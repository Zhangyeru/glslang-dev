#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec2 _59[16] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
const vec2 _64[16] = vec2[](vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0));
const vec2 _73[8] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
const vec2 _77[8] = vec2[](vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0));

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float data[];
} W;

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float data[];
} Bias;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

vec2 _2595(uint _2596)
{
    return vec2(X.data[_2596], X.data[_2596 + 1u]);
}

vec2 _2623(uint _2624)
{
    return vec2(Bias.data[_2624], Bias.data[_2624 + 1u]);
}

vec2[8] _118(vec2 _119[16], vec2 _120[8])
{
    vec2 _1739 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[192u], W.data[208u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[160u], W.data[176u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[128u], W.data[144u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[96u], W.data[112u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[64u], W.data[80u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[32u], W.data[48u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[0u], W.data[16u]), vec2(0.0))))))));
    vec2 _1760 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[416u], W.data[432u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[384u], W.data[400u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[352u], W.data[368u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[320u], W.data[336u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[288u], W.data[304u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[256u], W.data[272u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[224u], W.data[240u]), _1739)))))));
    vec2 _1766 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[480u], W.data[496u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[448u], W.data[464u]), _1760));
    vec2 _1793 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[193u], W.data[209u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[161u], W.data[177u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[129u], W.data[145u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[97u], W.data[113u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[65u], W.data[81u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[33u], W.data[49u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[1u], W.data[17u]), vec2(0.0))))))));
    vec2 _1814 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[417u], W.data[433u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[385u], W.data[401u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[353u], W.data[369u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[321u], W.data[337u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[289u], W.data[305u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[257u], W.data[273u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[225u], W.data[241u]), _1793)))))));
    vec2 _1820 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[481u], W.data[497u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[449u], W.data[465u]), _1814));
    vec2 _1847 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[194u], W.data[210u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[162u], W.data[178u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[130u], W.data[146u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[98u], W.data[114u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[66u], W.data[82u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[34u], W.data[50u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[2u], W.data[18u]), vec2(0.0))))))));
    vec2 _1868 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[418u], W.data[434u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[386u], W.data[402u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[354u], W.data[370u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[322u], W.data[338u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[290u], W.data[306u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[258u], W.data[274u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[226u], W.data[242u]), _1847)))))));
    vec2 _1874 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[482u], W.data[498u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[450u], W.data[466u]), _1868));
    vec2 _1901 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[195u], W.data[211u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[163u], W.data[179u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[131u], W.data[147u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[99u], W.data[115u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[67u], W.data[83u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[35u], W.data[51u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[3u], W.data[19u]), vec2(0.0))))))));
    vec2 _1922 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[419u], W.data[435u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[387u], W.data[403u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[355u], W.data[371u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[323u], W.data[339u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[291u], W.data[307u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[259u], W.data[275u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[227u], W.data[243u]), _1901)))))));
    vec2 _1928 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[483u], W.data[499u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[451u], W.data[467u]), _1922));
    vec2 _1955 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[196u], W.data[212u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[164u], W.data[180u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[132u], W.data[148u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[100u], W.data[116u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[68u], W.data[84u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[36u], W.data[52u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[4u], W.data[20u]), vec2(0.0))))))));
    vec2 _1976 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[420u], W.data[436u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[388u], W.data[404u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[356u], W.data[372u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[324u], W.data[340u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[292u], W.data[308u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[260u], W.data[276u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[228u], W.data[244u]), _1955)))))));
    vec2 _1982 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[484u], W.data[500u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[452u], W.data[468u]), _1976));
    vec2 _2009 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[197u], W.data[213u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[165u], W.data[181u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[133u], W.data[149u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[101u], W.data[117u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[69u], W.data[85u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[37u], W.data[53u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[5u], W.data[21u]), vec2(0.0))))))));
    vec2 _2030 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[421u], W.data[437u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[389u], W.data[405u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[357u], W.data[373u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[325u], W.data[341u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[293u], W.data[309u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[261u], W.data[277u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[229u], W.data[245u]), _2009)))))));
    vec2 _2036 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[485u], W.data[501u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[453u], W.data[469u]), _2030));
    vec2 _2063 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[198u], W.data[214u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[166u], W.data[182u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[134u], W.data[150u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[102u], W.data[118u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[70u], W.data[86u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[38u], W.data[54u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[6u], W.data[22u]), vec2(0.0))))))));
    vec2 _2084 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[422u], W.data[438u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[390u], W.data[406u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[358u], W.data[374u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[326u], W.data[342u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[294u], W.data[310u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[262u], W.data[278u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[230u], W.data[246u]), _2063)))))));
    vec2 _2090 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[486u], W.data[502u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[454u], W.data[470u]), _2084));
    vec2 _2117 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[199u], W.data[215u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[167u], W.data[183u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[135u], W.data[151u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[103u], W.data[119u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[71u], W.data[87u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[39u], W.data[55u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[7u], W.data[23u]), vec2(0.0))))))));
    vec2 _2138 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[423u], W.data[439u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[391u], W.data[407u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[359u], W.data[375u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[327u], W.data[343u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[295u], W.data[311u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[263u], W.data[279u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[231u], W.data[247u]), _2117)))))));
    vec2 _2144 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[487u], W.data[503u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[455u], W.data[471u]), _2138));
    vec2 _2171 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[200u], W.data[216u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[168u], W.data[184u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[136u], W.data[152u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[104u], W.data[120u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[72u], W.data[88u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[40u], W.data[56u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[8u], W.data[24u]), vec2(0.0))))))));
    vec2 _2192 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[424u], W.data[440u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[392u], W.data[408u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[360u], W.data[376u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[328u], W.data[344u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[296u], W.data[312u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[264u], W.data[280u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[232u], W.data[248u]), _2171)))))));
    vec2 _2198 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[488u], W.data[504u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[456u], W.data[472u]), _2192));
    vec2 _2225 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[201u], W.data[217u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[169u], W.data[185u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[137u], W.data[153u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[105u], W.data[121u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[73u], W.data[89u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[41u], W.data[57u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[9u], W.data[25u]), vec2(0.0))))))));
    vec2 _2246 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[425u], W.data[441u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[393u], W.data[409u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[361u], W.data[377u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[329u], W.data[345u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[297u], W.data[313u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[265u], W.data[281u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[233u], W.data[249u]), _2225)))))));
    vec2 _2252 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[489u], W.data[505u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[457u], W.data[473u]), _2246));
    vec2 _2279 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[202u], W.data[218u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[170u], W.data[186u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[138u], W.data[154u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[106u], W.data[122u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[74u], W.data[90u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[42u], W.data[58u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[10u], W.data[26u]), vec2(0.0))))))));
    vec2 _2300 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[426u], W.data[442u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[394u], W.data[410u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[362u], W.data[378u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[330u], W.data[346u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[298u], W.data[314u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[266u], W.data[282u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[234u], W.data[250u]), _2279)))))));
    vec2 _2306 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[490u], W.data[506u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[458u], W.data[474u]), _2300));
    vec2 _2333 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[203u], W.data[219u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[171u], W.data[187u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[139u], W.data[155u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[107u], W.data[123u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[75u], W.data[91u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[43u], W.data[59u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[11u], W.data[27u]), vec2(0.0))))))));
    vec2 _2354 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[427u], W.data[443u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[395u], W.data[411u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[363u], W.data[379u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[331u], W.data[347u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[299u], W.data[315u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[267u], W.data[283u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[235u], W.data[251u]), _2333)))))));
    vec2 _2360 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[491u], W.data[507u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[459u], W.data[475u]), _2354));
    vec2 _2387 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[204u], W.data[220u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[172u], W.data[188u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[140u], W.data[156u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[108u], W.data[124u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[76u], W.data[92u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[44u], W.data[60u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[12u], W.data[28u]), vec2(0.0))))))));
    vec2 _2408 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[428u], W.data[444u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[396u], W.data[412u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[364u], W.data[380u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[332u], W.data[348u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[300u], W.data[316u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[268u], W.data[284u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[236u], W.data[252u]), _2387)))))));
    vec2 _2414 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[492u], W.data[508u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[460u], W.data[476u]), _2408));
    vec2 _2441 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[205u], W.data[221u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[173u], W.data[189u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[141u], W.data[157u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[109u], W.data[125u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[77u], W.data[93u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[45u], W.data[61u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[13u], W.data[29u]), vec2(0.0))))))));
    vec2 _2462 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[429u], W.data[445u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[397u], W.data[413u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[365u], W.data[381u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[333u], W.data[349u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[301u], W.data[317u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[269u], W.data[285u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[237u], W.data[253u]), _2441)))))));
    vec2 _2468 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[493u], W.data[509u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[461u], W.data[477u]), _2462));
    vec2 _2495 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[206u], W.data[222u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[174u], W.data[190u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[142u], W.data[158u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[110u], W.data[126u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[78u], W.data[94u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[46u], W.data[62u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[14u], W.data[30u]), vec2(0.0))))))));
    vec2 _2516 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[430u], W.data[446u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[398u], W.data[414u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[366u], W.data[382u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[334u], W.data[350u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[302u], W.data[318u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[270u], W.data[286u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[238u], W.data[254u]), _2495)))))));
    vec2 _2522 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[494u], W.data[510u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[462u], W.data[478u]), _2516));
    vec2 _2549 = fma(vec2(_119[6].x, _119[6].y), vec2(W.data[207u], W.data[223u]), fma(vec2(_119[5].x, _119[5].y), vec2(W.data[175u], W.data[191u]), fma(vec2(_119[4].x, _119[4].y), vec2(W.data[143u], W.data[159u]), fma(vec2(_119[3].x, _119[3].y), vec2(W.data[111u], W.data[127u]), fma(vec2(_119[2].x, _119[2].y), vec2(W.data[79u], W.data[95u]), fma(vec2(_119[1].x, _119[1].y), vec2(W.data[47u], W.data[63u]), fma(vec2(_119[0].x, _119[0].y), vec2(W.data[15u], W.data[31u]), vec2(0.0))))))));
    vec2 _2570 = fma(vec2(_119[13].x, _119[13].y), vec2(W.data[431u], W.data[447u]), fma(vec2(_119[12].x, _119[12].y), vec2(W.data[399u], W.data[415u]), fma(vec2(_119[11].x, _119[11].y), vec2(W.data[367u], W.data[383u]), fma(vec2(_119[10].x, _119[10].y), vec2(W.data[335u], W.data[351u]), fma(vec2(_119[9].x, _119[9].y), vec2(W.data[303u], W.data[319u]), fma(vec2(_119[8].x, _119[8].y), vec2(W.data[271u], W.data[287u]), fma(vec2(_119[7].x, _119[7].y), vec2(W.data[239u], W.data[255u]), _2549)))))));
    vec2 _2576 = fma(vec2(_119[15].x, _119[15].y), vec2(W.data[495u], W.data[511u]), fma(vec2(_119[14].x, _119[14].y), vec2(W.data[463u], W.data[479u]), _2570));
    return vec2[](vec2((_1766.x + _1766.y) + _120[0].x, (_1820.x + _1820.y) + _120[0].y), vec2((_1874.x + _1874.y) + _120[1].x, (_1928.x + _1928.y) + _120[1].y), vec2((_1982.x + _1982.y) + _120[2].x, (_2036.x + _2036.y) + _120[2].y), vec2((_2090.x + _2090.y) + _120[3].x, (_2144.x + _2144.y) + _120[3].y), vec2((_2198.x + _2198.y) + _120[4].x, (_2252.x + _2252.y) + _120[4].y), vec2((_2306.x + _2306.y) + _120[5].x, (_2360.x + _2360.y) + _120[5].y), vec2((_2414.x + _2414.y) + _120[6].x, (_2468.x + _2468.y) + _120[6].y), vec2((_2522.x + _2522.y) + _120[7].x, (_2576.x + _2576.y) + _120[7].y));
}

