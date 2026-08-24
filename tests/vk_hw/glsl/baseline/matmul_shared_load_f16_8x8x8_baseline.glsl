#version 460
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 2, std430) buffer InputC0
{
    float16_t data[];
} C0;

layout(set = 0, binding = 3, std430) buffer InputC1
{
    float16_t data[];
} C1;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer Weight
{
    float16_t data[];
} W;

layout(set = 0, binding = 4, std430) buffer OutputD0
{
    float16_t data[];
} D0;

layout(set = 0, binding = 5, std430) buffer OutputD1
{
    float16_t data[];
} D1;

void main()
{
    for (int row = 0; row < 8; row++)
    {
        for (int col = 0; col < 8; col++)
        {
            float16_t acc0 = C0.data[(row * 8) + col];
            float16_t acc1 = C1.data[(row * 8) + col];
            for (int inner = 0; inner < 8; inner++)
            {
                acc0 = fma(A.data[(row * 8) + inner], W.data[(inner * 8) + col], acc0);
                acc1 = fma(A.data[(row * 8) + inner], W.data[(inner * 8) + col], acc1);
            }
            D0.data[(row * 8) + col] = acc0;
            D1.data[(row * 8) + col] = acc1;
        }
    }
}

