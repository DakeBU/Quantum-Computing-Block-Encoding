import QuantumBlockEncoding.SelectedRyTrace
import QuantumBlockEncoding.StoredRectangularGivens

/-!
# Stored and costed local recursive rotation traces

The input contains `S = 2^q` rational coefficients for the LOCAL controls,
not a table of the data register's amplitudes. Every split materializes its
two output vectors; each arithmetic operation is charged, and persistent
list concatenation charges each copied spine node. Zero coefficients still
emit rotations. Control wires and selected control bits are stored vectors.

The counters reuse `StoredGivens.Run`; no shared counter semantics is changed.
The rational compiler uses `field` only for unit rational-field operations.
Only `encode` locally overcounts its integer multiply/add operations in that
tag, with the independent exact `encodingIndexOperations` count documenting
this extra charge. Reads, writes, comparisons and emitted instructions are
separate. This is a unit scalar/index-word model, not rational bit
complexity: numerator growth, allocation bytes, proof erasure, counter
bookkeeping, and loop/address bookkeeping are not certified runtime costs.
No real-angle evaluation, trigonometry or angle approximation is performed.
-/

namespace QuantumBlockEncoding.StoredSelectedRyTrace

open StoredGivens

abbrev Coefficients (controls : Nat) := Vector Rat (2 ^ controls)

/-- The first recursive control selects the high half of the stored array. -/
def basisIndex : (controls : Nat) → PrimitiveBasis controls → Fin (2 ^ controls)
  | 0, _ => 0
  | q + 1, bits =>
    let rest := basisIndex q (fun i => bits i.succ)
    ⟨(bits 0).val * 2 ^ q + rest.val, by
      have hb := (bits 0).isLt
      have hr := rest.isLt
      simp only [pow_succ]
      nlinarith⟩

def denote {q : Nat} (coefficients : Coefficients q) : PrimitiveBasis q → Rat :=
  fun bits => coefficients[(basisIndex q bits).val]

def denoteBits {q : Nat} (bits : Vector (Fin 2) q) : PrimitiveBasis q :=
  fun i => bits[i.val]

theorem basisIndex_injective (q : Nat) : Function.Injective (basisIndex q) := by
  induction q with
  | zero => intro a b _; exact Subsingleton.elim _ _
  | succ q ih =>
    intro a b equal
    have hval := congrArg Fin.val equal
    simp only [basisIndex] at hval
    have ha := (basisIndex q (fun i => a i.succ)).isLt
    have hb := (basisIndex q (fun i => b i.succ)).isLt
    have ha0 := (a 0).isLt
    have hb0 := (b 0).isLt
    have heads : a 0 = b 0 := by
      apply Fin.ext
      nlinarith
    have tails : (fun i : Fin q => a i.succ) = (fun i => b i.succ) := by
      apply ih
      apply Fin.ext
      have hh := congrArg Fin.val heads
      nlinarith
    funext i
    refine Fin.cases heads (fun j => ?_) i
    exact congrFun tails j

/-- Materialize a tail; persistent storage is not treated as a free view. -/
def tail {q : Nat} (xs : Vector α (q + 1)) : Run (Vector α q) :=
  collect fun i => read xs i.succ

@[simp] theorem tail_value {q : Nat} (xs : Vector α (q + 1)) (i : Fin q) :
    (tail xs).value[i.val] = xs[i.succ.val] := by
  simp [tail, StoredGivens.read, charge]

theorem tail_cost {q : Nat} (xs : Vector α (q + 1)) (op : Op) :
    (tail xs).cost op = q * (3 * tick .read op + 2 * tick .write op) := by
  simp [tail, collect_cost, StoredGivens.read, charge]
  ring

def halfAdd (a b : Rat) : Run Rat := do
  let sum ← charge .field (a + b)
  charge .field (sum / 2)

def halfSub (a b : Rat) : Run Rat := do
  let difference ← charge .field (a - b)
  charge .field (difference / 2)

@[simp] theorem halfAdd_value (a b : Rat) : (halfAdd a b).value = (a + b) / 2 := rfl
@[simp] theorem halfSub_value (a b : Rat) : (halfSub a b).value = (a - b) / 2 := rfl

theorem halfAdd_cost (a b : Rat) (op : Op) :
    (halfAdd a b).cost op = 2 * tick .field op := by
  simp [halfAdd, bind, Run.bind, charge]; omega

theorem halfSub_cost (a b : Rat) (op : Op) :
    (halfSub a b).cost op = 2 * tick .field op := by
  simp [halfSub, bind, Run.bind, charge]; omega

