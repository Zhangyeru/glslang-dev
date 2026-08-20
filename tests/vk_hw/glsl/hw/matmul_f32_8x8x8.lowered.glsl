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

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec2 _72(uint _73)
{
    return vec2(A.data[_73], A.data[_73 + 1u]);
}

vec2 _84(uint _85)
{
    return vec2(B.data[_85], B.data[_85 + 1u]);
}

vec2 _94(uint _95)
{
    return vec2(C.data[_95], C.data[_95 + 1u]);
}

void _105(uint _106, vec2 _107)
{
    D.data[_106] = _107.x;
    D.data[_106 + 1u] = _107.y;
}

void _121()
{
    uint _135 = 0u;
    uint _140;
    for (;;)
    {
        _140 = _135;
        if (_140 < 8u)
        {
            uint _136 = 0u;
            uint _142;
            for (;;)
            {
                _142 = _136;
                if (_142 < 4u)
                {
                    vec2 _138 = vec2(0.0);
                    vec2 _139 = vec2(0.0);
                    uint _137 = 0u;
                    uint _144;
                    for (;;)
                    {
                        _144 = _137;
                        if (_144 < 4u)
                        {
                            uint _146 = _144 * 2u;
                            uint _148 = (_140 * 8u) + _146;
                            vec2 _161 = _72(((uint(0) + (_148 / 8u)) * uint(8)) + (uint(0) + (_148 % 8u)));
                            uint _165 = ((_146 + 0u) * 8u) + (_142 * 2u);
                            vec2 _178 = _84(((uint(0) + (_165 / 8u)) * uint(8)) + (uint(0) + (_165 % 8u)));
                            uint _182 = ((_146 + 1u) * 8u) + (_142 * 2u);
                            vec2 _195 = _84(((uint(0) + (_182 / 8u)) * uint(8)) + (uint(0) + (_182 % 8u)));
                            _138 = fma(_161, vec2(_178.x, _195.x), _138);
                            _139 = fma(_161, vec2(_178.y, _195.y), _139);
                            _137 = _144 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _209 = (_140 * 8u) + (_142 * 2u);
                    vec2 _222 = _94(((uint(0) + (_209 / 8u)) * uint(8)) + (uint(0) + (_209 % 8u)));
                    uint _238 = (_140 * 8u) + (_142 * 2u);
                    _105(((uint(0) + (_238 / 8u)) * uint(8)) + (uint(0) + (_238 % 8u)), vec2(_222.x + (_138.x + _138.y), _222.y + (_139.x + _139.y)));
                    _136 = _142 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _135 = _140 + 1u;
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
    _121();
}

