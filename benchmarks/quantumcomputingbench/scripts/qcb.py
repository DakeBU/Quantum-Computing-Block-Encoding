#!/usr/bin/env python3
"""Offline-first QuantumComputingBench command line. Run --help for commands."""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import sys

BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parents[1]
sys.path.insert(0, str(BASE / "src"))
from qcb_core import (assign_splits, content_hash, digest, model_input, prepare,
                      read_json, score, validate, write_json)


def schema_check(items):
    import jsonschema
    schema = read_json(BASE / "schemas/item-v1.schema.json")
    validator = jsonschema.Draft202012Validator(schema)
    return [f"{i.get('id')}: {e.message}" for i in items for e in validator.iter_errors(i)]


def paths(version):
    if not version or version in {".", ".."} or any(c not in "abcdefghijklmnopqrstuvwxyz0123456789.-" for c in version):
        raise ValueError("version must be a simple lowercase label")
    return BASE / "manifests" / version, BASE / "data/public" / version, BASE / "reports" / version


def load(version):
    manifest, public, reports = paths(version)
    snap = read_json(manifest / "snapshot.json")
    for relative, expected in snap["input_hashes"].items():
        path = (ROOT / relative).resolve()
        if (not path.is_relative_to(ROOT.resolve()) or not path.is_file()
                or hashlib.sha256(path.read_bytes()).hexdigest() != expected):
            raise ValueError("frozen source/adapter changed: " + relative + "; create an explicit migration/new version")
    return snap, read_json(public / "items.json")


def reject(errors):
    if errors:
        raise ValueError("\n".join(errors))


def snapshot_command(args):
    from qcb_snapshot import snapshot
    manifest, _, _ = paths(args.version)
    value = snapshot(ROOT)
    target = manifest / "snapshot.json"
    if target.exists():
        old = read_json(target)
        if old["input_hashes"] != value["input_hashes"]:
            raise ValueError("library inputs changed; create a new version/migration")
        print(json.dumps({"snapshot_id": old["snapshot_id"], "nodes": len(old["nodes"]), "resumed": True}))
        return
    write_json(target, value, immutable=True)
    print(json.dumps({"snapshot_id": value["snapshot_id"], "nodes": len(value["nodes"])}))


def generate_command(args):
    manifest, public, _ = paths(args.version)
    snap = read_json(manifest / "snapshot.json")
    authored = []
    sources = [BASE / "data/authored" / name for name in args.batches] if args.batches else sorted((BASE / "data/authored").glob("*.json"))
    for source in sources:
        if source.parent.resolve() != (BASE / "data/authored").resolve() or source.suffix != ".json":
            raise ValueError("batch must be a JSON filename in authored data")
        batch = read_json(source)
        authored.extend(batch["items"] if isinstance(batch, dict) else batch)
    superseded = {i["supersedes"] for i in authored if i.get("supersedes")}
    authored = [i for i in authored if i["key"] not in superseded]
    if args.limit < 0:
        raise ValueError("limit must be nonnegative")
    if args.limit:
        authored = authored[:args.limit]
    items = assign_splits(prepare(authored, snap))
    reject(schema_check(items) + validate(items, snap, ROOT))
    if not args.dry_run:
        write_json(public / "candidates.json", items, immutable=True)
        if not (public / "items.json").exists():
            write_json(public / "items.json", items, immutable=True)
        else:
            retained = read_json(public / "items.json")
            if [content_hash(i) for i in retained] != [content_hash(i) for i in items]:
                raise ValueError("retained items differ from frozen authoring; use a new version")
        write_json(manifest / "generation.json", {
            "schema_version": "qcb.generation.v1", "snapshot_id": snap["snapshot_id"],
            "method": "curated-original-source-inspected-fixture", "model_validation": False,
            "seed": 0, "items": [i["id"] for i in items], "authoring_hash": digest(authored),
            "calls": 0, "tokens": None, "cost_usd": 0, "elapsed_seconds": None,
            "limits": {"calls": 0, "spend_usd": 0}, "limit": args.limit,
            "batches": [p.name for p in sources], "superseded_candidates": sorted(superseded),
            "note": "No endpoint calls; session author/reviewer telemetry unavailable."
        }, immutable=True)
    print(json.dumps({"candidates": len(items), "dry_run": args.dry_run}))


