#!/usr/bin/env python3
# Copyright (C) 2026 The Khronos Group Inc.
# SPDX-License-Identifier: BSD-3-Clause

"""Validate and execute substantial inference shaders against CPU and GLSL references.

Every mode starts from the same validated frontend module. Performance uses
Vulkan timestamp queries, and still verifies every dataset and output guard.
Artifacts, source sizes, instruction counts, diagnostics and all ratios remain
in the output directory. A skipped runtime never counts as numerical coverage.
"""

import argparse
import collections
import hashlib
import json
import math
import pathlib
import struct
import subprocess
import time

from build_shaders import has_hw_residue
from large_float_cases import cases as float_cases
from large_typed_cases import cases as typed_cases

MODES = {"default": "", "scalar": "=scalar", "generic": "=no-direct,no-fusion"}
ROOT = pathlib.Path(__file__).resolve().parents[3]


def digest(path):
    return hashlib.sha256(pathlib.Path(path).read_bytes()).hexdigest()


def save(path, value):
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(value, indent=2) + "\n", encoding="utf-8")
    temporary.replace(path)


def run(command, commands, stage, timeout):
    record = {"stage": stage, "command": list(map(str, command))}
    commands.append(record)
    start = time.monotonic()
    try:
        result = subprocess.run(record["command"], capture_output=True, text=True, timeout=timeout)
        record.update(returncode=result.returncode, stdout=result.stdout, stderr=result.stderr)
        if result.returncode:
            raise RuntimeError(f"{stage}: exit {result.returncode}: {result.stderr or result.stdout}")
        return result.stdout, result.stderr
    except subprocess.TimeoutExpired as error:
        record.update(error="timeout", timeout_seconds=timeout)
        raise RuntimeError(f"{stage}: exceeded {timeout} seconds") from error
    finally:
        record["wall_seconds"] = time.monotonic() - start


