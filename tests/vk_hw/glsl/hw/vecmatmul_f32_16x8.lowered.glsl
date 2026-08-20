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

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

vec2 _72(uint _73)
{
    return vec2(X.data[_73], X.data[_73 + 1u]);
}

vec2 _83(uint _84)
{
    return vec2(W.data[_84], W.data[_84 + 1u]);
}

void _94(uint _95, vec2 _96)
{
    Y.data[_95] = _96.x;
    Y.data[_95 + 1u] = _96.y;
}

void _109()
{
    uint _119 = 0u;
    uint _123;
    for (;;)
    {
        _123 = _119;
        if (_123 < 8u)
        {
            vec2 _121 = vec2(0.0);
            vec2 _122 = vec2(0.0);
            uint _120 = 0u;
            uint _125;
            for (;;)
            {
                _125 = _120;
                if (_125 < 16u)
                {
                    vec2 _127 = _72(_125);
                    vec2 _131 = _83(((_125 + 0u) * 8u) + _123);
                    vec2 _135 = _83(((_125 + 1u) * 8u) + _123);
                    _121 = fma(_127, vec2(_131.x, _135.x), _121);
                    _122 = fma(_127, vec2(_131.y, _135.y), _122);
                    _120 = _125 + 2u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _94(_123, vec2(_121.x + _121.y, _122.x + _122.y));
            _119 = _123 + 2u;
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
    _109();
}

