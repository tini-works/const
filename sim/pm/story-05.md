# Story 05 — Second Clinic Location (Business Change)

## Customer's Words (Clinic Administrator)

> "We're opening a second location across town next month. Some patients will visit both. Their info needs to be the same at both clinics — I don't want patients re-entering everything just because they walked into the other building."

## What the Customer Is Saying

1. **"Some patients will visit both"** — Not all patients, but a meaningful subset will float between locations. The system must treat them as one patient, not create location-specific silos.

2. **"Their info needs to be the same at both clinics"** — Data synchronization across locations. A patient who updates their insurance at Location A should see that update reflected at Location B.

3. **"I don't want patients re-entering everything"** — The administrator is aware of the S-01 problem and wants to prevent it from reappearing in a multi-location context. They're pre-empting the complaint.

## What the Customer Is NOT Saying

- They're not describing different practice groups or organizations. This is one practice with two physical locations.
- They're not asking for location-specific workflows (yet). Same check-in process, just multiple places.
- They're not addressing staff sharing. Do receptionists work at both locations? Separate staff per location?

## Answers This Provides to Open Questions

This directly answers PM's open question from boxes-01.md: **"If the clinic has multiple locations, does data persist across locations?"** — YES, confirmed by the administrator.

This also answers Design's open question #3 from negotiation-s01.md: **"Multi-location — PM flagged. For this round, I'm designing as if data persists across locations."** — Design's assumption was correct.

Engineer's BOX-E4 (search index eventual consistency) becomes more critical. If a patient updates data at Location A, the search index at Location B must reflect it. The <2s lag target may need to be validated across locations.

## Architectural Implications

- **Centralized vs. distributed data** — One database serving both locations, or replicated databases? This is an engineering decision, but the box is: patient data is identical regardless of which location queries it.
- **Location-aware workflows** — Appointments are per-location. Patient records are cross-location. These are different data domains with different locality rules.
- **Staff access scope** — Can Location A's receptionist see that a patient was checked in at Location B today? Probably yes, to avoid confusion, but this needs confirmation.
