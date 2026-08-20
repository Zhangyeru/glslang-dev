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

f16vec2 _116(uint _117)
{
    return f16vec2(A.data[_117], A.data[_117 + 1u]);
}

f16vec2 _127(uint _128)
{
    return f16vec2(B.data[_128], B.data[_128 + 1u]);
}

f16vec2 _137(uint _138)
{
    return f16vec2(C.data[_138], C.data[_138 + 1u]);
}

f16vec2[128] _154()
{
    uint _169 = 0u;
    f16vec2 _168[128];
    uint _174;
    for (;;)
    {
        _174 = _169;
        if (_174 < 16u)
        {
            uint _170 = 0u;
            uint _176;
            for (;;)
            {
                _176 = _170;
                if (_176 < 8u)
                {
                    f16vec2 _172 = f16vec2(float16_t(0.0));
                    f16vec2 _173 = f16vec2(float16_t(0.0));
                    uint _171 = 0u;
                    uint _178;
                    for (;;)
                    {
                        _178 = _171;
                        if (_178 < 8u)
                        {
                            uint _180 = _178 * 2u;
                            uint _182 = (_174 * 16u) + _180;
                            f16vec2 _195 = _116(((uint(0) + (_182 / 16u)) * uint(16)) + (uint(0) + (_182 % 16u)));
                            uint _199 = ((_180 + 0u) * 16u) + (_176 * 2u);
                            f16vec2 _212 = _127(((uint(0) + (_199 / 16u)) * uint(16)) + (uint(0) + (_199 % 16u)));
                            uint _216 = ((_180 + 1u) * 16u) + (_176 * 2u);
                            f16vec2 _229 = _127(((uint(0) + (_216 / 16u)) * uint(16)) + (uint(0) + (_216 % 16u)));
                            _172 = fma(_195, f16vec2(_212.x, _229.x), _172);
                            _173 = fma(_195, f16vec2(_212.y, _229.y), _173);
                            _171 = _178 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _245 = (_174 * 16u) + (_176 * 2u);
                    f16vec2 _258 = _137(((uint(0) + (_245 / 16u)) * uint(16)) + (uint(0) + (_245 % 16u)));
                    _168[(_174 * 8u) + _176] = f16vec2(_258.x + (_172.x + _172.y), _258.y + (_173.x + _173.y));
                    _170 = _176 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _169 = _174 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _168;
}

f16vec2[128] _277(f16vec2 _278[128])
{
    f16vec2 _298[128] = _278;
    uint _293 = 0u;
    f16vec2 _292[128];
    uint _299;
    for (;;)
    {
        _299 = _293;
        if (_299 < 16u)
        {
            uint _294 = 0u;
            uint _301;
            for (;;)
            {
                _301 = _294;
                if (_301 < 8u)
                {
                    f16vec2 _296 = f16vec2(float16_t(0.0));
                    f16vec2 _297 = f16vec2(float16_t(0.0));
                    uint _295 = 0u;
                    uint _303;
                    for (;;)
                    {
                        _303 = _295;
                        if (_303 < 8u)
                        {
                            uint _305 = _303 * 2u;
                            uint _307 = (_299 * 16u) + _305;
                            f16vec2 _320 = _116(((uint(0) + (_307 / 16u)) * uint(16)) + (uint(0) + (_307 % 16u)));
                            uint _324 = ((_305 + 0u) * 16u) + (_301 * 2u);
                            f16vec2 _337 = _127(((uint(0) + (_324 / 16u)) * uint(16)) + (uint(0) + (_324 % 16u)));
                            uint _341 = ((_305 + 1u) * 16u) + (_301 * 2u);
                            f16vec2 _354 = _127(((uint(0) + (_341 / 16u)) * uint(16)) + (uint(0) + (_341 % 16u)));
                            _296 = fma(_320, f16vec2(_337.x, _354.x), _296);
                            _297 = fma(_320, f16vec2(_337.y, _354.y), _297);
                            _295 = _303 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _369 = (_299 * 8u) + _301;
                    _292[(_299 * 8u) + _301] = f16vec2(_298[_369].x + (_296.x + _296.y), _298[_369].y + (_297.x + _297.y));
                    _294 = _301 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _293 = _299 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _292;
}

void _590(uint _591, f16vec2 _592)
{
    D.data[_591] = _592.x;
    D.data[_591 + 1u] = _592.y;
}

f16vec2 _392(uint _393)
{
    return f16vec2(A.data[_393], A.data[_393 + 1u]);
}

f16vec2 _402(uint _403)
{
    return f16vec2(D.data[_403], D.data[_403 + 1u]);
}

f16vec2[8] _413()
{
    uint _425 = 0u;
    f16vec2 _424[8];
    uint _432;
    for (;;)
    {
        _432 = _425;
        if (_432 < 8u)
        {
            f16vec2 _427 = f16vec2(float16_t(0.0));
            f16vec2 _428 = f16vec2(float16_t(0.0));
            uint _426 = 0u;
            uint _434;
            for (;;)
            {
                _434 = _426;
                if (_434 < 8u)
                {
                    uint _436 = _434 * 2u;
                    uint _437 = _432 * 2u;
                    f16vec2 _438 = _392(_436);
                    uint _440 = (_436 * 16u) + _437;
                    f16vec2 _453 = _127(((uint(0) + (_440 / 16u)) * uint(16)) + (uint(0) + (_440 % 16u)));
                    uint _456 = ((_436 + 1u) * 16u) + _437;
                    f16vec2 _469 = _127(((uint(0) + (_456 / 16u)) * uint(16)) + (uint(0) + (_456 % 16u)));
                    _427 = fma(_438, f16vec2(_453.x, _469.x), _427);
                    _428 = fma(_438, f16vec2(_453.y, _469.y), _428);
                    _426 = _434 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _424[_432] = f16vec2(_427.x + _427.y, _428.x + _428.y) + _402(_432 * 2u);
            _425 = _432 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _424;
}

void _626(uint _627, f16vec2 _628)
{
    D.data[_627] = _628.x;
    D.data[_627 + 1u] = _628.y;
}

f16vec2 _496(uint _497)
{
    return f16vec2(D.data[_497], D.data[_497 + 1u]);
}

f16vec2[8] _506()
{
    uint _518 = 0u;
    f16vec2 _517[8];
    uint _525;
    for (;;)
    {
        _525 = _518;
        if (_525 < 8u)
        {
            f16vec2 _520 = f16vec2(float16_t(0.0));
            f16vec2 _521 = f16vec2(float16_t(0.0));
            uint _519 = 0u;
            uint _527;
            for (;;)
            {
                _527 = _519;
                if (_527 < 8u)
                {
                    uint _529 = _527 * 2u;
                    uint _530 = _525 * 2u;
                    f16vec2 _531 = _392(_529);
                    uint _533 = (_529 * 16u) + _530;
                    f16vec2 _546 = _127(((uint(0) + (_533 / 16u)) * uint(16)) + (uint(0) + (_533 % 16u)));
                    uint _549 = ((_529 + 1u) * 16u) + _530;
                    f16vec2 _562 = _127(((uint(0) + (_549 / 16u)) * uint(16)) + (uint(0) + (_549 % 16u)));
                    _520 = fma(_531, f16vec2(_546.x, _562.x), _520);
                    _521 = fma(_531, f16vec2(_546.y, _562.y), _521);
                    _519 = _527 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _517[_525] = f16vec2(_520.x + _520.y, _521.x + _521.y) + _496(_525 * 2u);
            _518 = _525 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _517;
}

void _650(uint _651, f16vec2 _652)
{
    D.data[_651] = _652.x;
    D.data[_651 + 1u] = _652.y;
}

void main()
{
    f16vec2 _55[128] = _154();
    f16vec2 tempArg[128] = _55;
    f16vec2 d0[128] = _55;
    f16vec2 _62[128] = _277(_55);
    f16vec2 tempArg_1[128] = _62;
    f16vec2 d1[128] = _62;
    f16vec2 _601[128] = _62;
    uint _602 = 0u;
    uint _607;
    for (;;)
    {
        _607 = _602;
        if (_607 < 256u)
        {
            _590(((uint(0) + (_607 / 16u)) * uint(16)) + (uint(0) + (_607 % 16u)), _601[_607 / 2u]);
            _602 = _607 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _89[8] = _413();
    f16vec2 tempArg_2[8] = _89;
    f16vec2 y0[8] = _89;
    f16vec2 _636[8] = _89;
    uint _637 = 0u;
    uint _642;
    for (;;)
    {
        _642 = _637;
        if (_642 < 16u)
        {
            _626(0u + _642, _636[_642 / 2u]);
            _637 = _642 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _102[8] = _506();
    f16vec2 tempArg_3[8] = _102;
    f16vec2 y1[8] = _102;
    f16vec2 _660[8] = _102;
    uint _661 = 0u;
    uint _666;
    for (;;)
    {
        _666 = _661;
        if (_666 < 16u)
        {
            _650(0u + _666, _660[_666 / 2u]);
            _661 = _666 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

