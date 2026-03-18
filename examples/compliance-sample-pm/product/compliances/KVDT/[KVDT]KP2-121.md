## KP2-121 — Transfer of eGK Data for Federal Police Insurees

| Field | Value |
|-------|-------|
| **ID** | KP2-121 |
| **Type** | Conditional Mandatory (Konditionale Pflicht) |
| **Source** | AKA KVDT KBV |
| Matched by | User stor 01.md |

### Requirement

The software must ensure that once an eGK has been read for a Federal Police healthcare (BPol) insuree, no further outdated KVKs can be read for that insuree. The BPol cost carrier is replacing the old KVKs with current eGKs.

1. When an eGK is read for the first time for a BPol insuree (VKNR = 74860), the software must reject future reading of an outdated KVK (including for VKNR 27860) in the current quarter and all subsequent quarters, and must inform the user that the insuree already has an eGK.

As part of the eGK rollout, BPol introduced the new VKNR = 74860. The cost carrier with VKNR 27860 will be marked as invalid as of 1 October 2025.

This requirement does not apply to software systems without an outpatient billing component (APK).
