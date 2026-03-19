## ABRG497 — Billing data must include required referral documentation for services that...

| Field | Value |
|-------|-------|
| **ID** | ABRG497 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG497](../../user-stories/US-ABRG497.md) |

### Requirement

Billing data must include required referral documentation for services that require referrals

### Acceptance Criteria

1. Given a Leistung requiring Überweisung, when billing data is generated, then referral documentation fields are included
