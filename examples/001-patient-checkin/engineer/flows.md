# Engineer — System Flows

Four flows. Each proves a specific commitment works end-to-end.

---

## FLW-01: Patient lookup on check-in scan

**What happens:** Patient scans their card at the kiosk. The system identifies them by MRN, retrieves their last-visit snapshot, and determines if they're a returning patient.

```
POST /api/checkin
Body: { "mrn": "PAT-001" }

Response (returning patient):
{
  "patient_type": "returning",
  "last_visit": "2024-11-15",
  "demographics": { ... },
  "allergies": { ..., "last_updated": "2024-08-01" }
}
```

**Verify:** `POST /api/checkin { "mrn": "TEST001" }` in staging returns patient data with `patient_type: "returning"`.

**Depends on:** HIS Module A and B being reachable. If either is down, check-in fails.

---

## FLW-02: Two-source data fetch

**What happens:** Check-In Service calls HIS Module A (demographics) and HIS Module B (allergies) in parallel. Both responses are merged into a single patient record.

**Why parallel:** Sequential calls would double the check-in latency. SLA is <2 seconds. Each HIS call takes 400-800ms.

**Verify:** Monitor check-in latency in production. P95 should be <2s. If either HIS module degrades, latency spikes and OBS-02 fires.

**Depends on:** HIS SLA. If Module B is slow, the entire check-in is slow.

---

## FLW-03: Diff and populate

**What happens:** The system compares the patient's current data against their last-visit snapshot. Unchanged fields are pre-filled as-is. Changed fields (e.g., a new address from a demographic update by another clinic) are pre-filled but flagged for staff review.

```
Diff result:
{
  "unchanged": ["name", "dob", "phone", "allergies"],
  "changed": [
    { "field": "address", "old": "123 Oak St", "new": "456 Elm Ave", "source": "HIS update" }
  ]
}
```

**Verify:** In staging, update TEST001's address in HIS directly (simulating an update from another clinic). Check in TEST001. Welcome Back screen shows the new address with a change flag. Staff review queue shows the change.

**Depends on:** HIS data being accurate. If HIS has bad data, the diff is meaningless.

---

## FLW-04: Allergy staleness check

**What happens:** Before sending the pre-filled form to the kiosk, the system checks the `last_updated` timestamp on the allergy data. If >6 months old, it flags the record for re-confirmation.

```
if (now - allergies.last_updated > 6_months):
    response.allergy_status = "stale"
    // Kiosk shows SCR-03 before SCR-01
else:
    response.allergy_status = "current"
    // Kiosk shows SCR-01 directly
```

**Verify:** In staging, set TEST003's allergy `last_updated` to 8 months ago. Check in TEST003. Response includes `allergy_status: "stale"`. Kiosk shows SCR-03 (Allergy Re-confirmation) before SCR-01.

**Depends on:** HIS Module B returning the `last_updated` timestamp. If this field is missing, the staleness check can't run — fail-safe should assume stale.
