# Plan - Deterministic Duplicate-Class Resolution in Vineflower

_Foundation date: 2026-07-23. Repository:
`https://github.com/Vineflower/vineflower.git`. Pinned foundation base:
`b8273988af850e8cfb234ca08d129058502b032f`._

_Status: backup foundation, not yet a submission. Activate it only if platform
repo-exhaustion or similarity checks reject MapStruct, then repeat live public-history
and platform preflights, freeze the contract, and build the metadata-family vertical
slice before expanding tests._

## 1. Selection verdict

Add explicit, deterministic duplicate-class strategies to Vineflower while ensuring
that one metadata-defined class family is never assembled from different input
origins.

Issue #416 identifies the current behavior: the first encountered class wins, and
encounter order may depend on implementation details. A small version of the feature
would change one `putIfAbsent` call or throw on a second name. That version is not the
selected task.

The selected hard version must also reconcile:

- own source inputs versus libraries;
- eager versus lazy `IContextSource` instances;
- byte-identical versus genuinely different candidates;
- `InnerClasses` and `EnclosingMethod` families;
- class caches and `reloadContext`;
- parallel preprocessing/emission; and
- the output sink belonging to each own source.

The small condition that makes this the “hard” version is origin coherence: after an
origin is chosen for a top-level family, nested, local, and anonymous members cannot
silently come from another archive. Losing own origins must not emit the winner through
their own output sink.

## 2. Draft public task description

The platform-facing preflight draft is
`vineflower-duplicate-class-resolution-draft.md`. It is deliberately not the final
submission description.

Before tests are written or the backup is activated, the executor must refresh public
state, confirm the option and lifecycle semantics against current Vineflower, audit
every sentence against the frozen behavior matrix, and validate it under the current
description, fairness, repo-fit, and similarity rules. Wording may be refined, but
metadata-family coherence, lazy sources, reload, and output ownership must not be
weakened silently.

## 3. Repository-fit and public-history evidence

### 3.1 Upstream request

Open issue #416, “Improve handling of duplicate classes,” states:

- current behavior uses the first encountered class;
- that choice can be VM/implementation dependent; and
- desired strategies include failing or preferring the most correct class.

The selected contract implements the unambiguous strategies the repository can define
without guessing semantic “correctness.” It does not add a heuristic “best class”
policy.

### 3.2 Public search result

At foundation time, Vineflower had 317 public pull requests, 277 issues, and 5
discussions. Searches covered every PR state, all discussion titles/bodies, live
branches, commits, and release notes.

No public implementation was found for:

- `duplicate-class-strategy`;
- configurable first/last/error class selection;
- content-identity coalescing;
- metadata-family origin coherence; or
- selected-origin output filtering.

The public commit “Avoid race condition crashes when handling duplicate classes”
changes later class processing so duplicate entries do not crash. It is already part of
the base and is not an implementation of issue #416.

Gate 0 must repeat searches for:

```text
duplicate class
duplicate-class-strategy
class collision
class origin
duplicate source
duplicate library
coherent inner class
```

Equivalent public work is a kill condition.

### 3.3 Scope fit

This feature belongs in the structural input layer:

- `IContextSource` already models sources, libraries, entries, children, and lazy
  lookup.
- `StructContext` already decides which `ContextUnit` supplies a binary name.
- `ClassesProcessor` already filters duplicate `StructClass` instances.
- `ContextUnit` already owns the output sink for each input.
- preferences already expose string-valued CLI/API options.

Do not implement the policy in the CLI alone, in `ClassesProcessor` after classes have
been mixed, or in one result saver.

## 4. Architecture dossier

Refresh paths/lines against the final pin.

