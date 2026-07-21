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

const f16vec4 _70[16] = f16vec4[](f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)));
const f16vec4 _96[4] = f16vec4[](f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)));
const f16vec4 _125[2] = f16vec4[](f16vec4(float16_t(0.0)), f16vec4(float16_t(0.0)));

layout(set = 0, binding = 0, std430) buffer InputX
{
    float16_t x[64];
} InX;

layout(set = 0, binding = 1, std430) buffer PackedWeights
{
    float16_t w1[1024];
    float16_t w2[1024];
    float16_t w3[128];
} Weights;

layout(set = 0, binding = 2, std430) buffer PackedBias
{
    float16_t b1[64];
    float16_t b2[16];
    float16_t b3[8];
} Biases;

layout(set = 0, binding = 3, std430) buffer OutputY
{
    float16_t y[8];
} OutY;

f16vec4 _148(uint _149)
{
    return f16vec4(InX.x[_149], InX.x[_149 + 1u], InX.x[_149 + 2u], InX.x[_149 + 3u]);
}

f16vec4 _166(uint _167)
{
    return f16vec4(Weights.w1[_167], Weights.w1[_167 + 1u], Weights.w1[_167 + 2u], Weights.w1[_167 + 3u]);
}

f16vec4 _182(uint _183)
{
    return f16vec4(Biases.b1[_183], Biases.b1[_183 + 1u], Biases.b1[_183 + 2u], Biases.b1[_183 + 3u]);
}