def spirv_stats(path, opnames):
    data = path.read_bytes()
    if len(data) < 20 or len(data) % 4:
        raise RuntimeError(f"invalid SPIR-V byte count: {path}")
    words = struct.unpack("<" + "I" * (len(data) // 4), data)
    if words[0] != 0x07230203:
        raise RuntimeError(f"invalid SPIR-V magic: {path}")
    counts = collections.Counter()
    offset = 5
    while offset < len(words):
        length, opcode = words[offset] >> 16, words[offset] & 0xFFFF
        if not length or offset + length > len(words):
            raise RuntimeError(f"invalid SPIR-V instruction at word {offset}: {path}")
        counts[opnames.get(opcode, str(opcode))] += 1
        offset += length
    return {
        "bytes": len(data),
        "instructions": sum(counts.values()),
        "id_bound": words[3],
        "functions": counts["OpFunction"],
        "blocks": counts["OpLabel"],
        "opcodes": dict(counts),
    }


def verify_bytes(actual, expected, initial, fmt, atol, rtol):
    if len(actual) != len(expected) or len(initial) != len(expected) or len(expected) % 4:
        raise AssertionError("output byte size differs from the reference")
    if expected[:4] != initial[:4] or expected[-4:] != initial[-4:]:
        raise AssertionError("reference overwrites a guard")
    errors = []
    for lane in range(len(expected) // 4):
        start = lane * 4
        a, e, sentinel = actual[start : start + 4], expected[start : start + 4], initial[start : start + 4]
        if a == e:
            continue
        av, ev = struct.unpack("<" + fmt, a)[0], struct.unpack("<" + fmt, e)[0]
        # Guard and untouched checkpoint storage is always checked exactly.
        if fmt == "f" and lane not in (0, len(expected) // 4 - 1) and e != sentinel:
            if math.isfinite(av) and math.isfinite(ev) and math.isclose(av, ev, abs_tol=atol, rel_tol=rtol):
                continue
        errors.append(f"lane {lane}: expected {ev}, actual {av}")
        if len(errors) == 8:
            break
    if errors:
        raise AssertionError("; ".join(errors))


def fingerprint(args, case, tool_hashes):
    return {
        "source": digest(args.source_dir / case["source"]),
        "baseline": digest(args.source_dir / case["baseline"]),
        "tools": tool_hashes,
        "target_env": "vulkan1.3",
        "modes": MODES,
    }


def compile_case(args, case, folder, commands, opnames, expected_fingerprint):
    hw = args.source_dir / case["source"]
    baseline = args.source_dir / case["baseline"]
    binaries = {"input": folder / "input.spv", "baseline": folder / "baseline.spv"}
    for name, source in (("input", hw), ("baseline", baseline)):
        (folder / (name + ".comp")).write_text(source.read_text(), encoding="utf-8")
        binaries[name].unlink(missing_ok=True)
        run([args.glslang, "-V", "--target-env", "vulkan1.3", source, "-o", binaries[name]],
            commands, name + ":compile", args.timeout)
        run([args.spirv_val, "--target-env", "vulkan1.3", binaries[name]],
            commands, name + ":validate", args.timeout)
        run([args.spirv_dis, binaries[name], "-o", folder / (name + ".spvasm")],
            commands, name + ":disassemble", args.timeout)
    stats = spirv_stats(binaries["input"], opnames)
    if stats["instructions"] < case["min_instructions"]:
        raise AssertionError(f"input has only {stats['instructions']} instructions; large-program witness was lost")
    for opcode, count in case["required_hw"].items():
        if stats["opcodes"].get(opcode, 0) < count:
            raise AssertionError(f"missing input witness {opcode}: expected at least {count}")
    baseline_stats = spirv_stats(binaries["baseline"], opnames)
    if has_hw_residue((folder / "baseline.spvasm").read_text()):
        raise AssertionError("ordinary GLSL baseline contains HW instructions")
    record = {
        "source_lines": len(hw.read_text().splitlines()),
        "source_bytes": hw.stat().st_size,
        "input": stats,
        "baseline": baseline_stats,
        "modes": {},
        "fingerprint": expected_fingerprint,
    }
    for mode, options in MODES.items():
        output = folder / (mode + ".spv")
        output.unlink(missing_ok=True)
        _, diagnostics = run([args.spirv_opt, "--target-env=vulkan1.3",
                              "--hw-lower-to-standard-extension-free" + options,
                              binaries["input"], "-o", output], commands, mode + ":lower", args.timeout)
        if "retrying scalar from the original" in diagnostics:
            raise AssertionError(f"{mode}: optimized lowering recovered unexpectedly: {diagnostics}")
        run([args.spirv_val, "--target-env", "vulkan1.3", output], commands, mode + ":validate", args.timeout)
        assembly = output.with_suffix(".spvasm")
        run([args.spirv_dis, output, "-o", assembly], commands, mode + ":disassemble", args.timeout)
        text = assembly.read_text()
        if has_hw_residue(text) or "ReplicateEXT" in text or "ReplicatedCompositesEXT" in text:
            raise AssertionError(f"{mode}: extension residue remains")
        record["modes"][mode] = spirv_stats(output, opnames)
    record["binary_sha256"] = {mode: digest(folder / (mode + ".spv")) for mode in ("baseline", *MODES)}
    save(folder / "build.json", record)
    return record


def execute(args, case, dataset, folder, commands, mode, number):
    prefix = folder / (("perf_" if args.perf else "run_") + mode + "_" + str(number))
    paths = {name: pathlib.Path(str(prefix) + "." + name) for name in ("a", "b", "initial", "actual", "expected")}
    for name in ("a", "b", "initial", "expected"):
        paths[name].write_bytes(dataset[name])
    command = [args.runner, "--execute-timed" if args.perf else "--execute", folder / (mode + ".spv"),
               paths["a"], paths["b"], paths["initial"], paths["actual"], "separate", "main", case["features"]]
    if args.perf:
        command.extend([args.warmup, args.repeat])
    output, _ = run(command, commands, mode + ":execute:" + dataset["label"], args.timeout)
    response = json.loads(output)
    if response["status"] == "skip":
        if not response.get("skip_reason"):
            raise AssertionError("missing-feature skip has no reason")
        return response
    if response["status"] != "pass":
        raise AssertionError(f"execution did not pass: {response}")
    verify_bytes(paths["actual"].read_bytes(), dataset["expected"], dataset["initial"], dataset["format"],
                 dataset.get("atol", 0.0), dataset.get("rtol", 0.0))
    for name in ("a", "b"):
        if pathlib.Path(str(paths["actual"]) + "." + name).read_bytes() != dataset[name]:
            raise AssertionError(f"readonly input {name} was modified")
    response["verify"] = "pass"
    if args.perf and (not math.isfinite(response["gpu_time_ns_avg"]) or response["gpu_time_ns_avg"] <= 0):
        raise AssertionError("non-positive or non-finite GPU timestamp duration")
    return response


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("glslang", "spirv-opt", "spirv-val", "spirv-dis", "runner"):
        parser.add_argument("--" + name, required=True)
    parser.add_argument("--source-dir", type=pathlib.Path, default=ROOT / "tests/vk_hw/shaders/large")
    parser.add_argument("--out-dir", type=pathlib.Path, required=True)
    parser.add_argument("--case", action="append")
    parser.add_argument("--perf", action="store_true")
    parser.add_argument("--warmup", type=int, default=20)
    parser.add_argument("--repeat", type=int, default=100)
    parser.add_argument("--max-ratio", type=float, default=5.0)
    parser.add_argument("--timeout", type=int, default=300)
    args = parser.parse_args()
    if (args.timeout <= 0 or not 0 <= args.warmup <= 10000 or not 1 <= args.repeat <= 10000
            or not math.isfinite(args.max_ratio) or args.max_ratio <= 0):
        parser.error("invalid timeout, timing counts or performance limit")
    all_cases = float_cases() + typed_cases()
    if len({c["name"] for c in all_cases}) != len(all_cases):
        parser.error("duplicate large case name")
    if args.case and set(args.case) - {c["name"] for c in all_cases}:
        parser.error("unknown large case")
    selected = [c for c in all_cases if not args.case or c["name"] in args.case]
    grammar = json.loads((ROOT / "External/spirv-tools/external/spirv-headers/include/spirv/unified1/spirv.core.grammar.json").read_text())
    opnames = {i["opcode"]: i["opname"] for i in grammar["instructions"]}
    tool_hashes = {name: digest(getattr(args, name)) for name in ("glslang", "spirv_opt", "spirv_val", "spirv_dis", "runner")}
    args.out_dir.mkdir(parents=True, exist_ok=True)
    records = []
    failures = []
    for case in selected:
        folder = args.out_dir / case["name"]
        folder.mkdir(parents=True, exist_ok=True)
        commands = []
        record = {"case": case["name"], "status": "running", "stage": "build", "macs": case["macs"],
                  "parameter_elements": case["parameter_elements"], "datasets": []}
        records.append(record)
        try:
            expected_fingerprint = fingerprint(args, case, tool_hashes)
            if args.perf:
                build = json.loads((folder / "build.json").read_text())
                if build["fingerprint"] != expected_fingerprint:
                    raise AssertionError("shader or tools changed; run the functional build before timing")
                for mode, sha in build["binary_sha256"].items():
                    if digest(folder / (mode + ".spv")) != sha:
                        raise AssertionError(f"{mode} binary changed since validation")
            else:
                build = compile_case(args, case, folder, commands, opnames, expected_fingerprint)
            record["build"] = build
            datasets = case["datasets"]()
            if not datasets or len({d["label"] for d in datasets}) != len(datasets):
                raise AssertionError("datasets are empty or labels are not unique")
            for number, dataset in enumerate(datasets):
                record["stage"] = "execute:" + dataset["label"]
                row = {"label": dataset["label"], "modes": {}}
                record["datasets"].append(row)
                baseline = execute(args, case, dataset, folder, commands, "baseline", number)
                row["baseline"] = baseline
                for mode in MODES:
                    result = execute(args, case, dataset, folder, commands, mode, number)
                    row["modes"][mode] = result
                    if args.perf and baseline["status"] == "pass" and result["status"] == "pass":
                        result["ratio"] = result["gpu_time_ns_avg"] / baseline["gpu_time_ns_avg"]
                        if result["ratio"] > args.max_ratio:
                            failures.append(f"{case['name']} {dataset['label']} {mode}: ratio {result['ratio']:.3f}")
                            result["performance"] = "fail"
                        else:
                            result["performance"] = "pass"
                save(folder / ("perf_partial.json" if args.perf else "results_partial.json"), record)
            skipped = any(r["baseline"]["status"] == "skip" or any(m["status"] == "skip" for m in r["modes"].values())
                          for r in record["datasets"])
            perf_failed = any(m.get("performance") == "fail" for r in record["datasets"] for m in r["modes"].values())
            record["status"] = "fail" if perf_failed else "skip" if skipped else "pass"
            record["stage"] = "complete"
            print(case["name"] + ": " + record["status"], flush=True)
        except (RuntimeError, AssertionError, ValueError, OSError) as error:
            record.update(status="fail", error=str(error))
            failures.append(case["name"] + ": " + str(error))
            print(case["name"] + ": FAIL: " + str(error), flush=True)
        finally:
            save(folder / ("perf_commands.json" if args.perf else "commands.json"), commands)
            save(folder / ("perf.json" if args.perf else "results.json"), record)
            save(args.out_dir / ("perf.json" if args.perf else "results.json"), records)
    if failures:
        raise SystemExit("\n".join(failures))


if __name__ == "__main__":
    main()
