# External Pro Construction Packet: Main Case Transfer Operator

Task: `QBE-MAIN-CASE-HIER-PRO-001`

This packet is an external upper-level input, analogous to a human expert
intervention or a ChatGPT Pro answer pasted into the ABEIS loop after the
ordinary harness has already started.  It is not a theorem and not a certified
candidate.  ABEIS may use it only by translating it into Lean declarations and
then proving the advertised block-entry, unitarity, and resource claims.

## Target

For `r = 1`, `k = 1`, and one passive state qubit, the target is

$$
E_1
=
|0\rangle\langle 1|_T
\otimes
|0\rangle\langle 1|_\tau
\otimes I_S .
$$

The required clean block is

$$
(\langle 0|_a \otimes I)\,U\,(|0\rangle_a\otimes I)=E_1 .
$$

## Pro Construction Idea

Use a single block-encoding ancilla `a`.

1. Compute an equality flag for the source subspace `T = k` and `tau = 1`.
   For the concrete benchmark `k = 1`, this is a Toffoli-style operation
   controlled by `T = 1` and `tau = 1`, targeting `a`.
2. When `a = 1`, transfer the selected active source basis state
   `|T=1, tau=1>` to the target basis state `|T=0, tau=0>`.
3. Flip the ancilla at the end so that the selected branch returns to the
   clean `a = 0` block and all unselected clean inputs are sent outside that
   block.

In the previously used reduced bit order

```text
bit 0 = type tau
bit 1 = time T
bit 2 = block ancilla a
```

the Pro construction is the four-gate transcript

```text
CCX(type,time;aux); CX(aux,time); CX(aux,type); X(aux)
```

or, in compact gate names,

```text
CCX012; CX21; CX20; X2
```

## Expected Proof Shape

The proof should be entrywise, not by informal circuit drawing.

For every passive state `s`:

- source branch:

  ```text
  |a=0, T=1, tau=1, s>
    -> |a=0, T=0, tau=0, s>
  ```

- non-source clean branches:

  ```text
  |a=0, T,tau,s> with (T,tau) != (1,1)
    -> a = 1 branch
  ```

Therefore the clean block has entry `1` exactly from active source
`(T,tau)=(1,1)` to active target `(T,tau)=(0,0)`, and entry `0` elsewhere.
The passive `S` register is unchanged, giving the tensor factor `I_S`.

## Expected Resource Claim

At the logical `{X, CNOT, Toffoli}` tier, before any later mutation, the Pro
construction has

```text
(gateCount, depth, auxiliaryQubits, oracleCalls) = (4, 4, 1, 0)
```

ABEIS may try to mutate or simplify it.  In the previous successful run, a
mutation/collaboration step found the depth-2 variant

```text
CCX012; {X0, X1, X2}
```

with score

```text
(gateCount, depth, auxiliaryQubits, oracleCalls) = (4, 2, 1, 0)
```

This previous endpoint is included only so the new isolated run can be checked
against the old result.  The current task must reproduce or improve it under
its own declarations and build gate.

## Acceptance Rule

The packet may guide the upper/middle plan immediately after injection.  It is
not accepted until Lean proves:

1. the candidate image/function is a permutation or the candidate matrix is
   unitary at the chosen semantic tier;
2. the clean block equals the target `E_1`;
3. the resource tuple is stated and checked;
4. any Qiskit/QASM export is generated only after the named Lean certificate.
