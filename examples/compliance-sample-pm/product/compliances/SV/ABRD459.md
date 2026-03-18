## ABRD459 — Referral doctor LANR and BSNR must be required when contract...

| Field | Value |
|-------|-------|
| **ID** | ABRD459 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-2 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD459](../../user-stories/US-ABRD459.md) |

### Requirement

Referral doctor LANR and BSNR must be required when contract mandates them

### Acceptance Criteria

1. Given a Vertrag requiring Überweiser-LANR/BSNR, when a referral service is documented without them, then validation blocks submission
