#!/usr/bin/env python3

from __future__ import annotations

import unittest

try:
    from qbe_control import (
        decide_cycle,
        infer_acceptance_anchors,
        infer_epsilon_ladder,
        infer_executable_acceptance,
        infer_population_gate,
        infer_route_lock,
        latest_frontier_rows,
        latest_obligation_rows,
        prompt_budget_violation,
        reduce_latest_feedback,
        summarize_candidate_population,
    )
except ModuleNotFoundError:
    from tools.qbe_control import (
        decide_cycle,
        infer_acceptance_anchors,
        infer_epsilon_ladder,
        infer_executable_acceptance,
        infer_population_gate,
        infer_route_lock,
        latest_frontier_rows,
        latest_obligation_rows,
        prompt_budget_violation,
        reduce_latest_feedback,
        summarize_candidate_population,
    )

try:
    from qbe import (
        changed_snapshot_delta,
        build_parser,
        infer_evaluation_mode,
        lean_index_files_for_task,
        lean_sorry_lines,
        provider_blocked_control_state,
        reusable_memory_card_rows,
        task_contract_capsule,
        user_problem_task_template,
    )
except ModuleNotFoundError:
    from tools.qbe import (
        changed_snapshot_delta,
        build_parser,
        infer_evaluation_mode,
        lean_index_files_for_task,
        lean_sorry_lines,
        provider_blocked_control_state,
        reusable_memory_card_rows,
        task_contract_capsule,
        user_problem_task_template,
    )


