## US-FORM1479 — The Vertragssoftware must provide a function to fill, print, and...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1479 |
| **Traced from** | [FORM1479](../compliances/SV/FORM1479.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a function to fill, print, and save the 'Ueberleitungsmanagement' form per AKA-Basisdatei rules, supporting both Volldruck and Formulardruck; printing before filling all mandatory fields and intermediate saving is possible, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a patient, when the 'Ueberleitungsmanagement' form is opened, then it can be filled, printed (Volldruck or Formulardruck), and saved
2. Given mandatory fields are not yet filled, then printing is still allowed
3. Given intermediate state, then saving is possible
