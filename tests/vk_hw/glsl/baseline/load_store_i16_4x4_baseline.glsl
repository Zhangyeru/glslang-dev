#version 460
#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
#extension GL_EXT_shader_16bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    int16_t data[];
} D;

layout(set = 0, binding = 0, std430) buffer InputA
{
    int16_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    int16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    int16_t data[];
} C;

void main()
{
    for (int i = 0; i < 16; i++)
    {
        D.data[i] = A.data[i];
    }
}

