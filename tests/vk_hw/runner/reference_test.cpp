// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#include "reference.h"

#include <cmath>
#include <cstring>
#include <iostream>
#include <string>
#include <vector>

namespace {

bool ExpectVector(const std::string& name, const std::vector<float>& actual, const std::vector<float>& expected)
{
    if (actual.size() != expected.size()) {
        std::cerr << name << ": size mismatch: " << actual.size() << " != " << expected.size() << "\n";
        return false;
    }
    for (size_t i = 0; i < actual.size(); ++i) {
        if (actual[i] != expected[i]) {
            std::cerr << name << ": value[" << i << "] mismatch: " << actual[i] << " != " << expected[i] << "\n";
            return false;
        }
    }
    return true;
}

bool TestRowAddBroadcast()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kReduce;
    config.dtype = vk_hw::DType::kF32;
    config.reduce_axis = vk_hw::ReduceAxis::kRow;
    config.reduce_op = vk_hw::ReduceOp::kAdd;
    config.m = 2;
    config.n = 3;
    return ExpectVector("row add", vk_hw::ReferenceOutput(config, {1, 2, 3, 4, 5, 6}, {}, {}), {6, 6, 6, 15, 15, 15});
}

bool TestColumnMinBroadcast()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kReduce;
    config.dtype = vk_hw::DType::kF32;
    config.reduce_axis = vk_hw::ReduceAxis::kColumn;
    config.reduce_op = vk_hw::ReduceOp::kMin;
    config.m = 3;
    config.n = 2;
    return ExpectVector("column min", vk_hw::ReferenceOutput(config, {5, 2, 3, 4, 7, 1}, {}, {}), {3, 1, 3, 1, 3, 1});
}

bool TestF16QuantizesEveryFoldStep()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kReduce;
    config.dtype = vk_hw::DType::kF16;
    config.reduce_axis = vk_hw::ReduceAxis::kRow;
    config.reduce_op = vk_hw::ReduceOp::kAdd;
    config.m = 1;
    config.n = 3;

    const std::vector<float> input = {-2.0f, -1.9091796875f, -1.642578125f};
    const float step_quantized = vk_hw::HalfBitsToFloat(
        vk_hw::FloatToHalfBits(vk_hw::HalfBitsToFloat(vk_hw::FloatToHalfBits(input[0] + input[1])) + input[2]));
    const float end_quantized = vk_hw::HalfBitsToFloat(vk_hw::FloatToHalfBits(input[0] + input[1] + input[2]));
    if (step_quantized == end_quantized) {
        std::cerr << "f16 test data does not distinguish per-step quantization\n";
        return false;
    }
    return ExpectVector("f16 fold", vk_hw::ReferenceOutput(config, input, {}, {}),
                        {step_quantized, step_quantized, step_quantized});
}

bool TestF16UsesRoundToNearestEven()
{
    const bool even_down = vk_hw::FloatToHalfBits(1.00048828125f) == 0x3c00u;
    const bool even_up = vk_hw::FloatToHalfBits(1.00146484375f) == 0x3c02u;
    if (!even_down || !even_up)
        std::cerr << "f16 conversion does not use round-to-nearest-even\n";
    return even_down && even_up;
}

bool TestF16FiniteRoundTrip()
{
    for (uint32_t bits = 0; bits <= 0xffffu; ++bits) {
        const uint16_t half = static_cast<uint16_t>(bits);
        const bool is_nan = (half & 0x7c00u) == 0x7c00u && (half & 0x03ffu) != 0;
        if (is_nan)
            continue;
        if (vk_hw::FloatToHalfBits(vk_hw::HalfBitsToFloat(half)) != half) {
            std::cerr << "f16 round-trip mismatch for bits " << bits << "\n";
            return false;
        }
    }
    return true;
}

uint64_t FloatRaw(float value)
{
    uint32_t raw = 0;
    std::memcpy(&raw, &value, sizeof(raw));
    return raw;
}

bool TestArbitraryDepthMlpReference()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kMlp;
    config.dtype = vk_hw::DType::kF32;
    config.a_dtype = vk_hw::DType::kF32;
    config.b_dtype = vk_hw::DType::kF32;
    config.accum_dtype = vk_hw::DType::kF32;
    config.layer_dims = {2, 2, 1, 2, 2, 1};

    const std::vector<float> input = {1, 2};
    const std::vector<float> weights = {
        1,  -1, 0.5f, 1, // 2 -> 2
        2,  -3,          // 2 -> 1
        -2, 4,           // 1 -> 2
        1,  0,  0,    1, // 2 -> 2
        5,  2,           // 2 -> 1
    };
    const std::vector<float> biases = {0, 0, 0, 1, -1, 1, -1, -1};

    const bool counts_match = vk_hw::ElementCountA(config) == 2 && vk_hw::ElementCountB(config) == 14 &&
                              vk_hw::ElementCountC(config) == 8 && vk_hw::ElementCountD(config) == 1 &&
                              vk_hw::FlopCount(config) == 28;
    if (!counts_match) {
        std::cerr << "arbitrary-depth mlp buffer counts or FLOPs are incorrect\n";
        return false;
    }
    if (!ExpectVector("arbitrary-depth mlp", vk_hw::ReferenceOutput(config, input, weights, biases), {8}))
        return false;

    vk_hw::RawValues raw_input;
    vk_hw::RawValues raw_weights;
    vk_hw::RawValues raw_biases;
    for (float value : input)
        raw_input.push_back(FloatRaw(value));
    for (float value : weights)
        raw_weights.push_back(FloatRaw(value));
    for (float value : biases)
        raw_biases.push_back(FloatRaw(value));
    if (vk_hw::ReferenceOutputRaw(config, raw_input, raw_weights, raw_biases) != vk_hw::RawValues{FloatRaw(8.0f)}) {
        std::cerr << "arbitrary-depth typed mlp reference is incorrect\n";
        return false;
    }
    return true;
}

