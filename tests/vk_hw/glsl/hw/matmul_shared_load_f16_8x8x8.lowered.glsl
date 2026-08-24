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

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer Weight
{
    float16_t data[];
} W;

layout(set = 0, binding = 2, std430) buffer InputC0
{
    float16_t data[];
} C0;

layout(set = 0, binding = 3, std430) buffer InputC1
{
    float16_t data[];
} C1;

layout(set = 0, binding = 4, std430) buffer OutputD0
{
    float16_t data[];
} D0;

layout(set = 0, binding = 5, std430) buffer OutputD1
{
    float16_t data[];
} D1;

f16vec2[32] _101()
{
    f16vec2 _556 = f16vec2(A.data[0u]);
    f16vec2 _565 = f16vec2(A.data[1u]);
    f16vec2 _574 = f16vec2(A.data[2u]);
    f16vec2 _583 = f16vec2(A.data[3u]);
    f16vec2 _592 = f16vec2(A.data[4u]);
    f16vec2 _601 = f16vec2(A.data[5u]);
    f16vec2 _610 = f16vec2(A.data[6u]);
    f16vec2 _619 = f16vec2(A.data[7u]);
    f16vec2 _632 = f16vec2(A.data[8u]);
    f16vec2 _641 = f16vec2(A.data[9u]);
    f16vec2 _650 = f16vec2(A.data[10u]);
    f16vec2 _659 = f16vec2(A.data[11u]);
    f16vec2 _668 = f16vec2(A.data[12u]);
    f16vec2 _677 = f16vec2(A.data[13u]);
    f16vec2 _686 = f16vec2(A.data[14u]);
    f16vec2 _695 = f16vec2(A.data[15u]);
    f16vec2 _708 = f16vec2(A.data[16u]);
    f16vec2 _717 = f16vec2(A.data[17u]);
    f16vec2 _726 = f16vec2(A.data[18u]);
    f16vec2 _735 = f16vec2(A.data[19u]);
    f16vec2 _744 = f16vec2(A.data[20u]);
    f16vec2 _753 = f16vec2(A.data[21u]);
    f16vec2 _762 = f16vec2(A.data[22u]);
    f16vec2 _771 = f16vec2(A.data[23u]);
    f16vec2 _784 = f16vec2(A.data[24u]);
    f16vec2 _793 = f16vec2(A.data[25u]);
    f16vec2 _802 = f16vec2(A.data[26u]);
    f16vec2 _811 = f16vec2(A.data[27u]);
    f16vec2 _820 = f16vec2(A.data[28u]);
    f16vec2 _829 = f16vec2(A.data[29u]);
    f16vec2 _838 = f16vec2(A.data[30u]);
    f16vec2 _847 = f16vec2(A.data[31u]);
    f16vec2 _860 = f16vec2(A.data[32u]);
    f16vec2 _869 = f16vec2(A.data[33u]);
    f16vec2 _878 = f16vec2(A.data[34u]);
    f16vec2 _887 = f16vec2(A.data[35u]);
    f16vec2 _896 = f16vec2(A.data[36u]);
    f16vec2 _905 = f16vec2(A.data[37u]);
    f16vec2 _914 = f16vec2(A.data[38u]);
    f16vec2 _923 = f16vec2(A.data[39u]);
    f16vec2 _936 = f16vec2(A.data[40u]);
    f16vec2 _945 = f16vec2(A.data[41u]);
    f16vec2 _954 = f16vec2(A.data[42u]);
    f16vec2 _963 = f16vec2(A.data[43u]);
    f16vec2 _972 = f16vec2(A.data[44u]);
    f16vec2 _981 = f16vec2(A.data[45u]);
    f16vec2 _990 = f16vec2(A.data[46u]);
    f16vec2 _999 = f16vec2(A.data[47u]);
    f16vec2 _1012 = f16vec2(A.data[48u]);
    f16vec2 _1021 = f16vec2(A.data[49u]);
    f16vec2 _1030 = f16vec2(A.data[50u]);
    f16vec2 _1039 = f16vec2(A.data[51u]);
    f16vec2 _1048 = f16vec2(A.data[52u]);
    f16vec2 _1057 = f16vec2(A.data[53u]);
    f16vec2 _1066 = f16vec2(A.data[54u]);
    f16vec2 _1075 = f16vec2(A.data[55u]);
    f16vec2 _1088 = f16vec2(A.data[56u]);
    f16vec2 _1097 = f16vec2(A.data[57u]);
    f16vec2 _1106 = f16vec2(A.data[58u]);
    f16vec2 _1115 = f16vec2(A.data[59u]);
    f16vec2 _1124 = f16vec2(A.data[60u]);
    f16vec2 _1133 = f16vec2(A.data[61u]);
    f16vec2 _1142 = f16vec2(A.data[62u]);
    f16vec2 _1151 = f16vec2(A.data[63u]);
    return f16vec2[](fma(_619, f16vec2(W.data[56u], W.data[57u]), fma(_610, f16vec2(W.data[48u], W.data[49u]), fma(_601, f16vec2(W.data[40u], W.data[41u]), fma(_592, f16vec2(W.data[32u], W.data[33u]), fma(_583, f16vec2(W.data[24u], W.data[25u]), fma(_574, f16vec2(W.data[16u], W.data[17u]), fma(_565, f16vec2(W.data[8u], W.data[9u]), fma(_556, f16vec2(W.data[0u], W.data[1u]), f16vec2(C0.data[0u], C0.data[1u]))))))))), fma(_619, f16vec2(W.data[58u], W.data[59u]), fma(_610, f16vec2(W.data[50u], W.data[51u]), fma(_601, f16vec2(W.data[42u], W.data[43u]), fma(_592, f16vec2(W.data[34u], W.data[35u]), fma(_583, f16vec2(W.data[26u], W.data[27u]), fma(_574, f16vec2(W.data[18u], W.data[19u]), fma(_565, f16vec2(W.data[10u], W.data[11u]), fma(_556, f16vec2(W.data[2u], W.data[3u]), f16vec2(C0.data[2u], C0.data[3u]))))))))), fma(_619, f16vec2(W.data[60u], W.data[61u]), fma(_610, f16vec2(W.data[52u], W.data[53u]), fma(_601, f16vec2(W.data[44u], W.data[45u]), fma(_592, f16vec2(W.data[36u], W.data[37u]), fma(_583, f16vec2(W.data[28u], W.data[29u]), fma(_574, f16vec2(W.data[20u], W.data[21u]), fma(_565, f16vec2(W.data[12u], W.data[13u]), fma(_556, f16vec2(W.data[4u], W.data[5u]), f16vec2(C0.data[4u], C0.data[5u]))))))))), fma(_619, f16vec2(W.data[62u], W.data[63u]), fma(_610, f16vec2(W.data[54u], W.data[55u]), fma(_601, f16vec2(W.data[46u], W.data[47u]), fma(_592, f16vec2(W.data[38u], W.data[39u]), fma(_583, f16vec2(W.data[30u], W.data[31u]), fma(_574, f16vec2(W.data[22u], W.data[23u]), fma(_565, f16vec2(W.data[14u], W.data[15u]), fma(_556, f16vec2(W.data[6u], W.data[7u]), f16vec2(C0.data[6u], C0.data[7u]))))))))), fma(_695, f16vec2(W.data[56u], W.data[57u]), fma(_686, f16vec2(W.data[48u], W.data[49u]), fma(_677, f16vec2(W.data[40u], W.data[41u]), fma(_668, f16vec2(W.data[32u], W.data[33u]), fma(_659, f16vec2(W.data[24u], W.data[25u]), fma(_650, f16vec2(W.data[16u], W.data[17u]), fma(_641, f16vec2(W.data[8u], W.data[9u]), fma(_632, f16vec2(W.data[0u], W.data[1u]), f16vec2(C0.data[8u], C0.data[9u]))))))))), fma(_695, f16vec2(W.data[58u], W.data[59u]), fma(_686, f16vec2(W.data[50u], W.data[51u]), fma(_677, f16vec2(W.data[42u], W.data[43u]), fma(_668, f16vec2(W.data[34u], W.data[35u]), fma(_659, f16vec2(W.data[26u], W.data[27u]), fma(_650, f16vec2(W.data[18u], W.data[19u]), fma(_641, f16vec2(W.data[10u], W.data[11u]), fma(_632, f16vec2(W.data[2u], W.data[3u]), f16vec2(C0.data[10u], C0.data[11u]))))))))), fma(_695, f16vec2(W.data[60u], W.data[61u]), fma(_686, f16vec2(W.data[52u], W.data[53u]), fma(_677, f16vec2(W.data[44u], W.data[45u]), fma(_668, f16vec2(W.data[36u], W.data[37u]), fma(_659, f16vec2(W.data[28u], W.data[29u]), fma(_650, f16vec2(W.data[20u], W.data[21u]), fma(_641, f16vec2(W.data[12u], W.data[13u]), fma(_632, f16vec2(W.data[4u], W.data[5u]), f16vec2(C0.data[12u], C0.data[13u]))))))))), fma(_695, f16vec2(W.data[62u], W.data[63u]), fma(_686, f16vec2(W.data[54u], W.data[55u]), fma(_677, f16vec2(W.data[46u], W.data[47u]), fma(_668, f16vec2(W.data[38u], W.data[39u]), fma(_659, f16vec2(W.data[30u], W.data[31u]), fma(_650, f16vec2(W.data[22u], W.data[23u]), fma(_641, f16vec2(W.data[14u], W.data[15u]), fma(_632, f16vec2(W.data[6u], W.data[7u]), f16vec2(C0.data[14u], C0.data[15u]))))))))), fma(_771, f16vec2(W.data[56u], W.data[57u]), fma(_762, f16vec2(W.data[48u], W.data[49u]), fma(_753, f16vec2(W.data[40u], W.data[41u]), fma(_744, f16vec2(W.data[32u], W.data[33u]), fma(_735, f16vec2(W.data[24u], W.data[25u]), fma(_726, f16vec2(W.data[16u], W.data[17u]), fma(_717, f16vec2(W.data[8u], W.data[9u]), fma(_708, f16vec2(W.data[0u], W.data[1u]), f16vec2(C0.data[16u], C0.data[17u]))))))))), fma(_771, f16vec2(W.data[58u], W.data[59u]), fma(_762, f16vec2(W.data[50u], W.data[51u]), fma(_753, f16vec2(W.data[42u], W.data[43u]), fma(_744, f16vec2(W.data[34u], W.data[35u]), fma(_735, f16vec2(W.data[26u], W.data[27u]), fma(_726, f16vec2(W.data[18u], W.data[19u]), fma(_717, f16vec2(W.data[10u], W.data[11u]), fma(_708, f16vec2(W.data[2u], W.data[3u]), f16vec2(C0.data[18u], C0.data[19u]))))))))), fma(_771, f16vec2(W.data[60u], W.data[61u]), fma(_762, f16vec2(W.data[52u], W.data[53u]), fma(_753, f16vec2(W.data[44u], W.data[45u]), fma(_744, f16vec2(W.data[36u], W.data[37u]), fma(_735, f16vec2(W.data[28u], W.data[29u]), fma(_726, f16vec2(W.data[20u], W.data[21u]), fma(_717, f16vec2(W.data[12u], W.data[13u]), fma(_708, f16vec2(W.data[4u], W.data[5u]), f16vec2(C0.data[20u], C0.data[21u]))))))))), fma(_771, f16vec2(W.data[62u], W.data[63u]), fma(_762, f16vec2(W.data[54u], W.data[55u]), fma(_753, f16vec2(W.data[46u], W.data[47u]), fma(_744, f16vec2(W.data[38u], W.data[39u]), fma(_735, f16vec2(W.data[30u], W.data[31u]), fma(_726, f16vec2(W.data[22u], W.data[23u]), fma(_717, f16vec2(W.data[14u], W.data[15u]), fma(_708, f16vec2(W.data[6u], W.data[7u]), f16vec2(C0.data[22u], C0.data[23u]))))))))), fma(_847, f16vec2(W.data[56u], W.data[57u]), fma(_838, f16vec2(W.data[48u], W.data[49u]), fma(_829, f16vec2(W.data[40u], W.data[41u]), fma(_820, f16vec2(W.data[32u], W.data[33u]), fma(_811, f16vec2(W.data[24u], W.data[25u]), fma(_802, f16vec2(W.data[16u], W.data[17u]), fma(_793, f16vec2(W.data[8u], W.data[9u]), fma(_784, f16vec2(W.data[0u], W.data[1u]), f16vec2(C0.data[24u], C0.data[25u]))))))))), fma(_847, f16vec2(W.data[58u], W.data[59u]), fma(_838, f16vec2(W.data[50u], W.data[51u]), fma(_829, f16vec2(W.data[42u], W.data[43u]), fma(_820, f16vec2(W.data[34u], W.data[35u]), fma(_811, f16vec2(W.data[26u], W.data[27u]), fma(_802, f16vec2(W.data[18u], W.data[19u]), fma(_793, f16vec2(W.data[10u], W.data[11u]), fma(_784, f16vec2(W.data[2u], W.data[3u]), f16vec2(C0.data[26u], C0.data[27u]))))))))), fma(_847, f16vec2(W.data[60u], W.data[61u]), fma(_838, f16vec2(W.data[52u], W.data[53u]), fma(_829, f16vec2(W.data[44u], W.data[45u]), fma(_820, f16vec2(W.data[36u], W.data[37u]), fma(_811, f16vec2(W.data[28u], W.data[29u]), fma(_802, f16vec2(W.data[20u], W.data[21u]), fma(_793, f16vec2(W.data[12u], W.data[13u]), fma(_784, f16vec2(W.data[4u], W.data[5u]), f16vec2(C0.data[28u], C0.data[29u]))))))))), fma(_847, f16vec2(W.data[62u], W.data[63u]), fma(_838, f16vec2(W.data[54u], W.data[55u]), fma(_829, f16vec2(W.data[46u], W.data[47u]), fma(_820, f16vec2(W.data[38u], W.data[39u]), fma(_811, f16vec2(W.data[30u], W.data[31u]), fma(_802, f16vec2(W.data[22u], W.data[23u]), fma(_793, f16vec2(W.data[14u], W.data[15u]), fma(_784, f16vec2(W.data[6u], W.data[7u]), f16vec2(C0.data[30u], C0.data[31u]))))))))), fma(_923, f16vec2(W.data[56u], W.data[57u]), fma(_914, f16vec2(W.data[48u], W.data[49u]), fma(_905, f16vec2(W.data[40u], W.data[41u]), fma(_896, f16vec2(W.data[32u], W.data[33u]), fma(_887, f16vec2(W.data[24u], W.data[25u]), fma(_878, f16vec2(W.data[16u], W.data[17u]), fma(_869, f16vec2(W.data[8u], W.data[9u]), fma(_860, f16vec2(W.data[0u], W.data[1u]), f16vec2(C0.data[32u], C0.data[33u]))))))))), fma(_923, f16vec2(W.data[58u], W.data[59u]), fma(_914, f16vec2(W.data[50u], W.data[51u]), fma(_905, f16vec2(W.data[42u], W.data[43u]), fma(_896, f16vec2(W.data[34u], W.data[35u]), fma(_887, f16vec2(W.data[26u], W.data[27u]), fma(_878, f16vec2(W.data[18u], W.data[19u]), fma(_869, f16vec2(W.data[10u], W.data[11u]), fma(_860, f16vec2(W.data[2u], W.data[3u]), f16vec2(C0.data[34u], C0.data[35u]))))))))), fma(_923, f16vec2(W.data[60u], W.data[61u]), fma(_914, f16vec2(W.data[52u], W.data[53u]), fma(_905, f16vec2(W.data[44u], W.data[45u]), fma(_896, f16vec2(W.data[36u], W.data[37u]), fma(_887, f16vec2(W.data[28u], W.data[29u]), fma(_878, f16vec2(W.data[20u], W.data[21u]), fma(_869, f16vec2(W.data[12u], W.data[13u]), fma(_860, f16vec2(W.data[4u], W.data[5u]), f16vec2(C0.data[36u], C0.data[37u]))))))))), fma(_923, f16vec2(W.data[62u], W.data[63u]), fma(_914, f16vec2(W.data[54u], W.data[55u]), fma(_905, f16vec2(W.data[46u], W.data[47u]), fma(_896, f16vec2(W.data[38u], W.data[39u]), fma(_887, f16vec2(W.data[30u], W.data[31u]), fma(_878, f16vec2(W.data[22u], W.data[23u]), fma(_869, f16vec2(W.data[14u], W.data[15u]), fma(_860, f16vec2(W.data[6u], W.data[7u]), f16vec2(C0.data[38u], C0.data[39u]))))))))), fma(_999, f16vec2(W.data[56u], W.data[57u]), fma(_990, f16vec2(W.data[48u], W.data[49u]), fma(_981, f16vec2(W.data[40u], W.data[41u]), fma(_972, f16vec2(W.data[32u], W.data[33u]), fma(_963, f16vec2(W.data[24u], W.data[25u]), fma(_954, f16vec2(W.data[16u], W.data[17u]), fma(_945, f16vec2(W.data[8u], W.data[9u]), fma(_936, f16vec2(W.data[0u], W.data[1u]), f16vec2(C0.data[40u], C0.data[41u]))))))))), fma(_999, f16vec2(W.data[58u], W.data[59u]), fma(_990, f16vec2(W.data[50u], W.data[51u]), fma(_981, f16vec2(W.data[42u], W.data[43u]), fma(_972, f16vec2(W.data[34u], W.data[35u]), fma(_963, f16vec2(W.data[26u], W.data[27u]), fma(_954, f16vec2(W.data[18u], W.data[19u]), fma(_945, f16vec2(W.data[10u], W.data[11u]), fma(_936, f16vec2(W.data[2u], W.data[3u]), f16vec2(C0.data[42u], C0.data[43u]))))))))), fma(_999, f16vec2(W.data[60u], W.data[61u]), fma(_990, f16vec2(W.data[52u], W.data[53u]), fma(_981, f16vec2(W.data[44u], W.data[45u]), fma(_972, f16vec2(W.data[36u], W.data[37u]), fma(_963, f16vec2(W.data[28u], W.data[29u]), fma(_954, f16vec2(W.data[20u], W.data[21u]), fma(_945, f16vec2(W.data[12u], W.data[13u]), fma(_936, f16vec2(W.data[4u], W.data[5u]), f16vec2(C0.data[44u], C0.data[45u]))))))))), fma(_999, f16vec2(W.data[62u], W.data[63u]), fma(_990, f16vec2(W.data[54u], W.data[55u]), fma(_981, f16vec2(W.data[46u], W.data[47u]), fma(_972, f16vec2(W.data[38u], W.data[39u]), fma(_963, f16vec2(W.data[30u], W.data[31u]), fma(_954, f16vec2(W.data[22u], W.data[23u]), fma(_945, f16vec2(W.data[14u], W.data[15u]), fma(_936, f16vec2(W.data[6u], W.data[7u]), f16vec2(C0.data[46u], C0.data[47u]))))))))), fma(_1075, f16vec2(W.data[56u], W.data[57u]), fma(_1066, f16vec2(W.data[48u], W.data[49u]), fma(_1057, f16vec2(W.data[40u], W.data[41u]), fma(_1048, f16vec2(W.data[32u], W.data[33u]), fma(_1039, f16vec2(W.data[24u], W.data[25u]), fma(_1030, f16vec2(W.data[16u], W.data[17u]), fma(_1021, f16vec2(W.data[8u], W.data[9u]), fma(_1012, f16vec2(W.data[0u], W.data[1u]), f16vec2(C0.data[48u], C0.data[49u]))))))))), fma(_1075, f16vec2(W.data[58u], W.data[59u]), fma(_1066, f16vec2(W.data[50u], W.data[51u]), fma(_1057, f16vec2(W.data[42u], W.data[43u]), fma(_1048, f16vec2(W.data[34u], W.data[35u]), fma(_1039, f16vec2(W.data[26u], W.data[27u]), fma(_1030, f16vec2(W.data[18u], W.data[19u]), fma(_1021, f16vec2(W.data[10u], W.data[11u]), fma(_1012, f16vec2(W.data[2u], W.data[3u]), f16vec2(C0.data[50u], C0.data[51u]))))))))), fma(_1075, f16vec2(W.data[60u], W.data[61u]), fma(_1066, f16vec2(W.data[52u], W.data[53u]), fma(_1057, f16vec2(W.data[44u], W.data[45u]), fma(_1048, f16vec2(W.data[36u], W.data[37u]), fma(_1039, f16vec2(W.data[28u], W.data[29u]), fma(_1030, f16vec2(W.data[20u], W.data[21u]), fma(_1021, f16vec2(W.data[12u], W.data[13u]), fma(_1012, f16vec2(W.data[4u], W.data[5u]), f16vec2(C0.data[52u], C0.data[53u]))))))))), fma(_1075, f16vec2(W.data[62u], W.data[63u]), fma(_1066, f16vec2(W.data[54u], W.data[55u]), fma(_1057, f16vec2(W.data[46u], W.data[47u]), fma(_1048, f16vec2(W.data[38u], W.data[39u]), fma(_1039, f16vec2(W.data[30u], W.data[31u]), fma(_1030, f16vec2(W.data[22u], W.data[23u]), fma(_1021, f16vec2(W.data[14u], W.data[15u]), fma(_1012, f16vec2(W.data[6u], W.data[7u]), f16vec2(C0.data[54u], C0.data[55u]))))))))), fma(_1151, f16vec2(W.data[56u], W.data[57u]), fma(_1142, f16vec2(W.data[48u], W.data[49u]), fma(_1133, f16vec2(W.data[40u], W.data[41u]), fma(_1124, f16vec2(W.data[32u], W.data[33u]), fma(_1115, f16vec2(W.data[24u], W.data[25u]), fma(_1106, f16vec2(W.data[16u], W.data[17u]), fma(_1097, f16vec2(W.data[8u], W.data[9u]), fma(_1088, f16vec2(W.data[0u], W.data[1u]), f16vec2(C0.data[56u], C0.data[57u]))))))))), fma(_1151, f16vec2(W.data[58u], W.data[59u]), fma(_1142, f16vec2(W.data[50u], W.data[51u]), fma(_1133, f16vec2(W.data[42u], W.data[43u]), fma(_1124, f16vec2(W.data[34u], W.data[35u]), fma(_1115, f16vec2(W.data[26u], W.data[27u]), fma(_1106, f16vec2(W.data[18u], W.data[19u]), fma(_1097, f16vec2(W.data[10u], W.data[11u]), fma(_1088, f16vec2(W.data[2u], W.data[3u]), f16vec2(C0.data[58u], C0.data[59u]))))))))), fma(_1151, f16vec2(W.data[60u], W.data[61u]), fma(_1142, f16vec2(W.data[52u], W.data[53u]), fma(_1133, f16vec2(W.data[44u], W.data[45u]), fma(_1124, f16vec2(W.data[36u], W.data[37u]), fma(_1115, f16vec2(W.data[28u], W.data[29u]), fma(_1106, f16vec2(W.data[20u], W.data[21u]), fma(_1097, f16vec2(W.data[12u], W.data[13u]), fma(_1088, f16vec2(W.data[4u], W.data[5u]), f16vec2(C0.data[60u], C0.data[61u]))))))))), fma(_1151, f16vec2(W.data[62u], W.data[63u]), fma(_1142, f16vec2(W.data[54u], W.data[55u]), fma(_1133, f16vec2(W.data[46u], W.data[47u]), fma(_1124, f16vec2(W.data[38u], W.data[39u]), fma(_1115, f16vec2(W.data[30u], W.data[31u]), fma(_1106, f16vec2(W.data[22u], W.data[23u]), fma(_1097, f16vec2(W.data[14u], W.data[15u]), fma(_1088, f16vec2(W.data[6u], W.data[7u]), f16vec2(C0.data[62u], C0.data[63u]))))))))));
}

