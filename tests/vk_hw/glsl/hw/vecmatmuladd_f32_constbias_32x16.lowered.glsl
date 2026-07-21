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

vec4 _82(uint _83)
{
    return vec4(X.data[_83], X.data[_83 + 1u], X.data[_83 + 2u], X.data[_83 + 3u]);
}

vec4 _122(uint _123)
{
    if (_123 == 0u)
    {
        return vec4[](vec4(-0.75, -0.5, -0.25, 0.0), vec4(0.25, 0.5, 0.75, -0.75), vec4(-0.5, -0.25, 0.0, 0.25), vec4(0.5, 0.75, -0.75, -0.5))[0];
    }
    if (_123 == 4u)
    {
        return vec4[](vec4(-0.75, -0.5, -0.25, 0.0), vec4(0.25, 0.5, 0.75, -0.75), vec4(-0.5, -0.25, 0.0, 0.25), vec4(0.5, 0.75, -0.75, -0.5))[1];
    }
    if (_123 == 8u)
    {
        return vec4[](vec4(-0.75, -0.5, -0.25, 0.0), vec4(0.25, 0.5, 0.75, -0.75), vec4(-0.5, -0.25, 0.0, 0.25), vec4(0.5, 0.75, -0.75, -0.5))[2];
    }
    return vec4[](vec4(-0.75, -0.5, -0.25, 0.0), vec4(0.25, 0.5, 0.75, -0.75), vec4(-0.5, -0.25, 0.0, 0.25), vec4(0.5, 0.75, -0.75, -0.5))[3];
}

void _102(uint _103, vec4 _104)
{
    Y.data[_103] = _104.x;
    Y.data[_103 + 1u] = _104.y;
    Y.data[_103 + 2u] = _104.z;
    Y.data[_103 + 3u] = _104.w;
}

void _138()
{
    uint _148 = 0u;
    uint _152;
    for (;;)
    {
        _152 = _148;
        if (_152 < 16u)
        {
            vec4 _150 = vec4(0.0);
            uint _149 = 0u;
            uint _154;
            for (;;)
            {
                _154 = _149;
                if (_154 < 32u)
                {
                    vec4 _156 = _82(_154);
                    vec4 _263 = _150 + vec4(dot(_156, vec4(W.data[(((_154 + 0u) * 16u) + _152) + 0u], W.data[(((_154 + 1u) * 16u) + _152) + 0u], W.data[(((_154 + 2u) * 16u) + _152) + 0u], W.data[(((_154 + 3u) * 16u) + _152) + 0u])), dot(_156, vec4(W.data[(((_154 + 0u) * 16u) + _152) + 1u], W.data[(((_154 + 1u) * 16u) + _152) + 1u], W.data[(((_154 + 2u) * 16u) + _152) + 1u], W.data[(((_154 + 3u) * 16u) + _152) + 1u])), dot(_156, vec4(W.data[(((_154 + 0u) * 16u) + _152) + 2u], W.data[(((_154 + 1u) * 16u) + _152) + 2u], W.data[(((_154 + 2u) * 16u) + _152) + 2u], W.data[(((_154 + 3u) * 16u) + _152) + 2u])), dot(_156, vec4(W.data[(((_154 + 0u) * 16u) + _152) + 3u], W.data[(((_154 + 1u) * 16u) + _152) + 3u], W.data[(((_154 + 2u) * 16u) + _152) + 3u], W.data[(((_154 + 3u) * 16u) + _152) + 3u])));
                    _150 = _263;
                    _149 = _154 + 4u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _102(_152, _150 + _122(_152));
            _148 = _152 + 4u;
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
    _138();
}

