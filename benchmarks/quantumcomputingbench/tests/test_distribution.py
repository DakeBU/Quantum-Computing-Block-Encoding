"""Public preview packaging and cohort boundaries, not model performance."""
import hashlib
import io
import json
from pathlib import Path
import sys
import unittest
import zipfile

B = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(B / "scripts"))
import release


class DistributionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot, cls.items, cls.native, cls.legacy = release.checked()

    def test_exact_cohorts_and_no_global_count_claim(self):
        manifest = release.release_manifest(self.snapshot, self.items, self.native, self.legacy, "fixture")
        self.assertEqual(manifest["native"]["admitted_core_ids"], 213)
        self.assertEqual(manifest["native"]["non_gold_records"], 25)
        self.assertEqual(manifest["legacy"]["diagnostic_records"], 26)
        self.assertIsNone(manifest["global_distinct_core_count"])
        self.assertFalse(manifest["cross_cohort_semantic_dedup_complete"])
        self.assertFalse(manifest["native"]["new_local_formal_verification_of_native_answers"])

    def test_quarantined_answers_are_audit_only(self):
        admission = release.read_json(B / "manifests/integration-20261022/admission.json")
        excluded = {r["key"] for r in admission["quarantined"]}
        self.assertFalse(excluded & {i["key"] for i in self.native})
        payload = release.payloads(self.snapshot, self.items, self.native, self.legacy, "fixture")
        audit = json.loads(payload["audit/native-non-gold.json"])
        self.assertTrue(excluded <= {i["key"] for i in audit})

    def test_native_prompt_and_answer_exports_have_same_ids(self):
        payload = release.payloads(self.snapshot, self.items, self.native, self.legacy, "fixture")
        for split in ["train", "dev", "test_public"]:
            data = json.loads(payload[f"data/native/{split}.json"])
            prompts = json.loads(payload[f"prompts/native/{split}.json"])
            self.assertEqual([i["id"] for i in data], [i["id"] for i in prompts])
            self.assertFalse(any("reference_answer" in p or "reviews" in p for p in prompts))

    def test_zip_deterministic_and_checksums_complete(self):
        payload = release.payloads(self.snapshot, self.items, self.native, self.legacy, "fixture")
        first = release.zip_bytes(payload)
        self.assertEqual(first, release.zip_bytes(payload))
        with zipfile.ZipFile(io.BytesIO(first)) as archive:
            entries = {line.split("  ", 1)[1]: line.split("  ", 1)[0]
                       for line in archive.read("CHECKSUMS.sha256").decode().splitlines()}
            self.assertEqual(set(entries), set(archive.namelist()) - {"CHECKSUMS.sha256"})
            for name, expected in entries.items():
                self.assertEqual(hashlib.sha256(archive.read(name)).hexdigest(), expected)
            self.assertFalse(any(name.endswith((".pdf", ".patch")) or ".." in Path(name).parts for name in entries))


if __name__ == "__main__":
    unittest.main()
