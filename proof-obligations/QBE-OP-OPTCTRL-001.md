# Proof Obligations: QBE-OP-OPTCTRL-001

Updated: `2026-06-19 02:55`

This ledger is the compact active-leaf view for the optimal-control operator
task.  The current cycle is an operator-block-encoding generalization, not a
paper-benchmark transcript and not a hardware-decomposition pass.

| Obligation | Lean declaration or target | Dependency class | Status |
|---|---|---|---|
| General passive target $E_1 \otimes I_d$ | planned `OptimalControl.passiveTargetOperator` | internal Lean interface | active leaf |
| Positive passive dimension convention | planned `[NeZero stateDim]` or `d + 1` convention | shape/register obligation | active leaf |
| Clean auxiliary embedding for passive dimension | planned `OptimalControl.passiveCleanIndex` | internal Lean interface | active leaf |
| Full-space active/passive quotient-remainder views | planned `OptimalControl.activeOfFullPassive`, `OptimalControl.stateOfFullPassive` | classical finite arithmetic | active leaf |
| System-space active/passive quotient-remainder views | planned `OptimalControl.passiveActiveOfSystem`, `OptimalControl.passiveStateOfSystem` | classical finite arithmetic | active leaf |
| Passive lift of reduced active permutation | planned `OptimalControl.liftReducedImagePassive` | internal Lean interface | active leaf |
| Passive lifted permutation/unitarity certificate | planned theorem for `liftReducedImagePassive stateDim evolvedEqFlipImage` | internal Lean interface | pending after lift |
| Clean-block theorem for passive lift | planned `OptimalControl.evolvedEqFlipPassive_cleanBlock` | projection/block-entry obligation | active leaf |
| Passive-family score remains `(4, 2, 1, 0)` | planned score lemma or candidate record | resource obligation | pending after clean block |
| Arbitrary time width and arbitrary `k` | no Lean target yet | source/operator extension | later task |
| Hardware-level Toffoli decomposition | no Lean target yet | backend extension | later task |

## Current Reuse Anchors

| Role | Lean declaration | Status |
|---|---|---|
| Concrete target | `OptimalControl.exampleOperator` | compiled |
| Concrete clean index | `OptimalControl.cleanIndex` | compiled |
| Reduced active map | `OptimalControl.evolvedEqFlipImage` | compiled |
| Reduced active permutation proof | `OptimalControl.evolvedEqFlipImage_isPermutation` | compiled |
| Concrete full lifted permutation proof | `OptimalControl.evolvedEqFlipFull_isPermutation` | compiled |
| Concrete clean-block theorem | `OptimalControl.evolvedEqFlip_cleanBlock` | compiled |
| Matrix-level concrete clean block | `OptimalControl.evolvedEqFlipUnitary_cleanBlock` | compiled |
| Circuit transcript bridge | `OptimalControl.evolvedEqFlipGateImages_eval` | compiled |
| Current score theorem | `OptimalControl.evolvedEqFlipCandidate_cost` | compiled |

## Next Lower Route

The next lower implementation should prove one reusable passive-state interface
at a time.  If quotient/remainder arithmetic blocks the full theorem, stop with
a typed `symbolic_bridge_gap` or `lean_tactic_gap` feedback packet instead of
changing the operator target or assuming a new register convention.
