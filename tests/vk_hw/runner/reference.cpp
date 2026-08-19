// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#include "reference.h"

#include <algorithm>
#include <cmath>
#include <cstring>
#include <limits>

namespace vk_hw {
namespace {

uint64_t WidthMask(uint32_t width) { return (uint64_t{1} << width) - 1u; }

uint64_t FloatBits(float value)
{
    uint32_t bits = 0;
    std::memcpy(&bits, &value, sizeof(bits));
    return bits;
}

float BitsFloat(uint64_t value)
{
    const uint32_t bits = static_cast<uint32_t>(value);
    float result = 0.0f;
    std::memcpy(&result, &bits, sizeof(result));
    return result;
}

long double RawToFloat(uint64_t raw, DType dtype)
{
    switch (dtype) {
    case DType::kF16:
        return HalfBitsToFloat(static_cast<uint16_t>(raw));
    case DType::kF32:
        return BitsFloat(raw);
    default:
        return 0.0;
    }
}

uint64_t FloatToRaw(long double value, DType dtype)
{
    switch (dtype) {
    case DType::kF16:
        return FloatToHalfBits(static_cast<float>(value));
    case DType::kF32:
        return FloatBits(static_cast<float>(value));
    default:
        return 0;
    }
}

uint64_t ConvertInteger(uint64_t raw, DType source, DType destination)
{
    const uint32_t source_width = ElementBitWidth(source);
    const uint32_t destination_width = ElementBitWidth(destination);
    raw &= WidthMask(source_width);
    if (IsSignedDType(source) && (raw & (uint64_t{1} << (source_width - 1u))) != 0) {
        raw |= ~WidthMask(source_width);
    }
    return raw & WidthMask(destination_width);
}

bool SignedIntegerLess(uint64_t lhs, uint64_t rhs, uint32_t width)
{
    const uint64_t sign = uint64_t{1} << (width - 1u);
    const bool lhs_negative = (lhs & sign) != 0;
    const bool rhs_negative = (rhs & sign) != 0;
    if (lhs_negative != rhs_negative)
        return lhs_negative;
    return (lhs & WidthMask(width)) < (rhs & WidthMask(width));
}

uint64_t FloatFma(uint64_t lhs, DType lhs_type, uint64_t rhs, DType rhs_type, uint64_t acc, DType accum_type)
{
    const long double lhs_value = RawToFloat(FloatToRaw(RawToFloat(lhs, lhs_type), accum_type), accum_type);
    const long double rhs_value = RawToFloat(FloatToRaw(RawToFloat(rhs, rhs_type), accum_type), accum_type);
    const long double acc_value = RawToFloat(acc, accum_type);
    switch (accum_type) {
    case DType::kF16:
        return FloatToRaw(
            std::fma(static_cast<float>(lhs_value), static_cast<float>(rhs_value), static_cast<float>(acc_value)),
            accum_type);
    case DType::kF32:
        return FloatToRaw(
            std::fma(static_cast<float>(lhs_value), static_cast<float>(rhs_value), static_cast<float>(acc_value)),
            accum_type);
    default:
        return 0;
    }
}

uint64_t IntegerMulAdd(uint64_t lhs, DType lhs_type, uint64_t rhs, DType rhs_type, uint64_t acc, DType accum_type)
{
    const uint64_t mask = WidthMask(ElementBitWidth(accum_type));
    const uint64_t lhs_value = ConvertInteger(lhs, lhs_type, accum_type);
    const uint64_t rhs_value = ConvertInteger(rhs, rhs_type, accum_type);
    // Unsigned arithmetic is defined modulo 2^N. The 64-bit host container
    // keeps multiplication of supported 32-bit values well-defined.
    return (acc + lhs_value * rhs_value) & mask;
}

uint64_t MulAdd(uint64_t lhs, DType lhs_type, uint64_t rhs, DType rhs_type, uint64_t acc, DType accum_type)
{
    return IsFloatDType(accum_type) ? FloatFma(lhs, lhs_type, rhs, rhs_type, acc, accum_type)
                                    : IntegerMulAdd(lhs, lhs_type, rhs, rhs_type, acc, accum_type);
}

uint64_t ZeroRaw(DType dtype) { return IsFloatDType(dtype) ? FloatToRaw(0.0, dtype) : 0; }

uint64_t ConvertRaw(uint64_t raw, DType source, DType destination)
{
    if (source == destination)
        return raw & WidthMask(ElementBitWidth(destination));
    if (IsFloatDType(source) && IsFloatDType(destination))
        return FloatToRaw(RawToFloat(raw, source), destination);
    if (!IsFloatDType(source) && !IsFloatDType(destination))
        return ConvertInteger(raw, source, destination);
    return 0;
}

uint64_t ReduceRawPair(uint64_t lhs, uint64_t rhs, ReduceOp op, DType dtype)
{
    if (IsFloatDType(dtype)) {
        const long double lhs_value = RawToFloat(lhs, dtype);
        const long double rhs_value = RawToFloat(rhs, dtype);
        long double result = 0.0;
        switch (op) {
        case ReduceOp::kAdd:
            result = lhs_value + rhs_value;
            break;
        case ReduceOp::kMin:
            result = std::fmin(lhs_value, rhs_value);
            break;
        case ReduceOp::kMax:
            result = std::fmax(lhs_value, rhs_value);
            break;
        }
        return FloatToRaw(result, dtype);
    }

    const uint64_t mask = WidthMask(ElementBitWidth(dtype));
    lhs &= mask;
    rhs &= mask;
    if (op == ReduceOp::kAdd)
        return (lhs + rhs) & mask;
    const bool less = IsSignedDType(dtype) ? SignedIntegerLess(lhs, rhs, ElementBitWidth(dtype)) : lhs < rhs;
    return op == ReduceOp::kMin ? (less ? lhs : rhs) : (less ? rhs : lhs);
}

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

bool HasConstBiasVariant(const CaseConfig& config)
{
    return config.shader_path.find("_constbias") != std::string::npos;
}

bool HasConstWeightVariant(const CaseConfig& config) { return config.shader_path.find("_constw") != std::string::npos; }

float ConstBiasValue(uint32_t index, DType dtype)
{
    const int signed_value = static_cast<int>(index % 7u) - 3;
    const float value = static_cast<float>(signed_value) * 0.25f;
    return QuantizeForDType(value, dtype);
}

float ConstWeightValue(uint32_t row, uint32_t col, DType dtype)
{
    // The coopmatHW scalar constructor fills all elements with the same value.
    // Using 0.5 to match the test shader matmul_f32_constw_4x4x4.comp
    (void)row;
    (void)col;
    const float value = 0.5f;
    return QuantizeForDType(value, dtype);
}

float ReducePair(float lhs, float rhs, ReduceOp op, DType dtype)
{
    float result = 0.0f;
    switch (op) {
    case ReduceOp::kAdd:
        result = lhs + rhs;
        break;
    case ReduceOp::kMin:
        result = std::fmin(lhs, rhs);
        break;
    case ReduceOp::kMax:
        result = std::fmax(lhs, rhs);
        break;
    }
    // The lowered f16 path stores every fold step in a float16_t lane. Match
    // that behavior instead of accumulating in f32 and quantizing only once.
    return QuantizeForDType(result, dtype);
}

} // namespace

uint32_t ElementBitWidth(DType dtype)
{
    switch (dtype) {
    case DType::kI8:
    case DType::kU8:
        return 8;
    case DType::kF16:
    case DType::kI16:
    case DType::kU16:
        return 16;
    case DType::kF32:
    case DType::kI32:
    case DType::kU32:
        return 32;
    }
    return 0;
}

size_t ElementSize(DType dtype) { return ElementBitWidth(dtype) / 8u; }

bool IsFloatDType(DType dtype) { return dtype == DType::kF16 || dtype == DType::kF32; }

bool IsSignedDType(DType dtype) { return dtype == DType::kI8 || dtype == DType::kI16 || dtype == DType::kI32; }

uint16_t FloatToHalfBits(float value)
{
    uint32_t bits = 0;
    std::memcpy(&bits, &value, sizeof(bits));

    const uint32_t sign = (bits >> 16) & 0x8000u;
    uint32_t mantissa = bits & 0x007fffffu;
    const uint32_t float_exponent = (bits >> 23) & 0xffu;
    int32_t exponent = static_cast<int32_t>(float_exponent) - 127 + 15;

    if (float_exponent == 0xffu) {
        return static_cast<uint16_t>(sign | (mantissa == 0 ? 0x7c00u : 0x7e00u));
    }

    if (exponent <= 0) {
        if (exponent < -10)
            return static_cast<uint16_t>(sign);
        mantissa |= 0x00800000u;
        const uint32_t shift = static_cast<uint32_t>(14 - exponent);
        uint32_t half_mantissa = mantissa >> shift;
        const uint32_t remainder = mantissa & ((1u << shift) - 1u);
        const uint32_t halfway = 1u << (shift - 1u);
        if (remainder > halfway || (remainder == halfway && (half_mantissa & 1u)))
            ++half_mantissa;
        return static_cast<uint16_t>(sign | half_mantissa);
    }

    if (exponent >= 31) {
        return static_cast<uint16_t>(sign | 0x7c00u);
    }

    uint32_t half_mantissa = mantissa >> 13;
    const uint32_t remainder = mantissa & 0x1fffu;
    if (remainder > 0x1000u || (remainder == 0x1000u && (half_mantissa & 1u))) {
        ++half_mantissa;
        if (half_mantissa == 0x400u) {
            half_mantissa = 0;
            if (++exponent >= 31)
                return static_cast<uint16_t>(sign | 0x7c00u);
        }
    }
    return static_cast<uint16_t>(sign | (static_cast<uint32_t>(exponent) << 10) | half_mantissa);
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
    case CaseKind::kMlp:
        return "mlp";
    case CaseKind::kReduce:
        return "reduce";
    }
    return "unknown";
}

