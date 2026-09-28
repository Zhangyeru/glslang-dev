#!/usr/bin/env python3
# Copyright (C) 2026 The Khronos Group Inc.
# SPDX-License-Identifier: BSD-3-Clause

"""Generate legal GLSL, validate typed paths, and compare lowering to CPU oracles.

Retains source, stage diagnostics, inputs, outputs and coverage.json. Optional
seeded programs compose bounded, defined arithmetic with functions and CFG;
on failure their operation sequence is reduced while preserving all gates.
"""

import argparse
import json
import math
import pathlib
import random
import re
import struct
import subprocess

from build_shaders import has_hw_residue

MODES = {
    "default": "",
    "scalar": "=scalar",
    "generic": "=no-direct,no-fusion",
    "rolled": "=unroll-elements=2,unroll-macs=2",
    "scalar_rolled": "=scalar,unroll-elements=2,unroll-macs=2",
}
FORMATS = {
    "float": "f",
    "float16_t": "e",
    "double": "d",
    "int": "i",
    "uint": "I",
    "int16_t": "h",
    "uint16_t": "H",
    "int64_t": "q",
    "uint64_t": "Q",
}


def cast(value, dtype):
    fmt = FORMATS[dtype]
    if fmt not in "fed":
        bits = struct.calcsize(fmt) * 8
        value = int(value) % (1 << bits)
        if fmt.islower() and value >= 1 << (bits - 1):
            value -= 1 << bits
    return struct.unpack("<" + fmt, struct.pack("<" + fmt, value))[0]


def pack(values, dtype):
    return b"".join(struct.pack("<" + FORMATS[dtype], cast(x, dtype)) for x in values)


def typed_ops(assembly):
    definitions = {}
    rows = []
    for line in assembly.splitlines():
        match = re.match(r"\s*(%\S+) = (Op\w+)\s*(.*)", line)
        if match:
            ident, op, rest = match.groups()
            args = rest.split()
            definitions[ident] = (op, args)
            rows.append((op, args))
        else:
            match = re.match(r"\s*(OpCooperative\w+HW)\b", line)
            if match:
                rows.append((match[1], []))

    def contains(ident, seen=None):
        seen = set() if seen is None else seen
        if ident in seen:
            return False
        seen.add(ident)
        op, args = definitions.get(ident, ("", []))
        if op in ("OpTypeCooperativeVectorHW", "OpTypeCooperativeMatrixHW"):
            return True
        if op in ("OpTypePointer",):
            return contains(args[1], seen)
        if op in ("OpTypeArray", "OpTypeRuntimeArray"):
            return contains(args[0], seen)
        if op in ("OpTypeStruct", "OpTypeFunction"):
            return any(contains(x, seen.copy()) for x in args)
        return False

    ops = set()
    for op, args in rows:
        pointer_operand = op in ("OpAccessChain", "OpInBoundsAccessChain") and any(
            contains(definitions.get(x, ("", []))[1][0]) for x in args[1:] if definitions.get(x, ("", []))[1]
        )
        if op.startswith("OpCooperative") or (args and contains(args[0])) or pointer_operand:
            ops.add(args[2] if op == "OpExtInst" else op)
    return ops


