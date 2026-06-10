# glslang 内部 Cooperative Matrix Use 推断方案

## 1. 目标

本文档描述一种 **不依赖 spirv-tools** 的方案，在 glslang 内部完成 Cooperative Matrix 的 `use` 推断、类型修正、必要 bitcast 插入，并最终直接 emit 正确的 `OpTypeCooperativeMatrixAZD/HW`。

目标流程：

```text
GLSL parser
  -> AST 类型推断 / 修正
  -> intermediate 保持 use 信息
  -> SPIR-V emit 直接生成带 use 的 OpTypeCooperativeMatrixAZD/HW
```

不再需要：

```text
glslang emit 无 use 类型
  -> spirv-opt --azd-fix-cooperative-matrix-use
  -> 修正 SPIR-V
```

---

## 2. 总体思路

核心思想是：**把 Cooperative Matrix 的 `use` 作为 glslang 类型系统的一部分**。

例如原始 GLSL 类型：

```glsl
coopmatHW<uint8_t, 16, 32>
```

在 glslang 内部可以被推断成：

```text
coopmatHW<uint8_t, 16, 32, MatrixUseA>
coopmatHW<uint8_t, 16, 32, MatrixUseB>
coopmatHW<uint32_t, 16, 16, MatrixAccumulator>
```

内部可以定义：

```cpp
enum TCoopMatUse {
    ECoopMatUseUnknown,
    ECoopMatUseA,
    ECoopMatUseB,
    ECoopMatUseAccumulator,
};
```

`TType` 中携带：

```cpp
TCoopMatUse coopMatUse;
```

最终 SPIR-V emit 阶段直接生成：

```spirv
%type_a = OpTypeCooperativeMatrixHW %uint8  %int_16 %int_32 MatrixUseAHW
%type_b = OpTypeCooperativeMatrixHW %uint8  %int_32 %int_16 MatrixUseBHW
%type_c = OpTypeCooperativeMatrixHW %uint32 %int_16 %int_16 MatrixAccumulatorHW
```

---

## 3. 阶段划分

整体可以分成五层：

```text
1. 类型系统扩展
   TType / TPublicType / type compare / mangling / clone

2. Parser / semantic check
   识别 coopmatAZD / coopmatHW
   初始 use = Unknown
   可选支持显式 use

3. AST use 推断
   从 coopMatMulAddHW / binary op / assign / load / store 反推 use
   检测 A/B/Accumulator 冲突

4. AST 类型修正 + bitcast 插入
   函数参数 / 返回值 / select / phi / accesschain / load 边界插入 role cast

5. SPIR-V emit
   类型池区分 use
   emit OpTypeCooperativeMatrixAZD/HW 带 use operand
   emit OpBitcast / role-convert helper
```

推荐 pipeline：

```text
Parse AST
  ↓
Built-in semantic check
  ↓
CollectCoopMatUseConstraints
  ↓
ResolveCoopMatUse
  ↓
RewriteCoopMatTypes
  ↓
InsertCoopMatRoleCasts
  ↓
Final type validation
  ↓
SPIR-V emit
```

---

## 4. 类型系统改造

### 4.1 增加 TCoopMatUse

建议在：

```text
glslang/Include/Types.h
```

增加：

```cpp
enum TCoopMatUse {
    ECoopMatUseUnknown,
    ECoopMatUseA,
    ECoopMatUseB,
    ECoopMatUseAccumulator,
};
```

在 `TType` 中增加：

```cpp
TCoopMatUse coopMatUse = ECoopMatUseUnknown;
```

并提供接口：

```cpp
bool hasCoopMatUse() const;
TCoopMatUse getCoopMatUse() const;
void setCoopMatUse(TCoopMatUse use);
bool isCoopMatUseUnknown() const;
```

如果已有：

```cpp
bool isCoopMat();
bool isCoopMatHW();
bool isCoopMatAZD();
```

建议再增加：

```cpp
bool isCoopMatLike() const;
```

用于统一判断 AZD/HW cooperative matrix。

---

### 4.2 类型相等规则

完整类型应包含：

```text
element type
rows
cols
scope / layout
coopmat kind: AZD / HW
use
```

因此：

```text
coopmatHW<uint8_t,16,32,UseA>
```

