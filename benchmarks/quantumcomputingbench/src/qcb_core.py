"""Versioned QA lifecycle, contamination controls and conservative scoring.

Only curated public material belongs here. Structural validation is NOT a
mathematical review and no fixture result is a model baseline.
"""
from __future__ import annotations

import copy
import hashlib
import json
import math
import re
from pathlib import Path

SCHEMA_VERSION = "qcb.item.v1"
TRACKS = {"knowledge", "reasoning", "quantum_semantics", "lean", "planned"}
EXPOSURES = {"closed_book", "approved_interface", "open_library"}
PUBLIC_FIELDS = {"id", "schema_version", "question", "language", "answer_format",
                 "track", "topic", "assumptions", "conventions", "formal_context",
                 "exposure", "task_hash"}


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, ensure_ascii=False,
                                     separators=(",", ":")).encode()).hexdigest()


def read_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def write_json(path, value, immutable=False):
    path = Path(path)
    text = json.dumps(value, indent=2, sort_keys=True, ensure_ascii=False) + "\n"
    if immutable and path.exists() and path.read_text(encoding="utf-8") != text:
        raise ValueError(f"frozen artifact differs: {path.name}; use a new version")
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(text, encoding="utf-8")
    temporary.replace(path)


def content_hash(item):
    return digest({k: v for k, v in item.items()
                   if k not in {"reviews", "validation", "lifecycle", "verification_receipts"}})


def normalize_question(text):
    return " ".join(re.findall(r"\w+", text.casefold()))


def node_id(value):
    """Lossless authoring adapter: explicit declaration record -> canonical ID."""
    if isinstance(value, str):
        return value
    if isinstance(value, dict) and set(value) == {"declaration"}:
        return "declaration:" + value["declaration"]
    raise ValueError("node reference must be a canonical ID or explicit declaration record")


def prepare(authored, snapshot):
    """Freeze authoring without silently promoting it to validated gold."""
    items = []
    for original in authored:
        item = copy.deepcopy(original)
        item["target_nodes"] = [node_id(n) for n in item["target_nodes"]]
        item["supporting_nodes"] = [node_id(n) for n in item["supporting_nodes"]]
        for step in item["semantic_steps"]:
            step["supporting_nodes"] = [node_id(n) for n in step["supporting_nodes"]]
        item["authored_hash"] = digest(original)
        item["primary_sources"] = [ref["primary_source"] for ref in item["source_refs"] if "primary_source" in ref]
        item["source_refs"] = [ref for ref in item["source_refs"] if "primary_source" not in ref]
        item.update(schema_version=SCHEMA_VERSION, language="en",
                    graph_version=snapshot["snapshot_id"], lifecycle="candidate",
                    exposure="closed_book", release_policy="public",
                    author=original.get("author", {"identity": "qcb-session-author",
                            "method": "source-inspected AI authoring", "independence": "self-authored"}),
                    lineage={"template": original["key"], "family": original["family"],
                             "parameters": {}, "provider": "session assistant", "model_version": None,
                             "seed": 0, "tokens": None, "cost_usd": None},
                    reviews=[], verification_receipts=[])
        item["skills"] = original.get("skills", [item["track"]])
        item["id"] = "qcb-" + digest({"key": item["key"], "graph": item["graph_version"]})[:20]
        nodes = sorted(set(item["target_nodes"] + item["supporting_nodes"]))
        item["support_count"] = len(nodes)
        item["semantic_step_count"] = len(item["semantic_steps"])
        item["structural_graph_distance"] = None
        item["structural_distance_definition"] = "unknown; imports are not theorem entailment"
        item["relation_types"] = ["authored_mathematical_support"] if item["semantic_steps"] else []
        formal = item.get("formal")
        item["formal_context"] = ({"imports": formal["imports"], "target": formal["target"]}
                                  if formal else None)
        item["context_hash"] = digest({"assumptions": item["assumptions"],
                                      "conventions": item["conventions"],
                                      "formal_context": item["formal_context"]})
        item["task_hash"] = digest({"question": item["question"], "context": item["context_hash"]})
        item["split_group"] = item["family"]
        item["split"] = split_for(item["split_group"], item["topic"])
        item["validation"] = {"formal": "not_replayed" if formal else "not_applicable",
                              "nl_alignment": "pending", "answer_quality": "pending"}
        items.append(item)
    return items


