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

struct InputFeatures
{
    f16vec2 value[6];
};

struct ProjectedFeatures
{
    f16vec2 value[18];
};

struct CompactFeatures
{
    f16vec2 value[6];
};

struct VisibilityFrame
{
    CompactFeatures features;
    uvec2 provenance;
};

struct VisibilityHistory
{
    VisibilityFrame frames[2];
    uint preferredFrame;
};

struct VisibilityResult
{
    f16vec2 value[3];
};

const f16vec2 _148[18] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const f16vec2 _181[6] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const f16vec2 _291[3] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));

layout(set = 0, binding = 0, std430) buffer VisibilityInput
{
    float16_t features[36];
} InX;

layout(set = 0, binding = 1, std430) buffer VisibilityWeights
{
    float16_t projection[432];
    float16_t compression[432];
    float16_t classifier[72];
} Weights;

layout(set = 0, binding = 2, std430) buffer VisibilityBiases
{
    float16_t projection[36];
    float16_t compression[12];
    float16_t classifier[6];
} Biases;

layout(set = 0, binding = 3, std430) buffer VisibilityOutput
{
    float16_t visibility[6];
} OutY;

uint buildVisibilityRoute()
{
    uint workItem = gl_GlobalInvocationID.x;
    uint localLane = gl_LocalInvocationIndex;
    return (workItem ^ localLane) & 1u;
}

f16vec2 _3915(uint _3916)
{
    return f16vec2(InX.features[_3916], InX.features[_3916 + 1u]);
}

