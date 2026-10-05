# ⚠️ AI Evaluation Report

> Automated review of problem quality, fairness, and agent failure patterns

## Metadata

- **Verdict:** `UNFAIR`
- **Completed:** 2026-07-22 04:49:02
- **Created:** 2026-07-22 04:41:44
- **Step:** Completed
- **Job ID:** `nx7398jgmsa1f4xv6fjc091dv18b10pt`

## Summary Statistics

- **Pass Rate:** 10% (10 runs)
- **Confidence:** 0.99
- **Reasoning:** Only 1 of 10 rollouts fully passes, so the task is not too easy and has sufficient runs. However, nine substantive near-complete implementations are rejected solely by undocumented diagnostic capitalization/synonym requirements or validation precedence for a multiply-invalid fixture. Because these failures are not valid under the stated contract, the correct verdict is UNFAIR until the hidden assertions are relaxed.

## Reviewer Notes

The engineering task itself is strong: it is realistic, well-scoped, comprehensively tested, and difficult for substantive reasons. All ten rollouts preserved the 3,641-test baseline, one rollout passed all 41 new tests legitimately, and the others passed 35-40. Functional groups covering supported interfaces, explicit/default resources, standard Properties parsing, source-defined implementations, generic shape, constructors, exact-interface replacement, nested mappings, and object-factory precedence passed across every rollout. The reference solution is clean and appropriately integrated.

The problem is not ready to ship because seven diagnostic groups enforce behavior the description does not specify. At test.patch:473, sentence-initial `Unknown` fails a lowercase-only `unknown|unrecognized` regex; similar case-sensitive defects affect unsupported interfaces, empty values, and conflicting duplicates. At test.patch:506 and test.patch:640, natural explanations such as `could not be resolved`, `could not be found`, `could not be read`, and `could not load` are rejected despite naming the invalid value and cause exactly as requested. These are not isolated agent mistakes: they account for failures in nine of ten otherwise substantive implementations.

The `shouldRejectUnassignableImplementationTypes` fixture is also multiply invalid: `NotACollection` is both unassignable to `List` and has the wrong generic arity. Three agents correctly report the arity defect first, but test.patch:543 insists on `assign` even though no validation precedence is documented. Make diagnostic matching case-insensitive and semantic, broaden the accepted missing/resolution wording, and either give the unassignable fixture matching generic arity or accept either valid cause. This requires test fixes, not hints.

## Checklist (19/25 passed)

### Problem

- ✅ **Requirements complete and self-contained**
  - The core feature requirements cover resource selection, property format, validation, constructor behavior, exact-interface scope, and factory precedence. Exact diagnostic vocabulary and validation ord...
- ❌ **No ambiguities, fully deterministic**
  - Core runtime behavior is deterministic, but the hidden suite creates ambiguity by requiring assignability to be diagnosed before generic arity for a type violating both constraints and by accepting on...
- ✅ **Concise and not prescriptive**
  - The description is compact and specifies outcomes rather than implementation structure.
- ✅ **Matches real-world repo scope**
  - Configurable concrete implementations are a realistic annotation-processor feature and fit MapStruct's collection construction subsystem.
- ✅ **Aligns with repo design philosophy**
  - The reference solution integrates through existing processor options, model context, and TypeFactory implementation selection without destabilizing public APIs.
- ✅ **No irrelevant context**
  - Every sentence in the task describes a required behavior or validation boundary.
- ✅ **Clear writing and formatting**
  - The prose is readable and precise despite being paragraph-based; the property key and option are presented unambiguously.
- ✅ **Tests cover requirements and edge cases**
  - Coverage is broad: defaults, explicit resources, all supported interfaces, source types, generics, constructors, duplicates, nested mappings, exact-interface boundaries, and factory precedence are exe...
- ✅ **Solution meets all requirements**
  - The reference passes all 3,641 baseline and 41 new tests and implements the full described feature surface.
- ✅ **No plagiarism**
  - Automated checks found no integrity issue, and the task/reference appear purpose-built for this repository rather than copied tutorial material.

### Tests

- ✅ **New tests highlight missing behavior**
  - The clean repository fails all 41 new invocations, while the reference and one rollout pass all of them.
- ✅ **Tests are deterministic**
  - The suite completed consistently with no timing or ordering instability reported across ten rollouts; failures are repeatable regex mismatches.
- ❌ **Assertions verify the correct output**
  - Functional assertions are strong and behavioral, but seven diagnostic groups reject correct semantic output due to capitalization, synonym choice, or first-reported cause.
- ❌ **Tests validate behavior, not internals**
  - Construction tests observe generated mapper behavior, but diagnostic regexes effectively test presentation details not required by the public contract.
- ✅ **Tests follow repo structure**
  - Tests use the existing processor test framework, compiler matrix, package layout, and resource annotations.
- ✅ **Test suite is concise**
  - The 28 logical groups are focused and generally non-redundant; dual-compiler execution is justified for annotation-processor behavior.
- ❌ **Tests do not check unspecified behavior**
  - The diagnostic tests check unspecified capitalization and vocabulary, and the unassignable test checks unspecified validation precedence.
- ❌ **No unreasonable assumptions in tests**
  - Most tests are reasonable, but diagnostic token matching and the validation-order expectation are not inferable from the description or repository conventions.
- ❌ **No trivial or unfair failure patterns**
  - Nine rollouts implement the substantive feature but fail only one to six hidden assertions because of exact diagnostic phrasing. This is precisely a trivial unfair failure pattern.

### Solution

- ✅ **No regressions, code follows patterns**
  - The reference uses existing processor option and TypeFactory patterns; all baseline tests pass.
- ✅ **No unexplained defensive code**
  - The added validation and error handling correspond to explicit configuration and type-safety requirements.
- ✅ **No irrelevant changes**
  - The reference changes eight focused source/documentation files, all directly tied to configuration loading, validation, and collection construction.
