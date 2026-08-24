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

const f16vec2 _72[4] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const f16vec2 _176[2] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[48];
} InX;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[64];
    float16_t w2[384];
    float16_t w3[384];
    float16_t w4[384];
    float16_t w5[192];
} Weights;

layout(set = 0, binding = 2, std430) buffer PackedBias
{
    float16_t b1[8];
    float16_t b2[48];
    float16_t b3[8];
    float16_t b4[48];
    float16_t b5[4];
} Biases;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[4];
} OutY;

f16vec2[4] _5902()
{
    f16vec2 _6071 = f16vec2(InX.x[0u]);
    f16vec2 _6080 = f16vec2(InX.x[1u]);
    f16vec2 _6089 = f16vec2(InX.x[2u]);
    f16vec2 _6098 = f16vec2(InX.x[3u]);
    f16vec2 _6107 = f16vec2(InX.x[4u]);
    f16vec2 _6116 = f16vec2(InX.x[5u]);
    f16vec2 _6125 = f16vec2(InX.x[6u]);
    f16vec2 _6134 = f16vec2(InX.x[7u]);
    return f16vec2[](fma(_6134, f16vec2(Weights.w1[56u], Weights.w1[57u]), fma(_6125, f16vec2(Weights.w1[48u], Weights.w1[49u]), fma(_6116, f16vec2(Weights.w1[40u], Weights.w1[41u]), fma(_6107, f16vec2(Weights.w1[32u], Weights.w1[33u]), fma(_6098, f16vec2(Weights.w1[24u], Weights.w1[25u]), fma(_6089, f16vec2(Weights.w1[16u], Weights.w1[17u]), fma(_6080, f16vec2(Weights.w1[8u], Weights.w1[9u]), fma(_6071, f16vec2(Weights.w1[0u], Weights.w1[1u]), f16vec2(Biases.b1[0u], Biases.b1[1u]))))))))), fma(_6134, f16vec2(Weights.w1[58u], Weights.w1[59u]), fma(_6125, f16vec2(Weights.w1[50u], Weights.w1[51u]), fma(_6116, f16vec2(Weights.w1[42u], Weights.w1[43u]), fma(_6107, f16vec2(Weights.w1[34u], Weights.w1[35u]), fma(_6098, f16vec2(Weights.w1[26u], Weights.w1[27u]), fma(_6089, f16vec2(Weights.w1[18u], Weights.w1[19u]), fma(_6080, f16vec2(Weights.w1[10u], Weights.w1[11u]), fma(_6071, f16vec2(Weights.w1[2u], Weights.w1[3u]), f16vec2(Biases.b1[2u], Biases.b1[3u]))))))))), fma(_6134, f16vec2(Weights.w1[60u], Weights.w1[61u]), fma(_6125, f16vec2(Weights.w1[52u], Weights.w1[53u]), fma(_6116, f16vec2(Weights.w1[44u], Weights.w1[45u]), fma(_6107, f16vec2(Weights.w1[36u], Weights.w1[37u]), fma(_6098, f16vec2(Weights.w1[28u], Weights.w1[29u]), fma(_6089, f16vec2(Weights.w1[20u], Weights.w1[21u]), fma(_6080, f16vec2(Weights.w1[12u], Weights.w1[13u]), fma(_6071, f16vec2(Weights.w1[4u], Weights.w1[5u]), f16vec2(Biases.b1[4u], Biases.b1[5u]))))))))), fma(_6134, f16vec2(Weights.w1[62u], Weights.w1[63u]), fma(_6125, f16vec2(Weights.w1[54u], Weights.w1[55u]), fma(_6116, f16vec2(Weights.w1[46u], Weights.w1[47u]), fma(_6107, f16vec2(Weights.w1[38u], Weights.w1[39u]), fma(_6098, f16vec2(Weights.w1[30u], Weights.w1[31u]), fma(_6089, f16vec2(Weights.w1[22u], Weights.w1[23u]), fma(_6080, f16vec2(Weights.w1[14u], Weights.w1[15u]), fma(_6071, f16vec2(Weights.w1[6u], Weights.w1[7u]), f16vec2(Biases.b1[6u], Biases.b1[7u]))))))))));
}

void _6209(uint _6210, f16vec2 _6211)
{
    OutY.y[_6210] = _6211.x;
    OutY.y[_6210 + 1u] = _6211.y;
}

