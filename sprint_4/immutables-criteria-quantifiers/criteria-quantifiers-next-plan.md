# Criteria Quantifiers Next Iteration Plan (v7 -> v8): clear the strict LoC and test gates

> Written 2026-07-21 from the submitted v7 artifacts, the refreshed 2/12 platform
> evaluation, all ten materialized agent runs, auto-review, AI evaluation, prechecks,
> false-positive evaluation, and both human reviews. This is a review-first plan: do not
> change the submission artifacts until the author approves the strategy.

## Executive conclusion

The submission is close, but it is not currently deliverable for two independent reasons:

1. Human review estimates the golden solution at approximately 230 meaningful production
   lines, below the current Olympus floor of 250.
2. The latest auto-review assigns Tests Band 1 because array-valued paths are tested as inputs
   to `any()`/`all()`/`none()`, but not with inherited `isEmpty()`, `notEmpty()`, `hasSize()`,
   and `contains()` operations in the in-memory backend.

The platform difficulty and false-positive gates are healthy. The current evidence has one
legitimate pass among the ten materialized runs and two among the broader twelve-run analysis
(10% and 16.7%, respectively), all below 40% and both nonzero. The false-positive panel evaluated
the materialized passer and found zero false positives. We should preserve that passing anchor
while closing the test hole and resolving, rather than guessing at, the strict LoC count.

The recommended path is therefore evidence-first:

1. Add the missing array collection-leaf tests and one low-risk generated-matcher parity test.
2. Replay the reference and the known passing agent before changing scope.
3. Produce a strict, requirement-linked LoC ledger and ask for the reviewer's per-file or
   per-feature breakdown.
4. Expand functionality only if the strict recount remains below 250, and only after a proposed
   scope cell is proven green on the reference and at least one current passing anchor.

Do not add filler lines, tests-only volume, comments, wrappers, or redundant BSON helpers. Those
are excluded by the manager's rules and would make the solution worse without fixing the gate.

## Current evidence snapshot

| Gate | Current evidence | Status |
|---|---|---|
| Reference verification | 417/417 baseline and 37/37 focused tests | Pass |
| Difficulty | 1/10 materialized; 2/12 broader analysis | Pass: 10%-16.7%, nonzero and <=40% |
| Successful-run horizon | Median 8 files, 128 messages, 618 LoC | Pass |
| False-positive evaluation | 1 run evaluated; 0 false positives; 1 genuine pass | `PASSED_WITH_WARNINGS` |
| Test fairness | All hidden tests fair; two advisory suggestions | Pass |
| AI evaluation | Holistic verdict `PASS`; current suite called shippable | Pass, but not authoritative over auto-review |
| Auto-review | Description 3, solution 3, tests 1 | Blocked on array collection-leaf coverage |
| Human review | Description 3, tests 2, solution 3; golden meaningful LoC `~230` | Blocked below 250 |

The 618-LoC number and the reviewer's approximately 230-LoC number are not contradictory. The
first is the median implementation size of successful agents; the second is a strict estimate of
the golden/reference solution. They are separate Olympus gates and both must pass.

## LoC verification

### What can be reproduced

The current reference patch changes six production files:

| File | Raw patch delta | Lenient counter |
|---|---:|---:|
| `Path.java` | +15 / -4 | 13 |
| `CriteriaContext.java` | +21 / -6 | 18 |
| `IterableMatcher.java` | +22 / -1 | 13 |
| `ExpressionInterpreter.java` | +45 / -20 | 47 |
| `FindVisitor.java` | +674 / -223 | 695 |
| `CriteriaModel.java` | +26 / -4 | 21 |
| **Total** | **+803 / -258** | **807** |

The repository's `review-guides/count_loc.py` reports 807 after collapsing adjacent
modifications and excluding blanks and comments. That result is useful only as a lenient screen:
the current platform rules explicitly say the manager also removes imports, braces and
punctuation-only lines, export-only wiring, type-only declarations, boilerplate, tests, and
non-meaningful churn.

The exact human number of approximately 230 cannot be independently reconstructed because the
review contains no per-file or per-method breakdown. It is not the raw delta, net delta, the
repository counter, or the successful-agent median. Reaching that number requires an aggressive
semantic discount, especially inside the 695-line lenient `FindVisitor` count.

### Why a strict reviewer can discount so much

Several parts of the patch are mechanically large but do not automatically count one-for-one:

