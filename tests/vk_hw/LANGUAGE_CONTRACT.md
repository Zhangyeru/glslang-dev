# HW vec/mat lowering contract

This contract targets Vulkan shaders containing HW cooperative vectors and
matrices. It separates the raw pass from the specialization pipeline and ties
the accepted operations to their semantic owners in `language_contract.json`.
`audit_language_contract.py` detects unreviewed changes to either the lowering
closure or validator. Its counts do not establish numerical correctness.

## Input and output

The input must pass validation for its target environment. Cooperative scalar
components are f16/f32 and signed/unsigned 8/16/32-bit integers. Shapes are
positive, compile-time values; their logical element counts must fit uint32.
The optional element/MAC policy limits default to zero (disabled). Allocation
failure, ID exhaustion and unrepresentable indices remain resource errors.

For specialization-dependent shape or reduce controls, the caller must apply
its specialization values, freeze specialization constants and fold constant
expressions before raw lowering. The production pipeline is:

```
validate input
→ [set supplied specialization values]
→ freeze-spec-const → fold-spec-const-op-composite
→ hw-lower-to-standard-extension-free
→ fold-spec-const-op-composite → validate output → check residue
```

Missing specialization overrides use the module defaults. A frozen artifact
represents one fully resolved specialization state. Matrix layout is an
ordinary constant 0 or 1; dynamic/spec layout is validator-invalid. This
contract does not add runtime-shaped cooperative values.

Success requires valid standard SPIR-V, no HW or replicated-composites residue,
and preservation of defined value, memory and floating-point behavior. Other
standard extensions/capabilities needed by the program may remain. Buffer
leaf types can include f64/i64/u64 even though cooperative components cannot.
Equal-width memory type changes reinterpret bits; cross-width accesses convert
one scalar lane numerically. Vector offsets are element indices; matrix
shape/offset operands use this branch's coordinate API.

## Closure obligations

| Family | Required preservation | Evidence owner |
| --- | --- | --- |
| Cooperative opcodes | Logical row/column addressing, reductions, accumulator type, tail elements and evaluation order | memory/matmul optimizer suites and Vulkan boundary cases |
| Conversion/arithmetic/scale/ExtInst | Each validator-legal signature, component conversion, exact integer behavior, floating-point controls | elementwise optimizer suite and GLSL numerical matrix |
| Types and constants | Recursive array/struct/pointer/function replacement; type ordering and deduplication; constant-expression versus runtime uses | aggregate/constants optimizer suites and GLSL large-struct cases |
| SSA and CFG | Operand/result type identity, predecessor labels, dominance and loop-carried values after generated loops split blocks | aggregate/composition suites and GLSL-to-SSA numerical cases |
| Functions and memory transport | Calls, returns, aliasing, component-pointer mutation and snapshot values | GLSL mutation/private/aggregate cases and descriptor alias oracles |
| Decorations and execution context | Memory operands, NoContraction, entry-point interfaces, per-invocation initialization and synchronization | validation/memory suites and Vulkan context cases |

The structural whitelist also contains operations whose relevant forms require
Kernel/physical addressing or storage classes unavailable to cooperative
whole objects in this Vulkan contract (for example sized copies and lifetime
operations). Recognizing an opcode during type replacement is not a claim that
every storage/signature is validator-legal. Those cases remain explicitly
outside the Vulkan positive matrix; universal-environment unit tests are
supplementary evidence. Cooperative whole objects live in Function/Private;
Workgroup uses ordinary numeric backing storage.

FRem/FMod, integer remainder/modulus, cooperative comparisons/logical operations,
OpDot, OpVectorShuffle, matrix-result ExtInst and non-whitelisted ExtInst are
validator exclusions. Expanding that language requires coordinated frontend,
validator, lowering and positive tests. TensorMap, CpAsync, HW barriers/shuffles
and Relreg remain outside vec/mat lowering; extension-free preflight rejects them.

## Recovery and evidence

Each lowering attempt owns an independent IR context. Failure cannot publish
partially rewritten types, helpers, memory operations or stale analyses.
Normalization and legality failures do not trigger optimization recovery.
Recoverable generation failures retry with scalar lowering from the original
binary. When ordinary target validation accepts the original module, an invalid
generated candidate also triggers recovery. A failed scalar attempt leaves the
original module intact. Resource exhaustion is diagnosed without repeated
retries. Fault-injection unit tests exercise both successful and failed recovery.

`no-direct` and `no-fusion` independently disable those optimizations without
disabling packed generic lowering. Source-derived tests must check the actual
HW-typed input operations; ordinary scalar Phi/loop instructions are insufficient.
Numerical oracles compare the same source and data across default, generic,
scalar and rolled configurations, using exact comparisons where semantics allow.
Performance is a separate gate: retain every measured ratio and skip reason;
no ratio above 5.0 is silently accepted.

## GLSL numerical matrix

`vk_hw_semantics` generates source files for every supported arithmetic,
conversion and ExtInst family. Float ExtInst run at both f16 and f32;
conversion tests cover widening/narrowing and vector/matrix shapes. Even/odd
widths and five lowering configurations exercise packed, scalar, generic and
rolled paths. Each configuration executes three independent CPU datasets,
checks both output guards and verifies the entire input buffers.

Additional cases cover f32/f16 and f64/i64/u64 backing conversions, four
invocations exchanging Workgroup data through three barriers, descriptor
aliasing/partial overlap, source-level in-bounds intrinsics, actual fragment
rasterization, and two linked GLSL entry points with different results.
A coherent-only alias probe returned stale data in both the lowered shader and
an independently written ordinary GLSL baseline on the local driver. The alias
oracle therefore uses `volatile coherent` to make each read observable; the
front-end visibility-mask fix is also checked independently in the file goldens.

The default twelve seeded programs combine aggregate function transport,
branches, loops and bounded arithmetic. `--fuzz-seeds N` extends the deterministic
campaign. Every candidate must compile and validate before a lowering result is
counted. A failing seed is reduced by deleting source operations, retaining only
reductions that pass the preceding gates and fail at the same stage. Sources,
commands, CPU expectations, actual bytes and reduction trials remain under the
configured output directory. Only unavailable device features may skip runtime
execution, with the queried feature retained in `skip_reason`.

Integer, bitcast, guard and exactly representable arithmetic checks are exact.
Division/transcendentals use explicit f32/f16 numerical tolerances; these are
not used for contraction, half-storage rounding or integer witnesses in the
boundary suite. This finite matrix plus source-contract audit is regression
evidence, not a mathematical proof for every possible program composition.

Run all generated cases with:

```bash
ctest --test-dir build -R '^vk_hw_(language_contract|language|semantics)$' --output-on-failure
```

For a reproducible focused campaign, use the command shown by `ctest -N -V`
and add `--case <name>` or `--fuzz-seeds N` to `run_semantic_tests.py`.
