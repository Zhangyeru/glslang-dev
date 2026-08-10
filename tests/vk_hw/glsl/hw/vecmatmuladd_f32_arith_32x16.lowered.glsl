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

vec4 _310(uint _311)
{
    return vec4(X.data[_311], X.data[_311 + 1u], X.data[_311 + 2u], X.data[_311 + 3u]);
}

vec4 _340(uint _341)
{
    return vec4(Bias.data[_341], Bias.data[_341 + 1u], Bias.data[_341 + 2u], Bias.data[_341 + 3u]);
}

vec4 _124(uint _125)
{
    return vec4(W.data[_125], W.data[_125 + 1u], W.data[_125 + 2u], W.data[_125 + 3u]);
}

vec4[4] _144(vec4 _145[8], vec4 _146[4])
{
    vec4 _165[8] = _145;
    vec4 _166[4] = _146;
    uint _159 = 0u;
    vec4 _158[4];
    uint _168;
    for (;;)
    {
        _168 = _159;
        if (_168 < 4u)
        {
            vec4 _161 = vec4(0.0);
            vec4 _162 = vec4(0.0);
            vec4 _163 = vec4(0.0);
            vec4 _164 = vec4(0.0);
            uint _160 = 0u;
            uint _170;
            for (;;)
            {
                _170 = _160;
                if (_170 < 8u)
                {
                    uint _172 = _170 * 4u;
                    uint _173 = _168 * 4u;
                    uint _177 = (_172 * 16u) + _173;
                    vec4 _190 = _124(((uint(0) + (_177 / 16u)) * uint(16)) + (uint(0) + (_177 % 16u)));
                    uint _193 = ((_172 + 1u) * 16u) + _173;
                    vec4 _206 = _124(((uint(0) + (_193 / 16u)) * uint(16)) + (uint(0) + (_193 % 16u)));
                    uint _209 = ((_172 + 2u) * 16u) + _173;
                    vec4 _222 = _124(((uint(0) + (_209 / 16u)) * uint(16)) + (uint(0) + (_209 % 16u)));
                    uint _225 = ((_172 + 3u) * 16u) + _173;
                    vec4 _238 = _124(((uint(0) + (_225 / 16u)) * uint(16)) + (uint(0) + (_225 % 16u)));
                    _161 = fma(_165[_170], vec4(_190.x, _206.x, _222.x, _238.x), _161);
                    _162 = fma(_165[_170], vec4(_190.y, _206.y, _222.y, _238.y), _162);
                    _163 = fma(_165[_170], vec4(_190.z, _206.z, _222.z, _238.z), _163);
                    _164 = fma(_165[_170], vec4(_190.w, _206.w, _222.w, _238.w), _164);
                    _160 = _170 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _158[_168] = vec4(((_161.x + _161.y) + _161.z) + _161.w, ((_162.x + _162.y) + _162.z) + _162.w, ((_163.x + _163.y) + _163.z) + _163.w, ((_164.x + _164.y) + _164.z) + _164.w) + _166[_168];
            _159 = _168 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _158;
}

void _704(uint _705, vec4 _706)
{
    Y.data[_705] = _706.x;
    Y.data[_705 + 1u] = _706.y;
    Y.data[_705 + 2u] = _706.z;
    Y.data[_705 + 3u] = _706.w;
}

void main()
{
    uint _327 = 0u;
    vec4 _326[8];
    uint _332;
    for (;;)
    {
        _332 = _327;
        if (_332 < 32u)
        {
            _326[_332 / 4u] = _310(0u + _332);
            _327 = _332 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _21[8] = _326;
    vec4 tempArg[8] = _21;
    vec4 x[8] = _21;
    uint _357 = 0u;
    vec4 _356[4];
    uint _362;
    for (;;)
    {
        _362 = _357;
        if (_362 < 16u)
        {
            _356[_362 / 4u] = _340(0u + _362);
            _357 = _362 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _51[4] = _356;
    vec4 tempArg_1[4] = _51;
    vec4 bias[4] = _51;
    vec4 _372[8] = _21;
    uint _371 = 0u;
    vec4 _370[8];
    uint _377;
    for (;;)
    {
        _377 = _371;
        if (_377 < 8u)
        {
            _370[_377] = -_372[_377];
            _371 = _377 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _386[8] = _370;
    uint _385 = 0u;
    vec4 _384[8];
    uint _391;
    for (;;)
    {
        _391 = _385;
        if (_391 < 8u)
        {
            _384[_391] = -_386[_391];
            _385 = _391 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _384;
    vec4 _400[8] = _384;
    uint _399 = 0u;
    vec4 _398[8];
    uint _406;
    for (;;)
    {
        _406 = _399;
        if (_406 < 8u)
        {
            _398[_406] = _400[_406] + _59[_406];
            _399 = _406 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _417[8] = _398;
    uint _416 = 0u;
    vec4 _415[8];
    uint _423;
    for (;;)
    {
        _423 = _416;
        if (_423 < 8u)
        {
            _415[_423] = _417[_423] - _59[_423];
            _416 = _423 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _415;
    vec4 _434[8] = _415;
    uint _433 = 0u;
    vec4 _432[8];
    uint _440;
    for (;;)
    {
        _440 = _433;
        if (_440 < 8u)
        {
            _432[_440] = _434[_440] * _64[_440];
            _433 = _440 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _451[8] = _432;
    uint _450 = 0u;
    vec4 _449[8];
    uint _457;
    for (;;)
    {
        _457 = _450;
        if (_457 < 8u)
        {
            _449[_457] = _451[_457] / _64[_457];
            _450 = _457 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _449;
    vec4 _468[8] = _449;
    uint _467 = 0u;
    vec4 _466[8];
    uint _473;
    for (;;)
    {
        _473 = _467;
        if (_473 < 8u)
        {
            _466[_473] = _468[_473] * vec4(1.0);
            _467 = _473 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _466;
    vec4 _483[4] = _51;
    uint _482 = 0u;
    vec4 _481[4];
    uint _488;
    for (;;)
    {
        _488 = _482;
        if (_488 < 4u)
        {
            _481[_488] = -_483[_488];
            _482 = _488 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _497[4] = _481;
    uint _496 = 0u;
    vec4 _495[4];
    uint _502;
    for (;;)
    {
        _502 = _496;
        if (_502 < 4u)
        {
            _495[_502] = -_497[_502];
            _496 = _502 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _495;
    vec4 _511[4] = _495;
    uint _510 = 0u;
    vec4 _509[4];
    uint _517;
    for (;;)
    {
        _517 = _510;
        if (_517 < 4u)
        {
            _509[_517] = _511[_517] + _73[_517];
            _510 = _517 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _528[4] = _509;
    uint _527 = 0u;
    vec4 _526[4];
    uint _534;
    for (;;)
    {
        _534 = _527;
        if (_534 < 4u)
        {
            _526[_534] = _528[_534] - _73[_534];
            _527 = _534 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _526;
    vec4 _545[4] = _526;
    uint _544 = 0u;
    vec4 _543[4];
    uint _551;
    for (;;)
    {
        _551 = _544;
        if (_551 < 4u)
        {
            _543[_551] = _545[_551] * _77[_551];
            _544 = _551 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _562[4] = _543;
    uint _561 = 0u;
    vec4 _560[4];
    uint _568;
    for (;;)
    {
        _568 = _561;
        if (_568 < 4u)
        {
            _560[_568] = _562[_568] / _77[_568];
            _561 = _568 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _560;
    vec4 _579[4] = _560;
    uint _578 = 0u;
    vec4 _577[4];
    uint _584;
    for (;;)
    {
        _584 = _578;
        if (_584 < 4u)
        {
            _577[_584] = _579[_584] * vec4(1.0);
            _578 = _584 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _577;
    vec4 _86[4] = _144(_466, _577);
    vec4 tempArg_2[4] = _86;
    vec4 y[4] = _86;
    vec4 _594[4] = _86;
    uint _593 = 0u;
    vec4 _592[4];
    uint _599;
    for (;;)
    {
        _599 = _593;
        if (_599 < 4u)
        {
            _592[_599] = -_594[_599];
            _593 = _599 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _608[4] = _592;
    uint _607 = 0u;
    vec4 _606[4];
    uint _613;
    for (;;)
    {
        _613 = _607;
        if (_613 < 4u)
        {
            _606[_613] = -_608[_613];
            _607 = _613 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _606;
    vec4 _622[4] = _606;
    uint _621 = 0u;
    vec4 _620[4];
    uint _628;
    for (;;)
    {
        _628 = _621;
        if (_628 < 4u)
        {
            _620[_628] = _622[_628] + _73[_628];
            _621 = _628 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _639[4] = _620;
    uint _638 = 0u;
    vec4 _637[4];
    uint _645;
    for (;;)
    {
        _645 = _638;
        if (_645 < 4u)
        {
            _637[_645] = _639[_645] - _73[_645];
            _638 = _645 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _637;
    vec4 _656[4] = _637;
    uint _655 = 0u;
    vec4 _654[4];
    uint _662;
    for (;;)
    {
        _662 = _655;
        if (_662 < 4u)
        {
            _654[_662] = _656[_662] * _77[_662];
            _655 = _662 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _673[4] = _654;
    uint _672 = 0u;
    vec4 _671[4];
    uint _679;
    for (;;)
    {
        _679 = _672;
        if (_679 < 4u)
        {
            _671[_679] = _673[_679] / _77[_679];
            _672 = _679 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _671;
    vec4 _690[4] = _671;
    uint _689 = 0u;
    vec4 _688[4];
    uint _695;
    for (;;)
    {
        _695 = _689;
        if (_695 < 4u)
        {
            _688[_695] = _690[_695] * vec4(1.0);
            _689 = _695 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _688;
    vec4 _720[4] = _688;
    uint _721 = 0u;
    uint _726;
    for (;;)
    {
        _726 = _721;
        if (_726 < 16u)
        {
            _704(0u + _726, _720[_726 / 4u]);
            _721 = _726 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

