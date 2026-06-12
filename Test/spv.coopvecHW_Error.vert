#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_HW_neural_shader : enable
#extension GL_NV_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopvecHW<float, 5> vAD;
    coopvecNV<float, 5> vNV;

    vAD = vNV;
    vNV = vAD;
    coopvecHW<float, 5>(vNV);

    coopvecHW<float> bad1;
    coopvecHW<float, 0> bad2;
    coopvecHW<float, -1> bad3;
    coopvecHW<float, float> bad4;
}
