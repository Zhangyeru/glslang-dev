# Repository Guidelines

## Project Structure & Module Organization
`glslang/` contains the front end, AST, type system, and semantic checks. `SPIRV/` holds AST-to-SPIR-V lowering. `StandAlone/` builds the `glslang` CLI. Bundled dependencies live under `External/`, most notably `External/spirv-tools/` for optimizer, assembler, disassembler, and validator work.

Tests are split by purpose. `Test/` stores shader fixtures and expected text outputs in `Test/baseResults/` and `Test/baseLegalResults/`. `gtests/` contains GoogleTest-based integration drivers such as `*.FromFile.cpp`. `tests/vk_hw/` contains end-to-end HW shader, golden GLSL, and runner scripts. Keep generated files under `build/` out of commits unless they are intentional goldens.

## Build, Test, and Development Commands
- `./update_glslang_sources.py` fetches/update external dependencies.
- `cmake -B build -DCMAKE_BUILD_TYPE=Debug` configures the default CMake build.
- `cmake --build build -j8` builds all targets.
- `cmake --build build --target glslang glslangtests spirv-opt spirv-val spirv-dis -j4` builds the compiler, tests, and SPIR-V tools.
- `build/StandAlone/glslang -V Test/spv.coopvecHW.comp` compiles a single shader to SPIR-V.
- `build/gtests/glslangtests --gtest_filter='*spv_coopvecHW*'` runs focused file-based tests.
- `build/gtests/glslangtests --update-mode --gtest_filter='*spv_coopvecHW*'` refreshes `Test/baseResults/` goldens.
- `ctest --test-dir build/External/spirv-tools --output-on-failure -j16` runs the SPIR-V Tools test suite and is required after every change.
- `ctest --test-dir build --output-on-failure` runs the full configured test suite.
- `ctest --test-dir build --output-on-failure -j32` runs the full top-level test suite and is required after every change.
- `ctest --test-dir build -R '^vk_hw_build_shaders$' -V` runs the HW shader build/golden pipeline.
- `ctest --test-dir build/External/spirv-tools --output-on-failure -j16` runs the spirv-tools test suite.

## Coding Style & Naming Conventions
Use the repository `.clang-format`: 4-space indentation, left-aligned pointers, braces on a new line for functions, 120-column limit. Match existing naming: `T*` classes in glslang, `E*` enums/opcodes, and CamelCase methods. Test shader names should stay descriptive and encode stage/shape, for example `vecmatmuladd_f16_convert_32x16.comp`.

## Testing Guidelines
Parser or SPIR-V emission changes should add/adjust file-based tests under `Test/` with matching outputs in `Test/baseResults/`. Prefer `--update-mode` over manual edits for large golden files. Lowering or validator changes in `External/spirv-tools/` should add focused `test_opt` coverage. HW changes should also be checked through `tests/vk_hw/scripts/build_shaders.py` or the matching `ctest` target.

For HW lowering changes, run the `vk_hw_perf` performance regression (or the equivalent
`tests/vk_hw/scripts/run_perf_tests.py` invocation) and inspect its `perf.json` output.
Every measured case must have `ratio <= 2.0` (`lowered_ns / baseline_ns`). A skipped case
must retain its `skip_reason`; any measured case above this threshold requires a documented
root-cause explanation in the change summary or PR and must not be accepted silently.

After every modification, first build all targets
- `cmake --build build -j8`
then run both mandatory regression suites:
- `ctest --test-dir build/External/spirv-tools --output-on-failure -j16`
- `ctest --test-dir build --output-on-failure -j32`

## Commit & Pull Request Guidelines
Recent history uses short, imperative subjects such as `Fix coopvecHW...` or `Add reg_control...`. Keep commits scoped to one logical change. PRs should state the affected areas (`glslang`, `SPIRV`, `External/spirv-tools`, `tests/vk_hw`), list the exact verification commands run, and call out any refreshed goldens so reviewers can separate semantic changes from expected output churn.
