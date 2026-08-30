#!/usr/bin/env python3

import unittest
from pathlib import Path

from website.scripts import lean_graph


ROOT = Path(__file__).resolve().parents[2]


class LeanGraphFactorizationTests(unittest.TestCase):
    def test_structural_sharing_double_counting(self) -> None:
        # a -> b -> d
        # a -> c -> e
        # b -> e
        # Targets d,e share support {a,b}.
        modules = {
            "QuantumBlockEncoding": {
                "name": "QuantumBlockEncoding",
                "source": "QuantumBlockEncoding.lean",
                "title": "barrel",
                "imports": ["d", "e"],
            },
            "a": {"name": "a", "source": "a.lean", "title": "a", "imports": []},
            "b": {"name": "b", "source": "b.lean", "title": "b", "imports": ["a"]},
            "c": {"name": "c", "source": "c.lean", "title": "c", "imports": ["a"]},
            "d": {"name": "d", "source": "d.lean", "title": "d", "imports": ["b"]},
            "e": {"name": "e", "source": "e.lean", "title": "e", "imports": ["b", "c"]},
        }
        profile = lean_graph._module_factorization_profile(modules)
        self.assertEqual(profile["targetCount"], 2)
        self.assertEqual(profile["uniqueSupportNodes"], 5)
        self.assertEqual(profile["expandedSupportIncidences"], 7)
        self.assertEqual(profile["sharedSupportNodeCount"], 2)
        self.assertEqual(profile["maxTargetReuse"], 2)
        self.assertEqual(profile["pairwiseSharingMass"], 2)
        self.assertAlmostEqual(profile["meanPairwiseSharedSupport"], 2.0)
        self.assertAlmostEqual(profile["supportSharingFactor"], 7 / 5)

    def test_reader_page_states_evidence_boundary(self) -> None:
        payload = {
            "stats": {"moduleCount": 5, "declarationCount": 10, "importEdgeCount": 5},
            "tracks": [],
            "factorizationProfile": {
                "targetCount": 2,
                "uniqueSupportNodes": 5,
                "supportSharingFactor": 1.4,
                "maxTargetReuse": 2,
            },
        }
        rendered = lean_graph.render_lean_graph_body(payload)
        self.assertIn("Library Factorization Profile", rendered)
        self.assertIn("module import DAG", rendered)
        self.assertIn("Anti-gaming rule", rendered)
        self.assertIn("theorem-level proof-term dependencies", rendered)
        self.assertIn("P_{\\rm share}", rendered)

    def test_semantic_fidelity_is_a_system_evidence_graph_branch(self) -> None:
        module_name = "QuantumBlockEncoding.SemanticFidelityEvidence"
        source = "QuantumBlockEncoding/SemanticFidelityEvidence.lean"
        modules = lean_graph._parse_modules(ROOT)

        self.assertIn(module_name, modules)
        self.assertEqual(
            lean_graph._track_for_source(source, {}),
            "system-evidence",
        )
        self.assertTrue(
            {
                "QuantumBlockEncoding.BlockEncoding",
                "QuantumBlockEncoding.StatePreparation",
                "QuantumBlockEncoding.GHL2025",
            }.issubset(set(modules[module_name]["imports"]))
        )

        source_text = (ROOT / source).read_text(encoding="utf-8")
        self.assertIn("def semanticRoundTripRegistry", source_text)
        self.assertIn("def verifiedOperatorBlockEncodingRoundTrip", source_text)
        self.assertIn("def verifiedStatePreparationRoundTrip", source_text)

        registry_name = (
            "QuantumBlockEncoding.SemanticFidelity.semanticRoundTripRegistry"
        )
        payload = lean_graph.build_lean_graph_payload(
            ROOT,
            [
                {
                    "fullName": registry_name,
                    "source": source,
                    "line": 1,
                    "kind": "def",
                    "catalog": "AutomationAndMemory",
                    "plainEnglish": "Registry of source-to-Lean semantic round-trip audits.",
                }
            ],
            [],
            [],
        )
        nodes = {node["id"]: node for node in payload["nodes"]}
        edges = {(edge["source"], edge["target"], edge["type"]) for edge in payload["edges"]}

        module_id = f"module:{module_name}"
        declaration_id = f"declaration:{registry_name}"
        self.assertEqual(nodes[module_id]["track"], "system-evidence")
        self.assertIn(declaration_id, nodes)
        self.assertIn(
            (module_id, declaration_id, "module-declares-leaf"),
            edges,
        )
        for dependency in (
            "QuantumBlockEncoding.BlockEncoding",
            "QuantumBlockEncoding.StatePreparation",
            "QuantumBlockEncoding.GHL2025",
        ):
            self.assertIn(
                (f"module:{dependency}", module_id, "module-supports-importer"),
                edges,
            )


if __name__ == "__main__":
    unittest.main()