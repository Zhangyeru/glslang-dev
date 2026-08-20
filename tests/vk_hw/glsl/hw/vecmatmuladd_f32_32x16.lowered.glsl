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

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float data[];
} Bias;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

vec2 _87(uint _88)
{
    return vec2(X.data[_88], X.data[_88 + 1u]);
}

vec2 _98(uint _99)
{
    return vec2(W.data[_99], W.data[_99 + 1u]);
}

vec2 _108(uint _109)
{
    return vec2(Bias.data[_109], Bias.data[_109 + 1u]);
}

vec2[8] _119()
{
    uint _131 = 0u;
    vec2 _130[8];
    uint _138;
    for (;;)
    {
        _138 = _131;
        if (_138 < 8u)
        {
            vec2 _133 = vec2(0.0);
            vec2 _134 = vec2(0.0);
            uint _132 = 0u;
            uint _140;
            for (;;)
            {
                _140 = _132;
                if (_140 < 16u)
                {
                    uint _142 = _140 * 2u;
                    uint _143 = _138 * 2u;
                    vec2 _144 = _87(_142);
                    uint _146 = (_142 * 16u) + _143;
                    vec2 _159 = _98(((uint(0) + (_146 / 16u)) * uint(16)) + (uint(0) + (_146 % 16u)));
                    uint _162 = ((_142 + 1u) * 16u) + _143;
                    vec2 _175 = _98(((uint(0) + (_162 / 16u)) * uint(16)) + (uint(0) + (_162 % 16u)));
                    _133 = fma(_144, vec2(_159.x, _175.x), _133);
                    _134 = fma(_144, vec2(_159.y, _175.y), _134);
                    _132 = _140 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _130[_138] = vec2(_133.x + _133.y, _134.x + _134.y) + _108(_138 * 2u);
            _131 = _138 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _130;
}

void _203(uint _204, vec2 _205)
{
    Y.data[_204] = _205.x;
    Y.data[_204 + 1u] = _205.y;
}

void main()
{
    vec2 _58[8] = _119();
    vec2 tempArg[8] = _58;
    vec2 y[8] = _58;
    vec2 _213[8] = _58;
    uint _214 = 0u;
    uint _219;
    for (;;)
    {
        _219 = _214;
        if (_219 < 16u)
        {
            _203(0u + _219, _213[_219 / 2u]);
            _214 = _219 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