def review_command(args):
    snap, items = load(args.version)
    reviews = read_json(args.reviews)
    records = reviews["items"]
    by_key = {i["key"]: i for i in items}
    if len({r["key"] for r in records}) != len(records):
        raise ValueError("duplicate review key")
    relative = Path(args.reviews).resolve().relative_to(ROOT).as_posix()
    artifact_hash = hashlib.sha256(Path(args.reviews).read_bytes()).hexdigest()
    for record in records:
        item = by_key[record["key"]]
        if (record.get("content_hash") != content_hash(item)
                and record.get("authored_sha256") != item.get("authored_hash")):
            raise ValueError("review content binding mismatch")
        item["reviews"] = [{**record, "content_hash": content_hash(item), "reviewer": reviews["reviewer"],
                            "method": "distinct-context-source-review", "artifact": relative,
                            "artifact_sha256": artifact_hash}]
        item["lifecycle"] = "candidate"
        item["validation"].update(nl_alignment="pending", answer_quality="pending")
        if record["verdict"] == "accept" and not item.get("formal") and not item["unresolved_issues"]:
            item["lifecycle"] = "released"
            item["validation"].update(nl_alignment="reviewed", answer_quality="reviewed")
            item["evidence_status"] = item["evidence_status"]  # source status never becomes Lean-certified
    reject(schema_check(items) + validate(items, snap, ROOT))
    # Review is a one-way admission step; immutable release is a separate export.
    manifest, public, _ = paths(args.version)
    admission = manifest / ("reviews-" + Path(args.reviews).stem + ".json")
    write_json(admission, {"artifact": relative, "sha256": artifact_hash}, immutable=True)
    write_json(public / "items.json", items)
    print(json.dumps({"released": sum(i["lifecycle"] == "released" for i in items),
                      "candidates": sum(i["lifecycle"] != "released" for i in items)}))


def validate_command(args):
    snap, items = load(args.version)
    reject(schema_check(items) + validate(items, snap, ROOT))
    print(json.dumps({"valid": len(items), "mathematical_review_not_implied": True}))


def batch_command(args):
    """Bounded full-universe triage, not fabricated per-node QA generation."""
    if not 1 <= args.batch_size <= 500:
        raise ValueError("batch-size must be 1..500")
    snap, items = load(args.version)
    state_path = BASE / ".local" / args.version / "state.json"
    state = read_json(state_path) if state_path.exists() else {
        "snapshot_id": snap["snapshot_id"], "goal_sha256": hashlib.sha256((BASE / "AGENT_GOAL.md").read_bytes()).hexdigest(),
        "objective": "Reproducible whole-graph QA with mathematical breadth, depth and Lean capability; not pilot-only.",
        "milestones": {"foundation": "implemented", "pilot": "pending", "expansion": "in_progress", "evaluation": "blocked"},
        "processed": {}, "batches": [], "complete": False}
    if state["snapshot_id"] != snap["snapshot_id"]:
        raise ValueError("resume state belongs to a different snapshot")
    if state["goal_sha256"] != hashlib.sha256((BASE / "AGENT_GOAL.md").read_bytes()).hexdigest():
        raise ValueError("implementation goal changed; explicitly migrate resume state")
    remaining = [n for n in snap["nodes"] if n["id"] not in state["processed"]]
    selected = remaining[:args.batch_size]
    supports = {n for i in items for n in i["target_nodes"] + i["supporting_nodes"]}
    for node in selected:
        state["processed"][node["id"]] = {
            "state": "candidate_pending_review" if node["id"] in supports else "blocked_by_missing_evidence",
            "reason": "Authored item exists; release ledger decides coverage." if node["id"] in supports
                      else "No source-inspected reviewed QA yet; node retained for substantive authoring."}
    if selected:
        state["batches"].append({"index": len(state["batches"]), "count": len(selected),
                                  "node_ids_hash": digest([n["id"] for n in selected])})
    state["inventory_processed"] = len(state["processed"]) == len(snap["nodes"])
    state["next_node"] = remaining[len(selected)]["id"] if len(remaining) > len(selected) else None
    state["complete"] = False  # triage completion is NOT benchmark completion
    write_json(state_path, state)
    print(json.dumps({"batch_nodes": len(selected), "processed": len(state["processed"]),
                      "total": len(snap["nodes"]), "next_node": state["next_node"], "benchmark_complete": False}))


