## E2: Billing Submission

**Goal:** Validate, transmit, and control the billing process end-to-end — including specialty billing programs — so that submitted billing data passes KBV validation and insurance acceptance without rejection.

**Origin:** AKA Q1-26-1 catalog section 3.2 (ABRG) — 45 obligations covering billing validation, transmission, duplicate prevention, and post-submission controls. KVDT v6.06 sections 2.1.7, 2.3.2, 2.3.8-2.3.11, 2.3.10.1, 2.3.10.4-5, 2.6, Ch.3-6 — ~42 obligations covering billing preparation, psychotherapy billing, specialty programs (ASV, KADT, SADT, Hybrid-DRG), validation modules, and encryption.

**Scope:**
- HPM billing validation module (Abrechnungspruefmodul) integration
- Pre-submission control lists with case, service, and financial summaries
- Duplicate billing prevention and transmission status marking
- Online and offline (data carrier) transmission channel support
- Substitute doctor (Vertreterarzt) billing attribution with correct LANR
- Diagnosis completeness checks — all acute and permanent diagnoses included
- Chronic care flat-rate validation against confirmed permanent diagnoses
- Pre-participation status verification before billing
- Late-submission window warnings (4+ quarter services)
- Transmission protocol PDF generation after successful billing
- Comprehensive audit logging of all validation warnings and errors
- Online billing services and 1Click billing via KIM (KVDT 2.1.7)
- Billing preparation functions — trial billing, daily control lists (KVDT 2.3.2)
- PKV card exclusion from GKV billing (KVDT 2.3.8)
- **Psychotherapy billing** — session documentation (FK 4234-4257), combination treatment by two therapists, group therapy GOP mapping, daily profile calculation, Pseudo-GOP 88130/88131 termination notifications, cross-quarter contingent tracking, reminder functions for approved therapies, therapy interruption recording (KVDT 2.3.11)
- Simultaneous procedures — highest-valued service, GSNZ, time surcharges (KVDT 2.3.10.1)
- Supervisory services (Betreuungsleistungen) referral and billing (KVDT 2.3.10.4-5)
- **ASV billing** — team number management, GOP marking with ASV-Teamnummer, ASV-Abrechnungsvereinbarung compliance (KVDT 2.6)
- **KADT** — spa physician billing via Satzart 0109, exclusion of Sonstige Kostentrager, Pseudo-GNR 00001U (KVDT Ch.3)
- **SADT** — pregnancy termination billing, Kennziffer-SA plausibility, pseudonymized printing (KVDT Ch.4)
- **Hybrid-DRG** — HDRG Satzart support, ICD/OPS encoding, billing file export, 1ClickHybridDRG via KIM, anesthesia hours validation, service date range checks (KVDT Ch.5)
- KVDT-Pruefmodul and KBV-Kryptomodul mandatory use, communication record, unencrypted file access (KVDT Ch.6)
- RVSA data record generation within KVDT billing file (KVDT 2.5.10)

**Compliance impact:** BG-1a (AKA Certification), BG-1b (KBV KVDT Certification), BG-2 (Revenue Protection), BG-6 (Competitive Advantage)

**Traceability:**

