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

vec4 _72(uint _73)
{
    return vec4(X.data[_73], X.data[_73 + 1u], X.data[_73 + 2u], X.data[_73 + 3u]);
}

vec4 _91(uint _92)
{
    return vec4(W.data[_92], W.data[_92 + 1u], W.data[_92 + 2u], W.data[_92 + 3u]);
}

void _108(uint _109, vec4 _110)
{
    Y.data[_109] = _110.x;
    Y.data[_109 + 1u] = _110.y;
    Y.data[_109 + 2u] = _110.z;
    Y.data[_109 + 3u] = _110.w;
}

void _129()
{
    uint _139 = 0u;
    uint _145;
    for (;;)
    {
        _145 = _139;
        if (_145 < 32u)
        {
            vec4 _141 = vec4(0.0);
            vec4 _142 = vec4(0.0);
            vec4 _143 = vec4(0.0);
            vec4 _144 = vec4(0.0);
            uint _140 = 0u;
            uint _147;
            for (;;)
            {
                _147 = _140;
                if (_147 < 64u)
                {
                    vec4 _149 = _72(_147);
                    vec4 _153 = _91(((_147 + 0u) * 32u) + _145);
                    vec4 _157 = _91(((_147 + 1u) * 32u) + _145);
                    vec4 _161 = _91(((_147 + 2u) * 32u) + _145);
                    vec4 _165 = _91(((_147 + 3u) * 32u) + _145);
                    _141 = fma(_149, vec4(_153.x, _157.x, _161.x, _165.x), _141);
                    _142 = fma(_149, vec4(_153.y, _157.y, _161.y, _165.y), _142);
                    _143 = fma(_149, vec4(_153.z, _157.z, _161.z, _165.z), _143);
                    _144 = fma(_149, vec4(_153.w, _157.w, _161.w, _165.w), _144);
                    _140 = _147 + 4u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _108(_145, vec4(((_141.x + _141.y) + _141.z) + _141.w, ((_142.x + _142.y) + _142.z) + _142.w, ((_143.x + _143.y) + _143.z) + _143.w, ((_144.x + _144.y) + _144.z) + _144.w));
            _139 = _145 + 4u;
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
    _129();
}

