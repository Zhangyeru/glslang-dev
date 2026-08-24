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
    f16vec2 _544 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(_82[24].x, _82[28].x), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(_82[16].x, _82[20].x), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(_82[8].x, _82[12].x), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(_82[0].x, _82[4].x), f16vec2(float16_t(0.0))))));
    f16vec2 _560 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(_82[24].y, _82[28].y), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(_82[16].y, _82[20].y), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(_82[8].y, _82[12].y), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(_82[0].y, _82[4].y), f16vec2(float16_t(0.0))))));
    f16vec2 _576 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(_82[25].x, _82[29].x), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(_82[17].x, _82[21].x), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(_82[9].x, _82[13].x), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(_82[1].x, _82[5].x), f16vec2(float16_t(0.0))))));
    f16vec2 _592 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(_82[25].y, _82[29].y), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(_82[17].y, _82[21].y), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(_82[9].y, _82[13].y), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(_82[1].y, _82[5].y), f16vec2(float16_t(0.0))))));
    f16vec2 _608 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(_82[26].x, _82[30].x), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(_82[18].x, _82[22].x), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(_82[10].x, _82[14].x), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(_82[2].x, _82[6].x), f16vec2(float16_t(0.0))))));
    f16vec2 _624 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(_82[26].y, _82[30].y), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(_82[18].y, _82[22].y), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(_82[10].y, _82[14].y), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(_82[2].y, _82[6].y), f16vec2(float16_t(0.0))))));
    f16vec2 _640 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(_82[27].x, _82[31].x), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(_82[19].x, _82[23].x), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(_82[11].x, _82[15].x), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(_82[3].x, _82[7].x), f16vec2(float16_t(0.0))))));
    f16vec2 _656 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(_82[27].y, _82[31].y), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(_82[19].y, _82[23].y), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(_82[11].y, _82[15].y), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(_82[3].y, _82[7].y), f16vec2(float16_t(0.0))))));
    f16vec2 _672 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(_82[24].x, _82[28].x), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(_82[16].x, _82[20].x), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(_82[8].x, _82[12].x), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(_82[0].x, _82[4].x), f16vec2(float16_t(0.0))))));
    f16vec2 _688 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(_82[24].y, _82[28].y), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(_82[16].y, _82[20].y), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(_82[8].y, _82[12].y), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(_82[0].y, _82[4].y), f16vec2(float16_t(0.0))))));
    f16vec2 _704 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(_82[25].x, _82[29].x), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(_82[17].x, _82[21].x), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(_82[9].x, _82[13].x), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(_82[1].x, _82[5].x), f16vec2(float16_t(0.0))))));
    f16vec2 _720 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(_82[25].y, _82[29].y), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(_82[17].y, _82[21].y), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(_82[9].y, _82[13].y), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(_82[1].y, _82[5].y), f16vec2(float16_t(0.0))))));
    f16vec2 _736 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(_82[26].x, _82[30].x), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(_82[18].x, _82[22].x), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(_82[10].x, _82[14].x), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(_82[2].x, _82[6].x), f16vec2(float16_t(0.0))))));
    f16vec2 _752 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(_82[26].y, _82[30].y), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(_82[18].y, _82[22].y), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(_82[10].y, _82[14].y), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(_82[2].y, _82[6].y), f16vec2(float16_t(0.0))))));
    f16vec2 _768 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(_82[27].x, _82[31].x), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(_82[19].x, _82[23].x), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(_82[11].x, _82[15].x), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(_82[3].x, _82[7].x), f16vec2(float16_t(0.0))))));
    f16vec2 _784 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(_82[27].y, _82[31].y), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(_82[19].y, _82[23].y), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(_82[11].y, _82[15].y), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(_82[3].y, _82[7].y), f16vec2(float16_t(0.0))))));
    f16vec2 _800 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(_82[24].x, _82[28].x), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(_82[16].x, _82[20].x), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(_82[8].x, _82[12].x), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(_82[0].x, _82[4].x), f16vec2(float16_t(0.0))))));
    f16vec2 _816 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(_82[24].y, _82[28].y), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(_82[16].y, _82[20].y), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(_82[8].y, _82[12].y), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(_82[0].y, _82[4].y), f16vec2(float16_t(0.0))))));
    f16vec2 _832 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(_82[25].x, _82[29].x), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(_82[17].x, _82[21].x), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(_82[9].x, _82[13].x), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(_82[1].x, _82[5].x), f16vec2(float16_t(0.0))))));
    f16vec2 _848 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(_82[25].y, _82[29].y), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(_82[17].y, _82[21].y), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(_82[9].y, _82[13].y), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(_82[1].y, _82[5].y), f16vec2(float16_t(0.0))))));
    f16vec2 _864 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(_82[26].x, _82[30].x), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(_82[18].x, _82[22].x), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(_82[10].x, _82[14].x), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(_82[2].x, _82[6].x), f16vec2(float16_t(0.0))))));
    f16vec2 _880 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(_82[26].y, _82[30].y), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(_82[18].y, _82[22].y), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(_82[10].y, _82[14].y), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(_82[2].y, _82[6].y), f16vec2(float16_t(0.0))))));
    f16vec2 _896 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(_82[27].x, _82[31].x), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(_82[19].x, _82[23].x), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(_82[11].x, _82[15].x), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(_82[3].x, _82[7].x), f16vec2(float16_t(0.0))))));
    f16vec2 _912 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(_82[27].y, _82[31].y), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(_82[19].y, _82[23].y), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(_82[11].y, _82[15].y), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(_82[3].y, _82[7].y), f16vec2(float16_t(0.0))))));
    f16vec2 _928 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(_82[24].x, _82[28].x), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(_82[16].x, _82[20].x), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(_82[8].x, _82[12].x), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(_82[0].x, _82[4].x), f16vec2(float16_t(0.0))))));
    f16vec2 _944 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(_82[24].y, _82[28].y), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(_82[16].y, _82[20].y), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(_82[8].y, _82[12].y), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(_82[0].y, _82[4].y), f16vec2(float16_t(0.0))))));
    f16vec2 _960 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(_82[25].x, _82[29].x), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(_82[17].x, _82[21].x), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(_82[9].x, _82[13].x), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(_82[1].x, _82[5].x), f16vec2(float16_t(0.0))))));
    f16vec2 _976 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(_82[25].y, _82[29].y), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(_82[17].y, _82[21].y), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(_82[9].y, _82[13].y), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(_82[1].y, _82[5].y), f16vec2(float16_t(0.0))))));
    f16vec2 _992 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(_82[26].x, _82[30].x), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(_82[18].x, _82[22].x), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(_82[10].x, _82[14].x), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(_82[2].x, _82[6].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1008 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(_82[26].y, _82[30].y), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(_82[18].y, _82[22].y), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(_82[10].y, _82[14].y), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(_82[2].y, _82[6].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1024 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(_82[27].x, _82[31].x), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(_82[19].x, _82[23].x), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(_82[11].x, _82[15].x), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(_82[3].x, _82[7].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1040 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(_82[27].y, _82[31].y), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(_82[19].y, _82[23].y), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(_82[11].y, _82[15].y), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(_82[3].y, _82[7].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1056 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(_82[24].x, _82[28].x), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(_82[16].x, _82[20].x), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(_82[8].x, _82[12].x), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(_82[0].x, _82[4].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1072 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(_82[24].y, _82[28].y), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(_82[16].y, _82[20].y), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(_82[8].y, _82[12].y), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(_82[0].y, _82[4].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1088 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(_82[25].x, _82[29].x), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(_82[17].x, _82[21].x), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(_82[9].x, _82[13].x), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(_82[1].x, _82[5].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1104 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(_82[25].y, _82[29].y), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(_82[17].y, _82[21].y), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(_82[9].y, _82[13].y), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(_82[1].y, _82[5].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1120 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(_82[26].x, _82[30].x), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(_82[18].x, _82[22].x), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(_82[10].x, _82[14].x), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(_82[2].x, _82[6].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1136 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(_82[26].y, _82[30].y), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(_82[18].y, _82[22].y), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(_82[10].y, _82[14].y), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(_82[2].y, _82[6].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1152 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(_82[27].x, _82[31].x), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(_82[19].x, _82[23].x), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(_82[11].x, _82[15].x), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(_82[3].x, _82[7].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1168 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(_82[27].y, _82[31].y), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(_82[19].y, _82[23].y), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(_82[11].y, _82[15].y), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(_82[3].y, _82[7].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1184 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(_82[24].x, _82[28].x), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(_82[16].x, _82[20].x), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(_82[8].x, _82[12].x), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(_82[0].x, _82[4].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1200 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(_82[24].y, _82[28].y), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(_82[16].y, _82[20].y), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(_82[8].y, _82[12].y), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(_82[0].y, _82[4].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1216 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(_82[25].x, _82[29].x), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(_82[17].x, _82[21].x), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(_82[9].x, _82[13].x), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(_82[1].x, _82[5].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1232 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(_82[25].y, _82[29].y), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(_82[17].y, _82[21].y), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(_82[9].y, _82[13].y), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(_82[1].y, _82[5].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1248 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(_82[26].x, _82[30].x), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(_82[18].x, _82[22].x), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(_82[10].x, _82[14].x), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(_82[2].x, _82[6].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1264 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(_82[26].y, _82[30].y), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(_82[18].y, _82[22].y), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(_82[10].y, _82[14].y), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(_82[2].y, _82[6].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1280 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(_82[27].x, _82[31].x), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(_82[19].x, _82[23].x), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(_82[11].x, _82[15].x), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(_82[3].x, _82[7].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1296 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(_82[27].y, _82[31].y), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(_82[19].y, _82[23].y), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(_82[11].y, _82[15].y), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(_82[3].y, _82[7].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1312 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(_82[24].x, _82[28].x), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(_82[16].x, _82[20].x), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(_82[8].x, _82[12].x), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(_82[0].x, _82[4].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1328 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(_82[24].y, _82[28].y), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(_82[16].y, _82[20].y), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(_82[8].y, _82[12].y), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(_82[0].y, _82[4].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1344 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(_82[25].x, _82[29].x), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(_82[17].x, _82[21].x), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(_82[9].x, _82[13].x), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(_82[1].x, _82[5].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1360 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(_82[25].y, _82[29].y), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(_82[17].y, _82[21].y), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(_82[9].y, _82[13].y), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(_82[1].y, _82[5].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1376 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(_82[26].x, _82[30].x), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(_82[18].x, _82[22].x), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(_82[10].x, _82[14].x), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(_82[2].x, _82[6].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1392 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(_82[26].y, _82[30].y), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(_82[18].y, _82[22].y), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(_82[10].y, _82[14].y), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(_82[2].y, _82[6].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1408 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(_82[27].x, _82[31].x), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(_82[19].x, _82[23].x), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(_82[11].x, _82[15].x), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(_82[3].x, _82[7].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1424 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(_82[27].y, _82[31].y), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(_82[19].y, _82[23].y), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(_82[11].y, _82[15].y), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(_82[3].y, _82[7].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1440 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(_82[24].x, _82[28].x), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(_82[16].x, _82[20].x), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(_82[8].x, _82[12].x), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(_82[0].x, _82[4].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1456 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(_82[24].y, _82[28].y), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(_82[16].y, _82[20].y), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(_82[8].y, _82[12].y), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(_82[0].y, _82[4].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1472 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(_82[25].x, _82[29].x), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(_82[17].x, _82[21].x), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(_82[9].x, _82[13].x), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(_82[1].x, _82[5].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1488 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(_82[25].y, _82[29].y), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(_82[17].y, _82[21].y), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(_82[9].y, _82[13].y), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(_82[1].y, _82[5].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1504 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(_82[26].x, _82[30].x), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(_82[18].x, _82[22].x), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(_82[10].x, _82[14].x), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(_82[2].x, _82[6].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1520 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(_82[26].y, _82[30].y), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(_82[18].y, _82[22].y), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(_82[10].y, _82[14].y), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(_82[2].y, _82[6].y), f16vec2(float16_t(0.0))))));
    f16vec2 _1536 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(_82[27].x, _82[31].x), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(_82[19].x, _82[23].x), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(_82[11].x, _82[15].x), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(_82[3].x, _82[7].x), f16vec2(float16_t(0.0))))));
    f16vec2 _1552 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(_82[27].y, _82[31].y), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(_82[19].y, _82[23].y), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(_82[11].y, _82[15].y), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(_82[3].y, _82[7].y), f16vec2(float16_t(0.0))))));
    return f16vec2[](f16vec2((_544.x + _544.y) + C.data[0u], (_560.x + _560.y) + C.data[1u]), f16vec2((_576.x + _576.y) + C.data[2u], (_592.x + _592.y) + C.data[3u]), f16vec2((_608.x + _608.y) + C.data[4u], (_624.x + _624.y) + C.data[5u]), f16vec2((_640.x + _640.y) + C.data[6u], (_656.x + _656.y) + C.data[7u]), f16vec2((_672.x + _672.y) + C.data[8u], (_688.x + _688.y) + C.data[9u]), f16vec2((_704.x + _704.y) + C.data[10u], (_720.x + _720.y) + C.data[11u]), f16vec2((_736.x + _736.y) + C.data[12u], (_752.x + _752.y) + C.data[13u]), f16vec2((_768.x + _768.y) + C.data[14u], (_784.x + _784.y) + C.data[15u]), f16vec2((_800.x + _800.y) + C.data[16u], (_816.x + _816.y) + C.data[17u]), f16vec2((_832.x + _832.y) + C.data[18u], (_848.x + _848.y) + C.data[19u]), f16vec2((_864.x + _864.y) + C.data[20u], (_880.x + _880.y) + C.data[21u]), f16vec2((_896.x + _896.y) + C.data[22u], (_912.x + _912.y) + C.data[23u]), f16vec2((_928.x + _928.y) + C.data[24u], (_944.x + _944.y) + C.data[25u]), f16vec2((_960.x + _960.y) + C.data[26u], (_976.x + _976.y) + C.data[27u]), f16vec2((_992.x + _992.y) + C.data[28u], (_1008.x + _1008.y) + C.data[29u]), f16vec2((_1024.x + _1024.y) + C.data[30u], (_1040.x + _1040.y) + C.data[31u]), f16vec2((_1056.x + _1056.y) + C.data[32u], (_1072.x + _1072.y) + C.data[33u]), f16vec2((_1088.x + _1088.y) + C.data[34u], (_1104.x + _1104.y) + C.data[35u]), f16vec2((_1120.x + _1120.y) + C.data[36u], (_1136.x + _1136.y) + C.data[37u]), f16vec2((_1152.x + _1152.y) + C.data[38u], (_1168.x + _1168.y) + C.data[39u]), f16vec2((_1184.x + _1184.y) + C.data[40u], (_1200.x + _1200.y) + C.data[41u]), f16vec2((_1216.x + _1216.y) + C.data[42u], (_1232.x + _1232.y) + C.data[43u]), f16vec2((_1248.x + _1248.y) + C.data[44u], (_1264.x + _1264.y) + C.data[45u]), f16vec2((_1280.x + _1280.y) + C.data[46u], (_1296.x + _1296.y) + C.data[47u]), f16vec2((_1312.x + _1312.y) + C.data[48u], (_1328.x + _1328.y) + C.data[49u]), f16vec2((_1344.x + _1344.y) + C.data[50u], (_1360.x + _1360.y) + C.data[51u]), f16vec2((_1376.x + _1376.y) + C.data[52u], (_1392.x + _1392.y) + C.data[53u]), f16vec2((_1408.x + _1408.y) + C.data[54u], (_1424.x + _1424.y) + C.data[55u]), f16vec2((_1440.x + _1440.y) + C.data[56u], (_1456.x + _1456.y) + C.data[57u]), f16vec2((_1472.x + _1472.y) + C.data[58u], (_1488.x + _1488.y) + C.data[59u]), f16vec2((_1504.x + _1504.y) + C.data[60u], (_1520.x + _1520.y) + C.data[61u]), f16vec2((_1536.x + _1536.y) + C.data[62u], (_1552.x + _1552.y) + C.data[63u]));
}

void _1626(uint _1627, f16vec2 _1628)
{
    D.data[_1627] = _1628.x;
    D.data[_1627 + 1u] = _1628.y;
}

void main()
{
    uint _1590 = 0u + 0u;
    float16_t _50[1] = float16_t[](S.data[_1590]);
    float16_t tempArg[1] = _50;
    float16_t sv[1] = _50;
    f16vec2 _59[32] = f16vec2[](f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]), f16vec2(sv[0]));
    f16vec2 mb[32] = _59;
    f16vec2 _64[32] = _81(_59);
    f16vec2 tempArg_1[32] = _64;
    f16vec2 md[32] = _64;
    f16vec2 _1641[32] = _64;
    uint _1642 = 0u;
    uint _1647;
    for (;;)
    {
        _1647 = _1642;
        if (_1647 < 64u)
        {
            _1626(((uint(0) + (_1647 / 8u)) * uint(8)) + (uint(0) + (_1647 % 8u)), _1641[_1647 / 2u]);
            _1642 = _1647 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

