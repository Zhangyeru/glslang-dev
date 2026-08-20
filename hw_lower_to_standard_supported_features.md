# HW Lower-to-Standard Pass 功能说明

## 1. 总体结论

当前 `hw-lower-to-standard` 已能完整处理本文定义的 cooperative matrix/vector 子集，将其转换为标准 SPIR-V array、vec2 或 scalar 代码；但还不能等价 lower 整个 `SPV_HW_neural_shader`。

本文档描述 2026-08-20 的 `lower-0605` 分支状态，比较基线为：

- glslang：`98791cac`
- SPIRV-Tools：`121650c4`

本文所述 P0、浮点重结合、direct 路径和 golden 更新均按独立提交维护。实现没有修改 `source/val`。

入口与 lowering 调度位于 [`hw_lower_to_standard_pass.cpp`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)；类型、校验、aggregate、elementwise、memory、matmul 和 direct 路径分别拆分在同目录的 `hw_lower_to_standard_*.cpp` 中，共享内部 helper 位于 [`hw_lower_to_standard_pass_internal.h`](External/spirv-tools/source/opt/hw_lower_to_standard_pass_internal.h)。

## 2. 支持的 HW opcode

当前真正实施 lowering 的共有 11 个 HW opcode：

| 类别 | Opcode | 当前语义 |
|---|---|---|
| 类型 | `OpTypeCooperativeMatrixHW` | lower 为 packed vec2 array 或 scalar array |
| 类型 | `OpTypeCooperativeVectorHW` | lower 为 packed vec2 array 或 scalar array |
| 内存 | `OpCooperativeMatrixLoadHW` | RowMajor/ColumnMajor，packed/scalar/循环路径 |
| 内存 | `OpCooperativeMatrixStoreHW` | 同上，支持 matmul-store 融合 |
| 内存 | `OpCooperativeVectorLoadHW` | packed/scalar/循环路径 |
| 内存 | `OpCooperativeVectorStoreHW` | 同上，支持 vecmatmul-store 融合 |
| 计算 | `OpCooperativeMatrixMulAddHW` | `A×B+C`，浮点、整数、mixed precision |
| 计算 | `OpCooperativeVectorMatrixMulHW` | `Vector×Matrix` |
| 计算 | `OpCooperativeVectorMatrixMulAddHW` | `Vector×Matrix+Bias` |
| Reduce | `OpCooperativeMatrixReduceHW` | Row/Column，Add/Min/Max |
| 查询 | `OpCooperativeMatrixLengthHW` | 替换为 `rows*cols` 的 int32 常量 |

