#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import pathlib
import tempfile
import unittest
from unittest import mock

from build_shaders import artifact_stem_for_shader
from build_shaders import compare_glsl_to_golden
from build_shaders import compile_hw_shader
from build_shaders import compile_unsupported_shader
from build_shaders import decompile_spv_to_glsl
from build_shaders import ensure_golden_comparison_ready
from build_shaders import find_hw_shaders
from build_shaders import has_hw_residue
from build_shaders import lowering_pass_for_stem
from build_shaders import output_dir_for_shader
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
                "a_dtype": "f16",
                "b_dtype": "f16",
                "c_dtype": "f16",
                "accum_dtype": "f16",
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
                "a_dtype": "f32",
                "b_dtype": "f32",
                "c_dtype": "f32",
                "accum_dtype": "f32",
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
                "a_dtype": "f32",
                "b_dtype": "f32",
                "c_dtype": "f32",
                "accum_dtype": "f32",
                "m": "5",
                "n": "7",
                "k": "0",
            },
        )
        self.assertEqual(shape_string(parse_case(pathlib.Path("load_store_f32_flow_5x7.lowered.spv"))), "5x7")

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

    def test_mixed_runner_receives_all_operand_types(self):
        shader = pathlib.Path("matmul_i8xu8_to_i32_4x4x4.lowered.spv")
        with mock.patch("run_function_tests.subprocess.run") as run:
            run.return_value = mock.Mock(stdout="{}")
            run_case("vk_hw_runner", shader, 1, 2)
        command = run.call_args.args[0]
        self.assertEqual(command[command.index("--a-dtype") + 1], "i8")
        self.assertEqual(command[command.index("--b-dtype") + 1], "u8")
        self.assertEqual(command[command.index("--c-dtype") + 1], "i32")
        self.assertEqual(command[command.index("--accum-dtype") + 1], "i32")


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

    def test_scalar_broadcast_case_uses_extension_free_scalar_mode(self):
        self.assertEqual(
            lowering_pass_for_stem("load_store_f32_scalar_5x7"),
            "--hw-lower-to-standard-extension-free=scalar",
        )


class ShaderStageDiscoveryTest(unittest.TestCase):
    def test_discovers_compute_and_fragment_shaders_only(self):
        with tempfile.TemporaryDirectory() as temp:
            shader_dir = pathlib.Path(temp)
            fragment = shader_dir / "a.frag"
            compute = shader_dir / "b.comp"
            unsupported_stage = shader_dir / "c.vert"
            for shader in (fragment, compute, unsupported_stage):
                shader.touch()

            self.assertEqual(find_hw_shaders(shader_dir), [fragment, compute])

    def test_fragment_artifacts_are_stage_qualified_and_isolated(self):
        out_dir = pathlib.Path("spv")
        compute = pathlib.Path("load_store_f32.comp")
        fragment = pathlib.Path("neural.frag")

        self.assertEqual(artifact_stem_for_shader(compute), "load_store_f32")
        self.assertEqual(output_dir_for_shader(out_dir, compute), out_dir)
        self.assertEqual(artifact_stem_for_shader(fragment), "neural.frag")
        self.assertEqual(
            output_dir_for_shader(out_dir, fragment), out_dir / "graphics")

    def test_fragment_compile_uses_graphics_artifact_names(self):
        with tempfile.TemporaryDirectory() as temp:
            root = pathlib.Path(temp)
            shader = root / "neural.frag"
            shader.touch()
            out_dir = output_dir_for_shader(root / "spv", shader)
            out_dir.mkdir(parents=True)
            (out_dir / "neural.frag.lowered.spvasm").write_text(
                "OpCapability Shader\n", encoding="utf-8")

            with mock.patch("build_shaders.run") as run:
                compile_hw_shader(
                    "glslang", "spirv-opt", "spirv-val", "spirv-dis",
                    shader, out_dir, "vulkan1.3")

        commands = [call.args[0] for call in run.call_args_list]
        self.assertTrue(str(commands[0][-1]).endswith(
            "graphics/neural.frag.hw.spv"))
        self.assertTrue(str(commands[1][-1]).endswith(
            "graphics/neural.frag.lowered.spv"))
        self.assertEqual(
            commands[1][1], "--hw-lower-to-standard-extension-free")

    def test_recursive_decompile_finds_graphics_lowered_shader(self):
        with tempfile.TemporaryDirectory() as temp:
            root = pathlib.Path(temp)
            spv_dir = root / "spv"
            graphics_dir = spv_dir / "graphics"
            graphics_dir.mkdir(parents=True)
            (graphics_dir / "neural.frag.hw.spv").touch()
            (graphics_dir / "neural.frag.lowered.spv").touch()

            with mock.patch("build_shaders.subprocess.run",
                            return_value=mock.Mock(returncode=0)) as run:
                counts = decompile_spv_to_glsl(
                    "spirv-cross", spv_dir, root / "glsl")

        self.assertEqual(counts, (1, 0, 1))
        command = run.call_args.args[0]
        self.assertTrue(str(command[1]).endswith(
            "graphics/neural.frag.lowered.spv"))
        self.assertTrue(str(command[3]).endswith(
            "glsl/hw/neural.frag.lowered.glsl"))

    def test_compute_runner_selection_ignores_nested_fragment_artifact(self):
        with tempfile.TemporaryDirectory() as temp:
            spv_dir = pathlib.Path(temp)
            compute = spv_dir / "load_store_f32.lowered.spv"
            compute.touch()
            graphics_dir = spv_dir / "graphics"
            graphics_dir.mkdir()
            (graphics_dir / "neural.frag.lowered.spv").touch()

            self.assertEqual(select_shaders(spv_dir, [], [], 0), [compute])


