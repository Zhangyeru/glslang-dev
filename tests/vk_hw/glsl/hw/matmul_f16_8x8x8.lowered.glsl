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

f16vec2[32] _72()
{
    f16vec2 _527 = f16vec2(A.data[0u]);
    f16vec2 _536 = f16vec2(A.data[1u]);
    f16vec2 _545 = f16vec2(A.data[2u]);
    f16vec2 _554 = f16vec2(A.data[3u]);
    f16vec2 _563 = f16vec2(A.data[4u]);
    f16vec2 _572 = f16vec2(A.data[5u]);
    f16vec2 _581 = f16vec2(A.data[6u]);
    f16vec2 _590 = f16vec2(A.data[7u]);
    f16vec2 _603 = f16vec2(A.data[8u]);
    f16vec2 _612 = f16vec2(A.data[9u]);
    f16vec2 _621 = f16vec2(A.data[10u]);
    f16vec2 _630 = f16vec2(A.data[11u]);
    f16vec2 _639 = f16vec2(A.data[12u]);
    f16vec2 _648 = f16vec2(A.data[13u]);
    f16vec2 _657 = f16vec2(A.data[14u]);
    f16vec2 _666 = f16vec2(A.data[15u]);
    f16vec2 _679 = f16vec2(A.data[16u]);
    f16vec2 _688 = f16vec2(A.data[17u]);
    f16vec2 _697 = f16vec2(A.data[18u]);
    f16vec2 _706 = f16vec2(A.data[19u]);
    f16vec2 _715 = f16vec2(A.data[20u]);
    f16vec2 _724 = f16vec2(A.data[21u]);
    f16vec2 _733 = f16vec2(A.data[22u]);
    f16vec2 _742 = f16vec2(A.data[23u]);
    f16vec2 _755 = f16vec2(A.data[24u]);
    f16vec2 _764 = f16vec2(A.data[25u]);
    f16vec2 _773 = f16vec2(A.data[26u]);
    f16vec2 _782 = f16vec2(A.data[27u]);
    f16vec2 _791 = f16vec2(A.data[28u]);
    f16vec2 _800 = f16vec2(A.data[29u]);
    f16vec2 _809 = f16vec2(A.data[30u]);
    f16vec2 _818 = f16vec2(A.data[31u]);
    f16vec2 _831 = f16vec2(A.data[32u]);
    f16vec2 _840 = f16vec2(A.data[33u]);
    f16vec2 _849 = f16vec2(A.data[34u]);
    f16vec2 _858 = f16vec2(A.data[35u]);
    f16vec2 _867 = f16vec2(A.data[36u]);
    f16vec2 _876 = f16vec2(A.data[37u]);
    f16vec2 _885 = f16vec2(A.data[38u]);
    f16vec2 _894 = f16vec2(A.data[39u]);
    f16vec2 _907 = f16vec2(A.data[40u]);
    f16vec2 _916 = f16vec2(A.data[41u]);
    f16vec2 _925 = f16vec2(A.data[42u]);
    f16vec2 _934 = f16vec2(A.data[43u]);
    f16vec2 _943 = f16vec2(A.data[44u]);
    f16vec2 _952 = f16vec2(A.data[45u]);
    f16vec2 _961 = f16vec2(A.data[46u]);
    f16vec2 _970 = f16vec2(A.data[47u]);
    f16vec2 _983 = f16vec2(A.data[48u]);
    f16vec2 _992 = f16vec2(A.data[49u]);
    f16vec2 _1001 = f16vec2(A.data[50u]);
    f16vec2 _1010 = f16vec2(A.data[51u]);
    f16vec2 _1019 = f16vec2(A.data[52u]);
    f16vec2 _1028 = f16vec2(A.data[53u]);
    f16vec2 _1037 = f16vec2(A.data[54u]);
    f16vec2 _1046 = f16vec2(A.data[55u]);
    f16vec2 _1059 = f16vec2(A.data[56u]);
    f16vec2 _1068 = f16vec2(A.data[57u]);
    f16vec2 _1077 = f16vec2(A.data[58u]);
    f16vec2 _1086 = f16vec2(A.data[59u]);
    f16vec2 _1095 = f16vec2(A.data[60u]);
    f16vec2 _1104 = f16vec2(A.data[61u]);
    f16vec2 _1113 = f16vec2(A.data[62u]);
    f16vec2 _1122 = f16vec2(A.data[63u]);
    return f16vec2[](fma(_590, f16vec2(B.data[56u], B.data[57u]), fma(_581, f16vec2(B.data[48u], B.data[49u]), fma(_572, f16vec2(B.data[40u], B.data[41u]), fma(_563, f16vec2(B.data[32u], B.data[33u]), fma(_554, f16vec2(B.data[24u], B.data[25u]), fma(_545, f16vec2(B.data[16u], B.data[17u]), fma(_536, f16vec2(B.data[8u], B.data[9u]), fma(_527, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[0u], C.data[1u]))))))))), fma(_590, f16vec2(B.data[58u], B.data[59u]), fma(_581, f16vec2(B.data[50u], B.data[51u]), fma(_572, f16vec2(B.data[42u], B.data[43u]), fma(_563, f16vec2(B.data[34u], B.data[35u]), fma(_554, f16vec2(B.data[26u], B.data[27u]), fma(_545, f16vec2(B.data[18u], B.data[19u]), fma(_536, f16vec2(B.data[10u], B.data[11u]), fma(_527, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[2u], C.data[3u]))))))))), fma(_590, f16vec2(B.data[60u], B.data[61u]), fma(_581, f16vec2(B.data[52u], B.data[53u]), fma(_572, f16vec2(B.data[44u], B.data[45u]), fma(_563, f16vec2(B.data[36u], B.data[37u]), fma(_554, f16vec2(B.data[28u], B.data[29u]), fma(_545, f16vec2(B.data[20u], B.data[21u]), fma(_536, f16vec2(B.data[12u], B.data[13u]), fma(_527, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[4u], C.data[5u]))))))))), fma(_590, f16vec2(B.data[62u], B.data[63u]), fma(_581, f16vec2(B.data[54u], B.data[55u]), fma(_572, f16vec2(B.data[46u], B.data[47u]), fma(_563, f16vec2(B.data[38u], B.data[39u]), fma(_554, f16vec2(B.data[30u], B.data[31u]), fma(_545, f16vec2(B.data[22u], B.data[23u]), fma(_536, f16vec2(B.data[14u], B.data[15u]), fma(_527, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[6u], C.data[7u]))))))))), fma(_666, f16vec2(B.data[56u], B.data[57u]), fma(_657, f16vec2(B.data[48u], B.data[49u]), fma(_648, f16vec2(B.data[40u], B.data[41u]), fma(_639, f16vec2(B.data[32u], B.data[33u]), fma(_630, f16vec2(B.data[24u], B.data[25u]), fma(_621, f16vec2(B.data[16u], B.data[17u]), fma(_612, f16vec2(B.data[8u], B.data[9u]), fma(_603, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[8u], C.data[9u]))))))))), fma(_666, f16vec2(B.data[58u], B.data[59u]), fma(_657, f16vec2(B.data[50u], B.data[51u]), fma(_648, f16vec2(B.data[42u], B.data[43u]), fma(_639, f16vec2(B.data[34u], B.data[35u]), fma(_630, f16vec2(B.data[26u], B.data[27u]), fma(_621, f16vec2(B.data[18u], B.data[19u]), fma(_612, f16vec2(B.data[10u], B.data[11u]), fma(_603, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[10u], C.data[11u]))))))))), fma(_666, f16vec2(B.data[60u], B.data[61u]), fma(_657, f16vec2(B.data[52u], B.data[53u]), fma(_648, f16vec2(B.data[44u], B.data[45u]), fma(_639, f16vec2(B.data[36u], B.data[37u]), fma(_630, f16vec2(B.data[28u], B.data[29u]), fma(_621, f16vec2(B.data[20u], B.data[21u]), fma(_612, f16vec2(B.data[12u], B.data[13u]), fma(_603, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[12u], C.data[13u]))))))))), fma(_666, f16vec2(B.data[62u], B.data[63u]), fma(_657, f16vec2(B.data[54u], B.data[55u]), fma(_648, f16vec2(B.data[46u], B.data[47u]), fma(_639, f16vec2(B.data[38u], B.data[39u]), fma(_630, f16vec2(B.data[30u], B.data[31u]), fma(_621, f16vec2(B.data[22u], B.data[23u]), fma(_612, f16vec2(B.data[14u], B.data[15u]), fma(_603, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[14u], C.data[15u]))))))))), fma(_742, f16vec2(B.data[56u], B.data[57u]), fma(_733, f16vec2(B.data[48u], B.data[49u]), fma(_724, f16vec2(B.data[40u], B.data[41u]), fma(_715, f16vec2(B.data[32u], B.data[33u]), fma(_706, f16vec2(B.data[24u], B.data[25u]), fma(_697, f16vec2(B.data[16u], B.data[17u]), fma(_688, f16vec2(B.data[8u], B.data[9u]), fma(_679, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[16u], C.data[17u]))))))))), fma(_742, f16vec2(B.data[58u], B.data[59u]), fma(_733, f16vec2(B.data[50u], B.data[51u]), fma(_724, f16vec2(B.data[42u], B.data[43u]), fma(_715, f16vec2(B.data[34u], B.data[35u]), fma(_706, f16vec2(B.data[26u], B.data[27u]), fma(_697, f16vec2(B.data[18u], B.data[19u]), fma(_688, f16vec2(B.data[10u], B.data[11u]), fma(_679, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[18u], C.data[19u]))))))))), fma(_742, f16vec2(B.data[60u], B.data[61u]), fma(_733, f16vec2(B.data[52u], B.data[53u]), fma(_724, f16vec2(B.data[44u], B.data[45u]), fma(_715, f16vec2(B.data[36u], B.data[37u]), fma(_706, f16vec2(B.data[28u], B.data[29u]), fma(_697, f16vec2(B.data[20u], B.data[21u]), fma(_688, f16vec2(B.data[12u], B.data[13u]), fma(_679, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[20u], C.data[21u]))))))))), fma(_742, f16vec2(B.data[62u], B.data[63u]), fma(_733, f16vec2(B.data[54u], B.data[55u]), fma(_724, f16vec2(B.data[46u], B.data[47u]), fma(_715, f16vec2(B.data[38u], B.data[39u]), fma(_706, f16vec2(B.data[30u], B.data[31u]), fma(_697, f16vec2(B.data[22u], B.data[23u]), fma(_688, f16vec2(B.data[14u], B.data[15u]), fma(_679, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[22u], C.data[23u]))))))))), fma(_818, f16vec2(B.data[56u], B.data[57u]), fma(_809, f16vec2(B.data[48u], B.data[49u]), fma(_800, f16vec2(B.data[40u], B.data[41u]), fma(_791, f16vec2(B.data[32u], B.data[33u]), fma(_782, f16vec2(B.data[24u], B.data[25u]), fma(_773, f16vec2(B.data[16u], B.data[17u]), fma(_764, f16vec2(B.data[8u], B.data[9u]), fma(_755, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[24u], C.data[25u]))))))))), fma(_818, f16vec2(B.data[58u], B.data[59u]), fma(_809, f16vec2(B.data[50u], B.data[51u]), fma(_800, f16vec2(B.data[42u], B.data[43u]), fma(_791, f16vec2(B.data[34u], B.data[35u]), fma(_782, f16vec2(B.data[26u], B.data[27u]), fma(_773, f16vec2(B.data[18u], B.data[19u]), fma(_764, f16vec2(B.data[10u], B.data[11u]), fma(_755, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[26u], C.data[27u]))))))))), fma(_818, f16vec2(B.data[60u], B.data[61u]), fma(_809, f16vec2(B.data[52u], B.data[53u]), fma(_800, f16vec2(B.data[44u], B.data[45u]), fma(_791, f16vec2(B.data[36u], B.data[37u]), fma(_782, f16vec2(B.data[28u], B.data[29u]), fma(_773, f16vec2(B.data[20u], B.data[21u]), fma(_764, f16vec2(B.data[12u], B.data[13u]), fma(_755, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[28u], C.data[29u]))))))))), fma(_818, f16vec2(B.data[62u], B.data[63u]), fma(_809, f16vec2(B.data[54u], B.data[55u]), fma(_800, f16vec2(B.data[46u], B.data[47u]), fma(_791, f16vec2(B.data[38u], B.data[39u]), fma(_782, f16vec2(B.data[30u], B.data[31u]), fma(_773, f16vec2(B.data[22u], B.data[23u]), fma(_764, f16vec2(B.data[14u], B.data[15u]), fma(_755, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[30u], C.data[31u]))))))))), fma(_894, f16vec2(B.data[56u], B.data[57u]), fma(_885, f16vec2(B.data[48u], B.data[49u]), fma(_876, f16vec2(B.data[40u], B.data[41u]), fma(_867, f16vec2(B.data[32u], B.data[33u]), fma(_858, f16vec2(B.data[24u], B.data[25u]), fma(_849, f16vec2(B.data[16u], B.data[17u]), fma(_840, f16vec2(B.data[8u], B.data[9u]), fma(_831, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[32u], C.data[33u]))))))))), fma(_894, f16vec2(B.data[58u], B.data[59u]), fma(_885, f16vec2(B.data[50u], B.data[51u]), fma(_876, f16vec2(B.data[42u], B.data[43u]), fma(_867, f16vec2(B.data[34u], B.data[35u]), fma(_858, f16vec2(B.data[26u], B.data[27u]), fma(_849, f16vec2(B.data[18u], B.data[19u]), fma(_840, f16vec2(B.data[10u], B.data[11u]), fma(_831, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[34u], C.data[35u]))))))))), fma(_894, f16vec2(B.data[60u], B.data[61u]), fma(_885, f16vec2(B.data[52u], B.data[53u]), fma(_876, f16vec2(B.data[44u], B.data[45u]), fma(_867, f16vec2(B.data[36u], B.data[37u]), fma(_858, f16vec2(B.data[28u], B.data[29u]), fma(_849, f16vec2(B.data[20u], B.data[21u]), fma(_840, f16vec2(B.data[12u], B.data[13u]), fma(_831, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[36u], C.data[37u]))))))))), fma(_894, f16vec2(B.data[62u], B.data[63u]), fma(_885, f16vec2(B.data[54u], B.data[55u]), fma(_876, f16vec2(B.data[46u], B.data[47u]), fma(_867, f16vec2(B.data[38u], B.data[39u]), fma(_858, f16vec2(B.data[30u], B.data[31u]), fma(_849, f16vec2(B.data[22u], B.data[23u]), fma(_840, f16vec2(B.data[14u], B.data[15u]), fma(_831, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[38u], C.data[39u]))))))))), fma(_970, f16vec2(B.data[56u], B.data[57u]), fma(_961, f16vec2(B.data[48u], B.data[49u]), fma(_952, f16vec2(B.data[40u], B.data[41u]), fma(_943, f16vec2(B.data[32u], B.data[33u]), fma(_934, f16vec2(B.data[24u], B.data[25u]), fma(_925, f16vec2(B.data[16u], B.data[17u]), fma(_916, f16vec2(B.data[8u], B.data[9u]), fma(_907, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[40u], C.data[41u]))))))))), fma(_970, f16vec2(B.data[58u], B.data[59u]), fma(_961, f16vec2(B.data[50u], B.data[51u]), fma(_952, f16vec2(B.data[42u], B.data[43u]), fma(_943, f16vec2(B.data[34u], B.data[35u]), fma(_934, f16vec2(B.data[26u], B.data[27u]), fma(_925, f16vec2(B.data[18u], B.data[19u]), fma(_916, f16vec2(B.data[10u], B.data[11u]), fma(_907, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[42u], C.data[43u]))))))))), fma(_970, f16vec2(B.data[60u], B.data[61u]), fma(_961, f16vec2(B.data[52u], B.data[53u]), fma(_952, f16vec2(B.data[44u], B.data[45u]), fma(_943, f16vec2(B.data[36u], B.data[37u]), fma(_934, f16vec2(B.data[28u], B.data[29u]), fma(_925, f16vec2(B.data[20u], B.data[21u]), fma(_916, f16vec2(B.data[12u], B.data[13u]), fma(_907, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[44u], C.data[45u]))))))))), fma(_970, f16vec2(B.data[62u], B.data[63u]), fma(_961, f16vec2(B.data[54u], B.data[55u]), fma(_952, f16vec2(B.data[46u], B.data[47u]), fma(_943, f16vec2(B.data[38u], B.data[39u]), fma(_934, f16vec2(B.data[30u], B.data[31u]), fma(_925, f16vec2(B.data[22u], B.data[23u]), fma(_916, f16vec2(B.data[14u], B.data[15u]), fma(_907, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[46u], C.data[47u]))))))))), fma(_1046, f16vec2(B.data[56u], B.data[57u]), fma(_1037, f16vec2(B.data[48u], B.data[49u]), fma(_1028, f16vec2(B.data[40u], B.data[41u]), fma(_1019, f16vec2(B.data[32u], B.data[33u]), fma(_1010, f16vec2(B.data[24u], B.data[25u]), fma(_1001, f16vec2(B.data[16u], B.data[17u]), fma(_992, f16vec2(B.data[8u], B.data[9u]), fma(_983, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[48u], C.data[49u]))))))))), fma(_1046, f16vec2(B.data[58u], B.data[59u]), fma(_1037, f16vec2(B.data[50u], B.data[51u]), fma(_1028, f16vec2(B.data[42u], B.data[43u]), fma(_1019, f16vec2(B.data[34u], B.data[35u]), fma(_1010, f16vec2(B.data[26u], B.data[27u]), fma(_1001, f16vec2(B.data[18u], B.data[19u]), fma(_992, f16vec2(B.data[10u], B.data[11u]), fma(_983, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[50u], C.data[51u]))))))))), fma(_1046, f16vec2(B.data[60u], B.data[61u]), fma(_1037, f16vec2(B.data[52u], B.data[53u]), fma(_1028, f16vec2(B.data[44u], B.data[45u]), fma(_1019, f16vec2(B.data[36u], B.data[37u]), fma(_1010, f16vec2(B.data[28u], B.data[29u]), fma(_1001, f16vec2(B.data[20u], B.data[21u]), fma(_992, f16vec2(B.data[12u], B.data[13u]), fma(_983, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[52u], C.data[53u]))))))))), fma(_1046, f16vec2(B.data[62u], B.data[63u]), fma(_1037, f16vec2(B.data[54u], B.data[55u]), fma(_1028, f16vec2(B.data[46u], B.data[47u]), fma(_1019, f16vec2(B.data[38u], B.data[39u]), fma(_1010, f16vec2(B.data[30u], B.data[31u]), fma(_1001, f16vec2(B.data[22u], B.data[23u]), fma(_992, f16vec2(B.data[14u], B.data[15u]), fma(_983, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[54u], C.data[55u]))))))))), fma(_1122, f16vec2(B.data[56u], B.data[57u]), fma(_1113, f16vec2(B.data[48u], B.data[49u]), fma(_1104, f16vec2(B.data[40u], B.data[41u]), fma(_1095, f16vec2(B.data[32u], B.data[33u]), fma(_1086, f16vec2(B.data[24u], B.data[25u]), fma(_1077, f16vec2(B.data[16u], B.data[17u]), fma(_1068, f16vec2(B.data[8u], B.data[9u]), fma(_1059, f16vec2(B.data[0u], B.data[1u]), f16vec2(C.data[56u], C.data[57u]))))))))), fma(_1122, f16vec2(B.data[58u], B.data[59u]), fma(_1113, f16vec2(B.data[50u], B.data[51u]), fma(_1104, f16vec2(B.data[42u], B.data[43u]), fma(_1095, f16vec2(B.data[34u], B.data[35u]), fma(_1086, f16vec2(B.data[26u], B.data[27u]), fma(_1077, f16vec2(B.data[18u], B.data[19u]), fma(_1068, f16vec2(B.data[10u], B.data[11u]), fma(_1059, f16vec2(B.data[2u], B.data[3u]), f16vec2(C.data[58u], C.data[59u]))))))))), fma(_1122, f16vec2(B.data[60u], B.data[61u]), fma(_1113, f16vec2(B.data[52u], B.data[53u]), fma(_1104, f16vec2(B.data[44u], B.data[45u]), fma(_1095, f16vec2(B.data[36u], B.data[37u]), fma(_1086, f16vec2(B.data[28u], B.data[29u]), fma(_1077, f16vec2(B.data[20u], B.data[21u]), fma(_1068, f16vec2(B.data[12u], B.data[13u]), fma(_1059, f16vec2(B.data[4u], B.data[5u]), f16vec2(C.data[60u], C.data[61u]))))))))), fma(_1122, f16vec2(B.data[62u], B.data[63u]), fma(_1113, f16vec2(B.data[54u], B.data[55u]), fma(_1104, f16vec2(B.data[46u], B.data[47u]), fma(_1095, f16vec2(B.data[38u], B.data[39u]), fma(_1086, f16vec2(B.data[30u], B.data[31u]), fma(_1077, f16vec2(B.data[22u], B.data[23u]), fma(_1068, f16vec2(B.data[14u], B.data[15u]), fma(_1059, f16vec2(B.data[6u], B.data[7u]), f16vec2(C.data[62u], C.data[63u]))))))))));
}

void _1133(uint _1134, f16vec2 _1135)
{
    D.data[_1134] = _1135.x;
    D.data[_1134 + 1u] = _1135.y;
}

void main()
{
    f16vec2 _55[32] = _72();
    f16vec2 tempArg[32] = _55;
    f16vec2 d[32] = _55;
    f16vec2 _1148[32] = _55;
    uint _1149 = 0u;
    uint _1154;
    for (;;)
    {
        _1154 = _1149;
        if (_1154 < 64u)
        {
            _1133(((uint(0) + (_1154 / 8u)) * uint(8)) + (uint(0) + (_1154 % 8u)), _1148[_1154 / 2u]);
            _1149 = _1154 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