def split_for(group, topic, seed="qcb-v1"):
    # Construction-family holdout, not a random row split. No secret-test claim.
    if topic in {"quantum_information", "scientific_computing"}:
        return "test_public"
    bucket = int(digest({"seed": seed, "family": group})[:8], 16) % 10
    return "train" if bucket < 7 else "dev" if bucket < 9 else "test_public"


def validate(items, snapshot, root=None):
    ids, questions, groups, targets = set(), set(), {}, {}
    nodes = {n["id"] for n in snapshot["nodes"]}
    errors = []
    originals = {}
    if root:
        authored_dir = Path(root) / "benchmarks/quantumcomputingbench/data/authored"
        for path in sorted(authored_dir.glob("*.json")):
            batch = read_json(path)
            for raw in batch.get("items", []) if isinstance(batch, dict) else batch:
                originals[digest(raw)] = raw
    required = {"id", "schema_version", "question", "reference_answer", "rubric", "track",
                "topic", "target_nodes", "supporting_nodes", "assumptions", "conventions",
                "source_refs", "family", "split_group", "split", "task_hash", "context_hash",
                "support_count", "semantic_step_count", "semantic_steps", "reviews",
                "validation", "evidence_status", "unresolved_issues", "release_policy",
                "graph_version", "formal_context", "lifecycle", "author"}
    for item in items:
        key = item.get("id", "<missing>")
        def fail(message):
            errors.append(f"{key}: {message}")
        if required - item.keys():
            fail(f"missing fields {sorted(required - item.keys())}")
            continue
        if item["schema_version"] != SCHEMA_VERSION or item["track"] not in TRACKS:
            fail("unsupported schema or track")
        if not isinstance(item["author"], dict) or not item["author"].get("identity"):
            fail("author identity required")
            continue
        formal = item.get("formal")
        if (item.get("answer_format") == "lean") != bool(formal):
            fail("formal task requires both Lean answer format and frozen formal context")
        if formal and item["formal_context"] != {"imports": formal.get("imports"), "target": formal.get("target")}:
            fail("formal context differs from frozen imports/target")
        if item["evidence_status"] not in {"source_inspected", "planned_source_inspected", "planned_evidence_pending"}:
            fail("unsupported evidence class; source inspection is not Lean certification")
        if key in ids:
            fail("duplicate ID")
        ids.add(key)
        q = normalize_question(item["question"])
        if q in questions:
            fail("duplicate normalized question")
        questions.add(q)
        if not item["question"].strip() or not item["reference_answer"].strip():
            fail("empty question or answer")
        support = set(item["target_nodes"] + item["supporting_nodes"])
        if not item["target_nodes"] or support - nodes:
            fail(f"unknown or empty target/support nodes: {sorted(support - nodes)}")
        if item["support_count"] != len(support):
            fail("inflated support count")
        if item["semantic_step_count"] != len(item["semantic_steps"]):
            fail("inflated semantic step count")
        for step in item["semantic_steps"]:
            mapped = bool(step.get("supporting_nodes"))
            blocked_draft = item["lifecycle"] == "candidate" and bool(item["unresolved_issues"])
            if (not step.get("claim") or (not mapped and not blocked_draft)
                    or set(step.get("supporting_nodes", [])) - support):
                fail("unmapped inference step")
        rubric = item["rubric"]
        if (not rubric or any(not r.get("criterion") or not isinstance(r.get("weight"), (int, float))
                              or not math.isfinite(r["weight"]) or r["weight"] <= 0 for r in rubric)
                or len({r["id"] for r in rubric}) != len(rubric)):
            fail("invalid rubric")
        if item["graph_version"] != snapshot["snapshot_id"]:
            fail("snapshot mismatch")
        expected_context = digest({"assumptions": item["assumptions"], "conventions": item["conventions"],
                                   "formal_context": item["formal_context"]})
        if item["context_hash"] != expected_context or item["task_hash"] != digest({
                "question": item["question"], "context": expected_context}):
            fail("context/target changed without re-freezing")
        group = item["split_group"]
        if group in groups and groups[group] != item["split"]:
            fail("family leakage across splits")
        groups[group] = item["split"]
        # Same target solution must not leak through alternate wording/family IDs.
        for target in item["target_nodes"]:
            if target in targets and targets[target] != item["split"]:
                fail("same target solution crosses splits")
            targets[target] = item["split"]
        for ref in item["source_refs"]:
            if not all(ref.get(k) for k in ["path", "sha256", "anchor", "license"]):
                fail("incomplete source/license anchor")
            if root:
                path = (Path(root) / ref["path"]).resolve()
                if not path.is_relative_to(Path(root).resolve()):
                    fail("source path escapes repository")
                elif not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != ref["sha256"]:
                    fail("source digest mismatch")
        if not item["source_refs"]:
            fail("missing source evidence")
        if item["release_policy"] != "public":
            fail("private material must never enter public item artifacts")
        if item["lifecycle"] in {"validated", "released"}:
            accepted = [r for r in item["reviews"] if r.get("verdict") == "accept"
                        and r.get("content_hash") == content_hash(item)
                        and r.get("reviewer") != item["author"]["identity"]
                        and r.get("artifact") and r.get("method") == "distinct-context-source-review"]
            if not accepted or item["unresolved_issues"]:
                fail("unreviewed or unresolved item promoted")
            if root:
                if item.get("authored_hash") not in originals:
                    fail("reviewed authoring artifact absent or changed")
                else:
                    baseline = prepare([originals[item["authored_hash"]]], snapshot)[0]
                    # Split assignment may change only through explicit versioned
                    # unioning; every mathematical authoring field must be exact.
                    for field in set(baseline) - {"split", "split_group", "reviews", "validation", "lifecycle", "verification_receipts"}:
                        if item.get(field) != baseline[field]:
                            fail(f"reviewed content differs from authored field: {field}")
                for review in accepted:
                    artifact = (Path(root) / review["artifact"]).resolve()
                    if (not artifact.is_relative_to(Path(root).resolve()) or not artifact.is_file()
                            or hashlib.sha256(artifact.read_bytes()).hexdigest() != review.get("artifact_sha256")):
                        fail("review artifact absent or changed")
                        continue
                    packet = read_json(artifact)
                    if (packet.get("reviewer") != review["reviewer"]
                            or not any(r.get("key") == item["key"]
                                       and (r.get("content_hash") == content_hash(item)
                                            or r.get("authored_sha256") == item.get("authored_hash"))
                                       and r.get("verdict") == "accept" for r in packet.get("items", []))):
                        fail("review artifact does not admit this exact item")
            if item["track"] == "planned" and item["evidence_status"] != "planned_source_inspected":
                fail("planned material lacks primary source inspection")
            if item["validation"]["nl_alignment"] != "reviewed" or item["validation"]["answer_quality"] != "reviewed":
                fail("semantic/answer review missing")
            if item.get("formal"):
                # No caller-supplied receipt is accepted as a proof certificate.
                fail("formal release requires trusted isolated replay (not yet enabled)")
    return errors


