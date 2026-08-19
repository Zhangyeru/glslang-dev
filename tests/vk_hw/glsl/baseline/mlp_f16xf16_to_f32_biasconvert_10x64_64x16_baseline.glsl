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

layout(set = 0, binding = 1, std430) buffer PackedParameters
{
    float16_t data[];
} Params;

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[10];
} InX;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float y[16];
} OutY;

void main()
{
    vec2 outputPairs[8];
    for (int outputPair = 0; outputPair < 8; outputPair++)
    {
        int outputCol = outputPair * 2;
        outputPairs[outputPair] = vec2(float(Params.data[3584 + outputCol]), float(Params.data[(3584 + outputCol) + 1]));
    }
    for (int hiddenPair = 0; hiddenPair < 32; hiddenPair++)
    {
        int hiddenCol = hiddenPair * 2;
        vec2 hidden = vec2(float(Params.data[3456 + hiddenCol]), float(Params.data[(3456 + hiddenCol) + 1]));
        for (int k = 0; k < 10; k++)
        {
            vec2 weight = vec2(float(Params.data[(16 + (k * 64)) + hiddenCol]), float(Params.data[((16 + (k * 64)) + hiddenCol) + 1]));
            hidden = fma(vec2(float(InX.x[k])), weight, hidden);
        }
        hidden = max(hidden, vec2(0.0));
        vec2 activation = unpackHalf2x16(packHalf2x16(hidden));
        for (int outputPair_1 = 0; outputPair_1 < 8; outputPair_1++)
        {
            int outputCol_1 = outputPair_1 * 2;
            vec2 weight0 = vec2(float(Params.data[(656 + (hiddenCol * 16)) + outputCol_1]), float(Params.data[((656 + (hiddenCol * 16)) + outputCol_1) + 1]));
            vec2 weight1 = vec2(float(Params.data[(656 + ((hiddenCol + 1) * 16)) + outputCol_1]), float(Params.data[((656 + ((hiddenCol + 1) * 16)) + outputCol_1) + 1]));
            outputPairs[outputPair_1] = fma(vec2(activation.x), weight0, outputPairs[outputPair_1]);
            outputPairs[outputPair_1] = fma(vec2(activation.y), weight1, outputPairs[outputPair_1]);
        }
    }
    for (int outputPair_2 = 0; outputPair_2 < 8; outputPair_2++)
    {
        vec2 result = max(outputPairs[outputPair_2], vec2(0.0));
        int outputCol_2 = outputPair_2 * 2;
        OutY.y[outputCol_2] = result.x;
        OutY.y[outputCol_2 + 1] = result.y;
    }
}

