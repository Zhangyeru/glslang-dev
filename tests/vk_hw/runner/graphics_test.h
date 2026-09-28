// Copyright (C) 2026 The Khronos Group Inc.
// SPDX-License-Identifier: BSD-3-Clause
#ifndef VK_HW_GRAPHICS_TEST_H
#define VK_HW_GRAPHICS_TEST_H
#include "vulkan_context.h"
#include <vector>
namespace vk_hw {
// Rasterize a fullscreen triangle into a one-pixel framebuffer. The fragment
// shader writes storage buffers, so all numeric results use the same host oracle.
void DrawFragment(VulkanContext& context, const std::vector<uint32_t>& vertex, const std::vector<uint32_t>& fragment,
                  const std::vector<VkDescriptorBufferInfo>& buffers);
} // namespace vk_hw
#endif
