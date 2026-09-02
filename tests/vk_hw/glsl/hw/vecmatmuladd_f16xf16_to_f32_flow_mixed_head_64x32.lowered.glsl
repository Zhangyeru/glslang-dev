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

struct MixedHeadFeaturePacket
{
    f16vec2 value[32];
    uvec4 provenance;
};

struct MixedHeadWeightPacket
{
    f16vec2 value[1024];
    uvec4 layoutInfo;
};

struct MixedHeadBiasPacket
{
    vec2 value[16];
    uvec4 revision;
};

struct MixedHeadRouteLane
{
    uvec4 scheduling;
};

struct MixedHeadDispatchBundle
{
    MixedHeadFeaturePacket features;
    MixedHeadWeightPacket weights;
    MixedHeadBiasPacket bias;
    MixedHeadRouteLane lanes[2];
    uint selectedLane;
    bool ready;
};

struct MixedHeadOutputPacket
{
    vec2 value[16];
    uvec4 completion;
};

struct MixedHeadResponse
{
    MixedHeadOutputPacket outputValue;
    uint selectedLane;
    bool committed;
};

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t data[];
} X;

layout(set = 0, binding = 1, std430) buffer InputWeights
{
    float16_t data[];
} W;

layout(set = 0, binding = 2, std430) buffer InputBias
{
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float data[];
} Y;

uint buildMixedHeadRouteKey()
{
    uint groupKey = gl_WorkGroupID.x ^ (gl_WorkGroupID.y << 3u);
    uint invocationKey = gl_LocalInvocationIndex ^ gl_GlobalInvocationID.x;
    return groupKey ^ invocationKey;
}

uint selectMixedHeadRoute(uint routeKey)
{
    uint selected = routeKey & 1u;
    switch (selected)
    {
        case 0u:
        {
            return 0u;
        }
        case 1u:
        {
            return 1u;
        }
        default:
        {
            return 0u;
        }
    }
}

f16vec2 _775(uint _776)
{
    return f16vec2(X.data[_776], X.data[_776 + 1u]);
}