- the Mongo visitor replaces and reorganizes existing translation paths, so moved legacy
  behavior and generic BSON construction may be treated as refactoring or boilerplate;
- imports, comments, braces, declarations, routing containers, and repetitive filter assembly
  are excluded even when necessary for compilation;
- `Path.ofType`, creator threading, `IterableMatcher.creator`, and
  `CriteriaModel.nestedIterableCreator` support direct collection-of-collection generation even
  though the current description explicitly excludes that surface;
- fieldless nested-iterable and `matches(Pattern)` support in the golden patch goes beyond the
  currently named contract and may therefore be excluded from task-effective scope.

This explains how the strict result can be dramatically lower than 807. It does not prove that
230 is the correct result. The reviewer marked the solution itself 3/3, so the issue is the tier
floor, not code quality or a claim that the implementation is padded.

### Working verdict

- The exact `~230` figure is **unverified**, because no auditable breakdown was supplied.
- The strict 250-line floor is nevertheless **binding** under the current review workflow.
- A lenient counter result of 807 is not sufficient evidence for approval.
- A claimed expansion of only 20 lines is too fragile. If expansion is required, target at least
  280-300 reviewer-counted production lines to survive classification variance.

Before changing scope, prepare a reviewer-facing ledger that assigns each non-excluded production
line to a current requirement: typed API and creator propagation, array-aware in-memory truth,
Mongo true/false/unknown evaluation, same-element scalar/object correlation, nested scope routing,
and legacy compatibility. Ask the reviewer to identify which groups were removed to reach 230.
This is the only reliable way to tell whether the submission is actually short or merely counted
under a different interpretation.

## Test findings and adjudication

### Blocking auto-review issue: fix

Add one in-memory test method covering inherited collection predicates on array-valued paths:

- object array: empty/non-empty, `hasSize()`, successful and unsuccessful `contains()`;
- primitive array: empty/non-empty, `hasSize()`, successful and unsuccessful `contains()`;
- use generated criteria where practical so the API path and runtime behavior are both exercised;
- assert observable matches, not interpreter helpers or implementation shape.

The base interpreter currently accepts only `Iterable` for these leaf operations, so this is a
real discriminator rather than redundant coverage. The reference solution and materialized
passing agent both centralize `Iterable` and Java-array traversal, so the expected projection is
that the known pass remains green. That projection must still be replayed, not assumed.

### Fairness advisory: generated matcher parity — add narrowly

Add one in-memory generated-matcher test that executes `all()` and `none()` with the named string
leaf operations (`startsWith`, `contains`, `endsWith`, and `hasLength`). Fold the assertions into
one coherent truth-table fixture rather than multiplying near-duplicate tests. The reference and
known passer already expose and execute these generated chains, making this a low-risk closure of
the advisory.

### Fairness advisory: rejected behavior for excluded nested collections — do not add

Do not add a test requiring direct collection-of-collection quantification to be rejected. The
description says that surface is outside the required contract; it does not promise a rejection
mode. Implementations are free to support it. A negative test would invent a new requirement,
penalize valid supersets, and recreate the false-positive/fairness problem that v6 removed.

### False-positive caveats — keep out of this iteration

Do not add the panel's flat `any().isNot()` null-element probe. The reference and the passing
candidate fail it identically, and the adjudicator classified it as a non-discriminating legacy
spec gap. Adding it without deliberately changing the description and reference would break the
golden solution and could invalidate the current genuine pass. The supplementary-character
length question is likewise under-specified and non-blocking in the current report.

## Scope decision

### Selected first move: strict recount plus test closure

The current task already spans a typed generated API, an in-memory evaluator, and executable Mongo
translation with nested three-valued quantifier semantics. Because the exact 230 count is not
auditable, the safest next iteration is not an immediate functionality expansion. First close the
known test defect and present a requirement-linked strict count.

### Changes that must not be used as an LoC bump

- Do not restore the full direct collection-of-collection family. That family was a dominant
  failure source in the earlier 0-pass batches, is excluded by the current description, and is
  not implemented by the known passing agent's generated API.
- Do not restore quantified `matches(Pattern)` merely to gain lines. The materialized passer's
  Mongo translator does not support it, so doing so would remove the only replay-proven anchor.
- Do not add a new quantifier such as `exactlyOne()` or an unrelated backend. That is a task
  redesign, not a safe 20-line correction, and requires a fresh difficulty study.
- Do not count test additions toward the golden production floor.

### Conditional scope pilot if the reviewer confirms approximately 230

