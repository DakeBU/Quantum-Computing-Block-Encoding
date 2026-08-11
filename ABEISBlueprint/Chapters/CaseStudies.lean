import QuantumBlockEncoding
import Verso
import VersoManual
import VersoBlueprint

open Verso.Genre
open Verso.Genre.Manual
open Informal

set_option linter.hashCommand false
set_option linter.style.longLine false
set_option verso.blueprint.externalCode.strictResolve true

#doc (Manual) "Certified case studies" =>
%%%
file := "case-studies"
%%%

These examples show the difference between a seed, a clean-block proof, and a complete verified
candidate. They also illustrate how ASPBE can evolve a correct unitary completion while preserving
the user-visible block.

# Cold-start transfer operator

:::definition "cold-start target" (lean := "QuantumBlockEncoding.coldE1QueryTarget")
The cold-start task fixes an $`8\times8` rational transfer operator, exact normalizer $`1`, semantic
source text, and no hidden free parameters.
:::

:::theorem "cold-start completion is a permutation" (lean := "QuantumBlockEncoding.coldE1CandidateImage_permutation_certificate") (uses := "cold-start target")
The explicit map on the full $`16` basis states is injective and surjective. This closes the finite
permutation leaf independently of the block-projection calculation.
:::

:::theorem "cold-start block projection" (lean := "QuantumBlockEncoding.coldE1Candidate_blockProjection") (uses := "cold-start completion is a permutation")
On the clean signal slice, the candidate permutation matrix agrees entrywise with the requested
cold-start target. Together with the permutation certificate, this supplies the two semantic
ingredients used by later full candidates.
:::

# Main Case 1 circuits

:::theorem "Pro circuit image is a permutation" (lean := "QuantumBlockEncoding.mainCaseProCircuitImage_permutation_certificate")
The logical circuit image, not merely a matrix-table completion, is proved to be a permutation of
the full basis.
:::

:::theorem "Pro circuit matrix is rational orthogonal" (lean := "QuantumBlockEncoding.mainCaseProCircuitMatrix_isRationalOrthogonal") (uses := "Pro circuit image is a permutation")
Both row and column Gram matrices of the concrete rational permutation matrix are identities. This
is the project-local finite unitarity theorem.
:::

:::theorem "Pro circuit block projection" (lean := "QuantumBlockEncoding.mainCaseProCircuit_blockProjection") (uses := "Pro circuit matrix is rational orthogonal")
The circuit matrix has exactly the requested clean block. The proof is separate from orthogonality,
so future implementations may change the off-block completion without changing the target theorem.
:::

:::definition "verified Pro circuit candidate" (lean := "QuantumBlockEncoding.mainCaseProCircuitVerified") (uses := "Pro circuit block projection")
The candidate packages the exact target, circuit, schedule, resource record, unitarity proof, and
block proof into the public verified-operator interface.
:::

:::theorem "cold partial-permutation clean block" (lean := "QuantumBlockEncoding.mainCaseColdPartialPerm_clean_eq_target")
The cold construction uses the shared partial-permutation route and exposes its clean-block target
equality as a reusable certificate theorem.
:::

:::definition "verified cold partial-permutation candidate" (lean := "QuantumBlockEncoding.mainCaseColdPartialPermVerified") (uses := "cold partial-permutation clean block")
The reusable exact block is promoted only after the full candidate supplies its unitary and
resource-level data.
:::

# Evolved optimal-control completion

:::theorem "evolved image is a permutation" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipImage_isPermutation")
The evolved child keeps the equality flag and follows it with three parallel bit flips. The
reduced active-register map remains a finite permutation.
:::

:::theorem "evolved matrix is rational orthogonal" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_isRationalOrthogonal") (uses := "evolved image is a permutation")
The corresponding $`16\times16` matrix closes both rational Gram-matrix identities.
:::

:::theorem "evolved clean block" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipUnitary_cleanBlock") (uses := "evolved matrix is rational orthogonal")
Although the off-block unitary completion differs from the parent construction, its clean block is
the same transfer operator.
:::

:::definition "verified evolved candidate" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipVerified") (uses := "evolved clean block")
The depth-two logical construction is packaged as a verified operator block encoding with an
explicit circuit transcript, schedule, resource count, and both semantic proofs.
:::

:::definition "zero-error evolved incumbent" (lean := "QuantumBlockEncoding.OptimalControl.evolvedEqFlipZeroErrorApprox") (uses := "verified evolved candidate")
The exact evolved solution is reused as the baseline for any later approximate optimization.
:::

# Cubic diagonal operator

:::theorem "linear diagonal input certificate is complete" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.linearDiagonalHouseholderInputBEContract_complete")
The linear diagonal input route simultaneously exposes rational orthogonality, the exact clean
block, normalizer $`1`, and the named resource equality. This is the proved input expected by later
polynomial or direct cubic routes.
:::

:::theorem "rational cubic completion exists" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalRationalCompletion_backendSupport")
For every grid index, four-square witnesses complete the cubic clean amplitude to a rational unit
vector. The direct sum of the resulting Householder blocks is rational orthogonal and its selected
block is the cubic diagonal operator.
:::

:::theorem "exact cubic certificate is complete" (lean := "QuantumBlockEncoding.CubicDiagonalOracle.cubicDiagonalHouseholderExactBEContract_complete") (uses := "rational cubic completion exists")
The root theorem combines the unitary predicate, exact clean-block target, normalizer, and resource
identity. It closes the direct exact construction without treating a clean-block-only wrapper as a
full operator certificate.
:::

# Robin-boundary audit

:::theorem "historical H-free fold is rejected" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryUnitaryEntry_ne_backendFold_n3")
The former raw symbolic target is not a missing associativity proof. It is false for the current
H-free backend model. The theorem converts the proposed equality to the equivalent backend
expansion and applies a compiled all-one coefficient counterexample. This closes that search
branch while leaving the paper-wide external oracle contracts visibly experimental.
:::

:::theorem "Robin active gate order" (lean := "QuantumBlockEncoding.Examples.RobinHeat.oneTermRobinGamma3BoundaryGateMatrixList_n3")
The seven active matrices are listed in exactly the circuit order used by the finite semantics.
Because symbolic coefficients retain expression-tree parentheses, algebraic regrouping belongs
after evaluation and is not asserted as raw constructor equality.
:::
