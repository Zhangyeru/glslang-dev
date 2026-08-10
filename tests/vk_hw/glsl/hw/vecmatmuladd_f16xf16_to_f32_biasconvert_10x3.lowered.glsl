#version 460
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
    float data[];
} Y;

f16vec4 _97(uint _98)
{
    return f16vec4(X.data[_98], X.data[_98 + 1u], X.data[_98 + 2u], X.data[_98 + 3u]);
}

float[3] _115()
{
    vec4 _125 = vec4(0.0);
    vec4 _126 = vec4(0.0);
    vec4 _127 = vec4(0.0);
    uint _124 = 0u;
    uint _132;
    for (;;)
    {
        _132 = _124;
        if (_132 < 2u)
        {
            uint _134 = _132 * 4u;
            vec4 _136 = vec4(_97(_134));
            uint _138 = (_134 * 3u) + 0u;
            uint _155 = ((_134 + 1u) * 3u) + 0u;
            uint _172 = ((_134 + 2u) * 3u) + 0u;
            uint _189 = ((_134 + 3u) * 3u) + 0u;
            _125 = fma(_136, vec4(f16vec4(W.data[((uint(0) + (_138 / 3u)) * uint(3)) + (uint(0) + (_138 % 3u))], W.data[((uint(0) + (_155 / 3u)) * uint(3)) + (uint(0) + (_155 % 3u))], W.data[((uint(0) + (_172 / 3u)) * uint(3)) + (uint(0) + (_172 % 3u))], W.data[((uint(0) + (_189 / 3u)) * uint(3)) + (uint(0) + (_189 % 3u))])), _125);
            uint _208 = 0u + 1u;
            uint _210 = (_134 * 3u) + _208;
            uint _226 = 0u + 1u;
            uint _228 = ((_134 + 1u) * 3u) + _226;
            uint _244 = 0u + 1u;
            uint _246 = ((_134 + 2u) * 3u) + _244;
            uint _262 = 0u + 1u;
            uint _264 = ((_134 + 3u) * 3u) + _262;
            _126 = fma(_136, vec4(f16vec4(W.data[((uint(0) + (_210 / 3u)) * uint(3)) + (uint(0) + (_210 % 3u))], W.data[((uint(0) + (_228 / 3u)) * uint(3)) + (uint(0) + (_228 % 3u))], W.data[((uint(0) + (_246 / 3u)) * uint(3)) + (uint(0) + (_246 % 3u))], W.data[((uint(0) + (_264 / 3u)) * uint(3)) + (uint(0) + (_264 % 3u))])), _126);
            uint _283 = 0u + 2u;
            uint _285 = (_134 * 3u) + _283;
            uint _301 = 0u + 2u;
            uint _303 = ((_134 + 1u) * 3u) + _301;
            uint _319 = 0u + 2u;
            uint _321 = ((_134 + 2u) * 3u) + _319;
            uint _337 = 0u + 2u;
            uint _339 = ((_134 + 3u) * 3u) + _337;
            _127 = fma(_136, vec4(f16vec4(W.data[((uint(0) + (_285 / 3u)) * uint(3)) + (uint(0) + (_285 % 3u))], W.data[((uint(0) + (_303 / 3u)) * uint(3)) + (uint(0) + (_303 % 3u))], W.data[((uint(0) + (_321 / 3u)) * uint(3)) + (uint(0) + (_321 % 3u))], W.data[((uint(0) + (_339 / 3u)) * uint(3)) + (uint(0) + (_339 % 3u))])), _127);
            _124 = _132 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    uint _361 = 8u + 1u;
    vec4 _365 = vec4(f16vec4(X.data[8u], X.data[_361], float16_t(0.0), float16_t(0.0)));
    uint _366 = 8u * 3u;
    uint _367 = _366 + 0u;
    uint _382 = 8u + 1u;
    uint _384 = (_382 * 3u) + 0u;
    _125 = fma(_365, vec4(f16vec4(W.data[((uint(0) + (_367 / 3u)) * uint(3)) + (uint(0) + (_367 % 3u))], W.data[((uint(0) + (_384 / 3u)) * uint(3)) + (uint(0) + (_384 % 3u))], float16_t(0.0), float16_t(0.0))), _125);
    uint _403 = 0u + 1u;
    uint _404 = 8u * 3u;
    uint _405 = _404 + _403;
    uint _420 = 8u + 1u;
    uint _421 = 0u + 1u;
    uint _423 = (_420 * 3u) + _421;
    _126 = fma(_365, vec4(f16vec4(W.data[((uint(0) + (_405 / 3u)) * uint(3)) + (uint(0) + (_405 % 3u))], W.data[((uint(0) + (_423 / 3u)) * uint(3)) + (uint(0) + (_423 % 3u))], float16_t(0.0), float16_t(0.0))), _126);
    uint _442 = 0u + 2u;
    uint _443 = 8u * 3u;
    uint _444 = _443 + _442;
    uint _459 = 8u + 1u;
    uint _460 = 0u + 2u;
    uint _462 = (_459 * 3u) + _460;
    _127 = fma(_365, vec4(f16vec4(W.data[((uint(0) + (_444 / 3u)) * uint(3)) + (uint(0) + (_444 % 3u))], W.data[((uint(0) + (_462 / 3u)) * uint(3)) + (uint(0) + (_462 % 3u))], float16_t(0.0), float16_t(0.0))), _127);
    float _123[3];
    _123[0u] = (((_125.x + _125.y) + _125.z) + _125.w) + float(Bias.data[0u]);
    uint _502 = 0u + 1u;
    _123[_502] = (((_126.x + _126.y) + _126.z) + _126.w) + float(Bias.data[_502]);
    uint _516 = 0u + 2u;
    _123[_516] = (((_127.x + _127.y) + _127.z) + _127.w) + float(Bias.data[_516]);
    return _123;
}

void main()
{
    float _64[3] = _115();
    float tempArg[3] = _64;
    float y[3] = _64;
    uint _524 = 0u + 0u;
    Y.data[_524] = _64[0];
    uint _528 = 0u + 1u;
    Y.data[_528] = _64[1];
    uint _531 = 0u + 2u;
    Y.data[_531] = _64[2];
}

