#!/usr/bin/env python3
"""Run the current-checkout Lean gates and write publication evidence."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def run(command: list[str]) -> None:
    print("+", " ".join(command), flush=True)
    subprocess.run(command, cwd=ROOT, check=True)


def capture(command: list[str]) -> str:
    return subprocess.run(
        command,
        cwd=ROOT,
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "_out" / "lean-gate.json",
    )
    args = parser.parse_args()
    if args.output.exists():
        args.output.unlink()

    run(["lake", "build"])
    run(["lake", "build", "Tests"])

    report = {
        "schemaVersion": 1,
        "passed": True,
        "commit": capture(["git", "rev-parse", "HEAD"]),
        "leanVersion": capture(["lake", "env", "lean", "--version"]).splitlines()[0],
        "commands": ["lake build", "lake build Tests"],
        "completedAtUtc": dt.datetime.now(dt.timezone.utc).isoformat(),
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(report, indent=2) + "\n", encoding="utf-8", newline="\n"
    )
    print(f"wrote Lean gate report: {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

