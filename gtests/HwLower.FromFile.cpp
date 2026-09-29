// Copyright (C) 2026 The Khronos Group Inc.
// SPDX-License-Identifier: BSD-3-Clause

#include "SPIRV/GLSL.std.450.h"
#include "TestFixture.h"
#include "../tests/vk_hw/runner/boundary_cases.h"

#include <functional>
#include <unordered_map>
#include <unordered_set>

#if ENABLE_OPT
#include "spirv-tools/optimizer.hpp"
#endif

namespace glslangtest {
namespace {

struct HwLowerCase {
    const char* name;
    unsigned width;
};

void PrintTo(const HwLowerCase& test, std::ostream* stream) { *stream << test.name << ", WIDTH=" << test.width; }

using HwExtensionFreeTest = GlslangTest<::testing::TestWithParam<HwLowerCase>>;

bool IsLanguageCase(const std::string& name)
{
    return name == "switch_return" || name == "do_break" || name == "private_nested" || name == "workgroup" ||
           name == "conversion_extinst" || name == "ssa";
}

#if ENABLE_OPT
// Inspect parsed IDs and types, not debug names or unrelated scalar operations.
struct HwInstruction {
    std::string op;
    uint32_t type;
    uint32_t id;
    std::vector<uint32_t> words;
};

class HwModule {
public:
    explicit HwModule(const std::vector<uint32_t>& binary)
    {
        spv_context context = spvContextCreate(SPV_ENV_VULKAN_1_3);
        const auto status = spvBinaryParse(
            context, this, binary.data(), binary.size(), nullptr,
            [](void* data, const spv_parsed_instruction_t* inst) -> spv_result_t {
                auto& module = *static_cast<HwModule*>(data);
                if (inst->result_id)
                    module.definitions[inst->result_id] = module.instructions.size();
                module.instructions.push_back({std::string("Op") + spvOpcodeString(inst->opcode),
                                               inst->type_id,
                                               inst->result_id,
                                               {inst->words, inst->words + inst->num_words}});
                return SPV_SUCCESS;
            },
            nullptr);
        EXPECT_EQ(SPV_SUCCESS, status);
        spvContextDestroy(context);
    }

    const HwInstruction* definition(uint32_t id) const
    {
        const auto found = definitions.find(id);
        return found == definitions.end() ? nullptr : &instructions[found->second];
    }

    bool containsHw(uint32_t type) const
    {
        std::unordered_set<uint32_t> visited;
        std::function<bool(uint32_t)> visit = [&](uint32_t id) {
            const auto* inst = definition(id);
            if (!inst || !visited.insert(id).second)
                return false;
            if (inst->op == "OpTypeCooperativeVectorHW" || inst->op == "OpTypeCooperativeMatrixHW")
                return true;
            if (inst->op == "OpTypePointer")
                return visit(inst->words[3]);
            if (inst->op == "OpTypeArray" || inst->op == "OpTypeRuntimeArray")
                return visit(inst->words[2]);
            if (inst->op == "OpTypeStruct" || inst->op == "OpTypeFunction") {
                for (size_t i = 2; i < inst->words.size(); ++i) {
                    if (visit(inst->words[i]))
                        return true;
                }
            }
            return false;
        };
        return visit(type);
    }

    bool typeIs(uint32_t type, const std::string& op) const
    {
        const auto* inst = definition(type);
        return inst && inst->op == op;
    }

    uint32_t pointerRoot(uint32_t id) const
    {
        const auto* inst = definition(id);
        while (inst && inst->op == "OpAccessChain") {
            id = inst->words[3];
            inst = definition(id);
        }
        return id;
    }

    bool pointerStorage(uint32_t id, spv::StorageClass storage) const
    {
        const auto* value = definition(id);
        const auto* type = value ? definition(value->type) : nullptr;
        return type && type->op == "OpTypePointer" && type->words[2] == uint32_t(storage);
    }

    size_t count(const std::string& op, const std::function<bool(const HwInstruction&)>& predicate = {}) const
    {
        return std::count_if(instructions.begin(), instructions.end(), [&](const HwInstruction& inst) {
            return inst.op == op && (!predicate || predicate(inst));
        });
    }

    size_t hwCount(const std::string& op) const
    {
        return count(op, [&](const HwInstruction& inst) {
            if (containsHw(inst.type))
                return true;
            if (op == "OpStore" || op == "OpReturnValue") {
                const auto* value = definition(inst.words[op == "OpStore" ? 2 : 1]);
                return value && containsHw(value->type);
            }
            return false;
        });
    }

    size_t mathCount(const std::string& op, const std::string& typeOp) const
    {
        return count(op, [&](const HwInstruction& inst) { return typeIs(inst.type, typeOp); });
    }

    bool decorated(uint32_t id, spv::Decoration decoration) const
    {
        return count("OpDecorate", [&](const HwInstruction& inst) {
                   return inst.words[1] == id && inst.words[2] == uint32_t(decoration);
               }) != 0;
    }

    // Whole-value reads must survive writes through a derived component pointer.
    // Check instruction order and the same pointer ID, rather than just counting loads.
    uint32_t componentWriteThenWholeLoadRoot(uint32_t requiredRoot = 0) const
    {
        std::unordered_set<uint32_t> writtenRoots;
        for (const auto& inst : instructions) {
            if (inst.op == "OpStore") {
                const auto* pointer = definition(inst.words[1]);
                const auto* value = definition(inst.words[2]);
                if (pointer && pointer->op == "OpAccessChain" && value && typeIs(value->type, "OpTypeFloat"))
                    writtenRoots.insert(pointer->words[3]);
            }
            if (inst.op == "OpLoad" && writtenRoots.count(inst.words[3]) &&
                (requiredRoot == 0 || requiredRoot == inst.words[3]) &&
                (containsHw(inst.type) || typeIs(inst.type, "OpTypeArray")))
                return inst.words[3];
        }
        return 0;
    }

    std::vector<uint32_t> multiBlockTransportLoads() const
    {
        std::unordered_map<uint32_t, std::unordered_set<uint32_t>> pointerBlocks;
        uint32_t block = 0;
        for (const auto& inst : instructions) {
            if (inst.op == "OpLabel")
                block = inst.id;
            const uint32_t pointer = inst.op == "OpLoad" ? inst.words[3] : inst.op == "OpStore" ? inst.words[1] : 0;
            const auto* variable = definition(pointer);
            if (variable && variable->op == "OpVariable" && containsHw(variable->type))
                pointerBlocks[pointer].insert(block);
        }
        std::vector<uint32_t> loads;
        for (const auto& inst : instructions) {
            if (inst.op == "OpLoad" && containsHw(inst.type) && pointerBlocks[inst.words[3]].size() > 1)
                loads.push_back(inst.id);
        }
        return loads;
    }

