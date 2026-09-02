#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct AssetRequest
{
    uint setIndex;
    uint versionIndex;
    uint planeIndex;
    uint epoch;
};

struct AssetMatrix
{
    vec2 value[384];
};

struct AssetVersion
{
    uvec4 planeState[2];
    uvec4 revision;
};

struct AssetCacheSet
{
    AssetVersion versions[2];
};

struct AssetCache
{
    AssetCacheSet sets[2];
    AssetMatrix resident;
};

layout(set = 0, binding = 1, std430) buffer InputB
{
    float data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float data[];
} C;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

uint buildRoutingKey()
{
    uint materialKey = floatBitsToUint(B.data[0]);
    uint frameKey = floatBitsToUint(C.data[0]);
    uint invocationKey = gl_GlobalInvocationID.x ^ gl_LocalInvocationIndex;
    return (materialKey ^ (frameKey << 1u)) ^ invocationKey;
}

AssetRequest decodeRequest(uint routingKey)
{
    AssetRequest request;
    request.setIndex = routingKey & 1u;
    request.versionIndex = (routingKey >> 1u) & 1u;
    request.planeIndex = (routingKey >> 2u) & 1u;
    request.epoch = routingKey >> 3u;
    return request;
}

vec2 _365(uint _366)
{
    return vec2(A.data[_366], A.data[_366 + 1u]);
}

AssetMatrix loadSourceAsset()
{
    uint _379 = 0u;
    vec2 _378[384];
    uint _384;
    for (;;)
    {
        _384 = _379;
        if (_384 < 768u)
        {
            _378[_384 / 2u] = _365(((uint(0) + (_384 / 32u)) * uint(32)) + (uint(0) + (_384 % 32u)));
            _379 = _384 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _138[384] = _378;
    vec2 tempArg[384] = _138;
    vec2 source[384] = _138;
    AssetMatrix result;
    result.value = _138;
    return result;
}

AssetCache populateCache(AssetMatrix source, AssetRequest request)
{
    AssetCache cache;
    cache.resident = source;
    for (int setIndex = 0; setIndex < 2; setIndex++)
    {
        for (int versionIndex = 0; versionIndex < 2; versionIndex++)
        {
            cache.sets[setIndex].versions[versionIndex].revision = uvec4(request.epoch, uint(setIndex), uint(versionIndex), 1u);
            for (int planeIndex = 0; planeIndex < 2; planeIndex++)
            {
                cache.sets[setIndex].versions[versionIndex].planeState[planeIndex] = uvec4(uint(planeIndex), request.epoch, 0u, 1u);
            }
        }
    }
    return cache;
}

AssetCache advanceCacheEpoch(inout AssetCache cache, AssetRequest request)
{
    uint selectedSet = request.setIndex;
    uint selectedVersion = request.versionIndex;
    uint selectedPlane = request.planeIndex;
    AssetMatrix resident = cache.resident;
    for (uint epochStep = 0u; epochStep < 3u; epochStep++)
    {
        bool keepResident = ((request.epoch + epochStep) & 1u) == 0u;
        AssetMatrix staged = cache.resident;
        resident = keepResident ? resident : cache.resident;
    }
    cache.resident = resident;
    cache.sets[selectedSet].versions[selectedVersion].revision.x += 3u;
    return cache;
}

AssetMatrix selectCachePlane(AssetCache cache, AssetRequest request)
{
    uint route = (request.setIndex << 1u) | request.versionIndex;
    AssetMatrix selected;
    switch (route)
    {
        case 0u:
        {
            selected = cache.resident;
            break;
        }
        case 1u:
        {
            selected = cache.resident;
            break;
        }
        case 2u:
        {
            selected = cache.resident;
            break;
        }
        default:
        {
            selected = cache.resident;
            break;
        }
    }
    return selected;
}

bool isCacheEntryResident(AssetCache cache, AssetRequest request)
{
    uvec4 revision = cache.sets[request.setIndex].versions[request.versionIndex].revision;
    bool hasPayload = revision.w != 0u;
    bool epochAdvanced = revision.x >= request.epoch;
    return hasPayload && epochAdvanced;
}

AssetMatrix resolveAsset(AssetCache cache, AssetRequest request)
{
    AssetCache param = cache;
    AssetRequest param_1 = request;
    AssetMatrix selected = selectCachePlane(param, param_1);
    AssetCache param_2 = cache;
    AssetRequest param_3 = request;
    if (isCacheEntryResident(param_2, param_3))
    {
        return selected;
    }
    return cache.resident;
}

void _404(uint _405, vec2 _406)
{
    D.data[_405] = _406.x;
    D.data[_405 + 1u] = _406.y;
}

void storeResolvedAsset(AssetMatrix resolved)
{
    vec2 _414[384] = resolved.value;
    uint _415 = 0u;
    uint _420;
    for (;;)
    {
        _420 = _415;
        if (_420 < 768u)
        {
            _404(((uint(0) + (_420 / 32u)) * uint(32)) + (uint(0) + (_420 % 32u)), _414[_420 / 2u]);
            _415 = _420 + 2u;
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
    uint routingKey = buildRoutingKey();
    uint param = routingKey;
    AssetRequest request = decodeRequest(param);
    AssetMatrix _338 = loadSourceAsset();
    AssetMatrix source = _338;
    AssetMatrix param_1 = _338;
    AssetRequest param_2 = request;
    AssetCache _344 = populateCache(param_1, param_2);
    AssetCache cache = _344;
    AssetCache param_3 = _344;
    AssetRequest param_4 = request;
    AssetCache _350 = advanceCacheEpoch(param_3, param_4);
    AssetCache currentCache = _350;
    AssetCache param_5 = _350;
    AssetRequest param_6 = request;
    AssetMatrix _356 = resolveAsset(param_5, param_6);
    AssetMatrix resolved = _356;
    AssetMatrix param_7 = _356;
    storeResolvedAsset(param_7);
}

