import QuantumBlockEncoding.Robin.PaperSevenPrimitive
import QuantumBlockEncoding.Robin.Figure4SourceData
import QuantumBlockEncoding.Robin.SourceBaseline
import Mathlib.Tactic

/-!
# Fixed-N physical leaves from the source Figure 4 route

These exact leaves replace the old transcript's `swap 0 0` placeholder.  They
do not by themselves establish the full source circuit clean-block theorem;
the derivative/boundary loaders and transported sparse cleanup remain separate
proof obligations.
-/

namespace QuantumBlockEncoding.Robin

/-- Historical row-bulk indicator for rows 2 through 5 of `D`.  Figure 4 acts
on `D^T`, so this circuit is retained only as a source-audit guard. -/
def warmRobinRowBulkIndicatorProgram : PrimitiveCircuit 4 :=
  [.cx 1 3 (by decide), .cx 2 3 (by decide)]

def warmRobinRowBulkIndicatorBasisEquiv :
    PrimitiveBasis 4 ≃ PrimitiveBasis 4 :=
  (cxBasisEquiv (1 : Fin 4) (3 : Fin 4) (by decide)).trans
    (cxBasisEquiv (2 : Fin 4) (3 : Fin 4) (by decide))

theorem warmRobinRowBulkIndicatorBasisAction (bits : PrimitiveBasis 4) :
    let output := warmRobinRowBulkIndicatorBasisEquiv bits
    output 0 = bits 0 ∧ output 1 = bits 1 ∧ output 2 = bits 2 ∧
      output 3 =
        (if 2 ≤ (bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val ∧
              (bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val ≤ 5 then
          Fin.cases 1 (fun _ => 0) (bits 3)
        else bits 3) := by
  native_decide +revert

theorem warmRobinRowBulkIndicatorProgram_eval :
    evalPrimitiveCircuit warmRobinRowBulkIndicatorProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinRowBulkIndicatorBasisEquiv := by
  simp only [warmRobinRowBulkIndicatorProgram, evalPrimitiveCircuit,
    evalPrimitiveGate, _root_.Matrix.one_mul]
  exact ComplexLCU.equivPermutationMatrix_mul _ _

/-- One physical SWAP expanded into the allowed primitive basis. -/
def primitiveSwapCircuit {qubits : Nat} (left right : Fin qubits)
    (distinct : left ≠ right) : PrimitiveCircuit qubits :=
  [.cx left right distinct, .cx right left (Ne.symm distinct),
    .cx left right distinct]

def primitiveSwapBasisEquiv {qubits : Nat} (left right : Fin qubits)
    (distinct : left ≠ right) : PrimitiveBasis qubits ≃ PrimitiveBasis qubits :=
  ((cxBasisEquiv left right distinct).trans
    (cxBasisEquiv right left (Ne.symm distinct))).trans
    (cxBasisEquiv left right distinct)

theorem primitiveSwapCircuit_eval {qubits : Nat} (left right : Fin qubits)
    (distinct : left ≠ right) :
    evalPrimitiveCircuit (primitiveSwapCircuit left right distinct) =
      ComplexLCU.equivPermutationMatrix
        (primitiveSwapBasisEquiv left right distinct) := by
  simp only [primitiveSwapCircuit, evalPrimitiveCircuit, evalPrimitiveGate,
    _root_.Matrix.one_mul]
  rw [ComplexLCU.equivPermutationMatrix_mul,
    ComplexLCU.equivPermutationMatrix_mul]
  rfl

/-- Swap the two fixed three-qubit registers with three actual SWAPs. -/
def warmRobinFigure4RegisterSwapProgram : PrimitiveCircuit 6 :=
  primitiveSwapCircuit 0 3 (by decide) ++
    primitiveSwapCircuit 1 4 (by decide) ++
    primitiveSwapCircuit 2 5 (by decide)

def warmRobinFigure4RegisterSwapBasisEquiv :
    PrimitiveBasis 6 ≃ PrimitiveBasis 6 :=
  ((primitiveSwapBasisEquiv 0 3 (by decide)).trans
    (primitiveSwapBasisEquiv 1 4 (by decide))).trans
    (primitiveSwapBasisEquiv 2 5 (by decide))

theorem warmRobinFigure4RegisterSwapProgram_eval :
    evalPrimitiveCircuit warmRobinFigure4RegisterSwapProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinFigure4RegisterSwapBasisEquiv := by
  unfold warmRobinFigure4RegisterSwapProgram
  rw [evalPrimitiveCircuit_append, evalPrimitiveCircuit_append,
    primitiveSwapCircuit_eval, primitiveSwapCircuit_eval,
    primitiveSwapCircuit_eval,
    ComplexLCU.equivPermutationMatrix_mul,
    ComplexLCU.equivPermutationMatrix_mul]
  rfl

theorem warmRobinFigure4RegisterSwapBasisAction
    (bits : PrimitiveBasis 6) :
    let output := warmRobinFigure4RegisterSwapBasisEquiv bits
    output 0 = bits 3 ∧ output 1 = bits 4 ∧ output 2 = bits 5 ∧
      output 3 = bits 0 ∧ output 4 = bits 1 ∧ output 5 = bits 2 := by
  native_decide +revert

theorem warmRobinFigure4RegisterSwapProgram_counts :
    warmRobinFigure4RegisterSwapProgram.ryCount = 0 ∧
      warmRobinFigure4RegisterSwapProgram.cxCount = 9 := by
  decide

/-- For homogeneous `f=1`, the coefficient oracle is physically empty. -/
def warmRobinHomogeneousCoefficientOracle : PrimitiveCircuit 1 := []

theorem warmRobinHomogeneousCoefficientOracle_eq_identity :
    evalPrimitiveCircuit warmRobinHomogeneousCoefficientOracle = 1 := by
  rfl

theorem warmRobinRowBulkIndicatorCleanup :
    evalPrimitiveCircuit
        (warmRobinRowBulkIndicatorProgram ++
          warmRobinRowBulkIndicatorProgram.reverse.map PrimitiveGate.dagger) =
      1 := by
  rw [evalPrimitiveCircuit_append, evalPrimitiveCircuit_dagger]
  exact (_root_.Matrix.mem_unitaryGroup_iff'.mp
    (evalPrimitiveCircuit_unitary warmRobinRowBulkIndicatorProgram))

/-! ## Correct D-transpose indicator -/

/-- Two disjoint pattern-controlled flips: `011` and `100`.  Wires `q3-q5`
hold the system column, `q7` is the indicator, and `q8` is reusable clean
workspace. -/
def warmRobinFigure4DTIndicatorReversibleProgram : ReversibleProgram 9 :=
  [ .x 5 ] ++
    cleanC3XReversibleProgram 3 4 5 7 8
      (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) ++
    [ .x 5, .x 3, .x 4 ] ++
    cleanC3XReversibleProgram 3 4 5 7 8
      (by decide) (by decide) (by decide) (by decide) (by decide) (by decide) ++
    [ .x 4, .x 3 ]

def warmRobinFigure4DTIndicatorBasisEquiv :
    PrimitiveBasis 9 ≃ PrimitiveBasis 9 :=
  evalReversibleProgram warmRobinFigure4DTIndicatorReversibleProgram

def warmRobinFigure4SystemBits (bits : PrimitiveBasis 9) : Fin 8 :=
  ⟨(bits 3).val + 2 * (bits 4).val + 4 * (bits 5).val, by omega⟩

theorem warmRobinFigure4DTIndicatorProgram_basisAction
    (bits : PrimitiveBasis 9) (workspaceClean : bits 8 = 0) :
    let output := warmRobinFigure4DTIndicatorBasisEquiv bits
    output 7 =
        (if warmRobinFigure4TransposeBulk (warmRobinFigure4SystemBits bits)
          then flipBit (bits 7) else bits 7) ∧
      output 8 = 0 ∧
      (∀ wire : Fin 9, wire ≠ 7 → wire ≠ 8 → output wire = bits wire) := by
  native_decide +revert

theorem warmRobinFigure4DTIndicatorProgram_workspaceClean
    (bits : PrimitiveBasis 9) (workspaceClean : bits 8 = 0) :
    warmRobinFigure4DTIndicatorBasisEquiv bits 8 = 0 :=
  (warmRobinFigure4DTIndicatorProgram_basisAction bits workspaceClean).2.1

noncomputable def warmRobinFigure4DTIndicatorProgram : PrimitiveProgram 9 :=
  compileReversibleProgram warmRobinFigure4DTIndicatorReversibleProgram

theorem warmRobinFigure4DTIndicatorProgram_eval :
    evalPrimitiveProgram warmRobinFigure4DTIndicatorProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinFigure4DTIndicatorBasisEquiv := by
  exact compileReversibleProgram_eval _

theorem warmRobinFigure4DTIndicatorProgram_noOracleCalls :
    warmRobinFigure4DTIndicatorProgram.resource.oracleCalls = 0 :=
  PrimitiveCircuit.resource_oracleCalls_eq_zero _

/-! ## Distinct D-transpose and D sparse-access programs -/

def warmRobinFigure4AddressBits (bits : PrimitiveBasis 9) : Fin 8 :=
  ⟨(bits 0).val + 2 * (bits 1).val + 4 * (bits 2).val, by omega⟩

/-- Convert slot `s` to `s XOR 3`, then add the system column modulo eight. -/
def warmRobinFigure4DTSparseAccessReversibleProgram : ReversibleProgram 9 :=
  [ .x 0, .x 1
  , .ccx 3 0 8 (by decide) (by decide) (by decide)
  , .ccx 8 1 2 (by decide) (by decide) (by decide)
  , .ccx 3 0 8 (by decide) (by decide) (by decide)
  , .ccx 3 0 1 (by decide) (by decide) (by decide)
  , .cx 3 0 (by decide)
  , .ccx 4 1 2 (by decide) (by decide) (by decide)
  , .cx 4 1 (by decide)
  , .cx 5 2 (by decide)
  ]

def warmRobinFigure4DTSparseAccessBasisEquiv :
    PrimitiveBasis 9 ≃ PrimitiveBasis 9 :=
  evalReversibleProgram warmRobinFigure4DTSparseAccessReversibleProgram

theorem warmRobinFigure4DTSparseAccessProgram_cleanAction
    (bits : PrimitiveBasis 9) (workspaceClean : bits 8 = 0) :
    let output := warmRobinFigure4DTSparseAccessBasisEquiv bits
    warmRobinFigure4AddressBits output =
        warmRobinSourceDTRow (warmRobinFigure4AddressBits bits)
          (warmRobinFigure4SystemBits bits) ∧
      warmRobinFigure4SystemBits output = warmRobinFigure4SystemBits bits ∧
      output 6 = bits 6 ∧ output 7 = bits 7 ∧ output 8 = 0 := by
  native_decide +revert

noncomputable def warmRobinFigure4DTSparseAccessProgram : PrimitiveProgram 9 :=
  compileReversibleProgram warmRobinFigure4DTSparseAccessReversibleProgram

theorem warmRobinFigure4DTSparseAccessProgram_eval :
    evalPrimitiveProgram warmRobinFigure4DTSparseAccessProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinFigure4DTSparseAccessBasisEquiv :=
  compileReversibleProgram_eval _

/-- Convert slot `s` to `s+5`, then add the second register modulo eight. -/
def warmRobinFigure4DSparseAccessReversibleProgram : ReversibleProgram 9 :=
  [ .ccx 0 1 2 (by decide) (by decide) (by decide)
  , .cx 0 1 (by decide)
  , .x 0
  , .x 2
  , .ccx 3 0 8 (by decide) (by decide) (by decide)
  , .ccx 8 1 2 (by decide) (by decide) (by decide)
  , .ccx 3 0 8 (by decide) (by decide) (by decide)
  , .ccx 3 0 1 (by decide) (by decide) (by decide)
  , .cx 3 0 (by decide)
  , .ccx 4 1 2 (by decide) (by decide) (by decide)
  , .cx 4 1 (by decide)
  , .cx 5 2 (by decide)
  ]

def warmRobinFigure4DSparseAccessBasisEquiv :
    PrimitiveBasis 9 ≃ PrimitiveBasis 9 :=
  evalReversibleProgram warmRobinFigure4DSparseAccessReversibleProgram

theorem warmRobinFigure4DSparseAccessProgram_cleanAction
    (bits : PrimitiveBasis 9) (workspaceClean : bits 8 = 0) :
    let output := warmRobinFigure4DSparseAccessBasisEquiv bits
    warmRobinFigure4AddressBits output =
        ⟨((warmRobinFigure4SystemBits bits).val +
          (warmRobinFigure4DOffset (warmRobinFigure4AddressBits bits)).val) % 8,
          Nat.mod_lt _ (by decide)⟩ ∧
      warmRobinFigure4SystemBits output = warmRobinFigure4SystemBits bits ∧
      output 6 = bits 6 ∧ output 7 = bits 7 ∧ output 8 = 0 := by
  native_decide +revert

noncomputable def warmRobinFigure4DSparseAccessProgram : PrimitiveProgram 9 :=
  compileReversibleProgram warmRobinFigure4DSparseAccessReversibleProgram

theorem warmRobinFigure4DSparseAccessProgram_eval :
    evalPrimitiveProgram warmRobinFigure4DSparseAccessProgram =
      ComplexLCU.equivPermutationMatrix
        warmRobinFigure4DSparseAccessBasisEquiv :=
  compileReversibleProgram_eval _

def warmRobinFigure4TransportInput
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    PrimitiveBasis 9
  | ⟨0, _⟩ => primitiveBits3LE slot 0
  | ⟨1, _⟩ => primitiveBits3LE slot 1
  | ⟨2, _⟩ => primitiveBits3LE slot 2
  | ⟨3, _⟩ => primitiveBits3LE column 0
  | ⟨4, _⟩ => primitiveBits3LE column 1
  | ⟨5, _⟩ => primitiveBits3LE column 2
  | ⟨6, _⟩ => coefficient
  | ⟨7, _⟩ => indicator
  | _ => 0

@[simp] theorem warmRobinFigure4TransportInput_workspace
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    warmRobinFigure4TransportInput slot column coefficient indicator 8 = 0 := by
  rfl

@[simp] theorem warmRobinFigure4TransportInput_address
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    warmRobinFigure4AddressBits
        (warmRobinFigure4TransportInput slot column coefficient indicator) =
      slot := by
  native_decide +revert

@[simp] theorem warmRobinFigure4TransportInput_system
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    warmRobinFigure4SystemBits
        (warmRobinFigure4TransportInput slot column coefficient indicator) =
      column := by
  native_decide +revert

@[simp] theorem warmRobinFigure4TransportInput_coefficient
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    warmRobinFigure4TransportInput slot column coefficient indicator 6 =
      coefficient := by
  rfl

@[simp] theorem warmRobinFigure4TransportInput_indicator
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    warmRobinFigure4TransportInput slot column coefficient indicator 7 =
      indicator := by
  rfl

def warmRobinFigure4RegisterSwapReversibleProgram : ReversibleProgram 9 :=
  [ .cx 0 3 (by decide), .cx 3 0 (by decide), .cx 0 3 (by decide)
  , .cx 1 4 (by decide), .cx 4 1 (by decide), .cx 1 4 (by decide)
  , .cx 2 5 (by decide), .cx 5 2 (by decide), .cx 2 5 (by decide)
  ]

def warmRobinFigure4RegisterSwapFullBasisEquiv :
    PrimitiveBasis 9 ≃ PrimitiveBasis 9 :=
  evalReversibleProgram warmRobinFigure4RegisterSwapReversibleProgram

@[simp] theorem warmRobinFigure4AddressBits_decode
    (bits : PrimitiveBasis 9) (wire : Fin 3) :
    primitiveBits3LE (warmRobinFigure4AddressBits bits) wire =
      bits ⟨wire.val, by omega⟩ := by
  fin_cases wire <;> native_decide +revert

@[simp] theorem warmRobinFigure4SystemBits_decode
    (bits : PrimitiveBasis 9) (wire : Fin 3) :
    primitiveBits3LE (warmRobinFigure4SystemBits bits) wire =
      bits ⟨wire.val + 3, by omega⟩ := by
  fin_cases wire <;> native_decide +revert

theorem warmRobinFigure4Basis_ext
    (left right : PrimitiveBasis 9)
    (address : warmRobinFigure4AddressBits left =
      warmRobinFigure4AddressBits right)
    (system : warmRobinFigure4SystemBits left =
      warmRobinFigure4SystemBits right)
    (coefficient : left 6 = right 6)
    (indicator : left 7 = right 7)
    (workspace : left 8 = right 8) : left = right := by
  funext wire
  fin_cases wire
  · simpa using congrArg (fun index => primitiveBits3LE index 0) address
  · simpa using congrArg (fun index => primitiveBits3LE index 1) address
  · simpa using congrArg (fun index => primitiveBits3LE index 2) address
  · simpa using congrArg (fun index => primitiveBits3LE index 0) system
  · simpa using congrArg (fun index => primitiveBits3LE index 1) system
  · simpa using congrArg (fun index => primitiveBits3LE index 2) system
  · exact coefficient
  · exact indicator
  · exact workspace

theorem warmRobinFigure4DTSparseAccess_transportInput
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    warmRobinFigure4DTSparseAccessBasisEquiv
        (warmRobinFigure4TransportInput slot column coefficient indicator) =
      warmRobinFigure4TransportInput
        (warmRobinSourceDTRow slot column) column coefficient indicator := by
  have inputClean :
      warmRobinFigure4TransportInput slot column coefficient indicator 8 = 0 :=
    warmRobinFigure4TransportInput_workspace _ _ _ _
  have action :=
    warmRobinFigure4DTSparseAccessProgram_cleanAction _ inputClean
  apply warmRobinFigure4Basis_ext
  · simpa using action.1
  · simpa using action.2.1
  · simpa using action.2.2.1
  · simpa using action.2.2.2.1
  · simpa using action.2.2.2.2

theorem warmRobinFigure4RegisterSwap_transportInput
    (left right : Fin 8) (coefficient indicator : Fin 2) :
    warmRobinFigure4RegisterSwapFullBasisEquiv
        (warmRobinFigure4TransportInput left right coefficient indicator) =
      warmRobinFigure4TransportInput right left coefficient indicator := by
  native_decide +revert

theorem warmRobinFigure4DOffset_after_DT
    (slot column : Fin 8) :
    (⟨((warmRobinSourceDTRow slot column).val +
        (warmRobinFigure4DOffset slot).val) % 8,
        Nat.mod_lt _ (by decide)⟩ : Fin 8) = column := by
  fin_cases slot <;> fin_cases column <;> native_decide

theorem warmRobinFigure4DSparseAccess_transportInput
    (slot system : Fin 8) (coefficient indicator : Fin 2) :
    warmRobinFigure4DSparseAccessBasisEquiv
        (warmRobinFigure4TransportInput slot system coefficient indicator) =
      warmRobinFigure4TransportInput
        ⟨(system.val + (warmRobinFigure4DOffset slot).val) % 8,
          Nat.mod_lt _ (by decide)⟩ system coefficient indicator := by
  have inputClean :
      warmRobinFigure4TransportInput slot system coefficient indicator 8 = 0 :=
    warmRobinFigure4TransportInput_workspace _ _ _ _
  have action :=
    warmRobinFigure4DSparseAccessProgram_cleanAction _ inputClean
  apply warmRobinFigure4Basis_ext
  · simpa using action.1
  · simpa using action.2.1
  · simpa using action.2.2.1
  · simpa using action.2.2.2.1
  · simpa using action.2.2.2.2

/-- Central cleanup root: D-transpose access, register transport, and inverse D
access restore the original slot while leaving the transported row in the
system register and returning `q8` to zero. -/
theorem warmRobinFigure4TransportedPostSwapCleanup
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    let afterDT := warmRobinFigure4DTSparseAccessBasisEquiv
      (warmRobinFigure4TransportInput slot column coefficient indicator)
    let afterSwap := warmRobinFigure4RegisterSwapFullBasisEquiv afterDT
    let output := warmRobinFigure4DSparseAccessBasisEquiv.symm afterSwap
    warmRobinFigure4AddressBits output = slot ∧
      warmRobinFigure4SystemBits output =
        warmRobinSourceDTRow slot column ∧
      output 6 = coefficient ∧ output 7 = indicator ∧ output 8 = 0 := by
  let sourceRow := warmRobinSourceDTRow slot column
  have afterDT :
      warmRobinFigure4DTSparseAccessBasisEquiv
          (warmRobinFigure4TransportInput slot column coefficient indicator) =
        warmRobinFigure4TransportInput
          sourceRow column coefficient indicator :=
    warmRobinFigure4DTSparseAccess_transportInput _ _ _ _
  have afterSwap :
      warmRobinFigure4RegisterSwapFullBasisEquiv
          (warmRobinFigure4DTSparseAccessBasisEquiv
            (warmRobinFigure4TransportInput slot column coefficient indicator)) =
        warmRobinFigure4TransportInput
          column sourceRow coefficient indicator := by
    rw [afterDT]
    exact warmRobinFigure4RegisterSwap_transportInput _ _ _ _
  have dForward :
      warmRobinFigure4DSparseAccessBasisEquiv
          (warmRobinFigure4TransportInput slot sourceRow coefficient indicator) =
        warmRobinFigure4TransportInput
          column sourceRow coefficient indicator := by
    rw [warmRobinFigure4DSparseAccess_transportInput]
    rw [show
      (⟨(sourceRow.val + (warmRobinFigure4DOffset slot).val) % 8,
        Nat.mod_lt _ (by decide)⟩ : Fin 8) = column by
          exact warmRobinFigure4DOffset_after_DT slot column]
  dsimp only
  rw [afterSwap, ← dForward, Equiv.symm_apply_apply]
  simp [sourceRow]

theorem warmRobinFigure4SparseWorkspaceClean
    (slot column : Fin 8) (coefficient indicator : Fin 2) :
    let afterDT := warmRobinFigure4DTSparseAccessBasisEquiv
      (warmRobinFigure4TransportInput slot column coefficient indicator)
    let afterSwap := warmRobinFigure4RegisterSwapFullBasisEquiv afterDT
    warmRobinFigure4DSparseAccessBasisEquiv.symm afterSwap 8 = 0 :=
  (warmRobinFigure4TransportedPostSwapCleanup
    slot column coefficient indicator).2.2.2.2

/-- Historical pre-T3 audit list. `Figure4T3.lean` now closes these obligations
for fixed N=8, homogeneous f=1, and the standard-RY-corrected executable
convention. -/
def warmRobinFigure4FormerOpenPrimitiveContracts : List String :=
  [ "derivative-amplitude loader exact semantics"
  , "corrected boundary standard-RY loader exact semantics"
  , "pre-SWAP sparse access and transported post-SWAP cleanup"
  , "stagewise all-workspace clean-column theorem"
  , "full Figure-4 primitive clean-block promotion"
  ]

/-- No primitive obligations remain open for the fixed-N8 Figure-4 route. -/
def warmRobinFigure4OpenPrimitiveContracts : List String := []

@[simp] theorem warmRobinFigure4OpenPrimitiveContracts_eq_nil :
    warmRobinFigure4OpenPrimitiveContracts = [] := rfl

end QuantumBlockEncoding.Robin
