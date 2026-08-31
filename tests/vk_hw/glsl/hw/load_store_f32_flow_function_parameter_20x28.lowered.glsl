#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct MatrixPayload
{
    vec2 value[280];
};

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec2 _64(uint _65)
{
    return vec2(A.data[_65], A.data[_65 + 1u]);
}

void _108(uint _109, vec2 _110)
{
    D.data[_109] = _110.x;
    D.data[_109 + 1u] = _110.y;
}

void storeParameter(MatrixPayload payload)
{
    vec2 _118[280] = payload.value;
    uint _119 = 0u;
    uint _124;
    for (;;)
    {
        _124 = _119;
        if (_124 < 560u)
        {
            _108(((uint(0) + (_124 / 28u)) * uint(28)) + (uint(0) + (_124 % 28u)), _118[_124 / 2u]);
            _119 = _124 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

void main()
{
    uint _83 = 0u;
    vec2 _82[280];
    uint _88;
    for (;;)
    {
        _88 = _83;
        if (_88 < 560u)
        {
            _82[_88 / 2u] = _64(((uint(0) + (_88 / 28u)) * uint(28)) + (uint(0) + (_88 % 28u)));
            _83 = _88 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _40[280] = _82;
    vec2 tempArg[280] = _40;
    vec2 value[280] = _40;
    MatrixPayload payload;
    payload.value = _40;
    MatrixPayload param = payload;
    storeParameter(param);
}

