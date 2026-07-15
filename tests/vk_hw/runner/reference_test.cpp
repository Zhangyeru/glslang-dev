// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#include "reference.h"

#include <cmath>
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

} // namespace

int main()
{
    return TestRowAddBroadcast() && TestColumnMinBroadcast() && TestF16QuantizesEveryFoldStep() &&
                   TestF16UsesRoundToNearestEven() && TestF16FiniteRoundTrip()
               ? 0
               : 1;
}
