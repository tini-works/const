## VERT582 — When creating a KV Schein or first documenting KV services,...

| Field | Value |
|-------|-------|
| **ID** | VERT582 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT582](../../user-stories/US-VERT582.md) |

### Requirement

When creating a KV Schein or first documenting KV services, the Vertragssoftware must check both FaV and HzV participation status online via the Pruef- und Abrechnungsmodul if the patient's Kassen-IK is in the Selektivvertragsdefinitionen Kostentraegerdaten

### Acceptance Criteria

1. Given a KV Schein is created or KV services first documented, when the patient's Kassen-IK is in Selektivvertragsdefinitionen Kostentraegerdaten, then both FaV and HzV participation are checked online via HPM
