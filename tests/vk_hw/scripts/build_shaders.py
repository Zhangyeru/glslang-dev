#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import argparse
import dataclasses
import difflib
import json
import pathlib
import re
import shutil
import subprocess
import sys


SPIRV_INSTRUCTION_RE = re.compile(
    r"^\s*(?:%[^\s=]+\s*=\s*)?"
    r"(?P<opcode>Op[A-Za-z0-9_]+)(?:\s+(?P<operands>.*))?$"
)
SPIRV_RESULT_INSTRUCTION_RE = re.compile(
    r"^\s*(?P<result>%[^\s=]+)\s*=\s*"
    r"(?P<opcode>Op[A-Za-z0-9_]+)(?:\s+(?P<operands>.*))?$"
)
HW_CAPABILITY_RE = re.compile(r"[A-Za-z0-9_]*(?:HW|AZD)")
HW_EXTENSION_RE = re.compile(r"SPV_(?:HW|AZD)_[A-Za-z0-9_]+")
HW_SOURCE_EXTENSION_RE = re.compile(r"GL_(?:HW|AZD)_[A-Za-z0-9_]+")
REPLICATED_COMPOSITE_OPCODES = frozenset({
    "OpConstantCompositeReplicateEXT",
    "OpSpecConstantCompositeReplicateEXT",
    "OpCompositeConstructReplicateEXT",
})
QUOTED_OPERAND_RE = re.compile(r'"([^"\\]*(?:\\.[^"\\]*)*)"')
ARTIFACT_STEM_RE = re.compile(r"[A-Za-z0-9][A-Za-z0-9_.-]*")


@dataclasses.dataclass(frozen=True)
class SpecializationCase:
    artifact_stem: str
    values: tuple = ()


def _strip_spirv_comment(line):
    """Remove a SPIR-V assembly comment without treating ';' in a string as one."""
    in_string = False
    escaped = False
    for index, char in enumerate(line):
        if escaped:
            escaped = False
        elif in_string and char == "\\":
            escaped = True
        elif char == '"':
            in_string = not in_string
        elif char == ";" and not in_string:
            return line[:index]
    return line


def _quoted_operand(operands):
    match = QUOTED_OPERAND_RE.fullmatch(operands.strip())
    return match.group(1) if match else None


def has_hw_residue(asm_text, include_replicated_composites=True):
    """Return whether lowered assembly contains a forbidden construct.

    Parse only instruction/opcode positions so debug names, strings, comments,
    standard cooperative KHR/NV instructions, and unrelated EXT declarations
    cannot be mistaken for residue.
    """
    for raw_line in asm_text.splitlines():
        line = _strip_spirv_comment(raw_line).rstrip()
        instruction = SPIRV_INSTRUCTION_RE.fullmatch(line)
        if not instruction:
            continue

        opcode = instruction.group("opcode")
        operands = instruction.group("operands") or ""
        if (opcode.endswith("HW") or
                (include_replicated_composites and
                 opcode in REPLICATED_COMPOSITE_OPCODES)):
            return True

        if opcode == "OpCapability":
            capability = operands.split(maxsplit=1)[0] if operands else ""
            if (HW_CAPABILITY_RE.fullmatch(capability) or
                    (include_replicated_composites and
                     capability == "ReplicatedCompositesEXT")):
                return True
        elif opcode == "OpExtension":
            extension = _quoted_operand(operands)
            if (extension and
                    (HW_EXTENSION_RE.fullmatch(extension) or
                     (include_replicated_composites and
                      extension == "SPV_EXT_replicated_composites"))):
                return True
        elif opcode == "OpSourceExtension":
            extension = _quoted_operand(operands)
            if (extension and
                    (HW_SOURCE_EXTENSION_RE.fullmatch(extension) or
                     (include_replicated_composites and
                      extension == "GL_EXT_replicated_composites"))):
                return True
        elif opcode == "OpSelectionMerge":
            merge_operands = operands.split()
            if (len(merge_operands) >= 2 and
                    "Relreg" in merge_operands[1].split("|")):
                return True

    return False


