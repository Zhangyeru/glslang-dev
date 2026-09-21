# GLSL-derived extension-free HW lowering regressions

`Glsl/HwExtensionFreeTest.ValidatedGlslPipeline/*` compiles the ten
`spv.hw_extfree_*.comp` sources for Vulkan 1.3 / SPIR-V 1.6. It validates
the unmodified frontend binary before checking its typed instruction patterns,
then runs only `--hw-lower-to-standard-extension-free`, validates the result,
and checks residue and path-specific invariants. Every case also runs with
`=scalar`. No assembled SPIR-V is used as an input.

The `WIDTH` macro gives 15 source/shape cases. The input disassembly goldens
are named `baseResults/spv.hw_extfree_<case>.comp.<width>.out`. They record
frontend output, not lowering input fixtures. Output checks use parsed result
and type IDs so that unrelated scalar operations cannot stand in for HW value
coverage. In total, the fixture exercises 38 lowering runs, including the
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

The select cases additionally use `unroll-elements=2`; integer matmul uses
`unroll-macs=8`; precise matmul uses `unroll-macs=4`. These variants force
structured loops without large shaders. Integer and precise cases exercise
automatic scalar arithmetic even in default mode. Odd dimensions alone are
not enough to establish scalar matmul: direct float helpers support tails and
can accept aggregate value arguments.

The matrix call cases use structs containing cooperative matrices for their
parameters and return values, following the existing GLSL flow tests.

## Run and update

```bash
cmake --build build -j8
build/gtests/glslangtests --gtest_filter='*HwExtensionFreeTest*'
# Only when an intentional frontend change requires new input goldens:
build/gtests/glslangtests --update-mode --gtest_filter='*HwExtensionFreeTest*'
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

These tests do not claim HW-valued `OpPhi` or `OpInBoundsAccessChain` coverage.
The ordinary frontend uses memory-backed cooperative loop/branch values and
`OpAccessChain`. Existing optimizer assembly tests remain supplementary phi
coverage; adding in-bounds access-chain coverage requires a separately justified
producer, not an arbitrary rewrite of these frontend outputs.

Explicit `FPFastMathMode` and memory operands beyond those emitted by the GLSL
frontend remain covered by existing optimizer unit tests. Validation and these
structural checks are not a numerical execution oracle.
