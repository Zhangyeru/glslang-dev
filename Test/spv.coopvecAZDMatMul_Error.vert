#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_neural_matrix : enable
#extension GL_AZD_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopvecAZD<float, 99> badResult;
    coopvecAZD<float16_t, 19> badInput;
    coopmatAZD<float16_t, 100, 20> matrix;

    coopVecMatMulAZD(badResult, badInput, matrix);
}
