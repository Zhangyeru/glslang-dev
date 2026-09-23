# Inference lowering boundaries

`runner/boundary_cases.h` is the shared case table for the GLSL GoogleTests and
the Vulkan functional/performance driver. It contains 46 source configurations,
not a dimension/type Cartesian product. `Test/spv.hw_boundary.comp` is the HW
source; `shaders/boundary/baseline.comp` is independently written standard GLSL.
The runner's CPU oracle uses deterministic typed inputs and the existing
reference arithmetic, with separate exact witnesses for rounding and contraction.

| Family | Real use and boundary |
| --- | --- |
| `head`, `channels` | Single-channel prediction, odd channel tails, vec2 packing; tail-only inputs make the final reduction term observable. |
| `batch` | Batch sizes 1/2/3 and partial 2x2 matrix tiles. Each row differs. |
| `direct_f32`, `mac_f16` | 256/2048/4096 MAC direct-helper thresholds, plus 4095/4096/4097 configurable limits at fixed work. |
| `activation` | Residual/scale/ReLU at 63/64/65 elements, including the scalar unroll boundary. |
| `slice` | Padded row/column-major parameter allocations; constant 0/1/last and runtime first/last offsets, all within allocation bounds. Offsets follow this branch's element/coordinate API. |
| `snapshot`, `mutation` | Loaded parameter snapshots versus modifications of cooperative values. The first/last component updates and the source SSBO writes are checked independently. |
| `route` | Two genuinely different experts, 0/1/2 iterations, struct argument/return transport, and a final prediction head. All six host controls execute. |
| `rounding` | FP16 parameters, FP32 accumulation, ReLU, an observable FP16 activation cache, then another layer. Covers 10→64→16 and 10→65→3. |
| `precise` | `4097*4097 - 16785408` distinguishes split multiplication/addition (0) from contraction (1). |
| `memory` | Standalone 64x64 parameter transport, without direct matmul absorbing the loads. Packed chunk helpers and scalar memory loops have different structural expectations. |
| `quant` | Signed/unsigned INT8 projections with K=31/32/33/1024, N=3, endpoint values, INT32 bias and exact non-overflowing accumulation. |

The rounding witness generates `1 + 2^-11`, caches it as FP16, and amplifies it
by 32 in the next layer. The exact answer is 32 rather than 32.015625. The cache
and its guards are checked as well as the final result. A register-only version
initially produced 32.015625 both in scalar-lowered SPIR-V and in independently
unrolled standard GLSL on the local RADV/llvmpipe drivers; the lowered conversion
instructions were present and connected. This was not evidence of a lower-pass
defect. The materialized cache makes the test's intended storage precision
observable without broadening the comparison tolerance or excluding a mode.
See Vulkan's [floating-point expression and precision rules](https://github.khronos.org/Vulkan-Site/spec/latest/appendices/spirvenv.html#spirvenv-precision-operation).

## Validation and artifacts

Each case is compiled from GLSL and input-validated before lowering. Raw default
and scalar modes, configured threshold modes, and the same freeze/fold/lower/fold
sequence used by `build_shaders.py` are output-validated and checked for HW
residue. GoogleTests inspect typed operations and the computation helper's
loops, rather than treating arbitrary loop counts as coverage. The original
GLSL, input and output assembly, stage and exact commands are sufficient to
reproduce a failure; generated artifacts live in `build/tests/vk_hw/boundary/`.

Vulkan checks three datasets per control, both output guards, source writes in
the snapshot case, and cached half values/guards in the mixed MLP cases. Integer,
tail, precise and rounding witnesses use exact comparisons. Other float cases
use the existing reference tolerances. Functional failure is never a skip.
Only missing queried Vulkan data-type features produce a `skip_reason`.

```
cmake --build build -j8
build/gtests/glslangtests --gtest_filter='*HwBoundaryTest*'
ctest --test-dir build -R '^vk_hw_boundary$' --output-on-failure
ctest --test-dir build -R '^vk_hw_boundary_perf$' --output-on-failure
ctest --test-dir build/External/spirv-tools --output-on-failure -j16
ctest --test-dir build --output-on-failure -j32
```

`vk_hw_boundary_perf` has its own fixture and does not inherit the ordinary
suite's `*flow*` exclusion. For each case it measures the independent baseline,
production default and production scalar modules (20 warmups, 200 samples per
control), verifies all datasets, and records both ratios in `boundary/perf.json`.
The maximum accepted ratio is 5.0. The existing `vk_hw_perf` threshold stays
unchanged. Preserve failed ratios and explain any exception; never raise the
threshold or silently skip a slow case.

