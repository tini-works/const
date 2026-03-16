# Proof Registry

Every claim of "it works" has a test, a way to run it, and a way to know when it stops working. If it's not here, it's not proven.

**Proven: 15/15 paths (100%)** | 0 false proofs | 1 known coverage gap

---

## Active Verification Paths

### Check-In

| ID | What we're proving | How | What tells us it broke |
|----|--------------------|-----|----------------------|
| VP-01 | Returning patient, no changes → confirm flow completes, no staff review | Integration test: test patient, no mutations | Review queue false positive monitor |
| VP-02 | Returning patient, insurance changed → staff review populated | Integration test: mutate insurance field | Queue miss rate monitor |
| VP-03 | Allergy data >6mo stale → re-confirmation screen appears | Integration test: backdated allergy record | Allergy-fetch age header monitor |
| VP-04 | New patient → full intake still works (regression) | Existing intake test suite | Existing monitors |

### Payment

| ID | What we're proving | How | What tells us it broke |
|----|--------------------|-----|----------------------|
| VP-10 | Expired card → "card problem" message + update CTA | Integration test: expiry-triggering test card | Alert: unmatched gateway error codes |
| VP-11 | Temporary decline → "temp issue" + retry CTA | Integration test: decline-triggering test card | Retry success rate monitor |
| VP-12 | Unknown error → generic message + correlation ID shown | Integration test: malformed gateway response | Alert: unknown-category rate >5% |
| VP-13 | Error state preserves cart and shipping info | Trigger error, navigate back, assert cart intact | Cart-loss event monitor |
| VP-14 | Three rapid retries → single charge only | 3 concurrent requests, same idempotency key | Duplicate charge alert (reconciliation feed) |

### Auth (post-migration)

| ID | What we're proving | How | What tells us it broke |
|----|--------------------|-----|----------------------|
| VP-30 | No service accepts v1 tokens after grace period | Regression test: v1 token → 401 | Alert: v1 tokens seen in production |

### Appearance

| ID | What we're proving | How | What tells us it broke |
|----|--------------------|-----|----------------------|
| VP-40 | Toggle switches modes, preference persists across sessions | E2E: toggle, close, reopen, assert mode | localStorage clear event monitor |
| VP-41 | 12 primary surfaces render correctly in reduced brightness | Screenshot diffing against approved baselines | Visual regression CI on every deploy |
| VP-42 | Non-tokenized surfaces meet WCAG AA in reduced brightness | Automated contrast ratio check | **Known gap:** new hardcoded colors bypass overlay |
| VP-43 | No regression in light mode | Existing visual regression suite | Existing monitors |

### Service-Level (auth migration tracking)

| Service | Re-verified? | Token version | Notes |
|---------|-------------|---------------|-------|
| Service A | Yes (day 3) | v2 | Early adopter |
| Service B | Yes (day 5) | v2 (was v1 during grace) | Migrated before deadline |
| Service C | Yes (day 20) | v2 | Late but clean |
| Service D | Yes (day 22) | v2 | Had pre-existing broken tests, fixed first |

## Removed

| ID | What | Why |
|----|------|-----|
| VP-99 | Export to PDF generates valid PDF | **Was a false proof.** Mocked the PDF library. Mock passed for 8 months while real dep was dead. Feature removed. |

## Known Coverage Gaps

| Gap | Risk | Resolves when |
|-----|------|--------------|
| VP-42: new hardcoded colors bypass opacity overlay | New colors added by engineers won't be covered by reduced-brightness mode | Design token system ships (REQ-404) |

## Rules we learned the hard way

| Rule | What happened without it |
|------|------------------------|
| **No mock-only proofs for external dependencies.** Every mock needs a companion integration test OR a production degradation signal. | PDF export: mocked test passed for 8 months. Real library was dead. Nobody knew. |
| **Verification paths test what, not how.** Paths must survive implementation rewrites. | Order processing: Python → Go rewrite. All 47 paths passed without modification. If we'd tested Python internals, we'd have rewritten 47 tests too. |
| **Read the customer's story, not just the requirements.** | Payment: customer said "I tried three times." That sentence created VP-14 (idempotency). A clean requirement like "handle payment errors" wouldn't have surfaced it. |
| **When a flow goes SUSPECT, re-verify — don't assume.** | Auth migration: Service D was flagged suspect, re-verification revealed pre-existing broken tests from before the migration. The suspect flag exposed rot that was already there. |

## What QA protects daily

1. **Every row in this registry must have all three columns filled.** What we're proving. How we prove it. What tells us the proof went stale. Missing any column = not actually proven.
2. **False proofs are worse than no proof.** A mocked test that passes while the real system is broken gives everyone false confidence. We ship broken things and don't know until customers complain.
3. **Coverage gaps are documented, not hidden.** VP-42 has a known gap. It's written here. When someone asks "is reduced brightness fully proven?" the answer is "yes, with one documented gap." Honesty over theater.
