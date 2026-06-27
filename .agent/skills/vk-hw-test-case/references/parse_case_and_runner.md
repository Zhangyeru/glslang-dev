# parse_case & runner/reference.cpp deep-dive

Detail backup for `SKILL.md`. Read when extending the test discovery grammar or the C++ reference.

## `parse_case` capture groups

Source: `tests/vk_hw/scripts/run_function_tests.py:16-45`.

The function takes a `pathlib.Path`, strips `.lowered.spv` (or falls back to `.stem`), then matches against four regexes in order. The variant suffix group is shared:

```python
suffix = r"(?:_(?:scalar|ssbo_direct|ubo|constbias|constw|constx))?"
```

| Order | Case prefix | Regex (stem) | Captures → dict |
|---|---|---|---|
| 1 | `multiops_` | `multiops_(f16\|f32){suffix}_(\d+)x(\d+)x(\d+)$` | `case=multiops`, `dtype`, `m`, `n`, `k` |
| 2 | `matmul_` | `matmul_(f16\|f32){suffix}_(\d+)x(\d+)x(\d+)$` | `case=matmul`, `dtype`, `m`, `n`, `k` |
| 3 | `vecmatmul`/`vecmatmuladd` | `(vecmatmuladd\|vecmatmul)_(f16\|f32){suffix}_(\d+)x(\d+)$` | `case`, `dtype`, `k`, `n` (m forced to `"1"`) |
| 4 | `load_store_` | `load_store_(f16\|f32)(?:_scalar)?(?:_(\d+)x(\d+))?$` | `case=load_store`, `dtype`, `m` (default `"8"`), `n` (default `"8"`), `k="0"` |

If none match → `ValueError(f"cannot parse case from {path}")` and `vk_hw_function` aborts.

### Adding a new variant tag

If the new case reuses an existing `CaseKind` but adds a variant suffix (e.g. `_constw`, `_constx` already present), just add the token to the `suffix` character class — no runner change needed unless the variant changes buffer layout or reference math.

If the variant needs new reference math (e.g. `constw` synthesizes weight from `ConstWeightValue`), also extend `HasConstWeightVariant` / `ConstWeightValue` in `runner/reference.cpp` and feed `CaseConfig` accordingly from `runner/main.cpp`.

### Adding a new case kind

Requires touching all four layers:

1. **Regex** — add a new branch in `parse_case` (`run_function_tests.py:16-45`) returning `{"case": "<name>", ...}`.
2. **`CaseKind` enum** — add `k<Name>` to `runner/reference.h:15`.
3. **`ParseCaseKind`** — add `if (value == "<name>") return CaseKind::k<Name>;` in `runner/main.cpp:72-85`.
4. **`ReferenceOutput`** — add a branch in `runner/reference.cpp:257` computing the CPU reference; also extend `ElementCountA/B/C/D` (`reference.cpp` around `:200-255`) if buffer layouts differ from the existing cases.

## `build_shaders.py` flag trigger points

Source: `tests/vk_hw/scripts/build_shaders.py`.

- **`HW_RE`** (line 15): `re.compile(r"HW|CooperativeMatrixHW|CooperativeVectorHW|OpTypeCooperative|OpCooperative")`. Applied to `.lowered.spvasm` text at lines 62-64. Any match → `RuntimeError`, `vk_hw_build_shaders` fails.
- **`--hw-lower-to-standard=scalar` vs `--hw-lower-to-standard`** (line 55): chosen by `"_scalar_" in stem`. The substring test is on the **stem**, so `matmul_f32_scalar_4x4x4` selects scalar mode; `load_store_f16_scalar` does **not** (it's `_scalar` not `_scalar_` — note load_store's regex allows `_scalar` without trailing underscore, and that variant does **not** trigger scalar lowering).
- **`--scalar-block-layout`** (lines 45-47): added to `spirv-val` when `"_ubo_" in shader.stem`. Same stem-substring rule.
- **Baseline compile** (lines 67-74): `glslang -V` → `.spv`; val; dis. No spirv-opt pass, no `HW_RE` check — baseline has no HW opcodes to begin with.
- **spirv-cross decompile** (lines 77-112): skips `.hw.spv` files (they still contain HW opcodes spirv-cross can't read); processes `.lowered.spv` and `_baseline.spv`. Failures are logged, not fatal.

## `runner/reference.cpp` extension

Key entry points:

- `enum class CaseKind` (`reference.h:15`): `kMatmul, kVecMatmul, kVecMatmulAdd, kLoadStore, kMultiOps`.
- `enum class DType` (`reference.h:16`): `kF16, kF32`.
- `struct CaseConfig` (`reference.h:18-28`): `kind`, `dtype`, `m`, `n`, `k`, `warmup`, `repeat`, `verify`, `shader_path`.
- `ReferenceOutput(config, a, b, c)` (`reference.h:52`, impl `reference.cpp:257`): the CPU reference. `vk_hw_function` and `vk_hw_perf` both call this via `runner/main.cpp:318-322` to verify runner GPU output.
- `ElementCountA/B/C/D` (`reference.h:47-50`, impl `reference.cpp:~200-255`): per-case buffer sizes. Must match the shader's actual buffer element count.
- `CompareOutput` (`reference.h:54`): `max_abs_error` / `max_rel_error` report.
- `HasConstWeightVariant` / `ConstWeightValue` (in `reference.cpp`): used by `kMatmul`/`kMultiOps` when the variant is `constw` — synthesizes the weight buffer in C++ instead of reading binding 1.

### `vk_hw_perf` baseline pairing

Source: `tests/vk_hw/scripts/run_perf_tests.py:44-46, 107-109`.

For each `<stem>.lowered.spv` the perf script derives `<stem>_baseline.spv` by string substitution and runs **both** through `vk_hw_runner`. The test passes only if `verify` and `baseline_verify` both report pass (`run_perf_tests.py:136-138`). Missing baseline file → hard fail at line 107-109.

### Descriptor type for `_ubo_`

`runner/main.cpp:60-70`: descriptor types default to four `STORAGE_BUFFER`s; if `shader_path` contains `_ubo_`, binding 1 switches to `UNIFORM_BUFFER`. The baseline shader must declare binding 1 as `uniform` (not `buffer`) to match. The HW shader can still load from it via `coopMatLoadHW` — see `shaders/hw/vecmatmul_f32_ubo_16x8.comp`.
