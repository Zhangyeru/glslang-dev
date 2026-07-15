#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct MatrixBox
{
    float values[2][35];
};

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

MatrixBox duplicate(inout MatrixBox box)
{
    box.values[1] = box.values[0];
    return box;
}

MatrixBox selectAndCarry(inout MatrixBox box, bool pickFirst)
{
    float _38[35];
    if (pickFirst)
    {
        _38 = box.values[0];
    }
    else
    {
        _38 = box.values[1];
    }
    float current[35] = _38;
    float _62[35];
    for (int iteration = 0; iteration < 3; iteration++)
    {
        bool keepCurrent = (iteration & 1) == 0;
        if (keepCurrent)
        {
            _62 = current;
        }
        else
        {
            _62 = box.values[1];
        }
        current = _62;
    }
    box.values[0] = current;
    return box;
}

void main()
{
    float _89[35] = float[](A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)]);
    float tempArg[35] = _89;
    float value[35] = _89;
    MatrixBox box;
    box.values[0] = _89;
    MatrixBox param = box;
    MatrixBox _97 = duplicate(param);
    box = _97;
    MatrixBox param_1 = _97;
    bool param_2 = gl_LocalInvocationIndex == 0u;
    MatrixBox _106 = selectAndCarry(param_1, param_2);
    box = _106;
    float result[35] = box.values[0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = box.values[0][0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = box.values[0][1];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = box.values[0][2];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = box.values[0][3];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = box.values[0][4];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = box.values[0][5];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = box.values[0][6];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = box.values[0][7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = box.values[0][8];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = box.values[0][9];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = box.values[0][10];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = box.values[0][11];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = box.values[0][12];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = box.values[0][13];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = box.values[0][14];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = box.values[0][15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = box.values[0][16];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = box.values[0][17];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = box.values[0][18];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = box.values[0][19];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = box.values[0][20];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = box.values[0][21];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = box.values[0][22];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = box.values[0][23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = box.values[0][24];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = box.values[0][25];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = box.values[0][26];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = box.values[0][27];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = box.values[0][28];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = box.values[0][29];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = box.values[0][30];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = box.values[0][31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = box.values[0][32];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = box.values[0][33];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = box.values[0][34];
}

