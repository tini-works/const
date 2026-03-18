## E8: Drug Prescribing & e-Rezept

**Goal:** Enable compliant drug prescribing — from drug master data and search through e-Rezept generation — so that prescriptions meet KBV AVWG certification requirements and integrate with the gematik e-Rezept infrastructure.

**Origin:** AVWG v5.8 (Anforderungskatalog nach § 73 SGB V für Verordnungssoftware) — ~59 obligations covering drug master data, prescribing workflows, substitution, pricing, dosage, electronic prescriptions, medication plans, and prescribing statistics.

**Scope:**
- **Drug master data** — completeness and currency of Arzneimittelstammdaten, full Merkmal catalog (finished pharmaceuticals, medical devices, bandages, test strips, enteral nutrition), integration of drug agreement interface (AVWG 1.3, 2.1, 2.2)
- **In-house pharmacy (Hausapotheke)** — package-level and free-text storage, PZN-based entries, update workflows (AVWG 2.3)
- **Prescribing workflow UI** — uniform layout of selection lists, selection from complete directory, physician samples per AMG, subsequent master data editing, first/second level information display with Merkmal mapping tables (AVWG 3.1)
- **Safety notices** — display of drug notices, archived Rote-Hand-Briefe, training material per EAMIV (AVWG 3.1)
- **G-BA resolutions** — machine-readable § 35a resolution implementation, resolution overview and detail display, reserve antibiotic labeling (AVWG 3.2)
- **Drug search** — search/research options, alphabetical sorting, default and custom sorting, price comparison search, detail information display (AVWG 3.4)
- **Substitution** — substitution/prescription proposals, complete listing, no automatic aut idem assignment, discrimination-free display (AVWG 3.5)
- **Pricing and discount drugs** — discount drug display in workflow, quick selection, display of more affordable alternatives, price history (AVWG 3.6)
- **Efficient prescribing** — AM-RL provision including annexes, drug agreement content per § 84 (AVWG 3.7)
- **Prescription types** — prescription from drug master data (PZN), active ingredient prescription, compounding prescription, free-text prescription, dosage information (free-text and structured, Dj marker, narcotic rules), replacement prescription, multiple prescription (AVWG 3.8)
- **Electronic prescriptions** — general e-Rezept requirements, FHIR profile mapping (KBV_PR_ERP_Prescription, KBV_PR_FOR_Coverage), form selection mapping to Coverage.type.coding.code and Medication_Category (AVWG 3.9)
- **Medication plan** — medication plan per § 31a SGB V (AVWG 3.10)
- **Controlling** — reference values (Richtgrößen), reference value utilization, further controlling programs, price assignment for active ingredient prescriptions (AVWG 4.1)
- **Statistics** — export of prescription data, creation of statistics with graphical display (AVWG 4.2)

**Compliance impact:** BG-1c (KBV AVWG Certification), BG-2 (Revenue Protection), BG-5 (User Efficiency), BG-7 (Regulatory Readiness)

**Traceability:**

| Link type | References |
|-----------|------------|
| Catalog sections | AVWG 1.3 (P1-050), 2.1, 2.2, 2.3, 3.1, 3.2, 3.4, 3.5, 3.6, 3.7, 3.8, 3.10, 4.1, 4.2 |
| KVDT Requirements | [P2-80](../KVDT/KVDT/P2-80.md) (AMV certification number links KVDT↔AVWG) |
| AVWG Requirements | [P1-050](../KVDT/AVWG/P1-050.md), [P2-100](../KVDT/AVWG/P2-100.md), [P2-110](../KVDT/AVWG/P2-110.md), [K2-155](../KVDT/AVWG/K2-155.md), [K2-160](../KVDT/AVWG/K2-160.md), [P3-100](../KVDT/AVWG/P3-100.md), [P3-110](../KVDT/AVWG/P3-110.md), [P3-113](../KVDT/AVWG/P3-113.md), [P3-115](../KVDT/AVWG/P3-115.md), [P3-120](../KVDT/AVWG/P3-120.md), [P3-121](../KVDT/AVWG/P3-121.md), [P3-130](../KVDT/AVWG/P3-130.md), [P3-141](../KVDT/AVWG/P3-141.md), [O3-145](../KVDT/AVWG/O3-145.md), [P3-250](../KVDT/AVWG/P3-250.md), [P3-255](../KVDT/AVWG/P3-255.md), [P3-260](../KVDT/AVWG/P3-260.md), [P3-265](../KVDT/AVWG/P3-265.md), [P3-270](../KVDT/AVWG/P3-270.md), [P3-300](../KVDT/AVWG/P3-300.md), [O3-310](../KVDT/AVWG/O3-310.md), [P3-315](../KVDT/AVWG/P3-315.md), [P3-320](../KVDT/AVWG/P3-320.md), [P3-325](../KVDT/AVWG/P3-325.md), [P3-330](../KVDT/AVWG/P3-330.md), [P3-340](../KVDT/AVWG/P3-340.md), [P3-400](../KVDT/AVWG/P3-400.md), [P3-420](../KVDT/AVWG/P3-420.md), [P3-430](../KVDT/AVWG/P3-430.md), [P3-440](../KVDT/AVWG/P3-440.md), [P3-515](../KVDT/AVWG/P3-515.md), [P3-516](../KVDT/AVWG/P3-516.md), [P3-520](../KVDT/AVWG/P3-520.md), [O3-540](../KVDT/AVWG/O3-540.md), [P3-600](../KVDT/AVWG/P3-600.md), [P3-610](../KVDT/AVWG/P3-610.md), [P3-621](../KVDT/AVWG/P3-621.md), [O3-622](../KVDT/AVWG/O3-622.md), [O3-623](../KVDT/AVWG/O3-623.md), [P3-624](../KVDT/AVWG/P3-624.md), [P3-625](../KVDT/AVWG/P3-625.md), [P3-630](../KVDT/AVWG/P3-630.md), [P3-640](../KVDT/AVWG/P3-640.md), [P3-710](../KVDT/AVWG/P3-710.md), [P3-731](../KVDT/AVWG/P3-731.md), [P3-800](../KVDT/AVWG/P3-800.md), [O4-100](../KVDT/AVWG/O4-100.md), [O4-110](../KVDT/AVWG/O4-110.md), [O4-130](../KVDT/AVWG/O4-130.md), [O4-140](../KVDT/AVWG/O4-140.md), [K4-150](../KVDT/AVWG/K4-150.md), [K4-200](../KVDT/AVWG/K4-200.md) |
| AKA Requirements | — |
| Decisions | — |
| Confirmed by | — |

**Verification:** 0/~59 requirements confirmed — all TBC.
