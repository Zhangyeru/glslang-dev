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

float16_t[3] _69()
{
    uint _95 = 0u / 3u;
    uint _96 = 0u % 3u;
    uint _109 = 1u / 3u;
    uint _110 = 1u % 3u;
    uint _123 = 2u / 3u;
    uint _124 = 2u % 3u;
    uint _137 = 3u / 3u;
    uint _138 = 3u % 3u;
    uint _151 = 4u / 3u;
    uint _152 = 4u % 3u;
    uint _165 = 5u / 3u;
    uint _166 = 5u % 3u;
    uint _180 = 6u / 3u;
    uint _181 = 6u % 3u;
    uint _195 = 7u / 3u;
    uint _196 = 7u % 3u;
    uint _210 = 8u / 3u;
    uint _211 = 8u % 3u;
    uint _225 = 9u / 3u;
    uint _226 = 9u % 3u;
    uint _240 = 10u / 3u;
    uint _241 = 10u % 3u;
    uint _255 = 11u / 3u;
    uint _256 = 11u % 3u;
    uint _270 = 12u / 3u;
    uint _271 = 12u % 3u;
    uint _285 = 13u / 3u;
    uint _286 = 13u % 3u;
    uint _300 = 14u / 3u;
    uint _301 = 14u % 3u;
    f16vec2 _316 = fma(f16vec2(X.data[4u], float16_t(0.0)), f16vec2(W.data[((uint(0) + _270) * uint(3)) + (uint(0) + _271)], float16_t(0.0)), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[((uint(0) + _180) * uint(3)) + (uint(0) + _181)], W.data[((uint(0) + _225) * uint(3)) + (uint(0) + _226)]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[((uint(0) + _95) * uint(3)) + (uint(0) + _96)], W.data[((uint(0) + _137) * uint(3)) + (uint(0) + _138)]), f16vec2(float16_t(0.0)))));
    f16vec2 _328 = fma(f16vec2(X.data[4u], float16_t(0.0)), f16vec2(W.data[((uint(0) + _285) * uint(3)) + (uint(0) + _286)], float16_t(0.0)), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[((uint(0) + _195) * uint(3)) + (uint(0) + _196)], W.data[((uint(0) + _240) * uint(3)) + (uint(0) + _241)]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[((uint(0) + _109) * uint(3)) + (uint(0) + _110)], W.data[((uint(0) + _151) * uint(3)) + (uint(0) + _152)]), f16vec2(float16_t(0.0)))));
    f16vec2 _340 = fma(f16vec2(X.data[4u], float16_t(0.0)), f16vec2(W.data[((uint(0) + _300) * uint(3)) + (uint(0) + _301)], float16_t(0.0)), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[((uint(0) + _210) * uint(3)) + (uint(0) + _211)], W.data[((uint(0) + _255) * uint(3)) + (uint(0) + _256)]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[((uint(0) + _123) * uint(3)) + (uint(0) + _124)], W.data[((uint(0) + _165) * uint(3)) + (uint(0) + _166)]), f16vec2(float16_t(0.0)))));
    return float16_t[](_316.x + _316.y, _328.x + _328.y, _340.x + _340.y);
}

void main()
{
    float16_t _47[3] = _69();
    float16_t tempArg[3] = _47;
    float16_t y[3] = _47;
    uint _346 = 0u + 0u;
    Y.data[_346] = _47[0];
    uint _349 = 0u + 1u;
    Y.data[_349] = _47[1];
    uint _352 = 0u + 2u;
    Y.data[_352] = _47[2];
}