f16vec4[16] _204()
{
    uint _215 = 0u;
    f16vec4 _214[16];
    uint _221;
    for (;;)
    {
        _221 = _215;
        if (_221 < 16u)
        {
            f16vec4 _217 = f16vec4(float16_t(0.0));
            f16vec4 _218 = f16vec4(float16_t(0.0));
            f16vec4 _219 = f16vec4(float16_t(0.0));
            f16vec4 _220 = f16vec4(float16_t(0.0));
            uint _216 = 0u;
            uint _223;
            for (;;)
            {
                _223 = _216;
                if (_223 < 4u)
                {
                    uint _225 = _223 * 4u;
                    f16vec4 _226 = _148(_225);
                    uint _227 = _221 * 4u;
                    uint _230 = ((_225 + 0u) * 64u) + _227;
                    f16vec4 _243 = _166(((uint(0) + (_230 / 64u)) * uint(64)) + (uint(0) + (_230 % 64u)));
                    uint _246 = ((_225 + 1u) * 64u) + _227;
                    f16vec4 _259 = _166(((uint(0) + (_246 / 64u)) * uint(64)) + (uint(0) + (_246 % 64u)));
                    uint _262 = ((_225 + 2u) * 64u) + _227;
                    f16vec4 _275 = _166(((uint(0) + (_262 / 64u)) * uint(64)) + (uint(0) + (_262 % 64u)));
                    uint _278 = ((_225 + 3u) * 64u) + _227;
                    f16vec4 _291 = _166(((uint(0) + (_278 / 64u)) * uint(64)) + (uint(0) + (_278 % 64u)));
                    _217 = fma(_226, f16vec4(_243.x, _259.x, _275.x, _291.x), _217);
                    _218 = fma(_226, f16vec4(_243.y, _259.y, _275.y, _291.y), _218);
                    _219 = fma(_226, f16vec4(_243.z, _259.z, _275.z, _291.z), _219);
                    _220 = fma(_226, f16vec4(_243.w, _259.w, _275.w, _291.w), _220);
                    _216 = _223 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _214[_221] = f16vec4(((_217.x + _217.y) + _217.z) + _217.w, ((_218.x + _218.y) + _218.z) + _218.w, ((_219.x + _219.y) + _219.z) + _219.w, ((_220.x + _220.y) + _220.z) + _220.w) + _182(_221 * 4u);
            _215 = _221 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _214;
}

f16vec4 _360(uint _361)
{
    return f16vec4(Weights.w2[_361], Weights.w2[_361 + 1u], Weights.w2[_361 + 2u], Weights.w2[_361 + 3u]);
}

f16vec4 _376(uint _377)
{
    return f16vec4(Biases.b2[_377], Biases.b2[_377 + 1u], Biases.b2[_377 + 2u], Biases.b2[_377 + 3u]);
}

f16vec4[4] _394(f16vec4 _395[16])
{
    f16vec4 _412[16] = _395;
    uint _406 = 0u;
    f16vec4 _405[4];
    uint _413;
    for (;;)
    {
        _413 = _406;
        if (_413 < 4u)
        {
            f16vec4 _408 = f16vec4(float16_t(0.0));
            f16vec4 _409 = f16vec4(float16_t(0.0));
            f16vec4 _410 = f16vec4(float16_t(0.0));
            f16vec4 _411 = f16vec4(float16_t(0.0));
            uint _407 = 0u;
            uint _415;
            for (;;)
            {
                _415 = _407;
                if (_415 < 16u)
                {
                    uint _417 = _415 * 4u;
                    uint _420 = _413 * 4u;
                    uint _423 = ((_417 + 0u) * 16u) + _420;
                    f16vec4 _436 = _360(((uint(0) + (_423 / 16u)) * uint(16)) + (uint(0) + (_423 % 16u)));
                    uint _439 = ((_417 + 1u) * 16u) + _420;
                    f16vec4 _452 = _360(((uint(0) + (_439 / 16u)) * uint(16)) + (uint(0) + (_439 % 16u)));
                    uint _455 = ((_417 + 2u) * 16u) + _420;
                    f16vec4 _468 = _360(((uint(0) + (_455 / 16u)) * uint(16)) + (uint(0) + (_455 % 16u)));
                    uint _471 = ((_417 + 3u) * 16u) + _420;
                    f16vec4 _484 = _360(((uint(0) + (_471 / 16u)) * uint(16)) + (uint(0) + (_471 % 16u)));
                    _408 = fma(_412[_415], f16vec4(_436.x, _452.x, _468.x, _484.x), _408);
                    _409 = fma(_412[_415], f16vec4(_436.y, _452.y, _468.y, _484.y), _409);
                    _410 = fma(_412[_415], f16vec4(_436.z, _452.z, _468.z, _484.z), _410);
                    _411 = fma(_412[_415], f16vec4(_436.w, _452.w, _468.w, _484.w), _411);
                    _407 = _415 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _405[_413] = f16vec4(((_408.x + _408.y) + _408.z) + _408.w, ((_409.x + _409.y) + _409.z) + _409.w, ((_410.x + _410.y) + _410.z) + _410.w, ((_411.x + _411.y) + _411.z) + _411.w) + _376(_413 * 4u);
            _406 = _413 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _405;
}

f16vec4 _553(uint _554)
{
    return f16vec4(Weights.w3[_554], Weights.w3[_554 + 1u], Weights.w3[_554 + 2u], Weights.w3[_554 + 3u]);
}

f16vec4 _569(uint _570)
{
    return f16vec4(Biases.b3[_570], Biases.b3[_570 + 1u], Biases.b3[_570 + 2u], Biases.b3[_570 + 3u]);
}

f16vec4[2] _587(f16vec4 _588[4])
{
    f16vec4 _605[4] = _588;
    uint _599 = 0u;
    f16vec4 _598[2];
    uint _606;
    for (;;)
    {
        _606 = _599;
        if (_606 < 2u)
        {
            f16vec4 _601 = f16vec4(float16_t(0.0));
            f16vec4 _602 = f16vec4(float16_t(0.0));
            f16vec4 _603 = f16vec4(float16_t(0.0));
            f16vec4 _604 = f16vec4(float16_t(0.0));
            uint _600 = 0u;
            uint _608;
            for (;;)
            {
                _608 = _600;
                if (_608 < 4u)
                {
                    uint _610 = _608 * 4u;
                    uint _613 = _606 * 4u;
                    uint _616 = ((_610 + 0u) * 8u) + _613;
                    f16vec4 _629 = _553(((uint(0) + (_616 / 8u)) * uint(8)) + (uint(0) + (_616 % 8u)));
                    uint _632 = ((_610 + 1u) * 8u) + _613;
                    f16vec4 _645 = _553(((uint(0) + (_632 / 8u)) * uint(8)) + (uint(0) + (_632 % 8u)));
                    uint _648 = ((_610 + 2u) * 8u) + _613;
                    f16vec4 _661 = _553(((uint(0) + (_648 / 8u)) * uint(8)) + (uint(0) + (_648 % 8u)));
                    uint _664 = ((_610 + 3u) * 8u) + _613;
                    f16vec4 _677 = _553(((uint(0) + (_664 / 8u)) * uint(8)) + (uint(0) + (_664 % 8u)));
                    _601 = fma(_605[_608], f16vec4(_629.x, _645.x, _661.x, _677.x), _601);
                    _602 = fma(_605[_608], f16vec4(_629.y, _645.y, _661.y, _677.y), _602);
                    _603 = fma(_605[_608], f16vec4(_629.z, _645.z, _661.z, _677.z), _603);
                    _604 = fma(_605[_608], f16vec4(_629.w, _645.w, _661.w, _677.w), _604);
                    _600 = _608 + 1u;
                    continue;
                }
                else
                {
                    break;
                }
            }
            _598[_606] = f16vec4(((_601.x + _601.y) + _601.z) + _601.w, ((_602.x + _602.y) + _602.z) + _602.w, ((_603.x + _603.y) + _603.z) + _603.w, ((_604.x + _604.y) + _604.z) + _604.w) + _569(_606 * 4u);
            _599 = _606 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    return _598;
}

void _800(uint _801, f16vec4 _802)
{
    OutY.y[_801] = _802.x;
    OutY.y[_801 + 1u] = _802.y;
    OutY.y[_801 + 2u] = _802.z;
    OutY.y[_801 + 3u] = _802.w;
}

void main()
{
    f16vec4 _65[16] = _204();
    f16vec4 tempArg[16] = _65;
    f16vec4 h1[16] = _65;
    f16vec4 _750[16] = _65;
    uint _749 = 0u;
    f16vec4 _748[16];
    uint _756;
    for (;;)
    {
        _756 = _749;
        if (_756 < 16u)
        {
            _748[_756] = max(_750[_756], _70[_756]);
            _749 = _756 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    h1 = _748;
    f16vec4 _92[4] = _394(_748);
    f16vec4 tempArg_1[4] = _92;
    f16vec4 h2[4] = _92;
    f16vec4 _767[4] = _92;
    uint _766 = 0u;
    f16vec4 _765[4];
    uint _773;
    for (;;)
    {
        _773 = _766;
        if (_773 < 4u)
        {
            _765[_773] = max(_767[_773], _96[_773]);
            _766 = _773 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    h2 = _765;
    f16vec4 _121[2] = _587(_765);
    f16vec4 tempArg_2[2] = _121;
    f16vec4 y[2] = _121;
    f16vec4 _784[2] = _121;
    uint _783 = 0u;
    f16vec4 _782[2];
    uint _790;
    for (;;)
    {
        _790 = _783;
        if (_790 < 2u)
        {
            _782[_790] = max(_784[_790], _125[_790]);
            _783 = _790 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    y = _782;
    f16vec4 _816[2] = _782;
    uint _817 = 0u;
    uint _822;
    for (;;)
    {
        _822 = _817;
        if (_822 < 8u)
        {
            _800(0u + _822, _816[_822 / 4u]);
            _817 = _822 + 4u;
            continue;
        }
        else
        {
            break;
        }
    }
}

