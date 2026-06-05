// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#ifndef TESTS_VK_AZD_RUNNER_REFERENCE_H_
#define TESTS_VK_AZD_RUNNER_REFERENCE_H_

#include <cstdint>
#include <string>
#include <vector>

namespace vk_azd {

enum class CaseKind { kMatmul, kVecMatmul, kVecMatmulAdd, kLoadStore, kMultiOps };
enum class DType { kF16, kF32 };

struct CaseConfig {
    CaseKind kind = CaseKind::kMatmul;
    DType dtype = DType::kF32;
    uint32_t m = 1;
    uint32_t n = 1;
    uint32_t k = 1;
    uint32_t warmup = 20;
    uint32_t repeat = 200;
    bool verify = true;
    std::string shader_path;
};

struct VerifyResult {
    bool pass = true;
    double max_abs_error = 0.0;
    double max_rel_error = 0.0;
};

size_t ElementSize(DType dtype);
uint16_t FloatToHalfBits(float value);
float HalfBitsToFloat(uint16_t value);
std::string CaseName(CaseKind kind);
std::string DTypeName(DType dtype);
uint64_t FlopCount(const CaseConfig& config);

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

} // namespace vk_azd

#endif // TESTS_VK_AZD_RUNNER_REFERENCE_H_
