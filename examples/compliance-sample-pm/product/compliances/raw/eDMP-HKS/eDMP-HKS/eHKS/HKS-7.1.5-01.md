## HKS-7.1.5-01 — Practice doctor must document Angabe Verdachtsdiagnose ueberweisender Arzt with conditional blocks in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | HKS-7.1.5-01 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 7.1.5 -- Verdachtsdiagnose ueberweisend |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-7.1.5-01](../../../../../user-stories/eDMP_HKS/US-HKS-7.1.5-01.md) |

### Requirement

As a practice doctor, I want to document Angabe Verdachtsdiagnose ueberweisender Arzt as Ja or Nein in HKS-D documents, with conditional sub-diagnosis blocks when Ja, so that the referring physician's suspected diagnosis is captured for diagnostic continuity.

### Acceptance Criteria

1. Given an HKS-D document is created and Angabe Verdachtsdiagnose ueberweisender Arzt is Ja, when the conditional block is presented, then the referring doctor's suspected diagnosis details are recorded
2. Given Angabe Verdachtsdiagnose ueberweisender Arzt is Nein, then no sub-diagnosis block is required
3. Given Ja is selected but the conditional sub-diagnosis block is empty, when validated, then an error is reported
