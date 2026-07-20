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

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float16_t data[];
} W;

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float16_t data[];
} Bias;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t data[];
} Y;

f16vec4 _79(uint _80)
{
    return f16vec4(X.data[_80], X.data[_80 + 1u], X.data[_80 + 2u], X.data[_80 + 3u]);
}

f16vec4 _116(uint _117)
{
    return f16vec4(W.data[_117], W.data[_117 + 1u], W.data[_117 + 2u], W.data[_117 + 3u]);
}

f16vec4 _159(uint _160)
{
    return f16vec4(Bias.data[_160], Bias.data[_160 + 1u], Bias.data[_160 + 2u], Bias.data[_160 + 3u]);
}

f16vec4[4] _191(f16vec4 _192[8], f16vec4 _193[128], f16vec4 _194[4])
{
    f16vec4 _267 = fma(_193[52], f16vec4(_192[3].y), fma(_193[48], f16vec4(_192[3].x), fma(_193[44], f16vec4(_192[2].w), fma(_193[40], f16vec4(_192[2].z), fma(_193[36], f16vec4(_192[2].y), fma(_193[32], f16vec4(_192[2].x), fma(_193[28], f16vec4(_192[1].w), fma(_193[24], f16vec4(_192[1].z), fma(_193[20], f16vec4(_192[1].y), fma(_193[16], f16vec4(_192[1].x), fma(_193[12], f16vec4(_192[0].w), fma(_193[8], f16vec4(_192[0].z), fma(_193[4], f16vec4(_192[0].y), fma(_193[0], f16vec4(_192[0].x), _194[0]))))))))))))));
    f16vec4 _337 = fma(_193[108], f16vec4(_192[6].w), fma(_193[104], f16vec4(_192[6].z), fma(_193[100], f16vec4(_192[6].y), fma(_193[96], f16vec4(_192[6].x), fma(_193[92], f16vec4(_192[5].w), fma(_193[88], f16vec4(_192[5].z), fma(_193[84], f16vec4(_192[5].y), fma(_193[80], f16vec4(_192[5].x), fma(_193[76], f16vec4(_192[4].w), fma(_193[72], f16vec4(_192[4].z), fma(_193[68], f16vec4(_192[4].y), fma(_193[64], f16vec4(_192[4].x), fma(_193[60], f16vec4(_192[3].w), fma(_193[56], f16vec4(_192[3].z), _267))))))))))))));
    f16vec4 _428 = fma(_193[53], f16vec4(_192[3].y), fma(_193[49], f16vec4(_192[3].x), fma(_193[45], f16vec4(_192[2].w), fma(_193[41], f16vec4(_192[2].z), fma(_193[37], f16vec4(_192[2].y), fma(_193[33], f16vec4(_192[2].x), fma(_193[29], f16vec4(_192[1].w), fma(_193[25], f16vec4(_192[1].z), fma(_193[21], f16vec4(_192[1].y), fma(_193[17], f16vec4(_192[1].x), fma(_193[13], f16vec4(_192[0].w), fma(_193[9], f16vec4(_192[0].z), fma(_193[5], f16vec4(_192[0].y), fma(_193[1], f16vec4(_192[0].x), _194[1]))))))))))))));
    f16vec4 _498 = fma(_193[109], f16vec4(_192[6].w), fma(_193[105], f16vec4(_192[6].z), fma(_193[101], f16vec4(_192[6].y), fma(_193[97], f16vec4(_192[6].x), fma(_193[93], f16vec4(_192[5].w), fma(_193[89], f16vec4(_192[5].z), fma(_193[85], f16vec4(_192[5].y), fma(_193[81], f16vec4(_192[5].x), fma(_193[77], f16vec4(_192[4].w), fma(_193[73], f16vec4(_192[4].z), fma(_193[69], f16vec4(_192[4].y), fma(_193[65], f16vec4(_192[4].x), fma(_193[61], f16vec4(_192[3].w), fma(_193[57], f16vec4(_192[3].z), _428))))))))))))));
    f16vec4 _589 = fma(_193[54], f16vec4(_192[3].y), fma(_193[50], f16vec4(_192[3].x), fma(_193[46], f16vec4(_192[2].w), fma(_193[42], f16vec4(_192[2].z), fma(_193[38], f16vec4(_192[2].y), fma(_193[34], f16vec4(_192[2].x), fma(_193[30], f16vec4(_192[1].w), fma(_193[26], f16vec4(_192[1].z), fma(_193[22], f16vec4(_192[1].y), fma(_193[18], f16vec4(_192[1].x), fma(_193[14], f16vec4(_192[0].w), fma(_193[10], f16vec4(_192[0].z), fma(_193[6], f16vec4(_192[0].y), fma(_193[2], f16vec4(_192[0].x), _194[2]))))))))))))));
    f16vec4 _659 = fma(_193[110], f16vec4(_192[6].w), fma(_193[106], f16vec4(_192[6].z), fma(_193[102], f16vec4(_192[6].y), fma(_193[98], f16vec4(_192[6].x), fma(_193[94], f16vec4(_192[5].w), fma(_193[90], f16vec4(_192[5].z), fma(_193[86], f16vec4(_192[5].y), fma(_193[82], f16vec4(_192[5].x), fma(_193[78], f16vec4(_192[4].w), fma(_193[74], f16vec4(_192[4].z), fma(_193[70], f16vec4(_192[4].y), fma(_193[66], f16vec4(_192[4].x), fma(_193[62], f16vec4(_192[3].w), fma(_193[58], f16vec4(_192[3].z), _589))))))))))))));
    f16vec4 _750 = fma(_193[55], f16vec4(_192[3].y), fma(_193[51], f16vec4(_192[3].x), fma(_193[47], f16vec4(_192[2].w), fma(_193[43], f16vec4(_192[2].z), fma(_193[39], f16vec4(_192[2].y), fma(_193[35], f16vec4(_192[2].x), fma(_193[31], f16vec4(_192[1].w), fma(_193[27], f16vec4(_192[1].z), fma(_193[23], f16vec4(_192[1].y), fma(_193[19], f16vec4(_192[1].x), fma(_193[15], f16vec4(_192[0].w), fma(_193[11], f16vec4(_192[0].z), fma(_193[7], f16vec4(_192[0].y), fma(_193[3], f16vec4(_192[0].x), _194[3]))))))))))))));
    f16vec4 _820 = fma(_193[111], f16vec4(_192[6].w), fma(_193[107], f16vec4(_192[6].z), fma(_193[103], f16vec4(_192[6].y), fma(_193[99], f16vec4(_192[6].x), fma(_193[95], f16vec4(_192[5].w), fma(_193[91], f16vec4(_192[5].z), fma(_193[87], f16vec4(_192[5].y), fma(_193[83], f16vec4(_192[5].x), fma(_193[79], f16vec4(_192[4].w), fma(_193[75], f16vec4(_192[4].z), fma(_193[71], f16vec4(_192[4].y), fma(_193[67], f16vec4(_192[4].x), fma(_193[63], f16vec4(_192[3].w), fma(_193[59], f16vec4(_192[3].z), _750))))))))))))));
    return f16vec4[](fma(_193[124], f16vec4(_192[7].w), fma(_193[120], f16vec4(_192[7].z), fma(_193[116], f16vec4(_192[7].y), fma(_193[112], f16vec4(_192[7].x), _337)))), fma(_193[125], f16vec4(_192[7].w), fma(_193[121], f16vec4(_192[7].z), fma(_193[117], f16vec4(_192[7].y), fma(_193[113], f16vec4(_192[7].x), _498)))), fma(_193[126], f16vec4(_192[7].w), fma(_193[122], f16vec4(_192[7].z), fma(_193[118], f16vec4(_192[7].y), fma(_193[114], f16vec4(_192[7].x), _659)))), fma(_193[127], f16vec4(_192[7].w), fma(_193[123], f16vec4(_192[7].z), fma(_193[119], f16vec4(_192[7].y), fma(_193[115], f16vec4(_192[7].x), _820)))));
}

