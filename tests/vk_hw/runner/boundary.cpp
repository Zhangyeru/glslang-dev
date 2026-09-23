// Copyright (C) 2026 The Khronos Group Inc.
// SPDX-License-Identifier: BSD-3-Clause
#include "boundary.h"

#include <algorithm>
#include <cstring>
#include <stdexcept>

namespace vk_hw {
namespace {
uint64_t Raw(float value, DType type)
{
    if (type == DType::kF16)
        return FloatToHalfBits(value);
    if (type == DType::kF32) {
        uint32_t bits;
        std::memcpy(&bits, &value, sizeof(bits));
        return bits;
    }
    return uint32_t(int32_t(value)) & ((uint64_t{1} << ElementBitWidth(type)) - 1);
}

RawValues Samples(size_t count, DType type, unsigned seed)
{
    RawValues result(count);
    const int signed_samples[] = {-128, -1, 0, 1, 127};
    const int unsigned_samples[] = {0, 1, 128, 254, 255};
    for (size_t i = 0; i < count; ++i) {
        const float value = IsFloatDType(type) ? float(int((i * 3 + seed) % 13) - 6) / 8
                            : type == DType::kU8 ? float(unsigned_samples[(i + seed) % 5])
                            : type == DType::kI8 ? float(signed_samples[(i + seed) % 5])
                                                : float(int(i % 3) * 257 - 257);
        result[i] = Raw(value, type);
    }
    return result;
}
} // namespace

DType BoundaryType(const std::string& type)
{
    if (type == "float16_t") return DType::kF16;
    if (type == "float") return DType::kF32;
    if (type == "int8_t") return DType::kI8;
    if (type == "uint8_t") return DType::kU8;
    if (type == "int") return DType::kI32;
    throw std::runtime_error("unknown boundary scalar type: " + type);
}

BoundaryData MakeBoundaryData(const BoundaryCase& t, unsigned dataset, unsigned control)
{
    if (dataset >= 3 || control >= t.controls())
        throw std::runtime_error("invalid boundary dataset/control");
    CaseConfig config;
    config.kind = t.kind == 1 ? CaseKind::kMatmul : CaseKind::kVecMatmulAdd;
    config.m = t.m;
    config.n = t.n;
    config.k = t.k;
    config.a_dtype = BoundaryType(t.a);
    config.b_dtype = BoundaryType(t.b);
    config.dtype = config.c_dtype = config.accum_dtype = BoundaryType(t.output);
    config.activation_dtype = config.a_dtype;
    BoundaryData data;
    data.a = Samples(t.m * t.k, config.a_dtype, dataset + 1);
    data.b = Samples(t.k * t.n, config.b_dtype, dataset + 2);
    data.c = Samples(t.m * t.n, config.c_dtype, dataset + 3);
    data.exact = !IsFloatDType(config.dtype) || dataset == 1 || t.kind == 8 || t.kind == 9;
    if (dataset == 1) {
        std::fill(data.a.begin(), data.a.end(), Raw(0, config.a_dtype));
        for (unsigned row = 0; row < t.m; ++row)
            data.a[(row + 1) * t.k - 1] = Raw(float(row + 1), config.a_dtype);
        std::fill(data.c.begin(), data.c.end(), Raw(0, config.c_dtype));
    }
    RawValues expected;
    if (t.kind == 9) {
        data.a = Samples(t.m * t.n, config.a_dtype, dataset);
        expected = data.a;
    } else if (t.kind == 2) {
        data.a = Samples(t.n, config.a_dtype, dataset);
        data.b = Samples(t.n, config.b_dtype, dataset + 3);
        expected.resize(t.n);
        for (unsigned i = 0; i < t.n; ++i) {
            const float a = HalfBitsToFloat(uint16_t(data.a[i]));
            const float b = HalfBitsToFloat(uint16_t(data.b[i]));
            expected[i] = Raw(std::max(0.0f, (a + b) * 0.5f), config.dtype);
        }
        data.exact = true;
    } else if (t.kind == 6) {
        const unsigned h = t.hidden;
        data.a.resize(h);
        for (unsigned i = 0; i < h; ++i)
            data.a[i] = Raw(float((i + dataset) % 7 + 1) / 4, config.a_dtype);
        data.b.assign(2 * h * h + h * t.n, Raw(0, config.b_dtype));
        data.c.assign(h + t.n + 1, Raw(0, config.c_dtype));
        for (unsigned i = 0; i < h; ++i) {
            data.b[i * h + i] = Raw(1, config.b_dtype);
            data.b[h * h + i * h + i] = Raw(2, config.b_dtype);
        }
        for (unsigned j = 0; j < t.n; ++j) {
            data.b[2 * h * h + j] = Raw(float(j + 1) / 4, config.b_dtype);
            data.b[2 * h * h + (h - 1) * t.n + j] = Raw(1, config.b_dtype);
        }
        RawValues state = data.a;
        CaseConfig step = config;
        step.k = step.n = h;
        const size_t start = (control & 1) * h * h;
        const RawValues weights(data.b.begin() + start, data.b.begin() + start + h * h);
        const RawValues bias(data.c.begin(), data.c.begin() + h);
        for (unsigned iteration = 0; iteration < control / 2; ++iteration)
            state = ReferenceOutputRaw(step, state, weights, bias);
        config.k = h;
        expected = ReferenceOutputRaw(config, state, RawValues(data.b.begin() + 2 * h * h, data.b.end()),
                                      RawValues(t.n, Raw(0, config.dtype)));
        data.c[h + t.n] = Raw(float(control), config.c_dtype);
        data.exact = true;
    } else if (t.kind == 7) {
        config.kind = CaseKind::kMlp;
        config.layer_dims = {t.k, t.hidden, t.n};
        config.c_dtype = config.b_dtype;
        RawValues weights = Samples(t.k * t.hidden + t.hidden * t.n, config.b_dtype, dataset + 1);
        RawValues bias = Samples(t.hidden + t.n, config.b_dtype, dataset + 2);
        if (dataset == 2) {
            std::fill(data.a.begin(), data.a.end(), Raw(0, config.a_dtype));
            data.a[0] = data.a[1] = Raw(1, config.a_dtype);
            std::fill(weights.begin(), weights.end(), Raw(0, config.b_dtype));
            std::fill(bias.begin(), bias.end(), Raw(0, config.b_dtype));
            weights[0] = Raw(1, config.b_dtype);
            weights[t.hidden] = Raw(0x1p-11f, config.b_dtype);
            bias[1] = Raw(-0x1p-14f, config.b_dtype);
            bias[t.hidden - 1] = Raw(0x1p-14f, config.b_dtype);
            for (unsigned j = 0; j < t.n; ++j)
                weights[t.k * t.hidden + j] = Raw(32, config.b_dtype);
            data.exact = true;
        }
        expected = ReferenceOutputRaw(config, data.a, weights, bias);
        CaseConfig first = config;
        first.layer_dims = {t.k, t.hidden};
        const auto hidden = ReferenceOutputRaw(first, data.a, weights, bias);
        data.cache_expected.assign(t.hidden + 2, Raw(-123, config.a_dtype));
        for (unsigned i = 0; i < t.hidden; ++i) {
            const uint32_t bits = uint32_t(hidden[i]);
            float value;
            std::memcpy(&value, &bits, sizeof(value));
            data.cache_expected[i + 1] = Raw(value, config.a_dtype);
        }
        data.b = weights;
        data.b.insert(data.b.end(), bias.begin(), bias.end());
        data.c.assign(t.hidden + 2, Raw(-123, config.a_dtype));
    } else if (t.kind == 8) {
        data.a = {Raw(4097, config.a_dtype), Raw(0, config.a_dtype)};
        data.b = {Raw(4097, config.b_dtype), Raw(4097, config.b_dtype), Raw(0, config.b_dtype),
                  Raw(0, config.b_dtype)};
        data.c.assign(t.n, Raw(-16785408, config.c_dtype));
        // Explicit volatile intermediates prevent the host compiler from fusing.
        volatile float product = 4097.0f * 4097.0f;
        volatile float sum = product + -16785408.0f;
        expected.assign(t.n, Raw(sum, config.dtype));
    } else {
        RawValues a = data.a, weights = data.b;
        if (t.kind == 3) {
            const unsigned offset = t.offset == 3 ? control * 3 : t.offset == 2 ? 3 : t.offset;
            data.a = Samples(t.k + 3, config.a_dtype, dataset);
            a.assign(data.a.begin() + offset, data.a.begin() + offset + t.k);
            // Fill the entire padded allocation, then select only the logical tile.
            data.b = Samples((t.k + 3) * (t.n + 3), config.b_dtype, dataset + 5);
            for (unsigned i = 0; i < t.k; ++i) {
                for (unsigned j = 0; j < t.n; ++j) {
                    const size_t address = t.layout == 0 ? (i + offset) * (t.n + 3) + j + offset
                                                         : (j + offset) * (t.k + 3) + i + offset;
                    weights[i * t.n + j] = data.b[address];
                }
            }
            data.c.push_back(Raw(float(offset), config.c_dtype));
        }
        if (t.kind == 5) {
            weights[control ? t.k * t.n - 1 : 0] = Raw(4, config.b_dtype);
            data.c.push_back(Raw(float(control), config.c_dtype));
        }
        // Snapshot deliberately uses the original weights, never the later SSBO writes.
        expected = ReferenceOutputRaw(config, a, weights, data.c);
    }
    // Both guard lanes are part of the downloaded allocation; comparison is bitwise.
    data.expected.assign(expected.size() + 2, Raw(-123, config.dtype));
    std::copy(expected.begin(), expected.end(), data.expected.begin() + 1);
    return data;
}
} // namespace vk_hw
