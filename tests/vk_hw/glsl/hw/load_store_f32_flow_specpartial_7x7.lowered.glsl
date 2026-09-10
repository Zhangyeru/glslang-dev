#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

void main()
{
    float _63 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)];
    float _77 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)];
    float _92 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)];
    float _107 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)];
    float _122 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)];
    float _137 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 0u)];
    float _152 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 0u)];
    float _166 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)];
    float _180 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)];
    float _194 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)];
    float _208 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)];
    float _222 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)];
    float _236 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 1u)];
    float _250 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 1u)];
    float _264 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)];
    float _278 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)];
    float _292 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)];
    float _306 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)];
    float _320 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)];
    float _334 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 2u)];
    float _348 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 2u)];
    float _362 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)];
    float _376 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)];
    float _390 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)];
    float _404 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)];
    float _418 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)];
    float _432 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 3u)];
    float _446 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 3u)];
    float _460 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)];
    float _474 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)];
    float _488 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)];
    float _502 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)];
    float _516 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)];
    float _530 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 4u)];
    float _544 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 4u)];
    float _558 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)];
    float _572 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)];
    float _586 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)];
    float _600 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)];
    float _614 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)];
    float _628 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 5u)];
    float _642 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 5u)];
    float _656 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)];
    float _670 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)];
    float _684 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)];
    float _698 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)];
    float _712 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)];
    float _726 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 6u)];
    float _740 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 6u)];
    float _24[49] = float[](_63, _77, _92, _107, _122, _137, _152, _166, _180, _194, _208, _222, _236, _250, _264, _278, _292, _306, _320, _334, _348, _362, _376, _390, _404, _418, _432, _446, _460, _474, _488, _502, _516, _530, _544, _558, _572, _586, _600, _614, _628, _642, _656, _670, _684, _698, _712, _726, _740);
    float tempArg[49] = _24;
    float value[49] = _24;
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = _24[0];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = _24[1];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = _24[2];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = _24[3];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = _24[4];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 0u)] = _24[5];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 0u)] = _24[6];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = _24[7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = _24[8];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = _24[9];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = _24[10];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = _24[11];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 1u)] = _24[12];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 1u)] = _24[13];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = _24[14];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = _24[15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = _24[16];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = _24[17];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = _24[18];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 2u)] = _24[19];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 2u)] = _24[20];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = _24[21];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = _24[22];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = _24[23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = _24[24];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = _24[25];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 3u)] = _24[26];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 3u)] = _24[27];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = _24[28];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = _24[29];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = _24[30];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = _24[31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = _24[32];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 4u)] = _24[33];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 4u)] = _24[34];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = _24[35];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = _24[36];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = _24[37];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = _24[38];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = _24[39];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 5u)] = _24[40];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 5u)] = _24[41];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = _24[42];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = _24[43];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = _24[44];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = _24[45];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = _24[46];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 6u)] = _24[47];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 6u)] = _24[48];
}

