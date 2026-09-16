#version 460
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

void _87(inout vec2 _89[65533], vec2 _88)
{
    for (uint _96 = 0u; _96 < 65533u; _96++)
    {
        _89[_96] = _88;
    }
}

void main()
{
    vec2 _82[65533];
    _87(_82, vec2(1.0));
    uint i = gl_GlobalInvocationID.x;
    int _25 = int(i);
    float _26 = _82[_25 / 2][_25 - 2 * (_25 / 2)];
    int _30 = int(i + 131065u);
    float _31 = _82[_30 / 2][_30 - 2 * (_30 / 2)];
    float check = (_26 + _31) - 2.0;
    float _52[35] = float[](A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)], A.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)]);
    float tempArg[35] = _52;
    float value[35] = _52;
    float _610[35] = _52;
    float _611[35] = float[](check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check, check);
    uint _609 = 0u;
    float _608[35];
    uint _616;
    for (;;)
    {
        _616 = _609;
        if (_616 < 35u)
        {
            _608[_616] = _610[_616] + _611[_616];
            _609 = _616 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    value = _608;
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 0u)] = _608[0];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 1u)] = _608[1];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 2u)] = _608[2];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 3u)] = _608[3];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 4u)] = _608[4];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 5u)] = _608[5];
    D.data[((uint(0) + 0u) * uint(7)) + (uint(0) + 6u)] = _608[6];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 0u)] = _608[7];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 1u)] = _608[8];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 2u)] = _608[9];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 3u)] = _608[10];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 4u)] = _608[11];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 5u)] = _608[12];
    D.data[((uint(0) + 1u) * uint(7)) + (uint(0) + 6u)] = _608[13];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 0u)] = _608[14];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 1u)] = _608[15];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 2u)] = _608[16];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 3u)] = _608[17];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 4u)] = _608[18];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 5u)] = _608[19];
    D.data[((uint(0) + 2u) * uint(7)) + (uint(0) + 6u)] = _608[20];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 0u)] = _608[21];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 1u)] = _608[22];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 2u)] = _608[23];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 3u)] = _608[24];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 4u)] = _608[25];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 5u)] = _608[26];
    D.data[((uint(0) + 3u) * uint(7)) + (uint(0) + 6u)] = _608[27];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 0u)] = _608[28];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 1u)] = _608[29];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 2u)] = _608[30];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 3u)] = _608[31];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 4u)] = _608[32];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 5u)] = _608[33];
    D.data[((uint(0) + 4u) * uint(7)) + (uint(0) + 6u)] = _608[34];
}

