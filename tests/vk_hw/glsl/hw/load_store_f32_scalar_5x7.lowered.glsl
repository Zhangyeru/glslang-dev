#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const float _39[35] = float[](0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
const float _42[35] = float[](1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);
const float _45[7] = float[](0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
const float _47[7] = float[](1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0);

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
    float matrixValue[35] = _26;
    uint _567 = 0u + 0u;
    uint _570 = 0u + 1u;
    uint _573 = 0u + 2u;
    uint _576 = 0u + 3u;
    uint _579 = 0u + 4u;
    uint _582 = 0u + 5u;
    uint _585 = 0u + 6u;
    float _34[7] = float[](A.data[_567], A.data[_570], A.data[_573], A.data[_576], A.data[_579], A.data[_582], A.data[_585]);
    float tempArg_1[7] = _34;
    float vectorValue[7] = _34;
    float _594[35] = _26;
    uint _593 = 0u;
    float _592[35];
    uint _600;
    for (;;)
    {
        _600 = _593;
        if (_600 < 35u)
        {
            _592[_600] = _594[_600] + _39[_600];
            _593 = _600 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float _611[35] = _592;
    uint _610 = 0u;
    float _609[35];
    uint _617;
    for (;;)
    {
        _617 = _610;
        if (_617 < 35u)
        {
            _609[_617] = _611[_617] * _42[_617];
            _610 = _617 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    matrixValue = _609;
    float _629[7] = _34;
    uint _628 = 0u;
    float _627[7];
    uint _635;
    for (;;)
    {
        _635 = _628;
        if (_635 < 7u)
        {
            _627[_635] = _629[_635] + _45[_635];
            _628 = _635 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float _646[7] = _627;
    uint _645 = 0u;
    float _644[7];
    uint _652;
    for (;;)
    {
        _652 = _645;
        if (_652 < 7u)
        {
            _644[_652] = _646[_652] * _47[_652];
            _645 = _652 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vectorValue = _644;
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = _609[0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = _609[1];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = _609[2];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = _609[3];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = _609[4];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = _609[5];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = _609[6];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = _609[7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = _609[8];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = _609[9];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = _609[10];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = _609[11];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = _609[12];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = _609[13];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = _609[14];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = _609[15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = _609[16];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = _609[17];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = _609[18];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = _609[19];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = _609[20];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = _609[21];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = _609[22];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = _609[23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = _609[24];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = _609[25];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = _609[26];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = _609[27];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = _609[28];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = _609[29];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = _609[30];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = _609[31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = _609[32];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = _609[33];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = _609[34];
    uint _1152 = 0u + 0u;
    D.data[_1152] = _644[0];
    uint _1155 = 0u + 1u;
    D.data[_1155] = _644[1];
    uint _1158 = 0u + 2u;
    D.data[_1158] = _644[2];
    uint _1161 = 0u + 3u;
    D.data[_1161] = _644[3];
    uint _1164 = 0u + 4u;
    D.data[_1164] = _644[4];
    uint _1167 = 0u + 5u;
    D.data[_1167] = _644[5];
    uint _1170 = 0u + 6u;
    D.data[_1170] = _644[6];
}

