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
    float16_t b1[64];
    float16_t b2[16];
    float16_t b3[8];
} Biases;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[1024];
    float16_t w2[1024];
    float16_t w3[128];
} Weights;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[8];
} OutY;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[64];
} InX;

void tileWeight3(int k0, int col0, inout f16vec4 weight[4])
{
    weight[0] = f16vec4(Weights.w3[(((k0 + 0) * 8) + col0) + 0], Weights.w3[(((k0 + 1) * 8) + col0) + 0], Weights.w3[(((k0 + 2) * 8) + col0) + 0], Weights.w3[(((k0 + 3) * 8) + col0) + 0]);
    weight[1] = f16vec4(Weights.w3[(((k0 + 0) * 8) + col0) + 1], Weights.w3[(((k0 + 1) * 8) + col0) + 1], Weights.w3[(((k0 + 2) * 8) + col0) + 1], Weights.w3[(((k0 + 3) * 8) + col0) + 1]);
    weight[2] = f16vec4(Weights.w3[(((k0 + 0) * 8) + col0) + 2], Weights.w3[(((k0 + 1) * 8) + col0) + 2], Weights.w3[(((k0 + 2) * 8) + col0) + 2], Weights.w3[(((k0 + 3) * 8) + col0) + 2]);
    weight[3] = f16vec4(Weights.w3[(((k0 + 0) * 8) + col0) + 3], Weights.w3[(((k0 + 1) * 8) + col0) + 3], Weights.w3[(((k0 + 2) * 8) + col0) + 3], Weights.w3[(((k0 + 3) * 8) + col0) + 3]);
}

f16vec4 loadBias3(int col0)
{
    return f16vec4(Biases.b3[col0 + 0], Biases.b3[col0 + 1], Biases.b3[col0 + 2], Biases.b3[col0 + 3]);
}

f16vec4 relu4(f16vec4 value)
{
    return max(value, f16vec4(float16_t(0.0)));
}

void storeOutput(int col0, f16vec4 value)
{
    OutY.y[col0 + 0] = value.x;
    OutY.y[col0 + 1] = value.y;
    OutY.y[col0 + 2] = value.z;
    OutY.y[col0 + 3] = value.w;
}

void main()
{
    f16vec2 h2[8];
    for (int outputPair = 0; outputPair < 8; outputPair++)
    {
        int outputCol = outputPair * 2;
        h2[outputPair] = f16vec2(Biases.b2[outputCol + 0], Biases.b2[outputCol + 1]);
    }
    for (int splitBase = 0; splitBase < 64; splitBase += 16)
    {
        for (int hiddenPair = 0; hiddenPair < 8; hiddenPair++)
        {
            int hiddenCol = splitBase + (hiddenPair * 2);
            f16vec2 h1 = f16vec2(Biases.b1[hiddenCol + 0], Biases.b1[hiddenCol + 1]);
            for (int k = 0; k < 16; k++)
            {
                f16vec2 weight = f16vec2(Weights.w1[((k * 64) + hiddenCol) + 0], Weights.w1[((k * 64) + hiddenCol) + 1]);
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
    f16vec4 param_2[4];
    for (int col0 = 0; col0 < 8; col0 += 4)
    {
        f16vec4 rx = f16vec4(float16_t(0.0));
        f16vec4 ry = f16vec4(float16_t(0.0));
        f16vec4 rz = f16vec4(float16_t(0.0));
        f16vec4 rw = f16vec4(float16_t(0.0));
        for (int k0 = 0; k0 < 16; k0 += 4)
        {
            f16vec4 v = f16vec4(h2[k0 / 2], h2[(k0 / 2) + 1]);
            int param = k0;
            int param_1 = col0;
            tileWeight3(param, param_1, param_2);
            f16vec4 weight_1[4] = param_2;
            rx = fma(v, weight_1[0], rx);
            ry = fma(v, weight_1[1], ry);
            rz = fma(v, weight_1[2], rz);
            rw = fma(v, weight_1[3], rw);
        }
        int param_3 = col0;
        f16vec4 param_4 = f16vec4(((rx.x + rx.y) + rx.z) + rx.w, ((ry.x + ry.y) + ry.z) + ry.w, ((rz.x + rz.y) + rz.z) + rz.w, ((rw.x + rw.y) + rw.z) + rw.w) + loadBias3(param_3);
        int param_5 = col0;
        f16vec4 param_6 = relu4(param_4);
        storeOutput(param_5, param_6);
    }
}

