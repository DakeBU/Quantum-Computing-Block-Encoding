"""Pure context-generation regressions for the HARNESS Master–Worker contract."""

from __future__ import annotations

import unittest
import argparse
import tempfile
from contextlib import ExitStack
from pathlib import Path
from unittest.mock import patch

try:
    import qbe
except ModuleNotFoundError:
    from tools import qbe


class ContextPackWorkerContractTests(unittest.TestCase):
    def test_harness_gate_discovers_context_regressions(self) -> None:
        with patch.object(qbe, "run", return_value=0) as execute:
            self.assertEqual(qbe.cmd_harness_check(argparse.Namespace()), 0)
        command = execute.call_args.args[0]
        self.assertEqual(command[:3], [qbe.sys.executable, "-m", "unittest"])
        self.assertIn("tools.test_qbe_context_pack", command)
        self.assertIn("tools.test_qbe_control", command)
        self.assertIn("tools.test_enforce_mutation_scope", command)

    def render(self) -> str:
        # Prevent initialization, network calls, and durable-memory writes.
        with (
            patch.object(qbe, "task_context", return_value=("audit target", "frozen input")),
            patch.object(qbe, "local_paper_source_context", return_value="source anchor"),
            patch.object(qbe, "focused_task_contract", return_value="frozen target body"),
            patch.object(qbe, "infer_task_mode", return_value="exploratoryConstruction"),
            patch.object(qbe, "blueprint_context", return_value="root and dependencies"),
            patch.object(qbe, "recent_trial_text", return_value="typed prior obstruction"),
            patch.object(qbe, "now_stamp", return_value="test-time"),
            patch.object(qbe, "write_text", side_effect=AssertionError("unexpected write")),
            patch.object(qbe, "cmd_init", side_effect=AssertionError("unexpected init")),
        ):
            return qbe.build_context_pack("SP-AUDIT-TEST", 2)

    def test_assigns_cross_layer_objectives_not_fixed_cognitive_castes(self) -> None:
        text = self.render()
        self.assertIn("HARNESS.md", text)
        self.assertIn("Frontier Master", text)
        self.assertIn("Universal Workers own independent substantive objectives end to end", text)
        self.assertIn("execution slots, not fixed cognitive roles", text)
        self.assertIn("Parallelize independent uncertainties", text)
        self.assertNotIn("Lower 1 writes", text)
        self.assertNotIn("lower 2 compiles one", text)
        self.assertNotIn("lower 3, if present", text)

    def test_variant_complementarity_requires_evidence_and_interface(self) -> None:
        text = self.render()
        self.assertIn("same frozen target and resource tier", text)
        self.assertIn("parent ids, the changed mechanism, and a discriminating check", text)
        self.assertIn("crossover only through an explicit shared interface", text)
        self.assertIn("Branches, prose volume, and unchanged retries are not progress", text)

    def test_preserves_compact_context_and_existing_safety_gates(self) -> None:
        text = self.render()
        for expected in (
            "SP-AUDIT-TEST cycle 2", "test-time", "frozen target body",
            "root and dependencies", "typed prior obstruction", "source anchor",
            "do not add assumptions", "controller-ready scheduling, route locks",
            "population selection, and acceptance gates", "python3 tools/qbe.py check",
            "not permanent Worker specializations",
        ):
            with self.subTest(expected=expected):
                self.assertIn(expected, text)


