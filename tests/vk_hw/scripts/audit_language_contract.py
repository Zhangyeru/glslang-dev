#!/usr/bin/env python3
# Copyright (C) 2026 The Khronos Group Inc.
# SPDX-License-Identifier: BSD-3-Clause

"""Check the reviewed HW input contract against validator and lowering sources.

This is a change detector and an ownership map, not a proof from test counts.
Runtime coverage reports are produced separately from validated GLSL inputs.
"""

import argparse
import hashlib
import json
import pathlib
import re


def function_body(source, name):
    declaration = re.search(
        r"(?:^|\n)(?:inline\s+)?(?:bool|HwGlslStd450Info)\s+"
        r"(?:HwLowerToStandardPass::)?" + re.escape(name) + r"\([^;{}]*\)\s*(?:const\s*)?\{",
        source,
    )
    if not declaration:
        raise ValueError(f"cannot locate definition of {name}")
    start = declaration.end() - 1
    depth = 1
    end = start + 1
    while depth:
        depth += (source[end] == "{") - (source[end] == "}")
        end += 1
    return source[start:end]


def declarations(root):
    opt = root / "External/spirv-tools/source/opt"
    internal = (opt / "hw_lower_to_standard_pass_internal.h").read_text()
    validation = (opt / "hw_lower_to_standard_validation.cpp").read_text()
    result = {}
    for group, function in {
        "conversion": "IsHwConversionOpcode",
        "arithmetic": "IsHwArithmeticOpcode",
        "scale": "IsHwScaleOpcode",
        "structural": "IsCoreOpcodeAllowedOnHwValue",
    }.items():
        result[group] = sorted(set(re.findall(r"spv::Op::(Op\w+)", function_body(internal, function))))
    result["hw"] = sorted(set(re.findall(r"spv::Op::(Op\w+)", function_body(validation, "IsHwOpcode"))))
    result["extinst"] = sorted(
        set(re.findall(r"case GLSLstd450(\w+)", function_body(internal, "DescribeSupportedHwGlslStd450")))
    )
    return result


def audit(root, contract):
    declared = declarations(root)
    groups = contract["groups"]
    if set(groups) != set(declared):
        raise ValueError("contract groups do not match the lowering dispatch")
    for name, actual in declared.items():
        if not actual:
            raise ValueError(f"empty dispatch family: {name}")
        expected = sorted(groups[name]["opcodes"])
        if actual != expected:
            raise ValueError(
                f"{name} closure changed: added={set(actual)-set(expected)}, "
                f"removed={set(expected)-set(actual)}; review signatures and evidence"
            )
        if not groups[name]["rule"] or not groups[name]["implementation"]:
            raise ValueError(f"missing semantic owner for {name}")
        for file in groups[name]["implementation"] + groups[name]["unit_suites"]:
            if not (root / file).is_file():
                raise ValueError(f"missing implementation/evidence: {file}")
    for file, expected in contract["validator_sha256"].items():
        actual = hashlib.sha256((root / file).read_bytes()).hexdigest()
        if actual != expected:
            raise ValueError(f"validator changed: {file}; review the legal input set and update its evidence")
    return {
        "status": "pass",
        "contract": contract["scope"],
        "operations": {name: len(ops) for name, ops in declared.items()},
        "groups": groups,
        "note": "Source contract checked; numerical and producer coverage are separate obligations.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=pathlib.Path, required=True)
    parser.add_argument("--report", type=pathlib.Path)
    args = parser.parse_args()
    contract = json.loads((args.root / "tests/vk_hw/language_contract.json").read_text())
    report = audit(args.root, contract)
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"status": report["status"], "operations": report["operations"]}))


if __name__ == "__main__":
    main()
