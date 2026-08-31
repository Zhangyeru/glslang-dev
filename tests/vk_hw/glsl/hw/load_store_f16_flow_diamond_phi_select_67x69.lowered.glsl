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
    bool takeLeft = gl_LocalInvocationIndex == 0u;
    uint _78 = 0u;
    float16_t _77[4623];
    uint _83;
    for (;;)
    {
        _83 = _78;
        if (_83 < 4623u)
        {
            _77[_83] = A.data[((uint(0) + (_83 / 69u)) * uint(69)) + (uint(0) + (_83 % 69u))];
            _78 = _83 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float16_t _34[4623] = _77;
    float16_t tempArg[4623] = _34;
    float16_t value[4623] = _34;
    float16_t merged[4623];
    if (takeLeft)
    {
        merged = value;
    }
    else
    {
        merged = value;
    }
    float16_t _46[4623];
    if (takeLeft)
    {
        _46 = merged;
    }
    else
    {
        _46 = value;
    }
    float16_t result[4623] = _46;
    float16_t _105[4623] = _46;
    uint _106 = 0u;
    uint _111;
    for (;;)
    {
        _111 = _106;
        if (_111 < 4623u)
        {
            D.data[((uint(0) + (_111 / 69u)) * uint(69)) + (uint(0) + (_111 % 69u))] = _105[_111];
            _106 = _111 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
}

