#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import argparse
import csv
import json
import pathlib
import subprocess
import sys

from run_function_tests import parse_case
from run_function_tests import select_shaders
from run_function_tests import shape_string


def run_shader(runner, shader, meta, warmup, repeat):
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
        "--c-dtype",
        meta["c_dtype"],
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


def baseline_for(lowered):
    stem = lowered.name[: -len(".lowered.spv")]
    return lowered.with_name(f"{stem}_baseline.spv")


def write_outputs(rows, out_json):
    out_json.parent.mkdir(parents=True, exist_ok=True)
    out_json.write_text(json.dumps(rows, indent=2) + "\n", encoding="utf-8")

    csv_path = out_json.with_suffix(".csv")
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "shader",
                "case",
                "dtype",
                "a_dtype",
                "b_dtype",
                "c_dtype",
                "accum_dtype",
                "axis",
                "reduce_op",
                "m",
                "n",
                "k",
                "layer_dims",
                "lowered_ns",
                "baseline_ns",
                "ratio",
                "gflops",
                "gops_avg",
                "status",
                "skip_reason",
                "verify",
                "baseline_verify",
            ],
        )
        writer.writeheader()
        for row in rows:
            writer.writerow(row)

    md_path = out_json.with_suffix(".md")
    lines = [
        "# HW Lowered Shader Vulkan Performance",
        "",
        "| Shader | Case | A | B | C/Bias | Accum | Axis | Operation | Shape | Lowered ns | Baseline ns | Ratio | GOPS | Status | Verify | Baseline Verify | Skip Reason |",
        "|---|---|---|---|---|---|---|---|---:|---:|---:|---:|---:|---|---|---|---|",
    ]
    def number(value, digits):
        return "" if value is None else f"{value:.{digits}f}"

    for row in rows:
        lines.append(
            f"| {row['shader']} | {row['case']} | {row['a_dtype']} | {row['b_dtype']} | "
            f"{row['c_dtype']} | {row['accum_dtype']} | {row.get('axis', '')} | "
            f"{row.get('reduce_op', '')} | {shape_string(row)} | {number(row['lowered_ns'], 3)} | "
            f"{number(row['baseline_ns'], 3)} | {number(row['ratio'], 4)} | {number(row['gops_avg'], 4)} | "
            f"{row['status']} | {row['verify']} | {row['baseline_verify']} | {row['skip_reason']} |"
        )
    md_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Run HW Vulkan performance tests")
    parser.add_argument("--runner", required=True)
    parser.add_argument("--spv-dir", required=True)
    parser.add_argument("--repeat", type=int, default=200)
    parser.add_argument("--warmup", type=int, default=20)
    parser.add_argument("--out", default="results/perf/perf.json")
    parser.add_argument("--include", action="append", default=[], help="fnmatch pattern for lowered SPIR-V names")
    parser.add_argument("--exclude", action="append", default=[], help="fnmatch pattern for lowered SPIR-V names")
    parser.add_argument("--max-work", type=int, default=0, help="skip cases with M*N*K above this value")
    args = parser.parse_args()

    rows = []
    for lowered in select_shaders(args.spv_dir, args.include, args.exclude, args.max_work):
        baseline = baseline_for(lowered)
        if not baseline.exists():
            raise RuntimeError(f"missing baseline SPIR-V for {lowered.name}: {baseline.name}")
        meta = parse_case(lowered)
        lowered_result = run_shader(args.runner, lowered, meta, args.warmup, args.repeat)
        baseline_result = run_shader(args.runner, baseline, meta, args.warmup, args.repeat)

        skipped = lowered_result.get("status") == "skip" or baseline_result.get("status") == "skip"
        lowered_ns = None if skipped else float(lowered_result["gpu_time_ns_avg"])
        baseline_ns = None if skipped else float(baseline_result["gpu_time_ns_avg"])
        skip_reasons = [
            result.get("skip_reason", "")
            for result in (lowered_result, baseline_result)
            if result.get("status") == "skip"
        ]
        rows.append(
            {
                "shader": lowered.name,
                "case": lowered_result["case"],
                "dtype": lowered_result["dtype"],
                "a_dtype": lowered_result["a_dtype"],
                "b_dtype": lowered_result["b_dtype"],
                "c_dtype": lowered_result["c_dtype"],
                "accum_dtype": lowered_result["accum_dtype"],
                "axis": lowered_result.get("axis", ""),
                "reduce_op": lowered_result.get("reduce_op", ""),
                "m": lowered_result["m"],
                "n": lowered_result["n"],
                "k": lowered_result["k"],
                "layer_dims": lowered_result.get("layer_dims", []),
                "lowered_ns": lowered_ns,
                "baseline_ns": baseline_ns,
                "ratio": lowered_ns / baseline_ns if baseline_ns and baseline_ns > 0 else None,
                "gflops": None if skipped else float(lowered_result["gflops_avg"]),
                "gops_avg": None if skipped else float(lowered_result["gops_avg"]),
                "status": "skip" if skipped else lowered_result.get("status", "pass"),
                "skip_reason": "; ".join(dict.fromkeys(skip_reasons)),
                "verify": lowered_result["verify"],
                "baseline_verify": baseline_result["verify"],
            }
        )

    if not rows:
        raise RuntimeError(f"no lowered shaders found in {args.spv_dir}")
    write_outputs(rows, pathlib.Path(args.out))
    return 0 if all(
        row["status"] == "skip" or (row["verify"] == "pass" and row["baseline_verify"] == "pass")
        for row in rows
    ) else 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as exc:
        print(exc, file=sys.stderr)
        sys.exit(1)
