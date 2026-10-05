# ⚠️ Verifier Completeness Audit — INCOMPLETE

> Probes whether a broken-but-plausible solution could still pass the current
> tests — BEFORE any rollouts. When it finds gaps it also proposes a fix to the
> test patch. (This check replaced the old post-rollout false-positive check.)

## Verdict & Summary

- **Verdict:** INCOMPLETE — 3 demonstrated gap(s)
- **Completed:** 2026-07-28 17:07
- **Audit effort:** 23 steps · 47 messages · 1117s
- **Job:** `nx7eg9fkqxxh2cqwjxxbxh03an8bcssa`

Audited the 82-test original verifier (52 javax + 30 Jakarta), built and exercised the reference oracle on boundary, ordering, include, invalid-input, staleness, rollback, and cross-artifact cases, and found three real completeness gaps. The original suite covered the stated top-level behaviors broadly, but did not pin recursive dependency discovery through nested approved includes, symlink-safe containment of approved includes, or identity-preserving rethrow of the commit IOException. For each gap, a plausible broken implementation passed the full original suite and failed an oracle-backed probe. I produced /var/artifacts/updated_test.patch as a full replacement verifier, added equivalent remedies to both artifacts, verified it applies to the pristine checkout, and ran it against the reference successfully (55 javax + 33 Jakarta tests).

## What to do with this (decision guide)

The audit demonstrated **3 gap(s)** where a plausible but broken solution still passes the current tests. On the platform you can:

- **Accept as-is** — apply the audit's proposed test patch verbatim. `proposed-changes.diff` shows exactly what it adds/changes on top of the task's `test.patch`. ⚠️ Accepting re-stales your other checks, so do it early.
- **Accept with edits** — take `proposed-changes.diff` as the starting point, adjust it, then apply. Best when the proposed tests are close but over- or under-shoot the contract.
- **Bypass** — keep your current tests; the reviewer is notified. Choose this only if a gap targets behavior the task deliberately leaves unspecified — justify it in the note.

**How to judge each gap:** weigh its severity (crash > wrong result > cosmetic) and plausibility (how likely a real solver writes that broken code), then read its broken-implementation and probe. A high-plausibility crash/wrong-result gap on a stated requirement is a real hole — prefer accept (or accept-with-edits). A gap that only bites genuinely unspecified behavior is a candidate for bypass.

Files here:
- `verifier-audit.md` — this report (complete; use it as the source of truth)
- `proposed-changes.diff` — a git-style diff of exactly what the platform proposes to change (0 new, 4 modified, 1 carried over). Apply it on top of the task's `test.patch` to get the full proposed test suite.

## Proposed-Patch Validation

The platform verified the proposed patch before offering it:

- ✅ Applies cleanly
- ✅ Base tests pass (without solution)
- ✅ New tests fail on clean repo (without solution)
- ✅ Reference passes the updated suite

```
git apply --check: ok
base (no solution): PASSED (921 tests, 921 passed)
new (no solution): FAILED (88 tests, 30 failed, 58 errored) (exit 1)
base (with solution): PASSED (921 tests, 921 passed)
new (with solution): PASSED (88 tests, 88 passed)
```

## Demonstrated Gaps (3)

### Gap 1 — WRONG RESULT · high plausibility · demonstrated

**Approved include containment is not tested through a symbolic link to outside the JSP root**

The verifier checks direct and traversal-based outside includes, selected symlinks, and usage symlinks, but never an approved include whose directory entry is beneath the JSP root and whose symlink target is outside. A default Files.isRegularFile(path) check follows that link and allows planning to consume an outside-root resource instead of throwing IllegalArgumentException.

**Violates:**
- `R4` — Dependency discovery uses parsed custom-tag invocations, includes invocations in approved inlined includes, resolves approved includes beneath the JSP root, and ignores JSP comments.
- `R8` — Every enumerated invalid selection, include, invocation-name, and destination condition throws IllegalArgumentException.
- `R17` — Approved-include containment must be symlink-safe: a lexically in-root include symlink whose target is outside is still an outside-root include and must be rejected.
- `R16` — Successful commits leave no transaction artifacts, do not touch unrelated paths, preserve subclass hooks, and behave equivalently in javax and Jakarta artifacts.

