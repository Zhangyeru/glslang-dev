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


def find_optional_tool(path_or_name):
    """Like find_tool but returns None when not found."""
    if not path_or_name:
        return None
    path = pathlib.Path(path_or_name)
    if path.exists():
        return str(path)
    return shutil.which(path_or_name)


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


def decompile_spv_to_glsl(spirv_cross, spv_dir, glsl_dir):
    """Convert every .spv file in spv_dir to a .glsl file in glsl_dir.

    Skips .hw.spv files: those contain HW cooperative-matrix opcodes that
    spirv-cross cannot decompile.  Only .lowered.spv (post-lowering) and
    _baseline.spv (hand-written reference) are converted.

    Returns (success_count, fail_count).  Failures are logged but do not
    abort the build so that a spirv-cross regression does not block
    functional/perf testing.
    """
    glsl_dir.mkdir(parents=True, exist_ok=True)
    # Remove stale .glsl files so the output always mirrors the current
    # set of .spv binaries.
    for stale in glsl_dir.glob("*.glsl"):
        stale.unlink()

    success = 0
    fail = 0
    skipped = 0
    for spv in sorted(spv_dir.glob("*.spv")):
        # .hw.spv contains pre-lowering HW extension opcodes that
        # spirv-cross does not understand — skip them silently.
        if spv.name.endswith(".hw.spv"):
            skipped += 1
            continue
        glsl = glsl_dir / f"{spv.stem}.glsl"
        cmd = [spirv_cross, str(spv), "--output", str(glsl), "--vulkan-semantics"]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0:
            success += 1
        else:
            fail += 1
            print(f"spirv-cross FAILED for {spv.name}: {result.stderr.strip()}",
                  file=sys.stderr)
    return success, fail, skipped


def main():
    parser = argparse.ArgumentParser(description="Build HW Vulkan test shaders")
    parser.add_argument("--glslang", required=True)
    parser.add_argument("--spirv-opt", required=True)
    parser.add_argument("--spirv-val")
    parser.add_argument("--spirv-dis")
    parser.add_argument("--spirv-cross",
                        help="Path to spirv-cross binary; GLSL decompilation "
                             "is skipped when not provided or not found.")
    parser.add_argument("--shader-dir", required=True)
    parser.add_argument("--baseline-dir", required=True)
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--glsl-out-dir",
                        help="Directory for decompiled GLSL output.  "
                             "Defaults to <out-dir>/../glsl when omitted.")
    parser.add_argument("--target-env", default="vulkan1.3")
    args = parser.parse_args()

    glslang = find_tool(args.glslang)
    spirv_opt = find_tool(args.spirv_opt)
    spirv_val = find_tool(args.spirv_val or "spirv-val")
    spirv_dis = find_tool(args.spirv_dis or "spirv-dis")
    spirv_cross = find_optional_tool(args.spirv_cross or "spirv-cross")
    spirv_cross_explicit = bool(args.spirv_cross)

    shader_dir = pathlib.Path(args.shader_dir)
    baseline_dir = pathlib.Path(args.baseline_dir)
    out_dir = pathlib.Path(args.out_dir)
    glsl_out_dir = pathlib.Path(args.glsl_out_dir) if args.glsl_out_dir \
                   else out_dir.parent / "glsl"
    out_dir.mkdir(parents=True, exist_ok=True)
    for stale in out_dir.glob("*.spv*"):
        stale.unlink()

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

    if spirv_cross:
        ok, fail, skipped = decompile_spv_to_glsl(spirv_cross, out_dir, glsl_out_dir)
        msg = f"decompiled {ok} SPIR-V binaries to GLSL in {glsl_out_dir}"
        if skipped:
            msg += f" ({skipped} .hw.spv skipped)"
        if fail:
            msg += f" ({fail} failed)"
        print(msg)
    else:
        if spirv_cross_explicit:
            print(f"WARNING: --spirv-cross '{args.spirv_cross}' was specified "
                  f"but the binary was not found; GLSL decompilation skipped. "
                  f"Stale .glsl files in {glsl_out_dir} will NOT be cleaned "
                  f"automatically.", file=sys.stderr)
        stale_glsl = sorted(glsl_out_dir.glob("*.glsl")) if glsl_out_dir.is_dir() else []
        if stale_glsl:
            if not spirv_cross_explicit:
                print(f"WARNING: {len(stale_glsl)} stale .glsl file(s) remain in "
                      f"{glsl_out_dir} (spirv-cross unavailable). Delete them "
                      f"manually or install spirv-cross to regenerate.",
                      file=sys.stderr)
        else:
            if not spirv_cross_explicit:
                print("spirv-cross not found; skipping GLSL decompilation "
                      "(pass --spirv-cross to enable)")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(exc, file=sys.stderr)
        sys.exit(1)
