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
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec2[8] _75()
{
    vec2 _93[8] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _94 = 0u;
    uint _100;
    for (;;)
    {
        _100 = _94;
        if (_100 < 16u)
        {
            float _96 = 0.0;
            uint _95 = 0u;
            uint _102;
            for (;;)
            {
                _102 = _95;
                if (_102 < 4u)
                {
                    uint _107 = ((_100 / 4u) * 4u) + _102;
                    uint _109 = (_102 * 4u) + (_100 % 4u);
                    _96 = fma(float(A.data[((uint(0) + (_107 / 4u)) * uint(4)) + (uint(0) + (_107 % 4u))]), float(B.data[((uint(0) + (_109 / 4u)) * uint(4)) + (uint(0) + (_109 % 4u))]), _96);
                    _95 = _102 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            uint _162 = _100 / 2u;
            vec2 _167 = _93[_162];
            _167[_100 % 2u] = _96 + C.data[((uint(0) + (_100 / 4u)) * uint(4)) + (uint(0) + (_100 % 4u))];
            _93[_162] = _167;
            _94 = _100 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _93;
}

void _171(uint _172, vec2 _173)
{
    D.data[_172] = _173.x;
    D.data[_172 + 1u] = _173.y;
}

void main()
{
    vec2 _56[8] = _75();
    vec2 tempArg[8] = _56;
    vec2 d[8] = _56;
    vec2 _181[8] = _56;
    uint _182 = 0u;
    uint _187;
    for (;;)
    {
        _187 = _182;
        if (_187 < 16u)
        {
            _171(((uint(0) + (_187 / 4u)) * uint(4)) + (uint(0) + (_187 % 4u)), _181[_187 / 2u]);
            _182 = _187 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

