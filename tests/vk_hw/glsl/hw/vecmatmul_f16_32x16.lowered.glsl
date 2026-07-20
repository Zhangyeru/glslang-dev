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

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

f16vec4 _72(uint _73)
{
    return f16vec4(X.data[_73], X.data[_73 + 1u], X.data[_73 + 2u], X.data[_73 + 3u]);
}

f16vec4 _109(uint _110)
{
    return f16vec4(W.data[_110], W.data[_110 + 1u], W.data[_110 + 2u], W.data[_110 + 3u]);
}

f16vec4[4] _153(f16vec4 _154[8], f16vec4 _155[128])
{
    f16vec4 _227 = fma(_155[52], f16vec4(_154[3].y), fma(_155[48], f16vec4(_154[3].x), fma(_155[44], f16vec4(_154[2].w), fma(_155[40], f16vec4(_154[2].z), fma(_155[36], f16vec4(_154[2].y), fma(_155[32], f16vec4(_154[2].x), fma(_155[28], f16vec4(_154[1].w), fma(_155[24], f16vec4(_154[1].z), fma(_155[20], f16vec4(_154[1].y), fma(_155[16], f16vec4(_154[1].x), fma(_155[12], f16vec4(_154[0].w), fma(_155[8], f16vec4(_154[0].z), fma(_155[4], f16vec4(_154[0].y), fma(_155[0], f16vec4(_154[0].x), f16vec4(float16_t(0.0))))))))))))))));
    f16vec4 _297 = fma(_155[108], f16vec4(_154[6].w), fma(_155[104], f16vec4(_154[6].z), fma(_155[100], f16vec4(_154[6].y), fma(_155[96], f16vec4(_154[6].x), fma(_155[92], f16vec4(_154[5].w), fma(_155[88], f16vec4(_154[5].z), fma(_155[84], f16vec4(_154[5].y), fma(_155[80], f16vec4(_154[5].x), fma(_155[76], f16vec4(_154[4].w), fma(_155[72], f16vec4(_154[4].z), fma(_155[68], f16vec4(_154[4].y), fma(_155[64], f16vec4(_154[4].x), fma(_155[60], f16vec4(_154[3].w), fma(_155[56], f16vec4(_154[3].z), _227))))))))))))));
    f16vec4 _387 = fma(_155[53], f16vec4(_154[3].y), fma(_155[49], f16vec4(_154[3].x), fma(_155[45], f16vec4(_154[2].w), fma(_155[41], f16vec4(_154[2].z), fma(_155[37], f16vec4(_154[2].y), fma(_155[33], f16vec4(_154[2].x), fma(_155[29], f16vec4(_154[1].w), fma(_155[25], f16vec4(_154[1].z), fma(_155[21], f16vec4(_154[1].y), fma(_155[17], f16vec4(_154[1].x), fma(_155[13], f16vec4(_154[0].w), fma(_155[9], f16vec4(_154[0].z), fma(_155[5], f16vec4(_154[0].y), fma(_155[1], f16vec4(_154[0].x), f16vec4(float16_t(0.0))))))))))))))));
    f16vec4 _457 = fma(_155[109], f16vec4(_154[6].w), fma(_155[105], f16vec4(_154[6].z), fma(_155[101], f16vec4(_154[6].y), fma(_155[97], f16vec4(_154[6].x), fma(_155[93], f16vec4(_154[5].w), fma(_155[89], f16vec4(_154[5].z), fma(_155[85], f16vec4(_154[5].y), fma(_155[81], f16vec4(_154[5].x), fma(_155[77], f16vec4(_154[4].w), fma(_155[73], f16vec4(_154[4].z), fma(_155[69], f16vec4(_154[4].y), fma(_155[65], f16vec4(_154[4].x), fma(_155[61], f16vec4(_154[3].w), fma(_155[57], f16vec4(_154[3].z), _387))))))))))))));
    f16vec4 _547 = fma(_155[54], f16vec4(_154[3].y), fma(_155[50], f16vec4(_154[3].x), fma(_155[46], f16vec4(_154[2].w), fma(_155[42], f16vec4(_154[2].z), fma(_155[38], f16vec4(_154[2].y), fma(_155[34], f16vec4(_154[2].x), fma(_155[30], f16vec4(_154[1].w), fma(_155[26], f16vec4(_154[1].z), fma(_155[22], f16vec4(_154[1].y), fma(_155[18], f16vec4(_154[1].x), fma(_155[14], f16vec4(_154[0].w), fma(_155[10], f16vec4(_154[0].z), fma(_155[6], f16vec4(_154[0].y), fma(_155[2], f16vec4(_154[0].x), f16vec4(float16_t(0.0))))))))))))))));
    f16vec4 _617 = fma(_155[110], f16vec4(_154[6].w), fma(_155[106], f16vec4(_154[6].z), fma(_155[102], f16vec4(_154[6].y), fma(_155[98], f16vec4(_154[6].x), fma(_155[94], f16vec4(_154[5].w), fma(_155[90], f16vec4(_154[5].z), fma(_155[86], f16vec4(_154[5].y), fma(_155[82], f16vec4(_154[5].x), fma(_155[78], f16vec4(_154[4].w), fma(_155[74], f16vec4(_154[4].z), fma(_155[70], f16vec4(_154[4].y), fma(_155[66], f16vec4(_154[4].x), fma(_155[62], f16vec4(_154[3].w), fma(_155[58], f16vec4(_154[3].z), _547))))))))))))));
    f16vec4 _707 = fma(_155[55], f16vec4(_154[3].y), fma(_155[51], f16vec4(_154[3].x), fma(_155[47], f16vec4(_154[2].w), fma(_155[43], f16vec4(_154[2].z), fma(_155[39], f16vec4(_154[2].y), fma(_155[35], f16vec4(_154[2].x), fma(_155[31], f16vec4(_154[1].w), fma(_155[27], f16vec4(_154[1].z), fma(_155[23], f16vec4(_154[1].y), fma(_155[19], f16vec4(_154[1].x), fma(_155[15], f16vec4(_154[0].w), fma(_155[11], f16vec4(_154[0].z), fma(_155[7], f16vec4(_154[0].y), fma(_155[3], f16vec4(_154[0].x), f16vec4(float16_t(0.0))))))))))))))));
    f16vec4 _777 = fma(_155[111], f16vec4(_154[6].w), fma(_155[107], f16vec4(_154[6].z), fma(_155[103], f16vec4(_154[6].y), fma(_155[99], f16vec4(_154[6].x), fma(_155[95], f16vec4(_154[5].w), fma(_155[91], f16vec4(_154[5].z), fma(_155[87], f16vec4(_154[5].y), fma(_155[83], f16vec4(_154[5].x), fma(_155[79], f16vec4(_154[4].w), fma(_155[75], f16vec4(_154[4].z), fma(_155[71], f16vec4(_154[4].y), fma(_155[67], f16vec4(_154[4].x), fma(_155[63], f16vec4(_154[3].w), fma(_155[59], f16vec4(_154[3].z), _707))))))))))))));
    return f16vec4[](fma(_155[124], f16vec4(_154[7].w), fma(_155[120], f16vec4(_154[7].z), fma(_155[116], f16vec4(_154[7].y), fma(_155[112], f16vec4(_154[7].x), _297)))), fma(_155[125], f16vec4(_154[7].w), fma(_155[121], f16vec4(_154[7].z), fma(_155[117], f16vec4(_154[7].y), fma(_155[113], f16vec4(_154[7].x), _457)))), fma(_155[126], f16vec4(_154[7].w), fma(_155[122], f16vec4(_154[7].z), fma(_155[118], f16vec4(_154[7].y), fma(_155[114], f16vec4(_154[7].x), _617)))), fma(_155[127], f16vec4(_154[7].w), fma(_155[123], f16vec4(_154[7].z), fma(_155[119], f16vec4(_154[7].y), fma(_155[115], f16vec4(_154[7].x), _777)))));
}

