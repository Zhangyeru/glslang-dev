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
    float _26[35] = float[](A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)]);
    float tempArg[35] = _26;
    float value[35] = _26;
    float _560 = (((((_26[0] + _26[1]) + _26[2]) + _26[3]) + _26[4]) + _26[5]) + _26[6];
    float _573 = (((((_26[7] + _26[8]) + _26[9]) + _26[10]) + _26[11]) + _26[12]) + _26[13];
    float _586 = (((((_26[14] + _26[15]) + _26[16]) + _26[17]) + _26[18]) + _26[19]) + _26[20];
    float _599 = (((((_26[21] + _26[22]) + _26[23]) + _26[24]) + _26[25]) + _26[26]) + _26[27];
    float _612 = (((((_26[28] + _26[29]) + _26[30]) + _26[31]) + _26[32]) + _26[33]) + _26[34];
    float _31[35] = float[](_560, _560, _560, _560, _560, _560, _560, _573, _573, _573, _573, _573, _573, _573, _586, _586, _586, _586, _586, _586, _586, _599, _599, _599, _599, _599, _599, _599, _612, _612, _612, _612, _612, _612, _612);
    float reduced[35] = _31;
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = _31[0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = _31[1];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = _31[2];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = _31[3];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = _31[4];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = _31[5];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = _31[6];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = _31[7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = _31[8];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = _31[9];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = _31[10];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = _31[11];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = _31[12];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = _31[13];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = _31[14];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = _31[15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = _31[16];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = _31[17];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = _31[18];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = _31[19];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = _31[20];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = _31[21];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = _31[22];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = _31[23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = _31[24];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = _31[25];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = _31[26];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = _31[27];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = _31[28];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = _31[29];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = _31[30];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = _31[31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = _31[32];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = _31[33];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = _31[34];
}

