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
    float _558 = max(max(max(max(_26[0], _26[7]), _26[14]), _26[21]), _26[28]);
    float _567 = max(max(max(max(_26[1], _26[8]), _26[15]), _26[22]), _26[29]);
    float _576 = max(max(max(max(_26[2], _26[9]), _26[16]), _26[23]), _26[30]);
    float _585 = max(max(max(max(_26[3], _26[10]), _26[17]), _26[24]), _26[31]);
    float _594 = max(max(max(max(_26[4], _26[11]), _26[18]), _26[25]), _26[32]);
    float _603 = max(max(max(max(_26[5], _26[12]), _26[19]), _26[26]), _26[33]);
    float _612 = max(max(max(max(_26[6], _26[13]), _26[20]), _26[27]), _26[34]);
    float _33[35] = float[](_558, _567, _576, _585, _594, _603, _612, _558, _567, _576, _585, _594, _603, _612, _558, _567, _576, _585, _594, _603, _612, _558, _567, _576, _585, _594, _603, _612, _558, _567, _576, _585, _594, _603, _612);
    float reduced[35] = _33;
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = _33[0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = _33[1];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = _33[2];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = _33[3];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = _33[4];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = _33[5];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = _33[6];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = _33[7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = _33[8];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = _33[9];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = _33[10];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = _33[11];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = _33[12];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = _33[13];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = _33[14];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = _33[15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = _33[16];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = _33[17];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = _33[18];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = _33[19];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = _33[20];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = _33[21];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = _33[22];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = _33[23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = _33[24];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = _33[25];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = _33[26];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = _33[27];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = _33[28];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = _33[29];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = _33[30];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = _33[31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = _33[32];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = _33[33];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = _33[34];
}