std::string DTypeName(DType dtype)
{
    switch (dtype) {
    case DType::kF16:
        return "f16";
    case DType::kF32:
        return "f32";
    case DType::kI8:
        return "i8";
    case DType::kU8:
        return "u8";
    case DType::kI16:
        return "i16";
    case DType::kU16:
        return "u16";
    case DType::kI32:
        return "i32";
    case DType::kU32:
        return "u32";
    }
    return "unknown";
}

std::string ReduceAxisName(ReduceAxis axis) { return axis == ReduceAxis::kRow ? "row" : "column"; }

std::string ReduceOpName(ReduceOp op)
{
    switch (op) {
    case ReduceOp::kAdd:
        return "add";
    case ReduceOp::kMin:
        return "min";
    case ReduceOp::kMax:
        return "max";
    }
    return "unknown";
}

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
    if (config.kind == CaseKind::kMlp) {
        uint64_t work = 0;
        for (size_t i = 1; i < config.layer_dims.size(); ++i)
            work += static_cast<uint64_t>(config.layer_dims[i - 1]) * config.layer_dims[i];
        return 2ull * work;
    }
    if (config.kind == CaseKind::kReduce) {
        if (config.reduce_axis == ReduceAxis::kRow) {
            return static_cast<uint64_t>(config.m) * (config.n - 1u);
        }
        return static_cast<uint64_t>(config.n) * (config.m - 1u);
    }
    return 0;
}