void main()
{
    f16vec2 _67[4] = _5902();
    f16vec2 tempArg[4] = _67;
    f16vec2 h1[4] = _67;
    f16vec2 _6152[4] = _67;
    uint _6151 = 0u;
    f16vec2 _6150[4];
    uint _6158;
    for (;;)
    {
        _6158 = _6151;
        if (_6158 < 4u)
        {
            _6150[_6158] = max(_6152[_6158], _72[_6158]);
            _6151 = _6158 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    h1 = _6150;
    f16vec2 _297 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[336u], Weights.w2[337u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[288u], Weights.w2[289u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[240u], Weights.w2[241u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[192u], Weights.w2[193u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[144u], Weights.w2[145u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[96u], Weights.w2[97u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[48u], Weights.w2[49u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[0u], Weights.w2[1u]), f16vec2(Biases.b2[0u], Biases.b2[1u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _300 = f16vec2(_297.x);
    f16vec2 _301 = f16vec2(_297.y);
    f16vec2 _440 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[338u], Weights.w2[339u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[290u], Weights.w2[291u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[242u], Weights.w2[243u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[194u], Weights.w2[195u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[146u], Weights.w2[147u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[98u], Weights.w2[99u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[50u], Weights.w2[51u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[2u], Weights.w2[3u]), f16vec2(Biases.b2[2u], Biases.b2[3u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _443 = f16vec2(_440.x);
    f16vec2 _444 = f16vec2(_440.y);
    f16vec2 _592 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[340u], Weights.w2[341u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[292u], Weights.w2[293u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[244u], Weights.w2[245u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[196u], Weights.w2[197u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[148u], Weights.w2[149u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[100u], Weights.w2[101u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[52u], Weights.w2[53u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[4u], Weights.w2[5u]), f16vec2(Biases.b2[4u], Biases.b2[5u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _595 = f16vec2(_592.x);
    f16vec2 _596 = f16vec2(_592.y);
    f16vec2 _744 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[342u], Weights.w2[343u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[294u], Weights.w2[295u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[246u], Weights.w2[247u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[198u], Weights.w2[199u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[150u], Weights.w2[151u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[102u], Weights.w2[103u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[54u], Weights.w2[55u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[6u], Weights.w2[7u]), f16vec2(Biases.b2[6u], Biases.b2[7u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _747 = f16vec2(_744.x);
    f16vec2 _748 = f16vec2(_744.y);
    f16vec2 _886 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[344u], Weights.w2[345u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[296u], Weights.w2[297u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[248u], Weights.w2[249u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[200u], Weights.w2[201u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[152u], Weights.w2[153u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[104u], Weights.w2[105u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[56u], Weights.w2[57u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[8u], Weights.w2[9u]), f16vec2(Biases.b2[8u], Biases.b2[9u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _889 = f16vec2(_886.x);
    f16vec2 _890 = f16vec2(_886.y);
    f16vec2 _905 = fma(_890, f16vec2(Weights.w3[72u], Weights.w3[73u]), fma(_889, f16vec2(Weights.w3[64u], Weights.w3[65u]), fma(_748, f16vec2(Weights.w3[56u], Weights.w3[57u]), fma(_747, f16vec2(Weights.w3[48u], Weights.w3[49u]), fma(_596, f16vec2(Weights.w3[40u], Weights.w3[41u]), fma(_595, f16vec2(Weights.w3[32u], Weights.w3[33u]), fma(_444, f16vec2(Weights.w3[24u], Weights.w3[25u]), fma(_443, f16vec2(Weights.w3[16u], Weights.w3[17u]), fma(_301, f16vec2(Weights.w3[8u], Weights.w3[9u]), fma(_300, f16vec2(Weights.w3[0u], Weights.w3[1u]), f16vec2(Biases.b3[0u], Biases.b3[1u])))))))))));
    f16vec2 _921 = fma(_890, f16vec2(Weights.w3[74u], Weights.w3[75u]), fma(_889, f16vec2(Weights.w3[66u], Weights.w3[67u]), fma(_748, f16vec2(Weights.w3[58u], Weights.w3[59u]), fma(_747, f16vec2(Weights.w3[50u], Weights.w3[51u]), fma(_596, f16vec2(Weights.w3[42u], Weights.w3[43u]), fma(_595, f16vec2(Weights.w3[34u], Weights.w3[35u]), fma(_444, f16vec2(Weights.w3[26u], Weights.w3[27u]), fma(_443, f16vec2(Weights.w3[18u], Weights.w3[19u]), fma(_301, f16vec2(Weights.w3[10u], Weights.w3[11u]), fma(_300, f16vec2(Weights.w3[2u], Weights.w3[3u]), f16vec2(Biases.b3[2u], Biases.b3[3u])))))))))));
    f16vec2 _937 = fma(_890, f16vec2(Weights.w3[76u], Weights.w3[77u]), fma(_889, f16vec2(Weights.w3[68u], Weights.w3[69u]), fma(_748, f16vec2(Weights.w3[60u], Weights.w3[61u]), fma(_747, f16vec2(Weights.w3[52u], Weights.w3[53u]), fma(_596, f16vec2(Weights.w3[44u], Weights.w3[45u]), fma(_595, f16vec2(Weights.w3[36u], Weights.w3[37u]), fma(_444, f16vec2(Weights.w3[28u], Weights.w3[29u]), fma(_443, f16vec2(Weights.w3[20u], Weights.w3[21u]), fma(_301, f16vec2(Weights.w3[12u], Weights.w3[13u]), fma(_300, f16vec2(Weights.w3[4u], Weights.w3[5u]), f16vec2(Biases.b3[4u], Biases.b3[5u])))))))))));
    f16vec2 _953 = fma(_890, f16vec2(Weights.w3[78u], Weights.w3[79u]), fma(_889, f16vec2(Weights.w3[70u], Weights.w3[71u]), fma(_748, f16vec2(Weights.w3[62u], Weights.w3[63u]), fma(_747, f16vec2(Weights.w3[54u], Weights.w3[55u]), fma(_596, f16vec2(Weights.w3[46u], Weights.w3[47u]), fma(_595, f16vec2(Weights.w3[38u], Weights.w3[39u]), fma(_444, f16vec2(Weights.w3[30u], Weights.w3[31u]), fma(_443, f16vec2(Weights.w3[22u], Weights.w3[23u]), fma(_301, f16vec2(Weights.w3[14u], Weights.w3[15u]), fma(_300, f16vec2(Weights.w3[6u], Weights.w3[7u]), f16vec2(Biases.b3[6u], Biases.b3[7u])))))))))));
    f16vec2 _1035 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[346u], Weights.w2[347u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[298u], Weights.w2[299u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[250u], Weights.w2[251u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[202u], Weights.w2[203u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[154u], Weights.w2[155u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[106u], Weights.w2[107u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[58u], Weights.w2[59u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[10u], Weights.w2[11u]), f16vec2(Biases.b2[10u], Biases.b2[11u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1038 = f16vec2(_1035.x);
    f16vec2 _1039 = f16vec2(_1035.y);
    f16vec2 _1185 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[348u], Weights.w2[349u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[300u], Weights.w2[301u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[252u], Weights.w2[253u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[204u], Weights.w2[205u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[156u], Weights.w2[157u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[108u], Weights.w2[109u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[60u], Weights.w2[61u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[12u], Weights.w2[13u]), f16vec2(Biases.b2[12u], Biases.b2[13u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1188 = f16vec2(_1185.x);
    f16vec2 _1189 = f16vec2(_1185.y);
    f16vec2 _1319 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[350u], Weights.w2[351u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[302u], Weights.w2[303u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[254u], Weights.w2[255u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[206u], Weights.w2[207u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[158u], Weights.w2[159u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[110u], Weights.w2[111u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[62u], Weights.w2[63u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[14u], Weights.w2[15u]), f16vec2(Biases.b2[14u], Biases.b2[15u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1322 = f16vec2(_1319.x);
    f16vec2 _1323 = f16vec2(_1319.y);
    f16vec2 _1467 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[352u], Weights.w2[353u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[304u], Weights.w2[305u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[256u], Weights.w2[257u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[208u], Weights.w2[209u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[160u], Weights.w2[161u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[112u], Weights.w2[113u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[64u], Weights.w2[65u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[16u], Weights.w2[17u]), f16vec2(Biases.b2[16u], Biases.b2[17u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1470 = f16vec2(_1467.x);
    f16vec2 _1471 = f16vec2(_1467.y);
    f16vec2 _1615 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[354u], Weights.w2[355u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[306u], Weights.w2[307u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[258u], Weights.w2[259u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[210u], Weights.w2[211u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[162u], Weights.w2[163u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[114u], Weights.w2[115u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[66u], Weights.w2[67u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[18u], Weights.w2[19u]), f16vec2(Biases.b2[18u], Biases.b2[19u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1618 = f16vec2(_1615.x);
    f16vec2 _1619 = f16vec2(_1615.y);
    f16vec2 _1631 = fma(_1619, f16vec2(Weights.w3[152u], Weights.w3[153u]), fma(_1618, f16vec2(Weights.w3[144u], Weights.w3[145u]), fma(_1471, f16vec2(Weights.w3[136u], Weights.w3[137u]), fma(_1470, f16vec2(Weights.w3[128u], Weights.w3[129u]), fma(_1323, f16vec2(Weights.w3[120u], Weights.w3[121u]), fma(_1322, f16vec2(Weights.w3[112u], Weights.w3[113u]), fma(_1189, f16vec2(Weights.w3[104u], Weights.w3[105u]), fma(_1188, f16vec2(Weights.w3[96u], Weights.w3[97u]), fma(_1039, f16vec2(Weights.w3[88u], Weights.w3[89u]), fma(_1038, f16vec2(Weights.w3[80u], Weights.w3[81u]), _905))))))))));
    f16vec2 _1643 = fma(_1619, f16vec2(Weights.w3[154u], Weights.w3[155u]), fma(_1618, f16vec2(Weights.w3[146u], Weights.w3[147u]), fma(_1471, f16vec2(Weights.w3[138u], Weights.w3[139u]), fma(_1470, f16vec2(Weights.w3[130u], Weights.w3[131u]), fma(_1323, f16vec2(Weights.w3[122u], Weights.w3[123u]), fma(_1322, f16vec2(Weights.w3[114u], Weights.w3[115u]), fma(_1189, f16vec2(Weights.w3[106u], Weights.w3[107u]), fma(_1188, f16vec2(Weights.w3[98u], Weights.w3[99u]), fma(_1039, f16vec2(Weights.w3[90u], Weights.w3[91u]), fma(_1038, f16vec2(Weights.w3[82u], Weights.w3[83u]), _921))))))))));
    f16vec2 _1655 = fma(_1619, f16vec2(Weights.w3[156u], Weights.w3[157u]), fma(_1618, f16vec2(Weights.w3[148u], Weights.w3[149u]), fma(_1471, f16vec2(Weights.w3[140u], Weights.w3[141u]), fma(_1470, f16vec2(Weights.w3[132u], Weights.w3[133u]), fma(_1323, f16vec2(Weights.w3[124u], Weights.w3[125u]), fma(_1322, f16vec2(Weights.w3[116u], Weights.w3[117u]), fma(_1189, f16vec2(Weights.w3[108u], Weights.w3[109u]), fma(_1188, f16vec2(Weights.w3[100u], Weights.w3[101u]), fma(_1039, f16vec2(Weights.w3[92u], Weights.w3[93u]), fma(_1038, f16vec2(Weights.w3[84u], Weights.w3[85u]), _937))))))))));
    f16vec2 _1667 = fma(_1619, f16vec2(Weights.w3[158u], Weights.w3[159u]), fma(_1618, f16vec2(Weights.w3[150u], Weights.w3[151u]), fma(_1471, f16vec2(Weights.w3[142u], Weights.w3[143u]), fma(_1470, f16vec2(Weights.w3[134u], Weights.w3[135u]), fma(_1323, f16vec2(Weights.w3[126u], Weights.w3[127u]), fma(_1322, f16vec2(Weights.w3[118u], Weights.w3[119u]), fma(_1189, f16vec2(Weights.w3[110u], Weights.w3[111u]), fma(_1188, f16vec2(Weights.w3[102u], Weights.w3[103u]), fma(_1039, f16vec2(Weights.w3[94u], Weights.w3[95u]), fma(_1038, f16vec2(Weights.w3[86u], Weights.w3[87u]), _953))))))))));
    f16vec2 _1747 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[356u], Weights.w2[357u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[308u], Weights.w2[309u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[260u], Weights.w2[261u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[212u], Weights.w2[213u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[164u], Weights.w2[165u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[116u], Weights.w2[117u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[68u], Weights.w2[69u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[20u], Weights.w2[21u]), f16vec2(Biases.b2[20u], Biases.b2[21u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1750 = f16vec2(_1747.x);
    f16vec2 _1751 = f16vec2(_1747.y);
    f16vec2 _1887 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[358u], Weights.w2[359u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[310u], Weights.w2[311u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[262u], Weights.w2[263u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[214u], Weights.w2[215u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[166u], Weights.w2[167u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[118u], Weights.w2[119u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[70u], Weights.w2[71u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[22u], Weights.w2[23u]), f16vec2(Biases.b2[22u], Biases.b2[23u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1890 = f16vec2(_1887.x);
    f16vec2 _1891 = f16vec2(_1887.y);
    f16vec2 _2033 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[360u], Weights.w2[361u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[312u], Weights.w2[313u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[264u], Weights.w2[265u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[216u], Weights.w2[217u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[168u], Weights.w2[169u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[120u], Weights.w2[121u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[72u], Weights.w2[73u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[24u], Weights.w2[25u]), f16vec2(Biases.b2[24u], Biases.b2[25u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2036 = f16vec2(_2033.x);
    f16vec2 _2037 = f16vec2(_2033.y);
    f16vec2 _2163 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[362u], Weights.w2[363u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[314u], Weights.w2[315u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[266u], Weights.w2[267u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[218u], Weights.w2[219u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[170u], Weights.w2[171u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[122u], Weights.w2[123u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[74u], Weights.w2[75u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[26u], Weights.w2[27u]), f16vec2(Biases.b2[26u], Biases.b2[27u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2166 = f16vec2(_2163.x);
    f16vec2 _2167 = f16vec2(_2163.y);
    f16vec2 _2295 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[364u], Weights.w2[365u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[316u], Weights.w2[317u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[268u], Weights.w2[269u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[220u], Weights.w2[221u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[172u], Weights.w2[173u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[124u], Weights.w2[125u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[76u], Weights.w2[77u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[28u], Weights.w2[29u]), f16vec2(Biases.b2[28u], Biases.b2[29u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2298 = f16vec2(_2295.x);
    f16vec2 _2299 = f16vec2(_2295.y);
    f16vec2 _2315 = fma(_2299, f16vec2(Weights.w3[232u], Weights.w3[233u]), fma(_2298, f16vec2(Weights.w3[224u], Weights.w3[225u]), fma(_2167, f16vec2(Weights.w3[216u], Weights.w3[217u]), fma(_2166, f16vec2(Weights.w3[208u], Weights.w3[209u]), fma(_2037, f16vec2(Weights.w3[200u], Weights.w3[201u]), fma(_2036, f16vec2(Weights.w3[192u], Weights.w3[193u]), fma(_1891, f16vec2(Weights.w3[184u], Weights.w3[185u]), fma(_1890, f16vec2(Weights.w3[176u], Weights.w3[177u]), fma(_1751, f16vec2(Weights.w3[168u], Weights.w3[169u]), fma(_1750, f16vec2(Weights.w3[160u], Weights.w3[161u]), _1631))))))))));
    f16vec2 _2331 = fma(_2299, f16vec2(Weights.w3[234u], Weights.w3[235u]), fma(_2298, f16vec2(Weights.w3[226u], Weights.w3[227u]), fma(_2167, f16vec2(Weights.w3[218u], Weights.w3[219u]), fma(_2166, f16vec2(Weights.w3[210u], Weights.w3[211u]), fma(_2037, f16vec2(Weights.w3[202u], Weights.w3[203u]), fma(_2036, f16vec2(Weights.w3[194u], Weights.w3[195u]), fma(_1891, f16vec2(Weights.w3[186u], Weights.w3[187u]), fma(_1890, f16vec2(Weights.w3[178u], Weights.w3[179u]), fma(_1751, f16vec2(Weights.w3[170u], Weights.w3[171u]), fma(_1750, f16vec2(Weights.w3[162u], Weights.w3[163u]), _1643))))))))));
    f16vec2 _2347 = fma(_2299, f16vec2(Weights.w3[236u], Weights.w3[237u]), fma(_2298, f16vec2(Weights.w3[228u], Weights.w3[229u]), fma(_2167, f16vec2(Weights.w3[220u], Weights.w3[221u]), fma(_2166, f16vec2(Weights.w3[212u], Weights.w3[213u]), fma(_2037, f16vec2(Weights.w3[204u], Weights.w3[205u]), fma(_2036, f16vec2(Weights.w3[196u], Weights.w3[197u]), fma(_1891, f16vec2(Weights.w3[188u], Weights.w3[189u]), fma(_1890, f16vec2(Weights.w3[180u], Weights.w3[181u]), fma(_1751, f16vec2(Weights.w3[172u], Weights.w3[173u]), fma(_1750, f16vec2(Weights.w3[164u], Weights.w3[165u]), _1655))))))))));
    f16vec2 _2363 = fma(_2299, f16vec2(Weights.w3[238u], Weights.w3[239u]), fma(_2298, f16vec2(Weights.w3[230u], Weights.w3[231u]), fma(_2167, f16vec2(Weights.w3[222u], Weights.w3[223u]), fma(_2166, f16vec2(Weights.w3[214u], Weights.w3[215u]), fma(_2037, f16vec2(Weights.w3[206u], Weights.w3[207u]), fma(_2036, f16vec2(Weights.w3[198u], Weights.w3[199u]), fma(_1891, f16vec2(Weights.w3[190u], Weights.w3[191u]), fma(_1890, f16vec2(Weights.w3[182u], Weights.w3[183u]), fma(_1751, f16vec2(Weights.w3[174u], Weights.w3[175u]), fma(_1750, f16vec2(Weights.w3[166u], Weights.w3[167u]), _1667))))))))));
    f16vec2 _2439 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[366u], Weights.w2[367u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[318u], Weights.w2[319u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[270u], Weights.w2[271u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[222u], Weights.w2[223u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[174u], Weights.w2[175u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[126u], Weights.w2[127u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[78u], Weights.w2[79u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[30u], Weights.w2[31u]), f16vec2(Biases.b2[30u], Biases.b2[31u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2442 = f16vec2(_2439.x);
    f16vec2 _2443 = f16vec2(_2439.y);
    f16vec2 _2567 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[368u], Weights.w2[369u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[320u], Weights.w2[321u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[272u], Weights.w2[273u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[224u], Weights.w2[225u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[176u], Weights.w2[177u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[128u], Weights.w2[129u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[80u], Weights.w2[81u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[32u], Weights.w2[33u]), f16vec2(Biases.b2[32u], Biases.b2[33u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2570 = f16vec2(_2567.x);
    f16vec2 _2571 = f16vec2(_2567.y);
    f16vec2 _2695 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[370u], Weights.w2[371u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[322u], Weights.w2[323u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[274u], Weights.w2[275u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[226u], Weights.w2[227u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[178u], Weights.w2[179u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[130u], Weights.w2[131u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[82u], Weights.w2[83u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[34u], Weights.w2[35u]), f16vec2(Biases.b2[34u], Biases.b2[35u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2698 = f16vec2(_2695.x);
    f16vec2 _2699 = f16vec2(_2695.y);
    f16vec2 _2833 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[372u], Weights.w2[373u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[324u], Weights.w2[325u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[276u], Weights.w2[277u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[228u], Weights.w2[229u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[180u], Weights.w2[181u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[132u], Weights.w2[133u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[84u], Weights.w2[85u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[36u], Weights.w2[37u]), f16vec2(Biases.b2[36u], Biases.b2[37u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2836 = f16vec2(_2833.x);
    f16vec2 _2837 = f16vec2(_2833.y);
    f16vec2 _2959 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[374u], Weights.w2[375u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[326u], Weights.w2[327u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[278u], Weights.w2[279u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[230u], Weights.w2[231u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[182u], Weights.w2[183u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[134u], Weights.w2[135u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[86u], Weights.w2[87u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[38u], Weights.w2[39u]), f16vec2(Biases.b2[38u], Biases.b2[39u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2962 = f16vec2(_2959.x);
    f16vec2 _2963 = f16vec2(_2959.y);
    f16vec2 _2975 = fma(_2963, f16vec2(Weights.w3[312u], Weights.w3[313u]), fma(_2962, f16vec2(Weights.w3[304u], Weights.w3[305u]), fma(_2837, f16vec2(Weights.w3[296u], Weights.w3[297u]), fma(_2836, f16vec2(Weights.w3[288u], Weights.w3[289u]), fma(_2699, f16vec2(Weights.w3[280u], Weights.w3[281u]), fma(_2698, f16vec2(Weights.w3[272u], Weights.w3[273u]), fma(_2571, f16vec2(Weights.w3[264u], Weights.w3[265u]), fma(_2570, f16vec2(Weights.w3[256u], Weights.w3[257u]), fma(_2443, f16vec2(Weights.w3[248u], Weights.w3[249u]), fma(_2442, f16vec2(Weights.w3[240u], Weights.w3[241u]), _2315))))))))));
    f16vec2 _2987 = fma(_2963, f16vec2(Weights.w3[314u], Weights.w3[315u]), fma(_2962, f16vec2(Weights.w3[306u], Weights.w3[307u]), fma(_2837, f16vec2(Weights.w3[298u], Weights.w3[299u]), fma(_2836, f16vec2(Weights.w3[290u], Weights.w3[291u]), fma(_2699, f16vec2(Weights.w3[282u], Weights.w3[283u]), fma(_2698, f16vec2(Weights.w3[274u], Weights.w3[275u]), fma(_2571, f16vec2(Weights.w3[266u], Weights.w3[267u]), fma(_2570, f16vec2(Weights.w3[258u], Weights.w3[259u]), fma(_2443, f16vec2(Weights.w3[250u], Weights.w3[251u]), fma(_2442, f16vec2(Weights.w3[242u], Weights.w3[243u]), _2331))))))))));
    f16vec2 _2999 = fma(_2963, f16vec2(Weights.w3[316u], Weights.w3[317u]), fma(_2962, f16vec2(Weights.w3[308u], Weights.w3[309u]), fma(_2837, f16vec2(Weights.w3[300u], Weights.w3[301u]), fma(_2836, f16vec2(Weights.w3[292u], Weights.w3[293u]), fma(_2699, f16vec2(Weights.w3[284u], Weights.w3[285u]), fma(_2698, f16vec2(Weights.w3[276u], Weights.w3[277u]), fma(_2571, f16vec2(Weights.w3[268u], Weights.w3[269u]), fma(_2570, f16vec2(Weights.w3[260u], Weights.w3[261u]), fma(_2443, f16vec2(Weights.w3[252u], Weights.w3[253u]), fma(_2442, f16vec2(Weights.w3[244u], Weights.w3[245u]), _2347))))))))));
    f16vec2 _3011 = fma(_2963, f16vec2(Weights.w3[318u], Weights.w3[319u]), fma(_2962, f16vec2(Weights.w3[310u], Weights.w3[311u]), fma(_2837, f16vec2(Weights.w3[302u], Weights.w3[303u]), fma(_2836, f16vec2(Weights.w3[294u], Weights.w3[295u]), fma(_2699, f16vec2(Weights.w3[286u], Weights.w3[287u]), fma(_2698, f16vec2(Weights.w3[278u], Weights.w3[279u]), fma(_2571, f16vec2(Weights.w3[270u], Weights.w3[271u]), fma(_2570, f16vec2(Weights.w3[262u], Weights.w3[263u]), fma(_2443, f16vec2(Weights.w3[254u], Weights.w3[255u]), fma(_2442, f16vec2(Weights.w3[246u], Weights.w3[247u]), _2363))))))))));
    f16vec2 _3085 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[376u], Weights.w2[377u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[328u], Weights.w2[329u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[280u], Weights.w2[281u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[232u], Weights.w2[233u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[184u], Weights.w2[185u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[136u], Weights.w2[137u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[88u], Weights.w2[89u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[40u], Weights.w2[41u]), f16vec2(Biases.b2[40u], Biases.b2[41u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3088 = f16vec2(_3085.x);
    f16vec2 _3089 = f16vec2(_3085.y);
    f16vec2 _3215 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[378u], Weights.w2[379u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[330u], Weights.w2[331u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[282u], Weights.w2[283u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[234u], Weights.w2[235u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[186u], Weights.w2[187u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[138u], Weights.w2[139u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[90u], Weights.w2[91u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[42u], Weights.w2[43u]), f16vec2(Biases.b2[42u], Biases.b2[43u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3218 = f16vec2(_3215.x);
    f16vec2 _3219 = f16vec2(_3215.y);
    f16vec2 _3339 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[380u], Weights.w2[381u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[332u], Weights.w2[333u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[284u], Weights.w2[285u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[236u], Weights.w2[237u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[188u], Weights.w2[189u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[140u], Weights.w2[141u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[92u], Weights.w2[93u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[44u], Weights.w2[45u]), f16vec2(Biases.b2[44u], Biases.b2[45u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3342 = f16vec2(_3339.x);
    f16vec2 _3343 = f16vec2(_3339.y);
    f16vec2 _3463 = max(fma(f16vec2(_6150[3].y), f16vec2(Weights.w2[382u], Weights.w2[383u]), fma(f16vec2(_6150[3].x), f16vec2(Weights.w2[334u], Weights.w2[335u]), fma(f16vec2(_6150[2].y), f16vec2(Weights.w2[286u], Weights.w2[287u]), fma(f16vec2(_6150[2].x), f16vec2(Weights.w2[238u], Weights.w2[239u]), fma(f16vec2(_6150[1].y), f16vec2(Weights.w2[190u], Weights.w2[191u]), fma(f16vec2(_6150[1].x), f16vec2(Weights.w2[142u], Weights.w2[143u]), fma(f16vec2(_6150[0].y), f16vec2(Weights.w2[94u], Weights.w2[95u]), fma(f16vec2(_6150[0].x), f16vec2(Weights.w2[46u], Weights.w2[47u]), f16vec2(Biases.b2[46u], Biases.b2[47u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3466 = f16vec2(_3463.x);
    f16vec2 _3467 = f16vec2(_3463.y);
    f16vec2 _123[4] = f16vec2[](f16vec2(fma(_3467, f16vec2(Weights.w3[376u], Weights.w3[377u]), fma(_3466, f16vec2(Weights.w3[368u], Weights.w3[369u]), fma(_3343, f16vec2(Weights.w3[360u], Weights.w3[361u]), fma(_3342, f16vec2(Weights.w3[352u], Weights.w3[353u]), fma(_3219, f16vec2(Weights.w3[344u], Weights.w3[345u]), fma(_3218, f16vec2(Weights.w3[336u], Weights.w3[337u]), fma(_3089, f16vec2(Weights.w3[328u], Weights.w3[329u]), fma(_3088, f16vec2(Weights.w3[320u], Weights.w3[321u]), _2975))))))))), f16vec2(fma(_3467, f16vec2(Weights.w3[378u], Weights.w3[379u]), fma(_3466, f16vec2(Weights.w3[370u], Weights.w3[371u]), fma(_3343, f16vec2(Weights.w3[362u], Weights.w3[363u]), fma(_3342, f16vec2(Weights.w3[354u], Weights.w3[355u]), fma(_3219, f16vec2(Weights.w3[346u], Weights.w3[347u]), fma(_3218, f16vec2(Weights.w3[338u], Weights.w3[339u]), fma(_3089, f16vec2(Weights.w3[330u], Weights.w3[331u]), fma(_3088, f16vec2(Weights.w3[322u], Weights.w3[323u]), _2987))))))))), f16vec2(fma(_3467, f16vec2(Weights.w3[380u], Weights.w3[381u]), fma(_3466, f16vec2(Weights.w3[372u], Weights.w3[373u]), fma(_3343, f16vec2(Weights.w3[364u], Weights.w3[365u]), fma(_3342, f16vec2(Weights.w3[356u], Weights.w3[357u]), fma(_3219, f16vec2(Weights.w3[348u], Weights.w3[349u]), fma(_3218, f16vec2(Weights.w3[340u], Weights.w3[341u]), fma(_3089, f16vec2(Weights.w3[332u], Weights.w3[333u]), fma(_3088, f16vec2(Weights.w3[324u], Weights.w3[325u]), _2999))))))))), f16vec2(fma(_3467, f16vec2(Weights.w3[382u], Weights.w3[383u]), fma(_3466, f16vec2(Weights.w3[374u], Weights.w3[375u]), fma(_3343, f16vec2(Weights.w3[366u], Weights.w3[367u]), fma(_3342, f16vec2(Weights.w3[358u], Weights.w3[359u]), fma(_3219, f16vec2(Weights.w3[350u], Weights.w3[351u]), fma(_3218, f16vec2(Weights.w3[342u], Weights.w3[343u]), fma(_3089, f16vec2(Weights.w3[334u], Weights.w3[335u]), fma(_3088, f16vec2(Weights.w3[326u], Weights.w3[327u]), _3011))))))))));
    f16vec2 tempArg_1[4] = _123;
    f16vec2 h3[4] = _123;
    f16vec2 _6173[4] = _123;
    uint _6172 = 0u;
    f16vec2 _6171[4];
    uint _6179;
    for (;;)
    {
        _6179 = _6172;
        if (_6179 < 4u)
        {
            _6171[_6179] = max(_6173[_6179], _72[_6179]);
            _6172 = _6179 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    h3 = _6171;
    f16vec2 _3603 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[336u], Weights.w4[337u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[288u], Weights.w4[289u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[240u], Weights.w4[241u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[192u], Weights.w4[193u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[144u], Weights.w4[145u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[96u], Weights.w4[97u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[48u], Weights.w4[49u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[0u], Weights.w4[1u]), f16vec2(Biases.b4[0u], Biases.b4[1u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3606 = f16vec2(_3603.x);
    f16vec2 _3607 = f16vec2(_3603.y);
    f16vec2 _3701 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[338u], Weights.w4[339u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[290u], Weights.w4[291u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[242u], Weights.w4[243u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[194u], Weights.w4[195u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[146u], Weights.w4[147u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[98u], Weights.w4[99u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[50u], Weights.w4[51u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[2u], Weights.w4[3u]), f16vec2(Biases.b4[2u], Biases.b4[3u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3704 = f16vec2(_3701.x);
    f16vec2 _3705 = f16vec2(_3701.y);
    f16vec2 _3799 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[340u], Weights.w4[341u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[292u], Weights.w4[293u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[244u], Weights.w4[245u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[196u], Weights.w4[197u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[148u], Weights.w4[149u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[100u], Weights.w4[101u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[52u], Weights.w4[53u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[4u], Weights.w4[5u]), f16vec2(Biases.b4[4u], Biases.b4[5u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3802 = f16vec2(_3799.x);
    f16vec2 _3803 = f16vec2(_3799.y);
    f16vec2 _3897 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[342u], Weights.w4[343u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[294u], Weights.w4[295u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[246u], Weights.w4[247u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[198u], Weights.w4[199u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[150u], Weights.w4[151u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[102u], Weights.w4[103u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[54u], Weights.w4[55u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[6u], Weights.w4[7u]), f16vec2(Biases.b4[6u], Biases.b4[7u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3900 = f16vec2(_3897.x);
    f16vec2 _3901 = f16vec2(_3897.y);
    f16vec2 _3995 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[344u], Weights.w4[345u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[296u], Weights.w4[297u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[248u], Weights.w4[249u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[200u], Weights.w4[201u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[152u], Weights.w4[153u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[104u], Weights.w4[105u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[56u], Weights.w4[57u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[8u], Weights.w4[9u]), f16vec2(Biases.b4[8u], Biases.b4[9u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3998 = f16vec2(_3995.x);
    f16vec2 _3999 = f16vec2(_3995.y);
    f16vec2 _4011 = fma(_3999, f16vec2(Weights.w5[36u], Weights.w5[37u]), fma(_3998, f16vec2(Weights.w5[32u], Weights.w5[33u]), fma(_3901, f16vec2(Weights.w5[28u], Weights.w5[29u]), fma(_3900, f16vec2(Weights.w5[24u], Weights.w5[25u]), fma(_3803, f16vec2(Weights.w5[20u], Weights.w5[21u]), fma(_3802, f16vec2(Weights.w5[16u], Weights.w5[17u]), fma(_3705, f16vec2(Weights.w5[12u], Weights.w5[13u]), fma(_3704, f16vec2(Weights.w5[8u], Weights.w5[9u]), fma(_3607, f16vec2(Weights.w5[4u], Weights.w5[5u]), fma(_3606, f16vec2(Weights.w5[0u], Weights.w5[1u]), f16vec2(Biases.b5[0u], Biases.b5[1u])))))))))));
    f16vec2 _4023 = fma(_3999, f16vec2(Weights.w5[38u], Weights.w5[39u]), fma(_3998, f16vec2(Weights.w5[34u], Weights.w5[35u]), fma(_3901, f16vec2(Weights.w5[30u], Weights.w5[31u]), fma(_3900, f16vec2(Weights.w5[26u], Weights.w5[27u]), fma(_3803, f16vec2(Weights.w5[22u], Weights.w5[23u]), fma(_3802, f16vec2(Weights.w5[18u], Weights.w5[19u]), fma(_3705, f16vec2(Weights.w5[14u], Weights.w5[15u]), fma(_3704, f16vec2(Weights.w5[10u], Weights.w5[11u]), fma(_3607, f16vec2(Weights.w5[6u], Weights.w5[7u]), fma(_3606, f16vec2(Weights.w5[2u], Weights.w5[3u]), f16vec2(Biases.b5[2u], Biases.b5[3u])))))))))));
    f16vec2 _4093 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[346u], Weights.w4[347u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[298u], Weights.w4[299u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[250u], Weights.w4[251u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[202u], Weights.w4[203u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[154u], Weights.w4[155u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[106u], Weights.w4[107u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[58u], Weights.w4[59u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[10u], Weights.w4[11u]), f16vec2(Biases.b4[10u], Biases.b4[11u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4096 = f16vec2(_4093.x);
    f16vec2 _4097 = f16vec2(_4093.y);
    f16vec2 _4191 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[348u], Weights.w4[349u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[300u], Weights.w4[301u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[252u], Weights.w4[253u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[204u], Weights.w4[205u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[156u], Weights.w4[157u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[108u], Weights.w4[109u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[60u], Weights.w4[61u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[12u], Weights.w4[13u]), f16vec2(Biases.b4[12u], Biases.b4[13u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4194 = f16vec2(_4191.x);
    f16vec2 _4195 = f16vec2(_4191.y);
    f16vec2 _4289 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[350u], Weights.w4[351u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[302u], Weights.w4[303u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[254u], Weights.w4[255u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[206u], Weights.w4[207u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[158u], Weights.w4[159u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[110u], Weights.w4[111u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[62u], Weights.w4[63u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[14u], Weights.w4[15u]), f16vec2(Biases.b4[14u], Biases.b4[15u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4292 = f16vec2(_4289.x);
    f16vec2 _4293 = f16vec2(_4289.y);
    f16vec2 _4387 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[352u], Weights.w4[353u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[304u], Weights.w4[305u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[256u], Weights.w4[257u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[208u], Weights.w4[209u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[160u], Weights.w4[161u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[112u], Weights.w4[113u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[64u], Weights.w4[65u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[16u], Weights.w4[17u]), f16vec2(Biases.b4[16u], Biases.b4[17u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4390 = f16vec2(_4387.x);
    f16vec2 _4391 = f16vec2(_4387.y);
    f16vec2 _4485 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[354u], Weights.w4[355u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[306u], Weights.w4[307u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[258u], Weights.w4[259u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[210u], Weights.w4[211u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[162u], Weights.w4[163u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[114u], Weights.w4[115u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[66u], Weights.w4[67u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[18u], Weights.w4[19u]), f16vec2(Biases.b4[18u], Biases.b4[19u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4488 = f16vec2(_4485.x);
    f16vec2 _4489 = f16vec2(_4485.y);
    f16vec2 _4501 = fma(_4489, f16vec2(Weights.w5[76u], Weights.w5[77u]), fma(_4488, f16vec2(Weights.w5[72u], Weights.w5[73u]), fma(_4391, f16vec2(Weights.w5[68u], Weights.w5[69u]), fma(_4390, f16vec2(Weights.w5[64u], Weights.w5[65u]), fma(_4293, f16vec2(Weights.w5[60u], Weights.w5[61u]), fma(_4292, f16vec2(Weights.w5[56u], Weights.w5[57u]), fma(_4195, f16vec2(Weights.w5[52u], Weights.w5[53u]), fma(_4194, f16vec2(Weights.w5[48u], Weights.w5[49u]), fma(_4097, f16vec2(Weights.w5[44u], Weights.w5[45u]), fma(_4096, f16vec2(Weights.w5[40u], Weights.w5[41u]), _4011))))))))));
    f16vec2 _4513 = fma(_4489, f16vec2(Weights.w5[78u], Weights.w5[79u]), fma(_4488, f16vec2(Weights.w5[74u], Weights.w5[75u]), fma(_4391, f16vec2(Weights.w5[70u], Weights.w5[71u]), fma(_4390, f16vec2(Weights.w5[66u], Weights.w5[67u]), fma(_4293, f16vec2(Weights.w5[62u], Weights.w5[63u]), fma(_4292, f16vec2(Weights.w5[58u], Weights.w5[59u]), fma(_4195, f16vec2(Weights.w5[54u], Weights.w5[55u]), fma(_4194, f16vec2(Weights.w5[50u], Weights.w5[51u]), fma(_4097, f16vec2(Weights.w5[46u], Weights.w5[47u]), fma(_4096, f16vec2(Weights.w5[42u], Weights.w5[43u]), _4023))))))))));
    f16vec2 _4583 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[356u], Weights.w4[357u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[308u], Weights.w4[309u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[260u], Weights.w4[261u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[212u], Weights.w4[213u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[164u], Weights.w4[165u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[116u], Weights.w4[117u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[68u], Weights.w4[69u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[20u], Weights.w4[21u]), f16vec2(Biases.b4[20u], Biases.b4[21u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4586 = f16vec2(_4583.x);
    f16vec2 _4587 = f16vec2(_4583.y);
    f16vec2 _4681 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[358u], Weights.w4[359u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[310u], Weights.w4[311u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[262u], Weights.w4[263u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[214u], Weights.w4[215u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[166u], Weights.w4[167u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[118u], Weights.w4[119u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[70u], Weights.w4[71u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[22u], Weights.w4[23u]), f16vec2(Biases.b4[22u], Biases.b4[23u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4684 = f16vec2(_4681.x);
    f16vec2 _4685 = f16vec2(_4681.y);
    f16vec2 _4779 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[360u], Weights.w4[361u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[312u], Weights.w4[313u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[264u], Weights.w4[265u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[216u], Weights.w4[217u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[168u], Weights.w4[169u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[120u], Weights.w4[121u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[72u], Weights.w4[73u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[24u], Weights.w4[25u]), f16vec2(Biases.b4[24u], Biases.b4[25u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4782 = f16vec2(_4779.x);
    f16vec2 _4783 = f16vec2(_4779.y);
    f16vec2 _4877 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[362u], Weights.w4[363u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[314u], Weights.w4[315u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[266u], Weights.w4[267u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[218u], Weights.w4[219u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[170u], Weights.w4[171u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[122u], Weights.w4[123u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[74u], Weights.w4[75u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[26u], Weights.w4[27u]), f16vec2(Biases.b4[26u], Biases.b4[27u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4880 = f16vec2(_4877.x);
    f16vec2 _4881 = f16vec2(_4877.y);
    f16vec2 _4975 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[364u], Weights.w4[365u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[316u], Weights.w4[317u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[268u], Weights.w4[269u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[220u], Weights.w4[221u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[172u], Weights.w4[173u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[124u], Weights.w4[125u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[76u], Weights.w4[77u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[28u], Weights.w4[29u]), f16vec2(Biases.b4[28u], Biases.b4[29u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4978 = f16vec2(_4975.x);
    f16vec2 _4979 = f16vec2(_4975.y);
    f16vec2 _4991 = fma(_4979, f16vec2(Weights.w5[116u], Weights.w5[117u]), fma(_4978, f16vec2(Weights.w5[112u], Weights.w5[113u]), fma(_4881, f16vec2(Weights.w5[108u], Weights.w5[109u]), fma(_4880, f16vec2(Weights.w5[104u], Weights.w5[105u]), fma(_4783, f16vec2(Weights.w5[100u], Weights.w5[101u]), fma(_4782, f16vec2(Weights.w5[96u], Weights.w5[97u]), fma(_4685, f16vec2(Weights.w5[92u], Weights.w5[93u]), fma(_4684, f16vec2(Weights.w5[88u], Weights.w5[89u]), fma(_4587, f16vec2(Weights.w5[84u], Weights.w5[85u]), fma(_4586, f16vec2(Weights.w5[80u], Weights.w5[81u]), _4501))))))))));
    f16vec2 _5003 = fma(_4979, f16vec2(Weights.w5[118u], Weights.w5[119u]), fma(_4978, f16vec2(Weights.w5[114u], Weights.w5[115u]), fma(_4881, f16vec2(Weights.w5[110u], Weights.w5[111u]), fma(_4880, f16vec2(Weights.w5[106u], Weights.w5[107u]), fma(_4783, f16vec2(Weights.w5[102u], Weights.w5[103u]), fma(_4782, f16vec2(Weights.w5[98u], Weights.w5[99u]), fma(_4685, f16vec2(Weights.w5[94u], Weights.w5[95u]), fma(_4684, f16vec2(Weights.w5[90u], Weights.w5[91u]), fma(_4587, f16vec2(Weights.w5[86u], Weights.w5[87u]), fma(_4586, f16vec2(Weights.w5[82u], Weights.w5[83u]), _4513))))))))));
    f16vec2 _5073 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[366u], Weights.w4[367u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[318u], Weights.w4[319u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[270u], Weights.w4[271u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[222u], Weights.w4[223u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[174u], Weights.w4[175u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[126u], Weights.w4[127u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[78u], Weights.w4[79u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[30u], Weights.w4[31u]), f16vec2(Biases.b4[30u], Biases.b4[31u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5076 = f16vec2(_5073.x);
    f16vec2 _5077 = f16vec2(_5073.y);
    f16vec2 _5171 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[368u], Weights.w4[369u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[320u], Weights.w4[321u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[272u], Weights.w4[273u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[224u], Weights.w4[225u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[176u], Weights.w4[177u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[128u], Weights.w4[129u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[80u], Weights.w4[81u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[32u], Weights.w4[33u]), f16vec2(Biases.b4[32u], Biases.b4[33u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5174 = f16vec2(_5171.x);
    f16vec2 _5175 = f16vec2(_5171.y);
    f16vec2 _5269 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[370u], Weights.w4[371u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[322u], Weights.w4[323u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[274u], Weights.w4[275u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[226u], Weights.w4[227u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[178u], Weights.w4[179u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[130u], Weights.w4[131u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[82u], Weights.w4[83u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[34u], Weights.w4[35u]), f16vec2(Biases.b4[34u], Biases.b4[35u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5272 = f16vec2(_5269.x);
    f16vec2 _5273 = f16vec2(_5269.y);
    f16vec2 _5367 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[372u], Weights.w4[373u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[324u], Weights.w4[325u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[276u], Weights.w4[277u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[228u], Weights.w4[229u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[180u], Weights.w4[181u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[132u], Weights.w4[133u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[84u], Weights.w4[85u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[36u], Weights.w4[37u]), f16vec2(Biases.b4[36u], Biases.b4[37u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5370 = f16vec2(_5367.x);
    f16vec2 _5371 = f16vec2(_5367.y);
    f16vec2 _5465 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[374u], Weights.w4[375u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[326u], Weights.w4[327u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[278u], Weights.w4[279u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[230u], Weights.w4[231u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[182u], Weights.w4[183u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[134u], Weights.w4[135u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[86u], Weights.w4[87u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[38u], Weights.w4[39u]), f16vec2(Biases.b4[38u], Biases.b4[39u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5468 = f16vec2(_5465.x);
    f16vec2 _5469 = f16vec2(_5465.y);
    f16vec2 _5481 = fma(_5469, f16vec2(Weights.w5[156u], Weights.w5[157u]), fma(_5468, f16vec2(Weights.w5[152u], Weights.w5[153u]), fma(_5371, f16vec2(Weights.w5[148u], Weights.w5[149u]), fma(_5370, f16vec2(Weights.w5[144u], Weights.w5[145u]), fma(_5273, f16vec2(Weights.w5[140u], Weights.w5[141u]), fma(_5272, f16vec2(Weights.w5[136u], Weights.w5[137u]), fma(_5175, f16vec2(Weights.w5[132u], Weights.w5[133u]), fma(_5174, f16vec2(Weights.w5[128u], Weights.w5[129u]), fma(_5077, f16vec2(Weights.w5[124u], Weights.w5[125u]), fma(_5076, f16vec2(Weights.w5[120u], Weights.w5[121u]), _4991))))))))));
    f16vec2 _5493 = fma(_5469, f16vec2(Weights.w5[158u], Weights.w5[159u]), fma(_5468, f16vec2(Weights.w5[154u], Weights.w5[155u]), fma(_5371, f16vec2(Weights.w5[150u], Weights.w5[151u]), fma(_5370, f16vec2(Weights.w5[146u], Weights.w5[147u]), fma(_5273, f16vec2(Weights.w5[142u], Weights.w5[143u]), fma(_5272, f16vec2(Weights.w5[138u], Weights.w5[139u]), fma(_5175, f16vec2(Weights.w5[134u], Weights.w5[135u]), fma(_5174, f16vec2(Weights.w5[130u], Weights.w5[131u]), fma(_5077, f16vec2(Weights.w5[126u], Weights.w5[127u]), fma(_5076, f16vec2(Weights.w5[122u], Weights.w5[123u]), _5003))))))))));
    f16vec2 _5563 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[376u], Weights.w4[377u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[328u], Weights.w4[329u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[280u], Weights.w4[281u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[232u], Weights.w4[233u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[184u], Weights.w4[185u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[136u], Weights.w4[137u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[88u], Weights.w4[89u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[40u], Weights.w4[41u]), f16vec2(Biases.b4[40u], Biases.b4[41u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5566 = f16vec2(_5563.x);
    f16vec2 _5567 = f16vec2(_5563.y);
    f16vec2 _5661 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[378u], Weights.w4[379u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[330u], Weights.w4[331u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[282u], Weights.w4[283u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[234u], Weights.w4[235u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[186u], Weights.w4[187u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[138u], Weights.w4[139u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[90u], Weights.w4[91u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[42u], Weights.w4[43u]), f16vec2(Biases.b4[42u], Biases.b4[43u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5664 = f16vec2(_5661.x);
    f16vec2 _5665 = f16vec2(_5661.y);
    f16vec2 _5759 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[380u], Weights.w4[381u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[332u], Weights.w4[333u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[284u], Weights.w4[285u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[236u], Weights.w4[237u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[188u], Weights.w4[189u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[140u], Weights.w4[141u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[92u], Weights.w4[93u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[44u], Weights.w4[45u]), f16vec2(Biases.b4[44u], Biases.b4[45u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5762 = f16vec2(_5759.x);
    f16vec2 _5763 = f16vec2(_5759.y);
    f16vec2 _5857 = max(fma(f16vec2(_6171[3].y), f16vec2(Weights.w4[382u], Weights.w4[383u]), fma(f16vec2(_6171[3].x), f16vec2(Weights.w4[334u], Weights.w4[335u]), fma(f16vec2(_6171[2].y), f16vec2(Weights.w4[286u], Weights.w4[287u]), fma(f16vec2(_6171[2].x), f16vec2(Weights.w4[238u], Weights.w4[239u]), fma(f16vec2(_6171[1].y), f16vec2(Weights.w4[190u], Weights.w4[191u]), fma(f16vec2(_6171[1].x), f16vec2(Weights.w4[142u], Weights.w4[143u]), fma(f16vec2(_6171[0].y), f16vec2(Weights.w4[94u], Weights.w4[95u]), fma(f16vec2(_6171[0].x), f16vec2(Weights.w4[46u], Weights.w4[47u]), f16vec2(Biases.b4[46u], Biases.b4[47u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5860 = f16vec2(_5857.x);
    f16vec2 _5861 = f16vec2(_5857.y);
    f16vec2 _172[2] = f16vec2[](f16vec2(fma(_5861, f16vec2(Weights.w5[188u], Weights.w5[189u]), fma(_5860, f16vec2(Weights.w5[184u], Weights.w5[185u]), fma(_5763, f16vec2(Weights.w5[180u], Weights.w5[181u]), fma(_5762, f16vec2(Weights.w5[176u], Weights.w5[177u]), fma(_5665, f16vec2(Weights.w5[172u], Weights.w5[173u]), fma(_5664, f16vec2(Weights.w5[168u], Weights.w5[169u]), fma(_5567, f16vec2(Weights.w5[164u], Weights.w5[165u]), fma(_5566, f16vec2(Weights.w5[160u], Weights.w5[161u]), _5481))))))))), f16vec2(fma(_5861, f16vec2(Weights.w5[190u], Weights.w5[191u]), fma(_5860, f16vec2(Weights.w5[186u], Weights.w5[187u]), fma(_5763, f16vec2(Weights.w5[182u], Weights.w5[183u]), fma(_5762, f16vec2(Weights.w5[178u], Weights.w5[179u]), fma(_5665, f16vec2(Weights.w5[174u], Weights.w5[175u]), fma(_5664, f16vec2(Weights.w5[170u], Weights.w5[171u]), fma(_5567, f16vec2(Weights.w5[166u], Weights.w5[167u]), fma(_5566, f16vec2(Weights.w5[162u], Weights.w5[163u]), _5493))))))))));
    f16vec2 tempArg_2[2] = _172;
    f16vec2 y[2] = _172;
    f16vec2 _6193[2] = _172;
    uint _6192 = 0u;
    f16vec2 _6191[2];
    uint _6199;
    for (;;)
    {
        _6199 = _6192;
        if (_6199 < 2u)
        {
            _6191[_6199] = max(_6193[_6199], _176[_6199]);
            _6192 = _6199 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _6191;
    f16vec2 _6219[2] = _6191;
    uint _6220 = 0u;
    uint _6225;
    for (;;)
    {
        _6225 = _6220;
        if (_6225 < 4u)
        {
            _6209(0u + _6225, _6219[_6225 / 2u]);
            _6220 = _6225 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

