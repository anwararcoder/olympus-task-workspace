# ⚠️ Verifier Completeness Audit — INCOMPLETE

> Probes whether a broken-but-plausible solution could still pass the current
> tests — BEFORE any rollouts. When it finds gaps it also proposes a fix to the
> test patch. (This check replaced the old post-rollout false-positive check.)

## Verdict & Summary

- **Verdict:** INCOMPLETE — 3 demonstrated gap(s)
- **Completed:** 2026-07-27 22:38
- **Audit effort:** 25 steps · 51 messages · 1631s
- **Job:** `nx78qm1j7dtbhhzrq8zjc5zaj58baskx`

Audited the specification, reference implementation, and all tests in test.patch. The original verifier runs 46 logical processor tests across its configured compilers (92 executions) and covers the API default, enabled/disabled behavior, direct/generic/transitive/interface/superclass/default/update/covariant overrides, local and inherited precedence, branch conflicts and diagnostics, shared ancestors, flattening, compositions, configuration inheritance, source rebinding/path disambiguation, expressions, method-option isolation, and invalid/no-super cases. Adversarial reference probes additionally exercised an inherited defaultExpression, inherited dependsOn ordering, and rebinding by full Java signature position when @Context/source roles differ. Three plausible broken implementations each passed all 92 original executions but failed its reference-backed probe. I wrote a full replacement /var/artifacts/updated_test.patch adding those probes to the verifier's focused Additional test class; it applies cleanly to the pristine checkout, and with the reference solution all 98 executions pass.

## What to do with this (decision guide)

The audit demonstrated **3 gap(s)** where a plausible but broken solution still passes the current tests. On the platform you can:

- **Accept as-is** — apply the audit's proposed test patch verbatim. `proposed-changes.diff` shows exactly what it adds/changes on top of the task's `test.patch`. ⚠️ Accepting re-stales your other checks, so do it early.
- **Accept with edits** — take `proposed-changes.diff` as the starting point, adjust it, then apply. Best when the proposed tests are close but over- or under-shoot the contract.
- **Bypass** — keep your current tests; the reviewer is notified. Choose this only if a gap targets behavior the task deliberately leaves unspecified — justify it in the note.

**How to judge each gap:** weigh its severity (crash > wrong result > cosmetic) and plausibility (how likely a real solver writes that broken code), then read its broken-implementation and probe. A high-plausibility crash/wrong-result gap on a stated requirement is a real hole — prefer accept (or accept-with-edits). A gap that only bites genuinely unspecified behavior is a candidate for bypass.

Files here:
- `verifier-audit.md` — this report (complete; use it as the source of truth)
- `proposed-changes.diff` — a git-style diff of exactly what the platform proposes to change (3 new, 1 modified, 66 carried over). Apply it on top of the task's `test.patch` to get the full proposed test suite.

## Proposed-Patch Validation

The platform verified the proposed patch before offering it:

- ✅ Applies cleanly
- ✅ Base tests pass (without solution)
- ✅ New tests fail on clean repo (without solution)
- ✅ Reference passes the updated suite

```
git apply --check: ok
base (no solution): PASSED (3649 tests, 3649 passed)
new (no solution): FAILED (1 tests, 1 failed) (exit 1)
base (with solution): PASSED (3649 tests, 3649 passed)
new (with solution): PASSED (98 tests, 98 passed)
```

## Demonstrated Gaps (3)

### Gap 1 — WRONG RESULT · high plausibility · demonstrated

**Source rebinding by source-parameter ordinal passes the suite but violates full-signature-position semantics**

The original tests rename ordinary source parameters and cover an update method, but never make source/non-source parameter roles differ between an overridden declaration and its override. Consequently they do not distinguish full Java signature position from the tempting shortcut of zipping each method's filtered source-parameter list.

**Violates:**
- `R12` — When an inherited source path's leading whole segment resolves to an overridden source parameter, that segment is rebound to the overriding source parameter at the same full signature position; the remaining path, including an empty suffix, is preserved, including for renamed same-typed parameters.
- `R13` — Rebinding is segment-based, not textual-prefix-based, and must not pair parameters by filtered source-parameter ordinal when non-source parameter roles occur in the signature.

**Remedy tests (added/updated to close it):** `rebindingUsesSignaturePositionNotSourceParameterOrdinal`

**Broken implementation (what a plausible solver does wrong):**

Changed sourceParameterBindings to call Parameter.getSourceParameters on both signatures and pair those filtered lists by ordinal. This is a natural shortcut because the operation is specifically rebinding source parameters.

**Probe (how the audit demonstrated the gap):**

