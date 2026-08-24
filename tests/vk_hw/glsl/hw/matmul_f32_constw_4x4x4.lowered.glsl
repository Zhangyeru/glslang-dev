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
    vec2 _186 = fma(vec2(A.data[2u], A.data[3u]), vec2(_13[4].x, _13[6].x), fma(vec2(A.data[0u], A.data[1u]), vec2(_13[0].x, _13[2].x), vec2(0.0)));
    vec2 _196 = fma(vec2(A.data[2u], A.data[3u]), vec2(_13[4].y, _13[6].y), fma(vec2(A.data[0u], A.data[1u]), vec2(_13[0].y, _13[2].y), vec2(0.0)));
    vec2 _206 = fma(vec2(A.data[2u], A.data[3u]), vec2(_13[5].x, _13[7].x), fma(vec2(A.data[0u], A.data[1u]), vec2(_13[1].x, _13[3].x), vec2(0.0)));
    vec2 _216 = fma(vec2(A.data[2u], A.data[3u]), vec2(_13[5].y, _13[7].y), fma(vec2(A.data[0u], A.data[1u]), vec2(_13[1].y, _13[3].y), vec2(0.0)));
    vec2 _226 = fma(vec2(A.data[6u], A.data[7u]), vec2(_13[4].x, _13[6].x), fma(vec2(A.data[4u], A.data[5u]), vec2(_13[0].x, _13[2].x), vec2(0.0)));
    vec2 _236 = fma(vec2(A.data[6u], A.data[7u]), vec2(_13[4].y, _13[6].y), fma(vec2(A.data[4u], A.data[5u]), vec2(_13[0].y, _13[2].y), vec2(0.0)));
    vec2 _246 = fma(vec2(A.data[6u], A.data[7u]), vec2(_13[5].x, _13[7].x), fma(vec2(A.data[4u], A.data[5u]), vec2(_13[1].x, _13[3].x), vec2(0.0)));
    vec2 _256 = fma(vec2(A.data[6u], A.data[7u]), vec2(_13[5].y, _13[7].y), fma(vec2(A.data[4u], A.data[5u]), vec2(_13[1].y, _13[3].y), vec2(0.0)));
    vec2 _266 = fma(vec2(A.data[10u], A.data[11u]), vec2(_13[4].x, _13[6].x), fma(vec2(A.data[8u], A.data[9u]), vec2(_13[0].x, _13[2].x), vec2(0.0)));
    vec2 _276 = fma(vec2(A.data[10u], A.data[11u]), vec2(_13[4].y, _13[6].y), fma(vec2(A.data[8u], A.data[9u]), vec2(_13[0].y, _13[2].y), vec2(0.0)));
    vec2 _286 = fma(vec2(A.data[10u], A.data[11u]), vec2(_13[5].x, _13[7].x), fma(vec2(A.data[8u], A.data[9u]), vec2(_13[1].x, _13[3].x), vec2(0.0)));
    vec2 _296 = fma(vec2(A.data[10u], A.data[11u]), vec2(_13[5].y, _13[7].y), fma(vec2(A.data[8u], A.data[9u]), vec2(_13[1].y, _13[3].y), vec2(0.0)));
    vec2 _306 = fma(vec2(A.data[14u], A.data[15u]), vec2(_13[4].x, _13[6].x), fma(vec2(A.data[12u], A.data[13u]), vec2(_13[0].x, _13[2].x), vec2(0.0)));
    vec2 _316 = fma(vec2(A.data[14u], A.data[15u]), vec2(_13[4].y, _13[6].y), fma(vec2(A.data[12u], A.data[13u]), vec2(_13[0].y, _13[2].y), vec2(0.0)));
    vec2 _326 = fma(vec2(A.data[14u], A.data[15u]), vec2(_13[5].x, _13[7].x), fma(vec2(A.data[12u], A.data[13u]), vec2(_13[1].x, _13[3].x), vec2(0.0)));
    vec2 _336 = fma(vec2(A.data[14u], A.data[15u]), vec2(_13[5].y, _13[7].y), fma(vec2(A.data[12u], A.data[13u]), vec2(_13[1].y, _13[3].y), vec2(0.0)));
    return vec2[](vec2((_186.x + _186.y) + C.data[0u], (_196.x + _196.y) + C.data[1u]), vec2((_206.x + _206.y) + C.data[2u], (_216.x + _216.y) + C.data[3u]), vec2((_226.x + _226.y) + C.data[4u], (_236.x + _236.y) + C.data[5u]), vec2((_246.x + _246.y) + C.data[6u], (_256.x + _256.y) + C.data[7u]), vec2((_266.x + _266.y) + C.data[8u], (_276.x + _276.y) + C.data[9u]), vec2((_286.x + _286.y) + C.data[10u], (_296.x + _296.y) + C.data[11u]), vec2((_306.x + _306.y) + C.data[12u], (_316.x + _316.y) + C.data[13u]), vec2((_326.x + _326.y) + C.data[14u], (_336.x + _336.y) + C.data[15u]));
}

void _352(uint _353, vec2 _354)
{
    D.data[_353] = _354.x;
    D.data[_353 + 1u] = _354.y;
}

void main()
{
    vec2 _48[8] = _65();
    vec2 tempArg[8] = _48;
    vec2 d[8] = _48;
    vec2 _367[8] = _48;
    uint _368 = 0u;
    uint _373;
    for (;;)
    {
        _373 = _368;
        if (_373 < 16u)
        {
            _352(((uint(0) + (_373 / 4u)) * uint(4)) + (uint(0) + (_373 % 4u)), _367[_373 / 2u]);
            _368 = _373 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

