import QuantumBlockEncoding.PrimitiveDepthBound

open QuantumBlockEncoding

example : (PrimitiveCircuit.resource ([] : PrimitiveCircuit 0)).depth = 0 := by decide
example : (PrimitiveCircuit.resource ([] : PrimitiveCircuit 3)).depth = 0 := by decide

-- Different wires share one scheduled layer, despite two instructions.
def parallel : PrimitiveCircuit 2 := [.x 0, .x 1]
example : parallel.depth = 1 := by decide
example : parallel.gateCount = 2 := by decide

-- Repeated use of one wire forces two layers.
def serial : PrimitiveCircuit 2 := [.x 0, .x 0]
example : serial.resource.depth = 2 := by decide
example : serial.depth = serial.gateCount := by decide

-- A two-wire gate synchronizes the previous layers, then a final gate
-- extends the dependency path on its own target.
def synchronized : PrimitiveCircuit 2 := [.x 0, .x 1, .cx 0 1 (by decide), .x 1]
example : synchronized.resource.depth = 3 := by decide
example : synchronized.gateCount = 4 := by decide

example {q bound : Nat} (c : PrimitiveCircuit q) (h : c.gateCount ≤ bound) :
    c.resource.depth ≤ bound :=
  c.resource_depth_le_gateCount.trans h

#print axioms PrimitiveCircuit.foldl_nextWireDepth_le
#print axioms PrimitiveCircuit.resource_depth_le_gateCount