class CurrentStateParsingTests(unittest.TestCase):
    def test_evaluation_mode_defaults_and_aliases(self) -> None:
        self.assertEqual(infer_evaluation_mode("Mode: `statePreparation`"), "full-abeis")
        self.assertEqual(
            infer_evaluation_mode("Evaluation mode: `task-only`"), "task-only"
        )
        self.assertEqual(infer_evaluation_mode("Evaluation mode: LAD"), "lad")
        self.assertEqual(
            infer_evaluation_mode("Evaluation mode: isolated-abeis"),
            "isolated-abeis",
        )
        self.assertEqual(
            infer_evaluation_mode("Evaluation mode: full_abeis"), "full-abeis"
        )

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

    def test_proof_translation_dag_is_a_schedulable_frontier(self) -> None:
        text = """
## Proof translation and DAG

| Node | Interface | Dependencies | Lean declaration | Status |
|---|---|---|---|---|
| TARGET | fixed matrix adapter | none | targetLemma | exact; proved |
| CIRCUIT | source transcript adapter | TARGET | circuitLemma | exact; active next Lean leaf |
"""
        rows = latest_frontier_rows(text)
        self.assertEqual(len(rows), 1)
        self.assertIn("CIRCUIT", rows[0])
        self.assertIn("circuitLemma", rows[0])

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
    def test_compiled_leaf_adapter_skips_redundant_architect(self) -> None:
        decision = decide_cycle(
            task_id="BE",
            cycle=1,
            frontier_rows=[
                "ADAPTER: specialize compiled theorem; class: internal compiled-leaf adapter; "
                "status: active next; Lean: taskLocalAdapter"
            ],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
        )
        self.assertEqual(decision.mode, "execute")
        self.assertEqual(decision.prompt_plan, ("lower2", "reviewer"))

    def test_stale_setup_gap_does_not_mask_a_new_ready_child(self) -> None:
        decision = decide_cycle(
            task_id="BE",
            cycle=2,
            frontier_rows=[],
            obligation_rows=[
                "ROOT-INITIALIZATION: setup; status: blocked internal; Lean: rootTheorem",
                "CIRCUIT: source adapter; status: active next; Lean: circuitLemma",
            ],
            feedback=[
                {
                    "leaf": "ROOT-INITIALIZATION",
                    "role": "upper",
                    "error_class": "source_translation_gap",
                    "closed_theorem_ok": False,
                }
            ],
            evidence_digest="lean-b",
        )
        self.assertEqual(decision.mode, "execute")
        self.assertEqual(decision.ready_leaf_ids, ("CIRCUIT",))
        self.assertIn("lower2", decision.prompt_plan)

    def test_missing_declared_root_never_closes_empty_frontier(self) -> None:
        decision = decide_cycle(
            task_id="NEW",
            cycle=1,
            frontier_rows=[],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            lean_acceptance_required=True,
            executable_acceptance_required=True,
        )
        self.assertFalse(decision.stop)
        self.assertEqual(decision.mode, "decompose")
        self.assertEqual(decision.unresolved_leaf_ids, ("ROOT-INITIALIZATION",))

    def test_isolated_abeis_keeps_population_control(self) -> None:
        row = "L1: root construction; status: active next; Lean: rootTheorem"
        decision = decide_cycle(
            task_id="COLD",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            population_gate_required=True,
            evaluation_mode="isolated-abeis",
        )
        self.assertEqual(decision.mode, "population")
        self.assertTrue(decision.population_gate_required)

    def test_task_only_is_one_bounded_nonadaptive_attempt(self) -> None:
        row = "L1: benchmark theorem; status: active next; Lean: targetTheorem"
        first = decide_cycle(
            task_id="BENCH",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            population_gate_required=True,
            evaluation_mode="task-only",
        )
        self.assertEqual(first.evaluation_mode, "task-only")
        self.assertEqual(first.prompt_plan, ("lower2", "reviewer"))
        self.assertFalse(first.population_gate_required)
        second = decide_cycle(
            task_id="BENCH",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
            population_gate_required=True,
            evaluation_mode="task-only",
        )
        self.assertTrue(second.stop)
        self.assertEqual(second.mode, "benchmark_complete")

    def test_lad_rejects_adaptive_capacity_and_tolerance(self) -> None:
        row = "L1: benchmark theorem; status: active next; Lean: targetTheorem"
        baseline = decide_cycle(
            task_id="BENCH",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            evaluation_mode="lad",
        )
        decision = decide_cycle(
            task_id="BENCH",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[
                {
                    "leaf": "L1",
                    "role": "upper",
                    "leaf_signature": baseline.leaf_signature,
                    "evidence_digest": baseline.evidence_digest,
                    "capacity_decision": "increase_lower",
                    "tolerance_decision": "open_approximate",
                    "epsilon_next": "1e-6",
                }
            ],
            evidence_digest="lean-a",
            task_kind="operatorBlockEncoding",
            epsilon_ladder=("1e-6",),
            evaluation_mode="lad",
        )
        self.assertEqual(decision.prompt_plan, ("lower2", "reviewer"))
        self.assertEqual(decision.capacity_authorizations, ())
        self.assertEqual(decision.epsilon_index, -1)

    def test_compiled_root_certificate_closes_stale_open_queue(self) -> None:
        decision = decide_cycle(
            task_id="T",
            cycle=4,
            frontier_rows=[
                "OLD: stale helper; status: active next; Lean: oldHelper"
            ],
            obligation_rows=[
                "EXT: optional optimization; class: external_contract_gap; status: blocked external"
            ],
            feedback=[],
            evidence_digest="lean-root",
            verified_root_anchors=("Root.complete",),
        )
        self.assertTrue(decision.stop)
        self.assertEqual(decision.status, "complete")
        self.assertEqual(decision.mode, "closeout")
        self.assertEqual(decision.certified_root_anchors, ("Root.complete",))

    def test_route_lock_never_schedules_off_route_lower_work(self) -> None:
        row = "APPROX-RAT-WITNESS: alternate route; status: active next; Lean: ratWitness"
        decision = decide_cycle(
            task_id="HINTED",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="missing-ratWitness",
            allowed_leaf_prefixes=("HINT-", "QSVT-"),
            forbidden_leaf_prefixes=("APPROX-RAT-",),
        )
        self.assertEqual(decision.mode, "decompose")
        self.assertNotIn("lower2", decision.prompt_plan)
        self.assertEqual(decision.route_rejected_leaf_ids, ("APPROX-RAT-WITNESS",))

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
        self.assertEqual(first.search_phase, "dependency")
        self.assertEqual(first.effective_epsilon, "n/a")
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

    def test_verified_compiled_ready_leaf_is_auto_retired(self) -> None:
        ready = "L1: compiled bridge; status: active next; Lean: localBridge"
        external = (
            "EXT: supplier theorem; class: external_contract_gap; "
            "status: blocked external"
        )
        decision = decide_cycle(
            task_id="T",
            cycle=2,
            frontier_rows=[ready],
            obligation_rows=[external],
            feedback=[],
            evidence_digest="lean-b",
            verified_closed_leaf_ids=("L1",),
        )
        self.assertEqual(decision.auto_retired_leaf_ids, ("L1",))
        self.assertNotIn("L1", decision.ready_leaf_ids)
        self.assertEqual(decision.mode, "dependency_decision")
        self.assertNotIn("lower2", decision.prompt_plan)

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

    def test_structural_gap_freezes_lower_capacity_and_tolerance(self) -> None:
        row = "BRIDGE: opaque interface; status: active next; Lean: bridgeLemma"
        initial = decide_cycle(
            task_id="BE",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            task_kind="operatorBlockEncoding",
            epsilon_ladder=("1e-10", "1e-9"),
            population_gate_required=True,
        )
        feedback = [
            {
                "trial_id": "review-structural-gap",
                "leaf": "BRIDGE",
                "role": "reviewer",
                "error_class": "symbolic_bridge_gap",
                "closed_theorem_ok": False,
                "leaf_signature": initial.leaf_signature,
                "evidence_digest": initial.evidence_digest,
                "capacity_decision": "increase_upper increase_lower",
                "tolerance_decision": "open_approximate",
                "epsilon_next": "1e-10",
            }
        ]
        decision = decide_cycle(
            task_id="BE",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
            previous_state={**initial.to_dict(), "execution_started": True},
            task_kind="operatorBlockEncoding",
            epsilon_ladder=("1e-10", "1e-9"),
            population_gate_required=True,
        )
        self.assertEqual(decision.mode, "prerequisite")
        self.assertEqual(decision.search_phase, "dependency")
        self.assertEqual(decision.effective_epsilon, "n/a")
        self.assertNotIn("lower2", decision.prompt_plan)
        self.assertEqual(decision.upper_capacity_level, 0)
        self.assertEqual(decision.lower_capacity_level, 0)
        self.assertEqual(decision.epsilon_index, -1)
        self.assertEqual(decision.prerequisite_leaf_ids, ("BRIDGE",))
        self.assertEqual(
            decision.prerequisite_error_classes, ("symbolic_bridge_gap",)
        )
        self.assertTrue(decision.policy_rejections)

    def test_unchanged_structural_prerequisite_pass_stops(self) -> None:
        row = "BRIDGE: opaque interface; status: active next; Lean: bridgeLemma"
        feedback = [
            {
                "trial_id": "lower-gap",
                "leaf": "BRIDGE",
                "role": "lower",
                "error_class": "shape_or_register_gap",
                "closed_theorem_ok": False,
            }
        ]
        first = decide_cycle(
            task_id="SP",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
        )
        self.assertEqual(first.mode, "prerequisite")
        second = decide_cycle(
            task_id="SP",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
        )
        self.assertTrue(second.stop)
        self.assertEqual(second.mode, "human_blocked")
        self.assertNotIn("lower2", second.prompt_plan)

    def test_tactic_gap_remains_a_lower_proof_task(self) -> None:
        row = "ALGEBRA: local arithmetic; status: active next; Lean: algebraLemma"
        decision = decide_cycle(
            task_id="BE",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[
                {
                    "leaf": "ALGEBRA",
                    "role": "reviewer",
                    "error_class": "lean_tactic_gap",
                    "closed_theorem_ok": False,
                }
            ],
            evidence_digest="lean-a",
        )
        self.assertEqual(decision.mode, "execute")
        self.assertIn("lower2", decision.prompt_plan)

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


