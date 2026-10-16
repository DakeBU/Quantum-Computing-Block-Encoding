"""Assert genuine partial evidence, never turn OOM or missing files green."""
import hashlib
import importlib.util
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
    def test_author_wip_originals_and_lossless_coverage(self):
        path = PACKET / "outputs-manifest.json"
        self.assertEqual(sha(path), "1e238b21c3209fe3d4cf9e662c9bde1eaca6441529dce2e5e660e79dee236cd0")
        manifest = read(path)
        self.assertEqual(len(manifest["artifacts"]), 18)
        self.assertFalse(manifest["independent_acceptance"])
        for row in manifest["artifacts"]:
            actual = ROOT / row["planned_canonical_path"]
            self.assertEqual(sha(actual), row["sha256"])
            self.assertEqual(actual.stat().st_size, row["bytes"])
        coverage = read(PACKET / "author-source-coverage.json")
        paragraphs = coverage["source_paragraphs"]
        self.assertEqual(len(paragraphs), 39)
        self.assertEqual("".join(p["exact_text"] for p in paragraphs).encode(), (PACKET / "source-only.md").read_bytes())
        self.assertEqual(len(coverage["whole_module_inventory"]), 88)
        source_graph = read(PACKET / "author-graph-views.json")["views"]["source-construction-graph"]
        self.assertEqual(len(source_graph["AND_hyperedges"]), 23)
        self.assertEqual(len(source_graph["open_source_gap_ids"]), 7)
        nodes = {n["id"] for n in source_graph["nodes"]}
        for edge in source_graph["AND_hyperedges"]:
            self.assertEqual(edge["logic"], "AND")
            self.assertTrue(set(edge["tails"] + edge["heads"]) <= nodes)

    def test_actual_static_delivery_excludes_decoder_and_compiler(self):
        path = PACKET / "static-review-inputs-c28.json"
        self.assertEqual(sha(path), "f8a52c1757c243ec9ab4b9521ace7522ee902a08c0e55c97264cc4222c9ba12b")
        packet = read(path)
        self.assertEqual(len(packet["input_sha256"]), 31)
        self.assertFalse(packet["main_reader_purification_scientific_ROOT"])
        for name, expected in packet["input_sha256"].items():
            self.assertNotIn("/decoder-c28", name)
            self.assertNotIn("parent-partial-transport", name)
            self.assertEqual(sha(ROOT / name), expected)

    def test_prospective_bindings_replay_without_admission(self):
        spec = importlib.util.spec_from_file_location("c28_prospective", ROOT / "website/scripts/check_research_publications.py")
        checker = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(checker)
        source = read(PACKET / "author-source-row-candidate.json")["source"]
        catalog = read(ROOT / "website/research/sources.json")
        own = [row for row in catalog["sources"] if row["id"] == source["id"]]
        if own:
            self.assertEqual(own, [source])
        else:
            catalog["sources"].append(source)
        original = checker.load
        with patch.object(checker, "load", lambda root, name: catalog if name == "website/research/sources.json" else original(root, name)):
            for path in read(PACKET / "static-review-inputs-c28.json")["candidate_paths"]:
                record = read(ROOT / path)
                self.assertEqual(checker.binding_digest(ROOT, record), record["binding_sha256"])
                self.assertEqual(record["status"], "PARENT_PROPOSAL_WIP_NOT_ADMITTED")
                self.assertIn("/decoder-c28/", record["decoder_evidence"])
                self.assertIn("/reviewer-c28/", record["reviewer_evidence"])

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
