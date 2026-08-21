#!/usr/bin/env python3

import unittest

from website.scripts import lean_graph


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


if __name__ == "__main__":
    unittest.main()
