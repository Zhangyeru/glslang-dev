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

struct PostprocessNetworkContext
{
    uint selectedRoute;
    bool enabled;
    uvec4 dimensions;
    vec4 controls;
};

struct PostprocessStage0
{
    f16vec2 value[5];
    uvec4 provenance;
};

struct PostprocessStage1
{
    f16vec2 value[32];
    uvec4 provenance;
};

struct PostprocessStage2
{
    f16vec2 value[8];
    uvec4 provenance;
};

struct PostprocessStage3
{
    f16vec2 value[4];
    uvec4 provenance;
};

struct PostprocessStage4
{
    f16vec2 value[2];
    uvec4 provenance;
};

struct PostprocessHistoryFrame
{
    PostprocessStage2 activation;
    uvec4 state;
};

struct PostprocessActivationHistory
{
    PostprocessHistoryFrame frames[2];
    uint selectedFrame;
};

const f16vec2 _268[32] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const f16vec2 _306[8] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const f16vec2 _344[4] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));
const f16vec2 _382[2] = f16vec2[](f16vec2(float16_t(0.0)), f16vec2(float16_t(0.0)));

layout(set = 0, binding = 0, std430) buffer PostprocessInputBuffer
{
    float16_t values[64];
} InX;

layout(set = 0, binding = 1, std430) buffer PostprocessWeightBuffer
{
    float16_t w0[640];
    float16_t w1[1024];
    float16_t w2[128];
    float16_t w3[32];
} Weights;

layout(set = 0, binding = 2, std430) buffer PostprocessBiasBuffer
{
    float16_t b0[64];
    float16_t b1[16];
    float16_t b2[8];
    float16_t b3[4];
} Biases;

layout(set = 0, binding = 3, std430) buffer PostprocessOutputBuffer
{
    float16_t values[4];
} OutY;

uint buildPostprocessRouteKey()
{
    uint dispatchKey = gl_GlobalInvocationID.x ^ gl_LocalInvocationIndex;
    uint groupKey = gl_WorkGroupID.x | (gl_WorkGroupID.y << 4u);
    return dispatchKey ^ groupKey;
}

uint selectPostprocessRoute(uint routeKey)
{
    switch (routeKey & 1u)
    {
        case 0u:
        {
            return 0u;
        }
        case 1u:
        {
            return 1u;
        }
        default:
        {
            return 0u;
        }
    }
}

PostprocessNetworkContext buildPostprocessContext()
{
    uint routeKey = buildPostprocessRouteKey();
    uint param = routeKey;
    PostprocessNetworkContext context;
    context.selectedRoute = selectPostprocessRoute(param);
    context.enabled = true;
    context.dimensions = uvec4(10u, 64u, 4u, 4u);
    context.controls = vec4(float(context.selectedRoute), 2.0, 1.0, 1.0);
    return context;
}

bool validatePostprocessContext(PostprocessNetworkContext context)
{
    bool _171 = context.dimensions.x == 10u;
    bool _177;
    if (_171)
    {
        _177 = context.dimensions.z == 4u;
    }
    else
    {
        _177 = _171;
    }
    bool dimensionsValid = _177;
    bool layerCountValid = context.dimensions.w == 4u;
    bool controlsValid = context.controls.w > 0.0;
    return ((context.enabled && dimensionsValid) && layerCountValid) && controlsValid;
}

f16vec2 _7594(uint _7595)
{
    return f16vec2(InX.values[_7595], InX.values[_7595 + 1u]);
}

PostprocessStage0 loadPostprocessInput(PostprocessNetworkContext context)
{
    uint _7607 = 0u;
    f16vec2 _7606[5];
    uint _7612;
    for (;;)
    {
        _7612 = _7607;
        if (_7612 < 10u)
        {
            _7606[_7612 / 2u] = _7594(0u + _7612);
            _7607 = _7612 + 2u;
            continue;
        }
        else
        {
            break;
        }
    }
    f16vec2 _207[5] = _7606;
    f16vec2 tempArg[5] = _207;
    PostprocessStage0 inputValue;
    inputValue.value = _207;
    inputValue.provenance = uvec4(0u, context.selectedRoute, 10u, 1u);
    return inputValue;
}

