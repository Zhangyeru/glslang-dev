#version 460
#extension GL_EXT_shader_explicit_arithmetic_types_int8 : require
#extension GL_EXT_shader_8bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    int8_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    int8_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    int8_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    int8_t data[];
} D;

void main()
{
    int8_t _24[16] = int8_t[](A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    int8_t tempArg[16] = _24;
    int8_t a[16] = _24;
    int8_t _36[16] = int8_t[](B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    int8_t tempArg_1[16] = _36;
    int8_t b[16] = _36;
    int8_t _48[16] = int8_t[](C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    int8_t tempArg_2[16] = _48;
    int8_t c[16] = _48;
    int8_t _55[16] = int8_t[]((_24[3] * _36[12]) + ((_24[2] * _36[8]) + ((_24[1] * _36[4]) + ((_24[0] * _36[0]) + _48[0]))), (_24[3] * _36[13]) + ((_24[2] * _36[9]) + ((_24[1] * _36[5]) + ((_24[0] * _36[1]) + _48[1]))), (_24[3] * _36[14]) + ((_24[2] * _36[10]) + ((_24[1] * _36[6]) + ((_24[0] * _36[2]) + _48[2]))), (_24[3] * _36[15]) + ((_24[2] * _36[11]) + ((_24[1] * _36[7]) + ((_24[0] * _36[3]) + _48[3]))), (_24[7] * _36[12]) + ((_24[6] * _36[8]) + ((_24[5] * _36[4]) + ((_24[4] * _36[0]) + _48[4]))), (_24[7] * _36[13]) + ((_24[6] * _36[9]) + ((_24[5] * _36[5]) + ((_24[4] * _36[1]) + _48[5]))), (_24[7] * _36[14]) + ((_24[6] * _36[10]) + ((_24[5] * _36[6]) + ((_24[4] * _36[2]) + _48[6]))), (_24[7] * _36[15]) + ((_24[6] * _36[11]) + ((_24[5] * _36[7]) + ((_24[4] * _36[3]) + _48[7]))), (_24[11] * _36[12]) + ((_24[10] * _36[8]) + ((_24[9] * _36[4]) + ((_24[8] * _36[0]) + _48[8]))), (_24[11] * _36[13]) + ((_24[10] * _36[9]) + ((_24[9] * _36[5]) + ((_24[8] * _36[1]) + _48[9]))), (_24[11] * _36[14]) + ((_24[10] * _36[10]) + ((_24[9] * _36[6]) + ((_24[8] * _36[2]) + _48[10]))), (_24[11] * _36[15]) + ((_24[10] * _36[11]) + ((_24[9] * _36[7]) + ((_24[8] * _36[3]) + _48[11]))), (_24[15] * _36[12]) + ((_24[14] * _36[8]) + ((_24[13] * _36[4]) + ((_24[12] * _36[0]) + _48[12]))), (_24[15] * _36[13]) + ((_24[14] * _36[9]) + ((_24[13] * _36[5]) + ((_24[12] * _36[1]) + _48[13]))), (_24[15] * _36[14]) + ((_24[14] * _36[10]) + ((_24[13] * _36[6]) + ((_24[12] * _36[2]) + _48[14]))), (_24[15] * _36[15]) + ((_24[14] * _36[11]) + ((_24[13] * _36[7]) + ((_24[12] * _36[3]) + _48[15]))));
    int8_t tempArg_3[16] = _55;
    int8_t d[16] = _55;
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)] = _55[0];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)] = _55[1];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)] = _55[2];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)] = _55[3];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)] = _55[4];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)] = _55[5];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)] = _55[6];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)] = _55[7];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)] = _55[8];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)] = _55[9];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)] = _55[10];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)] = _55[11];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)] = _55[12];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)] = _55[13];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)] = _55[14];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)] = _55[15];
}

