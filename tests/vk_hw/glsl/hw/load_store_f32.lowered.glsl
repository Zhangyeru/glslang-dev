#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec4 _49(uint _50)
{
    return vec4(A.data[_50], A.data[_50 + 1u], A.data[_50 + 2u], A.data[_50 + 3u]);
}

void _101(uint _102, vec4 _103)
{
    D.data[_102] = _103.x;
    D.data[_102 + 1u] = _103.y;
    D.data[_102 + 2u] = _103.z;
    D.data[_102 + 3u] = _103.w;
}

void main()
{
    uint _76 = 0u;
    vec4 _75[16];
    uint _81;
    for (;;)
    {
        _81 = _76;
        if (_81 < 64u)
        {
            _75[_81 / 4u] = _49(((uint(0) + (_81 / 8u)) * uint(8)) + (uint(0) + (_81 % 8u)));
            _76 = _81 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _24[16] = _75;
    vec4 tempArg[16] = _24;
    vec4 value[16] = _24;
    vec4 _117[16] = _24;
    uint _118 = 0u;
    uint _123;
    for (;;)
    {
        _123 = _118;
        if (_123 < 64u)
        {
            _101(((uint(0) + (_123 / 8u)) * uint(8)) + (uint(0) + (_123 % 8u)), _117[_123 / 4u]);
            _118 = _123 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

