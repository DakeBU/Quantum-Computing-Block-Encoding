# Function Oracle Clean-Branch Blocks

Paper anchor: GHL2025 function oracle $O_f$.

Lean declarations:

- `FunctionOraclePaperRegisters`
- `functionOraclePaperRegisters`
- `functionOracleNormalizedValue`
- `FunctionOraclePaperImage`
- `functionOraclePaperImage`
- `functionOraclePaperMatrix`
- `functionOraclePaperMatrix_cleanBranch_entry`
- `functionOraclePaperMatrix_cleanWorkspace_offBranch_zero`
- `functionOraclePaperMatrix_nonCleanInput_entry`

## Definitions

For a compound basis index $j$, Lean extracts the system register value

$$
i(j)= (j\gg 1)\mathbin{\&}(2^n-1)
$$

and the $m_f$ workspace value from the high workspace register.  A column is a
clean input column when that workspace value is zero.

The symbolic normalized amplitude is

$$
a_i = f(x_i)N_f^{-1}.
$$

In Lean this is `functionOracleNormalizedValue p i`.

The paper-image record for a clean input column stores the clean branch

$$
|0\rangle^{m_f}|i\rangle \mapsto
a_i |0\rangle^{m_f}|i\rangle + |\operatorname{orth}_f(i)\rangle .
$$

The orthogonal component is symbolic; its correctness is an obligation.

## Proved Matrix Skeleton Entries

For a clean input column $j$, if $r$ is the clean-branch basis row stored by
`functionOraclePaperImage p j`, Lean proves

$$
M_{r,j}=a_{i(j)}.
$$

This is `functionOraclePaperMatrix_cleanBranch_entry`.

For a clean input column, every other clean-workspace output row has zero entry:

$$
M_{r',j}=0
$$

when $r'$ is still in the clean workspace but is not the clean branch row.  This
is `functionOraclePaperMatrix_cleanWorkspace_offBranch_zero`.

For a non-clean input column, the matrix entry is routed to a symbolic
completion entry.  This is `functionOraclePaperMatrix_nonCleanInput_entry`.

## Not Proved Yet

The following are not proved:

- $N_f$ bounds the function amplitudes;
- $N_f^{-1}$ is genuine division by a nonzero normalizer;
- the symbolic orthogonal component is orthogonal to the clean branch;
- the whole $O_f$ skeleton extends to a unitary.
