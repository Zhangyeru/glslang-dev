// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#include "compute_pipeline.h"

#include <array>

namespace vk_hw {

ComputePipeline::ComputePipeline(VulkanContext* context, const std::vector<uint32_t>& code,
                                 const std::array<VkDescriptorType, 4>& descriptor_types)
    : context_(context), descriptor_types_(descriptor_types)
{
    VkShaderModuleCreateInfo module_info = {};
    module_info.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
    module_info.codeSize = code.size() * sizeof(uint32_t);
    module_info.pCode = code.data();
    Check(vkCreateShaderModule(context_->device(), &module_info, nullptr, &shader_module_), "vkCreateShaderModule");

    std::array<VkDescriptorSetLayoutBinding, 4> bindings = {};
    for (uint32_t i = 0; i < bindings.size(); ++i) {
        bindings[i].binding = i;
        bindings[i].descriptorType = descriptor_types_[i];
        bindings[i].descriptorCount = 1;
        bindings[i].stageFlags = VK_SHADER_STAGE_COMPUTE_BIT;
    }

    VkDescriptorSetLayoutCreateInfo layout_info = {};
    layout_info.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
    layout_info.bindingCount = static_cast<uint32_t>(bindings.size());
    layout_info.pBindings = bindings.data();
    Check(vkCreateDescriptorSetLayout(context_->device(), &layout_info, nullptr, &descriptor_set_layout_),
          "vkCreateDescriptorSetLayout");

    VkPipelineLayoutCreateInfo pipeline_layout_info = {};
    pipeline_layout_info.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
    pipeline_layout_info.setLayoutCount = 1;
    pipeline_layout_info.pSetLayouts = &descriptor_set_layout_;
    Check(vkCreatePipelineLayout(context_->device(), &pipeline_layout_info, nullptr, &pipeline_layout_),
          "vkCreatePipelineLayout");

    VkPipelineShaderStageCreateInfo stage_info = {};
    stage_info.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    stage_info.stage = VK_SHADER_STAGE_COMPUTE_BIT;
    stage_info.module = shader_module_;
    stage_info.pName = "main";

    VkComputePipelineCreateInfo pipeline_info = {};
    pipeline_info.sType = VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO;
    pipeline_info.stage = stage_info;
    pipeline_info.layout = pipeline_layout_;
    Check(vkCreateComputePipelines(context_->device(), VK_NULL_HANDLE, 1, &pipeline_info, nullptr, &pipeline_),
          "vkCreateComputePipelines");

    std::array<VkDescriptorPoolSize, 2> pool_sizes = {};
    uint32_t pool_size_count = 0;
    auto append_pool_size = [&](VkDescriptorType type) {
        for (uint32_t i = 0; i < pool_size_count; ++i) {
            if (pool_sizes[i].type == type) {
                ++pool_sizes[i].descriptorCount;
                return;
            }
        }
        pool_sizes[pool_size_count].type = type;
        pool_sizes[pool_size_count].descriptorCount = 1;
        ++pool_size_count;
    };
    for (VkDescriptorType type : descriptor_types_) {
        append_pool_size(type);
    }

    VkDescriptorPoolCreateInfo pool_info = {};
    pool_info.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
    pool_info.maxSets = 1;
    pool_info.poolSizeCount = pool_size_count;
    pool_info.pPoolSizes = pool_sizes.data();
    Check(vkCreateDescriptorPool(context_->device(), &pool_info, nullptr, &descriptor_pool_), "vkCreateDescriptorPool");

    VkDescriptorSetAllocateInfo alloc_info = {};
    alloc_info.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
    alloc_info.descriptorPool = descriptor_pool_;
    alloc_info.descriptorSetCount = 1;
    alloc_info.pSetLayouts = &descriptor_set_layout_;
    Check(vkAllocateDescriptorSets(context_->device(), &alloc_info, &descriptor_set_), "vkAllocateDescriptorSets");
}

ComputePipeline::~ComputePipeline()
{
    if (descriptor_pool_ != VK_NULL_HANDLE) {
        vkDestroyDescriptorPool(context_->device(), descriptor_pool_, nullptr);
    }
    if (pipeline_ != VK_NULL_HANDLE) {
        vkDestroyPipeline(context_->device(), pipeline_, nullptr);
    }
    if (pipeline_layout_ != VK_NULL_HANDLE) {
        vkDestroyPipelineLayout(context_->device(), pipeline_layout_, nullptr);
    }
    if (descriptor_set_layout_ != VK_NULL_HANDLE) {
        vkDestroyDescriptorSetLayout(context_->device(), descriptor_set_layout_, nullptr);
    }
    if (shader_module_ != VK_NULL_HANDLE) {
        vkDestroyShaderModule(context_->device(), shader_module_, nullptr);
    }
}

void ComputePipeline::UpdateDescriptors(const std::array<VkDescriptorBufferInfo, 4>& descriptors)
{
    std::array<VkWriteDescriptorSet, 4> writes = {};
    for (uint32_t i = 0; i < writes.size(); ++i) {
        writes[i].sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
        writes[i].dstSet = descriptor_set_;
        writes[i].dstBinding = i;
        writes[i].descriptorCount = 1;
        writes[i].descriptorType = descriptor_types_[i];
        writes[i].pBufferInfo = &descriptors[i];
    }
    vkUpdateDescriptorSets(context_->device(), static_cast<uint32_t>(writes.size()), writes.data(), 0, nullptr);
}

} // namespace vk_hw
