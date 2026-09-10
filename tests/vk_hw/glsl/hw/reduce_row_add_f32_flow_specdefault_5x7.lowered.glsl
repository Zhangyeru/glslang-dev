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
    float _23[35] = float[](A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)]);
    float tempArg[35] = _23;
    float value[35] = _23;
    float _561 = (((((_23[0] + _23[1]) + _23[2]) + _23[3]) + _23[4]) + _23[5]) + _23[6];
    float _574 = (((((_23[7] + _23[8]) + _23[9]) + _23[10]) + _23[11]) + _23[12]) + _23[13];
    float _587 = (((((_23[14] + _23[15]) + _23[16]) + _23[17]) + _23[18]) + _23[19]) + _23[20];
    float _600 = (((((_23[21] + _23[22]) + _23[23]) + _23[24]) + _23[25]) + _23[26]) + _23[27];
    float _613 = (((((_23[28] + _23[29]) + _23[30]) + _23[31]) + _23[32]) + _23[33]) + _23[34];
    float _30[35] = float[](_561, _561, _561, _561, _561, _561, _561, _574, _574, _574, _574, _574, _574, _574, _587, _587, _587, _587, _587, _587, _587, _600, _600, _600, _600, _600, _600, _600, _613, _613, _613, _613, _613, _613, _613);
    float reduced[35] = _30;
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = _30[0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = _30[1];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = _30[2];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = _30[3];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = _30[4];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = _30[5];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = _30[6];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = _30[7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = _30[8];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = _30[9];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = _30[10];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = _30[11];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = _30[12];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = _30[13];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = _30[14];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = _30[15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = _30[16];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = _30[17];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = _30[18];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = _30[19];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = _30[20];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = _30[21];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = _30[22];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = _30[23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = _30[24];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = _30[25];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = _30[26];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = _30[27];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = _30[28];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = _30[29];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = _30[30];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = _30[31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = _30[32];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = _30[33];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = _30[34];
}

