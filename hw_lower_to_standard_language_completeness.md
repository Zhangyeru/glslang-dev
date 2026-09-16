# HW Vec/Mat Lower Pass：已实现能力与语言完备性缺口

## 1. 范围与当前结论

核对日期：2026-09-15。本文以当前 `lower-0605` 工作区为准：glslang `e252d0e5`、
SPIRV-Tools `5e242e48`、SPIRV-Headers `223be10`，以及本次两个 P0 的工作区修改。不同分支的 API 或测试结论不能直接套用。
本分支 matrix load/store 使用 `Matrix Shape` / `Matrix Offset` 的 ivec2 接口。

当前已实现主要 cooperative vector/matrix 指令、validator 白名单内的 core/ExtInst 运算、
复杂组合语言结构、跨位宽 memory conversion 和严格浮点路径，并有 packed/direct/两层 MLP 优化。
**目前仍不能宣称“任意 validator 接受的 vec/mat-only module 均可 extension-free lower”。**
两个 P0 已按当前 Vulkan 范围实现：layout 限定为普通常量 0/1，默认取消人为 element/MAC 限额，
超大常量改用循环物化。仍缺少优化代码生成失败后统一恢复与 scalar fallback 的保证，以及完备性验证矩阵。

本文的完备性目标覆盖 cooperative vec/mat 类型、相关 HW 操作，以及 validator 允许作用于这些值的
core、extended instruction、SSA/CFG、函数、aggregate 和 memory 结构。TensorMap、CpAsync、HW Barrier、
`OpShuffleIndexHW`、`OpBytePermuteHW`、`OpShuffleFillDownHW` 和 `OpSelectionMerge` 的 `Relreg` operand
不在目标内；extension-free 模式
会预先拒绝这些没有标准等价 lowering 的 HW opcode/operand。

`kCooperativeOnly` 与 `kExtensionFree` 是不同 contract。前者可保留其他 HW 功能；后者成功时要求消除
HW opcode/type/capability/extension、嵌套引用及 replicated-composites residue。“Extension-free”
在这里不表示删除模块使用的所有其他标准扩展。

版本与行为依据：[grammar](External/spirv-tools/external/spirv-headers/include/spirv/unified1/spirv.core.grammar.json)、
[pass 入口和最终检查](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)、
[preflight 与合法化](External/spirv-tools/source/opt/hw_lower_to_standard_validation.cpp)。

## 2. 已实现能力

以下“支持”均以当前 validator 约束、输入预处理和第 3 节尺寸/表示限制为前提。
实现与代表性测试索引见 4.1；保留详细语义是为了区分功能支持与优化准入。

### 2.1 类型与内部表示

当前实现并有针对性测试覆盖的能力：

- Cooperative vector 和 cooperative matrix
- 浮点 component：f16、f32
- 整数 component：i8/u8、i16/u16、i32/u32
- 偶数宽度浮点使用 packed vec2 array
- 奇数宽度、整数和 force-scalar 模式使用 scalar array
- Matrix 统一使用逻辑 row-major flatten 表示
- Cooperative 类型嵌套在普通 array、struct 和 pointer 中
- Function 参数、返回值和局部变量中的 cooperative 类型
- Function type 重写、去重和 canonicalization
- `OpConstantComposite`、`OpSpecConstantComposite`、两种 constant replicate、`OpConstantNull` 与 `OpUndef`；
  matrix 常量接受一个 scalar 广播，普通 vector 常量要求 length 个直接 scalar constituent
- Extension-free 模式在 3.4 的表示限制内将固定 constituent 数量的 replicated composite 展开为 core composite，并删除
  `ReplicatedCompositesEXT` capability 与 `SPV_EXT_replicated_composites` declaration

### 2.2 HW vec/mat 指令

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

Matmul 当前实现并有针对性测试覆盖的能力：

- 在 element/MAC hard limit 内的正 M/N/K，支持超出 unroll 阈值后的 structured loop
- 奇数 K/N 和 scalar tail
- f16/f32 mixed operand 到 f32 accumulator/result
- 整数 mixed width 和 signedness
- Constant、value argument 和直接 buffer source
- 大 shape structured-loop fallback
- `NoContraction` 与 `ContractionOff` 严格逐 K `FMul + FAdd` 路径

