## US-ALLG662 — Users must be able to access all contract documents marked...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG662 |
| **Traced from** | [ALLG662](../compliances/SV/ALLG662.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want users is able to access all contract documents marked as "Public" per AKA base data file, so that general compliance requirements are met.

### Acceptance Criteria

1. Given AKA Basisdaten with "Öffentlich" marked documents, when the user requests them, then all public documents are accessible

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. The contract service provides `GetAllHints` and `GetAllLeaflets` methods that filter attachments (Anlagen) by type, but there is no filter for "Public" (Offentlich) marked documents.
2. No "Offentlich" or "Public" flag filtering was found in the attachment retrieval logic.
3. **Gap**: Users cannot specifically access documents marked as "Public" per the AKA base data file. The attachment system exists but lacks the public/private visibility distinction.
