## VERT495 — When requesting HzV participation, the Vertragssoftware must verify the patient's...

| Field | Value |
|-------|-------|
| **ID** | VERT495 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT495](../../user-stories/US-VERT495.md) |

### Requirement

When requesting HzV participation, the Vertragssoftware must verify the patient's current HzV participation status online via the Pruef- und Abrechnungsmodul and display appropriate messages depending on whether participation already exists or not

### Acceptance Criteria

1. Given HzV participation is requested, when the HPM returns no active participation, then the message 'Der Patient ist derzeit kein aktiver Vertragsteilnehmer' is shown
2. Given active participation exists, then the appropriate status message is displayed
