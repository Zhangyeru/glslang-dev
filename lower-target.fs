#version 460
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
#extension GL_EXT_scalar_block_layout : require

layout(set = 0, binding = 0, std430) buffer vecA
{
    f16vec4 data[8];
}
vA;

layout(set = 0, binding = 1, std430) uniform matA
{
    f16vec4 data[32][1];
}
mA;

layout(set = 0, binding = 2, std430) buffer Output
{
    f16vec4 data;
}
outputdata;

layout(location = 0) in vec3 in_color;
layout(location = 0) out vec4 out_color;

void tileWeight(in int row, in int col, out f16vec4 weight[4])
{
    // for (int i = 0; i < 4; i++) {
    //     weight[i] = mA.data[row + i][col];
    // }
    weight[0] =
        f16vec4(mA.data[row + 0][col].x, mA.data[row + 1][col].x, mA.data[row + 2][col].x, mA.data[row + 3][col].x);
    weight[1] =
        f16vec4(mA.data[row + 0][col].y, mA.data[row + 1][col].y, mA.data[row + 2][col].y, mA.data[row + 3][col].y);
    weight[2] =
        f16vec4(mA.data[row + 0][col].z, mA.data[row + 1][col].z, mA.data[row + 2][col].z, mA.data[row + 3][col].z);
    weight[3] =
        f16vec4(mA.data[row + 0][col].w, mA.data[row + 1][col].w, mA.data[row + 2][col].w, mA.data[row + 3][col].w);
}

#define MatMul_PATTERN(i, j)  \
    tileWeight(i, j, weight); \
    rx += v * weight[0];      \
    ry += v * weight[1];      \
    rz += v * weight[2];      \
    rw += v * weight[3];

f16vec4 test()
{
    f16vec4 result0 = f16vec4(0.0);
    f16vec4 v;

    f16vec4 rx = f16vec4(0.0);
    f16vec4 ry = f16vec4(0.0);
    f16vec4 rz = f16vec4(0.0);
    f16vec4 rw = f16vec4(0.0);

    f16vec4 weight[4];

    v = vA.data[0];
    MatMul_PATTERN(0, 0);
    v = vA.data[1];
    MatMul_PATTERN(4, 0);
    v = vA.data[2];
    MatMul_PATTERN(8, 0);
    v = vA.data[3];
    MatMul_PATTERN(12, 0);
    v = vA.data[4];
    MatMul_PATTERN(16, 0);
    v = vA.data[5];
    MatMul_PATTERN(20, 0);
    v = vA.data[6];
    MatMul_PATTERN(24, 0);
    v = vA.data[7];
    MatMul_PATTERN(28, 0);

    result0.x = rx.x + rx.y + rx.z + rx.w;
    result0.y = ry.x + ry.y + ry.z + ry.w;
    result0.z = rz.x + rz.y + rz.z + rz.w;
    result0.w = rw.x + rw.y + rw.z + rw.w;

    return result0;
}

void main()
{

    f16vec4 result = test();

    outputdata.data.x = result.x;
    outputdata.data.y = result.y;
    outputdata.data.z = result.z;
    outputdata.data.w = result.w;

    out_color.x = in_color.x + result.x + result.y + result.z + result.w;
    out_color.y = in_color.y;
    out_color.z = in_color.z;
    out_color.w = 1.0f;
    // out_color = vec4(in_color, 1.0f);
}