void _800(uint _801, f16vec4 _802)
{
    Y.data[_801] = _802.x;
    Y.data[_801 + 1u] = _802.y;
    Y.data[_801 + 2u] = _802.z;
    Y.data[_801 + 3u] = _802.w;
}

void main()
{
    uint _96 = 0u;
    f16vec4 _95[8];
    uint _101;
    for (;;)
    {
        _101 = _96;
        if (_101 < 32u)
        {
            _95[_101 / 4u] = _72(0u + _101);
            _96 = _101 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _21[8] = _95;
    f16vec4 tempArg[8] = _21;
    f16vec4 x[8] = _21;
    uint _128 = 0u;
    f16vec4 _127[128];
    uint _133;
    for (;;)
    {
        _133 = _128;
        if (_133 < 512u)
        {
            _127[_133 / 4u] = _109(((uint(0) + (_133 / 16u)) * uint(16)) + (uint(0) + (_133 % 16u)));
            _128 = _133 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[128] = _127;
    f16vec4 tempArg_1[128] = _39;
    f16vec4 w[128] = _39;
    f16vec4 _47[4] = _153(_21, _39);
    f16vec4 tempArg_2[4] = _47;
    f16vec4 y[4] = _47;
    f16vec4 _817[4] = _47;
    uint _818 = 0u;
    uint _823;
    for (;;)
    {
        _823 = _818;
        if (_823 < 16u)
        {
            _800(0u + _823, _817[_823 / 4u]);
            _818 = _823 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

