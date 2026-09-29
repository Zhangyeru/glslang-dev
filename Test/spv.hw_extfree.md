# GLSL-derived extension-free HW lowering regressions

`Glsl/HwExtensionFreeTest.ValidatedGlslPipeline/*` compiles the twenty-three
`spv.hw_extfree_*.comp` sources for Vulkan 1.3 / SPIR-V 1.6. It validates
the unmodified frontend binary before checking its typed instruction patterns,
then runs only `--hw-lower-to-standard-extension-free`, validates the result,
and checks residue and path-specific invariants. Every case also runs with
`=scalar`. No assembled SPIR-V is used as an input.

The `WIDTH` macro gives 40 source/shape cases. The input disassembly goldens
are named `baseResults/spv.hw_extfree_<case>.comp.<width>.out`. They record
frontend output, not lowering input fixtures. Output checks use parsed result
and type IDs so that unrelated scalar operations cannot stand in for HW value
coverage. In total, the fixture exercises 130 lowering runs, including the
additional loop-threshold variants below.

| Source | Widths | Checked behavior |
| --- | --- | --- |
| `alias` | 4, 5 | Component-pointer write precedes a surviving whole-value load; packed/scalar storage |
| `branch` | 3, 4 | Matrix ternary uses branch stores and a merge load, followed by arithmetic |
| `loop` | 5, 8 | Loop-carried loads/stores, inner branch and continue, scalar/packed add and subtract |
| `aggregate` | 4 | Nested structs/arrays, `inout` pointer parameter, aggregate return, component update |
| `select` | 4, 5 | HW-typed vector `OpSelect`; scalar selections or a rolled packed selection |
| `integer` | 3 | Integer matrix multiplication through an aggregate argument/return; signed scalar arithmetic |
| `shared` | 4, 3 | Matmul source also has a scalar consumer; non-direct packed/scalar fallback |
| `precise` | 2 | `NoContraction` matmul through aggregate calls; scalar multiply/add with retained decorations |
| `volatile` | 4 | Vector and matrix volatile memory operations carried across a branch; scalar lane accesses |
| `copy` | 4 | `nonuniformEXT` emits a decorated HW-typed `OpCopyObject`, followed by selection |
| `mutation_input` | 4 | Nonzero-offset input modified through an `inout` scalar call before matmul |
| `mutation_vector` | 4, 5 | Vector input/bias and column-major matrix modified through dynamic component pointers |
| `mutation_matrix` | 3, 4 | All three matrix operands modified before matmul |
| `precise_arithmetic` | 4, 5 | Precise vector multiply/add/scale retains NoContraction; neighboring subtraction remains relaxed |
| `precise_matrix_arithmetic` | 3, 4 | Precise matrix add/scale retains NoContraction in scalar and packed forms |
| `large_struct` | 65532, 65533, 65534 | Nested replicated structs containing large vector constants, global and local initializers |
| `switch_return` | 4, 5 | Switch, break, early aggregate return, typed function transport and arithmetic |
| `do_break` | 4, 5 | Do-while, break, continue and surviving cross-block cooperative value loads |
| `private_nested` | 4, 5 | Private struct/array/struct root, dynamic component write in a callee, packed index remapping |
| `workgroup` | 4, 5 | Numeric Workgroup backing, HW load/store, preserved barrier operands and constants |
| `conversion_extinst` | 4, 5 | HW-typed float/int conversions, signed arithmetic, GLSL.std.450 FClamp and bitcasts |
| `ssa` | 4, 5 | Vector and matrix loop backedges and diamond merges; a separate SSA pipeline requires HW-typed Phi |
| `coherent` | 4 | HW loads retain MakePointerVisible, NonPrivatePointer and the scope ID |

The select cases additionally use `unroll-elements=2`; integer matmul uses
`unroll-macs=8`; precise matmul uses `unroll-macs=4`. These variants force
structured loops without large shaders. Integer and precise cases exercise
automatic scalar arithmetic even in default mode. Odd dimensions alone are
not enough to establish scalar matmul: direct float helpers support tails and
can accept aggregate value arguments.

Mutation cases additionally use `unroll-macs=2`; precise elementwise cases
use `unroll-elements=2`. Mutation checks require the post-update operand ID
to feed the lowered computation, not merely survive as a dead load. Safe
forwarding through unrelated Function-variable stores remains permitted.
The large-struct cases straddle the composite instruction word-count limit;
replicated struct parents must be reconstructed as structs while large array
children use loop materialization.

The five language cases also run with `unroll-elements=2` in both modes.
Their output must have additional loops beyond the source loops, so a source
`do-while` or backing-array copy loop cannot stand in for a generated loop.
Inputs for branch selection, leaf selection and lane selection come from
`B.data[1]` and `B.data[2]`, rather than invocation IDs fixed at zero at runtime.

The matrix call cases use structs containing cooperative matrices for their
parameters and return values, following the existing GLSL flow tests.

## Run and update

```bash
cmake --build build -j8
build/gtests/glslangtests --gtest_filter='*HwExtensionFreeTest*'
# Only when an intentional frontend change requires new input goldens:
build/gtests/glslangtests --update-mode --gtest_filter='*HwExtensionFreeTest*'
# With GLSLANG_ENABLE_HW_VK_TESTS enabled and Vulkan available:
ctest --test-dir build -R '^vk_hw_language$' --output-on-failure
```

