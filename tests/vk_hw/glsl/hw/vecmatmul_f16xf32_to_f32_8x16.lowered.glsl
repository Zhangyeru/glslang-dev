#version 460
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
    float data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec2[8] _73()
{
    vec2 _476 = vec2(f16vec2(X.data[0u]));
    vec2 _494 = vec2(f16vec2(X.data[1u]));
    vec2 _512 = vec2(f16vec2(X.data[2u]));
    vec2 _530 = vec2(f16vec2(X.data[3u]));
    vec2 _548 = vec2(f16vec2(X.data[4u]));
    vec2 _566 = vec2(f16vec2(X.data[5u]));
    vec2 _584 = vec2(f16vec2(X.data[6u]));
    vec2 _602 = vec2(f16vec2(X.data[7u]));
    return vec2[](fma(_602, vec2(W.data[112u], W.data[113u]), fma(_584, vec2(W.data[96u], W.data[97u]), fma(_566, vec2(W.data[80u], W.data[81u]), fma(_548, vec2(W.data[64u], W.data[65u]), fma(_530, vec2(W.data[48u], W.data[49u]), fma(_512, vec2(W.data[32u], W.data[33u]), fma(_494, vec2(W.data[16u], W.data[17u]), fma(_476, vec2(W.data[0u], W.data[1u]), vec2(0.0))))))))), fma(_602, vec2(W.data[114u], W.data[115u]), fma(_584, vec2(W.data[98u], W.data[99u]), fma(_566, vec2(W.data[82u], W.data[83u]), fma(_548, vec2(W.data[66u], W.data[67u]), fma(_530, vec2(W.data[50u], W.data[51u]), fma(_512, vec2(W.data[34u], W.data[35u]), fma(_494, vec2(W.data[18u], W.data[19u]), fma(_476, vec2(W.data[2u], W.data[3u]), vec2(0.0))))))))), fma(_602, vec2(W.data[116u], W.data[117u]), fma(_584, vec2(W.data[100u], W.data[101u]), fma(_566, vec2(W.data[84u], W.data[85u]), fma(_548, vec2(W.data[68u], W.data[69u]), fma(_530, vec2(W.data[52u], W.data[53u]), fma(_512, vec2(W.data[36u], W.data[37u]), fma(_494, vec2(W.data[20u], W.data[21u]), fma(_476, vec2(W.data[4u], W.data[5u]), vec2(0.0))))))))), fma(_602, vec2(W.data[118u], W.data[119u]), fma(_584, vec2(W.data[102u], W.data[103u]), fma(_566, vec2(W.data[86u], W.data[87u]), fma(_548, vec2(W.data[70u], W.data[71u]), fma(_530, vec2(W.data[54u], W.data[55u]), fma(_512, vec2(W.data[38u], W.data[39u]), fma(_494, vec2(W.data[22u], W.data[23u]), fma(_476, vec2(W.data[6u], W.data[7u]), vec2(0.0))))))))), fma(_602, vec2(W.data[120u], W.data[121u]), fma(_584, vec2(W.data[104u], W.data[105u]), fma(_566, vec2(W.data[88u], W.data[89u]), fma(_548, vec2(W.data[72u], W.data[73u]), fma(_530, vec2(W.data[56u], W.data[57u]), fma(_512, vec2(W.data[40u], W.data[41u]), fma(_494, vec2(W.data[24u], W.data[25u]), fma(_476, vec2(W.data[8u], W.data[9u]), vec2(0.0))))))))), fma(_602, vec2(W.data[122u], W.data[123u]), fma(_584, vec2(W.data[106u], W.data[107u]), fma(_566, vec2(W.data[90u], W.data[91u]), fma(_548, vec2(W.data[74u], W.data[75u]), fma(_530, vec2(W.data[58u], W.data[59u]), fma(_512, vec2(W.data[42u], W.data[43u]), fma(_494, vec2(W.data[26u], W.data[27u]), fma(_476, vec2(W.data[10u], W.data[11u]), vec2(0.0))))))))), fma(_602, vec2(W.data[124u], W.data[125u]), fma(_584, vec2(W.data[108u], W.data[109u]), fma(_566, vec2(W.data[92u], W.data[93u]), fma(_548, vec2(W.data[76u], W.data[77u]), fma(_530, vec2(W.data[60u], W.data[61u]), fma(_512, vec2(W.data[44u], W.data[45u]), fma(_494, vec2(W.data[28u], W.data[29u]), fma(_476, vec2(W.data[12u], W.data[13u]), vec2(0.0))))))))), fma(_602, vec2(W.data[126u], W.data[127u]), fma(_584, vec2(W.data[110u], W.data[111u]), fma(_566, vec2(W.data[94u], W.data[95u]), fma(_548, vec2(W.data[78u], W.data[79u]), fma(_530, vec2(W.data[62u], W.data[63u]), fma(_512, vec2(W.data[46u], W.data[47u]), fma(_494, vec2(W.data[30u], W.data[31u]), fma(_476, vec2(W.data[14u], W.data[15u]), vec2(0.0))))))))));
}

void _621(uint _622, vec2 _623)
{
    Y.data[_622] = _623.x;
    Y.data[_622 + 1u] = _623.y;
}

void main()
{
    vec2 _48[8] = _73();
    vec2 tempArg[8] = _48;
    vec2 y[8] = _48;
    vec2 _635[8] = _48;
    uint _636 = 0u;
    uint _641;
    for (;;)
    {
        _641 = _636;
        if (_641 < 16u)
        {
            _621(0u + _641, _635[_641 / 2u]);
            _636 = _641 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

