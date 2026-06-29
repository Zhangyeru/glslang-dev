#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec4 loadA(int row, int k0)
{
    int base = (row * 16) + k0;
    return vec4(A.data[base + 0], A.data[base + 1], A.data[base + 2], A.data[base + 3]);
}

void tileWeightMat(int k0, int col0, inout vec4 weight[4])
{
    weight[0] = vec4(B.data[(((k0 + 0) * 16) + col0) + 0], B.data[(((k0 + 1) * 16) + col0) + 0], B.data[(((k0 + 2) * 16) + col0) + 0], B.data[(((k0 + 3) * 16) + col0) + 0]);
    weight[1] = vec4(B.data[(((k0 + 0) * 16) + col0) + 1], B.data[(((k0 + 1) * 16) + col0) + 1], B.data[(((k0 + 2) * 16) + col0) + 1], B.data[(((k0 + 3) * 16) + col0) + 1]);
    weight[2] = vec4(B.data[(((k0 + 0) * 16) + col0) + 2], B.data[(((k0 + 1) * 16) + col0) + 2], B.data[(((k0 + 2) * 16) + col0) + 2], B.data[(((k0 + 3) * 16) + col0) + 2]);
    weight[3] = vec4(B.data[(((k0 + 0) * 16) + col0) + 3], B.data[(((k0 + 1) * 16) + col0) + 3], B.data[(((k0 + 2) * 16) + col0) + 3], B.data[(((k0 + 3) * 16) + col0) + 3]);
}

vec4 matmulTile(int row, int col0, vec4 bias)
{
    vec4 rx = vec4(0.0);
    vec4 ry = vec4(0.0);
    vec4 rz = vec4(0.0);
    vec4 rw = vec4(0.0);
    vec4 param_4[4];
    for (int k0 = 0; k0 < 16; k0 += 4)
    {
        int param = row;
        int param_1 = k0;
        vec4 v = loadA(param, param_1);
        int param_2 = k0;
        int param_3 = col0;
        tileWeightMat(param_2, param_3, param_4);
        vec4 weight[4] = param_4;
        rx += (v * weight[0]);
        ry += (v * weight[1]);
        rz += (v * weight[2]);
        rw += (v * weight[3]);
    }
    return bias + vec4(((rx.x + rx.y) + rx.z) + rx.w, ((ry.x + ry.y) + ry.z) + ry.w, ((rz.x + rz.y) + rz.z) + rz.w, ((rw.x + rw.y) + rw.z) + rw.w);
}

void storeD(int row, int col0, vec4 value)
{
    int base = (row * 16) + col0;
    D.data[base + 0] = value.x;
    D.data[base + 1] = value.y;
    D.data[base + 2] = value.z;
    D.data[base + 3] = value.w;
}

vec4 loadD(int row, int col0)
{
    int base = (row * 16) + col0;
    return vec4(D.data[base + 0], D.data[base + 1], D.data[base + 2], D.data[base + 3]);
}

void tileWeightVec(int k0, int col0, inout vec4 weight[4])
{
    weight[0] = vec4(B.data[(((k0 + 0) * 16) + col0) + 0], B.data[(((k0 + 0) * 16) + col0) + 1], B.data[(((k0 + 0) * 16) + col0) + 2], B.data[(((k0 + 0) * 16) + col0) + 3]);
    weight[1] = vec4(B.data[(((k0 + 1) * 16) + col0) + 0], B.data[(((k0 + 1) * 16) + col0) + 1], B.data[(((k0 + 1) * 16) + col0) + 2], B.data[(((k0 + 1) * 16) + col0) + 3]);
    weight[2] = vec4(B.data[(((k0 + 2) * 16) + col0) + 0], B.data[(((k0 + 2) * 16) + col0) + 1], B.data[(((k0 + 2) * 16) + col0) + 2], B.data[(((k0 + 2) * 16) + col0) + 3]);
    weight[3] = vec4(B.data[(((k0 + 3) * 16) + col0) + 0], B.data[(((k0 + 3) * 16) + col0) + 1], B.data[(((k0 + 3) * 16) + col0) + 2], B.data[(((k0 + 3) * 16) + col0) + 3]);
}

vec4 vecmatmulTile(int col0, vec4 bias)
{
    vec4 acc = vec4(0.0);
    vec4 param_4[4];
    for (int k0 = 0; k0 < 16; k0 += 4)
    {
        int param = 0;
        int param_1 = k0;
        vec4 v = loadA(param, param_1);
        int param_2 = k0;
        int param_3 = col0;
        tileWeightVec(param_2, param_3, param_4);
        vec4 weight[4] = param_4;
        acc += (weight[0] * v.x);
        acc += (weight[1] * v.y);
        acc += (weight[2] * v.z);
        acc += (weight[3] * v.w);
    }
    return bias + acc;
}

void main()
{
    for (int row = 0; row < 16; row++)
    {
        for (int col0 = 0; col0 < 16; col0 += 4)
        {
            vec4 c = vec4(C.data[((row * 16) + col0) + 0], C.data[((row * 16) + col0) + 1], C.data[((row * 16) + col0) + 2], C.data[((row * 16) + col0) + 3]);
            int param = row;
            int param_1 = col0;
            vec4 param_2 = c;
            int param_3 = row;
            int param_4 = col0;
            vec4 param_5 = matmulTile(param, param_1, param_2);
            int param_6 = row;
            int param_7 = col0;
            vec4 param_8 = matmulTile(param_3, param_4, param_5);
            storeD(param_6, param_7, param_8);
        }
    }
    for (int col0_1 = 0; col0_1 < 16; col0_1 += 4)
    {
        int param_9 = 0;
        int param_10 = col0_1;
        int param_11 = col0_1;
        vec4 param_12 = loadD(param_9, param_10);
        int param_13 = 0;
        int param_14 = col0_1;
        vec4 param_15 = vecmatmulTile(param_11, param_12);
        storeD(param_13, param_14, param_15);
        int param_16 = 0;
        int param_17 = col0_1;
        int param_18 = col0_1;
        vec4 param_19 = loadD(param_16, param_17);
        int param_20 = 0;
        int param_21 = col0_1;
        vec4 param_22 = vecmatmulTile(param_18, param_19);
        storeD(param_20, param_21, param_22);
    }
}

