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
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

f16vec2 _75(uint _76)
{
    return f16vec2(A.data[_76], A.data[_76 + 1u]);
}

vec2 _119(uint _120)
{
    return vec2(B.data[_120], B.data[_120 + 1u]);
}

vec2 _157(uint _158)
{
    return vec2(C.data[_158], C.data[_158 + 1u]);
}

void _489(uint _490, vec2 _491)
{
    D.data[_490] = _491.x;
    D.data[_490 + 1u] = _491.y;
}

void main()
{
    uint _94 = 0u;
    f16vec2 _93[8];
    uint _99;
    for (;;)
    {
        _99 = _94;
        if (_99 < 16u)
        {
            _93[_99 / 2u] = _75(((uint(0) + (_99 / 4u)) * uint(4)) + (uint(0) + (_99 % 4u)));
            _94 = _99 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _24[8] = _93;
    f16vec2 tempArg[8] = _24;
    f16vec2 a[8] = _24;
    uint _133 = 0u;
    vec2 _132[8];
    uint _138;
    for (;;)
    {
        _138 = _133;
        if (_138 < 16u)
        {
            _132[_138 / 2u] = _119(((uint(0) + (_138 / 4u)) * uint(4)) + (uint(0) + (_138 % 4u)));
            _133 = _138 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _37[8] = _132;
    vec2 tempArg_1[8] = _37;
    vec2 b[8] = _37;
    uint _168 = 0u;
    vec2 _167[8];
    uint _173;
    for (;;)
    {
        _173 = _168;
        if (_173 < 16u)
        {
            _167[_173 / 2u] = _157(((uint(0) + (_173 / 4u)) * uint(4)) + (uint(0) + (_173 % 4u)));
            _168 = _173 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _49[8] = _167;
    vec2 tempArg_2[8] = _49;
    vec2 bias[8] = _49;
    vec2 _56[8] = vec2[](vec2(fma(float(_24[1].y), _37[6].x, fma(float(_24[1].x), _37[4].x, fma(float(_24[0].y), _37[2].x, fma(float(_24[0].x), _37[0].x, _49[0].x)))), fma(float(_24[1].y), _37[6].y, fma(float(_24[1].x), _37[4].y, fma(float(_24[0].y), _37[2].y, fma(float(_24[0].x), _37[0].y, _49[0].y))))), vec2(fma(float(_24[1].y), _37[7].x, fma(float(_24[1].x), _37[5].x, fma(float(_24[0].y), _37[3].x, fma(float(_24[0].x), _37[1].x, _49[1].x)))), fma(float(_24[1].y), _37[7].y, fma(float(_24[1].x), _37[5].y, fma(float(_24[0].y), _37[3].y, fma(float(_24[0].x), _37[1].y, _49[1].y))))), vec2(fma(float(_24[3].y), _37[6].x, fma(float(_24[3].x), _37[4].x, fma(float(_24[2].y), _37[2].x, fma(float(_24[2].x), _37[0].x, _49[2].x)))), fma(float(_24[3].y), _37[6].y, fma(float(_24[3].x), _37[4].y, fma(float(_24[2].y), _37[2].y, fma(float(_24[2].x), _37[0].y, _49[2].y))))), vec2(fma(float(_24[3].y), _37[7].x, fma(float(_24[3].x), _37[5].x, fma(float(_24[2].y), _37[3].x, fma(float(_24[2].x), _37[1].x, _49[3].x)))), fma(float(_24[3].y), _37[7].y, fma(float(_24[3].x), _37[5].y, fma(float(_24[2].y), _37[3].y, fma(float(_24[2].x), _37[1].y, _49[3].y))))), vec2(fma(float(_24[5].y), _37[6].x, fma(float(_24[5].x), _37[4].x, fma(float(_24[4].y), _37[2].x, fma(float(_24[4].x), _37[0].x, _49[4].x)))), fma(float(_24[5].y), _37[6].y, fma(float(_24[5].x), _37[4].y, fma(float(_24[4].y), _37[2].y, fma(float(_24[4].x), _37[0].y, _49[4].y))))), vec2(fma(float(_24[5].y), _37[7].x, fma(float(_24[5].x), _37[5].x, fma(float(_24[4].y), _37[3].x, fma(float(_24[4].x), _37[1].x, _49[5].x)))), fma(float(_24[5].y), _37[7].y, fma(float(_24[5].x), _37[5].y, fma(float(_24[4].y), _37[3].y, fma(float(_24[4].x), _37[1].y, _49[5].y))))), vec2(fma(float(_24[7].y), _37[6].x, fma(float(_24[7].x), _37[4].x, fma(float(_24[6].y), _37[2].x, fma(float(_24[6].x), _37[0].x, _49[6].x)))), fma(float(_24[7].y), _37[6].y, fma(float(_24[7].x), _37[4].y, fma(float(_24[6].y), _37[2].y, fma(float(_24[6].x), _37[0].y, _49[6].y))))), vec2(fma(float(_24[7].y), _37[7].x, fma(float(_24[7].x), _37[5].x, fma(float(_24[6].y), _37[3].x, fma(float(_24[6].x), _37[1].x, _49[7].x)))), fma(float(_24[7].y), _37[7].y, fma(float(_24[7].x), _37[5].y, fma(float(_24[6].y), _37[3].y, fma(float(_24[6].x), _37[1].y, _49[7].y))))));
    vec2 tempArg_3[8] = _56;
    vec2 d[8] = _56;
    vec2 _499[8] = _56;
    uint _500 = 0u;
    uint _505;
    for (;;)
    {
        _505 = _500;
        if (_505 < 16u)
        {
            _489(((uint(0) + (_505 / 4u)) * uint(4)) + (uint(0) + (_505 % 4u)), _499[_505 / 2u]);
            _500 = _505 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

