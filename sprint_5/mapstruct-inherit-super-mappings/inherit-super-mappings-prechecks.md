**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥40 messages, ≥200 LOC

This task numbers: Median files: 35, messages: 140, LOC: 1322

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "171459f60c3d7f4f0628aac3c0a69de7cc22648b5c0ed2367bd2abb64af59154",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Adds support for methods mapping a bean to a Map: detects such methods, builds a BeanToMapMappingMethod with entries per readable property or explicit mappings, handles nulls, conditions, defaults, and instantiates appropriate Map types with new codegen templates.",
      "confidence": 0.96,
      "contentAuthoredAt": 1783680273814,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "The submission adds a new @BeanMapping option (inheritSuperMappings) and compiler-time logic to collect and rebind property-level @Mapping annotations from overridden mapper methods, including conflict detection and precedence rules.",
        "The candidate implements an entirely new mapping mode: mapping a single bean source to a Map result, with detection in SourceMethod, integration in MapperCreationProcessor, new model classes (BeanToMapMappingMethod/BeanToMapEntry), and new FreeMarker templates for code generation.",
        "The submission’s behavior concerns inheritance resolution across type hierarchies, parameter rebinding in source paths, flattening (target = \".\") accumulation, and error reporting for ambiguous/incomparable overridden declarations; the candidate’s behavior concerns emitting map entries for readable properties, explicit key mappings, null/condition handling, defaults, and instantiation of result map types.",
        "Surfaces modified are disjoint in purpose: submission modifies BeanMapping API, BeanMappingOptions, MappingOptions, MethodRetrievalProcessor, and Message for inheritance-related diagnostics; candidate modifies SourceMethod, MapperCreationProcessor, adds new model classes/templates, and Message for bean-to-map diagnostics."
      ],
      "one_liner": "Both extend MapStruct’s mapping capabilities, but one adds inheritance of property-level mappings from overridden methods, while the other introduces bean-to-Map mapping support with code generation.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both patches are in the same repository and touch MapStruct’s mapping processor, they target different features at different layers. The submission implements a new configuration option and the inheritance algorithm for property mappings from super methods; the candidate adds a new mapping method kind (bean-to-Map) with dedicated model and templates. There is no purpose-matched modified surface, shared API, or shared behavior, so they teach different debugging lessons.",
      "similarity": 0.6142189386920992,
      "submission_summary": "Introduces a BeanMapping.inheritSuperMappings option and processing logic to inherit and rebind property-level mappings from overridden mapper methods, resolve most-specific conflicts, accumulate flattening targets, and emit diagnostics for missing/ambiguous inheritance.",
      "title": "Bean to Map Mapping Methods",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Introduces Mapping.sources[] and extends the processor to map one target from multiple ordered source paths via a user-defined multi-parameter method, adding ordered parameter binding, multi-source resolution, validations, and template updates to generate correct calls.",
      "confidence": 0.93,
      "contentAuthoredAt": 1784695960565,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds a new BeanMapping option (inheritSuperMappings) that inherits property-level @Mapping declarations from overridden mapper methods, with precedence, parameter-path rebinding, and conflict diagnostics; the candidate adds a new Mapping option (sources[]) to map a single target from multiple ordered source paths via a user-defined multi-parameter method.",
        "Submission’s core behavior hangs on override discovery across generic/transitive supertypes and rebinding leading source path segments to corresponding overriding parameters; the candidate’s core behavior is ordered parameter binding and method selection for multi-source mapping, with strict mutual-exclusion rules and prohibition on nested/flattening targets.",
        "Submission modifies MethodRetrievalProcessor to collect and reconcile inherited mappings; the candidate modifies selection and resolution layers (SelectionContext, TypeSelector, MappingResolverImpl, PropertyMapping) to support multiple SourceRHS and ordered binding, plus template updates to pass target types of multi-arg calls.",
        "Submission validates presence/ambiguity of inherited mappings and adds messages for no overridden method/ambiguous super mappings; the candidate adds a different set of validations and messages specific to multi-source constraints (minimum two sources, exclusivity with other attributes, nested target disallowed, mapping-not-found for ordered sources)."
      ],
      "one_liner": "Both extend MapStruct’s annotations and processor, but one adds inheritance of super-method property mappings, while the other adds ordered multi-source inputs for a single property mapping method.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both patches touch shared infrastructure (e.g., MethodRetrievalProcessor, Message), they do so for unrelated features: super-mapping inheritance versus ordered multi-source mapping. The modified APIs and observable behaviors differ materially: one controls inheritance from overridden methods via @BeanMapping; the other enables mapping a single target from multiple sources via @Mapping with ordered binding and new resolution rules. These teach different debugging lessons and should co‑exist.",
      "similarity": 0.6118146777153015,
      "submission_summary": "Introduces BeanMapping.inheritSuperMappings, parses it, and in method retrieval collects and reconciles property mappings from overridden mapping methods (including parameter-path rebinding and most-specific resolution), with new diagnostics for no overridden method and ambiguous inherited mappings.",
      "title": "Ordered Multi-Source Mapping Methods",
      "verdict": "distinct"
    },
    {
      "authorUsername": "igee",
      "candidate_summary": "Implements mapping support for Guava immutable collections and maps by generating builder-based mappings, enforcing sorted-type comparability, disallowing immutable @MappingTarget, and adding Type detection and diagnostics; integrates via MapperCreationProcessor and new model/builders for immutable containers.",
      "confidence": 0.95,
      "contentAuthoredAt": 1783929834023,
      "evalStatus": "ok",
      "evidence_gaps": [
        "Candidate patch is truncated, so some files/templates are not fully visible, though the visible changes suffice to identify the feature and surfaces."
      ],
      "isOlder": true,
      "meaningful_differences": [
        "Submission introduces a new BeanMapping option (inheritSuperMappings) and processor logic to discover overridden methods, rebind source parameter prefixes, and merge/resolve property-level @Mapping declarations across a type hierarchy.",
        "Submission adds compile-time diagnostics for missing overridden mapping methods and ambiguous competing inherited mappings, and does not alter collection/map mapping behaviors.",
        "Candidate implements mapping support for Guava immutable containers (ImmutableList/Set/Map/Multimap/Table, etc.), including builder-based construction, sorted-type comparability checks, lifecycle constraints (no @MappingTarget), unsupported-source diagnostics, and extensive model/builder/template changes.",
        "Candidate extends Type introspection for Guava types and modifies mapping method builders and MapperCreationProcessor to select and generate the appropriate immutable mapping implementations; it does not modify method-override inheritance."
      ],
      "one_liner": "One adds a @BeanMapping option to inherit property-level mappings from overridden methods; the other adds end-to-end support for mapping to Guava’s immutable collection and map types.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Although both patches live in the same repository, they target unrelated features at different purpose-matched surfaces. The submission adds a new BeanMapping attribute and override-based property-mapping inheritance in MethodRetrievalProcessor; the candidate implements Guava immutable collection/map targets with new model classes, Type checks, diagnostics, and generation templates. Any shared scaffolding (e.g., adding new Message enums) is generic infrastructure, not a shared feature, so these teach different debugging lessons.",
      "similarity": 0.5466411260949953,
      "submission_summary": "Adds boolean inheritSuperMappings() to @BeanMapping and wires the processor to collect property-level @Mapping declarations from overridden mapper methods, rebind leading source parameter segments, and merge/resolve them with local mappings; emits diagnostics for no overridden method and ambiguous competing inherited targets.",
      "title": "immutable collections",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Introduces a Replace Inheritance with Delegation refactoring in a Java language server, wiring it via executeCommand and a code action, and implementing AST-based edits to remove extends, insert a delegate field, forward members, and rewrite references while declining unsafe transformations.",
      "confidence": 0.99,
      "contentAuthoredAt": 1782539866774,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: MapStruct annotation processor vs. a Java language server (LSP) tool.",
        "Submission adds a new @BeanMapping option (inheritSuperMappings) and compiler-time processing to inherit property-level mappings from overridden methods; candidate implements a source-to-source refactoring (Replace Inheritance with Delegation) with code actions and executeCommand plumbing.",
        "Submission’s modified surfaces are MapStruct core annotation and processor internals (BeanMapping.java, BeanMappingOptions, MappingOptions, MethodRetrievalProcessor, Message), while the candidate modifies LSP server wiring and adds rewrite logic (JavaLanguageServer, LSP request handling, CodeActionProvider, ExecuteCommandParams, and rewrite classes).",
        "Behavioral goals diverge: inheritance of mapping metadata with precedence/ambiguity rules vs. transforming class inheritance to field delegation with behavior-preservation checks.",
        "Scope and lifecycle differ: compile-time annotation modeling and error reporting versus interactive refactoring producing WorkspaceEdits."
      ],
      "one_liner": "They each add a new capability to different Java tools: one extends MapStruct’s bean-mapping annotation processing, the other adds a refactoring to a Java language server.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "There is no purpose-matched surface or behavior overlap. The submission augments MapStruct’s annotation processing with a new BeanMapping option to inherit super mappings, including complex resolution, rebinding, and diagnostics. The candidate adds an LSP refactoring that rewrites Java source from inheritance to delegation, including command registration and code action exposure. Any shared vocabulary around “inheritance” is conceptual, not a shared task or surface.",
      "similarity": 0.5370141267776489,
      "submission_summary": "Adds a new BeanMapping attribute inheritSuperMappings and extends the MapStruct processor to inherit property-level @Mapping declarations from overridden mapper methods with precedence, source-path rebinding, and ambiguity/error diagnostics. Integrates into MethodRetrievalProcessor and related option classes without inheriting other method-level options.",
      "title": "Replace Inheritance with Delegation",
      "verdict": "distinct"
    },
    {
      "authorUsername": "samasimo",
      "candidate_summary": "Extends JavaParser with default methods on resolved declarations and a MethodOverrideLogic class to compute overriding/hiding, subsignature and override-equivalence, return-type substitutability, throws-clause compatibility, bridge-method needs, root/overridden/overriding methods, and unimplemented abstract methods, adapting generics and erasure per the JLS.",
      "confidence": 0.96,
      "contentAuthoredAt": 1781917027180,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: MapStruct code generation vs. JavaParser symbol resolution.",
        "Submission modifies MapStruct’s BeanMapping annotation and its processor to inherit and merge property mappings from overridden mapper methods, including parameter-name rebinding and ambiguity diagnostics; the candidate introduces override/hiding analysis APIs and logic for resolved methods/types, unrelated to mapping inheritance.",
        "Submission’s behavior targets mapping configuration resolution during annotation processing and code generation; the candidate targets JLS-conformant method relationship computation (subsignature, erasure, throws compatibility, bridge methods), with no mapping semantics.",
        "Submission adds user-facing diagnostics specific to mapping inheritance conflicts or missing overridden mapping methods; the candidate adds programmatic queries like getOverriddenMethods(), isCompatibleOverrideOf(), and getUnimplementedAbstractMethods()."
      ],
      "one_liner": "One adds a MapStruct annotation option to inherit property-level mappings from overridden mapper methods; the other adds JavaParser APIs and logic to analyze method override/hiding and related JLS relationships.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "There is no purpose-matched surface overlap: the submission augments MapStruct’s @BeanMapping and its processing pipeline to inherit and combine property mappings from overridden mapper methods, while the candidate adds JavaParser APIs and logic to compute method override/hiding relationships per the JLS. Any conceptual commonality around ‘overridden methods’ is generic and infrastructure-level, not the same task or behavior. They teach different debugging lessons in different repos.",
      "similarity": 0.5270963907241821,
      "submission_summary": "Adds inheritSuperMappings to @BeanMapping and extends the MapStruct processor to collect property mappings from overridden mapper methods, rebind leading source segments to overriding parameters, choose the most specific declarations, accumulate target=\".\" flattening, and report ambiguity or missing-super-method errors.",
      "title": "Method override/hiding relationships + override-equivalence + erasure",
      "verdict": "distinct"
    }
  ],
  "reusedFromPriorRun": true
}
```

---

**Test Fairness**

Coverage Suggestions (2) - Not Blockers

Advisory only — these don't affect the check result.

Other method-level BeanMapping options
Add one test for another non-copied method-level option such as `qualifiedByName`, `resultType`, or `nullValueCheckStrategy`; current negative coverage demonstrates `ignoreByDefault` and `nullValueMappingStrategy` only.

Composed mapping interactions
Add a composed inherited mapping that participates in same-target precedence or an incomparable-branch conflict, to verify compositions are expanded before the same conflict/precedence rules are applied.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Other method-level BeanMapping options",
      "suggestion": "Add one test for another non-copied method-level option such as `qualifiedByName`, `resultType`, or `nullValueCheckStrategy`; current negative coverage demonstrates `ignoreByDefault` and `nullValueMappingStrategy` only."
    },
    {
      "area": "Composed mapping interactions",
      "suggestion": "Add a composed inherited mapping that participates in same-target precedence or an incomparable-branch conflict, to verify compositions are expanded before the same conflict/precedence rules are applied."
    }
  ],
  "error": "",
  "executionTimeSeconds": 436.50058,
  "message": "All hidden tests are fair.",
  "overall": "PASS — all 54 hidden tests are fair. The prompt is unusually detailed and directly states nearly every new-feature expectation, including defaults, conflict diagnostics, hierarchy resolution, source-path interpretation, flattening, configuration inheritance, and method-option boundaries. The few assertions that rely on existing MapStruct option semantics or exact diagnostics are concretely supported by visible annotation documentation and processor constants; Java override edge cases follow standard JLS semantics. Tests are deterministic and user-visible. Diagnostic regexes generally pin required semantic tokens rather than prose, and the one exact message is backed by a visible stable message constant. A few cases are redundant or shallow, but none are unfair or improperly coupled to hidden internals.",
  "taskSummary": "Add `BeanMapping.inheritSuperMappings()` with default `false`. When true, an overriding mapping method must collect complete property-level `@Mapping` declarations (including composed mappings) from every actually overridden interface/class method, resolve generic and transitive hierarchies, prefer the current method and then the most-specific ancestor per target path, merge disjoint targets, diagnose same-target mappings from incomparable branches while naming the target and declaring types, deduplicate shared ancestors, and treat `target=\".\"` mappings as accumulative. Source paths must be interpreted against the overridden signature first and only parameter-leading segments rebound by full signature position; property-leading paths retain their old meaning and Java expression text is unchanged. The option is erroneous without an overridden mapping method, an unannotated overridden mapping method still qualifies, explicit/automatic configuration inheritance only fills missing targets, method-level options are not implicitly copied, and false preserves existing behavior.",
  "tests": [
    {
      "evidence": "The prompt explicitly sets the default to false, says behavior remains unchanged when false, and limits inheritance to when the option is enabled; therefore the parent's `first <- alpha` is absent while the local `second <- beta` remains.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.explicitFalseDisablesSuperMappingInheritance",
      "qualityCheck": "Deterministic behavioral check with both the omitted inherited value and retained local value asserted.",
      "verifies": "The mapped target's `first` is null and `second` is exactly `\"beta\"` when `inheritSuperMappings=false`."
    },
    {
      "evidence": "The prompt explicitly requires `boolean inheritSuperMappings() default false` and unchanged behavior when false.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.beanMappingOptionDefaultsToFalseWhenOmitted",
      "qualityCheck": "Good API/default test; reflection directly pins the required annotation default and runtime assertions pin its effect.",
      "verifies": "With the option omitted, `first` is null, `second` is `\"beta\"`, and reflection reports the annotation member's default value as boolean false."
    },
    {
      "evidence": "The prompt explicitly says inherited property-level declarations include mappings/ignores and that an `ignore=true` declaration participates in target precedence. `Mapping.ignore()` is defined as suppressing propagation in `core/src/main/java/org/mapstruct/Mapping.java:301-313`.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.inheritedIgnoreDeclarationSuppressesAutomaticMapping",
      "qualityCheck": "Directly distinguishes inherited ignore behavior from ordinary automatic name mapping.",
      "verifies": "An inherited `@Mapping(target=\"first\", ignore=true)` leaves `first` null despite a same-named source property, while the local `second` mapping yields `\"explicit\"`."
    },
    {
      "evidence": "The prompt explicitly says to rebind a leading parameter segment by the same signature position and preserve an empty remainder, including same-typed renamed parameters.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.wholeSourceParameterReferenceRebindsByPosition",
      "qualityCheck": "Clear two-position check; no ordering or environment dependence.",
      "verifies": "Inherited whole-parameter mappings from the first and second String parameters produce `first=\"left\"` and `second=\"right\"` after both parameters are renamed."
    },
    {
      "evidence": "The prompt says mappings for different target paths are combined; `details.first` and `details.second` are distinct paths.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.nestedSiblingTargetPathsRemainIndependent",
      "qualityCheck": "Useful boundary check that target identity is the complete nested path, not merely its first segment.",
      "verifies": "The result has `details.first=\"alpha\"` from the inherited mapping and `details.second=\"beta\"` from the current mapping."
    },
    {
      "evidence": "The prompt explicitly requires a compilation error identifying the target and declaring mapper types for competing incomparable branches, \"even where those branches declare the same thing.\"",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.identicalMappingsFromIncomparableBranchesConflict",
      "qualityCheck": "Regex checks required semantic tokens without pinning punctuation or word order; JDK-only selection reduces diagnostic variance.",
      "verifies": "JDK compilation fails with an ERROR attributed to `IdenticalConflictMapperK7p4`, and its message contains target `first` plus both declaring types `IdenticalLeftK7p4` and `IdenticalRightK7p4`, even though both branches map the same source."
    },
    {
      "evidence": "The prompt requires a whole path segment match and says a segment resolving as a property keeps its meaning.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.unqualifiedPropertySharingParameterPrefixIsNotRebound",
      "qualityCheck": "Good lexical-boundary regression test.",
      "verifies": "Inherited source path `sourceValue` reads that property and produces `first=\"boundary\"`; it is not altered merely because it starts with the characters `source`."
    },
    {
      "evidence": "The prompt explicitly says `target=\".\"` flattening declarations accumulate whether inherited or declared on the current method.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.localAndInheritedFlatteningDeclarationsAccumulate",
      "qualityCheck": "Deterministic and checks both accumulated contributions.",
      "verifies": "A parent flattening of `left` and a current-method flattening of `right` both apply, yielding `first=\"left\"` and `second=\"right\"`."
    },
    {
      "evidence": "The prompt explicitly says an overridden mapping method still counts when it declares no property mappings of its own.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.overriddenUnannotatedBeanMappingMethodIsAccepted",
      "qualityCheck": "Fair but shallow: the non-null assertion mainly acts as a compile-success smoke test.",
      "verifies": "Compilation succeeds and invoking the mapper returns a non-null target when the overridden method has no property mappings."
    },
    {
      "evidence": "The prompt requires inheritance of property-level `@Mapping` declarations. The complete forward copy retains constant, source, default expression/value, ignore, formatting, selection/qualifier parameters, and `dependsOn` in `processor/src/main/java/org/mapstruct/ap/internal/model/source/MappingOptions.java:520-549`; constant and qualifier/default semantics are documented at `core/src/main/java/org/mapstruct/Mapping.java:220-242` and `core/src/main/java/org/mapstruct/Mapping.java:315-351`.",
      "fairness": "Repo-discoverable",
      "name": "InheritSuperMappingsAdditionalK7p4Test.inheritedMappingRetainsConstantDefaultAndQualifierOptions",
      "qualityCheck": "Strong check that inheritance copies the declaration, not only target/source strings.",
      "verifies": "Inherited mapping options produce exactly `first=\"inherited-constant\"`, `second=\"decorated:alpha\"`, and, for null beta, `third=\"decorated:inherited-default\"`."
    },
    {
      "evidence": "The prompt requires complete property-level declaration inheritance and verbatim Java expression text. `conditionExpression` controls whether assignment occurs at `core/src/main/java/org/mapstruct/Mapping.java:377-407`, and forward inheritance copies it at `processor/src/main/java/org/mapstruct/ap/internal/model/source/MappingOptions.java:520-549`.",
      "fairness": "Repo-discoverable",
      "name": "InheritSuperMappingsAdditionalK7p4Test.inheritedMappingRetainsConditionExpression",
      "qualityCheck": "Checks both true and false branches and is deterministic.",
      "verifies": "For alpha `\"include-value\"`, `first` is that value; for alpha `\"skip-value\"`, `first` remains null under the inherited condition expression."
    },
    {
      "evidence": "The prompt covers overridden mapper-interface methods. Under JLS §9.4.1, an overriding interface method may redeclare an inherited default method; MapStruct visibly recognizes default methods via `processor/src/main/java/org/mapstruct/ap/internal/model/source/SourceMethod.java:558-560`.",
      "fairness": "Standard external semantics",
      "name": "InheritSuperMappingsAdditionalK7p4Test.overriddenDefaultMethodMappingsAreInherited",
      "qualityCheck": "Good Java-override edge case; no implementation-detail assertion.",
      "verifies": "An abstract child redeclaration overriding an interface default method inherits its mapping and returns `first=\"alpha\"` rather than executing/inheriting the default body's null result."
    },
    {
      "evidence": "The prompt requires inheritance from overridden methods; covariant return substitution is standard Java override semantics under JLS §8.4.5 and §9.4.1.",
      "fairness": "Standard external semantics",
      "name": "InheritSuperMappingsAdditionalK7p4Test.covariantOverrideMappingsAreInherited",
      "qualityCheck": "Focused and deterministic.",
      "verifies": "A covariant child return type still forms an override and the `CovariantTargetK7p4` result has `first=\"alpha\"`."
    },
    {
      "evidence": "The prompt applies to bean-mapping methods that override mapping methods without restricting creation versus update methods; the repository documents update configuration inheritance as a typical use at `core/src/main/java/org/mapstruct/InheritConfiguration.java:25-40`.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.updateMethodMappingsAreInherited",
      "qualityCheck": "Covers an important mapping-method integration point.",
      "verifies": "Calling the overriding void update method mutates the supplied target so `first=\"alpha\"`."
    },
    {
      "evidence": "The prompt explicitly says parameter-vs-property meaning is decided as the overridden method reads the path, then a parameter-leading segment is rebound; it must not be reinterpreted against the overriding signature.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.qualifiedParameterSegmentIsReboundBeforeMapKeyResolution",
      "qualityCheck": "Excellent adversarial fixture that distinguishes resolution order.",
      "verifies": "For inherited `source.entry.value`, the old leading `source` segment is treated as the source parameter and rebound before map-key interpretation, yielding `first=\"expected\"` rather than following map key `source` to `\"wrong\"`."
    },
    {
      "evidence": "The prompt requires inherited mappings to integrate with explicit configuration inheritance and shared contributions to apply once. Existing configuration initialization recursively initializes the template before copying it (`processor/src/main/java/org/mapstruct/ap/internal/processor/MapperCreationProcessor.java:643-653`), and forward inheritance copies the template's effective mappings (`processor/src/main/java/org/mapstruct/ap/internal/model/source/MappingMethodOptions.java:213-239`).",
      "fairness": "Repo-discoverable",
      "name": "InheritSuperMappingsAdditionalK7p4Test.inheritedFlatteningIsAppliedOnceWhenTheMethodIsAlsoAConfigurationTemplate",
      "qualityCheck": "Fair integration regression; values prove availability, while successful compilation guards against duplicate flattening.",
      "verifies": "Both the overriding `map` method and `copy`, which explicitly inherits configuration from `map`, produce `first=\"flattened\"` from the inherited flattening, without duplicate-application failure."
    },
    {
      "evidence": "The prompt explicitly says rebinding uses the same position in the full signature.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsAdditionalK7p4Test.rebindingFollowsTheFullSignaturePosition",
      "qualityCheck": "Precisely catches implementations that index only source parameters and skip context/mapping-target positions.",
      "verifies": "A mapping from the parent's third formal parameter is rebound to the child's third formal parameter and yields `first=\"expected\"`, not the newly ordinary source parameter at index two containing `\"wrong\"`."
    },
    {
      "evidence": "The prompt requires the property-level declaration to be inherited. `Mapping.dependsOn` explicitly requires generated setters to be ordered to satisfy dependencies at `core/src/main/java/org/mapstruct/Mapping.java:412-422`, and forward inheritance retains `dependsOn` at `processor/src/main/java/org/mapstruct/ap/internal/model/source/MappingOptions.java:520-549`.",
      "fairness": "Repo-discoverable",
      "name": "InheritSuperMappingsAdditionalK7p4Test.inheritedDependsOnPreservesAssignmentOrder",
      "qualityCheck": "Good observable check of a non-value mapping option; all three co-assertions are meaningful.",
      "verifies": "The result has `first=\"alpha\"`, `second=\"beta\"`, and the target records that `first` was assigned before `second`."
    },
    {
      "evidence": "Complete `@Mapping` declarations must be inherited. Default-expression-on-null behavior is documented at `core/src/main/java/org/mapstruct/Mapping.java:267-297`, and forward inheritance copies `defaultJavaExpression` at `processor/src/main/java/org/mapstruct/ap/internal/model/source/MappingOptions.java:520-549`.",
      "fairness": "Repo-discoverable",
      "name": "InheritSuperMappingsAdditionalK7p4Test.inheritedDefaultExpressionIsRetained",
      "qualityCheck": "Focused, deterministic property-option test.",
      "verifies": "When the inherited source property is null, `first` is exactly `\"fallback-expression\"`."
    },
    {
      "evidence": "The prompt explicitly says using the option on a method that overrides no mapping method is a compilation error.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsErrorsK7p4Test.optionWithoutAnOverriddenMethodIsRejected",
      "qualityCheck": "Fair and intentionally message-agnostic.",
      "verifies": "Compilation fails with an ERROR attributed to `NoSuperMapperK7p4`; no exact message is required."
    },
    {
      "evidence": "The prompt explicitly requires a same-target incomparable-branch compilation error naming the target and declaring mapper types.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsErrorsK7p4Test.incomparableBranchesCannotMapTheSameTarget",
      "qualityCheck": "Semantic regex is robust to prose/order changes.",
      "verifies": "JDK compilation fails with an ERROR on `ConflictMapperK7p4`, and the diagnostic contains `first`, `ConflictLeftK7p4`, and `ConflictRightK7p4`."
    },
    {
      "evidence": "The prompt defines precedence/conflicts by target path and requires target/type identification; `details.first` is the concrete competing path.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsErrorsK7p4Test.incomparableBranchesCannotMapTheSameNestedTargetPath",
      "qualityCheck": "Useful nested-path counterpart to the top-level conflict test.",
      "verifies": "JDK compilation fails with an ERROR on `NestedConflictMapperK7p4`, and the diagnostic contains exact nested path `details.first` plus both branch type names."
    },
    {
      "evidence": "The prompt says a conflict identifies the target and the declaring mapper types; for a three-way competition, all three are the declaring types involved.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsErrorsK7p4Test.everyCompetingBranchIsNamedInTheConflictDiagnostic",
      "qualityCheck": "Non-brittle token matching; meaningfully checks complete conflict reporting.",
      "verifies": "JDK compilation fails with an ERROR on `ThreeWayConflictMapperK7p4`, and one diagnostic contains `first` and all three declaring types `ThreeWayAlphaK7p4`, `ThreeWayBetaK7p4`, and `ThreeWayGammaK7p4`."
    },
    {
      "evidence": "The prompt mandates an error for incomparable same-target mappings and provides no declaration-order winner; reversing order cannot alter that rule.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsErrorsK7p4Test.branchDeclarationOrderDoesNotChooseAConflictingMapping",
      "qualityCheck": "Somewhat redundant with the basic conflict test, but useful against traversal-order bugs.",
      "verifies": "Reversing interface order still causes JDK compilation failure, with an ERROR containing `first` and both branch names."
    },
    {
      "evidence": "The prompt says \"overrides\". Under JLS §8.4.8.1 and §9.4.1, an overload with a different parameter signature is not overridden.",
      "fairness": "Standard external semantics",
      "name": "InheritSuperMappingsErrorsK7p4Test.unrelatedSameNamedOverloadIsNotASuperMappingMethod",
      "qualityCheck": "Fair compile-only check without brittle message matching.",
      "verifies": "A same-named parent method with an incompatible String parameter does not count as overridden; compilation fails with an ERROR on the child mapper."
    },
    {
      "evidence": "The prompt relies on Java override relationships; private methods are not inherited or overridden under JLS §9.4.1.",
      "fairness": "Standard external semantics",
      "name": "InheritSuperMappingsErrorsK7p4Test.privateSameNamedMethodIsNotASuperMappingMethod",
      "qualityCheck": "Appropriate language-semantics boundary test.",
      "verifies": "A private interface method does not count as an overridden mapping method; compilation fails with an ERROR on the child mapper."
    },
    {
      "evidence": "The prompt relies on Java override relationships; an inaccessible package-private method is not inherited/overridden across packages under JLS §8.4.8.1.",
      "fairness": "Standard external semantics",
      "name": "InheritSuperMappingsErrorsK7p4Test.inaccessiblePackagePrivateSuperMethodIsNotASuperMappingMethod",
      "qualityCheck": "Fair and message-agnostic.",
      "verifies": "A package-private superclass method from another package does not count as overridden; compilation fails with an ERROR on the child mapper."
    },
    {
      "evidence": "The prompt explicitly says Java expression strings remain verbatim. Keeping `source.getAlpha()` verbatim makes `source` unresolved in the generated overriding method.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsErrorsK7p4Test.rawJavaExpressionIsNotRewrittenForRenamedParameters",
      "qualityCheck": "The regex is broad but robust; it validates non-rewriting through the expected compile failure rather than generated-source internals.",
      "verifies": "Compilation fails and an ERROR diagnostic contains `source` when an inherited expression still references old parameter name `source` while the override parameter is `current`."
    },
    {
      "evidence": "The prompt requires rebinding old parameter `source` to `current`; the repository's exact normal diagnostic template is `The type of parameter \"%s\" has no property named \"%s\".` at `processor/src/main/java/org/mapstruct/ap/internal/util/Message.java:92`.",
      "fairness": "Repo-discoverable",
      "name": "InheritSuperMappingsErrorsK7p4Test.inheritedInvalidSourceUsesNormalPropertyDiagnostic",
      "qualityCheck": "Exact message matching is justified by a visible stable message constant and verifies normal diagnostic reuse.",
      "verifies": "Compilation fails with an ERROR on `InvalidInheritedSourceMapperK7p4` whose message is exactly `The type of parameter \"current\" has no property named \"absent\".`"
    },
    {
      "evidence": "The prompt states the option defaults false and behavior remains unchanged when false; the assertions simultaneously show no parent inheritance and preservation of existing local/automatic mapping behavior.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.defaultFlagDoesNotInheritParentMappings",
      "qualityCheck": "Good backward-compatibility test with all co-assertions relevant.",
      "verifies": "With no new option enabled, `first` is null, local `second` is `\"b\"`, and ordinary automatic same-name mapping still sets `natural=\"n\"`."
    },
    {
      "evidence": "The prompt's primary requirement is inheriting property-level declarations on an overriding method while retaining current declarations.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.directOverrideInheritsPropertyMappings",
      "qualityCheck": "Core happy-path test; deterministic.",
      "verifies": "A direct override produces `first=\"a\"` from the parent mapping and `second=\"b\"` from the current mapping."
    },
    {
      "evidence": "The prompt explicitly says a mapping declared on the current method wins for the same target path.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.currentMappingWinsForTheSameTarget",
      "qualityCheck": "Directly isolates precedence.",
      "verifies": "For competing parent `first <- alpha` and current `first <- beta`, the result's `first` is exactly `\"current\"`."
    },
    {
      "evidence": "The prompt explicitly says a current mapping or `ignore=true` wins for the same target path.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.currentIgnoreWinsForTheSameTarget",
      "qualityCheck": "Checks both the winning ignore and an unaffected local mapping.",
      "verifies": "A current ignore leaves `first` null despite the parent mapping, while current `second <- beta` yields `\"kept\"`."
    },
    {
      "evidence": "The prompt explicitly requires generic/transitive supertype resolution, most-specific same-target precedence, and combining different targets.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.genericTransitiveHierarchyUsesMostSpecificDeclaration",
      "qualityCheck": "Strong multi-assertion integration test.",
      "verifies": "Across generic root/middle interfaces, `first=\"middle\"` comes from the nearer declaration, `second=\"nested-second\"` comes from the middle declaration, and `third=\"root-third\"` comes from the root declaration."
    },
    {
      "evidence": "The prompt explicitly requires positional rebinding even for same-typed renamed parameters and preserving the remainder of the path.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.sameTypedRenamedParametersRebindByPosition",
      "qualityCheck": "Thoroughly distinguishes positional rebinding from type/name heuristics.",
      "verifies": "After two same-typed parameters are renamed, inherited paths yield `first=\"left-alpha\"` from position one, `second=\"right-beta\"` from position two, and `third=\"left-nested\"` from the remainder of a nested path on position one."
    },
    {
      "evidence": "The prompt explicitly gives this case: an unqualified property of a lone source parameter remains a property even when spelled like that parameter.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.unqualifiedPropertyNamedLikeTheParameterKeepsItsMeaning",
      "qualityCheck": "Exact ambiguity case from the specification.",
      "verifies": "Inherited unqualified `source=\"origin\"` reads the lone source bean's `origin` property and yields `first=\"property\"`; local beta mapping yields `second=\"beta\"`."
    },
    {
      "evidence": "The prompt says meaning is fixed as the overridden method reads the path; a leading segment resolved there as a parameter is rebound and the remainder retained.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.qualifiedSegmentNamedLikeTheParameterIsReboundWhenAFurtherPathFollows",
      "qualityCheck": "Adversarial values clearly separate the two interpretations.",
      "verifies": "Inherited `origin.value` is read as old parameter `origin` plus property `value`, then rebound, producing `first=\"parameter-value\"` rather than using the overriding bean's `origin` property."
    },
    {
      "evidence": "The prompt explicitly says a leading segment that resolves as a property in the overridden method keeps that meaning and is not reread against the override.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.qualifiedSegmentNamedLikeTheParameterKeepsItsMeaningWhenTheWholePathResolves",
      "qualityCheck": "Complements the prior ambiguity test with the opposite old-signature resolution.",
      "verifies": "Inherited `origin.inner` produces `first=\"nested-inner\"` from the source bean's `origin.inner` property path, not `\"direct-inner\"` from rebinding `origin` as a parameter."
    },
    {
      "evidence": "The prompt expressly allows the retained remainder after parameter rebinding to be empty.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.loneWholeSourceReferenceRebindsWhenNoSameNamedPropertyExists",
      "qualityCheck": "Simple whole-source edge case.",
      "verifies": "Inherited whole-parameter source `value` on a single String parameter, renamed to `current`, produces `first=\"whole-value\"`."
    },
    {
      "evidence": "The prompt says the most-specific overridden declaration wins for the same target and different targets combine; ignores are explicitly included in precedence.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.nearerInheritedIgnoreWinsOverARootDeclarationForTheSameTarget",
      "qualityCheck": "Checks that shadowing one target does not discard unrelated root mappings.",
      "verifies": "The nearer inherited ignore wins over the root's mapping so `first` is null, while the root's disjoint `third` mapping still yields `\"gamma\"`."
    },
    {
      "evidence": "The prompt explicitly says disjoint targets from incomparable branches combine and a shared ancestor contributes once.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.disjointDiamondBranchesCombineAndSharedRootContributesOnce",
      "qualityCheck": "Write-count assertion observably verifies deduplication rather than merely equal final values.",
      "verifies": "A diamond hierarchy yields `first=\"left\"`, `second=\"right\"`, `third=\"root\"`, and invokes the third-property setter exactly once."
    },
    {
      "evidence": "The prompt explicitly says the current mapping wins for the same target path; therefore the inherited branch competition is resolved before conflict reporting.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.currentMappingResolvesAnIncomparableBranchConflict",
      "qualityCheck": "Important interaction between local precedence and conflict detection.",
      "verifies": "A current-method mapping for disputed target `first` suppresses both inherited branch candidates and yields exactly `\"current\"` without compilation failure."
    },
    {
      "evidence": "The prompt explicitly gives current `ignore=true` the same-target precedence needed to resolve inherited competition.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.currentIgnoreResolvesAnIncomparableBranchConflict",
      "qualityCheck": "Checks both successful conflict suppression and an unaffected local mapping.",
      "verifies": "A current ignore for disputed `first` leaves it null and avoids the inherited branch conflict, while `second` is `\"right\"`."
    },
    {
      "evidence": "The prompt explicitly requires flattening declarations to accumulate and shared ancestor contributions to occur once.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.aSharedAncestorFlatteningIsAppliedOnceAndStillAccumulates",
      "qualityCheck": "Strong deduplication test using an observable write count.",
      "verifies": "Shared-root flattening supplies `first=\"left\"`, a branch flattening supplies `second=\"right\"`, and the first-property setter is called exactly once."
    },
    {
      "evidence": "The prompt explicitly says `target=\".\"` flattenings accumulate instead of competing as one target.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.flatteningsFromDifferentBranchesAccumulate",
      "qualityCheck": "Core flattening conflict exception is directly tested.",
      "verifies": "Two incomparable branch flattenings both apply, yielding `first=\"left\"` and `second=\"right\"` rather than a conflict on target `\".\"`."
    },
    {
      "evidence": "The prompt combines current same-target precedence with accumulation of flattening declarations; the flattening is retained but its expanded `first` loses to the explicit mapping.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.currentMappingWinsOverAnInheritedFlatteningWithoutDiscardingIt",
      "qualityCheck": "Precisely tests partial override of a flattening.",
      "verifies": "A current explicit mapping sets `first=\"declared-first\"` over the inherited flattening's `first`, while the same inherited flattening still supplies `second=\"flattened-second\"`."
    },
    {
      "evidence": "The prompt explicitly says inherited property mappings include mapping compositions.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.mappingCompositionOnParentIsInherited",
      "qualityCheck": "Focused composition coverage.",
      "verifies": "A parent mapping supplied through a composed annotation is inherited and produces `first=\"composed\"`."
    },
    {
      "evidence": "The prompt explicitly says existing explicit configuration inheritance fills only targets not supplied by current or inherited super mappings.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.explicitConfigurationInheritanceFillsAnUnmappedTarget",
      "qualityCheck": "Good precedence/integration test with both occupied and vacant targets.",
      "verifies": "With explicit `@InheritConfiguration`, inherited super mapping keeps `first=\"super\"` and configuration fills only missing `second=\"configuration\"` rather than replacing first with the template's gamma mapping."
    },
    {
      "evidence": "The prompt explicitly states the same fill-only rule for automatic configuration inheritance; the existing strategy is described at `core/src/main/java/org/mapstruct/MappingInheritanceStrategy.java:20-25`.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.automaticConfigurationInheritanceFillsAnUnmappedTarget",
      "qualityCheck": "Not redundant with explicit configuration because it exercises a distinct integration path.",
      "verifies": "Under `AUTO_INHERIT_FROM_CONFIG`, inherited super mapping keeps `first=\"super\"` and automatic configuration fills missing `second=\"configuration\"`."
    },
    {
      "evidence": "The prompt explicitly says property mappings are inherited without implicitly copying other method-level mapping options. `ignoreByDefault` is a `@BeanMapping` method option and its automatic-mapping effect is documented at `core/src/main/java/org/mapstruct/BeanMapping.java:140-149`.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.parentBeanMappingOptionsAreNotImplicitlyCopied",
      "qualityCheck": "Clear negative test for accidental whole-method option inheritance.",
      "verifies": "The parent's property mapping still gives `first=\"super\"`, but its method-level `ignoreByDefault=true` is not copied, so ordinary automatic mapping gives `natural=\"automatic\"`."
    },
    {
      "evidence": "The prompt forbids implicit copying of other method-level options. The child therefore uses the visible default `RETURN_NULL`, documented at `core/src/main/java/org/mapstruct/BeanMapping.java:92-100`, instead of the parent's `RETURN_DEFAULT`.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.parentNullValueMappingStrategyIsNotImplicitlyCopied",
      "qualityCheck": "Tests a second, semantically distinct method-level option and confirms property mapping inheritance still works.",
      "verifies": "Mapping null returns null rather than a default target, while a non-null source still inherits the property mapping and yields `first=\"super\"`."
    },
    {
      "evidence": "The prompt explicitly says Java expression strings remain verbatim; ordinary expression assignment semantics are documented at `core/src/main/java/org/mapstruct/Mapping.java:245-265`.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.rawJavaExpressionIsInheritedVerbatim",
      "qualityCheck": "Positive counterpart to the renamed-expression compile-failure test.",
      "verifies": "An inherited expression `source.getAlpha().toUpperCase()` produces exactly `first=\"MIXED\"` when the overriding parameter retains the name `source`."
    },
    {
      "evidence": "The prompt explicitly covers methods overriding mapper interface or superclass methods.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.abstractSuperclassMappingIsInherited",
      "qualityCheck": "Core superclass path, deterministic.",
      "verifies": "An abstract class override inherits its superclass mapping and produces `first=\"superclass\"`."
    },
    {
      "evidence": "The prompt explicitly requires generic/transitive superclass resolution, most-specific same-target precedence, and combination of disjoint targets.",
      "fairness": "Prompt-stated",
      "name": "InheritSuperMappingsK7p4Test.genericSuperclassChainUsesMostSpecificDeclaration",
      "qualityCheck": "Complements generic-interface coverage with generic classes.",
      "verifies": "Across a generic abstract superclass chain, `first=\"middle\"` comes from the nearer override and `third=\"root-third\"` remains from the generic root."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Dockerfile guidelines**

Status: WARNING

WARNING: Inconsistent mvn usage / unpinned Maven version risk:
The Dockerfile invokes the Maven wrapper to check the wrapper version and then uses the system 'mvn' for builds. Relevant lines:
  RUN ./mvnw -B -ntp --version
  RUN set -eux; \
      mkdir -p /opt/.m2/repository; \
      mvn -B -ntp -Dmaven.repo.local=/opt/.m2/repository -Dlicense.skip=true -Dmaven.test.skip=true clean install; 
Issue: Using 'mvn' (system maven) may rely on an unpinned Maven version in the base image and lead to non-reproducible builds. Recommendation: use ./mvnw consistently for all Maven invocations (the wrapper pins the Maven version) or explicitly install and pin a Maven version and call that consistently.

WARNING: Potentially unnecessary JDK download and image size duplication:
The Dockerfile downloads and installs OpenJDK 21 from Adoptium and verifies its SHA256. Relevant lines:
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
Issue: The chosen base image is olympus-base-jvm:latest which commonly includes a JVM toolchain. Re-downloading and installing a full JDK increases image size and may be redundant. Although you verify the SHA256 (good), prefer using the base image's JDK unless you have a concrete reason to replace it. If you must replace it, consider pinning the base image to a digest to avoid surprises from :latest and document the justification.

(End of issues.)

Note: Internet access is available during `docker build`, but not when running the container. Test patch is injected into the container after build. Ensure your Dockerfile installs all dependencies at build time so the environment works fully offline after build.

```json
{
  "all_issues": "WARNING: Inconsistent mvn usage / unpinned Maven version risk:\nThe Dockerfile invokes the Maven wrapper to check the wrapper version and then uses the system 'mvn' for builds. Relevant lines:\n  RUN ./mvnw -B -ntp --version\n  RUN set -eux; \\\n      mkdir -p /opt/.m2/repository; \\\n      mvn -B -ntp -Dmaven.repo.local=/opt/.m2/repository -Dlicense.skip=true -Dmaven.test.skip=true clean install; \nIssue: Using 'mvn' (system maven) may rely on an unpinned Maven version in the base image and lead to non-reproducible builds. Recommendation: use ./mvnw consistently for all Maven invocations (the wrapper pins the Maven version) or explicitly install and pin a Maven version and call that consistently.\n\nWARNING: Potentially unnecessary JDK download and image size duplication:\nThe Dockerfile downloads and installs OpenJDK 21 from Adoptium and verifies its SHA256. Relevant lines:\n  RUN set -eux; \\\n      arch=\"$(dpkg --print-architecture)\"; \\\n      case \"$arch\" in \\\n        amd64) tarch='x64'; sha='4b2220e232a97997b436ca6ab15cbf70171ecff52958a46159dfa5a8c44ca4de' ;; \\\n        arm64) tarch='aarch64'; sha='8d498ec88e1c1989fab95c6784240ab92d011e29c54d20a3f9c324b13476f9ad' ;; \\\n        *) echo \"unsupported architecture: $arch\" >&2; exit 1 ;; \\\n      esac; \\\n      url=\"https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jdk_${tarch}_linux_hotspot_21.0.11_10.tar.gz\"; \\\n      curl -fsSL --retry 8 --retry-all-errors --retry-delay 5 -o /tmp/jdk21.tar.gz \"$url\"; \\\n      echo \"${sha}  /tmp/jdk21.tar.gz\" | sha256sum -c -; \\\n      mkdir -p /opt/jdk-21; \\\n      tar -xzf /tmp/jdk21.tar.gz -C /opt/jdk-21 --strip-components=1; \\\n      rm -f /tmp/jdk21.tar.gz; \\\n      /opt/jdk-21/bin/java -version\nIssue: The chosen base image is olympus-base-jvm:latest which commonly includes a JVM toolchain. Re-downloading and installing a full JDK increases image size and may be redundant. Although you verify the SHA256 (good), prefer using the base image's JDK unless you have a concrete reason to replace it. If you must replace it, consider pinning the base image to a digest to avoid surprises from :latest and document the justification.\n\n(End of issues.)",
  "base_image_compliant": {
    "explanation": "OK - Dockerfile uses an accepted base image: FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest.",
    "status": "OK"
  },
  "dependencies_installed": {
    "explanation": "OK - The Dockerfile runs Maven to populate a local Maven repository and fetch dependencies (mvn ... clean install and mvn dependency:get). This satisfies the expectation to install application dependencies.",
    "status": "OK"
  },
  "interactive_shell": {
    "explanation": "OK - Container default command is an interactive shell: CMD [\"/bin/bash\"].",
    "status": "OK"
  },
  "no_test_execution": {
    "explanation": "OK - Tests are not executed. The Maven build uses -Dmaven.test.skip=true and there are no RUN lines invoking test.sh, pytest, npm test, or similar test runners.",
    "status": "OK"
  },
  "package_manager_installation": {
    "explanation": "OK - The Dockerfile does not install package managers that are provided by the chosen base image. A JDK binary tarball is downloaded and installed (not via an install script that pipes to sh), which is not a package-manager install.",
    "status": "OK"
  },
  "registry_compliant": {
    "explanation": "OK - Base image is one of the accepted Olympus images (public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest).",
    "status": "OK"
  },
  "repository_setup": {
    "explanation": "OK - WORKDIR /app is used and the repository contents are copied into the image with COPY . .. The Dockerfile does not attempt to git clone the repo.",
    "status": "OK"
  },
  "security_safety": {
    "explanation": "warning - The Dockerfile downloads an OpenJDK tarball from GitHub releases via curl and verifies its SHA256, which is good practice and mitigates supply-chain risks. However:\n1) The JDK is being downloaded and installed on top of a JVM-specific base image (olympus-base-jvm). This may be unnecessary duplication and increases image size; justify why the base image's JVM is not being used. Prefer relying on the base image's JDK unless a different exact JDK build is required.\nNo obfuscated commands, docker.sock mounts, hard-coded secrets, or other malicious patterns were detected.",
    "status": "warning"
  },
  "user_creation_compatible": {
    "explanation": "OK - The Dockerfile does not create any user or group; this is acceptable.",
    "status": "OK"
  },
  "version_pinning": {
    "explanation": "warning - Some tool/version risks detected:\n1) The Dockerfile downloads a specific JDK release (OpenJDK21U-jdk_..._21.0.11_10.tar.gz) and verifies its SHA256 (this is good and pinned). However the Dockerfile uses the system 'mvn' binary for the main build steps rather than consistently using the project wrapper ('./mvnw'). The lines involved:\n   RUN ./mvnw -B -ntp --version\n   RUN set -eux; \\    mkdir -p /opt/.m2/repository; \\    mvn -B -ntp -Dmaven.repo.local=/opt/.m2/repository -Dlicense.skip=true -Dmaven.test.skip=true clean install; \nUsing the system mvn (unqualified 'mvn') may make the build rely on an unpinned Maven version present in the base image. To ensure reproducible builds, prefer using ./mvnw for all Maven invocations (the wrapper pins the Maven version used by the project) or explicitly install/pin a specific Maven version and call it consistently.",
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
  "commitHash": "947296e59f047826e3738a698cc12bda6415d33b",
  "owner": "mapstruct",
  "repo": "mapstruct",
  "repoInfo": {
    "language": "java",
    "license": "noassertion",
    "stars": 7672
  },
  "warnings": [
    "License could not be recognized — proceed with caution; confirm it is a permitted license (MIT, Apache-2.0, BSD-2/3-Clause, ISC, 0BSD, Unlicense, or CC0) or the submission may be rejected in review"
  ]
}
```

---

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 3 total suggestions, including 1 high-priority removal of an obvious default. Per the rules, 3+ suggestions or any high-priority item requires a request_changes verdict.",
  "suggestions": [
    {
      "priority": "high",
      "quote": "Existing explicit and automatic configuration inheritance fills only targets not supplied by the current or inherited super mappings, and behavior remains unchanged when the option is false.",
      "suggestion": "Remove the trailing clause \"and behavior remains unchanged when the option is false.\" This is an obvious default and adds noise without affecting requirements."
    },
    {
      "priority": "medium",
      "quote": "When an inherited source path begins with a whole path segment that the overridden method resolves to a source parameter, rebind that segment to the overriding parameter in the same signature position and keep the rest of the path, which may be empty, including when same-typed parameters are renamed.",
      "suggestion": "Delete the example tail \", including when same-typed parameters are renamed.\" The rule is already fully specified by rebinding by signature position; the example is redundant."
    },
    {
      "priority": "low",
      "quote": "A shared ancestor contributes once, and target = \".\" flattening declarations accumulate instead of competing as one target, whether they are inherited or declared on the current method.",
      "suggestion": "Drop the clause \"whether they are inherited or declared on the current method.\" It’s implied by \"accumulate\" and earlier context and can be removed to tighten phrasing."
    }
  ],
  "summary": "- [HIGH] Trim obvious default: Remove \"... and behavior remains unchanged when the option is false.\" from: \"Existing explicit and automatic configuration inheritance fills only targets not supplied by the current or inherited super mappings, and behavior remains unchanged when the option is false.\" This default is implied and adds noise.\n- [MEDIUM] Remove redundant example: In \"... keep the rest of the path, which may be empty, including when same-typed parameters are renamed.\", delete \", including when same-typed parameters are renamed.\" The rebinding-by-signature-position rule already covers this case.\n- [LOW] Cut implied qualifier: In \"... flattening declarations accumulate instead of competing as one target, whether they are inherited or declared on the current method.\", drop \"whether they are inherited or declared on the current method.\" It’s implied by \"accumulate\" and prior context.",
  "verdict": "request_changes"
}
```
