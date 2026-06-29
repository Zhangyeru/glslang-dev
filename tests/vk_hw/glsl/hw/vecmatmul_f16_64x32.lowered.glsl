#version 450
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float16_t data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

f16vec4 _72(uint _73)
{
    return f16vec4(X.data[_73], X.data[_73 + 1u], X.data[_73 + 2u], X.data[_73 + 3u]);
}

f16vec4 _91(uint _92)
{
    return f16vec4(W.data[_92], W.data[_92 + 1u], W.data[_92 + 2u], W.data[_92 + 3u]);
}

f16vec4[8] _114()
{
    uint _125 = 0u;
    f16vec4 _124[8];
    uint _131;
    for (;;)
    {
        _131 = _125;
        if (_131 < 8u)
        {
            f16vec4 _127 = f16vec4(float16_t(0.0));
            f16vec4 _128 = f16vec4(float16_t(0.0));
            f16vec4 _129 = f16vec4(float16_t(0.0));
            f16vec4 _130 = f16vec4(float16_t(0.0));
            uint _126 = 0u;
            uint _133;
            for (;;)
            {
                _133 = _126;
                if (_133 < 16u)
                {
                    uint _135 = _133 * 4u;
                    f16vec4 _136 = _72(_135);
                    uint _137 = _131 * 4u;
                    uint _140 = ((_135 + 0u) * 32u) + _137;
                    f16vec4 _153 = _91(((uint(0) + (_140 / 32u)) * uint(32)) + (uint(0) + (_140 % 32u)));
                    uint _156 = ((_135 + 1u) * 32u) + _137;
                    f16vec4 _169 = _91(((uint(0) + (_156 / 32u)) * uint(32)) + (uint(0) + (_156 % 32u)));
                    uint _172 = ((_135 + 2u) * 32u) + _137;
                    f16vec4 _185 = _91(((uint(0) + (_172 / 32u)) * uint(32)) + (uint(0) + (_172 % 32u)));
                    uint _188 = ((_135 + 3u) * 32u) + _137;
                    f16vec4 _201 = _91(((uint(0) + (_188 / 32u)) * uint(32)) + (uint(0) + (_188 % 32u)));
                    _127 = fma(_136, f16vec4(_153.x, _169.x, _185.x, _201.x), _127);
                    _128 = fma(_136, f16vec4(_153.y, _169.y, _185.y, _201.y), _128);
                    _129 = fma(_136, f16vec4(_153.z, _169.z, _185.z, _201.z), _129);
                    _130 = fma(_136, f16vec4(_153.w, _169.w, _185.w, _201.w), _130);
                    _126 = _133 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _124[_131] = f16vec4(((_127.x + _127.y) + _127.z) + _127.w, ((_128.x + _128.y) + _128.z) + _128.w, ((_129.x + _129.y) + _129.z) + _129.w, ((_130.x + _130.y) + _130.z) + _130.w);
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

void _268(uint _269, f16vec4 _270)
{
    Y.data[_269] = _270.x;
    Y.data[_269 + 1u] = _270.y;
    Y.data[_269 + 2u] = _270.z;
    Y.data[_269 + 3u] = _270.w;
}

void main()
{
    f16vec4 _47[8] = _114();
    f16vec4 tempArg[8] = _47;
    f16vec4 y[8] = _47;
    f16vec4 _284[8] = _47;
    uint _285 = 0u;
    uint _290;
    for (;;)
    {
        _290 = _285;
        if (_290 < 32u)
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

