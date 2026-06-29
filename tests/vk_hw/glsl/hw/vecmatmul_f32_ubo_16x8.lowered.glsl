#version 450
#extension GL_EXT_scalar_block_layout : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, scalar) uniform InputW
{
    float data[128];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec4 _73(uint _74)
{
    return vec4(X.data[_74], X.data[_74 + 1u], X.data[_74 + 2u], X.data[_74 + 3u]);
}

vec4 _91(uint _92)
{
    return vec4(W.data[_92], W.data[_92 + 1u], W.data[_92 + 2u], W.data[_92 + 3u]);
}

vec4[2] _114()
{
    uint _125 = 0u;
    vec4 _124[2];
    uint _131;
    for (;;)
    {
        _131 = _125;
        if (_131 < 2u)
        {
            vec4 _127 = vec4(0.0);
            vec4 _128 = vec4(0.0);
            vec4 _129 = vec4(0.0);
            vec4 _130 = vec4(0.0);
            uint _126 = 0u;
            uint _133;
            for (;;)
            {
                _133 = _126;
                if (_133 < 4u)
                {
                    uint _135 = _133 * 4u;
                    vec4 _136 = _73(_135);
                    uint _137 = _131 * 4u;
                    uint _140 = ((_135 + 0u) * 8u) + _137;
                    vec4 _153 = _91(((uint(0) + (_140 / 8u)) * uint(8)) + (uint(0) + (_140 % 8u)));
                    uint _156 = ((_135 + 1u) * 8u) + _137;
                    vec4 _169 = _91(((uint(0) + (_156 / 8u)) * uint(8)) + (uint(0) + (_156 % 8u)));
                    uint _172 = ((_135 + 2u) * 8u) + _137;
                    vec4 _185 = _91(((uint(0) + (_172 / 8u)) * uint(8)) + (uint(0) + (_172 % 8u)));
                    uint _188 = ((_135 + 3u) * 8u) + _137;
                    vec4 _201 = _91(((uint(0) + (_188 / 8u)) * uint(8)) + (uint(0) + (_188 % 8u)));
                    _127 = fma(_136, vec4(_153.x, _169.x, _185.x, _201.x), _127);
                    _128 = fma(_136, vec4(_153.y, _169.y, _185.y, _201.y), _128);
                    _129 = fma(_136, vec4(_153.z, _169.z, _185.z, _201.z), _129);
                    _130 = fma(_136, vec4(_153.w, _169.w, _185.w, _201.w), _130);
                    _126 = _133 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _124[_131] = vec4(((_127.x + _127.y) + _127.z) + _127.w, ((_128.x + _128.y) + _128.z) + _128.w, ((_129.x + _129.y) + _129.z) + _129.w, ((_130.x + _130.y) + _130.z) + _130.w);
            _125 = _131 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _124;
}

void _268(uint _269, vec4 _270)
{
    Y.data[_269] = _270.x;
    Y.data[_269 + 1u] = _270.y;
    Y.data[_269 + 2u] = _270.z;
    Y.data[_269 + 3u] = _270.w;
}

void main()
{
    vec4 _48[2] = _114();
    vec4 tempArg[2] = _48;
    vec4 y[2] = _48;
    vec4 _284[2] = _48;
    uint _285 = 0u;
    uint _290;
    for (;;)
    {
        _290 = _285;
        if (_290 < 8u)
        {
            _268(_290, _284[_290 / 4u]);
            _285 = _290 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

