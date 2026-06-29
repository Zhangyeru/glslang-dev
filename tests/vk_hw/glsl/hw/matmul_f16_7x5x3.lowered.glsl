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

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

void main()
{
    float16_t _26[21] = float16_t[](A.data[((uint(0) + 0u) * uint(3)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(3)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(3)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(3)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(3)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(3)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(3)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(3)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(3)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(3)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(3)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(3)) + (uint(0) + 2u)], A.data[((uint(0) + 4u) * uint(3)) + (uint(0) + 0u)], A.data[((uint(0) + 4u) * uint(3)) + (uint(0) + 1u)], A.data[((uint(0) + 4u) * uint(3)) + (uint(0) + 2u)], A.data[((uint(0) + 5u) * uint(3)) + (uint(0) + 0u)], A.data[((uint(0) + 5u) * uint(3)) + (uint(0) + 1u)], A.data[((uint(0) + 5u) * uint(3)) + (uint(0) + 2u)], A.data[((uint(0) + 6u) * uint(3)) + (uint(0) + 0u)], A.data[((uint(0) + 6u) * uint(3)) + (uint(0) + 1u)], A.data[((uint(0) + 6u) * uint(3)) + (uint(0) + 2u)]);
    float16_t tempArg[21] = _26;
    float16_t a[21] = _26;
    float16_t _41[15] = float16_t[](B.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)], B.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)], B.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)], B.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)], B.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)], B.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)], B.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)], B.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)], B.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)], B.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)], B.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)], B.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)], B.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)], B.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)], B.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)]);
    float16_t tempArg_1[15] = _41;
    float16_t b[15] = _41;
    float16_t _54[35] = float16_t[](C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)], C.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)]);
    float16_t tempArg_2[35] = _54;
    float16_t c[35] = _54;
    float16_t _61[35] = float16_t[](fma(_26[2], _41[10], fma(_26[1], _41[5], fma(_26[0], _41[0], _54[0]))), fma(_26[2], _41[11], fma(_26[1], _41[6], fma(_26[0], _41[1], _54[1]))), fma(_26[2], _41[12], fma(_26[1], _41[7], fma(_26[0], _41[2], _54[2]))), fma(_26[2], _41[13], fma(_26[1], _41[8], fma(_26[0], _41[3], _54[3]))), fma(_26[2], _41[14], fma(_26[1], _41[9], fma(_26[0], _41[4], _54[4]))), fma(_26[5], _41[10], fma(_26[4], _41[5], fma(_26[3], _41[0], _54[5]))), fma(_26[5], _41[11], fma(_26[4], _41[6], fma(_26[3], _41[1], _54[6]))), fma(_26[5], _41[12], fma(_26[4], _41[7], fma(_26[3], _41[2], _54[7]))), fma(_26[5], _41[13], fma(_26[4], _41[8], fma(_26[3], _41[3], _54[8]))), fma(_26[5], _41[14], fma(_26[4], _41[9], fma(_26[3], _41[4], _54[9]))), fma(_26[8], _41[10], fma(_26[7], _41[5], fma(_26[6], _41[0], _54[10]))), fma(_26[8], _41[11], fma(_26[7], _41[6], fma(_26[6], _41[1], _54[11]))), fma(_26[8], _41[12], fma(_26[7], _41[7], fma(_26[6], _41[2], _54[12]))), fma(_26[8], _41[13], fma(_26[7], _41[8], fma(_26[6], _41[3], _54[13]))), fma(_26[8], _41[14], fma(_26[7], _41[9], fma(_26[6], _41[4], _54[14]))), fma(_26[11], _41[10], fma(_26[10], _41[5], fma(_26[9], _41[0], _54[15]))), fma(_26[11], _41[11], fma(_26[10], _41[6], fma(_26[9], _41[1], _54[16]))), fma(_26[11], _41[12], fma(_26[10], _41[7], fma(_26[9], _41[2], _54[17]))), fma(_26[11], _41[13], fma(_26[10], _41[8], fma(_26[9], _41[3], _54[18]))), fma(_26[11], _41[14], fma(_26[10], _41[9], fma(_26[9], _41[4], _54[19]))), fma(_26[14], _41[10], fma(_26[13], _41[5], fma(_26[12], _41[0], _54[20]))), fma(_26[14], _41[11], fma(_26[13], _41[6], fma(_26[12], _41[1], _54[21]))), fma(_26[14], _41[12], fma(_26[13], _41[7], fma(_26[12], _41[2], _54[22]))), fma(_26[14], _41[13], fma(_26[13], _41[8], fma(_26[12], _41[3], _54[23]))), fma(_26[14], _41[14], fma(_26[13], _41[9], fma(_26[12], _41[4], _54[24]))), fma(_26[17], _41[10], fma(_26[16], _41[5], fma(_26[15], _41[0], _54[25]))), fma(_26[17], _41[11], fma(_26[16], _41[6], fma(_26[15], _41[1], _54[26]))), fma(_26[17], _41[12], fma(_26[16], _41[7], fma(_26[15], _41[2], _54[27]))), fma(_26[17], _41[13], fma(_26[16], _41[8], fma(_26[15], _41[3], _54[28]))), fma(_26[17], _41[14], fma(_26[16], _41[9], fma(_26[15], _41[4], _54[29]))), fma(_26[20], _41[10], fma(_26[19], _41[5], fma(_26[18], _41[0], _54[30]))), fma(_26[20], _41[11], fma(_26[19], _41[6], fma(_26[18], _41[1], _54[31]))), fma(_26[20], _41[12], fma(_26[19], _41[7], fma(_26[18], _41[2], _54[32]))), fma(_26[20], _41[13], fma(_26[19], _41[8], fma(_26[18], _41[3], _54[33]))), fma(_26[20], _41[14], fma(_26[19], _41[9], fma(_26[18], _41[4], _54[34]))));
    float16_t tempArg_3[35] = _61;
    float16_t d[35] = _61;
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)] = _61[0];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)] = _61[1];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)] = _61[2];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)] = _61[3];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)] = _61[4];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)] = _61[5];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)] = _61[6];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)] = _61[7];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)] = _61[8];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)] = _61[9];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)] = _61[10];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)] = _61[11];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)] = _61[12];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)] = _61[13];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)] = _61[14];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)] = _61[15];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)] = _61[16];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)] = _61[17];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)] = _61[18];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)] = _61[19];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)] = _61[20];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)] = _61[21];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)] = _61[22];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)] = _61[23];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)] = _61[24];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)] = _61[25];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)] = _61[26];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)] = _61[27];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)] = _61[28];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)] = _61[29];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)] = _61[30];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)] = _61[31];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)] = _61[32];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)] = _61[33];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)] = _61[34];
}