| Concern | Current source | Relevant fact |
| --- | --- | --- |
| global class lookup | `struct/StructContext.java` | `unitsByClassName` retains one context unit and `classes` caches one parsed class |
| source registration | `StructContext#addSpace`, `initUnit` | eager unit class names are registered as units and child contexts are recursively added |
| source/library precedence | `StructContext#initUnit` | an own source can replace a library; same-tier duplicates keep the existing mapping |
| lazy libraries | `StructContext#getClass`, `hasClass` | lazy units may return no enumeration and are searched on demand |
| class bytes/parse | `struct/ContextUnit.java` | a unit can answer existence, bytes, and parsed `StructClass` |
| entry model | `main/extern/IContextSource.java` | entries include child contexts and multi-release metadata; source lists need not be cached |
| inner families | `main/ClassesProcessor.java` | `InnerClasses` and `EnclosingMethod` build nested/local/anonymous relationships after class lookup |
| badly placed entries | `StructContext#tryLoadClass` | requested entry name can differ from the declared binary name and is corrected in maps |
| own-class collection | `StructContext#getOwnClasses` | every own unit contributes entry names before later duplicate filtering |
| parallel work | `ContextUnit#save` | classes are preprocessed and emitted through a fork-join pool |
| output ownership | `ContextUnit#save` | each own unit loops its own entries and writes through its own sink |
| reload | `StructContext#reloadContext` | clears maps, reinitializes root units, and reuses context objects |
| preferences | `IFernflowerPreferences` | documented options are string keys with defaults and type metadata |

Two distinct duplicate filters exist today:

1. input-name-to-unit selection in `StructContext`; and
2. duplicate parsed-name filtering in `ClassesProcessor` / output collection.

A correct implementation needs one durable resolution record that both layers honor.

## 5. Frozen behavior matrix

### 5.1 Candidate identity and precedence

For one declared/requested binary name:

1. Gather available candidates from registered eager units and applicable lazy units.
2. If any candidate is from an own source, discard library candidates from policy
   comparison.
3. Within the remaining tier, compare exact classfile bytes.
4. Apply the configured strategy to distinct candidates.

| Case | Required result |
| --- | --- |
| one candidate | select it, no duplicate warning |
| source and library | select source for every strategy |
| two libraries, `first` | earliest registered/traversed eligible origin |
| two libraries, `last` | latest registered/traversed eligible origin |
| two own sources, `first` / `last` | same rule within own tier |
| different bytes, `error` | fail before class processing/output |
| byte-identical duplicates, `error` | do not fail; earliest eligible origin anchors the family |
| repeated occurrence in one unit | treat as one origin; do not manufacture an inter-origin conflict |

“Identical” means exact classfile byte equality. Do not attempt semantic normalization.
A digest may accelerate comparison, but collision-safe equality must compare bytes when
digests match or use a digest whose collision assumption is explicitly accepted by
the project.

### 5.2 Stable origin order

- Root source/library order follows public `addSource` / `addLibrary` registration.
- Child-context order follows `IContextSource.Entries#childContexts`.
- Entries within one origin do not decide inter-origin priority.
- A context source whose collection implementation returns names in a different order
  must not change which origin wins.
- `first` is the compatibility default.
- Invalid option values fail with the accepted values before decompilation begins.

The executor must confirm whether API users can add new contexts after class lookup has
started. If allowed today, registering a new duplicate must invalidate unresolved
selection safely or be rejected after resolution begins; it must not create a
half-old/half-new family.

### 5.3 Metadata-defined families

- A literal `$` in a top-level binary name does not make it nested.
- A member class uses its `InnerClasses` enclosing class.
- A local/anonymous class uses applicable `InnerClasses` and `EnclosingMethod`
  metadata.
- Follow enclosing relationships transitively to one family root.
- Detect cyclic or self-contradictory metadata and report it deterministically.
- If duplicate candidates disagree on the family of the same binary name, the selected
  strategy may choose one only before another established family conflicts; never
  merge the two metadata graphs.
- Once an origin anchors a family, all selected members available from that origin use
  it.
- If a family member required by processing is absent from the selected origin but
  present in another, fail with the family root, missing member, selected origin, and
  alternative origins.

Do not define family identity by splitting the binary name. Tests must include a legal
top-level class containing `$`.

### 5.4 Eager and lazy context sources

- Eager candidates are inventoried before class processing.
- A lazy library may not enumerate names and must be probed through `hasClass` /
  `getClassBytes` when the requested name is resolved.
- Lazy discovery participates in the same source/library tier and first/last/error
  rules.
- Cache positive and negative probes per unit/name for one context lifetime.
- Concurrent lookups for the same class/family produce one resolution.
- A lazy candidate discovered after an own-source family is established cannot
  displace it.
- A split family across lazy origins fails rather than switching origin.

The contract does not require enumerating all possible members of a genuinely
non-enumerable lazy source. It requires deterministic behavior for every member that
Vineflower requests.

### 5.5 Caching and reload

