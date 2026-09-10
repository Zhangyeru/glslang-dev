#version 460
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct HomogeneousPair
{
    vec4 first;
    vec4 second;
};

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
    float runtimeZero = A.data[gl_LocalInvocationIndex] - A.data[gl_LocalInvocationIndex];
    vec4 runtimeVector = vec4(runtimeZero);
    mat4 runtimeMatrix = mat4(runtimeVector, runtimeVector, runtimeVector, runtimeVector);
    vec4 runtimeArray[2] = vec4[](runtimeVector, runtimeVector);
    HomogeneousPair runtimePair = HomogeneousPair(runtimeVector, runtimeVector);
    float zero = (runtimeMatrix[3].z + runtimeArray[1].z) + runtimePair.second.w;
    float one = 1.0 * 1.0;
    float _72[35] = float[](zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero);
    float matrixZero[35] = _72;
    float _75[35] = float[](one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one, one);
    float matrixOne[35] = _75;
    float _84[35] = float[](A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)]);
    float tempArg[35] = _84;
    float value[35] = _84;
    float _610[35] = _84;
    float _611[35] = _72;
    uint _609 = 0u;
    float _608[35];
    uint _616;
    for (;;)
    {
        _616 = _609;
        if (_616 < 35u)
        {
            _608[_616] = _610[_616] + _611[_616];
            _609 = _616 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float _627[35] = _608;
    float _628[35] = _75;
    uint _626 = 0u;
    float _625[35];
    uint _633;
    for (;;)
    {
        _633 = _626;
        if (_633 < 35u)
        {
            _625[_633] = _627[_633] * _628[_633];
            _626 = _633 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _625;
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = _625[0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = _625[1];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = _625[2];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = _625[3];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = _625[4];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = _625[5];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = _625[6];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = _625[7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = _625[8];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = _625[9];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = _625[10];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = _625[11];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = _625[12];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = _625[13];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = _625[14];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = _625[15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = _625[16];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = _625[17];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = _625[18];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = _625[19];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = _625[20];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = _625[21];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = _625[22];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = _625[23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = _625[24];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = _625[25];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = _625[26];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = _625[27];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = _625[28];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = _625[29];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = _625[30];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = _625[31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = _625[32];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = _625[33];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = _625[34];
}

