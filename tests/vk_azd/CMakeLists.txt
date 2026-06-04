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

find_package(Vulkan QUIET)
if(NOT Vulkan_FOUND)
    message(STATUS "Vulkan SDK not found; skipping vk_azd_runner")
    return()
endif()

find_package(Python3 COMPONENTS Interpreter QUIET)

add_executable(vk_azd_runner
    runner/main.cpp
    runner/vulkan_context.cpp
    runner/compute_pipeline.cpp
    runner/buffer.cpp
    runner/timer.cpp
    runner/reference.cpp
)

target_link_libraries(vk_azd_runner PRIVATE Vulkan::Vulkan)
target_compile_features(vk_azd_runner PRIVATE cxx_std_17)
target_compile_options(vk_azd_runner PRIVATE
    $<$<CXX_COMPILER_ID:Clang,GNU>:-fexceptions>
    $<$<CXX_COMPILER_ID:MSVC>:/EHsc>
)
set_target_properties(vk_azd_runner PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests/vk_azd"
)

if(Python3_Interpreter_FOUND AND TARGET glslang-standalone AND TARGET spirv-opt
   AND TARGET spirv-val AND TARGET spirv-dis)
    add_test(NAME vk_azd_build_shaders
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/scripts/build_shaders.py
            --glslang $<TARGET_FILE:glslang-standalone>
            --spirv-opt $<TARGET_FILE:spirv-opt>
            --spirv-val $<TARGET_FILE:spirv-val>
            --spirv-dis $<TARGET_FILE:spirv-dis>
            --shader-dir ${CMAKE_CURRENT_SOURCE_DIR}/shaders/azd
            --baseline-dir ${CMAKE_CURRENT_SOURCE_DIR}/shaders/baseline
            --out-dir ${CMAKE_BINARY_DIR}/tests/vk_azd/spv
    )

    add_test(NAME vk_azd_function
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/scripts/run_function_tests.py
            --runner $<TARGET_FILE:vk_azd_runner>
            --spv-dir ${CMAKE_BINARY_DIR}/tests/vk_azd/spv
            --out ${CMAKE_BINARY_DIR}/tests/vk_azd/results/functional
    )

    add_test(NAME vk_azd_perf
        COMMAND ${Python3_EXECUTABLE}
            ${CMAKE_CURRENT_SOURCE_DIR}/scripts/run_perf_tests.py
            --runner $<TARGET_FILE:vk_azd_runner>
            --spv-dir ${CMAKE_BINARY_DIR}/tests/vk_azd/spv
            --repeat 200
            --warmup 20
            --out ${CMAKE_BINARY_DIR}/tests/vk_azd/results/perf/perf.json
    )

    set_tests_properties(vk_azd_build_shaders PROPERTIES
        LABELS "azd;vulkan"
        FIXTURES_SETUP vk_azd_spv
    )
    set_tests_properties(vk_azd_function vk_azd_perf PROPERTIES
        LABELS "azd;vulkan"
        FIXTURES_REQUIRED vk_azd_spv
    )
elseif(Python3_Interpreter_FOUND)
    message(STATUS "AZD Vulkan CTests require glslang-standalone and SPIRV-Tools executable targets")
endif()
