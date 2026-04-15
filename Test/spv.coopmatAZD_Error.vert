#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_cooperative_matrix : enable
#extension GL_NV_cooperative_matrix : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopmatAZD<float16_t, 16, 8> A;
    fcoopmatNV<16, gl_ScopeSubgroup, 16, 8> N;

    A = N;
    coopmatAZD<float16_t, 16, 8>(N);

    coopmatAZD<float16_t, 16> bad1;
    coopmatAZD<float16_t, 16, 0> bad2;
    coopmatAZD<bool, 16, 8> bad3;
}
