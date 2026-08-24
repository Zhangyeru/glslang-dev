// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#ifndef TESTS_VK_HW_RUNNER_COMPUTE_PIPELINE_H_
#define TESTS_VK_HW_RUNNER_COMPUTE_PIPELINE_H_

#include "vulkan_context.h"

#include <vulkan/vulkan.h>

#include <array>
#include <vector>

namespace vk_hw {

class ComputePipeline {
public:
    ComputePipeline(VulkanContext* context, const std::vector<uint32_t>& code,
                    const std::vector<VkDescriptorType>& descriptor_types);
    ~ComputePipeline();

    ComputePipeline(const ComputePipeline&) = delete;
    ComputePipeline& operator=(const ComputePipeline&) = delete;

    void UpdateDescriptors(const std::vector<VkDescriptorBufferInfo>& descriptors);

    VkPipeline pipeline() const { return pipeline_; }
    VkPipelineLayout layout() const { return pipeline_layout_; }
    VkDescriptorSet descriptor_set() const { return descriptor_set_; }

private:
    VulkanContext* context_ = nullptr;
    VkShaderModule shader_module_ = VK_NULL_HANDLE;
    VkDescriptorSetLayout descriptor_set_layout_ = VK_NULL_HANDLE;
    VkPipelineLayout pipeline_layout_ = VK_NULL_HANDLE;
    VkPipeline pipeline_ = VK_NULL_HANDLE;
    VkDescriptorPool descriptor_pool_ = VK_NULL_HANDLE;
    VkDescriptorSet descriptor_set_ = VK_NULL_HANDLE;
    std::vector<VkDescriptorType> descriptor_types_;
};

} // namespace vk_hw

#endif // TESTS_VK_HW_RUNNER_COMPUTE_PIPELINE_H_