和：

```text
coopmatHW<uint8_t,16,32,UseB>
```

是不同类型。

建议提供两个比较接口：

```cpp
bool sameTypeStrict(const TType& a, const TType& b);
bool sameTypeIgnoringCoopMatUse(const TType& a, const TType& b);
```

用途：

```text
sameTypeStrict:
  - SPIR-V type cache key
  - function mangling
  - variable final type

sameTypeIgnoringCoopMatUse:
  - 推断阶段判断 shape 是否兼容
  - 判断是否可以插 bitcast
```

---

### 4.3 函数 mangling 包含 use

函数签名中的 cooperative matrix 类型需要把 `use` 纳入 mangling。

否则下面两个内部函数签名会冲突：

```glsl
void foo(coopmatHW<uint8_t,16,32,UseA> x);
void foo(coopmatHW<uint8_t,16,32,UseB> x);
```

即使用户源码层面仍然是旧语法，glslang 内部的 resolved signature 也应该区分 `UseA`、`UseB`、`Accumulator`。

---

## 5. Parser 层设计

### 5.1 默认 use = Unknown

用户源码：

```glsl
coopmatHW<uint8_t, 16, 32> A;
coopmatHW<uint8_t, 32, 16> B;
coopmatHW<uint32_t, 16, 16> C;
```

parser 构造类型时：

```cpp
type.setCoopMatUse(ECoopMatUseUnknown);
```

也就是说 parser 阶段不急着决定 A/B/Accumulator。

---

### 5.2 可选支持显式 use

后续可以扩展语法支持：

```glsl
coopmatHW<uint8_t, 16, 32, MatrixUseA> A;
coopmatHW<uint8_t, 32, 16, MatrixUseB> B;
coopmatHW<uint32_t, 16, 16, MatrixAccumulator> C;
```

但第一阶段建议先保持源码语法不变：

```text
源码仍然是旧语法
内部 AST 推断 use
SPIR-V emit 带 use
```

这样改动面更小。

---

## 6. AST Use 推断规则

### 6.1 核心约束

对于：

```glsl
D = coopMatMulAddHW(A, B, C);
```

语义是：

```text
D = A * B + C
```

推断规则：

```text
A -> UseA
B -> UseB
C -> Accumulator
D -> Accumulator
```

对应约束：

```cpp
requireUse(A, ECoopMatUseA);
requireUse(B, ECoopMatUseB);
requireUse(C, ECoopMatUseAccumulator);
requireUse(D, ECoopMatUseAccumulator);
```

---

### 6.2 Binary Op 规则

建议把规则集中到统一函数中：

```cpp
bool inferCoopMatUseForBinary(
    TIntermBinary& node,
    TIntermTyped* left,
    TIntermTyped* right,
    TOperator op);
```

#### Matrix multiply

如果是 cooperative matrix 矩阵乘：

```text
left  -> UseA
right -> UseB
result -> Accumulator
```

#### Matrix scalar multiply

如果是：

```glsl
coopmat * scalar
scalar * coopmat
```

则：

```text
result use = coopmat operand use
```

#### Add / Sub

如果硬件语义只允许 accumulator 做加减，建议收紧成：

```text
+ / - 只允许 Accumulator
```

即：

```cpp
requireUse(left, ECoopMatUseAccumulator);
requireUse(right, ECoopMatUseAccumulator);
result = ECoopMatUseAccumulator;
```

如果需要更宽松规则，可以使用：

```text
Accumulator + Accumulator -> Accumulator
A + A -> A
B + B -> B
Unknown + A -> A
Unknown + B -> B
Unknown + Accumulator -> Accumulator
A + B -> error
A + Accumulator -> error
B + Accumulator -> error
```

#### Assignment

赋值规则：

```text
same shape + same scalar + same use:
  direct assign

same shape + same scalar + different use:
  显式 cast 边界允许 bitcast
  普通隐式赋值默认 error 或按策略插 bitcast
```

建议第一阶段保守：

```text
普通赋值要求 use 一致
显式构造 / 显式 cast 允许转换 use
函数边界可以插 bitcast
```

---

## 7. Role Constraint Solver

不要在解析每个节点时立即最终改类型，建议做三步：