def cases():
    result = []

    def add(name, dtype, expression, opcode, oracle, **kwargs):
        result.append(dict(name=name, dtype=dtype, expression=expression, required=[opcode], oracle=oracle, **kwargs))

    for name, expr, op, fn in [
        ("add", "x+y", "FAdd", lambda x, y: x + y),
        ("sub", "x-y", "FSub", lambda x, y: x - y),
        ("mul", "x*y", "FMul", lambda x, y: x * y),
        ("div", "x/y", "FDiv", lambda x, y: x / y),
        ("neg", "-x", "FNegate", lambda x, y: -x),
    ]:
        for dtype in ("float", "float16_t"):
            add(name + "_" + dtype, dtype, expr, "Op" + op, fn, approximate=name == "div")
    ext = [
        ("atan", "atan(x)", "Atan", lambda x, y: math.atan(x)),
        ("tanh", "tanh(x)", "Tanh", lambda x, y: math.tanh(x)),
        ("exp", "exp(x)", "Exp", lambda x, y: math.exp(x)),
        ("log", "log(x)", "Log", lambda x, y: math.log(x)),
        ("min", "min(x,y)", "FMin", min),
        ("max", "max(x,y)", "FMax", max),
        ("step", "step(y,x)", "Step", lambda x, y: float(x >= y)),
        ("clamp", "clamp(x,V(T(-1)),V(T(1)))", "FClamp", lambda x, y: min(max(x, -1), 1)),
        ("fma", "fma(x,y,V(T(1)))", "Fma", lambda x, y: x * y + 1),
        ("nmin", "min(x,y)", "NMin", min),
        ("nmax", "max(x,y)", "NMax", max),
        ("nclamp", "clamp(x,V(T(-1)),V(T(1)))", "NClamp", lambda x, y: min(max(x, -1), 1)),
    ]
    for name, expr, op, fn in ext:
        add(
            name,
            "float",
            expr,
            op,
            fn,
            nan_clamp=name.startswith("n"),
            positive=name == "log",
            approximate=name in ("atan", "tanh", "exp", "log"),
        )
        add(
            name + "_f16",
            "float16_t",
            expr,
            op,
            fn,
            nan_clamp=name.startswith("n"),
            positive=name == "log",
            approximate=name in ("atan", "tanh", "exp", "log"),
        )
    for dtype, prefix in (("int", "S"), ("uint", "U")):
        for name, expr, op, fn in [
            ("add", "x+y", "IAdd", lambda x, y: x + y),
            ("sub", "x-y", "ISub", lambda x, y: x - y),
            ("mul", "x*y", "IMul", lambda x, y: x * y),
            ("div", "x/y", prefix + "Div", lambda x, y: int(x / y)),
            ("shr", "x>>y", "ShiftRightArithmetic" if dtype == "int" else "ShiftRightLogical", lambda x, y: x >> y),
            ("shl", "x<<y", "ShiftLeftLogical", lambda x, y: x << y),
            ("or", "x|y", "BitwiseOr", lambda x, y: x | y),
            ("xor", "x^y", "BitwiseXor", lambda x, y: x ^ y),
            ("and", "x&y", "BitwiseAnd", lambda x, y: x & y),
            ("not", "~x", "Not", lambda x, y: ~x),
        ]:
            add(name + "_" + dtype, dtype, expr, "Op" + op, fn)
        if dtype == "int":
            add("neg_int", dtype, "-x", "OpSNegate", lambda x, y: -x)
        for name, expr, fn in [
            ("min", "min(x,y)", min),
            ("max", "max(x,y)", max),
            ("clamp", "clamp(x,V(T(1)),V(T(4)))", lambda x, y: min(max(x, 1), 4)),
        ]:
            add(name + "_" + dtype, dtype, expr, prefix + name.title(), fn)
    for src, dst, op in [
        ("float16_t", "float", "FConvert"),
        ("float", "float16_t", "FConvert"),
        ("int", "int16_t", "SConvert"),
        ("uint", "uint16_t", "UConvert"),
        ("int16_t", "int", "SConvert"),
        ("uint16_t", "uint", "UConvert"),
        ("float", "int", "ConvertFToS"),
        ("float", "uint", "ConvertFToU"),
        ("int", "float", "ConvertSToF"),
        ("uint", "float", "ConvertUToF"),
    ]:
        for matrix in (False, True):
            add(
                "convert_" + src + "_" + dst + ("_matrix" if matrix else ""),
                src,
                "R(x)",
                "Op" + op,
                lambda x, y, dst=dst: cast(x, dst),
                result=dst,
                matrix=matrix,
                positive=dst == "uint",
            )
    add(
        "bitcast",
        "float",
        "floatBitsToUint(x)",
        "OpBitcast",
        lambda x, y: struct.unpack("<I", struct.pack("<f", x))[0],
        result="uint",
    )
    for matrix in (False, True):
        add(
            "scale" + ("_matrix" if matrix else ""),
            "float",
            "x*T(2)",
            "OpMatrixTimesScalar" if matrix else "OpVectorTimesScalar",
            lambda x, y: x * 2,
            matrix=matrix,
        )
    for leaf, component in [
        ("float", "float16_t"),
        ("double", "float"),
        ("int64_t", "float"),
        ("uint64_t", "float"),
        ("int", "int16_t"),
    ]:
        add(
            "memory_" + leaf + "_" + component,
            component,
            "x",
            "OpCooperativeMatrixLoadHW",
            lambda x, y: x,
            matrix=True,
            leaf=leaf,
            out=leaf,
        )
    for name in ("workgroup_exchange", "descriptor_alias", "descriptor_overlap", "inbounds"):
        result.append(dict(name=name, dtype="float", context=name, required=["OpCooperativeVectorLoadHW"]))
    result[-1]["required"].append("OpInBoundsAccessChain")
    for name in ("ordinary_array_extract", "ordinary_nested_array_extract"):
        result.append(dict(name=name, dtype="float", context=name, required=["OpCooperativeVectorLoadHW", "OpFAdd"]))
    add("fragment_add", "float", "x+y", "OpFAdd", lambda x, y: x + y, graphics=True)
    add("multi_entry", "float", "x+y", "OpFAdd", lambda x, y: x + y, multi_entry=True)
    return result