- Cache one immutable resolution per binary name and one origin decision per family.
- Parsed-class cache entries must correspond to the resolution used by the family.
- `reloadContext()` clears candidate fingerprints, negative lazy probes, name
  resolutions, family origins, and diagnostics, then rebuilds from current units.
- A post-reload changed input is resolved from new bytes.
- Concurrent reload and active decompilation need only preserve the repository’s
  current lifecycle contract; do not invent concurrent reload support if it is not
  currently safe.

### 5.6 Processing and output ownership

- `getOwnClasses` returns each selected own class once.
- `ClassesProcessor` sees only selected family members.
- A losing own unit does not preprocess or emit the winner through its sink.
- A selected own class is emitted only through its selected origin’s sink.
- Losing duplicate class entries are omitted, not copied as “other” resources.
- Non-class resources, directories, and nonduplicate classes remain attached to their
  current origins.
- Libraries are never emitted.
- Plugins, renaming, whitelists, and language selection observe the selected
  `StructClass`.

This output condition is mandatory. Fixing only `StructContext#getClass` still allows a
losing `ContextUnit#save` loop to request and write the global winner.

### 5.7 Diagnostics

For different bytes under `first`/`last`, log one stable warning per binary name with:

- binary name;
- strategy;
- selected origin; and
- ignored origins in stable order.

For `error`, throw/report one failure listing all highest-tier conflicting origins in
stable order. Libraries ignored because an own source exists may be mentioned as
lower-precedence diagnostics but are not an error.

Byte-identical duplicates do not need a warning at normal log level. Debug/trace
provenance is acceptable.

Do not pin an entire sentence in task tests. Assert stable semantic fragments and
ordered origin names.

### 5.8 Out of scope

- choosing by classfile version or timestamp;
- judging which bytecode is semantically “best”;
- merging fields/methods from candidates;
- changing multi-release-JAR selection;
- renaming duplicate classes;
- deduplicating non-class resources;
- changing duplicate method handling inside one classfile; and
- persisting resolution decisions across processes.

## 6. Hard core and shortcut resistance

### 6.1 Hard core

The faithful core is:

1. candidate inventory with stable origin identity;
2. tiered strategy selection;
3. exact content equivalence;
4. metadata family graph construction;
5. family-origin locking and split detection;
6. lazy lookup/cache integration;
7. parsed-class/cache/reload integration; and
8. selected-origin processing/output filtering.

This is one resolution protocol crossing the full input lifecycle, not an unrelated
list of rare classfile cases.

### 6.2 Known inadequate implementations

| Shortcut | Why it fails |
| --- | --- |
| replace `putIfAbsent` with `put` | only implements last, remains silent, and ignores family/output |
| throw on a second entry in `initUnit` | identical bytes, precedence, lazy sources, and children are wrong |
| choose in `ClassesProcessor` | classes and families may already have been loaded/mixed |
| split name at `$` | misclassifies legal top-level names and ignores metadata |
| select each name independently | constructs hybrid outer/nested families |
| compare timestamps/paths | does not establish byte identity |
| filter only `getOwnClasses` | losing context output loops can still emit a global winner |
| store one static/global policy cache | breaks independent decompiler contexts and reload |
| synchronize only the classes map | family decisions can still race |

Tests must distinguish these implementations through public input/output and logs.

## 7. Measured implementation evidence

The disposable Gate B probe against the pinned base implemented the central resolver,
including metadata family traversal and lazy lookup:

- resolver core: 516 physical lines;
- 328 nonblank/non-comment/non-import/non-brace lines;
- 14 added integration/preference lines outside the core; and
- successful focused build with
  `./gradlew compileJava --no-daemon --offline`.

The probe intentionally omitted final tests and complete output-sink filtering, so it
is not a reference patch and is not stored here. Its purpose was to show that
family-coherent selection does not collapse to a map update.

Final strict production LoC must be measured again. Tests, fixtures, comments, imports,
formatting, generated classfiles, and duplicated boilerplate do not count.

## 8. Test design

Prefer generated tiny classfiles/JARs built by test fixtures over large opaque binaries.
Where Java source cannot express metadata corruption, use the repository’s bytecode
test utilities narrowly.

### 8.1 Strategy matrix

- two own inputs with same name/different method constant;
- two libraries with same name/different hierarchy;
- one own plus multiple libraries;
- identical bytes across two own origins;
- invalid strategy value;
- reverse registration order for first/last.

