# read-features-hit-the-ceiling

**Compiler/framework-assisted READ features max out at ~1.0 on diamond rollouts; never pick one
for Diamond — no fork count, LoC, or de-telegraphing changes it.**

## Evidence (as of 2026-06-10)
- `java-semantic-tokens`: 11 iterations, every fair lever class tried (stated-rule edge forks,
  Degraded fork, de-telegraph, member-access chains, error-typed elements). THREE independent
  rollout batches scored 3/3 = 1.00 — including one on the HARDER version (more forks +
  de-telegraphed description). Trajectories show thorough agents inferring the full de-telegraphed
  type-position set from first principles, instantly. Downgraded to normal Olympus.
- `java-call-hierarchy`: same repo, same READ shape; 7/10 castor then rollouts 1.0 at v3;
  shipped only by downgrading to normal Olympus.
- Mechanism: when the framework resolves the core answer (javac's `Trees.getElement` hands over
  the resolved program), a thorough agent implements the full stated contract. Fair forks catch
  only weaker agents (see [[fair-forks-catch-weak-agents-only]]).

## Applies at
W0 seam inventory + W1 candidate pre-screen (the READ/EDIT/STATE classification).

## Rule it shaped
`rules/task-shape.md` §1 (READ = dead on arrival), `rules/repo-selection.md` §2.
