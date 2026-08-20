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
    uint _126 = 0u / 3u;
    uint _127 = 0u % 3u;
    uint _140 = 1u / 3u;
    uint _141 = 1u % 3u;
    uint _154 = 2u / 3u;
    uint _155 = 2u % 3u;
    uint _168 = 3u / 3u;
    uint _169 = 3u % 3u;
    uint _182 = 4u / 3u;
    uint _183 = 4u % 3u;
    uint _196 = 5u / 3u;
    uint _197 = 5u % 3u;
    uint _210 = 6u / 3u;
    uint _211 = 6u % 3u;
    uint _224 = 7u / 3u;
    uint _225 = 7u % 3u;
    uint _238 = 8u / 3u;
    uint _239 = 8u % 3u;
    uint _252 = 9u / 3u;
    uint _253 = 9u % 3u;
    uint _266 = 10u / 3u;
    uint _267 = 10u % 3u;
    uint _281 = 11u / 3u;
    uint _282 = 11u % 3u;
    uint _296 = 12u / 3u;
    uint _297 = 12u % 3u;
    uint _311 = 13u / 3u;
    uint _312 = 13u % 3u;
    uint _326 = 14u / 3u;
    uint _327 = 14u % 3u;
    uint _341 = 15u / 3u;
    uint _342 = 15u % 3u;
    uint _356 = 16u / 3u;
    uint _357 = 16u % 3u;
    uint _371 = 17u / 3u;
    uint _372 = 17u % 3u;
    uint _386 = 18u / 3u;
    uint _387 = 18u % 3u;
    uint _401 = 19u / 3u;
    uint _402 = 19u % 3u;
    uint _416 = 20u / 3u;
    uint _417 = 20u % 3u;
    uint _431 = 21u / 3u;
    uint _432 = 21u % 3u;
    uint _446 = 22u / 3u;
    uint _447 = 22u % 3u;
    uint _461 = 23u / 3u;
    uint _462 = 23u % 3u;
    uint _476 = 24u / 3u;
    uint _477 = 24u % 3u;
    uint _491 = 25u / 3u;
    uint _492 = 25u % 3u;
    uint _506 = 26u / 3u;
    uint _507 = 26u % 3u;
    uint _521 = 27u / 3u;
    uint _522 = 27u % 3u;
    uint _536 = 28u / 3u;
    uint _537 = 28u % 3u;
    uint _551 = 29u / 3u;
    uint _552 = 29u % 3u;
    vec2 _573 = fma(vec2(f16vec2(X.data[4u], X.data[5u])), vec2(f16vec2(W.data[((uint(0) + _296) * uint(3)) + (uint(0) + _297)], W.data[((uint(0) + _341) * uint(3)) + (uint(0) + _342)])), fma(vec2(f16vec2(X.data[2u], X.data[3u])), vec2(f16vec2(W.data[((uint(0) + _210) * uint(3)) + (uint(0) + _211)], W.data[((uint(0) + _252) * uint(3)) + (uint(0) + _253)])), fma(vec2(f16vec2(X.data[0u], X.data[1u])), vec2(f16vec2(W.data[((uint(0) + _126) * uint(3)) + (uint(0) + _127)], W.data[((uint(0) + _168) * uint(3)) + (uint(0) + _169)])), vec2(0.0))));
    vec2 _583 = fma(vec2(f16vec2(X.data[8u], X.data[9u])), vec2(f16vec2(W.data[((uint(0) + _476) * uint(3)) + (uint(0) + _477)], W.data[((uint(0) + _521) * uint(3)) + (uint(0) + _522)])), fma(vec2(f16vec2(X.data[6u], X.data[7u])), vec2(f16vec2(W.data[((uint(0) + _386) * uint(3)) + (uint(0) + _387)], W.data[((uint(0) + _431) * uint(3)) + (uint(0) + _432)])), _573));
    vec2 _605 = fma(vec2(f16vec2(X.data[4u], X.data[5u])), vec2(f16vec2(W.data[((uint(0) + _311) * uint(3)) + (uint(0) + _312)], W.data[((uint(0) + _356) * uint(3)) + (uint(0) + _357)])), fma(vec2(f16vec2(X.data[2u], X.data[3u])), vec2(f16vec2(W.data[((uint(0) + _224) * uint(3)) + (uint(0) + _225)], W.data[((uint(0) + _266) * uint(3)) + (uint(0) + _267)])), fma(vec2(f16vec2(X.data[0u], X.data[1u])), vec2(f16vec2(W.data[((uint(0) + _140) * uint(3)) + (uint(0) + _141)], W.data[((uint(0) + _182) * uint(3)) + (uint(0) + _183)])), vec2(0.0))));
    vec2 _615 = fma(vec2(f16vec2(X.data[8u], X.data[9u])), vec2(f16vec2(W.data[((uint(0) + _491) * uint(3)) + (uint(0) + _492)], W.data[((uint(0) + _536) * uint(3)) + (uint(0) + _537)])), fma(vec2(f16vec2(X.data[6u], X.data[7u])), vec2(f16vec2(W.data[((uint(0) + _401) * uint(3)) + (uint(0) + _402)], W.data[((uint(0) + _446) * uint(3)) + (uint(0) + _447)])), _605));
    vec2 _637 = fma(vec2(f16vec2(X.data[4u], X.data[5u])), vec2(f16vec2(W.data[((uint(0) + _326) * uint(3)) + (uint(0) + _327)], W.data[((uint(0) + _371) * uint(3)) + (uint(0) + _372)])), fma(vec2(f16vec2(X.data[2u], X.data[3u])), vec2(f16vec2(W.data[((uint(0) + _238) * uint(3)) + (uint(0) + _239)], W.data[((uint(0) + _281) * uint(3)) + (uint(0) + _282)])), fma(vec2(f16vec2(X.data[0u], X.data[1u])), vec2(f16vec2(W.data[((uint(0) + _154) * uint(3)) + (uint(0) + _155)], W.data[((uint(0) + _196) * uint(3)) + (uint(0) + _197)])), vec2(0.0))));
    vec2 _647 = fma(vec2(f16vec2(X.data[8u], X.data[9u])), vec2(f16vec2(W.data[((uint(0) + _506) * uint(3)) + (uint(0) + _507)], W.data[((uint(0) + _551) * uint(3)) + (uint(0) + _552)])), fma(vec2(f16vec2(X.data[6u], X.data[7u])), vec2(f16vec2(W.data[((uint(0) + _416) * uint(3)) + (uint(0) + _417)], W.data[((uint(0) + _461) * uint(3)) + (uint(0) + _462)])), _637));
    return float[]((_583.x + _583.y) + float(Bias.data[0u]), (_615.x + _615.y) + float(Bias.data[1u]), (_647.x + _647.y) + float(Bias.data[2u]));
}

void main()
{
    float _64[3] = _85();
    float tempArg[3] = _64;
    float y[3] = _64;
    uint _657 = 0u + 0u;
    Y.data[_657] = _64[0];
    uint _661 = 0u + 1u;
    Y.data[_661] = _64[1];
    uint _664 = 0u + 2u;
    Y.data[_664] = _64[2];
}

