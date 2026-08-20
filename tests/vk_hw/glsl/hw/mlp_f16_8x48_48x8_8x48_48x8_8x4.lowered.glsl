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

const f16vec2 _100[4] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const f16vec2 _172[2] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[48];
} InX;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[384];
    float16_t w2[384];
    float16_t w3[384];
    float16_t w4[384];
    float16_t w5[32];
} Weights;

layout(set = 0, binding = 2, std430) buffer PackedBias
{
    float16_t b1[48];
    float16_t b2[8];
    float16_t b3[48];
    float16_t b4[8];
    float16_t b5[4];
} Biases;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[4];
} OutY;

f16vec2 _6601(uint _6602)
{
    return f16vec2(InX.x[_6602], InX.x[_6602 + 1u]);
}

f16vec2 _6493(uint _6494)
{
    return f16vec2(Weights.w5[_6494], Weights.w5[_6494 + 1u]);
}

f16vec2 _6503(uint _6504)
{
    return f16vec2(Biases.b5[_6504], Biases.b5[_6504 + 1u]);
}

f16vec2[2] _6514(f16vec2 _6515[4])
{
    f16vec2 _6532[4] = _6515;
    uint _6528 = 0u;
    f16vec2 _6527[2];
    uint _6535;
    for (;;)
    {
        _6535 = _6528;
        if (_6535 < 2u)
        {
            f16vec2 _6530 = f16vec2(float16_t(0.0));
            f16vec2 _6531 = f16vec2(float16_t(0.0));
            uint _6529 = 0u;
            uint _6537;
            for (;;)
            {
                _6537 = _6529;
                if (_6537 < 4u)
                {
                    uint _6539 = _6537 * 2u;
                    uint _6540 = _6535 * 2u;
                    uint _6544 = (_6539 * 4u) + _6540;
                    f16vec2 _6557 = _6493(((uint(0) + (_6544 / 4u)) * uint(4)) + (uint(0) + (_6544 % 4u)));
                    uint _6560 = ((_6539 + 1u) * 4u) + _6540;
                    f16vec2 _6573 = _6493(((uint(0) + (_6560 / 4u)) * uint(4)) + (uint(0) + (_6560 % 4u)));
                    _6530 = fma(_6532[_6537], f16vec2(_6557.x, _6573.x), _6530);
                    _6531 = fma(_6532[_6537], f16vec2(_6557.y, _6573.y), _6531);
                    _6529 = _6537 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _6527[_6535] = f16vec2(_6530.x + _6530.y, _6531.x + _6531.y) + _6503(_6535 * 2u);
            _6528 = _6535 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _6527;
}

void _6685(uint _6686, f16vec2 _6687)
{
    OutY.y[_6686] = _6687.x;
    OutY.y[_6686 + 1u] = _6687.y;
}

void main()
{
    uint _6612 = 0u;
    f16vec2 _6611[4];
    uint _6617;
    for (;;)
    {
        _6617 = _6612;
        if (_6617 < 8u)
        {
            _6611[_6617 / 2u] = _6601(0u + _6617);
            _6612 = _6617 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _22[4] = _6611;
    f16vec2 tempArg[4] = _22;
    f16vec2 x[4] = _22;
    f16vec2 _294 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[336u], Weights.w1[337u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[288u], Weights.w1[289u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[240u], Weights.w1[241u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[192u], Weights.w1[193u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[144u], Weights.w1[145u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[96u], Weights.w1[97u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[48u], Weights.w1[49u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[0u], Weights.w1[1u]), f16vec2(Biases.b1[0u], Biases.b1[1u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _297 = f16vec2(_294.x);
    f16vec2 _298 = f16vec2(_294.y);
    f16vec2 _437 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[338u], Weights.w1[339u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[290u], Weights.w1[291u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[242u], Weights.w1[243u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[194u], Weights.w1[195u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[146u], Weights.w1[147u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[98u], Weights.w1[99u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[50u], Weights.w1[51u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[2u], Weights.w1[3u]), f16vec2(Biases.b1[2u], Biases.b1[3u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _440 = f16vec2(_437.x);
    f16vec2 _441 = f16vec2(_437.y);
    f16vec2 _589 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[340u], Weights.w1[341u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[292u], Weights.w1[293u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[244u], Weights.w1[245u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[196u], Weights.w1[197u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[148u], Weights.w1[149u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[100u], Weights.w1[101u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[52u], Weights.w1[53u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[4u], Weights.w1[5u]), f16vec2(Biases.b1[4u], Biases.b1[5u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _592 = f16vec2(_589.x);
    f16vec2 _593 = f16vec2(_589.y);
    f16vec2 _740 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[342u], Weights.w1[343u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[294u], Weights.w1[295u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[246u], Weights.w1[247u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[198u], Weights.w1[199u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[150u], Weights.w1[151u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[102u], Weights.w1[103u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[54u], Weights.w1[55u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[6u], Weights.w1[7u]), f16vec2(Biases.b1[6u], Biases.b1[7u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _743 = f16vec2(_740.x);
    f16vec2 _744 = f16vec2(_740.y);
    f16vec2 _882 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[344u], Weights.w1[345u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[296u], Weights.w1[297u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[248u], Weights.w1[249u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[200u], Weights.w1[201u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[152u], Weights.w1[153u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[104u], Weights.w1[105u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[56u], Weights.w1[57u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[8u], Weights.w1[9u]), f16vec2(Biases.b1[8u], Biases.b1[9u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _885 = f16vec2(_882.x);
    f16vec2 _886 = f16vec2(_882.y);
    f16vec2 _902 = fma(_886, f16vec2(Weights.w2[72u], Weights.w2[73u]), fma(_885, f16vec2(Weights.w2[64u], Weights.w2[65u]), fma(_744, f16vec2(Weights.w2[56u], Weights.w2[57u]), fma(_743, f16vec2(Weights.w2[48u], Weights.w2[49u]), fma(_593, f16vec2(Weights.w2[40u], Weights.w2[41u]), fma(_592, f16vec2(Weights.w2[32u], Weights.w2[33u]), fma(_441, f16vec2(Weights.w2[24u], Weights.w2[25u]), fma(_440, f16vec2(Weights.w2[16u], Weights.w2[17u]), fma(_298, f16vec2(Weights.w2[8u], Weights.w2[9u]), fma(_297, f16vec2(Weights.w2[0u], Weights.w2[1u]), f16vec2(Biases.b2[0u], Biases.b2[1u])))))))))));
    f16vec2 _918 = fma(_886, f16vec2(Weights.w2[74u], Weights.w2[75u]), fma(_885, f16vec2(Weights.w2[66u], Weights.w2[67u]), fma(_744, f16vec2(Weights.w2[58u], Weights.w2[59u]), fma(_743, f16vec2(Weights.w2[50u], Weights.w2[51u]), fma(_593, f16vec2(Weights.w2[42u], Weights.w2[43u]), fma(_592, f16vec2(Weights.w2[34u], Weights.w2[35u]), fma(_441, f16vec2(Weights.w2[26u], Weights.w2[27u]), fma(_440, f16vec2(Weights.w2[18u], Weights.w2[19u]), fma(_298, f16vec2(Weights.w2[10u], Weights.w2[11u]), fma(_297, f16vec2(Weights.w2[2u], Weights.w2[3u]), f16vec2(Biases.b2[2u], Biases.b2[3u])))))))))));
    f16vec2 _934 = fma(_886, f16vec2(Weights.w2[76u], Weights.w2[77u]), fma(_885, f16vec2(Weights.w2[68u], Weights.w2[69u]), fma(_744, f16vec2(Weights.w2[60u], Weights.w2[61u]), fma(_743, f16vec2(Weights.w2[52u], Weights.w2[53u]), fma(_593, f16vec2(Weights.w2[44u], Weights.w2[45u]), fma(_592, f16vec2(Weights.w2[36u], Weights.w2[37u]), fma(_441, f16vec2(Weights.w2[28u], Weights.w2[29u]), fma(_440, f16vec2(Weights.w2[20u], Weights.w2[21u]), fma(_298, f16vec2(Weights.w2[12u], Weights.w2[13u]), fma(_297, f16vec2(Weights.w2[4u], Weights.w2[5u]), f16vec2(Biases.b2[4u], Biases.b2[5u])))))))))));
    f16vec2 _950 = fma(_886, f16vec2(Weights.w2[78u], Weights.w2[79u]), fma(_885, f16vec2(Weights.w2[70u], Weights.w2[71u]), fma(_744, f16vec2(Weights.w2[62u], Weights.w2[63u]), fma(_743, f16vec2(Weights.w2[54u], Weights.w2[55u]), fma(_593, f16vec2(Weights.w2[46u], Weights.w2[47u]), fma(_592, f16vec2(Weights.w2[38u], Weights.w2[39u]), fma(_441, f16vec2(Weights.w2[30u], Weights.w2[31u]), fma(_440, f16vec2(Weights.w2[22u], Weights.w2[23u]), fma(_298, f16vec2(Weights.w2[14u], Weights.w2[15u]), fma(_297, f16vec2(Weights.w2[6u], Weights.w2[7u]), f16vec2(Biases.b2[6u], Biases.b2[7u])))))))))));
    f16vec2 _1032 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[346u], Weights.w1[347u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[298u], Weights.w1[299u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[250u], Weights.w1[251u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[202u], Weights.w1[203u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[154u], Weights.w1[155u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[106u], Weights.w1[107u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[58u], Weights.w1[59u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[10u], Weights.w1[11u]), f16vec2(Biases.b1[10u], Biases.b1[11u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1035 = f16vec2(_1032.x);
    f16vec2 _1036 = f16vec2(_1032.y);
    f16vec2 _1182 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[348u], Weights.w1[349u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[300u], Weights.w1[301u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[252u], Weights.w1[253u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[204u], Weights.w1[205u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[156u], Weights.w1[157u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[108u], Weights.w1[109u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[60u], Weights.w1[61u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[12u], Weights.w1[13u]), f16vec2(Biases.b1[12u], Biases.b1[13u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1185 = f16vec2(_1182.x);
    f16vec2 _1186 = f16vec2(_1182.y);
    f16vec2 _1316 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[350u], Weights.w1[351u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[302u], Weights.w1[303u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[254u], Weights.w1[255u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[206u], Weights.w1[207u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[158u], Weights.w1[159u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[110u], Weights.w1[111u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[62u], Weights.w1[63u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[14u], Weights.w1[15u]), f16vec2(Biases.b1[14u], Biases.b1[15u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1319 = f16vec2(_1316.x);
    f16vec2 _1320 = f16vec2(_1316.y);
    f16vec2 _1464 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[352u], Weights.w1[353u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[304u], Weights.w1[305u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[256u], Weights.w1[257u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[208u], Weights.w1[209u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[160u], Weights.w1[161u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[112u], Weights.w1[113u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[64u], Weights.w1[65u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[16u], Weights.w1[17u]), f16vec2(Biases.b1[16u], Biases.b1[17u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1467 = f16vec2(_1464.x);
    f16vec2 _1468 = f16vec2(_1464.y);
    f16vec2 _1612 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[354u], Weights.w1[355u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[306u], Weights.w1[307u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[258u], Weights.w1[259u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[210u], Weights.w1[211u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[162u], Weights.w1[163u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[114u], Weights.w1[115u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[66u], Weights.w1[67u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[18u], Weights.w1[19u]), f16vec2(Biases.b1[18u], Biases.b1[19u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1615 = f16vec2(_1612.x);
    f16vec2 _1616 = f16vec2(_1612.y);
    f16vec2 _1628 = fma(_1616, f16vec2(Weights.w2[152u], Weights.w2[153u]), fma(_1615, f16vec2(Weights.w2[144u], Weights.w2[145u]), fma(_1468, f16vec2(Weights.w2[136u], Weights.w2[137u]), fma(_1467, f16vec2(Weights.w2[128u], Weights.w2[129u]), fma(_1320, f16vec2(Weights.w2[120u], Weights.w2[121u]), fma(_1319, f16vec2(Weights.w2[112u], Weights.w2[113u]), fma(_1186, f16vec2(Weights.w2[104u], Weights.w2[105u]), fma(_1185, f16vec2(Weights.w2[96u], Weights.w2[97u]), fma(_1036, f16vec2(Weights.w2[88u], Weights.w2[89u]), fma(_1035, f16vec2(Weights.w2[80u], Weights.w2[81u]), _902))))))))));
    f16vec2 _1640 = fma(_1616, f16vec2(Weights.w2[154u], Weights.w2[155u]), fma(_1615, f16vec2(Weights.w2[146u], Weights.w2[147u]), fma(_1468, f16vec2(Weights.w2[138u], Weights.w2[139u]), fma(_1467, f16vec2(Weights.w2[130u], Weights.w2[131u]), fma(_1320, f16vec2(Weights.w2[122u], Weights.w2[123u]), fma(_1319, f16vec2(Weights.w2[114u], Weights.w2[115u]), fma(_1186, f16vec2(Weights.w2[106u], Weights.w2[107u]), fma(_1185, f16vec2(Weights.w2[98u], Weights.w2[99u]), fma(_1036, f16vec2(Weights.w2[90u], Weights.w2[91u]), fma(_1035, f16vec2(Weights.w2[82u], Weights.w2[83u]), _918))))))))));
    f16vec2 _1652 = fma(_1616, f16vec2(Weights.w2[156u], Weights.w2[157u]), fma(_1615, f16vec2(Weights.w2[148u], Weights.w2[149u]), fma(_1468, f16vec2(Weights.w2[140u], Weights.w2[141u]), fma(_1467, f16vec2(Weights.w2[132u], Weights.w2[133u]), fma(_1320, f16vec2(Weights.w2[124u], Weights.w2[125u]), fma(_1319, f16vec2(Weights.w2[116u], Weights.w2[117u]), fma(_1186, f16vec2(Weights.w2[108u], Weights.w2[109u]), fma(_1185, f16vec2(Weights.w2[100u], Weights.w2[101u]), fma(_1036, f16vec2(Weights.w2[92u], Weights.w2[93u]), fma(_1035, f16vec2(Weights.w2[84u], Weights.w2[85u]), _934))))))))));
    f16vec2 _1664 = fma(_1616, f16vec2(Weights.w2[158u], Weights.w2[159u]), fma(_1615, f16vec2(Weights.w2[150u], Weights.w2[151u]), fma(_1468, f16vec2(Weights.w2[142u], Weights.w2[143u]), fma(_1467, f16vec2(Weights.w2[134u], Weights.w2[135u]), fma(_1320, f16vec2(Weights.w2[126u], Weights.w2[127u]), fma(_1319, f16vec2(Weights.w2[118u], Weights.w2[119u]), fma(_1186, f16vec2(Weights.w2[110u], Weights.w2[111u]), fma(_1185, f16vec2(Weights.w2[102u], Weights.w2[103u]), fma(_1036, f16vec2(Weights.w2[94u], Weights.w2[95u]), fma(_1035, f16vec2(Weights.w2[86u], Weights.w2[87u]), _950))))))))));
    f16vec2 _1744 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[356u], Weights.w1[357u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[308u], Weights.w1[309u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[260u], Weights.w1[261u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[212u], Weights.w1[213u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[164u], Weights.w1[165u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[116u], Weights.w1[117u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[68u], Weights.w1[69u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[20u], Weights.w1[21u]), f16vec2(Biases.b1[20u], Biases.b1[21u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1747 = f16vec2(_1744.x);
    f16vec2 _1748 = f16vec2(_1744.y);
    f16vec2 _1884 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[358u], Weights.w1[359u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[310u], Weights.w1[311u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[262u], Weights.w1[263u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[214u], Weights.w1[215u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[166u], Weights.w1[167u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[118u], Weights.w1[119u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[70u], Weights.w1[71u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[22u], Weights.w1[23u]), f16vec2(Biases.b1[22u], Biases.b1[23u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1887 = f16vec2(_1884.x);
    f16vec2 _1888 = f16vec2(_1884.y);
    f16vec2 _2030 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[360u], Weights.w1[361u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[312u], Weights.w1[313u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[264u], Weights.w1[265u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[216u], Weights.w1[217u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[168u], Weights.w1[169u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[120u], Weights.w1[121u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[72u], Weights.w1[73u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[24u], Weights.w1[25u]), f16vec2(Biases.b1[24u], Biases.b1[25u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2033 = f16vec2(_2030.x);
    f16vec2 _2034 = f16vec2(_2030.y);
    f16vec2 _2160 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[362u], Weights.w1[363u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[314u], Weights.w1[315u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[266u], Weights.w1[267u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[218u], Weights.w1[219u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[170u], Weights.w1[171u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[122u], Weights.w1[123u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[74u], Weights.w1[75u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[26u], Weights.w1[27u]), f16vec2(Biases.b1[26u], Biases.b1[27u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2163 = f16vec2(_2160.x);
    f16vec2 _2164 = f16vec2(_2160.y);
    f16vec2 _2292 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[364u], Weights.w1[365u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[316u], Weights.w1[317u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[268u], Weights.w1[269u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[220u], Weights.w1[221u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[172u], Weights.w1[173u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[124u], Weights.w1[125u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[76u], Weights.w1[77u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[28u], Weights.w1[29u]), f16vec2(Biases.b1[28u], Biases.b1[29u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2295 = f16vec2(_2292.x);
    f16vec2 _2296 = f16vec2(_2292.y);
    f16vec2 _2312 = fma(_2296, f16vec2(Weights.w2[232u], Weights.w2[233u]), fma(_2295, f16vec2(Weights.w2[224u], Weights.w2[225u]), fma(_2164, f16vec2(Weights.w2[216u], Weights.w2[217u]), fma(_2163, f16vec2(Weights.w2[208u], Weights.w2[209u]), fma(_2034, f16vec2(Weights.w2[200u], Weights.w2[201u]), fma(_2033, f16vec2(Weights.w2[192u], Weights.w2[193u]), fma(_1888, f16vec2(Weights.w2[184u], Weights.w2[185u]), fma(_1887, f16vec2(Weights.w2[176u], Weights.w2[177u]), fma(_1748, f16vec2(Weights.w2[168u], Weights.w2[169u]), fma(_1747, f16vec2(Weights.w2[160u], Weights.w2[161u]), _1628))))))))));
    f16vec2 _2328 = fma(_2296, f16vec2(Weights.w2[234u], Weights.w2[235u]), fma(_2295, f16vec2(Weights.w2[226u], Weights.w2[227u]), fma(_2164, f16vec2(Weights.w2[218u], Weights.w2[219u]), fma(_2163, f16vec2(Weights.w2[210u], Weights.w2[211u]), fma(_2034, f16vec2(Weights.w2[202u], Weights.w2[203u]), fma(_2033, f16vec2(Weights.w2[194u], Weights.w2[195u]), fma(_1888, f16vec2(Weights.w2[186u], Weights.w2[187u]), fma(_1887, f16vec2(Weights.w2[178u], Weights.w2[179u]), fma(_1748, f16vec2(Weights.w2[170u], Weights.w2[171u]), fma(_1747, f16vec2(Weights.w2[162u], Weights.w2[163u]), _1640))))))))));
    f16vec2 _2344 = fma(_2296, f16vec2(Weights.w2[236u], Weights.w2[237u]), fma(_2295, f16vec2(Weights.w2[228u], Weights.w2[229u]), fma(_2164, f16vec2(Weights.w2[220u], Weights.w2[221u]), fma(_2163, f16vec2(Weights.w2[212u], Weights.w2[213u]), fma(_2034, f16vec2(Weights.w2[204u], Weights.w2[205u]), fma(_2033, f16vec2(Weights.w2[196u], Weights.w2[197u]), fma(_1888, f16vec2(Weights.w2[188u], Weights.w2[189u]), fma(_1887, f16vec2(Weights.w2[180u], Weights.w2[181u]), fma(_1748, f16vec2(Weights.w2[172u], Weights.w2[173u]), fma(_1747, f16vec2(Weights.w2[164u], Weights.w2[165u]), _1652))))))))));
    f16vec2 _2360 = fma(_2296, f16vec2(Weights.w2[238u], Weights.w2[239u]), fma(_2295, f16vec2(Weights.w2[230u], Weights.w2[231u]), fma(_2164, f16vec2(Weights.w2[222u], Weights.w2[223u]), fma(_2163, f16vec2(Weights.w2[214u], Weights.w2[215u]), fma(_2034, f16vec2(Weights.w2[206u], Weights.w2[207u]), fma(_2033, f16vec2(Weights.w2[198u], Weights.w2[199u]), fma(_1888, f16vec2(Weights.w2[190u], Weights.w2[191u]), fma(_1887, f16vec2(Weights.w2[182u], Weights.w2[183u]), fma(_1748, f16vec2(Weights.w2[174u], Weights.w2[175u]), fma(_1747, f16vec2(Weights.w2[166u], Weights.w2[167u]), _1664))))))))));
    f16vec2 _2436 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[366u], Weights.w1[367u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[318u], Weights.w1[319u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[270u], Weights.w1[271u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[222u], Weights.w1[223u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[174u], Weights.w1[175u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[126u], Weights.w1[127u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[78u], Weights.w1[79u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[30u], Weights.w1[31u]), f16vec2(Biases.b1[30u], Biases.b1[31u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2439 = f16vec2(_2436.x);
    f16vec2 _2440 = f16vec2(_2436.y);
    f16vec2 _2564 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[368u], Weights.w1[369u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[320u], Weights.w1[321u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[272u], Weights.w1[273u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[224u], Weights.w1[225u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[176u], Weights.w1[177u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[128u], Weights.w1[129u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[80u], Weights.w1[81u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[32u], Weights.w1[33u]), f16vec2(Biases.b1[32u], Biases.b1[33u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2567 = f16vec2(_2564.x);
    f16vec2 _2568 = f16vec2(_2564.y);
    f16vec2 _2692 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[370u], Weights.w1[371u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[322u], Weights.w1[323u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[274u], Weights.w1[275u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[226u], Weights.w1[227u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[178u], Weights.w1[179u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[130u], Weights.w1[131u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[82u], Weights.w1[83u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[34u], Weights.w1[35u]), f16vec2(Biases.b1[34u], Biases.b1[35u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2695 = f16vec2(_2692.x);
    f16vec2 _2696 = f16vec2(_2692.y);
    f16vec2 _2830 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[372u], Weights.w1[373u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[324u], Weights.w1[325u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[276u], Weights.w1[277u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[228u], Weights.w1[229u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[180u], Weights.w1[181u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[132u], Weights.w1[133u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[84u], Weights.w1[85u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[36u], Weights.w1[37u]), f16vec2(Biases.b1[36u], Biases.b1[37u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2833 = f16vec2(_2830.x);
    f16vec2 _2834 = f16vec2(_2830.y);
    f16vec2 _2956 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[374u], Weights.w1[375u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[326u], Weights.w1[327u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[278u], Weights.w1[279u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[230u], Weights.w1[231u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[182u], Weights.w1[183u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[134u], Weights.w1[135u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[86u], Weights.w1[87u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[38u], Weights.w1[39u]), f16vec2(Biases.b1[38u], Biases.b1[39u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2959 = f16vec2(_2956.x);
    f16vec2 _2960 = f16vec2(_2956.y);
    f16vec2 _2972 = fma(_2960, f16vec2(Weights.w2[312u], Weights.w2[313u]), fma(_2959, f16vec2(Weights.w2[304u], Weights.w2[305u]), fma(_2834, f16vec2(Weights.w2[296u], Weights.w2[297u]), fma(_2833, f16vec2(Weights.w2[288u], Weights.w2[289u]), fma(_2696, f16vec2(Weights.w2[280u], Weights.w2[281u]), fma(_2695, f16vec2(Weights.w2[272u], Weights.w2[273u]), fma(_2568, f16vec2(Weights.w2[264u], Weights.w2[265u]), fma(_2567, f16vec2(Weights.w2[256u], Weights.w2[257u]), fma(_2440, f16vec2(Weights.w2[248u], Weights.w2[249u]), fma(_2439, f16vec2(Weights.w2[240u], Weights.w2[241u]), _2312))))))))));
    f16vec2 _2984 = fma(_2960, f16vec2(Weights.w2[314u], Weights.w2[315u]), fma(_2959, f16vec2(Weights.w2[306u], Weights.w2[307u]), fma(_2834, f16vec2(Weights.w2[298u], Weights.w2[299u]), fma(_2833, f16vec2(Weights.w2[290u], Weights.w2[291u]), fma(_2696, f16vec2(Weights.w2[282u], Weights.w2[283u]), fma(_2695, f16vec2(Weights.w2[274u], Weights.w2[275u]), fma(_2568, f16vec2(Weights.w2[266u], Weights.w2[267u]), fma(_2567, f16vec2(Weights.w2[258u], Weights.w2[259u]), fma(_2440, f16vec2(Weights.w2[250u], Weights.w2[251u]), fma(_2439, f16vec2(Weights.w2[242u], Weights.w2[243u]), _2328))))))))));
    f16vec2 _2996 = fma(_2960, f16vec2(Weights.w2[316u], Weights.w2[317u]), fma(_2959, f16vec2(Weights.w2[308u], Weights.w2[309u]), fma(_2834, f16vec2(Weights.w2[300u], Weights.w2[301u]), fma(_2833, f16vec2(Weights.w2[292u], Weights.w2[293u]), fma(_2696, f16vec2(Weights.w2[284u], Weights.w2[285u]), fma(_2695, f16vec2(Weights.w2[276u], Weights.w2[277u]), fma(_2568, f16vec2(Weights.w2[268u], Weights.w2[269u]), fma(_2567, f16vec2(Weights.w2[260u], Weights.w2[261u]), fma(_2440, f16vec2(Weights.w2[252u], Weights.w2[253u]), fma(_2439, f16vec2(Weights.w2[244u], Weights.w2[245u]), _2344))))))))));
    f16vec2 _3008 = fma(_2960, f16vec2(Weights.w2[318u], Weights.w2[319u]), fma(_2959, f16vec2(Weights.w2[310u], Weights.w2[311u]), fma(_2834, f16vec2(Weights.w2[302u], Weights.w2[303u]), fma(_2833, f16vec2(Weights.w2[294u], Weights.w2[295u]), fma(_2696, f16vec2(Weights.w2[286u], Weights.w2[287u]), fma(_2695, f16vec2(Weights.w2[278u], Weights.w2[279u]), fma(_2568, f16vec2(Weights.w2[270u], Weights.w2[271u]), fma(_2567, f16vec2(Weights.w2[262u], Weights.w2[263u]), fma(_2440, f16vec2(Weights.w2[254u], Weights.w2[255u]), fma(_2439, f16vec2(Weights.w2[246u], Weights.w2[247u]), _2360))))))))));
    f16vec2 _3082 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[376u], Weights.w1[377u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[328u], Weights.w1[329u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[280u], Weights.w1[281u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[232u], Weights.w1[233u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[184u], Weights.w1[185u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[136u], Weights.w1[137u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[88u], Weights.w1[89u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[40u], Weights.w1[41u]), f16vec2(Biases.b1[40u], Biases.b1[41u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3085 = f16vec2(_3082.x);
    f16vec2 _3086 = f16vec2(_3082.y);
    f16vec2 _3212 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[378u], Weights.w1[379u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[330u], Weights.w1[331u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[282u], Weights.w1[283u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[234u], Weights.w1[235u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[186u], Weights.w1[187u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[138u], Weights.w1[139u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[90u], Weights.w1[91u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[42u], Weights.w1[43u]), f16vec2(Biases.b1[42u], Biases.b1[43u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3215 = f16vec2(_3212.x);
    f16vec2 _3216 = f16vec2(_3212.y);
    f16vec2 _3336 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[380u], Weights.w1[381u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[332u], Weights.w1[333u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[284u], Weights.w1[285u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[236u], Weights.w1[237u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[188u], Weights.w1[189u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[140u], Weights.w1[141u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[92u], Weights.w1[93u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[44u], Weights.w1[45u]), f16vec2(Biases.b1[44u], Biases.b1[45u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3339 = f16vec2(_3336.x);
    f16vec2 _3340 = f16vec2(_3336.y);
    f16vec2 _3460 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[382u], Weights.w1[383u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[334u], Weights.w1[335u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[286u], Weights.w1[287u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[238u], Weights.w1[239u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[190u], Weights.w1[191u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[142u], Weights.w1[143u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[94u], Weights.w1[95u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[46u], Weights.w1[47u]), f16vec2(Biases.b1[46u], Biases.b1[47u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3463 = f16vec2(_3460.x);
    f16vec2 _3464 = f16vec2(_3460.y);
    f16vec2 _96[4] = f16vec2[](f16vec2(fma(_3464, f16vec2(Weights.w2[376u], Weights.w2[377u]), fma(_3463, f16vec2(Weights.w2[368u], Weights.w2[369u]), fma(_3340, f16vec2(Weights.w2[360u], Weights.w2[361u]), fma(_3339, f16vec2(Weights.w2[352u], Weights.w2[353u]), fma(_3216, f16vec2(Weights.w2[344u], Weights.w2[345u]), fma(_3215, f16vec2(Weights.w2[336u], Weights.w2[337u]), fma(_3086, f16vec2(Weights.w2[328u], Weights.w2[329u]), fma(_3085, f16vec2(Weights.w2[320u], Weights.w2[321u]), _2972))))))))), f16vec2(fma(_3464, f16vec2(Weights.w2[378u], Weights.w2[379u]), fma(_3463, f16vec2(Weights.w2[370u], Weights.w2[371u]), fma(_3340, f16vec2(Weights.w2[362u], Weights.w2[363u]), fma(_3339, f16vec2(Weights.w2[354u], Weights.w2[355u]), fma(_3216, f16vec2(Weights.w2[346u], Weights.w2[347u]), fma(_3215, f16vec2(Weights.w2[338u], Weights.w2[339u]), fma(_3086, f16vec2(Weights.w2[330u], Weights.w2[331u]), fma(_3085, f16vec2(Weights.w2[322u], Weights.w2[323u]), _2984))))))))), f16vec2(fma(_3464, f16vec2(Weights.w2[380u], Weights.w2[381u]), fma(_3463, f16vec2(Weights.w2[372u], Weights.w2[373u]), fma(_3340, f16vec2(Weights.w2[364u], Weights.w2[365u]), fma(_3339, f16vec2(Weights.w2[356u], Weights.w2[357u]), fma(_3216, f16vec2(Weights.w2[348u], Weights.w2[349u]), fma(_3215, f16vec2(Weights.w2[340u], Weights.w2[341u]), fma(_3086, f16vec2(Weights.w2[332u], Weights.w2[333u]), fma(_3085, f16vec2(Weights.w2[324u], Weights.w2[325u]), _2996))))))))), f16vec2(fma(_3464, f16vec2(Weights.w2[382u], Weights.w2[383u]), fma(_3463, f16vec2(Weights.w2[374u], Weights.w2[375u]), fma(_3340, f16vec2(Weights.w2[366u], Weights.w2[367u]), fma(_3339, f16vec2(Weights.w2[358u], Weights.w2[359u]), fma(_3216, f16vec2(Weights.w2[350u], Weights.w2[351u]), fma(_3215, f16vec2(Weights.w2[342u], Weights.w2[343u]), fma(_3086, f16vec2(Weights.w2[334u], Weights.w2[335u]), fma(_3085, f16vec2(Weights.w2[326u], Weights.w2[327u]), _3008))))))))));
    f16vec2 tempArg_1[4] = _96;
    f16vec2 h2[4] = _96;
    f16vec2 _6631[4] = _96;
    uint _6630 = 0u;
    f16vec2 _6629[4];
    uint _6637;
    for (;;)
    {
        _6637 = _6630;
        if (_6637 < 4u)
        {
            _6629[_6637] = max(_6631[_6637], _100[_6637]);
            _6630 = _6637 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    h2 = _6629;
    f16vec2 _3610 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[336u], Weights.w3[337u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[288u], Weights.w3[289u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[240u], Weights.w3[241u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[192u], Weights.w3[193u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[144u], Weights.w3[145u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[96u], Weights.w3[97u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[48u], Weights.w3[49u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[0u], Weights.w3[1u]), f16vec2(Biases.b3[0u], Biases.b3[1u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3613 = f16vec2(_3610.x);
    f16vec2 _3614 = f16vec2(_3610.y);
    f16vec2 _3732 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[338u], Weights.w3[339u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[290u], Weights.w3[291u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[242u], Weights.w3[243u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[194u], Weights.w3[195u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[146u], Weights.w3[147u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[98u], Weights.w3[99u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[50u], Weights.w3[51u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[2u], Weights.w3[3u]), f16vec2(Biases.b3[2u], Biases.b3[3u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3735 = f16vec2(_3732.x);
    f16vec2 _3736 = f16vec2(_3732.y);
    f16vec2 _3854 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[340u], Weights.w3[341u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[292u], Weights.w3[293u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[244u], Weights.w3[245u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[196u], Weights.w3[197u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[148u], Weights.w3[149u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[100u], Weights.w3[101u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[52u], Weights.w3[53u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[4u], Weights.w3[5u]), f16vec2(Biases.b3[4u], Biases.b3[5u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3857 = f16vec2(_3854.x);
    f16vec2 _3858 = f16vec2(_3854.y);
    f16vec2 _3976 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[342u], Weights.w3[343u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[294u], Weights.w3[295u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[246u], Weights.w3[247u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[198u], Weights.w3[199u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[150u], Weights.w3[151u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[102u], Weights.w3[103u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[54u], Weights.w3[55u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[6u], Weights.w3[7u]), f16vec2(Biases.b3[6u], Biases.b3[7u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3979 = f16vec2(_3976.x);
    f16vec2 _3980 = f16vec2(_3976.y);
    f16vec2 _4098 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[344u], Weights.w3[345u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[296u], Weights.w3[297u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[248u], Weights.w3[249u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[200u], Weights.w3[201u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[152u], Weights.w3[153u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[104u], Weights.w3[105u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[56u], Weights.w3[57u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[8u], Weights.w3[9u]), f16vec2(Biases.b3[8u], Biases.b3[9u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4101 = f16vec2(_4098.x);
    f16vec2 _4102 = f16vec2(_4098.y);
    f16vec2 _4114 = fma(_4102, f16vec2(Weights.w4[72u], Weights.w4[73u]), fma(_4101, f16vec2(Weights.w4[64u], Weights.w4[65u]), fma(_3980, f16vec2(Weights.w4[56u], Weights.w4[57u]), fma(_3979, f16vec2(Weights.w4[48u], Weights.w4[49u]), fma(_3858, f16vec2(Weights.w4[40u], Weights.w4[41u]), fma(_3857, f16vec2(Weights.w4[32u], Weights.w4[33u]), fma(_3736, f16vec2(Weights.w4[24u], Weights.w4[25u]), fma(_3735, f16vec2(Weights.w4[16u], Weights.w4[17u]), fma(_3614, f16vec2(Weights.w4[8u], Weights.w4[9u]), fma(_3613, f16vec2(Weights.w4[0u], Weights.w4[1u]), f16vec2(Biases.b4[0u], Biases.b4[1u])))))))))));
    f16vec2 _4126 = fma(_4102, f16vec2(Weights.w4[74u], Weights.w4[75u]), fma(_4101, f16vec2(Weights.w4[66u], Weights.w4[67u]), fma(_3980, f16vec2(Weights.w4[58u], Weights.w4[59u]), fma(_3979, f16vec2(Weights.w4[50u], Weights.w4[51u]), fma(_3858, f16vec2(Weights.w4[42u], Weights.w4[43u]), fma(_3857, f16vec2(Weights.w4[34u], Weights.w4[35u]), fma(_3736, f16vec2(Weights.w4[26u], Weights.w4[27u]), fma(_3735, f16vec2(Weights.w4[18u], Weights.w4[19u]), fma(_3614, f16vec2(Weights.w4[10u], Weights.w4[11u]), fma(_3613, f16vec2(Weights.w4[2u], Weights.w4[3u]), f16vec2(Biases.b4[2u], Biases.b4[3u])))))))))));
    f16vec2 _4138 = fma(_4102, f16vec2(Weights.w4[76u], Weights.w4[77u]), fma(_4101, f16vec2(Weights.w4[68u], Weights.w4[69u]), fma(_3980, f16vec2(Weights.w4[60u], Weights.w4[61u]), fma(_3979, f16vec2(Weights.w4[52u], Weights.w4[53u]), fma(_3858, f16vec2(Weights.w4[44u], Weights.w4[45u]), fma(_3857, f16vec2(Weights.w4[36u], Weights.w4[37u]), fma(_3736, f16vec2(Weights.w4[28u], Weights.w4[29u]), fma(_3735, f16vec2(Weights.w4[20u], Weights.w4[21u]), fma(_3614, f16vec2(Weights.w4[12u], Weights.w4[13u]), fma(_3613, f16vec2(Weights.w4[4u], Weights.w4[5u]), f16vec2(Biases.b4[4u], Biases.b4[5u])))))))))));
    f16vec2 _4150 = fma(_4102, f16vec2(Weights.w4[78u], Weights.w4[79u]), fma(_4101, f16vec2(Weights.w4[70u], Weights.w4[71u]), fma(_3980, f16vec2(Weights.w4[62u], Weights.w4[63u]), fma(_3979, f16vec2(Weights.w4[54u], Weights.w4[55u]), fma(_3858, f16vec2(Weights.w4[46u], Weights.w4[47u]), fma(_3857, f16vec2(Weights.w4[38u], Weights.w4[39u]), fma(_3736, f16vec2(Weights.w4[30u], Weights.w4[31u]), fma(_3735, f16vec2(Weights.w4[22u], Weights.w4[23u]), fma(_3614, f16vec2(Weights.w4[14u], Weights.w4[15u]), fma(_3613, f16vec2(Weights.w4[6u], Weights.w4[7u]), f16vec2(Biases.b4[6u], Biases.b4[7u])))))))))));
    f16vec2 _4220 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[346u], Weights.w3[347u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[298u], Weights.w3[299u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[250u], Weights.w3[251u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[202u], Weights.w3[203u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[154u], Weights.w3[155u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[106u], Weights.w3[107u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[58u], Weights.w3[59u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[10u], Weights.w3[11u]), f16vec2(Biases.b3[10u], Biases.b3[11u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4223 = f16vec2(_4220.x);
    f16vec2 _4224 = f16vec2(_4220.y);
    f16vec2 _4342 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[348u], Weights.w3[349u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[300u], Weights.w3[301u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[252u], Weights.w3[253u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[204u], Weights.w3[205u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[156u], Weights.w3[157u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[108u], Weights.w3[109u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[60u], Weights.w3[61u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[12u], Weights.w3[13u]), f16vec2(Biases.b3[12u], Biases.b3[13u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4345 = f16vec2(_4342.x);
    f16vec2 _4346 = f16vec2(_4342.y);
    f16vec2 _4464 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[350u], Weights.w3[351u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[302u], Weights.w3[303u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[254u], Weights.w3[255u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[206u], Weights.w3[207u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[158u], Weights.w3[159u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[110u], Weights.w3[111u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[62u], Weights.w3[63u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[14u], Weights.w3[15u]), f16vec2(Biases.b3[14u], Biases.b3[15u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4467 = f16vec2(_4464.x);
    f16vec2 _4468 = f16vec2(_4464.y);
    f16vec2 _4586 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[352u], Weights.w3[353u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[304u], Weights.w3[305u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[256u], Weights.w3[257u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[208u], Weights.w3[209u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[160u], Weights.w3[161u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[112u], Weights.w3[113u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[64u], Weights.w3[65u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[16u], Weights.w3[17u]), f16vec2(Biases.b3[16u], Biases.b3[17u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4589 = f16vec2(_4586.x);
    f16vec2 _4590 = f16vec2(_4586.y);
    f16vec2 _4708 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[354u], Weights.w3[355u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[306u], Weights.w3[307u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[258u], Weights.w3[259u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[210u], Weights.w3[211u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[162u], Weights.w3[163u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[114u], Weights.w3[115u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[66u], Weights.w3[67u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[18u], Weights.w3[19u]), f16vec2(Biases.b3[18u], Biases.b3[19u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4711 = f16vec2(_4708.x);
    f16vec2 _4712 = f16vec2(_4708.y);
    f16vec2 _4724 = fma(_4712, f16vec2(Weights.w4[152u], Weights.w4[153u]), fma(_4711, f16vec2(Weights.w4[144u], Weights.w4[145u]), fma(_4590, f16vec2(Weights.w4[136u], Weights.w4[137u]), fma(_4589, f16vec2(Weights.w4[128u], Weights.w4[129u]), fma(_4468, f16vec2(Weights.w4[120u], Weights.w4[121u]), fma(_4467, f16vec2(Weights.w4[112u], Weights.w4[113u]), fma(_4346, f16vec2(Weights.w4[104u], Weights.w4[105u]), fma(_4345, f16vec2(Weights.w4[96u], Weights.w4[97u]), fma(_4224, f16vec2(Weights.w4[88u], Weights.w4[89u]), fma(_4223, f16vec2(Weights.w4[80u], Weights.w4[81u]), _4114))))))))));
    f16vec2 _4736 = fma(_4712, f16vec2(Weights.w4[154u], Weights.w4[155u]), fma(_4711, f16vec2(Weights.w4[146u], Weights.w4[147u]), fma(_4590, f16vec2(Weights.w4[138u], Weights.w4[139u]), fma(_4589, f16vec2(Weights.w4[130u], Weights.w4[131u]), fma(_4468, f16vec2(Weights.w4[122u], Weights.w4[123u]), fma(_4467, f16vec2(Weights.w4[114u], Weights.w4[115u]), fma(_4346, f16vec2(Weights.w4[106u], Weights.w4[107u]), fma(_4345, f16vec2(Weights.w4[98u], Weights.w4[99u]), fma(_4224, f16vec2(Weights.w4[90u], Weights.w4[91u]), fma(_4223, f16vec2(Weights.w4[82u], Weights.w4[83u]), _4126))))))))));
    f16vec2 _4748 = fma(_4712, f16vec2(Weights.w4[156u], Weights.w4[157u]), fma(_4711, f16vec2(Weights.w4[148u], Weights.w4[149u]), fma(_4590, f16vec2(Weights.w4[140u], Weights.w4[141u]), fma(_4589, f16vec2(Weights.w4[132u], Weights.w4[133u]), fma(_4468, f16vec2(Weights.w4[124u], Weights.w4[125u]), fma(_4467, f16vec2(Weights.w4[116u], Weights.w4[117u]), fma(_4346, f16vec2(Weights.w4[108u], Weights.w4[109u]), fma(_4345, f16vec2(Weights.w4[100u], Weights.w4[101u]), fma(_4224, f16vec2(Weights.w4[92u], Weights.w4[93u]), fma(_4223, f16vec2(Weights.w4[84u], Weights.w4[85u]), _4138))))))))));
    f16vec2 _4760 = fma(_4712, f16vec2(Weights.w4[158u], Weights.w4[159u]), fma(_4711, f16vec2(Weights.w4[150u], Weights.w4[151u]), fma(_4590, f16vec2(Weights.w4[142u], Weights.w4[143u]), fma(_4589, f16vec2(Weights.w4[134u], Weights.w4[135u]), fma(_4468, f16vec2(Weights.w4[126u], Weights.w4[127u]), fma(_4467, f16vec2(Weights.w4[118u], Weights.w4[119u]), fma(_4346, f16vec2(Weights.w4[110u], Weights.w4[111u]), fma(_4345, f16vec2(Weights.w4[102u], Weights.w4[103u]), fma(_4224, f16vec2(Weights.w4[94u], Weights.w4[95u]), fma(_4223, f16vec2(Weights.w4[86u], Weights.w4[87u]), _4150))))))))));
    f16vec2 _4830 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[356u], Weights.w3[357u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[308u], Weights.w3[309u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[260u], Weights.w3[261u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[212u], Weights.w3[213u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[164u], Weights.w3[165u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[116u], Weights.w3[117u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[68u], Weights.w3[69u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[20u], Weights.w3[21u]), f16vec2(Biases.b3[20u], Biases.b3[21u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4833 = f16vec2(_4830.x);
    f16vec2 _4834 = f16vec2(_4830.y);
    f16vec2 _4952 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[358u], Weights.w3[359u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[310u], Weights.w3[311u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[262u], Weights.w3[263u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[214u], Weights.w3[215u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[166u], Weights.w3[167u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[118u], Weights.w3[119u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[70u], Weights.w3[71u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[22u], Weights.w3[23u]), f16vec2(Biases.b3[22u], Biases.b3[23u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _4955 = f16vec2(_4952.x);
    f16vec2 _4956 = f16vec2(_4952.y);
    f16vec2 _5074 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[360u], Weights.w3[361u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[312u], Weights.w3[313u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[264u], Weights.w3[265u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[216u], Weights.w3[217u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[168u], Weights.w3[169u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[120u], Weights.w3[121u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[72u], Weights.w3[73u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[24u], Weights.w3[25u]), f16vec2(Biases.b3[24u], Biases.b3[25u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5077 = f16vec2(_5074.x);
    f16vec2 _5078 = f16vec2(_5074.y);
    f16vec2 _5196 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[362u], Weights.w3[363u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[314u], Weights.w3[315u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[266u], Weights.w3[267u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[218u], Weights.w3[219u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[170u], Weights.w3[171u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[122u], Weights.w3[123u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[74u], Weights.w3[75u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[26u], Weights.w3[27u]), f16vec2(Biases.b3[26u], Biases.b3[27u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5199 = f16vec2(_5196.x);
    f16vec2 _5200 = f16vec2(_5196.y);
    f16vec2 _5318 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[364u], Weights.w3[365u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[316u], Weights.w3[317u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[268u], Weights.w3[269u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[220u], Weights.w3[221u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[172u], Weights.w3[173u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[124u], Weights.w3[125u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[76u], Weights.w3[77u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[28u], Weights.w3[29u]), f16vec2(Biases.b3[28u], Biases.b3[29u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5321 = f16vec2(_5318.x);
    f16vec2 _5322 = f16vec2(_5318.y);
    f16vec2 _5334 = fma(_5322, f16vec2(Weights.w4[232u], Weights.w4[233u]), fma(_5321, f16vec2(Weights.w4[224u], Weights.w4[225u]), fma(_5200, f16vec2(Weights.w4[216u], Weights.w4[217u]), fma(_5199, f16vec2(Weights.w4[208u], Weights.w4[209u]), fma(_5078, f16vec2(Weights.w4[200u], Weights.w4[201u]), fma(_5077, f16vec2(Weights.w4[192u], Weights.w4[193u]), fma(_4956, f16vec2(Weights.w4[184u], Weights.w4[185u]), fma(_4955, f16vec2(Weights.w4[176u], Weights.w4[177u]), fma(_4834, f16vec2(Weights.w4[168u], Weights.w4[169u]), fma(_4833, f16vec2(Weights.w4[160u], Weights.w4[161u]), _4724))))))))));
    f16vec2 _5346 = fma(_5322, f16vec2(Weights.w4[234u], Weights.w4[235u]), fma(_5321, f16vec2(Weights.w4[226u], Weights.w4[227u]), fma(_5200, f16vec2(Weights.w4[218u], Weights.w4[219u]), fma(_5199, f16vec2(Weights.w4[210u], Weights.w4[211u]), fma(_5078, f16vec2(Weights.w4[202u], Weights.w4[203u]), fma(_5077, f16vec2(Weights.w4[194u], Weights.w4[195u]), fma(_4956, f16vec2(Weights.w4[186u], Weights.w4[187u]), fma(_4955, f16vec2(Weights.w4[178u], Weights.w4[179u]), fma(_4834, f16vec2(Weights.w4[170u], Weights.w4[171u]), fma(_4833, f16vec2(Weights.w4[162u], Weights.w4[163u]), _4736))))))))));
    f16vec2 _5358 = fma(_5322, f16vec2(Weights.w4[236u], Weights.w4[237u]), fma(_5321, f16vec2(Weights.w4[228u], Weights.w4[229u]), fma(_5200, f16vec2(Weights.w4[220u], Weights.w4[221u]), fma(_5199, f16vec2(Weights.w4[212u], Weights.w4[213u]), fma(_5078, f16vec2(Weights.w4[204u], Weights.w4[205u]), fma(_5077, f16vec2(Weights.w4[196u], Weights.w4[197u]), fma(_4956, f16vec2(Weights.w4[188u], Weights.w4[189u]), fma(_4955, f16vec2(Weights.w4[180u], Weights.w4[181u]), fma(_4834, f16vec2(Weights.w4[172u], Weights.w4[173u]), fma(_4833, f16vec2(Weights.w4[164u], Weights.w4[165u]), _4748))))))))));
    f16vec2 _5370 = fma(_5322, f16vec2(Weights.w4[238u], Weights.w4[239u]), fma(_5321, f16vec2(Weights.w4[230u], Weights.w4[231u]), fma(_5200, f16vec2(Weights.w4[222u], Weights.w4[223u]), fma(_5199, f16vec2(Weights.w4[214u], Weights.w4[215u]), fma(_5078, f16vec2(Weights.w4[206u], Weights.w4[207u]), fma(_5077, f16vec2(Weights.w4[198u], Weights.w4[199u]), fma(_4956, f16vec2(Weights.w4[190u], Weights.w4[191u]), fma(_4955, f16vec2(Weights.w4[182u], Weights.w4[183u]), fma(_4834, f16vec2(Weights.w4[174u], Weights.w4[175u]), fma(_4833, f16vec2(Weights.w4[166u], Weights.w4[167u]), _4760))))))))));
    f16vec2 _5440 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[366u], Weights.w3[367u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[318u], Weights.w3[319u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[270u], Weights.w3[271u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[222u], Weights.w3[223u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[174u], Weights.w3[175u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[126u], Weights.w3[127u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[78u], Weights.w3[79u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[30u], Weights.w3[31u]), f16vec2(Biases.b3[30u], Biases.b3[31u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5443 = f16vec2(_5440.x);
    f16vec2 _5444 = f16vec2(_5440.y);
    f16vec2 _5562 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[368u], Weights.w3[369u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[320u], Weights.w3[321u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[272u], Weights.w3[273u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[224u], Weights.w3[225u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[176u], Weights.w3[177u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[128u], Weights.w3[129u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[80u], Weights.w3[81u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[32u], Weights.w3[33u]), f16vec2(Biases.b3[32u], Biases.b3[33u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5565 = f16vec2(_5562.x);
    f16vec2 _5566 = f16vec2(_5562.y);
    f16vec2 _5684 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[370u], Weights.w3[371u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[322u], Weights.w3[323u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[274u], Weights.w3[275u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[226u], Weights.w3[227u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[178u], Weights.w3[179u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[130u], Weights.w3[131u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[82u], Weights.w3[83u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[34u], Weights.w3[35u]), f16vec2(Biases.b3[34u], Biases.b3[35u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5687 = f16vec2(_5684.x);
    f16vec2 _5688 = f16vec2(_5684.y);
    f16vec2 _5806 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[372u], Weights.w3[373u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[324u], Weights.w3[325u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[276u], Weights.w3[277u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[228u], Weights.w3[229u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[180u], Weights.w3[181u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[132u], Weights.w3[133u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[84u], Weights.w3[85u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[36u], Weights.w3[37u]), f16vec2(Biases.b3[36u], Biases.b3[37u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5809 = f16vec2(_5806.x);
    f16vec2 _5810 = f16vec2(_5806.y);
    f16vec2 _5928 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[374u], Weights.w3[375u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[326u], Weights.w3[327u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[278u], Weights.w3[279u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[230u], Weights.w3[231u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[182u], Weights.w3[183u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[134u], Weights.w3[135u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[86u], Weights.w3[87u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[38u], Weights.w3[39u]), f16vec2(Biases.b3[38u], Biases.b3[39u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _5931 = f16vec2(_5928.x);
    f16vec2 _5932 = f16vec2(_5928.y);
    f16vec2 _5944 = fma(_5932, f16vec2(Weights.w4[312u], Weights.w4[313u]), fma(_5931, f16vec2(Weights.w4[304u], Weights.w4[305u]), fma(_5810, f16vec2(Weights.w4[296u], Weights.w4[297u]), fma(_5809, f16vec2(Weights.w4[288u], Weights.w4[289u]), fma(_5688, f16vec2(Weights.w4[280u], Weights.w4[281u]), fma(_5687, f16vec2(Weights.w4[272u], Weights.w4[273u]), fma(_5566, f16vec2(Weights.w4[264u], Weights.w4[265u]), fma(_5565, f16vec2(Weights.w4[256u], Weights.w4[257u]), fma(_5444, f16vec2(Weights.w4[248u], Weights.w4[249u]), fma(_5443, f16vec2(Weights.w4[240u], Weights.w4[241u]), _5334))))))))));
    f16vec2 _5956 = fma(_5932, f16vec2(Weights.w4[314u], Weights.w4[315u]), fma(_5931, f16vec2(Weights.w4[306u], Weights.w4[307u]), fma(_5810, f16vec2(Weights.w4[298u], Weights.w4[299u]), fma(_5809, f16vec2(Weights.w4[290u], Weights.w4[291u]), fma(_5688, f16vec2(Weights.w4[282u], Weights.w4[283u]), fma(_5687, f16vec2(Weights.w4[274u], Weights.w4[275u]), fma(_5566, f16vec2(Weights.w4[266u], Weights.w4[267u]), fma(_5565, f16vec2(Weights.w4[258u], Weights.w4[259u]), fma(_5444, f16vec2(Weights.w4[250u], Weights.w4[251u]), fma(_5443, f16vec2(Weights.w4[242u], Weights.w4[243u]), _5346))))))))));
    f16vec2 _5968 = fma(_5932, f16vec2(Weights.w4[316u], Weights.w4[317u]), fma(_5931, f16vec2(Weights.w4[308u], Weights.w4[309u]), fma(_5810, f16vec2(Weights.w4[300u], Weights.w4[301u]), fma(_5809, f16vec2(Weights.w4[292u], Weights.w4[293u]), fma(_5688, f16vec2(Weights.w4[284u], Weights.w4[285u]), fma(_5687, f16vec2(Weights.w4[276u], Weights.w4[277u]), fma(_5566, f16vec2(Weights.w4[268u], Weights.w4[269u]), fma(_5565, f16vec2(Weights.w4[260u], Weights.w4[261u]), fma(_5444, f16vec2(Weights.w4[252u], Weights.w4[253u]), fma(_5443, f16vec2(Weights.w4[244u], Weights.w4[245u]), _5358))))))))));
    f16vec2 _5980 = fma(_5932, f16vec2(Weights.w4[318u], Weights.w4[319u]), fma(_5931, f16vec2(Weights.w4[310u], Weights.w4[311u]), fma(_5810, f16vec2(Weights.w4[302u], Weights.w4[303u]), fma(_5809, f16vec2(Weights.w4[294u], Weights.w4[295u]), fma(_5688, f16vec2(Weights.w4[286u], Weights.w4[287u]), fma(_5687, f16vec2(Weights.w4[278u], Weights.w4[279u]), fma(_5566, f16vec2(Weights.w4[270u], Weights.w4[271u]), fma(_5565, f16vec2(Weights.w4[262u], Weights.w4[263u]), fma(_5444, f16vec2(Weights.w4[254u], Weights.w4[255u]), fma(_5443, f16vec2(Weights.w4[246u], Weights.w4[247u]), _5370))))))))));
    f16vec2 _6050 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[376u], Weights.w3[377u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[328u], Weights.w3[329u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[280u], Weights.w3[281u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[232u], Weights.w3[233u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[184u], Weights.w3[185u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[136u], Weights.w3[137u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[88u], Weights.w3[89u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[40u], Weights.w3[41u]), f16vec2(Biases.b3[40u], Biases.b3[41u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _6053 = f16vec2(_6050.x);
    f16vec2 _6054 = f16vec2(_6050.y);
    f16vec2 _6172 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[378u], Weights.w3[379u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[330u], Weights.w3[331u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[282u], Weights.w3[283u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[234u], Weights.w3[235u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[186u], Weights.w3[187u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[138u], Weights.w3[139u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[90u], Weights.w3[91u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[42u], Weights.w3[43u]), f16vec2(Biases.b3[42u], Biases.b3[43u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _6175 = f16vec2(_6172.x);
    f16vec2 _6176 = f16vec2(_6172.y);
    f16vec2 _6294 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[380u], Weights.w3[381u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[332u], Weights.w3[333u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[284u], Weights.w3[285u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[236u], Weights.w3[237u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[188u], Weights.w3[189u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[140u], Weights.w3[141u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[92u], Weights.w3[93u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[44u], Weights.w3[45u]), f16vec2(Biases.b3[44u], Biases.b3[45u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _6297 = f16vec2(_6294.x);
    f16vec2 _6298 = f16vec2(_6294.y);
    f16vec2 _6416 = max(fma(f16vec2(_6629[3].y), f16vec2(Weights.w3[382u], Weights.w3[383u]), fma(f16vec2(_6629[3].x), f16vec2(Weights.w3[334u], Weights.w3[335u]), fma(f16vec2(_6629[2].y), f16vec2(Weights.w3[286u], Weights.w3[287u]), fma(f16vec2(_6629[2].x), f16vec2(Weights.w3[238u], Weights.w3[239u]), fma(f16vec2(_6629[1].y), f16vec2(Weights.w3[190u], Weights.w3[191u]), fma(f16vec2(_6629[1].x), f16vec2(Weights.w3[142u], Weights.w3[143u]), fma(f16vec2(_6629[0].y), f16vec2(Weights.w3[94u], Weights.w3[95u]), fma(f16vec2(_6629[0].x), f16vec2(Weights.w3[46u], Weights.w3[47u]), f16vec2(Biases.b3[46u], Biases.b3[47u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _6419 = f16vec2(_6416.x);
    f16vec2 _6420 = f16vec2(_6416.y);
    f16vec2 _141[4] = f16vec2[](f16vec2(fma(_6420, f16vec2(Weights.w4[376u], Weights.w4[377u]), fma(_6419, f16vec2(Weights.w4[368u], Weights.w4[369u]), fma(_6298, f16vec2(Weights.w4[360u], Weights.w4[361u]), fma(_6297, f16vec2(Weights.w4[352u], Weights.w4[353u]), fma(_6176, f16vec2(Weights.w4[344u], Weights.w4[345u]), fma(_6175, f16vec2(Weights.w4[336u], Weights.w4[337u]), fma(_6054, f16vec2(Weights.w4[328u], Weights.w4[329u]), fma(_6053, f16vec2(Weights.w4[320u], Weights.w4[321u]), _5944))))))))), f16vec2(fma(_6420, f16vec2(Weights.w4[378u], Weights.w4[379u]), fma(_6419, f16vec2(Weights.w4[370u], Weights.w4[371u]), fma(_6298, f16vec2(Weights.w4[362u], Weights.w4[363u]), fma(_6297, f16vec2(Weights.w4[354u], Weights.w4[355u]), fma(_6176, f16vec2(Weights.w4[346u], Weights.w4[347u]), fma(_6175, f16vec2(Weights.w4[338u], Weights.w4[339u]), fma(_6054, f16vec2(Weights.w4[330u], Weights.w4[331u]), fma(_6053, f16vec2(Weights.w4[322u], Weights.w4[323u]), _5956))))))))), f16vec2(fma(_6420, f16vec2(Weights.w4[380u], Weights.w4[381u]), fma(_6419, f16vec2(Weights.w4[372u], Weights.w4[373u]), fma(_6298, f16vec2(Weights.w4[364u], Weights.w4[365u]), fma(_6297, f16vec2(Weights.w4[356u], Weights.w4[357u]), fma(_6176, f16vec2(Weights.w4[348u], Weights.w4[349u]), fma(_6175, f16vec2(Weights.w4[340u], Weights.w4[341u]), fma(_6054, f16vec2(Weights.w4[332u], Weights.w4[333u]), fma(_6053, f16vec2(Weights.w4[324u], Weights.w4[325u]), _5968))))))))), f16vec2(fma(_6420, f16vec2(Weights.w4[382u], Weights.w4[383u]), fma(_6419, f16vec2(Weights.w4[374u], Weights.w4[375u]), fma(_6298, f16vec2(Weights.w4[366u], Weights.w4[367u]), fma(_6297, f16vec2(Weights.w4[358u], Weights.w4[359u]), fma(_6176, f16vec2(Weights.w4[350u], Weights.w4[351u]), fma(_6175, f16vec2(Weights.w4[342u], Weights.w4[343u]), fma(_6054, f16vec2(Weights.w4[334u], Weights.w4[335u]), fma(_6053, f16vec2(Weights.w4[326u], Weights.w4[327u]), _5980))))))))));
    f16vec2 tempArg_2[4] = _141;
    f16vec2 h4[4] = _141;
    f16vec2 _6652[4] = _141;
    uint _6651 = 0u;
    f16vec2 _6650[4];
    uint _6658;
    for (;;)
    {
        _6658 = _6651;
        if (_6658 < 4u)
        {
            _6650[_6658] = max(_6652[_6658], _100[_6658]);
            _6651 = _6658 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    h4 = _6650;
    f16vec2 _168[2] = _6514(_6650);
    f16vec2 tempArg_3[2] = _168;
    f16vec2 y[2] = _168;
    f16vec2 _6669[2] = _168;
    uint _6668 = 0u;
    f16vec2 _6667[2];
    uint _6675;
    for (;;)
    {
        _6675 = _6668;
        if (_6675 < 2u)
        {
            _6667[_6675] = max(_6669[_6675], _172[_6675]);
            _6668 = _6675 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _6667;
    f16vec2 _6695[2] = _6667;
    uint _6696 = 0u;
    uint _6701;
    for (;;)
    {
        _6701 = _6696;
        if (_6701 < 4u)
        {
            _6685(0u + _6701, _6695[_6701 / 2u]);
            _6696 = _6701 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

