// Copyright (C) 2026 The Khronos Group Inc.
// SPDX-License-Identifier: BSD-3-Clause

#include "buffer.h"
#include "compute_pipeline.h"
#include "graphics_test.h"
#include "vulkan_context.h"

#include <algorithm>
#include <cstring>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

namespace {

using namespace vk_hw;

std::vector<uint32_t> ReadSpirv(const std::string& path)
{
    std::ifstream file(path, std::ios::binary | std::ios::ate);
    if (!file)
        throw std::runtime_error("cannot open " + path);
    const auto size = file.tellg();
    if (size <= 0 || size % 4 != 0)
        throw std::runtime_error("invalid SPIR-V size");
    std::vector<uint32_t> code(static_cast<size_t>(size) / 4);
    file.seekg(0);
    if (!file.read(reinterpret_cast<char*>(code.data()), size))
        throw std::runtime_error("cannot read " + path);
    return code;
}

std::vector<uint8_t> Bytes(const std::vector<float>& values)
{
    std::vector<uint8_t> bytes(values.size() * sizeof(float));
    std::memcpy(bytes.data(), values.data(), bytes.size());
    return bytes;
}

std::vector<uint8_t> ReadBytes(const std::string& path)
{
    std::ifstream file(path, std::ios::binary);
    if (!file)
        throw std::runtime_error("cannot open " + path);
    return {std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>()};
}

void WriteBytes(const std::string& path, const std::vector<uint8_t>& bytes)
{
    std::ofstream file(path, std::ios::binary);
    if (!file.write(reinterpret_cast<const char*>(bytes.data()), bytes.size()))
        throw std::runtime_error("cannot write " + path);
}

// A single workgroup, with an explicit device-to-host visibility barrier.
class Dispatch {
public:
    Dispatch(VulkanContext& context, const ComputePipeline& pipeline) : context_(context)
    {
        VkCommandPoolCreateInfo pool = {};
        pool.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
        pool.queueFamilyIndex = context.queue_family_index();
        Check(vkCreateCommandPool(context.device(), &pool, nullptr, &pool_), "vkCreateCommandPool");
        VkCommandBufferAllocateInfo alloc = {};
        alloc.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
        alloc.commandPool = pool_;
        alloc.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
        alloc.commandBufferCount = 1;
        Check(vkAllocateCommandBuffers(context.device(), &alloc, &command_), "vkAllocateCommandBuffers");
        VkCommandBufferBeginInfo begin = {};
        begin.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
        Check(vkBeginCommandBuffer(command_, &begin), "vkBeginCommandBuffer");
        vkCmdBindPipeline(command_, VK_PIPELINE_BIND_POINT_COMPUTE, pipeline.pipeline());
        VkDescriptorSet set = pipeline.descriptor_set();
        vkCmdBindDescriptorSets(command_, VK_PIPELINE_BIND_POINT_COMPUTE, pipeline.layout(), 0, 1, &set, 0, nullptr);
        vkCmdDispatch(command_, 1, 1, 1);
        VkMemoryBarrier barrier = {};
        barrier.sType = VK_STRUCTURE_TYPE_MEMORY_BARRIER;
        barrier.srcAccessMask = VK_ACCESS_SHADER_WRITE_BIT;
        barrier.dstAccessMask = VK_ACCESS_HOST_READ_BIT;
        vkCmdPipelineBarrier(command_, VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT, VK_PIPELINE_STAGE_HOST_BIT, 0, 1, &barrier,
                             0, nullptr, 0, nullptr);
        Check(vkEndCommandBuffer(command_), "vkEndCommandBuffer");
    }

    ~Dispatch() { vkDestroyCommandPool(context_.device(), pool_, nullptr); }

