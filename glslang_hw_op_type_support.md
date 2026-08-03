# glslang HW 类型与操作支持说明

## 1. 范围与判读原则

本文只记录当前 glslang 对 `GL_HW_neural_shader` 的源语言接收、语义检查和 SPIR-V 发射行为，覆盖：

- `coopmatHW`、`coopvecHW`、`tensorMap*` 类型；
- HW builtin、shape 和数据类型约束；
- GLSL AST 到 SPIR-V 指令的映射；
- glslang 前端会明确报错的组合；
- `precise` / `NoContraction` 在 HW 聚合类型上的当前状态。

本文不推导后续变换 pass 或运行时能否处理这些 SPIR-V。表中的“支持”表示相应行为已有 HW 专项 file test 覆盖，且 glslang 能通过前端检查并按所列方式发射。仅被通用 operator 路径意外接收、但不能形成有效 SPIR-V 的情况会单独列为“缺失拒绝”，不算作支持。

需要区分两类操作：

1. **HW 专用操作**：例如 `coopVecMatMulHW`，发射为 `OpCooperativeVectorMatrixMulHW`。
2. **以 HW 类型为操作数的普通操作**：例如 `coopvecHW<float, N>` 的 `a + b`，仍发射为 core `OpFAdd`；`fma/min/max/...` 发射为 `GLSL.std.450` 的 `OpExtInst`。操作数或结果是 HW 聚合类型，并不会把这些操作变成 HW 专用 opcode。

## 2. 扩展和类型

以下类型都要求启用：

```glsl
#extension GL_HW_neural_shader : enable
```

| GLSL 类型 | 参数 | glslang 接受的分量类型 | SPIR-V 类型 |
| --- | --- | --- | --- |
| `coopmatHW<T, Rows, Columns>` | 两个正整数维度 | `float16_t`、`float`/`float32_t`、`int8_t`、`int16_t`、`int`/`int32_t`、`uint8_t`、`uint16_t`、`uint`/`uint32_t` | `OpTypeCooperativeMatrixHW Component Rows Columns Use` |
| `coopvecHW<T, N>` | 一个正整数分量数 | 同上 | `OpTypeCooperativeVectorHW Component N` |
| `tensorMap1D` ... `tensorMap4D` | 维数由类型名确定 | 不适用 | `OpTypeTensorMapHW Dim` |

`float16_t`、8/16 位整数等显式算术类型仍需满足它们各自的 GLSL 扩展要求。发射时 glslang 会按实际分量类型补充 `Float16`、`Int8` 等能力；HW 类型本身会引入 `SPV_HW_neural_shader`，矩阵和向量分别引入 `CooperativeMatrixHW`、`CooperativeVectorHW` 能力。

### 2.1 类型参数和 shape

- 矩阵源语法总计三个类型参数：分量类型、行数、列数；向量总计两个：分量类型、分量数。
- shape 参数可以来自常量表达式或 specialization constant 表达式。SPIR-V 类型中的 `Rows`、`Columns`、`N` 是 ID 操作数，不要求在文本中展开为字面量。
- glslang 明确拒绝参数缺失、参数数量错误、非法分量类型以及非正维度。
- `bool`、`double`/`float64_t`、`int64_t`、`uint64_t` 不能作为 `coopmatHW` 或 `coopvecHW` 的分量类型。

### 2.2 `coopmatHW` 的 `Use` 推导

GLSL 的 `coopmatHW<T, Rows, Columns>` 没有显式 `Use` 参数。SPIR-V grammar 将 `OpTypeCooperativeMatrixHW` 的 `Use` 定义为可选操作数；当前 glslang 会在发射前按数据流和直接操作数位置推导 use，并显式写出 `MatrixUseAHW`、`MatrixUseBHW` 或 `MatrixAccumulatorHW`：

