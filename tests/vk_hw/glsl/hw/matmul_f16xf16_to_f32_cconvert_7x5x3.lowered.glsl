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
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

float[35] _90(float _91[35])
{
    vec2 _232 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _246 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _260 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _274 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _288 = fma(vec2(f16vec2(A.data[2u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _302 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _316 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _330 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _344 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _358 = fma(vec2(f16vec2(A.data[5u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[3u], A.data[4u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _372 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _386 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _400 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _414 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _428 = fma(vec2(f16vec2(A.data[8u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _442 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _456 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _470 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _484 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _498 = fma(vec2(f16vec2(A.data[11u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[9u], A.data[10u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _512 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _526 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _540 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _554 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _568 = fma(vec2(f16vec2(A.data[14u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _582 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _596 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _610 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _624 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _638 = fma(vec2(f16vec2(A.data[17u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[15u], A.data[16u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    vec2 _652 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[10u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[0u], B.data[5u])), vec2(0.0)));
    vec2 _666 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[11u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[1u], B.data[6u])), vec2(0.0)));
    vec2 _680 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[12u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[2u], B.data[7u])), vec2(0.0)));
    vec2 _694 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[13u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[3u], B.data[8u])), vec2(0.0)));
    vec2 _708 = fma(vec2(f16vec2(A.data[20u], float16_t(0.0))), vec2(f16vec2(B.data[14u], float16_t(0.0))), fma(vec2(f16vec2(A.data[18u], A.data[19u])), vec2(f16vec2(B.data[4u], B.data[9u])), vec2(0.0)));
    return float[]((_232.x + _232.y) + _91[0], (_246.x + _246.y) + _91[1], (_260.x + _260.y) + _91[2], (_274.x + _274.y) + _91[3], (_288.x + _288.y) + _91[4], (_302.x + _302.y) + _91[5], (_316.x + _316.y) + _91[6], (_330.x + _330.y) + _91[7], (_344.x + _344.y) + _91[8], (_358.x + _358.y) + _91[9], (_372.x + _372.y) + _91[10], (_386.x + _386.y) + _91[11], (_400.x + _400.y) + _91[12], (_414.x + _414.y) + _91[13], (_428.x + _428.y) + _91[14], (_442.x + _442.y) + _91[15], (_456.x + _456.y) + _91[16], (_470.x + _470.y) + _91[17], (_484.x + _484.y) + _91[18], (_498.x + _498.y) + _91[19], (_512.x + _512.y) + _91[20], (_526.x + _526.y) + _91[21], (_540.x + _540.y) + _91[22], (_554.x + _554.y) + _91[23], (_568.x + _568.y) + _91[24], (_582.x + _582.y) + _91[25], (_596.x + _596.y) + _91[26], (_610.x + _610.y) + _91[27], (_624.x + _624.y) + _91[28], (_638.x + _638.y) + _91[29], (_652.x + _652.y) + _91[30], (_666.x + _666.y) + _91[31], (_680.x + _680.y) + _91[32], (_694.x + _694.y) + _91[33], (_708.x + _708.y) + _91[34]);
}

void main()
{
    float16_t _54[35] = float16_t[](C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)]);
    float16_t tempArg[35] = _54;
    float16_t c16[35] = _54;
    float16_t _1212[35] = _54;
    uint _1210 = 0u;
    float _1209[35];
    uint _1217;
    for (;;)
    {
        _1217 = _1210;
        if (_1217 < 35u)
        {
            _1209[_1217] = float(_1212[_1217]);
            _1210 = _1217 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float _64[35] = _1209;
    float c[35] = _64;
    float _69[35] = _90(_1209);
    float tempArg_1[35] = _69;
    float d[35] = _69;
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)] = _69[0];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)] = _69[1];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)] = _69[2];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)] = _69[3];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)] = _69[4];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)] = _69[5];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)] = _69[6];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)] = _69[7];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)] = _69[8];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)] = _69[9];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)] = _69[10];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)] = _69[11];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)] = _69[12];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)] = _69[13];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)] = _69[14];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)] = _69[15];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)] = _69[16];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)] = _69[17];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)] = _69[18];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)] = _69[19];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)] = _69[20];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)] = _69[21];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)] = _69[22];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)] = _69[23];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)] = _69[24];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)] = _69[25];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)] = _69[26];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)] = _69[27];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)] = _69[28];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)] = _69[29];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)] = _69[30];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)] = _69[31];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)] = _69[32];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)] = _69[33];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)] = _69[34];
}

