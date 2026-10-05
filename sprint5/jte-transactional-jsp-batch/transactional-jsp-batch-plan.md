# Plan - Transactional JSP Batch Migration for JTE

_Foundation date: 2026-07-23. Repository:
`https://github.com/casid/jte.git`. Pinned foundation base:
`495ea7358dcdb5bba53b3c8e890f7b271d42503f`._

_Status: active foundation paired with `mapstruct-inherit-super-mappings`. Repeat the
public-history and platform preflights, validate the draft description, freeze the
API/description matrix, and then build the hardest vertical slice before broad tests._

## 1. Selection verdict

Add a read-only planning and transactional commit path for converting an unordered,
connected set of JSP tags to JTE.

Today `JspToJteConverter#convertTag` mutates the project one tag at a time: it writes the
JTE output, deletes the JSP tag, and rewrites every JSP usage immediately. Users must
manually choose leaves before their dependents. A later conversion failure occurs after
the earlier mutations.

The proposed path:

```java
JspMigrationPlan plan = converter.planTags(
    List.of("tags/form.tag", "tags/input.tag", "tags/label.tag"),
    MyConverter::init
);

plan.getConversionOrder();
plan.getWrites();
plan.getDeletes();
plan.commit();
```

Planning must discover dependencies, reject cycles and collisions, convert against a
virtual view containing prior planned conversions, and expose the exact writes and
deletions without changing disk. Commit must reject a stale plan and restore all
affected paths if an ordinary I/O failure interrupts the commit.

This is a normal Olympus candidate. It is hard because conversion, graph ordering,
whole-tree usage replacement, optimistic concurrency, and rollback must agree. It must
not be made “hard” by adding unrelated JSP syntax support.

## 2. Draft public task description

The platform-facing preflight draft is
`jte-transactional-jsp-batch-draft.md`. It uses the required header block and natural
prose without artificial line wrapping.

It is deliberately a draft, not the final submission description. Before tests are
written, the executor must revalidate the repository and public history, confirm the
API and path model against the current code, audit every sentence against the frozen
behavior matrix, and run the description through the current rules, prechecks, and
platform repo-fit/similarity checks. Every retained test must map to a clause in the
final prose, and every retained clause must be observable.

## 3. Repository-fit and public-history evidence

### 3.1 Existing repository purpose

`docs/jsp-converter.md` says the converter is intended to migrate huge JSP projects and
describes a leaf-first strangler workflow. The converter already owns:

- JSP parsing through Jasper;
- built-in and application custom-tag conversion;
- unresolved dependency rejection;
- conversion of the JTE bridging tag;
- output path suggestion;
- deletion of a converted JSP tag; and
- replacement of all usages under the JSP root.

A batch plan is a cohesive extension of that workflow. It does not put migration logic
in `TemplateEngine`, change template rendering, or generalize JTE into a filesystem
transaction library.

### 3.2 Public search result

At foundation time, JTE had 171 public pull requests and 44 discussions. Searches
covered every pull-request state, all discussion titles/bodies, live branches, commits,
and release notes.

No public implementation was found for:

- `convertAll`, `planTags`, or a conversion plan;
- batch JSP conversion;
- dependency-order conversion;
- conversion rollback or stale-plan detection; or
- a virtual JSP migration tree.

Relevant historical PRs are older parser, formatter, Jakarta-copy, and dependency
updates. None implements this behavior.

Gate 0 must repeat:

```text
JSP converter
JSP migration
batch converter
convert all JSP
conversion plan
transactional converter
rollback JSP
dependency order JSP
```

A new equivalent public PR, branch, commit, or external reference implementation is a
kill condition.

### 3.3 Maintainer-direction risk

There is no issue explicitly requesting a batch API. Repository fit comes from the
documented huge-project workflow and the current converter’s immediate mutation.

Before implementation, the repo-fit preflight must present the narrow description
above. If author review says conversion is intentionally one-file-only or that a plan
API is outside the converter, kill the candidate. Do not defend it by adding more
features.

### 3.4 Local accepted-task similarity

Accepted `jte-precompile-maintenance` shares three generic mechanisms: content hashes,
dependency information, and failure-safe filesystem changes. The difference must
survive platform similarity review:

| Task | Owned state | Operation | Persistence/API |
| --- | --- | --- | --- |
| precompile maintenance | compiler-generated source/class/binary artifacts | incremental generation/compilation and abandoned-artifact cleanup | persisted ownership/dependency manifest and TemplateEngine queries |
| JSP batch migration | application JSP/JTE source files selected by the user | one explicit conversion plan and commit | ephemeral reviewable plan on `JspToJteConverter`; no compile/artifact manifest |

The candidate does not reuse accepted task APIs or production files. Still, similar
solution vocabulary is a preflight risk. If the platform considers the graph/hash/
transaction core substantially duplicative, kill this candidate. Do not remove honest
transaction clauses merely to evade similarity.

## 4. Architecture dossier

Refresh paths and line numbers against the final pin.

| Concern | Current source | Relevant fact |
| --- | --- | --- |
| public coordinator | `jte-jsp-converter/.../JspToJteConverter.java` | `convertTag` combines parse, conversion, dependency check, write, deletion, and usage replacement |
| Jakarta coordinator | matching file in `jte-jsp-converter-jakarta` | production source is intentionally near-duplicated |
| Jasper entry | `org/apache/jasper/compiler/JtpParser.java` | builds a servlet/Jasper context and returns parsed `Node.Nodes` |
| structural visitor | `JtpConverter.java` | visits include directives, custom tags, EL, page/tag directives, and bodies |
| dependency check | `JspToJteConverter#checkDependencies` | scans converted text for unconverted tag-shaped tokens after conversion |
| tag conversion | `Converter`, `CustomTagConverter`, built-in converters | parser setup is user supplied and must be applied consistently to every selected tag |
| bridge conversion | `JspJteConverter` | turns the temporary JSP bridge representation into a JTE template call |
| output helper | `gg.jte.convert.IoUtils` | writes/deletes immediately and wraps I/O failures |
| usage rewrite | `replaceUsages` | walks `.jsp`, `.jsp.inc`, and `.tag` files and performs bounded opening/closing replacement |
| output naming | `suggestJteFile` | distinct JSP paths can normalize to the same JTE destination |
| includes | `JtpConverter#visit(IncludeDirective)` | includes are accepted only when configured through `addInlinedInclude` and their bodies are visited |

The current class boundary is the first problem: conversion cannot be reused without
mutation. The executor should separate “convert one source to text” from “apply its
filesystem effects” before adding batch orchestration.

## 5. Frozen behavior matrix

Freeze the final names before writing task tests.

### 5.1 Inputs and path safety

| Case | Required result |
| --- | --- |
| null or empty collection | argument failure, no disk access beyond configuration validation |
| duplicate path spellings normalizing to one file | planning failure |
| relative `..` escaping JSP root | planning failure |
| absolute path | planning failure unless the final API explicitly accepts and normalizes it within the root |
| missing/non-regular selected file | planning failure |
| symbolic-link selected tag | reject; do not follow a selected tag outside the configured tree |
| `.tag` inputs | supported target type |
| arbitrary `.jsp` page selected for deletion | out of scope unless repo preflight explicitly broadens the API |

The batch converts JSP tag files. It scans `.jsp`, `.jsp.inc`, and `.tag` files for
usage effects because existing `replaceUsages` does so.

### 5.2 Dependency graph

- Input order has no semantic effect.
- A selected tag depends on another selected tag when parsed JSP structure contains a
  real invocation of that tag.
- Comments, tag-like text, script strings, longer-prefix names, and suppressed nodes
  are not dependency edges.
- Parser setup and `getNotConvertedTags()` apply before dependency decisions.
- Approved inlined includes participate in the root tag’s dependency scan.
- Every dependency is converted before its dependents.
- Independent nodes use a documented stable lexical path order.
- A cycle fails planning and reports one deterministic closed path such as
  `a.tag -> b.tag -> a.tag`.
- Unselected dependencies retain current behavior: registered/suppressed tags may
  remain; unresolved non-suppressed tags fail.

Do not satisfy this with a regex over raw source. The task specifically selects parsed
structure because a textual scan creates false dependencies.

### 5.3 Output and virtual conversion

- Compute every proposed JTE destination before the first conversion.
- Two selected sources mapping to the same destination fail.
- An existing destination fails; the plan never silently overwrites a hand-written or
  prior JTE file.
- The selected tag’s source is read from one immutable planning snapshot.
- When a dependent is converted, calls to already planned dependencies behave as if
  existing one-tag conversion and usage replacement had run, but disk remains
  unchanged.