**Remedy tests (added/updated to close it):** `approvedIncludeSymlinkToOutsideRootIsRejected`, `jakartaApprovedIncludeSymlinkToOutsideRootIsRejected`

**Broken implementation (what a plausible solver does wrong):**

In resolveIncludedFile, use Files.isRegularFile(path) rather than Files.isRegularFile(path, LinkOption.NOFOLLOW_LINKS). This is a standard hurried implementation: lexical startsWith containment plus the default regular-file predicate.

**Probe (how the audit demonstrated the gap):**

Create /WEB-INF/linked.jsp.inc as a symlink to ../outside.jsp.inc, approve and include /WEB-INF/linked.jsp.inc from a selected tag, and require planning to throw IllegalArgumentException in both artifacts.

**Evidence:**

Reference probe run: 2 probes, 0 failures, BUILD SUCCESS. The combined broken implementation (following include symlinks in both artifacts and wrapping commit IOExceptions) passed the full original verifier: javax 52/52 and Jakarta 30/30, BUILD SUCCESS. Its symlink probe failed with "Expected planning to fail." The updated verifier passes on the reference: javax 55/55 and Jakarta 33/33.

---

### Gap 2 — WRONG RESULT · high plausibility · demonstrated

**Dependency discovery is not tested through nested approved includes**

All include-dependency tests use a single include level. The specification covers invocations in approved inlined includes without limiting nesting, so dependency traversal must continue through an approved include inside another approved include. Missing the nested edge can select a dependent first and make a valid batch reject as unresolved.

**Violates:**
- `R4` — Dependency discovery uses parsed custom-tag invocations, includes invocations in approved inlined includes, resolves approved includes beneath the JSP root, and ignores JSP comments.
- `R6` — Dependencies precede dependents, conversions use a virtual view of earlier conversions, the lexically first ready path is selected, and input order does not affect the plan.
- `R18` — Dependency discovery must recurse through nested approved includes; an invocation in an approved include nested within another approved include remains an invocation in an approved inlined include.
- `R16` — Successful commits leave no transaction artifacts, do not touch unrelated paths, preserve subclass hooks, and behave equivalently in javax and Jakarta artifacts.

**Remedy tests (added/updated to close it):** `nestedApprovedIncludesParticipateInDependencyOrdering`, `jakartaNestedApprovedIncludesParticipateInDependencyOrdering`

**Broken implementation (what a plausible solver does wrong):**

Track include depth in the parsed-node visitor and recurse only through the first approved include level. This shortcut still handles every top-level/direct approved-include case in the original suite.

**Probe (how the audit demonstrated the gap):**

Select a.tag and z.tag where a.tag includes approved one.jsp.inc, one.jsp.inc includes approved two.jsp.inc, and two.jsp.inc invokes my:z. Require order z.tag then a.tag and a.jte to call template.my.z in both artifacts.

**Evidence:**

The reference oracle accepted the nested include case and the final updated suite passes it in both artifacts. The one-level-only broken visitor passed all 82 original tests (52 javax + 30 Jakarta), then the dedicated probe errored with "Missing converter for custom tag: <my:z />" and BUILD FAILURE.

---

### Gap 3 — WRONG RESULT · high plausibility · demonstrated

**Rollback tests do not require rethrowing the exact original IOException instance**

Existing rollback tests assert IOException type, message fragments, restored state, and recursive suppressed messages, but not exception identity. An implementation can wrap the triggering IOException after a correct rollback, copy its suppressed exceptions, and pass while violating "rethrowing the original failure."

**Violates:**
- `R15` — After a mutating IOException, commit restores exact pre-commit bytes or absence, including created directories, rethrows the original failure, and suppresses restoration failures onto it.
- `R19` — Rethrowing the original commit IOException means preserving the exact exception instance rather than wrapping it after rollback.
- `R16` — Successful commits leave no transaction artifacts, do not touch unrelated paths, preserve subclass hooks, and behave equivalently in javax and Jakarta artifacts.

