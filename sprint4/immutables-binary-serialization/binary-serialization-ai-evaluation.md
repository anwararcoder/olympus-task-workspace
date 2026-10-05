# ✅ AI Evaluation Report

> Automated review of problem quality, fairness, and agent failure patterns

## Metadata

- **Verdict:** `PASS`
- **Completed:** 2026-07-19 20:12:53
- **Created:** 2026-07-19 19:59:29
- **Step:** Completed
- **Job ID:** `nx7033wsfqbf2j5w8x8naqtbhn8av3yv`

## Summary Statistics

- **Pass Rate:** 7% (14 runs)
- **Confidence:** 0.94
- **Reasoning:** There are 14 completed runs, including one legitimate full pass, so the task is neither insufficient nor impossible. The 7.1% pass rate is appropriately difficult. Every observed failure is explained by an explicit or reasonably inferable engineering requirement, tests accept alternative safe implementations, and the reference passes baseline and focused suites cleanly.

## Reviewer Notes

This is ready to ship. One of 14 completed rollouts passed all 326 baseline tests and all 38 focused tests with an independent, substantive implementation; a second rollout passed baseline and 35/38 focused tests. The 7.1% pass rate reflects genuine annotation-processor and wire-compatibility difficulty, not ambiguity. The twelve early failures are concrete clean-build regressions: three assumed custom builders return the immutable implementation, four mishandled type-use annotations in class literals, several misresolved nested generated types, and two crashed global eligibility analysis.

The three runtime failures in rd700pznbyhj6447dpz6fpz83x8av3mb are also fair. backwardReaderDefaultsMissingOlderAttributes (test.patch line 1455) and changedAttributeTypeIsTreatedAsAbsentNotMisdecoded (line 1483) enforce the explicit rule that constructor fields missing through version skew or type mismatch receive normal defaults. nullableAttributeEitherRoundTripsOrDisablesBinaryForm (line 1755) permits complete rejection; the rollout failed only because it generated the pair and then dereferenced a null nested value. These are valid implementation misses, not hidden conventions.

Coverage is broad and behavior-focused. The conditional BinCtorDefaulted branch is correct rather than a false negative: its defaulted size field is stored but is not a constructor parameter, so it falls outside the minimum constructor-built surface and other reconstructible constructor forms may, not must, be supported. A future strengthening could isolate constructor map-value mismatch separately, but current coverage is sufficient for fairness. The reference is concise, regression-clean, and shows no test-gaming, plagiarism, or AI slop.

## Checklist (25/25 passed)

### Problem

- ✅ **Requirements complete and self-contained**
  - The description specifies activation, API signatures, supported and unsupported shapes, compatibility, nesting, constructor behavior, conflicts, omission, and malformed input. Rollout failures map to ...
- ✅ **No ambiguities, fully deterministic**
  - The minimum required surface is precise. Optional nullable and extra constructor forms may be rejected, and tests use pairwise method checks where support is optional.
- ✅ **Concise and not prescriptive**
  - The description is long because the compatibility surface is large, but it states observable behavior without mandating a tag hash, framing helper, or generator architecture.
- ✅ **Matches real-world repo scope**
  - This is realistic processor/runtime engineering in the existing serial and value modules rather than a contrived exercise.
- ✅ **Aligns with repo design philosophy**
  - The feature is classpath-gated through the existing serial artifact pattern and uses the established generator/meta-model layers without a new annotation.
- ✅ **No irrelevant context**
  - Each paragraph defines eligibility, compatibility, supported shapes, nesting, or omission behavior used by tests.
- ✅ **Clear writing and formatting**
  - The prose is dense but terminology is consistent and constraints are concrete enough for an independent successful implementation.
- ✅ **Solution meets all requirements**
  - The reference passes all tests and implements gating, nameless framed fields, codecs, compatibility, nesting, collision rejection, and conservative eligibility. Rejecting BinCtorDefaulted is allowed b...
- ✅ **No plagiarism**
  - Automated integrity checks found no leaked, duplicate, or derivative public solution.

### Tests

- ✅ **New tests highlight missing or incorrect behavior**
  - The 38 focused tests fail on the base state and pass with the reference and one independent rollout.
- ✅ **Tests are deterministic**
  - Tests use fixed values, in-memory streams, reflection, and a controlled compiler probe; automated flakiness verification passed.
- ✅ **Assertions verify the correct output**
  - They compare full values or array contents, inspect preserved/defaulted fields, verify API modifiers, and require IOException for malformed input.
- ✅ **Tests validate behavior, not internals**
  - They call generated public APIs and observe bytes or reconstructed values. The activation probe checks only absence of the two named signatures.
- ✅ **Tests follow repo structure**
  - Fixtures and JUnit 5 tests are under value-fixture/test using existing Checkers and Maven/Surefire conventions.
- ✅ **Tests cover required behavior and edge cases**
  - Coverage spans activation, conflicts, types, version skew, collisions, nesting, recursion, constructors, unsupported shapes, long strings, and truncation. Constructor map-value mismatch is not isolate...
- ✅ **Test suite is concise**
  - Each test targets a distinct contract or shape family; repeated scalar round-trips serve as isolation sentinels for unsupported models.
- ✅ **Tests do not check unspecified behavior**
  - Mandatory assertions map to the description, while collision, nullable, nested-constructor, and defaulted-nonconstructor extensions allow complete rejection.
- ✅ **No unreasonable assumptions in tests**
  - Tests accept alternative safe implementations and do not require reference helper names, exact bytes, exact tags, or concrete collection classes.
- ✅ **No trivial or unfair failure patterns**
  - Failures are substantive generated-code integration or explicit compatibility defects, not test-runner discovery, flaky timing, or brittle strings.

### Solution

