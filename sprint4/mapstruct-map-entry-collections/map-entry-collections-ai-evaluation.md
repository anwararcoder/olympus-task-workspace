# ✅ AI Evaluation Report

> Automated review of problem quality, fairness, and agent failure patterns

## Metadata

- **Verdict:** `PASS`
- **Completed:** 2026-07-21 04:17:49
- **Created:** 2026-07-21 04:09:17
- **Step:** Completed
- **Job ID:** `nx7666xnpr5q0dysyj88cgycw18aytd2`

## Summary Statistics

- **Pass Rate:** 20% (10 runs)
- **Confidence:** 0.96
- **Reasoning:** PASS: 2/10 legitimate full passes, all baseline tests pass in every rollout, and every failure traces to an explicit or reasonably inferable requirement. Tests are deterministic and behavioral, the stream boundary is subtle but fair, and no hint is needed.

## Reviewer Notes

Ship this problem. Two of ten rollouts pass the complete 3,641-test baseline and all 32 hidden feature variants, giving a healthy 20% rollout pass rate for an Olympus task. The passing patches are substantive, independent implementations rather than verifier gaming, and the reference solution is focused and consistent with MapStruct’s container-mapping architecture.

The dominant failure is informative and fair: six agents changed method validation too broadly and allowed Map-to-Stream and Stream-to-Map, so preservesStreamMappingFamilyBoundaries()[1-2] compiled when it should have emitted the established diagnostics. The prompt limits the feature to iterable or array types, and Stream is modeled separately. One additional run omitted forged Map/List bean-property mappings, and one mishandled the explicitly requested lower-bounded result when the selected method returned Map.Entry<String,String>.

The only test-quality caveat is diagnostic granularity: MapEntryCollectionsC4e2Test places many mappers in one class-level @WithClasses fixture, so one compilation defect fans out into 30 failed invocations. That amplifies counts but does not create an unfair expectation; JUnit identifies the actual broken mapper. The stale autoReview blocker in review_context.json concerns an unrelated immutable @MappingTarget problem and should be ignored as context contamination.

## Checklist (26/26 passed)

### Problem

- ✅ **Requirements complete and self-contained**
  - The description states both directions, order, selection/conversions/qualifiers, abstract Entry key/value mapping, and the difficult lower-bound case. Repository conventions supply normal integration ...
- ✅ **No ambiguities, fully deterministic**
  - The core semantics have one clear interpretation. Stream exclusion follows from the explicit iterable-or-array scope and the separate stream family.
- ✅ **Concise and not prescriptive**
  - Two short paragraphs describe observable behavior without naming processor classes, templates, or algorithms.
- ✅ **Matches real-world repo scope**
  - This is a realistic annotation-processor feature spanning type modeling, selection, forging, code generation, tests, and documentation.
- ✅ **Aligns with repo design philosophy**
  - The solution extends existing iterable/map families and preserves their null, update, container, and stream-boundary conventions.
- ✅ **No irrelevant context**
  - Every sentence defines required behavior or compatibility.
- ✅ **Clear writing and formatting**
  - The two-paragraph description is compact and technically precise; the independent description-quality check passed.
- ✅ **Solution meets all requirements**
  - The reference passes 3,641 baseline and 32 new tests and explicitly handles each described behavior.
- ✅ **No plagiarism**
  - No artifact shows copied issue, PR, tutorial, or external solution text. The stale autoReview blocker concerns an unrelated immutable @MappingTarget task and is context contamination.
- ✅ **Problem is real engineering, not a contrived puzzle**
  - The task adds a coherent mapping family to a mature processor and requires long-horizon compiler-model and generation work.

### Tests

- ✅ **New tests highlight missing or incorrect behavior**
  - The clean repository fails all 32 new variants, while the reference and two agent implementations pass all 32.
- ✅ **Tests are deterministic**
  - Tests use fixed data, LinkedHashMap ordering, compiler diagnostics, and no timing or randomness; environment and flakiness checks passed.
- ✅ **Assertions verify the correct output**
  - Assertions check exact keys, values, order, subtype, null behavior, update replacement, qualifiers, conversions, and rejection.
