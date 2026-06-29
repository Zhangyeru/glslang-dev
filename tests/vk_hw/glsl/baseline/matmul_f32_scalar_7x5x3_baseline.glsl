#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

float loadAElement(int row, int k)
{
    float _50;
    if (k < 3)
    {
        _50 = A.data[(row * 3) + k];
    }
    else
    {
        _50 = 0.0;
    }
    return _50;
}

vec4 loadA(int row, int k0)
{
    int param = row;
    int param_1 = k0 + 0;
    int param_2 = row;
    int param_3 = k0 + 1;
    int param_4 = row;
    int param_5 = k0 + 2;
    int param_6 = row;
    int param_7 = k0 + 3;
    return vec4(loadAElement(param, param_1), loadAElement(param_2, param_3), loadAElement(param_4, param_5), loadAElement(param_6, param_7));
}

float loadBElement(int k, int col)
{
    float _76;
    if ((k < 3) && (col < 5))
    {
        _76 = B.data[(k * 5) + col];
    }
    else
    {
        _76 = 0.0;
    }
    return _76;
}

void tileWeight(int k0, int col0, inout vec4 weight[4])
{
    int param = k0 + 0;
    int param_1 = col0 + 0;
    int param_2 = k0 + 1;
    int param_3 = col0 + 0;
    int param_4 = k0 + 2;
    int param_5 = col0 + 0;
    int param_6 = k0 + 3;
    int param_7 = col0 + 0;
    weight[0] = vec4(loadBElement(param, param_1), loadBElement(param_2, param_3), loadBElement(param_4, param_5), loadBElement(param_6, param_7));
    int param_8 = k0 + 0;
    int param_9 = col0 + 1;
    int param_10 = k0 + 1;
    int param_11 = col0 + 1;
    int param_12 = k0 + 2;
    int param_13 = col0 + 1;
    int param_14 = k0 + 3;
    int param_15 = col0 + 1;
    weight[1] = vec4(loadBElement(param_8, param_9), loadBElement(param_10, param_11), loadBElement(param_12, param_13), loadBElement(param_14, param_15));
    int param_16 = k0 + 0;
    int param_17 = col0 + 2;
    int param_18 = k0 + 1;
    int param_19 = col0 + 2;
    int param_20 = k0 + 2;
    int param_21 = col0 + 2;
    int param_22 = k0 + 3;
    int param_23 = col0 + 2;
    weight[2] = vec4(loadBElement(param_16, param_17), loadBElement(param_18, param_19), loadBElement(param_20, param_21), loadBElement(param_22, param_23));
    int param_24 = k0 + 0;
    int param_25 = col0 + 3;
    int param_26 = k0 + 1;
    int param_27 = col0 + 3;
    int param_28 = k0 + 2;
    int param_29 = col0 + 3;
    int param_30 = k0 + 3;
    int param_31 = col0 + 3;
    weight[3] = vec4(loadBElement(param_24, param_25), loadBElement(param_26, param_27), loadBElement(param_28, param_29), loadBElement(param_30, param_31));
}

vec4 loadC(int row, int col0)
{
    float _125;
    if ((col0 + 0) < 5)
    {
        _125 = C.data[((row * 5) + col0) + 0];
    }
    else
    {
        _125 = 0.0;
    }
    float _144;
    if ((col0 + 1) < 5)
    {
        _144 = C.data[((row * 5) + col0) + 1];
    }
    else
    {
        _144 = 0.0;
    }
    float _159;
    if ((col0 + 2) < 5)
    {
        _159 = C.data[((row * 5) + col0) + 2];
    }
    else
    {
        _159 = 0.0;
    }
    float _174;
    if ((col0 + 3) < 5)
    {
        _174 = C.data[((row * 5) + col0) + 3];
    }
    else
    {
        _174 = 0.0;
    }
    return vec4(_125, _144, _159, _174);
}

void storeD(int row, int col0, vec4 value)
{
    if ((col0 + 0) < 5)
    {
        D.data[((row * 5) + col0) + 0] = value.x;
    }
    if ((col0 + 1) < 5)
    {
        D.data[((row * 5) + col0) + 1] = value.y;
    }
    if ((col0 + 2) < 5)
    {
        D.data[((row * 5) + col0) + 2] = value.z;
    }
    if ((col0 + 3) < 5)
    {
        D.data[((row * 5) + col0) + 3] = value.w;
    }
}

void main()
{
    vec4 param_4[4];
    for (int row = 0; row < 7; row++)
    {
        for (int col0 = 0; col0 < 5; col0 += 4)
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
            int param_6 = col0;
            int param_7 = row;
            int param_8 = col0;
            vec4 param_9 = loadC(param_5, param_6) + vec4(((rx.x + rx.y) + rx.z) + rx.w, ((ry.x + ry.y) + ry.z) + ry.w, ((rz.x + rz.y) + rz.z) + rz.w, ((rw.x + rw.y) + rw.z) + rw.w);
            storeD(param_7, param_8, param_9);
        }
    }
}

