#version 460
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
#extension GL_HW_neural_shader : require

struct DefaultMaterialSingleMaterialStruct
{
    vec4 factors[15];
    uvec4 indices;
};

struct DefaultMaterialMaterialStruct
{
    DefaultMaterialSingleMaterialStruct material[64];
};

layout(constant_id = 1) const uint CORE_MATERIAL_FLAGS = 0u;
const uint _144 = (CORE_MATERIAL_FLAGS & 16384u);
const bool _145 = (_144 == 16384u);
const uint _149 = (CORE_MATERIAL_FLAGS & 32768u);
const bool _150 = (_149 == 32768u);

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

layout(constant_id = 0) const uint CORE_MATERIAL_TYPE = 0u;
layout(constant_id = 2) const uint CORE_LIGHTING_FLAGS = 0u;
layout(constant_id = 3) const uint CORE_POST_PROCESS_FLAGS = 0u;
layout(constant_id = 4) const uint CORE_CAMERA_FLAGS = 0u;

layout(set = 1, binding = 2, std140) uniform uMaterialStructData
{
    DefaultMaterialMaterialStruct uMaterialData;
} _131;

layout(set = 1, binding = 4, std140) uniform uMaterialUserStructData
{
    DefaultMaterialUserMaterialStruct uMaterialUserData;
} _167;

layout(set = 3, binding = 0, std430) readonly buffer NeuralNetBuffer
{
    float16_t data[];
} nn_buf;

layout(set = 0, binding = 0, std140) uniform uCameraMatrices
{
    DefaultCameraMatrixStruct uCameras[16];
} _832;

layout(set = 0, binding = 1, std140) uniform uGeneralStructData
{
    DefaultMaterialGeneralDataStruct uGeneralData;
} _836;

layout(set = 0, binding = 2, std140) uniform uEnvironmentStructData
{
    DefaultMaterialEnvironmentStruct uEnvironmentData;
} _843;

layout(set = 0, binding = 3, std140) uniform uFogStructData
{
    DefaultMaterialFogStruct uFogData;
} _847;

layout(set = 0, binding = 4, std140) uniform uLightStructData
{
    DefaultMaterialLightStruct uLightData;
} _853;

layout(set = 0, binding = 5, std140) uniform uPostProcessStructData
{
    GlobalPostProcessStruct uPostProcessData;
} _860;

layout(set = 0, binding = 6, std430) buffer uLightClusterIndexData
{
    DefaultMaterialLightClusterData uLightClusterData[3456];
} _866;

layout(set = 1, binding = 0, std140) uniform uMeshStructData
{
    DefaultMaterialMeshStruct uMeshMatrix;
} _883;

layout(set = 1, binding = 1, std140) uniform uObjectSkinStructData
{
    DefaultMaterialSkinStruct uSkinData;
} _889;

layout(set = 1, binding = 3, std140) uniform uMaterialTransformStructData
{
    DefaultMaterialTransformMaterialStruct uMaterialTransformData;
} _896;

layout(set = 1, binding = 5, std430) buffer uLightProbeStructData
{
    DefaultSingleLightProbeStruct uLightProbeData[];
} _902;

layout(push_constant, std430) uniform uLightingPushConstant
{
    DefaultLightProbeDataIndexStruct uLightProbeDataIndexData;
    uint uViewMatrixIndex;
} _907;

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
    return indices >> uint(16);
}

uint GetMaterialInstanceIndex(uint indices)
{
    uint instanceIdx = 0u;
    bool _151;
    if (_145)
    {
        _151 = _150;
    }
    else
    {
        _151 = _145;
    }
    if (_151)
    {
        uint param = indices;
        instanceIdx = GetUnpackFlatIndicesInstanceIdx(param);
    }
    return instanceIdx;
}

