#version 460
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

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

layout(set = 0, binding = 3, std430) buffer OutputD
{
    int data[];
} D;

void main()
{
    int _23[16] = int[](A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    int tempArg[16] = _23;
    int a[16] = _23;
    int _35[16] = int[](B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    int tempArg_1[16] = _35;
    int b[16] = _35;
    int _47[16] = int[](C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    int tempArg_2[16] = _47;
    int c[16] = _47;
    int _54[16] = int[]((_23[3] * _35[12]) + ((_23[2] * _35[8]) + ((_23[1] * _35[4]) + ((_23[0] * _35[0]) + _47[0]))), (_23[3] * _35[13]) + ((_23[2] * _35[9]) + ((_23[1] * _35[5]) + ((_23[0] * _35[1]) + _47[1]))), (_23[3] * _35[14]) + ((_23[2] * _35[10]) + ((_23[1] * _35[6]) + ((_23[0] * _35[2]) + _47[2]))), (_23[3] * _35[15]) + ((_23[2] * _35[11]) + ((_23[1] * _35[7]) + ((_23[0] * _35[3]) + _47[3]))), (_23[7] * _35[12]) + ((_23[6] * _35[8]) + ((_23[5] * _35[4]) + ((_23[4] * _35[0]) + _47[4]))), (_23[7] * _35[13]) + ((_23[6] * _35[9]) + ((_23[5] * _35[5]) + ((_23[4] * _35[1]) + _47[5]))), (_23[7] * _35[14]) + ((_23[6] * _35[10]) + ((_23[5] * _35[6]) + ((_23[4] * _35[2]) + _47[6]))), (_23[7] * _35[15]) + ((_23[6] * _35[11]) + ((_23[5] * _35[7]) + ((_23[4] * _35[3]) + _47[7]))), (_23[11] * _35[12]) + ((_23[10] * _35[8]) + ((_23[9] * _35[4]) + ((_23[8] * _35[0]) + _47[8]))), (_23[11] * _35[13]) + ((_23[10] * _35[9]) + ((_23[9] * _35[5]) + ((_23[8] * _35[1]) + _47[9]))), (_23[11] * _35[14]) + ((_23[10] * _35[10]) + ((_23[9] * _35[6]) + ((_23[8] * _35[2]) + _47[10]))), (_23[11] * _35[15]) + ((_23[10] * _35[11]) + ((_23[9] * _35[7]) + ((_23[8] * _35[3]) + _47[11]))), (_23[15] * _35[12]) + ((_23[14] * _35[8]) + ((_23[13] * _35[4]) + ((_23[12] * _35[0]) + _47[12]))), (_23[15] * _35[13]) + ((_23[14] * _35[9]) + ((_23[13] * _35[5]) + ((_23[12] * _35[1]) + _47[13]))), (_23[15] * _35[14]) + ((_23[14] * _35[10]) + ((_23[13] * _35[6]) + ((_23[12] * _35[2]) + _47[14]))), (_23[15] * _35[15]) + ((_23[14] * _35[11]) + ((_23[13] * _35[7]) + ((_23[12] * _35[3]) + _47[15]))));
    int tempArg_3[16] = _54;
    int d[16] = _54;
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)] = _54[0];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)] = _54[1];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)] = _54[2];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)] = _54[3];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)] = _54[4];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)] = _54[5];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)] = _54[6];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)] = _54[7];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)] = _54[8];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)] = _54[9];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)] = _54[10];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)] = _54[11];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)] = _54[12];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)] = _54[13];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)] = _54[14];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)] = _54[15];
}