class ExplicitLeanTargetRetrievalTests(unittest.TestCase):
    def setUp(self) -> None:
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        patcher = patch.object(qbe, "ROOT", self.root)
        patcher.start()
        self.addCleanup(patcher.stop)

    def module(self, name: str, text: str = "theorem ready : True := by trivial\n") -> Path:
        path = self.root.joinpath("QuantumBlockEncoding", *name.split(".")).with_suffix(".lean")
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
        return path

    def test_explicit_nested_path_and_qualified_root_resolve_longest_module(self) -> None:
        named = self.module("Family.Target")
        self.module("Family")
        for text in (
            "`QuantumBlockEncoding/Family/Target.lean`",
            "QuantumBlockEncoding.Family.Target.ready",
            "import QuantumBlockEncoding.Family.Target",
        ):
            with self.subTest(text=text):
                self.assertEqual(qbe.lean_index_files_for_task(text)[0], named)

    def test_named_root_survives_small_limit_and_old_keyword_filters(self) -> None:
        self.module("Root", "theorem acceptedRoot : True := by trivial\n" +
                    "\n".join(f"def noise{i} := {i}" for i in range(30)))
        self.module("ZZZ", "theorem unrelated : True := by trivial\n")
        for keyword in ("", "cubic state-preparation", "Robin", "optimal-control"):
            with self.subTest(keyword=keyword):
                rows = qbe.lean_declaration_index(keyword + " QuantumBlockEncoding.Root.acceptedRoot", limit=1)
                self.assertEqual([row["name"] for row in rows], ["acceptedRoot"])

    def test_direct_imports_are_deduplicated_one_level_only(self) -> None:
        named = self.module("Root", "import QuantumBlockEncoding.Nested.Child QuantumBlockEncoding.Nested.Child\n")
        child = self.module("Nested.Child", "import QuantumBlockEncoding.Root QuantumBlockEncoding.Deep.Grandchild\n")
        self.module("Deep.Grandchild")
        anchors = qbe._explicit_lean_task_anchors("QuantumBlockEncoding.Root")
        self.assertEqual(qbe._task_anchor_files(anchors), [named, child])

    def test_direct_import_budget_and_external_library_exclusion(self) -> None:
        for i in range(20):
            self.module(f"Deps.D{i}")
        named = self.module("Root", "import Mathlib\n" + "\n".join(
            f"import QuantumBlockEncoding.Deps.D{i}" for i in range(20)))
        files = qbe._task_anchor_files([(named, "")])
        self.assertEqual(len(files), 17)
        self.assertEqual(files[0], named)
        self.assertTrue(all(path.is_relative_to(self.root / "QuantumBlockEncoding") for path in files))

    def test_invalid_absolute_and_escape_anchors_are_not_resolved(self) -> None:
        self.module("Root")
        for token in (
            "QuantumBlockEncoding/../Root.lean", "QuantumBlockEncoding/Root/../../Other.lean",
            "QuantumBlockEncoding.Root.bad-name", "QuantumBlockEncoding.3bad.ready",
            "/outside/QuantumBlockEncoding/Root.lean", "C:\\outside\\QuantumBlockEncoding\\Root.lean",
            "QuantumBlockEncoding/Root.lean/../../outside",
        ):
            with self.subTest(token=token):
                self.assertEqual(qbe._explicit_lean_task_anchors(token), [])

    def test_symbolic_link_module_or_parent_is_rejected_without_creating_links(self) -> None:
        path = self.module("Nested.Root")
        original = Path.is_symlink
        for link in (path, path.parent):
            with self.subTest(link=link.name), patch.object(
                Path, "is_symlink", lambda candidate: candidate == link or original(candidate)
            ):
                self.assertEqual(qbe._explicit_lean_task_anchors("QuantumBlockEncoding.Nested.Root.ready"), [])

    def test_resolved_escape_is_rejected(self) -> None:
        path = self.module("Root")
        original = Path.resolve
        def redirected(candidate: Path, *args, **kwargs):
            if candidate == path:
                return self.root.parent / "outside.lean"
            return original(candidate, *args, **kwargs)
        with patch.object(Path, "resolve", redirected):
            self.assertEqual(qbe._explicit_lean_task_anchors("QuantumBlockEncoding.Root.ready"), [])

    def test_valid_anchor_does_not_reintroduce_symlink_through_fallback(self) -> None:
        named = self.module("Root")
        linked = self.module("Linked")
        original = Path.is_symlink
        with patch.object(Path, "is_symlink", lambda candidate: candidate == linked or original(candidate)):
            files = qbe.lean_index_files_for_task("QuantumBlockEncoding.Root.ready")
        self.assertIn(named, files)
        self.assertNotIn(linked, files)

    def test_forbidden_evaluation_modes_do_not_expand_memory_scope(self) -> None:
        self.module("Secret")
        for mode in ("task-only", "isolated-abeis"):
            task = f"Evaluation mode: `{mode}`\nForbidden: prior memory\nQuantumBlockEncoding.Secret.ready"
            self.assertEqual(qbe.lean_index_files_for_task(task), qbe._fallback_lean_index_files_for_task(task))
            self.assertEqual(qbe._explicit_lean_task_anchors(task), [])
            self.assertNotIn("Secret.lean", [path.name for path in qbe.lean_index_files_for_task(task)])

    def test_no_explicit_anchor_preserves_legacy_file_and_row_order(self) -> None:
        self.module("AAA", "def first := 1\ndef second := 2\n")
        self.module("ZZZ", "def third := 3\ndef fourth := 4\n")
        text = "a new generic scientific task without explicit module names"
        self.assertEqual(qbe.lean_index_files_for_task(text), qbe._fallback_lean_index_files_for_task(text))
        self.assertEqual([row["name"] for row in qbe.lean_declaration_index(text, 2)], ["third", "fourth"])


