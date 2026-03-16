# QA — VP-99 Was a False Proof

## What happened

VP-99 said: "Export to PDF generates valid PDF." Status: passing. It had been passing for 14 months straight, including the 8 months after the PDF library died.

VP-99 was a lie. QA's inventory showed "proven" for a feature that was broken in production. That's the failure.

## Post-mortem: why VP-99 was false

**The mechanism:** Unit test with a mocked PDF library. The mock returns a synthetic PDF buffer. The test asserts: (a) the export endpoint returns 200, (b) the response body is non-empty, (c) the content-type header is `application/pdf`.

**What the mock hides:** The mock doesn't call the real PDF library. It doesn't know the library was deprecated. It doesn't know the library returns empty payloads. The mock produces the same synthetic buffer every time, regardless of the real world.

**What was missing:** No companion integration test. No production degradation signal. Nothing that touches the real dependency. VP-99 was mock-only proof for an external dependency — the one configuration that can never detect a dependency death.

**Verify:** Review the deleted test file. The test imported a mock (`jest.mock('pdf-library')` or equivalent), never the real library. No integration test existed for this flow. No production alert was configured for export success/failure rates.

## The three failures that enabled the ghost

| Failure | Role | What should have existed |
|---------|------|-------------------------|
| Mock hid dead dependency | QA | Integration test or degradation signal paired with the mock |
| No production signal on export | DevOps | Success/failure rate alert on the export endpoint |
| No staleness reconciliation | Engineer | Periodic check: is this flow still alive? |

All three had to fail for the ghost to survive 8 months undetected. Any one of them catching it would have surfaced the problem.

## What was removed

- VP-99 verification path: deleted. The feature is removed, so the proof is removed.
- Mocked test suite for PDF export: deleted. Tests for dead code are worse than no tests — they generate false confidence.

**Verify:** Run the full test suite after deletion. It passes. No test file references the export flow. The test count dropped by the exact number of export-related tests, and zero other tests broke.

## New rule: no mock-only proofs for external dependencies

A mock that passes while the real dependency is dead is not a proof. It's a false proof — actively harmful because it reports "proven" for something that's broken.

**The rule:** Every mocked test for an external dependency must pair with at least one of:

**(a) A companion integration test** that hits the real dependency in a test environment. This catches dependency deaths, API changes, and response format changes that the mock can't see.

**(b) A production degradation signal** that fires when the dependency changes behavior. Success rate drops, response shape changes, latency spikes — any of these would have caught the PDF library death within hours, not months.

Mock-only is not allowed. If neither (a) nor (b) can be provided, the proof is marked "unverified" and escalated.

**Verify:** Audit the current proof inventory. For every VP that uses a mock against an external dependency, confirm it has either a companion integration test or a production signal. Any VP that has neither is flagged for remediation. As of this cleanup, the remaining VPs (VP-12 dashboard, VP-15 email digest) both have integration tests and production signals. Zero mock-only external dependency proofs remain.