def has_spec_constant_residue(asm_text):
    """Return whether assembly still contains a specialization constant."""
    for raw_line in asm_text.splitlines():
        line = _strip_spirv_comment(raw_line).rstrip()
        instruction = SPIRV_INSTRUCTION_RE.fullmatch(line)
        if instruction and instruction.group("opcode").startswith(
                "OpSpecConstant"):
            return True
    return False


def specialization_integer_types(asm_text):
    """Return direct integer specialization constants keyed by SpecId.

    The vk_hw sidecar intentionally accepts integer controls only.  Parse the
    glslang-produced module before invoking spirv-opt so an unknown SpecId or
    an out-of-range value cannot be silently ignored by
    --set-spec-const-default-value.
    """
    integer_types = {}
    spec_constant_types = {}
    spec_id_targets = {}

    for raw_line in asm_text.splitlines():
        line = _strip_spirv_comment(raw_line).rstrip()
        instruction = SPIRV_INSTRUCTION_RE.fullmatch(line)
        if instruction and instruction.group("opcode") == "OpDecorate":
            operands = (instruction.group("operands") or "").split()
            if len(operands) == 3 and operands[1] == "SpecId":
                target, _, spec_id_text = operands
                try:
                    spec_id = int(spec_id_text, 0)
                except ValueError:
                    continue
                if spec_id in spec_id_targets:
                    spec_id_targets[spec_id] = None
                else:
                    spec_id_targets[spec_id] = target

        result_instruction = SPIRV_RESULT_INSTRUCTION_RE.fullmatch(line)
        if not result_instruction:
            continue
        result = result_instruction.group("result")
        opcode = result_instruction.group("opcode")
        operands = (result_instruction.group("operands") or "").split()
        if opcode == "OpTypeInt" and len(operands) == 2:
            try:
                width = int(operands[0], 0)
                signedness = int(operands[1], 0)
            except ValueError:
                continue
            if width > 0 and signedness in (0, 1):
                integer_types[result] = (width, bool(signedness))
        elif opcode == "OpSpecConstant" and operands:
            spec_constant_types[result] = operands[0]

    result = {}
    for spec_id, target in spec_id_targets.items():
        type_id = spec_constant_types.get(target)
        integer_type = integer_types.get(type_id)
        if target is not None and integer_type is not None:
            result[spec_id] = integer_type
    return result


def validate_specialization_cases(cases, asm_text, source):
    """Validate every requested override against the raw source module."""
    integer_types = specialization_integer_types(asm_text)
    for case in cases:
        for spec_id, value in case.values:
            integer_type = integer_types.get(spec_id)
            if integer_type is None:
                declared = ", ".join(str(item) for item in sorted(integer_types))
                if not declared:
                    declared = "none"
                raise ValueError(
                    f"specialization variant {case.artifact_stem} requests "
                    f"undeclared or non-integer SpecId {spec_id} in {source}; "
                    f"declared integer SpecIds: {declared}")

            width, is_signed = integer_type
            if is_signed:
                minimum = -(1 << (width - 1))
                maximum = (1 << (width - 1)) - 1
            else:
                minimum = 0
                maximum = (1 << width) - 1
            if value < minimum or value > maximum:
                spelling = f"i{width}" if is_signed else f"u{width}"
                raise ValueError(
                    f"specialization value {value} for SpecId {spec_id} in "
                    f"variant {case.artifact_stem} is outside {spelling} "
                    f"range [{minimum}, {maximum}]")


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


def validator_cmd(spirv_val, target_env, shader):
    cmd = [spirv_val, "--target-env", target_env]
    if "_ubo_" in shader.stem:
        cmd.append("--scalar-block-layout")
    return cmd


