# Proof Registry — Patient Check-In

**Proven: 4/4 paths (100%)** | 0 false proofs | 0 coverage gaps

---

## Verification Paths

| ID | What we're proving | How | What tells us it broke |
|----|--------------------|-----|----------------------|
| VP-01 | Returning patient, no changes → confirm flow completes, no staff review | Integration test: test patient, no mutations | Review queue false positive monitor |
| VP-02 | Returning patient, insurance changed → staff review populated | Integration test: mutate insurance field | Queue miss rate monitor |
| VP-03 | Allergy data >6mo stale → re-confirmation screen appears | Integration test: backdated allergy record | Allergy-fetch age header monitor |
| VP-04 | New patient → full intake still works (regression) | Existing intake test suite | Existing monitors |

All three columns filled for every row. If any column is empty, we don't actually have proof.

## Coverage

| Requirement | Verification paths | Degradation signal? |
|-------------|-------------------|-------------------|
| REQ-101 (pre-fill) | VP-01, VP-02 | Yes |
| REQ-102 (persistence) | VP-01, VP-02, VP-03 | Yes |
| REQ-103 (confirm flow) | VP-01 | Yes |
| REQ-104 (allergy staleness) | VP-03 | Yes |

Full coverage. Every requirement has a path, a mechanism, and a degradation signal.