- `coopMatMulHW` / `coopMatMulAddHW` 的 `A` 为 `MatrixUseAHW`，`B` 为 `MatrixUseBHW`；result 和 `C` 为 `MatrixAccumulatorHW`。
- `coopVecMatMulHW` / `coopVecMatMulAddHW` 的 matrix 为 `MatrixUseBHW`。
- reduce、构造、数值转换、bitcast、赋值和返回值会传播兼容的 use；没有约束的矩阵默认选择 `MatrixUseAHW`。
- 需要跨 use 表示同一 component/shape 时，发射器可以插入 `OpBitcast`。
- 同一个可追踪的逻辑值不能直接既作为 Operand A/B 又作为 accumulator；前端会报告 `same HW cooperative matrix logical value cannot be used directly as both OperandAB and Accumulator`。

## 3. HW cooperative matrix

### 3.1 Builtin 和发射映射

| GLSL builtin / 语法 | 关键参数 | SPIR-V 发射 |
| --- | --- | --- |
| `coopMatLoadHW(out m, buf, shape, offset, layout)` | `shape`、`offset` 为 `ivec2`，`layout` 为 `int` | `OpCooperativeMatrixLoadHW`，随后把结果写入 `out` 对象 |
| `coopMatStoreHW(m, buf, shape, offset, layout)` | 同上 | `OpCooperativeMatrixStoreHW` |
| `coopMatMulHW(out result, A, B)` | `A[M,K] * B[K,N] -> result[M,N]` | `OpCooperativeMatrixMulAddHW`，`C` 操作为 result 类型的 null constant |
| `coopMatMulAddHW(out result, A, B, C)` | `A[M,K] * B[K,N] + C[M,N]` | `OpCooperativeMatrixMulAddHW` |
| `coopMatReduceHW(matrix, reduceMask, combineOp)` | 两个控制参数都是编译期常量 | `OpCooperativeMatrixReduceHW` |
| `m.length()` | 返回 GLSL `int` | `OpCooperativeMatrixLengthHW`，再按 GLSL 结果类型处理 signedness |

矩阵布局常量为：

```text
gl_CooperativeMatrixLayoutRowMajorHW    = 0
gl_CooperativeMatrixLayoutColumnMajorHW = 1
```

reduce 控制常量为：

```text
gl_CooperativeMatrixReduceRowHW    = 0
gl_CooperativeMatrixReduceColumnHW = 1

gl_CooperativeMatrixReduceAddHW = 0
gl_CooperativeMatrixReduceMinHW = 1
gl_CooperativeMatrixReduceMaxHW = 2
```

`reduceMask` 必须为 `[0, 1]`，`combineOp` 必须为 `[0, 2]`；二者都必须是编译期常量。reduce 的结果继承输入矩阵的完整类型和 use。

### 3.2 Matmul 数据类型规则

矩阵和向量 matmul 共用以下数值规则：

- 浮点域只包含 16/32 位浮点；整数域包含 8/16/32 位有符号或无符号整数。
- `A`、`B` 和 accumulator/result 必须全部属于浮点域，或全部属于整数域。
- 整数域内允许有符号和无符号类型组合；前端检查的是数值域和位宽，而不是要求三者完全同型。
- accumulator/result 的位宽不能窄于 `A` 或 `B`。
- `coopMatMulAddHW` 额外要求 `C` 与 result 的分量类型完全相同。

矩阵 shape 必须满足：

```text
A.Rows == result.Rows
B.Columns == result.Columns
A.Columns == B.Rows
```

对 mul-add，还要求：

```text
C.Rows == result.Rows == A.Rows
C.Columns == result.Columns == B.Columns
```

上述任一条件不满足都会在 glslang 前端报错，不会等到 SPIR-V 发射后再诊断。

### 3.3 Load/store 的内存元素类型

`coopMatLoadHW` / `coopMatStoreHW` 的 buffer 元素 overload 与 cooperative matrix 的分量类型是两个不同概念。前端声明的 buffer 元素包括：

- 16/32/64 位浮点标量及其 `vec2`、`vec4`；
- 8/16/32/64 位有符号、无符号整数标量及其 `vec2`、`vec4`；
- 不提供 `vec3` buffer 元素 overload。

因此 64 位类型可以作为 load/store 的内存元素类型，但不能据此推断 64 位类型可以作为 `coopmatHW` 的分量类型。

### 3.4 普通矩阵表达式

对完整类型相同的两个 `coopmatHW`，当前 HW 专项 file test 覆盖并保证的集合是：

