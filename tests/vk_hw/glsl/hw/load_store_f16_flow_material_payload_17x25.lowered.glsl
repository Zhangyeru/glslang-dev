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

struct MaterialRoute
{
    uint payloadIndex;
    uint layerIndex;
    uint channelIndex;
    uint generation;
};

struct MaterialMatrix
{
    float16_t value[425];
};

struct MaterialLayer
{
    MaterialMatrix channels[2];
    uvec4 residency;
};

struct MaterialPayload
{
    MaterialLayer layers[2];
    uvec4 routing;
};

struct MaterialPacket
{
    MaterialPayload payloads[2];
    vec4 factors;
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

uint readMaterialKey()
{
    uint featureBits = floatBitsToUint(float(B.data[0]));
    uint surfaceBits = floatBitsToUint(float(C.data[0]));
    uint dispatchBits = gl_WorkGroupID.x | (gl_LocalInvocationIndex << 4u);
    return (featureBits ^ (surfaceBits >> 1u)) ^ dispatchBits;
}

MaterialRoute decodeMaterialRoute(uint materialKey)
{
    MaterialRoute route;
    route.payloadIndex = materialKey & 1u;
    route.layerIndex = (materialKey >> 1u) & 1u;
    route.channelIndex = (materialKey >> 2u) & 1u;
    route.generation = materialKey >> 3u;
    return route;
}

MaterialMatrix loadMaterialSurface()
{
    float16_t _138[425] = float16_t[](A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 24u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 0u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 1u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 2u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 3u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 4u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 5u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 6u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 7u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 8u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 9u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 10u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 11u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 12u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 13u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 14u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 15u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 16u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 17u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 18u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 19u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 20u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 21u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 22u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 23u)], A.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 24u)]);
    float16_t tempArg[425] = _138;
    float16_t surface[425] = _138;
    MaterialMatrix result;
    result.value = _138;
    return result;
}

MaterialPacket createMaterialPacket(MaterialMatrix surface, MaterialRoute route)
{
    MaterialPacket packet;
    packet.factors = vec4(float(B.data[1]), float(C.data[1]), float(route.generation), 1.0);
    for (int payloadIndex = 0; payloadIndex < 2; payloadIndex++)
    {
        packet.payloads[payloadIndex].routing = uvec4(route.payloadIndex, route.layerIndex, route.channelIndex, route.generation);
        for (int layerIndex = 0; layerIndex < 2; layerIndex++)
        {
            packet.payloads[payloadIndex].layers[layerIndex].residency = uvec4(uint(payloadIndex), uint(layerIndex), route.generation, 1u);
            for (int channelIndex = 0; channelIndex < 2; channelIndex++)
            {
                packet.payloads[payloadIndex].layers[layerIndex].channels[channelIndex] = surface;
            }
        }
    }
    return packet;
}

MaterialPacket applyMaterialOverrides(inout MaterialPacket packet, MaterialRoute route)
{
    MaterialMatrix activeMaterial = packet.payloads[route.payloadIndex].layers[route.layerIndex].channels[route.channelIndex];
    switch (route.generation & 3u)
    {
        case 0u:
        {
            packet.payloads[0].layers[0].channels[0] = activeMaterial;
            break;
        }
        case 1u:
        {
            packet.payloads[0].layers[1].channels[1] = activeMaterial;
            break;
        }
        case 2u:
        {
            packet.payloads[1].layers[0].channels[1] = activeMaterial;
            break;
        }
        default:
        {
            packet.payloads[1].layers[1].channels[0] = activeMaterial;
            break;
        }
    }
    packet.payloads[route.payloadIndex].layers[route.layerIndex].channels[route.channelIndex] = activeMaterial;
    return packet;
}

MaterialMatrix selectMaterialChannel(MaterialPacket packet, MaterialRoute route)
{
    MaterialMatrix selected = packet.payloads[route.payloadIndex].layers[route.layerIndex].channels[route.channelIndex];
    for (uint probe = 0u; probe < 3u; probe++)
    {
        uint candidateChannel = (route.channelIndex + probe) & 1u;
        MaterialMatrix candidate = packet.payloads[route.payloadIndex].layers[route.layerIndex].channels[candidateChannel];
        bool resident = packet.payloads[route.payloadIndex].layers[route.layerIndex].residency.w != 0u;
        selected = resident ? packet.payloads[route.payloadIndex].layers[route.layerIndex].channels[candidateChannel] : selected;
    }
    return selected;
}

