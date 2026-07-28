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

f16vec4 _109(uint _110)
{
    return f16vec4(X.data[_110], X.data[_110 + 1u], X.data[_110 + 2u], X.data[_110 + 3u]);
}

f16vec4 _146(uint _147)
{
    return f16vec4(W.data[_147], W.data[_147 + 1u], W.data[_147 + 2u], W.data[_147 + 3u]);
}

f16vec4 _189(uint _190)
{
    return f16vec4(Bias.data[_190], Bias.data[_190 + 1u], Bias.data[_190 + 2u], Bias.data[_190 + 3u]);
}

f16vec4[4] _312(f16vec4 _313[8], f16vec4 _314[128], f16vec4 _315[4])
{
    f16vec4 _332[8] = _313;
    f16vec4 _333[128] = _314;
    f16vec4 _334[4] = _315;
    uint _326 = 0u;
    f16vec4 _325[4];
    uint _335;
    for (;;)
    {
        _335 = _326;
        if (_335 < 4u)
        {
            f16vec4 _328 = f16vec4(float16_t(0.0));
            f16vec4 _329 = f16vec4(float16_t(0.0));
            f16vec4 _330 = f16vec4(float16_t(0.0));
            f16vec4 _331 = f16vec4(float16_t(0.0));
            uint _327 = 0u;
            uint _337;
            for (;;)
            {
                _337 = _327;
                if (_337 < 8u)
                {
                    uint _339 = _337 * 4u;
                    uint _345 = ((_339 + 0u) * 4u) + _335;
                    uint _350 = ((_339 + 1u) * 4u) + _335;
                    uint _355 = ((_339 + 2u) * 4u) + _335;
                    uint _360 = ((_339 + 3u) * 4u) + _335;
                    _328 = fma(_332[_337], f16vec4(_333[_345].x, _333[_350].x, _333[_355].x, _333[_360].x), _328);
                    _329 = fma(_332[_337], f16vec4(_333[_345].y, _333[_350].y, _333[_355].y, _333[_360].y), _329);
                    _330 = fma(_332[_337], f16vec4(_333[_345].z, _333[_350].z, _333[_355].z, _333[_360].z), _330);
                    _331 = fma(_332[_337], f16vec4(_333[_345].w, _333[_350].w, _333[_355].w, _333[_360].w), _331);
                    _327 = _337 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _325[_335] = f16vec4(((_328.x + _328.y) + _328.z) + _328.w, ((_329.x + _329.y) + _329.z) + _329.w, ((_330.x + _330.y) + _330.z) + _330.w, ((_331.x + _331.y) + _331.z) + _331.w) + _334[_335];
            _326 = _335 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _325;
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
    uint _133 = 0u;
    f16vec4 _132[8];
    uint _138;
    for (;;)
    {
        _138 = _133;
        if (_138 < 32u)
        {
            _132[_138 / 4u] = _109(0u + _138);
            _133 = _138 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _21[8] = _132;
    f16vec4 tempArg[8] = _21;
    f16vec4 x[8] = _21;
    uint _165 = 0u;
    f16vec4 _164[128];
    uint _170;
    for (;;)
    {
        _170 = _165;
        if (_170 < 512u)
        {
            _164[_170 / 4u] = _146(((uint(0) + (_170 / 16u)) * uint(16)) + (uint(0) + (_170 % 16u)));
            _165 = _170 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[128] = _164;
    f16vec4 tempArg_1[128] = _39;
    f16vec4 w[128] = _39;
    uint _207 = 0u;
    f16vec4 _206[4];
    uint _212;
    for (;;)
    {
        _212 = _207;
        if (_212 < 16u)
        {
            _206[_212 / 4u] = _189(0u + _212);
            _207 = _212 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _51[4] = _206;
    f16vec4 tempArg_2[4] = _51;
    f16vec4 bias[4] = _51;
    f16vec4 _225[8] = _21;
    uint _224 = 0u;
    vec4 _223[8];
    uint _230;
    for (;;)
    {
        _230 = _224;
        if (_230 < 8u)
        {
            _223[_230] = vec4(_225[_230]);
            _224 = _230 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 xf[8] = _223;
    vec4 _240[8] = _223;
    uint _239 = 0u;
    f16vec4 _238[8];
    uint _245;
    for (;;)
    {
        _245 = _239;
        if (_245 < 8u)
        {
            _238[_245] = f16vec4(_240[_245]);
            _239 = _245 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    x = _238;
    f16vec4 _255[128] = _39;
    uint _254 = 0u;
    vec4 _253[128];
    uint _260;
    for (;;)
    {
        _260 = _254;
        if (_260 < 128u)
        {
            _253[_260] = vec4(_255[_260]);
            _254 = _260 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _68[128] = _253;
    vec4 wf[128] = _68;
    vec4 _269[128] = _68;
    uint _268 = 0u;
    f16vec4 _267[128];
    uint _274;
    for (;;)
    {
        _274 = _268;
        if (_274 < 128u)
        {
            _267[_274] = f16vec4(_269[_274]);
            _268 = _274 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _72[128] = _267;
    w = _72;
    f16vec4 _284[4] = _51;
    uint _283 = 0u;
    vec4 _282[4];
    uint _289;
    for (;;)
    {
        _289 = _283;
        if (_289 < 4u)
        {
            _282[_289] = vec4(_284[_289]);
            _283 = _289 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 biasf[4] = _282;
    vec4 _298[4] = _282;
    uint _297 = 0u;
    f16vec4 _296[4];
    uint _303;
    for (;;)
    {
        _303 = _297;
        if (_303 < 4u)
        {
            _296[_303] = f16vec4(_298[_303]);
            _297 = _303 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    bias = _296;
    f16vec4 _84[4] = _312(_238, _72, _296);
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

