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

struct DefaultMaterialSingleMaterialStruct
{
    vec4 factors[15];
    uvec4 indices;
};

struct DefaultMaterialMaterialStruct
{
    DefaultMaterialSingleMaterialStruct material[64];
};

const f16vec2 _388[8] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const float16_t _433[3] = float16_t[](float16_t(0.0), float16_t(0.0), float16_t(0.0));

struct DefaultMaterialSingleUserMaterialStruct
{
    uvec4 userData[16];
};

struct DefaultMaterialUserMaterialStruct
{
    DefaultMaterialSingleUserMaterialStruct material[64];
};

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
    if (false)
    {
        _RESERVED_IDENTIFIER_FIXUP_151 = false;
    }
    else
    {
        _RESERVED_IDENTIFIER_FIXUP_151 = false;
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

float16_t[3] _8817(f16vec2 _8818[8], float16_t _8819[3])
{
    f16vec2 _9036 = fma(f16vec2(_8818[3].y), f16vec2(nn_buf.data[1701u], nn_buf.data[1702u]), fma(f16vec2(_8818[3].x), f16vec2(nn_buf.data[1698u], nn_buf.data[1699u]), fma(f16vec2(_8818[2].y), f16vec2(nn_buf.data[1695u], nn_buf.data[1696u]), fma(f16vec2(_8818[2].x), f16vec2(nn_buf.data[1692u], nn_buf.data[1693u]), fma(f16vec2(_8818[1].y), f16vec2(nn_buf.data[1689u], nn_buf.data[1690u]), fma(f16vec2(_8818[1].x), f16vec2(nn_buf.data[1686u], nn_buf.data[1687u]), fma(f16vec2(_8818[0].y), f16vec2(nn_buf.data[1683u], nn_buf.data[1684u]), fma(f16vec2(_8818[0].x), f16vec2(nn_buf.data[1680u], nn_buf.data[1681u]), f16vec2(_8819[0], _8819[1])))))))));
    float16_t _9061 = fma(_8818[6].y, nn_buf.data[1721u], fma(_8818[6].x, nn_buf.data[1718u], fma(_8818[5].y, nn_buf.data[1715u], fma(_8818[5].x, nn_buf.data[1712u], fma(_8818[4].y, nn_buf.data[1709u], fma(_8818[4].x, nn_buf.data[1706u], fma(_8818[3].y, nn_buf.data[1703u], fma(_8818[3].x, nn_buf.data[1700u], fma(_8818[2].y, nn_buf.data[1697u], fma(_8818[2].x, nn_buf.data[1694u], fma(_8818[1].y, nn_buf.data[1691u], fma(_8818[1].x, nn_buf.data[1688u], fma(_8818[0].y, nn_buf.data[1685u], fma(_8818[0].x, nn_buf.data[1682u], _8819[2]))))))))))))));
    f16vec2 _9068 = fma(f16vec2(_8818[7].y), f16vec2(nn_buf.data[1725u], nn_buf.data[1726u]), fma(f16vec2(_8818[7].x), f16vec2(nn_buf.data[1722u], nn_buf.data[1723u]), fma(f16vec2(_8818[6].y), f16vec2(nn_buf.data[1719u], nn_buf.data[1720u]), fma(f16vec2(_8818[6].x), f16vec2(nn_buf.data[1716u], nn_buf.data[1717u]), fma(f16vec2(_8818[5].y), f16vec2(nn_buf.data[1713u], nn_buf.data[1714u]), fma(f16vec2(_8818[5].x), f16vec2(nn_buf.data[1710u], nn_buf.data[1711u]), fma(f16vec2(_8818[4].y), f16vec2(nn_buf.data[1707u], nn_buf.data[1708u]), fma(f16vec2(_8818[4].x), f16vec2(nn_buf.data[1704u], nn_buf.data[1705u]), _9036))))))));
    return float16_t[](_9068.x, _9068.y, fma(_8818[7].y, nn_buf.data[1727u], fma(_8818[7].x, nn_buf.data[1724u], _9061)));
}

mediump vec3 evaluateNetwork2(mediump vec3 envmap, mediump vec3 dirmap, mediump vec3 specular, mediump float nDir)
{
    int _9074 = 0 / 2;
    int _9075 = 0 - 2 * (0 / 2);
    f16vec2 inVec[5];
    inVec[_9074][_9075] = float16_t(envmap.x);
    int _9076 = 1 / 2;
    int _9077 = 1 - 2 * (1 / 2);
    inVec[_9076][_9077] = float16_t(envmap.y);
    int _9078 = 2 / 2;
    int _9079 = 2 - 2 * (2 / 2);
    inVec[_9078][_9079] = float16_t(envmap.z);
    int _9080 = 3 / 2;
    int _9081 = 3 - 2 * (3 / 2);
    inVec[_9080][_9081] = float16_t(dirmap.x);
    int _9082 = 4 / 2;
    int _9083 = 4 - 2 * (4 / 2);
    inVec[_9082][_9083] = float16_t(dirmap.y);
    int _9084 = 5 / 2;
    int _9085 = 5 - 2 * (5 / 2);
    inVec[_9084][_9085] = float16_t(dirmap.z);
    int _9086 = 6 / 2;
    int _9087 = 6 - 2 * (6 / 2);
    inVec[_9086][_9087] = float16_t(specular.x);
    int _9088 = 7 / 2;
    int _9089 = 7 - 2 * (7 / 2);
    inVec[_9088][_9089] = float16_t(specular.y);
    int _9090 = 8 / 2;
    int _9091 = 8 - 2 * (8 / 2);
    inVec[_9090][_9091] = float16_t(specular.z);
    int _9092 = 9 / 2;
    int _9093 = 9 - 2 * (9 / 2);
    inVec[_9092][_9093] = float16_t(nDir);
    f16vec2 _1205 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[528u], nn_buf.data[529u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[464u], nn_buf.data[465u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[400u], nn_buf.data[401u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[336u], nn_buf.data[337u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[272u], nn_buf.data[273u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[208u], nn_buf.data[209u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[144u], nn_buf.data[145u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[80u], nn_buf.data[81u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[16u], nn_buf.data[17u]), f16vec2(nn_buf.data[3456u], nn_buf.data[3457u]))))))))));
    f16vec2 _1216 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[592u], nn_buf.data[593u]), _1205), f16vec2(float16_t(0.0)));
    f16vec2 _1219 = f16vec2(_1216.x);
    f16vec2 _1220 = f16vec2(_1216.y);
    f16vec2 _1445 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[530u], nn_buf.data[531u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[466u], nn_buf.data[467u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[402u], nn_buf.data[403u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[338u], nn_buf.data[339u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[274u], nn_buf.data[275u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[210u], nn_buf.data[211u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[146u], nn_buf.data[147u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[82u], nn_buf.data[83u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[18u], nn_buf.data[19u]), f16vec2(nn_buf.data[3458u], nn_buf.data[3459u]))))))))));
    f16vec2 _1456 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[594u], nn_buf.data[595u]), _1445), f16vec2(float16_t(0.0)));
    f16vec2 _1459 = f16vec2(_1456.x);
    f16vec2 _1460 = f16vec2(_1456.y);
    f16vec2 _1685 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[532u], nn_buf.data[533u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[468u], nn_buf.data[469u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[404u], nn_buf.data[405u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[340u], nn_buf.data[341u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[276u], nn_buf.data[277u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[212u], nn_buf.data[213u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[148u], nn_buf.data[149u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[84u], nn_buf.data[85u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[20u], nn_buf.data[21u]), f16vec2(nn_buf.data[3460u], nn_buf.data[3461u]))))))))));
    f16vec2 _1696 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[596u], nn_buf.data[597u]), _1685), f16vec2(float16_t(0.0)));
    f16vec2 _1699 = f16vec2(_1696.x);
    f16vec2 _1700 = f16vec2(_1696.y);
    f16vec2 _1925 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[534u], nn_buf.data[535u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[470u], nn_buf.data[471u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[406u], nn_buf.data[407u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[342u], nn_buf.data[343u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[278u], nn_buf.data[279u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[214u], nn_buf.data[215u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[150u], nn_buf.data[151u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[86u], nn_buf.data[87u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[22u], nn_buf.data[23u]), f16vec2(nn_buf.data[3462u], nn_buf.data[3463u]))))))))));
    f16vec2 _1936 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[598u], nn_buf.data[599u]), _1925), f16vec2(float16_t(0.0)));
    f16vec2 _1939 = f16vec2(_1936.x);
    f16vec2 _1940 = f16vec2(_1936.y);
    f16vec2 _2165 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[536u], nn_buf.data[537u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[472u], nn_buf.data[473u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[408u], nn_buf.data[409u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[344u], nn_buf.data[345u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[280u], nn_buf.data[281u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[216u], nn_buf.data[217u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[152u], nn_buf.data[153u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[88u], nn_buf.data[89u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[24u], nn_buf.data[25u]), f16vec2(nn_buf.data[3464u], nn_buf.data[3465u]))))))))));
    f16vec2 _2176 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[600u], nn_buf.data[601u]), _2165), f16vec2(float16_t(0.0)));
    f16vec2 _2179 = f16vec2(_2176.x);
    f16vec2 _2180 = f16vec2(_2176.y);
    f16vec2 _2196 = fma(_2180, f16vec2(nn_buf.data[800u], nn_buf.data[801u]), fma(_2179, f16vec2(nn_buf.data[784u], nn_buf.data[785u]), fma(_1940, f16vec2(nn_buf.data[768u], nn_buf.data[769u]), fma(_1939, f16vec2(nn_buf.data[752u], nn_buf.data[753u]), fma(_1700, f16vec2(nn_buf.data[736u], nn_buf.data[737u]), fma(_1699, f16vec2(nn_buf.data[720u], nn_buf.data[721u]), fma(_1460, f16vec2(nn_buf.data[704u], nn_buf.data[705u]), fma(_1459, f16vec2(nn_buf.data[688u], nn_buf.data[689u]), fma(_1220, f16vec2(nn_buf.data[672u], nn_buf.data[673u]), fma(_1219, f16vec2(nn_buf.data[656u], nn_buf.data[657u]), f16vec2(nn_buf.data[3584u], nn_buf.data[3585u])))))))))));
    f16vec2 _2212 = fma(_2180, f16vec2(nn_buf.data[802u], nn_buf.data[803u]), fma(_2179, f16vec2(nn_buf.data[786u], nn_buf.data[787u]), fma(_1940, f16vec2(nn_buf.data[770u], nn_buf.data[771u]), fma(_1939, f16vec2(nn_buf.data[754u], nn_buf.data[755u]), fma(_1700, f16vec2(nn_buf.data[738u], nn_buf.data[739u]), fma(_1699, f16vec2(nn_buf.data[722u], nn_buf.data[723u]), fma(_1460, f16vec2(nn_buf.data[706u], nn_buf.data[707u]), fma(_1459, f16vec2(nn_buf.data[690u], nn_buf.data[691u]), fma(_1220, f16vec2(nn_buf.data[674u], nn_buf.data[675u]), fma(_1219, f16vec2(nn_buf.data[658u], nn_buf.data[659u]), f16vec2(nn_buf.data[3586u], nn_buf.data[3587u])))))))))));
    f16vec2 _2228 = fma(_2180, f16vec2(nn_buf.data[804u], nn_buf.data[805u]), fma(_2179, f16vec2(nn_buf.data[788u], nn_buf.data[789u]), fma(_1940, f16vec2(nn_buf.data[772u], nn_buf.data[773u]), fma(_1939, f16vec2(nn_buf.data[756u], nn_buf.data[757u]), fma(_1700, f16vec2(nn_buf.data[740u], nn_buf.data[741u]), fma(_1699, f16vec2(nn_buf.data[724u], nn_buf.data[725u]), fma(_1460, f16vec2(nn_buf.data[708u], nn_buf.data[709u]), fma(_1459, f16vec2(nn_buf.data[692u], nn_buf.data[693u]), fma(_1220, f16vec2(nn_buf.data[676u], nn_buf.data[677u]), fma(_1219, f16vec2(nn_buf.data[660u], nn_buf.data[661u]), f16vec2(nn_buf.data[3588u], nn_buf.data[3589u])))))))))));
    f16vec2 _2244 = fma(_2180, f16vec2(nn_buf.data[806u], nn_buf.data[807u]), fma(_2179, f16vec2(nn_buf.data[790u], nn_buf.data[791u]), fma(_1940, f16vec2(nn_buf.data[774u], nn_buf.data[775u]), fma(_1939, f16vec2(nn_buf.data[758u], nn_buf.data[759u]), fma(_1700, f16vec2(nn_buf.data[742u], nn_buf.data[743u]), fma(_1699, f16vec2(nn_buf.data[726u], nn_buf.data[727u]), fma(_1460, f16vec2(nn_buf.data[710u], nn_buf.data[711u]), fma(_1459, f16vec2(nn_buf.data[694u], nn_buf.data[695u]), fma(_1220, f16vec2(nn_buf.data[678u], nn_buf.data[679u]), fma(_1219, f16vec2(nn_buf.data[662u], nn_buf.data[663u]), f16vec2(nn_buf.data[3590u], nn_buf.data[3591u])))))))))));
    f16vec2 _2260 = fma(_2180, f16vec2(nn_buf.data[808u], nn_buf.data[809u]), fma(_2179, f16vec2(nn_buf.data[792u], nn_buf.data[793u]), fma(_1940, f16vec2(nn_buf.data[776u], nn_buf.data[777u]), fma(_1939, f16vec2(nn_buf.data[760u], nn_buf.data[761u]), fma(_1700, f16vec2(nn_buf.data[744u], nn_buf.data[745u]), fma(_1699, f16vec2(nn_buf.data[728u], nn_buf.data[729u]), fma(_1460, f16vec2(nn_buf.data[712u], nn_buf.data[713u]), fma(_1459, f16vec2(nn_buf.data[696u], nn_buf.data[697u]), fma(_1220, f16vec2(nn_buf.data[680u], nn_buf.data[681u]), fma(_1219, f16vec2(nn_buf.data[664u], nn_buf.data[665u]), f16vec2(nn_buf.data[3592u], nn_buf.data[3593u])))))))))));
    f16vec2 _2276 = fma(_2180, f16vec2(nn_buf.data[810u], nn_buf.data[811u]), fma(_2179, f16vec2(nn_buf.data[794u], nn_buf.data[795u]), fma(_1940, f16vec2(nn_buf.data[778u], nn_buf.data[779u]), fma(_1939, f16vec2(nn_buf.data[762u], nn_buf.data[763u]), fma(_1700, f16vec2(nn_buf.data[746u], nn_buf.data[747u]), fma(_1699, f16vec2(nn_buf.data[730u], nn_buf.data[731u]), fma(_1460, f16vec2(nn_buf.data[714u], nn_buf.data[715u]), fma(_1459, f16vec2(nn_buf.data[698u], nn_buf.data[699u]), fma(_1220, f16vec2(nn_buf.data[682u], nn_buf.data[683u]), fma(_1219, f16vec2(nn_buf.data[666u], nn_buf.data[667u]), f16vec2(nn_buf.data[3594u], nn_buf.data[3595u])))))))))));
    f16vec2 _2292 = fma(_2180, f16vec2(nn_buf.data[812u], nn_buf.data[813u]), fma(_2179, f16vec2(nn_buf.data[796u], nn_buf.data[797u]), fma(_1940, f16vec2(nn_buf.data[780u], nn_buf.data[781u]), fma(_1939, f16vec2(nn_buf.data[764u], nn_buf.data[765u]), fma(_1700, f16vec2(nn_buf.data[748u], nn_buf.data[749u]), fma(_1699, f16vec2(nn_buf.data[732u], nn_buf.data[733u]), fma(_1460, f16vec2(nn_buf.data[716u], nn_buf.data[717u]), fma(_1459, f16vec2(nn_buf.data[700u], nn_buf.data[701u]), fma(_1220, f16vec2(nn_buf.data[684u], nn_buf.data[685u]), fma(_1219, f16vec2(nn_buf.data[668u], nn_buf.data[669u]), f16vec2(nn_buf.data[3596u], nn_buf.data[3597u])))))))))));
    f16vec2 _2308 = fma(_2180, f16vec2(nn_buf.data[814u], nn_buf.data[815u]), fma(_2179, f16vec2(nn_buf.data[798u], nn_buf.data[799u]), fma(_1940, f16vec2(nn_buf.data[782u], nn_buf.data[783u]), fma(_1939, f16vec2(nn_buf.data[766u], nn_buf.data[767u]), fma(_1700, f16vec2(nn_buf.data[750u], nn_buf.data[751u]), fma(_1699, f16vec2(nn_buf.data[734u], nn_buf.data[735u]), fma(_1460, f16vec2(nn_buf.data[718u], nn_buf.data[719u]), fma(_1459, f16vec2(nn_buf.data[702u], nn_buf.data[703u]), fma(_1220, f16vec2(nn_buf.data[686u], nn_buf.data[687u]), fma(_1219, f16vec2(nn_buf.data[670u], nn_buf.data[671u]), f16vec2(nn_buf.data[3598u], nn_buf.data[3599u])))))))))));
    f16vec2 _2405 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[538u], nn_buf.data[539u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[474u], nn_buf.data[475u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[410u], nn_buf.data[411u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[346u], nn_buf.data[347u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[282u], nn_buf.data[283u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[218u], nn_buf.data[219u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[154u], nn_buf.data[155u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[90u], nn_buf.data[91u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[26u], nn_buf.data[27u]), f16vec2(nn_buf.data[3466u], nn_buf.data[3467u]))))))))));
    f16vec2 _2416 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[602u], nn_buf.data[603u]), _2405), f16vec2(float16_t(0.0)));
    f16vec2 _2419 = f16vec2(_2416.x);
    f16vec2 _2420 = f16vec2(_2416.y);
    f16vec2 _2645 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[540u], nn_buf.data[541u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[476u], nn_buf.data[477u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[412u], nn_buf.data[413u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[348u], nn_buf.data[349u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[284u], nn_buf.data[285u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[220u], nn_buf.data[221u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[156u], nn_buf.data[157u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[92u], nn_buf.data[93u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[28u], nn_buf.data[29u]), f16vec2(nn_buf.data[3468u], nn_buf.data[3469u]))))))))));
    f16vec2 _2656 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[604u], nn_buf.data[605u]), _2645), f16vec2(float16_t(0.0)));
    f16vec2 _2659 = f16vec2(_2656.x);
    f16vec2 _2660 = f16vec2(_2656.y);
    f16vec2 _2885 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[542u], nn_buf.data[543u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[478u], nn_buf.data[479u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[414u], nn_buf.data[415u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[350u], nn_buf.data[351u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[286u], nn_buf.data[287u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[222u], nn_buf.data[223u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[158u], nn_buf.data[159u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[94u], nn_buf.data[95u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[30u], nn_buf.data[31u]), f16vec2(nn_buf.data[3470u], nn_buf.data[3471u]))))))))));
    f16vec2 _2896 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[606u], nn_buf.data[607u]), _2885), f16vec2(float16_t(0.0)));
    f16vec2 _2899 = f16vec2(_2896.x);
    f16vec2 _2900 = f16vec2(_2896.y);
    f16vec2 _3125 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[544u], nn_buf.data[545u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[480u], nn_buf.data[481u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[416u], nn_buf.data[417u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[352u], nn_buf.data[353u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[288u], nn_buf.data[289u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[224u], nn_buf.data[225u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[160u], nn_buf.data[161u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[96u], nn_buf.data[97u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[32u], nn_buf.data[33u]), f16vec2(nn_buf.data[3472u], nn_buf.data[3473u]))))))))));
    f16vec2 _3136 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[608u], nn_buf.data[609u]), _3125), f16vec2(float16_t(0.0)));
    f16vec2 _3139 = f16vec2(_3136.x);
    f16vec2 _3140 = f16vec2(_3136.y);
    f16vec2 _3365 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[546u], nn_buf.data[547u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[482u], nn_buf.data[483u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[418u], nn_buf.data[419u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[354u], nn_buf.data[355u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[290u], nn_buf.data[291u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[226u], nn_buf.data[227u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[162u], nn_buf.data[163u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[98u], nn_buf.data[99u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[34u], nn_buf.data[35u]), f16vec2(nn_buf.data[3474u], nn_buf.data[3475u]))))))))));
    f16vec2 _3376 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[610u], nn_buf.data[611u]), _3365), f16vec2(float16_t(0.0)));
    f16vec2 _3379 = f16vec2(_3376.x);
    f16vec2 _3380 = f16vec2(_3376.y);
    f16vec2 _3396 = fma(_3380, f16vec2(nn_buf.data[960u], nn_buf.data[961u]), fma(_3379, f16vec2(nn_buf.data[944u], nn_buf.data[945u]), fma(_3140, f16vec2(nn_buf.data[928u], nn_buf.data[929u]), fma(_3139, f16vec2(nn_buf.data[912u], nn_buf.data[913u]), fma(_2900, f16vec2(nn_buf.data[896u], nn_buf.data[897u]), fma(_2899, f16vec2(nn_buf.data[880u], nn_buf.data[881u]), fma(_2660, f16vec2(nn_buf.data[864u], nn_buf.data[865u]), fma(_2659, f16vec2(nn_buf.data[848u], nn_buf.data[849u]), fma(_2420, f16vec2(nn_buf.data[832u], nn_buf.data[833u]), fma(_2419, f16vec2(nn_buf.data[816u], nn_buf.data[817u]), _2196))))))))));
    f16vec2 _3412 = fma(_3380, f16vec2(nn_buf.data[962u], nn_buf.data[963u]), fma(_3379, f16vec2(nn_buf.data[946u], nn_buf.data[947u]), fma(_3140, f16vec2(nn_buf.data[930u], nn_buf.data[931u]), fma(_3139, f16vec2(nn_buf.data[914u], nn_buf.data[915u]), fma(_2900, f16vec2(nn_buf.data[898u], nn_buf.data[899u]), fma(_2899, f16vec2(nn_buf.data[882u], nn_buf.data[883u]), fma(_2660, f16vec2(nn_buf.data[866u], nn_buf.data[867u]), fma(_2659, f16vec2(nn_buf.data[850u], nn_buf.data[851u]), fma(_2420, f16vec2(nn_buf.data[834u], nn_buf.data[835u]), fma(_2419, f16vec2(nn_buf.data[818u], nn_buf.data[819u]), _2212))))))))));
    f16vec2 _3428 = fma(_3380, f16vec2(nn_buf.data[964u], nn_buf.data[965u]), fma(_3379, f16vec2(nn_buf.data[948u], nn_buf.data[949u]), fma(_3140, f16vec2(nn_buf.data[932u], nn_buf.data[933u]), fma(_3139, f16vec2(nn_buf.data[916u], nn_buf.data[917u]), fma(_2900, f16vec2(nn_buf.data[900u], nn_buf.data[901u]), fma(_2899, f16vec2(nn_buf.data[884u], nn_buf.data[885u]), fma(_2660, f16vec2(nn_buf.data[868u], nn_buf.data[869u]), fma(_2659, f16vec2(nn_buf.data[852u], nn_buf.data[853u]), fma(_2420, f16vec2(nn_buf.data[836u], nn_buf.data[837u]), fma(_2419, f16vec2(nn_buf.data[820u], nn_buf.data[821u]), _2228))))))))));
    f16vec2 _3444 = fma(_3380, f16vec2(nn_buf.data[966u], nn_buf.data[967u]), fma(_3379, f16vec2(nn_buf.data[950u], nn_buf.data[951u]), fma(_3140, f16vec2(nn_buf.data[934u], nn_buf.data[935u]), fma(_3139, f16vec2(nn_buf.data[918u], nn_buf.data[919u]), fma(_2900, f16vec2(nn_buf.data[902u], nn_buf.data[903u]), fma(_2899, f16vec2(nn_buf.data[886u], nn_buf.data[887u]), fma(_2660, f16vec2(nn_buf.data[870u], nn_buf.data[871u]), fma(_2659, f16vec2(nn_buf.data[854u], nn_buf.data[855u]), fma(_2420, f16vec2(nn_buf.data[838u], nn_buf.data[839u]), fma(_2419, f16vec2(nn_buf.data[822u], nn_buf.data[823u]), _2244))))))))));
    f16vec2 _3460 = fma(_3380, f16vec2(nn_buf.data[968u], nn_buf.data[969u]), fma(_3379, f16vec2(nn_buf.data[952u], nn_buf.data[953u]), fma(_3140, f16vec2(nn_buf.data[936u], nn_buf.data[937u]), fma(_3139, f16vec2(nn_buf.data[920u], nn_buf.data[921u]), fma(_2900, f16vec2(nn_buf.data[904u], nn_buf.data[905u]), fma(_2899, f16vec2(nn_buf.data[888u], nn_buf.data[889u]), fma(_2660, f16vec2(nn_buf.data[872u], nn_buf.data[873u]), fma(_2659, f16vec2(nn_buf.data[856u], nn_buf.data[857u]), fma(_2420, f16vec2(nn_buf.data[840u], nn_buf.data[841u]), fma(_2419, f16vec2(nn_buf.data[824u], nn_buf.data[825u]), _2260))))))))));
    f16vec2 _3476 = fma(_3380, f16vec2(nn_buf.data[970u], nn_buf.data[971u]), fma(_3379, f16vec2(nn_buf.data[954u], nn_buf.data[955u]), fma(_3140, f16vec2(nn_buf.data[938u], nn_buf.data[939u]), fma(_3139, f16vec2(nn_buf.data[922u], nn_buf.data[923u]), fma(_2900, f16vec2(nn_buf.data[906u], nn_buf.data[907u]), fma(_2899, f16vec2(nn_buf.data[890u], nn_buf.data[891u]), fma(_2660, f16vec2(nn_buf.data[874u], nn_buf.data[875u]), fma(_2659, f16vec2(nn_buf.data[858u], nn_buf.data[859u]), fma(_2420, f16vec2(nn_buf.data[842u], nn_buf.data[843u]), fma(_2419, f16vec2(nn_buf.data[826u], nn_buf.data[827u]), _2276))))))))));
    f16vec2 _3492 = fma(_3380, f16vec2(nn_buf.data[972u], nn_buf.data[973u]), fma(_3379, f16vec2(nn_buf.data[956u], nn_buf.data[957u]), fma(_3140, f16vec2(nn_buf.data[940u], nn_buf.data[941u]), fma(_3139, f16vec2(nn_buf.data[924u], nn_buf.data[925u]), fma(_2900, f16vec2(nn_buf.data[908u], nn_buf.data[909u]), fma(_2899, f16vec2(nn_buf.data[892u], nn_buf.data[893u]), fma(_2660, f16vec2(nn_buf.data[876u], nn_buf.data[877u]), fma(_2659, f16vec2(nn_buf.data[860u], nn_buf.data[861u]), fma(_2420, f16vec2(nn_buf.data[844u], nn_buf.data[845u]), fma(_2419, f16vec2(nn_buf.data[828u], nn_buf.data[829u]), _2292))))))))));
    f16vec2 _3508 = fma(_3380, f16vec2(nn_buf.data[974u], nn_buf.data[975u]), fma(_3379, f16vec2(nn_buf.data[958u], nn_buf.data[959u]), fma(_3140, f16vec2(nn_buf.data[942u], nn_buf.data[943u]), fma(_3139, f16vec2(nn_buf.data[926u], nn_buf.data[927u]), fma(_2900, f16vec2(nn_buf.data[910u], nn_buf.data[911u]), fma(_2899, f16vec2(nn_buf.data[894u], nn_buf.data[895u]), fma(_2660, f16vec2(nn_buf.data[878u], nn_buf.data[879u]), fma(_2659, f16vec2(nn_buf.data[862u], nn_buf.data[863u]), fma(_2420, f16vec2(nn_buf.data[846u], nn_buf.data[847u]), fma(_2419, f16vec2(nn_buf.data[830u], nn_buf.data[831u]), _2308))))))))));
    f16vec2 _3605 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[548u], nn_buf.data[549u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[484u], nn_buf.data[485u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[420u], nn_buf.data[421u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[356u], nn_buf.data[357u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[292u], nn_buf.data[293u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[228u], nn_buf.data[229u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[164u], nn_buf.data[165u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[100u], nn_buf.data[101u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[36u], nn_buf.data[37u]), f16vec2(nn_buf.data[3476u], nn_buf.data[3477u]))))))))));
    f16vec2 _3616 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[612u], nn_buf.data[613u]), _3605), f16vec2(float16_t(0.0)));
    f16vec2 _3619 = f16vec2(_3616.x);
    f16vec2 _3620 = f16vec2(_3616.y);
    f16vec2 _3845 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[550u], nn_buf.data[551u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[486u], nn_buf.data[487u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[422u], nn_buf.data[423u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[358u], nn_buf.data[359u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[294u], nn_buf.data[295u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[230u], nn_buf.data[231u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[166u], nn_buf.data[167u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[102u], nn_buf.data[103u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[38u], nn_buf.data[39u]), f16vec2(nn_buf.data[3478u], nn_buf.data[3479u]))))))))));
    f16vec2 _3856 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[614u], nn_buf.data[615u]), _3845), f16vec2(float16_t(0.0)));
    f16vec2 _3859 = f16vec2(_3856.x);
    f16vec2 _3860 = f16vec2(_3856.y);
    f16vec2 _4085 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[552u], nn_buf.data[553u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[488u], nn_buf.data[489u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[424u], nn_buf.data[425u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[360u], nn_buf.data[361u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[296u], nn_buf.data[297u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[232u], nn_buf.data[233u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[168u], nn_buf.data[169u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[104u], nn_buf.data[105u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[40u], nn_buf.data[41u]), f16vec2(nn_buf.data[3480u], nn_buf.data[3481u]))))))))));
    f16vec2 _4096 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[616u], nn_buf.data[617u]), _4085), f16vec2(float16_t(0.0)));
    f16vec2 _4099 = f16vec2(_4096.x);
    f16vec2 _4100 = f16vec2(_4096.y);
    f16vec2 _4325 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[554u], nn_buf.data[555u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[490u], nn_buf.data[491u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[426u], nn_buf.data[427u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[362u], nn_buf.data[363u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[298u], nn_buf.data[299u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[234u], nn_buf.data[235u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[170u], nn_buf.data[171u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[106u], nn_buf.data[107u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[42u], nn_buf.data[43u]), f16vec2(nn_buf.data[3482u], nn_buf.data[3483u]))))))))));
    f16vec2 _4336 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[618u], nn_buf.data[619u]), _4325), f16vec2(float16_t(0.0)));
    f16vec2 _4339 = f16vec2(_4336.x);
    f16vec2 _4340 = f16vec2(_4336.y);
    f16vec2 _4565 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[556u], nn_buf.data[557u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[492u], nn_buf.data[493u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[428u], nn_buf.data[429u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[364u], nn_buf.data[365u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[300u], nn_buf.data[301u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[236u], nn_buf.data[237u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[172u], nn_buf.data[173u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[108u], nn_buf.data[109u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[44u], nn_buf.data[45u]), f16vec2(nn_buf.data[3484u], nn_buf.data[3485u]))))))))));
    f16vec2 _4576 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[620u], nn_buf.data[621u]), _4565), f16vec2(float16_t(0.0)));
    f16vec2 _4579 = f16vec2(_4576.x);
    f16vec2 _4580 = f16vec2(_4576.y);
    f16vec2 _4596 = fma(_4580, f16vec2(nn_buf.data[1120u], nn_buf.data[1121u]), fma(_4579, f16vec2(nn_buf.data[1104u], nn_buf.data[1105u]), fma(_4340, f16vec2(nn_buf.data[1088u], nn_buf.data[1089u]), fma(_4339, f16vec2(nn_buf.data[1072u], nn_buf.data[1073u]), fma(_4100, f16vec2(nn_buf.data[1056u], nn_buf.data[1057u]), fma(_4099, f16vec2(nn_buf.data[1040u], nn_buf.data[1041u]), fma(_3860, f16vec2(nn_buf.data[1024u], nn_buf.data[1025u]), fma(_3859, f16vec2(nn_buf.data[1008u], nn_buf.data[1009u]), fma(_3620, f16vec2(nn_buf.data[992u], nn_buf.data[993u]), fma(_3619, f16vec2(nn_buf.data[976u], nn_buf.data[977u]), _3396))))))))));
    f16vec2 _4612 = fma(_4580, f16vec2(nn_buf.data[1122u], nn_buf.data[1123u]), fma(_4579, f16vec2(nn_buf.data[1106u], nn_buf.data[1107u]), fma(_4340, f16vec2(nn_buf.data[1090u], nn_buf.data[1091u]), fma(_4339, f16vec2(nn_buf.data[1074u], nn_buf.data[1075u]), fma(_4100, f16vec2(nn_buf.data[1058u], nn_buf.data[1059u]), fma(_4099, f16vec2(nn_buf.data[1042u], nn_buf.data[1043u]), fma(_3860, f16vec2(nn_buf.data[1026u], nn_buf.data[1027u]), fma(_3859, f16vec2(nn_buf.data[1010u], nn_buf.data[1011u]), fma(_3620, f16vec2(nn_buf.data[994u], nn_buf.data[995u]), fma(_3619, f16vec2(nn_buf.data[978u], nn_buf.data[979u]), _3412))))))))));
    f16vec2 _4628 = fma(_4580, f16vec2(nn_buf.data[1124u], nn_buf.data[1125u]), fma(_4579, f16vec2(nn_buf.data[1108u], nn_buf.data[1109u]), fma(_4340, f16vec2(nn_buf.data[1092u], nn_buf.data[1093u]), fma(_4339, f16vec2(nn_buf.data[1076u], nn_buf.data[1077u]), fma(_4100, f16vec2(nn_buf.data[1060u], nn_buf.data[1061u]), fma(_4099, f16vec2(nn_buf.data[1044u], nn_buf.data[1045u]), fma(_3860, f16vec2(nn_buf.data[1028u], nn_buf.data[1029u]), fma(_3859, f16vec2(nn_buf.data[1012u], nn_buf.data[1013u]), fma(_3620, f16vec2(nn_buf.data[996u], nn_buf.data[997u]), fma(_3619, f16vec2(nn_buf.data[980u], nn_buf.data[981u]), _3428))))))))));
    f16vec2 _4644 = fma(_4580, f16vec2(nn_buf.data[1126u], nn_buf.data[1127u]), fma(_4579, f16vec2(nn_buf.data[1110u], nn_buf.data[1111u]), fma(_4340, f16vec2(nn_buf.data[1094u], nn_buf.data[1095u]), fma(_4339, f16vec2(nn_buf.data[1078u], nn_buf.data[1079u]), fma(_4100, f16vec2(nn_buf.data[1062u], nn_buf.data[1063u]), fma(_4099, f16vec2(nn_buf.data[1046u], nn_buf.data[1047u]), fma(_3860, f16vec2(nn_buf.data[1030u], nn_buf.data[1031u]), fma(_3859, f16vec2(nn_buf.data[1014u], nn_buf.data[1015u]), fma(_3620, f16vec2(nn_buf.data[998u], nn_buf.data[999u]), fma(_3619, f16vec2(nn_buf.data[982u], nn_buf.data[983u]), _3444))))))))));
    f16vec2 _4660 = fma(_4580, f16vec2(nn_buf.data[1128u], nn_buf.data[1129u]), fma(_4579, f16vec2(nn_buf.data[1112u], nn_buf.data[1113u]), fma(_4340, f16vec2(nn_buf.data[1096u], nn_buf.data[1097u]), fma(_4339, f16vec2(nn_buf.data[1080u], nn_buf.data[1081u]), fma(_4100, f16vec2(nn_buf.data[1064u], nn_buf.data[1065u]), fma(_4099, f16vec2(nn_buf.data[1048u], nn_buf.data[1049u]), fma(_3860, f16vec2(nn_buf.data[1032u], nn_buf.data[1033u]), fma(_3859, f16vec2(nn_buf.data[1016u], nn_buf.data[1017u]), fma(_3620, f16vec2(nn_buf.data[1000u], nn_buf.data[1001u]), fma(_3619, f16vec2(nn_buf.data[984u], nn_buf.data[985u]), _3460))))))))));
    f16vec2 _4676 = fma(_4580, f16vec2(nn_buf.data[1130u], nn_buf.data[1131u]), fma(_4579, f16vec2(nn_buf.data[1114u], nn_buf.data[1115u]), fma(_4340, f16vec2(nn_buf.data[1098u], nn_buf.data[1099u]), fma(_4339, f16vec2(nn_buf.data[1082u], nn_buf.data[1083u]), fma(_4100, f16vec2(nn_buf.data[1066u], nn_buf.data[1067u]), fma(_4099, f16vec2(nn_buf.data[1050u], nn_buf.data[1051u]), fma(_3860, f16vec2(nn_buf.data[1034u], nn_buf.data[1035u]), fma(_3859, f16vec2(nn_buf.data[1018u], nn_buf.data[1019u]), fma(_3620, f16vec2(nn_buf.data[1002u], nn_buf.data[1003u]), fma(_3619, f16vec2(nn_buf.data[986u], nn_buf.data[987u]), _3476))))))))));
    f16vec2 _4692 = fma(_4580, f16vec2(nn_buf.data[1132u], nn_buf.data[1133u]), fma(_4579, f16vec2(nn_buf.data[1116u], nn_buf.data[1117u]), fma(_4340, f16vec2(nn_buf.data[1100u], nn_buf.data[1101u]), fma(_4339, f16vec2(nn_buf.data[1084u], nn_buf.data[1085u]), fma(_4100, f16vec2(nn_buf.data[1068u], nn_buf.data[1069u]), fma(_4099, f16vec2(nn_buf.data[1052u], nn_buf.data[1053u]), fma(_3860, f16vec2(nn_buf.data[1036u], nn_buf.data[1037u]), fma(_3859, f16vec2(nn_buf.data[1020u], nn_buf.data[1021u]), fma(_3620, f16vec2(nn_buf.data[1004u], nn_buf.data[1005u]), fma(_3619, f16vec2(nn_buf.data[988u], nn_buf.data[989u]), _3492))))))))));
    f16vec2 _4708 = fma(_4580, f16vec2(nn_buf.data[1134u], nn_buf.data[1135u]), fma(_4579, f16vec2(nn_buf.data[1118u], nn_buf.data[1119u]), fma(_4340, f16vec2(nn_buf.data[1102u], nn_buf.data[1103u]), fma(_4339, f16vec2(nn_buf.data[1086u], nn_buf.data[1087u]), fma(_4100, f16vec2(nn_buf.data[1070u], nn_buf.data[1071u]), fma(_4099, f16vec2(nn_buf.data[1054u], nn_buf.data[1055u]), fma(_3860, f16vec2(nn_buf.data[1038u], nn_buf.data[1039u]), fma(_3859, f16vec2(nn_buf.data[1022u], nn_buf.data[1023u]), fma(_3620, f16vec2(nn_buf.data[1006u], nn_buf.data[1007u]), fma(_3619, f16vec2(nn_buf.data[990u], nn_buf.data[991u]), _3508))))))))));
    f16vec2 _4805 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[558u], nn_buf.data[559u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[494u], nn_buf.data[495u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[430u], nn_buf.data[431u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[366u], nn_buf.data[367u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[302u], nn_buf.data[303u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[238u], nn_buf.data[239u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[174u], nn_buf.data[175u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[110u], nn_buf.data[111u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[46u], nn_buf.data[47u]), f16vec2(nn_buf.data[3486u], nn_buf.data[3487u]))))))))));
    f16vec2 _4816 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[622u], nn_buf.data[623u]), _4805), f16vec2(float16_t(0.0)));
    f16vec2 _4819 = f16vec2(_4816.x);
    f16vec2 _4820 = f16vec2(_4816.y);
    f16vec2 _5045 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[560u], nn_buf.data[561u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[496u], nn_buf.data[497u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[432u], nn_buf.data[433u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[368u], nn_buf.data[369u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[304u], nn_buf.data[305u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[240u], nn_buf.data[241u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[176u], nn_buf.data[177u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[112u], nn_buf.data[113u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[48u], nn_buf.data[49u]), f16vec2(nn_buf.data[3488u], nn_buf.data[3489u]))))))))));
    f16vec2 _5056 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[624u], nn_buf.data[625u]), _5045), f16vec2(float16_t(0.0)));
    f16vec2 _5059 = f16vec2(_5056.x);
    f16vec2 _5060 = f16vec2(_5056.y);
    f16vec2 _5285 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[562u], nn_buf.data[563u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[498u], nn_buf.data[499u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[434u], nn_buf.data[435u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[370u], nn_buf.data[371u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[306u], nn_buf.data[307u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[242u], nn_buf.data[243u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[178u], nn_buf.data[179u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[114u], nn_buf.data[115u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[50u], nn_buf.data[51u]), f16vec2(nn_buf.data[3490u], nn_buf.data[3491u]))))))))));
    f16vec2 _5296 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[626u], nn_buf.data[627u]), _5285), f16vec2(float16_t(0.0)));
    f16vec2 _5299 = f16vec2(_5296.x);
    f16vec2 _5300 = f16vec2(_5296.y);
    f16vec2 _5525 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[564u], nn_buf.data[565u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[500u], nn_buf.data[501u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[436u], nn_buf.data[437u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[372u], nn_buf.data[373u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[308u], nn_buf.data[309u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[244u], nn_buf.data[245u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[180u], nn_buf.data[181u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[116u], nn_buf.data[117u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[52u], nn_buf.data[53u]), f16vec2(nn_buf.data[3492u], nn_buf.data[3493u]))))))))));
    f16vec2 _5536 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[628u], nn_buf.data[629u]), _5525), f16vec2(float16_t(0.0)));
    f16vec2 _5539 = f16vec2(_5536.x);
    f16vec2 _5540 = f16vec2(_5536.y);
    f16vec2 _5765 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[566u], nn_buf.data[567u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[502u], nn_buf.data[503u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[438u], nn_buf.data[439u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[374u], nn_buf.data[375u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[310u], nn_buf.data[311u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[246u], nn_buf.data[247u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[182u], nn_buf.data[183u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[118u], nn_buf.data[119u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[54u], nn_buf.data[55u]), f16vec2(nn_buf.data[3494u], nn_buf.data[3495u]))))))))));
    f16vec2 _5776 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[630u], nn_buf.data[631u]), _5765), f16vec2(float16_t(0.0)));
    f16vec2 _5779 = f16vec2(_5776.x);
    f16vec2 _5780 = f16vec2(_5776.y);
    f16vec2 _5796 = fma(_5780, f16vec2(nn_buf.data[1280u], nn_buf.data[1281u]), fma(_5779, f16vec2(nn_buf.data[1264u], nn_buf.data[1265u]), fma(_5540, f16vec2(nn_buf.data[1248u], nn_buf.data[1249u]), fma(_5539, f16vec2(nn_buf.data[1232u], nn_buf.data[1233u]), fma(_5300, f16vec2(nn_buf.data[1216u], nn_buf.data[1217u]), fma(_5299, f16vec2(nn_buf.data[1200u], nn_buf.data[1201u]), fma(_5060, f16vec2(nn_buf.data[1184u], nn_buf.data[1185u]), fma(_5059, f16vec2(nn_buf.data[1168u], nn_buf.data[1169u]), fma(_4820, f16vec2(nn_buf.data[1152u], nn_buf.data[1153u]), fma(_4819, f16vec2(nn_buf.data[1136u], nn_buf.data[1137u]), _4596))))))))));
    f16vec2 _5812 = fma(_5780, f16vec2(nn_buf.data[1282u], nn_buf.data[1283u]), fma(_5779, f16vec2(nn_buf.data[1266u], nn_buf.data[1267u]), fma(_5540, f16vec2(nn_buf.data[1250u], nn_buf.data[1251u]), fma(_5539, f16vec2(nn_buf.data[1234u], nn_buf.data[1235u]), fma(_5300, f16vec2(nn_buf.data[1218u], nn_buf.data[1219u]), fma(_5299, f16vec2(nn_buf.data[1202u], nn_buf.data[1203u]), fma(_5060, f16vec2(nn_buf.data[1186u], nn_buf.data[1187u]), fma(_5059, f16vec2(nn_buf.data[1170u], nn_buf.data[1171u]), fma(_4820, f16vec2(nn_buf.data[1154u], nn_buf.data[1155u]), fma(_4819, f16vec2(nn_buf.data[1138u], nn_buf.data[1139u]), _4612))))))))));
    f16vec2 _5828 = fma(_5780, f16vec2(nn_buf.data[1284u], nn_buf.data[1285u]), fma(_5779, f16vec2(nn_buf.data[1268u], nn_buf.data[1269u]), fma(_5540, f16vec2(nn_buf.data[1252u], nn_buf.data[1253u]), fma(_5539, f16vec2(nn_buf.data[1236u], nn_buf.data[1237u]), fma(_5300, f16vec2(nn_buf.data[1220u], nn_buf.data[1221u]), fma(_5299, f16vec2(nn_buf.data[1204u], nn_buf.data[1205u]), fma(_5060, f16vec2(nn_buf.data[1188u], nn_buf.data[1189u]), fma(_5059, f16vec2(nn_buf.data[1172u], nn_buf.data[1173u]), fma(_4820, f16vec2(nn_buf.data[1156u], nn_buf.data[1157u]), fma(_4819, f16vec2(nn_buf.data[1140u], nn_buf.data[1141u]), _4628))))))))));
    f16vec2 _5844 = fma(_5780, f16vec2(nn_buf.data[1286u], nn_buf.data[1287u]), fma(_5779, f16vec2(nn_buf.data[1270u], nn_buf.data[1271u]), fma(_5540, f16vec2(nn_buf.data[1254u], nn_buf.data[1255u]), fma(_5539, f16vec2(nn_buf.data[1238u], nn_buf.data[1239u]), fma(_5300, f16vec2(nn_buf.data[1222u], nn_buf.data[1223u]), fma(_5299, f16vec2(nn_buf.data[1206u], nn_buf.data[1207u]), fma(_5060, f16vec2(nn_buf.data[1190u], nn_buf.data[1191u]), fma(_5059, f16vec2(nn_buf.data[1174u], nn_buf.data[1175u]), fma(_4820, f16vec2(nn_buf.data[1158u], nn_buf.data[1159u]), fma(_4819, f16vec2(nn_buf.data[1142u], nn_buf.data[1143u]), _4644))))))))));
    f16vec2 _5860 = fma(_5780, f16vec2(nn_buf.data[1288u], nn_buf.data[1289u]), fma(_5779, f16vec2(nn_buf.data[1272u], nn_buf.data[1273u]), fma(_5540, f16vec2(nn_buf.data[1256u], nn_buf.data[1257u]), fma(_5539, f16vec2(nn_buf.data[1240u], nn_buf.data[1241u]), fma(_5300, f16vec2(nn_buf.data[1224u], nn_buf.data[1225u]), fma(_5299, f16vec2(nn_buf.data[1208u], nn_buf.data[1209u]), fma(_5060, f16vec2(nn_buf.data[1192u], nn_buf.data[1193u]), fma(_5059, f16vec2(nn_buf.data[1176u], nn_buf.data[1177u]), fma(_4820, f16vec2(nn_buf.data[1160u], nn_buf.data[1161u]), fma(_4819, f16vec2(nn_buf.data[1144u], nn_buf.data[1145u]), _4660))))))))));
    f16vec2 _5876 = fma(_5780, f16vec2(nn_buf.data[1290u], nn_buf.data[1291u]), fma(_5779, f16vec2(nn_buf.data[1274u], nn_buf.data[1275u]), fma(_5540, f16vec2(nn_buf.data[1258u], nn_buf.data[1259u]), fma(_5539, f16vec2(nn_buf.data[1242u], nn_buf.data[1243u]), fma(_5300, f16vec2(nn_buf.data[1226u], nn_buf.data[1227u]), fma(_5299, f16vec2(nn_buf.data[1210u], nn_buf.data[1211u]), fma(_5060, f16vec2(nn_buf.data[1194u], nn_buf.data[1195u]), fma(_5059, f16vec2(nn_buf.data[1178u], nn_buf.data[1179u]), fma(_4820, f16vec2(nn_buf.data[1162u], nn_buf.data[1163u]), fma(_4819, f16vec2(nn_buf.data[1146u], nn_buf.data[1147u]), _4676))))))))));
    f16vec2 _5892 = fma(_5780, f16vec2(nn_buf.data[1292u], nn_buf.data[1293u]), fma(_5779, f16vec2(nn_buf.data[1276u], nn_buf.data[1277u]), fma(_5540, f16vec2(nn_buf.data[1260u], nn_buf.data[1261u]), fma(_5539, f16vec2(nn_buf.data[1244u], nn_buf.data[1245u]), fma(_5300, f16vec2(nn_buf.data[1228u], nn_buf.data[1229u]), fma(_5299, f16vec2(nn_buf.data[1212u], nn_buf.data[1213u]), fma(_5060, f16vec2(nn_buf.data[1196u], nn_buf.data[1197u]), fma(_5059, f16vec2(nn_buf.data[1180u], nn_buf.data[1181u]), fma(_4820, f16vec2(nn_buf.data[1164u], nn_buf.data[1165u]), fma(_4819, f16vec2(nn_buf.data[1148u], nn_buf.data[1149u]), _4692))))))))));
    f16vec2 _5908 = fma(_5780, f16vec2(nn_buf.data[1294u], nn_buf.data[1295u]), fma(_5779, f16vec2(nn_buf.data[1278u], nn_buf.data[1279u]), fma(_5540, f16vec2(nn_buf.data[1262u], nn_buf.data[1263u]), fma(_5539, f16vec2(nn_buf.data[1246u], nn_buf.data[1247u]), fma(_5300, f16vec2(nn_buf.data[1230u], nn_buf.data[1231u]), fma(_5299, f16vec2(nn_buf.data[1214u], nn_buf.data[1215u]), fma(_5060, f16vec2(nn_buf.data[1198u], nn_buf.data[1199u]), fma(_5059, f16vec2(nn_buf.data[1182u], nn_buf.data[1183u]), fma(_4820, f16vec2(nn_buf.data[1166u], nn_buf.data[1167u]), fma(_4819, f16vec2(nn_buf.data[1150u], nn_buf.data[1151u]), _4708))))))))));
    f16vec2 _6005 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[568u], nn_buf.data[569u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[504u], nn_buf.data[505u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[440u], nn_buf.data[441u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[376u], nn_buf.data[377u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[312u], nn_buf.data[313u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[248u], nn_buf.data[249u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[184u], nn_buf.data[185u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[120u], nn_buf.data[121u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[56u], nn_buf.data[57u]), f16vec2(nn_buf.data[3496u], nn_buf.data[3497u]))))))))));
    f16vec2 _6016 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[632u], nn_buf.data[633u]), _6005), f16vec2(float16_t(0.0)));
    f16vec2 _6019 = f16vec2(_6016.x);
    f16vec2 _6020 = f16vec2(_6016.y);
    f16vec2 _6245 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[570u], nn_buf.data[571u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[506u], nn_buf.data[507u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[442u], nn_buf.data[443u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[378u], nn_buf.data[379u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[314u], nn_buf.data[315u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[250u], nn_buf.data[251u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[186u], nn_buf.data[187u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[122u], nn_buf.data[123u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[58u], nn_buf.data[59u]), f16vec2(nn_buf.data[3498u], nn_buf.data[3499u]))))))))));
    f16vec2 _6256 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[634u], nn_buf.data[635u]), _6245), f16vec2(float16_t(0.0)));
    f16vec2 _6259 = f16vec2(_6256.x);
    f16vec2 _6260 = f16vec2(_6256.y);
    f16vec2 _6485 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[572u], nn_buf.data[573u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[508u], nn_buf.data[509u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[444u], nn_buf.data[445u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[380u], nn_buf.data[381u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[316u], nn_buf.data[317u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[252u], nn_buf.data[253u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[188u], nn_buf.data[189u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[124u], nn_buf.data[125u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[60u], nn_buf.data[61u]), f16vec2(nn_buf.data[3500u], nn_buf.data[3501u]))))))))));
    f16vec2 _6496 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[636u], nn_buf.data[637u]), _6485), f16vec2(float16_t(0.0)));
    f16vec2 _6499 = f16vec2(_6496.x);
    f16vec2 _6500 = f16vec2(_6496.y);
    f16vec2 _6725 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[574u], nn_buf.data[575u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[510u], nn_buf.data[511u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[446u], nn_buf.data[447u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[382u], nn_buf.data[383u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[318u], nn_buf.data[319u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[254u], nn_buf.data[255u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[190u], nn_buf.data[191u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[126u], nn_buf.data[127u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[62u], nn_buf.data[63u]), f16vec2(nn_buf.data[3502u], nn_buf.data[3503u]))))))))));
    f16vec2 _6736 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[638u], nn_buf.data[639u]), _6725), f16vec2(float16_t(0.0)));
    f16vec2 _6739 = f16vec2(_6736.x);
    f16vec2 _6740 = f16vec2(_6736.y);
    f16vec2 _6963 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[576u], nn_buf.data[577u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[512u], nn_buf.data[513u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[448u], nn_buf.data[449u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[384u], nn_buf.data[385u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[320u], nn_buf.data[321u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[256u], nn_buf.data[257u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[192u], nn_buf.data[193u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[128u], nn_buf.data[129u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[64u], nn_buf.data[65u]), f16vec2(nn_buf.data[3504u], nn_buf.data[3505u]))))))))));
    f16vec2 _6974 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[640u], nn_buf.data[641u]), _6963), f16vec2(float16_t(0.0)));
    f16vec2 _6977 = f16vec2(_6974.x);
    f16vec2 _6978 = f16vec2(_6974.y);
    f16vec2 _6994 = fma(_6978, f16vec2(nn_buf.data[1440u], nn_buf.data[1441u]), fma(_6977, f16vec2(nn_buf.data[1424u], nn_buf.data[1425u]), fma(_6740, f16vec2(nn_buf.data[1408u], nn_buf.data[1409u]), fma(_6739, f16vec2(nn_buf.data[1392u], nn_buf.data[1393u]), fma(_6500, f16vec2(nn_buf.data[1376u], nn_buf.data[1377u]), fma(_6499, f16vec2(nn_buf.data[1360u], nn_buf.data[1361u]), fma(_6260, f16vec2(nn_buf.data[1344u], nn_buf.data[1345u]), fma(_6259, f16vec2(nn_buf.data[1328u], nn_buf.data[1329u]), fma(_6020, f16vec2(nn_buf.data[1312u], nn_buf.data[1313u]), fma(_6019, f16vec2(nn_buf.data[1296u], nn_buf.data[1297u]), _5796))))))))));
    f16vec2 _7010 = fma(_6978, f16vec2(nn_buf.data[1442u], nn_buf.data[1443u]), fma(_6977, f16vec2(nn_buf.data[1426u], nn_buf.data[1427u]), fma(_6740, f16vec2(nn_buf.data[1410u], nn_buf.data[1411u]), fma(_6739, f16vec2(nn_buf.data[1394u], nn_buf.data[1395u]), fma(_6500, f16vec2(nn_buf.data[1378u], nn_buf.data[1379u]), fma(_6499, f16vec2(nn_buf.data[1362u], nn_buf.data[1363u]), fma(_6260, f16vec2(nn_buf.data[1346u], nn_buf.data[1347u]), fma(_6259, f16vec2(nn_buf.data[1330u], nn_buf.data[1331u]), fma(_6020, f16vec2(nn_buf.data[1314u], nn_buf.data[1315u]), fma(_6019, f16vec2(nn_buf.data[1298u], nn_buf.data[1299u]), _5812))))))))));
    f16vec2 _7026 = fma(_6978, f16vec2(nn_buf.data[1444u], nn_buf.data[1445u]), fma(_6977, f16vec2(nn_buf.data[1428u], nn_buf.data[1429u]), fma(_6740, f16vec2(nn_buf.data[1412u], nn_buf.data[1413u]), fma(_6739, f16vec2(nn_buf.data[1396u], nn_buf.data[1397u]), fma(_6500, f16vec2(nn_buf.data[1380u], nn_buf.data[1381u]), fma(_6499, f16vec2(nn_buf.data[1364u], nn_buf.data[1365u]), fma(_6260, f16vec2(nn_buf.data[1348u], nn_buf.data[1349u]), fma(_6259, f16vec2(nn_buf.data[1332u], nn_buf.data[1333u]), fma(_6020, f16vec2(nn_buf.data[1316u], nn_buf.data[1317u]), fma(_6019, f16vec2(nn_buf.data[1300u], nn_buf.data[1301u]), _5828))))))))));
    f16vec2 _7042 = fma(_6978, f16vec2(nn_buf.data[1446u], nn_buf.data[1447u]), fma(_6977, f16vec2(nn_buf.data[1430u], nn_buf.data[1431u]), fma(_6740, f16vec2(nn_buf.data[1414u], nn_buf.data[1415u]), fma(_6739, f16vec2(nn_buf.data[1398u], nn_buf.data[1399u]), fma(_6500, f16vec2(nn_buf.data[1382u], nn_buf.data[1383u]), fma(_6499, f16vec2(nn_buf.data[1366u], nn_buf.data[1367u]), fma(_6260, f16vec2(nn_buf.data[1350u], nn_buf.data[1351u]), fma(_6259, f16vec2(nn_buf.data[1334u], nn_buf.data[1335u]), fma(_6020, f16vec2(nn_buf.data[1318u], nn_buf.data[1319u]), fma(_6019, f16vec2(nn_buf.data[1302u], nn_buf.data[1303u]), _5844))))))))));
    f16vec2 _7058 = fma(_6978, f16vec2(nn_buf.data[1448u], nn_buf.data[1449u]), fma(_6977, f16vec2(nn_buf.data[1432u], nn_buf.data[1433u]), fma(_6740, f16vec2(nn_buf.data[1416u], nn_buf.data[1417u]), fma(_6739, f16vec2(nn_buf.data[1400u], nn_buf.data[1401u]), fma(_6500, f16vec2(nn_buf.data[1384u], nn_buf.data[1385u]), fma(_6499, f16vec2(nn_buf.data[1368u], nn_buf.data[1369u]), fma(_6260, f16vec2(nn_buf.data[1352u], nn_buf.data[1353u]), fma(_6259, f16vec2(nn_buf.data[1336u], nn_buf.data[1337u]), fma(_6020, f16vec2(nn_buf.data[1320u], nn_buf.data[1321u]), fma(_6019, f16vec2(nn_buf.data[1304u], nn_buf.data[1305u]), _5860))))))))));
    f16vec2 _7074 = fma(_6978, f16vec2(nn_buf.data[1450u], nn_buf.data[1451u]), fma(_6977, f16vec2(nn_buf.data[1434u], nn_buf.data[1435u]), fma(_6740, f16vec2(nn_buf.data[1418u], nn_buf.data[1419u]), fma(_6739, f16vec2(nn_buf.data[1402u], nn_buf.data[1403u]), fma(_6500, f16vec2(nn_buf.data[1386u], nn_buf.data[1387u]), fma(_6499, f16vec2(nn_buf.data[1370u], nn_buf.data[1371u]), fma(_6260, f16vec2(nn_buf.data[1354u], nn_buf.data[1355u]), fma(_6259, f16vec2(nn_buf.data[1338u], nn_buf.data[1339u]), fma(_6020, f16vec2(nn_buf.data[1322u], nn_buf.data[1323u]), fma(_6019, f16vec2(nn_buf.data[1306u], nn_buf.data[1307u]), _5876))))))))));
    f16vec2 _7090 = fma(_6978, f16vec2(nn_buf.data[1452u], nn_buf.data[1453u]), fma(_6977, f16vec2(nn_buf.data[1436u], nn_buf.data[1437u]), fma(_6740, f16vec2(nn_buf.data[1420u], nn_buf.data[1421u]), fma(_6739, f16vec2(nn_buf.data[1404u], nn_buf.data[1405u]), fma(_6500, f16vec2(nn_buf.data[1388u], nn_buf.data[1389u]), fma(_6499, f16vec2(nn_buf.data[1372u], nn_buf.data[1373u]), fma(_6260, f16vec2(nn_buf.data[1356u], nn_buf.data[1357u]), fma(_6259, f16vec2(nn_buf.data[1340u], nn_buf.data[1341u]), fma(_6020, f16vec2(nn_buf.data[1324u], nn_buf.data[1325u]), fma(_6019, f16vec2(nn_buf.data[1308u], nn_buf.data[1309u]), _5892))))))))));
    f16vec2 _7106 = fma(_6978, f16vec2(nn_buf.data[1454u], nn_buf.data[1455u]), fma(_6977, f16vec2(nn_buf.data[1438u], nn_buf.data[1439u]), fma(_6740, f16vec2(nn_buf.data[1422u], nn_buf.data[1423u]), fma(_6739, f16vec2(nn_buf.data[1406u], nn_buf.data[1407u]), fma(_6500, f16vec2(nn_buf.data[1390u], nn_buf.data[1391u]), fma(_6499, f16vec2(nn_buf.data[1374u], nn_buf.data[1375u]), fma(_6260, f16vec2(nn_buf.data[1358u], nn_buf.data[1359u]), fma(_6259, f16vec2(nn_buf.data[1342u], nn_buf.data[1343u]), fma(_6020, f16vec2(nn_buf.data[1326u], nn_buf.data[1327u]), fma(_6019, f16vec2(nn_buf.data[1310u], nn_buf.data[1311u]), _5908))))))))));
    f16vec2 _7203 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[578u], nn_buf.data[579u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[514u], nn_buf.data[515u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[450u], nn_buf.data[451u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[386u], nn_buf.data[387u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[322u], nn_buf.data[323u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[258u], nn_buf.data[259u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[194u], nn_buf.data[195u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[130u], nn_buf.data[131u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[66u], nn_buf.data[67u]), f16vec2(nn_buf.data[3506u], nn_buf.data[3507u]))))))))));
    f16vec2 _7214 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[642u], nn_buf.data[643u]), _7203), f16vec2(float16_t(0.0)));
    f16vec2 _7217 = f16vec2(_7214.x);
    f16vec2 _7218 = f16vec2(_7214.y);
    f16vec2 _7443 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[580u], nn_buf.data[581u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[516u], nn_buf.data[517u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[452u], nn_buf.data[453u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[388u], nn_buf.data[389u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[324u], nn_buf.data[325u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[260u], nn_buf.data[261u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[196u], nn_buf.data[197u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[132u], nn_buf.data[133u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[68u], nn_buf.data[69u]), f16vec2(nn_buf.data[3508u], nn_buf.data[3509u]))))))))));
    f16vec2 _7454 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[644u], nn_buf.data[645u]), _7443), f16vec2(float16_t(0.0)));
    f16vec2 _7457 = f16vec2(_7454.x);
    f16vec2 _7458 = f16vec2(_7454.y);
    f16vec2 _7683 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[582u], nn_buf.data[583u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[518u], nn_buf.data[519u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[454u], nn_buf.data[455u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[390u], nn_buf.data[391u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[326u], nn_buf.data[327u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[262u], nn_buf.data[263u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[198u], nn_buf.data[199u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[134u], nn_buf.data[135u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[70u], nn_buf.data[71u]), f16vec2(nn_buf.data[3510u], nn_buf.data[3511u]))))))))));
    f16vec2 _7694 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[646u], nn_buf.data[647u]), _7683), f16vec2(float16_t(0.0)));
    f16vec2 _7697 = f16vec2(_7694.x);
    f16vec2 _7698 = f16vec2(_7694.y);
    f16vec2 _7923 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[584u], nn_buf.data[585u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[520u], nn_buf.data[521u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[456u], nn_buf.data[457u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[392u], nn_buf.data[393u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[328u], nn_buf.data[329u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[264u], nn_buf.data[265u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[200u], nn_buf.data[201u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[136u], nn_buf.data[137u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[72u], nn_buf.data[73u]), f16vec2(nn_buf.data[3512u], nn_buf.data[3513u]))))))))));
    f16vec2 _7934 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[648u], nn_buf.data[649u]), _7923), f16vec2(float16_t(0.0)));
    f16vec2 _7937 = f16vec2(_7934.x);
    f16vec2 _7938 = f16vec2(_7934.y);
    f16vec2 _8163 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[586u], nn_buf.data[587u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[522u], nn_buf.data[523u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[458u], nn_buf.data[459u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[394u], nn_buf.data[395u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[330u], nn_buf.data[331u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[266u], nn_buf.data[267u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[202u], nn_buf.data[203u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[138u], nn_buf.data[139u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[74u], nn_buf.data[75u]), f16vec2(nn_buf.data[3514u], nn_buf.data[3515u]))))))))));
    f16vec2 _8174 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[650u], nn_buf.data[651u]), _8163), f16vec2(float16_t(0.0)));
    f16vec2 _8177 = f16vec2(_8174.x);
    f16vec2 _8178 = f16vec2(_8174.y);
    f16vec2 _8194 = fma(_8178, f16vec2(nn_buf.data[1600u], nn_buf.data[1601u]), fma(_8177, f16vec2(nn_buf.data[1584u], nn_buf.data[1585u]), fma(_7938, f16vec2(nn_buf.data[1568u], nn_buf.data[1569u]), fma(_7937, f16vec2(nn_buf.data[1552u], nn_buf.data[1553u]), fma(_7698, f16vec2(nn_buf.data[1536u], nn_buf.data[1537u]), fma(_7697, f16vec2(nn_buf.data[1520u], nn_buf.data[1521u]), fma(_7458, f16vec2(nn_buf.data[1504u], nn_buf.data[1505u]), fma(_7457, f16vec2(nn_buf.data[1488u], nn_buf.data[1489u]), fma(_7218, f16vec2(nn_buf.data[1472u], nn_buf.data[1473u]), fma(_7217, f16vec2(nn_buf.data[1456u], nn_buf.data[1457u]), _6994))))))))));
    f16vec2 _8210 = fma(_8178, f16vec2(nn_buf.data[1602u], nn_buf.data[1603u]), fma(_8177, f16vec2(nn_buf.data[1586u], nn_buf.data[1587u]), fma(_7938, f16vec2(nn_buf.data[1570u], nn_buf.data[1571u]), fma(_7937, f16vec2(nn_buf.data[1554u], nn_buf.data[1555u]), fma(_7698, f16vec2(nn_buf.data[1538u], nn_buf.data[1539u]), fma(_7697, f16vec2(nn_buf.data[1522u], nn_buf.data[1523u]), fma(_7458, f16vec2(nn_buf.data[1506u], nn_buf.data[1507u]), fma(_7457, f16vec2(nn_buf.data[1490u], nn_buf.data[1491u]), fma(_7218, f16vec2(nn_buf.data[1474u], nn_buf.data[1475u]), fma(_7217, f16vec2(nn_buf.data[1458u], nn_buf.data[1459u]), _7010))))))))));
    f16vec2 _8226 = fma(_8178, f16vec2(nn_buf.data[1604u], nn_buf.data[1605u]), fma(_8177, f16vec2(nn_buf.data[1588u], nn_buf.data[1589u]), fma(_7938, f16vec2(nn_buf.data[1572u], nn_buf.data[1573u]), fma(_7937, f16vec2(nn_buf.data[1556u], nn_buf.data[1557u]), fma(_7698, f16vec2(nn_buf.data[1540u], nn_buf.data[1541u]), fma(_7697, f16vec2(nn_buf.data[1524u], nn_buf.data[1525u]), fma(_7458, f16vec2(nn_buf.data[1508u], nn_buf.data[1509u]), fma(_7457, f16vec2(nn_buf.data[1492u], nn_buf.data[1493u]), fma(_7218, f16vec2(nn_buf.data[1476u], nn_buf.data[1477u]), fma(_7217, f16vec2(nn_buf.data[1460u], nn_buf.data[1461u]), _7026))))))))));
    f16vec2 _8242 = fma(_8178, f16vec2(nn_buf.data[1606u], nn_buf.data[1607u]), fma(_8177, f16vec2(nn_buf.data[1590u], nn_buf.data[1591u]), fma(_7938, f16vec2(nn_buf.data[1574u], nn_buf.data[1575u]), fma(_7937, f16vec2(nn_buf.data[1558u], nn_buf.data[1559u]), fma(_7698, f16vec2(nn_buf.data[1542u], nn_buf.data[1543u]), fma(_7697, f16vec2(nn_buf.data[1526u], nn_buf.data[1527u]), fma(_7458, f16vec2(nn_buf.data[1510u], nn_buf.data[1511u]), fma(_7457, f16vec2(nn_buf.data[1494u], nn_buf.data[1495u]), fma(_7218, f16vec2(nn_buf.data[1478u], nn_buf.data[1479u]), fma(_7217, f16vec2(nn_buf.data[1462u], nn_buf.data[1463u]), _7042))))))))));
    f16vec2 _8258 = fma(_8178, f16vec2(nn_buf.data[1608u], nn_buf.data[1609u]), fma(_8177, f16vec2(nn_buf.data[1592u], nn_buf.data[1593u]), fma(_7938, f16vec2(nn_buf.data[1576u], nn_buf.data[1577u]), fma(_7937, f16vec2(nn_buf.data[1560u], nn_buf.data[1561u]), fma(_7698, f16vec2(nn_buf.data[1544u], nn_buf.data[1545u]), fma(_7697, f16vec2(nn_buf.data[1528u], nn_buf.data[1529u]), fma(_7458, f16vec2(nn_buf.data[1512u], nn_buf.data[1513u]), fma(_7457, f16vec2(nn_buf.data[1496u], nn_buf.data[1497u]), fma(_7218, f16vec2(nn_buf.data[1480u], nn_buf.data[1481u]), fma(_7217, f16vec2(nn_buf.data[1464u], nn_buf.data[1465u]), _7058))))))))));
    f16vec2 _8274 = fma(_8178, f16vec2(nn_buf.data[1610u], nn_buf.data[1611u]), fma(_8177, f16vec2(nn_buf.data[1594u], nn_buf.data[1595u]), fma(_7938, f16vec2(nn_buf.data[1578u], nn_buf.data[1579u]), fma(_7937, f16vec2(nn_buf.data[1562u], nn_buf.data[1563u]), fma(_7698, f16vec2(nn_buf.data[1546u], nn_buf.data[1547u]), fma(_7697, f16vec2(nn_buf.data[1530u], nn_buf.data[1531u]), fma(_7458, f16vec2(nn_buf.data[1514u], nn_buf.data[1515u]), fma(_7457, f16vec2(nn_buf.data[1498u], nn_buf.data[1499u]), fma(_7218, f16vec2(nn_buf.data[1482u], nn_buf.data[1483u]), fma(_7217, f16vec2(nn_buf.data[1466u], nn_buf.data[1467u]), _7074))))))))));
    f16vec2 _8290 = fma(_8178, f16vec2(nn_buf.data[1612u], nn_buf.data[1613u]), fma(_8177, f16vec2(nn_buf.data[1596u], nn_buf.data[1597u]), fma(_7938, f16vec2(nn_buf.data[1580u], nn_buf.data[1581u]), fma(_7937, f16vec2(nn_buf.data[1564u], nn_buf.data[1565u]), fma(_7698, f16vec2(nn_buf.data[1548u], nn_buf.data[1549u]), fma(_7697, f16vec2(nn_buf.data[1532u], nn_buf.data[1533u]), fma(_7458, f16vec2(nn_buf.data[1516u], nn_buf.data[1517u]), fma(_7457, f16vec2(nn_buf.data[1500u], nn_buf.data[1501u]), fma(_7218, f16vec2(nn_buf.data[1484u], nn_buf.data[1485u]), fma(_7217, f16vec2(nn_buf.data[1468u], nn_buf.data[1469u]), _7090))))))))));
    f16vec2 _8306 = fma(_8178, f16vec2(nn_buf.data[1614u], nn_buf.data[1615u]), fma(_8177, f16vec2(nn_buf.data[1598u], nn_buf.data[1599u]), fma(_7938, f16vec2(nn_buf.data[1582u], nn_buf.data[1583u]), fma(_7937, f16vec2(nn_buf.data[1566u], nn_buf.data[1567u]), fma(_7698, f16vec2(nn_buf.data[1550u], nn_buf.data[1551u]), fma(_7697, f16vec2(nn_buf.data[1534u], nn_buf.data[1535u]), fma(_7458, f16vec2(nn_buf.data[1518u], nn_buf.data[1519u]), fma(_7457, f16vec2(nn_buf.data[1502u], nn_buf.data[1503u]), fma(_7218, f16vec2(nn_buf.data[1486u], nn_buf.data[1487u]), fma(_7217, f16vec2(nn_buf.data[1470u], nn_buf.data[1471u]), _7106))))))))));
    f16vec2 _8403 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[588u], nn_buf.data[589u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[524u], nn_buf.data[525u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[460u], nn_buf.data[461u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[396u], nn_buf.data[397u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[332u], nn_buf.data[333u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[268u], nn_buf.data[269u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[204u], nn_buf.data[205u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[140u], nn_buf.data[141u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[76u], nn_buf.data[77u]), f16vec2(nn_buf.data[3516u], nn_buf.data[3517u]))))))))));
    f16vec2 _8414 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[652u], nn_buf.data[653u]), _8403), f16vec2(float16_t(0.0)));
    f16vec2 _8417 = f16vec2(_8414.x);
    f16vec2 _8418 = f16vec2(_8414.y);
    f16vec2 _8643 = fma(f16vec2(inVec[4].x), f16vec2(nn_buf.data[590u], nn_buf.data[591u]), fma(f16vec2(inVec[3].y), f16vec2(nn_buf.data[526u], nn_buf.data[527u]), fma(f16vec2(inVec[3].x), f16vec2(nn_buf.data[462u], nn_buf.data[463u]), fma(f16vec2(inVec[2].y), f16vec2(nn_buf.data[398u], nn_buf.data[399u]), fma(f16vec2(inVec[2].x), f16vec2(nn_buf.data[334u], nn_buf.data[335u]), fma(f16vec2(inVec[1].y), f16vec2(nn_buf.data[270u], nn_buf.data[271u]), fma(f16vec2(inVec[1].x), f16vec2(nn_buf.data[206u], nn_buf.data[207u]), fma(f16vec2(inVec[0].y), f16vec2(nn_buf.data[142u], nn_buf.data[143u]), fma(f16vec2(inVec[0].x), f16vec2(nn_buf.data[78u], nn_buf.data[79u]), f16vec2(nn_buf.data[3518u], nn_buf.data[3519u]))))))))));
    f16vec2 _8654 = max(fma(f16vec2(inVec[4].y), f16vec2(nn_buf.data[654u], nn_buf.data[655u]), _8643), f16vec2(float16_t(0.0)));
    f16vec2 _8657 = f16vec2(_8654.x);
    f16vec2 _8658 = f16vec2(_8654.y);
    f16vec2 _380[8] = f16vec2[](f16vec2(fma(_8658, f16vec2(nn_buf.data[1664u], nn_buf.data[1665u]), fma(_8657, f16vec2(nn_buf.data[1648u], nn_buf.data[1649u]), fma(_8418, f16vec2(nn_buf.data[1632u], nn_buf.data[1633u]), fma(_8417, f16vec2(nn_buf.data[1616u], nn_buf.data[1617u]), _8194))))), f16vec2(fma(_8658, f16vec2(nn_buf.data[1666u], nn_buf.data[1667u]), fma(_8657, f16vec2(nn_buf.data[1650u], nn_buf.data[1651u]), fma(_8418, f16vec2(nn_buf.data[1634u], nn_buf.data[1635u]), fma(_8417, f16vec2(nn_buf.data[1618u], nn_buf.data[1619u]), _8210))))), f16vec2(fma(_8658, f16vec2(nn_buf.data[1668u], nn_buf.data[1669u]), fma(_8657, f16vec2(nn_buf.data[1652u], nn_buf.data[1653u]), fma(_8418, f16vec2(nn_buf.data[1636u], nn_buf.data[1637u]), fma(_8417, f16vec2(nn_buf.data[1620u], nn_buf.data[1621u]), _8226))))), f16vec2(fma(_8658, f16vec2(nn_buf.data[1670u], nn_buf.data[1671u]), fma(_8657, f16vec2(nn_buf.data[1654u], nn_buf.data[1655u]), fma(_8418, f16vec2(nn_buf.data[1638u], nn_buf.data[1639u]), fma(_8417, f16vec2(nn_buf.data[1622u], nn_buf.data[1623u]), _8242))))), f16vec2(fma(_8658, f16vec2(nn_buf.data[1672u], nn_buf.data[1673u]), fma(_8657, f16vec2(nn_buf.data[1656u], nn_buf.data[1657u]), fma(_8418, f16vec2(nn_buf.data[1640u], nn_buf.data[1641u]), fma(_8417, f16vec2(nn_buf.data[1624u], nn_buf.data[1625u]), _8258))))), f16vec2(fma(_8658, f16vec2(nn_buf.data[1674u], nn_buf.data[1675u]), fma(_8657, f16vec2(nn_buf.data[1658u], nn_buf.data[1659u]), fma(_8418, f16vec2(nn_buf.data[1642u], nn_buf.data[1643u]), fma(_8417, f16vec2(nn_buf.data[1626u], nn_buf.data[1627u]), _8274))))), f16vec2(fma(_8658, f16vec2(nn_buf.data[1676u], nn_buf.data[1677u]), fma(_8657, f16vec2(nn_buf.data[1660u], nn_buf.data[1661u]), fma(_8418, f16vec2(nn_buf.data[1644u], nn_buf.data[1645u]), fma(_8417, f16vec2(nn_buf.data[1628u], nn_buf.data[1629u]), _8290))))), f16vec2(fma(_8658, f16vec2(nn_buf.data[1678u], nn_buf.data[1679u]), fma(_8657, f16vec2(nn_buf.data[1662u], nn_buf.data[1663u]), fma(_8418, f16vec2(nn_buf.data[1646u], nn_buf.data[1647u]), fma(_8417, f16vec2(nn_buf.data[1630u], nn_buf.data[1631u]), _8306))))));
    f16vec2 tempArg[8] = _380;
    f16vec2 _RESERVED_IDENTIFIER_FIXUP_325[8] = _380;
    f16vec2 tempArg_5[8] = _380;
    f16vec2 out1[8] = _380;
    f16vec2 _9106[8] = _380;
    uint _9105 = 0u;
    f16vec2 _9104[8];
    uint _9112;
    for (;;)
    {
        _9112 = _9105;
        if (_9112 < 8u)
        {
            _9104[_9112] = max(_9106[_9112], _388[_9112]);
            _9105 = _9112 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    out1 = _9104;
    f16vec2 inVec2[8] = _9104;
    uint _9121 = 3616u + 0u;
    uint _9124 = 3616u + 1u;
    uint _9127 = 3616u + 2u;
    float16_t _414[3] = float16_t[](nn_buf.data[_9121], nn_buf.data[_9124], nn_buf.data[_9127]);
    float16_t tempArg_1[3] = _414;
    float16_t _RESERVED_IDENTIFIER_FIXUP_349[3] = _414;
    float16_t tempArg_7[3] = _414;
    float16_t bias2[3] = _414;
    float16_t _425[3] = _8817(_9104, _414);
    float16_t tempArg_2[3] = _425;
    float16_t _RESERVED_IDENTIFIER_FIXUP_361[3] = _425;
    float16_t tempArg_8[3] = _425;
    float16_t out2[3] = _425;
    float16_t _9133[3] = out2;
    uint _9132 = 0u;
    float16_t _9131[3];
    uint _9139;
    for (;;)
    {
        _9139 = _9132;
        if (_9139 < 3u)
        {
            _9131[_9139] = max(_9133[_9139], _433[_9139]);
            _9132 = _9139 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    out2 = _9131;
    return vec3(float(out2[0]), float(out2[1]), float(out2[2]));
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

