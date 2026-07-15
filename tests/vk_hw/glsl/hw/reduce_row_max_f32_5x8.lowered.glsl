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

void _232(uint _233, vec4 _234)
{
    D.data[_233] = _234.x;
    D.data[_233 + 1u] = _234.y;
    D.data[_233 + 2u] = _234.z;
    D.data[_233 + 3u] = _234.w;
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
    float _128 = max(max(max(max(max(max(max(_26[0].x, _26[0].y), _26[0].z), _26[0].w), _26[1].x), _26[1].y), _26[1].z), _26[1].w);
    float _151 = max(max(max(max(max(max(max(_26[2].x, _26[2].y), _26[2].z), _26[2].w), _26[3].x), _26[3].y), _26[3].z), _26[3].w);
    float _174 = max(max(max(max(max(max(max(_26[4].x, _26[4].y), _26[4].z), _26[4].w), _26[5].x), _26[5].y), _26[5].z), _26[5].w);
    float _197 = max(max(max(max(max(max(max(_26[6].x, _26[6].y), _26[6].z), _26[6].w), _26[7].x), _26[7].y), _26[7].z), _26[7].w);
    float _220 = max(max(max(max(max(max(max(_26[8].x, _26[8].y), _26[8].z), _26[8].w), _26[9].x), _26[9].y), _26[9].z), _26[9].w);
    vec4 _32[10] = vec4[](vec4(_128), vec4(_128), vec4(_151), vec4(_151), vec4(_174), vec4(_174), vec4(_197), vec4(_197), vec4(_220), vec4(_220));
    vec4 reduced[10] = _32;
    vec4 _248[10] = _32;
    uint _249 = 0u;
    uint _254;
    for (;;)
    {
        _254 = _249;
        if (_254 < 40u)
        {
            _232(((uint(0) + (_254 / 8u)) * uint(8)) + (uint(0) + (_254 % 8u)), _248[_254 / 4u]);
            _249 = _254 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

