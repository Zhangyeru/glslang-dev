// Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

#include "buffer.h"
#include "compute_pipeline.h"
#include "reference.h"
#include "timer.h"
#include "vulkan_context.h"

#include <vulkan/vulkan.h>

#include <array>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

namespace vk_hw {
namespace {

std::vector<uint32_t> ReadSpirv(const std::string& path)
{
    std::ifstream file(path, std::ios::binary | std::ios::ate);
    if (!file)
        throw std::runtime_error("failed to open SPIR-V: " + path);

    const std::streamsize size = file.tellg();
    if (size <= 0 || (size % 4) != 0) {
        throw std::runtime_error("invalid SPIR-V byte size: " + path);
    }
    file.seekg(0, std::ios::beg);

    std::vector<uint32_t> code(static_cast<size_t>(size) / sizeof(uint32_t));
    if (!file.read(reinterpret_cast<char*>(code.data()), size)) {
        throw std::runtime_error("failed to read SPIR-V: " + path);
    }
    return code;
}

std::string JsonEscape(const std::string& value)
{
    std::string escaped;
    escaped.reserve(value.size());
    for (char c : value) {
        if (c == '"' || c == '\\')
            escaped.push_back('\\');
        escaped.push_back(c);
    }
    return escaped;
}

std::array<VkDescriptorType, 4> DescriptorTypesForShader(
    const std::string& shader_path)
{
    std::array<VkDescriptorType, 4> descriptor_types = {
        VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
        VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
        VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
        VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
    };
    if (shader_path.find("_ubo_") != std::string::npos) {
        descriptor_types[1] = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
    }
    return descriptor_types;
}

CaseKind ParseCaseKind(const std::string& value)
{
    if (value == "matmul")
        return CaseKind::kMatmul;
    if (value == "vecmatmul")
        return CaseKind::kVecMatmul;
    if (value == "vecmatmuladd")
        return CaseKind::kVecMatmulAdd;
    if (value == "load_store")
        return CaseKind::kLoadStore;
    if (value == "multiops")
        return CaseKind::kMultiOps;
    if (value == "mlp")
        return CaseKind::kMlp;
    if (value == "reduce")
        return CaseKind::kReduce;
    throw std::runtime_error("unknown case: " + value);
}

DType ParseDType(const std::string& value)
{
    if (value == "f16")
        return DType::kF16;
    if (value == "f32")
        return DType::kF32;
    throw std::runtime_error("unknown dtype: " + value);
}

ReduceAxis ParseReduceAxis(const std::string& value)
{
    if (value == "row")
        return ReduceAxis::kRow;
    if (value == "column")
        return ReduceAxis::kColumn;
    throw std::runtime_error("unknown reduce axis: " + value);
}

ReduceOp ParseReduceOp(const std::string& value)
{
    if (value == "add")
        return ReduceOp::kAdd;
    if (value == "min")
        return ReduceOp::kMin;
    if (value == "max")
        return ReduceOp::kMax;
    throw std::runtime_error("unknown reduce operation: " + value);
}

uint32_t ParseU32(const std::string& value, const char* name)
{
    const unsigned long parsed = std::stoul(value);
    if (parsed > UINT32_MAX) {
        throw std::runtime_error(std::string(name) + " exceeds uint32_t");
    }
    return static_cast<uint32_t>(parsed);
}

CaseConfig ParseArgs(int argc, char** argv)
{
    CaseConfig config;
    for (int i = 1; i < argc; ++i) {
        const std::string arg = argv[i];
        auto require_value = [&](const char* option) -> std::string {
            if (i + 1 >= argc) {
                throw std::runtime_error(std::string("missing value for ") + option);
            }
            return argv[++i];
        };

        if (arg == "--shader") {
            config.shader_path = require_value("--shader");
        } else if (arg == "--case") {
            config.kind = ParseCaseKind(require_value("--case"));
        } else if (arg == "--dtype") {
            config.dtype = ParseDType(require_value("--dtype"));
        } else if (arg == "--m") {
            config.m = ParseU32(require_value("--m"), "--m");
        } else if (arg == "--n") {
            config.n = ParseU32(require_value("--n"), "--n");
        } else if (arg == "--k") {
            config.k = ParseU32(require_value("--k"), "--k");
        } else if (arg == "--d0") {
            config.d0 = ParseU32(require_value("--d0"), "--d0");
        } else if (arg == "--d1") {
            config.d1 = ParseU32(require_value("--d1"), "--d1");
        } else if (arg == "--d2") {
            config.d2 = ParseU32(require_value("--d2"), "--d2");
        } else if (arg == "--d3") {
            config.d3 = ParseU32(require_value("--d3"), "--d3");
        } else if (arg == "--axis") {
            config.reduce_axis = ParseReduceAxis(require_value("--axis"));
        } else if (arg == "--reduce-op") {
            config.reduce_op = ParseReduceOp(require_value("--reduce-op"));
        } else if (arg == "--warmup") {
            config.warmup = ParseU32(require_value("--warmup"), "--warmup");
        } else if (arg == "--repeat") {
            config.repeat = ParseU32(require_value("--repeat"), "--repeat");
        } else if (arg == "--verify") {
            config.verify = ParseU32(require_value("--verify"), "--verify") != 0;
        } else if (arg == "--layout-a" || arg == "--layout-b") {
            (void)require_value(arg.c_str());
        } else {
            throw std::runtime_error("unknown option: " + arg);
        }
    }

    if (config.shader_path.empty()) {
        throw std::runtime_error("--shader is required");
    }
    if (config.repeat == 0) {
        throw std::runtime_error("--repeat must be greater than zero");
    }
    if (config.kind == CaseKind::kMlp &&
        (config.d0 == 0 || config.d1 == 0 || config.d2 == 0 || config.d3 == 0)) {
        throw std::runtime_error("mlp case requires --d0 --d1 --d2 --d3");
    }
    if (config.kind == CaseKind::kReduce && (config.m == 0 || config.n == 0)) {
        throw std::runtime_error("reduce case requires non-zero --m and --n");
    }
    return config;
}

class DispatchTimer {
public:
    explicit DispatchTimer(VulkanContext* context) : context_(context)
    {
        VkCommandPoolCreateInfo pool_info = {};
        pool_info.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
        pool_info.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
        pool_info.queueFamilyIndex = context_->queue_family_index();
        Check(vkCreateCommandPool(context_->device(), &pool_info, nullptr, &command_pool_), "vkCreateCommandPool");

        VkCommandBufferAllocateInfo alloc_info = {};
        alloc_info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
        alloc_info.commandPool = command_pool_;
        alloc_info.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
        alloc_info.commandBufferCount = 1;
        Check(vkAllocateCommandBuffers(context_->device(), &alloc_info, &command_buffer_), "vkAllocateCommandBuffers");

        VkQueryPoolCreateInfo query_info = {};
        query_info.sType = VK_STRUCTURE_TYPE_QUERY_POOL_CREATE_INFO;
        query_info.queryType = VK_QUERY_TYPE_TIMESTAMP;
        query_info.queryCount = 2;
        Check(vkCreateQueryPool(context_->device(), &query_info, nullptr, &query_pool_), "vkCreateQueryPool");

        VkFenceCreateInfo fence_info = {};
        fence_info.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
        Check(vkCreateFence(context_->device(), &fence_info, nullptr, &fence_), "vkCreateFence");
    }

