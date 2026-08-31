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

struct SwitchValues
{
    float16_t first[4899];
    float16_t second[4899];
};

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

float16_t[4899] selectWithSwitch(SwitchValues values, uint selector)
{
    float16_t selected[4899];
    switch (selector % 3u)
    {
        case 0u:
        {
            selected = values.first;
            break;
        }
        case 1u:
        {
            selected = values.second;
            break;
        }
        default:
        {
            selected = values.first;
            break;
        }
    }
    return selected;
}

void main()
{
    uint _97 = 0u;
    float16_t _96[4899];
    uint _102;
    for (;;)
    {
        _102 = _97;
        if (_102 < 4899u)
        {
            _96[_102] = A.data[((uint(0) + (_102 / 71u)) * uint(71)) + (uint(0) + (_102 % 71u))];
            _97 = _102 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float16_t _56[4899] = _96;
    float16_t tempArg[4899] = _56;
    float16_t value[4899] = _56;
    SwitchValues values;
    values.first = _56;
    values.second = _56;
    SwitchValues param = values;
    uint param_1 = gl_LocalInvocationIndex;
    float16_t _70[4899] = selectWithSwitch(param, param_1);
    value = _70;
    float16_t _124[4899] = _70;
    uint _125 = 0u;
    uint _130;
    for (;;)
    {
        _130 = _125;
        if (_130 < 4899u)
        {
            D.data[((uint(0) + (_130 / 71u)) * uint(71)) + (uint(0) + (_130 % 71u))] = _124[_130];
            _125 = _130 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
}

