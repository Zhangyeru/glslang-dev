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

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[64];
} InX;

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

f16vec4 loadInput(int k0)
{
    return f16vec4(InX.x[k0 + 0], InX.x[k0 + 1], InX.x[k0 + 2], InX.x[k0 + 3]);
}

void tileWeight1(int k0, int col0, inout f16vec4 weight[4])
{
    weight[0] = f16vec4(Weights.w1[(((k0 + 0) * 64) + col0) + 0], Weights.w1[(((k0 + 1) * 64) + col0) + 0], Weights.w1[(((k0 + 2) * 64) + col0) + 0], Weights.w1[(((k0 + 3) * 64) + col0) + 0]);
    weight[1] = f16vec4(Weights.w1[(((k0 + 0) * 64) + col0) + 1], Weights.w1[(((k0 + 1) * 64) + col0) + 1], Weights.w1[(((k0 + 2) * 64) + col0) + 1], Weights.w1[(((k0 + 3) * 64) + col0) + 1]);
    weight[2] = f16vec4(Weights.w1[(((k0 + 0) * 64) + col0) + 2], Weights.w1[(((k0 + 1) * 64) + col0) + 2], Weights.w1[(((k0 + 2) * 64) + col0) + 2], Weights.w1[(((k0 + 3) * 64) + col0) + 2]);
    weight[3] = f16vec4(Weights.w1[(((k0 + 0) * 64) + col0) + 3], Weights.w1[(((k0 + 1) * 64) + col0) + 3], Weights.w1[(((k0 + 2) * 64) + col0) + 3], Weights.w1[(((k0 + 3) * 64) + col0) + 3]);
}

f16vec4 loadBias1(int col0)
{
    return f16vec4(Biases.b1[col0 + 0], Biases.b1[col0 + 1], Biases.b1[col0 + 2], Biases.b1[col0 + 3]);
}

f16vec4 relu4(f16vec4 value)
{
    return max(value, f16vec4(float16_t(0.0)));
}

void tileWeight2(int k0, int col0, inout f16vec4 weight[4])
{
    weight[0] = f16vec4(Weights.w2[(((k0 + 0) * 16) + col0) + 0], Weights.w2[(((k0 + 1) * 16) + col0) + 0], Weights.w2[(((k0 + 2) * 16) + col0) + 0], Weights.w2[(((k0 + 3) * 16) + col0) + 0]);
    weight[1] = f16vec4(Weights.w2[(((k0 + 0) * 16) + col0) + 1], Weights.w2[(((k0 + 1) * 16) + col0) + 1], Weights.w2[(((k0 + 2) * 16) + col0) + 1], Weights.w2[(((k0 + 3) * 16) + col0) + 1]);
    weight[2] = f16vec4(Weights.w2[(((k0 + 0) * 16) + col0) + 2], Weights.w2[(((k0 + 1) * 16) + col0) + 2], Weights.w2[(((k0 + 2) * 16) + col0) + 2], Weights.w2[(((k0 + 3) * 16) + col0) + 2]);
    weight[3] = f16vec4(Weights.w2[(((k0 + 0) * 16) + col0) + 3], Weights.w2[(((k0 + 1) * 16) + col0) + 3], Weights.w2[(((k0 + 2) * 16) + col0) + 3], Weights.w2[(((k0 + 3) * 16) + col0) + 3]);
}

f16vec4 loadBias2(int col0)
{
    return f16vec4(Biases.b2[col0 + 0], Biases.b2[col0 + 1], Biases.b2[col0 + 2], Biases.b2[col0 + 3]);
}

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

void storeOutput(int col0, f16vec4 value)
{
    OutY.y[col0 + 0] = value.x;
    OutY.y[col0 + 1] = value.y;
    OutY.y[col0 + 2] = value.z;
    OutY.y[col0 + 3] = value.w;
}

