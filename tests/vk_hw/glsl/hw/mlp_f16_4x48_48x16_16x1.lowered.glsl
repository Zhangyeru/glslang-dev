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

const f16vec2 _100[8] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const float16_t _128[1] = float16_t[](float16_t(0.0));

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[48];
} InX;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[192];
    float16_t w2[768];
    float16_t w3[16];
} Weights;

layout(set = 0, binding = 2, std430) buffer PackedBias
{
    float16_t b1[48];
    float16_t b2[16];
    float16_t b3[1];
} Biases;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[1];
} OutY;

f16vec2 _4385(uint _4386)
{
    return f16vec2(InX.x[_4386], InX.x[_4386 + 1u]);
}

float16_t[1] _4283(f16vec2 _4284[8])
{
    f16vec2 _4372 = fma(f16vec2(_4284[6].x, _4284[6].y), f16vec2(Weights.w3[12u], Weights.w3[13u]), fma(f16vec2(_4284[5].x, _4284[5].y), f16vec2(Weights.w3[10u], Weights.w3[11u]), fma(f16vec2(_4284[4].x, _4284[4].y), f16vec2(Weights.w3[8u], Weights.w3[9u]), fma(f16vec2(_4284[3].x, _4284[3].y), f16vec2(Weights.w3[6u], Weights.w3[7u]), fma(f16vec2(_4284[2].x, _4284[2].y), f16vec2(Weights.w3[4u], Weights.w3[5u]), fma(f16vec2(_4284[1].x, _4284[1].y), f16vec2(Weights.w3[2u], Weights.w3[3u]), fma(f16vec2(_4284[0].x, _4284[0].y), f16vec2(Weights.w3[0u], Weights.w3[1u]), f16vec2(float16_t(0.0)))))))));
    f16vec2 _4375 = fma(f16vec2(_4284[7].x, _4284[7].y), f16vec2(Weights.w3[14u], Weights.w3[15u]), _4372);
    return float16_t[]((_4375.x + _4375.y) + Biases.b3[0u]);
}

