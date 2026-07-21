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

vec4 _79(uint _80)
{
    return vec4(X.data[_80], X.data[_80 + 1u], X.data[_80 + 2u], X.data[_80 + 3u]);
}

vec4 _98(uint _99)
{
    return vec4(W.data[_99], W.data[_99 + 1u], W.data[_99 + 2u], W.data[_99 + 3u]);
}

vec4 _114(uint _115)
{
    return vec4(Bias.data[_115], Bias.data[_115 + 1u], Bias.data[_115 + 2u], Bias.data[_115 + 3u]);
}

vec4[4] _136()
{
    uint _147 = 0u;
    vec4 _146[4];
    uint _153;
    for (;;)
    {
        _153 = _147;
        if (_153 < 4u)
        {
            vec4 _149 = vec4(0.0);
            vec4 _150 = vec4(0.0);
            vec4 _151 = vec4(0.0);
            vec4 _152 = vec4(0.0);
            uint _148 = 0u;
            uint _155;
            for (;;)
            {
                _155 = _148;
                if (_155 < 8u)
                {
                    uint _157 = _155 * 4u;
                    vec4 _158 = _79(_157);
                    uint _159 = _153 * 4u;
                    uint _162 = ((_157 + 0u) * 16u) + _159;
                    vec4 _175 = _98(((uint(0) + (_162 / 16u)) * uint(16)) + (uint(0) + (_162 % 16u)));
                    uint _178 = ((_157 + 1u) * 16u) + _159;
                    vec4 _191 = _98(((uint(0) + (_178 / 16u)) * uint(16)) + (uint(0) + (_178 % 16u)));
                    uint _194 = ((_157 + 2u) * 16u) + _159;
                    vec4 _207 = _98(((uint(0) + (_194 / 16u)) * uint(16)) + (uint(0) + (_194 % 16u)));
                    uint _210 = ((_157 + 3u) * 16u) + _159;
                    vec4 _223 = _98(((uint(0) + (_210 / 16u)) * uint(16)) + (uint(0) + (_210 % 16u)));
                    _149 = fma(_158, vec4(_175.x, _191.x, _207.x, _223.x), _149);
                    _150 = fma(_158, vec4(_175.y, _191.y, _207.y, _223.y), _150);
                    _151 = fma(_158, vec4(_175.z, _191.z, _207.z, _223.z), _151);
                    _152 = fma(_158, vec4(_175.w, _191.w, _207.w, _223.w), _152);
                    _148 = _155 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _146[_153] = vec4(((_149.x + _149.y) + _149.z) + _149.w, ((_150.x + _150.y) + _150.z) + _150.w, ((_151.x + _151.y) + _151.z) + _151.w, ((_152.x + _152.y) + _152.z) + _152.w) + _114(_153 * 4u);
            _147 = _153 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _146;
}

void _293(uint _294, vec4 _295)
{
    Y.data[_294] = _295.x;
    Y.data[_294 + 1u] = _295.y;
    Y.data[_294 + 2u] = _295.z;
    Y.data[_294 + 3u] = _295.w;
}

void main()
{
    vec4 _58[4] = _136();
    vec4 tempArg[4] = _58;
    vec4 y[4] = _58;
    vec4 _309[4] = _58;
    uint _310 = 0u;
    uint _315;
    for (;;)
    {
        _315 = _310;
        if (_315 < 16u)
        {
            _293(0u + _315, _309[_315 / 4u]);
            _310 = _315 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

