#version 450
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

void main()
{
    float16_t _62 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 0u)];
    float16_t _76 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 1u)];
    float16_t _91 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 2u)];
    float16_t _106 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 3u)];
    float16_t _121 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 4u)];
    float16_t _136 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 5u)];
    float16_t _151 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 6u)];
    float16_t _166 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 7u)];
    float16_t _180 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 0u)];
    float16_t _194 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 1u)];
    float16_t _208 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 2u)];
    float16_t _222 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 3u)];
    float16_t _236 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 4u)];
    float16_t _250 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 5u)];
    float16_t _264 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 6u)];
    float16_t _278 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 7u)];
    float16_t _292 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 0u)];
    float16_t _306 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 1u)];
    float16_t _320 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 2u)];
    float16_t _334 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 3u)];
    float16_t _348 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 4u)];
    float16_t _362 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 5u)];
    float16_t _376 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 6u)];
    float16_t _390 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 7u)];
    float16_t _404 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 0u)];
    float16_t _418 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 1u)];
    float16_t _432 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 2u)];
    float16_t _446 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 3u)];
    float16_t _460 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 4u)];
    float16_t _474 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 5u)];
    float16_t _488 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 6u)];
    float16_t _502 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 7u)];
    float16_t _516 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 0u)];
    float16_t _530 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 1u)];
    float16_t _544 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 2u)];
    float16_t _558 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 3u)];
    float16_t _572 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 4u)];
    float16_t _586 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 5u)];
    float16_t _600 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 6u)];
    float16_t _614 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 7u)];
    float16_t _628 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 0u)];
    float16_t _642 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 1u)];
    float16_t _656 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 2u)];
    float16_t _670 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 3u)];
    float16_t _684 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 4u)];
    float16_t _698 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 5u)];
    float16_t _712 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 6u)];
    float16_t _726 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 7u)];
    float16_t _740 = A.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 0u)];
    float16_t _754 = A.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 1u)];
    float16_t _768 = A.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 2u)];
    float16_t _782 = A.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 3u)];
    float16_t _796 = A.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 4u)];
    float16_t _810 = A.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 5u)];
    float16_t _824 = A.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 6u)];
    float16_t _838 = A.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 7u)];
    float16_t _852 = A.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 0u)];
    float16_t _866 = A.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 1u)];
    float16_t _880 = A.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 2u)];
    float16_t _894 = A.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 3u)];
    float16_t _908 = A.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 4u)];
    float16_t _922 = A.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 5u)];
    float16_t _936 = A.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 6u)];
    float16_t _950 = A.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 7u)];
    float16_t _24[64] = float16_t[](_62, _76, _91, _106, _121, _136, _151, _166, _180, _194, _208, _222, _236, _250, _264, _278, _292, _306, _320, _334, _348, _362, _376, _390, _404, _418, _432, _446, _460, _474, _488, _502, _516, _530, _544, _558, _572, _586, _600, _614, _628, _642, _656, _670, _684, _698, _712, _726, _740, _754, _768, _782, _796, _810, _824, _838, _852, _866, _880, _894, _908, _922, _936, _950);
    float16_t tempArg[64] = _24;
    float16_t value[64] = _24;
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 0u)] = _24[0];
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 1u)] = _24[1];
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 2u)] = _24[2];
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 3u)] = _24[3];
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 4u)] = _24[4];
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 5u)] = _24[5];
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 6u)] = _24[6];
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 7u)] = _24[7];
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 0u)] = _24[8];
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 1u)] = _24[9];
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 2u)] = _24[10];
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 3u)] = _24[11];
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 4u)] = _24[12];
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 5u)] = _24[13];
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 6u)] = _24[14];
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 7u)] = _24[15];
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 0u)] = _24[16];
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 1u)] = _24[17];
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 2u)] = _24[18];
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 3u)] = _24[19];
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 4u)] = _24[20];
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 5u)] = _24[21];
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 6u)] = _24[22];
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 7u)] = _24[23];
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 0u)] = _24[24];
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 1u)] = _24[25];
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 2u)] = _24[26];
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 3u)] = _24[27];
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 4u)] = _24[28];
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 5u)] = _24[29];
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 6u)] = _24[30];
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 7u)] = _24[31];
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 0u)] = _24[32];
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 1u)] = _24[33];
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 2u)] = _24[34];
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 3u)] = _24[35];
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 4u)] = _24[36];
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 5u)] = _24[37];
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 6u)] = _24[38];
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 7u)] = _24[39];
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 0u)] = _24[40];
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 1u)] = _24[41];
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 2u)] = _24[42];
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 3u)] = _24[43];
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 4u)] = _24[44];
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 5u)] = _24[45];
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 6u)] = _24[46];
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 7u)] = _24[47];
    D.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 0u)] = _24[48];
    D.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 1u)] = _24[49];
    D.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 2u)] = _24[50];
    D.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 3u)] = _24[51];
    D.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 4u)] = _24[52];
    D.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 5u)] = _24[53];
    D.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 6u)] = _24[54];
    D.data[((uint(0) + 6u) * uint(8)) + (uint(0) + 7u)] = _24[55];
    D.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 0u)] = _24[56];
    D.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 1u)] = _24[57];
    D.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 2u)] = _24[58];
    D.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 3u)] = _24[59];
    D.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 4u)] = _24[60];
    D.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 5u)] = _24[61];
    D.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 6u)] = _24[62];
    D.data[((uint(0) + 7u) * uint(8)) + (uint(0) + 7u)] = _24[63];
}

