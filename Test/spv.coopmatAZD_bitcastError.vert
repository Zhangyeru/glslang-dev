#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_cooperative_matrix : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopmatAZD<int, 16, 8> i32;
    coopmatAZD<uint8_t, 16, 8> u8;
    coopmatAZD<float, 16, 8> f32;
    coopmatAZD<float16_t, 16, 8> f16;

    floatBitsToInt(i32);
    uintBitsToFloat(u8);
    float16BitsToInt16(f32);
    int16BitsToFloat16(f16);
}
