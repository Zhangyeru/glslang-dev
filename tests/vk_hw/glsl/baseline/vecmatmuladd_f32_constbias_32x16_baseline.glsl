#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float data[];
} Bias;

vec4 loadInput(int k0)
{
    return vec4(X.data[k0 + 0], X.data[k0 + 1], X.data[k0 + 2], X.data[k0 + 3]);
}

void tileWeight(int k0, int col0, inout vec4 weight[4])
{
    weight[0] = vec4(W.data[(((k0 + 0) * 16) + col0) + 0], W.data[(((k0 + 1) * 16) + col0) + 0], W.data[(((k0 + 2) * 16) + col0) + 0], W.data[(((k0 + 3) * 16) + col0) + 0]);
    weight[1] = vec4(W.data[(((k0 + 0) * 16) + col0) + 1], W.data[(((k0 + 1) * 16) + col0) + 1], W.data[(((k0 + 2) * 16) + col0) + 1], W.data[(((k0 + 3) * 16) + col0) + 1]);
    weight[2] = vec4(W.data[(((k0 + 0) * 16) + col0) + 2], W.data[(((k0 + 1) * 16) + col0) + 2], W.data[(((k0 + 2) * 16) + col0) + 2], W.data[(((k0 + 3) * 16) + col0) + 2]);
    weight[3] = vec4(W.data[(((k0 + 0) * 16) + col0) + 3], W.data[(((k0 + 1) * 16) + col0) + 3], W.data[(((k0 + 2) * 16) + col0) + 3], W.data[(((k0 + 3) * 16) + col0) + 3]);
}

vec4 biasTile(int col0)
{
    if (col0 == 0)
    {
        return vec4(-0.75, -0.5, -0.25, 0.0);
    }
    if (col0 == 4)
    {
        return vec4(0.25, 0.5, 0.75, -0.75);
    }
    if (col0 == 8)
    {
        return vec4(-0.5, -0.25, 0.0, 0.25);
    }
    return vec4(0.5, 0.75, -0.75, -0.5);
}

void storeOutput(int col0, vec4 value)
{
    Y.data[col0 + 0] = value.x;
    Y.data[col0 + 1] = value.y;
    Y.data[col0 + 2] = value.z;
    Y.data[col0 + 3] = value.w;
}

void main()
{
    vec4 param_3[4];
    for (int col0 = 0; col0 < 16; col0 += 4)
    {
        vec4 rx = vec4(0.0);
        vec4 ry = vec4(0.0);
        vec4 rz = vec4(0.0);
        vec4 rw = vec4(0.0);
        for (int k0 = 0; k0 < 32; k0 += 4)
        {
            int param = k0;
            vec4 v = loadInput(param);
            int param_1 = k0;
            int param_2 = col0;
            tileWeight(param_1, param_2, param_3);
            vec4 weight[4] = param_3;
            rx += (v * weight[0]);
            ry += (v * weight[1]);
            rz += (v * weight[2]);
            rw += (v * weight[3]);
        }
        int param_4 = col0;
        int param_5 = col0;
        vec4 param_6 = biasTile(param_4) + vec4(((rx.x + rx.y) + rx.z) + rx.w, ((ry.x + ry.y) + ry.z) + ry.w, ((rz.x + rz.y) + rz.z) + rz.w, ((rw.x + rw.y) + rw.z) + rw.w);
        storeOutput(param_5, param_6);
    }
}

