#version 450
#extension GL_EXT_scalar_block_layout : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, scalar) uniform InputW
{
    float data[128];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec2[4] _73()
{
    vec2 _511 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[96u], W.data[104u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[80u], W.data[88u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[64u], W.data[72u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[48u], W.data[56u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[32u], W.data[40u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[16u], W.data[24u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[0u], W.data[8u]), vec2(0.0))))))));
    vec2 _514 = fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[112u], W.data[120u]), _511);
    vec2 _538 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[97u], W.data[105u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[81u], W.data[89u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[65u], W.data[73u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[49u], W.data[57u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[33u], W.data[41u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[17u], W.data[25u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[1u], W.data[9u]), vec2(0.0))))))));
    vec2 _541 = fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[113u], W.data[121u]), _538);
    vec2 _565 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[98u], W.data[106u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[82u], W.data[90u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[66u], W.data[74u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[50u], W.data[58u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[34u], W.data[42u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[18u], W.data[26u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[2u], W.data[10u]), vec2(0.0))))))));
    vec2 _568 = fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[114u], W.data[122u]), _565);
    vec2 _592 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[99u], W.data[107u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[83u], W.data[91u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[67u], W.data[75u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[51u], W.data[59u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[35u], W.data[43u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[19u], W.data[27u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[3u], W.data[11u]), vec2(0.0))))))));
    vec2 _595 = fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[115u], W.data[123u]), _592);
    vec2 _619 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[100u], W.data[108u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[84u], W.data[92u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[68u], W.data[76u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[52u], W.data[60u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[36u], W.data[44u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[20u], W.data[28u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[4u], W.data[12u]), vec2(0.0))))))));
    vec2 _622 = fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[116u], W.data[124u]), _619);
    vec2 _646 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[101u], W.data[109u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[85u], W.data[93u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[69u], W.data[77u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[53u], W.data[61u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[37u], W.data[45u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[21u], W.data[29u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[5u], W.data[13u]), vec2(0.0))))))));
    vec2 _649 = fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[117u], W.data[125u]), _646);
    vec2 _673 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[102u], W.data[110u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[86u], W.data[94u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[70u], W.data[78u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[54u], W.data[62u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[38u], W.data[46u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[22u], W.data[30u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[6u], W.data[14u]), vec2(0.0))))))));
    vec2 _676 = fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[118u], W.data[126u]), _673);
    vec2 _700 = fma(vec2(X.data[12u], X.data[13u]), vec2(W.data[103u], W.data[111u]), fma(vec2(X.data[10u], X.data[11u]), vec2(W.data[87u], W.data[95u]), fma(vec2(X.data[8u], X.data[9u]), vec2(W.data[71u], W.data[79u]), fma(vec2(X.data[6u], X.data[7u]), vec2(W.data[55u], W.data[63u]), fma(vec2(X.data[4u], X.data[5u]), vec2(W.data[39u], W.data[47u]), fma(vec2(X.data[2u], X.data[3u]), vec2(W.data[23u], W.data[31u]), fma(vec2(X.data[0u], X.data[1u]), vec2(W.data[7u], W.data[15u]), vec2(0.0))))))));
    vec2 _703 = fma(vec2(X.data[14u], X.data[15u]), vec2(W.data[119u], W.data[127u]), _700);
    return vec2[](vec2(_514.x + _514.y, _541.x + _541.y), vec2(_568.x + _568.y, _595.x + _595.y), vec2(_622.x + _622.y, _649.x + _649.y), vec2(_676.x + _676.y, _703.x + _703.y));
}

void _713(uint _714, vec2 _715)
{
    Y.data[_714] = _715.x;
    Y.data[_714 + 1u] = _715.y;
}

void main()
{
    vec2 _48[4] = _73();
    vec2 tempArg[4] = _48;
    vec2 y[4] = _48;
    vec2 _727[4] = _48;
    uint _728 = 0u;
    uint _733;
    for (;;)
    {
        _733 = _728;
        if (_733 < 8u)
        {
            _713(0u + _733, _727[_733 / 2u]);
            _728 = _733 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

