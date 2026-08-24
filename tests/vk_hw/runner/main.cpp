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

#include <algorithm>
#include <array>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <optional>
#include <stdexcept>
#include <string>
#include <utility>
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

std::vector<VkDescriptorType> DescriptorTypesForShader(const std::string& shader_path)
{
    const bool has_extra_store = shader_path.find("_extrastore_") != std::string::npos;
    const bool has_shared_load = shader_path.find("_shared_load_") != std::string::npos;
    const uint32_t binding_count = has_shared_load ? 6u : (has_extra_store ? 5u : 4u);
    std::vector<VkDescriptorType> descriptor_types(binding_count, VK_DESCRIPTOR_TYPE_STORAGE_BUFFER);
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
    if (value == "extrastore")
        return CaseKind::kExtraStore;
    throw std::runtime_error("unknown case: " + value);
}

DType ParseDType(const std::string& value)
{
    if (value == "f16")
        return DType::kF16;
    if (value == "f32")
        return DType::kF32;
    if (value == "i8")
        return DType::kI8;
    if (value == "u8")
        return DType::kU8;
    if (value == "i16")
        return DType::kI16;
    if (value == "u16")
        return DType::kU16;
    if (value == "i32")
        return DType::kI32;
    if (value == "u32")
        return DType::kU32;
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
    size_t consumed = 0;
    const unsigned long parsed = std::stoul(value, &consumed);
    if (consumed != value.size()) {
        throw std::runtime_error(std::string(name) + " must be an unsigned integer");
    }
    if (parsed > UINT32_MAX) {
        throw std::runtime_error(std::string(name) + " exceeds uint32_t");
    }
    return static_cast<uint32_t>(parsed);
}

std::vector<uint32_t> ParseLayerDims(const std::string& value)
{
    std::vector<uint32_t> dims;
    size_t begin = 0;
    while (begin <= value.size()) {
        const size_t delimiter = value.find(',', begin);
        const std::string token = value.substr(begin, delimiter - begin);
        if (token.empty())
            throw std::runtime_error("--layer-dims must be a comma-separated list of non-zero dimensions");
        const uint32_t dim = ParseU32(token, "--layer-dims");
        if (dim == 0)
            throw std::runtime_error("--layer-dims dimensions must be greater than zero");
        dims.push_back(dim);
        if (delimiter == std::string::npos)
            break;
        begin = delimiter + 1;
    }
    return dims;
}