- 一元 `-`；
- `+`、`-`、`*`、`/` 及对应复合赋值。

这些表达式不是 cooperative matmul。它们分别发射为 `OpFAdd`、`OpFMul`、`OpIAdd`、`OpIMul`、`OpSDiv`、`OpUDiv` 等普通 SPIR-V core 指令，结果类型恰好是 `OpTypeCooperativeMatrixHW`。

一元 `+` 也会被接受，并作为 no-op 处理。

源码还显式接受 `matrix * scalar`、`scalar * matrix` 和适用的 `*=`，其中 scalar 的 basic type 必须与矩阵分量一致，并走普通 matrix-times-scalar 发射路径；当前尚无 `coopmatHW` 专项 positive file test 覆盖这一组合，因此这里记录为“已接收但待补测试”，不并入上面的受保证集合。

前端明确拒绝：

- 不同 component type 或不同 shape 的两个 HW 矩阵直接运算；
- HW 矩阵与 NV/KHR cooperative matrix 混用；
- 除乘法外的 matrix-scalar 算术，例如 `m + scalar`、`m - scalar`、`m / scalar`；
- 依赖隐式类型转换来凑齐上述操作数。

当前另有一组**前端缺失拒绝**，不能视为支持：通用 operator promotion 会漏接收整数矩阵的 `%`/`%=`、`~`、`&`/`|`/`^` 及复合赋值、矩阵的 `==`/`!=`、数值关系运算和前后置 `++`/`--`。这些组合没有 HW 专项 file test，当前发射结果也不是有效 SPIR-V。TODO 是在 glslang 前端显式拒绝它们，或先定义并实现可验证的语义与发射方式。

## 4. HW cooperative vector

### 4.1 Builtin 和发射映射

| GLSL builtin / 语法 | shape 规则 | SPIR-V 发射 |
| --- | --- | --- |
| `coopVecLoadHW(out v, buf, uint offset)` | result 类型由 `out v` 决定 | `OpCooperativeVectorLoadHW`，随后写入 `out` 对象 |
| `coopVecStoreHW(v, buf, uint offset)` | `offset` 必须匹配 `uint` overload | `OpCooperativeVectorStoreHW` |
| `coopVecMatMulHW(out result, input, matrix)` | `input.N == matrix.Rows`，`result.N == matrix.Columns` | `OpCooperativeVectorMatrixMulHW` |
| `coopVecMatMulAddHW(out result, input, matrix, bias)` | 上述规则加 `bias.N == result.N` | `OpCooperativeVectorMatrixMulAddHW` |
| `v.length()` | 类型参数中的 `N` | 直接取得 `OpTypeCooperativeVectorHW` 的 component-count ID；没有单独的 HW length 指令 |
| `v[index]` | 常量 index 会做 `[0, N)` 边界检查 | 走普通 access-chain/composite 发射路径，不使用 HW 专用 opcode |

matmul-add 还要求 bias 与 result 的分量类型完全相同。input、matrix 和 result 的数值域/位宽规则与 3.2 节相同。

### 4.2 Load/store 的内存元素类型

`coopVecLoadHW` / `coopVecStoreHW` 提供如下 buffer 元素 overload：

- 16/32/64 位浮点和 8/16/32/64 位有符号、无符号整数标量；
- 上述标量的 2、3、4 分量向量。

同样，64 位 buffer 元素 overload 不改变 `coopvecHW` 分量类型只能为 8/16/32 位整数或 16/32 位浮点这一规则。

### 4.3 普通向量表达式和标准 builtin

对完整类型相同的两个 `coopvecHW`，当前 HW 专项 file test 覆盖并保证的集合是：

- 浮点/整数 `+`、`-`、`*`、`/` 及对应复合赋值；
- 一元 `-`；
- 整数 `~`、`&`、`|`、`^`、`<<`、`>>` 及对应复合赋值；
- vector-scalar 乘法，scalar basic type 必须与 vector 分量一致。

这些操作发射为普通 `OpF*`、`OpI*`、`OpBitwise*` 和 `OpShift*` 指令，不是 `OpCooperativeVectorMatrix*HW`。

