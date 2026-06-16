// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#include "buffer.h"

#include <algorithm>
#include <cstring>
#include <stdexcept>

namespace vk_hw {

Buffer::Buffer(VulkanContext* context, VkDeviceSize size, VkBufferUsageFlags usage)
    : context_(context), size_(std::max<VkDeviceSize>(size, 4))
{
    VkBufferCreateInfo buffer_info = {};
    buffer_info.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
    buffer_info.size = size_;
    buffer_info.usage = usage;
    buffer_info.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
    Check(vkCreateBuffer(context_->device(), &buffer_info, nullptr, &buffer_), "vkCreateBuffer");

    VkMemoryRequirements requirements = {};
    vkGetBufferMemoryRequirements(context_->device(), buffer_, &requirements);

    VkMemoryAllocateInfo alloc_info = {};
    alloc_info.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
    alloc_info.allocationSize = requirements.size;
    alloc_info.memoryTypeIndex = FindMemoryType(requirements.memoryTypeBits, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
                                                                                 VK_MEMORY_PROPERTY_HOST_COHERENT_BIT);
    Check(vkAllocateMemory(context_->device(), &alloc_info, nullptr, &memory_), "vkAllocateMemory");
    Check(vkBindBufferMemory(context_->device(), buffer_, memory_, 0), "vkBindBufferMemory");
}

Buffer::~Buffer()
{
    if (buffer_ != VK_NULL_HANDLE) {
        vkDestroyBuffer(context_->device(), buffer_, nullptr);
    }
    if (memory_ != VK_NULL_HANDLE) {
        vkFreeMemory(context_->device(), memory_, nullptr);
    }
}

VkDescriptorBufferInfo Buffer::descriptor() const
{
    VkDescriptorBufferInfo info = {};
    info.buffer = buffer_;
    info.offset = 0;
    info.range = size_;
    return info;
}

void Buffer::Upload(const std::vector<uint8_t>& bytes)
{
    if (bytes.size() > size_) {
        throw std::runtime_error("upload exceeds buffer size");
    }

    void* mapped = nullptr;
    Check(vkMapMemory(context_->device(), memory_, 0, size_, 0, &mapped), "vkMapMemory(upload)");
    std::memset(mapped, 0, static_cast<size_t>(size_));
    if (!bytes.empty()) {
        std::memcpy(mapped, bytes.data(), bytes.size());
    }
    vkUnmapMemory(context_->device(), memory_);
}

std::vector<uint8_t> Buffer::Download(VkDeviceSize bytes) const
{
    if (bytes > size_) {
        throw std::runtime_error("download exceeds buffer size");
    }

    std::vector<uint8_t> result(static_cast<size_t>(bytes));
    void* mapped = nullptr;
    Check(vkMapMemory(context_->device(), memory_, 0, size_, 0, &mapped), "vkMapMemory(download)");
    if (!result.empty()) {
        std::memcpy(result.data(), mapped, result.size());
    }
    vkUnmapMemory(context_->device(), memory_);
    return result;
}

uint32_t Buffer::FindMemoryType(uint32_t type_bits, VkMemoryPropertyFlags properties) const
{
    VkPhysicalDeviceMemoryProperties memory_properties = {};
    vkGetPhysicalDeviceMemoryProperties(context_->physical_device(), &memory_properties);
    for (uint32_t i = 0; i < memory_properties.memoryTypeCount; ++i) {
        const bool type_supported = (type_bits & (1u << i)) != 0;
        const bool properties_supported = (memory_properties.memoryTypes[i].propertyFlags & properties) == properties;
        if (type_supported && properties_supported)
            return i;
    }
    throw std::runtime_error("no suitable host-visible coherent memory type");
}

} // namespace vk_hw
