# HW Vec/Mat Lower Pass 语言完备性总结与实施路线

## 1. 目标

本项目的目标是使 `hw-lower-to-standard-extension-free` 对任意合法的 HW cooperative vector/matrix shader
都能够完成 lowering，不因尚未优化的类型、shape、控制流或 operand 来源而失败。

目标可以表述为：

> 对任何通过 HW 扩展 validator 的合法 SPIR-V，只要使用的 HW 能力限定为 cooperative vector/matrix
> 类型及其相关操作，extension-free lower 必须成功，消除所有 HW 类型、opcode 和引用，并生成能够通过
> `spirv-val` 的标准 SPIR-V。

Direct、fusion、packed 和 unrolled 都属于可选性能优化。任何优化不匹配、安全性证明失败或代码生成失败，
都必须回退到语义完备的 scalar generic lowering，而不能令整个 pass 返回 `Failure`。

## 2. 范围

### 2.1 目标范围

- `OpTypeCooperativeVectorHW`
- `OpTypeCooperativeMatrixHW`
- cooperative vector/matrix 的 HW load、store、matmul、reduce 和查询指令
- 合法作用于 cooperative vec/mat 值的 core SPIR-V 指令
- 合法作用于 cooperative vec/mat 值的 extended instruction
- cooperative vec/mat 值经过的函数、SSA、CFG、composite、pointer 和 memory 语言结构

### 2.2 非目标范围

以下非 cooperative vec/mat HW 能力不属于本次语言完备性目标：

- TensorMap
- CpAsync
- HW Barrier
- `OpShuffleIndexHW`、`OpBytePermuteHW`、`OpShuffleFillDownHW`
- `OpSelectionMerge` 的 `Relreg` operand

需要区分 HW shuffle opcode 与普通 core `OpVectorShuffle`：前者不在范围内，后者如果 validator 允许作用于
cooperative vector，则属于需要实现的语言闭包。

## 3. 当前已经实现的能力

### 3.1 类型与内部表示

当前支持：

- Cooperative vector 和 cooperative matrix
- 浮点 component：f16、f32
- 整数 component：i8/u8、i16/u16、i32/u32
- 偶数宽度浮点使用 packed vec2 array
- 奇数宽度、整数和 force-scalar 模式使用 scalar array
- Matrix 统一使用逻辑 row-major flatten 表示
- Cooperative 类型嵌套在普通 array、struct 和 pointer 中
- Function 参数、返回值和局部变量中的 cooperative 类型
- Function type 重写、去重和 canonicalization
- Extension-free 模式将固定 constituent 数量的 replicated composite 展开为 core composite，并删除
  `ReplicatedCompositesEXT` capability 与 `SPV_EXT_replicated_composites` declaration

### 3.2 HW vec/mat 指令

当前实现 lowering 的 HW vec/mat opcode：

| 类别 | Opcode | 当前能力 |
|---|---|---|
| 类型 | `OpTypeCooperativeMatrixHW` | packed vec2 或 scalar array |
| 类型 | `OpTypeCooperativeVectorHW` | packed vec2 或 scalar array |
| 内存 | `OpCooperativeMatrixLoadHW` | RowMajor/ColumnMajor、packed/scalar/loop |
| 内存 | `OpCooperativeMatrixStoreHW` | RowMajor/ColumnMajor、packed/scalar/loop |
| 内存 | `OpCooperativeVectorLoadHW` | packed/scalar/loop |
| 内存 | `OpCooperativeVectorStoreHW` | packed/scalar/loop |
| 计算 | `OpCooperativeMatrixMulAddHW` | 浮点、整数、mixed precision |
| 计算 | `OpCooperativeVectorMatrixMulHW` | 浮点、整数、mixed precision |
| 计算 | `OpCooperativeVectorMatrixMulAddHW` | 浮点、整数、mixed precision |
| Reduce | `OpCooperativeMatrixReduceHW` | Row/Column、Add/Min/Max |
| 查询 | `OpCooperativeMatrixLengthHW` | 替换为 int32 常量 |

Matmul 当前支持：

- 任意正 M/N/K
- 奇数 K/N 和 scalar tail
- f16/f32 mixed operand 到 f32 accumulator/result
- 整数 mixed width 和 signedness
- Constant、value argument 和直接 buffer source
- 大 shape structured-loop fallback

### 3.3 Core conversion 与算术

当前支持的 conversion：

