# Story 02 — Patient Confirmed But Receptionist Blind (Bug)

## Customer's Words

> "I confirmed everything on the screen, tapped Confirm, got a green checkmark. But then the receptionist called me up and asked me to fill out the paper form anyway. She said she couldn't see anything on her screen."

## What the Customer Is Saying

Two things:

1. **"I got a green checkmark"** — The patient completed their part of the contract. The system told them they were done. They trusted the green checkmark. This is not a vague complaint — the patient received positive confirmation from the system.

2. **"She said she couldn't see anything on her screen"** — The receptionist's view did not reflect the patient's completed actions. The two sides of the check-in (patient view, receptionist view) were disconnected. The patient had to fall back to paper — the exact pre-system experience.

## What the Customer Is NOT Saying

- They're not complaining about the check-in flow itself. The kiosk experience worked for them. The failure was the handoff between patient completion and receptionist visibility.
- They're not saying the data was lost. They don't know if it was lost or just not displayed. From their perspective, the effect is the same: their effort was wasted.

## Impact Analysis

This bug directly undermines BOX-04 (experience communicates recognition). The patient did everything right and was still treated as if they hadn't. The green checkmark becomes a lie.

**Relates to existing boxes:** BOX-E1 (no data loss on timeout), BOX-D2 (two actor views). The root cause is likely the WebSocket connection between patient session and receptionist view (QA flagged this in G-06: no WebSocket contract tests).

## Candidate Root Causes (for Engineering)

1. WebSocket event (`patient.complete` or `section.updated`) never delivered to receptionist client
2. Receptionist's browser lost WebSocket connection silently — no reconnection, no fallback polling
3. Session data was persisted (patient side worked) but the real-time notification channel failed
4. Receptionist was looking at a stale screen — S3R never opened or refreshed

This bug validates QA's G-06 gap (WebSocket events have no contract test) and DevOps's concern about WebSocket reconnection strategy.
