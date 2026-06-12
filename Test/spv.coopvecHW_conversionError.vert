#version 450 core
#extension GL_HW_neural_shader : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopvecHW<float16_t, 5> f16;
    coopvecHW<float, 6> f32shape;
    coopvecHW<int16_t, 6> i16shape;

    coopvecHW<uint, 6>(f16);
    coopvecHW<int, 5>(f32shape);
    coopvecHW<float16_t, 5>(i16shape);
}
