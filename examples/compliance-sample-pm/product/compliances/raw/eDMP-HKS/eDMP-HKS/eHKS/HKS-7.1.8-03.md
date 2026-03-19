## HKS-7.1.8-03 — Practice doctor must document Histopathologie Spinozellulaeres Karzinom with Klassifikation and Grading in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | HKS-7.1.8-03 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 7.1.8 -- Histopathologie (Spinozellulaer) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-7.1.8-03](../../../../../user-stories/eDMP_HKS/US-HKS-7.1.8-03.md) |

### Requirement

As a practice doctor, I want to document Histopathologie Spinozellulaeres Karzinom as Ja or Nein in HKS-D documents, and when Ja, to record Klassifikation (in situ or invasiv) and Grading (Gx, G1, G2, G3, G4), so that squamous cell carcinoma histopathology findings are captured with classification and grading.

### Acceptance Criteria

1. Given an HKS-D document is created, when Histopathologie Spinozellulaeres Karzinom is Ja, then Klassifikation (in situ or invasiv) is selected
2. Given Klassifikation is invasiv, when documented, then Grading is one of Gx, G1, G2, G3, or G4
3. Given Histopathologie Spinozellulaeres Karzinom is Nein, then no sub-fields are required
