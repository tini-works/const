# PM Intake Log

| ID | Round | Type | Source | Summary | Boxes | Status | Priority |
|----|-------|------|--------|---------|-------|--------|----------|
| S-01 | R01 | Feature | Patient | Returning patient not recognized at check-in | BOX-01..04 | Boxes negotiated, staleness/identity/multi-loc decisions confirmed | P1 |
| S-02 | R02 | Bug | Patient | Patient confirmed but receptionist blind — data persisted, real-time sync failed | BOX-05..07 | New boxes proposed. Validates QA G-06 (WebSocket gaps) | P1 |
| S-03 | R03 | Feature | Patient | Mobile pre-check-in from personal device before arrival | BOX-08..11 | New boxes proposed. Depends on S-01 flow. Mitigates S-09 | P2 |
| S-04 | R04 | Critical Bug | Patient | Another patient's PHI flashed on screen — HIPAA breach | BOX-12..18 | CRITICAL. Generates HIPAA compliance boxes. Incident response required | P0 |
| S-05 | R05 | Business | Admin | Second clinic location — shared patient data | BOX-19..21 | New boxes proposed. Confirms multi-location open question from S-01 | P1 |
| S-06 | R06 | Compliance | State Board | Medication list collection mandate at every check-in | BOX-22..25 | Mandatory. Q3 deadline. New data category with 0-day staleness | P1 |
| S-07 | R07 | Bug | Receptionist | Two receptionists finalized same patient — data lost | BOX-26..28 | BOX-E5 proven NOT working. Must fix concurrent prevention | P0 |
| S-08 | R08 | Feature | Patient | Insurance card photo upload with OCR | BOX-29..31 | New boxes proposed. Extends BOX-03 update mechanism | P2 |
| S-09 | R09 | Performance | Receptionist | Monday morning crush — 30 concurrent check-ins, system freezes | BOX-32..35 | Performance boxes. Load testing required. S-03 mitigates | P1 |
| S-10 | R10 | Business (Major) | Admin | Acquiring Riverside Practice — 4,000 patients, paper + foreign EHR, duplicate detection | BOX-36..41 | Largest change. Migration project. Many open questions | P1 |

## Summary Statistics

- **Total boxes:** 41 (BOX-01 through BOX-41) + upstream boxes from Design (D1-D3), Engineering (E1-E5), DevOps (O1-O5)
- **Critical items:** S-04 (data breach), S-07 (concurrent finalization bug)
- **Compliance deadline:** S-06 medications by Q3
- **Open questions requiring stakeholder input:** S-03 (4), S-05 (3), S-08 (3), S-10 (7)

## Cross-Story Dependencies

```
S-03 (mobile pre-check-in) --mitigates--> S-09 (Monday crush)
S-05 (multi-location) --amplifies--> S-09 (peak load doubles)
S-10 (acquisition) --amplifies--> S-09 (4,000 more patients in search index)
S-06 (medications) --must-be-in--> S-03 (pre-check-in must include meds)
S-04 (data breach) --generates--> BOX-12..18 (HIPAA boxes apply to ALL stories)
S-10 (acquisition) --depends-on--> S-05 (multi-location architecture)
S-08 (photo upload) --extends--> S-03 (camera on mobile is natural)
S-07 (concurrent bug) --invalidates--> BOX-E5 (must be re-proven)
```

## Notes

- S-01 open questions are now resolved. See boxes-01.md "PM Decisions" section.
- HIPAA applicability is confirmed (was speculative in R01, now proven by S-04 incident).
- S-03 should be prioritized partly for its S-09 mitigation value — spreading check-in load temporally.
- S-10 is a migration project, fundamentally different from feature work. May need a separate workstream.
