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
    uint _78 = 0u / 4u;
    uint _79 = 0u % 4u;
    uint _83 = ((uint(0) + _78) * uint(4)) + (uint(0) + _79);
    uint _93 = 1u / 4u;
    uint _94 = 1u % 4u;
    uint _98 = ((uint(0) + _93) * uint(4)) + (uint(0) + _94);
    uint _108 = 2u / 4u;
    uint _109 = 2u % 4u;
    uint _113 = ((uint(0) + _108) * uint(4)) + (uint(0) + _109);
    uint _123 = 3u / 4u;
    uint _124 = 3u % 4u;
    uint _128 = ((uint(0) + _123) * uint(4)) + (uint(0) + _124);
    uint _137 = 4u / 4u;
    uint _138 = 4u % 4u;
    uint _142 = ((uint(0) + _137) * uint(4)) + (uint(0) + _138);
    uint _152 = 5u / 4u;
    uint _153 = 5u % 4u;
    uint _157 = ((uint(0) + _152) * uint(4)) + (uint(0) + _153);
    uint _167 = 6u / 4u;
    uint _168 = 6u % 4u;
    uint _172 = ((uint(0) + _167) * uint(4)) + (uint(0) + _168);
    uint _182 = 7u / 4u;
    uint _183 = 7u % 4u;
    uint _187 = ((uint(0) + _182) * uint(4)) + (uint(0) + _183);
    uint _196 = 8u / 4u;
    uint _197 = 8u % 4u;
    uint _201 = ((uint(0) + _196) * uint(4)) + (uint(0) + _197);
    uint _211 = 9u / 4u;
    uint _212 = 9u % 4u;
    uint _216 = ((uint(0) + _211) * uint(4)) + (uint(0) + _212);
    uint _226 = 10u / 4u;
    uint _227 = 10u % 4u;
    uint _231 = ((uint(0) + _226) * uint(4)) + (uint(0) + _227);
    uint _241 = 11u / 4u;
    uint _242 = 11u % 4u;
    uint _246 = ((uint(0) + _241) * uint(4)) + (uint(0) + _242);
    uint _256 = 12u / 4u;
    uint _257 = 12u % 4u;
    uint _261 = ((uint(0) + _256) * uint(4)) + (uint(0) + _257);
    uint _271 = 13u / 4u;
    uint _272 = 13u % 4u;
    uint _276 = ((uint(0) + _271) * uint(4)) + (uint(0) + _272);
    uint _286 = 14u / 4u;
    uint _287 = 14u % 4u;
    uint _291 = ((uint(0) + _286) * uint(4)) + (uint(0) + _287);
    uint _301 = 15u / 4u;
    uint _302 = 15u % 4u;
    uint _306 = ((uint(0) + _301) * uint(4)) + (uint(0) + _302);
    uint _347 = 0u / 4u;
    uint _348 = 0u % 4u;
    uint _361 = 1u / 4u;
    uint _362 = 1u % 4u;
    uint _375 = 2u / 4u;
    uint _376 = 2u % 4u;
    uint _389 = 3u / 4u;
    uint _390 = 3u % 4u;
    uint _403 = 4u / 4u;
    uint _404 = 4u % 4u;
    uint _417 = 5u / 4u;
    uint _418 = 5u % 4u;
    uint _431 = 6u / 4u;
    uint _432 = 6u % 4u;
    uint _445 = 7u / 4u;
    uint _446 = 7u % 4u;
    uint _459 = 8u / 4u;
    uint _460 = 8u % 4u;
    uint _473 = 9u / 4u;
    uint _474 = 9u % 4u;
    uint _487 = 10u / 4u;
    uint _488 = 10u % 4u;
    uint _501 = 11u / 4u;
    uint _502 = 11u % 4u;
    uint _515 = 12u / 4u;
    uint _516 = 12u % 4u;
    uint _529 = 13u / 4u;
    uint _530 = 13u % 4u;
    uint _543 = 14u / 4u;
    uint _544 = 14u % 4u;
    uint _557 = 15u / 4u;
    uint _558 = 15u % 4u;
    vec2 _570 = fma(vec2(A.data[_113], A.data[_128]), vec2(_13[4].x, _13[6].x), fma(vec2(A.data[_83], A.data[_98]), vec2(_13[0].x, _13[2].x), vec2(0.0)));
    vec2 _580 = fma(vec2(A.data[_113], A.data[_128]), vec2(_13[4].y, _13[6].y), fma(vec2(A.data[_83], A.data[_98]), vec2(_13[0].y, _13[2].y), vec2(0.0)));
    vec2 _590 = fma(vec2(A.data[_113], A.data[_128]), vec2(_13[5].x, _13[7].x), fma(vec2(A.data[_83], A.data[_98]), vec2(_13[1].x, _13[3].x), vec2(0.0)));
    vec2 _600 = fma(vec2(A.data[_113], A.data[_128]), vec2(_13[5].y, _13[7].y), fma(vec2(A.data[_83], A.data[_98]), vec2(_13[1].y, _13[3].y), vec2(0.0)));
    vec2 _610 = fma(vec2(A.data[_172], A.data[_187]), vec2(_13[4].x, _13[6].x), fma(vec2(A.data[_142], A.data[_157]), vec2(_13[0].x, _13[2].x), vec2(0.0)));
    vec2 _620 = fma(vec2(A.data[_172], A.data[_187]), vec2(_13[4].y, _13[6].y), fma(vec2(A.data[_142], A.data[_157]), vec2(_13[0].y, _13[2].y), vec2(0.0)));
    vec2 _630 = fma(vec2(A.data[_172], A.data[_187]), vec2(_13[5].x, _13[7].x), fma(vec2(A.data[_142], A.data[_157]), vec2(_13[1].x, _13[3].x), vec2(0.0)));
    vec2 _640 = fma(vec2(A.data[_172], A.data[_187]), vec2(_13[5].y, _13[7].y), fma(vec2(A.data[_142], A.data[_157]), vec2(_13[1].y, _13[3].y), vec2(0.0)));
    vec2 _650 = fma(vec2(A.data[_231], A.data[_246]), vec2(_13[4].x, _13[6].x), fma(vec2(A.data[_201], A.data[_216]), vec2(_13[0].x, _13[2].x), vec2(0.0)));
    vec2 _660 = fma(vec2(A.data[_231], A.data[_246]), vec2(_13[4].y, _13[6].y), fma(vec2(A.data[_201], A.data[_216]), vec2(_13[0].y, _13[2].y), vec2(0.0)));
    vec2 _670 = fma(vec2(A.data[_231], A.data[_246]), vec2(_13[5].x, _13[7].x), fma(vec2(A.data[_201], A.data[_216]), vec2(_13[1].x, _13[3].x), vec2(0.0)));
    vec2 _680 = fma(vec2(A.data[_231], A.data[_246]), vec2(_13[5].y, _13[7].y), fma(vec2(A.data[_201], A.data[_216]), vec2(_13[1].y, _13[3].y), vec2(0.0)));
    vec2 _690 = fma(vec2(A.data[_291], A.data[_306]), vec2(_13[4].x, _13[6].x), fma(vec2(A.data[_261], A.data[_276]), vec2(_13[0].x, _13[2].x), vec2(0.0)));
    vec2 _700 = fma(vec2(A.data[_291], A.data[_306]), vec2(_13[4].y, _13[6].y), fma(vec2(A.data[_261], A.data[_276]), vec2(_13[0].y, _13[2].y), vec2(0.0)));
    vec2 _710 = fma(vec2(A.data[_291], A.data[_306]), vec2(_13[5].x, _13[7].x), fma(vec2(A.data[_261], A.data[_276]), vec2(_13[1].x, _13[3].x), vec2(0.0)));
    vec2 _720 = fma(vec2(A.data[_291], A.data[_306]), vec2(_13[5].y, _13[7].y), fma(vec2(A.data[_261], A.data[_276]), vec2(_13[1].y, _13[3].y), vec2(0.0)));
    return vec2[](vec2((_570.x + _570.y) + C.data[((uint(0) + _347) * uint(4)) + (uint(0) + _348)], (_580.x + _580.y) + C.data[((uint(0) + _361) * uint(4)) + (uint(0) + _362)]), vec2((_590.x + _590.y) + C.data[((uint(0) + _375) * uint(4)) + (uint(0) + _376)], (_600.x + _600.y) + C.data[((uint(0) + _389) * uint(4)) + (uint(0) + _390)]), vec2((_610.x + _610.y) + C.data[((uint(0) + _403) * uint(4)) + (uint(0) + _404)], (_620.x + _620.y) + C.data[((uint(0) + _417) * uint(4)) + (uint(0) + _418)]), vec2((_630.x + _630.y) + C.data[((uint(0) + _431) * uint(4)) + (uint(0) + _432)], (_640.x + _640.y) + C.data[((uint(0) + _445) * uint(4)) + (uint(0) + _446)]), vec2((_650.x + _650.y) + C.data[((uint(0) + _459) * uint(4)) + (uint(0) + _460)], (_660.x + _660.y) + C.data[((uint(0) + _473) * uint(4)) + (uint(0) + _474)]), vec2((_670.x + _670.y) + C.data[((uint(0) + _487) * uint(4)) + (uint(0) + _488)], (_680.x + _680.y) + C.data[((uint(0) + _501) * uint(4)) + (uint(0) + _502)]), vec2((_690.x + _690.y) + C.data[((uint(0) + _515) * uint(4)) + (uint(0) + _516)], (_700.x + _700.y) + C.data[((uint(0) + _529) * uint(4)) + (uint(0) + _530)]), vec2((_710.x + _710.y) + C.data[((uint(0) + _543) * uint(4)) + (uint(0) + _544)], (_720.x + _720.y) + C.data[((uint(0) + _557) * uint(4)) + (uint(0) + _558)]));
}

void _736(uint _737, vec2 _738)
{
    D.data[_737] = _738.x;
    D.data[_737 + 1u] = _738.y;
}

void main()
{
    vec2 _48[8] = _65();
    vec2 tempArg[8] = _48;
    vec2 d[8] = _48;
    vec2 _751[8] = _48;
    uint _752 = 0u;
    uint _757;
    for (;;)
    {
        _757 = _752;
        if (_757 < 16u)
        {
            _736(((uint(0) + (_757 / 4u)) * uint(4)) + (uint(0) + (_757 % 4u)), _751[_757 / 2u]);
            _752 = _757 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

