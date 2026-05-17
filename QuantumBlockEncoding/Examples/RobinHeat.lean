import QuantumBlockEncoding.GHL2025

/-!
# Robin heat-equation example

This file records the fourth-order central second-derivative example from
Guseynov-Huang-Liu 2025 as symbolic stencil data.  The symbolic boundary entries
are intentionally not simplified: they are meant to be consumed by future
matrix-building and circuit-synthesis code.
-/

namespace QuantumBlockEncoding
namespace Examples
namespace RobinHeat

open Coeff

def fourthOrderSecondDerivative : Stencil where
  derivativeOrder := 2
  accuracyOrder := 4
  leftRadius := 2
  rightRadius := 2

def centralBulkEntries : List StencilEntry :=
  [
    { offset := -2, coeff := Coeff.rat ((-1 : Rat) / 12) },
    { offset := -1, coeff := Coeff.rat ((4 : Rat) / 3) },
    { offset := 0, coeff := Coeff.rat ((-5 : Rat) / 2) },
    { offset := 1, coeff := Coeff.rat ((4 : Rat) / 3) },
    { offset := 2, coeff := Coeff.rat ((-1 : Rat) / 12) }
  ]

def A1dx : Coeff := Coeff.symbol "A1*dx"
def B1dx : Coeff := Coeff.symbol "B1*dx"

/-- First row after eliminating the left Robin ghost points. -/
def leftBoundaryRow0 : List StencilEntry :=
  [
    { offset := 0, coeff := Coeff.rat ((-5 : Rat) / 2) + (Coeff.rat ((7 : Rat) / 3) * A1dx) },
    { offset := 1, coeff := Coeff.rat ((8 : Rat) / 3) },
    { offset := 2, coeff := Coeff.rat ((-1 : Rat) / 6) }
  ]

/-- Second row after eliminating the left Robin ghost points. -/
def leftBoundaryRow1 : List StencilEntry :=
  [
    { offset := -1, coeff := Coeff.rat ((4 : Rat) / 3) - (Coeff.rat ((1 : Rat) / 6) * A1dx) },
    { offset := 0, coeff := Coeff.rat ((-31 : Rat) / 12) },
    { offset := 1, coeff := Coeff.rat ((4 : Rat) / 3) },
    { offset := 2, coeff := Coeff.rat ((-1 : Rat) / 12) }
  ]

/-- Penultimate row after eliminating the right Robin ghost points. -/
def rightBoundaryRowNm2 : List StencilEntry :=
  [
    { offset := -2, coeff := Coeff.rat ((-1 : Rat) / 12) },
    { offset := -1, coeff := Coeff.rat ((4 : Rat) / 3) },
    { offset := 0, coeff := Coeff.rat ((-31 : Rat) / 12) },
    { offset := 1, coeff := Coeff.rat ((4 : Rat) / 3) + (Coeff.rat ((1 : Rat) / 6) * B1dx) }
  ]

/-- Last row after eliminating the right Robin ghost points. -/
def rightBoundaryRowNm1 : List StencilEntry :=
  [
    { offset := -2, coeff := Coeff.rat ((-1 : Rat) / 6) },
    { offset := -1, coeff := Coeff.rat ((8 : Rat) / 3) },
    { offset := 0, coeff := Coeff.rat ((-5 : Rat) / 2) - (Coeff.rat ((7 : Rat) / 3) * B1dx) }
  ]

def robinWindow (n : Nat) : BulkWindow where
  lower := 2
  upper := gridSize n - 3

def oneTermParameters (n : Nat) : GHL2025.OneTermRobinParameters where
  n := n
  kappa := 7
  functionPieces := 1
  polynomialDegreeCost := 1

theorem fourthOrderStencilWidth :
    fourthOrderSecondDerivative.width = 5 := rfl

theorem robinHeatAncillas (n : Nat) :
    (GHL2025.oneTermRobinResource (oneTermParameters n)).pureAncilla = 2 * n := rfl

end RobinHeat
end Examples
end QuantumBlockEncoding