- Generated JTE content must equal a legitimate dependency-first sequence of current
  one-tag conversions for the same tree and configuration.
- Each selected JSP tag is a planned deletion.
- Every matching usage in the scanned JSP tree is a planned write.
- A file rewritten several times appears once with its final content.
- Files whose final bytes equal their initial bytes do not appear as writes.

### 5.4 Plan inspection

The final public surface must expose, at minimum:

- dependency-safe conversion order;
- exact write destinations and UTF-8 content; and
- exact deletion paths.

Returned collections are immutable and deterministically ordered. Decide whether paths
are normalized absolute paths or root-relative values before tests; do not mix the two.

Inspection does not expose temporary/backup implementation paths.

### 5.5 Stale plans

Planning snapshots:

- every selected source;
- every approved included source read by Jasper;
- every JSP-tree file scanned for usages; and
- every proposed destination’s absence.

Before the first commit mutation, compare the current state with those snapshots by
content, not timestamp. A newly created destination, changed/deleted scanned file, or
changed include makes the plan stale.

A stale commit:

- reports the changed paths in deterministic order;
- performs no write, move, or deletion; and
- does not mark the plan committed, although the simplest final contract may still
  require callers to re-plan rather than retry.

### 5.6 Commit and rollback

- Commit is single-use after success.
- Stage every write before moving any original.
- Preserve an original for every overwritten/deleted path until every replacement is
  installed.
- If an ordinary `IOException` or wrapped I/O failure occurs after mutation begins,
  remove installed replacements and restore originals before rethrowing.
- A rollback failure is attached to the original failure and is not hidden.
- Successful commit removes temporary/backup files.
- Unsuccessful preparation removes staged files.
- Do not promise crash/power-loss recovery or a persistent journal; the guarantee is
  for failures observed by the running process.
- Do not replace whole configured roots. Unrelated content and concurrent work outside
  the snapshotted JSP inputs remain untouched.

A package-private file-operation seam is acceptable for deterministic rollback tests.
Do not expose a general transaction SPI as public API.

### 5.7 Compatibility and parity

- Existing `convertTag`, `replaceUsages`, subclass hooks, and IntelliJ entrypoint retain
  their behavior.
- `readFile`, `getResourceBase`, `getNotConvertedTags`, and parser setup overrides are
  honored by planning.
- `javax` and Jakarta artifacts have equivalent API and behavior.
- Duplicated Jakarta production lines do not count twice in strict implementation-size
  evidence.
- No TemplateEngine/runtime/rendering behavior changes.

## 6. Hard core and shortcut resistance

### 6.1 Hard core

The minimum faithful solution must coordinate:

1. structural dependency extraction;
2. deterministic graph validation/order;
3. output preflight;
4. conversion over a virtual multi-file snapshot;
5. exact multi-pass usage rewriting;
6. content-based optimistic concurrency; and
7. recoverable multi-path commit.

Each concern changes the correctness of the next. This is not a list of independent
edge cases attached to a loop.

### 6.2 Known inadequate implementations

| Shortcut | Why it fails |
| --- | --- |
| loop over `convertTag` | mutates before all selected conversions are known to succeed |
| require leaf order | avoids the required graph and cannot diagnose cycles |
| regex dependency discovery | false positives in comments/text and misses parser semantics |
| mutate then undo with current contents | can overwrite concurrent changes and loses exact originals |
| copy/replace whole roots | changes unrelated ownership and cannot safely span roots/filesystems |
| timestamps for stale checks | same-timestamp or backward-timestamp content changes pass |
| one temp rename per write | failure after the first rename remains partial |
| implement only the `javax` module | creates public artifact divergence |

Task tests must kill each architecture without pinning private class names.

## 7. Measured implementation evidence

The disposable Gate B probe against the pinned base produced:

- a 552-line batch core;
- 338 nonblank/non-comment/non-import/non-brace lines in that core;
- additional coordinator refactoring; and
- a successful focused Maven build.

The probe used a textual dependency detector only to size the graph/virtual-tree/
transaction core. The actual task requires structural discovery, so copying the probe
would fail the task. The probe is not stored in this foundation.

This passes the strict 250 meaningful-production-line floor, but final evidence must be
recomputed from the professional golden patch. Duplicated Jakarta code, imports,
comments, tests, formatting, and generated fixtures are excluded.

## 8. Test design

Build tests around observable behavior, not the expected class layout.