```text
Pass 1: 收集约束
Pass 2: 解约束并修正类型
Pass 3: 插入 bitcast
```

### 7.1 约束数据结构

```cpp
struct CoopMatRoleVar {
    TIntermTyped* node;
    TSymbol* symbol;
    TType baseTypeWithoutUse;
    TCoopMatUse inferredUse;
    SourceLoc loc;
};
```

约束类型：

```cpp
enum RoleConstraintKind {
    RequireA,
    RequireB,
    RequireAccumulator,
    SameUse,
    AllowABByUseCount,
    ExplicitCastBoundary,
};
```

示例：

```cpp
addConstraint(A, RequireA);
addConstraint(B, RequireB);
addConstraint(C, RequireAccumulator);
addConstraint(D, RequireAccumulator);
```

---

### 7.2 冲突规则

基础规则：

```text
Unknown + A -> A
Unknown + B -> B
Unknown + Accumulator -> Accumulator

A + A -> A
B + B -> B
Accumulator + Accumulator -> Accumulator
```

冲突规则：

```text
A + B:
  如果允许 A/B 混用，可以按 use count 决策
  否则 error

A/B + Accumulator:
  必须 error，除非存在显式 cast 边界
```

建议统计：

```cpp
struct UseStats {
    int useAsA = 0;
    int useAsB = 0;
    int useAsAccumulator = 0;
};
```

决策逻辑：

```cpp
if (useAsAccumulator > 0 && (useAsA > 0 || useAsB > 0)) {
    error("cooperative matrix cannot be used both as operand and accumulator");
}

if (useAsA > 0 || useAsB > 0) {
    if (useAsA == useAsB)
        error("ambiguous cooperative matrix A/B use");
    inferred = useAsA > useAsB ? ECoopMatUseA : ECoopMatUseB;
}

if (useAsAccumulator > 0) {
    inferred = ECoopMatUseAccumulator;
}
```

---

## 8. AST 类型修正

推断完成后，需要对所有相关 AST 节点修正类型：

```cpp
TType newType = oldType;
newType.setCoopMatUse(inferredUse);
node->setType(newType);
```

需要覆盖：

```text
TIntermSymbol
TIntermBinary
TIntermAggregate
TIntermUnary
TIntermSelection
TIntermTyped temporary
function return node
```

重点是：**不能只改 symbol declaration，还要改所有 expression result type**。

---

## 9. Bitcast 插入策略

建议引入新的 AST op：

```cpp
EOpCoopMatRoleCast
```

语义：

```text
source type: coopmatHW<T, M, N, UseX>
target type: coopmatHW<T, M, N, UseY>

要求：
  - element type 相同
  - rows / cols 相同
  - coopmat kind 相同
  - 只改变 use
```

构造 helper：

```cpp
TIntermTyped* makeCoopMatRoleCast(
    TIntermTyped* operand,
    TCoopMatUse targetUse,
    TIntermediate& intermediate)
{
    TType targetType = operand->getType();
    targetType.setCoopMatUse(targetUse);

    auto* cast = new TIntermUnary(EOpCoopMatRoleCast);
    cast->setOperand(operand);
    cast->setType(targetType);
    return cast;
}
```

SPIR-V emit 时可以生成：

```spirv
%dst = OpBitcast %target_type %src
```

如果 extension/validator 不允许 cooperative matrix `OpBitcast`，可以改成自定义 no-op cast，或者在更高层避免生成实际 cast。

---

## 10. 函数边界处理

### 10.1 函数参数

源码：

```glsl
void foo(coopmatHW<uint8_t,16,32> x) {
    D = coopMatMulAddHW(x, B, C);
}
```

函数体推断：

```text
x -> UseA
```

内部函数签名变成：

```text
void foo(coopmatHW<uint8_t,16,32,UseA> x)
```

调用点：

```glsl
foo(mat);
```

如果 `mat` 是 Unknown：

```text
mat -> UseA
```

如果 `mat` 已经是 UseB：

```text
foo(bitcast<UseA>(mat))
```

推荐策略：

```text
Unknown -> expected role:
  直接修正

A <-> B:
  可插 bitcast

A/B -> Accumulator:
  默认报错，除非显式 cast

Accumulator -> A/B:
  默认报错，除非显式 cast
```

