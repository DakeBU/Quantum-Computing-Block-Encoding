"""Additive current reader policy; frozen preview artifacts remain audit history."""
from copy import deepcopy
from pathlib import Path

from qcb_core import digest, read_json
from qcb_integrity import text_sha

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
CONTRACT_FIELDS = ("question", "assumptions", "conventions", "family", "split",
                   "graph_version", "target_nodes", "supporting_nodes", "source_refs")


def check_source_bindings(bindings):
    if not bindings:
        raise ValueError("substantive source bindings are required")
    for binding in bindings:
        if not isinstance(binding, dict) or not binding.get("sha256_lf"):
            raise ValueError("source review must bind exact files, not merely list source names")
        path = R / binding.get("file", binding.get("path", ""))
        if not path.is_file() or not path.resolve().is_relative_to(R) or text_sha(path) != binding["sha256_lf"]:
            raise ValueError("mathematical review source binding changed")


def check_withdrawal(row, original):
    """Bind a disposition to its actual predecessor, independent finding and sources."""
    if (row["core_id"] != original["core_id"] or original["key"] != row["predecessor_key"]
            or digest(original) != row["predecessor_item_digest"]):
        raise ValueError("reader quarantine does not bind its exact predecessor")
    review_path = B / row["review"]
    if not review_path.resolve().is_relative_to(B):
        raise ValueError("external quarantine review paths are forbidden")
    review = read_json(review_path)
    findings = [r for r in review.get("items", []) if r.get("core_id") == row["core_id"]]
    if (digest(review) != row["review_digest"] or len(findings) != 1
            or review.get("method") != "independent-mathematical-reader-review"
            or not review.get("reviewer") or review["reviewer"] == original["author"]["identity"]):
        raise ValueError("reader quarantine lacks an exact independent review")
    finding = findings[0]
    if (digest(finding) != row["finding_digest"] or finding.get("item_digest") != digest(original)
            or finding.get("verdict") not in {"reject", "uncertain"} or not finding.get("reasoning")):
        raise ValueError("reader quarantine is not backed by this rejected or uncertain content")
    check_source_bindings(finding["source_checks"])
    return finding


def apply_current_reader_policy(native):
    items = {i["core_id"]: deepcopy(i) for i in native}
    decisions = []
    policy = read_json(B / "shared/current-policy.json")
    rows = policy["answer_successors"] + policy.get("withdrawals", [])
    if len({row["core_id"] for row in rows}) != len(rows):
        raise ValueError("a core cannot have conflicting reader policy decisions")
    for row in policy["answer_successors"]:
        original = items.pop(row["core_id"])
        if original["key"] != row["predecessor_key"] or digest(original) != row["predecessor_item_digest"]:
            raise ValueError("textbook withdrawal does not bind its exact historical predecessor")
        if row.get("prior_withdrawal"):
            check_withdrawal(row["prior_withdrawal"], original)
        repair_path, review_path = B / row["repair"], B / row["review"]
        if not repair_path.resolve().is_relative_to(B) or not review_path.resolve().is_relative_to(B):
            raise ValueError("external repair/review paths are forbidden")
        repair = read_json(repair_path)
        if (repair["core_id"] != row["core_id"] or repair["supersedes_key"] != original["key"]
                or repair["supersedes_item_digest"] != digest(original)):
            raise ValueError("answer successor changed its predecessor contract")
        exposition = repair.get("exposition", {})
        if set(exposition) - {"core_summary", "semantic_steps"}:
            raise ValueError("answer repair cannot replace contract or admission metadata")
        if "core_summary" in exposition and not isinstance(exposition["core_summary"], str):
            raise ValueError("answer repair summary must be text")
        if "semantic_steps" in exposition:
            steps = exposition["semantic_steps"]
            allowed_nodes = set(original["target_nodes"] + original["supporting_nodes"])
            if (not isinstance(steps, list) or len(steps) != original["semantic_step_count"]
                    or any(not s.get("claim") or not s.get("supporting_nodes")
                           or set(s["supporting_nodes"]) - allowed_nodes for s in steps)):
                raise ValueError("answer repair changed graph scope or semantic step count")
        check_source_bindings(repair["source_checks"])
        decision = {**row, "status": "withheld_pending_distinct_repair_review"}
        if review_path.is_file():
            review = read_json(review_path)
            if (review.get("repair_record_digest") != digest(repair)
                    or review.get("method") != "independent-answer-successor-review"
                    or not review.get("reviewer") or review["reviewer"] == repair["author"]):
                raise ValueError("answer successor review is stale or not independent")
            if (review.get("verdict") == "accept" and review.get("core_id") == original["core_id"]
                    and review.get("original_item_digest") == digest(original)
                    and review.get("unchanged_question_contract_assessment", {}).get("contract_hash")
                        == digest({k: original[k] for k in CONTRACT_FIELDS})
                    and review.get("substantive_reconstruction") and review.get("source_checks")):
                check_source_bindings(review["source_checks"])
                current = deepcopy(original)
                current.update(key=repair["key"], reference_answer=repair["reference_answer"], rubric=repair["rubric"],
                               author={"identity": repair["author"], "method": "source-reconstructed additive answer repair"})
                if "core_summary" in exposition:
                    current["native_nl"]["core_summary"] = exposition["core_summary"]
                if "semantic_steps" in exposition:
                    current["semantic_steps"] = deepcopy(exposition["semantic_steps"])
                current["textbook_successor"] = {"predecessor_item_digest": digest(original),
                    "predecessor_key": original["key"],
                    "repair_record": row["repair"], "repair_record_digest": digest(repair),
                    "review_record": row["review"], "review_digest": digest(review)}
                # Never transfer old answer reviews to changed mathematical content.
                current["inherited_predecessor_reviews"] = current.pop("reviews")
                current["reviews"] = [review]
                current["id"] = "qcb-textbook-" + digest(current)[:20]
                items[row["core_id"]] = current
                decision["status"] = "reviewed_answer_successor_admitted_to_reader"
        decisions.append(decision)
    for row in policy.get("withdrawals", []):
        original = items.pop(row["core_id"])
        finding = check_withdrawal(row, original)
        decisions.append({**row, "status": "withheld_pending_mathematical_correction",
                          "finding_verdict": finding["verdict"]})
    return list(items.values()), decisions


def frozen_native_is_current(native):
    current, decisions = apply_current_reader_policy(native)
    return {i["core_id"]: digest(i) for i in current} == {i["core_id"]: digest(i) for i in native}


def public_reader_item(item):
    """Reader mathematics plus provenance references, not raw review/control logs."""
    fields = ("id", "key", "core_id", "question", "reference_answer", "assumptions", "conventions",
              "rubric", "formal_context", "task_kind", "difficulty", "topic", "family", "split",
              "graph_version", "target_nodes", "supporting_nodes", "source_refs", "primary_sources",
              "semantic_steps", "semantic_step_count", "evidence_relation", "textbook_successor")
    return {**{k: deepcopy(item[k]) for k in fields if k in item},
            "source_item_digest": digest(item), "export_role": "open_reader_not_stable_training_release"}
