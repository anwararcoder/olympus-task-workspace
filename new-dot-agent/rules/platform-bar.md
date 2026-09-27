# Platform Bar — Diamond-era, mode-specific numbers

> **Current authority:** read the task's criteria panel. For normal Olympus work, all live numbers,
> required checks, and panel fields are in
> `Shipd - Olympus/my-review-workflow/rules/platform-panel.md`. The thresholds below apply only when
> a current task explicitly selects the Diamond/Castor rollout mode. Do not use them to calibrate a
> normal Olympus submission.

For cross-gate diagnosis, use `rules/false-positive-calibration.md`. It explains why pass rate,
false-positive safety, golden correctness, fairness, and repo fit cannot be traded against one
another.

_Diamond-mode snapshot last verified: 2026-06-11. Re-verify it before any Diamond-mode use._

## The Diamond-era gates

| Gate | Requirement | Notes |
|---|---|---|
| **Diamond rollouts (THE binding gate)** | median/average score **< 0.6** (will tighten to **< 0.4**) | Opus-tier agents, **partial reward**: score = fraction of hidden tests passed (`weighted_test_score`, weight 1; `binary_score` weight 0). They are persistent — they keep going until they solve or fail. Missing one test = ~0.95+, NOT a fail. |
| **Castor pass rate** | ≤ 30% (1-3 of 10) | Binary per run. Castor is being upgraded toward diamond strength. 0% is recoverable: **hints are allowed** — add an inferable hint, rerun hinted (both hinted and unhinted Diamond Checks must then run). |
| **Fairness** | zero unfair tests | Test-Fairness + Code-Fairness judges + human review. One unfair test fails the whole submission. |
| **Solution size** | ~850+ non-empty LoC honest target | The platform floor wording is lower (~700, and a "400 effective" echo survives in old docs — treat both as DANGEROUSLY LOW). Accepted Java Diamonds run ~850–1200 non-empty. Our estimates run ~40% optimistic, so a plan must MEASURE (see `task-shape.md` volume gate), not estimate. |
| **Long-horizon** | median of successful runs ≥ 100 agent messages, ≥ 3-5 files modified | |
| **Tests** | 30+ tests, fail-on-base 100%, compile on base | Test patch typically 700–1300 lines. `test.sh` mode 100755. |
| **Quality score** | ≥ 5/7 on the 21-item checklist | |
| **QA audit** | every annotation `true` | `mixed`/`false` blocks the gate. |

## The Diamond-era pipeline order, and what each check did

Prechecks/Postchecks → 1x Castor (or Vega) sanity → **Diamond Checks** → 10x Castor → Holistic AI
Review → Auto Review (green-lights QA) → QA → Final QA Review loop → human reviewer → manager
finalize → accepted.

| Check | What it catches / does | Cost |
|---|---|---|
| **Prechecks / Postchecks** | basic setup: patches apply, four-state sanity, conciseness, description↔test alignment, patch hygiene, plagiarism | entry gate |
| **1x Castor / Vega sanity** | environment blockers (build/test breakage) before spending a full batch | cheap |
| **Diamond Checks** | the bundle below; surfaces structural issues (broken setup, ambiguous spec, too-easy) BEFORE QA | ~50 tokens full |
| → Rollouts | the binding ceiling measurement (3 rollouts/job) | ~45 tokens/job |
| → Code Validation | reference-solution / patch correctness | ~15 tokens |
| → Full Environment QA | end-to-end grade-harness run | ~20 tokens |
| **10x Castor** | the floor pass-rate gate | 25 tokens/run |
| **Holistic AI Review** | reads ALL runs to catch systematic trivial failures (env, test-running) | — |
| **Auto Review** | confirms fairness + solvability; its approval is the QA green-light badge | — |
| **Final QA Review** | the QA-annotation audit loop; re-runs on QA edits WITHOUT staling other checks | — |

Staleness (the rule that makes front-loading non-negotiable): editing description / test patch /
solution patch / Dockerfile re-stales ALL checks and forces fresh batches. Editing ONLY QA artifacts
re-runs Final QA Review without staling anything. Adding/modifying a **hint** stales only the HINTED
runs (the unhinted batch and the other checks stand); a hinted submission must run the pipeline
twice — once unhinted, once hinted. **The cost of a late deliverable edit is the whole pipeline — so
W1/W2 exist to settle difficulty and fairness before the expensive stages.**

## The 21-item quality rubric (score ≥ 5/7 to pass; self-audit against it before submitting)

- **Problem (1-7):** requirements complete · no ambiguity · concise · scoped · sound design
  philosophy · no irrelevant context · clean formatting.
- **Tests (8-15):** no missing behavior · deterministic · good assertions · behavior-not-internals ·
  respects repo structure · coverage · concise · no unspecified-behavior tests.
- **Solution & Code (16-21):** meets requirements · no regressions · no defensive/dead code · no
  irrelevant changes · API stability · no AI slop.

## What the gates MEAN (interpretation, learned the hard way)

- **The diamond gate is a CEILING test, not a floor test.** It asks: does the typical THOROUGH,
  persistent, strong agent fail >40–60% of your tests? Castor asked the opposite (do weak/mid agents
  fail?). A task can hold Castor at 2/10 and still score 1.00 on rollouts — that exact combination
  killed `osctrl-secret-rotation-windows` (finalized at Castor 2/10, reverted after three 1.00
  rollouts) and `java-semantic-tokens` (three independent 3/3 = 1.00 batches).
- **Rollouts are high-variance at small n.** One low batch (a 0.66) is NOT "close" — the
  thorough-agent ceiling, not a lucky weak batch, defines the tier. Never calibrate on one batch's
  average; read the trajectories.
- **Partial reward changes test design.** With independent micro-tests, a strong agent that misses
  one edge scores ~0.97. The score can only go low if failure CASCADES through the suite — see
  "score geometry" in `task-shape.md`.
- **A 100%-fail test is a wall, not difficulty.** Castor 0/N + rollouts ~1.0 is the wall
  fingerprint; remove the wall test (we proved this twice: de-telegraph 0/10, anon-supertype 0/12).

## Repo eligibility (hygiene, not predictors)

Permissive license (MIT/Apache-2/BSD), ~500+ stars, active-but-not-hot, real test infra. Languages
seen accepted in practice: **Go and Java** (the old "Go/Rust/TS/Python" list is stale). What
actually predicts success is the repo's SEAM SHAPE — see `repo-selection.md`.

## Changelog (append; never rewrite history)

- 2026-06-11 — Initial version. Sources: owner note in
  `standards/Olympus-Diamond-Tier-Failure-Analysis-Guide.md` (rollout partial reward, <0.6 now /
  <0.4 later, hints fine), Diamond Relaunch Discord post (pipeline, staleness, token costs),
  measured rollout metadata (`weighted_test_score` weight 1), and the semantic-tokens /
  secret-rotation / carve-integrity outcomes under the new criteria.
