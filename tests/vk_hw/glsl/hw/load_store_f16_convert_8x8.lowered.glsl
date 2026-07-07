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

f16vec4 _59(uint _60)
{
    return f16vec4(A.data[_60], A.data[_60 + 1u], A.data[_60 + 2u], A.data[_60 + 3u]);
}

void _175(uint _176, f16vec4 _177)
{
    D.data[_176] = _177.x;
    D.data[_176 + 1u] = _177.y;
    D.data[_176 + 2u] = _177.z;
    D.data[_176 + 3u] = _177.w;
}

void main()
{
    uint _86 = 0u;
    f16vec4 _85[16];
    uint _91;
    for (;;)
    {
        _91 = _86;
        if (_91 < 64u)
        {
            _85[_91 / 4u] = _59(((uint(0) + (_91 / 8u)) * uint(8)) + (uint(0) + (_91 % 8u)));
            _86 = _91 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _24[16] = _85;
    f16vec4 tempArg[16] = _24;
    f16vec4 value[16] = _24;
    vec4 _32[16] = vec4[](vec4(_24[0]), vec4(_24[1]), vec4(_24[2]), vec4(_24[3]), vec4(_24[4]), vec4(_24[5]), vec4(_24[6]), vec4(_24[7]), vec4(_24[8]), vec4(_24[9]), vec4(_24[10]), vec4(_24[11]), vec4(_24[12]), vec4(_24[13]), vec4(_24[14]), vec4(_24[15]));
    vec4 widened[16] = _32;
    f16vec4 _34[16] = f16vec4[](f16vec4(_32[0]), f16vec4(_32[1]), f16vec4(_32[2]), f16vec4(_32[3]), f16vec4(_32[4]), f16vec4(_32[5]), f16vec4(_32[6]), f16vec4(_32[7]), f16vec4(_32[8]), f16vec4(_32[9]), f16vec4(_32[10]), f16vec4(_32[11]), f16vec4(_32[12]), f16vec4(_32[13]), f16vec4(_32[14]), f16vec4(_32[15]));
    value = _34;
    f16vec4 _191[16] = _34;
    uint _192 = 0u;
    uint _197;
    for (;;)
    {
        _197 = _192;
        if (_197 < 64u)
        {
            _175(((uint(0) + (_197 / 8u)) * uint(8)) + (uint(0) + (_197 % 8u)), _191[_197 / 4u]);
            _192 = _197 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

