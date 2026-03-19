## US-FORM1413 — Hint when printing Muster 52.2

| Field | Value |
|-------|-------|
| **ID** | US-FORM1413 |
| **Traced from** | [FORM1413](../compliances/SV/FORM1413.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want hint when printing Muster 52.2, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given Muster 52.2 print triggered, when the print dialog opens, then a contract-specific hint is displayed

### Actual Acceptance Criteria

**Status: Partially implemented**

1. The Muster 52.2 form is defined as `Muster_52_2_V3` FormName constant and can be retrieved via `FormAPP.GetForm`
2. The `FormType_contract_hint` FormType exists in the domain model, providing infrastructure for contract-specific hints
3. The actual hint display when Muster 52.2 print is triggered is a client-side UI concern -- no backend endpoint specifically generates a print-time hint for Muster 52.2
