## ABRG618 — All billing and prescription data by a substitute physician must...

| Field | Value |
|-------|-------|
| **ID** | ABRG618 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG618](../../user-stories/US-ABRG618.md) |

### Requirement

All billing and prescription data by a substitute physician must be transmitted with the substitute's LANR

### Acceptance Criteria

1. Given Vertreterarzt billing data, when transmitted, then the Vertreter-LANR is used in all relevant fields
