import QuantumBlockEncoding.BandedSparseAccessPrimitive

/-! Fixed support for the BE102 answer repair, not a native-view admission.
All statements concern this exact seven-wire reversible witness. -/
namespace QuantumBlockEncoding.QcbDirtyWorkBoundary

open BandedSparseAccess

set_option maxRecDepth 8192
set_option maxHeartbeats 8000000

theorem entering_work_preserved (state : PrimitiveBasis 7) :
    primitiveAccess3BasisEquiv state 6 = state 6 := by
  decide +revert

theorem row_preserved (state : PrimitiveBasis 7) :
    primitiveWord3 (primitiveAccess3BasisEquiv state) 3 4 5 =
      primitiveWord3 state 3 4 5 := by
  decide +revert

def dirtyThree : PrimitiveBasis 7 := fun i => if i = 0 ∨ i = 1 ∨ i = 6 then 1 else 0
def dirtyOne : PrimitiveBasis 7 := fun i => if i = 0 ∨ i = 6 then 1 else 0

theorem dirty_three_correct_sum :
    primitiveWord3 dirtyThree 0 1 2 = 3 ∧
    primitiveWord3 dirtyThree 3 4 5 = 0 ∧ dirtyThree 6 = 1 ∧
    primitiveWord3 (primitiveAccess3BasisEquiv dirtyThree) 0 1 2 = 0 ∧
    primitiveAccess3BasisEquiv dirtyThree 6 = 1 := by
  decide

theorem dirty_one_wrong_sum :
    primitiveWord3 dirtyOne 0 1 2 = 1 ∧
    primitiveWord3 dirtyOne 3 4 5 = 0 ∧ dirtyOne 6 = 1 ∧
    primitiveWord3 (primitiveAccess3BasisEquiv dirtyOne) 0 1 2 = 6 ∧
    ((primitiveOffset3 (primitiveWord3 dirtyOne 0 1 2)).val +
      (primitiveWord3 dirtyOne 3 4 5).val) % 8 = 2 ∧
    primitiveAccess3BasisEquiv dirtyOne 6 = 1 := by
  decide

#print axioms entering_work_preserved
#print axioms row_preserved
#print axioms dirty_three_correct_sum
#print axioms dirty_one_wrong_sum

end QuantumBlockEncoding.QcbDirtyWorkBoundary
