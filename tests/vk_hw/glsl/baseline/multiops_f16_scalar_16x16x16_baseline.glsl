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

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

void main()
{
    for (int row = 0; row < 16; row++)
    {
        for (int col = 0; col < 16; col++)
        {
            float16_t d0 = C.data[(row * 16) + col];
            for (int k = 0; k < 16; k++)
            {
                d0 += (A.data[(row * 16) + k] * B.data[(k * 16) + col]);
            }
            float16_t d1 = d0;
            for (int k_1 = 0; k_1 < 16; k_1++)
            {
                d1 += (A.data[(row * 16) + k_1] * B.data[(k_1 * 16) + col]);
            }
            D.data[(row * 16) + col] = d1;
        }
    }
    for (int col_1 = 0; col_1 < 16; col_1++)
    {
        float16_t vec = float16_t(0.0);
        for (int k_2 = 0; k_2 < 16; k_2++)
        {
            vec += (A.data[k_2] * B.data[(k_2 * 16) + col_1]);
        }
        D.data[col_1] += vec;
        D.data[col_1] += vec;
    }
}

