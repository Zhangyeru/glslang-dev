#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import argparse
import fnmatch
import json
import pathlib
import re
import subprocess
import sys

DTYPE_RE = r"(?:f16|f32|i8|u8|i16|u16|i32|u32)"


def typed_meta(case, dtype, **kwargs):
    return {
        "case": case,
        "dtype": dtype,
        "a_dtype": dtype,
        "b_dtype": dtype,
        "accum_dtype": dtype,
        **kwargs,
    }


def parse_case(path):
    name = path.name
    if name.endswith(".lowered.spv"):
        stem = name[: -len(".lowered.spv")]
    else:
        stem = path.stem

    suffix = r"(?:_(?:scalar|ssbo_direct|ubo|constbias|constw|constx|convert|arith))?"

    m = re.match(
        rf"reduce_(row|column)_(add|min|max)_({DTYPE_RE})(?:_(scalar))?_(\d+)x(\d+)$",
        stem,
    )
    if m:
        axis, reduce_op, dtype, scalar, rows, cols = m.groups()
        result = typed_meta(
            "reduce",
            dtype,
            axis=axis,
            reduce_op=reduce_op,
            m=rows,
            n=cols,
            k="0",
        )
        if scalar:
            result["scalar"] = True
        return result

    m = re.match(rf"multiops_({DTYPE_RE}){suffix}_(\d+)x(\d+)x(\d+)$", stem)
    if m:
        dtype, rows, cols, inner = m.groups()
        return typed_meta("multiops", dtype, m=rows, n=cols, k=inner)

    m = re.match(
        rf"matmul_({DTYPE_RE})x({DTYPE_RE})_to_({DTYPE_RE}){suffix}_(\d+)x(\d+)x(\d+)$",
        stem,
    )
    if m:
        a_dtype, b_dtype, accum_dtype, rows, cols, inner = m.groups()
        return {
            "case": "matmul",
            "dtype": accum_dtype,
            "a_dtype": a_dtype,
            "b_dtype": b_dtype,
            "accum_dtype": accum_dtype,
            "m": rows,
            "n": cols,
            "k": inner,
        }

    m = re.match(rf"matmul_({DTYPE_RE}){suffix}_(\d+)x(\d+)x(\d+)$", stem)
    if m:
        dtype, rows, cols, inner = m.groups()
        return typed_meta("matmul", dtype, m=rows, n=cols, k=inner)

    m = re.match(
        rf"(vecmatmuladd|vecmatmul)_({DTYPE_RE})x({DTYPE_RE})_to_({DTYPE_RE}){suffix}_(\d+)x(\d+)$",
        stem,
    )
    if m:
        case, a_dtype, b_dtype, accum_dtype, inner, cols = m.groups()
        return {
            "case": case,
            "dtype": accum_dtype,
            "a_dtype": a_dtype,
            "b_dtype": b_dtype,
            "accum_dtype": accum_dtype,
            "m": "1",
            "n": cols,
            "k": inner,
        }

    m = re.match(rf"(vecmatmuladd|vecmatmul)_({DTYPE_RE}){suffix}_(\d+)x(\d+)$", stem)
    if m:
        case, dtype, inner, cols = m.groups()
        return typed_meta(case, dtype, m="1", n=cols, k=inner)

    m = re.match(rf"mlp_({DTYPE_RE})_(\d+x\d+(?:_\d+x\d+)*)$", stem)
    if m:
        dtype, encoded_layers = m.groups()
        layers = [layer.split("x") for layer in encoded_layers.split("_")]
        layer_dims = [layers[0][0]]
        for input_dim, output_dim in layers:
            if layer_dims[-1] != input_dim:
                raise ValueError(f"inconsistent mlp dimensions in {path}")
            layer_dims.append(output_dim)
        if any(int(dim) == 0 for dim in layer_dims):
            raise ValueError(f"mlp dimensions must be non-zero in {path}")
        return typed_meta("mlp", dtype, m="1", n=layer_dims[-1], k="0", layer_dims=layer_dims)

    m = re.match(rf"load_store_({DTYPE_RE})(?:_(?:scalar|convert|arith|flow))?(?:_(\d+)x(\d+))?$", stem)
    if m:
        dtype, rows, cols = m.groups()
        return typed_meta("load_store", dtype, m=rows or "8", n=cols or "8", k="0")

    raise ValueError(f"cannot parse case from {path}")