- ✅ **Tests validate behavior, not internals**
  - Tests call generated mapper APIs and inspect output; the boundary test checks public annotation-processing diagnostics in established style.
- ✅ **Tests follow repo structure**
  - They use ProcessorTest, WithClasses, ExpectedCompilationOutcome, AssertJ, standard packages, and dual compiler execution.
- ✅ **Tests cover required behavior and edge cases**
  - Coverage includes both directions, arrays, order, entry construction, qualifiers, conversions, nulls, properties, subtypes, inheritance, targets, bounds, names, and streams.
- ✅ **Test suite is concise**
  - Sixteen logical methods cover distinct integration points under two compilers. Shared fixture fanout reduces localization but is not redundant behavior coverage.
- ✅ **Tests do not check unspecified behavior**
  - Core cases are explicit; null/update/subtype/property/inheritance/collision checks enforce established behavior of a new container family and are inferable.
- ✅ **No unreasonable assumptions in tests**
  - Two passing independent architectures demonstrate flexibility; failures map to concrete omissions or over-broad validation, not hidden implementation choices.
- ✅ **No trivial or unfair failure patterns**
  - All agents ran tests and passed baseline; failures concern property forging, generic lower bounds, or stream family classification, not build/path trivia.

### Solution

- ✅ **No regressions, code follows patterns**
  - The reference reuses existing builders, models, type factory, templates, diagnostics, and documentation conventions; baseline verification passes.
- ✅ **No unexplained defensive code**
  - Added branches correspond directly to Entry construction, cross-container classification, property forging, generic typing, and stream boundaries.
- ✅ **No irrelevant changes**
  - All reference files are processor implementation, templates, or collection documentation required for the feature.
- ✅ **API contracts remain stable**
  - The patch adds supported mapper signatures and internal capabilities without removing public APIs or changing unrelated behavior.
- ✅ **No AI slop**
  - The reference is focused, idiomatic, minimally commented, and structurally consistent with nearby code; solution-quality checks passed.

### Other

- ✅ **Hint is appropriate if present**
  - No hint is present. With two legitimate passes and no trivial zero-pass obstacle, none is needed.

## Test Group Analysis

### ✅ Baseline regression suite

- **Tests:** 3641 | **Pass Rate:** 100% | **Runs:** 10 passed, 0 failed | **Fairness:** fair
- Runs the repository's existing processor tests with the hidden feature tests excluded.

### ⚠️ Map entries to iterable elements

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests mapsEachMapEntryToAnIterableElement()[1-2]: each Map.Entry is the element source and LinkedHashMap order is preserved.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Iterable elements to map entries

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests mapsEachIterableElementThroughAMapEntry()[1-2]: each element maps to Map.Entry and its key/value are inserted.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Abstract Map.Entry bean mapping

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests mapsAnOrdinaryObjectToAnEntry()[1-2]: an abstract method constructs Map.Entry through logical key and value properties.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Default null mapping behavior

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests returnsNullForNullSourcesByDefault()[1-2] in both cross-container directions and direct entry mapping.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ RETURN_DEFAULT null containers

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests returnsEmptyContainersForNullSourcesWhenConfigured()[1-2] for both directions.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Forged bean-property mappings

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests mapsMapAndIterableBeanProperties()[1-2]: Map/List conversions are forged for nested properties in both directions.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The implementation classified direct methods but did not forge Map-to-iterable and iterable-to-Map mappings for bean properties.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Concrete map and iterable subtypes

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests supportsConcreteMapAndIterableSubtypes()[1-2], constructing declared ScheduleMap and FlattenedScheduleList results.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Entry key conversions

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests appliesExistingConversionsToEntryKeys()[1-2], applying built-in Integer/String conversions in both directions.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Iterable mapping qualifiers

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests selectsEntryMappingMethodsWithIterableQualifiers()[1-2], choosing named entry-element methods in both directions.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Inherited cross-container methods

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests supportsInheritedCrossContainerMappingMethods()[1-2], recognizing methods inherited from a mapper superinterface.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Mapping-target replacement

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests replacesExistingEntriesInMappingTargets()[1-2], clearing and replacing existing list/map contents.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Map entries to arrays

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests mapsMapEntriesToArrayElementsInIterationOrder()[1-2], including allocation, element mapping, and source order.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Arrays to maps

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests mapsArrayElementsThroughMapEntries()[1-2], mapping each array element to an entry and inserting it.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ⚠️ Lower-bounded map results

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests usesConcreteSelectedEntryTypesForLowerBoundedMapResults()[1-2] with Map<? super String,? super String> and Map.Entry<String,String>.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > An unrelated bean-property forge omission prevented the shared fixture from compiling.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > Generated code typed the temporary entry through wildcard-captured map element types, producing Object values for put().

