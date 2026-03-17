# Quality

Proof integrity for the clinic check-in system. This area audits that things actually work — across kiosk, mobile, dashboard, migration, and security boundaries. Nothing here is an assertion without evidence.

## What's here

| File | What it does |
|------|-------------|
| [test-plan.md](test-plan.md) | Strategy, scope, environments, entry/exit criteria, and risk prioritization across all 10 rounds of development. The "why" and "how" of testing. |
| [test-suites.md](test-suites.md) | 73 test cases organized into 12 suites. Each case has preconditions, steps, expected results, and traceability links to user stories, screens, API endpoints, and production monitors. |
| [coverage-report.md](coverage-report.md) | Maps every user story and bug fix to its test cases. Shows what is covered, what has gaps, and links evidence — not assertions — for each claim. |
| [bug-reports.md](bug-reports.md) | 3 bug reports (P0 data leak, P1 sync failure, P1 data loss). Each includes root cause, fix description, regression tests, and post-mortem. All verified. |

## Quick reference

- **Is a feature tested?** Check [coverage-report.md](coverage-report.md) — it maps every user story AC to specific test cases with last-run results.
- **Want to run tests?** Check [test-suites.md](test-suites.md) — each suite has step-by-step cases with preconditions and expected results.
- **What's the testing strategy?** Check [test-plan.md](test-plan.md) — scope, environments, priorities, and release gates.
- **What broke before?** Check [bug-reports.md](bug-reports.md) — full history of P0/P1 bugs with root cause and fix verification.

## How verification works

- **Test suites carry execution metadata.** Each suite header records last run date, environment (staging/prod), result (pass/fail), and who ran it (CI or named reviewer).
- **Bug reports carry verification evidence.** Each fix lists the exact test cases that verify it, the environment where verification ran, and supplementary evidence (regression runs, penetration tests, video analysis).
- **Coverage report references evidence, not assertions.** Every "Covered" claim links to specific test cases with their last execution results. Gaps are called out explicitly with tracking status.

## At a glance

| Metric | Count |
|--------|-------|
| Test cases | 73 |
| Test suites | 12 |
| Bug reports | 3 (all verified) |
| User stories covered | 13 |
| Acceptance criteria covered | 75 of 79 (4 partial gaps tracked) |
| Critical areas with zero gaps | Session isolation, sync verification, concurrent edit safety, medication compliance |
