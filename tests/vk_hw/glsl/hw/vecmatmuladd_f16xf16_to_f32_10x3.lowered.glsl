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

f16vec2 _90(uint _91)
{
    return f16vec2(X.data[_91], X.data[_91 + 1u]);
}

f16vec2 _101(uint _102)
{
    return f16vec2(W.data[_102], W.data[_102 + 1u]);
}

vec2 _112(uint _113)
{
    return vec2(Bias.data[_113], Bias.data[_113 + 1u]);
}

float[3] _124()
{
    uint _141 = 0u;
    float _140[3];
    uint _142;
    vec2 _143;
    uint _148;
    for (;;)
    {
        _148 = _141;
        if (_148 < 1u)
        {
            _143 = vec2(0.0);
            vec2 _144 = vec2(0.0);
            _142 = 0u;
            uint _150;
            for (;;)
            {
                _150 = _142;
                if (_150 < 5u)
                {
                    uint _152 = _150 * 2u;
                    uint _153 = _148 * 2u;
                    vec2 _155 = vec2(_90(_152));
                    uint _157 = (_152 * 3u) + _153;
                    f16vec2 _170 = _101(((uint(0) + (_157 / 3u)) * uint(3)) + (uint(0) + (_157 % 3u)));
                    uint _173 = ((_152 + 1u) * 3u) + _153;
                    f16vec2 _186 = _101(((uint(0) + (_173 / 3u)) * uint(3)) + (uint(0) + (_173 % 3u)));
                    _143 = fma(_155, vec2(f16vec2(_170.x, _186.x)), _143);
                    _144 = fma(_155, vec2(f16vec2(_170.y, _186.y)), _144);
                    _142 = _150 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            uint _200 = _148 * 2u;
            vec2 _211 = vec2(_143.x + _143.y, _144.x + _144.y) + _112(_200);
            _140[_200] = _211.x;
            _140[_200 + 1u] = _211.y;
            _141 = _148 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    _143 = vec2(0.0);
    _142 = 0u;
    uint _218;
    for (;;)
    {
        _218 = _142;
        if (_218 < 5u)
        {
            uint _220 = _218 * 2u;
            uint _224 = (_220 * 3u) + 2u;
            uint _241 = ((_220 + 1u) * 3u) + 2u;
            _143 = fma(vec2(_90(_220)), vec2(f16vec2(W.data[((uint(0) + (_224 / 3u)) * uint(3)) + (uint(0) + (_224 % 3u))], W.data[((uint(0) + (_241 / 3u)) * uint(3)) + (uint(0) + (_241 % 3u))])), _143);
            _142 = _218 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    _140[2u] = (_143.x + _143.y) + Bias.data[2u];
    return _140;
}

void main()
{
    float _59[3] = _124();
    float tempArg[3] = _59;
    float y[3] = _59;
    uint _271 = 0u + 0u;
    Y.data[_271] = _59[0];
    uint _274 = 0u + 1u;
    Y.data[_274] = _59[1];
    uint _277 = 0u + 2u;
    Y.data[_277] = _59[2];
}

