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

void _233(uint _234, vec2 _235)
{
    D.data[_234] = _235.x;
    D.data[_234 + 1u] = _235.y;
}

void main()
{
    uint _73 = 0u;
    vec2 _72[20];
    uint _78;
    for (;;)
    {
        _78 = _73;
        if (_78 < 40u)
        {
            _72[_78 / 2u] = _54(((uint(0) + (_78 / 8u)) * uint(8)) + (uint(0) + (_78 % 8u)));
            _73 = _78 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _26[20] = _72;
    vec2 tempArg[20] = _26;
    vec2 value[20] = _26;
    float _119 = ((((((_26[0].x + _26[0].y) + _26[1].x) + _26[1].y) + _26[2].x) + _26[2].y) + _26[3].x) + _26[3].y;
    float _142 = ((((((_26[4].x + _26[4].y) + _26[5].x) + _26[5].y) + _26[6].x) + _26[6].y) + _26[7].x) + _26[7].y;
    float _165 = ((((((_26[8].x + _26[8].y) + _26[9].x) + _26[9].y) + _26[10].x) + _26[10].y) + _26[11].x) + _26[11].y;
    float _188 = ((((((_26[12].x + _26[12].y) + _26[13].x) + _26[13].y) + _26[14].x) + _26[14].y) + _26[15].x) + _26[15].y;
    float _211 = ((((((_26[16].x + _26[16].y) + _26[17].x) + _26[17].y) + _26[18].x) + _26[18].y) + _26[19].x) + _26[19].y;
    vec2 _31[20] = vec2[](vec2(_119), vec2(_119), vec2(_119), vec2(_119), vec2(_142), vec2(_142), vec2(_142), vec2(_142), vec2(_165), vec2(_165), vec2(_165), vec2(_165), vec2(_188), vec2(_188), vec2(_188), vec2(_188), vec2(_211), vec2(_211), vec2(_211), vec2(_211));
    vec2 reduced[20] = _31;
    vec2 _243[20] = _31;
    uint _244 = 0u;
    uint _249;
    for (;;)
    {
        _249 = _244;
        if (_249 < 40u)
        {
            _233(((uint(0) + (_249 / 8u)) * uint(8)) + (uint(0) + (_249 % 8u)), _243[_249 / 2u]);
            _244 = _249 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

