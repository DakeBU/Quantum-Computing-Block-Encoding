# Windows runtime compatibility

The local harness runs with the repository's Python environment. This change
addresses reproducible Windows file-sharing failures without changing proof
targets, acceptance rules, controller decisions, or the JSON/JSONL formats.

## Failures and fixes

`tools/qbe_runtime.py` previously read and initialized the first byte of its
lock file before acquiring the operating-system lock. On Windows, another
process can already hold that byte range, so the read itself raises
`PermissionError`. The lock now acquires the byte range directly. Windows
allows a byte-range lock beyond the current end of a file; a marker byte is
unnecessary. The existing concurrent-process and lease tests exercise this
behavior on Windows, including a newly created empty lock file.

Windows can also temporarily deny an atomic file replacement while a reader
or scanner holds an incompatible sharing handle. The replacement helper now
retries `os.replace` for Windows errors 5, 32, and 33, sleeping 10 milliseconds
between attempts and stopping after a two-second deadline. It retains atomic
replacement throughout: it never truncates the destination, deletes it first,
or falls back to a partial write. Other errors propagate immediately. A
persistent sharing or access failure still fails the write after the deadline.

The concurrent JSON observer test similarly retries a brief Windows access
failure. It still parses every successful read and requires observations while
writers are active. Malformed or partial JSON remains a failure. Child
processes are reaped even if an assertion fails.

The mutation-scope CLI tests now launch the interpreter already running the
tests, using `sys.executable`. This avoids depending on the optional `python3`
command alias and ensures child commands use the same environment.

`tools/replay_public_cases.py` likewise launches its six Python subprocesses
with `sys.executable`. Its command records retain the portable name `python3`,
so publication artifacts do not embed the environment's absolute executable
path. `tools/test_replay_public_cases.py` checks both the actual invocation and
the portable record, including preservation of failure exit codes.

Windows virtual-environment Python uses a launcher process. Its process ID can
differ from the Python process that actually holds a file lock. The two
kill/recovery tests now obtain the holder's PID directly from their own child
program and terminate that holder, then wait for the launcher to exit. This
tests kernel-lock recovery rather than accidentally leaving a child alive
after terminating only its launcher. Cleanup also runs if the duplicate-lease
assertion fails.

## Verification

Run from the repository root:

```powershell
.\.venv\Scripts\python.exe -m unittest tools.test_qbe_runtime tools.test_enforce_mutation_scope
.\.venv\Scripts\python.exe tools/qbe.py harness-check
.\.venv\Scripts\python.exe -m unittest tools.test_replay_public_cases
.\.venv\Scripts\python.exe tools/replay_public_cases.py
```

The scoped suite covers concurrent JSONL appends, atomic JSON writes, lossless
read-modify-write transactions, rejection of duplicate task dispatch,
recovery after a lock holder is killed, mutation rollback, and preservation of
pre-existing human changes. Additional deterministic tests verify transient
replacement recovery, bounded permanent failure, and immediate propagation of
unclassified permission errors.

The scoped run passed 18 tests. The complete harness, run with the repository
virtual environment, passed 81 tests in 17.909 seconds. Each suite has one
Windows symlink-privilege skip that predates this change; no new skips or
weakened proof gates were introduced.

The two public-replay interpreter tests also passed. A full public replay with
Lean enabled then passed the Lean module build, population-controller replay,
and all six published case groups (textbook preparation, both BE Case 1 arms,
both BE Case 2 arms, and Robin XOR four-slot T3). The resulting public JSON was
checked for workstation-path leakage.

If Git needs an ownership exception for this checkout, pass it only in the
invoking process configuration. Do not commit workstation-specific paths or
change a user's global Git configuration as part of these fixes.

## Boundaries and rollback

The retry policy addresses brief sharing conflicts, not broken filesystem
permissions or indefinitely held handles. The existing `timeout=None` lease
implementation still uses the Windows CRT's blocking-lock operation, whose
own retry window is bounded. This change does not claim to alter that timeout
policy.

The changes are confined to `tools/qbe_runtime.py`, its regression tests, and
the interpreter selection in `tools/test_enforce_mutation_scope.py`. They add
no persistent schema or migration. Reverting this patch restores the previous
implementation without rewriting historical runs or acceptance records; the
Windows failures described above would return. Keep the concurrency tests
when evaluating any alternative lock or replacement implementation.
## Blueprint search-asset compatibility

The pinned Verso revision serializes native Windows backslashes in embedded
search resource names, but removes a forward-slash-only prefix. The resulting
parent-directory segments made actual final resource emission fail after the
whole book had been traversed. This is a renderer defect, not a Lean theorem
failure or an absent source resource.

`tools/apply_verso_windows_compat.py` applies one checked separator-normalization
line to the exact pinned Verso search module on Windows. It does nothing on
Linux/macOS and rejects unknown revisions, source patterns, symlinks/reparse
points, or concurrent edits. Lean, Mathlib, scientific targets and verification
rules are untouched. The patch is reproduced by both Blueprint entry points;
it is not an unrecorded dependency edit.

`scripts/CheckBlueprintSearchAssets.lean` validates resource names, invokes the
actual Verso search emitter and compares emitted bytes before full rendering.
Both native Windows and canonical shell publication paths retain every real
proof, executable and final-site check. No archive-transport success substitutes
for those checks.
