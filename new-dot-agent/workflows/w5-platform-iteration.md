# W5 — Platform Iteration (results-driven; one diagnosis at a time; everything ledgered)

**Input:** any platform result (prechecks, Diamond Checks, castor batch, rollouts, auto-review).
**Output:** a categorized diagnosis + at most ONE defect-class change + ledger/Phase-A documentation.
**Rules:** the current task panel, `rules/false-positive-calibration.md`,
`rules/platform-bar.md` only for an explicitly selected Diamond mode,
`rules/fairness-and-review-flags.md`, and `rules/documentation-ledger.md`.

## 0. Before touching anything

Ledger the result. Download artifacts (eval JSONs, junit XMLs, solution patches, trajectories) —
**always download rollout trajectories**; scores without trajectories are uninterpretable
(secret-rotation's revert and semantic-tokens' false "0.49 = close" both came from reading scores
without trajectories).

Freeze the exact state first: HEAD/tag/dirty status, deliverable hashes, report hashes/timestamps,
run IDs and tiers, XML totals, and patch hashes. A report for a tagged state cannot approve a later
dirty state.

## 1. Categorize the batch (the diagnosis decides everything)

**Analyze the failures BEFORE touching anything (the owner's standing instruction).** Do not add
hints, clarifications, or test edits to brute-force the checks green — most of the time a uniform
failure means the task is ambiguous/unfair, not that the agents are weak. Analysis first saves the
tokens, the rounds, and the revert.

For each failing run, classify the verdict and find the FIRST wrong turn (cite the trajectory step):
- `PASS_LEGITIMATE` — earned pass (hidden tests unmodified; agent's own tests in separate files).
- `FAIL_WRONG_LOGIC` — built it, logic wrong.
- `FAIL_MISSED_REQUIREMENT` — skipped a stated/inferable requirement.
- `FAIL_INTEGRATION_ERROR` — wired it wrong (transport/observability), not a logic miss.
- `PROBLEM_FAULT_*` — OUR fault: ambiguity, unfair test, env breakage. Escalate, don't blame the agent.

Then read the pattern across the batch:

| Pattern | Meaning | Action |
|---|---|---|
| >50% of failures share ONE root cause | ambiguity / seam fault / wall — until proven otherwise | fix the task, not the agents; max 2 lever cycles on one blocker, then REDESIGN (carve burned 8 days re-wording an undiscoverable seam) |
| 0/N castor + rollouts ~1.0 | a WALL test | remove it; restore prior state byte-exact from git |
| scattered fair failures, rate above gate | genuinely too easy | difficulty lever — but run the CEILING check first (below) |
| rollout scores ~1.0 with cruising trajectories | thorough-agent ceiling reached | no test-side lever will move it; structural deepen, downgrade, or kill — decide with the owner |
| fairness FAIL on a test | unfair | fix/remove the test; sweep the same CLASS across the suite |
| passing candidate fails a fair stated probe | false positive | reproduce candidate and golden in four states; close the whole contract class |
| candidate and golden both fail a fair probe | golden/spec gap | choose the contract, then align description, tests, and golden together |
| env/build failures | task fault (FAIL_TEST_BROKEN class) | fix infra immediately; these are OUR fault |

## 2. The difficulty-shape check (run before ANY difficulty lever)

For a normal Olympus task, compute pass-probability breadth from current run families and compare
with the live panel. For an explicitly selected Diamond task, also compute partial-reward cascade
arithmetic against `rules/platform-bar.md`. If the current fair failure shape cannot reach the
active bar, stop iterating local levers and escalate the structural decision instead.

## 3. Lever discipline

- ONE diagnosis or defect class per round; dependent description/test/golden edits are one coherent
  lever. Re-measure on a fresh batch. Difficulty is not linear in explicitness (one
  removed enumeration flipped 5/10 → 0/10).
- PROBE before shipping any fork: replay saved agents/rollout solutions against it. Reference +
  strong agents must pass (not unfair, not a wall) and ≥1 saved agent must fail (not a no-op).
- Update the lever ledger row with the verdict, whatever it is. Dead levers are never retried.
- Phase A (commit-message + next-plan) for strategy-changing results; ledger lines for everything.

### Zero-pass recovery (0/N — diagnose before selecting a lever)

Follow the decision tree in `rules/false-positive-calibration.md`:

1. Signal/harness defect: repair infrastructure and rerun the unchanged contract.
2. One dominant discoverability blocker: use one behavior-only clarification or currently permitted
   hint, then replay the nearest correct-architecture solver.
3. Many independent fair blockers: coherently remove one capability island across description,
   tests, and golden; use breadth arithmetic rather than another local hint.
4. Golden/contract defect: align all three artifacts in the same round.
5. Rejected/foreign repo seam: stop and replace the task core.

Never remove a valid discriminator merely to turn its FP candidate into the solvability anchor.

## 4. Know when you are done iterating

GO to QA when all gates for the current task mode are in band, at least one legitimate passer
exists, the required false-positive evaluation is clean after independent adjudication, fairness
is clean, and auto-review has no blocking band. For Diamond mode, also apply its rollout ceiling.
ESCALATE to the owner (pivot / kill / mode decision) when the ceiling check says the
bar is unreachable fairly — say it plainly with the arithmetic; the most expensive sentence in
this business is "we're close" said without trajectory evidence.
