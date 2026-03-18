## VERT484 — When creating a KV billing Schein, the Vertragssoftware must provide...

| Field | Value |
|-------|-------|
| **ID** | VERT484 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT484](../../user-stories/US-VERT484.md) |

### Requirement

When creating a KV billing Schein, the Vertragssoftware must provide a function to check the patient's HzV participation status online via the Pruef- und Abrechnungsmodul, if the patient's Kassen-IK is in the current Kostentraegerdaten of the Selektivvertragsdefinitionen and no active participation exists

### Acceptance Criteria

1. Given a patient whose Kassen-IK matches active Selektivvertragsdefinitionen and no active participation exists, when a KV Schein is created, then an online HzV participation check via HPM is offered
2. Given the HPM returns a result, then it is displayed to the user
