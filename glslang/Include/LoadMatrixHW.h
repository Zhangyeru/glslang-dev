//
// Copyright (C) 2002-2005  3Dlabs Inc. Ltd.
// Copyright (C) 2012-2016 LunarG, Inc.
// Copyright (C) 2017, 2022-2024 Arm Limited.
// Modifications Copyright (C) 2020 Advanced Micro Devices, Inc. All rights reserved.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
//    Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
//    Redistributions in binary form must reproduce the above
//    copyright notice, this list of conditions and the following
//    disclaimer in the documentation and/or other materials provided
//    with the distribution.
//
//    Neither the name of 3Dlabs Inc. Ltd. nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//

#ifndef GLSLANG_LOAD_MATRIX_HW_H
#define GLSLANG_LOAD_MATRIX_HW_H

#include "intermediate.h"

namespace glslang {

struct TLoadMatrixHWVariant {
    TOperator op;
    const char* name;
    TBasicType componentType;
    int rows;
    int columns;
    unsigned int offsetAlignment;
};

// Keep shape, component type, and byte alignment together for each public builtin.
static const TLoadMatrixHWVariant LoadMatrixHWVariants[] = {
    {EOpLoadMatrixB8X1Burst1RowHW, "ldmatrix_b8_x1_burst1_R", EbtInt8, 16, 16, 16},
    {EOpLoadMatrixB8X1Burst2RowHW, "ldmatrix_b8_x1_burst2_R", EbtInt8, 16, 32, 32},
    {EOpLoadMatrixB8X2Burst1RowHW, "ldmatrix_b8_x2_burst1_R", EbtInt8, 32, 16, 16},
    {EOpLoadMatrixB8X2Burst2RowHW, "ldmatrix_b8_x2_burst2_R", EbtInt8, 32, 32, 32},
    {EOpLoadMatrixB8X1Burst1ColumnHW, "ldmatrix_b8_x1_burst1_C", EbtInt8, 16, 16, 16},
    {EOpLoadMatrixB8X1Burst2ColumnHW, "ldmatrix_b8_x1_burst2_C", EbtInt8, 32, 16, 32},
    {EOpLoadMatrixB8X2Burst1ColumnHW, "ldmatrix_b8_x2_burst1_C", EbtInt8, 16, 32, 16},
    {EOpLoadMatrixB8X2Burst2ColumnHW, "ldmatrix_b8_x2_burst2_C", EbtInt8, 32, 32, 32},
    {EOpLoadMatrixB16X1Burst1RowHW, "ldmatrix_b16_x1_burst1_R", EbtInt16, 16, 8, 16},
    {EOpLoadMatrixB16X1Burst2RowHW, "ldmatrix_b16_x1_burst2_R", EbtInt16, 16, 16, 32},
    {EOpLoadMatrixB16X2Burst1RowHW, "ldmatrix_b16_x2_burst1_R", EbtInt16, 32, 8, 16},
    {EOpLoadMatrixB16X2Burst2RowHW, "ldmatrix_b16_x2_burst2_R", EbtInt16, 32, 16, 32},
    {EOpLoadMatrixB16X1Burst2ColumnHW, "ldmatrix_b16_x1_burst2_C", EbtInt16, 16, 16, 32},
    {EOpLoadMatrixB16X2Burst2ColumnHW, "ldmatrix_b16_x2_burst2_C", EbtInt16, 16, 32, 32},
};

inline const TLoadMatrixHWVariant* getLoadMatrixHWVariant(TOperator op)
{
    for (const auto& variant : LoadMatrixHWVariants) {
        if (variant.op == op)
            return &variant;
    }
    return nullptr;
}

} // namespace glslang

#endif // GLSLANG_LOAD_MATRIX_HW_H
