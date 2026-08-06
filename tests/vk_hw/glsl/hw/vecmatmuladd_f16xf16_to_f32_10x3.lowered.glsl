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
    float data[];
} Bias;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

f16vec4 _91(uint _92)
{
    return f16vec4(X.data[_92], X.data[_92 + 1u], X.data[_92 + 2u], X.data[_92 + 3u]);
}

float[3] _109()
{
    vec4 _119 = vec4(0.0);
    vec4 _120 = vec4(0.0);
    vec4 _121 = vec4(0.0);
    uint _118 = 0u;
    uint _126;
    for (;;)
    {
        _126 = _118;
        if (_126 < 2u)
        {
            uint _128 = _126 * 4u;
            vec4 _130 = vec4(_91(_128));
            uint _132 = (_128 * 3u) + 0u;
            uint _149 = ((_128 + 1u) * 3u) + 0u;
            uint _166 = ((_128 + 2u) * 3u) + 0u;
            uint _183 = ((_128 + 3u) * 3u) + 0u;
            _119 = fma(_130, vec4(f16vec4(W.data[((uint(0) + (_132 / 3u)) * uint(3)) + (uint(0) + (_132 % 3u))], W.data[((uint(0) + (_149 / 3u)) * uint(3)) + (uint(0) + (_149 % 3u))], W.data[((uint(0) + (_166 / 3u)) * uint(3)) + (uint(0) + (_166 % 3u))], W.data[((uint(0) + (_183 / 3u)) * uint(3)) + (uint(0) + (_183 % 3u))])), _119);
            uint _202 = 0u + 1u;
            uint _204 = (_128 * 3u) + _202;
            uint _220 = 0u + 1u;
            uint _222 = ((_128 + 1u) * 3u) + _220;
            uint _238 = 0u + 1u;
            uint _240 = ((_128 + 2u) * 3u) + _238;
            uint _256 = 0u + 1u;
            uint _258 = ((_128 + 3u) * 3u) + _256;
            _120 = fma(_130, vec4(f16vec4(W.data[((uint(0) + (_204 / 3u)) * uint(3)) + (uint(0) + (_204 % 3u))], W.data[((uint(0) + (_222 / 3u)) * uint(3)) + (uint(0) + (_222 % 3u))], W.data[((uint(0) + (_240 / 3u)) * uint(3)) + (uint(0) + (_240 % 3u))], W.data[((uint(0) + (_258 / 3u)) * uint(3)) + (uint(0) + (_258 % 3u))])), _120);
            uint _277 = 0u + 2u;
            uint _279 = (_128 * 3u) + _277;
            uint _295 = 0u + 2u;
            uint _297 = ((_128 + 1u) * 3u) + _295;
            uint _313 = 0u + 2u;
            uint _315 = ((_128 + 2u) * 3u) + _313;
            uint _331 = 0u + 2u;
            uint _333 = ((_128 + 3u) * 3u) + _331;
            _121 = fma(_130, vec4(f16vec4(W.data[((uint(0) + (_279 / 3u)) * uint(3)) + (uint(0) + (_279 % 3u))], W.data[((uint(0) + (_297 / 3u)) * uint(3)) + (uint(0) + (_297 % 3u))], W.data[((uint(0) + (_315 / 3u)) * uint(3)) + (uint(0) + (_315 % 3u))], W.data[((uint(0) + (_333 / 3u)) * uint(3)) + (uint(0) + (_333 % 3u))])), _121);
            _118 = _126 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    uint _355 = 8u + 1u;
    vec4 _359 = vec4(f16vec4(X.data[8u], X.data[_355], float16_t(0.0), float16_t(0.0)));
    uint _360 = 8u * 3u;
    uint _361 = _360 + 0u;
    uint _376 = 8u + 1u;
    uint _378 = (_376 * 3u) + 0u;
    _119 = fma(_359, vec4(f16vec4(W.data[((uint(0) + (_361 / 3u)) * uint(3)) + (uint(0) + (_361 % 3u))], W.data[((uint(0) + (_378 / 3u)) * uint(3)) + (uint(0) + (_378 % 3u))], float16_t(0.0), float16_t(0.0))), _119);
    uint _397 = 0u + 1u;
    uint _398 = 8u * 3u;
    uint _399 = _398 + _397;
    uint _414 = 8u + 1u;
    uint _415 = 0u + 1u;
    uint _417 = (_414 * 3u) + _415;
    _120 = fma(_359, vec4(f16vec4(W.data[((uint(0) + (_399 / 3u)) * uint(3)) + (uint(0) + (_399 % 3u))], W.data[((uint(0) + (_417 / 3u)) * uint(3)) + (uint(0) + (_417 % 3u))], float16_t(0.0), float16_t(0.0))), _120);
    uint _436 = 0u + 2u;
    uint _437 = 8u * 3u;
    uint _438 = _437 + _436;
    uint _453 = 8u + 1u;
    uint _454 = 0u + 2u;
    uint _456 = (_453 * 3u) + _454;
    _121 = fma(_359, vec4(f16vec4(W.data[((uint(0) + (_438 / 3u)) * uint(3)) + (uint(0) + (_438 % 3u))], W.data[((uint(0) + (_456 / 3u)) * uint(3)) + (uint(0) + (_456 % 3u))], float16_t(0.0), float16_t(0.0))), _121);
    float _117[3];
    _117[0u] = (((_119.x + _119.y) + _119.z) + _119.w) + Bias.data[0u];
    uint _496 = 0u + 1u;
    _117[_496] = (((_120.x + _120.y) + _120.z) + _120.w) + Bias.data[_496];
    uint _509 = 0u + 2u;
    _117[_509] = (((_121.x + _121.y) + _121.z) + _121.w) + Bias.data[_509];
    return _117;
}

void main()
{
    float _59[3] = _109();
    float tempArg[3] = _59;
    float y[3] = _59;
    uint _516 = 0u + 0u;
    Y.data[_516] = _59[0];
    uint _519 = 0u + 1u;
    Y.data[_519] = _59[1];
    uint _522 = 0u + 2u;
    Y.data[_522] = _59[2];
}

