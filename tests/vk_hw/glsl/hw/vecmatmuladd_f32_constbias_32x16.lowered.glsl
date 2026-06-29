#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec4 _19[4] = vec4[](vec4(-0.75, -0.5, -0.25, 0.0), vec4(0.25, 0.5, 0.75, -0.75), vec4(-0.5, -0.25, 0.0, 0.25), vec4(0.5, 0.75, -0.75, -0.5));

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

vec4 _101(uint _102)
{
    return vec4(W.data[_102], W.data[_102 + 1u], W.data[_102 + 2u], W.data[_102 + 3u]);
}

vec4[4] _123()
{
    uint _134 = 0u;
    vec4 _133[4];
    uint _141;
    for (;;)
    {
        _141 = _134;
        if (_141 < 4u)
        {
            vec4 _136 = vec4(0.0);
            vec4 _137 = vec4(0.0);
            vec4 _138 = vec4(0.0);
            vec4 _139 = vec4(0.0);
            uint _135 = 0u;
            uint _143;
            for (;;)
            {
                _143 = _135;
                if (_143 < 8u)
                {
                    uint _145 = _143 * 4u;
                    vec4 _146 = _82(_145);
                    uint _147 = _141 * 4u;
                    uint _150 = ((_145 + 0u) * 16u) + _147;
                    vec4 _163 = _101(((uint(0) + (_150 / 16u)) * uint(16)) + (uint(0) + (_150 % 16u)));
                    uint _166 = ((_145 + 1u) * 16u) + _147;
                    vec4 _179 = _101(((uint(0) + (_166 / 16u)) * uint(16)) + (uint(0) + (_166 % 16u)));
                    uint _182 = ((_145 + 2u) * 16u) + _147;
                    vec4 _195 = _101(((uint(0) + (_182 / 16u)) * uint(16)) + (uint(0) + (_182 % 16u)));
                    uint _198 = ((_145 + 3u) * 16u) + _147;
                    vec4 _211 = _101(((uint(0) + (_198 / 16u)) * uint(16)) + (uint(0) + (_198 % 16u)));
                    _136 = fma(_146, vec4(_163.x, _179.x, _195.x, _211.x), _136);
                    _137 = fma(_146, vec4(_163.y, _179.y, _195.y, _211.y), _137);
                    _138 = fma(_146, vec4(_163.z, _179.z, _195.z, _211.z), _138);
                    _139 = fma(_146, vec4(_163.w, _179.w, _195.w, _211.w), _139);
                    _135 = _143 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _133[_141] = vec4(((_136.x + _136.y) + _136.z) + _136.w, ((_137.x + _137.y) + _137.z) + _137.w, ((_138.x + _138.y) + _138.z) + _138.w, ((_139.x + _139.y) + _139.z) + _139.w) + _19[_141];
            _134 = _141 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _133;
}

void _285(uint _286, vec4 _287)
{
    Y.data[_286] = _287.x;
    Y.data[_286 + 1u] = _287.y;
    Y.data[_286 + 2u] = _287.z;
    Y.data[_286 + 3u] = _287.w;
}

void main()
{
    vec4 _57[4] = _123();
    vec4 tempArg[4] = _57;
    vec4 y[4] = _57;
    vec4 _301[4] = _57;
    uint _302 = 0u;
    uint _307;
    for (;;)
    {
        _307 = _302;
        if (_307 < 16u)
        {
            _285(_307, _301[_307 / 4u]);
            _302 = _307 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