def assign_splits(items):
    """Union families and target-solution overlap before assigning a split."""
    parent = list(range(len(items)))
    def find(i):
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i
    seen = {}
    for i, item in enumerate(items):
        for key in ["family:" + item["family"]] + ["target:" + n for n in item["target_nodes"]]:
            if key in seen:
                parent[find(i)] = find(seen[key])
            seen[key] = i
    components = {}
    for i, item in enumerate(items):
        components.setdefault(find(i), []).append(item)
    for component in components.values():
        group = "+".join(sorted({x["family"] for x in component}))
        held = any(x["track"] == "planned" or x["topic"] in {"quantum_information", "scientific_computing"} for x in component)
        split = "test_public" if held else split_for(group, "shared")
        for item in component:
            item.update(split_group=group, split=split)
    return items


def model_input(item, exposure="closed_book", interface=None):
    if exposure not in EXPOSURES:
        raise ValueError("unknown exposure")
    result = {k: copy.deepcopy(v) for k, v in item.items() if k in PUBLIC_FIELDS}
    result["exposure"] = exposure
    if exposure == "approved_interface":
        # Explicit per-task approved statements only; arbitrary files are never read.
        if not interface or set(interface) != {"statements", "policy_hash"}:
            raise ValueError("approved interface manifest required")
        if interface["policy_hash"] != digest(interface["statements"]):
            raise ValueError("unbound interface")
        if any(set(s) != {"name", "type"} for s in interface["statements"]):
            raise ValueError("proofs/answers not allowed in interface")
        result["interface"] = copy.deepcopy(interface["statements"])
    elif interface is not None:
        raise ValueError("interface disallowed in this exposure")
    return result


