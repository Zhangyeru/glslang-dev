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

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

layout(set = 0, binding = 4, std430) buffer OutputE
{
    float16_t data[];
} E;

f16vec2 _1140(uint _1141)
{
    return f16vec2(B.data[_1141], B.data[_1141 + 1u]);
}

f16vec2[32] _79()
{
    f16vec2 _534 = f16vec2(A.data[0u]);
    f16vec2 _543 = f16vec2(A.data[1u]);
    f16vec2 _552 = f16vec2(A.data[2u]);
    f16vec2 _561 = f16vec2(A.data[3u]);
    f16vec2 _570 = f16vec2(A.data[4u]);
    f16vec2 _579 = f16vec2(A.data[5u]);
    f16vec2 _588 = f16vec2(A.data[6u]);
    f16vec2 _597 = f16vec2(A.data[7u]);
    f16vec2 _610 = f16vec2(A.data[8u]);
    f16vec2 _619 = f16vec2(A.data[9u]);
    f16vec2 _628 = f16vec2(A.data[10u]);
    f16vec2 _637 = f16vec2(A.data[11u]);
    f16vec2 _646 = f16vec2(A.data[12u]);
    f16vec2 _655 = f16vec2(A.data[13u]);
    f16vec2 _664 = f16vec2(A.data[14u]);
    f16vec2 _673 = f16vec2(A.data[15u]);
    f16vec2 _686 = f16vec2(A.data[16u]);
    f16vec2 _695 = f16vec2(A.data[17u]);
    f16vec2 _704 = f16vec2(A.data[18u]);
    f16vec2 _713 = f16vec2(A.data[19u]);
    f16vec2 _722 = f16vec2(A.data[20u]);
    f16vec2 _731 = f16vec2(A.data[21u]);
    f16vec2 _740 = f16vec2(A.data[22u]);
    f16vec2 _749 = f16vec2(A.data[23u]);
    f16vec2 _762 = f16vec2(A.data[24u]);
    f16vec2 _771 = f16vec2(A.data[25u]);
    f16vec2 _780 = f16vec2(A.data[26u]);
    f16vec2 _789 = f16vec2(A.data[27u]);
    f16vec2 _798 = f16vec2(A.data[28u]);
    f16vec2 _807 = f16vec2(A.data[29u]);
    f16vec2 _816 = f16vec2(A.data[30u]);
    f16vec2 _825 = f16vec2(A.data[31u]);
    f16vec2 _838 = f16vec2(A.data[32u]);
    f16vec2 _847 = f16vec2(A.data[33u]);
    f16vec2 _856 = f16vec2(A.data[34u]);
    f16vec2 _865 = f16vec2(A.data[35u]);
    f16vec2 _874 = f16vec2(A.data[36u]);
    f16vec2 _883 = f16vec2(A.data[37u]);
    f16vec2 _892 = f16vec2(A.data[38u]);
    f16vec2 _901 = f16vec2(A.data[39u]);
    f16vec2 _914 = f16vec2(A.data[40u]);
    f16vec2 _923 = f16vec2(A.data[41u]);
    f16vec2 _932 = f16vec2(A.data[42u]);
    f16vec2 _941 = f16vec2(A.data[43u]);
    f16vec2 _950 = f16vec2(A.data[44u]);
    f16vec2 _959 = f16vec2(A.data[45u]);
    f16vec2 _968 = f16vec2(A.data[46u]);
    f16vec2 _977 = f16vec2(A.data[47u]);
    f16vec2 _990 = f16vec2(A.data[48u]);
    f16vec2 _999 = f16vec2(A.data[49u]);
    f16vec2 _1008 = f16vec2(A.data[50u]);
    f16vec2 _1017 = f16vec2(A.data[51u]);
    f16vec2 _1026 = f16vec2(A.data[52u]);
    f16vec2 _1035 = f16vec2(A.data[53u]);
    f16vec2 _1044 = f16vec2(A.data[54u]);
    f16vec2 _1053 = f16vec2(A.data[55u]);
    f16vec2 _1066 = f16vec2(A.data[56u]);
    f16vec2 _1075 = f16vec2(A.data[57u]);
    f16vec2 _1084 = f16vec2(A.data[58u]);
    f16vec2 _1093 = f16vec2(A.data[59u]);
    f16vec2 _1102 = f16vec2(A.data[60u]);
    f16vec2 _1111 = f16vec2(A.data[61u]);
    f16vec2 _1120 = f16vec2(A.data[62u]);
    f16vec2 _1129 = f16vec2(A.data[63u]);
    return f16vec2[](fma(_597, f16vec2(B.data[56u], B.data[57u]), fma(_588, f16vec2(B.data[48u], B.data[49u]), fma(_579, f16vec2(B.data[40u], B.data[41u]), fma(_570, f16vec2(B.data[32u], B.data[33u]), fma(_561, f16vec2(B.data[24u], B.data[25u]), fma(_552, f16vec2(B.data[16u], B.data[17u]), fma(_543, f16vec2(B.data[8u], B.data[9u]), fma(_534, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[0u], C.data[1u]))))))))), fma(_597, f16vec2(B.data[58u], B.data[59u]), fma(_588, f16vec2(B.data[50u], B.data[51u]), fma(_579, f16vec2(B.data[42u], B.data[43u]), fma(_570, f16vec2(B.data[34u], B.data[35u]), fma(_561, f16vec2(B.data[26u], B.data[27u]), fma(_552, f16vec2(B.data[18u], B.data[19u]), fma(_543, f16vec2(B.data[10u], B.data[11u]), fma(_534, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[2u], C.data[3u]))))))))), fma(_597, f16vec2(B.data[60u], B.data[61u]), fma(_588, f16vec2(B.data[52u], B.data[53u]), fma(_579, f16vec2(B.data[44u], B.data[45u]), fma(_570, f16vec2(B.data[36u], B.data[37u]), fma(_561, f16vec2(B.data[28u], B.data[29u]), fma(_552, f16vec2(B.data[20u], B.data[21u]), fma(_543, f16vec2(B.data[12u], B.data[13u]), fma(_534, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[4u], C.data[5u]))))))))), fma(_597, f16vec2(B.data[62u], B.data[63u]), fma(_588, f16vec2(B.data[54u], B.data[55u]), fma(_579, f16vec2(B.data[46u], B.data[47u]), fma(_570, f16vec2(B.data[38u], B.data[39u]), fma(_561, f16vec2(B.data[30u], B.data[31u]), fma(_552, f16vec2(B.data[22u], B.data[23u]), fma(_543, f16vec2(B.data[14u], B.data[15u]), fma(_534, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[6u], C.data[7u]))))))))), fma(_673, f16vec2(B.data[56u], B.data[57u]), fma(_664, f16vec2(B.data[48u], B.data[49u]), fma(_655, f16vec2(B.data[40u], B.data[41u]), fma(_646, f16vec2(B.data[32u], B.data[33u]), fma(_637, f16vec2(B.data[24u], B.data[25u]), fma(_628, f16vec2(B.data[16u], B.data[17u]), fma(_619, f16vec2(B.data[8u], B.data[9u]), fma(_610, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[8u], C.data[9u]))))))))), fma(_673, f16vec2(B.data[58u], B.data[59u]), fma(_664, f16vec2(B.data[50u], B.data[51u]), fma(_655, f16vec2(B.data[42u], B.data[43u]), fma(_646, f16vec2(B.data[34u], B.data[35u]), fma(_637, f16vec2(B.data[26u], B.data[27u]), fma(_628, f16vec2(B.data[18u], B.data[19u]), fma(_619, f16vec2(B.data[10u], B.data[11u]), fma(_610, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[10u], C.data[11u]))))))))), fma(_673, f16vec2(B.data[60u], B.data[61u]), fma(_664, f16vec2(B.data[52u], B.data[53u]), fma(_655, f16vec2(B.data[44u], B.data[45u]), fma(_646, f16vec2(B.data[36u], B.data[37u]), fma(_637, f16vec2(B.data[28u], B.data[29u]), fma(_628, f16vec2(B.data[20u], B.data[21u]), fma(_619, f16vec2(B.data[12u], B.data[13u]), fma(_610, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[12u], C.data[13u]))))))))), fma(_673, f16vec2(B.data[62u], B.data[63u]), fma(_664, f16vec2(B.data[54u], B.data[55u]), fma(_655, f16vec2(B.data[46u], B.data[47u]), fma(_646, f16vec2(B.data[38u], B.data[39u]), fma(_637, f16vec2(B.data[30u], B.data[31u]), fma(_628, f16vec2(B.data[22u], B.data[23u]), fma(_619, f16vec2(B.data[14u], B.data[15u]), fma(_610, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[14u], C.data[15u]))))))))), fma(_749, f16vec2(B.data[56u], B.data[57u]), fma(_740, f16vec2(B.data[48u], B.data[49u]), fma(_731, f16vec2(B.data[40u], B.data[41u]), fma(_722, f16vec2(B.data[32u], B.data[33u]), fma(_713, f16vec2(B.data[24u], B.data[25u]), fma(_704, f16vec2(B.data[16u], B.data[17u]), fma(_695, f16vec2(B.data[8u], B.data[9u]), fma(_686, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[16u], C.data[17u]))))))))), fma(_749, f16vec2(B.data[58u], B.data[59u]), fma(_740, f16vec2(B.data[50u], B.data[51u]), fma(_731, f16vec2(B.data[42u], B.data[43u]), fma(_722, f16vec2(B.data[34u], B.data[35u]), fma(_713, f16vec2(B.data[26u], B.data[27u]), fma(_704, f16vec2(B.data[18u], B.data[19u]), fma(_695, f16vec2(B.data[10u], B.data[11u]), fma(_686, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[18u], C.data[19u]))))))))), fma(_749, f16vec2(B.data[60u], B.data[61u]), fma(_740, f16vec2(B.data[52u], B.data[53u]), fma(_731, f16vec2(B.data[44u], B.data[45u]), fma(_722, f16vec2(B.data[36u], B.data[37u]), fma(_713, f16vec2(B.data[28u], B.data[29u]), fma(_704, f16vec2(B.data[20u], B.data[21u]), fma(_695, f16vec2(B.data[12u], B.data[13u]), fma(_686, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[20u], C.data[21u]))))))))), fma(_749, f16vec2(B.data[62u], B.data[63u]), fma(_740, f16vec2(B.data[54u], B.data[55u]), fma(_731, f16vec2(B.data[46u], B.data[47u]), fma(_722, f16vec2(B.data[38u], B.data[39u]), fma(_713, f16vec2(B.data[30u], B.data[31u]), fma(_704, f16vec2(B.data[22u], B.data[23u]), fma(_695, f16vec2(B.data[14u], B.data[15u]), fma(_686, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[22u], C.data[23u]))))))))), fma(_825, f16vec2(B.data[56u], B.data[57u]), fma(_816, f16vec2(B.data[48u], B.data[49u]), fma(_807, f16vec2(B.data[40u], B.data[41u]), fma(_798, f16vec2(B.data[32u], B.data[33u]), fma(_789, f16vec2(B.data[24u], B.data[25u]), fma(_780, f16vec2(B.data[16u], B.data[17u]), fma(_771, f16vec2(B.data[8u], B.data[9u]), fma(_762, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[24u], C.data[25u]))))))))), fma(_825, f16vec2(B.data[58u], B.data[59u]), fma(_816, f16vec2(B.data[50u], B.data[51u]), fma(_807, f16vec2(B.data[42u], B.data[43u]), fma(_798, f16vec2(B.data[34u], B.data[35u]), fma(_789, f16vec2(B.data[26u], B.data[27u]), fma(_780, f16vec2(B.data[18u], B.data[19u]), fma(_771, f16vec2(B.data[10u], B.data[11u]), fma(_762, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[26u], C.data[27u]))))))))), fma(_825, f16vec2(B.data[60u], B.data[61u]), fma(_816, f16vec2(B.data[52u], B.data[53u]), fma(_807, f16vec2(B.data[44u], B.data[45u]), fma(_798, f16vec2(B.data[36u], B.data[37u]), fma(_789, f16vec2(B.data[28u], B.data[29u]), fma(_780, f16vec2(B.data[20u], B.data[21u]), fma(_771, f16vec2(B.data[12u], B.data[13u]), fma(_762, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[28u], C.data[29u]))))))))), fma(_825, f16vec2(B.data[62u], B.data[63u]), fma(_816, f16vec2(B.data[54u], B.data[55u]), fma(_807, f16vec2(B.data[46u], B.data[47u]), fma(_798, f16vec2(B.data[38u], B.data[39u]), fma(_789, f16vec2(B.data[30u], B.data[31u]), fma(_780, f16vec2(B.data[22u], B.data[23u]), fma(_771, f16vec2(B.data[14u], B.data[15u]), fma(_762, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[30u], C.data[31u]))))))))), fma(_901, f16vec2(B.data[56u], B.data[57u]), fma(_892, f16vec2(B.data[48u], B.data[49u]), fma(_883, f16vec2(B.data[40u], B.data[41u]), fma(_874, f16vec2(B.data[32u], B.data[33u]), fma(_865, f16vec2(B.data[24u], B.data[25u]), fma(_856, f16vec2(B.data[16u], B.data[17u]), fma(_847, f16vec2(B.data[8u], B.data[9u]), fma(_838, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[32u], C.data[33u]))))))))), fma(_901, f16vec2(B.data[58u], B.data[59u]), fma(_892, f16vec2(B.data[50u], B.data[51u]), fma(_883, f16vec2(B.data[42u], B.data[43u]), fma(_874, f16vec2(B.data[34u], B.data[35u]), fma(_865, f16vec2(B.data[26u], B.data[27u]), fma(_856, f16vec2(B.data[18u], B.data[19u]), fma(_847, f16vec2(B.data[10u], B.data[11u]), fma(_838, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[34u], C.data[35u]))))))))), fma(_901, f16vec2(B.data[60u], B.data[61u]), fma(_892, f16vec2(B.data[52u], B.data[53u]), fma(_883, f16vec2(B.data[44u], B.data[45u]), fma(_874, f16vec2(B.data[36u], B.data[37u]), fma(_865, f16vec2(B.data[28u], B.data[29u]), fma(_856, f16vec2(B.data[20u], B.data[21u]), fma(_847, f16vec2(B.data[12u], B.data[13u]), fma(_838, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[36u], C.data[37u]))))))))), fma(_901, f16vec2(B.data[62u], B.data[63u]), fma(_892, f16vec2(B.data[54u], B.data[55u]), fma(_883, f16vec2(B.data[46u], B.data[47u]), fma(_874, f16vec2(B.data[38u], B.data[39u]), fma(_865, f16vec2(B.data[30u], B.data[31u]), fma(_856, f16vec2(B.data[22u], B.data[23u]), fma(_847, f16vec2(B.data[14u], B.data[15u]), fma(_838, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[38u], C.data[39u]))))))))), fma(_977, f16vec2(B.data[56u], B.data[57u]), fma(_968, f16vec2(B.data[48u], B.data[49u]), fma(_959, f16vec2(B.data[40u], B.data[41u]), fma(_950, f16vec2(B.data[32u], B.data[33u]), fma(_941, f16vec2(B.data[24u], B.data[25u]), fma(_932, f16vec2(B.data[16u], B.data[17u]), fma(_923, f16vec2(B.data[8u], B.data[9u]), fma(_914, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[40u], C.data[41u]))))))))), fma(_977, f16vec2(B.data[58u], B.data[59u]), fma(_968, f16vec2(B.data[50u], B.data[51u]), fma(_959, f16vec2(B.data[42u], B.data[43u]), fma(_950, f16vec2(B.data[34u], B.data[35u]), fma(_941, f16vec2(B.data[26u], B.data[27u]), fma(_932, f16vec2(B.data[18u], B.data[19u]), fma(_923, f16vec2(B.data[10u], B.data[11u]), fma(_914, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[42u], C.data[43u]))))))))), fma(_977, f16vec2(B.data[60u], B.data[61u]), fma(_968, f16vec2(B.data[52u], B.data[53u]), fma(_959, f16vec2(B.data[44u], B.data[45u]), fma(_950, f16vec2(B.data[36u], B.data[37u]), fma(_941, f16vec2(B.data[28u], B.data[29u]), fma(_932, f16vec2(B.data[20u], B.data[21u]), fma(_923, f16vec2(B.data[12u], B.data[13u]), fma(_914, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[44u], C.data[45u]))))))))), fma(_977, f16vec2(B.data[62u], B.data[63u]), fma(_968, f16vec2(B.data[54u], B.data[55u]), fma(_959, f16vec2(B.data[46u], B.data[47u]), fma(_950, f16vec2(B.data[38u], B.data[39u]), fma(_941, f16vec2(B.data[30u], B.data[31u]), fma(_932, f16vec2(B.data[22u], B.data[23u]), fma(_923, f16vec2(B.data[14u], B.data[15u]), fma(_914, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[46u], C.data[47u]))))))))), fma(_1053, f16vec2(B.data[56u], B.data[57u]), fma(_1044, f16vec2(B.data[48u], B.data[49u]), fma(_1035, f16vec2(B.data[40u], B.data[41u]), fma(_1026, f16vec2(B.data[32u], B.data[33u]), fma(_1017, f16vec2(B.data[24u], B.data[25u]), fma(_1008, f16vec2(B.data[16u], B.data[17u]), fma(_999, f16vec2(B.data[8u], B.data[9u]), fma(_990, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[48u], C.data[49u]))))))))), fma(_1053, f16vec2(B.data[58u], B.data[59u]), fma(_1044, f16vec2(B.data[50u], B.data[51u]), fma(_1035, f16vec2(B.data[42u], B.data[43u]), fma(_1026, f16vec2(B.data[34u], B.data[35u]), fma(_1017, f16vec2(B.data[26u], B.data[27u]), fma(_1008, f16vec2(B.data[18u], B.data[19u]), fma(_999, f16vec2(B.data[10u], B.data[11u]), fma(_990, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[50u], C.data[51u]))))))))), fma(_1053, f16vec2(B.data[60u], B.data[61u]), fma(_1044, f16vec2(B.data[52u], B.data[53u]), fma(_1035, f16vec2(B.data[44u], B.data[45u]), fma(_1026, f16vec2(B.data[36u], B.data[37u]), fma(_1017, f16vec2(B.data[28u], B.data[29u]), fma(_1008, f16vec2(B.data[20u], B.data[21u]), fma(_999, f16vec2(B.data[12u], B.data[13u]), fma(_990, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[52u], C.data[53u]))))))))), fma(_1053, f16vec2(B.data[62u], B.data[63u]), fma(_1044, f16vec2(B.data[54u], B.data[55u]), fma(_1035, f16vec2(B.data[46u], B.data[47u]), fma(_1026, f16vec2(B.data[38u], B.data[39u]), fma(_1017, f16vec2(B.data[30u], B.data[31u]), fma(_1008, f16vec2(B.data[22u], B.data[23u]), fma(_999, f16vec2(B.data[14u], B.data[15u]), fma(_990, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[54u], C.data[55u]))))))))), fma(_1129, f16vec2(B.data[56u], B.data[57u]), fma(_1120, f16vec2(B.data[48u], B.data[49u]), fma(_1111, f16vec2(B.data[40u], B.data[41u]), fma(_1102, f16vec2(B.data[32u], B.data[33u]), fma(_1093, f16vec2(B.data[24u], B.data[25u]), fma(_1084, f16vec2(B.data[16u], B.data[17u]), fma(_1075, f16vec2(B.data[8u], B.data[9u]), fma(_1066, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[56u], C.data[57u]))))))))), fma(_1129, f16vec2(B.data[58u], B.data[59u]), fma(_1120, f16vec2(B.data[50u], B.data[51u]), fma(_1111, f16vec2(B.data[42u], B.data[43u]), fma(_1102, f16vec2(B.data[34u], B.data[35u]), fma(_1093, f16vec2(B.data[26u], B.data[27u]), fma(_1084, f16vec2(B.data[18u], B.data[19u]), fma(_1075, f16vec2(B.data[10u], B.data[11u]), fma(_1066, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[58u], C.data[59u]))))))))), fma(_1129, f16vec2(B.data[60u], B.data[61u]), fma(_1120, f16vec2(B.data[52u], B.data[53u]), fma(_1111, f16vec2(B.data[44u], B.data[45u]), fma(_1102, f16vec2(B.data[36u], B.data[37u]), fma(_1093, f16vec2(B.data[28u], B.data[29u]), fma(_1084, f16vec2(B.data[20u], B.data[21u]), fma(_1075, f16vec2(B.data[12u], B.data[13u]), fma(_1066, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[60u], C.data[61u]))))))))), fma(_1129, f16vec2(B.data[62u], B.data[63u]), fma(_1120, f16vec2(B.data[54u], B.data[55u]), fma(_1111, f16vec2(B.data[46u], B.data[47u]), fma(_1102, f16vec2(B.data[38u], B.data[39u]), fma(_1093, f16vec2(B.data[30u], B.data[31u]), fma(_1084, f16vec2(B.data[22u], B.data[23u]), fma(_1075, f16vec2(B.data[14u], B.data[15u]), fma(_1066, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[62u], C.data[63u]))))))))));
}

