#!/usr/bin/env python3
# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

import json
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
from build_shaders import has_spec_constant_residue
from build_shaders import load_specialization_cases
from build_shaders import lowering_pass_for_stem
from build_shaders import output_dir_for_shader
from build_shaders import specialization_optimizer_args
from build_shaders import specialization_integer_types
from build_shaders import SpecializationCase
from build_shaders import validate_specialization_cases
from build_shaders import validate_specialization_metadata_ownership
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

    def test_parses_descriptive_flow_identity_as_load_store(self):
        path = pathlib.Path(
            "load_store_f16_flow_material_payload_17x25.lowered.spv"
        )
        self.assertEqual(
            parse_case(path),
            {
                "case": "load_store",
                "dtype": "f16",
                "a_dtype": "f16",
                "b_dtype": "f16",
                "c_dtype": "f16",
                "accum_dtype": "f16",
                "m": "17",
                "n": "25",
                "k": "0",
            },
        )
        self.assertEqual(shape_string(parse_case(path)), "17x25")

    def test_parses_production_flow_workload_families(self):
        cases = [
            (
                "matmul_f32_flow_multi_call_graph_48x32x64.lowered.spv",
                "matmul",
                ("48", "32", "64"),
            ),
            (
                "vecmatmuladd_f16_flow_neural_material_128x64.lowered.spv",
                "vecmatmuladd",
                ("1", "64", "128"),
            ),
            (
                "mlp_f16_flow_material_classifier_16x64_64x32_32x8.lowered.spv",
                "mlp",
                ("1", "8", "0"),
            ),
            (
                "multiops_f32_flow_call_graph_32x16x24.lowered.spv",
                "multiops",
                ("32", "16", "24"),
            ),
        ]
        for name, expected_case, expected_shape in cases:
            with self.subTest(name=name):
                result = parse_case(pathlib.Path(name))
                self.assertEqual(result["case"], expected_case)
                self.assertEqual(
                    (result["m"], result["n"], result["k"]),
                    expected_shape,
                )

    def test_perf_exclusion_pattern_keeps_reduce_and_drops_flow(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = pathlib.Path(temp_dir)
            reduce_shader = root / "reduce_row_add_f32_5x8.lowered.spv"
            flow_shader = root / "load_store_f32_flow_5x7.lowered.spv"
            descriptive_flow_shader = (
                root
                / "matmul_f32_flow_visibility_tiles_24x40x56.lowered.spv"
            )
            reduce_shader.touch()
            flow_shader.touch()
            descriptive_flow_shader.touch()
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

    def test_shared_payload_flow_uses_default_packed_recovery(self):
        self.assertEqual(
            lowering_pass_for_stem(
                "multiops_f32_flow_shared_payload_24x24x24"
            ),
            "--hw-lower-to-standard-extension-free",
        )


class SpecializationCaseTest(unittest.TestCase):
    def test_rejects_orphan_and_stage_ambiguous_metadata(self):
        with tempfile.TemporaryDirectory() as temp:
            root = pathlib.Path(temp)
            orphan = root / "orphan.spec.json"
            orphan.write_text('{"variants": []}', encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "orphan"):
                validate_specialization_metadata_ownership(root, ())

            orphan.unlink()
            compute = root / "shared.comp"
            fragment = root / "shared.frag"
            compute.touch()
            fragment.touch()
            compute.with_suffix(".spec.json").write_text(
                '{"variants": []}', encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "ambiguous"):
                validate_specialization_metadata_ownership(
                    root, (compute, fragment))

    def test_shader_without_metadata_uses_one_default_case(self):
        shader = pathlib.Path("load_store_f32_5x7.comp")
        self.assertEqual(
            load_specialization_cases(shader),
            (SpecializationCase("load_store_f32_5x7"),),
        )
        self.assertEqual(specialization_optimizer_args(
            SpecializationCase("load_store_f32_5x7")), [
                "--freeze-spec-const",
                "--fold-spec-const-op-composite",
            ])

    def test_metadata_loads_default_partial_and_full_cases(self):
        with tempfile.TemporaryDirectory() as temp:
            root = pathlib.Path(temp)
            shader = root / "load_store_f32_flow_spec_controls.comp"
            shader.touch()
            shader.with_suffix(".spec.json").write_text(json.dumps({
                "variants": [
                    {
                        "artifact_stem":
                            "load_store_f32_flow_specdefault_5x7",
                        "values": {},
                    },
                    {
                        "artifact_stem":
                            "load_store_f32_flow_specpartial_7x7",
                        "values": {"2": 1, "0": 7},
                    },
                    {
                        "artifact_stem":
                            "load_store_f32_flow_specfull_8x6",
                        "values": {"0": 8, "1": 6, "2": 1},
                    },
                ],
            }), encoding="utf-8")

            cases = load_specialization_cases(shader)

        self.assertEqual(cases, (
            SpecializationCase(
                "load_store_f32_flow_specdefault_5x7"),
            SpecializationCase(
                "load_store_f32_flow_specpartial_7x7", ((0, 7), (2, 1))),
            SpecializationCase(
                "load_store_f32_flow_specfull_8x6",
                ((0, 8), (1, 6), (2, 1))),
        ))
        self.assertEqual(specialization_optimizer_args(cases[1]), [
            "--set-spec-const-default-value",
            "0:7 2:1",
            "--freeze-spec-const",
            "--fold-spec-const-op-composite",
        ])

    def test_metadata_rejects_invalid_variants(self):
        invalid_variants = [
            [],
            [{"artifact_stem": "../escape", "values": {}}],
            [{"artifact_stem": "valid", "values": {"-1": 2}}],
            [{"artifact_stem": "valid", "values": {"01": 2}}],
            [{"artifact_stem": "valid", "values": {"4294967296": 2}}],
            [{"artifact_stem": "valid", "values": {"0": 1.5}}],
            [
                {"artifact_stem": "duplicate", "values": {}},
                {"artifact_stem": "duplicate", "values": {"0": 1}},
            ],
        ]
        for variants in invalid_variants:
            with self.subTest(variants=variants), tempfile.TemporaryDirectory() as temp:
                shader = pathlib.Path(temp) / "case.comp"
                shader.touch()
                shader.with_suffix(".spec.json").write_text(
                    json.dumps({"variants": variants}), encoding="utf-8")
                with self.assertRaises(ValueError):
                    load_specialization_cases(shader)

    def test_compile_builds_all_specialization_variants_from_one_spirv(self):
        with tempfile.TemporaryDirectory() as temp:
            root = pathlib.Path(temp)
            shader = root / "vecmatmul_f32_flow_spec_shape.comp"
            shader.touch()
            cases = (
                SpecializationCase(
                    "vecmatmul_f32_flow_specdefault_5x3"),
                SpecializationCase(
                    "vecmatmul_f32_flow_specpartial_7x3", ((0, 7),)),
            )
            for case in cases:
                (root / f"{case.artifact_stem}.lowered.spvasm").write_text(
                    "OpCapability Shader\n", encoding="utf-8")
            (root / f"{shader.stem}.hw.spvasm").write_text(
                "OpDecorate %inner SpecId 0\n"
                "%int = OpTypeInt 32 1\n"
                "%inner = OpSpecConstant %int 5\n",
                encoding="utf-8",
            )

            with mock.patch("build_shaders.run") as run:
                compile_hw_shader(
                    "glslang", "spirv-opt", "spirv-val", "spirv-dis",
                    shader, root, "vulkan1.3", cases)

        commands = [call.args[0] for call in run.call_args_list]
        self.assertEqual(len(commands), 8)
        self.assertEqual(commands[1][0], "spirv-dis")
        self.assertTrue(str(commands[1][-1]).endswith(".hw.spvasm"))
        self.assertEqual(commands[2][1:5], [
            "--freeze-spec-const",
            "--fold-spec-const-op-composite",
            "--hw-lower-to-standard-extension-free",
            "--fold-spec-const-op-composite",
        ])
        self.assertEqual(commands[5][1:7], [
            "--set-spec-const-default-value",
            "0:7",
            "--freeze-spec-const",
            "--fold-spec-const-op-composite",
            "--hw-lower-to-standard-extension-free",
            "--fold-spec-const-op-composite",
        ])
        self.assertTrue(str(commands[2][-1]).endswith(
            "vecmatmul_f32_flow_specdefault_5x3.lowered.spv"))
        self.assertTrue(str(commands[5][-1]).endswith(
            "vecmatmul_f32_flow_specpartial_7x3.lowered.spv"))

    def test_variant_name_cannot_change_source_lowering_mode(self):
        with tempfile.TemporaryDirectory() as temp:
            root = pathlib.Path(temp)
            shader = root / "load_store_f32_scalar_spec_controls.comp"
            shader.touch()
            case = SpecializationCase("load_store_f32_specdefault_5x7")
            (root / f"{case.artifact_stem}.lowered.spvasm").write_text(
                "OpCapability Shader\n", encoding="utf-8")

            with mock.patch("build_shaders.run") as run:
                compile_hw_shader(
                    "glslang", "spirv-opt", "spirv-val", "spirv-dis",
                    shader, root, "vulkan1.3", (case,))

        lower_command = run.call_args_list[1].args[0]
        self.assertIn(
            "--hw-lower-to-standard-extension-free=scalar", lower_command)

    def test_parses_and_validates_integer_spec_constant_overrides(self):
        asm = (
            "OpDecorate %signed SpecId 0\n"
            "OpDecorate %unsigned SpecId 1\n"
            "%int = OpTypeInt 32 1\n"
            "%ushort = OpTypeInt 16 0\n"
            "%signed = OpSpecConstant %int 5\n"
            "%unsigned = OpSpecConstant %ushort 7\n"
        )
        self.assertEqual(
            specialization_integer_types(asm),
            {0: (32, True), 1: (16, False)},
        )
        validate_specialization_cases((
            SpecializationCase("minimum", ((0, -2147483648), (1, 0))),
            SpecializationCase("maximum", ((0, 2147483647), (1, 65535))),
        ), asm, "shader.comp")

    def test_rejects_unknown_non_integer_and_out_of_range_overrides(self):
        asm = (
            "OpDecorate %signed SpecId 0\n"
            "OpDecorate %floating SpecId 1\n"
            "%int = OpTypeInt 32 1\n"
            "%float = OpTypeFloat 32\n"
            "%signed = OpSpecConstant %int 5\n"
            "%floating = OpSpecConstant %float 1\n"
        )
        invalid_cases = (
            (SpecializationCase("unknown", ((99, 1),)), "SpecId 99"),
            (SpecializationCase("floating", ((1, 1),)), "non-integer SpecId 1"),
            (SpecializationCase("overflow", ((0, 2147483648),)), "outside i32"),
        )
        for case, message in invalid_cases:
            with self.subTest(case=case), self.assertRaisesRegex(
                    ValueError, message):
                validate_specialization_cases((case,), asm, "shader.comp")

    def test_compile_rejects_remaining_spec_constant_residue(self):
        with tempfile.TemporaryDirectory() as temp:
            root = pathlib.Path(temp)
            shader = root / "load_store_f32_5x7.comp"
            shader.touch()
            (root / "load_store_f32_5x7.lowered.spvasm").write_text(
                "%value = OpSpecConstant %int 5\n", encoding="utf-8")
            with mock.patch("build_shaders.run"):
                with self.assertRaisesRegex(
                        RuntimeError, "specialization constant remains"):
                    compile_hw_shader(
                        "glslang", "spirv-opt", "spirv-val", "spirv-dis",
                        shader, root, "vulkan1.3")

    def test_spec_constant_residue_detection_is_opcode_aware(self):
        self.assertTrue(has_spec_constant_residue(
            "%value = OpSpecConstant %uint 4\n"))
        self.assertTrue(has_spec_constant_residue(
            "%value = OpSpecConstantOp %uint IAdd %a %b\n"))
        self.assertFalse(has_spec_constant_residue(
            'OpName %value "OpSpecConstant"\n'
            "OpConstant %uint 4 ; OpSpecConstant\n"))


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
        self.assertEqual(commands[1][1:5], [
            "--freeze-spec-const",
            "--fold-spec-const-op-composite",
            "--hw-lower-to-standard-extension-free",
            "--fold-spec-const-op-composite",
        ])

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

    def test_detects_replicated_composite_residue(self):
        for assembly in (
                "OpCapability ReplicatedCompositesEXT\n",
                'OpExtension "SPV_EXT_replicated_composites"\n',
                'OpSourceExtension "GL_EXT_replicated_composites"\n',
                "%c = OpConstantCompositeReplicateEXT %v4 %one\n",
                "%s = OpSpecConstantCompositeReplicateEXT %v4 %spec\n",
                "%v = OpCompositeConstructReplicateEXT %v4 %value\n"):
            with self.subTest(assembly=assembly):
                self.assertTrue(has_hw_residue(assembly))

    def test_replicated_composite_names_do_not_cause_false_positives(self):
        self.assertFalse(has_hw_residue(
            'OpExtension "SPV_EXT_spec_constant_composites"\n'
            'OpSourceExtension "GL_EXT_spec_constant_composites"\n'
            'OpName %value "OpCompositeConstructReplicateEXT"\n'
            '; OpCapability ReplicatedCompositesEXT\n'))

    def test_unsupported_contract_can_check_hw_independently(self):
        assembly = """\
OpCapability ReplicatedCompositesEXT
OpExtension "SPV_EXT_replicated_composites"
%value = OpCompositeConstructReplicateEXT %v4 %scalar
"""
        self.assertTrue(has_hw_residue(assembly))
        self.assertFalse(has_hw_residue(
            assembly, include_replicated_composites=False))

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
    def test_production_flow_compile_requests_vulkan_target(self):
        with tempfile.TemporaryDirectory() as temp:
            out_dir = pathlib.Path(temp)
            shader = out_dir / "matmul_f32_flow_visibility_tiles_24x40x56.comp"
            shader.touch()
            (out_dir / "matmul_f32_flow_visibility_tiles_24x40x56.lowered.spvasm").write_text(
                "OpCapability Shader\n", encoding="utf-8"
            )

            with mock.patch("build_shaders.run") as run:
                compile_hw_shader(
                    "glslang", "spirv-opt", "spirv-val", "spirv-dis",
                    shader, out_dir, "vulkan1.3")

        compile_command = run.call_args_list[0].args[0]
        self.assertEqual(
            compile_command[:4],
            ["glslang", "--target-env", "vulkan1.3", "-V"],
        )

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
        self.assertEqual(commands[1][1:5], [
            "--freeze-spec-const",
            "--fold-spec-const-op-composite",
            "--hw-lower-to-standard-extension-free=scalar",
            "--fold-spec-const-op-composite",
        ])
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
