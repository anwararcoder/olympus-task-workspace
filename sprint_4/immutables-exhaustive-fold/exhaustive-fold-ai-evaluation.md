# ✅ AI Evaluation Report

> Automated review of problem quality, fairness, and agent failure patterns

## Metadata

- **Verdict:** `PASS`
- **Completed:** 2026-07-11 12:51:12
- **Created:** 2026-07-11 12:40:30
- **Step:** Completed
- **Job ID:** `nx76vtv38984jvny5y7rcy5zg18abbtg`

## Summary Statistics

- **Pass Rate:** 20% (10 runs)
- **Confidence:** 0.9
- **Reasoning:** PASS: 20% pass rate across 10 completed runs, at least one true positive, broad tests matching the stated requirements, and observed failures attributable to substantive implementation bugs rather than ambiguity or brittle tests.

## Reviewer Notes

This is a fair and well-constructed hard processor task. The pass rate is 2/10, with two evaluator-confirmed legitimate implementations passing both baseline and all 47 hidden exhaustive-fold tests. The hidden fixture maps closely to the task description: API generation (`valueEnclosingTypeGetsAFoldCompanion`, line 649), bottom-up folding, container shapes, identity memoization, most-specific dispatch, multiple families, generic exclusions, and rejection of unknown implementations are all directly exercised through generated public APIs.

The failing rollouts failed for valid engineering reasons. Seven runs never reached the fixture because their generated source or processor integration broke compilation, with concrete errors such as ClassCastException, Multimap `entrySet()` on a Multimap, SortedSet converted to a scalar family value, leaked generic `T`, and duplicate parameter `value`. The only rollout that compiled and ran the hidden tests failed two focused assertions: `sortedSetChildrenDeliveredAsListInIterationOrder` and `familyValuesInUnsupportedShapesContributeNoParameter`, both of which are explicit or reasonably inferable from the container-shape rules. I do not see a trivial hintable obstacle or an unfair hidden assumption; the `attributeNamedValueFoldsAndCompiles` case is slightly subtle but a reasonable source-generation robustness check.

## Checklist (25/25 passed)

### Problem

- ✅ **Requirements complete and self-contained**
  - The description states the generation trigger, naming, case/default method shape, supported containers, nullability, identity memoization, dispatch, multiple-family behavior, and generic exclusions. T...
- ✅ **No ambiguities, fully deterministic**
  - Expected behavior is deterministic: result parameters and container order are specified, unsupported shapes are excluded, and unknown implementations throw IllegalArgumentException. The tests avoid re...
- ✅ **Concise and not prescriptive**
  - The problem describes externally visible generated API and fold semantics without dictating the internal model or generator architecture.
- ✅ **Matches real-world repo scope**
  - Adding a new generated companion to Immutables' annotation processor is realistic, substantial repository work rather than a toy algorithm.
- ✅ **Aligns with repo design philosophy**
  - The reference solution adds a generator, metadata model, and processor wiring consistent with existing Immutables generation patterns.
- ✅ **No irrelevant context**
  - The prompt is dense but focused on fold generation requirements; there is no unrelated narrative.
- ✅ **Clear writing and formatting**
  - The description is a long paragraph rather than a structured checklist, but it is precise and covers the behaviors the tests enforce.
- ✅ **Solution meets all requirements**
  - The reference solution implements fold model discovery, child-shape classification, identity caching, dispatch, and generator output covering the hidden fixture.
- ✅ **No plagiarism**
  - No evidence in the artifacts indicates copied tutorial or issue text; the task is specialized to this repository's processor internals and hidden fixture.

### Tests

- ✅ **New tests highlight missing or incorrect behavior**
  - The base repository lacks this generated Fold feature, while the reference solution passes the hidden fixture and two agent rollouts pass legitimately.
- ✅ **Tests are deterministic**
  - The fixture builds fixed immutable values and checks deterministic iteration order derived from the containers themselves; no timing, randomness, or network behavior is involved.
- ✅ **Assertions verify the correct output**
  - Assertions check exact fold results, exact reflected method presence, parameter counts, container values, and exception type.
- ✅ **Tests validate behavior, not internals**
  - The hidden tests interact with generated public classes and methods via reflection/proxies and compile generated Java. They do not inspect private processor state.
- ✅ **Tests follow repo structure**
  - The tests live under value-fixture/test with normal JUnit 4 patterns and use the repository's Checkers helpers and Maven flow through test.sh.
- ✅ **Tests cover required behavior and edge cases**
  - The 47 hidden tests cover API shape, all specified container shapes, nullability, identity memoization, dispatch, multiple families, generics, unsupported shapes, and failure paths.
- ✅ **Test suite is concise**
  - The fixture is large, but the feature surface is also large. Most tests cover distinct requirements rather than redundant variants.
- ✅ **Tests do not check unspecified behavior**
  - Most tests map directly to explicit requirements. The attribute-name collision case is not stated verbatim but is a reasonable code-generation robustness edge for legal input.
- ✅ **No unreasonable assumptions in tests**
  - Failures are due to explicit or inferable requirements such as sorted-set handling, multimap entries, generic implementation cases, and valid generated Java names, not arbitrary strings or private int...
- ✅ **No trivial or unfair failure patterns**
  - No rollout failed because it could not find the test runner or because of flaky infrastructure. The common failures are substantive code-generation bugs.

