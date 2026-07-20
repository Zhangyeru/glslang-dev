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
    uint8_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    int data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    int data[];
} D;

void main()
{
    int8_t _24[16] = int8_t[](A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    int8_t tempArg[16] = _24;
    int8_t a[16] = _24;
    uint8_t _37[16] = uint8_t[](B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], B.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    uint8_t tempArg_1[16] = _37;
    uint8_t b[16] = _37;
    int _49[16] = int[](C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], C.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    int tempArg_2[16] = _49;
    int bias[16] = _49;
    int _56[16] = int[]((int(_24[3]) * int(uint(_37[12]))) + ((int(_24[2]) * int(uint(_37[8]))) + ((int(_24[1]) * int(uint(_37[4]))) + ((int(_24[0]) * int(uint(_37[0]))) + _49[0]))), (int(_24[3]) * int(uint(_37[13]))) + ((int(_24[2]) * int(uint(_37[9]))) + ((int(_24[1]) * int(uint(_37[5]))) + ((int(_24[0]) * int(uint(_37[1]))) + _49[1]))), (int(_24[3]) * int(uint(_37[14]))) + ((int(_24[2]) * int(uint(_37[10]))) + ((int(_24[1]) * int(uint(_37[6]))) + ((int(_24[0]) * int(uint(_37[2]))) + _49[2]))), (int(_24[3]) * int(uint(_37[15]))) + ((int(_24[2]) * int(uint(_37[11]))) + ((int(_24[1]) * int(uint(_37[7]))) + ((int(_24[0]) * int(uint(_37[3]))) + _49[3]))), (int(_24[7]) * int(uint(_37[12]))) + ((int(_24[6]) * int(uint(_37[8]))) + ((int(_24[5]) * int(uint(_37[4]))) + ((int(_24[4]) * int(uint(_37[0]))) + _49[4]))), (int(_24[7]) * int(uint(_37[13]))) + ((int(_24[6]) * int(uint(_37[9]))) + ((int(_24[5]) * int(uint(_37[5]))) + ((int(_24[4]) * int(uint(_37[1]))) + _49[5]))), (int(_24[7]) * int(uint(_37[14]))) + ((int(_24[6]) * int(uint(_37[10]))) + ((int(_24[5]) * int(uint(_37[6]))) + ((int(_24[4]) * int(uint(_37[2]))) + _49[6]))), (int(_24[7]) * int(uint(_37[15]))) + ((int(_24[6]) * int(uint(_37[11]))) + ((int(_24[5]) * int(uint(_37[7]))) + ((int(_24[4]) * int(uint(_37[3]))) + _49[7]))), (int(_24[11]) * int(uint(_37[12]))) + ((int(_24[10]) * int(uint(_37[8]))) + ((int(_24[9]) * int(uint(_37[4]))) + ((int(_24[8]) * int(uint(_37[0]))) + _49[8]))), (int(_24[11]) * int(uint(_37[13]))) + ((int(_24[10]) * int(uint(_37[9]))) + ((int(_24[9]) * int(uint(_37[5]))) + ((int(_24[8]) * int(uint(_37[1]))) + _49[9]))), (int(_24[11]) * int(uint(_37[14]))) + ((int(_24[10]) * int(uint(_37[10]))) + ((int(_24[9]) * int(uint(_37[6]))) + ((int(_24[8]) * int(uint(_37[2]))) + _49[10]))), (int(_24[11]) * int(uint(_37[15]))) + ((int(_24[10]) * int(uint(_37[11]))) + ((int(_24[9]) * int(uint(_37[7]))) + ((int(_24[8]) * int(uint(_37[3]))) + _49[11]))), (int(_24[15]) * int(uint(_37[12]))) + ((int(_24[14]) * int(uint(_37[8]))) + ((int(_24[13]) * int(uint(_37[4]))) + ((int(_24[12]) * int(uint(_37[0]))) + _49[12]))), (int(_24[15]) * int(uint(_37[13]))) + ((int(_24[14]) * int(uint(_37[9]))) + ((int(_24[13]) * int(uint(_37[5]))) + ((int(_24[12]) * int(uint(_37[1]))) + _49[13]))), (int(_24[15]) * int(uint(_37[14]))) + ((int(_24[14]) * int(uint(_37[10]))) + ((int(_24[13]) * int(uint(_37[6]))) + ((int(_24[12]) * int(uint(_37[2]))) + _49[14]))), (int(_24[15]) * int(uint(_37[15]))) + ((int(_24[14]) * int(uint(_37[11]))) + ((int(_24[13]) * int(uint(_37[7]))) + ((int(_24[12]) * int(uint(_37[3]))) + _49[15]))));
    int tempArg_3[16] = _56;
    int d[16] = _56;
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)] = _56[0];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)] = _56[1];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)] = _56[2];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)] = _56[3];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)] = _56[4];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)] = _56[5];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)] = _56[6];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)] = _56[7];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)] = _56[8];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)] = _56[9];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)] = _56[10];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)] = _56[11];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)] = _56[12];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)] = _56[13];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)] = _56[14];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)] = _56[15];
}

