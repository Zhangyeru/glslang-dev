#!/usr/bin/env python3
# Copyright (C) 2026 The Khronos Group Inc.
# SPDX-License-Identifier: BSD-3-Clause

"""Independent CPU references and inputs for the large FP16/INT8 networks.

The references operate on lists and scalar arithmetic; they neither parse the
GLSL nor consume lowered results. All eight intermediate layers and both output
guards are checked. B includes row-alignment gaps when switching between 48 and
64 columns, plus tail padding to a multiple of 192. Thus every matrix load can
describe the entire B allocation with an integral number of rows, and its
nonzero row offset still denotes an in-bounds rectangle.
"""

import struct


_MATERIAL_WIDTHS = (48, 64, 64, 48, 64, 48, 32, 16, 8)
_AUDIO_WIDTHS = (32, 64, 64, 48, 64, 48, 32, 16, 8)


def _f32(value):
    return struct.unpack("<f", struct.pack("<f", value))[0]


def _f16(value):
    return struct.unpack("<e", struct.pack("<e", value))[0]


def _pack(values, fmt):
    return struct.pack("<" + str(len(values)) + fmt, *values)


def _clamp(value, lower, upper):
    return max(lower, min(upper, value))


def _layout(widths):
    """Return (K, N, weights, bias) for each dense layer and padded B size."""
    layers = []
    cursor = 0
    for inputs, outputs in zip(widths, widths[1:]):
        cursor = (cursor + outputs - 1) // outputs * outputs
        bias = cursor + inputs * outputs
        layers.append((inputs, outputs, cursor, bias))
        cursor = bias + outputs
    return layers, (cursor + 191) // 192 * 192


def _noise(index, seed):
    """Stable, asymmetric integer data; no dependency on Python's RNG version."""
    value = (index + seed * 0x9E3779B9) & 0xFFFFFFFF
    value = ((value ^ (value >> 16)) * 0x7FEB352D) & 0xFFFFFFFF
    value = ((value ^ (value >> 15)) * 0x846CA68B) & 0xFFFFFFFF
    return value ^ (value >> 16)


def _material_reference(inputs, parameters):
    layers, _ = _layout(_MATERIAL_WIDTHS)
    features = [
        _clamp(_f32(_f32(value * inputs[48]) + inputs[49]), -2.0, 2.0)
        for value in inputs[:48]
    ]
    checkpoints = []
    for stage, (rows, columns, weights, bias) in enumerate(layers):
        projected = []
        for column in range(columns):
            accumulator = parameters[bias + column]
            for row in range(rows):
                product = _f32(features[row] * parameters[weights + row * columns + column])
                accumulator = _f32(accumulator + product)
            if stage == 1:
                accumulator = _f32(accumulator + _f32(features[column] * 0.25))
            if stage == len(layers) - 1:
                accumulator = _clamp(_f32(_f32(accumulator * 0.5) + 0.5), 0.0, 1.0)
            else:
                negative = 0.0 if inputs[50] > 0 else _f32(accumulator * 0.125)
                accumulator = _clamp(max(accumulator, negative), -2.0, 2.0)
            projected.append(accumulator)
        features = projected
        checkpoints.extend(projected)
    return checkpoints


def _audio_reference(inputs, parameters):
    layers, _ = _layout(_AUDIO_WIDTHS)
    features = [_clamp(value, -96, 95) for value in inputs[:32]]
    shift, relu = inputs[32:34]
    assert 1 <= shift < 31
    checkpoints = []
    for stage, (rows, columns, weights, bias) in enumerate(layers):
        projected = []
        for column in range(columns):
            accumulator = parameters[bias + column]
            for row in range(rows):
                accumulator += features[row] * parameters[weights + row * columns + column]
            if stage == 1:
                accumulator += features[column] * 2
            # Full int8 weights and bounded activations cannot overflow int32.
            assert -(1 << 31) <= accumulator < (1 << 31)
            if stage != len(layers) - 1:
                accumulator = (accumulator + (1 << (shift - 1))) >> shift
                accumulator = _clamp(accumulator, 0 if relu else -96, 95)
            projected.append(accumulator)
        features = projected
        checkpoints.extend(projected)
    return checkpoints