class HwResidueDetectionTest(unittest.TestCase):
    def test_detects_hw_opcodes_only_in_opcode_position(self):
        for assembly in (
                "%map = OpTypeTensorMapHW 1\n",
                "OpCpAsyncCommitGroupHW\n"):
            with self.subTest(assembly=assembly):
                self.assertTrue(has_hw_residue(assembly))

        self.assertFalse(has_hw_residue(
            'OpName %value "OpTypeTensorMapHW Relreg"\n'
            'OpString "OpCpAsyncCommitGroupHW"\n'
            '; %map = OpTypeTensorMapHW 1\n'))

    def test_detects_hw_and_legacy_azd_module_declarations(self):
        for assembly in (
                "OpCapability CooperativeMatrixHW\n",
                "OpCapability CooperativeVectorAZD\n",
                'OpExtension "SPV_HW_neural_shader"\n',
                'OpExtension "SPV_AZD_neural_matrix"\n',
                'OpSourceExtension "GL_HW_neural_shader"\n',
                'OpSourceExtension "GL_AZD_cooperative_vector"\n'):
            with self.subTest(assembly=assembly):
                self.assertTrue(has_hw_residue(assembly))

    def test_does_not_mistake_khr_or_nv_cooperative_features_for_hw(self):
        assembly = """\
OpCapability CooperativeMatrixKHR
OpCapability CooperativeMatrixNV
OpExtension "SPV_KHR_cooperative_matrix"
OpExtension "SPV_NV_cooperative_matrix"
%khr = OpTypeCooperativeMatrixKHR %float %scope %rows %cols %use
%nv = OpTypeCooperativeMatrixNV %float %scope %rows %cols
"""
        self.assertFalse(has_hw_residue(assembly))

    def test_relreg_is_only_detected_on_selection_merge_operand(self):
        self.assertTrue(has_hw_residue(
            "OpSelectionMerge %merge Flatten|Relreg\n"))
        self.assertFalse(has_hw_residue(
            'OpName %merge "Relreg"\n'
            "OpSelectionMerge %merge None ; Relreg\n"
            "OpLoopMerge %merge %continue Relreg\n"))

    def test_semicolon_in_string_does_not_hide_following_debug_text(self):
        self.assertFalse(has_hw_residue(
            'OpName %value "ordinary; OpTypeTensorMapHW Relreg"\n'))


class EndToEndLoweringContractTest(unittest.TestCase):
    def test_success_output_is_validated_before_residue_is_checked(self):
        with tempfile.TemporaryDirectory() as temp:
            out_dir = pathlib.Path(temp)
            shader = out_dir / "load_store_f32_scalar_5x7.comp"
            shader.touch()
            (out_dir / "load_store_f32_scalar_5x7.lowered.spvasm").write_text(
                "OpCapability Shader\n", encoding="utf-8")

            with mock.patch("build_shaders.run") as run:
                compile_hw_shader(
                    "glslang", "spirv-opt", "spirv-val", "spirv-dis",
                    shader, out_dir, "vulkan1.3")

        commands = [call.args[0] for call in run.call_args_list]
        self.assertEqual(commands[1][1],
                         "--hw-lower-to-standard-extension-free=scalar")
        self.assertEqual(commands[2][0:3],
                         ["spirv-val", "--target-env", "vulkan1.3"])
        self.assertTrue(str(commands[2][-1]).endswith(".lowered.spv"))
        self.assertEqual(commands[3][0], "spirv-dis")

    def test_unsupported_residue_is_preserved_then_rejected_strictly(self):
        with tempfile.TemporaryDirectory() as temp:
            out_dir = pathlib.Path(temp)
            shader = out_dir / "tensor_map.comp"
            shader.touch()
            (out_dir / "tensor_map.unsupported.partial.spvasm").write_text(
                "%map = OpTypeTensorMapHW 1\n", encoding="utf-8")
            failure = mock.Mock(
                returncode=1,
                stdout="",
                stderr="extension-free HW lowering has no equivalent lowering",
            )

            with mock.patch("build_shaders.run") as run, \
                    mock.patch("build_shaders.subprocess.run",
                               return_value=failure) as strict_run:
                compile_unsupported_shader(
                    "glslang", "spirv-opt", "spirv-val", "spirv-dis",
                    shader, out_dir, "vulkan1.3")

        commands = [call.args[0] for call in run.call_args_list]
        self.assertEqual(commands[1][1], "--hw-lower-to-standard")
        self.assertEqual(commands[2][0:3],
                         ["spirv-val", "--target-env", "vulkan1.3"])
        strict_command = strict_run.call_args.args[0]
        self.assertEqual(strict_command[1],
                         "--hw-lower-to-standard-extension-free")

    def test_unsupported_case_must_retain_hw_residue_in_partial_mode(self):
        with tempfile.TemporaryDirectory() as temp:
            out_dir = pathlib.Path(temp)
            shader = out_dir / "tensor_map.comp"
            shader.touch()
            (out_dir / "tensor_map.unsupported.partial.spvasm").write_text(
                "OpCapability Shader\n", encoding="utf-8")

            with mock.patch("build_shaders.run"):
                with self.assertRaisesRegex(
                        RuntimeError, "unexpectedly removed every HW feature"):
                    compile_unsupported_shader(
                        "glslang", "spirv-opt", "spirv-val", "spirv-dis",
                        shader, out_dir, "vulkan1.3")


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
