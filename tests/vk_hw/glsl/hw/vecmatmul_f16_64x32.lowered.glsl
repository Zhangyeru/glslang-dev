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

void _108(uint _109, f16vec4 _110)
{
    Y.data[_109] = _110.x;
    Y.data[_109 + 1u] = _110.y;
    Y.data[_109 + 2u] = _110.z;
    Y.data[_109 + 3u] = _110.w;
}

void _129()
{
    uint _139 = 0u;
    uint _145;
    for (;;)
    {
        _145 = _139;
        if (_145 < 8u)
        {
            f16vec4 _141 = f16vec4(float16_t(0.0));
            f16vec4 _142 = f16vec4(float16_t(0.0));
            f16vec4 _143 = f16vec4(float16_t(0.0));
            f16vec4 _144 = f16vec4(float16_t(0.0));
            uint _140 = 0u;
            uint _147;
            for (;;)
            {
                _147 = _140;
                if (_147 < 16u)
                {
                    uint _149 = _147 * 4u;
                    f16vec4 _150 = _72(_149);
                    uint _151 = _145 * 4u;
                    uint _154 = ((_149 + 0u) * 32u) + _151;
                    f16vec4 _167 = _91(((uint(0) + (_154 / 32u)) * uint(32)) + (uint(0) + (_154 % 32u)));
                    uint _170 = ((_149 + 1u) * 32u) + _151;
                    f16vec4 _183 = _91(((uint(0) + (_170 / 32u)) * uint(32)) + (uint(0) + (_170 % 32u)));
                    uint _186 = ((_149 + 2u) * 32u) + _151;
                    f16vec4 _199 = _91(((uint(0) + (_186 / 32u)) * uint(32)) + (uint(0) + (_186 % 32u)));
                    uint _202 = ((_149 + 3u) * 32u) + _151;
                    f16vec4 _215 = _91(((uint(0) + (_202 / 32u)) * uint(32)) + (uint(0) + (_202 % 32u)));
                    _141 = fma(_150, f16vec4(_167.x, _183.x, _199.x, _215.x), _141);
                    _142 = fma(_150, f16vec4(_167.y, _183.y, _199.y, _215.y), _142);
                    _143 = fma(_150, f16vec4(_167.z, _183.z, _199.z, _215.z), _143);
                    _144 = fma(_150, f16vec4(_167.w, _183.w, _199.w, _215.w), _144);
                    _140 = _147 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _108(_145 * 4u, f16vec4(((_141.x + _141.y) + _141.z) + _141.w, ((_142.x + _142.y) + _142.z) + _142.w, ((_143.x + _143.y) + _143.z) + _143.w, ((_144.x + _144.y) + _144.z) + _144.w));
            _139 = _145 + 1u;
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
    _129();
}

