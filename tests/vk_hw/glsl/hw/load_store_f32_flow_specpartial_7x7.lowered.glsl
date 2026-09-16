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
    float _62 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)];
    float _76 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)];
    float _91 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)];
    float _106 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)];
    float _121 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)];
    float _136 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)];
    float _151 = A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)];
    float _165 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)];
    float _179 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)];
    float _193 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)];
    float _207 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)];
    float _221 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)];
    float _235 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)];
    float _249 = A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)];
    float _263 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)];
    float _277 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)];
    float _291 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)];
    float _305 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)];
    float _319 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)];
    float _333 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)];
    float _347 = A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)];
    float _361 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)];
    float _375 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)];
    float _389 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)];
    float _403 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)];
    float _417 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)];
    float _431 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)];
    float _445 = A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)];
    float _459 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)];
    float _473 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)];
    float _487 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)];
    float _501 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)];
    float _515 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)];
    float _529 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)];
    float _543 = A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)];
    float _557 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 0u)];
    float _571 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 1u)];
    float _585 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 2u)];
    float _599 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 3u)];
    float _613 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 4u)];
    float _627 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 5u)];
    float _641 = A.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 6u)];
    float _655 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 0u)];
    float _669 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 1u)];
    float _683 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 2u)];
    float _697 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 3u)];
    float _711 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 4u)];
    float _725 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 5u)];
    float _739 = A.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 6u)];
    float _23[49] = float[](_62, _76, _91, _106, _121, _136, _151, _165, _179, _193, _207, _221, _235, _249, _263, _277, _291, _305, _319, _333, _347, _361, _375, _389, _403, _417, _431, _445, _459, _473, _487, _501, _515, _529, _543, _557, _571, _585, _599, _613, _627, _641, _655, _669, _683, _697, _711, _725, _739);
    float tempArg[49] = _23;
    float value[49] = _23;
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = _23[0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = _23[1];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = _23[2];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = _23[3];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = _23[4];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = _23[5];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = _23[6];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = _23[7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = _23[8];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = _23[9];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = _23[10];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = _23[11];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = _23[12];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = _23[13];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = _23[14];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = _23[15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = _23[16];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = _23[17];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = _23[18];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = _23[19];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = _23[20];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = _23[21];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = _23[22];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = _23[23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = _23[24];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = _23[25];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = _23[26];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = _23[27];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = _23[28];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = _23[29];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = _23[30];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = _23[31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = _23[32];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = _23[33];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = _23[34];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 0u)] = _23[35];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 1u)] = _23[36];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 2u)] = _23[37];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 3u)] = _23[38];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 4u)] = _23[39];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 5u)] = _23[40];
    D.data[((uint(0) + 5u) * uint(7)) + (uint(0) + 6u)] = _23[41];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 0u)] = _23[42];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 1u)] = _23[43];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 2u)] = _23[44];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 3u)] = _23[45];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 4u)] = _23[46];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 5u)] = _23[47];
    D.data[((uint(0) + 6u) * uint(7)) + (uint(0) + 6u)] = _23[48];
}