- ✅ **API contracts remain stable**
  - The feature adds an annotation-processor option and internal implementation support without breaking existing public mapping APIs.
- ✅ **No AI slop**
  - The reference is cohesive, uses project naming and formatting conventions, and contains no excessive commentary, hallucinated abstractions, or suspicious boilerplate.

### Other

- ✅ **Hint is appropriate if present**
  - No hint is present. A hint should not be used to teach agents hidden wording; the tests should instead be relaxed or corrected.

## Test Group Analysis

### ✅ BaselineRegressionSuite

- **Tests:** 3641 | **Pass Rate:** 100% | **Runs:** 10 passed, 0 failed | **Fairness:** fair
- Runs the existing MapStruct processor test suite to detect regressions outside the new feature.

### ✅ ConfigureEverySupportedInterfaceFamily

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks configured implementations for every supported collection, map, concurrent, navigable, sorted, and Java 21 sequenced interface family on both compilers.

### ✅ ConfigureReturnDefaultMappings

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks that configured implementations are used when null-value mapping creates empty return-default collections and maps.

### ✅ InitialCapacityConstructor

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks use of a public usable int constructor with source size as initial capacity.

### ✅ NoArgFallbackForUnusableIntConstructor

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks fallback to the public no-argument constructor when an int constructor exists but is not usable.

### ✅ ForgedNestedMappings

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks that configured implementations propagate into generated nested collection conversion methods.

### ✅ ConcreteResultTypesUnchanged

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks that mappings returning a concrete type retain that type while exact interface results use configuration.

### ✅ ExistingMappingTargetsUnchanged

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks that update methods preserve caller-provided mapping targets and only create configured types for new return values.

### ✅ ObjectFactoryPrecedence

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks that an applicable object factory overrides the configured implementation while other mappings still use configuration.

### ✅ ExplicitConfigurationResource

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks loading a classpath resource selected by the mapstruct.configurationFile processor option.

### ✅ SelectedResourceOverridesDefault

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks that an explicitly selected resource is used instead of an invalid default mapstruct.properties resource.

### ✅ UnconfiguredInterfacesKeepDefaults

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks partial configuration and retention of built-in implementations for interfaces without entries.

### ✅ EqualDuplicateEntries

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks that duplicate properties with identical values are accepted.

### ✅ StandardJavaPropertiesSyntax

- **Tests:** 2 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks comments, whitespace, Unicode escapes, and continuation syntax using standard Java Properties parsing.

### ❌ RejectUnknownProperties

- **Tests:** 1 | **Pass Rate:** 40% | **Runs:** 4 passed, 6 failed | **Fairness:** unfair
- Checks compilation failure and a diagnostic naming an unknown property and explaining that it is unknown.

  **Failure Mode** (unfair_test, AMBIGUOUS, 6 runs):
  > Sentence-initial 'Unknown' is rejected by a lowercase-only diagnostic regex.

### ⚠️ RejectUnsupportedInterfaces

- **Tests:** 1 | **Pass Rate:** 50% | **Runs:** 5 passed, 5 failed | **Fairness:** unfair
- Checks compilation failure for a configuration key naming an unsupported interface.

  **Failure Mode** (unfair_test, AMBIGUOUS, 5 runs):
  > Equivalent diagnostics using 'Unsupported' or 'not supported' are rejected because the regex requires lowercase contiguous 'unsupported'.

### ⚠️ RejectEmptyImplementationTypes

- **Tests:** 1 | **Pass Rate:** 70% | **Runs:** 7 passed, 3 failed | **Fairness:** unfair
- Checks compilation failure for an empty implementation value.

  **Failure Mode** (unfair_test, AMBIGUOUS, 3 runs):
  > Sentence-initial 'Empty' is rejected by the lowercase-only empty|blank regex.

### ❌ RejectMissingImplementationTypes

- **Tests:** 1 | **Pass Rate:** 30% | **Runs:** 3 passed, 7 failed | **Fairness:** unfair
- Checks compilation failure when the configured implementation type cannot be resolved.

  **Failure Mode** (unfair_test, AMBIGUOUS, 7 runs):
  > The regex excludes the natural phrases 'could not be resolved' and 'could not be found'.

### ✅ RejectInterfaceImplementationTypes

- **Tests:** 1 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks that an interface cannot be configured as the concrete implementation.

### ✅ RejectAbstractImplementationTypes

- **Tests:** 1 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks that an abstract class cannot be configured as the implementation.

### ⚠️ RejectUnassignableImplementationTypes

- **Tests:** 1 | **Pass Rate:** 70% | **Runs:** 7 passed, 3 failed | **Fairness:** unfair
- Checks that a configured implementation is assignable to the named interface.

  **Failure Mode** (unfair_test, AMBIGUOUS, 3 runs):
  > The fixture violates both assignability and generic arity, but the test accepts only an assignability-first diagnostic.

### ✅ RejectMissingAccessibleNoArgConstructor

- **Tests:** 1 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks rejection when the implementation lacks a public accessible no-argument constructor.

### ✅ RejectWrongGenericArity

- **Tests:** 1 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks rejection when implementation and interface declare different numbers of type parameters.

### ✅ RejectBoundedGenericParameters

- **Tests:** 1 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks rejection when implementation type parameters have bounds.

### ✅ RejectFixedElementGenericShape

- **Tests:** 1 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks rejection when the implementation does not preserve the interface type parameter and fixes an element type.

### ✅ RejectCheckedNoArgConstructorExceptions

- **Tests:** 1 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks rejection when the public no-argument constructor declares a checked exception.

### ✅ RejectInaccessibleImplementationTypes

- **Tests:** 1 | **Pass Rate:** 100% | **Runs:** 0 passed, 0 failed | **Fairness:** fair
- Checks rejection of a non-public nested implementation class.

