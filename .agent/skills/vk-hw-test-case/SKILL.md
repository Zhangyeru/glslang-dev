---
name: vk-hw-test-case
description: This skill should be used when the user asks to "add a vk_hw test case", "新增 vk_hw 用例", "add HW shader test", "add baseline shader", "add coopmatHW test", or discusses adding/modifying test shaders under tests/vk_hw/. Covers the full chain — hw/baseline shader pair, parse_case regex, build_shaders.py variant flags, and runner/reference.cpp ReferenceOutput extension.
---

# vk-hw-test-case

Rules for adding new test cases under `tests/vk_hw/`. Each case is a **pair** of shaders: a HW shader using `GL_HW_neural_shader` and a baseline shader hand-writing the same algorithm in plain GLSL.

## When to use

Activate when adding or modifying any `.comp` file under `tests/vk_hw/shaders/`, or when extending the test discovery / runner to support a new case kind or variant.

## Hard rules

### 1. Generate both files as a pair

- HW: `tests/vk_hw/shaders/hw/<stem>.comp`
- Baseline: `tests/vk_hw/shaders/baseline/<stem>_baseline.comp`

`run_perf_tests.py:44-46` derives the baseline path by string-substituting `.lowered.spv` → `_baseline.spv`. A missing baseline makes `vk_hw_perf` hard-fail (`run_perf_tests.py:107-109`). Stems must be identical except for the `_baseline` suffix.

### 2. Filename must match `parse_case`

The regex at `tests/vk_hw/scripts/run_function_tests.py:16-45` is the authoritative grammar. Accepted forms:

```
matmul_(f16|f32)(_(scalar|ssbo_direct|ubo|constbias|constw|constx))?_<M>x<N>x<K>
multiops_(f16|f32)(_(scalar|ssbo_direct|ubo|constbias|constw|constx))?_<M>x<N>x<K>
vecmatmul_(f16|f32)(_(scalar|ssbo_direct|ubo|constbias|constw|constx))?_<K>x<N>
vecmatmuladd_(f16|f32)(_(scalar|ssbo_direct|ubo|constbias|constw|constx))?_<K>x<N>
load_store_(f16|f32)(_scalar)?(_<M>x<N>)?
```

If the new file does not match, `parse_case` raises `ValueError` and `vk_hw_function` aborts.

### 3. Baseline algorithm must match the HW shader

The two shaders implement **the same algorithm**. Concretely:

- Same buffer bindings: `set = 0, binding = 0..3` with A/B/C/D (or X/W/C/Y) in the same order.
- Same dtype (`f16` or `f32`) and same shape (`M`, `N`, `K`).
- Same `layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;` — single-invocation compute.
- HW side expresses the math via `coopmatHW`/`coopvecHW` + `coopMatMulAddHW` etc.; baseline side writes the same math with `vec4` tile / scalar loops. See `shaders/hw/matmul_f32_8x8x8.comp` vs `shaders/baseline/matmul_f32_8x8x8_baseline.comp` for the canonical pattern.

The baseline is the human-readable mirror the perf runner times against; it is **not** executed as a correctness oracle (the C++ `ReferenceOutput` is). It still must produce numerically matching output.

**Style consistency across baselines**: every baseline shader uses the same `vec4` tile idiom — helper functions `loadA` / `loadC` / `storeD` / `tileWeight`, an `M`-loop wrapping a `col0 += 4` `N`-loop wrapping a `k0 += 4` `K`-loop, four parallel `vec4` accumulators (`rx`/`ry`/`rz`/`rw`), and a horizontal reduce on store. Do **not** write a scalar triple-loop baseline even when the shape would make it shorter — match the vec4-tile style of the existing baselines so the suite stays mechanically uniform. When porting to a new shape, only the stride constant (the `* N` row stride in `loadA`/`loadC`/`storeD` and the `* N` col stride in `tileWeight`) and the loop bounds change.

### 4. Headers

