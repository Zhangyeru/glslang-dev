#version 450
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

struct MatrixAValue
{
    vec2 value[1536];
};

struct MatrixAChannel
{
    MatrixAValue resident;
};

struct MatrixBValue
{
    vec2 value[1024];
};

struct MatrixBChannel
{
    MatrixBValue resident;
};

struct MatrixCValue
{
    vec2 value[768];
};

struct MatrixCChannel
{
    MatrixCValue resident;
};

struct RouteState
{
    uint index;
    bool dimensionsValid;
};

struct DispatchMetadata
{
    RouteState route;
};

struct MatrixDValue
{
    vec2 value[768];
};

struct MatrixDChannel
{
    MatrixDValue resident;
};

struct MatmulResponse
{
    MatrixDChannel outputTile;
    uint route;
    bool complete;
};

const ivec2 _106[3] = ivec2[](ivec2(48, 64), ivec2(64, 32), ivec2(48, 32));

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

uint selectExecutionRoute()
{
    uint route = ((gl_WorkGroupID.x ^ gl_WorkGroupID.y) ^ gl_WorkGroupID.z) & 1u;
    switch (route)
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

vec2 _681(uint _682)
{
    return vec2(A.data[_682], A.data[_682 + 1u]);
}

MatrixAChannel acquireLeftOperand()
{
    uint _694 = 0u;
    vec2 _693[1536];
    uint _699;
    for (;;)
    {
        _699 = _694;
        if (_699 < 3072u)
        {
            _693[_699 / 2u] = _681(((uint(0) + (_699 / 64u)) * uint(64)) + (uint(0) + (_699 % 64u)));
            _694 = _699 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _151[1536] = _693;
    vec2 tempArg[1536] = _151;
    vec2 lhs[1536] = _151;
    MatrixAChannel channel;
    channel.resident.value = _151;
    return channel;
}

vec2 _718(uint _719)
{
    return vec2(B.data[_719], B.data[_719 + 1u]);
}

MatrixBChannel acquireRightOperand()
{
    uint _730 = 0u;
    vec2 _729[1024];
    uint _735;
    for (;;)
    {
        _735 = _730;
        if (_735 < 2048u)
        {
            _729[_735 / 2u] = _718(((uint(0) + (_735 / 32u)) * uint(32)) + (uint(0) + (_735 % 32u)));
            _730 = _735 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _169[1024] = _729;
    vec2 tempArg[1024] = _169;
    vec2 rhs[1024] = _169;
    vec2 _174[1024] = _169;
    MatrixBChannel channel;
    channel.resident.value = _174;
    return channel;
}

vec2 _754(uint _755)
{
    return vec2(C.data[_755], C.data[_755 + 1u]);
}

MatrixCChannel acquireAccumulator()
{
    uint _765 = 0u;
    vec2 _764[768];
    uint _770;
    for (;;)
    {
        _770 = _765;
        if (_770 < 1536u)
        {
            _764[_770 / 2u] = _754(((uint(0) + (_770 / 32u)) * uint(32)) + (uint(0) + (_770 % 32u)));
            _765 = _770 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec2 _188[768] = _764;
    vec2 tempArg[768] = _188;
    vec2 accumulator[768] = _188;
    vec2 _193[768] = _188;
    MatrixCChannel channel;
    channel.resident.value = _193;
    return channel;
}

bool validateMatrixContract()
{
    bool valid = true;
    for (uint index = 0u; index < 3u; index++)
    {
        bool _130;
        if (valid)
        {
            _130 = all(greaterThan(_106[index], ivec2(0)));
        }
        else
        {
            _130 = valid;
        }
        valid = _130;
    }
    valid = valid && true;
    valid = valid && true;
    valid = valid && true;
    return valid;
}

DispatchMetadata buildDispatchMetadata(uint route)
{
    DispatchMetadata metadata;
    metadata.route.index = route;
    metadata.route.dimensionsValid = validateMatrixContract();
    if (!metadata.route.dimensionsValid)
    {
        metadata.route.index = 0u;
        return metadata;
    }
    switch (metadata.route.index)
    {
        case 0u:
        {
            metadata.route.index = 0u;
            break;
        }
        case 1u:
        {
            metadata.route.index = 1u;
            break;
        }
        default:
        {
            metadata.route.index = 0u;
            break;
        }
    }
    return metadata;
}

vec2[768] _331(vec2 _332[1536], vec2 _333[1024], vec2 _334[768])
{
    vec2 _364[1536] = _332;
    vec2 _365[1024] = _333;
    vec2 _366[768] = _334;
    vec2 _353[768] = vec2[](vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0), vec2(0.0));
    uint _354 = 0u;
    uint _367;
    for (;;)
    {
        _367 = _354;
        if (_367 < 96u)
        {
            uint _369 = _367 / 2u;
            uint _371 = (_367 % 2u) * 16u;
            uint _372 = _369 * 32u;
            uint _374 = _372 + _371;
            uint _375 = _374 + 1u;
            vec2 _356 = vec2(_366[_374 / 2u][_374 % 2u], _366[_375 / 2u][_375 % 2u]);
            uint _387 = _371 + 2u;
            uint _389 = _372 + _387;
            uint _390 = _389 + 1u;
            vec2 _357 = vec2(_366[_389 / 2u][_389 % 2u], _366[_390 / 2u][_390 % 2u]);
            uint _403 = _371 + 4u;
            uint _405 = _372 + _403;
            uint _406 = _405 + 1u;
            vec2 _358 = vec2(_366[_405 / 2u][_405 % 2u], _366[_406 / 2u][_406 % 2u]);
            uint _419 = _371 + 6u;
            uint _421 = _372 + _419;
            uint _422 = _421 + 1u;
            vec2 _359 = vec2(_366[_421 / 2u][_421 % 2u], _366[_422 / 2u][_422 % 2u]);
            uint _435 = _371 + 8u;
            uint _437 = _372 + _435;
            uint _438 = _437 + 1u;
            vec2 _360 = vec2(_366[_437 / 2u][_437 % 2u], _366[_438 / 2u][_438 % 2u]);
            uint _451 = _371 + 10u;
            uint _453 = _372 + _451;
            uint _454 = _453 + 1u;
            vec2 _361 = vec2(_366[_453 / 2u][_453 % 2u], _366[_454 / 2u][_454 % 2u]);
            uint _467 = _371 + 12u;
            uint _469 = _372 + _467;
            uint _470 = _469 + 1u;
            vec2 _362 = vec2(_366[_469 / 2u][_469 % 2u], _366[_470 / 2u][_470 % 2u]);
            uint _483 = _371 + 14u;
            uint _485 = _372 + _483;
            uint _486 = _485 + 1u;
            vec2 _363 = vec2(_366[_485 / 2u][_485 % 2u], _366[_486 / 2u][_486 % 2u]);
            uint _355 = 0u;
            uint _498;
            for (;;)
            {
                _498 = _355;
                if (_498 < 64u)
                {
                    uint _501 = (_369 * 64u) + _498;
                    vec2 _507 = vec2(_364[_501 / 2u][_501 % 2u]);
                    uint _508 = _498 * 32u;
                    uint _510 = _508 + _371;
                    uint _511 = _510 + 1u;
                    _356 = fma(_507, vec2(_365[_510 / 2u][_510 % 2u], _365[_511 / 2u][_511 % 2u]), _356);
                    uint _525 = _371 + 2u;
                    uint _527 = _508 + _525;
                    uint _528 = _527 + 1u;
                    _357 = fma(_507, vec2(_365[_527 / 2u][_527 % 2u], _365[_528 / 2u][_528 % 2u]), _357);
                    uint _542 = _371 + 4u;
                    uint _544 = _508 + _542;
                    uint _545 = _544 + 1u;
                    _358 = fma(_507, vec2(_365[_544 / 2u][_544 % 2u], _365[_545 / 2u][_545 % 2u]), _358);
                    uint _559 = _371 + 6u;
                    uint _561 = _508 + _559;
                    uint _562 = _561 + 1u;
                    _359 = fma(_507, vec2(_365[_561 / 2u][_561 % 2u], _365[_562 / 2u][_562 % 2u]), _359);
                    uint _576 = _371 + 8u;
                    uint _578 = _508 + _576;
                    uint _579 = _578 + 1u;
                    _360 = fma(_507, vec2(_365[_578 / 2u][_578 % 2u], _365[_579 / 2u][_579 % 2u]), _360);
                    uint _593 = _371 + 10u;
                    uint _595 = _508 + _593;
                    uint _596 = _595 + 1u;
                    _361 = fma(_507, vec2(_365[_595 / 2u][_595 % 2u], _365[_596 / 2u][_596 % 2u]), _361);
                    uint _610 = _371 + 12u;
                    uint _612 = _508 + _610;
                    uint _613 = _612 + 1u;
                    _362 = fma(_507, vec2(_365[_612 / 2u][_612 % 2u], _365[_613 / 2u][_613 % 2u]), _362);
                    uint _627 = _371 + 14u;
                    uint _629 = _508 + _627;
                    uint _630 = _629 + 1u;
                    _363 = fma(_507, vec2(_365[_629 / 2u][_629 % 2u], _365[_630 / 2u][_630 % 2u]), _363);
                    _355 = _498 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _353[_367 * 8u] = _356;
            _353[(_367 * 8u) + 1u] = _357;
            _353[(_367 * 8u) + 2u] = _358;
            _353[(_367 * 8u) + 3u] = _359;
            _353[(_367 * 8u) + 4u] = _360;
            _353[(_367 * 8u) + 5u] = _361;
            _353[(_367 * 8u) + 6u] = _362;
            _353[(_367 * 8u) + 7u] = _363;
            _354 = _367 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _353;
}

MatmulResponse executeMatmul(MatrixAChannel lhs, MatrixBChannel rhs, MatrixCChannel accumulator, DispatchMetadata metadata)
{
    vec2 _235[768] = _331(lhs.resident.value, rhs.resident.value, accumulator.resident.value);
    vec2 tempArg[768] = _235;
    vec2 _239[768] = _235;
    MatrixDValue computed;
    computed.value = _239;
    MatmulResponse response;
    response.outputTile.resident = computed;
    response.route = metadata.route.index;
    response.complete = metadata.route.dimensionsValid;
    return response;
}

MatmulResponse finalizeResponse(inout MatmulResponse response)
{
    if (response.complete)
    {
        response.complete = true;
    }
    else
    {
        response.complete = false;
    }
    switch (response.route)
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
            response.route = 0u;
            return response;
        }
    }
}

void _790(uint _791, vec2 _792)
{
    D.data[_791] = _792.x;
    D.data[_791 + 1u] = _792.y;
}

void _825(uint _826, vec2 _827)
{
    D.data[_826] = _827.x;
    D.data[_826 + 1u] = _827.y;
}

void commitResponse(MatmulResponse response)
{
    if (response.complete)
    {
        vec2 _800[768] = response.outputTile.resident.value;
        uint _801 = 0u;
        uint _806;
        for (;;)
        {
            _806 = _801;
            if (_806 < 1536u)
            {
                _790(((uint(0) + (_806 / 32u)) * uint(32)) + (uint(0) + (_806 % 32u)), _800[_806 / 2u]);
                _801 = _806 + 2u;
                continue;
            }
            else
            {
                break;
            }
        }
        return;
    }
    vec2 _835[768] = response.outputTile.resident.value;
    uint _836 = 0u;
    uint _841;
    for (;;)
    {
        _841 = _836;
        if (_841 < 1536u)
        {
            _825(((uint(0) + (_841 / 32u)) * uint(32)) + (uint(0) + (_841 % 32u)), _835[_841 / 2u]);
            _836 = _841 + 2u;
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
    uint route = selectExecutionRoute();
    MatrixAChannel _296 = acquireLeftOperand();
    MatrixAChannel lhs = _296;
    MatrixBChannel _298 = acquireRightOperand();
    MatrixBChannel rhs = _298;
    MatrixCChannel _300 = acquireAccumulator();
    MatrixCChannel accumulator = _300;
    uint param = route;
    DispatchMetadata metadata = buildDispatchMetadata(param);
    MatrixAChannel param_1 = _296;
    MatrixBChannel param_2 = _298;
    MatrixCChannel param_3 = _300;
    DispatchMetadata param_4 = metadata;
    MatmulResponse _314 = executeMatmul(param_1, param_2, param_3, param_4);
    MatmulResponse computed = _314;
    MatmulResponse param_5 = _314;
    MatmulResponse _318 = finalizeResponse(param_5);
    MatmulResponse finalized = _318;
    MatmulResponse param_6 = _318;
    commitResponse(param_6);
}