If the strict ledger and reviewer breakdown still leave the golden below 250, pilot the smallest
already-implemented, anchor-compatible contract extension before editing the final artifacts:

1. Make root-level boolean composition around quantified criteria explicit for valid collection
   values: direct `not(all(...))`, direct `not(none(...))`, and conjunction/disjunction with an
   ordinary field predicate.
2. Define quantified string length as Unicode code-point length and add a supplementary-character
   case alongside the existing newline boundary.

Both behaviors are implemented by the current reference and the known materialized passer, so
they are safer than regex or direct nested-collection scope. They may make additional existing
Mongo truth-routing and string-length logic count as task-effective, but this must be confirmed by
a strict recount. If the reviewer still counts below 250, stop: there is no evidence-backed
micro-expansion that guarantees both the LoC floor and a nonzero pass rate. At that point choose
between a genuine larger redesign with a new agent batch or retiring/replacing the task.

## Execution plan after author approval

### 1. Freeze and audit the submitted state

- Record the current description/test/solution hashes and preserve all platform reports and agent
  artifacts as immutable v7 evidence.
- Build a per-file, per-method strict LoC worksheet using the manager exclusion list. Separate
  required feature logic, legacy behavior retained by the task, and code outside the current
  contract.
- Request the human reviewer's breakdown or confirmation before treating 230 as exact.

### 2. Add tests in an isolated upstream checkout

- Apply the current test patch at base commit `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`.
- Add the array collection-leaf in-memory test and the generated string-matcher parity test.
- Keep the collection-of-collection exclusion as prose only; add no rejection test.
- Do not change the golden solution unless the reference run exposes a real defect.

Expected focused count: 39 test methods (5 API, 16 in-memory, 18 Mongo), assuming each new
coverage family is expressed as one coherent test method.

### 3. Run the minimum decisive replay

- Reference: all 39 focused tests and all 417 baseline tests must pass.
- Clean base: focused tests must fail for the missing `all()`/`none()` feature while baseline
  remains green.
- Materialized agent 5: all 39 focused tests and baseline must remain green.
- If the broader second passer is available as a replayable artifact, verify it as well; do not
  claim 2/12 after the test change without evidence.

The guaranteed projection is at least 1/10 materialized (10%) if agent 5 remains green. The
broader projection remains 2/12 (16.7%) only after the second pass is replay-confirmed. Either is
nonzero and safely below 40%.

### 4. Resolve LoC before any full platform rerun

- If the strict ledger is at least 250 and the reviewer accepts the classification, do not expand
  scope. Prefer correcting the count over changing a balanced task.
- If the reviewer confirms a strict count below 250, run the conditional composition/Unicode
  pilot against the reference and agent 5, then request a recount.
- Proceed only if the reviewer-counted golden reaches at least 280 or the reviewer explicitly
  confirms that the resulting scope clears the floor.
- If the pilot does not clear the floor, stop and redesign with a new agent study rather than
  stacking speculative requirements onto this submission.

### 5. Regenerate and verify final artifacts

- Regenerate only `immutables-criteria-quantifiers.md`, `test-criteria-quantifiers.patch`, and
  `solution-criteria-quantifiers.patch` if the approved plan requires a golden change.
- Run `git apply --check` independently and together at the exact base, `git diff --check`, shell
  syntax and executable-mode checks for `test.sh`, forbidden-token/leakage scans, and disjoint
  test/solution write-set checks.
- Use the remote workflow only if local cached verification cannot execute Mongo reliably; use an
  isolated forge and the narrowest decisive command.
- Rerun auto-review and false-positive evaluation after the final artifacts stabilize. Do not rely
  on the previous reports after tests or contract wording change.

## Final submission gate

The next submission is ready only when all of the following are evidenced:

- the strict golden solution count is reviewer-confirmed at or above 250, preferably 280+;
- auto-review no longer reports the array collection-leaf T4 hole;
- the two added in-memory coverage families pass on the reference and the known passing agent;
- at least one legitimate agent pass remains and total pass rate is <=40%;
- the false-positive panel reports zero false-positive passing runs;
- no test requires rejection of the deliberately excluded collection-of-collection surface;
- description, tests, and golden solution have a complete two-way requirement matrix;
- baseline remains 417/417, focused reference tests are fully green, and the clean base still
  fails the feature suite; and
- final patches apply cleanly and contain no leakage, infrastructure workaround, or unrelated
  production change.