- `OpFConvert`
- `OpSConvert`
- `OpUConvert`
- `OpConvertFToS`
- `OpConvertFToU`
- `OpConvertSToF`
- `OpConvertUToF`
- `OpBitcast`

当前支持的浮点算术：

- `OpFAdd`
- `OpFSub`
- `OpFMul`
- `OpFDiv`
- `OpFNegate`

当前支持的整数和位运算：

- `OpIAdd`、`OpISub`、`OpIMul`
- `OpSDiv`、`OpUDiv`、`OpSNegate`
- Shift right/left
- Bitwise And/Or/Xor/Not
- `OpVectorTimesScalar`
- `OpMatrixTimesScalar`

同 shape 的 f16/f32 operand 可以混用，lower 会在运算前扩展到 result component type。

### 3.4 SSA、CFG、composite 与函数

当前支持：

- `OpPhi`，包括 loop backedge
- Scalar-bool `OpSelect`
- `OpCopyObject`
- `OpCompositeConstruct`
- `OpCompositeConstructReplicateEXT`
- `OpCompositeExtract`
- `OpCompositeInsert`
- `OpVectorExtractDynamic`
- `OpVectorInsertDynamic`
- AccessChain/InBoundsAccessChain
- Function-local load/store transport
- 多层 array/struct aggregate
- Cooperative function 参数与返回值

### 3.5 GLSL.std.450

当前 cooperative vector 支持的 extended instruction 包括：

- Atan、Tanh、Exp、Log
- FMin/FMax、NMin/NMax
- UMin/UMax、SMin/SMax
- Step
- FClamp/NClamp、UClamp/SClamp
- Fma

当前尚不支持 cooperative matrix result 的 GLSL.std.450 lowering。

### 3.6 优化路径

当前已经实现：

- Packed vec2 lowering
- Matrix/vector direct pointer streaming
- Unrolled/rolled direct helper
- f16/f32 operand 独立类型
- f32 accumulator 专用 unroll 上限
- Constant/value operand fallback
- f16→f32→f16 无损往返转换链消除
- Matrix/vector store fusion
- 两层 MLP fusion
- Shared source 与 kill-list 闭包检查
- 小型 force-scalar 浮点 elementwise 静态展开

### 3.7 当前验证状态

- SPIR-V Tools CTest：32/32 通过
- 顶层 CTest：8/8 通过
- Vulkan function：105/105 通过，无 skip
- Vulkan perf：84/84 满足 `lowered_ns / baseline_ns <= 3.0`
- Extension-free 成功时无 HW opcode/type/nested reference，也无 replicated-composites opcode、capability 或
  extension residue

## 4. Validator 排除项与仍可能失败的合法 vec/mat 语言形态

### 4.1 Core opcode validator 边界（非 lowering 缺口）

当前 validator 只允许 3.3、3.4 所列 core conversion、arithmetic、scale 和 structural opcode 作用于
HW cooperative vec/mat。以下形式会在进入 lower pass 前被 `spirv-val` 拒绝：

- `OpFRem`
- `OpFMod`
- `OpSRem`
- `OpSMod`
- `OpUMod`
- 以 cooperative vec/mat 为数值 operand 的浮点和整数 comparison
- 以 cooperative vec/mat 为 operand/result 的 logical operation
- Cooperative `OpVectorShuffle`
- `OpDot`
- 部分 matrix shift/bitwise 组合

其中 `OpSelect` 是 validator 明确允许、lower 已支持的 structural operation，不属于上述 logical 排除项；
integer shift/bitwise 当前只允许 cooperative vector，不允许 cooperative matrix。

这些 validator-invalid 形式不属于 lower-pass 语言完备性目标，也不需要 scalar fallback。若未来 validator
扩大合法 core opcode 集合，lower 必须在同一个变更中同步扩展并增加 positive lowering 测试。

### 4.2 GLSL.std.450 validator 边界（非 lowering 缺口）

当前 validator 允许的 cooperative GLSL.std.450 集合就是 3.5 所列 cooperative-vector 白名单，并要求
result 和 cooperative operands 的类型、分量类型与长度满足对应指令约束。以下形式会被 `spirv-val` 拒绝：

- Cooperative matrix result
- 大量一元浮点函数，如 Sin、Cos、Sqrt、Abs、Floor、Ceil
- Pow 等多 operand 指令
- Length、Distance、Normalize、Cross 等 geometric/reduction 指令
- Scalar 与 cooperative operand 混合的签名

