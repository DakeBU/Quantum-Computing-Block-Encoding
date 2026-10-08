"""Exercise real Git checkout transport without changing the trusted checker."""
from __future__ import annotations

import json
from pathlib import Path
import subprocess
import tempfile
import unittest

from website.scripts.check_research_publications import binding_digest


ROOT = Path(__file__).resolve().parents[2]


class PublicationByteTransportTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="publication-transport-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / "source"
        self.root.mkdir()
        self.record = {"module": "QuantumBlockEncoding/ThinLQ.lean",
                       "lesson_path": "docs/lessons/pilot.md", "source_id": "pilot"}
        self.files = {
            ".gitattributes": (ROOT / ".gitattributes").read_bytes(),
            "QuantumBlockEncoding/ThinLQ.lean": b"-- fixture, not a certificate\n",
            "QuantumBlockEncoding/Nested/Helper.lean": b"-- ambient nested\n",
            "ABEISTests/Nested/Helper.lean": b"-- ambient test\n",
            "lean-toolchain": b"leanprover/lean4:v4.33.0\n",
            "lake-manifest.json": b"{}\n",
            "docs/lessons/pilot.md": b"Local fixture.\n",
            # A historical independently hashed packet must stay CRLF.
            "reviews/publication/historical/evidence.json": b'{"prior": true}\r\n',
            "reviews/publication/new/evidence.json": b'{"fresh": true}\n',
            "experiments/hermite-polynomial/precision/frozen.lean":
                b"-- frozen experimental fixture, not a certificate\r\n",
            "experiments/hermite-polynomial/precision/result.json":
                b'{"historical": true}\r\n',
            "failure-memory/frozen.json": b'{"historicalFailure": true}\r\n',
            "website/research/sources.json": json.dumps({"sources": [
                {"id": "pilot", "status": "primary-text-checked"}]}).encode(),
        }
        for name, data in self.files.items():
            target = self.root / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(data)
        self.git(self.root, "init", "-q")
        self.git(self.root, "config", "core.autocrlf", "true")
        self.git(self.root, "add", ".")
        self.git(self.root, "-c", "user.name=Transport fixture",
                 "-c", "user.email=fixture@example.invalid", "commit", "-qm", "fixture")

    @staticmethod
    def git(root, *args):
        return subprocess.run(["git", *args], cwd=root, check=True,
                              capture_output=True).stdout

    def test_actual_git_checkouts_keep_bound_and_review_bytes(self):
        expected = binding_digest(self.root, self.record)
        for autocrlf in ("true", "false", "input"):
            with self.subTest(autocrlf=autocrlf):
                dest = Path(self.temp.name) / ("checkout-" + autocrlf)
                self.git(Path(self.temp.name), "clone", "-q", "--no-checkout",
                         str(self.root), str(dest))
                self.git(dest, "config", "core.autocrlf", autocrlf)
                self.git(dest, "checkout", "-q", "HEAD")
                self.assertEqual(expected, binding_digest(dest, self.record))
                for name, data in self.files.items():
                    if name.startswith(("QuantumBlockEncoding/", "ABEISTests/",
                                        "docs/lessons/", "reviews/publication/",
                                        "experiments/", "failure-memory/")) or name in (
                                            "lean-toolchain", "lake-manifest.json"):
                        self.assertEqual(data, (dest / name).read_bytes(), name)

    def test_raw_checker_still_rejects_ambient_byte_drift(self):
        expected = binding_digest(self.root, self.record)
        ambient = self.root / "ABEISTests/Nested/Helper.lean"
        ambient.write_bytes(ambient.read_bytes().replace(b"\n", b"\r\n"))
        self.assertNotEqual(expected, binding_digest(self.root, self.record))

    def test_missing_bound_file_still_fails_closed(self):
        (self.root / "lean-toolchain").unlink()
        with self.assertRaises(ValueError):
            binding_digest(self.root, self.record)

    def test_current_thin_lq_frozen_context_round_trip(self):
        """Check the actual complete bound tree, not only the small fixture."""
        candidate = ROOT / "reviews/publication/thin-lq-lf/publication-candidate.json"
        self.assertTrue(candidate.is_file(), "required ThinLQ LF pilot is missing")
        record = json.loads(candidate.read_text(encoding="utf-8"))
        expected = binding_digest(ROOT, record)
        self.assertEqual(record["binding_sha256"], expected,
                         "frozen candidate is stale; do not silently rehash reviews")
        names = {".gitattributes", record["module"], record["lesson_path"],
                 "lean-toolchain", "lake-manifest.json", "website/research/sources.json"}
        for directory in ("QuantumBlockEncoding", "ABEISTests"):
            names.update(p.relative_to(ROOT).as_posix()
                         for p in (ROOT / directory).rglob("*.lean"))
        # Preserve genuine historical and newly exported packets alike.
        names.update(p.relative_to(ROOT).as_posix() for p in
                     (ROOT / "reviews/publication/thin-lq").glob("*.json"))
        names.update(p.relative_to(ROOT).as_posix() for p in
                     (ROOT / "reviews/publication/thin-lq-lf").glob("*.json"))
        projection = Path(self.temp.name) / "current-projection"
        projection.mkdir()
        before = {name: (ROOT / name).read_bytes() for name in names}
        for name, data in before.items():
            target = projection / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(data)
        self.git(projection, "init", "-q")
        self.git(projection, "config", "core.autocrlf", "true")
        self.git(projection, "add", ".")
        self.git(projection, "-c", "user.name=Transport fixture",
                 "-c", "user.email=fixture@example.invalid", "commit", "-qm", "projection")
        for autocrlf in ("true", "false", "input"):
            with self.subTest(current_autocrlf=autocrlf):
                dest = Path(self.temp.name) / ("current-" + autocrlf)
                self.git(Path(self.temp.name), "clone", "-q", "--no-checkout",
                         str(projection), str(dest))
                self.git(dest, "config", "core.autocrlf", autocrlf)
                self.git(dest, "checkout", "-q", "HEAD")
                self.assertEqual(expected, binding_digest(dest, record))
                for name in names:
                    if name.startswith("reviews/publication/"):
                        self.assertEqual(before[name], (dest / name).read_bytes(), name)
        for name, data in before.items():
            self.assertEqual(data, (ROOT / name).read_bytes(),
                             "live frozen context changed during test: " + name)


if __name__ == "__main__":
    unittest.main()
