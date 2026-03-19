## US-ALLG1385 — For FaV, system must provide access to medi-verbund.de for current...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1385 |
| **Traced from** | [ALLG1385](../compliances/SV/ALLG1385.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want for FaV, system provide access to medi-verbund.de for current contract documents, so that general compliance requirements are met.

### Acceptance Criteria

1. Given a FaV-Vertrag, when the user requests contract documents, then a link to medi-verbund.de opens

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. A `ContractInformationUrl` field concept exists in the AKA XML data, but no code was found that specifically handles FaV contracts to provide access to medi-verbund.de.
2. No medi-verbund.de URL handling or link-opening logic was found in the codebase.
3. **Gap**: For FaV contracts, the system does not provide access to medi-verbund.de for current contract documents.
