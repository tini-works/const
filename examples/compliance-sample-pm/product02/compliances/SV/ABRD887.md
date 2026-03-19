## ABRD887 — System must warn when the same diagnosis with certainty 'V'...

| Field | Value |
|-------|-------|
| **ID** | ABRD887 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-4 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD887](../../user-stories/US-ABRD887.md) |

### Requirement

System must warn when the same diagnosis with certainty 'V' (suspected) appears across multiple quarters

### Acceptance Criteria

1. Given a Verdachtsdiagnose ('V') present in 2+ consecutive Quartale, when the user opens the Diagnose, then a review warning is shown
