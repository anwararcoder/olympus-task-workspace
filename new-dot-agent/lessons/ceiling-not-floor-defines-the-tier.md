# ceiling-not-floor-defines-the-tier

**A task can hold the Castor floor (≤30%) and still score 1.00 on diamond rollouts — the
thorough-agent CEILING is the binding Diamond constraint, so measure it FIRST (W2), not after
finalization.**

## Evidence (as of 2026-06-10)
- `osctrl-secret-rotation-windows`: finalized at Castor 2/10 (20%, "Hard") with QA written and
  human review settled — then REVERTED when three diamond rollouts scored 1.00/1.00/1.00 under
  the new partial-reward gate. ~5 weeks of work post-detectability.
- `java-call-hierarchy`: rollouts hit 1.0 at v3, but rounds were still spent on levers before the
  downgrade decision.
- The two gates ask opposite questions: Castor = "do weak/mid agents fail?" (floor); rollouts =
  "does the typical thorough agent fail >40-60% of tests?" (ceiling). Passing the first says
  nothing about the second.

## Applies at
W2 (the difficulty preflight exists because of this lesson) and W5 (ceiling check before any
difficulty lever).

## Rule it shaped
`workflows/w2-difficulty-preflight.md` (the keystone), `rules/platform-bar.md` "what the gates
MEAN", `workflows/w5-platform-iteration.md` §2.
