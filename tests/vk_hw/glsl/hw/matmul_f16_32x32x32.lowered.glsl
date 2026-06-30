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

void _147()
{
    uint _161 = 0u;
    uint _168;
    for (;;)
    {
        _168 = _161;
        if (_168 < 32u)
        {
            uint _162 = 0u;
            uint _170;
            for (;;)
            {
                _170 = _162;
                if (_170 < 8u)
                {
                    f16vec4 _164 = f16vec4(float16_t(0.0));
                    f16vec4 _165 = f16vec4(float16_t(0.0));
                    f16vec4 _166 = f16vec4(float16_t(0.0));
                    f16vec4 _167 = f16vec4(float16_t(0.0));
                    uint _163 = 0u;
                    uint _172;
                    for (;;)
                    {
                        _172 = _163;
                        if (_172 < 8u)
                        {
                            uint _174 = _172 * 4u;
                            uint _176 = (_168 * 32u) + _174;
                            f16vec4 _189 = _72(((uint(0) + (_176 / 32u)) * uint(32)) + (uint(0) + (_176 % 32u)));
                            uint _193 = ((_174 + 0u) * 32u) + (_170 * 4u);
                            f16vec4 _206 = _92(((uint(0) + (_193 / 32u)) * uint(32)) + (uint(0) + (_193 % 32u)));
                            uint _210 = ((_174 + 1u) * 32u) + (_170 * 4u);
                            f16vec4 _223 = _92(((uint(0) + (_210 / 32u)) * uint(32)) + (uint(0) + (_210 % 32u)));
                            uint _227 = ((_174 + 2u) * 32u) + (_170 * 4u);
                            f16vec4 _240 = _92(((uint(0) + (_227 / 32u)) * uint(32)) + (uint(0) + (_227 % 32u)));
                            uint _244 = ((_174 + 3u) * 32u) + (_170 * 4u);
                            f16vec4 _257 = _92(((uint(0) + (_244 / 32u)) * uint(32)) + (uint(0) + (_244 % 32u)));
                            _164 = fma(_189, f16vec4(_206.x, _223.x, _240.x, _257.x), _164);
                            _165 = fma(_189, f16vec4(_206.y, _223.y, _240.y, _257.y), _165);
                            _166 = fma(_189, f16vec4(_206.z, _223.z, _240.z, _257.z), _166);
                            _167 = fma(_189, f16vec4(_206.w, _223.w, _240.w, _257.w), _167);
                            _163 = _172 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _289 = (_168 * 32u) + (_170 * 4u);
                    f16vec4 _302 = _108(((uint(0) + (_289 / 32u)) * uint(32)) + (uint(0) + (_289 % 32u)));
                    uint _346 = (_168 * 32u) + (_170 * 4u);
                    _125(((uint(0) + (_346 / 32u)) * uint(32)) + (uint(0) + (_346 % 32u)), f16vec4(_302.x + (((_164.x + _164.y) + _164.z) + _164.w), _302.y + (((_165.x + _165.y) + _165.z) + _165.w), _302.z + (((_166.x + _166.y) + _166.z) + _166.w), _302.w + (((_167.x + _167.y) + _167.z) + _167.w)));
                    _162 = _170 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _161 = _168 + 1u;
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
    _147();
}