RawValues MakeRawInput(size_t count, int seed, DType dtype)
{
    RawValues values(count);
    for (size_t i = 0; i < count; ++i) {
        const int signed_value = static_cast<int>((i * 17 + seed * 23) % 29) - 14;
        if (IsFloatDType(dtype)) {
            values[i] = FloatToRaw(static_cast<long double>(signed_value) / 19.0L, dtype);
        } else if (IsSignedDType(dtype)) {
            // Conversion through uint64_t is well-defined modulo 2^64.
            values[i] = static_cast<uint64_t>(static_cast<int64_t>(signed_value)) & WidthMask(ElementBitWidth(dtype));
        } else {
            values[i] = static_cast<uint64_t>(signed_value + 14) & WidthMask(ElementBitWidth(dtype));
        }
    }
    return values;
}

std::vector<uint8_t> EncodeRawBuffer(const RawValues& values, DType dtype)
{
    const size_t element_size = ElementSize(dtype);
    std::vector<uint8_t> bytes(values.size() * element_size);
    for (size_t i = 0; i < values.size(); ++i) {
        const uint64_t raw = values[i] & WidthMask(ElementBitWidth(dtype));
        std::memcpy(bytes.data() + i * element_size, &raw, element_size);
    }
    return bytes;
}

std::vector<uint8_t> EncodeNeuralMlpParameterBuffer(const RawValues& weights, const RawValues& biases)
{
    constexpr size_t kFirstWeightOffset = 16;
    constexpr size_t kFirstWeightCount = 10 * 64;
    constexpr size_t kSecondWeightOffset = 656;
    constexpr size_t kSecondWeightCount = 64 * 16;
    constexpr size_t kFirstBiasOffset = 3456;
    constexpr size_t kFirstBiasCount = 64;
    constexpr size_t kSecondBiasOffset = 3584;
    constexpr size_t kSecondBiasCount = 16;
    constexpr size_t kParameterCount = kSecondBiasOffset + kSecondBiasCount;

    if (weights.size() != kFirstWeightCount + kSecondWeightCount ||
        biases.size() != kFirstBiasCount + kSecondBiasCount) {
        return {};
    }

    RawValues packed(kParameterCount, 0);
    std::copy(weights.begin(), weights.begin() + kFirstWeightCount, packed.begin() + kFirstWeightOffset);
    std::copy(weights.begin() + kFirstWeightCount, weights.end(), packed.begin() + kSecondWeightOffset);
    std::copy(biases.begin(), biases.begin() + kFirstBiasCount, packed.begin() + kFirstBiasOffset);
    std::copy(biases.begin() + kFirstBiasCount, biases.end(), packed.begin() + kSecondBiasOffset);
    return EncodeRawBuffer(packed, DType::kF16);
}

