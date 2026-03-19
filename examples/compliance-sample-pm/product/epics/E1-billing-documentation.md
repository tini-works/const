## E1: Billing Documentation

**Goal:** Ensure correct documentation of services, diagnoses, codes, and supporting data during entry — so that billing data is compliant and audit-ready before it ever reaches submission.

**Origin:** AKA Q1-26-1 catalog section 3.1 (ABRD) — 46 obligations covering service code validation, diagnosis documentation, referral rules, and contract-specific billing fields. KVDT v6.06 sections 2.3-2.3.7 — ~50 billing documentation obligations covering service code validation, diagnosis documentation, referral rules, day separation, service identification, and genetic testing billing justifications.

**Scope:**
- Code 0000 (Arzt-Patienten-Kontakt) prompting and validation
- ICD-10 diagnosis specificity, terminal code enforcement, and catalog validity
- Referral form requirements (LANR, BSNR, hint text, FAV-specific fields)
- Service lookup filtering by KV region, IK assignment, and IK group
- Contract participation status checks before service entry
- OPS code requirements per EBM Annex 2 and specialty services
- Audit trail protection — submitted services cannot be deleted
- Disease pattern checks (Krankheitsbildpruefung) and multimorbidity flagging
- Material cost documentation and billing justification text
- Permanent diagnosis carry-over and acute/permanent plausibility warnings
- Satzart 010x entry and Scheinuntergruppe assignment (KVDT 2.3)
- Terminservice (TSS) appointment mediation marking and surcharges (KVDT 2.3.1)
- Quarter transition and Nachzugler case handling (KVDT 2.3.3)
- Insurance/status/Personengruppe changes within quarter (KVDT 2.3.4)
- Official insured data changes within quarter (KVDT 2.3.5)
- Referral specifics for Muster 6, 10, 39 — Auftrag, Ausstellungsdatum, IVD treatment day (KVDT 2.3.6)
- Treatment day / GNR ordering and justification text assignment (KVDT 2.3.7.1-2)
- HGNC gene symbol coding for genetic examination billing (KVDT 2.3.7.3)
- Visit billing justifications (KVDT 2.3.7.4)
- Service chain individual acknowledgment (KVDT 2.3.7.5)
- Day separation (Tagtrennung) logic (KVDT 2.3.7.6)
- Service identification with BSNR and LANR (KVDT 2.3.7.7)
- Programmed scheduling (Beregelung) (KVDT 2.3.7.8)
- Batch number transmission for vaccinations (KVDT 2.3.7.9)
- Implant register data capture and transmission (KVDT 2.3.7.10)
- ICD code as billing justification and required diagnosis checks (KVDT 2.3.10.3)
- OPS code dual function — billing justification and § 295 documentation (KVDT 2.3.10.2)
- GNR justification as alternative to OPS (KVDT 2.3.10.2)
- Pseudo treatment cases for NaPA (KVDT 2.4)

**Compliance impact:** BG-1a (AKA Certification), BG-1b (KBV KVDT Certification), BG-2 (Revenue Protection), BG-3 (Contract Expansion), BG-4 (Risk Reduction), BG-5 (User Efficiency)

**Traceability:**

