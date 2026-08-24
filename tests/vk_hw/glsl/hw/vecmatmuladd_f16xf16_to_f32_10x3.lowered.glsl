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
    vec2 _253 = fma(vec2(f16vec2(X.data[6u])), vec2(f16vec2(W.data[18u], W.data[19u])), fma(vec2(f16vec2(X.data[5u])), vec2(f16vec2(W.data[15u], W.data[16u])), fma(vec2(f16vec2(X.data[4u])), vec2(f16vec2(W.data[12u], W.data[13u])), fma(vec2(f16vec2(X.data[3u])), vec2(f16vec2(W.data[9u], W.data[10u])), fma(vec2(f16vec2(X.data[2u])), vec2(f16vec2(W.data[6u], W.data[7u])), fma(vec2(f16vec2(X.data[1u])), vec2(f16vec2(W.data[3u], W.data[4u])), fma(vec2(f16vec2(X.data[0u])), vec2(f16vec2(W.data[0u], W.data[1u])), vec2(Bias.data[0u], Bias.data[1u]))))))));
    vec2 _277 = fma(vec2(f16vec2(X.data[9u])), vec2(f16vec2(W.data[27u], W.data[28u])), fma(vec2(f16vec2(X.data[8u])), vec2(f16vec2(W.data[24u], W.data[25u])), fma(vec2(f16vec2(X.data[7u])), vec2(f16vec2(W.data[21u], W.data[22u])), _253)));
    float _280 = fma(float(X.data[9u]), float(W.data[29u]), fma(float(X.data[8u]), float(W.data[26u]), fma(float(X.data[7u]), float(W.data[23u]), fma(float(X.data[6u]), float(W.data[20u]), fma(float(X.data[5u]), float(W.data[17u]), fma(float(X.data[4u]), float(W.data[14u]), fma(float(X.data[3u]), float(W.data[11u]), fma(float(X.data[2u]), float(W.data[8u]), fma(float(X.data[1u]), float(W.data[5u]), fma(float(X.data[0u]), float(W.data[2u]), Bias.data[2u]))))))))));
    return float[](_277.x, _277.y, _280);
}

void main()
{
    float _59[3] = _79();
    float tempArg[3] = _59;
    float y[3] = _59;
    uint _285 = 0u + 0u;
    Y.data[_285] = _59[0];
    uint _288 = 0u + 1u;
    Y.data[_288] = _59[1];
    uint _291 = 0u + 2u;
    Y.data[_291] = _59[2];
}

