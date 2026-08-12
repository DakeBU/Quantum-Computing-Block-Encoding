from __future__ import annotations

import json
import subprocess
import tempfile
import unittest
from pathlib import Path

from tools.enforce_mutation_scope import allowed, snapshot, status_paths


class MutationAllowlistTests(unittest.TestCase):
    def test_exact_file_does_not_authorize_similar_name(self) -> None:
        self.assertTrue(allowed("MANIFEST.md", ("MANIFEST.md",)))
        self.assertFalse(allowed("MANIFEST.md.bak", ("MANIFEST.md",)))

    def test_directory_and_explicit_prefix_are_supported(self) -> None:
        self.assertTrue(allowed("runs/cycle/summary.md", ("runs/",)))
        self.assertTrue(
            allowed(
                "reviews/QBE-ROBIN-BE-COLD-001-cycle03-review.md",
                ("reviews/QBE-ROBIN-BE-COLD-001-*",),
            )
        )
        self.assertFalse(allowed("website/runs.html", ("runs/",)))

    def test_porcelain_parser_handles_untracked_and_modified_files(self) -> None:
        parsed = status_paths(b" M tracked.txt\0?? new.txt\0")
        self.assertEqual(parsed, {"tracked.txt": " M", "new.txt": "??"})


class MutationRollbackTests(unittest.TestCase):
    def test_cli_reverts_only_new_disallowed_mutations(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            subprocess.run(["git", "init", "-q"], cwd=root, check=True)
            (root / "tracked.txt").write_text("baseline\n", encoding="utf-8")
            subprocess.run(["git", "add", "tracked.txt"], cwd=root, check=True)
            subprocess.run(
                [
                    "git",
                    "-c",
                    "user.name=scope-test",
                    "-c",
                    "user.email=scope-test@invalid.local",
                    "commit",
                    "-qm",
                    "baseline",
                ],
                cwd=root,
                check=True,
            )
            before = root / "before.json"
            before.write_text(
                json.dumps({"entries": snapshot(root)}),
                encoding="utf-8",
            )
            (root / "tracked.txt").write_text("agent edit\n", encoding="utf-8")
            (root / "allowed.txt").write_text("keep\n", encoding="utf-8")
            (root / "forbidden.txt").write_text("remove\n", encoding="utf-8")
            script = Path(__file__).with_name("enforce_mutation_scope.py")
            completed = subprocess.run(
                [
                    "python3",
                    str(script),
                    "check",
                    "--root",
                    str(root),
                    "--before",
                    str(before),
                    "--allow",
                    "allowed.txt",
                    "--allow",
                    "before.json",
                ],
                check=False,
            )
            self.assertEqual(completed.returncode, 79)
            self.assertEqual((root / "tracked.txt").read_text(), "baseline\n")
            self.assertTrue((root / "allowed.txt").is_file())
            self.assertFalse((root / "forbidden.txt").exists())

    def test_cli_restores_preexisting_dirty_content_not_head(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            subprocess.run(["git", "init", "-q"], cwd=root, check=True)
            path = root / "human.txt"
            path.write_text("head\n", encoding="utf-8")
            subprocess.run(["git", "add", "human.txt"], cwd=root, check=True)
            subprocess.run(
                [
                    "git",
                    "-c",
                    "user.name=scope-test",
                    "-c",
                    "user.email=scope-test@invalid.local",
                    "commit",
                    "-qm",
                    "baseline",
                ],
                cwd=root,
                check=True,
            )
            path.write_text("human edit\n", encoding="utf-8")
            before = root / "before.json"
            before.write_text(
                json.dumps({"entries": snapshot(root)}), encoding="utf-8"
            )
            path.write_text("agent overwrite\n", encoding="utf-8")
            script = Path(__file__).with_name("enforce_mutation_scope.py")
            completed = subprocess.run(
                [
                    "python3",
                    str(script),
                    "check",
                    "--root",
                    str(root),
                    "--before",
                    str(before),
                    "--allow",
                    "before.json",
                ],
                check=False,
            )
            self.assertEqual(completed.returncode, 79)
            self.assertEqual(path.read_text(), "human edit\n")

    def test_atomic_cli_reverts_allowed_edits_with_a_scope_violation(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            subprocess.run(["git", "init", "-q"], cwd=root, check=True)
            for name in ("allowed.txt", "tracked.txt"):
                (root / name).write_text("baseline\n", encoding="utf-8")
            subprocess.run(["git", "add", "."], cwd=root, check=True)
            subprocess.run(
                [
                    "git",
                    "-c",
                    "user.name=scope-test",
                    "-c",
                    "user.email=scope-test@invalid.local",
                    "commit",
                    "-qm",
                    "baseline",
                ],
                cwd=root,
                check=True,
            )
            before = root / "before.json"
            before.write_text(json.dumps({"entries": snapshot(root)}), encoding="utf-8")
            (root / "allowed.txt").write_text("agent edit\n", encoding="utf-8")
            (root / "forbidden.txt").write_text("remove\n", encoding="utf-8")
            script = Path(__file__).with_name("enforce_mutation_scope.py")
            completed = subprocess.run(
                [
                    "python3",
                    str(script),
                    "check",
                    "--root",
                    str(root),
                    "--before",
                    str(before),
                    "--allow",
                    "allowed.txt",
                    "--atomic",
                ],
                check=False,
            )
            self.assertEqual(completed.returncode, 79)
            self.assertEqual((root / "allowed.txt").read_text(), "baseline\n")
            self.assertFalse((root / "forbidden.txt").exists())


if __name__ == "__main__":
    unittest.main()
