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

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float16_t data[];
} W;

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float16_t data[];
} Bias;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t data[];
} Y;

f16vec4 _241(uint _242)
{
    return f16vec4(X.data[_242], X.data[_242 + 1u], X.data[_242 + 2u], X.data[_242 + 3u]);
}

f16vec4 _272(uint _273)
{
    return f16vec4(W.data[_273], W.data[_273 + 1u], W.data[_273 + 2u], W.data[_273 + 3u]);
}

f16vec4 _314(uint _315)
{
    return f16vec4(Bias.data[_315], Bias.data[_315 + 1u], Bias.data[_315 + 2u], Bias.data[_315 + 3u]);
}

f16vec4[4] _116(f16vec4 _117[8], f16vec4 _118[128], f16vec4 _119[4])
{
    f16vec4 _139[8] = _117;
    f16vec4 _140[128] = _118;
    f16vec4 _141[4] = _119;
    uint _133 = 0u;
    f16vec4 _132[4];
    uint _142;
    for (;;)
    {
        _142 = _133;
        if (_142 < 4u)
        {
            f16vec4 _135 = f16vec4(float16_t(0.0));
            f16vec4 _136 = f16vec4(float16_t(0.0));
            f16vec4 _137 = f16vec4(float16_t(0.0));
            f16vec4 _138 = f16vec4(float16_t(0.0));
            uint _134 = 0u;
            uint _144;
            for (;;)
            {
                _144 = _134;
                if (_144 < 8u)
                {
                    uint _146 = _144 * 4u;
                    uint _151 = (_146 * 4u) + _142;
                    uint _156 = ((_146 + 1u) * 4u) + _142;
                    uint _162 = ((_146 + 2u) * 4u) + _142;
                    uint _168 = ((_146 + 3u) * 4u) + _142;
                    _135 = fma(_139[_144], f16vec4(_140[_151].x, _140[_156].x, _140[_162].x, _140[_168].x), _135);
                    _136 = fma(_139[_144], f16vec4(_140[_151].y, _140[_156].y, _140[_162].y, _140[_168].y), _136);
                    _137 = fma(_139[_144], f16vec4(_140[_151].z, _140[_156].z, _140[_162].z, _140[_168].z), _137);
                    _138 = fma(_139[_144], f16vec4(_140[_151].w, _140[_156].w, _140[_162].w, _140[_168].w), _138);
                    _134 = _144 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _132[_142] = f16vec4(((_135.x + _135.y) + _135.z) + _135.w, ((_136.x + _136.y) + _136.z) + _136.w, ((_137.x + _137.y) + _137.z) + _137.w, ((_138.x + _138.y) + _138.z) + _138.w) + _141[_142];
            _133 = _142 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _132;
}

void _434(uint _435, f16vec4 _436)
{
    Y.data[_435] = _436.x;
    Y.data[_435 + 1u] = _436.y;
    Y.data[_435 + 2u] = _436.z;
    Y.data[_435 + 3u] = _436.w;
}

void main()
{
    uint _259 = 0u;
    f16vec4 _258[8];
    uint _264;
    for (;;)
    {
        _264 = _259;
        if (_264 < 32u)
        {
            _258[_264 / 4u] = _241(0u + _264);
            _259 = _264 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _21[8] = _258;
    f16vec4 tempArg[8] = _21;
    f16vec4 x[8] = _21;
    uint _290 = 0u;
    f16vec4 _289[128];
    uint _295;
    for (;;)
    {
        _295 = _290;
        if (_295 < 512u)
        {
            _289[_295 / 4u] = _272(((uint(0) + (_295 / 16u)) * uint(16)) + (uint(0) + (_295 % 16u)));
            _290 = _295 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[128] = _289;
    f16vec4 tempArg_1[128] = _39;
    f16vec4 w[128] = _39;
    uint _331 = 0u;
    f16vec4 _330[4];
    uint _336;
    for (;;)
    {
        _336 = _331;
        if (_336 < 16u)
        {
            _330[_336 / 4u] = _314(0u + _336);
            _331 = _336 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _51[4] = _330;
    f16vec4 tempArg_2[4] = _51;
    f16vec4 bias[4] = _51;
    f16vec4 _348[8] = _21;
    uint _347 = 0u;
    vec4 _346[8];
    uint _353;
    for (;;)
    {
        _353 = _347;
        if (_353 < 8u)
        {
            _346[_353] = vec4(_348[_353]);
            _347 = _353 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 xf[8] = _346;
    vec4 _363[8] = _346;
    uint _362 = 0u;
    f16vec4 _361[8];
    uint _368;
    for (;;)
    {
        _368 = _362;
        if (_368 < 8u)
        {
            _361[_368] = f16vec4(_363[_368]);
            _362 = _368 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _361;
    f16vec4 _378[128] = _39;
    uint _377 = 0u;
    vec4 _376[128];
    uint _383;
    for (;;)
    {
        _383 = _377;
        if (_383 < 128u)
        {
            _376[_383] = vec4(_378[_383]);
            _377 = _383 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _68[128] = _376;
    vec4 wf[128] = _68;
    vec4 _392[128] = _68;
    uint _391 = 0u;
    f16vec4 _390[128];
    uint _397;
    for (;;)
    {
        _397 = _391;
        if (_397 < 128u)
        {
            _390[_397] = f16vec4(_392[_397]);
            _391 = _397 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _72[128] = _390;
    w = _72;
    f16vec4 _407[4] = _51;
    uint _406 = 0u;
    vec4 _405[4];
    uint _412;
    for (;;)
    {
        _412 = _406;
        if (_412 < 4u)
        {
            _405[_412] = vec4(_407[_412]);
            _406 = _412 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 biasf[4] = _405;
    vec4 _421[4] = _405;
    uint _420 = 0u;
    f16vec4 _419[4];
    uint _426;
    for (;;)
    {
        _426 = _420;
        if (_426 < 4u)
        {
            _419[_426] = f16vec4(_421[_426]);
            _420 = _426 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _419;
    f16vec4 _84[4] = _116(_361, _390, _419);
    f16vec4 tempArg_3[4] = _84;
    f16vec4 y[4] = _84;
    f16vec4 _450[4] = _84;
    uint _451 = 0u;
    uint _456;
    for (;;)
    {
        _456 = _451;
        if (_456 < 16u)
        {
            _434(0u + _456, _450[_456 / 4u]);
            _451 = _456 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