An individual source can also follow the standalone pipeline (use `-DWIDTH=5`
on glslang to select an alternate width):

```bash
build/StandAlone/glslang --target-env vulkan1.3 -V \
    Test/spv.hw_extfree_alias.comp -o build/input.spv
build/External/spirv-tools/tools/spirv-val --target-env vulkan1.3 build/input.spv
build/External/spirv-tools/tools/spirv-opt --target-env=vulkan1.3 \
    --hw-lower-to-standard-extension-free build/input.spv -o build/output.spv
build/External/spirv-tools/tools/spirv-val --target-env vulkan1.3 build/output.spv
build/External/spirv-tools/tools/spirv-dis build/output.spv -o build/output.spvasm
```

## Coverage boundaries

The raw frontend still uses memory-backed cooperative loop/branch values.
`Glsl/HwSsaTest.ValidatedCooperativePhiPipeline/*` separately applies
`--ssa-rewrite`, validates that result, requires both vector and matrix HW-valued
Phi, and lowers it in five modes. The SSA target-type set now includes HW types.
`vk_hw_semantics` additionally uses legal `GL_EXT_spirv_intrinsics` GLSL to
produce an `OpInBoundsAccessChain` to a statically in-range cooperative component.

Explicit `FPFastMathMode` and memory operands beyond those emitted by the GLSL
frontend remain covered by existing optimizer unit tests. Validation and these
structural checks alone are not a numerical execution oracle.

## Language numerical tests

`vk_hw_language` compiles the six language `Test/` sources directly, validates
the frontend binary, runs lowering in five configurations, validates
and checks residue, then executes each result with `vk_hw_language_tests`.
Only the `ssa` source receives the explicit SSA producer pass before lowering.
Each stage must succeed before the next runs. Sources, binaries, disassembly,
command diagnostics and `results.json` are under `build/tests/vk_hw/language/`.

The C++ runner uses independent scalar CPU formulas:

| Case | Runtime controls | Expected output |
| --- | --- | --- |
| `switch_return` | Keys 0, 1, 2 | `x+4`, `2*x`, `3-x` respectively |
| `do_break` | Counts 0, 1, 2, 3 | `x+1`, `x+1`, `x+2`, `-x-1` respectively |
| `private_nested` | Both leaves and every lane | Selected lane replaced by B[0]; other lanes and the other leaf unchanged |
| `workgroup` | One invocation | `x+2`, through Workgroup memory and both barriers |
| `conversion_extinst` | Positive/negative fractions and saturation inputs | `clamp(2*(trunc(x)+3), -4, 8)` |

Three deterministic datasets use exactly representable quarter-integers.
All output bits, including unwritten lanes and two trailing guard elements,
are compared; failure returns a nonzero exit status and reports the dataset,
control and lane. The 60 shader/configuration executions cover 660 dispatches.
Workgroup coverage verifies backing-memory lowering and barrier preservation;
it does not claim inter-invocation synchronization coverage. This suite covers
these five operation combinations, not every conversion or ExtInst opcode.

See `tests/vk_hw/LANGUAGE_CONTRACT.md` for the legal-input domain, transactional
recovery and the wider numerical matrix. Ordinary integer induction Phi remains
insufficient evidence for cooperative value transport.

## Ordinary array type collisions and scalar block layout

`Glsl/HwArrayCollisionTest.PreservesOrdinaryArrayIndices/*` compiles
`spv.hw_extfree_array_collision.comp` with ordinary and scalar SSBO layouts.
The ordinary `vec2[2]` function return shares its SPIR-V type with the packed
representation of `coopvecHW<float, 4>`. The test requires the ordinary `[1]`
extraction to remain unchanged and packed arithmetic to survive default and
`no-direct,no-fusion` lowering without a scalar retry. Explicit scalar lowering
is also validated. Both input and output validation receive the same validator
options; the scalar fixture requires them because its `vec3` member starts at
offset 8. These two source configurations add six raw lowering runs.

## Integer dependency chain scaling

`Glsl/HwIntegerChainTest.SmallIntegerOperationsStayUnrolled/*` expands
`spv.hw_extfree_integer_chain.comp` into signed and unsigned width-4/5 chains
of 32 and 512 statements. Each statement adds and XORs an integer cooperative
vector, and the final value is stored to an SSBO. The test requires exactly
two HW-typed operations per statement in the validated frontend module;
there are no source loops, and longer cases contain more actual instructions.
These generated inputs use structural assertions instead of large goldens.

Default, scalar and `no-direct,no-fusion` raw lowering must preserve the scalar
integer arithmetic, produce valid extension-free output without recovery
diagnostics, and introduce no loops while the vector fits the unroll limit.
The 32-statement cases additionally run default/scalar `unroll-elements=2`;
they require rolled add/XOR operations, so the optimization cannot ignore the
configured limit. The eight source configurations cover 32 raw lowering runs.
This regression protects the output structure responsible for integer-chain
compile-time scaling without depending on a machine-specific timing limit.