    void Run()
    {
        VkSubmitInfo submit = {};
        submit.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
        submit.commandBufferCount = 1;
        submit.pCommandBuffers = &command_;
        Check(vkQueueSubmit(context_.queue(), 1, &submit, VK_NULL_HANDLE), "vkQueueSubmit");
        Check(vkQueueWaitIdle(context_.queue()), "vkQueueWaitIdle");
    }

private:
    VulkanContext& context_;
    VkCommandPool pool_ = VK_NULL_HANDLE;
    VkCommandBuffer command_ = VK_NULL_HANDLE;
};

// File-based transport keeps the numerical oracle outside the GPU runner. All
// three buffers are returned, allowing the caller to check alias writes/guards.
void ExecuteFiles(char** argv)
{
    VulkanContext context;
    const std::string features = argv[9];
    std::string missing;
    if (features.find("f16") != std::string::npos && !context.supports_shader_float16())
        missing += " shaderFloat16";
    if (features.find("i16") != std::string::npos && !context.supports_shader_int16())
        missing += " shaderInt16";
    if (features.find("f64") != std::string::npos && !context.supports_shader_float64())
        missing += " shaderFloat64";
    if (features.find("i64") != std::string::npos && !context.supports_shader_int64())
        missing += " shaderInt64";
    if (features.find("s16") != std::string::npos && !context.supports_storage_buffer_16bit())
        missing += " storageBuffer16";
    const bool graphics = features.find("graphics:") == 0;
    if (graphics && !context.supports_fragment_stores())
        missing += " graphicsQueue/fragmentStoresAndAtomics";
    if (!missing.empty()) {
        std::cout << "{\"status\":\"skip\",\"skip_reason\":\"missing" << missing << "\"}\n";
        return;
    }
    const auto a = ReadBytes(argv[3]), b = ReadBytes(argv[4]), d = ReadBytes(argv[5]);
    Buffer aBuffer(&context, a.size()), bBuffer(&context, b.size()), dBuffer(&context, d.size());
    aBuffer.Upload(a);
    bBuffer.Upload(b);
    dBuffer.Upload(d);
    if (graphics) {
        DrawFragment(context, ReadSpirv(features.substr(9)), ReadSpirv(argv[2]),
                     {aBuffer.descriptor(), bBuffer.descriptor(), dBuffer.descriptor()});
        WriteBytes(argv[6], dBuffer.Download(d.size()));
        WriteBytes(std::string(argv[6]) + ".a", aBuffer.Download(a.size()));
        WriteBytes(std::string(argv[6]) + ".b", bBuffer.Download(b.size()));
        std::cout << "{\"status\":\"pass\",\"draws\":1}\n";
        return;
    }
    ComputePipeline pipeline(&context, ReadSpirv(argv[2]),
                             std::vector<VkDescriptorType>(3, VK_DESCRIPTOR_TYPE_STORAGE_BUFFER), argv[8]);
    auto bDescriptor = bBuffer.descriptor();
    const std::string alias = argv[7];
    VkDeviceSize offset = 0;
    if (alias != "separate") {
        bDescriptor = aBuffer.descriptor();
        if (alias == "overlap") {
            VkPhysicalDeviceProperties properties;
            vkGetPhysicalDeviceProperties(context.physical_device(), &properties);
            offset = std::max<VkDeviceSize>(256, properties.limits.minStorageBufferOffsetAlignment);
            if (offset + b.size() > a.size())
                throw std::runtime_error("alias buffer too small");
            bDescriptor.offset = offset;
        }
        bDescriptor.range = std::min<VkDeviceSize>(b.size(), a.size() - offset);
    }
    pipeline.UpdateDescriptors({aBuffer.descriptor(), bDescriptor, dBuffer.descriptor()});
    Dispatch(context, pipeline).Run();
    WriteBytes(argv[6], dBuffer.Download(d.size()));
    WriteBytes(std::string(argv[6]) + ".a", aBuffer.Download(a.size()));
    WriteBytes(std::string(argv[6]) + ".b", bBuffer.Download(b.size()));
    std::cout << "{\"status\":\"pass\",\"alias_offset\":" << offset << "}\n";
}

unsigned Run(const std::string& shader, const std::string& name, unsigned width)
{
    if (width != 4 && width != 5)
        throw std::runtime_error("language test width must be 4 or 5");
    if (name != "switch_return" && name != "do_break" && name != "private_nested" && name != "workgroup" &&
        name != "conversion_extinst" && name != "ssa")
        throw std::runtime_error("unknown language case " + name);

    VulkanContext context;
    ComputePipeline pipeline(&context, ReadSpirv(shader),
                             std::vector<VkDescriptorType>(3, VK_DESCRIPTOR_TYPE_STORAGE_BUFFER));
    Buffer aBuffer(&context, 2 * width * sizeof(float));
    Buffer bBuffer(&context, 3 * sizeof(float));
    // Include unwritten output lanes and a two-float guard beyond the largest output.
    Buffer dBuffer(&context, (2 * width + 2) * sizeof(float));
    pipeline.UpdateDescriptors({aBuffer.descriptor(), bBuffer.descriptor(), dBuffer.descriptor()});
    Dispatch dispatch(context, pipeline);
    const unsigned controls = name == "switch_return"               ? 3
                              : name == "do_break" || name == "ssa" ? 4
                              : name == "private_nested"            ? 2 * width
                                                                    : 1;
    const float samples[] = {-7.75f, -5.5f, -3.25f, -1.75f, -0.25f, 0.75f, 1.5f, 4.25f, 6.5f, 11.75f};
    unsigned checked = 0;
    for (unsigned dataset = 0; dataset < 3; ++dataset) {
        std::vector<float> a(2 * width);
        for (unsigned i = 0; i < a.size(); ++i)
            a[i] = samples[(i + 3 * dataset) % 10];
        for (unsigned control = 0; control < controls; ++control) {
            const unsigned slot = control / width;
            const unsigned lane = control % width;
            const std::vector<float> b = {17.25f, float(name == "private_nested" ? slot : control), float(lane)};
            const std::vector<float> initial(2 * width + 2, -12345.25f);
            std::vector<float> expected = initial;
            for (unsigned i = 0; i < width; ++i) {
                const float x = a[i];
                if (name == "switch_return")
                    expected[i] = control == 0 ? x + 4.0f : control == 1 ? 2.0f * x : 3.0f - x;
                else if (name == "do_break")
                    expected[i] = control < 2 ? x + 1.0f : control == 2 ? x + 2.0f : -x - 1.0f;
                else if (name == "private_nested") {
                    expected[i] = i == lane ? b[0] : a[slot * width + i];
                    expected[width + i] = a[(1 - slot) * width + i];
                } else if (name == "ssa") {
                    float value = x;
                    for (unsigned iteration = 0; iteration < control; ++iteration)
                        value = (iteration & 1u) == 0u ? value + 1.0f : value * 2.0f;
                    value += (control & 1u) != 0u ? 3.0f : -1.0f;
                    expected[i] = expected[width + i] = value;
                } else if (name == "workgroup")
                    expected[i] = x + 2.0f;
                else
                    expected[i] = std::clamp(float(2 * (int(x) + 3)), -4.0f, 8.0f);
            }
            aBuffer.Upload(Bytes(a));
            bBuffer.Upload(Bytes(b));
            dBuffer.Upload(Bytes(initial));
            dispatch.Run();
            const auto actual = dBuffer.Download(dBuffer.size());
            // Quarter-integer inputs and small integer results are exactly representable.
            // Bitwise comparison also detects unexpected writes to the guard lanes.
            if (actual != Bytes(expected)) {
                for (size_t i = 0; i < expected.size(); ++i) {
                    float value;
                    std::memcpy(&value, actual.data() + i * sizeof(float), sizeof(float));
                    if (std::memcmp(&value, &expected[i], sizeof(float)) != 0)
                        std::cerr << name << " width=" << width << " dataset=" << dataset << " control=" << control
                                  << " lane=" << i << " expected=" << expected[i] << " actual=" << value << '\n';
                }
                throw std::runtime_error("language output mismatch");
            }
            ++checked;
        }
    }
    return checked;
}

} // namespace

int main(int argc, char** argv)
{
    try {
        if (argc == 10 && std::string(argv[1]) == "--execute") {
            ExecuteFiles(argv);
            return 0;
        }
        if (argc != 4)
            throw std::runtime_error("usage: vk_hw_language_tests shader.spv case width");
        const unsigned checked = Run(argv[1], argv[2], unsigned(std::stoul(argv[3])));
        std::cout << "{\"status\":\"pass\",\"dispatches\":" << checked << "}\n";
        return 0;
    } catch (const std::exception& error) {
        std::cerr << error.what() << '\n';
        return 1;
    }
}
