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

f16vec4 _72(uint _73)
{
    return f16vec4(A.data[_73], A.data[_73 + 1u], A.data[_73 + 2u], A.data[_73 + 3u]);
}

f16vec4 _123(uint _124)
{
    return f16vec4(B.data[_124], B.data[_124 + 1u], B.data[_124 + 2u], B.data[_124 + 3u]);
}

f16vec4 _164(uint _165)
{
    return f16vec4(C.data[_165], C.data[_165 + 1u], C.data[_165 + 2u], C.data[_165 + 3u]);
}

f16vec4[16] _206(f16vec4 _207[16], f16vec4 _208[16], f16vec4 _209[16])
{
    return f16vec4[](fma(f16vec4(_207[1].w), _208[14], fma(f16vec4(_207[1].z), _208[12], fma(f16vec4(_207[1].y), _208[10], fma(f16vec4(_207[1].x), _208[8], fma(f16vec4(_207[0].w), _208[6], fma(f16vec4(_207[0].z), _208[4], fma(f16vec4(_207[0].y), _208[2], fma(f16vec4(_207[0].x), _208[0], _209[0])))))))), fma(f16vec4(_207[1].w), _208[15], fma(f16vec4(_207[1].z), _208[13], fma(f16vec4(_207[1].y), _208[11], fma(f16vec4(_207[1].x), _208[9], fma(f16vec4(_207[0].w), _208[7], fma(f16vec4(_207[0].z), _208[5], fma(f16vec4(_207[0].y), _208[3], fma(f16vec4(_207[0].x), _208[1], _209[1])))))))), fma(f16vec4(_207[3].w), _208[14], fma(f16vec4(_207[3].z), _208[12], fma(f16vec4(_207[3].y), _208[10], fma(f16vec4(_207[3].x), _208[8], fma(f16vec4(_207[2].w), _208[6], fma(f16vec4(_207[2].z), _208[4], fma(f16vec4(_207[2].y), _208[2], fma(f16vec4(_207[2].x), _208[0], _209[2])))))))), fma(f16vec4(_207[3].w), _208[15], fma(f16vec4(_207[3].z), _208[13], fma(f16vec4(_207[3].y), _208[11], fma(f16vec4(_207[3].x), _208[9], fma(f16vec4(_207[2].w), _208[7], fma(f16vec4(_207[2].z), _208[5], fma(f16vec4(_207[2].y), _208[3], fma(f16vec4(_207[2].x), _208[1], _209[3])))))))), fma(f16vec4(_207[5].w), _208[14], fma(f16vec4(_207[5].z), _208[12], fma(f16vec4(_207[5].y), _208[10], fma(f16vec4(_207[5].x), _208[8], fma(f16vec4(_207[4].w), _208[6], fma(f16vec4(_207[4].z), _208[4], fma(f16vec4(_207[4].y), _208[2], fma(f16vec4(_207[4].x), _208[0], _209[4])))))))), fma(f16vec4(_207[5].w), _208[15], fma(f16vec4(_207[5].z), _208[13], fma(f16vec4(_207[5].y), _208[11], fma(f16vec4(_207[5].x), _208[9], fma(f16vec4(_207[4].w), _208[7], fma(f16vec4(_207[4].z), _208[5], fma(f16vec4(_207[4].y), _208[3], fma(f16vec4(_207[4].x), _208[1], _209[5])))))))), fma(f16vec4(_207[7].w), _208[14], fma(f16vec4(_207[7].z), _208[12], fma(f16vec4(_207[7].y), _208[10], fma(f16vec4(_207[7].x), _208[8], fma(f16vec4(_207[6].w), _208[6], fma(f16vec4(_207[6].z), _208[4], fma(f16vec4(_207[6].y), _208[2], fma(f16vec4(_207[6].x), _208[0], _209[6])))))))), fma(f16vec4(_207[7].w), _208[15], fma(f16vec4(_207[7].z), _208[13], fma(f16vec4(_207[7].y), _208[11], fma(f16vec4(_207[7].x), _208[9], fma(f16vec4(_207[6].w), _208[7], fma(f16vec4(_207[6].z), _208[5], fma(f16vec4(_207[6].y), _208[3], fma(f16vec4(_207[6].x), _208[1], _209[7])))))))), fma(f16vec4(_207[9].w), _208[14], fma(f16vec4(_207[9].z), _208[12], fma(f16vec4(_207[9].y), _208[10], fma(f16vec4(_207[9].x), _208[8], fma(f16vec4(_207[8].w), _208[6], fma(f16vec4(_207[8].z), _208[4], fma(f16vec4(_207[8].y), _208[2], fma(f16vec4(_207[8].x), _208[0], _209[8])))))))), fma(f16vec4(_207[9].w), _208[15], fma(f16vec4(_207[9].z), _208[13], fma(f16vec4(_207[9].y), _208[11], fma(f16vec4(_207[9].x), _208[9], fma(f16vec4(_207[8].w), _208[7], fma(f16vec4(_207[8].z), _208[5], fma(f16vec4(_207[8].y), _208[3], fma(f16vec4(_207[8].x), _208[1], _209[9])))))))), fma(f16vec4(_207[11].w), _208[14], fma(f16vec4(_207[11].z), _208[12], fma(f16vec4(_207[11].y), _208[10], fma(f16vec4(_207[11].x), _208[8], fma(f16vec4(_207[10].w), _208[6], fma(f16vec4(_207[10].z), _208[4], fma(f16vec4(_207[10].y), _208[2], fma(f16vec4(_207[10].x), _208[0], _209[10])))))))), fma(f16vec4(_207[11].w), _208[15], fma(f16vec4(_207[11].z), _208[13], fma(f16vec4(_207[11].y), _208[11], fma(f16vec4(_207[11].x), _208[9], fma(f16vec4(_207[10].w), _208[7], fma(f16vec4(_207[10].z), _208[5], fma(f16vec4(_207[10].y), _208[3], fma(f16vec4(_207[10].x), _208[1], _209[11])))))))), fma(f16vec4(_207[13].w), _208[14], fma(f16vec4(_207[13].z), _208[12], fma(f16vec4(_207[13].y), _208[10], fma(f16vec4(_207[13].x), _208[8], fma(f16vec4(_207[12].w), _208[6], fma(f16vec4(_207[12].z), _208[4], fma(f16vec4(_207[12].y), _208[2], fma(f16vec4(_207[12].x), _208[0], _209[12])))))))), fma(f16vec4(_207[13].w), _208[15], fma(f16vec4(_207[13].z), _208[13], fma(f16vec4(_207[13].y), _208[11], fma(f16vec4(_207[13].x), _208[9], fma(f16vec4(_207[12].w), _208[7], fma(f16vec4(_207[12].z), _208[5], fma(f16vec4(_207[12].y), _208[3], fma(f16vec4(_207[12].x), _208[1], _209[13])))))))), fma(f16vec4(_207[15].w), _208[14], fma(f16vec4(_207[15].z), _208[12], fma(f16vec4(_207[15].y), _208[10], fma(f16vec4(_207[15].x), _208[8], fma(f16vec4(_207[14].w), _208[6], fma(f16vec4(_207[14].z), _208[4], fma(f16vec4(_207[14].y), _208[2], fma(f16vec4(_207[14].x), _208[0], _209[14])))))))), fma(f16vec4(_207[15].w), _208[15], fma(f16vec4(_207[15].z), _208[13], fma(f16vec4(_207[15].y), _208[11], fma(f16vec4(_207[15].x), _208[9], fma(f16vec4(_207[14].w), _208[7], fma(f16vec4(_207[14].z), _208[5], fma(f16vec4(_207[14].y), _208[3], fma(f16vec4(_207[14].x), _208[1], _209[15])))))))));
}

