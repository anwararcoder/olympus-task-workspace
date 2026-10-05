# duplicate-class-resolution - next plan (after round 3)

Written 2026-07-28, against tag `v3`. Supersedes the round-2 plan.

**Goal:** close the only remaining blocker (auto-review tests band 1 / human Tests 1/3) by enforcing
two description clauses that currently have no discriminating coverage, without disturbing the
passed false-positive gate, the passed fairness gate, or the 10% pass rate.

**Architecture:** test patch plus a presentation-only description re-voice. The solution patch is
NOT touched; auto-review rates it band 3 and the human reviewer rates it 3/3.

**Base repository:** `Vineflower/vineflower`, base commit
`b8273988af850e8cfb234ca08d129058502b032f`.

---

## 1. Current state

| Gate | Result | Reading |
| --- | --- | --- |
| Difficulty | 1/10 = 10%, all Nova | Solvable, well inside the 40% ceiling |
| **False-Positive review** | **PASSED** (0 FP, 1 genuine) | Round-1 blocker stays closed; the round-2 warning tag is gone |
| Repo fit | PASS | No duplicate, no maintainer ruling against it |
| Test Fairness | PASS, "All hidden tests are fair" | 3 advisory suggestions, non-blocking |
| Auto-review description | band 2 (Low, P4 presentation) | Approvable; worth fixing while other checks re-run |
| Auto-review solution | band 3 | Do not touch |
| Auto-review agents | band 3 | No leakage, no trivial solve |
| **Auto-review tests** | **band 1, two High issues** | **The blocker** |
| Human review v1 | quality 5: Desc 2/3, Tests 1/3, Solution 3/3 | Same two test gaps, same presentation note |
| Verifier audit | INCOMPLETE, 6 gaps | Evidence, not gospel - triaged in section 4 |

Batch shape:

| Group | Runs | Failing cells |
| --- | --- | --- |
| Passed | 3 | 0 |
| Failed, missed requirement | 1, 4, 5, 6, 7, 8, 9, 10 | dominated by one shared cache-invalidation blind spot |
| Failed, regression | 2 | own regression |

The pass rate moved 20% -> 10% because the round-2 addendum grew the suite from 40 to 45 cells. That
is expected and healthy. The submitted state is otherwise deliverable; only test completeness blocks
it.

## 2. The blocking defect class

Both High issues are one class: **a requirement DEFINED in the description but not ENFORCED by the
suite**. Blocker B was introduced by the round-2 addendum itself, which added the
registration-versus-selection clause without its carrier test. The standing lesson applies: any
description edit must be followed by a clause-to-test grounding pass in both directions.

Each blocker was validated on four axes before being accepted. This is the bar for accepting any
coverage ask, and it is what separates a real gap from advisory noise:

| Axis | Blocker A (concurrency) | Blocker B (deferred registration) |
| --- | --- | --- |
| Stated in the description? | Yes: "concurrent lookups or output processing must not change the winner" | Yes: "Registering a source records its candidates without resolving them; duplicate warnings and conflicts surface when a selection is requested" |
| Reference correct? | Yes: `resolve` is a memoized double-checked read over a `ConcurrentHashMap`, so exactly one thread runs `resolveUncached` and emits the warning | Yes: `initUnit` deletes the base pre-load `if (isOwn) this.getClass(clazz)`, so registration records candidates without reading bytes |
| Genuinely uncovered? | Yes: `threadCountDoesNotChangeSelectionOrSinkOwnership` varies the configured worker count, then calls `getOwnClasses()` and `saveContext()` sequentially | Yes: the conflict tests only prove the exception arrives at selection time |
| Sole passer survives? | Yes: agent 3's `resolve` is `synchronized` over a memoized selection map | Yes: agent 3 also removed the eager pre-load |

The wrong implementations these catch are the natural ones: an unsynchronized resolver warns twice
and double-probes, and a solver that keeps the base pre-load resolves during registration while
deferring only the exception.

## 3. Changes to make

### Task 1 (blocker A): true concurrent lookups

Add one test that coordinates real simultaneous lookups instead of varying worker counts.

- Two differing own candidates for the same binary name, with at least one lazy source so probe reads
  are counted by the existing `MemorySource.classReads`.