    ~DispatchTimer()
    {
        if (fence_ != VK_NULL_HANDLE) {
            vkDestroyFence(context_->device(), fence_, nullptr);
        }
        if (query_pool_ != VK_NULL_HANDLE) {
            vkDestroyQueryPool(context_->device(), query_pool_, nullptr);
        }
        if (command_pool_ != VK_NULL_HANDLE) {
            vkDestroyCommandPool(context_->device(), command_pool_, nullptr);
        }
    }

    double Run(const ComputePipeline& pipeline)
    {
        Check(vkResetFences(context_->device(), 1, &fence_), "vkResetFences");
        Check(vkResetCommandBuffer(command_buffer_, 0), "vkResetCommandBuffer");

        VkCommandBufferBeginInfo begin_info = {};
        begin_info.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
        begin_info.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
        Check(vkBeginCommandBuffer(command_buffer_, &begin_info), "vkBeginCommandBuffer");

        vkCmdResetQueryPool(command_buffer_, query_pool_, 0, 2);
        vkCmdBindPipeline(command_buffer_, VK_PIPELINE_BIND_POINT_COMPUTE, pipeline.pipeline());
        VkDescriptorSet descriptor_set = pipeline.descriptor_set();
        vkCmdBindDescriptorSets(command_buffer_, VK_PIPELINE_BIND_POINT_COMPUTE, pipeline.layout(), 0, 1,
                                &descriptor_set, 0, nullptr);
        vkCmdWriteTimestamp(command_buffer_, VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT, query_pool_, 0);
        vkCmdDispatch(command_buffer_, 1, 1, 1);

        VkMemoryBarrier barrier = {};
        barrier.sType = VK_STRUCTURE_TYPE_MEMORY_BARRIER;
        barrier.srcAccessMask = VK_ACCESS_SHADER_WRITE_BIT;
        barrier.dstAccessMask = VK_ACCESS_HOST_READ_BIT;
        vkCmdPipelineBarrier(command_buffer_, VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT, VK_PIPELINE_STAGE_HOST_BIT, 0, 1,
                             &barrier, 0, nullptr, 0, nullptr);

        vkCmdWriteTimestamp(command_buffer_, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, query_pool_, 1);
        Check(vkEndCommandBuffer(command_buffer_), "vkEndCommandBuffer");

        VkSubmitInfo submit_info = {};
        submit_info.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
        submit_info.commandBufferCount = 1;
        submit_info.pCommandBuffers = &command_buffer_;
        Check(vkQueueSubmit(context_->queue(), 1, &submit_info, fence_), "vkQueueSubmit");
        Check(vkWaitForFences(context_->device(), 1, &fence_, VK_TRUE, UINT64_MAX), "vkWaitForFences");

        std::array<uint64_t, 2> timestamps = {};
        Check(vkGetQueryPoolResults(context_->device(), query_pool_, 0, 2, sizeof(uint64_t) * timestamps.size(),
                                    timestamps.data(), sizeof(uint64_t),
                                    VK_QUERY_RESULT_64_BIT | VK_QUERY_RESULT_WAIT_BIT),
              "vkGetQueryPoolResults");
        return static_cast<double>(timestamps[1] - timestamps[0]) * context_->timestamp_period_ns();
    }

private:
    VulkanContext* context_ = nullptr;
    VkCommandPool command_pool_ = VK_NULL_HANDLE;
    VkCommandBuffer command_buffer_ = VK_NULL_HANDLE;
    VkQueryPool query_pool_ = VK_NULL_HANDLE;
    VkFence fence_ = VK_NULL_HANDLE;
};

void PrintJson(const CaseConfig& config, const TimeStats& stats, const VerifyResult& verify)
{
    const double gflops = stats.avg > 0.0 ? static_cast<double>(FlopCount(config)) / stats.avg : 0.0;

    std::cout << std::fixed << std::setprecision(6);
    std::cout << "{\n";
    std::cout << "  \"case\": \"" << CaseName(config.kind) << "\",\n";
    std::cout << "  \"shader\": \"" << JsonEscape(config.shader_path) << "\",\n";
    std::cout << "  \"dtype\": \"" << DTypeName(config.dtype) << "\",\n";
    std::cout << "  \"m\": " << config.m << ",\n";
    std::cout << "  \"n\": " << config.n << ",\n";
    std::cout << "  \"k\": " << config.k << ",\n";
    if (config.kind == CaseKind::kMlp) {
        std::cout << "  \"layer_dims\": [" << config.d0 << ", " << config.d1 << ", " << config.d2 << ", "
                  << config.d3 << "],\n";
    }
    if (config.kind == CaseKind::kReduce) {
        std::cout << "  \"axis\": \"" << ReduceAxisName(config.reduce_axis) << "\",\n";
        std::cout << "  \"reduce_op\": \"" << ReduceOpName(config.reduce_op) << "\",\n";
    }
    std::cout << "  \"warmup\": " << config.warmup << ",\n";
    std::cout << "  \"repeat\": " << config.repeat << ",\n";
    std::cout << "  \"gpu_time_ns_min\": " << stats.min << ",\n";
    std::cout << "  \"gpu_time_ns_avg\": " << stats.avg << ",\n";
    std::cout << "  \"gpu_time_ns_p50\": " << stats.p50 << ",\n";
    std::cout << "  \"gpu_time_ns_p90\": " << stats.p90 << ",\n";
    std::cout << "  \"gpu_time_ns_max\": " << stats.max << ",\n";
    std::cout << "  \"gflops_avg\": " << gflops << ",\n";
    std::cout << "  \"verify\": \"" << (verify.pass ? "pass" : "fail") << "\",\n";
    std::cout << "  \"max_abs_error\": " << verify.max_abs_error << ",\n";
    std::cout << "  \"max_rel_error\": " << verify.max_rel_error << "\n";
    std::cout << "}\n";
}

int Run(int argc, char** argv)
{
    const CaseConfig config = ParseArgs(argc, argv);
    const std::vector<uint32_t> spirv = ReadSpirv(config.shader_path);

    const std::vector<float> a = MakeInput(ElementCountA(config), 1, config.dtype);
    const std::vector<float> b = MakeInput(ElementCountB(config), 2, config.dtype);
    const std::vector<float> c = MakeInput(ElementCountC(config), 3, config.dtype);
    const std::vector<uint8_t> a_bytes = EncodeBuffer(a, config.dtype);
    const std::vector<uint8_t> b_bytes = EncodeBuffer(b, config.dtype);
    const std::vector<uint8_t> c_bytes = EncodeBuffer(c, config.dtype);
    const size_t d_bytes_size = ElementCountD(config) * ElementSize(config.dtype);
    const std::vector<uint8_t> d_init(d_bytes_size, 0);

    VulkanContext context;
    if (config.dtype == DType::kF16 &&
        (!context.supports_shader_float16() || !context.supports_storage_buffer_16bit())) {
        throw std::runtime_error("f16 case requires shaderFloat16 and storageBuffer16BitAccess Vulkan features");
    }
    if (config.shader_path.find("_ubo_") != std::string::npos &&
        !context.supports_scalar_block_layout()) {
        throw std::runtime_error("UBO case requires scalarBlockLayout Vulkan feature");
    }

    Buffer buffer_a(&context, a_bytes.size());
    Buffer buffer_b(&context, b_bytes.size());
    Buffer buffer_c(&context, c_bytes.size());
    Buffer buffer_d(&context, d_init.size());

    ComputePipeline pipeline(&context, spirv,
                             DescriptorTypesForShader(config.shader_path));
    pipeline.UpdateDescriptors(
        {buffer_a.descriptor(), buffer_b.descriptor(), buffer_c.descriptor(), buffer_d.descriptor()});

    auto reset_buffers = [&]() {
        buffer_a.Upload(a_bytes);
        buffer_b.Upload(b_bytes);
        buffer_c.Upload(c_bytes);
        buffer_d.Upload(d_init);
    };

    DispatchTimer timer(&context);
    for (uint32_t i = 0; i < config.warmup; ++i) {
        reset_buffers();
        (void)timer.Run(pipeline);
    }

    std::vector<double> samples;
    samples.reserve(config.repeat);
    for (uint32_t i = 0; i < config.repeat; ++i) {
        reset_buffers();
        samples.push_back(timer.Run(pipeline));
    }

    VerifyResult verify;
    if (config.verify) {
        const std::vector<float> expected = ReferenceOutput(config, a, b, c);
        const std::vector<float> actual = DecodeBuffer(buffer_d.Download(d_bytes_size), config.dtype);
        verify = CompareOutput(config, expected, actual);
    }

    PrintJson(config, ComputeStats(samples), verify);
    return 0;
}

} // namespace
} // namespace vk_hw

int main(int argc, char** argv)
{
    try {
        return vk_hw::Run(argc, argv);
    } catch (const std::exception& exc) {
        std::cerr << exc.what() << "\n";
        return 1;
    }
}
