# QA — Check-In Proofs

Four things we prove. Each one is runnable. Each one has a way to know when it breaks.

---

## VP-01: Returning patient, no changes — confirm flow completes

**What we're proving:** A returning patient whose data hasn't changed can confirm and be marked Ready without staff review.

**Run:**
1. Seed staging with TEST001 (returning patient, all data fresh, no changes since last visit)
2. POST /api/checkin { "mrn": "TEST001" }
3. Assert: response is `patient_type: "returning"`, `allergy_status: "current"`
4. Simulate kiosk confirm (no edits)
5. Assert: patient status = "Ready", staff review queue has NO entry for TEST001

**If it breaks:** Review queue false positive monitor fires — patients without edits are ending up in staff review.

---

## VP-02: Returning patient, insurance changed — staff review populated

**What we're proving:** When a returning patient edits a field (insurance, address, etc.), the change appears in the staff review queue for the receptionist.

**Run:**
1. Check in TEST001
2. On Welcome Back screen, edit insurance provider ("Aetna" → "BlueCross")
3. Confirm
4. Assert: staff review queue has an entry for TEST001 with change: insurance Aetna → BlueCross
5. Approve in staff review
6. Assert: patient status = "Ready"

**If it breaks:** Queue miss rate monitor — edits are being made but not showing up in staff review. This means staff can't verify changes.

---

## VP-03: Allergy data >6 months stale — re-confirmation screen appears

**What we're proving:** When a returning patient's allergy data hasn't been updated in >6 months, they see the Allergy Re-confirmation screen (SCR-03) before the Welcome Back screen.

**Run:**
1. Seed staging with TEST003 (allergy `last_updated` = 8 months ago)
2. POST /api/checkin { "mrn": "TEST003" }
3. Assert: response includes `allergy_status: "stale"`
4. Assert: kiosk flow shows SCR-03 first
5. Confirm allergies ("These are still correct")
6. Assert: allergy `last_updated` resets to today
7. Check in TEST003 again immediately
8. Assert: SCR-03 does NOT appear (staleness clock was reset)

**If it breaks:** Monitor allergy-fetch response `last_updated` headers. If patients with stale data are bypassing SCR-03, the staleness check in FLW-04 is broken.

---

## VP-04: New patient — full intake still works (regression)

**What we're proving:** The new check-in flow for returning patients didn't break the existing intake flow for new patients.

**Run:**
1. Check in with MRN NEW001 (no prior visits in the system)
2. Assert: response is `patient_type: "new"`
3. Assert: kiosk shows Full Intake Form (not Welcome Back, not Allergy Re-confirmation)
4. Complete intake
5. Assert: patient status = "Ready"

**If it breaks:** Existing intake monitors. If new patients are seeing Welcome Back or getting errors, the returning-patient branching has a bug.

---

## Coverage

| Commitment | Verified by | Degradation signal |
|------------|-------------|-------------------|
| 1. Data is there when patient arrives | VP-01, VP-02 | Yes |
| 2. Data persists across visits | VP-01, VP-02, VP-03 | Yes |
| 3. Confirm, don't re-enter | VP-01 | Yes |
| 4. Stale allergy guard | VP-03 | Yes |
| Regression (new patients) | VP-04 | Yes |

Every commitment has a proof. Every proof is runnable. Every proof has a degradation signal.
