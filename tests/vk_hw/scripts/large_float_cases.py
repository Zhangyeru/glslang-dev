# Copyright (C) 2026 The Khronos Group Inc.
# SPDX-License-Identifier: BSD-3-Clause

"""Independent f32 oracles for the large restoration models.

Parameters use reproducible, bounded binary fractions. Every layer has distinct
weights and biases; none of the models is an identity or a cancelling chain.
The references implement the mathematical network without parsing shader code
or consuming a lowered shader. Both the ordinary GLSL and HW shaders must agree
with the CPU result, including all intermediate checkpoints and unwritten lanes.
"""

import struct


def _f32(value):
    return struct.unpack("<f", struct.pack("<f", value))[0]


def _pack(values):
    return struct.pack("<" + "f" * len(values), *values)


def _add(left, right):
    return _f32(left + right)


def _mul(left, right):
    return _f32(left * right)


def _clamp(value, low, high):
    return max(low, min(high, value))


def _coefficients(count, seed, denominator=512):
    # Local integer PRNG: independent of Python random's implementation/state.
    state = seed
    values = []
    for _ in range(count):
        state ^= (state << 13) & 0xffffffff
        state ^= state >> 17
        state ^= (state << 5) & 0xffffffff
        state &= 0xffffffff
        values.append(((state % 63) - 31) / denominator)
    return values


def _affine(vector, parameters, weight_offset, bias_offset, columns):
    result = []
    for column in range(columns):
        total = 0.0
        for row, value in enumerate(vector):
            total = _add(total, _mul(value, parameters[weight_offset + row * columns + column]))
        result.append(_add(total, parameters[bias_offset + column]))
    return result


def _features(seed):
    current = _coefficients(32, 0x6729 + 53 * seed, 32)
    history = _coefficients(32, 0x9413 + 71 * seed, 48)
    # Round non-binary fractions before both shader and oracle consume them.
    return list(map(_f32, current)), list(map(_f32, history))


def _blend(current, history, weight):
    return [_add(_mul(now, _f32(1.0 - weight)), _mul(old, weight))
            for now, old in zip(current, history)]


def _output(count):
    # Finite exactly representable poison, including the first and last guards.
    # A shader that forgets a result/checkpoint write cannot pass by accident.
    return [-8192.0 + index * 0.25 for index in range(count)]


def _dataset(label, a, b, initial, expected):
    return {
        "label": label,
        "a": _pack(a),
        "b": _pack(b),
        "initial": _pack(initial),
        "expected": _pack(expected),
        "format": "f",
        # The CPU rounds separate multiplies/adds. Vulkan implementations may
        # contract/reassociate dot products; these tolerances still distinguish
        # layer, route, iteration, offset, and activation errors by wide margins.
        "atol": 3e-5,
        "rtol": 3e-5,
    }


def _residual_parameters():
    parameters = _coefficients(16896, 0xc239)
    for block in range(8):
        base = block * 2112
        parameters[base + 1024:base + 1056] = _coefficients(32, 0x31d + 97 * block, 128)
        parameters[base + 2080:base + 2112] = _coefficients(32, 0x71b + 53 * block, 128)
    return parameters


def _residual_datasets():
    parameters = _residual_parameters()
    datasets = []
    branch_traces = []
    for seed, confidence in enumerate((0.0625, 0.4375, 0.9375)):
        current, history = _features(seed)
        history_weight = (0.125, 0.5, 0.875)[seed]
        inputs = [history_weight, confidence, 19.0, -23.0] + current + history
        initial = _output(291)
        expected = initial.copy()
        value = _blend(current, history, history_weight)
        trace = []
        for block in range(8):
            base = block * 2112
            detail = [max(x, 0.0) for x in _affine(value, parameters, base, base + 1024, 32)]
            correction = [_clamp(x, -1.0, 1.0)
                          for x in _affine(detail, parameters, base + 1056, base + 2080, 32)]
            high_confidence = confidence > (0.25, 0.375, 0.5)[block % 3]
            trace.append(high_confidence)
            gain = 0.25 if high_confidence else 0.125
            value = [_clamp(_add(x, _mul(delta, gain)), -2.0, 2.0)
                     for x, delta in zip(value, correction)]
            confidence = _clamp(_add(confidence, _mul(correction[3 * block], 0.0625)), 0.0, 1.0)
            expected[33 + block * 32:65 + block * 32] = value
        expected[1:33] = [_add(_mul(x, 0.75), _mul(now, 0.25)) for x, now in zip(value, current)]
        expected[289] = confidence
        branch_traces.append(trace)
        datasets.append(_dataset(("low", "mixed", "high")[seed] + "_confidence",
                                 inputs, parameters, initial, expected))
    # Guarantee that every block's branch has both outcomes across the data set.
    assert not any(branch_traces[0]) and all(branch_traces[2])
    assert any(branch_traces[1]) and not all(branch_traces[1])
    return datasets


