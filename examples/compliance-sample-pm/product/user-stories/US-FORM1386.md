## US-FORM1386 — When the user documents a confirmed diagnosis (acute or permanent)...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1386 |
| **Traced from** | [FORM1386](../compliances/SV/FORM1386.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want when I documents a confirmed diagnosis (acute or permanent) from the AKA-Basisdatei Diagnosenliste for a contract participant, a hint is displayed: 'Please check the use of...', so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a confirmed diagnosis from the AKA Diagnosenliste documented for a participant, when the diagnosis is saved, then a hint 'Bitte pruefen Sie den Einsatz von...' is displayed

### Actual Acceptance Criteria

**Status: Partially implemented**

1. The `FormType_contract_hint` FormType constant exists in the form domain model (`form_common.d.go`), providing infrastructure for contract-specific hint display
2. The actual hint display ('Bitte pruefen Sie den Einsatz von...') triggered when a confirmed AKA-Basisdatei diagnosis is documented must be implemented as a client-side UI behavior
3. No backend endpoint explicitly triggers hint display on diagnosis save events
