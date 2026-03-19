# Domain Entity Index

> **Purpose:** Canonical business entity catalog for user story tagging and impact analysis. When a change request arrives, tag affected entities → find all impacted user stories → scope the work.
>
> **Rules:**
> - Use 1–3 entity IDs per user story
> - If no entity fits, propose a new one here before using it
> - Entities represent **business objects stakeholders talk about**, not technical artifacts
> - Use `—` for non-functional requirements (documentation, advertising, process rules) that don't touch a business entity
>
> **Tagging discipline for FRM (forms):** Always dual-tag to disambiguate form type:
> - Prescription forms → `FRM, VOD`
> - Referral forms (Muster 6/10/39) → `FRM, BF`
> - Clinical forms (Befundbogen) → `FRM, DX` or `FRM, PAT`
> - PTV psychotherapy forms → `FRM, SVC`
> - Patient receipt → `FRM, ABR`
> - Enrollment forms → `FRM, TE`
>
> **Specialty domain precision:** For narrow domains (psychotherapy, genetics, RVSA lab quality), entity tags alone may be broad. Use the traceability chain: **Entity → Epic → KVDT/AVWG Section → Requirements** for precise scoping.

## Core Business Entities

| Entity ID | German Name | English Name | Description | Impact Analysis Trigger |
|-----------|-------------|--------------|-------------|------------------------|
| `PAT` | Patient / Versicherter | Patient | A person receiving care, identified by Versicherten-ID, with insurance coverage and demographics | eGK spec change, VSDM update, data protection rules |
| `SVC` | Leistung / GNR | Service | A billable medical service identified by a GNR code from the EBM fee schedule | EBM quarterly update, new GOPen, billing rule changes |
| `DX` | Diagnose | Diagnosis | An ICD-10-GM coded diagnosis; includes Dauerdiagnosen (permanent) and acute diagnoses | ICD-10-GM annual update, diagnosis documentation rules |
| `OPS` | OPS-Code | Procedure Code | An OPS-coded procedure used for billing justification and § 295 documentation | OPS catalog update, side localization rules |
| `BF` | Behandlungsfall / Schein | Treatment Case | The billing case per patient per quarter per encounter type (= Abrechnungsschein, Satzart 010x) | Scheinuntergruppe rules, Satzart changes, TSS surcharges |
| `ABR` | Abrechnung | Billing Submission | The quarterly billing dataset — generation, validation, encryption, transmission to KV | KVDT-Prüfmodul update, encryption key rotation, transmission channel changes |
| `QTR` | Quartal | Quarter | The quarterly billing period governing all deadlines, transitions, and Nachzügler rules | Quarter transition logic, late billing windows |
| `VTG` | Vertrag / Selektivvertrag | Contract | A selective care contract (HzV, FAV) including its definition, IK assignments, and Vertragskennzeichen | New contract onboarded, contract deactivation, rule change |
| `TE` | Teilnahmeerklärung | Enrollment | Patient enrollment into a contract — the declaration, submission, status tracking, ICode/TE-Code handling | Enrollment form change, HPM submission spec change |
| `KT` | Kostenträger / Kasse | Payer | An insurance fund identified by IK, with KT-Stammdatei master data, VKNR, and billing area (KTAB) | KT-Stammdatei quarterly update, payer merger/dissolution |
| `VOD` | Verordnung | Prescription | A drug prescription — content (PZN, active ingredient, dosage), type (Erst/Wiederholung/Mehrfach), and e-Rezept FHIR mapping | AVWG rule change, e-Rezept spec update, Dosierungskennzeichen change |
| `MED` | Medikament / Arzneimittel | Medication | Drug master data — Arzneimittelstammdaten, Merkmal catalog, Rabattverträge, Priscus-Liste, G-BA § 35a resolutions | Drug database update, Rabattvertrag change, new G-BA resolution |
| `FRM` | Formular / Vordruck | Form | Any printed or electronic form — Überweisung (Muster 6/10/39), Befundbogen, PTV forms, patient receipt, EHIC declaration | Form layout change, new Muster version, printing spec update |
| `BST` | Betriebsstätte / BSNR | Practice Site | The practice location with BSNR, associated LANRs, and TI connector configuration | Multi-site billing rules, BSNR/NBSNR uniqueness |
| `ARZ` | Arzt / LANR | Physician | A physician with LANR, specialization, and contract qualifications | LANR management rules, substitute doctor (Vertreter) billing |
| `EBM` | EBM-Stammdatei (SDEBM) | Fee Schedule Data | The EBM master data file — GNR definitions, rules, conditions, KV-specific extensions | EBM quarterly update, new Prüfbedingungen, KV-specific GNRs |
| `KTS` | KT-/KV-Stammdateien | Payer Master Data | KBV master data files for payer resolution — SDKT, SDKV, SDAV, PLZ | Quarterly Stammdatei delivery, KV-Spezifika change |

## Absorptions (what merged into what)

> For migration reference — these old entity IDs should be replaced in user stories:

| Removed ID | Merged Into | Reason |
|------------|-------------|--------|
| `SCH` | `BF` | Schein = Behandlungsfall in KV billing. Same business object. |
| `VKZ` | `VTG` | Vertragskennzeichen is an attribute of Vertrag, not a separate entity. |
| `SVD` | `VTG` | Contract definition is the configuration aspect of Vertrag. |
| `TNV` | `TE` | Participation process is the lifecycle of the enrollment declaration. |
| `ICODE` | `TE` | ICode is a field within the enrollment workflow. |
| `TECODE` | `TE` | TE-Code is a field within the enrollment workflow. |
| `IKG` | `KT` | IK is the identifier of a Kostenträger. |
| `RZP` | `FRM` | Rezept is a form type (Muster 16, BtM, etc.). Tag `FRM` + `VOD`. |
| `UBW` | `FRM` | Überweisung is a form type (Muster 6/10/39). Tag `FRM` + relevant entity. |
| `BDB` | `FRM` | Befundbogen is a form type. Tag `FRM`. |
| `STD` | `EBM` or `KTS` | Split into specific master data types for precise impact analysis. |
| `EGK` | `PAT` | Card read-in is how patient data enters the system. The entity is Patient. |
| `PM` | — (removed) | Technical integration, not a business entity. Tag the entity being validated instead. |
| `PVS` | — (removed) | The system itself. Tag `BST` for practice config, or the specific entity affected. |
| `KLL` | `ABR` | Control list is a view of billing data. |
| `UBS` | `ABR` | Transmission status is an attribute of billing submission. |
| `DTR` | `ABR` | Data carrier is a delivery channel for billing. |
| `ARR` | — (removed) | Third-party tool integration. Not a domain entity. |
| `KAT` | — (removed) | Internal compliance artifact. Not a business entity. |
