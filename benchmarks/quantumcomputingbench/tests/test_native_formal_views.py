"""Native views require separate exact-content semantic and execution evidence."""
from copy import deepcopy
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

B = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(B / "src"))
import qcb_formal_views as formal
from qcb_curriculum import load_catalog
from qcb_core import read_json


class NativeFormalViewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.catalog, _, _ = load_catalog()
        cls.cores = cls.catalog["cores"]

    def changed_report(self, name, update):
        original = read_json
        value = deepcopy(original(formal.EVIDENCE / (name + ".json")))
        update(value)
        return patch.object(formal, "read_json", side_effect=lambda p: value if Path(p) == formal.EVIDENCE / (name + ".json") else original(p))

    def test_native_views_do_not_create_cores_or_claim_prose_certification(self):
        views, status = formal.admission(self.cores)
        self.assertEqual(status["status"], "admitted")
        self.assertEqual(set(views), {"qcb-core-sp-005", "qcb-core-sp-009", "qcb-core-la-102"})
        for view in views.values():
            self.assertFalse(view["isolated"])
            self.assertFalse(view["nl_explanation_certified_by_kernel"])
            self.assertEqual(view["task_kind"], "library_lemma_application")
            self.assertEqual(view["execution_class"], "trusted_local_reference")

    def test_decoder_input_is_bounded_not_the_original_qa_or_proof(self):
        packet = formal.decoder_packet(formal.candidates(self.cores))
        self.assertEqual(len(packet["views"]), 3)
        for view in packet["views"]:
            self.assertEqual(set(view), {"anonymous_id", "formal_context", "ambient_definitions"})
            self.assertEqual(set(view["formal_context"]), {"imports", "target"})
            self.assertTrue(all(isinstance(d, str) for d in view["ambient_definitions"]))

    def test_self_reviewer_or_stale_comparison_is_rejected(self):
        for change in (lambda d: d.update(reviewer="/root"), lambda d: d.update(decoder_digest="stale")):
            with self.changed_report("comparison", change), self.assertRaisesRegex(ValueError, "distinct reviewer"):
                formal.admission(self.cores)

    def test_rejected_semantic_view_is_not_admitted_by_kernel_receipt(self):
        with self.changed_report("comparison", lambda d: d["views"][0].update(verdict="reject")):
            views, status = formal.admission(self.cores)
            self.assertNotIn("qcb-core-sp-005", views)
            self.assertEqual(status["status"], "partially_admitted")

    def test_stale_pipeline_and_missing_negative_controls_fail_closed(self):
        for change in (lambda d: d.update(pipeline_hashes={}), lambda d: d.update(sorry_control_rejected=False),
                       lambda d: d.update(negative_control={"reason": "not_a_real_control"})):
            with self.changed_report("reference-checks", change), self.assertRaises(ValueError):
                formal.admission(self.cores)

    def test_wrong_fixed_reference_or_axiom_is_not_admitted(self):
        for change in (lambda d: d["views"][0].update(source_sha256="other proof"),
                       lambda d: d["views"][0].update(axioms=["sorryAx"]),
                       lambda d: d["views"][0].update(sorry=True)):
            with self.changed_report("reference-checks", change), self.assertRaisesRegex(ValueError, "receipt"):
                formal.admission(self.cores)


if __name__ == "__main__":
    unittest.main()
