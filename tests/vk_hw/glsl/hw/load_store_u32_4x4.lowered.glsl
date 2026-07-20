#version 460
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    uint data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    uint data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    uint data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    uint data[];
} C;

void main()
{
    uint _61 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)];
    uint _75 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)];
    uint _90 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)];
    uint _105 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)];
    uint _119 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)];
    uint _133 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)];
    uint _147 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)];
    uint _161 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)];
    uint _175 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)];
    uint _189 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)];
    uint _203 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)];
    uint _217 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)];
    uint _231 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)];
    uint _245 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)];
    uint _259 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)];
    uint _273 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)];
    uint _23[16] = uint[](_61, _75, _90, _105, _119, _133, _147, _161, _175, _189, _203, _217, _231, _245, _259, _273);
    uint tempArg[16] = _23;
    uint value[16] = _23;
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)] = _23[0];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)] = _23[1];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)] = _23[2];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)] = _23[3];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)] = _23[4];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)] = _23[5];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)] = _23[6];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)] = _23[7];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)] = _23[8];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)] = _23[9];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)] = _23[10];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)] = _23[11];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)] = _23[12];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)] = _23[13];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)] = _23[14];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)] = _23[15];
}

