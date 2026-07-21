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

f16vec4 _234(uint _235)
{
    return f16vec4(X.data[_235], X.data[_235 + 1u], X.data[_235 + 2u], X.data[_235 + 3u]);
}

f16vec4 _265(uint _266)
{
    return f16vec4(W.data[_266], W.data[_266 + 1u], W.data[_266 + 2u], W.data[_266 + 3u]);
}

f16vec4 _307(uint _308)
{
    return f16vec4(Bias.data[_308], Bias.data[_308 + 1u], Bias.data[_308 + 2u], Bias.data[_308 + 3u]);
}

f16vec4[4] _110(f16vec4 _111[8], f16vec4 _112[128], f16vec4 _113[4])
{
    f16vec4 _132[8] = _111;
    f16vec4 _133[128] = _112;
    f16vec4 _134[4] = _113;
    uint _124 = 0u;
    f16vec4 _123[4];
    uint _135;
    for (;;)
    {
        _135 = _124;
        if (_135 < 4u)
        {
            f16vec4 _126 = f16vec4(float16_t(0.0));
            f16vec4 _127 = f16vec4(float16_t(0.0));
            f16vec4 _128 = f16vec4(float16_t(0.0));
            f16vec4 _129 = f16vec4(float16_t(0.0));
            uint _125 = 0u;
            uint _137;
            for (;;)
            {
                _137 = _125;
                if (_137 < 8u)
                {
                    uint _139 = _137 * 4u;
                    uint _145 = ((_139 + 0u) * 4u) + _135;
                    uint _150 = ((_139 + 1u) * 4u) + _135;
                    uint _156 = ((_139 + 2u) * 4u) + _135;
                    uint _162 = ((_139 + 3u) * 4u) + _135;
                    _126 = fma(_132[_137], f16vec4(_133[_145].x, _133[_150].x, _133[_156].x, _133[_162].x), _126);
                    _127 = fma(_132[_137], f16vec4(_133[_145].y, _133[_150].y, _133[_156].y, _133[_162].y), _127);
                    _128 = fma(_132[_137], f16vec4(_133[_145].z, _133[_150].z, _133[_156].z, _133[_162].z), _128);
                    _129 = fma(_132[_137], f16vec4(_133[_145].w, _133[_150].w, _133[_156].w, _133[_162].w), _129);
                    _125 = _137 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _123[_135] = f16vec4(((_126.x + _126.y) + _126.z) + _126.w, ((_127.x + _127.y) + _127.z) + _127.w, ((_128.x + _128.y) + _128.z) + _128.w, ((_129.x + _129.y) + _129.z) + _129.w) + _134[_135];
            _124 = _135 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _123;
}

void _428(uint _429, f16vec4 _430)
{
    Y.data[_429] = _430.x;
    Y.data[_429 + 1u] = _430.y;
    Y.data[_429 + 2u] = _430.z;
    Y.data[_429 + 3u] = _430.w;
}

void main()
{
    uint _252 = 0u;
    f16vec4 _251[8];
    uint _257;
    for (;;)
    {
        _257 = _252;
        if (_257 < 32u)
        {
            _251[_257 / 4u] = _234(0u + _257);
            _252 = _257 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _21[8] = _251;
    f16vec4 tempArg[8] = _21;
    f16vec4 x[8] = _21;
    uint _283 = 0u;
    f16vec4 _282[128];
    uint _288;
    for (;;)
    {
        _288 = _283;
        if (_288 < 512u)
        {
            _282[_288 / 4u] = _265(((uint(0) + (_288 / 16u)) * uint(16)) + (uint(0) + (_288 % 16u)));
            _283 = _288 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[128] = _282;
    f16vec4 tempArg_1[128] = _39;
    f16vec4 w[128] = _39;
    uint _324 = 0u;
    f16vec4 _323[4];
    uint _329;
    for (;;)
    {
        _329 = _324;
        if (_329 < 16u)
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
    f16vec4 _51[4] = _323;
    f16vec4 tempArg_2[4] = _51;
    f16vec4 bias[4] = _51;
    f16vec4 _342[8] = _21;
    uint _341 = 0u;
    vec4 _340[8];
    uint _347;
    for (;;)
    {
        _347 = _341;
        if (_347 < 8u)
        {
            _340[_347] = vec4(_342[_347]);
            _341 = _347 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 xf[8] = _340;
    vec4 _357[8] = _340;
    uint _356 = 0u;
    f16vec4 _355[8];
    uint _362;
    for (;;)
    {
        _362 = _356;
        if (_362 < 8u)
        {
            _355[_362] = f16vec4(_357[_362]);
            _356 = _362 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _355;
    f16vec4 _372[128] = _39;
    uint _371 = 0u;
    vec4 _370[128];
    uint _377;
    for (;;)
    {
        _377 = _371;
        if (_377 < 128u)
        {
            _370[_377] = vec4(_372[_377]);
            _371 = _377 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 wf[128] = _370;
    vec4 _386[128] = _370;
    uint _385 = 0u;
    f16vec4 _384[128];
    uint _391;
    for (;;)
    {
        _391 = _385;
        if (_391 < 128u)
        {
            _384[_391] = f16vec4(_386[_391]);
            _385 = _391 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    w = _384;
    f16vec4 _401[4] = _51;
    uint _400 = 0u;
    vec4 _399[4];
    uint _406;
    for (;;)
    {
        _406 = _400;
        if (_406 < 4u)
        {
            _399[_406] = vec4(_401[_406]);
            _400 = _406 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 biasf[4] = _399;
    vec4 _415[4] = _399;
    uint _414 = 0u;
    f16vec4 _413[4];
    uint _420;
    for (;;)
    {
        _420 = _414;
        if (_420 < 4u)
        {
            _413[_420] = f16vec4(_415[_420]);
            _414 = _420 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _413;
    f16vec4 _80[4] = _110(_355, _384, _413);
    f16vec4 tempArg_3[4] = _80;
    f16vec4 y[4] = _80;
    f16vec4 _444[4] = _80;
    uint _445 = 0u;
    uint _450;
    for (;;)
    {
        _450 = _445;
        if (_450 < 16u)
        {
            _428(0u + _450, _444[_450 / 4u]);
            _445 = _450 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