InputFeatures loadVisibilityInput()
{
    uint _3928 = 0u;
    f16vec2 _3927[6];
    uint _3933;
    for (;;)
    {
        _3933 = _3928;
        if (_3933 < 12u)
        {
            _3927[_3933 / 2u] = _3915(0u + _3933);
            _3928 = _3933 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _95[6] = _3927;
    f16vec2 tempArg[6] = _95;
    InputFeatures inputFeatures;
    inputFeatures.value = _95;
    return inputFeatures;
}

f16vec2[18] _346(f16vec2 _347[6])
{
    f16vec2 _1753 = f16vec2(_347[0].x);
    f16vec2 _1790 = f16vec2(_347[0].y);
    f16vec2 _1827 = f16vec2(_347[1].x);
    f16vec2 _1864 = f16vec2(_347[1].y);
    f16vec2 _1901 = f16vec2(_347[2].x);
    f16vec2 _1938 = f16vec2(_347[2].y);
    f16vec2 _1975 = f16vec2(_347[3].x);
    f16vec2 _2012 = f16vec2(_347[3].y);
    f16vec2 _2049 = f16vec2(_347[4].x);
    f16vec2 _2086 = f16vec2(_347[4].y);
    f16vec2 _2088 = fma(_2086, f16vec2(Weights.projection[324u], Weights.projection[325u]), fma(_2049, f16vec2(Weights.projection[288u], Weights.projection[289u]), fma(_2012, f16vec2(Weights.projection[252u], Weights.projection[253u]), fma(_1975, f16vec2(Weights.projection[216u], Weights.projection[217u]), fma(_1938, f16vec2(Weights.projection[180u], Weights.projection[181u]), fma(_1901, f16vec2(Weights.projection[144u], Weights.projection[145u]), fma(_1864, f16vec2(Weights.projection[108u], Weights.projection[109u]), fma(_1827, f16vec2(Weights.projection[72u], Weights.projection[73u]), fma(_1790, f16vec2(Weights.projection[36u], Weights.projection[37u]), fma(_1753, f16vec2(Weights.projection[0u], Weights.projection[1u]), f16vec2(Biases.projection[0u], Biases.projection[1u])))))))))));
    f16vec2 _2090 = fma(_2086, f16vec2(Weights.projection[326u], Weights.projection[327u]), fma(_2049, f16vec2(Weights.projection[290u], Weights.projection[291u]), fma(_2012, f16vec2(Weights.projection[254u], Weights.projection[255u]), fma(_1975, f16vec2(Weights.projection[218u], Weights.projection[219u]), fma(_1938, f16vec2(Weights.projection[182u], Weights.projection[183u]), fma(_1901, f16vec2(Weights.projection[146u], Weights.projection[147u]), fma(_1864, f16vec2(Weights.projection[110u], Weights.projection[111u]), fma(_1827, f16vec2(Weights.projection[74u], Weights.projection[75u]), fma(_1790, f16vec2(Weights.projection[38u], Weights.projection[39u]), fma(_1753, f16vec2(Weights.projection[2u], Weights.projection[3u]), f16vec2(Biases.projection[2u], Biases.projection[3u])))))))))));
    f16vec2 _2092 = fma(_2086, f16vec2(Weights.projection[328u], Weights.projection[329u]), fma(_2049, f16vec2(Weights.projection[292u], Weights.projection[293u]), fma(_2012, f16vec2(Weights.projection[256u], Weights.projection[257u]), fma(_1975, f16vec2(Weights.projection[220u], Weights.projection[221u]), fma(_1938, f16vec2(Weights.projection[184u], Weights.projection[185u]), fma(_1901, f16vec2(Weights.projection[148u], Weights.projection[149u]), fma(_1864, f16vec2(Weights.projection[112u], Weights.projection[113u]), fma(_1827, f16vec2(Weights.projection[76u], Weights.projection[77u]), fma(_1790, f16vec2(Weights.projection[40u], Weights.projection[41u]), fma(_1753, f16vec2(Weights.projection[4u], Weights.projection[5u]), f16vec2(Biases.projection[4u], Biases.projection[5u])))))))))));
    f16vec2 _2094 = fma(_2086, f16vec2(Weights.projection[330u], Weights.projection[331u]), fma(_2049, f16vec2(Weights.projection[294u], Weights.projection[295u]), fma(_2012, f16vec2(Weights.projection[258u], Weights.projection[259u]), fma(_1975, f16vec2(Weights.projection[222u], Weights.projection[223u]), fma(_1938, f16vec2(Weights.projection[186u], Weights.projection[187u]), fma(_1901, f16vec2(Weights.projection[150u], Weights.projection[151u]), fma(_1864, f16vec2(Weights.projection[114u], Weights.projection[115u]), fma(_1827, f16vec2(Weights.projection[78u], Weights.projection[79u]), fma(_1790, f16vec2(Weights.projection[42u], Weights.projection[43u]), fma(_1753, f16vec2(Weights.projection[6u], Weights.projection[7u]), f16vec2(Biases.projection[6u], Biases.projection[7u])))))))))));
    f16vec2 _2096 = fma(_2086, f16vec2(Weights.projection[332u], Weights.projection[333u]), fma(_2049, f16vec2(Weights.projection[296u], Weights.projection[297u]), fma(_2012, f16vec2(Weights.projection[260u], Weights.projection[261u]), fma(_1975, f16vec2(Weights.projection[224u], Weights.projection[225u]), fma(_1938, f16vec2(Weights.projection[188u], Weights.projection[189u]), fma(_1901, f16vec2(Weights.projection[152u], Weights.projection[153u]), fma(_1864, f16vec2(Weights.projection[116u], Weights.projection[117u]), fma(_1827, f16vec2(Weights.projection[80u], Weights.projection[81u]), fma(_1790, f16vec2(Weights.projection[44u], Weights.projection[45u]), fma(_1753, f16vec2(Weights.projection[8u], Weights.projection[9u]), f16vec2(Biases.projection[8u], Biases.projection[9u])))))))))));
    f16vec2 _2098 = fma(_2086, f16vec2(Weights.projection[334u], Weights.projection[335u]), fma(_2049, f16vec2(Weights.projection[298u], Weights.projection[299u]), fma(_2012, f16vec2(Weights.projection[262u], Weights.projection[263u]), fma(_1975, f16vec2(Weights.projection[226u], Weights.projection[227u]), fma(_1938, f16vec2(Weights.projection[190u], Weights.projection[191u]), fma(_1901, f16vec2(Weights.projection[154u], Weights.projection[155u]), fma(_1864, f16vec2(Weights.projection[118u], Weights.projection[119u]), fma(_1827, f16vec2(Weights.projection[82u], Weights.projection[83u]), fma(_1790, f16vec2(Weights.projection[46u], Weights.projection[47u]), fma(_1753, f16vec2(Weights.projection[10u], Weights.projection[11u]), f16vec2(Biases.projection[10u], Biases.projection[11u])))))))))));
    f16vec2 _2100 = fma(_2086, f16vec2(Weights.projection[336u], Weights.projection[337u]), fma(_2049, f16vec2(Weights.projection[300u], Weights.projection[301u]), fma(_2012, f16vec2(Weights.projection[264u], Weights.projection[265u]), fma(_1975, f16vec2(Weights.projection[228u], Weights.projection[229u]), fma(_1938, f16vec2(Weights.projection[192u], Weights.projection[193u]), fma(_1901, f16vec2(Weights.projection[156u], Weights.projection[157u]), fma(_1864, f16vec2(Weights.projection[120u], Weights.projection[121u]), fma(_1827, f16vec2(Weights.projection[84u], Weights.projection[85u]), fma(_1790, f16vec2(Weights.projection[48u], Weights.projection[49u]), fma(_1753, f16vec2(Weights.projection[12u], Weights.projection[13u]), f16vec2(Biases.projection[12u], Biases.projection[13u])))))))))));
    f16vec2 _2102 = fma(_2086, f16vec2(Weights.projection[338u], Weights.projection[339u]), fma(_2049, f16vec2(Weights.projection[302u], Weights.projection[303u]), fma(_2012, f16vec2(Weights.projection[266u], Weights.projection[267u]), fma(_1975, f16vec2(Weights.projection[230u], Weights.projection[231u]), fma(_1938, f16vec2(Weights.projection[194u], Weights.projection[195u]), fma(_1901, f16vec2(Weights.projection[158u], Weights.projection[159u]), fma(_1864, f16vec2(Weights.projection[122u], Weights.projection[123u]), fma(_1827, f16vec2(Weights.projection[86u], Weights.projection[87u]), fma(_1790, f16vec2(Weights.projection[50u], Weights.projection[51u]), fma(_1753, f16vec2(Weights.projection[14u], Weights.projection[15u]), f16vec2(Biases.projection[14u], Biases.projection[15u])))))))))));
    f16vec2 _2104 = fma(_2086, f16vec2(Weights.projection[340u], Weights.projection[341u]), fma(_2049, f16vec2(Weights.projection[304u], Weights.projection[305u]), fma(_2012, f16vec2(Weights.projection[268u], Weights.projection[269u]), fma(_1975, f16vec2(Weights.projection[232u], Weights.projection[233u]), fma(_1938, f16vec2(Weights.projection[196u], Weights.projection[197u]), fma(_1901, f16vec2(Weights.projection[160u], Weights.projection[161u]), fma(_1864, f16vec2(Weights.projection[124u], Weights.projection[125u]), fma(_1827, f16vec2(Weights.projection[88u], Weights.projection[89u]), fma(_1790, f16vec2(Weights.projection[52u], Weights.projection[53u]), fma(_1753, f16vec2(Weights.projection[16u], Weights.projection[17u]), f16vec2(Biases.projection[16u], Biases.projection[17u])))))))))));
    f16vec2 _2106 = fma(_2086, f16vec2(Weights.projection[342u], Weights.projection[343u]), fma(_2049, f16vec2(Weights.projection[306u], Weights.projection[307u]), fma(_2012, f16vec2(Weights.projection[270u], Weights.projection[271u]), fma(_1975, f16vec2(Weights.projection[234u], Weights.projection[235u]), fma(_1938, f16vec2(Weights.projection[198u], Weights.projection[199u]), fma(_1901, f16vec2(Weights.projection[162u], Weights.projection[163u]), fma(_1864, f16vec2(Weights.projection[126u], Weights.projection[127u]), fma(_1827, f16vec2(Weights.projection[90u], Weights.projection[91u]), fma(_1790, f16vec2(Weights.projection[54u], Weights.projection[55u]), fma(_1753, f16vec2(Weights.projection[18u], Weights.projection[19u]), f16vec2(Biases.projection[18u], Biases.projection[19u])))))))))));
    f16vec2 _2108 = fma(_2086, f16vec2(Weights.projection[344u], Weights.projection[345u]), fma(_2049, f16vec2(Weights.projection[308u], Weights.projection[309u]), fma(_2012, f16vec2(Weights.projection[272u], Weights.projection[273u]), fma(_1975, f16vec2(Weights.projection[236u], Weights.projection[237u]), fma(_1938, f16vec2(Weights.projection[200u], Weights.projection[201u]), fma(_1901, f16vec2(Weights.projection[164u], Weights.projection[165u]), fma(_1864, f16vec2(Weights.projection[128u], Weights.projection[129u]), fma(_1827, f16vec2(Weights.projection[92u], Weights.projection[93u]), fma(_1790, f16vec2(Weights.projection[56u], Weights.projection[57u]), fma(_1753, f16vec2(Weights.projection[20u], Weights.projection[21u]), f16vec2(Biases.projection[20u], Biases.projection[21u])))))))))));
    f16vec2 _2110 = fma(_2086, f16vec2(Weights.projection[346u], Weights.projection[347u]), fma(_2049, f16vec2(Weights.projection[310u], Weights.projection[311u]), fma(_2012, f16vec2(Weights.projection[274u], Weights.projection[275u]), fma(_1975, f16vec2(Weights.projection[238u], Weights.projection[239u]), fma(_1938, f16vec2(Weights.projection[202u], Weights.projection[203u]), fma(_1901, f16vec2(Weights.projection[166u], Weights.projection[167u]), fma(_1864, f16vec2(Weights.projection[130u], Weights.projection[131u]), fma(_1827, f16vec2(Weights.projection[94u], Weights.projection[95u]), fma(_1790, f16vec2(Weights.projection[58u], Weights.projection[59u]), fma(_1753, f16vec2(Weights.projection[22u], Weights.projection[23u]), f16vec2(Biases.projection[22u], Biases.projection[23u])))))))))));
    f16vec2 _2112 = fma(_2086, f16vec2(Weights.projection[348u], Weights.projection[349u]), fma(_2049, f16vec2(Weights.projection[312u], Weights.projection[313u]), fma(_2012, f16vec2(Weights.projection[276u], Weights.projection[277u]), fma(_1975, f16vec2(Weights.projection[240u], Weights.projection[241u]), fma(_1938, f16vec2(Weights.projection[204u], Weights.projection[205u]), fma(_1901, f16vec2(Weights.projection[168u], Weights.projection[169u]), fma(_1864, f16vec2(Weights.projection[132u], Weights.projection[133u]), fma(_1827, f16vec2(Weights.projection[96u], Weights.projection[97u]), fma(_1790, f16vec2(Weights.projection[60u], Weights.projection[61u]), fma(_1753, f16vec2(Weights.projection[24u], Weights.projection[25u]), f16vec2(Biases.projection[24u], Biases.projection[25u])))))))))));
    f16vec2 _2114 = fma(_2086, f16vec2(Weights.projection[350u], Weights.projection[351u]), fma(_2049, f16vec2(Weights.projection[314u], Weights.projection[315u]), fma(_2012, f16vec2(Weights.projection[278u], Weights.projection[279u]), fma(_1975, f16vec2(Weights.projection[242u], Weights.projection[243u]), fma(_1938, f16vec2(Weights.projection[206u], Weights.projection[207u]), fma(_1901, f16vec2(Weights.projection[170u], Weights.projection[171u]), fma(_1864, f16vec2(Weights.projection[134u], Weights.projection[135u]), fma(_1827, f16vec2(Weights.projection[98u], Weights.projection[99u]), fma(_1790, f16vec2(Weights.projection[62u], Weights.projection[63u]), fma(_1753, f16vec2(Weights.projection[26u], Weights.projection[27u]), f16vec2(Biases.projection[26u], Biases.projection[27u])))))))))));
    f16vec2 _2116 = fma(_2086, f16vec2(Weights.projection[352u], Weights.projection[353u]), fma(_2049, f16vec2(Weights.projection[316u], Weights.projection[317u]), fma(_2012, f16vec2(Weights.projection[280u], Weights.projection[281u]), fma(_1975, f16vec2(Weights.projection[244u], Weights.projection[245u]), fma(_1938, f16vec2(Weights.projection[208u], Weights.projection[209u]), fma(_1901, f16vec2(Weights.projection[172u], Weights.projection[173u]), fma(_1864, f16vec2(Weights.projection[136u], Weights.projection[137u]), fma(_1827, f16vec2(Weights.projection[100u], Weights.projection[101u]), fma(_1790, f16vec2(Weights.projection[64u], Weights.projection[65u]), fma(_1753, f16vec2(Weights.projection[28u], Weights.projection[29u]), f16vec2(Biases.projection[28u], Biases.projection[29u])))))))))));
    f16vec2 _2118 = fma(_2086, f16vec2(Weights.projection[354u], Weights.projection[355u]), fma(_2049, f16vec2(Weights.projection[318u], Weights.projection[319u]), fma(_2012, f16vec2(Weights.projection[282u], Weights.projection[283u]), fma(_1975, f16vec2(Weights.projection[246u], Weights.projection[247u]), fma(_1938, f16vec2(Weights.projection[210u], Weights.projection[211u]), fma(_1901, f16vec2(Weights.projection[174u], Weights.projection[175u]), fma(_1864, f16vec2(Weights.projection[138u], Weights.projection[139u]), fma(_1827, f16vec2(Weights.projection[102u], Weights.projection[103u]), fma(_1790, f16vec2(Weights.projection[66u], Weights.projection[67u]), fma(_1753, f16vec2(Weights.projection[30u], Weights.projection[31u]), f16vec2(Biases.projection[30u], Biases.projection[31u])))))))))));
    f16vec2 _2120 = fma(_2086, f16vec2(Weights.projection[356u], Weights.projection[357u]), fma(_2049, f16vec2(Weights.projection[320u], Weights.projection[321u]), fma(_2012, f16vec2(Weights.projection[284u], Weights.projection[285u]), fma(_1975, f16vec2(Weights.projection[248u], Weights.projection[249u]), fma(_1938, f16vec2(Weights.projection[212u], Weights.projection[213u]), fma(_1901, f16vec2(Weights.projection[176u], Weights.projection[177u]), fma(_1864, f16vec2(Weights.projection[140u], Weights.projection[141u]), fma(_1827, f16vec2(Weights.projection[104u], Weights.projection[105u]), fma(_1790, f16vec2(Weights.projection[68u], Weights.projection[69u]), fma(_1753, f16vec2(Weights.projection[32u], Weights.projection[33u]), f16vec2(Biases.projection[32u], Biases.projection[33u])))))))))));
    f16vec2 _2122 = fma(_2086, f16vec2(Weights.projection[358u], Weights.projection[359u]), fma(_2049, f16vec2(Weights.projection[322u], Weights.projection[323u]), fma(_2012, f16vec2(Weights.projection[286u], Weights.projection[287u]), fma(_1975, f16vec2(Weights.projection[250u], Weights.projection[251u]), fma(_1938, f16vec2(Weights.projection[214u], Weights.projection[215u]), fma(_1901, f16vec2(Weights.projection[178u], Weights.projection[179u]), fma(_1864, f16vec2(Weights.projection[142u], Weights.projection[143u]), fma(_1827, f16vec2(Weights.projection[106u], Weights.projection[107u]), fma(_1790, f16vec2(Weights.projection[70u], Weights.projection[71u]), fma(_1753, f16vec2(Weights.projection[34u], Weights.projection[35u]), f16vec2(Biases.projection[34u], Biases.projection[35u])))))))))));
    f16vec2 _2123 = f16vec2(_347[5].x);
    f16vec2 _2160 = f16vec2(_347[5].y);
    return f16vec2[](fma(_2160, f16vec2(Weights.projection[396u], Weights.projection[397u]), fma(_2123, f16vec2(Weights.projection[360u], Weights.projection[361u]), _2088)), fma(_2160, f16vec2(Weights.projection[398u], Weights.projection[399u]), fma(_2123, f16vec2(Weights.projection[362u], Weights.projection[363u]), _2090)), fma(_2160, f16vec2(Weights.projection[400u], Weights.projection[401u]), fma(_2123, f16vec2(Weights.projection[364u], Weights.projection[365u]), _2092)), fma(_2160, f16vec2(Weights.projection[402u], Weights.projection[403u]), fma(_2123, f16vec2(Weights.projection[366u], Weights.projection[367u]), _2094)), fma(_2160, f16vec2(Weights.projection[404u], Weights.projection[405u]), fma(_2123, f16vec2(Weights.projection[368u], Weights.projection[369u]), _2096)), fma(_2160, f16vec2(Weights.projection[406u], Weights.projection[407u]), fma(_2123, f16vec2(Weights.projection[370u], Weights.projection[371u]), _2098)), fma(_2160, f16vec2(Weights.projection[408u], Weights.projection[409u]), fma(_2123, f16vec2(Weights.projection[372u], Weights.projection[373u]), _2100)), fma(_2160, f16vec2(Weights.projection[410u], Weights.projection[411u]), fma(_2123, f16vec2(Weights.projection[374u], Weights.projection[375u]), _2102)), fma(_2160, f16vec2(Weights.projection[412u], Weights.projection[413u]), fma(_2123, f16vec2(Weights.projection[376u], Weights.projection[377u]), _2104)), fma(_2160, f16vec2(Weights.projection[414u], Weights.projection[415u]), fma(_2123, f16vec2(Weights.projection[378u], Weights.projection[379u]), _2106)), fma(_2160, f16vec2(Weights.projection[416u], Weights.projection[417u]), fma(_2123, f16vec2(Weights.projection[380u], Weights.projection[381u]), _2108)), fma(_2160, f16vec2(Weights.projection[418u], Weights.projection[419u]), fma(_2123, f16vec2(Weights.projection[382u], Weights.projection[383u]), _2110)), fma(_2160, f16vec2(Weights.projection[420u], Weights.projection[421u]), fma(_2123, f16vec2(Weights.projection[384u], Weights.projection[385u]), _2112)), fma(_2160, f16vec2(Weights.projection[422u], Weights.projection[423u]), fma(_2123, f16vec2(Weights.projection[386u], Weights.projection[387u]), _2114)), fma(_2160, f16vec2(Weights.projection[424u], Weights.projection[425u]), fma(_2123, f16vec2(Weights.projection[388u], Weights.projection[389u]), _2116)), fma(_2160, f16vec2(Weights.projection[426u], Weights.projection[427u]), fma(_2123, f16vec2(Weights.projection[390u], Weights.projection[391u]), _2118)), fma(_2160, f16vec2(Weights.projection[428u], Weights.projection[429u]), fma(_2123, f16vec2(Weights.projection[392u], Weights.projection[393u]), _2120)), fma(_2160, f16vec2(Weights.projection[430u], Weights.projection[431u]), fma(_2123, f16vec2(Weights.projection[394u], Weights.projection[395u]), _2122)));
}

ProjectedFeatures evaluateProjection(InputFeatures inputFeatures)
{
    f16vec2 _141[18] = _346(inputFeatures.value);
    f16vec2 tempArg[18] = _141;
    ProjectedFeatures projected;
    projected.value = _141;
    f16vec2 _3945[18] = projected.value;
    uint _3944 = 0u;
    f16vec2 _3943[18];
    uint _3951;
    for (;;)
    {
        _3951 = _3944;
        if (_3951 < 18u)
        {
            _3943[_3951] = max(_3945[_3951], _148[_3951]);
            _3944 = _3951 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    projected.value = _3943;
    return projected;
}

f16vec2[6] _2199(f16vec2 _2200[18])
{
    f16vec2 _3170 = f16vec2(_2200[0].x);
    f16vec2 _3183 = f16vec2(_2200[0].y);
    f16vec2 _3196 = f16vec2(_2200[1].x);
    f16vec2 _3209 = f16vec2(_2200[1].y);
    f16vec2 _3222 = f16vec2(_2200[2].x);
    f16vec2 _3235 = f16vec2(_2200[2].y);
    f16vec2 _3248 = f16vec2(_2200[3].x);
    f16vec2 _3261 = f16vec2(_2200[3].y);
    f16vec2 _3274 = f16vec2(_2200[4].x);
    f16vec2 _3287 = f16vec2(_2200[4].y);
    f16vec2 _3289 = fma(_3287, f16vec2(Weights.compression[108u], Weights.compression[109u]), fma(_3274, f16vec2(Weights.compression[96u], Weights.compression[97u]), fma(_3261, f16vec2(Weights.compression[84u], Weights.compression[85u]), fma(_3248, f16vec2(Weights.compression[72u], Weights.compression[73u]), fma(_3235, f16vec2(Weights.compression[60u], Weights.compression[61u]), fma(_3222, f16vec2(Weights.compression[48u], Weights.compression[49u]), fma(_3209, f16vec2(Weights.compression[36u], Weights.compression[37u]), fma(_3196, f16vec2(Weights.compression[24u], Weights.compression[25u]), fma(_3183, f16vec2(Weights.compression[12u], Weights.compression[13u]), fma(_3170, f16vec2(Weights.compression[0u], Weights.compression[1u]), f16vec2(Biases.compression[0u], Biases.compression[1u])))))))))));
    f16vec2 _3291 = fma(_3287, f16vec2(Weights.compression[110u], Weights.compression[111u]), fma(_3274, f16vec2(Weights.compression[98u], Weights.compression[99u]), fma(_3261, f16vec2(Weights.compression[86u], Weights.compression[87u]), fma(_3248, f16vec2(Weights.compression[74u], Weights.compression[75u]), fma(_3235, f16vec2(Weights.compression[62u], Weights.compression[63u]), fma(_3222, f16vec2(Weights.compression[50u], Weights.compression[51u]), fma(_3209, f16vec2(Weights.compression[38u], Weights.compression[39u]), fma(_3196, f16vec2(Weights.compression[26u], Weights.compression[27u]), fma(_3183, f16vec2(Weights.compression[14u], Weights.compression[15u]), fma(_3170, f16vec2(Weights.compression[2u], Weights.compression[3u]), f16vec2(Biases.compression[2u], Biases.compression[3u])))))))))));
    f16vec2 _3293 = fma(_3287, f16vec2(Weights.compression[112u], Weights.compression[113u]), fma(_3274, f16vec2(Weights.compression[100u], Weights.compression[101u]), fma(_3261, f16vec2(Weights.compression[88u], Weights.compression[89u]), fma(_3248, f16vec2(Weights.compression[76u], Weights.compression[77u]), fma(_3235, f16vec2(Weights.compression[64u], Weights.compression[65u]), fma(_3222, f16vec2(Weights.compression[52u], Weights.compression[53u]), fma(_3209, f16vec2(Weights.compression[40u], Weights.compression[41u]), fma(_3196, f16vec2(Weights.compression[28u], Weights.compression[29u]), fma(_3183, f16vec2(Weights.compression[16u], Weights.compression[17u]), fma(_3170, f16vec2(Weights.compression[4u], Weights.compression[5u]), f16vec2(Biases.compression[4u], Biases.compression[5u])))))))))));
    f16vec2 _3295 = fma(_3287, f16vec2(Weights.compression[114u], Weights.compression[115u]), fma(_3274, f16vec2(Weights.compression[102u], Weights.compression[103u]), fma(_3261, f16vec2(Weights.compression[90u], Weights.compression[91u]), fma(_3248, f16vec2(Weights.compression[78u], Weights.compression[79u]), fma(_3235, f16vec2(Weights.compression[66u], Weights.compression[67u]), fma(_3222, f16vec2(Weights.compression[54u], Weights.compression[55u]), fma(_3209, f16vec2(Weights.compression[42u], Weights.compression[43u]), fma(_3196, f16vec2(Weights.compression[30u], Weights.compression[31u]), fma(_3183, f16vec2(Weights.compression[18u], Weights.compression[19u]), fma(_3170, f16vec2(Weights.compression[6u], Weights.compression[7u]), f16vec2(Biases.compression[6u], Biases.compression[7u])))))))))));
    f16vec2 _3297 = fma(_3287, f16vec2(Weights.compression[116u], Weights.compression[117u]), fma(_3274, f16vec2(Weights.compression[104u], Weights.compression[105u]), fma(_3261, f16vec2(Weights.compression[92u], Weights.compression[93u]), fma(_3248, f16vec2(Weights.compression[80u], Weights.compression[81u]), fma(_3235, f16vec2(Weights.compression[68u], Weights.compression[69u]), fma(_3222, f16vec2(Weights.compression[56u], Weights.compression[57u]), fma(_3209, f16vec2(Weights.compression[44u], Weights.compression[45u]), fma(_3196, f16vec2(Weights.compression[32u], Weights.compression[33u]), fma(_3183, f16vec2(Weights.compression[20u], Weights.compression[21u]), fma(_3170, f16vec2(Weights.compression[8u], Weights.compression[9u]), f16vec2(Biases.compression[8u], Biases.compression[9u])))))))))));
    f16vec2 _3299 = fma(_3287, f16vec2(Weights.compression[118u], Weights.compression[119u]), fma(_3274, f16vec2(Weights.compression[106u], Weights.compression[107u]), fma(_3261, f16vec2(Weights.compression[94u], Weights.compression[95u]), fma(_3248, f16vec2(Weights.compression[82u], Weights.compression[83u]), fma(_3235, f16vec2(Weights.compression[70u], Weights.compression[71u]), fma(_3222, f16vec2(Weights.compression[58u], Weights.compression[59u]), fma(_3209, f16vec2(Weights.compression[46u], Weights.compression[47u]), fma(_3196, f16vec2(Weights.compression[34u], Weights.compression[35u]), fma(_3183, f16vec2(Weights.compression[22u], Weights.compression[23u]), fma(_3170, f16vec2(Weights.compression[10u], Weights.compression[11u]), f16vec2(Biases.compression[10u], Biases.compression[11u])))))))))));
    f16vec2 _3300 = f16vec2(_2200[5].x);
    f16vec2 _3313 = f16vec2(_2200[5].y);
    f16vec2 _3326 = f16vec2(_2200[6].x);
    f16vec2 _3339 = f16vec2(_2200[6].y);
    f16vec2 _3352 = f16vec2(_2200[7].x);
    f16vec2 _3365 = f16vec2(_2200[7].y);
    f16vec2 _3378 = f16vec2(_2200[8].x);
    f16vec2 _3391 = f16vec2(_2200[8].y);
    f16vec2 _3404 = f16vec2(_2200[9].x);
    f16vec2 _3417 = f16vec2(_2200[9].y);
    f16vec2 _3419 = fma(_3417, f16vec2(Weights.compression[228u], Weights.compression[229u]), fma(_3404, f16vec2(Weights.compression[216u], Weights.compression[217u]), fma(_3391, f16vec2(Weights.compression[204u], Weights.compression[205u]), fma(_3378, f16vec2(Weights.compression[192u], Weights.compression[193u]), fma(_3365, f16vec2(Weights.compression[180u], Weights.compression[181u]), fma(_3352, f16vec2(Weights.compression[168u], Weights.compression[169u]), fma(_3339, f16vec2(Weights.compression[156u], Weights.compression[157u]), fma(_3326, f16vec2(Weights.compression[144u], Weights.compression[145u]), fma(_3313, f16vec2(Weights.compression[132u], Weights.compression[133u]), fma(_3300, f16vec2(Weights.compression[120u], Weights.compression[121u]), _3289))))))))));
    f16vec2 _3421 = fma(_3417, f16vec2(Weights.compression[230u], Weights.compression[231u]), fma(_3404, f16vec2(Weights.compression[218u], Weights.compression[219u]), fma(_3391, f16vec2(Weights.compression[206u], Weights.compression[207u]), fma(_3378, f16vec2(Weights.compression[194u], Weights.compression[195u]), fma(_3365, f16vec2(Weights.compression[182u], Weights.compression[183u]), fma(_3352, f16vec2(Weights.compression[170u], Weights.compression[171u]), fma(_3339, f16vec2(Weights.compression[158u], Weights.compression[159u]), fma(_3326, f16vec2(Weights.compression[146u], Weights.compression[147u]), fma(_3313, f16vec2(Weights.compression[134u], Weights.compression[135u]), fma(_3300, f16vec2(Weights.compression[122u], Weights.compression[123u]), _3291))))))))));
    f16vec2 _3423 = fma(_3417, f16vec2(Weights.compression[232u], Weights.compression[233u]), fma(_3404, f16vec2(Weights.compression[220u], Weights.compression[221u]), fma(_3391, f16vec2(Weights.compression[208u], Weights.compression[209u]), fma(_3378, f16vec2(Weights.compression[196u], Weights.compression[197u]), fma(_3365, f16vec2(Weights.compression[184u], Weights.compression[185u]), fma(_3352, f16vec2(Weights.compression[172u], Weights.compression[173u]), fma(_3339, f16vec2(Weights.compression[160u], Weights.compression[161u]), fma(_3326, f16vec2(Weights.compression[148u], Weights.compression[149u]), fma(_3313, f16vec2(Weights.compression[136u], Weights.compression[137u]), fma(_3300, f16vec2(Weights.compression[124u], Weights.compression[125u]), _3293))))))))));
    f16vec2 _3425 = fma(_3417, f16vec2(Weights.compression[234u], Weights.compression[235u]), fma(_3404, f16vec2(Weights.compression[222u], Weights.compression[223u]), fma(_3391, f16vec2(Weights.compression[210u], Weights.compression[211u]), fma(_3378, f16vec2(Weights.compression[198u], Weights.compression[199u]), fma(_3365, f16vec2(Weights.compression[186u], Weights.compression[187u]), fma(_3352, f16vec2(Weights.compression[174u], Weights.compression[175u]), fma(_3339, f16vec2(Weights.compression[162u], Weights.compression[163u]), fma(_3326, f16vec2(Weights.compression[150u], Weights.compression[151u]), fma(_3313, f16vec2(Weights.compression[138u], Weights.compression[139u]), fma(_3300, f16vec2(Weights.compression[126u], Weights.compression[127u]), _3295))))))))));
    f16vec2 _3427 = fma(_3417, f16vec2(Weights.compression[236u], Weights.compression[237u]), fma(_3404, f16vec2(Weights.compression[224u], Weights.compression[225u]), fma(_3391, f16vec2(Weights.compression[212u], Weights.compression[213u]), fma(_3378, f16vec2(Weights.compression[200u], Weights.compression[201u]), fma(_3365, f16vec2(Weights.compression[188u], Weights.compression[189u]), fma(_3352, f16vec2(Weights.compression[176u], Weights.compression[177u]), fma(_3339, f16vec2(Weights.compression[164u], Weights.compression[165u]), fma(_3326, f16vec2(Weights.compression[152u], Weights.compression[153u]), fma(_3313, f16vec2(Weights.compression[140u], Weights.compression[141u]), fma(_3300, f16vec2(Weights.compression[128u], Weights.compression[129u]), _3297))))))))));
    f16vec2 _3429 = fma(_3417, f16vec2(Weights.compression[238u], Weights.compression[239u]), fma(_3404, f16vec2(Weights.compression[226u], Weights.compression[227u]), fma(_3391, f16vec2(Weights.compression[214u], Weights.compression[215u]), fma(_3378, f16vec2(Weights.compression[202u], Weights.compression[203u]), fma(_3365, f16vec2(Weights.compression[190u], Weights.compression[191u]), fma(_3352, f16vec2(Weights.compression[178u], Weights.compression[179u]), fma(_3339, f16vec2(Weights.compression[166u], Weights.compression[167u]), fma(_3326, f16vec2(Weights.compression[154u], Weights.compression[155u]), fma(_3313, f16vec2(Weights.compression[142u], Weights.compression[143u]), fma(_3300, f16vec2(Weights.compression[130u], Weights.compression[131u]), _3299))))))))));
    f16vec2 _3430 = f16vec2(_2200[10].x);
    f16vec2 _3443 = f16vec2(_2200[10].y);
    f16vec2 _3456 = f16vec2(_2200[11].x);
    f16vec2 _3469 = f16vec2(_2200[11].y);
    f16vec2 _3482 = f16vec2(_2200[12].x);
    f16vec2 _3495 = f16vec2(_2200[12].y);
    f16vec2 _3508 = f16vec2(_2200[13].x);
    f16vec2 _3521 = f16vec2(_2200[13].y);
    f16vec2 _3534 = f16vec2(_2200[14].x);
    f16vec2 _3547 = f16vec2(_2200[14].y);
    f16vec2 _3549 = fma(_3547, f16vec2(Weights.compression[348u], Weights.compression[349u]), fma(_3534, f16vec2(Weights.compression[336u], Weights.compression[337u]), fma(_3521, f16vec2(Weights.compression[324u], Weights.compression[325u]), fma(_3508, f16vec2(Weights.compression[312u], Weights.compression[313u]), fma(_3495, f16vec2(Weights.compression[300u], Weights.compression[301u]), fma(_3482, f16vec2(Weights.compression[288u], Weights.compression[289u]), fma(_3469, f16vec2(Weights.compression[276u], Weights.compression[277u]), fma(_3456, f16vec2(Weights.compression[264u], Weights.compression[265u]), fma(_3443, f16vec2(Weights.compression[252u], Weights.compression[253u]), fma(_3430, f16vec2(Weights.compression[240u], Weights.compression[241u]), _3419))))))))));
    f16vec2 _3551 = fma(_3547, f16vec2(Weights.compression[350u], Weights.compression[351u]), fma(_3534, f16vec2(Weights.compression[338u], Weights.compression[339u]), fma(_3521, f16vec2(Weights.compression[326u], Weights.compression[327u]), fma(_3508, f16vec2(Weights.compression[314u], Weights.compression[315u]), fma(_3495, f16vec2(Weights.compression[302u], Weights.compression[303u]), fma(_3482, f16vec2(Weights.compression[290u], Weights.compression[291u]), fma(_3469, f16vec2(Weights.compression[278u], Weights.compression[279u]), fma(_3456, f16vec2(Weights.compression[266u], Weights.compression[267u]), fma(_3443, f16vec2(Weights.compression[254u], Weights.compression[255u]), fma(_3430, f16vec2(Weights.compression[242u], Weights.compression[243u]), _3421))))))))));
    f16vec2 _3553 = fma(_3547, f16vec2(Weights.compression[352u], Weights.compression[353u]), fma(_3534, f16vec2(Weights.compression[340u], Weights.compression[341u]), fma(_3521, f16vec2(Weights.compression[328u], Weights.compression[329u]), fma(_3508, f16vec2(Weights.compression[316u], Weights.compression[317u]), fma(_3495, f16vec2(Weights.compression[304u], Weights.compression[305u]), fma(_3482, f16vec2(Weights.compression[292u], Weights.compression[293u]), fma(_3469, f16vec2(Weights.compression[280u], Weights.compression[281u]), fma(_3456, f16vec2(Weights.compression[268u], Weights.compression[269u]), fma(_3443, f16vec2(Weights.compression[256u], Weights.compression[257u]), fma(_3430, f16vec2(Weights.compression[244u], Weights.compression[245u]), _3423))))))))));
    f16vec2 _3555 = fma(_3547, f16vec2(Weights.compression[354u], Weights.compression[355u]), fma(_3534, f16vec2(Weights.compression[342u], Weights.compression[343u]), fma(_3521, f16vec2(Weights.compression[330u], Weights.compression[331u]), fma(_3508, f16vec2(Weights.compression[318u], Weights.compression[319u]), fma(_3495, f16vec2(Weights.compression[306u], Weights.compression[307u]), fma(_3482, f16vec2(Weights.compression[294u], Weights.compression[295u]), fma(_3469, f16vec2(Weights.compression[282u], Weights.compression[283u]), fma(_3456, f16vec2(Weights.compression[270u], Weights.compression[271u]), fma(_3443, f16vec2(Weights.compression[258u], Weights.compression[259u]), fma(_3430, f16vec2(Weights.compression[246u], Weights.compression[247u]), _3425))))))))));
    f16vec2 _3557 = fma(_3547, f16vec2(Weights.compression[356u], Weights.compression[357u]), fma(_3534, f16vec2(Weights.compression[344u], Weights.compression[345u]), fma(_3521, f16vec2(Weights.compression[332u], Weights.compression[333u]), fma(_3508, f16vec2(Weights.compression[320u], Weights.compression[321u]), fma(_3495, f16vec2(Weights.compression[308u], Weights.compression[309u]), fma(_3482, f16vec2(Weights.compression[296u], Weights.compression[297u]), fma(_3469, f16vec2(Weights.compression[284u], Weights.compression[285u]), fma(_3456, f16vec2(Weights.compression[272u], Weights.compression[273u]), fma(_3443, f16vec2(Weights.compression[260u], Weights.compression[261u]), fma(_3430, f16vec2(Weights.compression[248u], Weights.compression[249u]), _3427))))))))));
    f16vec2 _3559 = fma(_3547, f16vec2(Weights.compression[358u], Weights.compression[359u]), fma(_3534, f16vec2(Weights.compression[346u], Weights.compression[347u]), fma(_3521, f16vec2(Weights.compression[334u], Weights.compression[335u]), fma(_3508, f16vec2(Weights.compression[322u], Weights.compression[323u]), fma(_3495, f16vec2(Weights.compression[310u], Weights.compression[311u]), fma(_3482, f16vec2(Weights.compression[298u], Weights.compression[299u]), fma(_3469, f16vec2(Weights.compression[286u], Weights.compression[287u]), fma(_3456, f16vec2(Weights.compression[274u], Weights.compression[275u]), fma(_3443, f16vec2(Weights.compression[262u], Weights.compression[263u]), fma(_3430, f16vec2(Weights.compression[250u], Weights.compression[251u]), _3429))))))))));
    f16vec2 _3560 = f16vec2(_2200[15].x);
    f16vec2 _3573 = f16vec2(_2200[15].y);
    f16vec2 _3586 = f16vec2(_2200[16].x);
    f16vec2 _3599 = f16vec2(_2200[16].y);
    f16vec2 _3612 = f16vec2(_2200[17].x);
    f16vec2 _3625 = f16vec2(_2200[17].y);
    return f16vec2[](fma(_3625, f16vec2(Weights.compression[420u], Weights.compression[421u]), fma(_3612, f16vec2(Weights.compression[408u], Weights.compression[409u]), fma(_3599, f16vec2(Weights.compression[396u], Weights.compression[397u]), fma(_3586, f16vec2(Weights.compression[384u], Weights.compression[385u]), fma(_3573, f16vec2(Weights.compression[372u], Weights.compression[373u]), fma(_3560, f16vec2(Weights.compression[360u], Weights.compression[361u]), _3549)))))), fma(_3625, f16vec2(Weights.compression[422u], Weights.compression[423u]), fma(_3612, f16vec2(Weights.compression[410u], Weights.compression[411u]), fma(_3599, f16vec2(Weights.compression[398u], Weights.compression[399u]), fma(_3586, f16vec2(Weights.compression[386u], Weights.compression[387u]), fma(_3573, f16vec2(Weights.compression[374u], Weights.compression[375u]), fma(_3560, f16vec2(Weights.compression[362u], Weights.compression[363u]), _3551)))))), fma(_3625, f16vec2(Weights.compression[424u], Weights.compression[425u]), fma(_3612, f16vec2(Weights.compression[412u], Weights.compression[413u]), fma(_3599, f16vec2(Weights.compression[400u], Weights.compression[401u]), fma(_3586, f16vec2(Weights.compression[388u], Weights.compression[389u]), fma(_3573, f16vec2(Weights.compression[376u], Weights.compression[377u]), fma(_3560, f16vec2(Weights.compression[364u], Weights.compression[365u]), _3553)))))), fma(_3625, f16vec2(Weights.compression[426u], Weights.compression[427u]), fma(_3612, f16vec2(Weights.compression[414u], Weights.compression[415u]), fma(_3599, f16vec2(Weights.compression[402u], Weights.compression[403u]), fma(_3586, f16vec2(Weights.compression[390u], Weights.compression[391u]), fma(_3573, f16vec2(Weights.compression[378u], Weights.compression[379u]), fma(_3560, f16vec2(Weights.compression[366u], Weights.compression[367u]), _3555)))))), fma(_3625, f16vec2(Weights.compression[428u], Weights.compression[429u]), fma(_3612, f16vec2(Weights.compression[416u], Weights.compression[417u]), fma(_3599, f16vec2(Weights.compression[404u], Weights.compression[405u]), fma(_3586, f16vec2(Weights.compression[392u], Weights.compression[393u]), fma(_3573, f16vec2(Weights.compression[380u], Weights.compression[381u]), fma(_3560, f16vec2(Weights.compression[368u], Weights.compression[369u]), _3557)))))), fma(_3625, f16vec2(Weights.compression[430u], Weights.compression[431u]), fma(_3612, f16vec2(Weights.compression[418u], Weights.compression[419u]), fma(_3599, f16vec2(Weights.compression[406u], Weights.compression[407u]), fma(_3586, f16vec2(Weights.compression[394u], Weights.compression[395u]), fma(_3573, f16vec2(Weights.compression[382u], Weights.compression[383u]), fma(_3560, f16vec2(Weights.compression[370u], Weights.compression[371u]), _3559)))))));
}

CompactFeatures evaluateCompression(ProjectedFeatures projected)
{
    f16vec2 _175[6] = _2199(projected.value);
    f16vec2 tempArg[6] = _175;
    CompactFeatures compact;
    compact.value = _175;
    f16vec2 _3962[6] = compact.value;
    uint _3961 = 0u;
    f16vec2 _3960[6];
    uint _3968;
    for (;;)
    {
        _3968 = _3961;
        if (_3968 < 6u)
        {
            _3960[_3968] = max(_3962[_3968], _181[_3968]);
            _3961 = _3968 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    compact.value = _3960;
    return compact;
}

VisibilityHistory updateVisibilityHistory(CompactFeatures compact, uint preferredFrame)
{
    VisibilityHistory history;
    for (int frameIndex = 0; frameIndex < 2; frameIndex++)
    {
        history.frames[frameIndex].features = compact;
        history.frames[frameIndex].provenance = uvec2(uint(frameIndex), gl_GlobalInvocationID.x);
    }
    history.preferredFrame = preferredFrame;
    return history;
}

bool isHistoryFrameUsable(VisibilityFrame frame, uint expectedFrame)
{
    bool frameMatches = frame.provenance.x == expectedFrame;
    bool invocationMatches = frame.provenance.y == gl_GlobalInvocationID.x;
    return frameMatches && invocationMatches;
}

CompactFeatures resolveVisibilityHistory(VisibilityHistory history)
{
    uint selectedFrame = history.preferredFrame & 1u;
    VisibilityFrame candidate;
    switch (selectedFrame)
    {
        case 0u:
        {
            candidate = history.frames[0];
            break;
        }
        default:
        {
            candidate = history.frames[1];
            break;
        }
    }
    VisibilityFrame param = candidate;
    uint param_1 = selectedFrame;
    if (isHistoryFrameUsable(param, param_1))
    {
        return candidate.features;
    }
    return history.frames[0].features;
}

f16vec2[3] _3640(f16vec2 _3641[6])
{
    f16vec2 _3828 = f16vec2(_3641[0].x);
    f16vec2 _3835 = f16vec2(_3641[0].y);
    f16vec2 _3842 = f16vec2(_3641[1].x);
    f16vec2 _3849 = f16vec2(_3641[1].y);
    f16vec2 _3856 = f16vec2(_3641[2].x);
    f16vec2 _3863 = f16vec2(_3641[2].y);
    f16vec2 _3870 = f16vec2(_3641[3].x);
    f16vec2 _3877 = f16vec2(_3641[3].y);
    f16vec2 _3884 = f16vec2(_3641[4].x);
    f16vec2 _3891 = f16vec2(_3641[4].y);
    f16vec2 _3893 = fma(_3891, f16vec2(Weights.classifier[54u], Weights.classifier[55u]), fma(_3884, f16vec2(Weights.classifier[48u], Weights.classifier[49u]), fma(_3877, f16vec2(Weights.classifier[42u], Weights.classifier[43u]), fma(_3870, f16vec2(Weights.classifier[36u], Weights.classifier[37u]), fma(_3863, f16vec2(Weights.classifier[30u], Weights.classifier[31u]), fma(_3856, f16vec2(Weights.classifier[24u], Weights.classifier[25u]), fma(_3849, f16vec2(Weights.classifier[18u], Weights.classifier[19u]), fma(_3842, f16vec2(Weights.classifier[12u], Weights.classifier[13u]), fma(_3835, f16vec2(Weights.classifier[6u], Weights.classifier[7u]), fma(_3828, f16vec2(Weights.classifier[0u], Weights.classifier[1u]), f16vec2(Biases.classifier[0u], Biases.classifier[1u])))))))))));
    f16vec2 _3895 = fma(_3891, f16vec2(Weights.classifier[56u], Weights.classifier[57u]), fma(_3884, f16vec2(Weights.classifier[50u], Weights.classifier[51u]), fma(_3877, f16vec2(Weights.classifier[44u], Weights.classifier[45u]), fma(_3870, f16vec2(Weights.classifier[38u], Weights.classifier[39u]), fma(_3863, f16vec2(Weights.classifier[32u], Weights.classifier[33u]), fma(_3856, f16vec2(Weights.classifier[26u], Weights.classifier[27u]), fma(_3849, f16vec2(Weights.classifier[20u], Weights.classifier[21u]), fma(_3842, f16vec2(Weights.classifier[14u], Weights.classifier[15u]), fma(_3835, f16vec2(Weights.classifier[8u], Weights.classifier[9u]), fma(_3828, f16vec2(Weights.classifier[2u], Weights.classifier[3u]), f16vec2(Biases.classifier[2u], Biases.classifier[3u])))))))))));
    f16vec2 _3897 = fma(_3891, f16vec2(Weights.classifier[58u], Weights.classifier[59u]), fma(_3884, f16vec2(Weights.classifier[52u], Weights.classifier[53u]), fma(_3877, f16vec2(Weights.classifier[46u], Weights.classifier[47u]), fma(_3870, f16vec2(Weights.classifier[40u], Weights.classifier[41u]), fma(_3863, f16vec2(Weights.classifier[34u], Weights.classifier[35u]), fma(_3856, f16vec2(Weights.classifier[28u], Weights.classifier[29u]), fma(_3849, f16vec2(Weights.classifier[22u], Weights.classifier[23u]), fma(_3842, f16vec2(Weights.classifier[16u], Weights.classifier[17u]), fma(_3835, f16vec2(Weights.classifier[10u], Weights.classifier[11u]), fma(_3828, f16vec2(Weights.classifier[4u], Weights.classifier[5u]), f16vec2(Biases.classifier[4u], Biases.classifier[5u])))))))))));
    f16vec2 _3898 = f16vec2(_3641[5].x);
    f16vec2 _3905 = f16vec2(_3641[5].y);
    return f16vec2[](fma(_3905, f16vec2(Weights.classifier[66u], Weights.classifier[67u]), fma(_3898, f16vec2(Weights.classifier[60u], Weights.classifier[61u]), _3893)), fma(_3905, f16vec2(Weights.classifier[68u], Weights.classifier[69u]), fma(_3898, f16vec2(Weights.classifier[62u], Weights.classifier[63u]), _3895)), fma(_3905, f16vec2(Weights.classifier[70u], Weights.classifier[71u]), fma(_3898, f16vec2(Weights.classifier[64u], Weights.classifier[65u]), _3897)));
}

VisibilityResult evaluateVisibilityClassifier(CompactFeatures compact)
{
    f16vec2 _285[3] = _3640(compact.value);
    f16vec2 tempArg[3] = _285;
    VisibilityResult result;
    result.value = _285;
    f16vec2 _3980[3] = result.value;
    uint _3979 = 0u;
    f16vec2 _3978[3];
    uint _3986;
    for (;;)
    {
        _3986 = _3979;
        if (_3986 < 3u)
        {
            _3978[_3986] = max(_3980[_3986], _291[_3986]);
            _3979 = _3986 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    result.value = _3978;
    return result;
}

void _3996(uint _3997, f16vec2 _3998)
{
    OutY.visibility[_3997] = _3998.x;
    OutY.visibility[_3997 + 1u] = _3998.y;
}

void storeVisibilityResult(VisibilityResult result)
{
    f16vec2 _4006[3] = result.value;
    uint _4007 = 0u;
    uint _4012;
    for (;;)
    {
        _4012 = _4007;
        if (_4012 < 6u)
        {
            _3996(0u + _4012, _4006[_4012 / 2u]);
            _4007 = _4012 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

void main()
{
    uint route = buildVisibilityRoute();
    InputFeatures _308 = loadVisibilityInput();
    InputFeatures inputFeatures = _308;
    InputFeatures param = _308;
    ProjectedFeatures _312 = evaluateProjection(param);
    ProjectedFeatures projected = _312;
    ProjectedFeatures param_1 = _312;
    CompactFeatures _316 = evaluateCompression(param_1);
    CompactFeatures compact = _316;
    CompactFeatures param_2 = _316;
    uint param_3 = route;
    VisibilityHistory _322 = updateVisibilityHistory(param_2, param_3);
    VisibilityHistory history = _322;
    VisibilityHistory param_4 = _322;
    CompactFeatures _326 = resolveVisibilityHistory(param_4);
    CompactFeatures resolved = _326;
    CompactFeatures param_5 = _326;
    VisibilityResult _330 = evaluateVisibilityClassifier(param_5);
    VisibilityResult result = _330;
    VisibilityResult param_6 = _330;
    storeVisibilityResult(param_6);
}

