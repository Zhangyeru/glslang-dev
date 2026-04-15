#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_cooperative_vector : enable
#extension GL_NV_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

void main()
{
    coopvecAZD<float, 5> vAD;
    coopvecNV<float, 5> vNV;

    vAD = vNV;
    vNV = vAD;
    coopvecAZD<float, 5>(vNV);

    coopvecAZD<float> bad1;
    coopvecAZD<float, 0> bad2;
    coopvecAZD<float, -1> bad3;
    coopvecAZD<float, float> bad4;
}
