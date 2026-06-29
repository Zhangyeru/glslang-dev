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

f16vec4 _49(uint _50)
{
    return f16vec4(A.data[_50], A.data[_50 + 1u], A.data[_50 + 2u], A.data[_50 + 3u]);
}

void _101(uint _102, f16vec4 _103)
{
    D.data[_102] = _103.x;
    D.data[_102 + 1u] = _103.y;
    D.data[_102 + 2u] = _103.z;
    D.data[_102 + 3u] = _103.w;
}

void main()
{
    uint _76 = 0u;
    f16vec4 _75[16];
    uint _81;
    for (;;)
    {
        _81 = _76;
        if (_81 < 64u)
        {
            _75[_81 / 4u] = _49(((uint(0) + (_81 / 8u)) * uint(8)) + (uint(0) + (_81 % 8u)));
            _76 = _81 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _24[16] = _75;
    f16vec4 tempArg[16] = _24;
    f16vec4 value[16] = _24;
    f16vec4 _117[16] = _24;
    uint _118 = 0u;
    uint _123;
    for (;;)
    {
        _123 = _118;
        if (_123 < 64u)
        {
            _101(((uint(0) + (_123 / 8u)) * uint(8)) + (uint(0) + (_123 % 8u)), _117[_123 / 4u]);
            _118 = _123 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