因此这些形式不是 lower 未实现的合法输入：不需要实现 cooperative matrix ExtInst、额外 transcendental、
geometric/reduction 或 mixed scalar/cooperative fallback。这里只需要保持 validator 白名单与 3.5、lower
实现及测试矩阵一致。

### 4.3 `NoContraction` 无法 lowering

当前 cooperative matmul 遇到 `NoContraction` 会失败。需要增加严格浮点路径：

- 使用 FMul + FAdd，而不是 Fma
- 保持逐 K 顺序
- 传播 `NoContraction`
- 正确处理 `FPFastMathMode None`
- 正确处理 `FPFastMathDefault`
- 支持 rounding、denorm、NaN/Inf 和 signed-zero contract
- 支持多 entry point 的不同 float-control 配置

### 4.4 Specialization constant 和动态控制不完整

当前会拒绝：

- Spec-constant rows/cols/length
- Spec-constant matrix layout
- Spec-constant reduce axis/op
- 部分动态 layout/control

如果扩展 grammar 允许，应实现：

- Spec-sized array
- Spec constant 循环边界
- 动态 RowMajor/ColumnMajor dispatch
- 动态 reduce axis/op dispatch

如果扩展要求普通常量，则应由 validator 将输入判定为非法，而不是让 lower 维护更窄的隐式规则。

### 4.5 Pointer 与 memory 语言闭包（已完成）

本阶段已经建立统一的 vec/mat memory lowering 模型：

```text
逻辑元素坐标
  → 原 layout 地址计算
  → outer array / inner array / vector lane 分解
  → 在原 pointer path 上追加通用 AccessChain
  → 对最终 component 执行普通 OpLoad/OpStore
```

已经覆盖：

- pointer 可来自 struct member、任意层 `AccessChain`/`InBoundsAccessChain`，并保留非零或动态 base pointer
- pointee 可为多层 fixed array，或 outermost runtime array 后接多层 fixed array
- leaf 可为 numeric scalar 或 ordinary numeric vector
- flatten 顺序固定为 outer array → inner array → vector lane
- cooperative component 与 leaf component 类型不同时，只要 bit width 相同即在 load/store 边界使用 `OpBitcast`
- bit width 不同时，每个 cooperative component 仍对应一个 buffer scalar/vector lane；load 后或 store 前执行
  标准数值转换，详见 4.6
- Matrix RowMajor/ColumnMajor subregion 的 shape/offset 地址计算继续作用于上述统一 flatten index
- load storage class：Workgroup、StorageBuffer、PhysicalStorageBuffer、Uniform
- store storage class：Workgroup、StorageBuffer、PhysicalStorageBuffer
- `Volatile`、`Aligned`、`Nontemporal`、`MakePointerAvailable`、`MakePointerVisible`、
  `NonPrivatePointer`、alias scope 和 no-alias operand 均传播到最终 scalar access
- constant nested access 的 byte offset/Alignment 可以沿 array stride 与 vector lane 递归计算；动态 offset
  保守退化为 component natural alignment
- generic、packed、direct 和 fusion 生成代码共用同一个 pointer layout/element access 实现

优化路径无法捕获 pointer 或证明 memory operand 可移动时，仍回退 generic lowering，不把优化未匹配视为
lower failure。

本阶段的明确边界：不插入 bounds clamp/check；动态 matrix layout 仍属于 4.4；storage class 集合保持与
validator 一致，不在 lower 内私自扩展。跨位宽 memory access 使用 4.6 的数值转换约定，保持原 pointer
layout 和地址计算；涉及这些访问的 pointer 不进入 direct/fusion 或 packed pointer-chunk helper。

### 4.6 类型 validator 边界与跨位宽 memory conversion

Cooperative vec/mat component 只允许 f16/f32、i8/u8、i16/u16、i32/u32。以下组合由 `spirv-val`
拒绝，不属于 lower-pass 的合法输入缺口：

- f64、i64/u64、bool cooperative component（类型声明即拒绝，不限于 matmul）
- Matmul accumulator 比 A/Input 或 B/Matrix 的 component 更窄
- Matmul Result 与 C/Bias 的 cooperative 类型不完全一致
- Cooperative `OpUDiv` 的 operand/result component 位宽不一致，或不是 unsigned integer
- Float/integer 跨域 matmul；同数值域的 mixed-precision widening matmul 仍然合法

上述限制针对 cooperative 类型，不限制普通 buffer leaf 使用 f64/i64/u64。HW load/store 的跨位宽
输入继续由 validator 接受，generic lowering 实现以下 memory conversion 约定：