def lowering_pass_for_stem(stem):
    return (
        "--hw-lower-to-standard-extension-free=scalar"
        if "_scalar_" in stem
        else "--hw-lower-to-standard-extension-free"
    )


def find_hw_shaders(shader_dir):
    """Return supported HW shaders in deterministic order."""
    return sorted((*shader_dir.glob("*.comp"), *shader_dir.glob("*.frag")))


def artifact_stem_for_shader(shader):
    """Keep existing compute names and qualify graphics artifacts by stage."""
    return shader.stem if shader.suffix == ".comp" else shader.name


def specialization_metadata_for_shader(shader):
    return shader.with_suffix(".spec.json")


def validate_specialization_metadata_ownership(shader_dir, shaders):
    """Reject orphan or stage-ambiguous specialization sidecars."""
    owners = {}
    for shader in shaders:
        owners.setdefault(specialization_metadata_for_shader(shader), []).append(
            shader)
    for metadata in sorted(shader_dir.glob("*.spec.json")):
        metadata_owners = owners.get(metadata, [])
        if not metadata_owners:
            raise ValueError(
                f"orphan specialization metadata has no .comp/.frag shader: "
                f"{metadata}")
        if len(metadata_owners) > 1:
            formatted = ", ".join(str(shader) for shader in metadata_owners)
            raise ValueError(
                f"specialization metadata {metadata} is ambiguous between: "
                f"{formatted}")