### 8.1 Core success

- three tags supplied in reverse dependency order;
- one independent tag to prove deterministic tie ordering;
- dependent generated JTE calls the planned dependency correctly;
- nonselected JSP pages and tags have all matching usages rewritten;
- body content and parameters preserve existing bridge semantics;
- plan inspection is immutable;
- disk is byte-for-byte unchanged before commit;
- commit produces exactly the inspected writes/deletes.

### 8.2 Graph failures

- direct self-cycle;
- multi-node cycle with deterministic path;
- selected dependency mentioned only in a JSP comment;
- prefix collision such as `foo` versus `foobar`;
- suppressed external custom tag;
- unresolved non-suppressed external tag.

### 8.3 Preflight failures

- normalized duplicate input;
- missing source;
- root escape;
- output normalization collision;
- pre-existing JTE output;
- parse failure in the last topological node;
- converter hook failure after earlier virtual conversions.

Assert no files changed in every failure.

### 8.4 Concurrency and transaction

- edit a selected source after planning;
- edit a nonselected JSP that was scanned for usages;
- create a proposed JTE destination after planning;
- keep timestamps unchanged while content changes;
- injected failure while staging;
- injected failure after some originals are backed up;
- injected failure after some replacements are installed;
- rollback failure retained as suppressed information;
- second commit after success rejected.

### 8.5 Compatibility/parity

- existing one-tag tests remain unchanged;
- IntelliJ entrypoint remains valid;
- custom `readFile`/resource-base/parser setup hooks are observed;
- mirrored scenarios in `javax` and Jakarta modules.

Use a small number of matrix helpers. Do not inflate the test patch with dozens of
nearly identical filesystem fixtures.

## 9. Reference implementation shape

This is architectural guidance, not a patch recipe.

1. Extract a side-effect-free “convert source to JTE text” operation from
   `convertTag`.
2. Add a structural dependency event/collector near `JtpConverter`, preserving user
   converter registration and suppressions.
3. Build an immutable planning snapshot and normalized selected-tag model.
4. Precompute destinations and graph; report all deterministic preflight errors before
   conversion where practical.
5. Convert in graph order against a virtual source view.
6. Reduce all virtual changes to one ordered write/delete set.
7. Snapshot by digest and expose immutable inspection.
8. Stage, backup, install, rollback, and clean through one package-private operation
   layer.
9. Mirror the behavior in Jakarta without claiming copied lines as independent
   difficulty.

Avoid a public abstraction hierarchy unless the final implementation proves one is
needed. A small immutable plan object and package-private planner/commit collaborators
are preferable.

## 10. Execution gates

### Gate 0 - live uniqueness and repo fit

- Re-resolve upstream.
- Repeat all public searches.
- Run platform similarity and author/repo-fit checks with the draft description.
- Kill on overlap or direction rejection.

### Gate A - contract freeze

- Freeze names, path representation, include behavior, stale-plan scope, and rollback
  boundary.
- Map every planned test to one description clause.
- Remove any contract that exists only to increase patch size.

### Gate B - professional minimum slice

Implement:

- two tags in unordered dependency order;
- read-only plan inspection;
- stale detection; and
- rollback after one installed write.

Measure strict production LoC and inspect whether the remaining branches are natural.
Kill if this collapses below the platform floor.

### Gate C - fresh strong agent

Give only the clean base and final description to a fresh strong agent. The task needs
at least one legitimate pass and no more than 40% normal-panel pass rate. If the agent
finds a simpler faithful architecture, treat it as evidence; do not add decorative
conditions to defeat it.

### Gate D - submission construction

Only after A/B/C:

- write concise description;
- build focused public-behavior tests;
- build professional golden patch;
- run local module tests and remote full verification per the hybrid workflow;
- run AI evaluation, false-positive evaluation, prechecks, and auto-review;
- reconcile every artifact before submission.

## 11. Kill and redesign conditions

Kill or redesign if:

- equivalent public work appears;
- repo-fit review rejects a batch API;
- parsed dependency extraction cannot be added without copying/altering Jasper;
- a faithful implementation can safely delegate to current `convertTag` in a small
  wrapper;
- strict unique production LoC is below the current floor;
- all strong agents fail because the description hides transaction boundaries; or
- more than 40% pass without hints.

Do not rescue the task by adding new JSP EL operators, tag libraries, formatting modes,
include syntax, or a generic transaction framework.