### ⚠️ RejectConflictingDuplicateEntries

- **Tests:** 1 | **Pass Rate:** 70% | **Runs:** 7 passed, 3 failed | **Fairness:** unfair
- Checks compilation failure for duplicate keys with different implementation values.

  **Failure Mode** (unfair_test, AMBIGUOUS, 3 runs):
  > Sentence-initial 'Conflicting' is rejected by the lowercase-only duplicate|conflict regex.

### ❌ RejectMissingSelectedResource

- **Tests:** 1 | **Pass Rate:** 40% | **Runs:** 4 passed, 6 failed | **Fairness:** unfair
- Checks compilation failure when an explicitly selected configuration resource does not exist.

  **Failure Mode** (unfair_test, AMBIGUOUS, 6 runs):
  > Diagnostics saying the resource 'could not be read', 'could not be found', or 'could not load' are excluded by a narrow synonym regex.

## Failure Patterns

### Pattern 1: Case-sensitive diagnostic cause keywords reject sentence-initial capitalization.

- **Type:** unfair_test | **Affected Runs:** 6 | **Hint Candidate:** No
- **Affected Test Groups:** RejectUnknownProperties, RejectUnsupportedInterfaces, RejectEmptyImplementationTypes, RejectConflictingDuplicateEntries
- **Analysis:** Messages beginning with 'Unknown', 'Unsupported', 'Empty', or 'Conflicting' identify the invalid key and cause but fail lowercase-only regexes. This is an unfair verifier detail, not genuine implementation difficulty.

### Pattern 2: Narrow synonym lists reject semantically equivalent missing-resource and unresolved-type diagnostics.

- **Type:** unfair_test | **Affected Runs:** 9 | **Hint Candidate:** No
- **Affected Test Groups:** RejectMissingImplementationTypes, RejectMissingSelectedResource
- **Analysis:** Phrases such as 'could not be resolved', 'could not be found', 'could not be read', and 'could not load' fulfill the prompt but are not accepted by the enumerated regular expressions. Nine otherwise strong rollouts encounter at least one such mismatch.

### Pattern 3: A multiply-invalid fixture imposes undocumented validation precedence.

- **Type:** unfair_test | **Affected Runs:** 3 | **Hint Candidate:** No
- **Affected Test Groups:** RejectUnassignableImplementationTypes
- **Analysis:** NotACollection violates both assignability and generic arity. Reporting either cause is accurate under the description, but the test requires assignability wording. This should be fixed by isolating the fixture defect or accepting either cause, not hinted around.

## Top Passing Runs

### Run 1 (PASS) ✅

**Strategy:** Passed all 3,641 baseline tests and all 41 new tests with a general implementation covering resource loading, duplicate detection, source-type resolution, generic preservation, constructor validation, capacity selection, exact-interface replacement, and object-factory precedence.

**True Positive Analysis:** The agent solution is substantive and integrated through the processor and TypeFactory rather than keyed to hidden fixtures. It also adds normal project tests and documentation and does not modify the hidden harness. The evaluator found no cheating or code-review blocker.

### Run 2 (FAIL) ❌

**Strategy:** Passed all baseline tests and 40 of 41 new tests. Its sole failure reports MissingList 'could not be resolved', which is semantically correct but excluded by the hidden synonym regex.

### Run 3 (FAIL) ❌

**Strategy:** Passed all baseline tests and 39 of 41 new tests. Both failures are verifier issues: 'could not be found' is excluded, and a multiply-invalid type is diagnosed for generic arity before assignability.

## Submission Readiness ❌

**Can Submit:** No