void _2983(uint _2984, vec2 _2985)
{
    Y.data[_2984] = _2985.x;
    Y.data[_2984 + 1u] = _2985.y;
}

void main()
{
    uint _2610 = 0u;
    vec2 _2609[16];
    uint _2615;
    for (;;)
    {
        _2615 = _2610;
        if (_2615 < 32u)
        {
            _2609[_2615 / 2u] = _2595(0u + _2615);
            _2610 = _2615 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _21[16] = _2609;
    vec2 tempArg[16] = _21;
    vec2 x[16] = _21;
    uint _2635 = 0u;
    vec2 _2634[8];
    uint _2640;
    for (;;)
    {
        _2640 = _2635;
        if (_2640 < 16u)
        {
            _2634[_2640 / 2u] = _2623(0u + _2640);
            _2635 = _2640 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _51[8] = _2634;
    vec2 tempArg_1[8] = _51;
    vec2 bias[8] = _51;
    vec2 _2651[16] = _21;
    uint _2650 = 0u;
    vec2 _2649[16];
    uint _2656;
    for (;;)
    {
        _2656 = _2650;
        if (_2656 < 16u)
        {
            _2649[_2656] = -_2651[_2656];
            _2650 = _2656 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _2665[16] = _2649;
    uint _2664 = 0u;
    vec2 _2663[16];
    uint _2670;
    for (;;)
    {
        _2670 = _2664;
        if (_2670 < 16u)
        {
            _2663[_2670] = -_2665[_2670];
            _2664 = _2670 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _2663;
    vec2 _2679[16] = _2663;
    uint _2678 = 0u;
    vec2 _2677[16];
    uint _2685;
    for (;;)
    {
        _2685 = _2678;
        if (_2685 < 16u)
        {
            _2677[_2685] = _2679[_2685] + _59[_2685];
            _2678 = _2685 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _2696[16] = _2677;
    uint _2695 = 0u;
    vec2 _2694[16];
    uint _2702;
    for (;;)
    {
        _2702 = _2695;
        if (_2702 < 16u)
        {
            _2694[_2702] = _2696[_2702] - _59[_2702];
            _2695 = _2702 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _2694;
    vec2 _2713[16] = _2694;
    uint _2712 = 0u;
    vec2 _2711[16];
    uint _2719;
    for (;;)
    {
        _2719 = _2712;
        if (_2719 < 16u)
        {
            _2711[_2719] = _2713[_2719] * _64[_2719];
            _2712 = _2719 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _2730[16] = _2711;
    uint _2729 = 0u;
    vec2 _2728[16];
    uint _2736;
    for (;;)
    {
        _2736 = _2729;
        if (_2736 < 16u)
        {
            _2728[_2736] = _2730[_2736] / _64[_2736];
            _2729 = _2736 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _2728;
    vec2 _2747[16] = _2728;
    uint _2746 = 0u;
    vec2 _2745[16];
    uint _2752;
    for (;;)
    {
        _2752 = _2746;
        if (_2752 < 16u)
        {
            _2745[_2752] = _2747[_2752] * vec2(1.0);
            _2746 = _2752 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _2745;
    vec2 _2762[8] = _51;
    uint _2761 = 0u;
    vec2 _2760[8];
    uint _2767;
    for (;;)
    {
        _2767 = _2761;
        if (_2767 < 8u)
        {
            _2760[_2767] = -_2762[_2767];
            _2761 = _2767 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _2776[8] = _2760;
    uint _2775 = 0u;
    vec2 _2774[8];
    uint _2781;
    for (;;)
    {
        _2781 = _2775;
        if (_2781 < 8u)
        {
            _2774[_2781] = -_2776[_2781];
            _2775 = _2781 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _2774;
    vec2 _2790[8] = _2774;
    uint _2789 = 0u;
    vec2 _2788[8];
    uint _2796;
    for (;;)
    {
        _2796 = _2789;
        if (_2796 < 8u)
        {
            _2788[_2796] = _2790[_2796] + _73[_2796];
            _2789 = _2796 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _2807[8] = _2788;
    uint _2806 = 0u;
    vec2 _2805[8];
    uint _2813;
    for (;;)
    {
        _2813 = _2806;
        if (_2813 < 8u)
        {
            _2805[_2813] = _2807[_2813] - _73[_2813];
            _2806 = _2813 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _2805;
    vec2 _2824[8] = _2805;
    uint _2823 = 0u;
    vec2 _2822[8];
    uint _2830;
    for (;;)
    {
        _2830 = _2823;
        if (_2830 < 8u)
        {
            _2822[_2830] = _2824[_2830] * _77[_2830];
            _2823 = _2830 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _2841[8] = _2822;
    uint _2840 = 0u;
    vec2 _2839[8];
    uint _2847;
    for (;;)
    {
        _2847 = _2840;
        if (_2847 < 8u)
        {
            _2839[_2847] = _2841[_2847] / _77[_2847];
            _2840 = _2847 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _2839;
    vec2 _2858[8] = _2839;
    uint _2857 = 0u;
    vec2 _2856[8];
    uint _2863;
    for (;;)
    {
        _2863 = _2857;
        if (_2863 < 8u)
        {
            _2856[_2863] = _2858[_2863] * vec2(1.0);
            _2857 = _2863 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _2856;
    vec2 _86[8] = _118(_2745, _2856);
    vec2 tempArg_2[8] = _86;
    vec2 y[8] = _86;
    vec2 _2873[8] = _86;
    uint _2872 = 0u;
    vec2 _2871[8];
    uint _2878;
    for (;;)
    {
        _2878 = _2872;
        if (_2878 < 8u)
        {
            _2871[_2878] = -_2873[_2878];
            _2872 = _2878 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _2887[8] = _2871;
    uint _2886 = 0u;
    vec2 _2885[8];
    uint _2892;
    for (;;)
    {
        _2892 = _2886;
        if (_2892 < 8u)
        {
            _2885[_2892] = -_2887[_2892];
            _2886 = _2892 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _2885;
    vec2 _2901[8] = _2885;
    uint _2900 = 0u;
    vec2 _2899[8];
    uint _2907;
    for (;;)
    {
        _2907 = _2900;
        if (_2907 < 8u)
        {
            _2899[_2907] = _2901[_2907] + _73[_2907];
            _2900 = _2907 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _2918[8] = _2899;
    uint _2917 = 0u;
    vec2 _2916[8];
    uint _2924;
    for (;;)
    {
        _2924 = _2917;
        if (_2924 < 8u)
        {
            _2916[_2924] = _2918[_2924] - _73[_2924];
            _2917 = _2924 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _2916;
    vec2 _2935[8] = _2916;
    uint _2934 = 0u;
    vec2 _2933[8];
    uint _2941;
    for (;;)
    {
        _2941 = _2934;
        if (_2941 < 8u)
        {
            _2933[_2941] = _2935[_2941] * _77[_2941];
            _2934 = _2941 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _2952[8] = _2933;
    uint _2951 = 0u;
    vec2 _2950[8];
    uint _2958;
    for (;;)
    {
        _2958 = _2951;
        if (_2958 < 8u)
        {
            _2950[_2958] = _2952[_2958] / _77[_2958];
            _2951 = _2958 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _2950;
    vec2 _2969[8] = _2950;
    uint _2968 = 0u;
    vec2 _2967[8];
    uint _2974;
    for (;;)
    {
        _2974 = _2968;
        if (_2974 < 8u)
        {
            _2967[_2974] = _2969[_2974] * vec2(1.0);
            _2968 = _2974 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _2967;
    vec2 _2993[8] = _2967;
    uint _2994 = 0u;
    uint _2999;
    for (;;)
    {
        _2999 = _2994;
        if (_2999 < 16u)
        {
            _2983(0u + _2999, _2993[_2999 / 2u]);
            _2994 = _2999 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