- ✅ **No regressions, code follows patterns**
  - Verification reports all 326 baseline and 38 new tests passing, with changes localized to serial runtime, templates, and metadata.
- ✅ **No unexplained defensive code**
  - Eligibility guards correspond to unsupported, recursive, conflicting, auxiliary, and collision cases; framing supports compatibility and truncation safety.
- ✅ **No irrelevant changes**
  - The reference modifies four task-related production files without unrelated refactors or fixture-specific hacks.
- ✅ **API contracts remain stable**
  - Only the requested generated pair is added, gated by serial presence and suppressed when either signature conflicts.
- ✅ **No AI slop**
  - The reference is compact, purposeful, and consistent with existing generator idioms, without verbose boilerplate or hallucinated dependencies.

### Other

- ✅ **Hint is appropriate if present**
  - No hint is present. One rollout passes legitimately, and common failures are substantive rather than incidental blockers, so no hint is needed.

## Test Group Analysis

### ❌ BaselineValueFixtureRegression

- **Tests:** 326 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Runs the 326 pre-existing value-fixture tests after a clean serial-enabled processor build to ensure generated code still compiles and existing behavior is preserved.

  **Failure Mode** (genuinely_hard, INFERRABLE, 3 runs):
  > Generated readFrom return types were incompatible with customized builders.
  **Failure Mode** (subtle_but_fair, INFERRABLE, 5 runs):
  > Type-use annotations or unresolved nested model names produced invalid Java source.
  **Failure Mode** (genuinely_hard, EXPLICIT, 4 runs):
  > Global eligibility or model analysis crashed or admitted unreconstructible existing types.

### ❌ PublicApiAndScalarRoundTrips

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers scalarRoundTrip and boxedScalarsRoundTrip: public instance writeTo, public static readFrom, compatible return type, and all primitive and boxed scalar values.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ SerialArtifactActivation

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers serialArtifactControlsActivation by compiling a fresh value-only probe and verifying binary methods appear only when org.immutables:serial is present.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ AttributeTagCollisionSafety

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers distinctNamesWithCollidingHashCodesNeverCorruptTheForm and collidingDerivedTagsNeverProduceACorruptForm for builder and constructor values.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ EligibilityAuxiliaryAndMethodConflicts

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers requiredAuxiliaryAttributeDisablesBinaryForm and existingBinarySignatureIsPreservedWithoutPartialForm.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ StandardContainersAndFactories

- **Tests:** 3 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers containerRoundTrip, emptyContainersRoundTrip, and factoryBackedContainersAndOptionalsRoundTrip for JDK and Guava list, set, map, and optional inputs.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ ForwardUnknownAttributeSkipping

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers forwardReaderSkipsUnknownNewerAttributes for builder and constructor readers, including an unknown field between known fields.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ BackwardMissingAttributeDefaults

- **Tests:** 1 | **Pass Rate:** 7% | **Runs:** 1 passed, 13 failed | **Fairness:** fair
- Covers backwardReaderDefaultsMissingOlderAttributes for builder values and constructor primitive, list, map, and optional defaults.

  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > A near-complete implementation treated a missing constructor primitive as incomplete input.
  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ NameBasedMatchingOrderAndRename

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers attributesMatchByNameNotDeclarationOrder and renamedAttributeIsTreatedAsAbsentNotMatchedByPosition.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ AttributeTypeMismatchAsAbsent

- **Tests:** 1 | **Pass Rate:** 7% | **Runs:** 1 passed, 13 failed | **Fairness:** fair
- Covers changedAttributeTypeIsTreatedAsAbsentNotMisdecoded for builder scalar mismatch and constructor scalar/container mismatches.

  **Failure Mode** (genuinely_hard, EXPLICIT, 1 runs):
  > The near-pass rejected a mismatched constructor scalar instead of defaulting it.
  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ ContainerShapeAndElementMismatch

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers changedScalarContainerShapeIsTreatedAsAbsent and changedContainerElementTypeIsTreatedAsAbsent.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ MapKeyAndValueMismatch

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers changedMapKeyTypeIsTreatedAsAbsent and changedMapValueTypeIsTreatedAsAbsent.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ DerivedAndAuxiliaryOmission

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers derivedAndAuxiliaryAttributesAreNotStored, verifying recomputation and normal auxiliary defaults.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ EnumShapesAndReordering

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers enumAttributesRoundTripInEveryPosition and enumRecoveredByConstantNameAcrossReorderedConstants.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ PrimitiveAndReferenceArrays

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers arraysRoundTrip for byte and int arrays plus String, boxed Integer, and enum reference arrays by contents.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ SpecializedCollectionShapes

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers bagsPreserveCountsKindAndOrder for multisets, bimaps, sorted sets, multimaps, list/set multimaps, and sorted maps.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ OptionalFlavors

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers optionalFlavorsRoundTripPresentAndAbsent for OptionalInt, OptionalLong, OptionalDouble, JDK Optional, and Guava Optional.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ DirectAndCrossPackageNestedValues

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers nestedValueRoundTrips and crossPackageNestedImmutableRoundTrips for direct acyclic generated immutable attributes.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ RecursiveGraphIsolation

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers recursiveNestedGraphDoesNotBlockUnrelatedValues, requiring pairwise method generation and continued support for an unrelated eligible sibling.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ GenericValueTypesAndNestedGenerics

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers genericValueTypeRoundTrips and nestedGenericValueTypeRoundTrips, including concrete type arguments on a direct nested immutable.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ NestedVersionSkewFraming

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers renamedNestedReaderSupportsVersionSkewWithoutDesync in both upgrade directions while preserving a following outer trailer attribute.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ ConstructorBuiltRoundTrips

