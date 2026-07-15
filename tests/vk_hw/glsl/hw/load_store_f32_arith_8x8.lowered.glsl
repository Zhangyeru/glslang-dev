#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec4 _32[16] = vec4[](vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0));
const vec4 _37[16] = vec4[](vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0), vec4(1.0));

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec4 _64(uint _65)
{
    return vec4(A.data[_65], A.data[_65 + 1u], A.data[_65 + 2u], A.data[_65 + 3u]);
}

void _213(uint _214, vec4 _215)
{
    D.data[_214] = _215.x;
    D.data[_214 + 1u] = _215.y;
    D.data[_214 + 2u] = _215.z;
    D.data[_214 + 3u] = _215.w;
}

void main()
{
    uint _91 = 0u;
    vec4 _90[16];
    uint _96;
    for (;;)
    {
        _96 = _91;
        if (_96 < 64u)
        {
            _90[_96 / 4u] = _64(((uint(0) + (_96 / 8u)) * uint(8)) + (uint(0) + (_96 % 8u)));
            _91 = _96 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _24[16] = _90;
    vec4 tempArg[16] = _24;
    vec4 value[16] = _24;
    vec4 _118[16] = _24;
    uint _117 = 0u;
    vec4 _116[16];
    uint _123;
    for (;;)
    {
        _123 = _117;
        if (_123 < 16u)
        {
            _116[_123] = -_118[_123];
            _117 = _123 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _132[16] = _116;
    uint _131 = 0u;
    vec4 _130[16];
    uint _137;
    for (;;)
    {
        _137 = _131;
        if (_137 < 16u)
        {
            _130[_137] = -_132[_137];
            _131 = _137 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _130;
    vec4 _146[16] = _130;
    uint _145 = 0u;
    vec4 _144[16];
    uint _152;
    for (;;)
    {
        _152 = _145;
        if (_152 < 16u)
        {
            _144[_152] = _146[_152] + _32[_152];
            _145 = _152 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _163[16] = _144;
    uint _162 = 0u;
    vec4 _161[16];
    uint _169;
    for (;;)
    {
        _169 = _162;
        if (_169 < 16u)
        {
            _161[_169] = _163[_169] - _32[_169];
            _162 = _169 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _161;
    vec4 _180[16] = _161;
    uint _179 = 0u;
    vec4 _178[16];
    uint _186;
    for (;;)
    {
        _186 = _179;
        if (_186 < 16u)
        {
            _178[_186] = _180[_186] * _37[_186];
            _179 = _186 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _197[16] = _178;
    uint _196 = 0u;
    vec4 _195[16];
    uint _203;
    for (;;)
    {
        _203 = _196;
        if (_203 < 16u)
        {
            _195[_203] = _197[_203] / _37[_203];
            _196 = _203 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _195;
    vec4 _229[16] = _195;
    uint _230 = 0u;
    uint _235;
    for (;;)
    {
        _235 = _230;
        if (_235 < 64u)
        {
            _213(((uint(0) + (_235 / 8u)) * uint(8)) + (uint(0) + (_235 % 8u)), _229[_235 / 4u]);
            _230 = _235 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

