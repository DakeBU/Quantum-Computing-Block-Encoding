import QuantumBlockEncoding.Robin.SourceSevenSparseData
import Mathlib.Tactic

/-!
# Fixed-N source interpretation for the Robin Figure-4 route

The derivative's periodic interior agrees with rows `2..5` of `D`, but the
Figure-4 indicator is applied to a row of `D^T`, hence to columns `3` and `4`
of `D`. This module fixes that distinction before circuit compilation.
-/

namespace QuantumBlockEncoding.Robin

/-- Periodic fourth-order integer stencil indexed by cyclic row offset. -/
def warmRobinPeriodicIntegerReference : Matrix 8 8 Int := fun row column =>
  match (row.val + 8 - column.val) % 8 with
  | 0 => -30
  | 1 | 7 => 16
  | 2 | 6 => -1
  | _ => 0

theorem warmRobinPeriodic_rows_two_through_five (row : Fin 8)
    (bulk : 2 ≤ row.val ∧ row.val ≤ 5) :
    ∀ column, warmRobinIntegerTarget row column =
      warmRobinPeriodicIntegerReference row column := by
  fin_cases row <;> simp_all <;> intro column <;> fin_cases column <;>
    native_decide

theorem warmRobinPeriodic_columns_three_and_four (column : Fin 8)
    (bulk : column = 3 ∨ column = 4) :
    ∀ row, warmRobinIntegerTarget row column =
      warmRobinPeriodicIntegerReference row column := by
  rcases bulk with rfl | rfl <;> intro row <;> fin_cases row <;> native_decide

/-- Figure 4 acts on a row of `D^T`, equivalently a column of `D`. -/
def warmRobinFigure4TransposeBulk (column : Fin 8) : Prop :=
  column = 3 ∨ column = 4

instance (column : Fin 8) : Decidable (warmRobinFigure4TransposeBulk column) :=
  by
    unfold warmRobinFigure4TransposeBulk
    infer_instance

theorem warmRobinFigure4TransposeBulk_matches_periodic
    (column : Fin 8) (bulk : warmRobinFigure4TransposeBulk column) :
    ∀ row, warmRobinIntegerTarget row column =
      warmRobinPeriodicIntegerReference row column :=
  warmRobinPeriodic_columns_three_and_four column bulk

theorem warmRobinFigure4_column_two_not_transpose_bulk :
    warmRobinIntegerTarget 0 2 = -2 ∧
      warmRobinPeriodicIntegerReference 0 2 = -1 := by
  native_decide

theorem warmRobinFigure4_column_five_not_transpose_bulk :
    warmRobinIntegerTarget 7 5 = -2 ∧
      warmRobinPeriodicIntegerReference 7 5 = -1 := by
  native_decide

/-- Interior derivative coefficients by physical selector slot. -/
def warmRobinFigure4BulkCoefficient (slot : Fin 8) : Rat :=
  match slot.val with
  | 0 => 0
  | 1 => -1 / 32
  | 2 => 16 / 32
  | 3 => -30 / 32
  | 4 => 16 / 32
  | 5 => -1 / 32
  | _ => 0

def warmRobinFigure4BoundaryCoefficient (slot column : Fin 8) : Rat :=
  warmRobinSourceSevenWeight slot column / 32

def warmRobinFigure4SourceCoefficient (slot column : Fin 8) : Rat :=
  warmRobinIntegerTarget (warmRobinSourceDTRow slot column) column / 32

theorem warmRobinFigure4SourceCoefficient_eq_weight (slot column : Fin 8) :
    warmRobinFigure4SourceCoefficient slot column =
      warmRobinSourceSevenWeight slot column / 32 := by
  rfl

theorem warmRobinFigure4SourceCoefficient_branch (slot column : Fin 8) :
    warmRobinFigure4SourceCoefficient slot column =
      if warmRobinFigure4TransposeBulk column then
        warmRobinFigure4BulkCoefficient slot
      else warmRobinFigure4BoundaryCoefficient slot column := by
  fin_cases slot <;> fin_cases column <;> native_decide

end QuantumBlockEncoding.Robin
