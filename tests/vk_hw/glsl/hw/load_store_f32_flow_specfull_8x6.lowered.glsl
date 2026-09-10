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

void main()
{
    float _64 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 0u)];
    float _78 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 0u)];
    float _94 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 0u)];
    float _109 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 0u)];
    float _125 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 0u)];
    float _140 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 0u)];
    float _155 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 1u)];
    float _169 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 1u)];
    float _184 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 1u)];
    float _198 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 1u)];
    float _213 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 1u)];
    float _227 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 1u)];
    float _242 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 2u)];
    float _256 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 2u)];
    float _271 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 2u)];
    float _285 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 2u)];
    float _300 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 2u)];
    float _314 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 2u)];
    float _329 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 3u)];
    float _343 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 3u)];
    float _358 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 3u)];
    float _372 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 3u)];
    float _387 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 3u)];
    float _401 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 3u)];
    float _416 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 4u)];
    float _430 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 4u)];
    float _445 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 4u)];
    float _459 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 4u)];
    float _474 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 4u)];
    float _488 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 4u)];
    float _503 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 5u)];
    float _517 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 5u)];
    float _532 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 5u)];
    float _546 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 5u)];
    float _561 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 5u)];
    float _575 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 5u)];
    float _591 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 6u)];
    float _605 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 6u)];
    float _620 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 6u)];
    float _634 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 6u)];
    float _649 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 6u)];
    float _663 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 6u)];
    float _679 = A.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 7u)];
    float _693 = A.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 7u)];
    float _708 = A.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 7u)];
    float _722 = A.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 7u)];
    float _737 = A.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 7u)];
    float _751 = A.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 7u)];
    vec2 _24[24] = vec2[](vec2(_64, _78), vec2(_94, _109), vec2(_125, _140), vec2(_155, _169), vec2(_184, _198), vec2(_213, _227), vec2(_242, _256), vec2(_271, _285), vec2(_300, _314), vec2(_329, _343), vec2(_358, _372), vec2(_387, _401), vec2(_416, _430), vec2(_445, _459), vec2(_474, _488), vec2(_503, _517), vec2(_532, _546), vec2(_561, _575), vec2(_591, _605), vec2(_620, _634), vec2(_649, _663), vec2(_679, _693), vec2(_708, _722), vec2(_737, _751));
    vec2 tempArg[24] = _24;
    vec2 value[24] = _24;
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 0u)] = _24[0].x;
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 0u)] = _24[0].y;
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 0u)] = _24[1].x;
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 0u)] = _24[1].y;
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 0u)] = _24[2].x;
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 0u)] = _24[2].y;
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 1u)] = _24[3].x;
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 1u)] = _24[3].y;
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 1u)] = _24[4].x;
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 1u)] = _24[4].y;
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 1u)] = _24[5].x;
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 1u)] = _24[5].y;
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 2u)] = _24[6].x;
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 2u)] = _24[6].y;
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 2u)] = _24[7].x;
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 2u)] = _24[7].y;
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 2u)] = _24[8].x;
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 2u)] = _24[8].y;
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 3u)] = _24[9].x;
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 3u)] = _24[9].y;
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 3u)] = _24[10].x;
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 3u)] = _24[10].y;
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 3u)] = _24[11].x;
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 3u)] = _24[11].y;
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 4u)] = _24[12].x;
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 4u)] = _24[12].y;
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 4u)] = _24[13].x;
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 4u)] = _24[13].y;
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 4u)] = _24[14].x;
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 4u)] = _24[14].y;
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 5u)] = _24[15].x;
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 5u)] = _24[15].y;
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 5u)] = _24[16].x;
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 5u)] = _24[16].y;
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 5u)] = _24[17].x;
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 5u)] = _24[17].y;
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 6u)] = _24[18].x;
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 6u)] = _24[18].y;
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 6u)] = _24[19].x;
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 6u)] = _24[19].y;
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 6u)] = _24[20].x;
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 6u)] = _24[20].y;
    D.data[((uint(0) + 0u) * uint(8)) + (uint(0) + 7u)] = _24[21].x;
    D.data[((uint(0) + 1u) * uint(8)) + (uint(0) + 7u)] = _24[21].y;
    D.data[((uint(0) + 2u) * uint(8)) + (uint(0) + 7u)] = _24[22].x;
    D.data[((uint(0) + 3u) * uint(8)) + (uint(0) + 7u)] = _24[22].y;
    D.data[((uint(0) + 4u) * uint(8)) + (uint(0) + 7u)] = _24[23].x;
    D.data[((uint(0) + 5u) * uint(8)) + (uint(0) + 7u)] = _24[23].y;
}