void _843(uint _844, f16vec4 _845)
{
    Y.data[_844] = _845.x;
    Y.data[_844 + 1u] = _845.y;
    Y.data[_844 + 2u] = _845.z;
    Y.data[_844 + 3u] = _845.w;
}

void main()
{
    uint _103 = 0u;
    f16vec4 _102[8];
    uint _108;
    for (;;)
    {
        _108 = _103;
        if (_108 < 32u)
        {
            _102[_108 / 4u] = _79(0u + _108);
            _103 = _108 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _21[8] = _102;
    f16vec4 tempArg[8] = _21;
    f16vec4 x[8] = _21;
    uint _135 = 0u;
    f16vec4 _134[128];
    uint _140;
    for (;;)
    {
        _140 = _135;
        if (_140 < 512u)
        {
            _134[_140 / 4u] = _116(((uint(0) + (_140 / 16u)) * uint(16)) + (uint(0) + (_140 % 16u)));
            _135 = _140 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[128] = _134;
    f16vec4 tempArg_1[128] = _39;
    f16vec4 w[128] = _39;
    uint _177 = 0u;
    f16vec4 _176[4];
    uint _182;
    for (;;)
    {
        _182 = _177;
        if (_182 < 16u)
        {
            _176[_182 / 4u] = _159(0u + _182);
            _177 = _182 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _51[4] = _176;
    f16vec4 tempArg_2[4] = _51;
    f16vec4 bias[4] = _51;
    f16vec4 _58[4] = _191(_21, _39, _51);
    f16vec4 tempArg_3[4] = _58;
    f16vec4 y[4] = _58;
    f16vec4 _859[4] = _58;
    uint _860 = 0u;
    uint _865;
    for (;;)
    {
        _865 = _860;
        if (_865 < 16u)
        {
            _843(0u + _865, _859[_865 / 4u]);
            _860 = _865 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