def context_shader(kind, width):
    header = f"""#version 460
#extension GL_HW_neural_shader : require
#define WIDTH {width}
layout(local_size_x={4 if kind=='workgroup_exchange' else 1}) in;
layout(set=0,binding=0) coherent buffer AA {{ float data[]; }} A;
layout(set=0,binding=1) coherent buffer BB {{ float data[]; }} B;
layout(set=0,binding=2) buffer DD {{ float data[]; }} D;
"""
    if kind in ("ordinary_array_extract", "ordinary_nested_array_extract"):
        # WIDTH=4 lowers to vec2[2], which can reuse this ordinary array type.
        # Keep both array elements and vector components distinct in the oracle.
        nested = kind == "ordinary_nested_array_extract"
        aggregate = (
            """struct Packet { float tag; vec2 values[2]; };
Packet makeArray() {
    return Packet(B.data[0], vec2[2](vec2(B.data[1], B.data[2]), vec2(B.data[3], B.data[4])));
}
"""
            if nested
            else """vec2[2] makeArray() {
    return vec2[2](vec2(B.data[1], B.data[2]), vec2(B.data[3], B.data[4]));
}
"""
        )
        return (
            header
            + aggregate
            + f"""void main() {{
    vec2 selected=makeArray(){'.values' if nested else ''}[1];
    coopvecHW<float,WIDTH> x;
    coopVecLoadHW(x,A.data,1u);
    x=x*selected.x+coopvecHW<float,WIDTH>(selected.y);
    coopVecStoreHW(x,D.data,1u);
}}
"""
        )
    if kind == "workgroup_exchange":
        return (
            header
            + """shared float backing[4*WIDTH];
void main() {
    uint lane=gl_LocalInvocationIndex;
    for(uint i=0;i<WIDTH;++i) backing[lane*WIDTH+i]=A.data[1+lane*WIDTH+i];
    barrier();
    coopvecHW<float,WIDTH> x;
    coopVecLoadHW(x,backing,((lane+1u)%4u)*WIDTH);
    barrier();
    x=x+coopvecHW<float,WIDTH>(float(lane));
    coopVecStoreHW(x,backing,lane*WIDTH);
    barrier();
    for(uint i=0;i<WIDTH;++i) D.data[1+lane*WIDTH+i]=backing[lane*WIDTH+i];
}
"""
        )
    if kind == "inbounds":
        return (
            header.replace(
                "#define WIDTH",
                """#extension GL_EXT_spirv_intrinsics : require
#extension GL_EXT_shader_explicit_arithmetic_types : require
#define WIDTH""",
            )
            + """// This is a source-level SPIR-V intrinsic, with a statically in-range index.
#define P spirv_type(id=32,7,float32_t)
spirv_instruction(id=66) P lane(spirv_by_reference highp coopvecHW<float,WIDTH> v, uint i);
spirv_instruction(id=62) void writeLane(P p, float value);
void main() {
    coopvecHW<float,WIDTH> x;
    coopVecLoadHW(x,A.data,1u);
    writeLane(lane(x,uint(WIDTH-1)),19.0);
    coopVecStoreHW(x,D.data,1u);
}
"""
        )
    offset = 65 if kind == "descriptor_overlap" else 1
    # Volatile makes each alias read observable. The coherent-only scalar GLSL
    # baseline also reused the earlier value on the local driver; retain that
    # distinction rather than labeling a common backend result a lowering bug.
    return (
        header.replace("coherent buffer", "volatile coherent buffer")
        + f"""void main() {{
    coopvecHW<float,WIDTH> before,after;
    coopVecLoadHW(before,A.data,{offset}u);
    B.data[1]=19.0;
    memoryBarrierBuffer();
    coopVecLoadHW(after,A.data,{offset}u);
    coopVecStoreHW(before+after,D.data,1u);
}}
"""
    )


