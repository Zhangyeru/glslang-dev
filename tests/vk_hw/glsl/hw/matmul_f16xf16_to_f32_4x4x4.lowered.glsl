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
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec2[8] _75()
{
    vec2 _202 = fma(vec2(f16vec2(A.data[2u], A.data[3u])), vec2(f16vec2(B.data[8u], B.data[12u])), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[0u], B.data[4u])), vec2(0.0)));
    vec2 _216 = fma(vec2(f16vec2(A.data[2u], A.data[3u])), vec2(f16vec2(B.data[9u], B.data[13u])), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[1u], B.data[5u])), vec2(0.0)));
    vec2 _230 = fma(vec2(f16vec2(A.data[2u], A.data[3u])), vec2(f16vec2(B.data[10u], B.data[14u])), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[2u], B.data[6u])), vec2(0.0)));
    vec2 _244 = fma(vec2(f16vec2(A.data[2u], A.data[3u])), vec2(f16vec2(B.data[11u], B.data[15u])), fma(vec2(f16vec2(A.data[0u], A.data[1u])), vec2(f16vec2(B.data[3u], B.data[7u])), vec2(0.0)));
    vec2 _258 = fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[8u], B.data[12u])), fma(vec2(f16vec2(A.data[4u], A.data[5u])), vec2(f16vec2(B.data[0u], B.data[4u])), vec2(0.0)));
    vec2 _272 = fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[9u], B.data[13u])), fma(vec2(f16vec2(A.data[4u], A.data[5u])), vec2(f16vec2(B.data[1u], B.data[5u])), vec2(0.0)));
    vec2 _286 = fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[10u], B.data[14u])), fma(vec2(f16vec2(A.data[4u], A.data[5u])), vec2(f16vec2(B.data[2u], B.data[6u])), vec2(0.0)));
    vec2 _300 = fma(vec2(f16vec2(A.data[6u], A.data[7u])), vec2(f16vec2(B.data[11u], B.data[15u])), fma(vec2(f16vec2(A.data[4u], A.data[5u])), vec2(f16vec2(B.data[3u], B.data[7u])), vec2(0.0)));
    vec2 _314 = fma(vec2(f16vec2(A.data[10u], A.data[11u])), vec2(f16vec2(B.data[8u], B.data[12u])), fma(vec2(f16vec2(A.data[8u], A.data[9u])), vec2(f16vec2(B.data[0u], B.data[4u])), vec2(0.0)));
    vec2 _328 = fma(vec2(f16vec2(A.data[10u], A.data[11u])), vec2(f16vec2(B.data[9u], B.data[13u])), fma(vec2(f16vec2(A.data[8u], A.data[9u])), vec2(f16vec2(B.data[1u], B.data[5u])), vec2(0.0)));
    vec2 _342 = fma(vec2(f16vec2(A.data[10u], A.data[11u])), vec2(f16vec2(B.data[10u], B.data[14u])), fma(vec2(f16vec2(A.data[8u], A.data[9u])), vec2(f16vec2(B.data[2u], B.data[6u])), vec2(0.0)));
    vec2 _356 = fma(vec2(f16vec2(A.data[10u], A.data[11u])), vec2(f16vec2(B.data[11u], B.data[15u])), fma(vec2(f16vec2(A.data[8u], A.data[9u])), vec2(f16vec2(B.data[3u], B.data[7u])), vec2(0.0)));
    vec2 _370 = fma(vec2(f16vec2(A.data[14u], A.data[15u])), vec2(f16vec2(B.data[8u], B.data[12u])), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[0u], B.data[4u])), vec2(0.0)));
    vec2 _384 = fma(vec2(f16vec2(A.data[14u], A.data[15u])), vec2(f16vec2(B.data[9u], B.data[13u])), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[1u], B.data[5u])), vec2(0.0)));
    vec2 _398 = fma(vec2(f16vec2(A.data[14u], A.data[15u])), vec2(f16vec2(B.data[10u], B.data[14u])), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[2u], B.data[6u])), vec2(0.0)));
    vec2 _412 = fma(vec2(f16vec2(A.data[14u], A.data[15u])), vec2(f16vec2(B.data[11u], B.data[15u])), fma(vec2(f16vec2(A.data[12u], A.data[13u])), vec2(f16vec2(B.data[3u], B.data[7u])), vec2(0.0)));
    return vec2[](vec2((_202.x + _202.y) + C.data[0u], (_216.x + _216.y) + C.data[1u]), vec2((_230.x + _230.y) + C.data[2u], (_244.x + _244.y) + C.data[3u]), vec2((_258.x + _258.y) + C.data[4u], (_272.x + _272.y) + C.data[5u]), vec2((_286.x + _286.y) + C.data[6u], (_300.x + _300.y) + C.data[7u]), vec2((_314.x + _314.y) + C.data[8u], (_328.x + _328.y) + C.data[9u]), vec2((_342.x + _342.y) + C.data[10u], (_356.x + _356.y) + C.data[11u]), vec2((_370.x + _370.y) + C.data[12u], (_384.x + _384.y) + C.data[13u]), vec2((_398.x + _398.y) + C.data[14u], (_412.x + _412.y) + C.data[15u]));
}

void _427(uint _428, vec2 _429)
{
    D.data[_428] = _429.x;
    D.data[_428 + 1u] = _429.y;
}

void main()
{
    vec2 _56[8] = _75();
    vec2 tempArg[8] = _56;
    vec2 d[8] = _56;
    vec2 _442[8] = _56;
    uint _443 = 0u;
    uint _448;
    for (;;)
    {
        _448 = _443;
        if (_448 < 16u)
        {
            _427(((uint(0) + (_448 / 4u)) * uint(4)) + (uint(0) + (_448 % 4u)), _442[_448 / 2u]);
            _443 = _448 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

