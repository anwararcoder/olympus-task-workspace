# MapStruct Inherited Super Mappings — Task Foundation

_Foundation audit: 2026-07-24. This is a measured design and execution gate, not a
submission artifact or a reference patch._

## Decision

Proceed as the sole new MapStruct foundation, paired with
`jte-transactional-jsp-batch`. Keep `vineflower-duplicate-class-resolution` as the
backup if platform repo-exhaustion or similarity checks block MapStruct.

The selected feature is the maintainer-proposed
`@BeanMapping(inheritSuperMappings = true)` behavior from MapStruct issue #3403. It
allows an overriding mapper method to reuse property mappings declared on the methods
it overrides. The hard form is not “look at the immediate parent and append its
annotations.” It must recover declarations hidden by MapStruct’s current method
collection, resolve generic and transitive Java override relationships, rebind renamed
source parameters, and merge multiple inheritance branches deterministically.

This foundation passed a compiling implementation probe. The public-history refresh
was repeated on 2026-07-24. It remains conditional on platform
repo-fit/similarity preflight, a strict final LoC count, and early agent calibration.

## Repository and pinned state

| Item | Value |
| --- | --- |
| Repository | `https://github.com/mapstruct/mapstruct` |
| Default branch | `main` |
| Pinned SHA | `947296e59f047826e3738a698cc12bda6415d33b` |
| Commit date | `2026-07-23` |
| License | Apache-2.0 |
| Open design issue | `https://github.com/mapstruct/mapstruct/issues/3403` |
| Confirming discussion | `https://github.com/mapstruct/mapstruct/discussions/3712` |
| Accepted Docker reference hash | `045350f5c216e79a809e6d2321458530e7ce13d8b367cc709b68a8c9dbb62cd3` |

The 2026-07-24 refresh found issue #3403 still open, last updated on
2023-12-25, with no linked branch or pull request. Exact repository code search for
`inheritSuperMappings` returned no result. Exact and broad issue/PR searches found no
implementation. The only commit after the probe base was #4080, a JSpecify
constructor/setter nullness fix that touches no inheritance machinery. Closed PR
#3869 is adjacent evidence: it attempted most-specific selection for ordinary
configuration inheritance but was abandoned after its distance calculation proved
source-order-dependent. It does not implement this API or behavior.

Search absence is time-bound evidence. Repeat the exact search immediately before
uploading submission artifacts.

## Why this belongs in MapStruct

Issue #3403 records the current behavior: when a mapper redeclares an inherited
mapping method, MapStruct sees the overriding method but does not retain the
overridden method’s property mappings. A MapStruct member explicitly proposed a
`BeanMapping` switch, showed that current declarations must override inherited ones,
and later preferred the name `inheritSuperMappings`.

Discussion #3712 independently reaches the same use case. The maintainer:

- says Java’s `@Inherited` does not implement method-annotation inheritance;
- points to issue #3403;
- names `@BeanMapping(inheritSuperMappings = true)` as the intended enhancement; and
- confirms the rename-and-`@InheritConfiguration` workaround is not equivalent for
  the requested override shape.

This is therefore not a synthetic API invented only to enlarge a task. The public
surface, default, location, and child-wins rule all come from maintainer direction.

## Neutral overlap audit

### Public work

No pull request, branch, release note, or commit implements issue #3403. Broad “super
mapping” searches returned unrelated generic-bound and mapper-configuration work, not
overridden-method property inheritance.

Adjacent public work does not implement the selected behavior:

- issue #478 concerns selecting a declaring class for ambiguous
  `@InheritConfiguration`;
- issue #3611 concerns mapper-config/generic inverse ambiguity;
- PR #463 introduced prototype-method inheritance from `@MapperConfig`;
- discussion #3737 concerns parent/child model mapping complexity; and
- discussion #3712 is confirming design evidence, not an implementation.

The executor must kill the task if equivalent public code appears. An API rename does
not cure overlap.

### Local accepted work

The local portfolio now has four accepted MapStruct tasks:

1. `mapstruct-bean-to-map`
2. `mapstruct-map-entry-collections`
3. `mapstruct-multi-source-methods`
4. `mapstruct-configurable-collection-implementations`

None copies property mappings from Java methods hidden by overriding.

There is adjacent machinery:

- `mapstruct-multi-source-methods` extends ordinary forward/inverse configuration
  inheritance for a new ordered source tuple;
