#!/usr/bin/env python3
"""Snapshot, reject, and undo agent mutations outside an explicit allowlist."""

from __future__ import annotations

import argparse
import base64
import hashlib
import json
import os
import shutil
import subprocess
from pathlib import Path


def status_paths(raw: bytes) -> dict[str, str]:
    entries: dict[str, str] = {}
    fields = raw.split(b"\0")
    index = 0
    while index < len(fields):
        field = fields[index]
        index += 1
        if not field:
            continue
        text = field.decode("utf-8", errors="replace")
        status = text[:2]
        path = text[3:]
        if status[0] in {"R", "C"} and index < len(fields):
            index += 1  # The second path is the rename/copy source.
        entries[path] = status
    return entries


def allowed(path: str, prefixes: tuple[str, ...]) -> bool:
    normalized = path.replace(os.sep, "/").lstrip("./")
    for prefix in prefixes:
        clean = prefix.replace(os.sep, "/").lstrip("./")
        if clean.endswith("*"):
            if normalized.startswith(clean[:-1]):
                return True
        elif clean.endswith("/"):
            if normalized.startswith(clean):
                return True
        elif normalized == clean:
            return True
    return False


def git_status(root: Path) -> dict[str, str]:
    raw = subprocess.check_output(
        ["git", "status", "--porcelain=v1", "-z", "--untracked-files=all"],
        cwd=root,
    )
    return status_paths(raw)


def fingerprint(path: Path) -> str:
    if path.is_symlink():
        return "symlink:" + os.readlink(path)
    if not path.exists():
        return "missing"
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return "sha256:" + digest.hexdigest()


def snapshot(root: Path) -> dict[str, dict[str, str]]:
    entries: dict[str, dict[str, str]] = {}
    for path, status in git_status(root).items():
        target = root / path
        entry = {"status": status, "fingerprint": fingerprint(target)}
        if target.is_symlink():
            entry.update(kind="symlink", data=os.readlink(target))
        elif target.is_file():
            entry.update(
                kind="file",
                data=base64.b64encode(target.read_bytes()).decode("ascii"),
            )
        else:
            entry.update(kind="missing", data="")
        entries[path] = entry
    return entries


def restore_violation(
    root: Path, path: str, status: str, prior: dict[str, str] | None
) -> None:
    target = root / path
    if prior:
        kind = prior.get("kind")
        if target.is_dir() and not target.is_symlink():
            shutil.rmtree(target)
        elif target.exists() or target.is_symlink():
            target.unlink()
        if kind == "file":
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(base64.b64decode(prior.get("data", "")))
        elif kind == "symlink":
            target.parent.mkdir(parents=True, exist_ok=True)
            target.symlink_to(prior.get("data", ""))
        return
    if status == "??":
        if target.is_dir() and not target.is_symlink():
            shutil.rmtree(target)
        elif target.exists() or target.is_symlink():
            target.unlink()
    else:
        subprocess.run(
            ["git", "restore", "--worktree", "--", path],
            cwd=root,
            check=True,
        )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    snapshot_parser = subparsers.add_parser("snapshot")
    snapshot_parser.add_argument("--root", type=Path, required=True)
    snapshot_parser.add_argument("--output", type=Path, required=True)
    check_parser = subparsers.add_parser("check")
    check_parser.add_argument("--root", type=Path, required=True)
    check_parser.add_argument("--before", type=Path, required=True)
    check_parser.add_argument("--allow", action="append", default=[])
    check_parser.add_argument(
        "--atomic",
        action="store_true",
        help="revert every mutation made since the snapshot when any path is out of scope",
    )
    args = parser.parse_args()
    root = args.root.resolve()

    if args.command == "snapshot":
        args.output.write_text(
            json.dumps({"entries": snapshot(root)}, sort_keys=True) + "\n",
            encoding="utf-8",
        )
        return 0

    before = json.loads(args.before.read_text(encoding="utf-8")).get("entries", {})
    after_status = git_status(root)
    prefixes = tuple(value for value in args.allow if value)
    changed: list[tuple[str, str]] = []
    for path in sorted(set(before) | set(after_status)):
        status = after_status.get(path, "")
        current = {"status": status, "fingerprint": fingerprint(root / path)}
        prior = before.get(path)
        prior_signature = (
            {"status": prior.get("status"), "fingerprint": prior.get("fingerprint")}
            if prior
            else None
        )
        if prior_signature != current:
            changed.append((path, status))
    violations = [entry for entry in changed if not allowed(entry[0], prefixes)]
    if not violations:
        return 0

    reverted = changed if args.atomic else violations
    for path, status in reverted:
        restore_violation(root, path, status, before.get(path))
    label = "agent transaction" if args.atomic else "files"
    print(f"mutation scope violation; reverted {label}:")
    for path, _status in reverted:
        print(f"- {path}")
    return 79


if __name__ == "__main__":
    raise SystemExit(main())
