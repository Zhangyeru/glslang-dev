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
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

layout(set = 0, binding = 4, std430) buffer OutputE
{
    float16_t data[];
} E;

f16vec2 _91(uint _92)
{
    return f16vec2(B.data[_92], B.data[_92 + 1u]);
}

f16vec2 _79(uint _80)
{
    return f16vec2(A.data[_80], A.data[_80 + 1u]);
}

f16vec2 _101(uint _102)
{
    return f16vec2(C.data[_102], C.data[_102 + 1u]);
}

f16vec2[512] _119()
{
    uint _134 = 0u;
    f16vec2 _133[512];
    uint _139;
    for (;;)
    {
        _139 = _134;
        if (_139 < 32u)
        {
            uint _135 = 0u;
            uint _141;
            for (;;)
            {
                _141 = _135;
                if (_141 < 16u)
                {
                    f16vec2 _137 = f16vec2(float16_t(0.0));
                    f16vec2 _138 = f16vec2(float16_t(0.0));
                    uint _136 = 0u;
                    uint _143;
                    for (;;)
                    {
                        _143 = _136;
                        if (_143 < 16u)
                        {
                            uint _145 = _143 * 2u;
                            uint _147 = (_139 * 32u) + _145;
                            f16vec2 _160 = _79(((uint(0) + (_147 / 32u)) * uint(32)) + (uint(0) + (_147 % 32u)));
                            uint _164 = ((_145 + 0u) * 32u) + (_141 * 2u);
                            f16vec2 _177 = _91(((uint(0) + (_164 / 32u)) * uint(32)) + (uint(0) + (_164 % 32u)));
                            uint _181 = ((_145 + 1u) * 32u) + (_141 * 2u);
                            f16vec2 _194 = _91(((uint(0) + (_181 / 32u)) * uint(32)) + (uint(0) + (_181 % 32u)));
                            _137 = fma(_160, f16vec2(_177.x, _194.x), _137);
                            _138 = fma(_160, f16vec2(_177.y, _194.y), _138);
                            _136 = _143 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _210 = (_139 * 32u) + (_141 * 2u);
                    f16vec2 _223 = _101(((uint(0) + (_210 / 32u)) * uint(32)) + (uint(0) + (_210 % 32u)));
                    _133[(_139 * 16u) + _141] = f16vec2(_223.x + (_137.x + _137.y), _223.y + (_138.x + _138.y));
                    _135 = _141 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _134 = _139 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _133;
}

void _268(uint _269, f16vec2 _270)
{
    D.data[_269] = _270.x;
    D.data[_269 + 1u] = _270.y;
}

void _303(uint _304, f16vec2 _305)
{
    E.data[_304] = _305.x;
    E.data[_304 + 1u] = _305.y;
}

void main()
{
    uint _243 = 0u;
    f16vec2 _242[512];
    uint _248;
    for (;;)
    {
        _248 = _243;
        if (_248 < 1024u)
        {
            _242[_248 / 2u] = _91(((uint(0) + (_248 / 32u)) * uint(32)) + (uint(0) + (_248 % 32u)));
            _243 = _248 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _36[512] = _242;
    f16vec2 tempArg[512] = _36;
    f16vec2 w[512] = _36;
    f16vec2 _55[512] = _119();
    f16vec2 tempArg_1[512] = _55;
    f16vec2 d[512] = _55;
    f16vec2 _278[512] = _55;
    uint _279 = 0u;
    uint _284;
    for (;;)
    {
        _284 = _279;
        if (_284 < 1024u)
        {
            _268(((uint(0) + (_284 / 32u)) * uint(32)) + (uint(0) + (_284 % 32u)), _278[_284 / 2u]);
            _279 = _284 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _313[512] = _36;
    uint _314 = 0u;
    uint _319;
    for (;;)
    {
        _319 = _314;
        if (_319 < 1024u)
        {
            _303(((uint(0) + (_319 / 32u)) * uint(32)) + (uint(0) + (_319 % 32u)), _313[_319 / 2u]);
            _314 = _319 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

