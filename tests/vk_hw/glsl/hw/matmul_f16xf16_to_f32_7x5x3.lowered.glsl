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
    vec2 _265 = vec2(f16vec2(A.data[0u]));
    vec2 _276 = vec2(f16vec2(A.data[1u]));
    vec2 _287 = vec2(f16vec2(A.data[2u]));
    vec2 _290 = fma(_287, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_276, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_265, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[0u], C.data[1u]))));
    vec2 _293 = fma(_287, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_276, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_265, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[2u], C.data[3u]))));
    vec2 _304 = vec2(f16vec2(A.data[3u]));
    vec2 _315 = vec2(f16vec2(A.data[4u]));
    vec2 _326 = vec2(f16vec2(A.data[5u]));
    vec2 _329 = fma(_326, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_315, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_304, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[5u], C.data[6u]))));
    vec2 _332 = fma(_326, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_315, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_304, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[7u], C.data[8u]))));
    vec2 _343 = vec2(f16vec2(A.data[6u]));
    vec2 _354 = vec2(f16vec2(A.data[7u]));
    vec2 _365 = vec2(f16vec2(A.data[8u]));
    vec2 _368 = fma(_365, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_354, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_343, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[10u], C.data[11u]))));
    vec2 _371 = fma(_365, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_354, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_343, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[12u], C.data[13u]))));
    vec2 _382 = vec2(f16vec2(A.data[9u]));
    vec2 _393 = vec2(f16vec2(A.data[10u]));
    vec2 _404 = vec2(f16vec2(A.data[11u]));
    vec2 _407 = fma(_404, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_393, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_382, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[15u], C.data[16u]))));
    vec2 _410 = fma(_404, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_393, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_382, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[17u], C.data[18u]))));
    vec2 _421 = vec2(f16vec2(A.data[12u]));
    vec2 _432 = vec2(f16vec2(A.data[13u]));
    vec2 _443 = vec2(f16vec2(A.data[14u]));
    vec2 _446 = fma(_443, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_432, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_421, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[20u], C.data[21u]))));
    vec2 _449 = fma(_443, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_432, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_421, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[22u], C.data[23u]))));
    vec2 _460 = vec2(f16vec2(A.data[15u]));
    vec2 _471 = vec2(f16vec2(A.data[16u]));
    vec2 _482 = vec2(f16vec2(A.data[17u]));
    vec2 _485 = fma(_482, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_471, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_460, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[25u], C.data[26u]))));
    vec2 _488 = fma(_482, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_471, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_460, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[27u], C.data[28u]))));
    vec2 _499 = vec2(f16vec2(A.data[18u]));
    vec2 _510 = vec2(f16vec2(A.data[19u]));
    vec2 _521 = vec2(f16vec2(A.data[20u]));
    vec2 _524 = fma(_521, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_510, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_499, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[30u], C.data[31u]))));
    vec2 _527 = fma(_521, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_510, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_499, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[32u], C.data[33u]))));
    return float[](_290.x, _290.y, _293.x, _293.y, fma(float(A.data[2u]), float(B.data[14u]), fma(float(A.data[1u]), float(B.data[9u]), fma(float(A.data[0u]), float(B.data[4u]), C.data[4u]))), _329.x, _329.y, _332.x, _332.y, fma(float(A.data[5u]), float(B.data[14u]), fma(float(A.data[4u]), float(B.data[9u]), fma(float(A.data[3u]), float(B.data[4u]), C.data[9u]))), _368.x, _368.y, _371.x, _371.y, fma(float(A.data[8u]), float(B.data[14u]), fma(float(A.data[7u]), float(B.data[9u]), fma(float(A.data[6u]), float(B.data[4u]), C.data[14u]))), _407.x, _407.y, _410.x, _410.y, fma(float(A.data[11u]), float(B.data[14u]), fma(float(A.data[10u]), float(B.data[9u]), fma(float(A.data[9u]), float(B.data[4u]), C.data[19u]))), _446.x, _446.y, _449.x, _449.y, fma(float(A.data[14u]), float(B.data[14u]), fma(float(A.data[13u]), float(B.data[9u]), fma(float(A.data[12u]), float(B.data[4u]), C.data[24u]))), _485.x, _485.y, _488.x, _488.y, fma(float(A.data[17u]), float(B.data[14u]), fma(float(A.data[16u]), float(B.data[9u]), fma(float(A.data[15u]), float(B.data[4u]), C.data[29u]))), _524.x, _524.y, _527.x, _527.y, fma(float(A.data[20u]), float(B.data[14u]), fma(float(A.data[19u]), float(B.data[9u]), fma(float(A.data[18u]), float(B.data[4u]), C.data[34u]))));
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

