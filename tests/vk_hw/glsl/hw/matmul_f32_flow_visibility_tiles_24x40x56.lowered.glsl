#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct VisibilityLeftTile
{
    vec2 value[672];
    uvec4 residency;
};

struct VisibilityRightTile
{
    vec2 value[1120];
    uvec4 residency;
};

struct VisibilityAccumulatorTile
{
    vec2 value[480];
    uvec4 revision;
};

struct VisibilityRequestLane
{
    VisibilityLeftTile left;
    VisibilityRightTile right;
    uvec4 scheduling;
};

struct VisibilityDispatchRequest
{
    VisibilityRequestLane lanes[2];
    VisibilityAccumulatorTile accumulator;
    uint selectedLane;
    bool contractValid;
};

struct VisibilityResultTile
{
    vec2 value[480];
    uvec4 completion;
};

struct VisibilityResponse
{
    VisibilityResultTile result;
    uint selectedLane;
    bool committed;
};

const ivec2 _108[3] = ivec2[](ivec2(24, 56), ivec2(56, 40), ivec2(24, 40));

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

uint selectVisibilityLane()
{
    uint workgroupKey = gl_WorkGroupID.x ^ (gl_WorkGroupID.y << 1u);
    uint invocationKey = gl_LocalInvocationIndex + gl_GlobalInvocationID.x;
    return (workgroupKey ^ invocationKey) & 1u;
}

vec2 _611(uint _612)
{
    return vec2(A.data[_612], A.data[_612 + 1u]);
}

