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

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

f16vec2[256] _77()
{
    uint _111 = uint(16);
    uint _113 = uint(0);
    uint _115 = uint(0);
    uint _117 = uint(32);
    uint _119 = uint(0);
    uint _121 = uint(0);
    uint _123 = uint(32);
    uint _125 = uint(0);
    uint _127 = uint(0);
    f16vec2 _96[256] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
    uint _97 = 0u;
    uint _128;
    for (;;)
    {
        _128 = _97;
        if (_128 < 32u)
        {
            uint _130 = _128 / 2u;
            uint _132 = (_128 % 2u) * 16u;
            uint _133 = _130 * 32u;
            f16vec2 _99 = f16vec2(C.data[((_125 + _130) * _123) + (_127 + _132)], C.data[((_125 + _130) * _123) + (_127 + (_132 + 1u))]);
            uint _151 = _132 + 2u;
            f16vec2 _100 = f16vec2(C.data[((_125 + _130) * _123) + (_127 + _151)], C.data[((_125 + _130) * _123) + (_127 + (_151 + 1u))]);
            uint _169 = _132 + 4u;
            f16vec2 _101 = f16vec2(C.data[((_125 + _130) * _123) + (_127 + _169)], C.data[((_125 + _130) * _123) + (_127 + (_169 + 1u))]);
            uint _187 = _132 + 6u;
            f16vec2 _102 = f16vec2(C.data[((_125 + _130) * _123) + (_127 + _187)], C.data[((_125 + _130) * _123) + (_127 + (_187 + 1u))]);
            uint _205 = _132 + 8u;
            f16vec2 _103 = f16vec2(C.data[((_125 + _130) * _123) + (_127 + _205)], C.data[((_125 + _130) * _123) + (_127 + (_205 + 1u))]);
            uint _223 = _132 + 10u;
            f16vec2 _104 = f16vec2(C.data[((_125 + _130) * _123) + (_127 + _223)], C.data[((_125 + _130) * _123) + (_127 + (_223 + 1u))]);
            uint _241 = _132 + 12u;
            f16vec2 _105 = f16vec2(C.data[((_125 + _130) * _123) + (_127 + _241)], C.data[((_125 + _130) * _123) + (_127 + (_241 + 1u))]);
            uint _259 = _132 + 14u;
            f16vec2 _106 = f16vec2(C.data[((_125 + _130) * _123) + (_127 + _259)], C.data[((_125 + _130) * _123) + (_127 + (_259 + 1u))]);
            uint _98 = 0u;
            uint _276;
            for (;;)
            {
                _276 = _98;
                if (_276 < 16u)
                {
                    f16vec2 _286 = f16vec2(A.data[((_113 + _130) * _111) + (_115 + _276)]);
                    uint _287 = _276 * 32u;
                    _99 = fma(_286, f16vec2(B.data[((_119 + _276) * _117) + (_121 + _132)], B.data[((_119 + _276) * _117) + (_121 + (_132 + 1u))]), _99);
                    uint _306 = _132 + 2u;
                    _100 = fma(_286, f16vec2(B.data[((_119 + _276) * _117) + (_121 + _306)], B.data[((_119 + _276) * _117) + (_121 + (_306 + 1u))]), _100);
                    uint _325 = _132 + 4u;
                    _101 = fma(_286, f16vec2(B.data[((_119 + _276) * _117) + (_121 + _325)], B.data[((_119 + _276) * _117) + (_121 + (_325 + 1u))]), _101);
                    uint _344 = _132 + 6u;
                    _102 = fma(_286, f16vec2(B.data[((_119 + _276) * _117) + (_121 + _344)], B.data[((_119 + _276) * _117) + (_121 + (_344 + 1u))]), _102);
                    uint _363 = _132 + 8u;
                    _103 = fma(_286, f16vec2(B.data[((_119 + _276) * _117) + (_121 + _363)], B.data[((_119 + _276) * _117) + (_121 + (_363 + 1u))]), _103);
                    uint _382 = _132 + 10u;
                    _104 = fma(_286, f16vec2(B.data[((_119 + _276) * _117) + (_121 + _382)], B.data[((_119 + _276) * _117) + (_121 + (_382 + 1u))]), _104);
                    uint _401 = _132 + 12u;
                    _105 = fma(_286, f16vec2(B.data[((_119 + _276) * _117) + (_121 + _401)], B.data[((_119 + _276) * _117) + (_121 + (_401 + 1u))]), _105);
                    uint _420 = _132 + 14u;
                    _106 = fma(_286, f16vec2(B.data[((_119 + _276) * _117) + (_121 + _420)], B.data[((_119 + _276) * _117) + (_121 + (_420 + 1u))]), _106);
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

void _477(uint _478, f16vec2 _479)
{
    D.data[_478] = _479.x;
    D.data[_478 + 1u] = _479.y;
}

void main()
{
    f16vec2 _58[256] = _77();
    f16vec2 tempArg[256] = _58;
    f16vec2 d[256] = _58;
    f16vec2 _488[256] = _58;
    uint _489 = 0u;
    uint _494;
    for (;;)
    {
        _494 = _489;
        if (_494 < 512u)
        {
            _477(((uint(0) + (_494 / 32u)) * uint(32)) + (uint(0) + (_494 % 32u)), _488[_494 / 2u]);
            _489 = _494 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

