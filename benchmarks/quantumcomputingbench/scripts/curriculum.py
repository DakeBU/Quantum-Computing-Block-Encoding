#!/usr/bin/env python3
"""Inspect/export the shared textbook registry and check compatible proposals."""
import argparse
import json
from pathlib import Path
import sys

B = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(B / "src"))
from qcb_core import read_json, write_json
from qcb_curriculum import load_catalog, summary, validate_proposals


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["validate", "export", "stable-check"])
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    try:
        catalog, _, graph = load_catalog()
        proposals = [read_json(path) for track in ["non-lean", "lean"]
                     for path in sorted((B / "tracks" / track / "proposals").glob("*.json"))]
        for proposal in proposals:
            if any(node not in graph for node in proposal.get("source_nodes", [])):
                raise ValueError("proposal uses an unknown graph/source identity")
        validate_proposals(catalog, proposals)
        result = summary(catalog)
        if args.command == "export":
            if not args.output:
                raise ValueError("--output is required; generated exports do not replace frozen source data")
            write_json(args.output, catalog)
        print(json.dumps(result, indent=2))
        if args.command == "stable-check" and not result["stable_readiness"]["stable"]:
            return 2
        return 0
    except (KeyError, ValueError, OSError) as error:
        print("ERROR: " + str(error), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
