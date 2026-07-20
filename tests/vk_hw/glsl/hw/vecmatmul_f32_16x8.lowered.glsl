#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec4 _72(uint _73)
{
    return vec4(X.data[_73], X.data[_73 + 1u], X.data[_73 + 2u], X.data[_73 + 3u]);
}

vec4 _108(uint _109)
{
    return vec4(W.data[_109], W.data[_109 + 1u], W.data[_109 + 2u], W.data[_109 + 3u]);
}

vec4[2] _152(vec4 _153[4], vec4 _154[32])
{
    vec4 _226 = fma(_154[26], vec4(_153[3].y), fma(_154[24], vec4(_153[3].x), fma(_154[22], vec4(_153[2].w), fma(_154[20], vec4(_153[2].z), fma(_154[18], vec4(_153[2].y), fma(_154[16], vec4(_153[2].x), fma(_154[14], vec4(_153[1].w), fma(_154[12], vec4(_153[1].z), fma(_154[10], vec4(_153[1].y), fma(_154[8], vec4(_153[1].x), fma(_154[6], vec4(_153[0].w), fma(_154[4], vec4(_153[0].z), fma(_154[2], vec4(_153[0].y), fma(_154[0], vec4(_153[0].x), vec4(0.0)))))))))))))));
    vec4 _306 = fma(_154[27], vec4(_153[3].y), fma(_154[25], vec4(_153[3].x), fma(_154[23], vec4(_153[2].w), fma(_154[21], vec4(_153[2].z), fma(_154[19], vec4(_153[2].y), fma(_154[17], vec4(_153[2].x), fma(_154[15], vec4(_153[1].w), fma(_154[13], vec4(_153[1].z), fma(_154[11], vec4(_153[1].y), fma(_154[9], vec4(_153[1].x), fma(_154[7], vec4(_153[0].w), fma(_154[5], vec4(_153[0].z), fma(_154[3], vec4(_153[0].y), fma(_154[1], vec4(_153[0].x), vec4(0.0)))))))))))))));
    return vec4[](fma(_154[30], vec4(_153[3].w), fma(_154[28], vec4(_153[3].z), _226)), fma(_154[31], vec4(_153[3].w), fma(_154[29], vec4(_153[3].z), _306)));
}

void _319(uint _320, vec4 _321)
{
    Y.data[_320] = _321.x;
    Y.data[_320 + 1u] = _321.y;
    Y.data[_320 + 2u] = _321.z;
    Y.data[_320 + 3u] = _321.w;
}

void main()
{
    uint _95 = 0u;
    vec4 _94[4];
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
    vec4 _21[4] = _94;
    vec4 tempArg[4] = _21;
    vec4 x[4] = _21;
    uint _127 = 0u;
    vec4 _126[32];
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
    vec4 _39[32] = _126;
    vec4 tempArg_1[32] = _39;
    vec4 w[32] = _39;
    vec4 _47[2] = _152(_21, _39);
    vec4 tempArg_2[2] = _47;
    vec4 y[2] = _47;
    vec4 _336[2] = _47;
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

