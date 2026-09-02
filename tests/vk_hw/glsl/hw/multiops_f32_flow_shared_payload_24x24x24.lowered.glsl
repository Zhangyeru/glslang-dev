#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct SharedPayloadLeftMatrix
{
    vec2 value[288];
    uvec4 state;
};

struct SharedPayloadWeightMatrix
{
    vec2 value[288];
    uvec4 state;
};

struct SharedPayloadAccumulatorMatrix
{
    vec2 value[288];
    uvec4 state;
};

struct SharedPayloadMatrixLane
{
    SharedPayloadLeftMatrix left;
    SharedPayloadWeightMatrix weights;
    uvec4 scheduling;
};

struct SharedPayloadMatrixRequest
{
    SharedPayloadMatrixLane lanes[2];
    SharedPayloadAccumulatorMatrix accumulator;
    uint selectedLane;
    bool ready;
};

struct SharedPayloadMatrixResult
{
    vec2 value[288];
    uvec4 completion;
};

struct SharedPayloadVectorInput
{
    vec2 value[12];
    uvec4 state;
};

struct SharedPayloadVectorBias
{
    vec2 value[12];
    uvec4 state;
};

struct SharedPayloadVectorResult
{
    vec2 value[12];
    uvec4 completion;
};

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

uint selectSharedPayloadRoute()
{
    uint dispatchKey = gl_GlobalInvocationID.x ^ gl_LocalInvocationIndex;
    return dispatchKey & 1u;
}

vec2 _1023(uint _1024)
{
    return vec2(A.data[_1024], A.data[_1024 + 1u]);
}

