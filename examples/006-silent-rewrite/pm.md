# PM — Order Processing

Not involved in the rewrite. Not notified. Correct.

Found out at standup. Response: "Still works? Great."

## Contracts held

| Contract | Threshold | Verify |
|----------|-----------|--------|
| B1: Order status queryable after state change | < 5s | `GET /api/orders/{id}/status` after a state transition. Response within 5s. QA's VP-01 covers this. |
| B2: Concurrent order capacity | 500 orders | Staging load test at 500+ concurrent. Engineer ran 2000. DevOps has the metrics. |
| B3: Confirmation visible to customer after payment | < 2s | Time from payment webhook to confirmation screen render. QA's VP-12 covers this. |

None of these mention language, architecture, or deployment topology. That's why the rewrite didn't require PM involvement.