| Criterion | Status | Detail |
|-----------|--------|--------|
| ✅ Prechecks | pass | 5/5 passing |
| ✅ Scope Gate | pass |  |
| ✅ Quality Checks | pass | 7/7 passing |
| ❌ Fair task | fail | 9 run(s) flagged task issues |
| ✅ Solvable | pass | 1/10 solved |
| ✅ Difficulty | pass | 10% — Hard |
| ✅ Long-horizon | pass | Median files: 23, messages: 109, LOC: 828 |
| ✅ No cheating | pass | No cheating detected |
| ❌ No environment blockers | fail | 9/10 run(s) flagged environment blocker (verifier) |
| ❌ No false positives | pending | Not run yet |
| ❌ Holistic AI Review | fail | UNFAIR |
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
    "completedAt": 1784684942411,
    "createdAt": 1784684504397,
    "currentStep": "Completed",
    "jobId": "nx7398jgmsa1f4xv6fjc091dv18b10pt"
  },
  "verdict": "UNFAIR",
  "reviewer_notes": "The engineering task itself is strong: it is realistic, well-scoped, comprehensively tested, and difficult for substantive reasons. All ten rollouts preserved the 3,641-test baseline, one rollout passed all 41 new tests legitimately, and the others passed 35-40. Functional groups covering supported interfaces, explicit/default resources, standard Properties parsing, source-defined implementations, generic shape, constructors, exact-interface replacement, nested mappings, and object-factory precedence passed across every rollout. The reference solution is clean and appropriately integrated.\n\nThe problem is not ready to ship because seven diagnostic groups enforce behavior the description does not specify. At test.patch:473, sentence-initial `Unknown` fails a lowercase-only `unknown|unrecognized` regex; similar case-sensitive defects affect unsupported interfaces, empty values, and conflicting duplicates. At test.patch:506 and test.patch:640, natural explanations such as `could not be resolved`, `could not be found`, `could not be read`, and `could not load` are rejected despite naming the invalid value and cause exactly as requested. These are not isolated agent mistakes: they account for failures in nine of ten otherwise substantive implementations.\n\nThe `shouldRejectUnassignableImplementationTypes` fixture is also multiply invalid: `NotACollection` is both unassignable to `List` and has the wrong generic arity. Three agents correctly report the arity defect first, but test.patch:543 insists on `assign` even though no validation precedence is documented. Make diagnostic matching case-insensitive and semantic, broaden the accepted missing/resolution wording, and either give the unassignable fixture matching generic arity or accept either valid cause. This requires test fixes, not hints.",
  "checklist": {
    "total": 25,
    "pass_count": 19,
    "fail_count": 6,
    "items": [
      {
        "item": "Requirements complete and self-contained",
        "reasoning": "The core feature requirements cover resource selection, property format, validation, constructor behavior, exact-interface scope, and factory precedence. Exact diagnostic vocabulary and validation order are intentionally not specified, which is appropriate for an API behavior task but conflicts with several tests.",
        "verdict": "pass"
      },
      {
        "item": "No ambiguities, fully deterministic",
        "reasoning": "Core runtime behavior is deterministic, but the hidden suite creates ambiguity by requiring assignability to be diagnosed before generic arity for a type violating both constraints and by accepting only selected English phrasings.",
        "verdict": "fail"
      },
      {
        "item": "Concise and not prescriptive",
        "reasoning": "The description is compact and specifies outcomes rather than implementation structure.",
        "verdict": "pass"
      },
      {
        "item": "Matches real-world repo scope",
        "reasoning": "Configurable concrete implementations are a realistic annotation-processor feature and fit MapStruct's collection construction subsystem.",
        "verdict": "pass"
      },
      {
        "item": "Aligns with repo design philosophy",
        "reasoning": "The reference solution integrates through existing processor options, model context, and TypeFactory implementation selection without destabilizing public APIs.",
        "verdict": "pass"
      },
      {
        "item": "No irrelevant context",
        "reasoning": "Every sentence in the task describes a required behavior or validation boundary.",
        "verdict": "pass"
      },
      {
        "item": "Clear writing and formatting",
        "reasoning": "The prose is readable and precise despite being paragraph-based; the property key and option are presented unambiguously.",
        "verdict": "pass"
      },
      {
        "item": "New tests highlight missing behavior",
        "reasoning": "The clean repository fails all 41 new invocations, while the reference and one rollout pass all of them.",
        "verdict": "pass"
      },
      {
        "item": "Tests are deterministic",
        "reasoning": "The suite completed consistently with no timing or ordering instability reported across ten rollouts; failures are repeatable regex mismatches.",
        "verdict": "pass"
      },
      {
        "item": "Assertions verify the correct output",
        "reasoning": "Functional assertions are strong and behavioral, but seven diagnostic groups reject correct semantic output due to capitalization, synonym choice, or first-reported cause.",
        "verdict": "fail"
      },
      {
        "item": "Tests validate behavior, not internals",
        "reasoning": "Construction tests observe generated mapper behavior, but diagnostic regexes effectively test presentation details not required by the public contract.",
        "verdict": "fail"
      },
      {
        "item": "Tests follow repo structure",
        "reasoning": "Tests use the existing processor test framework, compiler matrix, package layout, and resource annotations.",
        "verdict": "pass"
      },
      {
        "item": "Tests cover requirements and edge cases",
        "reasoning": "Coverage is broad: defaults, explicit resources, all supported interfaces, source types, generics, constructors, duplicates, nested mappings, exact-interface boundaries, and factory precedence are exercised.",
        "verdict": "pass"
      },
      {
        "item": "Test suite is concise",
        "reasoning": "The 28 logical groups are focused and generally non-redundant; dual-compiler execution is justified for annotation-processor behavior.",
        "verdict": "pass"
      },
      {
        "item": "Tests do not check unspecified behavior",
        "reasoning": "The diagnostic tests check unspecified capitalization and vocabulary, and the unassignable test checks unspecified validation precedence.",
        "verdict": "fail"
      },
      {
        "item": "Solution meets all requirements",
        "reasoning": "The reference passes all 3,641 baseline and 41 new tests and implements the full described feature surface.",
        "verdict": "pass"
      },
      {
        "item": "No regressions, code follows patterns",
        "reasoning": "The reference uses existing processor option and TypeFactory patterns; all baseline tests pass.",
        "verdict": "pass"
      },
      {
        "item": "No unexplained defensive code",
        "reasoning": "The added validation and error handling correspond to explicit configuration and type-safety requirements.",
        "verdict": "pass"
      },
      {
        "item": "No irrelevant changes",
        "reasoning": "The reference changes eight focused source/documentation files, all directly tied to configuration loading, validation, and collection construction.",
        "verdict": "pass"
      },
      {
        "item": "API contracts remain stable",
        "reasoning": "The feature adds an annotation-processor option and internal implementation support without breaking existing public mapping APIs.",
        "verdict": "pass"
      },
      {
        "item": "No AI slop",
        "reasoning": "The reference is cohesive, uses project naming and formatting conventions, and contains no excessive commentary, hallucinated abstractions, or suspicious boilerplate.",
        "verdict": "pass"
      },
      {
        "item": "No plagiarism",
        "reasoning": "Automated checks found no integrity issue, and the task/reference appear purpose-built for this repository rather than copied tutorial material.",
        "verdict": "pass"
      },
      {
        "item": "No unreasonable assumptions in tests",
        "reasoning": "Most tests are reasonable, but diagnostic token matching and the validation-order expectation are not inferable from the description or repository conventions.",
        "verdict": "fail"
      },
      {
        "item": "No trivial or unfair failure patterns",
        "reasoning": "Nine rollouts implement the substantive feature but fail only one to six hidden assertions because of exact diagnostic phrasing. This is precisely a trivial unfair failure pattern.",
        "verdict": "fail"
      },
      {
        "item": "Hint is appropriate if present",
        "reasoning": "No hint is present. A hint should not be used to teach agents hidden wording; the tests should instead be relaxed or corrected.",
        "verdict": "pass"
      }
    ]
  },
  "detailed_analysis": {
    "test_groups": [
      {
        "category": "regression",
        "description": "Runs the existing MapStruct processor test suite to detect regressions outside the new feature.",
        "failure_modes": [],
        "fairness_reasoning": "All 3,641 baseline tests passed in every rollout, so the task and implementations did not expose a regression or harness instability.",
        "fairness_verdict": "fair",
        "group_name": "BaselineRegressionSuite",
        "pass_rate_across_rollouts": 1,
        "rollout_results": {
          "failed": [],
          "passed": [
            "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
            "rd7fh851drnmsc6m908ep7c7ms8b0g75",
            "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
            "rd75m4k2j8jb0pmks64tywyy498b19pn",
            "rd7cfvmcf20tmx086nebasf2z58b1xtp",
            "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
            "rd7274mv48mrssmekjky6et61x8b0rhz",
            "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
            "rd700m9ty07qjgtdcz45660jn58b1yf6",
            "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
          ]
        },
        "total_tests_in_group": 3641
      },
      {
        "category": "new_behavior",
        "description": "Checks configured implementations for every supported collection, map, concurrent, navigable, sorted, and Java 21 sequenced interface family on both compilers.",
        "failure_modes": [],
        "fairness_reasoning": "This directly exercises the requirement that projects may replace built-ins for supported interfaces. The supported set is discoverable in TypeFactory and the assertions are behavioral.",
        "fairness_verdict": "fair",
        "group_name": "ConfigureEverySupportedInterfaceFamily",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks that configured implementations are used when null-value mapping creates empty return-default collections and maps.",
        "failure_modes": [],
        "fairness_reasoning": "Return-default mappings are another path where MapStruct constructs the exact interface result, so applying configuration is a reasonable direct consequence of the specification.",
        "fairness_verdict": "fair",
        "group_name": "ConfigureReturnDefaultMappings",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks use of a public usable int constructor with source size as initial capacity.",
        "failure_modes": [],
        "fairness_reasoning": "The constructor choice and source-size argument are explicitly required and are tested through observable constructor state.",
        "fairness_verdict": "fair",
        "group_name": "InitialCapacityConstructor",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks fallback to the public no-argument constructor when an int constructor exists but is not usable.",
        "failure_modes": [],
        "fairness_reasoning": "The wording 'usable public int constructor' implies unusable int constructors must not be selected, while the required no-argument constructor remains the valid fallback.",
        "fairness_verdict": "fair",
        "group_name": "NoArgFallbackForUnusableIntConstructor",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks that configured implementations propagate into generated nested collection conversion methods.",
        "failure_modes": [],
        "fairness_reasoning": "A forged nested method still constructs the exact supported interface result, so this follows directly from the feature's stated scope.",
        "fairness_verdict": "fair",
        "group_name": "ForgedNestedMappings",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks that mappings returning a concrete type retain that type while exact interface results use configuration.",
        "failure_modes": [],
        "fairness_reasoning": "The problem explicitly limits replacement to the exact supported interface result, making this a central and fair boundary test.",
        "fairness_verdict": "fair",
        "group_name": "ConcreteResultTypesUnchanged",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks that update methods preserve caller-provided mapping targets and only create configured types for new return values.",
        "failure_modes": [],
        "fairness_reasoning": "MapStruct does not construct an existing mapping target, so excluding it is a direct consequence of the stated exact-construction behavior.",
        "fairness_verdict": "fair",
        "group_name": "ExistingMappingTargetsUnchanged",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks that an applicable object factory overrides the configured implementation while other mappings still use configuration.",
        "failure_modes": [],
        "fairness_reasoning": "Object-factory precedence is explicitly stated and the test verifies it without inspecting implementation details.",
        "fairness_verdict": "fair",
        "group_name": "ObjectFactoryPrecedence",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks loading a classpath resource selected by the mapstruct.configurationFile processor option.",
        "failure_modes": [],
        "fairness_reasoning": "The option name, relative-resource semantics, and expected behavior are explicit in the task description.",
        "fairness_verdict": "fair",
        "group_name": "ExplicitConfigurationResource",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks that an explicitly selected resource is used instead of an invalid default mapstruct.properties resource.",
        "failure_modes": [],
        "fairness_reasoning": "The description says the option names another resource instead of the default, so ignoring the default is unambiguous.",
        "fairness_verdict": "fair",
        "group_name": "SelectedResourceOverridesDefault",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks partial configuration and retention of built-in implementations for interfaces without entries.",
        "failure_modes": [],
        "fairness_reasoning": "The feature replaces individual configured choices, and preserving built-ins for missing entries is clearly implied and consistent with the no-resource behavior.",
        "fairness_verdict": "fair",
        "group_name": "UnconfiguredInterfacesKeepDefaults",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks that duplicate properties with identical values are accepted.",
        "failure_modes": [],
        "fairness_reasoning": "Equal duplicates are explicitly permitted.",
        "fairness_verdict": "fair",
        "group_name": "EqualDuplicateEntries",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks comments, whitespace, Unicode escapes, and continuation syntax using standard Java Properties parsing.",
        "failure_modes": [],
        "fairness_reasoning": "The task explicitly requires standard Java properties parsing, and the fixture uses normal Properties syntax rather than obscure implementation details.",
        "fairness_verdict": "fair",
        "group_name": "StandardJavaPropertiesSyntax",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Checks compilation failure and a diagnostic naming an unknown property and explaining that it is unknown.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
              "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
              "rd7cfvmcf20tmx086nebasf2z58b1xtp",
              "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
              "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
              "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
            ],
            "classification": "AMBIGUOUS",
            "description": "Sentence-initial 'Unknown' is rejected by a lowercase-only diagnostic regex.",
            "explanation_type": "unfair_test",
            "reasoning": "Each diagnostic names mapstruct.unsupported and states that it is an unknown property, exactly satisfying the semantic contract. The case-sensitive pattern at test.patch:473 accepts only lowercase 'unknown' or 'unrecognized', an undocumented presentation requirement."
          }
        ],
        "fairness_reasoning": "Compilation failure is fair, but rejecting the natural sentence 'Unknown MapStruct configuration property' solely because the cause word is capitalized is brittle and not specified.",
        "fairness_verdict": "unfair",
        "group_name": "RejectUnknownProperties",
        "pass_rate_across_rollouts": 0.4,
        "rollout_results": {
          "failed": [
            "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
            "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
            "rd7cfvmcf20tmx086nebasf2z58b1xtp",
            "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
            "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
            "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
          ],
          "passed": [
            "rd7fh851drnmsc6m908ep7c7ms8b0g75",
            "rd75m4k2j8jb0pmks64tywyy498b19pn",
            "rd7274mv48mrssmekjky6et61x8b0rhz",
            "rd700m9ty07qjgtdcz45660jn58b1yf6"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks compilation failure for a configuration key naming an unsupported interface.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
              "rd7cfvmcf20tmx086nebasf2z58b1xtp",
              "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
              "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
              "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
            ],
            "classification": "AMBIGUOUS",
            "description": "Equivalent diagnostics using 'Unsupported' or 'not supported' are rejected because the regex requires lowercase contiguous 'unsupported'.",
            "explanation_type": "unfair_test",
            "reasoning": "The messages identify java.util.Queue and explain that it is unsupported or not supported. The task does not require a specific token, capitalization, or morphology."
          }
        ],
        "fairness_reasoning": "The behavioral requirement is explicit, but the diagnostic assertion is unnecessarily lexical and rejects semantically identical explanations.",
        "fairness_verdict": "unfair",
        "group_name": "RejectUnsupportedInterfaces",
        "pass_rate_across_rollouts": 0.5,
        "rollout_results": {
          "failed": [
            "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
            "rd7cfvmcf20tmx086nebasf2z58b1xtp",
            "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
            "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
            "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
          ],
          "passed": [
            "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
            "rd7fh851drnmsc6m908ep7c7ms8b0g75",
            "rd75m4k2j8jb0pmks64tywyy498b19pn",
            "rd7274mv48mrssmekjky6et61x8b0rhz",
            "rd700m9ty07qjgtdcz45660jn58b1yf6"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks compilation failure for an empty implementation value.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
              "rd7cfvmcf20tmx086nebasf2z58b1xtp",
              "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
            ],
            "classification": "AMBIGUOUS",
            "description": "Sentence-initial 'Empty' is rejected by the lowercase-only empty|blank regex.",
            "explanation_type": "unfair_test",
            "reasoning": "The diagnostics name java.util.List and state that its implementation value is empty. Only capitalization prevents a match at test.patch:494."
          }
        ],
        "fairness_reasoning": "The test correctly demands failure, but its case-sensitive wording constraint is not part of the task and caused otherwise correct implementations to fail.",
        "fairness_verdict": "unfair",
        "group_name": "RejectEmptyImplementationTypes",
        "pass_rate_across_rollouts": 0.7,
        "rollout_results": {
          "failed": [
            "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
            "rd7cfvmcf20tmx086nebasf2z58b1xtp",
            "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
          ],
          "passed": [
            "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
            "rd7fh851drnmsc6m908ep7c7ms8b0g75",
            "rd75m4k2j8jb0pmks64tywyy498b19pn",
            "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
            "rd7274mv48mrssmekjky6et61x8b0rhz",
            "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
            "rd700m9ty07qjgtdcz45660jn58b1yf6"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks compilation failure when the configured implementation type cannot be resolved.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd7fh851drnmsc6m908ep7c7ms8b0g75",
              "rd75m4k2j8jb0pmks64tywyy498b19pn",
              "rd7cfvmcf20tmx086nebasf2z58b1xtp",
              "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
              "rd7274mv48mrssmekjky6et61x8b0rhz",
              "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
              "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
            ],
            "classification": "AMBIGUOUS",
            "description": "The regex excludes the natural phrases 'could not be resolved' and 'could not be found'.",
            "explanation_type": "unfair_test",
            "reasoning": "All seven diagnostics name MissingList and explain that resolution or lookup failed. The pattern at test.patch:506 enumerates synonyms such as 'cannot be resolved' but accidentally omits equivalent 'could not' formulations."
          }
        ],
        "fairness_reasoning": "This group's 70% failure rate is not genuine task difficulty: all failures are semantically compliant diagnostics rejected by an arbitrary synonym list.",
        "fairness_verdict": "unfair",
        "group_name": "RejectMissingImplementationTypes",
        "pass_rate_across_rollouts": 0.3,
        "rollout_results": {
          "failed": [
            "rd7fh851drnmsc6m908ep7c7ms8b0g75",
            "rd75m4k2j8jb0pmks64tywyy498b19pn",
            "rd7cfvmcf20tmx086nebasf2z58b1xtp",
            "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
            "rd7274mv48mrssmekjky6et61x8b0rhz",
            "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
            "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
          ],
          "passed": [
            "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
            "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
            "rd700m9ty07qjgtdcz45660jn58b1yf6"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks that an interface cannot be configured as the concrete implementation.",
        "failure_modes": [],
        "fairness_reasoning": "The concrete-class constraint is explicit, and all rollouts produced an accepted diagnostic naming the invalid type and cause.",
        "fairness_verdict": "fair",
        "group_name": "RejectInterfaceImplementationTypes",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks that an abstract class cannot be configured as the implementation.",
        "failure_modes": [],
        "fairness_reasoning": "The concrete-class constraint explicitly excludes abstract classes.",
        "fairness_verdict": "fair",
        "group_name": "RejectAbstractImplementationTypes",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks that a configured implementation is assignable to the named interface.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
              "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
              "rd75m4k2j8jb0pmks64tywyy498b19pn"
            ],
            "classification": "AMBIGUOUS",
            "description": "The fixture violates both assignability and generic arity, but the test accepts only an assignability-first diagnostic.",
            "explanation_type": "unfair_test",
            "reasoning": "NotACollection has zero type parameters while List has one. These agents correctly rejected it for the explicit same-arity rule before checking assignability. The task specifies no validation precedence, yet test.patch:543 requires the diagnostic to contain 'assign'."
          }
        ],
        "fairness_reasoning": "The intended assignability check is fair, but the multiply-invalid fixture makes the required first-reported cause non-deterministic and therefore unfair without a documented precedence rule.",
        "fairness_verdict": "unfair",
        "group_name": "RejectUnassignableImplementationTypes",
        "pass_rate_across_rollouts": 0.7,
        "rollout_results": {
          "failed": [
            "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
            "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
            "rd75m4k2j8jb0pmks64tywyy498b19pn"
          ],
          "passed": [
            "rd7fh851drnmsc6m908ep7c7ms8b0g75",
            "rd7cfvmcf20tmx086nebasf2z58b1xtp",
            "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
            "rd7274mv48mrssmekjky6et61x8b0rhz",
            "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
            "rd700m9ty07qjgtdcz45660jn58b1yf6",
            "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks rejection when the implementation lacks a public accessible no-argument constructor.",
        "failure_modes": [],
        "fairness_reasoning": "A public no-argument constructor is explicitly required.",
        "fairness_verdict": "fair",
        "group_name": "RejectMissingAccessibleNoArgConstructor",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks rejection when implementation and interface declare different numbers of type parameters.",
        "failure_modes": [],
        "fairness_reasoning": "Matching generic arity is explicit and the fixture isolates that defect.",
        "fairness_verdict": "fair",
        "group_name": "RejectWrongGenericArity",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks rejection when implementation type parameters have bounds.",
        "failure_modes": [],
        "fairness_reasoning": "The task explicitly requires unbounded type parameters.",
        "fairness_verdict": "fair",
        "group_name": "RejectBoundedGenericParameters",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks rejection when the implementation does not preserve the interface type parameter and fixes an element type.",
        "failure_modes": [],
        "fairness_reasoning": "Preservation of interface type parameters is explicitly required and this fixture isolates that requirement.",
        "fairness_verdict": "fair",
        "group_name": "RejectFixedElementGenericShape",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks rejection when the public no-argument constructor declares a checked exception.",
        "failure_modes": [],
        "fairness_reasoning": "The no-argument constructor's checked-exception restriction is explicitly stated.",
        "fairness_verdict": "fair",
        "group_name": "RejectCheckedNoArgConstructorExceptions",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks rejection of a non-public nested implementation class.",
        "failure_modes": [],
        "fairness_reasoning": "Public accessibility is explicitly required and the fixture directly represents an inaccessible source type.",
        "fairness_verdict": "fair",
        "group_name": "RejectInaccessibleImplementationTypes",
        "pass_rate_across_rollouts": 1,
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks compilation failure for duplicate keys with different implementation values.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
              "rd7cfvmcf20tmx086nebasf2z58b1xtp",
              "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
            ],
            "classification": "AMBIGUOUS",
            "description": "Sentence-initial 'Conflicting' is rejected by the lowercase-only duplicate|conflict regex.",
            "explanation_type": "unfair_test",
            "reasoning": "The messages name java.util.List and both conflicting values. They satisfy the requested diagnostic semantics, but test.patch:625 does not use case-insensitive matching."
          }
        ],
        "fairness_reasoning": "Conflict detection is explicitly required, but exact capitalization of the explanatory word is not.",
        "fairness_verdict": "unfair",
        "group_name": "RejectConflictingDuplicateEntries",
        "pass_rate_across_rollouts": 0.7,
        "rollout_results": {
          "failed": [
            "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
            "rd7cfvmcf20tmx086nebasf2z58b1xtp",
            "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
          ],
          "passed": [
            "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
            "rd7fh851drnmsc6m908ep7c7ms8b0g75",
            "rd75m4k2j8jb0pmks64tywyy498b19pn",
            "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
            "rd7274mv48mrssmekjky6et61x8b0rhz",
            "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
            "rd700m9ty07qjgtdcz45660jn58b1yf6"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Checks compilation failure when an explicitly selected configuration resource does not exist.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
              "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
              "rd7cfvmcf20tmx086nebasf2z58b1xtp",
              "rd7274mv48mrssmekjky6et61x8b0rhz",
              "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
              "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
            ],
            "classification": "AMBIGUOUS",
            "description": "Diagnostics saying the resource 'could not be read', 'could not be found', or 'could not load' are excluded by a narrow synonym regex.",
            "explanation_type": "unfair_test",
            "reasoning": "Every message names absent.properties and explains that loading, reading, or lookup failed. The regex at test.patch:640 accepts 'cannot be read' and several alternatives but rejects ordinary equivalent phrasing."
          }
        ],
        "fairness_reasoning": "The required compilation failure is explicit, but the diagnostic requirement is semantic, not a prescribed phrasebook. Six valid implementations were rejected on wording alone.",
        "fairness_verdict": "unfair",
        "group_name": "RejectMissingSelectedResource",
        "pass_rate_across_rollouts": 0.4,
        "rollout_results": {
          "failed": [
            "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
            "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
            "rd7cfvmcf20tmx086nebasf2z58b1xtp",
            "rd7274mv48mrssmekjky6et61x8b0rhz",
            "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
            "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
          ],
          "passed": [
            "rd7fh851drnmsc6m908ep7c7ms8b0g75",
            "rd75m4k2j8jb0pmks64tywyy498b19pn",
            "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
            "rd700m9ty07qjgtdcz45660jn58b1yf6"
          ]
        },
        "total_tests_in_group": 1
      }
    ],
    "failure_patterns": [
      {
        "affected_runs": [
          "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
          "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
          "rd7cfvmcf20tmx086nebasf2z58b1xtp",
          "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
          "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
          "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
        ],
        "affected_test_groups": [
          "RejectUnknownProperties",
          "RejectUnsupportedInterfaces",
          "RejectEmptyImplementationTypes",
          "RejectConflictingDuplicateEntries"
        ],
        "description": "Case-sensitive diagnostic cause keywords reject sentence-initial capitalization.",
        "explanation_type": "unfair_test",
        "hint_candidate": false,
        "reasoning": "Messages beginning with 'Unknown', 'Unsupported', 'Empty', or 'Conflicting' identify the invalid key and cause but fail lowercase-only regexes. This is an unfair verifier detail, not genuine implementation difficulty."
      },
      {
        "affected_runs": [
          "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
          "rd7fh851drnmsc6m908ep7c7ms8b0g75",
          "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
          "rd75m4k2j8jb0pmks64tywyy498b19pn",
          "rd7cfvmcf20tmx086nebasf2z58b1xtp",
          "rd771cb90vqh1nbgb3r88y5gx98b1gr3",
          "rd7274mv48mrssmekjky6et61x8b0rhz",
          "rd77yjnq93n4cwjp87xacnb7kd8b02bg",
          "rd73zbarjkt3tgnvgz3dgnkbxs8b1tx7"
        ],
        "affected_test_groups": [
          "RejectMissingImplementationTypes",
          "RejectMissingSelectedResource"
        ],
        "description": "Narrow synonym lists reject semantically equivalent missing-resource and unresolved-type diagnostics.",
        "explanation_type": "unfair_test",
        "hint_candidate": false,
        "reasoning": "Phrases such as 'could not be resolved', 'could not be found', 'could not be read', and 'could not load' fulfill the prompt but are not accepted by the enumerated regular expressions. Nine otherwise strong rollouts encounter at least one such mismatch."
      },
      {
        "affected_runs": [
          "rd75hd8drr5qn5q9ykzf6jhgjs8b1tgt",
          "rd7dvvh52ynxf6vx8cwknxj3w98b10ty",
          "rd75m4k2j8jb0pmks64tywyy498b19pn"
        ],
        "affected_test_groups": [
          "RejectUnassignableImplementationTypes"
        ],
        "description": "A multiply-invalid fixture imposes undocumented validation precedence.",
        "explanation_type": "unfair_test",
        "hint_candidate": false,
        "reasoning": "NotACollection violates both assignability and generic arity. Reporting either cause is accurate under the description, but the test requires assignability wording. This should be fixed by isolating the fixture defect or accepting either cause, not hinted around."
      }
    ],
    "top_runs": [
      {
        "is_true_positive": true,
        "reasoning": "Passed all 3,641 baseline tests and all 41 new tests with a general implementation covering resource loading, duplicate detection, source-type resolution, generic preservation, constructor validation, capacity selection, exact-interface replacement, and object-factory precedence.",
        "run_id": "rd700m9ty07qjgtdcz45660jn58b1yf6",
        "true_positive_reasoning": "The agent solution is substantive and integrated through the processor and TypeFactory rather than keyed to hidden fixtures. It also adds normal project tests and documentation and does not modify the hidden harness. The evaluator found no cheating or code-review blocker.",
        "verdict": "pass"
      },
      {
        "reasoning": "Passed all baseline tests and 40 of 41 new tests. Its sole failure reports MissingList 'could not be resolved', which is semantically correct but excluded by the hidden synonym regex.",
        "run_id": "rd7fh851drnmsc6m908ep7c7ms8b0g75",
        "verdict": "fail"
      },
      {
        "reasoning": "Passed all baseline tests and 39 of 41 new tests. Both failures are verifier issues: 'could not be found' is excluded, and a multiply-invalid type is diagnosed for generic arity before assignability.",
        "run_id": "rd75m4k2j8jb0pmks64tywyy498b19pn",
        "verdict": "fail"
      }
    ]
  },
  "extra_fields": {
    "confidence": 0.99,
    "hint_suggestions": [],
    "pass_rate": 0.1,
    "total_runs": 10,
    "verdict_reasoning": "Only 1 of 10 rollouts fully passes, so the task is not too easy and has sufficient runs. However, nine substantive near-complete implementations are rejected solely by undocumented diagnostic capitalization/synonym requirements or validation precedence for a multiply-invalid fixture. Because these failures are not valid under the stated contract, the correct verdict is UNFAIR until the hidden assertions are relaxed."
  },
  "submission_readiness": {
    "can_submit": false,
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
        "detail": "9 run(s) flagged task issues",
        "id": "agentFair",
        "label": "Fair task",
        "status": "fail"
      },
      {
        "detail": "1/10 solved",
        "id": "agentSolvable",
        "label": "Solvable",
        "status": "pass"
      },
      {
        "detail": "10% — Hard",
        "id": "agentDifficulty",
        "label": "Difficulty",
        "status": "pass"
      },
      {
        "detail": "Median files: 23, messages: 109, LOC: 828",
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
        "detail": "9/10 run(s) flagged environment blocker (verifier)",
        "id": "agentNoEnvBlocker",
        "label": "No environment blockers",
        "status": "fail"
      },
      {
        "detail": "Not run yet",
        "id": "agentNoFalsePositives",
        "label": "No false positives",
        "status": "pending"
      },
      {
        "detail": "UNFAIR",
        "id": "holisticReview",
        "label": "Holistic AI Review",
        "status": "fail"
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