MixedHeadFeaturePacket loadMixedHeadFeatures()
{
    uint _787 = 0u;
    f16vec2 _786[32];
    uint _792;
    for (;;)
    {
        _792 = _787;
        if (_792 < 64u)
        {
            _786[_792 / 2u] = _775(0u + _792);
            _787 = _792 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _125[32] = _786;
    f16vec2 tempArg[32] = _125;
    MixedHeadFeaturePacket packet;
    packet.value = _125;
    packet.provenance = uvec4(64u, gl_GlobalInvocationID.x, 0u, 1u);
    return packet;
}

f16vec2 _800(uint _801)
{
    return f16vec2(W.data[_801], W.data[_801 + 1u]);
}

MixedHeadWeightPacket loadMixedHeadWeights()
{
    uint _812 = 0u;
    f16vec2 _811[1024];
    uint _817;
    for (;;)
    {
        _817 = _812;
        if (_817 < 2048u)
        {
            _811[_817 / 2u] = _800(((uint(0) + (_817 / 32u)) * uint(32)) + (uint(0) + (_817 % 32u)));
            _812 = _817 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _152[1024] = _811;
    f16vec2 tempArg[1024] = _152;
    f16vec2 _155[1024] = _152;
    MixedHeadWeightPacket packet;
    packet.value = _155;
    packet.layoutInfo = uvec4(64u, 32u, 0u, 1u);
    return packet;
}

vec2 _837(uint _838)
{
    return vec2(C.data[_838], C.data[_838 + 1u]);
}

MixedHeadBiasPacket loadMixedHeadBias()
{
    uint _849 = 0u;
    vec2 _848[16];
    uint _854;
    for (;;)
    {
        _854 = _849;
        if (_854 < 32u)
        {
            _848[_854 / 2u] = _837(0u + _854);
            _849 = _854 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _171[16] = _848;
    vec2 tempArg[16] = _171;
    MixedHeadBiasPacket packet;
    packet.value = _171;
    packet.revision = uvec4(32u, gl_WorkGroupID.x, 0u, 1u);
    return packet;
}

bool validateMixedHeadPackets(MixedHeadFeaturePacket features, MixedHeadWeightPacket weights, MixedHeadBiasPacket bias)
{
    bool featureReady = features.provenance.w != 0u;
    bool weightReady = weights.layoutInfo.w != 0u;
    bool biasReady = bias.revision.w != 0u;
    bool innerMatches = features.provenance.x == weights.layoutInfo.x;
    bool outputMatches = weights.layoutInfo.y == bias.revision.x;
    return (((featureReady && weightReady) && biasReady) && innerMatches) && outputMatches;
}

MixedHeadDispatchBundle buildMixedHeadBundle(MixedHeadFeaturePacket features, MixedHeadWeightPacket weights, MixedHeadBiasPacket bias, uint selectedLane)
{
    MixedHeadDispatchBundle bundle;
    bundle.features = features;
    bundle.weights = weights;
    bundle.bias = bias;
    bundle.selectedLane = selectedLane;
    MixedHeadFeaturePacket param = features;
    MixedHeadWeightPacket param_1 = weights;
    MixedHeadBiasPacket param_2 = bias;
    bundle.ready = validateMixedHeadPackets(param, param_1, param_2);
    for (uint laneIndex = 0u; laneIndex < 2u; laneIndex++)
    {
        bundle.lanes[laneIndex].scheduling = uvec4(laneIndex, selectedLane, uint(laneIndex == selectedLane), 1u);
    }
    return bundle;
}

MixedHeadDispatchBundle stabilizeMixedHeadBundle(inout MixedHeadDispatchBundle bundle)
{
    uint selectedLane = bundle.selectedLane & 1u;
    uvec4 selected = bundle.lanes[selectedLane].scheduling;
    for (uint probeIndex = 0u; probeIndex < 3u; probeIndex++)
    {
        uint candidateIndex = (selectedLane + probeIndex) & 1u;
        uvec4 candidate = bundle.lanes[candidateIndex].scheduling;
        bool candidateReady = candidate.w != 0u;
        selected = candidateReady ? candidate : selected;
    }
    if (bundle.ready)
    {
        bundle.lanes[selectedLane].scheduling = selected;
    }
    else
    {
        bundle.lanes[0].scheduling = selected;
        bundle.selectedLane = 0u;
    }
    return bundle;
}

vec2[16] _422(f16vec2 _423[32], f16vec2 _424[1024], vec2 _425[16])
{
    f16vec2 _454[32] = _423;
    f16vec2 _455[1024] = _424;
    vec2 _456[16] = _425;
    vec2 _443[16] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _444 = 0u;
    uint _457;
    for (;;)
    {
        _457 = _444;
        if (_457 < 2u)
        {
            uint _459 = _457 * 16u;
            uint _460 = _459 + 1u;
            vec2 _446 = vec2(_456[_459 / 2u][_459 % 2u], _456[_460 / 2u][_460 % 2u]);
            uint _472 = _459 + 2u;
            uint _473 = _472 + 1u;
            vec2 _447 = vec2(_456[_472 / 2u][_472 % 2u], _456[_473 / 2u][_473 % 2u]);
            uint _486 = _459 + 4u;
            uint _487 = _486 + 1u;
            vec2 _448 = vec2(_456[_486 / 2u][_486 % 2u], _456[_487 / 2u][_487 % 2u]);
            uint _500 = _459 + 6u;
            uint _501 = _500 + 1u;
            vec2 _449 = vec2(_456[_500 / 2u][_500 % 2u], _456[_501 / 2u][_501 % 2u]);
            uint _514 = _459 + 8u;
            uint _515 = _514 + 1u;
            vec2 _450 = vec2(_456[_514 / 2u][_514 % 2u], _456[_515 / 2u][_515 % 2u]);
            uint _528 = _459 + 10u;
            uint _529 = _528 + 1u;
            vec2 _451 = vec2(_456[_528 / 2u][_528 % 2u], _456[_529 / 2u][_529 % 2u]);
            uint _542 = _459 + 12u;
            uint _543 = _542 + 1u;
            vec2 _452 = vec2(_456[_542 / 2u][_542 % 2u], _456[_543 / 2u][_543 % 2u]);
            uint _556 = _459 + 14u;
            uint _557 = _556 + 1u;
            vec2 _453 = vec2(_456[_556 / 2u][_556 % 2u], _456[_557 / 2u][_557 % 2u]);
            uint _445 = 0u;
            uint _569;
            for (;;)
            {
                _569 = _445;
                if (_569 < 64u)
                {
                    vec2 _578 = vec2(f16vec2(_454[_569 / 2u][_569 % 2u]));
                    uint _581 = (_569 * 32u) + _459;
                    uint _588 = (_569 * 32u) + (_459 + 1u);
                    _446 = fma(_578, vec2(f16vec2(_455[_581 / 2u][_581 % 2u], _455[_588 / 2u][_588 % 2u])), _446);
                    uint _598 = _459 + 2u;
                    uint _601 = (_569 * 32u) + _598;
                    uint _608 = (_569 * 32u) + (_598 + 1u);
                    _447 = fma(_578, vec2(f16vec2(_455[_601 / 2u][_601 % 2u], _455[_608 / 2u][_608 % 2u])), _447);
                    uint _618 = _459 + 4u;
                    uint _621 = (_569 * 32u) + _618;
                    uint _628 = (_569 * 32u) + (_618 + 1u);
                    _448 = fma(_578, vec2(f16vec2(_455[_621 / 2u][_621 % 2u], _455[_628 / 2u][_628 % 2u])), _448);
                    uint _638 = _459 + 6u;
                    uint _641 = (_569 * 32u) + _638;
                    uint _648 = (_569 * 32u) + (_638 + 1u);
                    _449 = fma(_578, vec2(f16vec2(_455[_641 / 2u][_641 % 2u], _455[_648 / 2u][_648 % 2u])), _449);
                    uint _658 = _459 + 8u;
                    uint _661 = (_569 * 32u) + _658;
                    uint _668 = (_569 * 32u) + (_658 + 1u);
                    _450 = fma(_578, vec2(f16vec2(_455[_661 / 2u][_661 % 2u], _455[_668 / 2u][_668 % 2u])), _450);
                    uint _678 = _459 + 10u;
                    uint _681 = (_569 * 32u) + _678;
                    uint _688 = (_569 * 32u) + (_678 + 1u);
                    _451 = fma(_578, vec2(f16vec2(_455[_681 / 2u][_681 % 2u], _455[_688 / 2u][_688 % 2u])), _451);
                    uint _698 = _459 + 12u;
                    uint _701 = (_569 * 32u) + _698;
                    uint _708 = (_569 * 32u) + (_698 + 1u);
                    _452 = fma(_578, vec2(f16vec2(_455[_701 / 2u][_701 % 2u], _455[_708 / 2u][_708 % 2u])), _452);
                    uint _718 = _459 + 14u;
                    uint _721 = (_569 * 32u) + _718;
                    uint _728 = (_569 * 32u) + (_718 + 1u);
                    _453 = fma(_578, vec2(f16vec2(_455[_721 / 2u][_721 % 2u], _455[_728 / 2u][_728 % 2u])), _453);
                    _445 = _569 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _443[_457 * 8u] = _446;
            _443[(_457 * 8u) + 1u] = _447;
            _443[(_457 * 8u) + 2u] = _448;
            _443[(_457 * 8u) + 3u] = _449;
            _443[(_457 * 8u) + 4u] = _450;
            _443[(_457 * 8u) + 5u] = _451;
            _443[(_457 * 8u) + 6u] = _452;
            _443[(_457 * 8u) + 7u] = _453;
            _444 = _457 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _443;
}

MixedHeadResponse executeMixedHeadHead(MixedHeadDispatchBundle bundle)
{
    uint selectedLane = bundle.selectedLane & 1u;
    vec2 _321[16] = _422(bundle.features.value, bundle.weights.value, bundle.bias.value);
    vec2 tempArg[16] = _321;
    MixedHeadResponse response;
    response.outputValue.value = _321;
    response.outputValue.completion = uvec4(64u, 32u, selectedLane, 1u);
    response.selectedLane = selectedLane;
    response.committed = bundle.ready;
    return response;
}

MixedHeadResponse finalizeMixedHeadHead(inout MixedHeadResponse response)
{
    bool outputReady = response.outputValue.completion.w != 0u;
    response.committed = response.committed && outputReady;
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

void _863(uint _864, vec2 _865)
{
    Y.data[_864] = _865.x;
    Y.data[_864 + 1u] = _865.y;
}

void storeMixedHeadOutput(inout MixedHeadResponse response)
{
    if (!response.committed)
    {
        response.committed = true;
    }
    vec2 _873[16] = response.outputValue.value;
    uint _874 = 0u;
    uint _879;
    for (;;)
    {
        _879 = _874;
        if (_879 < 32u)
        {
            _863(0u + _879, _873[_879 / 2u]);
            _874 = _879 + 2u;
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
    uint routeKey = buildMixedHeadRouteKey();
    uint param = routeKey;
    uint selectedLane = selectMixedHeadRoute(param);
    MixedHeadFeaturePacket _382 = loadMixedHeadFeatures();
    MixedHeadFeaturePacket features = _382;
    MixedHeadWeightPacket _384 = loadMixedHeadWeights();
    MixedHeadWeightPacket weights = _384;
    MixedHeadBiasPacket _386 = loadMixedHeadBias();
    MixedHeadBiasPacket bias = _386;
    MixedHeadFeaturePacket param_1 = _382;
    MixedHeadWeightPacket param_2 = _384;
    MixedHeadBiasPacket param_3 = _386;
    uint param_4 = selectedLane;
    MixedHeadDispatchBundle _396 = buildMixedHeadBundle(param_1, param_2, param_3, param_4);
    MixedHeadDispatchBundle bundle = _396;
    MixedHeadDispatchBundle param_5 = _396;
    MixedHeadDispatchBundle _400 = stabilizeMixedHeadBundle(param_5);
    MixedHeadDispatchBundle stableBundle = _400;
    MixedHeadDispatchBundle param_6 = _400;
    MixedHeadResponse _404 = executeMixedHeadHead(param_6);
    MixedHeadResponse response = _404;
    MixedHeadResponse param_7 = _404;
    MixedHeadResponse _408 = finalizeMixedHeadHead(param_7);
    MixedHeadResponse finalResponse = _408;
    MixedHeadResponse param_8 = _408;
    storeMixedHeadOutput(param_8);
}

