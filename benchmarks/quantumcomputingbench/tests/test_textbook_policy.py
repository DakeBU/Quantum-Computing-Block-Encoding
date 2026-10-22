"""Historical preview is reproducible audit data, not repaired current gold."""
from contextlib import redirect_stderr
import io
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

B = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(B / "src"))
sys.path.insert(0, str(B / "scripts"))
import release
from qcb_core import digest
from qcb_nl_release_policy import check_current_gold
from qcb_textbook_policy import apply_current_reader_policy, frozen_native_is_current, CONTRACT_FIELDS, public_reader_item


class TextbookPolicyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        _, _, cls.historical, _ = release.checked()

    def test_rejected_predecessor_is_not_current_gold(self):
        original = next(i for i in self.historical if i["core_id"] == "qcb-core-sp-002")
        with self.assertRaisesRegex(ValueError, "withdrawn"):
            check_current_gold([original])
        self.assertFalse(frozen_native_is_current(self.historical))

    def test_successor_cannot_increase_core_count_or_change_contract(self):
        current, decisions = apply_current_reader_policy(self.historical)
        self.assertEqual(len(current), len({i["core_id"] for i in current}))
        self.assertLessEqual(len(current), len(self.historical))
        old = {i["core_id"]: i for i in self.historical}
        for item in current:
            self.assertEqual({k: item[k] for k in CONTRACT_FIELDS}, {k: old[item["core_id"]][k] for k in CONTRACT_FIELDS})
            if item.get("textbook_successor"):
                self.assertEqual(item["textbook_successor"]["predecessor_item_digest"], digest(old[item["core_id"]]))
                self.assertNotIn(old[item["core_id"]]["reviews"][0], item["reviews"])

    def test_frozen_tag_cannot_be_repackaged_as_current(self):
        errors = io.StringIO()
        with patch.object(sys, "argv", ["release.py", "build"]), redirect_stderr(errors):
            self.assertEqual(release.main(), 1)
        self.assertIn("historical preview contains a withdrawn predecessor", errors.getvalue())

    def test_public_reader_download_is_not_a_raw_review_or_control_log(self):
        current, _ = apply_current_reader_policy(self.historical)
        for item in current:
            view = public_reader_item(item)
            self.assertEqual(view["reference_answer"], item["reference_answer"])
            self.assertEqual(view["source_item_digest"], digest(item))
            self.assertNotIn("reviews", view)
            self.assertNotIn("inherited_predecessor_reviews", view)
            self.assertNotIn("lineage", view)
