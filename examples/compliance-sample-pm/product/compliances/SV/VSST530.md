## VSST530 — The Vertragssoftware must prevent transmission of Hilfsmittelverordnungen (medical device prescriptions)

| Field | Value |
|-------|-------|
| **ID** | VSST530 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST530](../../user-stories/US-VSST530.md) |

### Requirement

The Vertragssoftware must prevent transmission of Hilfsmittelverordnungen (medical device prescriptions)

### Acceptance Criteria

1. Given a Hilfsmittelverordnung, when prescription data transmission runs, then Hilfsmittel prescriptions are excluded from the transmission
