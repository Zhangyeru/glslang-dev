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

f16vec4 _105(uint _106)
{
    return f16vec4(X.data[_106], X.data[_106 + 1u], X.data[_106 + 2u], X.data[_106 + 3u]);
}

f16vec4 _142(uint _143)
{
    return f16vec4(W.data[_143], W.data[_143 + 1u], W.data[_143 + 2u], W.data[_143 + 3u]);
}

f16vec4 _185(uint _186)
{
    return f16vec4(Bias.data[_186], Bias.data[_186 + 1u], Bias.data[_186 + 2u], Bias.data[_186 + 3u]);
}

f16vec4[4] _307(f16vec4 _308[8], f16vec4 _309[128], f16vec4 _310[4])
{
    f16vec4 _383 = fma(_309[52], f16vec4(_308[3].y), fma(_309[48], f16vec4(_308[3].x), fma(_309[44], f16vec4(_308[2].w), fma(_309[40], f16vec4(_308[2].z), fma(_309[36], f16vec4(_308[2].y), fma(_309[32], f16vec4(_308[2].x), fma(_309[28], f16vec4(_308[1].w), fma(_309[24], f16vec4(_308[1].z), fma(_309[20], f16vec4(_308[1].y), fma(_309[16], f16vec4(_308[1].x), fma(_309[12], f16vec4(_308[0].w), fma(_309[8], f16vec4(_308[0].z), fma(_309[4], f16vec4(_308[0].y), fma(_309[0], f16vec4(_308[0].x), _310[0]))))))))))))));
    f16vec4 _453 = fma(_309[108], f16vec4(_308[6].w), fma(_309[104], f16vec4(_308[6].z), fma(_309[100], f16vec4(_308[6].y), fma(_309[96], f16vec4(_308[6].x), fma(_309[92], f16vec4(_308[5].w), fma(_309[88], f16vec4(_308[5].z), fma(_309[84], f16vec4(_308[5].y), fma(_309[80], f16vec4(_308[5].x), fma(_309[76], f16vec4(_308[4].w), fma(_309[72], f16vec4(_308[4].z), fma(_309[68], f16vec4(_308[4].y), fma(_309[64], f16vec4(_308[4].x), fma(_309[60], f16vec4(_308[3].w), fma(_309[56], f16vec4(_308[3].z), _383))))))))))))));
    f16vec4 _544 = fma(_309[53], f16vec4(_308[3].y), fma(_309[49], f16vec4(_308[3].x), fma(_309[45], f16vec4(_308[2].w), fma(_309[41], f16vec4(_308[2].z), fma(_309[37], f16vec4(_308[2].y), fma(_309[33], f16vec4(_308[2].x), fma(_309[29], f16vec4(_308[1].w), fma(_309[25], f16vec4(_308[1].z), fma(_309[21], f16vec4(_308[1].y), fma(_309[17], f16vec4(_308[1].x), fma(_309[13], f16vec4(_308[0].w), fma(_309[9], f16vec4(_308[0].z), fma(_309[5], f16vec4(_308[0].y), fma(_309[1], f16vec4(_308[0].x), _310[1]))))))))))))));
    f16vec4 _614 = fma(_309[109], f16vec4(_308[6].w), fma(_309[105], f16vec4(_308[6].z), fma(_309[101], f16vec4(_308[6].y), fma(_309[97], f16vec4(_308[6].x), fma(_309[93], f16vec4(_308[5].w), fma(_309[89], f16vec4(_308[5].z), fma(_309[85], f16vec4(_308[5].y), fma(_309[81], f16vec4(_308[5].x), fma(_309[77], f16vec4(_308[4].w), fma(_309[73], f16vec4(_308[4].z), fma(_309[69], f16vec4(_308[4].y), fma(_309[65], f16vec4(_308[4].x), fma(_309[61], f16vec4(_308[3].w), fma(_309[57], f16vec4(_308[3].z), _544))))))))))))));
    f16vec4 _705 = fma(_309[54], f16vec4(_308[3].y), fma(_309[50], f16vec4(_308[3].x), fma(_309[46], f16vec4(_308[2].w), fma(_309[42], f16vec4(_308[2].z), fma(_309[38], f16vec4(_308[2].y), fma(_309[34], f16vec4(_308[2].x), fma(_309[30], f16vec4(_308[1].w), fma(_309[26], f16vec4(_308[1].z), fma(_309[22], f16vec4(_308[1].y), fma(_309[18], f16vec4(_308[1].x), fma(_309[14], f16vec4(_308[0].w), fma(_309[10], f16vec4(_308[0].z), fma(_309[6], f16vec4(_308[0].y), fma(_309[2], f16vec4(_308[0].x), _310[2]))))))))))))));
    f16vec4 _775 = fma(_309[110], f16vec4(_308[6].w), fma(_309[106], f16vec4(_308[6].z), fma(_309[102], f16vec4(_308[6].y), fma(_309[98], f16vec4(_308[6].x), fma(_309[94], f16vec4(_308[5].w), fma(_309[90], f16vec4(_308[5].z), fma(_309[86], f16vec4(_308[5].y), fma(_309[82], f16vec4(_308[5].x), fma(_309[78], f16vec4(_308[4].w), fma(_309[74], f16vec4(_308[4].z), fma(_309[70], f16vec4(_308[4].y), fma(_309[66], f16vec4(_308[4].x), fma(_309[62], f16vec4(_308[3].w), fma(_309[58], f16vec4(_308[3].z), _705))))))))))))));
    f16vec4 _866 = fma(_309[55], f16vec4(_308[3].y), fma(_309[51], f16vec4(_308[3].x), fma(_309[47], f16vec4(_308[2].w), fma(_309[43], f16vec4(_308[2].z), fma(_309[39], f16vec4(_308[2].y), fma(_309[35], f16vec4(_308[2].x), fma(_309[31], f16vec4(_308[1].w), fma(_309[27], f16vec4(_308[1].z), fma(_309[23], f16vec4(_308[1].y), fma(_309[19], f16vec4(_308[1].x), fma(_309[15], f16vec4(_308[0].w), fma(_309[11], f16vec4(_308[0].z), fma(_309[7], f16vec4(_308[0].y), fma(_309[3], f16vec4(_308[0].x), _310[3]))))))))))))));
    f16vec4 _936 = fma(_309[111], f16vec4(_308[6].w), fma(_309[107], f16vec4(_308[6].z), fma(_309[103], f16vec4(_308[6].y), fma(_309[99], f16vec4(_308[6].x), fma(_309[95], f16vec4(_308[5].w), fma(_309[91], f16vec4(_308[5].z), fma(_309[87], f16vec4(_308[5].y), fma(_309[83], f16vec4(_308[5].x), fma(_309[79], f16vec4(_308[4].w), fma(_309[75], f16vec4(_308[4].z), fma(_309[71], f16vec4(_308[4].y), fma(_309[67], f16vec4(_308[4].x), fma(_309[63], f16vec4(_308[3].w), fma(_309[59], f16vec4(_308[3].z), _866))))))))))))));
    return f16vec4[](fma(_309[124], f16vec4(_308[7].w), fma(_309[120], f16vec4(_308[7].z), fma(_309[116], f16vec4(_308[7].y), fma(_309[112], f16vec4(_308[7].x), _453)))), fma(_309[125], f16vec4(_308[7].w), fma(_309[121], f16vec4(_308[7].z), fma(_309[117], f16vec4(_308[7].y), fma(_309[113], f16vec4(_308[7].x), _614)))), fma(_309[126], f16vec4(_308[7].w), fma(_309[122], f16vec4(_308[7].z), fma(_309[118], f16vec4(_308[7].y), fma(_309[114], f16vec4(_308[7].x), _775)))), fma(_309[127], f16vec4(_308[7].w), fma(_309[123], f16vec4(_308[7].z), fma(_309[119], f16vec4(_308[7].y), fma(_309[115], f16vec4(_308[7].x), _936)))));
}