def shader(case, width):
    if case.get("context"):
        return context_shader(case["context"], width)
    if case.get("fuzz") is not None:
        base = context_shader("descriptor_alias", width).split("void main()")[0]
        statements = "\n".join(
            {
                "add": "x=x+V(0.5);",
                "sub": "x=x-V(0.25);",
                "scale": "x=x*0.5;",
                "neg": "x=-x;",
                "clamp": "x=clamp(x,V(-4.0),V(4.0));",
            }[op]
            for op in case["fuzz"]
        )
        return (
            base
            + f"""#define V coopvecHW<float,WIDTH>
struct Packet {{ V value; }};
Packet transform(Packet p) {{ V x=p.value; {statements} p.value=x; return p; }}
void main() {{
    Packet p; coopVecLoadHW(p.value,A.data,1u);
    for(uint iteration=0;iteration<uint(B.data[0]);++iteration) {{
        if(((iteration+{case['seed']}u)&1u)==0u) p=transform(p);
        else p.value=-p.value;
    }}
    coopVecStoreHW(p.value,D.data,1u);
}}
"""
        )
    t = case["dtype"]
    r = case.get("result", t)
    leaf = case.get("leaf", t)
    out = case.get("out", r)
    matrix = case.get("matrix", False)
    v = f"coopmatHW<{t}, 1, {width}>" if matrix else f"coopvecHW<{t}, {width}>"
    ret = f"coopmatHW<{r}, 1, {width}>" if matrix else f"coopvecHW<{r}, {width}>"
    load = (
        (
            f"coopMatLoadHW(x,A.data,ivec2(1,{width+2}),ivec2(0,1),0); "
            f"coopMatLoadHW(y,B.data,ivec2(1,{width+2}),ivec2(0,1),0);"
        )
        if matrix
        else ("coopVecLoadHW(x,A.data,1u); coopVecLoadHW(y,B.data,1u);")
    )
    store = f"coopMatStoreHW(z,D.data,ivec2(1,{width+2}),ivec2(0,1),0);" if matrix else "coopVecStoreHW(z,D.data,1u);"
    return f"""#version 460
#extension GL_HW_neural_shader : require
#extension GL_EXT_shader_explicit_arithmetic_types : require
#extension GL_EXT_shader_16bit_storage : require
#define T {t}
#define V {v}
#define R {ret}
layout(local_size_x=1) in;
layout(set=0,binding=0) buffer AA {{ {leaf} data[]; }} A;
layout(set=0,binding=1) buffer BB {{ {leaf} data[]; }} B;
layout(set=0,binding=2) buffer DD {{ {out} data[]; }} D;
void main() {{ V x,y; {load} R z={case['expression']}; {store} }}
"""


def run(command, log):
    command = list(map(str, command))
    record = {"command": command}
    log.append(record)
    try:
        p = subprocess.run(command, text=True, capture_output=True, timeout=180)
    except subprocess.TimeoutExpired:
        record["error"] = "timeout"
        raise
    record.update(returncode=p.returncode, stdout=p.stdout, stderr=p.stderr)
    if p.returncode:
        raise RuntimeError(f"command failed: {command}\n{p.stdout}\n{p.stderr}")
    return p.stdout


def feature_names(case):
    types = {case["dtype"], case.get("result"), case.get("leaf"), case.get("out")}
    return (
        ",".join(
            x
            for t, x in [
                ("float16_t", "f16,s16"),
                ("int16_t", "i16,s16"),
                ("uint16_t", "i16,s16"),
                ("double", "f64"),
                ("int64_t", "i64"),
                ("uint64_t", "i64"),
            ]
            if t in types
        )
        or "none"
    )