- **HW shader**: `#version 450 core` + `#extension GL_HW_neural_shader : enable`. For `f16` also add `#extension GL_EXT_shader_explicit_arithmetic_types : enable`. Use the renamed builtins only: `coopmatHW<T, R, C>`, `coopvecHW<T, N>`, `coopMatLoadHW`, `coopMatStoreHW`, `coopMatMulAddHW`, `coopVecLoadHW`, `coopVecStoreHW`, `coopVecMatMulHW`, `gl_CooperativeMatrixLayoutRowMajorHW`. Shape/offset args are `ivec2`; vector load/store take a scalar `uint` offset.
- **Baseline shader**: `#version 450 core` only — **never** `GL_HW_neural_shader`. For `f16` add `GL_EXT_shader_16bit_storage` and `GL_EXT_shader_explicit_arithmetic_types_float16`.

### 5. Lowered HW shader must be clean

`build_shaders.py:62-64` greps the post-lowering disassembly with `HW_RE = re.compile(r"HW|CooperativeMatrixHW|CooperativeVectorHW|OpTypeCooperative|OpCooperative")` and fails the build if any token survives. Anything the lowering pass leaves as an HW opcode breaks `vk_hw_build_shaders`.

## Variant flag mapping

Filename tags drive build flags (`build_shaders.py`):

- `_scalar_` in stem → `spirv-opt --hw-lower-to-standard=scalar` (force scalar mode); otherwise `--hw-lower-to-standard` (packed-vec4 default).
- `_ubo_` in stem → `spirv-val --scalar-block-layout`; also the runner switches binding 1 from `STORAGE_BUFFER` to `UNIFORM_BUFFER` (`runner/main.cpp:66-68`). The baseline must declare binding 1 as `uniform` instead of `buffer` to match.

Other variant tags (`constw`, `constbias`, `constx`, `ssbo_direct`) are runner-side flags feeding `CaseConfig`; they do not change compile flags.

## Full chain checklist

When adding a new case:

1. Write `tests/vk_hw/shaders/hw/<stem>.comp` (HW header + coopmatHW/coopvecHW body).
2. Write `tests/vk_hw/shaders/baseline/<stem>_baseline.comp` (same algorithm, same bindings, same shape, same local_size, plain GLSL).
3. If the stem introduces a new shape grammar or variant tag → extend `parse_case` in `run_function_tests.py:16-45`.
4. If the case introduces a new `CaseKind` or variant requiring new reference math → extend `runner/reference.h` / `reference.cpp`:
   - Add to `enum class CaseKind` (`reference.h:15`) and `ParseCaseKind` (`main.cpp:72-85`).
   - Extend `ReferenceOutput` (`reference.cpp`) to compute the matching CPU reference, plus `ElementCountA/B/C/D` if buffer layouts differ.
5. Verify locally:
   ```bash
   python tests/vk_hw/scripts/build_shaders.py \
       --glslang <glslang> --spirv-opt <spirv-opt> \
       --spirv-val spirv-val --spirv-dis spirv-dis \
       --shader-dir tests/vk_hw/shaders/hw \
       --baseline-dir tests/vk_hw/shaders/baseline \
       --out-dir /tmp/vk_hw_spv --glsl-out-dir /tmp/vk_hw_glsl
   ```
   Confirm no `HW_RE` hit in `/tmp/vk_hw_spv/*.lowered.spvasm`.
6. `ctest -R vk_hw --output-on-failure` — `vk_hw_build_shaders`, `vk_hw_function`, `vk_hw_perf` all pass.
7. Eyeball the baseline vs HW pair: bindings, shape, local_size, dtype, algorithm all match.

## Inline minimal template (matmul_f32_4x4x4)