def score(items, predictions, ratings=None):
    """Rubric marks are evaluator input, never inferred by keyword/word-count.

    Missing predictions score zero; uncertain/unreviewed NL judgments stay null.
    Exact grading does not imply semantic fidelity. Formal grading fails closed.
    """
    by_id = {i["id"]: i for i in items}
    pred = {}
    for p in predictions:
        if p["id"] not in by_id or p["id"] in pred:
            raise ValueError("unknown or duplicate prediction ID")
        if not isinstance(p.get("answer"), str):
            raise ValueError("prediction answer must be a string")
        pred[p["id"]] = p["answer"]
    marks = {}
    for r in ratings or []:
        if r["id"] in marks or r["id"] not in by_id:
            raise ValueError("unknown or duplicate rating ID")
        marks[r["id"]] = r
    results = []
    for item in items:
        key = item["id"]
        value, reason, fidelity = None, "needs_review", None
        if key not in pred:
            value, reason = 0.0, "missing_prediction"
        elif item["answer_format"] == "exact":
            value = float(pred[key].strip() == item["reference_answer"].strip())
            reason = "exact"
        elif item["answer_format"] == "lean":
            reason = "isolated_verifier_required"
        elif key in marks:
            mark = marks[key]
            if (mark.get("prediction_hash") != digest(pred[key])
                    or mark.get("item_hash") != content_hash(item) or not mark.get("reviewer")
                    or mark.get("kind") != "human_rubric"):
                raise ValueError("unbound/unreviewed rubric rating")
            expected = {r["id"] for r in item["rubric"]}
            scores = mark["criteria"]
            if set(scores) != expected or any(type(v) not in (int, float) or not math.isfinite(v)
                                               or not 0 <= v <= 1 for v in scores.values()):
                raise ValueError("invalid criterion marks")
            if mark.get("semantic_fidelity") not in {"faithful", "unfaithful", "uncertain"}:
                raise ValueError("semantic fidelity required separately")
            fidelity, reason = mark["semantic_fidelity"], "human_rubric"
            if fidelity == "uncertain":
                value, reason = None, "uncertain_requires_review"
            else:
                value = sum(r["weight"] * scores[r["id"]] for r in item["rubric"]) / sum(r["weight"] for r in item["rubric"])
        results.append({"id": key, "track": item["track"], "correctness": value,
                        "semantic_fidelity": fidelity, "evidence_status": item["evidence_status"], "reason": reason})
    tracks = {}
    for track in sorted({i["track"] for i in items}):
        rows = [r for r in results if r["track"] == track]
        done = [r["correctness"] for r in rows if r["correctness"] is not None]
        tracks[track] = {"total": len(rows), "graded": len(done), "pending": len(rows)-len(done),
                         "graded_mean": sum(done)/len(done) if done else None}
    return {"schema_version": "qcb.score.v1", "model_performance_measured": False,
            "note": "Scoring output alone is not a model baseline; attach a real run manifest.",
            "results": results, "by_track": tracks}
