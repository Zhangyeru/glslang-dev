#version 460
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
#extension GL_EXT_samplerless_texture_functions : require

layout(constant_id = 1) const uint CORE_MATERIAL_FLAGS = 0u;
const uint _RESERVED_IDENTIFIER_FIXUP_144 = (CORE_MATERIAL_FLAGS & 16384u);
const bool _RESERVED_IDENTIFIER_FIXUP_145 = (_RESERVED_IDENTIFIER_FIXUP_144 == 16384u);
const uint _RESERVED_IDENTIFIER_FIXUP_149 = (CORE_MATERIAL_FLAGS & 32768u);
const bool _RESERVED_IDENTIFIER_FIXUP_150 = (_RESERVED_IDENTIFIER_FIXUP_149 == 32768u);

struct DefaultMaterialSingleMaterialStruct
{
    vec4 factors[15];
    uvec4 indices;
};

struct DefaultMaterialMaterialStruct
{
    DefaultMaterialSingleMaterialStruct material[64];
};

const vec4 _347[16] = vec4[](vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0));
const vec4 _398[4] = vec4[](vec4(0.0), vec4(0.0), vec4(0.0), vec4(0.0));

struct DefaultMaterialSingleUserMaterialStruct
{
    uvec4 userData[16];
};

struct DefaultMaterialUserMaterialStruct
{
    DefaultMaterialSingleUserMaterialStruct material[64];
};

layout(constant_id = 256) const uint CORE_BACKEND_TYPE = 0u;
layout(constant_id = 257) const float CORE_FLIP_NDC = 1.0;
layout(constant_id = 0) const uint CORE_MATERIAL_TYPE = 0u;
layout(constant_id = 2) const uint CORE_LIGHTING_FLAGS = 0u;
layout(constant_id = 3) const uint CORE_POST_PROCESS_FLAGS = 0u;
layout(constant_id = 4) const uint CORE_CAMERA_FLAGS = 0u;

struct DefaultCameraMatrixStruct
{
    mat4 view;
    mat4 proj;
    mat4 viewProj;
    mat4 viewInv;
    mat4 projInv;
    mat4 viewProjInv;
    mat4 viewPrevFrame;
    mat4 projPrevFrame;
    mat4 viewProjPrevFrame;
    mat4 shadowViewProj;
    mat4 shadowViewProjInv;
    vec4 jitter;
    vec4 jitterPrevFrame;
    uvec4 indices;
    uvec4 multiViewIndices;
    vec4 frustumPlanes[6];
    uvec4 counts;
    uvec4 pad0;
    mat4 envProjInv;
    mat4 matPad1;
};

struct DefaultMaterialGeneralDataStruct
{
    uvec4 indices;
    vec4 viewportSizeInvViewportSize;
    vec4 sceneTimingData;
};

struct DefaultMaterialEnvironmentStruct
{
    vec4 indirectSpecularColorFactor;
    vec4 indirectDiffuseColorFactor;
    vec4 envMapColorFactor;
    vec4 values;
    vec4 blendFactor;
    mat4 envRotation;
    uvec4 indices;
    vec4 shIndirectCoefficients[9];
    uvec4 multiEnvIndices;
    vec4 packedSun;
    vec4 packedPhases;
    vec4 groundColor;
    vec4 aerialPerspectiveParams;
    vec4 skySunParams;
    vec4 skySunColor;
    vec4 skyMoonNightParams;
    vec4 skyMoonColor;
    vec4 padding[4];
};

struct DefaultMaterialFogStruct
{
    uvec4 indices;
    vec4 firstLayer;
    vec4 secondLayer;
    vec4 baseFactors;
    vec4 inscatteringColor;
    vec4 envMapFactor;
    vec4 additionalFactor;
};

struct DefaultMaterialSingleLightStruct
{
    vec4 pos;
    vec4 dir;
    vec4 color;
    vec4 spotLightParams;
    vec4 shadowFactors;
    vec4 additionalFactor;
    uvec4 flags;
    uvec4 indices;
};

struct DefaultMaterialLightStruct
{
    uint directionalLightBeginIndex;
    uint directionalLightCount;
    uint pointLightBeginIndex;
    uint pointLightCount;
    uint spotLightBeginIndex;
    uint spotLightCount;
    uint rectLightBeginIndex;
    uint rectLightCount;
    uvec4 clusterSizes;
    vec4 clusterFactors;
    vec4 atlasSizeInvSize;
    vec4 additionalFactors;
    DefaultMaterialSingleLightStruct lights[64];
    float vpcfRadius;
    uint vpcfSampleCount;
    uint paddings0;
    uint paddings1;
};

