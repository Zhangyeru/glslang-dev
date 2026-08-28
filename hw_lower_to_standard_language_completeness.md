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
- Vulkan function：84/84 通过，无 skip
- Vulkan perf：84/84 满足 `lowered_ns / baseline_ns <= 3.0`
- Extension-free 成功时无 HW opcode、type 或 nested reference residue

## 4. 当前仍可能失败的合法 vec/mat 语言形态

### 4.1 Core opcode 没有形成完整闭包

当前未覆盖的典型操作：

- `OpFRem`
- `OpFMod`
- `OpSRem`
- `OpSMod`
- `OpUMod`
- 浮点和整数 comparison
- Logical operation
- Cooperative `OpVectorShuffle`
- `OpDot`
- 部分 matrix shift/bitwise 组合

应以 validator 接受集合为准生成完整 opcode 清单。纯逐元素操作应统一进入通用 elementwise lowering，
而不是继续依赖零散白名单。

### 4.2 GLSL.std.450 不完整

当前缺口：

- Cooperative matrix result
- 大量一元浮点函数，如 Sin、Cos、Sqrt、Abs、Floor、Ceil
- Pow 等多 operand 指令
- Length、Distance、Normalize、Cross 等 geometric/reduction 指令
- Scalar 与 cooperative operand 混合的合法签名

建议将 ExtInst 分为：

1. 纯 elementwise
2. 多 operand elementwise
3. Reduction/geometric

前两类使用统一逐元素框架，第三类按明确语义单独实现。

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
validator 一致，不在 lower 内私自扩展。现有 HW memory validator/GLSL overload 仍允许 cooperative component
与 buffer leaf component 具有不同 bit width；本阶段不猜测其跨宽度 raw-memory 重组或数值 conversion，
该类型语义归入 4.6，后续必须按扩展规范实现，不能通过收窄 validator 规避。

### 4.6 类型规则尚未形成闭包

当前拒绝：

- f64
- i64/u64
- bool component
- Accumulator narrowing
- Result 与 C/Bias 不同类型
- Mixed-width cooperative UDiv
- Float/integer 跨域 matmul

需要以 HW extension grammar 和 validator 为准：

- Validator 接受的组合必须 lower
- Validator 拒绝的组合不属于完备性目标
- 语义不明确时先补规范和 validator，不能在 lower 中猜测 conversion

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

### 4.8 组合语言覆盖不完整

仍需系统验证：

- 任意深度 struct/array nesting
- Function、Private、Workgroup 全局变量
- 多级 pointer
- 复杂 call graph
- Cooperative return value 的多个调用点
- 复杂或不可约 CFG
- 动态 composite indexing
- 多 entry point 共享函数和全局变量
- Core op 与 HW op 任意交错

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

- 补齐所有合法 core elementwise opcode
- 补齐 comparison、logical、shuffle、dot
- 任意 shape 使用 structured loop
- 任意合法 pointer path 可以寻址
- 所有 SSA/composite/function 构造能够重写
- Extension-free 后无 HW residue

### 阶段 3：补齐 ExtInst

- Cooperative vector 完整 GLSL.std.450
- Cooperative matrix GLSL.std.450
- Scalar/cooperative 混合 operand
- Reduction/geometric 独立实现

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
2. Extension-free 后不存在 HW opcode、type、capability、extension 或嵌套 type reference。
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
