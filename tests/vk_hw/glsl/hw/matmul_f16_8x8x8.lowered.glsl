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
    f16vec2 _536 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _552 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _568 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _584 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _600 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _616 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _632 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _648 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _664 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _680 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _696 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _712 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _728 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _744 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _760 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _776 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _792 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _808 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _824 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _840 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _856 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _872 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _888 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _904 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _920 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _936 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _952 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _968 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _984 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1000 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1016 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1032 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1048 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1064 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1080 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1096 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1112 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1128 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1144 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1160 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1176 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1192 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1208 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1224 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1240 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1256 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1272 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1288 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1304 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1320 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1336 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1352 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1368 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1384 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1400 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1416 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1432 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1448 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1464 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1480 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1496 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1512 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1528 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1544 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    return f16vec2[](f16vec2((_536.x + _536.y) + C.data[0u], (_552.x + _552.y) + C.data[1u]), f16vec2((_568.x + _568.y) + C.data[2u], (_584.x + _584.y) + C.data[3u]), f16vec2((_600.x + _600.y) + C.data[4u], (_616.x + _616.y) + C.data[5u]), f16vec2((_632.x + _632.y) + C.data[6u], (_648.x + _648.y) + C.data[7u]), f16vec2((_664.x + _664.y) + C.data[8u], (_680.x + _680.y) + C.data[9u]), f16vec2((_696.x + _696.y) + C.data[10u], (_712.x + _712.y) + C.data[11u]), f16vec2((_728.x + _728.y) + C.data[12u], (_744.x + _744.y) + C.data[13u]), f16vec2((_760.x + _760.y) + C.data[14u], (_776.x + _776.y) + C.data[15u]), f16vec2((_792.x + _792.y) + C.data[16u], (_808.x + _808.y) + C.data[17u]), f16vec2((_824.x + _824.y) + C.data[18u], (_840.x + _840.y) + C.data[19u]), f16vec2((_856.x + _856.y) + C.data[20u], (_872.x + _872.y) + C.data[21u]), f16vec2((_888.x + _888.y) + C.data[22u], (_904.x + _904.y) + C.data[23u]), f16vec2((_920.x + _920.y) + C.data[24u], (_936.x + _936.y) + C.data[25u]), f16vec2((_952.x + _952.y) + C.data[26u], (_968.x + _968.y) + C.data[27u]), f16vec2((_984.x + _984.y) + C.data[28u], (_1000.x + _1000.y) + C.data[29u]), f16vec2((_1016.x + _1016.y) + C.data[30u], (_1032.x + _1032.y) + C.data[31u]), f16vec2((_1048.x + _1048.y) + C.data[32u], (_1064.x + _1064.y) + C.data[33u]), f16vec2((_1080.x + _1080.y) + C.data[34u], (_1096.x + _1096.y) + C.data[35u]), f16vec2((_1112.x + _1112.y) + C.data[36u], (_1128.x + _1128.y) + C.data[37u]), f16vec2((_1144.x + _1144.y) + C.data[38u], (_1160.x + _1160.y) + C.data[39u]), f16vec2((_1176.x + _1176.y) + C.data[40u], (_1192.x + _1192.y) + C.data[41u]), f16vec2((_1208.x + _1208.y) + C.data[42u], (_1224.x + _1224.y) + C.data[43u]), f16vec2((_1240.x + _1240.y) + C.data[44u], (_1256.x + _1256.y) + C.data[45u]), f16vec2((_1272.x + _1272.y) + C.data[46u], (_1288.x + _1288.y) + C.data[47u]), f16vec2((_1304.x + _1304.y) + C.data[48u], (_1320.x + _1320.y) + C.data[49u]), f16vec2((_1336.x + _1336.y) + C.data[50u], (_1352.x + _1352.y) + C.data[51u]), f16vec2((_1368.x + _1368.y) + C.data[52u], (_1384.x + _1384.y) + C.data[53u]), f16vec2((_1400.x + _1400.y) + C.data[54u], (_1416.x + _1416.y) + C.data[55u]), f16vec2((_1432.x + _1432.y) + C.data[56u], (_1448.x + _1448.y) + C.data[57u]), f16vec2((_1464.x + _1464.y) + C.data[58u], (_1480.x + _1480.y) + C.data[59u]), f16vec2((_1496.x + _1496.y) + C.data[60u], (_1512.x + _1512.y) + C.data[61u]), f16vec2((_1528.x + _1528.y) + C.data[62u], (_1544.x + _1544.y) + C.data[63u]));
}

void _1583(uint _1584, f16vec2 _1585)
{
    D.data[_1584] = _1585.x;
    D.data[_1584 + 1u] = _1585.y;
}

void main()
{
    f16vec2 _55[32] = _72();
    f16vec2 tempArg[32] = _55;
    f16vec2 d[32] = _55;
    f16vec2 _1598[32] = _55;
    uint _1599 = 0u;
    uint _1604;
    for (;;)
    {
        _1604 = _1599;
        if (_1604 < 64u)
        {
            _1583(((uint(0) + (_1604 / 8u)) * uint(8)) + (uint(0) + (_1604 % 8u)), _1598[_1604 / 2u]);
            _1599 = _1604 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

