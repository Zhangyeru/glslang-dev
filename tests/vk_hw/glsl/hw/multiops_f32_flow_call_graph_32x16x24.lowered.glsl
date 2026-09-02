#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct CallGraphLeftMatrix
{
    vec2 value[384];
    uvec4 state;
};

struct CallGraphWeightMatrix
{
    vec2 value[192];
    uvec4 state;
};

struct CallGraphAccumulatorMatrix
{
    vec2 value[256];
    uvec4 state;
};

struct CallGraphMatrixLane
{
    CallGraphLeftMatrix left;
    CallGraphWeightMatrix weights;
    uvec4 scheduling;
};

struct CallGraphMatrixRequest
{
    CallGraphMatrixLane lanes[2];
    CallGraphAccumulatorMatrix accumulator;
    uint selectedLane;
    bool ready;
};

struct CallGraphMatrixResult
{
    vec2 value[256];
    uvec4 completion;
};

struct CallGraphVectorInput
{
    vec2 value[12];
    uvec4 state;
};

struct CallGraphVectorBias
{
    vec2 value[8];
    uvec4 state;
};

struct CallGraphVectorResult
{
    vec2 value[8];
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

uint selectCallGraphRoute()
{
    uint dispatchKey = gl_GlobalInvocationID.x ^ gl_LocalInvocationIndex;
    return dispatchKey & 1u;
}

vec2 _1490(uint _1491)
{
    return vec2(A.data[_1491], A.data[_1491 + 1u]);
}

CallGraphLeftMatrix loadCallGraphLeft()
{
    uint _1503 = 0u;
    vec2 _1502[384];
    uint _1508;
    for (;;)
    {
        _1508 = _1503;
        if (_1508 < 768u)
        {
            _1502[_1508 / 2u] = _1490(((uint(0) + (_1508 / 24u)) * uint(24)) + (uint(0) + (_1508 % 24u)));
            _1503 = _1508 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _124[384] = _1502;
    vec2 tempArg[384] = _124;
    CallGraphLeftMatrix result;
    result.value = _124;
    result.state = uvec4(32u, 24u, 0u, 1u);
    return result;
}

vec2 _1527(uint _1528)
{
    return vec2(B.data[_1528], B.data[_1528 + 1u]);
}

CallGraphWeightMatrix loadCallGraphWeights()
{
    uint _1538 = 0u;
    vec2 _1537[192];
    uint _1543;
    for (;;)
    {
        _1543 = _1538;
        if (_1543 < 384u)
        {
            _1537[_1543 / 2u] = _1527(((uint(0) + (_1543 / 16u)) * uint(16)) + (uint(0) + (_1543 % 16u)));
            _1538 = _1543 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _146[192] = _1537;
    vec2 tempArg[192] = _146;
    vec2 _149[192] = _146;
    CallGraphWeightMatrix result;
    result.value = _149;
    result.state = uvec4(24u, 16u, 1u, 1u);
    return result;
}

vec2 _1562(uint _1563)
{
    return vec2(C.data[_1563], C.data[_1563 + 1u]);
}

CallGraphAccumulatorMatrix loadCallGraphAccumulator()
{
    uint _1574 = 0u;
    vec2 _1573[256];
    uint _1579;
    for (;;)
    {
        _1579 = _1574;
        if (_1579 < 512u)
        {
            _1573[_1579 / 2u] = _1562(((uint(0) + (_1579 / 16u)) * uint(16)) + (uint(0) + (_1579 % 16u)));
            _1574 = _1579 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _166[256] = _1573;
    vec2 tempArg[256] = _166;
    vec2 _169[256] = _166;
    CallGraphAccumulatorMatrix result;
    result.value = _169;
    result.state = uvec4(32u, 16u, 2u, 1u);
    return result;
}

CallGraphMatrixRequest buildCallGraphMatrixRequest(CallGraphLeftMatrix left, CallGraphWeightMatrix weights, CallGraphAccumulatorMatrix accumulator, uint selectedLane)
{
    CallGraphMatrixRequest request;
    request.accumulator = accumulator;
    request.selectedLane = selectedLane;
    bool _187 = left.state.w != 0u;
    bool _193;
    if (_187)
    {
        _193 = weights.state.w != 0u;
    }
    else
    {
        _193 = _187;
    }
    bool _199;
    if (_193)
    {
        _199 = accumulator.state.w != 0u;
    }
    else
    {
        _199 = _193;
    }
    request.ready = _199;
    for (uint laneIndex = 0u; laneIndex < 2u; laneIndex++)
    {
        request.lanes[laneIndex].left = left;
        request.lanes[laneIndex].weights = weights;
        request.lanes[laneIndex].scheduling = uvec4(laneIndex, selectedLane, uint(laneIndex == selectedLane), 1u);
    }
    return request;
}

CallGraphMatrixRequest stabilizeCallGraphMatrixRequest(inout CallGraphMatrixRequest request)
{
    uint selectedLane = request.selectedLane & 1u;
    CallGraphMatrixLane resident = request.lanes[selectedLane];
    for (uint probe = 0u; probe < 3u; probe++)
    {
        uint candidateIndex = (selectedLane + probe) & 1u;
        CallGraphMatrixLane candidate = request.lanes[candidateIndex];
        bool _259 = candidate.left.state.w != 0u;
        bool _265;
        if (_259)
        {
            _265 = candidate.weights.state.w != 0u;
        }
        else
        {
            _265 = _259;
        }
        bool candidateReady = _265;
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

vec2[256] _479(vec2 _480[384], vec2 _481[192], vec2 _482[256])
{
    vec2 _510[384] = _480;
    vec2 _511[192] = _481;
    vec2 _512[256] = _482;
    vec2 _499[256] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _500 = 0u;
    uint _513;
    for (;;)
    {
        _513 = _500;
        if (_513 < 32u)
        {
            uint _515 = _513 / 1u;
            uint _517 = (_513 % 1u) * 16u;
            uint _518 = _515 * 16u;
            uint _520 = _518 + _517;
            uint _521 = _520 + 1u;
            vec2 _502 = vec2(_512[_520 / 2u][_520 % 2u], _512[_521 / 2u][_521 % 2u]);
            uint _533 = _517 + 2u;
            uint _535 = _518 + _533;
            uint _536 = _535 + 1u;
            vec2 _503 = vec2(_512[_535 / 2u][_535 % 2u], _512[_536 / 2u][_536 % 2u]);
            uint _549 = _517 + 4u;
            uint _551 = _518 + _549;
            uint _552 = _551 + 1u;
            vec2 _504 = vec2(_512[_551 / 2u][_551 % 2u], _512[_552 / 2u][_552 % 2u]);
            uint _565 = _517 + 6u;
            uint _567 = _518 + _565;
            uint _568 = _567 + 1u;
            vec2 _505 = vec2(_512[_567 / 2u][_567 % 2u], _512[_568 / 2u][_568 % 2u]);
            uint _580 = _517 + 8u;
            uint _582 = _518 + _580;
            uint _583 = _582 + 1u;
            vec2 _506 = vec2(_512[_582 / 2u][_582 % 2u], _512[_583 / 2u][_583 % 2u]);
            uint _596 = _517 + 10u;
            uint _598 = _518 + _596;
            uint _599 = _598 + 1u;
            vec2 _507 = vec2(_512[_598 / 2u][_598 % 2u], _512[_599 / 2u][_599 % 2u]);
            uint _611 = _517 + 12u;
            uint _613 = _518 + _611;
            uint _614 = _613 + 1u;
            vec2 _508 = vec2(_512[_613 / 2u][_613 % 2u], _512[_614 / 2u][_614 % 2u]);
            uint _627 = _517 + 14u;
            uint _629 = _518 + _627;
            uint _630 = _629 + 1u;
            vec2 _509 = vec2(_512[_629 / 2u][_629 % 2u], _512[_630 / 2u][_630 % 2u]);
            uint _501 = 0u;
            uint _642;
            for (;;)
            {
                _642 = _501;
                if (_642 < 24u)
                {
                    uint _645 = (_515 * 24u) + _642;
                    vec2 _651 = vec2(_510[_645 / 2u][_645 % 2u]);
                    uint _652 = _642 * 16u;
                    uint _654 = _652 + _517;
                    uint _655 = _654 + 1u;
                    _502 = fma(_651, vec2(_511[_654 / 2u][_654 % 2u], _511[_655 / 2u][_655 % 2u]), _502);
                    uint _669 = _517 + 2u;
                    uint _671 = _652 + _669;
                    uint _672 = _671 + 1u;
                    _503 = fma(_651, vec2(_511[_671 / 2u][_671 % 2u], _511[_672 / 2u][_672 % 2u]), _503);
                    uint _686 = _517 + 4u;
                    uint _688 = _652 + _686;
                    uint _689 = _688 + 1u;
                    _504 = fma(_651, vec2(_511[_688 / 2u][_688 % 2u], _511[_689 / 2u][_689 % 2u]), _504);
                    uint _703 = _517 + 6u;
                    uint _705 = _652 + _703;
                    uint _706 = _705 + 1u;
                    _505 = fma(_651, vec2(_511[_705 / 2u][_705 % 2u], _511[_706 / 2u][_706 % 2u]), _505);
                    uint _720 = _517 + 8u;
                    uint _722 = _652 + _720;
                    uint _723 = _722 + 1u;
                    _506 = fma(_651, vec2(_511[_722 / 2u][_722 % 2u], _511[_723 / 2u][_723 % 2u]), _506);
                    uint _737 = _517 + 10u;
                    uint _739 = _652 + _737;
                    uint _740 = _739 + 1u;
                    _507 = fma(_651, vec2(_511[_739 / 2u][_739 % 2u], _511[_740 / 2u][_740 % 2u]), _507);
                    uint _754 = _517 + 12u;
                    uint _756 = _652 + _754;
                    uint _757 = _756 + 1u;
                    _508 = fma(_651, vec2(_511[_756 / 2u][_756 % 2u], _511[_757 / 2u][_757 % 2u]), _508);
                    uint _771 = _517 + 14u;
                    uint _773 = _652 + _771;
                    uint _774 = _773 + 1u;
                    _509 = fma(_651, vec2(_511[_773 / 2u][_773 % 2u], _511[_774 / 2u][_774 % 2u]), _509);
                    _501 = _642 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _499[_513 * 8u] = _502;
            _499[(_513 * 8u) + 1u] = _503;
            _499[(_513 * 8u) + 2u] = _504;
            _499[(_513 * 8u) + 3u] = _505;
            _499[(_513 * 8u) + 4u] = _506;
            _499[(_513 * 8u) + 5u] = _507;
            _499[(_513 * 8u) + 6u] = _508;
            _499[(_513 * 8u) + 7u] = _509;
            _500 = _513 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _499;
}

CallGraphMatrixResult executeCallGraphFirstMatrixPass(CallGraphMatrixRequest request)
{
    uint laneIndex = request.selectedLane & 1u;
    CallGraphMatrixLane lane = request.lanes[laneIndex];
    vec2 _306[256] = _479(lane.left.value, lane.weights.value, request.accumulator.value);
    vec2 tempArg[256] = _306;
    vec2 _309[256] = _306;
    CallGraphMatrixResult result;
    result.value = _309;
    result.completion = uvec4(0u, laneIndex, uint(request.ready), 1u);
    return result;
}

vec2[256] _824(vec2 _825[384], vec2 _826[192], vec2 _827[256])
{
    vec2 _849[384] = _825;
    vec2 _850[192] = _826;
    vec2 _851[256] = _827;
    vec2 _838[256] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _839 = 0u;
    uint _852;
    for (;;)
    {
        _852 = _839;
        if (_852 < 32u)
        {
            uint _854 = _852 / 1u;
            uint _856 = (_852 % 1u) * 16u;
            uint _857 = _854 * 16u;
            uint _859 = _857 + _856;
            uint _860 = _859 + 1u;
            vec2 _841 = vec2(_851[_859 / 2u][_859 % 2u], _851[_860 / 2u][_860 % 2u]);
            uint _872 = _856 + 2u;
            uint _874 = _857 + _872;
            uint _875 = _874 + 1u;
            vec2 _842 = vec2(_851[_874 / 2u][_874 % 2u], _851[_875 / 2u][_875 % 2u]);
            uint _887 = _856 + 4u;
            uint _889 = _857 + _887;
            uint _890 = _889 + 1u;
            vec2 _843 = vec2(_851[_889 / 2u][_889 % 2u], _851[_890 / 2u][_890 % 2u]);
            uint _902 = _856 + 6u;
            uint _904 = _857 + _902;
            uint _905 = _904 + 1u;
            vec2 _844 = vec2(_851[_904 / 2u][_904 % 2u], _851[_905 / 2u][_905 % 2u]);
            uint _917 = _856 + 8u;
            uint _919 = _857 + _917;
            uint _920 = _919 + 1u;
            vec2 _845 = vec2(_851[_919 / 2u][_919 % 2u], _851[_920 / 2u][_920 % 2u]);
            uint _932 = _856 + 10u;
            uint _934 = _857 + _932;
            uint _935 = _934 + 1u;
            vec2 _846 = vec2(_851[_934 / 2u][_934 % 2u], _851[_935 / 2u][_935 % 2u]);
            uint _947 = _856 + 12u;
            uint _949 = _857 + _947;
            uint _950 = _949 + 1u;
            vec2 _847 = vec2(_851[_949 / 2u][_949 % 2u], _851[_950 / 2u][_950 % 2u]);
            uint _962 = _856 + 14u;
            uint _964 = _857 + _962;
            uint _965 = _964 + 1u;
            vec2 _848 = vec2(_851[_964 / 2u][_964 % 2u], _851[_965 / 2u][_965 % 2u]);
            uint _840 = 0u;
            uint _977;
            for (;;)
            {
                _977 = _840;
                if (_977 < 24u)
                {
                    uint _980 = (_854 * 24u) + _977;
                    vec2 _986 = vec2(_849[_980 / 2u][_980 % 2u]);
                    uint _987 = _977 * 16u;
                    uint _989 = _987 + _856;
                    uint _990 = _989 + 1u;
                    _841 = fma(_986, vec2(_850[_989 / 2u][_989 % 2u], _850[_990 / 2u][_990 % 2u]), _841);
                    uint _1004 = _856 + 2u;
                    uint _1006 = _987 + _1004;
                    uint _1007 = _1006 + 1u;
                    _842 = fma(_986, vec2(_850[_1006 / 2u][_1006 % 2u], _850[_1007 / 2u][_1007 % 2u]), _842);
                    uint _1021 = _856 + 4u;
                    uint _1023 = _987 + _1021;
                    uint _1024 = _1023 + 1u;
                    _843 = fma(_986, vec2(_850[_1023 / 2u][_1023 % 2u], _850[_1024 / 2u][_1024 % 2u]), _843);
                    uint _1038 = _856 + 6u;
                    uint _1040 = _987 + _1038;
                    uint _1041 = _1040 + 1u;
                    _844 = fma(_986, vec2(_850[_1040 / 2u][_1040 % 2u], _850[_1041 / 2u][_1041 % 2u]), _844);
                    uint _1055 = _856 + 8u;
                    uint _1057 = _987 + _1055;
                    uint _1058 = _1057 + 1u;
                    _845 = fma(_986, vec2(_850[_1057 / 2u][_1057 % 2u], _850[_1058 / 2u][_1058 % 2u]), _845);
                    uint _1072 = _856 + 10u;
                    uint _1074 = _987 + _1072;
                    uint _1075 = _1074 + 1u;
                    _846 = fma(_986, vec2(_850[_1074 / 2u][_1074 % 2u], _850[_1075 / 2u][_1075 % 2u]), _846);
                    uint _1089 = _856 + 12u;
                    uint _1091 = _987 + _1089;
                    uint _1092 = _1091 + 1u;
                    _847 = fma(_986, vec2(_850[_1091 / 2u][_1091 % 2u], _850[_1092 / 2u][_1092 % 2u]), _847);
                    uint _1106 = _856 + 14u;
                    uint _1108 = _987 + _1106;
                    uint _1109 = _1108 + 1u;
                    _848 = fma(_986, vec2(_850[_1108 / 2u][_1108 % 2u], _850[_1109 / 2u][_1109 % 2u]), _848);
                    _840 = _977 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _838[_852 * 8u] = _841;
            _838[(_852 * 8u) + 1u] = _842;
            _838[(_852 * 8u) + 2u] = _843;
            _838[(_852 * 8u) + 3u] = _844;
            _838[(_852 * 8u) + 4u] = _845;
            _838[(_852 * 8u) + 5u] = _846;
            _838[(_852 * 8u) + 6u] = _847;
            _838[(_852 * 8u) + 7u] = _848;
            _839 = _852 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _838;
}

CallGraphMatrixResult executeCallGraphSecondMatrixPass(CallGraphMatrixRequest request, CallGraphMatrixResult firstPass)
{
    uint laneIndex = request.selectedLane & 1u;
    CallGraphMatrixLane lane = request.lanes[laneIndex];
    vec2 _335[256] = firstPass.value;
    vec2 _336[256] = _824(lane.left.value, lane.weights.value, _335);
    vec2 tempArg[256] = _336;
    vec2 _339[256] = _336;
    CallGraphMatrixResult result;
    result.value = _339;
    result.completion = uvec4(1u, laneIndex, firstPass.completion.w, 1u);
    return result;
}

void _1599(uint _1600, vec2 _1601)
{
    D.data[_1600] = _1601.x;
    D.data[_1600 + 1u] = _1601.y;
}

void storeCallGraphMatrixResult(CallGraphMatrixResult result)
{
    vec2 _1609[256] = result.value;
    uint _1610 = 0u;
    uint _1615;
    for (;;)
    {
        _1615 = _1610;
        if (_1615 < 512u)
        {
            _1599(((uint(0) + (_1615 / 16u)) * uint(16)) + (uint(0) + (_1615 % 16u)), _1609[_1615 / 2u]);
            _1610 = _1615 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

vec2 _1634(uint _1635)
{
    return vec2(A.data[_1635], A.data[_1635 + 1u]);
}

CallGraphVectorInput loadCallGraphVectorInput()
{
    uint _1645 = 0u;
    vec2 _1644[12];
    uint _1650;
    for (;;)
    {
        _1650 = _1645;
        if (_1650 < 24u)
        {
            _1644[_1650 / 2u] = _1634(0u + _1650);
            _1645 = _1650 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _360[12] = _1644;
    vec2 tempArg[12] = _360;
    CallGraphVectorInput inputValue;
    inputValue.value = _360;
    inputValue.state = uvec4(24u, 0u, 0u, 1u);
    return inputValue;
}

vec2 _1658(uint _1659)
{
    float _1663 = D.data[_1659];
    float _1666 = D.data[_1659 + 1u];
    return vec2(_1663, _1666);
}

CallGraphVectorBias loadCallGraphVectorBias(uint passIndex)
{
    uint _1669 = 0u;
    vec2 _1668[8];
    uint _1674;
    for (;;)
    {
        _1674 = _1669;
        if (_1674 < 16u)
        {
            _1668[_1674 / 2u] = _1658(0u + _1674);
            _1669 = _1674 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _372[8] = _1668;
    vec2 tempArg[8] = _372;
    CallGraphVectorBias bias;
    bias.value = _372;
    bias.state = uvec4(16u, passIndex, 0u, 1u);
    return bias;
}

vec2[8] _1158(vec2 _1159[12], vec2 _1160[192], vec2 _1161[8])
{
    vec2 _1187[12] = _1159;
    vec2 _1188[192] = _1160;
    vec2 _1189[8] = _1161;
    vec2 _1176[8] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _1177 = 0u;
    uint _1190;
    for (;;)
    {
        _1190 = _1177;
        if (_1190 < 1u)
        {
            uint _1192 = _1190 * 16u;
            uint _1193 = _1192 + 1u;
            vec2 _1179 = vec2(_1189[_1192 / 2u][_1192 % 2u], _1189[_1193 / 2u][_1193 % 2u]);
            uint _1205 = _1192 + 2u;
            uint _1206 = _1205 + 1u;
            vec2 _1180 = vec2(_1189[_1205 / 2u][_1205 % 2u], _1189[_1206 / 2u][_1206 % 2u]);
            uint _1218 = _1192 + 4u;
            uint _1219 = _1218 + 1u;
            vec2 _1181 = vec2(_1189[_1218 / 2u][_1218 % 2u], _1189[_1219 / 2u][_1219 % 2u]);
            uint _1231 = _1192 + 6u;
            uint _1232 = _1231 + 1u;
            vec2 _1182 = vec2(_1189[_1231 / 2u][_1231 % 2u], _1189[_1232 / 2u][_1232 % 2u]);
            uint _1244 = _1192 + 8u;
            uint _1245 = _1244 + 1u;
            vec2 _1183 = vec2(_1189[_1244 / 2u][_1244 % 2u], _1189[_1245 / 2u][_1245 % 2u]);
            uint _1257 = _1192 + 10u;
            uint _1258 = _1257 + 1u;
            vec2 _1184 = vec2(_1189[_1257 / 2u][_1257 % 2u], _1189[_1258 / 2u][_1258 % 2u]);
            uint _1270 = _1192 + 12u;
            uint _1271 = _1270 + 1u;
            vec2 _1185 = vec2(_1189[_1270 / 2u][_1270 % 2u], _1189[_1271 / 2u][_1271 % 2u]);
            uint _1283 = _1192 + 14u;
            uint _1284 = _1283 + 1u;
            vec2 _1186 = vec2(_1189[_1283 / 2u][_1283 % 2u], _1189[_1284 / 2u][_1284 % 2u]);
            uint _1178 = 0u;
            uint _1296;
            for (;;)
            {
                _1296 = _1178;
                if (_1296 < 24u)
                {
                    vec2 _1303 = vec2(_1187[_1296 / 2u][_1296 % 2u]);
                    uint _1306 = (_1296 * 16u) + _1192;
                    uint _1313 = (_1296 * 16u) + (_1192 + 1u);
                    _1179 = fma(_1303, vec2(_1188[_1306 / 2u][_1306 % 2u], _1188[_1313 / 2u][_1313 % 2u]), _1179);
                    uint _1322 = _1192 + 2u;
                    uint _1325 = (_1296 * 16u) + _1322;
                    uint _1332 = (_1296 * 16u) + (_1322 + 1u);
                    _1180 = fma(_1303, vec2(_1188[_1325 / 2u][_1325 % 2u], _1188[_1332 / 2u][_1332 % 2u]), _1180);
                    uint _1341 = _1192 + 4u;
                    uint _1344 = (_1296 * 16u) + _1341;
                    uint _1351 = (_1296 * 16u) + (_1341 + 1u);
                    _1181 = fma(_1303, vec2(_1188[_1344 / 2u][_1344 % 2u], _1188[_1351 / 2u][_1351 % 2u]), _1181);
                    uint _1360 = _1192 + 6u;
                    uint _1363 = (_1296 * 16u) + _1360;
                    uint _1370 = (_1296 * 16u) + (_1360 + 1u);
                    _1182 = fma(_1303, vec2(_1188[_1363 / 2u][_1363 % 2u], _1188[_1370 / 2u][_1370 % 2u]), _1182);
                    uint _1379 = _1192 + 8u;
                    uint _1382 = (_1296 * 16u) + _1379;
                    uint _1389 = (_1296 * 16u) + (_1379 + 1u);
                    _1183 = fma(_1303, vec2(_1188[_1382 / 2u][_1382 % 2u], _1188[_1389 / 2u][_1389 % 2u]), _1183);
                    uint _1398 = _1192 + 10u;
                    uint _1401 = (_1296 * 16u) + _1398;
                    uint _1408 = (_1296 * 16u) + (_1398 + 1u);
                    _1184 = fma(_1303, vec2(_1188[_1401 / 2u][_1401 % 2u], _1188[_1408 / 2u][_1408 % 2u]), _1184);
                    uint _1417 = _1192 + 12u;
                    uint _1420 = (_1296 * 16u) + _1417;
                    uint _1427 = (_1296 * 16u) + (_1417 + 1u);
                    _1185 = fma(_1303, vec2(_1188[_1420 / 2u][_1420 % 2u], _1188[_1427 / 2u][_1427 % 2u]), _1185);
                    uint _1436 = _1192 + 14u;
                    uint _1439 = (_1296 * 16u) + _1436;
                    uint _1446 = (_1296 * 16u) + (_1436 + 1u);
                    _1186 = fma(_1303, vec2(_1188[_1439 / 2u][_1439 % 2u], _1188[_1446 / 2u][_1446 % 2u]), _1186);
                    _1178 = _1296 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _1176[_1190 * 8u] = _1179;
            _1176[(_1190 * 8u) + 1u] = _1180;
            _1176[(_1190 * 8u) + 2u] = _1181;
            _1176[(_1190 * 8u) + 3u] = _1182;
            _1176[(_1190 * 8u) + 4u] = _1183;
            _1176[(_1190 * 8u) + 5u] = _1184;
            _1176[(_1190 * 8u) + 6u] = _1185;
            _1176[(_1190 * 8u) + 7u] = _1186;
            _1177 = _1190 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _1176;
}

CallGraphVectorResult executeCallGraphVectorPass(CallGraphVectorInput inputValue, CallGraphWeightMatrix weights, CallGraphVectorBias bias, uint passIndex)
{
    vec2 _389[8] = _1158(inputValue.value, weights.value, bias.value);
    vec2 tempArg[8] = _389;
    CallGraphVectorResult result;
    result.value = _389;
    result.completion = uvec4(passIndex, 24u, 16u, 1u);
    return result;
}

void _1682(uint _1683, vec2 _1684)
{
    D.data[_1683] = _1684.x;
    D.data[_1683 + 1u] = _1684.y;
}

void storeCallGraphVectorResult(CallGraphVectorResult result)
{
    vec2 _1692[8] = result.value;
    uint _1693 = 0u;
    uint _1698;
    for (;;)
    {
        _1698 = _1693;
        if (_1698 < 16u)
        {
            _1682(0u + _1698, _1692[_1698 / 2u]);
            _1693 = _1698 + 2u;
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
    uint selectedLane = selectCallGraphRoute();
    CallGraphLeftMatrix _405 = loadCallGraphLeft();
    CallGraphLeftMatrix left = _405;
    CallGraphWeightMatrix weights = loadCallGraphWeights();
    CallGraphAccumulatorMatrix _409 = loadCallGraphAccumulator();
    CallGraphAccumulatorMatrix accumulator = _409;
    CallGraphLeftMatrix param = _405;
    CallGraphWeightMatrix param_1 = weights;
    CallGraphAccumulatorMatrix param_2 = _409;
    uint param_3 = selectedLane;
    CallGraphMatrixRequest _419 = buildCallGraphMatrixRequest(param, param_1, param_2, param_3);
    CallGraphMatrixRequest request = _419;
    CallGraphMatrixRequest param_4 = _419;
    CallGraphMatrixRequest _423 = stabilizeCallGraphMatrixRequest(param_4);
    CallGraphMatrixRequest stableRequest = _423;
    CallGraphMatrixRequest param_5 = _423;
    CallGraphMatrixResult _427 = executeCallGraphFirstMatrixPass(param_5);
    CallGraphMatrixResult firstPass = _427;
    CallGraphMatrixRequest param_6 = _423;
    CallGraphMatrixResult param_7 = _427;
    CallGraphMatrixResult _433 = executeCallGraphSecondMatrixPass(param_6, param_7);
    CallGraphMatrixResult secondPass = _433;
    CallGraphMatrixResult param_8 = _433;
    storeCallGraphMatrixResult(param_8);
    CallGraphVectorInput vectorInput = loadCallGraphVectorInput();
    for (uint passIndex = 0u; passIndex < 2u; passIndex++)
    {
        uint param_9 = passIndex;
        CallGraphVectorBias _450 = loadCallGraphVectorBias(param_9);
        CallGraphVectorBias bias = _450;
        CallGraphVectorInput param_10 = vectorInput;
        CallGraphWeightMatrix param_11 = weights;
        CallGraphVectorBias param_12 = _450;
        uint param_13 = passIndex;
        CallGraphVectorResult _460 = executeCallGraphVectorPass(param_10, param_11, param_12, param_13);
        CallGraphVectorResult vectorResult = _460;
        CallGraphVectorResult param_14 = _460;
        storeCallGraphVectorResult(param_14);
    }
}