/-- One read of each input coefficient feeds both charged half operations.
The pair vector is stored before its two stored projections are constructed. -/
def split {q : Nat} (xs : Coefficients (q + 1)) :
    Run (Coefficients q × Coefficients q) := do
  let pairs ← collect fun i : Fin (2 ^ q) => do
    let a ← read xs ⟨i.val, by have := i.isLt; simp only [pow_succ]; omega⟩
    let b ← read xs ⟨2 ^ q + i.val, by have := i.isLt; simp only [pow_succ]; omega⟩
    let plus ← halfAdd a b
    let minus ← halfSub a b
    pure (plus, minus)
  let plus ← collect fun i => do
    let pair ← read pairs i
    pure pair.1
  let minus ← collect fun i => do
    let pair ← read pairs i
    pure pair.2
  pure (plus, minus)

theorem split_value {q : Nat} (xs : Coefficients (q + 1)) :
    denote (split xs).value.1 =
        (fun bits => (denote xs (Fin.cons 0 bits) + denote xs (Fin.cons 1 bits)) / 2) ∧
    denote (split xs).value.2 =
        (fun bits => (denote xs (Fin.cons 0 bits) - denote xs (Fin.cons 1 bits)) / 2) := by
  constructor <;> funext bits <;>
    simp [split, denote, basisIndex, bind, pure, Run.bind, Run.pure, StoredGivens.read, charge]

theorem split_cost {q : Nat} (xs : Coefficients (q + 1)) (op : Op) :
    (split xs).cost op =
      2 ^ q * (4 * tick .field op + 10 * tick .read op + 6 * tick .write op) := by
  simp [split, bind, pure, Run.bind, Run.pure, collect_cost, StoredGivens.read, charge,
    halfAdd_cost, halfSub_cost]
  ring

/-- A real recursive persistent append: inspect each node and copy each
nonempty prefix node. The right list is shared, never traversed here. -/
def append : List α → List α → Run (List α)
  | [], ys => charge .read ys
  | x :: xs, ys =>
    let rest := append xs ys
    ⟨x :: rest.value, tick .read + rest.cost + tick .write⟩

@[simp] theorem append_value (xs ys : List α) : (append xs ys).value = xs ++ ys := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [append, ih]

theorem append_cost (xs ys : List α) (op : Op) :
    (append xs ys).cost op =
      (xs.length + 1) * tick .read op + xs.length * tick .write op := by
  induction xs with
  | nil => simp [append, charge]
  | cons x xs ih =>
    simp [append, ih]
    ring

/-- Emission and the list-cell write are both charged. -/
def emit {qubits : Nat} (gate : SelectedRyTrace.Gate qubits)
    (rest : List (SelectedRyTrace.Gate qubits)) : Run (List (SelectedRyTrace.Gate qubits)) := do
  let gate ← charge .emit gate
  charge .write (gate :: rest)

@[simp] theorem emit_value {qubits : Nat} (gate : SelectedRyTrace.Gate qubits) (rest) :
    (emit gate rest).value = gate :: rest := rfl

theorem emit_cost {qubits : Nat} (gate : SelectedRyTrace.Gate qubits) (rest) (op : Op) :
    (emit gate rest).cost op = tick .emit op + tick .write op := rfl

/-- The actual recursive stored producer. The two append traversals copy
only the two recursively emitted prefixes, not an already assembled trace. -/
def compile {qubits : Nat} : (q : Nat) →
    (wires : Vector (Fin qubits) q) → (target : Fin qubits) →
    (∀ i : Fin q, wires[i.val] ≠ target) → Coefficients q →
    Run (List (SelectedRyTrace.Gate qubits))
  | 0, _, target, _, xs => do
    let coefficient ← read xs 0
    emit (.ry target coefficient) []
  | q + 1, wires, target, distinct, xs =>
    let halves := split xs
    let tailWires := tail wires
    let control := StoredGivens.read wires 0
    let first := compile q tailWires.value target (by
      intro i
      simpa only [tailWires, tail_value] using distinct i.succ) halves.value.1
    let second := compile q tailWires.value target (by
      intro i
      simpa only [tailWires, tail_value] using distinct i.succ) halves.value.2
    let last := emit (.cx control.value target (distinct 0)) []
    let back := append second.value last.value
    let middle := emit (.cx control.value target (distinct 0)) back.value
    let result := append first.value middle.value
    ⟨result.value, halves.cost + tailWires.cost + control.cost + first.cost +
      second.cost + last.cost + back.cost + middle.cost + result.cost⟩

