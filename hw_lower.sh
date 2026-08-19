#!/bin/bash

# Usage: ./hw_lower.sh <input.glsl> [output.spv]
# Example: ./hw_lower.sh Test/spv.coopvecHW.comp
#          ./hw_lower.sh Test/spv.coopvecHW.comp output.spv
#
# Tool paths may be overridden with GLSLANG, SPIRV_OPT, SPIRV_DIS,
# SPIRV_VAL, and SPIRV_CROSS. Bare tool names are resolved through PATH.
# TARGET_ENV defaults to vulkan1.3.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
readonly SCRIPT_DIR

usage()
{
    echo "Usage: $0 <input.glsl> [output.spv]" >&2
}

find_tool()
{
    local candidate=$1
    local description=$2
    local resolved

    if [[ $candidate == */* ]]; then
        if [[ ! -x $candidate ]]; then
            echo "Error: $description is not executable: '$candidate'" >&2
            return 1
        fi
        printf '%s\n' "$candidate"
        return
    fi

    resolved=$(command -v -- "$candidate" || true)
    if [[ -z $resolved ]]; then
        echo "Error: $description '$candidate' was not found on PATH" >&2
        return 1
    fi
    printf '%s\n' "$resolved"
}

print_command()
{
    printf '  '
    printf '%q ' "$@"
    printf '\n'
}

run_command()
{
    print_command "$@"
    "$@"
}

has_hw_residue()
{
    grep -Eq '^[[:space:]]*(%[^[:space:]=]+[[:space:]]*=[[:space:]]*)?Op[A-Za-z0-9_]*HW([[:space:]]|$)' "$1" ||
        grep -Eq '^[[:space:]]*OpCapability[[:space:]]+[^[:space:]]*(HW|AZD)([[:space:]]|$)' "$1" ||
        grep -Eq '^[[:space:]]*OpExtension[[:space:]]+"SPV_(HW|AZD)_[A-Za-z0-9_]+"' "$1" ||
        grep -Eq '^[[:space:]]*OpSourceExtension[[:space:]]+"GL_(HW|AZD)_[A-Za-z0-9_]+"' "$1" ||
        grep -Eq '^[[:space:]]*OpSelectionMerge[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]*Relreg' "$1"
}

if (( $# < 1 || $# > 2 )); then
    usage
    exit 2
fi

readonly INPUT=$1
if [[ ! -f $INPUT ]]; then
    echo "Error: input file '$INPUT' not found" >&2
    exit 1
fi

GLSLANG=$(find_tool "${GLSLANG:-$SCRIPT_DIR/build/StandAlone/glslang}" "glslang")
SPIRV_OPT=$(find_tool "${SPIRV_OPT:-$SCRIPT_DIR/build/External/spirv-tools/tools/spirv-opt}" "spirv-opt")
SPIRV_DIS=$(find_tool "${SPIRV_DIS:-$SCRIPT_DIR/build/External/spirv-tools/tools/spirv-dis}" "spirv-dis")
SPIRV_VAL=$(find_tool "${SPIRV_VAL:-$SCRIPT_DIR/build/External/spirv-tools/tools/spirv-val}" "spirv-val")
SPIRV_CROSS=$(find_tool "${SPIRV_CROSS:-spirv-cross}" "spirv-cross")
readonly GLSLANG SPIRV_OPT SPIRV_DIS SPIRV_VAL SPIRV_CROSS

readonly TARGET_ENV=${TARGET_ENV-vulkan1.3}

if [[ -z $TARGET_ENV ]]; then
    echo "Error: TARGET_ENV must not be empty" >&2
    exit 1
fi

# Retain the shader-stage suffix in the default artifact name, so shaders such
# as foo.comp and foo.frag cannot overwrite one another.
if (( $# == 2 )); then
    OUTPUT=$2
else
    OUTPUT="$(basename -- "$INPUT").hw.spv"
fi

readonly OUTPUT
OUTPUT_DIR=$(dirname -- "$OUTPUT")
readonly OUTPUT_DIR
OUTPUT_NAME=$(basename -- "$OUTPUT")
if [[ $OUTPUT_NAME == *.hw.spv ]]; then
    ARTIFACT_STEM=${OUTPUT_NAME%.hw.spv}
elif [[ $OUTPUT_NAME == *.spv ]]; then
    ARTIFACT_STEM=${OUTPUT_NAME%.spv}
else
    ARTIFACT_STEM=$OUTPUT_NAME
fi

if [[ -z $ARTIFACT_STEM ]]; then
    echo "Error: output '$OUTPUT' has an empty artifact stem" >&2
    exit 1
fi

readonly LOWERED="$OUTPUT_DIR/$ARTIFACT_STEM.lowered.spv"
readonly DISASM="$OUTPUT_DIR/$ARTIFACT_STEM.lowered.spvasm"
readonly GLSL_OUT="$OUTPUT_DIR/$ARTIFACT_STEM.lowered.glsl"

mkdir -p -- "$OUTPUT_DIR"

echo "=== Step 1: Compile GLSL -> SPIR-V ==="
run_command "$GLSLANG" -V "$INPUT" -o "$OUTPUT"

echo "=== Step 2: Extension-free packed HW lowering ==="
print_command "$SPIRV_OPT" --hw-lower-to-standard-extension-free "$OUTPUT" -o "$LOWERED"
if "$SPIRV_OPT" --hw-lower-to-standard-extension-free "$OUTPUT" -o "$LOWERED"; then
    :
else
    status=$?
    rm -f -- "$LOWERED"
    echo "Error: extension-free HW lowering failed for '$INPUT'" >&2
    exit "$status"
fi

echo "=== Step 3: Validate lowered SPIR-V for $TARGET_ENV ==="
run_command "$SPIRV_VAL" --target-env "$TARGET_ENV" "$LOWERED"

echo "=== Step 4: Disassemble lowered SPIR-V ==="
run_command "$SPIRV_DIS" "$LOWERED" -o "$DISASM"
if has_hw_residue "$DISASM"; then
    echo "Error: HW/AZD residue remains after extension-free lowering: '$DISASM'" >&2
    exit 1
fi

echo "=== Step 5: SPIRV-Cross -> Vulkan GLSL ==="
run_command "$SPIRV_CROSS" "$LOWERED" --output "$GLSL_OUT" --vulkan-semantics

echo "Done. Outputs:"
echo "  SPIR-V binary:      $OUTPUT"
echo "  Lowered SPIR-V:     $LOWERED"
echo "  Disassembly:        $DISASM"
echo "  GLSL (spirv-cross): $GLSL_OUT"
