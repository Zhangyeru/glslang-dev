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

f16vec2[4] _72()
{
    f16vec2 _509 = fma(f16vec2(X.data[12u], X.data[13u]), f16vec2(W.data[96u], W.data[104u]), fma(f16vec2(X.data[10u], X.data[11u]), f16vec2(W.data[80u], W.data[88u]), fma(f16vec2(X.data[8u], X.data[9u]), f16vec2(W.data[64u], W.data[72u]), fma(f16vec2(X.data[6u], X.data[7u]), f16vec2(W.data[48u], W.data[56u]), fma(f16vec2(X.data[4u], X.data[5u]), f16vec2(W.data[32u], W.data[40u]), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[16u], W.data[24u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[0u], W.data[8u]), f16vec2(float16_t(0.0)))))))));
    f16vec2 _512 = fma(f16vec2(X.data[14u], X.data[15u]), f16vec2(W.data[112u], W.data[120u]), _509);
    f16vec2 _536 = fma(f16vec2(X.data[12u], X.data[13u]), f16vec2(W.data[97u], W.data[105u]), fma(f16vec2(X.data[10u], X.data[11u]), f16vec2(W.data[81u], W.data[89u]), fma(f16vec2(X.data[8u], X.data[9u]), f16vec2(W.data[65u], W.data[73u]), fma(f16vec2(X.data[6u], X.data[7u]), f16vec2(W.data[49u], W.data[57u]), fma(f16vec2(X.data[4u], X.data[5u]), f16vec2(W.data[33u], W.data[41u]), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[17u], W.data[25u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[1u], W.data[9u]), f16vec2(float16_t(0.0)))))))));
    f16vec2 _539 = fma(f16vec2(X.data[14u], X.data[15u]), f16vec2(W.data[113u], W.data[121u]), _536);
    f16vec2 _563 = fma(f16vec2(X.data[12u], X.data[13u]), f16vec2(W.data[98u], W.data[106u]), fma(f16vec2(X.data[10u], X.data[11u]), f16vec2(W.data[82u], W.data[90u]), fma(f16vec2(X.data[8u], X.data[9u]), f16vec2(W.data[66u], W.data[74u]), fma(f16vec2(X.data[6u], X.data[7u]), f16vec2(W.data[50u], W.data[58u]), fma(f16vec2(X.data[4u], X.data[5u]), f16vec2(W.data[34u], W.data[42u]), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[18u], W.data[26u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[2u], W.data[10u]), f16vec2(float16_t(0.0)))))))));
    f16vec2 _566 = fma(f16vec2(X.data[14u], X.data[15u]), f16vec2(W.data[114u], W.data[122u]), _563);
    f16vec2 _590 = fma(f16vec2(X.data[12u], X.data[13u]), f16vec2(W.data[99u], W.data[107u]), fma(f16vec2(X.data[10u], X.data[11u]), f16vec2(W.data[83u], W.data[91u]), fma(f16vec2(X.data[8u], X.data[9u]), f16vec2(W.data[67u], W.data[75u]), fma(f16vec2(X.data[6u], X.data[7u]), f16vec2(W.data[51u], W.data[59u]), fma(f16vec2(X.data[4u], X.data[5u]), f16vec2(W.data[35u], W.data[43u]), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[19u], W.data[27u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[3u], W.data[11u]), f16vec2(float16_t(0.0)))))))));
    f16vec2 _593 = fma(f16vec2(X.data[14u], X.data[15u]), f16vec2(W.data[115u], W.data[123u]), _590);
    f16vec2 _617 = fma(f16vec2(X.data[12u], X.data[13u]), f16vec2(W.data[100u], W.data[108u]), fma(f16vec2(X.data[10u], X.data[11u]), f16vec2(W.data[84u], W.data[92u]), fma(f16vec2(X.data[8u], X.data[9u]), f16vec2(W.data[68u], W.data[76u]), fma(f16vec2(X.data[6u], X.data[7u]), f16vec2(W.data[52u], W.data[60u]), fma(f16vec2(X.data[4u], X.data[5u]), f16vec2(W.data[36u], W.data[44u]), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[20u], W.data[28u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[4u], W.data[12u]), f16vec2(float16_t(0.0)))))))));
    f16vec2 _620 = fma(f16vec2(X.data[14u], X.data[15u]), f16vec2(W.data[116u], W.data[124u]), _617);
    f16vec2 _644 = fma(f16vec2(X.data[12u], X.data[13u]), f16vec2(W.data[101u], W.data[109u]), fma(f16vec2(X.data[10u], X.data[11u]), f16vec2(W.data[85u], W.data[93u]), fma(f16vec2(X.data[8u], X.data[9u]), f16vec2(W.data[69u], W.data[77u]), fma(f16vec2(X.data[6u], X.data[7u]), f16vec2(W.data[53u], W.data[61u]), fma(f16vec2(X.data[4u], X.data[5u]), f16vec2(W.data[37u], W.data[45u]), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[21u], W.data[29u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[5u], W.data[13u]), f16vec2(float16_t(0.0)))))))));
    f16vec2 _647 = fma(f16vec2(X.data[14u], X.data[15u]), f16vec2(W.data[117u], W.data[125u]), _644);
    f16vec2 _671 = fma(f16vec2(X.data[12u], X.data[13u]), f16vec2(W.data[102u], W.data[110u]), fma(f16vec2(X.data[10u], X.data[11u]), f16vec2(W.data[86u], W.data[94u]), fma(f16vec2(X.data[8u], X.data[9u]), f16vec2(W.data[70u], W.data[78u]), fma(f16vec2(X.data[6u], X.data[7u]), f16vec2(W.data[54u], W.data[62u]), fma(f16vec2(X.data[4u], X.data[5u]), f16vec2(W.data[38u], W.data[46u]), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[22u], W.data[30u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[6u], W.data[14u]), f16vec2(float16_t(0.0)))))))));
    f16vec2 _674 = fma(f16vec2(X.data[14u], X.data[15u]), f16vec2(W.data[118u], W.data[126u]), _671);
    f16vec2 _698 = fma(f16vec2(X.data[12u], X.data[13u]), f16vec2(W.data[103u], W.data[111u]), fma(f16vec2(X.data[10u], X.data[11u]), f16vec2(W.data[87u], W.data[95u]), fma(f16vec2(X.data[8u], X.data[9u]), f16vec2(W.data[71u], W.data[79u]), fma(f16vec2(X.data[6u], X.data[7u]), f16vec2(W.data[55u], W.data[63u]), fma(f16vec2(X.data[4u], X.data[5u]), f16vec2(W.data[39u], W.data[47u]), fma(f16vec2(X.data[2u], X.data[3u]), f16vec2(W.data[23u], W.data[31u]), fma(f16vec2(X.data[0u], X.data[1u]), f16vec2(W.data[7u], W.data[15u]), f16vec2(float16_t(0.0)))))))));
    f16vec2 _701 = fma(f16vec2(X.data[14u], X.data[15u]), f16vec2(W.data[119u], W.data[127u]), _698);
    return f16vec2[](f16vec2(_512.x + _512.y, _539.x + _539.y), f16vec2(_566.x + _566.y, _593.x + _593.y), f16vec2(_620.x + _620.y, _647.x + _647.y), f16vec2(_674.x + _674.y, _701.x + _701.y));
}

void _711(uint _712, f16vec2 _713)
{
    Y.data[_712] = _713.x;
    Y.data[_712 + 1u] = _713.y;
}

void main()
{
    f16vec2 _47[4] = _72();
    f16vec2 tempArg[4] = _47;
    f16vec2 y[4] = _47;
    f16vec2 _725[4] = _47;
    uint _726 = 0u;
    uint _731;
    for (;;)
    {
        _731 = _726;
        if (_731 < 8u)
        {
            _711(0u + _731, _725[_731 / 2u]);
            _726 = _731 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