theorem compile_value {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (xs : Coefficients q) :
    (compile q wires target distinct xs).value =
      SelectedRyTrace.compile q (fun i => wires[i.val]) target distinct (denote xs) := by
  induction q with
  | zero => rfl
  | succ q ih =>
    simp only [compile, StoredGivens.read, charge, append_value, emit_value]
    rw [ih, ih, (split_value xs).1, (split_value xs).2]
    simp only [SelectedRyTrace.compile, tail_value, List.append_assoc,
      List.cons_append, List.nil_append]

theorem compile_length {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (xs : Coefficients q) :
    (compile q wires target distinct xs).value.length =
      2 ^ q + 2 * (2 ^ q - 1) := by
  rw [compile_value, SelectedRyTrace.compile_length]

theorem compile_refines {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (xs : Coefficients q) (angle : ExactAngle) :
    evalPrimitiveCircuit (SelectedRyTrace.instantiate angle (compile q wires target distinct xs).value) =
      evalPrimitiveCircuit (compileUniformlyControlledRy q (fun i => wires[i.val]) target distinct
        (fun bits => .scale (denote xs bits) angle)) := by
  rw [compile_value, SelectedRyTrace.compile_refines]

/-- This recurrence describes the charged algorithm, including both append
traversals and materialization of the control-wire tail at every node. -/
def traceCost : Nat → Cost
  | 0 => tick .read + tick .write + tick .emit
  | q + 1 => fun op =>
    2 * traceCost q op +
    2 ^ q * (4 * tick .field op + 10 * tick .read op + 6 * tick .write op) +
    q * (3 * tick .read op + 2 * tick .write op) + tick .read op +
    2 * (tick .emit op + tick .write op) +
    2 * ((2 ^ q + 2 * (2 ^ q - 1) + 1) * tick .read op +
      (2 ^ q + 2 * (2 ^ q - 1)) * tick .write op)

theorem compile_cost {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (xs : Coefficients q) (op : Op) :
    (compile q wires target distinct xs).cost op = traceCost q op := by
  induction q with
  | zero =>
    simp [compile, bind, Run.bind, StoredGivens.read, charge, emit_cost, traceCost]
    ring
  | succ q ih =>
    simp only [compile, Pi.add_apply, split_cost, tail_cost, StoredGivens.read,
      charge, emit_cost, append_cost, compile_length, ih, traceCost]
    ring

/-- Exact component counts, written additively to avoid truncated subtraction. -/
theorem traceCost_fields (q : Nat) :
    traceCost q .field = 2 * q * 2 ^ q ∧
    traceCost q .read + 3 * q + 2 = (8 * q + 3) * 2 ^ q ∧
    traceCost q .write + 2 * q = (6 * q + 1) * 2 ^ q ∧
    traceCost q .emit + 2 = 3 * 2 ^ q := by
  induction q with
  | zero => decide
  | succ q ih =>
    rcases ih with ⟨hf, hr, hw, he⟩
    have positive : 0 < 2 ^ q := pow_pos (by decide) _
    have length_eq : 2 ^ q + 2 * (2 ^ q - 1) + 2 = 3 * 2 ^ q := by omega
    simp [traceCost, tick, pow_succ]
    constructor
    · nlinarith
    constructor
    · nlinarith
    constructor <;> nlinarith

theorem traceCost_unused (q : Nat) :
    traceCost q .sqrt = 0 ∧ traceCost q .angle = 0 ∧
    traceCost q .trig = 0 ∧ traceCost q .compare = 0 := by
  induction q with
  | zero => simp [traceCost, tick]
  | succ q ih => simpa [traceCost, tick] using ih

/-- All instructions, including zero-coefficient rotations, are emitted. -/
theorem compile_emit {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (xs : Coefficients q) :
    (compile q wires target distinct xs).cost .emit =
      (compile q wires target distinct xs).value.length := by
  rw [compile_cost, compile_length]
  have h := (traceCost_fields q).2.2.2
  have positive : 0 < 2 ^ q := pow_pos (by decide) _
  omega

theorem traceCost_total (q : Nat) :
    StoredRectangularGivens.total (traceCost q) + 5 * q + 4 = (16 * q + 7) * 2 ^ q := by
  rcases traceCost_fields q with ⟨hf, hr, hw, he⟩
  rcases traceCost_unused q with ⟨hs, ha, ht, hc⟩
  simp only [StoredRectangularGivens.total, hs, ha, ht, hc]
  nlinarith

/-- Polynomial in the local table size `S = 2^q` and control count `q`. -/
theorem compile_total_cost_le {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (xs : Coefficients q) :
    StoredRectangularGivens.total (compile q wires target distinct xs).cost ≤
      (16 * q + 7) * 2 ^ q := by
  have h := traceCost_total q
  have bound : StoredRectangularGivens.total (traceCost q) ≤ (16 * q + 7) * 2 ^ q := by omega
  simpa only [StoredRectangularGivens.total, compile_cost] using bound

/-- Two explicit index-word operations, locally charged under the field tag.
This helper makes no claim about the cost of integer multiplication in bits. -/
def joinIndex {q : Nat} (bit : Fin 2) (rest : Fin (2 ^ q)) : Run (Fin (2 ^ (q + 1))) :=
  let offset := charge .field (bit.val * 2 ^ q)
  let joined := charge .field (offset.value + rest.val)
  ⟨⟨joined.value, by
    have hb := bit.isLt
    have hr := rest.isLt
    dsimp [joined, offset, charge]
    simp only [pow_succ]
    nlinarith⟩, offset.cost + joined.cost⟩

/-- Convert a stored bit pattern to its array address, with charged tail copies. -/
def encode : (q : Nat) → Vector (Fin 2) q → Run (Fin (2 ^ q))
  | 0, _ => pure 0
  | q + 1, bits =>
    let first := StoredGivens.read bits 0
    let rest := tail bits
    let address := encode q rest.value
    let joined := joinIndex first.value address.value
    ⟨joined.value, first.cost + rest.cost + address.cost + joined.cost⟩

theorem encode_value {q : Nat} (bits : Vector (Fin 2) q) :
    (encode q bits).value = basisIndex q (denoteBits bits) := by
  induction q with
  | zero => rfl
  | succ q ih =>
    have ht : denoteBits (tail bits).value = (fun i => (denoteBits bits) i.succ) := by
      funext i
      exact tail_value bits i
    simp only [encode, joinIndex, StoredGivens.read, charge, ih]
    apply Fin.ext
    simp only [ht, basisIndex, denoteBits]

/-- Independent index-operation count; these are the extra local field-tag
charges and do not change any existing real/rational field-cost theorem. -/
def encodingIndexOperations (q : Nat) : Nat := 2 * q

def encodingCost : Nat → Cost
  | 0 => 0
  | q + 1 => fun op => encodingCost q op + 2 * tick .field op +
    (3 * q + 1) * tick .read op + 2 * q * tick .write op

theorem encode_cost {q : Nat} (bits : Vector (Fin 2) q) (op : Op) :
    (encode q bits).cost op = encodingCost q op := by
  induction q with
  | zero => rfl
  | succ q ih =>
    simp [encode, StoredGivens.read, charge, joinIndex, tail_cost, ih, encodingCost]
    ring

theorem encode_index_operations {q : Nat} (bits : Vector (Fin 2) q) :
    (encode q bits).cost .field = encodingIndexOperations q := by
  rw [encode_cost]
  induction q with
  | zero => rfl
  | succ q ih => simp [encodingCost, tick, encodingIndexOperations] at *; omega

theorem encodingCost_bound (q : Nat) (op : Op) :
    encodingCost q op ≤ q * (2 * tick .field op +
      (3 * q + 1) * tick .read op + 2 * q * tick .write op) := by
  induction q with
  | zero => simp [encodingCost]
  | succ q ih => simp only [encodingCost]; nlinarith

def oneHot {q : Nat} (chosen : Fin (2 ^ q)) : Run (Coefficients q) :=
  collect fun i => charge .compare (if i = chosen then 1 else 0)

theorem oneHot_value {q : Nat} (chosen : Fin (2 ^ q)) :
    denote (oneHot chosen).value = (fun bits => if basisIndex q bits = chosen then 1 else 0) := by
  funext bits
  simp [denote, oneHot, charge]

theorem oneHot_cost {q : Nat} (chosen : Fin (2 ^ q)) (op : Op) :
    (oneHot chosen).cost op =
      2 ^ q * (tick .compare op + 2 * tick .read op + 2 * tick .write op) := by
  simp [oneHot, collect_cost, charge]
  ring

def selectedCoefficients {q : Nat} (chosen : Vector (Fin 2) q) : Run (Coefficients q) := do
  let address ← encode q chosen
  oneHot address

theorem selectedCoefficients_value {q : Nat} (chosen : Vector (Fin 2) q) :
    denote (selectedCoefficients chosen).value =
      (fun bits => if bits = denoteBits chosen then 1 else 0) := by
  simp only [selectedCoefficients, bind, Run.bind, oneHot_value, encode_value]
  simp [(basisIndex_injective q).eq_iff]

def selected {qubits q : Nat} (wires : Vector (Fin qubits) q) (target : Fin qubits)
    (distinct : ∀ i : Fin q, wires[i.val] ≠ target) (chosen : Vector (Fin 2) q) :
    Run (List (SelectedRyTrace.Gate qubits)) := do
  let coefficients ← selectedCoefficients chosen
  compile q wires target distinct coefficients

theorem selected_value {qubits q : Nat} (wires : Vector (Fin qubits) q) (target : Fin qubits)
    (distinct : ∀ i : Fin q, wires[i.val] ≠ target) (chosen : Vector (Fin 2) q) :
    (selected wires target distinct chosen).value =
      SelectedRyTrace.selected (fun i => wires[i.val]) target distinct (denoteBits chosen) := by
  simp [selected, bind, Run.bind, compile_value, selectedCoefficients_value,
    SelectedRyTrace.selected]

theorem selected_refines {qubits q : Nat} (wires : Vector (Fin qubits) q) (target : Fin qubits)
    (distinct : ∀ i : Fin q, wires[i.val] ≠ target) (chosen : Vector (Fin 2) q) (angle : ExactAngle) :
    evalPrimitiveCircuit (SelectedRyTrace.instantiate angle (selected wires target distinct chosen).value) =
      evalPrimitiveCircuit (compileSelectedRy (fun i => wires[i.val]) target distinct
        (denoteBits chosen) angle) := by
  rw [selected_value, SelectedRyTrace.selected_refines]

theorem selected_cost {qubits q : Nat} (wires : Vector (Fin qubits) q) (target : Fin qubits)
    (distinct : ∀ i : Fin q, wires[i.val] ≠ target) (chosen : Vector (Fin 2) q) (op : Op) :
    (selected wires target distinct chosen).cost op = encodingCost q op +
      2 ^ q * (tick .compare op + 2 * tick .read op + 2 * tick .write op) + traceCost q op := by
  simp [selected, selectedCoefficients, bind, Run.bind, oneHot_cost, encode_cost, compile_cost]

/-- The local field-tag overcount is exposed separately from rational work. -/
theorem selected_field_tag_split {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (chosen : Vector (Fin 2) q) :
    (selected wires target distinct chosen).cost .field =
      2 * q * 2 ^ q + encodingIndexOperations q := by
  have encoded := encode_index_operations chosen
  rw [encode_cost] at encoded
  simp [selected_cost, tick, encoded, (traceCost_fields q).1, Nat.add_comm]

theorem selected_length {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (chosen : Vector (Fin 2) q) :
    (selected wires target distinct chosen).value.length =
      2 ^ q + 2 * (2 ^ q - 1) := by
  rw [selected_value, SelectedRyTrace.selected, SelectedRyTrace.compile_length]

theorem selected_emit {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (chosen : Vector (Fin 2) q) :
    (selected wires target distinct chosen).cost .emit =
      (selected wires target distinct chosen).value.length := by
  have empty := encodingCost_bound q .emit
  have count := (traceCost_fields q).2.2.2
  have positive : 0 < 2 ^ q := pow_pos (by decide) _
  simp [selected_cost, selected_length, tick] at *
  omega

theorem selected_total_cost_le {qubits q : Nat} (wires : Vector (Fin qubits) q)
    (target : Fin qubits) (distinct : ∀ i : Fin q, wires[i.val] ≠ target)
    (chosen : Vector (Fin 2) q) :
    StoredRectangularGivens.total (selected wires target distinct chosen).cost ≤
      (16 * q + 12) * 2 ^ q + 5 * q ^ 2 + 3 * q := by
  have hf := encodingCost_bound q .field
  have hs := encodingCost_bound q .sqrt
  have ha := encodingCost_bound q .angle
  have ht := encodingCost_bound q .trig
  have hc := encodingCost_bound q .compare
  have hr := encodingCost_bound q .read
  have hw := encodingCost_bound q .write
  have he := encodingCost_bound q .emit
  have trace := traceCost_total q
  simp [StoredRectangularGivens.total, selected_cost, tick] at *
  nlinarith

end QuantumBlockEncoding.StoredSelectedRyTrace
