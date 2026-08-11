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
    float _99[35] = float[](0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    uint _100 = 0u;
    uint _106;
    for (;;)
    {
        _106 = _100;
        if (_106 < 35u)
        {
            float _102 = 0.0;
            uint _101 = 0u;
            uint _108;
            for (;;)
            {
                _108 = _101;
                if (_108 < 3u)
                {
                    uint _113 = ((_106 / 5u) * 3u) + _108;
                    uint _115 = (_108 * 5u) + (_106 % 5u);
                    _102 = fma(float(A.data[((uint(0) + (_113 / 3u)) * uint(3)) + (uint(0) + (_113 % 3u))]), float(B.data[((uint(0) + (_115 / 5u)) * uint(5)) + (uint(0) + (_115 % 5u))]), _102);
                    _101 = _108 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _99[_106] = _102 + C.data[((uint(0) + (_106 / 5u)) * uint(5)) + (uint(0) + (_106 % 5u))];
            _100 = _106 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _99;
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