- **Tests:** 2 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers constructorBuiltValueRoundTrips and constructorBuiltValueWithVariedShapesRoundTrips for parameter scalars, enums, optionals, lists, sets, and maps; optional extensions are pairwise guarded.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ UnsupportedShapeRejection

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers typeWithUnrepresentableAttributeHasNoBinaryForm for Object, unresolved type variables, nested opaque values, arrays of arrays, and collections of collections, while ensuring an unrelated scalar type still works.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ NullableAttributeSafety

- **Tests:** 1 | **Pass Rate:** 7% | **Runs:** 1 passed, 13 failed | **Fairness:** fair
- Covers nullableAttributeEitherRoundTripsOrDisablesBinaryForm for nullable String and nullable direct nested immutable attributes, accepting safe support or complete rejection.

  **Failure Mode** (subtle_but_fair, INFERRABLE, 1 runs):
  > The near-pass generated methods for nullable nested values but dereferenced null during writeTo.
  **Failure Mode** (subtle_but_fair, INFERRABLE, 12 runs):
  > One compile-failing implementation crashed directly on nullable scalar analysis; the remaining compile failures were separate regressions.

### ❌ LongStringEncoding

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers veryLongStringRoundTrips with a multi-byte string far beyond DataOutput.writeUTF’s 65,535-byte limit.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ NamelessWireFormat

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers wireCarriesNoAttributeNames by checking that a distinctive attribute name is absent from encoded bytes.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

### ❌ TruncatedInputFailure

- **Tests:** 1 | **Pass Rate:** 14% | **Runs:** 2 passed, 12 failed | **Fairness:** fair
- Covers truncatedDataFailsInsteadOfProducingAValue by removing final bytes and requiring an IOException cause.

  **Failure Mode** (genuinely_hard, INFERRABLE, 12 runs):
  > Twelve implementations failed the clean serial-enabled processor build before this focused group executed.

## Failure Patterns

### Pattern 1: Generated readFrom methods used a concrete immutable return type incompatible with custom builder build() signatures.

- **Type:** shared_blind_spot | **Affected Runs:** 3 | **Hint Candidate:** No
- **Affected Test Groups:** BaselineValueFixtureRegression, PublicApiAndScalarRoundTrips, ConstructorBuiltRoundTrips
- **Analysis:** Three independent implementations made the same narrow return-type assumption. This is a shared processor-integration blind spot, but repository model analysis or a clean value-fixture build reveals it.

### Pattern 2: TypeMirror text was inserted directly into class literals, preserving type-use annotations and producing invalid Java.

- **Type:** subtle_but_fair | **Affected Runs:** 4 | **Hint Candidate:** No
- **Affected Test Groups:** BaselineValueFixtureRegression, PrimitiveAndReferenceArrays
- **Analysis:** Four runs missed existing type-use-annotated primitive/array fixtures. This is subtle annotation-processing work; a hint would reveal a specific implementation trap rather than remove incidental friction.

### Pattern 3: Nested immutable resolution emitted sentinel names or called binary methods on ineligible nested types.

- **Type:** genuinely_hard | **Affected Runs:** 4 | **Hint Candidate:** No
- **Affected Test Groups:** BaselineValueFixtureRegression, DirectAndCrossPackageNestedValues, NestedVersionSkewFraming, UnsupportedShapeRejection
- **Analysis:** These implementations did not integrate nested eligibility with the processor’s generated-name model. Direct nesting and conservative rejection are explicit, while repository mechanics are legitimately difficult.

### Pattern 4: Eligibility analysis crashed globally or admitted models whose construction APIs were not supported.

- **Type:** genuinely_hard | **Affected Runs:** 4 | **Hint Candidate:** No
- **Affected Test Groups:** BaselineValueFixtureRegression, UnsupportedShapeRejection, NullableAttributeSafety
- **Analysis:** Failures include an unsafe Element cast, nullable-type assertion, missing custom collection setters, and invalid scalar defaults. These are substantive all-or-nothing eligibility defects.

### Pattern 5: Constructor readers confused versioned absence with incomplete input.

- **Type:** genuinely_hard | **Affected Runs:** 1 | **Hint Candidate:** No
- **Affected Test Groups:** BackwardMissingAttributeDefaults, AttributeTypeMismatchAsAbsent
- **Analysis:** The near-pass threw EOFException for absent or mismatched constructor count fields rather than supplying zero. This distinction is explicit and central to compatibility.

### Pattern 6: Nullable direct nested values were classified as supported but written with an unconditional dereference.

- **Type:** subtle_but_fair | **Affected Runs:** 1 | **Hint Candidate:** No
- **Affected Test Groups:** NullableAttributeSafety
- **Analysis:** Nullable support is optional and the test allows rejection. Once methods are generated, faithful behavior is required, making this subtle but fair.

## Top Passing Runs

### Run 1 (PASS) ✅

**Strategy:** Passed all 326 baseline tests and all 38 new tests with a substantive runtime and processor implementation plus independent serial-module tests. The patch differs architecturally from the reference and contains no verifier identifiers or test manipulation.

**True Positive Analysis:** The implementation survives the full existing fixture corpus, supports all required evolution paths and shapes, and is not hardcoded to hidden fixtures. Evaluator review found no cheating.

### Run 2 (FAIL) ❌

**Strategy:** Passed all baseline tests and 35 of 38 new tests. Its failures are narrowly explained by explicit constructor default-on-absence semantics and a nullable nested value admitted without null-safe encoding.

## Submission Readiness ✅

**Can Submit:** Yes