def load_specialization_cases(shader):
    metadata = specialization_metadata_for_shader(shader)
    if not metadata.is_file():
        return (SpecializationCase(artifact_stem_for_shader(shader)),)

    try:
        document = json.loads(metadata.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError(f"invalid specialization metadata {metadata}: {error}")
    if not isinstance(document, dict) or set(document) != {"variants"}:
        raise ValueError(
            f"specialization metadata {metadata} must contain only variants")
    variants = document["variants"]
    if not isinstance(variants, list) or not variants:
        raise ValueError(
            f"specialization metadata {metadata} variants must be non-empty")

    cases = []
    seen_stems = set()
    for index, variant in enumerate(variants):
        if (not isinstance(variant, dict) or
                set(variant) != {"artifact_stem", "values"}):
            raise ValueError(
                f"specialization variant {index} in {metadata} must contain "
                "artifact_stem and values")
        artifact_stem = variant["artifact_stem"]
        if (not isinstance(artifact_stem, str) or
                not ARTIFACT_STEM_RE.fullmatch(artifact_stem)):
            raise ValueError(
                f"invalid specialization artifact stem in {metadata}: "
                f"{artifact_stem!r}")
        if artifact_stem in seen_stems:
            raise ValueError(
                f"duplicate specialization artifact stem in {metadata}: "
                f"{artifact_stem}")
        seen_stems.add(artifact_stem)

        values = variant["values"]
        if not isinstance(values, dict):
            raise ValueError(
                f"specialization values for {artifact_stem} must be an object")
        parsed_values = []
        for spec_id_text, value in values.items():
            try:
                spec_id = int(spec_id_text)
            except (TypeError, ValueError):
                raise ValueError(
                    f"invalid specialization SpecId in {metadata}: "
                    f"{spec_id_text!r}")
            if (spec_id < 0 or spec_id > 0xffffffff or
                    str(spec_id) != spec_id_text):
                raise ValueError(
                    f"invalid specialization SpecId in {metadata}: "
                    f"{spec_id_text!r}")
            if isinstance(value, bool) or not isinstance(value, int):
                raise ValueError(
                    f"specialization value for SpecId {spec_id} in {metadata} "
                    "must be an integer")
            parsed_values.append((spec_id, value))
        cases.append(SpecializationCase(
            artifact_stem, tuple(sorted(parsed_values))))
    return tuple(cases)


def specialization_optimizer_args(case):
    args = []
    if case.values:
        values = " ".join(
            f"{spec_id}:{value}" for spec_id, value in case.values)
        args.extend(["--set-spec-const-default-value", values])
    args.extend([
        "--freeze-spec-const",
        "--fold-spec-const-op-composite",
    ])
    return args


def output_dir_for_shader(out_dir, shader):
    """Keep non-compute SPIR-V out of the compute runner's flat directory."""
    return out_dir if shader.suffix == ".comp" else out_dir / "graphics"


def compile_hw_shader(glslang, spirv_opt, spirv_val, spirv_dis, shader,
                      out_dir, target_env, specialization_cases=None):
    source_stem = artifact_stem_for_shader(shader)
    out_dir.mkdir(parents=True, exist_ok=True)
    hw_spv = out_dir / f"{source_stem}.hw.spv"

    glslang_command = [glslang]
    if re.search(r"_flow_[a-z]", shader.stem):
        # Production flow shaders place cooperative values behind user
        # function/aggregate boundaries.  Request SPIR-V 1.6 explicitly so
        # their SSBO variables use StorageBuffer in every frontend path.
        glslang_command.extend(["--target-env", target_env])
    glslang_command.extend(["-V", str(shader), "-o", str(hw_spv)])
    run(glslang_command)
    cases = specialization_cases or load_specialization_cases(shader)
    if any(case.values for case in cases):
        hw_asm = out_dir / f"{source_stem}.hw.spvasm"
        run([spirv_dis, str(hw_spv), "-o", str(hw_asm)])
        validate_specialization_cases(
            cases, hw_asm.read_text(encoding="utf-8"), shader)
    lowering_pass = lowering_pass_for_stem(shader.stem)
    for case in cases:
        lowered_spv = out_dir / f"{case.artifact_stem}.lowered.spv"
        lowered_asm = out_dir / f"{case.artifact_stem}.lowered.spvasm"
        run([
            spirv_opt,
            *specialization_optimizer_args(case),
            lowering_pass,
            "--fold-spec-const-op-composite",
            str(hw_spv),
            "-o",
            str(lowered_spv),
        ])
        run([*validator_cmd(spirv_val, target_env, shader), str(lowered_spv)])
        run([spirv_dis, str(lowered_spv), "-o", str(lowered_asm)])

        asm_text = lowered_asm.read_text(encoding="utf-8")
        if has_spec_constant_residue(asm_text):
            raise RuntimeError(
                f"FAIL: specialization constant remains after freezing: "
                f"{lowered_asm}")
        if has_hw_residue(asm_text):
            raise RuntimeError(
                f"FAIL: HW op remains after lowering: {lowered_asm}")


def compile_unsupported_shader(glslang, spirv_opt, spirv_val, spirv_dis,
                               shader, out_dir, target_env):
    """Check the contract between partial and extension-free lowering.

    Unsupported shaders intentionally contain a non-cooperative HW feature.
    Cooperative-only lowering must preserve that feature in valid SPIR-V,
    while extension-free lowering must fail instead of silently emitting a
    module with HW residue.
    """
    stem = shader.stem
    hw_spv = out_dir / f"{stem}.unsupported.hw.spv"
    partial_spv = out_dir / f"{stem}.unsupported.partial.hw.spv"
    partial_asm = out_dir / f"{stem}.unsupported.partial.spvasm"
    rejected_spv = out_dir / f"{stem}.unsupported.rejected.hw.spv"

    run([glslang, "-V", str(shader), "-o", str(hw_spv)])
    run([spirv_opt, "--hw-lower-to-standard", str(hw_spv),
         "-o", str(partial_spv)])
    run([*validator_cmd(spirv_val, target_env, shader), str(partial_spv)])
    run([spirv_dis, str(partial_spv), "-o", str(partial_asm)])

    asm_text = partial_asm.read_text(encoding="utf-8")
    if not has_hw_residue(asm_text, include_replicated_composites=False):
        raise RuntimeError(
            "FAIL: cooperative-only lowering unexpectedly removed every HW "
            f"feature from unsupported input: {partial_asm}")

    cmd = [spirv_opt, "--hw-lower-to-standard-extension-free", str(hw_spv),
           "-o", str(rejected_spv)]
    print("+", " ".join(str(c) for c in cmd), "(expect failure)")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        raise RuntimeError(
            "FAIL: extension-free lowering accepted unsupported HW input: "
            f"{shader}")
    diagnostic = "\n".join((result.stdout, result.stderr))
    if "extension-free HW lowering" not in diagnostic:
        raise RuntimeError(
            "FAIL: extension-free lowering failed for an unexpected reason: "
            f"{shader}\n{diagnostic.strip()}")
    rejected_spv.unlink(missing_ok=True)


def compile_baseline_shader(glslang, spirv_val, spirv_dis, shader, out_dir, target_env):
    stem = shader.stem
    spv = out_dir / f"{stem}.spv"
    asm = out_dir / f"{stem}.spvasm"

    run([glslang, "-V", str(shader), "-o", str(spv)])
    run([*validator_cmd(spirv_val, target_env, shader), str(spv)])
    run([spirv_dis, str(spv), "-o", str(asm)])


def decompile_spv_to_glsl(spirv_cross, spv_dir, glsl_dir):
    """Convert every .spv file in spv_dir to a .glsl file in glsl_dir.

    Skips .hw.spv files: those contain HW cooperative-matrix opcodes that
    spirv-cross cannot decompile.  Only .lowered.spv (post-lowering) and
    _baseline.spv (hand-written reference) are converted.

    Output is split into subdirectories:
      - *.lowered.glsl  -> glsl_dir/hw/
      - *_baseline.glsl -> glsl_dir/baseline/

    Returns (success_count, fail_count, skipped_count).  Failures are logged
    but do not abort the build so that a spirv-cross regression does not
    block functional/perf testing.
    """
    hw_dir = glsl_dir / "hw"
    baseline_dir = glsl_dir / "baseline"
    hw_dir.mkdir(parents=True, exist_ok=True)
    baseline_dir.mkdir(parents=True, exist_ok=True)
    # Remove stale .glsl files so the output always mirrors the current
    # set of .spv binaries.
    for stale in hw_dir.glob("*.glsl"):
        stale.unlink()
    for stale in baseline_dir.glob("*.glsl"):
        stale.unlink()

    success = 0
    fail = 0
    skipped = 0
    for spv in sorted(spv_dir.rglob("*.spv")):
        # .hw.spv contains pre-lowering HW extension opcodes that
        # spirv-cross does not understand — skip them silently.
        if spv.name.endswith(".hw.spv"):
            skipped += 1
            continue
        # Route to subdirectory based on suffix.
        if spv.stem.endswith("_baseline"):
            out_subdir = baseline_dir
        else:
            out_subdir = hw_dir
        glsl = out_subdir / f"{spv.stem}.glsl"
        cmd = [spirv_cross, str(spv), "--output", str(glsl), "--vulkan-semantics"]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode == 0:
            success += 1
        else:
            fail += 1
            print(f"spirv-cross FAILED for {spv.name}: {result.stderr.strip()}",
                  file=sys.stderr)
    return success, fail, skipped


def ensure_golden_comparison_ready(golden_dir, spirv_cross,
                                   decompile_failures=0):
    if golden_dir is None:
        return
    if spirv_cross is None:
        raise RuntimeError(
            "golden GLSL comparison requires spirv-cross, but no executable "
            "was found")
    if decompile_failures:
        raise RuntimeError(
            f"spirv-cross failed for {decompile_failures} SPIR-V "
            "binary/binaries; golden comparison is incomplete")


def compare_glsl_to_golden(generated_dir, golden_dir, update_golden=False):
    """Compare freshly decompiled GLSL files against golden references.

    Both directories are expected to contain ``hw/`` and ``baseline/``
    subdirectories with ``.glsl`` files. Files missing from either side are
    reported; update mode removes golden files with no generated counterpart.

    Args:
        generated_dir: Directory containing freshly generated .glsl files.
        golden_dir:    Directory containing committed golden .glsl files.
        update_golden: When True, overwrite golden files with generated content
                       (like --update-mode in glslang gtests).

    Returns (match_count, mismatch_count, missing_count, diff_messages).
    """
    match = 0
    mismatch = 0
    missing = 0
    diffs = []

    for subdir in ("hw", "baseline"):
        gen_sub = generated_dir / subdir
        gold_sub = golden_dir / subdir
        if update_golden:
            gold_sub.mkdir(parents=True, exist_ok=True)

        generated_files = ({path.name: path for path in gen_sub.glob("*.glsl")}
                           if gen_sub.is_dir() else {})
        golden_files = ({path.name: path for path in gold_sub.glob("*.glsl")}
                        if gold_sub.is_dir() else {})

        for name in sorted(generated_files.keys() | golden_files.keys()):
            glsl = generated_files.get(name)
            golden = golden_files.get(name)

            if glsl is None:
                missing += 1
                if update_golden:
                    golden.unlink()
                    print(f"  REMOVED stale golden: {subdir}/{name}")
                else:
                    diffs.append(f"MISSING generated: {subdir}/{name}")
                continue

            generated_text = glsl.read_text(encoding="utf-8")

            if golden is None:
                missing += 1
                if update_golden:
                    golden = gold_sub / name
                    golden.write_text(generated_text, encoding="utf-8")
                    print(f"  NEW golden: {subdir}/{name}")
                else:
                    diffs.append(f"MISSING golden: {subdir}/{name}")
                continue

            golden_text = golden.read_text(encoding="utf-8")
            if generated_text == golden_text:
                match += 1
                continue

            mismatch += 1
            if update_golden:
                golden.write_text(generated_text, encoding="utf-8")
                print(f"  UPDATED golden: {subdir}/{golden.name}")
            else:
                diff_lines = list(difflib.unified_diff(
                    golden_text.splitlines(keepends=True),
                    generated_text.splitlines(keepends=True),
                    fromfile=f"golden/{subdir}/{glsl.name}",
                    tofile=f"generated/{subdir}/{glsl.name}",
                    n=3,
                ))
                snippet = "".join(diff_lines[:20]).rstrip()
                if len(diff_lines) > 20:
                    snippet += f"\n  ... ({len(diff_lines) - 20} more diff lines)"
                diffs.append(f"MISMATCH {subdir}/{golden.name}:\n{snippet}")

    return match, mismatch, missing, diffs


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
    parser.add_argument(
        "--unsupported-dir",
        help="Directory of HW shaders that cooperative-only lowering must "
             "preserve and extension-free lowering must reject.")
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--glsl-out-dir",
                        help="Directory for decompiled GLSL output.  "
                             "Defaults to <out-dir>/../glsl when omitted.")
    parser.add_argument("--golden-dir",
                        help="Directory containing golden GLSL reference files "
                             "(with hw/ and baseline/ subdirectories).  When "
                             "provided, freshly decompiled GLSL is compared "
                             "against these goldens and the test fails on "
                             "mismatch.")
    parser.add_argument("--update-golden", action="store_true", default=False,
                        help="Overwrite golden GLSL files with freshly "
                             "generated output.")
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
    unsupported_dir = pathlib.Path(args.unsupported_dir) \
        if args.unsupported_dir else None
    out_dir = pathlib.Path(args.out_dir)
    glsl_out_dir = pathlib.Path(args.glsl_out_dir) if args.glsl_out_dir \
                   else out_dir.parent / "glsl"
    golden_dir = pathlib.Path(args.golden_dir) if args.golden_dir else None
    ensure_golden_comparison_ready(golden_dir, spirv_cross)
    out_dir.mkdir(parents=True, exist_ok=True)
    for stale in out_dir.rglob("*.spv*"):
        stale.unlink()

    hw_shaders = find_hw_shaders(shader_dir)
    baseline_shaders = sorted(baseline_dir.glob("*.comp"))
    unsupported_shaders = (sorted(unsupported_dir.glob("*.comp"))
                           if unsupported_dir else [])
    if not hw_shaders:
        raise RuntimeError(f"no HW shaders found in {shader_dir}")
    validate_specialization_metadata_ownership(shader_dir, hw_shaders)
    if not baseline_shaders:
        raise RuntimeError(f"no baseline shaders found in {baseline_dir}")
    if unsupported_dir is not None and not unsupported_shaders:
        raise RuntimeError(f"no unsupported HW shaders found in {unsupported_dir}")

    specialization_cases = {}
    artifact_owners = {}
    variant_count = 0
    for shader in hw_shaders:
        cases = load_specialization_cases(shader)
        specialization_cases[shader] = cases
        variant_count += len(cases)
        for case in cases:
            owner = artifact_owners.get(case.artifact_stem)
            if owner is not None:
                raise RuntimeError(
                    f"duplicate HW artifact stem {case.artifact_stem}: "
                    f"{owner} and {shader}")
            artifact_owners[case.artifact_stem] = shader

    for shader in hw_shaders:
        compile_hw_shader(
            glslang, spirv_opt, spirv_val, spirv_dis, shader,
            output_dir_for_shader(out_dir, shader), args.target_env,
            specialization_cases[shader])
    for shader in baseline_shaders:
        compile_baseline_shader(glslang, spirv_val, spirv_dis, shader, out_dir, args.target_env)
    for shader in unsupported_shaders:
        compile_unsupported_shader(
            glslang, spirv_opt, spirv_val, spirv_dis, shader, out_dir,
            args.target_env)

    print(f"built {len(hw_shaders)} HW shader sources into {variant_count} "
          f"lowered variants and {len(baseline_shaders)} baselines; checked "
          f"{len(unsupported_shaders)} unsupported HW shader(s) in {out_dir}")

    if spirv_cross:
        ok, fail, skipped = decompile_spv_to_glsl(spirv_cross, out_dir, glsl_out_dir)
        msg = f"decompiled {ok} SPIR-V binaries to GLSL in {glsl_out_dir}"
        if skipped:
            msg += f" ({skipped} .hw.spv skipped)"
        if fail:
            msg += f" ({fail} failed)"
        print(msg)

        # Compare freshly decompiled GLSL against golden references.
        if golden_dir is not None:
            ensure_golden_comparison_ready(golden_dir, spirv_cross, fail)
            g_match, g_mismatch, g_missing, g_diffs = compare_glsl_to_golden(
                glsl_out_dir, golden_dir, update_golden=args.update_golden)
            print(f"golden comparison: {g_match} match, "
                  f"{g_mismatch} mismatch, {g_missing} missing")
            if g_diffs:
                for d in g_diffs:
                    print(d, file=sys.stderr)
            if args.update_golden:
                updated = g_mismatch + g_missing
                if updated:
                    print(f"updated {updated} golden file(s) in {golden_dir}")
            elif g_mismatch or g_missing:
                raise RuntimeError(
                    f"golden GLSL comparison failed: {g_mismatch} mismatch(es), "
                    f"{g_missing} missing. Re-run with --update-golden to "
                    f"regenerate golden files.")
    else:
        if spirv_cross_explicit:
            print(f"WARNING: --spirv-cross '{args.spirv_cross}' was specified "
                  f"but the binary was not found; GLSL decompilation skipped. "
                  f"Stale .glsl files in {glsl_out_dir} will NOT be cleaned "
                  f"automatically.", file=sys.stderr)
        stale_glsl = []
        for sub in ("hw", "baseline"):
            sub_dir = glsl_out_dir / sub
            if sub_dir.is_dir():
                stale_glsl.extend(sub_dir.glob("*.glsl"))
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
