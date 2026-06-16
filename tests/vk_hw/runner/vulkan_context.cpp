// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#include "vulkan_context.h"

#include <algorithm>
#include <stdexcept>
#include <string>
#include <vector>

namespace vk_hw {
namespace {

bool HasExtension(const std::vector<VkExtensionProperties>& extensions, const char* name)
{
    return std::any_of(extensions.begin(), extensions.end(), [name](const VkExtensionProperties& extension) {
        return std::string(extension.extensionName) == name;
    });
}

uint32_t ApiMajor(uint32_t version) { return VK_VERSION_MAJOR(version); }
uint32_t ApiMinor(uint32_t version) { return VK_VERSION_MINOR(version); }

bool ApiAtLeast(uint32_t version, uint32_t major, uint32_t minor)
{
    return ApiMajor(version) > major || (ApiMajor(version) == major && ApiMinor(version) >= minor);
}

} // namespace

void Check(VkResult result, const char* what)
{
    if (result != VK_SUCCESS) {
        throw std::runtime_error(std::string(what) + " failed with VkResult " + std::to_string(result));
    }
}

VulkanContext::VulkanContext()
{
    VkApplicationInfo app_info = {};
    app_info.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    app_info.pApplicationName = "vk_hw_runner";
    app_info.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
    app_info.pEngineName = "vk_hw_runner";
    app_info.engineVersion = VK_MAKE_VERSION(1, 0, 0);
    app_info.apiVersion = VK_API_VERSION_1_2;

    VkInstanceCreateInfo instance_info = {};
    instance_info.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    instance_info.pApplicationInfo = &app_info;
    Check(vkCreateInstance(&instance_info, nullptr, &instance_), "vkCreateInstance");

    PickPhysicalDevice();
    CreateDevice();
}

VulkanContext::~VulkanContext()
{
    if (device_ != VK_NULL_HANDLE)
        vkDestroyDevice(device_, nullptr);
    if (instance_ != VK_NULL_HANDLE)
        vkDestroyInstance(instance_, nullptr);
}

void VulkanContext::PickPhysicalDevice()
{
    uint32_t device_count = 0;
    Check(vkEnumeratePhysicalDevices(instance_, &device_count, nullptr), "vkEnumeratePhysicalDevices(count)");
    if (device_count == 0) {
        throw std::runtime_error("no Vulkan physical device found");
    }

    std::vector<VkPhysicalDevice> devices(device_count);
    Check(vkEnumeratePhysicalDevices(instance_, &device_count, devices.data()), "vkEnumeratePhysicalDevices");

    for (VkPhysicalDevice device : devices) {
        uint32_t queue_count = 0;
        vkGetPhysicalDeviceQueueFamilyProperties(device, &queue_count, nullptr);
        std::vector<VkQueueFamilyProperties> queues(queue_count);
        vkGetPhysicalDeviceQueueFamilyProperties(device, &queue_count, queues.data());

        for (uint32_t index = 0; index < queue_count; ++index) {
            if ((queues[index].queueFlags & VK_QUEUE_COMPUTE_BIT) != 0 && queues[index].timestampValidBits > 0) {
                VkPhysicalDeviceProperties properties = {};
                vkGetPhysicalDeviceProperties(device, &properties);
                physical_device_ = device;
                queue_family_index_ = index;
                timestamp_period_ns_ = properties.limits.timestampPeriod;
                return;
            }
        }
    }

    throw std::runtime_error("no Vulkan physical device with compute timestamp support found");
}

void VulkanContext::CreateDevice()
{
    VkPhysicalDeviceProperties properties = {};
    vkGetPhysicalDeviceProperties(physical_device_, &properties);

    uint32_t extension_count = 0;
    Check(vkEnumerateDeviceExtensionProperties(physical_device_, nullptr, &extension_count, nullptr),
          "vkEnumerateDeviceExtensionProperties(count)");
    std::vector<VkExtensionProperties> extensions(extension_count);
    Check(vkEnumerateDeviceExtensionProperties(physical_device_, nullptr, &extension_count, extensions.data()),
          "vkEnumerateDeviceExtensionProperties");

    std::vector<const char*> enabled_extensions;
    if (!ApiAtLeast(properties.apiVersion, 1, 1) && HasExtension(extensions, VK_KHR_16BIT_STORAGE_EXTENSION_NAME)) {
        enabled_extensions.push_back(VK_KHR_16BIT_STORAGE_EXTENSION_NAME);
    }
    if (!ApiAtLeast(properties.apiVersion, 1, 2) &&
        HasExtension(extensions, VK_KHR_SHADER_FLOAT16_INT8_EXTENSION_NAME)) {
        enabled_extensions.push_back(VK_KHR_SHADER_FLOAT16_INT8_EXTENSION_NAME);
    }

    VkPhysicalDevice16BitStorageFeatures storage16 = {};
    storage16.sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES;

    VkPhysicalDeviceShaderFloat16Int8Features float16_int8 = {};
    float16_int8.sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_FLOAT16_INT8_FEATURES;
    float16_int8.pNext = &storage16;

    VkPhysicalDeviceFeatures2 features2 = {};
    features2.sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2;
    features2.pNext = &float16_int8;
    vkGetPhysicalDeviceFeatures2(physical_device_, &features2);

    supports_storage_buffer_16bit_ = storage16.storageBuffer16BitAccess == VK_TRUE;
    supports_shader_float16_ = float16_int8.shaderFloat16 == VK_TRUE;
    storage16.storageBuffer16BitAccess = storage16.storageBuffer16BitAccess ? VK_TRUE : VK_FALSE;
    float16_int8.shaderFloat16 = float16_int8.shaderFloat16 ? VK_TRUE : VK_FALSE;

    const float queue_priority = 1.0f;
    VkDeviceQueueCreateInfo queue_info = {};
    queue_info.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
    queue_info.queueFamilyIndex = queue_family_index_;
    queue_info.queueCount = 1;
    queue_info.pQueuePriorities = &queue_priority;

    VkDeviceCreateInfo device_info = {};
    device_info.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
    device_info.pNext = &features2;
    device_info.queueCreateInfoCount = 1;
    device_info.pQueueCreateInfos = &queue_info;
    device_info.enabledExtensionCount = static_cast<uint32_t>(enabled_extensions.size());
    device_info.ppEnabledExtensionNames = enabled_extensions.data();
    Check(vkCreateDevice(physical_device_, &device_info, nullptr, &device_), "vkCreateDevice");

    vkGetDeviceQueue(device_, queue_family_index_, 0, &queue_);
}

} // namespace vk_hw
