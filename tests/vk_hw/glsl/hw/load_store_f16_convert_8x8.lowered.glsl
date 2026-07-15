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

void _143(uint _144, f16vec4 _145)
{
    D.data[_144] = _145.x;
    D.data[_144 + 1u] = _145.y;
    D.data[_144 + 2u] = _145.z;
    D.data[_144 + 3u] = _145.w;
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
    f16vec4 _115[16] = _24;
    uint _114 = 0u;
    vec4 _113[16];
    uint _120;
    for (;;)
    {
        _120 = _114;
        if (_120 < 16u)
        {
            _113[_120] = vec4(_115[_120]);
            _114 = _120 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 widened[16] = _113;
    vec4 _130[16] = _113;
    uint _129 = 0u;
    f16vec4 _128[16];
    uint _135;
    for (;;)
    {
        _135 = _129;
        if (_135 < 16u)
        {
            _128[_135] = f16vec4(_130[_135]);
            _129 = _135 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _128;
    f16vec4 _159[16] = _128;
    uint _160 = 0u;
    uint _165;
    for (;;)
    {
        _165 = _160;
        if (_165 < 64u)
        {
            _143(((uint(0) + (_165 / 8u)) * uint(8)) + (uint(0) + (_165 % 8u)), _159[_165 / 4u]);
            _160 = _165 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