### Solution

- ✅ **No regressions, code follows patterns**
  - Reference changes are localized to processor generator/model wiring and pass baseline tests according to the run context.
- ✅ **No unexplained defensive code**
  - The reference code mainly implements required fold behavior; the IllegalArgumentException path is specified, and null/object checks serve the generated API contract.
- ✅ **No irrelevant changes**
  - The reference patch adds Folds.generator, Folds.java, FoldModel.java, processor registration, and a small ValueType hook, all directly task-related.
- ✅ **API contracts remain stable**
  - Existing APIs are not broken; the feature adds new generated interfaces only for eligible enclosing types.
- ✅ **No AI slop**
  - The reference solution is compact, idiomatic for this codebase, and lacks verbose comments or hallucinated abstractions.

### Other

- ✅ **Hint is appropriate if present**
  - No hint is needed: pass rate is nonzero, and the shared misses are already covered by explicit task language rather than a discoverability trap.

## Test Group Analysis

### ❌ Existing value-fixture baseline suite

- **Tests:** 329 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Runs the repository's existing value-fixture tests excluding the new exhaustive fold fixture

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Fold companion API surface

- **Tests:** 3 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Checks generation of public <Enclosing>Fold<R>, default fold entries, abstract cases, and absence of ineligible entries

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Basic direct folding

- **Tests:** 3 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Leaf cases, direct child parameters, and chained bottom-up folding

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ List optional map basics

- **Tests:** 4 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- List children, empty containers, JDK Optional, and map value folding

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Optional and nullable singles

- **Tests:** 3 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Guava Optional flavor plus nullable direct family attributes when absent or present

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Set and sorted set containers

- **Tests:** 2 | **Pass Rate:** 20% | **Runs:** 2 passed, 8 failed | **Fairness:** fair
- Set and sorted-set family attributes folded into Lists in iteration order

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.
  **Failure Mode** (subtle_but_fair, INFERRABLE, 3 runs):
  > SortedSet family attributes were omitted or treated as a direct family value instead of being folded to a List in iteration order.

### ❌ Case execution order

- **Tests:** 1 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Verifies every implementation case runs after its child folds

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Identity memoization

- **Tests:** 4 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Ensures one fold application runs at most once per reachable value and distinguishes equal separate values

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Most-specific dispatch

- **Tests:** 5 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Dispatches extended immutable implementations to the most specific case and exposes fold entries for extended implementation families

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Inherited and ordered attributes

- **Tests:** 3 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Inherited family attributes and declared child parameters appear in declaration order with correct case signatures

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Multiple families

- **Tests:** 3 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Several family roots in one enclosing type, cross-family child folding, and one case for an implementation shared by families

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Caller-chosen result type

- **Tests:** 1 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Fold result type parameter is independent of the folded value family

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Unsupported and non-family shapes

- **Tests:** 3 | **Pass Rate:** 20% | **Runs:** 2 passed, 8 failed | **Fairness:** fair
- Attributes without same-enclosing family involvement, map keys, and nested containers contribute no child parameter

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.
  **Failure Mode** (subtle_but_fair, EXPLICIT, 1 runs):
  > Multiset children or unsupported nested shapes produced the wrong case signature.

### ❌ Multimap behavior

- **Tests:** 2 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Multimap value folding preserves keys, multiplicity, and order, including empty multimap cases

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.
  **Failure Mode** (genuinely_hard, EXPLICIT, 2 runs):
  > Guava Multimap values were treated like Map entry sets rather than Multimap entries.

### ❌ Array and multiset behavior

- **Tests:** 2 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Arrays fold to lists in array order and multisets fold to result lists with multiplicity

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Nullable containers

- **Tests:** 3 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Nullable list, map, optional, multimap, multiset, and array containers produce null when absent and fold normally when present

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Generic family handling

- **Tests:** 2 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Generic implementations get cases, but generic family roots and single-implementation roots do not get fold methods

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.
  **Failure Mode** (genuinely_hard, EXPLICIT, 2 runs):
  > Case signatures for generic implementations leaked implementation type parameters into a non-generic fold interface method.

### ❌ Attribute name collision

- **Tests:** 1 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- A family attribute legally named value folds and compiles

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.
  **Failure Mode** (subtle_but_fair, INFERRABLE, 2 runs):
  > Generated case parameters collided with an attribute named `value`.

### ❌ Foreign same-name families

- **Tests:** 1 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- A same-named family type from another package does not count as same-enclosing family involvement

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Unknown implementation rejection

- **Tests:** 1 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Passing a hand-written family instance outside the generated implementations throws IllegalArgumentException

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

### ❌ Enclosing and implementation eligibility

- **Tests:** 2 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** fair
- Families outside @Value.Enclosing, families with too few implementations, and generic root families receive no generated fold entry

  **Failure Mode** (genuinely_hard, EXPLICIT, 7 runs):
  > Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.

## Failure Patterns

### Pattern 1: Generated code or processor integration fails Java compilation before hidden tests execute

- **Type:** genuinely_hard | **Affected Runs:** 7 | **Hint Candidate:** No
- **Affected Test Groups:** Existing value-fixture baseline suite, Fold companion API surface, Basic direct folding, Set and sorted set containers, Generic family handling
- **Analysis:** Seven runs fail with real compiler or processor errors: ClassCastException, duplicate parameter `value`, undeclared generic `T`, SortedSet conversion, and Multimap entrySet() mistakes. These are valid agent failures for a generated-source feature, not a test harness problem.

