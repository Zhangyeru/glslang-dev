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

f16vec2 _96(uint _97)
{
    return f16vec2(X.data[_97], X.data[_97 + 1u]);
}

f16vec2 _107(uint _108)
{
    return f16vec2(W.data[_108], W.data[_108 + 1u]);
}

f16vec2 _117(uint _118)
{
    return f16vec2(Bias.data[_118], Bias.data[_118 + 1u]);
}

float[3] _128()
{
    uint _145 = 0u;
    float _144[3];
    uint _146;
    vec2 _147;
    uint _152;
    for (;;)
    {
        _152 = _145;
        if (_152 < 1u)
        {
            _147 = vec2(0.0);
            vec2 _148 = vec2(0.0);
            _146 = 0u;
            uint _154;
            for (;;)
            {
                _154 = _146;
                if (_154 < 5u)
                {
                    uint _156 = _154 * 2u;
                    uint _157 = _152 * 2u;
                    vec2 _159 = vec2(_96(_156));
                    uint _161 = (_156 * 3u) + _157;
                    f16vec2 _174 = _107(((uint(0) + (_161 / 3u)) * uint(3)) + (uint(0) + (_161 % 3u)));
                    uint _177 = ((_156 + 1u) * 3u) + _157;
                    f16vec2 _190 = _107(((uint(0) + (_177 / 3u)) * uint(3)) + (uint(0) + (_177 % 3u)));
                    _147 = fma(_159, vec2(f16vec2(_174.x, _190.x)), _147);
                    _148 = fma(_159, vec2(f16vec2(_174.y, _190.y)), _148);
                    _146 = _154 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            uint _204 = _152 * 2u;
            vec2 _216 = vec2(_147.x + _147.y, _148.x + _148.y) + vec2(_117(_204));
            _144[_204] = _216.x;
            _144[_204 + 1u] = _216.y;
            _145 = _152 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    _147 = vec2(0.0);
    _146 = 0u;
    uint _223;
    for (;;)
    {
        _223 = _146;
        if (_223 < 5u)
        {
            uint _225 = _223 * 2u;
            uint _229 = (_225 * 3u) + 2u;
            uint _246 = ((_225 + 1u) * 3u) + 2u;
            _147 = fma(vec2(_96(_225)), vec2(f16vec2(W.data[((uint(0) + (_229 / 3u)) * uint(3)) + (uint(0) + (_229 % 3u))], W.data[((uint(0) + (_246 / 3u)) * uint(3)) + (uint(0) + (_246 % 3u))])), _147);
            _146 = _223 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    _144[2u] = (_147.x + _147.y) + float(Bias.data[2u]);
    return _144;
}

void main()
{
    float _64[3] = _128();
    float tempArg[3] = _64;
    float y[3] = _64;
    uint _277 = 0u + 0u;
    Y.data[_277] = _64[0];
    uint _281 = 0u + 1u;
    Y.data[_281] = _64[1];
    uint _284 = 0u + 2u;
    Y.data[_284] = _64[2];
}

