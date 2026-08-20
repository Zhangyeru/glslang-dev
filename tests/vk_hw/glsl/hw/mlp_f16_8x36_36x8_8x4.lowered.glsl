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

const f16vec2 _96[4] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const f16vec2 _125[2] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[36];
} InX;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[288];
    float16_t w2[288];
    float16_t w3[32];
} Weights;

layout(set = 0, binding = 2, std430) buffer PackedBias
{
    float16_t b1[36];
    float16_t b2[8];
    float16_t b3[4];
} Biases;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[4];
} OutY;

f16vec2 _3203(uint _3204)
{
    return f16vec2(InX.x[_3204], InX.x[_3204 + 1u]);
}

f16vec2[2] _2657(f16vec2 _2658[4])
{
    uint _2684 = 0u / 4u;
    uint _2685 = 0u % 4u;
    uint _2698 = 1u / 4u;
    uint _2699 = 1u % 4u;
    uint _2712 = 2u / 4u;
    uint _2713 = 2u % 4u;
    uint _2726 = 3u / 4u;
    uint _2727 = 3u % 4u;
    uint _2740 = 4u / 4u;
    uint _2741 = 4u % 4u;
    uint _2754 = 5u / 4u;
    uint _2755 = 5u % 4u;
    uint _2768 = 6u / 4u;
    uint _2769 = 6u % 4u;
    uint _2782 = 7u / 4u;
    uint _2783 = 7u % 4u;
    uint _2796 = 8u / 4u;
    uint _2797 = 8u % 4u;
    uint _2810 = 9u / 4u;
    uint _2811 = 9u % 4u;
    uint _2824 = 10u / 4u;
    uint _2825 = 10u % 4u;
    uint _2838 = 11u / 4u;
    uint _2839 = 11u % 4u;
    uint _2852 = 12u / 4u;
    uint _2853 = 12u % 4u;
    uint _2866 = 13u / 4u;
    uint _2867 = 13u % 4u;
    uint _2880 = 14u / 4u;
    uint _2881 = 14u % 4u;
    uint _2894 = 15u / 4u;
    uint _2895 = 15u % 4u;
    uint _2908 = 16u / 4u;
    uint _2909 = 16u % 4u;
    uint _2922 = 17u / 4u;
    uint _2923 = 17u % 4u;
    uint _2936 = 18u / 4u;
    uint _2937 = 18u % 4u;
    uint _2950 = 19u / 4u;
    uint _2951 = 19u % 4u;
    uint _2964 = 20u / 4u;
    uint _2965 = 20u % 4u;
    uint _2978 = 21u / 4u;
    uint _2979 = 21u % 4u;
    uint _2992 = 22u / 4u;
    uint _2993 = 22u % 4u;
    uint _3006 = 23u / 4u;
    uint _3007 = 23u % 4u;
    uint _3020 = 24u / 4u;
    uint _3021 = 24u % 4u;
    uint _3034 = 25u / 4u;
    uint _3035 = 25u % 4u;
    uint _3048 = 26u / 4u;
    uint _3049 = 26u % 4u;
    uint _3062 = 27u / 4u;
    uint _3063 = 27u % 4u;
    uint _3076 = 28u / 4u;
    uint _3077 = 28u % 4u;
    uint _3090 = 29u / 4u;
    uint _3091 = 29u % 4u;
    uint _3104 = 30u / 4u;
    uint _3105 = 30u % 4u;
    uint _3118 = 31u / 4u;
    uint _3119 = 31u % 4u;
    f16vec2 _3134 = fma(f16vec2(_2658[2].x, _2658[2].y), f16vec2(Weights.w3[((uint(0) + _2908) * uint(4)) + (uint(0) + _2909)], Weights.w3[((uint(0) + _2964) * uint(4)) + (uint(0) + _2965)]), fma(f16vec2(_2658[1].x, _2658[1].y), f16vec2(Weights.w3[((uint(0) + _2796) * uint(4)) + (uint(0) + _2797)], Weights.w3[((uint(0) + _2852) * uint(4)) + (uint(0) + _2853)]), fma(f16vec2(_2658[0].x, _2658[0].y), f16vec2(Weights.w3[((uint(0) + _2684) * uint(4)) + (uint(0) + _2685)], Weights.w3[((uint(0) + _2740) * uint(4)) + (uint(0) + _2741)]), f16vec2(float16_t(0.0)))));
    f16vec2 _3137 = fma(f16vec2(_2658[3].x, _2658[3].y), f16vec2(Weights.w3[((uint(0) + _3020) * uint(4)) + (uint(0) + _3021)], Weights.w3[((uint(0) + _3076) * uint(4)) + (uint(0) + _3077)]), _3134);
    f16vec2 _3152 = fma(f16vec2(_2658[2].x, _2658[2].y), f16vec2(Weights.w3[((uint(0) + _2922) * uint(4)) + (uint(0) + _2923)], Weights.w3[((uint(0) + _2978) * uint(4)) + (uint(0) + _2979)]), fma(f16vec2(_2658[1].x, _2658[1].y), f16vec2(Weights.w3[((uint(0) + _2810) * uint(4)) + (uint(0) + _2811)], Weights.w3[((uint(0) + _2866) * uint(4)) + (uint(0) + _2867)]), fma(f16vec2(_2658[0].x, _2658[0].y), f16vec2(Weights.w3[((uint(0) + _2698) * uint(4)) + (uint(0) + _2699)], Weights.w3[((uint(0) + _2754) * uint(4)) + (uint(0) + _2755)]), f16vec2(float16_t(0.0)))));
    f16vec2 _3155 = fma(f16vec2(_2658[3].x, _2658[3].y), f16vec2(Weights.w3[((uint(0) + _3034) * uint(4)) + (uint(0) + _3035)], Weights.w3[((uint(0) + _3090) * uint(4)) + (uint(0) + _3091)]), _3152);
    f16vec2 _3170 = fma(f16vec2(_2658[2].x, _2658[2].y), f16vec2(Weights.w3[((uint(0) + _2936) * uint(4)) + (uint(0) + _2937)], Weights.w3[((uint(0) + _2992) * uint(4)) + (uint(0) + _2993)]), fma(f16vec2(_2658[1].x, _2658[1].y), f16vec2(Weights.w3[((uint(0) + _2824) * uint(4)) + (uint(0) + _2825)], Weights.w3[((uint(0) + _2880) * uint(4)) + (uint(0) + _2881)]), fma(f16vec2(_2658[0].x, _2658[0].y), f16vec2(Weights.w3[((uint(0) + _2712) * uint(4)) + (uint(0) + _2713)], Weights.w3[((uint(0) + _2768) * uint(4)) + (uint(0) + _2769)]), f16vec2(float16_t(0.0)))));
    f16vec2 _3173 = fma(f16vec2(_2658[3].x, _2658[3].y), f16vec2(Weights.w3[((uint(0) + _3048) * uint(4)) + (uint(0) + _3049)], Weights.w3[((uint(0) + _3104) * uint(4)) + (uint(0) + _3105)]), _3170);
    f16vec2 _3188 = fma(f16vec2(_2658[2].x, _2658[2].y), f16vec2(Weights.w3[((uint(0) + _2950) * uint(4)) + (uint(0) + _2951)], Weights.w3[((uint(0) + _3006) * uint(4)) + (uint(0) + _3007)]), fma(f16vec2(_2658[1].x, _2658[1].y), f16vec2(Weights.w3[((uint(0) + _2838) * uint(4)) + (uint(0) + _2839)], Weights.w3[((uint(0) + _2894) * uint(4)) + (uint(0) + _2895)]), fma(f16vec2(_2658[0].x, _2658[0].y), f16vec2(Weights.w3[((uint(0) + _2726) * uint(4)) + (uint(0) + _2727)], Weights.w3[((uint(0) + _2782) * uint(4)) + (uint(0) + _2783)]), f16vec2(float16_t(0.0)))));
    f16vec2 _3191 = fma(f16vec2(_2658[3].x, _2658[3].y), f16vec2(Weights.w3[((uint(0) + _3062) * uint(4)) + (uint(0) + _3063)], Weights.w3[((uint(0) + _3118) * uint(4)) + (uint(0) + _3119)]), _3188);
    return f16vec2[](f16vec2((_3137.x + _3137.y) + Biases.b3[0u], (_3155.x + _3155.y) + Biases.b3[1u]), f16vec2((_3173.x + _3173.y) + Biases.b3[2u], (_3191.x + _3191.y) + Biases.b3[3u]));
}