vec3 Linear2Srgb(vec3 linear)
{
    return mix(linear * 12.9200000762939453125, (pow(linear, vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875), step(vec3(0.003130800090730190277099609375), linear));
}

float GetUnpackNormalScale(uint instanceIdx)
{
    return _131.uMaterialData.material[instanceIdx].factors[1].x;
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

mediump vec3 evaluateNetwork2(mediump vec3 envmap, mediump vec3 dirmap, mediump vec3 specular, mediump float nDir)
{
    coopvecHW<float16_t, 10u> inVec;
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
    coopmatHW<float16_t, 10u, 64u> _269;
    coopMatLoadHW(_269, nn_buf.data, ivec2(10, 64), ivec2(0, 16), gl_CooperativeMatrixLayoutRowMajorHW);
    coopmatHW<float16_t, 10u, 64u> tempArg = _269;
    coopmatHW<float16_t, 10u, 64u> matW0 = tempArg;
    coopvecHW<float16_t, 64u> _277;
    coopVecLoadHW(_277, nn_buf.data, 3456u);
    coopvecHW<float16_t, 64u> tempArg_1 = _277;
    coopvecHW<float16_t, 64u> bias0_f16 = tempArg_1;
    coopvecHW<float, 64u> bias0 = coopvecHW<float, 64u>(bias0_f16);
    coopvecHW<float, 64u> _289;
    coopVecMatMulAddHW(_289, inVec, matW0, bias0);
    coopvecHW<float, 64u> tempArg_2 = _289;
    coopvecHW<float, 64u> out0 = tempArg_2;
    out0 = max(out0, coopvecHW<float, 64u>(0.0));
    coopvecHW<float16_t, 64u> inVec1 = coopvecHW<float16_t, 64u>(out0);
    coopmatHW<float16_t, 64u, 16u> _305;
    coopMatLoadHW(_305, nn_buf.data, ivec2(64, 16), ivec2(41, 0), gl_CooperativeMatrixLayoutRowMajorHW);
    coopmatHW<float16_t, 64u, 16u> tempArg_3 = _305;
    coopmatHW<float16_t, 64u, 16u> matW1 = tempArg_3;
    coopvecHW<float16_t, 16u> _313;
    coopVecLoadHW(_313, nn_buf.data, 3584u);
    coopvecHW<float16_t, 16u> tempArg_4 = _313;
    coopvecHW<float16_t, 16u> bias1_f16 = tempArg_4;
    coopvecHW<float, 16u> bias1 = coopvecHW<float, 16u>(bias1_f16);
    coopvecHW<float, 16u> _325;
    coopVecMatMulAddHW(_325, inVec1, matW1, bias1);
    coopvecHW<float, 16u> tempArg_5 = _325;
    coopvecHW<float, 16u> out1 = tempArg_5;
    out1 = max(out1, coopvecHW<float, 16u>(0.0));
    coopvecHW<float16_t, 16u> inVec2 = coopvecHW<float16_t, 16u>(out1);
    coopmatHW<float16_t, 16u, 3u> _341;
    coopMatLoadHW(_341, nn_buf.data, ivec2(16, 3), ivec2(560, 0), gl_CooperativeMatrixLayoutRowMajorHW);
    coopmatHW<float16_t, 16u, 3u> tempArg_6 = _341;
    coopmatHW<float16_t, 16u, 3u> matW2 = tempArg_6;
    coopvecHW<float16_t, 3u> _349;
    coopVecLoadHW(_349, nn_buf.data, 3616u);
    coopvecHW<float16_t, 3u> tempArg_7 = _349;
    coopvecHW<float16_t, 3u> bias2_f16 = tempArg_7;
    coopvecHW<float, 3u> bias2 = coopvecHW<float, 3u>(bias2_f16);
    coopvecHW<float, 3u> _361;
    coopVecMatMulAddHW(_361, inVec2, matW2, bias2);
    coopvecHW<float, 3u> tempArg_8 = _361;
    coopvecHW<float, 3u> out2 = tempArg_8;
    return max(vec3(out2[0], out2[1], out2[2]), vec3(0.0));
}

uint GetShadingMode()
{
    return _167.uMaterialUserData.material[0].userData[0].x;
}

vec3 Srgb2Linear(vec3 srgb)
{
    return mix(srgb / vec3(12.9200000762939453125), pow((srgb + vec3(0.054999999701976776123046875)) / vec3(1.05499994754791259765625), vec3(2.400000095367431640625)), step(vec3(0.040449999272823333740234375), srgb));
}

vec4 GetFinalColorFactor()
{
    uvec4 vec = _167.uMaterialUserData.material[0].userData[1];
    return vec4(uintBitsToFloat(vec.x), uintBitsToFloat(vec.y), uintBitsToFloat(vec.z), uintBitsToFloat(vec.w));
}

void main()
{
    vec2 uvFlip = vec2(inUv.x, 1.0 - inUv.y);
    uint param = inIndices;
    uint instanceIdx = GetMaterialInstanceIndex(param);
    vec3 normNormal = normalize(inNormal);
    vec3 N = normNormal;
    vec3 param_1 = texture(uSampTextures[0], inUv).xyz;
    N = Linear2Srgb(param_1);
    float normalScale = GetUnpackNormalScale(instanceIdx);
    vec3 param_2 = normNormal;
    vec4 param_3 = inTangentW;
    mat3 tbn = CalcTbnMatrix(param_2, param_3);
    mat3 param_4 = tbn;
    vec3 param_5 = N;
    float param_6 = normalScale;
    N = CalcFinalNormal(param_4, param_5, param_6);
    vec3 unitNormal = vec3(N.x, -N.z, N.y);
    vec3 param_7 = textureLod(uSampTextures[2], uvFlip, 0.0).xyz;
    int param_8 = 5;
    vec3 diffusefe = Linear2Srgb(param_7) * hdr(param_8);
    vec3 param_9 = textureLod(uSampTextures[3], uvFlip, 0.0).xyz;
    int param_10 = 6;
    vec3 specfe = Linear2Srgb(param_9) * hdr(param_10);
    vec3 unitViewDir = normalize(vec3(-viewDir.x, viewDir.z, -viewDir.y));
    float nDir = dot(unitViewDir, unitNormal);
    vec3 wDir = -reflect(unitViewDir, unitNormal);
    vec3 param_11 = wDir;
    vec2 degree_xyz = dir2polar(param_11);
    vec2 polar_uv = max(min(vec2((degree_xyz.y + 1.0) / 2.0, (degree_xyz.x + 1.0) / 2.0), vec2(1.0)), vec2(0.0));
    ivec2 _590 = textureSize(uSampTextures[5], 0);
    mediump ivec2 mp_copy_590 = _590;
    ivec2 texCoord = ivec2(polar_uv * vec2(mp_copy_590 - ivec2(1)));
    vec3 param_12 = texelFetch(uSampTextures[5], texCoord, 0).xyz;
    vec3 envmap = Linear2Srgb(param_12);
    vec3 param_13 = texelFetch(uSampTextures[7], texCoord, 0).xyz;
    vec3 envmap_re = Linear2Srgb(param_13);
    int param_14 = 1;
    int param_15 = 0;
    int param_16 = 0;
    envmap = (envmap * (hdr(param_14) - hdr(param_15))) + vec3(hdr(param_16));
    int param_17 = 4;
    int param_18 = 3;
    int param_19 = 3;
    envmap_re = (envmap_re * (hdr(param_17) - hdr(param_18))) + vec3(hdr(param_19));
    int param_20 = 2;
    envmap_re /= vec3(pow(10.0, hdr(param_20)));
    envmap += envmap_re;
    vec3 nViewDir = normalize(unitViewDir + unitNormal);
    vec3 param_21 = nViewDir;
    degree_xyz = dir2polar(param_21);
    polar_uv = max(min(vec2((degree_xyz.y + 1.0) / 2.0, (degree_xyz.x + 1.0) / 2.0), vec2(1.0)), vec2(0.0));
    ivec2 _669 = textureSize(uSampTextures[4], 0);
    mediump ivec2 mp_copy_669 = _669;
    texCoord = ivec2(polar_uv * vec2(mp_copy_669 - ivec2(1)));
    vec3 param_22 = texelFetch(uSampTextures[4], texCoord, 0).xyz;
    vec3 dirmap = Linear2Srgb(param_22);
    vec3 param_23 = texelFetch(uSampTextures[6], texCoord, 0).xyz;
    vec3 dirmapre = Linear2Srgb(param_23);
    int param_24 = 8;
    int param_25 = 7;
    int param_26 = 7;
    dirmap = (dirmap * (hdr(param_24) - hdr(param_25))) + vec3(hdr(param_26));
    int param_27 = 11;
    int param_28 = 10;
    int param_29 = 10;
    dirmapre = (dirmapre * (hdr(param_27) - hdr(param_28))) + vec3(hdr(param_29));
    int param_30 = 9;
    dirmapre /= vec3(pow(10.0, hdr(param_30)));
    dirmap += dirmapre;
    mediump vec3 param_31 = envmap;
    mediump vec3 param_32 = dirmap;
    mediump vec3 param_33 = specfe;
    mediump float param_34 = nDir;
    vec3 outputArr = evaluateNetwork2(param_31, param_32, param_33, param_34);
    if (GetShadingMode() == 0u)
    {
        vec3 param_35 = max(min(diffusefe + outputArr, vec3(1.0)), vec3(0.0));
        vec3 _748 = Srgb2Linear(param_35);
        fragColor.x = _748.x;
        fragColor.y = _748.y;
        fragColor.z = _748.z;
        vec4 _756 = fragColor;
        vec3 _760 = _756.xyz * GetFinalColorFactor().xyz;
        fragColor.x = _760.x;
        fragColor.y = _760.y;
        fragColor.z = _760.z;
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
                        vec3 _815 = -vec3(nDir);
                        fragColor.x = _815.x;
                        fragColor.y = _815.y;
                        fragColor.z = _815.z;
                        fragColor.w = 1.0;
                    }
                }
            }
        }
    }
}