f16vec2[32] _1161()
{
    f16vec2 _1554 = f16vec2(A.data[0u]);
    f16vec2 _1563 = f16vec2(A.data[1u]);
    f16vec2 _1572 = f16vec2(A.data[2u]);
    f16vec2 _1581 = f16vec2(A.data[3u]);
    f16vec2 _1590 = f16vec2(A.data[4u]);
    f16vec2 _1599 = f16vec2(A.data[5u]);
    f16vec2 _1608 = f16vec2(A.data[6u]);
    f16vec2 _1617 = f16vec2(A.data[7u]);
    f16vec2 _1630 = f16vec2(A.data[8u]);
    f16vec2 _1639 = f16vec2(A.data[9u]);
    f16vec2 _1648 = f16vec2(A.data[10u]);
    f16vec2 _1657 = f16vec2(A.data[11u]);
    f16vec2 _1666 = f16vec2(A.data[12u]);
    f16vec2 _1675 = f16vec2(A.data[13u]);
    f16vec2 _1684 = f16vec2(A.data[14u]);
    f16vec2 _1693 = f16vec2(A.data[15u]);
    f16vec2 _1706 = f16vec2(A.data[16u]);
    f16vec2 _1715 = f16vec2(A.data[17u]);
    f16vec2 _1724 = f16vec2(A.data[18u]);
    f16vec2 _1733 = f16vec2(A.data[19u]);
    f16vec2 _1742 = f16vec2(A.data[20u]);
    f16vec2 _1751 = f16vec2(A.data[21u]);
    f16vec2 _1760 = f16vec2(A.data[22u]);
    f16vec2 _1769 = f16vec2(A.data[23u]);
    f16vec2 _1782 = f16vec2(A.data[24u]);
    f16vec2 _1791 = f16vec2(A.data[25u]);
    f16vec2 _1800 = f16vec2(A.data[26u]);
    f16vec2 _1809 = f16vec2(A.data[27u]);
    f16vec2 _1818 = f16vec2(A.data[28u]);
    f16vec2 _1827 = f16vec2(A.data[29u]);
    f16vec2 _1836 = f16vec2(A.data[30u]);
    f16vec2 _1845 = f16vec2(A.data[31u]);
    f16vec2 _1858 = f16vec2(A.data[32u]);
    f16vec2 _1867 = f16vec2(A.data[33u]);
    f16vec2 _1876 = f16vec2(A.data[34u]);
    f16vec2 _1885 = f16vec2(A.data[35u]);
    f16vec2 _1894 = f16vec2(A.data[36u]);
    f16vec2 _1903 = f16vec2(A.data[37u]);
    f16vec2 _1912 = f16vec2(A.data[38u]);
    f16vec2 _1921 = f16vec2(A.data[39u]);
    f16vec2 _1934 = f16vec2(A.data[40u]);
    f16vec2 _1943 = f16vec2(A.data[41u]);
    f16vec2 _1952 = f16vec2(A.data[42u]);
    f16vec2 _1961 = f16vec2(A.data[43u]);
    f16vec2 _1970 = f16vec2(A.data[44u]);
    f16vec2 _1979 = f16vec2(A.data[45u]);
    f16vec2 _1988 = f16vec2(A.data[46u]);
    f16vec2 _1997 = f16vec2(A.data[47u]);
    f16vec2 _2010 = f16vec2(A.data[48u]);
    f16vec2 _2019 = f16vec2(A.data[49u]);
    f16vec2 _2028 = f16vec2(A.data[50u]);
    f16vec2 _2037 = f16vec2(A.data[51u]);
    f16vec2 _2046 = f16vec2(A.data[52u]);
    f16vec2 _2055 = f16vec2(A.data[53u]);
    f16vec2 _2064 = f16vec2(A.data[54u]);
    f16vec2 _2073 = f16vec2(A.data[55u]);
    f16vec2 _2086 = f16vec2(A.data[56u]);
    f16vec2 _2095 = f16vec2(A.data[57u]);
    f16vec2 _2104 = f16vec2(A.data[58u]);
    f16vec2 _2113 = f16vec2(A.data[59u]);
    f16vec2 _2122 = f16vec2(A.data[60u]);
    f16vec2 _2131 = f16vec2(A.data[61u]);
    f16vec2 _2140 = f16vec2(A.data[62u]);
    f16vec2 _2149 = f16vec2(A.data[63u]);
    return f16vec2[](fma(_1617, f16vec2(W.data[56u], W.data[57u]), fma(_1608, f16vec2(W.data[48u], W.data[49u]), fma(_1599, f16vec2(W.data[40u], W.data[41u]), fma(_1590, f16vec2(W.data[32u], W.data[33u]), fma(_1581, f16vec2(W.data[24u], W.data[25u]), fma(_1572, f16vec2(W.data[16u], W.data[17u]), fma(_1563, f16vec2(W.data[8u], W.data[9u]), fma(_1554, f16vec2(W.data[0u], W.data[1u]), f16vec2(C1.data[0u], C1.data[1u]))))))))), fma(_1617, f16vec2(W.data[58u], W.data[59u]), fma(_1608, f16vec2(W.data[50u], W.data[51u]), fma(_1599, f16vec2(W.data[42u], W.data[43u]), fma(_1590, f16vec2(W.data[34u], W.data[35u]), fma(_1581, f16vec2(W.data[26u], W.data[27u]), fma(_1572, f16vec2(W.data[18u], W.data[19u]), fma(_1563, f16vec2(W.data[10u], W.data[11u]), fma(_1554, f16vec2(W.data[2u], W.data[3u]), f16vec2(C1.data[2u], C1.data[3u]))))))))), fma(_1617, f16vec2(W.data[60u], W.data[61u]), fma(_1608, f16vec2(W.data[52u], W.data[53u]), fma(_1599, f16vec2(W.data[44u], W.data[45u]), fma(_1590, f16vec2(W.data[36u], W.data[37u]), fma(_1581, f16vec2(W.data[28u], W.data[29u]), fma(_1572, f16vec2(W.data[20u], W.data[21u]), fma(_1563, f16vec2(W.data[12u], W.data[13u]), fma(_1554, f16vec2(W.data[4u], W.data[5u]), f16vec2(C1.data[4u], C1.data[5u]))))))))), fma(_1617, f16vec2(W.data[62u], W.data[63u]), fma(_1608, f16vec2(W.data[54u], W.data[55u]), fma(_1599, f16vec2(W.data[46u], W.data[47u]), fma(_1590, f16vec2(W.data[38u], W.data[39u]), fma(_1581, f16vec2(W.data[30u], W.data[31u]), fma(_1572, f16vec2(W.data[22u], W.data[23u]), fma(_1563, f16vec2(W.data[14u], W.data[15u]), fma(_1554, f16vec2(W.data[6u], W.data[7u]), f16vec2(C1.data[6u], C1.data[7u]))))))))), fma(_1693, f16vec2(W.data[56u], W.data[57u]), fma(_1684, f16vec2(W.data[48u], W.data[49u]), fma(_1675, f16vec2(W.data[40u], W.data[41u]), fma(_1666, f16vec2(W.data[32u], W.data[33u]), fma(_1657, f16vec2(W.data[24u], W.data[25u]), fma(_1648, f16vec2(W.data[16u], W.data[17u]), fma(_1639, f16vec2(W.data[8u], W.data[9u]), fma(_1630, f16vec2(W.data[0u], W.data[1u]), f16vec2(C1.data[8u], C1.data[9u]))))))))), fma(_1693, f16vec2(W.data[58u], W.data[59u]), fma(_1684, f16vec2(W.data[50u], W.data[51u]), fma(_1675, f16vec2(W.data[42u], W.data[43u]), fma(_1666, f16vec2(W.data[34u], W.data[35u]), fma(_1657, f16vec2(W.data[26u], W.data[27u]), fma(_1648, f16vec2(W.data[18u], W.data[19u]), fma(_1639, f16vec2(W.data[10u], W.data[11u]), fma(_1630, f16vec2(W.data[2u], W.data[3u]), f16vec2(C1.data[10u], C1.data[11u]))))))))), fma(_1693, f16vec2(W.data[60u], W.data[61u]), fma(_1684, f16vec2(W.data[52u], W.data[53u]), fma(_1675, f16vec2(W.data[44u], W.data[45u]), fma(_1666, f16vec2(W.data[36u], W.data[37u]), fma(_1657, f16vec2(W.data[28u], W.data[29u]), fma(_1648, f16vec2(W.data[20u], W.data[21u]), fma(_1639, f16vec2(W.data[12u], W.data[13u]), fma(_1630, f16vec2(W.data[4u], W.data[5u]), f16vec2(C1.data[12u], C1.data[13u]))))))))), fma(_1693, f16vec2(W.data[62u], W.data[63u]), fma(_1684, f16vec2(W.data[54u], W.data[55u]), fma(_1675, f16vec2(W.data[46u], W.data[47u]), fma(_1666, f16vec2(W.data[38u], W.data[39u]), fma(_1657, f16vec2(W.data[30u], W.data[31u]), fma(_1648, f16vec2(W.data[22u], W.data[23u]), fma(_1639, f16vec2(W.data[14u], W.data[15u]), fma(_1630, f16vec2(W.data[6u], W.data[7u]), f16vec2(C1.data[14u], C1.data[15u]))))))))), fma(_1769, f16vec2(W.data[56u], W.data[57u]), fma(_1760, f16vec2(W.data[48u], W.data[49u]), fma(_1751, f16vec2(W.data[40u], W.data[41u]), fma(_1742, f16vec2(W.data[32u], W.data[33u]), fma(_1733, f16vec2(W.data[24u], W.data[25u]), fma(_1724, f16vec2(W.data[16u], W.data[17u]), fma(_1715, f16vec2(W.data[8u], W.data[9u]), fma(_1706, f16vec2(W.data[0u], W.data[1u]), f16vec2(C1.data[16u], C1.data[17u]))))))))), fma(_1769, f16vec2(W.data[58u], W.data[59u]), fma(_1760, f16vec2(W.data[50u], W.data[51u]), fma(_1751, f16vec2(W.data[42u], W.data[43u]), fma(_1742, f16vec2(W.data[34u], W.data[35u]), fma(_1733, f16vec2(W.data[26u], W.data[27u]), fma(_1724, f16vec2(W.data[18u], W.data[19u]), fma(_1715, f16vec2(W.data[10u], W.data[11u]), fma(_1706, f16vec2(W.data[2u], W.data[3u]), f16vec2(C1.data[18u], C1.data[19u]))))))))), fma(_1769, f16vec2(W.data[60u], W.data[61u]), fma(_1760, f16vec2(W.data[52u], W.data[53u]), fma(_1751, f16vec2(W.data[44u], W.data[45u]), fma(_1742, f16vec2(W.data[36u], W.data[37u]), fma(_1733, f16vec2(W.data[28u], W.data[29u]), fma(_1724, f16vec2(W.data[20u], W.data[21u]), fma(_1715, f16vec2(W.data[12u], W.data[13u]), fma(_1706, f16vec2(W.data[4u], W.data[5u]), f16vec2(C1.data[20u], C1.data[21u]))))))))), fma(_1769, f16vec2(W.data[62u], W.data[63u]), fma(_1760, f16vec2(W.data[54u], W.data[55u]), fma(_1751, f16vec2(W.data[46u], W.data[47u]), fma(_1742, f16vec2(W.data[38u], W.data[39u]), fma(_1733, f16vec2(W.data[30u], W.data[31u]), fma(_1724, f16vec2(W.data[22u], W.data[23u]), fma(_1715, f16vec2(W.data[14u], W.data[15u]), fma(_1706, f16vec2(W.data[6u], W.data[7u]), f16vec2(C1.data[22u], C1.data[23u]))))))))), fma(_1845, f16vec2(W.data[56u], W.data[57u]), fma(_1836, f16vec2(W.data[48u], W.data[49u]), fma(_1827, f16vec2(W.data[40u], W.data[41u]), fma(_1818, f16vec2(W.data[32u], W.data[33u]), fma(_1809, f16vec2(W.data[24u], W.data[25u]), fma(_1800, f16vec2(W.data[16u], W.data[17u]), fma(_1791, f16vec2(W.data[8u], W.data[9u]), fma(_1782, f16vec2(W.data[0u], W.data[1u]), f16vec2(C1.data[24u], C1.data[25u]))))))))), fma(_1845, f16vec2(W.data[58u], W.data[59u]), fma(_1836, f16vec2(W.data[50u], W.data[51u]), fma(_1827, f16vec2(W.data[42u], W.data[43u]), fma(_1818, f16vec2(W.data[34u], W.data[35u]), fma(_1809, f16vec2(W.data[26u], W.data[27u]), fma(_1800, f16vec2(W.data[18u], W.data[19u]), fma(_1791, f16vec2(W.data[10u], W.data[11u]), fma(_1782, f16vec2(W.data[2u], W.data[3u]), f16vec2(C1.data[26u], C1.data[27u]))))))))), fma(_1845, f16vec2(W.data[60u], W.data[61u]), fma(_1836, f16vec2(W.data[52u], W.data[53u]), fma(_1827, f16vec2(W.data[44u], W.data[45u]), fma(_1818, f16vec2(W.data[36u], W.data[37u]), fma(_1809, f16vec2(W.data[28u], W.data[29u]), fma(_1800, f16vec2(W.data[20u], W.data[21u]), fma(_1791, f16vec2(W.data[12u], W.data[13u]), fma(_1782, f16vec2(W.data[4u], W.data[5u]), f16vec2(C1.data[28u], C1.data[29u]))))))))), fma(_1845, f16vec2(W.data[62u], W.data[63u]), fma(_1836, f16vec2(W.data[54u], W.data[55u]), fma(_1827, f16vec2(W.data[46u], W.data[47u]), fma(_1818, f16vec2(W.data[38u], W.data[39u]), fma(_1809, f16vec2(W.data[30u], W.data[31u]), fma(_1800, f16vec2(W.data[22u], W.data[23u]), fma(_1791, f16vec2(W.data[14u], W.data[15u]), fma(_1782, f16vec2(W.data[6u], W.data[7u]), f16vec2(C1.data[30u], C1.data[31u]))))))))), fma(_1921, f16vec2(W.data[56u], W.data[57u]), fma(_1912, f16vec2(W.data[48u], W.data[49u]), fma(_1903, f16vec2(W.data[40u], W.data[41u]), fma(_1894, f16vec2(W.data[32u], W.data[33u]), fma(_1885, f16vec2(W.data[24u], W.data[25u]), fma(_1876, f16vec2(W.data[16u], W.data[17u]), fma(_1867, f16vec2(W.data[8u], W.data[9u]), fma(_1858, f16vec2(W.data[0u], W.data[1u]), f16vec2(C1.data[32u], C1.data[33u]))))))))), fma(_1921, f16vec2(W.data[58u], W.data[59u]), fma(_1912, f16vec2(W.data[50u], W.data[51u]), fma(_1903, f16vec2(W.data[42u], W.data[43u]), fma(_1894, f16vec2(W.data[34u], W.data[35u]), fma(_1885, f16vec2(W.data[26u], W.data[27u]), fma(_1876, f16vec2(W.data[18u], W.data[19u]), fma(_1867, f16vec2(W.data[10u], W.data[11u]), fma(_1858, f16vec2(W.data[2u], W.data[3u]), f16vec2(C1.data[34u], C1.data[35u]))))))))), fma(_1921, f16vec2(W.data[60u], W.data[61u]), fma(_1912, f16vec2(W.data[52u], W.data[53u]), fma(_1903, f16vec2(W.data[44u], W.data[45u]), fma(_1894, f16vec2(W.data[36u], W.data[37u]), fma(_1885, f16vec2(W.data[28u], W.data[29u]), fma(_1876, f16vec2(W.data[20u], W.data[21u]), fma(_1867, f16vec2(W.data[12u], W.data[13u]), fma(_1858, f16vec2(W.data[4u], W.data[5u]), f16vec2(C1.data[36u], C1.data[37u]))))))))), fma(_1921, f16vec2(W.data[62u], W.data[63u]), fma(_1912, f16vec2(W.data[54u], W.data[55u]), fma(_1903, f16vec2(W.data[46u], W.data[47u]), fma(_1894, f16vec2(W.data[38u], W.data[39u]), fma(_1885, f16vec2(W.data[30u], W.data[31u]), fma(_1876, f16vec2(W.data[22u], W.data[23u]), fma(_1867, f16vec2(W.data[14u], W.data[15u]), fma(_1858, f16vec2(W.data[6u], W.data[7u]), f16vec2(C1.data[38u], C1.data[39u]))))))))), fma(_1997, f16vec2(W.data[56u], W.data[57u]), fma(_1988, f16vec2(W.data[48u], W.data[49u]), fma(_1979, f16vec2(W.data[40u], W.data[41u]), fma(_1970, f16vec2(W.data[32u], W.data[33u]), fma(_1961, f16vec2(W.data[24u], W.data[25u]), fma(_1952, f16vec2(W.data[16u], W.data[17u]), fma(_1943, f16vec2(W.data[8u], W.data[9u]), fma(_1934, f16vec2(W.data[0u], W.data[1u]), f16vec2(C1.data[40u], C1.data[41u]))))))))), fma(_1997, f16vec2(W.data[58u], W.data[59u]), fma(_1988, f16vec2(W.data[50u], W.data[51u]), fma(_1979, f16vec2(W.data[42u], W.data[43u]), fma(_1970, f16vec2(W.data[34u], W.data[35u]), fma(_1961, f16vec2(W.data[26u], W.data[27u]), fma(_1952, f16vec2(W.data[18u], W.data[19u]), fma(_1943, f16vec2(W.data[10u], W.data[11u]), fma(_1934, f16vec2(W.data[2u], W.data[3u]), f16vec2(C1.data[42u], C1.data[43u]))))))))), fma(_1997, f16vec2(W.data[60u], W.data[61u]), fma(_1988, f16vec2(W.data[52u], W.data[53u]), fma(_1979, f16vec2(W.data[44u], W.data[45u]), fma(_1970, f16vec2(W.data[36u], W.data[37u]), fma(_1961, f16vec2(W.data[28u], W.data[29u]), fma(_1952, f16vec2(W.data[20u], W.data[21u]), fma(_1943, f16vec2(W.data[12u], W.data[13u]), fma(_1934, f16vec2(W.data[4u], W.data[5u]), f16vec2(C1.data[44u], C1.data[45u]))))))))), fma(_1997, f16vec2(W.data[62u], W.data[63u]), fma(_1988, f16vec2(W.data[54u], W.data[55u]), fma(_1979, f16vec2(W.data[46u], W.data[47u]), fma(_1970, f16vec2(W.data[38u], W.data[39u]), fma(_1961, f16vec2(W.data[30u], W.data[31u]), fma(_1952, f16vec2(W.data[22u], W.data[23u]), fma(_1943, f16vec2(W.data[14u], W.data[15u]), fma(_1934, f16vec2(W.data[6u], W.data[7u]), f16vec2(C1.data[46u], C1.data[47u]))))))))), fma(_2073, f16vec2(W.data[56u], W.data[57u]), fma(_2064, f16vec2(W.data[48u], W.data[49u]), fma(_2055, f16vec2(W.data[40u], W.data[41u]), fma(_2046, f16vec2(W.data[32u], W.data[33u]), fma(_2037, f16vec2(W.data[24u], W.data[25u]), fma(_2028, f16vec2(W.data[16u], W.data[17u]), fma(_2019, f16vec2(W.data[8u], W.data[9u]), fma(_2010, f16vec2(W.data[0u], W.data[1u]), f16vec2(C1.data[48u], C1.data[49u]))))))))), fma(_2073, f16vec2(W.data[58u], W.data[59u]), fma(_2064, f16vec2(W.data[50u], W.data[51u]), fma(_2055, f16vec2(W.data[42u], W.data[43u]), fma(_2046, f16vec2(W.data[34u], W.data[35u]), fma(_2037, f16vec2(W.data[26u], W.data[27u]), fma(_2028, f16vec2(W.data[18u], W.data[19u]), fma(_2019, f16vec2(W.data[10u], W.data[11u]), fma(_2010, f16vec2(W.data[2u], W.data[3u]), f16vec2(C1.data[50u], C1.data[51u]))))))))), fma(_2073, f16vec2(W.data[60u], W.data[61u]), fma(_2064, f16vec2(W.data[52u], W.data[53u]), fma(_2055, f16vec2(W.data[44u], W.data[45u]), fma(_2046, f16vec2(W.data[36u], W.data[37u]), fma(_2037, f16vec2(W.data[28u], W.data[29u]), fma(_2028, f16vec2(W.data[20u], W.data[21u]), fma(_2019, f16vec2(W.data[12u], W.data[13u]), fma(_2010, f16vec2(W.data[4u], W.data[5u]), f16vec2(C1.data[52u], C1.data[53u]))))))))), fma(_2073, f16vec2(W.data[62u], W.data[63u]), fma(_2064, f16vec2(W.data[54u], W.data[55u]), fma(_2055, f16vec2(W.data[46u], W.data[47u]), fma(_2046, f16vec2(W.data[38u], W.data[39u]), fma(_2037, f16vec2(W.data[30u], W.data[31u]), fma(_2028, f16vec2(W.data[22u], W.data[23u]), fma(_2019, f16vec2(W.data[14u], W.data[15u]), fma(_2010, f16vec2(W.data[6u], W.data[7u]), f16vec2(C1.data[54u], C1.data[55u]))))))))), fma(_2149, f16vec2(W.data[56u], W.data[57u]), fma(_2140, f16vec2(W.data[48u], W.data[49u]), fma(_2131, f16vec2(W.data[40u], W.data[41u]), fma(_2122, f16vec2(W.data[32u], W.data[33u]), fma(_2113, f16vec2(W.data[24u], W.data[25u]), fma(_2104, f16vec2(W.data[16u], W.data[17u]), fma(_2095, f16vec2(W.data[8u], W.data[9u]), fma(_2086, f16vec2(W.data[0u], W.data[1u]), f16vec2(C1.data[56u], C1.data[57u]))))))))), fma(_2149, f16vec2(W.data[58u], W.data[59u]), fma(_2140, f16vec2(W.data[50u], W.data[51u]), fma(_2131, f16vec2(W.data[42u], W.data[43u]), fma(_2122, f16vec2(W.data[34u], W.data[35u]), fma(_2113, f16vec2(W.data[26u], W.data[27u]), fma(_2104, f16vec2(W.data[18u], W.data[19u]), fma(_2095, f16vec2(W.data[10u], W.data[11u]), fma(_2086, f16vec2(W.data[2u], W.data[3u]), f16vec2(C1.data[58u], C1.data[59u]))))))))), fma(_2149, f16vec2(W.data[60u], W.data[61u]), fma(_2140, f16vec2(W.data[52u], W.data[53u]), fma(_2131, f16vec2(W.data[44u], W.data[45u]), fma(_2122, f16vec2(W.data[36u], W.data[37u]), fma(_2113, f16vec2(W.data[28u], W.data[29u]), fma(_2104, f16vec2(W.data[20u], W.data[21u]), fma(_2095, f16vec2(W.data[12u], W.data[13u]), fma(_2086, f16vec2(W.data[4u], W.data[5u]), f16vec2(C1.data[60u], C1.data[61u]))))))))), fma(_2149, f16vec2(W.data[62u], W.data[63u]), fma(_2140, f16vec2(W.data[54u], W.data[55u]), fma(_2131, f16vec2(W.data[46u], W.data[47u]), fma(_2122, f16vec2(W.data[38u], W.data[39u]), fma(_2113, f16vec2(W.data[30u], W.data[31u]), fma(_2104, f16vec2(W.data[22u], W.data[23u]), fma(_2095, f16vec2(W.data[14u], W.data[15u]), fma(_2086, f16vec2(W.data[6u], W.data[7u]), f16vec2(C1.data[62u], C1.data[63u]))))))))));
}

