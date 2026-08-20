#version 450
#extension GL_EXT_scalar_block_layout : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float data[];
} X;

layout(set = 0, binding = 1, scalar) uniform InputW
{
    float data[128];
} W;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec2 _73(uint _74)
{
    return vec2(X.data[_74], X.data[_74 + 1u]);
}

vec2 _84(uint _85)
{
    return vec2(W.data[_85], W.data[_85 + 1u]);
}

void _96(uint _97, vec2 _98)
{
    Y.data[_97] = _98.x;
    Y.data[_97 + 1u] = _98.y;
}

void _111()
{
    uint _121 = 0u;
    uint _125;
    for (;;)
    {
        _125 = _121;
        if (_125 < 8u)
        {
            vec2 _123 = vec2(0.0);
            vec2 _124 = vec2(0.0);
            uint _122 = 0u;
            uint _127;
            for (;;)
            {
                _127 = _122;
                if (_127 < 16u)
                {
                    vec2 _129 = _73(_127);
                    vec2 _133 = _84(((_127 + 0u) * 8u) + _125);
                    vec2 _137 = _84(((_127 + 1u) * 8u) + _125);
                    _123 = fma(_129, vec2(_133.x, _137.x), _123);
                    _124 = fma(_129, vec2(_133.y, _137.y), _124);
                    _122 = _127 + 2u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _96(_125, vec2(_123.x + _123.y, _124.x + _124.y));
            _121 = _125 + 2u;
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
    _111();
}

