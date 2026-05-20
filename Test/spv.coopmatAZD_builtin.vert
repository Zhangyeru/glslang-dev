#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_neural_matrix : enable
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

    coopmatAZD<float16_t, 16, 8> fA, fC, fR;
    coopmatAZD<float16_t, 8, 8> fB;
    coopmatAZD<float, 8, 8> fMulR;

    coopMatLoadAZD(fA, bufF16.data, shape16x8, vec2(1.0, 2.0), gl_RowMajorAZD);
    coopMatLoadAZD(fB, bufF16.data, shape8x8, vec2(3.0, 4.0), gl_ColumnMajorAZD);
    coopMatLoadAZD(fC, bufF16.data, shape16x8, vec2(5.0, 6.0), gl_RowMajorAZD);
    coopMatMulAZD(fMulR, fB, fB);
    coopMatMulAddAZD(fC, fA, fB, fC);
    fR = coopMatReduceAZD(fC, gl_ReduceRowAZD, gl_ReduceAddAZD);
    coopMatStoreAZD(fR, bufF16.data, shape16x8, vec2(7.0, 8.0), gl_ColumnMajorAZD);
    int lf = fR.length() + fMulR.length();

    coopmatAZD<int8_t, 16, 8> iA;
    coopmatAZD<int8_t, 8, 16> iB;
    coopmatAZD<int8_t, 16, 16> iC, iOperand, iR;
    coopmatAZD<int, 16, 16> iMulR;

    coopMatLoadAZD(iA, bufI8.data, shape16x8, vec2(9.0, 10.0), gl_RowMajorAZD);
    coopMatLoadAZD(iB, bufI8.data, shape8x16, vec2(11.0, 12.0), gl_ColumnMajorAZD);
    coopMatLoadAZD(iC, bufI8.data, shape16x16, vec2(13.0, 14.0), gl_RowMajorAZD);
    iOperand = iC;
    coopMatMulAZD(iMulR, iOperand, iOperand);
    coopMatMulAddAZD(iC, iA, iB, iC);
    iR = coopMatReduceAZD(iC, gl_ReduceColumnAZD, gl_ReduceMinAZD);
    coopMatStoreAZD(iR, bufI8.data, shape16x16, vec2(15.0, 16.0), gl_ColumnMajorAZD);
    int li = iR.length() + iMulR.length();

    coopmatAZD<uint16_t, 4, 16> uA;
    coopmatAZD<uint16_t, 16, 4> uB;
    coopmatAZD<uint16_t, 4, 4> uC, uOperand, uR;
    coopmatAZD<uint, 4, 4> uMulR;

    coopMatLoadAZD(uA, bufU16.data, shape4x16, vec2(17.0, 18.0), gl_RowMajorAZD);
    coopMatLoadAZD(uB, bufU16.data, shape16x4, vec2(19.0, 20.0), gl_ColumnMajorAZD);
    coopMatLoadAZD(uC, bufU16.data, shape4x4, vec2(21.0, 22.0), gl_RowMajorAZD);
    uOperand = uC;
    coopMatMulAZD(uMulR, uOperand, uOperand);
    coopMatMulAddAZD(uC, uA, uB, uC);
    uR = coopMatReduceAZD(uC, gl_ReduceRowAZD, gl_ReduceMaxAZD);
    coopMatStoreAZD(uR, bufU16.data, shape4x4, vec2(23.0, 24.0), gl_ColumnMajorAZD);
    int lu = uR.length() + uMulR.length();

    if (lf + li + lu == 0) {
        fC = fR;
        iC = iR;
        uC = uR;
    }
}
