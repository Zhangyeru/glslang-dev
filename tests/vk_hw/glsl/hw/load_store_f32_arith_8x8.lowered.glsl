#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec2 _32[32] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
const vec2 _37[32] = vec2[](vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0), vec2(1.0));

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

vec2 _64(uint _65)
{
    return vec2(A.data[_65], A.data[_65 + 1u]);
}

void _205(uint _206, vec2 _207)
{
    D.data[_206] = _207.x;
    D.data[_206 + 1u] = _207.y;
}

void main()
{
    uint _83 = 0u;
    vec2 _82[32];
    uint _88;
    for (;;)
    {
        _88 = _83;
        if (_88 < 64u)
        {
            _82[_88 / 2u] = _64(((uint(0) + (_88 / 8u)) * uint(8)) + (uint(0) + (_88 % 8u)));
            _83 = _88 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _24[32] = _82;
    vec2 tempArg[32] = _24;
    vec2 value[32] = _24;
    vec2 _110[32] = _24;
    uint _109 = 0u;
    vec2 _108[32];
    uint _115;
    for (;;)
    {
        _115 = _109;
        if (_115 < 32u)
        {
            _108[_115] = -_110[_115];
            _109 = _115 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _124[32] = _108;
    uint _123 = 0u;
    vec2 _122[32];
    uint _129;
    for (;;)
    {
        _129 = _123;
        if (_129 < 32u)
        {
            _122[_129] = -_124[_129];
            _123 = _129 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _122;
    vec2 _138[32] = _122;
    uint _137 = 0u;
    vec2 _136[32];
    uint _144;
    for (;;)
    {
        _144 = _137;
        if (_144 < 32u)
        {
            _136[_144] = _138[_144] + _32[_144];
            _137 = _144 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _155[32] = _136;
    uint _154 = 0u;
    vec2 _153[32];
    uint _161;
    for (;;)
    {
        _161 = _154;
        if (_161 < 32u)
        {
            _153[_161] = _155[_161] - _32[_161];
            _154 = _161 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _153;
    vec2 _172[32] = _153;
    uint _171 = 0u;
    vec2 _170[32];
    uint _178;
    for (;;)
    {
        _178 = _171;
        if (_178 < 32u)
        {
            _170[_178] = _172[_178] * _37[_178];
            _171 = _178 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _189[32] = _170;
    uint _188 = 0u;
    vec2 _187[32];
    uint _195;
    for (;;)
    {
        _195 = _188;
        if (_195 < 32u)
        {
            _187[_195] = _189[_195] / _37[_195];
            _188 = _195 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _187;
    vec2 _215[32] = _187;
    uint _216 = 0u;
    uint _221;
    for (;;)
    {
        _221 = _216;
        if (_221 < 64u)
        {
            _205(((uint(0) + (_221 / 8u)) * uint(8)) + (uint(0) + (_221 % 8u)), _215[_221 / 2u]);
            _216 = _221 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

