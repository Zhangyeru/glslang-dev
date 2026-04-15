#version 450 core
#extension GL_AZD_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopvecAZD<float16_t, 5> f16;
    coopvecAZD<float, 6> f32shape;
    coopvecAZD<int16_t, 6> i16shape;

    coopvecAZD<uint, 6>(f16);
    coopvecAZD<int, 5>(f32shape);
    coopvecAZD<float16_t, 5>(i16shape);
}
