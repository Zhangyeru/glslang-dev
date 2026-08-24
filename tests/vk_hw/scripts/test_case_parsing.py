#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import pathlib
import tempfile
import unittest
from unittest import mock

from run_function_tests import case_work
from run_function_tests import parse_case
from run_function_tests import run_case
from run_function_tests import shape_string
from run_function_tests import write_reports
from run_perf_tests import run_shader
from run_perf_tests import write_outputs


class CaseParsingTest(unittest.TestCase):
    def test_legacy_dtype_is_shorthand_for_all_operands(self):
        case = parse_case(pathlib.Path("matmul_f32_8x8x8.lowered.spv"))
        self.assertEqual(case["dtype"], "f32")
        self.assertEqual(case["a_dtype"], "f32")
        self.assertEqual(case["b_dtype"], "f32")
        self.assertEqual(case["c_dtype"], "f32")
        self.assertEqual(case["accum_dtype"], "f32")

    def test_mixed_matmul_filename(self):
        case = parse_case(pathlib.Path("matmul_i8xu8_to_i32_5x7x3.lowered.spv"))
        self.assertEqual(case["case"], "matmul")
        self.assertEqual(case["a_dtype"], "i8")
        self.assertEqual(case["b_dtype"], "u8")
        self.assertEqual(case["c_dtype"], "i32")
        self.assertEqual(case["accum_dtype"], "i32")
        self.assertEqual((case["m"], case["n"], case["k"]), ("5", "7", "3"))

    def test_mixed_vector_matmul_filename(self):
        case = parse_case(pathlib.Path("vecmatmul_i8xu8_to_i32_4x4.lowered.spv"))
        self.assertEqual(case["case"], "vecmatmul")
        self.assertEqual((case["a_dtype"], case["b_dtype"], case["accum_dtype"]), ("i8", "u8", "i32"))
        self.assertEqual((case["m"], case["n"], case["k"]), ("1", "4", "4"))

    def test_converted_bias_dtype_is_parsed_independently(self):
        case = parse_case(
            pathlib.Path("vecmatmuladd_f16xf16_to_f32_biasconvert_10x3.lowered.spv"))
        self.assertEqual(case["case"], "vecmatmuladd")
        self.assertEqual((case["a_dtype"], case["b_dtype"], case["c_dtype"], case["accum_dtype"]),
                         ("f16", "f16", "f16", "f32"))

    def test_converted_matrix_c_dtype_is_parsed_independently(self):
        case = parse_case(
            pathlib.Path("matmul_f16xf16_to_f32_cconvert_7x5x3.lowered.spv"))
        self.assertEqual(case["case"], "matmul")
        self.assertEqual((case["a_dtype"], case["b_dtype"], case["c_dtype"],
                          case["accum_dtype"]),
                         ("f16", "f16", "f16", "f32"))

    def test_every_dtype_is_accepted_for_load_store_and_reduce(self):
        for dtype in ("f16", "f32", "i8", "u8", "i16", "u16", "i32", "u32"):
            with self.subTest(dtype=dtype):
                load = parse_case(pathlib.Path(f"load_store_{dtype}_3x5.lowered.spv"))
                reduce = parse_case(pathlib.Path(f"reduce_row_add_{dtype}_3x5.lowered.spv"))
                self.assertEqual(load["accum_dtype"], dtype)
                self.assertEqual(reduce["a_dtype"], dtype)

    def test_64_bit_dtypes_are_rejected(self):
        for dtype in ("f64", "i64", "u64"):
            with self.subTest(dtype=dtype):
                with self.assertRaises(ValueError):
                    parse_case(pathlib.Path(f"load_store_{dtype}_3x5.lowered.spv"))
                with self.assertRaises(ValueError):
                    parse_case(pathlib.Path(f"matmul_f16xf32_to_{dtype}_3x5x7.lowered.spv"))

    def test_scalar_broadcast_identity_case_keeps_non_aligned_shape(self):
        case = parse_case(
            pathlib.Path("load_store_f32_scalar_5x7.lowered.spv"))
        self.assertEqual(case["case"], "load_store")
        self.assertEqual(case["dtype"], "f32")
        self.assertEqual((case["m"], case["n"]), ("5", "7"))

    def test_direct_matmul_regression_variants(self):
        for variant in ("shared_load", "value_arg"):
            with self.subTest(variant=variant):
                case = parse_case(pathlib.Path(
                    f"matmul_{variant}_f16_8x8x8.lowered.spv"))
                self.assertEqual(case["case"], "matmul")
                self.assertEqual(case["dtype"], "f16")
                self.assertEqual((case["m"], case["n"], case["k"]),
                                 ("8", "8", "8"))

    def test_two_layer_mlp_filename_keeps_odd_tail_dimensions(self):
        case = parse_case(
            pathlib.Path("mlp_f16_3x17_17x7.lowered.spv"))
        self.assertEqual(case["case"], "mlp")
        self.assertEqual(case["layer_dims"], ["3", "17", "7"])
        self.assertEqual((case["m"], case["n"], case["k"]),
                         ("1", "7", "0"))
        self.assertEqual(case_work(case), 3 * 17 + 17 * 7)
        self.assertEqual(shape_string(case), "3x17, 17x7")

    def test_four_layer_mlp_filename(self):
        case = parse_case(pathlib.Path("mlp_f16_8x48_48x8_8x48_48x4.lowered.spv"))
        self.assertEqual(case["case"], "mlp")
        self.assertEqual(case["layer_dims"], ["8", "48", "8", "48", "4"])
        self.assertEqual((case["m"], case["n"], case["k"]), ("1", "4", "0"))
        self.assertEqual((case["dtype"], case["a_dtype"], case["b_dtype"], case["c_dtype"],
                          case["accum_dtype"]), ("f16", "f16", "f16", "f16", "f16"))
        self.assertEqual(case_work(case), 8 * 48 + 48 * 8 + 8 * 48 + 48 * 4)
        self.assertEqual(shape_string(case), "8x48, 48x8, 8x48, 48x4")

    def test_mixed_mlp_tracks_bias_accumulator_and_activation_types(self):
        case = parse_case(pathlib.Path(
            "mlp_f16xf16_to_f32_biasconvert_10x64_64x16.lowered.spv"))
        self.assertEqual(case["case"], "mlp")
        self.assertEqual(case["layer_dims"], ["10", "64", "16"])
        self.assertEqual(
            (case["a_dtype"], case["b_dtype"], case["c_dtype"],
             case["accum_dtype"], case["activation_dtype"]),
            ("f16", "f16", "f16", "f32", "f16"),
        )
        self.assertTrue(case["packed_mlp_params"])

    def test_other_mixed_mlp_shape_keeps_separate_parameter_buffers(self):
        case = parse_case(pathlib.Path(
            "mlp_f16xf16_to_f32_biasconvert_8x32_32x4.lowered.spv"))
        self.assertEqual(case["layer_dims"], ["8", "32", "4"])
        self.assertFalse(case["packed_mlp_params"])

    def test_non_biasconvert_mlp_keeps_separate_parameter_buffers(self):
        case = parse_case(pathlib.Path(
            "mlp_f16xf16_to_f32_10x64_64x16.lowered.spv"))
        self.assertEqual(case["c_dtype"], "f32")
        self.assertFalse(case["packed_mlp_params"])

    def test_five_layer_mlp_filename(self):
        case = parse_case(pathlib.Path("mlp_f16_8x48_48x8_8x48_48x8_8x4.lowered.spv"))
        self.assertEqual(case["layer_dims"], ["8", "48", "8", "48", "8", "4"])
        self.assertEqual((case["m"], case["n"], case["k"]), ("1", "4", "0"))
        self.assertEqual(case_work(case), 8 * 48 + 48 * 8 + 8 * 48 + 48 * 8 + 8 * 4)
        self.assertEqual(shape_string(case), "8x48, 48x8, 8x48, 48x8, 8x4")

    def test_five_layer_2_1_2_mlp_filename(self):
        case = parse_case(pathlib.Path("mlp_f16_8x48_48x8_8x8_8x8_8x4.lowered.spv"))
        self.assertEqual(case["case"], "mlp")
        self.assertEqual(case["layer_dims"], ["8", "48", "8", "8", "8", "4"])
        self.assertEqual((case["m"], case["n"], case["k"]), ("1", "4", "0"))
        self.assertEqual(case_work(case), 8 * 48 + 48 * 8 + 8 * 8 + 8 * 8 + 8 * 4)
        self.assertEqual(shape_string(case), "8x48, 48x8, 8x8, 8x8, 8x4")

    def test_five_layer_1_2_1_mlp_filename(self):
        case = parse_case(pathlib.Path("mlp_f16_8x48_48x8_8x8_8x48_48x4.lowered.spv"))
        self.assertEqual(case["case"], "mlp")
        self.assertEqual(case["layer_dims"], ["8", "48", "8", "8", "48", "4"])
        self.assertEqual((case["m"], case["n"], case["k"]), ("1", "4", "0"))
        self.assertEqual(case_work(case), 8 * 48 + 48 * 8 + 8 * 8 + 8 * 48 + 48 * 4)
        self.assertEqual(shape_string(case), "8x48, 48x8, 8x8, 8x48, 48x4")

    def test_five_layer_1_2_2_mlp_filename(self):
        case = parse_case(pathlib.Path("mlp_f16_8x8_8x48_48x8_8x48_48x4.lowered.spv"))
        self.assertEqual(case["case"], "mlp")
        self.assertEqual(case["layer_dims"], ["8", "8", "48", "8", "48", "4"])
        self.assertEqual((case["m"], case["n"], case["k"]), ("1", "4", "0"))
        self.assertEqual(case_work(case), 8 * 8 + 8 * 48 + 48 * 8 + 8 * 48 + 48 * 4)
        self.assertEqual(shape_string(case), "8x8, 8x48, 48x8, 8x48, 48x4")

    def test_mlp_filename_rejects_disconnected_layers(self):
        for name in (
            "mlp_f16_8x48_47x8_8x4.lowered.spv",
            "mlp_f16_8x48_48x8_7x48_48x4.lowered.spv",
        ):
            with self.subTest(name=name), self.assertRaisesRegex(ValueError, "inconsistent mlp dimensions"):
                parse_case(pathlib.Path(name))

    def test_mlp_filename_rejects_zero_dimensions(self):
        with self.assertRaisesRegex(ValueError, "dimensions must be non-zero"):
            parse_case(pathlib.Path("mlp_f16_8x48_48x0.lowered.spv"))

    @mock.patch("run_function_tests.subprocess.run", return_value=mock.Mock(stdout="{}"))
    def test_function_runner_passes_generic_mlp_dimensions(self, subprocess_run):
        run_case("runner", pathlib.Path("mlp_f16_8x48_48x8_8x48_48x4.lowered.spv"), 1, 2)
        cmd = subprocess_run.call_args.args[0]
        self.assertEqual(cmd[cmd.index("--layer-dims") + 1], "8,48,8,48,4")
        self.assertFalse(any(dim in cmd for dim in ("--d0", "--d1", "--d2", "--d3")))

    @mock.patch("run_function_tests.subprocess.run", return_value=mock.Mock(stdout="{}"))
    def test_function_runner_passes_mixed_mlp_activation_dtype(self, subprocess_run):
        run_case(
            "runner",
            pathlib.Path(
                "mlp_f16xf16_to_f32_biasconvert_10x64_64x16.lowered.spv"),
            1,
            2,
        )
        cmd = subprocess_run.call_args.args[0]
        self.assertEqual(cmd[cmd.index("--activation-dtype") + 1], "f16")
        self.assertIn("--packed-mlp-params", cmd)

    @mock.patch("run_perf_tests.subprocess.run", return_value=mock.Mock(stdout="{}"))
    def test_performance_runner_passes_generic_mlp_dimensions(self, subprocess_run):
        meta = parse_case(pathlib.Path("mlp_f16_8x48_48x8_8x48_48x8_8x4.lowered.spv"))
        run_shader("runner", pathlib.Path("case.spv"), meta, 1, 2)
        cmd = subprocess_run.call_args.args[0]
        self.assertEqual(cmd[cmd.index("--layer-dims") + 1], "8,48,8,48,8,4")
        self.assertFalse(any(dim in cmd for dim in ("--d0", "--d1", "--d2", "--d3")))

    @mock.patch("run_perf_tests.subprocess.run", return_value=mock.Mock(stdout="{}"))
    def test_performance_runner_passes_mixed_mlp_activation_dtype(self, subprocess_run):
        meta = parse_case(pathlib.Path(
            "mlp_f16xf16_to_f32_biasconvert_10x64_64x16.lowered.spv"))
        run_shader("runner", pathlib.Path("case.spv"), meta, 1, 2)
        cmd = subprocess_run.call_args.args[0]
        self.assertEqual(cmd[cmd.index("--activation-dtype") + 1], "f16")
        self.assertIn("--packed-mlp-params", cmd)

    def test_structured_skip_is_reported_without_numeric_performance(self):
        functional = {
            "shader": "typed.lowered.spv",
            "case": "matmul",
            "dtype": "i32",
            "a_dtype": "i8",
            "b_dtype": "u8",
            "c_dtype": "i32",
            "accum_dtype": "i32",
            "m": 4,
            "n": 4,
            "k": 4,
            "status": "skip",
            "skip_reason": "shaderInt8",
            "verify": "skip",
            "max_abs_error": 0.0,
            "max_rel_error": 0.0,
        }
        perf = {
            **functional,
            "axis": "",
            "reduce_op": "",
            "layer_dims": [],
            "lowered_ns": None,
            "baseline_ns": None,
            "ratio": None,
            "gflops": None,
            "gops_avg": None,
            "baseline_verify": "skip",
        }
        perf.pop("max_abs_error")
        perf.pop("max_rel_error")
        with tempfile.TemporaryDirectory() as temp:
            root = pathlib.Path(temp)
            write_reports([functional], root / "functional")
            write_outputs([perf], root / "perf.json")
            self.assertIn("shaderInt8", (root / "functional" / "functional.md").read_text(encoding="utf-8"))
            self.assertIn("| skip |", (root / "perf.md").read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