void _3272(uint _3273, f16vec2 _3274)
{
    OutY.y[_3273] = _3274.x;
    OutY.y[_3273 + 1u] = _3274.y;
}

void main()
{
    uint _3218 = 0u;
    f16vec2 _3217[4];
    uint _3223;
    for (;;)
    {
        _3223 = _3218;
        if (_3223 < 8u)
        {
            _3217[_3223 / 2u] = _3203(0u + _3223);
            _3218 = _3223 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _22[4] = _3217;
    f16vec2 tempArg[4] = _22;
    f16vec2 x[4] = _22;
    f16vec2 _247 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[252u], Weights.w1[253u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[216u], Weights.w1[217u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[180u], Weights.w1[181u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[144u], Weights.w1[145u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[108u], Weights.w1[109u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[72u], Weights.w1[73u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[36u], Weights.w1[37u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[0u], Weights.w1[1u]), f16vec2(Biases.b1[0u], Biases.b1[1u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _250 = f16vec2(_247.x);
    f16vec2 _251 = f16vec2(_247.y);
    f16vec2 _390 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[254u], Weights.w1[255u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[218u], Weights.w1[219u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[182u], Weights.w1[183u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[146u], Weights.w1[147u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[110u], Weights.w1[111u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[74u], Weights.w1[75u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[38u], Weights.w1[39u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[2u], Weights.w1[3u]), f16vec2(Biases.b1[2u], Biases.b1[3u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _393 = f16vec2(_390.x);
    f16vec2 _394 = f16vec2(_390.y);
    f16vec2 _542 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[256u], Weights.w1[257u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[220u], Weights.w1[221u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[184u], Weights.w1[185u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[148u], Weights.w1[149u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[112u], Weights.w1[113u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[76u], Weights.w1[77u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[40u], Weights.w1[41u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[4u], Weights.w1[5u]), f16vec2(Biases.b1[4u], Biases.b1[5u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _545 = f16vec2(_542.x);
    f16vec2 _546 = f16vec2(_542.y);
    f16vec2 _685 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[258u], Weights.w1[259u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[222u], Weights.w1[223u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[186u], Weights.w1[187u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[150u], Weights.w1[151u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[114u], Weights.w1[115u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[78u], Weights.w1[79u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[42u], Weights.w1[43u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[6u], Weights.w1[7u]), f16vec2(Biases.b1[6u], Biases.b1[7u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _688 = f16vec2(_685.x);
    f16vec2 _689 = f16vec2(_685.y);
    f16vec2 _835 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[260u], Weights.w1[261u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[224u], Weights.w1[225u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[188u], Weights.w1[189u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[152u], Weights.w1[153u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[116u], Weights.w1[117u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[80u], Weights.w1[81u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[44u], Weights.w1[45u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[8u], Weights.w1[9u]), f16vec2(Biases.b1[8u], Biases.b1[9u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _838 = f16vec2(_835.x);
    f16vec2 _839 = f16vec2(_835.y);
    f16vec2 _853 = fma(_839, f16vec2(Weights.w2[72u], Weights.w2[73u]), fma(_838, f16vec2(Weights.w2[64u], Weights.w2[65u]), fma(_689, f16vec2(Weights.w2[56u], Weights.w2[57u]), fma(_688, f16vec2(Weights.w2[48u], Weights.w2[49u]), fma(_546, f16vec2(Weights.w2[40u], Weights.w2[41u]), fma(_545, f16vec2(Weights.w2[32u], Weights.w2[33u]), fma(_394, f16vec2(Weights.w2[24u], Weights.w2[25u]), fma(_393, f16vec2(Weights.w2[16u], Weights.w2[17u]), fma(_251, f16vec2(Weights.w2[8u], Weights.w2[9u]), fma(_250, f16vec2(Weights.w2[0u], Weights.w2[1u]), f16vec2(Biases.b2[0u], Biases.b2[1u])))))))))));
    f16vec2 _867 = fma(_839, f16vec2(Weights.w2[74u], Weights.w2[75u]), fma(_838, f16vec2(Weights.w2[66u], Weights.w2[67u]), fma(_689, f16vec2(Weights.w2[58u], Weights.w2[59u]), fma(_688, f16vec2(Weights.w2[50u], Weights.w2[51u]), fma(_546, f16vec2(Weights.w2[42u], Weights.w2[43u]), fma(_545, f16vec2(Weights.w2[34u], Weights.w2[35u]), fma(_394, f16vec2(Weights.w2[26u], Weights.w2[27u]), fma(_393, f16vec2(Weights.w2[18u], Weights.w2[19u]), fma(_251, f16vec2(Weights.w2[10u], Weights.w2[11u]), fma(_250, f16vec2(Weights.w2[2u], Weights.w2[3u]), f16vec2(Biases.b2[2u], Biases.b2[3u])))))))))));
    f16vec2 _881 = fma(_839, f16vec2(Weights.w2[76u], Weights.w2[77u]), fma(_838, f16vec2(Weights.w2[68u], Weights.w2[69u]), fma(_689, f16vec2(Weights.w2[60u], Weights.w2[61u]), fma(_688, f16vec2(Weights.w2[52u], Weights.w2[53u]), fma(_546, f16vec2(Weights.w2[44u], Weights.w2[45u]), fma(_545, f16vec2(Weights.w2[36u], Weights.w2[37u]), fma(_394, f16vec2(Weights.w2[28u], Weights.w2[29u]), fma(_393, f16vec2(Weights.w2[20u], Weights.w2[21u]), fma(_251, f16vec2(Weights.w2[12u], Weights.w2[13u]), fma(_250, f16vec2(Weights.w2[4u], Weights.w2[5u]), f16vec2(Biases.b2[4u], Biases.b2[5u])))))))))));
    f16vec2 _895 = fma(_839, f16vec2(Weights.w2[78u], Weights.w2[79u]), fma(_838, f16vec2(Weights.w2[70u], Weights.w2[71u]), fma(_689, f16vec2(Weights.w2[62u], Weights.w2[63u]), fma(_688, f16vec2(Weights.w2[54u], Weights.w2[55u]), fma(_546, f16vec2(Weights.w2[46u], Weights.w2[47u]), fma(_545, f16vec2(Weights.w2[38u], Weights.w2[39u]), fma(_394, f16vec2(Weights.w2[30u], Weights.w2[31u]), fma(_393, f16vec2(Weights.w2[22u], Weights.w2[23u]), fma(_251, f16vec2(Weights.w2[14u], Weights.w2[15u]), fma(_250, f16vec2(Weights.w2[6u], Weights.w2[7u]), f16vec2(Biases.b2[6u], Biases.b2[7u])))))))))));
    f16vec2 _977 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[262u], Weights.w1[263u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[226u], Weights.w1[227u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[190u], Weights.w1[191u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[154u], Weights.w1[155u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[118u], Weights.w1[119u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[82u], Weights.w1[83u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[46u], Weights.w1[47u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[10u], Weights.w1[11u]), f16vec2(Biases.b1[10u], Biases.b1[11u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _980 = f16vec2(_977.x);
    f16vec2 _981 = f16vec2(_977.y);
    f16vec2 _1121 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[264u], Weights.w1[265u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[228u], Weights.w1[229u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[192u], Weights.w1[193u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[156u], Weights.w1[157u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[120u], Weights.w1[121u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[84u], Weights.w1[85u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[48u], Weights.w1[49u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[12u], Weights.w1[13u]), f16vec2(Biases.b1[12u], Biases.b1[13u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1124 = f16vec2(_1121.x);
    f16vec2 _1125 = f16vec2(_1121.y);
    f16vec2 _1265 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[266u], Weights.w1[267u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[230u], Weights.w1[231u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[194u], Weights.w1[195u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[158u], Weights.w1[159u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[122u], Weights.w1[123u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[86u], Weights.w1[87u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[50u], Weights.w1[51u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[14u], Weights.w1[15u]), f16vec2(Biases.b1[14u], Biases.b1[15u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1268 = f16vec2(_1265.x);
    f16vec2 _1269 = f16vec2(_1265.y);
    f16vec2 _1399 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[268u], Weights.w1[269u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[232u], Weights.w1[233u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[196u], Weights.w1[197u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[160u], Weights.w1[161u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[124u], Weights.w1[125u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[88u], Weights.w1[89u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[52u], Weights.w1[53u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[16u], Weights.w1[17u]), f16vec2(Biases.b1[16u], Biases.b1[17u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1402 = f16vec2(_1399.x);
    f16vec2 _1403 = f16vec2(_1399.y);
    f16vec2 _1545 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[270u], Weights.w1[271u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[234u], Weights.w1[235u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[198u], Weights.w1[199u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[162u], Weights.w1[163u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[126u], Weights.w1[127u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[90u], Weights.w1[91u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[54u], Weights.w1[55u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[18u], Weights.w1[19u]), f16vec2(Biases.b1[18u], Biases.b1[19u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1548 = f16vec2(_1545.x);
    f16vec2 _1549 = f16vec2(_1545.y);
    f16vec2 _1561 = fma(_1549, f16vec2(Weights.w2[152u], Weights.w2[153u]), fma(_1548, f16vec2(Weights.w2[144u], Weights.w2[145u]), fma(_1403, f16vec2(Weights.w2[136u], Weights.w2[137u]), fma(_1402, f16vec2(Weights.w2[128u], Weights.w2[129u]), fma(_1269, f16vec2(Weights.w2[120u], Weights.w2[121u]), fma(_1268, f16vec2(Weights.w2[112u], Weights.w2[113u]), fma(_1125, f16vec2(Weights.w2[104u], Weights.w2[105u]), fma(_1124, f16vec2(Weights.w2[96u], Weights.w2[97u]), fma(_981, f16vec2(Weights.w2[88u], Weights.w2[89u]), fma(_980, f16vec2(Weights.w2[80u], Weights.w2[81u]), _853))))))))));
    f16vec2 _1573 = fma(_1549, f16vec2(Weights.w2[154u], Weights.w2[155u]), fma(_1548, f16vec2(Weights.w2[146u], Weights.w2[147u]), fma(_1403, f16vec2(Weights.w2[138u], Weights.w2[139u]), fma(_1402, f16vec2(Weights.w2[130u], Weights.w2[131u]), fma(_1269, f16vec2(Weights.w2[122u], Weights.w2[123u]), fma(_1268, f16vec2(Weights.w2[114u], Weights.w2[115u]), fma(_1125, f16vec2(Weights.w2[106u], Weights.w2[107u]), fma(_1124, f16vec2(Weights.w2[98u], Weights.w2[99u]), fma(_981, f16vec2(Weights.w2[90u], Weights.w2[91u]), fma(_980, f16vec2(Weights.w2[82u], Weights.w2[83u]), _867))))))))));
    f16vec2 _1585 = fma(_1549, f16vec2(Weights.w2[156u], Weights.w2[157u]), fma(_1548, f16vec2(Weights.w2[148u], Weights.w2[149u]), fma(_1403, f16vec2(Weights.w2[140u], Weights.w2[141u]), fma(_1402, f16vec2(Weights.w2[132u], Weights.w2[133u]), fma(_1269, f16vec2(Weights.w2[124u], Weights.w2[125u]), fma(_1268, f16vec2(Weights.w2[116u], Weights.w2[117u]), fma(_1125, f16vec2(Weights.w2[108u], Weights.w2[109u]), fma(_1124, f16vec2(Weights.w2[100u], Weights.w2[101u]), fma(_981, f16vec2(Weights.w2[92u], Weights.w2[93u]), fma(_980, f16vec2(Weights.w2[84u], Weights.w2[85u]), _881))))))))));
    f16vec2 _1597 = fma(_1549, f16vec2(Weights.w2[158u], Weights.w2[159u]), fma(_1548, f16vec2(Weights.w2[150u], Weights.w2[151u]), fma(_1403, f16vec2(Weights.w2[142u], Weights.w2[143u]), fma(_1402, f16vec2(Weights.w2[134u], Weights.w2[135u]), fma(_1269, f16vec2(Weights.w2[126u], Weights.w2[127u]), fma(_1268, f16vec2(Weights.w2[118u], Weights.w2[119u]), fma(_1125, f16vec2(Weights.w2[110u], Weights.w2[111u]), fma(_1124, f16vec2(Weights.w2[102u], Weights.w2[103u]), fma(_981, f16vec2(Weights.w2[94u], Weights.w2[95u]), fma(_980, f16vec2(Weights.w2[86u], Weights.w2[87u]), _895))))))))));
    f16vec2 _1675 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[272u], Weights.w1[273u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[236u], Weights.w1[237u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[200u], Weights.w1[201u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[164u], Weights.w1[165u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[128u], Weights.w1[129u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[92u], Weights.w1[93u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[56u], Weights.w1[57u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[20u], Weights.w1[21u]), f16vec2(Biases.b1[20u], Biases.b1[21u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1678 = f16vec2(_1675.x);
    f16vec2 _1679 = f16vec2(_1675.y);
    f16vec2 _1813 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[274u], Weights.w1[275u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[238u], Weights.w1[239u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[202u], Weights.w1[203u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[166u], Weights.w1[167u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[130u], Weights.w1[131u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[94u], Weights.w1[95u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[58u], Weights.w1[59u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[22u], Weights.w1[23u]), f16vec2(Biases.b1[22u], Biases.b1[23u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1816 = f16vec2(_1813.x);
    f16vec2 _1817 = f16vec2(_1813.y);
    f16vec2 _1945 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[276u], Weights.w1[277u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[240u], Weights.w1[241u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[204u], Weights.w1[205u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[168u], Weights.w1[169u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[132u], Weights.w1[133u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[96u], Weights.w1[97u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[60u], Weights.w1[61u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[24u], Weights.w1[25u]), f16vec2(Biases.b1[24u], Biases.b1[25u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1948 = f16vec2(_1945.x);
    f16vec2 _1949 = f16vec2(_1945.y);
    f16vec2 _2073 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[278u], Weights.w1[279u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[242u], Weights.w1[243u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[206u], Weights.w1[207u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[170u], Weights.w1[171u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[134u], Weights.w1[135u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[98u], Weights.w1[99u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[62u], Weights.w1[63u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[26u], Weights.w1[27u]), f16vec2(Biases.b1[26u], Biases.b1[27u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2076 = f16vec2(_2073.x);
    f16vec2 _2077 = f16vec2(_2073.y);
    f16vec2 _2207 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[280u], Weights.w1[281u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[244u], Weights.w1[245u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[208u], Weights.w1[209u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[172u], Weights.w1[173u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[136u], Weights.w1[137u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[100u], Weights.w1[101u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[64u], Weights.w1[65u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[28u], Weights.w1[29u]), f16vec2(Biases.b1[28u], Biases.b1[29u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2210 = f16vec2(_2207.x);
    f16vec2 _2211 = f16vec2(_2207.y);
    f16vec2 _2223 = fma(_2211, f16vec2(Weights.w2[232u], Weights.w2[233u]), fma(_2210, f16vec2(Weights.w2[224u], Weights.w2[225u]), fma(_2077, f16vec2(Weights.w2[216u], Weights.w2[217u]), fma(_2076, f16vec2(Weights.w2[208u], Weights.w2[209u]), fma(_1949, f16vec2(Weights.w2[200u], Weights.w2[201u]), fma(_1948, f16vec2(Weights.w2[192u], Weights.w2[193u]), fma(_1817, f16vec2(Weights.w2[184u], Weights.w2[185u]), fma(_1816, f16vec2(Weights.w2[176u], Weights.w2[177u]), fma(_1679, f16vec2(Weights.w2[168u], Weights.w2[169u]), fma(_1678, f16vec2(Weights.w2[160u], Weights.w2[161u]), _1561))))))))));
    f16vec2 _2235 = fma(_2211, f16vec2(Weights.w2[234u], Weights.w2[235u]), fma(_2210, f16vec2(Weights.w2[226u], Weights.w2[227u]), fma(_2077, f16vec2(Weights.w2[218u], Weights.w2[219u]), fma(_2076, f16vec2(Weights.w2[210u], Weights.w2[211u]), fma(_1949, f16vec2(Weights.w2[202u], Weights.w2[203u]), fma(_1948, f16vec2(Weights.w2[194u], Weights.w2[195u]), fma(_1817, f16vec2(Weights.w2[186u], Weights.w2[187u]), fma(_1816, f16vec2(Weights.w2[178u], Weights.w2[179u]), fma(_1679, f16vec2(Weights.w2[170u], Weights.w2[171u]), fma(_1678, f16vec2(Weights.w2[162u], Weights.w2[163u]), _1573))))))))));
    f16vec2 _2247 = fma(_2211, f16vec2(Weights.w2[236u], Weights.w2[237u]), fma(_2210, f16vec2(Weights.w2[228u], Weights.w2[229u]), fma(_2077, f16vec2(Weights.w2[220u], Weights.w2[221u]), fma(_2076, f16vec2(Weights.w2[212u], Weights.w2[213u]), fma(_1949, f16vec2(Weights.w2[204u], Weights.w2[205u]), fma(_1948, f16vec2(Weights.w2[196u], Weights.w2[197u]), fma(_1817, f16vec2(Weights.w2[188u], Weights.w2[189u]), fma(_1816, f16vec2(Weights.w2[180u], Weights.w2[181u]), fma(_1679, f16vec2(Weights.w2[172u], Weights.w2[173u]), fma(_1678, f16vec2(Weights.w2[164u], Weights.w2[165u]), _1585))))))))));
    f16vec2 _2259 = fma(_2211, f16vec2(Weights.w2[238u], Weights.w2[239u]), fma(_2210, f16vec2(Weights.w2[230u], Weights.w2[231u]), fma(_2077, f16vec2(Weights.w2[222u], Weights.w2[223u]), fma(_2076, f16vec2(Weights.w2[214u], Weights.w2[215u]), fma(_1949, f16vec2(Weights.w2[206u], Weights.w2[207u]), fma(_1948, f16vec2(Weights.w2[198u], Weights.w2[199u]), fma(_1817, f16vec2(Weights.w2[190u], Weights.w2[191u]), fma(_1816, f16vec2(Weights.w2[182u], Weights.w2[183u]), fma(_1679, f16vec2(Weights.w2[174u], Weights.w2[175u]), fma(_1678, f16vec2(Weights.w2[166u], Weights.w2[167u]), _1597))))))))));
    f16vec2 _2333 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[282u], Weights.w1[283u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[246u], Weights.w1[247u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[210u], Weights.w1[211u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[174u], Weights.w1[175u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[138u], Weights.w1[139u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[102u], Weights.w1[103u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[66u], Weights.w1[67u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[30u], Weights.w1[31u]), f16vec2(Biases.b1[30u], Biases.b1[31u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2336 = f16vec2(_2333.x);
    f16vec2 _2337 = f16vec2(_2333.y);
    f16vec2 _2461 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[284u], Weights.w1[285u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[248u], Weights.w1[249u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[212u], Weights.w1[213u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[176u], Weights.w1[177u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[140u], Weights.w1[141u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[104u], Weights.w1[105u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[68u], Weights.w1[69u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[32u], Weights.w1[33u]), f16vec2(Biases.b1[32u], Biases.b1[33u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2464 = f16vec2(_2461.x);
    f16vec2 _2465 = f16vec2(_2461.y);
    f16vec2 _2585 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[286u], Weights.w1[287u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[250u], Weights.w1[251u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[214u], Weights.w1[215u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[178u], Weights.w1[179u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[142u], Weights.w1[143u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[106u], Weights.w1[107u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[70u], Weights.w1[71u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[34u], Weights.w1[35u]), f16vec2(Biases.b1[34u], Biases.b1[35u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2588 = f16vec2(_2585.x);
    f16vec2 _2589 = f16vec2(_2585.y);
    f16vec2 _92[4] = f16vec2[](f16vec2(fma(_2589, f16vec2(Weights.w2[280u], Weights.w2[281u]), fma(_2588, f16vec2(Weights.w2[272u], Weights.w2[273u]), fma(_2465, f16vec2(Weights.w2[264u], Weights.w2[265u]), fma(_2464, f16vec2(Weights.w2[256u], Weights.w2[257u]), fma(_2337, f16vec2(Weights.w2[248u], Weights.w2[249u]), fma(_2336, f16vec2(Weights.w2[240u], Weights.w2[241u]), _2223))))))), f16vec2(fma(_2589, f16vec2(Weights.w2[282u], Weights.w2[283u]), fma(_2588, f16vec2(Weights.w2[274u], Weights.w2[275u]), fma(_2465, f16vec2(Weights.w2[266u], Weights.w2[267u]), fma(_2464, f16vec2(Weights.w2[258u], Weights.w2[259u]), fma(_2337, f16vec2(Weights.w2[250u], Weights.w2[251u]), fma(_2336, f16vec2(Weights.w2[242u], Weights.w2[243u]), _2235))))))), f16vec2(fma(_2589, f16vec2(Weights.w2[284u], Weights.w2[285u]), fma(_2588, f16vec2(Weights.w2[276u], Weights.w2[277u]), fma(_2465, f16vec2(Weights.w2[268u], Weights.w2[269u]), fma(_2464, f16vec2(Weights.w2[260u], Weights.w2[261u]), fma(_2337, f16vec2(Weights.w2[252u], Weights.w2[253u]), fma(_2336, f16vec2(Weights.w2[244u], Weights.w2[245u]), _2247))))))), f16vec2(fma(_2589, f16vec2(Weights.w2[286u], Weights.w2[287u]), fma(_2588, f16vec2(Weights.w2[278u], Weights.w2[279u]), fma(_2465, f16vec2(Weights.w2[270u], Weights.w2[271u]), fma(_2464, f16vec2(Weights.w2[262u], Weights.w2[263u]), fma(_2337, f16vec2(Weights.w2[254u], Weights.w2[255u]), fma(_2336, f16vec2(Weights.w2[246u], Weights.w2[247u]), _2259))))))));
    f16vec2 tempArg_1[4] = _92;
    f16vec2 h2[4] = _92;
    f16vec2 _3238[4] = _92;
    uint _3237 = 0u;
    f16vec2 _3236[4];
    uint _3244;
    for (;;)
    {
        _3244 = _3237;
        if (_3244 < 4u)
        {
            _3236[_3244] = max(_3238[_3244], _96[_3244]);
            _3237 = _3244 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    h2 = _3236;
    f16vec2 _121[2] = _2657(_3236);
    f16vec2 tempArg_2[2] = _121;
    f16vec2 y[2] = _121;
    f16vec2 _3256[2] = _121;
    uint _3255 = 0u;
    f16vec2 _3254[2];
    uint _3262;
    for (;;)
    {
        _3262 = _3255;
        if (_3262 < 2u)
        {
            _3254[_3262] = max(_3256[_3262], _125[_3262]);
            _3255 = _3262 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _3254;
    f16vec2 _3282[2] = _3254;
    uint _3283 = 0u;
    uint _3288;
    for (;;)
    {
        _3288 = _3283;
        if (_3288 < 4u)
        {
            _3272(0u + _3288, _3282[_3288 / 2u]);
            _3283 = _3288 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

