## US-VERT484 — When creating a KV billing Schein, the Vertragssoftware must provide...

| Field | Value |
|-------|-------|
| **ID** | US-VERT484 |
| **Traced from** | [VERT484](../compliances/SV/VERT484.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, SCH, TNV |

### User Story

As a practice owner, I want when creating a KV billing Schein, the Vertragssoftware provide a function to check the patient's HzV participation status online via the Pruef- und Abrechnungsmodul, if the patient's Kassen-IK is in the current Kostentraegerdaten of the Selektivvertragsdefinitionen and no active participation exists, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a patient whose Kassen-IK matches active Selektivvertragsdefinitionen and no active participation exists, when a KV Schein is created, then an online HzV participation check via HPM is offered
2. Given the HPM returns a result, then it is displayed to the user


### Actual Acceptance Criteria

**Status: Partially Implemented**

1. **Partially met.** `CheckParticipation` in `EnrollmentApp` accepts `IkNumber`, `InsuranceNumber`, `ContractId`, `DoctorId`, `PatientId` and queries HPM for participation status. However, the automatic trigger when creating a KV Schein (checking Kassen-IK against Selektivvertragsdefinitionen Kostentraegerdaten) is not explicitly wired into the Schein creation flow.
2. **Met.** `CheckParticipationResponse` returns `Status`, `ErrorMessages`, and `Reason`, which are displayed to the user.
