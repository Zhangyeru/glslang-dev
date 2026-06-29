#version 450
#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) buffer InputA
{
    float16_t data[];
} A;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

f16vec4 loadChunk(int base)
{
    return f16vec4(A.data[base + 0], A.data[base + 1], A.data[base + 2], A.data[base + 3]);
}

void storeChunk(int base, f16vec4 value)
{
    D.data[base + 0] = value.x;
    D.data[base + 1] = value.y;
    D.data[base + 2] = value.z;
    D.data[base + 3] = value.w;
}

void main()
{
    for (int base = 0; base < 64; base += 4)
    {
        int param = base;
        int param_1 = base;
        f16vec4 param_2 = loadChunk(param);
        storeChunk(param_1, param_2);
    }
}

