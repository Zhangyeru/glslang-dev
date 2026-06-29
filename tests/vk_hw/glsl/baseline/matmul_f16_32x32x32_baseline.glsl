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

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

f16vec4 loadA(int row, int k0)
{
    int base = (row * 32) + k0;
    return f16vec4(A.data[base + 0], A.data[base + 1], A.data[base + 2], A.data[base + 3]);
}

void tileWeight(int k0, int col0, inout f16vec4 weight[4])
{
    weight[0] = f16vec4(B.data[(((k0 + 0) * 32) + col0) + 0], B.data[(((k0 + 1) * 32) + col0) + 0], B.data[(((k0 + 2) * 32) + col0) + 0], B.data[(((k0 + 3) * 32) + col0) + 0]);
    weight[1] = f16vec4(B.data[(((k0 + 0) * 32) + col0) + 1], B.data[(((k0 + 1) * 32) + col0) + 1], B.data[(((k0 + 2) * 32) + col0) + 1], B.data[(((k0 + 3) * 32) + col0) + 1]);
    weight[2] = f16vec4(B.data[(((k0 + 0) * 32) + col0) + 2], B.data[(((k0 + 1) * 32) + col0) + 2], B.data[(((k0 + 2) * 32) + col0) + 2], B.data[(((k0 + 3) * 32) + col0) + 2]);
    weight[3] = f16vec4(B.data[(((k0 + 0) * 32) + col0) + 3], B.data[(((k0 + 1) * 32) + col0) + 3], B.data[(((k0 + 2) * 32) + col0) + 3], B.data[(((k0 + 3) * 32) + col0) + 3]);
}

f16vec4 loadC(int row, int col0)
{
    int base = (row * 32) + col0;
    return f16vec4(C.data[base + 0], C.data[base + 1], C.data[base + 2], C.data[base + 3]);
}

void storeD(int row, int col0, f16vec4 value)
{
    int base = (row * 32) + col0;
    D.data[base + 0] = value.x;
    D.data[base + 1] = value.y;
    D.data[base + 2] = value.z;
    D.data[base + 3] = value.w;
}

void main()
{
    f16vec4 param_4[4];
    for (int row = 0; row < 32; row++)
    {
        for (int col0 = 0; col0 < 32; col0 += 4)
        {
            f16vec4 rx = f16vec4(float16_t(0.0));
            f16vec4 ry = f16vec4(float16_t(0.0));
            f16vec4 rz = f16vec4(float16_t(0.0));
            f16vec4 rw = f16vec4(float16_t(0.0));
            for (int k0 = 0; k0 < 32; k0 += 4)
            {
                int param = row;
                int param_1 = k0;
                f16vec4 v = loadA(param, param_1);
                int param_2 = k0;
                int param_3 = col0;
                tileWeight(param_2, param_3, param_4);
                f16vec4 weight[4] = param_4;
                rx += (v * weight[0]);
                ry += (v * weight[1]);
                rz += (v * weight[2]);
                rw += (v * weight[3]);
            }
            int param_5 = row;
            int param_6 = col0;
            int param_7 = row;
            int param_8 = col0;
            f16vec4 param_9 = loadC(param_5, param_6) + f16vec4(((rx.x + rx.y) + rx.z) + rx.w, ((ry.x + ry.y) + ry.z) + ry.w, ((rz.x + rz.y) + rz.z) + rz.w, ((rw.x + rw.y) + rw.z) + rw.w);
            storeD(param_7, param_8, param_9);
        }
    }
}