void _1181(uint _1182, f16vec2 _1183)
{
    D.data[_1182] = _1183.x;
    D.data[_1182 + 1u] = _1183.y;
}

void _1216(uint _1217, f16vec2 _1218)
{
    E.data[_1217] = _1218.x;
    E.data[_1217 + 1u] = _1218.y;
}

void main()
{
    uint _1156 = 0u;
    f16vec2 _1155[32];
    uint _1161;
    for (;;)
    {
        _1161 = _1156;
        if (_1161 < 64u)
        {
            _1155[_1161 / 2u] = _1140(((uint(0) + (_1161 / 8u)) * uint(8)) + (uint(0) + (_1161 % 8u)));
            _1156 = _1161 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _36[32] = _1155;
    f16vec2 tempArg[32] = _36;
    f16vec2 w[32] = _36;
    f16vec2 _55[32] = _79();
    f16vec2 tempArg_1[32] = _55;
    f16vec2 d[32] = _55;
    f16vec2 _1191[32] = _55;
    uint _1192 = 0u;
    uint _1197;
    for (;;)
    {
        _1197 = _1192;
        if (_1197 < 64u)
        {
            _1181(((uint(0) + (_1197 / 8u)) * uint(8)) + (uint(0) + (_1197 % 8u)), _1191[_1197 / 2u]);
            _1192 = _1197 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _1226[32] = _36;
    uint _1227 = 0u;
    uint _1232;
    for (;;)
    {
        _1232 = _1227;
        if (_1232 < 64u)
        {
            _1216(((uint(0) + (_1232 / 8u)) * uint(8)) + (uint(0) + (_1232 % 8u)), _1226[_1232 / 2u]);
            _1227 = _1232 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

