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
    float _112[35] = _91;
    float _108[35] = float[](0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    uint _109 = 0u;
    uint _115;
    for (;;)
    {
        _115 = _109;
        if (_115 < 35u)
        {
            float _111 = 0.0;
            uint _110 = 0u;
            uint _117;
            for (;;)
            {
                _117 = _110;
                if (_117 < 3u)
                {
                    uint _122 = ((_115 / 5u) * 3u) + _117;
                    uint _124 = (_117 * 5u) + (_115 % 5u);
                    _111 = fma(float(A.data[((uint(0) + (_122 / 3u)) * uint(3)) + (uint(0) + (_122 % 3u))]), float(B.data[((uint(0) + (_124 / 5u)) * uint(5)) + (uint(0) + (_124 % 5u))]), _111);
                    _110 = _117 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _108[_115] = _111 + _112[_115];
            _109 = _115 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _108;
}

void main()
{
    float16_t _54[35] = float16_t[](C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)]);
    float16_t tempArg[35] = _54;
    float16_t c16[35] = _54;
    float16_t _663[35] = _54;
    uint _661 = 0u;
    float _660[35];
    uint _668;
    for (;;)
    {
        _668 = _661;
        if (_668 < 35u)
        {
            _660[_668] = float(_663[_668]);
            _661 = _668 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float _64[35] = _660;
    float c[35] = _64;
    float _69[35] = _90(_660);
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

