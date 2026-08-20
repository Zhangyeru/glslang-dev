#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec2 _59[16] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
const vec2 _64[16] = vec2[](vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0));
const vec2 _73[8] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
const vec2 _77[8] = vec2[](vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0));

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

vec2 _227(uint _228)
{
    return vec2(X.data[_228], X.data[_228 + 1u]);
}

vec2 _251(uint _252)
{
    return vec2(Bias.data[_252], Bias.data[_252 + 1u]);
}

vec2 _125(uint _126)
{
    return vec2(W.data[_126], W.data[_126 + 1u]);
}

vec2[8] _137(vec2 _138[16], vec2 _139[8])
{
    vec2 _156[16] = _138;
    vec2 _157[8] = _139;
    uint _152 = 0u;
    vec2 _151[8];
    uint _159;
    for (;;)
    {
        _159 = _152;
        if (_159 < 8u)
        {
            vec2 _154 = vec2(0.0);
            vec2 _155 = vec2(0.0);
            uint _153 = 0u;
            uint _161;
            for (;;)
            {
                _161 = _153;
                if (_161 < 16u)
                {
                    uint _163 = _161 * 2u;
                    uint _164 = _159 * 2u;
                    uint _168 = (_163 * 16u) + _164;
                    vec2 _181 = _125(((uint(0) + (_168 / 16u)) * uint(16)) + (uint(0) + (_168 % 16u)));
                    uint _184 = ((_163 + 1u) * 16u) + _164;
                    vec2 _197 = _125(((uint(0) + (_184 / 16u)) * uint(16)) + (uint(0) + (_184 % 16u)));
                    _154 = fma(_156[_161], vec2(_181.x, _197.x), _154);
                    _155 = fma(_156[_161], vec2(_181.y, _197.y), _155);
                    _153 = _161 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _151[_159] = vec2(_154.x + _154.y, _155.x + _155.y) + _157[_159];
            _152 = _159 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _151;
}

void _609(uint _610, vec2 _611)
{
    Y.data[_610] = _611.x;
    Y.data[_610 + 1u] = _611.y;
}

void main()
{
    uint _238 = 0u;
    vec2 _237[16];
    uint _243;
    for (;;)
    {
        _243 = _238;
        if (_243 < 32u)
        {
            _237[_243 / 2u] = _227(0u + _243);
            _238 = _243 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _21[16] = _237;
    vec2 tempArg[16] = _21;
    vec2 x[16] = _21;
    uint _262 = 0u;
    vec2 _261[8];
    uint _267;
    for (;;)
    {
        _267 = _262;
        if (_267 < 16u)
        {
            _261[_267 / 2u] = _251(0u + _267);
            _262 = _267 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _51[8] = _261;
    vec2 tempArg_1[8] = _51;
    vec2 bias[8] = _51;
    vec2 _277[16] = _21;
    uint _276 = 0u;
    vec2 _275[16];
    uint _282;
    for (;;)
    {
        _282 = _276;
        if (_282 < 16u)
        {
            _275[_282] = -_277[_282];
            _276 = _282 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _291[16] = _275;
    uint _290 = 0u;
    vec2 _289[16];
    uint _296;
    for (;;)
    {
        _296 = _290;
        if (_296 < 16u)
        {
            _289[_296] = -_291[_296];
            _290 = _296 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _289;
    vec2 _305[16] = _289;
    uint _304 = 0u;
    vec2 _303[16];
    uint _311;
    for (;;)
    {
        _311 = _304;
        if (_311 < 16u)
        {
            _303[_311] = _305[_311] + _59[_311];
            _304 = _311 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _322[16] = _303;
    uint _321 = 0u;
    vec2 _320[16];
    uint _328;
    for (;;)
    {
        _328 = _321;
        if (_328 < 16u)
        {
            _320[_328] = _322[_328] - _59[_328];
            _321 = _328 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _320;
    vec2 _339[16] = _320;
    uint _338 = 0u;
    vec2 _337[16];
    uint _345;
    for (;;)
    {
        _345 = _338;
        if (_345 < 16u)
        {
            _337[_345] = _339[_345] * _64[_345];
            _338 = _345 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _356[16] = _337;
    uint _355 = 0u;
    vec2 _354[16];
    uint _362;
    for (;;)
    {
        _362 = _355;
        if (_362 < 16u)
        {
            _354[_362] = _356[_362] / _64[_362];
            _355 = _362 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _354;
    vec2 _373[16] = _354;
    uint _372 = 0u;
    vec2 _371[16];
    uint _378;
    for (;;)
    {
        _378 = _372;
        if (_378 < 16u)
        {
            _371[_378] = _373[_378] * vec2(1.0);
            _372 = _378 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _371;
    vec2 _388[8] = _51;
    uint _387 = 0u;
    vec2 _386[8];
    uint _393;
    for (;;)
    {
        _393 = _387;
        if (_393 < 8u)
        {
            _386[_393] = -_388[_393];
            _387 = _393 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _402[8] = _386;
    uint _401 = 0u;
    vec2 _400[8];
    uint _407;
    for (;;)
    {
        _407 = _401;
        if (_407 < 8u)
        {
            _400[_407] = -_402[_407];
            _401 = _407 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _400;
    vec2 _416[8] = _400;
    uint _415 = 0u;
    vec2 _414[8];
    uint _422;
    for (;;)
    {
        _422 = _415;
        if (_422 < 8u)
        {
            _414[_422] = _416[_422] + _73[_422];
            _415 = _422 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _433[8] = _414;
    uint _432 = 0u;
    vec2 _431[8];
    uint _439;
    for (;;)
    {
        _439 = _432;
        if (_439 < 8u)
        {
            _431[_439] = _433[_439] - _73[_439];
            _432 = _439 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _431;
    vec2 _450[8] = _431;
    uint _449 = 0u;
    vec2 _448[8];
    uint _456;
    for (;;)
    {
        _456 = _449;
        if (_456 < 8u)
        {
            _448[_456] = _450[_456] * _77[_456];
            _449 = _456 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _467[8] = _448;
    uint _466 = 0u;
    vec2 _465[8];
    uint _473;
    for (;;)
    {
        _473 = _466;
        if (_473 < 8u)
        {
            _465[_473] = _467[_473] / _77[_473];
            _466 = _473 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _465;
    vec2 _484[8] = _465;
    uint _483 = 0u;
    vec2 _482[8];
    uint _489;
    for (;;)
    {
        _489 = _483;
        if (_489 < 8u)
        {
            _482[_489] = _484[_489] * vec2(1.0);
            _483 = _489 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _482;
    vec2 _86[8] = _137(_371, _482);
    vec2 tempArg_2[8] = _86;
    vec2 y[8] = _86;
    vec2 _499[8] = _86;
    uint _498 = 0u;
    vec2 _497[8];
    uint _504;
    for (;;)
    {
        _504 = _498;
        if (_504 < 8u)
        {
            _497[_504] = -_499[_504];
            _498 = _504 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _513[8] = _497;
    uint _512 = 0u;
    vec2 _511[8];
    uint _518;
    for (;;)
    {
        _518 = _512;
        if (_518 < 8u)
        {
            _511[_518] = -_513[_518];
            _512 = _518 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _511;
    vec2 _527[8] = _511;
    uint _526 = 0u;
    vec2 _525[8];
    uint _533;
    for (;;)
    {
        _533 = _526;
        if (_533 < 8u)
        {
            _525[_533] = _527[_533] + _73[_533];
            _526 = _533 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _544[8] = _525;
    uint _543 = 0u;
    vec2 _542[8];
    uint _550;
    for (;;)
    {
        _550 = _543;
        if (_550 < 8u)
        {
            _542[_550] = _544[_550] - _73[_550];
            _543 = _550 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _542;
    vec2 _561[8] = _542;
    uint _560 = 0u;
    vec2 _559[8];
    uint _567;
    for (;;)
    {
        _567 = _560;
        if (_567 < 8u)
        {
            _559[_567] = _561[_567] * _77[_567];
            _560 = _567 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _578[8] = _559;
    uint _577 = 0u;
    vec2 _576[8];
    uint _584;
    for (;;)
    {
        _584 = _577;
        if (_584 < 8u)
        {
            _576[_584] = _578[_584] / _77[_584];
            _577 = _584 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _576;
    vec2 _595[8] = _576;
    uint _594 = 0u;
    vec2 _593[8];
    uint _600;
    for (;;)
    {
        _600 = _594;
        if (_600 < 8u)
        {
            _593[_600] = _595[_600] * vec2(1.0);
            _594 = _600 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _593;
    vec2 _619[8] = _593;
    uint _620 = 0u;
    uint _625;
    for (;;)
    {
        _625 = _620;
        if (_625 < 16u)
        {
            _609(0u + _625, _619[_625 / 2u]);
            _620 = _625 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

