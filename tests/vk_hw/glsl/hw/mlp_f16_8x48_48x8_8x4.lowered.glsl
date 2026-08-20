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
    float16_t x[48];
} InX;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[384];
    float16_t w2[384];
    float16_t w3[32];
} Weights;

layout(set = 0, binding = 2, std430) buffer PackedBias
{
    float16_t b1[48];
    float16_t b2[8];
    float16_t b3[4];
} Biases;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[4];
} OutY;

f16vec2 _3598(uint _3599)
{
    return f16vec2(InX.x[_3599], InX.x[_3599 + 1u]);
}

f16vec2 _3490(uint _3491)
{
    return f16vec2(Weights.w3[_3491], Weights.w3[_3491 + 1u]);
}

f16vec2 _3500(uint _3501)
{
    return f16vec2(Biases.b3[_3501], Biases.b3[_3501 + 1u]);
}

f16vec2[2] _3511(f16vec2 _3512[4])
{
    f16vec2 _3529[4] = _3512;
    uint _3525 = 0u;
    f16vec2 _3524[2];
    uint _3532;
    for (;;)
    {
        _3532 = _3525;
        if (_3532 < 2u)
        {
            f16vec2 _3527 = f16vec2(float16_t(0.0));
            f16vec2 _3528 = f16vec2(float16_t(0.0));
            uint _3526 = 0u;
            uint _3534;
            for (;;)
            {
                _3534 = _3526;
                if (_3534 < 4u)
                {
                    uint _3536 = _3534 * 2u;
                    uint _3537 = _3532 * 2u;
                    uint _3541 = (_3536 * 4u) + _3537;
                    f16vec2 _3554 = _3490(((uint(0) + (_3541 / 4u)) * uint(4)) + (uint(0) + (_3541 % 4u)));
                    uint _3557 = ((_3536 + 1u) * 4u) + _3537;
                    f16vec2 _3570 = _3490(((uint(0) + (_3557 / 4u)) * uint(4)) + (uint(0) + (_3557 % 4u)));
                    _3527 = fma(_3529[_3534], f16vec2(_3554.x, _3570.x), _3527);
                    _3528 = fma(_3529[_3534], f16vec2(_3554.y, _3570.y), _3528);
                    _3526 = _3534 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _3524[_3532] = f16vec2(_3527.x + _3527.y, _3528.x + _3528.y) + _3500(_3532 * 2u);
            _3525 = _3532 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _3524;
}

void _3661(uint _3662, f16vec2 _3663)
{
    OutY.y[_3662] = _3663.x;
    OutY.y[_3662 + 1u] = _3663.y;
}

void main()
{
    uint _3609 = 0u;
    f16vec2 _3608[4];
    uint _3614;
    for (;;)
    {
        _3614 = _3609;
        if (_3614 < 8u)
        {
            _3608[_3614 / 2u] = _3598(0u + _3614);
            _3609 = _3614 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _22[4] = _3608;
    f16vec2 tempArg[4] = _22;
    f16vec2 x[4] = _22;
    f16vec2 _247 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[336u], Weights.w1[337u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[288u], Weights.w1[289u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[240u], Weights.w1[241u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[192u], Weights.w1[193u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[144u], Weights.w1[145u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[96u], Weights.w1[97u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[48u], Weights.w1[49u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[0u], Weights.w1[1u]), f16vec2(Biases.b1[0u], Biases.b1[1u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _250 = f16vec2(_247.x);
    f16vec2 _251 = f16vec2(_247.y);
    f16vec2 _390 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[338u], Weights.w1[339u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[290u], Weights.w1[291u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[242u], Weights.w1[243u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[194u], Weights.w1[195u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[146u], Weights.w1[147u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[98u], Weights.w1[99u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[50u], Weights.w1[51u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[2u], Weights.w1[3u]), f16vec2(Biases.b1[2u], Biases.b1[3u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _393 = f16vec2(_390.x);
    f16vec2 _394 = f16vec2(_390.y);
    f16vec2 _542 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[340u], Weights.w1[341u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[292u], Weights.w1[293u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[244u], Weights.w1[245u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[196u], Weights.w1[197u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[148u], Weights.w1[149u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[100u], Weights.w1[101u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[52u], Weights.w1[53u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[4u], Weights.w1[5u]), f16vec2(Biases.b1[4u], Biases.b1[5u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _545 = f16vec2(_542.x);
    f16vec2 _546 = f16vec2(_542.y);
    f16vec2 _693 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[342u], Weights.w1[343u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[294u], Weights.w1[295u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[246u], Weights.w1[247u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[198u], Weights.w1[199u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[150u], Weights.w1[151u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[102u], Weights.w1[103u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[54u], Weights.w1[55u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[6u], Weights.w1[7u]), f16vec2(Biases.b1[6u], Biases.b1[7u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _696 = f16vec2(_693.x);
    f16vec2 _697 = f16vec2(_693.y);
    f16vec2 _835 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[344u], Weights.w1[345u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[296u], Weights.w1[297u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[248u], Weights.w1[249u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[200u], Weights.w1[201u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[152u], Weights.w1[153u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[104u], Weights.w1[105u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[56u], Weights.w1[57u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[8u], Weights.w1[9u]), f16vec2(Biases.b1[8u], Biases.b1[9u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _838 = f16vec2(_835.x);
    f16vec2 _839 = f16vec2(_835.y);
    f16vec2 _855 = fma(_839, f16vec2(Weights.w2[72u], Weights.w2[73u]), fma(_838, f16vec2(Weights.w2[64u], Weights.w2[65u]), fma(_697, f16vec2(Weights.w2[56u], Weights.w2[57u]), fma(_696, f16vec2(Weights.w2[48u], Weights.w2[49u]), fma(_546, f16vec2(Weights.w2[40u], Weights.w2[41u]), fma(_545, f16vec2(Weights.w2[32u], Weights.w2[33u]), fma(_394, f16vec2(Weights.w2[24u], Weights.w2[25u]), fma(_393, f16vec2(Weights.w2[16u], Weights.w2[17u]), fma(_251, f16vec2(Weights.w2[8u], Weights.w2[9u]), fma(_250, f16vec2(Weights.w2[0u], Weights.w2[1u]), f16vec2(Biases.b2[0u], Biases.b2[1u])))))))))));
    f16vec2 _871 = fma(_839, f16vec2(Weights.w2[74u], Weights.w2[75u]), fma(_838, f16vec2(Weights.w2[66u], Weights.w2[67u]), fma(_697, f16vec2(Weights.w2[58u], Weights.w2[59u]), fma(_696, f16vec2(Weights.w2[50u], Weights.w2[51u]), fma(_546, f16vec2(Weights.w2[42u], Weights.w2[43u]), fma(_545, f16vec2(Weights.w2[34u], Weights.w2[35u]), fma(_394, f16vec2(Weights.w2[26u], Weights.w2[27u]), fma(_393, f16vec2(Weights.w2[18u], Weights.w2[19u]), fma(_251, f16vec2(Weights.w2[10u], Weights.w2[11u]), fma(_250, f16vec2(Weights.w2[2u], Weights.w2[3u]), f16vec2(Biases.b2[2u], Biases.b2[3u])))))))))));
    f16vec2 _887 = fma(_839, f16vec2(Weights.w2[76u], Weights.w2[77u]), fma(_838, f16vec2(Weights.w2[68u], Weights.w2[69u]), fma(_697, f16vec2(Weights.w2[60u], Weights.w2[61u]), fma(_696, f16vec2(Weights.w2[52u], Weights.w2[53u]), fma(_546, f16vec2(Weights.w2[44u], Weights.w2[45u]), fma(_545, f16vec2(Weights.w2[36u], Weights.w2[37u]), fma(_394, f16vec2(Weights.w2[28u], Weights.w2[29u]), fma(_393, f16vec2(Weights.w2[20u], Weights.w2[21u]), fma(_251, f16vec2(Weights.w2[12u], Weights.w2[13u]), fma(_250, f16vec2(Weights.w2[4u], Weights.w2[5u]), f16vec2(Biases.b2[4u], Biases.b2[5u])))))))))));
    f16vec2 _903 = fma(_839, f16vec2(Weights.w2[78u], Weights.w2[79u]), fma(_838, f16vec2(Weights.w2[70u], Weights.w2[71u]), fma(_697, f16vec2(Weights.w2[62u], Weights.w2[63u]), fma(_696, f16vec2(Weights.w2[54u], Weights.w2[55u]), fma(_546, f16vec2(Weights.w2[46u], Weights.w2[47u]), fma(_545, f16vec2(Weights.w2[38u], Weights.w2[39u]), fma(_394, f16vec2(Weights.w2[30u], Weights.w2[31u]), fma(_393, f16vec2(Weights.w2[22u], Weights.w2[23u]), fma(_251, f16vec2(Weights.w2[14u], Weights.w2[15u]), fma(_250, f16vec2(Weights.w2[6u], Weights.w2[7u]), f16vec2(Biases.b2[6u], Biases.b2[7u])))))))))));
    f16vec2 _985 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[346u], Weights.w1[347u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[298u], Weights.w1[299u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[250u], Weights.w1[251u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[202u], Weights.w1[203u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[154u], Weights.w1[155u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[106u], Weights.w1[107u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[58u], Weights.w1[59u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[10u], Weights.w1[11u]), f16vec2(Biases.b1[10u], Biases.b1[11u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _988 = f16vec2(_985.x);
    f16vec2 _989 = f16vec2(_985.y);
    f16vec2 _1135 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[348u], Weights.w1[349u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[300u], Weights.w1[301u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[252u], Weights.w1[253u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[204u], Weights.w1[205u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[156u], Weights.w1[157u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[108u], Weights.w1[109u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[60u], Weights.w1[61u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[12u], Weights.w1[13u]), f16vec2(Biases.b1[12u], Biases.b1[13u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1138 = f16vec2(_1135.x);
    f16vec2 _1139 = f16vec2(_1135.y);
    f16vec2 _1269 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[350u], Weights.w1[351u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[302u], Weights.w1[303u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[254u], Weights.w1[255u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[206u], Weights.w1[207u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[158u], Weights.w1[159u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[110u], Weights.w1[111u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[62u], Weights.w1[63u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[14u], Weights.w1[15u]), f16vec2(Biases.b1[14u], Biases.b1[15u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1272 = f16vec2(_1269.x);
    f16vec2 _1273 = f16vec2(_1269.y);
    f16vec2 _1417 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[352u], Weights.w1[353u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[304u], Weights.w1[305u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[256u], Weights.w1[257u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[208u], Weights.w1[209u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[160u], Weights.w1[161u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[112u], Weights.w1[113u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[64u], Weights.w1[65u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[16u], Weights.w1[17u]), f16vec2(Biases.b1[16u], Biases.b1[17u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1420 = f16vec2(_1417.x);
    f16vec2 _1421 = f16vec2(_1417.y);
    f16vec2 _1565 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[354u], Weights.w1[355u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[306u], Weights.w1[307u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[258u], Weights.w1[259u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[210u], Weights.w1[211u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[162u], Weights.w1[163u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[114u], Weights.w1[115u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[66u], Weights.w1[67u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[18u], Weights.w1[19u]), f16vec2(Biases.b1[18u], Biases.b1[19u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1568 = f16vec2(_1565.x);
    f16vec2 _1569 = f16vec2(_1565.y);
    f16vec2 _1581 = fma(_1569, f16vec2(Weights.w2[152u], Weights.w2[153u]), fma(_1568, f16vec2(Weights.w2[144u], Weights.w2[145u]), fma(_1421, f16vec2(Weights.w2[136u], Weights.w2[137u]), fma(_1420, f16vec2(Weights.w2[128u], Weights.w2[129u]), fma(_1273, f16vec2(Weights.w2[120u], Weights.w2[121u]), fma(_1272, f16vec2(Weights.w2[112u], Weights.w2[113u]), fma(_1139, f16vec2(Weights.w2[104u], Weights.w2[105u]), fma(_1138, f16vec2(Weights.w2[96u], Weights.w2[97u]), fma(_989, f16vec2(Weights.w2[88u], Weights.w2[89u]), fma(_988, f16vec2(Weights.w2[80u], Weights.w2[81u]), _855))))))))));
    f16vec2 _1593 = fma(_1569, f16vec2(Weights.w2[154u], Weights.w2[155u]), fma(_1568, f16vec2(Weights.w2[146u], Weights.w2[147u]), fma(_1421, f16vec2(Weights.w2[138u], Weights.w2[139u]), fma(_1420, f16vec2(Weights.w2[130u], Weights.w2[131u]), fma(_1273, f16vec2(Weights.w2[122u], Weights.w2[123u]), fma(_1272, f16vec2(Weights.w2[114u], Weights.w2[115u]), fma(_1139, f16vec2(Weights.w2[106u], Weights.w2[107u]), fma(_1138, f16vec2(Weights.w2[98u], Weights.w2[99u]), fma(_989, f16vec2(Weights.w2[90u], Weights.w2[91u]), fma(_988, f16vec2(Weights.w2[82u], Weights.w2[83u]), _871))))))))));
    f16vec2 _1605 = fma(_1569, f16vec2(Weights.w2[156u], Weights.w2[157u]), fma(_1568, f16vec2(Weights.w2[148u], Weights.w2[149u]), fma(_1421, f16vec2(Weights.w2[140u], Weights.w2[141u]), fma(_1420, f16vec2(Weights.w2[132u], Weights.w2[133u]), fma(_1273, f16vec2(Weights.w2[124u], Weights.w2[125u]), fma(_1272, f16vec2(Weights.w2[116u], Weights.w2[117u]), fma(_1139, f16vec2(Weights.w2[108u], Weights.w2[109u]), fma(_1138, f16vec2(Weights.w2[100u], Weights.w2[101u]), fma(_989, f16vec2(Weights.w2[92u], Weights.w2[93u]), fma(_988, f16vec2(Weights.w2[84u], Weights.w2[85u]), _887))))))))));
    f16vec2 _1617 = fma(_1569, f16vec2(Weights.w2[158u], Weights.w2[159u]), fma(_1568, f16vec2(Weights.w2[150u], Weights.w2[151u]), fma(_1421, f16vec2(Weights.w2[142u], Weights.w2[143u]), fma(_1420, f16vec2(Weights.w2[134u], Weights.w2[135u]), fma(_1273, f16vec2(Weights.w2[126u], Weights.w2[127u]), fma(_1272, f16vec2(Weights.w2[118u], Weights.w2[119u]), fma(_1139, f16vec2(Weights.w2[110u], Weights.w2[111u]), fma(_1138, f16vec2(Weights.w2[102u], Weights.w2[103u]), fma(_989, f16vec2(Weights.w2[94u], Weights.w2[95u]), fma(_988, f16vec2(Weights.w2[86u], Weights.w2[87u]), _903))))))))));
    f16vec2 _1697 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[356u], Weights.w1[357u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[308u], Weights.w1[309u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[260u], Weights.w1[261u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[212u], Weights.w1[213u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[164u], Weights.w1[165u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[116u], Weights.w1[117u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[68u], Weights.w1[69u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[20u], Weights.w1[21u]), f16vec2(Biases.b1[20u], Biases.b1[21u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1700 = f16vec2(_1697.x);
    f16vec2 _1701 = f16vec2(_1697.y);
    f16vec2 _1837 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[358u], Weights.w1[359u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[310u], Weights.w1[311u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[262u], Weights.w1[263u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[214u], Weights.w1[215u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[166u], Weights.w1[167u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[118u], Weights.w1[119u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[70u], Weights.w1[71u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[22u], Weights.w1[23u]), f16vec2(Biases.b1[22u], Biases.b1[23u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1840 = f16vec2(_1837.x);
    f16vec2 _1841 = f16vec2(_1837.y);
    f16vec2 _1983 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[360u], Weights.w1[361u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[312u], Weights.w1[313u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[264u], Weights.w1[265u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[216u], Weights.w1[217u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[168u], Weights.w1[169u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[120u], Weights.w1[121u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[72u], Weights.w1[73u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[24u], Weights.w1[25u]), f16vec2(Biases.b1[24u], Biases.b1[25u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _1986 = f16vec2(_1983.x);
    f16vec2 _1987 = f16vec2(_1983.y);
    f16vec2 _2113 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[362u], Weights.w1[363u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[314u], Weights.w1[315u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[266u], Weights.w1[267u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[218u], Weights.w1[219u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[170u], Weights.w1[171u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[122u], Weights.w1[123u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[74u], Weights.w1[75u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[26u], Weights.w1[27u]), f16vec2(Biases.b1[26u], Biases.b1[27u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2116 = f16vec2(_2113.x);
    f16vec2 _2117 = f16vec2(_2113.y);
    f16vec2 _2245 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[364u], Weights.w1[365u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[316u], Weights.w1[317u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[268u], Weights.w1[269u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[220u], Weights.w1[221u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[172u], Weights.w1[173u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[124u], Weights.w1[125u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[76u], Weights.w1[77u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[28u], Weights.w1[29u]), f16vec2(Biases.b1[28u], Biases.b1[29u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2248 = f16vec2(_2245.x);
    f16vec2 _2249 = f16vec2(_2245.y);
    f16vec2 _2265 = fma(_2249, f16vec2(Weights.w2[232u], Weights.w2[233u]), fma(_2248, f16vec2(Weights.w2[224u], Weights.w2[225u]), fma(_2117, f16vec2(Weights.w2[216u], Weights.w2[217u]), fma(_2116, f16vec2(Weights.w2[208u], Weights.w2[209u]), fma(_1987, f16vec2(Weights.w2[200u], Weights.w2[201u]), fma(_1986, f16vec2(Weights.w2[192u], Weights.w2[193u]), fma(_1841, f16vec2(Weights.w2[184u], Weights.w2[185u]), fma(_1840, f16vec2(Weights.w2[176u], Weights.w2[177u]), fma(_1701, f16vec2(Weights.w2[168u], Weights.w2[169u]), fma(_1700, f16vec2(Weights.w2[160u], Weights.w2[161u]), _1581))))))))));
    f16vec2 _2281 = fma(_2249, f16vec2(Weights.w2[234u], Weights.w2[235u]), fma(_2248, f16vec2(Weights.w2[226u], Weights.w2[227u]), fma(_2117, f16vec2(Weights.w2[218u], Weights.w2[219u]), fma(_2116, f16vec2(Weights.w2[210u], Weights.w2[211u]), fma(_1987, f16vec2(Weights.w2[202u], Weights.w2[203u]), fma(_1986, f16vec2(Weights.w2[194u], Weights.w2[195u]), fma(_1841, f16vec2(Weights.w2[186u], Weights.w2[187u]), fma(_1840, f16vec2(Weights.w2[178u], Weights.w2[179u]), fma(_1701, f16vec2(Weights.w2[170u], Weights.w2[171u]), fma(_1700, f16vec2(Weights.w2[162u], Weights.w2[163u]), _1593))))))))));
    f16vec2 _2297 = fma(_2249, f16vec2(Weights.w2[236u], Weights.w2[237u]), fma(_2248, f16vec2(Weights.w2[228u], Weights.w2[229u]), fma(_2117, f16vec2(Weights.w2[220u], Weights.w2[221u]), fma(_2116, f16vec2(Weights.w2[212u], Weights.w2[213u]), fma(_1987, f16vec2(Weights.w2[204u], Weights.w2[205u]), fma(_1986, f16vec2(Weights.w2[196u], Weights.w2[197u]), fma(_1841, f16vec2(Weights.w2[188u], Weights.w2[189u]), fma(_1840, f16vec2(Weights.w2[180u], Weights.w2[181u]), fma(_1701, f16vec2(Weights.w2[172u], Weights.w2[173u]), fma(_1700, f16vec2(Weights.w2[164u], Weights.w2[165u]), _1605))))))))));
    f16vec2 _2313 = fma(_2249, f16vec2(Weights.w2[238u], Weights.w2[239u]), fma(_2248, f16vec2(Weights.w2[230u], Weights.w2[231u]), fma(_2117, f16vec2(Weights.w2[222u], Weights.w2[223u]), fma(_2116, f16vec2(Weights.w2[214u], Weights.w2[215u]), fma(_1987, f16vec2(Weights.w2[206u], Weights.w2[207u]), fma(_1986, f16vec2(Weights.w2[198u], Weights.w2[199u]), fma(_1841, f16vec2(Weights.w2[190u], Weights.w2[191u]), fma(_1840, f16vec2(Weights.w2[182u], Weights.w2[183u]), fma(_1701, f16vec2(Weights.w2[174u], Weights.w2[175u]), fma(_1700, f16vec2(Weights.w2[166u], Weights.w2[167u]), _1617))))))))));
    f16vec2 _2389 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[366u], Weights.w1[367u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[318u], Weights.w1[319u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[270u], Weights.w1[271u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[222u], Weights.w1[223u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[174u], Weights.w1[175u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[126u], Weights.w1[127u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[78u], Weights.w1[79u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[30u], Weights.w1[31u]), f16vec2(Biases.b1[30u], Biases.b1[31u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2392 = f16vec2(_2389.x);
    f16vec2 _2393 = f16vec2(_2389.y);
    f16vec2 _2517 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[368u], Weights.w1[369u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[320u], Weights.w1[321u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[272u], Weights.w1[273u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[224u], Weights.w1[225u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[176u], Weights.w1[177u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[128u], Weights.w1[129u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[80u], Weights.w1[81u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[32u], Weights.w1[33u]), f16vec2(Biases.b1[32u], Biases.b1[33u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2520 = f16vec2(_2517.x);
    f16vec2 _2521 = f16vec2(_2517.y);
    f16vec2 _2645 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[370u], Weights.w1[371u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[322u], Weights.w1[323u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[274u], Weights.w1[275u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[226u], Weights.w1[227u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[178u], Weights.w1[179u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[130u], Weights.w1[131u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[82u], Weights.w1[83u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[34u], Weights.w1[35u]), f16vec2(Biases.b1[34u], Biases.b1[35u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2648 = f16vec2(_2645.x);
    f16vec2 _2649 = f16vec2(_2645.y);
    f16vec2 _2783 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[372u], Weights.w1[373u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[324u], Weights.w1[325u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[276u], Weights.w1[277u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[228u], Weights.w1[229u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[180u], Weights.w1[181u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[132u], Weights.w1[133u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[84u], Weights.w1[85u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[36u], Weights.w1[37u]), f16vec2(Biases.b1[36u], Biases.b1[37u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2786 = f16vec2(_2783.x);
    f16vec2 _2787 = f16vec2(_2783.y);
    f16vec2 _2909 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[374u], Weights.w1[375u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[326u], Weights.w1[327u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[278u], Weights.w1[279u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[230u], Weights.w1[231u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[182u], Weights.w1[183u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[134u], Weights.w1[135u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[86u], Weights.w1[87u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[38u], Weights.w1[39u]), f16vec2(Biases.b1[38u], Biases.b1[39u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _2912 = f16vec2(_2909.x);
    f16vec2 _2913 = f16vec2(_2909.y);
    f16vec2 _2925 = fma(_2913, f16vec2(Weights.w2[312u], Weights.w2[313u]), fma(_2912, f16vec2(Weights.w2[304u], Weights.w2[305u]), fma(_2787, f16vec2(Weights.w2[296u], Weights.w2[297u]), fma(_2786, f16vec2(Weights.w2[288u], Weights.w2[289u]), fma(_2649, f16vec2(Weights.w2[280u], Weights.w2[281u]), fma(_2648, f16vec2(Weights.w2[272u], Weights.w2[273u]), fma(_2521, f16vec2(Weights.w2[264u], Weights.w2[265u]), fma(_2520, f16vec2(Weights.w2[256u], Weights.w2[257u]), fma(_2393, f16vec2(Weights.w2[248u], Weights.w2[249u]), fma(_2392, f16vec2(Weights.w2[240u], Weights.w2[241u]), _2265))))))))));
    f16vec2 _2937 = fma(_2913, f16vec2(Weights.w2[314u], Weights.w2[315u]), fma(_2912, f16vec2(Weights.w2[306u], Weights.w2[307u]), fma(_2787, f16vec2(Weights.w2[298u], Weights.w2[299u]), fma(_2786, f16vec2(Weights.w2[290u], Weights.w2[291u]), fma(_2649, f16vec2(Weights.w2[282u], Weights.w2[283u]), fma(_2648, f16vec2(Weights.w2[274u], Weights.w2[275u]), fma(_2521, f16vec2(Weights.w2[266u], Weights.w2[267u]), fma(_2520, f16vec2(Weights.w2[258u], Weights.w2[259u]), fma(_2393, f16vec2(Weights.w2[250u], Weights.w2[251u]), fma(_2392, f16vec2(Weights.w2[242u], Weights.w2[243u]), _2281))))))))));
    f16vec2 _2949 = fma(_2913, f16vec2(Weights.w2[316u], Weights.w2[317u]), fma(_2912, f16vec2(Weights.w2[308u], Weights.w2[309u]), fma(_2787, f16vec2(Weights.w2[300u], Weights.w2[301u]), fma(_2786, f16vec2(Weights.w2[292u], Weights.w2[293u]), fma(_2649, f16vec2(Weights.w2[284u], Weights.w2[285u]), fma(_2648, f16vec2(Weights.w2[276u], Weights.w2[277u]), fma(_2521, f16vec2(Weights.w2[268u], Weights.w2[269u]), fma(_2520, f16vec2(Weights.w2[260u], Weights.w2[261u]), fma(_2393, f16vec2(Weights.w2[252u], Weights.w2[253u]), fma(_2392, f16vec2(Weights.w2[244u], Weights.w2[245u]), _2297))))))))));
    f16vec2 _2961 = fma(_2913, f16vec2(Weights.w2[318u], Weights.w2[319u]), fma(_2912, f16vec2(Weights.w2[310u], Weights.w2[311u]), fma(_2787, f16vec2(Weights.w2[302u], Weights.w2[303u]), fma(_2786, f16vec2(Weights.w2[294u], Weights.w2[295u]), fma(_2649, f16vec2(Weights.w2[286u], Weights.w2[287u]), fma(_2648, f16vec2(Weights.w2[278u], Weights.w2[279u]), fma(_2521, f16vec2(Weights.w2[270u], Weights.w2[271u]), fma(_2520, f16vec2(Weights.w2[262u], Weights.w2[263u]), fma(_2393, f16vec2(Weights.w2[254u], Weights.w2[255u]), fma(_2392, f16vec2(Weights.w2[246u], Weights.w2[247u]), _2313))))))))));
    f16vec2 _3035 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[376u], Weights.w1[377u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[328u], Weights.w1[329u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[280u], Weights.w1[281u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[232u], Weights.w1[233u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[184u], Weights.w1[185u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[136u], Weights.w1[137u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[88u], Weights.w1[89u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[40u], Weights.w1[41u]), f16vec2(Biases.b1[40u], Biases.b1[41u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3038 = f16vec2(_3035.x);
    f16vec2 _3039 = f16vec2(_3035.y);
    f16vec2 _3165 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[378u], Weights.w1[379u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[330u], Weights.w1[331u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[282u], Weights.w1[283u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[234u], Weights.w1[235u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[186u], Weights.w1[187u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[138u], Weights.w1[139u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[90u], Weights.w1[91u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[42u], Weights.w1[43u]), f16vec2(Biases.b1[42u], Biases.b1[43u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3168 = f16vec2(_3165.x);
    f16vec2 _3169 = f16vec2(_3165.y);
    f16vec2 _3289 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[380u], Weights.w1[381u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[332u], Weights.w1[333u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[284u], Weights.w1[285u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[236u], Weights.w1[237u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[188u], Weights.w1[189u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[140u], Weights.w1[141u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[92u], Weights.w1[93u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[44u], Weights.w1[45u]), f16vec2(Biases.b1[44u], Biases.b1[45u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3292 = f16vec2(_3289.x);
    f16vec2 _3293 = f16vec2(_3289.y);
    f16vec2 _3413 = max(fma(f16vec2(_22[3].y), f16vec2(Weights.w1[382u], Weights.w1[383u]), fma(f16vec2(_22[3].x), f16vec2(Weights.w1[334u], Weights.w1[335u]), fma(f16vec2(_22[2].y), f16vec2(Weights.w1[286u], Weights.w1[287u]), fma(f16vec2(_22[2].x), f16vec2(Weights.w1[238u], Weights.w1[239u]), fma(f16vec2(_22[1].y), f16vec2(Weights.w1[190u], Weights.w1[191u]), fma(f16vec2(_22[1].x), f16vec2(Weights.w1[142u], Weights.w1[143u]), fma(f16vec2(_22[0].y), f16vec2(Weights.w1[94u], Weights.w1[95u]), fma(f16vec2(_22[0].x), f16vec2(Weights.w1[46u], Weights.w1[47u]), f16vec2(Biases.b1[46u], Biases.b1[47u]))))))))), f16vec2(float16_t(0.0)));
    f16vec2 _3416 = f16vec2(_3413.x);
    f16vec2 _3417 = f16vec2(_3413.y);
    f16vec2 _92[4] = f16vec2[](f16vec2(fma(_3417, f16vec2(Weights.w2[376u], Weights.w2[377u]), fma(_3416, f16vec2(Weights.w2[368u], Weights.w2[369u]), fma(_3293, f16vec2(Weights.w2[360u], Weights.w2[361u]), fma(_3292, f16vec2(Weights.w2[352u], Weights.w2[353u]), fma(_3169, f16vec2(Weights.w2[344u], Weights.w2[345u]), fma(_3168, f16vec2(Weights.w2[336u], Weights.w2[337u]), fma(_3039, f16vec2(Weights.w2[328u], Weights.w2[329u]), fma(_3038, f16vec2(Weights.w2[320u], Weights.w2[321u]), _2925))))))))), f16vec2(fma(_3417, f16vec2(Weights.w2[378u], Weights.w2[379u]), fma(_3416, f16vec2(Weights.w2[370u], Weights.w2[371u]), fma(_3293, f16vec2(Weights.w2[362u], Weights.w2[363u]), fma(_3292, f16vec2(Weights.w2[354u], Weights.w2[355u]), fma(_3169, f16vec2(Weights.w2[346u], Weights.w2[347u]), fma(_3168, f16vec2(Weights.w2[338u], Weights.w2[339u]), fma(_3039, f16vec2(Weights.w2[330u], Weights.w2[331u]), fma(_3038, f16vec2(Weights.w2[322u], Weights.w2[323u]), _2937))))))))), f16vec2(fma(_3417, f16vec2(Weights.w2[380u], Weights.w2[381u]), fma(_3416, f16vec2(Weights.w2[372u], Weights.w2[373u]), fma(_3293, f16vec2(Weights.w2[364u], Weights.w2[365u]), fma(_3292, f16vec2(Weights.w2[356u], Weights.w2[357u]), fma(_3169, f16vec2(Weights.w2[348u], Weights.w2[349u]), fma(_3168, f16vec2(Weights.w2[340u], Weights.w2[341u]), fma(_3039, f16vec2(Weights.w2[332u], Weights.w2[333u]), fma(_3038, f16vec2(Weights.w2[324u], Weights.w2[325u]), _2949))))))))), f16vec2(fma(_3417, f16vec2(Weights.w2[382u], Weights.w2[383u]), fma(_3416, f16vec2(Weights.w2[374u], Weights.w2[375u]), fma(_3293, f16vec2(Weights.w2[366u], Weights.w2[367u]), fma(_3292, f16vec2(Weights.w2[358u], Weights.w2[359u]), fma(_3169, f16vec2(Weights.w2[350u], Weights.w2[351u]), fma(_3168, f16vec2(Weights.w2[342u], Weights.w2[343u]), fma(_3039, f16vec2(Weights.w2[334u], Weights.w2[335u]), fma(_3038, f16vec2(Weights.w2[326u], Weights.w2[327u]), _2961))))))))));
    f16vec2 tempArg_1[4] = _92;
    f16vec2 h2[4] = _92;
    f16vec2 _3628[4] = _92;
    uint _3627 = 0u;
    f16vec2 _3626[4];
    uint _3634;
    for (;;)
    {
        _3634 = _3627;
        if (_3634 < 4u)
        {
            _3626[_3634] = max(_3628[_3634], _96[_3634]);
            _3627 = _3634 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    h2 = _3626;
    f16vec2 _121[2] = _3511(_3626);
    f16vec2 tempArg_2[2] = _121;
    f16vec2 y[2] = _121;
    f16vec2 _3645[2] = _121;
    uint _3644 = 0u;
    f16vec2 _3643[2];
    uint _3651;
    for (;;)
    {
        _3651 = _3644;
        if (_3651 < 2u)
        {
            _3643[_3651] = max(_3645[_3651], _125[_3651]);
            _3644 = _3651 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _3643;
    f16vec2 _3671[2] = _3643;
    uint _3672 = 0u;
    uint _3677;
    for (;;)
    {
        _3677 = _3672;
        if (_3677 < 4u)
        {
            _3661(0u + _3677, _3671[_3677 / 2u]);
            _3672 = _3677 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

