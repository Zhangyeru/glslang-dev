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

f16vec4 _108(uint _109)
{
    return f16vec4(W.data[_109], W.data[_109 + 1u], W.data[_109 + 2u], W.data[_109 + 3u]);
}

f16vec4[2] _152(f16vec4 _153[4], f16vec4 _154[32])
{
    f16vec4 _226 = fma(_154[26], f16vec4(_153[3].y), fma(_154[24], f16vec4(_153[3].x), fma(_154[22], f16vec4(_153[2].w), fma(_154[20], f16vec4(_153[2].z), fma(_154[18], f16vec4(_153[2].y), fma(_154[16], f16vec4(_153[2].x), fma(_154[14], f16vec4(_153[1].w), fma(_154[12], f16vec4(_153[1].z), fma(_154[10], f16vec4(_153[1].y), fma(_154[8], f16vec4(_153[1].x), fma(_154[6], f16vec4(_153[0].w), fma(_154[4], f16vec4(_153[0].z), fma(_154[2], f16vec4(_153[0].y), fma(_154[0], f16vec4(_153[0].x), f16vec4(float16_t(0.0))))))))))))))));
    f16vec4 _306 = fma(_154[27], f16vec4(_153[3].y), fma(_154[25], f16vec4(_153[3].x), fma(_154[23], f16vec4(_153[2].w), fma(_154[21], f16vec4(_153[2].z), fma(_154[19], f16vec4(_153[2].y), fma(_154[17], f16vec4(_153[2].x), fma(_154[15], f16vec4(_153[1].w), fma(_154[13], f16vec4(_153[1].z), fma(_154[11], f16vec4(_153[1].y), fma(_154[9], f16vec4(_153[1].x), fma(_154[7], f16vec4(_153[0].w), fma(_154[5], f16vec4(_153[0].z), fma(_154[3], f16vec4(_153[0].y), fma(_154[1], f16vec4(_153[0].x), f16vec4(float16_t(0.0))))))))))))))));
    return f16vec4[](fma(_154[30], f16vec4(_153[3].w), fma(_154[28], f16vec4(_153[3].z), _226)), fma(_154[31], f16vec4(_153[3].w), fma(_154[29], f16vec4(_153[3].z), _306)));
}

void _319(uint _320, f16vec4 _321)
{
    Y.data[_320] = _321.x;
    Y.data[_320 + 1u] = _321.y;
    Y.data[_320 + 2u] = _321.z;
    Y.data[_320 + 3u] = _321.w;
}

void main()
{
    uint _95 = 0u;
    f16vec4 _94[4];
    uint _100;
    for (;;)
    {
        _100 = _95;
        if (_100 < 16u)
        {
            _94[_100 / 4u] = _72(0u + _100);
            _95 = _100 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _21[4] = _94;
    f16vec4 tempArg[4] = _21;
    f16vec4 x[4] = _21;
    uint _127 = 0u;
    f16vec4 _126[32];
    uint _132;
    for (;;)
    {
        _132 = _127;
        if (_132 < 128u)
        {
            _126[_132 / 4u] = _108(((uint(0) + (_132 / 8u)) * uint(8)) + (uint(0) + (_132 % 8u)));
            _127 = _132 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[32] = _126;
    f16vec4 tempArg_1[32] = _39;
    f16vec4 w[32] = _39;
    f16vec4 _47[2] = _152(_21, _39);
    f16vec4 tempArg_2[2] = _47;
    f16vec4 y[2] = _47;
    f16vec4 _336[2] = _47;
    uint _337 = 0u;
    uint _342;
    for (;;)
    {
        _342 = _337;
        if (_342 < 8u)
        {
            _319(0u + _342, _336[_342 / 4u]);
            _337 = _342 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