def check_bytes(actual, expected, dtype, approximate=False):
    if actual == expected:
        return
    fmt = FORMATS[dtype]
    size = struct.calcsize(fmt)
    if len(actual) != len(expected):
        raise AssertionError("output size mismatch")
    for i in range(len(actual) // size):
        a = actual[i * size : (i + 1) * size]
        e = expected[i * size : (i + 1) * size]
        if a == e:
            continue
        av = struct.unpack("<" + fmt, a)[0]
        ev = struct.unpack("<" + fmt, e)[0]
        if (
            approximate
            and i not in (0, len(actual) // size - 1)
            and math.isclose(av, ev, rel_tol=2e-3 if fmt == "e" else 3e-5, abs_tol=1e-3 if fmt == "e" else 3e-6)
        ):
            continue
        raise AssertionError(f"lane {i}: expected {ev}, actual {av}")


def execute_case(args, case, width, folder):
    folder.mkdir(parents=True, exist_ok=True)
    log = []
    record = {"case": case["name"], "width": width, "stage": "compile", "modes": {}}
    if case.get("fuzz") is not None:
        record.update(seed=case["seed"], operations=case["fuzz"])
    try:
        source = folder / ("input.frag" if case.get("graphics") else "input.comp")
        source_text = shader(case, width)
        if case.get("graphics"):
            source_text = source_text.replace("layout(local_size_x=1) in;", "")
        source.write_text(source_text)
        inp = folder / "input.spv"
        run(
            [
                args.glslang,
                "--target-env",
                "vulkan1.3",
                "-V",
                *(["--nan-clamp"] if case.get("nan_clamp") else []),
                source,
                "-o",
                inp,
            ],
            log,
        )
        record["stage"] = "input-validation"
        run([args.spirv_val, "--target-env", "vulkan1.3", inp], log)
        vertex = None
        if case.get("graphics"):
            vert = folder / "fullscreen.vert"
            vertex = folder / "fullscreen.spv"
            vert.write_text(
                "#version 460\nvoid main(){vec2 p=vec2((gl_VertexIndex<<1)&2,gl_VertexIndex&2);"
                "gl_Position=vec4(p*2.0-1.0,0.0,1.0);}\n"
            )
            run([args.glslang, "--target-env", "vulkan1.3", "-V", vert, "-o", vertex], log)
            run([args.spirv_val, "--target-env", "vulkan1.3", vertex], log)
        if case.get("multi_entry"):
            entries = []
            for entry in ("first", "second"):
                binary = folder / (entry + ".spv")
                entry_source = folder / (entry + ".comp")
                entry_source.write_text(source_text.replace("R z=x+y", "R z=x-y") if entry == "second" else source_text)
                run(
                    [
                        args.glslang,
                        "--target-env",
                        "vulkan1.3",
                        "-V",
                        "--source-entrypoint",
                        "main",
                        "-e",
                        entry,
                        entry_source,
                        "-o",
                        binary,
                    ],
                    log,
                )
                run([args.spirv_val, "--target-env", "vulkan1.3", binary], log)
                entries.append(binary)
            run([args.spirv_link, "--target-env", "vulkan1.3", *entries, "-o", inp], log)
            run([args.spirv_val, "--target-env", "vulkan1.3", inp], log)
        asm = folder / "input.spvasm"
        run([args.spirv_dis, inp, "-o", asm], log)
        record["stage"] = "typed-input"
        ops = typed_ops(asm.read_text())
        record["typed_operations"] = sorted(ops)
        if not set(case["required"]) <= ops:
            raise AssertionError(f"missing typed operations {set(case['required'])-ops}")
        dtype = case["dtype"]
        leaf = case.get("leaf", dtype)
        out = case.get("out", case.get("result", dtype))
        datasets = []
        for dataset in range(3):
            if case.get("fuzz") is not None:
                values = [(i + dataset - 2) * 0.25 for i in range(width)]
                expected = values.copy()
                for iteration in range(dataset + 1):
                    if (iteration + case["seed"]) & 1:
                        expected = [-x for x in expected]
                    else:
                        for op in case["fuzz"]:
                            expected = [
                                cast(
                                    {
                                        "add": lambda: x + 0.5,
                                        "sub": lambda: x - 0.25,
                                        "scale": lambda: x * 0.5,
                                        "neg": lambda: -x,
                                        "clamp": lambda: min(max(x, -4), 4),
                                    }[op](),
                                    "float",
                                )
                                for x in expected
                            ]
                a = pack([17] + values + [19], "float")
                b = pack([dataset + 1] + [0] * (width + 1), "float")
                initial = pack([31] * (width + 2), "float")
                expected = pack([31] + expected + [31], "float")
                datasets.append((a, b, initial, expected, a))
                continue
            if case.get("context"):
                kind = case["context"]
                if kind in ("ordinary_array_extract", "ordinary_nested_array_extract"):
                    av = [17] + [(i - dataset - 2) * 0.25 for i in range(width)] + [19]
                    bv = [23, -3 * (dataset + 1), 5 * (dataset + 2), 2.5 * (dataset + 1), -7 - dataset]
                    bv += [29] * (width + 2 - len(bv))
                    expected = [x * bv[3] + bv[4] for x in av[1:-1]]
                    modified = pack(av, "float")
                elif kind == "inbounds":
                    av = [17] + [(i + dataset) * 0.25 for i in range(width)] + [19]
                    expected = av[1:-1]
                    expected[-1] = 19
                    bv = [0] * (width + 2)
                    modified = pack(av, "float")
                elif kind == "workgroup_exchange":
                    av = [17] + [(i + dataset) * 0.25 for i in range(4 * width)] + [19]
                    expected = [av[1 + ((lane + 1) % 4) * width + i] + lane for lane in range(4) for i in range(width)]
                    bv = [0] * (width + 2)
                    modified = pack(av, "float")
                else:
                    av = [(i + dataset) * 0.25 for i in range(1024)]
                    offset = 65 if kind == "descriptor_overlap" else 1
                    expected = [2 * av[offset + i] for i in range(width)]
                    expected[0] = av[offset] + 19
                    bv = [0] * (width + 2)
                    updated = av.copy()
                    updated[offset] = 19
                    modified = pack(updated, "float")
                a = pack(av, "float")
                b = pack(bv, "float")
                initial = pack([31] * (len(expected) + 2), "float")
                expected = pack([31] + expected + [31], "float")
                datasets.append((a, b, initial, expected, modified))
                continue
            values = [((i + dataset) % 9 - 4) * 0.5 for i in range(width)]
            if FORMATS[leaf] not in "fed":
                values = [(i + dataset) % 9 - 4 for i in range(width)]
            if (
                case.get("positive")
                or FORMATS[dtype] in "HIQ"
                or FORMATS[leaf] in "HIQ"
                or case["name"].startswith("shl")
            ):
                values = [abs(x) + 1 for x in values]
            ys = [1 + (i + dataset) % 3 for i in range(width)]
            av = [cast(x, leaf) for x in values]
            bv = [cast(x, leaf) for x in ys]
            expected = [case["oracle"](cast(x, dtype), cast(y, dtype)) for x, y in zip(av, bv)]
            expected = [cast(x, case.get("result", dtype)) for x in expected]
            a = pack([17] + av + [19], leaf)
            b = pack([23] + bv + [29], leaf)
            initial = pack([31] * (width + 2), out)
            expected = pack([31] + expected + [31], out)
            datasets.append((a, b, initial, expected, a))
        for mode, options in MODES.items():
            record["stage"] = mode + ":lower"
            lowered = folder / (mode + ".spv")
            run(
                [
                    args.spirv_opt,
                    "--target-env=vulkan1.3",
                    "--hw-lower-to-standard-extension-free" + options,
                    inp,
                    "-o",
                    lowered,
                ],
                log,
            )
            record["stage"] = mode + ":validate"
            run([args.spirv_val, "--target-env", "vulkan1.3", lowered], log)
            output_asm = lowered.with_suffix(".spvasm")
            run([args.spirv_dis, lowered, "-o", output_asm], log)
            if has_hw_residue(output_asm.read_text()):
                raise AssertionError("HW residue")
            record["stage"] = mode + ":execute"
            results = []
            for dataset, (a, b, initial, expected, modified_a) in enumerate(datasets):
                prefix = folder / (mode + "_" + str(dataset))
                paths = [pathlib.Path(str(prefix) + suffix) for suffix in (".a", ".b", ".initial", ".actual")]
                for p, data in zip(paths, (a, b, initial)):
                    p.write_bytes(data)
                pathlib.Path(str(prefix) + ".expected").write_bytes(expected)
                alias = {"descriptor_alias": "alias", "descriptor_overlap": "overlap"}.get(
                    case.get("context"), "separate"
                )
                features = "graphics:" + str(vertex) if vertex else feature_names(case)
                for entry in ("first", "second") if case.get("multi_entry") else ("main",):
                    actual = pathlib.Path(str(paths[3]) + "." + entry)
                    entry_expected = expected
                    if entry == "second":
                        xs = [x[0] for x in struct.iter_unpack("<f", a)][1:-1]
                        ys = [x[0] for x in struct.iter_unpack("<f", b)][1:-1]
                        entry_expected = pack([31] + [x - y for x, y in zip(xs, ys)] + [31], "float")
                    pathlib.Path(str(prefix) + ".expected." + entry).write_bytes(entry_expected)
                    response = json.loads(
                        run([args.runner, "--execute", lowered, *paths[:3], actual, alias, entry, features], log)
                    )
                    if response["status"] == "skip":
                        if not response.get("skip_reason"):
                            raise AssertionError("runtime skip without a queried feature reason")
                        results.append(response)
                        break
                    if response["status"] != "pass":
                        raise AssertionError(f"runtime did not execute successfully: {response}")
                    check_bytes(actual.read_bytes(), entry_expected, out, case.get("approximate", False))
                    if pathlib.Path(str(actual) + ".a").read_bytes() != modified_a:
                        raise AssertionError("unexpected input A writes")
                    if pathlib.Path(str(actual) + ".b").read_bytes() != b:
                        raise AssertionError("input B was modified")
                    results.append({"status": "pass", "dataset": dataset, "entry": entry})
            record["modes"][mode] = results
        record["stage"] = (
            "skip" if any(r["status"] == "skip" for results in record["modes"].values() for r in results) else "pass"
        )
        return record
    finally:
        (folder / "commands.json").write_text(json.dumps(log, indent=2) + "\n")
        (folder / "result.json").write_text(json.dumps(record, indent=2) + "\n")


def minimize_failure(args, case, width, folder, stage):
    """Delete source operations only when the same gated stage still fails."""
    best = dict(case)
    trials = []
    index = 0
    while index < len(best["fuzz"]):
        candidate = dict(best)
        candidate["fuzz"] = best["fuzz"][:index] + best["fuzz"][index + 1 :]
        trial = folder / ("trial_" + str(len(trials)))
        try:
            execute_case(args, candidate, width, trial)
            failed_stage = None
        except (RuntimeError, AssertionError, subprocess.TimeoutExpired):
            failed_stage = json.loads((trial / "result.json").read_text())["stage"]
        trials.append({"operations": candidate["fuzz"], "failed_stage": failed_stage})
        if failed_stage == stage and stage not in ("compile", "input-validation", "typed-input"):
            best = candidate
        else:
            index += 1
    (folder / "minimized.comp").write_text(shader(best, width))
    (folder / "reduction.json").write_text(
        json.dumps({"seed": case["seed"], "stage": stage, "trials": trials}, indent=2) + "\n"
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("glslang", "spirv-opt", "spirv-val", "spirv-dis", "spirv-link", "runner", "out-dir"):
        parser.add_argument("--" + name, required=True)
    parser.add_argument("--case", action="append")
    parser.add_argument("--fuzz-seeds", type=int, default=12)
    args = parser.parse_args()
    if args.fuzz_seeds < 0:
        parser.error("--fuzz-seeds must not be negative")
    out = pathlib.Path(args.out_dir)
    out.mkdir(parents=True, exist_ok=True)
    candidates = cases()
    for seed in range(args.fuzz_seeds):
        rng = random.Random(seed)
        candidates.append(
            dict(
                name="fuzz_" + str(seed),
                dtype="float",
                seed=seed,
                fuzz=[rng.choice(("add", "sub", "scale", "neg", "clamp")) for _ in range(4 + seed % 5)],
                required=["OpCooperativeVectorLoadHW"],
            )
        )
    if args.case and set(args.case) - {c["name"] for c in candidates}:
        parser.error("unknown cases: " + ", ".join(sorted(set(args.case) - {c["name"] for c in candidates})))
    selected = [c for c in candidates if not args.case or c["name"] in args.case]
    if not selected:
        raise ValueError("no cases selected")
    results = []
    try:
        for case in selected:
            for width in (4, 5):
                folder = out / (case["name"] + "_" + str(width))
                try:
                    results.append(execute_case(args, case, width, folder))
                except (RuntimeError, AssertionError, subprocess.TimeoutExpired):
                    record = json.loads((folder / "result.json").read_text())
                    results.append(record)
                    if case.get("fuzz") is not None:
                        minimize_failure(args, case, width, folder / "reduction", record["stage"])
                    raise
            print(
                case["name"] + ": " + ("skip" if any(r["stage"] == "skip" for r in results[-2:]) else "pass"),
                flush=True,
            )
    finally:
        (out / "coverage.json").write_text(json.dumps(results, indent=2) + "\n")


if __name__ == "__main__":
    main()
