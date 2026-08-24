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

vec2[512] _112()
{
    uint _127 = 0u;
    vec2 _126[512];
    uint _132;
    for (;;)
    {
        _132 = _127;
        if (_132 < 32u)
        {
            uint _128 = 0u;
            uint _134;
            for (;;)
            {
                _134 = _128;
                if (_134 < 16u)
                {
                    vec2 _130 = vec2(0.0);
                    vec2 _131 = vec2(0.0);
                    uint _129 = 0u;
                    uint _136;
                    for (;;)
                    {
                        _136 = _129;
                        if (_136 < 16u)
                        {
                            uint _138 = _136 * 2u;
                            uint _140 = (_132 * 32u) + _138;
                            vec2 _153 = _72(((uint(0) + (_140 / 32u)) * uint(32)) + (uint(0) + (_140 % 32u)));
                            uint _157 = ((_138 + 0u) * 32u) + (_134 * 2u);
                            vec2 _170 = _84(((uint(0) + (_157 / 32u)) * uint(32)) + (uint(0) + (_157 % 32u)));
                            uint _174 = ((_138 + 1u) * 32u) + (_134 * 2u);
                            vec2 _187 = _84(((uint(0) + (_174 / 32u)) * uint(32)) + (uint(0) + (_174 % 32u)));
                            _130 = fma(_153, vec2(_170.x, _187.x), _130);
                            _131 = fma(_153, vec2(_170.y, _187.y), _131);
                            _129 = _136 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _203 = (_132 * 32u) + (_134 * 2u);
                    vec2 _216 = _94(((uint(0) + (_203 / 32u)) * uint(32)) + (uint(0) + (_203 % 32u)));
                    _126[(_132 * 16u) + _134] = vec2(_216.x + (_130.x + _130.y), _216.y + (_131.x + _131.y));
                    _128 = _134 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _127 = _132 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _126;
}

void _235(uint _236, vec2 _237)
{
    D.data[_236] = _237.x;
    D.data[_236 + 1u] = _237.y;
}

void main()
{
    vec2 _55[512] = _112();
    vec2 tempArg[512] = _55;
    vec2 d[512] = _55;
    vec2 _246[512] = _55;
    uint _247 = 0u;
    uint _252;
    for (;;)
    {
        _252 = _247;
        if (_252 < 1024u)
        {
            _235(((uint(0) + (_252 / 32u)) * uint(32)) + (uint(0) + (_252 % 32u)), _246[_252 / 2u]);
            _247 = _252 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

