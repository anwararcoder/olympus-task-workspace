**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥40 messages, ≥250 LOC

This task numbers: Median files: 14, messages: 125.5, LOC: 428

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "be6546c6f0a83e6f26475bdb8eb5b88480f675c74fe01d1ab0eb42453fdcb727",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Adds bean-to-map mapping methods that emit entries for each readable property (keys as property names), with support for constants/expressions, conditions, defaults, ignores, and update methods; introduces a dedicated mapping method model and templates and integrates its detection and creation in the processor.",
      "confidence": 0.92,
      "contentAuthoredAt": 1783680273814,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission enables mapping between Map<K,V> and iterables/arrays by treating each Map.Entry as an element, including the reverse iterable/array→Map path that builds entries and inserts them into the map.",
        "Candidate enables mapping from a single bean to a Map by emitting entries for each readable bean property (keys are property names), with support for conditions, defaults, ignoring, and update-method semantics; it does not address map↔iterable conversions.",
        "Submission introduces IterableToMapMappingMethod and extends IterableMappingMethod to source elements from map.entrySet() when mapping Map→Iterable; candidate introduces BeanToMapMappingMethod and BeanToMapEntry for property-to-entry emission.",
        "Submission alters BeanMappingMethod/TypeFactory to detect/construct Map.Entry types (e.g., using SimpleImmutableEntry) and relaxes retrieval checks to allow Map→Iterable and Iterable→Map; candidate validates result map key type is assignable from String and adds new diagnostics for missing/unknown property sources.",
        "Templates differ materially: submission updates IterableMappingMethod.ftl and adds IterableToMapMappingMethod.ftl for loop over entrySet and put(key,value) from mapped entries; candidate adds BeanToMapEntry.ftl and BeanToMapMappingMethod.ftl to generate guarded property-to-map entry writes with defaults/removal on null."
      ],
      "one_liner": "Both add new map-related mapping capabilities to MapStruct, but they target different source/target pairs and lifecycles: map↔iterable via Map.Entry vs. bean→map by property names.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "Despite both living in the same repo and touching core processors, they implement fundamentally different features at different surfaces. The submission teaches how to map Map entries to iterable elements (and back), while the candidate teaches emitting a map from a bean’s properties with conditions/defaults/update semantics. There are no shared purpose-matched APIs or behaviors; overlapping files are modified for distinct detection/creation paths, not the same task.",
      "similarity": 0.5670818090438843,
      "submission_summary": "Adds bidirectional support for mapping between Map<K,V> and iterables/arrays by treating Map.Entry as the element type, including generation and construction of entry implementations and adapting iterable handling and templates to iterate over entrySet when the source is a map.",
      "title": "Bean to Map Mapping Methods",
      "verdict": "distinct"
    },
    {
      "authorUsername": "igee",
      "candidate_summary": "Implements support for mapping to Guava’s immutable collections/maps (ImmutableList/Set/Map/Multimap/Table, etc.) using builders, including sorted/natural-order checks and source-shape validations. Adds dedicated immutable mapping method classes, templates, type recognizers, processor wiring, and documentation.",
      "confidence": 0.94,
      "contentAuthoredAt": 1783929834023,
      "evalStatus": "ok",
      "evidence_gaps": [
        "Candidate solution patch is truncated; however, visible changes already show a distinct Guava-immutable feature set unrelated to Map↔Iterable entry mapping."
      ],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds bidirectional mapping between Map<K,V> and iterables/arrays by treating each Map.Entry as an element and, in reverse, mapping elements to Map.Entry then inserting into a Map; candidate adds mapping to Guava Immutable* types (ImmutableList/Set/Map/Multimap/Table, etc.) via builders and enforces sorted/shape constraints.",
        "Submission modifies IterableMappingMethod and its template to iterate over map.entrySet() when the source is a Map and introduces a new IterableToMapMappingMethod plus Map.Entry construction (via SimpleImmutableEntry); candidate introduces entirely new Immutable* mapping method classes, builders, and templates and treats Guava immutables as non-updatable targets.",
        "Submission relaxes method validation to allow Map→Iterable and Iterable→Map (MethodRetrievalProcessor) and wires new lifecycle paths in MapperCreationProcessor for these; candidate wires Guava-immutable handling in MapperCreationProcessor, disallows @MappingTarget for immutables, and reports natural-ordering and source-shape errors.",
        "Type/TypeFactory changes diverge: submission adds Map.Entry detection and entry-implementation lookup; candidate adds many Guava type recognizers (isGuavaImmutable*), multimap/table type-argument resolution, and related behaviors."
      ],
      "one_liner": "Both extend MapStruct’s collection/map mapping capabilities, but one adds bidirectional Map↔Iterable entry mapping while the other adds support for Guava’s immutable collection/map types.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Despite sharing the repository and both touching collection-mapping infrastructure, the modified surfaces are used for different purposes and yield different observable features: the submission enables treating Map entries as iterable elements and vice versa, while the candidate introduces mapping to Guava’s immutable containers with builders and specific validations. There are no shared APIs or behaviors implementing the same task; overlaps are limited to generic framework plumbing, not the feature itself.",
      "similarity": 0.521665096282959,
      "submission_summary": "Implements mapping from Map<K,V> to iterables/arrays by iterating entrySet and mapping each entry to a result element, and reverse mapping from iterable/array elements to a Map via Map.Entry. Adds Map.Entry construction support, updates type detection and validation, new IterableToMapMappingMethod and template, and documentation for map–iterable mappings.",
      "title": "immutable collections",
      "verdict": "distinct"
    },
    {
      "authorUsername": "srtk",
      "candidate_summary": "Introduces @Iteration and IterationPart to supply index/size/first/last to element conversion methods invoked from iterable/array/map mapping loops. Extends selection/binding, validation, and codegen to wire these parameters, generate supporting locals (including lookahead), and forbid their use on mapping/stream methods.",
      "confidence": 0.93,
      "contentAuthoredAt": 1784036973339,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds end-to-end support for mapping Map<K,V> to iterable/array by treating each entry as an element and for mapping iterable/array elements to Map.Entry<K,V> to populate a Map; it introduces IterableToMapMappingMethod and adapts IterableMappingMethod to consume Map sources via entrySet().",
        "Submission extends type construction to support Map.Entry return/target types via AbstractMap.SimpleImmutableEntry and adds constructor/accessor logic for key/value; candidate does not interact with Map.Entry construction at all.",
        "Candidate adds new public API annotations @Iteration and IterationPart, selection/binding logic, and codegen to provide index/size/first/last to element conversion methods across iterable/array/map mappings, including validation and stream exclusions; submission does not introduce or use iteration parameters.",
        "Candidate modifies templates and builders to thread IterationPosition and generate index/size/lookahead logic; submission’s template changes are solely to iterate maps via entrySet() and to emit puts for iterable→map, with no position tracking.",
        "Candidate adds extensive validation errors around iteration params (wrong type, duplicates, disallowed on mapping methods/streams); submission’s retrieval changes are only to relax/allow Map↔Iterable method signatures."
      ],
      "one_liner": "Both extend MapStruct’s collection/map mappings, but one adds Map↔Iterable element-to-entry conversions via Map.Entry while the other introduces @Iteration position parameters for element conversions inside loops.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both touch iterable/map mapping internals and some of the same files, they do so for different purposes. The submission implements Map↔Iterable element/entry mappings via Map.Entry and related type construction, while the candidate introduces a new annotation-driven mechanism to expose iteration position to element converters, with accompanying validation and codegen. There are no shared newly introduced APIs or identical behaviors; the overlaps are framework scaffolding edited for different features.",
      "similarity": 0.45190680027008057,
      "submission_summary": "Implements mapping between maps and iterables/arrays: maps are treated as sequences of entries for iterable targets, and iterable elements can be mapped to Map.Entry<K,V> to populate map results. Extends processors/templates to infer Map.Entry element types, iterate over entrySet(), generate iterable→map loops, and construct Map.Entry implementations.",
      "title": "Iteration position parameters for element conversions",
      "verdict": "distinct"
    },
    {
      "authorUsername": "srtk",
      "candidate_summary": "Introduces @Iteration and IterationPart to allow conversion methods used inside generated iterable/array/map loops to receive loop position (index, size, first, last). Wires these parameters through method selection and templates, generates non-colliding locals, and adds compile-time validation rules preventing misuse and ensuring correct types and applicability.",
      "confidence": 0.9,
      "contentAuthoredAt": 1784233252851,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds end-to-end support for mapping Map<K,V> to/from iterables by treating entries as elements, including forging Iterable→Map and Map→Iterable methods and constructing concrete Map.Entry implementations; the candidate does not touch Map↔Iterable conversion.",
        "Submission introduces IterableToMapMappingMethod and related FTL to build maps from iterable elements; the candidate introduces @Iteration and IterationPart APIs and wiring to pass index/size/first/last into existing iterable/array/map loops.",
        "Submission modifies templates to iterate map.entrySet() when the source is a map and to treat Map.Entry as element type; the candidate modifies templates to track and pass loop position variables but keeps existing element/key/value mapping semantics.",
        "Submission extends Bean/Type/TypeFactory to detect Map.Entry types and choose SimpleImmutableEntry for construction; the candidate extends parameter parsing/binding and method selection/validation to recognize and enforce @Iteration constraints."
      ],
      "one_liner": "One implements mapping between maps and iterables via Map.Entry handling, while the other adds loop-position iteration parameters to element/key/value conversions.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "Despite touching some of the same generator templates and model classes, the two patches target different behaviors and purposes. The submission’s core is enabling Map↔Iterable mappings via Map.Entry element mapping and entry construction, whereas the candidate’s core is exposing loop position (index/size/first/last) to conversion methods across iterable/array/map loops with new public annotations and validation. These are separate features that teach different lessons; overlapping files are changed for distinct, non-overlapping goals.",
      "similarity": 0.4490545392036438,
      "submission_summary": "Implements mapping between Map<K,V> and iterables/arrays by treating each map entry as an element and, in reverse, mapping elements to Map.Entry and inserting into the target map. Adds Iterable→Map mapping machinery, Map.Entry type detection and construction, and updates templates and validation to support map entries in iterable mappings, with documentation updates.",
      "title": "Add Loop-Position Parameters for MapStruct Element Conversions",
      "verdict": "distinct"
    },
    {
      "authorUsername": "winnie",
      "candidate_summary": "Enhances the MVEL-to-Java rewriter to convert inline list/map literals into Java collections and coerce their elements/keys/values to the target’s generic types, choosing concrete list/set/map variants and unifying numeric types. Modifies the rewriter, adds TypeUtils for type inference and numeric ranking, and introduces CollectionLiterals builders to create mutable and sorted collections.",
      "confidence": 0.96,
      "contentAuthoredAt": 1780869482408,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: MapStruct code generation for bean/collection mappings vs. MVEL transpiler rewriting of inline collection literals.",
        "Submission adds support for mapping Map<K,V> to/from iterables/arrays via Map.Entry elements, including constructor handling for entries and codegen templates; candidate adds type-directed coercion of list/map literals to match target generic types, chooses concrete collection kinds, and unifies numeric types.",
        "Submission modifies MapStruct’s processor/model (BeanMappingMethod, IterableMappingMethod, PropertyMapping, Type/TypeFactory, templates) to enable map↔iterable mappings; candidate modifies MVELToJavaRewriter, introduces TypeUtils and CollectionLiterals, and coerces literals during variable init/assignment/method/constructor argument processing.",
        "Submission concerns mapping-method selection, null-value strategies, result-container instantiation for Map.Entry; candidate concerns runtime/compile-time type resolution, numeric widening and parsing, and building mutable or sorted collections based on target types."
      ],
      "one_liner": "Both enhance collection handling, but one adds map↔iterable entry mapping in a Java mapping generator while the other coerces inline list/map literals to target types in a transpiler.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "The patches target unrelated systems and purposes. The submission augments MapStruct’s code generation to support mapping between maps and iterables via Map.Entry, touching mapper model, selection, and templates. The candidate rewrites MVEL inline collection literals with type-directed coercion, numeric unification, and concrete collection selection. There is no purpose-matched modified surface or shared observable behavior beyond the generic theme of collections.",
      "similarity": 0.43725746870040894,
      "submission_summary": "Extends MapStruct to map Map<K,V> to iterables/arrays by treating each map entry as an element and to map iterables to maps by producing Map.Entry<K,V> and inserting key/value into the result. Updates processor/model classes and templates to recognize Map.Entry types, construct concrete entry implementations, iterate entrySet for map sources, and allow these mappings in method retrieval and selection.",
      "title": "Type-directed coercion for inline list and map literals",
      "verdict": "distinct"
    }
  ]
}
```

---

**Test Fairness**

Coverage Suggestions (2) - Not Blockers

Advisory only — these don't affect the check result.

Duplicate keys in iterable/array -> map
Add a test where two source elements map to the same entry key, so the benchmark documents whether later elements overwrite earlier ones in the result map.

Missing entry-mapping diagnostics
Add negative tests for map->iterable/array and iterable/array->map when no suitable Map.Entry element mapping exists, to ensure the processor emits a clear user-facing diagnostic for the new feature.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Duplicate keys in iterable/array -> map",
      "suggestion": "Add a test where two source elements map to the same entry key, so the benchmark documents whether later elements overwrite earlier ones in the result map."
    },
    {
      "area": "Missing entry-mapping diagnostics",
      "suggestion": "Add negative tests for map->iterable/array and iterable/array->map when no suitable Map.Entry element mapping exists, to ensure the processor emits a clear user-facing diagnostic for the new feature."
    }
  ],
  "error": "",
  "executionTimeSeconds": 650.716868,
  "message": "All hidden tests are fair.",
  "overall": "Overall, the hidden tests are fair. The core new behaviors are explicitly spelled out in the prompt, and the rest of the expectations reuse long-standing repo conventions for null handling, update semantics, subtype construction, qualifier selection, inherited methods, context propagation, and stream-vs-iterable family boundaries. A few tests infer exact literals from helper methods that exist only in the hidden test sources, but those literals are merely the observable consequence of selecting the right mapping method; they do not introduce extra hidden choices beyond the prompt+repo behavior contract.",
  "taskSummary": "The task adds a new MapStruct container-mapping mode: a Map<K,V> can be mapped to an iterable or array by treating each map entry as the source element, preserving the map's iteration order; in the reverse direction, each iterable/array element is first mapped to a Map.Entry<K,V>, then that entry's key/value are inserted into the result map. The prompt also states three important extensions: (1) these entry-element mappings use normal method selection/conversions/iterable qualifiers, (2) abstract mapping methods may target Map.Entry via logical key/value properties, and (3) lower-bounded map result types are supported when the selected entry mapping returns a concrete entry type. Hidden tests also lean on existing repo-wide container semantics: null-by-default vs RETURN_DEFAULT, update-method replacement semantics, subtype support, stream-vs-iterable boundaries, inherited mapping methods, and @Context propagation.",
  "tests": [
    {
      "evidence": "The prompt explicitly says: \"Support mapping from a Map<K, V> to an iterable or array result by treating each map entry as a source element, in the map's iteration order.\" It also says: \"Abstract mapping methods may target Map.Entry<K, V> through its logical key and value target properties.\" Given a LinkedHashMap and an entry mapping that reads key plus value properties, those exact extracted sequences are the singled-out result.",
      "fairness": "Prompt-stated",
      "name": "mapsEachMapEntryToAnIterableElement",
      "qualityCheck": "Fair and concrete. The exact values come from source data plus the declared entry mapping, not from hidden internals.",
      "verifies": "Mapping a LinkedHashMap with entries monday->Schedule(11:00, office) and friday->Schedule(16:00, remote) to List<FlattenedSchedule> yields a list whose extracted day values are exactly [\"monday\", \"friday\"], extracted time values exactly [\"11:00\", \"16:00\"], and extracted kind values exactly [\"office\", \"remote\"]."
    },
    {
      "evidence": "The prompt explicitly says: \"In the reverse direction, map each iterable or array source element to a Map.Entry<K, V>, then add that entry's key and value to the result map.\" Combined with \"Abstract mapping methods may target Map.Entry<K, V> through its logical key and value target properties,\" that makes these exact key/value contents predictable from the source objects.",
      "fairness": "Prompt-stated",
      "name": "mapsEachIterableElementThroughAMapEntry",
      "qualityCheck": "Fair. The assertions are direct consequences of the prompt-defined reverse mapping rule.",
      "verifies": "Mapping a two-element List<FlattenedSchedule> to Map<String,Schedule> yields a map containing only keys \"monday\" and \"friday\"; result.get(\"monday\").time == \"11:00\"; result.get(\"monday\").kind == \"office\"; result.get(\"friday\").time == \"16:00\"; result.get(\"friday\").kind == \"remote\"."
    },
    {
      "evidence": "The prompt expressly states: \"Abstract mapping methods may target Map.Entry<K, V> through its logical key and value target properties.\" The hidden mapper uses logical targets key and value, so these exact key/value fields are the prompt-defined outcome.",
      "fairness": "Prompt-stated",
      "name": "mapsAnOrdinaryObjectToAnEntry",
      "qualityCheck": "Fair. This is a direct probe of the new abstract Map.Entry target support.",
      "verifies": "Calling the abstract object-to-entry method with FlattenedSchedule(day=monday,time=11:00,kind=office) returns a Map.Entry whose key is exactly \"monday\", whose value.time is exactly \"11:00\", and whose value.kind is exactly \"office\"."
    },
    {
      "evidence": "Existing repo tests establish null-by-default container behavior: processor/src/test/java/org/mapstruct/ap/test/collection/CollectionMappingTest.java:38 and :49 assert null iterable properties remain null by default; processor/src/test/java/org/mapstruct/ap/test/collection/forged/CollectionMappingTest.java:151-157 shows null map properties remain null by default; override tests in processor/src/test/java/org/mapstruct/ap/test/nullvaluemapping/NullValueIterableMappingStrategyTest.java:33,41 and .../NullValueMapMappingStrategyTest.java:33,43 show empties/nulls are controlled by explicit null-value strategy, implying null is the default baseline.",
      "fairness": "Repo-discoverable",
      "name": "returnsNullForNullSourcesByDefault",
      "qualityCheck": "Fair, though it bundles three related null assertions. They all track established repository semantics.",
      "verifies": "By default, map((Map)null) returns null, map((List)null) returns null, and mapEntry((FlattenedSchedule)null) returns null."
    },
    {
      "evidence": "The repo already pins this exact behavior separately for iterable and map mappings: processor/src/test/java/org/mapstruct/ap/test/nullvaluemapping/NullValueIterableMappingStrategyTest.java:33 asserts a null iterable source maps to isEmpty(); processor/src/test/java/org/mapstruct/ap/test/nullvaluemapping/NullValueMapMappingStrategyTest.java:33 asserts a null map source maps to isEmpty(); and processor/src/test/java/org/mapstruct/ap/test/collection/forged/CollectionMapperNullValueMappingReturnDefault.java:12 shows the mapper-level RETURN_DEFAULT configuration pattern.",
      "fairness": "Repo-discoverable",
      "name": "returnsEmptyContainersForNullSourcesWhenConfigured",
      "qualityCheck": "Fair and well supported by existing tests. Not brittle.",
      "verifies": "With @Mapper(nullValueMappingStrategy = RETURN_DEFAULT), toList(null) returns an empty list and toMap(null) returns an empty map."
    },
    {
      "evidence": "The repo already shows container-typed bean properties are mapped through container mapping methods: processor/src/test/java/org/mapstruct/ap/test/collection/map/MapMappingTest.java:118-142 asserts map-typed bean properties are mapped; processor/src/test/java/org/mapstruct/ap/test/collection/CollectionMappingTest.java:57-61 and :77-84 assert iterable bean properties are mapped with expected element content/order. Given the prompt's new cross-container map↔iterable support, composing it inside bean properties is predictable.",
      "fairness": "Repo-discoverable",
      "name": "mapsMapAndIterableBeanProperties",
      "qualityCheck": "Fair. It checks an important integration point rather than an internal detail.",
      "verifies": "Flattening a bean whose schedules property is a one-entry map yields a bean whose schedules list has size 1 with first element day == \"monday\" and time == \"11:00\"; expanding that flattened bean yields a bean whose schedules map contains only key \"monday\" and whose mapped value.kind == \"office\"."
    },
    {
      "evidence": "Concrete collection/map subtype support is already visible in the repo. processor/src/test/java/org/mapstruct/ap/test/bugs/_2668/Issue2668Test.java:25 expects custom collection/map subtypes with accessible constructors to compile, and processor/src/test/java/org/mapstruct/ap/test/bugs/_2668/Issue2668Mapper.java:91-104 defines such subtypes. Runtime mapping through custom collection/map subclasses is also exercised in processor/src/test/java/org/mapstruct/ap/test/collection/CollectionMappingTest.java:409-434.",
      "fairness": "Repo-discoverable",
      "name": "supportsConcreteMapAndIterableSubtypes",
      "qualityCheck": "Fair. The instance-type check is aligned with the declared concrete return type and existing subtype support conventions.",
      "verifies": "Mapping a concrete ScheduleMap source yields a FlattenedScheduleList of size 1 whose first element day == \"monday\"; mapping that list back yields an object that is an instance of ScheduleMap and whose \"monday\" entry has time == \"11:00\"."
    },
    {
      "evidence": "The prompt says entry mappings participate in normal conversions, and the repo already pins the exact numeric/string key conversion form in ordinary map mappings: processor/src/test/java/org/mapstruct/ap/test/collection/map/MapMappingTest.java:44-45 expects numeric keys to map to strings like \"42\"/\"121\", and :105-106 expects the reverse back to numeric keys. That makes \"12\" <-> 12 predictable here.",
      "fairness": "Repo-discoverable",
      "name": "appliesExistingConversionsToEntryKeys",
      "qualityCheck": "Fair. Exact values are standard built-in conversion outputs already exercised elsewhere in the repo.",
      "verifies": "Flattening a map with the single key 12 produces a one-element list whose first day is exactly \"12\"; expanding that list back produces a map containing only key 12, and result.get(12).kind == \"office\"."
    },
    {
      "evidence": "Iterable qualifier selection is already explicit in the repo: processor/src/test/java/org/mapstruct/ap/test/selection/qualifier/named/KeyWordMapper.java:34 uses @IterableMapping(... qualifiedByName = \"EnglishToGerman\"), and processor/src/test/java/org/mapstruct/ap/test/selection/qualifier/named/NamedTest.java:73 shows the resulting iterable element values come from the named method's output. The prompt then explicitly extends iterable mapping qualifiers to entry element mappings.",
      "fairness": "Repo-discoverable",
      "name": "selectsEntryMappingMethodsWithIterableQualifiers",
      "qualityCheck": "Fair. The literal prefix is test-local, but it is only observing that the qualified helper method was selected.",
      "verifies": "When iterable mappings are qualified, flatten(...) returns a one-element list whose day is exactly \"selected-monday\"; expand(...) returns a map containing only key \"monday\" and result.get(\"monday\").time == \"11:00\"."
    },
    {
      "evidence": "Inherited mapping methods are already a visible MapStruct behavior: processor/src/test/java/org/mapstruct/ap/test/inheritedmappingmethod/InheritedMappingMethodTest.java:29-42 and :49-64 assert methods inherited from base mapper interfaces are selected and used. The prompt states entry element mappings participate in normal mapping-method selection, so inherited entry mappings are a predictable extension.",
      "fairness": "Repo-discoverable",
      "name": "supportsInheritedCrossContainerMappingMethods",
      "qualityCheck": "Fair. It checks a real integration behavior and relies on an existing repo convention.",
      "verifies": "Using a mapper that inherits the entry mapping methods from a base interface, flatten(...) returns a one-element list whose first day is \"monday\"; expand(...) returns a map containing only key \"monday\" and whose mapped value.kind == \"office\"."
    },
    {
      "evidence": "Existing update semantics for containers already replace prior contents rather than append to them: processor/src/test/java/org/mapstruct/ap/test/collection/CollectionMappingTest.java:125-126 asserts updated target lists contain only the new source contents, and :353-354 asserts updated target maps are reduced to the new source contents. The new feature reuses those established update semantics for cross-container mappings.",
      "fairness": "Repo-discoverable",
      "name": "replacesExistingEntriesInMappingTargets",
      "qualityCheck": "Fair. Good behavioral coverage; not coupled to implementation details like explicit clear() calls.",
      "verifies": "Updating an existing target list from a one-entry map leaves the target list with size 1 and first element day == \"monday\"; updating an existing target map from a one-element list leaves the target map containing only key \"friday\" with result.get(\"friday\").time == \"16:00\"."
    },
    {
      "evidence": "The prompt explicitly includes mapping to an \"iterable or array result\" and says map entries are treated as source elements \"in the map's iteration order.\" Those words directly single out the asserted day/time array order for a LinkedHashMap source.",
      "fairness": "Prompt-stated",
      "name": "mapsMapEntriesToArrayElementsInIterationOrder",
      "qualityCheck": "Fair and precise. The order requirement is directly in the prompt.",
      "verifies": "Mapping a LinkedHashMap with monday and friday entries to an array yields an array whose extracted day values are exactly [\"monday\", \"friday\"] and extracted time values exactly [\"11:00\", \"16:00\"]."
    },
    {
      "evidence": "The prompt explicitly extends the reverse-direction rule to arrays: \"map each iterable or array source element to a Map.Entry<K, V>, then add that entry's key and value to the result map.\" Those exact keys and fields are the direct consequence of that rule on the provided array elements.",
      "fairness": "Prompt-stated",
      "name": "mapsArrayElementsThroughMapEntries",
      "qualityCheck": "Fair. This is the array analogue of the list-to-map behavior already stated in the prompt.",
      "verifies": "Mapping a FlattenedSchedule[] containing monday and friday elements to a map yields a map containing only keys \"monday\" and \"friday\"; result.get(\"monday\").kind == \"office\"; result.get(\"friday\").time == \"16:00\"."
    },
    {
      "evidence": "The prompt's last sentence is explicit: \"Compatible lower-bounded map result types are supported when the selected entry mapping method returns a concrete entry type.\" The asserted entry is just the concrete selected entry method's output for the supplied source.",
      "fairness": "Prompt-stated",
      "name": "usesConcreteSelectedEntryTypesForLowerBoundedMapResults",
      "qualityCheck": "Fair and directly covered by the prompt. The concrete key/value pair is only observing the selected helper result.",
      "verifies": "Mapping a one-element list to Map<? super String, ? super String> yields a map containing the exact entry (\"bounded-monday\", \"11:00\")."
    },
    {
      "evidence": "The repo already makes @Context propagation through nested/container-related operations discoverable: processor/src/test/java/org/mapstruct/ap/test/bugs/_1131/Issue1131MapperWithContext.java:47,63 and .../Issue1131Test.java:66 show context participates in nested collection-related creation; processor/src/test/java/org/mapstruct/ap/test/bugs/_3561/Issue3561Mapper.java:21,25 and .../Issue3561Test.java:31-33 show selected helper logic receives @Context values; and processor/src/test/java/org/mapstruct/ap/test/naming/VariableNamingTest.java:21-23,34,52 shows variable-name collisions in generated code are a known tested concern in this repo. With the prompt's \"normal mapping-method selection\" language, correct context-driven output here is reasonably predictable.",
      "fairness": "Repo-discoverable",
      "name": "avoidsEntryLocalCollisionsWithContextParameters",
      "qualityCheck": "Fair but slightly indirect. The test name points at a codegen-collision concern, yet the assertions stay on user-visible behavior rather than generated local variable names.",
      "verifies": "Mapping a one-element list with context string \"context-\" yields a map containing only key \"context-monday\", and result.get(\"context-monday\") == \"11:00\"."
    },
    {
      "evidence": "That exact diagnostic is already pinned in repo tests: processor/src/test/java/org/mapstruct/ap/test/collection/erroneous/ErroneousCollectionMappingTest.java:36-38 and processor/src/test/java/org/mapstruct/ap/test/java8stream/erroneous/ErroneousStreamMappingTest.java:43-46. The prompt expands support only to iterable/array targets, not streams.",
      "fairness": "Repo-discoverable",
      "name": "preservesStreamMappingFamilyBoundaries: mapToStream error",
      "qualityCheck": "Fair. Exact message matching is somewhat wording-sensitive, but the wording is already standardized in the pinned repo.",
      "verifies": "Compiling the hidden mapper reports an ERROR on the mapToStream declaration line (line 18) with the exact message: \"Can't generate mapping method from non-iterable type to iterable type from java stdlib.\""
    },
    {
      "evidence": "That exact reverse-direction diagnostic is already pinned in repo tests: processor/src/test/java/org/mapstruct/ap/test/collection/erroneous/ErroneousCollectionMappingTest.java:32-34 and processor/src/test/java/org/mapstruct/ap/test/java8stream/erroneous/ErroneousStreamMappingTest.java:39-42. Since the prompt does not extend the feature to Stream, keeping this boundary is discoverable.",
      "fairness": "Repo-discoverable",
      "name": "preservesStreamMappingFamilyBoundaries: streamToMap error",
      "qualityCheck": "Fair. Line-number pinning is stable here because it refers to fixed method declaration lines in the hidden source, not generated output.",
      "verifies": "Compiling the hidden mapper reports an ERROR on the mapStreamToMap declaration line (line 20) with the exact message: \"Can't generate mapping method from iterable type from java stdlib to non-iterable type.\""
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Dockerfile guidelines**

Status: WARNING

WARNING: The Dockerfile downloads and installs a JDK into the image even though the chosen base image is olympus-base-jvm. Installing a second/alternative JDK may be redundant and requires justification. Relevant lines:

RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
      amd64) tarch='x64'; sha='4b2220e232a97997b436ca6ab15cbf70171ecff52958a46159dfa5a8c44ca4de' ;; \
      arm64) tarch='aarch64'; sha='8d498ec88e1c1989fab95c6784240ab92d011e29c54d20a3f9c324b13476f9ad' ;; \
      *) echo "unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    url="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jdk_${tarch}_linux_hotspot_21.0.11_10.tar.gz"; \
    curl -fsSL --retry 8 --retry-all-errors --retry-delay 5 -o /tmp/jdk21.tar.gz "$url"; \
    echo "${sha}  /tmp/jdk21.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/jdk-21; \
    tar -xzf /tmp/jdk21.tar.gz -C /opt/jdk-21 --strip-components=1; \
    rm -f /tmp/jdk21.tar.gz; \
    /opt/jdk-21/bin/java -version

-- This is not classified as malicious (sha256 verification is present), but it may duplicate functionality in olympus-base-jvm. If the intent is to override the base JDK, document why and keep the pinned sha as you have done.

WARNING: Inconsistent use of Maven vs. the Maven wrapper may reduce reproducibility. The Dockerfile runs the Maven wrapper to show the wrapper's version, but then uses the system mvn binary for the build. If the system mvn differs from the wrapper's pinned version the build can be non-reproducible. Recommended: use ./mvnw for builds (or explicitly pin the system Maven version). Relevant lines:

RUN ./mvnw -B -ntp --version

RUN set -eux; \
    mkdir -p /opt/.m2/repository; \
    mvn -B -ntp -Dmaven.repo.local=/opt/.m2/repository -Dlicense.skip=true -DskipTests clean install; \

(Use: replace the second RUN to invoke ./mvnw -B -ntp -Dmaven.repo.local=... clean install to ensure the wrapper's version is used.)

Note: Internet access is available during `docker build`, but not when running the container. Test patch is injected into the container after build. Ensure your Dockerfile installs all dependencies at build time so the environment works fully offline after build.

```json
{
  "all_issues": "WARNING: The Dockerfile downloads and installs a JDK into the image even though the chosen base image is olympus-base-jvm. Installing a second/alternative JDK may be redundant and requires justification. Relevant lines:\n\nRUN set -eux; \\\n    arch=\"$(dpkg --print-architecture)\"; \\\n    case \"$arch\" in \\\n      amd64) tarch='x64'; sha='4b2220e232a97997b436ca6ab15cbf70171ecff52958a46159dfa5a8c44ca4de' ;; \\\n      arm64) tarch='aarch64'; sha='8d498ec88e1c1989fab95c6784240ab92d011e29c54d20a3f9c324b13476f9ad' ;; \\\n      *) echo \"unsupported architecture: $arch\" >&2; exit 1 ;; \\\n    esac; \\\n    url=\"https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jdk_${tarch}_linux_hotspot_21.0.11_10.tar.gz\"; \\\n    curl -fsSL --retry 8 --retry-all-errors --retry-delay 5 -o /tmp/jdk21.tar.gz \"$url\"; \\\n    echo \"${sha}  /tmp/jdk21.tar.gz\" | sha256sum -c -; \\\n    mkdir -p /opt/jdk-21; \\\n    tar -xzf /tmp/jdk21.tar.gz -C /opt/jdk-21 --strip-components=1; \\\n    rm -f /tmp/jdk21.tar.gz; \\\n    /opt/jdk-21/bin/java -version\n\n-- This is not classified as malicious (sha256 verification is present), but it may duplicate functionality in olympus-base-jvm. If the intent is to override the base JDK, document why and keep the pinned sha as you have done.\n\nWARNING: Inconsistent use of Maven vs. the Maven wrapper may reduce reproducibility. The Dockerfile runs the Maven wrapper to show the wrapper's version, but then uses the system mvn binary for the build. If the system mvn differs from the wrapper's pinned version the build can be non-reproducible. Recommended: use ./mvnw for builds (or explicitly pin the system Maven version). Relevant lines:\n\nRUN ./mvnw -B -ntp --version\n\nRUN set -eux; \\\n    mkdir -p /opt/.m2/repository; \\\n    mvn -B -ntp -Dmaven.repo.local=/opt/.m2/repository -Dlicense.skip=true -DskipTests clean install; \\\n\n(Use: replace the second RUN to invoke ./mvnw -B -ntp -Dmaven.repo.local=... clean install to ensure the wrapper's version is used.)",
  "base_image_compliant": {
    "explanation": "Base image is FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest, which is one of the accepted Olympus base images.",
    "status": "OK"
  },
  "dependencies_installed": {
    "explanation": "Maven is invoked to resolve and build dependencies (mvn ... clean install) and specific test-related artifacts are fetched (dependency:get). The Dockerfile therefore installs project dependencies and performs a build step to populate the Maven cache.",
    "status": "OK"
  },
  "interactive_shell": {
    "explanation": "Container ends with CMD [\"/bin/bash\"], providing an interactive shell for developers.",
    "status": "OK"
  },
  "no_test_execution": {
    "explanation": "Tests are skipped via -DskipTests and there are no RUN lines invoking test.sh, pytest, npm test, or similar. No test.sh/test.patch handling is present.",
    "status": "OK"
  },
  "package_manager_installation": {
    "explanation": "No package managers that are already included in the chosen base image are being reinstalled. The Dockerfile downloads a JDK tarball directly (not via an installer script) and verifies its sha256 sum. No apt/npm/pip installer scripts or global installs of tools already present in the base image are used.",
    "status": "OK"
  },
  "registry_compliant": {
    "explanation": "The Dockerfile uses an allowed public.ecr.aws Olympus base image (public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest).",
    "status": "OK"
  },
  "repository_setup": {
    "explanation": "WORKDIR /app is used and the repository files are copied into the image via COPY . .. The Dockerfile does not clone the repo and does not only copy built artifacts.",
    "status": "OK"
  },
  "security_safety": {
    "explanation": "The only external download is a JDK tarball from GitHub; it is verified with a pinned sha256 checksum before extraction (good practice). There are no obfuscated commands, no docker.sock mounts, no hardcoded secrets, and no calls to untrusted install scripts piped to sh. Overall secure with the noted sha verification.",
    "status": "OK"
  },
  "user_creation_compatible": {
    "explanation": "No user or group is created in the Dockerfile, which is acceptable under the rubric.",
    "status": "OK"
  },
  "version_pinning": {
    "explanation": "Mostly OK: the JDK tarball download is pinned to a specific release and verified with a sha256; maven artifact dependency:get commands specify explicit artifact versions. WARNING: the Dockerfile checks the Maven wrapper with ./mvnw --version but then uses the system mvn binary for the actual build, which can result in a different, unpinned Maven version being used during build (potentially reducing reproducibility). Recommended: use the repository's Maven wrapper (./mvnw) for all Maven invocations or explicitly pin the Maven version used by the system mvn in the Dockerfile/image. Relevant lines:\n\nRUN ./mvnw -B -ntp --version\n\nRUN set -eux; \\\n    mkdir -p /opt/.m2/repository; \\\n    mvn -B -ntp -Dmaven.repo.local=/opt/.m2/repository -Dlicense.skip=true -DskipTests clean install; \\\n",
    "status": "warning"
  }
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
    "stars": 7669
  },
  "warnings": [
    "License could not be recognized — proceed with caution; confirm it is a permitted license (MIT, Apache-2.0, BSD-2/3-Clause, ISC, 0BSD, Unlicense, or CC0) or the submission may be rejected in review"
  ]
}
```
