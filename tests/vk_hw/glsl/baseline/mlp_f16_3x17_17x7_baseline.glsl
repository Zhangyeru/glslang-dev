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

layout(set = 0, binding = 2, std430) buffer PackedBias
{
    float16_t b1[17];
    float16_t b2[7];
} Biases;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[3];
} InX;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[51];
    float16_t w2[119];
} Weights;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[7];
} OutY;

void main()
{
    float16_t hidden[17];
    for (int col = 0; col < 17; col++)
    {
        float16_t acc = Biases.b1[col];
        for (int k = 0; k < 3; k++)
        {
            acc = fma(InX.x[k], Weights.w1[(k * 17) + col], acc);
        }
        hidden[col] = max(acc, float16_t(0.0));
    }
    for (int col_1 = 0; col_1 < 7; col_1++)
    {
        float16_t acc_1 = Biases.b2[col_1];
        for (int k_1 = 0; k_1 < 17; k_1++)
        {
            acc_1 = fma(hidden[k_1], Weights.w2[(k_1 * 7) + col_1], acc_1);
        }
        OutY.y[col_1] = max(acc_1, float16_t(0.0));
    }
}

