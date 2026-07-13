#!/usr/bin/env python3

from __future__ import annotations

import unittest

try:
    from qbe_control import (
        decide_cycle,
        infer_epsilon_ladder,
        latest_frontier_rows,
        latest_obligation_rows,
        prompt_budget_violation,
        reduce_latest_feedback,
    )
except ModuleNotFoundError:
    from tools.qbe_control import (
        decide_cycle,
        infer_epsilon_ladder,
        latest_frontier_rows,
        latest_obligation_rows,
        prompt_budget_violation,
        reduce_latest_feedback,
    )

try:
    from qbe import changed_snapshot_delta
except ModuleNotFoundError:
    from tools.qbe import changed_snapshot_delta


class CurrentStateParsingTests(unittest.TestCase):
    def test_latest_obligation_table_wins_and_closed_rows_disappear(self) -> None:
        text = """
| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| OLD | oldLemma | internal | active next |

Current obligation state:

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| OLD | oldLemma | internal | formalized |
| NEW | newLemma | internal | active next |
"""
        rows = latest_obligation_rows(text)
        self.assertEqual(len(rows), 1)
        self.assertIn("NEW", rows[0])
        self.assertNotIn("OLD", rows[0])

    def test_active_obligation_section_beats_stale_appended_history(self) -> None:
        text = """
## Current Obligation State [ACTIVE]: current run

| Node | Interface | Lean declaration | Dependency class | Status |
|---|---|---|---|---|
| NEW | approximate finite error definition | `newLemma` | internal | approximate active next Lean leaf |

## Current Obligation State: stale appended history

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| OLD | oldLemma | external_contract_gap | blocked external |
"""
        rows = latest_obligation_rows(text)
        self.assertEqual(len(rows), 1)
        self.assertIn("NEW", rows[0])
        self.assertIn("newLemma", rows[0])
        self.assertNotIn("OLD", rows[0])

    def test_latest_current_frontier_wins_without_task_specific_names(self) -> None:
        text = """
## Current Proof-DAG frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Check | Note | Status |
|---|---|---|---|---|---|---|---|
| old_leaf | old target | none | lower2 | oldLemma | build | - | retired |

## Current Proof-DAG frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Check | Note | Status |
|---|---|---|---|---|---|---|---|
| new_leaf | new target | helper | lower2 | newLemma | build | - | active next |
"""
        rows = latest_frontier_rows(text)
        self.assertEqual(len(rows), 1)
        self.assertIn("new_leaf", rows[0])
        self.assertNotIn("old_leaf", rows[0])

    def test_latest_feedback_wins(self) -> None:
        rows = reduce_latest_feedback(
            [
                {"leaf": "L1", "closed_theorem_ok": True},
                {"leaf": "L1", "closed_theorem_ok": False},
                {"leaf": "L2", "closed_theorem_ok": False},
            ]
        )
        keyed = {row["leaf"]: row for row in rows}
        self.assertTrue(keyed["L1"]["closed_theorem_ok"])
        self.assertFalse(keyed["L2"]["closed_theorem_ok"])

    def test_later_middle_status_does_not_erase_upper_policy(self) -> None:
        rows = reduce_latest_feedback(
            [
                {
                    "trial_id": "middle-new",
                    "leaf": "L1",
                    "role": "middle",
                    "closed_theorem_ok": False,
                },
                {
                    "trial_id": "upper-policy",
                    "leaf": "L1",
                    "role": "upper",
                    "tolerance_decision": "open_approximate",
                    "epsilon_next": "1e-10",
                },
            ]
        )
        self.assertEqual(len(rows), 2)
        self.assertTrue(any(row.get("tolerance_decision") == "open_approximate" for row in rows))