def _material_datasets():
    layers, count = _layout(_MATERIAL_WIDTHS)
    datasets = []
    controls = (
        ("signed_leaky", 11, 1.25, -0.125, -1.0),
        ("relu", 29, 0.75, 0.25, 1.0),
        ("exposure_clipping", 53, 2.0, -0.25, 0.0),
    )
    for label, seed, exposure, offset, relu in controls:
        inputs = [_f32((_noise(i, seed) % 1025 - 512) / 256.0) for i in range(48)]
        inputs.extend((exposure, offset, relu))
        # Padding carries a distinctive finite poison value. Every real layer
        # is overwritten below, so an accidental cross-layer load is observable.
        parameters = [_f16(-3.25)] * count
        for stage, (rows, columns, weights, bias) in enumerate(layers):
            for element in range(rows * columns):
                value = (_noise(element, seed + 7 * stage) % 769 - 384) / 2048.0
                parameters[weights + element] = _f16(value)
            for column in range(columns):
                value = (_noise(column, seed + 97 + stage) % 513 - 256) / 1024.0
                parameters[bias + column] = _f16(value)
        checkpoints = _material_reference(inputs, parameters)
        initial = [123.25] + [-321.5] * len(checkpoints) + [-77.5]
        expected = [initial[0]] + checkpoints + [initial[-1]]
        datasets.append({
            "label": label,
            "a": _pack(inputs, "f"),
            "b": _pack(parameters, "e"),
            "initial": _pack(initial, "f"),
            "expected": _pack(expected, "f"),
            "format": "f",
            "atol": 2e-5,
            "rtol": 3e-4,
        })
    return datasets


def _audio_datasets():
    layers, count = _layout(_AUDIO_WIDTHS)
    datasets = []
    controls = (("signed_saturating", 17, 4, 0), ("relu", 37, 6, 1), ("signed_rounding", 61, 7, 0))
    for label, seed, shift, relu in controls:
        inputs = [_noise(i, seed) % 257 - 128 for i in range(32)] + [shift, relu]
        parameters = [-113] * count
        for stage, (rows, columns, weights, bias) in enumerate(layers):
            for element in range(rows * columns):
                parameters[weights + element] = _noise(element, seed + 7 * stage) % 63 - 31
            for column in range(columns):
                parameters[bias + column] = _noise(column, seed + 97 + stage) % 127 - 63
        checkpoints = _audio_reference(inputs, parameters)
        initial = [0x12345678] + [-7654321] * len(checkpoints) + [-0x1234567]
        expected = [initial[0]] + checkpoints + [initial[-1]]
        datasets.append({
            "label": label,
            "a": _pack(inputs, "i"),
            "b": _pack(parameters, "b"),
            "initial": _pack(initial, "i"),
            "expected": _pack(expected, "i"),
            "format": "i",
            "atol": 0,
            "rtol": 0,
        })
    return datasets


def cases():
    """Cases consumed by run_large_tests.py; file names are shader-dir relative."""
    result = []
    for name, widths, features, datasets in (
        ("material_mlp_f16_f32", _MATERIAL_WIDTHS, "f16,s16", _material_datasets),
        ("quantized_audio_i8", _AUDIO_WIDTHS, "i8,s8", _audio_datasets),
    ):
        layers, count = _layout(widths)
        result.append({
            "name": name,
            "source": name + ".comp",
            "baseline": name + "_baseline.comp",
            "features": features,
            "macs": sum(rows * columns for rows, columns, _, _ in layers),
            "parameter_elements": count,
            "min_instructions": 850,
            "required_hw": {
                "OpCooperativeMatrixLoadHW": 8,
                "OpCooperativeVectorMatrixMulAddHW": 8,
                "OpCooperativeVectorStoreHW": 8,
            },
            "datasets": datasets,
        })
    return result
