#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_cooperative_vector : enable
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

    coopvecHW<float, 5> v;

    coopVecLoadHW(v, matrixBuf.matrixData);
    coopVecStoreHW(v, matrixBuf.matrixData);

    coopVecLoadHW(v, matrixBuf2.matrixData);
    coopVecStoreHW(v, matrixBuf2.matrixData);

    coopVecLoadHW(v, matrixBuf3.matrixData);
    coopVecStoreHW(v, matrixBuf3.matrixData);

    MatrixBuf4 matrixBuf4;
    coopVecLoadHW(v, matrixBuf4.matrixData);
    coopVecStoreHW(v, matrixBuf4.matrixData);
}
