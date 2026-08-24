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

f16vec2[8] _72()
{
    f16vec2 _1673 = f16vec2(X.data[0u]);
    f16vec2 _1690 = f16vec2(X.data[1u]);
    f16vec2 _1707 = f16vec2(X.data[2u]);
    f16vec2 _1724 = f16vec2(X.data[3u]);
    f16vec2 _1741 = f16vec2(X.data[4u]);
    f16vec2 _1758 = f16vec2(X.data[5u]);
    f16vec2 _1775 = f16vec2(X.data[6u]);
    f16vec2 _1792 = f16vec2(X.data[7u]);
    f16vec2 _1809 = f16vec2(X.data[8u]);
    f16vec2 _1826 = f16vec2(X.data[9u]);
    f16vec2 _1843 = f16vec2(X.data[10u]);
    f16vec2 _1845 = fma(_1843, f16vec2(W.data[160u], W.data[161u]), fma(_1826, f16vec2(W.data[144u], W.data[145u]), fma(_1809, f16vec2(W.data[128u], W.data[129u]), fma(_1792, f16vec2(W.data[112u], W.data[113u]), fma(_1775, f16vec2(W.data[96u], W.data[97u]), fma(_1758, f16vec2(W.data[80u], W.data[81u]), fma(_1741, f16vec2(W.data[64u], W.data[65u]), fma(_1724, f16vec2(W.data[48u], W.data[49u]), fma(_1707, f16vec2(W.data[32u], W.data[33u]), fma(_1690, f16vec2(W.data[16u], W.data[17u]), fma(_1673, f16vec2(W.data[0u], W.data[1u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _1847 = fma(_1843, f16vec2(W.data[162u], W.data[163u]), fma(_1826, f16vec2(W.data[146u], W.data[147u]), fma(_1809, f16vec2(W.data[130u], W.data[131u]), fma(_1792, f16vec2(W.data[114u], W.data[115u]), fma(_1775, f16vec2(W.data[98u], W.data[99u]), fma(_1758, f16vec2(W.data[82u], W.data[83u]), fma(_1741, f16vec2(W.data[66u], W.data[67u]), fma(_1724, f16vec2(W.data[50u], W.data[51u]), fma(_1707, f16vec2(W.data[34u], W.data[35u]), fma(_1690, f16vec2(W.data[18u], W.data[19u]), fma(_1673, f16vec2(W.data[2u], W.data[3u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _1849 = fma(_1843, f16vec2(W.data[164u], W.data[165u]), fma(_1826, f16vec2(W.data[148u], W.data[149u]), fma(_1809, f16vec2(W.data[132u], W.data[133u]), fma(_1792, f16vec2(W.data[116u], W.data[117u]), fma(_1775, f16vec2(W.data[100u], W.data[101u]), fma(_1758, f16vec2(W.data[84u], W.data[85u]), fma(_1741, f16vec2(W.data[68u], W.data[69u]), fma(_1724, f16vec2(W.data[52u], W.data[53u]), fma(_1707, f16vec2(W.data[36u], W.data[37u]), fma(_1690, f16vec2(W.data[20u], W.data[21u]), fma(_1673, f16vec2(W.data[4u], W.data[5u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _1851 = fma(_1843, f16vec2(W.data[166u], W.data[167u]), fma(_1826, f16vec2(W.data[150u], W.data[151u]), fma(_1809, f16vec2(W.data[134u], W.data[135u]), fma(_1792, f16vec2(W.data[118u], W.data[119u]), fma(_1775, f16vec2(W.data[102u], W.data[103u]), fma(_1758, f16vec2(W.data[86u], W.data[87u]), fma(_1741, f16vec2(W.data[70u], W.data[71u]), fma(_1724, f16vec2(W.data[54u], W.data[55u]), fma(_1707, f16vec2(W.data[38u], W.data[39u]), fma(_1690, f16vec2(W.data[22u], W.data[23u]), fma(_1673, f16vec2(W.data[6u], W.data[7u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _1853 = fma(_1843, f16vec2(W.data[168u], W.data[169u]), fma(_1826, f16vec2(W.data[152u], W.data[153u]), fma(_1809, f16vec2(W.data[136u], W.data[137u]), fma(_1792, f16vec2(W.data[120u], W.data[121u]), fma(_1775, f16vec2(W.data[104u], W.data[105u]), fma(_1758, f16vec2(W.data[88u], W.data[89u]), fma(_1741, f16vec2(W.data[72u], W.data[73u]), fma(_1724, f16vec2(W.data[56u], W.data[57u]), fma(_1707, f16vec2(W.data[40u], W.data[41u]), fma(_1690, f16vec2(W.data[24u], W.data[25u]), fma(_1673, f16vec2(W.data[8u], W.data[9u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _1855 = fma(_1843, f16vec2(W.data[170u], W.data[171u]), fma(_1826, f16vec2(W.data[154u], W.data[155u]), fma(_1809, f16vec2(W.data[138u], W.data[139u]), fma(_1792, f16vec2(W.data[122u], W.data[123u]), fma(_1775, f16vec2(W.data[106u], W.data[107u]), fma(_1758, f16vec2(W.data[90u], W.data[91u]), fma(_1741, f16vec2(W.data[74u], W.data[75u]), fma(_1724, f16vec2(W.data[58u], W.data[59u]), fma(_1707, f16vec2(W.data[42u], W.data[43u]), fma(_1690, f16vec2(W.data[26u], W.data[27u]), fma(_1673, f16vec2(W.data[10u], W.data[11u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _1857 = fma(_1843, f16vec2(W.data[172u], W.data[173u]), fma(_1826, f16vec2(W.data[156u], W.data[157u]), fma(_1809, f16vec2(W.data[140u], W.data[141u]), fma(_1792, f16vec2(W.data[124u], W.data[125u]), fma(_1775, f16vec2(W.data[108u], W.data[109u]), fma(_1758, f16vec2(W.data[92u], W.data[93u]), fma(_1741, f16vec2(W.data[76u], W.data[77u]), fma(_1724, f16vec2(W.data[60u], W.data[61u]), fma(_1707, f16vec2(W.data[44u], W.data[45u]), fma(_1690, f16vec2(W.data[28u], W.data[29u]), fma(_1673, f16vec2(W.data[12u], W.data[13u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _1859 = fma(_1843, f16vec2(W.data[174u], W.data[175u]), fma(_1826, f16vec2(W.data[158u], W.data[159u]), fma(_1809, f16vec2(W.data[142u], W.data[143u]), fma(_1792, f16vec2(W.data[126u], W.data[127u]), fma(_1775, f16vec2(W.data[110u], W.data[111u]), fma(_1758, f16vec2(W.data[94u], W.data[95u]), fma(_1741, f16vec2(W.data[78u], W.data[79u]), fma(_1724, f16vec2(W.data[62u], W.data[63u]), fma(_1707, f16vec2(W.data[46u], W.data[47u]), fma(_1690, f16vec2(W.data[30u], W.data[31u]), fma(_1673, f16vec2(W.data[14u], W.data[15u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _1860 = f16vec2(X.data[11u]);
    f16vec2 _1877 = f16vec2(X.data[12u]);
    f16vec2 _1894 = f16vec2(X.data[13u]);
    f16vec2 _1911 = f16vec2(X.data[14u]);
    f16vec2 _1928 = f16vec2(X.data[15u]);
    f16vec2 _1945 = f16vec2(X.data[16u]);
    f16vec2 _1962 = f16vec2(X.data[17u]);
    f16vec2 _1979 = f16vec2(X.data[18u]);
    f16vec2 _1996 = f16vec2(X.data[19u]);
    f16vec2 _2013 = f16vec2(X.data[20u]);
    f16vec2 _2015 = fma(_2013, f16vec2(W.data[320u], W.data[321u]), fma(_1996, f16vec2(W.data[304u], W.data[305u]), fma(_1979, f16vec2(W.data[288u], W.data[289u]), fma(_1962, f16vec2(W.data[272u], W.data[273u]), fma(_1945, f16vec2(W.data[256u], W.data[257u]), fma(_1928, f16vec2(W.data[240u], W.data[241u]), fma(_1911, f16vec2(W.data[224u], W.data[225u]), fma(_1894, f16vec2(W.data[208u], W.data[209u]), fma(_1877, f16vec2(W.data[192u], W.data[193u]), fma(_1860, f16vec2(W.data[176u], W.data[177u]), _1845))))))))));
    f16vec2 _2017 = fma(_2013, f16vec2(W.data[322u], W.data[323u]), fma(_1996, f16vec2(W.data[306u], W.data[307u]), fma(_1979, f16vec2(W.data[290u], W.data[291u]), fma(_1962, f16vec2(W.data[274u], W.data[275u]), fma(_1945, f16vec2(W.data[258u], W.data[259u]), fma(_1928, f16vec2(W.data[242u], W.data[243u]), fma(_1911, f16vec2(W.data[226u], W.data[227u]), fma(_1894, f16vec2(W.data[210u], W.data[211u]), fma(_1877, f16vec2(W.data[194u], W.data[195u]), fma(_1860, f16vec2(W.data[178u], W.data[179u]), _1847))))))))));
    f16vec2 _2019 = fma(_2013, f16vec2(W.data[324u], W.data[325u]), fma(_1996, f16vec2(W.data[308u], W.data[309u]), fma(_1979, f16vec2(W.data[292u], W.data[293u]), fma(_1962, f16vec2(W.data[276u], W.data[277u]), fma(_1945, f16vec2(W.data[260u], W.data[261u]), fma(_1928, f16vec2(W.data[244u], W.data[245u]), fma(_1911, f16vec2(W.data[228u], W.data[229u]), fma(_1894, f16vec2(W.data[212u], W.data[213u]), fma(_1877, f16vec2(W.data[196u], W.data[197u]), fma(_1860, f16vec2(W.data[180u], W.data[181u]), _1849))))))))));
    f16vec2 _2021 = fma(_2013, f16vec2(W.data[326u], W.data[327u]), fma(_1996, f16vec2(W.data[310u], W.data[311u]), fma(_1979, f16vec2(W.data[294u], W.data[295u]), fma(_1962, f16vec2(W.data[278u], W.data[279u]), fma(_1945, f16vec2(W.data[262u], W.data[263u]), fma(_1928, f16vec2(W.data[246u], W.data[247u]), fma(_1911, f16vec2(W.data[230u], W.data[231u]), fma(_1894, f16vec2(W.data[214u], W.data[215u]), fma(_1877, f16vec2(W.data[198u], W.data[199u]), fma(_1860, f16vec2(W.data[182u], W.data[183u]), _1851))))))))));
    f16vec2 _2023 = fma(_2013, f16vec2(W.data[328u], W.data[329u]), fma(_1996, f16vec2(W.data[312u], W.data[313u]), fma(_1979, f16vec2(W.data[296u], W.data[297u]), fma(_1962, f16vec2(W.data[280u], W.data[281u]), fma(_1945, f16vec2(W.data[264u], W.data[265u]), fma(_1928, f16vec2(W.data[248u], W.data[249u]), fma(_1911, f16vec2(W.data[232u], W.data[233u]), fma(_1894, f16vec2(W.data[216u], W.data[217u]), fma(_1877, f16vec2(W.data[200u], W.data[201u]), fma(_1860, f16vec2(W.data[184u], W.data[185u]), _1853))))))))));
    f16vec2 _2025 = fma(_2013, f16vec2(W.data[330u], W.data[331u]), fma(_1996, f16vec2(W.data[314u], W.data[315u]), fma(_1979, f16vec2(W.data[298u], W.data[299u]), fma(_1962, f16vec2(W.data[282u], W.data[283u]), fma(_1945, f16vec2(W.data[266u], W.data[267u]), fma(_1928, f16vec2(W.data[250u], W.data[251u]), fma(_1911, f16vec2(W.data[234u], W.data[235u]), fma(_1894, f16vec2(W.data[218u], W.data[219u]), fma(_1877, f16vec2(W.data[202u], W.data[203u]), fma(_1860, f16vec2(W.data[186u], W.data[187u]), _1855))))))))));
    f16vec2 _2027 = fma(_2013, f16vec2(W.data[332u], W.data[333u]), fma(_1996, f16vec2(W.data[316u], W.data[317u]), fma(_1979, f16vec2(W.data[300u], W.data[301u]), fma(_1962, f16vec2(W.data[284u], W.data[285u]), fma(_1945, f16vec2(W.data[268u], W.data[269u]), fma(_1928, f16vec2(W.data[252u], W.data[253u]), fma(_1911, f16vec2(W.data[236u], W.data[237u]), fma(_1894, f16vec2(W.data[220u], W.data[221u]), fma(_1877, f16vec2(W.data[204u], W.data[205u]), fma(_1860, f16vec2(W.data[188u], W.data[189u]), _1857))))))))));
    f16vec2 _2029 = fma(_2013, f16vec2(W.data[334u], W.data[335u]), fma(_1996, f16vec2(W.data[318u], W.data[319u]), fma(_1979, f16vec2(W.data[302u], W.data[303u]), fma(_1962, f16vec2(W.data[286u], W.data[287u]), fma(_1945, f16vec2(W.data[270u], W.data[271u]), fma(_1928, f16vec2(W.data[254u], W.data[255u]), fma(_1911, f16vec2(W.data[238u], W.data[239u]), fma(_1894, f16vec2(W.data[222u], W.data[223u]), fma(_1877, f16vec2(W.data[206u], W.data[207u]), fma(_1860, f16vec2(W.data[190u], W.data[191u]), _1859))))))))));
    f16vec2 _2030 = f16vec2(X.data[21u]);
    f16vec2 _2047 = f16vec2(X.data[22u]);
    f16vec2 _2064 = f16vec2(X.data[23u]);
    f16vec2 _2081 = f16vec2(X.data[24u]);
    f16vec2 _2098 = f16vec2(X.data[25u]);
    f16vec2 _2115 = f16vec2(X.data[26u]);
    f16vec2 _2132 = f16vec2(X.data[27u]);
    f16vec2 _2149 = f16vec2(X.data[28u]);
    f16vec2 _2166 = f16vec2(X.data[29u]);
    f16vec2 _2183 = f16vec2(X.data[30u]);
    f16vec2 _2185 = fma(_2183, f16vec2(W.data[480u], W.data[481u]), fma(_2166, f16vec2(W.data[464u], W.data[465u]), fma(_2149, f16vec2(W.data[448u], W.data[449u]), fma(_2132, f16vec2(W.data[432u], W.data[433u]), fma(_2115, f16vec2(W.data[416u], W.data[417u]), fma(_2098, f16vec2(W.data[400u], W.data[401u]), fma(_2081, f16vec2(W.data[384u], W.data[385u]), fma(_2064, f16vec2(W.data[368u], W.data[369u]), fma(_2047, f16vec2(W.data[352u], W.data[353u]), fma(_2030, f16vec2(W.data[336u], W.data[337u]), _2015))))))))));
    f16vec2 _2187 = fma(_2183, f16vec2(W.data[482u], W.data[483u]), fma(_2166, f16vec2(W.data[466u], W.data[467u]), fma(_2149, f16vec2(W.data[450u], W.data[451u]), fma(_2132, f16vec2(W.data[434u], W.data[435u]), fma(_2115, f16vec2(W.data[418u], W.data[419u]), fma(_2098, f16vec2(W.data[402u], W.data[403u]), fma(_2081, f16vec2(W.data[386u], W.data[387u]), fma(_2064, f16vec2(W.data[370u], W.data[371u]), fma(_2047, f16vec2(W.data[354u], W.data[355u]), fma(_2030, f16vec2(W.data[338u], W.data[339u]), _2017))))))))));
    f16vec2 _2189 = fma(_2183, f16vec2(W.data[484u], W.data[485u]), fma(_2166, f16vec2(W.data[468u], W.data[469u]), fma(_2149, f16vec2(W.data[452u], W.data[453u]), fma(_2132, f16vec2(W.data[436u], W.data[437u]), fma(_2115, f16vec2(W.data[420u], W.data[421u]), fma(_2098, f16vec2(W.data[404u], W.data[405u]), fma(_2081, f16vec2(W.data[388u], W.data[389u]), fma(_2064, f16vec2(W.data[372u], W.data[373u]), fma(_2047, f16vec2(W.data[356u], W.data[357u]), fma(_2030, f16vec2(W.data[340u], W.data[341u]), _2019))))))))));
    f16vec2 _2191 = fma(_2183, f16vec2(W.data[486u], W.data[487u]), fma(_2166, f16vec2(W.data[470u], W.data[471u]), fma(_2149, f16vec2(W.data[454u], W.data[455u]), fma(_2132, f16vec2(W.data[438u], W.data[439u]), fma(_2115, f16vec2(W.data[422u], W.data[423u]), fma(_2098, f16vec2(W.data[406u], W.data[407u]), fma(_2081, f16vec2(W.data[390u], W.data[391u]), fma(_2064, f16vec2(W.data[374u], W.data[375u]), fma(_2047, f16vec2(W.data[358u], W.data[359u]), fma(_2030, f16vec2(W.data[342u], W.data[343u]), _2021))))))))));
    f16vec2 _2193 = fma(_2183, f16vec2(W.data[488u], W.data[489u]), fma(_2166, f16vec2(W.data[472u], W.data[473u]), fma(_2149, f16vec2(W.data[456u], W.data[457u]), fma(_2132, f16vec2(W.data[440u], W.data[441u]), fma(_2115, f16vec2(W.data[424u], W.data[425u]), fma(_2098, f16vec2(W.data[408u], W.data[409u]), fma(_2081, f16vec2(W.data[392u], W.data[393u]), fma(_2064, f16vec2(W.data[376u], W.data[377u]), fma(_2047, f16vec2(W.data[360u], W.data[361u]), fma(_2030, f16vec2(W.data[344u], W.data[345u]), _2023))))))))));
    f16vec2 _2195 = fma(_2183, f16vec2(W.data[490u], W.data[491u]), fma(_2166, f16vec2(W.data[474u], W.data[475u]), fma(_2149, f16vec2(W.data[458u], W.data[459u]), fma(_2132, f16vec2(W.data[442u], W.data[443u]), fma(_2115, f16vec2(W.data[426u], W.data[427u]), fma(_2098, f16vec2(W.data[410u], W.data[411u]), fma(_2081, f16vec2(W.data[394u], W.data[395u]), fma(_2064, f16vec2(W.data[378u], W.data[379u]), fma(_2047, f16vec2(W.data[362u], W.data[363u]), fma(_2030, f16vec2(W.data[346u], W.data[347u]), _2025))))))))));
    f16vec2 _2197 = fma(_2183, f16vec2(W.data[492u], W.data[493u]), fma(_2166, f16vec2(W.data[476u], W.data[477u]), fma(_2149, f16vec2(W.data[460u], W.data[461u]), fma(_2132, f16vec2(W.data[444u], W.data[445u]), fma(_2115, f16vec2(W.data[428u], W.data[429u]), fma(_2098, f16vec2(W.data[412u], W.data[413u]), fma(_2081, f16vec2(W.data[396u], W.data[397u]), fma(_2064, f16vec2(W.data[380u], W.data[381u]), fma(_2047, f16vec2(W.data[364u], W.data[365u]), fma(_2030, f16vec2(W.data[348u], W.data[349u]), _2027))))))))));
    f16vec2 _2199 = fma(_2183, f16vec2(W.data[494u], W.data[495u]), fma(_2166, f16vec2(W.data[478u], W.data[479u]), fma(_2149, f16vec2(W.data[462u], W.data[463u]), fma(_2132, f16vec2(W.data[446u], W.data[447u]), fma(_2115, f16vec2(W.data[430u], W.data[431u]), fma(_2098, f16vec2(W.data[414u], W.data[415u]), fma(_2081, f16vec2(W.data[398u], W.data[399u]), fma(_2064, f16vec2(W.data[382u], W.data[383u]), fma(_2047, f16vec2(W.data[366u], W.data[367u]), fma(_2030, f16vec2(W.data[350u], W.data[351u]), _2029))))))))));
    f16vec2 _2200 = f16vec2(X.data[31u]);
    return f16vec2[](fma(_2200, f16vec2(W.data[496u], W.data[497u]), _2185), fma(_2200, f16vec2(W.data[498u], W.data[499u]), _2187), fma(_2200, f16vec2(W.data[500u], W.data[501u]), _2189), fma(_2200, f16vec2(W.data[502u], W.data[503u]), _2191), fma(_2200, f16vec2(W.data[504u], W.data[505u]), _2193), fma(_2200, f16vec2(W.data[506u], W.data[507u]), _2195), fma(_2200, f16vec2(W.data[508u], W.data[509u]), _2197), fma(_2200, f16vec2(W.data[510u], W.data[511u]), _2199));
}

void _2219(uint _2220, f16vec2 _2221)
{
    Y.data[_2220] = _2221.x;
    Y.data[_2220 + 1u] = _2221.y;
}

void main()
{
    f16vec2 _47[8] = _72();
    f16vec2 tempArg[8] = _47;
    f16vec2 y[8] = _47;
    f16vec2 _2233[8] = _47;
    uint _2234 = 0u;
    uint _2239;
    for (;;)
    {
        _2239 = _2234;
        if (_2239 < 16u)
        {
            _2219(0u + _2239, _2233[_2239 / 2u]);
            _2234 = _2239 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

