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

vec2 _49(uint _50)
{
    return vec2(A.data[_50], A.data[_50 + 1u]);
}

void _94(uint _95, vec2 _96)
{
    D.data[_95] = _96.x;
    D.data[_95 + 1u] = _96.y;
}

void main()
{
    uint _68 = 0u;
    vec2 _67[24];
    uint _73;
    for (;;)
    {
        _73 = _68;
        if (_73 < 48u)
        {
            _67[_73 / 2u] = _49(((uint(0) + (_73 / 6u)) * uint(6)) + (uint(0) + (_73 % 6u)));
            _68 = _73 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _23[24] = _67;
    vec2 tempArg[24] = _23;
    vec2 value[24] = _23;
    vec2 _104[24] = _23;
    uint _105 = 0u;
    uint _110;
    for (;;)
    {
        _110 = _105;
        if (_110 < 48u)
        {
            _94(((uint(0) + (_110 / 6u)) * uint(6)) + (uint(0) + (_110 % 6u)), _104[_110 / 2u]);
            _105 = _110 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

