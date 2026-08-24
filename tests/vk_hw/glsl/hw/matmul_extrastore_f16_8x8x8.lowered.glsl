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

f16vec2 _1590(uint _1591)
{
    return f16vec2(B.data[_1591], B.data[_1591 + 1u]);
}

f16vec2[32] _79()
{
    f16vec2 _543 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _559 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _575 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _591 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _607 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _623 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _639 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _655 = fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[4u], A.data[5u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[2u], A.data[3u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _671 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _687 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _703 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _719 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _735 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _751 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _767 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _783 = fma(f16vec2(A.data[14u], A.data[15u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[10u], A.data[11u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[8u], A.data[9u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _799 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _815 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _831 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _847 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _863 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _879 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _895 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _911 = fma(f16vec2(A.data[22u], A.data[23u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[20u], A.data[21u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[16u], A.data[17u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _927 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _943 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _959 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _975 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _991 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1007 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1023 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1039 = fma(f16vec2(A.data[30u], A.data[31u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[28u], A.data[29u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[26u], A.data[27u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[24u], A.data[25u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1055 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1071 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1087 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1103 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1119 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1135 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1151 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1167 = fma(f16vec2(A.data[38u], A.data[39u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[36u], A.data[37u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[34u], A.data[35u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[32u], A.data[33u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1183 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1199 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1215 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1231 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1247 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1263 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1279 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1295 = fma(f16vec2(A.data[46u], A.data[47u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[44u], A.data[45u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[42u], A.data[43u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[40u], A.data[41u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1311 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1327 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1343 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1359 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1375 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1391 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1407 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1423 = fma(f16vec2(A.data[54u], A.data[55u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[52u], A.data[53u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[50u], A.data[51u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[48u], A.data[49u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1439 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[48u], B.data[56u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[32u], B.data[40u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[16u], B.data[24u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[0u], B.data[8u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1455 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[49u], B.data[57u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[33u], B.data[41u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[17u], B.data[25u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[1u], B.data[9u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1471 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[50u], B.data[58u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[34u], B.data[42u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[18u], B.data[26u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[2u], B.data[10u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1487 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[51u], B.data[59u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[35u], B.data[43u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[19u], B.data[27u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[3u], B.data[11u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1503 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[52u], B.data[60u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[36u], B.data[44u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[20u], B.data[28u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[4u], B.data[12u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1519 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[53u], B.data[61u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[37u], B.data[45u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[21u], B.data[29u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[5u], B.data[13u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1535 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[54u], B.data[62u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[38u], B.data[46u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[22u], B.data[30u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[6u], B.data[14u]), f16vec2(float16_t(0.0))))));
    f16vec2 _1551 = fma(f16vec2(A.data[62u], A.data[63u]), f16vec2(B.data[55u], B.data[63u]), fma(f16vec2(A.data[60u], A.data[61u]), f16vec2(B.data[39u], B.data[47u]), fma(f16vec2(A.data[58u], A.data[59u]), f16vec2(B.data[23u], B.data[31u]), fma(f16vec2(A.data[56u], A.data[57u]), f16vec2(B.data[7u], B.data[15u]), f16vec2(float16_t(0.0))))));
    return f16vec2[](f16vec2((_543.x + _543.y) + C.data[0u], (_559.x + _559.y) + C.data[1u]), f16vec2((_575.x + _575.y) + C.data[2u], (_591.x + _591.y) + C.data[3u]), f16vec2((_607.x + _607.y) + C.data[4u], (_623.x + _623.y) + C.data[5u]), f16vec2((_639.x + _639.y) + C.data[6u], (_655.x + _655.y) + C.data[7u]), f16vec2((_671.x + _671.y) + C.data[8u], (_687.x + _687.y) + C.data[9u]), f16vec2((_703.x + _703.y) + C.data[10u], (_719.x + _719.y) + C.data[11u]), f16vec2((_735.x + _735.y) + C.data[12u], (_751.x + _751.y) + C.data[13u]), f16vec2((_767.x + _767.y) + C.data[14u], (_783.x + _783.y) + C.data[15u]), f16vec2((_799.x + _799.y) + C.data[16u], (_815.x + _815.y) + C.data[17u]), f16vec2((_831.x + _831.y) + C.data[18u], (_847.x + _847.y) + C.data[19u]), f16vec2((_863.x + _863.y) + C.data[20u], (_879.x + _879.y) + C.data[21u]), f16vec2((_895.x + _895.y) + C.data[22u], (_911.x + _911.y) + C.data[23u]), f16vec2((_927.x + _927.y) + C.data[24u], (_943.x + _943.y) + C.data[25u]), f16vec2((_959.x + _959.y) + C.data[26u], (_975.x + _975.y) + C.data[27u]), f16vec2((_991.x + _991.y) + C.data[28u], (_1007.x + _1007.y) + C.data[29u]), f16vec2((_1023.x + _1023.y) + C.data[30u], (_1039.x + _1039.y) + C.data[31u]), f16vec2((_1055.x + _1055.y) + C.data[32u], (_1071.x + _1071.y) + C.data[33u]), f16vec2((_1087.x + _1087.y) + C.data[34u], (_1103.x + _1103.y) + C.data[35u]), f16vec2((_1119.x + _1119.y) + C.data[36u], (_1135.x + _1135.y) + C.data[37u]), f16vec2((_1151.x + _1151.y) + C.data[38u], (_1167.x + _1167.y) + C.data[39u]), f16vec2((_1183.x + _1183.y) + C.data[40u], (_1199.x + _1199.y) + C.data[41u]), f16vec2((_1215.x + _1215.y) + C.data[42u], (_1231.x + _1231.y) + C.data[43u]), f16vec2((_1247.x + _1247.y) + C.data[44u], (_1263.x + _1263.y) + C.data[45u]), f16vec2((_1279.x + _1279.y) + C.data[46u], (_1295.x + _1295.y) + C.data[47u]), f16vec2((_1311.x + _1311.y) + C.data[48u], (_1327.x + _1327.y) + C.data[49u]), f16vec2((_1343.x + _1343.y) + C.data[50u], (_1359.x + _1359.y) + C.data[51u]), f16vec2((_1375.x + _1375.y) + C.data[52u], (_1391.x + _1391.y) + C.data[53u]), f16vec2((_1407.x + _1407.y) + C.data[54u], (_1423.x + _1423.y) + C.data[55u]), f16vec2((_1439.x + _1439.y) + C.data[56u], (_1455.x + _1455.y) + C.data[57u]), f16vec2((_1471.x + _1471.y) + C.data[58u], (_1487.x + _1487.y) + C.data[59u]), f16vec2((_1503.x + _1503.y) + C.data[60u], (_1519.x + _1519.y) + C.data[61u]), f16vec2((_1535.x + _1535.y) + C.data[62u], (_1551.x + _1551.y) + C.data[63u]));
}

void _1631(uint _1632, f16vec2 _1633)
{
    D.data[_1632] = _1633.x;
    D.data[_1632 + 1u] = _1633.y;
}

void _1666(uint _1667, f16vec2 _1668)
{
    E.data[_1667] = _1668.x;
    E.data[_1667 + 1u] = _1668.y;
}

void main()
{
    uint _1606 = 0u;
    f16vec2 _1605[32];
    uint _1611;
    for (;;)
    {
        _1611 = _1606;
        if (_1611 < 64u)
        {
            _1605[_1611 / 2u] = _1590(((uint(0) + (_1611 / 8u)) * uint(8)) + (uint(0) + (_1611 % 8u)));
            _1606 = _1611 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _36[32] = _1605;
    f16vec2 tempArg[32] = _36;
    f16vec2 w[32] = _36;
    f16vec2 _55[32] = _79();
    f16vec2 tempArg_1[32] = _55;
    f16vec2 d[32] = _55;
    f16vec2 _1641[32] = _55;
    uint _1642 = 0u;
    uint _1647;
    for (;;)
    {
        _1647 = _1642;
        if (_1647 < 64u)
        {
            _1631(((uint(0) + (_1647 / 8u)) * uint(8)) + (uint(0) + (_1647 % 8u)), _1641[_1647 / 2u]);
            _1642 = _1647 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _1676[32] = _36;
    uint _1677 = 0u;
    uint _1682;
    for (;;)
    {
        _1682 = _1677;
        if (_1682 < 64u)
        {
            _1666(((uint(0) + (_1682 / 8u)) * uint(8)) + (uint(0) + (_1682 % 8u)), _1676[_1682 / 2u]);
            _1677 = _1682 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

