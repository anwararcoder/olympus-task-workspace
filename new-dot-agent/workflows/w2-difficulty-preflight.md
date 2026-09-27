# W2 — Difficulty Preflight (NEW — the single biggest change in this system)

**Purpose:** test the THOROUGH-AGENT CEILING — the binding diamond constraint — before the full
build, at slice cost. Three tasks died or were reverted because rollouts ran last:
semantic-tokens (3×1.00 after 11 iterations), secret-rotation (3×1.00 AFTER finalization+QA),
call-hierarchy (1.00 at v3, downgraded). Each would have been killed here in days, not weeks.

**Input:** approved plan. **Output:** a GO / DEEPEN / KILL decision with rollout-trajectory
evidence, recorded in the task ledger + plan addendum.

1. **Build the vertical slice** in a worktree: the difficulty CORE only (the central design
   commitment + its cascade), the Gate-B spike code as the seed of the reference, the
   core-coupled tests for it (a dozen-ish scenario tests, four-state green), the draft
   description, a working Dockerfile. Breadth, edge forks, and polish are EXCLUDED — the slice
   must contain the thing that is supposed to defeat a thorough agent, and nothing else.
   (Slice scoring logic: extra breadth only ADDS easy tests, which raises rollout scores — so if
   the core alone doesn't bite, the full task cannot either. The slice is the honest ceiling test.)
2. **Submit as a draft** and run: prechecks → 1x castor sanity (env blockers) → **Diamond Checks
   (3 rollouts)**. Cost is tens of tokens (`rules/platform-bar.md`) — versus 15 person-weeks,
   which is what the three autopsied tasks burned post-build.
3. **Read the trajectories, not just the scores** (scores at n=3 are high-variance; one low batch
   is NOT validation). For each rollout: where did it struggle, what did it get wrong, did it
   cruise through the core? Extract every behavioral divergence — these become test fixtures.
4. **Decide:**
   - Rollouts cruise the core (~0.9+ with no real struggle in the trajectories) → **KILL or
     DEEPEN.** The idea's core is solvable by thorough agents; breadth will not save it. Deepen
     means a structural change (a new owned-state axis, an algorithm-forcing constraint) — then
     repeat W2. Two consecutive deepen-failures = KILL, write the lesson, return to W1.
   - Rollouts genuinely fight the core (low scores with trajectory evidence of the predicted
     architectural mistakes) → **GO** to W3, carrying the observed divergences as planned
     fixtures.
   - Rollouts can't start / uniform single-cause failure → suspect seam/ambiguity fault
     (the carve 0/34 signature), not difficulty: fix discoverability and re-run W2.
5. Ledger every event; append the decision + evidence to the plan as a dated addendum.

**Discipline:** no full build EVER starts without a W2 GO. This gate is cheap precisely so that
killing feels cheap — the old workflow's tragedy was that by the time the ceiling was measured,
killing felt unaffordable.
