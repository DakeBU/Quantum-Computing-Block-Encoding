# ChatGPT Pro Prompt: Generalize the evolved `E_k` construction

You are helping with task `QBE-OP-OPTCTRL-001`.

Target operator:

```text
E_k := |0><k|_time ⊗ |0><1|_type ⊗ I_n
```

The goal is not to give a polished paper explanation. The goal is to produce a
Lean-formalizable construction plan for a unitary/block-encoding candidate.
Do not claim global optimality.

## Current Lean-checked concrete status

The concrete instance is:

- one time bit;
- one type bit;
- one passive state bit;
- `k = 1`;
- one block-encoding auxiliary bit;
- reduced bit order: `bit 0 = type`, `bit 1 = time`, `bit 2 = auxiliary`.

The old candidate implemented one fixed permutation completion and had score:

```text
depth = 5, gateCount = 6, auxiliaryQubits = 1, oracleCalls = 0
```

Your proposed equality-flag/transfer construction specialized to:

```text
CCX(type,time;aux);
CX(aux,time);
CX(aux,type);
X(aux)
```

In Lean reduced-bit notation:

```text
CCX012; CX21; CX20; X2
```

It does **not** implement the old fixed permutation completion, but it does not
need to. Lean now verifies it directly as a different completion with the same
clean block:

```text
proEqTransferFull_isPermutation
proEqTransfer_cleanBlock
proEqTransferCost_gateCount = 4
proEqTransferCost_betterThan_depth5
```

Then an EoH-style mutation improved it:

```text
Layer 1: CCX(type,time;aux)
Layer 2: X(type), X(time), X(aux) in parallel
```

Lean names:

```text
evolvedEqFlipImage
evolvedEqFlipFull_isPermutation
evolvedEqFlip_cleanBlock
evolvedEqFlipCost_gateCount = 4
evolvedEqFlipCost.depth = 2
evolvedEqFlipCost_betterThan_pro
evolvedEqFlipCost_betterThan_depth5
```

Concrete logical score:

```text
depth = 2, gateCount = 4, auxiliaryQubits = 1, oracleCalls = 0
```

This is verified only as finite permutation/function semantics plus clean-block
equality. It is not yet connected to full gate-matrix semantics and is not yet
generalized to arbitrary time width or state dimension.

## Construction to generalize

Please analyze the evolved construction, not only the original transfer form.
The key idea is:

1. `O_eq` flags exactly the clean input branch satisfying `(T = k, tau = 1)`.
2. Instead of preserving a chosen old completion, use the freedom of block
   encoding: only the selected branch must return to clean ancilla as
   `(T = 0, tau = 0)`.
3. Non-selected clean inputs only need to leave the clean block; their exact
   images are completion freedom.

The intended block behavior is:

```text
(<0^a| ⊗ I) U_k (|0^a> ⊗ I) = E_k
```

where `U_k` is the composed reversible/unitary operation.

## Required output

Please return a proof-design note with these sections:

1. `Register layout`
   - Define the time register, type register, state register, flag ancilla,
     and clean/block ancilla.
   - State all assumptions on valid `k`, time dimension, and type dimension.

2. `Finite basis semantics`
   - Give a basis-index description of `E_k`.
   - State exactly when a matrix entry of `E_k` is `1` and when it is `0`.

3. `O_eq`
   - Specify whether `O_eq` is a reversible XOR-into-flag oracle or another
     reversible finite permutation.
   - State the Lean lemma that proves the flag is set iff `(T = k, tau = 1)`.
   - Include the required uncomputation if the flag must be reset for the final
     clean block.

4. `Evolved completion`
   - For general `k`, propose the analogue of `CCX012; {X0,X1,X2}`.
   - Be careful: for multi-bit time register, simply flipping all time bits
     may not map `k` to `0` unless the correct `X_T^(k)` convention is used.
   - State whether the clean selected branch can be sent to `(T=0,tau=0,a=0)`
     by unconditional flips after equality flagging, or whether some controlled
     transfer is unavoidable.
   - Explain how every non-selected clean input is guaranteed to leave the
     clean block.

5. `Ancilla routing`
   - Specify the ancilla routing rule.
   - Make explicit that the selected branch is routed to clean ancilla `0`.
   - Make explicit that every non-selected branch is routed to ancilla `1` or
     another non-clean value, so it contributes zero to the clean block.

6. `Unitarity/permutation proof`
   - Describe the finite permutation whose permutation matrix is `U_k`.
   - State injectivity/surjectivity lemmas or an explicit inverse.
   - If the construction uses high-level oracles, keep oracle calls in the
     resource score.

7. `Clean block theorem`
   - State the exact Lean theorem shape for:

```text
∀ row col,
  U_k (cleanIndex row) (cleanIndex col) = E_k row col
```

   - Split the proof into the selected case and the non-selected cases.

8. `Resource score and comparison`
   - Use `alpha = 1` as the target exact block encoding normalizer.
   - Estimate depth, gate count, auxiliary qubits, and oracle calls separately
     for the concrete `r = 1` construction and the generalized `r`-bit time
     construction.
   - Compare against the existing finite candidates:

```text
old fixed completion: depth = 5, gateCount = 6, auxiliaryQubits = 1, oracleCalls = 0
Pro transfer completion: depth = 4, gateCount = 4, auxiliaryQubits = 1, oracleCalls = 0
evolved clean-block completion: depth = 2, gateCount = 4, auxiliaryQubits = 1, oracleCalls = 0
```

   - Be clear that these candidates are for the concrete reduced instance
     `(time qubit, type qubit, one state qubit, k = 1)`.
   - Identify what changes when the time register has `r > 1` qubits.

## Constraints

- Avoid absolute local paths.
- Do not assert global optimality.
- Do not assert a completed Lean theorem unless you give the exact theorem
  statement and proof route.
- Treat all current candidates as concrete finite witnesses, not as fully
  generalized `E_k` theorems.
- The main deliverable is a route that a Lean agent can turn into definitions
  and lemmas for arbitrary `k`, arbitrary time-register width, and arbitrary
  passive state dimension.
