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
    float data[];
} Bias;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

float[3] _79()
{
    uint _120 = 0u / 3u;
    uint _121 = 0u % 3u;
    uint _134 = 1u / 3u;
    uint _135 = 1u % 3u;
    uint _148 = 2u / 3u;
    uint _149 = 2u % 3u;
    uint _162 = 3u / 3u;
    uint _163 = 3u % 3u;
    uint _176 = 4u / 3u;
    uint _177 = 4u % 3u;
    uint _190 = 5u / 3u;
    uint _191 = 5u % 3u;
    uint _204 = 6u / 3u;
    uint _205 = 6u % 3u;
    uint _218 = 7u / 3u;
    uint _219 = 7u % 3u;
    uint _232 = 8u / 3u;
    uint _233 = 8u % 3u;
    uint _246 = 9u / 3u;
    uint _247 = 9u % 3u;
    uint _260 = 10u / 3u;
    uint _261 = 10u % 3u;
    uint _275 = 11u / 3u;
    uint _276 = 11u % 3u;
    uint _290 = 12u / 3u;
    uint _291 = 12u % 3u;
    uint _305 = 13u / 3u;
    uint _306 = 13u % 3u;
    uint _320 = 14u / 3u;
    uint _321 = 14u % 3u;
    uint _335 = 15u / 3u;
    uint _336 = 15u % 3u;
    uint _350 = 16u / 3u;
    uint _351 = 16u % 3u;
    uint _365 = 17u / 3u;
    uint _366 = 17u % 3u;
    uint _380 = 18u / 3u;
    uint _381 = 18u % 3u;
    uint _395 = 19u / 3u;
    uint _396 = 19u % 3u;
    uint _410 = 20u / 3u;
    uint _411 = 20u % 3u;
    uint _425 = 21u / 3u;
    uint _426 = 21u % 3u;
    uint _440 = 22u / 3u;
    uint _441 = 22u % 3u;
    uint _455 = 23u / 3u;
    uint _456 = 23u % 3u;
    uint _470 = 24u / 3u;
    uint _471 = 24u % 3u;
    uint _485 = 25u / 3u;
    uint _486 = 25u % 3u;
    uint _500 = 26u / 3u;
    uint _501 = 26u % 3u;
    uint _515 = 27u / 3u;
    uint _516 = 27u % 3u;
    uint _530 = 28u / 3u;
    uint _531 = 28u % 3u;
    uint _545 = 29u / 3u;
    uint _546 = 29u % 3u;
    vec2 _567 = fma(vec2(f16vec2(X.data[4u], X.data[5u])), vec2(f16vec2(W.data[((uint(0) + _290) * uint(3)) + (uint(0) + _291)], W.data[((uint(0) + _335) * uint(3)) + (uint(0) + _336)])), fma(vec2(f16vec2(X.data[2u], X.data[3u])), vec2(f16vec2(W.data[((uint(0) + _204) * uint(3)) + (uint(0) + _205)], W.data[((uint(0) + _246) * uint(3)) + (uint(0) + _247)])), fma(vec2(f16vec2(X.data[0u], X.data[1u])), vec2(f16vec2(W.data[((uint(0) + _120) * uint(3)) + (uint(0) + _121)], W.data[((uint(0) + _162) * uint(3)) + (uint(0) + _163)])), vec2(0.0))));
    vec2 _577 = fma(vec2(f16vec2(X.data[8u], X.data[9u])), vec2(f16vec2(W.data[((uint(0) + _470) * uint(3)) + (uint(0) + _471)], W.data[((uint(0) + _515) * uint(3)) + (uint(0) + _516)])), fma(vec2(f16vec2(X.data[6u], X.data[7u])), vec2(f16vec2(W.data[((uint(0) + _380) * uint(3)) + (uint(0) + _381)], W.data[((uint(0) + _425) * uint(3)) + (uint(0) + _426)])), _567));
    vec2 _599 = fma(vec2(f16vec2(X.data[4u], X.data[5u])), vec2(f16vec2(W.data[((uint(0) + _305) * uint(3)) + (uint(0) + _306)], W.data[((uint(0) + _350) * uint(3)) + (uint(0) + _351)])), fma(vec2(f16vec2(X.data[2u], X.data[3u])), vec2(f16vec2(W.data[((uint(0) + _218) * uint(3)) + (uint(0) + _219)], W.data[((uint(0) + _260) * uint(3)) + (uint(0) + _261)])), fma(vec2(f16vec2(X.data[0u], X.data[1u])), vec2(f16vec2(W.data[((uint(0) + _134) * uint(3)) + (uint(0) + _135)], W.data[((uint(0) + _176) * uint(3)) + (uint(0) + _177)])), vec2(0.0))));
    vec2 _609 = fma(vec2(f16vec2(X.data[8u], X.data[9u])), vec2(f16vec2(W.data[((uint(0) + _485) * uint(3)) + (uint(0) + _486)], W.data[((uint(0) + _530) * uint(3)) + (uint(0) + _531)])), fma(vec2(f16vec2(X.data[6u], X.data[7u])), vec2(f16vec2(W.data[((uint(0) + _395) * uint(3)) + (uint(0) + _396)], W.data[((uint(0) + _440) * uint(3)) + (uint(0) + _441)])), _599));
    vec2 _630 = fma(vec2(f16vec2(X.data[4u], X.data[5u])), vec2(f16vec2(W.data[((uint(0) + _320) * uint(3)) + (uint(0) + _321)], W.data[((uint(0) + _365) * uint(3)) + (uint(0) + _366)])), fma(vec2(f16vec2(X.data[2u], X.data[3u])), vec2(f16vec2(W.data[((uint(0) + _232) * uint(3)) + (uint(0) + _233)], W.data[((uint(0) + _275) * uint(3)) + (uint(0) + _276)])), fma(vec2(f16vec2(X.data[0u], X.data[1u])), vec2(f16vec2(W.data[((uint(0) + _148) * uint(3)) + (uint(0) + _149)], W.data[((uint(0) + _190) * uint(3)) + (uint(0) + _191)])), vec2(0.0))));
    vec2 _640 = fma(vec2(f16vec2(X.data[8u], X.data[9u])), vec2(f16vec2(W.data[((uint(0) + _500) * uint(3)) + (uint(0) + _501)], W.data[((uint(0) + _545) * uint(3)) + (uint(0) + _546)])), fma(vec2(f16vec2(X.data[6u], X.data[7u])), vec2(f16vec2(W.data[((uint(0) + _410) * uint(3)) + (uint(0) + _411)], W.data[((uint(0) + _455) * uint(3)) + (uint(0) + _456)])), _630));
    return float[]((_577.x + _577.y) + Bias.data[0u], (_609.x + _609.y) + Bias.data[1u], (_640.x + _640.y) + Bias.data[2u]);
}

void main()
{
    float _59[3] = _79();
    float tempArg[3] = _59;
    float y[3] = _59;
    uint _649 = 0u + 0u;
    Y.data[_649] = _59[0];
    uint _652 = 0u + 1u;
    Y.data[_652] = _59[1];
    uint _655 = 0u + 2u;
    Y.data[_655] = _59[2];
}