class CycleDecisionTests(unittest.TestCase):
    def test_ready_leaf_schedules_ordered_proof_then_lean_work(self) -> None:
        row = "L1: local bridge; status: active next; Lean: localBridge"
        first = decide_cycle(
            task_id="T",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
        )
        self.assertEqual(first.mode, "execute")
        self.assertEqual(first.prompt_plan, ("lower1", "lower2", "reviewer"))
        second = decide_cycle(
            task_id="T",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
        )
        self.assertEqual(second.prompt_plan, ("lower2", "reviewer"))

    def test_external_gap_never_schedules_lower_and_then_stops(self) -> None:
        row = "EXT: imported theorem; class: external_contract_gap; status: blocked external; Lean: planned external theorem"
        first = decide_cycle(
            task_id="T",
            cycle=1,
            frontier_rows=[],
            obligation_rows=[row],
            feedback=[],
            evidence_digest="lean-a",
        )
        self.assertEqual(first.mode, "dependency_decision")
        self.assertNotIn("lower2", first.prompt_plan)
        second = decide_cycle(
            task_id="T",
            cycle=2,
            frontier_rows=[],
            obligation_rows=[row],
            feedback=[],
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
        )
        self.assertTrue(second.stop)
        self.assertEqual(second.status, "blocked")

    def test_repeated_executable_leaf_stops_at_budget(self) -> None:
        row = "L1: local bridge; status: active next; Lean: localBridge"
        first = decide_cycle(
            task_id="T",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            max_no_progress_cycles=2,
        )
        second = decide_cycle(
            task_id="T",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
            max_no_progress_cycles=2,
        )
        third = decide_cycle(
            task_id="T",
            cycle=3,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            previous_state={**second.to_dict(), "execution_started": True},
            max_no_progress_cycles=2,
        )
        self.assertTrue(third.stop)
        self.assertEqual(third.unchanged_cycles, 2)

    def test_capacity_increase_requires_current_signed_feedback(self) -> None:
        row = "L1: local bridge; status: active next; Lean: localBridge"
        first = decide_cycle(
            task_id="T",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
        )
        authorized = decide_cycle(
            task_id="T",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[
                {
                    "leaf": "L1",
                    "role": "upper",
                    "leaf_signature": first.leaf_signature,
                    "evidence_digest": first.evidence_digest,
                    "capacity_decision": "increase_lower",
                }
            ],
            evidence_digest="lean-a",
        )
        self.assertEqual(authorized.capacity_authorizations, ("increase_lower",))
        unauthorized = decide_cycle(
            task_id="T",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[
                {
                    "leaf": "L1",
                    "role": "lower",
                    "leaf_signature": first.leaf_signature,
                    "evidence_digest": first.evidence_digest,
                    "capacity_decision": "increase_lower",
                }
            ],
            evidence_digest="lean-a",
        )
        self.assertEqual(unauthorized.capacity_authorizations, ())

    def test_capacity_levels_advance_once_per_signed_decision(self) -> None:
        row = "L1: local bridge; status: active next; Lean: localBridge"
        first = decide_cycle(
            task_id="T",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
        )
        feedback = [
            {
                "trial_id": "upper-step-1",
                "leaf": "L1",
                "role": "upper",
                "leaf_signature": first.leaf_signature,
                "evidence_digest": first.evidence_digest,
                "capacity_decision": "increase_upper increase_lower",
            }
        ]
        advanced = decide_cycle(
            task_id="T",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
        )
        self.assertEqual(advanced.upper_capacity_level, 1)
        self.assertEqual(advanced.lower_capacity_level, 1)
        replayed = decide_cycle(
            task_id="T",
            cycle=3,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
            previous_state={**advanced.to_dict(), "execution_started": True},
        )
        self.assertEqual(replayed.upper_capacity_level, 1)
        self.assertEqual(replayed.lower_capacity_level, 1)

    def test_exact_to_approximate_moves_one_rung_after_stall(self) -> None:
        row = "L1: local bridge; status: active next; Lean: localBridge"
        ladder = ("1e-10", "1e-9", "1e-8")
        first = decide_cycle(
            task_id="SP",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            task_kind="statePreparation",
            epsilon_ladder=ladder,
        )
        second = decide_cycle(
            task_id="SP",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
            task_kind="statePreparation",
            epsilon_ladder=ladder,
        )
        opened = decide_cycle(
            task_id="SP",
            cycle=3,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[
                {
                    "trial_id": "review-open",
                    "leaf": "L1",
                    "role": "reviewer",
                    "leaf_signature": first.leaf_signature,
                    "evidence_digest": first.evidence_digest,
                    "tolerance_decision": "open_approximate",
                    "epsilon_next": "1e-10",
                }
            ],
            evidence_digest="lean-a",
            previous_state={**second.to_dict(), "execution_started": True},
            task_kind="statePreparation",
            epsilon_ladder=ladder,
        )
        self.assertFalse(opened.stop)
        self.assertEqual(opened.search_phase, "approximate_requested")
        self.assertEqual(opened.active_epsilon, "1e-10")
        self.assertEqual(opened.epsilon_index, 0)

    def test_rejected_transition_is_not_consumed_before_stall(self) -> None:
        row = "L1: local bridge; status: active next; Lean: localBridge"
        ladder = ("1e-10", "1e-9")
        first = decide_cycle(
            task_id="SP",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            task_kind="statePreparation",
            epsilon_ladder=ladder,
        )
        feedback = [
            {
                "trial_id": "open-after-stall",
                "leaf": "L1",
                "role": "upper",
                "leaf_signature": first.leaf_signature,
                "evidence_digest": first.evidence_digest,
                "capacity_decision": "increase_lower",
                "tolerance_decision": "open_approximate",
                "epsilon_next": "1e-10",
            }
        ]
        rejected = decide_cycle(
            task_id="SP",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
            task_kind="statePreparation",
            epsilon_ladder=ladder,
        )
        self.assertEqual(rejected.policy_decision_digest, "")
        self.assertEqual(rejected.lower_capacity_level, 0)
        self.assertTrue(rejected.policy_rejections)
        accepted = decide_cycle(
            task_id="SP",
            cycle=3,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
            previous_state={**rejected.to_dict(), "execution_started": True},
            task_kind="statePreparation",
            epsilon_ladder=ladder,
        )
        self.assertEqual(accepted.active_epsilon, "1e-10")
        self.assertEqual(accepted.lower_capacity_level, 1)

    def test_external_exact_gap_can_open_first_approximate_rung(self) -> None:
        row = "EXT: imported theorem; class: external_contract_gap; status: blocked external"
        ladder = ("1e-10", "1e-9")
        first = decide_cycle(
            task_id="BE",
            cycle=1,
            frontier_rows=[],
            obligation_rows=[row],
            feedback=[],
            evidence_digest="lean-a",
            task_kind="operatorBlockEncoding",
            epsilon_ladder=ladder,
        )
        opened = decide_cycle(
            task_id="BE",
            cycle=2,
            frontier_rows=[],
            obligation_rows=[row],
            feedback=[
                {
                    "trial_id": "open-external-gap",
                    "leaf": "EXT",
                    "role": "reviewer",
                    "leaf_signature": first.leaf_signature,
                    "evidence_digest": first.evidence_digest,
                    "tolerance_decision": "open_approximate",
                    "epsilon_next": "1e-10",
                }
            ],
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
            task_kind="operatorBlockEncoding",
            epsilon_ladder=ladder,
        )
        self.assertEqual(opened.active_epsilon, "1e-10")
        self.assertFalse(opened.policy_rejections)

    def test_one_cycle_policy_carry_forward_survives_prose_frontier_refresh(self) -> None:
        old_row = "EXT: source theorem; class: external_contract_gap; status: blocked external"
        first = decide_cycle(
            task_id="BE",
            cycle=1,
            frontier_rows=[],
            obligation_rows=[old_row],
            feedback=[],
            evidence_digest="lean-a",
            task_kind="operatorBlockEncoding",
            epsilon_ladder=("1e-10", "1e-9"),
        )
        new_row = (
            "APPROX-DEF: approximate finite error; Lean: approximateError; "
            "class: internal; status: approximate active next Lean leaf"
        )
        carried = decide_cycle(
            task_id="BE",
            cycle=2,
            frontier_rows=[new_row],
            obligation_rows=[],
            feedback=[
                {
                    "trial_id": "upper-before-middle-refresh",
                    "leaf": "EXT",
                    "role": "upper",
                    "leaf_signature": first.leaf_signature,
                    "evidence_digest": first.evidence_digest,
                    "tolerance_decision": "open_approximate",
                    "epsilon_next": "1e-10",
                }
            ],
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
            task_kind="operatorBlockEncoding",
            epsilon_ladder=("1e-10", "1e-9"),
        )
        self.assertEqual(carried.active_epsilon, "1e-10")
        self.assertEqual(carried.mode, "execute")
        self.assertIn("lower2", carried.prompt_plan)

    def test_tolerance_cannot_skip_a_rung(self) -> None:
        row = "L1: local bridge; status: active next; Lean: localBridge"
        previous = decide_cycle(
            task_id="BE",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            task_kind="operatorBlockEncoding",
            epsilon_ladder=("1e-10", "1e-9", "1e-8"),
        ).to_dict()
        previous.update(
            {
                "execution_started": True,
                "epsilon_index": 0,
                "search_phase": "approximate_requested",
                "unchanged_cycles": 0,
            }
        )
        skipped = decide_cycle(
            task_id="BE",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[
                {
                    "trial_id": "upper-skip",
                    "leaf": "L1",
                    "role": "upper",
                    "leaf_signature": previous["leaf_signature"],
                    "evidence_digest": "lean-a",
                    "tolerance_decision": "relax_epsilon",
                    "epsilon_next": "1e-8",
                }
            ],
            evidence_digest="lean-a",
            previous_state=previous,
            task_kind="operatorBlockEncoding",
            epsilon_ladder=("1e-10", "1e-9", "1e-8"),
        )
        self.assertEqual(skipped.epsilon_index, 0)
        self.assertTrue(any("skips" in reason for reason in skipped.policy_rejections))

    def test_approximate_leaf_is_gated_until_phase_opens(self) -> None:
        row = (
            "APPROX-L1: requested-epsilon witness; status: active next; "
            "Lean: approximateWitness"
        )
        gated = decide_cycle(
            task_id="BE",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            task_kind="operatorBlockEncoding",
            epsilon_ladder=("1e-10", "1e-9"),
        )
        self.assertEqual(gated.mode, "phase_decision")
        self.assertNotIn("lower2", gated.prompt_plan)
        opened = decide_cycle(
            task_id="BE",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[
                {
                    "trial_id": "review-open-approx-leaf",
                    "leaf": "APPROX-L1",
                    "role": "reviewer",
                    "leaf_signature": gated.leaf_signature,
                    "evidence_digest": gated.evidence_digest,
                    "tolerance_decision": "open_approximate",
                    "epsilon_next": "1e-10",
                }
            ],
            evidence_digest="lean-a",
            previous_state={**gated.to_dict(), "execution_started": True},
            task_kind="operatorBlockEncoding",
            epsilon_ladder=("1e-10", "1e-9"),
        )
        self.assertEqual(opened.mode, "execute")
        self.assertEqual(opened.active_epsilon, "1e-10")
        self.assertIn("lower2", opened.prompt_plan)


