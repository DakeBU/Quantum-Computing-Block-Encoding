#!/usr/bin/env python3
"""Process-safe runtime primitives for the ABEIS harness.

The proof controller is intentionally plain-file based.  These helpers keep
that design while making shared JSON, JSONL, Markdown, and Lean-adjacent writes
safe when separate screens or agent processes operate concurrently.
"""

from __future__ import annotations

import contextlib
import hashlib
import json
import os
import tempfile
import threading
import time
from pathlib import Path
from typing import Callable, Iterator, Mapping


class LockUnavailable(RuntimeError):
    """Raised when a non-blocking or timed task lease cannot be acquired."""


_THREAD_LOCKS: dict[str, threading.RLock] = {}
_THREAD_LOCKS_GUARD = threading.Lock()


def canonical_path(path: Path) -> Path:
    """Resolve aliases without requiring the target to exist."""

    return path.expanduser().resolve(strict=False)


def lock_path_for(path: Path, *, lock_root: Path | None = None) -> Path:
    canonical = canonical_path(path)
    root = lock_root
    if root is None:
        for parent in (canonical.parent, *canonical.parents):
            if (parent / ".qbe").is_dir():
                root = parent / ".qbe" / "locks"
                break
    if root is None:
        root = canonical.parent / ".qbe-locks"
    digest = hashlib.sha256(os.fsencode(str(canonical))).hexdigest()
    return canonical_path(root) / f"{digest}.lock"


def _thread_lock(path: Path) -> threading.RLock:
    key = str(canonical_path(path))
    with _THREAD_LOCKS_GUARD:
        return _THREAD_LOCKS.setdefault(key, threading.RLock())


def _try_os_lock(handle: object, *, blocking: bool) -> bool:
    if os.name == "nt":
        import msvcrt

        handle.seek(0)
        if handle.read(1) == "":
            handle.write("0")
            handle.flush()
        handle.seek(0)
        mode = msvcrt.LK_LOCK if blocking else msvcrt.LK_NBLCK
        try:
            msvcrt.locking(handle.fileno(), mode, 1)
            return True
        except OSError:
            return False

    import fcntl

    flags = fcntl.LOCK_EX | (0 if blocking else fcntl.LOCK_NB)
    try:
        fcntl.flock(handle.fileno(), flags)
        return True
    except BlockingIOError:
        return False


def _os_unlock(handle: object) -> None:
    if os.name == "nt":
        import msvcrt

        handle.seek(0)
        msvcrt.locking(handle.fileno(), msvcrt.LK_UNLCK, 1)
        return

    import fcntl

    fcntl.flock(handle.fileno(), fcntl.LOCK_UN)


@contextlib.contextmanager
def file_lock(
    path: Path,
    *,
    lock_root: Path | None = None,
    timeout: float | None = None,
    poll_interval: float = 0.05,
) -> Iterator[Path]:
    """Serialize access to one canonical path across threads and processes.

    ``timeout=None`` blocks.  ``timeout=0`` is a non-blocking task lease.
    Kernel locks are released when a process exits, including after SIGKILL,
    so an abandoned screen cannot leave a stale ownership record.
    """

    canonical = canonical_path(path)
    thread_lock = _thread_lock(canonical)
    if timeout is None:
        acquired_thread = thread_lock.acquire()
    else:
        acquired_thread = thread_lock.acquire(timeout=max(0.0, timeout))
    if not acquired_thread:
        raise LockUnavailable(f"lock is busy: {canonical}")

    lock_path = lock_path_for(canonical, lock_root=lock_root)
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    handle = None
    try:
        handle = lock_path.open("a+", encoding="ascii")
        if timeout is None:
            if not _try_os_lock(handle, blocking=True):
                raise LockUnavailable(f"could not acquire lock: {canonical}")
        else:
            deadline = time.monotonic() + max(0.0, timeout)
            while not _try_os_lock(handle, blocking=False):
                if time.monotonic() >= deadline:
                    raise LockUnavailable(f"lock is busy: {canonical}")
                time.sleep(max(0.001, poll_interval))
        yield canonical
    finally:
        if handle is not None:
            try:
                _os_unlock(handle)
            except OSError:
                pass
            handle.close()
        thread_lock.release()


