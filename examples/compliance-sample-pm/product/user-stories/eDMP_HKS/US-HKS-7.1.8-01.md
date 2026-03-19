## US-HKS-7.1.8-01 — Practice doctor must document Histopathologie Malignes Melanom with Klassifikation and Tumordicke Breslow in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | US-HKS-7.1.8-01 |
| **Traced from** | [HKS-7.1.8-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-7.1.8-01.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Histopathologie Malignes Melanom as Ja or Nein in HKS-D documents, and when Ja, to record Klassifikation (in situ or invasiv) and Tumordicke nach Breslow, so that malignant melanoma histopathology findings are captured with classification and thickness.

### Acceptance Criteria

1. Given an HKS-D document is created, when Histopathologie Malignes Melanom is Ja, then Klassifikation (in situ or invasiv) is selected
2. Given Klassifikation is invasiv, when documented, then Tumordicke nach Breslow (mm) is recorded
3. Given Histopathologie Malignes Melanom is Nein, then no sub-fields are required