def run_case(runner, shader, warmup, repeat):
    meta = parse_case(shader)
    cmd = [
        runner,
        "--shader",
        str(shader),
        "--case",
        meta["case"],
        "--dtype",
        meta["dtype"],
        "--a-dtype",
        meta["a_dtype"],
        "--b-dtype",
        meta["b_dtype"],
        "--accum-dtype",
        meta["accum_dtype"],
        "--m",
        meta["m"],
        "--n",
        meta["n"],
        "--k",
        meta["k"],
        "--warmup",
        str(warmup),
        "--repeat",
        str(repeat),
        "--verify",
        "1",
    ]
    if "layer_dims" in meta:
        cmd.extend(["--layer-dims", ",".join(str(dim) for dim in meta["layer_dims"])])
    if meta["case"] == "reduce":
        cmd.extend(["--axis", meta["axis"], "--reduce-op", meta["reduce_op"]])
    proc = subprocess.run(cmd, check=True, text=True, capture_output=True)
    return json.loads(proc.stdout)


def case_work(meta):
    if meta["case"] == "mlp":
        dims = [int(dim) for dim in meta["layer_dims"]]
        return sum(input_dim * output_dim for input_dim, output_dim in zip(dims, dims[1:]))
    m = int(meta["m"])
    n = int(meta["n"])
    k = int(meta["k"])
    if meta["case"] == "load_store":
        return m * n
    if meta["case"] == "reduce":
        return m * n
    return m * n * k


def shape_string(result):
    dims = result.get("layer_dims")
    if isinstance(dims, list) and len(dims) >= 2:
        return ", ".join(f"{input_dim}x{output_dim}" for input_dim, output_dim in zip(dims, dims[1:]))
    if result.get("case") in ("load_store", "reduce"):
        return f"{result.get('m', 0)}x{result.get('n', 0)}"
    return f"{result.get('m', 0)}x{result.get('n', 0)}x{result.get('k', 0)}"


def select_shaders(spv_dir, include, exclude, max_work):
    shaders = sorted(pathlib.Path(spv_dir).glob("*.lowered.spv"))
    selected = []
    for shader in shaders:
        name = shader.name
        if include and not any(fnmatch.fnmatch(name, pattern) for pattern in include):
            continue
        if exclude and any(fnmatch.fnmatch(name, pattern) for pattern in exclude):
            continue
        meta = parse_case(shader)
        if max_work and case_work(meta) > max_work:
            continue
        selected.append(shader)
    return selected


def write_reports(results, out_dir):
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "functional.json").write_text(json.dumps(results, indent=2) + "\n", encoding="utf-8")

    lines = [
        "# HW Vulkan Functional Results",
        "",
        "| Shader | Case | A | B | Accum | Axis | Operation | Shape | Status | Verify | Max Abs Error | Max Rel Error | Skip Reason |",
        "|---|---|---|---|---|---|---|---:|---|---|---:|---:|---|",
    ]
    for result in results:
        lines.append(
            f"| {pathlib.Path(result['shader']).name} | {result['case']} | {result['a_dtype']} | "
            f"{result['b_dtype']} | {result['accum_dtype']} | "
            f"{result.get('axis', '')} | {result.get('reduce_op', '')} | "
            f"{shape_string(result)} | {result.get('status', 'pass')} | {result['verify']} | "
            f"{result['max_abs_error']:.8g} | {result['max_rel_error']:.8g} | {result.get('skip_reason', '')} |"
        )
    (out_dir / "functional.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Run HW Vulkan functional tests")
    parser.add_argument("--runner", required=True)
    parser.add_argument("--spv-dir", required=True)
    parser.add_argument("--out", default="results/functional")
    parser.add_argument("--warmup", type=int, default=1)
    parser.add_argument("--repeat", type=int, default=1)
    parser.add_argument("--include", action="append", default=[], help="fnmatch pattern for lowered SPIR-V names")
    parser.add_argument("--exclude", action="append", default=[], help="fnmatch pattern for lowered SPIR-V names")
    parser.add_argument("--max-work", type=int, default=0, help="skip cases with M*N*K above this value")
    args = parser.parse_args()

    shaders = select_shaders(args.spv_dir, args.include, args.exclude, args.max_work)
    if not shaders:
        raise RuntimeError(f"no lowered shaders found in {args.spv_dir}")

    results = [run_case(args.runner, shader, args.warmup, args.repeat) for shader in shaders]
    write_reports(results, pathlib.Path(args.out))

    failed = [r for r in results if r.get("status", "pass") != "skip" and r.get("verify") != "pass"]
    if failed:
        print(f"{len(failed)} functional cases failed", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as exc:
        print(exc, file=sys.stderr)
        sys.exit(1)
