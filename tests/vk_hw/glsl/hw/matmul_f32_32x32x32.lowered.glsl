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

vec4 _72(uint _73)
{
    return vec4(A.data[_73], A.data[_73 + 1u], A.data[_73 + 2u], A.data[_73 + 3u]);
}

vec4 _123(uint _124)
{
    return vec4(B.data[_124], B.data[_124 + 1u], B.data[_124 + 2u], B.data[_124 + 3u]);
}

vec4 _164(uint _165)
{
    return vec4(C.data[_165], C.data[_165 + 1u], C.data[_165 + 2u], C.data[_165 + 3u]);
}

void _258(uint _259, vec4 _260)
{
    D.data[_259] = _260.x;
    D.data[_259 + 1u] = _260.y;
    D.data[_259 + 2u] = _260.z;
    D.data[_259 + 3u] = _260.w;
}

void main()
{
    uint _99 = 0u;
    vec4 _98[256];
    uint _104;
    for (;;)
    {
        _104 = _99;
        if (_104 < 1024u)
        {
            _98[_104 / 4u] = _72(((uint(0) + (_104 / 32u)) * uint(32)) + (uint(0) + (_104 % 32u)));
            _99 = _104 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _24[256] = _98;
    vec4 tempArg[256] = _24;
    vec4 a[256] = _24;
    uint _140 = 0u;
    vec4 _139[256];
    uint _145;
    for (;;)
    {
        _145 = _140;
        if (_145 < 1024u)
        {
            _139[_145 / 4u] = _123(((uint(0) + (_145 / 32u)) * uint(32)) + (uint(0) + (_145 % 32u)));
            _140 = _145 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _36[256] = _139;
    vec4 tempArg_1[256] = _36;
    vec4 b[256] = _36;
    uint _181 = 0u;
    vec4 _180[256];
    uint _186;
    for (;;)
    {
        _186 = _181;
        if (_186 < 1024u)
        {
            _180[_186 / 4u] = _164(((uint(0) + (_186 / 32u)) * uint(32)) + (uint(0) + (_186 % 32u)));
            _181 = _186 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _48[256] = _180;
    vec4 tempArg_2[256] = _48;
    vec4 c[256] = _48;
    vec4 _207[256] = _24;
    vec4 _208[256] = _36;
    vec4 _209[256] = _48;
    vec4 _210[256] = vec4[](vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0));
    uint _211 = 0u;
    uint _222;
    for (;;)
    {
        _222 = _211;
        if (_222 < 1024u)
        {
            float _213 = _209[_222 / 4u][_222 % 4u];
            uint _212 = 0u;
            uint _229;
            for (;;)
            {
                _229 = _212;
                if (_229 < 32u)
                {
                    uint _234 = ((_222 / 32u) * 32u) + _229;
                    uint _236 = (_229 * 32u) + (_222 % 32u);
                    _213 = fma(_207[_234 / 4u][_234 % 4u], _208[_236 / 4u][_236 % 4u], _213);
                    _212 = _229 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            uint _251 = _222 / 4u;
            vec4 _255 = _210[_251];
            _255[_222 % 4u] = _213;
            _210[_251] = _255;
            _211 = _222 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 tempArg_3[256] = _210;
    vec4 d[256] = _210;
    vec4 _274[256] = _210;
    uint _275 = 0u;
    uint _280;
    for (;;)
    {
        _280 = _275;
        if (_280 < 1024u)
        {
            _258(((uint(0) + (_280 / 32u)) * uint(32)) + (uint(0) + (_280 % 32u)), _274[_280 / 4u]);
            _275 = _280 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

