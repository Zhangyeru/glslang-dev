#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct MatrixPayload
{
    vec2 value[384];
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

vec2 _72(uint _73)
{
    return vec2(A.data[_73], A.data[_73 + 1u]);
}

MatrixPayload forwardValue(MatrixPayload payload)
{
    return payload;
}

void _116(uint _117, vec2 _118)
{
    D.data[_117] = _118.x;
    D.data[_117 + 1u] = _118.y;
}

void main()
{
    uint _91 = 0u;
    vec2 _90[384];
    uint _96;
    for (;;)
    {
        _96 = _91;
        if (_96 < 768u)
        {
            _90[_96 / 2u] = _72(((uint(0) + (_96 / 32u)) * uint(32)) + (uint(0) + (_96 % 32u)));
            _91 = _96 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _35[384] = _90;
    vec2 tempArg[384] = _35;
    vec2 inputValue[384] = _35;
    MatrixPayload inputPayload;
    inputPayload.value = _35;
    MatrixPayload param = inputPayload;
    MatrixPayload _44 = forwardValue(param);
    MatrixPayload first = _44;
    MatrixPayload param_1 = _44;
    MatrixPayload result = forwardValue(param_1);
    vec2 _126[384] = result.value;
    uint _127 = 0u;
    uint _132;
    for (;;)
    {
        _132 = _127;
        if (_132 < 768u)
        {
            _116(((uint(0) + (_132 / 32u)) * uint(32)) + (uint(0) + (_132 % 32u)), _126[_132 / 2u]);
            _127 = _132 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

