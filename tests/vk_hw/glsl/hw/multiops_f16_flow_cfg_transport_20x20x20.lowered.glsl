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

struct CfgTransportLeftMatrix
{
    f16vec2 value[200];
    uvec4 state;
};

struct CfgTransportWeightMatrix
{
    f16vec2 value[200];
    uvec4 state;
};

struct CfgTransportAccumulatorMatrix
{
    f16vec2 value[200];
    uvec4 state;
};

struct CfgTransportMatrixLane
{
    CfgTransportLeftMatrix left;
    CfgTransportWeightMatrix weights;
    uvec4 scheduling;
};

struct CfgTransportMatrixRequest
{
    CfgTransportMatrixLane lanes[2];
    CfgTransportAccumulatorMatrix accumulator;
    uint selectedLane;
    bool ready;
};

struct CfgTransportMatrixResult
{
    f16vec2 value[200];
    uvec4 completion;
};

struct CfgTransportVectorInput
{
    f16vec2 value[10];
    uvec4 state;
};

struct CfgTransportVectorBias
{
    f16vec2 value[10];
    uvec4 state;
};

struct CfgTransportVectorResult
{
    f16vec2 value[10];
    uvec4 completion;
};

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
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

uint selectCfgTransportRoute()
{
    uint dispatchKey = gl_GlobalInvocationID.x ^ gl_LocalInvocationIndex;
    return dispatchKey & 1u;
}

f16vec2 _2010(uint _2011)
{
    return f16vec2(A.data[_2011], A.data[_2011 + 1u]);
}

