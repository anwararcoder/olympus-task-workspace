# Inherited Super Mappings — next plan (v3 -> v4)

> Written after the third agent round. The immutable `inherit-super-mappings-plan.md` is unchanged.
> Execute only after the v3 checkpoint is committed and tagged.

## 1. Exact state being planned against

| signal | value |
| --- | --- |
| pass rate | 30% (3/10), all Nova |
| legitimate passes | 1 (agent-9); agent-6 and agent-10 are confirmed false positives |
| auto-review | `outcome: approved`; description 3.0, tests 3.0, solution 3.0, agents 3.0 |
| test fairness | **PASS** — `unfairTestCount: 0`, all 48 hidden tests fair |
| plagiarism | distinct (5 candidates) |
| repo fit | fresh, no upstream implementation |
| false-positive panel | **FAILED** — 3 evaluated, 2 FP, 1 genuine |
| verifier audit | INCOMPLETE — 3 demonstrated gaps, four-state validated |
| suite | 48 hidden tests / 92 executions |
| golden | untouched since v1, byte-identical |

**Every gate the platform grades is green except the false-positive panel.** That single check is
the whole remaining distance to acceptance, so this plan touches nothing else. The tests band is
already 3.0; there is no coverage debt to pay down and no reason to grow the suite for its own sake.

## 2. Root cause — two confirmed classes, both "reference green, suite silent"

Neither class needs a reference change. Both were reproduced by the adjudicator on candidate and
reference, and both are required by sentences already in the description.

### Class A — the rebinding decision is re-resolved in the child (Nova #6)

Verified against the base repository, not taken on trust.
`SourceReference.buildFromSingleSourceParameters` computes

```java
allowedMapToBean = !segments[0].equals( parameter.getName() );
```

* **Parent** `map(Map<String, Node> source)` with `source = "source.entry"` — the leading segment is
  spelled exactly like the parameter, so map-key access is disabled at position zero, the chain
  cannot complete as properties, and `source` binds to the **parameter**. The parent means
  `source.get("entry")`.
* **Child** `map(Map<String, Node> renamed)` inheriting the same string — the segment no longer
  matches the parameter name, map-key access is enabled, the chain completes as key-then-property,
  `foundEntryMatch` is true, and the `!foundEntryMatch` fallback that carries the rebinding is never
  entered. The child means `renamed.get("source").getEntry()`.

The reference mirrors the parent through `resolvesAsPropertyPath`, whose lookup is
`getReadAccessor(name, i > 0)` — map access allowed only after position zero. So the reference
rebinds and produces `renamed.get("entry")`.

The description already requires this: rebind a segment "that **the overridden method** resolves to
a source parameter". An inherited mapping that silently changes meaning because the child renamed a
parameter is precisely the bug this feature exists to prevent.

The suite cannot see it because **no fixture anywhere has a Map-typed source parameter** (grep over
all 67 fixture files: zero `Map<String` source parameters). The existing `QualifiedParameterMapperK7p4`
only covers the case where the property chain is structurally invalid (`String.value`), which is the
one shape where the broken architecture accidentally behaves.

### Class B — inherited mappings applied twice (Nova #10)

The candidate applies inherited mappings from `MapperCreationProcessor.mergeInheritedOptions`, which
is re-entrant and is called without the `isFullyInitialized()` guard the recursive path uses. A
method with `inheritSuperMappings = true` that is **also** consumed as an `@InheritConfiguration`
template by an earlier-declared sibling is processed twice. Ordinary targets self-suppress through
`currentTargets`, but `target = "."` flattening is deliberately excluded from that suppression and is
always appended, so it lands twice and a valid mapper fails to compile with a duplicate-source
ambiguity.

Stated by two clauses in combination: flattening declarations "accumulate instead of competing as one
target", and existing configuration inheritance "fills only targets not supplied by the current or
inherited super mappings". The reference resolves and applies once in `MethodRetrievalProcessor` and
compiles the same mapper cleanly.

