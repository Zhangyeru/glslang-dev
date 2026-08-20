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

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

f16vec2 _77(uint _78)
{
    return f16vec2(A.data[_78], A.data[_78 + 1u]);
}

f16vec2 _89(uint _90)
{
    return f16vec2(B.data[_90], B.data[_90 + 1u]);
}

f16vec2 _99(uint _100)
{
    return f16vec2(C.data[_100], C.data[_100 + 1u]);
}

void _110(uint _111, f16vec2 _112)
{
    D.data[_111] = _112.x;
    D.data[_111 + 1u] = _112.y;
}

void _126()
{
    uint _140 = 0u;
    uint _145;
    for (;;)
    {
        _145 = _140;
        if (_145 < 16u)
        {
            uint _141 = 0u;
            uint _147;
            for (;;)
            {
                _147 = _141;
                if (_147 < 16u)
                {
                    f16vec2 _143 = f16vec2(float16_t(0.0));
                    f16vec2 _144 = f16vec2(float16_t(0.0));
                    uint _142 = 0u;
                    uint _149;
                    for (;;)
                    {
                        _149 = _142;
                        if (_149 < 8u)
                        {
                            uint _151 = _149 * 2u;
                            uint _153 = (_145 * 16u) + _151;
                            f16vec2 _166 = _77(((uint(0) + (_153 / 16u)) * uint(16)) + (uint(0) + (_153 % 16u)));
                            uint _170 = ((_151 + 0u) * 32u) + (_147 * 2u);
                            f16vec2 _183 = _89(((uint(0) + (_170 / 32u)) * uint(32)) + (uint(0) + (_170 % 32u)));
                            uint _187 = ((_151 + 1u) * 32u) + (_147 * 2u);
                            f16vec2 _200 = _89(((uint(0) + (_187 / 32u)) * uint(32)) + (uint(0) + (_187 % 32u)));
                            _143 = fma(_166, f16vec2(_183.x, _200.x), _143);
                            _144 = fma(_166, f16vec2(_183.y, _200.y), _144);
                            _142 = _149 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _214 = (_145 * 32u) + (_147 * 2u);
                    f16vec2 _227 = _99(((uint(0) + (_214 / 32u)) * uint(32)) + (uint(0) + (_214 % 32u)));
                    uint _243 = (_145 * 32u) + (_147 * 2u);
                    _110(((uint(0) + (_243 / 32u)) * uint(32)) + (uint(0) + (_243 % 32u)), f16vec2(_227.x + (_143.x + _143.y), _227.y + (_144.x + _144.y)));
                    _141 = _147 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _140 = _145 + 1u;
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
    _126();
}

