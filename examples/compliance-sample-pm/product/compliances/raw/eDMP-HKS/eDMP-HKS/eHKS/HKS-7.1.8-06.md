## HKS-7.1.8-06 — Practice doctor must document Histopathologie Aktinische Keratose as Ja or Nein in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | HKS-7.1.8-06 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 7.1.8 -- Histopathologie (Aktinische Keratose) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-7.1.8-06](../../../../../user-stories/eDMP_HKS/US-HKS-7.1.8-06.md) |

### Requirement

As a practice doctor, I want to document Histopathologie Aktinische Keratose as Ja or Nein in HKS-D documents, so that actinic keratosis histopathology findings are captured for pre-malignant lesion tracking.

### Acceptance Criteria

1. Given an HKS-D document is created, when Histopathologie Aktinische Keratose is recorded, then exactly one of Ja or Nein is selected
2. Given no value is selected, when validated, then an error is reported
