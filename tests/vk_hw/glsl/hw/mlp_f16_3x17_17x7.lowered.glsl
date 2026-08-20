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

const float16_t _97[7] = float16_t[](float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0), float16_t(0.0));

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[3];
} InX;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[51];
    float16_t w2[119];
} Weights;

layout(set = 0, binding = 2, std430) buffer PackedBias
{
    float16_t b1[17];
    float16_t b2[7];
} Biases;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[7];
} OutY;

void main()
{
    uint _923 = 0u + 0u;
    uint _926 = 0u + 1u;
    uint _929 = 0u + 2u;
    float16_t _21[3] = float16_t[](InX.x[_923], InX.x[_926], InX.x[_929]);
    float16_t tempArg[3] = _21;
    float16_t x[3] = _21;
    f16vec2 _166 = max(fma(f16vec2(_21[2]), f16vec2(Weights.w1[34u], Weights.w1[35u]), fma(f16vec2(_21[1]), f16vec2(Weights.w1[17u], Weights.w1[18u]), fma(f16vec2(_21[0]), f16vec2(Weights.w1[0u], Weights.w1[1u]), f16vec2(Biases.b1[0u], Biases.b1[1u])))), f16vec2(float16_t(0.0)));
    f16vec2 _169 = f16vec2(_166.x);
    f16vec2 _170 = f16vec2(_166.y);
    f16vec2 _254 = max(fma(f16vec2(_21[2]), f16vec2(Weights.w1[36u], Weights.w1[37u]), fma(f16vec2(_21[1]), f16vec2(Weights.w1[19u], Weights.w1[20u]), fma(f16vec2(_21[0]), f16vec2(Weights.w1[2u], Weights.w1[3u]), f16vec2(Biases.b1[2u], Biases.b1[3u])))), f16vec2(float16_t(0.0)));
    f16vec2 _257 = f16vec2(_254.x);
    f16vec2 _258 = f16vec2(_254.y);
    f16vec2 _344 = max(fma(f16vec2(_21[2]), f16vec2(Weights.w1[38u], Weights.w1[39u]), fma(f16vec2(_21[1]), f16vec2(Weights.w1[21u], Weights.w1[22u]), fma(f16vec2(_21[0]), f16vec2(Weights.w1[4u], Weights.w1[5u]), f16vec2(Biases.b1[4u], Biases.b1[5u])))), f16vec2(float16_t(0.0)));
    f16vec2 _347 = f16vec2(_344.x);
    f16vec2 _348 = f16vec2(_344.y);
    f16vec2 _430 = max(fma(f16vec2(_21[2]), f16vec2(Weights.w1[40u], Weights.w1[41u]), fma(f16vec2(_21[1]), f16vec2(Weights.w1[23u], Weights.w1[24u]), fma(f16vec2(_21[0]), f16vec2(Weights.w1[6u], Weights.w1[7u]), f16vec2(Biases.b1[6u], Biases.b1[7u])))), f16vec2(float16_t(0.0)));
    f16vec2 _433 = f16vec2(_430.x);
    f16vec2 _434 = f16vec2(_430.y);
    f16vec2 _521 = max(fma(f16vec2(_21[2]), f16vec2(Weights.w1[42u], Weights.w1[43u]), fma(f16vec2(_21[1]), f16vec2(Weights.w1[25u], Weights.w1[26u]), fma(f16vec2(_21[0]), f16vec2(Weights.w1[8u], Weights.w1[9u]), f16vec2(Biases.b1[8u], Biases.b1[9u])))), f16vec2(float16_t(0.0)));
    f16vec2 _524 = f16vec2(_521.x);
    f16vec2 _525 = f16vec2(_521.y);
    f16vec2 _541 = fma(_525, f16vec2(Weights.w2[63u], Weights.w2[64u]), fma(_524, f16vec2(Weights.w2[56u], Weights.w2[57u]), fma(_434, f16vec2(Weights.w2[49u], Weights.w2[50u]), fma(_433, f16vec2(Weights.w2[42u], Weights.w2[43u]), fma(_348, f16vec2(Weights.w2[35u], Weights.w2[36u]), fma(_347, f16vec2(Weights.w2[28u], Weights.w2[29u]), fma(_258, f16vec2(Weights.w2[21u], Weights.w2[22u]), fma(_257, f16vec2(Weights.w2[14u], Weights.w2[15u]), fma(_170, f16vec2(Weights.w2[7u], Weights.w2[8u]), fma(_169, f16vec2(Weights.w2[0u], Weights.w2[1u]), f16vec2(Biases.b2[0u], Biases.b2[1u])))))))))));
    f16vec2 _557 = fma(_525, f16vec2(Weights.w2[65u], Weights.w2[66u]), fma(_524, f16vec2(Weights.w2[58u], Weights.w2[59u]), fma(_434, f16vec2(Weights.w2[51u], Weights.w2[52u]), fma(_433, f16vec2(Weights.w2[44u], Weights.w2[45u]), fma(_348, f16vec2(Weights.w2[37u], Weights.w2[38u]), fma(_347, f16vec2(Weights.w2[30u], Weights.w2[31u]), fma(_258, f16vec2(Weights.w2[23u], Weights.w2[24u]), fma(_257, f16vec2(Weights.w2[16u], Weights.w2[17u]), fma(_170, f16vec2(Weights.w2[9u], Weights.w2[10u]), fma(_169, f16vec2(Weights.w2[2u], Weights.w2[3u]), f16vec2(Biases.b2[2u], Biases.b2[3u])))))))))));
    f16vec2 _573 = fma(_525, f16vec2(Weights.w2[67u], Weights.w2[68u]), fma(_524, f16vec2(Weights.w2[60u], Weights.w2[61u]), fma(_434, f16vec2(Weights.w2[53u], Weights.w2[54u]), fma(_433, f16vec2(Weights.w2[46u], Weights.w2[47u]), fma(_348, f16vec2(Weights.w2[39u], Weights.w2[40u]), fma(_347, f16vec2(Weights.w2[32u], Weights.w2[33u]), fma(_258, f16vec2(Weights.w2[25u], Weights.w2[26u]), fma(_257, f16vec2(Weights.w2[18u], Weights.w2[19u]), fma(_170, f16vec2(Weights.w2[11u], Weights.w2[12u]), fma(_169, f16vec2(Weights.w2[4u], Weights.w2[5u]), f16vec2(Biases.b2[4u], Biases.b2[5u])))))))))));
    f16vec2 _613 = max(fma(f16vec2(_21[2]), f16vec2(Weights.w1[44u], Weights.w1[45u]), fma(f16vec2(_21[1]), f16vec2(Weights.w1[27u], Weights.w1[28u]), fma(f16vec2(_21[0]), f16vec2(Weights.w1[10u], Weights.w1[11u]), f16vec2(Biases.b1[10u], Biases.b1[11u])))), f16vec2(float16_t(0.0)));
    f16vec2 _616 = f16vec2(_613.x);
    f16vec2 _617 = f16vec2(_613.y);
    f16vec2 _705 = max(fma(f16vec2(_21[2]), f16vec2(Weights.w1[46u], Weights.w1[47u]), fma(f16vec2(_21[1]), f16vec2(Weights.w1[29u], Weights.w1[30u]), fma(f16vec2(_21[0]), f16vec2(Weights.w1[12u], Weights.w1[13u]), f16vec2(Biases.b1[12u], Biases.b1[13u])))), f16vec2(float16_t(0.0)));
    f16vec2 _708 = f16vec2(_705.x);
    f16vec2 _709 = f16vec2(_705.y);
    f16vec2 _762 = fma(_708, f16vec2(Weights.w2[90u], float16_t(0.0)), fma(_617, f16vec2(Weights.w2[83u], float16_t(0.0)), fma(_616, f16vec2(Weights.w2[76u], float16_t(0.0)), fma(_525, f16vec2(Weights.w2[69u], float16_t(0.0)), fma(_524, f16vec2(Weights.w2[62u], float16_t(0.0)), fma(_434, f16vec2(Weights.w2[55u], float16_t(0.0)), fma(_433, f16vec2(Weights.w2[48u], float16_t(0.0)), fma(_348, f16vec2(Weights.w2[41u], float16_t(0.0)), fma(_347, f16vec2(Weights.w2[34u], float16_t(0.0)), fma(_258, f16vec2(Weights.w2[27u], float16_t(0.0)), fma(_257, f16vec2(Weights.w2[20u], float16_t(0.0)), fma(_170, f16vec2(Weights.w2[13u], float16_t(0.0)), fma(_169, f16vec2(Weights.w2[6u], float16_t(0.0)), f16vec2(Biases.b2[6u], float16_t(0.0)))))))))))))));
    f16vec2 _797 = max(fma(f16vec2(_21[2]), f16vec2(Weights.w1[48u], Weights.w1[49u]), fma(f16vec2(_21[1]), f16vec2(Weights.w1[31u], Weights.w1[32u]), fma(f16vec2(_21[0]), f16vec2(Weights.w1[14u], Weights.w1[15u]), f16vec2(Biases.b1[14u], Biases.b1[15u])))), f16vec2(float16_t(0.0)));
    f16vec2 _800 = f16vec2(_797.x);
    f16vec2 _801 = f16vec2(_797.y);
    f16vec2 _881 = max(fma(f16vec2(_21[2]), f16vec2(Weights.w1[50u], float16_t(0.0)), fma(f16vec2(_21[1]), f16vec2(Weights.w1[33u], float16_t(0.0)), fma(f16vec2(_21[0]), f16vec2(Weights.w1[16u], float16_t(0.0)), f16vec2(Biases.b1[16u], float16_t(0.0))))), f16vec2(float16_t(0.0)));
    f16vec2 _884 = f16vec2(_881.x);
    f16vec2 _893 = fma(_884, f16vec2(Weights.w2[112u], Weights.w2[113u]), fma(_801, f16vec2(Weights.w2[105u], Weights.w2[106u]), fma(_800, f16vec2(Weights.w2[98u], Weights.w2[99u]), fma(_709, f16vec2(Weights.w2[91u], Weights.w2[92u]), fma(_708, f16vec2(Weights.w2[84u], Weights.w2[85u]), fma(_617, f16vec2(Weights.w2[77u], Weights.w2[78u]), fma(_616, f16vec2(Weights.w2[70u], Weights.w2[71u]), _541)))))));
    f16vec2 _901 = fma(_884, f16vec2(Weights.w2[114u], Weights.w2[115u]), fma(_801, f16vec2(Weights.w2[107u], Weights.w2[108u]), fma(_800, f16vec2(Weights.w2[100u], Weights.w2[101u]), fma(_709, f16vec2(Weights.w2[93u], Weights.w2[94u]), fma(_708, f16vec2(Weights.w2[86u], Weights.w2[87u]), fma(_617, f16vec2(Weights.w2[79u], Weights.w2[80u]), fma(_616, f16vec2(Weights.w2[72u], Weights.w2[73u]), _557)))))));
    f16vec2 _909 = fma(_884, f16vec2(Weights.w2[116u], Weights.w2[117u]), fma(_801, f16vec2(Weights.w2[109u], Weights.w2[110u]), fma(_800, f16vec2(Weights.w2[102u], Weights.w2[103u]), fma(_709, f16vec2(Weights.w2[95u], Weights.w2[96u]), fma(_708, f16vec2(Weights.w2[88u], Weights.w2[89u]), fma(_617, f16vec2(Weights.w2[81u], Weights.w2[82u]), fma(_616, f16vec2(Weights.w2[74u], Weights.w2[75u]), _573)))))));
    float16_t _93[7] = float16_t[](_893.x, _893.y, _901.x, _901.y, _909.x, _909.y, fma(_884, f16vec2(Weights.w2[118u], float16_t(0.0)), fma(_801, f16vec2(Weights.w2[111u], float16_t(0.0)), fma(_800, f16vec2(Weights.w2[104u], float16_t(0.0)), fma(_709, f16vec2(Weights.w2[97u], float16_t(0.0)), _762)))).x);
    float16_t tempArg_1[7] = _93;
    float16_t y[7] = _93;
    float16_t _938[7] = _93;
    uint _937 = 0u;
    float16_t _936[7];
    uint _944;
    for (;;)
    {
        _944 = _937;
        if (_944 < 7u)
        {
            _936[_944] = max(_938[_944], _97[_944]);
            _937 = _944 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _936;
    uint _954 = 0u + 0u;
    OutY.y[_954] = _936[0];
    uint _957 = 0u + 1u;
    OutY.y[_957] = _936[1];
    uint _960 = 0u + 2u;
    OutY.y[_960] = _936[2];
    uint _963 = 0u + 3u;
    OutY.y[_963] = _936[3];
    uint _966 = 0u + 4u;
    OutY.y[_966] = _936[4];
    uint _969 = 0u + 5u;
    OutY.y[_969] = _936[5];
    uint _972 = 0u + 6u;
    OutY.y[_972] = _936[6];
}

