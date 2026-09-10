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

vec2[2] _75()
{
    vec2 _189 = vec2(X.data[0u]);
    vec2 _194 = vec2(X.data[1u]);
    vec2 _199 = vec2(X.data[2u]);
    vec2 _204 = vec2(X.data[3u]);
    vec2 _209 = vec2(X.data[4u]);
    vec2 _214 = vec2(X.data[5u]);
    vec2 _219 = vec2(X.data[6u]);
    vec2 _224 = vec2(X.data[7u]);
    return vec2[](fma(_224, vec2(W.data[28u], W.data[29u]), fma(_219, vec2(W.data[24u], W.data[25u]), fma(_214, vec2(W.data[20u], W.data[21u]), fma(_209, vec2(W.data[16u], W.data[17u]), fma(_204, vec2(W.data[12u], W.data[13u]), fma(_199, vec2(W.data[8u], W.data[9u]), fma(_194, vec2(W.data[4u], W.data[5u]), fma(_189, vec2(W.data[0u], W.data[1u]), vec2(0.0))))))))), fma(_224, vec2(W.data[30u], W.data[31u]), fma(_219, vec2(W.data[26u], W.data[27u]), fma(_214, vec2(W.data[22u], W.data[23u]), fma(_209, vec2(W.data[18u], W.data[19u]), fma(_204, vec2(W.data[14u], W.data[15u]), fma(_199, vec2(W.data[10u], W.data[11u]), fma(_194, vec2(W.data[6u], W.data[7u]), fma(_189, vec2(W.data[2u], W.data[3u]), vec2(0.0))))))))));
}

void _231(uint _232, vec2 _233)
{
    Y.data[_232] = _233.x;
    Y.data[_232 + 1u] = _233.y;
}

void main()
{
    vec2 _48[2] = _75();
    vec2 tempArg[2] = _48;
    vec2 outputValue[2] = _48;
    vec2 _245[2] = _48;
    uint _246 = 0u;
    uint _251;
    for (;;)
    {
        _251 = _246;
        if (_251 < 4u)
        {
            _231(0u + _251, _245[_251 / 2u]);
            _246 = _251 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

