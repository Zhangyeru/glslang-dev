#!/usr/bin/env python3
# Copyright (C) 2026 The Khronos Group Inc.
# SPDX-License-Identifier: BSD-3-Clause

"""Compile the focused GLSL language fixtures and execute their CPU oracles.

No normalization or general optimization precedes raw HW lowering. The matching
HwExtensionFreeTest cases own the detailed typed input/output assertions.
"""

import argparse
import json
import pathlib
import subprocess

from build_shaders import has_hw_residue


CASES = ("switch_return", "do_break", "private_nested", "workgroup", "conversion_extinst")
MODES = {
    "default": "",
    "scalar": "=scalar",
    "rolled": "=unroll-elements=2",
    "scalar_rolled": "=scalar,unroll-elements=2",
}


def run(command, log):
    command = [str(arg) for arg in command]
    record = {"command": command}
    log.append(record)
    try:
        result = subprocess.run(command, text=True, capture_output=True, timeout=120)
    except subprocess.TimeoutExpired:
        record["error"] = "timeout after 120 seconds"
        raise
    record.update(returncode=result.returncode, stdout=result.stdout, stderr=result.stderr)
    if result.returncode:
        raise RuntimeError(f"command failed: {command}\n{result.stdout}\n{result.stderr}")
    return result.stdout


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("glslang", "spirv-opt", "spirv-val", "spirv-dis", "runner", "source-dir", "out-dir"):
        parser.add_argument("--" + name, required=True)
    args = parser.parse_args()
    out = pathlib.Path(args.out_dir)
    out.mkdir(parents=True, exist_ok=True)
    results = []
    try:
        for name in CASES:
            for width in (4, 5):
                folder = out / f"{name}_{width}"
                folder.mkdir(exist_ok=True)
                log = []
                record = {"case": name, "width": width, "stage": "compile", "modes": {}}
                results.append(record)
                try:
                    source = pathlib.Path(args.source_dir) / f"spv.hw_extfree_{name}.comp"
                    binary = folder / "input.spv"
                    run([args.glslang, "--target-env", "vulkan1.3", "-V", f"-DWIDTH={width}",
                         source, "-o", binary], log)
                    record["stage"] = "input-validation"
                    run([args.spirv_val, "--target-env", "vulkan1.3", binary], log)
                    run([args.spirv_dis, binary, "-o", folder / "input.spvasm"], log)
                    for mode, options in MODES.items():
                        record["stage"] = f"{mode}:lower"
                        lowered = folder / f"{mode}.spv"
                        run([args.spirv_opt, "--target-env=vulkan1.3",
                             "--hw-lower-to-standard-extension-free" + options, binary, "-o", lowered], log)
                        record["stage"] = f"{mode}:output-validation"
                        run([args.spirv_val, "--target-env", "vulkan1.3", lowered], log)
                        assembly = lowered.with_suffix(".spvasm")
                        run([args.spirv_dis, lowered, "-o", assembly], log)
                        record["stage"] = f"{mode}:residue"
                        if has_hw_residue(assembly.read_text(encoding="utf-8")):
                            raise RuntimeError(f"HW residue in {assembly}")
                        record["stage"] = f"{mode}:execute"
                        result = json.loads(run([args.runner, lowered, name, width], log))
                        if result.get("status") != "pass" or result.get("dispatches", 0) <= 0:
                            raise RuntimeError(f"no successful numerical verification: {result}")
                        record["modes"][mode] = result
                    record["stage"] = "pass"
                    print(f"{name}_{width}: all four lowering modes verified", flush=True)
                finally:
                    (folder / "commands.json").write_text(json.dumps(log, indent=2) + "\n", encoding="utf-8")
    finally:
        (out / "results.json").write_text(json.dumps(results, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
