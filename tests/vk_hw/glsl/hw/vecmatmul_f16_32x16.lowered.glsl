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

void _128()
{
    uint _138 = 0u;
    uint _144;
    for (;;)
    {
        _144 = _138;
        if (_144 < 4u)
        {
            f16vec4 _140 = f16vec4(float16_t(0.0));
            f16vec4 _141 = f16vec4(float16_t(0.0));
            f16vec4 _142 = f16vec4(float16_t(0.0));
            f16vec4 _143 = f16vec4(float16_t(0.0));
            uint _139 = 0u;
            uint _146;
            for (;;)
            {
                _146 = _139;
                if (_146 < 8u)
                {
                    uint _148 = _146 * 4u;
                    f16vec4 _149 = _72(_148);
                    uint _150 = _144 * 4u;
                    uint _153 = ((_148 + 0u) * 16u) + _150;
                    f16vec4 _166 = _91(((uint(0) + (_153 / 16u)) * uint(16)) + (uint(0) + (_153 % 16u)));
                    uint _169 = ((_148 + 1u) * 16u) + _150;
                    f16vec4 _182 = _91(((uint(0) + (_169 / 16u)) * uint(16)) + (uint(0) + (_169 % 16u)));
                    uint _185 = ((_148 + 2u) * 16u) + _150;
                    f16vec4 _198 = _91(((uint(0) + (_185 / 16u)) * uint(16)) + (uint(0) + (_185 % 16u)));
                    uint _201 = ((_148 + 3u) * 16u) + _150;
                    f16vec4 _214 = _91(((uint(0) + (_201 / 16u)) * uint(16)) + (uint(0) + (_201 % 16u)));
                    _140 = fma(_149, f16vec4(_166.x, _182.x, _198.x, _214.x), _140);
                    _141 = fma(_149, f16vec4(_166.y, _182.y, _198.y, _214.y), _141);
                    _142 = fma(_149, f16vec4(_166.z, _182.z, _198.z, _214.z), _142);
                    _143 = fma(_149, f16vec4(_166.w, _182.w, _198.w, _214.w), _143);
                    _139 = _146 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _108(_144 * 4u, f16vec4(((_140.x + _140.y) + _140.z) + _140.w, ((_141.x + _141.y) + _141.z) + _141.w, ((_142.x + _142.y) + _142.z) + _142.w, ((_143.x + _143.y) + _143.z) + _143.w));
            _138 = _144 + 1u;
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
    _128();
}

