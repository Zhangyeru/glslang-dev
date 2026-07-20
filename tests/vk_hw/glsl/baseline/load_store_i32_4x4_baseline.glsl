#version 460
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    int data[];
} D;

layout(set = 0, binding = 0, std430) buffer InputA
{
    int data[];
} A;

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
    for (int i = 0; i < 16; i++)
    {
        D.data[i] = A.data[i];
    }
}

