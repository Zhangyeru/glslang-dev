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
    int _25[15] = int[](A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)], A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)], A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)], A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)]);
    int tempArg[15] = _25;
    int value[15] = _25;
    int _271 = max(max(_25[0], _25[5]), _25[10]);
    int _276 = max(max(_25[1], _25[6]), _25[11]);
    int _281 = max(max(_25[2], _25[7]), _25[12]);
    int _286 = max(max(_25[3], _25[8]), _25[13]);
    int _291 = max(max(_25[4], _25[9]), _25[14]);
    int _32[15] = int[](_271, _276, _281, _286, _291, _271, _276, _281, _286, _291, _271, _276, _281, _286, _291);
    int reduced[15] = _32;
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)] = _32[0];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)] = _32[1];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)] = _32[2];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)] = _32[3];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)] = _32[4];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)] = _32[5];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)] = _32[6];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)] = _32[7];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)] = _32[8];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)] = _32[9];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)] = _32[10];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)] = _32[11];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)] = _32[12];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)] = _32[13];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)] = _32[14];
}

