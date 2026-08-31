#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct MatrixLeaf
{
    vec2 value[192];
};

struct MatrixShelf
{
    MatrixLeaf leaves[2];
};

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

vec2 _63(uint _64)
{
    return vec2(A.data[_64], A.data[_64 + 1u]);
}

void _106(uint _107, vec2 _108)
{
    D.data[_107] = _108.x;
    D.data[_107 + 1u] = _108.y;
}

void main()
{
    uint _81 = 0u;
    vec2 _80[192];
    uint _86;
    for (;;)
    {
        _86 = _81;
        if (_86 < 384u)
        {
            _80[_86 / 2u] = _63(((uint(0) + (_86 / 24u)) * uint(24)) + (uint(0) + (_86 % 24u)));
            _81 = _86 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _26[192] = _80;
    vec2 tempArg[192] = _26;
    vec2 inputValue[192] = _26;
    MatrixShelf shelf;
    shelf.leaves[1].value = _26;
    vec2 result[192] = shelf.leaves[1].value;
    vec2 _116[192] = shelf.leaves[1].value;
    uint _117 = 0u;
    uint _122;
    for (;;)
    {
        _122 = _117;
        if (_122 < 384u)
        {
            _106(((uint(0) + (_122 / 24u)) * uint(24)) + (uint(0) + (_122 % 24u)), _116[_122 / 2u]);
            _117 = _122 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

