# Large inference shader regressions

These tests live in `tests/vk_hw` (the Vulkan test area). They exercise complete
inference graphs instead of padding small shaders with unused statements. The
fixtures contain meaningful preprocessing, learned projections, activations,
residuals, runtime controls and observable intermediate checkpoints. Parameters
and inputs are deterministic synthetic data; these are representative inference
algorithms, not claims to reproduce a trained model's task accuracy.

| Case | HW source lines | Input instructions | HW projection sites | MACs per invocation | Parameter elements | CPU datasets |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `residual_denoiser_f32` | 295 | 1162 | 16 | 16384 | 16896 float | 3 |
| `routed_experts_f32` | 162 | 684 | 7 | 4096 or 7168 | 10560 float | 18 |
| `material_mlp_f16_f32` | 240 | 920 | 8 | 18560 | 19008 half | 3 |
| `quantized_audio_i8` | 243 | 967 | 8 | 17536 | 18048 int8 | 3 |

The source/IR counts above are the initial current-checkout measurements. The
runner records actual counts every run and enforces conservative input floors
(1100/650/850/850 instructions), plus required HW operations. Generated SPIR-V
contains approximately 4,678–351,045 instructions depending on scenario and
lowering mode. MAC counts describe executed arithmetic; all three expert
branches are present in the module, but one selected branch runs per iteration.

## Scenarios and observable behavior

* Residual denoiser: temporal blending of current/history features followed by
  eight distinct 32→32→32 residual blocks. Confidence selects two correction
  strengths; the three datasets cover low, mixed and high confidence branches.
  Every block's complete 32-component state is checked before the final blend.
* Routed experts: three genuinely different 32→48→32 networks and a shared
  32→32 reconstruction head. Three input patterns execute every route 0/1/2 and
  one/two refinement iterations. Final feature lanes differ for every route
  and iteration choice; metadata alone is not a routing witness. Unexecuted
  checkpoint storage must retain its sentinel.
* Material MLP: eight projections 48→64→64→48→64→48→32→16→8, with FP16 parameters
  and FP32 activation/accumulation. Exposure preprocessing, ReLU/LeakyReLU,
  a 64-channel residual and output clamping are independently referenced.
* Quantized audio: eight projections 32→64→64→48→64→48→32→16→8. INT8 weights and
  bounded activations accumulate into INT32, followed by explicit rounding
  shifts, signed/ReLU clipping and a residual stage. Integer comparison is exact;
  all accumulator ranges and shift counts are defined.

All 344 intermediate typed-network outputs are checked. Each case uses three
SSBOs: immutable A inputs/controls, immutable B parameters and D output/checkpoint
storage. D includes exact first/last guards; A and B are downloaded and compared
byte-for-byte. Typed parameter allocations include alignment padding populated
with poison values. Every weight starts at a multiple of its column count, and
matrix Shape describes the whole padded allocation, making nonzero row offsets
legal rather than relying on out-of-bounds layer-local shapes.

## Independent references and validation

Each `.comp` has an independently written ordinary GLSL `_baseline.comp` and
an independent Python CPU reference in `scripts/large_float_cases.py` or
`scripts/large_typed_cases.py`. Both baseline and lowered results must agree
with the CPU result, not merely each other. Float comparisons use the declared
case tolerance for computed lanes; guards and untouched lanes are always exact.
CPU references round FP32 arithmetic explicitly. Inputs are asymmetric and
bounded, all layers have distinct parameters, and stage checkpoints make an
incorrect early stage visible even if a later activation clamps its output.

`run_large_tests.py` validates both frontend modules, audits the actual input
size and HW operations, then runs raw default, scalar and no-direct/no-fusion
lowering on the same input. Every output must pass `spirv-val` and the residue
check. Unexpected optimized-generation recovery is a failure. The 27 datasets
produce **108** baseline/mode numerical executions; no runtime skip counts as
numerical coverage.

