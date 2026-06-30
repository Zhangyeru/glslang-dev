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

vec4 _73(uint _74)
{
    return vec4(X.data[_74], X.data[_74 + 1u], X.data[_74 + 2u], X.data[_74 + 3u]);
}

vec4 _91(uint _92)
{
    return vec4(W.data[_92], W.data[_92 + 1u], W.data[_92 + 2u], W.data[_92 + 3u]);
}

void _109(uint _110, vec4 _111)
{
    Y.data[_110] = _111.x;
    Y.data[_110 + 1u] = _111.y;
    Y.data[_110 + 2u] = _111.z;
    Y.data[_110 + 3u] = _111.w;
}

void _129()
{
    uint _139 = 0u;
    uint _145;
    for (;;)
    {
        _145 = _139;
        if (_145 < 2u)
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
                if (_147 < 4u)
                {
                    uint _149 = _147 * 4u;
                    vec4 _150 = _73(_149);
                    uint _151 = _145 * 4u;
                    uint _154 = ((_149 + 0u) * 8u) + _151;
                    vec4 _167 = _91(((uint(0) + (_154 / 8u)) * uint(8)) + (uint(0) + (_154 % 8u)));
                    uint _170 = ((_149 + 1u) * 8u) + _151;
                    vec4 _183 = _91(((uint(0) + (_170 / 8u)) * uint(8)) + (uint(0) + (_170 % 8u)));
                    uint _186 = ((_149 + 2u) * 8u) + _151;
                    vec4 _199 = _91(((uint(0) + (_186 / 8u)) * uint(8)) + (uint(0) + (_186 % 8u)));
                    uint _202 = ((_149 + 3u) * 8u) + _151;
                    vec4 _215 = _91(((uint(0) + (_202 / 8u)) * uint(8)) + (uint(0) + (_202 % 8u)));
                    _141 = fma(_150, vec4(_167.x, _183.x, _199.x, _215.x), _141);
                    _142 = fma(_150, vec4(_167.y, _183.y, _199.y, _215.y), _142);
                    _143 = fma(_150, vec4(_167.z, _183.z, _199.z, _215.z), _143);
                    _144 = fma(_150, vec4(_167.w, _183.w, _199.w, _215.w), _144);
                    _140 = _147 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _109(_145 * 4u, vec4(((_141.x + _141.y) + _141.z) + _141.w, ((_142.x + _142.y) + _142.z) + _142.w, ((_143.x + _143.y) + _143.z) + _143.w, ((_144.x + _144.y) + _144.z) + _144.w));
            _139 = _145 + 1u;
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

