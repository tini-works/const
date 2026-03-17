# Engineering Boxes — Complete Registry

All boxes originated by Engineering, across 10 rounds of negotiation.

---

## Round 1 (S-01)

| ID | Box | Status | Matched by |
|----|-----|--------|------------|
| BOX-E1 | Session timeout produces no data loss | Matched | Per-section persist. reinitiate API (G-02 resolved). Partial pre-check-in recovery (S-03). |
| BOX-E2 | Patient access is token-scoped, not authenticated | Matched | 64-char hashed tokens. Extended to mobile pre-check-in links (S-03). |
| BOX-E3 | Data updates are staged, not immediate | Matched | checkin_sections.confirmed_value applied only on finalize. Atomic finalization (BOX-E9). |
| BOX-E4 | Search index is eventually consistent | Matched | Event-driven rebuild. BOX-O2 monitors drift. |
| BOX-E5 | Concurrent check-in prevention | Matched | DB unique partial index. Cross-location (S-05). Optimistic locking on finalization (S-07). |

## Round 6 (S-06)

| ID | Box | Status | Matched by |
|----|-----|--------|------------|
| BOX-E6 | Medication completion is server-enforced | Matched | POST .../complete returns 400 if medications not confirmed. Cannot be bypassed by client bug. |

## Round 8 (S-08)

| ID | Box | Status | Matched by |
|----|-----|--------|------------|
| BOX-E7 | OCR is asynchronous with timeout fallback | Matched | Upload returns 202. Polling for result. 10s timeout to manual fallback. |

## Round 10 (S-10)

| ID | Box | Status | Matched by |
|----|-----|--------|------------|
| BOX-E8 | Import is idempotent on source_id | Matched | source_id + source_system unique. Re-import returns "already_imported". |
| BOX-E9 | Finalization is atomic (single transaction) | Matched | All patient_data mutations in one DB transaction. Responds to DevOps BOX-O1. |

---

## Summary

- **Total Engineering boxes:** 9 (BOX-E1 through BOX-E9)
- **All matched:** Yes
- **Pattern:** Engineering boxes fall into three categories:
  1. **System constraints PM/Design can't see** (E1, E2, E3, E4, E5) — behaviors that emerge from architectural choices
  2. **Safety gates** (E6, E9) — server-side enforcement of rules that client-side alone cannot guarantee
  3. **Integration realities** (E7, E8) — constraints from external system integration (OCR latency, import idempotency)

---

## Boxes Surfaced to Specific Verticals

### To PM (decisions needed)

| Box | Question | Impact if unresolved |
|-----|----------|---------------------|
| BOX-E2 (extended) | Is the one-shot link model acceptable for mobile pre-check-in? Patients cannot bookmark/revisit. | Mobile UX may confuse patients who try to return to the link |
| BOX-E8 | Should 100% confidence duplicates auto-merge or always human review? | Merge workflow scope |

### To Design (constraints to absorb)

| Box | Constraint | Design impact |
|-----|-----------|---------------|
| BOX-E1 | ~100ms latency per section confirm | Spinner during persist. Optimistic UI with reconciliation on error. |
| BOX-E4 | 2s search lag after record changes | "Update Record" on S2 may not reflect in S1 immediately. Not a bug. |
| BOX-E7 | OCR takes 2-10s | Patient sees spinner during OCR. Must offer manual fallback if >10s. Three states: processing, completed, failed. |

### To QA (new verification requirements)

| Box | What QA must test |
|-----|-------------------|
| BOX-E6 | Complete check-in without confirming medications -> assert 400 |
| BOX-E7 | OCR timeout -> assert manual fallback offered |
| BOX-E8 | Import same source_id twice -> assert no duplicate created |
| BOX-E9 | Kill service mid-finalization -> assert all-or-nothing |

### To DevOps (operational requirements)

| Box | What DevOps must provision |
|-----|--------------------------|
| BOX-E9 | DB transaction isolation level: READ COMMITTED minimum |
| BOX-E7 | OCR service integration: HIPAA BAA with cloud provider |
| BOX-E8 | Import pipeline: restart safety, monitoring for stuck batches |