def coverage_command(args):
    from qcb_snapshot import coverage
    snap, items = load(args.version)
    reject(schema_check(items) + validate(items, snap, ROOT))
    result = coverage(snap, items)
    _, _, reports = paths(args.version)
    write_json(reports / "coverage.json", result, immutable=True)
    print(json.dumps({k: v for k, v in result.items() if k not in {"ledger", "node_dispositions", "nodes"}})[:3500])


def export_command(args):
    snap, items = load(args.version)
    reject(schema_check(items) + validate(items, snap, ROOT))
    released = [i for i in items if i["lifecycle"] == "released"]
    manifest, public, _ = paths(args.version)
    write_json(public / "release.json", released, immutable=True)
    for setting in ["closed_book", "open_library"]:
        write_json(public / f"prompts-{setting}.json", [model_input(i, setting) for i in released], immutable=True)
    write_json(manifest / "release.json", {"schema_version": "qcb.release.v1", "snapshot_id": snap["snapshot_id"],
        "items_hash": digest(released), "ids": [i["id"] for i in released],
        "splits": {s: [i["id"] for i in released if i["split"] == s] for s in ["train", "dev", "test_public"]},
        "private_gold_published": False, "test_is_public": True, "baseline": "unmeasured",
        "license": "See dataset card; external source text not redistributed."}, immutable=True)
    print(json.dumps({"released": len(released), "public_test": True}))


def score_command(args):
    _, public, reports = paths(args.version)
    items = read_json(public / "release.json")
    result = score(items, read_json(args.predictions), read_json(args.ratings) if args.ratings else None)
    if args.output:
        path = Path(args.output).resolve()
        if path.is_relative_to(ROOT):
            raise ValueError("evaluation logs must be outside the tracked repository")
        write_json(path, result)
    else:
        print(json.dumps(result["by_track"], indent=2))


def verify_command(args):
    from qcb_lean import verify
    _, items = load(args.version)
    item = next(i for i in items if i["id"] == args.item)
    receipt = verify(ROOT, item, Path(args.proof).read_text(), image=args.image)
    print(json.dumps(receipt, indent=2))
    if receipt.get("status") not in {"verified", "certified"}:
        return 2


def baseline_command(args):
    from qcb_runner import run
    _, public, _ = paths(args.version)
    items = read_json(public / "release.json")
    result = run(items, read_json(args.config), args.output, ROOT,
                 authorized=args.authorized, fixture=args.fixture)
    print(json.dumps({k: v for k, v in result.items() if k not in {"predictions", "calls"}}, indent=2))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    commands = {"snapshot": snapshot_command, "generate": generate_command, "validate": validate_command,
                "review": review_command, "batch": batch_command, "coverage": coverage_command,
                "export": export_command, "score": score_command, "verify-lean": verify_command,
                "baseline": baseline_command}
    for name, function in commands.items():
        p = sub.add_parser(name)
        p.add_argument("--version", default="v0.1")
        p.set_defaults(function=function)
        if name == "generate":
            p.add_argument("--batches", nargs="*", default=[])
            p.add_argument("--limit", type=int, default=0)
            p.add_argument("--dry-run", action="store_true")
        if name == "review":
            p.add_argument("--reviews", required=True)
        if name == "batch":
            p.add_argument("--batch-size", type=int, default=128)
        if name == "score":
            p.add_argument("--predictions", required=True)
            p.add_argument("--ratings")
            p.add_argument("--output")
        if name == "baseline":
            p.add_argument("--config", required=True)
            p.add_argument("--output", required=True)
            p.add_argument("--authorized", action="store_true")
            p.add_argument("--fixture", action="store_true")
        if name == "verify-lean":
            p.add_argument("--item", required=True)
            p.add_argument("--proof", required=True)
            p.add_argument("--image")
    args = parser.parse_args()
    try:
        return args.function(args) or 0
    except (ValueError, KeyError, OSError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