| Source → target component | Lowered conversion |
|---|---|
| 完全相同类型 | 直接使用 |
| 等位宽异类型 | `OpBitcast`，保持既有按位重解释语义 |
| 跨位宽 float → float | `OpFConvert` |
| 跨位宽 float → integer | 按 target signedness 使用 `OpConvertFToS` / `OpConvertFToU` |
| 跨位宽 integer → float | 按 source signedness 使用 `OpConvertSToF` / `OpConvertUToF` |
| 跨位宽 integer → integer | 按 source signedness 使用 `OpSConvert` / `OpUConvert`；target signedness 不同时，再用等位宽 `OpBitcast` |

Load 的 source 是 buffer leaf，target 是 cooperative component；store 的方向相反。例如 f16 cooperative
从 f32[] 加载时，生成 `OpLoad f32 → OpFConvert f16`；存回 f32[] 时，生成 `OpFConvert f32 → OpStore`。
一个逻辑 component 对应一个 leaf lane，不按字节拼接或拆分；offset、stride、alignment 按原 backing memory
计算。整数 narrowing 保留低位，浮点 conversion 遵循标准 SPIR-V conversion 和模块 float controls；不额外
提供饱和、clamp 或对超出可表示范围的浮点转整数结果作保证。

跨位宽访问在原 memory site 执行逐 scalar access 和 conversion，支持小 shape 展开、大 shape structured loop，
也支持转换后重建 packed cooperative aggregate。它们不被捕获为 direct/fusion 的 buffer source/destination，
后续计算可以消费已经物化并转换的 cooperative value。生成 conversion 时补齐必要的标准数值 capability。
Lower 内部保留防御性类型检查；本阶段不修改 glslang 前端。

### 4.7 固定 hard limit 仍可能拒绝合法 shader

当前存在：

- `max_elements`
- `max_matmul_macs`
- `max_unrolled_elements`
- `max_unrolled_matmul_macs`

Unroll limit 只决定 unrolled 或 rolled，是合理的；但 element/MAC hard limit 可能拒绝本可由循环表达的合法 shader。

语言完备目标要求：

- 大 shape 默认使用 structured loop
- Hard limit 变为用户显式安全策略
- 默认只在 ID 空间、整数溢出或内存耗尽时失败

### 4.8 组合语言闭包（已完成）

当前已经系统覆盖：

- 任意合法深度的 struct/array 递归 nesting
- Function 局部变量与 Private 全局变量中的 cooperative aggregate
- Workgroup 普通数值全局作为 cooperative load/store 的 backing memory
- `VariablePointers` 允许的 pointer-to-pointer 与多级 pointer transport
- 动态 nested AccessChain 和 cooperative vector dynamic insert/extract
- 复杂 call graph、aggregate/cooperative return value 和多个调用点
- loop、switch、selection、Phi/backedge、early return 组成的复杂 structured CFG
- 多 entry point 共享函数与 Private 全局变量
- Core arithmetic、SSA、composite、dynamic indexing 与 HW load/matmul/store 任意交错
- packed/default 与 force-scalar 两条 lowering 路径
- vk_hw 包含 20 个 150–300 行的 production flow case，分别覆盖 load/store、matmul、
  vecmatmuladd、MLP 和 multiops；shared-payload case 通过默认 packed 路径验证同一 buffer 的
  loop-carried RAW 依赖

合法性边界：

- `Function` 是函数局部 storage class，不是全局变量。
- Validator 规定 cooperative 类型或包含它的 aggregate 只能分配在 `Function` 或 `Private`；
  `Workgroup` 支持指普通 scalar/vector/array backing memory，不表示可以直接分配 cooperative 类型。
- Shader capability 要求 structured control flow；真正的不可约 CFG 会被 validator 拒绝，不属于 lowering
  必须接受的合法 shader 集合。

## 5. 语言完备性架构

### 5.1 Universal scalar canonical fallback

实现“不失败”的关键是将 scalar generic lowering 建成完整语言后端：

```text
合法 HW vec/mat 指令
        │
        ├─ fusion 成功 ───────→ optimized IR
        ├─ direct 成功 ───────→ optimized IR
        ├─ packed 成功 ───────→ optimized IR
        │
        └─ 任意失败 ──────────→ scalar canonical lowering
                                      │
                                      └─ 对合法输入必须成功
```

必须满足：

- Match failure → scalar fallback
- Safety proof failure → scalar fallback
- Optimization codegen failure → scalar fallback
- 不支持优化的 shape/type → scalar fallback
- 不可移动 memory access → scalar fallback

