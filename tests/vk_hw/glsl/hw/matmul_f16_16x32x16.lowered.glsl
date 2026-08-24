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

f16vec2 _77(uint _78)
{
    return f16vec2(A.data[_78], A.data[_78 + 1u]);
}

f16vec2 _89(uint _90)
{
    return f16vec2(B.data[_90], B.data[_90 + 1u]);
}

f16vec2 _99(uint _100)
{
    return f16vec2(C.data[_100], C.data[_100 + 1u]);
}

f16vec2[256] _117()
{
    uint _132 = 0u;
    f16vec2 _131[256];
    uint _137;
    for (;;)
    {
        _137 = _132;
        if (_137 < 16u)
        {
            uint _133 = 0u;
            uint _139;
            for (;;)
            {
                _139 = _133;
                if (_139 < 16u)
                {
                    f16vec2 _135 = f16vec2(float16_t(0.0));
                    f16vec2 _136 = f16vec2(float16_t(0.0));
                    uint _134 = 0u;
                    uint _141;
                    for (;;)
                    {
                        _141 = _134;
                        if (_141 < 8u)
                        {
                            uint _143 = _141 * 2u;
                            uint _145 = (_137 * 16u) + _143;
                            f16vec2 _158 = _77(((uint(0) + (_145 / 16u)) * uint(16)) + (uint(0) + (_145 % 16u)));
                            uint _162 = ((_143 + 0u) * 32u) + (_139 * 2u);
                            f16vec2 _175 = _89(((uint(0) + (_162 / 32u)) * uint(32)) + (uint(0) + (_162 % 32u)));
                            uint _179 = ((_143 + 1u) * 32u) + (_139 * 2u);
                            f16vec2 _192 = _89(((uint(0) + (_179 / 32u)) * uint(32)) + (uint(0) + (_179 % 32u)));
                            _135 = fma(_158, f16vec2(_175.x, _192.x), _135);
                            _136 = fma(_158, f16vec2(_175.y, _192.y), _136);
                            _134 = _141 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _208 = (_137 * 32u) + (_139 * 2u);
                    f16vec2 _221 = _99(((uint(0) + (_208 / 32u)) * uint(32)) + (uint(0) + (_208 % 32u)));
                    _131[(_137 * 16u) + _139] = f16vec2(_221.x + (_135.x + _135.y), _221.y + (_136.x + _136.y));
                    _133 = _139 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _132 = _137 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _131;
}

void _240(uint _241, f16vec2 _242)
{
    D.data[_241] = _242.x;
    D.data[_241 + 1u] = _242.y;
}

void main()
{
    f16vec2 _58[256] = _117();
    f16vec2 tempArg[256] = _58;
    f16vec2 d[256] = _58;
    f16vec2 _251[256] = _58;
    uint _252 = 0u;
    uint _257;
    for (;;)
    {
        _257 = _252;
        if (_257 < 512u)
        {
            _240(((uint(0) + (_257 / 32u)) * uint(32)) + (uint(0) + (_257 % 32u)), _251[_257 / 2u]);
            _252 = _257 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

