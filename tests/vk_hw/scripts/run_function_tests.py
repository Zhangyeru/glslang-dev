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


def parse_case(path):
    name = path.name
    if name.endswith(".lowered.spv"):
        stem = name[: -len(".lowered.spv")]
    else:
        stem = path.stem

    suffix = r"(?:_(?:scalar|ssbo_direct|ubo|constbias|constw|constx))?"

    m = re.match(rf"multiops_(f16|f32){suffix}_(\d+)x(\d+)x(\d+)$", stem)
    if m:
        dtype, rows, cols, inner = m.groups()
        return {"case": "multiops", "dtype": dtype, "m": rows, "n": cols, "k": inner}

    m = re.match(rf"matmul_(f16|f32){suffix}_(\d+)x(\d+)x(\d+)$", stem)
    if m:
        dtype, rows, cols, inner = m.groups()
        return {"case": "matmul", "dtype": dtype, "m": rows, "n": cols, "k": inner}

    m = re.match(rf"(vecmatmuladd|vecmatmul)_(f16|f32){suffix}_(\d+)x(\d+)$", stem)
    if m:
        case, dtype, inner, cols = m.groups()
        return {"case": case, "dtype": dtype, "m": "1", "n": cols, "k": inner}

    m = re.match(r"mlp_(f16|f32)_(\d+)x(\d+)_(\d+)x(\d+)_(\d+)x(\d+)$", stem)
    if m:
        dtype, d0, d1, d1_check, d2, d2_check, d3 = m.groups()
        if d1 != d1_check or d2 != d2_check:
            raise ValueError(f"inconsistent mlp dimensions in {path}")
        return {
            "case": "mlp",
            "dtype": dtype,
            "m": "1",
            "n": d3,
            "k": "0",
            "d0": d0,
            "d1": d1,
            "d2": d2,
            "d3": d3,
        }

    m = re.match(r"load_store_(f16|f32)(?:_scalar)?(?:_(\d+)x(\d+))?$", stem)
    if m:
        dtype, rows, cols = m.groups()
        return {"case": "load_store", "dtype": dtype, "m": rows or "8", "n": cols or "8", "k": "0"}

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
    for dim in ("d0", "d1", "d2", "d3"):
        if dim in meta:
            cmd.extend([f"--{dim}", meta[dim]])
    proc = subprocess.run(cmd, check=True, text=True, capture_output=True)
    return json.loads(proc.stdout)


def case_work(meta):
    if meta["case"] == "mlp":
        return int(meta["d0"]) * int(meta["d1"]) + int(meta["d1"]) * int(meta["d2"]) + int(meta["d2"]) * int(meta["d3"])
    m = int(meta["m"])
    n = int(meta["n"])
    k = int(meta["k"])
    if meta["case"] == "load_store":
        return m * n
    return m * n * k


def shape_string(result):
    dims = result.get("layer_dims")
    if isinstance(dims, list) and len(dims) == 4:
        return f"{dims[0]}x{dims[1]}, {dims[1]}x{dims[2]}, {dims[2]}x{dims[3]}"
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
        "| Shader | Case | DType | Shape | Verify | Max Abs Error | Max Rel Error |",
        "|---|---|---|---:|---|---:|---:|",
    ]
    for result in results:
        lines.append(
            f"| {pathlib.Path(result['shader']).name} | {result['case']} | {result['dtype']} | "
            f"{shape_string(result)} | {result['verify']} | {result['max_abs_error']:.8g} | {result['max_rel_error']:.8g} |"
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

    failed = [r for r in results if r.get("verify") != "pass"]
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
