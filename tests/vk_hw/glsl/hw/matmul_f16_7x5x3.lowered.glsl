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
    float16_t _98[35] = float16_t[](float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0));
    uint _99 = 0u;
    uint _105;
    for (;;)
    {
        _105 = _99;
        if (_105 < 35u)
        {
            float16_t _101 = float16_t(0.0);
            uint _100 = 0u;
            uint _107;
            for (;;)
            {
                _107 = _100;
                if (_107 < 3u)
                {
                    uint _112 = ((_105 / 5u) * 3u) + _107;
                    uint _114 = (_107 * 5u) + (_105 % 5u);
                    _101 = fma(A.data[((uint(0) + (_112 / 3u)) * uint(3)) + (uint(0) + (_112 % 3u))], B.data[((uint(0) + (_114 / 5u)) * uint(5)) + (uint(0) + (_114 % 5u))], _101);
                    _100 = _107 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _98[_105] = _101 + C.data[((uint(0) + (_105 / 5u)) * uint(5)) + (uint(0) + (_105 % 5u))];
            _99 = _105 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _98;
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