void _2160(uint _2161, f16vec2 _2162)
{
    D0.data[_2161] = _2162.x;
    D0.data[_2161 + 1u] = _2162.y;
}

void _2200(uint _2201, f16vec2 _2202)
{
    D1.data[_2201] = _2202.x;
    D1.data[_2201 + 1u] = _2202.y;
}

void main()
{
    f16vec2 _70[32] = _101();
    f16vec2 tempArg[32] = _70;
    f16vec2 d0[32] = _70;
    f16vec2 _77[32] = _1161();
    f16vec2 tempArg_1[32] = _77;
    f16vec2 d1[32] = _77;
    f16vec2 _2175[32] = _70;
    uint _2176 = 0u;
    uint _2181;
    for (;;)
    {
        _2181 = _2176;
        if (_2181 < 64u)
        {
            _2160(((uint(0) + (_2181 / 8u)) * uint(8)) + (uint(0) + (_2181 % 8u)), _2175[_2181 / 2u]);
            _2176 = _2181 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _2210[32] = _77;
    uint _2211 = 0u;
    uint _2216;
    for (;;)
    {
        _2216 = _2211;
        if (_2216 < 64u)
        {
            _2200(((uint(0) + (_2216 / 8u)) * uint(8)) + (uint(0) + (_2216 % 8u)), _2210[_2216 / 2u]);
            _2211 = _2216 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