MaterialMatrix resolveMaterialPayload(MaterialPacket packet, MaterialRoute route)
{
    MaterialPacket param = packet;
    MaterialRoute param_1 = route;
    MaterialMatrix selected = selectMaterialChannel(param, param_1);
    bool validFactors = packet.factors.w > 0.0;
    bool validRouting = packet.payloads[route.payloadIndex].routing.z == route.channelIndex;
    if (validFactors && validRouting)
    {
        return selected;
    }
    return packet.payloads[route.payloadIndex].layers[route.layerIndex].channels[route.channelIndex];
}

void storeMaterialPayload(MaterialMatrix material)
{
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 0u)] = material.value[0];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 1u)] = material.value[1];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 2u)] = material.value[2];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 3u)] = material.value[3];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 4u)] = material.value[4];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 5u)] = material.value[5];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 6u)] = material.value[6];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 7u)] = material.value[7];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 8u)] = material.value[8];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 9u)] = material.value[9];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 10u)] = material.value[10];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 11u)] = material.value[11];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 12u)] = material.value[12];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 13u)] = material.value[13];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 14u)] = material.value[14];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 15u)] = material.value[15];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 16u)] = material.value[16];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 17u)] = material.value[17];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 18u)] = material.value[18];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 19u)] = material.value[19];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 20u)] = material.value[20];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 21u)] = material.value[21];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 22u)] = material.value[22];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 23u)] = material.value[23];
    D.data[((uint(0) + 0u) * uint(25)) + (uint(0) + 24u)] = material.value[24];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 0u)] = material.value[25];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 1u)] = material.value[26];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 2u)] = material.value[27];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 3u)] = material.value[28];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 4u)] = material.value[29];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 5u)] = material.value[30];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 6u)] = material.value[31];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 7u)] = material.value[32];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 8u)] = material.value[33];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 9u)] = material.value[34];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 10u)] = material.value[35];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 11u)] = material.value[36];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 12u)] = material.value[37];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 13u)] = material.value[38];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 14u)] = material.value[39];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 15u)] = material.value[40];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 16u)] = material.value[41];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 17u)] = material.value[42];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 18u)] = material.value[43];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 19u)] = material.value[44];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 20u)] = material.value[45];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 21u)] = material.value[46];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 22u)] = material.value[47];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 23u)] = material.value[48];
    D.data[((uint(0) + 1u) * uint(25)) + (uint(0) + 24u)] = material.value[49];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 0u)] = material.value[50];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 1u)] = material.value[51];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 2u)] = material.value[52];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 3u)] = material.value[53];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 4u)] = material.value[54];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 5u)] = material.value[55];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 6u)] = material.value[56];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 7u)] = material.value[57];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 8u)] = material.value[58];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 9u)] = material.value[59];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 10u)] = material.value[60];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 11u)] = material.value[61];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 12u)] = material.value[62];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 13u)] = material.value[63];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 14u)] = material.value[64];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 15u)] = material.value[65];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 16u)] = material.value[66];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 17u)] = material.value[67];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 18u)] = material.value[68];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 19u)] = material.value[69];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 20u)] = material.value[70];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 21u)] = material.value[71];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 22u)] = material.value[72];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 23u)] = material.value[73];
    D.data[((uint(0) + 2u) * uint(25)) + (uint(0) + 24u)] = material.value[74];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 0u)] = material.value[75];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 1u)] = material.value[76];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 2u)] = material.value[77];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 3u)] = material.value[78];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 4u)] = material.value[79];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 5u)] = material.value[80];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 6u)] = material.value[81];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 7u)] = material.value[82];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 8u)] = material.value[83];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 9u)] = material.value[84];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 10u)] = material.value[85];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 11u)] = material.value[86];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 12u)] = material.value[87];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 13u)] = material.value[88];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 14u)] = material.value[89];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 15u)] = material.value[90];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 16u)] = material.value[91];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 17u)] = material.value[92];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 18u)] = material.value[93];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 19u)] = material.value[94];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 20u)] = material.value[95];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 21u)] = material.value[96];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 22u)] = material.value[97];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 23u)] = material.value[98];
    D.data[((uint(0) + 3u) * uint(25)) + (uint(0) + 24u)] = material.value[99];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 0u)] = material.value[100];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 1u)] = material.value[101];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 2u)] = material.value[102];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 3u)] = material.value[103];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 4u)] = material.value[104];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 5u)] = material.value[105];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 6u)] = material.value[106];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 7u)] = material.value[107];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 8u)] = material.value[108];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 9u)] = material.value[109];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 10u)] = material.value[110];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 11u)] = material.value[111];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 12u)] = material.value[112];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 13u)] = material.value[113];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 14u)] = material.value[114];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 15u)] = material.value[115];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 16u)] = material.value[116];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 17u)] = material.value[117];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 18u)] = material.value[118];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 19u)] = material.value[119];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 20u)] = material.value[120];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 21u)] = material.value[121];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 22u)] = material.value[122];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 23u)] = material.value[123];
    D.data[((uint(0) + 4u) * uint(25)) + (uint(0) + 24u)] = material.value[124];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 0u)] = material.value[125];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 1u)] = material.value[126];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 2u)] = material.value[127];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 3u)] = material.value[128];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 4u)] = material.value[129];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 5u)] = material.value[130];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 6u)] = material.value[131];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 7u)] = material.value[132];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 8u)] = material.value[133];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 9u)] = material.value[134];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 10u)] = material.value[135];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 11u)] = material.value[136];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 12u)] = material.value[137];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 13u)] = material.value[138];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 14u)] = material.value[139];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 15u)] = material.value[140];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 16u)] = material.value[141];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 17u)] = material.value[142];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 18u)] = material.value[143];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 19u)] = material.value[144];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 20u)] = material.value[145];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 21u)] = material.value[146];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 22u)] = material.value[147];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 23u)] = material.value[148];
    D.data[((uint(0) + 5u) * uint(25)) + (uint(0) + 24u)] = material.value[149];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 0u)] = material.value[150];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 1u)] = material.value[151];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 2u)] = material.value[152];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 3u)] = material.value[153];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 4u)] = material.value[154];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 5u)] = material.value[155];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 6u)] = material.value[156];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 7u)] = material.value[157];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 8u)] = material.value[158];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 9u)] = material.value[159];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 10u)] = material.value[160];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 11u)] = material.value[161];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 12u)] = material.value[162];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 13u)] = material.value[163];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 14u)] = material.value[164];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 15u)] = material.value[165];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 16u)] = material.value[166];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 17u)] = material.value[167];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 18u)] = material.value[168];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 19u)] = material.value[169];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 20u)] = material.value[170];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 21u)] = material.value[171];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 22u)] = material.value[172];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 23u)] = material.value[173];
    D.data[((uint(0) + 6u) * uint(25)) + (uint(0) + 24u)] = material.value[174];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 0u)] = material.value[175];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 1u)] = material.value[176];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 2u)] = material.value[177];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 3u)] = material.value[178];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 4u)] = material.value[179];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 5u)] = material.value[180];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 6u)] = material.value[181];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 7u)] = material.value[182];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 8u)] = material.value[183];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 9u)] = material.value[184];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 10u)] = material.value[185];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 11u)] = material.value[186];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 12u)] = material.value[187];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 13u)] = material.value[188];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 14u)] = material.value[189];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 15u)] = material.value[190];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 16u)] = material.value[191];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 17u)] = material.value[192];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 18u)] = material.value[193];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 19u)] = material.value[194];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 20u)] = material.value[195];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 21u)] = material.value[196];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 22u)] = material.value[197];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 23u)] = material.value[198];
    D.data[((uint(0) + 7u) * uint(25)) + (uint(0) + 24u)] = material.value[199];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 0u)] = material.value[200];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 1u)] = material.value[201];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 2u)] = material.value[202];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 3u)] = material.value[203];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 4u)] = material.value[204];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 5u)] = material.value[205];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 6u)] = material.value[206];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 7u)] = material.value[207];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 8u)] = material.value[208];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 9u)] = material.value[209];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 10u)] = material.value[210];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 11u)] = material.value[211];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 12u)] = material.value[212];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 13u)] = material.value[213];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 14u)] = material.value[214];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 15u)] = material.value[215];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 16u)] = material.value[216];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 17u)] = material.value[217];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 18u)] = material.value[218];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 19u)] = material.value[219];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 20u)] = material.value[220];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 21u)] = material.value[221];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 22u)] = material.value[222];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 23u)] = material.value[223];
    D.data[((uint(0) + 8u) * uint(25)) + (uint(0) + 24u)] = material.value[224];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 0u)] = material.value[225];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 1u)] = material.value[226];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 2u)] = material.value[227];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 3u)] = material.value[228];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 4u)] = material.value[229];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 5u)] = material.value[230];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 6u)] = material.value[231];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 7u)] = material.value[232];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 8u)] = material.value[233];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 9u)] = material.value[234];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 10u)] = material.value[235];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 11u)] = material.value[236];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 12u)] = material.value[237];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 13u)] = material.value[238];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 14u)] = material.value[239];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 15u)] = material.value[240];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 16u)] = material.value[241];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 17u)] = material.value[242];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 18u)] = material.value[243];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 19u)] = material.value[244];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 20u)] = material.value[245];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 21u)] = material.value[246];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 22u)] = material.value[247];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 23u)] = material.value[248];
    D.data[((uint(0) + 9u) * uint(25)) + (uint(0) + 24u)] = material.value[249];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 0u)] = material.value[250];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 1u)] = material.value[251];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 2u)] = material.value[252];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 3u)] = material.value[253];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 4u)] = material.value[254];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 5u)] = material.value[255];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 6u)] = material.value[256];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 7u)] = material.value[257];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 8u)] = material.value[258];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 9u)] = material.value[259];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 10u)] = material.value[260];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 11u)] = material.value[261];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 12u)] = material.value[262];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 13u)] = material.value[263];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 14u)] = material.value[264];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 15u)] = material.value[265];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 16u)] = material.value[266];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 17u)] = material.value[267];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 18u)] = material.value[268];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 19u)] = material.value[269];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 20u)] = material.value[270];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 21u)] = material.value[271];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 22u)] = material.value[272];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 23u)] = material.value[273];
    D.data[((uint(0) + 10u) * uint(25)) + (uint(0) + 24u)] = material.value[274];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 0u)] = material.value[275];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 1u)] = material.value[276];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 2u)] = material.value[277];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 3u)] = material.value[278];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 4u)] = material.value[279];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 5u)] = material.value[280];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 6u)] = material.value[281];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 7u)] = material.value[282];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 8u)] = material.value[283];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 9u)] = material.value[284];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 10u)] = material.value[285];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 11u)] = material.value[286];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 12u)] = material.value[287];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 13u)] = material.value[288];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 14u)] = material.value[289];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 15u)] = material.value[290];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 16u)] = material.value[291];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 17u)] = material.value[292];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 18u)] = material.value[293];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 19u)] = material.value[294];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 20u)] = material.value[295];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 21u)] = material.value[296];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 22u)] = material.value[297];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 23u)] = material.value[298];
    D.data[((uint(0) + 11u) * uint(25)) + (uint(0) + 24u)] = material.value[299];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 0u)] = material.value[300];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 1u)] = material.value[301];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 2u)] = material.value[302];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 3u)] = material.value[303];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 4u)] = material.value[304];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 5u)] = material.value[305];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 6u)] = material.value[306];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 7u)] = material.value[307];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 8u)] = material.value[308];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 9u)] = material.value[309];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 10u)] = material.value[310];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 11u)] = material.value[311];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 12u)] = material.value[312];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 13u)] = material.value[313];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 14u)] = material.value[314];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 15u)] = material.value[315];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 16u)] = material.value[316];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 17u)] = material.value[317];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 18u)] = material.value[318];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 19u)] = material.value[319];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 20u)] = material.value[320];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 21u)] = material.value[321];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 22u)] = material.value[322];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 23u)] = material.value[323];
    D.data[((uint(0) + 12u) * uint(25)) + (uint(0) + 24u)] = material.value[324];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 0u)] = material.value[325];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 1u)] = material.value[326];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 2u)] = material.value[327];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 3u)] = material.value[328];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 4u)] = material.value[329];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 5u)] = material.value[330];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 6u)] = material.value[331];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 7u)] = material.value[332];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 8u)] = material.value[333];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 9u)] = material.value[334];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 10u)] = material.value[335];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 11u)] = material.value[336];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 12u)] = material.value[337];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 13u)] = material.value[338];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 14u)] = material.value[339];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 15u)] = material.value[340];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 16u)] = material.value[341];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 17u)] = material.value[342];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 18u)] = material.value[343];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 19u)] = material.value[344];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 20u)] = material.value[345];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 21u)] = material.value[346];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 22u)] = material.value[347];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 23u)] = material.value[348];
    D.data[((uint(0) + 13u) * uint(25)) + (uint(0) + 24u)] = material.value[349];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 0u)] = material.value[350];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 1u)] = material.value[351];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 2u)] = material.value[352];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 3u)] = material.value[353];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 4u)] = material.value[354];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 5u)] = material.value[355];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 6u)] = material.value[356];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 7u)] = material.value[357];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 8u)] = material.value[358];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 9u)] = material.value[359];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 10u)] = material.value[360];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 11u)] = material.value[361];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 12u)] = material.value[362];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 13u)] = material.value[363];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 14u)] = material.value[364];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 15u)] = material.value[365];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 16u)] = material.value[366];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 17u)] = material.value[367];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 18u)] = material.value[368];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 19u)] = material.value[369];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 20u)] = material.value[370];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 21u)] = material.value[371];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 22u)] = material.value[372];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 23u)] = material.value[373];
    D.data[((uint(0) + 14u) * uint(25)) + (uint(0) + 24u)] = material.value[374];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 0u)] = material.value[375];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 1u)] = material.value[376];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 2u)] = material.value[377];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 3u)] = material.value[378];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 4u)] = material.value[379];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 5u)] = material.value[380];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 6u)] = material.value[381];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 7u)] = material.value[382];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 8u)] = material.value[383];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 9u)] = material.value[384];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 10u)] = material.value[385];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 11u)] = material.value[386];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 12u)] = material.value[387];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 13u)] = material.value[388];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 14u)] = material.value[389];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 15u)] = material.value[390];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 16u)] = material.value[391];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 17u)] = material.value[392];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 18u)] = material.value[393];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 19u)] = material.value[394];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 20u)] = material.value[395];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 21u)] = material.value[396];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 22u)] = material.value[397];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 23u)] = material.value[398];
    D.data[((uint(0) + 15u) * uint(25)) + (uint(0) + 24u)] = material.value[399];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 0u)] = material.value[400];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 1u)] = material.value[401];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 2u)] = material.value[402];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 3u)] = material.value[403];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 4u)] = material.value[404];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 5u)] = material.value[405];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 6u)] = material.value[406];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 7u)] = material.value[407];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 8u)] = material.value[408];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 9u)] = material.value[409];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 10u)] = material.value[410];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 11u)] = material.value[411];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 12u)] = material.value[412];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 13u)] = material.value[413];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 14u)] = material.value[414];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 15u)] = material.value[415];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 16u)] = material.value[416];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 17u)] = material.value[417];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 18u)] = material.value[418];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 19u)] = material.value[419];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 20u)] = material.value[420];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 21u)] = material.value[421];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 22u)] = material.value[422];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 23u)] = material.value[423];
    D.data[((uint(0) + 16u) * uint(25)) + (uint(0) + 24u)] = material.value[424];
}

void main()
{
    uint materialKey = readMaterialKey();
    uint param = materialKey;
    MaterialRoute route = decodeMaterialRoute(param);
    MaterialMatrix _365 = loadMaterialSurface();
    MaterialMatrix surface = _365;
    MaterialMatrix param_1 = _365;
    MaterialRoute param_2 = route;
    MaterialPacket _371 = createMaterialPacket(param_1, param_2);
    MaterialPacket packet = _371;
    MaterialPacket param_3 = _371;
    MaterialRoute param_4 = route;
    MaterialPacket _377 = applyMaterialOverrides(param_3, param_4);
    MaterialPacket resolvedPacket = _377;
    MaterialPacket param_5 = _377;
    MaterialRoute param_6 = route;
    MaterialMatrix _383 = resolveMaterialPayload(param_5, param_6);
    MaterialMatrix resolved = _383;
    MaterialMatrix param_7 = _383;
    storeMaterialPayload(param_7);
}

