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

vec2[8] _79()
{
    uint _112 = uint(16);
    uint _114 = uint(0);
    uint _116 = uint(0);
    vec2 _97[8] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _98 = 0u;
    uint _117;
    for (;;)
    {
        _117 = _98;
        if (_117 < 1u)
        {
            uint _119 = _117 * 16u;
            vec2 _100 = vec2(Bias.data[_119], Bias.data[_119 + 1u]);
            uint _128 = _119 + 2u;
            vec2 _101 = vec2(Bias.data[_128], Bias.data[_128 + 1u]);
            uint _136 = _119 + 4u;
            vec2 _102 = vec2(Bias.data[_136], Bias.data[_136 + 1u]);
            uint _144 = _119 + 6u;
            vec2 _103 = vec2(Bias.data[_144], Bias.data[_144 + 1u]);
            uint _151 = _119 + 8u;
            vec2 _104 = vec2(Bias.data[_151], Bias.data[_151 + 1u]);
            uint _159 = _119 + 10u;
            vec2 _105 = vec2(Bias.data[_159], Bias.data[_159 + 1u]);
            uint _167 = _119 + 12u;
            vec2 _106 = vec2(Bias.data[_167], Bias.data[_167 + 1u]);
            uint _175 = _119 + 14u;
            vec2 _107 = vec2(Bias.data[_175], Bias.data[_175 + 1u]);
            uint _99 = 0u;
            uint _182;
            for (;;)
            {
                _182 = _99;
                if (_182 < 32u)
                {
                    vec2 _186 = vec2(X.data[_182]);
                    _100 = fma(_186, vec2(W.data[((_114 + _182) * _112) + (_116 + _119)], W.data[((_114 + _182) * _112) + (_116 + (_119 + 1u))]), _100);
                    uint _203 = _119 + 2u;
                    _101 = fma(_186, vec2(W.data[((_114 + _182) * _112) + (_116 + _203)], W.data[((_114 + _182) * _112) + (_116 + (_203 + 1u))]), _101);
                    uint _220 = _119 + 4u;
                    _102 = fma(_186, vec2(W.data[((_114 + _182) * _112) + (_116 + _220)], W.data[((_114 + _182) * _112) + (_116 + (_220 + 1u))]), _102);
                    uint _237 = _119 + 6u;
                    _103 = fma(_186, vec2(W.data[((_114 + _182) * _112) + (_116 + _237)], W.data[((_114 + _182) * _112) + (_116 + (_237 + 1u))]), _103);
                    uint _254 = _119 + 8u;
                    _104 = fma(_186, vec2(W.data[((_114 + _182) * _112) + (_116 + _254)], W.data[((_114 + _182) * _112) + (_116 + (_254 + 1u))]), _104);
                    uint _271 = _119 + 10u;
                    _105 = fma(_186, vec2(W.data[((_114 + _182) * _112) + (_116 + _271)], W.data[((_114 + _182) * _112) + (_116 + (_271 + 1u))]), _105);
                    uint _288 = _119 + 12u;
                    _106 = fma(_186, vec2(W.data[((_114 + _182) * _112) + (_116 + _288)], W.data[((_114 + _182) * _112) + (_116 + (_288 + 1u))]), _106);
                    uint _305 = _119 + 14u;
                    _107 = fma(_186, vec2(W.data[((_114 + _182) * _112) + (_116 + _305)], W.data[((_114 + _182) * _112) + (_116 + (_305 + 1u))]), _107);
                    _99 = _182 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _97[_117 * 8u] = _100;
            _97[(_117 * 8u) + 1u] = _101;
            _97[(_117 * 8u) + 2u] = _102;
            _97[(_117 * 8u) + 3u] = _103;
            _97[(_117 * 8u) + 4u] = _104;
            _97[(_117 * 8u) + 5u] = _105;
            _97[(_117 * 8u) + 6u] = _106;
            _97[(_117 * 8u) + 7u] = _107;
            _98 = _117 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _97;
}

void _360(uint _361, vec2 _362)
{
    Y.data[_361] = _362.x;
    Y.data[_361 + 1u] = _362.y;
}

void main()
{
    vec2 _58[8] = _79();
    vec2 tempArg[8] = _58;
    vec2 y[8] = _58;
    vec2 _370[8] = _58;
    uint _371 = 0u;
    uint _376;
    for (;;)
    {
        _376 = _371;
        if (_376 < 16u)
        {
            _360(0u + _376, _370[_376 / 2u]);
            _371 = _376 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

