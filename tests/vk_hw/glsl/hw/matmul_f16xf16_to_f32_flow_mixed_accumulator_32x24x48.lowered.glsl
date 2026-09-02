#version 450
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct MixedLeftTile
{
    f16vec2 value[768];
    uvec4 residency;
};

struct MixedRightTile
{
    f16vec2 value[576];
    uvec4 residency;
};

struct MixedAccumulatorTile
{
    vec2 value[384];
    uvec4 revision;
};

struct MixedRequestLane
{
    MixedLeftTile left;
    MixedRightTile right;
    uvec4 scheduling;
};

struct MixedDispatchRequest
{
    MixedRequestLane lanes[2];
    MixedAccumulatorTile accumulator;
    uint selectedLane;
    bool contractValid;
};

struct MixedResultTile
{
    vec2 value[384];
    uvec4 completion;
};

struct MixedResponse
{
    MixedResultTile result;
    uint selectedLane;
    bool committed;
};

const ivec2 _109[3] = ivec2[](ivec2(32, 48), ivec2(48, 24), ivec2(32, 24));

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

uint selectMixedLane()
{
    uint workgroupKey = gl_WorkGroupID.x ^ (gl_WorkGroupID.y << 1u);
    uint invocationKey = gl_LocalInvocationIndex + gl_GlobalInvocationID.x;
    return (workgroupKey ^ invocationKey) & 1u;
}

f16vec2 _618(uint _619)
{
    return f16vec2(A.data[_619], A.data[_619 + 1u]);
}

