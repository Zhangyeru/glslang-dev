#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_neural_shader : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

layout(set = 0, binding = 0) buffer MatrixBuf {
    float16_t matrixData[];
} matrixBuf;

void main()
{
    coopvecHW<float, 5> v;
    coopVecLoadHW(v, matrixBuf.matrixData, 128);
}
