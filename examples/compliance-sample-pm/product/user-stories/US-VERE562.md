## US-VERE562 — Failed TEs must be retryable; successful TEs must be blocked...

| Field | Value |
|-------|-------|
| **ID** | US-VERE562 |
| **Traced from** | [VERE562](../compliances/SV/VERE562.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a patient, I want failed TEs is retryable; successful TEs is blocked from re-send, so that my enrollment is processed correctly.

### Acceptance Criteria

1. Given a failed TE, when retry is attempted, then re-send proceeds
2. Given a successful TE, when re-send is attempted, then it is blocked
