# WORKFLOW — Task Authoring System

_This document is the narrative for the Diamond-era authoring system. The
`rules/` files are the per-topic doctrine; the `workflows/` files are the per-stage operating
checklists; `lessons/` is the growing memory. For current normal Olympus work, numbers and panel
requirements live in `Shipd - Olympus/my-review-workflow/rules/platform-panel.md`; the Diamond
numbers in `rules/platform-bar.md` are mode-specific history.
This doc stitches it all together so a zero-context agent (any provider) can load just this file
and know what to do and why._

> **Authority routing:** read the task's current criteria panel first. For a normal Olympus task,
> read `rules/false-positive-calibration.md` and the live platform panel before using this
> document. Use the Diamond ceiling/rollout sections below only when the current panel explicitly
> selects that mode.

---

## 0. What we do, and the one sentence that governs everything

We author feature-request tasks against real open-source repos for an AI-evaluation platform.
A task = description + hidden test patch + reference solution patch + Dockerfile + base commit.
The platform runs agents against it; a Diamond task must be **hard-but-fair**: strong agents must
genuinely fail large parts of it, yet every failure must map to a stated-or-inferable requirement,
and two different faithful implementations must both pass.

> **The governing sentence: every downstream disaster is born at idea selection, and the binding
> constraint is the THOROUGH-AGENT CEILING — so we test the ceiling first, kill cheaply, and only
> build what survived.**

The previous workflow built first and measured the ceiling last. Three tasks (semantic-tokens,
call-hierarchy, secret-rotation) each burned weeks before discovering — via 1.00 rollout scores —
that thorough agents simply solve them. One of them was discovered AFTER finalization and full QA.
That ordering error, more than any single bad idea, is what this system fixes.

## 1. The gates (Diamond-mode summary; current mode comes from the live task panel)

Two different questions are asked of every task:
- **The floor (Castor):** do enough weak/mid agents fail? (binary pass rate gate)
- **The ceiling (Diamond rollouts):** does the typical THOROUGH, persistent, strong agent fail a
  large FRACTION of the tests? (partial-reward median gate — the hard one)

Partial reward is the crucial mechanic: missing one test scores ~0.95+, so scattered hard edges
cannot move the median. Only a **failure cascade** — one wrong architectural commitment failing a
large cluster of tests — produces low strong-agent scores. This single fact drives idea selection
(§2), test design (§4), and the preflight (§3).

Pipeline: prechecks → 1x castor sanity → Diamond Checks (incl. rollouts) → 10x castor → holistic
AI review → auto-review (green-lights QA) → QA + audit loop → human review → finalize. Editing any
deliverable re-stales everything; QA-only edits stale nothing. Front-load accordingly.

## 2. What a winning idea looks like (doctrine: `rules/task-shape.md`)

**Pre-screen every candidate as READ / EDIT / STATE:**
- READ (framework already resolved the answer; agent formats it) → **dead on arrival**, measured
  repeatedly. No fork count, LoC, or de-telegraphing changes it.
- EDIT (change bound by a global property → cascade: fix X, Y breaks, fixing Y conflicts with Z)
  → eligible when the cascade is real.
- STATE (persisted state + ownership + lifecycle + cross-process/component reconciliation) → the
  only shape that has met the rollout bar. Hunt for: artifacts one run writes and a later run must
  trust/refresh/clean, two subsystems computing the same thing independently (drift), caches that
  must cohere, directories shared with user-owned files.

**Score geometry:** the hard core must gate >50% of the suite, through STATED requirements. If the
largest honest failure cascade is small relative to the suite, the median math cannot reach the
bar — compute this on paper before building (Gate A below).

**The seven properties of accepted work:** existing seam · 4+ independent concerns failing
different tests · intuitive design architecturally wrong · contract-only tests (two faithful
implementations pass) · outcome-prose description with every clause load-bearing · every failure
maps to a requirement · substantial idiomatic reference. **The anti-patterns:** LoC-as-input ·
forks contradicting base behavior · arbitrary/unobservable constants · leaf values ·
compute-and-emit · daemon-homed features untestable from base symbols · READs · walls.

## 3. The stage flow (each stage = one workflow file, one kind of session)

