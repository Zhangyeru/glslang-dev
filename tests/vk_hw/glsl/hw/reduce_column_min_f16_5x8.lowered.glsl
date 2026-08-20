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

f16vec2 _55(uint _56)
{
    return f16vec2(A.data[_56], A.data[_56 + 1u]);
}

void _231(uint _232, f16vec2 _233)
{
    D.data[_232] = _233.x;
    D.data[_232 + 1u] = _233.y;
}

void main()
{
    uint _74 = 0u;
    f16vec2 _73[20];
    uint _79;
    for (;;)
    {
        _79 = _74;
        if (_79 < 40u)
        {
            _73[_79 / 2u] = _55(((uint(0) + (_79 / 8u)) * uint(8)) + (uint(0) + (_79 % 8u)));
            _74 = _79 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _26[20] = _73;
    f16vec2 tempArg[20] = _26;
    f16vec2 value[20] = _26;
    float16_t _111 = min(min(min(min(_26[0].x, _26[4].x), _26[8].x), _26[12].x), _26[16].x);
    float16_t _125 = min(min(min(min(_26[0].y, _26[4].y), _26[8].y), _26[12].y), _26[16].y);
    float16_t _139 = min(min(min(min(_26[1].x, _26[5].x), _26[9].x), _26[13].x), _26[17].x);
    float16_t _153 = min(min(min(min(_26[1].y, _26[5].y), _26[9].y), _26[13].y), _26[17].y);
    float16_t _167 = min(min(min(min(_26[2].x, _26[6].x), _26[10].x), _26[14].x), _26[18].x);
    float16_t _181 = min(min(min(min(_26[2].y, _26[6].y), _26[10].y), _26[14].y), _26[18].y);
    float16_t _195 = min(min(min(min(_26[3].x, _26[7].x), _26[11].x), _26[15].x), _26[19].x);
    float16_t _209 = min(min(min(min(_26[3].y, _26[7].y), _26[11].y), _26[15].y), _26[19].y);
    f16vec2 _32[20] = f16vec2[](f16vec2(_111, _125), f16vec2(_139, _153), f16vec2(_167, _181), f16vec2(_195, _209), f16vec2(_111, _125), f16vec2(_139, _153), f16vec2(_167, _181), f16vec2(_195, _209), f16vec2(_111, _125), f16vec2(_139, _153), f16vec2(_167, _181), f16vec2(_195, _209), f16vec2(_111, _125), f16vec2(_139, _153), f16vec2(_167, _181), f16vec2(_195, _209), f16vec2(_111, _125), f16vec2(_139, _153), f16vec2(_167, _181), f16vec2(_195, _209));
    f16vec2 reduced[20] = _32;
    f16vec2 _241[20] = _32;
    uint _242 = 0u;
    uint _247;
    for (;;)
    {
        _247 = _242;
        if (_247 < 40u)
        {
            _231(((uint(0) + (_247 / 8u)) * uint(8)) + (uint(0) + (_247 % 8u)), _241[_247 / 2u]);
            _242 = _247 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