**Remedy tests (added/updated to close it):** `commitRethrowsTheOriginalIOExceptionInstance`, `jakartaCommitRethrowsTheOriginalIOExceptionInstance`

**Broken implementation (what a plausible solver does wrong):**

After rollback, construct new IOException(failure.getMessage(), failure), copy failure.getSuppressed() to the wrapper, and throw the wrapper. Wrapping at a transaction boundary is a common implementation choice.

**Probe (how the audit demonstrated the gap):**

Have FailingPathFileSystem retain the exact IOException instance it injects, commit a plan that fails after mutation starts, and assert that the surfaced Throwable isSameAs that retained instance in both artifacts.

**Evidence:**

The reference identity probe passed. The wrapping implementation, combined with the symlink shortcut, passed the full original 82-test verifier. The dedicated identity probe then failed its isSameAs assertion. Updated reference validation passes 55 javax and 33 Jakarta tests.

---

## Requirements Coverage (21 total — 13 covered, 8 gapped)

### Tier 1 — 11 covered, 5 gapped

- ✅ R1 — planTags accepts a non-empty collection of root-relative .tag paths and returns a migration plan.
  - _spec: "`JspToJteConverter.planTags(Collection<String>, Consumer<Converter>)` accepts a non-empty collection of root-relative `.tag` paths and returns a migration plan."_
- ✅ R2 — Plan accessors expose normalized absolute paths, final UTF-8 write content, and immutable collections.
  - _spec: "`getConversionOrder()` and `getDeletes()` return normalized absolute `Path` values, while `getWrites()` maps normalized absolute paths to their final UTF-8 content. These collections are immutable."_
- ✅ R3 — Planning is read-only and must not mutate the filesystem, including on failure.
  - _spec: "Planning does not change the filesystem."_
- ⚠️ **R4** (gap 1, 2) — Dependency discovery uses parsed custom-tag invocations, includes invocations in approved inlined includes, resolves approved includes beneath the JSP root, and ignores JSP comments.
  - _spec: "It finds dependencies from parsed custom-tag invocations, including invocations in approved inlined includes; an approved include path is resolved against the converter's resource base and must resolve beneath the JSP root. JSP comments do not create dependencies."_
- ✅ R5 — Parser setup, suppressions, and getNotConvertedTags apply to every selected tag.
  - _spec: "Parser setup, suppressions, and `getNotConvertedTags()` apply to every selected tag."_
- ⚠️ **R6** (gap 2) — Dependencies precede dependents, conversions use a virtual view of earlier conversions, the lexically first ready path is selected, and input order does not affect the plan.
  - _spec: "Dependencies are converted before their dependents against a virtual view of earlier conversions: each step takes the lexically first root-relative path whose dependencies are already converted, so input order does not affect the plan."_
- ✅ R7 — Cycles reject planning with a deterministic closed path.
  - _spec: "A cycle reports a deterministic closed path."_
- ⚠️ **R8** (gap 1) — Every enumerated invalid selection, include, invocation-name, and destination condition throws IllegalArgumentException.
  - _spec: "Planning rejects null or empty input, null or blank paths, normalized duplicates, absolute paths, paths outside the JSP root, non-`.tag` inputs, missing or non-regular inputs, selected symbolic links, approved includes outside the JSP root, ambiguous selected invocation names, colliding generated destinations, destinations outside the JTE root, and destinations whose path is already taken, including by a symbolic link; each of these is an `IllegalArgumentException`."_
- ✅ R9 — Unresolved non-suppressed tags and parse/setup/conversion failures reject the whole plan; parser setup failures surface unchanged.
  - _spec: "Unresolved non-suppressed tags and parse, setup, or conversion failures also reject the whole plan, and a failure thrown by the parser setup consumer surfaces unchanged rather than wrapped."_
