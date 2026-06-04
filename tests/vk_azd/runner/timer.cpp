// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#include "timer.h"

#include <algorithm>
#include <numeric>

namespace vk_azd {

TimeStats ComputeStats(std::vector<double> samples)
{
    TimeStats stats;
    if (samples.empty())
        return stats;

    std::sort(samples.begin(), samples.end());
    stats.min = samples.front();
    stats.max = samples.back();
    stats.avg = std::accumulate(samples.begin(), samples.end(), 0.0) / samples.size();
    stats.p50 = samples[samples.size() / 2];
    stats.p90 = samples[static_cast<size_t>((samples.size() - 1) * 0.9)];
    return stats;
}

} // namespace vk_azd
