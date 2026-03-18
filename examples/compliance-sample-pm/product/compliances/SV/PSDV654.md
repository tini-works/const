## PSDV654 — KT master data file (ehd) must be supported

| Field | Value |
|-------|-------|
| **ID** | PSDV654 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.10 PSDV — Patient Master Data |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Data import validation |
| Matched by | [US-PSDV654](../../user-stories/US-PSDV654.md) |

### Requirement

KT master data file (ehd) must be supported

### Acceptance Criteria

1. Given a KT-Stammdatei (ehd), when imported, then all Kostenträger records are parsed and stored correctly
