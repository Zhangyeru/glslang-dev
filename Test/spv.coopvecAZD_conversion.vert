#version 450 core
#extension GL_AZD_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    gl_Position = vec4(0.0);

    coopvecAZD<float16_t, 5> f16;
    coopvecAZD<float, 5> f32;
    coopvecAZD<int, 5> i32;
    coopvecAZD<uint, 5> u32;
    coopvecAZD<int16_t, 5> i16;
    coopvecAZD<uint16_t, 5> u16;

    u32 = coopvecAZD<uint, 5>(f16);
    i32 = coopvecAZD<int, 5>(f16);
    i16 = coopvecAZD<int16_t, 5>(f32);
    u16 = coopvecAZD<uint16_t, 5>(f32);

    i32 = coopvecAZD<int, 5>(u16);
    u32 = coopvecAZD<uint, 5>(i16);

    f32 = coopvecAZD<float, 5>(u16);
    f16 = coopvecAZD<float16_t, 5>(i16);
    f16 = coopvecAZD<float16_t, 5>(f32);
}