bool TestAllTypedBufferRoundTrips()
{
    const vk_hw::DType types[] = {
        vk_hw::DType::kF16, vk_hw::DType::kF32, vk_hw::DType::kI8,  vk_hw::DType::kU8,
        vk_hw::DType::kI16, vk_hw::DType::kU16, vk_hw::DType::kI32, vk_hw::DType::kU32,
    };
    for (vk_hw::DType dtype : types) {
        const vk_hw::RawValues input = vk_hw::MakeRawInput(37, 9, dtype);
        const vk_hw::RawValues output = vk_hw::DecodeRawBuffer(vk_hw::EncodeRawBuffer(input, dtype), dtype);
        if (input != output) {
            std::cerr << "typed codec round-trip failed for " << vk_hw::DTypeName(dtype) << "\n";
            return false;
        }
    }
    return true;
}

bool TestNeuralMlpParameterPacking()
{
    vk_hw::RawValues weights(10 * 64 + 64 * 16, 0);
    vk_hw::RawValues biases(64 + 16, 0);
    weights[0] = 0x3c00u;
    weights[639] = 0x4000u;
    weights[640] = 0x4200u;
    weights.back() = 0x4400u;
    biases[0] = 0x4500u;
    biases[63] = 0x4600u;
    biases[64] = 0x4700u;
    biases.back() = 0x4800u;

    const vk_hw::RawValues packed =
        vk_hw::DecodeRawBuffer(vk_hw::EncodeNeuralMlpParameterBuffer(weights, biases), vk_hw::DType::kF16);
    const bool rejects_wrong_size = vk_hw::EncodeNeuralMlpParameterBuffer({0}, {0}).empty();
    return rejects_wrong_size && packed.size() == 3600 && packed[15] == 0 && packed[16] == weights[0] &&
           packed[655] == weights[639] && packed[656] == weights[640] && packed[1679] == weights.back() &&
           packed[1680] == 0 && packed[3455] == 0 && packed[3456] == biases[0] && packed[3519] == biases[63] &&
           packed[3520] == 0 && packed[3583] == 0 && packed[3584] == biases[64] && packed[3599] == biases.back();
}

bool TestMixedSignedUnsignedIntegerMatmul()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kMatmul;
    config.a_dtype = vk_hw::DType::kI8;
    config.b_dtype = vk_hw::DType::kU8;
    config.c_dtype = vk_hw::DType::kI32;
    config.accum_dtype = vk_hw::DType::kI32;
    config.m = config.n = config.k = 1;
    const vk_hw::RawValues output = vk_hw::ReferenceOutputRaw(config, {0xffu}, {2u}, {3u});
    if (output != vk_hw::RawValues{1u}) {
        std::cerr << "mixed i8/u8 to i32 conversion is incorrect\n";
        return false;
    }

    return true;
}

bool TestIntegerMatmulWrapsAt32Bits()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kMatmul;
    config.a_dtype = vk_hw::DType::kI32;
    config.b_dtype = vk_hw::DType::kI32;
    config.c_dtype = vk_hw::DType::kI32;
    config.accum_dtype = vk_hw::DType::kI32;
    config.m = config.n = config.k = 1;
    const vk_hw::RawValues output = vk_hw::ReferenceOutputRaw(config, {0x7fffffffu}, {2u}, {3u});
    return output == vk_hw::RawValues{1u};
}

bool TestMixedFloatUsesAccumulatorFma()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kMatmul;
    config.a_dtype = vk_hw::DType::kF16;
    config.b_dtype = vk_hw::DType::kF32;
    config.c_dtype = vk_hw::DType::kF32;
    config.accum_dtype = vk_hw::DType::kF32;
    config.m = config.n = config.k = 1;
    const uint16_t a = vk_hw::FloatToHalfBits(1.25f);
    const uint64_t b = FloatRaw(0.75f);
    const uint64_t c = FloatRaw(-0.5f);
    const vk_hw::RawValues output = vk_hw::ReferenceOutputRaw(config, {a}, {b}, {c});
    return output == vk_hw::RawValues{FloatRaw(std::fma(1.25f, 0.75f, -0.5f))};
}

