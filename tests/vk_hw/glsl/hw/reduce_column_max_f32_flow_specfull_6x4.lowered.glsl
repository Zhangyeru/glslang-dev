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

vec2 _54(uint _55)
{
    return vec2(A.data[_55], A.data[_55 + 1u]);
}

void _179(uint _180, vec2 _181)
{
    D.data[_180] = _181.x;
    D.data[_180 + 1u] = _181.y;
}

void main()
{
    uint _73 = 0u;
    vec2 _72[12];
    uint _78;
    for (;;)
    {
        _78 = _73;
        if (_78 < 24u)
        {
            _72[_78 / 2u] = _54(((uint(0) + (_78 / 4u)) * uint(4)) + (uint(0) + (_78 % 4u)));
            _73 = _78 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _23[12] = _72;
    vec2 tempArg[12] = _23;
    vec2 value[12] = _23;
    float _114 = max(max(max(max(max(_23[0].x, _23[2].x), _23[4].x), _23[6].x), _23[8].x), _23[10].x);
    float _131 = max(max(max(max(max(_23[0].y, _23[2].y), _23[4].y), _23[6].y), _23[8].y), _23[10].y);
    float _148 = max(max(max(max(max(_23[1].x, _23[3].x), _23[5].x), _23[7].x), _23[9].x), _23[11].x);
    float _165 = max(max(max(max(max(_23[1].y, _23[3].y), _23[5].y), _23[7].y), _23[9].y), _23[11].y);
    vec2 _30[12] = vec2[](vec2(_114, _131), vec2(_148, _165), vec2(_114, _131), vec2(_148, _165), vec2(_114, _131), vec2(_148, _165), vec2(_114, _131), vec2(_148, _165), vec2(_114, _131), vec2(_148, _165), vec2(_114, _131), vec2(_148, _165));
    vec2 reduced[12] = _30;
    vec2 _189[12] = _30;
    uint _190 = 0u;
    uint _195;
    for (;;)
    {
        _195 = _190;
        if (_195 < 24u)
        {
            _179(((uint(0) + (_195 / 4u)) * uint(4)) + (uint(0) + (_195 % 4u)), _189[_195 / 2u]);
            _190 = _195 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