---

### 10.2 函数返回

源码：

```glsl
coopmatHW<uint32_t,16,16> foo() {
    return coopMatMulAddHW(A, B, C);
}
```

推断：

```text
return type -> Accumulator
```

内部签名：

```text
coopmatHW<uint32_t,16,16,Accumulator> foo()
```

调用点：

```glsl
C = foo();
```

`C` 也会被推断为 `Accumulator`。

---

### 10.3 Forward Declaration

对于 forward-declared callee，需要延后解析。

建议流程：

```text
第一次 parser 看到 prototype:
  创建 function symbol
  coopmat 参数 / 返回 use = Unknown

看到 definition:
  根据函数体推断参数和返回 use
  更新 function symbol resolved signature

遇到 call 但 callee 尚未 definition:
  call node 挂 pending constraint
  final resolve pass 再修正 call argument / return type
```

数据结构：

```cpp
struct PendingCoopMatCall {
    TIntermAggregate* callNode;
    TFunction* callee;
    TSourceLoc loc;
};
```

最终处理：

```cpp
for each pending call:
    resolvedSig = callee->getResolvedCoopMatSignature();
    applyArgumentRoleCasts(callNode, resolvedSig);
    set callNode type to resolved return type;
```

---

## 11. Select / Phi / Control Flow

### 11.1 Selection

对于：

```glsl
x = cond ? a : b;
```

建议第一阶段要求：

```text
a.use == b.use == result.use
```

如果一个是 Unknown，可以修正为另一个。

如果不同：

```text
A vs B:
  第一阶段建议报错
  后续可以插 bitcast 到 result role

A/B vs Accumulator:
  默认报错
```

---

### 11.2 If / Loop Merge

例如：

```glsl
coopmatHW<uint8_t,16,32> x;

if (cond)
    x = a;
else
    x = b;
```

变量 `x` 的 final role 必须固定。

两个 assignment RHS 都需要转成 `x` 的 role。

---

## 12. AccessChain / Load / Store

如果有：

```glsl
buffer {
    coopmatHW<uint8_t,16,32> m[];
} buf;

auto x = buf.m[i];
```

第一阶段推荐策略：

```text
所有 storage/member declaration 最终必须 resolved use
unresolved -> default 或 error
```

也就是：

```text
buffer member 如果被使用，根据使用点推断
如果完全没使用，可以 default UseA 或 warning
```

不建议第一阶段保留 unknown storage type，因为最终 SPIR-V type 不能是 unresolved cooperative matrix type。

---

## 13. Built-in / Intrinsic 规则表

建议集中维护 cooperative matrix 内建函数规则，不要散落在 parser 各处。

```cpp
struct CoopMatBuiltinRule {
    const char* name;
    std::vector<TCoopMatUse> paramUses;
    TCoopMatUse returnUse;
};
```

例如：

```cpp
{
    "coopMatMulAddHW",
    {
        ECoopMatUseA,
        ECoopMatUseB,
        ECoopMatUseAccumulator
    },
    ECoopMatUseAccumulator
}
```

对于：

```glsl
D = coopMatMulAddHW(A, B, C);
```

规则：

```text
A -> UseA
B -> UseB
C -> Accumulator
D -> Accumulator
```

---

## 14. SPIR-V Emit 改造

主要涉及：

```text
glslang/SPIRV/GlslangToSpv.cpp
glslang/SPIRV/SpvBuilder.cpp
```

### 14.1 Type cache key 包含 use

SPIR-V type cache key 必须包含：

```text
element type
rows
cols
scope / layout
coopmat kind
use
```

伪代码：

```cpp
CoopMatTypeKey key {
    elemType,
    rows,
    cols,
    scope,
    kind,
    type.getCoopMatUse()
};
```

不能只按：

```text
element type + rows + cols
```

否则 A/B/Accumulator 会错误复用同一个 type id。

---

### 14.2 Emit OpTypeCooperativeMatrixHW

伪代码：

