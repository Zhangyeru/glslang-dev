#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

vec4 loadA(int row, int k0)
{
    int base = (row * 16) + k0;
    return vec4(A.data[base + 0], A.data[base + 1], A.data[base + 2], A.data[base + 3]);
}

void tileWeight(int k0, int col0, inout vec4 weight[4])
{
    weight[0] = vec4(B.data[(((k0 + 0) * 16) + col0) + 0], B.data[(((k0 + 1) * 16) + col0) + 0], B.data[(((k0 + 2) * 16) + col0) + 0], B.data[(((k0 + 3) * 16) + col0) + 0]);
    weight[1] = vec4(B.data[(((k0 + 0) * 16) + col0) + 1], B.data[(((k0 + 1) * 16) + col0) + 1], B.data[(((k0 + 2) * 16) + col0) + 1], B.data[(((k0 + 3) * 16) + col0) + 1]);
    weight[2] = vec4(B.data[(((k0 + 0) * 16) + col0) + 2], B.data[(((k0 + 1) * 16) + col0) + 2], B.data[(((k0 + 2) * 16) + col0) + 2], B.data[(((k0 + 3) * 16) + col0) + 2]);
    weight[3] = vec4(B.data[(((k0 + 0) * 16) + col0) + 3], B.data[(((k0 + 1) * 16) + col0) + 3], B.data[(((k0 + 2) * 16) + col0) + 3], B.data[(((k0 + 3) * 16) + col0) + 3]);
}

vec4 loadC(int row, int col0)
{
    int base = (row * 16) + col0;
    return vec4(C.data[base + 0], C.data[base + 1], C.data[base + 2], C.data[base + 3]);
}

void storeD(int row, int col0, vec4 value)
{
    int base = (row * 16) + col0;
    D.data[base + 0] = value.x;
    D.data[base + 1] = value.y;
    D.data[base + 2] = value.z;
    D.data[base + 3] = value.w;
}

void main()
{
    vec4 param_4[4];
    vec4 param_9[4];
    vec4 param_14[4];
    vec4 param_19[4];
    for (int row = 0; row < 16; row++)
    {
        for (int col0 = 0; col0 < 16; col0 += 4)
        {
            vec4 rx = vec4(0.0);
            vec4 ry = vec4(0.0);
            vec4 rz = vec4(0.0);
            vec4 rw = vec4(0.0);
            int param = row;
            int param_1 = 0;
            vec4 v = loadA(param, param_1);
            int param_2 = 0;
            int param_3 = col0;
            tileWeight(param_2, param_3, param_4);
            vec4 weight[4] = param_4;
            rx += (v * weight[0]);
            ry += (v * weight[1]);
            rz += (v * weight[2]);
            rw += (v * weight[3]);
            int param_5 = row;
            int param_6 = 4;
            v = loadA(param_5, param_6);
            int param_7 = 4;
            int param_8 = col0;
            tileWeight(param_7, param_8, param_9);
            weight = param_9;
            rx += (v * weight[0]);
            ry += (v * weight[1]);
            rz += (v * weight[2]);
            rw += (v * weight[3]);
            int param_10 = row;
            int param_11 = 8;
            v = loadA(param_10, param_11);
            int param_12 = 8;
            int param_13 = col0;
            tileWeight(param_12, param_13, param_14);
            weight = param_14;
            rx += (v * weight[0]);
            ry += (v * weight[1]);
            rz += (v * weight[2]);
            rw += (v * weight[3]);
            int param_15 = row;
            int param_16 = 12;
            v = loadA(param_15, param_16);
            int param_17 = 12;
            int param_18 = col0;
            tileWeight(param_17, param_18, param_19);
            weight = param_19;
            rx += (v * weight[0]);
            ry += (v * weight[1]);
            rz += (v * weight[2]);
            rw += (v * weight[3]);
            int param_20 = row;
            int param_21 = col0;
            int param_22 = row;
            int param_23 = col0;
            vec4 param_24 = loadC(param_20, param_21) + vec4(((rx.x + rx.y) + rx.z) + rx.w, ((ry.x + ry.y) + ry.z) + ry.w, ((rz.x + rz.y) + rz.z) + rz.w, ((rw.x + rw.y) + rw.z) + rw.w);
            storeD(param_22, param_23, param_24);
        }
    }
}

