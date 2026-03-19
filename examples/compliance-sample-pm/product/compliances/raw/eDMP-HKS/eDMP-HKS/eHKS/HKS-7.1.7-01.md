## HKS-7.1.7-01 — Practice doctor must document Biopsie/Exzision with Anzahl, anderweitige Therapie, and derzeit keine weitere in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | HKS-7.1.7-01 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 7.1.7 -- Biopsie/Exzision |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-7.1.7-01](../../../../../user-stories/eDMP_HKS/US-HKS-7.1.7-01.md) |

### Requirement

As a practice doctor, I want to document Biopsie/Exzision as Ja or Nein in HKS-D documents, and when Ja, to record Anzahl, anderweitige Therapie, or derzeit keine weitere, so that biopsy and excision procedures are tracked for histopathological workup.

### Acceptance Criteria

1. Given an HKS-D document is created, when Biopsie/Exzision is Ja, then Anzahl (count) is recorded as a positive integer
2. Given Biopsie/Exzision is Ja, when the procedure details are documented, then anderweitige Therapie or derzeit keine weitere can be indicated
3. Given Biopsie/Exzision is Nein, then no Anzahl or sub-fields are required
