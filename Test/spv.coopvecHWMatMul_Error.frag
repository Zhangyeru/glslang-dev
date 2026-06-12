#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_neural_matrix : enable
#extension GL_HW_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopvecHW<float, 99> badResult;
    coopvecHW<float16_t, 19> badInput;
    coopmatHW<float16_t, 100, 20> matrix;

    coopVecMatMulHW(badResult, badInput, matrix);
}
