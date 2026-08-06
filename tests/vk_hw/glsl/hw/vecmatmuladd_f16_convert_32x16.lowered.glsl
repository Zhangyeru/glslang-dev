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

f16vec4 _238(uint _239)
{
    return f16vec4(X.data[_239], X.data[_239 + 1u], X.data[_239 + 2u], X.data[_239 + 3u]);
}

f16vec4 _269(uint _270)
{
    return f16vec4(W.data[_270], W.data[_270 + 1u], W.data[_270 + 2u], W.data[_270 + 3u]);
}

f16vec4 _311(uint _312)
{
    return f16vec4(Bias.data[_312], Bias.data[_312 + 1u], Bias.data[_312 + 2u], Bias.data[_312 + 3u]);
}

f16vec4[4] _114(f16vec4 _115[8], f16vec4 _116[128], f16vec4 _117[4])
{
    f16vec4 _136[8] = _115;
    f16vec4 _137[128] = _116;
    f16vec4 _138[4] = _117;
    uint _128 = 0u;
    f16vec4 _127[4];
    uint _139;
    for (;;)
    {
        _139 = _128;
        if (_139 < 4u)
        {
            f16vec4 _130 = f16vec4(float16_t(0.0));
            f16vec4 _131 = f16vec4(float16_t(0.0));
            f16vec4 _132 = f16vec4(float16_t(0.0));
            f16vec4 _133 = f16vec4(float16_t(0.0));
            uint _129 = 0u;
            uint _141;
            for (;;)
            {
                _141 = _129;
                if (_141 < 8u)
                {
                    uint _143 = _141 * 4u;
                    uint _149 = ((_143 + 0u) * 4u) + _139;
                    uint _154 = ((_143 + 1u) * 4u) + _139;
                    uint _160 = ((_143 + 2u) * 4u) + _139;
                    uint _166 = ((_143 + 3u) * 4u) + _139;
                    _130 = fma(_136[_141], f16vec4(_137[_149].x, _137[_154].x, _137[_160].x, _137[_166].x), _130);
                    _131 = fma(_136[_141], f16vec4(_137[_149].y, _137[_154].y, _137[_160].y, _137[_166].y), _131);
                    _132 = fma(_136[_141], f16vec4(_137[_149].z, _137[_154].z, _137[_160].z, _137[_166].z), _132);
                    _133 = fma(_136[_141], f16vec4(_137[_149].w, _137[_154].w, _137[_160].w, _137[_166].w), _133);
                    _129 = _141 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _127[_139] = f16vec4(((_130.x + _130.y) + _130.z) + _130.w, ((_131.x + _131.y) + _131.z) + _131.w, ((_132.x + _132.y) + _132.z) + _132.w, ((_133.x + _133.y) + _133.z) + _133.w) + _138[_139];
            _128 = _139 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _127;
}

void _432(uint _433, f16vec4 _434)
{
    Y.data[_433] = _434.x;
    Y.data[_433 + 1u] = _434.y;
    Y.data[_433 + 2u] = _434.z;
    Y.data[_433 + 3u] = _434.w;
}

void main()
{
    uint _256 = 0u;
    f16vec4 _255[8];
    uint _261;
    for (;;)
    {
        _261 = _256;
        if (_261 < 32u)
        {
            _255[_261 / 4u] = _238(0u + _261);
            _256 = _261 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _21[8] = _255;
    f16vec4 tempArg[8] = _21;
    f16vec4 x[8] = _21;
    uint _287 = 0u;
    f16vec4 _286[128];
    uint _292;
    for (;;)
    {
        _292 = _287;
        if (_292 < 512u)
        {
            _286[_292 / 4u] = _269(((uint(0) + (_292 / 16u)) * uint(16)) + (uint(0) + (_292 % 16u)));
            _287 = _292 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[128] = _286;
    f16vec4 tempArg_1[128] = _39;
    f16vec4 w[128] = _39;
    uint _328 = 0u;
    f16vec4 _327[4];
    uint _333;
    for (;;)
    {
        _333 = _328;
        if (_333 < 16u)
        {
            _327[_333 / 4u] = _311(0u + _333);
            _328 = _333 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _51[4] = _327;
    f16vec4 tempArg_2[4] = _51;
    f16vec4 bias[4] = _51;
    f16vec4 _346[8] = _21;
    uint _345 = 0u;
    vec4 _344[8];
    uint _351;
    for (;;)
    {
        _351 = _345;
        if (_351 < 8u)
        {
            _344[_351] = vec4(_346[_351]);
            _345 = _351 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 xf[8] = _344;
    vec4 _361[8] = _344;
    uint _360 = 0u;
    f16vec4 _359[8];
    uint _366;
    for (;;)
    {
        _366 = _360;
        if (_366 < 8u)
        {
            _359[_366] = f16vec4(_361[_366]);
            _360 = _366 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _359;
    f16vec4 _376[128] = _39;
    uint _375 = 0u;
    vec4 _374[128];
    uint _381;
    for (;;)
    {
        _381 = _375;
        if (_381 < 128u)
        {
            _374[_381] = vec4(_376[_381]);
            _375 = _381 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _68[128] = _374;
    vec4 wf[128] = _68;
    vec4 _390[128] = _68;
    uint _389 = 0u;
    f16vec4 _388[128];
    uint _395;
    for (;;)
    {
        _395 = _389;
        if (_395 < 128u)
        {
            _388[_395] = f16vec4(_390[_395]);
            _389 = _395 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _72[128] = _388;
    w = _72;
    f16vec4 _405[4] = _51;
    uint _404 = 0u;
    vec4 _403[4];
    uint _410;
    for (;;)
    {
        _410 = _404;
        if (_410 < 4u)
        {
            _403[_410] = vec4(_405[_410]);
            _404 = _410 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 biasf[4] = _403;
    vec4 _419[4] = _403;
    uint _418 = 0u;
    f16vec4 _417[4];
    uint _424;
    for (;;)
    {
        _424 = _418;
        if (_424 < 4u)
        {
            _417[_424] = f16vec4(_419[_424]);
            _418 = _424 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _417;
    f16vec4 _84[4] = _114(_359, _388, _417);
    f16vec4 tempArg_3[4] = _84;
    f16vec4 y[4] = _84;
    f16vec4 _448[4] = _84;
    uint _449 = 0u;
    uint _454;
    for (;;)
    {
        _454 = _449;
        if (_454 < 16u)
        {
            _432(0u + _454, _448[_454 / 4u]);
            _449 = _454 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

