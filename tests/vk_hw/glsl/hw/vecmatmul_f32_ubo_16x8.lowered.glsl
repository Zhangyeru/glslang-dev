#version 450
#extension GL_EXT_scalar_block_layout : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, scalar) uniform InputW
{
    float data[128];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec4 _73(uint _74)
{
    return vec4(X.data[_74], X.data[_74 + 1u], X.data[_74 + 2u], X.data[_74 + 3u]);
}

vec4 _109(uint _110)
{
    return vec4(W.data[_110], W.data[_110 + 1u], W.data[_110 + 2u], W.data[_110 + 3u]);
}

vec4[2] _153(vec4 _154[4], vec4 _155[32])
{
    vec4 _227 = fma(_155[26], vec4(_154[3].y), fma(_155[24], vec4(_154[3].x), fma(_155[22], vec4(_154[2].w), fma(_155[20], vec4(_154[2].z), fma(_155[18], vec4(_154[2].y), fma(_155[16], vec4(_154[2].x), fma(_155[14], vec4(_154[1].w), fma(_155[12], vec4(_154[1].z), fma(_155[10], vec4(_154[1].y), fma(_155[8], vec4(_154[1].x), fma(_155[6], vec4(_154[0].w), fma(_155[4], vec4(_154[0].z), fma(_155[2], vec4(_154[0].y), fma(_155[0], vec4(_154[0].x), vec4(0.0)))))))))))))));
    vec4 _307 = fma(_155[27], vec4(_154[3].y), fma(_155[25], vec4(_154[3].x), fma(_155[23], vec4(_154[2].w), fma(_155[21], vec4(_154[2].z), fma(_155[19], vec4(_154[2].y), fma(_155[17], vec4(_154[2].x), fma(_155[15], vec4(_154[1].w), fma(_155[13], vec4(_154[1].z), fma(_155[11], vec4(_154[1].y), fma(_155[9], vec4(_154[1].x), fma(_155[7], vec4(_154[0].w), fma(_155[5], vec4(_154[0].z), fma(_155[3], vec4(_154[0].y), fma(_155[1], vec4(_154[0].x), vec4(0.0)))))))))))))));
    return vec4[](fma(_155[30], vec4(_154[3].w), fma(_155[28], vec4(_154[3].z), _227)), fma(_155[31], vec4(_154[3].w), fma(_155[29], vec4(_154[3].z), _307)));
}

void _320(uint _321, vec4 _322)
{
    Y.data[_321] = _322.x;
    Y.data[_321 + 1u] = _322.y;
    Y.data[_321 + 2u] = _322.z;
    Y.data[_321 + 3u] = _322.w;
}

void main()
{
    uint _96 = 0u;
    vec4 _95[4];
    uint _101;
    for (;;)
    {
        _101 = _96;
        if (_101 < 16u)
        {
            _95[_101 / 4u] = _73(0u + _101);
            _96 = _101 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _21[4] = _95;
    vec4 tempArg[4] = _21;
    vec4 x[4] = _21;
    uint _128 = 0u;
    vec4 _127[32];
    uint _133;
    for (;;)
    {
        _133 = _128;
        if (_133 < 128u)
        {
            _127[_133 / 4u] = _109(((uint(0) + (_133 / 8u)) * uint(8)) + (uint(0) + (_133 % 8u)));
            _128 = _133 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _40[32] = _127;
    vec4 tempArg_1[32] = _40;
    vec4 w[32] = _40;
    vec4 _48[2] = _153(_21, _40);
    vec4 tempArg_2[2] = _48;
    vec4 y[2] = _48;
    vec4 _337[2] = _48;
    uint _338 = 0u;
    uint _343;
    for (;;)
    {
        _343 = _338;
        if (_343 < 8u)
        {
            _320(0u + _343, _337[_343 / 4u]);
            _338 = _343 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