### 2.3 Core conversion 与算术

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

### 2.4 SSA、CFG、composite 与函数

当前实现并有针对性测试覆盖的能力：

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

### 2.5 GLSL.std.450

当前 cooperative vector 支持的 extended instruction 包括：

- Atan、Tanh、Exp、Log
- FMin/FMax、NMin/NMax
- UMin/UMax、SMin/SMax
- Step
- FClamp/NClamp、UClamp/SClamp
- Fma

Cooperative matrix result 的 GLSL.std.450 当前被 validator 拒绝，属于合法性边界（见 3.1），
不是 lower 单独遗漏的合法输入。

### 2.6 优化路径

当前已经实现：

- Packed vec2 lowering
- Matrix/vector direct 输入 pointer streaming；matmul 返回 lowered aggregate，后续 store 独立 lowering
- Unrolled/rolled direct helper
- f16/f32 operand 独立类型
- f32 accumulator 专用 unroll 上限
- Constant/value operand fallback
- f16→f32→f16 无损往返转换链消除
- 两层 MLP fusion
- Shared source 与 kill-list 闭包检查
- 小型 force-scalar 浮点 elementwise 静态展开

### 2.7 严格浮点与多 entry point contract

Cooperative matrix/vector matmul 的 `NoContraction` 已有实现与回归覆盖：validator 允许 direct 或 decoration-group
形式修饰 HW vector matmul/matmuladd；glslang 会把 `precise` cooperative 输出传播到对应 HW 结果指令。

Lowering 采用以下 contract：

- 原 HW matmul 带 `NoContraction`，或其函数位于任一 `ContractionOff` entry point 的调用树中时，启用严格路径；
- 小 shape 使用 scalar fallback，大 shape 使用 structured-loop fallback，均按 K=0 到 K-1 顺序计算；
- 浮点 operand 先扩展到 accumulator 类型，再生成普通 `OpFMul` 和 `OpFAdd`，不生成 Fma；
- 源于 `NoContraction` 时，生成的每条 `OpFMul` 和 `OpFAdd` 都传播 `NoContraction`；仅源于
  `ContractionOff` 时由 entry-point execution mode 约束；
- strict matmul 禁止 direct 和两层 MLP fusion；共享函数只要被一个 `ContractionOff` 入口调用，
  就保守使用 strict lowering；
- 整数 matmul 继续按逐 K `OpIMul + OpIAdd` lowering，合法的 `NoContraction` 输入不会导致失败。

Fast-math 状态同时保存 mask 与 decoration 是否显式存在，因此显式 `FPFastMathMode None` 不会与无 decoration
共享错误 helper，并会覆盖 entry point 的 `FPFastMathDefault`。RTE/RTZ、denorm preserve/flush 和
`SignedZeroInfNanPreserve` 保留在原 entry-point 调用树上，生成的浮点操作自然继承相应 contract；不同 entry
point 可以对独立或共享调用树使用不同 float-control 配置。

Validator 原有冲突规则保持不变，包括同一结果不能同时使用 `NoContraction` 与 `FPFastMathMode`、同一 entry
point 不能同时使用 `FPFastMathDefault` 与 `ContractionOff`，以及 `FPFastMathDefault` 调用树中不能包含
`NoContraction`。

### 2.8 Specialization normalization：pipeline 支持

`HwLowerToStandardPass` 本身仍不使用 specialization constant 的默认值静默决定类型尺寸或
控制参数：未解析的 rows/cols/length 和 reduce axis/op 直接传给 raw lower 时
仍会被拒绝。`vk_hw` 构建脚本在 lower 之前执行以下流程；生产驱动集成时也需要显式实现同一 contract：

```text
[有外部 specialization value 时] --set-spec-const-default-value
  → --freeze-spec-const
  → --fold-spec-const-op-composite
  → --hw-lower-to-standard-extension-free[=scalar]
  → --fold-spec-const-op-composite
```

该流程已实现并覆盖：