The parent signature is (Source first, @Context Helper helper, Source second), while the Java override has (Source renamedFirst, Helper nowSource, Source renamedSecond). The inherited path second.alpha must bind to renamedSecond at signature index 2. Source-ordinal pairing instead binds it to nowSource at filtered-source ordinal 1.

**Evidence:**

Reference probe exited 0 and returned "signature-position". The broken implementation passed the complete original focused suite: 92 tests, 0 failures. Its probe compiled but returned "middle" instead of "signature-position" (2 compiler executions failed).

---

### Gap 2 — WRONG RESULT · medium plausibility · demonstrated

**Dropping inherited dependsOn ordering is not detected**

The verifier checks inherited constants, defaultValue, qualifiers, and conditionExpression, but has no inherited mapping whose dependsOn member affects observable setter order.

**Violates:**
- `R2` — When enabled on an overriding bean-mapping method, property-level @Mapping declarations from overridden mapper-interface and superclass methods are inherited, including composed mappings.
- `R3` — Every behavior-bearing member of an inherited property-level @Mapping declaration is retained, including fallback expressions, qualifiers, formatting, conditions, and dependsOn ordering.

**Remedy tests (added/updated to close it):** `inheritedDependsOnPreservesAssignmentOrder`

**Broken implementation (what a plausible solver does wrong):**

In copyForSuperInheritance, copied all tested @Mapping state but replaced dependsOn with Collections.emptySet(). A hurried manual copy of a large annotation/options object can plausibly omit ordering metadata while preserving values and conversions.

**Probe (how the audit demonstrated the gap):**

An inherited mapping for second is declared before first but specifies dependsOn="first". A target setter records whether first had already been assigned when second is assigned.

**Evidence:**

Reference probe exited 0 and observed first assigned before second. The broken implementation passed all 92 original executions, then the probe failed because firstSetBeforeSecond was false in both compiler executions.

---

### Gap 3 — WRONG RESULT · medium plausibility · demonstrated

**Dropping inherited defaultExpression is not detected**

The existing property-options test exercises defaultValue but not defaultExpression. Thus preserving one fallback mechanism is incorrectly sufficient for the verifier.

**Violates:**
- `R2` — When enabled on an overriding bean-mapping method, property-level @Mapping declarations from overridden mapper-interface and superclass methods are inherited, including composed mappings.
- `R3` — Every behavior-bearing member of an inherited property-level @Mapping declaration is retained, including fallback expressions, qualifiers, formatting, conditions, and dependsOn ordering.
- `R15` — Java expression strings in inherited declarations remain verbatim rather than being parameter-name rewritten.

**Remedy tests (added/updated to close it):** `inheritedDefaultExpressionIsRetained`

**Broken implementation (what a plausible solver does wrong):**

In copyForSuperInheritance, copied the inherited mapping but passed null for defaultJavaExpression. This is a plausible single-field omission in a manual constructor copy containing many adjacent @Mapping members.

**Probe (how the audit demonstrated the gap):**

The parent maps first from alpha with defaultExpression = java("default-expression"); the override enables super inheritance and receives a source whose alpha is null.

**Evidence:**

Reference probe exited 0 and produced "default-expression". The broken implementation passed the full original suite (92 tests, 0 failures), while the probe produced null and failed in both compiler executions.

---

## Requirements Coverage (20 total — 15 covered, 5 gapped)

### Tier 1 — 14 covered, 3 gapped

- ✅ R1 — BeanMapping exposes boolean inheritSuperMappings() with a default value of false.
  - _spec: "Add `boolean inheritSuperMappings() default false` to `@BeanMapping`."_
- ⚠️ **R2** (gap 2, 3) — When enabled on an overriding bean-mapping method, property-level @Mapping declarations from overridden mapper-interface and superclass methods are inherited, including composed mappings.
  - _spec: "When enabled on a bean-mapping method that overrides mapper interface or superclass methods, inherit their property-level `@Mapping` declarations, including mapping compositions, without implicitly copying their other method-level mapping options."_
- ✅ R4 — inheritSuperMappings does not implicitly inherit other method-level mapping options.
  - _spec: "When enabled on a bean-mapping method that overrides mapper interface or superclass methods, inherit their property-level `@Mapping` declarations, including mapping compositions, without implicitly copying their other method-level mapping options."_
- ✅ R5 — A mapping or ignore=true declared on the current method takes precedence over an inherited declaration for the same target path.
  - _spec: "A mapping or `ignore = true` declared on the current method wins for the same target path."_