## 3. The solvability problem, stated plainly

**Closing class A costs the current solvability anchor.** agent-9, the one genuine pass, hooks the
same `getSourceParameterFromMethodOrTemplate` fallback as agent-6 (verified in its patch: the hook
sits inside the method body reached only when `!foundEntryMatch`). It therefore fails the Map probe
for exactly the same reason. agent-6 and agent-9 are the same architecture; only agent-10 differs,
and it dies on class B.

Two options were weighed:

1. **De-scope class A** so the corner is explicitly unspecified. Both agent-6 and agent-9 would
   become genuine and the panel would overrule any future probe there, as it did for the role-change
   probe on Nova #9. Rejected: it blesses an inherited mapping whose meaning changes under a rename,
   which is the feature's central promise, and the carve-out ("except when the parameter is a Map")
   is arbitrary enough that a human reviewer would question the contract.
2. **Close class A and make the rule discoverable.** Chosen.

The lever that makes option 2 safe is a description anchor, not a weaker test. The two FP passers
were each one conceptual point from correct; the point they missed is *where* the parameter/property
decision is made. Stating it converts a hidden trap into a stated requirement, which by the
clarity-dissolves-mechanical-difficulty rule should hold the pass rate roughly flat rather than
depress it. This is the same shape as the value-pointers overflow anchor: name the observable, never
the mechanism.

## 4. Levers

### L1 — close class A: decision follows the overridden method (description + one fixture)

**Description.** Append one sentence to the rebinding paragraph, after the existing
"unqualified property" sentence:

> Whether a leading segment denotes a parameter or a property is decided as the overridden method
> reads the inherited path, not by reading it again against the overriding signature.

Behavioral, no API named, no algorithm leaked. It generalises the existing unqualified-property
sentence instead of contradicting it, and it is exactly what the reference does.

**Test.** New fixture `MapParameterMapperK7p4`: parent declares
`TargetK7p4 map(Map<String, NestedSourceK7p4> source)` with
`@Mapping(target = "first", source = "source.entry")`; the override renames the lone parameter and
enables inheritance. Assert the mapped value is the one stored under key `entry`, and that a value
stored under key `source` is **not** what surfaces. One test in `InheritSuperMappingsK7p4Test`.

The assertion is derived from the description clause, not from the reference's internals: it checks
which key the generated mapper reads, which is the observable the parent already fixes.

### L2 — close class B: inherited mappings applied once (one fixture)

New fixture `RecursiveTemplateMapperK7p4`: a parent declaring a `target = "."` flattening; a child
method with `inheritSuperMappings = true`; and an **earlier-declared** sibling in the same mapper
that consumes the child method as its `@InheritConfiguration` template. Assert the mapper compiles
and both methods map correctly.

This asserts only that a valid mapper compiles and produces the stated flattening — no diagnostics,
no ordering internals. A double-application fails it with the ambiguity error the panel reproduced.

### L3 — verifier-audit gap 1: rebinding uses signature position, not source ordinal

Real and stated: the description says "the overriding parameter in **the same signature position**".
The audit's broken implementation zips the two filtered source-parameter lists by ordinal, which
diverges as soon as a non-source parameter role differs between the declarations.

Distinct from the role-change probe the Nova #9 adjudicator overruled: there, the same position no
longer held a source parameter at all, so the clause specified nothing. Here the overriding parameter
at that position **is** a source parameter, so the clause applies directly.

New fixture with parent `(Source first, @Context Helper helper, Source second)` and override
`(Source renamedFirst, Helper nowSource, Source renamedSecond)`, inheriting `second.alpha`; assert it
binds to `renamedSecond`. agent-9's implementation already indexes the full parameter list, so this
cell does not cost the architecture we want to keep.

### L4 — verifier-audit gaps 2 and 3: inherited `dependsOn` and `defaultExpression`

