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
    f16vec2 _489 = f16vec2(X.data[0u]);
    f16vec2 _498 = f16vec2(X.data[1u]);
    f16vec2 _507 = f16vec2(X.data[2u]);
    f16vec2 _516 = f16vec2(X.data[3u]);
    f16vec2 _525 = f16vec2(X.data[4u]);
    f16vec2 _534 = f16vec2(X.data[5u]);
    f16vec2 _543 = f16vec2(X.data[6u]);
    f16vec2 _552 = f16vec2(X.data[7u]);
    f16vec2 _561 = f16vec2(X.data[8u]);
    f16vec2 _570 = f16vec2(X.data[9u]);
    f16vec2 _579 = f16vec2(X.data[10u]);
    f16vec2 _581 = fma(_579, f16vec2(W.data[80u], W.data[81u]), fma(_570, f16vec2(W.data[72u], W.data[73u]), fma(_561, f16vec2(W.data[64u], W.data[65u]), fma(_552, f16vec2(W.data[56u], W.data[57u]), fma(_543, f16vec2(W.data[48u], W.data[49u]), fma(_534, f16vec2(W.data[40u], W.data[41u]), fma(_525, f16vec2(W.data[32u], W.data[33u]), fma(_516, f16vec2(W.data[24u], W.data[25u]), fma(_507, f16vec2(W.data[16u], W.data[17u]), fma(_498, f16vec2(W.data[8u], W.data[9u]), fma(_489, f16vec2(W.data[0u], W.data[1u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _583 = fma(_579, f16vec2(W.data[82u], W.data[83u]), fma(_570, f16vec2(W.data[74u], W.data[75u]), fma(_561, f16vec2(W.data[66u], W.data[67u]), fma(_552, f16vec2(W.data[58u], W.data[59u]), fma(_543, f16vec2(W.data[50u], W.data[51u]), fma(_534, f16vec2(W.data[42u], W.data[43u]), fma(_525, f16vec2(W.data[34u], W.data[35u]), fma(_516, f16vec2(W.data[26u], W.data[27u]), fma(_507, f16vec2(W.data[18u], W.data[19u]), fma(_498, f16vec2(W.data[10u], W.data[11u]), fma(_489, f16vec2(W.data[2u], W.data[3u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _585 = fma(_579, f16vec2(W.data[84u], W.data[85u]), fma(_570, f16vec2(W.data[76u], W.data[77u]), fma(_561, f16vec2(W.data[68u], W.data[69u]), fma(_552, f16vec2(W.data[60u], W.data[61u]), fma(_543, f16vec2(W.data[52u], W.data[53u]), fma(_534, f16vec2(W.data[44u], W.data[45u]), fma(_525, f16vec2(W.data[36u], W.data[37u]), fma(_516, f16vec2(W.data[28u], W.data[29u]), fma(_507, f16vec2(W.data[20u], W.data[21u]), fma(_498, f16vec2(W.data[12u], W.data[13u]), fma(_489, f16vec2(W.data[4u], W.data[5u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _587 = fma(_579, f16vec2(W.data[86u], W.data[87u]), fma(_570, f16vec2(W.data[78u], W.data[79u]), fma(_561, f16vec2(W.data[70u], W.data[71u]), fma(_552, f16vec2(W.data[62u], W.data[63u]), fma(_543, f16vec2(W.data[54u], W.data[55u]), fma(_534, f16vec2(W.data[46u], W.data[47u]), fma(_525, f16vec2(W.data[38u], W.data[39u]), fma(_516, f16vec2(W.data[30u], W.data[31u]), fma(_507, f16vec2(W.data[22u], W.data[23u]), fma(_498, f16vec2(W.data[14u], W.data[15u]), fma(_489, f16vec2(W.data[6u], W.data[7u]), f16vec2(float16_t(0.0)))))))))))));
    f16vec2 _588 = f16vec2(X.data[11u]);
    f16vec2 _597 = f16vec2(X.data[12u]);
    f16vec2 _606 = f16vec2(X.data[13u]);
    f16vec2 _615 = f16vec2(X.data[14u]);
    f16vec2 _624 = f16vec2(X.data[15u]);
    return f16vec2[](fma(_624, f16vec2(W.data[120u], W.data[121u]), fma(_615, f16vec2(W.data[112u], W.data[113u]), fma(_606, f16vec2(W.data[104u], W.data[105u]), fma(_597, f16vec2(W.data[96u], W.data[97u]), fma(_588, f16vec2(W.data[88u], W.data[89u]), _581))))), fma(_624, f16vec2(W.data[122u], W.data[123u]), fma(_615, f16vec2(W.data[114u], W.data[115u]), fma(_606, f16vec2(W.data[106u], W.data[107u]), fma(_597, f16vec2(W.data[98u], W.data[99u]), fma(_588, f16vec2(W.data[90u], W.data[91u]), _583))))), fma(_624, f16vec2(W.data[124u], W.data[125u]), fma(_615, f16vec2(W.data[116u], W.data[117u]), fma(_606, f16vec2(W.data[108u], W.data[109u]), fma(_597, f16vec2(W.data[100u], W.data[101u]), fma(_588, f16vec2(W.data[92u], W.data[93u]), _585))))), fma(_624, f16vec2(W.data[126u], W.data[127u]), fma(_615, f16vec2(W.data[118u], W.data[119u]), fma(_606, f16vec2(W.data[110u], W.data[111u]), fma(_597, f16vec2(W.data[102u], W.data[103u]), fma(_588, f16vec2(W.data[94u], W.data[95u]), _587))))));
}

void _635(uint _636, f16vec2 _637)
{
    Y.data[_636] = _637.x;
    Y.data[_636 + 1u] = _637.y;
}

void main()
{
    f16vec2 _47[4] = _72();
    f16vec2 tempArg[4] = _47;
    f16vec2 y[4] = _47;
    f16vec2 _649[4] = _47;
    uint _650 = 0u;
    uint _655;
    for (;;)
    {
        _655 = _650;
        if (_655 < 8u)
        {
            _635(0u + _655, _649[_655 / 2u]);
            _650 = _655 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

