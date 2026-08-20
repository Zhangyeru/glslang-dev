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

f16vec2 _72(uint _73)
{
    return f16vec2(A.data[_73], A.data[_73 + 1u]);
}

f16vec2 _84(uint _85)
{
    return f16vec2(B.data[_85], B.data[_85 + 1u]);
}

f16vec2 _94(uint _95)
{
    return f16vec2(C.data[_95], C.data[_95 + 1u]);
}

void _105(uint _106, f16vec2 _107)
{
    D.data[_106] = _107.x;
    D.data[_106 + 1u] = _107.y;
}

void _121()
{
    uint _135 = 0u;
    uint _140;
    for (;;)
    {
        _140 = _135;
        if (_140 < 32u)
        {
            uint _136 = 0u;
            uint _142;
            for (;;)
            {
                _142 = _136;
                if (_142 < 16u)
                {
                    f16vec2 _138 = f16vec2(float16_t(0.0));
                    f16vec2 _139 = f16vec2(float16_t(0.0));
                    uint _137 = 0u;
                    uint _144;
                    for (;;)
                    {
                        _144 = _137;
                        if (_144 < 16u)
                        {
                            uint _146 = _144 * 2u;
                            uint _148 = (_140 * 32u) + _146;
                            f16vec2 _161 = _72(((uint(0) + (_148 / 32u)) * uint(32)) + (uint(0) + (_148 % 32u)));
                            uint _165 = ((_146 + 0u) * 32u) + (_142 * 2u);
                            f16vec2 _178 = _84(((uint(0) + (_165 / 32u)) * uint(32)) + (uint(0) + (_165 % 32u)));
                            uint _182 = ((_146 + 1u) * 32u) + (_142 * 2u);
                            f16vec2 _195 = _84(((uint(0) + (_182 / 32u)) * uint(32)) + (uint(0) + (_182 % 32u)));
                            _138 = fma(_161, f16vec2(_178.x, _195.x), _138);
                            _139 = fma(_161, f16vec2(_178.y, _195.y), _139);
                            _137 = _144 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _209 = (_140 * 32u) + (_142 * 2u);
                    f16vec2 _222 = _94(((uint(0) + (_209 / 32u)) * uint(32)) + (uint(0) + (_209 % 32u)));
                    uint _238 = (_140 * 32u) + (_142 * 2u);
                    _105(((uint(0) + (_238 / 32u)) * uint(32)) + (uint(0) + (_238 % 32u)), f16vec2(_222.x + (_138.x + _138.y), _222.y + (_139.x + _139.y)));
                    _136 = _142 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _135 = _140 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
}

void main()
{
    _121();
}