CfgTransportLeftMatrix loadCfgTransportLeft()
{
    uint _2023 = 0u;
    f16vec2 _2022[200];
    uint _2028;
    for (;;)
    {
        _2028 = _2023;
        if (_2028 < 400u)
        {
            _2022[_2028 / 2u] = _2010(((uint(0) + (_2028 / 20u)) * uint(20)) + (uint(0) + (_2028 % 20u)));
            _2023 = _2028 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _119[200] = _2022;
    f16vec2 tempArg[200] = _119;
    CfgTransportLeftMatrix result;
    result.value = _119;
    result.state = uvec4(20u, 20u, 0u, 1u);
    return result;
}

f16vec2 _2047(uint _2048)
{
    return f16vec2(B.data[_2048], B.data[_2048 + 1u]);
}

CfgTransportWeightMatrix loadCfgTransportWeights()
{
    uint _2058 = 0u;
    f16vec2 _2057[200];
    uint _2063;
    for (;;)
    {
        _2063 = _2058;
        if (_2063 < 400u)
        {
            _2057[_2063 / 2u] = _2047(((uint(0) + (_2063 / 20u)) * uint(20)) + (uint(0) + (_2063 % 20u)));
            _2058 = _2063 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _137[200] = _2057;
    f16vec2 tempArg[200] = _137;
    f16vec2 _140[200] = _137;
    CfgTransportWeightMatrix result;
    result.value = _140;
    result.state = uvec4(20u, 20u, 1u, 1u);
    return result;
}

f16vec2 _2082(uint _2083)
{
    return f16vec2(C.data[_2083], C.data[_2083 + 1u]);
}

CfgTransportAccumulatorMatrix loadCfgTransportAccumulator()
{
    uint _2093 = 0u;
    f16vec2 _2092[200];
    uint _2098;
    for (;;)
    {
        _2098 = _2093;
        if (_2098 < 400u)
        {
            _2092[_2098 / 2u] = _2082(((uint(0) + (_2098 / 20u)) * uint(20)) + (uint(0) + (_2098 % 20u)));
            _2093 = _2098 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _155[200] = _2092;
    f16vec2 tempArg[200] = _155;
    f16vec2 _158[200] = _155;
    CfgTransportAccumulatorMatrix result;
    result.value = _158;
    result.state = uvec4(20u, 20u, 2u, 1u);
    return result;
}

CfgTransportMatrixRequest buildCfgTransportMatrixRequest(CfgTransportLeftMatrix left, CfgTransportWeightMatrix weights, CfgTransportAccumulatorMatrix accumulator, uint selectedLane)
{
    CfgTransportMatrixRequest request;
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

CfgTransportMatrixRequest stabilizeCfgTransportMatrixRequest(inout CfgTransportMatrixRequest request)
{
    uint selectedLane = request.selectedLane & 1u;
    CfgTransportMatrixLane resident = request.lanes[selectedLane];
    for (uint probe = 0u; probe < 3u; probe++)
    {
        uint candidateIndex = (selectedLane + probe) & 1u;
        CfgTransportMatrixLane candidate = request.lanes[candidateIndex];
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

f16vec2[200] _461(f16vec2 _462[200], f16vec2 _463[200], f16vec2 _464[200])
{
    f16vec2 _487[200] = _462;
    f16vec2 _488[200] = _463;
    f16vec2 _489[200] = _464;
    f16vec2 _482[200] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
    uint _483 = 0u;
    uint _490;
    for (;;)
    {
        _490 = _483;
        if (_490 < 100u)
        {
            uint _492 = _490 / 5u;
            uint _494 = (_490 % 5u) * 4u;
            uint _495 = _492 * 20u;
            uint _497 = _495 + _494;
            uint _498 = _497 + 1u;
            f16vec2 _485 = f16vec2(_489[_497 / 2u][_497 % 2u], _489[_498 / 2u][_498 % 2u]);
            uint _510 = _494 + 2u;
            uint _512 = _495 + _510;
            uint _513 = _512 + 1u;
            f16vec2 _486 = f16vec2(_489[_512 / 2u][_512 % 2u], _489[_513 / 2u][_513 % 2u]);
            uint _484 = 0u;
            uint _525;
            for (;;)
            {
                _525 = _484;
                if (_525 < 20u)
                {
                    uint _528 = (_492 * 20u) + _525;
                    f16vec2 _534 = f16vec2(_487[_528 / 2u][_528 % 2u]);
                    uint _535 = _525 * 20u;
                    uint _537 = _535 + _494;
                    uint _538 = _537 + 1u;
                    _485 = fma(_534, f16vec2(_488[_537 / 2u][_537 % 2u], _488[_538 / 2u][_538 % 2u]), _485);
                    uint _552 = _494 + 2u;
                    uint _554 = _535 + _552;
                    uint _555 = _554 + 1u;
                    _486 = fma(_534, f16vec2(_488[_554 / 2u][_554 % 2u], _488[_555 / 2u][_555 % 2u]), _486);
                    _484 = _525 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _482[_490 * 2u] = _485;
            _482[(_490 * 2u) + 1u] = _486;
            _483 = _490 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _482;
}

CfgTransportMatrixResult executeCfgTransportFirstMatrixPass(CfgTransportMatrixRequest request)
{
    uint laneIndex = request.selectedLane & 1u;
    CfgTransportMatrixLane lane = request.lanes[laneIndex];
    f16vec2 _295[200] = _461(lane.left.value, lane.weights.value, request.accumulator.value);
    f16vec2 tempArg[200] = _295;
    f16vec2 _298[200] = _295;
    CfgTransportMatrixResult result;
    result.value = _298;
    result.completion = uvec4(0u, laneIndex, uint(request.ready), 1u);
    return result;
}

f16vec2[200] _579(f16vec2 _580[200], f16vec2 _581[200], f16vec2 _582[200])
{
    f16vec2 _598[200] = _580;
    f16vec2 _599[200] = _581;
    f16vec2 _600[200] = _582;
    f16vec2 _593[200] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
    uint _594 = 0u;
    uint _601;
    for (;;)
    {
        _601 = _594;
        if (_601 < 100u)
        {
            uint _603 = _601 / 5u;
            uint _605 = (_601 % 5u) * 4u;
            uint _606 = _603 * 20u;
            uint _608 = _606 + _605;
            uint _609 = _608 + 1u;
            f16vec2 _596 = f16vec2(_600[_608 / 2u][_608 % 2u], _600[_609 / 2u][_609 % 2u]);
            uint _621 = _605 + 2u;
            uint _623 = _606 + _621;
            uint _624 = _623 + 1u;
            f16vec2 _597 = f16vec2(_600[_623 / 2u][_623 % 2u], _600[_624 / 2u][_624 % 2u]);
            uint _595 = 0u;
            uint _636;
            for (;;)
            {
                _636 = _595;
                if (_636 < 20u)
                {
                    uint _639 = (_603 * 20u) + _636;
                    f16vec2 _645 = f16vec2(_598[_639 / 2u][_639 % 2u]);
                    uint _646 = _636 * 20u;
                    uint _648 = _646 + _605;
                    uint _649 = _648 + 1u;
                    _596 = fma(_645, f16vec2(_599[_648 / 2u][_648 % 2u], _599[_649 / 2u][_649 % 2u]), _596);
                    uint _663 = _605 + 2u;
                    uint _665 = _646 + _663;
                    uint _666 = _665 + 1u;
                    _597 = fma(_645, f16vec2(_599[_665 / 2u][_665 % 2u], _599[_666 / 2u][_666 % 2u]), _597);
                    _595 = _636 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _593[_601 * 2u] = _596;
            _593[(_601 * 2u) + 1u] = _597;
            _594 = _601 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _593;
}

CfgTransportMatrixResult executeCfgTransportSecondMatrixPass(CfgTransportMatrixRequest request, CfgTransportMatrixResult firstPass)
{
    uint laneIndex = request.selectedLane & 1u;
    CfgTransportMatrixLane lane = request.lanes[laneIndex];
    f16vec2 _324[200] = firstPass.value;
    f16vec2 _325[200] = _579(lane.left.value, lane.weights.value, _324);
    f16vec2 tempArg[200] = _325;
    f16vec2 _328[200] = _325;
    CfgTransportMatrixResult result;
    result.value = _328;
    result.completion = uvec4(1u, laneIndex, firstPass.completion.w, 1u);
    return result;
}

void _2118(uint _2119, f16vec2 _2120)
{
    D.data[_2119] = _2120.x;
    D.data[_2119 + 1u] = _2120.y;
}

void storeCfgTransportMatrixResult(CfgTransportMatrixResult result)
{
    f16vec2 _2128[200] = result.value;
    uint _2129 = 0u;
    uint _2134;
    for (;;)
    {
        _2134 = _2129;
        if (_2134 < 400u)
        {
            _2118(((uint(0) + (_2134 / 20u)) * uint(20)) + (uint(0) + (_2134 % 20u)), _2128[_2134 / 2u]);
            _2129 = _2134 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

f16vec2 _2153(uint _2154)
{
    return f16vec2(A.data[_2154], A.data[_2154 + 1u]);
}

CfgTransportVectorInput loadCfgTransportVectorInput()
{
    uint _2165 = 0u;
    f16vec2 _2164[10];
    uint _2170;
    for (;;)
    {
        _2170 = _2165;
        if (_2170 < 20u)
        {
            _2164[_2170 / 2u] = _2153(0u + _2170);
            _2165 = _2170 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _349[10] = _2164;
    f16vec2 tempArg[10] = _349;
    CfgTransportVectorInput inputValue;
    inputValue.value = _349;
    inputValue.state = uvec4(20u, 0u, 0u, 1u);
    return inputValue;
}

f16vec2 _2178(uint _2179)
{
    float16_t _2183 = D.data[_2179];
    float16_t _2186 = D.data[_2179 + 1u];
    return f16vec2(_2183, _2186);
}

CfgTransportVectorBias loadCfgTransportVectorBias(uint passIndex)
{
    uint _2189 = 0u;
    f16vec2 _2188[10];
    uint _2194;
    for (;;)
    {
        _2194 = _2189;
        if (_2194 < 20u)
        {
            _2188[_2194 / 2u] = _2178(0u + _2194);
            _2189 = _2194 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _360[10] = _2188;
    f16vec2 tempArg[10] = _360;
    CfgTransportVectorBias bias;
    bias.value = _360;
    bias.state = uvec4(20u, passIndex, 0u, 1u);
    return bias;
}

f16vec2[10] _691(f16vec2 _692[10], f16vec2 _693[200], f16vec2 _694[10])
{
    f16vec2 _1588 = f16vec2(_692[0].x);
    f16vec2 _1609 = f16vec2(_692[0].y);
    f16vec2 _1630 = f16vec2(_692[1].x);
    f16vec2 _1651 = f16vec2(_692[1].y);
    f16vec2 _1672 = f16vec2(_692[2].x);
    f16vec2 _1693 = f16vec2(_692[2].y);
    f16vec2 _1714 = f16vec2(_692[3].x);
    f16vec2 _1735 = f16vec2(_692[3].y);
    f16vec2 _1756 = f16vec2(_692[4].x);
    f16vec2 _1777 = f16vec2(_692[4].y);
    f16vec2 _1779 = fma(_1777, f16vec2(_693[90].x, _693[90].y), fma(_1756, f16vec2(_693[80].x, _693[80].y), fma(_1735, f16vec2(_693[70].x, _693[70].y), fma(_1714, f16vec2(_693[60].x, _693[60].y), fma(_1693, f16vec2(_693[50].x, _693[50].y), fma(_1672, f16vec2(_693[40].x, _693[40].y), fma(_1651, f16vec2(_693[30].x, _693[30].y), fma(_1630, f16vec2(_693[20].x, _693[20].y), fma(_1609, f16vec2(_693[10].x, _693[10].y), fma(_1588, f16vec2(_693[0].x, _693[0].y), f16vec2(_694[0].x, _694[0].y)))))))))));
    f16vec2 _1781 = fma(_1777, f16vec2(_693[91].x, _693[91].y), fma(_1756, f16vec2(_693[81].x, _693[81].y), fma(_1735, f16vec2(_693[71].x, _693[71].y), fma(_1714, f16vec2(_693[61].x, _693[61].y), fma(_1693, f16vec2(_693[51].x, _693[51].y), fma(_1672, f16vec2(_693[41].x, _693[41].y), fma(_1651, f16vec2(_693[31].x, _693[31].y), fma(_1630, f16vec2(_693[21].x, _693[21].y), fma(_1609, f16vec2(_693[11].x, _693[11].y), fma(_1588, f16vec2(_693[1].x, _693[1].y), f16vec2(_694[1].x, _694[1].y)))))))))));
    f16vec2 _1783 = fma(_1777, f16vec2(_693[92].x, _693[92].y), fma(_1756, f16vec2(_693[82].x, _693[82].y), fma(_1735, f16vec2(_693[72].x, _693[72].y), fma(_1714, f16vec2(_693[62].x, _693[62].y), fma(_1693, f16vec2(_693[52].x, _693[52].y), fma(_1672, f16vec2(_693[42].x, _693[42].y), fma(_1651, f16vec2(_693[32].x, _693[32].y), fma(_1630, f16vec2(_693[22].x, _693[22].y), fma(_1609, f16vec2(_693[12].x, _693[12].y), fma(_1588, f16vec2(_693[2].x, _693[2].y), f16vec2(_694[2].x, _694[2].y)))))))))));
    f16vec2 _1785 = fma(_1777, f16vec2(_693[93].x, _693[93].y), fma(_1756, f16vec2(_693[83].x, _693[83].y), fma(_1735, f16vec2(_693[73].x, _693[73].y), fma(_1714, f16vec2(_693[63].x, _693[63].y), fma(_1693, f16vec2(_693[53].x, _693[53].y), fma(_1672, f16vec2(_693[43].x, _693[43].y), fma(_1651, f16vec2(_693[33].x, _693[33].y), fma(_1630, f16vec2(_693[23].x, _693[23].y), fma(_1609, f16vec2(_693[13].x, _693[13].y), fma(_1588, f16vec2(_693[3].x, _693[3].y), f16vec2(_694[3].x, _694[3].y)))))))))));
    f16vec2 _1787 = fma(_1777, f16vec2(_693[94].x, _693[94].y), fma(_1756, f16vec2(_693[84].x, _693[84].y), fma(_1735, f16vec2(_693[74].x, _693[74].y), fma(_1714, f16vec2(_693[64].x, _693[64].y), fma(_1693, f16vec2(_693[54].x, _693[54].y), fma(_1672, f16vec2(_693[44].x, _693[44].y), fma(_1651, f16vec2(_693[34].x, _693[34].y), fma(_1630, f16vec2(_693[24].x, _693[24].y), fma(_1609, f16vec2(_693[14].x, _693[14].y), fma(_1588, f16vec2(_693[4].x, _693[4].y), f16vec2(_694[4].x, _694[4].y)))))))))));
    f16vec2 _1789 = fma(_1777, f16vec2(_693[95].x, _693[95].y), fma(_1756, f16vec2(_693[85].x, _693[85].y), fma(_1735, f16vec2(_693[75].x, _693[75].y), fma(_1714, f16vec2(_693[65].x, _693[65].y), fma(_1693, f16vec2(_693[55].x, _693[55].y), fma(_1672, f16vec2(_693[45].x, _693[45].y), fma(_1651, f16vec2(_693[35].x, _693[35].y), fma(_1630, f16vec2(_693[25].x, _693[25].y), fma(_1609, f16vec2(_693[15].x, _693[15].y), fma(_1588, f16vec2(_693[5].x, _693[5].y), f16vec2(_694[5].x, _694[5].y)))))))))));
    f16vec2 _1791 = fma(_1777, f16vec2(_693[96].x, _693[96].y), fma(_1756, f16vec2(_693[86].x, _693[86].y), fma(_1735, f16vec2(_693[76].x, _693[76].y), fma(_1714, f16vec2(_693[66].x, _693[66].y), fma(_1693, f16vec2(_693[56].x, _693[56].y), fma(_1672, f16vec2(_693[46].x, _693[46].y), fma(_1651, f16vec2(_693[36].x, _693[36].y), fma(_1630, f16vec2(_693[26].x, _693[26].y), fma(_1609, f16vec2(_693[16].x, _693[16].y), fma(_1588, f16vec2(_693[6].x, _693[6].y), f16vec2(_694[6].x, _694[6].y)))))))))));
    f16vec2 _1793 = fma(_1777, f16vec2(_693[97].x, _693[97].y), fma(_1756, f16vec2(_693[87].x, _693[87].y), fma(_1735, f16vec2(_693[77].x, _693[77].y), fma(_1714, f16vec2(_693[67].x, _693[67].y), fma(_1693, f16vec2(_693[57].x, _693[57].y), fma(_1672, f16vec2(_693[47].x, _693[47].y), fma(_1651, f16vec2(_693[37].x, _693[37].y), fma(_1630, f16vec2(_693[27].x, _693[27].y), fma(_1609, f16vec2(_693[17].x, _693[17].y), fma(_1588, f16vec2(_693[7].x, _693[7].y), f16vec2(_694[7].x, _694[7].y)))))))))));
    f16vec2 _1795 = fma(_1777, f16vec2(_693[98].x, _693[98].y), fma(_1756, f16vec2(_693[88].x, _693[88].y), fma(_1735, f16vec2(_693[78].x, _693[78].y), fma(_1714, f16vec2(_693[68].x, _693[68].y), fma(_1693, f16vec2(_693[58].x, _693[58].y), fma(_1672, f16vec2(_693[48].x, _693[48].y), fma(_1651, f16vec2(_693[38].x, _693[38].y), fma(_1630, f16vec2(_693[28].x, _693[28].y), fma(_1609, f16vec2(_693[18].x, _693[18].y), fma(_1588, f16vec2(_693[8].x, _693[8].y), f16vec2(_694[8].x, _694[8].y)))))))))));
    f16vec2 _1797 = fma(_1777, f16vec2(_693[99].x, _693[99].y), fma(_1756, f16vec2(_693[89].x, _693[89].y), fma(_1735, f16vec2(_693[79].x, _693[79].y), fma(_1714, f16vec2(_693[69].x, _693[69].y), fma(_1693, f16vec2(_693[59].x, _693[59].y), fma(_1672, f16vec2(_693[49].x, _693[49].y), fma(_1651, f16vec2(_693[39].x, _693[39].y), fma(_1630, f16vec2(_693[29].x, _693[29].y), fma(_1609, f16vec2(_693[19].x, _693[19].y), fma(_1588, f16vec2(_693[9].x, _693[9].y), f16vec2(_694[9].x, _694[9].y)))))))))));
    f16vec2 _1798 = f16vec2(_692[5].x);
    f16vec2 _1819 = f16vec2(_692[5].y);
    f16vec2 _1840 = f16vec2(_692[6].x);
    f16vec2 _1861 = f16vec2(_692[6].y);
    f16vec2 _1882 = f16vec2(_692[7].x);
    f16vec2 _1903 = f16vec2(_692[7].y);
    f16vec2 _1924 = f16vec2(_692[8].x);
    f16vec2 _1945 = f16vec2(_692[8].y);
    f16vec2 _1966 = f16vec2(_692[9].x);
    f16vec2 _1987 = f16vec2(_692[9].y);
    f16vec2 _2008[10] = f16vec2[](fma(_1987, f16vec2(_693[190].x, _693[190].y), fma(_1966, f16vec2(_693[180].x, _693[180].y), fma(_1945, f16vec2(_693[170].x, _693[170].y), fma(_1924, f16vec2(_693[160].x, _693[160].y), fma(_1903, f16vec2(_693[150].x, _693[150].y), fma(_1882, f16vec2(_693[140].x, _693[140].y), fma(_1861, f16vec2(_693[130].x, _693[130].y), fma(_1840, f16vec2(_693[120].x, _693[120].y), fma(_1819, f16vec2(_693[110].x, _693[110].y), fma(_1798, f16vec2(_693[100].x, _693[100].y), _1779)))))))))), fma(_1987, f16vec2(_693[191].x, _693[191].y), fma(_1966, f16vec2(_693[181].x, _693[181].y), fma(_1945, f16vec2(_693[171].x, _693[171].y), fma(_1924, f16vec2(_693[161].x, _693[161].y), fma(_1903, f16vec2(_693[151].x, _693[151].y), fma(_1882, f16vec2(_693[141].x, _693[141].y), fma(_1861, f16vec2(_693[131].x, _693[131].y), fma(_1840, f16vec2(_693[121].x, _693[121].y), fma(_1819, f16vec2(_693[111].x, _693[111].y), fma(_1798, f16vec2(_693[101].x, _693[101].y), _1781)))))))))), fma(_1987, f16vec2(_693[192].x, _693[192].y), fma(_1966, f16vec2(_693[182].x, _693[182].y), fma(_1945, f16vec2(_693[172].x, _693[172].y), fma(_1924, f16vec2(_693[162].x, _693[162].y), fma(_1903, f16vec2(_693[152].x, _693[152].y), fma(_1882, f16vec2(_693[142].x, _693[142].y), fma(_1861, f16vec2(_693[132].x, _693[132].y), fma(_1840, f16vec2(_693[122].x, _693[122].y), fma(_1819, f16vec2(_693[112].x, _693[112].y), fma(_1798, f16vec2(_693[102].x, _693[102].y), _1783)))))))))), fma(_1987, f16vec2(_693[193].x, _693[193].y), fma(_1966, f16vec2(_693[183].x, _693[183].y), fma(_1945, f16vec2(_693[173].x, _693[173].y), fma(_1924, f16vec2(_693[163].x, _693[163].y), fma(_1903, f16vec2(_693[153].x, _693[153].y), fma(_1882, f16vec2(_693[143].x, _693[143].y), fma(_1861, f16vec2(_693[133].x, _693[133].y), fma(_1840, f16vec2(_693[123].x, _693[123].y), fma(_1819, f16vec2(_693[113].x, _693[113].y), fma(_1798, f16vec2(_693[103].x, _693[103].y), _1785)))))))))), fma(_1987, f16vec2(_693[194].x, _693[194].y), fma(_1966, f16vec2(_693[184].x, _693[184].y), fma(_1945, f16vec2(_693[174].x, _693[174].y), fma(_1924, f16vec2(_693[164].x, _693[164].y), fma(_1903, f16vec2(_693[154].x, _693[154].y), fma(_1882, f16vec2(_693[144].x, _693[144].y), fma(_1861, f16vec2(_693[134].x, _693[134].y), fma(_1840, f16vec2(_693[124].x, _693[124].y), fma(_1819, f16vec2(_693[114].x, _693[114].y), fma(_1798, f16vec2(_693[104].x, _693[104].y), _1787)))))))))), fma(_1987, f16vec2(_693[195].x, _693[195].y), fma(_1966, f16vec2(_693[185].x, _693[185].y), fma(_1945, f16vec2(_693[175].x, _693[175].y), fma(_1924, f16vec2(_693[165].x, _693[165].y), fma(_1903, f16vec2(_693[155].x, _693[155].y), fma(_1882, f16vec2(_693[145].x, _693[145].y), fma(_1861, f16vec2(_693[135].x, _693[135].y), fma(_1840, f16vec2(_693[125].x, _693[125].y), fma(_1819, f16vec2(_693[115].x, _693[115].y), fma(_1798, f16vec2(_693[105].x, _693[105].y), _1789)))))))))), fma(_1987, f16vec2(_693[196].x, _693[196].y), fma(_1966, f16vec2(_693[186].x, _693[186].y), fma(_1945, f16vec2(_693[176].x, _693[176].y), fma(_1924, f16vec2(_693[166].x, _693[166].y), fma(_1903, f16vec2(_693[156].x, _693[156].y), fma(_1882, f16vec2(_693[146].x, _693[146].y), fma(_1861, f16vec2(_693[136].x, _693[136].y), fma(_1840, f16vec2(_693[126].x, _693[126].y), fma(_1819, f16vec2(_693[116].x, _693[116].y), fma(_1798, f16vec2(_693[106].x, _693[106].y), _1791)))))))))), fma(_1987, f16vec2(_693[197].x, _693[197].y), fma(_1966, f16vec2(_693[187].x, _693[187].y), fma(_1945, f16vec2(_693[177].x, _693[177].y), fma(_1924, f16vec2(_693[167].x, _693[167].y), fma(_1903, f16vec2(_693[157].x, _693[157].y), fma(_1882, f16vec2(_693[147].x, _693[147].y), fma(_1861, f16vec2(_693[137].x, _693[137].y), fma(_1840, f16vec2(_693[127].x, _693[127].y), fma(_1819, f16vec2(_693[117].x, _693[117].y), fma(_1798, f16vec2(_693[107].x, _693[107].y), _1793)))))))))), fma(_1987, f16vec2(_693[198].x, _693[198].y), fma(_1966, f16vec2(_693[188].x, _693[188].y), fma(_1945, f16vec2(_693[178].x, _693[178].y), fma(_1924, f16vec2(_693[168].x, _693[168].y), fma(_1903, f16vec2(_693[158].x, _693[158].y), fma(_1882, f16vec2(_693[148].x, _693[148].y), fma(_1861, f16vec2(_693[138].x, _693[138].y), fma(_1840, f16vec2(_693[128].x, _693[128].y), fma(_1819, f16vec2(_693[118].x, _693[118].y), fma(_1798, f16vec2(_693[108].x, _693[108].y), _1795)))))))))), fma(_1987, f16vec2(_693[199].x, _693[199].y), fma(_1966, f16vec2(_693[189].x, _693[189].y), fma(_1945, f16vec2(_693[179].x, _693[179].y), fma(_1924, f16vec2(_693[169].x, _693[169].y), fma(_1903, f16vec2(_693[159].x, _693[159].y), fma(_1882, f16vec2(_693[149].x, _693[149].y), fma(_1861, f16vec2(_693[139].x, _693[139].y), fma(_1840, f16vec2(_693[129].x, _693[129].y), fma(_1819, f16vec2(_693[119].x, _693[119].y), fma(_1798, f16vec2(_693[109].x, _693[109].y), _1797)))))))))));
    return _2008;
}

CfgTransportVectorResult executeCfgTransportVectorPass(CfgTransportVectorInput inputValue, CfgTransportWeightMatrix weights, CfgTransportVectorBias bias, uint passIndex)
{
    f16vec2 _377[10] = _691(inputValue.value, weights.value, bias.value);
    f16vec2 tempArg[10] = _377;
    CfgTransportVectorResult result;
    result.value = _377;
    result.completion = uvec4(passIndex, 20u, 20u, 1u);
    return result;
}

void _2202(uint _2203, f16vec2 _2204)
{
    D.data[_2203] = _2204.x;
    D.data[_2203 + 1u] = _2204.y;
}

void storeCfgTransportVectorResult(CfgTransportVectorResult result)
{
    f16vec2 _2212[10] = result.value;
    uint _2213 = 0u;
    uint _2218;
    for (;;)
    {
        _2218 = _2213;
        if (_2218 < 20u)
        {
            _2202(0u + _2218, _2212[_2218 / 2u]);
            _2213 = _2218 + 2u;
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
    uint selectedLane = selectCfgTransportRoute();
    CfgTransportLeftMatrix _393 = loadCfgTransportLeft();
    CfgTransportLeftMatrix left = _393;
    CfgTransportWeightMatrix weights = loadCfgTransportWeights();
    CfgTransportAccumulatorMatrix _397 = loadCfgTransportAccumulator();
    CfgTransportAccumulatorMatrix accumulator = _397;
    CfgTransportLeftMatrix param = _393;
    CfgTransportWeightMatrix param_1 = weights;
    CfgTransportAccumulatorMatrix param_2 = _397;
    uint param_3 = selectedLane;
    CfgTransportMatrixRequest _407 = buildCfgTransportMatrixRequest(param, param_1, param_2, param_3);
    CfgTransportMatrixRequest request = _407;
    CfgTransportMatrixRequest param_4 = _407;
    CfgTransportMatrixRequest _411 = stabilizeCfgTransportMatrixRequest(param_4);
    CfgTransportMatrixRequest stableRequest = _411;
    CfgTransportMatrixRequest param_5 = _411;
    CfgTransportMatrixResult _415 = executeCfgTransportFirstMatrixPass(param_5);
    CfgTransportMatrixResult firstPass = _415;
    CfgTransportMatrixRequest param_6 = _411;
    CfgTransportMatrixResult param_7 = _415;
    CfgTransportMatrixResult _421 = executeCfgTransportSecondMatrixPass(param_6, param_7);
    CfgTransportMatrixResult secondPass = _421;
    CfgTransportMatrixResult param_8 = _421;
    storeCfgTransportMatrixResult(param_8);
    CfgTransportVectorInput vectorInput = loadCfgTransportVectorInput();
    for (uint passIndex = 0u; passIndex < 2u; passIndex++)
    {
        uint param_9 = passIndex;
        CfgTransportVectorBias _438 = loadCfgTransportVectorBias(param_9);
        CfgTransportVectorBias bias = _438;
        CfgTransportVectorInput param_10 = vectorInput;
        CfgTransportWeightMatrix param_11 = weights;
        CfgTransportVectorBias param_12 = _438;
        uint param_13 = passIndex;
        CfgTransportVectorResult _448 = executeCfgTransportVectorPass(param_10, param_11, param_12, param_13);
        CfgTransportVectorResult vectorResult = _448;
        CfgTransportVectorResult param_14 = _448;
        storeCfgTransportVectorResult(param_14);
    }
}

