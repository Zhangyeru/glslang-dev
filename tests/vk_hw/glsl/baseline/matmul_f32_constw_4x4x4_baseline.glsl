#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

void main()
{
    for (int row = 0; row < 4; row++)
    {
        for (int col = 0; col < 4; col++)
        {
            float acc = C.data[(row * 4) + col];
            for (int k = 0; k < 4; k++)
            {
                acc += (A.data[(row * 4) + k] * 0.5);
            }
            D.data[(row * 4) + col] = acc;
        }
    }
}

