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

float16_t[35] _81()
{
    f16vec2 _266 = fma(f16vec2(A.data[2u], float16_t(0.0)), f16vec2(B.data[10u], float16_t(0.0)), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[0u], B.data[5u]), f16vec2(float16_t(0.0))));
    f16vec2 _276 = fma(f16vec2(A.data[2u], float16_t(0.0)), f16vec2(B.data[11u], float16_t(0.0)), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[1u], B.data[6u]), f16vec2(float16_t(0.0))));
    f16vec2 _286 = fma(f16vec2(A.data[2u], float16_t(0.0)), f16vec2(B.data[12u], float16_t(0.0)), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[2u], B.data[7u]), f16vec2(float16_t(0.0))));
    f16vec2 _296 = fma(f16vec2(A.data[2u], float16_t(0.0)), f16vec2(B.data[13u], float16_t(0.0)), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[3u], B.data[8u]), f16vec2(float16_t(0.0))));
    f16vec2 _306 = fma(f16vec2(A.data[2u], float16_t(0.0)), f16vec2(B.data[14u], float16_t(0.0)), fma(f16vec2(A.data[0u], A.data[1u]), f16vec2(B.data[4u], B.data[9u]), f16vec2(float16_t(0.0))));
    f16vec2 _316 = fma(f16vec2(A.data[5u], float16_t(0.0)), f16vec2(B.data[10u], float16_t(0.0)), fma(f16vec2(A.data[3u], A.data[4u]), f16vec2(B.data[0u], B.data[5u]), f16vec2(float16_t(0.0))));
    f16vec2 _326 = fma(f16vec2(A.data[5u], float16_t(0.0)), f16vec2(B.data[11u], float16_t(0.0)), fma(f16vec2(A.data[3u], A.data[4u]), f16vec2(B.data[1u], B.data[6u]), f16vec2(float16_t(0.0))));
    f16vec2 _336 = fma(f16vec2(A.data[5u], float16_t(0.0)), f16vec2(B.data[12u], float16_t(0.0)), fma(f16vec2(A.data[3u], A.data[4u]), f16vec2(B.data[2u], B.data[7u]), f16vec2(float16_t(0.0))));
    f16vec2 _346 = fma(f16vec2(A.data[5u], float16_t(0.0)), f16vec2(B.data[13u], float16_t(0.0)), fma(f16vec2(A.data[3u], A.data[4u]), f16vec2(B.data[3u], B.data[8u]), f16vec2(float16_t(0.0))));
    f16vec2 _356 = fma(f16vec2(A.data[5u], float16_t(0.0)), f16vec2(B.data[14u], float16_t(0.0)), fma(f16vec2(A.data[3u], A.data[4u]), f16vec2(B.data[4u], B.data[9u]), f16vec2(float16_t(0.0))));
    f16vec2 _366 = fma(f16vec2(A.data[8u], float16_t(0.0)), f16vec2(B.data[10u], float16_t(0.0)), fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[0u], B.data[5u]), f16vec2(float16_t(0.0))));
    f16vec2 _376 = fma(f16vec2(A.data[8u], float16_t(0.0)), f16vec2(B.data[11u], float16_t(0.0)), fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[1u], B.data[6u]), f16vec2(float16_t(0.0))));
    f16vec2 _386 = fma(f16vec2(A.data[8u], float16_t(0.0)), f16vec2(B.data[12u], float16_t(0.0)), fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[2u], B.data[7u]), f16vec2(float16_t(0.0))));
    f16vec2 _396 = fma(f16vec2(A.data[8u], float16_t(0.0)), f16vec2(B.data[13u], float16_t(0.0)), fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[3u], B.data[8u]), f16vec2(float16_t(0.0))));
    f16vec2 _406 = fma(f16vec2(A.data[8u], float16_t(0.0)), f16vec2(B.data[14u], float16_t(0.0)), fma(f16vec2(A.data[6u], A.data[7u]), f16vec2(B.data[4u], B.data[9u]), f16vec2(float16_t(0.0))));
    f16vec2 _416 = fma(f16vec2(A.data[11u], float16_t(0.0)), f16vec2(B.data[10u], float16_t(0.0)), fma(f16vec2(A.data[9u], A.data[10u]), f16vec2(B.data[0u], B.data[5u]), f16vec2(float16_t(0.0))));
    f16vec2 _426 = fma(f16vec2(A.data[11u], float16_t(0.0)), f16vec2(B.data[11u], float16_t(0.0)), fma(f16vec2(A.data[9u], A.data[10u]), f16vec2(B.data[1u], B.data[6u]), f16vec2(float16_t(0.0))));
    f16vec2 _436 = fma(f16vec2(A.data[11u], float16_t(0.0)), f16vec2(B.data[12u], float16_t(0.0)), fma(f16vec2(A.data[9u], A.data[10u]), f16vec2(B.data[2u], B.data[7u]), f16vec2(float16_t(0.0))));
    f16vec2 _446 = fma(f16vec2(A.data[11u], float16_t(0.0)), f16vec2(B.data[13u], float16_t(0.0)), fma(f16vec2(A.data[9u], A.data[10u]), f16vec2(B.data[3u], B.data[8u]), f16vec2(float16_t(0.0))));
    f16vec2 _456 = fma(f16vec2(A.data[11u], float16_t(0.0)), f16vec2(B.data[14u], float16_t(0.0)), fma(f16vec2(A.data[9u], A.data[10u]), f16vec2(B.data[4u], B.data[9u]), f16vec2(float16_t(0.0))));
    f16vec2 _466 = fma(f16vec2(A.data[14u], float16_t(0.0)), f16vec2(B.data[10u], float16_t(0.0)), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[0u], B.data[5u]), f16vec2(float16_t(0.0))));
    f16vec2 _476 = fma(f16vec2(A.data[14u], float16_t(0.0)), f16vec2(B.data[11u], float16_t(0.0)), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[1u], B.data[6u]), f16vec2(float16_t(0.0))));
    f16vec2 _486 = fma(f16vec2(A.data[14u], float16_t(0.0)), f16vec2(B.data[12u], float16_t(0.0)), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[2u], B.data[7u]), f16vec2(float16_t(0.0))));
    f16vec2 _496 = fma(f16vec2(A.data[14u], float16_t(0.0)), f16vec2(B.data[13u], float16_t(0.0)), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[3u], B.data[8u]), f16vec2(float16_t(0.0))));
    f16vec2 _506 = fma(f16vec2(A.data[14u], float16_t(0.0)), f16vec2(B.data[14u], float16_t(0.0)), fma(f16vec2(A.data[12u], A.data[13u]), f16vec2(B.data[4u], B.data[9u]), f16vec2(float16_t(0.0))));
    f16vec2 _516 = fma(f16vec2(A.data[17u], float16_t(0.0)), f16vec2(B.data[10u], float16_t(0.0)), fma(f16vec2(A.data[15u], A.data[16u]), f16vec2(B.data[0u], B.data[5u]), f16vec2(float16_t(0.0))));
    f16vec2 _526 = fma(f16vec2(A.data[17u], float16_t(0.0)), f16vec2(B.data[11u], float16_t(0.0)), fma(f16vec2(A.data[15u], A.data[16u]), f16vec2(B.data[1u], B.data[6u]), f16vec2(float16_t(0.0))));
    f16vec2 _536 = fma(f16vec2(A.data[17u], float16_t(0.0)), f16vec2(B.data[12u], float16_t(0.0)), fma(f16vec2(A.data[15u], A.data[16u]), f16vec2(B.data[2u], B.data[7u]), f16vec2(float16_t(0.0))));
    f16vec2 _546 = fma(f16vec2(A.data[17u], float16_t(0.0)), f16vec2(B.data[13u], float16_t(0.0)), fma(f16vec2(A.data[15u], A.data[16u]), f16vec2(B.data[3u], B.data[8u]), f16vec2(float16_t(0.0))));
    f16vec2 _556 = fma(f16vec2(A.data[17u], float16_t(0.0)), f16vec2(B.data[14u], float16_t(0.0)), fma(f16vec2(A.data[15u], A.data[16u]), f16vec2(B.data[4u], B.data[9u]), f16vec2(float16_t(0.0))));
    f16vec2 _566 = fma(f16vec2(A.data[20u], float16_t(0.0)), f16vec2(B.data[10u], float16_t(0.0)), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[0u], B.data[5u]), f16vec2(float16_t(0.0))));
    f16vec2 _576 = fma(f16vec2(A.data[20u], float16_t(0.0)), f16vec2(B.data[11u], float16_t(0.0)), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[1u], B.data[6u]), f16vec2(float16_t(0.0))));
    f16vec2 _586 = fma(f16vec2(A.data[20u], float16_t(0.0)), f16vec2(B.data[12u], float16_t(0.0)), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[2u], B.data[7u]), f16vec2(float16_t(0.0))));
    f16vec2 _596 = fma(f16vec2(A.data[20u], float16_t(0.0)), f16vec2(B.data[13u], float16_t(0.0)), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[3u], B.data[8u]), f16vec2(float16_t(0.0))));
    f16vec2 _606 = fma(f16vec2(A.data[20u], float16_t(0.0)), f16vec2(B.data[14u], float16_t(0.0)), fma(f16vec2(A.data[18u], A.data[19u]), f16vec2(B.data[4u], B.data[9u]), f16vec2(float16_t(0.0))));
    return float16_t[]((_266.x + _266.y) + C.data[0u], (_276.x + _276.y) + C.data[1u], (_286.x + _286.y) + C.data[2u], (_296.x + _296.y) + C.data[3u], (_306.x + _306.y) + C.data[4u], (_316.x + _316.y) + C.data[5u], (_326.x + _326.y) + C.data[6u], (_336.x + _336.y) + C.data[7u], (_346.x + _346.y) + C.data[8u], (_356.x + _356.y) + C.data[9u], (_366.x + _366.y) + C.data[10u], (_376.x + _376.y) + C.data[11u], (_386.x + _386.y) + C.data[12u], (_396.x + _396.y) + C.data[13u], (_406.x + _406.y) + C.data[14u], (_416.x + _416.y) + C.data[15u], (_426.x + _426.y) + C.data[16u], (_436.x + _436.y) + C.data[17u], (_446.x + _446.y) + C.data[18u], (_456.x + _456.y) + C.data[19u], (_466.x + _466.y) + C.data[20u], (_476.x + _476.y) + C.data[21u], (_486.x + _486.y) + C.data[22u], (_496.x + _496.y) + C.data[23u], (_506.x + _506.y) + C.data[24u], (_516.x + _516.y) + C.data[25u], (_526.x + _526.y) + C.data[26u], (_536.x + _536.y) + C.data[27u], (_546.x + _546.y) + C.data[28u], (_556.x + _556.y) + C.data[29u], (_566.x + _566.y) + C.data[30u], (_576.x + _576.y) + C.data[31u], (_586.x + _586.y) + C.data[32u], (_596.x + _596.y) + C.data[33u], (_606.x + _606.y) + C.data[34u]);
}

