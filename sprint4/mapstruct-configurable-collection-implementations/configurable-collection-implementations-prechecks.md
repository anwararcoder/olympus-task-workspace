**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥40 messages, ≥250 LOC

This task numbers: Median files: 36, messages: 215, LOC: 1350

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "1f0e30bcb41829bd7aad8306949dac7778ccc13ecd45c1fb641900cb97adf907",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "igee",
      "candidate_summary": "Implements mapping to Guava immutable collections, maps, multimaps, and tables with builder-based generation, validation of sorted-type comparability, source-shape checks, and restrictions on use as @MappingTarget. Introduces new model builders and templates to create and populate Immutable* targets and integrates diagnostics for unsupported scenarios.",
      "confidence": 0.84,
      "contentAuthoredAt": 1783929834023,
      "evalStatus": "ok",
      "evidence_gaps": [
        "Candidate patch is truncated; however, enough of the solution is present to understand its feature and surfaces."
      ],
      "isOlder": true,
      "meaningful_differences": [
        "Submission introduces a configuration file (mapstruct.properties or a selected resource via the mapstruct.configurationFile option) to override the concrete implementations used for standard Java collection/map interfaces; candidate adds new mapping pipelines for Guava Immutable* types (collections, maps, multimaps, tables) with dedicated builders and validations.",
        "Submission validates configured implementation classes (public, concrete, assignable to interface, generic shape preserved, no‑arg constructor, optional int-capacity constructor) and defers processing until generated implementations become available; candidate validates natural ordering for sorted immutables and forbids use as @MappingTarget and in before‑mapping callbacks.",
        "Submission alters instance creation for configured interfaces, including passing source.size() to an int constructor when available; candidate generates builder‑based creation for Guava immutables, maps from specific source shapes (iterable→collection, map→map, map<k, collection<v>>→multimap, map<r, map<c,v>>→table) and errors on incompatible shapes.",
        "Submission’s changes concentrate on loading/propagating configured implementation types through TypeFactory/ImplementationType and gating direct assignment when a configured impl is set; candidate introduces multiple new model/builders/templates (Immutable*MappingMethod, GuavaImmutableMappingSupport) and broad template logic to handle Guava immutables end‑to‑end."
      ],
      "one_liner": "Both extend MapStruct’s collection mapping capabilities, but one adds a configurable mechanism to choose concrete collection/map implementations, while the other adds end‑to‑end support for Guava’s immutable collection types and their specific semantics.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both target collection mapping in the same repository, they modify different surfaces for different purposes. The submission implements a configuration system to select concrete implementations for standard Java collection/map interfaces and adjusts construction semantics; the candidate adds comprehensive support for Guava’s immutable types with builder-based generation, source-shape checks, and immutability constraints. Shared files touched (e.g., documentation and some model classes) are for unrelated purposes and reflect repository scaffolding rather than the same task.",
      "similarity": 0.5712998248326734,
      "submission_summary": "Adds a configuration mechanism to select concrete implementations for standard collection/map interface results, loading from a classpath properties file or an explicitly selected resource, validating choices, deferring until types exist, and using size-based constructors when available. Wires this through MappingProcessor, TypeFactory, ImplementationType, templates, and options, and blocks direct assignment when a configured implementation must be constructed.",
      "title": "immutable collections",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Introduces bean-to-map mapping methods that enumerate a bean’s readable properties into map entries keyed by property name, with support for constants/expressions, ignores, conditions, defaults, and update semantics. It integrates detection and building via SourceMethod and MapperCreationProcessor and adds FTL templates to generate the corresponding code.",
      "confidence": 0.93,
      "contentAuthoredAt": 1783680273814,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission introduces an external configuration file (mapstruct.properties or a processor option) to select concrete implementations for collection/map interfaces, with validation, deferred resolution across rounds, and passing initial capacity to constructors; candidate adds a new mapping method kind that converts a bean’s readable properties into map entries with extensive null/condition/default/update semantics.",
        "Submission modifies MappingProcessor, TypeFactory, ImplementationType, collection/map assignment wrappers, and adds CollectionImplementationConfiguration/ConfiguredImplementationType; candidate adds BeanToMapMappingMethod/BeanToMapEntry, integrates detection in SourceMethod and MapperCreationProcessor, and adds new FTL templates for bean-to-map code generation.",
        "Submission changes how MapStruct instantiates target collection/map results (interface→implementation resolution and constructor selection); candidate changes how MapStruct derives and writes map entries from a bean source, including constants/expressions/ignores and lifecycle hooks.",
        "Submission adds a new processor option (mapstruct.configurationFile) and classpath resource parsing; candidate does not alter options or resource handling at all."
      ],
      "one_liner": "Both extend MapStruct’s handling of collections/maps, but one adds a configuration-driven choice of concrete collection/map implementations while the other introduces bean-to-map mapping methods and code generation.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Despite living in the same repository, the patches target different features and surfaces. The submission wires a configuration-driven mechanism into type resolution and instantiation for collection/map interfaces, whereas the candidate adds a new bean-to-map mapping method with dedicated model classes and templates. There are no purpose-matched modified files, shared APIs, or shared behaviors; the overlap is only the general domain of maps/collections, which is boilerplate-level and not the same task.",
      "similarity": 0.5353782523238388,
      "submission_summary": "Loads and validates a classpath properties resource (or a selected one via mapstruct.configurationFile) to choose concrete implementations for supported collection/map interfaces, defers processing if the implementation type isn’t yet generated, and integrates the result into TypeFactory and codegen (including using an int-capacity constructor when available). It adjusts assignment/builders to avoid direct assignment when a configured implementation exists and passes source size to constructors in generated code.",
      "title": "Bean to Map Mapping Methods",
      "verdict": "distinct"
    },
    {
      "authorUsername": "harshbadeja",
      "candidate_summary": "Enhances Jdbi to reuse parameterized supertype registrations for compatible subtypes by introducing generic supertype matching and applying it to row/column mappers, qualified mappers, collectors, SQL array types, and codecs. It also preserves qualifier requirements, adjusts precedence and cache invalidation so later registrations win, and enforces ordered encounter semantics for codec maps.",
      "confidence": 0.97,
      "contentAuthoredAt": 1782326409525,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and layers: MapStruct’s annotation processor and codegen templates vs. Jdbi’s runtime factories and type resolution.",
        "Submission introduces a properties-driven configuration to choose concrete implementations for collection/map interfaces during code generation; candidate introduces generic supertype matching for parameterized types at runtime across mappers/codecs/collectors/arrays.",
        "Submission validates configured classes (public, concrete, assignable, generic shape preserved, constructors) and defers until generated types become available; candidate adjusts precedence, preserves qualifier sets, clears prepared caches to honor later registrations, and enforces encounter order for codecs.",
        "Submission adds initial-capacity constructor usage when available in configured implementations; candidate adds a new isGenericSuperType semantic used broadly for lookups and updates tests accordingly."
      ],
      "one_liner": "They implement unrelated features in different projects: MapStruct adds compile-time configuration for which concrete collection/map classes it generates, while Jdbi broadens runtime generic-type resolution for mappers/codecs/collectors.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "revision_requested",
      "reason": "The patches target different repos and purposes. The MapStruct change is a compile-time, properties-driven selection and validation of concrete collection/map implementations used in generated code, including template updates to pass size and honoring object factories. The Jdbi change is a runtime enhancement to resolve parameterized supertype registrations for subtypes across multiple factories, with ordering and cache semantics. There is no shared modified surface or common behavioral task beyond generic high-level ‘collection’ terminology, so they are distinct.",
      "similarity": 0.5164546966552734,
      "submission_summary": "Extends MapStruct’s annotation processor to read a properties resource (or a selected configuration file) that maps collection/map interfaces to concrete implementation classes, validates them, defers when unavailable, and wires the chosen implementations into type/model creation and templates (including using an int constructor for initial capacity when available). It also adds an option for the configuration file and error reporting for invalid or missing entries.",
      "title": "Generic Subtype Resolution for Jdbi Mapper Factories",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Extends the Immutables generator to conditionally add compact binary serialization methods (writeTo/readFrom) when a serial module is present, computing per-attribute tags/type codes, supporting specific attribute shapes, nested immutables, and version tolerance, and avoiding conflicts with existing methods.",
      "confidence": 0.98,
      "contentAuthoredAt": 1782991288807,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "The submission introduces a configuration file (mapstruct.properties or an explicitly selected resource) to map collection/map interfaces to concrete implementations in MapStruct, with validation, deferred rounds for generated types, and optional initial-capacity constructor use; the candidate generates binary serialization APIs (writeTo/readFrom) for Immutables types based on a serial module being present.",
        "The submission modifies MapStruct’s annotation processor surfaces (MappingProcessor, TypeFactory, assignment builders, codegen templates) to select and construct configured implementations; the candidate modifies Immutables’ generator and metadata (ValueType/ValueAttribute) to compute tags/codes and conditionally emit serialization methods and wire helpers.",
        "The submission’s scope is collection/map result materialization during mapping (including streams, object factory precedence, and interface-specific defaults); the candidate’s scope is attribute shape–based, version-tolerant binary encoding/decoding for supported value types, avoiding conflicts and unsupported/recursive shapes."
      ],
      "one_liner": "One adds configurable concrete collection/map types for MapStruct-generated mappings, while the other adds compact binary writeTo/readFrom methods to generated Immutables.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "These patches target different repositories and unrelated features. The MapStruct change is about configurable collection/map implementation selection during mapping; the Immutables change is about generating binary serialization APIs for value types. There is no purpose-matched modified surface or shared behavior beyond both being annotation-processor-based generators, which is generic scaffolding, not substantive overlap.",
      "similarity": 0.48390597105026245,
      "submission_summary": "Adds a configuration mechanism to MapStruct’s processor to replace default concrete types for supported collection/map interfaces, validates configured implementations, defers when types are generated in later rounds, and uses an initial-capacity constructor when available; updates codegen templates and selection logic accordingly.",
      "title": "Compact binary form for generated immutables",
      "verdict": "distinct"
    },
    {
      "authorUsername": "tommyshelby3768",
      "candidate_summary": "Changes MVEL’s literal rewriting so list/map literals produce mutable ArrayList/LinkedHashMap instances, introduces a helper to build LinkedHashMap with computed capacity, and updates the transpiler to emit these constructions across all literal contexts.",
      "confidence": 0.96,
      "contentAuthoredAt": 1783281066226,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission (MapStruct) adds an annotation-processor configuration to select concrete implementations for collection/map interface results during code generation, including validation, round-deferred availability, and passing initial capacity when possible.",
        "Submission modifies MapStruct’s type factory, assignment builders, freemarker templates, and processor options to honor configured types only when MapStruct constructs interface results, preserving object factory precedence and blocking direct assignment for configured interfaces.",
        "Candidate (MVEL) rewrites parsed list/map literals to produce mutable ArrayList/LinkedHashMap instances at runtime, adds a linkedHashMapOf factory with computed capacity, and changes AST rewriting to ensure literals are mutable across contexts and nesting.",
        "Candidate’s errors are runtime (e.g., odd map literal entries), whereas the submission’s failures are compile-time diagnostics tied to invalid configuration or missing types.",
        "The repositories and architectural layers differ: MapStruct’s Java annotation processor vs. MVEL’s expression compiler/transpiler and runtime helpers."
      ],
      "one_liner": "Both change how collections are constructed, but in different projects and contexts: one configures MapStruct’s generated collection implementations, the other makes MVEL collection literals produce mutable Java collections.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "The two patches target different repositories and solve unrelated tasks. The MapStruct change introduces a properties-driven configuration to choose concrete collection implementations in generated mappers, with compile-time validation and initial-capacity semantics; the MVEL change alters literal lowering to mutable collections and adds a factory helper. There is no shared, purpose-matched modified surface or common observable behavior beyond generic “collection creation.”",
      "similarity": 0.4819306433200836,
      "submission_summary": "Adds a properties-driven configuration to MapStruct’s annotation processor to choose concrete implementations for supported collection/map interfaces, validates configured types, defers until types are available, and updates generation to use configured classes (optionally with initial capacity) and to avoid direct assignment when configured.",
      "title": "Parser-owned zero-copy input stores stable object data",
      "verdict": "distinct"
    }
  ]
}
```

---

**Test Fairness**

Coverage Suggestions (2) - Not Blockers

Advisory only — these don't affect the check result.

No configuration resource present at all
Add a test with neither `mapstruct.properties` nor `mapstruct.configurationFile` present and verify that plain built-in defaults remain active for at least one list and one map mapping.

Late-round implementation never appears
Add a multi-round test where a configured implementation name is expected from another processor but is never generated, and verify compilation ultimately fails after processing finishes with a diagnostic naming the missing configured type.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "No configuration resource present at all",
      "suggestion": "Add a test with neither `mapstruct.properties` nor `mapstruct.configurationFile` present and verify that plain built-in defaults remain active for at least one list and one map mapping."
    },
    {
      "area": "Late-round implementation never appears",
      "suggestion": "Add a multi-round test where a configured implementation name is expected from another processor but is never generated, and verify compilation ultimately fails after processing finishes with a diagnostic naming the missing configured type."
    }
  ],
  "error": "",
  "executionTimeSeconds": 461.839881,
  "message": "All hidden tests are fair.",
  "overall": "The hidden tests are fair overall. The prompt is unusually specific and directly states most of the new behavior: resource selection, validation rules, later-round availability, constructor selection, stream/property/nested integration, and object-factory precedence. Where exact built-in default types matter, the repo already exposes them in `TypeFactory`, and existing templates/tests make RETURN_DEFAULT, concrete-return, and update-target behavior discoverable. The diagnostic checks are mostly high-quality because they use broad regexes that require the offending key/value and the general cause, rather than exact message wording. I do not see any assertion that depends on an undiscoverable implementation detail or an arbitrary author-only choice.",
  "taskSummary": "The task is to add configurable collection/map implementation selection to MapStruct’s annotation processor. By default it should read `mapstruct.properties` from the mapping compilation classpath root; `-Amapstruct.configurationFile=...` selects a different classpath resource by relative path and suppresses use of the default one. Entries map a supported interface FQCN like `java.util.List` to an implementation FQCN. The configured implementation should replace MapStruct’s built-in implementation only when MapStruct is constructing that exact supported interface result. Validation is strict: unknown keys, unsupported interfaces, empty values, conflicting duplicates, missing/inaccessible/abstract/interface/non-assignable implementations, wrong generic shape, checked no-arg constructors, etc. must fail compilation with a diagnostic naming the bad key/value and the cause. If a public usable `int` constructor exists it should be used with source size; otherwise a public no-arg constructor is required. The rule must also apply in forged nested mappings, stream-to-collection results, and direct collection/map property copies, while applicable object factories still take precedence. Implementations generated in later AP rounds are valid once they appear; resources are loaded from the compilation classpath, not the processor classloader.",
  "tests": [
    {
      "evidence": "Prompt: entries are `mapstruct.collectionImplementation.<interface-qualified-name>=<implementation-qualified-name>` and the configured choice replaces the built-in when MapStruct constructs that supported interface result. Repo: the exact supported interface families are discoverable in `processor/src/main/java/org/mapstruct/ap/internal/model/common/TypeFactory.java:123-159`, which enumerates `Iterable`, `Collection`, `List`, `Set`, `SortedSet`, `NavigableSet`, `Map`, `SortedMap`, `NavigableMap`, `ConcurrentMap`, `ConcurrentNavigableMap`, `SequencedSet`, and `SequencedMap`.",
      "fairness": "Repo-discoverable",
      "name": "shouldConfigureEverySupportedInterfaceFamily",
      "qualityCheck": "Good user-visible assertions on exact result classes. Broad but not brittle; it checks the externally observable contract rather than internals.",
      "verifies": "For each supported interface-returning mapper method, the runtime result is exactly the implementation named in the properties file: `Iterable -> ChosenSortedSet`, `Collection -> ChosenList`, `List -> FactoryList`, `Set -> HashSet`, `SortedSet -> ChosenSortedSet`, `NavigableSet -> ConcurrentSkipListSet`, `Map -> HashMap`, `SortedMap -> ChosenSortedMap`, `NavigableMap -> ConcurrentSkipListMap`, `ConcurrentMap -> ConcurrentHashMap`, `ConcurrentNavigableMap -> ChosenConcurrentNavigableMap`, `SequencedSet -> ChosenSequencedSet`, and `SequencedMap -> ChosenSequencedMap`."
    },
    {
      "evidence": "Prompt covers replacement whenever MapStruct creates interface results. Repo already makes `RETURN_DEFAULT` empty collection/map creation discoverable: `processor/src/main/resources/org/mapstruct/ap/internal/model/IterableMappingMethod.ftl:20-40` and `MapMappingMethod.ftl:19-29` return `iterableCreation` on null when `mapNullToDefault`; existing tests assert empties for that behavior in `processor/src/test/java/org/mapstruct/ap/test/nullvaluemapping/NullValueIterableMappingStrategyTest.java:24-31` and `NullValueMapMappingStrategyTest.java:24-31`.",
      "fairness": "Repo-discoverable",
      "name": "shouldConfigureReturnDefaultMappings",
      "qualityCheck": "Fair integration test. It pins both class and emptiness, which are the observable outcomes that matter.",
      "verifies": "With `NullValueMappingStrategy.RETURN_DEFAULT`, a null `List` source returns an empty `FactoryList`, and a null `Map` source returns an empty `HashMap`."
    },
    {
      "evidence": "Prompt explicitly says: 'When it also exposes a usable public `int` constructor, MapStruct must use that constructor with the source size as the initial capacity.' It also says the implementation may be a source type in the current compilation.",
      "fairness": "Prompt-stated",
      "name": "shouldRetainInitialCapacityConstructionWhenAvailable",
      "qualityCheck": "Strong and non-brittle: it checks the exact promised constructor-selection rule and still confirms element mapping works.",
      "verifies": "A configured `List` implementation with a public `int` constructor is instantiated as `CapacityList`; `CapacityList.getLastCapacity()` equals the source size (`2` for `List<Long>`, `3` for `Long[]`), and the array mapping still yields `\"1\", \"2\", \"3\"`."
    },
    {
      "evidence": "Prompt explicitly requires using a usable public `int` constructor with the source size as initial capacity, and says the rule applies to map interface results too.",
      "fairness": "Prompt-stated",
      "name": "shouldRetainInitialCapacityConstructionForMaps",
      "qualityCheck": "Good observable contract test; not coupled to internal method names except the purpose-built test fixture probe.",
      "verifies": "A configured `Map` implementation with a public `int` constructor is instantiated as `CapacityMapD4e6b2`; the mapped entries are exactly `(1->10, 2->20)` as strings, and `CapacityMapD4e6b2.getLastCapacity()` is `2`."
    },
    {
      "evidence": "Prompt says the implementation must 'expose a public no-argument constructor that declares no checked exceptions' and only 'when it also exposes a usable public `int` constructor' must MapStruct use that constructor. That makes fallback to the no-arg constructor the stated behavior.",
      "fairness": "Prompt-stated",
      "name": "shouldUseTheNoArgConstructorWhenTheIntConstructorIsNotUsable",
      "qualityCheck": "Fair and precise; it tests the boundary between 'usable int ctor' and 'only no-arg ctor is usable'.",
      "verifies": "When the configured implementation has a non-usable `int` constructor but a usable public no-arg constructor, the result is exactly `FallbackCapacityList` and `FallbackCapacityList.wasNoArgConstructorUsed()` is `true`."
    },
    {
      "evidence": "Prompt states: 'The rule applies to every mapping form' and includes collection values copied into bean properties. A forged nested mapping is exactly one of those construction sites.",
      "fairness": "Prompt-stated",
      "name": "shouldUseConfigurationInForgedNestedMappings",
      "qualityCheck": "Good integration coverage of forged mapping generation, not just top-level iterable methods.",
      "verifies": "In a forged nested bean mapping, the nested `values` property is instantiated exactly as `FactoryList` and contains `\"1\", \"2\"`."
    },
    {
      "evidence": "Prompt says the configured choice replaces the built-in only when MapStruct constructs a supported interface result. Repo shows MapStruct only substitutes an implementation type when one exists for the target abstraction: `processor/src/main/java/org/mapstruct/ap/internal/model/common/NewInstanceCreation.java:34-45` uses `targetType.getImplementationType()` if present, otherwise the target type itself.",
      "fairness": "Repo-discoverable",
      "name": "shouldKeepConcreteResultTypesUnchanged",
      "qualityCheck": "Fair boundary test between abstract/interface targets and concrete return types.",
      "verifies": "A mapper method returning concrete `ArrayList<String>` still returns exactly `ArrayList`, while a mapper method returning interface `List<String>` uses the configured `FactoryList`."
    },
    {
      "evidence": "Prompt limits replacement to places where MapStruct constructs a supported interface result. Repo’s update wrapper keeps an existing target instance by clearing and mutating it in place (`processor/src/main/resources/org/mapstruct/ap/internal/model/assignment/ExistingInstanceSetterWrapperForCollectionsAndMaps.ftl:10-25`).",
      "fairness": "Repo-discoverable",
      "name": "shouldKeepExistingMappingTargets",
      "qualityCheck": "Good user-facing assertion that config does not silently replace caller-owned mapping targets.",
      "verifies": "For an update method with an existing `ArrayList` target, the passed-in target remains exactly `ArrayList` and ends up containing `\"1\", \"2\"`; a separate create-method call still returns configured `FactoryList`."
    },
    {
      "evidence": "Prompt explicitly states: 'an applicable object factory still wins.'",
      "fairness": "Prompt-stated",
      "name": "shouldGiveObjectFactoriesPrecedence",
      "qualityCheck": "Excellent precedence test because it checks both the winning-factory case and the fallback-to-config case in one method.",
      "verifies": "When an applicable object factory exists, `toList` returns `FactoryList` and `toMap` returns `FactoryMapD4e6b2` despite conflicting configured implementations; for `Set`, where no competing factory is provided, the configured `ChosenSortedSet` is used."
    },
    {
      "evidence": "Prompt says the rule applies to 'collection results materialized from streams' and that 'an applicable object factory still wins.'",
      "fairness": "Prompt-stated",
      "name": "shouldGiveObjectFactoriesPrecedenceForStreams",
      "qualityCheck": "Good targeted stream case; it distinguishes stream-specific factory precedence from ordinary configured list construction.",
      "verifies": "For stream materialization, `fromStream(Stream.of(1L,2L))` returns exactly `FactoryList` containing `\"1\", \"2\"`, while `fromList(longs())` returns exactly `ChosenList` containing `\"1\", \"2\"`."
    },
    {
      "evidence": "Prompt explicitly includes 'collection results materialized from streams' in the rule’s scope.",
      "fairness": "Prompt-stated",
      "name": "shouldUseConfiguredImplementationForStreamResults",
      "qualityCheck": "Fair and direct. It checks the new stream integration point without overfitting to generated code shape.",
      "verifies": "A stream-to-list mapping with no applicable factory returns exactly `ChosenList` and contains `\"1\", \"2\"`."
    },
    {
      "evidence": "Prompt expressly calls out 'collection or map values copied directly into bean properties' and adds that in each case 'construction follows the rule above'—i.e. exact configured implementation plus int-constructor/no-arg-constructor selection.",
      "fairness": "Prompt-stated",
      "name": "shouldUseConfiguredConstructionForDirectCollectionProperties",
      "qualityCheck": "Important integration test; it checks the path that previously could differ from dedicated iterable/map mapping methods.",
      "verifies": "For direct bean-property copies, `values` is exactly `PropertyListC6a2d9` with contents `one,two,three` and recorded capacity `3`; `labels` is exactly `PropertyMapC6a2d9` with the same entries and recorded capacity `2`; `codes` is exactly `PropertySetC6a2d9` with contents `alpha,beta` and records that its no-arg constructor was used."
    },
    {
      "evidence": "Prompt explicitly states: 'The `mapstruct.configurationFile` annotation processor option instead names another resource on that same classpath by relative path.'",
      "fairness": "Prompt-stated",
      "name": "shouldLoadAnExplicitlySelectedResource",
      "qualityCheck": "Straightforward and fair. It tests the option’s positive path without brittle internals.",
      "verifies": "When `-Amapstruct.configurationFile=config/chosen.properties` is supplied and that classpath resource contains the list mapping, `toList` returns exactly `ChosenList`."
    },
    {
      "evidence": "Prompt says the processor option 'instead names another resource', which makes selected-resource precedence over the default explicit.",
      "fairness": "Prompt-stated",
      "name": "shouldUseTheSelectedResourceInsteadOfTheDefault",
      "qualityCheck": "Good precedence check. Using an intentionally invalid default file is a solid way to prove the default is really ignored.",
      "verifies": "When both a default `mapstruct.properties` and a selected `chosen.properties` exist, MapStruct ignores the default file and `toList` returns exactly `ChosenList` from the selected resource."
    },
    {
      "evidence": "Prompt says that without configuration for an interface the built-in choices remain in effect. Repo exposes the exact built-ins in `processor/src/main/java/org/mapstruct/ap/internal/model/common/TypeFactory.java:123-159`: `List -> ArrayList`, `SequencedSet -> LinkedHashSet`, `SequencedMap -> LinkedHashMap`.",
      "fairness": "Repo-discoverable",
      "name": "shouldRetainDefaultsForUnconfiguredInterfaces",
      "qualityCheck": "Fair and valuable because it proves configuration is per-interface, not global.",
      "verifies": "With only `Map` configured, `toList` still returns exactly built-in `ArrayList`, `toMap` returns configured `ChosenSortedMap`, `toSequencedSet` still returns built-in `LinkedHashSet`, and `toSequencedMap` still returns built-in `LinkedHashMap`."
    },
    {
      "evidence": "Prompt explicitly says: 'Equal duplicate entries are permitted.'",
      "fairness": "Prompt-stated",
      "name": "shouldAcceptEqualDuplicateEntries",
      "qualityCheck": "Simple but legitimate. It tests a precise parsing/validation corner case.",
      "verifies": "Two identical `List` entries in the properties file are accepted and `toList` returns exactly `ChosenList`."
    },
    {
      "evidence": "Prompt says to 'Parse the resource as a standard Java properties file.' The accepted syntax here matches standard `java.util.Properties` file semantics: comments, escaped Unicode in keys, trimming around separators, and backslash line continuation.",
      "fairness": "Standard external semantics",
      "name": "shouldReadStandardPropertiesSyntax",
      "qualityCheck": "Fair use of a real standard rather than an arbitrary author choice; not brittle because it tests standard syntax, not exact formatting.",
      "verifies": "A properties file using comment lines, leading whitespace, a Unicode escape in the key (`Li\\u0073t`), and a continued value line still configures `List` so `toList` returns exactly `ChosenList`."
    },
    {
      "evidence": "Prompt explicitly states: 'An implementation generated by another annotation processor in a later processing round is valid and must be used once it becomes available,' and still requires the usable public `int` constructor to be used when present.",
      "fairness": "Prompt-stated",
      "name": "shouldUseImplementationsGeneratedInLaterProcessingRounds",
      "qualityCheck": "Strong end-to-end test of the multi-round resolution requirement. Reflection on class name is appropriate because the types do not exist in round 1.",
      "verifies": "If the configured implementation types are generated by another processor in later rounds, `toList` returns a class whose name equals `LateRoundListA91e4c`, contains `\"1\", \"2\"`, and reports `lastCapacity()==2`; `toMap` returns a class whose name equals `LateRoundMapA91e4c` and contains exactly `(1->10, 2->20)` as strings."
    },
    {
      "evidence": "Prompt explicitly says: 'Unknown properties ... fail compilation with a diagnostic that identifies the invalid key or value and its cause.'",
      "fairness": "Prompt-stated",
      "name": "shouldRejectUnknownProperties",
      "qualityCheck": "Fair and not brittle: the regex only requires the offending key plus broad cause language, not an exact message string.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `mapstruct.unsupported` and also includes generic invalid/unknown/unsupported wording."
    },
    {
      "evidence": "Prompt explicitly says: 'unsupported interfaces ... fail compilation with a diagnostic that identifies the invalid key or value and its cause.'",
      "fairness": "Prompt-stated",
      "name": "shouldRejectUnsupportedInterfaces",
      "qualityCheck": "Good validation test with flexible message matching.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `java.util.Queue` and also includes unsupported-interface wording."
    },
    {
      "evidence": "Prompt explicitly says: 'empty values ... fail compilation with a diagnostic that identifies the invalid key or value and its cause.'",
      "fairness": "Prompt-stated",
      "name": "shouldRejectEmptyImplementationTypes",
      "qualityCheck": "Fair; regex is broad and checks only the user-visible contract.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `java.util.List` and also includes empty/missing-implementation wording."
    },
    {
      "evidence": "Prompt says an explicitly configured implementation must resolve to a valid type, and one 'that never becomes available remains an invalid configured value.'",
      "fairness": "Prompt-stated",
      "name": "shouldRejectMissingImplementationTypes",
      "qualityCheck": "Good observable failure-mode test; broad regex avoids brittleness.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `MissingList` and also includes missing/unresolved-type wording."
    },
    {
      "evidence": "Prompt requires the implementation to resolve to 'a publicly accessible concrete class'.",
      "fairness": "Prompt-stated",
      "name": "shouldRejectInterfaceImplementationTypes",
      "qualityCheck": "Fair direct validation of the 'concrete class' requirement.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `ChosenListContract` and also includes interface/concrete/instantiable wording."
    },
    {
      "evidence": "Prompt requires 'a publicly accessible concrete class'.",
      "fairness": "Prompt-stated",
      "name": "shouldRejectAbstractImplementationTypes",
      "qualityCheck": "Good precise negative case for the same requirement; slightly redundant with the interface case, but still legitimate.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `AbstractChosenList` and also includes abstract/concrete/instantiable wording."
    },
    {
      "evidence": "Prompt requires the implementation to 'be assignable to the named interface'.",
      "fairness": "Prompt-stated",
      "name": "shouldRejectUnassignableImplementationTypes",
      "qualityCheck": "Fair and necessary because assignability is distinct from merely being concrete/public.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `NotACollection` and also includes assignable/implement/compatible wording."
    },
    {
      "evidence": "Prompt requires the implementation to 'expose a public no-argument constructor that declares no checked exceptions.'",
      "fairness": "Prompt-stated",
      "name": "shouldRejectTypesWithoutAccessibleNoArgConstructors",
      "qualityCheck": "Good boundary check; broad regex keeps it resilient.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `PrivateConstructorList` and also includes constructor/default/no-arg instantiation wording."
    },
    {
      "evidence": "Prompt requires the implementation to 'have the same number of unbounded type parameters'.",
      "fairness": "Prompt-stated",
      "name": "shouldRejectIncompatibleGenericArity",
      "qualityCheck": "Fair and specific to a stated generic-shape rule.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `WrongArityList` and also includes generic/type-parameter/arity wording."
    },
    {
      "evidence": "Prompt requires the implementation to have 'the same number of unbounded type parameters'.",
      "fairness": "Prompt-stated",
      "name": "shouldRejectBoundedGenericImplementations",
      "qualityCheck": "Fair and appropriately narrow; it checks the 'unbounded' part, not just the count.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `BoundedList` and also includes unbounded/bound/type-parameter wording."
    },
    {
      "evidence": "Prompt requires implementations to 'preserve the interface type parameters'.",
      "fairness": "Prompt-stated",
      "name": "shouldRejectGenericImplementationsThatFixElementTypes",
      "qualityCheck": "Good negative case for a subtle but explicitly stated generic-preservation rule.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `FixedElementList` and also includes preserve/type-parameter/type-argument/element-type wording."
    },
    {
      "evidence": "Prompt requires implementations to 'preserve the interface type parameters'. Reordering violates that stated form.",
      "fairness": "Prompt-stated",
      "name": "shouldRejectImplementationsThatReorderTypeParameters",
      "qualityCheck": "Fair and valuable: it catches a different failure mode than fixed element types.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `ReorderedMapE8c4a7` and also includes preserve/type-parameter/order wording."
    },
    {
      "evidence": "Prompt requires a public no-arg constructor that 'declares no checked exceptions.'",
      "fairness": "Prompt-stated",
      "name": "shouldRejectConstructorsWithCheckedExceptions",
      "qualityCheck": "Fair and direct; regex is broad enough to avoid over-coupling to exact phrasing.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `CheckedConstructorList` and also includes checked/exception/throws wording."
    },
    {
      "evidence": "Prompt requires the implementation to resolve to a 'publicly accessible' concrete class.",
      "fairness": "Prompt-stated",
      "name": "shouldRejectInaccessibleImplementationTypes",
      "qualityCheck": "Good accessibility check. The regex sensibly targets the offending type name plus the access cause.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `HiddenList` and also includes public/access/visible wording."
    },
    {
      "evidence": "Prompt explicitly says 'conflicting duplicates fail compilation with a diagnostic that identifies the invalid key or value and its cause.'",
      "fairness": "Prompt-stated",
      "name": "shouldRejectConflictingDuplicateEntries",
      "qualityCheck": "Fair and non-brittle; the regex matches the required substance, not a fixed sentence.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `java.util.List` and also includes duplicate/conflict/multiple/different wording."
    },
    {
      "evidence": "Prompt explicitly states: 'That resource must exist when explicitly selected.'",
      "fairness": "Prompt-stated",
      "name": "shouldRejectMissingSelectedResources",
      "qualityCheck": "Good negative-path test. Message matching is very tolerant and only requires the missing resource name.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `absent.properties` when `mapstruct.configurationFile=absent.properties` is explicitly selected but missing."
    },
    {
      "evidence": "Prompt explicitly states: 'Neither resource is resolved from the annotation processor's own classloader.'",
      "fairness": "Prompt-stated",
      "name": "shouldNotLoadConfigurationFromTheProcessorClassloader",
      "qualityCheck": "Fair and important integration test for classpath/classloader boundaries. Matching on the filename keeps it robust.",
      "verifies": "Compilation fails with an error diagnostic whose text includes `processor-only_a91e4c.properties` when the resource is only reachable from the annotation processor’s own classloader."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Repository meets compliance requirements (500+ stars, permissive license, active maintenance)**

Status: WARNING

License could not be recognized — proceed with caution; confirm it is a permitted license (MIT, Apache-2.0, BSD-2/3-Clause, ISC, 0BSD, Unlicense, or CC0) or the submission may be rejected in review

```json
{
  "checks": {
    "activeMaintenance": "pass",
    "language": "pass",
    "license": "warning",
    "stars": "pass",
    "validCommit": "pass"
  },
  "commitHash": "7ad5f9e56e9896c8f165d509b0cff8916061e85e",
  "owner": "mapstruct",
  "repo": "mapstruct",
  "repoInfo": {
    "language": "java",
    "license": "noassertion",
    "stars": 7671
  },
  "warnings": [
    "License could not be recognized — proceed with caution; confirm it is a permitted license (MIT, Apache-2.0, BSD-2/3-Clause, ISC, 0BSD, Unlicense, or CC0) or the submission may be rejected in review"
  ]
}
```

---

**Shipd Bot Description Warnings**

> "The rule applies to every mapping form"

This is slightly spec-doc-ish. Fold it into the next sentence so it reads more like normal engineering prose, e.g. "Apply this anywhere MapStruct constructs a supported collection or map interface result, including direct bean-property copies and stream materialization." That keeps the tested scope without the formal preamble.

> "construction follows the rule above"

Trim this clause. It restates constructor-selection rules that were already spelled out in the previous sentence. A tighter ending would be: "...only when MapStruct constructs that exact supported interface result, and an applicable object factory still wins."

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 4 suggestions total, including 1 HIGH priority item and 2 MEDIUM ones. Per guidelines, any HIGH priority or 3+ suggestions requires a request_changes verdict.",
  "suggestions": [
    {
      "priority": "high",
      "quote": "\"... without a default resource, the built-in choices remain in effect.\"",
      "suggestion": "Remove this fallback note. If no configuration file is present, using built-in defaults is the obvious behavior and discoverable from the code/tests, so stating it adds noise."
    },
    {
      "priority": "medium",
      "quote": "\"... on that same classpath by relative path.\"",
      "suggestion": "Remove the phrase \"by relative path\". Classpath resources are inherently referenced by resource-relative names; specifying this adds unnecessary implementation detail."
    },
    {
      "priority": "medium",
      "quote": "\"...; construction follows the rule above, and an applicable object factory still wins.\"",
      "suggestion": "Delete only the redundant fragment \"construction follows the rule above,\". It restates the preceding constraints without adding new requirements."
    },
    {
      "priority": "low",
      "quote": "\"...; one that never becomes available remains an invalid configured value.\"",
      "suggestion": "Remove this clause. It is implied by the requirement that the implementation must resolve to a valid, accessible class; a missing/never-generated type naturally fails resolution."
    }
  ],
  "summary": "- [HIGH] Delete the fallback clause “without a default resource, the built-in choices remain in effect.” This is an obvious default and discoverable from existing behavior; keeping it is redundant.\n- [MEDIUM] Remove “by relative path” from “The mapstruct.configurationFile … on that same classpath by relative path.” Classpath resource lookups are inherently relative; this detail is unnecessary.\n- [MEDIUM] Trim “construction follows the rule above,” from “In each case, the configured choice …; construction follows the rule above, and an applicable object factory still wins.” It restates prior constraints without adding information.\n- [LOW] Drop “one that never becomes available remains an invalid configured value.” It’s implied by the requirement that implementations must resolve to valid, accessible classes; unresolved types already fail.",
  "verdict": "request_changes"
}
```