The functional fixture records source copies, hashes, exact commands, per-stage
wall times, input/output instruction counts and buffers under
`build/tests/vk_hw/large/`. Performance requires matching source/tool/binary
hashes from the functional build, so it cannot silently time stale artifacts.

## GPU timing and gates

`vk_hw_language_tests --execute-timed` measures dispatch GPU timestamps after
20 warmups and 100 samples by default. It handles timestamp bit-width wrap,
orders repeated output writes and returns all three buffers for numerical
verification after timing. Only missing queried data-type/storage capabilities
can yield `skip`, with `skip_reason`; timing failures and numerical mismatches
are failures. The timing report includes device and driver metadata.

`vk_hw_large_perf` is serial and measures **81** lowered-mode/dataset ratios
against the independently compiled ordinary GLSL baseline. All measured ratios
are kept in `large/perf.json`; ratios above **5.0** fail the test. Existing
ordinary and boundary performance gates are unchanged. Generic is retained in
the measurements and gate even though it deliberately disables optimizations.

```bash
cmake --build build -j8
ctest --test-dir build -R '^vk_hw_large_reference_tests$' --output-on-failure
ctest --test-dir build -R '^vk_hw_large$' --output-on-failure
ctest --test-dir build -R '^vk_hw_large_perf$' --fixture-exclude-any '.*' --output-on-failure
ctest --test-dir build/External/spirv-tools --output-on-failure -j16
ctest --test-dir build --output-on-failure -j32
```

For a focused run, use the command shown by `ctest -N -V -R '^vk_hw_large$'`
and add `--case <name>`. Use `--perf` only after the corresponding functional
build, with the same output directory. A perf-only run does not rebuild inputs.

## Performance finding from the initial run

The four scenarios passed all 108 numerical executions. The first isolated
performance run found **24** mode/dataset ratios above 5.0, all in generic:

| Family | default maximum | scalar maximum | generic maximum | failing generic datasets |
| --- | ---: | ---: | ---: | ---: |
| residual denoiser | 0.488 | 1.407 | 5.526 | 3 |
| routed experts | 0.952 | 1.529 | 7.373 | 18 |
| mixed material MLP | 0.930 | 0.935 | 5.718 | 3 |
| quantized audio | 1.017 | 1.029 | 1.011 | 0 |

These are recorded failures, not accepted exceptions; `vk_hw_large_perf` remains
red until the slow path is addressed. Do not drop the generic mode, raise the
limit or overwrite the evidence with only passing cases. Current/recheck ratios
are in `large/perf.json` and may differ slightly with measurement variation.

The controlled mode comparison localizes the bottleneck to the generic packed
memory/value path once direct/fusion are disabled. The same source, dataset,
baseline and output contract pass numerically and meet the gate in default and
scalar modes. In generic, the vector-matrix path retains materialized packed
matrix values and additional memory/helper stages rather than direct parameter
streaming. For example, residual generic has 68 functions/75 loops versus 52/59
in default; mixed material generic has 35 functions/33 loops versus 10/0 in
scalar. Implementation owners are `LowerVectorMatrixMulPackedVec2`,
`GetOrCreateVectorMatmulPatternFunctionPackedVec2` and packed memory helpers in
`External/spirv-tools/source/opt/`. A separate RADV driver dump for routed expert 0 with two iterations confirmed
176 scratch-load and 14 scratch-store instructions in generic, versus none in
default. Both dump executions passed the same CPU and input-buffer checks.
There were no `storage:vgpr_spill` markers, so this is evidence of scratch
traffic from materialized values, not a claim of measured register spilling.
The dumps used `RADV_DEBUG=shaders` and `MESA_SHADER_CACHE_DISABLE=true`, separate
from timing. An isolated serial recheck on AMD Radeon Graphics (RADV RENOIR,
driver version 104865800) reproduced all 24 generic failures, maximum ratio
7.346; default/scalar maxima were 1.009/1.605. Initial, full-suite and isolated
reports plus driver dumps are retained in `/tmp/vk-large-evidence/` for this run.
This change adds tests and timing support; it does not modify the lowering
implementation to hide the finding.
