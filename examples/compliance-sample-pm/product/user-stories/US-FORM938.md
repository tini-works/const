## US-FORM938 — When opening the 'Schnellinformation zur Patientenbegleitung' form, a hint window...

| Field | Value |
|-------|-------|
| **ID** | US-FORM938 |
| **Traced from** | [FORM938](../compliances/SV/FORM938.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want when opening the 'Schnellinformation zur Patientenbegleitung' form, a hint window appear stating: 'To bill the Patientenbegleitung service, the patient's signature on the Patientenmerkblatt is mandatory. Please hand it to the patient and have them sign it.', so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given the Schnellinformation form is opened, when it loads, then a hint window appears stating the Patientenmerkblatt signature requirement for billing the Patientenbegleitung service

### Actual Acceptance Criteria

**Status: Not implemented**

1. No backend endpoint exists to display a hint window when the Schnellinformation form is opened
2. The `FormType_contract_hint` FormType constant exists in the form domain model, suggesting the infrastructure for contract hints is partially in place
3. The actual hint display ('Patientenmerkblatt signature required for Patientenbegleitung billing') must be implemented as a client-side UI behavior triggered when the form loads
