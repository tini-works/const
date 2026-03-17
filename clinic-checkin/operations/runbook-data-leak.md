# Runbook: Patient Data Leak (PHI Exposure)

**Severity:** P0 -- Page Immediately
**SLA:** Acknowledge within 15 minutes, contain within 1 hour
**Last tested:** 2026-03-17 — Tabletop exercise: simulated BUG-002 recurrence, walked through containment and HIPAA assessment steps.
**Last triggered:** Never in production. BUG-002 occurred in QA; ADR-002 session purge has held.

This runbook covers any incident where one patient's PHI is exposed to another patient, unauthorized staff member, or external party. This includes BUG-002-class issues (kiosk session isolation failure) and any other unauthorized data exposure.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: [Data Leak Detected](./monitoring-alerting.md#p0----page-immediately-any-time) (`security_session_isolation_failure > 0`) |
| **Caused by:** | [BUG-002: Previous patient's data visible on kiosk](../quality/bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan) — the original P0 incident |
| **Fixed by:** | [ADR-002: Session Purge Protocol](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation) — three-layer defense-in-depth |
| **Watches:** | [Check-In Service session isolation](../architecture/architecture.md#check-in-service-core), [Session Purge Protocol](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation) |
| **Proves:** | [US-003: Secure patient identification on scan](../product/user-stories.md#us-003-secure-patient-identification-on-scan) — no PHI leakage between sessions |
| **Detects:** | [TC-301: Sequential patients no leakage](../quality/test-suites.md#tc-301-sequential-patients--no-data-leakage), [TC-302: Rapid scans](../quality/test-suites.md#tc-302-rapid-sequential-scans--no-data-leakage), [TC-303: Sub-second timing](../quality/test-suites.md#tc-303-rapid-sequential-scans--sub-second-timing), [TC-304: DOM inspection](../quality/test-suites.md#tc-304-session-purge--dom-inspection), [TC-305: Back button](../quality/test-suites.md#tc-305-browser-back-button-does-not-reveal-previous-session) — any of these failing in production |

---

## Detection

How you'll know:
- Alert: `security_session_isolation_failure_total > 0`
- Patient report: "I saw someone else's information on the screen"
- Staff report: "A patient mentioned seeing another patient's name"
- Audit log anomaly: patient record accessed without a corresponding check-in session
- Security scan: PHI found in logs, cache, or browser storage

---

## Immediate Response (First 15 Minutes)

### 1. Acknowledge and Assess

```bash
# Check if the alert is real -- verify the metric
curl -s https://api.clinic-checkin.example.com/metrics | grep session_isolation

# Check recent audit logs for anomalous access patterns
# Connect to the read replica for queries (don't load the primary)
psql $DB_REPLICA_URL -c "
  SELECT entity_type, entity_id, action, actor_type, actor_id, created_at
  FROM audit_log
  WHERE created_at > NOW() - INTERVAL '1 hour'
    AND action = 'read'
    AND actor_type = 'patient'
  ORDER BY created_at DESC
  LIMIT 50;
"
```

### 2. Determine Scope

Answer these questions:
- **Which kiosk(s)?** Check the kiosk_id in audit logs and the alert metadata.
- **Which patients were affected?** Both the patient whose data was exposed AND the patient who saw it.
- **What data was exposed?** Name only? Allergies? Medications? Insurance? Full record?
- **Is it ongoing?** Is the issue still happening on other kiosks?

```bash
# Find check-ins on the affected kiosk in the time window
psql $DB_REPLICA_URL -c "
  SELECT ci.id, ci.patient_id, ci.started_at, ci.completed_at,
         p.first_name, p.last_name
  FROM check_ins ci
  JOIN patients p ON p.id = ci.patient_id
  WHERE ci.kiosk_id = '<affected_kiosk_uuid>'
    AND ci.started_at > NOW() - INTERVAL '2 hours'
  ORDER BY ci.started_at;
"
```

### 3. Contain

If the issue is ongoing (session isolation failure confirmed):

```bash
# Option A: Disable the affected kiosk immediately
# Update kiosk status in the database
psql $DB_PRIMARY_URL -c "
  UPDATE kiosks SET is_active = false WHERE id = '<affected_kiosk_uuid>';
"
# The kiosk SPA checks this flag and shows "Kiosk unavailable" if false

# Option B: If the issue may affect ALL kiosks, take the nuclear option
# Restart all Check-In Service instances to clear any in-memory state
kubectl rollout restart deployment/checkin-service
# Or for ECS:
aws ecs update-service --cluster clinic-prod --service checkin-service --force-new-deployment
```

If the issue is a code bug (not just stale state):
```bash
# Rollback to the last known good deployment
kubectl set image deployment/checkin-service \
  checkin-service=registry.example.com/checkin-service:<last-known-good-sha>
```

---

## Investigation (First Hour)

### 4. Root Cause Analysis

Check the session purge protocol:

```bash
# Check application logs for session purge events around the incident time
# In Loki/Grafana:
{service="checkin-service"} | json | message=~"session.*reset|session.*purge|new.*scan"
  | kiosk_id="<affected_kiosk_uuid>"
  | timestamp > "<incident_time_minus_5min>"
  | timestamp < "<incident_time_plus_5min>"

# Check for rapid sequential scans (< 1 second apart)
psql $DB_REPLICA_URL -c "
  SELECT ci1.patient_id AS patient_a, ci2.patient_id AS patient_b,
         ci1.started_at AS scan_a, ci2.started_at AS scan_b,
         EXTRACT(EPOCH FROM (ci2.started_at - ci1.started_at)) AS gap_seconds
  FROM check_ins ci1
  JOIN check_ins ci2 ON ci1.kiosk_id = ci2.kiosk_id
    AND ci2.started_at > ci1.started_at
    AND ci2.started_at < ci1.started_at + INTERVAL '5 seconds'
  WHERE ci1.kiosk_id = '<affected_kiosk_uuid>'
    AND ci1.started_at > NOW() - INTERVAL '24 hours'
  ORDER BY ci1.started_at;
"
```

Check browser-level issues:
- Is the kiosk running the latest SPA version? (Version mismatch after deploy can break session purge)
- Is the kiosk Chrome in a bad state? (Memory pressure can cause delayed garbage collection)
- Was the kiosk restarted recently? (Boot sequence may skip initialization)

### 5. Document Affected Parties

Create a list of every patient whose data may have been exposed:

```bash
# Patient whose data was seen by someone else = the EXPOSED patient
# Patient who saw the data = the WITNESS patient
# Both need to be notified

psql $DB_REPLICA_URL -c "
  SELECT p.id, p.first_name, p.last_name, p.phone, p.email
  FROM patients p
  WHERE p.id IN ('<exposed_patient_id>', '<witness_patient_id>');
"
```

---

## HIPAA Breach Assessment (Within 24 Hours)

### 6. Determine if This Is a Reportable Breach

Per HIPAA Breach Notification Rule (45 CFR 164.402-414):

A breach is presumed unless you can demonstrate a low probability that PHI was compromised, based on:

1. **Nature and extent of PHI involved** -- Was it just a name? Name + allergies? Full record with SSN?
2. **Who saw it?** -- Another patient (unauthorized person) vs. staff member (possibly authorized)
3. **Was the PHI actually acquired or viewed?** -- "I saw a name flash for a split second" vs. "I read their allergy list"
4. **Extent of mitigation** -- Did we contain it immediately?

### Decision Matrix

| Data Exposed | Likely Reportable? |
|-------------|-------------------|
| Name only, brief flash (< 1 second) | Possibly not (low probability of compromise) |
| Name + clinical data (allergies, medications) | Yes |
| Name + insurance info (member ID, SSN) | Yes |
| Any data viewed long enough to read/memorize | Yes |

### If Reportable

1. Notify compliance officer / privacy officer immediately
2. Individual notification to affected patients within 60 days (HIPAA requirement)
3. If > 500 individuals affected: notify HHS and media within 60 days
4. If < 500 individuals affected: log for annual HHS reporting
5. Document everything: timeline, root cause, remediation steps, notifications sent

---

## Remediation

### 7. Fix and Verify

After root cause is identified:

1. Implement fix (may be code fix, configuration fix, or kiosk restart)
2. Run the automated session isolation test suite:

```bash
# These tests simulate rapid sequential card scans and verify DOM isolation
npm run test:session-isolation

# Run the headless browser test specifically
npm run test:e2e -- --grep "session purge"
```

3. Deploy fix through normal CI/CD pipeline (even for P0, run full tests)
4. Re-enable affected kiosk(s):

```bash
psql $DB_PRIMARY_URL -c "
  UPDATE kiosks SET is_active = true WHERE id = '<affected_kiosk_uuid>';
"
```

5. Monitor the `security_session_isolation_failure_total` metric for 24 hours

### 8. Post-Incident

- Write incident postmortem within 48 hours
- Include: timeline, root cause, impact (which patients, what data), remediation, prevention
- Review with security lead and compliance officer
- Update this runbook if the incident revealed a gap

---

## Communication Templates

### To clinic staff (immediate):

> **ALERT: A potential data exposure has been reported on Kiosk [X] at [Location]. The kiosk has been taken offline while we investigate. Please direct patients to other kiosks or assist them manually at the front desk. Do not attempt to restart the kiosk. We will notify you when it's safe to use again.**

### To affected patient (within 60 days if reportable):

> **[Letter -- compliance/legal team drafts the actual notification per HIPAA 164.404]**

---

## Escalation

| Time | If | Escalate to |
|------|------|-------------|
| +0 min | Alert fires | On-call engineer |
| +15 min | No ack | Secondary on-call |
| +30 min | Issue not contained | CTO + compliance officer |
| +1 hour | Confirmed breach | Legal counsel |