- ✅ R6 — Absent a local declaration for the target, the most specific overridden declaration wins.
  - _spec: "Otherwise the most specific overridden declaration wins."_
- ✅ R7 — Mappings for different target paths from incomparable branches are combined independently, including sibling nested target paths.
  - _spec: "Mappings for different targets from incomparable branches are combined, while competing mappings for the same target are a compilation error that identifies the target and declaring mapper types, even where those branches declare the same thing."_
- ✅ R8 — Competing mappings for the same target from incomparable branches cause compilation failure, even if identical, and the error identifies the target and all declaring mapper types.
  - _spec: "Mappings for different targets from incomparable branches are combined, while competing mappings for the same target are a compilation error that identifies the target and declaring mapper types, even where those branches declare the same thing."_
- ✅ R9 — A shared ancestor declaration contributes only once in a diamond hierarchy.
  - _spec: "A shared ancestor contributes once, and `target = "."` flattening declarations accumulate instead of competing as one target, whether they are inherited or declared on the current method."_
- ✅ R10 — All target="." flattening declarations accumulate rather than conflict, including combinations of inherited and current-method flattenings.
  - _spec: "A shared ancestor contributes once, and `target = "."` flattening declarations accumulate instead of competing as one target, whether they are inherited or declared on the current method."_
- ✅ R11 — Override discovery works through generic and transitive supertypes.
  - _spec: "Resolve override relationships through generic and transitive supertypes."_
- ⚠️ **R12** (gap 1) — When an inherited source path's leading whole segment resolves to an overridden source parameter, that segment is rebound to the overriding source parameter at the same full signature position; the remaining path, including an empty suffix, is preserved, including for renamed same-typed parameters.
  - _spec: "When an inherited source path begins with a whole path segment that the overridden method resolves to a source parameter, rebind that segment to the overriding parameter in the same signature position and keep the rest of the path, which may be empty, including when same-typed parameters are renamed."_
- ✅ R14 — A leading segment that resolves as a property remains a property; in particular, an unqualified property on a lone source parameter is not rewritten merely because it has the old parameter's spelling.
  - _spec: "A segment that resolves to a property instead keeps its meaning, so an unqualified property of a lone source parameter is left alone even when it is spelled like that parameter."_
- ⚠️ **R15** (gap 3) — Java expression strings in inherited declarations remain verbatim rather than being parameter-name rewritten.
  - _spec: "Java expression strings remain verbatim."_
- ✅ R16 — Enabling inheritSuperMappings on a method that overrides no mapping method is a compilation error rather than a silent no-op.
  - _spec: "Using the option on a method that overrides no mapping method is a compilation error, while an overridden mapping method still counts when it declares no property mappings of its own."_
- ✅ R17 — An overridden mapping method counts even when it declares no property mappings.
  - _spec: "Using the option on a method that overrides no mapping method is a compilation error, while an overridden mapping method still counts when it declares no property mappings of its own."_
- ✅ R18 — Existing explicit and automatic configuration inheritance fills only targets not already supplied by local or inherited super mappings.
  - _spec: "Existing explicit and automatic configuration inheritance fills only targets not supplied by the current or inherited super mappings, and behavior remains unchanged when the option is false."_
- ✅ R19 — When inheritSuperMappings is omitted or explicitly false, existing mapping behavior remains unchanged.
  - _spec: "Existing explicit and automatic configuration inheritance fills only targets not supplied by the current or inherited super mappings, and behavior remains unchanged when the option is false."_

### Tier 2 — 1 covered, 2 gapped

- ⚠️ **R3** (gap 2, 3) — Every behavior-bearing member of an inherited property-level @Mapping declaration is retained, including fallback expressions, qualifiers, formatting, conditions, and dependsOn ordering.
  - _spec: "When enabled on a bean-mapping method that overrides mapper interface or superclass methods, inherit their property-level `@Mapping` declarations, including mapping compositions, without implicitly copying their other method-level mapping options."_
- ⚠️ **R13** (gap 1) — Rebinding is segment-based, not textual-prefix-based, and must not pair parameters by filtered source-parameter ordinal when non-source parameter roles occur in the signature.
  - _spec: "When an inherited source path begins with a whole path segment that the overridden method resolves to a source parameter, rebind that segment to the overriding parameter in the same signature position and keep the rest of the path, which may be empty, including when same-typed parameters are renamed."_
- ✅ R20 — Conflict handling must consider all incomparable alternatives and cannot silently choose one based on declaration or traversal order.
  - _spec: "Mappings for different targets from incomparable branches are combined, while competing mappings for the same target are a compilation error that identifies the target and declaring mapper types, even where those branches declare the same thing."_
