# Immutables Seedable Lazy Attributes — Foundation Plan

> Status: selected foundation, not yet a submission.
>
> Written 2026-07-21 after re-reading the current task-selection prompt, the live workflow and
> review authorities, the active MapStruct and Immutables task histories, and the three accepted
> Immutables sprint-4 submissions. The next agent must validate the kill gates below before it
> authors final deliverables.

## Executive decision

Create the next task in Immutables around **seedable lazy attributes**:

```java
@Value.Lazy
@Value.Default
String rendered() {
  return expensiveRender(source());
}
```

The annotation pair should describe one optional generated attribute with two ways to obtain its
value:

- a caller may explicitly seed it through the generated builder or its own with-method; or
- if no seed exists, its initializer runs lazily on first access and memoizes one successful
  result using ordinary `@Value.Lazy` concurrency and retry behavior.

The hard part is not removing the current diagnostic. The hard part is retaining the distinction
between an explicit seed and a computed fallback throughout generated builders, with-copies,
`from(...)`, `toBuilder()`, lazy runtime state, and every supported generated configuration. A
modified copy must keep a caller's explicit override, must not force a cold fallback merely to copy
it, and must not turn a computed fallback into an override that can become stale when another
attribute changes.

This is the selected idea because an upstream user request sits in the repository's native feature
seam and the behavior has a finite, publicly observable state machine. That request is useful
repo-fit evidence, not maintainer endorsement. The idea is materially safer than the old
derived-result carry-over proposal, which conflicts with deliberate repository semantics. It is
also less likely than another MapStruct container task to collapse to one reusable recognition
insight.

Selection is conditional on a measured reference spike. The live Olympus golden floor is 250
meaningful production lines, but this task may collapse into short conditions around existing
templates. Proceed to full task construction only if a minimal, scope-exact reference has at least
325 conservatively counted meaningful production lines, with 375-500 preferred. If it does not,
bench the idea; do not inflate it with unrelated features, tests, comments, or template repetition.

## Why the previous rounds change the selection standard

### Map-entry collections: volume was not difficulty

`my-work/mapstruct-map-entry-collections/` evolved from the rejected immutable-update idea into
MapStruct issue #3580. Both fresh map-entry batches reached 10/10 even though agent solutions were
substantial: the second batch changed 14-19 files and had a 479.5-LoC median. Once a solver made
the single decision to model `Map<K,V>` as `Map.Entry<K,V>` elements, existing container mapping
machinery supplied arrays, qualifiers, conversions, subtypes, inheritance, updates, and null
handling.

The post-v4 refinement replayed old candidates at a promising 3/10, but a fresh population read
the newly explicit array and lower-bound requirements and returned to 10/10. This proves that old
omissions are not a difficulty mechanism. The next task must require multiple independent
architectural decisions from its first version.

The map-entry false-positive panel also exposed the right kind of discriminator:

- broad Map exemptions accidentally admitted `Map -> Stream`; and
- unsafe generated local naming collided with an ordinary `@Context` parameter.

The current uncommitted repair projects a 4/10 saved-candidate split, but that projection is not a
fresh pass-rate result. The lesson for this task is to design adjacent-behavior and namespace/state
discriminators before the first platform run.

### Criteria quantifiers: raw diff size was not effective LoC

`my-work/immutables-criteria-quantifiers/` now has healthy difficulty and false-positive evidence:
one materialized legitimate pass in ten, two in the broader twelve-run analysis, and zero false
positives. It is nevertheless blocked because a human reviewer estimated the golden at roughly
230 meaningful production lines, below the current 250 floor. Its lenient count is 807 and the
successful-agent median is 618 raw LoC. That median clears its separate successful-run LoC gate,
but it cannot repair the golden patch's effective-LoC deficit.

The strict discount is understandable: a large visitor rewrite includes moved legacy logic,
repeated BSON construction, declarations, routing, and behavior later removed from the task's
contract. The new task therefore needs a requirement-to-production-method ledger during the
reference spike. Count only logic required by the final contract after likely solvability
de-scoping.

### Accepted Immutables tasks: close classes, not examples

The recent accepted tasks provide the useful positive pattern:

| Task | Final result | Reusable lesson |
| --- | --- | --- |
| Binary serialization | 1/14, one genuine passer | Separate required eligibility from optional extensions; conditional support must still preserve non-default data. |
| Value pointers | 3/14; the FP panel upheld the two materialized passers it evaluated | Express the complete eligibility rule, including both positive members and vetoes, instead of adding fixture-specific exclusions. |
| Exhaustive fold | 2/10, zero false positives | Add behavioral boundary fixtures while keeping the public contract and reference coherent. |

The seedable-lazy suite must similarly test the state/provenance classes, not a catalog of scalar
types.

## Candidate comparison and exclusions