void main()
{
    float16_t _61[35] = _81();
    float16_t tempArg[35] = _61;
    float16_t d[35] = _61;
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 0u)] = _61[0];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 1u)] = _61[1];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 2u)] = _61[2];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 3u)] = _61[3];
    D.data[((uint(0) + 0u) * uint(5)) + (uint(0) + 4u)] = _61[4];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 0u)] = _61[5];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 1u)] = _61[6];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 2u)] = _61[7];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 3u)] = _61[8];
    D.data[((uint(0) + 1u) * uint(5)) + (uint(0) + 4u)] = _61[9];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 0u)] = _61[10];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 1u)] = _61[11];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 2u)] = _61[12];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 3u)] = _61[13];
    D.data[((uint(0) + 2u) * uint(5)) + (uint(0) + 4u)] = _61[14];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 0u)] = _61[15];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 1u)] = _61[16];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 2u)] = _61[17];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 3u)] = _61[18];
    D.data[((uint(0) + 3u) * uint(5)) + (uint(0) + 4u)] = _61[19];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 0u)] = _61[20];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 1u)] = _61[21];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 2u)] = _61[22];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 3u)] = _61[23];
    D.data[((uint(0) + 4u) * uint(5)) + (uint(0) + 4u)] = _61[24];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 0u)] = _61[25];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 1u)] = _61[26];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 2u)] = _61[27];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 3u)] = _61[28];
    D.data[((uint(0) + 5u) * uint(5)) + (uint(0) + 4u)] = _61[29];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 0u)] = _61[30];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 1u)] = _61[31];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 2u)] = _61[32];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 3u)] = _61[33];
    D.data[((uint(0) + 6u) * uint(5)) + (uint(0) + 4u)] = _61[34];
}

