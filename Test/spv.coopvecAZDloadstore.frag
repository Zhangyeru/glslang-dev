#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable
#extension GL_EXT_buffer_reference : enable
#extension GL_EXT_nonuniform_qualifier : enable

layout(location = 0) out vec4 outColor;

layout(set = 0, binding = 0) buffer MatrixBuf {
    u64vec3 matrixData[];
} matrixBuf;

layout(set = 0, binding = 0) buffer MatrixBuf2 {
    coherent float16_t matrixData[];
} matrixBuf2;

layout(set = 0, binding = 0) coherent buffer MatrixBuf3 {
    volatile float32_t matrixData[];
} matrixBuf3;

layout(set = 0, binding = 0, buffer_reference) buffer MatrixBuf4 {
    coherent float16_t matrixData[];
};

void main()
{
    outColor = vec4(1.0);

    coopvecAZD<float, 5> v;

    coopVecLoadAZD(v, matrixBuf.matrixData);
    coopVecStoreAZD(v, matrixBuf.matrixData);

    coopVecLoadAZD(v, matrixBuf2.matrixData);
    coopVecStoreAZD(v, matrixBuf2.matrixData);

    coopVecLoadAZD(v, matrixBuf3.matrixData);
    coopVecStoreAZD(v, matrixBuf3.matrixData);

    MatrixBuf4 matrixBuf4;
    coopVecLoadAZD(v, matrixBuf4.matrixData);
    coopVecStoreAZD(v, matrixBuf4.matrixData);
}