def _replace_text_unlocked(path: Path, text: str, *, encoding: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    mode = None
    try:
        mode = path.stat().st_mode & 0o777
    except OSError:
        pass
    fd, temporary_name = tempfile.mkstemp(prefix=f".{path.name}.", suffix=".tmp", dir=path.parent)
    temporary = Path(temporary_name)
    try:
        with os.fdopen(fd, "w", encoding=encoding, newline="") as handle:
            handle.write(text)
            handle.flush()
            os.fsync(handle.fileno())
        if mode is not None:
            os.chmod(temporary, mode)
        os.replace(temporary, path)
    finally:
        try:
            temporary.unlink()
        except FileNotFoundError:
            pass


def atomic_write_text(path: Path, text: str, *, encoding: str = "utf-8") -> None:
    path = canonical_path(path)
    with file_lock(path):
        _replace_text_unlocked(path, text, encoding=encoding)


def update_text_locked(
    path: Path,
    update: Callable[[str], str],
    *,
    encoding: str = "utf-8",
) -> str:
    """Apply one read-modify-write transaction under the canonical file lock."""

    path = canonical_path(path)
    with file_lock(path):
        previous = path.read_text(encoding=encoding) if path.exists() else ""
        current = update(previous)
        _replace_text_unlocked(path, current, encoding=encoding)
        return current


def write_text_exclusive(path: Path, text: str, *, encoding: str = "utf-8") -> None:
    path = canonical_path(path)
    with file_lock(path):
        if path.exists():
            raise FileExistsError(path)
        _replace_text_unlocked(path, text, encoding=encoding)


def write_text_if_missing(path: Path, text: str, *, encoding: str = "utf-8") -> bool:
    path = canonical_path(path)
    with file_lock(path):
        if path.exists():
            return False
        _replace_text_unlocked(path, text, encoding=encoding)
        return True


def append_text_locked(path: Path, text: str, *, encoding: str = "utf-8") -> None:
    path = canonical_path(path)
    with file_lock(path):
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open("a", encoding=encoding, newline="") as handle:
            handle.write(text)
            handle.flush()
            os.fsync(handle.fileno())


def atomic_write_json(path: Path, payload: object) -> None:
    atomic_write_text(path, json.dumps(payload, indent=2, sort_keys=True) + "\n")


def update_json_locked(
    path: Path,
    update: Callable[[dict[str, object]], dict[str, object]],
) -> dict[str, object]:
    """Apply a JSON-object read-modify-write transaction under one lock."""

    path = canonical_path(path)
    with file_lock(path):
        previous: dict[str, object] = {}
        if path.exists():
            try:
                loaded = json.loads(path.read_text(encoding="utf-8"))
                if isinstance(loaded, dict):
                    previous = loaded
            except (OSError, json.JSONDecodeError):
                previous = {}
        current = update(previous)
        _replace_text_unlocked(
            path,
            json.dumps(current, indent=2, sort_keys=True) + "\n",
            encoding="utf-8",
        )
        return current


def append_jsonl_locked(path: Path, record: Mapping[str, object]) -> None:
    append_text_locked(
        path,
        json.dumps(dict(record), sort_keys=True, ensure_ascii=False) + "\n",
    )


def semantic_route_fingerprint(record: Mapping[str, object]) -> str:
    """Hash proof-route semantics while ignoring run IDs, prose, and roles."""

    feedback_raw = record.get("verifier_feedback", {})
    feedback = feedback_raw if isinstance(feedback_raw, Mapping) else {}

    def clean(value: object) -> object:
        if isinstance(value, str):
            return " ".join(value.split()).lower()
        if isinstance(value, (list, tuple)):
            return [clean(item) for item in value]
        return value

    route_fields = {
        "leaf_signature": record.get("leaf_signature") or feedback.get("leaf_signature"),
        "evidence_digest": record.get("evidence_digest") or feedback.get("evidence_digest"),
        "ready_leaf_ids": record.get("ready_leaf_ids"),
        "leaf": feedback.get("leaf"),
        "error_class": feedback.get("error_class"),
        "missing_dependency": feedback.get("missing_dependency"),
        "target_declaration_hash": feedback.get("target_declaration_hash"),
        "contract_hash": feedback.get("contract_hash"),
        "dimensions": feedback.get("dimensions"),
        "register_order": feedback.get("register_order"),
        "alpha": feedback.get("alpha"),
        "search_phase": record.get("search_phase") or feedback.get("search_phase"),
        "epsilon": record.get("effective_epsilon") or feedback.get("requested_epsilon"),
        "candidate_family": feedback.get("candidate_family"),
    }
    compact = {key: clean(value) for key, value in route_fields.items() if value not in (None, "", [], ())}
    if not compact:
        return ""
    payload = {
        "schema": 1,
        "task_id": clean(record.get("task_id", "")),
        "route": compact,
    }
    return hashlib.sha256(
        json.dumps(payload, sort_keys=True, separators=(",", ":"), ensure_ascii=True).encode("utf-8")
    ).hexdigest()
