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

void publishWorkgroupTile(StreamMatrix inbound, StreamRoute route)
{
    for (int queueIndex = 0; queueIndex < 2; queueIndex++)
    {
        tileStorage.headers[queueIndex] = uvec4(route.sequence, uint(queueIndex), route.priority, 1u);
    }
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 0u)] = inbound.value[0].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 1u)] = inbound.value[0].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 2u)] = inbound.value[1].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 3u)] = inbound.value[1].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 4u)] = inbound.value[2].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 5u)] = inbound.value[2].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 6u)] = inbound.value[3].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 7u)] = inbound.value[3].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 8u)] = inbound.value[4].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 9u)] = inbound.value[4].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 10u)] = inbound.value[5].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 11u)] = inbound.value[5].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 12u)] = inbound.value[6].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 13u)] = inbound.value[6].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 14u)] = inbound.value[7].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 15u)] = inbound.value[7].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 16u)] = inbound.value[8].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 17u)] = inbound.value[8].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 18u)] = inbound.value[9].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 19u)] = inbound.value[9].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 20u)] = inbound.value[10].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 21u)] = inbound.value[10].y;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 22u)] = inbound.value[11].x;
    tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 23u)] = inbound.value[11].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 0u)] = inbound.value[12].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 1u)] = inbound.value[12].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 2u)] = inbound.value[13].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 3u)] = inbound.value[13].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 4u)] = inbound.value[14].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 5u)] = inbound.value[14].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 6u)] = inbound.value[15].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 7u)] = inbound.value[15].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 8u)] = inbound.value[16].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 9u)] = inbound.value[16].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 10u)] = inbound.value[17].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 11u)] = inbound.value[17].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 12u)] = inbound.value[18].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 13u)] = inbound.value[18].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 14u)] = inbound.value[19].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 15u)] = inbound.value[19].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 16u)] = inbound.value[20].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 17u)] = inbound.value[20].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 18u)] = inbound.value[21].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 19u)] = inbound.value[21].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 20u)] = inbound.value[22].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 21u)] = inbound.value[22].y;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 22u)] = inbound.value[23].x;
    tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 23u)] = inbound.value[23].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 0u)] = inbound.value[24].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 1u)] = inbound.value[24].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 2u)] = inbound.value[25].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 3u)] = inbound.value[25].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 4u)] = inbound.value[26].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 5u)] = inbound.value[26].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 6u)] = inbound.value[27].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 7u)] = inbound.value[27].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 8u)] = inbound.value[28].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 9u)] = inbound.value[28].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 10u)] = inbound.value[29].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 11u)] = inbound.value[29].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 12u)] = inbound.value[30].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 13u)] = inbound.value[30].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 14u)] = inbound.value[31].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 15u)] = inbound.value[31].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 16u)] = inbound.value[32].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 17u)] = inbound.value[32].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 18u)] = inbound.value[33].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 19u)] = inbound.value[33].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 20u)] = inbound.value[34].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 21u)] = inbound.value[34].y;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 22u)] = inbound.value[35].x;
    tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 23u)] = inbound.value[35].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 0u)] = inbound.value[36].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 1u)] = inbound.value[36].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 2u)] = inbound.value[37].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 3u)] = inbound.value[37].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 4u)] = inbound.value[38].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 5u)] = inbound.value[38].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 6u)] = inbound.value[39].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 7u)] = inbound.value[39].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 8u)] = inbound.value[40].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 9u)] = inbound.value[40].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 10u)] = inbound.value[41].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 11u)] = inbound.value[41].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 12u)] = inbound.value[42].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 13u)] = inbound.value[42].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 14u)] = inbound.value[43].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 15u)] = inbound.value[43].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 16u)] = inbound.value[44].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 17u)] = inbound.value[44].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 18u)] = inbound.value[45].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 19u)] = inbound.value[45].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 20u)] = inbound.value[46].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 21u)] = inbound.value[46].y;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 22u)] = inbound.value[47].x;
    tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 23u)] = inbound.value[47].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 0u)] = inbound.value[48].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 1u)] = inbound.value[48].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 2u)] = inbound.value[49].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 3u)] = inbound.value[49].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 4u)] = inbound.value[50].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 5u)] = inbound.value[50].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 6u)] = inbound.value[51].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 7u)] = inbound.value[51].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 8u)] = inbound.value[52].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 9u)] = inbound.value[52].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 10u)] = inbound.value[53].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 11u)] = inbound.value[53].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 12u)] = inbound.value[54].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 13u)] = inbound.value[54].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 14u)] = inbound.value[55].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 15u)] = inbound.value[55].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 16u)] = inbound.value[56].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 17u)] = inbound.value[56].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 18u)] = inbound.value[57].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 19u)] = inbound.value[57].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 20u)] = inbound.value[58].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 21u)] = inbound.value[58].y;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 22u)] = inbound.value[59].x;
    tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 23u)] = inbound.value[59].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 0u)] = inbound.value[60].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 1u)] = inbound.value[60].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 2u)] = inbound.value[61].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 3u)] = inbound.value[61].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 4u)] = inbound.value[62].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 5u)] = inbound.value[62].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 6u)] = inbound.value[63].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 7u)] = inbound.value[63].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 8u)] = inbound.value[64].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 9u)] = inbound.value[64].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 10u)] = inbound.value[65].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 11u)] = inbound.value[65].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 12u)] = inbound.value[66].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 13u)] = inbound.value[66].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 14u)] = inbound.value[67].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 15u)] = inbound.value[67].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 16u)] = inbound.value[68].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 17u)] = inbound.value[68].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 18u)] = inbound.value[69].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 19u)] = inbound.value[69].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 20u)] = inbound.value[70].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 21u)] = inbound.value[70].y;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 22u)] = inbound.value[71].x;
    tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 23u)] = inbound.value[71].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 0u)] = inbound.value[72].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 1u)] = inbound.value[72].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 2u)] = inbound.value[73].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 3u)] = inbound.value[73].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 4u)] = inbound.value[74].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 5u)] = inbound.value[74].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 6u)] = inbound.value[75].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 7u)] = inbound.value[75].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 8u)] = inbound.value[76].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 9u)] = inbound.value[76].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 10u)] = inbound.value[77].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 11u)] = inbound.value[77].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 12u)] = inbound.value[78].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 13u)] = inbound.value[78].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 14u)] = inbound.value[79].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 15u)] = inbound.value[79].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 16u)] = inbound.value[80].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 17u)] = inbound.value[80].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 18u)] = inbound.value[81].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 19u)] = inbound.value[81].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 20u)] = inbound.value[82].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 21u)] = inbound.value[82].y;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 22u)] = inbound.value[83].x;
    tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 23u)] = inbound.value[83].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 0u)] = inbound.value[84].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 1u)] = inbound.value[84].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 2u)] = inbound.value[85].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 3u)] = inbound.value[85].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 4u)] = inbound.value[86].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 5u)] = inbound.value[86].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 6u)] = inbound.value[87].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 7u)] = inbound.value[87].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 8u)] = inbound.value[88].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 9u)] = inbound.value[88].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 10u)] = inbound.value[89].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 11u)] = inbound.value[89].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 12u)] = inbound.value[90].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 13u)] = inbound.value[90].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 14u)] = inbound.value[91].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 15u)] = inbound.value[91].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 16u)] = inbound.value[92].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 17u)] = inbound.value[92].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 18u)] = inbound.value[93].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 19u)] = inbound.value[93].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 20u)] = inbound.value[94].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 21u)] = inbound.value[94].y;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 22u)] = inbound.value[95].x;
    tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 23u)] = inbound.value[95].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 0u)] = inbound.value[96].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 1u)] = inbound.value[96].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 2u)] = inbound.value[97].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 3u)] = inbound.value[97].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 4u)] = inbound.value[98].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 5u)] = inbound.value[98].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 6u)] = inbound.value[99].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 7u)] = inbound.value[99].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 8u)] = inbound.value[100].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 9u)] = inbound.value[100].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 10u)] = inbound.value[101].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 11u)] = inbound.value[101].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 12u)] = inbound.value[102].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 13u)] = inbound.value[102].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 14u)] = inbound.value[103].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 15u)] = inbound.value[103].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 16u)] = inbound.value[104].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 17u)] = inbound.value[104].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 18u)] = inbound.value[105].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 19u)] = inbound.value[105].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 20u)] = inbound.value[106].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 21u)] = inbound.value[106].y;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 22u)] = inbound.value[107].x;
    tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 23u)] = inbound.value[107].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 0u)] = inbound.value[108].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 1u)] = inbound.value[108].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 2u)] = inbound.value[109].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 3u)] = inbound.value[109].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 4u)] = inbound.value[110].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 5u)] = inbound.value[110].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 6u)] = inbound.value[111].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 7u)] = inbound.value[111].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 8u)] = inbound.value[112].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 9u)] = inbound.value[112].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 10u)] = inbound.value[113].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 11u)] = inbound.value[113].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 12u)] = inbound.value[114].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 13u)] = inbound.value[114].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 14u)] = inbound.value[115].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 15u)] = inbound.value[115].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 16u)] = inbound.value[116].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 17u)] = inbound.value[116].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 18u)] = inbound.value[117].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 19u)] = inbound.value[117].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 20u)] = inbound.value[118].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 21u)] = inbound.value[118].y;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 22u)] = inbound.value[119].x;
    tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 23u)] = inbound.value[119].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 0u)] = inbound.value[120].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 1u)] = inbound.value[120].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 2u)] = inbound.value[121].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 3u)] = inbound.value[121].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 4u)] = inbound.value[122].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 5u)] = inbound.value[122].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 6u)] = inbound.value[123].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 7u)] = inbound.value[123].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 8u)] = inbound.value[124].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 9u)] = inbound.value[124].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 10u)] = inbound.value[125].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 11u)] = inbound.value[125].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 12u)] = inbound.value[126].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 13u)] = inbound.value[126].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 14u)] = inbound.value[127].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 15u)] = inbound.value[127].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 16u)] = inbound.value[128].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 17u)] = inbound.value[128].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 18u)] = inbound.value[129].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 19u)] = inbound.value[129].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 20u)] = inbound.value[130].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 21u)] = inbound.value[130].y;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 22u)] = inbound.value[131].x;
    tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 23u)] = inbound.value[131].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 0u)] = inbound.value[132].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 1u)] = inbound.value[132].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 2u)] = inbound.value[133].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 3u)] = inbound.value[133].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 4u)] = inbound.value[134].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 5u)] = inbound.value[134].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 6u)] = inbound.value[135].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 7u)] = inbound.value[135].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 8u)] = inbound.value[136].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 9u)] = inbound.value[136].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 10u)] = inbound.value[137].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 11u)] = inbound.value[137].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 12u)] = inbound.value[138].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 13u)] = inbound.value[138].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 14u)] = inbound.value[139].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 15u)] = inbound.value[139].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 16u)] = inbound.value[140].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 17u)] = inbound.value[140].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 18u)] = inbound.value[141].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 19u)] = inbound.value[141].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 20u)] = inbound.value[142].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 21u)] = inbound.value[142].y;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 22u)] = inbound.value[143].x;
    tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 23u)] = inbound.value[143].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 0u)] = inbound.value[144].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 1u)] = inbound.value[144].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 2u)] = inbound.value[145].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 3u)] = inbound.value[145].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 4u)] = inbound.value[146].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 5u)] = inbound.value[146].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 6u)] = inbound.value[147].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 7u)] = inbound.value[147].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 8u)] = inbound.value[148].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 9u)] = inbound.value[148].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 10u)] = inbound.value[149].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 11u)] = inbound.value[149].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 12u)] = inbound.value[150].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 13u)] = inbound.value[150].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 14u)] = inbound.value[151].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 15u)] = inbound.value[151].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 16u)] = inbound.value[152].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 17u)] = inbound.value[152].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 18u)] = inbound.value[153].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 19u)] = inbound.value[153].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 20u)] = inbound.value[154].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 21u)] = inbound.value[154].y;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 22u)] = inbound.value[155].x;
    tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 23u)] = inbound.value[155].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 0u)] = inbound.value[156].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 1u)] = inbound.value[156].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 2u)] = inbound.value[157].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 3u)] = inbound.value[157].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 4u)] = inbound.value[158].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 5u)] = inbound.value[158].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 6u)] = inbound.value[159].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 7u)] = inbound.value[159].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 8u)] = inbound.value[160].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 9u)] = inbound.value[160].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 10u)] = inbound.value[161].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 11u)] = inbound.value[161].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 12u)] = inbound.value[162].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 13u)] = inbound.value[162].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 14u)] = inbound.value[163].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 15u)] = inbound.value[163].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 16u)] = inbound.value[164].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 17u)] = inbound.value[164].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 18u)] = inbound.value[165].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 19u)] = inbound.value[165].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 20u)] = inbound.value[166].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 21u)] = inbound.value[166].y;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 22u)] = inbound.value[167].x;
    tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 23u)] = inbound.value[167].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 0u)] = inbound.value[168].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 1u)] = inbound.value[168].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 2u)] = inbound.value[169].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 3u)] = inbound.value[169].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 4u)] = inbound.value[170].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 5u)] = inbound.value[170].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 6u)] = inbound.value[171].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 7u)] = inbound.value[171].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 8u)] = inbound.value[172].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 9u)] = inbound.value[172].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 10u)] = inbound.value[173].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 11u)] = inbound.value[173].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 12u)] = inbound.value[174].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 13u)] = inbound.value[174].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 14u)] = inbound.value[175].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 15u)] = inbound.value[175].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 16u)] = inbound.value[176].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 17u)] = inbound.value[176].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 18u)] = inbound.value[177].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 19u)] = inbound.value[177].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 20u)] = inbound.value[178].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 21u)] = inbound.value[178].y;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 22u)] = inbound.value[179].x;
    tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 23u)] = inbound.value[179].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 0u)] = inbound.value[180].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 1u)] = inbound.value[180].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 2u)] = inbound.value[181].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 3u)] = inbound.value[181].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 4u)] = inbound.value[182].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 5u)] = inbound.value[182].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 6u)] = inbound.value[183].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 7u)] = inbound.value[183].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 8u)] = inbound.value[184].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 9u)] = inbound.value[184].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 10u)] = inbound.value[185].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 11u)] = inbound.value[185].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 12u)] = inbound.value[186].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 13u)] = inbound.value[186].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 14u)] = inbound.value[187].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 15u)] = inbound.value[187].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 16u)] = inbound.value[188].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 17u)] = inbound.value[188].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 18u)] = inbound.value[189].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 19u)] = inbound.value[189].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 20u)] = inbound.value[190].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 21u)] = inbound.value[190].y;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 22u)] = inbound.value[191].x;
    tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 23u)] = inbound.value[191].y;
}

