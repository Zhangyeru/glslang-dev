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

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec2[512] _75()
{
    uint _111 = uint(32);
    uint _113 = uint(0);
    uint _115 = uint(0);
    uint _117 = uint(32);
    uint _119 = uint(0);
    uint _121 = uint(0);
    uint _123 = uint(32);
    uint _125 = uint(0);
    uint _127 = uint(0);
    vec2 _96[512] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _97 = 0u;
    uint _128;
    for (;;)
    {
        _128 = _97;
        if (_128 < 64u)
        {
            uint _130 = _128 / 2u;
            uint _132 = (_128 % 2u) * 16u;
            uint _133 = _130 * 32u;
            vec2 _99 = vec2(C.data[((_125 + _130) * _123) + (_127 + _132)], C.data[((_125 + _130) * _123) + (_127 + (_132 + 1u))]);
            uint _151 = _132 + 2u;
            vec2 _100 = vec2(C.data[((_125 + _130) * _123) + (_127 + _151)], C.data[((_125 + _130) * _123) + (_127 + (_151 + 1u))]);
            uint _169 = _132 + 4u;
            vec2 _101 = vec2(C.data[((_125 + _130) * _123) + (_127 + _169)], C.data[((_125 + _130) * _123) + (_127 + (_169 + 1u))]);
            uint _187 = _132 + 6u;
            vec2 _102 = vec2(C.data[((_125 + _130) * _123) + (_127 + _187)], C.data[((_125 + _130) * _123) + (_127 + (_187 + 1u))]);
            uint _205 = _132 + 8u;
            vec2 _103 = vec2(C.data[((_125 + _130) * _123) + (_127 + _205)], C.data[((_125 + _130) * _123) + (_127 + (_205 + 1u))]);
            uint _223 = _132 + 10u;
            vec2 _104 = vec2(C.data[((_125 + _130) * _123) + (_127 + _223)], C.data[((_125 + _130) * _123) + (_127 + (_223 + 1u))]);
            uint _241 = _132 + 12u;
            vec2 _105 = vec2(C.data[((_125 + _130) * _123) + (_127 + _241)], C.data[((_125 + _130) * _123) + (_127 + (_241 + 1u))]);
            uint _259 = _132 + 14u;
            vec2 _106 = vec2(C.data[((_125 + _130) * _123) + (_127 + _259)], C.data[((_125 + _130) * _123) + (_127 + (_259 + 1u))]);
            uint _98 = 0u;
            uint _276;
            for (;;)
            {
                _276 = _98;
                if (_276 < 32u)
                {
                    vec2 _288 = vec2(f16vec2(A.data[((_113 + _130) * _111) + (_115 + _276)]));
                    uint _289 = _276 * 32u;
                    _99 = fma(_288, vec2(B.data[((_119 + _276) * _117) + (_121 + _132)], B.data[((_119 + _276) * _117) + (_121 + (_132 + 1u))]), _99);
                    uint _308 = _132 + 2u;
                    _100 = fma(_288, vec2(B.data[((_119 + _276) * _117) + (_121 + _308)], B.data[((_119 + _276) * _117) + (_121 + (_308 + 1u))]), _100);
                    uint _327 = _132 + 4u;
                    _101 = fma(_288, vec2(B.data[((_119 + _276) * _117) + (_121 + _327)], B.data[((_119 + _276) * _117) + (_121 + (_327 + 1u))]), _101);
                    uint _346 = _132 + 6u;
                    _102 = fma(_288, vec2(B.data[((_119 + _276) * _117) + (_121 + _346)], B.data[((_119 + _276) * _117) + (_121 + (_346 + 1u))]), _102);
                    uint _365 = _132 + 8u;
                    _103 = fma(_288, vec2(B.data[((_119 + _276) * _117) + (_121 + _365)], B.data[((_119 + _276) * _117) + (_121 + (_365 + 1u))]), _103);
                    uint _384 = _132 + 10u;
                    _104 = fma(_288, vec2(B.data[((_119 + _276) * _117) + (_121 + _384)], B.data[((_119 + _276) * _117) + (_121 + (_384 + 1u))]), _104);
                    uint _403 = _132 + 12u;
                    _105 = fma(_288, vec2(B.data[((_119 + _276) * _117) + (_121 + _403)], B.data[((_119 + _276) * _117) + (_121 + (_403 + 1u))]), _105);
                    uint _422 = _132 + 14u;
                    _106 = fma(_288, vec2(B.data[((_119 + _276) * _117) + (_121 + _422)], B.data[((_119 + _276) * _117) + (_121 + (_422 + 1u))]), _106);
                    _98 = _276 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _96[_128 * 8u] = _99;
            _96[(_128 * 8u) + 1u] = _100;
            _96[(_128 * 8u) + 2u] = _101;
            _96[(_128 * 8u) + 3u] = _102;
            _96[(_128 * 8u) + 4u] = _103;
            _96[(_128 * 8u) + 5u] = _104;
            _96[(_128 * 8u) + 6u] = _105;
            _96[(_128 * 8u) + 7u] = _106;
            _97 = _128 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _96;
}

void _479(uint _480, vec2 _481)
{
    D.data[_480] = _481.x;
    D.data[_480 + 1u] = _481.y;
}

void main()
{
    vec2 _56[512] = _75();
    vec2 tempArg[512] = _56;
    vec2 d[512] = _56;
    vec2 _490[512] = _56;
    uint _491 = 0u;
    uint _496;
    for (;;)
    {
        _496 = _491;
        if (_496 < 1024u)
        {
            _479(((uint(0) + (_496 / 32u)) * uint(32)) + (uint(0) + (_496 % 32u)), _490[_496 / 2u]);
            _491 = _496 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

