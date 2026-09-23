// Copyright (C) 2026 The Khronos Group Inc.
// SPDX-License-Identifier: BSD-3-Clause
#ifndef VK_HW_BOUNDARY_H
#define VK_HW_BOUNDARY_H
#include "boundary_cases.h"
#include "reference.h"

namespace vk_hw {
struct BoundaryData {
    RawValues a, b, c, expected, cache_expected;
    bool exact = false;
};
DType BoundaryType(const std::string& type);
BoundaryData MakeBoundaryData(const BoundaryCase& test, unsigned dataset, unsigned control);
} // namespace vk_hw
#endif
