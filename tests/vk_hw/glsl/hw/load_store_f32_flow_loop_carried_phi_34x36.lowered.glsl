#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec2 _89(uint _90)
{
    return vec2(A.data[_90], A.data[_90 + 1u]);
}

void _129(uint _130, vec2 _131)
{
    D.data[_130] = _131.x;
    D.data[_130 + 1u] = _131.y;
}

void main()
{
    uint _104 = 0u;
    vec2 _103[612];
    uint _109;
    for (;;)
    {
        _109 = _104;
        if (_109 < 1224u)
        {
            _103[_109 / 2u] = _89(((uint(0) + (_109 / 36u)) * uint(36)) + (uint(0) + (_109 % 36u)));
            _104 = _109 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _26[612] = _103;
    vec2 tempArg[612] = _26;
    vec2 value[612] = _26;
    vec2 current[612] = value;
    uint iterationCount = (floatBitsToUint(B.data[0]) & 3u) + 1u;
    vec2 _62[612];
    for (uint iteration = 0u; iteration < iterationCount; iteration++)
    {
        bool keepCurrent = (iteration & 1u) == 0u;
        if (keepCurrent)
        {
            _62 = current;
        }
        else
        {
            _62 = value;
        }
        current = _62;
    }
    vec2 _139[612] = current;
    uint _140 = 0u;
    uint _145;
    for (;;)
    {
        _145 = _140;
        if (_145 < 1224u)
        {
            _129(((uint(0) + (_145 / 36u)) * uint(36)) + (uint(0) + (_145 % 36u)), _139[_145 / 2u]);
            _140 = _145 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

