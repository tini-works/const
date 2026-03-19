## HKS-7.1.8-01 — Practice doctor must document Histopathologie Malignes Melanom with Klassifikation and Tumordicke Breslow in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | HKS-7.1.8-01 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 7.1.8 -- Histopathologie (Melanom) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-7.1.8-01](../../../../../user-stories/eDMP_HKS/US-HKS-7.1.8-01.md) |

### Requirement

As a practice doctor, I want to document Histopathologie Malignes Melanom as Ja or Nein in HKS-D documents, and when Ja, to record Klassifikation (in situ or invasiv) and Tumordicke nach Breslow, so that malignant melanoma histopathology findings are captured with classification and thickness.

### Acceptance Criteria

1. Given an HKS-D document is created, when Histopathologie Malignes Melanom is Ja, then Klassifikation (in situ or invasiv) is selected
2. Given Klassifikation is invasiv, when documented, then Tumordicke nach Breslow (mm) is recorded
3. Given Histopathologie Malignes Melanom is Nein, then no sub-fields are required
