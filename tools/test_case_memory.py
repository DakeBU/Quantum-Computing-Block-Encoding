#!/usr/bin/env python3
"""Focused tests for contributed-case identity and promotion boundaries."""

from __future__ import annotations

import copy
import unittest

from tools.qbe import _case_contains_secret, canonical_case_hash, validate_case_packet


def packet() -> dict:
    value = {
        "schema_version": "2.0", "id": "sample-state", "title": "Sample",
        "kind": "statePreparation", "status": "draft",
        "mathematics": {"target": "|1>", "normalizer": "1", "projector": "|0>", "epsilon": "0", "semantic_tier": "exact", "plain": "prepare one", "latex": "X|0>=|1>", "assumptions": []},
        "lean": {"imports": [], "code": "example : True := by trivial", "proposed_name": "sample", "dependencies": [], "root": ""},
        "provenance": {"source": "user", "locator": "", "generated": False, "model_tool_version": "", "notes": ""},
        "contributor": {"name": "Tester", "credit": "Tester", "contact": "", "display_preference": "full"},
        "verification": {"compiler_command": "lake env lean", "accepted": False, "diagnostics": "draft"},
        "executable": {"advertised": False, "artifact": "", "accepted": False, "diagnostics": ""},
        "resource": {"convention": "none", "record": None},
        "license": {"spdx": "MIT", "agreed": True},
        "reuse_consent": {"public_repository": True, "public_retrieval": False, "training_reuse": False},
        "case_hash": "",
    }
    value["case_hash"] = canonical_case_hash(value)
    return value


class CaseMemoryTests(unittest.TestCase):
    def test_valid_draft(self) -> None:
        validate_case_packet(packet())

    def test_credit_does_not_change_identity(self) -> None:
        first = packet()
        second = copy.deepcopy(first)
        second["contributor"]["name"] = "Another contributor"
        self.assertEqual(canonical_case_hash(first), canonical_case_hash(second))

    def test_secret_field_is_rejected(self) -> None:
        value = packet()
        value["runner"] = {"api_key": "secret"}
        self.assertEqual(_case_contains_secret(value), "runner.api_key")
        with self.assertRaisesRegex(ValueError, "credential-like"):
            validate_case_packet(value)

    def test_pending_is_not_verified(self) -> None:
        value = packet()
        value["status"] = "pendingReview"
        value["case_hash"] = canonical_case_hash(value)
        with self.assertRaisesRegex(ValueError, "compiler evidence"):
            validate_case_packet(value, promotion=True)


if __name__ == "__main__":
    unittest.main()
