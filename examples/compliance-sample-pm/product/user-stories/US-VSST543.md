## US-VSST543 — The HPM endpoints for medication information, substitutions, and lists must...

| Field | Value |
|-------|-------|
| **ID** | US-VSST543 |
| **Traced from** | [VSST543](../compliances/SV/VSST543.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the HPM endpoints for medication information, substitutions, and lists is queried via HTTP POST using the patient's Hauptkassen-IK derived from the Kostentraegerdaten of the Selektivvertragsdefinition, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a medication query to HPM endpoints, when the query is executed, then it uses HTTP POST with the Hauptkassen-IK derived from the Selektivvertragsdefinition Kostentraegerdaten
