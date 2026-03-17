# Priority and Sequencing

How the 10 stories should be ordered based on severity, dependencies, deadlines, and business impact.

---

## Tier 0 — Fix Now (system integrity at risk)

### S-04: Data Breach (PHI exposure)
- HIPAA violation in production
- Requires: immediate screen clearing fix, incident response, breach assessment
- Boxes: BOX-12..18
- Unblocks: HIPAA compliance framework for all other stories

### S-07: Concurrent Finalization Bug (data loss)
- Data integrity failure — patient data silently lost
- BOX-E5 is broken. Must be fixed and re-proven
- Boxes: BOX-26..28
- Unblocks: trust in the finalization pipeline

---

## Tier 1 — Must Do (operational necessity or hard deadline)

### S-02: Receptionist Blind to Patient Completion
- Core workflow broken — receptionist falls back to paper
- Validates QA G-06 (WebSocket gaps)
- Boxes: BOX-05..07
- Unblocks: real-time sync reliability for all future features

### S-06: Medication List Mandate
- **Deadline: Q3** — non-negotiable, license at stake
- New data category integrated into check-in flow
- Boxes: BOX-22..25
- Unblocks: regulatory compliance

### S-05: Second Clinic Location
- **Deadline: next month** — the location is opening
- Architecture must support multi-location before it opens
- Boxes: BOX-19..21
- Unblocks: S-10 (acquisition builds on multi-location)

### S-09: Monday Morning Crush
- Patients leaving. Revenue loss. Staff frustration.
- Performance engineering and capacity planning
- Boxes: BOX-32..35
- Partially mitigated by: S-03 (mobile pre-check-in)

---

## Tier 2 — Strategic (high value, can sequence)

### S-03: Mobile Pre-Check-In
- High patient value. Mitigates S-09. Extends S-01.
- Requires appointment system integration (new dependency)
- Boxes: BOX-08..11
- Must include S-06 medications when launched

### S-08: Insurance Card Photo Upload
- Patient convenience. Competitive expectation.
- Requires OCR capability (new technology)
- Boxes: BOX-29..31
- Natural fit with S-03 (photo from phone)

### S-10: Riverside Acquisition
- Largest scope. Migration project.
- Many open questions to resolve with administrator
- Boxes: BOX-36..41
- Depends on: S-05 (multi-location), S-09 (performance headroom)
- Timeline driven by acquisition closing date (unknown)

---

## Sequencing Dependencies

```
S-04 ──┐
S-07 ──┤ (Tier 0: fix immediately, in parallel)
       │
S-02 ──┤ (fix WebSocket, enables real-time reliability)
S-05 ──┤ (multi-location architecture, deadline: next month)
       │
S-06 ──┤ (medications, deadline: Q3, can parallel with above)
S-09 ──┤ (performance, informs capacity for everything)
       │
S-03 ──┤ (pre-check-in, builds on S-01+S-05+S-06)
S-08 ──┤ (photo upload, can parallel with S-03)
       │
S-10 ──┘ (acquisition migration, builds on everything above)
```

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| S-04 triggers formal HIPAA breach investigation | Medium | Critical | Immediate remediation + incident documentation |
| S-06 Q3 deadline missed | Low | Critical (license) | Start early, medications are a well-understood data category |
| S-05 location opens before system supports multi-location | Medium | High | Prioritize architectural changes over UX polish |
| S-10 acquisition creates thousands of duplicates | High | High | Invest in duplicate detection quality before bulk import |
| S-09 performance degrades further with S-05 + S-10 scale | High | Medium | Load test before each scale increase |
| S-03 mobile pre-check-in increases attack surface | Medium | Medium | BOX-11 identity verification, security review |