    void expectNoHw(const std::string& assembly) const
    {
        for (const auto& inst : instructions) {
            EXPECT_FALSE(inst.op.size() >= 2 && inst.op.substr(inst.op.size() - 2) == "HW") << inst.op;
            EXPECT_FALSE(containsHw(inst.type));
            EXPECT_NE("OpCompositeConstructReplicateEXT", inst.op);
            EXPECT_NE("OpConstantCompositeReplicateEXT", inst.op);
            EXPECT_NE("OpSpecConstantCompositeReplicateEXT", inst.op);
            if (inst.op == "OpSelectionMerge") {
                EXPECT_EQ(0u, inst.words[2] & uint32_t(spv::SelectionControlRelregMask));
            }
        }
        // Only inspect declaration operands; names and source strings are not residue.
        std::istringstream lines(assembly);
        std::string line;
        while (std::getline(lines, line)) {
            std::istringstream tokens(line);
            std::string op, operand;
            tokens >> op >> operand;
            if (op != "OpCapability" && op != "OpExtension" && op != "OpSourceExtension")
                continue;
            EXPECT_EQ(std::string::npos, operand.find("HW")) << line;
            EXPECT_EQ(std::string::npos, operand.find("AZD")) << line;
            EXPECT_EQ(std::string::npos, operand.find("ReplicatedComposites")) << line;
            EXPECT_EQ(std::string::npos, operand.find("replicated_composites")) << line;
        }
    }

