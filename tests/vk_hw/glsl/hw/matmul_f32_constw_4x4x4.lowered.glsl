#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec4 _14[4] = vec4[](vec4(0.5), vec4(0.5), vec4(0.5), vec4(0.5));

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec4 _65(uint _66)
{
    return vec4(A.data[_66], A.data[_66 + 1u], A.data[_66 + 2u], A.data[_66 + 3u]);
}

vec4 _85(uint _86)
{
    return vec4(C.data[_86], C.data[_86 + 1u], C.data[_86 + 2u], C.data[_86 + 3u]);
}

vec4[4] _107()
{
    uint _122 = 0u;
    vec4 _121[4];
    uint _130;
    for (;;)
    {
        _130 = _122;
        if (_130 < 4u)
        {
            uint _123 = 0u;
            uint _132;
            for (;;)
            {
                _132 = _123;
                if (_132 < 1u)
                {
                    vec4 _125 = vec4(0.0);
                    vec4 _126 = vec4(0.0);
                    vec4 _127 = vec4(0.0);
                    vec4 _128 = vec4(0.0);
                    uint _124 = 0u;
                    uint _134;
                    for (;;)
                    {
                        _134 = _124;
                        if (_134 < 1u)
                        {
                            uint _136 = _134 * 4u;
                            uint _138 = (_130 * 4u) + _136;
                            vec4 _151 = _65(((uint(0) + (_138 / 4u)) * uint(4)) + (uint(0) + (_138 % 4u)));
                            uint _154 = ((_136 + 0u) * 1u) + _132;
                            uint _159 = ((_136 + 1u) * 1u) + _132;
                            uint _164 = ((_136 + 2u) * 1u) + _132;
                            uint _169 = ((_136 + 3u) * 1u) + _132;
                            _125 = fma(_151, vec4(_14[_154].x, _14[_159].x, _14[_164].x, _14[_169].x), _125);
                            _126 = fma(_151, vec4(_14[_154].y, _14[_159].y, _14[_164].y, _14[_169].y), _126);
                            _127 = fma(_151, vec4(_14[_154].z, _14[_159].z, _14[_164].z, _14[_169].z), _127);
                            _128 = fma(_151, vec4(_14[_154].w, _14[_159].w, _14[_164].w, _14[_169].w), _128);
                            _124 = _134 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _205 = (_130 * 4u) + (_132 * 4u);
                    vec4 _218 = _85(((uint(0) + (_205 / 4u)) * uint(4)) + (uint(0) + (_205 % 4u)));
                    _121[(_130 * 1u) + _132] = vec4(_218.x + (((_125.x + _125.y) + _125.z) + _125.w), _218.y + (((_126.x + _126.y) + _126.z) + _126.w), _218.z + (((_127.x + _127.y) + _127.z) + _127.w), _218.w + (((_128.x + _128.y) + _128.z) + _128.w));
                    _123 = _132 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _122 = _130 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _121;
}

void _266(uint _267, vec4 _268)
{
    D.data[_267] = _268.x;
    D.data[_267 + 1u] = _268.y;
    D.data[_267 + 2u] = _268.z;
    D.data[_267 + 3u] = _268.w;
}

void main()
{
    vec4 _15[4] = _14;
    vec4 b[4] = _15;
    vec4 _49[4] = _107();
    vec4 tempArg[4] = _49;
    vec4 d[4] = _49;
    vec4 _283[4] = _49;
    uint _284 = 0u;
    uint _289;
    for (;;)
    {
        _289 = _284;
        if (_289 < 16u)
        {
            _266(((uint(0) + (_289 / 4u)) * uint(4)) + (uint(0) + (_289 % 4u)), _283[_289 / 4u]);
            _284 = _289 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

