from __future__ import annotations

import copy
import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from website.scripts import research_atlas as atlas
from website.scripts import check_research_publications as publication


class ResearchCatalogTests(unittest.TestCase):
    def setUp(self):
        self.catalog = atlas.load_catalog()

    def test_catalog(self):
        atlas.validate_catalog(self.catalog)

    def test_every_requested_research_direction_has_acceptance_steps(self):
        routes = {item["id"]: item for item in self.catalog["wiki"]["routes"]}
        self.assertEqual(set(routes), {"spw-structured", "spw-envelope", "spw-no-qram", "spw-controlled", "spw-ground", "spw-gibbs", "spw-fault-tolerant", "spw-verification", "spw-cvdv"})
        self.assertTrue(all(len(r["steps"]) >= 3 for r in routes.values()))

    def test_cannot_promote_conceptual_functor(self):
        self.catalog["atlas"]["hyperedges"][0]["status"] = "Lean-certified"
        with self.assertRaisesRegex(ValueError, "certified Lean functor"):
            atlas.validate_catalog(self.catalog)

    def test_empty_and_tail_fails(self):
        self.catalog["atlas"]["hyperedges"][0]["tails"] = []
        with self.assertRaisesRegex(ValueError, "AND"):
            atlas.validate_catalog(self.catalog)

    def test_unknown_node_fails(self):
        self.catalog["atlas"]["hyperedges"][0]["tails"].append("family:not-a-node")
        with self.assertRaisesRegex(ValueError, "endpoint"):
            atlas.validate_catalog(self.catalog)

    def test_model_switch_is_not_a_lower_bound_result(self):
        self.catalog["wiki"]["routes"][0]["lower_bound"]["comparison_key"] = "free-qram"
        with self.assertRaisesRegex(ValueError, "changes model"):
            atlas.validate_catalog(self.catalog)

    def test_source_candidate_is_retained_not_promoted(self):
        source = next(s for s in self.catalog["sources"]["sources"] if s["id"] == "butterworth-2026-candidate")
        self.assertEqual(source["status"], "primary-source-unavailable")
        self.assertEqual(source["formal_status"], "external-reference")

    def test_unknown_lean_ref_fails_at_publication(self):
        with self.assertRaisesRegex(ValueError, "unknown generated Lean"):
            atlas.validate_catalog(self.catalog, {})

    def test_lookup_packet_is_bounded_and_keeps_full_hyperedges(self):
        packet = atlas.context_packet(self.catalog, route_id="spw-envelope", limit=1000)
        self.assertLessEqual(len(packet["families"]), 6)
        self.assertEqual(len(packet["routes"]), 1)
        original = {e["id"]: e for e in self.catalog["atlas"]["hyperedges"]}
        for edge in packet["hyperedges"]:
            self.assertEqual(edge["tails"], original[edge["id"]]["tails"])
            self.assertTrue(edge["failure_boundary"])

    def test_specific_search_finds_structure(self):
        packet = atlas.context_packet(self.catalog, query="Bernstein")
        self.assertIn("family:hermite-bernstein", [f["id"] for f in packet["families"]])

    def test_latex_is_a_lesson_not_proof_promotion(self):
        text = atlas.family_latex(self.catalog["atlas"]["families"][0])
        self.assertIn("not a new theorem certificate", text)
        self.assertIn(r"\dagger", text)
        self.assertNotIn("†", text)


class PublicationBindingTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.write("QuantumBlockEncoding/Test.lean", "theorem test : True := by trivial\n")
        self.write("lean-toolchain", "test-toolchain\n")
        self.write("lake-manifest.json", "{}\n")
        self.write("lesson.md", "Statement and mathematical proof.\n")
        self.write_json("website/research/sources.json", {"sources": [{"id": "test-source", "status": "primary-text-checked", "anchor": "synthetic fixture"}]})
        self.record = {"module": "QuantumBlockEncoding/Test.lean", "source_id": "test-source", "source_statement": "Synthetic test statement", "source_anchor": "fixture only", "lesson_path": "lesson.md", "declarations": ["test"], "obligation_map": [{"kind": "proof-edge", "source_obligation": "fixture", "declarations": ["test"]}], "assumption_deltas": [{"classification": "same", "source": "True", "formal": "True", "explanation": "fixture"}], "graph_contribution": {"baseline": "test-baseline", "classes": ["add-node"], "node_ids": ["declaration:test"], "views": ["lean-graph"], "preserved_contract": "fixture", "remaining_boundary": "fixture only"}, "formalizer": "test-author", "residual_boundary": "synthetic fixture, never publication evidence", "decoder_evidence": "decoder.json", "reviewer_evidence": "reviewer.json"}
        digest = publication.binding_digest(self.root, self.record)
        self.record["binding_sha256"] = digest
        self.write("decoder-packet.txt", "Anonymous formal context\n")
        self.write("review-packet.txt", "Source and reconstruction\n")
        self.write("decoder-artifact.txt", "Fixture reconstruction\n")
        self.write("review-artifact.txt", "Fixture verdict\n")
        self.decoder = {"role": "decoder", "binding_sha256": digest, "identity": "test-decoder", "run_id": "fixture", "packet_path": "decoder-packet.txt", "packet_sha256": hashlib.sha256((self.root / "decoder-packet.txt").read_bytes()).hexdigest(), "artifact_path": "decoder-artifact.txt", "source_blind": True, "reconstruction": "True"}
        self.reviewer = {"role": "reviewer", "binding_sha256": digest, "identity": "test-reviewer", "run_id": "fixture", "packet_path": "review-packet.txt", "packet_sha256": hashlib.sha256((self.root / "review-packet.txt").read_bytes()).hexdigest(), "artifact_path": "review-artifact.txt", "anti_anchored": True, "verdict": "accepted", "semantic_slots": {key: "fixture" for key in ("target", "normalization", "registers", "oracles", "ancillas_phases", "error_success", "resources")}}
        self.flush()
        self.inventory = {"test": {"source": "QuantumBlockEncoding/Test.lean"}}

    def tearDown(self):
        self.temp.cleanup()

    def write(self, name, value):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(value, encoding="utf-8")

    def write_json(self, name, value):
        self.write(name, json.dumps(value))

    def flush(self):
        self.write_json("decoder.json", self.decoder)
        self.write_json("reviewer.json", self.reviewer)

    def test_synthetic_integrity_fixture(self):
        publication.validate_record(self.root, self.record, self.inventory)

    def test_private_helper_change_invalidates_whole_module(self):
        self.write("QuantumBlockEncoding/Test.lean", "private def helper := False\ntheorem test : True := by trivial\n")
        with self.assertRaisesRegex(ValueError, "stale"):
            publication.validate_record(self.root, self.record, self.inventory)

    def test_toolchain_change_invalidates_review(self):
        self.write("lean-toolchain", "changed-toolchain\n")
        with self.assertRaisesRegex(ValueError, "stale"):
            publication.validate_record(self.root, self.record, self.inventory)

    def test_self_review_rejected(self):
        self.reviewer["identity"] = "test-author"
        self.flush()
        with self.assertRaisesRegex(ValueError, "distinct"):
            publication.validate_record(self.root, self.record, self.inventory)

    def test_refreshed_binding_does_not_reuse_old_verdict(self):
        self.record["source_statement"] = "Changed source"
        self.record["binding_sha256"] = publication.binding_digest(self.root, self.record)
        with self.assertRaisesRegex(ValueError, "stale context"):
            publication.validate_record(self.root, self.record, self.inventory)

    def test_changed_packet_rejected(self):
        self.write("decoder-packet.txt", "source leaked or context changed\n")
        with self.assertRaisesRegex(ValueError, "packet has changed"):
            publication.validate_record(self.root, self.record, self.inventory)

    def test_uninventoried_declaration_rejected(self):
        self.inventory["extra"] = {"source": "QuantumBlockEncoding/Test.lean"}
        with self.assertRaisesRegex(ValueError, "whole changed-module"):
            publication.validate_record(self.root, self.record, self.inventory)

    def test_missing_semantic_slot_rejected(self):
        del self.reviewer["semantic_slots"]["ancillas_phases"]
        self.flush()
        with self.assertRaisesRegex(ValueError, "all quantum semantic slots"):
            publication.validate_record(self.root, self.record, self.inventory)

    def test_evidence_path_traversal_rejected(self):
        with self.assertRaisesRegex(ValueError, "non-portable"):
            publication.local_file(self.root, "../review.json")


if __name__ == "__main__":
    unittest.main()