### ⚠️ Generated local-name collisions

- **Tests:** 2 | **Pass Rate:** 80% | **Runs:** 8 passed, 2 failed | **Fairness:** fair
- Tests avoidsEntryLocalCollisionsWithContextParameters()[1-2], ensuring the temporary entry variable does not collide with @Context.

  **Failure Mode** (genuinely_hard, INFERRABLE, 1 runs):
  > The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.
  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.

### ❌ Stream mapping family boundary

- **Tests:** 2 | **Pass Rate:** 40% | **Runs:** 4 passed, 6 failed | **Fairness:** fair
- Tests preservesStreamMappingFamilyBoundaries()[1-2]: Map-to-Stream and Stream-to-Map remain rejected while Map/List crossings are admitted.

  **Failure Mode** (subtle_but_fair, INFERRABLE, 6 runs):
  > Agents broadly exempted mappings involving Map from existing iterable/non-iterable validation, allowing Map-to-Stream and Stream-to-Map.

## Failure Patterns

### Pattern 1: Over-broad Map exemptions admitted Map-to-Stream and Stream-to-Map methods.

- **Type:** subtle_but_fair | **Affected Runs:** 6 | **Hint Candidate:** No
- **Affected Test Groups:** Stream mapping family boundary
- **Analysis:** Six agents changed MethodRetrievalProcessor using a condition equivalent to 'either side is a Map' instead of requiring the opposite side to be iterable/array. The task scope and existing stream family make the correct restriction inferable. This is subtle but meaningful type-family reasoning.

### Pattern 2: One compile defect in the class-level @WithClasses fixture fanned out to all 30 C4e2 invocations.

- **Type:** genuinely_hard | **Affected Runs:** 2 | **Hint Candidate:** No
- **Affected Test Groups:** Map entries to iterable elements, Iterable elements to map entries, Abstract Map.Entry bean mapping, Default null mapping behavior, RETURN_DEFAULT null containers, Forged bean-property mappings, Concrete map and iterable subtypes, Entry key conversions, Iterable mapping qualifiers, Inherited cross-container methods, Mapping-target replacement, Map entries to arrays, Arrays to maps, Lower-bounded map results, Generated local-name collisions
- **Analysis:** One run omitted forged bean-property mappings and one mishandled lower-bounded entry types. The shared mapper set makes each defect appear as 30 failures. This weakens localization but does not create false blame because both root defects violate requested or inferable behavior and JUnit identifies the broken mapper.

## Top Passing Runs

### Run 1 (PASS) ✅

**Strategy:** Passed all 3,641 baseline and 32 new tests with coordinated changes to type modeling, classification, entry construction, property forging, mapping models, and templates. Added independent tests and did not game the verifier.

**True Positive Analysis:** Patch and evaluator evidence show broad support for arrays, qualifiers, conversions, targets, inherited/property mappings, abstract Entry construction, lower bounds, and stream boundaries. The implementation is not fixture-specific.

### Run 2 (PASS) ✅

**Strategy:** Passed every baseline and feature test with a distinct compact architecture reusing ContainerMappingMethodBuilder and IterableMappingMethod while preserving validation boundaries.

**True Positive Analysis:** Patch inspection confirms correct Entry typing, entrySet iteration, reverse put generation, abstract Entry construction, property forging, and narrowly scoped Map/iterable validation. No test suppression or hardcoding appears.

## Submission Readiness ✅

**Can Submit:** Yes

