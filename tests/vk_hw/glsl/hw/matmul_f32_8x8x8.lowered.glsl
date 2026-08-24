#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec2[32] _72()
{
    vec2 _527 = vec2(A.data[0u]);
    vec2 _536 = vec2(A.data[1u]);
    vec2 _545 = vec2(A.data[2u]);
    vec2 _554 = vec2(A.data[3u]);
    vec2 _563 = vec2(A.data[4u]);
    vec2 _572 = vec2(A.data[5u]);
    vec2 _581 = vec2(A.data[6u]);
    vec2 _590 = vec2(A.data[7u]);
    vec2 _603 = vec2(A.data[8u]);
    vec2 _612 = vec2(A.data[9u]);
    vec2 _621 = vec2(A.data[10u]);
    vec2 _630 = vec2(A.data[11u]);
    vec2 _639 = vec2(A.data[12u]);
    vec2 _648 = vec2(A.data[13u]);
    vec2 _657 = vec2(A.data[14u]);
    vec2 _666 = vec2(A.data[15u]);
    vec2 _679 = vec2(A.data[16u]);
    vec2 _688 = vec2(A.data[17u]);
    vec2 _697 = vec2(A.data[18u]);
    vec2 _706 = vec2(A.data[19u]);
    vec2 _715 = vec2(A.data[20u]);
    vec2 _724 = vec2(A.data[21u]);
    vec2 _733 = vec2(A.data[22u]);
    vec2 _742 = vec2(A.data[23u]);
    vec2 _755 = vec2(A.data[24u]);
    vec2 _764 = vec2(A.data[25u]);
    vec2 _773 = vec2(A.data[26u]);
    vec2 _782 = vec2(A.data[27u]);
    vec2 _791 = vec2(A.data[28u]);
    vec2 _800 = vec2(A.data[29u]);
    vec2 _809 = vec2(A.data[30u]);
    vec2 _818 = vec2(A.data[31u]);
    vec2 _831 = vec2(A.data[32u]);
    vec2 _840 = vec2(A.data[33u]);
    vec2 _849 = vec2(A.data[34u]);
    vec2 _858 = vec2(A.data[35u]);
    vec2 _867 = vec2(A.data[36u]);
    vec2 _876 = vec2(A.data[37u]);
    vec2 _885 = vec2(A.data[38u]);
    vec2 _894 = vec2(A.data[39u]);
    vec2 _907 = vec2(A.data[40u]);
    vec2 _916 = vec2(A.data[41u]);
    vec2 _925 = vec2(A.data[42u]);
    vec2 _934 = vec2(A.data[43u]);
    vec2 _943 = vec2(A.data[44u]);
    vec2 _952 = vec2(A.data[45u]);
    vec2 _961 = vec2(A.data[46u]);
    vec2 _970 = vec2(A.data[47u]);
    vec2 _983 = vec2(A.data[48u]);
    vec2 _992 = vec2(A.data[49u]);
    vec2 _1001 = vec2(A.data[50u]);
    vec2 _1010 = vec2(A.data[51u]);
    vec2 _1019 = vec2(A.data[52u]);
    vec2 _1028 = vec2(A.data[53u]);
    vec2 _1037 = vec2(A.data[54u]);
    vec2 _1046 = vec2(A.data[55u]);
    vec2 _1059 = vec2(A.data[56u]);
    vec2 _1068 = vec2(A.data[57u]);
    vec2 _1077 = vec2(A.data[58u]);
    vec2 _1086 = vec2(A.data[59u]);
    vec2 _1095 = vec2(A.data[60u]);
    vec2 _1104 = vec2(A.data[61u]);
    vec2 _1113 = vec2(A.data[62u]);
    vec2 _1122 = vec2(A.data[63u]);
    return vec2[](fma(_590, vec2(B.data[56u], B.data[57u]), fma(_581, vec2(B.data[48u], B.data[49u]), fma(_572, vec2(B.data[40u], B.data[41u]), fma(_563, vec2(B.data[32u], B.data[33u]), fma(_554, vec2(B.data[24u], B.data[25u]), fma(_545, vec2(B.data[16u], B.data[17u]), fma(_536, vec2(B.data[8u], B.data[9u]), fma(_527, vec2(B.data[0u], B.data[1u]), vec2(C.data[0u], C.data[1u]))))))))), fma(_590, vec2(B.data[58u], B.data[59u]), fma(_581, vec2(B.data[50u], B.data[51u]), fma(_572, vec2(B.data[42u], B.data[43u]), fma(_563, vec2(B.data[34u], B.data[35u]), fma(_554, vec2(B.data[26u], B.data[27u]), fma(_545, vec2(B.data[18u], B.data[19u]), fma(_536, vec2(B.data[10u], B.data[11u]), fma(_527, vec2(B.data[2u], B.data[3u]), vec2(C.data[2u], C.data[3u]))))))))), fma(_590, vec2(B.data[60u], B.data[61u]), fma(_581, vec2(B.data[52u], B.data[53u]), fma(_572, vec2(B.data[44u], B.data[45u]), fma(_563, vec2(B.data[36u], B.data[37u]), fma(_554, vec2(B.data[28u], B.data[29u]), fma(_545, vec2(B.data[20u], B.data[21u]), fma(_536, vec2(B.data[12u], B.data[13u]), fma(_527, vec2(B.data[4u], B.data[5u]), vec2(C.data[4u], C.data[5u]))))))))), fma(_590, vec2(B.data[62u], B.data[63u]), fma(_581, vec2(B.data[54u], B.data[55u]), fma(_572, vec2(B.data[46u], B.data[47u]), fma(_563, vec2(B.data[38u], B.data[39u]), fma(_554, vec2(B.data[30u], B.data[31u]), fma(_545, vec2(B.data[22u], B.data[23u]), fma(_536, vec2(B.data[14u], B.data[15u]), fma(_527, vec2(B.data[6u], B.data[7u]), vec2(C.data[6u], C.data[7u]))))))))), fma(_666, vec2(B.data[56u], B.data[57u]), fma(_657, vec2(B.data[48u], B.data[49u]), fma(_648, vec2(B.data[40u], B.data[41u]), fma(_639, vec2(B.data[32u], B.data[33u]), fma(_630, vec2(B.data[24u], B.data[25u]), fma(_621, vec2(B.data[16u], B.data[17u]), fma(_612, vec2(B.data[8u], B.data[9u]), fma(_603, vec2(B.data[0u], B.data[1u]), vec2(C.data[8u], C.data[9u]))))))))), fma(_666, vec2(B.data[58u], B.data[59u]), fma(_657, vec2(B.data[50u], B.data[51u]), fma(_648, vec2(B.data[42u], B.data[43u]), fma(_639, vec2(B.data[34u], B.data[35u]), fma(_630, vec2(B.data[26u], B.data[27u]), fma(_621, vec2(B.data[18u], B.data[19u]), fma(_612, vec2(B.data[10u], B.data[11u]), fma(_603, vec2(B.data[2u], B.data[3u]), vec2(C.data[10u], C.data[11u]))))))))), fma(_666, vec2(B.data[60u], B.data[61u]), fma(_657, vec2(B.data[52u], B.data[53u]), fma(_648, vec2(B.data[44u], B.data[45u]), fma(_639, vec2(B.data[36u], B.data[37u]), fma(_630, vec2(B.data[28u], B.data[29u]), fma(_621, vec2(B.data[20u], B.data[21u]), fma(_612, vec2(B.data[12u], B.data[13u]), fma(_603, vec2(B.data[4u], B.data[5u]), vec2(C.data[12u], C.data[13u]))))))))), fma(_666, vec2(B.data[62u], B.data[63u]), fma(_657, vec2(B.data[54u], B.data[55u]), fma(_648, vec2(B.data[46u], B.data[47u]), fma(_639, vec2(B.data[38u], B.data[39u]), fma(_630, vec2(B.data[30u], B.data[31u]), fma(_621, vec2(B.data[22u], B.data[23u]), fma(_612, vec2(B.data[14u], B.data[15u]), fma(_603, vec2(B.data[6u], B.data[7u]), vec2(C.data[14u], C.data[15u]))))))))), fma(_742, vec2(B.data[56u], B.data[57u]), fma(_733, vec2(B.data[48u], B.data[49u]), fma(_724, vec2(B.data[40u], B.data[41u]), fma(_715, vec2(B.data[32u], B.data[33u]), fma(_706, vec2(B.data[24u], B.data[25u]), fma(_697, vec2(B.data[16u], B.data[17u]), fma(_688, vec2(B.data[8u], B.data[9u]), fma(_679, vec2(B.data[0u], B.data[1u]), vec2(C.data[16u], C.data[17u]))))))))), fma(_742, vec2(B.data[58u], B.data[59u]), fma(_733, vec2(B.data[50u], B.data[51u]), fma(_724, vec2(B.data[42u], B.data[43u]), fma(_715, vec2(B.data[34u], B.data[35u]), fma(_706, vec2(B.data[26u], B.data[27u]), fma(_697, vec2(B.data[18u], B.data[19u]), fma(_688, vec2(B.data[10u], B.data[11u]), fma(_679, vec2(B.data[2u], B.data[3u]), vec2(C.data[18u], C.data[19u]))))))))), fma(_742, vec2(B.data[60u], B.data[61u]), fma(_733, vec2(B.data[52u], B.data[53u]), fma(_724, vec2(B.data[44u], B.data[45u]), fma(_715, vec2(B.data[36u], B.data[37u]), fma(_706, vec2(B.data[28u], B.data[29u]), fma(_697, vec2(B.data[20u], B.data[21u]), fma(_688, vec2(B.data[12u], B.data[13u]), fma(_679, vec2(B.data[4u], B.data[5u]), vec2(C.data[20u], C.data[21u]))))))))), fma(_742, vec2(B.data[62u], B.data[63u]), fma(_733, vec2(B.data[54u], B.data[55u]), fma(_724, vec2(B.data[46u], B.data[47u]), fma(_715, vec2(B.data[38u], B.data[39u]), fma(_706, vec2(B.data[30u], B.data[31u]), fma(_697, vec2(B.data[22u], B.data[23u]), fma(_688, vec2(B.data[14u], B.data[15u]), fma(_679, vec2(B.data[6u], B.data[7u]), vec2(C.data[22u], C.data[23u]))))))))), fma(_818, vec2(B.data[56u], B.data[57u]), fma(_809, vec2(B.data[48u], B.data[49u]), fma(_800, vec2(B.data[40u], B.data[41u]), fma(_791, vec2(B.data[32u], B.data[33u]), fma(_782, vec2(B.data[24u], B.data[25u]), fma(_773, vec2(B.data[16u], B.data[17u]), fma(_764, vec2(B.data[8u], B.data[9u]), fma(_755, vec2(B.data[0u], B.data[1u]), vec2(C.data[24u], C.data[25u]))))))))), fma(_818, vec2(B.data[58u], B.data[59u]), fma(_809, vec2(B.data[50u], B.data[51u]), fma(_800, vec2(B.data[42u], B.data[43u]), fma(_791, vec2(B.data[34u], B.data[35u]), fma(_782, vec2(B.data[26u], B.data[27u]), fma(_773, vec2(B.data[18u], B.data[19u]), fma(_764, vec2(B.data[10u], B.data[11u]), fma(_755, vec2(B.data[2u], B.data[3u]), vec2(C.data[26u], C.data[27u]))))))))), fma(_818, vec2(B.data[60u], B.data[61u]), fma(_809, vec2(B.data[52u], B.data[53u]), fma(_800, vec2(B.data[44u], B.data[45u]), fma(_791, vec2(B.data[36u], B.data[37u]), fma(_782, vec2(B.data[28u], B.data[29u]), fma(_773, vec2(B.data[20u], B.data[21u]), fma(_764, vec2(B.data[12u], B.data[13u]), fma(_755, vec2(B.data[4u], B.data[5u]), vec2(C.data[28u], C.data[29u]))))))))), fma(_818, vec2(B.data[62u], B.data[63u]), fma(_809, vec2(B.data[54u], B.data[55u]), fma(_800, vec2(B.data[46u], B.data[47u]), fma(_791, vec2(B.data[38u], B.data[39u]), fma(_782, vec2(B.data[30u], B.data[31u]), fma(_773, vec2(B.data[22u], B.data[23u]), fma(_764, vec2(B.data[14u], B.data[15u]), fma(_755, vec2(B.data[6u], B.data[7u]), vec2(C.data[30u], C.data[31u]))))))))), fma(_894, vec2(B.data[56u], B.data[57u]), fma(_885, vec2(B.data[48u], B.data[49u]), fma(_876, vec2(B.data[40u], B.data[41u]), fma(_867, vec2(B.data[32u], B.data[33u]), fma(_858, vec2(B.data[24u], B.data[25u]), fma(_849, vec2(B.data[16u], B.data[17u]), fma(_840, vec2(B.data[8u], B.data[9u]), fma(_831, vec2(B.data[0u], B.data[1u]), vec2(C.data[32u], C.data[33u]))))))))), fma(_894, vec2(B.data[58u], B.data[59u]), fma(_885, vec2(B.data[50u], B.data[51u]), fma(_876, vec2(B.data[42u], B.data[43u]), fma(_867, vec2(B.data[34u], B.data[35u]), fma(_858, vec2(B.data[26u], B.data[27u]), fma(_849, vec2(B.data[18u], B.data[19u]), fma(_840, vec2(B.data[10u], B.data[11u]), fma(_831, vec2(B.data[2u], B.data[3u]), vec2(C.data[34u], C.data[35u]))))))))), fma(_894, vec2(B.data[60u], B.data[61u]), fma(_885, vec2(B.data[52u], B.data[53u]), fma(_876, vec2(B.data[44u], B.data[45u]), fma(_867, vec2(B.data[36u], B.data[37u]), fma(_858, vec2(B.data[28u], B.data[29u]), fma(_849, vec2(B.data[20u], B.data[21u]), fma(_840, vec2(B.data[12u], B.data[13u]), fma(_831, vec2(B.data[4u], B.data[5u]), vec2(C.data[36u], C.data[37u]))))))))), fma(_894, vec2(B.data[62u], B.data[63u]), fma(_885, vec2(B.data[54u], B.data[55u]), fma(_876, vec2(B.data[46u], B.data[47u]), fma(_867, vec2(B.data[38u], B.data[39u]), fma(_858, vec2(B.data[30u], B.data[31u]), fma(_849, vec2(B.data[22u], B.data[23u]), fma(_840, vec2(B.data[14u], B.data[15u]), fma(_831, vec2(B.data[6u], B.data[7u]), vec2(C.data[38u], C.data[39u]))))))))), fma(_970, vec2(B.data[56u], B.data[57u]), fma(_961, vec2(B.data[48u], B.data[49u]), fma(_952, vec2(B.data[40u], B.data[41u]), fma(_943, vec2(B.data[32u], B.data[33u]), fma(_934, vec2(B.data[24u], B.data[25u]), fma(_925, vec2(B.data[16u], B.data[17u]), fma(_916, vec2(B.data[8u], B.data[9u]), fma(_907, vec2(B.data[0u], B.data[1u]), vec2(C.data[40u], C.data[41u]))))))))), fma(_970, vec2(B.data[58u], B.data[59u]), fma(_961, vec2(B.data[50u], B.data[51u]), fma(_952, vec2(B.data[42u], B.data[43u]), fma(_943, vec2(B.data[34u], B.data[35u]), fma(_934, vec2(B.data[26u], B.data[27u]), fma(_925, vec2(B.data[18u], B.data[19u]), fma(_916, vec2(B.data[10u], B.data[11u]), fma(_907, vec2(B.data[2u], B.data[3u]), vec2(C.data[42u], C.data[43u]))))))))), fma(_970, vec2(B.data[60u], B.data[61u]), fma(_961, vec2(B.data[52u], B.data[53u]), fma(_952, vec2(B.data[44u], B.data[45u]), fma(_943, vec2(B.data[36u], B.data[37u]), fma(_934, vec2(B.data[28u], B.data[29u]), fma(_925, vec2(B.data[20u], B.data[21u]), fma(_916, vec2(B.data[12u], B.data[13u]), fma(_907, vec2(B.data[4u], B.data[5u]), vec2(C.data[44u], C.data[45u]))))))))), fma(_970, vec2(B.data[62u], B.data[63u]), fma(_961, vec2(B.data[54u], B.data[55u]), fma(_952, vec2(B.data[46u], B.data[47u]), fma(_943, vec2(B.data[38u], B.data[39u]), fma(_934, vec2(B.data[30u], B.data[31u]), fma(_925, vec2(B.data[22u], B.data[23u]), fma(_916, vec2(B.data[14u], B.data[15u]), fma(_907, vec2(B.data[6u], B.data[7u]), vec2(C.data[46u], C.data[47u]))))))))), fma(_1046, vec2(B.data[56u], B.data[57u]), fma(_1037, vec2(B.data[48u], B.data[49u]), fma(_1028, vec2(B.data[40u], B.data[41u]), fma(_1019, vec2(B.data[32u], B.data[33u]), fma(_1010, vec2(B.data[24u], B.data[25u]), fma(_1001, vec2(B.data[16u], B.data[17u]), fma(_992, vec2(B.data[8u], B.data[9u]), fma(_983, vec2(B.data[0u], B.data[1u]), vec2(C.data[48u], C.data[49u]))))))))), fma(_1046, vec2(B.data[58u], B.data[59u]), fma(_1037, vec2(B.data[50u], B.data[51u]), fma(_1028, vec2(B.data[42u], B.data[43u]), fma(_1019, vec2(B.data[34u], B.data[35u]), fma(_1010, vec2(B.data[26u], B.data[27u]), fma(_1001, vec2(B.data[18u], B.data[19u]), fma(_992, vec2(B.data[10u], B.data[11u]), fma(_983, vec2(B.data[2u], B.data[3u]), vec2(C.data[50u], C.data[51u]))))))))), fma(_1046, vec2(B.data[60u], B.data[61u]), fma(_1037, vec2(B.data[52u], B.data[53u]), fma(_1028, vec2(B.data[44u], B.data[45u]), fma(_1019, vec2(B.data[36u], B.data[37u]), fma(_1010, vec2(B.data[28u], B.data[29u]), fma(_1001, vec2(B.data[20u], B.data[21u]), fma(_992, vec2(B.data[12u], B.data[13u]), fma(_983, vec2(B.data[4u], B.data[5u]), vec2(C.data[52u], C.data[53u]))))))))), fma(_1046, vec2(B.data[62u], B.data[63u]), fma(_1037, vec2(B.data[54u], B.data[55u]), fma(_1028, vec2(B.data[46u], B.data[47u]), fma(_1019, vec2(B.data[38u], B.data[39u]), fma(_1010, vec2(B.data[30u], B.data[31u]), fma(_1001, vec2(B.data[22u], B.data[23u]), fma(_992, vec2(B.data[14u], B.data[15u]), fma(_983, vec2(B.data[6u], B.data[7u]), vec2(C.data[54u], C.data[55u]))))))))), fma(_1122, vec2(B.data[56u], B.data[57u]), fma(_1113, vec2(B.data[48u], B.data[49u]), fma(_1104, vec2(B.data[40u], B.data[41u]), fma(_1095, vec2(B.data[32u], B.data[33u]), fma(_1086, vec2(B.data[24u], B.data[25u]), fma(_1077, vec2(B.data[16u], B.data[17u]), fma(_1068, vec2(B.data[8u], B.data[9u]), fma(_1059, vec2(B.data[0u], B.data[1u]), vec2(C.data[56u], C.data[57u]))))))))), fma(_1122, vec2(B.data[58u], B.data[59u]), fma(_1113, vec2(B.data[50u], B.data[51u]), fma(_1104, vec2(B.data[42u], B.data[43u]), fma(_1095, vec2(B.data[34u], B.data[35u]), fma(_1086, vec2(B.data[26u], B.data[27u]), fma(_1077, vec2(B.data[18u], B.data[19u]), fma(_1068, vec2(B.data[10u], B.data[11u]), fma(_1059, vec2(B.data[2u], B.data[3u]), vec2(C.data[58u], C.data[59u]))))))))), fma(_1122, vec2(B.data[60u], B.data[61u]), fma(_1113, vec2(B.data[52u], B.data[53u]), fma(_1104, vec2(B.data[44u], B.data[45u]), fma(_1095, vec2(B.data[36u], B.data[37u]), fma(_1086, vec2(B.data[28u], B.data[29u]), fma(_1077, vec2(B.data[20u], B.data[21u]), fma(_1068, vec2(B.data[12u], B.data[13u]), fma(_1059, vec2(B.data[4u], B.data[5u]), vec2(C.data[60u], C.data[61u]))))))))), fma(_1122, vec2(B.data[62u], B.data[63u]), fma(_1113, vec2(B.data[54u], B.data[55u]), fma(_1104, vec2(B.data[46u], B.data[47u]), fma(_1095, vec2(B.data[38u], B.data[39u]), fma(_1086, vec2(B.data[30u], B.data[31u]), fma(_1077, vec2(B.data[22u], B.data[23u]), fma(_1068, vec2(B.data[14u], B.data[15u]), fma(_1059, vec2(B.data[6u], B.data[7u]), vec2(C.data[62u], C.data[63u]))))))))));
}

void _1133(uint _1134, vec2 _1135)
{
    D.data[_1134] = _1135.x;
    D.data[_1134 + 1u] = _1135.y;
}

void main()
{
    vec2 _55[32] = _72();
    vec2 tempArg[32] = _55;
    vec2 d[32] = _55;
    vec2 _1148[32] = _55;
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