- 没有传入任何 specialization value 时省略 set pass，所有 SpecId 使用模块默认值；
- 只传入部分 SpecId 时覆盖这些值，其余 SpecId 仍使用模块默认值；
- 模块不含 specialization constant 时，freeze 和 fold 是 no-op，因此所有 shader 可以共用同一流程；
- 经过 normalization 后，spec-constant matrix rows/cols、vector length 以及 reduce axis/op 都成为 raw lower 已支持的普通常量；shape 由 `OpSpecConstantOp` 表达式派生时也先被折叠；
- lower 后再执行一次 fold，清理 lower 重建的 spec composite；最终 artifact 必须无
  `OpSpecConstant*` 和 HW residue，并通过 `spirv-val`。

`vk_hw` 用 3 个 shader 类的 default/partial/full 各 3 个 variant，共 9 个 Vulkan function case
覆盖上述语义。每个 frozen module 只对应一组最终 specialization 状态；生产驱动的缓存键
必须包含显式覆盖和采用默认值后的完整结果。`vk_hw` sidecar 的外部覆盖当前限定为直接 integer
specialization constant；构建脚本会在执行 set pass 前校验 SpecId 存在、类型为整数且值在对应位宽范围内，
避免 SPIRV-Tools 对无效映射静默沿用默认值。

Layout 不再属于 specialization 控制：前端与 validator 只允许普通整数常量 0/1，
即使 specialization 默认值为 0/1 也会拒绝。Load/store 的三个 spec variant 仅改变 shape；
ColumnMajor 由独立的固定 layout=1 shader 覆盖。

### 2.9 Pointer 与 memory

当前 vec/mat memory lowering 使用统一模型：

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
  标准数值转换，详见 2.10
- Matrix RowMajor/ColumnMajor subregion 的 shape/offset 地址计算继续作用于上述统一 flatten index
- load storage class：Workgroup、StorageBuffer、PhysicalStorageBuffer、Uniform
- store storage class：Workgroup、StorageBuffer、PhysicalStorageBuffer
- `Volatile`、`Aligned`、`Nontemporal`、`MakePointerAvailable`、`MakePointerVisible`、
  `NonPrivatePointer`、alias scope 和 no-alias operand 均传播到最终 scalar access
- constant nested access 的 byte offset/Alignment 可以沿 array stride 与 vector lane 递归计算；动态 offset
  保守退化为 component natural alignment
- generic、packed 和 direct 内存访问共用 pointer layout/element access 实现

优化路径无法捕获 pointer 或证明 memory operand 可移动时，仍回退 generic lowering，不把优化未匹配视为
lower failure。

当前边界：不插入 bounds clamp/check；layout 普通常量规则见 3.2；storage class 集合保持与
validator 一致，不在 lower 内私自扩展。跨位宽 memory access 使用 2.10 的数值转换约定，保持原 pointer
layout 和地址计算；涉及这些访问的 pointer 不进入 direct/fusion 或 packed pointer-chunk helper。

### 2.10 跨位宽 memory conversion

2.1、3.1 的 component 类型限制针对 cooperative 类型，不限制普通 buffer leaf 使用 f64/i64/u64。HW load/store 的跨位宽
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
Lower 内部保留防御性类型检查。

### 2.11 组合语言结构

已有组合测试覆盖以下场景；这些案例不等同于任意深度、任意组合的完备性证明：

- 多层 struct/array 递归 nesting
- Function 局部变量与 Private 全局变量中的 cooperative aggregate
- Workgroup 普通数值全局作为 cooperative load/store 的 backing memory
- `VariablePointers` 允许的 pointer-to-pointer 与多级 pointer transport
- 动态 nested AccessChain 和 cooperative vector dynamic insert/extract
- 复杂 call graph、aggregate/cooperative return value 和多个调用点
- loop、switch、selection、Phi/backedge、early return 组成的复杂 structured CFG
- 多 entry point 共享函数与 Private 全局变量
- Core arithmetic、SSA、composite、dynamic indexing 与 HW load/matmul/store 交错
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

## 3. 限制与剩余缺口

### 3.1 Validator 排除项与目标范围边界

以下输入在当前 validator 中非法，不计为 lower 遗漏的合法能力：

