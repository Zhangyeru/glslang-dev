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
    f16vec2 _136 = fma(f16vec2(X.data[4u], float16_t(0.0)), f16vec2(W.data[12u], float16_t(0.0)), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[6u], W.data[9u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[0u], W.data[3u]), f16vec2(float16_t(0.0)))));
    f16vec2 _148 = fma(f16vec2(X.data[4u], float16_t(0.0)), f16vec2(W.data[13u], float16_t(0.0)), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[7u], W.data[10u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[1u], W.data[4u]), f16vec2(float16_t(0.0)))));
    f16vec2 _160 = fma(f16vec2(X.data[4u], float16_t(0.0)), f16vec2(W.data[14u], float16_t(0.0)), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[8u], W.data[11u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[2u], W.data[5u]), f16vec2(float16_t(0.0)))));
    return float16_t[](_136.x + _136.y, _148.x + _148.y, _160.x + _160.y);
}

void main()
{
    float16_t _47[3] = _69();
    float16_t tempArg[3] = _47;
    float16_t y[3] = _47;
    uint _166 = 0u + 0u;
    Y.data[_166] = _47[0];
    uint _169 = 0u + 1u;
    Y.data[_169] = _47[1];
    uint _172 = 0u + 2u;
    Y.data[_172] = _47[2];
}

