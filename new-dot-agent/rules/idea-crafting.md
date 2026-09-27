# Idea Crafting — selection with kill-gates (the stage where every task is won or lost)

> Every downstream block we ever hit was born here. A weak core idea cannot be rescued by clever
> tests, careful wording, or iterations — it forces manufactured difficulty, which is exactly what
> the fairness judges flag; sanding off the unfairness collapses the difficulty, and the task
> grades too easy. That death spiral is unwinnable from inside. The only winning move is to never
> enter it. Spend your effort on SELECTION; the plan is just the proof of a correct selection.

Prerequisites: `rules/task-shape.md` (the doctrine), `rules/repo-selection.md` (a repo dossier with
surviving STATE/EDIT seams), `rules/platform-bar.md` (the gates), and the `lessons/` registry.

## The crafting sequence

1. **Start from the dossier's seam list**, not from "what LSP/CLI features exist". Each candidate
   must name the exact base subsystem/split it extends (the seam litmus).
2. **Run the §5 kill questions of `task-shape.md` on every candidate.** Be adversarial, not
   advocational — in theory every idea sounds hard; in practice most are solved in one pass.
3. **Shortlist 3 survivors** with FULL draft titles + descriptions (the plagiarism judge compares
   how the description is written, so the preflight needs the real description, not a stub).
4. For the selected idea, run the three EMPIRICAL gates below before freezing anything.

## The three empirical gates (estimates are banned; these replace them)

### Gate A — Cascade arithmetic (the leaf-value / score-geometry test, on paper)
List every independent failure cluster the idea can produce. For each, count the tests it would
take down. Compute the largest single cascade and the union. Under partial reward
(`rules/platform-bar.md`), the median strong agent must fail >40–60% of the suite — so:
- largest single cascade < ~30% of planned tests → leaf-value shape → KILL or restructure.
- This arithmetic on `osctrl-secret-rotation` (largest cluster ~5 of 35 tests, union 10) proves its
  revert was predictable at plan time, before five weeks of work. Run it in an hour instead.

### Gate B — Validation spike (the volume test, in a worktree)
Build the HARDEST fork — or skeletons of the two or three hardest — in a throwaway worktree and
MEASURE effective LoC (non-blank, non-brace, non-comment). Estimates run ~40% optimistic
(encapsulate-field: estimated ~850, honest build 451; idempotency: estimated 650-800, honest build
**160** — ~4x, because rich framework primitives collapse bookkeeping). If the hardest fork is a
30-line branch, the feature is thin: deepen it with a stated CONSTRAINT that forces a real algorithm
(the codeforces principle), or change ideas. The plan must report the MEASURED number.
**Pre-spike screen (`state-shape-predicts-cascade-not-volume`):** does the core contain an ALGORITHM
(parser, recursion, freshness/age math, canonicalization, multi-axis reconciliation) or just
BOOKKEEPING (keyed store + state transitions + a hash + reject branches)? Bookkeeping-only cores are
implementation-thin no matter how hard the design is to RECOGNIZE — and the deepeners that tempt you
(config-children, durable stores needing an untestable fresh-process boundary, header-fidelity that
overlaps a sibling idea) are padding that catches zero agents. Find an in-contract algorithm or pick
a different seam; killing here at slice cost is the system working.

### Gate C — Naive-agent gauntlet (the ceiling test, locally, before any platform spend)
Open a FRESH agent session (strongest model available, zero plan context). Give it only: the draft
description + the repo at base. Let it work for a real attempt (~1-2h budget). Then study where it
struggled vs cruised:
- It cruises through the CORE → the rollout median will be ~1.0; KILL or deepen. (Both
  semantic-tokens and call-hierarchy would have died here in an afternoon.)
- It builds the core but makes the architectural mistakes your forks predict → strong signal; note
  EXACTLY which mistakes (these become test fixtures).
- It cannot even start → suspect ambiguity/undiscoverability, not difficulty (the 0/34 carve
  signature). Check the seam-legality of what you're asking (see `rules/test-writing.md` §seam).
The gauntlet output (its diff + where it diverged) goes into the plan verbatim as evidence.

## Discoverability proof (per fork — the carve lesson, executed not declared)

For every fork, write a short prose proof: (a) which description clause or repo signal makes the
correct choice discoverable, (b) what the naive opposite choice is, (c) which test fails then, and
(d) that the observable is reachable from BASE-COMMIT symbols through a synchronous entry point.
carve-integrity's plan declared this proof done without executing it; the un-executed fork
(reclamation, internal-only) cost 0/34 and eight days. A fork whose proof you cannot write is
either unfair or undiscoverable — fix the design now.

## Knowledge-transfer check (fill the table for every candidate)

If the feature maps to a well-known pattern (a famous LSP method, a standard refactoring, a
documented protocol), agents get a massive head start — you need a repo-specific twist where the
obvious pattern ACTIVELY MISLEADS. If you cannot name the twist, the head start stands and the
ceiling is ~1.0.

| Language | Analogous feature the model has seen | Why transfer FAILS / misleads in THIS repo |
|---|---|---|
| Python | … | … |
| JavaScript | … | … |
| Go / Rust | … | … |

The best ideas are ones where copying the known pattern produces the WRONG architecture (the model's
prior is a liability, not a head start).

## Per-fork bypass test (run alongside Gate A, before committing)

For each claimed fork, answer — any "bad" answer means it is not really an independent hard fork:

| Question | Bad answer |
|---|---|
| Can a capable agent solve it in <20 min? | yes → speed bump, not a fork |
| Does it fail DIFFERENTLY from the other forks? | no → you have fewer forks than you think |
| Is there a well-known pattern that solves it directly? | yes → instant solve |
| Does the naive approach PARTIALLY work? | yes → agent thinks it's done (worse than total failure) |
| Would the simple version pass 80%+ of the planned tests? | yes → the whole idea is too easy |

## Output: `{problem-name}-plan.md`

`my-work/{repo}-{problem}/{problem}-plan.md`, immutable once implementation begins. Must contain:
What It Is (with behavior/wire examples) · Why Hard At Its Core (file:line evidence) · Independent
Semantic Forks table (4-6+, each a DIFFERENT failure, each with its discoverability proof) ·
**Gate A arithmetic, Gate B measured LoC, Gate C gauntlet evidence** (a plan missing any of the
three is incomplete — treat its difficulty claims as fiction) · Score-geometry sketch (which tests
route through the core; target >50%) · Layer spread · Bypass-resilience table · Knowledge-transfer
table · "Why this will be accepted" walking the seven properties · "Why this dodges the
anti-patterns" walking (a)–(h) of `task-shape.md` · Draft title + description · Preflight plan.

Then proceed to `workflows/w2-difficulty-preflight.md` — do NOT start the full build on the
strength of the plan alone.
