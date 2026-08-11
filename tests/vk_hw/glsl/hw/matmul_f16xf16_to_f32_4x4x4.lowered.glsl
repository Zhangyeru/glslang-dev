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

vec4[4] _74()
{
    vec4 _92[4] = vec4[](vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0));
    uint _93 = 0u;
    uint _99;
    for (;;)
    {
        _99 = _93;
        if (_99 < 16u)
        {
            float _95 = 0.0;
            uint _94 = 0u;
            uint _101;
            for (;;)
            {
                _101 = _94;
                if (_101 < 4u)
                {
                    uint _106 = ((_99 / 4u) * 4u) + _101;
                    uint _108 = (_101 * 4u) + (_99 % 4u);
                    _95 = fma(float(A.data[((uint(0) + (_106 / 4u)) * uint(4)) + (uint(0) + (_106 % 4u))]), float(B.data[((uint(0) + (_108 / 4u)) * uint(4)) + (uint(0) + (_108 % 4u))]), _95);
                    _94 = _101 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            uint _160 = _99 / 4u;
            vec4 _165 = _92[_160];
            _165[_99 % 4u] = _95 + C.data[((uint(0) + (_99 / 4u)) * uint(4)) + (uint(0) + (_99 % 4u))];
            _92[_160] = _165;
            _93 = _99 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _92;
}

void _169(uint _170, vec4 _171)
{
    D.data[_170] = _171.x;
    D.data[_170 + 1u] = _171.y;
    D.data[_170 + 2u] = _171.z;
    D.data[_170 + 3u] = _171.w;
}

void main()
{
    vec4 _56[4] = _74();
    vec4 tempArg[4] = _56;
    vec4 d[4] = _56;
    vec4 _187[4] = _56;
    uint _188 = 0u;
    uint _193;
    for (;;)
    {
        _193 = _188;
        if (_193 < 16u)
        {
            _169(((uint(0) + (_193 / 4u)) * uint(4)) + (uint(0) + (_193 % 4u)), _187[_193 / 4u]);
            _188 = _193 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

