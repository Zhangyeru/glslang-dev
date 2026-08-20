#version 460
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
    float data[];
} C;

layout(set = 0, binding = 3, std430) buffer OutputD
{
    float data[];
} D;

vec2[8] _75()
{
    uint _89 = 0u / 4u;
    uint _90 = 0u % 4u;
    uint _94 = ((uint(0) + _89) * uint(4)) + (uint(0) + _90);
    uint _104 = 1u / 4u;
    uint _105 = 1u % 4u;
    uint _109 = ((uint(0) + _104) * uint(4)) + (uint(0) + _105);
    uint _119 = 2u / 4u;
    uint _120 = 2u % 4u;
    uint _124 = ((uint(0) + _119) * uint(4)) + (uint(0) + _120);
    uint _134 = 3u / 4u;
    uint _135 = 3u % 4u;
    uint _139 = ((uint(0) + _134) * uint(4)) + (uint(0) + _135);
    uint _148 = 4u / 4u;
    uint _149 = 4u % 4u;
    uint _153 = ((uint(0) + _148) * uint(4)) + (uint(0) + _149);
    uint _163 = 5u / 4u;
    uint _164 = 5u % 4u;
    uint _168 = ((uint(0) + _163) * uint(4)) + (uint(0) + _164);
    uint _178 = 6u / 4u;
    uint _179 = 6u % 4u;
    uint _183 = ((uint(0) + _178) * uint(4)) + (uint(0) + _179);
    uint _193 = 7u / 4u;
    uint _194 = 7u % 4u;
    uint _198 = ((uint(0) + _193) * uint(4)) + (uint(0) + _194);
    uint _207 = 8u / 4u;
    uint _208 = 8u % 4u;
    uint _212 = ((uint(0) + _207) * uint(4)) + (uint(0) + _208);
    uint _222 = 9u / 4u;
    uint _223 = 9u % 4u;
    uint _227 = ((uint(0) + _222) * uint(4)) + (uint(0) + _223);
    uint _237 = 10u / 4u;
    uint _238 = 10u % 4u;
    uint _242 = ((uint(0) + _237) * uint(4)) + (uint(0) + _238);
    uint _252 = 11u / 4u;
    uint _253 = 11u % 4u;
    uint _257 = ((uint(0) + _252) * uint(4)) + (uint(0) + _253);
    uint _267 = 12u / 4u;
    uint _268 = 12u % 4u;
    uint _272 = ((uint(0) + _267) * uint(4)) + (uint(0) + _268);
    uint _282 = 13u / 4u;
    uint _283 = 13u % 4u;
    uint _287 = ((uint(0) + _282) * uint(4)) + (uint(0) + _283);
    uint _297 = 14u / 4u;
    uint _298 = 14u % 4u;
    uint _302 = ((uint(0) + _297) * uint(4)) + (uint(0) + _298);
    uint _312 = 15u / 4u;
    uint _313 = 15u % 4u;
    uint _317 = ((uint(0) + _312) * uint(4)) + (uint(0) + _313);
    uint _326 = 0u / 4u;
    uint _327 = 0u % 4u;
    uint _331 = ((uint(0) + _326) * uint(4)) + (uint(0) + _327);
    uint _340 = 1u / 4u;
    uint _341 = 1u % 4u;
    uint _345 = ((uint(0) + _340) * uint(4)) + (uint(0) + _341);
    uint _354 = 2u / 4u;
    uint _355 = 2u % 4u;
    uint _359 = ((uint(0) + _354) * uint(4)) + (uint(0) + _355);
    uint _368 = 3u / 4u;
    uint _369 = 3u % 4u;
    uint _373 = ((uint(0) + _368) * uint(4)) + (uint(0) + _369);
    uint _382 = 4u / 4u;
    uint _383 = 4u % 4u;
    uint _387 = ((uint(0) + _382) * uint(4)) + (uint(0) + _383);
    uint _396 = 5u / 4u;
    uint _397 = 5u % 4u;
    uint _401 = ((uint(0) + _396) * uint(4)) + (uint(0) + _397);
    uint _410 = 6u / 4u;
    uint _411 = 6u % 4u;
    uint _415 = ((uint(0) + _410) * uint(4)) + (uint(0) + _411);
    uint _424 = 7u / 4u;
    uint _425 = 7u % 4u;
    uint _429 = ((uint(0) + _424) * uint(4)) + (uint(0) + _425);
    uint _438 = 8u / 4u;
    uint _439 = 8u % 4u;
    uint _443 = ((uint(0) + _438) * uint(4)) + (uint(0) + _439);
    uint _452 = 9u / 4u;
    uint _453 = 9u % 4u;
    uint _457 = ((uint(0) + _452) * uint(4)) + (uint(0) + _453);
    uint _466 = 10u / 4u;
    uint _467 = 10u % 4u;
    uint _471 = ((uint(0) + _466) * uint(4)) + (uint(0) + _467);
    uint _480 = 11u / 4u;
    uint _481 = 11u % 4u;
    uint _485 = ((uint(0) + _480) * uint(4)) + (uint(0) + _481);
    uint _494 = 12u / 4u;
    uint _495 = 12u % 4u;
    uint _499 = ((uint(0) + _494) * uint(4)) + (uint(0) + _495);
    uint _508 = 13u / 4u;
    uint _509 = 13u % 4u;
    uint _513 = ((uint(0) + _508) * uint(4)) + (uint(0) + _509);
    uint _522 = 14u / 4u;
    uint _523 = 14u % 4u;
    uint _527 = ((uint(0) + _522) * uint(4)) + (uint(0) + _523);
    uint _536 = 15u / 4u;
    uint _537 = 15u % 4u;
    uint _541 = ((uint(0) + _536) * uint(4)) + (uint(0) + _537);
    uint _550 = 0u / 4u;
    uint _551 = 0u % 4u;
    uint _565 = 1u / 4u;
    uint _566 = 1u % 4u;
    uint _579 = 2u / 4u;
    uint _580 = 2u % 4u;
    uint _593 = 3u / 4u;
    uint _594 = 3u % 4u;
    uint _607 = 4u / 4u;
    uint _608 = 4u % 4u;
    uint _621 = 5u / 4u;
    uint _622 = 5u % 4u;
    uint _635 = 6u / 4u;
    uint _636 = 6u % 4u;
    uint _649 = 7u / 4u;
    uint _650 = 7u % 4u;
    uint _663 = 8u / 4u;
    uint _664 = 8u % 4u;
    uint _677 = 9u / 4u;
    uint _678 = 9u % 4u;
    uint _691 = 10u / 4u;
    uint _692 = 10u % 4u;
    uint _705 = 11u / 4u;
    uint _706 = 11u % 4u;
    uint _719 = 12u / 4u;
    uint _720 = 12u % 4u;
    uint _733 = 13u / 4u;
    uint _734 = 13u % 4u;
    uint _747 = 14u / 4u;
    uint _748 = 14u % 4u;
    uint _761 = 15u / 4u;
    uint _762 = 15u % 4u;
    vec2 _778 = fma(vec2(f16vec2(A.data[_124], A.data[_139])), vec2(f16vec2(B.data[_443], B.data[_499])), fma(vec2(f16vec2(A.data[_94], A.data[_109])), vec2(f16vec2(B.data[_331], B.data[_387])), vec2(0.0)));
    vec2 _792 = fma(vec2(f16vec2(A.data[_124], A.data[_139])), vec2(f16vec2(B.data[_457], B.data[_513])), fma(vec2(f16vec2(A.data[_94], A.data[_109])), vec2(f16vec2(B.data[_345], B.data[_401])), vec2(0.0)));
    vec2 _806 = fma(vec2(f16vec2(A.data[_124], A.data[_139])), vec2(f16vec2(B.data[_471], B.data[_527])), fma(vec2(f16vec2(A.data[_94], A.data[_109])), vec2(f16vec2(B.data[_359], B.data[_415])), vec2(0.0)));
    vec2 _820 = fma(vec2(f16vec2(A.data[_124], A.data[_139])), vec2(f16vec2(B.data[_485], B.data[_541])), fma(vec2(f16vec2(A.data[_94], A.data[_109])), vec2(f16vec2(B.data[_373], B.data[_429])), vec2(0.0)));
    vec2 _834 = fma(vec2(f16vec2(A.data[_183], A.data[_198])), vec2(f16vec2(B.data[_443], B.data[_499])), fma(vec2(f16vec2(A.data[_153], A.data[_168])), vec2(f16vec2(B.data[_331], B.data[_387])), vec2(0.0)));
    vec2 _848 = fma(vec2(f16vec2(A.data[_183], A.data[_198])), vec2(f16vec2(B.data[_457], B.data[_513])), fma(vec2(f16vec2(A.data[_153], A.data[_168])), vec2(f16vec2(B.data[_345], B.data[_401])), vec2(0.0)));
    vec2 _862 = fma(vec2(f16vec2(A.data[_183], A.data[_198])), vec2(f16vec2(B.data[_471], B.data[_527])), fma(vec2(f16vec2(A.data[_153], A.data[_168])), vec2(f16vec2(B.data[_359], B.data[_415])), vec2(0.0)));
    vec2 _876 = fma(vec2(f16vec2(A.data[_183], A.data[_198])), vec2(f16vec2(B.data[_485], B.data[_541])), fma(vec2(f16vec2(A.data[_153], A.data[_168])), vec2(f16vec2(B.data[_373], B.data[_429])), vec2(0.0)));
    vec2 _890 = fma(vec2(f16vec2(A.data[_242], A.data[_257])), vec2(f16vec2(B.data[_443], B.data[_499])), fma(vec2(f16vec2(A.data[_212], A.data[_227])), vec2(f16vec2(B.data[_331], B.data[_387])), vec2(0.0)));
    vec2 _904 = fma(vec2(f16vec2(A.data[_242], A.data[_257])), vec2(f16vec2(B.data[_457], B.data[_513])), fma(vec2(f16vec2(A.data[_212], A.data[_227])), vec2(f16vec2(B.data[_345], B.data[_401])), vec2(0.0)));
    vec2 _918 = fma(vec2(f16vec2(A.data[_242], A.data[_257])), vec2(f16vec2(B.data[_471], B.data[_527])), fma(vec2(f16vec2(A.data[_212], A.data[_227])), vec2(f16vec2(B.data[_359], B.data[_415])), vec2(0.0)));
    vec2 _932 = fma(vec2(f16vec2(A.data[_242], A.data[_257])), vec2(f16vec2(B.data[_485], B.data[_541])), fma(vec2(f16vec2(A.data[_212], A.data[_227])), vec2(f16vec2(B.data[_373], B.data[_429])), vec2(0.0)));
    vec2 _946 = fma(vec2(f16vec2(A.data[_302], A.data[_317])), vec2(f16vec2(B.data[_443], B.data[_499])), fma(vec2(f16vec2(A.data[_272], A.data[_287])), vec2(f16vec2(B.data[_331], B.data[_387])), vec2(0.0)));
    vec2 _960 = fma(vec2(f16vec2(A.data[_302], A.data[_317])), vec2(f16vec2(B.data[_457], B.data[_513])), fma(vec2(f16vec2(A.data[_272], A.data[_287])), vec2(f16vec2(B.data[_345], B.data[_401])), vec2(0.0)));
    vec2 _974 = fma(vec2(f16vec2(A.data[_302], A.data[_317])), vec2(f16vec2(B.data[_471], B.data[_527])), fma(vec2(f16vec2(A.data[_272], A.data[_287])), vec2(f16vec2(B.data[_359], B.data[_415])), vec2(0.0)));
    vec2 _988 = fma(vec2(f16vec2(A.data[_302], A.data[_317])), vec2(f16vec2(B.data[_485], B.data[_541])), fma(vec2(f16vec2(A.data[_272], A.data[_287])), vec2(f16vec2(B.data[_373], B.data[_429])), vec2(0.0)));
    return vec2[](vec2((_778.x + _778.y) + C.data[((uint(0) + _550) * uint(4)) + (uint(0) + _551)], (_792.x + _792.y) + C.data[((uint(0) + _565) * uint(4)) + (uint(0) + _566)]), vec2((_806.x + _806.y) + C.data[((uint(0) + _579) * uint(4)) + (uint(0) + _580)], (_820.x + _820.y) + C.data[((uint(0) + _593) * uint(4)) + (uint(0) + _594)]), vec2((_834.x + _834.y) + C.data[((uint(0) + _607) * uint(4)) + (uint(0) + _608)], (_848.x + _848.y) + C.data[((uint(0) + _621) * uint(4)) + (uint(0) + _622)]), vec2((_862.x + _862.y) + C.data[((uint(0) + _635) * uint(4)) + (uint(0) + _636)], (_876.x + _876.y) + C.data[((uint(0) + _649) * uint(4)) + (uint(0) + _650)]), vec2((_890.x + _890.y) + C.data[((uint(0) + _663) * uint(4)) + (uint(0) + _664)], (_904.x + _904.y) + C.data[((uint(0) + _677) * uint(4)) + (uint(0) + _678)]), vec2((_918.x + _918.y) + C.data[((uint(0) + _691) * uint(4)) + (uint(0) + _692)], (_932.x + _932.y) + C.data[((uint(0) + _705) * uint(4)) + (uint(0) + _706)]), vec2((_946.x + _946.y) + C.data[((uint(0) + _719) * uint(4)) + (uint(0) + _720)], (_960.x + _960.y) + C.data[((uint(0) + _733) * uint(4)) + (uint(0) + _734)]), vec2((_974.x + _974.y) + C.data[((uint(0) + _747) * uint(4)) + (uint(0) + _748)], (_988.x + _988.y) + C.data[((uint(0) + _761) * uint(4)) + (uint(0) + _762)]));
}

void _1003(uint _1004, vec2 _1005)
{
    D.data[_1004] = _1005.x;
    D.data[_1004 + 1u] = _1005.y;
}

void main()
{
    vec2 _56[8] = _75();
    vec2 tempArg[8] = _56;
    vec2 d[8] = _56;
    vec2 _1018[8] = _56;
    uint _1019 = 0u;
    uint _1024;
    for (;;)
    {
        _1024 = _1019;
        if (_1024 < 16u)
        {
            _1003(((uint(0) + (_1024 / 4u)) * uint(4)) + (uint(0) + (_1024 % 4u)), _1018[_1024 / 2u]);
            _1019 = _1024 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
}