权威 opcode 列表位于 [`IsHwOpcode`](External/spirv-tools/source/opt/hw_lower_to_standard_validation.cpp)，实际 lowering dispatch 位于 [`LowerHwInstructions`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

## 3. 类型和内部表示

支持的 cooperative component 类型：

- 浮点：`f16`、`f32`
- 整数：`i8/u8`、`i16/u16`、`i32/u32`
- 明确拒绝：`f64`、`i64/u64`、`bool` 及其他类型

默认内部表示：

- f16/f32 matrix 且 `cols % 2 == 0`：`array<vec2, rows*(cols/2)>`
- f16/f32 vector 且 `length % 2 == 0`：`array<vec2, length/2>`
- 整数或奇数宽度浮点：一维 scalar array
- `scalar` 模式强制所有 cooperative 值使用 scalar array

奇数宽度不是“vec2 + tail”的混合存储布局，而是整个 cooperative 值物化为 scalar array。direct 计算内部可以用结构化循环处理任意 K/N，但不改变该存储布局。matrix 内部统一按逻辑 row-major 展平。

类型检查位于 [`IsSupportedHwComponentType`](External/spirv-tools/source/opt/hw_lower_to_standard_pass_internal.h)，类型物化位于 [`MaterializeLoweredTypes`](External/spirv-tools/source/opt/hw_lower_to_standard_types.cpp)。

## 4. Shape 和 specialization constant

### 4.1 Lower 与 fusion shape 速查

lower pass 没有固定的 shape 白名单。只要 shape 是普通常量、维度为正并且不超过配置的 hard limit，奇数维度和 tail 都属于支持范围：

| 对象或操作 | 支持的逻辑 shape | 默认 hard limit |
|---|---|---:|
| Cooperative vector type | `V[L]` | `1 <= L <= max_elements`，默认 `1,048,576` |
| Cooperative matrix type | `M[R×C]` | `R >= 1`、`C >= 1`、`R*C <= max_elements` |
| Matrix mul-add | `A[M×K] * B[K×N] + C[M×N] -> Result[M×N]` | `M*K`、`K*N`、`M*N <= max_elements`，并且 `M*K*N <= max_matmul_macs`；后者默认 `16,777,216` |
| Vector matmul | `Input[K] * Matrix[K×N] -> Result[N]` | `K`、`N <= max_elements`，`K*N <= max_elements` 且 `K*N <= max_matmul_macs` |
| Vector matmul-add | `Input[K] * Matrix[K×N] + Bias[N] -> Result[N]` | 与 vector matmul 相同；`Bias` 必须为 `[N]` |
| Reduce、conversion 和逐元素操作 | 输入输出保持相同的 vector length 或 matrix rows/cols | 每个 cooperative type 分别满足上述 element limit |

默认 `max_unrolled_elements` 和 `max_unrolled_matmul_macs` 都是 `4,096`。受这些阈值控制且具有 loop fallback 的 load/store、reduce、generic matmul 和批量逐元素操作，在超过 unroll threshold、但没有超过 hard limit 时会改用结构化循环，而不是因 shape 过大而失败。matrix/vector direct 在逻辑 MAC 数不超过 `max_unrolled_matmul_macs` 时完全展开 M/N/K 控制流，超过时使用 runtime structured loops；两种形式都保留 direct pointer streaming，并继续受总体 element/MAC hard limit 约束。常量和 composite 构造仍受 4.2 节单独列出的 constituent 规则约束。

默认 packed 模式不会改变通用 shape 支持范围：

- f16/f32 matrix 仅在 `cols % 2 == 0` 时使用 packed vec2 表示；f16/f32 vector 仅在 `length % 2 == 0` 时使用 packed vec2 表示。
- matrix/vector direct 的同精度 f16/f32 和 f16×f16→f32 路径都支持任意正 K/N；M 不要求偶数对齐。同精度且 K/N 为偶数的 matrix direct 保留 packed 快路径，其余 matrix direct 使用通用结构化循环。
- K 或 N 为奇数、整数、其他 mixed precision 或 force-scalar 情况仍可由 generic scalar/loop 路径 lower；这类情况不是 unsupported。generic 计算中某些本身为偶数宽度的 operand/result 仍可能保留 packed 内部布局。

两层 `HwFuseTwoLayerVectorMatmulPass` 只匹配：

```text
Input[K] * Matrix0[K×N] (+ Bias0[N]) -> Hidden[N]
Hidden[N] * Matrix1[N×P] (+ Bias1[P]) -> Output[P]
```

其中两层之间允许一个 `max(Hidden, 0)` ReLU。fusion 的精确 shape/type 条件是：

- `K >= 1`、`N > 16`、`1 <= P <= 16`；
- `Matrix0` 必须严格为 `[K×N]`，`Matrix1` 必须严格为 `[N×P]`，可选 bias 分别严格为 `[N]` 和 `[P]`；
- component type 必须满足以下一种 profile：全部 cooperative vector、matrix 和 bias 为 f16；或者两层输入与
  matrix 为 f16、bias/累加/ReLU/输出为 f32，并在层间保留一个显式 f32→f16 cooperative-vector conversion；
- K/N/P 必须来自普通 32-bit `OpConstant`，不接受 specialization-constant shape；
- `K*N + N*P = N*(K+P) <= max_unrolled_matmul_macs`，默认上限为 `4,096`，等于上限仍可融合；
- 不要求 K、N 或 P 是 2、4、16 的倍数。K 按标量逐元素遍历；N 按 16 分片，N/P 的奇数尾部使用零补 lane；
- force-scalar 模式不运行 fusion，matrix-matrix 链也不属于该 pass 的匹配范围。

已覆盖的边界示例：`K=3,N=17,P=7`、`K=3,N=18,P=1`、`K=3,N=64,P=7` 和恰好达到预算的 `K=112,N=32,P=16` 可以融合；`N=16`、`P=17` 或预算为 `4,128` 的 `K=113,N=32,P=16` 不融合。其中 `K=3,N=17,P=7` 同时具有 K/N/P tail，并由 SPIRV-Tools 单测和 `vk_hw` Vulkan function/perf 用例共同覆盖。不满足 fusion 条件不代表 lower 失败：只要各层仍满足通用 lower hard limit，就会分别进入普通 lowering。

### 4.2 常量与 specialization constant

当前策略是明确拒绝 specialization-constant shape：

- matrix rows/cols 必须是普通 `OpConstant`
- vector length 必须是普通 `OpConstant`
- matrix load/store layout 必须是普通常量
- reduce axis/combine 必须是普通常量
- 不会使用 `OpSpecConstant` 默认值静默固化尺寸

但 cooperative 数据本身支持：

- `OpSpecConstantComposite`
- `OpConstantComposite`
- `OpConstantCompositeReplicateEXT`
- `OpSpecConstantCompositeReplicateEXT`
- `OpConstantNull`
- `OpUndef`

即“spec constant 数据”支持，“spec constant 类型尺寸/控制参数”不支持。

Composite constituent 规则与 validator 保持一致：

- 普通 matrix `OpConstantComposite` / `OpSpecConstantComposite`：一个直接 component scalar constant/undef，广播到整个 matrix
- 普通 vector `OpConstantComposite` / `OpSpecConstantComposite`：必须提供恰好 `length` 个直接 component scalar constant/undef，不能嵌套普通 vector constant
- 两个 `*ConstantCompositeReplicateEXT`：matrix/vector 都只接受一个直接 component scalar constituent
- 普通 `OpConstantComposite` 不能引用 spec constant；`OpSpecConstantComposite` 可以引用普通或 spec constant
- lower 后单条 composite instruction 最多 65,532 个 constituent：scalar layout 按 element 数计，packed layout 按 vec2 piece 数计；超过限制会在修改模块前失败

## 5. Matrix Reduce

`OpCooperativeMatrixReduceHW` 支持全部 6 种 axis/combine 组合：

- axis `0`：Row reduce，跨 columns 归约，并广播回该行
- axis `1`：Column reduce，跨 rows 归约，并广播回该列
- combine `0`：Add
- combine `1`：Min
- combine `2`：Max

生成操作：

- float Add → `OpFAdd`
- integer Add → `OpIAdd`
- float Min/Max → GLSL `FMin/FMax`
- signed integer Min/Max → GLSL `SMin/SMax`
- unsigned integer Min/Max → GLSL `UMin/UMax`

支持 packed f16/f32、scalar、整数、奇数宽度以及大尺寸三层结构化循环。输入输出必须具有完全相同的 shape 和 component type。

实现位于 [`LowerMatrixReduce`](External/spirv-tools/source/opt/hw_lower_to_standard_matmul.cpp) 和 [`BuildReduceCombine`](External/spirv-tools/source/opt/hw_lower_to_standard_matmul.cpp)。

## 6. Matmul、mixed precision 和 signedness

### 6.1 Matrix

支持：

```text
A[M×K] * B[K×N] + C[M×N] -> Result[M×N]
```

完整 shape hard limit 和 packed/generic 分流见 4.1 节。

### 6.2 Vector

支持：

```text
Input[K] * Matrix[K×N] -> Result[N]
Input[K] * Matrix[K×N] + Bias[N] -> Result[N]
```

完整 shape hard limit 和 fusion eligibility 见 4.1 节。

### 6.3 类型规则

- 所有乘数和 accumulator 必须同属 float 域或 integer 域
- result 类型必须与 C/Bias operand 类型完全相同；SSBO direct 对 converted bias 的例外见 6.4 节
- accumulator 位宽必须不小于任一乘数
- 不支持 accumulator narrowing
- 不支持 float/integer 跨域混合
- 整数输入可以具有不同 signedness 和位宽

支持示例：

- `f16 × f16 -> f16`
- `f16 × f16 -> f32`
- `f16 × f32 -> f32`
- `i8 × u8 -> i32`
- `i8 × u16 -> u32`

整数扩展规则：

- signed 输入使用 `OpSConvert`
- unsigned 输入使用 `OpUConvert`
- accumulator signedness 不同时，再通过 `OpBitcast` 保留位模式
- 最终使用 `OpIMul + OpIAdd`
- 没有饱和运算

浮点 generic 路径使用 `GLSL.std.450 Fma`。整数 mixed precision 按上述 signedness 规则扩展；浮点 mixed
precision 则在乘加前扩展到 accumulator component type。各优化路径额外允许的类型、shape 和浮点 contract 分别见
6.4、6.5 节。

相关实现：

- [`LegalizeModule`](External/spirv-tools/source/opt/hw_lower_to_standard_validation.cpp)：类型、shape 和 MAC 合法性
- [`BuildMatmulAccumulate`](External/spirv-tools/source/opt/hw_lower_to_standard_matmul.cpp)：mixed-precision widening 和乘加

### 6.4 SSBO direct

SSBO direct 的目标是避免先把 cooperative matrix/vector 从 SSBO 完整物化到 Function aggregate，再执行单个
matmul。它捕获可安全移动的原始 buffer pointer，在生成的 helper 中按需加载 operand，但仍产生原 matmul 的结果值。
把 matmul 与 store 一起替换的功能属于 6.5 节的 fusion，不属于本节。

#### 6.4.1 各 direct 路径准入条件

| 路径 | 指令形态 | 类型 | Shape | Operand 处理 |
| --- | --- | --- | --- | --- |
| Matrix direct | `OpCooperativeMatrixMulAddHW` | 同精度 f16/f32；也支持 f16 A/B、f32 C/result | 任意正数 K、N；M/K/N 均不要求偶数对齐 | A、B、C 独立解析为 direct source、constant 或 value 参数；仅某个 source 解析失败时，该 operand 单独改用 constant/value；C 上的 `OpFConvert` 不吸收 |
| Vector direct | vector-matmul / vector-matmul-add | 同精度 f16 或 f32；也支持 f16 input/matrix、f32 accumulator/result/bias | 任意正数 K、N；K/N 均可有 tail | input、matrix、bias 独立解析为 direct source、constant 或 value 参数；仅某个 source 解析失败时，该 operand 单独改用 constant/value |

所有 direct 路径还必须通过下表中的共同或来源相关检查：

| 检查项 | 准入条件 | 不满足时 |
| --- | --- | --- |
| Lowering 模式 | `kPreferPackedVec2` | `kForceScalar` 走 generic 路径 |
| 浮点重结合 | 没有显式约束时使用项目默认的可重结合 contract；显式 `FPFastMathMode` 必须含 `AllowReassoc` 或 `Fast`；匹配 component type 的 `FPFastMathDefault` 也必须含 `AllowReassoc`；拒绝 `NoContraction` | 走 generic 路径 |
| Matrix 来源 | 可追溯到 RowMajor `OpCooperativeMatrixLoadHW`；pointer 可捕获；shape/offset module-visible；MemoryAccess 可移动 | 仅该 operand 改用 constant/value |
| Matrix direct type transport | 允许不改变 operand type 的 transport；显式 matrix-use bitcast 要求 component type 与 shape 完全相同，use tag 可以变化，例如 frontend 为 converted C 生成的 `MatrixUseAHW -> MatrixAccumulatorHW` | component type 或 shape 变化会取消整条 Matrix direct 并走 generic 路径 |
| Vector direct matrix type transport | 允许不改变 operand type 的 transport，以及同 component type、同 shape 的 `MatrixUseAHW -> MatrixUseBHW` 显式 bitcast | component type、shape 或 use 方向不兼容时取消整条 Vector direct 并走 generic 路径 |
| Vector input 来源 | `OpCooperativeVectorLoadHW`，offset 为常量 0，pointer 可捕获且 load 可移动 | 仅该 operand 改用 constant/value |
| 普通 bias 来源 | 与 result 同型的 `OpCooperativeVectorLoadHW`，offset 为常量 0 | 仅 bias 改用 constant/value |
| Converted bias 来源 | 仅 vector direct：`f16 OpCooperativeVectorLoadHW ->` 单个同 shape `OpFConvert -> f32`；load offset 可为任意可表示的常量 | conversion 形态不匹配或 offset 为动态值时仅 bias 改用 constant/value；已捕获链不封闭时取消整条 vector direct，走 generic 路径 |
| Direct load 移动与别名 | load 与 matmul 之间不能存在可能写入同一内存的指令；不同 module root 只有在 pointer path 均无 `Aliased` / `AliasedPointer` 时才可视为不相交 | 仅该 operand 改用 constant/value |
| Function transport | 可穿过无 MemoryAccess operand、pointer 未带 `Volatile` decoration 的 Function `OpStore` / `OpLoad`；`Volatile` 或其他带语义的 memory access 不可删除 | 至少该 operand 改用 constant/value 并保留 transport；删除闭包不成立时整条回退 |
| Direct source 共享与删除闭包 | 已捕获 source 的其他 live user 只能经兼容 bitcast/封闭 Function transport 流向其他 HW op；待删除 load/transport 的 user 必须闭合 | 安全共享时保留原 source/transport 并继续 direct；存在 unsafe shared user 或 kill-chain 不闭合时，取消整条 Matrix/Vector direct，走 generic 路径 |
| 尺寸预算 | `max_elements` / `max_matmul_macs` 是 direct eligibility hard limit；`M*K*N` 或 `K*N` 不超过 `max_unrolled_matmul_macs` 时生成 unrolled direct，否则生成 rolled direct | hard limit 失败时 validation 拒绝；unroll threshold 只切换代码形态 |

上表中的 operand 独立 fallback 仅指“无法把该 operand 解析为可捕获 direct source”的情况。一旦 source
已被捕获，direct 重写还必须同时证明共享 use 安全且待删除链闭合；这类整体安全性检查失败不会只将
单个 operand 改为 value 参数，而是使当前 Matrix/Vector direct 整体回退到 generic lowering。

#### 6.4.2 生成的计算

Matrix direct 以 `M*K*N`、vector direct 以 `K*N` 计算展开预算。预算内的 helper 完全展开输出和 K 控制流，仍按 vec2 K-pack 执行 Fma/horizontal reduction；预算外保留现有 runtime structured-loop helper。两种形式都直接加载 pointer source，并支持 constant/value operand、mixed precision 和奇数 K/N tail。f16×f16→f32 时只在乘加位置插入 f16→f32 `OpFConvert`，结果按实际 lowered layout 写回 packed vec2 或 scalar aggregate。

Converted bias 的常量 offset 会合并到 helper 的 scalar/vec2 索引；原 bias conversion 的
`FPFastMathMode` 会传播到 helper 内对应的 `OpFConvert`，包括显式的 `FPFastMathMode None`，避免生成指令意外继承
非零 `FPFastMathDefault`。

这些路径可能与严格逐 K、以 C/bias 为初始 accumulator 的 Fma 链产生不同的 contraction、舍入、NaN/Inf
或正负零行为。原指令完整的 `FPFastMathMode` 会传播到生成的 Fma、`OpFConvert`、`OpFAdd` 等浮点结果。

相关实现：

- [`TryLowerDirectMatrixMulAdd`](External/spirv-tools/source/opt/hw_lower_to_standard_direct.cpp)：matrix direct
- [`BuildDirectMatrixMatmulFunction`](External/spirv-tools/source/opt/hw_lower_to_standard_direct_generated.cpp)：matrix unrolled/rolled direct 分流
- [`TryLowerDirectVectorMatrixMulPackedVec2`](External/spirv-tools/source/opt/hw_lower_to_standard_direct.cpp)：vector direct
- [`BuildDirectVectorMatmulFunctionPackedVec2`](External/spirv-tools/source/opt/hw_lower_to_standard_direct_generated.cpp)：vector unrolled/rolled direct 分流

### 6.5 Fusion

Fusion 会把多个 HW 指令及其封闭 transport chain 一起替换，而不是像 SSBO direct 那样只改变单个 matmul 的
operand 获取方式。当前包含单算子 store fusion 和两层 vector-matmul fusion。

#### 6.5.1 Fusion 路径与准入条件

| 路径 | 匹配范围 | 类型与 Shape | 数据流 / 内存条件 | 回退行为 |
| --- | --- | --- | --- | --- |
| Matrix store fusion | 三个 matrix load → `OpCooperativeMatrixMulAddHW` → matrix store | A/B/C/result 同为 packed f16 或 f32；`K % 2 == 0`、`N % 2 == 0`，M 可不对齐 | 四端均为 RowMajor，pointer 可捕获，shape/offset module-visible，MemoryAccess 可移动，use-chain 封闭 | 取消 fusion，继续尝试 matrix direct 或 generic lowering |
| Vector store fusion | vector load + matrix load → vector-matmul → vector store | operand/result 同为 packed f16 或 f32；`K % 2 == 0`、`N % 2 == 0` | input/output offset 为 0；matrix 为 RowMajor；input/matrix/output root 已知、互不冲突且无 alias decoration；use-chain 封闭 | 取消 fusion，继续尝试 vector direct 或 generic lowering |
| 带 bias 的 vector store fusion | vector store fusion 中的 matmul 换成 vector-matmul-add | 与无 bias 版本相同 | bias 必须是无类型转换的 `OpConstantComposite`，最多 8 个 vec2 pack（16 个 scalar） | 取消 fusion，继续尝试 vector direct 或 generic lowering |
| 两层 vector-matmul fusion | `matmul0 (+ bias0) -> optional ReLU -> matmul1 (+ bias1)` | 全 f16，或 f16 输入/权重配合 f32 bias/累加及显式层间 f32→f16 conversion；`K > 0`、`N > 16`、`1 <= P <= 16` | 同一 basic block，中间值封闭，满足逐 pair 展开预算 | pair 保持原样，后续逐层 lowering |

所有 fusion 路径只在 `kPreferPackedVec2` 下启用，并要求相关浮点运算允许重结合且不带 `NoContraction`。

#### 6.5.2 单算子 store fusion

Matrix store fusion 将 A/B/C 的 load、matrix-mul-add 和最终 store 替换为一个直接读写 buffer 的 helper。
Vector store fusion 中，无 bias 版本使用两个 vec2 accumulator，并在写回前分别 horizontal reduce；常量 bias
版本使用单个 vec2 accumulator 累加 2 个 `OpDot` 的结果，最后加入 bias 并直接写回。原指令的完整
`FPFastMathMode` 会传播到生成的 Fma、`OpDot` 和 `OpFAdd`。

这类 fusion 对 load/store 的可移动性和死 use-chain 采用保守检查；任一待删除值仍有 live user，或 memory operand
无法安全传播时，都不会执行整条替换。相关实现：

- [`TryLowerFusedMatrixMatmulStore`](External/spirv-tools/source/opt/hw_lower_to_standard_direct.cpp)
- [`TryLowerFusedVectorMatmulStore`](External/spirv-tools/source/opt/hw_lower_to_standard_direct.cpp)

#### 6.5.3 两层 vector-matmul 匹配

`kPreferPackedVec2` 模式会在主 lowering 前运行内部 pass `HwFuseTwoLayerVectorMatmulPass`。`kForceScalar` 不运行该 fusion。pass 以第二层 vector-matmul 为入口，匹配：

```text
hidden = input[K] * matrix0[K×N] (+ bias0[N])
hidden = max(hidden, 0)                    // 可选
hidden = f16(hidden)                       // mixed f16×f16→f32 profile 必需
output = hidden[N] * matrix1[N×P] (+ bias1[P])
```

两层都可以是 `OpCooperativeVectorMatrixMulHW` 或 `OpCooperativeVectorMatrixMulAddHW`，bias 可分别存在。中间 ReLU 只识别 `GLSL.std.450 FMax(hidden, 0)` 或 `FMax(0, hidden)`，其中零必须是同 cooperative vector type 的全零常量；其他 clamp、select、非零 max 不匹配。

##### 两层 fusion 的详细准入条件

| 检查项 | 准入条件 | 不满足时 |
| --- | --- | --- |
| Lowering 模式 | `kPreferPackedVec2` 会在主 lowering 前运行 `HwFuseTwoLayerVectorMatmulPass` | `kForceScalar` 不运行 fusion |
| 指令形态 | 两层均为 vector-matmul 或 vector-matmul-add；层间只允许可选的 `FMax(hidden, 0)` / `FMax(0, hidden)` ReLU | pair 保持原样 |
| Component type | 全部为 f16；或 input/matrix0/层间 activation/matrix1 为 f16，hidden/output/bias 为 f32，且层间 conversion 严格为 f32→f16 | pair 保持原样 |
| Shape 类型与一致性 | shape 是普通 32 位整数常量，并严格满足 `K×N -> N`、`N×P -> P` | pair 保持原样 |
| Shape 范围 | `K > 0`、`N > 16`、`1 <= P <= 16` | pair 保持原样 |
| 控制流 | 两层和可选 ReLU 位于同一 basic block | pair 保持原样 |
| 中间值闭包 | hidden 只由当前融合链消费；可经过同 block 内封闭的 `OpCopyObject`、同 type `OpBitcast` 或 Function variable store/load | 存在额外 live user 时不融合 |
| 浮点约束 | 两层和可选 ReLU 均不带 `NoContraction` | pair 保持原样 |
| 展开预算 | `K×N + N×P <= max_unrolled_matmul_macs`；默认 4,096，边界值允许 | 超出一个 MAC 也不融合 |

不满足这些条件时，fusion 不修改该 pair，后续主 pass 仍会分别 lower 原来的两层，因此“不融合”不等于“不支持”。

#### 6.5.4 两层 fusion 生成的计算

fusion 直接生成标准 scalar/vec2 算术，不物化完整 hidden cooperative vector：

1. output 按相邻两列组成最多 8 个 accumulator vec2，并以第二层 bias 或零初始化。
2. N 维按 16 个 hidden column 分段；每段再按相邻两列构造一个 hidden vec2。
3. 对每个 hidden pair，逐个 K 元素 splat input scalar，与 matrix0 的相邻两个 weight 做对应 accumulator 类型的 vec2 `Fma`，随后执行可选的 vec2 ReLU。
4. hidden pair 的两个 lane 立即与 matrix1 的对应两行相乘，更新所有 output accumulator，不保留完整 hidden 数组。
5. 最后从 output pair 提取 P 个有效 scalar，构造原 output cooperative vector value，供主 lowering 继续处理。

全 f16 profile 使用 f16vec2 accumulator。mixed profile 使用 f32vec2 accumulator：第一层 f16 input/weight
先 widening 到 f32，完成 f32 Fma 与可选 ReLU 后用 `OpQuantizeToF16` 生成可观察的 f16 精度值，再参与第二层
f32 Fma；因此不会把原 shader 的层间 f16 activation 静默提升为全程 f32，也不会让后端把连续
f32→f16→f32 SSA conversion 折叠为 identity。

上述遍历在 fusion pass 中按常量 shape 静态展开，不生成 runtime loop；`max_unrolled_matmul_macs` 同时承担代码尺寸预算。N 最后一段的奇数 hidden lane 以及奇数 P 的无效 output lane 使用零补齐，并跳过不存在的第二行更新，不生成越界 extract 或 load。

#### 6.5.5 多层链配对

更长的线性链采用贪心、非重叠的两层配对。每个候选都把当前 matmul 当作第二层，并向前追溯尚未消费的第一层；成功 rewrite 后生成的是普通 composite，不会再次充当另一 pair 的 cooperative 第一层。因此：

- 四层链可形成 `(L1,L2)` 和 `(L3,L4)` 两个 pair
- 五层链可形成两个 pair，剩余一层进入普通 lowering
- 中间某层不满足条件时，不影响后续独立 pair 继续匹配
- MAC budget 对每个 pair 独立计算，不按整条 MLP 链累计

`vk_hw_runner` 用任意长度 `layer_dims` 描述这类 MLP，命令行形式为 `--layer-dims 8,48,8,48,4`；
`--activation-dtype` 描述非最终层 ReLU 后的存储/舍入类型，缺省等于 `--accum-dtype`。旧的 `--d0` 到
`--d3` 三层形式仍保留兼容。

#### 6.5.6 两层 fusion 内的 matrix/bias direct load

fusion 会分别尝试将 matrix0、matrix1、bias0 和 bias1 从原 cooperative load 改成按需 scalar load。四个 operand 独立判定：某个 operand 不满足 direct 条件时，仅该 operand 保留 aggregate extract 路径，不会关闭其他 operand 的 direct load，也不会单独导致整个 pair 取消 fusion。

matrix direct load 要求：

- 来源可在同一 basic block 内经封闭 transport chain 追溯到同 type `OpCooperativeMatrixLoadHW`
- layout 为 RowMajor，shape/offset 为 module-visible 普通常量；按原 row-major 公式计算的最大扁平索引可由 32 位 `OpAccessChain` 表达
- pointer 指向 component 完全匹配的 array/runtime array；Function 和 Private storage 不接受
- 固定长度 array 还会检查实际上界；runtime array 允许 `neural.frag` 使用的跨逻辑 shape 线性窗口
- PhysicalStorageBuffer load 显式带合法 `Aligned`

bias direct load 要求来源为同 type `OpCooperativeVectorLoadHW`，offset 是可表示完整 bias 范围的非负 32 位常量；固定长度 array 还会检查上界。mixed profile 额外允许吸收 f16 load 后紧邻 transport chain 的 f32 `OpFConvert`，按需 scalar load 后恢复同一 conversion 及其 `FPFastMathMode`。

#### 6.5.7 两层 fusion 的内存与浮点语义

可移动 direct load 只传播 `Aligned`、`Nontemporal`、`NonPrivatePointer`、`AliasScopeINTEL` 和 `NoAliasINTEL`。`Aligned` 必须是非零 2 的幂，并按 `ArrayStride × element index` 对应的实际 byte offset 收紧；alias scope operand 必须 module-visible。

load 与第二层之间采用保守的纯操作 allowlist。`Volatile`、MakePointerAvailable/Visible、barrier、atomic、call、cooperative/image/module write、带 memory operand 的 Function store、共享 source 或未知副作用都会使相关 operand 回退 aggregate 路径。普通、无 memory operand 的 Function store/load 只在封闭 transport chain 内允许。

项目对该 fusion 使用允许重结合的 MLP contract。第一层、ReLU、层间 quantize、bias conversion 和第二层原有的显式 `FPFastMathMode`（包括 `None`）分别传播到对应生成算术；最终 replacement `OpCompositeConstruct` 不保留浮点 decoration。mixed bridge 带 `FPRoundingMode` 或模块声明 16-bit `RoundingModeRTE/RTZ` 时不融合；模块存在 `FPFastMathDefault` 而 bridge 没有显式 override 时也保守回退，避免 f16/f32 默认值错配。`NoContraction` 无法由该重写等价表达，因此 validator/lower preflight 会拒绝，单独运行 fusion pass 时也不会匹配。

实现与测试：

- [`hw_fuse_two_layer_vector_matmul_pass.cpp`](External/spirv-tools/source/opt/hw_fuse_two_layer_vector_matmul_pass.cpp)
- [`hw_fuse_two_layer_vector_matmul_test.cpp`](External/spirv-tools/test/opt/hw_fuse_two_layer_vector_matmul_test.cpp)

## 7. Core conversion、算术和 ExtInst

### 7.1 Conversion

支持：

- `OpConvertFToU`
- `OpConvertFToS`
- `OpConvertSToF`
- `OpConvertUToF`
- `OpUConvert`
- `OpSConvert`
- `OpFConvert`
- `OpBitcast`

输入输出逻辑 shape 必须相同。

`OpBitcast` 额外要求：

- matrix→matrix：rows/cols 相同且 component bit width 相同
- vector→vector：length 相同且 component bit width 相同
- lowered representation 相同时变为 `OpCopyObject`
- packed/scalar 不同时逐元素 bitcast

### 7.2 Arithmetic

浮点：

- `OpFAdd`
- `OpFSub`
- `OpFMul`
- `OpFDiv`
- `OpFNegate`

同 shape 的 f16/f32 cooperative operand 可以混用。lower 会先按元素或 vec2 piece 插入 `OpFConvert`，统一到 result component type，再执行原浮点运算。

整数：

- `OpIAdd`
- `OpISub`
- `OpIMul`
- `OpSDiv`
- `OpUDiv`
- `OpSNegate`

位运算：

- `OpShiftRightLogical`
- `OpShiftRightArithmetic`
- `OpShiftLeftLogical`
- `OpBitwiseOr`
- `OpBitwiseXor`
- `OpBitwiseAnd`
- `OpNot`

整数 core operation 的类型规则：

- `IAdd/ISub/IMul/SDiv/SNegate`：shape 和 component bit width 必须一致，signedness 可以不同
- `UDiv`：result 和两个 operand 必须都是 unsigned，且 component bit width 必须一致
- shift 仅允许 cooperative vector；base 与 result 同 bit width，shift operand 可以是 8/16/32 位任意 signedness
- bitwise 仅允许 cooperative vector；operand/result 同 bit width，signedness 可以不同
- 当前 validator 会接受 mixed-width HW `UDiv`，但其隐式转换时机没有明确等价语义；pass 明确失败，不猜测 narrowing/extension 规则

Scale：

- `OpVectorTimesScalar`
- `OpMatrixTimesScalar`

不在当前 closure 中的典型操作包括 `OpFRem`、`OpFMod`、`OpSRem`、`OpUMod`、比较操作、`OpVectorShuffle`、`OpDot`；直接作用于 cooperative 值会失败。

完整分类位于 [`IsCoreOpcodeAllowedOnHwValue`](External/spirv-tools/source/opt/hw_lower_to_standard_pass_internal.h)。

### 7.3 GLSL.std.450

当前仅支持 cooperative vector result，不支持 cooperative matrix result。

支持的 extended instruction：

- 一元：`Atan`、`Tanh`、`Exp`、`Log`
- 二元：`FMin/FMax`、`NMin/NMax`、`Step`、`UMin/UMax`、`SMin/SMax`
- 三元：`FClamp`、`NClamp`、`Fma`、`UClamp`、`SClamp`

所有 value operand 必须是等长 cooperative vector，import 必须是 `GLSL.std.450`。浮点 ExtInst 要求 component type 完全相同；整数 U/S min/max/clamp 只要求相同 bit width，opcode 决定 signed/unsigned 解释，`OpTypeInt` signedness 可以混用。

## 8. SSA、CFG 和 composite

当前支持：

- `OpPhi`，包括 loop backedge 上携带 cooperative 值
- `OpSelect`，条件必须是 scalar bool
- `OpCompositeConstruct`
- `OpCompositeConstructReplicateEXT`
- `OpCompositeExtract`
- `OpCompositeInsert`
- `OpVectorExtractDynamic`
- `OpVectorInsertDynamic`
- `OpCopyObject`
- `OpCopyLogical`

具体行为：

- `OpPhi` 不逐元素展开，直接将 result/incoming 类型统一改成 lowered array type
- pass 新增 lowering 循环时会保存并恢复外层 `OpLoopMerge`
- `OpSelect` 的源条件必须是 scalar bool；SPIR-V 1.3 的 packed-loop 路径会在 preheader 将其 splat 为 `v4bool`，避免用 scalar bool 直接选择 vector
- runtime matrix `OpCompositeConstruct` 必须恰好提供一个同 component scalar，并广播到整个 matrix
- runtime vector `OpCompositeConstruct` 可混用同 component scalar 与普通 vector constituent，但展开后的 component 总数必须恰好等于 length；单 scalar 不是普通 vector 的广播形式
- runtime `OpCompositeConstructReplicateEXT` 对 matrix/vector 都要求一个同 component scalar；小尺寸展开，大尺寸使用结构化 broadcast loop
- matrix extract/insert 的 row、column 会映射为 flat index 或 pack+lane
- packed dynamic index lower 为 `/2` 和 `%2`
- dynamic access/index 支持最多 64 位整数
- 支持穿过嵌套 array、runtime array、struct、普通 vector/matrix 的 composite 路径

实现位于：

- [`RemapCompositeIndices`](External/spirv-tools/source/opt/hw_lower_to_standard_aggregate.cpp)
- [`LowerAccessChain`](External/spirv-tools/source/opt/hw_lower_to_standard_aggregate.cpp)
- [`LowerSelect`](External/spirv-tools/source/opt/hw_lower_to_standard_aggregate.cpp)

## 9. 函数边界和嵌套类型

支持重写：

- `OpTypeFunction`
- `OpFunction`
- `OpFunctionParameter`
- `OpFunctionCall`
- `OpReturnValue`
- cooperative type 嵌套于 array/struct/pointer/function type
- `Function` storage 下的局部 cooperative aggregate variable，以及 `Private` storage 下的模块级 cooperative aggregate variable
- 函数参数、返回值、嵌套 struct/array 返回值及指针参数
- lower 后若 cooperative signature 与已有普通 signature 相同，会 canonicalize `OpTypeFunction`、替换所有使用并删除重复声明

关键限制：

- 指向 cooperative 值或包含 cooperative 值的 pointer 只允许 `StorageClass Function` 或 `StorageClass Private`
- `StorageBuffer`、`Uniform` 等不能直接存放整个 cooperative aggregate
- 该限制不影响 cooperative HW load/store 使用外部 scalar buffer；限制的是“把整个 cooperative array value 存入 Function/Private 之外的 storage”

Function variable forwarding 很保守：

- 只转发同一 basic block 内的直接普通 store/load
- 跨 block、derived access chain、alias store、`Volatile` load 都保留真实标准 array load/store
- forwarding 只针对 `Function` variable；`Private` 全局变量始终保留真实 load/store

递归类型检查位于 [`TypeContainsHw`](External/spirv-tools/source/opt/hw_lower_to_standard_types.cpp)。

## 10. 其他允许的结构 opcode

以下 opcode 被 authoritative closure 识别，合法输入主要依赖递归类型替换自然变成标准 array/struct/pointer 操作：

- `OpVariable`、`OpLoad`、`OpStore`
- `OpCopyMemory`、`OpCopyMemorySized`
- `OpAccessChain`、`OpInBoundsAccessChain`
- `OpPtrAccessChain`、`OpInBoundsPtrAccessChain`
- `OpTypeArray`、`OpTypeRuntimeArray`、`OpTypeStruct`
- `OpTypePointer`、`OpTypeForwardPointer`
- `OpLifetimeStart`、`OpLifetimeStop`
- `OpArrayLength`
- `OpSizeOf`
- `OpPtrEqual`、`OpPtrNotEqual`、`OpPtrDiff`

`OpCopyLogical` 已覆盖 distinct nested aggregate；若类型替换后 source/result type ID 合并，会防御性改写为 `OpCopyObject`。

这里的“closure 识别”不等于每个 opcode 都存在独立、可由 validator 接受的 cooperative 用例。`OpTypeForwardPointer`、runtime-array `OpArrayLength` 等通常要求与 cooperative whole-object 限制冲突的 storage class，因此不作为独立端到端能力宣称；合法的 Function/Private 形式才属于支持范围。

## 11. Load/store 和 MemoryAccess

### 11.1 Matrix 地址计算

shape/offset 是至少 2 个 component 的 vector，component 可为 int32 或 f32。

RowMajor 地址：

```text
(offset.row + row) * shape.cols + offset.col + col
```

ColumnMajor 地址：

```text
(offset.col + col) * shape.rows + offset.row + row
```

### 11.2 Vector 地址计算

```text
offset + logical_index
```

vector offset 支持 1–64 位 signed/unsigned integer。这里的 64 位仅用于索引，不代表支持 64 位 cooperative component。

外部 pointer 的 pointee 必须是 component 完全匹配的 `OpTypeArray` 或 `OpTypeRuntimeArray`。pass 不自动进行 bounds check、clamp 或越界零填充。

### 11.3 MemoryAccess

支持并传播：

- `Volatile`
- `Aligned`
- `Nontemporal`
- `MakePointerAvailable`
- `MakePointerVisible`
- `NonPrivatePointer`
- `AliasScopeINTEL`
- `NoAliasINTEL`

处理规则：

- `Aligned` 会根据 component 自然对齐和已知 byte offset 安全收紧
- `PhysicalStorageBuffer` 支持，但原访问必须显式携带 `Aligned`
- 带不可移动内存语义、alias 风险、barrier、atomic、call 或 intervening write 时，会禁用 fused/helper 优化并回退普通逐元素 lower
- fallback 路径仍会完整保留 memory operand

实现位于 [`NormalizeMemoryOperandsForAccess`](External/spirv-tools/source/opt/hw_lower_to_standard_memory.cpp)。

## 12. 大尺寸与配置

默认配置：

| 参数 | 默认值 |
|---|---:|
| `max_elements` | 1,048,576 |
| `max_matmul_macs` | 16,777,216 |
| `max_unrolled_elements` | 4,096 |
| `max_unrolled_matmul_macs` | 4,096 |

超过 hard limit 时失败；对受 unroll threshold 控制的 generic 路径，超过阈值时改为结构化循环：

- 大 load/store：逐元素 memory loop
- 大 matmul：output × K 双层循环
- 大 reduce：output/reduce/broadcast 三层循环
- elementwise conversion/arithmetic/scale：按 scalar 或 vec2 piece 循环

matrix/vector direct 在 MAC 数小于等于 `max_unrolled_matmul_macs` 时生成无 `OpLoopMerge` 的完全展开 helper，超过时生成 rolled helper；阈值边界包含在 unrolled 一侧。该阈值不会关闭 direct，只有总体 `max_elements` 或 `max_matmul_macs` hard limit 会阻止 direct 路径。

unroll threshold 内部还会截断到 65,532，避免生成无法序列化的超长 composite instruction。

公共配置定义位于 [`HwLowerToStandardOptions`](External/spirv-tools/include/spirv-tools/optimizer.hpp)。

## 13. 两种 completeness 模式

CLI：

```text
--hw-lower-to-standard[=<options>]
--hw-lower-to-standard-extension-free[=<options>]
```

支持的 options：

```text
pack | scalar
max-elements=N
max-macs=N
unroll-elements=N
unroll-macs=N
```

### 13.1 cooperative-only

这是默认模式：

- lower 上述 11 个 cooperative opcode
- 允许其他 HW opcode 和 `Relreg` 保留
- 必要时保留 `SPV_HW_neural_shader`

### 13.2 extension-free

成功返回时保证不存在任何已知 HW opcode、capability、extension、operand 或 cooperative type reference。

以下 9 个 HW opcode 尚无等价 lower，严格模式会在修改 IR 前失败：

- `OpTypeTensorMapHW`
- `OpCpAsyncTensorGlobalSharedHW`
- `OpCpAsyncCommitGroupHW`
- `OpCpAsyncWaitGroupHW`
- `OpBarrierArriveHW`
- `OpBarrierWaitHW`
- `OpShuffleIndexHW`
- `OpBytePermuteHW`
- `OpShuffleFillDownHW`

`OpSelectionMerge` 的 `Relreg` operand 同样会失败。

严格预检位于 [`PreflightExtensionFreeMode`](External/spirv-tools/source/opt/hw_lower_to_standard_validation.cpp)，最终残留扫描位于 [`FinalHwCheck`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

## 14. 明确不支持的能力

当前不支持：

- cooperative component `f64`、`i64/u64`、`bool`
- specialization-constant shape、layout、reduce control
- dynamic cooperative matrix/vector 类型尺寸
- float/integer 跨域 matmul
- accumulator narrowing
- 与 result 类型不同的 C/Bias
- integer saturation
- `NoContraction` cooperative matrix matmul 无法 lower；HW vector-matmul 在 validator 和 lower preflight 阶段即被拒绝
- mixed-width cooperative `OpUDiv`
- packed integer vec2
- `vec2[] + scalar tail` 混合内部表示
- RowMajor/ColumnMajor 之外的 matrix layout
- pointee 为 struct、ordinary vector 或不同 component array 的 HW memory access
- 缺少显式 `Aligned` 的 PhysicalStorageBuffer HW access
- 自动越界检查、clamp 或零填充
- cooperative matrix result 上的 GLSL.std.450 `OpExtInst`
- TensorMap、CpAsync、Barrier、Shuffle 和 Relreg 的等价 lowering

需要特别区分：64 位 cooperative component 不支持，但 64 位 vector offset、packed dynamic index 和 PhysicalStorageBuffer 地址支持。

## 15. 当前验证状态

本次审计现场运行结果：

- `cmake --build build -j8`：通过
- SPIRV-Tools CTest：32/32 通过
- SPIRV-Tools `HwFuseTwoLayerVectorMatmulTest.*`：56/56 通过；覆盖全 f16 与 mixed f16×f16→f32 pair、可观察 activation quantize、显式 fast-math `None`、rounding-mode 回退、converted bias direct load、线性 matrix window、四层双 pair、五层组合及 packed outer lowering
- SPIRV-Tools `HwLowerToStandardTest.*`：214/214 通过
- Optimizer API/CLI option 测试：2/2 通过
- glslang lowering 集成测试：4/4 通过
- `vk_hw` Python 单测：55/55 通过
- `vk_hw_build_shaders_script_tests`、`vk_hw_case_parsing_tests`、`vk_hw_reference_tests`：3/3 通过
- `vk_hw_build_shaders`：通过
  - 覆盖 78 个 HW shader、76 个 baseline 和 1 个 unsupported HW shader
  - 执行 extension-free lowering
  - 执行 `spirv-val` 校验
  - 扫描所有 `*HW` opcode、HW/AZD capability/extension 和 `Relreg` residue
  - 验证 cooperative-only 保留 TensorMap，而 extension-free 明确失败
  - 执行 lowered GLSL golden 对比：154/154 匹配
- 顶层 CTest：8/8 通过
- 完整 `vk_hw_function`：77/77 通过，无 skip；10 个 MLP 用例全部 verify 通过；mixed MLP 的 `activation_dtype=f16`、`accum_dtype=f32`，严格 f32 比较下 `max_abs_error=0`、`max_rel_error=0`
- 2026-08-20 现场采样，`warmup=20`、`repeat=200` 的完整 `vk_hw_perf`：76/76 完成且 lowered/baseline verify 均通过，无 skip
  - odd-tail fusion `mlp_f16_3x17_17x7` ratio 0.7030，lowered/baseline 均 verify 通过
  - mixed `mlp_f16xf16_to_f32_biasconvert_10x64_64x16` 使用与 `neural.frag` 相同的单一 3600-element 参数 buffer 和 W0/W1/B0/B1 offsets；ratio 1.1359，lowered/baseline 均严格 verify 通过
  - 四层 `mlp_f16_8x48_48x8_8x48_48x4`：ratio 0.6564；lowered 11319.0 ns，baseline 17245.0 ns
  - 五层 2-2-1 `mlp_f16_8x48_48x8_8x48_48x8_8x4`：ratio 0.6826；lowered 12797.6 ns，baseline 18747.0 ns
  - 五层 2-1-2 `mlp_f16_8x48_48x8_8x8_8x48_48x4`：ratio 0.7151；lowered 12192.8 ns，baseline 17049.8 ns；(L1,L2) 和 (L4,L5) 融合，L3 的输出宽度为 8，不满足 fusion 的 `N > 16`，因此保留为普通 lowering
  - Matrix direct 相关用例 `matmul_f16_7x5x3`、`matmul_f16xf16_to_f32_4x4x4`、`matmul_f16xf16_to_f32_7x5x3` 的 ratio 分别为 0.9937、0.9316、0.8271
  - `mlp_f16_8x48_48x8_8x4` 的 ratio 为 0.7380
  - `matmul_f32_constw_4x4x4` 的 ratio 为 0.9105
  - 完整采样中的 `load_store_i16_4x4` 瞬时 ratio 为 2.8894；以 `warmup=50`、`repeat=500` 复测为 0.9815，判定为测量抖动
  - 除以下 5 个已解释超限项外，其余 71 个用例 ratio 均不超过 2；超限项以 `warmup=50`、`repeat=500` 复测确认
  - `multiops_f32_16x16x16`：复测 ratio 2.6959；其中 `16*16*16=4,096` 个 matrix MAC 恰好命中 direct unroll 边界，完全展开的直线 Fma/helper 代码增加了指令缓存和调度压力；这是可配置代码尺寸阈值在默认边界上的明确取舍
  - `matmul_f16xf16_to_f32_cconvert_7x5x3`：复测 ratio 2.3619；Matrix direct 按设计不吸收 C 的 cooperative `OpFConvert`，因此在 unrolled direct helper 前仍需用独立循环把 35 个 f16 C 元素物化并转换为 f32 aggregate；该小 shape 仅有 105 个 MAC，转换循环和 aggregate 传参开销超过 baseline 的静态计算
  - `vecmatmuladd_f16_convert_32x16`：复测 ratio 21.8380；f16/f32 往返转换物化并复制大型 aggregate，产生 4 KiB scratch 和大量 scratch load/store；vec2 将原 vec4 aggregate 拆为两倍 piece，进一步增加循环和索引开销
  - `load_store_f32_scalar_5x7`：复测 ratio 5.3391；scalar aggregate 的 4 个动态循环和 private-array 动态索引被后端展开为大量分支/选择，baseline 则完全展开并向量化
  - `matmul_f16_32x32x32`：复测 ratio 4.8856；三层动态循环阻止后端展开和跨 output tile 复用 A/B，vec2 的 output/K pack 数量也高于原 vec4 路径；主要瓶颈不是寄存器 spill

glslang 的 fixture/golden 与 SPIRV-Tools lowering 是跨仓配对修改，集成、推送或回放时必须使用匹配 revision。

因此最准确的能力描述是：

> 当前 pass 已具备本文定义的 cooperative matrix/vector lower 完整能力；对整个 HW neural shader extension，则通过 extension-free 模式实现“能等价 lower 的全部消除，不能等价 lower 的明确失败”，而不是宣称所有 HW opcode 都已经支持。