| 类别 | 当前边界 |
|---|---|
| Cooperative component | 仅 f16/f32、i8/u8、i16/u16、i32/u32；拒绝 f64、i64/u64、bool |
| Core 运算 | 拒绝 cooperative `OpFRem/FMod/SRem/SMod/UMod`、数值 comparison、logical、`OpVectorShuffle`、`OpDot`；shift/bitwise 只允许 cooperative vector |
| Structural | Scalar-bool `OpSelect` 合法且已 lower，不能与被排除的 logical 运算混淆 |
| GLSL.std.450 | 仅 2.5 的 cooperative-vector 白名单；matrix result、Sin/Cos/Sqrt/Abs/Floor/Ceil、Pow、geometric/reduction 和 mixed scalar/cooperative 签名不合法 |
| Matmul | 拒绝跨 float/integer 域、accumulator 比乘数窄、Result 与 C/Bias 类型不完全一致；同域 mixed-precision widening 合法 |
| UDiv | Cooperative operand/result 必须为同位宽 unsigned integer |
| 动态控制 | Runtime cooperative 类型尺寸和 runtime reduce axis/op 被 constant-instruction 规则排除；spec constant 的预处理见 2.8 |
| 存储与 CFG | Cooperative 类型及包含它的 aggregate 只可分配在 Function/Private；Workgroup 仅作普通数值 backing memory；Shader 要求 structured CFG |

上述集合依据当前 [validator](External/spirv-tools/source/val) 的 type、arithmetic、logical、composites、
conversion、extensions 和 memory 检查。未来 validator 扩大合法集时，应同步扩展 lower 与 positive coverage。
这也不包括第 1 节明确排除的其他 HW 扩展能力。

### 3.2 Matrix layout：validator 排除动态和 specialization 输入（P0 已实现）

前端与 [HW memory validator](External/spirv-tools/source/val/validate_memory.cpp) 对 load/store 使用同一边界：
layout 必须为普通整数常量 0（RowMajor）或 1（ColumnMajor），接受整数 `OpConstantNull` 表示零。
Runtime SSA、参数、Phi/Select、undef、specialization constant 及其表达式均被拒绝；越界常量单独报值域错误。
保留既有整数类型范围并检查完整值，64-bit 高位不为零不能截断后通过。

Lower 继续保留防御性检查。这里不实现动态 dispatch；shape/offset 接口保持不变，shape 与 reduce control
仍可通过 freeze/fold specialization normalization 处理。

### 3.3 默认资源策略：零表示不启用人为限额（P0 已实现）

[构造参数](External/spirv-tools/source/opt/hw_lower_to_standard_pass.h)、公共 C++ options 和 CLI 已统一：

| 参数 | 默认值 | 行为 |
|---|---:|---|
| `max_elements` / `max-elements` | 0 | 不启用人为 element 限额；正值才进行策略拒绝 |
| `max_matmul_macs` / `max-macs` | 0 | 不启用人为 MAC 限额；正值才进行策略拒绝 |
| `max_unrolled_elements` / `unroll-elements` | 4,096 | 超过阈值的受控路径使用 structured loop |
| `max_unrolled_matmul_macs` / `unroll-macs` | 4,096 | 选择 unrolled/rolled，f32 direct 仍有更小内部阈值 |

Unroll 参数必须为正；设置非零 hard limit 时，unroll limit 不能超过对应 hard limit。
零值只取消策略上限，不取消表示检查：cooperative 逻辑 element 数必须可由 uint32 索引表示，matrix
乘积先以 uint64 计算并检查后才能收窄，MAC 计数使用 uint64。不能表示的尺寸、ID 耗尽等仍明确失败。
已有正例覆盖超过旧 1,048,576 elements 和 16,777,216 MAC 的输入，显式限额负例继续保留。

### 3.4 超大常量与 replicated composite：循环物化（P0 已实现，Vulkan 范围）

SPIR-V 单条 core composite 仍最多 65,532 个 constituent；这个序列化规则不再直接成为大常量的拒绝条件。
[大常量后端](External/spirv-tools/source/opt/hw_lower_to_standard_constants.cpp) 分析紧凑常量依赖，
对超限 HW 广播、replicated constant、普通 array replicate 和依赖它们的父 aggregate 按需生成循环 helper。
小常量继续静态表示；packed 按 vec2 piece 计数，scalar 按逻辑 element 计数，不改数组类型或外部 buffer 布局。