f16vec2[32] _558(f16vec2 _559[5])
{
    f16vec2 _2651 = f16vec2(_559[0].x);
    f16vec2 _2716 = f16vec2(_559[0].y);
    f16vec2 _2781 = f16vec2(_559[1].x);
    f16vec2 _2846 = f16vec2(_559[1].y);
    f16vec2 _2911 = f16vec2(_559[2].x);
    f16vec2 _2976 = f16vec2(_559[2].y);
    f16vec2 _3041 = f16vec2(_559[3].x);
    f16vec2 _3106 = f16vec2(_559[3].y);
    f16vec2 _3171 = f16vec2(_559[4].x);
    f16vec2 _3236 = f16vec2(_559[4].y);
    f16vec2 _3238 = fma(_3236, f16vec2(Weights.w0[576u], Weights.w0[577u]), fma(_3171, f16vec2(Weights.w0[512u], Weights.w0[513u]), fma(_3106, f16vec2(Weights.w0[448u], Weights.w0[449u]), fma(_3041, f16vec2(Weights.w0[384u], Weights.w0[385u]), fma(_2976, f16vec2(Weights.w0[320u], Weights.w0[321u]), fma(_2911, f16vec2(Weights.w0[256u], Weights.w0[257u]), fma(_2846, f16vec2(Weights.w0[192u], Weights.w0[193u]), fma(_2781, f16vec2(Weights.w0[128u], Weights.w0[129u]), fma(_2716, f16vec2(Weights.w0[64u], Weights.w0[65u]), fma(_2651, f16vec2(Weights.w0[0u], Weights.w0[1u]), f16vec2(Biases.b0[0u], Biases.b0[1u])))))))))));
    f16vec2 _3240 = fma(_3236, f16vec2(Weights.w0[578u], Weights.w0[579u]), fma(_3171, f16vec2(Weights.w0[514u], Weights.w0[515u]), fma(_3106, f16vec2(Weights.w0[450u], Weights.w0[451u]), fma(_3041, f16vec2(Weights.w0[386u], Weights.w0[387u]), fma(_2976, f16vec2(Weights.w0[322u], Weights.w0[323u]), fma(_2911, f16vec2(Weights.w0[258u], Weights.w0[259u]), fma(_2846, f16vec2(Weights.w0[194u], Weights.w0[195u]), fma(_2781, f16vec2(Weights.w0[130u], Weights.w0[131u]), fma(_2716, f16vec2(Weights.w0[66u], Weights.w0[67u]), fma(_2651, f16vec2(Weights.w0[2u], Weights.w0[3u]), f16vec2(Biases.b0[2u], Biases.b0[3u])))))))))));
    f16vec2 _3242 = fma(_3236, f16vec2(Weights.w0[580u], Weights.w0[581u]), fma(_3171, f16vec2(Weights.w0[516u], Weights.w0[517u]), fma(_3106, f16vec2(Weights.w0[452u], Weights.w0[453u]), fma(_3041, f16vec2(Weights.w0[388u], Weights.w0[389u]), fma(_2976, f16vec2(Weights.w0[324u], Weights.w0[325u]), fma(_2911, f16vec2(Weights.w0[260u], Weights.w0[261u]), fma(_2846, f16vec2(Weights.w0[196u], Weights.w0[197u]), fma(_2781, f16vec2(Weights.w0[132u], Weights.w0[133u]), fma(_2716, f16vec2(Weights.w0[68u], Weights.w0[69u]), fma(_2651, f16vec2(Weights.w0[4u], Weights.w0[5u]), f16vec2(Biases.b0[4u], Biases.b0[5u])))))))))));
    f16vec2 _3244 = fma(_3236, f16vec2(Weights.w0[582u], Weights.w0[583u]), fma(_3171, f16vec2(Weights.w0[518u], Weights.w0[519u]), fma(_3106, f16vec2(Weights.w0[454u], Weights.w0[455u]), fma(_3041, f16vec2(Weights.w0[390u], Weights.w0[391u]), fma(_2976, f16vec2(Weights.w0[326u], Weights.w0[327u]), fma(_2911, f16vec2(Weights.w0[262u], Weights.w0[263u]), fma(_2846, f16vec2(Weights.w0[198u], Weights.w0[199u]), fma(_2781, f16vec2(Weights.w0[134u], Weights.w0[135u]), fma(_2716, f16vec2(Weights.w0[70u], Weights.w0[71u]), fma(_2651, f16vec2(Weights.w0[6u], Weights.w0[7u]), f16vec2(Biases.b0[6u], Biases.b0[7u])))))))))));
    f16vec2 _3246 = fma(_3236, f16vec2(Weights.w0[584u], Weights.w0[585u]), fma(_3171, f16vec2(Weights.w0[520u], Weights.w0[521u]), fma(_3106, f16vec2(Weights.w0[456u], Weights.w0[457u]), fma(_3041, f16vec2(Weights.w0[392u], Weights.w0[393u]), fma(_2976, f16vec2(Weights.w0[328u], Weights.w0[329u]), fma(_2911, f16vec2(Weights.w0[264u], Weights.w0[265u]), fma(_2846, f16vec2(Weights.w0[200u], Weights.w0[201u]), fma(_2781, f16vec2(Weights.w0[136u], Weights.w0[137u]), fma(_2716, f16vec2(Weights.w0[72u], Weights.w0[73u]), fma(_2651, f16vec2(Weights.w0[8u], Weights.w0[9u]), f16vec2(Biases.b0[8u], Biases.b0[9u])))))))))));
    f16vec2 _3248 = fma(_3236, f16vec2(Weights.w0[586u], Weights.w0[587u]), fma(_3171, f16vec2(Weights.w0[522u], Weights.w0[523u]), fma(_3106, f16vec2(Weights.w0[458u], Weights.w0[459u]), fma(_3041, f16vec2(Weights.w0[394u], Weights.w0[395u]), fma(_2976, f16vec2(Weights.w0[330u], Weights.w0[331u]), fma(_2911, f16vec2(Weights.w0[266u], Weights.w0[267u]), fma(_2846, f16vec2(Weights.w0[202u], Weights.w0[203u]), fma(_2781, f16vec2(Weights.w0[138u], Weights.w0[139u]), fma(_2716, f16vec2(Weights.w0[74u], Weights.w0[75u]), fma(_2651, f16vec2(Weights.w0[10u], Weights.w0[11u]), f16vec2(Biases.b0[10u], Biases.b0[11u])))))))))));
    f16vec2 _3250 = fma(_3236, f16vec2(Weights.w0[588u], Weights.w0[589u]), fma(_3171, f16vec2(Weights.w0[524u], Weights.w0[525u]), fma(_3106, f16vec2(Weights.w0[460u], Weights.w0[461u]), fma(_3041, f16vec2(Weights.w0[396u], Weights.w0[397u]), fma(_2976, f16vec2(Weights.w0[332u], Weights.w0[333u]), fma(_2911, f16vec2(Weights.w0[268u], Weights.w0[269u]), fma(_2846, f16vec2(Weights.w0[204u], Weights.w0[205u]), fma(_2781, f16vec2(Weights.w0[140u], Weights.w0[141u]), fma(_2716, f16vec2(Weights.w0[76u], Weights.w0[77u]), fma(_2651, f16vec2(Weights.w0[12u], Weights.w0[13u]), f16vec2(Biases.b0[12u], Biases.b0[13u])))))))))));
    f16vec2 _3252 = fma(_3236, f16vec2(Weights.w0[590u], Weights.w0[591u]), fma(_3171, f16vec2(Weights.w0[526u], Weights.w0[527u]), fma(_3106, f16vec2(Weights.w0[462u], Weights.w0[463u]), fma(_3041, f16vec2(Weights.w0[398u], Weights.w0[399u]), fma(_2976, f16vec2(Weights.w0[334u], Weights.w0[335u]), fma(_2911, f16vec2(Weights.w0[270u], Weights.w0[271u]), fma(_2846, f16vec2(Weights.w0[206u], Weights.w0[207u]), fma(_2781, f16vec2(Weights.w0[142u], Weights.w0[143u]), fma(_2716, f16vec2(Weights.w0[78u], Weights.w0[79u]), fma(_2651, f16vec2(Weights.w0[14u], Weights.w0[15u]), f16vec2(Biases.b0[14u], Biases.b0[15u])))))))))));
    f16vec2 _3254 = fma(_3236, f16vec2(Weights.w0[592u], Weights.w0[593u]), fma(_3171, f16vec2(Weights.w0[528u], Weights.w0[529u]), fma(_3106, f16vec2(Weights.w0[464u], Weights.w0[465u]), fma(_3041, f16vec2(Weights.w0[400u], Weights.w0[401u]), fma(_2976, f16vec2(Weights.w0[336u], Weights.w0[337u]), fma(_2911, f16vec2(Weights.w0[272u], Weights.w0[273u]), fma(_2846, f16vec2(Weights.w0[208u], Weights.w0[209u]), fma(_2781, f16vec2(Weights.w0[144u], Weights.w0[145u]), fma(_2716, f16vec2(Weights.w0[80u], Weights.w0[81u]), fma(_2651, f16vec2(Weights.w0[16u], Weights.w0[17u]), f16vec2(Biases.b0[16u], Biases.b0[17u])))))))))));
    f16vec2 _3256 = fma(_3236, f16vec2(Weights.w0[594u], Weights.w0[595u]), fma(_3171, f16vec2(Weights.w0[530u], Weights.w0[531u]), fma(_3106, f16vec2(Weights.w0[466u], Weights.w0[467u]), fma(_3041, f16vec2(Weights.w0[402u], Weights.w0[403u]), fma(_2976, f16vec2(Weights.w0[338u], Weights.w0[339u]), fma(_2911, f16vec2(Weights.w0[274u], Weights.w0[275u]), fma(_2846, f16vec2(Weights.w0[210u], Weights.w0[211u]), fma(_2781, f16vec2(Weights.w0[146u], Weights.w0[147u]), fma(_2716, f16vec2(Weights.w0[82u], Weights.w0[83u]), fma(_2651, f16vec2(Weights.w0[18u], Weights.w0[19u]), f16vec2(Biases.b0[18u], Biases.b0[19u])))))))))));
    f16vec2 _3258 = fma(_3236, f16vec2(Weights.w0[596u], Weights.w0[597u]), fma(_3171, f16vec2(Weights.w0[532u], Weights.w0[533u]), fma(_3106, f16vec2(Weights.w0[468u], Weights.w0[469u]), fma(_3041, f16vec2(Weights.w0[404u], Weights.w0[405u]), fma(_2976, f16vec2(Weights.w0[340u], Weights.w0[341u]), fma(_2911, f16vec2(Weights.w0[276u], Weights.w0[277u]), fma(_2846, f16vec2(Weights.w0[212u], Weights.w0[213u]), fma(_2781, f16vec2(Weights.w0[148u], Weights.w0[149u]), fma(_2716, f16vec2(Weights.w0[84u], Weights.w0[85u]), fma(_2651, f16vec2(Weights.w0[20u], Weights.w0[21u]), f16vec2(Biases.b0[20u], Biases.b0[21u])))))))))));
    f16vec2 _3260 = fma(_3236, f16vec2(Weights.w0[598u], Weights.w0[599u]), fma(_3171, f16vec2(Weights.w0[534u], Weights.w0[535u]), fma(_3106, f16vec2(Weights.w0[470u], Weights.w0[471u]), fma(_3041, f16vec2(Weights.w0[406u], Weights.w0[407u]), fma(_2976, f16vec2(Weights.w0[342u], Weights.w0[343u]), fma(_2911, f16vec2(Weights.w0[278u], Weights.w0[279u]), fma(_2846, f16vec2(Weights.w0[214u], Weights.w0[215u]), fma(_2781, f16vec2(Weights.w0[150u], Weights.w0[151u]), fma(_2716, f16vec2(Weights.w0[86u], Weights.w0[87u]), fma(_2651, f16vec2(Weights.w0[22u], Weights.w0[23u]), f16vec2(Biases.b0[22u], Biases.b0[23u])))))))))));
    f16vec2 _3262 = fma(_3236, f16vec2(Weights.w0[600u], Weights.w0[601u]), fma(_3171, f16vec2(Weights.w0[536u], Weights.w0[537u]), fma(_3106, f16vec2(Weights.w0[472u], Weights.w0[473u]), fma(_3041, f16vec2(Weights.w0[408u], Weights.w0[409u]), fma(_2976, f16vec2(Weights.w0[344u], Weights.w0[345u]), fma(_2911, f16vec2(Weights.w0[280u], Weights.w0[281u]), fma(_2846, f16vec2(Weights.w0[216u], Weights.w0[217u]), fma(_2781, f16vec2(Weights.w0[152u], Weights.w0[153u]), fma(_2716, f16vec2(Weights.w0[88u], Weights.w0[89u]), fma(_2651, f16vec2(Weights.w0[24u], Weights.w0[25u]), f16vec2(Biases.b0[24u], Biases.b0[25u])))))))))));
    f16vec2 _3264 = fma(_3236, f16vec2(Weights.w0[602u], Weights.w0[603u]), fma(_3171, f16vec2(Weights.w0[538u], Weights.w0[539u]), fma(_3106, f16vec2(Weights.w0[474u], Weights.w0[475u]), fma(_3041, f16vec2(Weights.w0[410u], Weights.w0[411u]), fma(_2976, f16vec2(Weights.w0[346u], Weights.w0[347u]), fma(_2911, f16vec2(Weights.w0[282u], Weights.w0[283u]), fma(_2846, f16vec2(Weights.w0[218u], Weights.w0[219u]), fma(_2781, f16vec2(Weights.w0[154u], Weights.w0[155u]), fma(_2716, f16vec2(Weights.w0[90u], Weights.w0[91u]), fma(_2651, f16vec2(Weights.w0[26u], Weights.w0[27u]), f16vec2(Biases.b0[26u], Biases.b0[27u])))))))))));
    f16vec2 _3266 = fma(_3236, f16vec2(Weights.w0[604u], Weights.w0[605u]), fma(_3171, f16vec2(Weights.w0[540u], Weights.w0[541u]), fma(_3106, f16vec2(Weights.w0[476u], Weights.w0[477u]), fma(_3041, f16vec2(Weights.w0[412u], Weights.w0[413u]), fma(_2976, f16vec2(Weights.w0[348u], Weights.w0[349u]), fma(_2911, f16vec2(Weights.w0[284u], Weights.w0[285u]), fma(_2846, f16vec2(Weights.w0[220u], Weights.w0[221u]), fma(_2781, f16vec2(Weights.w0[156u], Weights.w0[157u]), fma(_2716, f16vec2(Weights.w0[92u], Weights.w0[93u]), fma(_2651, f16vec2(Weights.w0[28u], Weights.w0[29u]), f16vec2(Biases.b0[28u], Biases.b0[29u])))))))))));
    f16vec2 _3268 = fma(_3236, f16vec2(Weights.w0[606u], Weights.w0[607u]), fma(_3171, f16vec2(Weights.w0[542u], Weights.w0[543u]), fma(_3106, f16vec2(Weights.w0[478u], Weights.w0[479u]), fma(_3041, f16vec2(Weights.w0[414u], Weights.w0[415u]), fma(_2976, f16vec2(Weights.w0[350u], Weights.w0[351u]), fma(_2911, f16vec2(Weights.w0[286u], Weights.w0[287u]), fma(_2846, f16vec2(Weights.w0[222u], Weights.w0[223u]), fma(_2781, f16vec2(Weights.w0[158u], Weights.w0[159u]), fma(_2716, f16vec2(Weights.w0[94u], Weights.w0[95u]), fma(_2651, f16vec2(Weights.w0[30u], Weights.w0[31u]), f16vec2(Biases.b0[30u], Biases.b0[31u])))))))))));
    f16vec2 _3270 = fma(_3236, f16vec2(Weights.w0[608u], Weights.w0[609u]), fma(_3171, f16vec2(Weights.w0[544u], Weights.w0[545u]), fma(_3106, f16vec2(Weights.w0[480u], Weights.w0[481u]), fma(_3041, f16vec2(Weights.w0[416u], Weights.w0[417u]), fma(_2976, f16vec2(Weights.w0[352u], Weights.w0[353u]), fma(_2911, f16vec2(Weights.w0[288u], Weights.w0[289u]), fma(_2846, f16vec2(Weights.w0[224u], Weights.w0[225u]), fma(_2781, f16vec2(Weights.w0[160u], Weights.w0[161u]), fma(_2716, f16vec2(Weights.w0[96u], Weights.w0[97u]), fma(_2651, f16vec2(Weights.w0[32u], Weights.w0[33u]), f16vec2(Biases.b0[32u], Biases.b0[33u])))))))))));
    f16vec2 _3272 = fma(_3236, f16vec2(Weights.w0[610u], Weights.w0[611u]), fma(_3171, f16vec2(Weights.w0[546u], Weights.w0[547u]), fma(_3106, f16vec2(Weights.w0[482u], Weights.w0[483u]), fma(_3041, f16vec2(Weights.w0[418u], Weights.w0[419u]), fma(_2976, f16vec2(Weights.w0[354u], Weights.w0[355u]), fma(_2911, f16vec2(Weights.w0[290u], Weights.w0[291u]), fma(_2846, f16vec2(Weights.w0[226u], Weights.w0[227u]), fma(_2781, f16vec2(Weights.w0[162u], Weights.w0[163u]), fma(_2716, f16vec2(Weights.w0[98u], Weights.w0[99u]), fma(_2651, f16vec2(Weights.w0[34u], Weights.w0[35u]), f16vec2(Biases.b0[34u], Biases.b0[35u])))))))))));
    f16vec2 _3274 = fma(_3236, f16vec2(Weights.w0[612u], Weights.w0[613u]), fma(_3171, f16vec2(Weights.w0[548u], Weights.w0[549u]), fma(_3106, f16vec2(Weights.w0[484u], Weights.w0[485u]), fma(_3041, f16vec2(Weights.w0[420u], Weights.w0[421u]), fma(_2976, f16vec2(Weights.w0[356u], Weights.w0[357u]), fma(_2911, f16vec2(Weights.w0[292u], Weights.w0[293u]), fma(_2846, f16vec2(Weights.w0[228u], Weights.w0[229u]), fma(_2781, f16vec2(Weights.w0[164u], Weights.w0[165u]), fma(_2716, f16vec2(Weights.w0[100u], Weights.w0[101u]), fma(_2651, f16vec2(Weights.w0[36u], Weights.w0[37u]), f16vec2(Biases.b0[36u], Biases.b0[37u])))))))))));
    f16vec2 _3276 = fma(_3236, f16vec2(Weights.w0[614u], Weights.w0[615u]), fma(_3171, f16vec2(Weights.w0[550u], Weights.w0[551u]), fma(_3106, f16vec2(Weights.w0[486u], Weights.w0[487u]), fma(_3041, f16vec2(Weights.w0[422u], Weights.w0[423u]), fma(_2976, f16vec2(Weights.w0[358u], Weights.w0[359u]), fma(_2911, f16vec2(Weights.w0[294u], Weights.w0[295u]), fma(_2846, f16vec2(Weights.w0[230u], Weights.w0[231u]), fma(_2781, f16vec2(Weights.w0[166u], Weights.w0[167u]), fma(_2716, f16vec2(Weights.w0[102u], Weights.w0[103u]), fma(_2651, f16vec2(Weights.w0[38u], Weights.w0[39u]), f16vec2(Biases.b0[38u], Biases.b0[39u])))))))))));
    f16vec2 _3278 = fma(_3236, f16vec2(Weights.w0[616u], Weights.w0[617u]), fma(_3171, f16vec2(Weights.w0[552u], Weights.w0[553u]), fma(_3106, f16vec2(Weights.w0[488u], Weights.w0[489u]), fma(_3041, f16vec2(Weights.w0[424u], Weights.w0[425u]), fma(_2976, f16vec2(Weights.w0[360u], Weights.w0[361u]), fma(_2911, f16vec2(Weights.w0[296u], Weights.w0[297u]), fma(_2846, f16vec2(Weights.w0[232u], Weights.w0[233u]), fma(_2781, f16vec2(Weights.w0[168u], Weights.w0[169u]), fma(_2716, f16vec2(Weights.w0[104u], Weights.w0[105u]), fma(_2651, f16vec2(Weights.w0[40u], Weights.w0[41u]), f16vec2(Biases.b0[40u], Biases.b0[41u])))))))))));
    f16vec2 _3280 = fma(_3236, f16vec2(Weights.w0[618u], Weights.w0[619u]), fma(_3171, f16vec2(Weights.w0[554u], Weights.w0[555u]), fma(_3106, f16vec2(Weights.w0[490u], Weights.w0[491u]), fma(_3041, f16vec2(Weights.w0[426u], Weights.w0[427u]), fma(_2976, f16vec2(Weights.w0[362u], Weights.w0[363u]), fma(_2911, f16vec2(Weights.w0[298u], Weights.w0[299u]), fma(_2846, f16vec2(Weights.w0[234u], Weights.w0[235u]), fma(_2781, f16vec2(Weights.w0[170u], Weights.w0[171u]), fma(_2716, f16vec2(Weights.w0[106u], Weights.w0[107u]), fma(_2651, f16vec2(Weights.w0[42u], Weights.w0[43u]), f16vec2(Biases.b0[42u], Biases.b0[43u])))))))))));
    f16vec2 _3282 = fma(_3236, f16vec2(Weights.w0[620u], Weights.w0[621u]), fma(_3171, f16vec2(Weights.w0[556u], Weights.w0[557u]), fma(_3106, f16vec2(Weights.w0[492u], Weights.w0[493u]), fma(_3041, f16vec2(Weights.w0[428u], Weights.w0[429u]), fma(_2976, f16vec2(Weights.w0[364u], Weights.w0[365u]), fma(_2911, f16vec2(Weights.w0[300u], Weights.w0[301u]), fma(_2846, f16vec2(Weights.w0[236u], Weights.w0[237u]), fma(_2781, f16vec2(Weights.w0[172u], Weights.w0[173u]), fma(_2716, f16vec2(Weights.w0[108u], Weights.w0[109u]), fma(_2651, f16vec2(Weights.w0[44u], Weights.w0[45u]), f16vec2(Biases.b0[44u], Biases.b0[45u])))))))))));
    f16vec2 _3284 = fma(_3236, f16vec2(Weights.w0[622u], Weights.w0[623u]), fma(_3171, f16vec2(Weights.w0[558u], Weights.w0[559u]), fma(_3106, f16vec2(Weights.w0[494u], Weights.w0[495u]), fma(_3041, f16vec2(Weights.w0[430u], Weights.w0[431u]), fma(_2976, f16vec2(Weights.w0[366u], Weights.w0[367u]), fma(_2911, f16vec2(Weights.w0[302u], Weights.w0[303u]), fma(_2846, f16vec2(Weights.w0[238u], Weights.w0[239u]), fma(_2781, f16vec2(Weights.w0[174u], Weights.w0[175u]), fma(_2716, f16vec2(Weights.w0[110u], Weights.w0[111u]), fma(_2651, f16vec2(Weights.w0[46u], Weights.w0[47u]), f16vec2(Biases.b0[46u], Biases.b0[47u])))))))))));
    f16vec2 _3286 = fma(_3236, f16vec2(Weights.w0[624u], Weights.w0[625u]), fma(_3171, f16vec2(Weights.w0[560u], Weights.w0[561u]), fma(_3106, f16vec2(Weights.w0[496u], Weights.w0[497u]), fma(_3041, f16vec2(Weights.w0[432u], Weights.w0[433u]), fma(_2976, f16vec2(Weights.w0[368u], Weights.w0[369u]), fma(_2911, f16vec2(Weights.w0[304u], Weights.w0[305u]), fma(_2846, f16vec2(Weights.w0[240u], Weights.w0[241u]), fma(_2781, f16vec2(Weights.w0[176u], Weights.w0[177u]), fma(_2716, f16vec2(Weights.w0[112u], Weights.w0[113u]), fma(_2651, f16vec2(Weights.w0[48u], Weights.w0[49u]), f16vec2(Biases.b0[48u], Biases.b0[49u])))))))))));
    f16vec2 _3288 = fma(_3236, f16vec2(Weights.w0[626u], Weights.w0[627u]), fma(_3171, f16vec2(Weights.w0[562u], Weights.w0[563u]), fma(_3106, f16vec2(Weights.w0[498u], Weights.w0[499u]), fma(_3041, f16vec2(Weights.w0[434u], Weights.w0[435u]), fma(_2976, f16vec2(Weights.w0[370u], Weights.w0[371u]), fma(_2911, f16vec2(Weights.w0[306u], Weights.w0[307u]), fma(_2846, f16vec2(Weights.w0[242u], Weights.w0[243u]), fma(_2781, f16vec2(Weights.w0[178u], Weights.w0[179u]), fma(_2716, f16vec2(Weights.w0[114u], Weights.w0[115u]), fma(_2651, f16vec2(Weights.w0[50u], Weights.w0[51u]), f16vec2(Biases.b0[50u], Biases.b0[51u])))))))))));
    f16vec2 _3290 = fma(_3236, f16vec2(Weights.w0[628u], Weights.w0[629u]), fma(_3171, f16vec2(Weights.w0[564u], Weights.w0[565u]), fma(_3106, f16vec2(Weights.w0[500u], Weights.w0[501u]), fma(_3041, f16vec2(Weights.w0[436u], Weights.w0[437u]), fma(_2976, f16vec2(Weights.w0[372u], Weights.w0[373u]), fma(_2911, f16vec2(Weights.w0[308u], Weights.w0[309u]), fma(_2846, f16vec2(Weights.w0[244u], Weights.w0[245u]), fma(_2781, f16vec2(Weights.w0[180u], Weights.w0[181u]), fma(_2716, f16vec2(Weights.w0[116u], Weights.w0[117u]), fma(_2651, f16vec2(Weights.w0[52u], Weights.w0[53u]), f16vec2(Biases.b0[52u], Biases.b0[53u])))))))))));
    f16vec2 _3292 = fma(_3236, f16vec2(Weights.w0[630u], Weights.w0[631u]), fma(_3171, f16vec2(Weights.w0[566u], Weights.w0[567u]), fma(_3106, f16vec2(Weights.w0[502u], Weights.w0[503u]), fma(_3041, f16vec2(Weights.w0[438u], Weights.w0[439u]), fma(_2976, f16vec2(Weights.w0[374u], Weights.w0[375u]), fma(_2911, f16vec2(Weights.w0[310u], Weights.w0[311u]), fma(_2846, f16vec2(Weights.w0[246u], Weights.w0[247u]), fma(_2781, f16vec2(Weights.w0[182u], Weights.w0[183u]), fma(_2716, f16vec2(Weights.w0[118u], Weights.w0[119u]), fma(_2651, f16vec2(Weights.w0[54u], Weights.w0[55u]), f16vec2(Biases.b0[54u], Biases.b0[55u])))))))))));
    f16vec2 _3294 = fma(_3236, f16vec2(Weights.w0[632u], Weights.w0[633u]), fma(_3171, f16vec2(Weights.w0[568u], Weights.w0[569u]), fma(_3106, f16vec2(Weights.w0[504u], Weights.w0[505u]), fma(_3041, f16vec2(Weights.w0[440u], Weights.w0[441u]), fma(_2976, f16vec2(Weights.w0[376u], Weights.w0[377u]), fma(_2911, f16vec2(Weights.w0[312u], Weights.w0[313u]), fma(_2846, f16vec2(Weights.w0[248u], Weights.w0[249u]), fma(_2781, f16vec2(Weights.w0[184u], Weights.w0[185u]), fma(_2716, f16vec2(Weights.w0[120u], Weights.w0[121u]), fma(_2651, f16vec2(Weights.w0[56u], Weights.w0[57u]), f16vec2(Biases.b0[56u], Biases.b0[57u])))))))))));
    f16vec2 _3296 = fma(_3236, f16vec2(Weights.w0[634u], Weights.w0[635u]), fma(_3171, f16vec2(Weights.w0[570u], Weights.w0[571u]), fma(_3106, f16vec2(Weights.w0[506u], Weights.w0[507u]), fma(_3041, f16vec2(Weights.w0[442u], Weights.w0[443u]), fma(_2976, f16vec2(Weights.w0[378u], Weights.w0[379u]), fma(_2911, f16vec2(Weights.w0[314u], Weights.w0[315u]), fma(_2846, f16vec2(Weights.w0[250u], Weights.w0[251u]), fma(_2781, f16vec2(Weights.w0[186u], Weights.w0[187u]), fma(_2716, f16vec2(Weights.w0[122u], Weights.w0[123u]), fma(_2651, f16vec2(Weights.w0[58u], Weights.w0[59u]), f16vec2(Biases.b0[58u], Biases.b0[59u])))))))))));
    f16vec2 _3298 = fma(_3236, f16vec2(Weights.w0[636u], Weights.w0[637u]), fma(_3171, f16vec2(Weights.w0[572u], Weights.w0[573u]), fma(_3106, f16vec2(Weights.w0[508u], Weights.w0[509u]), fma(_3041, f16vec2(Weights.w0[444u], Weights.w0[445u]), fma(_2976, f16vec2(Weights.w0[380u], Weights.w0[381u]), fma(_2911, f16vec2(Weights.w0[316u], Weights.w0[317u]), fma(_2846, f16vec2(Weights.w0[252u], Weights.w0[253u]), fma(_2781, f16vec2(Weights.w0[188u], Weights.w0[189u]), fma(_2716, f16vec2(Weights.w0[124u], Weights.w0[125u]), fma(_2651, f16vec2(Weights.w0[60u], Weights.w0[61u]), f16vec2(Biases.b0[60u], Biases.b0[61u])))))))))));
    f16vec2 _3300 = fma(_3236, f16vec2(Weights.w0[638u], Weights.w0[639u]), fma(_3171, f16vec2(Weights.w0[574u], Weights.w0[575u]), fma(_3106, f16vec2(Weights.w0[510u], Weights.w0[511u]), fma(_3041, f16vec2(Weights.w0[446u], Weights.w0[447u]), fma(_2976, f16vec2(Weights.w0[382u], Weights.w0[383u]), fma(_2911, f16vec2(Weights.w0[318u], Weights.w0[319u]), fma(_2846, f16vec2(Weights.w0[254u], Weights.w0[255u]), fma(_2781, f16vec2(Weights.w0[190u], Weights.w0[191u]), fma(_2716, f16vec2(Weights.w0[126u], Weights.w0[127u]), fma(_2651, f16vec2(Weights.w0[62u], Weights.w0[63u]), f16vec2(Biases.b0[62u], Biases.b0[63u])))))))))));
    return f16vec2[](_3238, _3240, _3242, _3244, _3246, _3248, _3250, _3252, _3254, _3256, _3258, _3260, _3262, _3264, _3266, _3268, _3270, _3272, _3274, _3276, _3278, _3280, _3282, _3284, _3286, _3288, _3290, _3292, _3294, _3296, _3298, _3300);
}

