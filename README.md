# const

A framework for how teams work together — not by passing work down a chain, but by each team owning their part and matching at the boundaries.

Born from a simple observation: most process failures happen at handoffs. Requirements get lost. Designs get misinterpreted. Code doesn't match the spec. Tests prove the wrong thing. Production breaks silently. Each team did their job — but the work between teams fell through the cracks.

The Constitution replaces handoffs with **matching**. Each team independently discovers what must be true, negotiates boxes with the teams they touch, and proves their work with evidence. No waterfall. No ticket-passing. Just independent teams keeping honest inventories and matching at the seams.

## Read this

| Document | What it is | Start here if... |
|----------|-----------|------------------|
| [CONST.md](CONST.md) | The framework — 3 fundamentals, 5 verticals, 4 mechanics | You want the full operating model |
| [ELI10.md](ELI10.md) | The same thing, explained with a treehouse | You want to understand the ideas first |
| [examples/](examples/) | Working examples — real-world events driving real inventories | You want to see it in practice |

## The idea in 30 seconds

1. **Don't derive, match.** When work crosses a team boundary, the receiving team doesn't blindly follow instructions. They figure out what must be true (boxes), negotiate with the sender, then match those boxes however they see fit.

2. **Start from the source.** Every piece of work has an origin — a change in reality that demands a response. Each vertical matches against verified items — from the origin, from other verticals, or both. They don't control what arrives. They control what they choose to match.

3. **Own your inventory.** Each team keeps a warehouse of their work — with traces showing where each item came from, what it matches, and who verified it. When something changes, the traces tell you what else needs checking.

## Examples

### [PickRight Logistics](examples/pickright/)
A 3PL warehouse (~15 people, 1 site) running an off-the-shelf WMS for 5 clients — cosmetics with lot tracking, high-volume electronics, cold chain specialty food, and two clients migrated from a competitor. Evolved through 15 rounds: a mispick crisis, a cold chain onboarding, a competitor acquisition, and recovery. Five verticals responded — inventories grew from basic to battle-tested. **Stresses:** multi-client complexity, regulatory compliance (lot traceability, cold chain), crisis and recovery, competitor migration under pressure.

### [NeoLedger Core Banking](examples/core-banking/)
A Series A fintech platform (25 people) providing deposit accounts, card programs, and payments-as-a-service to 3 live clients via REST API. Sponsor bank holds the charter. SOC 2 audit in 4 months, PCI-DSS required, BSA/AML obligations. Evolved through 5 rounds of steady improvement with a skeleton crew — 2 engineers, no dedicated QA or DevOps. **Stresses:** heavy regulatory surface (OCC, PCI, SOC 2, BSA/AML), understaffed verticals, sponsor bank dependency, multiple client SLAs.

## Companion

The [const-companion](companion/skills/const-companion/SKILL.md) is a Socratic skill that helps teams discover, audit, and maintain their inventory. Four modes: **Bootstrap** (build inventory from scratch), **Audit** (prune ceremony, surface gaps), **Change Trace** (follow a change through matched items), **Pulse** (health check across verticals). It questions — it never prescribes.
