// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#ifndef TESTS_VK_HW_RUNNER_REFERENCE_H_
#define TESTS_VK_HW_RUNNER_REFERENCE_H_

#include <cstdint>
#include <string>
#include <vector>

namespace vk_hw {

enum class CaseKind { kMatmul, kVecMatmul, kVecMatmulAdd, kLoadStore, kMultiOps, kMlp, kReduce };
enum class DType { kF16, kF32, kI8, kU8, kI16, kU16, kI32, kU32 };
enum class ReduceAxis { kRow, kColumn };
enum class ReduceOp { kAdd, kMin, kMax };

struct CaseConfig {
    CaseKind kind = CaseKind::kMatmul;
    // |dtype| is retained as the legacy, single-type spelling. Parsers set
    // all four explicit fields from --dtype before applying any per-input
    // overrides.
    DType dtype = DType::kF32;
    DType a_dtype = DType::kF32;
    DType b_dtype = DType::kF32;
    DType c_dtype = DType::kF32;
    DType accum_dtype = DType::kF32;
    uint32_t m = 1;
    uint32_t n = 1;
    uint32_t k = 1;
    uint32_t warmup = 20;
    uint32_t repeat = 200;
    bool verify = true;
    std::vector<uint32_t> layer_dims;
    ReduceAxis reduce_axis = ReduceAxis::kRow;
    ReduceOp reduce_op = ReduceOp::kAdd;
    std::string shader_path;
};

struct VerifyResult {
    bool pass = true;
    double max_abs_error = 0.0;
    double max_rel_error = 0.0;
};

size_t ElementSize(DType dtype);
uint32_t ElementBitWidth(DType dtype);
bool IsFloatDType(DType dtype);
bool IsSignedDType(DType dtype);
uint16_t FloatToHalfBits(float value);
float HalfBitsToFloat(uint16_t value);
std::string CaseName(CaseKind kind);
std::string DTypeName(DType dtype);
std::string ReduceAxisName(ReduceAxis axis);
std::string ReduceOpName(ReduceOp op);
uint64_t FlopCount(const CaseConfig& config);

// Typed reference values are represented by their raw scalar bit pattern. A
// 64-bit container keeps 32-bit integer products and accumulation well-defined
// in the host reference implementation.
using RawValues = std::vector<uint64_t>;

RawValues MakeRawInput(size_t count, int seed, DType dtype);
std::vector<uint8_t> EncodeRawBuffer(const RawValues& values, DType dtype);
RawValues DecodeRawBuffer(const std::vector<uint8_t>& bytes, DType dtype);
RawValues ReferenceOutputRaw(const CaseConfig& config, const RawValues& a, const RawValues& b, const RawValues& c);
VerifyResult CompareOutputRaw(const CaseConfig& config, const RawValues& expected, const RawValues& actual);

std::vector<float> MakeInput(size_t count, int seed, DType dtype);
std::vector<uint8_t> EncodeBuffer(const std::vector<float>& values, DType dtype);
std::vector<float> DecodeBuffer(const std::vector<uint8_t>& bytes, DType dtype);

size_t ElementCountA(const CaseConfig& config);
size_t ElementCountB(const CaseConfig& config);
size_t ElementCountC(const CaseConfig& config);
size_t ElementCountD(const CaseConfig& config);

std::vector<float> ReferenceOutput(const CaseConfig& config, const std::vector<float>& a, const std::vector<float>& b,
                                   const std::vector<float>& c);
VerifyResult CompareOutput(const CaseConfig& config, const std::vector<float>& expected,
                           const std::vector<float>& actual);

} // namespace vk_hw

#endif // TESTS_VK_HW_RUNNER_REFERENCE_H_
