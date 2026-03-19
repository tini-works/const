## HKS-7.1.4-02 — Practice doctor must document Ueberweisender Arzt hat HKS durchgefuehrt as Ja or Nein in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | HKS-7.1.4-02 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 7.1.4 -- HKS-D Ueberweisender Arzt |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-7.1.4-02](../../../../../user-stories/eDMP_HKS/US-HKS-7.1.4-02.md) |

### Requirement

As a practice doctor, I want to document whether the referring doctor performed the HKS screening (Ueberweisender Arzt hat HKS durchgefuehrt) as Ja or Nein in HKS-D documents, so that the referring physician's screening status is captured for quality assurance.

### Acceptance Criteria

1. Given an HKS-D document is created, when Ueberweisender Arzt hat HKS durchgefuehrt is recorded, then exactly one of Ja or Nein is selected
2. Given no value is selected, when validated, then an error is reported