- Start N threads, hold them on a `CyclicBarrier`, then release them into a mix of
  `getClass(DUPLICATE)` and `hasClass(DUPLICATE)`.
- Assert: every returned class is the same winner and carries the expected marker, and exactly one
  warning is emitted for the decision. Do NOT assert eager-source read counts: the prompt states
  caching for lazy probes and resolved selections, never a physical read count for eager sources, so
  pinning one would reject a conforming implementation that reads a candidate twice.
- Determinism: every assertion is scheduling-independent, because memoization makes the counts
  invariant on a correct implementation. Bound the barrier wait with a timeout and join every thread
  so a hung implementation fails loudly instead of hanging the suite.
- Keep the existing worker-count test; it covers output processing, the other half of the clause.

### Task 2 (blocker B): strict deferred registration

Add one test that instruments registration itself.

- Register two differing own duplicates via `addSpace`, plus an `error`-strategy variant.
- Immediately after registration assert `classReads` is zero on every source and
  `harness.logger.warnings()` is empty.
- Then request the first selection and assert reads occur and the warning, or the `error` conflict,
  surfaces at that point.
- This directly discriminates the eager-resolver shortcut, which is the base repository's own
  behavior and therefore the most likely wrong implementation.

### Task 3: class-entry-scoped omission (verifier-audit gaps 3 and 4, adopted)

Adopted because it clears the same four-axis bar: the clause "Losing duplicate entries are omitted,
while nonduplicate classes and non-class resources remain with their original inputs" is explicit;
the reference filters per class name via `isSelected(unit, name)`; the passer filters per name via
`selectedOwnClassNames(origin)`; and no current test covers it, because the existing `last` and
`error` output tests give the losing origin only the duplicate.

Extend those tests so the losing origin also owns an unrelated class and a resource, then assert both
still reach their own sink. Two audit gaps, one defect class, one round.

### Task 4: description re-voice (presentation only)

Both channels flag the same Low issue: paragraph 3 reads as a dense generated specification. The
human reviewer asks for "a more natural issue voice without changing any behavioral requirements".

Constraints, non-negotiable:

- Every behavioral clause survives verbatim in meaning. No clause added, removed, weakened, or
  broadened. This is the bean-to-map anchor-scoping lesson: an over-reaching re-word draws a solution
  or fairness finding.
- Re-voice paragraph 3 into guarantees about selection, family coherence, caching, reload, and output
  ownership rather than a run-on list of internal mechanics.
- ASCII only, no em dashes, no headings or bullet lists in the submitted prose.
- After the edit, re-run the clause-to-test grounding matrix in both directions. This is exactly the
  step whose absence created blocker B.

## 4. Verifier-audit triage (6 gaps)

The audit is evidence, not gospel. Its own requirements table marks R14 (deferred registration) and
R16 (concurrency) as **covered** - a false negative on precisely the two confirmed blockers - so its
coverage verdicts are not authoritative and its gaps are triaged individually.

| Gap | Verdict | Grounds |
| --- | --- | --- |
| 3, 4 - class-entry-scoped omission | **ADOPT** (Task 3) | Stated clause, reference correct, passer correct, genuinely uncovered |
| 1 - whitespace-decorated option values | **BYPASS** | R21 ("the accepted-value domain is exact") is audit-invented; the description never mentions trimming. The round-2 addendum already adjudicated and dropped `"first "` with written grounds, on the reasoning that a trimming parser is lenient rather than broken. Re-adopting reverses a considered fairness decision and pins unstated strictness. |
| 5 - non-String option values | **BYPASS** | Same invented R21, and rated COSMETIC. Asserting a typed-value diagnostic pins behavior the prompt never states. |
| 6 - byte-identical library duplicates must not warn | **BYPASS this round** | COSMETIC, medium plausibility. The warning condition is stated for "differing candidates", so a spurious extra warning is a diagnostic nit with no wrong-result consequence. Not worth new surface while the rate rests on a single run. |
| 2 - family coherence under `error` with a byte-identical duplicate and an unavailable root | **BYPASS this round** | A four-way conjunction resting on R22 ("family activation is strategy-independent"), an inference rather than a stated clause. Fixture cost and wall risk exceed the demonstrated value at 1/10. |

