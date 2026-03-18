# const

A framework for how teams work together — not by passing work down a chain, but by each team owning their part and matching at the boundaries.

Born from a simple observation: most process failures happen at handoffs. Requirements get lost. Designs get misinterpreted. Code doesn't match the spec. Tests prove the wrong thing. Production breaks silently. Each team did their job — but the work between teams fell through the cracks.

The Constitution replaces handoffs with **matching**. Each team independently discovers what must be true, negotiates boxes with the teams they touch, and proves their work with evidence. No waterfall. No ticket-passing. Just independent teams keeping honest inventories and matching at the seams.

## Read this

| Document | What it is | Start here if... |
|----------|-----------|------------------|
| [CONST.md](CONST.md) | The framework — 3 fundamentals, 5 verticals, mechanics | You want the full operating model |
| [ELI10.md](ELI10.md) | The same thing, explained with a treehouse | You want to understand the ideas first |
| [examples/](examples/) | Working examples — real-world events driving real inventories | You want to see it in practice |

## The idea in 30 seconds

1. **Don't derive, match.** When work crosses a team boundary, the receiving team doesn't blindly follow instructions. They figure out what must be true (boxes), negotiate with the sender, then match those boxes however they see fit.

2. **Start from the source.** Every piece of work has an origin — a change in reality that demands a response. Each vertical matches against verified items — from the origin, from other verticals, or both. They don't control what arrives. They control what they choose to match.

3. **Own your inventory.** Each team keeps a warehouse of their work — with breadcrumbs showing where each item came from, what it matches, and who verified it. When something changes, the breadcrumbs tell you what else needs checking.

## Examples

### [Clinic Check-In](examples/clinic-checkin/)
A clinic patient check-in system that evolved through 10 rounds of complaints, bugs, features, compliance mandates, and business changes. A patient complained about re-entering data. Then a bug broke the receptionist's screen. Then another patient's data leaked. Then the clinic opened a second location. Then it acquired another practice with 4,000 patients. Five teams responded — each maintaining their own inventory. **Stresses:** external customers, healthcare compliance, data sensitivity, gradual evolution.

### [Pave — Internal Deploy Platform](examples/pave/)
An internal deploy platform serving ~20 product teams at a mid-size tech company. A Friday deploy broke checkout. Then a team SSH'd to prod to bypass the platform. Then the platform's own database migration took it down for 4 hours. Then the VP mandated deploy frequency as a KPI and teams gamed it. Then the CTO proposed replacing the whole thing with a managed platform. Six platform engineers responded — each proving their work against internal customers who think they know better. **Stresses:** internal customers, origin ambiguity, platform eating itself, political pressure, existential justification.
