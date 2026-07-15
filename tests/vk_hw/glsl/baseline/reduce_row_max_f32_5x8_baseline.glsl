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

float reducePair(float lhs, float rhs)
{
    return max(lhs, rhs);
}

void main()
{
    for (int row = 0; row < 5; row++)
    {
        float reduced = A.data[row * 8];
        for (int col = 1; col < 8; col++)
        {
            float param = reduced;
            float param_1 = A.data[(row * 8) + col];
            reduced = reducePair(param, param_1);
        }
        for (int col_1 = 0; col_1 < 8; col_1++)
        {
            D.data[(row * 8) + col_1] = reduced;
        }
    }
}

