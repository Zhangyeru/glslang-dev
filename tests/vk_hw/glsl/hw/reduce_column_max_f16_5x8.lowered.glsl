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

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

f16vec2 _56(uint _57)
{
    return f16vec2(A.data[_57], A.data[_57 + 1u]);
}

void _232(uint _233, f16vec2 _234)
{
    D.data[_233] = _234.x;
    D.data[_233 + 1u] = _234.y;
}

void main()
{
    uint _75 = 0u;
    f16vec2 _74[20];
    uint _80;
    for (;;)
    {
        _80 = _75;
        if (_80 < 40u)
        {
            _74[_80 / 2u] = _56(((uint(0) + (_80 / 8u)) * uint(8)) + (uint(0) + (_80 % 8u)));
            _75 = _80 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _26[20] = _74;
    f16vec2 tempArg[20] = _26;
    f16vec2 value[20] = _26;
    float16_t _112 = max(max(max(max(_26[0].x, _26[4].x), _26[8].x), _26[12].x), _26[16].x);
    float16_t _126 = max(max(max(max(_26[0].y, _26[4].y), _26[8].y), _26[12].y), _26[16].y);
    float16_t _140 = max(max(max(max(_26[1].x, _26[5].x), _26[9].x), _26[13].x), _26[17].x);
    float16_t _154 = max(max(max(max(_26[1].y, _26[5].y), _26[9].y), _26[13].y), _26[17].y);
    float16_t _168 = max(max(max(max(_26[2].x, _26[6].x), _26[10].x), _26[14].x), _26[18].x);
    float16_t _182 = max(max(max(max(_26[2].y, _26[6].y), _26[10].y), _26[14].y), _26[18].y);
    float16_t _196 = max(max(max(max(_26[3].x, _26[7].x), _26[11].x), _26[15].x), _26[19].x);
    float16_t _210 = max(max(max(max(_26[3].y, _26[7].y), _26[11].y), _26[15].y), _26[19].y);
    f16vec2 _33[20] = f16vec2[](f16vec2(_112, _126), f16vec2(_140, _154), f16vec2(_168, _182), f16vec2(_196, _210), f16vec2(_112, _126), f16vec2(_140, _154), f16vec2(_168, _182), f16vec2(_196, _210), f16vec2(_112, _126), f16vec2(_140, _154), f16vec2(_168, _182), f16vec2(_196, _210), f16vec2(_112, _126), f16vec2(_140, _154), f16vec2(_168, _182), f16vec2(_196, _210), f16vec2(_112, _126), f16vec2(_140, _154), f16vec2(_168, _182), f16vec2(_196, _210));
    f16vec2 reduced[20] = _33;
    f16vec2 _242[20] = _33;
    uint _243 = 0u;
    uint _248;
    for (;;)
    {
        _248 = _243;
        if (_248 < 40u)
        {
            _232(((uint(0) + (_248 / 8u)) * uint(8)) + (uint(0) + (_248 % 8u)), _242[_248 / 2u]);
            _243 = _248 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