```cpp
spv::Id Builder::makeCooperativeMatrixHWType(
    spv::Id componentType,
    int rows,
    int cols,
    TCoopMatUse use)
{
    spv::Id typeId = getUniqueId();

    std::vector<unsigned> operands;
    operands.push_back(componentType);
    operands.push_back(makeUintConstant(rows));
    operands.push_back(makeUintConstant(cols));
    operands.push_back(mapUseToHWOperand(use));

    addInstruction(spv::OpTypeCooperativeMatrixHW, typeId, operands);
    return typeId;
}
```

HW use 映射：

```cpp
unsigned mapUseToHWOperand(TCoopMatUse use)
{
    switch (use) {
    case ECoopMatUseA:
        return MatrixUseAHW;
    case ECoopMatUseB:
        return MatrixUseBHW;
    case ECoopMatUseAccumulator:
        return MatrixAccumulatorHW;
    default:
        error("unresolved cooperative matrix use");
    }
}
```

AZD use 映射：

```cpp
unsigned mapUseToAZDOperand(TCoopMatUse use)
{
    switch (use) {
    case ECoopMatUseA:
        return MatrixUseA;
    case ECoopMatUseB:
        return MatrixUseB;
    case ECoopMatUseAccumulator:
        return MatrixAccumulator;
    default:
        error("unresolved cooperative matrix use");
    }
}
```

---

### 14.3 Emit Role Cast

对 AST op：

```cpp
EOpCoopMatRoleCast
```

emit：

```spirv
%dst = OpBitcast %target_type %src
```

限制：

```text
source / target element type 相同
rows / cols 相同
kind 相同
只 use 不同
```

---

## 15. 错误诊断

### 15.1 Operand 与 Accumulator 冲突

源码：

```glsl
x = coopMatMulAddHW(x, B, C);
```

如果同一个 `x` 同时作为 A 和 D：

```text
x -> UseA
x -> Accumulator
```

报错：

```text
cooperative matrix variable 'x' is used both as operand matrix and accumulator matrix
```

---

### 15.2 A/B 冲突

源码：

```glsl
coopMatMulAddHW(x, x, C);
```

同一个 `x` 同时作为 A 和 B。

推荐策略：

```text
如果 useAsA == useAsB:
  error: ambiguous cooperative matrix A/B use

如果 useAsA > useAsB:
  symbol use = A
  B 使用点插 bitcast 或报错

如果 useAsB > useAsA:
  symbol use = B
  A 使用点插 bitcast 或报错
```

第一阶段建议 tie 时直接报错。

---

## 16. 建议新增 Pass

可以增加一个专门的 resolver：

```text
glslang/MachineIndependent/CoopMatUseResolver.cpp
```

入口：

```cpp
bool TIntermediate::resolveCoopMatUses()
{
    CoopMatUseCollector collector(*this);
    root->traverse(&collector);

    CoopMatUseSolver solver(collector.constraints);
    if (!solver.solve())
        return false;

    CoopMatTypeRewriter rewriter(solver.results);
    root->traverse(&rewriter);

    CoopMatCastInserter castInserter(solver.results);
    root = castInserter.rewrite(root);

    CoopMatFinalValidator validator;
    root->traverse(&validator);

    return !validator.hasError();
}
```

---

## 17. 推荐修改文件

```text
glslang/Include/Types.h
  - TCoopMatUse enum
  - TType 增加 get/set coopMatUse
  - 类型比较 / mangling / clone

glslang/MachineIndependent/ParseHelper.cpp
  - coopmat 类型构造时 use = Unknown
  - coopMatMulAddHW / AZD semantic rule
  - binary op 初步约束收集

glslang/MachineIndependent/Intermediate.cpp
  - 新增 EOpCoopMatRoleCast
  - 构造 cast node helper

glslang/MachineIndependent/intermOut.cpp
  - debug dump 打印 coopmat use

glslang/MachineIndependent/CoopMatUseResolver.cpp
  - 新 pass：collect / solve / rewrite / cast insert

glslang/SPIRV/GlslangToSpv.cpp
  - convert type 时区分 use
  - emit EOpCoopMatRoleCast
  - intrinsic emit 使用 resolved type

glslang/SPIRV/SpvBuilder.cpp
  - makeCooperativeMatrixAZDType / HWType 增加 use operand
```

---

## 18. 最小实现版本

第一阶段建议只支持：

