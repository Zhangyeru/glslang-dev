// Copyright (C) 2026 The Khronos Group Inc.
// SPDX-License-Identifier: BSD-3-Clause
#ifndef VK_HW_BOUNDARY_CASES_H
#define VK_HW_BOUNDARY_CASES_H

#include <string>
#include <vector>

namespace vk_hw {

// KIND is shared with the two independently written GLSL implementations.
// 0 projection, 1 batched matrix, 2 activation, 3 parameter slice,
// 4 load snapshot, 5 value mutation, 6 expert route, 7 mixed MLP,
// 8 precise projection, 9 memory-only threshold probe.
struct BoundaryCase {
    const char* name;
    unsigned kind, m, n, k;
    const char* a = "float16_t";
    const char* b = "float16_t";
    const char* output = "float16_t";
    unsigned hidden = 16;
    unsigned layout = 0;
    // Slice: 0 constant zero, 1 constant one, 2 last legal, 3 runtime first/last.
    unsigned offset = 0;

    std::vector<std::string> defines() const
    {
        return {"KIND=" + std::to_string(kind), "M=" + std::to_string(m), "N=" + std::to_string(n),
                "K=" + std::to_string(k), "H=" + std::to_string(hidden), "AT=" + std::string(a),
                "BT=" + std::string(b), "OT=" + std::string(output), "LAYOUT=" + std::to_string(layout),
                "OFFSET_KIND=" + std::to_string(offset)};
    }

    std::vector<std::string> modes() const
    {
        std::vector<std::string> result = {"", "scalar"};
        if (kind == 2 && n >= 127) {
            result.push_back("unroll-elements=128");
            result.push_back("scalar,unroll-elements=128");
        }
        if (std::string(name) == "mac_f16_64x64" || kind == 9) {
            for (const char* prefix : {"", "scalar,"}) {
                for (unsigned limit : {4095, 4096, 4097})
                    result.push_back(std::string(prefix) + (kind == 9 ? "unroll-elements=" : "unroll-macs=") +
                                     std::to_string(limit));
            }
        }
        return result;
    }

    unsigned controls() const { return kind == 6 ? 6 : (kind == 3 && offset == 3) || kind == 5 ? 2 : 1; }
};

inline const std::vector<BoundaryCase>& BoundaryCases()
{
    static const std::vector<BoundaryCase> cases = {
        {"head_f16_16x1", 0, 1, 1, 16},
        {"head_f16_16x2", 0, 1, 2, 16},
        {"head_f16_16x3", 0, 1, 3, 16},
        {"channels_f16_64x63", 0, 1, 63, 64},
        {"mac_f16_64x64", 0, 1, 64, 64},
        {"channels_f16_64x65", 0, 1, 65, 64},
        {"channels_f16_63x64", 0, 1, 64, 63},
        {"channels_f16_65x64", 0, 1, 64, 65},
        {"batch_f16_1x16x16", 1, 1, 16, 16},
        {"batch_f16_2x16x16", 1, 2, 16, 16},
        {"batch_f16_3x16x16", 1, 3, 16, 16},
        {"batch_f16_3x17x15", 1, 3, 17, 15},
        {"direct_f32_16x15", 0, 1, 15, 16, "float", "float", "float"},
        {"direct_f32_16x16", 0, 1, 16, 16, "float", "float", "float"},
        {"direct_f32_16x17", 0, 1, 17, 16, "float", "float", "float"},
        {"direct_f32_8x15x16", 1, 8, 15, 16, "float", "float", "float"},
        {"direct_f32_8x7x16", 1, 8, 7, 16, "float", "float", "float"},
        {"direct_f32_8x8x16", 1, 8, 8, 16, "float", "float", "float"},
        {"direct_f32_8x9x16", 1, 8, 9, 16, "float", "float", "float"},
        {"direct_f32_8x16x16", 1, 8, 16, 16, "float", "float", "float"},
        {"direct_f32_8x17x16", 1, 8, 17, 16, "float", "float", "float"},
        {"activation_f16_63", 2, 1, 63, 63},
        {"activation_f16_64", 2, 1, 64, 64},
        {"activation_f16_65", 2, 1, 65, 65},
        {"activation_f16_127", 2, 1, 127, 127},
        {"activation_f16_128", 2, 1, 128, 128},
        {"activation_f16_129", 2, 1, 129, 129},
        {"slice_row_zero", 3, 1, 16, 16, "float16_t", "float16_t", "float16_t", 16, 0, 0},
        {"slice_row_one", 3, 1, 16, 16, "float16_t", "float16_t", "float16_t", 16, 0, 1},
        {"slice_row_last", 3, 1, 16, 16, "float16_t", "float16_t", "float16_t", 16, 0, 2},
        {"slice_row_dynamic", 3, 1, 16, 16, "float16_t", "float16_t", "float16_t", 16, 0, 3},
        {"slice_column_zero", 3, 1, 16, 16, "float16_t", "float16_t", "float16_t", 16, 1, 0},
        {"slice_column_one", 3, 1, 16, 16, "float16_t", "float16_t", "float16_t", 16, 1, 1},
        {"slice_column_last", 3, 1, 16, 16, "float16_t", "float16_t", "float16_t", 16, 1, 2},
        {"slice_column_dynamic", 3, 1, 16, 16, "float16_t", "float16_t", "float16_t", 16, 1, 3},
        {"snapshot_f16_16x16", 4, 1, 16, 16},
        {"mutation_f16_16x16", 5, 1, 16, 16},
        {"route_f16_16x16x4", 6, 1, 4, 16},
        {"rounding_10x64x16", 7, 1, 16, 10, "float16_t", "float16_t", "float", 64},
        {"rounding_10x65x3", 7, 1, 3, 10, "float16_t", "float16_t", "float", 65},
        {"precise_f32_2x2", 8, 1, 2, 2, "float", "float", "float"},
        {"memory_f16_64x64", 9, 64, 64, 1},
        {"quant_i8i8_31x3", 0, 1, 3, 31, "int8_t", "int8_t", "int"},
        {"quant_i8i8_32x3", 0, 1, 3, 32, "int8_t", "int8_t", "int"},
        {"quant_i8i8_33x3", 0, 1, 3, 33, "int8_t", "int8_t", "int"},
        {"quant_u8i8_31x3", 0, 1, 3, 31, "uint8_t", "int8_t", "int"},
        {"quant_u8i8_32x3", 0, 1, 3, 32, "uint8_t", "int8_t", "int"},
        {"quant_u8i8_33x3", 0, 1, 3, 33, "uint8_t", "int8_t", "int"},
        {"quant_i8u8_31x3", 0, 1, 3, 31, "int8_t", "uint8_t", "int"},
        {"quant_i8u8_32x3", 0, 1, 3, 32, "int8_t", "uint8_t", "int"},
        {"quant_i8u8_33x3", 0, 1, 3, 33, "int8_t", "uint8_t", "int"},
        {"quant_i8u8_1024x3", 0, 1, 3, 1024, "int8_t", "uint8_t", "int"},
    };
    return cases;
}

} // namespace vk_hw
#endif
