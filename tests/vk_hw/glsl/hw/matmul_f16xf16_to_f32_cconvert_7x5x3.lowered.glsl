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
    vec2 _224 = vec2(f16vec2(A.data[0u]));
    vec2 _235 = vec2(f16vec2(A.data[1u]));
    vec2 _246 = vec2(f16vec2(A.data[2u]));
    vec2 _249 = fma(_246, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_235, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_224, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(_91[0], _91[1]))));
    vec2 _252 = fma(_246, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_235, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_224, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(_91[2], _91[3]))));
    vec2 _263 = vec2(f16vec2(A.data[3u]));
    vec2 _274 = vec2(f16vec2(A.data[4u]));
    vec2 _285 = vec2(f16vec2(A.data[5u]));
    vec2 _288 = fma(_285, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_274, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_263, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(_91[5], _91[6]))));
    vec2 _291 = fma(_285, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_274, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_263, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(_91[7], _91[8]))));
    vec2 _302 = vec2(f16vec2(A.data[6u]));
    vec2 _313 = vec2(f16vec2(A.data[7u]));
    vec2 _324 = vec2(f16vec2(A.data[8u]));
    vec2 _327 = fma(_324, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_313, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_302, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(_91[10], _91[11]))));
    vec2 _330 = fma(_324, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_313, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_302, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(_91[12], _91[13]))));
    vec2 _341 = vec2(f16vec2(A.data[9u]));
    vec2 _352 = vec2(f16vec2(A.data[10u]));
    vec2 _363 = vec2(f16vec2(A.data[11u]));
    vec2 _366 = fma(_363, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_352, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_341, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(_91[15], _91[16]))));
    vec2 _369 = fma(_363, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_352, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_341, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(_91[17], _91[18]))));
    vec2 _380 = vec2(f16vec2(A.data[12u]));
    vec2 _391 = vec2(f16vec2(A.data[13u]));
    vec2 _402 = vec2(f16vec2(A.data[14u]));
    vec2 _405 = fma(_402, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_391, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_380, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(_91[20], _91[21]))));
    vec2 _408 = fma(_402, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_391, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_380, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(_91[22], _91[23]))));
    vec2 _419 = vec2(f16vec2(A.data[15u]));
    vec2 _430 = vec2(f16vec2(A.data[16u]));
    vec2 _441 = vec2(f16vec2(A.data[17u]));
    vec2 _444 = fma(_441, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_430, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_419, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(_91[25], _91[26]))));
    vec2 _447 = fma(_441, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_430, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_419, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(_91[27], _91[28]))));
    vec2 _458 = vec2(f16vec2(A.data[18u]));
    vec2 _469 = vec2(f16vec2(A.data[19u]));
    vec2 _480 = vec2(f16vec2(A.data[20u]));
    vec2 _483 = fma(_480, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_469, vec2(f16vec2(B.data[5u], B.data[6u])), fma(_458, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(_91[30], _91[31]))));
    vec2 _486 = fma(_480, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_469, vec2(f16vec2(B.data[7u], B.data[8u])), fma(_458, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(_91[32], _91[33]))));
    return float[](_249.x, _249.y, _252.x, _252.y, fma(float(A.data[2u]), float(B.data[14u]), fma(float(A.data[1u]), float(B.data[9u]), fma(float(A.data[0u]), float(B.data[4u]), _91[4]))), _288.x, _288.y, _291.x, _291.y, fma(float(A.data[5u]), float(B.data[14u]), fma(float(A.data[4u]), float(B.data[9u]), fma(float(A.data[3u]), float(B.data[4u]), _91[9]))), _327.x, _327.y, _330.x, _330.y, fma(float(A.data[8u]), float(B.data[14u]), fma(float(A.data[7u]), float(B.data[9u]), fma(float(A.data[6u]), float(B.data[4u]), _91[14]))), _366.x, _366.y, _369.x, _369.y, fma(float(A.data[11u]), float(B.data[14u]), fma(float(A.data[10u]), float(B.data[9u]), fma(float(A.data[9u]), float(B.data[4u]), _91[19]))), _405.x, _405.y, _408.x, _408.y, fma(float(A.data[14u]), float(B.data[14u]), fma(float(A.data[13u]), float(B.data[9u]), fma(float(A.data[12u]), float(B.data[4u]), _91[24]))), _444.x, _444.y, _447.x, _447.y, fma(float(A.data[17u]), float(B.data[14u]), fma(float(A.data[16u]), float(B.data[9u]), fma(float(A.data[15u]), float(B.data[4u]), _91[29]))), _483.x, _483.y, _486.x, _486.y, fma(float(A.data[20u]), float(B.data[14u]), fma(float(A.data[19u]), float(B.data[9u]), fma(float(A.data[18u]), float(B.data[4u]), _91[34]))));
}

void main()
{
    float16_t _54[35] = float16_t[](C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)]);
    float16_t tempArg[35] = _54;
    float16_t c16[35] = _54;
    float16_t _993[35] = _54;
    uint _991 = 0u;
    float _990[35];
    uint _998;
    for (;;)
    {
        _998 = _991;
        if (_998 < 35u)
        {
            _990[_998] = float(_993[_998]);
            _991 = _998 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float _64[35] = _990;
    float c[35] = _64;
    float _69[35] = _90(_990);
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