class PostLeanAndPopulationTests(unittest.TestCase):
    def test_reviewer_rejection_is_typed_without_selecting(self) -> None:
        population = summarize_candidate_population(
            [
                {
                    "trial_id": "middle-propose",
                    "role": "middle",
                    "candidate_id": "c1",
                    "candidate_family": "lcu",
                    "population_action": "propose",
                    "fitness_evidence": "finite decomposition",
                },
                {
                    "trial_id": "review-reject",
                    "role": "reviewer",
                    "candidate_id": "c1",
                    "population_action": "reject",
                    "fitness_evidence": "normalization lift missing",
                },
            ]
        )
        self.assertEqual(population.active_candidate_ids, ("c1",))
        self.assertEqual(population.selected_candidate_ids, ())
        self.assertEqual(population.invalid_packets, ())

    def test_lean_root_waits_for_declared_executable_gate(self) -> None:
        waiting = decide_cycle(
            task_id="HARD",
            cycle=1,
            frontier_rows=[],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            verified_root_anchors=("Root.complete",),
            executable_acceptance_required=True,
            executable_acceptance_complete=False,
            executable_acceptance_command="python3 export.py",
            executable_acceptance_artifacts=("out.json",),
        )
        self.assertEqual(waiting.mode, "export")
        self.assertFalse(waiting.stop)
        self.assertIn("exporter", waiting.prompt_plan)
        complete = decide_cycle(
            task_id="HARD",
            cycle=2,
            frontier_rows=[],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            verified_root_anchors=("Root.complete",),
            executable_acceptance_required=True,
            executable_acceptance_complete=True,
        )
        self.assertEqual(complete.mode, "closeout")
        self.assertTrue(complete.stop)

    def test_population_requires_middle_candidate_and_privileged_selection(self) -> None:
        row = "L1: local bridge; status: active next; Lean: localBridge"
        no_population = decide_cycle(
            task_id="HARD",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=[],
            evidence_digest="lean-a",
            population_gate_required=True,
        )
        self.assertEqual(no_population.mode, "population")
        feedback = [
            {
                "trial_id": "review-select",
                "role": "reviewer",
                "candidate_id": "householder",
                "population_action": "select",
                "fitness_evidence": "finite check and compiled support leaves",
            },
            {
                "trial_id": "middle-propose",
                "role": "middle",
                "candidate_id": "householder",
                "candidate_family": "rational diagonal dilation",
                "population_action": "propose",
                "fitness_evidence": "CubicDiagonalOracle.householder8_isRationalOrthogonal",
            },
        ]
        selected = decide_cycle(
            task_id="HARD",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
            population_gate_required=True,
        )
        self.assertEqual(selected.mode, "execute")
        self.assertEqual(selected.population_direction, "householder")

    def test_unchanged_selected_route_returns_to_population_before_retry(self) -> None:
        row = "L1: local bridge; status: active next; Lean: localBridge"
        feedback = [
            {
                "trial_id": "review-select",
                "role": "reviewer",
                "candidate_id": "direct",
                "population_action": "select",
                "fitness_evidence": "best current exact route",
            },
            {
                "trial_id": "middle-propose",
                "role": "middle",
                "candidate_id": "direct",
                "candidate_family": "direct exact",
                "population_action": "propose",
                "fitness_evidence": "one named ready leaf",
            },
        ]
        first = decide_cycle(
            task_id="HARD",
            cycle=1,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
            population_gate_required=True,
        )
        second = decide_cycle(
            task_id="HARD",
            cycle=2,
            frontier_rows=[row],
            obligation_rows=[],
            feedback=feedback,
            evidence_digest="lean-a",
            previous_state={**first.to_dict(), "execution_started": True},
            max_no_progress_cycles=2,
            population_gate_required=True,
        )
        self.assertEqual(second.mode, "population")
        self.assertNotIn("lower2", second.prompt_plan)

    def test_crossover_without_two_parents_is_rejected(self) -> None:
        population = summarize_candidate_population(
            [
                {
                    "trial_id": "bad-cross",
                    "role": "middle",
                    "candidate_id": "child",
                    "population_action": "crossover",
                    "parent_ids": "only-one",
                    "fitness_evidence": "idea",
                }
            ]
        )
        self.assertFalse(population.active_candidate_ids)
        self.assertTrue(population.invalid_packets)


