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

f16vec4 _117(uint _118)
{
    return f16vec4(A.data[_118], A.data[_118 + 1u], A.data[_118 + 2u], A.data[_118 + 3u]);
}

f16vec4 _166(uint _167)
{
    return f16vec4(B.data[_167], B.data[_167 + 1u], B.data[_167 + 2u], B.data[_167 + 3u]);
}

f16vec4 _207(uint _208)
{
    return f16vec4(C.data[_208], C.data[_208 + 1u], C.data[_208 + 2u], C.data[_208 + 3u]);
}

f16vec4[64] _249(f16vec4 _250[64], f16vec4 _251[64], f16vec4 _252[64])
{
    f16vec4 _268[64] = _250;
    f16vec4 _269[64] = _251;
    f16vec4 _270[64] = _252;
    uint _271 = 0u;
    f16vec4 _267[64];
    uint _278;
    for (;;)
    {
        _278 = _271;
        if (_278 < 16u)
        {
            uint _272 = 0u;
            uint _280;
            for (;;)
            {
                _280 = _272;
                if (_280 < 4u)
                {
                    f16vec4 _274 = f16vec4(float16_t(0.0));
                    f16vec4 _275 = f16vec4(float16_t(0.0));
                    f16vec4 _276 = f16vec4(float16_t(0.0));
                    f16vec4 _277 = f16vec4(float16_t(0.0));
                    uint _273 = 0u;
                    uint _282;
                    for (;;)
                    {
                        _282 = _273;
                        if (_282 < 4u)
                        {
                            uint _285 = (_278 * 4u) + _282;
                            uint _288 = _282 * 4u;
                            uint _291 = ((_288 + 0u) * 4u) + _280;
                            uint _296 = ((_288 + 1u) * 4u) + _280;
                            uint _301 = ((_288 + 2u) * 4u) + _280;
                            uint _306 = ((_288 + 3u) * 4u) + _280;
                            _274 = fma(_268[_285], f16vec4(_269[_291].x, _269[_296].x, _269[_301].x, _269[_306].x), _274);
                            _275 = fma(_268[_285], f16vec4(_269[_291].y, _269[_296].y, _269[_301].y, _269[_306].y), _275);
                            _276 = fma(_268[_285], f16vec4(_269[_291].z, _269[_296].z, _269[_301].z, _269[_306].z), _276);
                            _277 = fma(_268[_285], f16vec4(_269[_291].w, _269[_296].w, _269[_301].w, _269[_306].w), _277);
                            _273 = _282 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _339 = (_278 * 4u) + _280;
                    _267[_339] = f16vec4(_270[_339].x + (((_274.x + _274.y) + _274.z) + _274.w), _270[_339].y + (((_275.x + _275.y) + _275.z) + _275.w), _270[_339].z + (((_276.x + _276.y) + _276.z) + _276.w), _270[_339].w + (((_277.x + _277.y) + _277.z) + _277.w));
                    _272 = _280 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _271 = _278 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _267;
}

void _388(uint _389, f16vec4 _390)
{
    D.data[_389] = _390.x;
    D.data[_389 + 1u] = _390.y;
    D.data[_389 + 2u] = _390.z;
    D.data[_389 + 3u] = _390.w;
}

f16vec4 _429(uint _430)
{
    return f16vec4(A.data[_430], A.data[_430 + 1u], A.data[_430 + 2u], A.data[_430 + 3u]);
}

f16vec4 _459(uint _460)
{
    return f16vec4(D.data[_460], D.data[_460 + 1u], D.data[_460 + 2u], D.data[_460 + 3u]);
}

f16vec4[4] _489(f16vec4 _490[4], f16vec4 _491[64], f16vec4 _492[4])
{
    f16vec4 _509[4] = _490;
    f16vec4 _510[64] = _491;
    f16vec4 _511[4] = _492;
    uint _503 = 0u;
    f16vec4 _502[4];
    uint _512;
    for (;;)
    {
        _512 = _503;
        if (_512 < 4u)
        {
            f16vec4 _505 = f16vec4(float16_t(0.0));
            f16vec4 _506 = f16vec4(float16_t(0.0));
            f16vec4 _507 = f16vec4(float16_t(0.0));
            f16vec4 _508 = f16vec4(float16_t(0.0));
            uint _504 = 0u;
            uint _514;
            for (;;)
            {
                _514 = _504;
                if (_514 < 4u)
                {
                    uint _516 = _514 * 4u;
                    uint _522 = ((_516 + 0u) * 4u) + _512;
                    uint _527 = ((_516 + 1u) * 4u) + _512;
                    uint _532 = ((_516 + 2u) * 4u) + _512;
                    uint _537 = ((_516 + 3u) * 4u) + _512;
                    _505 = fma(_509[_514], f16vec4(_510[_522].x, _510[_527].x, _510[_532].x, _510[_537].x), _505);
                    _506 = fma(_509[_514], f16vec4(_510[_522].y, _510[_527].y, _510[_532].y, _510[_537].y), _506);
                    _507 = fma(_509[_514], f16vec4(_510[_522].z, _510[_527].z, _510[_532].z, _510[_537].z), _507);
                    _508 = fma(_509[_514], f16vec4(_510[_522].w, _510[_527].w, _510[_532].w, _510[_537].w), _508);
                    _504 = _514 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _502[_512] = f16vec4(((_505.x + _505.y) + _505.z) + _505.w, ((_506.x + _506.y) + _506.z) + _506.w, ((_507.x + _507.y) + _507.z) + _507.w, ((_508.x + _508.y) + _508.z) + _508.w) + _511[_512];
            _503 = _512 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _502;
}

void _608(uint _609, f16vec4 _610)
{
    D.data[_609] = _610.x;
    D.data[_609 + 1u] = _610.y;
    D.data[_609 + 2u] = _610.z;
    D.data[_609 + 3u] = _610.w;
}

f16vec4 _637(uint _638)
{
    return f16vec4(D.data[_638], D.data[_638 + 1u], D.data[_638 + 2u], D.data[_638 + 3u]);
}

f16vec4[4] _666(f16vec4 _667[4], f16vec4 _668[64], f16vec4 _669[4])
{
    f16vec4 _686[4] = _667;
    f16vec4 _687[64] = _668;
    f16vec4 _688[4] = _669;
    uint _680 = 0u;
    f16vec4 _679[4];
    uint _689;
    for (;;)
    {
        _689 = _680;
        if (_689 < 4u)
        {
            f16vec4 _682 = f16vec4(float16_t(0.0));
            f16vec4 _683 = f16vec4(float16_t(0.0));
            f16vec4 _684 = f16vec4(float16_t(0.0));
            f16vec4 _685 = f16vec4(float16_t(0.0));
            uint _681 = 0u;
            uint _691;
            for (;;)
            {
                _691 = _681;
                if (_691 < 4u)
                {
                    uint _693 = _691 * 4u;
                    uint _699 = ((_693 + 0u) * 4u) + _689;
                    uint _704 = ((_693 + 1u) * 4u) + _689;
                    uint _709 = ((_693 + 2u) * 4u) + _689;
                    uint _714 = ((_693 + 3u) * 4u) + _689;
                    _682 = fma(_686[_691], f16vec4(_687[_699].x, _687[_704].x, _687[_709].x, _687[_714].x), _682);
                    _683 = fma(_686[_691], f16vec4(_687[_699].y, _687[_704].y, _687[_709].y, _687[_714].y), _683);
                    _684 = fma(_686[_691], f16vec4(_687[_699].z, _687[_704].z, _687[_709].z, _687[_714].z), _684);
                    _685 = fma(_686[_691], f16vec4(_687[_699].w, _687[_704].w, _687[_709].w, _687[_714].w), _685);
                    _681 = _691 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _679[_689] = f16vec4(((_682.x + _682.y) + _682.z) + _682.w, ((_683.x + _683.y) + _683.z) + _683.w, ((_684.x + _684.y) + _684.z) + _684.w, ((_685.x + _685.y) + _685.z) + _685.w) + _688[_689];
            _680 = _689 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _679;
}

void _785(uint _786, f16vec4 _787)
{
    D.data[_786] = _787.x;
    D.data[_786 + 1u] = _787.y;
    D.data[_786 + 2u] = _787.z;
    D.data[_786 + 3u] = _787.w;
}

void main()
{
    uint _142 = 0u;
    f16vec4 _141[64];
    uint _147;
    for (;;)
    {
        _147 = _142;
        if (_147 < 256u)
        {
            _141[_147 / 4u] = _117(((uint(0) + (_147 / 16u)) * uint(16)) + (uint(0) + (_147 % 16u)));
            _142 = _147 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _24[64] = _141;
    f16vec4 tempArg[64] = _24;
    f16vec4 a[64] = _24;
    uint _183 = 0u;
    f16vec4 _182[64];
    uint _188;
    for (;;)
    {
        _188 = _183;
        if (_188 < 256u)
        {
            _182[_188 / 4u] = _166(((uint(0) + (_188 / 16u)) * uint(16)) + (uint(0) + (_188 % 16u)));
            _183 = _188 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _34[64] = _182;
    f16vec4 tempArg_1[64] = _34;
    f16vec4 b[64] = _34;
    uint _224 = 0u;
    f16vec4 _223[64];
    uint _229;
    for (;;)
    {
        _229 = _224;
        if (_229 < 256u)
        {
            _223[_229 / 4u] = _207(((uint(0) + (_229 / 16u)) * uint(16)) + (uint(0) + (_229 % 16u)));
            _224 = _229 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _46[64] = _223;
    f16vec4 tempArg_2[64] = _46;
    f16vec4 c[64] = _46;
    f16vec4 _54[64] = _34;
    f16vec4 _55[64] = _249(_24, _54, _46);
    f16vec4 tempArg_3[64] = _55;
    f16vec4 d0[64] = _55;
    f16vec4 _62[64] = _34;
    f16vec4 _63[64] = _249(_24, _62, _55);
    f16vec4 tempArg_4[64] = _63;
    f16vec4 d1[64] = _63;
    f16vec4 _404[64] = _63;
    uint _405 = 0u;
    uint _410;
    for (;;)
    {
        _410 = _405;
        if (_410 < 256u)
        {
            _388(((uint(0) + (_410 / 16u)) * uint(16)) + (uint(0) + (_410 % 16u)), _404[_410 / 4u]);
            _405 = _410 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    uint _447 = 0u;
    f16vec4 _446[4];
    uint _452;
    for (;;)
    {
        _452 = _447;
        if (_452 < 16u)
        {
            _446[_452 / 4u] = _429(_452);
            _447 = _452 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _78[4] = _446;
    f16vec4 tempArg_5[4] = _78;
    f16vec4 x[4] = _78;
    uint _476 = 0u;
    f16vec4 _475[4];
    uint _481;
    for (;;)
    {
        _481 = _476;
        if (_481 < 16u)
        {
            _475[_481 / 4u] = _459(_481);
            _476 = _481 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _83[4] = _475;
    f16vec4 tempArg_6[4] = _83;
    f16vec4 bias[4] = _83;
    f16vec4 _90[4] = _489(_78, _34, _83);
    f16vec4 tempArg_7[4] = _90;
    f16vec4 y0[4] = _90;
    f16vec4 _624[4] = _90;
    uint _625 = 0u;
    uint _630;
    for (;;)
    {
        _630 = _625;
        if (_630 < 16u)
        {
            _608(_630, _624[_630 / 4u]);
            _625 = _630 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    uint _654 = 0u;
    f16vec4 _653[4];
    uint _659;
    for (;;)
    {
        _659 = _654;
        if (_659 < 16u)
        {
            _653[_659 / 4u] = _637(_659);
            _654 = _659 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _97[4] = _653;
    f16vec4 tempArg_8[4] = _97;
    bias = _97;
    f16vec4 _103[4] = _666(_78, _34, _97);
    f16vec4 tempArg_9[4] = _103;
    f16vec4 y1[4] = _103;
    f16vec4 _801[4] = _103;
    uint _802 = 0u;
    uint _807;
    for (;;)
    {
        _807 = _802;
        if (_807 < 16u)
        {
            _785(_807, _801[_807 / 4u]);
            _802 = _807 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

