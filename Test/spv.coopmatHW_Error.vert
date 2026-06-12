#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_neural_shader : enable
#extension GL_NV_cooperative_matrix : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopmatHW<float16_t, 16, 8> A;
    fcoopmatNV<16, gl_ScopeSubgroup, 16, 8> N;

    A = N;
    coopmatHW<float16_t, 16, 8>(N);

    coopmatHW<float16_t, 16> bad1;
    coopmatHW<float16_t, 16, 0> bad2;
    coopmatHW<bool, 16, 8> bad3;
}