StreamMatrix acquireWorkgroupTile()
{
    float16_t _6028 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 0u)];
    float16_t _6042 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 1u)];
    float16_t _6057 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 2u)];
    float16_t _6071 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 3u)];
    float16_t _6086 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 4u)];
    float16_t _6100 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 5u)];
    float16_t _6115 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 6u)];
    float16_t _6129 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 7u)];
    float16_t _6144 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 8u)];
    float16_t _6158 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 9u)];
    float16_t _6173 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 10u)];
    float16_t _6187 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 11u)];
    float16_t _6202 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 12u)];
    float16_t _6216 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 13u)];
    float16_t _6231 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 14u)];
    float16_t _6245 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 15u)];
    float16_t _6260 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 16u)];
    float16_t _6274 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 17u)];
    float16_t _6289 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 18u)];
    float16_t _6303 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 19u)];
    float16_t _6318 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 20u)];
    float16_t _6332 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 21u)];
    float16_t _6347 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 22u)];
    float16_t _6361 = tileStorage.values[((uint(0) + 0u) * uint(24)) + (uint(0) + 23u)];
    float16_t _6376 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 0u)];
    float16_t _6390 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 1u)];
    float16_t _6405 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 2u)];
    float16_t _6419 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 3u)];
    float16_t _6434 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 4u)];
    float16_t _6448 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 5u)];
    float16_t _6463 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 6u)];
    float16_t _6477 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 7u)];
    float16_t _6492 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 8u)];
    float16_t _6506 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 9u)];
    float16_t _6521 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 10u)];
    float16_t _6535 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 11u)];
    float16_t _6550 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 12u)];
    float16_t _6564 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 13u)];
    float16_t _6579 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 14u)];
    float16_t _6593 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 15u)];
    float16_t _6608 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 16u)];
    float16_t _6622 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 17u)];
    float16_t _6637 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 18u)];
    float16_t _6651 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 19u)];
    float16_t _6666 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 20u)];
    float16_t _6680 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 21u)];
    float16_t _6695 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 22u)];
    float16_t _6709 = tileStorage.values[((uint(0) + 1u) * uint(24)) + (uint(0) + 23u)];
    float16_t _6724 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 0u)];
    float16_t _6738 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 1u)];
    float16_t _6753 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 2u)];
    float16_t _6767 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 3u)];
    float16_t _6782 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 4u)];
    float16_t _6796 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 5u)];
    float16_t _6811 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 6u)];
    float16_t _6825 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 7u)];
    float16_t _6840 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 8u)];
    float16_t _6854 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 9u)];
    float16_t _6869 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 10u)];
    float16_t _6883 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 11u)];
    float16_t _6898 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 12u)];
    float16_t _6912 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 13u)];
    float16_t _6927 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 14u)];
    float16_t _6941 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 15u)];
    float16_t _6956 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 16u)];
    float16_t _6970 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 17u)];
    float16_t _6985 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 18u)];
    float16_t _6999 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 19u)];
    float16_t _7014 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 20u)];
    float16_t _7028 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 21u)];
    float16_t _7043 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 22u)];
    float16_t _7057 = tileStorage.values[((uint(0) + 2u) * uint(24)) + (uint(0) + 23u)];
    float16_t _7072 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 0u)];
    float16_t _7086 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 1u)];
    float16_t _7101 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 2u)];
    float16_t _7115 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 3u)];
    float16_t _7130 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 4u)];
    float16_t _7144 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 5u)];
    float16_t _7159 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 6u)];
    float16_t _7173 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 7u)];
    float16_t _7188 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 8u)];
    float16_t _7202 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 9u)];
    float16_t _7217 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 10u)];
    float16_t _7231 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 11u)];
    float16_t _7246 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 12u)];
    float16_t _7260 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 13u)];
    float16_t _7275 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 14u)];
    float16_t _7289 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 15u)];
    float16_t _7304 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 16u)];
    float16_t _7318 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 17u)];
    float16_t _7333 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 18u)];
    float16_t _7347 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 19u)];
    float16_t _7362 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 20u)];
    float16_t _7376 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 21u)];
    float16_t _7391 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 22u)];
    float16_t _7405 = tileStorage.values[((uint(0) + 3u) * uint(24)) + (uint(0) + 23u)];
    float16_t _7420 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 0u)];
    float16_t _7434 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 1u)];
    float16_t _7449 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 2u)];
    float16_t _7463 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 3u)];
    float16_t _7478 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 4u)];
    float16_t _7492 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 5u)];
    float16_t _7507 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 6u)];
    float16_t _7521 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 7u)];
    float16_t _7536 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 8u)];
    float16_t _7550 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 9u)];
    float16_t _7565 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 10u)];
    float16_t _7579 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 11u)];
    float16_t _7594 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 12u)];
    float16_t _7608 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 13u)];
    float16_t _7623 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 14u)];
    float16_t _7637 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 15u)];
    float16_t _7652 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 16u)];
    float16_t _7666 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 17u)];
    float16_t _7681 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 18u)];
    float16_t _7695 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 19u)];
    float16_t _7710 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 20u)];
    float16_t _7724 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 21u)];
    float16_t _7739 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 22u)];
    float16_t _7753 = tileStorage.values[((uint(0) + 4u) * uint(24)) + (uint(0) + 23u)];
    float16_t _7768 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 0u)];
    float16_t _7782 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 1u)];
    float16_t _7797 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 2u)];
    float16_t _7811 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 3u)];
    float16_t _7826 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 4u)];
    float16_t _7840 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 5u)];
    float16_t _7855 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 6u)];
    float16_t _7869 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 7u)];
    float16_t _7884 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 8u)];
    float16_t _7898 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 9u)];
    float16_t _7913 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 10u)];
    float16_t _7927 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 11u)];
    float16_t _7942 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 12u)];
    float16_t _7956 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 13u)];
    float16_t _7971 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 14u)];
    float16_t _7985 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 15u)];
    float16_t _8000 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 16u)];
    float16_t _8014 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 17u)];
    float16_t _8029 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 18u)];
    float16_t _8043 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 19u)];
    float16_t _8058 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 20u)];
    float16_t _8072 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 21u)];
    float16_t _8087 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 22u)];
    float16_t _8101 = tileStorage.values[((uint(0) + 5u) * uint(24)) + (uint(0) + 23u)];
    float16_t _8116 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 0u)];
    float16_t _8130 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 1u)];
    float16_t _8145 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 2u)];
    float16_t _8159 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 3u)];
    float16_t _8174 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 4u)];
    float16_t _8188 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 5u)];
    float16_t _8203 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 6u)];
    float16_t _8217 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 7u)];
    float16_t _8232 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 8u)];
    float16_t _8246 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 9u)];
    float16_t _8261 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 10u)];
    float16_t _8275 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 11u)];
    float16_t _8290 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 12u)];
    float16_t _8304 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 13u)];
    float16_t _8319 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 14u)];
    float16_t _8333 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 15u)];
    float16_t _8348 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 16u)];
    float16_t _8362 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 17u)];
    float16_t _8377 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 18u)];
    float16_t _8391 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 19u)];
    float16_t _8406 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 20u)];
    float16_t _8420 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 21u)];
    float16_t _8435 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 22u)];
    float16_t _8449 = tileStorage.values[((uint(0) + 6u) * uint(24)) + (uint(0) + 23u)];
    float16_t _8464 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 0u)];
    float16_t _8478 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 1u)];
    float16_t _8493 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 2u)];
    float16_t _8507 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 3u)];
    float16_t _8522 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 4u)];
    float16_t _8536 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 5u)];
    float16_t _8551 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 6u)];
    float16_t _8565 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 7u)];
    float16_t _8580 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 8u)];
    float16_t _8594 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 9u)];
    float16_t _8609 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 10u)];
    float16_t _8623 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 11u)];
    float16_t _8638 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 12u)];
    float16_t _8652 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 13u)];
    float16_t _8667 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 14u)];
    float16_t _8681 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 15u)];
    float16_t _8696 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 16u)];
    float16_t _8710 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 17u)];
    float16_t _8725 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 18u)];
    float16_t _8739 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 19u)];
    float16_t _8754 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 20u)];
    float16_t _8768 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 21u)];
    float16_t _8783 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 22u)];
    float16_t _8797 = tileStorage.values[((uint(0) + 7u) * uint(24)) + (uint(0) + 23u)];
    float16_t _8812 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 0u)];
    float16_t _8826 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 1u)];
    float16_t _8841 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 2u)];
    float16_t _8855 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 3u)];
    float16_t _8870 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 4u)];
    float16_t _8884 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 5u)];
    float16_t _8899 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 6u)];
    float16_t _8913 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 7u)];
    float16_t _8928 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 8u)];
    float16_t _8942 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 9u)];
    float16_t _8957 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 10u)];
    float16_t _8971 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 11u)];
    float16_t _8986 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 12u)];
    float16_t _9000 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 13u)];
    float16_t _9015 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 14u)];
    float16_t _9029 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 15u)];
    float16_t _9044 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 16u)];
    float16_t _9058 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 17u)];
    float16_t _9073 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 18u)];
    float16_t _9087 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 19u)];
    float16_t _9102 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 20u)];
    float16_t _9116 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 21u)];
    float16_t _9131 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 22u)];
    float16_t _9145 = tileStorage.values[((uint(0) + 8u) * uint(24)) + (uint(0) + 23u)];
    float16_t _9160 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 0u)];
    float16_t _9174 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 1u)];
    float16_t _9189 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 2u)];
    float16_t _9203 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 3u)];
    float16_t _9218 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 4u)];
    float16_t _9232 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 5u)];
    float16_t _9247 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 6u)];
    float16_t _9261 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 7u)];
    float16_t _9276 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 8u)];
    float16_t _9290 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 9u)];
    float16_t _9305 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 10u)];
    float16_t _9319 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 11u)];
    float16_t _9334 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 12u)];
    float16_t _9348 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 13u)];
    float16_t _9363 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 14u)];
    float16_t _9377 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 15u)];
    float16_t _9392 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 16u)];
    float16_t _9406 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 17u)];
    float16_t _9421 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 18u)];
    float16_t _9435 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 19u)];
    float16_t _9450 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 20u)];
    float16_t _9464 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 21u)];
    float16_t _9479 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 22u)];
    float16_t _9493 = tileStorage.values[((uint(0) + 9u) * uint(24)) + (uint(0) + 23u)];
    float16_t _9508 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 0u)];
    float16_t _9522 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 1u)];
    float16_t _9537 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 2u)];
    float16_t _9551 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 3u)];
    float16_t _9566 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 4u)];
    float16_t _9580 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 5u)];
    float16_t _9595 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 6u)];
    float16_t _9609 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 7u)];
    float16_t _9624 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 8u)];
    float16_t _9638 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 9u)];
    float16_t _9653 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 10u)];
    float16_t _9667 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 11u)];
    float16_t _9682 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 12u)];
    float16_t _9696 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 13u)];
    float16_t _9711 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 14u)];
    float16_t _9725 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 15u)];
    float16_t _9740 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 16u)];
    float16_t _9754 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 17u)];
    float16_t _9769 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 18u)];
    float16_t _9783 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 19u)];
    float16_t _9798 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 20u)];
    float16_t _9812 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 21u)];
    float16_t _9827 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 22u)];
    float16_t _9841 = tileStorage.values[((uint(0) + 10u) * uint(24)) + (uint(0) + 23u)];
    float16_t _9856 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 0u)];
    float16_t _9870 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 1u)];
    float16_t _9885 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 2u)];
    float16_t _9899 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 3u)];
    float16_t _9914 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 4u)];
    float16_t _9928 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 5u)];
    float16_t _9943 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 6u)];
    float16_t _9957 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 7u)];
    float16_t _9972 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 8u)];
    float16_t _9986 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 9u)];
    float16_t _10001 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 10u)];
    float16_t _10015 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 11u)];
    float16_t _10030 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 12u)];
    float16_t _10044 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 13u)];
    float16_t _10059 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 14u)];
    float16_t _10073 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 15u)];
    float16_t _10088 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 16u)];
    float16_t _10102 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 17u)];
    float16_t _10117 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 18u)];
    float16_t _10131 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 19u)];
    float16_t _10146 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 20u)];
    float16_t _10160 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 21u)];
    float16_t _10175 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 22u)];
    float16_t _10189 = tileStorage.values[((uint(0) + 11u) * uint(24)) + (uint(0) + 23u)];
    float16_t _10204 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 0u)];
    float16_t _10218 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 1u)];
    float16_t _10233 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 2u)];
    float16_t _10247 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 3u)];
    float16_t _10262 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 4u)];
    float16_t _10276 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 5u)];
    float16_t _10291 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 6u)];
    float16_t _10305 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 7u)];
    float16_t _10320 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 8u)];
    float16_t _10334 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 9u)];
    float16_t _10349 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 10u)];
    float16_t _10363 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 11u)];
    float16_t _10378 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 12u)];
    float16_t _10392 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 13u)];
    float16_t _10407 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 14u)];
    float16_t _10421 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 15u)];
    float16_t _10436 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 16u)];
    float16_t _10450 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 17u)];
    float16_t _10465 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 18u)];
    float16_t _10479 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 19u)];
    float16_t _10494 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 20u)];
    float16_t _10508 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 21u)];
    float16_t _10523 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 22u)];
    float16_t _10537 = tileStorage.values[((uint(0) + 12u) * uint(24)) + (uint(0) + 23u)];
    float16_t _10552 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 0u)];
    float16_t _10566 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 1u)];
    float16_t _10581 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 2u)];
    float16_t _10595 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 3u)];
    float16_t _10610 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 4u)];
    float16_t _10624 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 5u)];
    float16_t _10639 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 6u)];
    float16_t _10653 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 7u)];
    float16_t _10668 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 8u)];
    float16_t _10682 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 9u)];
    float16_t _10697 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 10u)];
    float16_t _10711 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 11u)];
    float16_t _10726 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 12u)];
    float16_t _10740 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 13u)];
    float16_t _10755 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 14u)];
    float16_t _10769 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 15u)];
    float16_t _10784 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 16u)];
    float16_t _10798 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 17u)];
    float16_t _10813 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 18u)];
    float16_t _10827 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 19u)];
    float16_t _10842 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 20u)];
    float16_t _10856 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 21u)];
    float16_t _10871 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 22u)];
    float16_t _10885 = tileStorage.values[((uint(0) + 13u) * uint(24)) + (uint(0) + 23u)];
    float16_t _10900 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 0u)];
    float16_t _10914 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 1u)];
    float16_t _10929 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 2u)];
    float16_t _10943 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 3u)];
    float16_t _10958 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 4u)];
    float16_t _10972 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 5u)];
    float16_t _10987 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 6u)];
    float16_t _11001 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 7u)];
    float16_t _11016 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 8u)];
    float16_t _11030 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 9u)];
    float16_t _11045 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 10u)];
    float16_t _11059 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 11u)];
    float16_t _11074 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 12u)];
    float16_t _11088 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 13u)];
    float16_t _11103 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 14u)];
    float16_t _11117 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 15u)];
    float16_t _11132 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 16u)];
    float16_t _11146 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 17u)];
    float16_t _11161 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 18u)];
    float16_t _11175 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 19u)];
    float16_t _11190 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 20u)];
    float16_t _11204 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 21u)];
    float16_t _11219 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 22u)];
    float16_t _11233 = tileStorage.values[((uint(0) + 14u) * uint(24)) + (uint(0) + 23u)];
    float16_t _11248 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 0u)];
    float16_t _11262 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 1u)];
    float16_t _11277 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 2u)];
    float16_t _11291 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 3u)];
    float16_t _11306 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 4u)];
    float16_t _11320 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 5u)];
    float16_t _11335 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 6u)];
    float16_t _11349 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 7u)];
    float16_t _11364 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 8u)];
    float16_t _11378 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 9u)];
    float16_t _11393 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 10u)];
    float16_t _11407 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 11u)];
    float16_t _11422 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 12u)];
    float16_t _11436 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 13u)];
    float16_t _11451 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 14u)];
    float16_t _11465 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 15u)];
    float16_t _11480 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 16u)];
    float16_t _11494 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 17u)];
    float16_t _11509 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 18u)];
    float16_t _11523 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 19u)];
    float16_t _11538 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 20u)];
    float16_t _11552 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 21u)];
    float16_t _11567 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 22u)];
    float16_t _11581 = tileStorage.values[((uint(0) + 15u) * uint(24)) + (uint(0) + 23u)];
    f16vec2 _184[192] = f16vec2[](f16vec2(_6028, _6042), f16vec2(_6057, _6071), f16vec2(_6086, _6100), f16vec2(_6115, _6129), f16vec2(_6144, _6158), f16vec2(_6173, _6187), f16vec2(_6202, _6216), f16vec2(_6231, _6245), f16vec2(_6260, _6274), f16vec2(_6289, _6303), f16vec2(_6318, _6332), f16vec2(_6347, _6361), f16vec2(_6376, _6390), f16vec2(_6405, _6419), f16vec2(_6434, _6448), f16vec2(_6463, _6477), f16vec2(_6492, _6506), f16vec2(_6521, _6535), f16vec2(_6550, _6564), f16vec2(_6579, _6593), f16vec2(_6608, _6622), f16vec2(_6637, _6651), f16vec2(_6666, _6680), f16vec2(_6695, _6709), f16vec2(_6724, _6738), f16vec2(_6753, _6767), f16vec2(_6782, _6796), f16vec2(_6811, _6825), f16vec2(_6840, _6854), f16vec2(_6869, _6883), f16vec2(_6898, _6912), f16vec2(_6927, _6941), f16vec2(_6956, _6970), f16vec2(_6985, _6999), f16vec2(_7014, _7028), f16vec2(_7043, _7057), f16vec2(_7072, _7086), f16vec2(_7101, _7115), f16vec2(_7130, _7144), f16vec2(_7159, _7173), f16vec2(_7188, _7202), f16vec2(_7217, _7231), f16vec2(_7246, _7260), f16vec2(_7275, _7289), f16vec2(_7304, _7318), f16vec2(_7333, _7347), f16vec2(_7362, _7376), f16vec2(_7391, _7405), f16vec2(_7420, _7434), f16vec2(_7449, _7463), f16vec2(_7478, _7492), f16vec2(_7507, _7521), f16vec2(_7536, _7550), f16vec2(_7565, _7579), f16vec2(_7594, _7608), f16vec2(_7623, _7637), f16vec2(_7652, _7666), f16vec2(_7681, _7695), f16vec2(_7710, _7724), f16vec2(_7739, _7753), f16vec2(_7768, _7782), f16vec2(_7797, _7811), f16vec2(_7826, _7840), f16vec2(_7855, _7869), f16vec2(_7884, _7898), f16vec2(_7913, _7927), f16vec2(_7942, _7956), f16vec2(_7971, _7985), f16vec2(_8000, _8014), f16vec2(_8029, _8043), f16vec2(_8058, _8072), f16vec2(_8087, _8101), f16vec2(_8116, _8130), f16vec2(_8145, _8159), f16vec2(_8174, _8188), f16vec2(_8203, _8217), f16vec2(_8232, _8246), f16vec2(_8261, _8275), f16vec2(_8290, _8304), f16vec2(_8319, _8333), f16vec2(_8348, _8362), f16vec2(_8377, _8391), f16vec2(_8406, _8420), f16vec2(_8435, _8449), f16vec2(_8464, _8478), f16vec2(_8493, _8507), f16vec2(_8522, _8536), f16vec2(_8551, _8565), f16vec2(_8580, _8594), f16vec2(_8609, _8623), f16vec2(_8638, _8652), f16vec2(_8667, _8681), f16vec2(_8696, _8710), f16vec2(_8725, _8739), f16vec2(_8754, _8768), f16vec2(_8783, _8797), f16vec2(_8812, _8826), f16vec2(_8841, _8855), f16vec2(_8870, _8884), f16vec2(_8899, _8913), f16vec2(_8928, _8942), f16vec2(_8957, _8971), f16vec2(_8986, _9000), f16vec2(_9015, _9029), f16vec2(_9044, _9058), f16vec2(_9073, _9087), f16vec2(_9102, _9116), f16vec2(_9131, _9145), f16vec2(_9160, _9174), f16vec2(_9189, _9203), f16vec2(_9218, _9232), f16vec2(_9247, _9261), f16vec2(_9276, _9290), f16vec2(_9305, _9319), f16vec2(_9334, _9348), f16vec2(_9363, _9377), f16vec2(_9392, _9406), f16vec2(_9421, _9435), f16vec2(_9450, _9464), f16vec2(_9479, _9493), f16vec2(_9508, _9522), f16vec2(_9537, _9551), f16vec2(_9566, _9580), f16vec2(_9595, _9609), f16vec2(_9624, _9638), f16vec2(_9653, _9667), f16vec2(_9682, _9696), f16vec2(_9711, _9725), f16vec2(_9740, _9754), f16vec2(_9769, _9783), f16vec2(_9798, _9812), f16vec2(_9827, _9841), f16vec2(_9856, _9870), f16vec2(_9885, _9899), f16vec2(_9914, _9928), f16vec2(_9943, _9957), f16vec2(_9972, _9986), f16vec2(_10001, _10015), f16vec2(_10030, _10044), f16vec2(_10059, _10073), f16vec2(_10088, _10102), f16vec2(_10117, _10131), f16vec2(_10146, _10160), f16vec2(_10175, _10189), f16vec2(_10204, _10218), f16vec2(_10233, _10247), f16vec2(_10262, _10276), f16vec2(_10291, _10305), f16vec2(_10320, _10334), f16vec2(_10349, _10363), f16vec2(_10378, _10392), f16vec2(_10407, _10421), f16vec2(_10436, _10450), f16vec2(_10465, _10479), f16vec2(_10494, _10508), f16vec2(_10523, _10537), f16vec2(_10552, _10566), f16vec2(_10581, _10595), f16vec2(_10610, _10624), f16vec2(_10639, _10653), f16vec2(_10668, _10682), f16vec2(_10697, _10711), f16vec2(_10726, _10740), f16vec2(_10755, _10769), f16vec2(_10784, _10798), f16vec2(_10813, _10827), f16vec2(_10842, _10856), f16vec2(_10871, _10885), f16vec2(_10900, _10914), f16vec2(_10929, _10943), f16vec2(_10958, _10972), f16vec2(_10987, _11001), f16vec2(_11016, _11030), f16vec2(_11045, _11059), f16vec2(_11074, _11088), f16vec2(_11103, _11117), f16vec2(_11132, _11146), f16vec2(_11161, _11175), f16vec2(_11190, _11204), f16vec2(_11219, _11233), f16vec2(_11248, _11262), f16vec2(_11277, _11291), f16vec2(_11306, _11320), f16vec2(_11335, _11349), f16vec2(_11364, _11378), f16vec2(_11393, _11407), f16vec2(_11422, _11436), f16vec2(_11451, _11465), f16vec2(_11480, _11494), f16vec2(_11509, _11523), f16vec2(_11538, _11552), f16vec2(_11567, _11581));
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

void _11584(uint _11585, f16vec2 _11586)
{
    D.data[_11585] = _11586.x;
    D.data[_11585 + 1u] = _11586.y;
}

void storeStreamingTile(StreamMatrix streamed)
{
    f16vec2 _11594[192] = streamed.value;
    uint _11595 = 0u;
    uint _11600;
    for (;;)
    {
        _11600 = _11595;
        if (_11600 < 384u)
        {
            _11584(((uint(0) + (_11600 / 24u)) * uint(24)) + (uint(0) + (_11600 % 24u)), _11594[_11600 / 2u]);
            _11595 = _11600 + 2u;
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