### Pattern 2: Agents mishandle explicit container shapes, especially SortedSet, Multimap, and Multiset

- **Type:** subtle_but_fair | **Affected Runs:** 4 | **Hint Candidate:** No
- **Affected Test Groups:** Set and sorted set containers, Unsupported and non-family shapes, Multimap behavior, Array and multiset behavior
- **Analysis:** The problem explicitly lists list, set, multiset, array, map, and multimap behavior. The failures show incomplete shape analysis rather than hidden expectations: rd78 misses sorted-set/multiset signatures, rd7abr and rd7bq treat SortedSet as a scalar, and rd7dzza uses Map entrySet() on Multimap.

### Pattern 3: Generic implementation cases are emitted with invalid type variables

- **Type:** genuinely_hard | **Affected Runs:** 2 | **Hint Candidate:** No
- **Affected Test Groups:** Generic family handling, Fold companion API surface
- **Analysis:** Both runs generate MeterSpecFold methods that reference undeclared `T`. The description explicitly says generic family roots get no fold method, but generic implementations in eligible families still get a case, making this a fair hard requirement.

### Pattern 4: Generated parameter names collide with user attributes named `value`

- **Type:** subtle_but_fair | **Affected Runs:** 2 | **Hint Candidate:** No
- **Affected Test Groups:** Attribute name collision
- **Analysis:** The compile error is a normal source-generation robustness issue. The exact attribute name is not in the prompt, but arbitrary legal attribute names are part of the public input space for an annotation processor, so the test is subtle but fair.

## Top Passing Runs

### Run 1 (PASS) ✅

**Strategy:** Passed both baseline and all 47 hidden exhaustive-fold tests. The evaluator classified it as a legitimate processor implementation rather than test-gaming.

**True Positive Analysis:** It generates the fold companion through the annotation processor and survives baseline compilation, container-shape tests, dispatch tests, generics, and memoization checks. This would pass code review at the behavioral level.

### Run 2 (PASS) ✅

**Strategy:** Also passed baseline and hidden tests with evaluator confirmation of a legitimate generator implementation.

**True Positive Analysis:** The solution implements ordinary processor metadata and generator support and is not merely special-casing the hidden fixture.

## Submission Readiness ✅

**Can Submit:** Yes

| Criterion | Status | Detail |
|-----------|--------|--------|
| ✅ Prechecks | pass | 5/5 passing |
| ✅ Quality Checks | pass | 7/7 passing |
| ✅ Fair task | pass | No fairness issues |
| ✅ Solvable | pass | 2/10 solved |
| ✅ Difficulty | pass | 20% — Hard |
| ✅ Long-horizon | pass | Median files: 7, messages: 200, LOC: 691.5 |
| ✅ No cheating | pass | No cheating detected |
| ✅ No environment blockers | pass | No environment blockers detected |
| ✅ No false positives | pass | No false positives detected |
| ✅ Holistic AI Review | pass | PASS |
| ✅ Rebuild-safe | pass | image rebuilds hermetically |
| ✅ Harbor rebuild-safe | pass | image deep-rebuilds from clean source + vendored deps |

---

<details>
<summary>Raw JSON Data</summary>

