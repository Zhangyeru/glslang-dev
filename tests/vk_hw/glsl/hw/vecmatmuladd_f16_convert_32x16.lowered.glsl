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

f16vec4 _264(uint _265)
{
    return f16vec4(W.data[_265], W.data[_265 + 1u], W.data[_265 + 2u], W.data[_265 + 3u]);
}

f16vec4 _306(uint _307)
{
    return f16vec4(Bias.data[_307], Bias.data[_307 + 1u], Bias.data[_307 + 2u], Bias.data[_307 + 3u]);
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

void _426(uint _427, f16vec4 _428)
{
    Y.data[_427] = _428.x;
    Y.data[_427 + 1u] = _428.y;
    Y.data[_427 + 2u] = _428.z;
    Y.data[_427 + 3u] = _428.w;
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
            _251[_257 / 4u] = _234(_257);
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
    uint _282 = 0u;
    f16vec4 _281[128];
    uint _287;
    for (;;)
    {
        _287 = _282;
        if (_287 < 512u)
        {
            _281[_287 / 4u] = _264(((uint(0) + (_287 / 16u)) * uint(16)) + (uint(0) + (_287 % 16u)));
            _282 = _287 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[128] = _281;
    f16vec4 tempArg_1[128] = _39;
    f16vec4 w[128] = _39;
    uint _323 = 0u;
    f16vec4 _322[4];
    uint _328;
    for (;;)
    {
        _328 = _323;
        if (_328 < 16u)
        {
            _322[_328 / 4u] = _306(_328);
            _323 = _328 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _51[4] = _322;
    f16vec4 tempArg_2[4] = _51;
    f16vec4 bias[4] = _51;
    f16vec4 _340[8] = _21;
    uint _339 = 0u;
    vec4 _338[8];
    uint _345;
    for (;;)
    {
        _345 = _339;
        if (_345 < 8u)
        {
            _338[_345] = vec4(_340[_345]);
            _339 = _345 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 xf[8] = _338;
    vec4 _355[8] = _338;
    uint _354 = 0u;
    f16vec4 _353[8];
    uint _360;
    for (;;)
    {
        _360 = _354;
        if (_360 < 8u)
        {
            _353[_360] = f16vec4(_355[_360]);
            _354 = _360 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _353;
    f16vec4 _370[128] = _39;
    uint _369 = 0u;
    vec4 _368[128];
    uint _375;
    for (;;)
    {
        _375 = _369;
        if (_375 < 128u)
        {
            _368[_375] = vec4(_370[_375]);
            _369 = _375 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 wf[128] = _368;
    vec4 _384[128] = _368;
    uint _383 = 0u;
    f16vec4 _382[128];
    uint _389;
    for (;;)
    {
        _389 = _383;
        if (_389 < 128u)
        {
            _382[_389] = f16vec4(_384[_389]);
            _383 = _389 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    w = _382;
    f16vec4 _399[4] = _51;
    uint _398 = 0u;
    vec4 _397[4];
    uint _404;
    for (;;)
    {
        _404 = _398;
        if (_404 < 4u)
        {
            _397[_404] = vec4(_399[_404]);
            _398 = _404 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 biasf[4] = _397;
    vec4 _413[4] = _397;
    uint _412 = 0u;
    f16vec4 _411[4];
    uint _418;
    for (;;)
    {
        _418 = _412;
        if (_418 < 4u)
        {
            _411[_418] = f16vec4(_413[_418]);
            _412 = _418 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _411;
    f16vec4 _80[4] = _110(_353, _382, _411);
    f16vec4 tempArg_3[4] = _80;
    f16vec4 y[4] = _80;
    f16vec4 _442[4] = _80;
    uint _443 = 0u;
    uint _448;
    for (;;)
    {
        _448 = _443;
        if (_448 < 16u)
        {
            _426(_448, _442[_448 / 4u]);
            _443 = _448 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