| Criterion | Status | Detail |
|-----------|--------|--------|
| ✅ Prechecks | pass | 5/5 passing |
| ✅ Scope Gate | pass |  |
| ✅ Quality Checks | pass | 7/7 passing |
| ✅ Fair task | pass | No fairness issues |
| ✅ Solvable | pass | 2/10 solved |
| ✅ Difficulty | pass | 20% — Hard |
| ✅ Long-horizon | pass | Median files: 14, messages: 125.5, LOC: 428 |
| ✅ No cheating | pass | No cheating detected |
| ✅ No environment blockers | pass | No environment blockers detected |
| ❌ No false positives | warn | Passed with caveats |
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
    "completedAt": 1784596669232,
    "createdAt": 1784596157594,
    "currentStep": "Completed",
    "jobId": "nx7666xnpr5q0dysyj88cgycw18aytd2"
  },
  "verdict": "PASS",
  "reviewer_notes": "Ship this problem. Two of ten rollouts pass the complete 3,641-test baseline and all 32 hidden feature variants, giving a healthy 20% rollout pass rate for an Olympus task. The passing patches are substantive, independent implementations rather than verifier gaming, and the reference solution is focused and consistent with MapStruct’s container-mapping architecture.\n\nThe dominant failure is informative and fair: six agents changed method validation too broadly and allowed Map-to-Stream and Stream-to-Map, so preservesStreamMappingFamilyBoundaries()[1-2] compiled when it should have emitted the established diagnostics. The prompt limits the feature to iterable or array types, and Stream is modeled separately. One additional run omitted forged Map/List bean-property mappings, and one mishandled the explicitly requested lower-bounded result when the selected method returned Map.Entry<String,String>.\n\nThe only test-quality caveat is diagnostic granularity: MapEntryCollectionsC4e2Test places many mappers in one class-level @WithClasses fixture, so one compilation defect fans out into 30 failed invocations. That amplifies counts but does not create an unfair expectation; JUnit identifies the actual broken mapper. The stale autoReview blocker in review_context.json concerns an unrelated immutable @MappingTarget problem and should be ignored as context contamination.",
  "checklist": {
    "total": 26,
    "pass_count": 26,
    "fail_count": 0,
    "items": [
      {
        "item": "Requirements complete and self-contained",
        "reasoning": "The description states both directions, order, selection/conversions/qualifiers, abstract Entry key/value mapping, and the difficult lower-bound case. Repository conventions supply normal integration behavior.",
        "verdict": "pass"
      },
      {
        "item": "No ambiguities, fully deterministic",
        "reasoning": "The core semantics have one clear interpretation. Stream exclusion follows from the explicit iterable-or-array scope and the separate stream family.",
        "verdict": "pass"
      },
      {
        "item": "Concise and not prescriptive",
        "reasoning": "Two short paragraphs describe observable behavior without naming processor classes, templates, or algorithms.",
        "verdict": "pass"
      },
      {
        "item": "Matches real-world repo scope",
        "reasoning": "This is a realistic annotation-processor feature spanning type modeling, selection, forging, code generation, tests, and documentation.",
        "verdict": "pass"
      },
      {
        "item": "Aligns with repo design philosophy",
        "reasoning": "The solution extends existing iterable/map families and preserves their null, update, container, and stream-boundary conventions.",
        "verdict": "pass"
      },
      {
        "item": "No irrelevant context",
        "reasoning": "Every sentence defines required behavior or compatibility.",
        "verdict": "pass"
      },
      {
        "item": "Clear writing and formatting",
        "reasoning": "The two-paragraph description is compact and technically precise; the independent description-quality check passed.",
        "verdict": "pass"
      },
      {
        "item": "New tests highlight missing or incorrect behavior",
        "reasoning": "The clean repository fails all 32 new variants, while the reference and two agent implementations pass all 32.",
        "verdict": "pass"
      },
      {
        "item": "Tests are deterministic",
        "reasoning": "Tests use fixed data, LinkedHashMap ordering, compiler diagnostics, and no timing or randomness; environment and flakiness checks passed.",
        "verdict": "pass"
      },
      {
        "item": "Assertions verify the correct output",
        "reasoning": "Assertions check exact keys, values, order, subtype, null behavior, update replacement, qualifiers, conversions, and rejection.",
        "verdict": "pass"
      },
      {
        "item": "Tests validate behavior, not internals",
        "reasoning": "Tests call generated mapper APIs and inspect output; the boundary test checks public annotation-processing diagnostics in established style.",
        "verdict": "pass"
      },
      {
        "item": "Tests follow repo structure",
        "reasoning": "They use ProcessorTest, WithClasses, ExpectedCompilationOutcome, AssertJ, standard packages, and dual compiler execution.",
        "verdict": "pass"
      },
      {
        "item": "Tests cover required behavior and edge cases",
        "reasoning": "Coverage includes both directions, arrays, order, entry construction, qualifiers, conversions, nulls, properties, subtypes, inheritance, targets, bounds, names, and streams.",
        "verdict": "pass"
      },
      {
        "item": "Test suite is concise",
        "reasoning": "Sixteen logical methods cover distinct integration points under two compilers. Shared fixture fanout reduces localization but is not redundant behavior coverage.",
        "verdict": "pass"
      },
      {
        "item": "Tests do not check unspecified behavior",
        "reasoning": "Core cases are explicit; null/update/subtype/property/inheritance/collision checks enforce established behavior of a new container family and are inferable.",
        "verdict": "pass"
      },
      {
        "item": "Solution meets all requirements",
        "reasoning": "The reference passes 3,641 baseline and 32 new tests and explicitly handles each described behavior.",
        "verdict": "pass"
      },
      {
        "item": "No regressions, code follows patterns",
        "reasoning": "The reference reuses existing builders, models, type factory, templates, diagnostics, and documentation conventions; baseline verification passes.",
        "verdict": "pass"
      },
      {
        "item": "No unexplained defensive code",
        "reasoning": "Added branches correspond directly to Entry construction, cross-container classification, property forging, generic typing, and stream boundaries.",
        "verdict": "pass"
      },
      {
        "item": "No irrelevant changes",
        "reasoning": "All reference files are processor implementation, templates, or collection documentation required for the feature.",
        "verdict": "pass"
      },
      {
        "item": "API contracts remain stable",
        "reasoning": "The patch adds supported mapper signatures and internal capabilities without removing public APIs or changing unrelated behavior.",
        "verdict": "pass"
      },
      {
        "item": "No AI slop",
        "reasoning": "The reference is focused, idiomatic, minimally commented, and structurally consistent with nearby code; solution-quality checks passed.",
        "verdict": "pass"
      },
      {
        "item": "No plagiarism",
        "reasoning": "No artifact shows copied issue, PR, tutorial, or external solution text. The stale autoReview blocker concerns an unrelated immutable @MappingTarget task and is context contamination.",
        "verdict": "pass"
      },
      {
        "item": "No unreasonable assumptions in tests",
        "reasoning": "Two passing independent architectures demonstrate flexibility; failures map to concrete omissions or over-broad validation, not hidden implementation choices.",
        "verdict": "pass"
      },
      {
        "item": "No trivial or unfair failure patterns",
        "reasoning": "All agents ran tests and passed baseline; failures concern property forging, generic lower bounds, or stream family classification, not build/path trivia.",
        "verdict": "pass"
      },
      {
        "item": "Hint is appropriate if present",
        "reasoning": "No hint is present. With two legitimate passes and no trivial zero-pass obstacle, none is needed.",
        "verdict": "pass"
      },
      {
        "item": "Problem is real engineering, not a contrived puzzle",
        "reasoning": "The task adds a coherent mapping family to a mature processor and requires long-horizon compiler-model and generation work.",
        "verdict": "pass"
      }
    ]
  },
  "detailed_analysis": {
    "test_groups": [
      {
        "category": "baseline",
        "description": "Runs the repository's existing processor tests with the hidden feature tests excluded.",
        "failure_modes": [],
        "fairness_reasoning": "All ten rollouts passed all 3,641 baseline tests, showing the environment is sound and the feature can be implemented without unrelated regressions.",
        "fairness_verdict": "fair",
        "group_name": "Baseline regression suite",
        "pass_rate_across_rollouts": 1,
        "rollout_results": {
          "failed": [],
          "passed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 3641
      },
      {
        "category": "new_behavior",
        "description": "Tests mapsEachMapEntryToAnIterableElement()[1-2]: each Map.Entry is the element source and LinkedHashMap order is preserved.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "This directly matches the first sentence of the task, including iteration order.",
        "fairness_verdict": "fair",
        "group_name": "Map entries to iterable elements",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests mapsEachIterableElementThroughAMapEntry()[1-2]: each element maps to Map.Entry and its key/value are inserted.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "This directly restates the reverse-direction requirement and checks only observable map contents.",
        "fairness_verdict": "fair",
        "group_name": "Iterable elements to map entries",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests mapsAnOrdinaryObjectToAnEntry()[1-2]: an abstract method constructs Map.Entry through logical key and value properties.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "The task explicitly names abstract Map.Entry targets and logical key/value properties.",
        "fairness_verdict": "fair",
        "group_name": "Abstract Map.Entry bean mapping",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests returnsNullForNullSourcesByDefault()[1-2] in both cross-container directions and direct entry mapping.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "Following the existing default null strategy is normal compatibility behavior, not a new undocumented policy.",
        "fairness_verdict": "fair",
        "group_name": "Default null mapping behavior",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests returnsEmptyContainersForNullSourcesWhenConfigured()[1-2] for both directions.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "Entry mappings are required to participate in normal mapping behavior; honoring NullValueMappingStrategy is established MapStruct behavior.",
        "fairness_verdict": "fair",
        "group_name": "RETURN_DEFAULT null containers",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests mapsMapAndIterableBeanProperties()[1-2]: Map/List conversions are forged for nested properties in both directions.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The implementation classified direct methods but did not forge Map-to-iterable and iterable-to-Map mappings for bean properties.",
            "explanation_type": "genuinely_hard",
            "reasoning": "ScheduleBookMapper reported that Map<String,Schedule> could not map to List<FlattenedSchedule> and vice versa. Property forging is INFERRABLE from existing MapStruct collection/map property behavior and the unrestricted feature wording."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "Property forging is a standard integration path for every existing container mapping family and is reasonably inferable from the repository.",
        "fairness_verdict": "fair",
        "group_name": "Forged bean-property mappings",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests supportsConcreteMapAndIterableSubtypes()[1-2], constructing declared ScheduleMap and FlattenedScheduleList results.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "Using declared concrete result subtypes follows existing iterable/map container selection rules.",
        "fairness_verdict": "fair",
        "group_name": "Concrete map and iterable subtypes",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests appliesExistingConversionsToEntryKeys()[1-2], applying built-in Integer/String conversions in both directions.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "The description explicitly states that entry mappings participate in conversions.",
        "fairness_verdict": "fair",
        "group_name": "Entry key conversions",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests selectsEntryMappingMethodsWithIterableQualifiers()[1-2], choosing named entry-element methods in both directions.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "Iterable mapping qualifiers are explicitly required and the test distinguishes selected from non-selected methods behaviorally.",
        "fairness_verdict": "fair",
        "group_name": "Iterable mapping qualifiers",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests supportsInheritedCrossContainerMappingMethods()[1-2], recognizing methods inherited from a mapper superinterface.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "Inheritance is a core existing mapper capability; a new mapping family should classify inherited declarations consistently.",
        "fairness_verdict": "fair",
        "group_name": "Inherited cross-container methods",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests replacesExistingEntriesInMappingTargets()[1-2], clearing and replacing existing list/map contents.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "Clearing existing targets is established iterable/map update-template behavior and the test checks only final contents.",
        "fairness_verdict": "fair",
        "group_name": "Mapping-target replacement",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests mapsMapEntriesToArrayElementsInIterationOrder()[1-2], including allocation, element mapping, and source order.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "Arrays and map iteration order are explicit in the task; LinkedHashMap makes the assertion deterministic.",
        "fairness_verdict": "fair",
        "group_name": "Map entries to arrays",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests mapsArrayElementsThroughMapEntries()[1-2], mapping each array element to an entry and inserting it.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "The reverse direction explicitly includes array sources.",
        "fairness_verdict": "fair",
        "group_name": "Arrays to maps",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests usesConcreteSelectedEntryTypesForLowerBoundedMapResults()[1-2] with Map<? super String,? super String> and Map.Entry<String,String>.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "An unrelated bean-property forge omission prevented the shared fixture from compiling.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run did not reach the lower-bound assertion because ScheduleBookMapper failed first. Its root omission is INFERRABLE from repository conventions."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "Generated code typed the temporary entry through wildcard-captured map element types, producing Object values for put().",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl.java:25 failed with Object cannot be converted to capture#1 of ? super String. The prompt explicitly requires lower-bounded map results to use the concrete selected entry type. This is a legitimate, technically difficult miss."
          }
        ],
        "fairness_reasoning": "The exact generic scenario is stated in the final sentence and the test checks one observable entry.",
        "fairness_verdict": "fair",
        "group_name": "Lower-bounded map results",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Tests avoidsEntryLocalCollisionsWithContextParameters()[1-2], ensuring the temporary entry variable does not collide with @Context.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd709x34y17n4t7ab9cyxh5xf58aztqh"
            ],
            "classification": "INFERRABLE",
            "description": "The shared mapper fixture did not compile because automatic Map/List bean-property mappings were not forged.",
            "explanation_type": "genuinely_hard",
            "reasoning": "This run implemented direct top-level mappings but omitted PropertyMapping integration. ScheduleBookMapper diagnostics prevented every test using the class-level @WithClasses fixture from executing. The omitted integration is INFERRABLE from existing container mapping architecture."
          },
          {
            "affected_runs": [
              "rd77vdqnjhfkmg52yg102y36kd8azdsg"
            ],
            "classification": "EXPLICIT",
            "description": "The shared mapper fixture did not compile because lower-bounded result entry types were reduced to wildcard-captured Object types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "EntryBoundaryMapper517e60Impl failed with Object not convertible to capture of ? super String. This is collateral failure from an EXPLICIT lower-bound requirement, not a defect in this group’s behavior."
          }
        ],
        "fairness_reasoning": "This checks generated-code validity, not a specific identifier. Existing model builders reserve parameter names, making collision avoidance inferable.",
        "fairness_verdict": "fair",
        "group_name": "Generated local-name collisions",
        "pass_rate_across_rollouts": 0.8,
        "rollout_results": {
          "failed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg"
          ],
          "passed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7ehg5245sj914bbfkgbh87b58az3dy",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "regression",
        "description": "Tests preservesStreamMappingFamilyBoundaries()[1-2]: Map-to-Stream and Stream-to-Map remain rejected while Map/List crossings are admitted.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
              "rd776w3snw4a95mb6hq131bkz98az3ft",
              "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
              "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
              "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
              "rd7emas1b3gtrhejemg57aptv98az234"
            ],
            "classification": "INFERRABLE",
            "description": "Agents broadly exempted mappings involving Map from existing iterable/non-iterable validation, allowing Map-to-Stream and Stream-to-Map.",
            "explanation_type": "subtle_but_fair",
            "reasoning": "Compilation succeeded where two established diagnostics were expected. The task limits the new family to iterable or array types; Stream is neither and is modeled separately in the visible processor. This is a common but substantive over-broad condition."
          }
        ],
        "fairness_reasoning": "The negative boundary follows from the explicit iterable-or-array scope and existing stream-specific rules. Exact diagnostics and lines follow repository compilation-test conventions. Two independent agents handled the boundary correctly, so no hint is necessary.",
        "fairness_verdict": "fair",
        "group_name": "Stream mapping family boundary",
        "pass_rate_across_rollouts": 0.4,
        "rollout_results": {
          "failed": [
            "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
            "rd776w3snw4a95mb6hq131bkz98az3ft",
            "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
            "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
            "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
            "rd7emas1b3gtrhejemg57aptv98az234"
          ],
          "passed": [
            "rd709x34y17n4t7ab9cyxh5xf58aztqh",
            "rd77vdqnjhfkmg52yg102y36kd8azdsg",
            "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
            "rd7ehg5245sj914bbfkgbh87b58az3dy"
          ]
        },
        "total_tests_in_group": 2
      }
    ],
    "failure_patterns": [
      {
        "affected_runs": [
          "rd74b8qbt4tyh7afsyjtdbacjs8ays87",
          "rd776w3snw4a95mb6hq131bkz98az3ft",
          "rd79znpaxv1nnqbfd1d84ds0pn8azxpe",
          "rd7d9b8n3khmc51dk0acevpm9s8aybw1",
          "rd7e0kwhb5yg9fpf9x4jm6zrj18az74c",
          "rd7emas1b3gtrhejemg57aptv98az234"
        ],
        "affected_test_groups": [
          "Stream mapping family boundary"
        ],
        "description": "Over-broad Map exemptions admitted Map-to-Stream and Stream-to-Map methods.",
        "explanation_type": "subtle_but_fair",
        "hint_candidate": false,
        "reasoning": "Six agents changed MethodRetrievalProcessor using a condition equivalent to 'either side is a Map' instead of requiring the opposite side to be iterable/array. The task scope and existing stream family make the correct restriction inferable. This is subtle but meaningful type-family reasoning."
      },
      {
        "affected_runs": [
          "rd709x34y17n4t7ab9cyxh5xf58aztqh",
          "rd77vdqnjhfkmg52yg102y36kd8azdsg"
        ],
        "affected_test_groups": [
          "Map entries to iterable elements",
          "Iterable elements to map entries",
          "Abstract Map.Entry bean mapping",
          "Default null mapping behavior",
          "RETURN_DEFAULT null containers",
          "Forged bean-property mappings",
          "Concrete map and iterable subtypes",
          "Entry key conversions",
          "Iterable mapping qualifiers",
          "Inherited cross-container methods",
          "Mapping-target replacement",
          "Map entries to arrays",
          "Arrays to maps",
          "Lower-bounded map results",
          "Generated local-name collisions"
        ],
        "description": "One compile defect in the class-level @WithClasses fixture fanned out to all 30 C4e2 invocations.",
        "explanation_type": "genuinely_hard",
        "hint_candidate": false,
        "reasoning": "One run omitted forged bean-property mappings and one mishandled lower-bounded entry types. The shared mapper set makes each defect appear as 30 failures. This weakens localization but does not create false blame because both root defects violate requested or inferable behavior and JUnit identifies the broken mapper."
      }
    ],
    "top_runs": [
      {
        "is_true_positive": true,
        "reasoning": "Passed all 3,641 baseline and 32 new tests with coordinated changes to type modeling, classification, entry construction, property forging, mapping models, and templates. Added independent tests and did not game the verifier.",
        "run_id": "rd7ehg5245sj914bbfkgbh87b58az3dy",
        "true_positive_reasoning": "Patch and evaluator evidence show broad support for arrays, qualifiers, conversions, targets, inherited/property mappings, abstract Entry construction, lower bounds, and stream boundaries. The implementation is not fixture-specific.",
        "verdict": "pass"
      },
      {
        "is_true_positive": true,
        "reasoning": "Passed every baseline and feature test with a distinct compact architecture reusing ContainerMappingMethodBuilder and IterableMappingMethod while preserving validation boundaries.",
        "run_id": "rd782f9g6ffm3dkzykxr19rjrx8ayx9w",
        "true_positive_reasoning": "Patch inspection confirms correct Entry typing, entrySet iteration, reverse put generation, abstract Entry construction, property forging, and narrowly scoped Map/iterable validation. No test suppression or hardcoding appears.",
        "verdict": "pass"
      }
    ]
  },
  "extra_fields": {
    "confidence": 0.96,
    "hint_suggestions": [],
    "pass_rate": 0.2,
    "total_runs": 10,
    "verdict_reasoning": "PASS: 2/10 legitimate full passes, all baseline tests pass in every rollout, and every failure traces to an explicit or reasonably inferable requirement. Tests are deterministic and behavioral, the stream boundary is subtle but fair, and no hint is needed."
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
        "id": "scopeGate",
        "label": "Scope Gate",
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
        "detail": "Median files: 14, messages: 125.5, LOC: 428",
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
        "detail": "Passed with caveats",
        "id": "agentNoFalsePositives",
        "label": "No false positives",
        "status": "warn"
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
