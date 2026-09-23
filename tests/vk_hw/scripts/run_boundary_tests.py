#!/usr/bin/env python3
# Copyright (C) 2026 The Khronos Group Inc.
# SPDX-License-Identifier: BSD-3-Clause
"""Validated raw/production lowering and numerical/performance inference boundaries."""

import argparse
import json
import pathlib
import subprocess

from build_shaders import has_hw_residue, specialization_optimizer_args, SpecializationCase


def run(command, log):
    command = [str(arg) for arg in command]
    record = {"command": command}
    log.append(record)
    try:
        result = subprocess.run(command, text=True, capture_output=True, timeout=180)
    except subprocess.TimeoutExpired:
        record["error"] = "timeout after 180 seconds"
        raise
    record.update(returncode=result.returncode, stdout=result.stdout, stderr=result.stderr)
    if result.returncode:
        raise RuntimeError(f"command failed: {command}\n{result.stdout}\n{result.stderr}")
    return result.stdout


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("glslang", "spirv-opt", "spirv-val", "spirv-dis", "runner", "source", "baseline", "out-dir"):
        parser.add_argument("--" + name, required=True)
    parser.add_argument("--perf", action="store_true")
    parser.add_argument("--max-ratio", type=float, default=5.0)
    parser.add_argument("--case", action="append", help="run selected case IDs")
    args = parser.parse_args()
    if args.max_ratio <= 0:
        parser.error("--max-ratio must be positive")
    out = pathlib.Path(args.out_dir)
    out.mkdir(parents=True, exist_ok=True)
    cases = json.loads(run([args.runner, "--list-boundary-cases"], []))
    if args.case:
        missing = set(args.case) - {case["name"] for case in cases}
        if missing:
            parser.error(f"unknown cases: {sorted(missing)}")
        cases = [case for case in cases if case["name"] in args.case]
    results = []
    failures = []
    for case in cases:
        folder = out / case["name"]
        folder.mkdir(exist_ok=True)
        log = []
        record = {"case": case["name"], "stage": "compile", "modes": {}}
        results.append(record)
        try:
            if not args.perf:
                defines = ["-D" + define for define in case["defines"]]
                for source, stem in ((args.source, "input"), (args.baseline, "baseline")):
                    record["stage"] = f"{stem}:compile"
                    snapshot = folder / f"{stem}.comp"
                    snapshot.write_bytes(pathlib.Path(source).read_bytes())
                    binary = folder / f"{stem}.spv"
                    run([args.glslang, "--target-env", "vulkan1.3", "-V", *defines, snapshot, "-o", binary], log)
                    record["stage"] = f"{stem}-validation"
                    run([args.spirv_val, "--target-env", "vulkan1.3", binary], log)
                    run([args.spirv_dis, binary, "-o", folder / f"{stem}.spvasm"], log)
                variants = [(f"raw_{i}", mode, False) for i, mode in enumerate(case["modes"])]
                variants += [("production", "", True), ("production_scalar", "scalar", True)]
                for stem, mode, production in variants:
                    record["stage"] = f"{stem}:lower"
                    flag = "--hw-lower-to-standard-extension-free" + ("=" + mode if mode else "")
                    # Use the same specialization preparation and post-fold as build_shaders.py.
                    prefix = specialization_optimizer_args(SpecializationCase("boundary", ())) if production else []
                    suffix = ["--fold-spec-const-op-composite"] if production else []
                    binary = folder / f"{stem}.spv"
                    run([args.spirv_opt, "--target-env=vulkan1.3", *prefix, flag, *suffix,
                         folder / "input.spv", "-o", binary], log)
                    record["stage"] = f"{stem}:output-validation"
                    run([args.spirv_val, "--target-env", "vulkan1.3", binary], log)
                    assembly = binary.with_suffix(".spvasm")
                    run([args.spirv_dis, binary, "-o", assembly], log)
                    if has_hw_residue(assembly.read_text(encoding="utf-8")):
                        raise RuntimeError(f"HW residue in {assembly}")
                stems = ["baseline", *(variant[0] for variant in variants)]
            else:
                stems = ["baseline", "production", "production_scalar"]
            for stem in stems:
                record["stage"] = f"{stem}:execute"
                result = json.loads(run([args.runner, "--boundary-case", case["name"], "--shader",
                                         folder / f"{stem}.spv", "--warmup", 20 if args.perf else 0,
                                         "--repeat", 200 if args.perf else 1], log))
                record["modes"][stem] = result
                if result["status"] == "skip":
                    if not result.get("skip_reason"):
                        raise RuntimeError("skip without skip_reason")
                elif result["status"] != "pass" or result["verify"] != "pass":
                    raise RuntimeError(f"no numerical verification: {result}")
                elif result.get("verified_dispatches") != 3 * case["controls"]:
                    raise RuntimeError(f"incomplete dataset/control coverage: {result}")
            record["stage"] = "skip" if any(x["status"] == "skip" for x in record["modes"].values()) else "pass"
            if args.perf and record["stage"] == "pass":
                baseline_ns = record["modes"]["baseline"]["gpu_time_ns_avg"]
                if baseline_ns <= 0:
                    raise RuntimeError("non-positive baseline timestamp")
                slow = []
                for stem in ("production", "production_scalar"):
                    measured = record["modes"][stem]
                    measured["ratio"] = measured["gpu_time_ns_avg"] / baseline_ns
                    if measured["ratio"] > args.max_ratio:
                        slow.append(f"{stem} ratio {measured['ratio']:.3f} exceeds {args.max_ratio}")
                if slow:
                    raise RuntimeError("; ".join(slow))
            print(f"{case['name']}: {record['stage']}", flush=True)
        except (RuntimeError, subprocess.TimeoutExpired) as error:
            record["error"] = str(error)
            failures.append(case["name"])
            print(f"{case['name']}: FAIL at {record['stage']}: {error}", flush=True)
        finally:
            name = "perf_commands.json" if args.perf else "commands.json"
            (folder / name).write_text(json.dumps(log, indent=2) + "\n", encoding="utf-8")
            (out / ("perf.json" if args.perf else "results.json")).write_text(
                json.dumps(results, indent=2) + "\n", encoding="utf-8")
    if failures:
        raise SystemExit(f"failed boundary cases: {', '.join(failures)}")


if __name__ == "__main__":
    main()
