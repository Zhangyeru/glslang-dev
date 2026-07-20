#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import pathlib
import tempfile
import unittest

from run_function_tests import parse_case
from run_function_tests import write_reports
from run_perf_tests import write_outputs


class CaseParsingTest(unittest.TestCase):
    def test_legacy_dtype_is_shorthand_for_all_operands(self):
        case = parse_case(pathlib.Path("matmul_f32_8x8x8.lowered.spv"))
        self.assertEqual(case["dtype"], "f32")
        self.assertEqual(case["a_dtype"], "f32")
        self.assertEqual(case["b_dtype"], "f32")
        self.assertEqual(case["accum_dtype"], "f32")

    def test_mixed_matmul_filename(self):
        case = parse_case(pathlib.Path("matmul_i8xu8_to_i32_5x7x3.lowered.spv"))
        self.assertEqual(case["case"], "matmul")
        self.assertEqual(case["a_dtype"], "i8")
        self.assertEqual(case["b_dtype"], "u8")
        self.assertEqual(case["accum_dtype"], "i32")
        self.assertEqual((case["m"], case["n"], case["k"]), ("5", "7", "3"))

    def test_mixed_vector_matmul_filename(self):
        case = parse_case(pathlib.Path("vecmatmul_i8xu8_to_i32_4x4.lowered.spv"))
        self.assertEqual(case["case"], "vecmatmul")
        self.assertEqual((case["a_dtype"], case["b_dtype"], case["accum_dtype"]), ("i8", "u8", "i32"))
        self.assertEqual((case["m"], case["n"], case["k"]), ("1", "4", "4"))

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

    def test_structured_skip_is_reported_without_numeric_performance(self):
        functional = {
            "shader": "typed.lowered.spv",
            "case": "matmul",
            "dtype": "i32",
            "a_dtype": "i8",
            "b_dtype": "u8",
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