Both real, both cheap, both zero solvability cost. `copyForSuperInheritance` rebuilds
`MappingOptions` field by field, so dropping a single behaviour-bearing member is a plausible
omission that the current suite cannot see. Any faithful copy passes both.

- `inheritedDependsOnPreservesAssignmentOrder` — inherited mapping declared second but carrying
  `dependsOn = "first"`; assert the observable setter order.
- `inheritedDefaultExpressionIsRetained` — inherited mapping with
  `defaultExpression = @Java(...)`; assert the fallback value when the source is null.

Take these as **accept-with-edits**: reuse the audit's shapes, rename to the `K7p4` convention, keep
them in the existing test classes rather than applying the 98-test replacement patch wholesale, so
nothing else in the suite is disturbed.

## 5. Explicitly rejected, recorded so they are not re-opened

| item | source | grounds |
| --- | --- | --- |
| incomparable parents with the option off must report no conflict | fairness suggestion 1 | Near-miss of an already-enforced clause. Every implementation gates on `isInheritSuperMappings()` before collecting anything, so no plausible broken implementation is admitted. `DefaultOffMapperK7p4` already pins option-off behaviour. |
| composed annotation carrying multiple `@Mapping` declarations | fairness suggestion 2 | Composition expansion happens in MapStruct's own gem processing before the feature sees the list; a solution that inherits one mapping of a composition but not the rest is not a plausible architecture. `ComposedMapperK7p4` already covers composition. |
| source parameter becomes `@MappingTarget` at the same position | judge-c, Nova #9 | Explicitly overruled by the adjudicator as prompt-unspecified: the clause is written for source-to-source rename correspondence. Testing it would pin behaviour the description does not define. |
| dotted path whose complete chain resolves as properties | v2 non-goal | Reference and every observed candidate agree here (the self-referential bean case resolves identically on both sides), so no discriminator exists in either direction. Unchanged from v2. |

The first two are the exact class the owner flagged: coverage suggestions adopted without asking
whether a plausible broken implementation is actually admitted. Both fail that test.

## 6. Execution order and verification

1. L1 description sentence + `MapParameterMapperK7p4` fixture and test.
2. L2 `RecursiveTemplateMapperK7p4` fixture and test.
3. L3 signature-position fixture and test.
4. L4 the two inherited-member cells.
5. Regenerate the test patch **with explicit paths**, then diff the file list against the previous
   patch before shipping (an earlier `git add -A` once swept stale fixtures into the patch).
6. Confirm the solution patch is byte-identical to v3.

Gates, in order:

- **Reference-green is the hard gate.** Every new cell must pass the unchanged golden. If any cell
  fails the reference, the cell is wrong, not the reference — stop and re-derive it.
- Four-state on the exact shipped bytes: base green, new tests fail on the clean repo, both golden
  states green.
- Replay agent-10 against L2: must fail. Replay agent-6 against L1: must fail. These are the
  discriminator gates that prove the classes are actually closed.
- Replay agent-9: expected to fail L1 only. Any *additional* new failure means a lever over-reached
  and must be narrowed.
- Suite hygiene: `test.sh` stays mode 100755, patches disjoint, ASCII only, no forbidden tokens.

## 7. Expected outcome

Suite grows from 48 to roughly 53 hidden tests. Both confirmed false-positive shapes fail, the three
audit cells are closed, the seven coding failures are untouched, and no new hard corner is
introduced — L1 is paired with the sentence that makes it discoverable, and L2/L3/L4 assert
behaviours a faithful implementation already has.

The honest risk is the pass rate: the architecture shared by two of three passers is the one L1
rejects, so a fresh batch could come back lower. The mitigation is the description anchor rather
than a weaker test, and the reference proves the contract is implementable. Request a **mixed-tier
pool**; all three rounds so far have been Nova-only, which caps what any pass rate can tell us.