- `mapstruct-map-entry-collections` verifies inherited mapper method discovery across
  collection families; and
- the configurable-collections task changes processor-wide implementation-type
  selection and construction consumers.

Those patches do not add this API, reconstruct overridden declarations, apply
nearest-declaration precedence, rebind overridden parameter positions, or resolve
diamond branches. The execution fork must still run the platform similarity preflight
with the concise description before producing a golden patch.

## Rejected MapStruct alternatives

| Candidate | Decision |
| --- | --- |
| subtype-local `@SubclassMapping` mappings, issue #3655 | Reject: the accepted multi-source ledger records a compiling 129-line meaningful spike; adding `Mapping[]` and passing existing options is too direct |
| generic wrapper mapping, issue #2377 | Reject: a maintainer’s public fork and related merged generic work create overlap and unsettled semantics |
| exact numeric conversion, issue #4017 | Reject: maintainer direction argues against the requested runtime exact-conversion behavior |
| collection-strategy override, issue #3708 | Reject: public PR #3935 implements the area |
| default source values, issues #3798/#2436 | Reject for now: public PR #4014 overlaps part of the behavior and the remaining boundary lacks clear owner direction |
| parallel immutable-source mapping, issue #4066 | Reject: no maintainer validation and it repeats the immutable-update direction risk |

The new foundation must not absorb rejected candidates merely to raise its line count.

## Draft public task description

The platform-facing preflight draft is
`mapstruct-inherit-super-mappings-draft.md`. It is deliberately not the final
submission description.

Before tests are written, the executor must refresh public state, confirm the API and
semantics against current MapStruct, audit each sentence against the frozen contract,
and validate it under the current description, fairness, repo-fit, and similarity
rules. Tighten wording only when no tested requirement is lost, and do not turn the
final prose into an implementation checklist.

## Frozen behavioral contract

### Public API

- Add `BeanMapping.inheritSuperMappings()` with default `false`.
- It is opt-in per generated bean mapping method.
- The default path must be byte-for-byte behaviorally compatible.
- Using the option without any overridden mapping method is a compilation error.

### What is inherited

- Inherit property-level `@Mapping` declarations directly declared on overridden
  methods.
- Include repeatable containers and existing mapping compositions/meta-annotations.
- Traverse interface and superclass chains transitively.
- Process a shared common ancestor once.
- Do not implicitly copy the ancestor’s `@BeanMapping`, `@IterableMapping`,
  `@MapMapping`, `@ValueMapping`, or `@SubclassMapping` options.
- Existing forward/inverse/automatic configuration inheritance keeps its normal
  semantics and fills only targets still not selected by local or super mappings.

### Override recognition

- Use Java override semantics, not method name alone or erased-signature text alone.
- Resolve generic members in the context of the concrete mapper.
- Static, private, unrelated overload, and merely same-named methods do not
  participate.
- Abstract mapper-interface and superclass declarations are valid ancestors when the
  concrete mapping implementation is generated by MapStruct.
- Work under both javac and ECJ.

### Source rebinding

- For a qualified inherited source such as `left.address.city`, identify `left` in
  the overridden signature.
- Bind it to the overriding parameter at the same Java signature position.
- Preserve `.address.city`.
- This is deterministic even when two source parameters have the same type and both
  are renamed.
- Unqualified one-source property paths retain normal MapStruct resolution.
- Raw `expression`, `defaultExpression`, and `conditionExpression` Java strings are
  copied verbatim rather than token-rewritten.

### Target precedence

For each exact target path:

1. a mapping declared on the current method wins;
2. otherwise a declaration on a more specific ancestor wins;
3. disjoint targets from incomparable branches combine; and
4. competing same-target declarations from incomparable branches are rejected until
   the current method resolves that target.

Additional rules:

- `ignore = true` is a real current/ancestor declaration for precedence.
- A redundant direct reference to an ancestor does not make its declaration compete
  with a more specific subtype declaration.
- A diamond’s shared declaration is not duplicated.
- `target = "."` is not one concrete target and therefore accumulates using existing
  forward-inheritance behavior.
- Diagnostics require semantic fields, not one exact sentence.

## Architecture trace

The feature crosses independent MapStruct ownership points:

1. `core/.../BeanMapping.java` owns the public switch and documentation.
2. generated Gem access exposes the new member to the processor.
3. `BeanMappingOptions` validates and reads the flag.
4. `AbstractElementUtilsDecorator#getAllEnclosedExecutableElements` currently removes
   overridden declarations. The feature cannot recover parent annotations from the
   ordinary method list.
5. `MethodRetrievalProcessor` must walk declared methods in the actual generic
   supertype graph and use compiler override semantics.
6. inherited declarations need their own source model with the mapper’s concrete
   generic substitutions.
7. `MappingOptions`/source-reference inheritance must translate parameter names by
   override position without rewriting nested property paths.
8. `MapperCreationProcessor` must merge exact target paths with local, subtype,
   distance, diamond, and incomparable-branch rules.
9. existing `@InheritConfiguration` and inverse processing must remain ordered and
   fill-only.
10. `Message`/messager integration must attach useful no-super and branch-ambiguity
    diagnostics to the current method/annotation.

An implementation that changes only annotation retention or only the method collector
cannot satisfy this graph.

## Measured minimum implementation probe

A disposable probe was built from the earlier SHA
`7ad5f9e56e9896c8f165d509b0cff8916061e85e`. It is evidence only and must not be
copied as the golden solution. The live pinned SHA is one unrelated commit ahead.

The final bounded probe implemented:

- the public flag and option parsing;
- explicit hierarchy traversal for hidden overridden methods;
- generic member resolution;
- transitive nearest-first property mapping inheritance;
- local target precedence;
- same-distance branch ambiguity reporting;
- more-specific declaration selection in redundant hierarchies;
- common-ancestor deduplication;
- `target = "."` accumulation;
- source-prefix rebinding by override parameter position; and
- dedicated property-only merging that does not copy unrelated mapping-method
  options.

Measured production diff:

- 443 insertions and one deletion;
- nine production files;
- 378 meaningful lines under the repository’s lenient `count_loc.py`;
- 289 lines under a stricter nonblank, noncomment, nonimport, nonbrace screen; and
- no test lines included.

Verification:

```text
./mvnw -q -pl processor -am -DskipDistribution=true \
  -DskipTests -Dlicense.skip=true compile

./mvnw -q -pl processor -am -DskipDistribution=true \
  -Dlicense.skip=true -Dtest=SuperMappingInheritanceTest \
  -Dsurefire.failIfNoSpecifiedTests=false test
```

Both passed. The focused suite ran six compiler invocations with zero failures:

- generic Root → Intermediate → Concrete inheritance;
- a local mapping overriding an inherited target;
- two same-type source parameters renamed on the overriding method; and
- disjoint property mappings combined from a diamond’s two branches;
- each positive shape under javac and ECJ.

The probe omitted production documentation beyond the API Javadoc, the full negative
matrix, inherited configuration interplay tests, flattening tests, superclass
fixtures, overload negatives, and broad regressions. The strict final manager count
must be recomputed. If the real solution falls below the live 250-line floor after all
exclusions, kill or naturally rescope the candidate; do not pad it.

## Shortcut audit

| Shortcut | Why it fails |
| --- | --- |
| add Java `@Inherited` to `@Mapping` | `@Inherited` applies to class annotations, not overridden method annotations; the maintainer explicitly rejected this assumption |
| call existing `getAllEnclosedExecutableElements` | it deliberately removes overridden declarations, so the annotations to copy are already gone |
| look only at the immediate parent | misses transitive mappings, generic intermediate redeclarations, and common ancestors |
| match name and erased parameters | accepts unrelated overloads and loses generic substitutions; compiler override rules are required |
| copy annotation mirrors as strings | does not integrate mapping compositions/options and cannot rebind renamed parameters safely |
| use current forward inheritance unchanged | same-type renamed multi-source parameters fall back to names and become ambiguous |
| append every ancestor in traversal order | makes branch order observable and silently selects one competing target |
| globally choose shortest distance only | redundant inheritance can make a less-specific ancestor appear equally near |
| merge each binary method independently | duplicates a common diamond ancestor and can report false conflicts |
| copy all mapping-method options | expands the feature beyond property mappings and changes unrelated Bean/Iterable/Map/Subclass behavior |
| require callers to rename the override | reproduces the verbose workaround the maintainer identified as not equivalent |

Every shortcut rejection must be observable in tests. Do not assert private helper
names or one implementation architecture.

## Test design

