# fair-forks-catch-weak-agents-only

**Confirmed-fair edge forks lower the WEAK/MID population's scores but do not move the
thorough-agent median — the rollout ceiling is immune to edge-case difficulty, however fair and
well-probed.**

## Evidence (as of 2026-06-10)
- `java-semantic-tokens` final round: two forks confirmed by replay to bite real agents (the
  member-access chain fork failed an opus-tier 0.49 sample; the error-typed fork failed a castor
  agent) PLUS a de-telegraphed description — and the diamond rollouts on this HARDER version came
  back 3/3 = **1.00**. The trajectories show all three agents handling both forks easily and
  reconstructing the de-telegraphed enumeration from first principles.
- Mechanism: thorough agents implement the whole stated contract; an edge they could miss is, by
  fairness construction, stated-or-inferable — so they don't miss it. Only a CASCADE through an
  architectural commitment (see [[state-ownership-lifecycle-is-the-shape]]) moves their median.

## Applies at
W5 ceiling check (before spending a round on another edge fork) and W1 fork design.

## Rule it shaped
`rules/task-shape.md` §1-2, `workflows/w5-platform-iteration.md` §2.
