"""Compatibility is explicit and cannot accept a mathematical/code mutation."""
from copy import deepcopy
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(B / "src"))
from qcb_integrity import text_sha
from qcb_migration import (LEDGER, SOURCE_PATH, PIPELINE_PATHS, _historical,
                           equivalent, pipeline_matches, source_matches)


class IntegrationMigrationTests(unittest.TestCase):
    def setUp(self):
        self.ledger = json.loads((R / LEDGER).read_text(encoding="utf-8"))

    def test_exact_historical_blobs_and_approved_compatibility(self):
        for relative, record in self.ledger["inputs"].items():
            with self.subTest(path=relative):
                old = _historical(str(R), record["original_commit"], relative)
                self.assertEqual(hashlib.sha256(old).hexdigest(), record["original_sha256"])
                self.assertEqual(text_sha(R / relative), record["current_sha256"])
                self.assertTrue(equivalent(old.decode(), (R / relative).read_text(encoding="utf-8"), relative))
                if record["kind"] == "source":
                    self.assertTrue(source_matches(R, relative, record["original_sha256"]))
                else:
                    self.assertTrue(pipeline_matches(R / relative, record["original_sha256"]))

    def test_unrelated_source_and_escape_are_never_migrated(self):
        for relative in ["QuantumBlockEncoding/StatePreparation.lean", "../escape"]:
            self.assertFalse(source_matches(R, relative, "0" * 64))

    def test_pipeline_hash_tamper_rejected(self):
        for relative in PIPELINE_PATHS:
            self.assertFalse(pipeline_matches(R / relative, "0" * 64))

    def test_code_mutation_not_compatible_even_with_new_declared_hash(self):
        relative = "benchmarks/quantumcomputingbench/src/qcb_nl.py"
        record = self.ledger["inputs"][relative]
        old = _historical(str(R), record["original_commit"], relative).decode()
        current = (R / relative).read_text(encoding="utf-8")
        self.assertFalse(equivalent(old, current + "\nUNREVIEWED_SEMANTICS = True\n", relative))

    def test_attribution_order_and_affiliation_are_exact(self):
        record = self.ledger["inputs"][SOURCE_PATH]
        old = _historical(str(R), record["original_commit"], SOURCE_PATH).decode()
        current = (R / SOURCE_PATH).read_text(encoding="utf-8")
        self.assertFalse(equivalent(old, current.replace('"Outongyi Lv"', '"Unapproved Person"'), SOURCE_PATH))
        self.assertFalse(equivalent(old, current + "\nSEMANTIC_CHANGE = 1\n", SOURCE_PATH))

    def test_changed_ledger_does_not_authorize_a_semantic_change(self):
        relative = "benchmarks/quantumcomputingbench/src/qcb_nl.py"
        record = self.ledger["inputs"][relative]
        original = _historical(str(R), record["original_commit"], relative)
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            target = root / relative
            target.parent.mkdir(parents=True)
            target.write_text((R / relative).read_text(encoding="utf-8") + "\nNEW_RULE = False\n", encoding="utf-8")
            ledger = deepcopy(self.ledger)
            ledger["inputs"][relative]["current_sha256"] = text_sha(target)
            policy = root / LEDGER
            policy.parent.mkdir(parents=True)
            policy.write_text(json.dumps(ledger), encoding="utf-8")
            with patch("qcb_migration._historical", return_value=original):
                self.assertFalse(pipeline_matches(target, record["original_sha256"]))


if __name__ == "__main__":
    unittest.main()
