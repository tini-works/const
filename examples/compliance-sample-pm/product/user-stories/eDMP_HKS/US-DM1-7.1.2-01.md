## US-DM1-7.1.2-01 — Practice doctor must document Empfohlene Schulung(en) wahrgenommen with nested Diabetes and Hypertonie sub-fields

| Field | Value |
|-------|-------|
| **ID** | US-DM1-7.1.2-01 |
| **Traced from** | [DM1-7.1.2-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-7.1.2-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether recommended Schulungen were attended, with separate sub-fields for Diabetes-Schulung and Hypertonie-Schulung each accepting Ja, Nein, War aktuell nicht moeglich, or Bei letzter Doku keine Schulung empfohlen, so that attendance of recommended education programmes is tracked for each programme type individually.

### Acceptance Criteria

1. Given an eDMP DM1 Verlauf section is documented, when Empfohlene Schulung wahrgenommen is recorded, then Diabetes-Schulung status is one of Ja, Nein, War aktuell nicht moeglich, or Bei letzter Doku keine Schulung empfohlen
2. Given an eDMP DM1 Verlauf section is documented, when Empfohlene Schulung wahrgenommen is recorded, then Hypertonie-Schulung status is one of Ja, Nein, War aktuell nicht moeglich, or Bei letzter Doku keine Schulung empfohlen
3. Given either sub-field is missing, when validated, then an error is reported