函数使用在入口变量声明之后物化并按函数复用；HW 大广播直接填充本地存储，动态 vector extract 可直接访问
该存储。普通 runtime replicate 保持原求值位置。静态 extract 尽可能沿常量依赖解析，避免把常量用途变成运行时用途。

Function initializer 在函数入口初始化；Private 与合法 Output initializer 在相关 entry point 的原始逻辑前
每个 invocation 初始化一次，共享函数不会重置 Private 数据。可达性分析也追踪全局 pointer-to-pointer
别名，避免遗漏间接访问。覆盖多 entry point、Phi、函数参数及嵌套 aggregate。
非 Vulkan 的非零共享/只读全局初始化不在本次范围，不能套用每个 invocation 的循环初始化。

循环物化需要实际存储和初始化时间；编译器后端与设备资源限制仍存在，不承诺大尺寸的固定运行或编译成本。
测试见 [large constant tests](External/spirv-tools/test/opt/hw_lower_to_standard_constants_test.cpp)。

### 3.5 优化回退 contract：已有不匹配回退，缺少统一失败恢复

已经实现的行为是：direct/fusion 不匹配或无法证明 source 可移动、共享 use/kill-list 安全时，保留
原语义并走 value/generic 路径；force-scalar 模式禁用 direct 与两层 fusion。严格浮点也走 generic。
当前 direct 仅融合输入读取与计算，不合并后续 store；这属于优化边界，不是 store 功能缺口。

但 [Process / LowerHwInstructions](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp) 中仍有：

- 两层 fusion 返回 `Status::Failure` 时，整个 pass 直接失败；
- direct 返回 `false` 时向上传播失败；其他生成/类型重写阶段也会传播失败；
- 没有围绕整个优化阶段建立统一的 IR 恢复和 scalar 重试机制。

因此“优化代码生成失败必定回退 scalar”仍是目标，不是现有保证。返回失败本身也不证明每条路径都有
可触发的合法输入缺陷；需要审计失败来源，区分非法输入、未匹配、资源不足和生成失败，并避免在
部分修改过的 IR 上直接重试。

### 3.6 验证覆盖尚不等于语言完备性证明

当前有 focused positive/negative tests、Vulkan function/reference、标准 baseline/perf 和组合 workload。
仍需建立从 validator 合法集合出发的自动能力矩阵，以及系统性差分测试和只生成合法 module 的 fuzzing。
现有案例数量不能证明任意 nesting、CFG、pointer path、decoration 和 opcode 组合都成功。

## 4. 验证证据与回归要求

### 4.1 实现与代表性测试索引

| 能力 | 实现入口 | 代表性测试/用例 |
|---|---|---|
| 类型、aggregate、函数与 replicated composite | [types](External/spirv-tools/source/opt/hw_lower_to_standard_types.cpp)、[aggregate](External/spirv-tools/source/opt/hw_lower_to_standard_aggregate.cpp) | [aggregate tests](External/spirv-tools/test/opt/hw_lower_to_standard_aggregate_test.cpp)、[composition tests](External/spirv-tools/test/opt/hw_lower_to_standard_composition_test.cpp) |
| Core conversion/arithmetic、ExtInst | [elementwise](External/spirv-tools/source/opt/hw_lower_to_standard_elementwise.cpp)、[opcode 白名单](External/spirv-tools/source/opt/hw_lower_to_standard_pass_internal.h) | [elementwise tests](External/spirv-tools/test/opt/hw_lower_to_standard_elementwise_test.cpp)、[negative validation](External/spirv-tools/test/opt/hw_lower_to_standard_validation_test.cpp) |
| Nested memory、alignment、memory operands、跨位宽转换 | [memory](External/spirv-tools/source/opt/hw_lower_to_standard_memory.cpp) | [memory tests](External/spirv-tools/test/opt/hw_lower_to_standard_memory_test.cpp)，含 loop-carried 同 root 访问、动态 offset 和 conversion 矩阵 |
| Matmul/reduce、mixed precision、严格浮点 | [matmul](External/spirv-tools/source/opt/hw_lower_to_standard_matmul.cpp) | [matmul tests](External/spirv-tools/test/opt/hw_lower_to_standard_matmul_test.cpp)、[NoContraction validation tests](External/spirv-tools/test/opt/hw_lower_to_standard_validation_test.cpp) |
| Direct 与两层 fusion | [direct](External/spirv-tools/source/opt/hw_lower_to_standard_direct.cpp)、[fusion](External/spirv-tools/source/opt/hw_fuse_two_layer_vector_matmul_pass.cpp) | [matmul tests](External/spirv-tools/test/opt/hw_lower_to_standard_matmul_test.cpp)、[fusion tests](External/spirv-tools/test/opt/hw_fuse_two_layer_vector_matmul_test.cpp) |
| Specialization normalization | [build_shaders.py](tests/vk_hw/scripts/build_shaders.py) | [脚本测试](tests/vk_hw/scripts/test_build_shaders.py)、[shader 与 spec sidecar](tests/vk_hw/shaders/hw) |
| Production flow 与 Vulkan 执行 | [vk_hw CMake](tests/vk_hw/CMakeLists.txt)、[reference](tests/vk_hw/runner/reference.cpp) | [function runner](tests/vk_hw/scripts/run_function_tests.py)、[perf runner](tests/vk_hw/scripts/run_perf_tests.py)、[GLSL goldens](tests/vk_hw/glsl/hw) |

