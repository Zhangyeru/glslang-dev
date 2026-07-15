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

vec4 _56(uint _57)
{
    return vec4(A.data[_57], A.data[_57 + 1u], A.data[_57 + 2u], A.data[_57 + 3u]);
}

void _230(uint _231, vec4 _232)
{
    D.data[_231] = _232.x;
    D.data[_231 + 1u] = _232.y;
    D.data[_231 + 2u] = _232.z;
    D.data[_231 + 3u] = _232.w;
}

void main()
{
    uint _83 = 0u;
    vec4 _82[10];
    uint _88;
    for (;;)
    {
        _88 = _83;
        if (_88 < 40u)
        {
            _82[_88 / 4u] = _56(((uint(0) + (_88 / 8u)) * uint(8)) + (uint(0) + (_88 % 8u)));
            _83 = _88 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 _26[10] = _82;
    vec4 tempArg[10] = _26;
    vec4 value[10] = _26;
    float _120 = max(max(max(max(_26[0].x, _26[2].x), _26[4].x), _26[6].x), _26[8].x);
    float _134 = max(max(max(max(_26[0].y, _26[2].y), _26[4].y), _26[6].y), _26[8].y);
    float _148 = max(max(max(max(_26[0].z, _26[2].z), _26[4].z), _26[6].z), _26[8].z);
    float _162 = max(max(max(max(_26[0].w, _26[2].w), _26[4].w), _26[6].w), _26[8].w);
    float _176 = max(max(max(max(_26[1].x, _26[3].x), _26[5].x), _26[7].x), _26[9].x);
    float _190 = max(max(max(max(_26[1].y, _26[3].y), _26[5].y), _26[7].y), _26[9].y);
    float _204 = max(max(max(max(_26[1].z, _26[3].z), _26[5].z), _26[7].z), _26[9].z);
    float _218 = max(max(max(max(_26[1].w, _26[3].w), _26[5].w), _26[7].w), _26[9].w);
    vec4 _33[10] = vec4[](vec4(_120, _134, _148, _162), vec4(_176, _190, _204, _218), vec4(_120, _134, _148, _162), vec4(_176, _190, _204, _218), vec4(_120, _134, _148, _162), vec4(_176, _190, _204, _218), vec4(_120, _134, _148, _162), vec4(_176, _190, _204, _218), vec4(_120, _134, _148, _162), vec4(_176, _190, _204, _218));
    vec4 reduced[10] = _33;
    vec4 _246[10] = _33;
    uint _247 = 0u;
    uint _252;
    for (;;)
    {
        _252 = _247;
        if (_252 < 40u)
        {
            _230(((uint(0) + (_252 / 8u)) * uint(8)) + (uint(0) + (_252 % 8u)), _246[_252 / 4u]);
            _247 = _252 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

