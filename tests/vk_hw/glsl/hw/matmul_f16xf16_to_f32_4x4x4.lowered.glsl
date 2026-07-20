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

f16vec4 _74(uint _75)
{
    return f16vec4(A.data[_75], A.data[_75 + 1u], A.data[_75 + 2u], A.data[_75 + 3u]);
}

f16vec4 _124(uint _125)
{
    return f16vec4(B.data[_125], B.data[_125 + 1u], B.data[_125 + 2u], B.data[_125 + 3u]);
}

vec4 _166(uint _167)
{
    return vec4(C.data[_167], C.data[_167 + 1u], C.data[_167 + 2u], C.data[_167 + 3u]);
}

void _535(uint _536, vec4 _537)
{
    D.data[_536] = _537.x;
    D.data[_536 + 1u] = _537.y;
    D.data[_536 + 2u] = _537.z;
    D.data[_536 + 3u] = _537.w;
}

void main()
{
    uint _100 = 0u;
    f16vec4 _99[4];
    uint _105;
    for (;;)
    {
        _105 = _100;
        if (_105 < 16u)
        {
            _99[_105 / 4u] = _74(((uint(0) + (_105 / 4u)) * uint(4)) + (uint(0) + (_105 % 4u)));
            _100 = _105 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _24[4] = _99;
    f16vec4 tempArg[4] = _24;
    f16vec4 a[4] = _24;
    uint _141 = 0u;
    f16vec4 _140[4];
    uint _146;
    for (;;)
    {
        _146 = _141;
        if (_146 < 16u)
        {
            _140[_146 / 4u] = _124(((uint(0) + (_146 / 4u)) * uint(4)) + (uint(0) + (_146 % 4u)));
            _141 = _146 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _36[4] = _140;
    f16vec4 tempArg_1[4] = _36;
    f16vec4 b[4] = _36;
    uint _186 = 0u;
    vec4 _185[4];
    uint _191;
    for (;;)
    {
        _191 = _186;
        if (_191 < 16u)
        {
            _185[_191 / 4u] = _166(((uint(0) + (_191 / 4u)) * uint(4)) + (uint(0) + (_191 % 4u)));
            _186 = _191 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _49[4] = _185;
    vec4 tempArg_2[4] = _49;
    vec4 bias[4] = _49;
    vec4 _56[4] = vec4[](vec4(fma(float(_24[0].w), float(_36[3].x), fma(float(_24[0].z), float(_36[2].x), fma(float(_24[0].y), float(_36[1].x), fma(float(_24[0].x), float(_36[0].x), _49[0].x)))), fma(float(_24[0].w), float(_36[3].y), fma(float(_24[0].z), float(_36[2].y), fma(float(_24[0].y), float(_36[1].y), fma(float(_24[0].x), float(_36[0].y), _49[0].y)))), fma(float(_24[0].w), float(_36[3].z), fma(float(_24[0].z), float(_36[2].z), fma(float(_24[0].y), float(_36[1].z), fma(float(_24[0].x), float(_36[0].z), _49[0].z)))), fma(float(_24[0].w), float(_36[3].w), fma(float(_24[0].z), float(_36[2].w), fma(float(_24[0].y), float(_36[1].w), fma(float(_24[0].x), float(_36[0].w), _49[0].w))))), vec4(fma(float(_24[1].w), float(_36[3].x), fma(float(_24[1].z), float(_36[2].x), fma(float(_24[1].y), float(_36[1].x), fma(float(_24[1].x), float(_36[0].x), _49[1].x)))), fma(float(_24[1].w), float(_36[3].y), fma(float(_24[1].z), float(_36[2].y), fma(float(_24[1].y), float(_36[1].y), fma(float(_24[1].x), float(_36[0].y), _49[1].y)))), fma(float(_24[1].w), float(_36[3].z), fma(float(_24[1].z), float(_36[2].z), fma(float(_24[1].y), float(_36[1].z), fma(float(_24[1].x), float(_36[0].z), _49[1].z)))), fma(float(_24[1].w), float(_36[3].w), fma(float(_24[1].z), float(_36[2].w), fma(float(_24[1].y), float(_36[1].w), fma(float(_24[1].x), float(_36[0].w), _49[1].w))))), vec4(fma(float(_24[2].w), float(_36[3].x), fma(float(_24[2].z), float(_36[2].x), fma(float(_24[2].y), float(_36[1].x), fma(float(_24[2].x), float(_36[0].x), _49[2].x)))), fma(float(_24[2].w), float(_36[3].y), fma(float(_24[2].z), float(_36[2].y), fma(float(_24[2].y), float(_36[1].y), fma(float(_24[2].x), float(_36[0].y), _49[2].y)))), fma(float(_24[2].w), float(_36[3].z), fma(float(_24[2].z), float(_36[2].z), fma(float(_24[2].y), float(_36[1].z), fma(float(_24[2].x), float(_36[0].z), _49[2].z)))), fma(float(_24[2].w), float(_36[3].w), fma(float(_24[2].z), float(_36[2].w), fma(float(_24[2].y), float(_36[1].w), fma(float(_24[2].x), float(_36[0].w), _49[2].w))))), vec4(fma(float(_24[3].w), float(_36[3].x), fma(float(_24[3].z), float(_36[2].x), fma(float(_24[3].y), float(_36[1].x), fma(float(_24[3].x), float(_36[0].x), _49[3].x)))), fma(float(_24[3].w), float(_36[3].y), fma(float(_24[3].z), float(_36[2].y), fma(float(_24[3].y), float(_36[1].y), fma(float(_24[3].x), float(_36[0].y), _49[3].y)))), fma(float(_24[3].w), float(_36[3].z), fma(float(_24[3].z), float(_36[2].z), fma(float(_24[3].y), float(_36[1].z), fma(float(_24[3].x), float(_36[0].z), _49[3].z)))), fma(float(_24[3].w), float(_36[3].w), fma(float(_24[3].z), float(_36[2].w), fma(float(_24[3].y), float(_36[1].w), fma(float(_24[3].x), float(_36[0].w), _49[3].w))))));
    vec4 tempArg_3[4] = _56;
    vec4 d[4] = _56;
    vec4 _551[4] = _56;
    uint _552 = 0u;
    uint _557;
    for (;;)
    {
        _557 = _552;
        if (_557 < 16u)
        {
            _535(((uint(0) + (_557 / 4u)) * uint(4)) + (uint(0) + (_557 % 4u)), _551[_557 / 4u]);
            _552 = _557 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

