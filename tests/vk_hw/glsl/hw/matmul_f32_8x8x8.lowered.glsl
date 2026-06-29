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

vec4[16] _131()
{
    uint _146 = 0u;
    vec4 _145[16];
    uint _153;
    for (;;)
    {
        _153 = _146;
        if (_153 < 8u)
        {
            uint _147 = 0u;
            uint _155;
            for (;;)
            {
                _155 = _147;
                if (_155 < 2u)
                {
                    vec4 _149 = vec4(0.0);
                    vec4 _150 = vec4(0.0);
                    vec4 _151 = vec4(0.0);
                    vec4 _152 = vec4(0.0);
                    uint _148 = 0u;
                    uint _157;
                    for (;;)
                    {
                        _157 = _148;
                        if (_157 < 2u)
                        {
                            uint _159 = _157 * 4u;
                            uint _161 = (_153 * 8u) + _159;
                            vec4 _174 = _72(((uint(0) + (_161 / 8u)) * uint(8)) + (uint(0) + (_161 % 8u)));
                            uint _178 = ((_159 + 0u) * 8u) + (_155 * 4u);
                            vec4 _191 = _92(((uint(0) + (_178 / 8u)) * uint(8)) + (uint(0) + (_178 % 8u)));
                            uint _195 = ((_159 + 1u) * 8u) + (_155 * 4u);
                            vec4 _208 = _92(((uint(0) + (_195 / 8u)) * uint(8)) + (uint(0) + (_195 % 8u)));
                            uint _212 = ((_159 + 2u) * 8u) + (_155 * 4u);
                            vec4 _225 = _92(((uint(0) + (_212 / 8u)) * uint(8)) + (uint(0) + (_212 % 8u)));
                            uint _229 = ((_159 + 3u) * 8u) + (_155 * 4u);
                            vec4 _242 = _92(((uint(0) + (_229 / 8u)) * uint(8)) + (uint(0) + (_229 % 8u)));
                            _149 = fma(_174, vec4(_191.x, _208.x, _225.x, _242.x), _149);
                            _150 = fma(_174, vec4(_191.y, _208.y, _225.y, _242.y), _150);
                            _151 = fma(_174, vec4(_191.z, _208.z, _225.z, _242.z), _151);
                            _152 = fma(_174, vec4(_191.w, _208.w, _225.w, _242.w), _152);
                            _148 = _157 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _276 = (_153 * 8u) + (_155 * 4u);
                    vec4 _289 = _108(((uint(0) + (_276 / 8u)) * uint(8)) + (uint(0) + (_276 % 8u)));
                    _145[(_153 * 2u) + _155] = vec4(_289.x + (((_149.x + _149.y) + _149.z) + _149.w), _289.y + (((_150.x + _150.y) + _150.z) + _150.w), _289.z + (((_151.x + _151.y) + _151.z) + _151.w), _289.w + (((_152.x + _152.y) + _152.z) + _152.w));
                    _147 = _155 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _146 = _153 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _145;
}

void _336(uint _337, vec4 _338)
{
    D.data[_337] = _338.x;
    D.data[_337 + 1u] = _338.y;
    D.data[_337 + 2u] = _338.z;
    D.data[_337 + 3u] = _338.w;
}

void main()
{
    vec4 _55[16] = _131();
    vec4 tempArg[16] = _55;
    vec4 d[16] = _55;
    vec4 _353[16] = _55;
    uint _354 = 0u;
    uint _359;
    for (;;)
    {
        _359 = _354;
        if (_359 < 64u)
        {
            _336(((uint(0) + (_359 / 8u)) * uint(8)) + (uint(0) + (_359 % 8u)), _353[_359 / 4u]);
            _354 = _359 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

