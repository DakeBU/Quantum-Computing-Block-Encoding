from pathlib import Path
import tempfile
import unittest

from website.scripts.proof_inputs import CONFIG, SOURCE_DIRS, lean_module_targets, proof_input_digest


class ProofInputIdentityTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        for name in CONFIG:
            (self.root / name).write_text("input\n", encoding="utf-8")
        for name in SOURCE_DIRS:
            (self.root / name).mkdir()
        self.leaf = self.root / "QuantumBlockEncoding" / "Leaf.lean"
        self.leaf.write_text("theorem sample : True := True.intro\n", encoding="utf-8")

    def test_deleted_or_changed_leaf_invalidates_old_evidence(self):
        original = proof_input_digest(self.root)
        self.leaf.write_text("theorem different : True := True.intro\n", encoding="utf-8")
        self.assertNotEqual(original, proof_input_digest(self.root))
        self.leaf.unlink()
        self.assertNotEqual(original, proof_input_digest(self.root))

    def test_missing_root_configuration_is_an_error(self):
        (self.root / "Tests.lean").unlink()
        with self.assertRaises(RuntimeError):
            proof_input_digest(self.root)

    def test_checkout_line_endings_do_not_change_identity(self):
        original = proof_input_digest(self.root)
        source = self.leaf.read_bytes().replace(b"\r\n", b"\n")
        self.leaf.write_bytes(source.replace(b"\n", b"\r\n"))
        self.assertEqual(original, proof_input_digest(self.root))

    def test_unbuilt_new_leaf_changes_identity(self):
        original = proof_input_digest(self.root)
        (self.root / "ABEISTests" / "New.lean").write_text("import Mathlib\n", encoding="utf-8")
        self.assertNotEqual(original, proof_input_digest(self.root))

    def test_unimported_new_leaf_is_an_explicit_build_target(self):
        (self.root / "ABEISTests" / "Unimported.lean").write_text("invalid Lean", encoding="utf-8")
        self.assertEqual(lean_module_targets(self.root),
                         ["ABEISTests.Unimported", "QuantumBlockEncoding.Leaf"])


if __name__ == "__main__":
    unittest.main()