Fairness advisories 1 and 2 are the two blockers and are adopted as Tasks 1 and 2. Advisory 3 (option
documentation metadata) is declined: the reference and the passer both register
`@Name`/`@Description`/`@Type`, so the assertion would pass, but it pins a repository convention the
description never states, and `optionIsDocumentedDefaultedAndValidatedBeforeInputs` already covers the
DEFAULTS map and validate-before-processing.

### Task 5: child-origin output ownership (added after the fairness rerun)

The advisory list regenerated against the repaired suite. Crossing the contract against ORIGIN SHAPE
(root / child / library / cross-context) found one genuinely uncovered cell with a distinct
mechanism: a child context owns its own output sink, and no test asserted child sink ownership. Added
`childOriginKeepsOutputOwnershipForItsSelectedClass` (48 tests). Stated clause, reference green,
mutation-proven (root-only-output mutant fails exactly this cell), zero cost to the passer and both
near-solvers.

The other advisories are bypassed with grounds recorded in the ledger: reload warning lifecycle
(inference, near-miss of the already-enforced add-source variant), cross-context lazy-probe isolation
(no fair observable without the read counts just ruled unfair), and same-name conflict reporting
(behaviour already enforced; only message rendering is unasserted, and pinning it is the value-pinning
class that caused the round-1 fairness FAIL).

A second five-item advisory list was then adjudicated in full and NONE qualified; the grounds for each
are in the ledger. The two that recur (reload warning lifecycle, context-local lazy probe) do so
because the checker keeps no memory of prior adjudications, not because new exposure appeared.

Standing rule for the next round: judge every advisory on four axes before adopting - stated in the
description, reference correct, genuinely uncovered, and no plausible conforming implementation
rejected - plus a fifth the repeated-entry probe made explicit: is the behaviour already guaranteed by
BASE code the feature never touches? (`ContextUnit.save` dedupes sink entries at the base commit, so a
sink-cardinality assertion would test the repository rather than the submission.) An advisory that
fails any axis gets a written bypass, not a test.

## 5. What must not change

- Do not touch `solution-duplicate-class-resolution.patch`. It is auto-review band 3 and human 3/3.
- Do not add a defensive byte-array cloning test. The FP adjudicator explicitly overruled that probe
  as an unfair implementation detail; adding it imports the exact assertion the panel rejected.
- Do not clarify `addingLazySourceInvalidatesCachedNegativeProbe`. Three near-solvers sat at 39/40 on
  that cell in round 2; clarifying it would convert them at once and push the rate toward the ceiling.
- Do not assert message exclusivity or failure presentation beyond the stated fields. That species
  caused the round-1 fairness FAIL and was overruled again this round.
- Do not add tests that assert what the reference happens to do rather than what a description clause
  requires. Every new assertion in this plan traces to a quoted clause.

## 6. Verification

Local, before anything else:

- `git apply --check` and `--whitespace=error` for both patches at the exact base, independently and
  together; `git diff --check`; `bash -n` on `test.sh`; `test.sh` stays mode 100755; test and solution
  file sets stay disjoint; ASCII only; no forbidden tokens.
- Hunk header recount after every edit, plus a test-name uniqueness check.

Authoritative, remote per the hybrid-cloud workflow, in an isolated forge namespace:

1. Reference-green on the full suite including every new cell. **Hard gate.**
2. Four-state: base+tests passes, new-on-base fails for the intended reason, base+solution passes,
   new+solution passes.
3. Replay the sole passer (agent 3) against the new suite; it must stay fully green. **Hard gate** -
   if it fails, the new cell is wrong, not the passer.
4. Spot-replay two near-solvers to confirm no new wall: they must fail only the cells they already
   failed, plus at most the newly covered clause if they genuinely violate it.
5. Repeat the concurrency test enough times to demonstrate stability rather than a lucky schedule.

Then re-run the checks these edits stale: Verify Tests, Verify Solution, auto-review (require tests
band > 1 with both High issues absent), fairness (require PASS), and a fresh batch with the required
false-positive review.

## 7. Completion criteria

- Auto-review tests band is no longer 1 and neither High issue is reported.
- Auto-review description holds at 2 or better with only presentation notes.
- Fairness stays PASS; no new unfair test.
- False-positive review stays clean on the fresh batch.
- At least one legitimate pass, no more than 40%.
- Reference green, four-state green, patches apply clean, solution byte-identical to v1.
