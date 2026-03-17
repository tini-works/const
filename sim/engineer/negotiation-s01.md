# Engineer Negotiation — Story 01

## Boxes Received from Design

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-01: Returning patient is recognized | **Accepted** | Requires a search service with index over patient records. Lookup by name+DOB must return results in <200ms for typeahead UX. |
| BOX-02: Previously collected data is not re-asked | **Accepted** | Patient data must be stored per-category with last-confirmed timestamps. Check-in service assembles a confirmation view from stored data, never blank fields for existing data. |
| BOX-03: Confirm or update, not re-enter | **Accepted** | Check-in session is a stateful object. Each section tracks its own status (pending/confirmed/updated). Updates are patches, not replacements. |
| BOX-04: Experience communicates recognition | **Accepted** | Patient-facing API returns first name in the session payload. Greeting is data-driven, not hardcoded. |
| BOX-D1: Graceful recognition failure | **Accepted with constraint** | Fuzzy search is expensive. I'll implement it as a separate endpoint with looser matching (Levenshtein on names, partial DOB, phone/email lookup). This is S1b only — S1 uses exact-prefix matching for speed. |
| BOX-D2: Two actor views | **Accepted** | Two separate API response shapes for the same check-in session: receptionist view (full detail + diffs) and patient view (confirmation-only, first name only). Access controlled by role and session token. |
| BOX-D3: Partial data handling | **Accepted** | Each data category is independently nullable. The confirmation view splits sections into "existing" and "missing" groups server-side. Client renders two lists, not one mixed list. |

## Boxes I'm Adding Upward

### BOX-E1: Session timeout produces no data loss

Design specifies 5-minute inactivity timeout on S3P with partial progress preserved. This has a system implication: **confirmed sections must be persisted immediately on each confirmation action, not batched at the end.**

If we batch (save all on "All Confirmed"), a timeout loses everything. If we persist per-section, a timeout loses only unconfirmed sections, and re-initiation restores progress.

**Constraint:** This means every "Still correct" / "Update" tap is a write operation. The check-in session is a write-heavy, short-lived entity. I need to size the data layer accordingly.

**Upstream impact:** Design should know that each confirmation tap has ~100ms latency (network round-trip for persist). If they want instant UI feedback, the client must optimistically update and reconcile on error.

### BOX-E2: Patient access is token-scoped, not authenticated

The patient is not a logged-in user. They're handed a tablet. The check-in session must be accessible via a short-lived, unguessable token — not via user authentication.

**Constraints:**
- Token is generated when receptionist clicks "Begin Check-in" and embedded in the patient-facing URL.
- Token expires when: (a) session is finalized, (b) session times out, or (c) a hard TTL of 30 minutes passes.
- Token grants access to exactly one check-in session. No patient record browsing.
- Token must not appear in server logs (PII-adjacent).

**Upstream impact:** PM should know this means the patient cannot bookmark, share, or revisit this URL. It's a one-shot, one-session access mechanism. If they want a patient portal with self-service check-in later, that's a different architecture.

### BOX-E3: Data updates are staged, not immediate

When a patient taps "Update" and changes their insurance info on S3P, that data is **not written to the patient record immediately**. It is staged in the check-in session.

The receptionist sees the diff on S3R. Only when the receptionist clicks "Complete Check-in" (finalize) are the updates applied to the patient record.

**Why:** The receptionist may need to verify updates (e.g., scan a new insurance card). Applying unverified patient-entered data directly to the record violates data integrity.

**Upstream impact:**
- Design: S3R's "flagged items" with old-vs-new is not cosmetic — it's a review gate. The receptionist is approving staged changes. Design already has this concept but should know it's load-bearing, not decorative.
- PM: This means there's a window where the patient has submitted data that isn't yet on their record. If the receptionist doesn't finalize, the staged data exists in the check-in session but never reaches the patient record. PM should decide: do unfinalised sessions expire silently, or should they generate a follow-up task?

### BOX-E4: Search index is eventually consistent

Patient records live in the primary data store. The search index (used by S1 and S1b) is a derived, eventually-consistent projection.

**Why this matters:**
- A patient registered 30 seconds ago at another location might not appear in search yet.
- A receptionist who just updated a name via "Update Record" on S2 might not find the patient under the new name immediately on S1.
- Typical lag: <2 seconds under normal load.

**Upstream impact:** Design should know that the "Update Record" flow on S2 may have a brief window where the updated data isn't reflected in S1 search results. This is not a bug; it's a consistency tradeoff for search performance. If this is unacceptable, we need synchronous indexing, which adds ~300ms to every write.

### BOX-E5: Concurrent check-in prevention

If a receptionist starts a check-in for Patient X, and another receptionist at another terminal tries to start a check-in for the same patient, the system must prevent it. Two simultaneous check-in sessions for the same patient would produce conflicting data.

**Constraint:** At most one active check-in session per patient. Attempting to create a second returns an error with the existing session ID and the name of the receptionist who initiated it.

**Upstream impact:** Design needs a screen state for this: "This patient is already being checked in by [Receptionist Name] at [time]." This is a new state on S2 that doesn't exist in Design's current state machine.

## Open Questions to PM

1. **Unfinalised session policy** (from BOX-E3): When a check-in session is created but never finalized (receptionist gets busy, patient leaves), what happens? Options: (a) auto-expire after 30 min, discard staged changes silently; (b) create a follow-up task for the receptionist; (c) keep in limbo until next visit. I recommend (a) with an audit log entry.

2. **HIPAA data-at-rest requirements**: Patient data (allergies, insurance) stored in the database must be encrypted at rest. The patient-facing token must not encode PII. Is there a specific encryption standard required, or is AES-256 at the storage layer sufficient?

3. **Audit trail depth**: Every data change (confirmation, update, who did it, when) will be logged. How long must audit records be retained? This affects storage sizing.
