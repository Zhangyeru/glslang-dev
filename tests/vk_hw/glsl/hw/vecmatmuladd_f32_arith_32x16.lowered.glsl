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

vec4 _337(uint _338)
{
    return vec4(Bias.data[_338], Bias.data[_338 + 1u], Bias.data[_338 + 2u], Bias.data[_338 + 3u]);
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

void _702(uint _703, vec4 _704)
{
    Y.data[_703] = _704.x;
    Y.data[_703 + 1u] = _704.y;
    Y.data[_703 + 2u] = _704.z;
    Y.data[_703 + 3u] = _704.w;
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
            _323[_329 / 4u] = _307(0u + _329);
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
    uint _354 = 0u;
    vec4 _353[4];
    uint _359;
    for (;;)
    {
        _359 = _354;
        if (_359 < 16u)
        {
            _353[_359 / 4u] = _337(0u + _359);
            _354 = _359 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _51[4] = _353;
    vec4 tempArg_1[4] = _51;
    vec4 bias[4] = _51;
    vec4 _370[8] = _21;
    uint _369 = 0u;
    vec4 _368[8];
    uint _375;
    for (;;)
    {
        _375 = _369;
        if (_375 < 8u)
        {
            _368[_375] = -_370[_375];
            _369 = _375 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _384[8] = _368;
    uint _383 = 0u;
    vec4 _382[8];
    uint _389;
    for (;;)
    {
        _389 = _383;
        if (_389 < 8u)
        {
            _382[_389] = -_384[_389];
            _383 = _389 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _382;
    vec4 _398[8] = _382;
    uint _397 = 0u;
    vec4 _396[8];
    uint _404;
    for (;;)
    {
        _404 = _397;
        if (_404 < 8u)
        {
            _396[_404] = _398[_404] + _59[_404];
            _397 = _404 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _415[8] = _396;
    uint _414 = 0u;
    vec4 _413[8];
    uint _421;
    for (;;)
    {
        _421 = _414;
        if (_421 < 8u)
        {
            _413[_421] = _415[_421] - _59[_421];
            _414 = _421 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _413;
    vec4 _432[8] = _413;
    uint _431 = 0u;
    vec4 _430[8];
    uint _438;
    for (;;)
    {
        _438 = _431;
        if (_438 < 8u)
        {
            _430[_438] = _432[_438] * _64[_438];
            _431 = _438 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _449[8] = _430;
    uint _448 = 0u;
    vec4 _447[8];
    uint _455;
    for (;;)
    {
        _455 = _448;
        if (_455 < 8u)
        {
            _447[_455] = _449[_455] / _64[_455];
            _448 = _455 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _447;
    vec4 _466[8] = _447;
    uint _465 = 0u;
    vec4 _464[8];
    uint _471;
    for (;;)
    {
        _471 = _465;
        if (_471 < 8u)
        {
            _464[_471] = _466[_471] * vec4(1.0);
            _465 = _471 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _464;
    vec4 _481[4] = _51;
    uint _480 = 0u;
    vec4 _479[4];
    uint _486;
    for (;;)
    {
        _486 = _480;
        if (_486 < 4u)
        {
            _479[_486] = -_481[_486];
            _480 = _486 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _495[4] = _479;
    uint _494 = 0u;
    vec4 _493[4];
    uint _500;
    for (;;)
    {
        _500 = _494;
        if (_500 < 4u)
        {
            _493[_500] = -_495[_500];
            _494 = _500 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _493;
    vec4 _509[4] = _493;
    uint _508 = 0u;
    vec4 _507[4];
    uint _515;
    for (;;)
    {
        _515 = _508;
        if (_515 < 4u)
        {
            _507[_515] = _509[_515] + _73[_515];
            _508 = _515 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _526[4] = _507;
    uint _525 = 0u;
    vec4 _524[4];
    uint _532;
    for (;;)
    {
        _532 = _525;
        if (_532 < 4u)
        {
            _524[_532] = _526[_532] - _73[_532];
            _525 = _532 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _524;
    vec4 _543[4] = _524;
    uint _542 = 0u;
    vec4 _541[4];
    uint _549;
    for (;;)
    {
        _549 = _542;
        if (_549 < 4u)
        {
            _541[_549] = _543[_549] * _77[_549];
            _542 = _549 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _560[4] = _541;
    uint _559 = 0u;
    vec4 _558[4];
    uint _566;
    for (;;)
    {
        _566 = _559;
        if (_566 < 4u)
        {
            _558[_566] = _560[_566] / _77[_566];
            _559 = _566 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _558;
    vec4 _577[4] = _558;
    uint _576 = 0u;
    vec4 _575[4];
    uint _582;
    for (;;)
    {
        _582 = _576;
        if (_582 < 4u)
        {
            _575[_582] = _577[_582] * vec4(1.0);
            _576 = _582 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _575;
    vec4 _86[4] = _143(_464, _575);
    vec4 tempArg_2[4] = _86;
    vec4 y[4] = _86;
    vec4 _592[4] = _86;
    uint _591 = 0u;
    vec4 _590[4];
    uint _597;
    for (;;)
    {
        _597 = _591;
        if (_597 < 4u)
        {
            _590[_597] = -_592[_597];
            _591 = _597 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _606[4] = _590;
    uint _605 = 0u;
    vec4 _604[4];
    uint _611;
    for (;;)
    {
        _611 = _605;
        if (_611 < 4u)
        {
            _604[_611] = -_606[_611];
            _605 = _611 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _604;
    vec4 _620[4] = _604;
    uint _619 = 0u;
    vec4 _618[4];
    uint _626;
    for (;;)
    {
        _626 = _619;
        if (_626 < 4u)
        {
            _618[_626] = _620[_626] + _73[_626];
            _619 = _626 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _637[4] = _618;
    uint _636 = 0u;
    vec4 _635[4];
    uint _643;
    for (;;)
    {
        _643 = _636;
        if (_643 < 4u)
        {
            _635[_643] = _637[_643] - _73[_643];
            _636 = _643 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _635;
    vec4 _654[4] = _635;
    uint _653 = 0u;
    vec4 _652[4];
    uint _660;
    for (;;)
    {
        _660 = _653;
        if (_660 < 4u)
        {
            _652[_660] = _654[_660] * _77[_660];
            _653 = _660 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _671[4] = _652;
    uint _670 = 0u;
    vec4 _669[4];
    uint _677;
    for (;;)
    {
        _677 = _670;
        if (_677 < 4u)
        {
            _669[_677] = _671[_677] / _77[_677];
            _670 = _677 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _669;
    vec4 _688[4] = _669;
    uint _687 = 0u;
    vec4 _686[4];
    uint _693;
    for (;;)
    {
        _693 = _687;
        if (_693 < 4u)
        {
            _686[_693] = _688[_693] * vec4(1.0);
            _687 = _693 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _686;
    vec4 _718[4] = _686;
    uint _719 = 0u;
    uint _724;
    for (;;)
    {
        _724 = _719;
        if (_724 < 16u)
        {
            _702(0u + _724, _718[_724 / 4u]);
            _719 = _724 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

