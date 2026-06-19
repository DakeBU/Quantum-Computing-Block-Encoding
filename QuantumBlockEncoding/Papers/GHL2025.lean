import QuantumBlockEncoding.GHL2025

/-!
# Guseynov-Huang-Liu 2025 Import Surface

This module is the paper-specific import surface for the first ABEIS faithful
reproduction case study.  The source-map and todo memory live in
`research-wiki/paper-contributions/GHL2025/`.

It intentionally re-exports only the stable contract-level paper file.  The
historical `RobinMatrix` proof-development file remains in the repository as an
optional research module, but it is no longer part of the default import surface
because it contains active proof obligations.
-/

namespace QuantumBlockEncoding
namespace Papers
namespace GHL2025

end GHL2025
end Papers
end QuantumBlockEncoding