class RolePromptWorkerContractTests(unittest.TestCase):
    def render(self, role: str, mode: str, index: int) -> str:
        with ExitStack() as stack:
            for name in (
                "recent_trial_text", "local_paper_source_context", "verifier_feedback_contract",
                "blueprint_context", "mathlib_retrieval_context", "atlas_retrieval_context",
                "failure_trace_and_judge_context",
            ):
                stack.enter_context(patch.object(qbe, name, return_value="test context"))
            stack.enter_context(patch.object(qbe, "blueprint_status_state", return_value={}))
            stack.enter_context(patch.object(qbe, "write_text", side_effect=AssertionError("unexpected write")))
            stack.enter_context(patch.object(qbe, "cmd_init", side_effect=AssertionError("unexpected init")))
            return qbe.role_prompt(
                role, "SP-WORKER-TEST", "frozen target",
                "Mode: `exploratoryConstruction`\nEvaluation mode: `full-abeis`\n",
                1, qbe.ROOT / "runs" / "test-worker-contract", mode, index,
            )

    def test_default_slots_are_end_to_end_workers_in_full_and_focused_modes(self):
        for mode in ("full", "focused"):
            for slot in range(1, 5):
                with self.subTest(mode=mode, slot=slot):
                    text = self.render("lower", mode, slot)
                    self.assertIn(f"Universal Worker, execution slot `{slot}`", text)
                    self.assertIn("one assigned substantive objective end to end", text)
                    self.assertIn("Do not claim one method is faster without a matched comparison", text)
                    self.assertIn("acceptance anchors, or benchmark split", text)
                    self.assertNotIn("Avoid Lean edits unless", text)
                    self.assertNotIn("natural-language proof\nagent owns proof design", text)

    def test_planning_prompts_do_not_reintroduce_slot_castes(self):
        for role in ("upper", "middle", "reviewer"):
            for mode in ("full", "focused"):
                with self.subTest(role=role, mode=mode):
                    text = self.render(role, mode, 0)
                    for retired in ("lower 1 receives", "lower 2 must then", "active leaf for lower 2",
                                    "lower-1 natural-language proof task", "three complementary lower roles"):
                        self.assertNotIn(retired, text)
                    self.assertIn("source", text.lower())

    def test_explicit_game_experiment_and_post_lean_export_profiles_are_retained(self):
        for slot, expected in (
            (-30, "post-Lean executable exporter"),
            (101, "Natural-Language Hierarchical Team worker `1`"),
            (201, "Lean Hierarchical Team worker `1`"),
        ):
            with self.subTest(slot=slot):
                self.assertIn("Lower profile for this prompt: " + expected,
                              self.render("lower", "focused", slot))


if __name__ == "__main__":
    unittest.main()
