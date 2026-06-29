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
    float16_t data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float16_t data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

f16vec4 loadInput(int k0)
{
    return f16vec4(X.data[k0 + 0], X.data[k0 + 1], X.data[k0 + 2], X.data[k0 + 3]);
}

void tileWeight(int k0, int col0, inout f16vec4 weight[4])
{
    weight[0] = f16vec4(W.data[(((k0 + 0) * 8) + col0) + 0], W.data[(((k0 + 1) * 8) + col0) + 0], W.data[(((k0 + 2) * 8) + col0) + 0], W.data[(((k0 + 3) * 8) + col0) + 0]);
    weight[1] = f16vec4(W.data[(((k0 + 0) * 8) + col0) + 1], W.data[(((k0 + 1) * 8) + col0) + 1], W.data[(((k0 + 2) * 8) + col0) + 1], W.data[(((k0 + 3) * 8) + col0) + 1]);
    weight[2] = f16vec4(W.data[(((k0 + 0) * 8) + col0) + 2], W.data[(((k0 + 1) * 8) + col0) + 2], W.data[(((k0 + 2) * 8) + col0) + 2], W.data[(((k0 + 3) * 8) + col0) + 2]);
    weight[3] = f16vec4(W.data[(((k0 + 0) * 8) + col0) + 3], W.data[(((k0 + 1) * 8) + col0) + 3], W.data[(((k0 + 2) * 8) + col0) + 3], W.data[(((k0 + 3) * 8) + col0) + 3]);
}

void storeOutput(int col0, f16vec4 value)
{
    Y.data[col0 + 0] = value.x;
    Y.data[col0 + 1] = value.y;
    Y.data[col0 + 2] = value.z;
    Y.data[col0 + 3] = value.w;
}

void main()
{
    f16vec4 param_3[4];
    for (int col0 = 0; col0 < 8; col0 += 4)
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
            tileWeight(param_1, param_2, param_3);
            f16vec4 weight[4] = param_3;
            rx += (v * weight[0]);
            ry += (v * weight[1]);
            rz += (v * weight[2]);
            rw += (v * weight[3]);
        }
        int param_4 = col0;
        f16vec4 param_5 = f16vec4(((rx.x + rx.y) + rx.z) + rx.w, ((ry.x + ry.y) + ry.z) + ry.w, ((rz.x + rz.y) + rz.z) + rz.w, ((rw.x + rw.y) + rw.z) + rw.w);
        storeOutput(param_4, param_5);
    }
}