void _959(uint _960, f16vec4 _961)
{
    Y.data[_960] = _961.x;
    Y.data[_960 + 1u] = _961.y;
    Y.data[_960 + 2u] = _961.z;
    Y.data[_960 + 3u] = _961.w;
}

void main()
{
    uint _129 = 0u;
    f16vec4 _128[8];
    uint _134;
    for (;;)
    {
        _134 = _129;
        if (_134 < 32u)
        {
            _128[_134 / 4u] = _105(0u + _134);
            _129 = _134 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _21[8] = _128;
    f16vec4 tempArg[8] = _21;
    f16vec4 x[8] = _21;
    uint _161 = 0u;
    f16vec4 _160[128];
    uint _166;
    for (;;)
    {
        _166 = _161;
        if (_166 < 512u)
        {
            _160[_166 / 4u] = _142(((uint(0) + (_166 / 16u)) * uint(16)) + (uint(0) + (_166 % 16u)));
            _161 = _166 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[128] = _160;
    f16vec4 tempArg_1[128] = _39;
    f16vec4 w[128] = _39;
    uint _203 = 0u;
    f16vec4 _202[4];
    uint _208;
    for (;;)
    {
        _208 = _203;
        if (_208 < 16u)
        {
            _202[_208 / 4u] = _185(0u + _208);
            _203 = _208 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _51[4] = _202;
    f16vec4 tempArg_2[4] = _51;
    f16vec4 bias[4] = _51;
    f16vec4 _221[8] = _21;
    uint _220 = 0u;
    vec4 _219[8];
    uint _226;
    for (;;)
    {
        _226 = _220;
        if (_226 < 8u)
        {
            _219[_226] = vec4(_221[_226]);
            _220 = _226 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 xf[8] = _219;
    vec4 _236[8] = _219;
    uint _235 = 0u;
    f16vec4 _234[8];
    uint _241;
    for (;;)
    {
        _241 = _235;
        if (_241 < 8u)
        {
            _234[_241] = f16vec4(_236[_241]);
            _235 = _241 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _234;
    f16vec4 _251[128] = _39;
    uint _250 = 0u;
    vec4 _249[128];
    uint _256;
    for (;;)
    {
        _256 = _250;
        if (_256 < 128u)
        {
            _249[_256] = vec4(_251[_256]);
            _250 = _256 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 wf[128] = _249;
    vec4 _265[128] = _249;
    uint _264 = 0u;
    f16vec4 _263[128];
    uint _270;
    for (;;)
    {
        _270 = _264;
        if (_270 < 128u)
        {
            _263[_270] = f16vec4(_265[_270]);
            _264 = _270 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    w = _263;
    f16vec4 _280[4] = _51;
    uint _279 = 0u;
    vec4 _278[4];
    uint _285;
    for (;;)
    {
        _285 = _279;
        if (_285 < 4u)
        {
            _278[_285] = vec4(_280[_285]);
            _279 = _285 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 biasf[4] = _278;
    vec4 _294[4] = _278;
    uint _293 = 0u;
    f16vec4 _292[4];
    uint _299;
    for (;;)
    {
        _299 = _293;
        if (_299 < 4u)
        {
            _292[_299] = f16vec4(_294[_299]);
            _293 = _299 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _292;
    f16vec4 _80[4] = _307(_234, _263, _292);
    f16vec4 tempArg_3[4] = _80;
    f16vec4 y[4] = _80;
    f16vec4 _975[4] = _80;
    uint _976 = 0u;
    uint _981;
    for (;;)
    {
        _981 = _976;
        if (_981 < 16u)
        {
            _959(0u + _981, _975[_981 / 4u]);
            _976 = _981 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