HW (`shaders/hw/matmul_f32_4x4x4.comp`):
```glsl
#version 450 core
#extension GL_HW_neural_shader : enable

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0) buffer InputA { float data[]; } A;
layout(set = 0, binding = 1) buffer InputB { float data[]; } B;
layout(set = 0, binding = 2) buffer InputC { float data[]; } C;
layout(set = 0, binding = 3) buffer OutputD { float data[]; } D;

void main()
{
    const ivec2 shape = ivec2(4, 4);
    const ivec2 zeroOffset = ivec2(0, 0);
    coopmatHW<float, 4, 4> a, b, c, d;
    coopMatLoadHW(a, A.data, shape, zeroOffset, gl_CooperativeMatrixLayoutRowMajorHW);
    coopMatLoadHW(b, B.data, shape, zeroOffset, gl_CooperativeMatrixLayoutRowMajorHW);
    coopMatLoadHW(c, C.data, shape, zeroOffset, gl_CooperativeMatrixLayoutRowMajorHW);
    coopMatMulAddHW(d, a, b, c);
    coopMatStoreHW(d, D.data, shape, zeroOffset, gl_CooperativeMatrixLayoutRowMajorHW);
}
```

Baseline (`shaders/baseline/matmul_f32_4x4x4_baseline.comp`):
```glsl
#version 450 core

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0) buffer InputA { float data[]; } A;
layout(set = 0, binding = 1) buffer InputB { float data[]; } B;
layout(set = 0, binding = 2) buffer InputC { float data[]; } C;
layout(set = 0, binding = 3) buffer OutputD { float data[]; } D;

vec4 loadA(int row, int k0)
{
    int base = row * 4 + k0;
    return vec4(A.data[base + 0], A.data[base + 1],
                A.data[base + 2], A.data[base + 3]);
}

vec4 loadC(int row, int col0)
{
    int base = row * 4 + col0;
    return vec4(C.data[base + 0], C.data[base + 1],
                C.data[base + 2], C.data[base + 3]);
}

void storeD(int row, int col0, vec4 value)
{
    int base = row * 4 + col0;
    D.data[base + 0] = value.x;
    D.data[base + 1] = value.y;
    D.data[base + 2] = value.z;
    D.data[base + 3] = value.w;
}

void tileWeight(int k0, int col0, out vec4 weight[4])
{
    weight[0] = vec4(B.data[(k0 + 0) * 4 + col0 + 0], B.data[(k0 + 1) * 4 + col0 + 0],
                     B.data[(k0 + 2) * 4 + col0 + 0], B.data[(k0 + 3) * 4 + col0 + 0]);
    weight[1] = vec4(B.data[(k0 + 0) * 4 + col0 + 1], B.data[(k0 + 1) * 4 + col0 + 1],
                     B.data[(k0 + 2) * 4 + col0 + 1], B.data[(k0 + 3) * 4 + col0 + 1]);
    weight[2] = vec4(B.data[(k0 + 0) * 4 + col0 + 2], B.data[(k0 + 1) * 4 + col0 + 2],
                     B.data[(k0 + 2) * 4 + col0 + 2], B.data[(k0 + 3) * 4 + col0 + 2]);
    weight[3] = vec4(B.data[(k0 + 0) * 4 + col0 + 3], B.data[(k0 + 1) * 4 + col0 + 3],
                     B.data[(k0 + 2) * 4 + col0 + 3], B.data[(k0 + 3) * 4 + col0 + 3]);
}

void main()
{
    for (int row = 0; row < 4; ++row) {
        for (int col0 = 0; col0 < 4; col0 += 4) {
            vec4 rx = vec4(0.0);
            vec4 ry = vec4(0.0);
            vec4 rz = vec4(0.0);
            vec4 rw = vec4(0.0);
            vec4 weight[4];
            for (int k0 = 0; k0 < 4; k0 += 4) {
                vec4 v = loadA(row, k0);
                tileWeight(k0, col0, weight);
                rx += v * weight[0];
                ry += v * weight[1];
                rz += v * weight[2];
                rw += v * weight[3];
            }
            storeD(row, col0, loadC(row, col0) + vec4(
                rx.x + rx.y + rx.z + rx.w,
                ry.x + ry.y + ry.z + ry.w,
                rz.x + rz.y + rz.z + rz.w,
                rw.x + rw.y + rw.z + rw.w));
        }
    }
}
```

Copyable templates live in `examples/template.comp` and `examples/template_baseline.comp`.

## Reference deep-dive

For `parse_case` capture groups, `build_shaders.py` flag trigger points, and `runner/reference.cpp` extension steps with line references, see `references/parse_case_and_runner.md`.
