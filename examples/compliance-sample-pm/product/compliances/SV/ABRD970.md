## ABRD970 — Care facility name and location must be required for home...

| Field | Value |
|-------|-------|
| **ID** | ABRD970 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-2 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD970](../../user-stories/US-ABRD970.md) |

### Requirement

Care facility name and location must be required for home visit services

### Acceptance Criteria

1. Given a Hausbesuch-Leistung, when facility name/location is missing, then validation blocks submission
