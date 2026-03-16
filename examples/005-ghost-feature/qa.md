# QA Inventory — 005 Ghost Feature Removal

## Proof Registry Failure Exposed

| ID | Path | Mechanism | Degradation signal | Actual status |
|----|------|-----------|-------------------|---------------|
| VP-99 | Export to PDF generates valid PDF | Unit test with **mocked** PDF library | **None** | **FALSE PROOF** |

The mock passes forever. The real library died 8 months ago. QA's registry showed "proven" for a broken feature.

This is a QA-level failure: proof mechanism disconnected from reality, no degradation signal.

## Verification Paths Removed

| ID | Path | Reason |
|----|------|--------|
| VP-99 | Export to PDF | Feature removed from all inventories |

Mocked test suite for PDF export deleted.

## Systemic Rule Added

**No mock-only proofs for external dependencies.** Every mocked test must have either:

1. A companion integration test hitting the real dependency, **OR**
2. A production degradation signal that fires when the dependency changes or dies

A mock that passes while the real dependency is dead is a proof-shaped lie.