一元 `+` 也会被接受，并作为 no-op 处理。

前端还为 `coopvecHW` 提供 `fma`、`min`、`max`、`step`、`exp`、`log`、`tanh`、`atan`、`clamp` overload。它们遵循各自的浮点/整数 builtin 类型约束，并发射为 `GLSL.std.450` 的 `OpExtInst`，不是 HW 专用 opcode。

前端明确拒绝不同分量类型、不同 `N`、HW/NV cooperative vector 混用，以及通过隐式转换拼接二元操作数。

与矩阵相似，当前通用路径会漏接收整数向量的 `%`/`%=`、向量的 `==`/`!=` 以及前后置 `++`/`--`；这些是**前端缺失拒绝**，没有 HW 专项 file test，当前发射结果也不是有效 SPIR-V，不属于受支持集合。TODO 是补齐前端拒绝，或在定义合法语义和发射后再提升为支持。

## 5. 构造、数值转换和 bitcast

### 5.1 显式构造和转换

- `coopmatHW` 构造器只接受一个参数；参数必须是 scalar 或另一个 `coopmatHW`。矩阵输入必须保持相同 shape。
- `coopvecHW` 构造器可以由 scalar、普通 vector 或 cooperative vector 的分量组成，并按目标 `N` 检查提供的分量数量。
- HW 与 NV/KHR cooperative 类型之间不能构造或赋值。
- cooperative HW 类型不参与普通二元表达式的隐式数值转换；改变 component type 必须使用显式构造器。

显式数值转换使用普通 SPIR-V conversion opcode，例如 `OpFConvert`、`OpSConvert`、`OpUConvert`、`OpConvertFToS`、`OpConvertSToF`，而不是 HW 专用 conversion opcode。

### 5.2 Bitcast builtin

`coopmatHW` 和 `coopvecHW` 都提供以下配对，并保持原 shape：

- `float`/`float16_t` -> `int`/`int16_t`：`floatBitsToInt`、`float16BitsToInt16`；
- `float`/`float16_t` -> `uint`/`uint16_t`：`floatBitsToUint`、`float16BitsToUint16`，以及 half 命名别名；
- 对应的 `int`/`uint` -> `float` 和 16 位反向形式。

源分量类型不属于 builtin 要求的集合时前端会报错。合法调用发射普通 `OpBitcast`。

## 6. Tensor map、异步拷贝、barrier 和 shuffle

| GLSL | 前端约束 | SPIR-V 发射 |
| --- | --- | --- |
| `tensorMap1D` ... `tensorMap4D` | opaque tensor-map 类型 | `OpTypeTensorMapHW Dim` |
| `cp_async_tensor_global_shared(dst, map, coord)` | `dst` 必须是 shared storage 的一维 `int[]` lvalue；coord 维数必须与 map 维数一致 | `OpCpAsyncTensorGlobalSharedHW Dim Dst Map Coord` |
| `cp_async_commit_group()` | 无参数 | `OpCpAsyncCommitGroupHW` |
| `cp_async_wait_group(int n)` | `n` 必须是非负编译期常量 | `OpCpAsyncWaitGroupHW` |
| `barrier_arrive(int id, int n)` | 常量 `id` 不能为负；`n` 必须是非负编译期常量 | `OpBarrierArriveHW` |
| `barrier_wait(int id, int n)` | 同上 | `OpBarrierWaitHW` |
| `shufidx(int32_t value, int32_t idx)` | 若 `idx` 可在编译期求值，则必须在 `[0, 31]`；动态 `idx` 不因非常量本身被拒绝 | `OpShuffleIndexHW` |
| `bytePrmt(uint32_t src0, uint32_t src1, uint32_t mask)` | 参数必须匹配声明类型 | `OpBytePermuteHW` |
| `shuffle_fill_down(uint32_t src, uint32_t fill, int32_t shift)` | 参数必须匹配声明类型 | `OpShuffleFillDownHW` |

注意 barrier 的 `id` 不要求必须是编译期常量；当前前端只在能够取到常量值时检查其非负性。

## 7. `reg_control`

`[[reg_control]]`：

