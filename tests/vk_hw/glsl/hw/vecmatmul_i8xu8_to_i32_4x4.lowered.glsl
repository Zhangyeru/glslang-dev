#version 460
#extension GL_EXT_shader_explicit_arithmetic_types_int8 : require
#extension GL_EXT_shader_8bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    int8_t data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    uint8_t data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    int data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    int data[];
} C;

void main()
{
    uint _67 = 0u + 0u;
    int8_t _70 = X.data[_67];
    uint _71 = 0u + 1u;
    int8_t _73 = X.data[_71];
    uint _75 = 0u + 2u;
    int8_t _77 = X.data[_75];
    uint _79 = 0u + 3u;
    int8_t _81 = X.data[_79];
    int8_t _21[4] = int8_t[](_70, _73, _77, _81);
    int8_t tempArg[4] = _21;
    int8_t x[4] = _21;
    uint8_t _38[16] = uint8_t[](W.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 0u)], W.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 1u)], W.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 2u)], W.data[((uint(0) + 0u) * uint(4)) + (uint(0) + 3u)], W.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 0u)], W.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 1u)], W.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 2u)], W.data[((uint(0) + 1u) * uint(4)) + (uint(0) + 3u)], W.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 0u)], W.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 1u)], W.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 2u)], W.data[((uint(0) + 2u) * uint(4)) + (uint(0) + 3u)], W.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 0u)], W.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 1u)], W.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 2u)], W.data[((uint(0) + 3u) * uint(4)) + (uint(0) + 3u)]);
    uint8_t tempArg_1[16] = _38;
    uint8_t w[16] = _38;
    int8_t _307 = _21[0];
    int8_t _332 = _21[1];
    int8_t _357 = _21[2];
    int8_t _382 = _21[3];
    int _46[4] = int[]((int(_382) * int(uint(_38[12]))) + ((int(_357) * int(uint(_38[8]))) + ((int(_332) * int(uint(_38[4]))) + ((int(_307) * int(uint(_38[0]))) + 0))), (int(_382) * int(uint(_38[13]))) + ((int(_357) * int(uint(_38[9]))) + ((int(_332) * int(uint(_38[5]))) + ((int(_307) * int(uint(_38[1]))) + 0))), (int(_382) * int(uint(_38[14]))) + ((int(_357) * int(uint(_38[10]))) + ((int(_332) * int(uint(_38[6]))) + ((int(_307) * int(uint(_38[2]))) + 0))), (int(_382) * int(uint(_38[15]))) + ((int(_357) * int(uint(_38[11]))) + ((int(_332) * int(uint(_38[7]))) + ((int(_307) * int(uint(_38[3]))) + 0))));
    int tempArg_2[4] = _46;
    int y[4] = _46;
    uint _408 = 0u + 0u;
    Y.data[_408] = _46[0];
    uint _412 = 0u + 1u;
    Y.data[_412] = _46[1];
    uint _415 = 0u + 2u;
    Y.data[_415] = _46[2];
    uint _418 = 0u + 3u;
    Y.data[_418] = _46[3];
}

