# Conversion Window: Passive-State Lift for Optimal-Control $E_1$

Task id: `QBE-OP-OPTCTRL-001`
Mode: `operatorBlockEncoding`
Updated: `2026-06-19 02:55`

This window translates the user-specified operator
$E_k := |0\rangle\langle k|_\mathrm{time} \otimes
|0\rangle\langle 1|_\mathrm{type} \otimes I_\mathrm{state}$ into the next
Lean-facing contract.  There is no local paper-source archive for this task, so
the source anchor is the task text and the public operator formula above.

## Current Scope

The compiled concrete champion is the `r = 1`, `k = 1` logical reversible
construction

```text
Layer 1: CCX(type,time;aux)
Layer 2: X(type), X(time), X(aux)
```

with Lean reduced bit order `bit 0 = type`, `bit 1 = time`,
`bit 2 = auxiliary`.  The current Lean file proves this for one passive state
bit.  The active leaf is to replace the hard-coded passive dimension `2` by an
arbitrary positive passive dimension while preserving the same active reduced
map and the same logical score `(4, 2, 1, 0)`.

This is not a new approximate-search cycle and not a hardware decomposition
cycle.  The exact normalizer remains `alpha = 1`, and the signal auxiliary
count remains `a = 1`.

## Symbol Map

| Source symbol | Meaning | Lean name | Type / role | Status |
|---|---|---|---|---|
| $E_1$ | target $|0\rangle\langle 1|_\mathrm{time} \otimes |0\rangle\langle 1|_\mathrm{type} \otimes I_\mathrm{state}$ | `OptimalControl.exampleOperator` | current concrete `Matrix 8 8 Rat` | proved for `stateDim = 2` |
| $d$ | passive state dimension | planned `stateDim` or `d.succ` parameter | positive natural dimension | active leaf |
| active system branch | pair `(type,time)` encoded as `type + 2 * time` | planned quotient part of `Fin (4 * stateDim)` | branch in `Fin 4` | active leaf |
| passive state index | identity factor index | planned remainder part of `Fin (4 * stateDim)` | element of `Fin stateDim` | active leaf |
| $E_1 \otimes I_d$ | generalized target matrix | planned `passiveTargetOperator` | `Matrix (4 * stateDim) (4 * stateDim) Rat` | active leaf |
| clean signal embedding | embed system basis into auxiliary-zero full basis | planned `passiveCleanIndex` | `Fin (4 * stateDim) -> Fin (8 * stateDim)` | active leaf |
| reduced active unitary | compiled active map | `OptimalControl.evolvedEqFlipImage` | `Fin 8 -> Fin 8` | proved |
| lifted image | apply reduced map and preserve passive state index | planned `liftReducedImagePassive` | `Fin 8 -> Fin 8`, lifted to `Fin (8 * stateDim)` | active leaf |
| $U$ | permutation matrix induced by lifted image | planned `unitaryFromReducedImagePassive` | `Matrix (8 * stateDim) (8 * stateDim) Rat` | active leaf |
| clean block | exact block-entry equality | planned `CleanBlockE1Passive` | proposition | active leaf |
| score | logical reversible resource tuple | `OptimalControl.evolvedEqFlipCandidate_cost` and planned passive score lemma | `(4, 2, 1, 0)` | concrete proved; passive lift pending |

## Register Layout

For passive dimension `stateDim > 0`, use these quotient/remainder layouts.

| Space | Dimension | Encoding |
|---|---:|---|
| system | `4 * stateDim` | `stateDim * (type + 2 * time) + s` |
| full one-ancilla space | `8 * stateDim` | `stateDim * (type + 2 * time + 4 * aux) + s` |
| clean block | first `4 * stateDim` rows and columns | `aux = 0` |

The generalized target has entry `1` exactly when the row has active system
branch `0`, the column has active system branch `3`, and both have the same
passive state index.  Every other entry is `0`.

## Lean Contract

