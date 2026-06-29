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

vec4 _92(uint _93)
{
    return vec4(B.data[_93], B.data[_93 + 1u], B.data[_93 + 2u], B.data[_93 + 3u]);
}

vec4 _108(uint _109)
{
    return vec4(C.data[_109], C.data[_109 + 1u], C.data[_109 + 2u], C.data[_109 + 3u]);
}

vec4[256] _132()
{
    uint _147 = 0u;
    vec4 _146[256];
    uint _154;
    for (;;)
    {
        _154 = _147;
        if (_154 < 32u)
        {
            uint _148 = 0u;
            uint _156;
            for (;;)
            {
                _156 = _148;
                if (_156 < 8u)
                {
                    vec4 _150 = vec4(0.0);
                    vec4 _151 = vec4(0.0);
                    vec4 _152 = vec4(0.0);
                    vec4 _153 = vec4(0.0);
                    uint _149 = 0u;
                    uint _158;
                    for (;;)
                    {
                        _158 = _149;
                        if (_158 < 8u)
                        {
                            uint _160 = _158 * 4u;
                            uint _162 = (_154 * 32u) + _160;
                            vec4 _175 = _72(((uint(0) + (_162 / 32u)) * uint(32)) + (uint(0) + (_162 % 32u)));
                            uint _179 = ((_160 + 0u) * 32u) + (_156 * 4u);
                            vec4 _192 = _92(((uint(0) + (_179 / 32u)) * uint(32)) + (uint(0) + (_179 % 32u)));
                            uint _196 = ((_160 + 1u) * 32u) + (_156 * 4u);
                            vec4 _209 = _92(((uint(0) + (_196 / 32u)) * uint(32)) + (uint(0) + (_196 % 32u)));
                            uint _213 = ((_160 + 2u) * 32u) + (_156 * 4u);
                            vec4 _226 = _92(((uint(0) + (_213 / 32u)) * uint(32)) + (uint(0) + (_213 % 32u)));
                            uint _230 = ((_160 + 3u) * 32u) + (_156 * 4u);
                            vec4 _243 = _92(((uint(0) + (_230 / 32u)) * uint(32)) + (uint(0) + (_230 % 32u)));
                            _150 = fma(_175, vec4(_192.x, _209.x, _226.x, _243.x), _150);
                            _151 = fma(_175, vec4(_192.y, _209.y, _226.y, _243.y), _151);
                            _152 = fma(_175, vec4(_192.z, _209.z, _226.z, _243.z), _152);
                            _153 = fma(_175, vec4(_192.w, _209.w, _226.w, _243.w), _153);
                            _149 = _158 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _277 = (_154 * 32u) + (_156 * 4u);
                    vec4 _290 = _108(((uint(0) + (_277 / 32u)) * uint(32)) + (uint(0) + (_277 % 32u)));
                    _146[(_154 * 8u) + _156] = vec4(_290.x + (((_150.x + _150.y) + _150.z) + _150.w), _290.y + (((_151.x + _151.y) + _151.z) + _151.w), _290.z + (((_152.x + _152.y) + _152.z) + _152.w), _290.w + (((_153.x + _153.y) + _153.z) + _153.w));
                    _148 = _156 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _147 = _154 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _146;
}

void _337(uint _338, vec4 _339)
{
    D.data[_338] = _339.x;
    D.data[_338 + 1u] = _339.y;
    D.data[_338 + 2u] = _339.z;
    D.data[_338 + 3u] = _339.w;
}

void main()
{
    vec4 _55[256] = _132();
    vec4 tempArg[256] = _55;
    vec4 d[256] = _55;
    vec4 _354[256] = _55;
    uint _355 = 0u;
    uint _360;
    for (;;)
    {
        _360 = _355;
        if (_360 < 1024u)
        {
            _337(((uint(0) + (_360 / 32u)) * uint(32)) + (uint(0) + (_360 % 32u)), _354[_360 / 4u]);
            _355 = _360 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

