#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec4 _59[8] = vec4[](vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0));
const vec4 _64[8] = vec4[](vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0));
const vec4 _73[4] = vec4[](vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0));
const vec4 _77[4] = vec4[](vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0));

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float data[];
} W;

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float data[];
} Bias;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

vec4 _307(uint _308)
{
    return vec4(X.data[_308], X.data[_308 + 1u], X.data[_308 + 2u], X.data[_308 + 3u]);
}

vec4 _336(uint _337)
{
    return vec4(Bias.data[_337], Bias.data[_337 + 1u], Bias.data[_337 + 2u], Bias.data[_337 + 3u]);
}

vec4 _118(uint _119)
{
    return vec4(W.data[_119], W.data[_119 + 1u], W.data[_119 + 2u], W.data[_119 + 3u]);
}

vec4[4] _143(vec4 _144[8], vec4 _145[4])
{
    vec4 _163[8] = _144;
    vec4 _164[4] = _145;
    uint _156 = 0u;
    vec4 _155[4];
    uint _165;
    for (;;)
    {
        _165 = _156;
        if (_165 < 4u)
        {
            vec4 _158 = vec4(0.0);
            vec4 _159 = vec4(0.0);
            vec4 _160 = vec4(0.0);
            vec4 _161 = vec4(0.0);
            uint _157 = 0u;
            uint _167;
            for (;;)
            {
                _167 = _157;
                if (_167 < 8u)
                {
                    uint _169 = _167 * 4u;
                    uint _172 = _165 * 4u;
                    uint _175 = ((_169 + 0u) * 16u) + _172;
                    vec4 _188 = _118(((uint(0) + (_175 / 16u)) * uint(16)) + (uint(0) + (_175 % 16u)));
                    uint _191 = ((_169 + 1u) * 16u) + _172;
                    vec4 _204 = _118(((uint(0) + (_191 / 16u)) * uint(16)) + (uint(0) + (_191 % 16u)));
                    uint _207 = ((_169 + 2u) * 16u) + _172;
                    vec4 _220 = _118(((uint(0) + (_207 / 16u)) * uint(16)) + (uint(0) + (_207 % 16u)));
                    uint _223 = ((_169 + 3u) * 16u) + _172;
                    vec4 _236 = _118(((uint(0) + (_223 / 16u)) * uint(16)) + (uint(0) + (_223 % 16u)));
                    _158 = fma(_163[_167], vec4(_188.x, _204.x, _220.x, _236.x), _158);
                    _159 = fma(_163[_167], vec4(_188.y, _204.y, _220.y, _236.y), _159);
                    _160 = fma(_163[_167], vec4(_188.z, _204.z, _220.z, _236.z), _160);
                    _161 = fma(_163[_167], vec4(_188.w, _204.w, _220.w, _236.w), _161);
                    _157 = _167 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _155[_165] = vec4(((_158.x + _158.y) + _158.z) + _158.w, ((_159.x + _159.y) + _159.z) + _159.w, ((_160.x + _160.y) + _160.z) + _160.w, ((_161.x + _161.y) + _161.z) + _161.w) + _164[_165];
            _156 = _165 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _155;
}

void _700(uint _701, vec4 _702)
{
    Y.data[_701] = _702.x;
    Y.data[_701 + 1u] = _702.y;
    Y.data[_701 + 2u] = _702.z;
    Y.data[_701 + 3u] = _702.w;
}

void main()
{
    uint _324 = 0u;
    vec4 _323[8];
    uint _329;
    for (;;)
    {
        _329 = _324;
        if (_329 < 32u)
        {
            _323[_329 / 4u] = _307(_329);
            _324 = _329 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _21[8] = _323;
    vec4 tempArg[8] = _21;
    vec4 x[8] = _21;
    uint _353 = 0u;
    vec4 _352[4];
    uint _358;
    for (;;)
    {
        _358 = _353;
        if (_358 < 16u)
        {
            _352[_358 / 4u] = _336(_358);
            _353 = _358 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _51[4] = _352;
    vec4 tempArg_1[4] = _51;
    vec4 bias[4] = _51;
    vec4 _368[8] = _21;
    uint _367 = 0u;
    vec4 _366[8];
    uint _373;
    for (;;)
    {
        _373 = _367;
        if (_373 < 8u)
        {
            _366[_373] = -_368[_373];
            _367 = _373 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _382[8] = _366;
    uint _381 = 0u;
    vec4 _380[8];
    uint _387;
    for (;;)
    {
        _387 = _381;
        if (_387 < 8u)
        {
            _380[_387] = -_382[_387];
            _381 = _387 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _380;
    vec4 _396[8] = _380;
    uint _395 = 0u;
    vec4 _394[8];
    uint _402;
    for (;;)
    {
        _402 = _395;
        if (_402 < 8u)
        {
            _394[_402] = _396[_402] + _59[_402];
            _395 = _402 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _413[8] = _394;
    uint _412 = 0u;
    vec4 _411[8];
    uint _419;
    for (;;)
    {
        _419 = _412;
        if (_419 < 8u)
        {
            _411[_419] = _413[_419] - _59[_419];
            _412 = _419 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _411;
    vec4 _430[8] = _411;
    uint _429 = 0u;
    vec4 _428[8];
    uint _436;
    for (;;)
    {
        _436 = _429;
        if (_436 < 8u)
        {
            _428[_436] = _430[_436] * _64[_436];
            _429 = _436 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _447[8] = _428;
    uint _446 = 0u;
    vec4 _445[8];
    uint _453;
    for (;;)
    {
        _453 = _446;
        if (_453 < 8u)
        {
            _445[_453] = _447[_453] / _64[_453];
            _446 = _453 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _445;
    vec4 _464[8] = _445;
    uint _463 = 0u;
    vec4 _462[8];
    uint _469;
    for (;;)
    {
        _469 = _463;
        if (_469 < 8u)
        {
            _462[_469] = _464[_469] * vec4(1.0);
            _463 = _469 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _462;
    vec4 _479[4] = _51;
    uint _478 = 0u;
    vec4 _477[4];
    uint _484;
    for (;;)
    {
        _484 = _478;
        if (_484 < 4u)
        {
            _477[_484] = -_479[_484];
            _478 = _484 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _493[4] = _477;
    uint _492 = 0u;
    vec4 _491[4];
    uint _498;
    for (;;)
    {
        _498 = _492;
        if (_498 < 4u)
        {
            _491[_498] = -_493[_498];
            _492 = _498 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _491;
    vec4 _507[4] = _491;
    uint _506 = 0u;
    vec4 _505[4];
    uint _513;
    for (;;)
    {
        _513 = _506;
        if (_513 < 4u)
        {
            _505[_513] = _507[_513] + _73[_513];
            _506 = _513 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _524[4] = _505;
    uint _523 = 0u;
    vec4 _522[4];
    uint _530;
    for (;;)
    {
        _530 = _523;
        if (_530 < 4u)
        {
            _522[_530] = _524[_530] - _73[_530];
            _523 = _530 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _522;
    vec4 _541[4] = _522;
    uint _540 = 0u;
    vec4 _539[4];
    uint _547;
    for (;;)
    {
        _547 = _540;
        if (_547 < 4u)
        {
            _539[_547] = _541[_547] * _77[_547];
            _540 = _547 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _558[4] = _539;
    uint _557 = 0u;
    vec4 _556[4];
    uint _564;
    for (;;)
    {
        _564 = _557;
        if (_564 < 4u)
        {
            _556[_564] = _558[_564] / _77[_564];
            _557 = _564 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _556;
    vec4 _575[4] = _556;
    uint _574 = 0u;
    vec4 _573[4];
    uint _580;
    for (;;)
    {
        _580 = _574;
        if (_580 < 4u)
        {
            _573[_580] = _575[_580] * vec4(1.0);
            _574 = _580 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _573;
    vec4 _86[4] = _143(_462, _573);
    vec4 tempArg_2[4] = _86;
    vec4 y[4] = _86;
    vec4 _590[4] = _86;
    uint _589 = 0u;
    vec4 _588[4];
    uint _595;
    for (;;)
    {
        _595 = _589;
        if (_595 < 4u)
        {
            _588[_595] = -_590[_595];
            _589 = _595 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _604[4] = _588;
    uint _603 = 0u;
    vec4 _602[4];
    uint _609;
    for (;;)
    {
        _609 = _603;
        if (_609 < 4u)
        {
            _602[_609] = -_604[_609];
            _603 = _609 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _602;
    vec4 _618[4] = _602;
    uint _617 = 0u;
    vec4 _616[4];
    uint _624;
    for (;;)
    {
        _624 = _617;
        if (_624 < 4u)
        {
            _616[_624] = _618[_624] + _73[_624];
            _617 = _624 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _635[4] = _616;
    uint _634 = 0u;
    vec4 _633[4];
    uint _641;
    for (;;)
    {
        _641 = _634;
        if (_641 < 4u)
        {
            _633[_641] = _635[_641] - _73[_641];
            _634 = _641 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _633;
    vec4 _652[4] = _633;
    uint _651 = 0u;
    vec4 _650[4];
    uint _658;
    for (;;)
    {
        _658 = _651;
        if (_658 < 4u)
        {
            _650[_658] = _652[_658] * _77[_658];
            _651 = _658 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _669[4] = _650;
    uint _668 = 0u;
    vec4 _667[4];
    uint _675;
    for (;;)
    {
        _675 = _668;
        if (_675 < 4u)
        {
            _667[_675] = _669[_675] / _77[_675];
            _668 = _675 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _667;
    vec4 _686[4] = _667;
    uint _685 = 0u;
    vec4 _684[4];
    uint _691;
    for (;;)
    {
        _691 = _685;
        if (_691 < 4u)
        {
            _684[_691] = _686[_691] * vec4(1.0);
            _685 = _691 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _684;
    vec4 _716[4] = _684;
    uint _717 = 0u;
    uint _722;
    for (;;)
    {
        _722 = _717;
        if (_722 < 16u)
        {
            _700(_722, _716[_722 / 4u]);
            _717 = _722 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

