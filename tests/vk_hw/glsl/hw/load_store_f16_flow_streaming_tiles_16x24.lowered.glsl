#version 460
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct StreamRoute
{
    uint queueIndex;
    uint layerIndex;
    uint sequence;
    uint priority;
};

struct StreamMatrix
{
    f16vec2 value[192];
};

struct TileVersion
{
    StreamMatrix layers[2];
    uvec4 state;
};

struct TileQueue
{
    TileVersion versions[2];
};

struct SharedTileStorage
{
    uvec4 headers[2];
    float16_t values[384];
};

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

shared SharedTileStorage tileStorage;

uint readStreamKey()
{
    uint producerKey = floatBitsToUint(float(B.data[0]));
    uint consumerKey = floatBitsToUint(float(C.data[0]));
    uint dispatchKey = gl_WorkGroupID.x ^ gl_LocalInvocationIndex;
    return (producerKey ^ (consumerKey << 1u)) ^ dispatchKey;
}

StreamRoute decodeStreamRoute(uint streamKey)
{
    StreamRoute route;
    route.queueIndex = streamKey & 1u;
    route.layerIndex = (streamKey >> 1u) & 1u;
    route.sequence = streamKey >> 2u;
    route.priority = (streamKey >> 4u) & 3u;
    return route;
}

f16vec2 _392(uint _393)
{
    return f16vec2(A.data[_393], A.data[_393 + 1u]);
}

StreamMatrix loadInboundTile()
{
    uint _405 = 0u;
    f16vec2 _404[192];
    uint _410;
    for (;;)
    {
        _410 = _405;
        if (_410 < 384u)
        {
            _404[_410 / 2u] = _392(((uint(0) + (_410 / 24u)) * uint(24)) + (uint(0) + (_410 % 24u)));
            _405 = _410 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _141[192] = _404;
    f16vec2 tempArg[192] = _141;
    f16vec2 inbound[192] = _141;
    StreamMatrix result;
    result.value = _141;
    return result;
}

void _430(uint _431, f16vec2 _432)
{
    tileStorage.values[_431] = _432.x;
    tileStorage.values[_431 + 1u] = _432.y;
}

void publishWorkgroupTile(StreamMatrix inbound, StreamRoute route)
{
    for (int queueIndex = 0; queueIndex < 2; queueIndex++)
    {
        tileStorage.headers[queueIndex] = uvec4(route.sequence, uint(queueIndex), route.priority, 1u);
    }
    f16vec2 _441[192] = inbound.value;
    uint _442 = 0u;
    uint _447;
    for (;;)
    {
        _447 = _442;
        if (_447 < 384u)
        {
            _430(((uint(0) + (_447 / 24u)) * uint(24)) + (uint(0) + (_447 % 24u)), _441[_447 / 2u]);
            _442 = _447 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

f16vec2 _466(uint _467)
{
    float16_t _471 = tileStorage.values[_467];
    float16_t _474 = tileStorage.values[_467 + 1u];
    return f16vec2(_471, _474);
}

StreamMatrix acquireWorkgroupTile()
{
    uint _477 = 0u;
    f16vec2 _476[192];
    uint _482;
    for (;;)
    {
        _482 = _477;
        if (_482 < 384u)
        {
            _476[_482 / 2u] = _466(((uint(0) + (_482 / 24u)) * uint(24)) + (uint(0) + (_482 % 24u)));
            _477 = _482 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _184[192] = _476;
    f16vec2 tempArg[192] = _184;
    f16vec2 staged[192] = _184;
    StreamMatrix result;
    result.value = _184;
    return result;
}

TileQueue populateTileQueue(StreamMatrix staged, StreamRoute route)
{
    TileQueue queue;
    for (int queueIndex = 0; queueIndex < 2; queueIndex++)
    {
        queue.versions[queueIndex].state = tileStorage.headers[queueIndex];
        for (int layerIndex = 0; layerIndex < 2; layerIndex++)
        {
            queue.versions[queueIndex].layers[layerIndex] = staged;
        }
    }
    queue.versions[route.queueIndex].state.y = route.layerIndex;
    return queue;
}

TileQueue advanceTileQueue(inout TileQueue queue, StreamRoute route)
{
    StreamMatrix carried = queue.versions[route.queueIndex].layers[route.layerIndex];
    for (uint queueStep = 0u; queueStep < 3u; queueStep++)
    {
        uint candidateIndex = (route.queueIndex + queueStep) & 1u;
        StreamMatrix candidate = queue.versions[candidateIndex].layers[route.layerIndex];
        bool hasPriority = queue.versions[candidateIndex].state.z <= route.priority;
        carried = hasPriority ? queue.versions[candidateIndex].layers[route.layerIndex] : carried;
    }
    queue.versions[route.queueIndex].layers[route.layerIndex] = carried;
    return queue;
}

StreamMatrix selectStreamedTile(TileQueue queue, StreamRoute route)
{
    StreamMatrix selected;
    switch (route.priority)
    {
        case 0u:
        {
            selected = queue.versions[route.queueIndex].layers[0];
            break;
        }
        case 1u:
        {
            selected = queue.versions[route.queueIndex].layers[1];
            break;
        }
        case 2u:
        {
            selected = queue.versions[0].layers[route.layerIndex];
            break;
        }
        default:
        {
            selected = queue.versions[1].layers[route.layerIndex];
            break;
        }
    }
    return selected;
}

StreamMatrix resolveStreamingTile(TileQueue queue, StreamRoute route)
{
    TileQueue param = queue;
    StreamRoute param_1 = route;
    StreamMatrix selected = selectStreamedTile(param, param_1);
    bool published = tileStorage.headers[route.queueIndex].w != 0u;
    if (published)
    {
        return selected;
    }
    return queue.versions[route.queueIndex].layers[route.layerIndex];
}

void _501(uint _502, f16vec2 _503)
{
    D.data[_502] = _503.x;
    D.data[_502 + 1u] = _503.y;
}

void storeStreamingTile(StreamMatrix streamed)
{
    f16vec2 _511[192] = streamed.value;
    uint _512 = 0u;
    uint _517;
    for (;;)
    {
        _517 = _512;
        if (_517 < 384u)
        {
            _501(((uint(0) + (_517 / 24u)) * uint(24)) + (uint(0) + (_517 % 24u)), _511[_517 / 2u]);
            _512 = _517 + 2u;
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
    uint streamKey = readStreamKey();
    uint param = streamKey;
    StreamRoute route = decodeStreamRoute(param);
    StreamMatrix _355 = loadInboundTile();
    StreamMatrix inbound = _355;
    StreamMatrix param_1 = _355;
    StreamRoute param_2 = route;
    publishWorkgroupTile(param_1, param_2);
    memoryBarrierShared();
    barrier();
    StreamMatrix _364 = acquireWorkgroupTile();
    StreamMatrix staged = _364;
    StreamMatrix param_3 = _364;
    StreamRoute param_4 = route;
    TileQueue _370 = populateTileQueue(param_3, param_4);
    TileQueue queue = _370;
    TileQueue param_5 = _370;
    StreamRoute param_6 = route;
    TileQueue _376 = advanceTileQueue(param_5, param_6);
    TileQueue currentQueue = _376;
    TileQueue param_7 = _376;
    StreamRoute param_8 = route;
    StreamMatrix _382 = resolveStreamingTile(param_7, param_8);
    StreamMatrix resolved = _382;
    StreamMatrix param_9 = _382;
    storeStreamingTile(param_9);
}

