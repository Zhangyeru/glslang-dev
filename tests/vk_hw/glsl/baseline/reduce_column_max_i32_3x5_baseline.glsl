#version 460
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    int data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    int data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    int data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    int data[];
} C;

void main()
{
    for (int col = 0; col < 5; col++)
    {
        int value = A.data[col];
        for (int row = 1; row < 3; row++)
        {
            value = max(value, A.data[(row * 5) + col]);
        }
        for (int row_1 = 0; row_1 < 3; row_1++)
        {
            D.data[(row_1 * 5) + col] = value;
        }
    }
}

