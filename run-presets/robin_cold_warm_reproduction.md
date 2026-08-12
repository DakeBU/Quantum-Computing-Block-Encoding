# Preset: Robin paper reproduction

Tasks: `QBE-ROBIN-BE-COLD-001` and `QBE-ROBIN-BE-WARM-001`

Both arms encode the same frozen `Fin 8` homogeneous-Robin matrix with
`alpha = 56/3`, clean signal index zero, `epsilon = 0`, and score order

```text
(semantic tier, gate count, depth, auxiliary qubits, oracle calls).
```

The cold worktree physically removes Robin-specific Lean modules, paper notes,
old run data, and generated declaration indexes. The warm worktree retains the
paper construction and compiled Robin memory. A cross-arm comparison is invalid
if any target, projector, normalizer, tolerance, semantic tier, model, or gate
accounting convention differs.

## Reported warm replay

```bash
export CODEX_MODEL=gpt-5.6-sol
python3 tools/run_robin_repro.py prepare --arm warm --force
python3 tools/run_robin_repro.py run --arm warm --cycles 7 --minutes 100
python3 tools/run_robin_repro.py audit --arm warm
```

The recorded run used Codex CLI 0.145.0. `CODEX_MODEL` defaults to
`gpt-5.6-sol`. A provider authentication, entitlement,
or quota rejection exits with code `78`, leaves the effective cycle at its prior
value, charges zero prompt-proxy tokens, and skips the Lean gate. Re-run the same
arm after access is restored; do not reset its accepted task-local population.

The August 2026 run completed six cycles and was interrupted during cycle
seven after a repeated source-contract scan. Its accepted Lean milestones are
the fixed target equality, source transcript and layout guards, and indicator
permutation certificate. No root/export/resource point was accepted. The cold
arm is retained for a later comparison and is not part of this reported run.

## Website/API replay

Open **Run with your API** in QuantumComputinglib and choose either:

- `Robin block encoding: isolated cold start`;
- `Robin block encoding: paper-seeded warm start`.

The static page prepares the same packet. Its local companion runner invokes
`tools/run_robin_repro.py`; it does not define a second matrix or acceptance
contract. The user's API credential remains in the runner process environment.

## Result rule

The audit may report a resource point only when the named Lean root compiles,
the exporter manifest exists, and Qiskit verifies both unitarity and the clean
block. A paper oracle left as a contract, an interface-only Lean declaration,
or a finite simulator match is a partial route rather than an accepted point.
