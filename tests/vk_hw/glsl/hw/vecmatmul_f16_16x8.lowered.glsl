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

f16vec4 _90(uint _91)
{
    return f16vec4(W.data[_91], W.data[_91 + 1u], W.data[_91 + 2u], W.data[_91 + 3u]);
}

void _107(uint _108, f16vec4 _109)
{
    Y.data[_108] = _109.x;
    Y.data[_108 + 1u] = _109.y;
    Y.data[_108 + 2u] = _109.z;
    Y.data[_108 + 3u] = _109.w;
}

void _127()
{
    uint _137 = 0u;
    uint _143;
    for (;;)
    {
        _143 = _137;
        if (_143 < 2u)
        {
            f16vec4 _139 = f16vec4(float16_t(0.0));
            f16vec4 _140 = f16vec4(float16_t(0.0));
            f16vec4 _141 = f16vec4(float16_t(0.0));
            f16vec4 _142 = f16vec4(float16_t(0.0));
            uint _138 = 0u;
            uint _145;
            for (;;)
            {
                _145 = _138;
                if (_145 < 4u)
                {
                    uint _147 = _145 * 4u;
                    f16vec4 _148 = _72(_147);
                    uint _149 = _143 * 4u;
                    uint _152 = ((_147 + 0u) * 8u) + _149;
                    f16vec4 _165 = _90(((uint(0) + (_152 / 8u)) * uint(8)) + (uint(0) + (_152 % 8u)));
                    uint _168 = ((_147 + 1u) * 8u) + _149;
                    f16vec4 _181 = _90(((uint(0) + (_168 / 8u)) * uint(8)) + (uint(0) + (_168 % 8u)));
                    uint _184 = ((_147 + 2u) * 8u) + _149;
                    f16vec4 _197 = _90(((uint(0) + (_184 / 8u)) * uint(8)) + (uint(0) + (_184 % 8u)));
                    uint _200 = ((_147 + 3u) * 8u) + _149;
                    f16vec4 _213 = _90(((uint(0) + (_200 / 8u)) * uint(8)) + (uint(0) + (_200 % 8u)));
                    _139 = fma(_148, f16vec4(_165.x, _181.x, _197.x, _213.x), _139);
                    _140 = fma(_148, f16vec4(_165.y, _181.y, _197.y, _213.y), _140);
                    _141 = fma(_148, f16vec4(_165.z, _181.z, _197.z, _213.z), _141);
                    _142 = fma(_148, f16vec4(_165.w, _181.w, _197.w, _213.w), _142);
                    _138 = _145 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _107(_143 * 4u, f16vec4(((_139.x + _139.y) + _139.z) + _139.w, ((_140.x + _140.y) + _140.z) + _140.w, ((_141.x + _141.y) + _141.z) + _141.w, ((_142.x + _142.y) + _142.z) + _142.w));
            _137 = _143 + 1u;
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
    _127();
}

