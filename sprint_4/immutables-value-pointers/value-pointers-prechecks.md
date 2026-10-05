**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥40 messages, ≥250 LOC

This task numbers: Median files: 6, messages: 125, LOC: 1037

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "4588d2d26ae16f9c339d1b212c687065d4fbf3cb2aef74f69b43467cabbc828b",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "hermes",
      "candidate_summary": "Extends Jackson core with JsonPointerTemplate supporting compile-time templates with wildcards and named captures, plus matching (full/prefix), capture resolution to JsonPointer, and helpers to search TreeNode and stream contexts. Also augments JsonPointer with convenience methods for segment counting, decoding, prefix checks, and relative computation.",
      "confidence": 0.94,
      "contentAuthoredAt": 1782857544705,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds a code generator to Immutables: for @Value.Enclosing families it emits a companion <Enclosing>Pointers class with Pointer parsing/rendering, resolve(Object, Pointer), and update(Object, Pointer, UnaryOperator) that walks and structurally rebuilds generated immutable implementations along attributes.",
        "Submission’s pointer semantics include optional/list/array/string-keyed-map step handling, distinct PointerMiss/PointerType exceptions, nullable handling, and immutability-preserving updates; it prohibits stepping into derived/lazy/opaque attributes.",
        "Candidate modifies Jackson core to introduce JsonPointerTemplate with RFC6901-compatible escaping plus wildcards (*)/** and named captures {name}, adds matching (full/prefix), capture resolution, and search helpers over TreeNode and stream contexts; it does not perform object updates.",
        "Candidate extends existing JsonPointer APIs (segmentCount, asDecodedSegments, startsWith, relativeTo, isEmpty) and integrates matching into TokenStreamContext, JsonParser, and JsonGenerator; the submission integrates into the Immutables annotation processor (new generator, meta model) rather than runtime libraries.",
        "Pointer string rules and responsibilities differ materially: submission’s empty string denotes root and pointers target generated value objects with attribute names and container indexing; candidate’s templates target JSON structures with wildcard/capture-driven matching and no update semantics."
      ],
      "one_liner": "Both introduce path-like pointer utilities, but one generates typed navigators/updaters for Immutables value families while the other adds wildcard/capture template matching around Jackson’s JsonPointer and streaming/tree APIs.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "The two patches land in different repositories and layers: one augments the Immutables annotation processor to generate a companion pointers API that can resolve and immutably update paths through generated value objects; the other adds a runtime template-matching facility around Jackson’s JsonPointer with wildcards/captures and stream/tree integration. Any superficial similarity in using RFC 6901 escaping is generic to pointer strings; the modified surfaces, behaviors, and lifecycles are unrelated, so they teach different tasks.",
      "similarity": 0.5692055821418762,
      "submission_summary": "Adds a new generator to Immutables that, for eligible @Value.Enclosing families, emits a <Enclosing>Pointers companion with Pointer parse/render, resolve to navigate generated immutable implementations by attribute steps (including optionals/lists/arrays/string-keyed maps), and update to rebuild only the path with type/shape checks and specific miss/type exceptions. Wires this into the processor via a new PointerModel and Processor hookup.",
      "title": "JsonPointer Template Matching",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Generates a compact binary serialization form for eligible @Value.Immutable types by adding instance writeTo(DataOutput) and static readFrom(DataInput) methods, backed by a new BinaryWire utility. It computes per‑attribute tags/type codes, supports specific scalar/container/nested shapes, tolerates versioning, and only generates when the serial module is present and no API conflicts exist.",
      "confidence": 0.95,
      "contentAuthoredAt": 1782991288807,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission generates per-enclosing-type companion classes (<Enclosing>Pointers) with a nested Pointer type and static parse/render/resolve/update utilities; candidate injects writeTo(DataOutput) and readFrom(DataInput) methods into immutable implementations.",
        "Submission’s behavior is pointer parsing/round‑tripping, navigation (resolve) across attributes with typed failure modes, and structural updates with copy‑on‑write along the path; candidate’s behavior is a framed, tag‑based binary encoding/decoding of attribute values with versioning tolerance.",
        "Submission’s scope includes precise rules for optional/list/array/string‑keyed map stepping, disallowing sets/multimaps/etc., and enforcing update type checks; candidate’s scope includes supported scalar/enum/string/optional/array/collection/map shapes, nested immutables that also support the form, and ignores unknown attributes on read.",
        "Submission integrates a new Pointers generator/template (Pointers.generator, Pointers.java), adds PointerModel meta, and wires it in Processor; candidate modifies Immutables.generator, adds BinaryWire primitives, and extends ValueAttribute/ValueType for binary tags/type codes and eligibility.",
        "Submission only targets @Value.Enclosing families without type parameters and requires with‑methods; candidate is gated by presence of the serial module and avoids generation if conflicting methods exist or unsupported attributes are present."
      ],
      "one_liner": "Both extend the Immutables processor to generate extra helpers for generated values, but one adds pointer navigation/update companions while the other adds compact binary serialization methods.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "Although both touch the same repository and the value processor, they implement unrelated features at different purpose‑matched surfaces. The submission adds a new codegen companion for pointer navigation and structural updates, while the candidate adds binary serialization APIs and wire primitives to immutable implementations. Any overlap (e.g., both extend meta/ValueType) is generic scaffolding for different generators, not the same behavioral task.",
      "similarity": 0.5597561597824097,
      "submission_summary": "Adds a Pointers code generator that, for eligible @Value.Enclosing families, emits a <Enclosing>Pointers companion with a nested Pointer type and static parse/render/resolve/update methods. It implements pointer syntax/round‑trip, typed miss/type errors, container and optional stepping, and copy‑on‑write updates of addressed subvalues.",
      "title": "Compact binary form for generated immutables",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Adds a generator that emits a “[Enclosing]Fold<R>” interface for eligible @Value.Enclosing families, defining abstract case methods and fold dispatch to compute results bottom‑up over family-typed attributes with memoization and shape-aware handling of optionals and collections.",
      "confidence": 0.92,
      "contentAuthoredAt": 1783281221104,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission generates a “[Enclosing]Pointers” class with a nested Pointer type and parse/render of pointer strings, including escape handling (~0/~1), and distinct error types for malformed strings, type mismatches, and misses.",
        "Submission resolves a pointer against a root value through attributes/containers and supports targeted structural updates that rebuild only the path while preserving off-path identity and order; it validates replacement types and prohibits stepping into opaque shapes (e.g., sets, non-string-keyed maps, primitive arrays).",
        "Candidate generates a “[Enclosing]Fold<R>” interface with abstract case methods and default/static fold dispatch that computes results bottom‑up across family-typed attributes, memoizes via IdentityHashMap to avoid re-folding shared nodes, and handles optionals, lists/sets/multisets, arrays, maps/multimaps by shape.",
        "Generated surfaces differ in kind and purpose: a concrete utility class with navigation/update APIs versus a generic visitor/fold interface with case methods and dispatch."
      ],
      "one_liner": "Both generate companions for @Value.Enclosing families, but one adds JSON-pointer-like navigation and in-place path updates while the other adds a bottom-up fold over family-typed attributes.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [
          {
            "candidate": "Generates a package-level companion interface named after an @Value.Enclosing type (suffix “Fold”) when a nested abstract family has two or more @Value.Immutable implementations; families with fewer implementations or outside @Value.Enclosing receive nothing.",
            "submission": "Generates a package-level companion named after an @Value.Enclosing type (suffix “Pointers”) when it has a nested abstract family with two or more nested @Value.Immutable implementations without their own type parameters; otherwise nothing is generated.",
            "what_overlaps": "Both gate generation on detecting an @Value.Enclosing family with at least two nested immutable implementations and skip otherwise."
          },
          {
            "candidate": "Passing a family-typed instance that is not one of the generated implementations throws an IllegalArgumentException.",
            "submission": "Operations throw IllegalArgumentException when the root is not a generated implementation of the enclosing type.",
            "what_overlaps": "Both enforce that operations apply only to generated implementations, rejecting foreign instances."
          }
        ],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both patches live in the same processor and detect the same notion of an @Value.Enclosing “family,” they implement wholly different features on different generated surfaces: one produces a pointer parser/resolver/updater with fine‑grained error semantics, the other a generic fold interface with case dispatch and memoization. The only overlaps are repository boilerplate (adding a generator invocation) and shared eligibility logic, not the same behavioral change. These would teach different debugging lessons and should co‑exist.",
      "similarity": 0.5462086028044864,
      "submission_summary": "Adds a generator that emits a “[Enclosing]Pointers” companion class for eligible @Value.Enclosing families, providing a Pointer type, parse/render, resolve, and update over nested immutable implementations with strict shape/type rules and targeted rebuilding on updates.",
      "title": "Exhaustive fold for enclosed value families",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Extends immutable generation to include a nested Patch type per value, plus diff/apply/then methods that compute sparse attribute-level differences, apply them without replacing whole containers, and combine patches; supports recursion into nested immutables, optionals, and maps while preserving container shapes.",
      "confidence": 0.94,
      "contentAuthoredAt": 1782801753255,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission generates a package-level <EnclosingName>Pointers companion for @Value.Enclosing families, with Pointer parse/render, resolve(Object, Pointer), and update(Object, Pointer, UnaryOperator) and dedicated exception types; the candidate adds a nested Patch type to each @Value.Immutable with diff/apply/then methods.",
        "Submission’s behavior is string-pointer-based navigation and selective rebuilding along a path (lists/arrays indexed by digits, maps with String keys only, optionals as addressable steps); the candidate’s behavior is computing sparse attribute-level differences between two instances and applying/combining them without string addressing.",
        "Submission generates only for enclosing types that have two or more nested immutable implementations (no generics) that generate withers; the candidate generates for individual immutables with stored attributes (builder or constructor) and supports generics.",
        "Submission introduces MalformedPointerException, PointerMissException, and PointerTypeException and validates pointer syntax and step applicability; the candidate doesn’t introduce new exception types and focuses on container- and value-level merge semantics (sets, multisets, multimaps, maps, optionals, arrays).",
        "Submission integrates via a new Pointers.generator, Pointers.java, a Processor hook, and a new PointerModel; the candidate integrates by extending Immutables.generator and enhancing ValueAttribute/ValueType to support Patch generation."
      ],
      "one_liner": "They add two different codegen features: one generates a companion to parse/render/resolve/update via string pointers over families of enclosed immutable values, while the other generates per-immutable structural diff/patch types with diff/apply/then semantics.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both extend the Immutables processor, they target different features and code surfaces: one adds a new generator and companion API for pointer-driven navigation/updates over enclosing families; the other augments each immutable with a structural diff/patch facility. Their observable behaviors, generation conditions, and error/typing semantics do not overlap materially, and the shared edits (ValueType metadata) serve unrelated purposes.",
      "similarity": 0.501025378704071,
      "submission_summary": "Adds a new generator that emits a <Enclosing>Pointers companion for eligible @Value.Enclosing families, implementing a Pointer type with parse/render, resolve over attributes/containers, and update that selectively rebuilds only along the addressed path with strict type and step checks.",
      "title": "Structural differences for generated immutables",
      "verdict": "distinct"
    },
    {
      "authorUsername": "hermes",
      "candidate_summary": "Augments YAVI’s validation core so each ConstraintViolation carries a ViolationPath composed of PathElements (FIELD/INDEX/KEY), with builder support, path rendering (including JSON Pointer), matching, ordering, grouping, and propagation through nested and collection validators.",
      "confidence": 0.93,
      "contentAuthoredAt": 1782466234252,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission modifies the Immutables annotation processor to generate per-enclosing-type companion Pointers classes that can parse, resolve into object graphs of generated immutable implementations, and update values immutably along the path with fine-grained type and miss exceptions.",
        "Submission’s behavior covers container stepping (lists, arrays, maps with string keys), optional unwrapping, attribute presence/null handling, and rebuild-on-update semantics while preserving off-path instance identity and collection ordering; the candidate has no object graph resolution or update semantics.",
        "Candidate changes the YAVI core validator to attach a structured ViolationPath to each ConstraintViolation, propagate and compose it through nested/collection validators, provide sorting/grouping/matching by path, and render multiple string formats; there is no code generation or coupling to immutable types.",
        "Candidate adds glob-style path matching, ordering, and various path utilities (startsWith/endsWith/relativize/commonPrefix), which are unrelated to the submission’s pointer-walk/update semantics."
      ],
      "one_liner": "Both introduce structured path/pointer representations with JSON Pointer-style escaping, but in different repos for very different purposes: code-generated resolvers/updaters for Immutables vs. validation path tracking and querying in YAVI.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [
          {
            "candidate": "toJsonPointer escapes tilde as '~0' and slash as '~1' when rendering paths.",
            "submission": "Rendering a parsed pointer returns the original string, using JSON Pointer escapes where '~' becomes '~0' and '/' becomes '~1'.",
            "what_overlaps": "Both describe JSON Pointer-compatible escaping rules for tokens."
          },
          {
            "candidate": "ViolationPath.root and ViolationPath.of(List/varargs) yield the root when the element list is empty.",
            "submission": "The empty string is the root pointer.",
            "what_overlaps": "Both define a notion of a root path when no steps/elements are present."
          }
        ],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "The submission adds a generator and meta-model in the Immutables processor to emit companion Pointers classes that can parse, resolve, and update values within families of generated immutable implementations, including rich error semantics and strict type checks. The candidate extends YAVI’s validation API to carry a structured path on violations, with utilities for rendering, matching, grouping, and composition through nested validators. Any overlap (JSON Pointer escaping and the concept of a root path) is generic plumbing, not the same feature or surface; the modified files, purposes, and behaviors are unrelated across repos.",
      "similarity": 0.497458815574646,
      "submission_summary": "Extends the Immutables processor to generate per-enclosing-type Pointers companions that parse/render pointers, resolve into generated immutable object graphs, and apply updates immutably along the path with specific miss/type exceptions and container/optional handling. Integrates the generator into Processor and adds a PointerModel to determine eligible steps and implementations.",
      "title": "Path Violation Segments",
      "verdict": "distinct"
    }
  ]
}
```

---

**Test Fairness**

Coverage Suggestions (2) - Not Blockers

Advisory only — these don't affect the check result.

Generic family suppression
Add a fixture where the only would-be family members themselves declare type parameters, and assert that no `*Pointers` companion is generated for that enclosing type.

Foreign replacement root
Add an `update(root, "", op)` case where the operator returns a generated implementation from a different enclosing family, and assert `PointerTypeException` plus no mutation of the original root.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Generic family suppression",
      "suggestion": "Add a fixture where the only would-be family members themselves declare type parameters, and assert that no `*Pointers` companion is generated for that enclosing type."
    },
    {
      "area": "Foreign replacement root",
      "suggestion": "Add an `update(root, \"\", op)` case where the operator returns a generated implementation from a different enclosing family, and assert `PointerTypeException` plus no mutation of the original root."
    }
  ],
  "error": "",
  "executionTimeSeconds": 330.538536,
  "message": "All hidden tests are fair.",
  "overall": "I do not see an unfair hidden assertion here. Most checks are direct restatements of the prompt, and the few that go beyond literal prompt wording are still reasonably discoverable from the repo: `copy=false` disabling withers, derived/lazy not being settable, and the exact supported optional flavors. The only purely extra-formal assertion is equal pointers having equal hash codes, which is standard Java semantics. The tests are exhaustive but mostly stick to public behavior rather than implementation details; exact exception-class matching is justified because the prompt names the exception types explicitly.",
  "taskSummary": "The task is to add a generated `*Pointers` companion for certain `@Value.Enclosing` families and make that companion expose a public pointer API: `parse(String)`, `render(Pointer)`, `resolve(Object, Pointer)`, and `update(Object, Pointer, UnaryOperator)`. The prompt is unusually specific about generation gating (family size, no type parameters, all relevant nested immutables must have generated `with` methods), pointer string syntax and escaping, exact failure classes (`MalformedPointerException`, `PointerMissException`, `PointerTypeException`), resolve semantics across runtime types, lists/arrays/maps/optionals/nulls, and update semantics including structural sharing, equality short-circuiting, wrong-type rejection, derived/lazy prohibition, and opaque container handling.",
  "tests": [
    {
      "evidence": "Prompt: 'the processor generates in its package a public final companion named after the enclosing type with the suffix `Pointers`' and 'The companion's static `parse(String)` and `render(Pointer)`' plus static `resolve` and `update`. Applying that rule per enclosing type also covers a same-named type in a sibling package.",
      "fairness": "Prompt-stated",
      "name": "companionShapeAndForeignSibling: companion API shape and sibling-package generation",
      "qualityCheck": "Fair; the test checks the exact public API surface the prompt names, not internals.",
      "verifies": "A class named `CircuitPointers` exists in the enclosing type's package, is `public final`, its `parse(String)`, `render(Pointer)`, `resolve(Object, Pointer)`, and `update(Object, Pointer, UnaryOperator)` methods are `static`, and an eligible same-named enclosing type in another package gets its own `other.CircuitPointers` class."
    },
    {
      "evidence": "Prompt: a companion is generated only 'when a type annotated with `@Value.Enclosing` declares a nested abstract type with two or more nested `@Value.Immutable` implementations...' and 'Enclosing types without such a family ... receive nothing.'",
      "fairness": "Prompt-stated",
      "name": "companionShapeAndForeignSibling: no companion for enclosing types without a qualifying family",
      "qualityCheck": "Fair; this is a direct negative case from the generation rule.",
      "verifies": "`StandalonePointers` is absent when an enclosing type has only one nested immutable implementation and therefore no qualifying family."
    },
    {
      "evidence": "Prompt: enclosing types whose relevant implementations 'do not all generate modified copies (the `with` methods), receive nothing.' Repo docs make `copy=false` map to that condition: `value-annotations/src/org/immutables/value/Value.java:80-87` says `copy=false` disables copying methods, including `withAttributeName` methods.",
      "fairness": "Repo-discoverable",
      "name": "companionShapeAndForeignSibling: no companion when copy=false removes withers",
      "qualityCheck": "Fair; the prompt gives the gating rule and the repo explicitly documents that `copy=false` removes withers.",
      "verifies": "`NoCopyPointers`, `MixedCopyPointers`, and `LoosePointers` are absent when some relevant nested immutables do not generate `with` methods because `copy=false` disables copying methods."
    },
    {
      "evidence": "Prompt again gates generation on all relevant implementations generating `with` methods. Repo support makes the needed inference discoverable: `value-annotations/src/org/immutables/value/Value.java:580-585` defines `with` as modify-by-copy attribute methods, and `value-processor/src/org/immutables/value/processor/meta/ValueAttribute.java:223-231` shows only abstract/default attributes are settable while derived/lazy are merely gettable.",
      "fairness": "Repo-discoverable",
      "name": "companionShapeAndForeignSibling: no companion when members have only derived attributes",
      "qualityCheck": "Fair, though it requires reading repo behavior for what counts as a wither-generating attribute.",
      "verifies": "`StampPointers` is absent when the only candidate implementations would not generate `with` methods because they expose only derived/lazy-style readable attributes, not settable ones."
    },
    {
      "evidence": "Prompt says the generated companion is 'public final' with no visibility carve-out based on the enclosing type's own visibility.",
      "fairness": "Prompt-stated",
      "name": "companionShapeAndForeignSibling: companion visibility does not mirror enclosing visibility",
      "qualityCheck": "Fair; the prompt singles out the generated class visibility.",
      "verifies": "`SealedPointers` exists and is `public final` even if the source enclosing type itself is not public."
    },
    {
      "evidence": "Prompt: 'The empty string is the root pointer'; `resolve` walks 'a root by a pointer to the addressed value'; and 'The root must be a generated implementation of the enclosing type without its own type parameters, whether or not it belongs to a family.'",
      "fairness": "Prompt-stated",
      "name": "rootPointerParsesFromEmptyStringAndResolvesRootItself",
      "qualityCheck": "Fair; this is the root-pointer rule applied directly.",
      "verifies": "`render(parse(\"\"))` returns `\"\"`; `resolve(root, \"\")` returns the identical root instance; a generated implementation of the same enclosing type that is not part of a family is also accepted as the root; and resolving `/value` on such a root returns the attribute value."
    },
    {
      "evidence": "Prompt: 'Rendering a parsed pointer returns the original string' and 'Steps may be empty.' The escape rules are also stated explicitly.",
      "fairness": "Prompt-stated",
      "name": "renderIsTheExactInverseOfParse",
      "qualityCheck": "Fair; exact round-tripping is expressly required, so value-pinning here is justified.",
      "verifies": "For forms including escaped `~` and `/`, empty steps, Unicode, and `//`, `render(parse(form))` returns the exact original string, not a normalized variant."
    },
    {
      "evidence": "Prompt: 'equal strings parse to equal pointers.'",
      "fairness": "Prompt-stated",
      "name": "pointersParsedFromEqualStringsAreEqual",
      "qualityCheck": "Fair and direct.",
      "verifies": "Two pointers parsed from the same string compare equal."
    },
    {
      "evidence": "Standard Java object contract: if `equals` says two objects are equal, their `hashCode` values must match. The prompt already requires pointer equality for equal strings.",
      "fairness": "Standard external semantics",
      "name": "pointersParsedFromEqualStringsAreEqualWithEqualHashCodes",
      "qualityCheck": "Fair, though a bit redundant once equality is required.",
      "verifies": "Two pointers that compare equal also have the same `hashCode()`."
    },
    {
      "evidence": "Prompt: 'a pointer's `toString` is its rendered form.'",
      "fairness": "Prompt-stated",
      "name": "pointerToStringIsItsRenderedForm",
      "qualityCheck": "Fair and exact.",
      "verifies": "`Pointer.toString()` returns the same string as `render(pointer)`, including for the root pointer."
    },
    {
      "evidence": "Prompt: 'Any other string not starting with `/`, fails `parse` with a nested `MalformedPointerException`.'",
      "fairness": "Prompt-stated",
      "name": "parseRejectsAStringWithoutALeadingSlash",
      "qualityCheck": "Fair; exact exception type is named in the prompt.",
      "verifies": "Parsing a non-empty string that does not start with `/` throws the nested `MalformedPointerException` exactly."
    },
    {
      "evidence": "Prompt: within a step only `~0` and `~1` are legal, and 'Any other use of `~` ... fails `parse` with a nested `MalformedPointerException`.'",
      "fairness": "Prompt-stated",
      "name": "parseRejectsADanglingEscape",
      "qualityCheck": "Fair.",
      "verifies": "Parsing a pointer with a trailing bare `~` throws the nested `MalformedPointerException` exactly."
    },
    {
      "evidence": "Prompt: only `~0` and `~1` are valid escapes; any other use of `~` is malformed.",
      "fairness": "Prompt-stated",
      "name": "parseRejectsAnUnknownEscape",
      "qualityCheck": "Fair.",
      "verifies": "Parsing a pointer containing `~2` throws the nested `MalformedPointerException` exactly."
    },
    {
      "evidence": "Prompt: 'A step at an implementation selects an attribute of the value actually present...' and non-container attributes address their value directly.",
      "fairness": "Prompt-stated",
      "name": "regularAttributeResolvesToItsValue",
      "qualityCheck": "Fair; this is basic resolve behavior.",
      "verifies": "Resolving a path through ordinary attributes returns the primitive/string attribute values at the addressed path, such as `\"f0\"` and `2`."
    },
    {
      "evidence": "Prompt: a step at an implementation selects an attribute of 'the value actually present ... whatever its position's static type.'",
      "fairness": "Prompt-stated",
      "name": "descentFollowsTheRuntimeImplementationNotTheStaticType",
      "qualityCheck": "Fair and important.",
      "verifies": "After traversing a position whose static type is a supertype, later steps are resolved against the runtime implementation actually stored there."
    },
    {
      "evidence": "Prompt: 'A step selecting a list or array attribute, or a map attribute with plain string keys, addresses the container as a last step.'",
      "fairness": "Prompt-stated",
      "name": "listAttributeAsFinalStepResolvesTheContainerItself",
      "qualityCheck": "Fair; it checks the exact stop-at-container rule.",
      "verifies": "When the pointer ends at a `List` or string-keyed `Map`/`BiMap` attribute step, `resolve` returns the container object itself rather than forcing another step."
    },
    {
      "evidence": "Prompt: for list/array attributes, the following step is 'a zero-based index of digits, no sign or leading zeros.'",
      "fairness": "Prompt-stated",
      "name": "arrayElementResolvesByIndex",
      "qualityCheck": "Fair.",
      "verifies": "For an object-array attribute, a following canonical digit step selects the element at that zero-based index."
    },
    {
      "evidence": "Prompt: 'An optional attribute step addresses its content.'",
      "fairness": "Prompt-stated",
      "name": "optionalContentResolvesAcrossFlavors: standard Optional",
      "qualityCheck": "Fair.",
      "verifies": "A present `java.util.Optional` attribute resolves to its contained value at the attribute step."
    },
    {
      "evidence": "The prompt speaks of 'optional' attributes generally. The repo makes these exact flavors discoverable as supported optional kinds: `value-processor/src/org/immutables/value/processor/meta/AttributeTypeKind.java:63-85`, `value-processor/src/org/immutables/value/processor/meta/ValueAttribute.java:618-639`, and fixture `value-fixture/src/org/immutables/fixture/jdkonly/UsingAllOptionals.java:25-43`. The prompt separately states that an 'empty optional' is a miss.",
      "fairness": "Repo-discoverable",
      "name": "optionalContentResolvesAcrossFlavors / emptyOptionalIsAMiss: Guava and specialized optionals",
      "qualityCheck": "Fair; it depends on repo-visible optional-kind support rather than hidden conventions.",
      "verifies": "Present Guava `Optional` and JDK `OptionalInt`/`OptionalLong`/`OptionalDouble` resolve to their contents, and empty instances of those supported optional kinds resolve as a `PointerMissException`."
    },
    {
      "evidence": "Prompt: optional steps address their content, and later steps select attributes 'declared or inherited' on the runtime value actually present.",
      "fairness": "Prompt-stated",
      "name": "crossFamilyOptionalDescentReachesInheritedAttribute",
      "qualityCheck": "Fair.",
      "verifies": "After resolving through an optional whose runtime value is another immutable implementation, a subsequent step can select an inherited attribute such as `tag`."
    },
    {
      "evidence": "Prompt defines the exact escape mapping: '`~0` stands for `~` and `~1` for `/`', with rendering/parsing preserving the original string.",
      "fairness": "Prompt-stated",
      "name": "escapedStepsSelectTheLiteralMapKeys",
      "qualityCheck": "Fair; exact accepted key strings are determined by the stated escape rules.",
      "verifies": "Escaped step text like `a~1b`, `~00`, and raw Unicode step text selects the literal string map keys `a/b`, `~0`, and `café`."
    },
    {
      "evidence": "Prompt: 'Steps may be empty.' Map-key traversal uses the following step as the key, while 'an absent attribute' is a `PointerMissException`.",
      "fairness": "Prompt-stated",
      "name": "emptyStepIsAPresentMapKeyButAMissingAttribute",
      "qualityCheck": "Fair and precise.",
      "verifies": "An empty step after a string-keyed map attribute selects the empty-string map key, but an empty step at an implementation where no such attribute exists throws `PointerMissException`."
    },
    {
      "evidence": "Prompt distinguishes map-key traversal from list/array indexing: for a map attribute with plain string keys, the following step is the key.",
      "fairness": "Prompt-stated",
      "name": "digitStringSelectsAMapKeyNotAnIndex",
      "qualityCheck": "Fair.",
      "verifies": "Under a string-keyed map attribute, the step `0` is interpreted as the string key `\"0\"`, not as an index."
    },
    {
      "evidence": "Prompt: 'Resolving a null-holding position returns null' and `PointerMissException` covers 'a step through null, whatever the shape of the attribute holding it.'",
      "fairness": "Prompt-stated",
      "name": "nullableAttributeHoldingNullResolvesToNull / stepThroughNullIsAMiss",
      "qualityCheck": "Fair; the test checks both the direct-null and step-through-null rules.",
      "verifies": "Resolving a nullable attribute or nullable array/list position that currently holds `null` returns `null`, but taking any additional step through that null position throws `PointerMissException` exactly."
    },
    {
      "evidence": "Prompt: traversal uses 'the value actually present' and failures include 'an absent attribute' as `PointerMissException`.",
      "fairness": "Prompt-stated",
      "name": "absentAttributeIsAMissOnTheImplementationAtHand",
      "qualityCheck": "Fair.",
      "verifies": "Selecting an attribute name that is not present on the runtime implementation throws `PointerMissException`, even if some other implementation in the family has that attribute."
    },
    {
      "evidence": "Prompt: `PointerMissException` covers 'an index past the end whatever number its digits form.'",
      "fairness": "Prompt-stated",
      "name": "indexPastTheEndOfAListOrArrayIsAMiss",
      "qualityCheck": "Fair; exact miss-vs-mismatch behavior is stated.",
      "verifies": "A canonical digit index beyond the end of a list or object array throws `PointerMissException`, including huge digit strings that numerically exceed the size."
    },
    {
      "evidence": "Prompt: `PointerMissException` covers 'an absent map key.'",
      "fairness": "Prompt-stated",
      "name": "absentMapKeyIsAMiss",
      "qualityCheck": "Fair.",
      "verifies": "Looking up a missing key in a string-keyed map throws `PointerMissException`."
    },
    {
      "evidence": "Prompt: an index must be 'zero-based index of digits, no sign or leading zeros' and `PointerTypeException` covers 'non-index text where an index is required.'",
      "fairness": "Prompt-stated",
      "name": "nonCanonicalIndexTextIsATypeMismatch",
      "qualityCheck": "Fair; the accepted/rejected index forms are very specifically stated.",
      "verifies": "When an index is required, non-canonical text such as `01`, `-1`, `+1`, `1x`, the empty string, or `00` throws `PointerTypeException` exactly."
    },
    {
      "evidence": "Prompt: 'Every other attribute is a whole value; no step applies below a value that is not itself such an implementation' and 'Set, multiset, multimap, sorted or non-string-keyed map, and primitive-element array attributes are whole values only: stepping below ... raises the type mismatch.'",
      "fairness": "Prompt-stated",
      "name": "stepBelowNonDescendableValuesIsATypeMismatch",
      "qualityCheck": "Fair; these are public traversal semantics, not hidden internals.",
      "verifies": "Trying to step below a scalar value, primitive-element array, set, multiset, multimap, sorted map, non-string-keyed map, or an immutable value that is not itself an eligible same-enclosing implementation throws `PointerTypeException` exactly."
    },
    {
      "evidence": "Prompt: 'Every other attribute is a whole value' and the same final sentence marks those opaque container kinds as 'whole values only'. It also separately says array/list attributes can be addressed at the container step.",
      "fairness": "Prompt-stated",
      "name": "opaqueContainersResolveAsWholeValues",
      "qualityCheck": "Fair.",
      "verifies": "For set/multiset/multimap/sorted-map/non-string-keyed-map/generic immutable/primitive-array/object-array attributes, resolving the attribute step itself succeeds and returns the whole value/container rather than descending further."
    },
    {
      "evidence": "Prompt: 'The root must be a generated implementation of the enclosing type without its own type parameters ... anything else raises `IllegalArgumentException`.'",
      "fairness": "Prompt-stated",
      "name": "foreignRootsAreRejectedWithIllegalArgument",
      "qualityCheck": "Fair; exact root-admissibility rules are in the prompt.",
      "verifies": "`resolve` throws `IllegalArgumentException` exactly for a hand-rolled implementation, `null`, an unrelated object, a generated implementation from another enclosing family, and a generated implementation that has its own type parameters."
    },
    {
      "evidence": "Prompt: `update` returns 'a new root carrying its result'; if changed, 'only the values along the pointer's path are rebuilt: everything off that path enters the new root as the very same instance.'",
      "fairness": "Prompt-stated",
      "name": "updateReplacesADeepValueAlongTheSpineOnly",
      "qualityCheck": "Fair; identity-sharing is explicitly promised, so these identity assertions are not over-coupled.",
      "verifies": "A deep update changes only the addressed leaf value, leaves the original root unchanged, and preserves object identity for every off-path value the assertions inspect, including sibling list elements, sibling map entries, and other attributes in rebuilt ancestors."
    },
    {
      "evidence": "Prompt: 'A rebuilt map keeps its iteration order and other entries.' Keeping order with the same keys implies the updated key keeps its position.",
      "fairness": "Prompt-stated",
      "name": "updatedMapKeepsIterationOrderAndUpdatedKeyKeepsItsPosition",
      "qualityCheck": "Fair and targeted.",
      "verifies": "After updating a map entry, the key iteration order is unchanged, the updated key stays in the same position, the updated entry has the new value, and unrelated attributes remain the same instance."
    },
    {
      "evidence": "Prompt: 'a rebuilt list or array keeps its other elements' and off-path values are reused verbatim.",
      "fairness": "Prompt-stated",
      "name": "updatedListKeepsOtherElementInstances / updatedArrayKeepsOtherElementInstances",
      "qualityCheck": "Fair.",
      "verifies": "When updating one list element or one object-array element, all other elements remain the very same instances and off-path attributes stay the same instance."
    },
    {
      "evidence": "Prompt: optional attribute steps address the content, and update rebuilds only the path to the addressed value.",
      "fairness": "Prompt-stated",
      "name": "updateThroughOptionalContentRebuildsThePresentOptional",
      "qualityCheck": "Fair.",
      "verifies": "Updating through a present `java.util.Optional` changes the nested content while preserving other fields and reusing untouched siblings."
    },
    {
      "evidence": "Repo support for these exact optional flavors is visible in `value-processor/src/org/immutables/value/processor/meta/AttributeTypeKind.java:63-85` and `value-processor/src/org/immutables/value/processor/meta/ValueAttribute.java:618-639`, with fixture coverage in `value-fixture/src/org/immutables/fixture/jdkonly/UsingAllOptionals.java:25-43`. The prompt supplies the generic optional and miss/update rules.",
      "fairness": "Repo-discoverable",
      "name": "updateThroughASpecializedOptionalRebuildsTheContent / Guava Optional update",
      "qualityCheck": "Fair; this extends a prompt-stated rule to repo-visible supported optional kinds.",
      "verifies": "Updating through a present Guava `Optional` or JDK `OptionalInt`/`OptionalLong`/`OptionalDouble` rebuilds that wrapper with the new contained value, while preserving unrelated fields; absent specialized optionals still miss on resolve."
    },
    {
      "evidence": "Prompt: the container attribute step itself is addressable for lists, arrays, and string-keyed maps, and `update` applies the operator to 'the addressed value'. Wrong-typed replacements are the only rejected ones.",
      "fairness": "Prompt-stated",
      "name": "updateWholeContainerAtItsAttributeStep",
      "qualityCheck": "Fair; it checks the exact addressed-value rule.",
      "verifies": "Updating the attribute step of a list, object-array, or string-keyed map accepts a correctly typed replacement container and rebuilds only the path, preserving unrelated attributes by identity."
    },
    {
      "evidence": "Prompt: 'A result equal to the existing value returns the original root instance.'",
      "fairness": "Prompt-stated",
      "name": "equalOperatorResultReturnsTheVerySameRoot",
      "qualityCheck": "Fair and direct.",
      "verifies": "If the operator returns a value equal to the existing addressed value, `update` returns the original root instance exactly, including for a root update and nullable scalar update."
    },
    {
      "evidence": "Prompt: the empty string is the root pointer, `update` applies the operator to the addressed value, and only a 'replacement root that is not such an implementation' is rejected.",
      "fairness": "Prompt-stated",
      "name": "updateAtTheRootPointerReturnsTheReplacementItself",
      "qualityCheck": "Fair.",
      "verifies": "Updating the root pointer with a replacement that is itself a valid generated implementation of the same enclosing type returns that replacement object as the new root."
    },
    {
      "evidence": "Prompt rejects 'null anywhere but a nullable position', so nullable positions accept null; and equal results return the original root instance.",
      "fairness": "Prompt-stated",
      "name": "nullableUpdateAcceptsNullAndRebuildsSpine",
      "qualityCheck": "Fair; the assertions follow from the prompt's nullability and equality-short-circuit rules.",
      "verifies": "Updating a nullable attribute may replace its value with `null` or a non-null value, rebuilding only the path as needed; if the current nullable value is already `null` and the operator returns `null`, the original root is returned unchanged."
    },
    {
      "evidence": "Prompt: 'A wrong-typed replacement for a scalar or container attribute, null anywhere but a nullable position, or a replacement root that is not such an implementation raises the type mismatch and leaves the root untouched.'",
      "fairness": "Prompt-stated",
      "name": "misfitOperatorResultsAreRejectedAndTheRootLeftUntouched",
      "qualityCheck": "Fair; exact exception class and non-mutation behavior are both stated.",
      "verifies": "If the operator returns a wrong-typed value, an impermissible `null`, or an invalid replacement root, `update` throws `PointerTypeException` exactly and previously resolvable data in the original root remains unchanged."
    },
    {
      "evidence": "Prompt: 'Set, multiset, multimap, sorted or non-string-keyed map, and primitive-element array attributes are whole values only: ... updating them raises the type mismatch.'",
      "fairness": "Prompt-stated",
      "name": "opaqueAttributesCannotBeUpdated",
      "qualityCheck": "Fair.",
      "verifies": "Updating a set, primitive-array, sorted-map, multimap, non-string-keyed map, multiset, or nullable set attribute itself throws `PointerTypeException` exactly, even if the replacement value is otherwise type-compatible or `null`."
    },
    {
      "evidence": "Prompt: 'the operator runs only when the walk permits the update.'",
      "fairness": "Prompt-stated",
      "name": "updateWalksBeforeApplyingSoMissesNeverInvokeTheOperator",
      "qualityCheck": "Fair and well-targeted; it checks user-visible behavior, not internals.",
      "verifies": "For misses or type mismatches encountered during path walking, `update` throws before invoking the operator, leaving the operator call counter at zero across all those failing cases."
    },
    {
      "evidence": "Prompt: a null-holding position resolves to null and stepping through null misses; otherwise ordinary list rules apply, and list updates rebuild only the path while keeping other elements.",
      "fairness": "Prompt-stated",
      "name": "updateOfNullableListReplacesNullWholesale / presentNullableListBehavesLikeAnOrdinaryList",
      "qualityCheck": "Fair; this is a natural combination of the prompt's null and list rules.",
      "verifies": "A nullable list attribute that currently holds `null` can be replaced wholesale with a list; once non-null, resolving the attribute returns the list, indexed descent works, out-of-range indexes miss, and element updates rebuild only the changed element while preserving the others by identity."
    },
    {
      "evidence": "Prompt: steps may select attributes 'declared or inherited'; and 'An update at or through a derived or lazy attribute raises the type mismatch.'",
      "fairness": "Prompt-stated",
      "name": "derivedAndLazyAttributesAreReadableButNeverUpdated",
      "qualityCheck": "Fair; exact read/write asymmetry is spelled out in the prompt.",
      "verifies": "Derived and lazy attributes can be resolved like ordinary attributes, including further descent through a derived attribute's runtime value, but `update` at or through any derived/lazy attribute throws `PointerTypeException` exactly and does not invoke the operator."
    },
    {
      "evidence": "Prompt: 'Every other attribute is a whole value; no step applies below a value that is not itself such an implementation.' Combined with the runtime-value rule, descent is allowed when the whole value is itself an eligible implementation.",
      "fairness": "Prompt-stated",
      "name": "plainValueAttributeDescendsIntoTheRuntimeImplementation",
      "qualityCheck": "Fair.",
      "verifies": "A non-container attribute whose runtime value is another eligible immutable implementation resolves first to that whole value and then allows further descent and update into that runtime implementation."
    },
    {
      "evidence": "Prompt separates map-key traversal from later attribute traversal on the addressed runtime value, and lists 'an absent attribute' as a miss.",
      "fairness": "Prompt-stated",
      "name": "mapsAreNotConfusedWithAttributesAcrossImplementations",
      "qualityCheck": "Fair; it checks an ambiguity the prompt resolves.",
      "verifies": "After stepping through a string-keyed map entry into the mapped immutable value, later steps are interpreted as attributes on that runtime value, so a missing attribute is a `PointerMissException`; meanwhile ordinary string-keyed maps and `BiMap` still support keyed descent and nested attribute access."
    },
    {
      "evidence": "Prompt gives the same root-admissibility rule for `update`'s root and separately says the operator runs only when the walk permits the update.",
      "fairness": "Prompt-stated",
      "name": "updateRejectsForeignRootsWithoutInvokingTheOperator",
      "qualityCheck": "Fair and not brittle.",
      "verifies": "`update` throws `IllegalArgumentException` exactly for the same invalid root categories as `resolve`, and in those cases the operator is never invoked."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Dockerfile guidelines**

Status: WARNING

warning: The Dockerfile fetches dependencies and builds the project (./mvnw -version; mvn dependency:get ...; mvn -DskipTests install; mvn dependency:go-offline) which installs required dependencies. However, it mixes use of the Maven wrapper (./mvnw) and the system mvn binary. Mixing wrapper and system maven invocations can produce different Maven versions/behavior across builds; prefer using the repository mvnw wrapper exclusively (./mvnw) or ensure the system mvn version is pinned/known. Also the Dockerfile explicitly downloads two different jackson BOM coordinates/versions (com.fasterxml.jackson:jackson-bom:2.21.2 and tools.jackson:jackson-bom:3.1.0) — verify this is intentional because fetching multiple BOMs for the same libraries can cause conflicts.

Note: Internet access is available during `docker build`, but not when running the container. Test patch is injected into the container after build. Ensure your Dockerfile installs all dependencies at build time so the environment works fully offline after build.

```json
{
  "all_issues": "warning: The Dockerfile fetches dependencies and builds the project (./mvnw -version; mvn dependency:get ...; mvn -DskipTests install; mvn dependency:go-offline) which installs required dependencies. However, it mixes use of the Maven wrapper (./mvnw) and the system mvn binary. Mixing wrapper and system maven invocations can produce different Maven versions/behavior across builds; prefer using the repository mvnw wrapper exclusively (./mvnw) or ensure the system mvn version is pinned/known. Also the Dockerfile explicitly downloads two different jackson BOM coordinates/versions (com.fasterxml.jackson:jackson-bom:2.21.2 and tools.jackson:jackson-bom:3.1.0) — verify this is intentional because fetching multiple BOMs for the same libraries can cause conflicts.",
  "base_image_compliant": {
    "explanation": "OK: Dockerfile starts FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest, which is one of the accepted Olympus base images.",
    "status": "OK"
  },
  "dependencies_installed": {
    "explanation": "warning: The Dockerfile fetches dependencies and builds the project (./mvnw -version; mvn dependency:get ...; mvn -DskipTests install; mvn dependency:go-offline) which installs required dependencies. However, it mixes use of the Maven wrapper (./mvnw) and the system mvn binary. Mixing wrapper and system maven invocations can produce different Maven versions/behavior across builds; prefer using the repository mvnw wrapper exclusively (./mvnw) or ensure the system mvn version is pinned/known. Also the Dockerfile explicitly downloads two different jackson BOM coordinates/versions (com.fasterxml.jackson:jackson-bom:2.21.2 and tools.jackson:jackson-bom:3.1.0) — verify this is intentional because fetching multiple BOMs for the same libraries can cause conflicts.",
    "status": "warning"
  },
  "interactive_shell": {
    "explanation": "OK: The container ends with CMD [\"/bin/bash\"], providing an interactive shell for developers.",
    "status": "OK"
  },
  "no_test_execution": {
    "explanation": "OK: Tests are not executed during build. Maven runs include -DskipTests and there are no test execution commands (no pytest, npm test, test.sh execution, etc.).",
    "status": "OK"
  },
  "package_manager_installation": {
    "explanation": "OK: The Dockerfile does not attempt to install package managers (no apt-get/npm/pip installs or curl-based installer scripts). It uses Maven and the mvnw wrapper already provided by typical Java projects and the olympus-base-jvm image.",
    "status": "OK"
  },
  "registry_compliant": {
    "explanation": "OK: The base image is pulled from the approved public.ecr.aws registry and matches an allowed Olympus base image.",
    "status": "OK"
  },
  "repository_setup": {
    "explanation": "OK: WORKDIR is /app and the Dockerfile copies the repository into the image with COPY . .; the Dockerfile does not clone the repository during build.",
    "status": "OK"
  },
  "security_safety": {
    "explanation": "OK: No obfuscated commands, no downloads-and-executes via curl/wget, no hard-coded secrets, no docker.sock mounts, and no other obvious malicious or privileged operations. Note: the Dockerfile changes permissions (chmod -R a+rwX /opt/m2) to make the Maven repo writable — this is common for shared caches but confirm this is acceptable for your environment.",
    "status": "OK"
  },
  "user_creation_compatible": {
    "explanation": "OK: The Dockerfile does not create any user or group; this is compatible with the rubric requirement (no user creation is acceptable).",
    "status": "OK"
  },
  "version_pinning": {
    "explanation": "OK: Explicit mvn dependency:get commands specify exact versions (e.g., com.fasterxml.jackson:jackson-bom:2.21.2, tools.jackson:jackson-bom:3.1.0, org.junit:junit-bom:5.9.1, surefire 2.22.2). The base image uses :latest as allowed by the rubric. Note: dependency versions declared in the project's pom.xml (pulled by mvn install) cannot be verified from the Dockerfile alone; ensure the project's pom.xml / parent pom pins dependency versions or uses BOMs/lock mechanisms as appropriate for reproducibility.",
    "status": "OK"
  }
}
```

---

**Problem description have appropriate length (target: 100-200 words)**

Status: WARNING

Description is verbose (531 words, over target by 31). Consider trimming to ≤500 words.

```json
{
  "errorThreshold": 1000,
  "target": 500,
  "warningThreshold": 500,
  "wordCount": 531
}
```

---

**Shipd Bot Description Warnings**

> "modified copies (the `with` methods)"

Trim the parenthetical. Something like "do not all support copy methods" is enough; the repo already makes the `withX` convention obvious, so spelling it out here reads a bit like generated documentation.

> "walks a root by a pointer"

Rephrase to something more natural, e.g. "resolves a pointer against a root". The current wording is understandable but awkward compared with the rest of the description.

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are only 2 suggestions, both medium/low priority trims of explanatory wording. No high-priority removals and fewer than 3 total suggestions means the verdict is minor_suggestions.",
  "suggestions": [
    {
      "priority": "low",
      "quote": "(the `with` methods)",
      "suggestion": "Remove the parenthetical explanation. It’s an aside that doesn’t affect requirements; the presence/absence of generated with-methods can be inferred from the code generator and tests."
    },
    {
      "priority": "medium",
      "quote": "\"A step at an implementation selects an attribute of the value actually present, declared or inherited, whatever its position's static type.\"",
      "suggestion": "Drop the trailing clause \"whatever its position's static type\". The preceding text already establishes runtime-implementation semantics; the static-type qualifier is redundant."
    }
  ],
  "summary": "- [MEDIUM] Trim redundancy in: \"A step at an implementation selects an attribute of the value actually present, declared or inherited, whatever its position's static type.\" Remove the clause \"whatever its position's static type\" – the sentence already specifies selection based on the runtime implementation, making the static-type qualifier unnecessary.\n- [LOW] Remove the parenthetical in: \"do not all generate modified copies (the `with` methods)\" – the aside adds noise without changing behavior; whether with-methods are generated is evident from generator settings and code conventions.",
  "verdict": "minor_suggestions"
}
```
