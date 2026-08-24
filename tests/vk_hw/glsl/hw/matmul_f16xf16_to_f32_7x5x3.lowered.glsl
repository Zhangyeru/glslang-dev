#version 460
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

float[35] _82()
{
    vec2 _273 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _287 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _301 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _315 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _329 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _343 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _357 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _371 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _385 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _399 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _413 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _427 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _441 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _455 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _469 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _483 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _497 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _511 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _525 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _539 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _553 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _567 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _581 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _595 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _609 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _623 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _637 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _651 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _665 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _679 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _693 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _707 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _721 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _735 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _749 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    return float[]((_273.x + _273.y) + C.data[0u], (_287.x + _287.y) + C.data[1u], (_301.x + _301.y) + C.data[2u], (_315.x + _315.y) + C.data[3u], (_329.x + _329.y) + C.data[4u], (_343.x + _343.y) + C.data[5u], (_357.x + _357.y) + C.data[6u], (_371.x + _371.y) + C.data[7u], (_385.x + _385.y) + C.data[8u], (_399.x + _399.y) + C.data[9u], (_413.x + _413.y) + C.data[10u], (_427.x + _427.y) + C.data[11u], (_441.x + _441.y) + C.data[12u], (_455.x + _455.y) + C.data[13u], (_469.x + _469.y) + C.data[14u], (_483.x + _483.y) + C.data[15u], (_497.x + _497.y) + C.data[16u], (_511.x + _511.y) + C.data[17u], (_525.x + _525.y) + C.data[18u], (_539.x + _539.y) + C.data[19u], (_553.x + _553.y) + C.data[20u], (_567.x + _567.y) + C.data[21u], (_581.x + _581.y) + C.data[22u], (_595.x + _595.y) + C.data[23u], (_609.x + _609.y) + C.data[24u], (_623.x + _623.y) + C.data[25u], (_637.x + _637.y) + C.data[26u], (_651.x + _651.y) + C.data[27u], (_665.x + _665.y) + C.data[28u], (_679.x + _679.y) + C.data[29u], (_693.x + _693.y) + C.data[30u], (_707.x + _707.y) + C.data[31u], (_721.x + _721.y) + C.data[32u], (_735.x + _735.y) + C.data[33u], (_749.x + _749.y) + C.data[34u]);
}

void main()
{
    float _62[35] = _82();
    float tempArg[35] = _62;
    float d[35] = _62;
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)] = _62[0];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)] = _62[1];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)] = _62[2];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)] = _62[3];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)] = _62[4];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)] = _62[5];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)] = _62[6];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)] = _62[7];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)] = _62[8];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)] = _62[9];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)] = _62[10];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)] = _62[11];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)] = _62[12];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)] = _62[13];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)] = _62[14];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)] = _62[15];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)] = _62[16];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)] = _62[17];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)] = _62[18];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)] = _62[19];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)] = _62[20];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)] = _62[21];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)] = _62[22];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)] = _62[23];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)] = _62[24];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)] = _62[25];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)] = _62[26];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)] = _62[27];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)] = _62[28];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)] = _62[29];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)] = _62[30];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)] = _62[31];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)] = _62[32];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)] = _62[33];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)] = _62[34];
}

