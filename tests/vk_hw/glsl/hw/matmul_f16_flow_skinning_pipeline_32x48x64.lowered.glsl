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

struct SkinningLeftTile
{
    f16vec2 value[1024];
    uvec4 residency;
};

struct SkinningRightTile
{
    f16vec2 value[1536];
    uvec4 residency;
};

struct SkinningAccumulatorTile
{
    f16vec2 value[768];
    uvec4 revision;
};

struct SkinningRequestLane
{
    SkinningLeftTile left;
    SkinningRightTile right;
    uvec4 scheduling;
};

struct SkinningDispatchRequest
{
    SkinningRequestLane lanes[2];
    SkinningAccumulatorTile accumulator;
    uint selectedLane;
    bool contractValid;
};

struct SkinningResultTile
{
    f16vec2 value[768];
    uvec4 completion;
};

struct SkinningResponse
{
    SkinningResultTile result;
    uint selectedLane;
    bool committed;
};

const ivec2 _109[3] = ivec2[](ivec2(32, 64), ivec2(64, 48), ivec2(32, 48));

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

uint selectSkinningLane()
{
    uint workgroupKey = gl_WorkGroupID.x ^ (gl_WorkGroupID.y << 1u);
    uint invocationKey = gl_LocalInvocationIndex + gl_GlobalInvocationID.x;
    return (workgroupKey ^ invocationKey) & 1u;
}

f16vec2 _775(uint _776)
{
    return f16vec2(A.data[_776], A.data[_776 + 1u]);
}

f16vec2 _812(uint _813)
{
    return f16vec2(B.data[_813], B.data[_813 + 1u]);
}

f16vec2 _848(uint _849)
{
    return f16vec2(C.data[_849], C.data[_849 + 1u]);
}

SkinningLeftTile registerSkinningLeftTile(inout SkinningLeftTile tile)
{
    tile.residency = uvec4(32u, 64u, 0u, 1u);
    return tile;
}

SkinningRightTile registerSkinningRightTile(inout SkinningRightTile tile)
{
    tile.residency = uvec4(64u, 48u, 1u, 1u);
    return tile;
}

SkinningAccumulatorTile registerSkinningAccumulatorTile(inout SkinningAccumulatorTile tile)
{
    tile.revision = uvec4(32u, 48u, 2u, 1u);
    return tile;
}

bool validateSkinningContract()
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

SkinningDispatchRequest buildSkinningRequest(SkinningLeftTile left, SkinningRightTile right, SkinningAccumulatorTile accumulator, uint selectedLane)
{
    SkinningDispatchRequest request;
    request.accumulator = accumulator;
    request.selectedLane = selectedLane;
    request.contractValid = validateSkinningContract();
    for (uint lane = 0u; lane < 2u; lane++)
    {
        request.lanes[lane].left = left;
        request.lanes[lane].right = right;
        request.lanes[lane].scheduling = uvec4(lane, selectedLane, uint(lane == selectedLane), 1u);
    }
    return request;
}

