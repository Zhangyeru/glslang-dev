# HW Lower-to-Standard Pass 功能说明

## 1. 总体结论

当前 `hw-lower-to-standard` 已能完整处理本文定义的 cooperative matrix/vector 子集，将其转换为标准 SPIR-V array、vec4 或 scalar 代码；但还不能等价 lower 整个 `SPV_HW_neural_shader`。

本文档描述 2026-07-24 的工作树状态，基线提交为：

- glslang：`98791cac`
- SPIRV-Tools：`121650c4`

本文所述 P0 已提交；本轮浮点重结合、direct 路径和 golden 更新尚未提交。实现没有修改 `source/val`。

核心实现位于 [`hw_lower_to_standard_pass.cpp`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

## 2. 支持的 HW opcode

当前真正实施 lowering 的共有 11 个 HW opcode：

| 类别 | Opcode | 当前语义 |
|---|---|---|
| 类型 | `OpTypeCooperativeMatrixHW` | lower 为 packed vec4 array 或 scalar array |
| 类型 | `OpTypeCooperativeVectorHW` | lower 为 packed vec4 array 或 scalar array |
| 内存 | `OpCooperativeMatrixLoadHW` | RowMajor/ColumnMajor，packed/scalar/循环路径 |
| 内存 | `OpCooperativeMatrixStoreHW` | 同上，支持 matmul-store 融合 |
| 内存 | `OpCooperativeVectorLoadHW` | packed/scalar/循环路径 |
| 内存 | `OpCooperativeVectorStoreHW` | 同上，支持 vecmatmul-store 融合 |
| 计算 | `OpCooperativeMatrixMulAddHW` | `A×B+C`，浮点、整数、mixed precision |
| 计算 | `OpCooperativeVectorMatrixMulHW` | `Vector×Matrix` |
| 计算 | `OpCooperativeVectorMatrixMulAddHW` | `Vector×Matrix+Bias` |
| Reduce | `OpCooperativeMatrixReduceHW` | Row/Column，Add/Min/Max |
| 查询 | `OpCooperativeMatrixLengthHW` | 替换为 `rows*cols` 的 int32 常量 |

权威 opcode 列表位于 [`IsHwOpcode`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)，实际 lowering dispatch 位于 [`LowerHwInstructions`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

## 3. 类型和内部表示

支持的 cooperative component 类型：

- 浮点：`f16`、`f32`
- 整数：`i8/u8`、`i16/u16`、`i32/u32`
- 明确拒绝：`f64`、`i64/u64`、`bool` 及其他类型

默认内部表示：

- f16/f32 matrix 且 `cols % 4 == 0`：`array<vec4, rows*cols/4>`
- f16/f32 vector 且 `length % 4 == 0`：`array<vec4, length/4>`
- 整数或非 4 对齐浮点：一维 scalar array
- `scalar` 模式强制所有 cooperative 值使用 scalar array

非 4 对齐不是“vec4 + tail”的混合布局，而是整个值回退到 scalar array。matrix 内部统一按逻辑 row-major 展平。

类型检查位于 [`IsSupportedHwComponentType`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)，类型物化位于 [`MaterializeLoweredTypes`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

## 4. Shape 和 specialization constant

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
- lower 后单条 composite instruction 最多 65,532 个 constituent：scalar layout 按 element 数计，packed layout 按 vec4 piece 数计；超过限制会在修改模块前失败

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

支持 packed f16/f32、scalar、整数、非 4 对齐以及大尺寸三层结构化循环。输入输出必须具有完全相同的 shape 和 component type。

实现位于 [`LowerMatrixReduce`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp) 和 [`BuildReduceCombine`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

## 6. Matmul、mixed precision 和 signedness

### 6.1 Matrix

支持：

```text
A[M×K] * B[K×N] + C[M×N] -> Result[M×N]
```

### 6.2 Vector

支持：

```text
Input[K] * Matrix[K×N] -> Result[N]
Input[K] * Matrix[K×N] + Bias[N] -> Result[N]
```

### 6.3 类型规则

- 所有乘数和 accumulator 必须同属 float 域或 integer 域
- result 类型必须与 C/Bias 类型完全相同
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

浮点 generic 路径以及 matrix/non-fused-vector direct 路径使用 `GLSL.std.450 Fma`。无 bias 的 fused vector-store 路径与 baseline 保持相同的四路 vec4 累加结构：每个 K tile 生成 4 个 Fma，循环结束后分别做 horizontal reduce；常量 bias 的 fused vector-matmul-add 路径则对每个 4-column tile 生成 4 个 `OpDot`，再用一次 vec4 `OpFAdd` 累加。没有显式浮点约束时，lower pass 的默认 contract 允许沿 K 方向重结合，因此满足 direct 条件的 matrix/vector matmul 会优先使用 direct 或 fused-direct 路径。显式 `FPFastMathMode` 优先于该默认值：只有包含 `AllowReassoc` 或 `Fast` 才允许 direct；匹配 component type 的 `FPFastMathDefault` 也必须包含 `AllowReassoc`。如果 entry point 已声明其他 component type 的 `FPFastMathDefault`，未匹配的当前 type 按无 fast-math flags 处理。`NoContraction` 无法由当前重结合 lowering 等价表达，因此明确拒绝。

direct/fused-direct 只支持 operand 和 result component type 完全相同的 packed f16 或 f32；mixed precision、整数、force-scalar 和非 4 对齐 shape 走 generic 路径。traced matrix load 还必须是 RowMajor、pointer 可捕获、shape/offset module-visible 且 MemoryAccess 可移动；vector input/bias load 要求 offset 为 0。fused vector-store 覆盖 output offset 为 0 的 `OpCooperativeVectorMatrixMulHW`，以及最多 4 个 vec4 pack、没有类型转换的 `OpConstantComposite` bias 的 `OpCooperativeVectorMatrixMulAddHW`。streaming fusion 还要求 input/matrix/output root 已知且互不冲突，并且没有 `Aliased`/`AliasedPointer`；类型变化、潜在 alias、不安全或不封闭的 use-chain 都会回退。

matrix/non-fused-vector direct 路径按 4 个 K 元素分组累加并执行 horizontal reduce；matrix mul-add 再用独立 `OpFAdd` 加 C。无 bias 的 fused vector-store 使用四个 vec4 accumulator，并在写回前分别 horizontal reduce；常量 bias 的 fused vector-matmul-add 使用单个 vec4 accumulator 累加 4 个 `OpDot` 的结果，最后加入 bias 并直接写回。结果可能与严格逐 K、以 C/bias 为初始 accumulator 的 Fma 链产生不同的 contraction、舍入、NaN/Inf 或正负零行为。原指令已有的完整 `FPFastMathMode` 仍会传播到生成的 Fma、`OpDot`、FConvert、FAdd、Min/Max 等结果。

相关实现：

- [`LegalizeModule`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)：类型、shape 和 MAC 合法性
- [`BuildMatmulAccumulate`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)：mixed-precision widening 和乘加
- [`TryLowerDirectMatrixMulAddPackedVec4`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)：matrix direct 路径
- [`TryLowerDirectVectorMatrixMulPackedVec4`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)：vector direct 路径
- [`TryLowerFusedVectorMatmulStore`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)：vector fused-store 与常量 bias 路径

### 6.4 两层 vector-matmul fusion

packed 模式会在主 lowering 前运行内部 pass `HwFuseTwoLayerVectorMatmulPass`，识别同一 basic block 内的：

```text
hidden = input[1×K] * matrix0[K×N] (+ bias0)
hidden = max(hidden, 0)                 // 可选
output = hidden[1×N] * matrix1[N×P] (+ bias1)
```

启用条件：

- 全部 cooperative component 都是 f16
- `N > 16`，`1 <= P <= 16`
- K/N/P 都是普通常量，spec-constant shape 不匹配
- 两层及可选零 ReLU 位于同一 basic block
- 中间值只有融合链使用；允许通过封闭的 Function variable store/load 传递
- `K*N + N*P <= max_unrolled_matmul_macs`
- force-scalar 模式完全跳过该 pass

N 按 16 切分，但实际计算以相邻两个 hidden column 为一个 f16vec2：先用 `splat(input[k]) * matrix0[k][h:h+2]` 生成 hidden pair，执行可选 vec2 ReLU，然后立即用 matrix1 的对应两行更新最多 8 个 f16vec2 output accumulator。K、N 或 P 的奇数尾部用零补 lane，不生成越界 extract/load。

更长的线性 MLP 链按指令顺序进行不重叠的两层配对：四层链可融合 `(layer1, layer2)` 与 `(layer3, layer4)`，五层链同样融合前两对并保留最后一层进入普通 lowering。MAC 阈值对每个候选 pair 独立计算，不按整条链累计；一次 rewrite 生成的 cooperative result composite 不会再与紧邻层重叠融合。`vk_hw_runner` 的 MLP 元数据使用任意长度 `layer_dims`，命令行以 `--layer-dims 8,48,8,48,4` 传入，同时保留原 `--d0` 到 `--d3` 的三层兼容形式。

对每个可封闭追溯到常量 shape/offset 的 RowMajor `OpCooperativeMatrixLoadHW` operand，fusion 会尝试从原 array pointer 流式加载元素；两层 mul-add 的 bias 若可封闭追溯到常量 offset 的 `OpCooperativeVectorLoadHW`，也会直接按输出 lane 加载，不再先物化完整 cooperative vector 和 Function 临时数组。四个 matrix/bias 候选分别判定，一个 operand 回退不会关闭其他 operand 的 direct 路径。

这些 direct load 都会传播可移动的 `Aligned`、`Nontemporal`、`NonPrivatePointer`、`AliasScopeINTEL` 和 `NoAliasINTEL`；`Aligned` 按实际 `ArrayStride` 对应的 byte offset 收紧。direct source 不接受 Function/Private storage，索引必须能由 32 位 `OpAccessChain` 表达。内存时序检查采用保守的纯操作允许列表；遇到 Volatile、MakePointerAvailable/Visible、HW async/split barrier、named/control/memory barrier、atomic、call、cooperative/image/module write、共享 source 或其他未知副作用时，仅该 operand 保留原 cooperative load，由普通 lowering 处理。

该内部 fusion 采用本项目允许重结合的两层 MLP contract：即使原结果带 `NoContraction` 或未声明 `AllowReassoc` 也会融合，并将原有 `FPFastMathMode` 分别传播到生成的 stage1、ReLU 和 stage2 运算；replacement composite 上不保留浮点算术 decoration。这是上一节普通 direct/generic matmul 规则的显式例外。

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

同 shape 的 f16/f32 cooperative operand 可以混用。lower 会先按元素或 vec4 piece 插入 `OpFConvert`，统一到 result component type，再执行原浮点运算。

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

完整分类位于 [`IsCoreOpcodeAllowedOnHwValue`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

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
- packed dynamic index lower 为 `/4` 和 `%4`
- dynamic access/index 支持最多 64 位整数
- 支持穿过嵌套 array、runtime array、struct、普通 vector/matrix 的 composite 路径

实现位于：

- [`RemapCompositeIndices`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)
- [`LowerAccessChain`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)
- [`LowerSelect`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)

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

递归类型检查位于 [`TypeContainsHw`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

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

实现位于 [`NormalizeMemoryOperandsForAccess`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

## 12. 大尺寸与配置

默认配置：

| 参数 | 默认值 |
|---|---:|
| `max_elements` | 1,048,576 |
| `max_matmul_macs` | 16,777,216 |
| `max_unrolled_elements` | 4,096 |
| `max_unrolled_matmul_macs` | 4,096 |

超过 hard limit 时失败；超过 unroll threshold 时改为结构化循环：

- 大 load/store：逐元素 memory loop
- 大 matmul：output × K 双层循环
- 大 reduce：output/reduce/broadcast 三层循环
- elementwise conversion/arithmetic/scale：按 scalar 或 vec4 piece 循环

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

严格预检位于 [`PreflightExtensionFreeMode`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)，最终残留扫描位于 [`FinalHwCheck`](External/spirv-tools/source/opt/hw_lower_to_standard_pass.cpp)。

## 14. 明确不支持的能力

当前不支持：

- cooperative component `f64`、`i64/u64`、`bool`
- specialization-constant shape、layout、reduce control
- dynamic cooperative matrix/vector 类型尺寸
- float/integer 跨域 matmul
- accumulator narrowing
- 与 result 类型不同的 C/Bias
- integer saturation
- `NoContraction` cooperative matrix/vector matmul
- mixed-width cooperative `OpUDiv`
- packed integer vec4
- `vec4[] + scalar tail` 混合内部表示
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
- SPIRV-Tools `HwFuseTwoLayerVectorMatmulTest.*`：37/37 通过；覆盖四层双 pair、五层双 pair 加普通尾层 (2-2-1)、五层双 pair 夹单普通层 (2-1-2) 及 packed outer lowering
- SPIRV-Tools `HwLowerToStandardTest.*`：189/189 通过
- Optimizer API/CLI option 测试：2/2 通过
- glslang lowering 集成测试：4/4 通过
- `vk_hw` Python 单测：39/39 通过
- `vk_hw_build_shaders_script_tests`、`vk_hw_case_parsing_tests`、`vk_hw_reference_tests`：3/3 通过
- `vk_hw_build_shaders`：通过
  - 覆盖 70 个 HW shader、69 个 baseline 和 1 个 unsupported HW shader
  - 执行 extension-free lowering
  - 执行 `spirv-val` 校验
  - 扫描所有 `*HW` opcode、HW/AZD capability/extension 和 `Relreg` residue
  - 验证 cooperative-only 保留 TensorMap，而 extension-free 明确失败
  - 执行 lowered GLSL golden 对比：139/139 匹配
- 顶层 CTest：8/8 通过
- 完整 `vk_hw_function`：70/70 通过，无 skip
- 7 个 MLP 功能用例全部 verify 通过；新增四层用例误差为 0，五层 2-2-1 用例 `max_abs_error=0.000244`、`max_rel_error=0.000576`，五层 2-1-2 用例 `max_abs_error=0.001953`、`max_rel_error=0.004315`
- `warmup=20`、`repeat=200` 的完整 `vk_hw_perf`：69/69 完成且 lowered/baseline verify 均通过，无 skip
  - 四层 `mlp_f16_8x48_48x8_8x48_48x4`：ratio 0.6195；lowered 28131.6 ns，baseline 45411.0 ns
  - 五层 2-2-1 `mlp_f16_8x48_48x8_8x48_48x8_8x4`：ratio 0.6636；lowered 32532.8 ns，baseline 49027.0 ns
  - 五层 2-1-2 `mlp_f16_8x48_48x8_8x8_8x8_8x4`：ratio 0.6533；lowered 22021.0 ns，baseline 33706.0 ns；(L1,L2) 和 (L4,L5) 融合，L3 因中间 N=48 与 P=8 组合超过 `kMaxCompositeConstituents=256` 而保留为普通 lowering
  - 除以下 3 个既有超限项外，其余 66 个用例 ratio 均不超过 2
  - `vecmatmuladd_f16_convert_32x16`：ratio 10.3367；f16/f32 往返转换物化并复制大型 aggregate，产生 4 KiB scratch 和大量 scratch load/store
  - `load_store_f32_scalar_5x7`：ratio 6.1417；scalar aggregate 的 4 个动态循环和 private-array 动态索引被后端展开为大量分支/选择，baseline 则完全展开并向量化
  - `matmul_f16_32x32x32`：ratio 3.8398；三层动态循环阻止后端展开和跨 output tile 复用 A/B，不是寄存器 spill

两个仓库工作树均保留本次未提交修改。

因此最准确的能力描述是：

> 当前 pass 已具备本文定义的 cooperative matrix/vector lower 完整能力；对整个 HW neural shader extension，则通过 extension-free 模式实现“能等价 lower 的全部消除，不能等价 lower 的明确失败”，而不是宣称所有 HW opcode 都已经支持。