class ToleranceParsingTests(unittest.TestCase):
    def test_explicit_acceptance_anchors_are_parsed_in_order(self) -> None:
        text = (
            "Lean acceptance anchors: `Root.input_complete`, "
            "`Root.target_complete`\n"
        )
        self.assertEqual(
            infer_acceptance_anchors(text),
            ("Root.input_complete", "Root.target_complete"),
        )

    def test_explicit_route_lock_is_parsed(self) -> None:
        text = """
Route lock: `HINT-`, `QSVT-`
Forbidden leaf prefixes: `APPROX-RAT-`, `RATIONAL-CIRCLE-`
"""
        self.assertEqual(
            infer_route_lock(text),
            (("HINT-", "QSVT-"), ("APPROX-RAT-", "RATIONAL-CIRCLE-")),
        )

    def test_executable_acceptance_contract_is_parsed(self) -> None:
        contract = infer_executable_acceptance(
            "Executable acceptance command: `python3 tools/export.py`\n"
            "Executable acceptance artifacts: `out/a.json`, `out/a.qasm3`\n"
        )
        self.assertEqual(contract.command, "python3 tools/export.py")
        self.assertEqual(contract.artifacts, ("out/a.json", "out/a.qasm3"))
        self.assertEqual(contract.backend, "both")
        self.assertTrue(contract.required)

    def test_selectable_executable_policy_is_parsed_independently(self) -> None:
        contract = infer_executable_acceptance(
            "Executable check backend: `openqasm3RoundTrip`\n"
            "Executable check required: `false`\n"
            "Executable evidence classes: `syntaxOnly`, `roundTrip`\n"
            "Executable acceptance command: `python3 tools/check.py`\n"
        )
        self.assertEqual(contract.backend, "openqasm3RoundTrip")
        self.assertFalse(contract.required)
        self.assertEqual(contract.evidence_classes, ("syntaxOnly", "roundTrip"))

    def test_population_gate_is_explicit(self) -> None:
        self.assertTrue(infer_population_gate("Population gate: `required`\n"))
        self.assertFalse(infer_population_gate("Population is discussed in prose.\n"))

    def test_sparse_declared_ladder_is_filled_by_decades(self) -> None:
        text = """
Requested tolerance: epsilon = 1e-10
relaxedEpsilonLadder = [1e-10, 1e-8, 1e-6]
"""
        self.assertEqual(
            infer_epsilon_ladder(text),
            ("1e-10", "1e-9", "1e-8", "1e-7", "1e-6"),
        )

    def test_markdown_line_ladder_is_parsed(self) -> None:
        text = "Tolerance ladder: `0`, `1e-10`, `1e-9`, `1e-8`, `1e-7`, `1e-6`\n"
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
    def test_user_ingestion_starts_with_named_active_root(self) -> None:
        task = user_problem_task_template(
            safe_id="WEB-TASK-1",
            title="Web task",
            kind="statePreparation",
            mode="statePreparation",
            language="en",
            prompt_path="task-inbox/WEB-TASK-1/user_prompt.en.md",
            source="web",
            epsilon="0",
            export_targets="qiskit",
            raw="Prepare |1>.",
        )
        self.assertEqual(
            infer_acceptance_anchors(task),
            ("UserSubmission.WEB_TASK_1_rootCertificate",),
        )
        frontier = latest_frontier_rows(task)
        self.assertEqual(len(frontier), 1)
        self.assertIn("ROOT-INITIALIZATION", frontier[0])

    def test_provider_block_does_not_advance_cycle_or_token_budget(self) -> None:
        state = provider_blocked_control_state(
            {"cycle": 4, "estimated_run_input_tokens": 9000},
            previous_cycle=3,
            run_tokens_used=7000,
        )
        self.assertEqual(state["cycle"], 3)
        self.assertEqual(state["estimated_run_input_tokens"], 7000)
        self.assertEqual(state["estimated_cycle_input_tokens"], 0)
        self.assertEqual(state["status"], "provider-blocked")
        self.assertFalse(state["stop"])

    def test_external_agent_parallelism_requires_explicit_opt_in(self) -> None:
        args = build_parser().parse_args(["sleep-run", "T", "--dry-run"])
        self.assertFalse(args.parallel_panels)
        self.assertFalse(args.parallel_lower)

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