MixedLeftTile loadMixedLeftTile()
{
    uint _631 = 0u;
    f16vec2 _630[768];
    uint _636;
    for (;;)
    {
        _636 = _631;
        if (_636 < 1536u)
        {
            _630[_636 / 2u] = _618(((uint(0) + (_636 / 48u)) * uint(48)) + (uint(0) + (_636 % 48u)));
            _631 = _636 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _157[768] = _630;
    f16vec2 tempArg[768] = _157;
    MixedLeftTile tile;
    tile.value = _157;
    tile.residency = uvec4(32u, 48u, 0u, 1u);
    return tile;
}

f16vec2 _655(uint _656)
{
    return f16vec2(B.data[_656], B.data[_656 + 1u]);
}

MixedRightTile loadMixedRightTile()
{
    uint _667 = 0u;
    f16vec2 _666[576];
    uint _672;
    for (;;)
    {
        _672 = _667;
        if (_672 < 1152u)
        {
            _666[_672 / 2u] = _655(((uint(0) + (_672 / 24u)) * uint(24)) + (uint(0) + (_672 % 24u)));
            _667 = _672 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _176[576] = _666;
    f16vec2 tempArg[576] = _176;
    f16vec2 _179[576] = _176;
    MixedRightTile tile;
    tile.value = _179;
    tile.residency = uvec4(48u, 24u, 1u, 1u);
    return tile;
}

vec2 _692(uint _693)
{
    return vec2(C.data[_693], C.data[_693 + 1u]);
}

MixedAccumulatorTile loadMixedAccumulatorTile()
{
    uint _704 = 0u;
    vec2 _703[384];
    uint _709;
    for (;;)
    {
        _709 = _704;
        if (_709 < 768u)
        {
            _703[_709 / 2u] = _692(((uint(0) + (_709 / 24u)) * uint(24)) + (uint(0) + (_709 % 24u)));
            _704 = _709 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _195[384] = _703;
    vec2 tempArg[384] = _195;
    vec2 _198[384] = _195;
    MixedAccumulatorTile tile;
    tile.value = _198;
    tile.revision = uvec4(32u, 24u, 2u, 1u);
    return tile;
}

bool validateMixedContract()
{
    bool positiveDimensions = true;
    for (uint shapeIndex = 0u; shapeIndex < 3u; shapeIndex++)
    {
        bool _133;
        if (positiveDimensions)
        {
            _133 = all(greaterThan(_109[shapeIndex], ivec2(0)));
        }
        else
        {
            _133 = positiveDimensions;
        }
        positiveDimensions = _133;
    }
    bool innerMatches = true;
    bool rowsMatch = true;
    bool columnsMatch = true;
    return ((positiveDimensions && innerMatches) && rowsMatch) && columnsMatch;
}

MixedDispatchRequest buildMixedRequest(MixedLeftTile left, MixedRightTile right, MixedAccumulatorTile accumulator, uint selectedLane)
{
    MixedDispatchRequest request;
    request.accumulator = accumulator;
    request.selectedLane = selectedLane;
    request.contractValid = validateMixedContract();
    for (uint lane = 0u; lane < 2u; lane++)
    {
        request.lanes[lane].left = left;
        request.lanes[lane].right = right;
        request.lanes[lane].scheduling = uvec4(lane, selectedLane, uint(lane == selectedLane), 1u);
    }
    return request;
}

MixedDispatchRequest normalizeMixedRequest(inout MixedDispatchRequest request)
{
    uint selectedLane = request.selectedLane & 1u;
    MixedRequestLane residentLane = request.lanes[selectedLane];
    for (uint probe = 0u; probe < 3u; probe++)
    {
        uint candidateIndex = (selectedLane + probe) & 1u;
        MixedRequestLane candidate = request.lanes[candidateIndex];
        bool _272 = candidate.left.residency.w != 0u;
        bool _278;
        if (_272)
        {
            _278 = candidate.right.residency.w != 0u;
        }
        else
        {
            _278 = _272;
        }
        bool candidateReady = _278;
        residentLane = candidateReady ? candidate : residentLane;
    }
    switch (selectedLane)
    {
        case 0u:
        {
            request.lanes[0] = residentLane;
            break;
        }
        case 1u:
        {
            request.lanes[1] = residentLane;
            break;
        }
        default:
        {
            request.lanes[0] = residentLane;
            request.selectedLane = 0u;
            break;
        }
    }
    return request;
}

vec2[384] _416(f16vec2 _417[768], f16vec2 _418[576], vec2 _419[384])
{
    f16vec2 _445[768] = _417;
    f16vec2 _446[576] = _418;
    vec2 _447[384] = _419;
    vec2 _438[384] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _439 = 0u;
    uint _448;
    for (;;)
    {
        _448 = _439;
        if (_448 < 96u)
        {
            uint _450 = _448 / 3u;
            uint _452 = (_448 % 3u) * 8u;
            uint _453 = _450 * 24u;
            uint _455 = _453 + _452;
            uint _456 = _455 + 1u;
            vec2 _441 = vec2(_447[_455 / 2u][_455 % 2u], _447[_456 / 2u][_456 % 2u]);
            uint _468 = _452 + 2u;
            uint _470 = _453 + _468;
            uint _471 = _470 + 1u;
            vec2 _442 = vec2(_447[_470 / 2u][_470 % 2u], _447[_471 / 2u][_471 % 2u]);
            uint _484 = _452 + 4u;
            uint _486 = _453 + _484;
            uint _487 = _486 + 1u;
            vec2 _443 = vec2(_447[_486 / 2u][_486 % 2u], _447[_487 / 2u][_487 % 2u]);
            uint _500 = _452 + 6u;
            uint _502 = _453 + _500;
            uint _503 = _502 + 1u;
            vec2 _444 = vec2(_447[_502 / 2u][_502 % 2u], _447[_503 / 2u][_503 % 2u]);
            uint _440 = 0u;
            uint _515;
            for (;;)
            {
                _515 = _440;
                if (_515 < 48u)
                {
                    uint _518 = (_450 * 48u) + _515;
                    vec2 _526 = vec2(f16vec2(_445[_518 / 2u][_518 % 2u]));
                    uint _527 = _515 * 24u;
                    uint _529 = _527 + _452;
                    uint _530 = _529 + 1u;
                    _441 = fma(_526, vec2(f16vec2(_446[_529 / 2u][_529 % 2u], _446[_530 / 2u][_530 % 2u])), _441);
                    uint _545 = _452 + 2u;
                    uint _547 = _527 + _545;
                    uint _548 = _547 + 1u;
                    _442 = fma(_526, vec2(f16vec2(_446[_547 / 2u][_547 % 2u], _446[_548 / 2u][_548 % 2u])), _442);
                    uint _563 = _452 + 4u;
                    uint _565 = _527 + _563;
                    uint _566 = _565 + 1u;
                    _443 = fma(_526, vec2(f16vec2(_446[_565 / 2u][_565 % 2u], _446[_566 / 2u][_566 % 2u])), _443);
                    uint _581 = _452 + 6u;
                    uint _583 = _527 + _581;
                    uint _584 = _583 + 1u;
                    _444 = fma(_526, vec2(f16vec2(_446[_583 / 2u][_583 % 2u], _446[_584 / 2u][_584 % 2u])), _444);
                    _440 = _515 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _438[_448 * 4u] = _441;
            _438[(_448 * 4u) + 1u] = _442;
            _438[(_448 * 4u) + 2u] = _443;
            _438[(_448 * 4u) + 3u] = _444;
            _439 = _448 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _438;
}

MixedResponse executeMixedRequest(MixedDispatchRequest request)
{
    uint laneIndex = request.selectedLane & 1u;
    MixedRequestLane lane = request.lanes[laneIndex];
    vec2 _319[384] = _416(lane.left.value, lane.right.value, request.accumulator.value);
    vec2 tempArg[384] = _319;
    vec2 _322[384] = _319;
    MixedResponse response;
    response.result.value = _322;
    response.result.completion = uvec4(laneIndex, 32u, 24u, 1u);
    response.selectedLane = laneIndex;
    response.committed = request.contractValid;
    return response;
}

MixedResponse finalizeMixedResponse(inout MixedResponse response)
{
    bool resultReady = response.result.completion.w != 0u;
    response.committed = response.committed && resultReady;
    switch (response.selectedLane)
    {
        case 0u:
        {
            return response;
        }
        case 1u:
        {
            return response;
        }
        default:
        {
            response.selectedLane = 0u;
            return response;
        }
    }
}

void _729(uint _730, vec2 _731)
{
    D.data[_730] = _731.x;
    D.data[_730 + 1u] = _731.y;
}

void storeMixedResponse(inout MixedResponse response)
{
    if (!response.committed)
    {
        response.committed = true;
    }
    vec2 _739[384] = response.result.value;
    uint _740 = 0u;
    uint _745;
    for (;;)
    {
        _745 = _740;
        if (_745 < 768u)
        {
            _729(((uint(0) + (_745 / 24u)) * uint(24)) + (uint(0) + (_745 % 24u)), _739[_745 / 2u]);
            _740 = _745 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

void main()
{
    uint selectedLane = selectMixedLane();
    MixedLeftTile _376 = loadMixedLeftTile();
    MixedLeftTile left = _376;
    MixedRightTile _378 = loadMixedRightTile();
    MixedRightTile right = _378;
    MixedAccumulatorTile _380 = loadMixedAccumulatorTile();
    MixedAccumulatorTile accumulator = _380;
    MixedLeftTile param = _376;
    MixedRightTile param_1 = _378;
    MixedAccumulatorTile param_2 = _380;
    uint param_3 = selectedLane;
    MixedDispatchRequest _390 = buildMixedRequest(param, param_1, param_2, param_3);
    MixedDispatchRequest request = _390;
    MixedDispatchRequest param_4 = _390;
    MixedDispatchRequest _394 = normalizeMixedRequest(param_4);
    MixedDispatchRequest normalized = _394;
    MixedDispatchRequest param_5 = _394;
    MixedResponse _398 = executeMixedRequest(param_5);
    MixedResponse response = _398;
    MixedResponse param_6 = _398;
    MixedResponse _402 = finalizeMixedResponse(param_6);
    MixedResponse finalResponse = _402;
    MixedResponse param_7 = _402;
    storeMixedResponse(param_7);
}

