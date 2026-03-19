## US-ABRD675 — Referral forms for FAV patients must include additional contract-specific text...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD675 |
| **Traced from** | [ABRD675](../compliances/SV/ABRD675.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | FRM, UBW, VTG |

### User Story

As a practice doctor, I want referral forms for FAV patients include additional contract-specific text fields, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a FAV-Patient with an Überweisung, when the form is generated, then contract-specific Zusatzfelder are present and fillable

### Actual Acceptance Criteria

1. The `schein` API supports referral schein creation for FAV patients with contract-specific data fields.
2. The `billing.GetContractTypeByIds` provides FAV referral form field requirements.
3. FAV Zusatzfelder rendering is handled at the form template level.
