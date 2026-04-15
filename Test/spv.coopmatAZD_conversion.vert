#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_cooperative_matrix : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    gl_Position = vec4(0.0);

    coopmatAZD<float16_t, 16, 8> f16;
    coopmatAZD<float, 16, 8> f32;
    coopmatAZD<int, 16, 8> i32;
    coopmatAZD<uint, 16, 8> u32;
    coopmatAZD<int16_t, 16, 8> i16;
    coopmatAZD<uint16_t, 16, 8> u16;

    u32 = coopmatAZD<uint, 16, 8>(f16);
    i32 = coopmatAZD<int, 16, 8>(f16);
    i16 = coopmatAZD<int16_t, 16, 8>(f32);
    u16 = coopmatAZD<uint16_t, 16, 8>(f32);

    i32 = coopmatAZD<int, 16, 8>(i16);
    u32 = coopmatAZD<uint, 16, 8>(u16);

    f32 = coopmatAZD<float, 16, 8>(u16);
    f16 = coopmatAZD<float16_t, 16, 8>(i16);
    f16 = coopmatAZD<float16_t, 16, 8>(f32);
}