void main()
{
    uint _4400 = 0u;
    f16vec2 _4399[2];
    uint _4405;
    for (;;)
    {
        _4405 = _4400;
        if (_4405 < 4u)
        {
            _4399[_4405 / 2u] = _4385(0u + _4405);
            _4400 = _4405 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _22[2] = _4399;
    f16vec2 tempArg[2] = _22;
    f16vec2 x[2] = _22;
    f16vec2 _237 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[144u], Weights.w1[145u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[96u], Weights.w1[97u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[48u], Weights.w1[49u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[0u], Weights.w1[1u]), f16vec2(Biases.b1[0u], Biases.b1[1u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _240 = f16vec2(_237.x);
    f16vec2 _241 = f16vec2(_237.y);
    f16vec2 _396 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[146u], Weights.w1[147u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[98u], Weights.w1[99u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[50u], Weights.w1[51u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[2u], Weights.w1[3u]), f16vec2(Biases.b1[2u], Biases.b1[3u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _399 = f16vec2(_396.x);
    f16vec2 _400 = f16vec2(_396.y);
    f16vec2 _566 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[148u], Weights.w1[149u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[100u], Weights.w1[101u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[52u], Weights.w1[53u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[4u], Weights.w1[5u]), f16vec2(Biases.b1[4u], Biases.b1[5u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _569 = f16vec2(_566.x);
    f16vec2 _570 = f16vec2(_566.y);
    f16vec2 _740 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[150u], Weights.w1[151u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[102u], Weights.w1[103u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[54u], Weights.w1[55u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[6u], Weights.w1[7u]), f16vec2(Biases.b1[6u], Biases.b1[7u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _743 = f16vec2(_740.x);
    f16vec2 _744 = f16vec2(_740.y);
    f16vec2 _904 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[152u], Weights.w1[153u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[104u], Weights.w1[105u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[56u], Weights.w1[57u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[8u], Weights.w1[9u]), f16vec2(Biases.b1[8u], Biases.b1[9u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _907 = f16vec2(_904.x);
    f16vec2 _908 = f16vec2(_904.y);
    f16vec2 _922 = fma(_908, f16vec2(Weights.w2[144u], Weights.w2[145u]), fma(_907, f16vec2(Weights.w2[128u], Weights.w2[129u]), fma(_744, f16vec2(Weights.w2[112u], Weights.w2[113u]), fma(_743, f16vec2(Weights.w2[96u], Weights.w2[97u]), fma(_570, f16vec2(Weights.w2[80u], Weights.w2[81u]), fma(_569, f16vec2(Weights.w2[64u], Weights.w2[65u]), fma(_400, f16vec2(Weights.w2[48u], Weights.w2[49u]), fma(_399, f16vec2(Weights.w2[32u], Weights.w2[33u]), fma(_241, f16vec2(Weights.w2[16u], Weights.w2[17u]), fma(_240, f16vec2(Weights.w2[0u], Weights.w2[1u]), f16vec2(Biases.b2[0u], Biases.b2[1u])))))))))));
    f16vec2 _936 = fma(_908, f16vec2(Weights.w2[146u], Weights.w2[147u]), fma(_907, f16vec2(Weights.w2[130u], Weights.w2[131u]), fma(_744, f16vec2(Weights.w2[114u], Weights.w2[115u]), fma(_743, f16vec2(Weights.w2[98u], Weights.w2[99u]), fma(_570, f16vec2(Weights.w2[82u], Weights.w2[83u]), fma(_569, f16vec2(Weights.w2[66u], Weights.w2[67u]), fma(_400, f16vec2(Weights.w2[50u], Weights.w2[51u]), fma(_399, f16vec2(Weights.w2[34u], Weights.w2[35u]), fma(_241, f16vec2(Weights.w2[18u], Weights.w2[19u]), fma(_240, f16vec2(Weights.w2[2u], Weights.w2[3u]), f16vec2(Biases.b2[2u], Biases.b2[3u])))))))))));
    f16vec2 _950 = fma(_908, f16vec2(Weights.w2[148u], Weights.w2[149u]), fma(_907, f16vec2(Weights.w2[132u], Weights.w2[133u]), fma(_744, f16vec2(Weights.w2[116u], Weights.w2[117u]), fma(_743, f16vec2(Weights.w2[100u], Weights.w2[101u]), fma(_570, f16vec2(Weights.w2[84u], Weights.w2[85u]), fma(_569, f16vec2(Weights.w2[68u], Weights.w2[69u]), fma(_400, f16vec2(Weights.w2[52u], Weights.w2[53u]), fma(_399, f16vec2(Weights.w2[36u], Weights.w2[37u]), fma(_241, f16vec2(Weights.w2[20u], Weights.w2[21u]), fma(_240, f16vec2(Weights.w2[4u], Weights.w2[5u]), f16vec2(Biases.b2[4u], Biases.b2[5u])))))))))));
    f16vec2 _964 = fma(_908, f16vec2(Weights.w2[150u], Weights.w2[151u]), fma(_907, f16vec2(Weights.w2[134u], Weights.w2[135u]), fma(_744, f16vec2(Weights.w2[118u], Weights.w2[119u]), fma(_743, f16vec2(Weights.w2[102u], Weights.w2[103u]), fma(_570, f16vec2(Weights.w2[86u], Weights.w2[87u]), fma(_569, f16vec2(Weights.w2[70u], Weights.w2[71u]), fma(_400, f16vec2(Weights.w2[54u], Weights.w2[55u]), fma(_399, f16vec2(Weights.w2[38u], Weights.w2[39u]), fma(_241, f16vec2(Weights.w2[22u], Weights.w2[23u]), fma(_240, f16vec2(Weights.w2[6u], Weights.w2[7u]), f16vec2(Biases.b2[6u], Biases.b2[7u])))))))))));
    f16vec2 _978 = fma(_908, f16vec2(Weights.w2[152u], Weights.w2[153u]), fma(_907, f16vec2(Weights.w2[136u], Weights.w2[137u]), fma(_744, f16vec2(Weights.w2[120u], Weights.w2[121u]), fma(_743, f16vec2(Weights.w2[104u], Weights.w2[105u]), fma(_570, f16vec2(Weights.w2[88u], Weights.w2[89u]), fma(_569, f16vec2(Weights.w2[72u], Weights.w2[73u]), fma(_400, f16vec2(Weights.w2[56u], Weights.w2[57u]), fma(_399, f16vec2(Weights.w2[40u], Weights.w2[41u]), fma(_241, f16vec2(Weights.w2[24u], Weights.w2[25u]), fma(_240, f16vec2(Weights.w2[8u], Weights.w2[9u]), f16vec2(Biases.b2[8u], Biases.b2[9u])))))))))));
    f16vec2 _994 = fma(_908, f16vec2(Weights.w2[154u], Weights.w2[155u]), fma(_907, f16vec2(Weights.w2[138u], Weights.w2[139u]), fma(_744, f16vec2(Weights.w2[122u], Weights.w2[123u]), fma(_743, f16vec2(Weights.w2[106u], Weights.w2[107u]), fma(_570, f16vec2(Weights.w2[90u], Weights.w2[91u]), fma(_569, f16vec2(Weights.w2[74u], Weights.w2[75u]), fma(_400, f16vec2(Weights.w2[58u], Weights.w2[59u]), fma(_399, f16vec2(Weights.w2[42u], Weights.w2[43u]), fma(_241, f16vec2(Weights.w2[26u], Weights.w2[27u]), fma(_240, f16vec2(Weights.w2[10u], Weights.w2[11u]), f16vec2(Biases.b2[10u], Biases.b2[11u])))))))))));
    f16vec2 _1010 = fma(_908, f16vec2(Weights.w2[156u], Weights.w2[157u]), fma(_907, f16vec2(Weights.w2[140u], Weights.w2[141u]), fma(_744, f16vec2(Weights.w2[124u], Weights.w2[125u]), fma(_743, f16vec2(Weights.w2[108u], Weights.w2[109u]), fma(_570, f16vec2(Weights.w2[92u], Weights.w2[93u]), fma(_569, f16vec2(Weights.w2[76u], Weights.w2[77u]), fma(_400, f16vec2(Weights.w2[60u], Weights.w2[61u]), fma(_399, f16vec2(Weights.w2[44u], Weights.w2[45u]), fma(_241, f16vec2(Weights.w2[28u], Weights.w2[29u]), fma(_240, f16vec2(Weights.w2[12u], Weights.w2[13u]), f16vec2(Biases.b2[12u], Biases.b2[13u])))))))))));
    f16vec2 _1026 = fma(_908, f16vec2(Weights.w2[158u], Weights.w2[159u]), fma(_907, f16vec2(Weights.w2[142u], Weights.w2[143u]), fma(_744, f16vec2(Weights.w2[126u], Weights.w2[127u]), fma(_743, f16vec2(Weights.w2[110u], Weights.w2[111u]), fma(_570, f16vec2(Weights.w2[94u], Weights.w2[95u]), fma(_569, f16vec2(Weights.w2[78u], Weights.w2[79u]), fma(_400, f16vec2(Weights.w2[62u], Weights.w2[63u]), fma(_399, f16vec2(Weights.w2[46u], Weights.w2[47u]), fma(_241, f16vec2(Weights.w2[30u], Weights.w2[31u]), fma(_240, f16vec2(Weights.w2[14u], Weights.w2[15u]), f16vec2(Biases.b2[14u], Biases.b2[15u])))))))))));
    f16vec2 _1064 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[154u], Weights.w1[155u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[106u], Weights.w1[107u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[58u], Weights.w1[59u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[10u], Weights.w1[11u]), f16vec2(Biases.b1[10u], Biases.b1[11u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _1067 = f16vec2(_1064.x);
    f16vec2 _1068 = f16vec2(_1064.y);
    f16vec2 _1234 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[156u], Weights.w1[157u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[108u], Weights.w1[109u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[60u], Weights.w1[61u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[12u], Weights.w1[13u]), f16vec2(Biases.b1[12u], Biases.b1[13u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _1237 = f16vec2(_1234.x);
    f16vec2 _1238 = f16vec2(_1234.y);
    f16vec2 _1403 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[158u], Weights.w1[159u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[110u], Weights.w1[111u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[62u], Weights.w1[63u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[14u], Weights.w1[15u]), f16vec2(Biases.b1[14u], Biases.b1[15u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _1406 = f16vec2(_1403.x);
    f16vec2 _1407 = f16vec2(_1403.y);
    f16vec2 _1573 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[160u], Weights.w1[161u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[112u], Weights.w1[113u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[64u], Weights.w1[65u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[16u], Weights.w1[17u]), f16vec2(Biases.b1[16u], Biases.b1[17u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _1576 = f16vec2(_1573.x);
    f16vec2 _1577 = f16vec2(_1573.y);
    f16vec2 _1743 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[162u], Weights.w1[163u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[114u], Weights.w1[115u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[66u], Weights.w1[67u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[18u], Weights.w1[19u]), f16vec2(Biases.b1[18u], Biases.b1[19u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _1746 = f16vec2(_1743.x);
    f16vec2 _1747 = f16vec2(_1743.y);
    f16vec2 _1763 = fma(_1747, f16vec2(Weights.w2[304u], Weights.w2[305u]), fma(_1746, f16vec2(Weights.w2[288u], Weights.w2[289u]), fma(_1577, f16vec2(Weights.w2[272u], Weights.w2[273u]), fma(_1576, f16vec2(Weights.w2[256u], Weights.w2[257u]), fma(_1407, f16vec2(Weights.w2[240u], Weights.w2[241u]), fma(_1406, f16vec2(Weights.w2[224u], Weights.w2[225u]), fma(_1238, f16vec2(Weights.w2[208u], Weights.w2[209u]), fma(_1237, f16vec2(Weights.w2[192u], Weights.w2[193u]), fma(_1068, f16vec2(Weights.w2[176u], Weights.w2[177u]), fma(_1067, f16vec2(Weights.w2[160u], Weights.w2[161u]), _922))))))))));
    f16vec2 _1779 = fma(_1747, f16vec2(Weights.w2[306u], Weights.w2[307u]), fma(_1746, f16vec2(Weights.w2[290u], Weights.w2[291u]), fma(_1577, f16vec2(Weights.w2[274u], Weights.w2[275u]), fma(_1576, f16vec2(Weights.w2[258u], Weights.w2[259u]), fma(_1407, f16vec2(Weights.w2[242u], Weights.w2[243u]), fma(_1406, f16vec2(Weights.w2[226u], Weights.w2[227u]), fma(_1238, f16vec2(Weights.w2[210u], Weights.w2[211u]), fma(_1237, f16vec2(Weights.w2[194u], Weights.w2[195u]), fma(_1068, f16vec2(Weights.w2[178u], Weights.w2[179u]), fma(_1067, f16vec2(Weights.w2[162u], Weights.w2[163u]), _936))))))))));
    f16vec2 _1795 = fma(_1747, f16vec2(Weights.w2[308u], Weights.w2[309u]), fma(_1746, f16vec2(Weights.w2[292u], Weights.w2[293u]), fma(_1577, f16vec2(Weights.w2[276u], Weights.w2[277u]), fma(_1576, f16vec2(Weights.w2[260u], Weights.w2[261u]), fma(_1407, f16vec2(Weights.w2[244u], Weights.w2[245u]), fma(_1406, f16vec2(Weights.w2[228u], Weights.w2[229u]), fma(_1238, f16vec2(Weights.w2[212u], Weights.w2[213u]), fma(_1237, f16vec2(Weights.w2[196u], Weights.w2[197u]), fma(_1068, f16vec2(Weights.w2[180u], Weights.w2[181u]), fma(_1067, f16vec2(Weights.w2[164u], Weights.w2[165u]), _950))))))))));
    f16vec2 _1811 = fma(_1747, f16vec2(Weights.w2[310u], Weights.w2[311u]), fma(_1746, f16vec2(Weights.w2[294u], Weights.w2[295u]), fma(_1577, f16vec2(Weights.w2[278u], Weights.w2[279u]), fma(_1576, f16vec2(Weights.w2[262u], Weights.w2[263u]), fma(_1407, f16vec2(Weights.w2[246u], Weights.w2[247u]), fma(_1406, f16vec2(Weights.w2[230u], Weights.w2[231u]), fma(_1238, f16vec2(Weights.w2[214u], Weights.w2[215u]), fma(_1237, f16vec2(Weights.w2[198u], Weights.w2[199u]), fma(_1068, f16vec2(Weights.w2[182u], Weights.w2[183u]), fma(_1067, f16vec2(Weights.w2[166u], Weights.w2[167u]), _964))))))))));
    f16vec2 _1827 = fma(_1747, f16vec2(Weights.w2[312u], Weights.w2[313u]), fma(_1746, f16vec2(Weights.w2[296u], Weights.w2[297u]), fma(_1577, f16vec2(Weights.w2[280u], Weights.w2[281u]), fma(_1576, f16vec2(Weights.w2[264u], Weights.w2[265u]), fma(_1407, f16vec2(Weights.w2[248u], Weights.w2[249u]), fma(_1406, f16vec2(Weights.w2[232u], Weights.w2[233u]), fma(_1238, f16vec2(Weights.w2[216u], Weights.w2[217u]), fma(_1237, f16vec2(Weights.w2[200u], Weights.w2[201u]), fma(_1068, f16vec2(Weights.w2[184u], Weights.w2[185u]), fma(_1067, f16vec2(Weights.w2[168u], Weights.w2[169u]), _978))))))))));
    f16vec2 _1843 = fma(_1747, f16vec2(Weights.w2[314u], Weights.w2[315u]), fma(_1746, f16vec2(Weights.w2[298u], Weights.w2[299u]), fma(_1577, f16vec2(Weights.w2[282u], Weights.w2[283u]), fma(_1576, f16vec2(Weights.w2[266u], Weights.w2[267u]), fma(_1407, f16vec2(Weights.w2[250u], Weights.w2[251u]), fma(_1406, f16vec2(Weights.w2[234u], Weights.w2[235u]), fma(_1238, f16vec2(Weights.w2[218u], Weights.w2[219u]), fma(_1237, f16vec2(Weights.w2[202u], Weights.w2[203u]), fma(_1068, f16vec2(Weights.w2[186u], Weights.w2[187u]), fma(_1067, f16vec2(Weights.w2[170u], Weights.w2[171u]), _994))))))))));
    f16vec2 _1859 = fma(_1747, f16vec2(Weights.w2[316u], Weights.w2[317u]), fma(_1746, f16vec2(Weights.w2[300u], Weights.w2[301u]), fma(_1577, f16vec2(Weights.w2[284u], Weights.w2[285u]), fma(_1576, f16vec2(Weights.w2[268u], Weights.w2[269u]), fma(_1407, f16vec2(Weights.w2[252u], Weights.w2[253u]), fma(_1406, f16vec2(Weights.w2[236u], Weights.w2[237u]), fma(_1238, f16vec2(Weights.w2[220u], Weights.w2[221u]), fma(_1237, f16vec2(Weights.w2[204u], Weights.w2[205u]), fma(_1068, f16vec2(Weights.w2[188u], Weights.w2[189u]), fma(_1067, f16vec2(Weights.w2[172u], Weights.w2[173u]), _1010))))))))));
    f16vec2 _1875 = fma(_1747, f16vec2(Weights.w2[318u], Weights.w2[319u]), fma(_1746, f16vec2(Weights.w2[302u], Weights.w2[303u]), fma(_1577, f16vec2(Weights.w2[286u], Weights.w2[287u]), fma(_1576, f16vec2(Weights.w2[270u], Weights.w2[271u]), fma(_1407, f16vec2(Weights.w2[254u], Weights.w2[255u]), fma(_1406, f16vec2(Weights.w2[238u], Weights.w2[239u]), fma(_1238, f16vec2(Weights.w2[222u], Weights.w2[223u]), fma(_1237, f16vec2(Weights.w2[206u], Weights.w2[207u]), fma(_1068, f16vec2(Weights.w2[190u], Weights.w2[191u]), fma(_1067, f16vec2(Weights.w2[174u], Weights.w2[175u]), _1026))))))))));
    f16vec2 _1913 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[164u], Weights.w1[165u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[116u], Weights.w1[117u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[68u], Weights.w1[69u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[20u], Weights.w1[21u]), f16vec2(Biases.b1[20u], Biases.b1[21u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _1916 = f16vec2(_1913.x);
    f16vec2 _1917 = f16vec2(_1913.y);
    f16vec2 _2083 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[166u], Weights.w1[167u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[118u], Weights.w1[119u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[70u], Weights.w1[71u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[22u], Weights.w1[23u]), f16vec2(Biases.b1[22u], Biases.b1[23u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _2086 = f16vec2(_2083.x);
    f16vec2 _2087 = f16vec2(_2083.y);
    f16vec2 _2253 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[168u], Weights.w1[169u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[120u], Weights.w1[121u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[72u], Weights.w1[73u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[24u], Weights.w1[25u]), f16vec2(Biases.b1[24u], Biases.b1[25u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _2256 = f16vec2(_2253.x);
    f16vec2 _2257 = f16vec2(_2253.y);
    f16vec2 _2423 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[170u], Weights.w1[171u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[122u], Weights.w1[123u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[74u], Weights.w1[75u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[26u], Weights.w1[27u]), f16vec2(Biases.b1[26u], Biases.b1[27u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _2426 = f16vec2(_2423.x);
    f16vec2 _2427 = f16vec2(_2423.y);
    f16vec2 _2593 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[172u], Weights.w1[173u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[124u], Weights.w1[125u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[76u], Weights.w1[77u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[28u], Weights.w1[29u]), f16vec2(Biases.b1[28u], Biases.b1[29u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _2596 = f16vec2(_2593.x);
    f16vec2 _2597 = f16vec2(_2593.y);
    f16vec2 _2613 = fma(_2597, f16vec2(Weights.w2[464u], Weights.w2[465u]), fma(_2596, f16vec2(Weights.w2[448u], Weights.w2[449u]), fma(_2427, f16vec2(Weights.w2[432u], Weights.w2[433u]), fma(_2426, f16vec2(Weights.w2[416u], Weights.w2[417u]), fma(_2257, f16vec2(Weights.w2[400u], Weights.w2[401u]), fma(_2256, f16vec2(Weights.w2[384u], Weights.w2[385u]), fma(_2087, f16vec2(Weights.w2[368u], Weights.w2[369u]), fma(_2086, f16vec2(Weights.w2[352u], Weights.w2[353u]), fma(_1917, f16vec2(Weights.w2[336u], Weights.w2[337u]), fma(_1916, f16vec2(Weights.w2[320u], Weights.w2[321u]), _1763))))))))));
    f16vec2 _2629 = fma(_2597, f16vec2(Weights.w2[466u], Weights.w2[467u]), fma(_2596, f16vec2(Weights.w2[450u], Weights.w2[451u]), fma(_2427, f16vec2(Weights.w2[434u], Weights.w2[435u]), fma(_2426, f16vec2(Weights.w2[418u], Weights.w2[419u]), fma(_2257, f16vec2(Weights.w2[402u], Weights.w2[403u]), fma(_2256, f16vec2(Weights.w2[386u], Weights.w2[387u]), fma(_2087, f16vec2(Weights.w2[370u], Weights.w2[371u]), fma(_2086, f16vec2(Weights.w2[354u], Weights.w2[355u]), fma(_1917, f16vec2(Weights.w2[338u], Weights.w2[339u]), fma(_1916, f16vec2(Weights.w2[322u], Weights.w2[323u]), _1779))))))))));
    f16vec2 _2645 = fma(_2597, f16vec2(Weights.w2[468u], Weights.w2[469u]), fma(_2596, f16vec2(Weights.w2[452u], Weights.w2[453u]), fma(_2427, f16vec2(Weights.w2[436u], Weights.w2[437u]), fma(_2426, f16vec2(Weights.w2[420u], Weights.w2[421u]), fma(_2257, f16vec2(Weights.w2[404u], Weights.w2[405u]), fma(_2256, f16vec2(Weights.w2[388u], Weights.w2[389u]), fma(_2087, f16vec2(Weights.w2[372u], Weights.w2[373u]), fma(_2086, f16vec2(Weights.w2[356u], Weights.w2[357u]), fma(_1917, f16vec2(Weights.w2[340u], Weights.w2[341u]), fma(_1916, f16vec2(Weights.w2[324u], Weights.w2[325u]), _1795))))))))));
    f16vec2 _2661 = fma(_2597, f16vec2(Weights.w2[470u], Weights.w2[471u]), fma(_2596, f16vec2(Weights.w2[454u], Weights.w2[455u]), fma(_2427, f16vec2(Weights.w2[438u], Weights.w2[439u]), fma(_2426, f16vec2(Weights.w2[422u], Weights.w2[423u]), fma(_2257, f16vec2(Weights.w2[406u], Weights.w2[407u]), fma(_2256, f16vec2(Weights.w2[390u], Weights.w2[391u]), fma(_2087, f16vec2(Weights.w2[374u], Weights.w2[375u]), fma(_2086, f16vec2(Weights.w2[358u], Weights.w2[359u]), fma(_1917, f16vec2(Weights.w2[342u], Weights.w2[343u]), fma(_1916, f16vec2(Weights.w2[326u], Weights.w2[327u]), _1811))))))))));
    f16vec2 _2677 = fma(_2597, f16vec2(Weights.w2[472u], Weights.w2[473u]), fma(_2596, f16vec2(Weights.w2[456u], Weights.w2[457u]), fma(_2427, f16vec2(Weights.w2[440u], Weights.w2[441u]), fma(_2426, f16vec2(Weights.w2[424u], Weights.w2[425u]), fma(_2257, f16vec2(Weights.w2[408u], Weights.w2[409u]), fma(_2256, f16vec2(Weights.w2[392u], Weights.w2[393u]), fma(_2087, f16vec2(Weights.w2[376u], Weights.w2[377u]), fma(_2086, f16vec2(Weights.w2[360u], Weights.w2[361u]), fma(_1917, f16vec2(Weights.w2[344u], Weights.w2[345u]), fma(_1916, f16vec2(Weights.w2[328u], Weights.w2[329u]), _1827))))))))));
    f16vec2 _2693 = fma(_2597, f16vec2(Weights.w2[474u], Weights.w2[475u]), fma(_2596, f16vec2(Weights.w2[458u], Weights.w2[459u]), fma(_2427, f16vec2(Weights.w2[442u], Weights.w2[443u]), fma(_2426, f16vec2(Weights.w2[426u], Weights.w2[427u]), fma(_2257, f16vec2(Weights.w2[410u], Weights.w2[411u]), fma(_2256, f16vec2(Weights.w2[394u], Weights.w2[395u]), fma(_2087, f16vec2(Weights.w2[378u], Weights.w2[379u]), fma(_2086, f16vec2(Weights.w2[362u], Weights.w2[363u]), fma(_1917, f16vec2(Weights.w2[346u], Weights.w2[347u]), fma(_1916, f16vec2(Weights.w2[330u], Weights.w2[331u]), _1843))))))))));
    f16vec2 _2709 = fma(_2597, f16vec2(Weights.w2[476u], Weights.w2[477u]), fma(_2596, f16vec2(Weights.w2[460u], Weights.w2[461u]), fma(_2427, f16vec2(Weights.w2[444u], Weights.w2[445u]), fma(_2426, f16vec2(Weights.w2[428u], Weights.w2[429u]), fma(_2257, f16vec2(Weights.w2[412u], Weights.w2[413u]), fma(_2256, f16vec2(Weights.w2[396u], Weights.w2[397u]), fma(_2087, f16vec2(Weights.w2[380u], Weights.w2[381u]), fma(_2086, f16vec2(Weights.w2[364u], Weights.w2[365u]), fma(_1917, f16vec2(Weights.w2[348u], Weights.w2[349u]), fma(_1916, f16vec2(Weights.w2[332u], Weights.w2[333u]), _1859))))))))));
    f16vec2 _2725 = fma(_2597, f16vec2(Weights.w2[478u], Weights.w2[479u]), fma(_2596, f16vec2(Weights.w2[462u], Weights.w2[463u]), fma(_2427, f16vec2(Weights.w2[446u], Weights.w2[447u]), fma(_2426, f16vec2(Weights.w2[430u], Weights.w2[431u]), fma(_2257, f16vec2(Weights.w2[414u], Weights.w2[415u]), fma(_2256, f16vec2(Weights.w2[398u], Weights.w2[399u]), fma(_2087, f16vec2(Weights.w2[382u], Weights.w2[383u]), fma(_2086, f16vec2(Weights.w2[366u], Weights.w2[367u]), fma(_1917, f16vec2(Weights.w2[350u], Weights.w2[351u]), fma(_1916, f16vec2(Weights.w2[334u], Weights.w2[335u]), _1875))))))))));
    f16vec2 _2763 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[174u], Weights.w1[175u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[126u], Weights.w1[127u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[78u], Weights.w1[79u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[30u], Weights.w1[31u]), f16vec2(Biases.b1[30u], Biases.b1[31u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _2766 = f16vec2(_2763.x);
    f16vec2 _2767 = f16vec2(_2763.y);
    f16vec2 _2933 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[176u], Weights.w1[177u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[128u], Weights.w1[129u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[80u], Weights.w1[81u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[32u], Weights.w1[33u]), f16vec2(Biases.b1[32u], Biases.b1[33u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _2936 = f16vec2(_2933.x);
    f16vec2 _2937 = f16vec2(_2933.y);
    f16vec2 _3103 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[178u], Weights.w1[179u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[130u], Weights.w1[131u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[82u], Weights.w1[83u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[34u], Weights.w1[35u]), f16vec2(Biases.b1[34u], Biases.b1[35u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _3106 = f16vec2(_3103.x);
    f16vec2 _3107 = f16vec2(_3103.y);
    f16vec2 _3273 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[180u], Weights.w1[181u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[132u], Weights.w1[133u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[84u], Weights.w1[85u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[36u], Weights.w1[37u]), f16vec2(Biases.b1[36u], Biases.b1[37u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _3276 = f16vec2(_3273.x);
    f16vec2 _3277 = f16vec2(_3273.y);
    f16vec2 _3443 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[182u], Weights.w1[183u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[134u], Weights.w1[135u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[86u], Weights.w1[87u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[38u], Weights.w1[39u]), f16vec2(Biases.b1[38u], Biases.b1[39u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _3446 = f16vec2(_3443.x);
    f16vec2 _3447 = f16vec2(_3443.y);
    f16vec2 _3463 = fma(_3447, f16vec2(Weights.w2[624u], Weights.w2[625u]), fma(_3446, f16vec2(Weights.w2[608u], Weights.w2[609u]), fma(_3277, f16vec2(Weights.w2[592u], Weights.w2[593u]), fma(_3276, f16vec2(Weights.w2[576u], Weights.w2[577u]), fma(_3107, f16vec2(Weights.w2[560u], Weights.w2[561u]), fma(_3106, f16vec2(Weights.w2[544u], Weights.w2[545u]), fma(_2937, f16vec2(Weights.w2[528u], Weights.w2[529u]), fma(_2936, f16vec2(Weights.w2[512u], Weights.w2[513u]), fma(_2767, f16vec2(Weights.w2[496u], Weights.w2[497u]), fma(_2766, f16vec2(Weights.w2[480u], Weights.w2[481u]), _2613))))))))));
    f16vec2 _3479 = fma(_3447, f16vec2(Weights.w2[626u], Weights.w2[627u]), fma(_3446, f16vec2(Weights.w2[610u], Weights.w2[611u]), fma(_3277, f16vec2(Weights.w2[594u], Weights.w2[595u]), fma(_3276, f16vec2(Weights.w2[578u], Weights.w2[579u]), fma(_3107, f16vec2(Weights.w2[562u], Weights.w2[563u]), fma(_3106, f16vec2(Weights.w2[546u], Weights.w2[547u]), fma(_2937, f16vec2(Weights.w2[530u], Weights.w2[531u]), fma(_2936, f16vec2(Weights.w2[514u], Weights.w2[515u]), fma(_2767, f16vec2(Weights.w2[498u], Weights.w2[499u]), fma(_2766, f16vec2(Weights.w2[482u], Weights.w2[483u]), _2629))))))))));
    f16vec2 _3495 = fma(_3447, f16vec2(Weights.w2[628u], Weights.w2[629u]), fma(_3446, f16vec2(Weights.w2[612u], Weights.w2[613u]), fma(_3277, f16vec2(Weights.w2[596u], Weights.w2[597u]), fma(_3276, f16vec2(Weights.w2[580u], Weights.w2[581u]), fma(_3107, f16vec2(Weights.w2[564u], Weights.w2[565u]), fma(_3106, f16vec2(Weights.w2[548u], Weights.w2[549u]), fma(_2937, f16vec2(Weights.w2[532u], Weights.w2[533u]), fma(_2936, f16vec2(Weights.w2[516u], Weights.w2[517u]), fma(_2767, f16vec2(Weights.w2[500u], Weights.w2[501u]), fma(_2766, f16vec2(Weights.w2[484u], Weights.w2[485u]), _2645))))))))));
    f16vec2 _3511 = fma(_3447, f16vec2(Weights.w2[630u], Weights.w2[631u]), fma(_3446, f16vec2(Weights.w2[614u], Weights.w2[615u]), fma(_3277, f16vec2(Weights.w2[598u], Weights.w2[599u]), fma(_3276, f16vec2(Weights.w2[582u], Weights.w2[583u]), fma(_3107, f16vec2(Weights.w2[566u], Weights.w2[567u]), fma(_3106, f16vec2(Weights.w2[550u], Weights.w2[551u]), fma(_2937, f16vec2(Weights.w2[534u], Weights.w2[535u]), fma(_2936, f16vec2(Weights.w2[518u], Weights.w2[519u]), fma(_2767, f16vec2(Weights.w2[502u], Weights.w2[503u]), fma(_2766, f16vec2(Weights.w2[486u], Weights.w2[487u]), _2661))))))))));
    f16vec2 _3527 = fma(_3447, f16vec2(Weights.w2[632u], Weights.w2[633u]), fma(_3446, f16vec2(Weights.w2[616u], Weights.w2[617u]), fma(_3277, f16vec2(Weights.w2[600u], Weights.w2[601u]), fma(_3276, f16vec2(Weights.w2[584u], Weights.w2[585u]), fma(_3107, f16vec2(Weights.w2[568u], Weights.w2[569u]), fma(_3106, f16vec2(Weights.w2[552u], Weights.w2[553u]), fma(_2937, f16vec2(Weights.w2[536u], Weights.w2[537u]), fma(_2936, f16vec2(Weights.w2[520u], Weights.w2[521u]), fma(_2767, f16vec2(Weights.w2[504u], Weights.w2[505u]), fma(_2766, f16vec2(Weights.w2[488u], Weights.w2[489u]), _2677))))))))));
    f16vec2 _3543 = fma(_3447, f16vec2(Weights.w2[634u], Weights.w2[635u]), fma(_3446, f16vec2(Weights.w2[618u], Weights.w2[619u]), fma(_3277, f16vec2(Weights.w2[602u], Weights.w2[603u]), fma(_3276, f16vec2(Weights.w2[586u], Weights.w2[587u]), fma(_3107, f16vec2(Weights.w2[570u], Weights.w2[571u]), fma(_3106, f16vec2(Weights.w2[554u], Weights.w2[555u]), fma(_2937, f16vec2(Weights.w2[538u], Weights.w2[539u]), fma(_2936, f16vec2(Weights.w2[522u], Weights.w2[523u]), fma(_2767, f16vec2(Weights.w2[506u], Weights.w2[507u]), fma(_2766, f16vec2(Weights.w2[490u], Weights.w2[491u]), _2693))))))))));
    f16vec2 _3559 = fma(_3447, f16vec2(Weights.w2[636u], Weights.w2[637u]), fma(_3446, f16vec2(Weights.w2[620u], Weights.w2[621u]), fma(_3277, f16vec2(Weights.w2[604u], Weights.w2[605u]), fma(_3276, f16vec2(Weights.w2[588u], Weights.w2[589u]), fma(_3107, f16vec2(Weights.w2[572u], Weights.w2[573u]), fma(_3106, f16vec2(Weights.w2[556u], Weights.w2[557u]), fma(_2937, f16vec2(Weights.w2[540u], Weights.w2[541u]), fma(_2936, f16vec2(Weights.w2[524u], Weights.w2[525u]), fma(_2767, f16vec2(Weights.w2[508u], Weights.w2[509u]), fma(_2766, f16vec2(Weights.w2[492u], Weights.w2[493u]), _2709))))))))));
    f16vec2 _3575 = fma(_3447, f16vec2(Weights.w2[638u], Weights.w2[639u]), fma(_3446, f16vec2(Weights.w2[622u], Weights.w2[623u]), fma(_3277, f16vec2(Weights.w2[606u], Weights.w2[607u]), fma(_3276, f16vec2(Weights.w2[590u], Weights.w2[591u]), fma(_3107, f16vec2(Weights.w2[574u], Weights.w2[575u]), fma(_3106, f16vec2(Weights.w2[558u], Weights.w2[559u]), fma(_2937, f16vec2(Weights.w2[542u], Weights.w2[543u]), fma(_2936, f16vec2(Weights.w2[526u], Weights.w2[527u]), fma(_2767, f16vec2(Weights.w2[510u], Weights.w2[511u]), fma(_2766, f16vec2(Weights.w2[494u], Weights.w2[495u]), _2725))))))))));
    f16vec2 _3613 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[184u], Weights.w1[185u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[136u], Weights.w1[137u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[88u], Weights.w1[89u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[40u], Weights.w1[41u]), f16vec2(Biases.b1[40u], Biases.b1[41u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _3616 = f16vec2(_3613.x);
    f16vec2 _3617 = f16vec2(_3613.y);
    f16vec2 _3783 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[186u], Weights.w1[187u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[138u], Weights.w1[139u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[90u], Weights.w1[91u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[42u], Weights.w1[43u]), f16vec2(Biases.b1[42u], Biases.b1[43u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _3786 = f16vec2(_3783.x);
    f16vec2 _3787 = f16vec2(_3783.y);
    f16vec2 _3953 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[188u], Weights.w1[189u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[140u], Weights.w1[141u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[92u], Weights.w1[93u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[44u], Weights.w1[45u]), f16vec2(Biases.b1[44u], Biases.b1[45u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _3956 = f16vec2(_3953.x);
    f16vec2 _3957 = f16vec2(_3953.y);
    f16vec2 _4123 = max(fma(f16vec2(_22[1].y), f16vec2(Weights.w1[190u], Weights.w1[191u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[142u], Weights.w1[143u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[94u], Weights.w1[95u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[46u], Weights.w1[47u]), f16vec2(Biases.b1[46u], Biases.b1[47u]))))), f16vec2(float16_t(0.0)));
    f16vec2 _4126 = f16vec2(_4123.x);
    f16vec2 _4127 = f16vec2(_4123.y);
    f16vec2 _96[8] = f16vec2[](f16vec2(fma(_4127, f16vec2(Weights.w2[752u], Weights.w2[753u]), fma(_4126, f16vec2(Weights.w2[736u], Weights.w2[737u]), fma(_3957, f16vec2(Weights.w2[720u], Weights.w2[721u]), fma(_3956, f16vec2(Weights.w2[704u], Weights.w2[705u]), fma(_3787, f16vec2(Weights.w2[688u], Weights.w2[689u]), fma(_3786, f16vec2(Weights.w2[672u], Weights.w2[673u]), fma(_3617, f16vec2(Weights.w2[656u], Weights.w2[657u]), fma(_3616, f16vec2(Weights.w2[640u], Weights.w2[641u]), _3463))))))))), f16vec2(fma(_4127, f16vec2(Weights.w2[754u], Weights.w2[755u]), fma(_4126, f16vec2(Weights.w2[738u], Weights.w2[739u]), fma(_3957, f16vec2(Weights.w2[722u], Weights.w2[723u]), fma(_3956, f16vec2(Weights.w2[706u], Weights.w2[707u]), fma(_3787, f16vec2(Weights.w2[690u], Weights.w2[691u]), fma(_3786, f16vec2(Weights.w2[674u], Weights.w2[675u]), fma(_3617, f16vec2(Weights.w2[658u], Weights.w2[659u]), fma(_3616, f16vec2(Weights.w2[642u], Weights.w2[643u]), _3479))))))))), f16vec2(fma(_4127, f16vec2(Weights.w2[756u], Weights.w2[757u]), fma(_4126, f16vec2(Weights.w2[740u], Weights.w2[741u]), fma(_3957, f16vec2(Weights.w2[724u], Weights.w2[725u]), fma(_3956, f16vec2(Weights.w2[708u], Weights.w2[709u]), fma(_3787, f16vec2(Weights.w2[692u], Weights.w2[693u]), fma(_3786, f16vec2(Weights.w2[676u], Weights.w2[677u]), fma(_3617, f16vec2(Weights.w2[660u], Weights.w2[661u]), fma(_3616, f16vec2(Weights.w2[644u], Weights.w2[645u]), _3495))))))))), f16vec2(fma(_4127, f16vec2(Weights.w2[758u], Weights.w2[759u]), fma(_4126, f16vec2(Weights.w2[742u], Weights.w2[743u]), fma(_3957, f16vec2(Weights.w2[726u], Weights.w2[727u]), fma(_3956, f16vec2(Weights.w2[710u], Weights.w2[711u]), fma(_3787, f16vec2(Weights.w2[694u], Weights.w2[695u]), fma(_3786, f16vec2(Weights.w2[678u], Weights.w2[679u]), fma(_3617, f16vec2(Weights.w2[662u], Weights.w2[663u]), fma(_3616, f16vec2(Weights.w2[646u], Weights.w2[647u]), _3511))))))))), f16vec2(fma(_4127, f16vec2(Weights.w2[760u], Weights.w2[761u]), fma(_4126, f16vec2(Weights.w2[744u], Weights.w2[745u]), fma(_3957, f16vec2(Weights.w2[728u], Weights.w2[729u]), fma(_3956, f16vec2(Weights.w2[712u], Weights.w2[713u]), fma(_3787, f16vec2(Weights.w2[696u], Weights.w2[697u]), fma(_3786, f16vec2(Weights.w2[680u], Weights.w2[681u]), fma(_3617, f16vec2(Weights.w2[664u], Weights.w2[665u]), fma(_3616, f16vec2(Weights.w2[648u], Weights.w2[649u]), _3527))))))))), f16vec2(fma(_4127, f16vec2(Weights.w2[762u], Weights.w2[763u]), fma(_4126, f16vec2(Weights.w2[746u], Weights.w2[747u]), fma(_3957, f16vec2(Weights.w2[730u], Weights.w2[731u]), fma(_3956, f16vec2(Weights.w2[714u], Weights.w2[715u]), fma(_3787, f16vec2(Weights.w2[698u], Weights.w2[699u]), fma(_3786, f16vec2(Weights.w2[682u], Weights.w2[683u]), fma(_3617, f16vec2(Weights.w2[666u], Weights.w2[667u]), fma(_3616, f16vec2(Weights.w2[650u], Weights.w2[651u]), _3543))))))))), f16vec2(fma(_4127, f16vec2(Weights.w2[764u], Weights.w2[765u]), fma(_4126, f16vec2(Weights.w2[748u], Weights.w2[749u]), fma(_3957, f16vec2(Weights.w2[732u], Weights.w2[733u]), fma(_3956, f16vec2(Weights.w2[716u], Weights.w2[717u]), fma(_3787, f16vec2(Weights.w2[700u], Weights.w2[701u]), fma(_3786, f16vec2(Weights.w2[684u], Weights.w2[685u]), fma(_3617, f16vec2(Weights.w2[668u], Weights.w2[669u]), fma(_3616, f16vec2(Weights.w2[652u], Weights.w2[653u]), _3559))))))))), f16vec2(fma(_4127, f16vec2(Weights.w2[766u], Weights.w2[767u]), fma(_4126, f16vec2(Weights.w2[750u], Weights.w2[751u]), fma(_3957, f16vec2(Weights.w2[734u], Weights.w2[735u]), fma(_3956, f16vec2(Weights.w2[718u], Weights.w2[719u]), fma(_3787, f16vec2(Weights.w2[702u], Weights.w2[703u]), fma(_3786, f16vec2(Weights.w2[686u], Weights.w2[687u]), fma(_3617, f16vec2(Weights.w2[670u], Weights.w2[671u]), fma(_3616, f16vec2(Weights.w2[654u], Weights.w2[655u]), _3575))))))))));
    f16vec2 tempArg_1[8] = _96;
    f16vec2 h2[8] = _96;
    f16vec2 _4425[8] = _96;
    uint _4424 = 0u;
    f16vec2 _4423[8];
    uint _4431;
    for (;;)
    {
        _4431 = _4424;
        if (_4431 < 8u)
        {
            _4423[_4431] = max(_4425[_4431], _100[_4431]);
            _4424 = _4431 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    h2 = _4423;
    float16_t _124[1] = _4283(_4423);
    float16_t tempArg_2[1] = _124;
    float16_t y[1] = _124;
    float16_t _4443[1] = _124;
    uint _4442 = 0u;
    float16_t _4441[1];
    uint _4449;
    for (;;)
    {
        _4449 = _4442;
        if (_4449 < 1u)
        {
            _4441[_4449] = max(_4443[_4449], _128[_4449]);
            _4442 = _4449 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _4441;
    uint _4459 = 0u + 0u;
    OutY.y[_4459] = _4441[0];
}

