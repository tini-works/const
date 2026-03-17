# Design Boxes — Complete Registry

All boxes originated by Design, across 10 rounds of negotiation.

---

## Round 1 (S-01: Returning Patient Recognition)

| ID | Box | Status |
|----|-----|--------|
| BOX-D1 | Recognition failure has a graceful path | Matched (S1b). Stress-tested by S-10 migration. |
| BOX-D2 | Receptionist and patient see purpose-appropriate views | Matched (S2/S3R vs S3P). Extended in S-02. |
| BOX-D3 | Partial data handled without confusion | Matched (S3P "We still need" section). Relevant to S-10 imports. |

## Round 2 (S-02: Receptionist Blind)

| ID | Box | Status |
|----|-----|--------|
| BOX-D4 | Receptionist sees connection health | Matched (S3R connection indicator). |
| BOX-D5 | Patient completion produces unambiguous visual event | Matched (S3R notification event + pulse). |

## Round 3 (S-03: Mobile Pre-Check-In)

| ID | Box | Status |
|----|-----|--------|
| BOX-D6 | Mobile flow is responsive, not a separate app | Matched (S3P responsive layout). |
| BOX-D7 | Pre-check-in includes "what happens next" feedback | Matched (S4 mobile variant). |
| BOX-D8 | Partial pre-check-in is handled across devices | Matched (S2 partial status, S3P progress restore). |

## Round 4 (S-04: Data Breach / HIPAA)

| ID | Box | Status |
|----|-----|--------|
| BOX-D9 | Kiosk has a distinct idle state (Welcome Screen) | Matched (S0). |
| BOX-D10 | Screen transitions never show intermediate data states | Matched (S0 as gate, data loads behind it). |

## Round 5 (S-05: Second Location)

| ID | Box | Status |
|----|-----|--------|
| BOX-D11 | Receptionist sees current location context | Matched (app header location indicator). |
| BOX-D12 | Queue filters by location with cross-location toggle | Matched (S5 location filter). |

## Round 6 (S-06: Medication Mandate)

| ID | Box | Status |
|----|-----|--------|
| BOX-D13 | Medication confirmation cannot be conflated with scrolling | Matched (explicit "I confirm" button with activation delay). |
| BOX-D14 | Empty medication list is explicitly confirmed | Matched ("No, I am not taking any medications" as affirmative action). |

## Round 7 (S-07: Concurrent Check-In Bug)

| ID | Box | Status |
|----|-----|--------|
| BOX-D15 | Concurrent blocking message is informative | Matched (S2 concurrent state with who/when/status/location). |
| BOX-D16 | Conflict at finalization shows both sessions | Matched (S8 side-by-side comparison). |

## Round 8 (S-08: Insurance Photo Upload)

| ID | Box | Status |
|----|-----|--------|
| BOX-D17 | Photo capture has clear framing guidance | Matched (camera overlay with card frame). |
| BOX-D18 | Manual entry remains available as fallback | Matched ("Enter manually" option on capture screen). |

## Round 9 (S-09: Monday Morning Crush)

| ID | Box | Status |
|----|-----|--------|
| BOX-D19 | Patient never sees system load state | Matched (generic error messages, no load indicators on patient screens). |
| BOX-D20 | Queue view shows wait time and queue depth | Matched (S5 header metrics during busy/peak). |

## Round 10 (S-10: Riverside Acquisition)

| ID | Box | Status |
|----|-----|--------|
| BOX-D21 | Duplicate review supports confidence tiers | Matched (S11 confidence filters). |
| BOX-D22 | Import dashboard shows real-time progress | Matched (S10 progress dashboard). |
| BOX-D23 | Merged record shows provenance | Matched (S12 source tagging, S3P import note). |

---

## Summary

- **Total Design boxes:** 23 (BOX-D1 through BOX-D23)
- **All matched:** Yes. Every box has at least one screen that implements it.
- **Pattern:** Design boxes fall into three categories:
  1. **Failure paths PM missed** (D1, D4, D5, D10, D15, D16, D17, D18, D19) — what happens when things go wrong
  2. **UX specificity PM can't see** (D2, D3, D6, D7, D8, D9, D13, D14, D20) — concrete interaction design that PM's boxes leave abstract
  3. **Operational context** (D11, D12, D21, D22, D23) — system information the user needs to do their job