### 4.2 验证记录

两个 P0 的最终构建与回归日志分别为 [build](build/hw_p0_final_build.log)、
[SPIRV-Tools](build/hw_p0_final_spirv_ctest.log)、[顶层 CTest](build/hw_p0_final_top_ctest.log)。
当前 function/perf JSON 位于 `build/tests/vk_hw/results/`，判定必须同时检查数值 verify、skip_reason 和 ratio。

2026-09-15 已完成一次 P0 全量验证：顶层 8/8、GLSL golden 205 match、function 119/119、perf 84/84，
无 skip；当次最大 ratio 为 2.9838259442，未超过 3.0 或 5.0。证据分别保存为
[顶层快照](build/hw_p0_verified_top_ctest.log)、[function 快照](build/hw_p0_verified_functional.json)、
[perf 快照](build/hw_p0_verified_perf.json)。随后补充全局指针别名初始化回归，
[最终 focused 日志](build/hw_p0_final_focused.log) 的 18 个大常量/配置测试全部通过；
定稿后的完整回归使用上方 `hw_p0_final_*` 日志，保留前述快照以区分各轮结果。

以下为 P0 实现之前的文档刷新历史记录，不能作为新实现的验证结果。

2026-09-14 在上述工作区完成以下实测；下表记录首轮结果，不是沿用旧文档的通过数字。
为了避免后续执行覆盖证据，function/perf JSON 与详细 CTest 输出另存为本地快照（均在 `build/`，不提交）。

| 检查 | 本次结果 | 本地证据 |
|---|---|---|
| 全量构建 | 通过 | [build log](build/hw_completeness_refresh_build.log) |
| SPIRV-Tools CTest | 32/32 通过，41.90 秒 | [CTest log](build/hw_completeness_refresh_spirv_tools_ctest.log) |
| 顶层 CTest | 8/8 通过，133.32 秒 | [CTest log](build/hw_completeness_refresh_top_ctest.log) |
| GLSL golden | 202 match，0 mismatch，0 missing | [详细测试快照](build/hw_completeness_refresh_top_details.log) |
| Vulkan function | 116 pass，0 fail，0 skip；verify 全部通过 | [functional snapshot](build/hw_completeness_refresh_functional.json) |
| Vulkan perf | 84 measured/pass，0 fail，0 skip；lowered/baseline verify 全部通过；ratio 全部 ≤ 3.0 | [perf snapshot](build/hw_completeness_refresh_perf.json) |

该次最大 ratio 为 **2.7744223853**，对应 `matmul_f16xf16_to_f32_cconvert_7x5x3.lowered.spv`；
超过 3.0 或 5.0 的 measured case 均为 0。该性能数字只描述这次运行，不是跨设备或跨运行的保证。
第二轮在相同代码和性能配置下，全量构建与 SPIRV-Tools 32/32 仍通过，但顶层为 **7/8**：
`vk_hw_perf` 失败。Function 仍为 116/116、0 skip；perf 有 84 个 measured case、0 skip，
数值 verify 与 baseline verify 全部通过，其中 **1 个 ratio 超过 3.0**，没有超过 5.0 的 case。

