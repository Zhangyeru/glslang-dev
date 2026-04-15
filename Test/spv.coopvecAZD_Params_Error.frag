#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

coopvecAZD<float> bad1;
coopvecAZD<float, 0> bad2;
coopvecAZD<float, -1> bad3;
coopvecAZD<float, float> bad4;

void main()
{
}
