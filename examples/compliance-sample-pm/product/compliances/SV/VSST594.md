## VSST594 — The Vertragssoftware must display the patient's employment status and type...

| Field | Value |
|-------|-------|
| **ID** | VSST594 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST594](../../user-stories/US-VSST594.md) |

### Requirement

The Vertragssoftware must display the patient's employment status and type when issuing a work incapacity certificate (AU), with the ability to open and edit the documentation from the display

### Acceptance Criteria

1. Given an AU is being issued, when the patient view loads, then employment status and type are displayed with a link to edit the documentation
