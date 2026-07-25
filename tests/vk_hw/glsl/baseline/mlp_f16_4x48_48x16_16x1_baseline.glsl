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
    float16_t b2[16];
    float16_t b3[1];
} Biases;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[192];
    float16_t w2[768];
    float16_t w3[16];
} Weights;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[48];
} InX;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[1];
} OutY;

float16_t relu(float16_t v)
{
    return max(v, float16_t(0.0));
}

void main()
{
    f16vec2 h2[8];
    for (int outputPair = 0; outputPair < 8; outputPair++)
    {
        int outputCol = outputPair * 2;
        h2[outputPair] = f16vec2(Biases.b2[outputCol + 0], Biases.b2[outputCol + 1]);
    }
    for (int splitBase = 0; splitBase < 48; splitBase += 16)
    {
        for (int hiddenPair = 0; hiddenPair < 8; hiddenPair++)
        {
            int hiddenCol = splitBase + (hiddenPair * 2);
            f16vec2 h1 = f16vec2(Biases.b1[hiddenCol + 0], Biases.b1[hiddenCol + 1]);
            for (int k = 0; k < 4; k++)
            {
                f16vec2 weight = f16vec2(Weights.w1[((k * 48) + hiddenCol) + 0], Weights.w1[((k * 48) + hiddenCol) + 1]);
                h1 = fma(f16vec2(InX.x[k]), weight, h1);
            }
            h1 = max(h1, f16vec2(float16_t(0.0)));
            for (int outputPair_1 = 0; outputPair_1 < 8; outputPair_1++)
            {
                int outputCol_1 = outputPair_1 * 2;
                f16vec2 weight0 = f16vec2(Weights.w2[(((hiddenCol + 0) * 16) + outputCol_1) + 0], Weights.w2[(((hiddenCol + 0) * 16) + outputCol_1) + 1]);
                f16vec2 weight1 = f16vec2(Weights.w2[(((hiddenCol + 1) * 16) + outputCol_1) + 0], Weights.w2[(((hiddenCol + 1) * 16) + outputCol_1) + 1]);
                h2[outputPair_1] = fma(f16vec2(h1.x), weight0, h2[outputPair_1]);
                h2[outputPair_1] = fma(f16vec2(h1.y), weight1, h2[outputPair_1]);
            }
        }
    }
    for (int outputPair_2 = 0; outputPair_2 < 8; outputPair_2++)
    {
        h2[outputPair_2] = max(h2[outputPair_2], f16vec2(float16_t(0.0)));
    }
    float16_t y = Biases.b3[0];
    for (int inputPair = 0; inputPair < 8; inputPair++)
    {
        int inputRow = inputPair * 2;
        y = fma(h2[inputPair].x, Weights.w3[inputRow + 0], y);
        y = fma(h2[inputPair].y, Weights.w3[inputRow + 1], y);
    }
    float16_t param = y;
    OutY.y[0] = relu(param);
}