    std::vector<HwInstruction> instructions;
    std::unordered_map<uint32_t, size_t> definitions;
};

void CheckInput(const HwModule& module, const std::string& name)
{
    if (name == "large_struct") {
        EXPECT_GT(module.count("OpConstantCompositeReplicateEXT",
                               [&](const HwInstruction& inst) {
                                   return module.typeIs(inst.type, "OpTypeStruct") && module.containsHw(inst.type);
                               }),
                  0u);
        return;
    }
    EXPECT_GT(module.hwCount("OpLoad"), 0u);
    EXPECT_GT(module.hwCount("OpStore"), 0u);
    if (name == "switch_return") {
        EXPECT_EQ(1u, module.count("OpSwitch"));
        EXPECT_GE(module.hwCount("OpReturnValue"), 2u);
        EXPECT_GT(module.hwCount("OpFunctionParameter"), 0u);
        EXPECT_GT(module.hwCount("OpFunctionCall"), 0u);
        for (const char* op : {"OpFAdd", "OpFMul", "OpFNegate"})
            EXPECT_GT(module.hwCount(op), 0u) << op;
    }
    if (name == "do_break") {
        EXPECT_EQ(1u, module.count("OpLoopMerge"));
        EXPECT_GE(module.count("OpBranchConditional"), 3u);
        EXPECT_GT(module.hwCount("OpFAdd"), 0u);
        EXPECT_GT(module.hwCount("OpFNegate"), 0u);
        EXPECT_FALSE(module.multiBlockTransportLoads().empty());
    }
    if (name == "private_nested") {
        EXPECT_GE(module.count("OpTypeStruct", [&](const HwInstruction& inst) { return module.containsHw(inst.id); }),
                  2u);
        EXPECT_EQ(1u, module.count("OpVariable", [&](const HwInstruction& inst) {
            return module.containsHw(inst.type) && module.pointerStorage(inst.id, spv::StorageClassPrivate);
        }));
        EXPECT_GT(module.count("OpStore",
                               [&](const HwInstruction& inst) {
                                   const auto* pointer = module.definition(inst.words[1]);
                                   const auto* value = module.definition(inst.words[2]);
                                   return pointer && pointer->op == "OpAccessChain" && pointer->words.size() == 8 &&
                                          module.pointerStorage(pointer->id, spv::StorageClassPrivate) && value &&
                                          module.typeIs(value->type, "OpTypeFloat") &&
                                          module.containsHw(module.definition(module.pointerRoot(pointer->id))->type);
                               }),
                  0u);
        EXPECT_EQ(1u, module.count("OpFunctionCall")); // The cross-function mutation.
        EXPECT_EQ(2u, module.count("OpCooperativeVectorStoreHW"));
    }
    if (name == "workgroup") {
        EXPECT_EQ(2u, module.count("OpControlBarrier"));
        for (const auto& inst : module.instructions) {
            if (inst.op == "OpCooperativeVectorLoadHW" || inst.op == "OpCooperativeVectorStoreHW") {
                const uint32_t pointer = inst.words[inst.op == "OpCooperativeVectorLoadHW" ? 3 : 1];
                EXPECT_TRUE(module.pointerStorage(pointer, spv::StorageClassWorkgroup));
            }
            if (inst.op == "OpVariable" && module.pointerStorage(inst.id, spv::StorageClassWorkgroup)) {
                EXPECT_FALSE(module.containsHw(inst.type));
            }
        }
        EXPECT_GT(module.hwCount("OpFAdd"), 0u);
    }
    if (name == "conversion_extinst") {
        for (const char* op : {"OpConvertFToS", "OpConvertSToF", "OpIAdd", "OpIMul"})
            EXPECT_GT(module.hwCount(op), 0u) << op;
        EXPECT_EQ(2u, module.hwCount("OpBitcast"));
        EXPECT_EQ(1u, module.count("OpExtInst", [&](const HwInstruction& inst) {
            const auto* set = module.definition(inst.words[3]);
            return module.containsHw(inst.type) && inst.words[4] == GLSLstd450FClamp && set &&
                   set->op == "OpExtInstImport" &&
                   std::string(reinterpret_cast<const char*>(&set->words[2])) == "GLSL.std.450";
        }));
    }
    if (name == "alias") {
        EXPECT_NE(0u, module.componentWriteThenWholeLoadRoot());
    }
    if (name == "branch" || name == "loop" || name == "integer" || name == "precise" || name == "volatile") {
        EXPECT_GT(module.count("OpSelectionMerge"), 0u);
    }
    if (name == "branch" || name == "integer" || name == "precise") {
        EXPECT_EQ(0u, module.hwCount("OpSelect")); // Matrix ternaries are memory-backed.
    }
    if (name == "loop") {
        EXPECT_GT(module.count("OpLoopMerge"), 0u);
        EXPECT_GT(module.hwCount("OpFAdd"), 0u);
        EXPECT_GT(module.hwCount("OpFSub"), 0u);
    }
    if (name == "aggregate" || name == "integer" || name == "precise") {
        EXPECT_GT(module.hwCount("OpFunctionParameter"), 0u);
        EXPECT_GT(module.hwCount("OpFunctionCall"), 0u);
        EXPECT_GT(module.hwCount("OpReturnValue"), 0u);
    }
    if (name == "aggregate") {
        EXPECT_GE(module.count("OpTypeStruct", [&](const HwInstruction& inst) { return module.containsHw(inst.id); }),
                  2u);
        EXPECT_GT(module.hwCount("OpAccessChain"), 0u);
    }
    if (name == "select" || name == "copy") {
        EXPECT_GT(module.hwCount("OpSelect"), 0u);
    }
    if (name == "copy") {
        EXPECT_GT(module.hwCount("OpCopyObject"), 0u);
        EXPECT_GT(module.count("OpCopyObject",
                               [&](const HwInstruction& inst) {
                                   return module.containsHw(inst.type) &&
                                          module.decorated(inst.id, spv::DecorationNonUniform);
                               }),
                  0u);
    }
    if (name == "integer" || name == "precise") {
        EXPECT_GT(module.count("OpCooperativeMatrixMulAddHW"), 0u);
    }
    if (name == "precise") {
        EXPECT_GT(module.count("OpCooperativeMatrixMulAddHW",
                               [&](const HwInstruction& inst) {
                                   return module.decorated(inst.id, spv::DecorationNoContraction);
                               }),
                  0u);
    }
    if (name == "precise_arithmetic" || name == "precise_matrix_arithmetic") {
        EXPECT_GT(module.count("OpFAdd",
                               [&](const HwInstruction& inst) {
                                   return module.containsHw(inst.type) &&
                                          module.decorated(inst.id, spv::DecorationNoContraction);
                               }),
                  0u);
        EXPECT_GT(module.hwCount("OpFSub"), 0u);
    }
    if (name == "shared") {
        EXPECT_GT(module.count("OpCooperativeVectorMatrixMulHW"), 0u);
        EXPECT_GT(module.count("OpAccessChain",
                               [&](const HwInstruction& inst) {
                                   const auto* base = module.definition(inst.words[3]);
                                   return base && module.containsHw(base->type) && !module.containsHw(inst.type);
                               }),
                  0u);
    }
    if (name == "volatile") {
        for (const auto& inst : module.instructions) {
            size_t mask = 0;
            if (inst.op == "OpCooperativeVectorLoadHW")
                mask = 5;
            if (inst.op == "OpCooperativeVectorStoreHW")
                mask = 4;
            if (inst.op == "OpCooperativeMatrixLoadHW")
                mask = 7;
            if (inst.op == "OpCooperativeMatrixStoreHW")
                mask = 6;
            if (mask) {
                ASSERT_GT(inst.words.size(), mask);
                EXPECT_NE(0u, inst.words[mask] & uint32_t(spv::MemoryAccessVolatileMask));
            }
        }
    }
    if (name == "coherent") {
        EXPECT_EQ(2u, module.count("OpCooperativeVectorLoadHW", [&](const HwInstruction& inst) {
            return inst.words.size() == 7 && (inst.words[5] & uint32_t(spv::MemoryAccessMakePointerVisibleMask)) != 0 &&
                   (inst.words[5] & uint32_t(spv::MemoryAccessNonPrivatePointerMask)) != 0;
        }));
    }
}

void CheckOutput(const HwModule& module, const HwLowerCase& test, bool scalar, bool rolled, uint32_t aliasRoot)
{
    const std::string name = test.name;
    if (scalar) {
        EXPECT_EQ(0u, module.count("OpTypeArray", [&](const HwInstruction& inst) {
            const auto* element = module.definition(inst.words[2]);
            return element && element->op == "OpTypeVector" && module.typeIs(element->words[2], "OpTypeFloat");
        }));
    }
    if (name == "alias") {
        // Generated memory helpers also write/read arrays. Require the original
        // source variable, so those helpers cannot hide incorrect forwarding.
        ASSERT_NE(0u, aliasRoot);
        EXPECT_EQ(aliasRoot, module.componentWriteThenWholeLoadRoot(aliasRoot));
    }
    if (name == "loop") {
        EXPECT_GT(module.count("OpLoopMerge"), 0u);
        const char* type = !scalar && test.width % 2 == 0 ? "OpTypeVector" : "OpTypeFloat";
        EXPECT_GT(module.mathCount("OpFAdd", type), 0u);
        EXPECT_GT(module.mathCount("OpFSub", type), 0u);
    }
    if (name == "select" || name == "copy") {
        EXPECT_EQ(rolled ? 1u : test.width, module.count("OpSelect"));
        EXPECT_EQ(0u, module.mathCount("OpSelect", "OpTypeArray"));
        if (rolled && !scalar && test.width == 4) {
            EXPECT_EQ(1u, module.mathCount("OpSelect", "OpTypeVector"));
        }
    }
    if (name == "aggregate") {
        EXPECT_GT(module.count("OpReturnValue"), 0u);
        EXPECT_GT(module.count("OpFunctionParameter"), 0u);
    }
    if (name == "copy") {
        EXPECT_GT(module.count("OpCopyObject",
                               [&](const HwInstruction& inst) {
                                   return module.typeIs(inst.type, "OpTypeArray") &&
                                          module.decorated(inst.id, spv::DecorationNonUniform);
                               }),
                  0u);
    }
    if (name == "integer") {
        // Address arithmetic is unsigned; require signed data arithmetic.
        for (const char* op : {"OpIMul", "OpIAdd"}) {
            EXPECT_GT(module.count(op,
                                   [&](const HwInstruction& inst) {
                                       const auto* type = module.definition(inst.type);
                                       return type && type->op == "OpTypeInt" && type->words[3] == 1;
                                   }),
                      0u);
            EXPECT_EQ(0u, module.mathCount(op, "OpTypeVector"));
        }
        EXPECT_EQ(0u, module.count("OpTypeVector", [&](const HwInstruction& inst) {
            return module.typeIs(inst.words[2], "OpTypeFloat");
        }));
    }
    if (name == "precise") {
        EXPECT_GT(module.mathCount("OpFMul", "OpTypeFloat"), 0u);
        EXPECT_GT(module.mathCount("OpFAdd", "OpTypeFloat"), 0u);
        for (const auto& inst : module.instructions) {
            if (inst.op == "OpFMul" || inst.op == "OpFAdd") {
                EXPECT_TRUE(module.typeIs(inst.type, "OpTypeFloat"));
                EXPECT_TRUE(module.decorated(inst.id, spv::DecorationNoContraction));
            }
            if (inst.op == "OpExtInst") {
                EXPECT_NE(uint32_t(GLSLstd450Fma), inst.words[4]);
            }
        }
    }
    if (name == "precise_arithmetic" || name == "precise_matrix_arithmetic") {
        EXPECT_GT(module.count("OpFAdd"), 0u);
        EXPECT_GT(module.count("OpFMul") + module.count("OpVectorTimesScalar"), 0u);
        EXPECT_GT(module.count("OpFSub"), 0u);
        for (const auto& inst : module.instructions) {
            if (inst.op == "OpFMul" || inst.op == "OpFAdd" || inst.op == "OpVectorTimesScalar") {
                EXPECT_TRUE(module.decorated(inst.id, spv::DecorationNoContraction)) << inst.op << " " << inst.id;
            } else if (inst.op == "OpFSub") {
                EXPECT_FALSE(module.decorated(inst.id, spv::DecorationNoContraction));
            }
        }
    }
    if (name == "large_struct") {
        const unsigned pieces = !scalar && test.width % 2 == 0 ? test.width / 2 : test.width;
        if (pieces > 65532) {
            EXPECT_GT(module.count("OpLoopMerge"), 0u);
        }
        EXPECT_GT(module.count("OpLoad"), 0u);
    }
    if (name == "shared") {
        const char* type = !scalar && test.width == 4 ? "OpTypeVector" : "OpTypeFloat";
        EXPECT_GT(module.count("OpExtInst",
                               [&](const HwInstruction& inst) {
                                   return inst.words[4] == GLSLstd450Fma && module.typeIs(inst.type, type);
                               }),
                  0u);
        if (!scalar && test.width == 4) {
            EXPECT_GT(module.mathCount("OpFunctionParameter", "OpTypeArray"), 0u);
        } else {
            EXPECT_EQ(0u, module.mathCount("OpExtInst", "OpTypeVector"));
        }
    }
    if (name == "volatile") {
        EXPECT_GE(module.count("OpLoad",
                               [&](const HwInstruction& inst) {
                                   return module.typeIs(inst.type, "OpTypeFloat") && inst.words.size() > 4 &&
                                          (inst.words[4] & uint32_t(spv::MemoryAccessVolatileMask));
                               }),
                  12u);
        EXPECT_GE(module.count("OpStore",
                               [&](const HwInstruction& inst) {
                                   const auto* value = module.definition(inst.words[2]);
                                   return value && module.typeIs(value->type, "OpTypeFloat") && inst.words.size() > 3 &&
                                          (inst.words[3] & uint32_t(spv::MemoryAccessVolatileMask));
                               }),
                  24u);
        EXPECT_EQ(0u, module.count("OpFunctionCall")); // No captured packed-memory helper.
    }
    if (rolled) {
        EXPECT_GT(module.count("OpLoopMerge"), 0u);
    }
}

void CheckLanguageOutput(const HwModule& input, const HwModule& output, const HwLowerCase& test, bool scalar,
                         bool rolled)
{
    const std::string name = test.name;
    if (!IsLanguageCase(name))
        return;
    const bool packed = !scalar && test.width % 2 == 0;
    const char* arithmeticType = packed ? "OpTypeVector" : "OpTypeFloat";
    if (name == "switch_return" || name == "do_break" || name == "workgroup") {
        EXPECT_GT(output.mathCount("OpFAdd", arithmeticType), 0u);
    }
    if (name == "switch_return" || name == "do_break") {
        EXPECT_GT(output.mathCount("OpFNegate", arithmeticType), 0u);
    }
    if (name == "switch_return") {
        EXPECT_GT(output.mathCount("OpFMul", arithmeticType), 0u);
        for (const auto& inst : input.instructions) {
            if (inst.op == "OpSwitch" || inst.op == "OpReturnValue") {
                EXPECT_EQ(1u,
                          output.count(inst.op, [&](const HwInstruction& other) { return inst.words == other.words; }));
            }
        }
    }
    if (name == "private_nested") {
        // Keep the original global and component pointer IDs, including the dynamic
        // aggregate indices. Packed lowering adds only the piece/lane index split.
        for (const auto& inst : input.instructions) {
            if (inst.op != "OpAccessChain" || !input.pointerStorage(inst.id, spv::StorageClassPrivate))
                continue;
            const auto* lowered = output.definition(inst.id);
            ASSERT_NE(nullptr, lowered);
            EXPECT_EQ("OpAccessChain", lowered->op);
            EXPECT_EQ(input.pointerRoot(inst.id), output.pointerRoot(inst.id));
            EXPECT_TRUE(output.pointerStorage(inst.id, spv::StorageClassPrivate));
            const bool component = !input.containsHw(inst.type);
            ASSERT_EQ(inst.words.size() + (packed && component ? 1 : 0), lowered->words.size());
            const size_t end = inst.words.size() - (component ? 1 : 0);
            EXPECT_TRUE(std::equal(inst.words.begin() + 3, inst.words.begin() + end, lowered->words.begin() + 3));
        }
    }
    if (name == "workgroup") {
        EXPECT_EQ(2u, output.count("OpControlBarrier"));
        for (const auto& inst : input.instructions) {
            if (inst.op == "OpControlBarrier") {
                EXPECT_EQ(2u,
                          output.count(inst.op, [&](const HwInstruction& other) { return inst.words == other.words; }));
                for (size_t i = 1; i < inst.words.size(); ++i) {
                    const auto* constant = output.definition(inst.words[i]);
                    ASSERT_NE(nullptr, constant);
                    EXPECT_EQ(input.definition(inst.words[i])->words, constant->words);
                }
            }
        }
        EXPECT_GT(output.count("OpLoad",
                               [&](const HwInstruction& inst) {
                                   return output.pointerStorage(inst.words[3], spv::StorageClassWorkgroup);
                               }),
                  0u);
        EXPECT_GT(output.count("OpStore",
                               [&](const HwInstruction& inst) {
                                   return output.pointerStorage(inst.words[1], spv::StorageClassWorkgroup);
                               }),
                  0u);
    }
    if (name == "conversion_extinst") {
        for (const char* op : {"OpConvertFToS", "OpConvertSToF", "OpBitcast"}) {
            EXPECT_GT(output.mathCount(op, "OpTypeInt") + output.mathCount(op, "OpTypeFloat") +
                          output.mathCount(op, "OpTypeVector"),
                      0u)
                << op;
        }
        for (const char* op : {"OpIAdd", "OpIMul"}) {
            EXPECT_GT(output.count(op,
                                   [&](const HwInstruction& inst) {
                                       const auto* type = output.definition(inst.type);
                                       return type && type->op == "OpTypeInt" && type->words[3] == 1;
                                   }),
                      0u)
                << op;
        }
        EXPECT_GT(output.count("OpExtInst",
                               [&](const HwInstruction& inst) {
                                   return inst.words[4] == GLSLstd450FClamp && output.typeIs(inst.type, arithmeticType);
                               }),
                  0u);
    }
    if (rolled) {
        EXPECT_GT(output.count("OpLoopMerge"), input.count("OpLoopMerge"));
    }
}
#endif

TEST_P(HwExtensionFreeTest, ValidatedGlslPipeline)
{
#if !ENABLE_OPT
    GTEST_SKIP() << "SPIRV-Tools is required for HW lowering";
#else
    const auto test = GetParam();
    const std::string file = "spv.hw_extfree_" + std::string(test.name) + ".comp";
    std::string source;
    tryLoadFile(GlobalTestSettings.testRoot + "/" + file, "input", &source);
    ASSERT_FALSE(source.empty());
    source.insert(source.find('\n') + 1, "#define WIDTH " + std::to_string(test.width) + "\n");
    const auto controls = DeriveOptions(Source::GLSL, Semantics::Vulkan, Target::Spv);
    const auto compiled =
        compileAndLink(file, source, "", controls, glslang::EShTargetVulkan_1_3, glslang::EShTargetSpv_1_6);
    std::ostringstream compileMessages;
    outputResultToStream(&compileMessages, compiled, controls);
    ASSERT_FALSE(compiled.spirvBinary.empty()) << compileMessages.str();

    std::ostringstream diagnostics;
    const auto consumer = [&](spv_message_level_t, const char*, const spv_position_t&, const char* message) {
        diagnostics << message << '\n';
    };
    spvtools::SpirvTools tools(SPV_ENV_VULKAN_1_3);
    tools.SetMessageConsumer(consumer);
    ASSERT_TRUE(tools.Validate(compiled.spirvBinary)) << "Invalid frontend input:\n" << diagnostics.str();
    std::string inputAssembly;
    ASSERT_TRUE(tools.Disassemble(compiled.spirvBinary, &inputAssembly));
    const HwModule inputModule(compiled.spirvBinary);
    CheckInput(inputModule, test.name);
    std::vector<uint32_t> mutatedValues;
    const bool mutation = std::string(test.name).find("mutation_") == 0;
    if (mutation) {
        for (const auto& inst : inputModule.instructions) {
            if (inst.op != "OpCooperativeVectorMatrixMulHW" && inst.op != "OpCooperativeVectorMatrixMulAddHW" &&
                inst.op != "OpCooperativeMatrixMulAddHW")
                continue;
            const size_t end = std::string(test.name) == "mutation_input" ? 4 : inst.words.size();
            for (size_t i = 3; i < end; ++i) {
                const auto* value = inputModule.definition(inst.words[i]);
                ASSERT_NE(nullptr, value);
                ASSERT_EQ("OpLoad", value->op);
                mutatedValues.push_back(value->id);
            }
        }
        ASSERT_FALSE(mutatedValues.empty());
    }
    std::vector<uint32_t> transportLoads;
    if (std::string(test.name) == "branch" || std::string(test.name) == "loop" ||
        std::string(test.name) == "do_break") {
        transportLoads = inputModule.multiBlockTransportLoads();
        ASSERT_FALSE(transportLoads.empty());
    }
    const uint32_t aliasRoot = inputModule.componentWriteThenWholeLoadRoot();
    ASSERT_FALSE(::testing::Test::HasFailure()) << "Input does not exercise the intended pattern";

    // Freeze the frontend-generated input separately from lowering assertions.
    // These goldens must never be used as hand-written assembly inputs.
    const std::string golden =
        GlobalTestSettings.testRoot + "/baseResults/" + file + "." + std::to_string(test.width) + ".out";
    std::string expectedInput;
    tryLoadFile(golden, "expected input SPIR-V", &expectedInput);
    checkEqAndUpdateIfRequested(expectedInput, inputAssembly, golden, diagnostics.str());

    for (bool scalar : {false, true}) {
        std::vector<std::string> options = {scalar ? "=scalar" : ""};
        const std::string name = test.name;
        const std::string prefix = scalar ? "=scalar," : "=";
        if (name == "select")
            options.push_back(prefix + "unroll-elements=2");
        if (name == "integer")
            options.push_back(prefix + "unroll-macs=8");
        if (name == "precise")
            options.push_back(prefix + "unroll-macs=4");
        if (mutation)
            options.push_back(prefix + "unroll-macs=2");
        if (name == "precise_arithmetic" || name == "precise_matrix_arithmetic")
            options.push_back(prefix + "unroll-elements=2");
        if (IsLanguageCase(name))
            options.push_back(prefix + "unroll-elements=2");
        for (size_t variant = 0; variant < options.size(); ++variant) {
            const std::string flag = "--hw-lower-to-standard-extension-free" + options[variant];
            SCOPED_TRACE(flag);
            diagnostics.str("");
            spvtools::Optimizer optimizer(SPV_ENV_VULKAN_1_3);
            optimizer.SetMessageConsumer(consumer);
            ASSERT_TRUE(optimizer.RegisterPassFromFlag(flag));
            std::vector<uint32_t> lowered;
            ASSERT_TRUE(optimizer.Run(compiled.spirvBinary.data(), compiled.spirvBinary.size(), &lowered))
                << diagnostics.str();
            ASSERT_TRUE(tools.Validate(lowered)) << "Invalid lowered output:\n" << diagnostics.str();
            std::string assembly;
            ASSERT_TRUE(tools.Disassemble(lowered, &assembly));
            HwModule module(lowered);
            module.expectNoHw(assembly);
            CheckOutput(module, test, scalar, variant != 0, aliasRoot);
            CheckLanguageOutput(inputModule, module, test, scalar, variant != 0);
            for (uint32_t id : mutatedValues) {
                // A surviving but unused load does not preserve the update.
                // Require its value to feed computation or aggregate staging.
                const size_t uses = module.count("OpFunctionCall", [&](const HwInstruction& inst) {
                    return std::find(inst.words.begin() + 4, inst.words.end(), id) != inst.words.end();
                }) + module.count("OpCompositeExtract", [&](const HwInstruction& inst) {
                    return inst.words[3] == id;
                }) + module.count("OpStore", [&](const HwInstruction& inst) { return inst.words[2] == id; });
                EXPECT_GT(uses, 0u) << "Modified value was bypassed: " << id;
            }
            for (uint32_t id : transportLoads) {
                const auto* load = module.definition(id);
                ASSERT_NE(nullptr, load) << "Cross-block transport load was incorrectly forwarded: " << id;
                EXPECT_EQ("OpLoad", load->op);
            }
        }
    }
#endif
}

INSTANTIATE_TEST_SUITE_P(
    Glsl, HwExtensionFreeTest,
    ::testing::Values(
        HwLowerCase{"alias", 4}, HwLowerCase{"alias", 5}, HwLowerCase{"branch", 3}, HwLowerCase{"branch", 4},
        HwLowerCase{"loop", 5}, HwLowerCase{"loop", 8}, HwLowerCase{"aggregate", 4}, HwLowerCase{"select", 4},
        HwLowerCase{"select", 5}, HwLowerCase{"integer", 3}, HwLowerCase{"shared", 4}, HwLowerCase{"shared", 3},
        HwLowerCase{"precise", 2}, HwLowerCase{"volatile", 4}, HwLowerCase{"copy", 4}, HwLowerCase{"mutation_input", 4},
        HwLowerCase{"mutation_vector", 4}, HwLowerCase{"mutation_vector", 5}, HwLowerCase{"mutation_matrix", 3},
        HwLowerCase{"mutation_matrix", 4}, HwLowerCase{"precise_arithmetic", 4}, HwLowerCase{"precise_arithmetic", 5},
        HwLowerCase{"precise_matrix_arithmetic", 3}, HwLowerCase{"precise_matrix_arithmetic", 4},
        HwLowerCase{"large_struct", 65532}, HwLowerCase{"large_struct", 65533}, HwLowerCase{"large_struct", 65534},
        HwLowerCase{"switch_return", 4}, HwLowerCase{"switch_return", 5}, HwLowerCase{"do_break", 4},
        HwLowerCase{"do_break", 5}, HwLowerCase{"private_nested", 4}, HwLowerCase{"private_nested", 5},
        HwLowerCase{"workgroup", 4}, HwLowerCase{"workgroup", 5}, HwLowerCase{"conversion_extinst", 4},
        HwLowerCase{"conversion_extinst", 5}, HwLowerCase{"ssa", 4}, HwLowerCase{"ssa", 5}, HwLowerCase{"coherent", 4}),
    [](const ::testing::TestParamInfo<HwLowerCase>& info) {
        return std::string(info.param.name) + "_" + std::to_string(info.param.width);
    });

using HwSsaTest = GlslangTest<::testing::TestWithParam<unsigned>>;

TEST_P(HwSsaTest, ValidatedCooperativePhiPipeline)
{
#if !ENABLE_OPT
    GTEST_SKIP() << "SPIRV-Tools is required";
#else
    std::string source;
    tryLoadFile(GlobalTestSettings.testRoot + "/spv.hw_extfree_ssa.comp", "SSA GLSL", &source);
    source.insert(source.find('\n') + 1, "#define WIDTH " + std::to_string(GetParam()) + "\n");
    const auto controls = DeriveOptions(Source::GLSL, Semantics::Vulkan, Target::Spv);
    const auto compiled = compileAndLink("spv.hw_extfree_ssa.comp", source, "", controls, glslang::EShTargetVulkan_1_3,
                                         glslang::EShTargetSpv_1_6);
    ASSERT_FALSE(compiled.spirvBinary.empty());
    spvtools::SpirvTools tools(SPV_ENV_VULKAN_1_3);
    ASSERT_TRUE(tools.Validate(compiled.spirvBinary));
    spvtools::Optimizer promote(SPV_ENV_VULKAN_1_3);
    ASSERT_TRUE(promote.RegisterPassFromFlag("--ssa-rewrite"));
    std::vector<uint32_t> ssa;
    ASSERT_TRUE(promote.Run(compiled.spirvBinary.data(), compiled.spirvBinary.size(), &ssa));
    ASSERT_TRUE(tools.Validate(ssa));
    const HwModule input(ssa);
    for (const char* type : {"OpTypeCooperativeVectorHW", "OpTypeCooperativeMatrixHW"}) {
        EXPECT_GT(input.count("OpPhi", [&](const HwInstruction& inst) { return input.typeIs(inst.type, type); }), 0u);
    }
    ASSERT_FALSE(::testing::Test::HasFailure());
    for (const char* mode :
         {"", "=scalar", "=no-direct,no-fusion", "=unroll-elements=2", "=scalar,unroll-elements=2"}) {
        SCOPED_TRACE(mode);
        spvtools::Optimizer lower(SPV_ENV_VULKAN_1_3);
        ASSERT_TRUE(lower.RegisterPassFromFlag(std::string("--hw-lower-to-standard-extension-free") + mode));
        std::vector<uint32_t> output;
        ASSERT_TRUE(lower.Run(ssa.data(), ssa.size(), &output));
        ASSERT_TRUE(tools.Validate(output));
        std::string assembly;
        ASSERT_TRUE(tools.Disassemble(output, &assembly));
        HwModule(output).expectNoHw(assembly);
    }
#endif
}

INSTANTIATE_TEST_SUITE_P(Glsl, HwSsaTest, ::testing::Values(4u, 5u));

using HwArrayCollisionTest = GlslangTest<::testing::TestWithParam<bool>>;

TEST_P(HwArrayCollisionTest, PreservesOrdinaryArrayIndices)
{
#if !ENABLE_OPT
    GTEST_SKIP() << "SPIRV-Tools is required for HW lowering";
#else
    const bool scalarLayout = GetParam();
    const std::string file = "spv.hw_extfree_array_collision.comp";
    std::string source;
    tryLoadFile(GlobalTestSettings.testRoot + "/" + file, "array collision GLSL", &source);
    ASSERT_FALSE(source.empty());
    source.insert(source.find('\n') + 1, std::string("#define SCALAR_LAYOUT ") + (scalarLayout ? "1\n" : "0\n"));
    const auto controls = DeriveOptions(Source::GLSL, Semantics::Vulkan, Target::Spv);
    const auto compiled =
        compileAndLink(file, source, "", controls, glslang::EShTargetVulkan_1_3, glslang::EShTargetSpv_1_6);
    std::ostringstream compileMessages;
    outputResultToStream(&compileMessages, compiled, controls);
    ASSERT_FALSE(compiled.spirvBinary.empty()) << compileMessages.str();

    std::ostringstream diagnostics;
    const auto consumer = [&](spv_message_level_t, const char*, const spv_position_t&, const char* message) {
        diagnostics << message << '\n';
    };
    spvtools::SpirvTools tools(SPV_ENV_VULKAN_1_3);
    tools.SetMessageConsumer(consumer);
    if (scalarLayout) {
        ASSERT_FALSE(tools.Validate(compiled.spirvBinary)) << "Fixture no longer requires scalar block layout";
        diagnostics.str("");
    }
    spvtools::ValidatorOptions validatorOptions;
    validatorOptions.SetScalarBlockLayout(scalarLayout);
    ASSERT_TRUE(tools.Validate(compiled.spirvBinary.data(), compiled.spirvBinary.size(), validatorOptions))
        << "Invalid frontend input:\n" << diagnostics.str();

    const HwModule input(compiled.spirvBinary);
    const HwInstruction* ordinaryExtract = nullptr;
    uint32_t cooperativeSum = 0;
    uint32_t ordinaryArrayType = 0;
    for (const auto& inst : input.instructions) {
        if (inst.op == "OpFAdd" && input.containsHw(inst.type))
            cooperativeSum = inst.id;
        if (inst.op != "OpCompositeExtract")
            continue;
        const auto* array = input.definition(inst.words[3]);
        if (array && array->op == "OpFunctionCall" && input.typeIs(array->type, "OpTypeArray")) {
            ASSERT_EQ(nullptr, ordinaryExtract);
            ordinaryExtract = &inst;
            ordinaryArrayType = array->type;
        }
    }
    ASSERT_NE(nullptr, ordinaryExtract);
    ASSERT_EQ(5u, ordinaryExtract->words.size());
    ASSERT_EQ(1u, ordinaryExtract->words[4]);
    const auto* vectorType = input.definition(ordinaryExtract->type);
    ASSERT_NE(nullptr, vectorType);
    ASSERT_EQ("OpTypeVector", vectorType->op);
    ASSERT_EQ(2u, vectorType->words[3]);
    ASSERT_TRUE(input.typeIs(vectorType->words[2], "OpTypeFloat"));
    const auto* arrayType = input.definition(ordinaryArrayType);
    ASSERT_NE(nullptr, arrayType);
    ASSERT_EQ(vectorType->id, arrayType->words[2]);
    const auto* arrayLength = input.definition(arrayType->words[3]);
    ASSERT_NE(nullptr, arrayLength);
    ASSERT_EQ("OpConstant", arrayLength->op);
    ASSERT_EQ(2u, arrayLength->words[3]);
    ASSERT_NE(0u, cooperativeSum);

    for (const char* mode : {"", "=no-direct,no-fusion", "=scalar"}) {
        SCOPED_TRACE(mode);
        diagnostics.str("");
        spvtools::Optimizer optimizer(SPV_ENV_VULKAN_1_3);
        optimizer.SetMessageConsumer(consumer);
        ASSERT_TRUE(optimizer.RegisterPassFromFlag(std::string("--hw-lower-to-standard-extension-free") + mode));
        spvtools::OptimizerOptions optimizerOptions;
        optimizerOptions.set_validator_options(validatorOptions);
        std::vector<uint32_t> lowered;
        ASSERT_TRUE(optimizer.Run(compiled.spirvBinary.data(), compiled.spirvBinary.size(), &lowered, optimizerOptions))
            << diagnostics.str();
        // A successful scalar retry would hide corruption in packed lowering.
        EXPECT_TRUE(diagnostics.str().empty()) << diagnostics.str();
        ASSERT_TRUE(tools.Validate(lowered.data(), lowered.size(), validatorOptions))
            << "Invalid lowered output:\n" << diagnostics.str();
        std::string assembly;
        ASSERT_TRUE(tools.Disassemble(lowered, &assembly));
        const HwModule output(lowered);
        output.expectNoHw(assembly);
        const auto* extracted = output.definition(ordinaryExtract->id);
        ASSERT_NE(nullptr, extracted);
        EXPECT_EQ(ordinaryExtract->op, extracted->op);
        EXPECT_EQ(ordinaryExtract->words, extracted->words);
        const auto* sum = output.definition(cooperativeSum);
        ASSERT_NE(nullptr, sum);
        const auto* loweredType = output.definition(sum->type);
        ASSERT_NE(nullptr, loweredType);
        ASSERT_EQ("OpTypeArray", loweredType->op);
        if (std::string(mode) == "=scalar") {
            EXPECT_TRUE(output.typeIs(loweredType->words[2], "OpTypeFloat"));
        } else {
            // Require the collision itself and retained packed arithmetic.
            EXPECT_EQ(ordinaryArrayType, loweredType->id);
            EXPECT_GT(output.mathCount("OpFAdd", "OpTypeVector"), 0u);
        }
    }
#endif
}

INSTANTIATE_TEST_SUITE_P(Glsl, HwArrayCollisionTest, ::testing::Values(false, true),
                        [](const ::testing::TestParamInfo<bool>& info) {
                            return info.param ? "ScalarLayout" : "StandardLayout";
                        });

struct HwIntegerChainCase {
    unsigned width;
    unsigned statements;
    bool signedValues;
};

using HwIntegerChainTest = GlslangTest<::testing::TestWithParam<HwIntegerChainCase>>;

TEST_P(HwIntegerChainTest, SmallIntegerOperationsStayUnrolled)
{
#if !ENABLE_OPT
    GTEST_SKIP() << "SPIRV-Tools is required for HW lowering";
#else
    const auto& test = GetParam();
    const std::string file = "spv.hw_extfree_integer_chain.comp";
    std::string source;
    tryLoadFile(GlobalTestSettings.testRoot + "/" + file, "integer chain GLSL", &source);
    ASSERT_FALSE(source.empty());
    source.insert(source.find('\n') + 1, "#define WIDTH " + std::to_string(test.width) +
                                            "\n#define SIGNED_VALUES " + (test.signedValues ? "1\n" : "0\n"));
    const std::string marker = "    x = (x + V(T(1))) ^ V(T(1013904223)); // GENERATED_INTEGER_CHAIN";
    const auto insertion = source.find(marker);
    ASSERT_NE(std::string::npos, insertion);
    std::string chain;
    for (unsigned i = 0; i < test.statements; ++i) {
        // Keep literals representable in both scalar types. Each result feeds
        // the next statement and eventually reaches observable SSBO storage.
        const uint32_t mask = (1013904223u + i * 1664525u) & 0x7fffffffu;
        chain += "    x = (x + V(T(" + std::to_string(2 * i + 1) + "))) ^ V(T(" + std::to_string(mask) + "));\n";
    }
    source.replace(insertion, marker.size(), chain);
    const auto controls = DeriveOptions(Source::GLSL, Semantics::Vulkan, Target::Spv);
    const auto compiled =
        compileAndLink(file, source, "", controls, glslang::EShTargetVulkan_1_3, glslang::EShTargetSpv_1_6);
    std::ostringstream diagnostics;
    outputResultToStream(&diagnostics, compiled, controls);
    ASSERT_FALSE(compiled.spirvBinary.empty()) << diagnostics.str();
    diagnostics.str("");
    const auto consumer = [&](spv_message_level_t, const char*, const spv_position_t&, const char* message) {
        diagnostics << message << '\n';
    };
    spvtools::SpirvTools tools(SPV_ENV_VULKAN_1_3);
    tools.SetMessageConsumer(consumer);
    ASSERT_TRUE(tools.Validate(compiled.spirvBinary)) << "Invalid frontend input:\n" << diagnostics.str();
    const HwModule input(compiled.spirvBinary);
    ASSERT_EQ(0u, input.count("OpLoopMerge"));
    for (const char* op : {"OpIAdd", "OpBitwiseXor"}) {
        ASSERT_EQ(test.statements, input.hwCount(op)) << op;
        ASSERT_EQ(test.statements, input.count(op, [&](const HwInstruction& inst) {
            const auto* vector = input.definition(inst.type);
            if (!vector || vector->op != "OpTypeCooperativeVectorHW")
                return false;
            const auto* component = input.definition(vector->words[2]);
            return component && component->op == "OpTypeInt" && component->words[2] == 32 &&
                   component->words[3] == uint32_t(test.signedValues);
        })) << op;
    }

    std::vector<std::string> modes = {"", "=scalar", "=no-direct,no-fusion"};
    if (test.statements == 32) {
        modes.push_back("=unroll-elements=2");
        modes.push_back("=scalar,unroll-elements=2");
    }
    for (const auto& mode : modes) {
        SCOPED_TRACE(mode);
        diagnostics.str("");
        spvtools::Optimizer optimizer(SPV_ENV_VULKAN_1_3);
        optimizer.SetMessageConsumer(consumer);
        ASSERT_TRUE(optimizer.RegisterPassFromFlag("--hw-lower-to-standard-extension-free" + mode));
        std::vector<uint32_t> lowered;
        ASSERT_TRUE(optimizer.Run(compiled.spirvBinary.data(), compiled.spirvBinary.size(), &lowered))
            << diagnostics.str();
        EXPECT_TRUE(diagnostics.str().empty()) << "A scalar retry must not conceal a failed path:\n" << diagnostics.str();
        ASSERT_TRUE(tools.Validate(lowered)) << "Invalid lowered output:\n" << diagnostics.str();
        std::string assembly;
        ASSERT_TRUE(tools.Disassemble(lowered, &assembly));
        const HwModule output(lowered);
        output.expectNoHw(assembly);
        const bool rolled = mode.find("unroll-elements=2") != std::string::npos;
        if (rolled) {
            // Both arithmetic operations must still honor the configured limit.
            // Memory loops alone are insufficient to establish this path.
            EXPECT_GE(output.count("OpLoopMerge"), 2u * test.statements);
        } else {
            EXPECT_EQ(0u, output.count("OpLoopMerge"));
        }
        const size_t arithmeticCount = test.statements * (rolled ? 1u : test.width);
        for (const char* op : {"OpIAdd", "OpBitwiseXor"}) {
            const size_t count = output.count(op, [&](const HwInstruction& inst) {
                const auto* component = output.definition(inst.type);
                return component && component->op == "OpTypeInt" && component->words[2] == 32 &&
                       component->words[3] == uint32_t(test.signedValues);
            });
            // Unsigned address/index arithmetic can add unrelated OpIAdd values.
            if (std::string(op) == "OpIAdd")
                EXPECT_GE(count, arithmeticCount);
            else
                EXPECT_EQ(count, arithmeticCount);
            EXPECT_EQ(0u, output.mathCount(op, "OpTypeVector"));
        }
    }
#endif
}

INSTANTIATE_TEST_SUITE_P(
    Glsl, HwIntegerChainTest,
    ::testing::Values(HwIntegerChainCase{4, 32, false}, HwIntegerChainCase{5, 32, false},
                      HwIntegerChainCase{4, 32, true}, HwIntegerChainCase{5, 32, true},
                      HwIntegerChainCase{4, 512, false}, HwIntegerChainCase{5, 512, false},
                      HwIntegerChainCase{4, 512, true}, HwIntegerChainCase{5, 512, true}),
    [](const ::testing::TestParamInfo<HwIntegerChainCase>& info) {
        return std::string(info.param.signedValues ? "Signed" : "Unsigned") + "_" + std::to_string(info.param.width) +
               "_" + std::to_string(info.param.statements);
    });

using HwBoundaryTest = GlslangTest<::testing::TestWithParam<vk_hw::BoundaryCase>>;

TEST_P(HwBoundaryTest, ValidatedInferenceBoundary)
{
#if !ENABLE_OPT
    GTEST_SKIP() << "SPIRV-Tools is required for HW lowering";
#else
    const auto& test = GetParam();
    std::string source;
    tryLoadFile(GlobalTestSettings.testRoot + "/spv.hw_boundary.comp", "boundary shader", &source);
    ASSERT_FALSE(source.empty());
    std::string preamble;
    for (auto define : test.defines()) {
        define[define.find('=')] = ' ';
        preamble += "#define " + define + "\n";
    }
    source.insert(source.find('\n') + 1, preamble);
    const auto controls = DeriveOptions(Source::GLSL, Semantics::Vulkan, Target::Spv);
    const auto compiled = compileAndLink("spv.hw_boundary.comp", source, "", controls,
                                         glslang::EShTargetVulkan_1_3, glslang::EShTargetSpv_1_6);
    std::ostringstream diagnostics;
    outputResultToStream(&diagnostics, compiled, controls);
    ASSERT_FALSE(compiled.spirvBinary.empty()) << diagnostics.str();
    const auto consumer = [&](spv_message_level_t, const char*, const spv_position_t&, const char* message) {
        diagnostics << message << '\n';
    };
    spvtools::SpirvTools tools(SPV_ENV_VULKAN_1_3);
    tools.SetMessageConsumer(consumer);
    ASSERT_TRUE(tools.Validate(compiled.spirvBinary)) << diagnostics.str();
    const HwModule input(compiled.spirvBinary);
    const std::string operation = test.kind == 1 ? "OpCooperativeMatrixMulAddHW"
                                  : test.kind == 9 ? "OpCooperativeMatrixLoadHW"
                                  : test.kind == 2 ? "OpFAdd" : "OpCooperativeVectorMatrixMulAddHW";
    std::vector<uint32_t> values;
    for (const auto& inst : input.instructions) {
        if (inst.op == operation && input.containsHw(inst.type)) values.push_back(inst.id);
    }
    ASSERT_FALSE(values.empty()) << "No typed operation for intended boundary";
    if (test.kind == 6) {
        EXPECT_GT(input.count("OpLoopMerge"), 0u);
        EXPECT_GT(input.hwCount("OpReturnValue"), 0u);
    }
    if (test.kind == 7) {
        EXPECT_GE(input.hwCount("OpFConvert"), 3u);
        EXPECT_EQ(1u, input.count("OpMemoryBarrier"));
    }
    if (test.kind == 8) {
        ASSERT_TRUE(input.decorated(values.front(), spv::DecorationNoContraction));
    }
    ASSERT_FALSE(::testing::Test::HasFailure());

    for (const auto& mode : test.modes()) {
        SCOPED_TRACE(mode);
        spvtools::Optimizer optimizer(SPV_ENV_VULKAN_1_3);
        optimizer.SetMessageConsumer(consumer);
        ASSERT_TRUE(optimizer.RegisterPassFromFlag("--hw-lower-to-standard-extension-free" +
                                                   (mode.empty() ? "" : "=" + mode)));
        std::vector<uint32_t> binary;
        ASSERT_TRUE(optimizer.Run(compiled.spirvBinary.data(), compiled.spirvBinary.size(), &binary))
            << diagnostics.str();
        ASSERT_TRUE(tools.Validate(binary)) << diagnostics.str();
        std::string assembly;
        ASSERT_TRUE(tools.Disassemble(binary, &assembly));
        const HwModule output(binary);
        output.expectNoHw(assembly);
        const bool scalar = mode.find("scalar") != std::string::npos;
        if (scalar) {
            for (const char* op : {"OpFAdd", "OpFMul", "OpIMul"})
                EXPECT_EQ(0u, output.mathCount(op, "OpTypeVector"));
        }
        if (test.kind == 8) {
            EXPECT_EQ(0u, output.count("OpExtInst", [](const HwInstruction& inst) {
                return inst.words[4] == GLSLstd450Fma;
            }));
            EXPECT_GT(output.count("OpFMul", [&](const HwInstruction& inst) {
                return output.decorated(inst.id, spv::DecorationNoContraction);
            }), 0u);
        }
        // Follow the original result into its replacement helper. Count only
        // that function's loops, not unrelated load/store helpers or debug names.
        auto loopsForValue = [&](uint32_t id) {
            const auto* value = output.definition(id);
            EXPECT_NE(nullptr, value);
            if (!value) return size_t(0);
            uint32_t owner = 0, current = 0;
            for (const auto& inst : output.instructions) {
                if (inst.op == "OpFunction") current = inst.id;
                if (inst.id == id) owner = current;
            }
            if (value->op == "OpFunctionCall") owner = value->words[3];
            size_t loops = 0;
            for (const auto& inst : output.instructions) {
                if (inst.op == "OpFunction") current = inst.id;
                if (current == owner && inst.op == "OpLoopMerge") ++loops;
            }
            return loops;
        };
        const std::string name = test.name;
        if (name.find("direct_f32_") == 0 || name == "mac_f16_64x64" || test.kind == 9) {
            unsigned limit = 4096;
            if (name.find("direct_f32_") == 0)
                limit = test.kind == 1 ? 1024 : scalar ? 4096 : 256;
            if (mode.find("4095") != std::string::npos) limit = 4095;
            if (mode.find("4097") != std::string::npos) limit = 4097;
            const unsigned work = test.kind == 9 ? test.m * test.n : test.m * test.n * test.k;
            const auto loops = loopsForValue(values.front());
            if (test.kind == 9 && !scalar) {
                // Packed memory uses chunk helpers even below the unroll limit.
                // Above it, scalar memory loops stage packed values in the caller.
                EXPECT_GT(loops, 0u);
                if (work > limit) {
                    EXPECT_EQ(0u, output.count("OpFunctionCall"));
                } else {
                    EXPECT_GT(output.count("OpFunctionCall"), 0u);
                }
            } else if (work > limit) {
                EXPECT_GT(loops, 0u);
            } else {
                EXPECT_EQ(0u, loops);
            }
        }
        if (test.kind == 2 && scalar) {
            const auto loops = loopsForValue(values.front());
            const unsigned limit = mode.find("unroll-elements=128") == std::string::npos ? 4096 : 128;
            if (test.n > limit) {
                EXPECT_GT(loops, 0u);
            } else {
                EXPECT_EQ(0u, loops);
            }
        }
    }
#endif
}

INSTANTIATE_TEST_SUITE_P(Inference, HwBoundaryTest, ::testing::ValuesIn(vk_hw::BoundaryCases()),
                        [](const ::testing::TestParamInfo<vk_hw::BoundaryCase>& info) { return info.param.name; });

} // namespace
} // namespace glslangtest
