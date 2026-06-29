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
    float16_t _64 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)];
    float16_t _78 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)];
    float16_t _93 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)];
    float16_t _108 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)];
    float16_t _123 = A.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)];
    float16_t _137 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)];
    float16_t _151 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)];
    float16_t _165 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)];
    float16_t _179 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)];
    float16_t _193 = A.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)];
    float16_t _207 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)];
    float16_t _221 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)];
    float16_t _235 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)];
    float16_t _249 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)];
    float16_t _263 = A.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)];
    float16_t _277 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)];
    float16_t _291 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)];
    float16_t _305 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)];
    float16_t _319 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)];
    float16_t _333 = A.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)];
    float16_t _347 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)];
    float16_t _361 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)];
    float16_t _375 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)];
    float16_t _389 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)];
    float16_t _403 = A.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)];
    float16_t _417 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)];
    float16_t _431 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)];
    float16_t _445 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)];
    float16_t _459 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)];
    float16_t _473 = A.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)];
    float16_t _488 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)];
    float16_t _502 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)];
    float16_t _516 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)];
    float16_t _530 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)];
    float16_t _544 = A.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)];
    float16_t _26[35] = float16_t[](_64, _78, _93, _108, _123, _137, _151, _165, _179, _193, _207, _221, _235, _249, _263, _277, _291, _305, _319, _333, _347, _361, _375, _389, _403, _417, _431, _445, _459, _473, _488, _502, _516, _530, _544);
    float16_t tempArg[35] = _26;
    float16_t value[35] = _26;
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)] = _26[0];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)] = _26[1];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)] = _26[2];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)] = _26[3];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)] = _26[4];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)] = _26[5];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)] = _26[6];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)] = _26[7];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)] = _26[8];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)] = _26[9];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)] = _26[10];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)] = _26[11];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)] = _26[12];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)] = _26[13];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)] = _26[14];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)] = _26[15];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)] = _26[16];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)] = _26[17];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)] = _26[18];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)] = _26[19];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)] = _26[20];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)] = _26[21];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)] = _26[22];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)] = _26[23];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)] = _26[24];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)] = _26[25];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)] = _26[26];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)] = _26[27];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)] = _26[28];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)] = _26[29];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)] = _26[30];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)] = _26[31];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)] = _26[32];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)] = _26[33];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)] = _26[34];
}

