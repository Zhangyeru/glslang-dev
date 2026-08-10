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

vec4 _86(uint _87)
{
    return vec4(X.data[_87], X.data[_87 + 1u], X.data[_87 + 2u], X.data[_87 + 3u]);
}

vec4 _105(uint _106)
{
    return vec4(W.data[_106], W.data[_106 + 1u], W.data[_106 + 2u], W.data[_106 + 3u]);
}

vec4 _121(uint _122)
{
    return vec4(Bias.data[_122], Bias.data[_122 + 1u], Bias.data[_122 + 2u], Bias.data[_122 + 3u]);
}

vec4[4] _138()
{
    uint _150 = 0u;
    vec4 _149[4];
    uint _159;
    for (;;)
    {
        _159 = _150;
        if (_159 < 4u)
        {
            vec4 _152 = vec4(0.0);
            vec4 _153 = vec4(0.0);
            vec4 _154 = vec4(0.0);
            vec4 _155 = vec4(0.0);
            uint _151 = 0u;
            uint _161;
            for (;;)
            {
                _161 = _151;
                if (_161 < 8u)
                {
                    uint _163 = _161 * 4u;
                    uint _164 = _159 * 4u;
                    vec4 _165 = _86(_163);
                    uint _167 = (_163 * 16u) + _164;
                    vec4 _180 = _105(((uint(0) + (_167 / 16u)) * uint(16)) + (uint(0) + (_167 % 16u)));
                    uint _183 = ((_163 + 1u) * 16u) + _164;
                    vec4 _196 = _105(((uint(0) + (_183 / 16u)) * uint(16)) + (uint(0) + (_183 % 16u)));
                    uint _199 = ((_163 + 2u) * 16u) + _164;
                    vec4 _212 = _105(((uint(0) + (_199 / 16u)) * uint(16)) + (uint(0) + (_199 % 16u)));
                    uint _215 = ((_163 + 3u) * 16u) + _164;
                    vec4 _228 = _105(((uint(0) + (_215 / 16u)) * uint(16)) + (uint(0) + (_215 % 16u)));
                    _152 = fma(_165, vec4(_180.x, _196.x, _212.x, _228.x), _152);
                    _153 = fma(_165, vec4(_180.y, _196.y, _212.y, _228.y), _153);
                    _154 = fma(_165, vec4(_180.z, _196.z, _212.z, _228.z), _154);
                    _155 = fma(_165, vec4(_180.w, _196.w, _212.w, _228.w), _155);
                    _151 = _161 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _149[_159] = vec4(((_152.x + _152.y) + _152.z) + _152.w, ((_153.x + _153.y) + _153.z) + _153.w, ((_154.x + _154.y) + _154.z) + _154.w, ((_155.x + _155.y) + _155.z) + _155.w) + _121(_159 * 4u);
            _150 = _159 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _149;
}

void _298(uint _299, vec4 _300)
{
    Y.data[_299] = _300.x;
    Y.data[_299 + 1u] = _300.y;
    Y.data[_299 + 2u] = _300.z;
    Y.data[_299 + 3u] = _300.w;
}

void main()
{
    vec4 _58[4] = _138();
    vec4 tempArg[4] = _58;
    vec4 y[4] = _58;
    vec4 _314[4] = _58;
    uint _315 = 0u;
    uint _320;
    for (;;)
    {
        _320 = _315;
        if (_320 < 16u)
        {
            _298(0u + _320, _314[_320 / 4u]);
            _315 = _320 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

