#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import argparse
import pathlib
import re
import shutil
import subprocess
import sys


HW_RE = re.compile(r"HW|CooperativeMatrixHW|CooperativeVectorHW|OpTypeCooperative|OpCooperative")


def run(cmd):
    print("+", " ".join(str(c) for c in cmd))
    subprocess.run(cmd, check=True)


def find_tool(path_or_name):
    path = pathlib.Path(path_or_name)
    if path.exists():
        return str(path)
    found = shutil.which(path_or_name)
    if found:
        return found
    raise FileNotFoundError(f"tool not found: {path_or_name}")


def compile_hw_shader(glslang, spirv_opt, spirv_val, spirv_dis, shader, out_dir, target_env):
    stem = shader.stem
    hw_spv = out_dir / f"{stem}.hw.spv"
    lowered_spv = out_dir / f"{stem}.lowered.spv"
    lowered_asm = out_dir / f"{stem}.lowered.spvasm"
    lowering_pass = "--hw-lower-to-standard=scalar" if "_scalar_" in stem else "--hw-lower-to-standard"

    run([glslang, "-V", str(shader), "-o", str(hw_spv)])
    run([spirv_opt, lowering_pass, str(hw_spv), "-o", str(lowered_spv)])
    run([spirv_val, "--target-env", target_env, str(lowered_spv)])
    run([spirv_dis, str(lowered_spv), "-o", str(lowered_asm)])

    asm_text = lowered_asm.read_text(encoding="utf-8")
    if HW_RE.search(asm_text):
        raise RuntimeError(f"FAIL: HW op remains after lowering: {lowered_asm}")


def compile_baseline_shader(glslang, spirv_val, spirv_dis, shader, out_dir, target_env):
    stem = shader.stem
    spv = out_dir / f"{stem}.spv"
    asm = out_dir / f"{stem}.spvasm"

    run([glslang, "-V", str(shader), "-o", str(spv)])
    run([spirv_val, "--target-env", target_env, str(spv)])
    run([spirv_dis, str(spv), "-o", str(asm)])


def main():
    parser = argparse.ArgumentParser(description="Build HW Vulkan test shaders")
    parser.add_argument("--glslang", required=True)
    parser.add_argument("--spirv-opt", required=True)
    parser.add_argument("--spirv-val")
    parser.add_argument("--spirv-dis")
    parser.add_argument("--shader-dir", required=True)
    parser.add_argument("--baseline-dir", required=True)
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--target-env", default="vulkan1.3")
    args = parser.parse_args()

    glslang = find_tool(args.glslang)
    spirv_opt = find_tool(args.spirv_opt)
    spirv_val = find_tool(args.spirv_val or "spirv-val")
    spirv_dis = find_tool(args.spirv_dis or "spirv-dis")

    shader_dir = pathlib.Path(args.shader_dir)
    baseline_dir = pathlib.Path(args.baseline_dir)
    out_dir = pathlib.Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    hw_shaders = sorted(shader_dir.glob("*.comp"))
    baseline_shaders = sorted(baseline_dir.glob("*.comp"))
    if not hw_shaders:
        raise RuntimeError(f"no HW shaders found in {shader_dir}")
    if not baseline_shaders:
        raise RuntimeError(f"no baseline shaders found in {baseline_dir}")

    for shader in hw_shaders:
        compile_hw_shader(glslang, spirv_opt, spirv_val, spirv_dis, shader, out_dir, args.target_env)
    for shader in baseline_shaders:
        compile_baseline_shader(glslang, spirv_val, spirv_dis, shader, out_dir, args.target_env)

    print(f"built {len(hw_shaders)} HW shaders and {len(baseline_shaders)} baselines into {out_dir}")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(exc, file=sys.stderr)
        sys.exit(1)