```
W0 select-repo    -> repo dossier: hygiene + SEAM INVENTORY (>=2 STATE/cascade-EDIT seams or out)
W1 craft-idea     -> plan with THREE EMPIRICAL GATES (no estimates):
                       A cascade arithmetic   (leaf-value / score-geometry math, on paper)
                       B validation spike     (hardest fork BUILT in a worktree; LoC MEASURED)
                       C naive-agent gauntlet (fresh strongest model + description only; watch it)
                     + per-fork discoverability proofs, executed not declared
                     + a separate fresh-session red-team of the plan
W2 difficulty-preflight (NEW, the keystone)
                  -> vertical slice of the CORE -> platform rollouts EARLY -> read trajectories
                     -> GO / DEEPEN / KILL. No full build without a GO. Killing here costs days;
                     killing after QA costs months and morale.
W3 build          -> tests first by score geometry; fixtures from W2's observed divergences;
                     description with clause<->test trace; solution grown from the spike;
                     ablation-proven fork independence; patches + Dockerfile.
W4 verify         -> four-state in-container + ADVERSARIAL REVIEW BY A FRESH SESSION
                     (fairness sweep, craftsmanship sweep, second-implementation experiment).
W5 platform-iteration
                  -> categorize every batch (trajectories mandatory); CEILING CHECK before any
                     difficulty lever; close false positives by CONTRACT CLASS; one diagnosis per
                     round; probe forks by replay before shipping; lever ledger; escalate with
                     arithmetic when the bar is unreachable.
W6 qa             -> pre-QA huddle; write; SELF-AUDIT SWEEP; audit loop fixing CLASSES not
                     instances.
W7 human-review   -> FIXED / Justified / CONCEDE(base-conflicts) / ESCALATE(duplicates);
                     reviewer concerns are also ceiling data.
W8 retrospective  -> mandatory at accept/kill/revert/downgrade: ledger autopsy -> lessons/ ->
                     EDIT THE RULES. The system must compound.
```

## 4. The cross-cutting disciplines (rules, enforced at every stage)

- **Measure, don't assume** — the three empirical gates + W2 exist because every painful task was
  carried past its kill-point by an optimistic estimate (difficulty, volume, or both).
- **Trajectories over scores** — rollout scores at n=3 are high-variance; the trajectory shows
  whether the agent fought or cruised. Both of our worst misreads came from scores alone.
- **Replay = gap-finder** — saved-agent replays prove a fork bites / isn't a wall / isn't a no-op;
  they never measure pass rates.
- **One diagnosis per round** — a class-level correction may coordinate description, test, and
  golden edits; fresh batch after; dead levers go in the lever ledger and stay dead.
- **Fairness sweeps are class-based** — one flagged instance means the class is broken everywhere.
- **False-positive sweeps are contract-based** — every passer is provisional; follow
  `rules/false-positive-calibration.md` and reproduce discriminators against candidate and golden.
- **Seam legality** — every observable from base symbols through a synchronous entry; degenerate
  fixture semantics stated; no internal names; no spec-open or hidden-internal assertions.
- **Repo-faithful craftsmanship** — measured comment density, no dead code, no AI tells, no diff
  noise; path canonicalization, atomic writes, ownership-scoped deletion, validate-before-side-
  effects where the contract touches them.
- **Ledger everything** (`rules/documentation-ledger.md`) — one line per platform interaction
  INCLUDING precheck and QA fix rounds; Phase A/B commits for strategy changes; lessons propagate
  into rules at W8 or they didn't happen.

## 5. Session architecture (provider-agnostic by construction)

State lives in FILES (dossiers, plans, ledgers, lessons), never in a provider's chat memory. Each
stage is its own fresh session with a one-line invocation pointing at this system + the stage
workflow + the task directory (templates in `workflow-onboarding.md`). Builder and reviewer are
ALWAYS different sessions. Long-running build sessions are checkpointed by the four-state evidence
they must paste into the ledger — an agent that cannot show the evidence has not done the work.
Any model that can read files and run shell commands can operate this system; provider-specific
accelerators (subagents, plan modes, background tasks) are conveniences documented in the
onboarding, not dependencies.

## 6. The economics (why this ordering wins)

Old shape: idea (cheap, optimistic) → full build (expensive) → calibration ping-pong (very
expensive) → ceiling discovered (catastrophic — sometimes post-QA). Measured cost: ~15
person-weeks of post-build iteration across three tasks, plus a finalized-then-reverted task.
New shape: the cheap stages (W0-W2: days, tens of platform tokens) carry the kill burden; the
expensive stages (W3-W7) only run on ideas that have already survived a cascade-arithmetic check,
a measured volume spike, a naive-agent gauntlet, and a real strong-agent rollout on the core.
Expect to kill MOST candidates at W1-W2. That is the system working, not failing — each kill
costs days and produces a lesson; each false GO costs weeks and produces a downgrade.

## 7. Glossary

**Four-state**: base+tests green / tests-fail-on-base / tests-pass-with-solution / no-regression.
**Wall**: a test ~no gate-population agent passes (0/N castor + ~1.0 rollouts). **Leaf value**:
an artifact with no derived state/cascade; max one small fork. **Score geometry**: the mapping
from suite topology to achievable partial-reward scores. **Seam**: the existing repo subsystem/
split a feature naturally extends. **Cascade**: a cluster of tests that all fail when one design
commitment is wrong. **Ceiling check**: the arithmetic showing whether any fair lever can move the
strong-agent median below the bar. **Dossier / Plan / Ledger / Lessons**: the four file-based
memories (repo / task-idea / task-history / global).

**Reference material (`templates/`):** copy-paste, not reasoning — `test-sh.md`, `dockerfile.md`,
`patch-and-verify.md` (commands + four-state + workspace isolation), `artifact-structure.md` (the
task-directory file-naming contract). The reasoning files point here so they stay short.