RawValues DecodeRawBuffer(const std::vector<uint8_t>& bytes, DType dtype)
{
    const size_t element_size = ElementSize(dtype);
    const size_t count = bytes.size() / element_size;
    RawValues values(count, 0);
    for (size_t i = 0; i < count; ++i) {
        std::memcpy(&values[i], bytes.data() + i * element_size, element_size);
    }
    return values;
}

std::vector<float> MakeInput(size_t count, int seed, DType dtype)
{
    const RawValues raw = MakeRawInput(count, seed, dtype);
    std::vector<float> values(raw.size());
    for (size_t i = 0; i < raw.size(); ++i)
        values[i] = static_cast<float>(RawToFloat(raw[i], dtype));
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
    case CaseKind::kReduce:
        return static_cast<size_t>(config.m) * config.n;
    case CaseKind::kMlp:
        return config.layer_dims.empty() ? 0 : *std::max_element(config.layer_dims.begin(), config.layer_dims.end());
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
    case CaseKind::kReduce:
        return 1;
    case CaseKind::kMlp:
        size_t count = 0;
        for (size_t i = 1; i < config.layer_dims.size(); ++i)
            count += static_cast<size_t>(config.layer_dims[i - 1]) * config.layer_dims[i];
        return count;
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
    case CaseKind::kReduce:
        return 1;
    case CaseKind::kMlp:
        size_t count = 0;
        for (size_t i = 1; i < config.layer_dims.size(); ++i)
            count += config.layer_dims[i];
        return count;
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
    case CaseKind::kReduce:
        return static_cast<size_t>(config.m) * config.n;
    case CaseKind::kMlp:
        return config.layer_dims.empty() ? 0 : config.layer_dims.back();
    }
    return 0;
}