Use two collision-resistant top-level test classes:

- `InheritSuperMappingsK7p4Test` for successful behavior and runtime/generated-source
  assertions;
- `InheritSuperMappingsErrorsK7p4Test` for isolated compilation failures.

The future task runner must select and exclude these names. If the executor changes
them, update the runner, fixtures, and excludes atomically during submission
construction.

### Positive matrix

1. option defaults to false and ordinary override behavior remains unchanged;
2. direct interface override inherits one property mapping;
3. current explicit mapping replaces the same inherited target;
4. current `ignore = true` replaces an inherited target;
5. transitive root/intermediate/current mappings merge nearest first;
6. a generic mapper hierarchy is resolved in the concrete type context;
7. one renamed source parameter is rebound by position;
8. two same-type renamed source parameters are rebound without name ambiguity;
9. nested source suffixes survive rebinding;
10. disjoint mappings from two diamond branches combine;
11. a shared diamond ancestor contributes once;
12. a more-specific declaration beats a redundantly referenced ancestor;
13. a local target resolves otherwise competing branch mappings;
14. multiple `target = "."` declarations accumulate;
15. composed `@Mapping` declarations are inherited;
16. existing explicit `@InheritConfiguration` fills a still-unmapped target after
    super inheritance;
17. a parent `@BeanMapping` member is not copied implicitly;
18. an inherited raw Java expression remains verbatim when parameter names are
    preserved; and
19. an abstract superclass declaration works in addition to interfaces.

### Negative matrix

1. the flag on a method with no overridden mapping method;
2. incomparable nearest branches mapping the same target;
3. an unrelated same-name overload is not treated as a super mapping;
4. a renamed parameter referenced from a raw Java expression demonstrates existing
   verbatim-expression behavior without an invented rewrite guarantee; and
5. invalid inherited source/target paths retain normal MapStruct diagnostics.

Do not combine independent invalidities in one fixture. The accepted configurable
collections history showed that a multiply invalid type plus a cause-word regex can
turn genuine implementations into `test_mismatch`.

## Description-to-test closure

| Public clause | Required observable cells |
| --- | --- |
| flag/default | API compilation; false-path regression |
| overridden methods only | direct override; unrelated overload negative; no-super diagnostic |
| transitive/generic | three layers; generic binding; superclass |
| local wins | explicit mapping; ignore; local branch resolution |
| most specific wins | intermediate; redundant ancestor |
| incomparable branches | disjoint merge; same-target error |
| common ancestor once | diamond root |
| parameter-position rebinding | one rename; same-type two-parameter rename; nested suffix |
| flattenings accumulate | two `target="."` ancestors |
| property mappings only | composition positive; parent BeanMapping negative |
| existing inheritance remains fill-only | combined explicit inheritance |
| verbatim expressions | stable-name positive; no rewrite assumption |
| useful errors | target and mapper identities, matched semantically |

If a test cannot map to this table, remove it or amend the public description before
agent runs.

## Fairness and false-positive controls

- Run every successful compiler fixture under javac and ECJ.
- Keep most diagnostic fixtures on the compiler where source attachment is stable;
  do not demand identical compiler presentation.
- Assert diagnostic kind plus semantic identifiers such as target and mapper names.
- Make matching case-insensitive and accept natural conflict/no-parent vocabulary.
- Do not require exact word order, punctuation, or the reference sentence.
- Each negative fixture must have one primary defect.
- Do not add a standalone focused test that passes pristine MapStruct. Fold default
  compatibility into broad `base` mode or into a feature-sensitive method.
- Treat a candidate that changes the test harness or introduces colliding fixture
  types as broken evidence, not automatically as a solver failure.
- Every passing candidate gets an adversarial false-positive review. Reproduce each
  panel probe against candidate and reference before accepting it.
- A reference-also-fails probe is a possible spec/golden gap, not an automatic
  dismissal.

## MapStruct infrastructure lesson

No Dockerfile, base-commit file, or runner is bundled with this foundation. The
foundation directory intentionally contains only the plan, draft description, and
handoff prompt.

When the execution fork constructs submission artifacts, start from the byte-identical
Dockerfile used by accepted `mapstruct-map-entry-collections`,
`mapstruct-multi-source-methods`, and final
`mapstruct-configurable-collection-implementations`:

- pinned Temurin 21.0.11 for amd64 and arm64;
- architecture-specific SHA-256 verification;
- full Maven dependency warm-up;
- offline `/opt/.m2` execution;
- clean target removal after warm-up; and
- the accepted Maven environment variables.

Its accepted SHA-256 is
`045350f5c216e79a809e6d2321458530e7ce13d8b367cc709b68a8c9dbb62cd3`.
Do not replace it because a generic scanner dislikes the extra JDK layer. Copy it only
when implementation begins; change it only for a demonstrated incompatibility, then
rerun all environment gates.

Build the later `test.sh` from the accepted runner shape:

- `base` runs the broad processor suite while excluding only the two unique task
  classes;
- `new` runs only the two focused task classes;
- reports are aggregated into platform XML;
- Maven failures before Surefire get a real fallback failure;
- temporary logs/excludes are cleaned;
- JDK 21 and offline cache settings match the image; and
- mode is `100755`.

At artifact time, ensure the test patch contains the executable runner and no
top-level file collides with a solver-created type.

## Execution gates

### Gate 0 — live uniqueness and direction

Refresh exact upstream SHA and all public searches. Inspect issue #3403 and discussions
#3712/#3737 for new comments. Stop on equivalent work or negative maintainer direction.

### Gate 1 — platform similarity

Submit the concise draft description to repo-fit, author, and similarity preflight.
Compare against all four accepted local MapStruct tasks. Stop on material duplicate
classification; do not conceal overlap by renaming the flag.

### Gate 2 — smallest hard slice

In an owned worktree, implement only:

- hidden overridden-method retrieval;
- generic transitive hierarchy;
- local/nearest/diamond selection; and
- two same-type renamed parameters.

Recompute strict meaningful production LoC with the live exclusion list. Record raw,
lenient, and strict counts. A count below the live floor is a stop, not an invitation
to add decorative validation.

### Gate 3 — contract matrix and mutation audit

Build tests from the matrix and prove that each listed shortcut fails for the intended
observable reason. Ensure test and solution paths are disjoint and every changed
source path appears in one artifact.

### Gate 4 — early calibration

Give a fresh strong agent only the clean base, public description, and normal runner.
Use the earliest permitted panel. Require:

- at least one legitimate pass;
- pass rate at or below the live 40% bar;
- successful-run medians at least 250 LOC, 40 messages, and two files;
- no unfair or test-broken run counted as difficulty; and
- substantive failure diversity beyond one diagnostic.

A zero pass rate is a blocker. An over-40% rate is also a blocker. Repair only a
demonstrated fairness/contract defect; do not invent hidden conditions.

### Gate 5 — complete and verify

Complete the bounded matrix, then use focused local verification. Run full four-state
and broad regression verification remotely under `HYBRID-CLOUD-WORKFLOW.md` once the
artifacts are stable. Coordinate forge ownership, avoid repeated full builds, copy
durable evidence, clean only task-owned images/directories, and shut down the forge.

### Gate 6 — reviews

Run and reconcile:

- prechecks;
- AI/holistic evaluation;
- false-positive evaluation;
- auto-review;
- any human-review feedback; and
- a final description/test/solution diff audit.

Never trade a false-positive hole against pass rate.

## Kill conditions

Kill or replace this foundation if:

- equivalent public implementation or local task overlap appears;
- maintainer direction rejects the API/behavior;
- the faithful strict golden falls below the live LoC floor;
- a small immediate-parent copy satisfies the honest description;
- branch/generic/parameter behavior cannot be specified naturally;
- the early panel exceeds 40%;
- no legitimate solver passes after fairness and environment repair; or
- the task requires exact diagnostic vocabulary to remain difficult.

Do not rescue it with subclass mappings, new collection behavior, runtime reflection,
or unrelated mapping annotations.

## Foundation done definition

This foundation has done its job when the execution fork either kills it with evidence
or produces a submission where:

- upstream uniqueness and repo fit are current;
- the description is concise and complete;
- every test maps to a public clause;
- clean base compiles with the test patch and fails only the new feature cells;
- reference passes focused and broad verification;
- javac and ECJ agree on positive behavior;
- strict meaningful production LoC clears the current floor honestly;
- at least one agent passes and no more than 40% pass;
- all failures are classified from trajectories/artifacts;
- every passer clears false-positive review; and
- no unresolved precheck, AI, auto-review, or human-review blocker remains.