失败仍来自 `matmul_f16xf16_to_f32_cconvert_7x5x3.lowered.spv`：`lowered_ns = 22023.8`、
`baseline_ns = 7240.4`，ratio = **3.0417932711**。两轮对同一用例的结果跨越 3.0 门槛，
不能宣称性能稳定通过；具体计时波动原因尚未定位，本次只修改文档，不调整 lowering 或放宽阈值。
证据：[第二轮顶层日志](build/hw_completeness_refresh_final_top_ctest.log)、
[第二轮 perf 快照](build/hw_completeness_refresh_second_perf.json)、
[第二轮 function 快照](build/hw_completeness_refresh_second_functional.json)。

Perf JSON 的行级 `status: pass` 与数值 `verify: pass` 不等于 ratio 检查通过；脚本还会独立执行
`find_ratio_regressions` 并以非零退出码报告超限。汇总时必须同时检查 ratio 与 CTest 结果。
定稿后的回归输出另存为 [构建日志](build/hw_completeness_refresh_verified_build.log)、
[SPIRV-Tools 日志](build/hw_completeness_refresh_verified_spirv_tools_ctest.log) 和
[顶层日志](build/hw_completeness_refresh_verified_top_ctest.log)，不覆盖上述两轮证据。

本地日志链接在没有构建产物的全新 checkout 中可能不可用，可按 4.3 的命令重现。

### 4.3 命令与性能判定

文档修改后按仓库要求依次执行：

```bash
cmake --build build -j8
ctest --test-dir build/External/spirv-tools --output-on-failure -j16
ctest --test-dir build --output-on-failure -j32
```

顶层套件已包含 `vk_hw_build_shaders`、`vk_hw_function`、`vk_hw_perf`；shader 构建比较 golden，
本次不使用 `--update-golden`。性能配置使用 20 次 warmup、200 次 repeat，并排除 `*flow*.lowered.spv`，
因此 function 覆盖数不等于 perf measured 数，不能把性能结论扩展到所有 production flow。

当前 CMake 与 perf 脚本采用 `ratio = lowered_ns / baseline_ns <= 3.0`；仓库指南要求 measured case
`ratio <= 5.0`。本次保留较严格的现有配置，不将门槛放宽：超过 3.0 会使当前 perf 测试失败，超过 5.0
还必须在变更说明中给出根因解释，不能静默接受。记录 measured/skip/failed 数量及最大 ratio，
任何 skipped case 保留原 `skip_reason`。失败或环境不可用应如实标注，不能记为通过。

## 5. 后续优先级与完备性验收

| 优先级 | 待完成工作 | 验收要点 |
|---|---|---|
| P0，已实现 | Layout 仅允许普通常量 0/1 | 前端和 validator 正负例；固定 RowMajor/ColumnMajor；spec shape 用例保留 |
| P0，已实现 | 取消默认人为限额，超大常量循环物化 | 显式限额与表示溢出负例；constituent 边界、函数/全局初始化、packed/scalar 及 Vulkan 用例 |
| P1 | 审计错误路径并建立可恢复的优化失败回退 | 不匹配与生成失败分开；重试基于有效 IR；禁用 direct/fusion/packed 后仍满足相同功能 contract |
| P1 | 自动能力矩阵、差分测试与合法输入 fuzzing | 覆盖类型 × shape × opcode × storage × decoration × CFG/aggregate；检查输出验证、residue 和语义 |

最终目标是：对范围内、完成明确 specialization normalization 的合法 vec/mat module，默认配置不因
优化准入、可循环表达的尺寸或语言组合而失败；输出通过 `spirv-val`，无目标 HW/replicated residue，
并与参考结果一致。Raw pass 与 preprocessing pipeline 的验收必须分开记录。

非法输入、明确范围外的 HW 能力、用户显式配置的资源策略和实际不可恢复资源错误应单独诊断。
本次关闭两个 P0 在上述范围内的实现缺口；P1 的统一失败恢复、自动能力矩阵和更广泛完备性验证仍待完成。
