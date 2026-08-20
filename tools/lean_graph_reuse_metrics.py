#!/usr/bin/env python3
"""Read-only reuse metrics for the generated ASPBE Lean graph.

The current public graph contains module import edges and module-to-declaration
containment. These metrics therefore describe library/module factorization, not
theorem-level proof-term compression.
"""

from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path


BARREL_SOURCES = {"QuantumBlockEncoding.lean"}


def _module_subgraph(payload: dict[str, object]):
    modules = {
        str(node["id"]): node
        for node in payload.get("nodes", [])
        if node.get("type") == "module"
        and str(node.get("source", "")) not in BARREL_SOURCES
    }
    succ: dict[str, set[str]] = {node_id: set() for node_id in modules}
    pred: dict[str, set[str]] = {node_id: set() for node_id in modules}
    for edge in payload.get("edges", []):
        if edge.get("type") != "module-supports-importer":
            continue
        source = str(edge.get("source", ""))
        target = str(edge.get("target", ""))
        if source in modules and target in modules:
            succ[source].add(target)
            pred[target].add(source)
    return modules, succ, pred


def _support_set(target: str, pred: dict[str, set[str]]) -> set[str]:
    seen: set[str] = set()
    stack = [target]
    while stack:
        current = stack.pop()
        if current in seen:
            continue
        seen.add(current)
        stack.extend(pred.get(current, ()))
    return seen


def _safe_ratio(num: int | float, den: int | float) -> float:
    return float(num) / float(den) if den else 0.0


def compute_metrics(payload: dict[str, object]) -> dict[str, object]:
    modules, succ, pred = _module_subgraph(payload)
    frontier = sorted(node for node in modules if not succ[node])
    supports = {target: _support_set(target, pred) for target in frontier}

    reuse: Counter[str] = Counter()
    for support in supports.values():
        reuse.update(support)

    used_nodes = set(reuse)
    expanded = sum(len(support) for support in supports.values())
    unique = len(used_nodes)
    shared_nodes = {node for node, count in reuse.items() if count >= 2}
    exclusive_nodes = {node for node, count in reuse.items() if count == 1}
    reuse_excess = expanded - unique

    direct_fanout = {node: len(succ[node]) for node in modules}
    direct_shared = {node for node, fanout in direct_fanout.items() if fanout >= 2}

    histogram = Counter(reuse.values())
    top_reused = sorted(
        (
            {
                "id": node,
                "source": str(modules[node].get("source", "")),
                "label": str(
                    modules[node].get("label", modules[node].get("fullName", node))
                ),
                "targetReuse": int(count),
                "directFanout": int(direct_fanout[node]),
            }
            for node, count in reuse.items()
        ),
        key=lambda item: (-item["targetReuse"], -item["directFanout"], item["id"]),
    )[:20]

    return {
        "schemaVersion": 1,
        "evidenceClass": "module-import-proxy",
        "warning": (
            "These are non-lossy measurements of the generated module import DAG. "
            "They are not theorem-level proof-term dependency or proof-compression metrics."
        ),
        "scope": {
            "barrelSourcesExcluded": sorted(BARREL_SOURCES),
            "moduleCount": len(modules),
            "importEdgeCount": sum(len(targets) for targets in succ.values()),
            "frontierTargetCount": len(frontier),
        },
        "factorization": {
            "uniqueSupportNodes": unique,
            "expandedSupportIncidences": expanded,
            "supportSharingFactor": _safe_ratio(expanded, unique),
            "reuseExcess": reuse_excess,
            "reuseGainFraction": _safe_ratio(reuse_excess, expanded),
            "sharedSupportNodeCount": len(shared_nodes),
            "exclusiveSupportNodeCount": len(exclusive_nodes),
            "sharedSupportCoverage": _safe_ratio(len(shared_nodes), unique),
            "meanTargetReusePerSupportNode": _safe_ratio(expanded, unique),
            "meanTargetReuseAmongSharedNodes": _safe_ratio(
                sum(reuse[node] for node in shared_nodes), len(shared_nodes)
            ),
            "maxTargetReuse": max(reuse.values(), default=0),
        },
        "directReuse": {
            "directSharedModuleCount": len(direct_shared),
            "directSharedCoverage": _safe_ratio(len(direct_shared), len(modules)),
            "directReuseExcess": sum(
                max(fanout - 1, 0) for fanout in direct_fanout.values()
            ),
            "maxDirectFanout": max(direct_fanout.values(), default=0),
        },
        "reuseHistogram": {
            str(reuse_count): node_count
            for reuse_count, node_count in sorted(histogram.items())
        },
        "topReusedModules": top_reused,
    }


def _toy_payload() -> dict[str, object]:
    # a -> b -> d
    # a -> c -> e
    # b -> e
    # Frontier targets d,e share a,b.
    nodes = [
        {
            "id": f"module:{name}",
            "type": "module",
            "source": f"{name}.lean",
            "label": name,
        }
        for name in "abcde"
    ]
    edges = [("a", "b"), ("a", "c"), ("b", "d"), ("b", "e"), ("c", "e")]
    return {
        "nodes": nodes,
        "edges": [
            {
                "id": f"{left}-{right}",
                "source": f"module:{left}",
                "target": f"module:{right}",
                "type": "module-supports-importer",
            }
            for left, right in edges
        ],
    }


def self_test() -> None:
    metrics = compute_metrics(_toy_payload())
    assert metrics["scope"]["frontierTargetCount"] == 2
    # d support = {a,b,d}; e support = {a,b,c,e}
    assert metrics["factorization"]["expandedSupportIncidences"] == 7
    assert metrics["factorization"]["uniqueSupportNodes"] == 5
    assert metrics["factorization"]["reuseExcess"] == 2
    assert metrics["factorization"]["sharedSupportNodeCount"] == 2
    assert metrics["factorization"]["maxTargetReuse"] == 2


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "graph",
        nargs="?",
        type=Path,
        default=Path("_site/data/lean-graph.json"),
        help="generated lean-graph.json",
    )
    parser.add_argument("--output", type=Path)
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()

    if args.self_test:
        self_test()
        print("lean-graph reuse metric self-test: ok")
        return

    payload = json.loads(args.graph.read_text(encoding="utf-8"))
    metrics = compute_metrics(payload)
    rendered = json.dumps(metrics, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered, encoding="utf-8")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
