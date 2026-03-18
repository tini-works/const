## E4: Form Generation

**Goal:** Generate compliant forms (PDF/PCX) per contract and regulatory requirements — including prescription printing, patient receipts, psychotherapy forms, and European health insurance declarations — so that printed and electronic forms meet all specifications.

**Origin:** AKA Q1-26-1 catalog section 3.5 (FORM) — 45 obligations covering form templates, field population, print optimization, and contract-specific form variants. KVDT v6.06 sections 2.3.9, 2.3.11.6, 2.3.12, 2.5.9 — ~13 form-related obligations covering patient receipts, PTV psychotherapy forms, European Health Insurance declarations, and RVSA certificate printing. AVWG v5.8 section 3.9 — 6 prescription printing obligations covering drug master data, active ingredient, compounding, and free-text prescriptions.

**Scope:**
- PDF and legacy PCX format form generation
- Contract-specific form templates and field mappings
- Patient data pre-population from master data and enrollment records
- Referral forms with contract-specific text fields and hint text
- Prescription forms compliant with E-Rezept and paper workflows
- Form versioning across quarterly contract updates
- Print optimization for medical practice environments
- Form archive and retrieval for audit purposes
- **Prescription printing** — general requirements, printing from drug master data, active ingredient prescriptions, compounding prescriptions, free-text prescriptions, form selection (Muster 16, BtM, T-Rezept, Privat) (AVWG 3.9)
- **Patient receipt** — service listing, point value, quotation, quarterly receipt, layout and content specifications, line length, day-based receipts (KVDT 2.3.9)
- **PTV forms** — access and printing of Muster PTV 3 and PTV 10 for psychotherapy (KVDT 2.3.11.6)
- **European Health Insurance** — Patientenerklärung access, printing (full and partial), ADT-Prüfnummer positioning (KVDT 2.3.12)
- **RVSA certificate overview** — print function for ring trial certificate overview (KVDT 2.5.9)

**Compliance impact:** BG-1a (AKA Certification), BG-1b (KBV KVDT Certification), BG-1c (KBV AVWG Certification), BG-5 (User Efficiency)

**Traceability:**

| Link type | References |
|-----------|------------|
| Catalog sections | AKA 3.5 FORM; KVDT 2.3.9, 2.3.11.6, 2.3.12, 2.5.9; AVWG 3.9 |
| KVDT Requirements | [P2-820](../KVDT/KVDT/P2-820.md), [P2-830](../KVDT/KVDT/P2-830.md), [P2-840](../KVDT/KVDT/P2-840.md), [K2-855](../KVDT/KVDT/K2-855.md), [K2-860](../KVDT/KVDT/K2-860.md), [P2-870](../KVDT/KVDT/P2-870.md), [P2-880](../KVDT/KVDT/P2-880.md), [P2-890](../KVDT/KVDT/P2-890.md), [KP2-960](../KVDT/KVDT/KP2-960.md), [KP2-961](../KVDT/KVDT/KP2-961.md), [KP2-962](../KVDT/KVDT/KP2-962.md), [KP2-963](../KVDT/KVDT/KP2-963.md), [KP2-945](../KVDT/KVDT/KP2-945.md), [KP2-946](../KVDT/KVDT/KP2-946.md), [K20-061](../KVDT/KVDT/K20-061.md) |
| AVWG Requirements | [P3-700](../KVDT/AVWG/P3-700.md), [P3-720](../KVDT/AVWG/P3-720.md), [P3-721](../KVDT/AVWG/P3-721.md), [K3-722](../KVDT/AVWG/K3-722.md), [K3-723](../KVDT/AVWG/K3-723.md), [P3-724](../KVDT/AVWG/P3-724.md), [P3-730](../KVDT/AVWG/P3-730.md) |
| AKA Requirements | [US-FORM513](../user-stories/US-FORM513.md), [US-FORM586](../user-stories/US-FORM586.md), [US-FORM588](../user-stories/US-FORM588.md), [US-FORM610](../user-stories/US-FORM610.md), [US-FORM632](../user-stories/US-FORM632.md), [US-FORM635](../user-stories/US-FORM635.md), [US-FORM636](../user-stories/US-FORM636.md), [US-FORM637](../user-stories/US-FORM637.md), [US-FORM656](../user-stories/US-FORM656.md), [US-FORM813](../user-stories/US-FORM813.md), [US-FORM814](../user-stories/US-FORM814.md), [US-FORM815](../user-stories/US-FORM815.md), [US-FORM859](../user-stories/US-FORM859.md), [US-FORM886](../user-stories/US-FORM886.md), [US-FORM907](../user-stories/US-FORM907.md), [US-FORM938](../user-stories/US-FORM938.md), [US-FORM1042](../user-stories/US-FORM1042.md), [US-FORM1174](../user-stories/US-FORM1174.md), [US-FORM1175](../user-stories/US-FORM1175.md), [US-FORM1176](../user-stories/US-FORM1176.md), [US-FORM1177](../user-stories/US-FORM1177.md), [US-FORM1178](../user-stories/US-FORM1178.md), [US-FORM1236](../user-stories/US-FORM1236.md), [US-FORM1237](../user-stories/US-FORM1237.md), [US-FORM1238](../user-stories/US-FORM1238.md), [US-FORM1286](../user-stories/US-FORM1286.md), [US-FORM1386](../user-stories/US-FORM1386.md), [US-FORM1410](../user-stories/US-FORM1410.md), [US-FORM1413](../user-stories/US-FORM1413.md), [US-FORM1414](../user-stories/US-FORM1414.md), [US-FORM1447](../user-stories/US-FORM1447.md), [US-FORM1450](../user-stories/US-FORM1450.md), [US-FORM1451](../user-stories/US-FORM1451.md), [US-FORM1452](../user-stories/US-FORM1452.md), [US-FORM1453](../user-stories/US-FORM1453.md), [US-FORM1478](../user-stories/US-FORM1478.md), [US-FORM1479](../user-stories/US-FORM1479.md), [US-FORM1566](../user-stories/US-FORM1566.md), [US-FORM1684](../user-stories/US-FORM1684.md), [US-FORM1687](../user-stories/US-FORM1687.md), [US-FORM1688](../user-stories/US-FORM1688.md), [US-FORM1689](../user-stories/US-FORM1689.md), [US-FORM1733](../user-stories/US-FORM1733.md), [US-FORM1836](../user-stories/US-FORM1836.md), [US-FORM1844](../user-stories/US-FORM1844.md) |
| Decisions | — |
| Confirmed by | — |

**Verification:** 0/~67 requirements confirmed — all TBC.
