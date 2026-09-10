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

float[3] _74()
{
    vec2 _181 = fma(vec2(X.data[6u]), vec2(W.data[18u], W.data[19u]), fma(vec2(X.data[5u]), vec2(W.data[15u], W.data[16u]), fma(vec2(X.data[4u]), vec2(W.data[12u], W.data[13u]), fma(vec2(X.data[3u]), vec2(W.data[9u], W.data[10u]), fma(vec2(X.data[2u]), vec2(W.data[6u], W.data[7u]), fma(vec2(X.data[1u]), vec2(W.data[3u], W.data[4u]), fma(vec2(X.data[0u]), vec2(W.data[0u], W.data[1u]), vec2(0.0))))))));
    return float[](_181.x, _181.y, fma(X.data[6u], W.data[20u], fma(X.data[5u], W.data[17u], fma(X.data[4u], W.data[14u], fma(X.data[3u], W.data[11u], fma(X.data[2u], W.data[8u], fma(X.data[1u], W.data[5u], fma(X.data[0u], W.data[2u], 0.0))))))));
}

void main()
{
    float _48[3] = _74();
    float tempArg[3] = _48;
    float outputValue[3] = _48;
    uint _187 = 0u + 0u;
    Y.data[_187] = _48[0];
    uint _190 = 0u + 1u;
    Y.data[_190] = _48[1];
    uint _193 = 0u + 2u;
    Y.data[_193] = _48[2];
}

