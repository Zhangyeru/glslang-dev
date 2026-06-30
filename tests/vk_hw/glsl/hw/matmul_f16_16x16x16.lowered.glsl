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

layout(set = 0, binding = 1, std430) buffer InputB
{
    float16_t data[];
} B;

layout(set = 0, binding = 2, std430) buffer InputC
{
    float16_t data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float16_t data[];
} D;

f16vec4 _72(uint _73)
{
    return f16vec4(A.data[_73], A.data[_73 + 1u], A.data[_73 + 2u], A.data[_73 + 3u]);
}

f16vec4 _92(uint _93)
{
    return f16vec4(B.data[_93], B.data[_93 + 1u], B.data[_93 + 2u], B.data[_93 + 3u]);
}

f16vec4 _108(uint _109)
{
    return f16vec4(C.data[_109], C.data[_109 + 1u], C.data[_109 + 2u], C.data[_109 + 3u]);
}

void _125(uint _126, f16vec4 _127)
{
    D.data[_126] = _127.x;
    D.data[_126 + 1u] = _127.y;
    D.data[_126 + 2u] = _127.z;
    D.data[_126 + 3u] = _127.w;
}

void _146()
{
    uint _160 = 0u;
    uint _167;
    for (;;)
    {
        _167 = _160;
        if (_167 < 16u)
        {
            uint _161 = 0u;
            uint _169;
            for (;;)
            {
                _169 = _161;
                if (_169 < 4u)
                {
                    f16vec4 _163 = f16vec4(float16_t(0.0));
                    f16vec4 _164 = f16vec4(float16_t(0.0));
                    f16vec4 _165 = f16vec4(float16_t(0.0));
                    f16vec4 _166 = f16vec4(float16_t(0.0));
                    uint _162 = 0u;
                    uint _171;
                    for (;;)
                    {
                        _171 = _162;
                        if (_171 < 4u)
                        {
                            uint _173 = _171 * 4u;
                            uint _175 = (_167 * 16u) + _173;
                            f16vec4 _188 = _72(((uint(0) + (_175 / 16u)) * uint(16)) + (uint(0) + (_175 % 16u)));
                            uint _192 = ((_173 + 0u) * 16u) + (_169 * 4u);
                            f16vec4 _205 = _92(((uint(0) + (_192 / 16u)) * uint(16)) + (uint(0) + (_192 % 16u)));
                            uint _209 = ((_173 + 1u) * 16u) + (_169 * 4u);
                            f16vec4 _222 = _92(((uint(0) + (_209 / 16u)) * uint(16)) + (uint(0) + (_209 % 16u)));
                            uint _226 = ((_173 + 2u) * 16u) + (_169 * 4u);
                            f16vec4 _239 = _92(((uint(0) + (_226 / 16u)) * uint(16)) + (uint(0) + (_226 % 16u)));
                            uint _243 = ((_173 + 3u) * 16u) + (_169 * 4u);
                            f16vec4 _256 = _92(((uint(0) + (_243 / 16u)) * uint(16)) + (uint(0) + (_243 % 16u)));
                            _163 = fma(_188, f16vec4(_205.x, _222.x, _239.x, _256.x), _163);
                            _164 = fma(_188, f16vec4(_205.y, _222.y, _239.y, _256.y), _164);
                            _165 = fma(_188, f16vec4(_205.z, _222.z, _239.z, _256.z), _165);
                            _166 = fma(_188, f16vec4(_205.w, _222.w, _239.w, _256.w), _166);
                            _162 = _171 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _288 = (_167 * 16u) + (_169 * 4u);
                    f16vec4 _301 = _108(((uint(0) + (_288 / 16u)) * uint(16)) + (uint(0) + (_288 % 16u)));
                    uint _345 = (_167 * 16u) + (_169 * 4u);
                    _125(((uint(0) + (_345 / 16u)) * uint(16)) + (uint(0) + (_345 % 16u)), f16vec4(_301.x + (((_163.x + _163.y) + _163.z) + _163.w), _301.y + (((_164.x + _164.y) + _164.z) + _164.w), _301.z + (((_165.x + _165.y) + _165.z) + _165.w), _301.w + (((_166.x + _166.y) + _166.z) + _166.w)));
                    _161 = _169 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _160 = _167 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
}

void main()
{
    _146();
}

