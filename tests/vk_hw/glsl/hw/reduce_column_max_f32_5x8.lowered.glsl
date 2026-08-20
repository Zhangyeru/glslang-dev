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

vec2 _56(uint _57)
{
    return vec2(A.data[_57], A.data[_57 + 1u]);
}

void _232(uint _233, vec2 _234)
{
    D.data[_233] = _234.x;
    D.data[_233 + 1u] = _234.y;
}

void main()
{
    uint _75 = 0u;
    vec2 _74[20];
    uint _80;
    for (;;)
    {
        _80 = _75;
        if (_80 < 40u)
        {
            _74[_80 / 2u] = _56(((uint(0) + (_80 / 8u)) * uint(8)) + (uint(0) + (_80 % 8u)));
            _75 = _80 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _26[20] = _74;
    vec2 tempArg[20] = _26;
    vec2 value[20] = _26;
    float _112 = max(max(max(max(_26[0].x, _26[4].x), _26[8].x), _26[12].x), _26[16].x);
    float _126 = max(max(max(max(_26[0].y, _26[4].y), _26[8].y), _26[12].y), _26[16].y);
    float _140 = max(max(max(max(_26[1].x, _26[5].x), _26[9].x), _26[13].x), _26[17].x);
    float _154 = max(max(max(max(_26[1].y, _26[5].y), _26[9].y), _26[13].y), _26[17].y);
    float _168 = max(max(max(max(_26[2].x, _26[6].x), _26[10].x), _26[14].x), _26[18].x);
    float _182 = max(max(max(max(_26[2].y, _26[6].y), _26[10].y), _26[14].y), _26[18].y);
    float _196 = max(max(max(max(_26[3].x, _26[7].x), _26[11].x), _26[15].x), _26[19].x);
    float _210 = max(max(max(max(_26[3].y, _26[7].y), _26[11].y), _26[15].y), _26[19].y);
    vec2 _33[20] = vec2[](vec2(_112, _126), vec2(_140, _154), vec2(_168, _182), vec2(_196, _210), vec2(_112, _126), vec2(_140, _154), vec2(_168, _182), vec2(_196, _210), vec2(_112, _126), vec2(_140, _154), vec2(_168, _182), vec2(_196, _210), vec2(_112, _126), vec2(_140, _154), vec2(_168, _182), vec2(_196, _210), vec2(_112, _126), vec2(_140, _154), vec2(_168, _182), vec2(_196, _210));
    vec2 reduced[20] = _33;
    vec2 _242[20] = _33;
    uint _243 = 0u;
    uint _248;
    for (;;)
    {
        _248 = _243;
        if (_248 < 40u)
        {
            _232(((uint(0) + (_248 / 8u)) * uint(8)) + (uint(0) + (_248 % 8u)), _242[_248 / 2u]);
            _243 = _248 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

