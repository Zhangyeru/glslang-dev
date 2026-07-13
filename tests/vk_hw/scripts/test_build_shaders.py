#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import pathlib
import tempfile
import unittest

from build_shaders import compare_glsl_to_golden
from build_shaders import ensure_golden_comparison_ready


class CompareGlslToGoldenTest(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        root = pathlib.Path(self.temp_dir.name)
        self.generated_dir = root / "generated"
        self.golden_dir = root / "golden"

    def tearDown(self):
        self.temp_dir.cleanup()

    @staticmethod
    def write_file(root, relative_path, text):
        path = root / relative_path
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
        return path

    def test_reports_golden_without_generated_file(self):
        self.write_file(self.golden_dir, "hw/stale.glsl", "stale\n")

        match, mismatch, missing, diffs = compare_glsl_to_golden(
            self.generated_dir, self.golden_dir)

        self.assertEqual((match, mismatch, missing), (0, 0, 1))
        self.assertEqual(diffs, ["MISSING generated: hw/stale.glsl"])

    def test_reports_generated_file_without_golden(self):
        self.write_file(self.generated_dir, "baseline/new.glsl", "new\n")

        match, mismatch, missing, diffs = compare_glsl_to_golden(
            self.generated_dir, self.golden_dir)

        self.assertEqual((match, mismatch, missing), (0, 0, 1))
        self.assertEqual(diffs, ["MISSING golden: baseline/new.glsl"])

    def test_update_reconciles_missing_files_in_both_directions(self):
        generated = self.write_file(
            self.generated_dir, "hw/current.glsl", "current\n")
        stale = self.write_file(self.golden_dir, "hw/stale.glsl", "stale\n")

        match, mismatch, missing, diffs = compare_glsl_to_golden(
            self.generated_dir, self.golden_dir, update_golden=True)

        self.assertEqual((match, mismatch, missing), (0, 0, 2))
        self.assertEqual(diffs, [])
        self.assertFalse(stale.exists())
        self.assertEqual(
            (self.golden_dir / "hw/current.glsl").read_text(encoding="utf-8"),
            generated.read_text(encoding="utf-8"))


class GoldenComparisonReadinessTest(unittest.TestCase):
    def test_requires_spirv_cross_for_golden_comparison(self):
        with self.assertRaisesRegex(RuntimeError, "requires spirv-cross"):
            ensure_golden_comparison_ready(pathlib.Path("golden"), None)

    def test_rejects_incomplete_decompilation(self):
        with self.assertRaisesRegex(RuntimeError, "golden comparison is incomplete"):
            ensure_golden_comparison_ready(
                pathlib.Path("golden"), "/path/to/spirv-cross", 2)

    def test_allows_failures_without_golden_comparison(self):
        ensure_golden_comparison_ready(None, None, 2)


if __name__ == "__main__":
    unittest.main()