PostprocessStage1 evaluatePostprocessStage0(PostprocessStage0 inputValue, PostprocessNetworkContext context)
{
    f16vec2 _261[32] = _558(inputValue.value);
    f16vec2 tempArg[32] = _261;
    PostprocessStage1 outputValue;
    outputValue.value = _261;
    f16vec2 _7624[32] = outputValue.value;
    uint _7623 = 0u;
    f16vec2 _7622[32];
    uint _7630;
    for (;;)
    {
        _7630 = _7623;
        if (_7630 < 32u)
        {
            _7622[_7630] = max(_7624[_7630], _268[_7630]);
            _7623 = _7630 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    outputValue.value = _7622;
    outputValue.provenance = uvec4(1u, context.selectedRoute, 64u, 1u);
    return outputValue;
}

f16vec2[8] _3303(f16vec2 _3304[32])
{
    f16vec2 _5907 = f16vec2(_3304[0].x);
    f16vec2 _5924 = f16vec2(_3304[0].y);
    f16vec2 _5941 = f16vec2(_3304[1].x);
    f16vec2 _5958 = f16vec2(_3304[1].y);
    f16vec2 _5975 = f16vec2(_3304[2].x);
    f16vec2 _5992 = f16vec2(_3304[2].y);
    f16vec2 _6009 = f16vec2(_3304[3].x);
    f16vec2 _6026 = f16vec2(_3304[3].y);
    f16vec2 _6043 = f16vec2(_3304[4].x);
    f16vec2 _6060 = f16vec2(_3304[4].y);
    f16vec2 _6062 = fma(_6060, f16vec2(Weights.w1[144u], Weights.w1[145u]), fma(_6043, f16vec2(Weights.w1[128u], Weights.w1[129u]), fma(_6026, f16vec2(Weights.w1[112u], Weights.w1[113u]), fma(_6009, f16vec2(Weights.w1[96u], Weights.w1[97u]), fma(_5992, f16vec2(Weights.w1[80u], Weights.w1[81u]), fma(_5975, f16vec2(Weights.w1[64u], Weights.w1[65u]), fma(_5958, f16vec2(Weights.w1[48u], Weights.w1[49u]), fma(_5941, f16vec2(Weights.w1[32u], Weights.w1[33u]), fma(_5924, f16vec2(Weights.w1[16u], Weights.w1[17u]), fma(_5907, f16vec2(Weights.w1[0u], Weights.w1[1u]), f16vec2(Biases.b1[0u], Biases.b1[1u])))))))))));
    f16vec2 _6064 = fma(_6060, f16vec2(Weights.w1[146u], Weights.w1[147u]), fma(_6043, f16vec2(Weights.w1[130u], Weights.w1[131u]), fma(_6026, f16vec2(Weights.w1[114u], Weights.w1[115u]), fma(_6009, f16vec2(Weights.w1[98u], Weights.w1[99u]), fma(_5992, f16vec2(Weights.w1[82u], Weights.w1[83u]), fma(_5975, f16vec2(Weights.w1[66u], Weights.w1[67u]), fma(_5958, f16vec2(Weights.w1[50u], Weights.w1[51u]), fma(_5941, f16vec2(Weights.w1[34u], Weights.w1[35u]), fma(_5924, f16vec2(Weights.w1[18u], Weights.w1[19u]), fma(_5907, f16vec2(Weights.w1[2u], Weights.w1[3u]), f16vec2(Biases.b1[2u], Biases.b1[3u])))))))))));
    f16vec2 _6066 = fma(_6060, f16vec2(Weights.w1[148u], Weights.w1[149u]), fma(_6043, f16vec2(Weights.w1[132u], Weights.w1[133u]), fma(_6026, f16vec2(Weights.w1[116u], Weights.w1[117u]), fma(_6009, f16vec2(Weights.w1[100u], Weights.w1[101u]), fma(_5992, f16vec2(Weights.w1[84u], Weights.w1[85u]), fma(_5975, f16vec2(Weights.w1[68u], Weights.w1[69u]), fma(_5958, f16vec2(Weights.w1[52u], Weights.w1[53u]), fma(_5941, f16vec2(Weights.w1[36u], Weights.w1[37u]), fma(_5924, f16vec2(Weights.w1[20u], Weights.w1[21u]), fma(_5907, f16vec2(Weights.w1[4u], Weights.w1[5u]), f16vec2(Biases.b1[4u], Biases.b1[5u])))))))))));
    f16vec2 _6068 = fma(_6060, f16vec2(Weights.w1[150u], Weights.w1[151u]), fma(_6043, f16vec2(Weights.w1[134u], Weights.w1[135u]), fma(_6026, f16vec2(Weights.w1[118u], Weights.w1[119u]), fma(_6009, f16vec2(Weights.w1[102u], Weights.w1[103u]), fma(_5992, f16vec2(Weights.w1[86u], Weights.w1[87u]), fma(_5975, f16vec2(Weights.w1[70u], Weights.w1[71u]), fma(_5958, f16vec2(Weights.w1[54u], Weights.w1[55u]), fma(_5941, f16vec2(Weights.w1[38u], Weights.w1[39u]), fma(_5924, f16vec2(Weights.w1[22u], Weights.w1[23u]), fma(_5907, f16vec2(Weights.w1[6u], Weights.w1[7u]), f16vec2(Biases.b1[6u], Biases.b1[7u])))))))))));
    f16vec2 _6070 = fma(_6060, f16vec2(Weights.w1[152u], Weights.w1[153u]), fma(_6043, f16vec2(Weights.w1[136u], Weights.w1[137u]), fma(_6026, f16vec2(Weights.w1[120u], Weights.w1[121u]), fma(_6009, f16vec2(Weights.w1[104u], Weights.w1[105u]), fma(_5992, f16vec2(Weights.w1[88u], Weights.w1[89u]), fma(_5975, f16vec2(Weights.w1[72u], Weights.w1[73u]), fma(_5958, f16vec2(Weights.w1[56u], Weights.w1[57u]), fma(_5941, f16vec2(Weights.w1[40u], Weights.w1[41u]), fma(_5924, f16vec2(Weights.w1[24u], Weights.w1[25u]), fma(_5907, f16vec2(Weights.w1[8u], Weights.w1[9u]), f16vec2(Biases.b1[8u], Biases.b1[9u])))))))))));
    f16vec2 _6072 = fma(_6060, f16vec2(Weights.w1[154u], Weights.w1[155u]), fma(_6043, f16vec2(Weights.w1[138u], Weights.w1[139u]), fma(_6026, f16vec2(Weights.w1[122u], Weights.w1[123u]), fma(_6009, f16vec2(Weights.w1[106u], Weights.w1[107u]), fma(_5992, f16vec2(Weights.w1[90u], Weights.w1[91u]), fma(_5975, f16vec2(Weights.w1[74u], Weights.w1[75u]), fma(_5958, f16vec2(Weights.w1[58u], Weights.w1[59u]), fma(_5941, f16vec2(Weights.w1[42u], Weights.w1[43u]), fma(_5924, f16vec2(Weights.w1[26u], Weights.w1[27u]), fma(_5907, f16vec2(Weights.w1[10u], Weights.w1[11u]), f16vec2(Biases.b1[10u], Biases.b1[11u])))))))))));
    f16vec2 _6074 = fma(_6060, f16vec2(Weights.w1[156u], Weights.w1[157u]), fma(_6043, f16vec2(Weights.w1[140u], Weights.w1[141u]), fma(_6026, f16vec2(Weights.w1[124u], Weights.w1[125u]), fma(_6009, f16vec2(Weights.w1[108u], Weights.w1[109u]), fma(_5992, f16vec2(Weights.w1[92u], Weights.w1[93u]), fma(_5975, f16vec2(Weights.w1[76u], Weights.w1[77u]), fma(_5958, f16vec2(Weights.w1[60u], Weights.w1[61u]), fma(_5941, f16vec2(Weights.w1[44u], Weights.w1[45u]), fma(_5924, f16vec2(Weights.w1[28u], Weights.w1[29u]), fma(_5907, f16vec2(Weights.w1[12u], Weights.w1[13u]), f16vec2(Biases.b1[12u], Biases.b1[13u])))))))))));
    f16vec2 _6076 = fma(_6060, f16vec2(Weights.w1[158u], Weights.w1[159u]), fma(_6043, f16vec2(Weights.w1[142u], Weights.w1[143u]), fma(_6026, f16vec2(Weights.w1[126u], Weights.w1[127u]), fma(_6009, f16vec2(Weights.w1[110u], Weights.w1[111u]), fma(_5992, f16vec2(Weights.w1[94u], Weights.w1[95u]), fma(_5975, f16vec2(Weights.w1[78u], Weights.w1[79u]), fma(_5958, f16vec2(Weights.w1[62u], Weights.w1[63u]), fma(_5941, f16vec2(Weights.w1[46u], Weights.w1[47u]), fma(_5924, f16vec2(Weights.w1[30u], Weights.w1[31u]), fma(_5907, f16vec2(Weights.w1[14u], Weights.w1[15u]), f16vec2(Biases.b1[14u], Biases.b1[15u])))))))))));
    f16vec2 _6077 = f16vec2(_3304[5].x);
    f16vec2 _6094 = f16vec2(_3304[5].y);
    f16vec2 _6111 = f16vec2(_3304[6].x);
    f16vec2 _6128 = f16vec2(_3304[6].y);
    f16vec2 _6145 = f16vec2(_3304[7].x);
    f16vec2 _6162 = f16vec2(_3304[7].y);
    f16vec2 _6179 = f16vec2(_3304[8].x);
    f16vec2 _6196 = f16vec2(_3304[8].y);
    f16vec2 _6213 = f16vec2(_3304[9].x);
    f16vec2 _6230 = f16vec2(_3304[9].y);
    f16vec2 _6232 = fma(_6230, f16vec2(Weights.w1[304u], Weights.w1[305u]), fma(_6213, f16vec2(Weights.w1[288u], Weights.w1[289u]), fma(_6196, f16vec2(Weights.w1[272u], Weights.w1[273u]), fma(_6179, f16vec2(Weights.w1[256u], Weights.w1[257u]), fma(_6162, f16vec2(Weights.w1[240u], Weights.w1[241u]), fma(_6145, f16vec2(Weights.w1[224u], Weights.w1[225u]), fma(_6128, f16vec2(Weights.w1[208u], Weights.w1[209u]), fma(_6111, f16vec2(Weights.w1[192u], Weights.w1[193u]), fma(_6094, f16vec2(Weights.w1[176u], Weights.w1[177u]), fma(_6077, f16vec2(Weights.w1[160u], Weights.w1[161u]), _6062))))))))));
    f16vec2 _6234 = fma(_6230, f16vec2(Weights.w1[306u], Weights.w1[307u]), fma(_6213, f16vec2(Weights.w1[290u], Weights.w1[291u]), fma(_6196, f16vec2(Weights.w1[274u], Weights.w1[275u]), fma(_6179, f16vec2(Weights.w1[258u], Weights.w1[259u]), fma(_6162, f16vec2(Weights.w1[242u], Weights.w1[243u]), fma(_6145, f16vec2(Weights.w1[226u], Weights.w1[227u]), fma(_6128, f16vec2(Weights.w1[210u], Weights.w1[211u]), fma(_6111, f16vec2(Weights.w1[194u], Weights.w1[195u]), fma(_6094, f16vec2(Weights.w1[178u], Weights.w1[179u]), fma(_6077, f16vec2(Weights.w1[162u], Weights.w1[163u]), _6064))))))))));
    f16vec2 _6236 = fma(_6230, f16vec2(Weights.w1[308u], Weights.w1[309u]), fma(_6213, f16vec2(Weights.w1[292u], Weights.w1[293u]), fma(_6196, f16vec2(Weights.w1[276u], Weights.w1[277u]), fma(_6179, f16vec2(Weights.w1[260u], Weights.w1[261u]), fma(_6162, f16vec2(Weights.w1[244u], Weights.w1[245u]), fma(_6145, f16vec2(Weights.w1[228u], Weights.w1[229u]), fma(_6128, f16vec2(Weights.w1[212u], Weights.w1[213u]), fma(_6111, f16vec2(Weights.w1[196u], Weights.w1[197u]), fma(_6094, f16vec2(Weights.w1[180u], Weights.w1[181u]), fma(_6077, f16vec2(Weights.w1[164u], Weights.w1[165u]), _6066))))))))));
    f16vec2 _6238 = fma(_6230, f16vec2(Weights.w1[310u], Weights.w1[311u]), fma(_6213, f16vec2(Weights.w1[294u], Weights.w1[295u]), fma(_6196, f16vec2(Weights.w1[278u], Weights.w1[279u]), fma(_6179, f16vec2(Weights.w1[262u], Weights.w1[263u]), fma(_6162, f16vec2(Weights.w1[246u], Weights.w1[247u]), fma(_6145, f16vec2(Weights.w1[230u], Weights.w1[231u]), fma(_6128, f16vec2(Weights.w1[214u], Weights.w1[215u]), fma(_6111, f16vec2(Weights.w1[198u], Weights.w1[199u]), fma(_6094, f16vec2(Weights.w1[182u], Weights.w1[183u]), fma(_6077, f16vec2(Weights.w1[166u], Weights.w1[167u]), _6068))))))))));
    f16vec2 _6240 = fma(_6230, f16vec2(Weights.w1[312u], Weights.w1[313u]), fma(_6213, f16vec2(Weights.w1[296u], Weights.w1[297u]), fma(_6196, f16vec2(Weights.w1[280u], Weights.w1[281u]), fma(_6179, f16vec2(Weights.w1[264u], Weights.w1[265u]), fma(_6162, f16vec2(Weights.w1[248u], Weights.w1[249u]), fma(_6145, f16vec2(Weights.w1[232u], Weights.w1[233u]), fma(_6128, f16vec2(Weights.w1[216u], Weights.w1[217u]), fma(_6111, f16vec2(Weights.w1[200u], Weights.w1[201u]), fma(_6094, f16vec2(Weights.w1[184u], Weights.w1[185u]), fma(_6077, f16vec2(Weights.w1[168u], Weights.w1[169u]), _6070))))))))));
    f16vec2 _6242 = fma(_6230, f16vec2(Weights.w1[314u], Weights.w1[315u]), fma(_6213, f16vec2(Weights.w1[298u], Weights.w1[299u]), fma(_6196, f16vec2(Weights.w1[282u], Weights.w1[283u]), fma(_6179, f16vec2(Weights.w1[266u], Weights.w1[267u]), fma(_6162, f16vec2(Weights.w1[250u], Weights.w1[251u]), fma(_6145, f16vec2(Weights.w1[234u], Weights.w1[235u]), fma(_6128, f16vec2(Weights.w1[218u], Weights.w1[219u]), fma(_6111, f16vec2(Weights.w1[202u], Weights.w1[203u]), fma(_6094, f16vec2(Weights.w1[186u], Weights.w1[187u]), fma(_6077, f16vec2(Weights.w1[170u], Weights.w1[171u]), _6072))))))))));
    f16vec2 _6244 = fma(_6230, f16vec2(Weights.w1[316u], Weights.w1[317u]), fma(_6213, f16vec2(Weights.w1[300u], Weights.w1[301u]), fma(_6196, f16vec2(Weights.w1[284u], Weights.w1[285u]), fma(_6179, f16vec2(Weights.w1[268u], Weights.w1[269u]), fma(_6162, f16vec2(Weights.w1[252u], Weights.w1[253u]), fma(_6145, f16vec2(Weights.w1[236u], Weights.w1[237u]), fma(_6128, f16vec2(Weights.w1[220u], Weights.w1[221u]), fma(_6111, f16vec2(Weights.w1[204u], Weights.w1[205u]), fma(_6094, f16vec2(Weights.w1[188u], Weights.w1[189u]), fma(_6077, f16vec2(Weights.w1[172u], Weights.w1[173u]), _6074))))))))));
    f16vec2 _6246 = fma(_6230, f16vec2(Weights.w1[318u], Weights.w1[319u]), fma(_6213, f16vec2(Weights.w1[302u], Weights.w1[303u]), fma(_6196, f16vec2(Weights.w1[286u], Weights.w1[287u]), fma(_6179, f16vec2(Weights.w1[270u], Weights.w1[271u]), fma(_6162, f16vec2(Weights.w1[254u], Weights.w1[255u]), fma(_6145, f16vec2(Weights.w1[238u], Weights.w1[239u]), fma(_6128, f16vec2(Weights.w1[222u], Weights.w1[223u]), fma(_6111, f16vec2(Weights.w1[206u], Weights.w1[207u]), fma(_6094, f16vec2(Weights.w1[190u], Weights.w1[191u]), fma(_6077, f16vec2(Weights.w1[174u], Weights.w1[175u]), _6076))))))))));
    f16vec2 _6247 = f16vec2(_3304[10].x);
    f16vec2 _6264 = f16vec2(_3304[10].y);
    f16vec2 _6281 = f16vec2(_3304[11].x);
    f16vec2 _6298 = f16vec2(_3304[11].y);
    f16vec2 _6315 = f16vec2(_3304[12].x);
    f16vec2 _6332 = f16vec2(_3304[12].y);
    f16vec2 _6349 = f16vec2(_3304[13].x);
    f16vec2 _6366 = f16vec2(_3304[13].y);
    f16vec2 _6383 = f16vec2(_3304[14].x);
    f16vec2 _6400 = f16vec2(_3304[14].y);
    f16vec2 _6402 = fma(_6400, f16vec2(Weights.w1[464u], Weights.w1[465u]), fma(_6383, f16vec2(Weights.w1[448u], Weights.w1[449u]), fma(_6366, f16vec2(Weights.w1[432u], Weights.w1[433u]), fma(_6349, f16vec2(Weights.w1[416u], Weights.w1[417u]), fma(_6332, f16vec2(Weights.w1[400u], Weights.w1[401u]), fma(_6315, f16vec2(Weights.w1[384u], Weights.w1[385u]), fma(_6298, f16vec2(Weights.w1[368u], Weights.w1[369u]), fma(_6281, f16vec2(Weights.w1[352u], Weights.w1[353u]), fma(_6264, f16vec2(Weights.w1[336u], Weights.w1[337u]), fma(_6247, f16vec2(Weights.w1[320u], Weights.w1[321u]), _6232))))))))));
    f16vec2 _6404 = fma(_6400, f16vec2(Weights.w1[466u], Weights.w1[467u]), fma(_6383, f16vec2(Weights.w1[450u], Weights.w1[451u]), fma(_6366, f16vec2(Weights.w1[434u], Weights.w1[435u]), fma(_6349, f16vec2(Weights.w1[418u], Weights.w1[419u]), fma(_6332, f16vec2(Weights.w1[402u], Weights.w1[403u]), fma(_6315, f16vec2(Weights.w1[386u], Weights.w1[387u]), fma(_6298, f16vec2(Weights.w1[370u], Weights.w1[371u]), fma(_6281, f16vec2(Weights.w1[354u], Weights.w1[355u]), fma(_6264, f16vec2(Weights.w1[338u], Weights.w1[339u]), fma(_6247, f16vec2(Weights.w1[322u], Weights.w1[323u]), _6234))))))))));
    f16vec2 _6406 = fma(_6400, f16vec2(Weights.w1[468u], Weights.w1[469u]), fma(_6383, f16vec2(Weights.w1[452u], Weights.w1[453u]), fma(_6366, f16vec2(Weights.w1[436u], Weights.w1[437u]), fma(_6349, f16vec2(Weights.w1[420u], Weights.w1[421u]), fma(_6332, f16vec2(Weights.w1[404u], Weights.w1[405u]), fma(_6315, f16vec2(Weights.w1[388u], Weights.w1[389u]), fma(_6298, f16vec2(Weights.w1[372u], Weights.w1[373u]), fma(_6281, f16vec2(Weights.w1[356u], Weights.w1[357u]), fma(_6264, f16vec2(Weights.w1[340u], Weights.w1[341u]), fma(_6247, f16vec2(Weights.w1[324u], Weights.w1[325u]), _6236))))))))));
    f16vec2 _6408 = fma(_6400, f16vec2(Weights.w1[470u], Weights.w1[471u]), fma(_6383, f16vec2(Weights.w1[454u], Weights.w1[455u]), fma(_6366, f16vec2(Weights.w1[438u], Weights.w1[439u]), fma(_6349, f16vec2(Weights.w1[422u], Weights.w1[423u]), fma(_6332, f16vec2(Weights.w1[406u], Weights.w1[407u]), fma(_6315, f16vec2(Weights.w1[390u], Weights.w1[391u]), fma(_6298, f16vec2(Weights.w1[374u], Weights.w1[375u]), fma(_6281, f16vec2(Weights.w1[358u], Weights.w1[359u]), fma(_6264, f16vec2(Weights.w1[342u], Weights.w1[343u]), fma(_6247, f16vec2(Weights.w1[326u], Weights.w1[327u]), _6238))))))))));
    f16vec2 _6410 = fma(_6400, f16vec2(Weights.w1[472u], Weights.w1[473u]), fma(_6383, f16vec2(Weights.w1[456u], Weights.w1[457u]), fma(_6366, f16vec2(Weights.w1[440u], Weights.w1[441u]), fma(_6349, f16vec2(Weights.w1[424u], Weights.w1[425u]), fma(_6332, f16vec2(Weights.w1[408u], Weights.w1[409u]), fma(_6315, f16vec2(Weights.w1[392u], Weights.w1[393u]), fma(_6298, f16vec2(Weights.w1[376u], Weights.w1[377u]), fma(_6281, f16vec2(Weights.w1[360u], Weights.w1[361u]), fma(_6264, f16vec2(Weights.w1[344u], Weights.w1[345u]), fma(_6247, f16vec2(Weights.w1[328u], Weights.w1[329u]), _6240))))))))));
    f16vec2 _6412 = fma(_6400, f16vec2(Weights.w1[474u], Weights.w1[475u]), fma(_6383, f16vec2(Weights.w1[458u], Weights.w1[459u]), fma(_6366, f16vec2(Weights.w1[442u], Weights.w1[443u]), fma(_6349, f16vec2(Weights.w1[426u], Weights.w1[427u]), fma(_6332, f16vec2(Weights.w1[410u], Weights.w1[411u]), fma(_6315, f16vec2(Weights.w1[394u], Weights.w1[395u]), fma(_6298, f16vec2(Weights.w1[378u], Weights.w1[379u]), fma(_6281, f16vec2(Weights.w1[362u], Weights.w1[363u]), fma(_6264, f16vec2(Weights.w1[346u], Weights.w1[347u]), fma(_6247, f16vec2(Weights.w1[330u], Weights.w1[331u]), _6242))))))))));
    f16vec2 _6414 = fma(_6400, f16vec2(Weights.w1[476u], Weights.w1[477u]), fma(_6383, f16vec2(Weights.w1[460u], Weights.w1[461u]), fma(_6366, f16vec2(Weights.w1[444u], Weights.w1[445u]), fma(_6349, f16vec2(Weights.w1[428u], Weights.w1[429u]), fma(_6332, f16vec2(Weights.w1[412u], Weights.w1[413u]), fma(_6315, f16vec2(Weights.w1[396u], Weights.w1[397u]), fma(_6298, f16vec2(Weights.w1[380u], Weights.w1[381u]), fma(_6281, f16vec2(Weights.w1[364u], Weights.w1[365u]), fma(_6264, f16vec2(Weights.w1[348u], Weights.w1[349u]), fma(_6247, f16vec2(Weights.w1[332u], Weights.w1[333u]), _6244))))))))));
    f16vec2 _6416 = fma(_6400, f16vec2(Weights.w1[478u], Weights.w1[479u]), fma(_6383, f16vec2(Weights.w1[462u], Weights.w1[463u]), fma(_6366, f16vec2(Weights.w1[446u], Weights.w1[447u]), fma(_6349, f16vec2(Weights.w1[430u], Weights.w1[431u]), fma(_6332, f16vec2(Weights.w1[414u], Weights.w1[415u]), fma(_6315, f16vec2(Weights.w1[398u], Weights.w1[399u]), fma(_6298, f16vec2(Weights.w1[382u], Weights.w1[383u]), fma(_6281, f16vec2(Weights.w1[366u], Weights.w1[367u]), fma(_6264, f16vec2(Weights.w1[350u], Weights.w1[351u]), fma(_6247, f16vec2(Weights.w1[334u], Weights.w1[335u]), _6246))))))))));
    f16vec2 _6417 = f16vec2(_3304[15].x);
    f16vec2 _6434 = f16vec2(_3304[15].y);
    f16vec2 _6451 = f16vec2(_3304[16].x);
    f16vec2 _6468 = f16vec2(_3304[16].y);
    f16vec2 _6485 = f16vec2(_3304[17].x);
    f16vec2 _6502 = f16vec2(_3304[17].y);
    f16vec2 _6519 = f16vec2(_3304[18].x);
    f16vec2 _6536 = f16vec2(_3304[18].y);
    f16vec2 _6553 = f16vec2(_3304[19].x);
    f16vec2 _6570 = f16vec2(_3304[19].y);
    f16vec2 _6572 = fma(_6570, f16vec2(Weights.w1[624u], Weights.w1[625u]), fma(_6553, f16vec2(Weights.w1[608u], Weights.w1[609u]), fma(_6536, f16vec2(Weights.w1[592u], Weights.w1[593u]), fma(_6519, f16vec2(Weights.w1[576u], Weights.w1[577u]), fma(_6502, f16vec2(Weights.w1[560u], Weights.w1[561u]), fma(_6485, f16vec2(Weights.w1[544u], Weights.w1[545u]), fma(_6468, f16vec2(Weights.w1[528u], Weights.w1[529u]), fma(_6451, f16vec2(Weights.w1[512u], Weights.w1[513u]), fma(_6434, f16vec2(Weights.w1[496u], Weights.w1[497u]), fma(_6417, f16vec2(Weights.w1[480u], Weights.w1[481u]), _6402))))))))));
    f16vec2 _6574 = fma(_6570, f16vec2(Weights.w1[626u], Weights.w1[627u]), fma(_6553, f16vec2(Weights.w1[610u], Weights.w1[611u]), fma(_6536, f16vec2(Weights.w1[594u], Weights.w1[595u]), fma(_6519, f16vec2(Weights.w1[578u], Weights.w1[579u]), fma(_6502, f16vec2(Weights.w1[562u], Weights.w1[563u]), fma(_6485, f16vec2(Weights.w1[546u], Weights.w1[547u]), fma(_6468, f16vec2(Weights.w1[530u], Weights.w1[531u]), fma(_6451, f16vec2(Weights.w1[514u], Weights.w1[515u]), fma(_6434, f16vec2(Weights.w1[498u], Weights.w1[499u]), fma(_6417, f16vec2(Weights.w1[482u], Weights.w1[483u]), _6404))))))))));
    f16vec2 _6576 = fma(_6570, f16vec2(Weights.w1[628u], Weights.w1[629u]), fma(_6553, f16vec2(Weights.w1[612u], Weights.w1[613u]), fma(_6536, f16vec2(Weights.w1[596u], Weights.w1[597u]), fma(_6519, f16vec2(Weights.w1[580u], Weights.w1[581u]), fma(_6502, f16vec2(Weights.w1[564u], Weights.w1[565u]), fma(_6485, f16vec2(Weights.w1[548u], Weights.w1[549u]), fma(_6468, f16vec2(Weights.w1[532u], Weights.w1[533u]), fma(_6451, f16vec2(Weights.w1[516u], Weights.w1[517u]), fma(_6434, f16vec2(Weights.w1[500u], Weights.w1[501u]), fma(_6417, f16vec2(Weights.w1[484u], Weights.w1[485u]), _6406))))))))));
    f16vec2 _6578 = fma(_6570, f16vec2(Weights.w1[630u], Weights.w1[631u]), fma(_6553, f16vec2(Weights.w1[614u], Weights.w1[615u]), fma(_6536, f16vec2(Weights.w1[598u], Weights.w1[599u]), fma(_6519, f16vec2(Weights.w1[582u], Weights.w1[583u]), fma(_6502, f16vec2(Weights.w1[566u], Weights.w1[567u]), fma(_6485, f16vec2(Weights.w1[550u], Weights.w1[551u]), fma(_6468, f16vec2(Weights.w1[534u], Weights.w1[535u]), fma(_6451, f16vec2(Weights.w1[518u], Weights.w1[519u]), fma(_6434, f16vec2(Weights.w1[502u], Weights.w1[503u]), fma(_6417, f16vec2(Weights.w1[486u], Weights.w1[487u]), _6408))))))))));
    f16vec2 _6580 = fma(_6570, f16vec2(Weights.w1[632u], Weights.w1[633u]), fma(_6553, f16vec2(Weights.w1[616u], Weights.w1[617u]), fma(_6536, f16vec2(Weights.w1[600u], Weights.w1[601u]), fma(_6519, f16vec2(Weights.w1[584u], Weights.w1[585u]), fma(_6502, f16vec2(Weights.w1[568u], Weights.w1[569u]), fma(_6485, f16vec2(Weights.w1[552u], Weights.w1[553u]), fma(_6468, f16vec2(Weights.w1[536u], Weights.w1[537u]), fma(_6451, f16vec2(Weights.w1[520u], Weights.w1[521u]), fma(_6434, f16vec2(Weights.w1[504u], Weights.w1[505u]), fma(_6417, f16vec2(Weights.w1[488u], Weights.w1[489u]), _6410))))))))));
    f16vec2 _6582 = fma(_6570, f16vec2(Weights.w1[634u], Weights.w1[635u]), fma(_6553, f16vec2(Weights.w1[618u], Weights.w1[619u]), fma(_6536, f16vec2(Weights.w1[602u], Weights.w1[603u]), fma(_6519, f16vec2(Weights.w1[586u], Weights.w1[587u]), fma(_6502, f16vec2(Weights.w1[570u], Weights.w1[571u]), fma(_6485, f16vec2(Weights.w1[554u], Weights.w1[555u]), fma(_6468, f16vec2(Weights.w1[538u], Weights.w1[539u]), fma(_6451, f16vec2(Weights.w1[522u], Weights.w1[523u]), fma(_6434, f16vec2(Weights.w1[506u], Weights.w1[507u]), fma(_6417, f16vec2(Weights.w1[490u], Weights.w1[491u]), _6412))))))))));
    f16vec2 _6584 = fma(_6570, f16vec2(Weights.w1[636u], Weights.w1[637u]), fma(_6553, f16vec2(Weights.w1[620u], Weights.w1[621u]), fma(_6536, f16vec2(Weights.w1[604u], Weights.w1[605u]), fma(_6519, f16vec2(Weights.w1[588u], Weights.w1[589u]), fma(_6502, f16vec2(Weights.w1[572u], Weights.w1[573u]), fma(_6485, f16vec2(Weights.w1[556u], Weights.w1[557u]), fma(_6468, f16vec2(Weights.w1[540u], Weights.w1[541u]), fma(_6451, f16vec2(Weights.w1[524u], Weights.w1[525u]), fma(_6434, f16vec2(Weights.w1[508u], Weights.w1[509u]), fma(_6417, f16vec2(Weights.w1[492u], Weights.w1[493u]), _6414))))))))));
    f16vec2 _6586 = fma(_6570, f16vec2(Weights.w1[638u], Weights.w1[639u]), fma(_6553, f16vec2(Weights.w1[622u], Weights.w1[623u]), fma(_6536, f16vec2(Weights.w1[606u], Weights.w1[607u]), fma(_6519, f16vec2(Weights.w1[590u], Weights.w1[591u]), fma(_6502, f16vec2(Weights.w1[574u], Weights.w1[575u]), fma(_6485, f16vec2(Weights.w1[558u], Weights.w1[559u]), fma(_6468, f16vec2(Weights.w1[542u], Weights.w1[543u]), fma(_6451, f16vec2(Weights.w1[526u], Weights.w1[527u]), fma(_6434, f16vec2(Weights.w1[510u], Weights.w1[511u]), fma(_6417, f16vec2(Weights.w1[494u], Weights.w1[495u]), _6416))))))))));
    f16vec2 _6587 = f16vec2(_3304[20].x);
    f16vec2 _6604 = f16vec2(_3304[20].y);
    f16vec2 _6621 = f16vec2(_3304[21].x);
    f16vec2 _6638 = f16vec2(_3304[21].y);
    f16vec2 _6655 = f16vec2(_3304[22].x);
    f16vec2 _6672 = f16vec2(_3304[22].y);
    f16vec2 _6689 = f16vec2(_3304[23].x);
    f16vec2 _6706 = f16vec2(_3304[23].y);
    f16vec2 _6723 = f16vec2(_3304[24].x);
    f16vec2 _6740 = f16vec2(_3304[24].y);
    f16vec2 _6742 = fma(_6740, f16vec2(Weights.w1[784u], Weights.w1[785u]), fma(_6723, f16vec2(Weights.w1[768u], Weights.w1[769u]), fma(_6706, f16vec2(Weights.w1[752u], Weights.w1[753u]), fma(_6689, f16vec2(Weights.w1[736u], Weights.w1[737u]), fma(_6672, f16vec2(Weights.w1[720u], Weights.w1[721u]), fma(_6655, f16vec2(Weights.w1[704u], Weights.w1[705u]), fma(_6638, f16vec2(Weights.w1[688u], Weights.w1[689u]), fma(_6621, f16vec2(Weights.w1[672u], Weights.w1[673u]), fma(_6604, f16vec2(Weights.w1[656u], Weights.w1[657u]), fma(_6587, f16vec2(Weights.w1[640u], Weights.w1[641u]), _6572))))))))));
    f16vec2 _6744 = fma(_6740, f16vec2(Weights.w1[786u], Weights.w1[787u]), fma(_6723, f16vec2(Weights.w1[770u], Weights.w1[771u]), fma(_6706, f16vec2(Weights.w1[754u], Weights.w1[755u]), fma(_6689, f16vec2(Weights.w1[738u], Weights.w1[739u]), fma(_6672, f16vec2(Weights.w1[722u], Weights.w1[723u]), fma(_6655, f16vec2(Weights.w1[706u], Weights.w1[707u]), fma(_6638, f16vec2(Weights.w1[690u], Weights.w1[691u]), fma(_6621, f16vec2(Weights.w1[674u], Weights.w1[675u]), fma(_6604, f16vec2(Weights.w1[658u], Weights.w1[659u]), fma(_6587, f16vec2(Weights.w1[642u], Weights.w1[643u]), _6574))))))))));
    f16vec2 _6746 = fma(_6740, f16vec2(Weights.w1[788u], Weights.w1[789u]), fma(_6723, f16vec2(Weights.w1[772u], Weights.w1[773u]), fma(_6706, f16vec2(Weights.w1[756u], Weights.w1[757u]), fma(_6689, f16vec2(Weights.w1[740u], Weights.w1[741u]), fma(_6672, f16vec2(Weights.w1[724u], Weights.w1[725u]), fma(_6655, f16vec2(Weights.w1[708u], Weights.w1[709u]), fma(_6638, f16vec2(Weights.w1[692u], Weights.w1[693u]), fma(_6621, f16vec2(Weights.w1[676u], Weights.w1[677u]), fma(_6604, f16vec2(Weights.w1[660u], Weights.w1[661u]), fma(_6587, f16vec2(Weights.w1[644u], Weights.w1[645u]), _6576))))))))));
    f16vec2 _6748 = fma(_6740, f16vec2(Weights.w1[790u], Weights.w1[791u]), fma(_6723, f16vec2(Weights.w1[774u], Weights.w1[775u]), fma(_6706, f16vec2(Weights.w1[758u], Weights.w1[759u]), fma(_6689, f16vec2(Weights.w1[742u], Weights.w1[743u]), fma(_6672, f16vec2(Weights.w1[726u], Weights.w1[727u]), fma(_6655, f16vec2(Weights.w1[710u], Weights.w1[711u]), fma(_6638, f16vec2(Weights.w1[694u], Weights.w1[695u]), fma(_6621, f16vec2(Weights.w1[678u], Weights.w1[679u]), fma(_6604, f16vec2(Weights.w1[662u], Weights.w1[663u]), fma(_6587, f16vec2(Weights.w1[646u], Weights.w1[647u]), _6578))))))))));
    f16vec2 _6750 = fma(_6740, f16vec2(Weights.w1[792u], Weights.w1[793u]), fma(_6723, f16vec2(Weights.w1[776u], Weights.w1[777u]), fma(_6706, f16vec2(Weights.w1[760u], Weights.w1[761u]), fma(_6689, f16vec2(Weights.w1[744u], Weights.w1[745u]), fma(_6672, f16vec2(Weights.w1[728u], Weights.w1[729u]), fma(_6655, f16vec2(Weights.w1[712u], Weights.w1[713u]), fma(_6638, f16vec2(Weights.w1[696u], Weights.w1[697u]), fma(_6621, f16vec2(Weights.w1[680u], Weights.w1[681u]), fma(_6604, f16vec2(Weights.w1[664u], Weights.w1[665u]), fma(_6587, f16vec2(Weights.w1[648u], Weights.w1[649u]), _6580))))))))));
    f16vec2 _6752 = fma(_6740, f16vec2(Weights.w1[794u], Weights.w1[795u]), fma(_6723, f16vec2(Weights.w1[778u], Weights.w1[779u]), fma(_6706, f16vec2(Weights.w1[762u], Weights.w1[763u]), fma(_6689, f16vec2(Weights.w1[746u], Weights.w1[747u]), fma(_6672, f16vec2(Weights.w1[730u], Weights.w1[731u]), fma(_6655, f16vec2(Weights.w1[714u], Weights.w1[715u]), fma(_6638, f16vec2(Weights.w1[698u], Weights.w1[699u]), fma(_6621, f16vec2(Weights.w1[682u], Weights.w1[683u]), fma(_6604, f16vec2(Weights.w1[666u], Weights.w1[667u]), fma(_6587, f16vec2(Weights.w1[650u], Weights.w1[651u]), _6582))))))))));
    f16vec2 _6754 = fma(_6740, f16vec2(Weights.w1[796u], Weights.w1[797u]), fma(_6723, f16vec2(Weights.w1[780u], Weights.w1[781u]), fma(_6706, f16vec2(Weights.w1[764u], Weights.w1[765u]), fma(_6689, f16vec2(Weights.w1[748u], Weights.w1[749u]), fma(_6672, f16vec2(Weights.w1[732u], Weights.w1[733u]), fma(_6655, f16vec2(Weights.w1[716u], Weights.w1[717u]), fma(_6638, f16vec2(Weights.w1[700u], Weights.w1[701u]), fma(_6621, f16vec2(Weights.w1[684u], Weights.w1[685u]), fma(_6604, f16vec2(Weights.w1[668u], Weights.w1[669u]), fma(_6587, f16vec2(Weights.w1[652u], Weights.w1[653u]), _6584))))))))));
    f16vec2 _6756 = fma(_6740, f16vec2(Weights.w1[798u], Weights.w1[799u]), fma(_6723, f16vec2(Weights.w1[782u], Weights.w1[783u]), fma(_6706, f16vec2(Weights.w1[766u], Weights.w1[767u]), fma(_6689, f16vec2(Weights.w1[750u], Weights.w1[751u]), fma(_6672, f16vec2(Weights.w1[734u], Weights.w1[735u]), fma(_6655, f16vec2(Weights.w1[718u], Weights.w1[719u]), fma(_6638, f16vec2(Weights.w1[702u], Weights.w1[703u]), fma(_6621, f16vec2(Weights.w1[686u], Weights.w1[687u]), fma(_6604, f16vec2(Weights.w1[670u], Weights.w1[671u]), fma(_6587, f16vec2(Weights.w1[654u], Weights.w1[655u]), _6586))))))))));
    f16vec2 _6757 = f16vec2(_3304[25].x);
    f16vec2 _6774 = f16vec2(_3304[25].y);
    f16vec2 _6791 = f16vec2(_3304[26].x);
    f16vec2 _6808 = f16vec2(_3304[26].y);
    f16vec2 _6825 = f16vec2(_3304[27].x);
    f16vec2 _6842 = f16vec2(_3304[27].y);
    f16vec2 _6859 = f16vec2(_3304[28].x);
    f16vec2 _6876 = f16vec2(_3304[28].y);
    f16vec2 _6893 = f16vec2(_3304[29].x);
    f16vec2 _6910 = f16vec2(_3304[29].y);
    f16vec2 _6912 = fma(_6910, f16vec2(Weights.w1[944u], Weights.w1[945u]), fma(_6893, f16vec2(Weights.w1[928u], Weights.w1[929u]), fma(_6876, f16vec2(Weights.w1[912u], Weights.w1[913u]), fma(_6859, f16vec2(Weights.w1[896u], Weights.w1[897u]), fma(_6842, f16vec2(Weights.w1[880u], Weights.w1[881u]), fma(_6825, f16vec2(Weights.w1[864u], Weights.w1[865u]), fma(_6808, f16vec2(Weights.w1[848u], Weights.w1[849u]), fma(_6791, f16vec2(Weights.w1[832u], Weights.w1[833u]), fma(_6774, f16vec2(Weights.w1[816u], Weights.w1[817u]), fma(_6757, f16vec2(Weights.w1[800u], Weights.w1[801u]), _6742))))))))));
    f16vec2 _6914 = fma(_6910, f16vec2(Weights.w1[946u], Weights.w1[947u]), fma(_6893, f16vec2(Weights.w1[930u], Weights.w1[931u]), fma(_6876, f16vec2(Weights.w1[914u], Weights.w1[915u]), fma(_6859, f16vec2(Weights.w1[898u], Weights.w1[899u]), fma(_6842, f16vec2(Weights.w1[882u], Weights.w1[883u]), fma(_6825, f16vec2(Weights.w1[866u], Weights.w1[867u]), fma(_6808, f16vec2(Weights.w1[850u], Weights.w1[851u]), fma(_6791, f16vec2(Weights.w1[834u], Weights.w1[835u]), fma(_6774, f16vec2(Weights.w1[818u], Weights.w1[819u]), fma(_6757, f16vec2(Weights.w1[802u], Weights.w1[803u]), _6744))))))))));
    f16vec2 _6916 = fma(_6910, f16vec2(Weights.w1[948u], Weights.w1[949u]), fma(_6893, f16vec2(Weights.w1[932u], Weights.w1[933u]), fma(_6876, f16vec2(Weights.w1[916u], Weights.w1[917u]), fma(_6859, f16vec2(Weights.w1[900u], Weights.w1[901u]), fma(_6842, f16vec2(Weights.w1[884u], Weights.w1[885u]), fma(_6825, f16vec2(Weights.w1[868u], Weights.w1[869u]), fma(_6808, f16vec2(Weights.w1[852u], Weights.w1[853u]), fma(_6791, f16vec2(Weights.w1[836u], Weights.w1[837u]), fma(_6774, f16vec2(Weights.w1[820u], Weights.w1[821u]), fma(_6757, f16vec2(Weights.w1[804u], Weights.w1[805u]), _6746))))))))));
    f16vec2 _6918 = fma(_6910, f16vec2(Weights.w1[950u], Weights.w1[951u]), fma(_6893, f16vec2(Weights.w1[934u], Weights.w1[935u]), fma(_6876, f16vec2(Weights.w1[918u], Weights.w1[919u]), fma(_6859, f16vec2(Weights.w1[902u], Weights.w1[903u]), fma(_6842, f16vec2(Weights.w1[886u], Weights.w1[887u]), fma(_6825, f16vec2(Weights.w1[870u], Weights.w1[871u]), fma(_6808, f16vec2(Weights.w1[854u], Weights.w1[855u]), fma(_6791, f16vec2(Weights.w1[838u], Weights.w1[839u]), fma(_6774, f16vec2(Weights.w1[822u], Weights.w1[823u]), fma(_6757, f16vec2(Weights.w1[806u], Weights.w1[807u]), _6748))))))))));
    f16vec2 _6920 = fma(_6910, f16vec2(Weights.w1[952u], Weights.w1[953u]), fma(_6893, f16vec2(Weights.w1[936u], Weights.w1[937u]), fma(_6876, f16vec2(Weights.w1[920u], Weights.w1[921u]), fma(_6859, f16vec2(Weights.w1[904u], Weights.w1[905u]), fma(_6842, f16vec2(Weights.w1[888u], Weights.w1[889u]), fma(_6825, f16vec2(Weights.w1[872u], Weights.w1[873u]), fma(_6808, f16vec2(Weights.w1[856u], Weights.w1[857u]), fma(_6791, f16vec2(Weights.w1[840u], Weights.w1[841u]), fma(_6774, f16vec2(Weights.w1[824u], Weights.w1[825u]), fma(_6757, f16vec2(Weights.w1[808u], Weights.w1[809u]), _6750))))))))));
    f16vec2 _6922 = fma(_6910, f16vec2(Weights.w1[954u], Weights.w1[955u]), fma(_6893, f16vec2(Weights.w1[938u], Weights.w1[939u]), fma(_6876, f16vec2(Weights.w1[922u], Weights.w1[923u]), fma(_6859, f16vec2(Weights.w1[906u], Weights.w1[907u]), fma(_6842, f16vec2(Weights.w1[890u], Weights.w1[891u]), fma(_6825, f16vec2(Weights.w1[874u], Weights.w1[875u]), fma(_6808, f16vec2(Weights.w1[858u], Weights.w1[859u]), fma(_6791, f16vec2(Weights.w1[842u], Weights.w1[843u]), fma(_6774, f16vec2(Weights.w1[826u], Weights.w1[827u]), fma(_6757, f16vec2(Weights.w1[810u], Weights.w1[811u]), _6752))))))))));
    f16vec2 _6924 = fma(_6910, f16vec2(Weights.w1[956u], Weights.w1[957u]), fma(_6893, f16vec2(Weights.w1[940u], Weights.w1[941u]), fma(_6876, f16vec2(Weights.w1[924u], Weights.w1[925u]), fma(_6859, f16vec2(Weights.w1[908u], Weights.w1[909u]), fma(_6842, f16vec2(Weights.w1[892u], Weights.w1[893u]), fma(_6825, f16vec2(Weights.w1[876u], Weights.w1[877u]), fma(_6808, f16vec2(Weights.w1[860u], Weights.w1[861u]), fma(_6791, f16vec2(Weights.w1[844u], Weights.w1[845u]), fma(_6774, f16vec2(Weights.w1[828u], Weights.w1[829u]), fma(_6757, f16vec2(Weights.w1[812u], Weights.w1[813u]), _6754))))))))));
    f16vec2 _6926 = fma(_6910, f16vec2(Weights.w1[958u], Weights.w1[959u]), fma(_6893, f16vec2(Weights.w1[942u], Weights.w1[943u]), fma(_6876, f16vec2(Weights.w1[926u], Weights.w1[927u]), fma(_6859, f16vec2(Weights.w1[910u], Weights.w1[911u]), fma(_6842, f16vec2(Weights.w1[894u], Weights.w1[895u]), fma(_6825, f16vec2(Weights.w1[878u], Weights.w1[879u]), fma(_6808, f16vec2(Weights.w1[862u], Weights.w1[863u]), fma(_6791, f16vec2(Weights.w1[846u], Weights.w1[847u]), fma(_6774, f16vec2(Weights.w1[830u], Weights.w1[831u]), fma(_6757, f16vec2(Weights.w1[814u], Weights.w1[815u]), _6756))))))))));
    f16vec2 _6927 = f16vec2(_3304[30].x);
    f16vec2 _6944 = f16vec2(_3304[30].y);
    f16vec2 _6961 = f16vec2(_3304[31].x);
    f16vec2 _6978 = f16vec2(_3304[31].y);
    return f16vec2[](fma(_6978, f16vec2(Weights.w1[1008u], Weights.w1[1009u]), fma(_6961, f16vec2(Weights.w1[992u], Weights.w1[993u]), fma(_6944, f16vec2(Weights.w1[976u], Weights.w1[977u]), fma(_6927, f16vec2(Weights.w1[960u], Weights.w1[961u]), _6912)))), fma(_6978, f16vec2(Weights.w1[1010u], Weights.w1[1011u]), fma(_6961, f16vec2(Weights.w1[994u], Weights.w1[995u]), fma(_6944, f16vec2(Weights.w1[978u], Weights.w1[979u]), fma(_6927, f16vec2(Weights.w1[962u], Weights.w1[963u]), _6914)))), fma(_6978, f16vec2(Weights.w1[1012u], Weights.w1[1013u]), fma(_6961, f16vec2(Weights.w1[996u], Weights.w1[997u]), fma(_6944, f16vec2(Weights.w1[980u], Weights.w1[981u]), fma(_6927, f16vec2(Weights.w1[964u], Weights.w1[965u]), _6916)))), fma(_6978, f16vec2(Weights.w1[1014u], Weights.w1[1015u]), fma(_6961, f16vec2(Weights.w1[998u], Weights.w1[999u]), fma(_6944, f16vec2(Weights.w1[982u], Weights.w1[983u]), fma(_6927, f16vec2(Weights.w1[966u], Weights.w1[967u]), _6918)))), fma(_6978, f16vec2(Weights.w1[1016u], Weights.w1[1017u]), fma(_6961, f16vec2(Weights.w1[1000u], Weights.w1[1001u]), fma(_6944, f16vec2(Weights.w1[984u], Weights.w1[985u]), fma(_6927, f16vec2(Weights.w1[968u], Weights.w1[969u]), _6920)))), fma(_6978, f16vec2(Weights.w1[1018u], Weights.w1[1019u]), fma(_6961, f16vec2(Weights.w1[1002u], Weights.w1[1003u]), fma(_6944, f16vec2(Weights.w1[986u], Weights.w1[987u]), fma(_6927, f16vec2(Weights.w1[970u], Weights.w1[971u]), _6922)))), fma(_6978, f16vec2(Weights.w1[1020u], Weights.w1[1021u]), fma(_6961, f16vec2(Weights.w1[1004u], Weights.w1[1005u]), fma(_6944, f16vec2(Weights.w1[988u], Weights.w1[989u]), fma(_6927, f16vec2(Weights.w1[972u], Weights.w1[973u]), _6924)))), fma(_6978, f16vec2(Weights.w1[1022u], Weights.w1[1023u]), fma(_6961, f16vec2(Weights.w1[1006u], Weights.w1[1007u]), fma(_6944, f16vec2(Weights.w1[990u], Weights.w1[991u]), fma(_6927, f16vec2(Weights.w1[974u], Weights.w1[975u]), _6926)))));
}

PostprocessStage2 evaluatePostprocessStage1(PostprocessStage1 inputValue, PostprocessNetworkContext context)
{
    f16vec2 _300[8] = _3303(inputValue.value);
    f16vec2 tempArg[8] = _300;
    PostprocessStage2 outputValue;
    outputValue.value = _300;
    f16vec2 _7642[8] = outputValue.value;
    uint _7641 = 0u;
    f16vec2 _7640[8];
    uint _7648;
    for (;;)
    {
        _7648 = _7641;
        if (_7648 < 8u)
        {
            _7640[_7648] = max(_7642[_7648], _306[_7648]);
            _7641 = _7648 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    outputValue.value = _7640;
    outputValue.provenance = uvec4(2u, context.selectedRoute, 16u, 1u);
    return outputValue;
}

PostprocessActivationHistory buildPostprocessHistory(PostprocessStage2 activation, PostprocessNetworkContext context)
{
    PostprocessActivationHistory history;
    history.selectedFrame = context.selectedRoute;
    for (uint frameIndex = 0u; frameIndex < 2u; frameIndex++)
    {
        history.frames[frameIndex].activation = activation;
        history.frames[frameIndex].state = uvec4(frameIndex, context.selectedRoute, 2u, 1u);
    }
    return history;
}

bool validatePostprocessFrame(PostprocessHistoryFrame frame, PostprocessNetworkContext context)
{
    bool resident = frame.state.w != 0u;
    bool stageMatches = frame.state.z == 2u;
    bool routeKnown = frame.state.y == context.selectedRoute;
    return (resident && stageMatches) && routeKnown;
}

PostprocessStage2 resolvePostprocessHistory(PostprocessActivationHistory history, PostprocessNetworkContext context)
{
    uint selectedFrame = history.selectedFrame & 1u;
    PostprocessHistoryFrame selected;
    switch (selectedFrame)
    {
        case 0u:
        {
            selected = history.frames[0];
            break;
        }
        case 1u:
        {
            selected = history.frames[1];
            break;
        }
        default:
        {
            selected = history.frames[0];
            break;
        }
    }
    PostprocessHistoryFrame param = selected;
    PostprocessNetworkContext param_1 = context;
    if (validatePostprocessFrame(param, param_1))
    {
        return selected.activation;
    }
    return history.frames[0].activation;
}

PostprocessStage2 routePostprocessActivation(PostprocessStage2 activation, PostprocessNetworkContext context)
{
    PostprocessStage2 param = activation;
    PostprocessNetworkContext param_1 = context;
    PostprocessActivationHistory _478 = buildPostprocessHistory(param, param_1);
    PostprocessActivationHistory history = _478;
    PostprocessActivationHistory param_2 = _478;
    PostprocessNetworkContext param_3 = context;
    return resolvePostprocessHistory(param_2, param_3);
}

f16vec2[4] _6997(f16vec2 _6998[8])
{
    f16vec2 _7310 = f16vec2(_6998[0].x);
    f16vec2 _7319 = f16vec2(_6998[0].y);
    f16vec2 _7328 = f16vec2(_6998[1].x);
    f16vec2 _7337 = f16vec2(_6998[1].y);
    f16vec2 _7346 = f16vec2(_6998[2].x);
    f16vec2 _7355 = f16vec2(_6998[2].y);
    f16vec2 _7364 = f16vec2(_6998[3].x);
    f16vec2 _7373 = f16vec2(_6998[3].y);
    f16vec2 _7382 = f16vec2(_6998[4].x);
    f16vec2 _7391 = f16vec2(_6998[4].y);
    f16vec2 _7393 = fma(_7391, f16vec2(Weights.w2[72u], Weights.w2[73u]), fma(_7382, f16vec2(Weights.w2[64u], Weights.w2[65u]), fma(_7373, f16vec2(Weights.w2[56u], Weights.w2[57u]), fma(_7364, f16vec2(Weights.w2[48u], Weights.w2[49u]), fma(_7355, f16vec2(Weights.w2[40u], Weights.w2[41u]), fma(_7346, f16vec2(Weights.w2[32u], Weights.w2[33u]), fma(_7337, f16vec2(Weights.w2[24u], Weights.w2[25u]), fma(_7328, f16vec2(Weights.w2[16u], Weights.w2[17u]), fma(_7319, f16vec2(Weights.w2[8u], Weights.w2[9u]), fma(_7310, f16vec2(Weights.w2[0u], Weights.w2[1u]), f16vec2(Biases.b2[0u], Biases.b2[1u])))))))))));
    f16vec2 _7395 = fma(_7391, f16vec2(Weights.w2[74u], Weights.w2[75u]), fma(_7382, f16vec2(Weights.w2[66u], Weights.w2[67u]), fma(_7373, f16vec2(Weights.w2[58u], Weights.w2[59u]), fma(_7364, f16vec2(Weights.w2[50u], Weights.w2[51u]), fma(_7355, f16vec2(Weights.w2[42u], Weights.w2[43u]), fma(_7346, f16vec2(Weights.w2[34u], Weights.w2[35u]), fma(_7337, f16vec2(Weights.w2[26u], Weights.w2[27u]), fma(_7328, f16vec2(Weights.w2[18u], Weights.w2[19u]), fma(_7319, f16vec2(Weights.w2[10u], Weights.w2[11u]), fma(_7310, f16vec2(Weights.w2[2u], Weights.w2[3u]), f16vec2(Biases.b2[2u], Biases.b2[3u])))))))))));
    f16vec2 _7397 = fma(_7391, f16vec2(Weights.w2[76u], Weights.w2[77u]), fma(_7382, f16vec2(Weights.w2[68u], Weights.w2[69u]), fma(_7373, f16vec2(Weights.w2[60u], Weights.w2[61u]), fma(_7364, f16vec2(Weights.w2[52u], Weights.w2[53u]), fma(_7355, f16vec2(Weights.w2[44u], Weights.w2[45u]), fma(_7346, f16vec2(Weights.w2[36u], Weights.w2[37u]), fma(_7337, f16vec2(Weights.w2[28u], Weights.w2[29u]), fma(_7328, f16vec2(Weights.w2[20u], Weights.w2[21u]), fma(_7319, f16vec2(Weights.w2[12u], Weights.w2[13u]), fma(_7310, f16vec2(Weights.w2[4u], Weights.w2[5u]), f16vec2(Biases.b2[4u], Biases.b2[5u])))))))))));
    f16vec2 _7399 = fma(_7391, f16vec2(Weights.w2[78u], Weights.w2[79u]), fma(_7382, f16vec2(Weights.w2[70u], Weights.w2[71u]), fma(_7373, f16vec2(Weights.w2[62u], Weights.w2[63u]), fma(_7364, f16vec2(Weights.w2[54u], Weights.w2[55u]), fma(_7355, f16vec2(Weights.w2[46u], Weights.w2[47u]), fma(_7346, f16vec2(Weights.w2[38u], Weights.w2[39u]), fma(_7337, f16vec2(Weights.w2[30u], Weights.w2[31u]), fma(_7328, f16vec2(Weights.w2[22u], Weights.w2[23u]), fma(_7319, f16vec2(Weights.w2[14u], Weights.w2[15u]), fma(_7310, f16vec2(Weights.w2[6u], Weights.w2[7u]), f16vec2(Biases.b2[6u], Biases.b2[7u])))))))))));
    f16vec2 _7400 = f16vec2(_6998[5].x);
    f16vec2 _7409 = f16vec2(_6998[5].y);
    f16vec2 _7418 = f16vec2(_6998[6].x);
    f16vec2 _7427 = f16vec2(_6998[6].y);
    f16vec2 _7436 = f16vec2(_6998[7].x);
    f16vec2 _7445 = f16vec2(_6998[7].y);
    return f16vec2[](fma(_7445, f16vec2(Weights.w2[120u], Weights.w2[121u]), fma(_7436, f16vec2(Weights.w2[112u], Weights.w2[113u]), fma(_7427, f16vec2(Weights.w2[104u], Weights.w2[105u]), fma(_7418, f16vec2(Weights.w2[96u], Weights.w2[97u]), fma(_7409, f16vec2(Weights.w2[88u], Weights.w2[89u]), fma(_7400, f16vec2(Weights.w2[80u], Weights.w2[81u]), _7393)))))), fma(_7445, f16vec2(Weights.w2[122u], Weights.w2[123u]), fma(_7436, f16vec2(Weights.w2[114u], Weights.w2[115u]), fma(_7427, f16vec2(Weights.w2[106u], Weights.w2[107u]), fma(_7418, f16vec2(Weights.w2[98u], Weights.w2[99u]), fma(_7409, f16vec2(Weights.w2[90u], Weights.w2[91u]), fma(_7400, f16vec2(Weights.w2[82u], Weights.w2[83u]), _7395)))))), fma(_7445, f16vec2(Weights.w2[124u], Weights.w2[125u]), fma(_7436, f16vec2(Weights.w2[116u], Weights.w2[117u]), fma(_7427, f16vec2(Weights.w2[108u], Weights.w2[109u]), fma(_7418, f16vec2(Weights.w2[100u], Weights.w2[101u]), fma(_7409, f16vec2(Weights.w2[92u], Weights.w2[93u]), fma(_7400, f16vec2(Weights.w2[84u], Weights.w2[85u]), _7397)))))), fma(_7445, f16vec2(Weights.w2[126u], Weights.w2[127u]), fma(_7436, f16vec2(Weights.w2[118u], Weights.w2[119u]), fma(_7427, f16vec2(Weights.w2[110u], Weights.w2[111u]), fma(_7418, f16vec2(Weights.w2[102u], Weights.w2[103u]), fma(_7409, f16vec2(Weights.w2[94u], Weights.w2[95u]), fma(_7400, f16vec2(Weights.w2[86u], Weights.w2[87u]), _7399)))))));
}

PostprocessStage3 evaluatePostprocessStage2(PostprocessStage2 inputValue, PostprocessNetworkContext context)
{
    f16vec2 _338[4] = _6997(inputValue.value);
    f16vec2 tempArg[4] = _338;
    PostprocessStage3 outputValue;
    outputValue.value = _338;
    f16vec2 _7660[4] = outputValue.value;
    uint _7659 = 0u;
    f16vec2 _7658[4];
    uint _7666;
    for (;;)
    {
        _7666 = _7659;
        if (_7666 < 4u)
        {
            _7658[_7666] = max(_7660[_7666], _344[_7666]);
            _7659 = _7666 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    outputValue.value = _7658;
    outputValue.provenance = uvec4(3u, context.selectedRoute, 8u, 1u);
    return outputValue;
}

f16vec2[2] _7456(f16vec2 _7457[4])
{
    f16vec2 _7551 = f16vec2(_7457[0].x);
    f16vec2 _7556 = f16vec2(_7457[0].y);
    f16vec2 _7561 = f16vec2(_7457[1].x);
    f16vec2 _7566 = f16vec2(_7457[1].y);
    f16vec2 _7571 = f16vec2(_7457[2].x);
    f16vec2 _7576 = f16vec2(_7457[2].y);
    f16vec2 _7581 = f16vec2(_7457[3].x);
    f16vec2 _7586 = f16vec2(_7457[3].y);
    return f16vec2[](fma(_7586, f16vec2(Weights.w3[28u], Weights.w3[29u]), fma(_7581, f16vec2(Weights.w3[24u], Weights.w3[25u]), fma(_7576, f16vec2(Weights.w3[20u], Weights.w3[21u]), fma(_7571, f16vec2(Weights.w3[16u], Weights.w3[17u]), fma(_7566, f16vec2(Weights.w3[12u], Weights.w3[13u]), fma(_7561, f16vec2(Weights.w3[8u], Weights.w3[9u]), fma(_7556, f16vec2(Weights.w3[4u], Weights.w3[5u]), fma(_7551, f16vec2(Weights.w3[0u], Weights.w3[1u]), f16vec2(Biases.b3[0u], Biases.b3[1u]))))))))), fma(_7586, f16vec2(Weights.w3[30u], Weights.w3[31u]), fma(_7581, f16vec2(Weights.w3[26u], Weights.w3[27u]), fma(_7576, f16vec2(Weights.w3[22u], Weights.w3[23u]), fma(_7571, f16vec2(Weights.w3[18u], Weights.w3[19u]), fma(_7566, f16vec2(Weights.w3[14u], Weights.w3[15u]), fma(_7561, f16vec2(Weights.w3[10u], Weights.w3[11u]), fma(_7556, f16vec2(Weights.w3[6u], Weights.w3[7u]), fma(_7551, f16vec2(Weights.w3[2u], Weights.w3[3u]), f16vec2(Biases.b3[2u], Biases.b3[3u]))))))))));
}

PostprocessStage4 evaluatePostprocessStage3(PostprocessStage3 inputValue, PostprocessNetworkContext context)
{
    f16vec2 _376[2] = _7456(inputValue.value);
    f16vec2 tempArg[2] = _376;
    PostprocessStage4 outputValue;
    outputValue.value = _376;
    f16vec2 _7678[2] = outputValue.value;
    uint _7677 = 0u;
    f16vec2 _7676[2];
    uint _7684;
    for (;;)
    {
        _7684 = _7677;
        if (_7684 < 2u)
        {
            _7676[_7684] = max(_7678[_7684], _382[_7684]);
            _7677 = _7684 + 1u;
            continue;
        }
        else
        {
            break;
        }
    }
    outputValue.value = _7676;
    outputValue.provenance = uvec4(4u, context.selectedRoute, 4u, 1u);
    return outputValue;
}

void _7694(uint _7695, f16vec2 _7696)
{
    OutY.values[_7695] = _7696.x;
    OutY.values[_7695 + 1u] = _7696.y;
}

void storePostprocessOutput(PostprocessStage4 outputValue)
{
    f16vec2 _7704[2] = outputValue.value;
    uint _7705 = 0u;
    uint _7710;
    for (;;)
    {
        _7710 = _7705;
        if (_7710 < 4u)
        {
            _7694(0u + _7710, _7704[_7710 / 2u]);
            _7705 = _7710 + 2u;
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
    PostprocessNetworkContext context = buildPostprocessContext();
    PostprocessNetworkContext param = context;
    if (!validatePostprocessContext(param))
    {
        context.enabled = true;
    }
    PostprocessNetworkContext param_1 = context;
    PostprocessStage0 _506 = loadPostprocessInput(param_1);
    PostprocessStage0 stage0 = _506;
    PostprocessStage0 param_2 = _506;
    PostprocessNetworkContext param_3 = context;
    PostprocessStage1 _512 = evaluatePostprocessStage0(param_2, param_3);
    PostprocessStage1 stage1 = _512;
    PostprocessStage1 param_4 = _512;
    PostprocessNetworkContext param_5 = context;
    PostprocessStage2 _518 = evaluatePostprocessStage1(param_4, param_5);
    PostprocessStage2 stage2 = _518;
    PostprocessStage2 param_6 = _518;
    PostprocessNetworkContext param_7 = context;
    PostprocessStage2 _523 = routePostprocessActivation(param_6, param_7);
    stage2 = _523;
    PostprocessStage2 param_8 = _523;
    PostprocessNetworkContext param_9 = context;
    PostprocessStage3 _529 = evaluatePostprocessStage2(param_8, param_9);
    PostprocessStage3 stage3 = _529;
    PostprocessStage3 param_10 = _529;
    PostprocessNetworkContext param_11 = context;
    PostprocessStage4 _535 = evaluatePostprocessStage3(param_10, param_11);
    PostprocessStage4 stage4 = _535;
    PostprocessStage4 param_12 = _535;
    storePostprocessOutput(param_12);
}

