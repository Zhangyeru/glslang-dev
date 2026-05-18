#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_neural_matrix : enable
#extension GL_AZD_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopvecAZD<float, 100> result;
    coopvecAZD<float16_t, 20> vInput;
    coopvecAZD<float16_t, 99> badBias;
    coopmatAZD<float16_t, 100, 20> matrix;

    coopVecMatMulAddAZD(result, vInput, matrix, badBias);
}