struct GlobalPostProcessStruct
{
    uvec4 flags;
    vec4 renderTimings;
    vec4 factors[14];
    vec4 userFactors[16];
};

struct DefaultMaterialLightClusterData
{
    uint count;
    uint lightIndices[15];
};

struct DefaultMaterialSingleMeshStruct
{
    mat4 world;
    mat4 normalWorld;
    mat4 prevWorld;
    uvec4 indices;
    uvec4 layers;
    uvec4 customData[2];
};

struct DefaultMaterialMeshStruct
{
    DefaultMaterialSingleMeshStruct mesh[64];
};

struct DefaultMaterialSkinStruct
{
    mat4 jointMatrices[256];
};

struct DefaultMaterialTransformSingleMaterialStruct
{
    uvec4 _packed[15];
    uvec4 indices;
};

struct DefaultMaterialTransformMaterialStruct
{
    DefaultMaterialTransformSingleMaterialStruct material[64];
};

struct DefaultSingleLightProbeStruct
{
    vec4 shCoefficientsData[9];
    vec4 bentNormalAo;
};

struct DefaultLightProbeDataIndexStruct
{
    uint lightProbeDataIndex;
};

layout(set = 1, binding = 2, std140) uniform uMaterialStructData
{
    DefaultMaterialMaterialStruct uMaterialData;
} _RESERVED_IDENTIFIER_FIXUP_131;

layout(set = 3, binding = 0, std430) readonly buffer NeuralNetBuffer
{
    float16_t data[];
} nn_buf;

layout(set = 1, binding = 4, std140) uniform uMaterialUserStructData
{
    DefaultMaterialUserMaterialStruct uMaterialUserData;
} _RESERVED_IDENTIFIER_FIXUP_167;

layout(set = 0, binding = 0, std140) uniform uCameraMatrices
{
    DefaultCameraMatrixStruct uCameras[16];
} _RESERVED_IDENTIFIER_FIXUP_832;

layout(set = 0, binding = 1, std140) uniform uGeneralStructData
{
    DefaultMaterialGeneralDataStruct uGeneralData;
} _RESERVED_IDENTIFIER_FIXUP_836;

layout(set = 0, binding = 2, std140) uniform uEnvironmentStructData
{
    DefaultMaterialEnvironmentStruct uEnvironmentData;
} _RESERVED_IDENTIFIER_FIXUP_843;

layout(set = 0, binding = 3, std140) uniform uFogStructData
{
    DefaultMaterialFogStruct uFogData;
} _RESERVED_IDENTIFIER_FIXUP_847;

layout(set = 0, binding = 4, std140) uniform uLightStructData
{
    DefaultMaterialLightStruct uLightData;
} _RESERVED_IDENTIFIER_FIXUP_853;

layout(set = 0, binding = 5, std140) uniform uPostProcessStructData
{
    GlobalPostProcessStruct uPostProcessData;
} _RESERVED_IDENTIFIER_FIXUP_860;

layout(set = 0, binding = 6, std430) buffer uLightClusterIndexData
{
    DefaultMaterialLightClusterData uLightClusterData[3456];
} _RESERVED_IDENTIFIER_FIXUP_866;

layout(set = 1, binding = 0, std140) uniform uMeshStructData
{
    DefaultMaterialMeshStruct uMeshMatrix;
} _RESERVED_IDENTIFIER_FIXUP_883;

layout(set = 1, binding = 1, std140) uniform uObjectSkinStructData
{
    DefaultMaterialSkinStruct uSkinData;
} _RESERVED_IDENTIFIER_FIXUP_889;

layout(set = 1, binding = 3, std140) uniform uMaterialTransformStructData
{
    DefaultMaterialTransformMaterialStruct uMaterialTransformData;
} _RESERVED_IDENTIFIER_FIXUP_896;

layout(set = 1, binding = 5, std430) buffer uLightProbeStructData
{
    DefaultSingleLightProbeStruct uLightProbeData[];
} _RESERVED_IDENTIFIER_FIXUP_902;

layout(push_constant, std430) uniform uLightingPushConstant
{
    DefaultLightProbeDataIndexStruct uLightProbeDataIndexData;
    uint uViewMatrixIndex;
} _RESERVED_IDENTIFIER_FIXUP_907;

layout(set = 2, binding = 1) uniform mediump sampler2D uSampTextures[10];
layout(set = 0, binding = 7) uniform mediump sampler2D uSampColorPrePass;
layout(set = 0, binding = 8) uniform sampler2D uSampColorShadow;
layout(set = 0, binding = 9) uniform sampler2DShadow uSampDepthShadow;
layout(set = 0, binding = 10) uniform samplerCube uSampRadiance;
layout(set = 2, binding = 0) uniform mediump sampler2D uSampTextureBase;