| Link type | References |
|-----------|------------|
| Catalog sections | AKA 3.1 ABRD; KVDT 2.3, 2.3.1-2.3.7, 2.3.10.2-3, 2.4 |
| KVDT Requirements | [KP2-500](../compliances/KVDT/KP2-500.md), [KP2-514](../compliances/KVDT/KP2-514.md), [P2-501](../compliances/KVDT/P2-501.md), [KP2-502](../compliances/KVDT/KP2-502.md), [KP2-503](../compliances/KVDT/KP2-503.md), [KP2-505](../compliances/KVDT/KP2-505.md), [K2-506](../compliances/KVDT/K2-506.md), [KP2-507](../compliances/KVDT/KP2-507.md), [KP2-508](../compliances/KVDT/KP2-508.md), [KP2-509](../compliances/KVDT/KP2-509.md), [KP2-511](../compliances/KVDT/KP2-511.md), [KP2-512](../compliances/KVDT/KP2-512.md), [KP2-513](../compliances/KVDT/KP2-513.md), [K2-512](../compliances/KVDT/K2-512.md), [P2-520](../compliances/KVDT/P2-520.md), [P2-521](../compliances/KVDT/P2-521.md), [P2-530](../compliances/KVDT/P2-530.md), [P2-535](../compliances/KVDT/P2-535.md), [P2-540](../compliances/KVDT/P2-540.md), [P2-556](../compliances/KVDT/P2-556.md), [KP2-557](../compliances/KVDT/KP2-557.md), [P2-558](../compliances/KVDT/P2-558.md), [KP2-560](../compliances/KVDT/KP2-560.md), [KP2-561](../compliances/KVDT/KP2-561.md), [KP2-562](../compliances/KVDT/KP2-562.md), [KP2-565](../compliances/KVDT/KP2-565.md), [KP2-570](../compliances/KVDT/KP2-570.md), [P2-600](../compliances/KVDT/P2-600.md), [P2-610](../compliances/KVDT/P2-610.md), [P21-015](../compliances/KVDT/P21-015.md), [KP2-612](../compliances/KVDT/KP2-612.md), [KP2-613](../compliances/KVDT/KP2-613.md), [KP2-614](../compliances/KVDT/KP2-614.md), [KP2-615](../compliances/KVDT/KP2-615.md), [KP2-616](../compliances/KVDT/KP2-616.md), [KP2-617](../compliances/KVDT/KP2-617.md), [KP2-618](../compliances/KVDT/KP2-618.md), [KP2-621](../compliances/KVDT/KP2-621.md), [KP2-622](../compliances/KVDT/KP2-622.md), [KP2-623](../compliances/KVDT/KP2-623.md), [KP2-624](../compliances/KVDT/KP2-624.md), [KP2-625](../compliances/KVDT/KP2-625.md), [K2-620](../compliances/KVDT/K2-620.md), [P2-630](../compliances/KVDT/P2-630.md), [P2-641](../compliances/KVDT/P2-641.md), [K2-650](../compliances/KVDT/K2-650.md), [KP2-651](../compliances/KVDT/KP2-651.md), [KP2-652](../compliances/KVDT/KP2-652.md), [KP2-910](../compliances/KVDT/KP2-910.md), [KP2-912](../compliances/KVDT/KP2-912.md), [P2-920](../compliances/KVDT/P2-920.md), [KP2-950](../compliances/KVDT/KP2-950.md) |
| AVWG Requirements | — |
| AKA Requirements | [US-ABRD456](../user-stories/US-ABRD456.md), [US-ABRD457](../user-stories/US-ABRD457.md), [US-ABRD459](../user-stories/US-ABRD459.md), [US-ABRD514](../user-stories/US-ABRD514.md), [US-ABRD601](../user-stories/US-ABRD601.md), [US-ABRD602](../user-stories/US-ABRD602.md), [US-ABRD603](../user-stories/US-ABRD603.md), [US-ABRD605](../user-stories/US-ABRD605.md), [US-ABRD606](../user-stories/US-ABRD606.md), [US-ABRD607](../user-stories/US-ABRD607.md), [US-ABRD608](../user-stories/US-ABRD608.md), [US-ABRD609](../user-stories/US-ABRD609.md), [US-ABRD611](../user-stories/US-ABRD611.md), [US-ABRD612](../user-stories/US-ABRD612.md), [US-ABRD613](../user-stories/US-ABRD613.md), [US-ABRD659](../user-stories/US-ABRD659.md), [US-ABRD675](../user-stories/US-ABRD675.md), [US-ABRD679](../user-stories/US-ABRD679.md), [US-ABRD786](../user-stories/US-ABRD786.md), [US-ABRD830](../user-stories/US-ABRD830.md), [US-ABRD834](../user-stories/US-ABRD834.md), [US-ABRD850](../user-stories/US-ABRD850.md), [US-ABRD887](../user-stories/US-ABRD887.md), [US-ABRD920](../user-stories/US-ABRD920.md), [US-ABRD936](../user-stories/US-ABRD936.md), [US-ABRD939](../user-stories/US-ABRD939.md), [US-ABRD965](../user-stories/US-ABRD965.md), [US-ABRD967](../user-stories/US-ABRD967.md), [US-ABRD969](../user-stories/US-ABRD969.md), [US-ABRD970](../user-stories/US-ABRD970.md), [US-ABRD991](../user-stories/US-ABRD991.md), [US-ABRD992](../user-stories/US-ABRD992.md), [US-ABRD994](../user-stories/US-ABRD994.md), [US-ABRD995](../user-stories/US-ABRD995.md), [US-ABRD1008](../user-stories/US-ABRD1008.md), [US-ABRD1009](../user-stories/US-ABRD1009.md), [US-ABRD1015](../user-stories/US-ABRD1015.md), [US-ABRD1035](../user-stories/US-ABRD1035.md), [US-ABRD1062](../user-stories/US-ABRD1062.md), [US-ABRD1416](../user-stories/US-ABRD1416.md), [US-ABRD1449](../user-stories/US-ABRD1449.md), [US-ABRD1544](../user-stories/US-ABRD1544.md), [US-ABRD1546](../user-stories/US-ABRD1546.md), [US-ABRD1564](../user-stories/US-ABRD1564.md), [US-ABRD1681](../user-stories/US-ABRD1681.md), [US-ABRD1846](../user-stories/US-ABRD1846.md) |
| Decisions | — |
| Confirmed by | — |

**Verification:** 0/~98 requirements confirmed — all TBC.
