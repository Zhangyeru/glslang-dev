#!/usr/bin/env python3
# Copyright (C) 2026 The Khronos Group Inc.
# SPDX-License-Identifier: BSD-3-Clause

"""Guard, oracle and parameter-size checks for the large inference fixtures."""

import struct
import unittest

from large_float_cases import cases as float_cases
from large_typed_cases import cases as typed_cases
from run_large_tests import verify_bytes


class LargeReferenceTest(unittest.TestCase):
    def test_case_contracts(self):
        for case in float_cases() + typed_cases():
            with self.subTest(case=case["name"]):
                datasets = case["datasets"]()
                self.assertGreaterEqual(len(datasets), 3)
                self.assertEqual(len(datasets), len({d["label"] for d in datasets}))
                parameter_width = 1 if "s8" in case["features"] else 2 if "s16" in case["features"] else 4
                for dataset in datasets:
                    self.assertEqual(case["parameter_elements"] * parameter_width, len(dataset["b"]))
                    self.assertEqual(len(dataset["initial"]), len(dataset["expected"]))
                    self.assertEqual(dataset["initial"][:4], dataset["expected"][:4])
                    self.assertEqual(dataset["initial"][-4:], dataset["expected"][-4:])
                    self.assertNotEqual(dataset["initial"][4:-4], dataset["expected"][4:-4])
                    verify_bytes(dataset["expected"], dataset["expected"], dataset["initial"],
                                 dataset["format"], dataset["atol"], dataset["rtol"])

    def test_float_tolerance_never_hides_guards_or_unwritten_checkpoints(self):
        initial = struct.pack("<4f", 31, 31, 31, 31)
        expected = struct.pack("<4f", 31, 1, 31, 31)
        near = struct.pack("<4f", 31, 1.000001, 31, 31)
        verify_bytes(near, expected, initial, "f", 1e-4, 1e-4)
        for lane in (0, 2, 3):
            values = [31, 1, 31, 31]
            values[lane] += 0.00001
            with self.subTest(lane=lane), self.assertRaises(AssertionError):
                verify_bytes(struct.pack("<4f", *values), expected, initial, "f", 1e-4, 1e-4)
        with self.assertRaises(AssertionError):
            verify_bytes(struct.pack("<4f", 31, float("nan"), 31, 31), expected, initial, "f", 1e-4, 1e-4)

    def test_integer_results_are_exact(self):
        initial = struct.pack("<3i", 31, 31, 31)
        expected = struct.pack("<3i", 31, -123456, 31)
        with self.assertRaises(AssertionError):
            verify_bytes(struct.pack("<3i", 31, -123455, 31), expected, initial, "i", 10, 10)


if __name__ == "__main__":
    unittest.main()
