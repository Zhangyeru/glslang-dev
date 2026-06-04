// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#ifndef TESTS_VK_AZD_RUNNER_TIMER_H_
#define TESTS_VK_AZD_RUNNER_TIMER_H_

#include <vector>

namespace vk_azd {

struct TimeStats {
    double min = 0.0;
    double avg = 0.0;
    double p50 = 0.0;
    double p90 = 0.0;
    double max = 0.0;
};

TimeStats ComputeStats(std::vector<double> samples);

} // namespace vk_azd

#endif // TESTS_VK_AZD_RUNNER_TIMER_H_
