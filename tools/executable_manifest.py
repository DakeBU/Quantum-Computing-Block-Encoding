#!/usr/bin/env python3
"""Versioned executable-check and export policy shared by CLI and website."""

from __future__ import annotations

from copy import deepcopy
from typing import Mapping


CHECK_BACKENDS = ("none", "qiskitOperator", "openqasm3RoundTrip", "both")
EXPORT_FORMATS = (
    "canonicalIrJson",
    "qiskitPython",
    "openqasm3",
    "metricsJson",
    "circuitText",
)
EVIDENCE_CLASSES = (
    "syntaxOnly",
    "roundTrip",
    "numericUnitary",
    "numericCleanBlock",
    "leanCheckedRefinement",
)


def default_executable_policy() -> dict[str, object]:
    return {
        "intermediateCheck": {
            "backend": "both",
            "required": True,
            "unitarityTolerance": 1e-10,
            "cleanBlockTolerance": 1e-10,
            "requireCanonicalRoundTrip": True,
        },
        "exports": {
            "formats": ["canonicalIrJson", "qiskitPython", "openqasm3", "metricsJson"]
        },
    }


def migrate_task_packet(packet: Mapping[str, object]) -> dict[str, object]:
    """Migrate the legacy task-builder packet without discarding user fields."""

    result = deepcopy(dict(packet))
    version = int(result.get("schemaVersion", 1))
    if version > 2:
        raise ValueError(f"unsupported task packet schemaVersion {version}")
    if version == 1:
        old = result.pop("exports", {})
        old = old if isinstance(old, Mapping) else {}
        formats = ["canonicalIrJson", "metricsJson"]
        if old.get("qiskit") is True:
            formats.append("qiskitPython")
        if old.get("qasm3") is True:
            formats.append("openqasm3")
        if old.get("qiskit") and old.get("qasm3"):
            backend = "both"
        elif old.get("qiskit"):
            backend = "qiskitOperator"
        elif old.get("qasm3"):
            backend = "openqasm3RoundTrip"
        else:
            backend = "none"
        result["executablePolicy"] = default_executable_policy()
        result["executablePolicy"]["intermediateCheck"]["backend"] = backend  # type: ignore[index]
        result["executablePolicy"]["intermediateCheck"]["required"] = backend != "none"  # type: ignore[index]
        result["executablePolicy"]["exports"]["formats"] = list(dict.fromkeys(formats))  # type: ignore[index]
        result["schemaVersion"] = 2
    validate_executable_policy(result.get("executablePolicy"))
    return result


def validate_executable_policy(value: object) -> None:
    if not isinstance(value, Mapping):
        raise ValueError("executablePolicy must be an object")
    check = value.get("intermediateCheck")
    exports = value.get("exports")
    if not isinstance(check, Mapping) or check.get("backend") not in CHECK_BACKENDS:
        raise ValueError("invalid intermediate check backend")
    if not isinstance(check.get("required"), bool):
        raise ValueError("intermediate check required must be boolean")
    for key in ("unitarityTolerance", "cleanBlockTolerance"):
        tolerance = check.get(key)
        if not isinstance(tolerance, (int, float)) or tolerance < 0:
            raise ValueError(f"invalid {key}")
    if not isinstance(check.get("requireCanonicalRoundTrip"), bool):
        raise ValueError("requireCanonicalRoundTrip must be boolean")
    if not isinstance(exports, Mapping) or not isinstance(exports.get("formats"), list):
        raise ValueError("export formats must be a list")
    formats = exports["formats"]
    if len(formats) != len(set(formats)) or any(item not in EXPORT_FORMATS for item in formats):
        raise ValueError("unsupported or duplicate export format")