void _869(uint _870, f16vec4 _871)
{
    D.data[_870] = _871.x;
    D.data[_870 + 1u] = _871.y;
    D.data[_870 + 2u] = _871.z;
    D.data[_870 + 3u] = _871.w;
}

void main()
{
    uint _99 = 0u;
    f16vec4 _98[16];
    uint _104;
    for (;;)
    {
        _104 = _99;
        if (_104 < 64u)
        {
            _98[_104 / 4u] = _72(((uint(0) + (_104 / 8u)) * uint(8)) + (uint(0) + (_104 % 8u)));
            _99 = _104 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _24[16] = _98;
    f16vec4 tempArg[16] = _24;
    f16vec4 a[16] = _24;
    uint _140 = 0u;
    f16vec4 _139[16];
    uint _145;
    for (;;)
    {
        _145 = _140;
        if (_145 < 64u)
        {
            _139[_145 / 4u] = _123(((uint(0) + (_145 / 8u)) * uint(8)) + (uint(0) + (_145 % 8u)));
            _140 = _145 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _36[16] = _139;
    f16vec4 tempArg_1[16] = _36;
    f16vec4 b[16] = _36;
    uint _181 = 0u;
    f16vec4 _180[16];
    uint _186;
    for (;;)
    {
        _186 = _181;
        if (_186 < 64u)
        {
            _180[_186 / 4u] = _164(((uint(0) + (_186 / 8u)) * uint(8)) + (uint(0) + (_186 % 8u)));
            _181 = _186 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _48[16] = _180;
    f16vec4 tempArg_2[16] = _48;
    f16vec4 c[16] = _48;
    f16vec4 _55[16] = _206(_24, _36, _48);
    f16vec4 tempArg_3[16] = _55;
    f16vec4 d[16] = _55;
    f16vec4 _885[16] = _55;
    uint _886 = 0u;
    uint _891;
    for (;;)
    {
        _891 = _886;
        if (_891 < 64u)
        {
            _869(((uint(0) + (_891 / 8u)) * uint(8)) + (uint(0) + (_891 % 8u)), _885[_891 / 4u]);
            _886 = _891 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

