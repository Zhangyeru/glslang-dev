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

f16vec4 _1815(uint _1816)
{
    return f16vec4(nn_buf.data[_1816], nn_buf.data[_1816 + 1u], nn_buf.data[_1816 + 2u], nn_buf.data[_1816 + 3u]);
}

f16vec4 _1080(uint _1081)
{
    return f16vec4(nn_buf.data[_1081], nn_buf.data[_1081 + 1u], nn_buf.data[_1081 + 2u], nn_buf.data[_1081 + 3u]);
}

vec4[16] _1097(float16_t _1098[10], vec4 _1099[16])
{
    float16_t _1118[10] = _1098;
    vec4 _1119[16] = _1099;
    uint _1112 = 0u;
    vec4 _1111[16];
    uint _1121;
    for (;;)
    {
        _1121 = _1112;
        if (_1121 < 16u)
        {
            vec4 _1114 = vec4(0.0);
            vec4 _1115 = vec4(0.0);
            vec4 _1116 = vec4(0.0);
            vec4 _1117 = vec4(0.0);
            uint _1113 = 0u;
            uint _1123;
            for (;;)
            {
                _1123 = _1113;
                if (_1123 < 2u)
                {
                    uint _1125 = _1123 * 4u;
                    uint _1126 = _1121 * 4u;
                    vec4 _1139 = vec4(f16vec4(_1118[_1125], _1118[_1125 + 1u], _1118[_1125 + 2u], _1118[_1125 + 3u]));
                    uint _1141 = (_1125 * 64u) + _1126;
                    f16vec4 _1154 = _1080(((uint(0) + (_1141 / 64u)) * uint(64)) + (uint(16) + (_1141 % 64u)));
                    uint _1157 = ((_1125 + 1u) * 64u) + _1126;
                    f16vec4 _1170 = _1080(((uint(0) + (_1157 / 64u)) * uint(64)) + (uint(16) + (_1157 % 64u)));
                    uint _1173 = ((_1125 + 2u) * 64u) + _1126;
                    f16vec4 _1186 = _1080(((uint(0) + (_1173 / 64u)) * uint(64)) + (uint(16) + (_1173 % 64u)));
                    uint _1189 = ((_1125 + 3u) * 64u) + _1126;
                    f16vec4 _1202 = _1080(((uint(0) + (_1189 / 64u)) * uint(64)) + (uint(16) + (_1189 % 64u)));
                    _1114 = fma(_1139, vec4(f16vec4(_1154.x, _1170.x, _1186.x, _1202.x)), _1114);
                    _1115 = fma(_1139, vec4(f16vec4(_1154.y, _1170.y, _1186.y, _1202.y)), _1115);
                    _1116 = fma(_1139, vec4(f16vec4(_1154.z, _1170.z, _1186.z, _1202.z)), _1116);
                    _1117 = fma(_1139, vec4(f16vec4(_1154.w, _1170.w, _1186.w, _1202.w)), _1117);
                    _1113 = _1123 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            uint _1236 = _1121 * 4u;
            uint _1239 = 8u + 1u;
            vec4 _1243 = vec4(f16vec4(_1118[8u], _1118[_1239], float16_t(0.0), float16_t(0.0)));
            uint _1244 = 8u * 64u;
            uint _1245 = _1244 + _1236;
            f16vec4 _1258 = _1080(((uint(0) + (_1245 / 64u)) * uint(64)) + (uint(16) + (_1245 % 64u)));
            uint _1259 = 8u + 1u;
            uint _1261 = (_1259 * 64u) + _1236;
            f16vec4 _1274 = _1080(((uint(0) + (_1261 / 64u)) * uint(64)) + (uint(16) + (_1261 % 64u)));
            _1114 = fma(_1243, vec4(f16vec4(_1258.x, _1274.x, float16_t(0.0), float16_t(0.0))), _1114);
            _1115 = fma(_1243, vec4(f16vec4(_1258.y, _1274.y, float16_t(0.0), float16_t(0.0))), _1115);
            _1116 = fma(_1243, vec4(f16vec4(_1258.z, _1274.z, float16_t(0.0), float16_t(0.0))), _1116);
            _1117 = fma(_1243, vec4(f16vec4(_1258.w, _1274.w, float16_t(0.0), float16_t(0.0))), _1117);
            _1111[_1121] = vec4(((_1114.x + _1114.y) + _1114.z) + _1114.w, ((_1115.x + _1115.y) + _1115.z) + _1115.w, ((_1116.x + _1116.y) + _1116.z) + _1116.w, ((_1117.x + _1117.y) + _1117.z) + _1117.w) + _1119[_1121];
            _1112 = _1121 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _1111;
}

f16vec4 _1890(uint _1891)
{
    return f16vec4(nn_buf.data[_1891], nn_buf.data[_1891 + 1u], nn_buf.data[_1891 + 2u], nn_buf.data[_1891 + 3u]);
}

f16vec4 _1339(uint _1340)
{
    return f16vec4(nn_buf.data[_1340], nn_buf.data[_1340 + 1u], nn_buf.data[_1340 + 2u], nn_buf.data[_1340 + 3u]);
}

vec4[4] _1356(f16vec4 _1357[16], vec4 _1358[4])
{
    f16vec4 _1377[16] = _1357;
    vec4 _1378[4] = _1358;
    uint _1371 = 0u;
    vec4 _1370[4];
    uint _1380;
    for (;;)
    {
        _1380 = _1371;
        if (_1380 < 4u)
        {
            vec4 _1373 = vec4(0.0);
            vec4 _1374 = vec4(0.0);
            vec4 _1375 = vec4(0.0);
            vec4 _1376 = vec4(0.0);
            uint _1372 = 0u;
            uint _1382;
            for (;;)
            {
                _1382 = _1372;
                if (_1382 < 16u)
                {
                    uint _1384 = _1382 * 4u;
                    uint _1385 = _1380 * 4u;
                    vec4 _1388 = vec4(_1377[_1382]);
                    uint _1390 = (_1384 * 16u) + _1385;
                    f16vec4 _1403 = _1339(((uint(41) + (_1390 / 16u)) * uint(16)) + (uint(0) + (_1390 % 16u)));
                    uint _1406 = ((_1384 + 1u) * 16u) + _1385;
                    f16vec4 _1419 = _1339(((uint(41) + (_1406 / 16u)) * uint(16)) + (uint(0) + (_1406 % 16u)));
                    uint _1422 = ((_1384 + 2u) * 16u) + _1385;
                    f16vec4 _1435 = _1339(((uint(41) + (_1422 / 16u)) * uint(16)) + (uint(0) + (_1422 % 16u)));
                    uint _1438 = ((_1384 + 3u) * 16u) + _1385;
                    f16vec4 _1451 = _1339(((uint(41) + (_1438 / 16u)) * uint(16)) + (uint(0) + (_1438 % 16u)));
                    _1373 = fma(_1388, vec4(f16vec4(_1403.x, _1419.x, _1435.x, _1451.x)), _1373);
                    _1374 = fma(_1388, vec4(f16vec4(_1403.y, _1419.y, _1435.y, _1451.y)), _1374);
                    _1375 = fma(_1388, vec4(f16vec4(_1403.z, _1419.z, _1435.z, _1451.z)), _1375);
                    _1376 = fma(_1388, vec4(f16vec4(_1403.w, _1419.w, _1435.w, _1451.w)), _1376);
                    _1372 = _1382 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _1370[_1380] = vec4(((_1373.x + _1373.y) + _1373.z) + _1373.w, ((_1374.x + _1374.y) + _1374.z) + _1374.w, ((_1375.x + _1375.y) + _1375.z) + _1375.w, ((_1376.x + _1376.y) + _1376.z) + _1376.w) + _1378[_1380];
            _1371 = _1380 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _1370;
}

float[3] _1527(f16vec4 _1528[4], float _1529[3])
{
    f16vec4 _1544[4] = _1528;
    float _1545[3] = _1529;
    vec4 _1540 = vec4(0.0);
    vec4 _1541 = vec4(0.0);
    vec4 _1542 = vec4(0.0);
    uint _1539 = 0u;
    uint _1547;
    for (;;)
    {
        _1547 = _1539;
        if (_1547 < 4u)
        {
            uint _1549 = _1547 * 4u;
            vec4 _1552 = vec4(_1544[_1547]);
            uint _1554 = (_1549 * 3u) + 0u;
            uint _1571 = ((_1549 + 1u) * 3u) + 0u;
            uint _1588 = ((_1549 + 2u) * 3u) + 0u;
            uint _1605 = ((_1549 + 3u) * 3u) + 0u;
            _1540 = fma(_1552, vec4(f16vec4(nn_buf.data[((uint(560) + (_1554 / 3u)) * uint(3)) + (uint(0) + (_1554 % 3u))], nn_buf.data[((uint(560) + (_1571 / 3u)) * uint(3)) + (uint(0) + (_1571 % 3u))], nn_buf.data[((uint(560) + (_1588 / 3u)) * uint(3)) + (uint(0) + (_1588 % 3u))], nn_buf.data[((uint(560) + (_1605 / 3u)) * uint(3)) + (uint(0) + (_1605 % 3u))])), _1540);
            uint _1624 = 0u + 1u;
            uint _1626 = (_1549 * 3u) + _1624;
            uint _1642 = 0u + 1u;
            uint _1644 = ((_1549 + 1u) * 3u) + _1642;
            uint _1660 = 0u + 1u;
            uint _1662 = ((_1549 + 2u) * 3u) + _1660;
            uint _1678 = 0u + 1u;
            uint _1680 = ((_1549 + 3u) * 3u) + _1678;
            _1541 = fma(_1552, vec4(f16vec4(nn_buf.data[((uint(560) + (_1626 / 3u)) * uint(3)) + (uint(0) + (_1626 % 3u))], nn_buf.data[((uint(560) + (_1644 / 3u)) * uint(3)) + (uint(0) + (_1644 % 3u))], nn_buf.data[((uint(560) + (_1662 / 3u)) * uint(3)) + (uint(0) + (_1662 % 3u))], nn_buf.data[((uint(560) + (_1680 / 3u)) * uint(3)) + (uint(0) + (_1680 % 3u))])), _1541);
            uint _1699 = 0u + 2u;
            uint _1701 = (_1549 * 3u) + _1699;
            uint _1717 = 0u + 2u;
            uint _1719 = ((_1549 + 1u) * 3u) + _1717;
            uint _1735 = 0u + 2u;
            uint _1737 = ((_1549 + 2u) * 3u) + _1735;
            uint _1753 = 0u + 2u;
            uint _1755 = ((_1549 + 3u) * 3u) + _1753;
            _1542 = fma(_1552, vec4(f16vec4(nn_buf.data[((uint(560) + (_1701 / 3u)) * uint(3)) + (uint(0) + (_1701 % 3u))], nn_buf.data[((uint(560) + (_1719 / 3u)) * uint(3)) + (uint(0) + (_1719 % 3u))], nn_buf.data[((uint(560) + (_1737 / 3u)) * uint(3)) + (uint(0) + (_1737 % 3u))], nn_buf.data[((uint(560) + (_1755 / 3u)) * uint(3)) + (uint(0) + (_1755 % 3u))])), _1542);
            _1539 = _1547 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float _1538[3];
    _1538[0u] = (((_1540.x + _1540.y) + _1540.z) + _1540.w) + _1545[0u];
    uint _1795 = 0u + 1u;
    _1538[_1795] = (((_1541.x + _1541.y) + _1541.z) + _1541.w) + _1545[_1795];
    uint _1808 = 0u + 2u;
    _1538[_1808] = (((_1542.x + _1542.y) + _1542.z) + _1542.w) + _1545[_1808];
    return _1538;
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
    uint _1832 = 0u;
    f16vec4 _1831[16];
    uint _1837;
    for (;;)
    {
        _1837 = _1832;
        if (_1837 < 64u)
        {
            _1831[_1837 / 4u] = _1815(3456u + _1837);
            _1832 = _1837 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _323[16] = _1831;
    f16vec4 tempArg[16] = _323;
    f16vec4 _RESERVED_IDENTIFIER_FIXUP_277[16] = _323;
    f16vec4 tempArg_1[16] = _323;
    f16vec4 bias0_f16[16] = _323;
    f16vec4 _1847[16] = _323;
    uint _1846 = 0u;
    vec4 _1845[16];
    uint _1852;
    for (;;)
    {
        _1852 = _1846;
        if (_1852 < 16u)
        {
            _1845[_1852] = vec4(_1847[_1852]);
            _1846 = _1852 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 bias0[16] = _1845;
    vec4 _339[16] = _1097(inVec, _1845);
    vec4 tempArg_2[16] = _339;
    vec4 _RESERVED_IDENTIFIER_FIXUP_289[16] = _339;
    vec4 tempArg_2_1[16] = _339;
    vec4 out0[16] = _339;
    vec4 _1861[16] = _339;
    uint _1860 = 0u;
    vec4 _1859[16];
    uint _1867;
    for (;;)
    {
        _1867 = _1860;
        if (_1867 < 16u)
        {
            _1859[_1867] = max(_1861[_1867], _347[_1867]);
            _1860 = _1867 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    out0 = _1859;
    vec4 _1878[16] = _1859;
    uint _1877 = 0u;
    f16vec4 _1876[16];
    uint _1883;
    for (;;)
    {
        _1883 = _1877;
        if (_1883 < 16u)
        {
            _1876[_1883] = f16vec4(_1878[_1883]);
            _1877 = _1883 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 inVec1[16] = _1876;
    uint _1907 = 0u;
    f16vec4 _1906[4];
    uint _1912;
    for (;;)
    {
        _1912 = _1907;
        if (_1912 < 16u)
        {
            _1906[_1912 / 4u] = _1890(3584u + _1912);
            _1907 = _1912 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _374[4] = _1906;
    f16vec4 tempArg_3[4] = _374;
    f16vec4 _RESERVED_IDENTIFIER_FIXUP_313[4] = _374;
    f16vec4 tempArg_4[4] = _374;
    f16vec4 bias1_f16[4] = _374;
    f16vec4 _1922[4] = _374;
    uint _1921 = 0u;
    vec4 _1920[4];
    uint _1927;
    for (;;)
    {
        _1927 = _1921;
        if (_1927 < 4u)
        {
            _1920[_1927] = vec4(_1922[_1927]);
            _1921 = _1927 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    vec4 bias1[4] = _1920;
    vec4 _390[4] = _1356(_1876, _1920);
    vec4 tempArg_5[4] = _390;
    vec4 _RESERVED_IDENTIFIER_FIXUP_325[4] = _390;
    vec4 tempArg_5_1[4] = _390;
    vec4 out1[4] = _390;
    vec4 _1936[4] = _390;
    uint _1935 = 0u;
    vec4 _1934[4];
    uint _1942;
    for (;;)
    {
        _1942 = _1935;
        if (_1942 < 4u)
        {
            _1934[_1942] = max(_1936[_1942], _398[_1942]);
            _1935 = _1942 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    out1 = _1934;
    vec4 _1953[4] = _1934;
    uint _1952 = 0u;
    f16vec4 _1951[4];
    uint _1958;
    for (;;)
    {
        _1958 = _1952;
        if (_1958 < 4u)
        {
            _1951[_1958] = f16vec4(_1953[_1958]);
            _1952 = _1958 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 inVec2[4] = _1951;
    uint _1965 = 3616u + 0u;
    uint _1968 = 3616u + 1u;
    uint _1971 = 3616u + 2u;
    float16_t _425[3] = float16_t[](nn_buf.data[_1965], nn_buf.data[_1968], nn_buf.data[_1971]);
    float16_t tempArg_6[3] = _425;
    float16_t _RESERVED_IDENTIFIER_FIXUP_349[3] = _425;
    float16_t tempArg_7[3] = _425;
    float16_t bias2_f16[3] = _425;
    float16_t _1977[3] = _425;
    uint _1975 = 0u;
    float _1974[3];
    uint _1982;
    for (;;)
    {
        _1982 = _1975;
        if (_1982 < 3u)
        {
            _1974[_1982] = float(_1977[_1982]);
            _1975 = _1982 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    float bias2[3] = _1974;
    float _441[3] = _1527(_1951, _1974);
    float tempArg_8[3] = _441;
    float _RESERVED_IDENTIFIER_FIXUP_361[3] = _441;
    float tempArg_8_1[3] = _441;
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

