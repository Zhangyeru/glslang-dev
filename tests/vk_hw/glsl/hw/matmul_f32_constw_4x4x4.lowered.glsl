#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

const vec2 _13[8] = vec2[](vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5), vec2(0.5));

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec2[8] _65()
{
    vec2 _181 = vec2(A.data[0u]);
    vec2 _186 = vec2(A.data[1u]);
    vec2 _191 = vec2(A.data[2u]);
    vec2 _196 = vec2(A.data[3u]);
    vec2 _203 = vec2(A.data[4u]);
    vec2 _208 = vec2(A.data[5u]);
    vec2 _213 = vec2(A.data[6u]);
    vec2 _218 = vec2(A.data[7u]);
    vec2 _225 = vec2(A.data[8u]);
    vec2 _230 = vec2(A.data[9u]);
    vec2 _235 = vec2(A.data[10u]);
    vec2 _240 = vec2(A.data[11u]);
    vec2 _247 = vec2(A.data[12u]);
    vec2 _252 = vec2(A.data[13u]);
    vec2 _257 = vec2(A.data[14u]);
    vec2 _262 = vec2(A.data[15u]);
    return vec2[](fma(_196, vec2(_13[6].x, _13[6].y), fma(_191, vec2(_13[4].x, _13[4].y), fma(_186, vec2(_13[2].x, _13[2].y), fma(_181, vec2(_13[0].x, _13[0].y), vec2(C.data[0u], C.data[1u]))))), fma(_196, vec2(_13[7].x, _13[7].y), fma(_191, vec2(_13[5].x, _13[5].y), fma(_186, vec2(_13[3].x, _13[3].y), fma(_181, vec2(_13[1].x, _13[1].y), vec2(C.data[2u], C.data[3u]))))), fma(_218, vec2(_13[6].x, _13[6].y), fma(_213, vec2(_13[4].x, _13[4].y), fma(_208, vec2(_13[2].x, _13[2].y), fma(_203, vec2(_13[0].x, _13[0].y), vec2(C.data[4u], C.data[5u]))))), fma(_218, vec2(_13[7].x, _13[7].y), fma(_213, vec2(_13[5].x, _13[5].y), fma(_208, vec2(_13[3].x, _13[3].y), fma(_203, vec2(_13[1].x, _13[1].y), vec2(C.data[6u], C.data[7u]))))), fma(_240, vec2(_13[6].x, _13[6].y), fma(_235, vec2(_13[4].x, _13[4].y), fma(_230, vec2(_13[2].x, _13[2].y), fma(_225, vec2(_13[0].x, _13[0].y), vec2(C.data[8u], C.data[9u]))))), fma(_240, vec2(_13[7].x, _13[7].y), fma(_235, vec2(_13[5].x, _13[5].y), fma(_230, vec2(_13[3].x, _13[3].y), fma(_225, vec2(_13[1].x, _13[1].y), vec2(C.data[10u], C.data[11u]))))), fma(_262, vec2(_13[6].x, _13[6].y), fma(_257, vec2(_13[4].x, _13[4].y), fma(_252, vec2(_13[2].x, _13[2].y), fma(_247, vec2(_13[0].x, _13[0].y), vec2(C.data[12u], C.data[13u]))))), fma(_262, vec2(_13[7].x, _13[7].y), fma(_257, vec2(_13[5].x, _13[5].y), fma(_252, vec2(_13[3].x, _13[3].y), fma(_247, vec2(_13[1].x, _13[1].y), vec2(C.data[14u], C.data[15u]))))));
}

void _270(uint _271, vec2 _272)
{
    D.data[_271] = _272.x;
    D.data[_271 + 1u] = _272.y;
}

void main()
{
    vec2 _48[8] = _65();
    vec2 tempArg[8] = _48;
    vec2 d[8] = _48;
    vec2 _285[8] = _48;
    uint _286 = 0u;
    uint _291;
    for (;;)
    {
        _291 = _286;
        if (_291 < 16u)
        {
            _270(((uint(0) + (_291 / 4u)) * uint(4)) + (uint(0) + (_291 % 4u)), _285[_291 / 2u]);
            _286 = _291 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

