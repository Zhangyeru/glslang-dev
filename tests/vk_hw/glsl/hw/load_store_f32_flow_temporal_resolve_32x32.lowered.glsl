#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct FrameRoute
{
    uint historyIndex;
    uint slotIndex;
    uint candidateIndex;
    uint frameNumber;
};

struct HistoryMatrix
{
    vec2 value[512];
};

struct HistorySample
{
    uvec4 candidateState[2];
    uvec4 frameState;
};

struct TemporalHistory
{
    HistorySample slots[2];
};

struct TemporalResolveQueue
{
    TemporalHistory histories[2];
    HistoryMatrix currentFrame;
    vec4 blendState;
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

uint readFrameKey()
{
    uint motionKey = floatBitsToUint(B.data[0]);
    uint exposureKey = floatBitsToUint(C.data[0]);
    uint dispatchKey = gl_GlobalInvocationID.x + gl_GlobalInvocationID.y;
    return (motionKey ^ (exposureKey << 1u)) ^ dispatchKey;
}

FrameRoute decodeFrameRoute(uint frameKey)
{
    FrameRoute route;
    route.historyIndex = frameKey & 1u;
    route.slotIndex = (frameKey >> 1u) & 1u;
    route.candidateIndex = (frameKey >> 2u) & 1u;
    route.frameNumber = frameKey >> 3u;
    return route;
}

vec2 _374(uint _375)
{
    return vec2(A.data[_375], A.data[_375 + 1u]);
}

HistoryMatrix loadCurrentFrame()
{
    uint _388 = 0u;
    vec2 _387[512];
    uint _393;
    for (;;)
    {
        _393 = _388;
        if (_393 < 1024u)
        {
            _387[_393 / 2u] = _374(((uint(0) + (_393 / 32u)) * uint(32)) + (uint(0) + (_393 % 32u)));
            _388 = _393 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _137[512] = _387;
    vec2 tempArg[512] = _137;
    vec2 currentFrame[512] = _137;
    HistoryMatrix result;
    result.value = _137;
    return result;
}

TemporalResolveQueue seedTemporalHistory(HistoryMatrix currentFrame, FrameRoute route)
{
    TemporalResolveQueue queue;
    queue.currentFrame = currentFrame;
    queue.blendState = vec4(B.data[1], C.data[1], float(route.frameNumber), 1.0);
    for (int historyIndex = 0; historyIndex < 2; historyIndex++)
    {
        for (int slotIndex = 0; slotIndex < 2; slotIndex++)
        {
            queue.histories[historyIndex].slots[slotIndex].frameState = uvec4(route.frameNumber, uint(historyIndex), uint(slotIndex), 1u);
            for (int candidateIndex = 0; candidateIndex < 2; candidateIndex++)
            {
                queue.histories[historyIndex].slots[slotIndex].candidateState[candidateIndex] = uvec4(uint(candidateIndex), route.frameNumber, 0u, 1u);
            }
        }
    }
    return queue;
}

TemporalResolveQueue rotateTemporalHistory(inout TemporalResolveQueue queue, FrameRoute route)
{
    HistoryMatrix carried = queue.currentFrame;
    for (uint frameDelta = 0u; frameDelta < 3u; frameDelta++)
    {
        uint historyIndex = (route.historyIndex + frameDelta) & 1u;
        HistoryMatrix previous = queue.currentFrame;
        bool acceptPrevious = ((route.frameNumber + frameDelta) & 1u) != 0u;
        carried = acceptPrevious ? queue.currentFrame : carried;
    }
    queue.currentFrame = carried;
    queue.histories[route.historyIndex].slots[route.slotIndex].frameState.x++;
    return queue;
}

HistoryMatrix chooseTemporalCandidate(TemporalResolveQueue queue, FrameRoute route)
{
    uint selector = (route.slotIndex << 1u) | route.candidateIndex;
    HistoryMatrix candidate;
    switch (selector)
    {
        case 0u:
        {
            candidate = queue.currentFrame;
            break;
        }
        case 1u:
        {
            candidate = queue.currentFrame;
            break;
        }
        case 2u:
        {
            candidate = queue.currentFrame;
            break;
        }
        default:
        {
            candidate = queue.currentFrame;
            break;
        }
    }
    return candidate;
}

bool historyIsUsable(TemporalResolveQueue queue, FrameRoute route)
{
    uvec4 state = queue.histories[route.historyIndex].slots[route.slotIndex].frameState;
    bool populated = state.w != 0u;
    bool hasBlendState = queue.blendState.w > 0.0;
    return populated && hasBlendState;
}

HistoryMatrix resolveTemporalFrame(TemporalResolveQueue queue, FrameRoute route)
{
    TemporalResolveQueue param = queue;
    FrameRoute param_1 = route;
    HistoryMatrix candidate = chooseTemporalCandidate(param, param_1);
    TemporalResolveQueue param_2 = queue;
    FrameRoute param_3 = route;
    if (historyIsUsable(param_2, param_3))
    {
        return candidate;
    }
    return queue.currentFrame;
}

void _413(uint _414, vec2 _415)
{
    D.data[_414] = _415.x;
    D.data[_414 + 1u] = _415.y;
}

void storeResolvedFrame(HistoryMatrix resolvedFrame)
{
    vec2 _423[512] = resolvedFrame.value;
    uint _424 = 0u;
    uint _429;
    for (;;)
    {
        _429 = _424;
        if (_429 < 1024u)
        {
            _413(((uint(0) + (_429 / 32u)) * uint(32)) + (uint(0) + (_429 % 32u)), _423[_429 / 2u]);
            _424 = _429 + 2u;
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
    uint frameKey = readFrameKey();
    uint param = frameKey;
    FrameRoute route = decodeFrameRoute(param);
    HistoryMatrix _347 = loadCurrentFrame();
    HistoryMatrix currentFrame = _347;
    HistoryMatrix param_1 = _347;
    FrameRoute param_2 = route;
    TemporalResolveQueue _353 = seedTemporalHistory(param_1, param_2);
    TemporalResolveQueue queue = _353;
    TemporalResolveQueue param_3 = _353;
    FrameRoute param_4 = route;
    TemporalResolveQueue _359 = rotateTemporalHistory(param_3, param_4);
    TemporalResolveQueue rotatedQueue = _359;
    TemporalResolveQueue param_5 = _359;
    FrameRoute param_6 = route;
    HistoryMatrix _365 = resolveTemporalFrame(param_5, param_6);
    HistoryMatrix resolvedFrame = _365;
    HistoryMatrix param_7 = _365;
    storeResolvedFrame(param_7);
}

