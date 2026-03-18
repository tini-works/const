## VSST543 — The HPM endpoints for medication information, substitutions, and lists must...

| Field | Value |
|-------|-------|
| **ID** | VSST543 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST543](../../user-stories/US-VSST543.md) |

### Requirement

The HPM endpoints for medication information, substitutions, and lists must be queried via HTTP POST using the patient's Hauptkassen-IK derived from the Kostentraegerdaten of the Selektivvertragsdefinition

### Acceptance Criteria

1. Given a medication query to HPM endpoints, when the query is executed, then it uses HTTP POST with the Hauptkassen-IK derived from the Selektivvertragsdefinition Kostentraegerdaten
