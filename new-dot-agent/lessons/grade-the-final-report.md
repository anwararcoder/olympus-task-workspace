# grade-the-final-report

**Grade an agent experiment (gauntlet, rollout, replay) on its FINAL report and artifacts — a
mid-flight snapshot understates a persistent agent, and the verdict can flip within the same day.
Also: a strong agent's recurring blind spot is testing the component directly instead of the
public API path.**

## Evidence (as of 2026-06-11)
- `jte-precompile-maintenance` Gate C: the mid-flight read of the gauntlet worktree said the agent
  "MISSED atomicity and wrote NO tests" → verdict MIXED. Its FINAL report showed atomicity handled
  at the compiler level (success-flag, delete-nothing-on-failure, manifest = previous ∪ written),
  rename handled, 7/7 own tests, 776/776 module green — ONE pass. The corrected projection
  (~0.85 rollout score) flipped the recommendation from "GO to W2" to "DEEPEN before W2", i.e.
  it prevented spending W2 tokens on a predictable kill.
- The agent's one surviving gap was structural, not effort: all its tests drove
  `TemplateCompiler` directly and never `TemplateEngine.create()`, so the engine-constructor
  eager-clean path stayed unexamined. Public-API-driven scenarios are therefore mandatory fixture
  material (and a recurring discriminator candidate).
- Same family as [[scores-without-trajectories-mislead]]: partial evidence reads systematically
  wrong; diamond rollout agents are persistent by design ("keep going until they fail or solve").

## Applies at
W1 Gate C grading, W2 trajectory reading, W5 batch categorization.

## Rule it shaped
Recorded in `rules/documentation-ledger.md` §4 as the revision-protocol precedent; reinforces
`workflows/w2-difficulty-preflight.md` step 3.
