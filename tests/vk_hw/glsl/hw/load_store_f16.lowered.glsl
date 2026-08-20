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

f16vec2 _49(uint _50)
{
    return f16vec2(A.data[_50], A.data[_50 + 1u]);
}

void _93(uint _94, f16vec2 _95)
{
    D.data[_94] = _95.x;
    D.data[_94 + 1u] = _95.y;
}

void main()
{
    uint _68 = 0u;
    f16vec2 _67[32];
    uint _73;
    for (;;)
    {
        _73 = _68;
        if (_73 < 64u)
        {
            _67[_73 / 2u] = _49(((uint(0) + (_73 / 8u)) * uint(8)) + (uint(0) + (_73 % 8u)));
            _68 = _73 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _24[32] = _67;
    f16vec2 tempArg[32] = _24;
    f16vec2 value[32] = _24;
    f16vec2 _103[32] = _24;
    uint _104 = 0u;
    uint _109;
    for (;;)
    {
        _109 = _104;
        if (_109 < 64u)
        {
            _93(((uint(0) + (_109 / 8u)) * uint(8)) + (uint(0) + (_109 % 8u)), _103[_109 / 2u]);
            _104 = _109 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