VisibilityLeftTile loadVisibilityLeftTile()
{
    uint _624 = 0u;
    vec2 _623[672];
    uint _629;
    for (;;)
    {
        _629 = _624;
        if (_629 < 1344u)
        {
            _623[_629 / 2u] = _611(((uint(0) + (_629 / 56u)) * uint(56)) + (uint(0) + (_629 % 56u)));
            _624 = _629 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _156[672] = _623;
    vec2 tempArg[672] = _156;
    VisibilityLeftTile tile;
    tile.value = _156;
    tile.residency = uvec4(24u, 56u, 0u, 1u);
    return tile;
}

vec2 _648(uint _649)
{
    return vec2(B.data[_649], B.data[_649 + 1u]);
}

VisibilityRightTile loadVisibilityRightTile()
{
    uint _660 = 0u;
    vec2 _659[1120];
    uint _665;
    for (;;)
    {
        _665 = _660;
        if (_665 < 2240u)
        {
            _659[_665 / 2u] = _648(((uint(0) + (_665 / 40u)) * uint(40)) + (uint(0) + (_665 % 40u)));
            _660 = _665 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _175[1120] = _659;
    vec2 tempArg[1120] = _175;
    vec2 _178[1120] = _175;
    VisibilityRightTile tile;
    tile.value = _178;
    tile.residency = uvec4(56u, 40u, 1u, 1u);
    return tile;
}

vec2 _684(uint _685)
{
    return vec2(C.data[_685], C.data[_685 + 1u]);
}

VisibilityAccumulatorTile loadVisibilityAccumulatorTile()
{
    uint _696 = 0u;
    vec2 _695[480];
    uint _701;
    for (;;)
    {
        _701 = _696;
        if (_701 < 960u)
        {
            _695[_701 / 2u] = _684(((uint(0) + (_701 / 40u)) * uint(40)) + (uint(0) + (_701 % 40u)));
            _696 = _701 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _194[480] = _695;
    vec2 tempArg[480] = _194;
    vec2 _197[480] = _194;
    VisibilityAccumulatorTile tile;
    tile.value = _197;
    tile.revision = uvec4(24u, 40u, 2u, 1u);
    return tile;
}

bool validateVisibilityContract()
{
    bool positiveDimensions = true;
    for (uint shapeIndex = 0u; shapeIndex < 3u; shapeIndex++)
    {
        bool _132;
        if (positiveDimensions)
        {
            _132 = all(greaterThan(_108[shapeIndex], ivec2(0)));
        }
        else
        {
            _132 = positiveDimensions;
        }
        positiveDimensions = _132;
    }
    bool innerMatches = true;
    bool rowsMatch = true;
    bool columnsMatch = true;
    return ((positiveDimensions && innerMatches) && rowsMatch) && columnsMatch;
}

VisibilityDispatchRequest buildVisibilityRequest(VisibilityLeftTile left, VisibilityRightTile right, VisibilityAccumulatorTile accumulator, uint selectedLane)
{
    VisibilityDispatchRequest request;
    request.accumulator = accumulator;
    request.selectedLane = selectedLane;
    request.contractValid = validateVisibilityContract();
    for (uint lane = 0u; lane < 2u; lane++)
    {
        request.lanes[lane].left = left;
        request.lanes[lane].right = right;
        request.lanes[lane].scheduling = uvec4(lane, selectedLane, uint(lane == selectedLane), 1u);
    }
    return request;
}

VisibilityDispatchRequest normalizeVisibilityRequest(inout VisibilityDispatchRequest request)
{
    uint selectedLane = request.selectedLane & 1u;
    VisibilityRequestLane residentLane = request.lanes[selectedLane];
    for (uint probe = 0u; probe < 3u; probe++)
    {
        uint candidateIndex = (selectedLane + probe) & 1u;
        VisibilityRequestLane candidate = request.lanes[candidateIndex];
        bool _271 = candidate.left.residency.w != 0u;
        bool _277;
        if (_271)
        {
            _277 = candidate.right.residency.w != 0u;
        }
        else
        {
            _277 = _271;
        }
        bool candidateReady = _277;
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

vec2[480] _414(vec2 _415[672], vec2 _416[1120], vec2 _417[480])
{
    vec2 _444[672] = _415;
    vec2 _445[1120] = _416;
    vec2 _446[480] = _417;
    vec2 _437[480] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _438 = 0u;
    uint _447;
    for (;;)
    {
        _447 = _438;
        if (_447 < 120u)
        {
            uint _449 = _447 / 5u;
            uint _451 = (_447 % 5u) * 8u;
            uint _452 = _449 * 40u;
            uint _454 = _452 + _451;
            uint _455 = _454 + 1u;
            vec2 _440 = vec2(_446[_454 / 2u][_454 % 2u], _446[_455 / 2u][_455 % 2u]);
            uint _467 = _451 + 2u;
            uint _469 = _452 + _467;
            uint _470 = _469 + 1u;
            vec2 _441 = vec2(_446[_469 / 2u][_469 % 2u], _446[_470 / 2u][_470 % 2u]);
            uint _483 = _451 + 4u;
            uint _485 = _452 + _483;
            uint _486 = _485 + 1u;
            vec2 _442 = vec2(_446[_485 / 2u][_485 % 2u], _446[_486 / 2u][_486 % 2u]);
            uint _499 = _451 + 6u;
            uint _501 = _452 + _499;
            uint _502 = _501 + 1u;
            vec2 _443 = vec2(_446[_501 / 2u][_501 % 2u], _446[_502 / 2u][_502 % 2u]);
            uint _439 = 0u;
            uint _514;
            for (;;)
            {
                _514 = _439;
                if (_514 < 56u)
                {
                    uint _517 = (_449 * 56u) + _514;
                    vec2 _523 = vec2(_444[_517 / 2u][_517 % 2u]);
                    uint _524 = _514 * 40u;
                    uint _526 = _524 + _451;
                    uint _527 = _526 + 1u;
                    _440 = fma(_523, vec2(_445[_526 / 2u][_526 % 2u], _445[_527 / 2u][_527 % 2u]), _440);
                    uint _541 = _451 + 2u;
                    uint _543 = _524 + _541;
                    uint _544 = _543 + 1u;
                    _441 = fma(_523, vec2(_445[_543 / 2u][_543 % 2u], _445[_544 / 2u][_544 % 2u]), _441);
                    uint _558 = _451 + 4u;
                    uint _560 = _524 + _558;
                    uint _561 = _560 + 1u;
                    _442 = fma(_523, vec2(_445[_560 / 2u][_560 % 2u], _445[_561 / 2u][_561 % 2u]), _442);
                    uint _575 = _451 + 6u;
                    uint _577 = _524 + _575;
                    uint _578 = _577 + 1u;
                    _443 = fma(_523, vec2(_445[_577 / 2u][_577 % 2u], _445[_578 / 2u][_578 % 2u]), _443);
                    _439 = _514 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _437[_447 * 4u] = _440;
            _437[(_447 * 4u) + 1u] = _441;
            _437[(_447 * 4u) + 2u] = _442;
            _437[(_447 * 4u) + 3u] = _443;
            _438 = _447 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _437;
}

VisibilityResponse executeVisibilityRequest(VisibilityDispatchRequest request)
{
    uint laneIndex = request.selectedLane & 1u;
    VisibilityRequestLane lane = request.lanes[laneIndex];
    vec2 _318[480] = _414(lane.left.value, lane.right.value, request.accumulator.value);
    vec2 tempArg[480] = _318;
    vec2 _321[480] = _318;
    VisibilityResponse response;
    response.result.value = _321;
    response.result.completion = uvec4(laneIndex, 24u, 40u, 1u);
    response.selectedLane = laneIndex;
    response.committed = request.contractValid;
    return response;
}

VisibilityResponse finalizeVisibilityResponse(inout VisibilityResponse response)
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

void _721(uint _722, vec2 _723)
{
    D.data[_722] = _723.x;
    D.data[_722 + 1u] = _723.y;
}

void storeVisibilityResponse(inout VisibilityResponse response)
{
    if (!response.committed)
    {
        response.committed = true;
    }
    vec2 _731[480] = response.result.value;
    uint _732 = 0u;
    uint _737;
    for (;;)
    {
        _737 = _732;
        if (_737 < 960u)
        {
            _721(((uint(0) + (_737 / 40u)) * uint(40)) + (uint(0) + (_737 % 40u)), _731[_737 / 2u]);
            _732 = _737 + 2u;
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
    uint selectedLane = selectVisibilityLane();
    VisibilityLeftTile _375 = loadVisibilityLeftTile();
    VisibilityLeftTile left = _375;
    VisibilityRightTile _377 = loadVisibilityRightTile();
    VisibilityRightTile right = _377;
    VisibilityAccumulatorTile _379 = loadVisibilityAccumulatorTile();
    VisibilityAccumulatorTile accumulator = _379;
    VisibilityLeftTile param = _375;
    VisibilityRightTile param_1 = _377;
    VisibilityAccumulatorTile param_2 = _379;
    uint param_3 = selectedLane;
    VisibilityDispatchRequest _389 = buildVisibilityRequest(param, param_1, param_2, param_3);
    VisibilityDispatchRequest request = _389;
    VisibilityDispatchRequest param_4 = _389;
    VisibilityDispatchRequest _393 = normalizeVisibilityRequest(param_4);
    VisibilityDispatchRequest normalized = _393;
    VisibilityDispatchRequest param_5 = _393;
    VisibilityResponse _397 = executeVisibilityRequest(param_5);
    VisibilityResponse response = _397;
    VisibilityResponse param_6 = _397;
    VisibilityResponse _401 = finalizeVisibilityResponse(param_6);
    VisibilityResponse finalResponse = _401;
    VisibilityResponse param_7 = _401;
    storeVisibilityResponse(param_7);
}