```text
1. 局部变量 use 推断
2. coopMatMulAddHW / AZD 参数 use 推断
3. assignment role 统一
4. binary + / - / scalar multiply 基础规则
5. function 参数 / 返回 resolved signature
6. SPIR-V emit 带 use
```

第一阶段保守报错：

```text
1. select 两边 role 不一致
2. 同一个 storage member A/B 混用
3. A/B 和 Accumulator 隐式转换
4. unresolved forward call 复杂递归
5. 多态函数根据 use 重载
```

---

## 19. 示例

源码：

```glsl
coopmatHW<uint8_t, 16, 32> A;
coopmatHW<uint8_t, 32, 16> B;
coopmatHW<uint32_t, 16, 16> C;
coopmatHW<uint32_t, 16, 16> D;

D = coopMatMulAddHW(A, B, C);
```

AST 推断结果：

```text
A -> UseA
B -> UseB
C -> Accumulator
D -> Accumulator
```

内部类型变成：

```text
A : coopmatHW<uint8_t, 16, 32, UseA>
B : coopmatHW<uint8_t, 32, 16, UseB>
C : coopmatHW<uint32_t,16, 16, Accumulator>
D : coopmatHW<uint32_t,16, 16, Accumulator>
```

SPIR-V emit：

```spirv
%type_A = OpTypeCooperativeMatrixHW %uint8  %int_16 %int_32 MatrixUseAHW
%type_B = OpTypeCooperativeMatrixHW %uint8  %int_32 %int_16 MatrixUseBHW
%type_C = OpTypeCooperativeMatrixHW %uint32 %int_16 %int_16 MatrixAccumulatorHW
```

---

## 20. 分阶段开发计划

### 第一刀：类型系统 + emit

实现：

```text
TType 增加 coopMatUse
SPIR-V type cache key 增加 use
emit OpTypeCooperativeMatrixAZD/HW 带 use
```

目标：

```text
可以手工构造 A/B/Accumulator 三种类型，并 emit 正确 SPIR-V type
```

---

### 第二刀：mulAdd 约束推断

实现：

```text
coopMatMulAddHW(A, B, C)
A -> UseA
B -> UseB
C/D -> Accumulator
```

目标测试：

```glsl
D = coopMatMulAddHW(A, B, C);
```

---

### 第三刀：assignment / binary op

实现：

```text
=, +, -, scalar multiply
```

目标测试：

```glsl
C2 = C + D;
D = D * 2;
```

---

### 第四刀：函数参数 / 返回

实现：

```text
callee body 推断 param / return
call site 修正 argument type
return statement 修正 return type
```

目标测试：

```glsl
coopmatHW<uint32_t,16,16> foo(
    coopmatHW<uint8_t,16,32> A,
    coopmatHW<uint8_t,32,16> B,
    coopmatHW<uint32_t,16,16> C)
{
    return coopMatMulAddHW(A, B, C);
}
```

---

### 第五刀：bitcast 插入

实现：

```text
A/B boundary cast
function call cast
return cast
select/phi cast
accesschain/load cast
```

目标测试：

```text
InsertsFunctionBoundaryBitcastsForParametersAndReturns
InsertsPhiEdgeBitcasts
InsertsAccessChainLoadUseBitcast
```

---

## 21. 结论

推荐把 `use` 正式纳入 glslang 类型系统：

```text
coopmat kind + element type + shape + use = 完整类型
```

然后新增一个专门 AST pass：

```text
collect constraints
resolve role
rewrite type
insert role cast
validate
```

最终 SPIR-V emit 层只根据已经 resolved 的 `TType` 生成正确的 `OpTypeCooperativeMatrixAZD/HW`。

这种设计相比 spirv-tools 后处理方案有几个优势：

```text
1. 不依赖 spirv-tools
2. 错误可以在 GLSL 编译阶段定位到源码行
3. 函数参数 / 返回 / AST 边界更容易处理
4. emit 的 SPIR-V 天然类型正确
5. 不需要后处理扫描 SSA use-def
```

第一阶段建议保守实现：

```text
A/B 冲突：
  按 use count 决策，tie 报错

A/B 与 Accumulator 冲突：
  默认报错

显式 cast：
  后续再开放

复杂 select / phi / storage 混用：
  第一阶段先报错，稳定后再支持
```