Assert selected decompiled content, warning/error provenance, and output location.

### 8.2 Family coherence

- duplicate outer and duplicate member choose one origin consistently;
- outer candidates identical but their nested members differ;
- selected outer origin lacks a metadata-declared member present in another origin;
- local/anonymous class with `EnclosingMethod`;
- multi-level nested family;
- top-level `Cash$Money` with no nesting metadata;
- candidates with inconsistent/cyclic metadata.

The generated source must never combine markers from two origins in one family.

### 8.3 Lazy and child sources

- lazy library returns `Entries.EMPTY` but answers class probes;
- two lazy libraries under first/last/error;
- eager own source versus lazy library;
- duplicate in child contexts with stable child ordering;
- repeated negative lookup is cached;
- concurrent requests for outer/member produce one origin or one stable split error.

### 8.4 Reload and output

- change candidate bytes, call `reloadContext`, and observe a new decision;
- remove a prior winner before reload;
- two own archives with duplicate class emit it only in the selected archive;
- losing archive retains unrelated class/resources;
- parallel thread counts 1 and greater than 1 produce identical outputs/diagnostics.

### 8.5 Regression

- existing single-source decompilation unchanged;
- current source-over-library behavior unchanged under default;
- badly placed class correction still works;
- whitelist/include/exclude and renaming use the selected class;
- plugin language selection sees the selected class.

Avoid a Cartesian explosion. Use helpers that create origin pairs/families and assert
the same contract under a focused matrix.

## 9. Reference implementation shape

This is architectural guidance, not a golden recipe.

1. Give each registered root/child context a stable origin identity/order.
2. Keep all eager candidate origins per entry name instead of only one unit.
3. Add a context-owned resolver for byte comparison, strategy, metadata families,
   lazy probes, and diagnostics.
4. Resolve/lock the family before a parsed class is cached.
5. Keep source-over-library precedence outside the strategy switch.
6. Represent the selected origin so `getOwnClasses`, class processing, and
   `ContextUnit#save` can all ask the same decision.
7. Clear all resolver state during context reload/clear.
8. Add the documented string preference and default without a CLI-only special case.

Do not make `StructClass`, `ContextUnit`, or global decompiler state carry a static
winner. Resolution belongs to one `StructContext`.

## 10. Execution gates

### Gate 0 - live uniqueness and author fit

- Re-resolve `master`.
- Repeat PR/issue/discussion/branch/commit/release searches.
- Run platform similarity/repo-fit preflight with the draft description.
- Confirm issue #416 remains open and no implementation is linked.

### Gate A - contract freeze

Freeze:

- option name/values/default;
- origin-order definition;
- identical-byte behavior;
- metadata family rules;
- lazy-source boundary;
- output ownership; and
- diagnostic semantic fields.

Every test must map to explicit prose.

### Gate B - hardest vertical slice

Implement and measure:

- two own duplicate outer/member families;
- first/error selection;
- byte identity;
- metadata family locking; and
- selected-origin output.

If this faithful slice collapses below the strict floor, kill the candidate. Do not
add more strategies or malformed fixtures merely to increase size.

### Gate C - fresh strong agent ceiling

Give a fresh strong zero-context agent only the clean base and final description. The
normal panel must produce at least one legitimate pass and no more than 40% pass rate.
If a simpler correct resolver is found, accept the evidence and redesign/kill.

### Gate D - submission construction

After A/B/C only:

- build concise description and public-behavior tests;
- implement the professional golden patch;
- run focused local tests and remote full verification per hybrid workflow;
- run AI evaluation, false-positive evaluation, prechecks, and auto-review;
- reconcile pass-rate failures separately from fairness/description failures.

## 11. Kill and redesign conditions

Kill or redesign if:

- equivalent public work appears;
- issue #416 is closed as unwanted or superseded;
- author review wants only a trivial first/last map behavior;
- metadata-family coherence conflicts with Vineflower’s intended recovery behavior;
- lazy sources make the stated deterministic boundary impossible without changing
  their public contract;
- strict production LoC is below the platform floor;
- the description cannot state output ownership without internal jargon;
- every strong agent fails for an unstated origin rule; or
- more than 40% pass without hints.

Do not rescue the task with heuristic “best bytecode,” multi-release selection,
duplicate-resource policies, or new decompiler transformations.
