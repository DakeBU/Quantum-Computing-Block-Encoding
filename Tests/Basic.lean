import QuantumBlockEncoding

open QuantumBlockEncoding

example : gridSize 3 = 8 := rfl

example : (bandedSparseAccessResource 4 2).pureAncilla = 3 := rfl

example :
    (GHL2025.oneTermRobinResource { n := 5, kappa := 7, functionPieces := 1, polynomialDegreeCost := 3 }).pureAncilla = 10 := rfl

example : Examples.RobinHeat.fourthOrderSecondDerivative.width = 5 := rfl

example : problemCount = 7 := rfl

example : literatureCount = 16 := rfl

example : automationTaskCount = 3 := rfl

example : threeLayerAgentContracts.length = 4 := rfl
