#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_neural_matrix : enable
#extension GL_HW_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopvecHW<float, 100> result;
    coopvecHW<float16_t, 20> vInput;
    coopvecHW<float16_t, 99> badBias;
    coopmatHW<float16_t, 100, 20> matrix;

    coopVecMatMulAddHW(result, vInput, matrix, badBias);
}
