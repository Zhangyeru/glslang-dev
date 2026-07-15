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

float16_t reducePair(float16_t lhs, float16_t rhs)
{
    return lhs + rhs;
}

void main()
{
    for (int row = 0; row < 5; row++)
    {
        float16_t reduced = A.data[row * 8];
        for (int col = 1; col < 8; col++)
        {
            float16_t param = reduced;
            float16_t param_1 = A.data[(row * 8) + col];
            reduced = reducePair(param, param_1);
        }
        for (int col_1 = 0; col_1 < 8; col_1++)
        {
            D.data[(row * 8) + col_1] = reduced;
        }
    }
}

