## ABRD936 — Blank billing codes must be correctly managed based on active/inactive...

| Field | Value |
|-------|-------|
| **ID** | ABRD936 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD936](../../user-stories/US-ABRD936.md) |

### Requirement

Blank billing codes must be correctly managed based on active/inactive status

### Acceptance Criteria

1. Given a Blanko-Abrechnungscode, when its status is inactive, then it cannot be used for billing
2. When active, then it is selectable
