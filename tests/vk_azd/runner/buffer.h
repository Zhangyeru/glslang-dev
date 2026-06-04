// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#ifndef TESTS_VK_AZD_RUNNER_BUFFER_H_
#define TESTS_VK_AZD_RUNNER_BUFFER_H_

#include "vulkan_context.h"

#include <vulkan/vulkan.h>

#include <cstdint>
#include <vector>

namespace vk_azd {

class Buffer {
public:
    Buffer(VulkanContext* context, VkDeviceSize size, VkBufferUsageFlags usage = VK_BUFFER_USAGE_STORAGE_BUFFER_BIT);
    ~Buffer();

    Buffer(const Buffer&) = delete;
    Buffer& operator=(const Buffer&) = delete;

    VkBuffer buffer() const { return buffer_; }
    VkDeviceSize size() const { return size_; }
    VkDescriptorBufferInfo descriptor() const;

    void Upload(const std::vector<uint8_t>& bytes);
    std::vector<uint8_t> Download(VkDeviceSize bytes) const;

private:
    uint32_t FindMemoryType(uint32_t type_bits, VkMemoryPropertyFlags properties) const;

    VulkanContext* context_ = nullptr;
    VkBuffer buffer_ = VK_NULL_HANDLE;
    VkDeviceMemory memory_ = VK_NULL_HANDLE;
    VkDeviceSize size_ = 0;
};

} // namespace vk_azd

#endif // TESTS_VK_AZD_RUNNER_BUFFER_H_
