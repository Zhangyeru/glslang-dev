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

f16vec2 _79(uint _80)
{
    return f16vec2(X.data[_80], X.data[_80 + 1u]);
}

f16vec2 _90(uint _91)
{
    return f16vec2(W.data[_91], W.data[_91 + 1u]);
}

float16_t[3] _101()
{
    uint _118 = 0u;
    float16_t _117[3];
    uint _119;
    f16vec2 _120;
    uint _124;
    for (;;)
    {
        _124 = _118;
        if (_124 < 1u)
        {
            _120 = f16vec2(float16_t(0.0));
            f16vec2 _121 = f16vec2(float16_t(0.0));
            _119 = 0u;
            uint _126;
            for (;;)
            {
                _126 = _119;
                if (_126 < 2u)
                {
                    uint _128 = _126 * 2u;
                    uint _129 = _124 * 2u;
                    f16vec2 _130 = _79(_128);
                    uint _132 = (_128 * 3u) + _129;
                    f16vec2 _145 = _90(((uint(0) + (_132 / 3u)) * uint(3)) + (uint(0) + (_132 % 3u)));
                    uint _148 = ((_128 + 1u) * 3u) + _129;
                    f16vec2 _161 = _90(((uint(0) + (_148 / 3u)) * uint(3)) + (uint(0) + (_148 % 3u)));
                    _120 = fma(_130, f16vec2(_145.x, _161.x), _120);
                    _121 = fma(_130, f16vec2(_145.y, _161.y), _121);
                    _119 = _126 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            uint _173 = _124 * 2u;
            f16vec2 _176 = f16vec2(X.data[4u], float16_t(0.0));
            uint _177 = 4u * 3u;
            uint _178 = _177 + _173;
            f16vec2 _191 = _90(((uint(0) + (_178 / 3u)) * uint(3)) + (uint(0) + (_178 % 3u)));
            _120 = fma(_176, f16vec2(_191.x, float16_t(0.0)), _120);
            _121 = fma(_176, f16vec2(_191.y, float16_t(0.0)), _121);
            f16vec2 _208 = f16vec2(_120.x + _120.y, _121.x + _121.y);
            _117[_173] = _208.x;
            _117[_173 + 1u] = _208.y;
            _118 = _124 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    _120 = f16vec2(float16_t(0.0));
    _119 = 0u;
    uint _215;
    for (;;)
    {
        _215 = _119;
        if (_215 < 2u)
        {
            uint _217 = _215 * 2u;
            uint _220 = (_217 * 3u) + 2u;
            uint _237 = ((_217 + 1u) * 3u) + 2u;
            _120 = fma(_79(_217), f16vec2(W.data[((uint(0) + (_220 / 3u)) * uint(3)) + (uint(0) + (_220 % 3u))], W.data[((uint(0) + (_237 / 3u)) * uint(3)) + (uint(0) + (_237 % 3u))]), _120);
            _119 = _215 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    uint _259 = 4u * 3u;
    uint _260 = _259 + 2u;
    _120 = fma(f16vec2(X.data[4u], float16_t(0.0)), f16vec2(W.data[((uint(0) + (_260 / 3u)) * uint(3)) + (uint(0) + (_260 % 3u))], float16_t(0.0)), _120);
    _117[2u] = _120.x + _120.y;
    return _117;
}

void main()
{
    float16_t _47[3] = _101();
    float16_t tempArg[3] = _47;
    float16_t y[3] = _47;
    uint _285 = 0u + 0u;
    Y.data[_285] = _47[0];
    uint _288 = 0u + 1u;
    Y.data[_288] = _47[1];
    uint _291 = 0u + 2u;
    Y.data[_291] = _47[2];
}

