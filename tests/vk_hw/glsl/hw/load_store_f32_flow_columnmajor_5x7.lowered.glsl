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
    float _65 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)];
    float _79 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)];
    float _94 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)];
    float _109 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)];
    float _124 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)];
    float _138 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)];
    float _153 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)];
    float _167 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)];
    float _181 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)];
    float _195 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)];
    float _209 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)];
    float _223 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)];
    float _237 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)];
    float _251 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)];
    float _265 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)];
    float _279 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)];
    float _293 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)];
    float _307 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)];
    float _321 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)];
    float _335 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)];
    float _349 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)];
    float _363 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)];
    float _377 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)];
    float _391 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)];
    float _405 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)];
    float _419 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)];
    float _433 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)];
    float _447 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)];
    float _461 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)];
    float _475 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)];
    float _489 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)];
    float _503 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)];
    float _517 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)];
    float _531 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)];
    float _545 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)];
    float _27[35] = float[](_65, _79, _94, _109, _124, _138, _153, _167, _181, _195, _209, _223, _237, _251, _265, _279, _293, _307, _321, _335, _349, _363, _377, _391, _405, _419, _433, _447, _461, _475, _489, _503, _517, _531, _545);
    float tempArg[35] = _27;
    float value[35] = _27;
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)] = _27[0];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)] = _27[1];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)] = _27[2];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)] = _27[3];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)] = _27[4];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)] = _27[5];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)] = _27[6];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)] = _27[7];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)] = _27[8];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)] = _27[9];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)] = _27[10];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)] = _27[11];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)] = _27[12];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)] = _27[13];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)] = _27[14];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)] = _27[15];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)] = _27[16];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)] = _27[17];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)] = _27[18];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)] = _27[19];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)] = _27[20];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)] = _27[21];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)] = _27[22];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)] = _27[23];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)] = _27[24];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)] = _27[25];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)] = _27[26];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)] = _27[27];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)] = _27[28];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)] = _27[29];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)] = _27[30];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)] = _27[31];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)] = _27[32];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)] = _27[33];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)] = _27[34];
}

