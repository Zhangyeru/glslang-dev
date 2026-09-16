#version 460
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

void _83(inout float _85[65533], float _84)
{
    for (uint _92 = 0u; _92 < 65533u; _92++)
    {
        _85[_92] = _84;
    }
}

void main()
{
    float _80[65533];
    _83(_80, 1.0);
    uint i = gl_GlobalInvocationID.x;
    float _26 = _80[int(i)];
    float _31 = _80[int(i + 65532u)];
    float check = (_26 + _31) - 2.0;
    float _52[35] = float[](A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)]);
    float tempArg[35] = _52;
    float value[35] = _52;
    float _599[35] = _52;
    float _600[35] = float[](check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check);
    uint _598 = 0u;
    float _597[35];
    uint _605;
    for (;;)
    {
        _605 = _598;
        if (_605 < 35u)
        {
            _597[_605] = _599[_605] + _600[_605];
            _598 = _605 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _597;
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = _597[0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = _597[1];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = _597[2];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = _597[3];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = _597[4];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = _597[5];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = _597[6];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = _597[7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = _597[8];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = _597[9];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = _597[10];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = _597[11];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = _597[12];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = _597[13];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = _597[14];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = _597[15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = _597[16];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = _597[17];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = _597[18];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = _597[19];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = _597[20];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = _597[21];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = _597[22];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = _597[23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = _597[24];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = _597[25];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = _597[26];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = _597[27];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = _597[28];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = _597[29];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = _597[30];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = _597[31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = _597[32];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = _597[33];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = _597[34];
}

