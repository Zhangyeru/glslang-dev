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

void main()
{
    uint _59 = 0u;
    float16_t _58[5183];
    uint _64;
    for (;;)
    {
        _64 = _59;
        if (_64 < 5183u)
        {
            _58[_64] = A.data[((uint(0) + (_64 / 73u)) * uint(73)) + (uint(0) + (_64 % 73u))];
            _59 = _64 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float16_t _26[5183] = _58;
    float16_t tempArg[5183] = _26;
    float16_t value[5183] = _26;
    float16_t _88[5183] = _26;
    uint _87 = 0u;
    float16_t _86[5183];
    uint _93;
    for (;;)
    {
        _93 = _87;
        if (_93 < 5183u)
        {
            _86[_93] = -_88[_93];
            _87 = _93 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float16_t _102[5183] = _86;
    uint _101 = 0u;
    float16_t _100[5183];
    uint _107;
    for (;;)
    {
        _107 = _101;
        if (_107 < 5183u)
        {
            _100[_107] = -_102[_107];
            _101 = _107 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _100;
    float16_t _114[5183] = _100;
    uint _115 = 0u;
    uint _120;
    for (;;)
    {
        _120 = _115;
        if (_120 < 5183u)
        {
            D.data[((uint(0) + (_120 / 73u)) * uint(73)) + (uint(0) + (_120 % 73u))] = _114[_120];
            _115 = _120 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
}

