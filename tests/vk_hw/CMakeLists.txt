# Copyright (c) 2026 Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

find_package(Python3 COMPONENTS Interpreter QUIET)
if(Python3_Interpreter_FOUND)
    add_test(NAME vk_hw_build_shaders_script_tests
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/scripts/test_build_shaders.py
    )
    set_tests_properties(vk_hw_build_shaders_script_tests PROPERTIES
        LABELS "hw"
    )
    add_test(NAME vk_hw_case_parsing_tests
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/scripts/test_case_parsing.py
    )
    set_tests_properties(vk_hw_case_parsing_tests PROPERTIES
        LABELS "hw"
    )
endif()

add_executable(vk_hw_reference_tests
    runner/reference_test.cpp
    runner/reference.cpp
)
target_compile_features(vk_hw_reference_tests PRIVATE cxx_std_17)
add_test(NAME vk_hw_reference_tests COMMAND vk_hw_reference_tests)
set_tests_properties(vk_hw_reference_tests PROPERTIES LABELS "hw")

find_package(Vulkan QUIET)
if(NOT Vulkan_FOUND)
    message(STATUS "Vulkan SDK not found; skipping vk_hw_runner")
    return()
endif()

# spirv-cross is used to decompile SPIR-V back to readable GLSL after
# building.  It is optional for standalone functional/perf runs, but the
# golden comparison requires it.  HINTS are limited to in-tree locations
# to avoid caching paths under /tmp or other volatile directories that may
# disappear between cmake runs.
find_program(SPIRV_CROSS_EXECUTABLE spirv-cross
    HINTS
        ${CMAKE_BINARY_DIR}/External/SPIRV-Cross
        ${CMAKE_SOURCE_DIR}/External/SPIRV-Cross/build
    DOC "spirv-cross decompiler (optional, used to mirror SPIR-V to GLSL)"
)
if(SPIRV_CROSS_EXECUTABLE AND EXISTS "${SPIRV_CROSS_EXECUTABLE}")
    message(STATUS "Found spirv-cross: ${SPIRV_CROSS_EXECUTABLE}")
else()
    if(SPIRV_CROSS_EXECUTABLE AND NOT EXISTS "${SPIRV_CROSS_EXECUTABLE}")
        message(WARNING "Cached spirv-cross path no longer exists: "
                        "${SPIRV_CROSS_EXECUTABLE}. "
                        "Re-run cmake with -DSPIRV_CROSS_EXECUTABLE=<path> "
                        "or install spirv-cross on PATH.")
        set(SPIRV_CROSS_EXECUTABLE "SPIRV_CROSS_EXECUTABLE-NOTFOUND"
            CACHE FILEPATH "" FORCE)
    endif()
    message(STATUS "spirv-cross not found; GLSL decompilation will be skipped")
endif()

add_executable(vk_hw_runner
    runner/main.cpp
    runner/vulkan_context.cpp
    runner/compute_pipeline.cpp
    runner/buffer.cpp
    runner/timer.cpp
    runner/reference.cpp
)

target_link_libraries(vk_hw_runner PRIVATE Vulkan::Vulkan)
target_compile_features(vk_hw_runner PRIVATE cxx_std_17)
target_compile_options(vk_hw_runner PRIVATE
    $<$<CXX_COMPILER_ID:Clang,GNU>:-fexceptions>
    $<$<CXX_COMPILER_ID:MSVC>:/EHsc>
)
set_target_properties(vk_hw_runner PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests/vk_hw"
)

if(Python3_Interpreter_FOUND AND TARGET glslang-standalone AND TARGET spirv-opt
   AND TARGET spirv-val AND TARGET spirv-dis)
    set(_build_shader_args
        --glslang $<TARGET_FILE:glslang-standalone>
        --spirv-opt $<TARGET_FILE:spirv-opt>
        --spirv-val $<TARGET_FILE:spirv-val>
        --spirv-dis $<TARGET_FILE:spirv-dis>
        --shader-dir ${CMAKE_CURRENT_SOURCE_DIR}/shaders/hw
        --baseline-dir ${CMAKE_CURRENT_SOURCE_DIR}/shaders/baseline
        --unsupported-dir ${CMAKE_CURRENT_SOURCE_DIR}/shaders/unsupported
        --out-dir ${CMAKE_BINARY_DIR}/tests/vk_hw/spv
        --glsl-out-dir ${CMAKE_BINARY_DIR}/tests/vk_hw/glsl
        --golden-dir ${CMAKE_CURRENT_SOURCE_DIR}/glsl
    )
    if(SPIRV_CROSS_EXECUTABLE)
        list(APPEND _build_shader_args --spirv-cross ${SPIRV_CROSS_EXECUTABLE})
    endif()

    add_test(NAME vk_hw_build_shaders
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/scripts/build_shaders.py
            ${_build_shader_args}
    )

    add_test(NAME vk_hw_function
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/scripts/run_function_tests.py
            --runner $<TARGET_FILE:vk_hw_runner>
            --spv-dir ${CMAKE_BINARY_DIR}/tests/vk_hw/spv
            --out ${CMAKE_BINARY_DIR}/tests/vk_hw/results/functional
    )

    add_test(NAME vk_hw_perf
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/scripts/run_perf_tests.py
            --runner $<TARGET_FILE:vk_hw_runner>
            --spv-dir ${CMAKE_BINARY_DIR}/tests/vk_hw/spv
            --repeat 200
            --warmup 20
            --exclude *flow*.lowered.spv
            --out ${CMAKE_BINARY_DIR}/tests/vk_hw/results/perf/perf.json
    )

    set_tests_properties(vk_hw_build_shaders PROPERTIES
        LABELS "hw;vulkan"
        FIXTURES_SETUP vk_hw_spv
    )
    set_tests_properties(vk_hw_function vk_hw_perf PROPERTIES
        LABELS "hw;vulkan"
        FIXTURES_REQUIRED vk_hw_spv
    )
elseif(Python3_Interpreter_FOUND)
    message(STATUS "HW Vulkan CTests require glslang-standalone and SPIRV-Tools executable targets")
endif()