class ReusableMemoryRoutingTests(unittest.TestCase):
    def test_sorry_scan_uses_only_existing_test_roots(self) -> None:
        self.assertFalse(any(line.startswith("rg failed:") for line in lean_sorry_lines()))

    def test_state_capsule_preserves_contract_and_executable_evidence(self) -> None:
        task_text = """
Kind: `operatorBlockEncoding`
## Lean-Checkable Target
For N = 2^n, encode D with alpha = 1.
Register order: ancilla then system.
The clean block uses one ancilla projector.
Requested tolerance: epsilon = 1e-10
"""
        capsule = task_contract_capsule(
            "T",
            task_text,
            {
                "leaf_signature": "leaf",
                "evidence_digest": "evidence",
                "ready_leaf_ids": ["L1"],
                "search_phase": "exact",
                "effective_epsilon": "0",
                "executable_acceptance_required": True,
                "executable_acceptance_complete": True,
                "executable_acceptance_artifacts": ["acceptance.json"],
            },
            [{"compiled_lean_anchors": ["D.complete"]}],
            [],
        )
        self.assertEqual(capsule["normalization_alpha"], ["1"])
        self.assertIn("Register order", capsule["register_order"][0])
        self.assertEqual(capsule["compiled_lean_declarations"], ["D.complete"])
        self.assertTrue(capsule["executable_acceptance"]["complete"])
        self.assertEqual(len(capsule["active_route_fingerprint"]), 64)

    def test_cubic_index_includes_product_and_state_preparation_modules(self) -> None:
        names = {path.name for path in lean_index_files_for_task("cubic diagonal x^3")}
        self.assertIn("BlockEncodingClassics.lean", names)
        self.assertIn("StatePreparation.lean", names)

    def test_cubic_qsvt_hint_ranks_compiled_product_before_qsvt(self) -> None:
        rows = reusable_memory_card_rows(
            "construct diagonal O0 then use QSVT polynomial x^3 for cubic target"
        )
        paths = [str(row["path"]) for row in rows]
        product = next(i for i, path in enumerate(paths) if "Arithmetic.Product" in path)
        qsvt = next(i for i, path in enumerate(paths) if "QSVT.Consumer" in path)
        self.assertLess(product, qsvt)

    def test_cubic_memory_exposes_complete_exact_root(self) -> None:
        rows = reusable_memory_card_rows("cubic diagonal x^3 exact block encoding")
        householder = next(
            row for row in rows if "Diagonal.RationalHouseholder" in str(row["path"])
        )
        self.assertIn(
            "cubicDiagonalHouseholderExactBEContract_complete",
            householder["compiled_lean_anchors"],
        )


if __name__ == "__main__":
    unittest.main()
