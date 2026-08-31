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

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

float16_t[5475] thirdLevel(float16_t value[5475])
{
    return value;
}

float16_t[5475] secondLevel(float16_t value[5475])
{
    float16_t param[5475] = value;
    float16_t _28[5475] = thirdLevel(param);
    float16_t carried[5475] = _28;
    return _28;
}

float16_t[5475] firstLevel(float16_t value[5475])
{
    float16_t param[5475] = value;
    float16_t _35[5475] = secondLevel(param);
    float16_t carried[5475] = _35;
    return _35;
}

void main()
{
    uint _86 = 0u;
    float16_t _85[5475];
    uint _91;
    for (;;)
    {
        _91 = _86;
        if (_91 < 5475u)
        {
            _85[_91] = A.data[((uint(0) + (_91 / 75u)) * uint(75)) + (uint(0) + (_91 % 75u))];
            _86 = _91 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float16_t _53[5475] = _85;
    float16_t tempArg[5475] = _53;
    float16_t value[5475] = _53;
    float16_t param[5475] = _53;
    float16_t _58[5475] = firstLevel(param);
    value = _58;
    float16_t _113[5475] = _58;
    uint _114 = 0u;
    uint _119;
    for (;;)
    {
        _119 = _114;
        if (_119 < 5475u)
        {
            D.data[((uint(0) + (_119 / 75u)) * uint(75)) + (uint(0) + (_119 % 75u))] = _113[_119];
            _114 = _119 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
}

