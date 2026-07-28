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

f16vec4 _116(uint _117)
{
    return f16vec4(A.data[_117], A.data[_117 + 1u], A.data[_117 + 2u], A.data[_117 + 3u]);
}

f16vec4 _135(uint _136)
{
    return f16vec4(B.data[_136], B.data[_136 + 1u], B.data[_136 + 2u], B.data[_136 + 3u]);
}

f16vec4 _151(uint _152)
{
    return f16vec4(C.data[_152], C.data[_152 + 1u], C.data[_152 + 2u], C.data[_152 + 3u]);
}

f16vec4[64] _173()
{
    uint _188 = 0u;
    f16vec4 _187[64];
    uint _195;
    for (;;)
    {
        _195 = _188;
        if (_195 < 16u)
        {
            uint _189 = 0u;
            uint _197;
            for (;;)
            {
                _197 = _189;
                if (_197 < 4u)
                {
                    f16vec4 _191 = f16vec4(float16_t(0.0));
                    f16vec4 _192 = f16vec4(float16_t(0.0));
                    f16vec4 _193 = f16vec4(float16_t(0.0));
                    f16vec4 _194 = f16vec4(float16_t(0.0));
                    uint _190 = 0u;
                    uint _199;
                    for (;;)
                    {
                        _199 = _190;
                        if (_199 < 4u)
                        {
                            uint _201 = _199 * 4u;
                            uint _203 = (_195 * 16u) + _201;
                            f16vec4 _216 = _116(((uint(0) + (_203 / 16u)) * uint(16)) + (uint(0) + (_203 % 16u)));
                            uint _220 = ((_201 + 0u) * 16u) + (_197 * 4u);
                            f16vec4 _233 = _135(((uint(0) + (_220 / 16u)) * uint(16)) + (uint(0) + (_220 % 16u)));
                            uint _237 = ((_201 + 1u) * 16u) + (_197 * 4u);
                            f16vec4 _250 = _135(((uint(0) + (_237 / 16u)) * uint(16)) + (uint(0) + (_237 % 16u)));
                            uint _254 = ((_201 + 2u) * 16u) + (_197 * 4u);
                            f16vec4 _267 = _135(((uint(0) + (_254 / 16u)) * uint(16)) + (uint(0) + (_254 % 16u)));
                            uint _271 = ((_201 + 3u) * 16u) + (_197 * 4u);
                            f16vec4 _284 = _135(((uint(0) + (_271 / 16u)) * uint(16)) + (uint(0) + (_271 % 16u)));
                            _191 = fma(_216, f16vec4(_233.x, _250.x, _267.x, _284.x), _191);
                            _192 = fma(_216, f16vec4(_233.y, _250.y, _267.y, _284.y), _192);
                            _193 = fma(_216, f16vec4(_233.z, _250.z, _267.z, _284.z), _193);
                            _194 = fma(_216, f16vec4(_233.w, _250.w, _267.w, _284.w), _194);
                            _190 = _199 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _318 = (_195 * 16u) + (_197 * 4u);
                    f16vec4 _331 = _151(((uint(0) + (_318 / 16u)) * uint(16)) + (uint(0) + (_318 % 16u)));
                    _187[(_195 * 4u) + _197] = f16vec4(_331.x + (((_191.x + _191.y) + _191.z) + _191.w), _331.y + (((_192.x + _192.y) + _192.z) + _192.w), _331.z + (((_193.x + _193.y) + _193.z) + _193.w), _331.w + (((_194.x + _194.y) + _194.z) + _194.w));
                    _189 = _197 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _188 = _195 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _187;
}

f16vec4[64] _378(f16vec4 _379[64])
{
    f16vec4 _401[64] = _379;
    uint _394 = 0u;
    f16vec4 _393[64];
    uint _402;
    for (;;)
    {
        _402 = _394;
        if (_402 < 16u)
        {
            uint _395 = 0u;
            uint _404;
            for (;;)
            {
                _404 = _395;
                if (_404 < 4u)
                {
                    f16vec4 _397 = f16vec4(float16_t(0.0));
                    f16vec4 _398 = f16vec4(float16_t(0.0));
                    f16vec4 _399 = f16vec4(float16_t(0.0));
                    f16vec4 _400 = f16vec4(float16_t(0.0));
                    uint _396 = 0u;
                    uint _406;
                    for (;;)
                    {
                        _406 = _396;
                        if (_406 < 4u)
                        {
                            uint _408 = _406 * 4u;
                            uint _410 = (_402 * 16u) + _408;
                            f16vec4 _423 = _116(((uint(0) + (_410 / 16u)) * uint(16)) + (uint(0) + (_410 % 16u)));
                            uint _427 = ((_408 + 0u) * 16u) + (_404 * 4u);
                            f16vec4 _440 = _135(((uint(0) + (_427 / 16u)) * uint(16)) + (uint(0) + (_427 % 16u)));
                            uint _444 = ((_408 + 1u) * 16u) + (_404 * 4u);
                            f16vec4 _457 = _135(((uint(0) + (_444 / 16u)) * uint(16)) + (uint(0) + (_444 % 16u)));
                            uint _461 = ((_408 + 2u) * 16u) + (_404 * 4u);
                            f16vec4 _474 = _135(((uint(0) + (_461 / 16u)) * uint(16)) + (uint(0) + (_461 % 16u)));
                            uint _478 = ((_408 + 3u) * 16u) + (_404 * 4u);
                            f16vec4 _491 = _135(((uint(0) + (_478 / 16u)) * uint(16)) + (uint(0) + (_478 % 16u)));
                            _397 = fma(_423, f16vec4(_440.x, _457.x, _474.x, _491.x), _397);
                            _398 = fma(_423, f16vec4(_440.y, _457.y, _474.y, _491.y), _398);
                            _399 = fma(_423, f16vec4(_440.z, _457.z, _474.z, _491.z), _399);
                            _400 = fma(_423, f16vec4(_440.w, _457.w, _474.w, _491.w), _400);
                            _396 = _406 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _524 = (_402 * 4u) + _404;
                    _393[(_402 * 4u) + _404] = f16vec4(_401[_524].x + (((_397.x + _397.y) + _397.z) + _397.w), _401[_524].y + (((_398.x + _398.y) + _398.z) + _398.w), _401[_524].z + (((_399.x + _399.y) + _399.z) + _399.w), _401[_524].w + (((_400.x + _400.y) + _400.z) + _400.w));
                    _395 = _404 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _394 = _402 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _393;
}

void _935(uint _936, f16vec4 _937)
{
    D.data[_936] = _937.x;
    D.data[_936 + 1u] = _937.y;
    D.data[_936 + 2u] = _937.z;
    D.data[_936 + 3u] = _937.w;
}

f16vec4 _572(uint _573)
{
    return f16vec4(A.data[_573], A.data[_573 + 1u], A.data[_573 + 2u], A.data[_573 + 3u]);
}

f16vec4 _588(uint _589)
{
    return f16vec4(D.data[_589], D.data[_589 + 1u], D.data[_589 + 2u], D.data[_589 + 3u]);
}

f16vec4[4] _606()
{
    uint _617 = 0u;
    f16vec4 _616[4];
    uint _623;
    for (;;)
    {
        _623 = _617;
        if (_623 < 4u)
        {
            f16vec4 _619 = f16vec4(float16_t(0.0));
            f16vec4 _620 = f16vec4(float16_t(0.0));
            f16vec4 _621 = f16vec4(float16_t(0.0));
            f16vec4 _622 = f16vec4(float16_t(0.0));
            uint _618 = 0u;
            uint _625;
            for (;;)
            {
                _625 = _618;
                if (_625 < 4u)
                {
                    uint _627 = _625 * 4u;
                    f16vec4 _628 = _572(_627);
                    uint _629 = _623 * 4u;
                    uint _632 = ((_627 + 0u) * 16u) + _629;
                    f16vec4 _645 = _135(((uint(0) + (_632 / 16u)) * uint(16)) + (uint(0) + (_632 % 16u)));
                    uint _648 = ((_627 + 1u) * 16u) + _629;
                    f16vec4 _661 = _135(((uint(0) + (_648 / 16u)) * uint(16)) + (uint(0) + (_648 % 16u)));
                    uint _664 = ((_627 + 2u) * 16u) + _629;
                    f16vec4 _677 = _135(((uint(0) + (_664 / 16u)) * uint(16)) + (uint(0) + (_664 % 16u)));
                    uint _680 = ((_627 + 3u) * 16u) + _629;
                    f16vec4 _693 = _135(((uint(0) + (_680 / 16u)) * uint(16)) + (uint(0) + (_680 % 16u)));
                    _619 = fma(_628, f16vec4(_645.x, _661.x, _677.x, _693.x), _619);
                    _620 = fma(_628, f16vec4(_645.y, _661.y, _677.y, _693.y), _620);
                    _621 = fma(_628, f16vec4(_645.z, _661.z, _677.z, _693.z), _621);
                    _622 = fma(_628, f16vec4(_645.w, _661.w, _677.w, _693.w), _622);
                    _618 = _625 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _616[_623] = f16vec4(((_619.x + _619.y) + _619.z) + _619.w, ((_620.x + _620.y) + _620.z) + _620.w, ((_621.x + _621.y) + _621.z) + _621.w, ((_622.x + _622.y) + _622.z) + _622.w) + _588(_623 * 4u);
            _617 = _623 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _616;
}

void _977(uint _978, f16vec4 _979)
{
    D.data[_978] = _979.x;
    D.data[_978 + 1u] = _979.y;
    D.data[_978 + 2u] = _979.z;
    D.data[_978 + 3u] = _979.w;
}

f16vec4 _762(uint _763)
{
    return f16vec4(D.data[_763], D.data[_763 + 1u], D.data[_763 + 2u], D.data[_763 + 3u]);
}

f16vec4[4] _778()
{
    uint _789 = 0u;
    f16vec4 _788[4];
    uint _795;
    for (;;)
    {
        _795 = _789;
        if (_795 < 4u)
        {
            f16vec4 _791 = f16vec4(float16_t(0.0));
            f16vec4 _792 = f16vec4(float16_t(0.0));
            f16vec4 _793 = f16vec4(float16_t(0.0));
            f16vec4 _794 = f16vec4(float16_t(0.0));
            uint _790 = 0u;
            uint _797;
            for (;;)
            {
                _797 = _790;
                if (_797 < 4u)
                {
                    uint _799 = _797 * 4u;
                    f16vec4 _800 = _572(_799);
                    uint _801 = _795 * 4u;
                    uint _804 = ((_799 + 0u) * 16u) + _801;
                    f16vec4 _817 = _135(((uint(0) + (_804 / 16u)) * uint(16)) + (uint(0) + (_804 % 16u)));
                    uint _820 = ((_799 + 1u) * 16u) + _801;
                    f16vec4 _833 = _135(((uint(0) + (_820 / 16u)) * uint(16)) + (uint(0) + (_820 % 16u)));
                    uint _836 = ((_799 + 2u) * 16u) + _801;
                    f16vec4 _849 = _135(((uint(0) + (_836 / 16u)) * uint(16)) + (uint(0) + (_836 % 16u)));
                    uint _852 = ((_799 + 3u) * 16u) + _801;
                    f16vec4 _865 = _135(((uint(0) + (_852 / 16u)) * uint(16)) + (uint(0) + (_852 % 16u)));
                    _791 = fma(_800, f16vec4(_817.x, _833.x, _849.x, _865.x), _791);
                    _792 = fma(_800, f16vec4(_817.y, _833.y, _849.y, _865.y), _792);
                    _793 = fma(_800, f16vec4(_817.z, _833.z, _849.z, _865.z), _793);
                    _794 = fma(_800, f16vec4(_817.w, _833.w, _849.w, _865.w), _794);
                    _790 = _797 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _788[_795] = f16vec4(((_791.x + _791.y) + _791.z) + _791.w, ((_792.x + _792.y) + _792.z) + _792.w, ((_793.x + _793.y) + _793.z) + _793.w, ((_794.x + _794.y) + _794.z) + _794.w) + _762(_795 * 4u);
            _789 = _795 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _788;
}

void _1007(uint _1008, f16vec4 _1009)
{
    D.data[_1008] = _1009.x;
    D.data[_1008 + 1u] = _1009.y;
    D.data[_1008 + 2u] = _1009.z;
    D.data[_1008 + 3u] = _1009.w;
}

void main()
{
    f16vec4 _55[64] = _173();
    f16vec4 tempArg[64] = _55;
    f16vec4 d0[64] = _55;
    f16vec4 _62[64] = _378(_55);
    f16vec4 tempArg_1[64] = _62;
    f16vec4 d1[64] = _62;
    f16vec4 _952[64] = _62;
    uint _953 = 0u;
    uint _958;
    for (;;)
    {
        _958 = _953;
        if (_958 < 256u)
        {
            _935(((uint(0) + (_958 / 16u)) * uint(16)) + (uint(0) + (_958 % 16u)), _952[_958 / 4u]);
            _953 = _958 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _89[4] = _606();
    f16vec4 tempArg_2[4] = _89;
    f16vec4 y0[4] = _89;
    f16vec4 _993[4] = _89;
    uint _994 = 0u;
    uint _999;
    for (;;)
    {
        _999 = _994;
        if (_999 < 16u)
        {
            _977(0u + _999, _993[_999 / 4u]);
            _994 = _999 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _102[4] = _778();
    f16vec4 tempArg_3[4] = _102;
    f16vec4 y1[4] = _102;
    f16vec4 _1023[4] = _102;
    uint _1024 = 0u;
    uint _1029;
    for (;;)
    {
        _1029 = _1024;
        if (_1029 < 16u)
        {
            _1007(0u + _1029, _1023[_1029 / 4u]);
            _1024 = _1029 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

