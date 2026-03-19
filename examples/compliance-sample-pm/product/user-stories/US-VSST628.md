## US-VSST628 — The Vertragssoftware must provide a function to print the 'Merkblatt...

| Field | Value |
|-------|-------|
| **ID** | US-VSST628 |
| **Traced from** | [VSST628](../compliances/SV/VSST628.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, FRM |

### User Story

As a practice staff, I want the Vertragssoftware provide a function to print the 'Merkblatt Versicherter Hilfsmittel' document per AKA-Basisdatei for steuerbare Hilfsmittel prescriptions, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a steuerbare Hilfsmittel prescription, when the user requests the Merkblatt, then the Merkblatt Versicherter Hilfsmittel per AKA-Basisdatei is printed

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/himi`, `api/printer`, `api/form`

1. **HIMI printing** -- The `HimiApp.Print` method generates printed output for Hilfsmittel prescriptions with `PrintOption` support.
2. **Gap: Merkblatt Versicherter Hilfsmittel** -- The specific 'Merkblatt Versicherter Hilfsmittel' document generation per AKA-Basisdatei for steuerbare prescriptions needs verification as a specific print template.
