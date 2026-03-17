# Design Negotiation — Story 05 (Second Clinic Location)

## Context

Business change. The clinic is opening a second location next month. Patients may visit both. Data must be the same everywhere.

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-19: Patient data is location-independent | **Accepted — no new screens needed** | This is an infrastructure/data box. From Design's perspective, the screens already show patient data without location awareness. The data layer handles it. My screens don't change for this box. |
| BOX-20: Check-in works at any location for any patient | **Accepted — no screen changes** | S1 search already returns all patients. If the data layer serves all patients regardless of origin location, S1 works unchanged. |
| BOX-21: Location is a context, not a boundary | **Accepted with design addition** | This one DOES have design impact. If location is a context, the receptionist needs to know which location they're operating in. And the queue (S5) should show only this location's sessions, not all locations' sessions. Location is a filter, not a data boundary. |

## Boxes I'm Adding

### BOX-D11: Receptionist sees their current location context

The receptionist's UI must show which location they are operating at. This is a persistent header element: "Location: Main Street Clinic" or "Location: Riverside Office." This prevents confusion when the same receptionist works at multiple locations.

**Why this matters:** Without a location indicator, a receptionist could start a check-in session thinking they're at Location A when the system is configured for Location B. Appointments are per-location (BOX-21) — the wrong location context means wrong appointment matching.

**Design:** Location indicator in the app header. Set during login or device configuration (kiosks are permanently assigned to a location). Not changeable mid-session.

### BOX-D12: Queue view (S5) filters by location with cross-location visibility option

By default, the check-in queue (S5) shows only this location's sessions. But the receptionist should be able to toggle a "view all locations" mode — useful for coordination ("Is Mrs. Rodriguez currently checking in at the other location?").

**Why this matters:** BOX-E5 (concurrent check-in prevention) is cross-location. If the receptionist at Location B tries to check in a patient who's already being checked in at Location A, they need to see the blocking session's location. The queue toggle makes this visible.

## Design Changes Required

1. **App header modification** — Add persistent location indicator
2. **S5 (Queue) modification** — Add location filter toggle (this location / all locations)
3. **S2 modification** — Add "last visit location" to patient quick facts (useful context: "I see you usually visit our Main Street location")

## Push-back to PM

1. **PM's open question about staff access scope** — I'm answering it: yes, receptionist can see cross-location sessions. The default view is filtered to their location, but they can toggle to see all. This is necessary for BOX-E5 (concurrent prevention) to make sense to the user.

2. **No design changes for the patient.** The patient doesn't know or care about locations from a system perspective. They walk in, they check in, their data is there. The multi-location architecture is invisible to the patient UX. This is correct — location is an operational concern, not a patient experience concern.
