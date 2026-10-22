"""Additive current reader policy; frozen preview artifacts remain audit history."""
from copy import deepcopy
import math
from pathlib import Path
import re

from qcb_core import digest, read_json
from qcb_integrity import text_sha

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
CONTRACT_FIELDS = ("question", "assumptions", "conventions", "family", "split",
                   "graph_version", "target_nodes", "supporting_nodes", "source_refs")


def check_exposition(exposition, original):
    if set(exposition) - {"core_summary", "semantic_steps"}:
        raise ValueError("repair exposition cannot replace contract or admission metadata")
    if "core_summary" in exposition and not isinstance(exposition["core_summary"], str):
        raise ValueError("repair summary must be text")
    if "semantic_steps" in exposition:
        steps = exposition["semantic_steps"]
        allowed_nodes = set(original["target_nodes"] + original["supporting_nodes"])
        if (not isinstance(steps, list) or len(steps) != original["semantic_step_count"]
                or any(not s.get("claim") or not s.get("supporting_nodes")
                       or set(s["supporting_nodes"]) - allowed_nodes for s in steps)):
            raise ValueError("repair changed graph scope or semantic step count")


def question_successor(row, original):
    """A versioned replacement question; never pretend its old contract survived."""
    check_withdrawal(row["prior_withdrawal"], original)
    paths = [B / row[key] for key in ("repair", "review")]
    if any(not path.resolve().is_relative_to(B) for path in paths):
        raise ValueError("external question repair/review paths are forbidden")
    repair = read_json(paths[0])
    allowed = {"schema_version", "core_id", "supersedes_key", "supersedes_item_digest",
               "supersedes_contract_hash", "author", "key", "question_version", "admission",
               "change_scope", "question", "reference_answer", "rubric", "exposition",
               "source_checks", "execution"}
    convention_revision = repair.get("schema_version") == "qcb.textbook_question_successor.v2"
    if convention_revision:
        allowed.add("conventions")
    original_contract = {key: original[key] for key in CONTRACT_FIELDS}
    if (set(repair) != allowed or repair["schema_version"] not in {
            "qcb.textbook_question_successor.v1", "qcb.textbook_question_successor.v2"}
            or repair["core_id"] != original["core_id"] or row["core_id"] != original["core_id"]
            or repair["supersedes_key"] != original["key"] or row["predecessor_key"] != original["key"]
            or repair["supersedes_item_digest"] != digest(original)
            or row["predecessor_item_digest"] != digest(original)
            or repair["supersedes_contract_hash"] != digest(original_contract)
            or repair["question_version"] != 2 or not repair["author"] or not repair["change_scope"]
            or not isinstance(repair["question"], str) or not repair["question"].strip()
            or repair["question"] == original["question"]
            or not isinstance(repair["author"], str) or not repair["author"].strip()
            or repair["admission"] != "pending_distinct_review"
            or not isinstance(repair["key"], str) or not re.fullmatch(
                re.escape(original["core_id"]) + r"-textbook-question-v2-[a-z0-9]+(?:-[a-z0-9]+)*", repair["key"])):
        raise ValueError("question successor does not bind an explicit versioned contract change")
    if convention_revision and (
            not isinstance(repair["conventions"], list) or not repair["conventions"]
            or any(not isinstance(s, str) or not s.strip() for s in repair["conventions"])
            or len(set(repair["conventions"])) != len(repair["conventions"])
            or repair["conventions"] == original["conventions"]):
        raise ValueError("convention successor requires explicit changed nonempty conventions")
    rubric = repair["rubric"]
    if (not isinstance(repair["reference_answer"], str) or not repair["reference_answer"].strip()
            or not isinstance(rubric, list) or not rubric
            or any(not isinstance(r, dict) or set(r) != {"id", "weight", "criterion"}
                   or not isinstance(r["id"], str) or not r["id"].strip()
                   or not isinstance(r["criterion"], str) or not r["criterion"].strip()
                   or isinstance(r["weight"], bool) or not isinstance(r["weight"], (int, float))
                   or not math.isfinite(r["weight"]) or r["weight"] <= 0 for r in rubric)
            or len({r["id"] for r in rubric}) != len(rubric)):
        raise ValueError("question successor requires a complete answer and well-formed rubric")
    check_exposition(repair["exposition"], original)
    check_source_bindings(repair["source_checks"])
    new_contract = {**original_contract, "question": repair["question"]}
    changed_fields = ["question"]
    if convention_revision:
        new_contract["conventions"] = deepcopy(repair["conventions"])
        changed_fields.append("conventions")
    decision = {**row, "status": "withheld_pending_distinct_question_review"}
    if not paths[1].is_file():
        return None, decision
    review = read_json(paths[1])
    reviewer = review.get("reviewer")
    if (review.get("repair_record_digest") != digest(repair)
            or review.get("method") != ("independent-question-convention-successor-review"
                if convention_revision else "independent-question-successor-review")
            or not isinstance(reviewer, str) or not reviewer.strip()
            or reviewer in {repair["author"], original["author"]["identity"]}
            or review.get("original_item_digest") != digest(original)
            or review.get("original_contract_hash") != digest(original_contract)
            or review.get("successor_contract_hash") != digest(new_contract)
            or review.get("question_version") != repair["question_version"]):
        raise ValueError("question successor review is stale or not independent")
    if review.get("verdict") != "accept":
        return None, decision
    narratives = [review.get(key) for key in ("substantive_reconstruction", "contract_change_assessment")]
    if convention_revision:
        narratives.append(review.get("convention_change_assessment"))
        if (review.get("original_conventions") != original["conventions"]
                or review.get("successor_conventions") != repair["conventions"]
                or review.get("changed_contract_fields") != changed_fields):
            raise ValueError("convention successor review must bind both convention lists and changed fields")
    if (review.get("core_id") != original["core_id"] or not review.get("source_checks")
            or any(not isinstance(n, dict) or not n or any(
                not isinstance(k, str) or not k.strip() or not isinstance(v, str) or not v.strip()
                for k, v in n.items()) for n in narratives)):
        raise ValueError("question successor lacks a substantive contract-change review")
    check_source_bindings(review["source_checks"])
    current = deepcopy(original)
    for field in ("key", "question", "reference_answer", "rubric", "question_version"):
        current[field] = deepcopy(repair[field])
    if convention_revision:
        current["conventions"] = deepcopy(repair["conventions"])
    for field in ("core_summary",):
        if field in repair["exposition"]:
            current["native_nl"][field] = repair["exposition"][field]
    if "semantic_steps" in repair["exposition"]:
        current["semantic_steps"] = deepcopy(repair["exposition"]["semantic_steps"])
    current["author"] = {"identity": repair["author"], "method": "explicit versioned question-contract correction"}
    if convention_revision:
        current["author"]["method"] = "explicit versioned question-and-convention correction"
    current["native_nl"].update(author_identity=repair["author"], new_problem_core=False)
    current["inherited_predecessor_reviews"] = current.pop("reviews")
    current["inherited_predecessor_hashes"] = {key: current.pop(key) for key in
        ("authored_hash", "context_hash", "task_hash") if key in current}
    current["reviews"] = [review]
    current["question_successor"] = {
        "question_version": repair["question_version"], "predecessor_key": original["key"],
        "predecessor_item_digest": digest(original), "predecessor_contract_hash": digest(original_contract),
        "current_contract_hash": digest(new_contract), "changed_contract_fields": changed_fields,
        "repair_record": row["repair"], "repair_record_digest": digest(repair),
        "review_record": row["review"], "review_digest": digest(review),
        "equivalence_to_predecessor_claimed": False, "additional_core_count": 0}
    if convention_revision:
        current["question_successor"].update(
            original_conventions=deepcopy(original["conventions"]),
            current_conventions=deepcopy(current["conventions"]))
    current["id"] = "qcb-textbook-" + digest(current)[:20]
    decision["status"] = "reviewed_question_successor_admitted_to_reader"
    return current, decision


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
    rows = policy["answer_successors"] + policy.get("question_successors", []) + policy.get("withdrawals", [])
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
        check_exposition(exposition, original)
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
    for row in policy.get("question_successors", []):
        original = items.pop(row["core_id"])
        current, decision = question_successor(row, original)
        if current is not None:
            items[row["core_id"]] = current
        decisions.append(decision)
    for row in policy.get("withdrawals", []):
        original = items.pop(row["core_id"])
        finding = check_withdrawal(row, original)
        decisions.append({**row, "status": "withheld_pending_mathematical_correction",
                          "finding_verdict": finding["verdict"]})
    if len({item["key"] for item in items.values()}) != len(items):
        raise ValueError("reader policy introduced a colliding current item key")
    return list(items.values()), decisions


def frozen_native_is_current(native):
    current, decisions = apply_current_reader_policy(native)
    return {i["core_id"]: digest(i) for i in current} == {i["core_id"]: digest(i) for i in native}


def public_reader_item(item):
    """Reader mathematics plus provenance references, not raw review/control logs."""
    fields = ("id", "key", "core_id", "question", "reference_answer", "assumptions", "conventions",
              "rubric", "formal_context", "task_kind", "difficulty", "topic", "family", "split",
              "graph_version", "target_nodes", "supporting_nodes", "source_refs", "primary_sources",
              "semantic_steps", "semantic_step_count", "evidence_relation", "textbook_successor",
              "question_successor", "question_version")
    return {**{k: deepcopy(item[k]) for k in fields if k in item},
            "source_item_digest": digest(item), "export_role": "open_reader_not_stable_training_release"}
