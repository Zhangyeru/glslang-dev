#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputW
{
    float data[];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float data[];
} Bias;

vec2 _81(uint _82)
{
    return vec2(X.data[_82], X.data[_82 + 1u]);
}

vec2 _108(uint _109)
{
    if (_109 == 0u)
    {
        return vec2[](vec2(-0.75, -0.5), vec2(-0.25, 0.0), vec2(0.25, 0.5), vec2(0.75, -0.75), vec2(-0.5, -0.25), vec2(0.0, 0.25), vec2(0.5, 0.75), vec2(-0.75, -0.5))[0];
    }
    if (_109 == 2u)
    {
        return vec2[](vec2(-0.75, -0.5), vec2(-0.25, 0.0), vec2(0.25, 0.5), vec2(0.75, -0.75), vec2(-0.5, -0.25), vec2(0.0, 0.25), vec2(0.5, 0.75), vec2(-0.75, -0.5))[1];
    }
    if (_109 == 4u)
    {
        return vec2[](vec2(-0.75, -0.5), vec2(-0.25, 0.0), vec2(0.25, 0.5), vec2(0.75, -0.75), vec2(-0.5, -0.25), vec2(0.0, 0.25), vec2(0.5, 0.75), vec2(-0.75, -0.5))[2];
    }
    if (_109 == 6u)
    {
        return vec2[](vec2(-0.75, -0.5), vec2(-0.25, 0.0), vec2(0.25, 0.5), vec2(0.75, -0.75), vec2(-0.5, -0.25), vec2(0.0, 0.25), vec2(0.5, 0.75), vec2(-0.75, -0.5))[3];
    }
    if (_109 == 8u)
    {
        return vec2[](vec2(-0.75, -0.5), vec2(-0.25, 0.0), vec2(0.25, 0.5), vec2(0.75, -0.75), vec2(-0.5, -0.25), vec2(0.0, 0.25), vec2(0.5, 0.75), vec2(-0.75, -0.5))[4];
    }
    if (_109 == 10u)
    {
        return vec2[](vec2(-0.75, -0.5), vec2(-0.25, 0.0), vec2(0.25, 0.5), vec2(0.75, -0.75), vec2(-0.5, -0.25), vec2(0.0, 0.25), vec2(0.5, 0.75), vec2(-0.75, -0.5))[5];
    }
    if (_109 == 12u)
    {
        return vec2[](vec2(-0.75, -0.5), vec2(-0.25, 0.0), vec2(0.25, 0.5), vec2(0.75, -0.75), vec2(-0.5, -0.25), vec2(0.0, 0.25), vec2(0.5, 0.75), vec2(-0.75, -0.5))[6];
    }
    return vec2[](vec2(-0.75, -0.5), vec2(-0.25, 0.0), vec2(0.25, 0.5), vec2(0.75, -0.75), vec2(-0.5, -0.25), vec2(0.0, 0.25), vec2(0.5, 0.75), vec2(-0.75, -0.5))[7];
}

void _93(uint _94, vec2 _95)
{
    Y.data[_94] = _95.x;
    Y.data[_94 + 1u] = _95.y;
}

void _144()
{
    uint _154 = 0u;
    uint _158;
    for (;;)
    {
        _158 = _154;
        if (_158 < 16u)
        {
            vec2 _156 = vec2(0.0);
            uint _155 = 0u;
            uint _160;
            for (;;)
            {
                _160 = _155;
                if (_160 < 32u)
                {
                    vec2 _162 = _81(_160);
                    _156 += vec2(dot(_162, vec2(W.data[(((_160 + 0u) * 16u) + _158) + 0u], W.data[(((_160 + 1u) * 16u) + _158) + 0u])), dot(_162, vec2(W.data[(((_160 + 0u) * 16u) + _158) + 1u], W.data[(((_160 + 1u) * 16u) + _158) + 1u])));
                    _155 = _160 + 2u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _93(_158, _156 + _108(_158));
            _154 = _158 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

void main()
{
    _144();
}

