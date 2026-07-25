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
    float16_t b1[36];
    float16_t b2[8];
    float16_t b3[4];
} Biases;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[288];
    float16_t w2[288];
    float16_t w3[32];
} Weights;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[36];
} InX;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[4];
} OutY;

f16vec2 relu2(f16vec2 value)
{
    return max(value, f16vec2(float16_t(0.0)));
}

f16vec4 relu4(f16vec4 value)
{
    return max(value, f16vec4(float16_t(0.0)));
}

void main()
{
    f16vec2 h2[4];
    for (int outputPair = 0; outputPair < 4; outputPair++)
    {
        int outputBase = outputPair * 2;
        h2[outputPair] = f16vec2(Biases.b2[outputBase], Biases.b2[outputBase + 1]);
    }
    for (int splitBegin = 0; splitBegin < 36; splitBegin += 16)
    {
        int splitEnd = min((splitBegin + 16), 36);
        for (int hidden = splitBegin; hidden < splitEnd; hidden += 2)
        {
            f16vec2 h1 = f16vec2(Biases.b1[hidden], Biases.b1[hidden + 1]);
            for (int k = 0; k < 8; k++)
            {
                f16vec2 weight = f16vec2(Weights.w1[(k * 36) + hidden], Weights.w1[((k * 36) + hidden) + 1]);
                h1 = fma(f16vec2(InX.x[k]), weight, h1);
            }
            f16vec2 param = h1;
            h1 = relu2(param);
            for (int outputPair_1 = 0; outputPair_1 < 4; outputPair_1++)
            {
                int outputBase_1 = outputPair_1 * 2;
                f16vec2 weight0 = f16vec2(Weights.w2[(hidden * 8) + outputBase_1], Weights.w2[((hidden * 8) + outputBase_1) + 1]);
                f16vec2 weight1 = f16vec2(Weights.w2[((hidden + 1) * 8) + outputBase_1], Weights.w2[(((hidden + 1) * 8) + outputBase_1) + 1]);
                h2[outputPair_1] = fma(f16vec2(h1.x), weight0, h2[outputPair_1]);
                h2[outputPair_1] = fma(f16vec2(h1.y), weight1, h2[outputPair_1]);
            }
        }
    }
    for (int outputPair_2 = 0; outputPair_2 < 4; outputPair_2++)
    {
        f16vec2 param_1 = h2[outputPair_2];
        h2[outputPair_2] = relu2(param_1);
    }
    f16vec4 acc0 = f16vec4(float16_t(0.0));
    f16vec4 acc1 = f16vec4(float16_t(0.0));
    f16vec4 acc2 = f16vec4(float16_t(0.0));
    f16vec4 acc3 = f16vec4(float16_t(0.0));
    for (int block = 0; block < 2; block++)
    {
        int k_1 = block * 4;
        f16vec4 value = f16vec4(h2[block * 2], h2[(block * 2) + 1]);
        acc0 = fma(value, f16vec4(Weights.w3[((k_1 + 0) * 4) + 0], Weights.w3[((k_1 + 1) * 4) + 0], Weights.w3[((k_1 + 2) * 4) + 0], Weights.w3[((k_1 + 3) * 4) + 0]), acc0);
        acc1 = fma(value, f16vec4(Weights.w3[((k_1 + 0) * 4) + 1], Weights.w3[((k_1 + 1) * 4) + 1], Weights.w3[((k_1 + 2) * 4) + 1], Weights.w3[((k_1 + 3) * 4) + 1]), acc1);
        acc2 = fma(value, f16vec4(Weights.w3[((k_1 + 0) * 4) + 2], Weights.w3[((k_1 + 1) * 4) + 2], Weights.w3[((k_1 + 2) * 4) + 2], Weights.w3[((k_1 + 3) * 4) + 2]), acc2);
        acc3 = fma(value, f16vec4(Weights.w3[((k_1 + 0) * 4) + 3], Weights.w3[((k_1 + 1) * 4) + 3], Weights.w3[((k_1 + 2) * 4) + 3], Weights.w3[((k_1 + 3) * 4) + 3]), acc3);
    }
    f16vec4 param_2 = f16vec4(((acc0.x + acc0.y) + acc0.z) + acc0.w, ((acc1.x + acc1.y) + acc1.z) + acc1.w, ((acc2.x + acc2.y) + acc2.z) + acc2.w, ((acc3.x + acc3.y) + acc3.z) + acc3.w) + f16vec4(Biases.b3[0], Biases.b3[1], Biases.b3[2], Biases.b3[3]);
    f16vec4 result = relu4(param_2);
    OutY.y[0] = result.x;
    OutY.y[1] = result.y;
    OutY.y[2] = result.z;
    OutY.y[3] = result.w;
}

