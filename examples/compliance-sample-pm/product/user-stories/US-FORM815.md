## US-FORM815 — If the 'Schnellinformation zur Patientenbegleitung' form is not printed, the...

| Field | Value |
|-------|-------|
| **ID** | US-FORM815 |
| **Traced from** | [FORM815](../compliances/SV/FORM815.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want if the 'Schnellinformation zur Patientenbegleitung' form is not printed, the Vertragssoftware display a confirmation dialog asking whether the user intentionally skips sending the quick information to the insurance, noting that early intervention may help mitigate illness consequences, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given the Schnellinformation form is not printed, when the user closes it, then a confirmation dialog asks whether the user intentionally skips, explaining that early insurer intervention may help

### Actual Acceptance Criteria

**Status: Not implemented**

1. No backend endpoint exists to trigger a confirmation dialog when the Schnellinformation form is not printed
2. This requirement is a client-side UI concern: the confirmation dialog asking whether the user intentionally skips sending the quick information must be implemented in the frontend/companion application
