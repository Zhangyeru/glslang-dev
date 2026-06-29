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

vec4 _90(uint _91)
{
    return vec4(W.data[_91], W.data[_91 + 1u], W.data[_91 + 2u], W.data[_91 + 3u]);
}

vec4[2] _112()
{
    uint _123 = 0u;
    vec4 _122[2];
    uint _129;
    for (;;)
    {
        _129 = _123;
        if (_129 < 2u)
        {
            vec4 _125 = vec4(0.0);
            vec4 _126 = vec4(0.0);
            vec4 _127 = vec4(0.0);
            vec4 _128 = vec4(0.0);
            uint _124 = 0u;
            uint _131;
            for (;;)
            {
                _131 = _124;
                if (_131 < 4u)
                {
                    uint _133 = _131 * 4u;
                    vec4 _134 = _72(_133);
                    uint _135 = _129 * 4u;
                    uint _138 = ((_133 + 0u) * 8u) + _135;
                    vec4 _151 = _90(((uint(0) + (_138 / 8u)) * uint(8)) + (uint(0) + (_138 % 8u)));
                    uint _154 = ((_133 + 1u) * 8u) + _135;
                    vec4 _167 = _90(((uint(0) + (_154 / 8u)) * uint(8)) + (uint(0) + (_154 % 8u)));
                    uint _170 = ((_133 + 2u) * 8u) + _135;
                    vec4 _183 = _90(((uint(0) + (_170 / 8u)) * uint(8)) + (uint(0) + (_170 % 8u)));
                    uint _186 = ((_133 + 3u) * 8u) + _135;
                    vec4 _199 = _90(((uint(0) + (_186 / 8u)) * uint(8)) + (uint(0) + (_186 % 8u)));
                    _125 = fma(_134, vec4(_151.x, _167.x, _183.x, _199.x), _125);
                    _126 = fma(_134, vec4(_151.y, _167.y, _183.y, _199.y), _126);
                    _127 = fma(_134, vec4(_151.z, _167.z, _183.z, _199.z), _127);
                    _128 = fma(_134, vec4(_151.w, _167.w, _183.w, _199.w), _128);
                    _124 = _131 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _122[_129] = vec4(((_125.x + _125.y) + _125.z) + _125.w, ((_126.x + _126.y) + _126.z) + _126.w, ((_127.x + _127.y) + _127.z) + _127.w, ((_128.x + _128.y) + _128.z) + _128.w);
            _123 = _129 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _122;
}

void _266(uint _267, vec4 _268)
{
    Y.data[_267] = _268.x;
    Y.data[_267 + 1u] = _268.y;
    Y.data[_267 + 2u] = _268.z;
    Y.data[_267 + 3u] = _268.w;
}

void main()
{
    vec4 _47[2] = _112();
    vec4 tempArg[2] = _47;
    vec4 y[2] = _47;
    vec4 _282[2] = _47;
    uint _283 = 0u;
    uint _288;
    for (;;)
    {
        _288 = _283;
        if (_288 < 8u)
        {
            _266(_288, _282[_288 / 4u]);
            _283 = _288 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

