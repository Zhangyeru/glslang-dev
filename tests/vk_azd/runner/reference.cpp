// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#include "reference.h"

#include <algorithm>
#include <cmath>
#include <cstring>
#include <limits>

namespace vk_azd {
namespace {

float QuantizeForDType(float value, DType dtype)
{
    if (dtype == DType::kF32)
        return value;
    return HalfBitsToFloat(FloatToHalfBits(value));
}

float OutputQuantize(float value, DType dtype)
{
    if (dtype == DType::kF32)
        return value;
    return HalfBitsToFloat(FloatToHalfBits(value));
}

} // namespace

size_t ElementSize(DType dtype) { return dtype == DType::kF16 ? 2 : 4; }

uint16_t FloatToHalfBits(float value)
{
    uint32_t bits = 0;
    std::memcpy(&bits, &value, sizeof(bits));

    const uint32_t sign = (bits >> 16) & 0x8000u;
    uint32_t mantissa = bits & 0x007fffffu;
    int32_t exponent = static_cast<int32_t>((bits >> 23) & 0xffu) - 127 + 15;

    if (exponent <= 0) {
        if (exponent < -10)
            return static_cast<uint16_t>(sign);
        mantissa |= 0x00800000u;
        const uint32_t shift = static_cast<uint32_t>(14 - exponent);
        uint32_t half_mantissa = mantissa >> shift;
        if ((mantissa >> (shift - 1)) & 1u)
            ++half_mantissa;
        return static_cast<uint16_t>(sign | half_mantissa);
    }

    if (exponent >= 31) {
        return static_cast<uint16_t>(sign | 0x7c00u);
    }

    uint32_t half = sign | (static_cast<uint32_t>(exponent) << 10) | (mantissa >> 13);
    if (mantissa & 0x00001000u)
        ++half;
    return static_cast<uint16_t>(half);
}

float HalfBitsToFloat(uint16_t value)
{
    const uint32_t sign = (static_cast<uint32_t>(value) & 0x8000u) << 16;
    uint32_t exponent = (static_cast<uint32_t>(value) >> 10) & 0x1fu;
    uint32_t mantissa = static_cast<uint32_t>(value) & 0x03ffu;
    uint32_t bits = 0;

    if (exponent == 0) {
        if (mantissa == 0) {
            bits = sign;
        } else {
            exponent = 127 - 15 + 1;
            while ((mantissa & 0x0400u) == 0) {
                mantissa <<= 1;
                --exponent;
            }
            mantissa &= 0x03ffu;
            bits = sign | (exponent << 23) | (mantissa << 13);
        }
    } else if (exponent == 31) {
        bits = sign | 0x7f800000u | (mantissa << 13);
    } else {
        exponent = exponent - 15 + 127;
        bits = sign | (exponent << 23) | (mantissa << 13);
    }

    float result = 0.0f;
    std::memcpy(&result, &bits, sizeof(result));
    return result;
}

std::string CaseName(CaseKind kind)
{
    switch (kind) {
    case CaseKind::kMatmul:
        return "matmul";
    case CaseKind::kVecMatmul:
        return "vecmatmul";
    case CaseKind::kVecMatmulAdd:
        return "vecmatmuladd";
    case CaseKind::kLoadStore:
        return "load_store";
    case CaseKind::kMultiOps:
        return "multiops";
    }
    return "unknown";
}

std::string DTypeName(DType dtype) { return dtype == DType::kF16 ? "f16" : "f32"; }

uint64_t FlopCount(const CaseConfig& config)
{
    if (config.kind == CaseKind::kMatmul) {
        return 2ull * config.m * config.n * config.k;
    }
    if (config.kind == CaseKind::kVecMatmul || config.kind == CaseKind::kVecMatmulAdd) {
        return 2ull * config.k * config.n;
    }
    if (config.kind == CaseKind::kMultiOps) {
        return 2ull * (2ull * config.m * config.n * config.k + 2ull * config.n * config.k);
    }
    return 0;
}

std::vector<float> MakeInput(size_t count, int seed, DType dtype)
{
    std::vector<float> values(count);
    for (size_t i = 0; i < count; ++i) {
        const int v = static_cast<int>((i * 17 + seed * 23) % 29) - 14;
        values[i] = QuantizeForDType(static_cast<float>(v) / 19.0f, dtype);
    }
    return values;
}

std::vector<uint8_t> EncodeBuffer(const std::vector<float>& values, DType dtype)
{
    std::vector<uint8_t> bytes(values.size() * ElementSize(dtype));
    if (dtype == DType::kF32) {
        std::memcpy(bytes.data(), values.data(), bytes.size());
        return bytes;
    }

    for (size_t i = 0; i < values.size(); ++i) {
        const uint16_t half = FloatToHalfBits(values[i]);
        std::memcpy(bytes.data() + i * sizeof(uint16_t), &half, sizeof(half));
    }
    return bytes;
}

std::vector<float> DecodeBuffer(const std::vector<uint8_t>& bytes, DType dtype)
{
    const size_t count = bytes.size() / ElementSize(dtype);
    std::vector<float> values(count);
    if (dtype == DType::kF32) {
        std::memcpy(values.data(), bytes.data(), count * sizeof(float));
        return values;
    }

    for (size_t i = 0; i < count; ++i) {
        uint16_t half = 0;
        std::memcpy(&half, bytes.data() + i * sizeof(uint16_t), sizeof(half));
        values[i] = HalfBitsToFloat(half);
    }
    return values;
}

size_t ElementCountA(const CaseConfig& config)
{
    switch (config.kind) {
    case CaseKind::kMatmul:
    case CaseKind::kMultiOps:
        return static_cast<size_t>(config.m) * config.k;
    case CaseKind::kVecMatmul:
    case CaseKind::kVecMatmulAdd:
        return config.k;
    case CaseKind::kLoadStore:
        return static_cast<size_t>(config.m) * config.n;
    }
    return 0;
}

size_t ElementCountB(const CaseConfig& config)
{
    switch (config.kind) {
    case CaseKind::kMatmul:
    case CaseKind::kMultiOps:
        return static_cast<size_t>(config.k) * config.n;
    case CaseKind::kVecMatmul:
    case CaseKind::kVecMatmulAdd:
        return static_cast<size_t>(config.n) * config.k;
    case CaseKind::kLoadStore:
        return 1;
    }
    return 0;
}

size_t ElementCountC(const CaseConfig& config)
{
    switch (config.kind) {
    case CaseKind::kMatmul:
    case CaseKind::kMultiOps:
        return static_cast<size_t>(config.m) * config.n;
    case CaseKind::kVecMatmulAdd:
        return config.n;
    case CaseKind::kVecMatmul:
    case CaseKind::kLoadStore:
        return 1;
    }
    return 0;
}

size_t ElementCountD(const CaseConfig& config)
{
    switch (config.kind) {
    case CaseKind::kMatmul:
    case CaseKind::kMultiOps:
        return static_cast<size_t>(config.m) * config.n;
    case CaseKind::kVecMatmul:
    case CaseKind::kVecMatmulAdd:
        return config.n;
    case CaseKind::kLoadStore:
        return static_cast<size_t>(config.m) * config.n;
    }
    return 0;
}

std::vector<float> ReferenceOutput(const CaseConfig& config, const std::vector<float>& a, const std::vector<float>& b,
                                   const std::vector<float>& c)
{
    std::vector<float> out(ElementCountD(config), 0.0f);

    if (config.kind == CaseKind::kLoadStore) {
        for (size_t i = 0; i < out.size(); ++i) {
            out[i] = OutputQuantize(a[i], config.dtype);
        }
        return out;
    }

    if (config.kind == CaseKind::kMatmul) {
        for (uint32_t row = 0; row < config.m; ++row) {
            for (uint32_t col = 0; col < config.n; ++col) {
                float acc = c[row * config.n + col];
                for (uint32_t inner = 0; inner < config.k; ++inner) {
                    acc += a[row * config.k + inner] * b[inner * config.n + col];
                }
                out[row * config.n + col] = OutputQuantize(acc, config.dtype);
            }
        }
        return out;
    }

    if (config.kind == CaseKind::kMultiOps) {
        for (uint32_t row = 0; row < config.m; ++row) {
            for (uint32_t col = 0; col < config.n; ++col) {
                float d0 = c[row * config.n + col];
                for (uint32_t inner = 0; inner < config.k; ++inner) {
                    d0 += a[row * config.k + inner] * b[inner * config.n + col];
                }
                d0 = OutputQuantize(d0, config.dtype);

                float d1 = d0;
                for (uint32_t inner = 0; inner < config.k; ++inner) {
                    d1 += a[row * config.k + inner] * b[inner * config.n + col];
                }
                out[row * config.n + col] = OutputQuantize(d1, config.dtype);
            }
        }

        for (uint32_t col = 0; col < config.n; ++col) {
            float vec = 0.0f;
            for (uint32_t inner = 0; inner < config.k; ++inner) {
                vec += a[inner] * b[col * config.k + inner];
            }
            out[col] = OutputQuantize(out[col] + vec, config.dtype);
            out[col] = OutputQuantize(out[col] + vec, config.dtype);
        }
        return out;
    }

    for (uint32_t col = 0; col < config.n; ++col) {
        float acc = config.kind == CaseKind::kVecMatmulAdd ? c[col] : 0.0f;
        for (uint32_t inner = 0; inner < config.k; ++inner) {
            acc += a[inner] * b[col * config.k + inner];
        }
        out[col] = OutputQuantize(acc, config.dtype);
    }
    return out;
}

VerifyResult CompareOutput(const CaseConfig& config, const std::vector<float>& expected,
                           const std::vector<float>& actual)
{
    const double abs_threshold = config.dtype == DType::kF16 ? 2e-2 : 1e-5;
    const double rel_threshold = config.dtype == DType::kF16 ? 2e-2 : 1e-4;

    VerifyResult result;
    const size_t count = std::min(expected.size(), actual.size());
    if (expected.size() != actual.size())
        result.pass = false;
    for (size_t i = 0; i < count; ++i) {
        const double diff = std::abs(static_cast<double>(expected[i]) - actual[i]);
        const double denom = std::max(std::abs(static_cast<double>(expected[i])), 1e-12);
        const double rel = diff / denom;
        result.max_abs_error = std::max(result.max_abs_error, diff);
        result.max_rel_error = std::max(result.max_rel_error, rel);
        if (diff > abs_threshold && rel > rel_threshold)
            result.pass = false;
    }
    return result;
}

} // namespace vk_azd
