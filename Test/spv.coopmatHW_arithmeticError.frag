#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_neural_matrix : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopmatHW<float16_t, 16, 8> f16a, f16b;
    coopmatHW<float, 16, 8> f32a;
    coopmatHW<float16_t, 8, 16> f16shape;

    coopmatHW<int, 8, 8> i32a;
    coopmatHW<uint8_t, 16, 8> u8a;
    coopmatHW<int8_t, 16, 8> i8a;

    f16a + float16_t(1.0);
    f16a - float16_t(1.0);
    f16a / float16_t(1.0);
    float16_t(1.0) + f16a;
    float16_t(1.0) - f16a;
    float16_t(1.0) / f16a;
    f16a += float16_t(1.0);
    f16a -= float16_t(1.0);
    f16a /= float16_t(1.0);

    f16a + f32a;
    f16a - f32a;
    f16a * f32a;
    f16a / f32a;
    f16a += f32a;
    f16a -= f32a;
    f16a *= f32a;
    f16a /= f32a;

    f16a + f16shape;
    f16a - f16shape;
    f16a * f16shape;
    f16a / f16shape;
    f16a += f16shape;
    f16a -= f16shape;
    f16a *= f16shape;
    f16a /= f16shape;

    u8a + i8a;
    u8a - i8a;
    u8a * i8a;
    u8a / i8a;
    u8a += i8a;
    u8a -= i8a;
    u8a *= i8a;
    u8a /= i8a;

    i32a + 1;
    i32a - 1;
    i32a / 1;
    i32a += 1;
    i32a -= 1;
    i32a /= 1;
}
