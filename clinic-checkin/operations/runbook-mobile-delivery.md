# Runbook: Mobile Check-In Delivery Failure

**Severity:** P1 during clinic hours (patients cannot use mobile check-in), P2 otherwise
**Impact:** Patients who requested mobile check-in links do not receive SMS/email. They must fall back to kiosk check-in. No data loss -- this affects convenience, not data integrity.
**Last tested:** 2026-03-17 — Simulated Twilio outage in staging, verified fallback detection and token expiry monitoring.
**Last triggered:** Never in production.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by** | Alert: [SMS Delivery Failure Rate](./monitoring-alerting.md#p1----notify-during-business-hours) (`notification_sent_total{type="sms",status="failure"}` rate > 10%), Alert: [Token Redemption Failure Rate](./monitoring-alerting.md#p1----notify-during-business-hours) (> 5% of redemption attempts), Alert: [Token Expiry Rate High](./monitoring-alerting.md#p2----investigate-during-next-business-day) (> 20% of issued tokens unused) |
| **Caused by** | Twilio/SendGrid service disruption, invalid phone numbers, token generation bug, or mobile SPA deployment issue |
| **Watches** | [Notification Service](../architecture/architecture.md#notification-service), [Mobile Check-In Links API](../architecture/api-spec.md#6-mobile-check-in-links), [ADR-001: WebSocket with Polling Fallback](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates) |
| **Proves** | [US-007: Mobile check-in link delivery](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device) — SMS/email delivery, [US-008: Mobile check-in flow](../product/user-stories.md#us-008-receptionist-visibility-of-mobile-check-ins) — token redemption and completion |
| **Detects** | Mobile delivery pipeline failure in production — SMS not sent, token not redeemable, or mobile SPA unreachable |
| **Confirmed by** | Jordan Lee (DevOps Lead), 2026-03-17 — simulated Twilio outage in staging, verified detection and diagnosis steps |

---

## Detection

How you'll know:
- Alert: `notification_sent_total{type="sms",status="failure"}` rate exceeds 10% of SMS attempts
- Alert: `mobile_token_redemption_failure_total` rate exceeds 5%
- Alert: daily token expiry rate exceeds 20% (tokens issued but never redeemed)
- Patient report: "I never got the text message with my check-in link"
- Staff report: "Multiple patients say mobile check-in links aren't working"

---

## Diagnosis

### Step 1: Identify Which Part of the Delivery Chain Is Broken

The mobile check-in delivery chain has 4 links:

```
Staff initiates → Notification Service sends SMS/email → Patient clicks link → Mobile SPA loads with token
```

```bash
# 1. Is the Notification Service healthy?
curl -s https://api.clinic-checkin.example.com/notification/health | jq .

# 2. Are SMS messages being sent at all?
curl -s https://api.clinic-checkin.example.com/metrics | grep notification_sent_total
# Check for type="sms" — are successes happening or all failures?

# 3. Check Twilio delivery status (if using Twilio)
# In Twilio console or via API:
# Look for delivery failures, carrier blocks, invalid numbers

# 4. Are tokens being generated correctly?
psql $DB_REPLICA_URL -c "
  SELECT id, patient_id, token, expires_at, redeemed_at, created_at
  FROM mobile_checkin_tokens
  WHERE created_at > NOW() - INTERVAL '2 hours'
  ORDER BY created_at DESC
  LIMIT 20;
"
# Check: are tokens being created? Are expiry times reasonable?

# 5. Is the mobile SPA reachable?
curl -s -o /dev/null -w "%{http_code}" https://checkin.clinic.example.com
# Should return 200
```

### Step 2: Fix Based on Root Cause

#### Root Cause: Twilio/SendGrid Outage

```bash
# Check Twilio status page: https://status.twilio.com
# Check SendGrid status page: https://status.sendgrid.com

# Check Notification Service logs for provider errors
# In Loki:
{service="notification-service"} | json | level="error" | message=~"twilio|sendgrid|sms|email"

# If Twilio is down and SendGrid is up, and both channels are configured:
# The service should automatically fall back to email delivery
# Verify fallback is working:
curl -s https://api.clinic-checkin.example.com/metrics | grep notification_sent_total
# Look for type="email" successes increasing
```

If no fallback is available:
- Inform clinic staff that mobile check-in links are temporarily unavailable
- Patients should use kiosk check-in instead
- No manual intervention needed -- links will resume when the provider recovers

#### Root Cause: Invalid Phone Numbers / Carrier Blocks

```bash
# Check failure reasons in Notification Service logs
{service="notification-service"} | json | message=~"delivery.*fail|undeliverable|blocked"

# Check for patterns -- same carrier? Same area code?
psql $DB_REPLICA_URL -c "
  SELECT p.phone, t.created_at, t.redeemed_at
  FROM mobile_checkin_tokens t
  JOIN patients p ON p.id = t.patient_id
  WHERE t.created_at > NOW() - INTERVAL '24 hours'
    AND t.redeemed_at IS NULL
  ORDER BY t.created_at DESC
  LIMIT 20;
"
```

#### Root Cause: Token Generation or Redemption Bug

```bash
# Check if tokens are being generated with correct format
psql $DB_REPLICA_URL -c "
  SELECT token, LENGTH(token) AS token_length, expires_at,
         expires_at - created_at AS ttl
  FROM mobile_checkin_tokens
  WHERE created_at > NOW() - INTERVAL '2 hours'
  LIMIT 10;
"
# Tokens should be valid format, TTL should match configured expiry

# Test token redemption manually
curl -s -X POST https://api.clinic-checkin.example.com/v1/checkins/mobile/validate \
  -H "Content-Type: application/json" \
  -d '{"token":"test-mobile-token-001"}' | jq .
# Should return patient context or appropriate error

# If tokens are generated but redemption fails, check Check-In Service logs:
{service="checkin-service"} | json | message=~"token.*invalid|token.*expired|mobile.*redeem"
```

#### Root Cause: Mobile SPA Not Loading

```bash
# Check CDN health
curl -s -o /dev/null -w "%{http_code}" https://checkin.clinic.example.com

# Check if recent deploy broke the SPA
# Verify version heartbeat
curl -s https://checkin.clinic.example.com/version.json | jq .

# If SPA is unreachable: check CDN invalidation, DNS, certificate
dig checkin.clinic.example.com
openssl s_client -connect checkin.clinic.example.com:443 < /dev/null 2>/dev/null \
  | openssl x509 -noout -dates
```

---

## Mitigation While Investigating

Mobile check-in is a convenience channel. The kiosk is always the fallback.

Tell receptionist staff:
> **"Mobile check-in links are temporarily unavailable. Please direct patients to use the kiosk for check-in. If a patient has already received a link that isn't working, they can check in at the kiosk instead."**

---

## Recovery Verification

After fixing the issue:

```bash
# 1. Verify Notification Service is healthy
curl -s https://api.clinic-checkin.example.com/notification/health | jq .

# 2. Send a test SMS (use a test patient)
curl -s -X POST https://api.clinic-checkin.example.com/v1/checkins/mobile/send-link \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{"patient_id":"<test_patient_uuid>","location_id":"<location_id>"}' | jq .

# 3. Verify the SMS was received (check test phone)

# 4. Verify token redemption works
# Open the link from the SMS on a mobile device, confirm check-in flow loads

# 5. Monitor SMS delivery rate for 30 minutes
curl -s https://api.clinic-checkin.example.com/metrics | grep notification_sent_total
# Failure rate should return to < 2%
```

---

## Post-Incident

If the outage lasted > 30 minutes during business hours:
- Count how many patients were affected (tokens issued but not redeemed during the window)
- Notify clinic managers that mobile check-in was temporarily unavailable
- No patient data was at risk -- mobile delivery failure is a convenience issue only
- Document the incident and root cause

---

## Prevention

- Monitor Twilio/SendGrid status pages (subscribe to status notifications)
- Maintain both SMS and email delivery paths for redundancy
- Set token expiry to a reasonable window (e.g., end of appointment day) to avoid premature expiry
- Include mobile check-in link delivery in post-deploy smoke tests
- Monitor token redemption rate as a business metric -- a declining rate may indicate UX issues, not just delivery failures