Lower Lean work should introduce the smallest reusable surface needed for the
passive-state lift.  Suggested names may be adjusted to match local style, but
do not duplicate the existing concrete declarations.

```lean
def passiveTargetOperator (stateDim : Nat) [NeZero stateDim] :
    Matrix (4 * stateDim) (4 * stateDim) Rat := ...

def passiveCleanIndex (stateDim : Nat) [NeZero stateDim] :
    Fin (4 * stateDim) -> Fin (8 * stateDim) := ...

def passiveActiveOfSystem (stateDim : Nat) [NeZero stateDim] :
    Fin (4 * stateDim) -> Fin 4 := ...

def passiveStateOfSystem (stateDim : Nat) [NeZero stateDim] :
    Fin (4 * stateDim) -> Fin stateDim := ...

def activeOfFullPassive (stateDim : Nat) [NeZero stateDim] :
    Fin (8 * stateDim) -> Fin 8 := ...

def stateOfFullPassive (stateDim : Nat) [NeZero stateDim] :
    Fin (8 * stateDim) -> Fin stateDim := ...

def liftReducedImagePassive (stateDim : Nat) [NeZero stateDim]
    (f : Fin 8 -> Fin 8) : Fin (8 * stateDim) -> Fin (8 * stateDim) := ...

def unitaryFromReducedImagePassive (stateDim : Nat) [NeZero stateDim]
    (f : Fin 8 -> Fin 8) : Matrix (8 * stateDim) (8 * stateDim) Rat := ...

def CleanBlockE1Passive (stateDim : Nat) [NeZero stateDim]
    (f : Fin 8 -> Fin 8) : Prop := ...

theorem evolvedEqFlipPassive_cleanBlock (stateDim : Nat) [NeZero stateDim] :
    CleanBlockE1Passive stateDim evolvedEqFlipImage := ...
```

If `[NeZero stateDim]` causes quotient/remainder friction, the fallback is to
parameterize by `d : Nat` and use passive dimension `d + 1`.  Lower agents must
record that choice in this window before broad proof search.

## Proof Map

1. Define the quotient/remainder views for system and full indices.  The
   reusable arithmetic fact is that every full index decomposes as
   `stateDim * active + passive` with active part below `8` and passive part
   below `stateDim`.
2. Define the target matrix by active system branch and passive equality:
   branch `3` maps to branch `0`, and the passive index is unchanged.
3. Define the lifted image by applying `evolvedEqFlipImage` to the active
   reduced branch and preserving the passive remainder.
4. Prove the branch table for clean inputs:
   `0 -> 7`, `1 -> 6`, `2 -> 5`, and `3 -> 0` under `evolvedEqFlipImage`.
   Only the source branch `3` returns to a clean branch.
5. Use the branch table and passive preservation to prove the clean block:
   the matrix entry is `1` exactly for row branch `0`, column branch `3`, and
   equal passive index.
6. Reuse the existing circuit transcript and cost declarations to state that
   the passive lift keeps logical score `(4, 2, 1, 0)` in this semantic tier.

## Proof-DAG Frontier

