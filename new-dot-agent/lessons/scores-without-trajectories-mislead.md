# scores-without-trajectories-mislead

**Rollout scores at small n are high-variance and sometimes plain wrong about the current
artifacts — every batch read MUST include downloading and reading the trajectories/artifacts, or
the diagnosis will send the next round the wrong way.**

## Evidence (as of 2026-06-10)
- A saved `java-semantic-tokens` diamond sample recorded as **0.49** replayed at **69/71 = 0.97**
  against the on-disk suite (stale artifact or grade-time quirk). The prior plan's whole "Diamond
  1/3 — we're close" strategy was built on that unexamined number.
- A later 0.66 batch average was read as "close to 0.6"; the next (harder) version scored
  3/3 = **1.00** — the 0.66 was a lucky-weak-batch floor, not the thorough-agent ceiling.
- The decisive insights of two grinds came only from artifacts, never from scores:
  `java-lambda-to-anonymous`'s bimodal scoring (full-solve=1.00 vs ~0.49) and its full-solver
  trial-compile-oracle mechanism; `jte`'s Gate-C verdict flip (see
  [[grade-the-final-report]] precedent inside `rules/documentation-ledger.md` §4).

## Applies at
W5 §0 (mandatory artifact download) and W2 step 3 (read trajectories, not scores).

## Rule it shaped
`workflows/w5-platform-iteration.md` §0, `workflows/w2-difficulty-preflight.md` step 3.