- 属性语法要求 `GL_EXT_control_flow_attributes`，`reg_control` 语义另要求 `GL_HW_neural_shader`，并且属性自身不接受参数；
- 只适用于 `if`/条件选择；
- 可与 `flatten` 或 `branch` 组合；
- 用于 switch、loop 或 function 时前端明确报错。

SPIR-V 发射时，该属性成为 `OpSelectionMerge` 的 `Relreg` selection-control bit（内部枚举为 `SelectionControlRelregMask`），并引入 `SPV_HW_neural_shader`。

## 8. glslang 前端明确拒绝汇总

下表只汇总 glslang 的源语言和 AST/SPIR-V 发射检查，不描述任何后续变换 pass 的能力或拒绝条件。

| 类别 | glslang 明确拒绝的情况 |
| --- | --- |
| HW 类型参数 | `coopmatHW`/`coopvecHW` 参数缺失、数量错误、非正 shape，或 component 为 `bool`、64 位浮点、64 位整数及其他非 2.1 节集合中的类型 |
| Storage 与 interface block | `shared coopmatHW`；把 `coopmatHW`/`coopvecHW` 直接作为 block member，或让 block member 的嵌套类型包含它们 |
| Cooperative 类型混用 | HW cooperative matrix/vector 与 NV/KHR cooperative 类型之间的构造、赋值或运算 |
| 普通表达式 | component/shape 不同的两个 HW 聚合值参与二元操作；依赖隐式转换凑齐 HW 二元操作数；除乘法外的 HW matrix-scalar 算术；浮点 `%`/位运算/移位；vector 关系运算；matrix 移位；所有逻辑运算。3.4、4.3 节另列出当前仍需补齐拒绝的通用 operator 漏网项 |
| Matrix use | 同一个可追踪逻辑矩阵值直接同时充当 Operand A/B 与 accumulator |
| Matrix matmul | 数值域不一致、component 位宽不在允许集合、accumulator/result 窄于输入、`A.Rows`/`A.Columns`/`B.Rows`/`B.Columns` 与 result shape 不匹配，或 mul-add 的 `C` component/shape 与 result 不一致 |
| Vector matmul | 数值域或位宽规则不满足、`input.N != matrix.Rows`、`result.N != matrix.Columns`，或 mul-add 的 bias component/`N` 与 result 不一致 |
| Matrix reduce | `reduceMask`/`combineOp` 不是编译期常量，或分别超出 `[0, 1]`/`[0, 2]` |
| Load/store overload | buffer 元素类型或其他实参不匹配 3.3、4.2 节列出的 builtin overload；matrix load/store 的 shape/offset/layout 参数类型错误 |
| Tensor async | `dst` 不是 shared storage 的一维 `int[]` lvalue，或 tensor-map 维数与 coord 类型/维数不一致 |
| Wait/barrier | wait-group 的 `n` 不是非负编译期常量；barrier 的 `n` 不是非负编译期常量；能够求值为常量的 barrier `id` 为负数 |
| Shuffle | 能在编译期求值的 `shufidx` index 不在 `[0, 31]`，或 shuffle/byte-permute 参数类型不匹配 builtin 声明 |
| `reg_control` | 扩展未启用、属性带参数，或属性用于 switch、loop、function 等非条件选择节点 |

## 9. `precise` / `NoContraction` 当前状态

### 9.1 已覆盖：HW 类型上的普通 core arithmetic

当前 `PropagateNoContraction` 能沿普通赋值表达式识别 `EOpAdd`、`EOpSub`、`EOpMul`、`EOpDiv`、一元负号等 core arithmetic 节点。因此下面这种表达式会把 `NoContraction` 加到实际 core 算术结果上：

```glsl
precise coopvecHW<float, 4> result;
result = a + b;
```

对应的 `OpFAdd` result ID 会带 `NoContraction`。这说明“结果类型是 HW 类型”本身不会阻断 `precise`；关键在于 AST 节点仍是当前传播器认识的普通 arithmetic operation。

### 9.2 未覆盖：HW aggregate/out-parameter arithmetic builtin

下面的情况当前不会把 `NoContraction` 传播到 `OpCooperativeVectorMatrixMulHW`：

