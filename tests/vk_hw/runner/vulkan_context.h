// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#ifndef TESTS_VK_HW_RUNNER_VULKAN_CONTEXT_H_
#define TESTS_VK_HW_RUNNER_VULKAN_CONTEXT_H_

#include <vulkan/vulkan.h>

#include <cstdint>

namespace vk_hw {

void Check(VkResult result, const char* what);

class VulkanContext {
public:
    VulkanContext();
    ~VulkanContext();

    VulkanContext(const VulkanContext&) = delete;
    VulkanContext& operator=(const VulkanContext&) = delete;

    VkInstance instance() const { return instance_; }
    VkPhysicalDevice physical_device() const { return physical_device_; }
    VkDevice device() const { return device_; }
    VkQueue queue() const { return queue_; }
    uint32_t queue_family_index() const { return queue_family_index_; }
    float timestamp_period_ns() const { return timestamp_period_ns_; }
    bool supports_shader_float16() const { return supports_shader_float16_; }
    bool supports_storage_buffer_16bit() const { return supports_storage_buffer_16bit_; }

private:
    void PickPhysicalDevice();
    void CreateDevice();

    VkInstance instance_ = VK_NULL_HANDLE;
    VkPhysicalDevice physical_device_ = VK_NULL_HANDLE;
    VkDevice device_ = VK_NULL_HANDLE;
    VkQueue queue_ = VK_NULL_HANDLE;
    uint32_t queue_family_index_ = UINT32_MAX;
    float timestamp_period_ns_ = 1.0f;
    bool supports_shader_float16_ = false;
    bool supports_storage_buffer_16bit_ = false;
};

} // namespace vk_hw

#endif // TESTS_VK_HW_RUNNER_VULKAN_CONTEXT_H_
