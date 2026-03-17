# const

A framework for how teams work together — not by passing work down a chain, but by each team owning their part and matching at the boundaries.

Born from a simple observation: most process failures happen at handoffs. Requirements get lost. Designs get misinterpreted. Code doesn't match the spec. Tests prove the wrong thing. Production breaks silently. Each team did their job — but the work between teams fell through the cracks.

The Constitution replaces handoffs with **matching**. Each team independently discovers what must be true, negotiates checkboxes with the teams they touch, and proves their work with evidence. No waterfall. No ticket-passing. Just independent teams keeping honest inventories and matching at the seams.

## Read this

| Document | What it is | Start here if... |
|----------|-----------|------------------|
| [CONST.md](CONST.md) | The framework — 4 fundamentals, 5 verticals, mechanics | You want the full operating model |
| [ELI10.md](ELI10.md) | The same thing, explained with a treehouse | You want to understand the ideas first |
| [clinic-checkin/](clinic-checkin/) | A working example — 10 rounds of real-world events | You want to see it in practice |

## The idea in 30 seconds

1. **Don't derive, match.** When work crosses a team boundary, the receiving team doesn't blindly follow instructions. They figure out what must be true (checkboxes), negotiate with the sender, then match those checkboxes however they see fit.

2. **Start from the customer.** Everyone works from the same customer story — not from each other's documents. A patient says "I don't want to re-enter my info." Five teams hear the same sentence and each discovers what it means for their domain.

3. **Own your inventory.** Each team keeps a warehouse of their work — with breadcrumbs showing where each item came from, what it matches, and who verified it. When something changes, the breadcrumbs tell you what else needs checking.

4. **Iterate together, own separately.** Teams work in parallel, not in sequence. The overlap is real. But each team owns their domain. You can't skip the matching — that's how you know the work is coherent.

## The example

The [clinic-checkin/](clinic-checkin/) directory is a complete worked example. A clinic patient check-in system that evolved through 10 rounds:

A patient complained about re-entering data. Then a bug broke the receptionist's screen. Then someone asked for mobile check-in. Then another patient's data leaked. Then the clinic opened a second location. Then the state mandated medication lists. Then two receptionists edited the same patient. Then someone wanted to photograph their insurance card. Then Monday mornings crushed the system. Then the clinic acquired another practice with 4,000 patients.

Five teams responded — product, experience, architecture, quality, operations — each maintaining their own inventory with their own documents, their own verification evidence, and their own traces. No team told another team what documents to keep. Each chose what works for their job.

Browse [clinic-checkin/README.md](clinic-checkin/README.md) to see how the inventories connect.
