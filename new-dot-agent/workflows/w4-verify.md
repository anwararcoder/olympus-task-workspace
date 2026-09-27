# W4 — Verify & Adversarial Review (before ANY submission, every iteration)

**Input:** deliverables from W3 (or any later edit). **Output:** evidence-backed green, or a punch
list. **Rule:** `rules/fairness-and-review-flags.md` (the sweep target).

## 1. Four-state verification (mechanical, non-negotiable, evidence pasted into the task ledger)

| State | Setup | Must show |
|---|---|---|
| S1 | base + test patch, `base` mode | base suite green (with documented skips) |
| S2 | base + test patch, `new` mode | ALL hidden tests fail/ERROR at runtime (compile OK) |
| S3 | base + test patch + solution, `new` mode | ALL hidden tests pass |
| S4 | base + solution, `base` mode | no regression |

Run inside the Dockerfile at least once per round. Repeat S3 three times if the repo has any
flakiness history. Replay discipline: saved-agent replays are a GAP-FINDER (does a fork bite? is
it a wall?) — never a pass-rate or difficulty meter; only platform batches measure difficulty.

## 2. Adversarial review (a FRESH session, not the builder)

The builder agent never certifies its own work — long-running builders hallucinate. A fresh
session receives only the deliverables + rules and attacks:
- **Fairness sweep:** every section of `fairness-and-review-flags.md` A–D against every test
  assertion and description clause. For each fork: "what wrong implementation still passes?" and
  "what CORRECT implementation fails?" (the second question is the unfairness detector).
- **Craftsmanship sweep:** dead code, comment density vs repo, diff noise, AI tells, naming.
- **Contract trace:** every test → a clause; every clause → a test; degenerate fixture values have
  stated semantics.
- **Second-implementation thought experiment:** sketch a faithful alternative design (different
  storage/marker/error transport); confirm it would pass every test.
- Patch hygiene re-check: fresh-apply, modes, no test code in solution patch and vice versa.

## 3. Exit

All findings fixed or explicitly justified in writing (a justified decline is legitimate — pinned
free choices must NOT be "fixed" into the tests). Ledger line with the evidence summary. Only then
may the owner submit.
