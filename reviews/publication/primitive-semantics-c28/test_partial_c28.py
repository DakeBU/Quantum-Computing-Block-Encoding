"""Assert genuine partial evidence, never turn OOM or missing files green."""
import hashlib
import json
from pathlib import Path
import unittest
from unittest.mock import patch

PACKET = Path(__file__).resolve().parent
ROOT = PACKET.parents[2]
DECODER = PACKET / "decoder-c28"
RESUME = PACKET / "decoder-c28-resume1"
read = lambda p: json.loads(p.read_text(encoding="utf-8"))
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()


class PartialC28(unittest.TestCase):
    def test_all_actual_public_bytes(self):
        path = PACKET / "parent-partial-transport.json"
        self.assertEqual(sha(path), "3451bdd118862f32ba12bbf701bec1e429e995244b08f20e2881f944074771df")
        manifest = read(path)
        self.assertFalse(manifest["admission"])
        self.assertEqual(len(manifest["artifacts"]), 20)
        for row in manifest["artifacts"]:
            path = ROOT / row["path"]
            self.assertTrue(path.is_file(), row["path"])
            self.assertEqual(sha(path), row["sha256"])
            self.assertEqual(path.stat().st_size, row["bytes"])

    def test_missing_partial_input_is_not_green(self):
        original = Path.is_file
        absent = RESUME / "environment-precheck.json"
        with patch.object(Path, "is_file", lambda p: False if p == absent else original(p)):
            result = unittest.TestResult()
            PartialC28("test_all_actual_public_bytes").run(result)
        self.assertEqual(len(result.failures), 1)
        self.assertEqual(result.errors, [])

    def test_original_whole_source_and_configuration_bindings(self):
        seal = read(DECODER / "initial-seal-v2.json")
        self.assertEqual(len(seal["inputs"]), 23)
        self.assertEqual(seal["phase"], "before_first_Lean_command")
        for module, row in seal["inputs"].items():
            name = module.replace(".", "/")
            self.assertEqual(sha(ROOT / (name + ".lean")), row["source_sha256"])
            self.assertEqual(sha(ROOT / ".lake/build/lib/lean" / (name + ".olean")), row["inherited_olean_sha256"])
        for name, expected in seal["configuration"].items():
            self.assertEqual(sha(ROOT / name), expected)
        for name, count in (("ConcreteSemantics", 25), ("PrimitiveSemantics", 55), ("ReversibleClassical", 8)):
            rows = seal["inputs"]["QuantumBlockEncoding." + name]["inventory"]["declarations"]
            self.assertEqual(len(rows), count)
            self.assertFalse(any(row["private"] for row in rows))
        self.assertEqual(sha(DECODER / "initial-seal.json"), seal["supersedes_inventory_only"]["sha256"])

    def test_original_oom_is_not_axiom_or_source_acceptance(self):
        result = read(DECODER / "verification-summary.json")
        self.assertEqual(result["successful_actual_source_compiles"], ["ConcreteSemantics"])
        self.assertIn("out of memory", result["failed_actual_source_compiles"]["PrimitiveSemantics"])
        self.assertEqual(result["unattempted_actual_source_compiles"], ["ReversibleClassical"])
        self.assertEqual(result["executed_check_axiom_probes"], 0)
        self.assertEqual(result["pending_named_root_check_axiom_probes"], 88)
        self.assertIsNone(result["sourceAgreement"])
        self.assertIsNone(result["opaqueAuthorPacketBinding"])
        self.assertFalse(result["axiom_cleanliness_claim"])
        self.assertFalse(result["clean_transitive_rebuild"])
        self.assertIn("out of memory", (DECODER / "logs/PrimitiveSemantics.stderr.public.log").read_text())
        self.assertEqual((DECODER / "logs/PrimitiveSemantics.stdout.public.log").read_bytes(), b"")

    def test_resume_stopped_before_lean(self):
        result = read(RESUME / "decoder-packet.json")
        self.assertEqual(result["status"], "ENV_BLOCKED_PRECHECK_NO_LEAN_LAUNCH")
        self.assertEqual(result["original_packet_sha256"], sha(DECODER / "decoder-packet.json"))
        self.assertEqual(result["verification_summary_sha256"], sha(RESUME / "verification-summary.json"))
        env = read(RESUME / "environment-precheck.json")
        self.assertLess(env["free_virtual_bytes"], env["thresholds_bytes"]["virtual_min"])
        self.assertFalse(env["checks"]["virtual"])
        self.assertEqual(env["proof_calls"], 0)
        self.assertEqual(env["lean_help_calls"], 0)
        self.assertEqual(read(RESUME / "log-allowlist.json")["new_lean_logs"], [])
        self.assertIsNone(result["sourceAgreement"])

    def test_source_first_review_not_implementation_review(self):
        seal = read(PACKET / "reviewer-c28/phase1-seal.json")
        self.assertEqual(sha(PACKET / "source-only.md"), seal["source"]["sha256"])
        self.assertEqual(sha(PACKET / "reviewer-c28/source-only-notes.md"), seal["notes"]["sha256"])
        self.assertEqual(seal["phase"], "SOURCE_ONLY_FROZEN_BEFORE_FORMAL_ACCESS")
        self.assertFalse(seal["implementation_accepted"])
        self.assertFalse(seal["publication_admission_granted"])
        self.assertIn("implementation and actual formal signatures", seal["unread"])
        self.assertIn("decoder reconstruction", seal["unread"])


if __name__ == "__main__":
    unittest.main()