SharedPayloadLeftMatrix loadSharedPayloadLeft()
{
    uint _1036 = 0u;
    vec2 _1035[288];
    uint _1041;
    for (;;)
    {
        _1041 = _1036;
        if (_1041 < 576u)
        {
            _1035[_1041 / 2u] = _1023(((uint(0) + (_1041 / 24u)) * uint(24)) + (uint(0) + (_1041 % 24u)));
            _1036 = _1041 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _119[288] = _1035;
    vec2 tempArg[288] = _119;
    SharedPayloadLeftMatrix result;
    result.value = _119;
    result.state = uvec4(24u, 24u, 0u, 1u);
    return result;
}

vec2 _1060(uint _1061)
{
    return vec2(B.data[_1061], B.data[_1061 + 1u]);
}

SharedPayloadWeightMatrix loadSharedPayloadWeights()
{
    uint _1071 = 0u;
    vec2 _1070[288];
    uint _1076;
    for (;;)
    {
        _1076 = _1071;
        if (_1076 < 576u)
        {
            _1070[_1076 / 2u] = _1060(((uint(0) + (_1076 / 24u)) * uint(24)) + (uint(0) + (_1076 % 24u)));
            _1071 = _1076 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _137[288] = _1070;
    vec2 tempArg[288] = _137;
    vec2 _140[288] = _137;
    SharedPayloadWeightMatrix result;
    result.value = _140;
    result.state = uvec4(24u, 24u, 1u, 1u);
    return result;
}

vec2 _1095(uint _1096)
{
    return vec2(C.data[_1096], C.data[_1096 + 1u]);
}

SharedPayloadAccumulatorMatrix loadSharedPayloadAccumulator()
{
    uint _1106 = 0u;
    vec2 _1105[288];
    uint _1111;
    for (;;)
    {
        _1111 = _1106;
        if (_1111 < 576u)
        {
            _1105[_1111 / 2u] = _1095(((uint(0) + (_1111 / 24u)) * uint(24)) + (uint(0) + (_1111 % 24u)));
            _1106 = _1111 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _155[288] = _1105;
    vec2 tempArg[288] = _155;
    vec2 _158[288] = _155;
    SharedPayloadAccumulatorMatrix result;
    result.value = _158;
    result.state = uvec4(24u, 24u, 2u, 1u);
    return result;
}

SharedPayloadMatrixRequest buildSharedPayloadMatrixRequest(SharedPayloadLeftMatrix left, SharedPayloadWeightMatrix weights, SharedPayloadAccumulatorMatrix accumulator, uint selectedLane)
{
    SharedPayloadMatrixRequest request;
    request.accumulator = accumulator;
    request.selectedLane = selectedLane;
    bool _176 = left.state.w != 0u;
    bool _182;
    if (_176)
    {
        _182 = weights.state.w != 0u;
    }
    else
    {
        _182 = _176;
    }
    bool _188;
    if (_182)
    {
        _188 = accumulator.state.w != 0u;
    }
    else
    {
        _188 = _182;
    }
    request.ready = _188;
    for (uint laneIndex = 0u; laneIndex < 2u; laneIndex++)
    {
        request.lanes[laneIndex].left = left;
        request.lanes[laneIndex].weights = weights;
        request.lanes[laneIndex].scheduling = uvec4(laneIndex, selectedLane, uint(laneIndex == selectedLane), 1u);
    }
    return request;
}

SharedPayloadMatrixRequest stabilizeSharedPayloadMatrixRequest(inout SharedPayloadMatrixRequest request)
{
    uint selectedLane = request.selectedLane & 1u;
    SharedPayloadMatrixLane resident = request.lanes[selectedLane];
    for (uint probe = 0u; probe < 3u; probe++)
    {
        uint candidateIndex = (selectedLane + probe) & 1u;
        SharedPayloadMatrixLane candidate = request.lanes[candidateIndex];
        bool _248 = candidate.left.state.w != 0u;
        bool _254;
        if (_248)
        {
            _254 = candidate.weights.state.w != 0u;
        }
        else
        {
            _254 = _248;
        }
        bool candidateReady = _254;
        resident = candidateReady ? candidate : resident;
    }
    switch (selectedLane)
    {
        case 0u:
        {
            request.lanes[0] = resident;
            break;
        }
        case 1u:
        {
            request.lanes[1] = resident;
            break;
        }
        default:
        {
            request.lanes[0] = resident;
            request.selectedLane = 0u;
            break;
        }
    }
    return request;
}

vec2[288] _461(vec2 _462[288], vec2 _463[288], vec2 _464[288])
{
    vec2 _488[288] = _462;
    vec2 _489[288] = _463;
    vec2 _490[288] = _464;
    vec2 _481[288] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _482 = 0u;
    uint _491;
    for (;;)
    {
        _491 = _482;
        if (_491 < 72u)
        {
            uint _493 = _491 / 3u;
            uint _495 = (_491 % 3u) * 8u;
            uint _496 = _493 * 24u;
            uint _498 = _496 + _495;
            uint _499 = _498 + 1u;
            vec2 _484 = vec2(_490[_498 / 2u][_498 % 2u], _490[_499 / 2u][_499 % 2u]);
            uint _511 = _495 + 2u;
            uint _513 = _496 + _511;
            uint _514 = _513 + 1u;
            vec2 _485 = vec2(_490[_513 / 2u][_513 % 2u], _490[_514 / 2u][_514 % 2u]);
            uint _527 = _495 + 4u;
            uint _529 = _496 + _527;
            uint _530 = _529 + 1u;
            vec2 _486 = vec2(_490[_529 / 2u][_529 % 2u], _490[_530 / 2u][_530 % 2u]);
            uint _543 = _495 + 6u;
            uint _545 = _496 + _543;
            uint _546 = _545 + 1u;
            vec2 _487 = vec2(_490[_545 / 2u][_545 % 2u], _490[_546 / 2u][_546 % 2u]);
            uint _483 = 0u;
            uint _558;
            for (;;)
            {
                _558 = _483;
                if (_558 < 24u)
                {
                    uint _561 = (_493 * 24u) + _558;
                    vec2 _567 = vec2(_488[_561 / 2u][_561 % 2u]);
                    uint _568 = _558 * 24u;
                    uint _570 = _568 + _495;
                    uint _571 = _570 + 1u;
                    _484 = fma(_567, vec2(_489[_570 / 2u][_570 % 2u], _489[_571 / 2u][_571 % 2u]), _484);
                    uint _585 = _495 + 2u;
                    uint _587 = _568 + _585;
                    uint _588 = _587 + 1u;
                    _485 = fma(_567, vec2(_489[_587 / 2u][_587 % 2u], _489[_588 / 2u][_588 % 2u]), _485);
                    uint _602 = _495 + 4u;
                    uint _604 = _568 + _602;
                    uint _605 = _604 + 1u;
                    _486 = fma(_567, vec2(_489[_604 / 2u][_604 % 2u], _489[_605 / 2u][_605 % 2u]), _486);
                    uint _619 = _495 + 6u;
                    uint _621 = _568 + _619;
                    uint _622 = _621 + 1u;
                    _487 = fma(_567, vec2(_489[_621 / 2u][_621 % 2u], _489[_622 / 2u][_622 % 2u]), _487);
                    _483 = _558 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _481[_491 * 4u] = _484;
            _481[(_491 * 4u) + 1u] = _485;
            _481[(_491 * 4u) + 2u] = _486;
            _481[(_491 * 4u) + 3u] = _487;
            _482 = _491 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _481;
}

SharedPayloadMatrixResult executeSharedPayloadFirstMatrixPass(SharedPayloadMatrixRequest request)
{
    uint laneIndex = request.selectedLane & 1u;
    SharedPayloadMatrixLane lane = request.lanes[laneIndex];
    vec2 _295[288] = _461(lane.left.value, lane.weights.value, request.accumulator.value);
    vec2 tempArg[288] = _295;
    vec2 _298[288] = _295;
    SharedPayloadMatrixResult result;
    result.value = _298;
    result.completion = uvec4(0u, laneIndex, uint(request.ready), 1u);
    return result;
}

vec2[288] _654(vec2 _655[288], vec2 _656[288], vec2 _657[288])
{
    vec2 _675[288] = _655;
    vec2 _676[288] = _656;
    vec2 _677[288] = _657;
    vec2 _668[288] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _669 = 0u;
    uint _678;
    for (;;)
    {
        _678 = _669;
        if (_678 < 72u)
        {
            uint _680 = _678 / 3u;
            uint _682 = (_678 % 3u) * 8u;
            uint _683 = _680 * 24u;
            uint _685 = _683 + _682;
            uint _686 = _685 + 1u;
            vec2 _671 = vec2(_677[_685 / 2u][_685 % 2u], _677[_686 / 2u][_686 % 2u]);
            uint _698 = _682 + 2u;
            uint _700 = _683 + _698;
            uint _701 = _700 + 1u;
            vec2 _672 = vec2(_677[_700 / 2u][_700 % 2u], _677[_701 / 2u][_701 % 2u]);
            uint _713 = _682 + 4u;
            uint _715 = _683 + _713;
            uint _716 = _715 + 1u;
            vec2 _673 = vec2(_677[_715 / 2u][_715 % 2u], _677[_716 / 2u][_716 % 2u]);
            uint _728 = _682 + 6u;
            uint _730 = _683 + _728;
            uint _731 = _730 + 1u;
            vec2 _674 = vec2(_677[_730 / 2u][_730 % 2u], _677[_731 / 2u][_731 % 2u]);
            uint _670 = 0u;
            uint _743;
            for (;;)
            {
                _743 = _670;
                if (_743 < 24u)
                {
                    uint _746 = (_680 * 24u) + _743;
                    vec2 _752 = vec2(_675[_746 / 2u][_746 % 2u]);
                    uint _753 = _743 * 24u;
                    uint _755 = _753 + _682;
                    uint _756 = _755 + 1u;
                    _671 = fma(_752, vec2(_676[_755 / 2u][_755 % 2u], _676[_756 / 2u][_756 % 2u]), _671);
                    uint _770 = _682 + 2u;
                    uint _772 = _753 + _770;
                    uint _773 = _772 + 1u;
                    _672 = fma(_752, vec2(_676[_772 / 2u][_772 % 2u], _676[_773 / 2u][_773 % 2u]), _672);
                    uint _787 = _682 + 4u;
                    uint _789 = _753 + _787;
                    uint _790 = _789 + 1u;
                    _673 = fma(_752, vec2(_676[_789 / 2u][_789 % 2u], _676[_790 / 2u][_790 % 2u]), _673);
                    uint _804 = _682 + 6u;
                    uint _806 = _753 + _804;
                    uint _807 = _806 + 1u;
                    _674 = fma(_752, vec2(_676[_806 / 2u][_806 % 2u], _676[_807 / 2u][_807 % 2u]), _674);
                    _670 = _743 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _668[_678 * 4u] = _671;
            _668[(_678 * 4u) + 1u] = _672;
            _668[(_678 * 4u) + 2u] = _673;
            _668[(_678 * 4u) + 3u] = _674;
            _669 = _678 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _668;
}

SharedPayloadMatrixResult executeSharedPayloadSecondMatrixPass(SharedPayloadMatrixRequest request, SharedPayloadMatrixResult firstPass)
{
    uint laneIndex = request.selectedLane & 1u;
    SharedPayloadMatrixLane lane = request.lanes[laneIndex];
    vec2 _324[288] = firstPass.value;
    vec2 _325[288] = _654(lane.left.value, lane.weights.value, _324);
    vec2 tempArg[288] = _325;
    vec2 _328[288] = _325;
    SharedPayloadMatrixResult result;
    result.value = _328;
    result.completion = uvec4(1u, laneIndex, firstPass.completion.w, 1u);
    return result;
}

void _1131(uint _1132, vec2 _1133)
{
    D.data[_1132] = _1133.x;
    D.data[_1132 + 1u] = _1133.y;
}

void storeSharedPayloadMatrixResult(SharedPayloadMatrixResult result)
{
    vec2 _1141[288] = result.value;
    uint _1142 = 0u;
    uint _1147;
    for (;;)
    {
        _1147 = _1142;
        if (_1147 < 576u)
        {
            _1131(((uint(0) + (_1147 / 24u)) * uint(24)) + (uint(0) + (_1147 % 24u)), _1141[_1147 / 2u]);
            _1142 = _1147 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

vec2 _1166(uint _1167)
{
    return vec2(A.data[_1167], A.data[_1167 + 1u]);
}

SharedPayloadVectorInput loadSharedPayloadVectorInput()
{
    uint _1177 = 0u;
    vec2 _1176[12];
    uint _1182;
    for (;;)
    {
        _1182 = _1177;
        if (_1182 < 24u)
        {
            _1176[_1182 / 2u] = _1166(0u + _1182);
            _1177 = _1182 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _349[12] = _1176;
    vec2 tempArg[12] = _349;
    SharedPayloadVectorInput inputValue;
    inputValue.value = _349;
    inputValue.state = uvec4(24u, 0u, 0u, 1u);
    return inputValue;
}

vec2 _1190(uint _1191)
{
    float _1195 = D.data[_1191];
    float _1198 = D.data[_1191 + 1u];
    return vec2(_1195, _1198);
}

SharedPayloadVectorBias loadSharedPayloadVectorBias(uint passIndex)
{
    uint _1201 = 0u;
    vec2 _1200[12];
    uint _1206;
    for (;;)
    {
        _1206 = _1201;
        if (_1206 < 24u)
        {
            _1200[_1206 / 2u] = _1190(0u + _1206);
            _1201 = _1206 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _360[12] = _1200;
    vec2 tempArg[12] = _360;
    SharedPayloadVectorBias bias;
    bias.value = _360;
    bias.state = uvec4(24u, passIndex, 0u, 1u);
    return bias;
}

vec2[12] _840(vec2 _841[12], vec2 _842[288], vec2 _843[12])
{
    vec2 _864[12] = _841;
    vec2 _865[288] = _842;
    vec2 _866[12] = _843;
    vec2 _857[12] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _858 = 0u;
    uint _867;
    for (;;)
    {
        _867 = _858;
        if (_867 < 3u)
        {
            uint _869 = _867 * 8u;
            uint _870 = _869 + 1u;
            vec2 _860 = vec2(_866[_869 / 2u][_869 % 2u], _866[_870 / 2u][_870 % 2u]);
            uint _882 = _869 + 2u;
            uint _883 = _882 + 1u;
            vec2 _861 = vec2(_866[_882 / 2u][_882 % 2u], _866[_883 / 2u][_883 % 2u]);
            uint _895 = _869 + 4u;
            uint _896 = _895 + 1u;
            vec2 _862 = vec2(_866[_895 / 2u][_895 % 2u], _866[_896 / 2u][_896 % 2u]);
            uint _908 = _869 + 6u;
            uint _909 = _908 + 1u;
            vec2 _863 = vec2(_866[_908 / 2u][_908 % 2u], _866[_909 / 2u][_909 % 2u]);
            uint _859 = 0u;
            uint _921;
            for (;;)
            {
                _921 = _859;
                if (_921 < 24u)
                {
                    vec2 _928 = vec2(_864[_921 / 2u][_921 % 2u]);
                    uint _931 = (_921 * 24u) + _869;
                    uint _938 = (_921 * 24u) + (_869 + 1u);
                    _860 = fma(_928, vec2(_865[_931 / 2u][_931 % 2u], _865[_938 / 2u][_938 % 2u]), _860);
                    uint _947 = _869 + 2u;
                    uint _950 = (_921 * 24u) + _947;
                    uint _957 = (_921 * 24u) + (_947 + 1u);
                    _861 = fma(_928, vec2(_865[_950 / 2u][_950 % 2u], _865[_957 / 2u][_957 % 2u]), _861);
                    uint _966 = _869 + 4u;
                    uint _969 = (_921 * 24u) + _966;
                    uint _976 = (_921 * 24u) + (_966 + 1u);
                    _862 = fma(_928, vec2(_865[_969 / 2u][_969 % 2u], _865[_976 / 2u][_976 % 2u]), _862);
                    uint _985 = _869 + 6u;
                    uint _988 = (_921 * 24u) + _985;
                    uint _995 = (_921 * 24u) + (_985 + 1u);
                    _863 = fma(_928, vec2(_865[_988 / 2u][_988 % 2u], _865[_995 / 2u][_995 % 2u]), _863);
                    _859 = _921 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _857[_867 * 4u] = _860;
            _857[(_867 * 4u) + 1u] = _861;
            _857[(_867 * 4u) + 2u] = _862;
            _857[(_867 * 4u) + 3u] = _863;
            _858 = _867 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _857;
}

SharedPayloadVectorResult executeSharedPayloadVectorPass(SharedPayloadVectorInput inputValue, SharedPayloadWeightMatrix weights, SharedPayloadVectorBias bias, uint passIndex)
{
    vec2 _377[12] = _840(inputValue.value, weights.value, bias.value);
    vec2 tempArg[12] = _377;
    SharedPayloadVectorResult result;
    result.value = _377;
    result.completion = uvec4(passIndex, 24u, 24u, 1u);
    return result;
}

void _1214(uint _1215, vec2 _1216)
{
    D.data[_1215] = _1216.x;
    D.data[_1215 + 1u] = _1216.y;
}

void storeSharedPayloadVectorResult(SharedPayloadVectorResult result)
{
    vec2 _1224[12] = result.value;
    uint _1225 = 0u;
    uint _1230;
    for (;;)
    {
        _1230 = _1225;
        if (_1230 < 24u)
        {
            _1214(0u + _1230, _1224[_1230 / 2u]);
            _1225 = _1230 + 2u;
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
    uint selectedLane = selectSharedPayloadRoute();
    SharedPayloadLeftMatrix _393 = loadSharedPayloadLeft();
    SharedPayloadLeftMatrix left = _393;
    SharedPayloadWeightMatrix weights = loadSharedPayloadWeights();
    SharedPayloadAccumulatorMatrix _397 = loadSharedPayloadAccumulator();
    SharedPayloadAccumulatorMatrix accumulator = _397;
    SharedPayloadLeftMatrix param = _393;
    SharedPayloadWeightMatrix param_1 = weights;
    SharedPayloadAccumulatorMatrix param_2 = _397;
    uint param_3 = selectedLane;
    SharedPayloadMatrixRequest _407 = buildSharedPayloadMatrixRequest(param, param_1, param_2, param_3);
    SharedPayloadMatrixRequest request = _407;
    SharedPayloadMatrixRequest param_4 = _407;
    SharedPayloadMatrixRequest _411 = stabilizeSharedPayloadMatrixRequest(param_4);
    SharedPayloadMatrixRequest stableRequest = _411;
    SharedPayloadMatrixRequest param_5 = _411;
    SharedPayloadMatrixResult _415 = executeSharedPayloadFirstMatrixPass(param_5);
    SharedPayloadMatrixResult firstPass = _415;
    SharedPayloadMatrixRequest param_6 = _411;
    SharedPayloadMatrixResult param_7 = _415;
    SharedPayloadMatrixResult _421 = executeSharedPayloadSecondMatrixPass(param_6, param_7);
    SharedPayloadMatrixResult secondPass = _421;
    SharedPayloadMatrixResult param_8 = _421;
    storeSharedPayloadMatrixResult(param_8);
    SharedPayloadVectorInput vectorInput = loadSharedPayloadVectorInput();
    for (uint passIndex = 0u; passIndex < 2u; passIndex++)
    {
        uint param_9 = passIndex;
        SharedPayloadVectorBias _438 = loadSharedPayloadVectorBias(param_9);
        SharedPayloadVectorBias bias = _438;
        SharedPayloadVectorInput param_10 = vectorInput;
        SharedPayloadWeightMatrix param_11 = weights;
        SharedPayloadVectorBias param_12 = _438;
        uint param_13 = passIndex;
        SharedPayloadVectorResult _448 = executeSharedPayloadVectorPass(param_10, param_11, param_12, param_13);
        SharedPayloadVectorResult vectorResult = _448;
        SharedPayloadVectorResult param_14 = _448;
        storeSharedPayloadVectorResult(param_14);
    }
}

