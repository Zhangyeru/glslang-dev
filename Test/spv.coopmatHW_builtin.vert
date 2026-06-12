#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_neural_matrix : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

layout(set = 0, binding = 0) buffer BufF16 {
    float16_t data[];
} bufF16;

layout(set = 0, binding = 1) buffer BufI8 {
    int8_t data[];
} bufI8;

layout(set = 0, binding = 2) buffer BufU16 {
    uint16_t data[];
} bufU16;

void main()
{
    gl_Position = vec4(0.0);

    const vec2 shape16x8 = vec2(16.0, 8.0);
    const vec2 shape8x8 = vec2(8.0, 8.0);
    const vec2 shape8x16 = vec2(8.0, 16.0);
    const vec2 shape16x16 = vec2(16.0, 16.0);
    const vec2 shape4x16 = vec2(4.0, 16.0);
    const vec2 shape16x4 = vec2(16.0, 4.0);
    const vec2 shape4x4 = vec2(4.0, 4.0);

    coopmatHW<float16_t, 16, 8> fA, fC, fR;
    coopmatHW<float16_t, 8, 8> fB;
    coopmatHW<float, 8, 8> fMulR;

    coopMatLoadHW(fA, bufF16.data, shape16x8, vec2(1.0, 2.0), gl_RowMajorHW);
    coopMatLoadHW(fB, bufF16.data, shape8x8, vec2(3.0, 4.0), gl_ColumnMajorHW);
    coopMatLoadHW(fC, bufF16.data, shape16x8, vec2(5.0, 6.0), gl_RowMajorHW);
    coopMatMulHW(fMulR, fB, fB);
    coopMatMulAddHW(fC, fA, fB, fC);
    fR = coopMatReduceHW(fC, gl_ReduceRowHW, gl_ReduceAddHW);
    coopMatStoreHW(fR, bufF16.data, shape16x8, vec2(7.0, 8.0), gl_ColumnMajorHW);
    int lf = fR.length() + fMulR.length();

    coopmatHW<int8_t, 16, 8> iA;
    coopmatHW<int8_t, 8, 16> iB;
    coopmatHW<int8_t, 16, 16> iC, iOperand, iR;
    coopmatHW<int, 16, 16> iMulR;

    coopMatLoadHW(iA, bufI8.data, shape16x8, vec2(9.0, 10.0), gl_RowMajorHW);
    coopMatLoadHW(iB, bufI8.data, shape8x16, vec2(11.0, 12.0), gl_ColumnMajorHW);
    coopMatLoadHW(iC, bufI8.data, shape16x16, vec2(13.0, 14.0), gl_RowMajorHW);
    iOperand = iC;
    coopMatMulHW(iMulR, iOperand, iOperand);
    coopMatMulAddHW(iC, iA, iB, iC);
    iR = coopMatReduceHW(iC, gl_ReduceColumnHW, gl_ReduceMinHW);
    coopMatStoreHW(iR, bufI8.data, shape16x16, vec2(15.0, 16.0), gl_ColumnMajorHW);
    int li = iR.length() + iMulR.length();

    coopmatHW<uint16_t, 4, 16> uA;
    coopmatHW<uint16_t, 16, 4> uB;
    coopmatHW<uint16_t, 4, 4> uC, uOperand, uR;
    coopmatHW<uint, 4, 4> uMulR;

    coopMatLoadHW(uA, bufU16.data, shape4x16, vec2(17.0, 18.0), gl_RowMajorHW);
    coopMatLoadHW(uB, bufU16.data, shape16x4, vec2(19.0, 20.0), gl_ColumnMajorHW);
    coopMatLoadHW(uC, bufU16.data, shape4x4, vec2(21.0, 22.0), gl_RowMajorHW);
    uOperand = uC;
    coopMatMulHW(uMulR, uOperand, uOperand);
    coopMatMulAddHW(uC, uA, uB, uC);
    uR = coopMatReduceHW(uC, gl_ReduceRowHW, gl_ReduceMaxHW);
    coopMatStoreHW(uR, bufU16.data, shape4x4, vec2(23.0, 24.0), gl_ColumnMajorHW);
    int lu = uR.length() + uMulR.length();

    if (lf + li + lu == 0) {
        fC = fR;
        iC = iR;
        uC = uR;
    }
}
