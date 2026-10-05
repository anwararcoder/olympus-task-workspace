**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥40 messages, ≥250 LOC

This task numbers: Median files: 10, messages: 340, LOC: 820

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "dea92d32510f4a0b3d67da98ec5279facda6f4cde2eaf7bcc28c97f60ea937d1",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Implements compact binary serialization for generated immutables when the serial module is present by generating writeTo(DataOutput) and static readFrom(DataInput) for eligible types. It adds generator templates, BinaryWire primitives, and meta logic to determine eligibility, compute field tags/type codes, and avoid conflicts with preexisting methods.",
      "confidence": 0.93,
      "contentAuthoredAt": 1782991288807,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds a new behavior for attributes annotated with both @Value.Lazy and @Value.Default: explicit seeding via builders/with-methods, preserved across copies, and special Modifiable behavior; candidate adds writeTo(DataOutput)/readFrom(DataInput) methods for eligible value types when the serial module is present.",
        "Submission modifies builder/from/copy code paths, lazy-field storage/bitmaps, and Modifiable accessors to track and preserve seed provenance; candidate generates binary serialization logic, type/field tagging, and element encoding/decoding, with a new BinaryWire utility.",
        "Submission changes meta processing to classify and validate seedable-lazy attributes (isGenerateSeedableLazy), require builders/with-methods, and prohibit with interned values; candidate changes meta to compute isGenerateBinary, per-attribute binary support/type codes, conflict detection with existing APIs, and eligibility modeling for constructor/builder cases.",
        "Submission updates Value.java Javadoc to document lazy+default semantics; candidate adds a new serial module class and no Javadoc changes to lazy/default."
      ],
      "one_liner": "Both changes extend Immutables code generation but one adds seedable lazy attributes while the other adds a compact binary write/read form for generated values.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both operate in the same repo and touch generator/meta code, they target different features and modified surfaces for different purposes: seedable lazy attribute seeding vs compact binary serialization methods. There are no shared introduced APIs, behaviors, or tests; the overlaps are only infrastructural (both edit the code generator) and do not represent the same task or debugging lesson.",
      "similarity": 0.6050481200218201,
      "submission_summary": "Implements support for seedable lazy attributes by treating @Value.Lazy + @Value.Default as a hybrid: builders and with-methods can set an explicit seed that bypasses the initializer and is preserved across toBuilder/from/copyOf and Modifiable conversions. It adds generator and meta wiring (flags, fields, bitmaps, copy/from paths) plus validation and Javadoc to enforce and describe this behavior.",
      "title": "Compact binary form for generated immutables",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Generates a structural diff/patch facility for immutable types: a nested Patch class plus diff, apply, and then methods that compute sparse per-attribute changes (including element-wise collection/map deltas and recursive diffs into nested immutables and optionals) and apply or compose them. Adds codegen and meta-layer support to detect nested immutable element/value types and gate generation with checked-exception propagation.",
      "confidence": 0.88,
      "contentAuthoredAt": 1782801753255,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission introduces a new attribute mode (Lazy+Default) that can be explicitly seeded via builder/with-methods and preserves seed provenance across copies; the candidate adds a nested Patch type and diff/apply/then methods to compute and apply sparse structural differences.",
        "Submission changes builder/from/copy and Modifiable accessors to track and preserve explicit seeds without invoking initializers; the candidate computes per-attribute differences (including collection/map element deltas and recursive diffs) and applies them, with no seed/lazy semantics.",
        "Submission updates annotation processing to treat Lazy+Default as a special seedable-lazy case and enforces builder/with-method presence; the candidate adds type-introspection support to find nested immutable element/value types and enable recursive patch generation."
      ],
      "one_liner": "Both extend the Immutables code generator, but one adds seedable lazy attributes (Lazy+Default seeding/preservation) while the other adds a structural diff/patch API (diff/apply/then) for immutable values.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both touch Immutables.generator and meta classes, they target unrelated features: seedable lazy initialization vs. structural diff/patch generation. There are no shared APIs or behaviors introduced; the overlapping files are repository boilerplate surfaces used for different purposes. Each teaches a distinct debugging lesson at different behavioral surfaces.",
      "similarity": 0.5508865154118263,
      "submission_summary": "Generates support for seedable lazy attributes when an accessor is annotated with both @Value.Lazy and @Value.Default: builders/with-methods can set an explicit value that bypasses initialization and is preserved through copy/from/toBuilder, with special handling in Modifiable types and serialization. Adds codegen and meta-layer flags/validation, tracking seed provenance via bitmaps and customizing builder/from/copy paths and with-methods.",
      "title": "Structural differences for generated immutables",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Adds a Pointers generator for @Value.Enclosing families, producing a companion class with parse/render of pointers and resolve/update over nested immutable values with precise error types. Integrates via a new template, a Processor hook, a PointerModel meta class, and ValueType accessors to enable generation.",
      "confidence": 0.97,
      "contentAuthoredAt": 1783890373543,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds a new seedable-lazy attribute mode (when @Value.Lazy is combined with @Value.Default), including builder/with-method seeding, preservation across copy/from/toBuilder, specialized modifiable accessors, serialization behavior, and extensive generator/meta wiring.",
        "Candidate adds a new generator for Pointers that parses/renders JSONPointer-like paths and resolves/updates nested immutable values within @Value.Enclosing families; integrates via a new Pointers.generator, Processor hook, and a PointerModel with isGeneratePointers gating.",
        "Submission’s modified surfaces are Immutables.generator, Modifiables.generator, meta collectors (AccessorAttributesCollector, ValueAttribute, ValueAttributeFunctions, ValueType, ValueTypeComposer) and annotation docs; Candidate’s modified surfaces are new Pointers generator/templates, Processor, a new PointerModel, and a small ValueType addition for pointer modeling.",
        "Behaviorally, submission affects attribute initialization semantics and provenance (seed vs computed) across builders/copies; candidate affects navigation and structural updates through string pointers, with distinct error semantics (MalformedPointerException, PointerMissException, PointerTypeException)."
      ],
      "one_liner": "They implement unrelated generated features: one adds seedable lazy attributes via @Value.Lazy + @Value.Default, the other introduces pointer parsing/resolution/update for @Value.Enclosing families.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Despite sharing the repo, the solutions target different features and code paths. The submission’s changes revolve around attribute initialization and builder/copy generation for a new seedable-lazy mode, while the candidate introduces a brand-new pointers facility with parsing, resolution, and update semantics for enclosing value families. The only file both touch (ValueType) is modified for unrelated purposes, so there is no purpose-matched surface overlap.",
      "similarity": 0.4813779294490814,
      "submission_summary": "Implements a seedable lazy attribute mode triggered by @Value.Lazy + @Value.Default: builders and with-methods can explicitly seed values, seeds are preserved across copy/from/toBuilder, unseeded values remain cold, and modifiable accessors return fresh fallbacks. Adds detection and constraints in meta (collector, flags, predicates, composer checks) and updates codegen templates and docs accordingly.",
      "title": "Pointers into Enclosed Value Families",
      "verdict": "distinct"
    },
    {
      "authorUsername": "igee",
      "candidate_summary": "Extends MapStruct to support Guava immutable collections/maps as mapping targets by generating code that builds the appropriate Guava builders from iterable/map-shaped sources, with diagnostics for unsupported shapes and @MappingTarget usage and checks for natural ordering for sorted types. It adds model/builders and utilities for Guava types, adjusts assignment/wrappers and type utilities, updates the mapper creation pipeline, and documents the feature.",
      "confidence": 0.94,
      "contentAuthoredAt": 1783929834023,
      "evalStatus": "ok",
      "evidence_gaps": [
        "Candidate patch is truncated, so some template/rendering details are not fully visible; however, the visible changes already establish a different feature and surface."
      ],
      "isOlder": true,
      "meaningful_differences": [
        "They target different repositories and generators: Immutables’ value processor/templates vs. MapStruct’s mapping model/processor and docs.",
        "Submission modifies Immutables’ annotation processing and codegen templates to support a hybrid @Value.Lazy+@Value.Default attribute that can be explicitly seeded via builders/with-methods and whose seed provenance is preserved across copy/from/toBuilder; candidate adds mapping-method generation to build Guava immutable containers from appropriate source shapes.",
        "Submission adds validation/constraints for the hybrid (requires builder/with-methods, disallows interned values), seed-bit tracking fields, modifiable accessor semantics (fresh fallback per unseeded access), and serialization behavior; candidate adds detection of Guava immutable types, builder-based construction, natural-order checks for sorted types, erroring on @MappingTarget usage, and source-shape diagnostics.",
        "Surfaces changed are unrelated: Immutables.generator/Modifiables.generator and meta classes (AccessorAttributesCollector, ValueAttribute, ValueType, ValueTypeComposer) vs. MapStruct’s AbstractMappingMethodBuilder, Container/Map mapping builders, new Immutable*MappingMethod classes, Type utilities, MapperCreationProcessor, and Freemarker templates."
      ],
      "one_liner": "Each adds a new capability to a different Java code generator: one introduces seedable lazy attributes in Immutables, the other adds Guava immutable-collection mapping support in MapStruct.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "There is no purpose-matched surface or behavior in common: the submission implements a seedable lazy-attribute lifecycle within Immutables-generated classes, while the candidate adds support for generating MapStruct mapping methods targeting Guava immutable collections/maps. Any overlap in terminology (immutable, builder) is generic to Java code generation and not a shared task. The modified files, APIs introduced, and observable behaviors diverge completely, so they teach different lessons.",
      "similarity": 0.478465735912323,
      "submission_summary": "Extends Immutables to allow an accessor annotated with both @Value.Lazy and @Value.Default to accept an explicit seed via generated builders and with-methods, track seed provenance, keep initializers cold when unseeded, and preserve or omit seeds correctly across from/copyOf/toBuilder paths. It updates the value processor (collectors, model flags, validation), generator templates (immutable and modifiable), and docs to implement seed bits, accessors, copy/serialization rules, and builder wiring.",
      "title": "immutable collections",
      "verdict": "distinct"
    }
  ]
}
```

---

**Test Fairness**

Coverage Suggestions (2) - Not Blockers

Advisory only — these don't affect the check result.

generated immutable copyOf path
Add a direct positive test that `ImmutableSeedableLazyModel.copyOf(generatedImmutable)` preserves explicit-vs-cold state without forcing the hybrid accessor, since current coverage focuses on builder/toBuilder, external sources, and modifiable sources more than same-type immutable `copyOf`.

boolean/null scalar withers
Add a wither-focused check for prompt-listed falsey/null scalar cases such as `withEnabled(false)`, `withNullable(null)`, or `withOptional(Optional.empty())`, to complement the existing wither coverage for scalar ints, arrays, and collection/map hybrids.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "generated immutable copyOf path",
      "suggestion": "Add a direct positive test that `ImmutableSeedableLazyModel.copyOf(generatedImmutable)` preserves explicit-vs-cold state without forcing the hybrid accessor, since current coverage focuses on builder/toBuilder, external sources, and modifiable sources more than same-type immutable `copyOf`."
    },
    {
      "area": "boolean/null scalar withers",
      "suggestion": "Add a wither-focused check for prompt-listed falsey/null scalar cases such as `withEnabled(false)`, `withNullable(null)`, or `withOptional(Optional.empty())`, to complement the existing wither coverage for scalar ints, arrays, and collection/map hybrids."
    }
  ],
  "error": "",
  "executionTimeSeconds": 454.503688,
  "message": "All hidden tests are fair.",
  "overall": "Overall, the hidden tests are fair. Most assertions are directly spelled out in the prompt, and the rest are anchored in visible existing repository semantics for ordinary `@Value.Lazy`, auxiliary omission from equality/hash/string, wither same-instance short-circuiting, builder clearing, and Modifiable `*IsSet()` conventions. The suite is dense and somewhat redundant in places, but it is not over-coupled to invisible internals or hidden setup.",
  "taskSummary": "The task adds a new hybrid mode where one accessor is annotated with both `@Value.Lazy` and `@Value.Default`. In that mode, the attribute still behaves like ordinary lazy initialization when unseeded, but builders, with-methods, toBuilder/from/copyOf, Modifiable companions, and serialization paths must now track whether a caller explicitly seeded the lazy value. The prompt is unusually detailed: it spells out which values count as explicit seeds (including falsey/null/empty values), which copy/merge paths must preserve seeds or treat sources as absent, what Modifiable should do when unseeded, and which invalid configurations must be rejected.",
  "tests": [
    {
      "evidence": "The prompt says, \"Until then, its initializer stays cold\" and that an unseeded hybrid \"retains ordinary `@Value.Lazy` initialization.\" Existing repo docs make the ordinary lazy form concrete: `value-annotations/src/org/immutables/value/Value.java:319-324` says lazy values are stored in a field and initialization is guarded by synchronization/volatile checks, and `value-fixture/test/org/immutables/fixture/ValuesTest.java:336-344` shows first access computes once while later accesses reuse the memoized value.",
      "fairness": "Repo-discoverable",
      "name": "omittedSeedIsColdAndSuccessfulFallbackIsConcurrentAndMemoized",
      "qualityCheck": "Fair. It is a real integration check of existing lazy semantics under the new mode. The concurrency aspect uses generous timeouts, so it is not obviously flaky.",
      "verifies": "Building without calling the hybrid setter leaves `scalarCalls` at 0; 16 concurrent `scalar()` calls all return the same integer; a later `scalar()` call returns that same integer again; and `scalarCalls` ends at exactly 1."
    },
    {
      "evidence": "The prompt says unseeded hybrids keep ordinary lazy behavior. Ordinary lazy memoization is documented at `value-annotations/src/org/immutables/value/Value.java:319-324` and exercised at `value-fixture/test/org/immutables/fixture/ValuesTest.java:336-344`. Support for specialized optionals is already visible in `value-fixture/test/org/immutables/fixture/jdkonly/JdkOptionalDefaultTest.java:42-50`, which uses builder and withers with `OptionalInt`.",
      "fairness": "Repo-discoverable",
      "name": "specializedOptionalInitializerRunsOnceAndMemoizes",
      "qualityCheck": "Fair, though somewhat redundant with the previous lazy-once test; it adds useful specialized-optional coverage.",
      "verifies": "An unseeded `OptionalInt` hybrid leaves `calls` at 0 before access, returns a present `OptionalInt` on first `number()`, increments `calls` to 1, returns the same `OptionalInt` value on the second call, and keeps `calls` at 1."
    },
    {
      "evidence": "The exact seed forms are prompt-stated: \"Any direct setter or collection/map mutator establishes a seed, including legal `null`, false, zero, empty optional, empty array, and empty collection or map values. Until then, its initializer stays cold.\" The `clear()` integration is repo-discoverable: `value-annotations/src/org/immutables/value/Value.java:1157-1165` documents generated builder clearing, and `value-fixture/test/org/immutables/fixture/modifiable/ClearBuilderTest.java:24-39` shows `builder.clear()` resets builder state before a later build.",
      "fairness": "Repo-discoverable",
      "name": "falseyNullableAndEmptySeedsBypassFallbacks_and_builderClearRestoresCold",
      "qualityCheck": "Fair. This test is dense, but it is checking many prompt-enumerated seed forms and a discoverable existing builder feature.",
      "verifies": "Builder seeding with `0`, `false`, `null`, `Optional.empty()`, empty collection/map, empty array, and explicit checked/error strings makes the built value return exactly those seeded values and leave all fallback counters at 0; direct container setters with empty list/map also bypass fallback; single-item mutators seed collection/map values without fallback; and calling builder `clear()` before rebuilding removes the seed so `scalar()` is cold again and computes once on first access."
    },
    {
      "evidence": "The prompt explicitly says, \"An unseeded hybrid retains ordinary `@Value.Lazy` initialization and declared checked-exception signatures.\" Existing repo commentary also matches that behavior at `value-processor/src/org/immutables/value/processor/meta/ValueAttribute.java:1304-1311`.",
      "fairness": "Prompt-stated",
      "name": "checkedExceptionSignaturesArePreserved",
      "qualityCheck": "Fair and precise; it checks the exact reflected signature the prompt names.",
      "verifies": "The generated immutable `checked()` method and generated modifiable `checked()` method declare exactly the same checked exception types as their abstract source methods."
    },
    {
      "evidence": "The prompt routes this to ordinary lazy behavior. The repo states that explicitly: `value-processor/src/org/immutables/value/processor/meta/ValueAttribute.java:1309-1312` says neither checked nor runtime exceptions are memoized for lazy attributes, and `value-fixture/test/org/immutables/fixture/ValuesTest.java:633-655` already tests that lazy exceptions are thrown again on a second call.",
      "fairness": "Repo-discoverable",
      "name": "checkedAndErrorFailuresAreRetriedInsteadOfMemoized",
      "qualityCheck": "Fair. It is a direct carry-over of existing lazy failure semantics into the hybrid mode.",
      "verifies": "Calling unseeded `checked()` twice throws twice and increments `checkedCalls` to 2, and calling unseeded `errorProne()` twice throws twice and increments `errorCalls` to 2."
    },
    {
      "evidence": "The seed-origin rules themselves are prompt-stated: \"Calling a hybrid with-method with a value equal to a computed fallback still establishes an explicit seed. Copying a value while changing another attribute preserves an explicit seed, but leaves an omitted or merely computed fallback cold in the copy.\" The exact same-instance short-circuit on equal current values is repo-discoverable from existing wither tests: `value-fixture/test/org/immutables/fixture/ValuesTest.java:620-629`, `value-fixture/test/org/immutables/fixture/with/WithEnumsTest.java:35-44`, and specialized optional withers in `value-fixture/test/org/immutables/fixture/jdkonly/JdkOptionalDefaultTest.java:42-50`.",
      "fairness": "Repo-discoverable",
      "name": "withersPreserveExplicitOriginButDropComputedFallbacks",
      "qualityCheck": "Fair. This is one of the most important behavior checks, though it packs many subcases into one test.",
      "verifies": "A copy made from a cold value by changing another attribute stays cold until first access; a copy made from a value that only computed a fallback does not preserve that computed fallback; `withScalar(computedFallback)` on a computed value creates a distinct instance that treats the value as an explicit seed and preserves it across `withInput(...)`; repeating `withScalar(currentSeed)` returns the same instance; and analogous explicit-seed preservation holds for list, array, and nullable collection/map hybrids seeded through withers, without extra fallback calls."
    },
    {
      "evidence": "The prompt explicitly says, \"Generated `toBuilder`, builder `from`, and `copyOf` paths preserve explicit seeds without calling the hybrid accessor. An unseeded source acts as absent and does not clear a destination seed.\" It also says, \"Copying a value while changing another attribute preserves an explicit seed, but leaves an omitted or merely computed fallback cold in the copy.\"",
      "fairness": "Prompt-stated",
      "name": "generatedToBuilderAndBuilderFromTransferOnlyExplicitSeeds",
      "qualityCheck": "Fair and central to the feature. It tests exactly the copy-path rules the prompt spells out.",
      "verifies": "`builder.from(cold)` does not clear an already seeded destination `scalar(99)` and does not force fallback; `cold.toBuilder().input(...).build()` leaves scalar cold; a merely computed fallback does not transfer through `toBuilder()` and is recomputed in the copy; explicit scalar, tags, optional-empty, and nullable-null seeds do transfer through `from(...)` and `toBuilder()` and are returned exactly, with no fallback counter increments."
    },
    {
      "evidence": "The prompt explicitly states, \"Copying from an arbitrary external implementation leaves the hybrid unseeded and does not read its getter, including when a style disables builder `from`.\"",
      "fairness": "Prompt-stated",
      "name": "externalFromAndCopyOfNeverProbeHybridGetter",
      "qualityCheck": "Fair. It checks a subtle but explicitly required distinction between generated-source transfer and arbitrary external implementations.",
      "verifies": "`Immutable...builder().from(external).build()` and `Immutable...copyOf(external)` leave the external read counter at 0 during transfer; later each copied value's own accessor throws from its own fallback, bringing the read counter to 2 total; and `copyOf` on a style with `from = \"\"` likewise leaves the external getter unread until the copied accessor is invoked."
    },
    {
      "evidence": "The prompt says generated `copyOf` paths preserve explicit seeds without calling the accessor, that `Modifiable.from(...)` follows the same rule for generated immutable and modifiable sources, and separately that only an \"arbitrary external implementation\" must stay unseeded and unread. This test is exactly that generated-modifiable vs arbitrary-external distinction.",
      "fairness": "Prompt-stated",
      "name": "copyOfWithDisabledFromRecognizesGeneratedModifiableOrigin",
      "qualityCheck": "Fair. It checks an important edge where style disables builder `from` but `copyOf` should still distinguish generated modifiable sources.",
      "verifies": "`ImmutableSeedableLazyNoFromModel.copyOf(modifiableSeeded)` preserves the explicit seed `\"seed\"` across accessor calls and `.withInput(...)` without incrementing source reads, while `copyOf(modifiableCold)` leaves the hybrid cold so first access computes and returns `\"fallback-15\"` and increments the read counter once."
    },
    {
      "evidence": "Existing repo semantics make this discoverable: `value-annotations/src/org/immutables/value/Value.java:286-289` says auxiliary attributes are excluded from `equals`, `hashCode`, and `toString`, and lazy attributes are always auxiliary; `value-fixture/test/org/immutables/fixture/ValuesTest.java:246-251` already checks equality/hash/string omission for an auxiliary attribute.",
      "fairness": "Repo-discoverable",
      "name": "lazyAuxiliaryStateIsIgnoredByEqualsHashCodeAndToString",
      "qualityCheck": "Fair. It is not prompt-restated, but it follows visible existing `@Value.Lazy`/`@Value.Auxiliary` semantics rather than inventing a new rule.",
      "verifies": "An unseeded value compares equal to a seeded value with the same non-lazy attributes, has the same `hashCode()`, has the same `toString()`, and none of those operations force the lazy hybrid accessor (`scalarCalls` stays 0)."
    },
    {
      "evidence": "The prompt says, \"Ordinary Java serialization resets both explicit and computed lazy state without forcing the attribute.\" The repo also documents the same ordinary lazy serialization basis at `value-annotations/src/org/immutables/value/Value.java:1520`, which says lazy fields are transient and ready to be reinitialized after deserialization.",
      "fairness": "Prompt-stated",
      "name": "javaSerializationResetsExplicitAndComputedLazyStateWithoutForcing",
      "qualityCheck": "Fair and user-visible. The assertions match the exact reset-vs-force distinction in the prompt.",
      "verifies": "Regular Java serialization/deserialization of a cold, explicitly seeded, or previously computed hybrid value does not force the hybrid during serialization, and after deserialization the first `scalar()` call recomputes from the fallback rather than reusing pre-serialization explicit or computed lazy state."
    },
    {
      "evidence": "The prompt explicitly says, \"generated structural serialization and marshaling omit it.\" Existing structural serialization docs at `serial/src/org/immutables/serial/Serial.java:51-56` say structural serialization uses attribute names/builders rather than internal storage, which matches omission-based behavior.",
      "fairness": "Prompt-stated",
      "name": "structuralSerializationAndMarshalingOmitHybridAttribute",
      "qualityCheck": "Fair. It covers both structural Java serialization and generated JSON marshaling exactly where the prompt names them.",
      "verifies": "For `@Serial.Structural`, both cold and explicitly seeded values round-trip without incrementing the hybrid call counter before access, and the restored value computes the hybrid only on later access; for generated Gson marshaling, `Marshaling.toJson(...)` for both cold and seeded values does not contain the JSON field name `\"value\"` and does not increment the hybrid call counter."
    },
    {
      "evidence": "The prompt explicitly says, \"A generated Modifiable returns a fresh fallback on each unseeded access without marking the attribute set; unset and clear remove explicit seeds.\"",
      "fairness": "Prompt-stated",
      "name": "modifiableUnseededAccessIsFreshAndDoesNotSetIsSet",
      "qualityCheck": "Fair and core to the Modifiable portion of the feature.",
      "verifies": "On a generated Modifiable, calling unseeded `checked()` twice throws twice and leaves `checkedIsSet()` false, and calling unseeded `scalar()` twice leaves `scalarIsSet()` false while incrementing the fallback counter twice."
    },
    {
      "evidence": "The prompt names the exact seed forms and says converting a Modifiable to immutable preserves explicit seeds. The visible `*IsSet()` API shape is repo-discoverable: `value-annotations/src/org/immutables/value/Value.java:798` defines the `*IsSet` naming template, and `value-fixture/test/org/immutables/fixture/modifiable/ModifiablesTest.java:69-107` already exercises `stringIsSet()`/unset/clear behavior on Modifiables.",
      "fairness": "Repo-discoverable",
      "name": "modifiableSettersSeedFalseyEmptyAndNullValues_and_toImmutablePreservesThem",
      "qualityCheck": "Fair. It tests the exact seed values the prompt enumerates and uses an existing public Modifiable API.",
      "verifies": "After `setScalar(0)`, `setOptional(Optional.empty())`, `addAllTags(emptyList)`, `setNullableTags(null)`, `setNullableIndex(null)`, and `setChecked(\"safe\")`, the corresponding `*IsSet()` methods are true, accessors return exactly those seeded values, fallback counters do not change, and `toImmutable()` returns an immutable value with the same seeded values."
    },
    {
      "evidence": "This is all explicitly in the prompt: \"unset and clear remove explicit seeds,\" \"Converting it to an immutable value preserves explicit seeds and leaves unseeded hybrids cold,\" and \"An unseeded source acts as absent and does not clear a destination seed. `Modifiable.from(...)` follows the same rule for generated immutable and modifiable sources.\"",
      "fairness": "Prompt-stated",
      "name": "modifiableUnsetClearAndMergeRespectSeedOrigin",
      "qualityCheck": "Fair. Dense but directly tied to the prompt's transfer/origin rules.",
      "verifies": "`unset...` removes explicit seeds so later access re-runs fallbacks and rethrows checked failures; `.from(unseeded immutable)` does not clear an existing scalar seed of 7; `.from(seed-carrying immutable)`, immutable-builder `.from(modifiable)`, and immutable `copyOf(modifiable)` preserve explicit seeds including empty/null seeds; `clear()` removes a seed so later access recomputes; `toImmutable()` from an unseeded modifiable leaves the hybrid cold; and `.from(unseeded modifiable)` does not clear an existing destination seed while `.from(seed80)` overwrites it with 80."
    },
    {
      "evidence": "The prompt defines the capability per accessor rather than as a shared object-wide state. Existing ordinary lazy behavior is per-attribute in `value-fixture/src/org/immutables/fixture/SillyLazy.java:24-33`, and `value-fixture/test/org/immutables/fixture/ValuesTest.java:336-344` shows two lazy attributes computing independently.",
      "fairness": "Repo-discoverable",
      "name": "multipleSeedableLazyAttributesRemainIndependent",
      "qualityCheck": "Fair. This is a sensible regression test for per-attribute bookkeeping.",
      "verifies": "Seeding `first(0)` leaves both fallback counters at 0, `first()` returns 0 without triggering fallback, and the unrelated `second()` attribute remains cold until first access and then memoizes after one increment."
    },
    {
      "evidence": "The prompt explicitly includes \"empty optional\" among values that establish a seed. Existing repo tests show specialized optional defaults and withers accept `OptionalInt.empty()` at `value-fixture/test/org/immutables/fixture/jdkonly/JdkOptionalDefaultTest.java:42-50`, and existing wither tests show equal current values return the same instance at `value-fixture/test/org/immutables/fixture/with/WithEnumsTest.java:42-44` and `value-fixture/test/org/immutables/fixture/ValuesTest.java:620-629`.",
      "fairness": "Repo-discoverable",
      "name": "specializedEmptyOptionalIsAnExplicitSeed",
      "qualityCheck": "Fair. The same-instance co-assertion relies on visible existing wither conventions, not hidden internals.",
      "verifies": "Builder seeding with `number(OptionalInt.empty())` returns exactly `OptionalInt.empty()` without running fallback logic, and calling `withNumber(OptionalInt.empty())` again on that seeded value returns the same instance."
    },
    {
      "evidence": "The prompt says, \"`Modifiable.from(...)` follows the same rule for generated immutable and modifiable sources. Copying from an arbitrary external implementation leaves the hybrid unseeded and does not read its getter.\"",
      "fairness": "Prompt-stated",
      "name": "modifiableFromExternalLeavesHybridColdAndUnread",
      "qualityCheck": "Fair and specific. It covers the Modifiable variant of an explicitly described external-source rule.",
      "verifies": "`Modifiable...create().from(external)` leaves the external read counter at 0 and `expensiveIsSet()` false, and the first later accessor call throws from the copied modifiable's own fallback, bringing the read counter to 1."
    },
    {
      "evidence": "Those validations already exist in the repo: `value-processor/src/org/immutables/value/processor/meta/AccessorAttributesCollector.java:438` errors that `@Value.Lazy` must be non-abstract and non-final, and `...:441` errors that `@Value.Lazy` cannot be `@Value.Derived` or `@Value.Default`.",
      "fairness": "Repo-discoverable",
      "name": "invalidPlainLazyFormsRemainRejected",
      "qualityCheck": "Fair. The log check is intentionally broad, so it is not brittle about full diagnostic wording.",
      "verifies": "Annotation processing fails for `@Value.Lazy abstract`, `@Value.Lazy final`, and `@Value.Lazy @Value.Derived` methods, and the diagnostic output contains `@Value.Lazy`."
    },
    {
      "evidence": "The prompt explicitly requires: \"Reject the combination for interned immutable values and types without generated builders or with-methods, with a diagnostic mentioning both annotations.\"",
      "fairness": "Prompt-stated",
      "name": "seedableLazyInvalidConfigurationsAreRejectedWithBothAnnotationNames",
      "qualityCheck": "Fair. It checks exactly the invalid configurations and only requires the prompt-mandated diagnostic markers, not a brittle full message.",
      "verifies": "Annotation processing fails for hybrid `@Value.Lazy`+`@Value.Default` on an interned immutable, on `builder = false`, and on `copy = false`, and each diagnostic contains both `@Value.Lazy` and `@Value.Default`."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Shipd Bot Description Warnings**

> "as a new generated capability."

Trim the introductory framing. It does not add task-defining information beyond the title and first clause. For example, change the opening to: "Introduce seedable lazy attributes."

> "strict and staged builders are not required."

Soften or remove this implementation-scope note unless you specifically want to constrain the solver. The hidden tests only exercise ordinary generated builders, so this reads as extra process guidance rather than a behavior requirement. If you want to keep the scope note, a lighter version would be: "Support the standard generated builder path."

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 2 medium-priority suggestions focused on trimming obvious defaults. With only 1–2 medium/low items, the correct verdict is minor_suggestions.",
  "suggestions": [
    {
      "priority": "medium",
      "quote": "An unseeded hybrid retains ordinary `@Value.Lazy` initialization and declared checked-exception signatures.",
      "suggestion": "Remove the phrase \"and declared checked-exception signatures.\" This is a default/codegen-preserved behavior and not part of the new functionality; it’s implied by retaining ordinary @Value.Lazy behavior and can be inferred from the existing codebase."
    },
    {
      "priority": "medium",
      "quote": "Until then, its initializer stays cold.",
      "suggestion": "Delete this sentence. It restates obvious @Value.Lazy behavior and doesn’t add new requirements specific to seedable lazy attributes."
    }
  ],
  "summary": "- **[MEDIUM]** Trim the trailing clause in: \"An unseeded hybrid retains ordinary `@Value.Lazy` initialization and declared checked-exception signatures.\" Remove \"and declared checked-exception signatures.\" since throws-signature preservation is a default of implementing the abstract method and not new behavior.\n- **[MEDIUM]** Remove the standalone sentence: \"Until then, its initializer stays cold.\" It reiterates standard lazy semantics and doesn’t specify new requirements for seedable lazy behavior.",
  "verdict": "minor_suggestions"
}
```
