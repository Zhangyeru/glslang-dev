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

layout(set = 0, binding = 1, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer ScaleBuf
{
    float16_t data[];
} S;

layout(set = 0, binding = 2, std430) buffer OutputD
{
    float16_t data[];
} D;

f16vec2[32] _81(f16vec2 _82[32])
{
    f16vec2 _535 = f16vec2(A.data[0u]);
    f16vec2 _544 = f16vec2(A.data[1u]);
    f16vec2 _553 = f16vec2(A.data[2u]);
    f16vec2 _562 = f16vec2(A.data[3u]);
    f16vec2 _571 = f16vec2(A.data[4u]);
    f16vec2 _580 = f16vec2(A.data[5u]);
    f16vec2 _589 = f16vec2(A.data[6u]);
    f16vec2 _598 = f16vec2(A.data[7u]);
    f16vec2 _611 = f16vec2(A.data[8u]);
    f16vec2 _620 = f16vec2(A.data[9u]);
    f16vec2 _629 = f16vec2(A.data[10u]);
    f16vec2 _638 = f16vec2(A.data[11u]);
    f16vec2 _647 = f16vec2(A.data[12u]);
    f16vec2 _656 = f16vec2(A.data[13u]);
    f16vec2 _665 = f16vec2(A.data[14u]);
    f16vec2 _674 = f16vec2(A.data[15u]);
    f16vec2 _687 = f16vec2(A.data[16u]);
    f16vec2 _696 = f16vec2(A.data[17u]);
    f16vec2 _705 = f16vec2(A.data[18u]);
    f16vec2 _714 = f16vec2(A.data[19u]);
    f16vec2 _723 = f16vec2(A.data[20u]);
    f16vec2 _732 = f16vec2(A.data[21u]);
    f16vec2 _741 = f16vec2(A.data[22u]);
    f16vec2 _750 = f16vec2(A.data[23u]);
    f16vec2 _763 = f16vec2(A.data[24u]);
    f16vec2 _772 = f16vec2(A.data[25u]);
    f16vec2 _781 = f16vec2(A.data[26u]);
    f16vec2 _790 = f16vec2(A.data[27u]);
    f16vec2 _799 = f16vec2(A.data[28u]);
    f16vec2 _808 = f16vec2(A.data[29u]);
    f16vec2 _817 = f16vec2(A.data[30u]);
    f16vec2 _826 = f16vec2(A.data[31u]);
    f16vec2 _839 = f16vec2(A.data[32u]);
    f16vec2 _848 = f16vec2(A.data[33u]);
    f16vec2 _857 = f16vec2(A.data[34u]);
    f16vec2 _866 = f16vec2(A.data[35u]);
    f16vec2 _875 = f16vec2(A.data[36u]);
    f16vec2 _884 = f16vec2(A.data[37u]);
    f16vec2 _893 = f16vec2(A.data[38u]);
    f16vec2 _902 = f16vec2(A.data[39u]);
    f16vec2 _915 = f16vec2(A.data[40u]);
    f16vec2 _924 = f16vec2(A.data[41u]);
    f16vec2 _933 = f16vec2(A.data[42u]);
    f16vec2 _942 = f16vec2(A.data[43u]);
    f16vec2 _951 = f16vec2(A.data[44u]);
    f16vec2 _960 = f16vec2(A.data[45u]);
    f16vec2 _969 = f16vec2(A.data[46u]);
    f16vec2 _978 = f16vec2(A.data[47u]);
    f16vec2 _991 = f16vec2(A.data[48u]);
    f16vec2 _1000 = f16vec2(A.data[49u]);
    f16vec2 _1009 = f16vec2(A.data[50u]);
    f16vec2 _1018 = f16vec2(A.data[51u]);
    f16vec2 _1027 = f16vec2(A.data[52u]);
    f16vec2 _1036 = f16vec2(A.data[53u]);
    f16vec2 _1045 = f16vec2(A.data[54u]);
    f16vec2 _1054 = f16vec2(A.data[55u]);
    f16vec2 _1067 = f16vec2(A.data[56u]);
    f16vec2 _1076 = f16vec2(A.data[57u]);
    f16vec2 _1085 = f16vec2(A.data[58u]);
    f16vec2 _1094 = f16vec2(A.data[59u]);
    f16vec2 _1103 = f16vec2(A.data[60u]);
    f16vec2 _1112 = f16vec2(A.data[61u]);
    f16vec2 _1121 = f16vec2(A.data[62u]);
    f16vec2 _1130 = f16vec2(A.data[63u]);
    return f16vec2[](fma(_598, f16vec2(_82[28].x, _82[28].y), fma(_589, f16vec2(_82[24].x, _82[24].y), fma(_580, f16vec2(_82[20].x, _82[20].y), fma(_571, f16vec2(_82[16].x, _82[16].y), fma(_562, f16vec2(_82[12].x, _82[12].y), fma(_553, f16vec2(_82[8].x, _82[8].y), fma(_544, f16vec2(_82[4].x, _82[4].y), fma(_535, f16vec2(_82[0].x, _82[0].y), f16vec2(C.data[0u], C.data[1u]))))))))), fma(_598, f16vec2(_82[29].x, _82[29].y), fma(_589, f16vec2(_82[25].x, _82[25].y), fma(_580, f16vec2(_82[21].x, _82[21].y), fma(_571, f16vec2(_82[17].x, _82[17].y), fma(_562, f16vec2(_82[13].x, _82[13].y), fma(_553, f16vec2(_82[9].x, _82[9].y), fma(_544, f16vec2(_82[5].x, _82[5].y), fma(_535, f16vec2(_82[1].x, _82[1].y), f16vec2(C.data[2u], C.data[3u]))))))))), fma(_598, f16vec2(_82[30].x, _82[30].y), fma(_589, f16vec2(_82[26].x, _82[26].y), fma(_580, f16vec2(_82[22].x, _82[22].y), fma(_571, f16vec2(_82[18].x, _82[18].y), fma(_562, f16vec2(_82[14].x, _82[14].y), fma(_553, f16vec2(_82[10].x, _82[10].y), fma(_544, f16vec2(_82[6].x, _82[6].y), fma(_535, f16vec2(_82[2].x, _82[2].y), f16vec2(C.data[4u], C.data[5u]))))))))), fma(_598, f16vec2(_82[31].x, _82[31].y), fma(_589, f16vec2(_82[27].x, _82[27].y), fma(_580, f16vec2(_82[23].x, _82[23].y), fma(_571, f16vec2(_82[19].x, _82[19].y), fma(_562, f16vec2(_82[15].x, _82[15].y), fma(_553, f16vec2(_82[11].x, _82[11].y), fma(_544, f16vec2(_82[7].x, _82[7].y), fma(_535, f16vec2(_82[3].x, _82[3].y), f16vec2(C.data[6u], C.data[7u]))))))))), fma(_674, f16vec2(_82[28].x, _82[28].y), fma(_665, f16vec2(_82[24].x, _82[24].y), fma(_656, f16vec2(_82[20].x, _82[20].y), fma(_647, f16vec2(_82[16].x, _82[16].y), fma(_638, f16vec2(_82[12].x, _82[12].y), fma(_629, f16vec2(_82[8].x, _82[8].y), fma(_620, f16vec2(_82[4].x, _82[4].y), fma(_611, f16vec2(_82[0].x, _82[0].y), f16vec2(C.data[8u], C.data[9u]))))))))), fma(_674, f16vec2(_82[29].x, _82[29].y), fma(_665, f16vec2(_82[25].x, _82[25].y), fma(_656, f16vec2(_82[21].x, _82[21].y), fma(_647, f16vec2(_82[17].x, _82[17].y), fma(_638, f16vec2(_82[13].x, _82[13].y), fma(_629, f16vec2(_82[9].x, _82[9].y), fma(_620, f16vec2(_82[5].x, _82[5].y), fma(_611, f16vec2(_82[1].x, _82[1].y), f16vec2(C.data[10u], C.data[11u]))))))))), fma(_674, f16vec2(_82[30].x, _82[30].y), fma(_665, f16vec2(_82[26].x, _82[26].y), fma(_656, f16vec2(_82[22].x, _82[22].y), fma(_647, f16vec2(_82[18].x, _82[18].y), fma(_638, f16vec2(_82[14].x, _82[14].y), fma(_629, f16vec2(_82[10].x, _82[10].y), fma(_620, f16vec2(_82[6].x, _82[6].y), fma(_611, f16vec2(_82[2].x, _82[2].y), f16vec2(C.data[12u], C.data[13u]))))))))), fma(_674, f16vec2(_82[31].x, _82[31].y), fma(_665, f16vec2(_82[27].x, _82[27].y), fma(_656, f16vec2(_82[23].x, _82[23].y), fma(_647, f16vec2(_82[19].x, _82[19].y), fma(_638, f16vec2(_82[15].x, _82[15].y), fma(_629, f16vec2(_82[11].x, _82[11].y), fma(_620, f16vec2(_82[7].x, _82[7].y), fma(_611, f16vec2(_82[3].x, _82[3].y), f16vec2(C.data[14u], C.data[15u]))))))))), fma(_750, f16vec2(_82[28].x, _82[28].y), fma(_741, f16vec2(_82[24].x, _82[24].y), fma(_732, f16vec2(_82[20].x, _82[20].y), fma(_723, f16vec2(_82[16].x, _82[16].y), fma(_714, f16vec2(_82[12].x, _82[12].y), fma(_705, f16vec2(_82[8].x, _82[8].y), fma(_696, f16vec2(_82[4].x, _82[4].y), fma(_687, f16vec2(_82[0].x, _82[0].y), f16vec2(C.data[16u], C.data[17u]))))))))), fma(_750, f16vec2(_82[29].x, _82[29].y), fma(_741, f16vec2(_82[25].x, _82[25].y), fma(_732, f16vec2(_82[21].x, _82[21].y), fma(_723, f16vec2(_82[17].x, _82[17].y), fma(_714, f16vec2(_82[13].x, _82[13].y), fma(_705, f16vec2(_82[9].x, _82[9].y), fma(_696, f16vec2(_82[5].x, _82[5].y), fma(_687, f16vec2(_82[1].x, _82[1].y), f16vec2(C.data[18u], C.data[19u]))))))))), fma(_750, f16vec2(_82[30].x, _82[30].y), fma(_741, f16vec2(_82[26].x, _82[26].y), fma(_732, f16vec2(_82[22].x, _82[22].y), fma(_723, f16vec2(_82[18].x, _82[18].y), fma(_714, f16vec2(_82[14].x, _82[14].y), fma(_705, f16vec2(_82[10].x, _82[10].y), fma(_696, f16vec2(_82[6].x, _82[6].y), fma(_687, f16vec2(_82[2].x, _82[2].y), f16vec2(C.data[20u], C.data[21u]))))))))), fma(_750, f16vec2(_82[31].x, _82[31].y), fma(_741, f16vec2(_82[27].x, _82[27].y), fma(_732, f16vec2(_82[23].x, _82[23].y), fma(_723, f16vec2(_82[19].x, _82[19].y), fma(_714, f16vec2(_82[15].x, _82[15].y), fma(_705, f16vec2(_82[11].x, _82[11].y), fma(_696, f16vec2(_82[7].x, _82[7].y), fma(_687, f16vec2(_82[3].x, _82[3].y), f16vec2(C.data[22u], C.data[23u]))))))))), fma(_826, f16vec2(_82[28].x, _82[28].y), fma(_817, f16vec2(_82[24].x, _82[24].y), fma(_808, f16vec2(_82[20].x, _82[20].y), fma(_799, f16vec2(_82[16].x, _82[16].y), fma(_790, f16vec2(_82[12].x, _82[12].y), fma(_781, f16vec2(_82[8].x, _82[8].y), fma(_772, f16vec2(_82[4].x, _82[4].y), fma(_763, f16vec2(_82[0].x, _82[0].y), f16vec2(C.data[24u], C.data[25u]))))))))), fma(_826, f16vec2(_82[29].x, _82[29].y), fma(_817, f16vec2(_82[25].x, _82[25].y), fma(_808, f16vec2(_82[21].x, _82[21].y), fma(_799, f16vec2(_82[17].x, _82[17].y), fma(_790, f16vec2(_82[13].x, _82[13].y), fma(_781, f16vec2(_82[9].x, _82[9].y), fma(_772, f16vec2(_82[5].x, _82[5].y), fma(_763, f16vec2(_82[1].x, _82[1].y), f16vec2(C.data[26u], C.data[27u]))))))))), fma(_826, f16vec2(_82[30].x, _82[30].y), fma(_817, f16vec2(_82[26].x, _82[26].y), fma(_808, f16vec2(_82[22].x, _82[22].y), fma(_799, f16vec2(_82[18].x, _82[18].y), fma(_790, f16vec2(_82[14].x, _82[14].y), fma(_781, f16vec2(_82[10].x, _82[10].y), fma(_772, f16vec2(_82[6].x, _82[6].y), fma(_763, f16vec2(_82[2].x, _82[2].y), f16vec2(C.data[28u], C.data[29u]))))))))), fma(_826, f16vec2(_82[31].x, _82[31].y), fma(_817, f16vec2(_82[27].x, _82[27].y), fma(_808, f16vec2(_82[23].x, _82[23].y), fma(_799, f16vec2(_82[19].x, _82[19].y), fma(_790, f16vec2(_82[15].x, _82[15].y), fma(_781, f16vec2(_82[11].x, _82[11].y), fma(_772, f16vec2(_82[7].x, _82[7].y), fma(_763, f16vec2(_82[3].x, _82[3].y), f16vec2(C.data[30u], C.data[31u]))))))))), fma(_902, f16vec2(_82[28].x, _82[28].y), fma(_893, f16vec2(_82[24].x, _82[24].y), fma(_884, f16vec2(_82[20].x, _82[20].y), fma(_875, f16vec2(_82[16].x, _82[16].y), fma(_866, f16vec2(_82[12].x, _82[12].y), fma(_857, f16vec2(_82[8].x, _82[8].y), fma(_848, f16vec2(_82[4].x, _82[4].y), fma(_839, f16vec2(_82[0].x, _82[0].y), f16vec2(C.data[32u], C.data[33u]))))))))), fma(_902, f16vec2(_82[29].x, _82[29].y), fma(_893, f16vec2(_82[25].x, _82[25].y), fma(_884, f16vec2(_82[21].x, _82[21].y), fma(_875, f16vec2(_82[17].x, _82[17].y), fma(_866, f16vec2(_82[13].x, _82[13].y), fma(_857, f16vec2(_82[9].x, _82[9].y), fma(_848, f16vec2(_82[5].x, _82[5].y), fma(_839, f16vec2(_82[1].x, _82[1].y), f16vec2(C.data[34u], C.data[35u]))))))))), fma(_902, f16vec2(_82[30].x, _82[30].y), fma(_893, f16vec2(_82[26].x, _82[26].y), fma(_884, f16vec2(_82[22].x, _82[22].y), fma(_875, f16vec2(_82[18].x, _82[18].y), fma(_866, f16vec2(_82[14].x, _82[14].y), fma(_857, f16vec2(_82[10].x, _82[10].y), fma(_848, f16vec2(_82[6].x, _82[6].y), fma(_839, f16vec2(_82[2].x, _82[2].y), f16vec2(C.data[36u], C.data[37u]))))))))), fma(_902, f16vec2(_82[31].x, _82[31].y), fma(_893, f16vec2(_82[27].x, _82[27].y), fma(_884, f16vec2(_82[23].x, _82[23].y), fma(_875, f16vec2(_82[19].x, _82[19].y), fma(_866, f16vec2(_82[15].x, _82[15].y), fma(_857, f16vec2(_82[11].x, _82[11].y), fma(_848, f16vec2(_82[7].x, _82[7].y), fma(_839, f16vec2(_82[3].x, _82[3].y), f16vec2(C.data[38u], C.data[39u]))))))))), fma(_978, f16vec2(_82[28].x, _82[28].y), fma(_969, f16vec2(_82[24].x, _82[24].y), fma(_960, f16vec2(_82[20].x, _82[20].y), fma(_951, f16vec2(_82[16].x, _82[16].y), fma(_942, f16vec2(_82[12].x, _82[12].y), fma(_933, f16vec2(_82[8].x, _82[8].y), fma(_924, f16vec2(_82[4].x, _82[4].y), fma(_915, f16vec2(_82[0].x, _82[0].y), f16vec2(C.data[40u], C.data[41u]))))))))), fma(_978, f16vec2(_82[29].x, _82[29].y), fma(_969, f16vec2(_82[25].x, _82[25].y), fma(_960, f16vec2(_82[21].x, _82[21].y), fma(_951, f16vec2(_82[17].x, _82[17].y), fma(_942, f16vec2(_82[13].x, _82[13].y), fma(_933, f16vec2(_82[9].x, _82[9].y), fma(_924, f16vec2(_82[5].x, _82[5].y), fma(_915, f16vec2(_82[1].x, _82[1].y), f16vec2(C.data[42u], C.data[43u]))))))))), fma(_978, f16vec2(_82[30].x, _82[30].y), fma(_969, f16vec2(_82[26].x, _82[26].y), fma(_960, f16vec2(_82[22].x, _82[22].y), fma(_951, f16vec2(_82[18].x, _82[18].y), fma(_942, f16vec2(_82[14].x, _82[14].y), fma(_933, f16vec2(_82[10].x, _82[10].y), fma(_924, f16vec2(_82[6].x, _82[6].y), fma(_915, f16vec2(_82[2].x, _82[2].y), f16vec2(C.data[44u], C.data[45u]))))))))), fma(_978, f16vec2(_82[31].x, _82[31].y), fma(_969, f16vec2(_82[27].x, _82[27].y), fma(_960, f16vec2(_82[23].x, _82[23].y), fma(_951, f16vec2(_82[19].x, _82[19].y), fma(_942, f16vec2(_82[15].x, _82[15].y), fma(_933, f16vec2(_82[11].x, _82[11].y), fma(_924, f16vec2(_82[7].x, _82[7].y), fma(_915, f16vec2(_82[3].x, _82[3].y), f16vec2(C.data[46u], C.data[47u]))))))))), fma(_1054, f16vec2(_82[28].x, _82[28].y), fma(_1045, f16vec2(_82[24].x, _82[24].y), fma(_1036, f16vec2(_82[20].x, _82[20].y), fma(_1027, f16vec2(_82[16].x, _82[16].y), fma(_1018, f16vec2(_82[12].x, _82[12].y), fma(_1009, f16vec2(_82[8].x, _82[8].y), fma(_1000, f16vec2(_82[4].x, _82[4].y), fma(_991, f16vec2(_82[0].x, _82[0].y), f16vec2(C.data[48u], C.data[49u]))))))))), fma(_1054, f16vec2(_82[29].x, _82[29].y), fma(_1045, f16vec2(_82[25].x, _82[25].y), fma(_1036, f16vec2(_82[21].x, _82[21].y), fma(_1027, f16vec2(_82[17].x, _82[17].y), fma(_1018, f16vec2(_82[13].x, _82[13].y), fma(_1009, f16vec2(_82[9].x, _82[9].y), fma(_1000, f16vec2(_82[5].x, _82[5].y), fma(_991, f16vec2(_82[1].x, _82[1].y), f16vec2(C.data[50u], C.data[51u]))))))))), fma(_1054, f16vec2(_82[30].x, _82[30].y), fma(_1045, f16vec2(_82[26].x, _82[26].y), fma(_1036, f16vec2(_82[22].x, _82[22].y), fma(_1027, f16vec2(_82[18].x, _82[18].y), fma(_1018, f16vec2(_82[14].x, _82[14].y), fma(_1009, f16vec2(_82[10].x, _82[10].y), fma(_1000, f16vec2(_82[6].x, _82[6].y), fma(_991, f16vec2(_82[2].x, _82[2].y), f16vec2(C.data[52u], C.data[53u]))))))))), fma(_1054, f16vec2(_82[31].x, _82[31].y), fma(_1045, f16vec2(_82[27].x, _82[27].y), fma(_1036, f16vec2(_82[23].x, _82[23].y), fma(_1027, f16vec2(_82[19].x, _82[19].y), fma(_1018, f16vec2(_82[15].x, _82[15].y), fma(_1009, f16vec2(_82[11].x, _82[11].y), fma(_1000, f16vec2(_82[7].x, _82[7].y), fma(_991, f16vec2(_82[3].x, _82[3].y), f16vec2(C.data[54u], C.data[55u]))))))))), fma(_1130, f16vec2(_82[28].x, _82[28].y), fma(_1121, f16vec2(_82[24].x, _82[24].y), fma(_1112, f16vec2(_82[20].x, _82[20].y), fma(_1103, f16vec2(_82[16].x, _82[16].y), fma(_1094, f16vec2(_82[12].x, _82[12].y), fma(_1085, f16vec2(_82[8].x, _82[8].y), fma(_1076, f16vec2(_82[4].x, _82[4].y), fma(_1067, f16vec2(_82[0].x, _82[0].y), f16vec2(C.data[56u], C.data[57u]))))))))), fma(_1130, f16vec2(_82[29].x, _82[29].y), fma(_1121, f16vec2(_82[25].x, _82[25].y), fma(_1112, f16vec2(_82[21].x, _82[21].y), fma(_1103, f16vec2(_82[17].x, _82[17].y), fma(_1094, f16vec2(_82[13].x, _82[13].y), fma(_1085, f16vec2(_82[9].x, _82[9].y), fma(_1076, f16vec2(_82[5].x, _82[5].y), fma(_1067, f16vec2(_82[1].x, _82[1].y), f16vec2(C.data[58u], C.data[59u]))))))))), fma(_1130, f16vec2(_82[30].x, _82[30].y), fma(_1121, f16vec2(_82[26].x, _82[26].y), fma(_1112, f16vec2(_82[22].x, _82[22].y), fma(_1103, f16vec2(_82[18].x, _82[18].y), fma(_1094, f16vec2(_82[14].x, _82[14].y), fma(_1085, f16vec2(_82[10].x, _82[10].y), fma(_1076, f16vec2(_82[6].x, _82[6].y), fma(_1067, f16vec2(_82[2].x, _82[2].y), f16vec2(C.data[60u], C.data[61u]))))))))), fma(_1130, f16vec2(_82[31].x, _82[31].y), fma(_1121, f16vec2(_82[27].x, _82[27].y), fma(_1112, f16vec2(_82[23].x, _82[23].y), fma(_1103, f16vec2(_82[19].x, _82[19].y), fma(_1094, f16vec2(_82[15].x, _82[15].y), fma(_1085, f16vec2(_82[11].x, _82[11].y), fma(_1076, f16vec2(_82[7].x, _82[7].y), fma(_1067, f16vec2(_82[3].x, _82[3].y), f16vec2(C.data[62u], C.data[63u]))))))))));
}

void _1176(uint _1177, f16vec2 _1178)
{
    D.data[_1177] = _1178.x;
    D.data[_1177 + 1u] = _1178.y;
}

void main()
{
    uint _1140 = 0u + 0u;
    float16_t _50[1] = float16_t[](S.data[_1140]);
    float16_t tempArg[1] = _50;
    float16_t sv[1] = _50;
    f16vec2 _59[32] = f16vec2[](f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]));
    f16vec2 mb[32] = _59;
    f16vec2 _64[32] = _81(_59);
    f16vec2 tempArg_1[32] = _64;
    f16vec2 md[32] = _64;
    f16vec2 _1191[32] = _64;
    uint _1192 = 0u;
    uint _1197;
    for (;;)
    {
        _1197 = _1192;
        if (_1197 < 64u)
        {
            _1176(((uint(0) + (_1197 / 8u)) * uint(8)) + (uint(0) + (_1197 % 8u)), _1191[_1197 / 2u]);
            _1192 = _1197 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

