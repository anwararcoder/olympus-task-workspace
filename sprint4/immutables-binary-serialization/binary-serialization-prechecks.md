**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥40 messages, ≥250 LOC

This task numbers: Median files: 8, messages: 180, LOC: 1791

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "ec35a4f580d7bd431133f1893b92d6dde8fb6835bfb093b76e69ca31f7c2d84e",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Generates structural diff/patch support for @Value.Immutable types: a nested Patch class, a diff method to compute sparse attribute changes, apply to produce a new instance, and then to compose patches, with recursive handling for nested immutables and optionals and container-specific semantics. Modifies Immutables.generator and meta (ValueType/ValueAttribute) to detect eligible shapes and propagate throws clauses.",
      "confidence": 0.93,
      "contentAuthoredAt": 1782801753255,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds instance writeTo(java.io.DataOutput) and static readFrom(java.io.DataInput) to generated immutable implementations, with a tag- and type-coded, name-independent binary wire format; candidate adds a nested Patch type plus diff/apply/then methods for structural changes.",
        "Submission conditions generation on the serial module being present and avoids generation if conflicting methods already exist; candidate does not depend on a serial module and instead guards on attribute shapes and reserved method names (diff/apply/then).",
        "Submission’s behavior is serialization/deserialization across versions (skipping unknown fields, matching by attribute tag), including nested immutables that also support the binary form; candidate’s behavior computes sparse per-attribute deltas, applies them without replacing whole containers, and composes patches, with recursive diffs for nested immutables and optionals.",
        "Submission writes/reads supported scalars, strings, enums, arrays, optionals, and collections/maps/multimaps in a compact binary form; candidate compares values (including float/double by bit pattern, arrays by contents) and records adds/removes/puts for collections/maps/multisets/multimaps.",
        "Submission introduces a runtime helper BinaryWire in the serial module for varints/frames/strings; candidate introduces no runtime wire helper and instead augments metadata (ValueAttribute/ValueType) to enable/compose Patch generation."
      ],
      "one_liner": "Both extend the Immutables code generator, but one adds compact binary serialization methods while the other adds structural diff/patch capabilities.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both touch the same generator and metadata files, they do so for different purposes and expose entirely different generated APIs. One teaches adding a binary serialization layer with forward/backward compatibility and tag-based field matching; the other teaches computing and applying structural diffs with recursive patch composition. There is no shared introduced API or testable behavior; the overlap is limited to repository scaffolding for code generation.",
      "similarity": 0.6714482307434082,
      "submission_summary": "Adds compact binary serialization to generated @Value.Immutable types when the serial module is present: generates writeTo(DataOutput) and static readFrom(DataInput), with tag- and type-coded frames, skipping unknown attributes and supporting nested immutables/collections/optionals. Modifies Immutables.generator and the meta (ValueType/ValueAttribute) to gate support and compute tags/type codes, and adds a BinaryWire helper in the serial module.",
      "title": "Structural differences for generated immutables",
      "verdict": "distinct"
    },
    {
      "authorUsername": "igee",
      "candidate_summary": "Extends MapStruct’s processor to support Guava immutable collection types as mapping targets, generating methods that populate the corresponding builders for ImmutableList/Set/SortedSet/Multiset, ImmutableMap/SortedMap/BiMap, ImmutableMultimap/ListMultimap/SetMultimap, and ImmutableTable, with validation of source shapes and natural ordering for sorted types, and erroring on immutable @MappingTarget uses.",
      "confidence": 0.93,
      "contentAuthoredAt": 1783929834023,
      "evalStatus": "ok",
      "evidence_gaps": [
        "Candidate patch is truncated, though the visible parts already show its purpose and surfaces clearly."
      ],
      "isOlder": false,
      "meaningful_differences": [
        "Different repositories and ecosystems: one targets Immutables’ annotation processor/generator, the other MapStruct’s mapping processor.",
        "Submission generates public writeTo(DataOutput) and static readFrom(DataInput) methods on generated @Value.Immutable types with a tag/type-coded, order-independent binary wire format; candidate generates mapping methods that build Guava Immutable* collections/maps/multimaps/tables from source shapes.",
        "Submission’s scope centers on serialization compatibility, attribute tagging, nested immutable support, optionals/arrays/collections encoding, and conflict detection; candidate’s scope centers on selecting/forging element/key/value mappings, builder population, sorted-type comparability checks, lifecycle hooks, and error reporting for unsupported sources or immutable @MappingTarget.",
        "Submission modifies Immutables.generator templates and meta-model classes (ValueAttribute, ValueType) and introduces BinaryWire primitives; candidate introduces multiple MapStruct model builders and Type utilities to detect Guava immutable types and wiring into MapperCreationProcessor."
      ],
      "one_liner": "They both extend code generation around immutable types, but one adds a compact binary serialization form to generated Immutables, while the other adds MapStruct mapping support for Guava immutable collections and tables.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "The modified surfaces and behaviors are orthogonal: one adds a binary serialization lifecycle to generated Immutables via new methods and a wire format, while the other enhances MapStruct to create and validate Guava immutable collection/map/multimap/table mappings. There are no shared purpose-matched files, APIs, or behaviors; any mentions of Guava types occur in different roles (binary encode vs. mapping targets). Hence they teach different tasks and should co-exist.",
      "similarity": 0.5924239754676819,
      "submission_summary": "Extends the Immutables value processor to (when the serial module is present) generate writeTo(DataOutput) and static readFrom(DataInput) for eligible @Value.Immutable types, implementing an order-independent, tag/type-coded binary wire format with broad support for primitives, strings, enums, optionals, arrays, collections, maps, multimaps, and nested immutables. Adds BinaryWire primitives and meta logic to decide eligibility, avoid method conflicts, and ensure constructor/builder reconstruction fidelity.",
      "title": "immutable collections",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Adds a Pointers generator that emits a FooPointers companion for eligible @Value.Enclosing types, with parse/render of string pointers and resolve/update operations that navigate lists, arrays, string-keyed maps, optionals, and nested immutable implementations, rebuilding only path-local values. Wires the generator into Processor and adds a meta PointerModel to detect eligible families.",
      "confidence": 0.92,
      "contentAuthoredAt": 1783890373543,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": false,
      "meaningful_differences": [
        "Submission adds public writeTo(DataOutput) and static readFrom(DataInput) to generated @Value.Immutable implementations, gated by the serial module and only for supported attribute shapes; the candidate generates a separate FooPointers companion class for @Value.Enclosing families with parse/render/resolve/update pointer semantics.",
        "Submission’s behavioral change is binary IO encoding/decoding with attribute tags, type codes, skipping unknowns, and version tolerance; the candidate’s behavior is string pointer parsing, walking nested values/containers, and structural updates with path-local rebuilding and detailed failure types.",
        "Submission modifies Immutables.generator to emit serialization code and adds BinaryWire primitives plus eligibility checks in meta (ValueType/ValueAttribute); the candidate adds a new Pointers.generator, a Processor hook to run it, and a PointerModel in meta to discover eligible families—no binary IO or method injection on value types.",
        "Submission’s scope governs supported types (scalars, enums, optionals, arrays, certain collections, nested immutables) and constructor/builder viability; the candidate’s scope governs pointer syntax, resolvable shapes (lists, arrays, string-keyed maps, optionals), and update constraints (no derived/lazy/opaque/set-like descent)."
      ],
      "one_liner": "Both add new code generation features to Immutables, but one introduces compact binary serialization methods on immutable implementations while the other generates standalone pointer companions for navigating and updating families of enclosed values.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "finalizing_review",
      "reason": "Although both live in the same repository and touch generator/meta plumbing, they target entirely different features and surfaces. The submission injects binary serialization methods into each immutable implementation with wire-format and compatibility rules, while the candidate creates separate companion classes to parse/render pointers and to resolve/update within enclosed value families. There are no shared introduced APIs or common observable behaviors; overlaps in edited meta classes are for distinct purposes, not the same task.",
      "similarity": 0.5517767358985307,
      "submission_summary": "Extends the value processor to generate writeTo(DataOutput) and static readFrom(DataInput) on eligible @Value.Immutable implementations when the serial module is present, using BinaryWire utilities and attribute tags/type codes for compact, version-tolerant binary IO. Adds meta logic to determine eligibility and supported shapes and avoids generation when conflicting methods exist.",
      "title": "Pointers into Enclosed Value Families",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Adds a fold generator that, for @Value.Enclosing families with at least two implementations, emits a Fold<R> interface with case methods and fold entry points. The generated code dispatches to the most specific case, folds through attributes that are family types across supported containers, and memoizes per-value results to avoid repeated computation.",
      "confidence": 0.93,
      "contentAuthoredAt": 1783281221104,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": false,
      "meaningful_differences": [
        "Submission generates instance writeTo(DataOutput) and static readFrom(DataInput) methods on @Value.Immutable types when a serial module is present; candidate generates a separate Fold<R> interface for @Value.Enclosing families.",
        "Submission adds BinaryWire primitives and serialization templates in Immutables.generator to encode/decode supported attribute shapes; candidate adds Folds.generator, FoldModel meta, and Processor wiring to generate fold dispatch and memoized traversal.",
        "Submission’s scope focuses on reconstructible attribute shapes (scalars, strings, enums, optionals, arrays, maps/sets/multimaps, and direct nested immutables) and version/compat rules; candidate’s scope focuses on hierarchical dispatch over family implementations and folding through attributes that are family types in various container shapes.",
        "Submission modifies meta (ValueAttribute/ValueType) to compute binary support, type codes, tags, and conflict detection with existing APIs; candidate modifies meta (ValueType) to detect enclosing-family eligibility and build a FoldModel, with no serialization concerns."
      ],
      "one_liner": "They add unrelated generated features: one introduces compact binary serialization for immutable values, the other generates fold/visitor interfaces for value-family hierarchies.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Both patches target the same repository but serve different, non-overlapping features at different purpose-matched surfaces. The submission implements a binary serialization format by emitting per-type read/write methods and wiring attribute-level support, while the candidate introduces a fold/visitor facility for value-family hierarchies via separate generated interfaces and traversal logic. No concrete APIs, behaviors, or tests coincide beyond generic generator infrastructure.",
      "similarity": 0.5439928492901956,
      "submission_summary": "Extends the value processor to conditionally generate writeTo(DataOutput) and static readFrom(DataInput) on eligible immutable types when the serial module is present, using BinaryWire primitives and tag/type-coded frames to serialize supported attribute shapes and nested generated immutables. Adds meta logic to determine eligibility, compute stable field tags and type codes, avoid conflicts, and support builder- and constructor-based reconstruction.",
      "title": "Exhaustive fold for enclosed value families",
      "verdict": "distinct"
    },
    {
      "authorUsername": "phoenix",
      "candidate_summary": "Enhances Spoon’s partial evaluator to fold binary/unary operations with correct Java promotion and overflow semantics, preserves types, and applies algebraic identities and reassociation while respecting side effects. Also sets binary operator result types in CodeFactory and adjusts pretty printing to parenthesize negated negative literals.",
      "confidence": 0.98,
      "contentAuthoredAt": 1783792052458,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": false,
      "meaningful_differences": [
        "Different repositories and domains: Immutables code generation and serialization vs. Spoon’s AST manipulation and evaluation.",
        "Modified surfaces are unrelated: Immutables’ code generator templates and metadata (ValueType/ValueAttribute) plus a new BinaryWire utility vs. Spoon’s CodeFactory, pretty printer, operator/type helpers, and partial evaluator visitors.",
        "Behavioral changes diverge: submission adds writeTo/readFrom binary encoding/decoding for generated immutable classes with version/compat rules; candidate folds/simplifies expressions with precise Java promotion/overflow semantics and formatting/type fixes.",
        "Scopes differ fundamentally: submission covers supported attribute shapes (scalars, enums, collections, optionals, arrays, nested immutables), conflict detection, and generation conditions; candidate covers algebraic identities, side-effect preservation, reassociation, and exception rules for divide/mod by zero."
      ],
      "one_liner": "One adds generated compact binary serialization for Immutables’ value classes; the other implements constant folding and related utilities in Spoon’s AST partial evaluator.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "The two patches target different repositories and unrelated features. The submission modifies Immutables’ code generation pipeline to synthesize binary serialization methods and an internal wire format helper, while the candidate alters Spoon’s partial evaluator, type/result inference, and pretty printing to perform constant folding and simplifications. There is no purpose-matched surface or shared behavioral change; any similarities are purely generic Java concerns, not the same task.",
      "similarity": 0.520654559135437,
      "submission_summary": "Extends Immutables’ value processor to conditionally generate writeTo(DataOutput) and static readFrom(DataInput) for @Value.Immutable types when the serial module is present, using a new BinaryWire utility and per-attribute tags/type codes. Handles numerous attribute shapes, nested immutables, compatibility across versions, and skips unsupported/conflicting cases.",
      "title": "Faithful constant folding and algebraic simplification in the partial evaluator",
      "verdict": "distinct"
    }
  ]
}
```

---

**Test Fairness**

Coverage Suggestions (2) - Not Blockers

Advisory only — these don't affect the check result.

Container-mismatch desynchronization
Add a case where an incompatible list/map payload is followed by another compatible attribute and assert that the later attribute still decodes correctly, to prove mismatched container payloads are skipped without desynchronizing the stream.

Constructor-built derived/auxiliary omission
Add a constructor-built value with derived and auxiliary attributes to verify that the omit/recompute/default rules are applied there too; current derived/auxiliary coverage is builder-built only.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Container-mismatch desynchronization",
      "suggestion": "Add a case where an incompatible list/map payload is followed by another compatible attribute and assert that the later attribute still decodes correctly, to prove mismatched container payloads are skipped without desynchronizing the stream."
    },
    {
      "area": "Constructor-built derived/auxiliary omission",
      "suggestion": "Add a constructor-built value with derived and auxiliary attributes to verify that the omit/recompute/default rules are applied there too; current derived/auxiliary coverage is builder-built only."
    }
  ],
  "error": "",
  "executionTimeSeconds": 383.952514,
  "message": "All hidden tests are fair.",
  "overall": "PASS. The prompt is unusually explicit, and the repo gives extra discoverability around serial-module gating and existing structural reconstruction conventions. Most tests are straight prompt checks of visible behavior; where the prompt leaves room (nullable support, extra constructor forms, collision handling), the tests are permissive and accept either safe support or no generated pair. I do not see hidden setup, brittle message matching, or coupling to implementation internals. The only slightly narrow assertion is requiring an `IOException`-family failure for truncated input, but that matches standard `DataInput` semantics, so it is still fair.",
  "taskSummary": "Extend the value processor so that plain eligible `@Value.Immutable` implementations automatically gain a compact binary API when the `org.immutables:serial` artifact is merely on the compilation classpath: a public instance `writeTo(java.io.DataOutput)` and a public static `readFrom(java.io.DataInput)`. The pair must only be emitted when all stored, non-auxiliary state can be reconstructed faithfully; otherwise emit neither method, and never emit only one half. The required supported surface is broad for builder-built values (primitive and boxed scalars, strings, enums, optionals, arrays, direct nested generated immutables, and the listed collection families) and narrower-but-explicit for constructor-built values. The wire format must not carry attribute names, must not rely on declaration order, must ignore unknown added fields, default/omit missing or mismatched fields, preserve declared collection/optional shapes, omit derived/auxiliary attrs, avoid recursive/unsafe forms, preserve preexisting `writeTo`/`readFrom` APIs, and fail on truncated input. Repo context makes the serial-module gate and existing structural-serialization patterns discoverable: classpath gating exists in `value-processor/src/org/immutables/value/processor/meta/Proto.java:184-197,424-426`, and the current `@Serial.Structural` Java-serialization path reconstructs via builders/constructors in `value-processor/src/org/immutables/value/processor/Immutables.generator:320-437,438-499,560-563`, but the prompt explicitly asks for a new DataInput/DataOutput form with no extra annotation and no attribute names on the wire.",
  "tests": [
    {
      "evidence": "The prompt explicitly says generated implementations 'gain a compact binary form' with 'a public instance method writeTo(java.io.DataOutput) and a public static method readFrom(java.io.DataInput)' and that 'reading a written value yields an equal value.' It also explicitly lists builder-built support for primitive scalars and strings.",
      "fairness": "Prompt-stated",
      "name": "scalarRoundTrip",
      "qualityCheck": "Fair and direct: it checks the visible API shape plus round-trip semantics without coupling to internals.",
      "verifies": "`fromBytes(ImmutableBinScalars.class, toBytes(value))` is equal to the original `BinScalars` instance with all primitive scalar fields populated, `ImmutableBinScalars` has a public non-static `writeTo(DataOutput)`, has a public static `readFrom(DataInput)`, and `readFrom` returns a type assignable to `BinScalars`."
    },
    {
      "evidence": "The prompt says 'When org.immutables:serial is on the compilation classpath ... generated implementations gain' the methods, and 'Without the serial artifact, generation is unchanged.' The repo also makes classpath gating discoverable: `Proto.java:184-197` and `Proto.java:424-426` check `environment().hasSerialModule()` before serial features activate.",
      "fairness": "Prompt-stated",
      "name": "serialArtifactControlsActivation",
      "qualityCheck": "Fair. The string search is shallow, but it is checking the exact signatures named in the prompt and only for absence.",
      "verifies": "With the normal test build, an eligible immutable still round-trips; when a fresh `@Value.Immutable` source is annotation-processed with only `org.immutables:value` on classpath/processorpath, the generated source text contains neither `writeTo(java.io.DataOutput` nor `readFrom(java.io.DataInput`."
    },
    {
      "evidence": "The prompt explicitly says builder-built values must support 'primitive and boxed scalars.'",
      "fairness": "Prompt-stated",
      "name": "boxedScalarsRoundTrip",
      "qualityCheck": "Fair and straightforward.",
      "verifies": "A value whose attributes are all boxed scalar types (`Boolean`, `Byte`, `Character`, `Short`, `Integer`, `Long`, `Float`, `Double`) serializes and deserializes to an equal value."
    },
    {
      "evidence": "The prompt says 'Distinct attributes must never be conflated; a type that cannot distinguish them safely receives neither method' and 'Unsupported ... shapes must receive neither method rather than a partial form.'",
      "fairness": "Prompt-stated",
      "name": "distinctNamesWithCollidingHashCodesNeverCorruptTheForm",
      "qualityCheck": "Fair stress case. It does not force any particular tagging scheme; it only forbids corruption or one-sided generation.",
      "verifies": "For a type with attributes `aa` and `bB` (same Java `String.hashCode()`), `ImmutableBinTagCollision` either exposes both binary methods or neither, and if both exist, a value with `aa=\"first\"` and `bB=\"second\"` round-trips exactly."
    },
    {
      "evidence": "Same prompt clauses as above: distinct attributes must not be conflated, and unsafe types should receive neither method rather than a partial form.",
      "fairness": "Prompt-stated",
      "name": "collidingDerivedTagsNeverProduceACorruptForm",
      "qualityCheck": "Fair and permissive. It allows implementations either to support the shape safely or to decline it entirely.",
      "verifies": "For the builder-built `BinTagOverlap` and constructor-built `BinCtorTagOverlap`, each generated immutable either has both binary methods or neither; if methods exist, the populated values round-trip exactly."
    },
    {
      "evidence": "The prompt explicitly states: 'a required auxiliary attribute disables the binary form.'",
      "fairness": "Prompt-stated",
      "name": "requiredAuxiliaryAttributeDisablesBinaryForm",
      "qualityCheck": "Fair and exact.",
      "verifies": "`ImmutableBinRequiredAux` has neither `writeTo(DataOutput)` nor `readFrom(DataInput)`."
    },
    {
      "evidence": "The prompt explicitly says: 'If the value type already declares or inherits either signature, preserve that API and add neither part of a conflicting binary form.'",
      "fairness": "Prompt-stated",
      "name": "existingBinarySignatureIsPreservedWithoutPartialForm",
      "qualityCheck": "Fair and well-targeted to visible API behavior, not internals.",
      "verifies": "`ImmutableBinMethodConflict.getMethod(\"writeTo\", DataOutput.class)` resolves to the inherited `BinMethodBase` method and no `readFrom(DataInput)` is added; `ImmutableBinReadConflict` gets no generated `writeTo`; and `ImmutableBinFullApi` keeps the existing `BinFullApi.writeTo` and does not add a different generated `readFrom` beyond the preexisting `BinFullApi` one."
    },
    {
      "evidence": "The prompt requires builder-built support for optionals and for 'lists, sets ... maps' of supported scalar/string/enum elements.",
      "fairness": "Prompt-stated",
      "name": "containerRoundTrip",
      "qualityCheck": "Fair.",
      "verifies": "A `BinContainers` value with populated `List<String>`, `Set<Integer>`, `Map<String,Integer>`, and `Optional<String>` fields round-trips exactly."
    },
    {
      "evidence": "The prompt requires those container and optional shapes to round-trip and says missing values use their normal default or absent values.",
      "fairness": "Prompt-stated",
      "name": "emptyContainersRoundTrip",
      "qualityCheck": "Fair, though somewhat redundant with the broader container tests.",
      "verifies": "`ImmutableBinContainers.builder().build()` round-trips exactly with all container/optional fields absent or empty as normal for the type."
    },
    {
      "evidence": "The prompt explicitly says 'Values from standard Java and Guava collection or optional factories round-trip' and that Java and Guava optionals, including `OptionalInt`, `OptionalLong`, and `OptionalDouble`, preserve presence.",
      "fairness": "Prompt-stated",
      "name": "factoryBackedContainersAndOptionalsRoundTrip",
      "qualityCheck": "Fair and directly tied to prompt wording.",
      "verifies": "A `BinContainers` built from JDK factory values (`List.of`, `Set.of`, `Map.of`, `Optional.of`) round-trips exactly; a `BinContainers` built from Guava immutable collection factories also round-trips exactly; and a `BinOptionals` using `OptionalInt`, `OptionalLong`, `OptionalDouble`, `Optional<Integer>`, and Guava `Optional<String>` round-trips exactly."
    },
    {
      "evidence": "The prompt says 'added attributes are ignored by older readers,' 'Readers must skip unknown attributes without desynchronizing later ones,' and 'These rules apply to supported constructor-built values as well.'",
      "fairness": "Prompt-stated",
      "name": "forwardReaderSkipsUnknownNewerAttributes",
      "qualityCheck": "Fair and strong: it checks both ignore-new-fields and no-desync behavior.",
      "verifies": "Bytes written by a newer builder-built type read as an older type preserve shared fields (`name`, `age`) while ignoring added fields; bytes written by a newer constructor-built type read as an older constructor-built type produce the older value with only shared parameters; and an unknown middle attribute does not desynchronize reading of a later known attribute."
    },
    {
      "evidence": "The prompt explicitly says 'missing attributes take their normal default or absent values' and that the same rule applies to supported constructor-built values. The repo also shows that existing structural reconstruction relies on ordinary builder/constructor defaults for omitted data (`Immutables.generator:438-460`) and has tests for empty collection/optional defaults (`serial/test/org/immutables/serial/fixture/SerialTest.java:74-98`, `value-fixture/test/org/immutables/fixture/jdkonly/JdkOptionalDefaultTest.java:29-74`).",
      "fairness": "Prompt-stated",
      "name": "backwardReaderDefaultsMissingOlderAttributes",
      "qualityCheck": "Fair. The exact object forms come from the generic defaulting rule rather than a hidden magic value.",
      "verifies": "Reading older bytes as a newer builder-built type yields the newer value with only the shared fields set and all added fields left at that type's ordinary defaults; reading older bytes as a newer constructor-built type yields the constructor-built value with added parameters defaulted/absent (`0`, empty collections, empty optional) rather than misread."
    },
    {
      "evidence": "The prompt explicitly says 'Attribute matching must not depend on declaration order: reordered attributes still match.'",
      "fairness": "Prompt-stated",
      "name": "attributesMatchByNameNotDeclarationOrder",
      "qualityCheck": "Fair and directly on-point.",
      "verifies": "Bytes written from `BinEvoV2` read into `BinEvoV2Reordered` preserve `name`, `age`, `email`, and `roles` by field identity rather than source declaration order."
    },
    {
      "evidence": "The prompt explicitly says 'A writer/reader type mismatch is also treated as absent, including mismatched container elements and map keys or values. These rules apply to supported constructor-built values as well.'",
      "fairness": "Prompt-stated",
      "name": "changedAttributeTypeIsTreatedAsAbsentNotMisdecoded",
      "qualityCheck": "Fair. It exercises both scalar and container mismatches without overcoupling to implementation strategy.",
      "verifies": "When an attribute's declared type changes, reading older/newer bytes yields the target type with shared fields preserved and the mismatched field left absent/defaulted rather than decoded from incompatible data; the same holds for constructor-built scalar and container mismatches."
    },
    {
      "evidence": "The prompt says compatibility follows encoded shape, not declared type name, and that writer/reader mismatches are treated as absent rather than matched by position.",
      "fairness": "Prompt-stated",
      "name": "changedScalarContainerShapeIsTreatedAsAbsent",
      "qualityCheck": "Fair and precise.",
      "verifies": "Bytes written from a scalar `payload` field and read into a `List<String> payload` field produce the target value with `label` preserved and `payload` left at its ordinary absent/default state."
    },
    {
      "evidence": "The prompt explicitly includes 'mismatched container elements' in the rule that type mismatches are treated as absent.",
      "fairness": "Prompt-stated",
      "name": "changedContainerElementTypeIsTreatedAsAbsent",
      "qualityCheck": "Fair.",
      "verifies": "Bytes written from `List<Integer> items` and read as `List<String> items` preserve `label` and leave `items` empty rather than attempting per-element coercion."
    },
    {
      "evidence": "The prompt says 'renamed attributes behave as missing rather than matching by position.'",
      "fairness": "Prompt-stated",
      "name": "renamedAttributeIsTreatedAsAbsentNotMatchedByPosition",
      "qualityCheck": "Fair and directly aligned with the prompt.",
      "verifies": "Bytes written with attribute `title` and read by a type with `heading` plus `count` produce the target value with `count` preserved and `heading` left at its declared default, not populated from the old `title` value by ordinal position."
    },
    {
      "evidence": "The prompt explicitly includes 'mismatched ... map keys' in the 'treated as absent' rule.",
      "fairness": "Prompt-stated",
      "name": "changedMapKeyTypeIsTreatedAsAbsent",
      "qualityCheck": "Fair.",
      "verifies": "Bytes written from `Map<Integer,String> entries` and read as `Map<String,String> entries` preserve `label` and leave `entries` at its ordinary empty/default state."
    },
    {
      "evidence": "The prompt explicitly includes 'mismatched ... map ... values' in the 'treated as absent' rule.",
      "fairness": "Prompt-stated",
      "name": "changedMapValueTypeIsTreatedAsAbsent",
      "qualityCheck": "Fair.",
      "verifies": "Bytes written from `Map<String,Integer> entries` and read as `Map<String,String> entries` preserve `label` and leave `entries` at its ordinary empty/default state."
    },
    {
      "evidence": "The prompt explicitly says 'Derived and auxiliary attributes are omitted. Derived attributes are recomputed during construction, optional auxiliary attributes use their normal defaults.'",
      "fairness": "Prompt-stated",
      "name": "derivedAndAuxiliaryAttributesAreNotStored",
      "qualityCheck": "Fair and user-visible.",
      "verifies": "After round-tripping a `BinDerived` value whose `memo` was explicitly set, the read value has the same `base`, recomputes `doubled` from `base`, and has `memo` reset to the type's normal default rather than the written override."
    },
    {
      "evidence": "The prompt explicitly lists enums as supported scalars and also includes sets, maps, and optionals of supported enum elements.",
      "fairness": "Prompt-stated",
      "name": "enumAttributesRoundTripInEveryPosition",
      "qualityCheck": "Fair.",
      "verifies": "A value with an enum scalar, enum set, enum-keyed map, and optional enum round-trips exactly."
    },
    {
      "evidence": "The prompt explicitly says 'enums are recovered by matching constant name even after reordering.'",
      "fairness": "Prompt-stated",
      "name": "enumRecoveredByConstantNameAcrossReorderedConstants",
      "qualityCheck": "Fair and direct.",
      "verifies": "Bytes written using `BinColor` read as the analogous type using reordered enum `BinColorAlt` recover `GREEN`, the set members, the map key, and the optional favorite by enum constant name rather than ordinal position."
    },
    {
      "evidence": "The prompt explicitly says 'Primitive arrays and reference arrays of supported scalar, string, or enum elements round-trip by contents.'",
      "fairness": "Prompt-stated",
      "name": "arraysRoundTrip",
      "qualityCheck": "Fair.",
      "verifies": "Primitive array, primitive-int array, `String[]`, boxed `Integer[]`, and enum `BinColor[]` fields all round-trip with element-by-element equality."
    },
    {
      "evidence": "The prompt explicitly names 'lists, sets, sorted sets, multisets, maps, sorted maps, bimaps, and multimaps' and says 'Multisets preserve counts, and multimaps preserve per-key multiplicity.'",
      "fairness": "Prompt-stated",
      "name": "bagsPreserveCountsKindAndOrder",
      "qualityCheck": "Fair. Equality does not over-pin concrete implementation classes.",
      "verifies": "A value containing a `Multiset<String>`, `BiMap<String,Integer>`, naturally ordered `SortedSet<Integer>`, `Multimap<String,Integer>`, `ListMultimap<String,Integer>`, `SetMultimap<String,Integer>`, and naturally ordered `SortedMap<String,Integer>` round-trips exactly, including multiset counts and list-multimap multiplicity/order."
    },
    {
      "evidence": "The prompt explicitly says Java and Guava optionals preserve presence, including `OptionalInt`, `OptionalLong`, and `OptionalDouble`.",
      "fairness": "Prompt-stated",
      "name": "optionalFlavorsRoundTripPresentAndAbsent",
      "qualityCheck": "Fair.",
      "verifies": "A `BinOptionals` with all optional flavors present round-trips exactly, and a `BinOptionals` with all of them absent round-trips exactly."
    },
    {
      "evidence": "The prompt says builder-built values must support 'direct nested generated immutables' and later clarifies required nested support for direct, acyclic generated immutables that also receive the binary form.",
      "fairness": "Prompt-stated",
      "name": "nestedValueRoundTrips",
      "qualityCheck": "Fair.",
      "verifies": "A builder-built value containing a direct nested generated immutable field round-trips exactly."
    },
    {
      "evidence": "The prompt explicitly says required direct nested support applies 'regardless of package.'",
      "fairness": "Prompt-stated",
      "name": "crossPackageNestedImmutableRoundTrips",
      "qualityCheck": "Fair.",
      "verifies": "A value whose direct nested generated immutable comes from a different package round-trips exactly."
    },
    {
      "evidence": "The prompt says 'Unsupported or recursive shapes must receive neither method rather than a partial form, and must not prevent unrelated eligible values from receiving the methods.'",
      "fairness": "Prompt-stated",
      "name": "recursiveNestedGraphDoesNotBlockUnrelatedValues",
      "qualityCheck": "Fair and important integration coverage.",
      "verifies": "For the recursive pair `BinLoopA`/`BinLoopB`, each generated class either has both methods or neither; regardless of that, an unrelated eligible sibling type (`BinLeaf`) still gets working binary round-trip methods."
    },
    {
      "evidence": "The prompt explicitly says 'Concrete type arguments do not by themselves disqualify a direct nested generated immutable' and that required nested support applies regardless of concrete type arguments.",
      "fairness": "Prompt-stated",
      "name": "nestedGenericValueTypeRoundTrips",
      "qualityCheck": "Fair; it also guards against inner-value decoding desynchronizing later outer fields.",
      "verifies": "A value containing a direct nested generated immutable with concrete type arguments (`BinGenericLeaf<String>`) round-trips exactly, and the later outer scalar `trailer` still reads as `44`."
    },
    {
      "evidence": "The prompt requires direct nested generated immutables to support version changes and says 'Their version changes must not desynchronize following outer attributes.' It also says added attributes are ignored by older readers and missing attributes take their normal defaults.",
      "fairness": "Prompt-stated",
      "name": "renamedNestedReaderSupportsVersionSkewWithoutDesync",
      "qualityCheck": "Fair and strong.",
      "verifies": "When outer bytes contain a newer nested immutable version, reading as the older outer type still preserves the outer `trailer` and the shared nested field `a`; and when older nested bytes are read as the newer outer type, the outer `trailer` is preserved, shared nested field `a` is preserved, and the new nested field takes its normal default."
    },
    {
      "evidence": "The prompt says 'Value types may declare type parameters' while excluding unresolved type-variable attributes from the required surface.",
      "fairness": "Prompt-stated",
      "name": "genericValueTypeRoundTrips",
      "qualityCheck": "Fair.",
      "verifies": "A type that merely declares a type parameter but stores only supported non-type-variable attributes (`String` and `List<String>`) still round-trips exactly."
    },
    {
      "evidence": "The prompt says constructor-built values must at least support types whose stored non-auxiliary attributes are all constructor parameters using scalars, enums, optionals, lists, sets, or maps.",
      "fairness": "Prompt-stated",
      "name": "constructorBuiltValueRoundTrips",
      "qualityCheck": "Fair and directly within the minimum required constructor surface.",
      "verifies": "A constructor-built immutable whose stored non-auxiliary attributes are `String`, `int`, and `List<String>` round-trips exactly."
    },
    {
      "evidence": "The prompt explicitly requires constructor-built support for scalars, enums, optionals, lists, sets, and maps, and says 'other faithfully reconstructible constructor forms may also be supported.' It also says unsupported shapes must receive neither method rather than a partial form.",
      "fairness": "Prompt-stated",
      "name": "constructorBuiltValueWithVariedShapesRoundTrips",
      "qualityCheck": "Fair. It is careful not to require support for the optional extra constructor cases.",
      "verifies": "A constructor-built value whose parameters are a scalar, enum, optional, set/list-like collection, and map round-trips exactly; for the extra constructor-built shapes with a direct nested immutable or a defaulted non-parameter attribute, the generated immutable either has both binary methods or neither, and if both exist the sample values round-trip exactly."
    },
    {
      "evidence": "The prompt explicitly excludes `Object`, unresolved type-variable attributes, arrays of arrays, collections of collections, and nested values inside containers from the required surface, and says unsupported shapes must receive neither method and must not block unrelated eligible values.",
      "fairness": "Prompt-stated",
      "name": "typeWithUnrepresentableAttributeHasNoBinaryForm",
      "qualityCheck": "Fair and directly tied to the exclusions in the prompt.",
      "verifies": "Types with an `Object` attribute, an unresolved type-variable attribute, a direct nested immutable that is itself unsupported, arrays-of-arrays / list-of-lists, or nested generated immutables inside containers have neither binary method; an unrelated supported scalar type still round-trips exactly."
    },
    {
      "evidence": "The prompt does not require nullable support, but it does require that unsupported shapes receive neither method rather than a partial form, and that any generated form round-trip equal values. The repo also shows current structural serialization already handles nullable shapes (`serial/test/org/immutables/serial/fixture/NullableCollections.java:10-22`, `serial/test/org/immutables/serial/fixture/SerialTest.java:74-98`), making this permissive test especially fair.",
      "fairness": "Prompt-stated",
      "name": "nullableAttributeEitherRoundTripsOrDisablesBinaryForm",
      "qualityCheck": "Fair and intentionally permissive; it does not force support for a non-required extension.",
      "verifies": "For nullable scalar and nullable direct-nested cases, each immutable either has both methods or neither; if both methods exist, absent-null and present-nested samples round-trip exactly."
    },
    {
      "evidence": "The prompt explicitly says 'Strings of any length round-trip.'",
      "fairness": "Prompt-stated",
      "name": "veryLongStringRoundTrips",
      "qualityCheck": "Fair and valuable boundary coverage.",
      "verifies": "A `String` far longer than 65,535 bytes in modified UTF-8 (built from 70,000 repetitions of `xß漢`) round-trips exactly inside an otherwise supported value."
    },
    {
      "evidence": "The prompt explicitly says 'The encoded data carries no attribute names.'",
      "fairness": "Prompt-stated",
      "name": "wireCarriesNoAttributeNames",
      "qualityCheck": "Fair black-box check of a user-visible wire-format property. It does not overcouple to any particular encoding beyond the stated prohibition.",
      "verifies": "The raw bytes produced for a value whose sole attribute is named `extremelyDistinctiveTokenAttribute` do not contain that attribute name as a substring when viewed losslessly as ISO-8859-1 text."
    },
    {
      "evidence": "The prompt explicitly requires 'Incomplete input produces an error rather than a wrong value.' The more specific `IOException` expectation follows standard `DataInput` semantics: truncated reads from `DataInput` methods signal `EOFException`/`IOException`, so surfacing an `IOException`-family failure is the conventional contract for this exact case.",
      "fairness": "Standard external semantics",
      "name": "truncatedDataFailsInsteadOfProducingAValue",
      "qualityCheck": "Fair, though it is the most specific assertion in the patch; the specificity is still grounded in standard `DataInput` behavior rather than repo internals.",
      "verifies": "If the final three bytes are removed from a valid serialized `BinScalars` payload, invoking `readFrom` via reflection fails and the underlying cause is an `IOException` rather than yielding a value."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Dockerfile guidelines**

Status: WARNING

WARNING: Dockerfile invokes both the Maven wrapper and the system Maven: it runs './mvnw -B -ntp -version' but later uses 'mvn -B -ntp ...' for dependency and build steps. This can produce non-reproducible builds because the system 'mvn' version in the base image may differ from the wrapper. Recommendation: use './mvnw' for all Maven invocations to pin Maven tooling.

WARNING: The Dockerfile itself cannot verify that all project dependencies are pinned in the project's pom.xml. Ensure the pom.xml declares explicit versions (or appropriate dependencyManagement) so dependency resolution is deterministic. The Dockerfile explicitly fetches com.fasterxml.jackson:jackson-bom:2.21.2 and tools.jackson:jackson-bom:3.1.0; confirm these BOM versions are intentional as they may conflict.

(No errors detected.)

Note: Internet access is available during `docker build`, but not when running the container. Test patch is injected into the container after build. Ensure your Dockerfile installs all dependencies at build time so the environment works fully offline after build.

```json
{
  "all_issues": "WARNING: Dockerfile invokes both the Maven wrapper and the system Maven: it runs './mvnw -B -ntp -version' but later uses 'mvn -B -ntp ...' for dependency and build steps. This can produce non-reproducible builds because the system 'mvn' version in the base image may differ from the wrapper. Recommendation: use './mvnw' for all Maven invocations to pin Maven tooling.\n\nWARNING: The Dockerfile itself cannot verify that all project dependencies are pinned in the project's pom.xml. Ensure the pom.xml declares explicit versions (or appropriate dependencyManagement) so dependency resolution is deterministic. The Dockerfile explicitly fetches com.fasterxml.jackson:jackson-bom:2.21.2 and tools.jackson:jackson-bom:3.1.0; confirm these BOM versions are intentional as they may conflict.\n\n(No errors detected.)",
  "base_image_compliant": {
    "explanation": "FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest is an accepted Olympus per-language JVM base image.",
    "status": "OK"
  },
  "dependencies_installed": {
    "explanation": "Dockerfile runs Maven commands to fetch dependencies (mvn dependency:get, mvn dependency:go-offline) and performs a mvn -DskipTests install. This installs project dependencies and prepares the build cache as expected for a JVM/Maven project.",
    "status": "OK"
  },
  "interactive_shell": {
    "explanation": "Container ends with CMD [\"/bin/bash\"] which provides an interactive shell for developers.",
    "status": "OK"
  },
  "no_test_execution": {
    "explanation": "Tests are not executed during build: the install step uses -DskipTests and there are no test.sh or explicit test commands run.",
    "status": "OK"
  },
  "package_manager_installation": {
    "explanation": "No package managers are installed in the Dockerfile. The chosen base image (olympus-base-jvm) is expected to provide the JVM toolchain (Maven/Java) and no attempts are made to re-install preexisting package managers.",
    "status": "OK"
  },
  "registry_compliant": {
    "explanation": "Base image is pulled from the allowed public.ecr.aws registry and matches an accepted Olympus JVM base image.",
    "status": "OK"
  },
  "repository_setup": {
    "explanation": "WORKDIR is set to /app and the Dockerfile copies the repository files with COPY . .. The Dockerfile does not attempt to git clone the repository.",
    "status": "OK"
  },
  "security_safety": {
    "explanation": "No remote install scripts (curl | sh) are executed, no obfuscated/encoded commands are present, no host escapes or docker.sock mounts, and no secrets are hard-coded. The Dockerfile appears free of malicious patterns.",
    "status": "OK"
  },
  "user_creation_compatible": {
    "explanation": "No user or group is created in the Dockerfile; this is acceptable. (If user creation is added later, it must follow the required name and UID/GID constraints.)",
    "status": "OK"
  },
  "version_pinning": {
    "explanation": "WARNING: The Dockerfile mixes the Maven wrapper and the system Maven: it runs './mvnw -B -ntp -version' but subsequent build/dependency commands invoke 'mvn ...'. Using the system 'mvn' (from the base image) can lead to unpinned Maven tooling/version differences. For reproducible builds prefer invoking the project wrapper ('./mvnw') for all Maven commands so the Maven version is pinned to the project's wrapper. Also: the Dockerfile itself cannot verify whether the project's pom.xml pins all dependency versions—ensure the pom declares explicit versions (or uses a consistent dependency management strategy). Additionally, the Dockerfile explicitly fetches multiple jackson BOM artifacts (com.fasterxml.jackson:jackson-bom:2.21.2 and tools.jackson:jackson-bom:3.1.0) which may indicate conflicting BOM versions; confirm this is intentional.",
    "status": "warning"
  }
}
```

---

**Shipd Bot Description Warnings**

> "those parameters are scalars, enums, optionals, lists, sets, or maps."

Soften this from an exclusive rule to the minimum required surface. The hidden tests require these constructor-parameter shapes to work, but they also explicitly allow some extra constructor cases (for example nested/defaulted constructor-built values) to be either supported or omitted. Suggested rewrite: "Constructor-built values should at least work when the stored constructor parameters are scalars, enums, optionals, lists, sets, or maps."

> "stable per-attribute tags rather than declaration order"

Describe the observable compatibility rule instead of prescribing a specific matching mechanism. The tests care that reordered attributes still line up correctly and renamed ones do not match by position; they do not require the description to mandate "stable tags". Suggested rewrite: "Stored attributes must not match by declaration order; reordering should preserve matches, and renames should behave like missing attributes rather than positional matches."

> "Framing lets a reader skip unknown attributes without misreading later ones."

This is an internal wire-format prescription. State the required behavior without naming the technique. Suggested rewrite: "Readers must be able to skip unknown attributes without desynchronizing later ones."

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 4 total suggestions, including 2 high-priority removals (an obvious round-trip statement and an open-ended allowance). With 3+ suggestions and presence of HIGH items, the correct verdict is request_changes.",
  "suggestions": [
    {
      "priority": "high",
      "quote": "The implementation receives a public instance method `writeTo(java.io.DataOutput)` and a public static method `readFrom(java.io.DataInput)`; reading a written value yields an equal value.",
      "suggestion": "Delete the clause \"; reading a written value yields an equal value.\" This is an obvious round‑trip property any competent solver will ensure; it adds length without new requirements."
    },
    {
      "priority": "high",
      "quote": "Constructor-built values must at least support types whose stored non-auxiliary attributes are all constructor parameters using scalars, enums, optionals, lists, sets, or maps; other faithfully reconstructible constructor forms may also be supported.",
      "suggestion": "Remove the trailing permissive clause \"; other faithfully reconstructible constructor forms may also be supported.\" It introduces open-ended scope and ambiguity without adding testable requirements."
    },
    {
      "priority": "medium",
      "quote": "These rules apply to supported constructor-built values as well.",
      "suggestion": "Remove this sentence. It restates behavior already implied by the general compatibility rules and the earlier requirement to generate methods only when the value can be reconstructed faithfully."
    },
    {
      "priority": "low",
      "quote": "Concrete type arguments do not by themselves disqualify a direct nested generated immutable.",
      "suggestion": "Remove this corollary. It follows from the earlier statements that value types may be generic and that direct nested generated immutables are supported; keeping only those primary rules is sufficient."
    }
  ],
  "summary": "- [HIGH] Delete the clause: \"; reading a written value yields an equal value.\" from “The implementation receives a public instance method `writeTo(java.io.DataOutput)` and a public static method `readFrom(java.io.DataInput)`; reading a written value yields an equal value.” Rationale: round‑trip equality is an obvious default property and adds no actionable detail.\n- [HIGH] Remove the open-ended allowance: “other faithfully reconstructible constructor forms may also be supported.” from “Constructor-built values must at least support types whose stored non-auxiliary attributes are all constructor parameters using scalars, enums, optionals, lists, sets, or maps; other faithfully reconstructible constructor forms may also be supported.” Rationale: it creates ambiguity and expands scope without concrete requirements.\n- [MEDIUM] Cut the redundant sentence: “These rules apply to supported constructor-built values as well.” Rationale: compatibility/absence rules already apply generically and are implied by the “reconstructed faithfully” requirement.\n- [LOW] Remove: “Concrete type arguments do not by themselves disqualify a direct nested generated immutable.” Rationale: it’s a corollary of prior statements (generics allowed; direct nested immutables supported) and can be inferred without restating.",
  "verdict": "request_changes"
}
```
