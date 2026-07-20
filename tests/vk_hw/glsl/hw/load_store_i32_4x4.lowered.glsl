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
    int _61 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)];
    int _75 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)];
    int _90 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)];
    int _105 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)];
    int _119 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)];
    int _133 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)];
    int _147 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)];
    int _161 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)];
    int _175 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)];
    int _189 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)];
    int _203 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)];
    int _217 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)];
    int _231 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)];
    int _245 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)];
    int _259 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)];
    int _273 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)];
    int _23[16] = int[](_61, _75, _90, _105, _119, _133, _147, _161, _175, _189, _203, _217, _231, _245, _259, _273);
    int tempArg[16] = _23;
    int value[16] = _23;
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)] = _23[0];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)] = _23[1];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)] = _23[2];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)] = _23[3];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)] = _23[4];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)] = _23[5];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)] = _23[6];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)] = _23[7];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)] = _23[8];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)] = _23[9];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)] = _23[10];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)] = _23[11];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)] = _23[12];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)] = _23[13];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)] = _23[14];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)] = _23[15];
}

