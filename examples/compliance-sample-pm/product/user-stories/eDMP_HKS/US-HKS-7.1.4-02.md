## US-HKS-7.1.4-02 — Practice doctor must document Ueberweisender Arzt hat HKS durchgefuehrt as Ja or Nein in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | US-HKS-7.1.4-02 |
| **Traced from** | [HKS-7.1.4-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-7.1.4-02.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the referring doctor performed the HKS screening (Ueberweisender Arzt hat HKS durchgefuehrt) as Ja or Nein in HKS-D documents, so that the referring physician's screening status is captured for quality assurance.

### Acceptance Criteria

1. Given an HKS-D document is created, when Ueberweisender Arzt hat HKS durchgefuehrt is recorded, then exactly one of Ja or Nein is selected
2. Given no value is selected, when validated, then an error is reported
