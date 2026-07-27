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
    float16_t b1[48];
    float16_t b2[8];
    float16_t b3[48];
    float16_t b4[8];
    float16_t b5[4];
} Biases;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[384];
    float16_t w2[384];
    float16_t w3[384];
    float16_t w4[384];
    float16_t w5[32];
} Weights;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[48];
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
    for (int splitBegin = 0; splitBegin < 48; splitBegin += 16)
    {
        int splitEnd = min((splitBegin + 16), 48);
        for (int hidden = splitBegin; hidden < splitEnd; hidden += 2)
        {
            f16vec2 h1 = f16vec2(Biases.b1[hidden], Biases.b1[hidden + 1]);
            for (int k = 0; k < 8; k++)
            {
                f16vec2 weight = f16vec2(Weights.w1[(k * 48) + hidden], Weights.w1[((k * 48) + hidden) + 1]);
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
    f16vec2 h4[4];
    for (int outputPair_3 = 0; outputPair_3 < 4; outputPair_3++)
    {
        int outputBase_2 = outputPair_3 * 2;
        h4[outputPair_3] = f16vec2(Biases.b4[outputBase_2], Biases.b4[outputBase_2 + 1]);
    }
    for (int splitBegin_1 = 0; splitBegin_1 < 48; splitBegin_1 += 16)
    {
        int splitEnd_1 = min((splitBegin_1 + 16), 48);
        for (int hidden_1 = splitBegin_1; hidden_1 < splitEnd_1; hidden_1 += 2)
        {
            f16vec2 h3 = f16vec2(Biases.b3[hidden_1], Biases.b3[hidden_1 + 1]);
            for (int k_1 = 0; k_1 < 8; k_1++)
            {
                float16_t inputValue = h2[k_1 / 2][k_1 % 2];
                f16vec2 weight_1 = f16vec2(Weights.w3[(k_1 * 48) + hidden_1], Weights.w3[((k_1 * 48) + hidden_1) + 1]);
                h3 = fma(f16vec2(inputValue), weight_1, h3);
            }
            f16vec2 param_2 = h3;
            h3 = relu2(param_2);
            for (int outputPair_4 = 0; outputPair_4 < 4; outputPair_4++)
            {
                int outputBase_3 = outputPair_4 * 2;
                f16vec2 weight0_1 = f16vec2(Weights.w4[(hidden_1 * 8) + outputBase_3], Weights.w4[((hidden_1 * 8) + outputBase_3) + 1]);
                f16vec2 weight1_1 = f16vec2(Weights.w4[((hidden_1 + 1) * 8) + outputBase_3], Weights.w4[(((hidden_1 + 1) * 8) + outputBase_3) + 1]);
                h4[outputPair_4] = fma(f16vec2(h3.x), weight0_1, h4[outputPair_4]);
                h4[outputPair_4] = fma(f16vec2(h3.y), weight1_1, h4[outputPair_4]);
            }
        }
    }
    for (int outputPair_5 = 0; outputPair_5 < 4; outputPair_5++)
    {
        f16vec2 param_3 = h4[outputPair_5];
        h4[outputPair_5] = relu2(param_3);
    }
    f16vec4 acc0 = f16vec4(float16_t(0.0));
    f16vec4 acc1 = f16vec4(float16_t(0.0));
    f16vec4 acc2 = f16vec4(float16_t(0.0));
    f16vec4 acc3 = f16vec4(float16_t(0.0));
    for (int block = 0; block < 2; block++)
    {
        int k_2 = block * 4;
        f16vec4 value = f16vec4(h4[block * 2], h4[(block * 2) + 1]);
        acc0 = fma(value, f16vec4(Weights.w5[((k_2 + 0) * 4) + 0], Weights.w5[((k_2 + 1) * 4) + 0], Weights.w5[((k_2 + 2) * 4) + 0], Weights.w5[((k_2 + 3) * 4) + 0]), acc0);
        acc1 = fma(value, f16vec4(Weights.w5[((k_2 + 0) * 4) + 1], Weights.w5[((k_2 + 1) * 4) + 1], Weights.w5[((k_2 + 2) * 4) + 1], Weights.w5[((k_2 + 3) * 4) + 1]), acc1);
        acc2 = fma(value, f16vec4(Weights.w5[((k_2 + 0) * 4) + 2], Weights.w5[((k_2 + 1) * 4) + 2], Weights.w5[((k_2 + 2) * 4) + 2], Weights.w5[((k_2 + 3) * 4) + 2]), acc2);
        acc3 = fma(value, f16vec4(Weights.w5[((k_2 + 0) * 4) + 3], Weights.w5[((k_2 + 1) * 4) + 3], Weights.w5[((k_2 + 2) * 4) + 3], Weights.w5[((k_2 + 3) * 4) + 3]), acc3);
    }
    f16vec4 param_4 = f16vec4(((acc0.x + acc0.y) + acc0.z) + acc0.w, ((acc1.x + acc1.y) + acc1.z) + acc1.w, ((acc2.x + acc2.y) + acc2.z) + acc2.w, ((acc3.x + acc3.y) + acc3.z) + acc3.w) + f16vec4(Biases.b5[0], Biases.b5[1], Biases.b5[2], Biases.b5[3]);
    f16vec4 result = relu4(param_4);
    OutY.y[0] = result.x;
    OutY.y[1] = result.y;
    OutY.y[2] = result.z;
    OutY.y[3] = result.w;
}

