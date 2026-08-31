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

vec2 privateValue[504];

vec2 _56(uint _57)
{
    return vec2(A.data[_57], A.data[_57 + 1u]);
}

void _100(uint _101, vec2 _102)
{
    D.data[_101] = _102.x;
    D.data[_101 + 1u] = _102.y;
}

void main()
{
    uint _75 = 0u;
    vec2 _74[504];
    uint _80;
    for (;;)
    {
        _80 = _75;
        if (_80 < 1008u)
        {
            _74[_80 / 2u] = _56(((uint(0) + (_80 / 36u)) * uint(36)) + (uint(0) + (_80 % 36u)));
            _75 = _80 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _26[504] = _74;
    vec2 tempArg[504] = _26;
    vec2 inputValue[504] = _26;
    privateValue = _26;
    vec2 result[504] = privateValue;
    vec2 _110[504] = privateValue;
    uint _111 = 0u;
    uint _116;
    for (;;)
    {
        _116 = _111;
        if (_116 < 1008u)
        {
            _100(((uint(0) + (_116 / 36u)) * uint(36)) + (uint(0) + (_116 % 36u)), _110[_116 / 2u]);
            _111 = _116 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

