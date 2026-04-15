#version 450 core
#extension GL_AZD_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopvecAZD<int, 5> i32;
    coopvecAZD<uint8_t, 5> u8;
    coopvecAZD<float, 5> f32;
    coopvecAZD<float16_t, 5> f16;

    floatBitsToInt(i32);
    uintBitsToFloat(u8);
    float16BitsToInt16(f32);
    int16BitsToFloat16(f16);
}