CaseConfig ParseArgs(int argc, char** argv)
{
    CaseConfig config;
    std::optional<DType> legacy_dtype;
    std::optional<DType> a_dtype;
    std::optional<DType> b_dtype;
    std::optional<DType> c_dtype;
    std::optional<DType> accum_dtype;
    std::optional<DType> activation_dtype;
    std::optional<std::vector<uint32_t>> layer_dims;
    std::array<std::optional<uint32_t>, 4> legacy_layer_dims;
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
            legacy_dtype = ParseDType(require_value("--dtype"));
        } else if (arg == "--a-dtype") {
            a_dtype = ParseDType(require_value("--a-dtype"));
        } else if (arg == "--b-dtype") {
            b_dtype = ParseDType(require_value("--b-dtype"));
        } else if (arg == "--c-dtype") {
            c_dtype = ParseDType(require_value("--c-dtype"));
        } else if (arg == "--accum-dtype") {
            accum_dtype = ParseDType(require_value("--accum-dtype"));
        } else if (arg == "--activation-dtype") {
            activation_dtype = ParseDType(require_value("--activation-dtype"));
        } else if (arg == "--packed-mlp-params") {
            config.packed_mlp_params = true;
        } else if (arg == "--m") {
            config.m = ParseU32(require_value("--m"), "--m");
        } else if (arg == "--n") {
            config.n = ParseU32(require_value("--n"), "--n");
        } else if (arg == "--k") {
            config.k = ParseU32(require_value("--k"), "--k");
        } else if (arg == "--layer-dims") {
            if (layer_dims.has_value())
                throw std::runtime_error("--layer-dims may only be specified once");
            layer_dims = ParseLayerDims(require_value("--layer-dims"));
        } else if (arg == "--d0") {
            legacy_layer_dims[0] = ParseU32(require_value("--d0"), "--d0");
        } else if (arg == "--d1") {
            legacy_layer_dims[1] = ParseU32(require_value("--d1"), "--d1");
        } else if (arg == "--d2") {
            legacy_layer_dims[2] = ParseU32(require_value("--d2"), "--d2");
        } else if (arg == "--d3") {
            legacy_layer_dims[3] = ParseU32(require_value("--d3"), "--d3");
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

    const bool has_legacy_layer_dims = std::any_of(legacy_layer_dims.begin(), legacy_layer_dims.end(),
                                                   [](const auto& dim) { return dim.has_value(); });
    if (layer_dims.has_value() && has_legacy_layer_dims) {
        throw std::runtime_error("--layer-dims cannot be combined with --d0 --d1 --d2 --d3");
    }
    if (layer_dims.has_value()) {
        config.layer_dims = std::move(*layer_dims);
    } else if (has_legacy_layer_dims) {
        config.layer_dims.reserve(legacy_layer_dims.size());
        for (const auto& dim : legacy_layer_dims)
            config.layer_dims.push_back(dim.value_or(0));
    }
    if (config.kind == CaseKind::kMlp &&
        (config.layer_dims.size() < 2 ||
         std::any_of(config.layer_dims.begin(), config.layer_dims.end(), [](uint32_t dim) { return dim == 0; }))) {
        throw std::runtime_error(
            "mlp case requires --layer-dims with at least two non-zero dimensions or --d0 --d1 --d2 --d3");
    }
    if (config.packed_mlp_params &&
        (config.kind != CaseKind::kMlp || config.layer_dims != std::vector<uint32_t>{10, 64, 16})) {
        throw std::runtime_error("--packed-mlp-params requires the 10,64,16 MLP fixture");
    }
    if (config.kind == CaseKind::kReduce && (config.m == 0 || config.n == 0)) {
        throw std::runtime_error("reduce case requires non-zero --m and --n");
    }
    const DType shorthand = legacy_dtype.value_or(DType::kF32);
    config.a_dtype = a_dtype.value_or(shorthand);
    config.b_dtype = b_dtype.value_or(shorthand);
    config.accum_dtype = accum_dtype.value_or(shorthand);
    config.c_dtype = c_dtype.value_or(config.accum_dtype);
    config.activation_dtype = activation_dtype.value_or(config.accum_dtype);
    config.dtype = config.accum_dtype;

    const bool float_inputs = IsFloatDType(config.a_dtype) && IsFloatDType(config.b_dtype) &&
                              IsFloatDType(config.c_dtype) && IsFloatDType(config.accum_dtype) &&
                              IsFloatDType(config.activation_dtype);
    const bool integer_inputs = !IsFloatDType(config.a_dtype) && !IsFloatDType(config.b_dtype) &&
                                !IsFloatDType(config.c_dtype) && !IsFloatDType(config.accum_dtype) &&
                                !IsFloatDType(config.activation_dtype);
    if (!float_inputs && !integer_inputs)
        throw std::runtime_error(
            "A, B, C, accumulator, and activation types must all be floating-point or all be integer");
    if (ElementBitWidth(config.accum_dtype) < ElementBitWidth(config.a_dtype) ||
        ElementBitWidth(config.accum_dtype) < ElementBitWidth(config.b_dtype) ||
        ElementBitWidth(config.accum_dtype) < ElementBitWidth(config.c_dtype) ||
        ElementBitWidth(config.accum_dtype) < ElementBitWidth(config.activation_dtype)) {
        throw std::runtime_error("accumulator type must not be narrower than A, B, C, or activation");
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

void PrintLayerDims(const std::vector<uint32_t>& dims)
{
    std::cout << "[";
    for (size_t i = 0; i < dims.size(); ++i) {
        if (i != 0)
            std::cout << ", ";
        std::cout << dims[i];
    }
    std::cout << "]";
}

void PrintJson(const CaseConfig& config, const TimeStats& stats, const VerifyResult& verify)
{
    const double gflops = stats.avg > 0.0 ? static_cast<double>(FlopCount(config)) / stats.avg : 0.0;

    std::cout << std::fixed << std::setprecision(6);
    std::cout << "{\n";
    std::cout << "  \"case\": \"" << CaseName(config.kind) << "\",\n";
    std::cout << "  \"shader\": \"" << JsonEscape(config.shader_path) << "\",\n";
    std::cout << "  \"dtype\": \"" << DTypeName(config.dtype) << "\",\n";
    std::cout << "  \"a_dtype\": \"" << DTypeName(config.a_dtype) << "\",\n";
    std::cout << "  \"b_dtype\": \"" << DTypeName(config.b_dtype) << "\",\n";
    std::cout << "  \"c_dtype\": \"" << DTypeName(config.c_dtype) << "\",\n";
    std::cout << "  \"accum_dtype\": \"" << DTypeName(config.accum_dtype) << "\",\n";
    std::cout << "  \"activation_dtype\": \"" << DTypeName(config.activation_dtype) << "\",\n";
    std::cout << "  \"status\": \"" << (verify.pass ? "pass" : "fail") << "\",\n";
    std::cout << "  \"skip_reason\": \"\",\n";
    std::cout << "  \"m\": " << config.m << ",\n";
    std::cout << "  \"n\": " << config.n << ",\n";
    std::cout << "  \"k\": " << config.k << ",\n";
    if (config.kind == CaseKind::kMlp) {
        std::cout << "  \"layer_dims\": ";
        PrintLayerDims(config.layer_dims);
        std::cout << ",\n";
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
    std::cout << "  \"gops_avg\": " << gflops << ",\n";
    std::cout << "  \"verify\": \"" << (verify.pass ? "pass" : "fail") << "\",\n";
    std::cout << "  \"max_abs_error\": " << verify.max_abs_error << ",\n";
    std::cout << "  \"max_rel_error\": " << verify.max_rel_error << "\n";
    std::cout << "}\n";
}

void PrintSkipJson(const CaseConfig& config, const std::string& reason)
{
    std::cout << "{\n";
    std::cout << "  \"case\": \"" << CaseName(config.kind) << "\",\n";
    std::cout << "  \"shader\": \"" << JsonEscape(config.shader_path) << "\",\n";
    std::cout << "  \"dtype\": \"" << DTypeName(config.dtype) << "\",\n";
    std::cout << "  \"a_dtype\": \"" << DTypeName(config.a_dtype) << "\",\n";
    std::cout << "  \"b_dtype\": \"" << DTypeName(config.b_dtype) << "\",\n";
    std::cout << "  \"c_dtype\": \"" << DTypeName(config.c_dtype) << "\",\n";
    std::cout << "  \"accum_dtype\": \"" << DTypeName(config.accum_dtype) << "\",\n";
    std::cout << "  \"activation_dtype\": \"" << DTypeName(config.activation_dtype) << "\",\n";
    std::cout << "  \"status\": \"skip\",\n";
    std::cout << "  \"skip_reason\": \"" << JsonEscape(reason) << "\",\n";
    std::cout << "  \"m\": " << config.m << ",\n";
    std::cout << "  \"n\": " << config.n << ",\n";
    std::cout << "  \"k\": " << config.k << ",\n";
    if (config.kind == CaseKind::kMlp) {
        std::cout << "  \"layer_dims\": ";
        PrintLayerDims(config.layer_dims);
        std::cout << ",\n";
    }
    if (config.kind == CaseKind::kReduce) {
        std::cout << "  \"axis\": \"" << ReduceAxisName(config.reduce_axis) << "\",\n";
        std::cout << "  \"reduce_op\": \"" << ReduceOpName(config.reduce_op) << "\",\n";
    }
    std::cout << "  \"warmup\": " << config.warmup << ",\n";
    std::cout << "  \"repeat\": " << config.repeat << ",\n";
    std::cout << "  \"gpu_time_ns_avg\": null,\n";
    std::cout << "  \"gflops_avg\": null,\n";
    std::cout << "  \"gops_avg\": null,\n";
    std::cout << "  \"verify\": \"skip\",\n";
    std::cout << "  \"max_abs_error\": 0.0,\n";
    std::cout << "  \"max_rel_error\": 0.0\n";
    std::cout << "}\n";
}

std::string MissingFeature(const VulkanContext& context, DType dtype)
{
    switch (dtype) {
    case DType::kF16:
        if (!context.supports_shader_float16())
            return "shaderFloat16";
        if (!context.supports_storage_buffer_16bit())
            return "storageBuffer16BitAccess";
        break;
    case DType::kI8:
    case DType::kU8:
        if (!context.supports_shader_int8())
            return "shaderInt8";
        if (!context.supports_storage_buffer_8bit())
            return "storageBuffer8BitAccess";
        break;
    case DType::kI16:
    case DType::kU16:
        if (!context.supports_shader_int16())
            return "shaderInt16";
        if (!context.supports_storage_buffer_16bit())
            return "storageBuffer16BitAccess";
        break;
    case DType::kF32:
    case DType::kI32:
    case DType::kU32:
        break;
    }
    return {};
}

int Run(int argc, char** argv)
{
    const CaseConfig config = ParseArgs(argc, argv);
    const std::vector<uint32_t> spirv = ReadSpirv(config.shader_path);

    const RawValues a = MakeRawInput(ElementCountA(config), 1, config.a_dtype);
    const RawValues b = MakeRawInput(ElementCountB(config), 2, config.b_dtype);
    const RawValues c = MakeRawInput(ElementCountC(config), 3, config.c_dtype);
    const std::vector<uint8_t> a_bytes = EncodeRawBuffer(a, config.a_dtype);
    std::vector<uint8_t> b_bytes;
    const std::vector<uint8_t> c_bytes = EncodeRawBuffer(c, config.c_dtype);
    if (config.packed_mlp_params) {
        if (config.b_dtype != DType::kF16 || config.c_dtype != DType::kF16) {
            throw std::runtime_error("--packed-mlp-params requires f16 weights and biases");
        }
        b_bytes = EncodeNeuralMlpParameterBuffer(b, c);
        if (b_bytes.empty())
            throw std::runtime_error("invalid weight or bias count for packed neural MLP parameters");
    } else
        b_bytes = EncodeRawBuffer(b, config.b_dtype);
    const size_t d_bytes_size = ElementCountD(config) * ElementSize(config.accum_dtype);
    const std::vector<uint8_t> d_init(d_bytes_size, 0);

    VulkanContext context;
    for (DType dtype : {config.a_dtype, config.b_dtype, config.c_dtype, config.accum_dtype, config.activation_dtype}) {
        const std::string missing = MissingFeature(context, dtype);
        if (!missing.empty()) {
            PrintSkipJson(config, DTypeName(dtype) + " case requires Vulkan feature " + missing);
            return 0;
        }
    }
    if (config.shader_path.find("_ubo_") != std::string::npos && !context.supports_scalar_block_layout()) {
        PrintSkipJson(config, "UBO case requires Vulkan feature scalarBlockLayout");
        return 0;
    }

    Buffer buffer_a(&context, a_bytes.size());
    Buffer buffer_b(&context, b_bytes.size());
    Buffer buffer_c(&context, c_bytes.size());
    Buffer buffer_d(&context, d_init.size());

    const bool has_extra_store = config.kind == CaseKind::kExtraStore;
    const bool has_shared_load = config.shader_path.find("_shared_load_") != std::string::npos;
    const bool has_value_arg = config.shader_path.find("_value_arg_") != std::string::npos;
    // Extra-store writes B to E. Shared-load writes its second result to E.
    const size_t e_bytes_size = has_extra_store ? b_bytes.size() : (has_shared_load ? d_bytes_size : 0);
    const std::vector<uint8_t> e_init(e_bytes_size, 0);
    Buffer buffer_e(&context, e_bytes_size == 0 ? 1 : e_bytes_size);

    ComputePipeline pipeline(&context, spirv, DescriptorTypesForShader(config.shader_path));
    std::vector<VkDescriptorBufferInfo> desc_infos;
    if (has_shared_load) {
        desc_infos = {buffer_a.descriptor(), buffer_b.descriptor(), buffer_c.descriptor(),
                      buffer_c.descriptor(), buffer_d.descriptor(), buffer_e.descriptor()};
    } else if (has_value_arg) {
        desc_infos = {buffer_a.descriptor(), buffer_c.descriptor(), buffer_d.descriptor(), buffer_b.descriptor()};
    } else {
        desc_infos = {buffer_a.descriptor(), buffer_b.descriptor(), buffer_c.descriptor(), buffer_d.descriptor()};
    }
    if (has_extra_store) {
        desc_infos.push_back(buffer_e.descriptor());
    }
    pipeline.UpdateDescriptors(desc_infos);

    auto reset_buffers = [&]() {
        buffer_a.Upload(a_bytes);
        buffer_b.Upload(b_bytes);
        buffer_c.Upload(c_bytes);
        buffer_d.Upload(d_init);
        if (has_extra_store || has_shared_load)
            buffer_e.Upload(e_init);
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
        const RawValues expected = ReferenceOutputRaw(config, a, b, c);
        const RawValues actual = DecodeRawBuffer(buffer_d.Download(d_bytes_size), config.accum_dtype);
        verify = CompareOutputRaw(config, expected, actual);
        if (has_extra_store && verify.pass) {
            const RawValues expected_e = b;
            const RawValues actual_e = DecodeRawBuffer(buffer_e.Download(e_bytes_size), config.b_dtype);
            verify = CompareOutputRaw(config, expected_e, actual_e);
        } else if (has_shared_load && verify.pass) {
            const RawValues actual_e = DecodeRawBuffer(buffer_e.Download(e_bytes_size), config.accum_dtype);
            verify = CompareOutputRaw(config, expected, actual_e);
        }
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