def _expert_parameters():
    # 220*48 and 330*32 describe the same backing allocation. The final 48
    # elements pad the learned weights/biases to those complete matrix extents.
    parameters = _coefficients(10560, 0x8635)
    for route in range(3):
        expansion_bias = _coefficients(48, 0x19f + 79 * route, 128)
        projection_bias = _coefficients(32, 0x6d3 + 83 * route, 128)
        parameters[10240 + route * 48:10288 + route * 48] = expansion_bias
        parameters[10384 + route * 32:10416 + route * 32] = projection_bias
    parameters[10480:10512] = _coefficients(32, 0x3241, 128)
    return parameters


def _expert_datasets():
    parameters = _expert_parameters()
    datasets = []
    for seed, input_confidence in enumerate((0.125, 0.5, 0.875)):
        current, history = _features(seed + 3)
        history_weight = (0.25, 0.5, 0.75)[seed]
        results = []
        for route in range(3):
            for iterations in (1, 2):
                inputs = [float(route), float(iterations), history_weight, input_confidence] + current + history
                initial = _output(133)
                expected = initial.copy()
                value = _blend(current, history, history_weight)
                confidence = input_confidence
                expected[33:65] = value
                for iteration in range(iterations):
                    hidden = [max(x, 0.0) for x in _affine(value, parameters, route * 1536,
                                                         10240 + route * 48, 48)]
                    residual = [_clamp(x, -0.5, 0.5)
                                for x in _affine(hidden, parameters, 4608 + route * 1536,
                                                 10384 + route * 32, 32)]
                    strength = 0.5 if confidence > (0.375, 0.5, 0.625)[route] else 0.25
                    value = [_clamp(_add(x, _mul(delta, strength)), -2.0, 2.0)
                             for x, delta in zip(value, residual)]
                    confidence = _clamp(_add(confidence, _mul(residual[route * 7], 0.125)), 0.0, 1.0)
                    expected[65 + iteration * 32:97 + iteration * 32] = value
                projected = _affine(value, parameters, 9216, 10480, 32)
                expected[1:33] = [_add(x, _mul(residual, 0.5)) for x, residual in zip(projected, value)]
                expected[129:132] = [float(route), float(iterations), confidence]
                results.append(expected[1:33])
                datasets.append(_dataset(f"input{seed}_route{route}_iterations{iterations}",
                                         inputs, parameters, initial, expected))
        # Compare result lanes alone: metadata cannot mask inert routing/loops.
        for left in range(len(results)):
            for right in range(left):
                assert max(abs(a - b) for a, b in zip(results[left], results[right])) > 1e-3
    return datasets


def cases():
    """Descriptors consumed by run_large_tests.py; MACs are maximum per invocation."""
    return [
        {
            "name": "residual_denoiser_f32",
            "source": "residual_denoiser_f32.comp",
            "baseline": "residual_denoiser_f32_baseline.comp",
            "features": "",
            "macs": 16384,
            "parameter_elements": 16896,
            "min_instructions": 1100,
            "required_hw": {
                "OpTypeCooperativeVectorHW": 1,
                "OpTypeCooperativeMatrixHW": 1,
                "OpCooperativeMatrixLoadHW": 16,
                "OpCooperativeVectorMatrixMulAddHW": 16,
                "OpCooperativeVectorStoreHW": 9,
            },
            "datasets": _residual_datasets,
        },
        {
            "name": "routed_experts_f32",
            "source": "routed_experts_f32.comp",
            "baseline": "routed_experts_f32_baseline.comp",
            "features": "",
            "macs": 7168,
            "parameter_elements": 10560,
            "min_instructions": 650,
            "required_hw": {
                "OpTypeCooperativeVectorHW": 2,
                "OpTypeCooperativeMatrixHW": 3,
                "OpCooperativeMatrixLoadHW": 7,
                "OpCooperativeVectorMatrixMulAddHW": 7,
                "OpCooperativeVectorStoreHW": 3,
                "OpLoopMerge": 1,
            },
            "datasets": _expert_datasets,
        },
    ]
