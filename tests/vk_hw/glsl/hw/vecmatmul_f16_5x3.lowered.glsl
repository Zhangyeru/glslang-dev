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

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

f16vec4 _78(uint _79)
{
    return f16vec4(X.data[_79], X.data[_79 + 1u], X.data[_79 + 2u], X.data[_79 + 3u]);
}

float16_t[3] _97()
{
    f16vec4 _107 = f16vec4(float16_t(0.0));
    f16vec4 _108 = f16vec4(float16_t(0.0));
    f16vec4 _109 = f16vec4(float16_t(0.0));
    uint _106 = 0u;
    uint _113;
    for (;;)
    {
        _113 = _106;
        if (_113 < 1u)
        {
            uint _115 = _113 * 4u;
            f16vec4 _116 = _78(_115);
            uint _118 = (_115 * 3u) + 0u;
            uint _135 = ((_115 + 1u) * 3u) + 0u;
            uint _152 = ((_115 + 2u) * 3u) + 0u;
            uint _169 = ((_115 + 3u) * 3u) + 0u;
            _107 = fma(_116, f16vec4(W.data[((uint(0) + (_118 / 3u)) * uint(3)) + (uint(0) + (_118 % 3u))], W.data[((uint(0) + (_135 / 3u)) * uint(3)) + (uint(0) + (_135 % 3u))], W.data[((uint(0) + (_152 / 3u)) * uint(3)) + (uint(0) + (_152 % 3u))], W.data[((uint(0) + (_169 / 3u)) * uint(3)) + (uint(0) + (_169 % 3u))]), _107);
            uint _187 = 0u + 1u;
            uint _189 = (_115 * 3u) + _187;
            uint _205 = 0u + 1u;
            uint _207 = ((_115 + 1u) * 3u) + _205;
            uint _223 = 0u + 1u;
            uint _225 = ((_115 + 2u) * 3u) + _223;
            uint _241 = 0u + 1u;
            uint _243 = ((_115 + 3u) * 3u) + _241;
            _108 = fma(_116, f16vec4(W.data[((uint(0) + (_189 / 3u)) * uint(3)) + (uint(0) + (_189 % 3u))], W.data[((uint(0) + (_207 / 3u)) * uint(3)) + (uint(0) + (_207 % 3u))], W.data[((uint(0) + (_225 / 3u)) * uint(3)) + (uint(0) + (_225 % 3u))], W.data[((uint(0) + (_243 / 3u)) * uint(3)) + (uint(0) + (_243 % 3u))]), _108);
            uint _261 = 0u + 2u;
            uint _263 = (_115 * 3u) + _261;
            uint _279 = 0u + 2u;
            uint _281 = ((_115 + 1u) * 3u) + _279;
            uint _297 = 0u + 2u;
            uint _299 = ((_115 + 2u) * 3u) + _297;
            uint _315 = 0u + 2u;
            uint _317 = ((_115 + 3u) * 3u) + _315;
            _109 = fma(_116, f16vec4(W.data[((uint(0) + (_263 / 3u)) * uint(3)) + (uint(0) + (_263 % 3u))], W.data[((uint(0) + (_281 / 3u)) * uint(3)) + (uint(0) + (_281 % 3u))], W.data[((uint(0) + (_299 / 3u)) * uint(3)) + (uint(0) + (_299 % 3u))], W.data[((uint(0) + (_317 / 3u)) * uint(3)) + (uint(0) + (_317 % 3u))]), _109);
            _106 = _113 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _338 = f16vec4(X.data[4u], float16_t(0.0), float16_t(0.0), float16_t(0.0));
    uint _339 = 4u * 3u;
    uint _340 = _339 + 0u;
    _107 = fma(_338, f16vec4(W.data[((uint(0) + (_340 / 3u)) * uint(3)) + (uint(0) + (_340 % 3u))], float16_t(0.0), float16_t(0.0), float16_t(0.0)), _107);
    uint _358 = 0u + 1u;
    uint _359 = 4u * 3u;
    uint _360 = _359 + _358;
    _108 = fma(_338, f16vec4(W.data[((uint(0) + (_360 / 3u)) * uint(3)) + (uint(0) + (_360 % 3u))], float16_t(0.0), float16_t(0.0), float16_t(0.0)), _108);
    uint _378 = 0u + 2u;
    uint _379 = 4u * 3u;
    uint _380 = _379 + _378;
    _109 = fma(_338, f16vec4(W.data[((uint(0) + (_380 / 3u)) * uint(3)) + (uint(0) + (_380 % 3u))], float16_t(0.0), float16_t(0.0), float16_t(0.0)), _109);
    float16_t _105[3];
    _105[0u] = ((_107.x + _107.y) + _107.z) + _107.w;
    uint _415 = 0u + 1u;
    _105[_415] = ((_108.x + _108.y) + _108.z) + _108.w;
    uint _425 = 0u + 2u;
    _105[_425] = ((_109.x + _109.y) + _109.z) + _109.w;
    return _105;
}

void main()
{
    float16_t _47[3] = _97();
    float16_t tempArg[3] = _47;
    float16_t y[3] = _47;
    uint _429 = 0u + 0u;
    Y.data[_429] = _47[0];
    uint _432 = 0u + 1u;
    Y.data[_432] = _47[1];
    uint _435 = 0u + 2u;
    Y.data[_435] = _47[2];
}

