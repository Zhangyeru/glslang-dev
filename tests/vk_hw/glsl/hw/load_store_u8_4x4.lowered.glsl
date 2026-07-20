#version 460
#extension GL_EXT_shader_explicit_arithmetic_types_int8 : require
#extension GL_EXT_shader_8bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    uint8_t data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    uint8_t data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    uint8_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    uint8_t data[];
} C;

void main()
{
    uint8_t _62 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)];
    uint8_t _76 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)];
    uint8_t _91 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)];
    uint8_t _106 = A.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)];
    uint8_t _120 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)];
    uint8_t _134 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)];
    uint8_t _148 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)];
    uint8_t _162 = A.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)];
    uint8_t _176 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)];
    uint8_t _190 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)];
    uint8_t _204 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)];
    uint8_t _218 = A.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)];
    uint8_t _232 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)];
    uint8_t _246 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)];
    uint8_t _260 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)];
    uint8_t _274 = A.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)];
    uint8_t _24[16] = uint8_t[](_62, _76, _91, _106, _120, _134, _148, _162, _176, _190, _204, _218, _232, _246, _260, _274);
    uint8_t tempArg[16] = _24;
    uint8_t value[16] = _24;
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)] = _24[0];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)] = _24[1];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)] = _24[2];
    D.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)] = _24[3];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)] = _24[4];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)] = _24[5];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)] = _24[6];
    D.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)] = _24[7];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)] = _24[8];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)] = _24[9];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)] = _24[10];
    D.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)] = _24[11];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)] = _24[12];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)] = _24[13];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)] = _24[14];
    D.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)] = _24[15];
}

