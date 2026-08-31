#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct SharedMatrix
{
    uint generation;
    float values[1024];
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

shared SharedMatrix workgroupMatrix;

vec2 _68(uint _69)
{
    return vec2(A.data[_69], A.data[_69 + 1u]);
}

void _110(uint _111, vec2 _112)
{
    workgroupMatrix.values[_111] = _112.x;
    workgroupMatrix.values[_111 + 1u] = _112.y;
}

vec2 _146(uint _147)
{
    return vec2(workgroupMatrix.values[_147], workgroupMatrix.values[_147 + 1u]);
}

void _181(uint _182, vec2 _183)
{
    D.data[_182] = _183.x;
    D.data[_182 + 1u] = _183.y;
}

void main()
{
    uint _85 = 0u;
    vec2 _84[512];
    uint _90;
    for (;;)
    {
        _90 = _85;
        if (_90 < 1024u)
        {
            _84[_90 / 2u] = _68(((uint(0) + (_90 / 32u)) * uint(32)) + (uint(0) + (_90 % 32u)));
            _85 = _90 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _24[512] = _84;
    vec2 tempArg[512] = _24;
    vec2 inputValue[512] = _24;
    workgroupMatrix.generation = 1u;
    vec2 _121[512] = _24;
    uint _122 = 0u;
    uint _127;
    for (;;)
    {
        _127 = _122;
        if (_127 < 1024u)
        {
            _110(((uint(0) + (_127 / 32u)) * uint(32)) + (uint(0) + (_127 % 32u)), _121[_127 / 2u]);
            _122 = _127 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    memoryBarrierShared();
    barrier();
    uint _157 = 0u;
    vec2 _156[512];
    uint _162;
    for (;;)
    {
        _162 = _157;
        if (_162 < 1024u)
        {
            _156[_162 / 2u] = _146(((uint(0) + (_162 / 32u)) * uint(32)) + (uint(0) + (_162 % 32u)));
            _157 = _162 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _44[512] = _156;
    vec2 tempArg_1[512] = _44;
    vec2 result[512] = _44;
    vec2 _191[512] = _44;
    uint _192 = 0u;
    uint _197;
    for (;;)
    {
        _197 = _192;
        if (_197 < 1024u)
        {
            _181(((uint(0) + (_197 / 32u)) * uint(32)) + (uint(0) + (_197 % 32u)), _191[_197 / 2u]);
            _192 = _197 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

