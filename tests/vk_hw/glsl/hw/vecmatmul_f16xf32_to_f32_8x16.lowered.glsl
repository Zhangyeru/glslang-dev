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
    float data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

f16vec2 _73(uint _74)
{
    return f16vec2(X.data[_74], X.data[_74 + 1u]);
}

vec2 _104(uint _105)
{
    return vec2(W.data[_105], W.data[_105 + 1u]);
}

void _793(uint _794, vec2 _795)
{
    Y.data[_794] = _795.x;
    Y.data[_794 + 1u] = _795.y;
}

void main()
{
    uint _90 = 0u;
    f16vec2 _89[4];
    uint _95;
    for (;;)
    {
        _95 = _90;
        if (_95 < 8u)
        {
            _89[_95 / 2u] = _73(0u + _95);
            _90 = _95 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _21[4] = _89;
    f16vec2 tempArg[4] = _21;
    f16vec2 x[4] = _21;
    uint _119 = 0u;
    vec2 _118[64];
    uint _124;
    for (;;)
    {
        _124 = _119;
        if (_124 < 128u)
        {
            _118[_124 / 2u] = _104(((uint(0) + (_124 / 16u)) * uint(16)) + (uint(0) + (_124 % 16u)));
            _119 = _124 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _40[64] = _118;
    vec2 tempArg_1[64] = _40;
    vec2 w[64] = _40;
    vec2 _48[8] = vec2[](vec2(fma(float(_21[3].y), _40[56].x, fma(float(_21[3].x), _40[48].x, fma(float(_21[2].y), _40[40].x, fma(float(_21[2].x), _40[32].x, fma(float(_21[1].y), _40[24].x, fma(float(_21[1].x), _40[16].x, fma(float(_21[0].y), _40[8].x, fma(float(_21[0].x), _40[0].x, 0.0)))))))), fma(float(_21[3].y), _40[56].y, fma(float(_21[3].x), _40[48].y, fma(float(_21[2].y), _40[40].y, fma(float(_21[2].x), _40[32].y, fma(float(_21[1].y), _40[24].y, fma(float(_21[1].x), _40[16].y, fma(float(_21[0].y), _40[8].y, fma(float(_21[0].x), _40[0].y, 0.0))))))))), vec2(fma(float(_21[3].y), _40[57].x, fma(float(_21[3].x), _40[49].x, fma(float(_21[2].y), _40[41].x, fma(float(_21[2].x), _40[33].x, fma(float(_21[1].y), _40[25].x, fma(float(_21[1].x), _40[17].x, fma(float(_21[0].y), _40[9].x, fma(float(_21[0].x), _40[1].x, 0.0)))))))), fma(float(_21[3].y), _40[57].y, fma(float(_21[3].x), _40[49].y, fma(float(_21[2].y), _40[41].y, fma(float(_21[2].x), _40[33].y, fma(float(_21[1].y), _40[25].y, fma(float(_21[1].x), _40[17].y, fma(float(_21[0].y), _40[9].y, fma(float(_21[0].x), _40[1].y, 0.0))))))))), vec2(fma(float(_21[3].y), _40[58].x, fma(float(_21[3].x), _40[50].x, fma(float(_21[2].y), _40[42].x, fma(float(_21[2].x), _40[34].x, fma(float(_21[1].y), _40[26].x, fma(float(_21[1].x), _40[18].x, fma(float(_21[0].y), _40[10].x, fma(float(_21[0].x), _40[2].x, 0.0)))))))), fma(float(_21[3].y), _40[58].y, fma(float(_21[3].x), _40[50].y, fma(float(_21[2].y), _40[42].y, fma(float(_21[2].x), _40[34].y, fma(float(_21[1].y), _40[26].y, fma(float(_21[1].x), _40[18].y, fma(float(_21[0].y), _40[10].y, fma(float(_21[0].x), _40[2].y, 0.0))))))))), vec2(fma(float(_21[3].y), _40[59].x, fma(float(_21[3].x), _40[51].x, fma(float(_21[2].y), _40[43].x, fma(float(_21[2].x), _40[35].x, fma(float(_21[1].y), _40[27].x, fma(float(_21[1].x), _40[19].x, fma(float(_21[0].y), _40[11].x, fma(float(_21[0].x), _40[3].x, 0.0)))))))), fma(float(_21[3].y), _40[59].y, fma(float(_21[3].x), _40[51].y, fma(float(_21[2].y), _40[43].y, fma(float(_21[2].x), _40[35].y, fma(float(_21[1].y), _40[27].y, fma(float(_21[1].x), _40[19].y, fma(float(_21[0].y), _40[11].y, fma(float(_21[0].x), _40[3].y, 0.0))))))))), vec2(fma(float(_21[3].y), _40[60].x, fma(float(_21[3].x), _40[52].x, fma(float(_21[2].y), _40[44].x, fma(float(_21[2].x), _40[36].x, fma(float(_21[1].y), _40[28].x, fma(float(_21[1].x), _40[20].x, fma(float(_21[0].y), _40[12].x, fma(float(_21[0].x), _40[4].x, 0.0)))))))), fma(float(_21[3].y), _40[60].y, fma(float(_21[3].x), _40[52].y, fma(float(_21[2].y), _40[44].y, fma(float(_21[2].x), _40[36].y, fma(float(_21[1].y), _40[28].y, fma(float(_21[1].x), _40[20].y, fma(float(_21[0].y), _40[12].y, fma(float(_21[0].x), _40[4].y, 0.0))))))))), vec2(fma(float(_21[3].y), _40[61].x, fma(float(_21[3].x), _40[53].x, fma(float(_21[2].y), _40[45].x, fma(float(_21[2].x), _40[37].x, fma(float(_21[1].y), _40[29].x, fma(float(_21[1].x), _40[21].x, fma(float(_21[0].y), _40[13].x, fma(float(_21[0].x), _40[5].x, 0.0)))))))), fma(float(_21[3].y), _40[61].y, fma(float(_21[3].x), _40[53].y, fma(float(_21[2].y), _40[45].y, fma(float(_21[2].x), _40[37].y, fma(float(_21[1].y), _40[29].y, fma(float(_21[1].x), _40[21].y, fma(float(_21[0].y), _40[13].y, fma(float(_21[0].x), _40[5].y, 0.0))))))))), vec2(fma(float(_21[3].y), _40[62].x, fma(float(_21[3].x), _40[54].x, fma(float(_21[2].y), _40[46].x, fma(float(_21[2].x), _40[38].x, fma(float(_21[1].y), _40[30].x, fma(float(_21[1].x), _40[22].x, fma(float(_21[0].y), _40[14].x, fma(float(_21[0].x), _40[6].x, 0.0)))))))), fma(float(_21[3].y), _40[62].y, fma(float(_21[3].x), _40[54].y, fma(float(_21[2].y), _40[46].y, fma(float(_21[2].x), _40[38].y, fma(float(_21[1].y), _40[30].y, fma(float(_21[1].x), _40[22].y, fma(float(_21[0].y), _40[14].y, fma(float(_21[0].x), _40[6].y, 0.0))))))))), vec2(fma(float(_21[3].y), _40[63].x, fma(float(_21[3].x), _40[55].x, fma(float(_21[2].y), _40[47].x, fma(float(_21[2].x), _40[39].x, fma(float(_21[1].y), _40[31].x, fma(float(_21[1].x), _40[23].x, fma(float(_21[0].y), _40[15].x, fma(float(_21[0].x), _40[7].x, 0.0)))))))), fma(float(_21[3].y), _40[63].y, fma(float(_21[3].x), _40[55].y, fma(float(_21[2].y), _40[47].y, fma(float(_21[2].x), _40[39].y, fma(float(_21[1].y), _40[31].y, fma(float(_21[1].x), _40[23].y, fma(float(_21[0].y), _40[15].y, fma(float(_21[0].x), _40[7].y, 0.0))))))))));
    vec2 tempArg_2[8] = _48;
    vec2 y[8] = _48;
    vec2 _804[8] = _48;
    uint _805 = 0u;
    uint _810;
    for (;;)
    {
        _810 = _805;
        if (_810 < 16u)
        {
            _793(0u + _810, _804[_810 / 2u]);
            _805 = _810 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

