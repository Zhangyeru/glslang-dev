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

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float16_t data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

void main()
{
    uint _68 = 0u + 0u;
    float16_t _71 = X.data[_68];
    uint _72 = 0u + 1u;
    float16_t _74 = X.data[_72];
    uint _76 = 0u + 2u;
    float16_t _78 = X.data[_76];
    uint _79 = 0u + 3u;
    float16_t _81 = X.data[_79];
    uint _83 = 0u + 4u;
    float16_t _85 = X.data[_83];
    float16_t _21[5] = float16_t[](_71, _74, _78, _81, _85);
    float16_t tempArg[5] = _21;
    float16_t x[5] = _21;
    float16_t _39[15] = float16_t[](W.data[((uint(0) + 0u) * uint(3)) + (uint(0) + 0u)], W.data[((uint(0) + 0u) * uint(3)) + (uint(0) + 1u)], W.data[((uint(0) + 0u) * uint(3)) + (uint(0) + 2u)], W.data[((uint(0) + 1u) * uint(3)) + (uint(0) + 0u)], W.data[((uint(0) + 1u) * uint(3)) + (uint(0) + 1u)], W.data[((uint(0) + 1u) * uint(3)) + (uint(0) + 2u)], W.data[((uint(0) + 2u) * uint(3)) + (uint(0) + 0u)], W.data[((uint(0) + 2u) * uint(3)) + (uint(0) + 1u)], W.data[((uint(0) + 2u) * uint(3)) + (uint(0) + 2u)], W.data[((uint(0) + 3u) * uint(3)) + (uint(0) + 0u)], W.data[((uint(0) + 3u) * uint(3)) + (uint(0) + 1u)], W.data[((uint(0) + 3u) * uint(3)) + (uint(0) + 2u)], W.data[((uint(0) + 4u) * uint(3)) + (uint(0) + 0u)], W.data[((uint(0) + 4u) * uint(3)) + (uint(0) + 1u)], W.data[((uint(0) + 4u) * uint(3)) + (uint(0) + 2u)]);
    float16_t tempArg_1[15] = _39;
    float16_t w[15] = _39;
    float16_t _297 = _21[0];
    float16_t _304 = _21[1];
    float16_t _311 = _21[2];
    float16_t _318 = _21[3];
    float16_t _325 = _21[4];
    float16_t _47[3] = float16_t[](fma(_325, _39[12], fma(_318, _39[9], fma(_311, _39[6], fma(_304, _39[3], fma(_297, _39[0], float16_t(0.0)))))), fma(_325, _39[13], fma(_318, _39[10], fma(_311, _39[7], fma(_304, _39[4], fma(_297, _39[1], float16_t(0.0)))))), fma(_325, _39[14], fma(_318, _39[11], fma(_311, _39[8], fma(_304, _39[5], fma(_297, _39[2], float16_t(0.0)))))));
    float16_t tempArg_2[3] = _47;
    float16_t y[3] = _47;
    uint _333 = 0u + 0u;
    Y.data[_333] = _47[0];
    uint _336 = 0u + 1u;
    Y.data[_336] = _47[1];
    uint _339 = 0u + 2u;
    Y.data[_339] = _47[2];
}

