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
        if (_143 < 8u)
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
                if (_145 < 16u)
                {
                    f16vec4 _147 = _72(_145);
                    f16vec4 _151 = _90(((_145 + 0u) * 8u) + _143);
                    f16vec4 _155 = _90(((_145 + 1u) * 8u) + _143);
                    f16vec4 _159 = _90(((_145 + 2u) * 8u) + _143);
                    f16vec4 _163 = _90(((_145 + 3u) * 8u) + _143);
                    _139 = fma(_147, f16vec4(_151.x, _155.x, _159.x, _163.x), _139);
                    _140 = fma(_147, f16vec4(_151.y, _155.y, _159.y, _163.y), _140);
                    _141 = fma(_147, f16vec4(_151.z, _155.z, _159.z, _163.z), _141);
                    _142 = fma(_147, f16vec4(_151.w, _155.w, _159.w, _163.w), _142);
                    _138 = _145 + 4u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _107(_143, f16vec4(((_139.x + _139.y) + _139.z) + _139.w, ((_140.x + _140.y) + _140.z) + _140.w, ((_141.x + _141.y) + _141.z) + _141.w, ((_142.x + _142.y) + _142.z) + _142.w));
            _137 = _143 + 4u;
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

