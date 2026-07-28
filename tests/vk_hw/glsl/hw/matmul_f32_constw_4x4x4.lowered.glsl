#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec4 _13[4] = vec4[](vec4(0.5), vec4(0.5), vec4(0.5), vec4(0.5));

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec4 _64(uint _65)
{
    return vec4(A.data[_65], A.data[_65 + 1u], A.data[_65 + 2u], A.data[_65 + 3u]);
}

vec4 _84(uint _85)
{
    return vec4(C.data[_85], C.data[_85 + 1u], C.data[_85 + 2u], C.data[_85 + 3u]);
}

vec4[4] _106()
{
    uint _121 = 0u;
    vec4 _120[4];
    uint _129;
    for (;;)
    {
        _129 = _121;
        if (_129 < 4u)
        {
            uint _122 = 0u;
            uint _131;
            for (;;)
            {
                _131 = _122;
                if (_131 < 1u)
                {
                    vec4 _124 = vec4(0.0);
                    vec4 _125 = vec4(0.0);
                    vec4 _126 = vec4(0.0);
                    vec4 _127 = vec4(0.0);
                    uint _123 = 0u;
                    uint _133;
                    for (;;)
                    {
                        _133 = _123;
                        if (_133 < 1u)
                        {
                            uint _135 = _133 * 4u;
                            uint _137 = (_129 * 4u) + _135;
                            vec4 _150 = _64(((uint(0) + (_137 / 4u)) * uint(4)) + (uint(0) + (_137 % 4u)));
                            uint _153 = ((_135 + 0u) * 1u) + _131;
                            uint _158 = ((_135 + 1u) * 1u) + _131;
                            uint _163 = ((_135 + 2u) * 1u) + _131;
                            uint _168 = ((_135 + 3u) * 1u) + _131;
                            _124 = fma(_150, vec4(_13[_153].x, _13[_158].x, _13[_163].x, _13[_168].x), _124);
                            _125 = fma(_150, vec4(_13[_153].y, _13[_158].y, _13[_163].y, _13[_168].y), _125);
                            _126 = fma(_150, vec4(_13[_153].z, _13[_158].z, _13[_163].z, _13[_168].z), _126);
                            _127 = fma(_150, vec4(_13[_153].w, _13[_158].w, _13[_163].w, _13[_168].w), _127);
                            _123 = _133 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _204 = (_129 * 4u) + (_131 * 4u);
                    vec4 _217 = _84(((uint(0) + (_204 / 4u)) * uint(4)) + (uint(0) + (_204 % 4u)));
                    _120[(_129 * 1u) + _131] = vec4(_217.x + (((_124.x + _124.y) + _124.z) + _124.w), _217.y + (((_125.x + _125.y) + _125.z) + _125.w), _217.z + (((_126.x + _126.y) + _126.z) + _126.w), _217.w + (((_127.x + _127.y) + _127.z) + _127.w));
                    _122 = _131 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _121 = _129 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _120;
}

void _265(uint _266, vec4 _267)
{
    D.data[_266] = _267.x;
    D.data[_266 + 1u] = _267.y;
    D.data[_266 + 2u] = _267.z;
    D.data[_266 + 3u] = _267.w;
}

void main()
{
    vec4 _48[4] = _106();
    vec4 tempArg[4] = _48;
    vec4 d[4] = _48;
    vec4 _282[4] = _48;
    uint _283 = 0u;
    uint _288;
    for (;;)
    {
        _288 = _283;
        if (_288 < 16u)
        {
            _265(((uint(0) + (_288 / 4u)) * uint(4)) + (uint(0) + (_288 % 4u)), _282[_288 / 4u]);
            _283 = _288 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

