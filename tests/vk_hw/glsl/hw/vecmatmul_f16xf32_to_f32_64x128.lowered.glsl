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
    float data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec2[64] _73()
{
    uint _107 = uint(128);
    uint _109 = uint(0);
    uint _111 = uint(0);
    vec2 _93[64] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _94 = 0u;
    uint _112;
    for (;;)
    {
        _112 = _94;
        if (_112 < 8u)
        {
            uint _114 = _112 * 16u;
            vec2 _96 = vec2(0.0);
            vec2 _97 = vec2(0.0);
            vec2 _98 = vec2(0.0);
            vec2 _99 = vec2(0.0);
            vec2 _100 = vec2(0.0);
            vec2 _101 = vec2(0.0);
            vec2 _102 = vec2(0.0);
            vec2 _103 = vec2(0.0);
            uint _95 = 0u;
            uint _144;
            for (;;)
            {
                _144 = _95;
                if (_144 < 64u)
                {
                    vec2 _150 = vec2(f16vec2(X.data[_144]));
                    _96 = fma(_150, vec2(W.data[((_109 + _144) * _107) + (_111 + _114)], W.data[((_109 + _144) * _107) + (_111 + (_114 + 1u))]), _96);
                    uint _168 = _114 + 2u;
                    _97 = fma(_150, vec2(W.data[((_109 + _144) * _107) + (_111 + _168)], W.data[((_109 + _144) * _107) + (_111 + (_168 + 1u))]), _97);
                    uint _185 = _114 + 4u;
                    _98 = fma(_150, vec2(W.data[((_109 + _144) * _107) + (_111 + _185)], W.data[((_109 + _144) * _107) + (_111 + (_185 + 1u))]), _98);
                    uint _202 = _114 + 6u;
                    _99 = fma(_150, vec2(W.data[((_109 + _144) * _107) + (_111 + _202)], W.data[((_109 + _144) * _107) + (_111 + (_202 + 1u))]), _99);
                    uint _219 = _114 + 8u;
                    _100 = fma(_150, vec2(W.data[((_109 + _144) * _107) + (_111 + _219)], W.data[((_109 + _144) * _107) + (_111 + (_219 + 1u))]), _100);
                    uint _236 = _114 + 10u;
                    _101 = fma(_150, vec2(W.data[((_109 + _144) * _107) + (_111 + _236)], W.data[((_109 + _144) * _107) + (_111 + (_236 + 1u))]), _101);
                    uint _253 = _114 + 12u;
                    _102 = fma(_150, vec2(W.data[((_109 + _144) * _107) + (_111 + _253)], W.data[((_109 + _144) * _107) + (_111 + (_253 + 1u))]), _102);
                    uint _270 = _114 + 14u;
                    _103 = fma(_150, vec2(W.data[((_109 + _144) * _107) + (_111 + _270)], W.data[((_109 + _144) * _107) + (_111 + (_270 + 1u))]), _103);
                    _95 = _144 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _93[_112 * 8u] = _96;
            _93[(_112 * 8u) + 1u] = _97;
            _93[(_112 * 8u) + 2u] = _98;
            _93[(_112 * 8u) + 3u] = _99;
            _93[(_112 * 8u) + 4u] = _100;
            _93[(_112 * 8u) + 5u] = _101;
            _93[(_112 * 8u) + 6u] = _102;
            _93[(_112 * 8u) + 7u] = _103;
            _94 = _112 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _93;
}

void _325(uint _326, vec2 _327)
{
    Y.data[_326] = _327.x;
    Y.data[_326 + 1u] = _327.y;
}

void main()
{
    vec2 _48[64] = _73();
    vec2 tempArg[64] = _48;
    vec2 y[64] = _48;
    vec2 _335[64] = _48;
    uint _336 = 0u;
    uint _341;
    for (;;)
    {
        _341 = _336;
        if (_341 < 128u)
        {
            _325(0u + _341, _335[_341 / 2u]);
            _336 = _341 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

