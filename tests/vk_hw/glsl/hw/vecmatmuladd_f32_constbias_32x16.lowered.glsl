#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec2 _19[8] = vec2[](vec2(-0.75, -0.5), vec2(-0.25, 0.0), vec2(0.25, 0.5), vec2(0.75, -0.75), vec2(-0.5, -0.25), vec2(0.0, 0.25), vec2(0.5, 0.75), vec2(-0.75, -0.5));

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float data[];
} Bias;

vec2[8] _81()
{
    vec2 _1701 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[192u], W.data[208u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[160u], W.data[176u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[128u], W.data[144u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[96u], W.data[112u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[64u], W.data[80u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[32u], W.data[48u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[0u], W.data[16u]), vec2(0.0))))))));
    vec2 _1722 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[416u], W.data[432u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[384u], W.data[400u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[352u], W.data[368u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[320u], W.data[336u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[288u], W.data[304u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[256u], W.data[272u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[224u], W.data[240u]), _1701)))))));
    vec2 _1728 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[480u], W.data[496u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[448u], W.data[464u]), _1722));
    vec2 _1755 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[193u], W.data[209u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[161u], W.data[177u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[129u], W.data[145u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[97u], W.data[113u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[65u], W.data[81u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[33u], W.data[49u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[1u], W.data[17u]), vec2(0.0))))))));
    vec2 _1776 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[417u], W.data[433u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[385u], W.data[401u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[353u], W.data[369u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[321u], W.data[337u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[289u], W.data[305u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[257u], W.data[273u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[225u], W.data[241u]), _1755)))))));
    vec2 _1782 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[481u], W.data[497u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[449u], W.data[465u]), _1776));
    vec2 _1809 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[194u], W.data[210u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[162u], W.data[178u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[130u], W.data[146u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[98u], W.data[114u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[66u], W.data[82u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[34u], W.data[50u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[2u], W.data[18u]), vec2(0.0))))))));
    vec2 _1830 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[418u], W.data[434u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[386u], W.data[402u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[354u], W.data[370u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[322u], W.data[338u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[290u], W.data[306u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[258u], W.data[274u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[226u], W.data[242u]), _1809)))))));
    vec2 _1836 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[482u], W.data[498u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[450u], W.data[466u]), _1830));
    vec2 _1863 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[195u], W.data[211u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[163u], W.data[179u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[131u], W.data[147u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[99u], W.data[115u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[67u], W.data[83u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[35u], W.data[51u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[3u], W.data[19u]), vec2(0.0))))))));
    vec2 _1884 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[419u], W.data[435u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[387u], W.data[403u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[355u], W.data[371u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[323u], W.data[339u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[291u], W.data[307u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[259u], W.data[275u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[227u], W.data[243u]), _1863)))))));
    vec2 _1890 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[483u], W.data[499u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[451u], W.data[467u]), _1884));
    vec2 _1917 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[196u], W.data[212u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[164u], W.data[180u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[132u], W.data[148u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[100u], W.data[116u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[68u], W.data[84u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[36u], W.data[52u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[4u], W.data[20u]), vec2(0.0))))))));
    vec2 _1938 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[420u], W.data[436u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[388u], W.data[404u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[356u], W.data[372u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[324u], W.data[340u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[292u], W.data[308u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[260u], W.data[276u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[228u], W.data[244u]), _1917)))))));
    vec2 _1944 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[484u], W.data[500u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[452u], W.data[468u]), _1938));
    vec2 _1971 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[197u], W.data[213u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[165u], W.data[181u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[133u], W.data[149u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[101u], W.data[117u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[69u], W.data[85u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[37u], W.data[53u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[5u], W.data[21u]), vec2(0.0))))))));
    vec2 _1992 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[421u], W.data[437u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[389u], W.data[405u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[357u], W.data[373u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[325u], W.data[341u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[293u], W.data[309u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[261u], W.data[277u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[229u], W.data[245u]), _1971)))))));
    vec2 _1998 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[485u], W.data[501u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[453u], W.data[469u]), _1992));
    vec2 _2025 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[198u], W.data[214u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[166u], W.data[182u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[134u], W.data[150u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[102u], W.data[118u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[70u], W.data[86u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[38u], W.data[54u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[6u], W.data[22u]), vec2(0.0))))))));
    vec2 _2046 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[422u], W.data[438u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[390u], W.data[406u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[358u], W.data[374u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[326u], W.data[342u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[294u], W.data[310u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[262u], W.data[278u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[230u], W.data[246u]), _2025)))))));
    vec2 _2052 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[486u], W.data[502u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[454u], W.data[470u]), _2046));
    vec2 _2079 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[199u], W.data[215u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[167u], W.data[183u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[135u], W.data[151u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[103u], W.data[119u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[71u], W.data[87u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[39u], W.data[55u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[7u], W.data[23u]), vec2(0.0))))))));
    vec2 _2100 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[423u], W.data[439u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[391u], W.data[407u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[359u], W.data[375u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[327u], W.data[343u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[295u], W.data[311u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[263u], W.data[279u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[231u], W.data[247u]), _2079)))))));
    vec2 _2106 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[487u], W.data[503u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[455u], W.data[471u]), _2100));
    vec2 _2133 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[200u], W.data[216u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[168u], W.data[184u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[136u], W.data[152u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[104u], W.data[120u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[72u], W.data[88u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[40u], W.data[56u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[8u], W.data[24u]), vec2(0.0))))))));
    vec2 _2154 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[424u], W.data[440u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[392u], W.data[408u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[360u], W.data[376u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[328u], W.data[344u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[296u], W.data[312u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[264u], W.data[280u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[232u], W.data[248u]), _2133)))))));
    vec2 _2160 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[488u], W.data[504u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[456u], W.data[472u]), _2154));
    vec2 _2187 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[201u], W.data[217u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[169u], W.data[185u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[137u], W.data[153u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[105u], W.data[121u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[73u], W.data[89u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[41u], W.data[57u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[9u], W.data[25u]), vec2(0.0))))))));
    vec2 _2208 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[425u], W.data[441u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[393u], W.data[409u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[361u], W.data[377u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[329u], W.data[345u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[297u], W.data[313u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[265u], W.data[281u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[233u], W.data[249u]), _2187)))))));
    vec2 _2214 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[489u], W.data[505u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[457u], W.data[473u]), _2208));
    vec2 _2241 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[202u], W.data[218u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[170u], W.data[186u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[138u], W.data[154u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[106u], W.data[122u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[74u], W.data[90u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[42u], W.data[58u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[10u], W.data[26u]), vec2(0.0))))))));
    vec2 _2262 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[426u], W.data[442u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[394u], W.data[410u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[362u], W.data[378u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[330u], W.data[346u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[298u], W.data[314u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[266u], W.data[282u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[234u], W.data[250u]), _2241)))))));
    vec2 _2268 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[490u], W.data[506u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[458u], W.data[474u]), _2262));
    vec2 _2295 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[203u], W.data[219u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[171u], W.data[187u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[139u], W.data[155u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[107u], W.data[123u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[75u], W.data[91u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[43u], W.data[59u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[11u], W.data[27u]), vec2(0.0))))))));
    vec2 _2316 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[427u], W.data[443u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[395u], W.data[411u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[363u], W.data[379u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[331u], W.data[347u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[299u], W.data[315u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[267u], W.data[283u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[235u], W.data[251u]), _2295)))))));
    vec2 _2322 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[491u], W.data[507u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[459u], W.data[475u]), _2316));
    vec2 _2349 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[204u], W.data[220u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[172u], W.data[188u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[140u], W.data[156u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[108u], W.data[124u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[76u], W.data[92u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[44u], W.data[60u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[12u], W.data[28u]), vec2(0.0))))))));
    vec2 _2370 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[428u], W.data[444u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[396u], W.data[412u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[364u], W.data[380u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[332u], W.data[348u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[300u], W.data[316u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[268u], W.data[284u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[236u], W.data[252u]), _2349)))))));
    vec2 _2376 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[492u], W.data[508u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[460u], W.data[476u]), _2370));
    vec2 _2403 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[205u], W.data[221u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[173u], W.data[189u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[141u], W.data[157u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[109u], W.data[125u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[77u], W.data[93u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[45u], W.data[61u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[13u], W.data[29u]), vec2(0.0))))))));
    vec2 _2424 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[429u], W.data[445u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[397u], W.data[413u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[365u], W.data[381u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[333u], W.data[349u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[301u], W.data[317u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[269u], W.data[285u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[237u], W.data[253u]), _2403)))))));
    vec2 _2430 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[493u], W.data[509u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[461u], W.data[477u]), _2424));
    vec2 _2457 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[206u], W.data[222u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[174u], W.data[190u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[142u], W.data[158u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[110u], W.data[126u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[78u], W.data[94u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[46u], W.data[62u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[14u], W.data[30u]), vec2(0.0))))))));
    vec2 _2478 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[430u], W.data[446u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[398u], W.data[414u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[366u], W.data[382u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[334u], W.data[350u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[302u], W.data[318u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[270u], W.data[286u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[238u], W.data[254u]), _2457)))))));
    vec2 _2484 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[494u], W.data[510u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[462u], W.data[478u]), _2478));
    vec2 _2511 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[207u], W.data[223u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[175u], W.data[191u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[143u], W.data[159u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[111u], W.data[127u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[79u], W.data[95u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[47u], W.data[63u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[15u], W.data[31u]), vec2(0.0))))))));
    vec2 _2532 = fma(vec2(X.data[26u], X.data[27u]), vec2(W.data[431u], W.data[447u]), fma(vec2(X.data[24u], X.data[25u]), vec2(W.data[399u], W.data[415u]), fma(vec2(X.data[22u], X.data[23u]), vec2(W.data[367u], W.data[383u]), fma(vec2(X.data[20u], X.data[21u]), vec2(W.data[335u], W.data[351u]), fma(vec2(X.data[18u], X.data[19u]), vec2(W.data[303u], W.data[319u]), fma(vec2(X.data[16u], X.data[17u]), vec2(W.data[271u], W.data[287u]), fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[239u], W.data[255u]), _2511)))))));
    vec2 _2538 = fma(vec2(X.data[30u], X.data[31u]), vec2(W.data[495u], W.data[511u]), fma(vec2(X.data[28u], X.data[29u]), vec2(W.data[463u], W.data[479u]), _2532));
    return vec2[](vec2((_1728.x + _1728.y) + _19[0].x, (_1782.x + _1782.y) + _19[0].y), vec2((_1836.x + _1836.y) + _19[1].x, (_1890.x + _1890.y) + _19[1].y), vec2((_1944.x + _1944.y) + _19[2].x, (_1998.x + _1998.y) + _19[2].y), vec2((_2052.x + _2052.y) + _19[3].x, (_2106.x + _2106.y) + _19[3].y), vec2((_2160.x + _2160.y) + _19[4].x, (_2214.x + _2214.y) + _19[4].y), vec2((_2268.x + _2268.y) + _19[5].x, (_2322.x + _2322.y) + _19[5].y), vec2((_2376.x + _2376.y) + _19[6].x, (_2430.x + _2430.y) + _19[6].y), vec2((_2484.x + _2484.y) + _19[7].x, (_2538.x + _2538.y) + _19[7].y));
}

void _2562(uint _2563, vec2 _2564)
{
    Y.data[_2563] = _2564.x;
    Y.data[_2563 + 1u] = _2564.y;
}

void main()
{
    vec2 _57[8] = _81();
    vec2 tempArg[8] = _57;
    vec2 y[8] = _57;
    vec2 _2576[8] = _57;
    uint _2577 = 0u;
    uint _2582;
    for (;;)
    {
        _2582 = _2577;
        if (_2582 < 16u)
        {
            _2562(0u + _2582, _2576[_2582 / 2u]);
            _2577 = _2582 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

