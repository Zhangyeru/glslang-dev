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

void _130(uint _131, f16vec4 _132)
{
    D.data[_131] = _132.x;
    D.data[_131 + 1u] = _132.y;
    D.data[_131 + 2u] = _132.z;
    D.data[_131 + 3u] = _132.w;
}

void _152()
{
    uint _166 = 0u;
    uint _173;
    for (;;)
    {
        _173 = _166;
        if (_173 < 16u)
        {
            uint _167 = 0u;
            uint _175;
            for (;;)
            {
                _175 = _167;
                if (_175 < 8u)
                {
                    f16vec4 _169 = f16vec4(float16_t(0.0));
                    f16vec4 _170 = f16vec4(float16_t(0.0));
                    f16vec4 _171 = f16vec4(float16_t(0.0));
                    f16vec4 _172 = f16vec4(float16_t(0.0));
                    uint _168 = 0u;
                    uint _177;
                    for (;;)
                    {
                        _177 = _168;
                        if (_177 < 4u)
                        {
                            uint _179 = _177 * 4u;
                            uint _181 = (_173 * 16u) + _179;
                            f16vec4 _194 = _77(((uint(0) + (_181 / 16u)) * uint(16)) + (uint(0) + (_181 % 16u)));
                            uint _198 = ((_179 + 0u) * 32u) + (_175 * 4u);
                            f16vec4 _211 = _97(((uint(0) + (_198 / 32u)) * uint(32)) + (uint(0) + (_198 % 32u)));
                            uint _215 = ((_179 + 1u) * 32u) + (_175 * 4u);
                            f16vec4 _228 = _97(((uint(0) + (_215 / 32u)) * uint(32)) + (uint(0) + (_215 % 32u)));
                            uint _232 = ((_179 + 2u) * 32u) + (_175 * 4u);
                            f16vec4 _245 = _97(((uint(0) + (_232 / 32u)) * uint(32)) + (uint(0) + (_232 % 32u)));
                            uint _249 = ((_179 + 3u) * 32u) + (_175 * 4u);
                            f16vec4 _262 = _97(((uint(0) + (_249 / 32u)) * uint(32)) + (uint(0) + (_249 % 32u)));
                            _169 = fma(_194, f16vec4(_211.x, _228.x, _245.x, _262.x), _169);
                            _170 = fma(_194, f16vec4(_211.y, _228.y, _245.y, _262.y), _170);
                            _171 = fma(_194, f16vec4(_211.z, _228.z, _245.z, _262.z), _171);
                            _172 = fma(_194, f16vec4(_211.w, _228.w, _245.w, _262.w), _172);
                            _168 = _177 + 1u;
                            continue;
                        }
                        else
                        {
                            break;
                        }
                    }
                    uint _294 = (_173 * 32u) + (_175 * 4u);
                    f16vec4 _307 = _113(((uint(0) + (_294 / 32u)) * uint(32)) + (uint(0) + (_294 % 32u)));
                    uint _351 = (_173 * 32u) + (_175 * 4u);
                    _130(((uint(0) + (_351 / 32u)) * uint(32)) + (uint(0) + (_351 % 32u)), f16vec4(_307.x + (((_169.x + _169.y) + _169.z) + _169.w), _307.y + (((_170.x + _170.y) + _170.z) + _170.w), _307.z + (((_171.x + _171.y) + _171.z) + _171.w), _307.w + (((_172.x + _172.y) + _172.z) + _172.w)));
                    _167 = _175 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _166 = _173 + 1u;
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
    _152();
}

