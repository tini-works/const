## US-VSST1020 — eDMP transmission

| Field | Value |
|-------|-------|
| **ID** | US-VSST1020 |
| **Traced from** | [VSST1020](../compliances/SV/VSST1020.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want eDMP transmission, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given eDMP data ready, when transmission is triggered, then the data is sent to the DMP-Datenstelle

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/edmp`, `api/mail`

1. **eDMP billing and transmission** -- The `edmp` package implements full DMP billing workflow: `CheckValidationForDMPBilling`, `SendKIMMail`, `SendKVForDMPBilling`, `SendMailRetry`, `ZipDMPBillingHistories`.
2. **KIM mail integration** -- DMP data is transmitted to the DMP-Datenstelle via KIM mail through the `mail` service.
3. **Billing history** -- `GetDMPBillingHistories` tracks all DMP transmissions.
