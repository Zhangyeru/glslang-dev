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

layout(set = 0, binding = 3, std430) buffer ScaleBuf
{
    float16_t data[];
} S;

layout(set = 0, binding = 1, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 2, std430) buffer OutputD
{
    float16_t data[];
} D;

void main()
{
    float16_t scale = S.data[0];
    for (int row = 0; row < 8; row++)
    {
        for (int col = 0; col < 8; col++)
        {
            float16_t acc = C.data[(row * 8) + col];
            for (int inner = 0; inner < 8; inner++)
            {
                acc = fma(A.data[(row * 8) + inner], scale, acc);
            }
            D.data[(row * 8) + col] = acc;
        }
    }
}

