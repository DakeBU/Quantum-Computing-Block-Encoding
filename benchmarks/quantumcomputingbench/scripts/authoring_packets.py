"""Issue bounded, resumable, source-bound mathematical authoring packets.

No endpoint calls, questions, answers or reviews are invented. Issued != covered.
Use these packets with a human/agent author, then independently review candidates.
"""
from collections import defaultdict, deque
from pathlib import Path
import argparse
import sys

B = Path(__file__).resolve().parents[1]
R = B.parents[1]
sys.path.insert(0, str(B / "src"))
sys.path.insert(0, str(B / "scripts"))
from qcb import load
from qcb_core import digest, read_json, write_json
from qcb_integrity import text_sha

KINDS = {"declaration", "module", "curriculum_chapter", "conditional_transport", "mathematical_family", "research_obligation"}


def select_nodes(snapshot, items, issued, limit):
    # Target coverage, NOT incidental support membership. Round robin across
    # source modules/planned topics prevents the first huge module taking over.
    targets = {n for i in items if i["lifecycle"] == "released" for n in i["target_nodes"]}
    buckets = defaultdict(deque)
    for n in snapshot["nodes"]:
        if n["kind"] in KINDS and n["id"] not in targets and n["id"] not in issued:
            buckets[str(n.get("source") or n["topic"])].append(n)
    chosen = []
    while buckets and len(chosen) < limit:
        for key in sorted(list(buckets)):
            chosen.append(buckets[key].popleft())
            if not buckets[key]:
                del buckets[key]
            if len(chosen) == limit:
                break
    return chosen


def packet(snapshot, node, root=R):
    root = Path(root).resolve()
    source = node.get("source")
    source_path = (root / source).resolve() if source else None
    excerpt = None
    if source_path and source_path.is_relative_to(root) and source_path.is_file():
        lines = source_path.read_text(encoding="utf-8").splitlines()
        start = max(0, int(node.get("line") or 1) - 15)
        excerpt = {"path": source, "sha256": text_sha(source_path), "start_line": start + 1,
                   "text": "\n".join(lines[start:start + 110]),
                   "scope": "bounded discovery excerpt, NOT guaranteed complete type/proof/context; inspect full source before authoring"}
    return {"snapshot_id": snapshot["snapshot_id"], "target": node, "source_packet": excerpt,
        "structural_relations": [e for e in snapshot["edges"] if node["id"] in {e["source"], e["target"]}],
        "conditional_hyperedges": [h for h in snapshot["hyperedges"] if h["id"] == node["id"]
                                   or node["id"] in h.get("tails", []) + h.get("heads", [])],
        "author_contract": ["Read complete target type, definitions, proof and source boundaries, not only the excerpt.",
            "Propose original knowledge, application, missing-hypothesis/counterexample and genuine multi-step questions when supported.",
            "Do not infer theorem dependency/depth from imports, ownership, lexical hints or conceptual Hypergraph transports.",
            "Keep every AND premise, phase/register convention, resource tier and planned/open evidence boundary.",
            "Author candidate JSON with source hashes and exact step-to-node mappings; no padding or trivial file-name recall.",
            "A compiler-valid proof is not independent NL alignment or a universally correct PRM reward.",
            "Do not fetch/pay/call models or execute generated Lean without separately approved bounds/isolation.",
            "Keep pending authoring, reference checking, independent review, release and coverage as separate states."],
        "questions_authored": 0, "review_performed": False, "released_coverage_added": 0}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--version", default="release-v3")
    p.add_argument("--batch-size", type=int, default=8)
    args = p.parse_args()
    if not 1 <= args.batch_size <= 32:
        raise ValueError("batch-size must be 1..32; these are source-reading packets, not a QA count target")
    snap, items = load(args.version)
    directory = B / ".local" / args.version / "authoring"
    state_path = directory / "state.json"
    state = read_json(state_path) if state_path.exists() else {
        "snapshot_id": snap["snapshot_id"], "issued": [], "batches": [], "benchmark_complete": False}
    if state["snapshot_id"] != snap["snapshot_id"]:
        raise ValueError("snapshot changed; explicitly migrate or choose a new version")
    chosen = select_nodes(snap, items, set(state["issued"]), args.batch_size)
    if not chosen:
        print({"remaining_packets": 0, "benchmark_complete": False})
        return
    records = [packet(snap, n) for n in chosen]
    name = f"batch-{len(state['batches']):04d}.json"
    write_json(directory / name, records, immutable=True)
    state["issued"] += [n["id"] for n in chosen]
    state["batches"].append({"file": name, "packets_hash": digest(records)})
    write_json(state_path, state)
    print({"source_packets_issued": len(records), "file": str(directory / name),
           "questions_generated": 0, "benchmark_complete": False})


if __name__ == "__main__":
    main()
