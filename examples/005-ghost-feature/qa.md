# QA — Proof Registry

## Active Proofs

| ID | Path | Mechanism | Degradation signal | Status |
|----|------|-----------|--------------------|--------|
| VP-12 | Dashboard loads aggregated data | Integration test + Datadog latency | Alert on p99 > 2s | Active |
| VP-15 | Email digest delivered | E2E test + delivery webhook | Alert on bounce > 5% | Active |
| ~~VP-99~~ | ~~PDF export generates valid PDF~~ | ~~Unit test (mocked)~~ | ~~None~~ | **Removed — false proof** |

## VP-99 Post-Mortem

VP-99 was a false proof. The test mocked the PDF library. The mock passed while the real dependency was dead for 8 months. No degradation signal existed to catch it.

QA's registry showed "proven" for a broken feature. That's the failure.

## Removed

- Mocked test suite for PDF export deleted
- VP-99 removed from proof registry

## New Rule

**No mock-only proofs for external dependencies.** Every mocked test must pair with either:

1. A companion integration test hitting the real dependency, OR
2. A production degradation signal that fires when the dependency changes or dies

A mock that passes while the real dependency is dead is not a proof.