- ✅ R10 — Writes contain every generated template and final affected JSP-source content exactly once; selected tags are deleted; deleted and unchanged scanned files are not writes.
  - _spec: "The plan writes each generated JTE template and the final content of every affected `.jsp`, `.jsp.inc`, and `.tag` file under the JSP root, with a file that is rewritten several times represented once. It deletes every selected JSP tag; deleted files and unchanged scanned files are not writes."_
- ✅ R11 — Batch-generated templates preserve existing one-tag parser setup and per-tag conversion behavior.
  - _spec: "Each generated template uses the same parser setup and per-tag conversion rules as existing one-tag conversion."_
- ✅ R12 — Before any mutation, commit compares selected, included, and scanned content snapshots and verifies all generated destinations remain absent; timestamp equality cannot hide content changes.
  - _spec: "Before its first mutation, `commit()` compares the content of every selected, included, and usage-scanned file with the planning snapshot and verifies that every generated destination is still absent. Timestamp equality does not make changed content current."_
- ✅ R13 — Staleness throws StaleJspMigrationPlanException, aggregates all changed normalized absolute paths once in lexical order, and causes no planned mutation.
  - _spec: "Staleness throws `StaleJspMigrationPlanException`; `getChangedPaths()` returns all changed normalized absolute paths, each listed once, in lexical order, and no planned mutation occurs."_
- ✅ R14 — A successfully committed plan cannot commit successfully again.
  - _spec: "A successful plan commits only once."_
- ⚠️ **R15** (gap 3) — After a mutating IOException, commit restores exact pre-commit bytes or absence, including created directories, rethrows the original failure, and suppresses restoration failures onto it.
  - _spec: "If an `IOException` occurs after mutation begins, commit restores every affected path, including directories it created, to its exact pre-commit bytes or absence before rethrowing the original failure. Failures during that restoration are attached as suppressed exceptions."_
- ⚠️ **R16** (gap 1, 2, 3) — Successful commits leave no transaction artifacts, do not touch unrelated paths, preserve subclass hooks, and behave equivalently in javax and Jakarta artifacts.
  - _spec: "Successful commits leave no temporary files, unrelated paths remain untouched, subclass hooks keep working, and the `javax` and Jakarta artifacts provide equivalent behavior."_

### Tier 2 — 2 covered, 3 gapped

- ⚠️ **R17** (gap 1) — Approved-include containment must be symlink-safe: a lexically in-root include symlink whose target is outside is still an outside-root include and must be rejected.
  - _spec: "It finds dependencies from parsed custom-tag invocations, including invocations in approved inlined includes; an approved include path is resolved against the converter's resource base and must resolve beneath the JSP root."_
- ⚠️ **R18** (gap 2) — Dependency discovery must recurse through nested approved includes; an invocation in an approved include nested within another approved include remains an invocation in an approved inlined include.
  - _spec: "It finds dependencies from parsed custom-tag invocations, including invocations in approved inlined includes; an approved include path is resolved against the converter's resource base and must resolve beneath the JSP root."_
- ⚠️ **R19** (gap 3) — Rethrowing the original commit IOException means preserving the exact exception instance rather than wrapping it after rollback.
  - _spec: "If an `IOException` occurs after mutation begins, commit restores every affected path, including directories it created, to its exact pre-commit bytes or absence before rethrowing the original failure."_
- ✅ R20 — Validation and conversion alternatives are all-or-nothing: no earlier successful conversion may leak filesystem mutation when a later alternative fails.
  - _spec: "Planning does not change the filesystem. Unresolved non-suppressed tags and parse, setup, or conversion failures also reject the whole plan, and a failure thrown by the parser setup consumer surfaces unchanged rather than wrapped."_
- ✅ R21 — Independent ready alternatives must remain independently selectable and use lexical fall-through rather than collection/input order.
  - _spec: "Dependencies are converted before their dependents against a virtual view of earlier conversions: each step takes the lexically first root-relative path whose dependencies are already converted, so input order does not affect the plan."_
