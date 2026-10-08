// Copyright (C) 2026 The Khronos Group Inc.
// SPDX-License-Identifier: BSD-3-Clause

#include "buffer.h"
#include "compute_pipeline.h"
#include "graphics_test.h"
#include "vulkan_context.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <numeric>
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

unsigned ParseIterations(const char* value, const char* name, bool allow_zero)
{
    const std::string text = value;
    if (text.empty() || text.find_first_not_of("0123456789") != std::string::npos)
        throw std::runtime_error(std::string(name) + " must be an unsigned integer");
    const auto count = std::stoul(text);
    if (count > 10000 || (!allow_zero && count == 0))
        throw std::runtime_error(std::string(name) + (allow_zero ? " must be in [0, 10000]" : " must be in [1, 10000]"));
    return static_cast<unsigned>(count);
}

// A single workgroup, with an explicit device-to-host visibility barrier.
class Dispatch {
public:
    Dispatch(VulkanContext& context, const ComputePipeline& pipeline, bool timed = false) : context_(context)
    {
        if (timed) {
            uint32_t count = 0;
            vkGetPhysicalDeviceQueueFamilyProperties(context.physical_device(), &count, nullptr);
            std::vector<VkQueueFamilyProperties> properties(count);
            vkGetPhysicalDeviceQueueFamilyProperties(context.physical_device(), &count, properties.data());
            if (context.queue_family_index() >= count)
                throw std::runtime_error("invalid timestamp queue family");
            timestamp_bits_ = properties[context.queue_family_index()].timestampValidBits;
            if (timestamp_bits_ == 0 || timestamp_bits_ > 64 || !std::isfinite(context.timestamp_period_ns()) ||
                context.timestamp_period_ns() <= 0.0f)
                throw std::runtime_error("compute queue has no usable timestamp support");
        }
        try {
            Initialize(pipeline, timed);
        } catch (...) {
            DestroyResources();
            throw;
        }
    }

    ~Dispatch() { DestroyResources(); }

    double Run()
    {
        VkSubmitInfo submit = {};
        submit.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
        submit.commandBufferCount = 1;
        submit.pCommandBuffers = &command_;
        Check(vkQueueSubmit(context_.queue(), 1, &submit, VK_NULL_HANDLE), "vkQueueSubmit");
        Check(vkQueueWaitIdle(context_.queue()), "vkQueueWaitIdle");
        if (query_pool_ == VK_NULL_HANDLE)
            return 0.0;
        std::array<uint64_t, 2> timestamps = {};
        Check(vkGetQueryPoolResults(context_.device(), query_pool_, 0, 2, sizeof(timestamps), timestamps.data(),
                                    sizeof(uint64_t), VK_QUERY_RESULT_64_BIT | VK_QUERY_RESULT_WAIT_BIT),
              "vkGetQueryPoolResults");
        uint64_t ticks = timestamps[1] - timestamps[0];
        // Queue timestamps may expose fewer than 64 bits and wrap at that width.
        if (timestamp_bits_ < 64)
            ticks &= (uint64_t{1} << timestamp_bits_) - 1;
        const double duration = static_cast<double>(ticks) * context_.timestamp_period_ns();
        if (!std::isfinite(duration) || duration <= 0.0)
            throw std::runtime_error("GPU dispatch duration must be finite and positive");
        return duration;
    }

private:
    void Initialize(const ComputePipeline& pipeline, bool timed)
    {
        VkCommandPoolCreateInfo pool = {};
        pool.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
        pool.queueFamilyIndex = context_.queue_family_index();
        Check(vkCreateCommandPool(context_.device(), &pool, nullptr, &pool_), "vkCreateCommandPool");
        VkCommandBufferAllocateInfo alloc = {};
        alloc.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
        alloc.commandPool = pool_;
        alloc.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
        alloc.commandBufferCount = 1;
        Check(vkAllocateCommandBuffers(context_.device(), &alloc, &command_), "vkAllocateCommandBuffers");
        if (timed) {
            VkQueryPoolCreateInfo query = {};
            query.sType = VK_STRUCTURE_TYPE_QUERY_POOL_CREATE_INFO;
            query.queryType = VK_QUERY_TYPE_TIMESTAMP;
            query.queryCount = 2;
            Check(vkCreateQueryPool(context_.device(), &query, nullptr, &query_pool_), "vkCreateQueryPool");
        }
        VkCommandBufferBeginInfo begin = {};
        begin.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
        Check(vkBeginCommandBuffer(command_, &begin), "vkBeginCommandBuffer");
        if (timed)
            vkCmdResetQueryPool(command_, query_pool_, 0, 2);
        vkCmdBindPipeline(command_, VK_PIPELINE_BIND_POINT_COMPUTE, pipeline.pipeline());
        VkDescriptorSet set = pipeline.descriptor_set();
        vkCmdBindDescriptorSets(command_, VK_PIPELINE_BIND_POINT_COMPUTE, pipeline.layout(), 0, 1, &set, 0, nullptr);
        if (timed)
            vkCmdWriteTimestamp(command_, VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT, query_pool_, 0);
        vkCmdDispatch(command_, 1, 1, 1);
        if (timed)
            vkCmdWriteTimestamp(command_, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, query_pool_, 1);
        VkMemoryBarrier barrier = {};
        barrier.sType = VK_STRUCTURE_TYPE_MEMORY_BARRIER;
        barrier.srcAccessMask = VK_ACCESS_SHADER_WRITE_BIT;
        barrier.dstAccessMask = VK_ACCESS_HOST_READ_BIT;
        VkPipelineStageFlags destination = VK_PIPELINE_STAGE_HOST_BIT;
        if (timed) {
            // Queue idle permits command/query reuse; this dependency also
            // orders the output writes of subsequent dispatch submissions.
            barrier.dstAccessMask |= VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT;
            destination |= VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT;
        }
        vkCmdPipelineBarrier(command_, VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT, destination, 0, 1, &barrier,
                             0, nullptr, 0, nullptr);
        Check(vkEndCommandBuffer(command_), "vkEndCommandBuffer");
    }

