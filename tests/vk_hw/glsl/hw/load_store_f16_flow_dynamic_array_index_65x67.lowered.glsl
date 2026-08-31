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
    uint dynamicIndex = gl_LocalInvocationIndex & 1u;
    uint _71 = 0u;
    float16_t _70[4355];
    uint _76;
    for (;;)
    {
        _76 = _71;
        if (_76 < 4355u)
        {
            _70[_76] = A.data[((uint(0) + (_76 / 67u)) * uint(67)) + (uint(0) + (_76 % 67u))];
            _71 = _76 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float16_t _33[4355] = _70;
    float16_t tempArg[4355] = _33;
    float16_t value[4355] = _33;
    float16_t values[2][4355];
    values[dynamicIndex] = _33;
    float16_t result[4355] = values[dynamicIndex];
    float16_t _98[4355] = values[dynamicIndex];
    uint _99 = 0u;
    uint _104;
    for (;;)
    {
        _104 = _99;
        if (_104 < 4355u)
        {
            D.data[((uint(0) + (_104 / 67u)) * uint(67)) + (uint(0) + (_104 % 67u))] = _98[_104];
            _99 = _104 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
}