只有非法 SPIR-V 或不可恢复的系统资源问题才能返回 `Failure`。

### 5.2 Validator 是语言边界

Lower pass 不应维护一套比 validator 更窄的合法性规则。

应建立机器可检查的语言能力矩阵：

```text
component type
× vec/mat shape
× HW opcode
× core opcode
× ExtInst
× storage class
× decoration
× CFG/composite context
```

Validator 接受集合是 lower 必须覆盖的集合。

## 6. 推荐实施顺序

### 阶段 1：定义语言闭包

- 从 grammar 和 validator 自动提取合法 opcode/type 组合
- 建立“合法且必须 lower”的能力矩阵
- 审计所有 `ReportError` 和 `return false`
- 区分非法输入、优化未匹配和真正不可恢复错误

### 阶段 2：完成 scalar canonical lowering

- 保证 validator 已接受的 core conversion、arithmetic、scale 和 structural opcode 都有 scalar fallback
- 为 validator 拒绝的 comparison、logical、shuffle、dot 等形式保留 negative validation coverage
- 任意 shape 使用 structured loop
- 任意合法 pointer path 可以寻址
- 所有 SSA/composite/function 构造能够重写
- Extension-free 后无 HW residue

### 阶段 3：ExtInst 白名单覆盖

- 覆盖 3.5 中 validator 已接受的 cooperative-vector GLSL.std.450 白名单
- 覆盖 packed、scalar、small-unrolled 和 structured-loop 路径
- 为 matrix result、额外 transcendental、geometric/reduction 和 mixed operand 保留 negative validation coverage

### 阶段 4：严格浮点与动态参数

- `NoContraction`
- Fast-math 和 rounding
- Denorm、NaN/Inf、signed zero
- Specialization constant
- Dynamic layout/reduce control
- 多 entry point float-control

### 阶段 5：Memory 与 aggregate 完备性

- 所有合法 storage class
- Nested pointer/access chain
- 完整 MemoryAccess
- Workgroup/Private/global aggregate
- 复杂 call graph 和 CFG

### 阶段 6：恢复和扩展优化

在 scalar fallback 完备后继续扩展：

- Packed vec2
- Unrolled
- Direct
- Store fusion
- MLP fusion

所有优化都必须保持 fallback contract，不能扩大 pass 的失败集合。

## 7. 测试策略

### 7.1 自动生成能力矩阵测试

对 validator 接受的组合自动生成：

- Opcode × component type
- Opcode × shape
- Packed/scalar
- Constant/spec constant
- Storage class
- Decoration
- CFG/aggregate context

### 7.2 Differential testing

- 原 HW shader 与 lowered shader Vulkan 输出对比
- Scalar 与 packed/direct 输出对比
- Fusion 开关前后输出对比
- 多组 specialization value 对比

### 7.3 Fuzzing

- 只生成 validator 接受的 vec/mat module
- Lower 不得返回 Failure
- Lower 后必须通过 `spirv-val`
- Final residue 必须为零

### 7.4 回归要求

- SPIR-V Tools 完整 CTest
- glslang lowering golden
- Vulkan function
- Vulkan perf，所有 measured case `ratio <= 3.0`

## 8. 最终验收标准

只有同时满足以下条件，才能称为 vec/mat lowering 语言完备：

1. 任意 validator 接受的 vec/mat-only module 不返回 `Failure`。
2. Extension-free 后不存在 HW opcode、type、capability、extension 或嵌套 type reference，也不存在
   replicated-composites opcode、capability 或 extension。
3. Lowered module 通过 `spirv-val`。
4. Scalar lowering 与原 HW shader 的运行结果一致。
5. 禁用 direct、fusion、packed 后仍能成功 lower。
6. Spec constant、复杂 CFG、nested aggregate 和所有合法 storage class 均有覆盖。
7. Failure 只允许来自：
   - 原始 SPIR-V 非法
   - 明确不在 vec/mat 范围内的 HW opcode
   - ID 空间、整数溢出、内存耗尽等不可恢复系统错误

## 9. 核心结论

当前 pass 已经拥有成熟的主流 vec/mat 功能和性能优化，但“不失败”目标不能靠继续扩展 direct/fusion
白名单实现。正确方向是：

> 先将 scalar generic lowering 建成覆盖 validator 合法集合的完整语言后端，再将 packed、direct 和 fusion
> 保持为永远可回退的性能层。
