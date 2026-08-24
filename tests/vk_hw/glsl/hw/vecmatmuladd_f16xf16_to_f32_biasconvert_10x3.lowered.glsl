#version 460
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

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float16_t data[];
} Bias;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

float[3] _85()
{
    vec2 _223 = fma(vec2(f16vec2(X.data[8u], X.data[9u])), vec2(f16vec2(W.data[24u], W.data[27u])), fma(vec2(f16vec2(X.data[6u], X.data[7u])), vec2(f16vec2(W.data[18u], W.data[21u])), fma(vec2(f16vec2(X.data[4u], X.data[5u])), vec2(f16vec2(W.data[12u], W.data[15u])), fma(vec2(f16vec2(X.data[2u], X.data[3u])), vec2(f16vec2(W.data[6u], W.data[9u])), fma(vec2(f16vec2(X.data[0u], X.data[1u])), vec2(f16vec2(W.data[0u], W.data[3u])), vec2(0.0))))));
    vec2 _255 = fma(vec2(f16vec2(X.data[8u], X.data[9u])), vec2(f16vec2(W.data[25u], W.data[28u])), fma(vec2(f16vec2(X.data[6u], X.data[7u])), vec2(f16vec2(W.data[19u], W.data[22u])), fma(vec2(f16vec2(X.data[4u], X.data[5u])), vec2(f16vec2(W.data[13u], W.data[16u])), fma(vec2(f16vec2(X.data[2u], X.data[3u])), vec2(f16vec2(W.data[7u], W.data[10u])), fma(vec2(f16vec2(X.data[0u], X.data[1u])), vec2(f16vec2(W.data[1u], W.data[4u])), vec2(0.0))))));
    vec2 _287 = fma(vec2(f16vec2(X.data[8u], X.data[9u])), vec2(f16vec2(W.data[26u], W.data[29u])), fma(vec2(f16vec2(X.data[6u], X.data[7u])), vec2(f16vec2(W.data[20u], W.data[23u])), fma(vec2(f16vec2(X.data[4u], X.data[5u])), vec2(f16vec2(W.data[14u], W.data[17u])), fma(vec2(f16vec2(X.data[2u], X.data[3u])), vec2(f16vec2(W.data[8u], W.data[11u])), fma(vec2(f16vec2(X.data[0u], X.data[1u])), vec2(f16vec2(W.data[2u], W.data[5u])), vec2(0.0))))));
    return float[]((_223.x + _223.y) + float(Bias.data[0u]), (_255.x + _255.y) + float(Bias.data[1u]), (_287.x + _287.y) + float(Bias.data[2u]));
}

void main()
{
    float _64[3] = _85();
    float tempArg[3] = _64;
    float y[3] = _64;
    uint _297 = 0u + 0u;
    Y.data[_297] = _64[0];
    uint _301 = 0u + 1u;
    Y.data[_301] = _64[1];
    uint _304 = 0u + 2u;
    Y.data[_304] = _64[2];
}