SkinningDispatchRequest normalizeSkinningRequest(inout SkinningDispatchRequest request)
{
    uint selectedLane = request.selectedLane & 1u;
    SkinningRequestLane residentLane = request.lanes[selectedLane];
    for (uint probe = 0u; probe < 3u; probe++)
    {
        uint candidateIndex = (selectedLane + probe) & 1u;
        SkinningRequestLane candidate = request.lanes[candidateIndex];
        bool _231 = candidate.left.residency.w != 0u;
        bool _237;
        if (_231)
        {
            _237 = candidate.right.residency.w != 0u;
        }
        else
        {
            _237 = _231;
        }
        bool candidateReady = _237;
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

f16vec2[768] _425(f16vec2 _426[1024], f16vec2 _427[1536], f16vec2 _428[768])
{
    f16vec2 _458[1024] = _426;
    f16vec2 _459[1536] = _427;
    f16vec2 _460[768] = _428;
    f16vec2 _447[768] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
    uint _448 = 0u;
    uint _461;
    for (;;)
    {
        _461 = _448;
        if (_461 < 96u)
        {
            uint _463 = _461 / 3u;
            uint _465 = (_461 % 3u) * 16u;
            uint _466 = _463 * 48u;
            uint _468 = _466 + _465;
            uint _469 = _468 + 1u;
            f16vec2 _450 = f16vec2(_460[_468 / 2u][_468 % 2u], _460[_469 / 2u][_469 % 2u]);
            uint _481 = _465 + 2u;
            uint _483 = _466 + _481;
            uint _484 = _483 + 1u;
            f16vec2 _451 = f16vec2(_460[_483 / 2u][_483 % 2u], _460[_484 / 2u][_484 % 2u]);
            uint _497 = _465 + 4u;
            uint _499 = _466 + _497;
            uint _500 = _499 + 1u;
            f16vec2 _452 = f16vec2(_460[_499 / 2u][_499 % 2u], _460[_500 / 2u][_500 % 2u]);
            uint _513 = _465 + 6u;
            uint _515 = _466 + _513;
            uint _516 = _515 + 1u;
            f16vec2 _453 = f16vec2(_460[_515 / 2u][_515 % 2u], _460[_516 / 2u][_516 % 2u]);
            uint _529 = _465 + 8u;
            uint _531 = _466 + _529;
            uint _532 = _531 + 1u;
            f16vec2 _454 = f16vec2(_460[_531 / 2u][_531 % 2u], _460[_532 / 2u][_532 % 2u]);
            uint _545 = _465 + 10u;
            uint _547 = _466 + _545;
            uint _548 = _547 + 1u;
            f16vec2 _455 = f16vec2(_460[_547 / 2u][_547 % 2u], _460[_548 / 2u][_548 % 2u]);
            uint _561 = _465 + 12u;
            uint _563 = _466 + _561;
            uint _564 = _563 + 1u;
            f16vec2 _456 = f16vec2(_460[_563 / 2u][_563 % 2u], _460[_564 / 2u][_564 % 2u]);
            uint _577 = _465 + 14u;
            uint _579 = _466 + _577;
            uint _580 = _579 + 1u;
            f16vec2 _457 = f16vec2(_460[_579 / 2u][_579 % 2u], _460[_580 / 2u][_580 % 2u]);
            uint _449 = 0u;
            uint _592;
            for (;;)
            {
                _592 = _449;
                if (_592 < 64u)
                {
                    uint _595 = (_463 * 64u) + _592;
                    f16vec2 _601 = f16vec2(_458[_595 / 2u][_595 % 2u]);
                    uint _602 = _592 * 48u;
                    uint _604 = _602 + _465;
                    uint _605 = _604 + 1u;
                    _450 = fma(_601, f16vec2(_459[_604 / 2u][_604 % 2u], _459[_605 / 2u][_605 % 2u]), _450);
                    uint _619 = _465 + 2u;
                    uint _621 = _602 + _619;
                    uint _622 = _621 + 1u;
                    _451 = fma(_601, f16vec2(_459[_621 / 2u][_621 % 2u], _459[_622 / 2u][_622 % 2u]), _451);
                    uint _636 = _465 + 4u;
                    uint _638 = _602 + _636;
                    uint _639 = _638 + 1u;
                    _452 = fma(_601, f16vec2(_459[_638 / 2u][_638 % 2u], _459[_639 / 2u][_639 % 2u]), _452);
                    uint _653 = _465 + 6u;
                    uint _655 = _602 + _653;
                    uint _656 = _655 + 1u;
                    _453 = fma(_601, f16vec2(_459[_655 / 2u][_655 % 2u], _459[_656 / 2u][_656 % 2u]), _453);
                    uint _670 = _465 + 8u;
                    uint _672 = _602 + _670;
                    uint _673 = _672 + 1u;
                    _454 = fma(_601, f16vec2(_459[_672 / 2u][_672 % 2u], _459[_673 / 2u][_673 % 2u]), _454);
                    uint _687 = _465 + 10u;
                    uint _689 = _602 + _687;
                    uint _690 = _689 + 1u;
                    _455 = fma(_601, f16vec2(_459[_689 / 2u][_689 % 2u], _459[_690 / 2u][_690 % 2u]), _455);
                    uint _704 = _465 + 12u;
                    uint _706 = _602 + _704;
                    uint _707 = _706 + 1u;
                    _456 = fma(_601, f16vec2(_459[_706 / 2u][_706 % 2u], _459[_707 / 2u][_707 % 2u]), _456);
                    uint _721 = _465 + 14u;
                    uint _723 = _602 + _721;
                    uint _724 = _723 + 1u;
                    _457 = fma(_601, f16vec2(_459[_723 / 2u][_723 % 2u], _459[_724 / 2u][_724 % 2u]), _457);
                    _449 = _592 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _447[_461 * 8u] = _450;
            _447[(_461 * 8u) + 1u] = _451;
            _447[(_461 * 8u) + 2u] = _452;
            _447[(_461 * 8u) + 3u] = _453;
            _447[(_461 * 8u) + 4u] = _454;
            _447[(_461 * 8u) + 5u] = _455;
            _447[(_461 * 8u) + 6u] = _456;
            _447[(_461 * 8u) + 7u] = _457;
            _448 = _461 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _447;
}

SkinningResponse executeSkinningRequest(SkinningDispatchRequest request)
{
    uint laneIndex = request.selectedLane & 1u;
    SkinningRequestLane lane = request.lanes[laneIndex];
    f16vec2 _284[1536] = lane.right.value;
    f16vec2 _285[768] = request.accumulator.value;
    f16vec2 _286[768] = _425(lane.left.value, _284, _285);
    f16vec2 tempArg[768] = _286;
    f16vec2 _289[768] = _286;
    SkinningResponse response;
    response.result.value = _289;
    response.result.completion = uvec4(laneIndex, 32u, 48u, 1u);
    response.selectedLane = laneIndex;
    response.committed = request.contractValid;
    return response;
}

SkinningResponse finalizeSkinningResponse(inout SkinningResponse response)
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

SkinningResponse prepareSkinningCommit(inout SkinningResponse response)
{
    if (!response.committed)
    {
        response.committed = true;
    }
    return response;
}

void _884(uint _885, f16vec2 _886)
{
    D.data[_885] = _886.x;
    D.data[_885 + 1u] = _886.y;
}

void main()
{
    uint selectedLane = selectSkinningLane();
    uint _788 = 0u;
    f16vec2 _787[1024];
    uint _793;
    for (;;)
    {
        _793 = _788;
        if (_793 < 2048u)
        {
            _787[_793 / 2u] = _775(((uint(0) + (_793 / 64u)) * uint(64)) + (uint(0) + (_793 % 64u)));
            _788 = _793 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _344[1024] = _787;
    f16vec2 tempArg[1024] = _344;
    SkinningLeftTile loadedLeft;
    loadedLeft.value = _344;
    uint _824 = 0u;
    f16vec2 _823[1536];
    uint _829;
    for (;;)
    {
        _829 = _824;
        if (_829 < 3072u)
        {
            _823[_829 / 2u] = _812(((uint(0) + (_829 / 48u)) * uint(48)) + (uint(0) + (_829 % 48u)));
            _824 = _829 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _355[1536] = _823;
    f16vec2 tempArg_1[1536] = _355;
    SkinningRightTile loadedRight;
    loadedRight.value = _355;
    uint _859 = 0u;
    f16vec2 _858[768];
    uint _864;
    for (;;)
    {
        _864 = _859;
        if (_864 < 1536u)
        {
            _858[_864 / 2u] = _848(((uint(0) + (_864 / 48u)) * uint(48)) + (uint(0) + (_864 % 48u)));
            _859 = _864 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _366[768] = _858;
    f16vec2 tempArg_2[768] = _366;
    SkinningAccumulatorTile loadedAccumulator;
    loadedAccumulator.value = _366;
    SkinningLeftTile param = loadedLeft;
    SkinningLeftTile _373 = registerSkinningLeftTile(param);
    SkinningLeftTile left = _373;
    SkinningRightTile param_1 = loadedRight;
    SkinningRightTile _377 = registerSkinningRightTile(param_1);
    SkinningRightTile right = _377;
    SkinningAccumulatorTile param_2 = loadedAccumulator;
    SkinningAccumulatorTile _381 = registerSkinningAccumulatorTile(param_2);
    SkinningAccumulatorTile accumulator = _381;
    SkinningLeftTile param_3 = _373;
    SkinningRightTile param_4 = _377;
    SkinningAccumulatorTile param_5 = _381;
    uint param_6 = selectedLane;
    SkinningDispatchRequest _391 = buildSkinningRequest(param_3, param_4, param_5, param_6);
    SkinningDispatchRequest request = _391;
    SkinningDispatchRequest param_7 = _391;
    SkinningDispatchRequest _395 = normalizeSkinningRequest(param_7);
    SkinningDispatchRequest normalized = _395;
    SkinningDispatchRequest param_8 = _395;
    SkinningResponse _399 = executeSkinningRequest(param_8);
    SkinningResponse response = _399;
    SkinningResponse param_9 = _399;
    SkinningResponse _403 = finalizeSkinningResponse(param_9);
    SkinningResponse finalResponse = _403;
    SkinningResponse param_10 = _403;
    SkinningResponse _407 = prepareSkinningCommit(param_10);
    SkinningResponse committedResponse = _407;
    f16vec2 _894[768] = committedResponse.result.value;
    uint _895 = 0u;
    uint _900;
    for (;;)
    {
        _900 = _895;
        if (_900 < 1536u)
        {
            _884(((uint(0) + (_900 / 48u)) * uint(48)) + (uint(0) + (_900 % 48u)), _894[_900 / 2u]);
            _895 = _900 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

