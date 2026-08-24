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
    vec2 _194 = vec2(f16vec2(A.data[0u]));
    vec2 _202 = vec2(f16vec2(A.data[1u]));
    vec2 _210 = vec2(f16vec2(A.data[2u]));
    vec2 _218 = vec2(f16vec2(A.data[3u]));
    vec2 _228 = vec2(f16vec2(A.data[4u]));
    vec2 _236 = vec2(f16vec2(A.data[5u]));
    vec2 _244 = vec2(f16vec2(A.data[6u]));
    vec2 _252 = vec2(f16vec2(A.data[7u]));
    vec2 _262 = vec2(f16vec2(A.data[8u]));
    vec2 _270 = vec2(f16vec2(A.data[9u]));
    vec2 _278 = vec2(f16vec2(A.data[10u]));
    vec2 _286 = vec2(f16vec2(A.data[11u]));
    vec2 _296 = vec2(f16vec2(A.data[12u]));
    vec2 _304 = vec2(f16vec2(A.data[13u]));
    vec2 _312 = vec2(f16vec2(A.data[14u]));
    vec2 _320 = vec2(f16vec2(A.data[15u]));
    return vec2[](fma(_218, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_210, vec2(f16vec2(B.data[8u], B.data[9u])), fma(_202, vec2(f16vec2(B.data[4u], B.data[5u])), fma(_194, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[0u], C.data[1u]))))), fma(_218, vec2(f16vec2(B.data[14u], B.data[15u])), fma(_210, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_202, vec2(f16vec2(B.data[6u], B.data[7u])), fma(_194, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[2u], C.data[3u]))))), fma(_252, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_244, vec2(f16vec2(B.data[8u], B.data[9u])), fma(_236, vec2(f16vec2(B.data[4u], B.data[5u])), fma(_228, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[4u], C.data[5u]))))), fma(_252, vec2(f16vec2(B.data[14u], B.data[15u])), fma(_244, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_236, vec2(f16vec2(B.data[6u], B.data[7u])), fma(_228, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[6u], C.data[7u]))))), fma(_286, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_278, vec2(f16vec2(B.data[8u], B.data[9u])), fma(_270, vec2(f16vec2(B.data[4u], B.data[5u])), fma(_262, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[8u], C.data[9u]))))), fma(_286, vec2(f16vec2(B.data[14u], B.data[15u])), fma(_278, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_270, vec2(f16vec2(B.data[6u], B.data[7u])), fma(_262, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[10u], C.data[11u]))))), fma(_320, vec2(f16vec2(B.data[12u], B.data[13u])), fma(_312, vec2(f16vec2(B.data[8u], B.data[9u])), fma(_304, vec2(f16vec2(B.data[4u], B.data[5u])), fma(_296, vec2(f16vec2(B.data[0u], B.data[1u])), vec2(C.data[12u], C.data[13u]))))), fma(_320, vec2(f16vec2(B.data[14u], B.data[15u])), fma(_312, vec2(f16vec2(B.data[10u], B.data[11u])), fma(_304, vec2(f16vec2(B.data[6u], B.data[7u])), fma(_296, vec2(f16vec2(B.data[2u], B.data[3u])), vec2(C.data[14u], C.data[15u]))))));
}

void _329(uint _330, vec2 _331)
{
    D.data[_330] = _331.x;
    D.data[_330 + 1u] = _331.y;
}

void main()
{
    vec2 _56[8] = _75();
    vec2 tempArg[8] = _56;
    vec2 d[8] = _56;
    vec2 _344[8] = _56;
    uint _345 = 0u;
    uint _350;
    for (;;)
    {
        _350 = _345;
        if (_350 < 16u)
        {
            _329(((uint(0) + (_350 / 4u)) * uint(4)) + (uint(0) + (_350 % 4u)), _344[_350 / 2u]);
            _345 = _350 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