RawValues ReferenceOutputRaw(const CaseConfig& config, const RawValues& a, const RawValues& b, const RawValues& c)
{
    RawValues out(ElementCountD(config), ZeroRaw(config.accum_dtype));

    if (config.kind == CaseKind::kLoadStore) {
        for (size_t i = 0; i < out.size(); ++i)
            out[i] = ConvertRaw(a[i], config.a_dtype, config.accum_dtype);
        return out;
    }

    if (config.kind == CaseKind::kReduce) {
        if (config.reduce_axis == ReduceAxis::kRow) {
            for (uint32_t row = 0; row < config.m; ++row) {
                uint64_t reduced = ConvertRaw(a[row * config.n], config.a_dtype, config.accum_dtype);
                for (uint32_t col = 1; col < config.n; ++col) {
                    reduced =
                        ReduceRawPair(reduced, ConvertRaw(a[row * config.n + col], config.a_dtype, config.accum_dtype),
                                      config.reduce_op, config.accum_dtype);
                }
                for (uint32_t col = 0; col < config.n; ++col)
                    out[row * config.n + col] = reduced;
            }
        } else {
            for (uint32_t col = 0; col < config.n; ++col) {
                uint64_t reduced = ConvertRaw(a[col], config.a_dtype, config.accum_dtype);
                for (uint32_t row = 1; row < config.m; ++row) {
                    reduced =
                        ReduceRawPair(reduced, ConvertRaw(a[row * config.n + col], config.a_dtype, config.accum_dtype),
                                      config.reduce_op, config.accum_dtype);
                }
                for (uint32_t row = 0; row < config.m; ++row)
                    out[row * config.n + col] = reduced;
            }
        }
        return out;
    }

    auto const_weight = [&](uint32_t, uint32_t) {
        return IsFloatDType(config.b_dtype) ? FloatToRaw(0.5L, config.b_dtype)
                                            : ConvertRaw(1, DType::kU8, config.b_dtype);
    };
    auto const_bias = [&](uint32_t index) {
        const int signed_value = static_cast<int>(index % 7u) - 3;
        if (IsFloatDType(config.accum_dtype))
            return FloatToRaw(static_cast<long double>(signed_value) * 0.25L, config.accum_dtype);
        return static_cast<uint64_t>(static_cast<int64_t>(signed_value)) &
               WidthMask(ElementBitWidth(config.accum_dtype));
    };

    if (config.kind == CaseKind::kMatmul) {
        for (uint32_t row = 0; row < config.m; ++row) {
            for (uint32_t col = 0; col < config.n; ++col) {
                uint64_t acc = ConvertRaw(c[row * config.n + col], config.c_dtype, config.accum_dtype);
                for (uint32_t inner = 0; inner < config.k; ++inner) {
                    const uint64_t b_value =
                        HasConstWeightVariant(config) ? const_weight(inner, col) : b[inner * config.n + col];
                    acc = MulAdd(a[row * config.k + inner], config.a_dtype, b_value, config.b_dtype, acc,
                                 config.accum_dtype);
                }
                out[row * config.n + col] = acc;
            }
        }
        return out;
    }

    if (config.kind == CaseKind::kMultiOps) {
        for (uint32_t row = 0; row < config.m; ++row) {
            for (uint32_t col = 0; col < config.n; ++col) {
                uint64_t d0 = ConvertRaw(c[row * config.n + col], config.c_dtype, config.accum_dtype);
                for (uint32_t inner = 0; inner < config.k; ++inner) {
                    d0 = MulAdd(a[row * config.k + inner], config.a_dtype, b[inner * config.n + col], config.b_dtype,
                                d0, config.accum_dtype);
                }
                uint64_t d1 = d0;
                for (uint32_t inner = 0; inner < config.k; ++inner) {
                    d1 = MulAdd(a[row * config.k + inner], config.a_dtype, b[inner * config.n + col], config.b_dtype,
                                d1, config.accum_dtype);
                }
                out[row * config.n + col] = d1;
            }
        }
        for (uint32_t col = 0; col < config.n; ++col) {
            uint64_t vec = ZeroRaw(config.accum_dtype);
            for (uint32_t inner = 0; inner < config.k; ++inner) {
                vec = MulAdd(a[inner], config.a_dtype, b[inner * config.n + col], config.b_dtype, vec,
                             config.accum_dtype);
            }
            out[col] = ReduceRawPair(out[col], vec, ReduceOp::kAdd, config.accum_dtype);
            out[col] = ReduceRawPair(out[col], vec, ReduceOp::kAdd, config.accum_dtype);
        }
        return out;
    }

    if (config.kind == CaseKind::kMlp) {
        auto run_layer = [&](const RawValues& input, DType input_type, uint32_t input_width, uint32_t output_width,
                             size_t weight_offset, size_t bias_offset) {
            RawValues layer(output_width, ZeroRaw(config.accum_dtype));
            for (uint32_t col = 0; col < output_width; ++col) {
                uint64_t acc = ConvertRaw(c[bias_offset + col], config.c_dtype, config.accum_dtype);
                for (uint32_t inner = 0; inner < input_width; ++inner) {
                    acc = MulAdd(input[inner], input_type, b[weight_offset + inner * output_width + col],
                                 config.b_dtype, acc, config.accum_dtype);
                }
                if (IsFloatDType(config.accum_dtype) && RawToFloat(acc, config.accum_dtype) < 0.0L)
                    acc = ZeroRaw(config.accum_dtype);
                if (!IsFloatDType(config.accum_dtype) && IsSignedDType(config.accum_dtype) &&
                    (acc & (uint64_t{1} << (ElementBitWidth(config.accum_dtype) - 1u))) != 0)
                    acc = 0;
                layer[col] = acc;
            }
            return layer;
        };
        if (config.layer_dims.size() < 2)
            return out;

        RawValues activation = a;
        size_t weight_offset = 0;
        size_t bias_offset = 0;
        for (size_t layer = 0; layer + 1 < config.layer_dims.size(); ++layer) {
            const uint32_t input_width = config.layer_dims[layer];
            const uint32_t output_width = config.layer_dims[layer + 1];
            const DType input_type = layer == 0 ? config.a_dtype : config.activation_dtype;
            activation = run_layer(activation, input_type, input_width, output_width, weight_offset, bias_offset);
            if (layer + 2 < config.layer_dims.size()) {
                for (uint64_t& value : activation)
                    value = ConvertRaw(value, config.accum_dtype, config.activation_dtype);
            }
            weight_offset += static_cast<size_t>(input_width) * output_width;
            bias_offset += output_width;
        }
        return activation;
    }

    for (uint32_t col = 0; col < config.n; ++col) {
        uint64_t acc = ZeroRaw(config.accum_dtype);
        if (config.kind == CaseKind::kVecMatmulAdd)
            acc =
                HasConstBiasVariant(config) ? const_bias(col) : ConvertRaw(c[col], config.c_dtype, config.accum_dtype);
        for (uint32_t inner = 0; inner < config.k; ++inner) {
            const uint64_t weight =
                HasConstWeightVariant(config) ? const_weight(inner, col) : b[inner * config.n + col];
            acc = MulAdd(a[inner], config.a_dtype, weight, config.b_dtype, acc, config.accum_dtype);
        }
        out[col] = acc;
    }
    return out;
}

