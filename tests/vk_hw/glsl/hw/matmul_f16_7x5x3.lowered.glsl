#version 450
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
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

float16_t[35] _81()
{
    f16vec2 _261 = f16vec2(A.data[0u]);
    f16vec2 _267 = f16vec2(A.data[1u]);
    f16vec2 _273 = f16vec2(A.data[2u]);
    f16vec2 _275 = fma(_273, f16vec2(B.data[10u], B.data[11u]), fma(_267, f16vec2(B.data[5u], B.data[6u]), fma(_261, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[0u], C.data[1u]))));
    f16vec2 _277 = fma(_273, f16vec2(B.data[12u], B.data[13u]), fma(_267, f16vec2(B.data[7u], B.data[8u]), fma(_261, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[2u], C.data[3u]))));
    f16vec2 _285 = f16vec2(A.data[3u]);
    f16vec2 _291 = f16vec2(A.data[4u]);
    f16vec2 _297 = f16vec2(A.data[5u]);
    f16vec2 _299 = fma(_297, f16vec2(B.data[10u], B.data[11u]), fma(_291, f16vec2(B.data[5u], B.data[6u]), fma(_285, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[5u], C.data[6u]))));
    f16vec2 _301 = fma(_297, f16vec2(B.data[12u], B.data[13u]), fma(_291, f16vec2(B.data[7u], B.data[8u]), fma(_285, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[7u], C.data[8u]))));
    f16vec2 _309 = f16vec2(A.data[6u]);
    f16vec2 _315 = f16vec2(A.data[7u]);
    f16vec2 _321 = f16vec2(A.data[8u]);
    f16vec2 _323 = fma(_321, f16vec2(B.data[10u], B.data[11u]), fma(_315, f16vec2(B.data[5u], B.data[6u]), fma(_309, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[10u], C.data[11u]))));
    f16vec2 _325 = fma(_321, f16vec2(B.data[12u], B.data[13u]), fma(_315, f16vec2(B.data[7u], B.data[8u]), fma(_309, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[12u], C.data[13u]))));
    f16vec2 _333 = f16vec2(A.data[9u]);
    f16vec2 _339 = f16vec2(A.data[10u]);
    f16vec2 _345 = f16vec2(A.data[11u]);
    f16vec2 _347 = fma(_345, f16vec2(B.data[10u], B.data[11u]), fma(_339, f16vec2(B.data[5u], B.data[6u]), fma(_333, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[15u], C.data[16u]))));
    f16vec2 _349 = fma(_345, f16vec2(B.data[12u], B.data[13u]), fma(_339, f16vec2(B.data[7u], B.data[8u]), fma(_333, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[17u], C.data[18u]))));
    f16vec2 _357 = f16vec2(A.data[12u]);
    f16vec2 _363 = f16vec2(A.data[13u]);
    f16vec2 _369 = f16vec2(A.data[14u]);
    f16vec2 _371 = fma(_369, f16vec2(B.data[10u], B.data[11u]), fma(_363, f16vec2(B.data[5u], B.data[6u]), fma(_357, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[20u], C.data[21u]))));
    f16vec2 _373 = fma(_369, f16vec2(B.data[12u], B.data[13u]), fma(_363, f16vec2(B.data[7u], B.data[8u]), fma(_357, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[22u], C.data[23u]))));
    f16vec2 _381 = f16vec2(A.data[15u]);
    f16vec2 _387 = f16vec2(A.data[16u]);
    f16vec2 _393 = f16vec2(A.data[17u]);
    f16vec2 _395 = fma(_393, f16vec2(B.data[10u], B.data[11u]), fma(_387, f16vec2(B.data[5u], B.data[6u]), fma(_381, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[25u], C.data[26u]))));
    f16vec2 _397 = fma(_393, f16vec2(B.data[12u], B.data[13u]), fma(_387, f16vec2(B.data[7u], B.data[8u]), fma(_381, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[27u], C.data[28u]))));
    f16vec2 _405 = f16vec2(A.data[18u]);
    f16vec2 _411 = f16vec2(A.data[19u]);
    f16vec2 _417 = f16vec2(A.data[20u]);
    f16vec2 _419 = fma(_417, f16vec2(B.data[10u], B.data[11u]), fma(_411, f16vec2(B.data[5u], B.data[6u]), fma(_405, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[30u], C.data[31u]))));
    f16vec2 _421 = fma(_417, f16vec2(B.data[12u], B.data[13u]), fma(_411, f16vec2(B.data[7u], B.data[8u]), fma(_405, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[32u], C.data[33u]))));
    return float16_t[](_275.x, _275.y, _277.x, _277.y, fma(A.data[2u], B.data[14u], fma(A.data[1u], B.data[9u], fma(A.data[0u], B.data[4u], C.data[4u]))), _299.x, _299.y, _301.x, _301.y, fma(A.data[5u], B.data[14u], fma(A.data[4u], B.data[9u], fma(A.data[3u], B.data[4u], C.data[9u]))), _323.x, _323.y, _325.x, _325.y, fma(A.data[8u], B.data[14u], fma(A.data[7u], B.data[9u], fma(A.data[6u], B.data[4u], C.data[14u]))), _347.x, _347.y, _349.x, _349.y, fma(A.data[11u], B.data[14u], fma(A.data[10u], B.data[9u], fma(A.data[9u], B.data[4u], C.data[19u]))), _371.x, _371.y, _373.x, _373.y, fma(A.data[14u], B.data[14u], fma(A.data[13u], B.data[9u], fma(A.data[12u], B.data[4u], C.data[24u]))), _395.x, _395.y, _397.x, _397.y, fma(A.data[17u], B.data[14u], fma(A.data[16u], B.data[9u], fma(A.data[15u], B.data[4u], C.data[29u]))), _419.x, _419.y, _421.x, _421.y, fma(A.data[20u], B.data[14u], fma(A.data[19u], B.data[9u], fma(A.data[18u], B.data[4u], C.data[34u]))));
}

void main()
{
    float16_t _61[35] = _81();
    float16_t tempArg[35] = _61;
    float16_t d[35] = _61;
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)] = _61[0];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)] = _61[1];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)] = _61[2];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)] = _61[3];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)] = _61[4];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)] = _61[5];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)] = _61[6];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)] = _61[7];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)] = _61[8];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)] = _61[9];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)] = _61[10];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)] = _61[11];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)] = _61[12];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)] = _61[13];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)] = _61[14];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)] = _61[15];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)] = _61[16];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)] = _61[17];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)] = _61[18];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)] = _61[19];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)] = _61[20];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)] = _61[21];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)] = _61[22];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)] = _61[23];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)] = _61[24];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)] = _61[25];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)] = _61[26];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)] = _61[27];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)] = _61[28];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)] = _61[29];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)] = _61[30];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)] = _61[31];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)] = _61[32];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)] = _61[33];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)] = _61[34];
}

