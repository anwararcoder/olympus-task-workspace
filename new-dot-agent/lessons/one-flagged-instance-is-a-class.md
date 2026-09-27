# one-flagged-instance-is-a-class

**Platform audits and reviews SAMPLE — when one annotation/file is flagged for a mistake, the
whole mistake CLASS is broken across all artifacts. Fix the class everywhere in one round, or pay
one round per instance.**

## Evidence (as of 2026-06-10)
- One habit (writing `file:line` inside backticks) produced **17 flagged annotations across 4
  agents** on a single task's QA audit — a single class, discovered instance by instance.
- `osctrl` QA audits converged 14 → 4 → 0 across three rounds; the rounds that swept classes
  (not instances) were the ones that converged.
- Same dynamic outside QA: when the platform flagged one test's assertion form (modifier render
  ORDER), 16 sibling tests had the identical defect — fixed as a class in one round.

## Applies at
W6 audit loop (primarily), W5 fairness fixes, W7 review responses.

## Rule it shaped
`rules/fairness-and-review-flags.md` §F.1, `rules/qa-authoring.md` audit loop,
`workflows/w6-qa.md` step 4.
