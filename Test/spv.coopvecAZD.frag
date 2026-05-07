#version 450 core
#extension GL_KHR_memory_scope_semantics : enable
#extension GL_AZD_neural_matrix : enable
#extension GL_AZD_cooperative_vector : enable
#extension GL_EXT_shader_explicit_arithmetic_types : enable

layout(location = 0) out vec4 outColor;

coopvecAZD<float16_t, 1> foo(coopvecAZD<float16_t, 1> x) { return x; }
coopvecAZD<float16_t, 2> foo(coopvecAZD<float16_t, 2> x) { return x; }

void main()
{
    outColor = vec4(1.0);

    coopvecAZD<float, 5> v = coopvecAZD<float, 5>(0.0);

    vec3 x = vec3(1.0), y = vec3(2.0);
    coopvecAZD<float, 5> v2 = coopvecAZD<float, 5>(x, y);

    coopvecAZD<float16_t, 5> v3 = coopvecAZD<float16_t, 5>(v2);
    coopvecAZD<float, 5> v4;

    v4 = v + v2;
    v4 = v - v2;
    v4 = v * v2;
    v4 = v / v2;

    float f = 0.0;
    v4 *= f;
    v4 *= 5.0;

    int len = v4.length();
    v4[0] = f;
    v4[4] = 5.0;

    coopvecAZD<float, 20> v7;
    coopvecAZD<float, 100> v8;
    coopvecAZD<float16_t, 20> v7h;
    coopvecAZD<float, 100> v8bias;
    coopmatAZD<float16_t, 100, 20> m8;
    coopVecMatMulAZD(v8, v7h, m8);

    coopvecAZD<int8_t, 20> v9;
    coopvecAZD<int32_t, 100> v10;
    coopvecAZD<int32_t, 100> v10bias;
    coopmatAZD<int8_t, 100, 20> m10;
    coopVecMatMulAZD(v10, v9, m10);

    coopvecAZD<float16_t, 2> f162 = coopvecAZD<float16_t, 2>(v7.length());

    float16_t f16;
    coopvecAZD<float16_t, 1> f161 = coopvecAZD<float16_t, 1>(f16);

    coopvecAZD<float16_t, 7> v11, v12, v13;
    v11 = max(v11, v12);
    v11 = min(v11, v12);
    v11 = step(v11, v12);
    v11 = clamp(v11, v12, v13);
    v11 = -v11;
    v11 = exp(v11);
    v11 = log(v11);
    v11 = tanh(v11);
    v11 = atan(v11);
    v11 = fma(v11, v12, v13);

    coopvecAZD<int16_t, 7> s11, s12;
    s11 = -s11;
    s11 = ~s11;
    s11 = s11 + s12;
    s11 = s11 - s12;
    s11 = s11 * s12;
    s11 = s11 / s12;
    s11 += s12;
    s11 -= s12;
    s11 *= s12;
    s11 /= s12;

    coopvecAZD<uint16_t, 7> u11, u12, u13;
    u11 = min(u11, u12);
    u11 = max(u11, u12);
    u11 = clamp(u11, u12, u13);
    u11 = ~u11;
    u11 = u11 >> u12;
    u11 = u11 << u12;
    u11 = u11 | u12;
    u11 = u11 & u12;
    u11 = u11 ^ u12;
    u11 = u11 + u12;
    u11 = u11 - u12;
    u11 = u11 * u12;
    u11 = u11 / u12;
    u11 >>= u12;
    u11 <<= u12;
    u11 |= u12;
    u11 &= u12;
    u11 ^= u12;
    u11 += u12;
    u11 -= u12;
    u11 *= u12;
    u11 /= u12;

    s11 = s11 >> s12;
    s11 = s11 << s12;
    s11 = s11 | s12;
    s11 = s11 & s12;
    s11 = s11 ^ s12;
    s11 >>= s12;
    s11 <<= s12;
    s11 |= s12;
    s11 &= s12;
    s11 ^= s12;

    coopVecMatMulAddAZD(v8, v7h, m8, v8bias);
    coopVecMatMulAddAZD(v10, v9, m10, v10bias);

    f += (v += v)[len];
}
