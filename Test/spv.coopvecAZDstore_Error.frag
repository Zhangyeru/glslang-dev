#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

layout(set = 0, binding = 0) buffer MatrixBuf {
    float16_t matrixData[];
} matrixBuf;

void main()
{
    coopvecAZD<float, 5> v;
    coopVecStoreAZD(v, matrixBuf.matrixData, 128);
}