class ToleranceParsingTests(unittest.TestCase):
    def test_sparse_declared_ladder_is_filled_by_decades(self) -> None:
        text = """
Requested tolerance: epsilon = 1e-10
relaxedEpsilonLadder = [1e-10, 1e-8, 1e-6]
"""
        self.assertEqual(
            infer_epsilon_ladder(text),
            ("1e-10", "1e-9", "1e-8", "1e-7", "1e-6"),
        )


class PromptBudgetTests(unittest.TestCase):
    def test_budget_rejects_before_execution(self) -> None:
        violation = prompt_budget_violation(
            {"lower2.md": 9000, "reviewer.md": 5000},
            max_prompt_tokens=10000,
            max_cycle_tokens=12000,
            run_tokens_used=0,
            max_run_tokens=50000,
        )
        self.assertIn("cycle token budget exceeded", violation)


class AgentChangeAccountingTests(unittest.TestCase):
    def test_preexisting_dirty_files_are_not_repeated_in_agent_trial(self) -> None:
        before = {
            "old.md": (" M", 100, 10),
            "edited.lean": (" M", 200, 20),
        }
        after = {
            "old.md": (" M", 100, 10),
            "edited.lean": (" M", 204, 21),
            "new.md": ("??", 30, 22),
        }
        self.assertEqual(
            changed_snapshot_delta(before, after),
            ["edited.lean", "new.md"],
        )


if __name__ == "__main__":
    unittest.main()
