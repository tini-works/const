## US-FORM1414 — Hint when filling Muster 52.2

| Field | Value |
|-------|-------|
| **ID** | US-FORM1414 |
| **Traced from** | [FORM1414](../compliances/SV/FORM1414.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT |

### User Story

As a practice staff (MFA), I want hint when filling Muster 52.2, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given Muster 52.2 being filled, when the user opens the form, then a filling-guidance hint is displayed

### Actual Acceptance Criteria

**Status: Partially implemented**

1. The Muster 52.2 form (`Muster_52_2_V3` FormName constant) is retrievable and fillable via `FormAPP.GetForm`
2. The `FormType_contract_hint` FormType exists in the domain model for hint infrastructure
3. The actual filling-guidance hint display when Muster 52.2 is opened is a client-side UI concern -- no backend endpoint specifically generates a fill-time hint for Muster 52.2
