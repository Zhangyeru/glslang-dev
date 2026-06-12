#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_neural_matrix : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopmatHW<float16_t, 16, 8> f16;
    coopmatHW<float16_t, 8, 16> f16shape;
    coopmatHW<int16_t, 8, 16> i16shape;

    coopmatHW<uint, 8, 16>(f16);
    coopmatHW<int, 16, 8>(f16shape);
    coopmatHW<float16_t, 16, 8>(i16shape);
}
