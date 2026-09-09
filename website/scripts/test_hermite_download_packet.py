"""Exercise the real downloadable packet, including isolated finite replay."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from website.scripts import publish_extensions as publisher
from website.scripts.check_site import check_hermite_publication


PACKET = Path("executable-exports/SP-HERMITE-001")
RESTORED = ("circuit.qasm2", "circuit.qasm3", "mass-tree.json", "endpoint-jets.json")


class HermiteDownloadPacketTests(unittest.TestCase):
    def setUp(self) -> None:
        payload = json.loads(publisher.HERMITE_PATH.read_text(encoding="utf-8"))
        self.case = next(case for case in payload["cases"]
                         if case["slug"] == "hermite-smooth-state-preparation")
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.site = Path(self.temp.name)
        self.download_root = self.site / "downloads" / self.case["slug"]
        self.packet = self.download_root / PACKET

    def publish(self) -> str:
        rendered = publisher.publish_case_assets(self.site, self.case)
        page = self.site / "example-cases" / self.case["slug"] / "index.html"
        page.parent.mkdir(parents=True)
        page.write_text("<!doctype html><html><body>" + rendered + "</body></html>",
                        encoding="utf-8")
        return rendered

    def test_registry_contains_every_accepted_artifact_and_both_replay_sources(self) -> None:
        registered = [asset["path"] for asset in self.case["supplementaryAssets"]]
        self.assertEqual(len(registered), len(set(registered)))
        acceptance = json.loads((publisher.ROOT / PACKET / "acceptance.json").read_text(encoding="utf-8"))
        required = set(acceptance["artifact_sha256"]) | {
            "acceptance.json", "qiskit/export.py", "qiskit/replay.py",
        }
        self.assertTrue({(PACKET / name).as_posix() for name in required} <= set(registered))

    def test_real_publisher_preserves_all_asset_bytes_and_display_links(self) -> None:
        rendered = self.publish()
        for asset in self.case["supplementaryAssets"]:
            relative = Path(asset["path"])
            with self.subTest(asset=relative.as_posix()):
                self.assertEqual((self.download_root / relative).read_bytes(),
                                 (publisher.ROOT / relative).read_bytes())
                self.assertIn("../../downloads/" + self.case["slug"] + "/" + relative.as_posix(),
                              rendered)
        self.assertEqual(check_hermite_publication(self.site, publisher.ROOT), [])

    def test_final_gate_rejects_each_missing_restored_file(self) -> None:
        self.publish()
        for name in RESTORED:
            with self.subTest(name=name):
                target = self.packet / name
                contents = target.read_bytes()
                target.unlink()
                errors = check_hermite_publication(self.site, publisher.ROOT)
                self.assertEqual(len(errors), 1)
                self.assertIn(name, errors[0])
                target.write_bytes(contents)

    def test_download_only_replay_runs_with_no_repository_artifact_fallback(self) -> None:
        self.publish()
        before = {p.relative_to(self.packet).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
                  for p in self.packet.rglob("*") if p.is_file()}
        script = (Path("downloads") / self.case["slug"] / PACKET / "qiskit/replay.py")
        # Isolated Python ignores PYTHONPATH; cwd and __file__ both refer to the
        # temporary website, not to the repository's original exporter packet.
        completed = subprocess.run(
            [sys.executable, "-I", "-B", str(script)], cwd=self.site,
            check=True, capture_output=True, text=True, timeout=120,
        )
        result = json.loads(completed.stdout)
        self.assertIs(result["passed"], True)
        self.assertEqual(result["evidence_class"], "independent-finite-replay")
        self.assertIs(result["lean_certificate_claimed"], False)
        self.assertTrue(set(RESTORED) <= set(result["checked_artifacts"]))
        self.assertLessEqual(max(result["qasm_max_amplitude_errors"].values()), 1e-10)
        after = {p.relative_to(self.packet).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
                 for p in self.packet.rglob("*") if p.is_file()}
        self.assertEqual(after, before, "Independent replay must not mutate accepted artifacts")


if __name__ == "__main__":
    unittest.main()