bool TestConvertedF16BiasUsesAccumulatorType()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kVecMatmulAdd;
    config.a_dtype = vk_hw::DType::kF16;
    config.b_dtype = vk_hw::DType::kF16;
    config.c_dtype = vk_hw::DType::kF16;
    config.accum_dtype = vk_hw::DType::kF32;
    config.m = config.n = config.k = 1;
    const uint16_t a = vk_hw::FloatToHalfBits(1.25f);
    const uint16_t b = vk_hw::FloatToHalfBits(0.75f);
    const uint16_t bias = vk_hw::FloatToHalfBits(-0.5f);
    const vk_hw::RawValues output = vk_hw::ReferenceOutputRaw(config, {a}, {b}, {bias});
    return output == vk_hw::RawValues{FloatRaw(std::fma(1.25f, 0.75f, -0.5f))};
}

bool TestMixedMlpQuantizesIntermediateActivation()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kMlp;
    config.a_dtype = vk_hw::DType::kF16;
    config.b_dtype = vk_hw::DType::kF16;
    config.c_dtype = vk_hw::DType::kF16;
    config.accum_dtype = vk_hw::DType::kF32;
    config.activation_dtype = vk_hw::DType::kF16;
    config.layer_dims = {1, 1, 1};

    const uint16_t one = vk_hw::FloatToHalfBits(1.0f);
    const uint16_t small_bias = vk_hw::FloatToHalfBits(0.0006f);
    const uint16_t zero = vk_hw::FloatToHalfBits(0.0f);
    const float first = std::fma(1.0f, 1.0f, vk_hw::HalfBitsToFloat(small_bias));
    const float rounded = vk_hw::HalfBitsToFloat(vk_hw::FloatToHalfBits(first));
    const vk_hw::RawValues rounded_output = vk_hw::ReferenceOutputRaw(config, {one}, {one, one}, {small_bias, zero});
    if (rounded_output != vk_hw::RawValues{FloatRaw(rounded)})
        return false;

    // This is a semantic sentinel for the explicit f32 -> f16 bridge. The
    // otherwise identical unrounded network must not pass f32 verification.
    config.activation_dtype = vk_hw::DType::kF32;
    const vk_hw::RawValues unrounded_output = vk_hw::ReferenceOutputRaw(config, {one}, {one, one}, {small_bias, zero});
    if (unrounded_output == rounded_output)
        return false;
    config.activation_dtype = vk_hw::DType::kF16;
    return !vk_hw::CompareOutputRaw(config, rounded_output, unrounded_output).pass;
}

bool TestIntegerReduceUsesOperandSignedness()
{
    vk_hw::CaseConfig config;
    config.kind = vk_hw::CaseKind::kReduce;
    config.reduce_axis = vk_hw::ReduceAxis::kRow;
    config.reduce_op = vk_hw::ReduceOp::kMin;
    config.m = 1;
    config.n = 2;

    config.a_dtype = config.accum_dtype = vk_hw::DType::kI8;
    if (vk_hw::ReferenceOutputRaw(config, {0x80u, 0x7fu}, {}, {}) != vk_hw::RawValues({0x80u, 0x80u}))
        return false;

    config.a_dtype = config.accum_dtype = vk_hw::DType::kU8;
    return vk_hw::ReferenceOutputRaw(config, {0x80u, 0x7fu}, {}, {}) == vk_hw::RawValues({0x7fu, 0x7fu});
}

bool TestFloatCompareDistinguishesSignedZeroAndAcceptsNaN()
{
    vk_hw::CaseConfig config;
    config.accum_dtype = vk_hw::DType::kF32;
    if (vk_hw::CompareOutputRaw(config, {FloatRaw(-0.0f)}, {FloatRaw(0.0f)}).pass)
        return false;
    return vk_hw::CompareOutputRaw(config, {FloatRaw(NAN)}, {FloatRaw(-NAN)}).pass;
}

} // namespace

int main()
{
    return TestRowAddBroadcast() && TestColumnMinBroadcast() && TestF16QuantizesEveryFoldStep() &&
                   TestF16UsesRoundToNearestEven() && TestF16FiniteRoundTrip() && TestAllTypedBufferRoundTrips() &&
                   TestNeuralMlpParameterPacking() && TestMixedSignedUnsignedIntegerMatmul() &&
                   TestIntegerMatmulWrapsAt32Bits() && TestMixedFloatUsesAccumulatorFma() &&
                   TestConvertedF16BiasUsesAccumulatorType() && TestMixedMlpQuantizesIntermediateActivation() &&
                   TestArbitraryDepthMlpReference() && TestIntegerReduceUsesOperandSignedness() &&
                   TestFloatCompareDistinguishesSignedZeroAndAcceptsNaN()
               ? 0
               : 1;
}
