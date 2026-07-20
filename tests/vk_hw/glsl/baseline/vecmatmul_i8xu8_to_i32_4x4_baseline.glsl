#version 460
#extension GL_EXT_shader_explicit_arithmetic_types_int8 : require
#extension GL_EXT_shader_8bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    int8_t data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    uint8_t data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    int data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    int data[];
} C;

void main()
{
    for (int col = 0; col < 4; col++)
    {
        int acc = 0;
        for (int inner = 0; inner < 4; inner++)
        {
            acc += (int(X.data[inner]) * int(uint(W.data[(inner * 4) + col])));
        }
        Y.data[col] = acc;
    }
}

