#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import pathlib
import tempfile
import unittest
from unittest import mock

from build_shaders import compare_glsl_to_golden
from build_shaders import ensure_golden_comparison_ready
from build_shaders import lowering_pass_for_stem
from run_function_tests import case_work
from run_function_tests import parse_case
from run_function_tests import run_case
from run_function_tests import select_shaders
from run_function_tests import shape_string


class ParseReduceCaseTest(unittest.TestCase):
    def test_parses_packed_reduce_metadata(self):
        self.assertEqual(
            parse_case(pathlib.Path("reduce_column_min_f16_5x8.lowered.spv")),
            {
                "case": "reduce",
                "dtype": "f16",
                "axis": "column",
                "reduce_op": "min",
                "m": "5",
                "n": "8",
                "k": "0",
            },
        )
    def test_parses_scalar_reduce_metadata(self):
        self.assertEqual(
            parse_case(pathlib.Path("reduce_row_add_f32_scalar_5x7.lowered.spv")),
            {
                "case": "reduce",
                "dtype": "f32",
                "axis": "row",
                "reduce_op": "add",
                "m": "5",
                "n": "7",
                "k": "0",
                "scalar": True,
            },
        )

    def test_reduce_work_and_shape_use_element_count(self):
        meta = parse_case(pathlib.Path("reduce_row_max_f32_5x8.lowered.spv"))
        self.assertEqual(case_work(meta), 40)
        self.assertEqual(shape_string(meta), "5x8")

    def test_rejects_unknown_reduce_axis(self):
        with self.assertRaisesRegex(ValueError, "cannot parse case"):
            parse_case(pathlib.Path("reduce_diagonal_add_f32_5x7.lowered.spv"))

    def test_rejects_unknown_reduce_operation(self):
        with self.assertRaisesRegex(ValueError, "cannot parse case"):
            parse_case(pathlib.Path("reduce_row_product_f32_5x7.lowered.spv"))

    def test_parses_flow_identity_as_load_store(self):
        self.assertEqual(
            parse_case(pathlib.Path("load_store_f32_flow_5x7.lowered.spv")),
            {
                "case": "load_store",
                "dtype": "f32",
                "m": "5",
                "n": "7",
                "k": "0",
            },
        )

    def test_perf_exclusion_pattern_keeps_reduce_and_drops_flow(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = pathlib.Path(temp_dir)
            reduce_shader = root / "reduce_row_add_f32_5x8.lowered.spv"
            flow_shader = root / "load_store_f32_flow_5x7.lowered.spv"
            reduce_shader.touch()
            flow_shader.touch()
            self.assertEqual(
                select_shaders(root, [], ["*flow*.lowered.spv"], 0),
                [reduce_shader],
            )

    def test_reduce_runner_receives_axis_and_operation(self):
        shader = pathlib.Path("reduce_column_max_f32_5x8.lowered.spv")
        with mock.patch("run_function_tests.subprocess.run") as run:
            run.return_value = mock.Mock(stdout="{}")
            run_case("vk_hw_runner", shader, 1, 2)
        command = run.call_args.args[0]
        self.assertEqual(command[command.index("--axis") + 1], "column")
        self.assertEqual(command[command.index("--reduce-op") + 1], "max")


class ExtensionFreeLoweringModeTest(unittest.TestCase):
    def test_uses_extension_free_packed_mode(self):
        self.assertEqual(
            lowering_pass_for_stem("reduce_row_add_f32_5x8"),
            "--hw-lower-to-standard-extension-free",
        )

    def test_uses_extension_free_scalar_mode(self):
        self.assertEqual(
            lowering_pass_for_stem("reduce_row_add_f32_scalar_5x7"),
            "--hw-lower-to-standard-extension-free=scalar",
        )


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
