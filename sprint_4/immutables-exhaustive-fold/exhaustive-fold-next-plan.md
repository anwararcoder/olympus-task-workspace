# Exhaustive Fold — next-plan (v4 -> v5)

The frozen `exhaustive-fold-plan.md` stays unchanged. This file is the post-FP-panel plan.

## Current situation (2026-07-11)

v4 landed the difficulty target: 2/10 PASS_LEGITIMATE, agent-8 one test short (43/44, generic-impl
dispatch only), agent-1 at 39/44 (still the Immutable*-param reading despite the stated clause).
The v4 clauses did exactly what the replay predicted — the near-solver band converted into passers.

**The blocker: acceptance now requires the false-positive panel to pass, and BOTH passes were
confirmed false positives with real, prompt-grounded defects:**

1. **Nova #2 — non-transitive dispatch comparator.** It sorts family implementations with a
   comparator mixing subtype checks (-1/+1) and alphabetical fallback. Non-transitive: with a
   family `Middle`/`Other`/`Zeta extends Middle` (names M<O<Z), the sort places `instanceof
   Middle` before `instanceof Zeta`, so a Zeta folds through caseMiddle — violating the stated
   most-specific dispatch. Our fixtures dodged it only because their names/declaration order
   happen to sort safely. Panel-verified: candidate fails the probe, reference passes.
2. **Nova #7 — value-enclosing gate.** Fold emission wired under `hasEnclosingNonvalue`, so a
   type that is BOTH `@Value.Immutable` and `@Value.Enclosing` gets no companion although the
   prompt's generation rule is unqualified. Reference gates on `kind().isEnclosing()` (covers
   `DEFINED_AND_ENCLOSING_TYPE`) — panel-verified pass. The hidden suite had no value-enclosing
   fixture.
3. **judge-c's "debatable" probe (adjudicator set it aside): leaf-typed attributes.** An
   attribute declared as an implementation that is NOT itself a family type (`Router link()`).
   The description excludes it ("declared type is a family type"), Nova #2 excluded it — but OUR
   REFERENCE folded it via the never-exercised castRoot path. Reference contradicted description
   on an untested corner: a standing FP/fairness landmine either direction.

## v5 (executed this iteration)

All three closed; spike-verified in a worktree before finalizing:

1. **Sort-trap family** (fixture + test): `Stage` { `Mixer`, `Router`, `Wired extends Mixer` } —
   names M<R<W mirror the panel's M<O<Z construction; `fold(Stage)` of a Wired must hit caseWired
   (plus plain-Mixer exact dispatch — the Vega-class check). Kills non-transitive comparators and
   declaration-order chains. Reference (true topological mostSpecificFirst) passes unchanged.
2. **Value-enclosing fixture** (`PanelSpec`: `@Value.Immutable @Value.Enclosing` with a 2-impl
   Step family) + test that `PanelSpecFold` is generated and folds. Reference passes unchanged
   (spike-verified 46/47 before any solution edit — only the leaf test failed).
3. **Leaf-attr contradiction resolved description-exact** (the direction the panel's adjudicator
   leaned and Nova #2 implemented):
   - Description P3 sharpened: attributes fold "whose declared type is a family type of the same
     enclosing type **that receives a `fold` method**" — one clause that excludes BOTH leaf-typed
     attributes (not family types) AND generic-root-typed attributes (family type, no fold
     method). +6 words, offset by trimming P4's consequence tail -> 497 words.
   - Solution tightened to match: childrenOf keys off fold-entry names only; the dead castRoot /
     implToRoot machinery deleted; supertype-name sets memoized (built once, threaded through the
     ordering loops). count_loc 402 (v2's accepted-track level; 391 before the honest recovery).
   - Tests: caseWired has exactly the value parameter; `@Nullable Box<String>` on DialB pins the
     generic-root-typed negative (existing signature probe unchanged).
4. Suite = 47 tests; full fixture regression green (372/0).

## Why this holds up

- Every new test enforces an already-stated clause — no description-difficulty added, no
  WHAT-not-HOW violation, no reflection-order pins.
- The FP panel's own hardening prescriptions are implemented verbatim (sort-trap sibling,
  value-enclosing fixture), and the third judge's ambiguity is dissolved by making description,
  reference, and tests agree on one reading pinned by a test.
- Solvability: the hardening costs nothing that was not already stated. Agent-8's profile (only
  generic-impl dispatch missing) is untouched by all three fixes — the nearest genuine-passer
  class survives. Nova#2-alikes need a correct topological sort; Nova#7-alikes the correct gate —
  both already required by the prompt text.

## Verification protocol (this iteration)

Replay agents 2, 7 (must now FAIL via the new tests — proving the hardening bites the confirmed
FPs) and agent-8 (profile must be unchanged) against the v5 suite; four-state from the final
patches; forge full-reactor; `git apply --check` + GNU patch dry-run before any upload.

## If the next round misses

- Over 20% or a new FP: diagnose the new passing runs' patches directly (comparator/gating class
  bugs first), add the panel's prescribed probe as a fixture — never remove tests.
- 0/10: the stated-clause compliance data (agent-1 ignored a stated clause) says tune ONE
  clarifying example into the description, not new mechanisms.
- LoC pushback: the documented reserve is the impl-typed-attribute mechanism ("or one of its
  implementations", castRoot revived + tested) — adds stated scope and LoC at a solvability cost.
