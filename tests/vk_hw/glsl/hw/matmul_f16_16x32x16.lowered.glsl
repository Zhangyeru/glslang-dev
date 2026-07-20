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

f16vec4 _128(uint _129)
{
    return f16vec4(B.data[_129], B.data[_129 + 1u], B.data[_129 + 2u], B.data[_129 + 3u]);
}

f16vec4 _171(uint _172)
{
    return f16vec4(C.data[_172], C.data[_172 + 1u], C.data[_172 + 2u], C.data[_172 + 3u]);
}

void _265(uint _266, f16vec4 _267)
{
    D.data[_266] = _267.x;
    D.data[_266 + 1u] = _267.y;
    D.data[_266 + 2u] = _267.z;
    D.data[_266 + 3u] = _267.w;
}

void main()
{
    uint _104 = 0u;
    f16vec4 _103[64];
    uint _109;
    for (;;)
    {
        _109 = _104;
        if (_109 < 256u)
        {
            _103[_109 / 4u] = _77(((uint(0) + (_109 / 16u)) * uint(16)) + (uint(0) + (_109 % 16u)));
            _104 = _109 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _24[64] = _103;
    f16vec4 tempArg[64] = _24;
    f16vec4 a[64] = _24;
    uint _147 = 0u;
    f16vec4 _146[128];
    uint _152;
    for (;;)
    {
        _152 = _147;
        if (_152 < 512u)
        {
            _146[_152 / 4u] = _128(((uint(0) + (_152 / 32u)) * uint(32)) + (uint(0) + (_152 % 32u)));
            _147 = _152 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _39[128] = _146;
    f16vec4 tempArg_1[128] = _39;
    f16vec4 b[128] = _39;
    uint _188 = 0u;
    f16vec4 _187[128];
    uint _193;
    for (;;)
    {
        _193 = _188;
        if (_193 < 512u)
        {
            _187[_193 / 4u] = _171(((uint(0) + (_193 / 32u)) * uint(32)) + (uint(0) + (_193 % 32u)));
            _188 = _193 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 _51[128] = _187;
    f16vec4 tempArg_2[128] = _51;
    f16vec4 c[128] = _51;
    f16vec4 _214[64] = _24;
    f16vec4 _215[128] = _39;
    f16vec4 _216[128] = _51;
    f16vec4 _217[128] = f16vec4[](f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)));
    uint _218 = 0u;
    uint _229;
    for (;;)
    {
        _229 = _218;
        if (_229 < 512u)
        {
            float16_t _220 = _216[_229 / 4u][_229 % 4u];
            uint _219 = 0u;
            uint _236;
            for (;;)
            {
                _236 = _219;
                if (_236 < 16u)
                {
                    uint _241 = ((_229 / 32u) * 16u) + _236;
                    uint _243 = (_236 * 32u) + (_229 % 32u);
                    _220 = fma(_214[_241 / 4u][_241 % 4u], _215[_243 / 4u][_243 % 4u], _220);
                    _219 = _236 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            uint _258 = _229 / 4u;
            f16vec4 _262 = _217[_258];
            _262[_229 % 4u] = _220;
            _217[_258] = _262;
            _218 = _229 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec4 tempArg_3[128] = _217;
    f16vec4 d[128] = _217;
    f16vec4 _281[128] = _217;
    uint _282 = 0u;
    uint _287;
    for (;;)
    {
        _287 = _282;
        if (_287 < 512u)
        {
            _265(((uint(0) + (_287 / 32u)) * uint(32)) + (uint(0) + (_287 % 32u)), _281[_287 / 4u]);
            _282 = _287 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

