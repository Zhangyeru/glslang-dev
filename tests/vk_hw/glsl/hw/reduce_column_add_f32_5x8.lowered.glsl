#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

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

vec4 _55(uint _56)
{
    return vec4(A.data[_56], A.data[_56 + 1u], A.data[_56 + 2u], A.data[_56 + 3u]);
}

void _229(uint _230, vec4 _231)
{
    D.data[_230] = _231.x;
    D.data[_230 + 1u] = _231.y;
    D.data[_230 + 2u] = _231.z;
    D.data[_230 + 3u] = _231.w;
}

void main()
{
    uint _82 = 0u;
    vec4 _81[10];
    uint _87;
    for (;;)
    {
        _87 = _82;
        if (_87 < 40u)
        {
            _81[_87 / 4u] = _55(((uint(0) + (_87 / 8u)) * uint(8)) + (uint(0) + (_87 % 8u)));
            _82 = _87 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _26[10] = _81;
    vec4 tempArg[10] = _26;
    vec4 value[10] = _26;
    float _119 = (((_26[0].x + _26[2].x) + _26[4].x) + _26[6].x) + _26[8].x;
    float _133 = (((_26[0].y + _26[2].y) + _26[4].y) + _26[6].y) + _26[8].y;
    float _147 = (((_26[0].z + _26[2].z) + _26[4].z) + _26[6].z) + _26[8].z;
    float _161 = (((_26[0].w + _26[2].w) + _26[4].w) + _26[6].w) + _26[8].w;
    float _175 = (((_26[1].x + _26[3].x) + _26[5].x) + _26[7].x) + _26[9].x;
    float _189 = (((_26[1].y + _26[3].y) + _26[5].y) + _26[7].y) + _26[9].y;
    float _203 = (((_26[1].z + _26[3].z) + _26[5].z) + _26[7].z) + _26[9].z;
    float _217 = (((_26[1].w + _26[3].w) + _26[5].w) + _26[7].w) + _26[9].w;
    vec4 _32[10] = vec4[](vec4(_119, _133, _147, _161), vec4(_175, _189, _203, _217), vec4(_119, _133, _147, _161), vec4(_175, _189, _203, _217), vec4(_119, _133, _147, _161), vec4(_175, _189, _203, _217), vec4(_119, _133, _147, _161), vec4(_175, _189, _203, _217), vec4(_119, _133, _147, _161), vec4(_175, _189, _203, _217));
    vec4 reduced[10] = _32;
    vec4 _245[10] = _32;
    uint _246 = 0u;
    uint _251;
    for (;;)
    {
        _251 = _246;
        if (_251 < 40u)
        {
            _229(((uint(0) + (_251 / 8u)) * uint(8)) + (uint(0) + (_251 % 8u)), _245[_251 / 4u]);
            _246 = _251 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