```json
{
  "type": "holistic_review",
  "title": "AI Review",
  "subtitle": "Automated review of problem quality, fairness, and agent failure patterns",
  "metadata": {
    "completedAt": 1783763472910,
    "createdAt": 1783762830650,
    "currentStep": "Completed",
    "jobId": "nx76vtv38984jvny5y7rcy5zg18abbtg"
  },
  "verdict": "PASS",
  "reviewer_notes": "This is a fair and well-constructed hard processor task. The pass rate is 2/10, with two evaluator-confirmed legitimate implementations passing both baseline and all 47 hidden exhaustive-fold tests. The hidden fixture maps closely to the task description: API generation (`valueEnclosingTypeGetsAFoldCompanion`, line 649), bottom-up folding, container shapes, identity memoization, most-specific dispatch, multiple families, generic exclusions, and rejection of unknown implementations are all directly exercised through generated public APIs.\n\nThe failing rollouts failed for valid engineering reasons. Seven runs never reached the fixture because their generated source or processor integration broke compilation, with concrete errors such as ClassCastException, Multimap `entrySet()` on a Multimap, SortedSet converted to a scalar family value, leaked generic `T`, and duplicate parameter `value`. The only rollout that compiled and ran the hidden tests failed two focused assertions: `sortedSetChildrenDeliveredAsListInIterationOrder` and `familyValuesInUnsupportedShapesContributeNoParameter`, both of which are explicit or reasonably inferable from the container-shape rules. I do not see a trivial hintable obstacle or an unfair hidden assumption; the `attributeNamedValueFoldsAndCompiles` case is slightly subtle but a reasonable source-generation robustness check.",
  "checklist": {
    "total": 25,
    "pass_count": 25,
    "fail_count": 0,
    "items": [
      {
        "item": "Requirements complete and self-contained",
        "reasoning": "The description states the generation trigger, naming, case/default method shape, supported containers, nullability, identity memoization, dispatch, multiple-family behavior, and generic exclusions. The one unstated-but-inferable edge is avoiding source-name collisions with user attributes.",
        "verdict": "pass"
      },
      {
        "item": "No ambiguities, fully deterministic",
        "reasoning": "Expected behavior is deterministic: result parameters and container order are specified, unsupported shapes are excluded, and unknown implementations throw IllegalArgumentException. The tests avoid relying on unspecified random or timing behavior.",
        "verdict": "pass"
      },
      {
        "item": "Concise and not prescriptive",
        "reasoning": "The problem describes externally visible generated API and fold semantics without dictating the internal model or generator architecture.",
        "verdict": "pass"
      },
      {
        "item": "Matches real-world repo scope",
        "reasoning": "Adding a new generated companion to Immutables' annotation processor is realistic, substantial repository work rather than a toy algorithm.",
        "verdict": "pass"
      },
      {
        "item": "Aligns with repo design philosophy",
        "reasoning": "The reference solution adds a generator, metadata model, and processor wiring consistent with existing Immutables generation patterns.",
        "verdict": "pass"
      },
      {
        "item": "No irrelevant context",
        "reasoning": "The prompt is dense but focused on fold generation requirements; there is no unrelated narrative.",
        "verdict": "pass"
      },
      {
        "item": "Clear writing and formatting",
        "reasoning": "The description is a long paragraph rather than a structured checklist, but it is precise and covers the behaviors the tests enforce.",
        "verdict": "pass"
      },
      {
        "item": "New tests highlight missing or incorrect behavior",
        "reasoning": "The base repository lacks this generated Fold feature, while the reference solution passes the hidden fixture and two agent rollouts pass legitimately.",
        "verdict": "pass"
      },
      {
        "item": "Tests are deterministic",
        "reasoning": "The fixture builds fixed immutable values and checks deterministic iteration order derived from the containers themselves; no timing, randomness, or network behavior is involved.",
        "verdict": "pass"
      },
      {
        "item": "Assertions verify the correct output",
        "reasoning": "Assertions check exact fold results, exact reflected method presence, parameter counts, container values, and exception type.",
        "verdict": "pass"
      },
      {
        "item": "Tests validate behavior, not internals",
        "reasoning": "The hidden tests interact with generated public classes and methods via reflection/proxies and compile generated Java. They do not inspect private processor state.",
        "verdict": "pass"
      },
      {
        "item": "Tests follow repo structure",
        "reasoning": "The tests live under value-fixture/test with normal JUnit 4 patterns and use the repository's Checkers helpers and Maven flow through test.sh.",
        "verdict": "pass"
      },
      {
        "item": "Tests cover required behavior and edge cases",
        "reasoning": "The 47 hidden tests cover API shape, all specified container shapes, nullability, identity memoization, dispatch, multiple families, generics, unsupported shapes, and failure paths.",
        "verdict": "pass"
      },
      {
        "item": "Test suite is concise",
        "reasoning": "The fixture is large, but the feature surface is also large. Most tests cover distinct requirements rather than redundant variants.",
        "verdict": "pass"
      },
      {
        "item": "Tests do not check unspecified behavior",
        "reasoning": "Most tests map directly to explicit requirements. The attribute-name collision case is not stated verbatim but is a reasonable code-generation robustness edge for legal input.",
        "verdict": "pass"
      },
      {
        "item": "Solution meets all requirements",
        "reasoning": "The reference solution implements fold model discovery, child-shape classification, identity caching, dispatch, and generator output covering the hidden fixture.",
        "verdict": "pass"
      },
      {
        "item": "No regressions, code follows patterns",
        "reasoning": "Reference changes are localized to processor generator/model wiring and pass baseline tests according to the run context.",
        "verdict": "pass"
      },
      {
        "item": "No unexplained defensive code",
        "reasoning": "The reference code mainly implements required fold behavior; the IllegalArgumentException path is specified, and null/object checks serve the generated API contract.",
        "verdict": "pass"
      },
      {
        "item": "No irrelevant changes",
        "reasoning": "The reference patch adds Folds.generator, Folds.java, FoldModel.java, processor registration, and a small ValueType hook, all directly task-related.",
        "verdict": "pass"
      },
      {
        "item": "API contracts remain stable",
        "reasoning": "Existing APIs are not broken; the feature adds new generated interfaces only for eligible enclosing types.",
        "verdict": "pass"
      },
      {
        "item": "No AI slop",
        "reasoning": "The reference solution is compact, idiomatic for this codebase, and lacks verbose comments or hallucinated abstractions.",
        "verdict": "pass"
      },
      {
        "item": "No plagiarism",
        "reasoning": "No evidence in the artifacts indicates copied tutorial or issue text; the task is specialized to this repository's processor internals and hidden fixture.",
        "verdict": "pass"
      },
      {
        "item": "No unreasonable assumptions in tests",
        "reasoning": "Failures are due to explicit or inferable requirements such as sorted-set handling, multimap entries, generic implementation cases, and valid generated Java names, not arbitrary strings or private internals.",
        "verdict": "pass"
      },
      {
        "item": "No trivial or unfair failure patterns",
        "reasoning": "No rollout failed because it could not find the test runner or because of flaky infrastructure. The common failures are substantive code-generation bugs.",
        "verdict": "pass"
      },
      {
        "item": "Hint is appropriate if present",
        "reasoning": "No hint is needed: pass rate is nonzero, and the shared misses are already covered by explicit task language rather than a discoverability trap.",
        "verdict": "pass"
      }
    ]
  },
  "detailed_analysis": {
    "test_groups": [
      {
        "category": "baseline",
        "description": "Runs the repository's existing value-fixture tests excluding the new exhaustive fold fixture",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about not regressing existing annotation processing."
          }
        ],
        "fairness_reasoning": "Baseline failures are due to the agents' processor changes breaking compilation or existing generated types. Keeping the old suite green is a standard expectation for a processor feature.",
        "fairness_verdict": "fair",
        "group_name": "Existing value-fixture baseline suite",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 329
      },
      {
        "category": "new_behavior",
        "description": "Checks generation of public <Enclosing>Fold<R>, default fold entries, abstract cases, and absence of ineligible entries",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Checks generation of public <Enclosing>Fold<R>, default fold entries, abstract cases, and absence of ineligible entries."
          }
        ],
        "fairness_reasoning": "Tests `valueEnclosingTypeGetsAFoldCompanion` (line 649), `generatedFoldInterfaceIsPublicWithOneResultTypeParameter` (line 897), and `allCasesAbstractEntriesDefaultAndIneligibleShapesAbsent` (line 905). These directly match the specified interface naming, result type parameter, abstract case methods, and default fold methods.",
        "fairness_verdict": "fair",
        "group_name": "Fold companion API surface",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 3
      },
      {
        "category": "new_behavior",
        "description": "Leaf cases, direct child parameters, and chained bottom-up folding",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Leaf cases, direct child parameters, and chained bottom-up folding."
          }
        ],
        "fairness_reasoning": "Tests at lines 293, 300, and 307 check the core bottom-up fold contract and the rule that a direct family attribute contributes its already-folded result.",
        "fairness_verdict": "fair",
        "group_name": "Basic direct folding",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 3
      },
      {
        "category": "new_behavior",
        "description": "List children, empty containers, JDK Optional, and map value folding",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about List children, empty containers, JDK Optional, and map value folding."
          }
        ],
        "fairness_reasoning": "Tests at lines 314, 336, 358, and 369 map directly to the described list, optional, empty-container, and map-value shapes.",
        "fairness_verdict": "fair",
        "group_name": "List optional map basics",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 4
      },
      {
        "category": "new_behavior",
        "description": "Guava Optional flavor plus nullable direct family attributes when absent or present",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Guava Optional flavor plus nullable direct family attributes when absent or present."
          }
        ],
        "fairness_reasoning": "The description states optional attributes preserve their optional type and nullable attributes produce null when absent. Lines 397, 416, and 439 exercise exactly that behavior.",
        "fairness_verdict": "fair",
        "group_name": "Optional and nullable singles",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 3
      },
      {
        "category": "new_behavior",
        "description": "Set and sorted-set family attributes folded into Lists in iteration order",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Set and sorted-set family attributes folded into Lists in iteration order."
          },
          {
            "affected_runs": [
              "rd78c5qv2a2pg93yqaaba2s4518ab62t",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb"
            ],
            "classification": "INFERRABLE",
            "description": "SortedSet family attributes were omitted or treated as a direct family value instead of being folded to a List in iteration order.",
            "explanation_type": "subtle_but_fair",
            "reasoning": "The hidden test `sortedSetChildrenDeliveredAsListInIterationOrder` at value-fixture/test/org/immutables/fixture/fold_c8b14d/ExhaustiveFold_382647_Test.java:479 expects a sorted set of family values to contribute a list of folded results. The description explicitly says set attributes contribute a list in iteration order; applying that to the repo's sorted-set attribute kind is subtle but fair."
          }
        ],
        "fairness_reasoning": "The sorted-set assertion at line 479 is a fair extension of the specified set-container rule. It verifies observable iteration order rather than implementation internals.",
        "fairness_verdict": "fair",
        "group_name": "Set and sorted set containers",
        "pass_rate_across_rollouts": 0.2,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Verifies every implementation case runs after its child folds",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Verifies every implementation case runs after its child folds."
          }
        ],
        "fairness_reasoning": "`everyCaseRunsAfterItsChildren` at line 503 is the direct behavioral meaning of bottom-up computation.",
        "fairness_verdict": "fair",
        "group_name": "Case execution order",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Ensures one fold application runs at most once per reachable value and distinguishes equal separate values",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Ensures one fold application runs at most once per reachable value and distinguishes equal separate values."
          }
        ],
        "fairness_reasoning": "Tests at lines 531, 558, 1085, and 1114 check the explicit identity-cache requirement, including reuse across lists, maps, and multiple family fold entries.",
        "fairness_verdict": "fair",
        "group_name": "Identity memoization",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 4
      },
      {
        "category": "new_behavior",
        "description": "Dispatches extended immutable implementations to the most specific case and exposes fold entries for extended implementation families",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Dispatches extended immutable implementations to the most specific case and exposes fold entries for extended implementation families."
          }
        ],
        "fairness_reasoning": "Tests at lines 581, 592, 608, 626, and 993 cover the explicit requirements for most-specific implementation dispatch and fold entries for implementations extended by other implementations.",
        "fairness_verdict": "fair",
        "group_name": "Most-specific dispatch",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 5
      },
      {
        "category": "new_behavior",
        "description": "Inherited family attributes and declared child parameters appear in declaration order with correct case signatures",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Inherited family attributes and declared child parameters appear in declaration order with correct case signatures."
          }
        ],
        "fairness_reasoning": "Tests at lines 667, 730, and 1143 match the specification that inherited attributes are included and child result parameters follow declaration order.",
        "fairness_verdict": "fair",
        "group_name": "Inherited and ordered attributes",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 3
      },
      {
        "category": "new_behavior",
        "description": "Several family roots in one enclosing type, cross-family child folding, and one case for an implementation shared by families",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Several family roots in one enclosing type, cross-family child folding, and one case for an implementation shared by families."
          }
        ],
        "fairness_reasoning": "Tests at lines 674, 687, and 699 directly exercise the stated support for several family types and a single case reachable from multiple family entries.",
        "fairness_verdict": "fair",
        "group_name": "Multiple families",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 3
      },
      {
        "category": "new_behavior",
        "description": "Fold result type parameter is independent of the folded value family",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Fold result type parameter is independent of the folded value family."
          }
        ],
        "fairness_reasoning": "`resultTypeIsCallerChosenIndependently` at line 714 validates the required single type parameter for the fold result.",
        "fairness_verdict": "fair",
        "group_name": "Caller-chosen result type",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Attributes without same-enclosing family involvement, map keys, and nested containers contribute no child parameter",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Attributes without same-enclosing family involvement, map keys, and nested containers contribute no child parameter."
          },
          {
            "affected_runs": [
              "rd78c5qv2a2pg93yqaaba2s4518ab62t"
            ],
            "classification": "EXPLICIT",
            "description": "Multiset children or unsupported nested shapes produced the wrong case signature.",
            "explanation_type": "subtle_but_fair",
            "reasoning": "rd78c5qv2a2pg93yqaaba2s4518ab62t compiled and passed baseline tests but failed `familyValuesInUnsupportedShapesContributeNoParameter` at ExhaustiveFold_382647_Test.java:874 with parameter count 1 instead of 2. The task explicitly distinguishes supported multiset attributes from unsupported map-key and nested-container family values, so the test is fair."
          }
        ],
        "fairness_reasoning": "Tests at lines 639, 750, and 874 enforce the explicit exclusion of non-family attributes, family values in map keys, and nested containers while preserving supported multiset attributes.",
        "fairness_verdict": "fair",
        "group_name": "Unsupported and non-family shapes",
        "pass_rate_across_rollouts": 0.2,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm"
          ]
        },
        "total_tests_in_group": 3
      },
      {
        "category": "new_behavior",
        "description": "Multimap value folding preserves keys, multiplicity, and order, including empty multimap cases",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Multimap value folding preserves keys, multiplicity, and order, including empty multimap cases."
          },
          {
            "affected_runs": [
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb"
            ],
            "classification": "EXPLICIT",
            "description": "Guava Multimap values were treated like Map entry sets rather than Multimap entries.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The compiler error `method entrySet()` on SignalNetFold.java appears in the logs for Multimap attributes. The description explicitly says multimap values contribute a multimap preserving per-key multiplicity and order, so generated code must use the repository's multimap shape rather than Map APIs."
          }
        ],
        "fairness_reasoning": "`multimapValuesFoldedPreservingMultiplicityAndOrder` at line 772 and `emptyMultimapAndMultisetDeliverEmptyResults` at line 799 correspond exactly to the multimap paragraph in the task description.",
        "fairness_verdict": "fair",
        "group_name": "Multimap behavior",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Arrays fold to lists in array order and multisets fold to result lists with multiplicity",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Arrays fold to lists in array order and multisets fold to result lists with multiplicity."
          }
        ],
        "fairness_reasoning": "Tests at lines 821 and 842 are explicit container-shape requirements from the description.",
        "fairness_verdict": "fair",
        "group_name": "Array and multiset behavior",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Nullable list, map, optional, multimap, multiset, and array containers produce null when absent and fold normally when present",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Nullable list, map, optional, multimap, multiset, and array containers produce null when absent and fold normally when present."
          }
        ],
        "fairness_reasoning": "Tests at lines 931, 956, and 969 exercise the explicit nullable-container rule across supported shapes and optional flavors.",
        "fairness_verdict": "fair",
        "group_name": "Nullable containers",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 3
      },
      {
        "category": "new_behavior",
        "description": "Generic implementations get cases, but generic family roots and single-implementation roots do not get fold methods",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Generic implementations get cases, but generic family roots and single-implementation roots do not get fold methods."
          },
          {
            "affected_runs": [
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn"
            ],
            "classification": "EXPLICIT",
            "description": "Case signatures for generic implementations leaked implementation type parameters into a non-generic fold interface method.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Both logs show MeterSpecFold.java cannot find symbol `class T`. The test `genericImplementationGetsACaseAndFolds` at ExhaustiveFold_382647_Test.java:1021 maps to the explicit requirement that a generic implementation belonging to an eligible non-generic family still gets a case."
          }
        ],
        "fairness_reasoning": "Tests at lines 1021 and 1044 follow the explicit requirement that generic roots get no fold method while generic implementations in eligible families still get cases.",
        "fairness_verdict": "fair",
        "group_name": "Generic family handling",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "A family attribute legally named value folds and compiles",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about A family attribute legally named value folds and compiles."
          },
          {
            "affected_runs": [
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn"
            ],
            "classification": "INFERRABLE",
            "description": "Generated case parameters collided with an attribute named `value`.",
            "explanation_type": "subtle_but_fair",
            "reasoning": "The logs show `variable value is already defined in method caseLatch(Latch,R,R)`, and the hidden test `attributeNamedValueFoldsAndCompiles` at ExhaustiveFold_382647_Test.java:1010 verifies a legal attribute named value. The description does not call out this exact name, but robust Java source generation must avoid collisions with user attribute names, so this is an inferable edge of the requested generated API."
          }
        ],
        "fairness_reasoning": "The task does not name this exact attribute, but generated Java source must remain valid for legal user attribute names. This is a reasonable robustness check, not an implementation-detail assertion.",
        "fairness_verdict": "fair",
        "group_name": "Attribute name collision",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "A same-named family type from another package does not count as same-enclosing family involvement",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about A same-named family type from another package does not count as same-enclosing family involvement."
          }
        ],
        "fairness_reasoning": "`foreignSameNameFamilyAttributeContributesNoParameter` at line 1164 is a fair check of the stated same-enclosing-type limitation.",
        "fairness_verdict": "fair",
        "group_name": "Foreign same-name families",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Passing a hand-written family instance outside the generated implementations throws IllegalArgumentException",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Passing a hand-written family instance outside the generated implementations throws IllegalArgumentException."
          }
        ],
        "fairness_reasoning": "`valueOutsideTheGeneratedImplementationsIsRejected` at line 1185 maps exactly to the explicit rejection requirement.",
        "fairness_verdict": "fair",
        "group_name": "Unknown implementation rejection",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Families outside @Value.Enclosing, families with too few implementations, and generic root families receive no generated fold entry",
        "failure_modes": [
          {
            "affected_runs": [
              "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
              "rd721jrh2s4wd10qbpx853550s8ab4kb",
              "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
              "rd7abractay6m3zp13yb9qmk5s8aab4w",
              "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
              "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
              "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
            ],
            "classification": "EXPLICIT",
            "description": "Generated annotation-processor output did not compile or the processor crashed before the hidden fixture could run.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Seven rollouts fail before JUnit reaches the focused assertions. The exact errors differ: a processor ClassCastException in rd71xgn2d0c5rec4v6tfax9yvs8aad6a; duplicate parameter name `value` in rd721jrh2s4wd10qbpx853550s8ab4kb; leaked generic type variable `T` in rd77pv2y1ry7754p2zjqe3x32n8aav5h; SortedSet-as-scalar and Multimap entrySet() mistakes in rd7abractay6m3zp13yb9qmk5s8aab4w, rd7bq6jaay4xadsakq0cx1bscd8aahsb, and rd7dzza8kgzwrmgtrv3j92ntds8ab87v; and combined generic/signature collision errors in rd7dh9xqfg2p4e0dddq61nsrkd8aahtn. These are implementation bugs in a difficult code generator, not hidden-test assumptions about Families outside @Value.Enclosing, families with too few implementations, and generic root families receive no generated fold entry."
          }
        ],
        "fairness_reasoning": "The assertions in `allCasesAbstractEntriesDefaultAndIneligibleShapesAbsent` and `singleImplementationGenericRootsAndTheirImplementationsReceiveNothing` cover explicit negative-generation rules. They use reflection on public generated types rather than private processor internals.",
        "fairness_verdict": "fair",
        "group_name": "Enclosing and implementation eligibility",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
            "rd721jrh2s4wd10qbpx853550s8ab4kb",
            "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
            "rd7abractay6m3zp13yb9qmk5s8aab4w",
            "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
            "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
            "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
          ],
          "passed": [
            "rd7102q1xc7tmfztena3vtttpn8abqny",
            "rd76mmjvw0854cht1qe30hsgt18aaatm",
            "rd78c5qv2a2pg93yqaaba2s4518ab62t"
          ]
        },
        "total_tests_in_group": 2
      }
    ],
    "failure_patterns": [
      {
        "affected_runs": [
          "rd71xgn2d0c5rec4v6tfax9yvs8aad6a",
          "rd721jrh2s4wd10qbpx853550s8ab4kb",
          "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
          "rd7abractay6m3zp13yb9qmk5s8aab4w",
          "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
          "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn",
          "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
        ],
        "affected_test_groups": [
          "Existing value-fixture baseline suite",
          "Fold companion API surface",
          "Basic direct folding",
          "Set and sorted set containers",
          "Generic family handling"
        ],
        "description": "Generated code or processor integration fails Java compilation before hidden tests execute",
        "explanation_type": "genuinely_hard",
        "hint_candidate": false,
        "reasoning": "Seven runs fail with real compiler or processor errors: ClassCastException, duplicate parameter `value`, undeclared generic `T`, SortedSet conversion, and Multimap entrySet() mistakes. These are valid agent failures for a generated-source feature, not a test harness problem."
      },
      {
        "affected_runs": [
          "rd78c5qv2a2pg93yqaaba2s4518ab62t",
          "rd7abractay6m3zp13yb9qmk5s8aab4w",
          "rd7bq6jaay4xadsakq0cx1bscd8aahsb",
          "rd7dzza8kgzwrmgtrv3j92ntds8ab87v"
        ],
        "affected_test_groups": [
          "Set and sorted set containers",
          "Unsupported and non-family shapes",
          "Multimap behavior",
          "Array and multiset behavior"
        ],
        "description": "Agents mishandle explicit container shapes, especially SortedSet, Multimap, and Multiset",
        "explanation_type": "subtle_but_fair",
        "hint_candidate": false,
        "reasoning": "The problem explicitly lists list, set, multiset, array, map, and multimap behavior. The failures show incomplete shape analysis rather than hidden expectations: rd78 misses sorted-set/multiset signatures, rd7abr and rd7bq treat SortedSet as a scalar, and rd7dzza uses Map entrySet() on Multimap."
      },
      {
        "affected_runs": [
          "rd77pv2y1ry7754p2zjqe3x32n8aav5h",
          "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn"
        ],
        "affected_test_groups": [
          "Generic family handling",
          "Fold companion API surface"
        ],
        "description": "Generic implementation cases are emitted with invalid type variables",
        "explanation_type": "genuinely_hard",
        "hint_candidate": false,
        "reasoning": "Both runs generate MeterSpecFold methods that reference undeclared `T`. The description explicitly says generic family roots get no fold method, but generic implementations in eligible families still get a case, making this a fair hard requirement."
      },
      {
        "affected_runs": [
          "rd721jrh2s4wd10qbpx853550s8ab4kb",
          "rd7dh9xqfg2p4e0dddq61nsrkd8aahtn"
        ],
        "affected_test_groups": [
          "Attribute name collision"
        ],
        "description": "Generated parameter names collide with user attributes named `value`",
        "explanation_type": "subtle_but_fair",
        "hint_candidate": false,
        "reasoning": "The compile error is a normal source-generation robustness issue. The exact attribute name is not in the prompt, but arbitrary legal attribute names are part of the public input space for an annotation processor, so the test is subtle but fair."
      }
    ],
    "top_runs": [
      {
        "is_true_positive": true,
        "reasoning": "Passed both baseline and all 47 hidden exhaustive-fold tests. The evaluator classified it as a legitimate processor implementation rather than test-gaming.",
        "run_id": "rd76mmjvw0854cht1qe30hsgt18aaatm",
        "true_positive_reasoning": "It generates the fold companion through the annotation processor and survives baseline compilation, container-shape tests, dispatch tests, generics, and memoization checks. This would pass code review at the behavioral level.",
        "verdict": "pass"
      },
      {
        "is_true_positive": true,
        "reasoning": "Also passed baseline and hidden tests with evaluator confirmation of a legitimate generator implementation.",
        "run_id": "rd7102q1xc7tmfztena3vtttpn8abqny",
        "true_positive_reasoning": "The solution implements ordinary processor metadata and generator support and is not merely special-casing the hidden fixture.",
        "verdict": "pass"
      }
    ]
  },
  "extra_fields": {
    "confidence": 0.9,
    "hint_suggestions": [],
    "pass_rate": 0.2,
    "total_runs": 10,
    "verdict_reasoning": "PASS: 20% pass rate across 10 completed runs, at least one true positive, broad tests matching the stated requirements, and observed failures attributable to substantive implementation bugs rather than ambiguity or brittle tests."
  },
  "submission_readiness": {
    "can_submit": true,
    "is_bypassed": false,
    "criteria": [
      {
        "detail": "5/5 passing",
        "id": "prechecks",
        "label": "Prechecks",
        "stale": false,
        "status": "pass"
      },
      {
        "detail": "7/7 passing",
        "id": "dynamicChecks",
        "label": "Quality Checks",
        "stale": false,
        "status": "pass"
      },
      {
        "detail": "No fairness issues",
        "id": "agentFair",
        "label": "Fair task",
        "status": "pass"
      },
      {
        "detail": "2/10 solved",
        "id": "agentSolvable",
        "label": "Solvable",
        "status": "pass"
      },
      {
        "detail": "20% — Hard",
        "id": "agentDifficulty",
        "label": "Difficulty",
        "status": "pass"
      },
      {
        "detail": "Median files: 7, messages: 200, LOC: 691.5",
        "id": "agentLongHorizon",
        "label": "Long-horizon",
        "status": "pass"
      },
      {
        "detail": "No cheating detected",
        "id": "agentNoCheating",
        "label": "No cheating",
        "status": "pass"
      },
      {
        "detail": "No environment blockers detected",
        "id": "agentNoEnvBlocker",
        "label": "No environment blockers",
        "status": "pass"
      },
      {
        "detail": "No false positives detected",
        "id": "agentNoFalsePositives",
        "label": "No false positives",
        "status": "pass"
      },
      {
        "detail": "PASS",
        "id": "holisticReview",
        "label": "Holistic AI Review",
        "status": "pass"
      },
      {
        "detail": "image rebuilds hermetically",
        "id": "rebuildSafe",
        "label": "Rebuild-safe",
        "status": "pass"
      },
      {
        "detail": "image deep-rebuilds from clean source + vendored deps",
        "id": "harborSafe",
        "label": "Harbor rebuild-safe",
        "status": "pass"
      }
    ]
  }
}
```

</details>
