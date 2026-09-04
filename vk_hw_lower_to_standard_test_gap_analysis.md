# vk_hw Lower-to-Standard 测试覆盖与缺口分析

## 1. 文档目的

本文档记录 `HwLowerToStandardPass` 与 `tests/vk_hw` 的交叉覆盖审计结果，并给出后续端到端测试建设顺序。

审计目标不是只确认已有 shader 能够通过，而是围绕以下最终目标检查测试闭包：

> 对任意通过 HW 扩展 validator 的合法 cooperative vector/matrix shader，extension-free lowering 不因
> shape、类型、控制流、operand 来源、pointer path 或 memory 语义而失败；lower 后无 HW residue，能够通过
> `spirv-val`，并与原语义保持一致。

本文档是 [HW Vec/Mat Lower Pass 语言完备性总结](hw_lower_to_standard_language_completeness.md) 的测试侧配套材料。

审计快照：

- 日期：2026-09-02
- glslang 分支：`lower-0605`
- SPIRV-Tools 分支：`lower-0605`
- 当前 Vulkan function：106 个 compute case
- 当前 graphics build/golden：2 个 fragment case

## 2. Lower pass 实际执行流程

主流程位于
[`HwLowerToStandardPass::Process`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp#L48)：

```text
参数与 extension-free preflight
  → NoContraction 检查
  → loop-carried RAW root 分析
  → 两层 vector-matmul fusion
  → 收集 cooperative 类型
  → function/aggregate/type legalization
  → packed vec2 或 scalar type materialization
  → Function-local cooperative variable 消除
  → matmul pattern helper 准备
  → direct matrix/vector matmul 尝试
  → 通用 worklist lowering
      ├─ matrix/vector load/store
      ├─ matrix/vector matmul
      ├─ reduce/length
      ├─ SSA/select/composite/dynamic indexing
      ├─ AccessChain/pointer transport
      ├─ conversion/arithmetic/scale
      └─ cooperative vector GLSL.std.450
  → nested type reference 替换
  → HW declaration/capability/extension 清理
  → final HW residue 检查
```

### 2.1 Preflight 与优化准备

`Process` 首先验证 element/MAC limit 配置并检查 module 是否包含 HW construct。Extension-free 模式在任何
IR mutation 前执行完整合法性预检。

默认 packed 模式随后执行：

1. 同一 module pointer root 的 loop-carried RAW 分析；
2. 两层 vector-matmul fusion；
3. cooperative type 收集与 ordinary type materialization；
4. function type、aggregate 和 Function-local variable 重写。

### 2.2 Direct 优化层

[`LowerHwInstructions`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp#L168) 首先收集：

- `OpCooperativeMatrixMulAddHW`
- `OpCooperativeVectorMatrixMulHW`
- `OpCooperativeVectorMatrixMulAddHW`

并尝试 direct pointer streaming。Direct match、安全性证明或 source kill-list 检查不满足时，指令仍应保留给
后续通用 lowering，而不能因为优化不匹配而失败。

### 2.3 通用 lowering 层

剩余 HW/关联 core instruction 被加入 worklist，覆盖：

- HW load/store、matmul、reduce、length；
- constant/composite construct、extract、insert；
- select、Phi、CopyObject；
- dynamic vector extract/insert；
- AccessChain/InBoundsAccessChain/PtrAccessChain；
- null、undef、bitcast；
- conversion、arithmetic、scale 和 cooperative vector ExtInst。

Memory lowering 位于
[`hw_lower_to_standard_memory.cpp`](External/spirv-tools/source/opt/hw_lower_to_standard_memory.cpp#L47)，根据：

- element count；
- RowMajor/ColumnMajor；
- packed/scalar representation；
- pointer 是否可捕获；
- memory operand 是否可移动；

选择 static expansion、packed helper loop 或 generic scalar structured loop。

Matmul 根据 MAC 数量和类型组合选择 direct、packed helper、scalar fallback 或 structured-loop fallback。

## 3. 当前 vk_hw 测试组成

当前 105 个 compute Vulkan function case 分布如下：

| 家族 | 用例数 |
|---|---:|
| load/store | 19 |
| matmul | 30 |
| extra-store | 2 |
| vecmatmul | 11 |
| vecmatmuladd | 11 |
| MLP | 14 |
| multiops | 7 |
| reduce | 12 |
| 合计 | 106 |

另有：

- `neural.frag`
- `neural_f16.frag`

这两个 graphics case 当前只执行 compile、lower、validator 和 GLSL golden。Graphics artifact 被放到
`spv/graphics/` 子目录，不会被 compute function runner 选择。

### 3.1 已覆盖较好的能力

- f16、f32、i8/u8、i16/u16、i32/u32 基础 component；
- packed、自然 scalar representation，以及部分显式 force-scalar；
- even shape、odd tail、mixed precision；
- unrolled 与 rolled matmul；
- matrix/vector direct path；
- constant weight、constant bias、value argument；
- shared source、多次 matmul 和 extra store；
- 两层及多层 MLP；
- row/column reduce 的 f32 Add/Min/Max；
- function 参数、返回值、多调用点；
- 多层 struct/array aggregate；
- loop、switch、selection、Phi、early return；
- Function-local cooperative value transport；
- 同一 buffer 的 loop-carried RAW；
- extension-free 后无 HW residue；
- extension-free 后无 replicated-composites opcode、capability 或 extension residue；
- Vulkan 数值 reference 和 perf ratio 检查。

### 3.2 已确认的零覆盖或弱覆盖项

对当前 shader source 和生成的原始 HW SPIR-V 扫描后确认：

| 能力 | 当前 vk_hw 覆盖 |
|---|---:|
| ColumnMajor cooperative matrix memory | 0 |
| PhysicalStorageBuffer / buffer_reference | 0 |
| cooperative load/store 上的 MemoryAccess operand | 0 |
| Compute cooperative `OpVectorExtractDynamic` | 0 |
| Compute cooperative `OpVectorInsertDynamic` | 0 |
| cooperative GLSL.std.450 | 只有 FMax |
| UBO cooperative source | 1 个 f32 vecmatmul |
| 真正 Workgroup cooperative backing | 1 个 f16 matrix flow |
| Fragment Vulkan 数值运行 | 0 |
| 多 entry point Vulkan 运行 | 0 |

因此，20 个 production flow case 虽然显著增强了真实 call graph、aggregate 和 CFG 覆盖，但不能替代
one-feature-one-regression 的语言微测试。特别是 dynamic vector indexing、Private global、inout pointer 等
能力仍需要独立、可定位的端到端用例。

## 4. P0：pass 已实现，应立即增加的测试

### 4.1 不需要大幅修改 runner 的第一批用例

| 建议文件名 | 目标能力 | 期望路径/检查 |
|---|---|---|
| `load_store_f16_flow_column_major_7x5.comp` | ColumnMajor packed/tail | 同 layout load/store roundtrip |
| `load_store_i32_flow_column_major_5x7.comp` | ColumnMajor integer scalar | integer generic memory |
| `load_store_f32_flow_nested_vec4_leaf_8x8.comp` | struct→array→ordinary vec4 leaf | nested pointer decomposition |
| `load_store_f16_flow_nested_u16_leaf_8x8.comp` | f16 cooperative + u16 backing | same-width bitcast boundary |
| `load_store_f32_flow_workgroup_vector_1x128.comp` | cooperative vector Workgroup backing | barrier + Workgroup load/store |
| `load_store_i32_flow_workgroup_matrix_8x8.comp` | integer Workgroup matrix | scalar generic Workgroup path |
| `load_store_f32_flow_dynamic_vector_index_1x64.comp` | dynamic vector extract/insert | `OpVectorExtractDynamic/InsertDynamic` |
| `load_store_f32_flow_private_global_8x8.comp` | Private cooperative aggregate | global type/pointer rewrite |
| `load_store_f16_flow_inout_pointer_8x8.comp` | inout/function pointer transport | pointer escape-safe legalization |
| `load_store_f16_flow_loop_carried_raw_32x32.comp` | f16 matrix RAW | packed helper memory dependency |
| `load_store_f32_flow_disjoint_loop_root_32x32.comp` | disjoint roots | 不应错误强化无关 memory root |
| `load_store_i32_arith_8x8.comp` | signed integer arithmetic | identity composition + exact compare |
| `load_store_u32_arith_8x8.comp` | unsigned arithmetic/bitwise | UDiv、shift、bitwise |
| `load_store_i16_convert_8x8.comp` | SConvert/UConvert | integer width conversion |

Integer arithmetic case 应至少覆盖：

- IAdd、ISub、IMul；
- SDiv/UDiv；
- SNegate；
- ShiftRightLogical、ShiftRightArithmetic、ShiftLeftLogical；
- Bitwise And/Or/Xor/Not。

为了复用现有 load/store identity reference，可以将操作组织为语义恒等链，例如：

```text
-(-x)
(x + 0) - 0
(x * 1) / 1
(x xor 0) and all_ones
x << 0
```

### 4.2 默认 threshold 边界和 rolled path

默认配置为：

- `max_unrolled_elements = 4096`
- `max_unrolled_matmul_macs = 4096`

建议增加：

| 建议文件名 | 覆盖点 |
|---|---|
| `load_store_f32_flow_large_elementwise_65x65.comp` | 4225 elements，触发 memory/elementwise structured loop |
| `reduce_column_add_f32_65x65.comp` | `LowerMatrixReduceWithLoop` |
| `vecmatmul_f16_64x64.comp` | 4096 MAC 精确边界 |
| `vecmatmul_f16_64x65.comp` | 4160 MAC，边界之上 |
| `matmul_f32_16x16x16.comp` | 已覆盖 4096 MAC matrix 边界，应保留 |
| `matmul_f32_16x32x16.comp` | 已覆盖 matrix rolled path，应增加显式 golden/path assertion |

测试除数值正确外，还应反汇编检查：

- threshold case 没有意外进入 rolled path；
- above-threshold case 存在合法 structured `OpLoopMerge`；
- lower 后无 HW residue。

## 5. P0：需要扩展 runner/harness 的 memory 测试

### 5.1 Subregion 与动态地址

建议增加：

- `load_store_f32_flow_subregion_5x7.comp`
- `load_store_f32_flow_column_major_subregion_5x7.comp`
- `load_store_f32_flow_dynamic_offset_8x8.comp`
- `vecmatmuladd_f16_flow_nonzero_dynamic_offsets_17x9.comp`

Runner 需要支持 sidecar metadata：

```text
logical shape
physical rows/columns
row stride
base offset
subregion row/column offset
expected untouched padding
```

验证不能只比较逻辑输出，还要确认 subregion 之外的 guard/padding 没有被写坏。

### 5.2 UBO 与复杂 layout

当前只有一个 scalar-layout f32 UBO vecmatmul。建议增加：

- `vecmatmul_f32_flow_ubo_std140_nested_16x8.comp`
- `vecmatmul_f16_flow_ubo_scalar_subregion_17x9.comp`
- `load_store_f32_flow_ubo_matrix_source_8x8.comp`

需要覆盖：

- std140；
- scalar block layout；
- struct member；
- fixed array；
- ordinary vector leaf；
- nonzero matrix offset。

### 5.3 PhysicalStorageBuffer / buffer_reference

建议增加：

- `load_store_f32_flow_buffer_reference_8x8.comp`
- `matmul_f16_flow_buffer_reference_16x16x16.comp`
- `load_store_i32_flow_buffer_reference_nested_8x8.comp`

Runner 需要：

- 创建支持 shader device address 的 buffer；
- 查询并上传 device address；
- 启用相应 Vulkan feature；
- 将地址通过 UBO/push constant/descriptor 传入 shader；
- 支持并验证 required alignment。

### 5.4 完整 MemoryAccess operand

GLSL 难以稳定表达全部 SPIR-V MemoryAccess operand，因此应让 vk_hw build pipeline 接受 `.spvasm` 输入。

建议至少增加：

- `memory_operands_matrix_load_full_f32_8x8.spvasm`
- `memory_operands_matrix_store_full_f32_8x8.spvasm`
- `memory_operands_vector_load_full_f16_16.spvasm`
- `memory_operands_vector_store_full_f16_16.spvasm`

覆盖组合：

- Volatile；
- Aligned；
- Nontemporal；
- MakePointerAvailable；
- MakePointerVisible；
- NonPrivatePointer；
- AliasScopeINTELMask；
- NoAliasINTELMask。

运行验证还要检查 memory operand 没有阻止 generic fallback，并且不能被 direct/fusion 非法移动。

## 6. P1：已实现 elementwise 与 ExtInst 的运行覆盖

### 6.1 Conversion 闭包

当前 Vulkan 侧主要验证 `OpFConvert`。还应增加：

- `OpSConvert`
- `OpUConvert`
- `OpConvertFToS`
- `OpConvertFToU`
- `OpConvertSToF`
- `OpConvertUToF`
- cooperative bitcast 的独立 roundtrip case

每类至少覆盖：

- cooperative vector；
- cooperative matrix；
- packed source → scalar result；
- scalar source → packed result；
- signedness 变化；
- force-scalar；
- 大 shape loop。

### 6.2 Scale 操作

当前只有 vector scale 的弱覆盖，应独立增加：

- `OpVectorTimesScalar`：f16、f32、integer；
- `OpMatrixTimesScalar`：f16、f32、integer；
- packed、scalar、large-loop；
- scalar operand 通过 function parameter/value argument 传递。

### 6.3 GLSL.std.450

当前 pass 支持 18 个 cooperative vector GLSL.std.450 opcode，但 Vulkan 侧实际只运行了 `FMax`。

应使用生成器为以下 opcode 生成测试：

| 类别 | Opcode |
|---|---|
| unary float | Atan、Tanh、Exp、Log |
| binary float | FMin、FMax、NMin、NMax、Step |
| ternary float | FClamp、NClamp、Fma |
| unsigned integer | UMin、UMax、UClamp |
| signed integer | SMin、SMax、SClamp |

生成矩阵至少为：

```text
opcode
× valid dtype
× packed/scalar
× small/rolled shape
× constant/value operand
```

Runner 需要新增 elementwise reference case，不能继续假设所有 load/store shader 都是 identity。

## 7. P1：matmul、direct 与 fusion 风险路径

### 7.1 Constant/value operand

当前 vk_hw 有 constant weight、constant bias 和一个 value argument case，但 SPIRV-Tools 单测覆盖的组合更多。

建议增加：

- `matmul_f32_consta_4x4x4.comp`
- `matmul_f32_constc_4x4x4.comp`
- `vecmatmul_f32_constx_32x16.comp`
- `vecmatmul_f32_constw_32x16.comp`
- dynamic B 通过 function value argument；
- dynamic matrix/bias 通过 aggregate return value。

### 7.2 Mixed precision 与 integer

建议增加：

- f32×f16→f32，与现有 f16×f32→f32 对称；
- f32 input + f16 matrix + f32 bias 的 vecmatmuladd；
- i16/u16/i32/u32 vecmatmul；
- integer vecmatmuladd；
- mixed signedness vector matmul；
- odd K/N integer tail；
- f32 same-precision MLP；
- force-scalar MLP；
- force-scalar mixed vecmatmuladd。

### 7.3 Alias、barrier 与 source sharing

这些能力当前主要只有 SPIRV-Tools 结构单测，需要 Vulkan 驱动数值覆盖：

- aliased input/output descriptor；
- 不同 binding 绑定同一个 VkBuffer；
- partially overlapping descriptor range；
- load 与 matmul 之间的同根 store；
- disjoint-root store；
- control barrier / memory barrier；
- shared load 被两个 direct matmul 使用；
- shared source 同时存在 composite extract 用户；
- bias load 在中间 vector store 前后复用；
- fused store 与后续 bias load 的 RAW/WAR/WAW。

建议用例：

- `vecmatmuladd_f32_flow_aliased_io_32x16.comp`
- `matmul_f32_flow_intervening_store_16x16x16.comp`
- `matmul_f16_flow_control_barrier_16x16x16.comp`
- `matmul_f32_flow_disjoint_store_16x16x16.comp`
- `matmul_f32_flow_shared_source_extra_user_16x16x16.comp`

Runner 需要显式 descriptor alias 配置，不能只固定创建 A/B/C/D 四个互不相交 buffer。

## 8. P1：Reduce、Length 和组合语言微测试

### 8.1 Reduce

当前 f32 已覆盖 2 axis × 3 operation，但 f16 和 integer 不完整。

建议增加：

- f16 row min/max；
- f16 column add；
- i32 row add/min/max；
- u32 row/column min/max；
- i8/u8、i16/u16 代表性 Add/Min/Max；
- force-scalar f16；
- 65×65 rolled reduce。

### 8.2 Matrix length

`OpCooperativeMatrixLengthHW` 已实现 lowering，但 vk_hw 没有专门的 Vulkan case。应增加一个 shader，将 length
用于选择正确输出或写入独立整数结果 buffer，以验证：

- packed matrix length；
- scalar matrix length；
- odd shape；
- nested function/type use；
- int32 result constant 替换。

### 8.3 语言微测试应保留

Production flow 之外，建议恢复或重新建立以下 focused regression：

- dynamic vector index；
- direct cooperative composite extract/insert；
- Function inout pointer；
- Private global；
- Private nested global；
- Workgroup array；
- Workgroup struct member；
- multiple call sites；
- cooperative return value；
- loop-carried cooperative Phi；
- early return；
- diamond select；
- pointer-to-pointer；
- CopyMemory/CopyLogical；
- multi-entry point shared function。

其中 GLSL 无法稳定生成的 instruction 应使用 `.spvasm` 输入，不应因为前端不可表达而放弃 Vulkan 运行覆盖。

## 9. P2：需要与 lowering 功能开发同步加入的测试

以下能力当前仍属于实现缺口，不能只添加普通“应通过”shader：

### 9.1 Core opcode 闭包

- FRem、FMod；
- SRem、SMod、UMod；
- floating/integer comparison；
- logical operation；
- cooperative core OpVectorShuffle；
- OpDot；
- 部分 matrix shift/bitwise 组合。

### 9.2 GLSL.std.450 扩展

- cooperative matrix result；
- Sin、Cos、Sqrt、Abs、Floor、Ceil；
- Pow；
- Length、Distance、Normalize、Cross；
- scalar/cooperative 混合合法签名。

### 9.3 严格浮点

- NoContraction matrix matmul；
- NoContraction vector matmul/matmuladd；
- FPFastMathMode None；
- FPFastMathDefault；
- rounding mode；
- denorm preserve/flush；
- NaN/Inf；
- signed zero；
- 多 entry point 不同 float-control。

### 9.4 Specialization 与动态控制

- specialization-constant rows/columns/length；
- specialization-constant layout；
- specialization-constant reduce axis/op；
- dynamic RowMajor/ColumnMajor dispatch；
- dynamic reduce axis/op dispatch；
- 多组 specialization value differential。

### 9.5 类型边界和 hard limit

- validator 接受时的 f64/i64/u64/bool component；
- accumulator narrowing；
- result 与 C/bias 类型不同；
- mixed-width cooperative UDiv；
- float/integer cross-domain matmul；
- 超过 `max_elements` 但可由 loop 表达的合法 shape；
- 超过 `max_matmul_macs` 但可由 rolled helper 表达的合法 matmul。

这些测试应与实现放在同一个 change 中。若当前先加入，应作为明确的 known-gap/expected-failure test，修复后立即
转换为普通成功测试，避免 expected failure 长期固化。

## 10. Runner 与测试框架改造建议

### 10.1 Sidecar metadata

当前 runner 通过文件名推导：

- case kind；
- dtype；
- shape；
- UBO/constant/value argument 等少量 variant。

随着 layout、offset、alias、special value 和 entry point 增加，继续扩展 filename regex 会变得脆弱。建议为复杂
case 增加同名 JSON sidecar：

```json
{
  "case": "load_store",
  "logical_shape": [5, 7],
  "physical_shape": [13, 17],
  "offset": [3, 4],
  "layout": "column_major",
  "descriptors": [
    {"binding": 0, "type": "storage_buffer", "buffer": "A"},
    {"binding": 3, "type": "storage_buffer", "buffer": "D"}
  ],
  "input_pattern": "finite_default",
  "expected": "subregion_roundtrip"
}
```

### 10.2 支持 SPIR-V assembly 输入

Build pipeline 应同时发现：

- `.comp`
- `.frag`
- `.spvasm`

`.spvasm` 先通过 `spirv-as`，再执行与 GLSL 完全相同的：

```text
pre-lower validation
→ extension-free lower
→ post-lower validation
→ residue check
→ Vulkan execution
```

### 10.3 支持不同 entry point 和 graphics pipeline

需要增加：

- `--entry-point`；
- 同一 SPIR-V module 针对不同 entry point 创建 pipeline；
- fragment render-pass/attachment runner；
- graphics output image readback；
- neural f16/f32 fragment differential。

### 10.4 输入模式

当前输入主要是有限的小数和小整数。建议增加：

- finite default；
- positive-only，供 Log/Sqrt；
- boundary integer；
- NaN/Inf；
- subnormal；
- +0/-0；
- deterministic random seed；
- adversarial cancellation/FMA rounding。

## 11. 自动化测试要求

有限手写 case 无法证明“任意合法 shader 不失败”，必须增加自动化层。

### 11.1 Validator 能力矩阵生成

自动生成：

```text
opcode
× component type
× shape
× packed/scalar
× constant/spec constant
× storage class
× memory decoration
× CFG/aggregate context
```

每个合法 case 至少验证：

1. lower 不返回 Failure；
2. lower 后通过 `spirv-val`；
3. HW opcode/type/capability/extension/nested reference residue 为零。

### 11.2 Differential testing

对同一个 source module 自动生成：

```text
default packed/direct/fusion
force-scalar
禁用 direct/fusion 的 generic packed
```

三者使用完全相同输入并比较输出。当前通过不同文件名维护独立 scalar shader，不能保证 source 语义始终一致，
应逐步替换为同一 source 的多 lowering mode 编译。

### 11.3 Fuzzing

Fuzzer 只生成 validator 接受的 vec/mat-only module，并随机组合：

- function/call graph；
- struct/array nesting；
- SSA/Phi/select；
- structured loop/switch；
- pointer path；
- memory operand；
- arithmetic/conversion/ExtInst；
- shape/type。

Fuzz invariant：

```text
extension-free lower succeeds
AND spirv-val succeeds
AND no HW residue
```

有 Vulkan 环境时，对可执行的小 shape module 再做 scalar/default differential。

## 12. 推荐实施顺序

建议按以下顺序推进：

1. 恢复 focused language microtests：ColumnMajor、dynamic vector index、Private/inout、Workgroup；
2. 增加 4096 threshold/rolled-path case；
3. 补齐 integer arithmetic/conversion；
4. 建立 ExtInst 自动生成与 reference；
5. 增加 subregion/offset sidecar metadata；
6. 增加 `.spvasm` 和完整 MemoryAccess 测试；
7. 增加 descriptor alias 与 direct/fusion safety 测试；
8. 增加 buffer_reference/BDA；
9. 增加 graphics runtime；
10. 随 lowering 功能开发补齐 core opcode、strict FP、specialization 和 hard-limit case；
11. 建立 capability matrix、differential 和 fuzz 长期测试。

## 13. 验收标准

新增测试体系完成后，应满足：

- 每个 pass 主分支至少有一个 Vulkan 数值 case；
- 每个已支持 core/ExtInst opcode 至少有一个运行 case；
- 每个合法 storage class 和 memory layout 至少有一个运行 case；
- packed、scalar、rolled、direct、fusion 和 generic fallback 均可单独触发；
- alias、barrier、volatile 和 loop-carried dependency 均有回归；
- graphics shader 不再只有 build/golden；
- 所有成功 case lower 后无 HW residue并通过 `spirv-val`；
- differential case 在相同输入下结果一致；
- performance case 的 `lowered_ns / baseline_ns <= 3.0`；
- 对 validator 接受的自动生成 vec/mat module，lower 不出现非系统资源类 Failure。
