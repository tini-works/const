## US-ABRD1416 — OPS code 5035 must be required for specialty service codes...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD1416 |
| **Traced from** | [ABRD1416](../compliances/SV/ABRD1416.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want oPS code 5035 is required for specialty service codes E3a/A3a/E3b/A3b/E4a/A4a/E4b/A4b/E5a/A5a/E5b/A5b, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a specialty code (E3a, A3a, etc.) documented, when OPS 5035 is missing, then validation blocks with a mandatory-OPS error

### Actual Acceptance Criteria

1. Implemented -- `ABRD1416Validator` requires OPS 5035 for specialty codes.