For a focused rerun, invoke `scripts/run_boundary_tests.py` with the same tool,
source, baseline and output arguments shown by `ctest -N -V`, adding
`--case <case-id>`. Add `--perf` only after the matching functional build, using
the same output directory. `--list-boundary-cases` on `vk_hw_runner` lists the
shared definitions without initializing Vulkan.

## Measured performance failures (2026-09-23)

On AMD Radeon Graphics (RADV RENOIR), reported driver version 104865800,
all 46 cases passed functional verification: 242 module executions and 846
dataset/control dispatches, without skips. The new performance gate found
**nine failing mode/case pairs in seven cases**. A separate serial rerun with
20 warmups and 200 samples reproduced every failure. These are recorded
failures, not accepted exceptions: `vk_hw_boundary_perf` remains red and the
5.0 limit remains enforced. The ordinary `vk_hw_perf` still passes its existing
3.0 limit. No lower-pass implementation or unroll defaults were changed.

| Case | Failing mode | Initial ratio | Serial recheck | Cause |
| --- | --- | ---: | ---: | --- |
| `channels_f16_64x65` | scalar | 8.18 | 7.66 | Memory and MAC loops |
| `channels_f16_65x64` | scalar | 9.66 | 9.65 | Memory and MAC loops |
| `direct_f32_8x15x16` | default | 7.30 | 7.26 | Unrolled register spills |
| `direct_f32_8x16x16` | default | 9.15 | 9.17 | Unrolled register spills |
| `direct_f32_8x16x16` | scalar | 7.44 | 7.43 | Unrolled register spills |
| `direct_f32_8x17x16` | scalar | 7.49 | 7.45 | Unrolled register spills |
| `activation_f16_63` | default | 13.45 | 12.75 | Separate scalar elementwise loops |
| `activation_f16_65` | default | 13.29 | 13.29 | Separate scalar elementwise loops |
| `activation_f16_65` | scalar | 13.27 | 13.28 | Separate scalar elementwise loops |

The source and generated-code evidence separates three causes:

* **Scalar 4160-element weights:** `LowerMatrixLoad` switches to
  `BuildScalarMemoryLoop` above 4096 elements, and `LowerVectorMatrixMul`
  independently switches to its loop at 4096 MACs. The resulting function arrays
  use scratch memory in the RADV assembly (without VGPR-spill markers).
  For `64x65`, raising only `unroll-macs` to 8192 reduced about 3683 µs to
  1613 µs; also raising `unroll-elements` to 8192 reduced it to 261 µs.
  These diagnostic options isolate the two costs; they are not applied to the
  regression cases or proposed as global defaults.
* **FP32 matrix unrolling:** the direct matrix helper unrolls through 2048 MACs;
  scalar matmul unrolls through 4096. All four failing FP32 mode/case pairs show
  `storage:vgpr_spill` and scratch load/store instructions in RADV's compiled
  shader dump. For `8x16x16`, `unroll-macs=1024` selects the direct loop and
  reduces about 529 µs to 57 µs. The scalar counterpart decreases from 430 µs
  to 177 µs. This identifies excessive live values in the unrolled paths,
  rather than a numerical failure or timer outlier.
* **Odd-width activations:** `LowerElementwiseWithLoop` only permits the small
  scalar unroll when the mode is explicitly scalar and the piece count is at
  most 64. Default width 63 and both width-65 modes therefore emit three separate
  loops for add, scale and max, with materialized function arrays. The baseline
  performs them in one loop. The RADV dump contains extensive branch expansion
  of the dynamic function-array accesses, without scratch/spill markers.
  Width 63 in scalar mode and width 64 in either mode stay near baseline speed.

The full gate report is `build/tests/vk_hw/boundary/perf.json`. The independent
recheck, controlled option trials and nine driver dumps are retained under
`build/tests/vk_hw/boundary_analysis/` as `perf_recheck.json`,
`controlled_perf.json`, `driver_diagnostics.json` and `*_radv.txt`.
Driver dumps were collected separately from the serial timing recheck using
`RADV_DEBUG=shaders` and are diagnostic evidence, not benchmark samples.

These findings leave follow-up optimizer work: reduce unrolled live ranges,
avoid unnecessary scalar matrix staging, and fuse or otherwise optimize
non-packed elementwise processing. Keep the new failing cases when making
those changes, and rerun the complete valid-input and runtime pipeline.
