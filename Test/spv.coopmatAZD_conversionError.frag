#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_neural_matrix : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopmatAZD<float16_t, 16, 8> f16;
    coopmatAZD<float16_t, 8, 16> f16shape;
    coopmatAZD<int16_t, 8, 16> i16shape;

    coopmatAZD<uint, 8, 16>(f16);
    coopmatAZD<int, 16, 8>(f16shape);
    coopmatAZD<float16_t, 16, 8>(i16shape);
}