| Node | Interface | Dependencies | Owner | Lean declaration | Human proof map | Local gate | Status |
|---|---|---|---|---|---|---|---|
| `root-passive-state-family-r1-k1` | exact block encoding of $E_1 \otimes I_d$ for all positive passive dimensions | `passive-target`, `passive-lift`, `passive-clean-block`, `passive-resource` | middle/reviewer | planned theorem packaging after leaves | this window | `python3 tools/qbe.py check` | active root |
| `active-reduced-circuit` | reduced circuit `CCX; X(type); X(time); X(aux)` implements `evolvedEqFlipImage` | none | closed | `OptimalControl.evolvedEqFlipGateImages_eval` | candidate population Gen 7 | compiled gate | proved |
| `active-reduced-clean-branch` | clean active branch table sends only source branch `3` to clean target branch `0` | `active-reduced-circuit` | lower 2 | planned local lemma, or inline `native_decide` if small | Proof Map step 4 | `lake build Tests` | active leaf |
| `passive-target` | define $E_1 \otimes I_d$ on `Fin (4 * stateDim)` | quotient/remainder layout | lower 2 | planned `passiveTargetOperator` | Proof Map step 2 | `lake build Tests` | active leaf |
| `passive-lift` | lift `Fin 8 -> Fin 8` to `Fin (8 * stateDim)` while preserving passive index | quotient/remainder layout | lower 2 | planned `liftReducedImagePassive` | Proof Map step 3 | `lake build Tests` | active leaf |
| `passive-clean-block` | clean block of lifted `evolvedEqFlipImage` equals `passiveTargetOperator` | `passive-target`, `passive-lift`, `active-reduced-clean-branch` | lower 2 | planned `evolvedEqFlipPassive_cleanBlock` | Proof Map step 5 | `lake build Tests` | active leaf |
| `passive-resource` | score stays `(4, 2, 1, 0)` because the active logical circuit is unchanged | `active-reduced-circuit`, `passive-clean-block` | lower 2/reviewer | planned passive score lemma or prose obligation | Proof Map step 6 | `python3 tools/qbe.py check` | pending after clean block |
| `general-time-width` | extend from one time bit and `k = 1` to arbitrary time width and `k` | none ready | upper later | no Lean declaration | task backlog | none | stale for this cycle |
| `hardware-decomposition` | decompose logical Toffoli into selected hardware library | none ready | upper later | no Lean declaration | candidate backlog | none | stale for this cycle |

## Lower-Agent Packets

### Lower 1: Natural-Language Proof Architect

Write `proof-attempts/QBE-OP-OPTCTRL-001/passive-state-lift-lower1-dag-<timestamp>.md`.

The packet must:

- restate the quotient/remainder layout for `Fin (4 * stateDim)` and
  `Fin (8 * stateDim)`;
- prove in prose why the lifted map preserves passive indices;
- give the active clean-branch table for `evolvedEqFlipImage`;
- map each proof step to either an existing Lean declaration above or one
  planned lower-2 declaration;
- avoid hardware, approximate, and arbitrary-`k` claims.

### Lower 2: Lean Implementation Worker

Allowed write scope:

```text
QuantumBlockEncoding/OptimalControl.lean
Tests/Basic.lean
```

Implement exactly one passive-state leaf.  Prefer `passive-target` plus
`passive-lift` if the clean-block theorem is too large for one pass; otherwise
close `evolvedEqFlipPassive_cleanBlock`.  Do not modify the concrete Gen 7
theorem statements.  Run:

```bash
python3 tools/qbe.py check
```

Log typed feedback with `trial-log`, including `leaf`, `lean_parse_ok`,
`lean_build_ok`, `block_entry_ok`, `normalizer_ok`, `resource_score=(4,2,1,0)`,
`closed_theorem_ok`, `error_class`, and `next_route`.

### Lower 3: Necessary-Condition Verifier

Write `verifier-feedback/QBE-OP-OPTCTRL-001/passive-state-lift-<timestamp>.md`
or `.json`.

Check passive dimensions `1`, `2`, and `4` for the proposed layout.  The
diagnostic should verify:

- the lifted image is bijective for each checked dimension;
- the clean block has entries exactly at active branch `3 -> 0` with matching
  passive index;
- all other clean-block entries are zero;
- the resource tuple is still `(4, 2, 1, 0)`;
- any failure is classified as `shape_or_register_gap`,
  `finite_matrix_counterexample`, `symbolic_bridge_gap`, or `lean_tactic_gap`.

## Open Obligations

| Obligation | Status |
|---|---|
| General passive target $E_1 \otimes I_d$ | active |
| General passive lift of `evolvedEqFlipImage` | active |
| General clean-block theorem for the passive lift | active |
| Passive-family resource score | pending after clean-block theorem |
| Arbitrary time width and arbitrary `k` | later task |
| Hardware decomposition of Toffoli | later task |

## Build Gate

The current cycle must end with:

```bash
python3 tools/qbe.py check
```
