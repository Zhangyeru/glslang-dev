#version 460
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    uint data[];
} D;

layout(set = 0, binding = 0, std430) buffer InputA
{
    uint data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    uint data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    uint data[];
} C;

void main()
{
    for (int i = 0; i < 16; i++)
    {
        D.data[i] = A.data[i];
    }
}

