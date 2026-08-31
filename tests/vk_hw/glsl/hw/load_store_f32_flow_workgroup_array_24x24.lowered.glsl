#version 450
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

shared float workgroupValues[576];

vec2 _61(uint _62)
{
    return vec2(A.data[_62], A.data[_62 + 1u]);
}

void _103(uint _104, vec2 _105)
{
    workgroupValues[_104] = _105.x;
    workgroupValues[_104 + 1u] = _105.y;
}

vec2 _138(uint _139)
{
    return vec2(workgroupValues[_139], workgroupValues[_139 + 1u]);
}

void _172(uint _173, vec2 _174)
{
    D.data[_173] = _174.x;
    D.data[_173 + 1u] = _174.y;
}

void main()
{
    uint _78 = 0u;
    vec2 _77[288];
    uint _83;
    for (;;)
    {
        _83 = _78;
        if (_83 < 576u)
        {
            _77[_83 / 2u] = _61(((uint(0) + (_83 / 24u)) * uint(24)) + (uint(0) + (_83 % 24u)));
            _78 = _83 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _24[288] = _77;
    vec2 tempArg[288] = _24;
    vec2 inputValue[288] = _24;
    vec2 _113[288] = _24;
    uint _114 = 0u;
    uint _119;
    for (;;)
    {
        _119 = _114;
        if (_119 < 576u)
        {
            _103(((uint(0) + (_119 / 24u)) * uint(24)) + (uint(0) + (_119 % 24u)), _113[_119 / 2u]);
            _114 = _119 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    memoryBarrierShared();
    barrier();
    uint _148 = 0u;
    vec2 _147[288];
    uint _153;
    for (;;)
    {
        _153 = _148;
        if (_153 < 576u)
        {
            _147[_153 / 2u] = _138(((uint(0) + (_153 / 24u)) * uint(24)) + (uint(0) + (_153 % 24u)));
            _148 = _153 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _36[288] = _147;
    vec2 tempArg_1[288] = _36;
    vec2 result[288] = _36;
    vec2 _182[288] = _36;
    uint _183 = 0u;
    uint _188;
    for (;;)
    {
        _188 = _183;
        if (_188 < 576u)
        {
            _172(((uint(0) + (_188 / 24u)) * uint(24)) + (uint(0) + (_188 % 24u)), _182[_188 / 2u]);
            _183 = _188 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

