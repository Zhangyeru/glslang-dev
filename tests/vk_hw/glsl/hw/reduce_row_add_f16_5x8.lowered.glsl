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

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

f16vec4 _54(uint _55)
{
    return f16vec4(A.data[_55], A.data[_55 + 1u], A.data[_55 + 2u], A.data[_55 + 3u]);
}

void _231(uint _232, f16vec4 _233)
{
    D.data[_232] = _233.x;
    D.data[_232 + 1u] = _233.y;
    D.data[_232 + 2u] = _233.z;
    D.data[_232 + 3u] = _233.w;
}

void main()
{
    uint _81 = 0u;
    f16vec4 _80[10];
    uint _86;
    for (;;)
    {
        _86 = _81;
        if (_86 < 40u)
        {
            _80[_86 / 4u] = _54(((uint(0) + (_86 / 8u)) * uint(8)) + (uint(0) + (_86 % 8u)));
            _81 = _86 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _26[10] = _80;
    f16vec4 tempArg[10] = _26;
    f16vec4 value[10] = _26;
    float16_t _127 = ((((((_26[0].x + _26[0].y) + _26[0].z) + _26[0].w) + _26[1].x) + _26[1].y) + _26[1].z) + _26[1].w;
    float16_t _150 = ((((((_26[2].x + _26[2].y) + _26[2].z) + _26[2].w) + _26[3].x) + _26[3].y) + _26[3].z) + _26[3].w;
    float16_t _173 = ((((((_26[4].x + _26[4].y) + _26[4].z) + _26[4].w) + _26[5].x) + _26[5].y) + _26[5].z) + _26[5].w;
    float16_t _196 = ((((((_26[6].x + _26[6].y) + _26[6].z) + _26[6].w) + _26[7].x) + _26[7].y) + _26[7].z) + _26[7].w;
    float16_t _219 = ((((((_26[8].x + _26[8].y) + _26[8].z) + _26[8].w) + _26[9].x) + _26[9].y) + _26[9].z) + _26[9].w;
    f16vec4 _31[10] = f16vec4[](f16vec4(_127), f16vec4(_127), f16vec4(_150), f16vec4(_150), f16vec4(_173), f16vec4(_173), f16vec4(_196), f16vec4(_196), f16vec4(_219), f16vec4(_219));
    f16vec4 reduced[10] = _31;
    f16vec4 _247[10] = _31;
    uint _248 = 0u;
    uint _253;
    for (;;)
    {
        _253 = _248;
        if (_253 < 40u)
        {
            _231(((uint(0) + (_253 / 8u)) * uint(8)) + (uint(0) + (_253 % 8u)), _247[_253 / 4u]);
            _248 = _253 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