void main()
{
    f16vec4 param_3[4];
    float16_t h1[64];
    for (int col0 = 0; col0 < 64; col0 += 4)
    {
        f16vec4 rx = f16vec4(float16_t(0.0));
        f16vec4 ry = f16vec4(float16_t(0.0));
        f16vec4 rz = f16vec4(float16_t(0.0));
        f16vec4 rw = f16vec4(float16_t(0.0));
        for (int k0 = 0; k0 < 16; k0 += 4)
        {
            int param = k0;
            f16vec4 v = loadInput(param);
            int param_1 = k0;
            int param_2 = col0;
            tileWeight1(param_1, param_2, param_3);
            f16vec4 weight[4] = param_3;
            rx += (v * weight[0]);
            ry += (v * weight[1]);
            rz += (v * weight[2]);
            rw += (v * weight[3]);
        }
        int param_4 = col0;
        f16vec4 param_5 = loadBias1(param_4) + f16vec4(((rx.x + rx.y) + rx.z) + rx.w, ((ry.x + ry.y) + ry.z) + ry.w, ((rz.x + rz.y) + rz.z) + rz.w, ((rw.x + rw.y) + rw.z) + rw.w);
        f16vec4 value = relu4(param_5);
        h1[col0 + 0] = value.x;
        h1[col0 + 1] = value.y;
        h1[col0 + 2] = value.z;
        h1[col0 + 3] = value.w;
    }
    f16vec4 param_8[4];
    float16_t h2[16];
    for (int col0_1 = 0; col0_1 < 16; col0_1 += 4)
    {
        f16vec4 rx_1 = f16vec4(float16_t(0.0));
        f16vec4 ry_1 = f16vec4(float16_t(0.0));
        f16vec4 rz_1 = f16vec4(float16_t(0.0));
        f16vec4 rw_1 = f16vec4(float16_t(0.0));
        for (int k0_1 = 0; k0_1 < 64; k0_1 += 4)
        {
            f16vec4 v_1 = f16vec4(h1[k0_1 + 0], h1[k0_1 + 1], h1[k0_1 + 2], h1[k0_1 + 3]);
            int param_6 = k0_1;
            int param_7 = col0_1;
            tileWeight2(param_6, param_7, param_8);
            f16vec4 weight_1[4] = param_8;
            rx_1 += (v_1 * weight_1[0]);
            ry_1 += (v_1 * weight_1[1]);
            rz_1 += (v_1 * weight_1[2]);
            rw_1 += (v_1 * weight_1[3]);
        }
        int param_9 = col0_1;
        f16vec4 param_10 = loadBias2(param_9) + f16vec4(((rx_1.x + rx_1.y) + rx_1.z) + rx_1.w, ((ry_1.x + ry_1.y) + ry_1.z) + ry_1.w, ((rz_1.x + rz_1.y) + rz_1.z) + rz_1.w, ((rw_1.x + rw_1.y) + rw_1.z) + rw_1.w);
        f16vec4 value_1 = relu4(param_10);
        h2[col0_1 + 0] = value_1.x;
        h2[col0_1 + 1] = value_1.y;
        h2[col0_1 + 2] = value_1.z;
        h2[col0_1 + 3] = value_1.w;
    }
    f16vec4 param_13[4];
    for (int col0_2 = 0; col0_2 < 8; col0_2 += 4)
    {
        f16vec4 rx_2 = f16vec4(float16_t(0.0));
        f16vec4 ry_2 = f16vec4(float16_t(0.0));
        f16vec4 rz_2 = f16vec4(float16_t(0.0));
        f16vec4 rw_2 = f16vec4(float16_t(0.0));
        for (int k0_2 = 0; k0_2 < 16; k0_2 += 4)
        {
            f16vec4 v_2 = f16vec4(h2[k0_2 + 0], h2[k0_2 + 1], h2[k0_2 + 2], h2[k0_2 + 3]);
            int param_11 = k0_2;
            int param_12 = col0_2;
            tileWeight3(param_11, param_12, param_13);
            f16vec4 weight_2[4] = param_13;
            rx_2 += (v_2 * weight_2[0]);
            ry_2 += (v_2 * weight_2[1]);
            rz_2 += (v_2 * weight_2[2]);
            rw_2 += (v_2 * weight_2[3]);
        }
        int param_14 = col0_2;
        f16vec4 param_15 = loadBias3(param_14) + f16vec4(((rx_2.x + rx_2.y) + rx_2.z) + rx_2.w, ((ry_2.x + ry_2.y) + ry_2.z) + ry_2.w, ((rz_2.x + rz_2.y) + rz_2.z) + rz_2.w, ((rw_2.x + rw_2.y) + rw_2.z) + rw_2.w);
        int param_16 = col0_2;
        f16vec4 param_17 = relu4(param_15);
        storeOutput(param_16, param_17);
    }
}

