#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec4 _66(uint _67)
{
    return vec4(A.data[_67], A.data[_67 + 1u], A.data[_67 + 2u], A.data[_67 + 3u]);
}

vec4 _116(uint _117)
{
    return vec4(C.data[_117], C.data[_117 + 1u], C.data[_117 + 2u], C.data[_117 + 3u]);
}

vec4[4] _158(vec4 _159[4], vec4 _160[4], vec4 _161[4])
{
    return vec4[](fma(vec4(_159[0].w), _160[3], fma(vec4(_159[0].z), _160[2], fma(vec4(_159[0].y), _160[1], fma(vec4(_159[0].x), _160[0], _161[0])))), fma(vec4(_159[1].w), _160[3], fma(vec4(_159[1].z), _160[2], fma(vec4(_159[1].y), _160[1], fma(vec4(_159[1].x), _160[0], _161[1])))), fma(vec4(_159[2].w), _160[3], fma(vec4(_159[2].z), _160[2], fma(vec4(_159[2].y), _160[1], fma(vec4(_159[2].x), _160[0], _161[2])))), fma(vec4(_159[3].w), _160[3], fma(vec4(_159[3].z), _160[2], fma(vec4(_159[3].y), _160[1], fma(vec4(_159[3].x), _160[0], _161[3])))));
}

void _249(uint _250, vec4 _251)
{
    D.data[_250] = _251.x;
    D.data[_250 + 1u] = _251.y;
    D.data[_250 + 2u] = _251.z;
    D.data[_250 + 3u] = _251.w;
}

void main()
{
    vec4 _15[4] = vec4[](vec4(0.5), vec4(0.5), vec4(0.5), vec4(0.5));
    vec4 b[4] = _15;
    uint _92 = 0u;
    vec4 _91[4];
    uint _97;
    for (;;)
    {
        _97 = _92;
        if (_97 < 16u)
        {
            _91[_97 / 4u] = _66(((uint(0) + (_97 / 4u)) * uint(4)) + (uint(0) + (_97 % 4u)));
            _92 = _97 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _30[4] = _91;
    vec4 tempArg[4] = _30;
    vec4 a[4] = _30;
    uint _133 = 0u;
    vec4 _132[4];
    uint _138;
    for (;;)
    {
        _138 = _133;
        if (_138 < 16u)
        {
            _132[_138 / 4u] = _116(((uint(0) + (_138 / 4u)) * uint(4)) + (uint(0) + (_138 % 4u)));
            _133 = _138 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _42[4] = _132;
    vec4 tempArg_1[4] = _42;
    vec4 c[4] = _42;
    vec4 _49[4] = _158(_30, _15, _42);
    vec4 tempArg_2[4] = _49;
    vec4 d[4] = _49;
    vec4 _265[4] = _49;
    uint _266 = 0u;
    uint _271;
    for (;;)
    {
        _271 = _266;
        if (_271 < 16u)
        {
            _249(((uint(0) + (_271 / 4u)) * uint(4)) + (uint(0) + (_271 % 4u)), _265[_271 / 4u]);
            _266 = _271 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

