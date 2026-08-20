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

f16vec2 _59(uint _60)
{
    return f16vec2(A.data[_60], A.data[_60 + 1u]);
}

void _135(uint _136, f16vec2 _137)
{
    D.data[_136] = _137.x;
    D.data[_136 + 1u] = _137.y;
}

void main()
{
    uint _78 = 0u;
    f16vec2 _77[32];
    uint _83;
    for (;;)
    {
        _83 = _78;
        if (_83 < 64u)
        {
            _77[_83 / 2u] = _59(((uint(0) + (_83 / 8u)) * uint(8)) + (uint(0) + (_83 % 8u)));
            _78 = _83 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _24[32] = _77;
    f16vec2 tempArg[32] = _24;
    f16vec2 value[32] = _24;
    f16vec2 _107[32] = _24;
    uint _106 = 0u;
    vec2 _105[32];
    uint _112;
    for (;;)
    {
        _112 = _106;
        if (_112 < 32u)
        {
            _105[_112] = vec2(_107[_112]);
            _106 = _112 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 widened[32] = _105;
    vec2 _122[32] = _105;
    uint _121 = 0u;
    f16vec2 _120[32];
    uint _127;
    for (;;)
    {
        _127 = _121;
        if (_127 < 32u)
        {
            _120[_127] = f16vec2(_122[_127]);
            _121 = _127 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _120;
    f16vec2 _145[32] = _120;
    uint _146 = 0u;
    uint _151;
    for (;;)
    {
        _151 = _146;
        if (_151 < 64u)
        {
            _135(((uint(0) + (_151 / 8u)) * uint(8)) + (uint(0) + (_151 % 8u)), _145[_151 / 2u]);
            _146 = _151 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

