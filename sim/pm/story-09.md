# Story 09 — Monday Morning Crush (Performance Issue)

## Customer's Words (Receptionist)

> "Monday mornings are a nightmare. Between 8 and 9 AM we get 30 patients checking in at once. The kiosk screens freeze, the search takes forever, and half the time I just tell people to sit down and I'll call them when the system catches up. We've lost two patients this month — they just left."

## What the Customer Is Saying

1. **"30 patients checking in at once"** — Burst load. The system was likely sized for average throughput, not peak. 30 concurrent check-ins in a 60-minute window = one every 2 minutes, but they likely arrive in clusters (opening rush).

2. **"Kiosk screens freeze"** — Client-side failure under load. Either the backend is slow (API timeouts causing UI freeze) or the kiosk devices themselves are underpowered for concurrent WebSocket connections + rendering.

3. **"Search takes forever"** — The patient lookup (S1) degrades under concurrent load. Engineer's BOX-01 specifies <200ms for typeahead. This is broken at 30 concurrent users.

4. **"I just tell people to sit down"** — The receptionist has abandoned the system. They've reverted to a manual workflow. The system has failed its core purpose.

5. **"We've lost two patients this month — they just left"** — Business impact. Patient churn due to wait times. This is no longer a UX complaint — it's revenue loss.

## Impact Assessment

- **BOX-01 (returning patient recognized):** Fails when search is degraded
- **BOX-04 (experience communicates recognition):** Fails when kiosks freeze
- **BOX-E1 (no data loss on timeout):** Under load, timeouts may increase. Are per-section saves still completing?
- **Engineer's <200ms search target:** Broken at peak load

## Sizing Requirements

For a single location with the Round 05 second location:
- Peak: 30 patients / hour / location = 60 concurrent check-ins system-wide
- Each check-in: 1 search query + 3-5 section confirmation writes + WebSocket connection
- Write burst: 60 sessions x 4 writes = 240 writes in the peak hour, clustered in the first 15 minutes

For Round 10 (acquisition of 4,000-patient practice): the peak load multiplies further.

## Relationship to Other Stories

- S-03 (mobile pre-check-in) would directly alleviate this. Patients who pre-check-in from home don't need the kiosk.
- S-05 (second location) doubles the potential peak if both locations have Monday morning rushes.
- S-10 (acquisition) adds 4,000 patients to the database, increasing search index size and query time.
