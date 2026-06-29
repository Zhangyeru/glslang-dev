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

f16vec4 _77(uint _78)
{
    return f16vec4(A.data[_78], A.data[_78 + 1u], A.data[_78 + 2u], A.data[_78 + 3u]);
}

f16vec4 _97(uint _98)
{
    return f16vec4(B.data[_98], B.data[_98 + 1u], B.data[_98 + 2u], B.data[_98 + 3u]);
}

f16vec4 _113(uint _114)
{
    return f16vec4(C.data[_114], C.data[_114 + 1u], C.data[_114 + 2u], C.data[_114 + 3u]);
}

f16vec4[128] _137()
{
    uint _152 = 0u;
    f16vec4 _151[128];
    uint _159;
    for (;;)
    {
        _159 = _152;
        if (_159 < 16u)
        {
            uint _153 = 0u;
            uint _161;
            for (;;)
            {
                _161 = _153;
                if (_161 < 8u)
                {
                    f16vec4 _155 = f16vec4(float16_t(0.0));
                    f16vec4 _156 = f16vec4(float16_t(0.0));
                    f16vec4 _157 = f16vec4(float16_t(0.0));
                    f16vec4 _158 = f16vec4(float16_t(0.0));
                    uint _154 = 0u;
                    uint _163;
                    for (;;)
                    {
                        _163 = _154;
                        if (_163 < 4u)
                        {
                            uint _165 = _163 * 4u;
                            uint _167 = (_159 * 16u) + _165;
                            f16vec4 _180 = _77(((uint(0) + (_167 / 16u)) * uint(16)) + (uint(0) + (_167 % 16u)));
                            uint _184 = ((_165 + 0u) * 32u) + (_161 * 4u);
                            f16vec4 _197 = _97(((uint(0) + (_184 / 32u)) * uint(32)) + (uint(0) + (_184 % 32u)));
                            uint _201 = ((_165 + 1u) * 32u) + (_161 * 4u);
                            f16vec4 _214 = _97(((uint(0) + (_201 / 32u)) * uint(32)) + (uint(0) + (_201 % 32u)));
                            uint _218 = ((_165 + 2u) * 32u) + (_161 * 4u);
                            f16vec4 _231 = _97(((uint(0) + (_218 / 32u)) * uint(32)) + (uint(0) + (_218 % 32u)));
                            uint _235 = ((_165 + 3u) * 32u) + (_161 * 4u);
                            f16vec4 _248 = _97(((uint(0) + (_235 / 32u)) * uint(32)) + (uint(0) + (_235 % 32u)));
                            _155 = fma(_180, f16vec4(_197.x, _214.x, _231.x, _248.x), _155);
                            _156 = fma(_180, f16vec4(_197.y, _214.y, _231.y, _248.y), _156);
                            _157 = fma(_180, f16vec4(_197.z, _214.z, _231.z, _248.z), _157);
                            _158 = fma(_180, f16vec4(_197.w, _214.w, _231.w, _248.w), _158);
                            _154 = _163 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _282 = (_159 * 32u) + (_161 * 4u);
                    f16vec4 _295 = _113(((uint(0) + (_282 / 32u)) * uint(32)) + (uint(0) + (_282 % 32u)));
                    _151[(_159 * 8u) + _161] = f16vec4(_295.x + (((_155.x + _155.y) + _155.z) + _155.w), _295.y + (((_156.x + _156.y) + _156.z) + _156.w), _295.z + (((_157.x + _157.y) + _157.z) + _157.w), _295.w + (((_158.x + _158.y) + _158.z) + _158.w));
                    _153 = _161 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _152 = _159 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _151;
}

void _342(uint _343, f16vec4 _344)
{
    D.data[_343] = _344.x;
    D.data[_343 + 1u] = _344.y;
    D.data[_343 + 2u] = _344.z;
    D.data[_343 + 3u] = _344.w;
}

void main()
{
    f16vec4 _58[128] = _137();
    f16vec4 tempArg[128] = _58;
    f16vec4 d[128] = _58;
    f16vec4 _359[128] = _58;
    uint _360 = 0u;
    uint _365;
    for (;;)
    {
        _365 = _360;
        if (_365 < 512u)
        {
            _342(((uint(0) + (_365 / 32u)) * uint(32)) + (uint(0) + (_365 % 32u)), _359[_365 / 4u]);
            _360 = _365 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

