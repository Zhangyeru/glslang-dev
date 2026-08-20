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

f16vec2 _186(uint _187)
{
    return f16vec2(X.data[_187], X.data[_187 + 1u]);
}

f16vec2 _211(uint _212)
{
    return f16vec2(W.data[_212], W.data[_212 + 1u]);
}

f16vec2 _247(uint _248)
{
    return f16vec2(Bias.data[_248], Bias.data[_248 + 1u]);
}

f16vec2[8] _117(f16vec2 _118[16], f16vec2 _119[256], f16vec2 _120[8])
{
    f16vec2 _138[16] = _118;
    f16vec2 _139[256] = _119;
    f16vec2 _140[8] = _120;
    uint _134 = 0u;
    f16vec2 _133[8];
    uint _141;
    for (;;)
    {
        _141 = _134;
        if (_141 < 8u)
        {
            f16vec2 _136 = f16vec2(float16_t(0.0));
            f16vec2 _137 = f16vec2(float16_t(0.0));
            uint _135 = 0u;
            uint _143;
            for (;;)
            {
                _143 = _135;
                if (_143 < 16u)
                {
                    uint _145 = _143 * 2u;
                    uint _150 = (_145 * 8u) + _141;
                    uint _155 = ((_145 + 1u) * 8u) + _141;
                    _136 = fma(_138[_143], f16vec2(_139[_150].x, _139[_155].x), _136);
                    _137 = fma(_138[_143], f16vec2(_139[_150].y, _139[_155].y), _137);
                    _135 = _143 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _133[_141] = f16vec2(_136.x + _136.y, _137.x + _137.y) + _140[_141];
            _134 = _141 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _133;
}

void _361(uint _362, f16vec2 _363)
{
    Y.data[_362] = _363.x;
    Y.data[_362 + 1u] = _363.y;
}

void main()
{
    uint _198 = 0u;
    f16vec2 _197[16];
    uint _203;
    for (;;)
    {
        _203 = _198;
        if (_203 < 32u)
        {
            _197[_203 / 2u] = _186(0u + _203);
            _198 = _203 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _21[16] = _197;
    f16vec2 tempArg[16] = _21;
    f16vec2 x[16] = _21;
    uint _223 = 0u;
    f16vec2 _222[256];
    uint _228;
    for (;;)
    {
        _228 = _223;
        if (_228 < 512u)
        {
            _222[_228 / 2u] = _211(((uint(0) + (_228 / 16u)) * uint(16)) + (uint(0) + (_228 % 16u)));
            _223 = _228 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _39[256] = _222;
    f16vec2 tempArg_1[256] = _39;
    f16vec2 w[256] = _39;
    uint _258 = 0u;
    f16vec2 _257[8];
    uint _263;
    for (;;)
    {
        _263 = _258;
        if (_263 < 16u)
        {
            _257[_263 / 2u] = _247(0u + _263);
            _258 = _263 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _51[8] = _257;
    f16vec2 tempArg_2[8] = _51;
    f16vec2 bias[8] = _51;
    f16vec2 _275[16] = _21;
    uint _274 = 0u;
    vec2 _273[16];
    uint _280;
    for (;;)
    {
        _280 = _274;
        if (_280 < 16u)
        {
            _273[_280] = vec2(_275[_280]);
            _274 = _280 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 xf[16] = _273;
    vec2 _290[16] = _273;
    uint _289 = 0u;
    f16vec2 _288[16];
    uint _295;
    for (;;)
    {
        _295 = _289;
        if (_295 < 16u)
        {
            _288[_295] = f16vec2(_290[_295]);
            _289 = _295 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _288;
    f16vec2 _305[256] = _39;
    uint _304 = 0u;
    vec2 _303[256];
    uint _310;
    for (;;)
    {
        _310 = _304;
        if (_310 < 256u)
        {
            _303[_310] = vec2(_305[_310]);
            _304 = _310 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _68[256] = _303;
    vec2 wf[256] = _68;
    vec2 _319[256] = _68;
    uint _318 = 0u;
    f16vec2 _317[256];
    uint _324;
    for (;;)
    {
        _324 = _318;
        if (_324 < 256u)
        {
            _317[_324] = f16vec2(_319[_324]);
            _318 = _324 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _72[256] = _317;
    w = _72;
    f16vec2 _334[8] = _51;
    uint _333 = 0u;
    vec2 _332[8];
    uint _339;
    for (;;)
    {
        _339 = _333;
        if (_339 < 8u)
        {
            _332[_339] = vec2(_334[_339]);
            _333 = _339 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 biasf[8] = _332;
    vec2 _348[8] = _332;
    uint _347 = 0u;
    f16vec2 _346[8];
    uint _353;
    for (;;)
    {
        _353 = _347;
        if (_353 < 8u)
        {
            _346[_353] = f16vec2(_348[_353]);
            _347 = _353 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _346;
    f16vec2 _84[8] = _117(_288, _317, _346);
    f16vec2 tempArg_3[8] = _84;
    f16vec2 y[8] = _84;
    f16vec2 _371[8] = _84;
    uint _372 = 0u;
    uint _377;
    for (;;)
    {
        _377 = _372;
        if (_377 < 16u)
        {
            _361(0u + _377, _371[_377 / 2u]);
            _372 = _377 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