| Candidate | Repo fit | Difficulty / LoC outlook | Decision |
| --- | --- | --- | --- |
| Immutables seedable lazy attributes | Open upstream user request in a native feature seam; no implementation, branch, PR, or maintainer rejection found | Finite but multi-path state machine; projected 250-525 before scope freeze and must prove >=325 | **Selected, subject to Gate B** |
| Immutables derived/lazy result carry-over | No request found; conflicts with per-instance computation and copy semantics | Invasive and large, but semantically unsound | **Killed** |
| Immutables encoding type-literal interpolation (#1654) | Maintainer proposed a `classLiteral<K>()` interpolation seam | Strong repo fit, but likely 100-250 meaningful lines after reusing existing interpolation | Backup research only; too much LoC-collapse risk |
| MapStruct keyed collection merge | Public issue #3742 covers it | Could be substantial | **Killed:** maintainer recommends custom mapping and says replacement/clear behavior is by design |
| MapStruct container-aware nested paths | Potentially deep recursive forging task | Could reach 700+, but needs a separate public sweep and risks another one-helper collapse | Future fallback, not selected |
| Immutables polymorphic JSON discriminator | Large | Overlaps existing Gson/Jackson polymorphism and binary-serialization territory | Rejected |

### Why derived-result carry-over is not a fallback

The earlier `immutable-tmp-plan.md` treated cross-copy derived/lazy cache carry-over as promising.
That conclusion is now superseded by stronger repository evidence:

- `Value.java:180-187` defines `@Value.Derived` as eagerly computed and stored per instance.
- `Immutables.generator:4160-4167` intentionally omits derived fields from with-copy arguments.
- `ValuesTest.recalculateDerivedOnCopy` pins recalculation.
- commit `9c15ce2c812aeb488fcf2a85c33932dc0379ce69` fixed upstream issue #106 specifically so withers
  recalculate derived values.
- in issue #1308, the maintainer explains that a derived value may depend on environment such as
  an ID generator and is finalized as part of that constructed value.

Dynamic accessor-read tracking cannot see clocks, random values, thread-local state, captured
instances, or external mutable objects. It would also transfer per-instance lazy synchronization
state between objects. Do not revive this idea in an attempt to gain LoC.

## Repository and public preflight

### Exact upstream state

- Repository: `https://github.com/immutables/immutables.git`
- Proposed base: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`
- Local clean checkout: `repos/immutables`
- GitHub `master` resolved to the same SHA on 2026-07-21.

The next agent must recheck remote `master`, the issue, linked development, open and closed pull
requests, remote branches, and local task overlap before freezing the base. A later public
implementation is a hard kill or rebase/reselection event, not something to hide.

### Upstream use case

[Issue #1137, “A lazy default?”](https://github.com/immutables/immutables/issues/1137), opened
2020-01-12, asks for an attribute that may be passed through the builder but otherwise is computed
lazily once for the immutable object's lifetime. Follow-up comments describe seeding an already
available serialized representation and summarize the desired relationship as “lazy plus a value
that can be provided at construction.”

As of the snapshot above, the issue is open, unassigned, unlabeled, has three non-maintainer
comments, and has no linked branch or pull request. Searches for `lazy default`, `Value.Lazy` with
`Value.Default`, `provided lazy`, `settable lazy`, and `1137` returned no pull requests. Remote
branch and repository-history searches returned no implementation. This is evidence of an
unimplemented request, not maintainer endorsement; the lack of a maintainer response remains a
repo-fit uncertainty to record honestly.

### Local uniqueness

No task plan or description under `my-work/` contains seedable/settable lazy attributes or the
`@Value.Lazy` + `@Value.Default` combination. The selected task does not reuse the public surfaces
of structural patching, exhaustive folds, binary serialization, value pointers, criteria
quantifiers, bean-to-map, or map-entry collections.

The task is adjacent to ordinary default/derived/lazy generation, but adjacency is the feature's
native seam rather than reuse of an accepted task's infrastructure.

## Current architecture and the real integration points

### Annotation semantics

- `value-annotations/src/org/immutables/value/Value.java:189-214` defines `@Value.Default` as an
  optional builder-settable value whose initializer supplies a fallback.
- `Value.java:304-328` defines `@Value.Lazy` as non-settable, synchronized, once-only computed
  state and states that it behaves as auxiliary.
- `AccessorAttributesCollector.java:364-445` classifies attributes. Lines 435-441 explicitly
  reject a lazy attribute that is also default or derived.

This diagnostic is the visible gap, but deleting it is not the solution. The model currently
assumes the categories are disjoint. A successful solution must also update the public annotation
Javadoc that currently says Lazy attributes cannot be set. Documentation is required API work but
does not count toward effective production LoC.

### Attribute model

- `ValueAttribute.java:222-235` makes abstract/default attributes settable and lazy attributes
  gettable. Its `isIgnorable()` flag belongs to Datatype feature generation; it is not what keeps
  Lazy out of equality or serialization.
- `ValueType.java:905-913` builds `settableAttributes` from abstract/default flags only.
- `ValueType.java:973-980` builds a separate lazy list.
- `ValueTypeComposer.java:234-244` gives Lazy a separate logical duplicate-detection namespace by
  appending `$lazy`; actual generated storage naming and disambiguation occur in
  `Immutables.generator:1374-1433`, including `disambiguateFieldRep`.

A correct solution should introduce an explicit hybrid classification or equally clear model.
Leaving both old flags active risks duplicate fields/accessors, eager default construction, and
leaking auxiliary lazy state into equality, rendering, or marshaling.

Pure Lazy is absent from `implementedAttributes`, which in turn keeps it out of equivalence and
generated marshaling lists. Once the hybrid becomes settable/implemented, the solution must
preserve those exclusions deliberately rather than relying on `isIgnorable()`.

### Generated lazy state

`Immutables.generator:1374-1433` emits:

- transient value fields;
- volatile initialization bitmaps;
- synchronized double checks;
- one successful memoized value; and
- retry after an exception or `Error`, because the initialized bit is set only after the
  initializer returns.

The hybrid should reuse those guarantees without confusing “initialized” with “explicitly
seeded.” At least two independent bits or an equivalent state representation are needed
conceptually, even if template code packs them efficiently.

### Builder, construction, and copy paths

- `Immutables.generator:1330-1369` implements `copyOf` and builder-based copying.
- `Immutables.generator:1640-1684` defines tracked attribute groups and bit constants;
  `2025-2028` and the setter families around `2307-2424` update set state.
- `Immutables.generator:2722-2747` implements optional whole-builder clearing.
- `Immutables.generator:3159-3240` declares stored attributes and constructs them from builders.
- `Immutables.generator:3371-3415` implements the safe default/derived construction shim.
- `Immutables.generator:4160-4177` reconstructs immutable copies.
- `Immutables.generator:4180-4520` emits the attribute with-method families.

These paths currently treat a default as ordinary stored value and a lazy as no constructor
input. A seedable lazy value needs provenance-aware treatment rather than either existing path.

### Modifiable boundary

Pure Lazy is normally absent from `implementedAttributes`, so a Modifiable inherits the concrete
accessor and naturally recomputes. `Modifiables.generator:473-530` nevertheless contains a Lazy
branch; a settable hybrid would make that previously dormant path relevant. A hybrid modifiable
attribute should return its explicit seed when set and otherwise retain non-caching behavior, but
checked throws and conversion/unset paths must be resolved before Modifiable is retained in scope.

## Proposed behavioral contract

This contract is provisional until the reference spike proves it coherent. Once tests or the
description pin a choice, record it in the ledger and keep all four surfaces aligned.

### Activation and public shape

1. A non-abstract, non-final accessor carrying both `@Value.Lazy` and `@Value.Default` is one
   seedable lazy attribute.
2. The generated builder exposes the normal public mutation shape for the corresponding legal
   Default attribute, but the attribute is optional: omitting it does not make `build()` fail. W1
   must decide whether collection/map `add`, `addAll`, `put`, and related mutators all establish
   explicit seed provenance, as their direct setter does, or whether those shapes are explicitly
   ineligible. The repository-native preference is that every generated mutation for an eligible
   attribute seeds it; do not leave this implicit or use container cases merely to gain LoC.
3. The generated immutable accessor remains auxiliary like ordinary `@Value.Lazy`: its cached or
   seeded state is not part of equality, hash code, or string rendering, and merely observing those
   operations must not force the initializer.
4. Ordinary `@Value.Lazy`, ordinary `@Value.Default`, and `@Value.Derived` behavior must remain
   unchanged. `@Value.Lazy` + `@Value.Derived` remains invalid.

Do not add a third annotation. The upstream request and current API already provide an intuitive
composition. A new `@LazyDefault` API would add surface without resolving provenance.

### Immutable state machine

| State | Origin | Access behavior | Copy meaning |
| --- | --- | --- | --- |
| Cold fallback | Builder supplied nothing, or a computed fallback was invalidated for a modified copy | First successful access invokes initializer; failures leave it cold | Remains cold without forcing source |
| Computed fallback | Initializer returned successfully | Subsequent access returns the memoized result | Does not become an explicit override; a modified copy resets it to cold |
| Explicit seed | Builder or the attribute's own with-method supplied a value | Returns seed without invoking initializer | Survives unrelated with-copies and generated-instance builder copying |

The initializing interval is an implementation concern, but public behavior must retain ordinary
lazy thread safety: concurrent first access publishes one successful result, and a thrown checked
or unchecked exception or `Error` is not memoized.

Explicit values must not be inferred from their content. `null` where permitted, primitive zero,
`false`, an empty optional, and an empty collection are explicit seeds when their setters were
called. If collection/map incremental mutators remain eligible, even the first empty bulk mutation
must follow the frozen explicitness rule. Existing builder set bits are likely reusable, but tests
must assert behavior rather than field layout.

### Construction and direct access

| Operation | Required outcome |
| --- | --- |
| Build without setter | Does not invoke initializer; result begins cold |
| Build after setter | Records an explicit seed; initializer is never invoked for that instance |
| First cold access succeeds | Invokes initializer once and memoizes result |
| First cold access throws an exception or `Error` | Leaves value cold; a later access retries |
| Concurrent cold access | Publishes one successful value to all callers |
| Attribute with-method | Creates explicit provenance and does not invoke the initializer, even when supplied content equals a computed fallback |

### Provenance through copies

The following rules are central difficulty, not optional edge cases:

1. A with-method for another attribute must never call a cold seedable-lazy accessor merely to
   populate the new instance.
2. An explicit seed survives an unrelated with-copy.
3. A fallback, whether still cold or already computed, is cold in a modified copy. This lets its
   initializer observe changed ordinary attributes and prevents a computed value from silently
   becoming a caller override.
4. `toBuilder()` and the generated fast path of `builder.from(generatedInstance)` preserve an
   explicit seed, preserve coldness without forcing it, and treat a computed fallback as fallback
   provenance rather than as an explicit seed.
5. For a generated source whose hybrid is fallback/unseeded, merge-style `builder.from(source)`
   treats the hybrid as absent and leaves any seed already present in the target builder intact. A
   fresh `toBuilder()` therefore remains cold without forcing the source.
6. When any generated transfer receives an arbitrary external implementation, provenance cannot
   be observed. The preferred provisional rule is to treat the hybrid like ordinary Lazy and not
   read/copy it. This applies to `builder.from(...)` and direct `copyOf(external)` styles that do
   not route through builder-from. It preserves coldness and checked-exception Lazy accessors. Any
   different rule requires an explicit throws-aware design across every generated copy API before
   tests pin it; alternatively reject the incompatible style clearly.
7. `copyOf` retains its existing identity shortcut for an already generated immutable instance.
   It need not create a new instance merely to exercise lazy state.
8. A style-generated whole-builder `clear()` removes seed state and returns the builder to the
   cold fallback state.

Existing no-op withers may return `this`. A computed fallback remains computed when no new instance
is created. The reset-to-cold rule applies to a genuinely modified copy. Conversely, the hybrid's
own wither must not return `this` merely because a computed fallback equals the supplied value:
that call changes provenance to explicit, which a later unrelated copy must preserve.

Do not implement dynamic dependency tracking. Resetting fallback provenance on a modified copy is
safe, deterministic, and consistent with ordinary per-instance lazy computation.

### Modifiable and persistence boundaries

If Modifiable remains in the frozen contract:

1. A generated modifiable companion returns an explicit seed when set.
2. When unseeded, its accessor follows current modifiable-lazy behavior and computes without
   immutable memoization.
3. Changing another modifiable field does not convert a computed result into stored seed state.
4. If Modifiable remains in scope, specify `unsetX()`, `toImmutable()`, immutable
   `builder.from(modifiable)`, and Modifiable `from(generated/external)` as well as direct access.
   An unseeded conversion must not silently invoke a checked-exception accessor and turn fallback
   output into an explicit immutable seed.
5. Persistence is unresolved until W1 characterizes the generated paths. Treat computed fallback
   cache state, caller-provided seed state, simple Java serialization, structural Java
   serialization, generated Gson/OkJson adapters, and reflective Jackson as separate decisions.
   Ordinary Lazy is precedent for transient runtime cache state, while Default is precedent for
   persisted caller input; neither settles the hybrid automatically. Simple Java serialization
   can reset transient Lazy fields, but structural serial forms iterate settable attributes and
   can force/read them. Generated Gson/OkJson omit pure Lazy, while reflective Jackson normally
   discovers and invokes its public accessor. Retain only a coherent, explicitly described policy,
   or de-scope the unsupported persistence variants before artifact construction.
6. Identity and rendering remain ordinary-lazy behavior unless source evidence disproves that
   composition: seed/cache state is auxiliary and observing equality, hash, or string rendering
   must not force initialization.
7. Interning/canonicalization is a mandatory compatibility decision, not a silent out-of-scope
   label. Equal objects can carry different auxiliary seeds, and interning can return a previously
   canonicalized instance. W1 must choose and test a repository-native rule—such as the existing
   auxiliary first-canonical-instance semantics or a clear diagnostic for the combination—and
   reconcile it with every blanket seed guarantee in the final description. Do not add seed state
   to value identity or mutate an existing canonical object merely to preserve a later seed.

The final description may use a shorter general rule only when it accurately covers the retained
surfaces. “Ordinary lazy auxiliary behavior” is enough for identity/rendering, but it is not a
universal JSON rule. The tests must protect every integration the final contract actually keeps.

The immutable core is activation, optional explicit seeding, cold fallback, successful lazy
publication/retry, explicitness for sentinel values, and native immutable copy provenance.
Collection mutation APIs, whole-builder clear, arbitrary external `from`, Modifiable, Java
serialization, JSON, and interning are conditional integration surfaces. Characterize each early;
include it only when the supported feature necessarily crosses it and the behavior can be stated
fairly. Gate B counts only the final frozen contract. If the honest core and necessary native
surfaces are too small, kill the idea rather than promoting optional integrations for size.

“Excluded” cannot mean allowing a generator path to emit undefined behavior. If W1 does not retain
Modifiable or collection/map mutation support, the eligibility model must reject the annotation
pair clearly for those configurations (or suppress the incompatible generated API under an
equally clear, repository-native rule). The same principle applies to any style whose direct
external `copyOf` path cannot honor the chosen no-read/throws contract.

## Independent architectural decisions

The task earns its difficulty only if the final reference and suite preserve these independent
axes:

1. **Hybrid classification:** recognize the annotation composition without enabling
   `Lazy+Derived` or corrupting default/derived counters.
2. **Explicitness tracking:** distinguish unset from seeded values for primitives, nullable values,
   and empty containers/optionals.
3. **Lazy publication:** retain synchronized successful memoization and retry-on-failure.
4. **Provenance-aware copies:** preserve explicit seeds, reset computed fallbacks, and never force
   cold values.
5. **Generated builder transfer:** `from` and `toBuilder` preserve provenance for generated
   instances while defining the arbitrary-implementation boundary.
6. **Conditional Modifiable semantics:** if retained, set/unset and every conversion path preserve
   the frozen seed/fallback rule without applying immutable caching.
7. **Adjacent-behavior isolation:** pure Lazy, pure Default, Derived, identity, rendering, and each
   retained persistence behavior remain unchanged.
8. **Namespace safety:** any storage or state name introduced specifically for seed provenance is
   disambiguated from legal user attributes. Do not require repair of the pre-existing pure-Lazy
   `lazyInitBitmap` collision as part of this task.
9. **Canonicalization boundary:** interning either follows one explicitly stated existing
   auxiliary rule or rejects the unsupported combination without changing value identity.

If a spike reduces most of these to one flag and one accessor template, the idea is too easy even
if the test matrix is long.

## False-positive threat model and contract closure

| Wrong architecture | Positive control | Fair discriminator | Golden expectation |
| --- | --- | --- | --- |
| Treat hybrid as eager Default | Explicit seed works | Counter proves unseeded build does not initialize | Cold until access |
| Treat hybrid as non-settable Lazy | Cold access works | Builder setter and own with-method seed without computation | Seed returned |
| Use value/null as the set sentinel | Non-null reference works | Explicit nullable null, zero/false, and empty optional/container | All remain explicit |
| Copy lazy field/bitmap blindly | Same-input copy looks fine | Compute fallback, change its dependency with a wither, then access copy | Recomputes against copy |
| Recompute or drop every value | Fallback behaves correctly | Explicit seed followed by unrelated wither/toBuilder | Seed survives |
| Copy through public getter | Final values appear correct | Cold source counter before and after wither/from | Source remains cold |
| Keep a no-op own-wither shortcut for computed fallback | Returned content looks equal | Compute fallback, call own wither with equal content, then modify a dependency | Supplied content remains an explicit seed |
| Treat unseeded generated `from` as a clearing assignment | Fresh builder works | Merge an unseeded source into an already seeded builder | Existing target seed remains |
| Read arbitrary external source | Ordinary external getter works | Checked-exception hybrid accessor through external `from` and direct `copyOf` styles | Accessor is not read under the preferred boundary, or incompatible style is rejected |
| Mark initialized before computation | Success case works | Initializer throws once then succeeds | Second call retries |
| Include hybrid in identity/rendering | Setter exists | Equal objects with different seeds; toString/hashCode before access | Equal; no initialization |
| Collapse multiple hybrids to one state bit | One attribute works | Two attributes seeded/computed independently across bitmap boundary | Independent state |
| Apply immutable caching to Modifiable | Immutable tests pass | Repeated unseeded modifiable access observes normal recomputation | No cache |
| Delete diagnostic too broadly | Hybrid works | `Lazy+Derived` and abstract/final invalid forms | Existing rejection retained |
| Hard-code new generated names | Normal fixture works | User attributes/names occupy names introduced by the hybrid implementation | Generated code compiles |
| Ignore canonicalization | Non-interned seed works | Build value-equal interned objects with distinct seed origins | Frozen interning rule holds or form is clearly rejected |
| Treat every builder API as direct setter only | Scalar seed works | Legal collection/map mutation API on a hybrid attribute | Mutation establishes the frozen provenance rule or shape is ineligible |

Every final description clause needs a row in a requirement -> test -> reference-method matrix.
Do not add a panel-discovered probe unless it is fair and the reference passes it in the same exact
state. Close the full wrong-architecture class, not the single fixture.

## Test strategy

Use repository-native `value-fixture` sources and public generated APIs. Do not assert template
text, private field names, generated source formatting, or a particular bit layout.

### Core fixture families

1. **Cold versus seeded:** deterministic counter; scalar and primitive/nullable sentinel cases.
2. **Retry and concurrency:** initializers that fail once by exception and `Error` in focused
   cases; barrier-controlled concurrent first access with an atomic count and stable object
   identity.
3. **Copy provenance:** one ordinary dependency plus a seedable lazy fallback; cold, computed, and
   explicit variants through unrelated withers.
4. **Builder transfer:** generated-instance `from`, `toBuilder`, whole-builder clear where enabled,
   and one arbitrary external implementation if that boundary remains in scope.
5. **Auxiliary boundary:** equality, hash, and toString without forcing the initializer; persistence
   and interning only when retained by the frozen contract.
6. **Conditional native surfaces:** collection/map builder mutation, clear, external `from`, and
   Modifiable only where W1 keeps them in scope.
7. **Classification and namespace:** pure annotation forms unchanged; invalid forms still fail;
   user names collide only with state introduced by the new hybrid mechanism, not known unrelated
   pure-Lazy defects.

### Test construction rules

- Generate a fresh six-hex token and use it in all new fixture/test type names.
- Prefer truth tables inside coherent tests over dozens of near-duplicate methods.
- Each new focused test must fail on the clean base for the intended missing behavior, not merely a
  changed diagnostic line number.
- Keep test and solution write sets disjoint.
- Do not hide requirements in fixture implementation. Counters and barriers are observation tools;
  the description must state the behavior they validate.
- Test both permission and rejection branches where the contract uses words such as “only,”
  “never,” or “remains.”
- Include baseline suites chosen by repository precedent; do not silently shrink baseline coverage
  to make verification cheap.

## Effective-LoC Gate B

Before writing the final description, Dockerfile, or full hidden suite, implement the smallest
complete vertical reference slice in a disposable worktree. It must include hybrid classification,
immutable seed/fallback state, builder construction, unrelated with-copy provenance, generated
`from`/`toBuilder`, and every conditional branch W1 retains in the frozen contract. Include the
Modifiable branch only if W1 keeps it as a native part of that contract. Do not count tests or
generated Java output.

Build a method-level ledger using the manager exclusions from
`my-review-workflow/rules/platform-panel.md`:

- exclude blank/comment-only lines, imports, braces/punctuation-only lines, package declarations,
  type-only declarations, export/wiring-only lines, tests, generated files, boilerplate, padding,
  and unrelated refactors;
- separate added, deleted, and substantively modified production logic;
- map every counted block to a final requirement;
- subtract any implementation for behavior the final description does not require; and
- estimate the count again after the most likely solvability de-scope.

### Expected production surfaces

| Surface | Expected task logic | Conservative range |
| --- | --- | ---: |
| `value-annotations/.../Value.java` | Public Javadoc for the supported annotation composition | required, **0 counted** |
| `AccessorAttributesCollector.java` | Hybrid recognition and diagnostics | 20-45 |
| `ValueAttribute.java` and model helpers | Explicit hybrid classification and semantic predicates | 30-60 |
| `ValueType.java` / `ValueTypeComposer.java` | Settable/lazy lists, bit/name planes, construction grouping | 20-50 |
| `Immutables.generator` core | Runtime state, builder seed, construction, withers, generated transfer provenance | 180-250 |
| `Immutables.generator` conditional | Retained collection mutation, clear, persistence, interning, or style branches | 0-50 |
| `Modifiables.generator` | Conditional seeded/unseeded and conversion behavior | 0-70 |
| **Projected strict total** | Before tests and documentation | **250-525** |

These are hypotheses, not acceptance evidence.

### Gate decision

- **GO:** conservative strict count >=325 and the reference architecture still has at least four
  independent decisions. Confirm the logic sits at its natural repository roots; file count is a
  warning signal, not a reason to spread code artificially.
- **RESEARCH MORE:** 275-324 with a clearly identified native missing branch; obtain a second count
  and prove the branch is part of the same user contract before expanding.
- **KILL:** <275, or reaching 325 requires JSON features, a new annotation, dynamic dependency
  tracking, unrelated refactors, or behavior included only to gain lines.

Planning exactly at the live 250 floor is too fragile because strict classification can push the
effective count below it. The buffer protects against the same semantic discount that blocked
criteria quantifiers; 325 and the four-decision check are author-side safeguards, not different
platform thresholds.

## Solvability and pass-rate calibration

No pass-rate claim exists for this new idea. Do not infer one from reference size or from the
accepted Immutables tasks.

### Gate C — Early ease/fairness warning before full artifacts

1. Build the full contract-closure threat matrix and a few minimal characterization probes for its
   highest-risk wrong architectures. The complete executable mutation panel belongs in W5 after
   the hidden suite exists.
2. Verify the reference passes those probes and that each clean-base probe observes the intended
   missing behavior.
3. After the reference spike and a draft public description, ask one or two fresh strong agents to
   implement in isolated clones. Give them only the repository and draft description; do not leak
   this plan, reference architecture, ledger, or hidden tests.
4. If both rapidly converge on the same small flag/template change, trigger an independent
   architecture review or a small mixed-capability confirmation. Bench/redesign only if that
   second signal confirms a one-insight task likely to exceed the live limit. If both hit the same
   wall, audit fairness before building the hidden suite.
5. Any simplification, redesign, eligibility change, or contract de-scope returns to W1 and must
   rerun Gate B before W4; never reuse a stale LoC count.
6. If candidate-run infrastructure is available, use a mixed capability sample and record actual
   model tiers. Capability generally rises Nova < Orion < Vega < Castor, but tier names are context,
   not verdicts.
7. Inspect the first architectural commitment in every patch, not only its final failing test.

### Target interpretation

- Desired first-round band: 1-3 legitimate passes per 10 fresh runs.
- 0 legitimate passes: identify a shared architectural wall and simplify one central obligation;
  do not expose hidden fixture checklists or weaken FP boundaries.
- 4/10: at the live ceiling; do not add prose hints or optional breadth before the fresh FP panel.
- >4/10: the concept or description is too recognizable. Do not stack decorative type examples;
  determine whether an independent native boundary is missing or bench the task.

Saved-candidate replay can validate a new discriminator only after candidates exist. It never
replaces a fresh population, as map-entry collections demonstrated.

## Execution roadmap

### W0 — Re-establish authority and exact state

- Read `prompt.md` and this plan completely.
- Read all current sources listed in the handoff prompt, respecting the authority order in
  `.agent/rules/false-positive-calibration.md`.
- If this task directory has no `.git`, initialize a task-local repository before durable work;
  never absorb it into or mutate a parent/shared repository.
- Record the base SHA, upstream SHA, issue state, PR/branch searches, local overlap search, and
  shared workspace status in an append-only ledger.
- Confirm `repos/immutables` is clean and treat it as read-only.

### W1 — Architecture dossier and contract freeze

- Trace all settable, lazy, builder, copy, modifiable, serialization, and naming paths named above.
- Generate real current output for representative pure Lazy and pure Default fixtures.
- Write the state-transition table, requirement/test/production matrix, expected write set, and
  explicit out-of-scope list.
- Resolve collection/map mutation APIs, generated and arbitrary-source `from`, direct external
  `copyOf` styles, checked throws, whole-builder clear, Modifiable conversions/unset, simple and
  structural Java serialization, generated Gson/OkJson, reflective Jackson, interning,
  constructor-style, and encoding boundaries before tests pin them. Classify each as core,
  necessary native integration, or explicitly rejected/excluded.

### W2 — Minimal reference spike and Gate B

- Use a uniquely named detached worktree or temporary clone at the exact base.
- Implement the narrow complete reference without task tests or cleanup refactors.
- Add only enough local characterization tests to prove the state transitions.
- Run targeted compilation/tests, then produce the strict method-level LoC ledger.
- Stop immediately on a KILL result and report evidence; do not continue from sunk cost.

### W3 — Run early Gate C

- Draft only the concise public description needed for one or two zero-context dry runs.
- Record time-to-insight, first architecture, changed surfaces, and genuine blockers.
- Confirm a rapid one-insight convergence through independent architecture review or a small
  mixed-capability sample before benching/redesigning.
- Return to W1 and rerun Gate B after any contract, eligibility, simplification, or design change.
- Do not construct the hidden suite merely to rescue sunk cost.

### W4 — Author canonical artifacts

Only after GO:

- draft a concise behavior-first description;
- author repository-native hidden tests and `test.sh`;
- produce a clean, minimal solution patch from the exact base;
- create the base-commit file and pinned Dockerfile following current JVM precedents;
- keep the append-only ledger current; create `commit-message.txt` only when the user explicitly
  requests a checkpoint and then follow the current workflow;
- ensure no prompt, hidden-test, reference, or token leakage.

Expected canonical names:

```text
BASE_COMMIT-seedable-lazy.txt
Dockerfile-seedable-lazy
immutables-seedable-lazy.md
test-seedable-lazy.patch
solution-seedable-lazy.patch
```

These five files are the platform submission artifacts. The plan, prompt, ledger, verification
logs, reports, and agent-run records are internal evidence. `BASE_COMMIT-seedable-lazy.txt` must
contain the exact SHA on line 1 and `https://github.com/immutables/immutables` on line 2.

Do not fabricate auto-review, AI-evaluation, precheck, false-positive, or human-review artifacts.
Those files exist only after the corresponding external checks run on exact recorded hashes.

### W5 — Local artifact gates

- Use `git add -N` for intended untracked files before binary diff, patch, or hash comparisons.
- independent and combined `git apply --check` at the exact base;
- whitespace and `git diff --check`;
- test/solution path-disjointness audit;
- executable `test.sh` mode and selector/exclusion audit;
- ASCII and forbidden-token/leakage scans;
- base-green/new-red causality audit for each focused test;
- reference completeness and no unrelated production changes;
- strict LoC recount against the final contract, not the spike's broader code.

### W6 — One stable remote verification batch

Read `standards/HYBRID-CLOUD-WORKFLOW.md` completely. Keep edits and durable evidence local. Choose
one mapped account explicitly, confirm its forge is idle, and run
`scripts/verify-remote.sh <task-dir> --account <login>` from the `Shipd - Olympus` root only after
the bytes are stable.

Required four states:

| State | Expected |
| --- | --- |
| base + tests | baseline pass |
| new + tests | focused fail for missing feature |
| base + tests + solution | baseline pass |
| new + tests + solution | focused and baseline pass |

Use task-owned namespaces and output paths, copy XML/evidence back locally, remove only this task's
disposable remote data, never run broad Docker prune, and stop the forge only when no other task is
using it.

### W7 — Fresh solver and FP calibration

- Run the mutation panel before spending platform tokens.
- Run fresh solver population(s) only against the final concise description.
- Import exact run IDs, tiers, patch hashes, trajectories, and XML; cluster architecture families.
- Review every nominal passer as provisional and run fair four-state FP discriminators.
- Change description/tests/reference as one contract when a genuine spec gap is found.
- Freeze exact hashes before each external review and never mix reports from different rounds.

### W8 — Reviewer simulation and submission readiness

- Re-run current auto-review/precheck workflows against the exact final artifacts where available.
- Perform an independent human-style bug hunt, coverage matrix, repo-fit check, effective-LoC
  review, and prose concision pass.
- Verify at least one legitimate pass, <=40% pass rate, successful-run medians >=250 LoC, >=40
  messages, >=2 files, no unfair/environment blocker, and a passing FP evaluation.
- Treat final platform checks and manager approval as external facts; do not self-certify acceptance.

## Description drafting guardrails

The eventual description should be shorter than this design document and state observable
invariants, not template mechanisms. It should include:

- activation through the annotation pair;
- optional builder seed versus cold lazy fallback;
- successful memoization and retry after failure;
- explicit-seed versus fallback copy provenance;
- the generated-instance `from`/`toBuilder` rule;
- ordinary Lazy auxiliary behavior and unchanged neighboring annotation forms; and
- every retained conditional boundary such as collection mutation, Modifiable, persistence, or
  interning.

It should not enumerate every scalar/container fixture, prescribe bitmaps or field names, mention
agent behavior, quote hidden tests, or teach the implementation. Every test-pinned choice must
nevertheless be inferable from it.

### Provisional title

**Allow builder-provided seeds for lazy Immutables attributes**

### Provisional concise contract sketch

> Support non-abstract value accessors annotated with both `@Value.Lazy` and `@Value.Default`.
> Their generated builder attribute is optional. A supplied value is an explicit seed returned
> without running the initializer; otherwise initialization is deferred until first access and
> follows ordinary lazy memoization and retry behavior. Generated copies preserve explicit seeds
> without forcing cold attributes, while fallback values remain fallbacks and recompute in a
> modified copy. Generated `from` and `toBuilder` operations preserve the same distinction. The
> attribute otherwise remains auxiliary like an ordinary lazy attribute, and existing Lazy,
> Default, and Derived behavior is unchanged.

This sketch is not a final submission description. Refine it only after W1/W2 resolve the named
boundaries.

This plan remains an immutable historical handoff. Timestamped, evidenced decisions in the ledger
supersede its provisional contract choices; current platform authority supersedes both. A
superseding ledger entry must explain the source evidence and update description, tests, solution,
and threat matrix together.

## Hard kill rules

Stop and report rather than force the task if any of these becomes true:

1. Upstream master, a public PR/branch, or another local submission implements the same feature.
2. A maintainer rejects the composition or directs users to an existing supported mechanism.
3. The minimal final-contract reference is below 275 strict meaningful production lines, or below
   325 without a native missing branch.
4. The only path to size is a new annotation, unrelated JSON/serialization features, dynamic
   dependency tracking, or refactoring churn.
5. Copy provenance cannot be expressed behaviorally without inspecting generated internals.
6. A coherent reference requires changing ordinary Lazy/Default/Derived semantics.
7. Seed provenance cannot be reconciled with interning/canonicalization without making auxiliary
   seed state part of value identity or mutating an existing canonical object.
8. All fresh capable solvers converge on one mechanical flag/template implementation, or no
   legitimate solver can pass after one evidence-based simplification.
9. A fair FP discriminator requires behavior the reference cannot support or the description
   cannot state naturally.

## Definition of foundation success

This directory currently succeeds only as a handoff foundation. The task becomes submission-ready
later when the next agent has:

- passed repo-fit, uniqueness, and Gate-B checks;
- passed the early Gate-C ease/fairness warning check;
- frozen a coherent final contract and out-of-scope list;
- built canonical description/test/solution/base/Docker artifacts;
- passed exact local and remote four-state verification;
- demonstrated a conservative strict golden LoC margin;
- calibrated a fresh nonzero <=40% legitimate pass rate;
- adjudicated every nominal passer with no confirmed false positives;
- cleared current automated and human-style review findings; and
- left exact hashes, run IDs, evidence, and remaining external status in the ledger.

Until then, this plan is a decision record, not evidence that the task already meets platform
criteria.
