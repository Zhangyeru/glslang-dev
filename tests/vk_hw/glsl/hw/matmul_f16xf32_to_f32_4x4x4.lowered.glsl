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

vec2[8] _75()
{
    vec2 _194 = vec2(f16vec2(A.data[0u]));
    vec2 _200 = vec2(f16vec2(A.data[1u]));
    vec2 _206 = vec2(f16vec2(A.data[2u]));
    vec2 _212 = vec2(f16vec2(A.data[3u]));
    vec2 _220 = vec2(f16vec2(A.data[4u]));
    vec2 _226 = vec2(f16vec2(A.data[5u]));
    vec2 _232 = vec2(f16vec2(A.data[6u]));
    vec2 _238 = vec2(f16vec2(A.data[7u]));
    vec2 _246 = vec2(f16vec2(A.data[8u]));
    vec2 _252 = vec2(f16vec2(A.data[9u]));
    vec2 _258 = vec2(f16vec2(A.data[10u]));
    vec2 _264 = vec2(f16vec2(A.data[11u]));
    vec2 _272 = vec2(f16vec2(A.data[12u]));
    vec2 _278 = vec2(f16vec2(A.data[13u]));
    vec2 _284 = vec2(f16vec2(A.data[14u]));
    vec2 _290 = vec2(f16vec2(A.data[15u]));
    return vec2[](fma(_212, vec2(B.data[12u], B.data[13u]), fma(_206, vec2(B.data[8u], B.data[9u]), fma(_200, vec2(B.data[4u], B.data[5u]), fma(_194, vec2(B.data[0u], B.data[1u]), vec2(C.data[0u], C.data[1u]))))), fma(_212, vec2(B.data[14u], B.data[15u]), fma(_206, vec2(B.data[10u], B.data[11u]), fma(_200, vec2(B.data[6u], B.data[7u]), fma(_194, vec2(B.data[2u], B.data[3u]), vec2(C.data[2u], C.data[3u]))))), fma(_238, vec2(B.data[12u], B.data[13u]), fma(_232, vec2(B.data[8u], B.data[9u]), fma(_226, vec2(B.data[4u], B.data[5u]), fma(_220, vec2(B.data[0u], B.data[1u]), vec2(C.data[4u], C.data[5u]))))), fma(_238, vec2(B.data[14u], B.data[15u]), fma(_232, vec2(B.data[10u], B.data[11u]), fma(_226, vec2(B.data[6u], B.data[7u]), fma(_220, vec2(B.data[2u], B.data[3u]), vec2(C.data[6u], C.data[7u]))))), fma(_264, vec2(B.data[12u], B.data[13u]), fma(_258, vec2(B.data[8u], B.data[9u]), fma(_252, vec2(B.data[4u], B.data[5u]), fma(_246, vec2(B.data[0u], B.data[1u]), vec2(C.data[8u], C.data[9u]))))), fma(_264, vec2(B.data[14u], B.data[15u]), fma(_258, vec2(B.data[10u], B.data[11u]), fma(_252, vec2(B.data[6u], B.data[7u]), fma(_246, vec2(B.data[2u], B.data[3u]), vec2(C.data[10u], C.data[11u]))))), fma(_290, vec2(B.data[12u], B.data[13u]), fma(_284, vec2(B.data[8u], B.data[9u]), fma(_278, vec2(B.data[4u], B.data[5u]), fma(_272, vec2(B.data[0u], B.data[1u]), vec2(C.data[12u], C.data[13u]))))), fma(_290, vec2(B.data[14u], B.data[15u]), fma(_284, vec2(B.data[10u], B.data[11u]), fma(_278, vec2(B.data[6u], B.data[7u]), fma(_272, vec2(B.data[2u], B.data[3u]), vec2(C.data[14u], C.data[15u]))))));
}

void _297(uint _298, vec2 _299)
{
    D.data[_298] = _299.x;
    D.data[_298 + 1u] = _299.y;
}

void main()
{
    vec2 _56[8] = _75();
    vec2 tempArg[8] = _56;
    vec2 d[8] = _56;
    vec2 _312[8] = _56;
    uint _313 = 0u;
    uint _318;
    for (;;)
    {
        _318 = _313;
        if (_318 < 16u)
        {
            _297(((uint(0) + (_318 / 4u)) * uint(4)) + (uint(0) + (_318 % 4u)), _312[_318 / 2u]);
            _313 = _318 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