```glsl
precise coopvecHW<float, 4> result;
coopVecMatMulHW(result, input, matrix);
```

原因是三个实现环节没有接上：

1. definition collector 只把 unary/binary assignment 记录为对象定义；aggregate builtin 调用虽然会递归访问参数，但不会把 `out` 实参映射为由该调用定义。
2. arithmetic whitelist 只列举普通 `EOpAdd`、`EOpMul` 等节点，没有 `EOpCooperativeMatrixMulHW`、`EOpCooperativeMatrixMulAddHW`、`EOpCooperativeVectorMatMulHW`、`EOpCooperativeVectorMatMulAddHW`。aggregate visitor 本身也不标记调用节点。
3. HW matmul 发射 helper 创建 `OpCooperative*Mul*HW` result 后直接 `OpStore` 到 `out` 指针，没有从调用节点取得并施加 `NoContraction` decoration。

同一结构性缺口也要求审视其他以 aggregate 节点返回 HW 算术值的 builtin；不能仅因目标变量声明了 `precise` 就假定其 SPIR-V result 已被装饰。load/store、barrier 等非算术操作不应被纳入 `NoContraction`。

### 9.3 TODO

- 让 definition collector 将 HW arithmetic builtin 的 `out`/`inout` 实参映射到对应 aggregate call，且不把只读参数误认为定义。
- 给 `TNoContractionPropagator` 增加明确的 HW arithmetic aggregate 分类；只覆盖有 `NoContraction` 语义的运算，不泛化到所有 HW builtin。
- 为每类 HW arithmetic builtin 明确 `precise` 的 SPIR-V contract。只有在对应 result opcode 合法接受 `NoContraction` 时才可装饰真正产生数值的 result ID；当前禁止 `NoContraction` 的 HW vector-matmul 不能直接发射该 decoration，必须先解决规则冲突或选择其他合法表示。任何方案都不能装饰 `OpStore`、out pointer 或仅用于搬运的临时值。
- 分别评估 return-value aggregate arithmetic（例如 cooperative-vector `fma` overload、matrix reduce）的语义和合法 decoration 位置。
- 添加 policy 对应的 positive/negative file tests：当前至少要锁定 HW vector-matmul 不产生非法 `NoContraction`；未来若某类 HW opcode 获得合法传播规则，再为该类增加 `precise` positive test。普通 core arithmetic on HW types 的现有行为必须保持。

在这些 TODO 完成并有测试覆盖前，不应声称 `precise` 已覆盖 HW matrix/vector matmul builtin。

## 10. 主要实现与测试入口

实现入口：

- 类型语法和扩展检查：`glslang/MachineIndependent/glslang.y`、`Versions.cpp`
- 类型参数、builtin shape/类型、常量范围和 storage 检查：`glslang/MachineIndependent/ParseHelper.cpp`
- builtin 声明与 AST operator 关联：`glslang/MachineIndependent/Initialize.cpp`
- 普通算术和隐式转换约束：`glslang/MachineIndependent/Intermediate.cpp`
- `reg_control`：`glslang/MachineIndependent/attribute.cpp`
- `precise` 传播：`glslang/MachineIndependent/propagateNoContraction.cpp`
- SPIR-V 类型、use 推导和操作发射：`SPIRV/GlslangToSpv.cpp`、`SPIRV/SpvBuilder.cpp`

代表性 file tests：

- 类型与 builtin：`Test/spv.coopmatHW*.{comp,vert,frag}`、`Test/spv.coopvecHW*.{comp,vert,frag}`
- matmul 类型/shape 错误：`Test/spv.coopmatHW_matmul*Error.comp`、`Test/spv.coopvecHWMatMul*_Error.*`
- use 推导：`Test/spv.coopmatHW_role*.comp`、`Test/spv.coopmatHW_use_pass*.comp`
- tensor/cp/barrier：`Test/spv.cpAsyncTensor*.comp`、`Test/spv.cpAsyncGroupBarrier*.comp`
- shuffle：`Test/spv.hwNeuralBuiltins*.comp`
- `reg_control`：`Test/spv.regControl*.comp`