layout(location = 0) in vec2 inUv;
layout(location = 5) flat in uint inIndices;
layout(location = 3) in vec3 inNormal;
layout(location = 4) in vec4 inTangentW;
layout(location = 1) in vec3 viewDir;
layout(location = 0) out vec4 fragColor;
layout(location = 2) in vec3 inPosition;

uint GetUnpackFlatIndicesInstanceIdx(uint indices)
{
    return indices >> 16u;
}

uint GetMaterialInstanceIndex(uint indices)
{
    uint instanceIdx = 0u;
    bool _RESERVED_IDENTIFIER_FIXUP_151;
    if (_RESERVED_IDENTIFIER_FIXUP_145)
    {
        _RESERVED_IDENTIFIER_FIXUP_151 = _RESERVED_IDENTIFIER_FIXUP_150;
    }
    else
    {
        _RESERVED_IDENTIFIER_FIXUP_151 = _RESERVED_IDENTIFIER_FIXUP_145;
    }
    if (_RESERVED_IDENTIFIER_FIXUP_151)
    {
        uint param = indices;
        uint param_1 = param;
        instanceIdx = GetUnpackFlatIndicesInstanceIdx(param_1);
    }
    return instanceIdx;
}

vec3 Linear2Srgb(vec3 linear)
{
    return mix(linear * 12.9200000762939453125, (pow(linear, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875), step(vec3(0.003130800090730190277099609375), linear));
}

float GetUnpackNormalScale(uint instanceIdx)
{
    return _RESERVED_IDENTIFIER_FIXUP_131.uMaterialData.material[instanceIdx].factors[1].x;
}

mat3 CalcTbnMatrix(vec3 polygonNormal, vec4 tangentW)
{
    vec3 tangent = normalize(tangentW.xyz);
    vec3 bitangent = cross(polygonNormal, tangent) * tangentW.w;
    return mat3(vec3(tangent), vec3(bitangent), vec3(polygonNormal));
}

vec3 CalcFinalNormal(mat3 tbn, vec3 normal, float normalScale)
{
    vec3 n = normalize(((normal * 2.0) - vec3(1.0)) * vec3(normalScale, normalScale, 1.0));
    return normalize(tbn * n);
}

float hdr(int i)
{
    return float(nn_buf.data[i]);
}

vec2 dir2polar(vec3 dir)
{
    float r = length(dir);
    float r_xy = length(dir.xy);
    float radian_xy = acos(dir.z / r);
    float degree_xy = degrees(radian_xy) - 90.0;
    float radian_z = acos(dir.x / (r_xy + 9.9999996826552253889678874634872e-21));
    float degree_z = degrees(radian_z);
    bool tem = dir.y < 0.0;
    if (tem)
    {
        degree_z = -degree_z;
    }
    return vec2(degree_xy / 90.0, degree_z / 180.0);
}

f16vec4 _1080(uint _1081)
{
    return f16vec4(nn_buf.data[_1081], nn_buf.data[_1081 + 1u], nn_buf.data[_1081 + 2u], nn_buf.data[_1081 + 3u]);
}

f16vec4 _1096(uint _1097)
{
    return f16vec4(nn_buf.data[_1097], nn_buf.data[_1097 + 1u], nn_buf.data[_1097 + 2u], nn_buf.data[_1097 + 3u]);
}

vec4[16] _1113(float16_t _1114[10])
{
    float16_t _1133[10] = _1114;
    uint _1127 = 0u;
    vec4 _1126[16];
    uint _1136;
    for (;;)
    {
        _1136 = _1127;
        if (_1136 < 16u)
        {
            vec4 _1129 = vec4(0.0);
            vec4 _1130 = vec4(0.0);
            vec4 _1131 = vec4(0.0);
            vec4 _1132 = vec4(0.0);
            uint _1128 = 0u;
            uint _1138;
            for (;;)
            {
                _1138 = _1128;
                if (_1138 < 2u)
                {
                    uint _1140 = _1138 * 4u;
                    uint _1141 = _1136 * 4u;
                    vec4 _1154 = vec4(f16vec4(_1133[_1140], _1133[_1140 + 1u], _1133[_1140 + 2u], _1133[_1140 + 3u]));
                    uint _1156 = (_1140 * 64u) + _1141;
                    f16vec4 _1169 = _1080(((uint(0) + (_1156 / 64u)) * uint(64)) + (uint(16) + (_1156 % 64u)));
                    uint _1172 = ((_1140 + 1u) * 64u) + _1141;
                    f16vec4 _1185 = _1080(((uint(0) + (_1172 / 64u)) * uint(64)) + (uint(16) + (_1172 % 64u)));
                    uint _1188 = ((_1140 + 2u) * 64u) + _1141;
                    f16vec4 _1201 = _1080(((uint(0) + (_1188 / 64u)) * uint(64)) + (uint(16) + (_1188 % 64u)));
                    uint _1204 = ((_1140 + 3u) * 64u) + _1141;
                    f16vec4 _1217 = _1080(((uint(0) + (_1204 / 64u)) * uint(64)) + (uint(16) + (_1204 % 64u)));
                    _1129 = fma(_1154, vec4(f16vec4(_1169.x, _1185.x, _1201.x, _1217.x)), _1129);
                    _1130 = fma(_1154, vec4(f16vec4(_1169.y, _1185.y, _1201.y, _1217.y)), _1130);
                    _1131 = fma(_1154, vec4(f16vec4(_1169.z, _1185.z, _1201.z, _1217.z)), _1131);
                    _1132 = fma(_1154, vec4(f16vec4(_1169.w, _1185.w, _1201.w, _1217.w)), _1132);
                    _1128 = _1138 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            uint _1251 = _1136 * 4u;
            uint _1254 = 8u + 1u;
            vec4 _1258 = vec4(f16vec4(_1133[8u], _1133[_1254], float16_t(0.0), float16_t(0.0)));
            uint _1259 = 8u * 64u;
            uint _1260 = _1259 + _1251;
            f16vec4 _1273 = _1080(((uint(0) + (_1260 / 64u)) * uint(64)) + (uint(16) + (_1260 % 64u)));
            uint _1274 = 8u + 1u;
            uint _1276 = (_1274 * 64u) + _1251;
            f16vec4 _1289 = _1080(((uint(0) + (_1276 / 64u)) * uint(64)) + (uint(16) + (_1276 % 64u)));
            _1129 = fma(_1258, vec4(f16vec4(_1273.x, _1289.x, float16_t(0.0), float16_t(0.0))), _1129);
            _1130 = fma(_1258, vec4(f16vec4(_1273.y, _1289.y, float16_t(0.0), float16_t(0.0))), _1130);
            _1131 = fma(_1258, vec4(f16vec4(_1273.z, _1289.z, float16_t(0.0), float16_t(0.0))), _1131);
            _1132 = fma(_1258, vec4(f16vec4(_1273.w, _1289.w, float16_t(0.0), float16_t(0.0))), _1132);
            _1126[_1136] = vec4(((_1129.x + _1129.y) + _1129.z) + _1129.w, ((_1130.x + _1130.y) + _1130.z) + _1130.w, ((_1131.x + _1131.y) + _1131.z) + _1131.w, ((_1132.x + _1132.y) + _1132.z) + _1132.w) + vec4(_1096(_1251 + 3456u));
            _1127 = _1136 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _1126;
}

f16vec4 _1355(uint _1356)
{
    return f16vec4(nn_buf.data[_1356], nn_buf.data[_1356 + 1u], nn_buf.data[_1356 + 2u], nn_buf.data[_1356 + 3u]);
}

f16vec4 _1371(uint _1372)
{
    return f16vec4(nn_buf.data[_1372], nn_buf.data[_1372 + 1u], nn_buf.data[_1372 + 2u], nn_buf.data[_1372 + 3u]);
}

vec4[4] _1388(f16vec4 _1389[16])
{
    f16vec4 _1408[16] = _1389;
    uint _1402 = 0u;
    vec4 _1401[4];
    uint _1411;
    for (;;)
    {
        _1411 = _1402;
        if (_1411 < 4u)
        {
            vec4 _1404 = vec4(0.0);
            vec4 _1405 = vec4(0.0);
            vec4 _1406 = vec4(0.0);
            vec4 _1407 = vec4(0.0);
            uint _1403 = 0u;
            uint _1413;
            for (;;)
            {
                _1413 = _1403;
                if (_1413 < 16u)
                {
                    uint _1415 = _1413 * 4u;
                    uint _1416 = _1411 * 4u;
                    vec4 _1419 = vec4(_1408[_1413]);
                    uint _1421 = (_1415 * 16u) + _1416;
                    f16vec4 _1434 = _1355(((uint(41) + (_1421 / 16u)) * uint(16)) + (uint(0) + (_1421 % 16u)));
                    uint _1437 = ((_1415 + 1u) * 16u) + _1416;
                    f16vec4 _1450 = _1355(((uint(41) + (_1437 / 16u)) * uint(16)) + (uint(0) + (_1437 % 16u)));
                    uint _1453 = ((_1415 + 2u) * 16u) + _1416;
                    f16vec4 _1466 = _1355(((uint(41) + (_1453 / 16u)) * uint(16)) + (uint(0) + (_1453 % 16u)));
                    uint _1469 = ((_1415 + 3u) * 16u) + _1416;
                    f16vec4 _1482 = _1355(((uint(41) + (_1469 / 16u)) * uint(16)) + (uint(0) + (_1469 % 16u)));
                    _1404 = fma(_1419, vec4(f16vec4(_1434.x, _1450.x, _1466.x, _1482.x)), _1404);
                    _1405 = fma(_1419, vec4(f16vec4(_1434.y, _1450.y, _1466.y, _1482.y)), _1405);
                    _1406 = fma(_1419, vec4(f16vec4(_1434.z, _1450.z, _1466.z, _1482.z)), _1406);
                    _1407 = fma(_1419, vec4(f16vec4(_1434.w, _1450.w, _1466.w, _1482.w)), _1407);
                    _1403 = _1413 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _1401[_1411] = vec4(((_1404.x + _1404.y) + _1404.z) + _1404.w, ((_1405.x + _1405.y) + _1405.z) + _1405.w, ((_1406.x + _1406.y) + _1406.z) + _1406.w, ((_1407.x + _1407.y) + _1407.z) + _1407.w) + vec4(_1371((_1411 * 4u) + 3584u));
            _1402 = _1411 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _1401;
}

float[3] _1559(f16vec4 _1560[4])
{
    f16vec4 _1575[4] = _1560;
    vec4 _1571 = vec4(0.0);
    vec4 _1572 = vec4(0.0);
    vec4 _1573 = vec4(0.0);
    uint _1570 = 0u;
    uint _1578;
    for (;;)
    {
        _1578 = _1570;
        if (_1578 < 4u)
        {
            uint _1580 = _1578 * 4u;
            vec4 _1583 = vec4(_1575[_1578]);
            uint _1585 = (_1580 * 3u) + 0u;
            uint _1602 = ((_1580 + 1u) * 3u) + 0u;
            uint _1619 = ((_1580 + 2u) * 3u) + 0u;
            uint _1636 = ((_1580 + 3u) * 3u) + 0u;
            _1571 = fma(_1583, vec4(f16vec4(nn_buf.data[((uint(560) + (_1585 / 3u)) * uint(3)) + (uint(0) + (_1585 % 3u))], nn_buf.data[((uint(560) + (_1602 / 3u)) * uint(3)) + (uint(0) + (_1602 % 3u))], nn_buf.data[((uint(560) + (_1619 / 3u)) * uint(3)) + (uint(0) + (_1619 % 3u))], nn_buf.data[((uint(560) + (_1636 / 3u)) * uint(3)) + (uint(0) + (_1636 % 3u))])), _1571);
            uint _1655 = 0u + 1u;
            uint _1657 = (_1580 * 3u) + _1655;
            uint _1673 = 0u + 1u;
            uint _1675 = ((_1580 + 1u) * 3u) + _1673;
            uint _1691 = 0u + 1u;
            uint _1693 = ((_1580 + 2u) * 3u) + _1691;
            uint _1709 = 0u + 1u;
            uint _1711 = ((_1580 + 3u) * 3u) + _1709;
            _1572 = fma(_1583, vec4(f16vec4(nn_buf.data[((uint(560) + (_1657 / 3u)) * uint(3)) + (uint(0) + (_1657 % 3u))], nn_buf.data[((uint(560) + (_1675 / 3u)) * uint(3)) + (uint(0) + (_1675 % 3u))], nn_buf.data[((uint(560) + (_1693 / 3u)) * uint(3)) + (uint(0) + (_1693 % 3u))], nn_buf.data[((uint(560) + (_1711 / 3u)) * uint(3)) + (uint(0) + (_1711 % 3u))])), _1572);
            uint _1730 = 0u + 2u;
            uint _1732 = (_1580 * 3u) + _1730;
            uint _1748 = 0u + 2u;
            uint _1750 = ((_1580 + 1u) * 3u) + _1748;
            uint _1766 = 0u + 2u;
            uint _1768 = ((_1580 + 2u) * 3u) + _1766;
            uint _1784 = 0u + 2u;
            uint _1786 = ((_1580 + 3u) * 3u) + _1784;
            _1573 = fma(_1583, vec4(f16vec4(nn_buf.data[((uint(560) + (_1732 / 3u)) * uint(3)) + (uint(0) + (_1732 % 3u))], nn_buf.data[((uint(560) + (_1750 / 3u)) * uint(3)) + (uint(0) + (_1750 % 3u))], nn_buf.data[((uint(560) + (_1768 / 3u)) * uint(3)) + (uint(0) + (_1768 % 3u))], nn_buf.data[((uint(560) + (_1786 / 3u)) * uint(3)) + (uint(0) + (_1786 % 3u))])), _1573);
            _1570 = _1578 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    uint _1814 = 0u + 3616u;
    float _1569[3];
    _1569[0u] = (((_1571.x + _1571.y) + _1571.z) + _1571.w) + float(nn_buf.data[_1814]);
    uint _1828 = 0u + 1u;
    _1569[_1828] = (((_1572.x + _1572.y) + _1572.z) + _1572.w) + float(nn_buf.data[_1828 + 3616u]);
    uint _1843 = 0u + 2u;
    _1569[_1843] = (((_1573.x + _1573.y) + _1573.z) + _1573.w) + float(nn_buf.data[_1843 + 3616u]);
    return _1569;
}

mediump vec3 evaluateNetwork2(mediump vec3 envmap, mediump vec3 dirmap, mediump vec3 specular, mediump float nDir)
{
    float16_t inVec[10];
    inVec[0] = float16_t(envmap.x);
    inVec[1] = float16_t(envmap.y);
    inVec[2] = float16_t(envmap.z);
    inVec[3] = float16_t(dirmap.x);
    inVec[4] = float16_t(dirmap.y);
    inVec[5] = float16_t(dirmap.z);
    inVec[6] = float16_t(specular.x);
    inVec[7] = float16_t(specular.y);
    inVec[8] = float16_t(specular.z);
    inVec[9] = float16_t(nDir);
    vec4 _339[16] = _1113(inVec);
    vec4 tempArg[16] = _339;
    vec4 _RESERVED_IDENTIFIER_FIXUP_289[16] = _339;
    vec4 tempArg_2[16] = _339;
    vec4 out0[16] = _339;
    vec4 _1854[16] = _339;
    uint _1853 = 0u;
    vec4 _1852[16];
    uint _1860;
    for (;;)
    {
        _1860 = _1853;
        if (_1860 < 16u)
        {
            _1852[_1860] = max(_1854[_1860], _347[_1860]);
            _1853 = _1860 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    out0 = _1852;
    vec4 _1871[16] = _1852;
    uint _1870 = 0u;
    f16vec4 _1869[16];
    uint _1876;
    for (;;)
    {
        _1876 = _1870;
        if (_1876 < 16u)
        {
            _1869[_1876] = f16vec4(_1871[_1876]);
            _1870 = _1876 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 inVec1[16] = _1869;
    vec4 _390[4] = _1388(_1869);
    vec4 tempArg_1[4] = _390;
    vec4 _RESERVED_IDENTIFIER_FIXUP_325[4] = _390;
    vec4 tempArg_5[4] = _390;
    vec4 out1[4] = _390;
    vec4 _1885[4] = _390;
    uint _1884 = 0u;
    vec4 _1883[4];
    uint _1891;
    for (;;)
    {
        _1891 = _1884;
        if (_1891 < 4u)
        {
            _1883[_1891] = max(_1885[_1891], _398[_1891]);
            _1884 = _1891 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    out1 = _1883;
    vec4 _1902[4] = _1883;
    uint _1901 = 0u;
    f16vec4 _1900[4];
    uint _1907;
    for (;;)
    {
        _1907 = _1901;
        if (_1907 < 4u)
        {
            _1900[_1907] = f16vec4(_1902[_1907]);
            _1901 = _1907 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 inVec2[4] = _1900;
    float _441[3] = _1559(_1900);
    float tempArg_3[3] = _441;
    float _RESERVED_IDENTIFIER_FIXUP_361[3] = _441;
    float tempArg_8[3] = _441;
    float out2[3] = _441;
    return max(vec3(out2[0], out2[1], out2[2]), vec3(0.0));
}

uint GetShadingMode()
{
    return _RESERVED_IDENTIFIER_FIXUP_167.uMaterialUserData.material[0].userData[0].x;
}

vec3 Srgb2Linear(vec3 srgb)
{
    return mix(srgb / vec3(12.9200000762939453125), pow((srgb + vec3(0.054999999701976776123046875)) / vec3(1.05499994754791259765625), vec3(2.400000095367431640625)), step(vec3(0.040449999272823333740234375), srgb));
}

vec4 GetFinalColorFactor()
{
    uvec4 vec = _RESERVED_IDENTIFIER_FIXUP_167.uMaterialUserData.material[0].userData[1];
    return vec4(uintBitsToFloat(vec.x), uintBitsToFloat(vec.y), uintBitsToFloat(vec.z), uintBitsToFloat(vec.w));
}

void main()
{
    vec2 uvFlip = vec2(inUv.x, 1.0 - inUv.y);
    uint param = inIndices;
    uint param_1 = param;
    uint instanceIdx = GetMaterialInstanceIndex(param_1);
    vec3 normNormal = normalize(inNormal);
    vec3 N = normNormal;
    vec3 param_1_1 = texture(uSampTextures[0], inUv).xyz;
    vec3 param_2 = param_1_1;
    N = Linear2Srgb(param_2);
    uint param_3 = instanceIdx;
    float normalScale = GetUnpackNormalScale(param_3);
    vec3 param_2_1 = normNormal;
    vec4 param_3_1 = inTangentW;
    vec3 param_4 = param_2_1;
    vec4 param_5 = param_3_1;
    mat3 tbn = CalcTbnMatrix(param_4, param_5);
    mat3 param_4_1 = tbn;
    vec3 param_5_1 = N;
    float param_6 = normalScale;
    mat3 param_7 = param_4_1;
    vec3 param_8 = param_5_1;
    float param_9 = param_6;
    N = CalcFinalNormal(param_7, param_8, param_9);
    vec3 unitNormal = vec3(N.x, -N.z, N.y);
    vec3 param_7_1 = textureLod(uSampTextures[2], uvFlip, 0.0).xyz;
    int param_8_1 = 5;
    vec3 param_10 = param_7_1;
    int param_11 = param_8_1;
    vec3 diffusefe = Linear2Srgb(param_10) * hdr(param_11);
    vec3 param_9_1 = textureLod(uSampTextures[3], uvFlip, 0.0).xyz;
    int param_10_1 = 6;
    vec3 param_12 = param_9_1;
    int param_13 = param_10_1;
    vec3 specfe = Linear2Srgb(param_12) * hdr(param_13);
    vec3 unitViewDir = normalize(vec3(-viewDir.x, viewDir.z, -viewDir.y));
    float nDir = dot(unitViewDir, unitNormal);
    vec3 wDir = -reflect(unitViewDir, unitNormal);
    vec3 param_11_1 = wDir;
    vec3 param_14 = param_11_1;
    vec2 degree_xyz = dir2polar(param_14);
    vec2 polar_uv = max(min(vec2((degree_xyz.y + 1.0) / 2.0, (degree_xyz.x + 1.0) / 2.0), vec2(1.0)), vec2(0.0));
    ivec2 _RESERVED_IDENTIFIER_FIXUP_590 = textureSize(uSampTextures[5], 0);
    mediump ivec2 mp_copy_590 = _RESERVED_IDENTIFIER_FIXUP_590;
    ivec2 texCoord = ivec2(polar_uv * vec2(mp_copy_590 - ivec2(1)));
    vec3 param_12_1 = texelFetch(uSampTextures[5], texCoord, 0).xyz;
    vec3 param_15 = param_12_1;
    vec3 envmap = Linear2Srgb(param_15);
    vec3 param_13_1 = texelFetch(uSampTextures[7], texCoord, 0).xyz;
    vec3 param_16 = param_13_1;
    vec3 envmap_re = Linear2Srgb(param_16);
    int param_14_1 = 1;
    int param_15_1 = 0;
    int param_16_1 = 0;
    int param_17 = param_14_1;
    int param_18 = param_15_1;
    int param_19 = param_16_1;
    envmap = (envmap * (hdr(param_17) - hdr(param_18))) + vec3(hdr(param_19));
    int param_17_1 = 4;
    int param_18_1 = 3;
    int param_19_1 = 3;
    int param_20 = param_17_1;
    int param_21 = param_18_1;
    int param_22 = param_19_1;
    envmap_re = (envmap_re * (hdr(param_20) - hdr(param_21))) + vec3(hdr(param_22));
    int param_20_1 = 2;
    int param_23 = param_20_1;
    envmap_re /= vec3(pow(10.0, hdr(param_23)));
    envmap += envmap_re;
    vec3 nViewDir = normalize(unitViewDir + unitNormal);
    vec3 param_21_1 = nViewDir;
    vec3 param_24 = param_21_1;
    degree_xyz = dir2polar(param_24);
    polar_uv = max(min(vec2((degree_xyz.y + 1.0) / 2.0, (degree_xyz.x + 1.0) / 2.0), vec2(1.0)), vec2(0.0));
    ivec2 _RESERVED_IDENTIFIER_FIXUP_669 = textureSize(uSampTextures[4], 0);
    mediump ivec2 mp_copy_669 = _RESERVED_IDENTIFIER_FIXUP_669;
    texCoord = ivec2(polar_uv * vec2(mp_copy_669 - ivec2(1)));
    vec3 param_22_1 = texelFetch(uSampTextures[4], texCoord, 0).xyz;
    vec3 param_25 = param_22_1;
    vec3 dirmap = Linear2Srgb(param_25);
    vec3 param_23_1 = texelFetch(uSampTextures[6], texCoord, 0).xyz;
    vec3 param_26 = param_23_1;
    vec3 dirmapre = Linear2Srgb(param_26);
    int param_24_1 = 8;
    int param_25_1 = 7;
    int param_26_1 = 7;
    int param_27 = param_24_1;
    int param_28 = param_25_1;
    int param_29 = param_26_1;
    dirmap = (dirmap * (hdr(param_27) - hdr(param_28))) + vec3(hdr(param_29));
    int param_27_1 = 11;
    int param_28_1 = 10;
    int param_29_1 = 10;
    int param_30 = param_27_1;
    int param_31 = param_28_1;
    int param_32 = param_29_1;
    dirmapre = (dirmapre * (hdr(param_30) - hdr(param_31))) + vec3(hdr(param_32));
    int param_30_1 = 9;
    int param_33 = param_30_1;
    dirmapre /= vec3(pow(10.0, hdr(param_33)));
    dirmap += dirmapre;
    mediump vec3 param_31_1 = envmap;
    mediump vec3 param_32_1 = dirmap;
    mediump vec3 param_33_1 = specfe;
    mediump float param_34 = nDir;
    mediump vec3 param_35 = param_31_1;
    mediump vec3 param_36 = param_32_1;
    mediump vec3 param_37 = param_33_1;
    mediump float param_38 = param_34;
    vec3 outputArr = evaluateNetwork2(param_35, param_36, param_37, param_38);
    if (GetShadingMode() == 0u)
    {
        vec3 param_35_1 = max(min(diffusefe + outputArr, vec3(1.0)), vec3(0.0));
        vec3 param_39 = param_35_1;
        vec3 _RESERVED_IDENTIFIER_FIXUP_748 = Srgb2Linear(param_39);
        fragColor.x = _RESERVED_IDENTIFIER_FIXUP_748.x;
        fragColor.y = _RESERVED_IDENTIFIER_FIXUP_748.y;
        fragColor.z = _RESERVED_IDENTIFIER_FIXUP_748.z;
        vec4 _RESERVED_IDENTIFIER_FIXUP_756 = fragColor;
        vec3 _RESERVED_IDENTIFIER_FIXUP_760 = _RESERVED_IDENTIFIER_FIXUP_756.xyz * GetFinalColorFactor().xyz;
        fragColor.x = _RESERVED_IDENTIFIER_FIXUP_760.x;
        fragColor.y = _RESERVED_IDENTIFIER_FIXUP_760.y;
        fragColor.z = _RESERVED_IDENTIFIER_FIXUP_760.z;
        fragColor.w = 1.0;
    }
    else
    {
        if (GetShadingMode() == 1u)
        {
            fragColor.x = envmap.x;
            fragColor.y = envmap.y;
            fragColor.z = envmap.z;
            fragColor.w = 1.0;
        }
        else
        {
            if (GetShadingMode() == 2u)
            {
                fragColor.x = dirmap.x;
                fragColor.y = dirmap.y;
                fragColor.z = dirmap.z;
                fragColor.w = 1.0;
            }
            else
            {
                if (GetShadingMode() == 3u)
                {
                    fragColor.x = specfe.x;
                    fragColor.y = specfe.y;
                    fragColor.z = specfe.z;
                    fragColor.w = 1.0;
                }
                else
                {
                    if (GetShadingMode() == 4u)
                    {
                        vec3 _RESERVED_IDENTIFIER_FIXUP_815 = -vec3(nDir);
                        fragColor.x = _RESERVED_IDENTIFIER_FIXUP_815.x;
                        fragColor.y = _RESERVED_IDENTIFIER_FIXUP_815.y;
                        fragColor.z = _RESERVED_IDENTIFIER_FIXUP_815.z;
                        fragColor.w = 1.0;
                    }
                }
            }
        }
    }
}

