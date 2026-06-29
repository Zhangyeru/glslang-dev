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

f16vec4[4] _113()
{
    uint _124 = 0u;
    f16vec4 _123[4];
    uint _130;
    for (;;)
    {
        _130 = _124;
        if (_130 < 4u)
        {
            f16vec4 _126 = f16vec4(float16_t(0.0));
            f16vec4 _127 = f16vec4(float16_t(0.0));
            f16vec4 _128 = f16vec4(float16_t(0.0));
            f16vec4 _129 = f16vec4(float16_t(0.0));
            uint _125 = 0u;
            uint _132;
            for (;;)
            {
                _132 = _125;
                if (_132 < 8u)
                {
                    uint _134 = _132 * 4u;
                    f16vec4 _135 = _72(_134);
                    uint _136 = _130 * 4u;
                    uint _139 = ((_134 + 0u) * 16u) + _136;
                    f16vec4 _152 = _91(((uint(0) + (_139 / 16u)) * uint(16)) + (uint(0) + (_139 % 16u)));
                    uint _155 = ((_134 + 1u) * 16u) + _136;
                    f16vec4 _168 = _91(((uint(0) + (_155 / 16u)) * uint(16)) + (uint(0) + (_155 % 16u)));
                    uint _171 = ((_134 + 2u) * 16u) + _136;
                    f16vec4 _184 = _91(((uint(0) + (_171 / 16u)) * uint(16)) + (uint(0) + (_171 % 16u)));
                    uint _187 = ((_134 + 3u) * 16u) + _136;
                    f16vec4 _200 = _91(((uint(0) + (_187 / 16u)) * uint(16)) + (uint(0) + (_187 % 16u)));
                    _126 = fma(_135, f16vec4(_152.x, _168.x, _184.x, _200.x), _126);
                    _127 = fma(_135, f16vec4(_152.y, _168.y, _184.y, _200.y), _127);
                    _128 = fma(_135, f16vec4(_152.z, _168.z, _184.z, _200.z), _128);
                    _129 = fma(_135, f16vec4(_152.w, _168.w, _184.w, _200.w), _129);
                    _125 = _132 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _123[_130] = f16vec4(((_126.x + _126.y) + _126.z) + _126.w, ((_127.x + _127.y) + _127.z) + _127.w, ((_128.x + _128.y) + _128.z) + _128.w, ((_129.x + _129.y) + _129.z) + _129.w);
            _124 = _130 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _123;
}

void _267(uint _268, f16vec4 _269)
{
    Y.data[_268] = _269.x;
    Y.data[_268 + 1u] = _269.y;
    Y.data[_268 + 2u] = _269.z;
    Y.data[_268 + 3u] = _269.w;
}

void main()
{
    f16vec4 _47[4] = _113();
    f16vec4 tempArg[4] = _47;
    f16vec4 y[4] = _47;
    f16vec4 _283[4] = _47;
    uint _284 = 0u;
    uint _289;
    for (;;)
    {
        _289 = _284;
        if (_289 < 16u)
        {
            _267(_289, _283[_289 / 4u]);
            _284 = _289 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

