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

vec2 _55(uint _56)
{
    return vec2(A.data[_56], A.data[_56 + 1u]);
}

void _234(uint _235, vec2 _236)
{
    D.data[_235] = _236.x;
    D.data[_235 + 1u] = _236.y;
}

void main()
{
    uint _74 = 0u;
    vec2 _73[20];
    uint _79;
    for (;;)
    {
        _79 = _74;
        if (_79 < 40u)
        {
            _73[_79 / 2u] = _55(((uint(0) + (_79 / 8u)) * uint(8)) + (uint(0) + (_79 % 8u)));
            _74 = _79 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _26[20] = _73;
    vec2 tempArg[20] = _26;
    vec2 value[20] = _26;
    float _120 = min(min(min(min(min(min(min(_26[0].x, _26[0].y), _26[1].x), _26[1].y), _26[2].x), _26[2].y), _26[3].x), _26[3].y);
    float _143 = min(min(min(min(min(min(min(_26[4].x, _26[4].y), _26[5].x), _26[5].y), _26[6].x), _26[6].y), _26[7].x), _26[7].y);
    float _166 = min(min(min(min(min(min(min(_26[8].x, _26[8].y), _26[9].x), _26[9].y), _26[10].x), _26[10].y), _26[11].x), _26[11].y);
    float _189 = min(min(min(min(min(min(min(_26[12].x, _26[12].y), _26[13].x), _26[13].y), _26[14].x), _26[14].y), _26[15].x), _26[15].y);
    float _212 = min(min(min(min(min(min(min(_26[16].x, _26[16].y), _26[17].x), _26[17].y), _26[18].x), _26[18].y), _26[19].x), _26[19].y);
    vec2 _32[20] = vec2[](vec2(_120), vec2(_120), vec2(_120), vec2(_120), vec2(_143), vec2(_143), vec2(_143), vec2(_143), vec2(_166), vec2(_166), vec2(_166), vec2(_166), vec2(_189), vec2(_189), vec2(_189), vec2(_189), vec2(_212), vec2(_212), vec2(_212), vec2(_212));
    vec2 reduced[20] = _32;
    vec2 _244[20] = _32;
    uint _245 = 0u;
    uint _250;
    for (;;)
    {
        _250 = _245;
        if (_250 < 40u)
        {
            _234(((uint(0) + (_250 / 8u)) * uint(8)) + (uint(0) + (_250 % 8u)), _244[_250 / 2u]);
            _245 = _250 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