    void DestroyResources()
    {
        if (pool_ != VK_NULL_HANDLE)
            vkDestroyCommandPool(context_.device(), pool_, nullptr);
        if (query_pool_ != VK_NULL_HANDLE)
            vkDestroyQueryPool(context_.device(), query_pool_, nullptr);
    }

    VulkanContext& context_;
    VkCommandPool pool_ = VK_NULL_HANDLE;
    VkCommandBuffer command_ = VK_NULL_HANDLE;
    VkQueryPool query_pool_ = VK_NULL_HANDLE;
    uint32_t timestamp_bits_ = 0;
};

// File-based transport keeps the numerical oracle outside the GPU runner. All
// three buffers are returned, allowing the caller to check alias writes/guards.
void ExecuteFiles(char** argv, unsigned warmup = 0, unsigned repeat = 0)
{
    const std::string features = argv[9];
    const bool graphics = features.find("graphics:") == 0;
    const std::string alias = argv[7];
    if (repeat != 0 && graphics)
        throw std::runtime_error("--execute-timed only supports compute shaders");
    if (repeat != 0 && alias != "separate")
        throw std::runtime_error("--execute-timed requires separate buffers and immutable inputs");
    VulkanContext context;
    std::string missing;
    if (features.find("f16") != std::string::npos && !context.supports_shader_float16())
        missing += " shaderFloat16";
    if (features.find("i8") != std::string::npos && !context.supports_shader_int8())
        missing += " shaderInt8";
    if (features.find("i16") != std::string::npos && !context.supports_shader_int16())
        missing += " shaderInt16";
    if (features.find("f64") != std::string::npos && !context.supports_shader_float64())
        missing += " shaderFloat64";
    if (features.find("i64") != std::string::npos && !context.supports_shader_int64())
        missing += " shaderInt64";
    if (features.find("s16") != std::string::npos && !context.supports_storage_buffer_16bit())
        missing += " storageBuffer16";
    if (features.find("s8") != std::string::npos && !context.supports_storage_buffer_8bit())
        missing += " storageBuffer8";
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
    Dispatch dispatch(context, pipeline, repeat != 0);
    std::vector<double> samples;
    if (repeat != 0) {
        // Timed workloads read immutable inputs and deterministically overwrite
        // their output, so no upload or host read belongs in the timed interval.
        for (unsigned i = 0; i < warmup; ++i)
            dispatch.Run();
        samples.reserve(repeat);
        for (unsigned i = 0; i < repeat; ++i)
            samples.push_back(dispatch.Run());
    } else {
        dispatch.Run();
    }
    WriteBytes(argv[6], dBuffer.Download(d.size()));
    WriteBytes(std::string(argv[6]) + ".a", aBuffer.Download(a.size()));
    WriteBytes(std::string(argv[6]) + ".b", bBuffer.Download(b.size()));
    std::cout << "{\"status\":\"pass\",\"alias_offset\":" << offset;
    if (!samples.empty()) {
        std::sort(samples.begin(), samples.end());
        const double average = std::accumulate(samples.begin(), samples.end(), 0.0) / samples.size();
        const double median = (samples[(samples.size() - 1) / 2] + samples[samples.size() / 2]) / 2.0;
        std::cout << std::setprecision(17) << ",\"warmup\":" << warmup << ",\"repeat\":" << repeat
                  << ",\"gpu_time_ns_avg\":" << average << ",\"gpu_time_ns_min\":" << samples.front()
                  << ",\"gpu_time_ns_p50\":" << median << ",\"gpu_time_ns_max\":" << samples.back();
        VkPhysicalDeviceProperties properties = {};
        vkGetPhysicalDeviceProperties(context.physical_device(), &properties);
        std::cout << ",\"device\":" << std::quoted(properties.deviceName)
                  << ",\"driver_version\":" << properties.driverVersion
                  << ",\"vendor_id\":" << properties.vendorID;
    }
    std::cout << "}\n";
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
        if (argc == 12 && std::string(argv[1]) == "--execute-timed") {
            const unsigned warmup = ParseIterations(argv[10], "warmup", true);
            const unsigned repeat = ParseIterations(argv[11], "repeat", false);
            ExecuteFiles(argv, warmup, repeat);
            return 0;
        }
        if (argc != 4)
            throw std::runtime_error(
                "usage: vk_hw_language_tests shader.spv case width\n"
                "       vk_hw_language_tests --execute shader.spv a.bin b.bin d.bin output.bin alias entry features\n"
                "       vk_hw_language_tests --execute-timed shader.spv a.bin b.bin d.bin output.bin separate entry "
                "features warmup repeat\n"
                "Timed shaders must read immutable A/B buffers and overwrite their D results each dispatch.");
        const unsigned checked = Run(argv[1], argv[2], unsigned(std::stoul(argv[3])));
        std::cout << "{\"status\":\"pass\",\"dispatches\":" << checked << "}\n";
        return 0;
    } catch (const std::exception& error) {
        std::cerr << error.what() << '\n';
        return 1;
    }
}
