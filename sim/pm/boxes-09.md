# Boxes — Story 09 (Monday Morning Crush)

---

## BOX-32: System handles 30 concurrent check-ins per location without degradation

The system must maintain its performance targets (<200ms search, <100ms section save, <2s WebSocket delivery) with 30 concurrent check-in sessions at a single location.

**Traces to:** "Between 8 and 9 AM we get 30 patients checking in at once."

**Verified when:** Load test with 30 concurrent simulated check-in sessions shows all performance targets met. No screen freezes, no search timeouts.

---

## BOX-33: System handles 60 concurrent check-ins across all locations

With two locations (S-05) and a potential third (S-10), the system must handle aggregate peak load of 60+ concurrent sessions.

**Traces to:** S-05 (second location) + S-09 (30/location) + S-10 (acquisition adds volume).

**Verified when:** Load test with 60 concurrent sessions across simulated multi-location setup. Performance targets hold.

---

## BOX-34: Degraded performance is visible to staff, not silent

When the system is under load and response times increase, the receptionist must see a clear indicator — not just a frozen screen.

**Traces to:** "Half the time I just tell people to sit down and I'll call them when the system catches up" — the receptionist has no system feedback. They diagnose the problem from absence of response.

**Verified when:** When API response times exceed 2x target, the receptionist UI shows a load indicator. When response times exceed 5x target, a warning banner appears: "System is experiencing high load. Check-ins may be delayed."

---

## BOX-35: Patient loss due to wait times is measurable

The receptionist reported losing 2 patients. The system should track check-in abandonment so the business can measure and respond to it.

**Traces to:** "We've lost two patients this month — they just left."

**Verified when:** Sessions that are created but never finalized (patient walked away) are tracked as abandonments. A report shows: date, time, wait time before abandonment, location.

---

## Mitigation Note

S-03 (mobile pre-check-in) is the strategic solution to Monday morning crush. Patients who pre-check-in at home don't consume kiosk time or receptionist attention during peak hours. S-03 should be prioritized partly for its S-09 mitigation value.
