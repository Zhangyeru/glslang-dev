#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec2 _13[8] = vec2[](vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5));

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

vec2 _65(uint _66)
{
    return vec2(A.data[_66], A.data[_66 + 1u]);
}

vec2 _77(uint _78)
{
    return vec2(C.data[_78], C.data[_78 + 1u]);
}

vec2[8] _94()
{
    uint _109 = 0u;
    vec2 _108[8];
    uint _115;
    for (;;)
    {
        _115 = _109;
        if (_115 < 4u)
        {
            uint _110 = 0u;
            uint _117;
            for (;;)
            {
                _117 = _110;
                if (_117 < 2u)
                {
                    vec2 _112 = vec2(0.0);
                    vec2 _113 = vec2(0.0);
                    uint _111 = 0u;
                    uint _119;
                    for (;;)
                    {
                        _119 = _111;
                        if (_119 < 2u)
                        {
                            uint _121 = _119 * 2u;
                            uint _123 = (_115 * 4u) + _121;
                            vec2 _136 = _65(((uint(0) + (_123 / 4u)) * uint(4)) + (uint(0) + (_123 % 4u)));
                            uint _139 = ((_121 + 0u) * 2u) + _117;
                            uint _144 = ((_121 + 1u) * 2u) + _117;
                            _112 = fma(_136, vec2(_13[_139].x, _13[_144].x), _112);
                            _113 = fma(_136, vec2(_13[_139].y, _13[_144].y), _113);
                            _111 = _119 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _162 = (_115 * 4u) + (_117 * 2u);
                    vec2 _175 = _77(((uint(0) + (_162 / 4u)) * uint(4)) + (uint(0) + (_162 % 4u)));
                    _108[(_115 * 2u) + _117] = vec2(_175.x + (_112.x + _112.y), _175.y + (_113.x + _113.y));
                    _110 = _117 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _109 = _115 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _108;
}

void _195(uint _196, vec2 _197)
{
    D.data[_196] = _197.x;
    D.data[_196 + 1u] = _197.y;
}

void main()
{
    vec2 _48[8] = _94();
    vec2 tempArg[8] = _48;
    vec2 d[8] = _48;
    vec2 _206[8] = _48;
    uint _207 = 0u;
    uint _212;
    for (;;)
    {
        _212 = _207;
        if (_212 < 16u)
        {
            _195(((uint(0) + (_212 / 4u)) * uint(4)) + (uint(0) + (_212 % 4u)), _206[_212 / 2u]);
            _207 = _212 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

