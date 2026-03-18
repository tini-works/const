## FORM938 — When opening the 'Schnellinformation zur Patientenbegleitung' form, a hint window...

| Field | Value |
|-------|-------|
| **ID** | FORM938 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.5 FORM — Form Management |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Form output check |
| Matched by | [US-FORM938](../../user-stories/US-FORM938.md) |

### Requirement

When opening the 'Schnellinformation zur Patientenbegleitung' form, a hint window must appear stating: 'To bill the Patientenbegleitung service, the patient's signature on the Patientenmerkblatt is mandatory. Please hand it to the patient and have them sign it.'

### Acceptance Criteria

1. Given the Schnellinformation form is opened, when it loads, then a hint window appears stating the Patientenmerkblatt signature requirement for billing the Patientenbegleitung service
