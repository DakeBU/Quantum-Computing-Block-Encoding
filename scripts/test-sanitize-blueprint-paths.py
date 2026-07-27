#!/usr/bin/env python3
"""Regression tests for portable Blueprint publication paths."""

from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("sanitize-blueprint-paths.py")
SPEC = importlib.util.spec_from_file_location("sanitize_blueprint_paths", SCRIPT)
assert SPEC and SPEC.loader
SANITIZER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(SANITIZER)


class SanitizerTests(unittest.TestCase):
    def test_xref_without_source_paths_is_already_safe(self) -> None:
        value, changed, seen = SANITIZER._normalize_source_paths(
            {"declarations": []}, Path.cwd().resolve()
        )
        self.assertEqual(value, {"declarations": []})
        self.assertEqual(changed, 0)
        self.assertEqual(seen, 0)

    def test_repository_path_becomes_portable(self) -> None:
        root = Path.cwd().resolve()
        source = root / "QuantumBlockEncoding" / "Core.lean"
        value, changed, seen = SANITIZER._normalize_source_paths(
            {"sourcePath": str(source)}, root
        )
        self.assertEqual(value["sourcePath"], "QuantumBlockEncoding/Core.lean")
        self.assertEqual(changed, 1)
        self.assertEqual(seen, 1)

    def test_outside_absolute_path_is_rejected(self) -> None:
        root = Path.cwd().resolve()
        with self.assertRaises(ValueError):
            SANITIZER._normalize_source_paths(
                {"sourcePath": str(root.parent / "outside.lean")}, root
            )

    def test_embedded_json_paths_are_scrubbed(self) -> None:
        root = Path.cwd().resolve()
        value, changed = SANITIZER._scrub_json_strings(
            {
                "sourceHref": str(root / "QuantumBlockEncoding" / "Core.lean"),
                "html": (
                    '<a href="'
                    + str(root.parent / "external" / "Core.lean")
                    + '">source</a>'
                ),
            },
            root,
        )
        self.assertGreaterEqual(changed, 2)
        self.assertEqual(
            value["sourceHref"], "QuantumBlockEncoding/Core.lean"
        )
        self.assertIn("external-source", value["html"])
        self.assertNotIn(str(root), str(value))

    def test_mathematical_colon_backslash_is_preserved(self) -> None:
        text = r"the set \{x:\mathcal V(x)=1\}"
        scrubbed, changed = SANITIZER._scrub_local_paths_from_text(
            text, Path.cwd().resolve()
        )
        self.assertEqual(scrubbed, text)
        self.assertEqual(changed, 0)

    def test_publication_scan_rejects_derived_repository_path(self) -> None:
        root = Path.cwd().resolve()
        with tempfile.TemporaryDirectory(dir=root) as temporary:
            output = Path(temporary)
            (output / "safe.html").write_text(
                '<a href="https://example.org/library/">safe URL</a>',
                encoding="utf-8",
            )
            self.assertEqual(
                SANITIZER._assert_no_local_paths(output, root), 1
            )
            (output / "unsafe.json").write_text(
                '{"path": "' + str(root).replace("\\", "/") + '/source.lean"}',
                encoding="utf-8",
            )
            with self.assertRaises(ValueError):
                SANITIZER._assert_no_local_paths(output, root)


if __name__ == "__main__":
    unittest.main()
