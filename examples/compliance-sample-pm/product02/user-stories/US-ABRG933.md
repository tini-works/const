## US-ABRG933 — System must automatically display the transmission protocol as PDF after...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG933 |
| **Traced from** | [ABRG933](../compliances/SV/ABRG933.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want automatically display the transmission protocol as PDF after successful billing, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given successful billing transmission, when the process completes, then a PDF Übertragungsprotokoll is automatically displayed

### Actual Acceptance Criteria

1. Implemented. The `BillingApp.GetBillingPDF` operation in `backend-core/app/app-core/api/billing/billing.d.go` retrieves billing PDFs by `BillingHistoryId` and `IndexFile`. The `BillingApp.DownloadAllProtocols` supports bulk PDF protocol download. The `BillingSubmissionResponse` event notifies the user upon completion, enabling automatic display of the transmission protocol.
