#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import argparse
import pathlib
import sys


def read_optional(path):
    path = pathlib.Path(path)
    return path.read_text(encoding="utf-8") if path.exists() else f"_Missing: {path}_\n"


def main():
    parser = argparse.ArgumentParser(description="Collect HW Vulkan functional/perf reports")
    parser.add_argument("--functional", default="results/functional/functional.md")
    parser.add_argument("--perf", default="results/perf/perf.md")
    parser.add_argument("--out", default="results/hw_vk_report.md")
    args = parser.parse_args()

    out = pathlib.Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    text = "\n\n".join(
        [
            "# HW Vulkan Function/Performance Report",
            read_optional(args.functional),
            read_optional(args.perf),
        ]
    )
    out.write_text(text, encoding="utf-8")
    print(out)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as exc:
        print(exc, file=sys.stderr)
        sys.exit(1)
