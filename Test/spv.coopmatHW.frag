#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_neural_shader : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

layout(location = 0) out vec4 outColor;

layout(set = 0, binding = 0) buffer Buf {
    float16_t data[];
} buf;

void main()
{
    outColor = vec4(1.0);

    const uint srcMatrixOffset = 16;
    const uint dstMatrixOffset = 32;
    const uint matrixStride = 32;

    coopmatHW<float16_t, 16, 8> A = coopmatHW<float16_t, 16, 8>(0.0);
    coopmatHW<float16_t, 8, 8> B = coopmatHW<float16_t, 8, 8>(1.0);
    coopmatHW<float16_t, 8, 8> S = coopmatHW<float16_t, 8, 8>(2.0);
    coopmatHW<float16_t, 16, 8> C;
    coopmatHW<float, 8, 8> M;
    coopmatHW<float16_t, 16, 8> R0;
    coopmatHW<float16_t, 16, 8> R1;

    coopMatLoadHW(C, buf.data, srcMatrixOffset, matrixStride, gl_CooperativeMatrixLayoutRowMajorHW);
    coopMatMulHW(M, S, B);
    coopMatMulAddHW(C, A, B, C);
    R0 = coopMatReduceHW(C, gl_CooperativeMatrixReduceRowHW, gl_CooperativeMatrixReduceAddHW);
    R1 = coopMatReduceHW(C, gl_CooperativeMatrixReduceColumnHW, gl_CooperativeMatrixReduceMaxHW);
    coopMatStoreHW(C, buf.data, dstMatrixOffset, matrixStride, gl_CooperativeMatrixLayoutColumnMajorHW);

    int len = C.length() + M.length();
    coopmatHW<float16_t, 16, 8> D = coopmatHW<float16_t, 16, 8>(C);
    C = D;
    if (len == 0)
        C = coopmatHW<float16_t, 16, 8>(0.0);
}
