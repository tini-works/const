## US-HKS-5.0-01 — Practice software must support four eHKS document types: HKS-A, HKS-A-EV, HKS-D, HKS-D-EV

| Field | Value |
|-------|-------|
| **ID** | US-HKS-5.0-01 |
| **Traced from** | [HKS-5.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-5.0-01.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to support generation of all four eHKS document types: HKS-A (Allgemeinarzt), HKS-A-EV (Allgemeinarzt Erstverordnung), HKS-D (Dermatologe), and HKS-D-EV (Dermatologe Erstverordnung), so that all screening and referral document workflows are supported.

### Acceptance Criteria

1. Given a skin cancer screening is performed by a general practitioner, when an eHKS document is created, then HKS-A or HKS-A-EV document type is available
2. Given a skin cancer screening is performed by a dermatologist, when an eHKS document is created, then HKS-D or HKS-D-EV document type is available
3. Given a document type other than HKS-A, HKS-A-EV, HKS-D, or HKS-D-EV is selected, when validated, then an error is reported
