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
    float16_t b1[8];
    float16_t b2[48];
    float16_t b3[8];
    float16_t b4[48];
    float16_t b5[4];
} Biases;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[48];
} InX;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[64];
    float16_t w2[384];
    float16_t w3[384];
    float16_t w4[384];
    float16_t w5[192];
} Weights;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[4];
} OutY;

f16vec2 relu2(f16vec2 value)
{
    return max(value, f16vec2(float16_t(0.0)));
}

void main()
{
    float16_t h1[8];
    for (int col = 0; col < 8; col++)
    {
        float16_t acc = Biases.b1[col];
        for (int k = 0; k < 8; k++)
        {
            acc = fma(InX.x[k], Weights.w1[(k * 8) + col], acc);
        }
        h1[col] = max(acc, float16_t(0.0));
    }
    f16vec2 h3[4];
    for (int outputPair = 0; outputPair < 4; outputPair++)
    {
        int outputBase = outputPair * 2;
        h3[outputPair] = f16vec2(Biases.b3[outputBase], Biases.b3[outputBase + 1]);
    }
    for (int splitBegin = 0; splitBegin < 48; splitBegin += 16)
    {
        int splitEnd = min((splitBegin + 16), 48);
        for (int hidden = splitBegin; hidden < splitEnd; hidden += 2)
        {
            f16vec2 h2 = f16vec2(Biases.b2[hidden], Biases.b2[hidden + 1]);
            for (int k_1 = 0; k_1 < 8; k_1++)
            {
                f16vec2 weight = f16vec2(Weights.w2[(k_1 * 48) + hidden], Weights.w2[((k_1 * 48) + hidden) + 1]);
                h2 = fma(f16vec2(h1[k_1]), weight, h2);
            }
            f16vec2 param = h2;
            h2 = relu2(param);
            for (int outputPair_1 = 0; outputPair_1 < 4; outputPair_1++)
            {
                int outputBase_1 = outputPair_1 * 2;
                f16vec2 weight0 = f16vec2(Weights.w3[(hidden * 8) + outputBase_1], Weights.w3[((hidden * 8) + outputBase_1) + 1]);
                f16vec2 weight1 = f16vec2(Weights.w3[((hidden + 1) * 8) + outputBase_1], Weights.w3[(((hidden + 1) * 8) + outputBase_1) + 1]);
                h3[outputPair_1] = fma(f16vec2(h2.x), weight0, h3[outputPair_1]);
                h3[outputPair_1] = fma(f16vec2(h2.y), weight1, h3[outputPair_1]);
            }
        }
    }
    for (int outputPair_2 = 0; outputPair_2 < 4; outputPair_2++)
    {
        f16vec2 param_1 = h3[outputPair_2];
        h3[outputPair_2] = relu2(param_1);
    }
    f16vec2 y_acc[2];
    for (int outputPair_3 = 0; outputPair_3 < 2; outputPair_3++)
    {
        int outputBase_2 = outputPair_3 * 2;
        y_acc[outputPair_3] = f16vec2(Biases.b5[outputBase_2], Biases.b5[outputBase_2 + 1]);
    }
    for (int splitBegin_1 = 0; splitBegin_1 < 48; splitBegin_1 += 16)
    {
        int splitEnd_1 = min((splitBegin_1 + 16), 48);
        for (int hidden_1 = splitBegin_1; hidden_1 < splitEnd_1; hidden_1 += 2)
        {
            f16vec2 h4 = f16vec2(Biases.b4[hidden_1], Biases.b4[hidden_1 + 1]);
            for (int k_2 = 0; k_2 < 8; k_2++)
            {
                float16_t inputValue = h3[k_2 / 2][k_2 % 2];
                f16vec2 weight_1 = f16vec2(Weights.w4[(k_2 * 48) + hidden_1], Weights.w4[((k_2 * 48) + hidden_1) + 1]);
                h4 = fma(f16vec2(inputValue), weight_1, h4);
            }
            f16vec2 param_2 = h4;
            h4 = relu2(param_2);
            for (int outputPair_4 = 0; outputPair_4 < 2; outputPair_4++)
            {
                int outputBase_3 = outputPair_4 * 2;
                f16vec2 weight0_1 = f16vec2(Weights.w5[(hidden_1 * 4) + outputBase_3], Weights.w5[((hidden_1 * 4) + outputBase_3) + 1]);
                f16vec2 weight1_1 = f16vec2(Weights.w5[((hidden_1 + 1) * 4) + outputBase_3], Weights.w5[(((hidden_1 + 1) * 4) + outputBase_3) + 1]);
                y_acc[outputPair_4] = fma(f16vec2(h4.x), weight0_1, y_acc[outputPair_4]);
                y_acc[outputPair_4] = fma(f16vec2(h4.y), weight1_1, y_acc[outputPair_4]);
            }
        }
    }
    for (int outputPair_5 = 0; outputPair_5 < 2; outputPair_5++)
    {
        f16vec2 param_3 = y_acc[outputPair_5];
        y_acc[outputPair_5] = relu2(param_3);
    }
    OutY.y[0] = y_acc[0].x;
    OutY.y[1] = y_acc[0].y;
    OutY.y[2] = y_acc[1].x;
    OutY.y[3] = y_acc[1].y;
}

