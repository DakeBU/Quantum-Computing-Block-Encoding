/-!
# Literature registry

The registry is deliberately compiled by Lean.  A paper should appear here
before implementation work starts, so that project scope is visible to both
humans and automated agents.
-/

namespace QuantumBlockEncoding

inductive ImplementationStatus where
  | planned
  | skeleton
  | formalized
deriving Repr, DecidableEq

inductive PaperRole where
  | primaryTarget
  | explicitBlockEncoding
  | oracleConstruction
  | statePreparation
  | qsvtFramework
  | pdeSimulation
  | arithmeticCircuits
deriving Repr, DecidableEq

structure PaperEntry where
  key : String
  title : String
  authors : String
  year : Nat
  role : PaperRole
  status : ImplementationStatus
  targetFile : String
  url : String
  note : String
deriving Repr, DecidableEq

def literature : List PaperEntry :=
  [
    {
      key := "guseynov-huang-liu-2026-robin",
      title := "Quantum framework for simulating linear PDEs with Robin boundary conditions",
      authors := "Nikita Guseynov, Xiajie Huang, Nana Liu",
      year := 2026,
      role := PaperRole.primaryTarget,
      status := ImplementationStatus.skeleton,
      targetFile := "QuantumBlockEncoding/GHL2025.lean",
      url := "https://arxiv.org/abs/2506.20478",
      note := "Main target: explicit oracle-free block encodings for Robin boundaries."
    },
    {
      key := "guseynov-huang-liu-2025-pde-block-encoding",
      title := "Efficient explicit gate construction of block-encoding for Hamiltonians needed for simulating partial differential equations",
      authors := "Nikita Guseynov, Xiajie Huang, Nana Liu",
      year := 2025,
      role := PaperRole.explicitBlockEncoding,
      status := ImplementationStatus.skeleton,
      targetFile := "QuantumBlockEncoding/BandedSparseAccess.lean",
      url := "https://arxiv.org/abs/2405.12855",
      note := "Periodic-boundary predecessor and baseline for derivative/operator encodings."
    },
    {
      key := "conditionally-clean-promise-gates-2026",
      title := "Asymptotically Optimal Quantum Circuits for Comparators and Incrementers",
      authors := "Vivien Vandaele",
      year := 2026,
      role := PaperRole.arithmeticCircuits,
      status := ImplementationStatus.skeleton,
      targetFile := "QuantumBlockEncoding/PromiseGateOptimization.lean",
      url := "https://arxiv.org/abs/2603.12917",
      note := "ASPBE formalizes the controlled-conjugation and involutory dirty-flag identities; the paper's complete comparator and incrementer constructions remain outside current scope."
    },
    {
      key := "kharazi-alkadri-liu-mandadapu-whaley-2025-bvp",
      title := "Explicit block encodings of boundary value problems for many-body elliptic operators",
      authors := "Tyler Kharazi, Ahmad M. Alkadri, Jin-Peng Liu, Kranthi K. Mandadapu, K. Birgitta Whaley",
      year := 2025,
      role := PaperRole.explicitBlockEncoding,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/OpenProblems.lean",
      url := "https://arxiv.org/abs/2407.18347",
      note := "Explicit circuits for elliptic operators and Dirichlet, Neumann, Robin boundaries."
    },
    {
      key := "camps-lin-vanbeeumen-yang-2024-sparse",
      title := "Explicit quantum circuits for block encodings of certain sparse matrices",
      authors := "Daan Camps, Lin Lin, Roel Van Beeumen, Chao Yang",
      year := 2024,
      role := PaperRole.explicitBlockEncoding,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/Circuit.lean",
      url := "https://arxiv.org/abs/2203.10236",
      note := "Sparse-matrix block encoding circuits; important comparison point for generated circuits."
    },
    {
      key := "camps-vanbeeumen-2022-fable",
      title := "FABLE: Fast Approximate Quantum Circuits for Block-Encodings",
      authors := "Daan Camps, Roel Van Beeumen",
      year := 2022,
      role := PaperRole.explicitBlockEncoding,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/Circuit.lean",
      url := "https://arxiv.org/abs/2205.00081",
      note := "Approximate direct circuit synthesis for dense or structured matrices."
    },
    {
      key := "li-ni-ying-2023-pdo",
      title := "On efficient quantum block encoding of pseudo-differential operators",
      authors := "Haoya Li, Hongkang Ni, Lexing Ying",
      year := 2023,
      role := PaperRole.explicitBlockEncoding,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/OpenProblems.lean",
      url := "https://arxiv.org/abs/2301.08908",
      note := "Dense operator family; useful for variable-coefficient PDE operators."
    },
    {
      key := "gilyen-su-low-wiebe-2019-qsvt",
      title := "Quantum singular value transformation and beyond: exponential improvements for quantum matrix arithmetics",
      authors := "Andras Gilyen, Yuan Su, Guang Hao Low, Nathan Wiebe",
      year := 2019,
      role := PaperRole.qsvtFramework,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/BlockEncoding.lean",
      url := "https://arxiv.org/abs/1806.01838",
      note := "Core block-encoding and QSVT framework."
    },
    {
      key := "low-chuang-2017-qsp",
      title := "Optimal Hamiltonian simulation by quantum signal processing",
      authors := "Guang Hao Low, Isaac L. Chuang",
      year := 2017,
      role := PaperRole.qsvtFramework,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/OpenProblems.lean",
      url := "https://arxiv.org/abs/1606.02685",
      note := "Hamiltonian simulation primitive used after a block encoding is available."
    },
    {
      key := "childs-wiebe-2012-lcu",
      title := "Hamiltonian simulation using linear combinations of unitary operations",
      authors := "Andrew M. Childs, Nathan Wiebe",
      year := 2012,
      role := PaperRole.qsvtFramework,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/BlockEncoding.lean",
      url := "https://arxiv.org/abs/1202.5822",
      note := "LCU composition is central to combining block encodings."
    },
    {
      key := "berry-childs-cleve-kothari-somma-2014-sparse",
      title := "Exponential improvement in precision for simulating sparse Hamiltonians",
      authors := "Dominic W. Berry, Andrew M. Childs, Richard Cleve, Robin Kothari, Rolando D. Somma",
      year := 2014,
      role := PaperRole.qsvtFramework,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/Resources.lean",
      url := "https://arxiv.org/abs/1312.1414",
      note := "Sparse Hamiltonian simulation and query-model baseline."
    },
    {
      key := "jin-liu-yu-2024-schrodingerization-prl",
      title := "Quantum simulation of partial differential equations via Schrodingerization",
      authors := "Shi Jin, Nana Liu, Yue Yu",
      year := 2024,
      role := PaperRole.pdeSimulation,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/OpenProblems.lean",
      url := "https://arxiv.org/abs/2212.13969",
      note := "Transforms non-unitary PDE dynamics into Hamiltonian simulation tasks."
    },
    {
      key := "hu-jin-liu-zhang-2024-pde-circuits",
      title := "Quantum circuits for partial differential equations via Schrodingerisation",
      authors := "Junpeng Hu, Shi Jin, Nana Liu, Lei Zhang",
      year := 2024,
      role := PaperRole.pdeSimulation,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/OpenProblems.lean",
      url := "https://arxiv.org/abs/2403.10032",
      note := "Circuit-level PDE simulation reference around Schrodingerisation."
    },
    {
      key := "guseynov-liu-2024-piecewise-state-prep",
      title := "Efficient explicit circuit for quantum state preparation of piece-wise continuous functions",
      authors := "Nikita Guseynov, Nana Liu",
      year := 2024,
      role := PaperRole.statePreparation,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/OpenProblems.lean",
      url := "https://arxiv.org/abs/2411.01131",
      note := "Amplitude oracle ingredient for coefficient functions."
    },
    {
      key := "rossi-chuang-2022-mqsp",
      title := "Multivariable quantum signal processing (M-QSP): prophecies of the two-headed oracle",
      authors := "Zane M. Rossi, Isaac L. Chuang",
      year := 2022,
      role := PaperRole.qsvtFramework,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/OpenProblems.lean",
      url := "https://arxiv.org/abs/2205.06261",
      note := "Boundary of current multivariate polynomial transformation techniques."
    },
    {
      key := "draper-kutin-rains-svore-2004-adder",
      title := "A logarithmic-depth quantum carry-lookahead adder",
      authors := "Thomas G. Draper, Samuel A. Kutin, Eric M. Rains, Krysta M. Svore",
      year := 2004,
      role := PaperRole.arithmeticCircuits,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/Circuit.lean",
      url := "https://arxiv.org/abs/quant-ph/0406142",
      note := "Arithmetic subroutine source for explicit oracle implementations."
    },
    {
      key := "haener-roetteler-svore-2018-arithmetic",
      title := "Optimizing quantum circuits for arithmetic",
      authors := "Thomas Haener, Martin Roetteler, Krysta M. Svore",
      year := 2018,
      role := PaperRole.arithmeticCircuits,
      status := ImplementationStatus.planned,
      targetFile := "QuantumBlockEncoding/Circuit.lean",
      url := "https://arxiv.org/abs/1805.12445",
      note := "Arithmetic circuit optimization relevant to gate-level oracle costs."
    }
  ]

def literatureCount : Nat := literature.length

def primaryPapers : List PaperEntry :=
  literature.filter (fun p => p.role == PaperRole.primaryTarget)

end QuantumBlockEncoding