| Link type | References |
|-----------|------------|
| Catalog sections | AKA 3.2 ABRG; KVDT 2.1.7, 2.3.2, 2.3.8, 2.3.10.1, 2.3.10.4-5, 2.3.11, 2.4, 2.5.10, 2.6, Ch.3, Ch.4, Ch.5, Ch.6 |
| KVDT Requirements | [P2-95](../compliances/KVDT/P2-95.md), [P2-97](../compliances/KVDT/P2-97.md), [P2-510](../compliances/KVDT/P2-510.md), [P2-790](../compliances/KVDT/P2-790.md), [K2-900](../compliances/KVDT/K2-900.md), [K2-930](../compliances/KVDT/K2-930.md), [K2-940](../compliances/KVDT/K2-940.md), [KP2-941](../compliances/KVDT/KP2-941.md), [KP2-942](../compliances/KVDT/KP2-942.md), [KP2-943](../compliances/KVDT/KP2-943.md), [KP2-944](../compliances/KVDT/KP2-944.md), [K2-947](../compliances/KVDT/K2-947.md), [KP2-964](../compliances/KVDT/KP2-964.md), [KP2-965](../compliances/KVDT/KP2-965.md), [KP2-966](../compliances/KVDT/KP2-966.md), [KP2-967](../compliances/KVDT/KP2-967.md), [KP2-968](../compliances/KVDT/KP2-968.md), [K2-969](../compliances/KVDT/K2-969.md), [KP2-970](../compliances/KVDT/KP2-970.md), [KP2-971](../compliances/KVDT/KP2-971.md), [KP2-972](../compliances/KVDT/KP2-972.md), [P21-001](../compliances/KVDT/P21-001.md), [P21-005](../compliances/KVDT/P21-005.md), [P21-010](../compliances/KVDT/P21-010.md), [P2.6-10](../compliances/KVDT/P2.6-10.md), [P2.6-20](../compliances/KVDT/P2.6-20.md), [P2.6-30](../compliances/KVDT/P2.6-30.md), [K4-10](../compliances/KVDT/K4-10.md), [K4-20](../compliances/KVDT/K4-20.md), [K4-30](../compliances/KVDT/K4-30.md), [K4-40](../compliances/KVDT/K4-40.md), [K4-50](../compliances/KVDT/K4-50.md), [K4-60](../compliances/KVDT/K4-60.md), [KP8-01](../compliances/KVDT/KP8-01.md), [KP8-02](../compliances/KVDT/KP8-02.md), [KP8-03](../compliances/KVDT/KP8-03.md), [KP8-04](../compliances/KVDT/KP8-04.md), [KP8-05](../compliances/KVDT/KP8-05.md), [K8-06](../compliances/KVDT/K8-06.md), [KP8-07](../compliances/KVDT/KP8-07.md), [KP8-08](../compliances/KVDT/KP8-08.md), [P5-10](../compliances/KVDT/P5-10.md), [P5-20](../compliances/KVDT/P5-20.md), [P5-30](../compliances/KVDT/P5-30.md), [P20-070](../compliances/KVDT/P20-070.md) |
| AVWG Requirements | — |
| AKA Requirements | [US-ABRG386](../user-stories/US-ABRG386.md), [US-ABRG454](../user-stories/US-ABRG454.md), [US-ABRG485](../user-stories/US-ABRG485.md), [US-ABRG486](../user-stories/US-ABRG486.md), [US-ABRG490](../user-stories/US-ABRG490.md), [US-ABRG491](../user-stories/US-ABRG491.md), [US-ABRG492](../user-stories/US-ABRG492.md), [US-ABRG493](../user-stories/US-ABRG493.md), [US-ABRG497](../user-stories/US-ABRG497.md), [US-ABRG498](../user-stories/US-ABRG498.md), [US-ABRG505](../user-stories/US-ABRG505.md), [US-ABRG614](../user-stories/US-ABRG614.md), [US-ABRG615](../user-stories/US-ABRG615.md), [US-ABRG616](../user-stories/US-ABRG616.md), [US-ABRG617](../user-stories/US-ABRG617.md), [US-ABRG618](../user-stories/US-ABRG618.md), [US-ABRG619](../user-stories/US-ABRG619.md), [US-ABRG664](../user-stories/US-ABRG664.md), [US-ABRG665](../user-stories/US-ABRG665.md), [US-ABRG666](../user-stories/US-ABRG666.md), [US-ABRG667](../user-stories/US-ABRG667.md), [US-ABRG668](../user-stories/US-ABRG668.md), [US-ABRG669](../user-stories/US-ABRG669.md), [US-ABRG670](../user-stories/US-ABRG670.md), [US-ABRG678](../user-stories/US-ABRG678.md), [US-ABRG803](../user-stories/US-ABRG803.md), [US-ABRG829](../user-stories/US-ABRG829.md), [US-ABRG921](../user-stories/US-ABRG921.md), [US-ABRG927](../user-stories/US-ABRG927.md), [US-ABRG929](../user-stories/US-ABRG929.md), [US-ABRG933](../user-stories/US-ABRG933.md), [US-ABRG958](../user-stories/US-ABRG958.md), [US-ABRG961](../user-stories/US-ABRG961.md), [US-ABRG993](../user-stories/US-ABRG993.md), [US-ABRG996](../user-stories/US-ABRG996.md), [US-ABRG997](../user-stories/US-ABRG997.md), [US-ABRG998](../user-stories/US-ABRG998.md), [US-ABRG999](../user-stories/US-ABRG999.md), [US-ABRG1006](../user-stories/US-ABRG1006.md), [US-ABRG1007](../user-stories/US-ABRG1007.md), [US-ABRG1013](../user-stories/US-ABRG1013.md), [US-ABRG1274](../user-stories/US-ABRG1274.md), [US-ABRG1415](../user-stories/US-ABRG1415.md), [US-ABRG1565](../user-stories/US-ABRG1565.md), [US-ABRG1847](../user-stories/US-ABRG1847.md) |
| Decisions | — |
| Confirmed by | — |

**Verification:** 0/~87 requirements confirmed — all TBC.