| Criterion | Status | Detail |
|-----------|--------|--------|
| ✅ Prechecks | pass | 5/5 passing |
| ✅ Quality Checks | pass | 7/7 passing |
| ✅ Fair task | pass | No fairness issues |
| ✅ Solvable | pass | 1/14 solved |
| ✅ Difficulty | pass | 7% — Hard |
| ✅ Long-horizon | pass | Median files: 8, messages: 180, LOC: 1791 |
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
    "completedAt": 1784481173978,
    "createdAt": 1784480369461,
    "currentStep": "Completed",
    "jobId": "nx7033wsfqbf2j5w8x8naqtbhn8av3yv"
  },
  "verdict": "PASS",
  "reviewer_notes": "This is ready to ship. One of 14 completed rollouts passed all 326 baseline tests and all 38 focused tests with an independent, substantive implementation; a second rollout passed baseline and 35/38 focused tests. The 7.1% pass rate reflects genuine annotation-processor and wire-compatibility difficulty, not ambiguity. The twelve early failures are concrete clean-build regressions: three assumed custom builders return the immutable implementation, four mishandled type-use annotations in class literals, several misresolved nested generated types, and two crashed global eligibility analysis.\n\nThe three runtime failures in rd700pznbyhj6447dpz6fpz83x8av3mb are also fair. backwardReaderDefaultsMissingOlderAttributes (test.patch line 1455) and changedAttributeTypeIsTreatedAsAbsentNotMisdecoded (line 1483) enforce the explicit rule that constructor fields missing through version skew or type mismatch receive normal defaults. nullableAttributeEitherRoundTripsOrDisablesBinaryForm (line 1755) permits complete rejection; the rollout failed only because it generated the pair and then dereferenced a null nested value. These are valid implementation misses, not hidden conventions.\n\nCoverage is broad and behavior-focused. The conditional BinCtorDefaulted branch is correct rather than a false negative: its defaulted size field is stored but is not a constructor parameter, so it falls outside the minimum constructor-built surface and other reconstructible constructor forms may, not must, be supported. A future strengthening could isolate constructor map-value mismatch separately, but current coverage is sufficient for fairness. The reference is concise, regression-clean, and shows no test-gaming, plagiarism, or AI slop.",
  "checklist": {
    "total": 25,
    "pass_count": 25,
    "fail_count": 0,
    "items": [
      {
        "item": "Requirements complete and self-contained",
        "reasoning": "The description specifies activation, API signatures, supported and unsupported shapes, compatibility, nesting, constructor behavior, conflicts, omission, and malformed input. Rollout failures map to these contracts.",
        "verdict": "pass"
      },
      {
        "item": "No ambiguities, fully deterministic",
        "reasoning": "The minimum required surface is precise. Optional nullable and extra constructor forms may be rejected, and tests use pairwise method checks where support is optional.",
        "verdict": "pass"
      },
      {
        "item": "Concise and not prescriptive",
        "reasoning": "The description is long because the compatibility surface is large, but it states observable behavior without mandating a tag hash, framing helper, or generator architecture.",
        "verdict": "pass"
      },
      {
        "item": "Matches real-world repo scope",
        "reasoning": "This is realistic processor/runtime engineering in the existing serial and value modules rather than a contrived exercise.",
        "verdict": "pass"
      },
      {
        "item": "Aligns with repo design philosophy",
        "reasoning": "The feature is classpath-gated through the existing serial artifact pattern and uses the established generator/meta-model layers without a new annotation.",
        "verdict": "pass"
      },
      {
        "item": "No irrelevant context",
        "reasoning": "Each paragraph defines eligibility, compatibility, supported shapes, nesting, or omission behavior used by tests.",
        "verdict": "pass"
      },
      {
        "item": "Clear writing and formatting",
        "reasoning": "The prose is dense but terminology is consistent and constraints are concrete enough for an independent successful implementation.",
        "verdict": "pass"
      },
      {
        "item": "New tests highlight missing or incorrect behavior",
        "reasoning": "The 38 focused tests fail on the base state and pass with the reference and one independent rollout.",
        "verdict": "pass"
      },
      {
        "item": "Tests are deterministic",
        "reasoning": "Tests use fixed values, in-memory streams, reflection, and a controlled compiler probe; automated flakiness verification passed.",
        "verdict": "pass"
      },
      {
        "item": "Assertions verify the correct output",
        "reasoning": "They compare full values or array contents, inspect preserved/defaulted fields, verify API modifiers, and require IOException for malformed input.",
        "verdict": "pass"
      },
      {
        "item": "Tests validate behavior, not internals",
        "reasoning": "They call generated public APIs and observe bytes or reconstructed values. The activation probe checks only absence of the two named signatures.",
        "verdict": "pass"
      },
      {
        "item": "Tests follow repo structure",
        "reasoning": "Fixtures and JUnit 5 tests are under value-fixture/test using existing Checkers and Maven/Surefire conventions.",
        "verdict": "pass"
      },
      {
        "item": "Tests cover required behavior and edge cases",
        "reasoning": "Coverage spans activation, conflicts, types, version skew, collisions, nesting, recursion, constructors, unsupported shapes, long strings, and truncation. Constructor map-value mismatch is not isolated, but combined constructor and dedicated builder mismatch tests are strong coverage.",
        "verdict": "pass"
      },
      {
        "item": "Test suite is concise",
        "reasoning": "Each test targets a distinct contract or shape family; repeated scalar round-trips serve as isolation sentinels for unsupported models.",
        "verdict": "pass"
      },
      {
        "item": "Tests do not check unspecified behavior",
        "reasoning": "Mandatory assertions map to the description, while collision, nullable, nested-constructor, and defaulted-nonconstructor extensions allow complete rejection.",
        "verdict": "pass"
      },
      {
        "item": "Solution meets all requirements",
        "reasoning": "The reference passes all tests and implements gating, nameless framed fields, codecs, compatibility, nesting, collision rejection, and conservative eligibility. Rejecting BinCtorDefaulted is allowed because its stored defaulted field is not a constructor parameter.",
        "verdict": "pass"
      },
      {
        "item": "No regressions, code follows patterns",
        "reasoning": "Verification reports all 326 baseline and 38 new tests passing, with changes localized to serial runtime, templates, and metadata.",
        "verdict": "pass"
      },
      {
        "item": "No unexplained defensive code",
        "reasoning": "Eligibility guards correspond to unsupported, recursive, conflicting, auxiliary, and collision cases; framing supports compatibility and truncation safety.",
        "verdict": "pass"
      },
      {
        "item": "No irrelevant changes",
        "reasoning": "The reference modifies four task-related production files without unrelated refactors or fixture-specific hacks.",
        "verdict": "pass"
      },
      {
        "item": "API contracts remain stable",
        "reasoning": "Only the requested generated pair is added, gated by serial presence and suppressed when either signature conflicts.",
        "verdict": "pass"
      },
      {
        "item": "No AI slop",
        "reasoning": "The reference is compact, purposeful, and consistent with existing generator idioms, without verbose boilerplate or hallucinated dependencies.",
        "verdict": "pass"
      },
      {
        "item": "No plagiarism",
        "reasoning": "Automated integrity checks found no leaked, duplicate, or derivative public solution.",
        "verdict": "pass"
      },
      {
        "item": "No unreasonable assumptions in tests",
        "reasoning": "Tests accept alternative safe implementations and do not require reference helper names, exact bytes, exact tags, or concrete collection classes.",
        "verdict": "pass"
      },
      {
        "item": "No trivial or unfair failure patterns",
        "reasoning": "Failures are substantive generated-code integration or explicit compatibility defects, not test-runner discovery, flaky timing, or brittle strings.",
        "verdict": "pass"
      },
      {
        "item": "Hint is appropriate if present",
        "reasoning": "No hint is present. One rollout passes legitimately, and common failures are substantive rather than incidental blockers, so no hint is needed.",
        "verdict": "pass"
      }
    ]
  },
  "detailed_analysis": {
    "test_groups": [
      {
        "category": "regression",
        "description": "Runs the 326 pre-existing value-fixture tests after a clean serial-enabled processor build to ensure generated code still compiles and existing behavior is preserved.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd755zan1afh7at217a2pvr05h8avzjp"
            ],
            "classification": "INFERRABLE",
            "description": "Generated readFrom return types were incompatible with customized builders.",
            "explanation_type": "genuinely_hard",
            "reasoning": "These implementations declared the concrete immutable return type but returned builder.build(), which is typed as the abstract value for several visible custom styles. This is discoverable from the repository and clean compilation."
          },
          {
            "affected_runs": [
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8"
            ],
            "classification": "INFERRABLE",
            "description": "Type-use annotations or unresolved nested model names produced invalid Java source.",
            "explanation_type": "subtle_but_fair",
            "reasoning": "The processors rendered TypeMirror text into class literals or emitted sentinel nested names. Handling the repository’s diverse type model is subtle but normal annotation-processor engineering."
          },
          {
            "affected_runs": [
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "EXPLICIT",
            "description": "Global eligibility or model analysis crashed or admitted unreconstructible existing types.",
            "explanation_type": "genuinely_hard",
            "reasoning": "These runs crashed on executable-backed or nullable models, or generated readers assuming unavailable setters and invalid defaults. The prompt explicitly requires unsupported shapes not to block unrelated values."
          }
        ],
        "fairness_reasoning": "A feature activated broadly by the serial artifact must survive the repository’s existing model corpus. The clean-build regression gate is behavior-level and exposed substantive processor defects rather than test-runner trivia.",
        "fairness_verdict": "fair",
        "group_name": "BaselineValueFixtureRegression",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 326
      },
      {
        "category": "new_behavior",
        "description": "Covers scalarRoundTrip and boxedScalarsRoundTrip: public instance writeTo, public static readFrom, compatible return type, and all primitive and boxed scalar values.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The signatures and scalar support are stated verbatim in the task; reflection checks only the public contract.",
        "fairness_verdict": "fair",
        "group_name": "PublicApiAndScalarRoundTrips",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers serialArtifactControlsActivation by compiling a fresh value-only probe and verifying binary methods appear only when org.immutables:serial is present.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The opening sentences define this exact activation contract. The compiler probe observes generated API rather than private internals.",
        "fairness_verdict": "fair",
        "group_name": "SerialArtifactActivation",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers distinctNamesWithCollidingHashCodesNeverCorruptTheForm and collidingDerivedTagsNeverProduceACorruptForm for builder and constructor values.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The task explicitly forbids conflating distinct attributes. Tests allow either a safe pair or no pair and do not mandate a tag algorithm.",
        "fairness_verdict": "fair",
        "group_name": "AttributeTagCollisionSafety",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers requiredAuxiliaryAttributeDisablesBinaryForm and existingBinarySignatureIsPreservedWithoutPartialForm.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "Both all-or-nothing eligibility rules are explicit and the assertions preserve inherited or declared APIs.",
        "fairness_verdict": "fair",
        "group_name": "EligibilityAuxiliaryAndMethodConflicts",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers containerRoundTrip, emptyContainersRoundTrip, and factoryBackedContainersAndOptionalsRoundTrip for JDK and Guava list, set, map, and optional inputs.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The supported shapes and factory interoperability are explicit; equality checks do not require a concrete collection implementation.",
        "fairness_verdict": "fair",
        "group_name": "StandardContainersAndFactories",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 3
      },
      {
        "category": "new_behavior",
        "description": "Covers forwardReaderSkipsUnknownNewerAttributes for builder and constructor readers, including an unknown field between known fields.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "This directly tests the stated requirement that unknown fields be skipped without desynchronizing later fields.",
        "fairness_verdict": "fair",
        "group_name": "ForwardUnknownAttributeSkipping",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers backwardReaderDefaultsMissingOlderAttributes for builder values and constructor primitive, list, map, and optional defaults.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd700pznbyhj6447dpz6fpz83x8av3mb"
            ],
            "classification": "EXPLICIT",
            "description": "A near-complete implementation treated a missing constructor primitive as incomplete input.",
            "explanation_type": "genuinely_hard",
            "reasoning": "Its reader threw EOFException for missing count instead of supplying the normal primitive default zero. The description explicitly says missing attributes take normal defaults and applies this to supported constructor-built values."
          },
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The count assertion at test.patch line 1455 directly implements the explicit constructor compatibility rule. Distinguishing absent versioned data from truncated framing is difficult but essential.",
        "fairness_verdict": "fair",
        "group_name": "BackwardMissingAttributeDefaults",
        "pass_rate_across_rollouts": 0.0714285714,
        "rollout_results": {
          "failed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers attributesMatchByNameNotDeclarationOrder and renamedAttributeIsTreatedAsAbsentNotMatchedByPosition.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The description states both rules almost word for word and does not require a particular stable-tag implementation.",
        "fairness_verdict": "fair",
        "group_name": "NameBasedMatchingOrderAndRename",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers changedAttributeTypeIsTreatedAsAbsentNotMisdecoded for builder scalar mismatch and constructor scalar/container mismatches.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd700pznbyhj6447dpz6fpz83x8av3mb"
            ],
            "classification": "EXPLICIT",
            "description": "The near-pass rejected a mismatched constructor scalar instead of defaulting it.",
            "explanation_type": "genuinely_hard",
            "reasoning": "After recognizing a type mismatch for count, the reader treated the constructor parameter as missing-required and threw EOFException. The prompt explicitly defines mismatch as absence for constructor values."
          },
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The test at test.patch line 1483 directly exercises the explicit mismatch-as-absence rule and accepts normal empty/default constructor values.",
        "fairness_verdict": "fair",
        "group_name": "AttributeTypeMismatchAsAbsent",
        "pass_rate_across_rollouts": 0.0714285714,
        "rollout_results": {
          "failed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers changedScalarContainerShapeIsTreatedAsAbsent and changedContainerElementTypeIsTreatedAsAbsent.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "Mismatched container elements are explicit, and scalar-versus-container shape changes are a direct application of writer/reader type mismatch.",
        "fairness_verdict": "fair",
        "group_name": "ContainerShapeAndElementMismatch",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers changedMapKeyTypeIsTreatedAsAbsent and changedMapValueTypeIsTreatedAsAbsent.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The tests separately isolate the explicit map key and value mismatch clauses and expect the normal empty attribute value.",
        "fairness_verdict": "fair",
        "group_name": "MapKeyAndValueMismatch",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers derivedAndAuxiliaryAttributesAreNotStored, verifying recomputation and normal auxiliary defaults.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The final paragraph specifies this behavior exactly, and the test compares observable reconstructed values.",
        "fairness_verdict": "fair",
        "group_name": "DerivedAndAuxiliaryOmission",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers enumAttributesRoundTripInEveryPosition and enumRecoveredByConstantNameAcrossReorderedConstants.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "Enum name recovery after reordering and enum use in scalar, optional, list, and map-key positions are explicitly required.",
        "fairness_verdict": "fair",
        "group_name": "EnumShapesAndReordering",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers arraysRoundTrip for byte and int arrays plus String, boxed Integer, and enum reference arrays by contents.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The hidden fixture stays inside the required array surface and uses Arrays.equals, while annotated-array compile failures came from baseline integration rather than an unfair assertion.",
        "fairness_verdict": "fair",
        "group_name": "PrimitiveAndReferenceArrays",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers bagsPreserveCountsKindAndOrder for multisets, bimaps, sorted sets, multimaps, list/set multimaps, and sorted maps.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The task enumerates every tested shape and calls out multiset counts and multimap multiplicity. Value equality avoids pinning the wire format.",
        "fairness_verdict": "fair",
        "group_name": "SpecializedCollectionShapes",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers optionalFlavorsRoundTripPresentAndAbsent for OptionalInt, OptionalLong, OptionalDouble, JDK Optional, and Guava Optional.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "Every tested optional kind and presence semantics are listed explicitly in the task.",
        "fairness_verdict": "fair",
        "group_name": "OptionalFlavors",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers nestedValueRoundTrips and crossPackageNestedImmutableRoundTrips for direct acyclic generated immutable attributes.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The fixtures stay within the expressly required direct, acyclic surface and avoid nested values inside containers.",
        "fairness_verdict": "fair",
        "group_name": "DirectAndCrossPackageNestedValues",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers recursiveNestedGraphDoesNotBlockUnrelatedValues, requiring pairwise method generation and continued support for an unrelated eligible sibling.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The task explicitly requires recursive shapes to receive neither method and not prevent unrelated eligible values; the test permissively accepts rejection.",
        "fairness_verdict": "fair",
        "group_name": "RecursiveGraphIsolation",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers genericValueTypeRoundTrips and nestedGenericValueTypeRoundTrips, including concrete type arguments on a direct nested immutable.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The prompt clearly allows generic declarations and concrete nested arguments while excluding unresolved type-variable attributes.",
        "fairness_verdict": "fair",
        "group_name": "GenericValueTypesAndNestedGenerics",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers renamedNestedReaderSupportsVersionSkewWithoutDesync in both upgrade directions while preserving a following outer trailer attribute.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The trailer assertion is the observable form of the explicit rule that nested version changes must not desynchronize following outer attributes.",
        "fairness_verdict": "fair",
        "group_name": "NestedVersionSkewFraming",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers constructorBuiltValueRoundTrips and constructorBuiltValueWithVariedShapesRoundTrips for parameter scalars, enums, optionals, lists, sets, and maps; optional extensions are pairwise guarded.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The mandatory fixtures exactly match the minimum constructor surface. BinCtorDefaulted is conditional because its stored defaulted field is not a constructor parameter and therefore lies outside that minimum.",
        "fairness_verdict": "fair",
        "group_name": "ConstructorBuiltRoundTrips",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 2
      },
      {
        "category": "new_behavior",
        "description": "Covers typeWithUnrepresentableAttributeHasNoBinaryForm for Object, unresolved type variables, nested opaque values, arrays of arrays, and collections of collections, while ensuring an unrelated scalar type still works.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "Every rejected fixture is named in the outside-required-surface list; the sibling assertion fairly enforces the explicit isolation requirement.",
        "fairness_verdict": "fair",
        "group_name": "UnsupportedShapeRejection",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers nullableAttributeEitherRoundTripsOrDisablesBinaryForm for nullable String and nullable direct nested immutable attributes, accepting safe support or complete rejection.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd700pznbyhj6447dpz6fpz83x8av3mb"
            ],
            "classification": "INFERRABLE",
            "description": "The near-pass generated methods for nullable nested values but dereferenced null during writeTo.",
            "explanation_type": "subtle_but_fair",
            "reasoning": "Nullable support is not mandatory, but once the form was generated, faithful reconstruction and all-or-nothing eligibility required null safety. The test also allows complete rejection."
          },
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "One compile-failing implementation crashed directly on nullable scalar analysis; the remaining compile failures were separate regressions.",
            "explanation_type": "subtle_but_fair",
            "reasoning": "rd7f6 asserted on an annotated nullable String instead of rejecting it. The other failures remain agent-caused generated-source defects."
          }
        ],
        "fairness_reasoning": "The test at test.patch line 1755 is deliberately permissive: nullable support is optional, but a generated pair must faithfully handle null.",
        "fairness_verdict": "fair",
        "group_name": "NullableAttributeSafety",
        "pass_rate_across_rollouts": 0.0714285714,
        "rollout_results": {
          "failed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers veryLongStringRoundTrips with a multi-byte string far beyond DataOutput.writeUTF’s 65,535-byte limit.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The prompt explicitly requires strings of any length. The deterministic test targets a common pitfall without prescribing an encoding.",
        "fairness_verdict": "fair",
        "group_name": "LongStringEncoding",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers wireCarriesNoAttributeNames by checking that a distinctive attribute name is absent from encoded bytes.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The no-attribute-names rule is explicit, and the test does not constrain numeric tags, framing, or exact bytes.",
        "fairness_verdict": "fair",
        "group_name": "NamelessWireFormat",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      },
      {
        "category": "new_behavior",
        "description": "Covers truncatedDataFailsInsteadOfProducingAValue by removing final bytes and requiring an IOException cause.",
        "failure_modes": [
          {
            "affected_runs": [
              "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
              "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
              "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
              "rd74jphd16kejshbykzx0pdt598at1yr",
              "rd755zan1afh7at217a2pvr05h8avzjp",
              "rd75cw27c9cbd70gba018721dd8avv9g",
              "rd766xktkzz1wcbwabsekp1vbd8ats2v",
              "rd774ffrrneq1a4t7yap2jw45h8avefq",
              "rd79zwk67jcq4zphrv31vs2kp98atbb4",
              "rd7a83fj866epxax1pnt75qe218ataqt",
              "rd7b4sqneteabx8xxzmzj4sann8av7v8",
              "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
            ],
            "classification": "INFERRABLE",
            "description": "Twelve implementations failed the clean serial-enabled processor build before this focused group executed.",
            "explanation_type": "genuinely_hard",
            "reasoning": "The failures were agent-caused generated-source defects: incompatible custom-builder return types, invalid type-use-annotated class literals, unresolved nested implementation names, unsafe eligibility, or processor crashes. They do not indicate an unstated expectation in this group."
          }
        ],
        "fairness_reasoning": "The description directly requires incomplete input to error rather than produce a wrong value; any IOException subtype is accepted.",
        "fairness_verdict": "fair",
        "group_name": "TruncatedInputFailure",
        "pass_rate_across_rollouts": 0.1428571429,
        "rollout_results": {
          "failed": [
            "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
            "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
            "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
            "rd74jphd16kejshbykzx0pdt598at1yr",
            "rd755zan1afh7at217a2pvr05h8avzjp",
            "rd75cw27c9cbd70gba018721dd8avv9g",
            "rd766xktkzz1wcbwabsekp1vbd8ats2v",
            "rd774ffrrneq1a4t7yap2jw45h8avefq",
            "rd79zwk67jcq4zphrv31vs2kp98atbb4",
            "rd7a83fj866epxax1pnt75qe218ataqt",
            "rd7b4sqneteabx8xxzmzj4sann8av7v8",
            "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
          ],
          "passed": [
            "rd700pznbyhj6447dpz6fpz83x8av3mb",
            "rd759q119txqbbegqf7dg4mrvd8atg6b"
          ]
        },
        "total_tests_in_group": 1
      }
    ],
    "failure_patterns": [
      {
        "affected_runs": [
          "rd70x0g9e1vzp5jgb1mac1gken8avrsb",
          "rd7133nnr8d6swfaje8m6gyy8x8atn4g",
          "rd755zan1afh7at217a2pvr05h8avzjp"
        ],
        "affected_test_groups": [
          "BaselineValueFixtureRegression",
          "PublicApiAndScalarRoundTrips",
          "ConstructorBuiltRoundTrips"
        ],
        "description": "Generated readFrom methods used a concrete immutable return type incompatible with custom builder build() signatures.",
        "explanation_type": "shared_blind_spot",
        "hint_candidate": false,
        "reasoning": "Three independent implementations made the same narrow return-type assumption. This is a shared processor-integration blind spot, but repository model analysis or a clean value-fixture build reveals it."
      },
      {
        "affected_runs": [
          "rd74jphd16kejshbykzx0pdt598at1yr",
          "rd79zwk67jcq4zphrv31vs2kp98atbb4",
          "rd7a83fj866epxax1pnt75qe218ataqt",
          "rd7b4sqneteabx8xxzmzj4sann8av7v8"
        ],
        "affected_test_groups": [
          "BaselineValueFixtureRegression",
          "PrimitiveAndReferenceArrays"
        ],
        "description": "TypeMirror text was inserted directly into class literals, preserving type-use annotations and producing invalid Java.",
        "explanation_type": "subtle_but_fair",
        "hint_candidate": false,
        "reasoning": "Four runs missed existing type-use-annotated primitive/array fixtures. This is subtle annotation-processing work; a hint would reveal a specific implementation trap rather than remove incidental friction."
      },
      {
        "affected_runs": [
          "rd74jphd16kejshbykzx0pdt598at1yr",
          "rd75cw27c9cbd70gba018721dd8avv9g",
          "rd766xktkzz1wcbwabsekp1vbd8ats2v",
          "rd774ffrrneq1a4t7yap2jw45h8avefq"
        ],
        "affected_test_groups": [
          "BaselineValueFixtureRegression",
          "DirectAndCrossPackageNestedValues",
          "NestedVersionSkewFraming",
          "UnsupportedShapeRejection"
        ],
        "description": "Nested immutable resolution emitted sentinel names or called binary methods on ineligible nested types.",
        "explanation_type": "genuinely_hard",
        "hint_candidate": false,
        "reasoning": "These implementations did not integrate nested eligibility with the processor’s generated-name model. Direct nesting and conservative rejection are explicit, while repository mechanics are legitimately difficult."
      },
      {
        "affected_runs": [
          "rd71n0gdtsd2nxb1mvz6hbfazs8at24s",
          "rd75cw27c9cbd70gba018721dd8avv9g",
          "rd766xktkzz1wcbwabsekp1vbd8ats2v",
          "rd7f6gfpaxc2dpynhgrm5rnns58at75r"
        ],
        "affected_test_groups": [
          "BaselineValueFixtureRegression",
          "UnsupportedShapeRejection",
          "NullableAttributeSafety"
        ],
        "description": "Eligibility analysis crashed globally or admitted models whose construction APIs were not supported.",
        "explanation_type": "genuinely_hard",
        "hint_candidate": false,
        "reasoning": "Failures include an unsafe Element cast, nullable-type assertion, missing custom collection setters, and invalid scalar defaults. These are substantive all-or-nothing eligibility defects."
      },
      {
        "affected_runs": [
          "rd700pznbyhj6447dpz6fpz83x8av3mb"
        ],
        "affected_test_groups": [
          "BackwardMissingAttributeDefaults",
          "AttributeTypeMismatchAsAbsent"
        ],
        "description": "Constructor readers confused versioned absence with incomplete input.",
        "explanation_type": "genuinely_hard",
        "hint_candidate": false,
        "reasoning": "The near-pass threw EOFException for absent or mismatched constructor count fields rather than supplying zero. This distinction is explicit and central to compatibility."
      },
      {
        "affected_runs": [
          "rd700pznbyhj6447dpz6fpz83x8av3mb"
        ],
        "affected_test_groups": [
          "NullableAttributeSafety"
        ],
        "description": "Nullable direct nested values were classified as supported but written with an unconditional dereference.",
        "explanation_type": "subtle_but_fair",
        "hint_candidate": false,
        "reasoning": "Nullable support is optional and the test allows rejection. Once methods are generated, faithful behavior is required, making this subtle but fair."
      }
    ],
    "top_runs": [
      {
        "is_true_positive": true,
        "reasoning": "Passed all 326 baseline tests and all 38 new tests with a substantive runtime and processor implementation plus independent serial-module tests. The patch differs architecturally from the reference and contains no verifier identifiers or test manipulation.",
        "run_id": "rd759q119txqbbegqf7dg4mrvd8atg6b",
        "true_positive_reasoning": "The implementation survives the full existing fixture corpus, supports all required evolution paths and shapes, and is not hardcoded to hidden fixtures. Evaluator review found no cheating.",
        "verdict": "pass"
      },
      {
        "reasoning": "Passed all baseline tests and 35 of 38 new tests. Its failures are narrowly explained by explicit constructor default-on-absence semantics and a nullable nested value admitted without null-safe encoding.",
        "run_id": "rd700pznbyhj6447dpz6fpz83x8av3mb",
        "verdict": "fail"
      }
    ]
  },
  "extra_fields": {
    "confidence": 0.94,
    "hint_suggestions": [],
    "pass_rate": 0.0714285714,
    "total_runs": 14,
    "verdict_reasoning": "There are 14 completed runs, including one legitimate full pass, so the task is neither insufficient nor impossible. The 7.1% pass rate is appropriately difficult. Every observed failure is explained by an explicit or reasonably inferable engineering requirement, tests accept alternative safe implementations, and the reference passes baseline and focused suites cleanly."
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
        "detail": "1/14 solved",
        "id": "agentSolvable",
        "label": "Solvable",
        "status": "pass"
      },
      {
        "detail": "7% — Hard",
        "id": "agentDifficulty",
        "label": "Difficulty",
        "status": "pass"
      },
      {
        "detail": "Median files: 8, messages: 180, LOC: 1791",
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
