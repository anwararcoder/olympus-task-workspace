# MapStruct Configurable Collection Implementations — Foundation Plan

> Status: foundation only, prepared 2026-07-21. This document selects and bounds the next task;
> it does not authorize implementation in the shared checkout. The executor must revalidate the
> live upstream state, prove the harness and strict-LoC gates, and then build in an isolated
> workspace.

## Executive decision

Create `mapstruct-configurable-collection-implementations` around MapStruct issue
[#3180](https://github.com/mapstruct/mapstruct/issues/3180): allow a project-level configuration
resource to replace MapStruct's fixed concrete implementations for supported collection and map
interfaces.

This is the best current MapStruct candidate because it has all of the properties the recent task
history says we need:

- a real open upstream request with two independent user reports (#3180 and #2384);
- a maintainer-endorsed direction—project configuration or an SPI—rather than a rejected feature
  domain;
- no open or closed implementation PR found for #3180 and no implementation in current `main`;
- no overlap with the local Map-entry, bean-to-map, or rejected immutable-update tasks;
- base-compilable fixtures: configuration is expressed as resource text and a string processor
  option, so test Java need not reference a new annotation, member, enum constant, or SPI type;
- a natural production ripple through configuration discovery, processor lifecycle, validation,
  type modeling, implementation selection, construction, diagnostics, and documentation;
- behavioral assertions that distinguish direct, forged, factory, concrete-target, and update
  paths without inspecting private classes or generated-source formatting.

The provisional public contract uses a classpath `mapstruct.properties` resource. Properties with
the prefix `mapstruct.collectionImplementation.` map a supported interface FQN to an implementation
FQN. An optional `-Amapstruct.configurationFile=<resource-name>` selects an alternative classpath
resource, primarily so independent modules and tests can use isolated configurations. This exact
surface is not frozen until the executor proves it against both compiler harnesses and rechecks
upstream discussion; the feature domain and precedence rules are the durable decision.

Do not fall back to `@SubclassMapping` update support. Live preflight found issue #2946 and public
PR #3330 implementing it. Do not fall back to context-as-source: issue #3665 already has public PR
#3891. Those are already-solved-online blockers, not task-calibration opportunities.

## Why the recent rounds change the selection standard

### Map-entry collections: an architectural boundary worked

`mapstruct-map-entry-collections` twice reached 10/10 even though the solutions were substantial.
Once agents represented `Map<K,V>` as `Map.Entry<K,V>` elements, most positive variants became
ordinary reuse of existing container machinery. Adding arrays and lower bounds merely taught a
fresh population what else to enumerate.

The accepted round succeeded at 2/10 because the final test required an architectural classifier:
open only the Map/iterable-or-array pair while preserving MapStruct's separate Stream family. Six
agents used a global Map exemption and failed. Two independently structured solutions passed. The
lesson is not “add a negative test”; it is “find a neighboring family whose preservation forces
the correct ownership boundary.”

This task's equivalent boundary is precedence and lifecycle. A correct implementation cannot
merely replace `ArrayList` with a configured string. It must apply configuration only when
MapStruct owns construction, while preserving a user-provided factory, a declared concrete
target, and an existing `@MappingTarget` instance. It must also reach forged mappings without
leaking configuration between compiler tasks.

### Criteria quantifiers: raw patch size is not effective production LoC

`immutables-criteria-quantifiers` showed that tests, imports, declarations, generated templates,
comments, braces, and wiring can make a patch look large while the manager's effective production
count remains below the live floor. The accepted Map-entry patch also illustrated the danger of a
lenient count: `count_loc.py` can clear a patch that a strict human count treats as borderline.

For this task, the live normal-Olympus authority is
`my-review-workflow/rules/platform-panel.md`: the golden must contain at least 250 meaningful
production lines under the manager exclusions. The planning target is at least **350 strict
effective production lines**, leaving a real margin. `count_loc.py` is only an early screen. If a
minimal complete reference cannot project at least 300 strict lines, kill or structurally deepen
the idea before authoring full artifacts. Never add branches, wrappers, comments, or tests to pad
the count.

### Accepted Immutables tasks: close a state class, not a list of examples

The accepted binary-serialization and value-pointer tasks became durable when their tests closed
an interacting state/dispatch class and the reference implemented the same class. The seedable-lazy
foundation carries that forward through explicit provenance and lifecycle states.

The corresponding class here is **construction ownership**:

1. MapStruct-owned interface construction may use a configured implementation.
2. User-owned construction through an object factory takes precedence.
3. A declared concrete return type constructs that type, not a global replacement.
4. An existing mapping target retains its supplied identity.
5. Forged/nested mappings inherit the same configuration because MapStruct owns their temporary
   result construction.

All planned examples should be projections of this one class. If a test cannot be explained by
one of these states or by configuration validity, it is probably breadth rather than difficulty.

## Candidate comparison and exclusions

| Candidate | Upstream/repo fit | Difficulty and strict-LoC outlook | Decision |
| --- | --- | --- | --- |
| Configurable collection/map implementations (#3180, related #2384) | Open feature; maintainer explicitly discussed a project property file or SPI; fixed registry exists in `TypeFactory`; no PR found | Configuration discovery + validation + per-processing lifecycle + model/codegen precedence; projected 350–550 strict production lines | **Selected**, subject to harness and Gate-B measurement |
| Custom property-name matching (#1076, related #3841) | Maintainer welcomed the concept and no PR was found, but the existing `AccessorNamingStrategy` already normalizes property names and the remaining flat-match work concentrates in one `BeanMappingMethod` block | Likely 150–250 strict lines unless combined with controversial recursive flattening; repeats the criteria-quantifiers boundary risk | **Reserve only**; do not use without a measured deeper seam |
| Method-level DeepClone propagation into nested containers (#3516) | Open bug; maintainer agrees it should be examined | Source analysis identifies the immediate defect as one options-fallback break between bean and iterable mapping options; likely a small propagation fix despite broad behavioral examples | **Killed for LoC**, not a platform-sized task |

Additional live exclusions:

- `@SubclassMapping` + `@MappingTarget`: issue #2946 and public PR #3330.
- `@Context` as a source: issue #3665 and public PR #3891.
- unmodifiable collection results: issue #3334 and public PR #3356.
- retaining/updating collection elements: issue #3695 and public PR #3696; separate maintainer
  comments also describe replacement/clear behavior as intentional for existing strategies.
- subclass mappings with several sources: issue #3118; maintainer says the accidental behavior
  should likely be rejected because the dispatch source is ambiguous.
- implicit nested-name flattening: issue #3841 has no maintainer decision and risks crossing
  MapStruct's explicit-mapping design into ModelMapper-style inference.

## Repository and public preflight

### Exact upstream state at foundation time

- Repository: `https://github.com/mapstruct/mapstruct.git`.
- Live `refs/heads/main` on 2026-07-21:
  `7ad5f9e56e9896c8f165d509b0cff8916061e85e` (`#4088 Avoid stale nested source local var in
  updates (#4089)`).
- The shared local checkout was still at the older dossier commit
  `ddfd8187b3934976d28852785a596e387e4424cd`; it is a read-only source, not the execution
  workspace.
- The selected live base object already exists locally, but the executor must still compare it to
  remote `main` and record the exact SHA when starting. If upstream moved, inspect the relevant
  diff before pinning the new base.

Do not fetch, checkout, patch, or clean the shared `repos/mapstruct` directory as part of task
implementation. Create a uniquely named private worktree or no-local clone at the recorded base.

### Upstream demand and maintainer position

Issue #3180 asks to choose the implementation used when a mapping target is a collection/map
interface, motivated by a serializer that cannot accept MapStruct's default `LinkedHashMap`.
The maintainer first points to `@ObjectFactory` as a local workaround, then says a general way to
define implementation types could be useful. The discussion explicitly considers a
`mapstruct.properties` file or another SPI/configuration mechanism. The maintainer objects only to
an unbounded family of dynamically named processor options such as one supported option per FQN;
he does not reject configurable implementations.

Issue #2384 independently asks why `Collection` must become `ArrayList` and whether the default can
be selected. Issue #1961 contains the broader configuration discussion: local programmatic
configuration should outrank a global default, and project/module configuration and
organization-wide SPI configuration are distinct plausible scopes.

The provisional single configuration-file option respects those comments:

- it does not introduce one dynamic processor option for every interface;
- it remains compile-time configuration;
- it keeps local factory/concrete target choices above the global default;
- it can later coexist with an organization-wide SPI if upstream chooses to add one.

### Public implementation and local uniqueness sweep

At foundation time:

- #3180 is open and has no linked or search-discovered implementation PR;
- repository-wide search finds no `mapstruct.properties`,
  `mapstruct.collectionImplementation`, or `implementation.type.*` implementation;
- issue/PR search for “collection implementation”, “implementation types”, configurable, and
  properties returns #3180 and related requests but no solution PR;
- web/GitHub Discussion search found no public implementation or maintainer rejection;
- local `my-work` contains no task about configurable result implementations.

This is a time-sensitive gate, not a permanent fact. Repeat issue, PR, code, commit, release-note,
and Discussion searches immediately before implementation and before submission. If a public
implementation appears, kill the task; title or wording changes do not cure public overlap.

## Current architecture and integration points

### Fixed implementation registry

`processor/src/main/java/org/mapstruct/ap/internal/model/common/TypeFactory.java` owns a fixed
`implementationTypes` map. Its constructor registers defaults including:

- `Iterable`, `Collection`, and `List` → `ArrayList`;
- `Set` → `LinkedHashSet`;
- `SortedSet`/`NavigableSet` → `TreeSet`;
- `Map` → `LinkedHashMap`;
- `SortedMap`/`NavigableMap` → `TreeMap`;
- concurrent and sequenced map/set interfaces → their current repository defaults.

`getImplementationType(TypeMirror)` performs an exact declared-interface lookup and rebuilds the
implementation `Type` with the target's generic arguments. This exact registry is the natural
overlay point; do not scatter string checks through iterable and map builders.

### Construction model

`ImplementationType` records whether creation uses a no-argument constructor, an initial-capacity
constructor, load-factor adjustment, or a repository factory method. `IterableCreation.ftl`
chooses, in order, a selected object factory, enum-set construction, a registered implementation,
or direct construction. Collection, map, nested-property, and `SET_TO_DEFAULT` paths consume the
same target `Type`/implementation metadata through `IterableCreation`, `NewInstanceCreation`,
`CollectionAssignmentBuilder`, and property mapping.

This is why factory precedence and forged propagation should emerge from one validated registry
overlay rather than separate special cases.

### Processor lifecycle

`MappingProcessor` exposes fixed supported options through `MappingOption`. It constructs an
`Options` object from `ProcessingEnvironment#getOptions`. A
`DefaultModelElementProcessorContext` is created per mapper and currently constructs a fresh
`TypeFactory`; `RoundContext` and `AnnotationProcessorContext` hold processing-environment state
shared across those mapper contexts.

The configuration resource must therefore be discovered and parsed once per processing
environment, while each `TypeFactory` receives an immutable validated view to overlay its own
`ImplementationType` objects. A static mutable map would leak across test-template compiler runs
and parallel processor invocations.

### Harness shape

MapStruct's processor tests use `@ProcessorTest` with javac and ECJ, `@WithClasses` fixtures
recompiled at test runtime, `@ProcessorOption` for string options, and behavioral runtime
assertions. Fixture Java is compiled by the test module before runtime processing, so it cannot
name new annotations, annotation members, enum constants, or SPI types.

Resource configuration avoids that trap. The test patch can contain `.properties` resources and
an existing string-valued `@ProcessorOption`; clean-base fixture Java still compiles. The clean
base ignores the resource/unknown option and then fails the expected runtime or compilation
outcome, while the reference recognizes it.

This resource visibility must be proved for both javac and ECJ before the task proceeds. Do not
assume the processor classloader, application classpath, and test classpath are interchangeable.

## Proposed behavioral contract

### Resource discovery

1. With no option, MapStruct looks for `mapstruct.properties` on the mapping compilation
   classpath. A missing default resource is normal and preserves all current defaults.
2. `-Amapstruct.configurationFile=<relative-resource-name>` selects one alternative classpath
   resource. If the option is explicitly supplied and that resource cannot be read, compilation
   reports a clear error.
3. The selected file is parsed once per processing environment. Configuration from one compiler
   task must not leak into another.
4. Standard `.properties` comments, escaping, and surrounding whitespace are accepted. Invalid
   MapStruct-owned keys and duplicate conflicting assignments receive deterministic diagnostics;
   do not silently depend on classpath or hash-map order.

If the harness proves that the compilation classpath cannot provide this contract consistently
under both compilers, stop and choose an equally base-compilable resource-loading surface. Do not
solve a harness wall with generated test-only annotations or reflection into test internals.

### Configuration entries

An entry has this provisional form:

```properties
mapstruct.collectionImplementation.java.util.List=com.acme.FastList
mapstruct.collectionImplementation.java.util.Map=com.acme.FlatHashMap
```

The left side names an interface that MapStruct already knows how to instantiate through
`TypeFactory`'s implementation registry. The right side names the replacement implementation.
Matching is exact by target-interface FQN; there is no subtype wildcard or nearest-supertype
search in this task.

### Validation

For each configured pair, annotation processing must verify before generation that:

- the configured interface is a supported registry key;
- both types resolve through the annotation-processing element model, including types compiled in
  the current project—never through `Class.forName`;
- the implementation is concrete and accessible from generated mapper code;
- its erased type is assignable to the configured interface;
- its generic shape can receive the interface's type arguments without raw or malformed generated
  code;
- it has an accessible zero-argument constructor; an accessible `int` constructor may retain the
  normal capacity-aware creation path, but lack of that optimization must not reject an otherwise
  valid type.

Invalid entries produce stable, user-facing compilation diagnostics that identify the resource
entry and reason. Do not let an invalid value fall through to a generated-source javac error.

### Construction and precedence

- A direct mapping whose declared result is a configured supported interface constructs the
  configured implementation and returns it through the interface type.
- The same choice applies to forged collection/map mappings for bean properties and nested
  conversions.
- `RETURN_DEFAULT` and equivalent MapStruct-owned default construction use the configured
  implementation when the affected result interface is configured.
- A mapper/object factory applicable to that construction wins over global configuration.
- An explicitly concrete declared result type constructs that concrete type and is not replaced
  by the configuration for one of its interfaces.
- An update method with an existing `@MappingTarget` preserves that exact instance and existing
  clear/add or clear/put semantics. Global configuration must not allocate a replacement target.
- Unconfigured interfaces retain their current exact defaults, constructor/factory behavior,
  generated imports, generic arguments, and source-order semantics.
- Arrays, streams, bean construction, enum sets, builders, and non-container return types are out
  of scope and must remain unchanged.

### Documentation boundary

Document the resource location, optional selector option, key format, supported target interfaces,
validation rules, and precedence. Do not claim the feature configures every implementation choice
in MapStruct. It configures only defaults for supported collection/map interface construction.

## Independent architectural decisions

| Decision | Why it is independent | Typical incomplete implementation |
| --- | --- | --- |
| Resource ownership and lookup | Annotation processors have distinct processor, compilation, and output classpaths | Reads from the processor classloader, so project resources are invisible |
| Processing lifecycle | Mapper contexts are per mapper but configuration is per compilation | Parses repeatedly or stores mutable static state that leaks across tests |
| Stable parsing and diagnostics | Configuration errors must fail before generated-source compilation | Uses `Properties#getProperty` and silently overwrites duplicates/typos |
| Element-model type resolution | Implementations can be source types in the current compilation | Uses `Class.forName`, which only sees processor-path binaries |
| Assignability/accessibility/generics | A raw FQN is insufficient to generate a valid parameterized constructor | Accepts abstract, package-private, incompatible, or wrong-arity types |
| Registry overlay and default fallback | Only configured exact interfaces change | Replaces every `Collection` subtype or loses JDK-version defaults |
| Construction metadata | Existing templates distinguish capacity, load factor, factories, and no-arg creation | Always emits a size constructor that a configured class lacks |
| Ownership precedence | Factory, concrete result, existing target, and forged result have different owners | Global config overrides a factory or replaces an update target |
| Forged propagation | Nested properties get mapping methods after the top-level method is analyzed | Direct methods work, forged/nested methods still use `ArrayList`/`LinkedHashMap` |

These decisions should create honest code volume. If the spike collapses most rows into one small
registry assignment, the idea did not survive measurement.

## False-positive threat model and contract closure

The suite must distinguish at least these plausible wrong architectures:

| Wrong architecture | Positive case it may pass | Boundary that must catch it |
| --- | --- | --- |
| Hard-code a different global default | Direct configured List/Map | No-resource control and unconfigured-interface control |
| Read resources through the processor classloader | A config bundled with processor tests | Implementation/config supplied on the compilation classpath |
| Use `Class.forName` | JDK implementations | Custom implementation compiled in the same fixture/project |
| Apply only in direct iterable/map builders | Direct methods | Forged bean-property mapping and `RETURN_DEFAULT` path |
| Override all construction | Configured direct method | `@ObjectFactory`, concrete result, and existing-target identity controls |
| Ignore type validation | Valid replacement | Nonassignable, inaccessible, abstract/interface, generic-shape, and constructor diagnostics |
| Store a static global registry | One configured compiler task | Back-to-back configured and unconfigured tasks under both compilers |
| Match assignable supertypes broadly | Exact `List` configuration | Unconfigured `Collection`, `Set`, and sorted/concurrent controls |
| Emit one constructor shape | Custom class with both constructors | No-arg-only implementation plus normal capacity-capable implementation |

Do not turn every table row into several repetitive tests. Prefer composite fixtures that keep
the base failing for the new feature while placing positive and neighboring preservation cases in
the same compilation. A negative case that already passes on the clean base is not an independent
new-task test unless paired with a base-failing positive control.

Every candidate pass remains provisional until the current false-positive evaluation and an
independent contract-class audit clear it. A candidate that differs from the reference in resource
loader or constructor organization is legitimate if it satisfies the observable contract.

## Test strategy

### Harness spike before full test authoring

Build only enough test infrastructure to prove:

1. a selected resource is visible to the processor under javac;
2. the same resource is visible under ECJ;
3. a custom implementation compiled with the fixture resolves through `Elements`;
4. a clean base compiles all test Java and fails the new test for the intended missing behavior;
5. two processor-test invocations with different resource selections do not contaminate each
   other.

If any point fails, diagnose the classpath model before adding production scope. A compiler-specific
resource wall is a task/harness defect, not difficulty.

### Core fixture families

- direct `List` and `Map` results use two observable custom implementations;
- an unconfigured `Set` or `Collection` retains its repository default;
- bean properties force forged list/map mappings and receive the configured implementations;
- a null source under `RETURN_DEFAULT` produces an empty configured result;
- an applicable `@ObjectFactory` wins and its returned instance is observable;
- a concrete return type remains that exact class;
- an update method preserves the supplied target by identity;
- a custom implementation defined in fixture sources proves element-model resolution;
- one no-arg-only implementation proves constructor compatibility;
- invalid resources independently exercise unsupported key, missing type, nonassignability,
  abstract/interface type, inaccessibility, generic mismatch, and missing constructor;
- an explicitly named missing resource reports a clear error;
- a configured compilation followed by an unconfigured one proves no state leakage.

Use unique low-collision test package/file tokens selected at implementation time. Keep logically
independent compilation fixtures in separate test methods or classes so one broken mapper does not
fan out into dozens of misleading failures, the caveat observed in Map-entry's accepted report.

### Assertion rules

- Assert runtime result classes/identity/content and compilation success/failure.
- Assert a diagnostic's stable semantic phrase and associated element/resource entry only when
  the repository treats it as API; do not over-pin ordering or irrelevant punctuation.
- Do not reflect into `TypeFactory`, inspect private model objects, or require exact generated
  source formatting.
- Do not assert capacity, load-factor, or constructor choice unless that behavior is explicitly
  included in the final description.
- Trace every test to one description clause or a cited repository preservation rule.
- Ask both adversarial questions for every assertion: what wrong implementation still passes,
  and what faithful alternative implementation would fail?

## Effective-LoC Gate B

### Strict counting policy

Count only added/meaningfully changed production logic. Exclude:

- tests and test harness;
- documentation;
- blank and comment-only lines;
- imports/package/export-only wiring;
- braces, punctuation-only lines, and FreeMarker closing/control boilerplate;
- type-only declarations and generated boilerplate;
- dead code or defensive branches not reachable from the contract.

Run `review-guides/count_loc.py` as a lenient screen, then maintain a file-by-file strict count with
the manager exclusions from `review-guides/shipd-messages.md` and
`my-review-workflow/rules/platform-panel.md`.

### Expected production surfaces

| Surface | Honest work expected | Provisional strict range |
| --- | --- | --- |
| Processor option and immutable configuration model | selector option, lifecycle plumbing | 35–60 |
| Resource reader/parser | lookup, explicit/default absence, stable entry parsing | 80–130 |
| Type/entry validator | element resolution, accessibility, assignability, generics, constructors | 110–170 |
| TypeFactory/ImplementationType integration | validated overlay, generic reconstruction, constructor metadata | 70–110 |
| Diagnostics and construction integration | user errors, factory/default/update boundaries, any necessary model/template changes | 55–90 |
| **Projected strict production total** | excludes docs/tests/wiring | **350–560** |

These are hypotheses, not credit. Estimates in this workflow have historically run about 40%
optimistic.

### Gate decision

- `>= 350` strict effective production lines with all architecture rows real: GO.
- `300–349`: inspect whether one missing cohesive lifecycle/validation axis belongs in the feature;
  deepen only if upstream semantics demand it.
- `250–299`: do not proceed as planned. The task has no reviewer margin even if it technically
  touches the platform floor.
- `< 250`: kill immediately.

Tests, documentation, extra exception wording, and wrapper classes cannot rescue a failed Gate B.

## Solvability and pass-rate calibration

The current default Olympus bar is:

- at least one legitimate pass;
- pass rate at most 40%;
- successful-run medians at least 250 LOC, 40 messages, and 2 files;
- no unfair or environment-blocked runs;
- required false-positive evaluation passes.

Do not assume this task is hard merely because it spans configuration and annotation processing.
The strongest agent may identify the `TypeFactory` registry quickly. The difficulty must survive
that insight through classpath ownership, per-processing lifecycle, type validation, and
construction precedence.

Before full artifact polish:

1. Give a fresh strong solver only the concise draft description and exact base.
2. Inspect its trajectory, not only pass/fail. Did it use `Class.forName`, global static state, or
   override local construction? Did it discover both compiler classpaths?
3. If the solver implements the complete core cleanly with little investigation, kill or deepen
   structurally. More invalid-value examples will not lower the ceiling.
4. If all solvers fail at resource discovery or cannot compile the fixtures, repair the seam;
   that is a wall, not healthy difficulty.
5. After canonical artifacts are stable, obtain a fresh mixed-capability population. Saved replay
   is a gap finder only and cannot establish the live pass rate.

Never trade the FP gate against pass rate. If a fair candidate passes the contract, keep it as a
legitimate pass. If a broad candidate passes because the suite omitted a stated ownership state,
close the state class in description, tests, and reference together.

## Execution roadmap

### W0 — Re-establish authority and exact state

- Read every authority listed in `task-prompt.md`.
- Recheck remote base, issue/PR/discussion/code overlap, local uniqueness, and maintainer stance.
- Record exact URLs, timestamps, hashes, and search queries in a repo-fit document and ledger.
- Create a private exact-base workspace; leave the shared clone untouched.

### W1 — Prove resource/harness fitness

- Trace javac and ECJ compiler/processor classpaths in the harness.
- Create the smallest base-compilable resource probe.
- Prove default, explicit, missing, and isolated resource behavior under both compilers.
- Decide and document the final resource location/selector contract before production work.

### W2 — Minimal reference spike and Gate B

- Implement config discovery, one valid pair, validation, and direct construction.
- Extend through one forged path and one precedence boundary.
- Count strict effective production LoC and project only demonstrated remaining work.
- Write GO/DEEPEN/KILL in the ledger. Do not author the full submission after a failed gate.

### W3 — Early ceiling/fairness preflight

- Draft a concise public description without architecture hints.
- Give a fresh strong solver the draft and base.
- Read the trajectory and probe the dominant wrong architecture.
- Revise one architectural invariant at a time; do not add a checklist of edge values.

### W4 — Build canonical artifacts

- Complete the professional reference implementation and upstream-style docs.
- Build base-compilable, behavioral, dual-compiler tests.
- Write `test.sh`, Dockerfile, base commit, description, ledger, repo-fit, and prechecks artifacts
  using the repository conventions.
- Generate disjoint test and solution patches from clean indexes.

### W5 — Lightweight local gates

- static patch application, whitespace, mode, path-disjointness, leakage, ASCII, and hash checks;
- targeted compilation only when it answers a new question;
- no repeated full local Maven/Docker runs when the exact bytes have not changed.

### W6 — One stable remote verification batch

- Follow `standards/HYBRID-CLOUD-WORKFLOW.md`.
- Select one mapped idle forge after checking account, containers, and disk.
- Use one task-owned namespace and immutable image/cache.
- Run the four states once after bytes stabilize; preserve logs/XML/hashes locally.
- Remove only task-owned disposable data and stop the forge if otherwise idle.

### W7 — Fresh solvability and FP calibration

- Obtain a fresh mixed-capability batch on exact hashes.
- Build run-family and first-wrong-turn matrices.
- Adjudicate each proposed FP in candidate/reference/base states.
- Modify artifacts only for a contract-class defect, then rerun every stale required check.

### W8 — Reviewer simulation and submission readiness

- Description, Tests, Solution & Code review at current 0–3 bands.
- strict golden LoC and successful-run medians;
- repo fit, public overlap, fairness, cheating, environment, similarity, and FP gates;
- final artifact freshness and exact hash manifest.

## Description drafting guardrails

The final description must be written late, after the contract is proven. It should read like a
maintainer feature request, not like this plan. State the observable configuration surface because
users must know how to activate it, but do not name internal registry/model/template classes or
tell the solver how to load resources.

Provisional sketch, to be rewritten rather than copied mechanically:

```md
MapStruct currently chooses fixed concrete implementations when a collection or map mapping
returns a supported interface. Allow those defaults to be overridden per interface from a
classpath `mapstruct.properties` resource. An alternative resource may be selected with the
`mapstruct.configurationFile` processor option; each
`mapstruct.collectionImplementation.<interface-fqn>` entry names the concrete implementation to
use.

Configured implementations apply to direct and generated nested mappings whenever MapStruct owns
the result construction, including empty results created by the configured null strategy. They
must be accessible, concrete, generically compatible, constructible, and assignable to the named
interface; invalid entries produce compilation errors. Applicable object factories, concrete
declared targets, and existing mapping-target instances retain precedence. Missing entries keep
the current defaults, and unrelated mapping families are unchanged.
```

Every final clause must map to a test and the reference. Remove any clause that is merely a true
implementation detail. Do not hide the resource format or precedence and then test them.

## Hard kill rules

Kill or return to candidate selection if any occurs:

- a public implementation PR, fork surfaced by the issue, release, or maintainer-provided patch
  now solves the feature;
- maintainers reject configurable implementation selection or the chosen resource surface;
- resource fixtures cannot compile and exercise both javac and ECJ without new-symbol base
  failures;
- strict effective golden production LoC is below 250, or cannot reach 350 without padding;
- the implementation collapses to a small registry assignment plus repetitive validation;
- a fresh strong solver cruises through every lifecycle/precedence decision;
- all agents fail one resource/classpath wall;
- correct alternative implementations fail due to generated-source formatting or loader
  assumptions not stated in the description;
- the feature overlaps a local task or becomes a derivative of bean-to-map/map-entry work;
- reference and description disagree on factory, concrete-target, update, or invalid-config
  semantics.

## Definition of foundation success

This foundation is complete when the next executor can begin with:

- one selected, upstream-supported, non-publicly-implemented feature domain;
- an exact live-base procedure and local uniqueness evidence;
- a provisional but closed observable contract;
- identified source and harness integration points;
- a strict-LoC measurement gate with a safe margin;
- a construction-ownership difficulty invariant;
- an FP threat matrix that protects faithful alternative designs;
- an execution path that uses private workspaces and only one necessary remote batch.

It is not evidence that the eventual task will pass the platform. The executor must earn GO at the
resource-harness, strict-LoC, early-ceiling, four-state, fresh-population, and false-positive gates.

## 2026-07-21 execution addendum (append-only)

The foundation above was frozen at SHA-256
`0db6f646ca3ab7e0deb4f40ba8fca927eab7280098f440ab070f7eec23c035c9` before execution. Gate 0
remained GO on live MapStruct main commit `7ad5f9e56e9896c8f165d509b0cff8916061e85e`: issue 3180
remained open and supported a project-level configuration direction, while no public implementation
or local derivative was found.

The resource seam was proved for both javac and ECJ with compiler-invocation-scoped classpaths.
The final contract uses a root `mapstruct.properties` resource, an optional relative
`mapstruct.configurationFile` selector, exact supported-interface keys, deterministic validation,
per-processor isolation, object-factory precedence, concrete/update preservation, and forged plus
`RETURN_DEFAULT` coverage. Configured types must preserve unbounded generic parameters in order and
provide a safe public no-argument constructor; a safe public `int` constructor retains size-aware
allocation when present.

The frozen behavioral suite contains 27 logical processor tests expanded over javac and ECJ (54
compiler invocations). It includes positive interface-family, nested-forge, null-default, capacity,
precedence, fallback, duplicate, validation, and no-cross-run-leakage discriminators. The official
strict counter reports 450 meaningful non-test solution LOC across eight implementation/documentation
files, above the approximately 380-LOC screen without counting the harness or fixtures.