VerifyResult CompareOutputRaw(const CaseConfig& config, const RawValues& expected, const RawValues& actual)
{
    VerifyResult result;
    if (expected.size() != actual.size())
        result.pass = false;
    const size_t count = std::min(expected.size(), actual.size());
    if (!IsFloatDType(config.accum_dtype)) {
        const uint64_t mask = WidthMask(ElementBitWidth(config.accum_dtype));
        for (size_t i = 0; i < count; ++i) {
            if ((expected[i] & mask) != (actual[i] & mask)) {
                result.pass = false;
                result.max_abs_error = std::numeric_limits<double>::infinity();
                result.max_rel_error = std::numeric_limits<double>::infinity();
            }
        }
        return result;
    }

    // The output buffer stores accumulator values. Intermediate f16 rounding
    // changes the expected f32 result, but must not relax comparison of that
    // result or a missing activation bridge would be accepted silently.
    const bool use_f16_tolerance = config.accum_dtype == DType::kF16;
    const double abs_threshold = use_f16_tolerance ? 2e-2 : 1e-5;
    const double rel_threshold = use_f16_tolerance ? 2e-2 : 1e-4;
    for (size_t i = 0; i < count; ++i) {
        const long double expected_value = RawToFloat(expected[i], config.accum_dtype);
        const long double actual_value = RawToFloat(actual[i], config.accum_dtype);
        if (std::isnan(expected_value) && std::isnan(actual_value))
            continue;
        if (expected_value == 0.0L && actual_value == 0.0L) {
            const uint64_t sign = uint64_t{1} << (ElementBitWidth(config.accum_dtype) - 1u);
            if (((expected[i] ^ actual[i]) & sign) != 0)
                result.pass = false;
            continue;
        }
        if (expected_value == actual_value)
            continue;
        if (!std::isfinite(expected_value) || !std::isfinite(actual_value)) {
            result.pass = false;
            result.max_abs_error = std::numeric_limits<double>::infinity();
            result.max_rel_error = std::numeric_limits<double>::infinity();
            continue;
        }
        const long double diff = std::fabs(expected_value - actual_value);
        const long double denom = std::max(std::fabs(expected_value), 1e-18L);
        const long double rel = diff / denom;
        result.max_abs_error = std::max(result.max_abs_error, static_cast<double>(diff));
        result.max_rel_error = std::max(result.max_rel_error, static_cast<double>(rel));
        if (diff > abs_threshold && rel > rel_threshold)
            result.pass = false;
    }
    return result;
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

    if (config.kind == CaseKind::kReduce) {
        if (config.reduce_axis == ReduceAxis::kRow) {
            for (uint32_t row = 0; row < config.m; ++row) {
                float reduced = a[row * config.n];
                for (uint32_t col = 1; col < config.n; ++col) {
                    reduced = ReducePair(reduced, a[row * config.n + col], config.reduce_op, config.dtype);
                }
                for (uint32_t col = 0; col < config.n; ++col) {
                    out[row * config.n + col] = reduced;
                }
            }
        } else {
            for (uint32_t col = 0; col < config.n; ++col) {
                float reduced = a[col];
                for (uint32_t row = 1; row < config.m; ++row) {
                    reduced = ReducePair(reduced, a[row * config.n + col], config.reduce_op, config.dtype);
                }
                for (uint32_t row = 0; row < config.m; ++row) {
                    out[row * config.n + col] = reduced;
                }
            }
        }
        return out;
    }

    if (config.kind == CaseKind::kMatmul) {
        for (uint32_t row = 0; row < config.m; ++row) {
            for (uint32_t col = 0; col < config.n; ++col) {
                float acc = c[row * config.n + col];
                for (uint32_t inner = 0; inner < config.k; ++inner) {
                    const float b_value = HasConstWeightVariant(config) ? ConstWeightValue(inner, col, config.dtype)
                                                                        : b[inner * config.n + col];
                    acc += a[row * config.k + inner] * b_value;
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
                vec += a[inner] * b[inner * config.n + col];
            }
            out[col] = OutputQuantize(out[col] + vec, config.dtype);
            out[col] = OutputQuantize(out[col] + vec, config.dtype);
        }
        return out;
    }

    if (config.kind == CaseKind::kMlp) {
        auto relu_quantized = [&](float value) { return std::max(OutputQuantize(value, config.accum_dtype), 0.0f); };

        auto run_layer = [&](const std::vector<float>& input, uint32_t input_width, uint32_t output_width,
                             size_t weight_offset, size_t bias_offset) {
            std::vector<float> layer(output_width, 0.0f);
            for (uint32_t col = 0; col < output_width; ++col) {
                float acc = c[bias_offset + col];
                for (uint32_t inner = 0; inner < input_width; ++inner) {
                    acc += input[inner] * b[weight_offset + inner * output_width + col];
                }
                layer[col] = relu_quantized(acc);
            }
            return layer;
        };
        if (config.layer_dims.size() < 2)
            return out;

        std::vector<float> activation = a;
        size_t weight_offset = 0;
        size_t bias_offset = 0;
        for (size_t layer = 0; layer + 1 < config.layer_dims.size(); ++layer) {
            const uint32_t input_width = config.layer_dims[layer];
            const uint32_t output_width = config.layer_dims[layer + 1];
            activation = run_layer(activation, input_width, output_width, weight_offset, bias_offset);
            if (layer + 2 < config.layer_dims.size()) {
                for (float& value : activation)
                    value = QuantizeForDType(value, config.activation_dtype);
            }
            weight_offset += static_cast<size_t>(input_width) * output_width;
            bias_offset += output_width;
        }
        return activation;
    }

    for (uint32_t col = 0; col < config.n; ++col) {
        float acc = 0.0f;
        if (config.kind == CaseKind::kVecMatmulAdd) {
            acc = HasConstBiasVariant(config) ? ConstBiasValue(col, config.dtype) : c[col];
        }
        for (uint32_t inner = 0; inner < config.k; ++inner) {
            const float w_value =
                HasConstWeightVariant(config) ? ConstWeightValue(inner, col, config.dtype) : b[inner * config.n + col];
            acc += a[inner] * w_value;
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
        const double expected_value = static_cast<double>(expected[i]);
        const double actual_value = static_cast<double>(actual[i]);
        if (!std::isfinite(expected_value) || !std::isfinite(actual_value)) {
            result.pass = false;
            result.max_abs_error = std::numeric_limits<double>::infinity();
            result.max_rel_error = std::numeric_limits<double>::infinity();
            continue;
        }

        const double diff = std::abs(expected_value - actual_value);
        const double denom = std::max(std::abs(expected_value), 1e-12);
        const double rel = diff / denom;
        result.max_abs_error = std::max(result.max_abs_error, diff);
        result.max_rel_error = std::max(result.max_rel_error, rel);
        if (diff > abs_threshold && rel > rel_threshold)
            result.pass = false;
    }
    return result;
}

} // namespace vk_hw
