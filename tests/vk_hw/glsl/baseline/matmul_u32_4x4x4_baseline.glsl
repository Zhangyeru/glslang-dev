#version 460
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 2, std430) buffer InputC
{
    uint data[];
} C;

layout(set = 0, binding = 0, std430) buffer InputA
{
    uint data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    uint data[];
} B;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    uint data[];
} D;

void main()
{
    for (int row = 0; row < 4; row++)
    {
        for (int col = 0; col < 4; col++)
        {
            uint acc = C.data[(row * 4) + col];
            for (int inner = 0; inner < 4; inner++)
            {
                acc += (A.data[(row * 4) + inner] * B.data[(inner * 4) + col]);
            }
            D.data[(row * 4) + col] = acc;
        }
    }
}

