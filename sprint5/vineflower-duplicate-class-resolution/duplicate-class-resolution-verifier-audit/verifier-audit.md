# ⚠️ Verifier Completeness Audit — INCOMPLETE

> Probes whether a broken-but-plausible solution could still pass the current
> tests — BEFORE any rollouts. When it finds gaps it also proposes a fix to the
> test patch. (This check replaced the old post-rollout false-positive check.)

## Verdict & Summary

- **Verdict:** INCOMPLETE — 6 demonstrated gap(s)
- **Completed:** 2026-07-27 21:13
- **Audit effort:** 22 steps · 45 messages · 852s
- **Job:** `nx78v7h014zqf29m3rhq2wtxt98ba78b`

Audited the 45-test verifier against the full specification and the reference implementation. I demonstrated six completeness gaps with plausible broken implementations: each broken implementation passed all 45 original tests, while its targeted reference-backed probe failed. I added six tests; the resulting 51-test suite passes the reference solution, and /var/artifacts/updated_test.patch was generated as a full replacement patch and verified to apply cleanly to the pristine checkout.

## What to do with this (decision guide)

The audit demonstrated **6 gap(s)** where a plausible but broken solution still passes the current tests. On the platform you can:

- **Accept as-is** — apply the audit's proposed test patch verbatim. `proposed-changes.diff` shows exactly what it adds/changes on top of the task's `test.patch`. ⚠️ Accepting re-stales your other checks, so do it early.
- **Accept with edits** — take `proposed-changes.diff` as the starting point, adjust it, then apply. Best when the proposed tests are close but over- or under-shoot the contract.
- **Bypass** — keep your current tests; the reviewer is notified. Choose this only if a gap targets behavior the task deliberately leaves unspecified — justify it in the note.

**How to judge each gap:** weigh its severity (crash > wrong result > cosmetic) and plausibility (how likely a real solver writes that broken code), then read its broken-implementation and probe. A high-plausibility crash/wrong-result gap on a stated requirement is a real hole — prefer accept (or accept-with-edits). A gap that only bites genuinely unspecified behavior is a candidate for bypass.

Files here:
- `verifier-audit.md` — this report (complete; use it as the source of truth)
- `proposed-changes.diff` — a git-style diff of exactly what the platform proposes to change (0 new, 1 modified, 2 carried over). Apply it on top of the task's `test.patch` to get the full proposed test suite.

## Proposed-Patch Validation

The platform verified the proposed patch before offering it:

- ✅ Applies cleanly
- ✅ Base tests pass (without solution)
- ✅ New tests fail on clean repo (without solution)
- ✅ Reference passes the updated suite

```
git apply --check: ok
base (no solution): PASSED (1 tests, 1 passed)
new (no solution): FAILED (51 tests, 1 passed, 50 failed) (exit 1)
base (with solution): PASSED (1 tests, 1 passed)
new (with solution): PASSED (51 tests, 51 passed)
```

## Demonstrated Gaps (6)

### Gap 1 — WRONG RESULT · high plausibility · demonstrated

**Whitespace-decorated invalid strategies can be silently normalized and accepted**

The verifier rejects middle, firstly, and error!, but never probes leading/trailing whitespace or the empty value. The accepted values are exact tokens, and the reference rejects these inputs while listing first, last, and error.

**Violates:**
- `R6` — Reject invalid option values before processing and report all accepted values.
- `R21` — The accepted-value domain is exact: whitespace-decorated strings and non-string property values are invalid and must receive the same accepted-values diagnostic rather than being normalized or failing with an unrelated type error.

**Remedy tests (added/updated to close it):** `invalidOptionWhitespaceIsRejected`

**Broken implementation (what a plausible solver does wrong):**

Parse with value.trim().toLowerCase(Locale.ROOT), a common convenience normalization. This accepts " first", "first ", tab-prefixed last, and newline-suffixed error.

**Probe (how the audit demonstrated the gap):**

Construct Fernflower for each whitespace-decorated/empty strategy and require immediate rejection whose message identifies all accepted values.

**Evidence:**

With only the trim() mutation, ./gradlew duplicateClassResolutionTest passed all 45 original tests (BUILD SUCCESSFUL). The reference passed the added probe and the complete 51-test updated suite. Running the probe against the mutation failed (BUILD FAILED) because no exception was thrown for a normalized value.

---

### Gap 2 — WRONG RESULT · high plausibility · demonstrated

**Origin coherence under error can be skipped for byte-identical duplicates when the root is unavailable**

Original family-coherence tests exercise first/last, while error tests cover plain identical duplicates and no-duplicate family splitting separately. They never combine error, an exact byte-identical own duplicate, an unavailable root, and a later member available only from the alternative origin.

**Violates:**
- `R5` — Under error, reject only byte-different inter-origin candidates; permit byte-identical candidates using the first eligible origin, and do not treat repeated entries from one origin as an inter-origin conflict.
- `R7` — An exact own-source binary-name duplicate activates origin coherence for the enclosing family.
- `R9` — Anchor a family to the selected origin of an available root, otherwise to the strategy-selected duplicate, and load subsequent members from that origin.
- `R10` — If a family member exists only outside the anchored own origin, fail and identify root, member, anchor, and every alternative origin.
- `R22` — Family activation is strategy-independent: an exact byte-identical duplicate under error still activates coherence even though it is not an error conflict.

**Remedy tests (added/updated to close it):** `errorIdenticalDuplicateStillAnchorsFamily`

**Broken implementation (what a plausible solver does wrong):**

Activate familyOrigins only when strategy != ERROR, on the assumption that error merely validates bytes and need not anchor allowed identical duplicates.

**Probe (how the audit demonstrated the gap):**

Under error, register an identical Siblings$One in two root-less own origins and Siblings$Two only in the second. The first eligible origin must anchor the unavailable-root family, so resolving all own classes must report that it cannot supply $Two.

**Evidence:**

The strategy != ERROR coherence shortcut passed all 45 original tests (BUILD SUCCESSFUL). The reference throws the required family conflict and passes errorIdenticalDuplicateStillAnchorsFamily; the shortcut returned a split family and failed the probe (BUILD FAILED: expected exception, none thrown).

---

### Gap 3 — WRONG RESULT · high plausibility · demonstrated

**last can suppress unrelated classes from an origin that loses one duplicate**

The default-first output test gives both origins unique classes, but the last output tests give the losing origin only the duplicate. Thus last may incorrectly filter at origin scope while preserving tested resource copying.

**Violates:**
- `R19` — Return every selected own class exactly once and emit it only through the selected origin's output sink.
- `R20` — Omit only losing duplicate entries; preserve nonduplicate classes and non-class resources with their original inputs.
- `R23` — Duplicate omission is class-entry scoped, not origin scoped; losing one duplicate cannot suppress unrelated classes or resources from that origin under last or error.

**Remedy tests (added/updated to close it):** `lastKeepsNonduplicateClassesFromLosingOrigin`

**Broken implementation (what a plausible solver does wrong):**

For last, mark an origin class-output-inactive once it loses any eager duplicate, rather than filtering only the losing duplicate entry.

**Probe (how the audit demonstrated the gap):**

Give the first own origin both the duplicate and a unique class, give the later origin the duplicate, then assert that last emits the unique class through the first sink and the duplicate through the later sink.

**Evidence:**

The source-scoped last filter passed all 45 original tests (BUILD SUCCESSFUL). The reference preserved both selected classes and passed lastKeepsNonduplicateClassesFromLosingOrigin; the broken implementation omitted the unique class and failed the probe (BUILD FAILED).

---

### Gap 4 — WRONG RESULT · high plausibility · demonstrated

**error coalescing can suppress unrelated classes and resources from the non-selected identical origin**

The original error-identical test verifies only which sink gets the duplicated class. It provides no unrelated class or resource on the coalesced origin, allowing whole-origin coalescing to pass.

**Violates:**
- `R5` — Under error, reject only byte-different inter-origin candidates; permit byte-identical candidates using the first eligible origin, and do not treat repeated entries from one origin as an inter-origin conflict.
- `R19` — Return every selected own class exactly once and emit it only through the selected origin's output sink.
- `R20` — Omit only losing duplicate entries; preserve nonduplicate classes and non-class resources with their original inputs.
- `R23` — Duplicate omission is class-entry scoped, not origin scoped; losing one duplicate cannot suppress unrelated classes or resources from that origin under last or error.

**Remedy tests (added/updated to close it):** `errorIdenticalDuplicatesKeepOtherClassesFromEveryOrigin`

**Broken implementation (what a plausible solver does wrong):**

When error permits an identical duplicate and chooses the first origin, treat every later origin containing that duplicate as redundant for class output instead of omitting only that duplicate entry.

**Probe (how the audit demonstrated the gap):**

Give the second byte-identical origin a unique class and resources; assert that the duplicate is emitted from the first sink while the unique class and both origins' resources remain in their original sinks.

**Evidence:**

The whole-origin error coalescer passed all 45 original tests (BUILD SUCCESSFUL). The reference passed errorIdenticalDuplicatesKeepOtherClassesFromEveryOrigin; the broken implementation omitted the second origin's unique class and failed the probe (BUILD FAILED).

---

### Gap 5 — COSMETIC · high plausibility · demonstrated

**Non-string invalid option values need not produce the required accepted-values diagnostic**

The public property map is Map<String,Object>, but every original invalid-option probe supplies a String. A direct cast can therefore pass the suite while an Integer causes an unrelated ClassCastException rather than the required diagnostic.

**Violates:**
- `R6` — Reject invalid option values before processing and report all accepted values.
- `R21` — The accepted-value domain is exact: whitespace-decorated strings and non-string property values are invalid and must receive the same accepted-values diagnostic rather than being normalized or failing with an unrelated type error.

**Remedy tests (added/updated to close it):** `nonStringInvalidOptionIdentifiesAcceptedValues`

**Broken implementation (what a plausible solver does wrong):**

Cast properties.get(DUPLICATE_CLASS_STRATEGY) directly to String before parsing instead of converting the invalid value into a parser diagnostic.

**Probe (how the audit demonstrated the gap):**

Pass Integer 17 as the option and assert rejection plus first, last, and error in the message.

**Evidence:**

The direct-cast implementation passed all 45 original tests (BUILD SUCCESSFUL). The reference passed nonStringInvalidOptionIdentifiesAcceptedValues; the direct-cast implementation failed it (BUILD FAILED) because the ClassCastException message omitted the accepted values.

---

### Gap 6 — COSMETIC · medium plausibility · demonstrated

**Byte-identical eager or lazy library duplicates can emit spurious first/last warnings**

The original no-warning test covers identical own-source duplicates only. Library warning tests use differing bytes, so a separate library path can warn merely because multiple candidates exist.

**Violates:**
- `R12` — Apply duplicate name selection to eager own inputs and eager or lazy libraries.
- `R17` — For each differing first/last decision, emit exactly one warning with class name, strategy, selected origin, registration-ordered ignored origins, and family root.
- `R24` — The differing-bytes warning condition applies uniformly to library decisions as well as own-source decisions, so byte-identical library duplicates do not warn.

**Remedy tests (added/updated to close it):** `identicalLibraryDuplicatesDoNotWarnForFirstOrLast`

**Broken implementation (what a plausible solver does wrong):**

On the library path for first/last, set the warning condition to candidates.size() > 1 rather than comparing exact bytes; retain correct comparison for own sources and error.

**Probe (how the audit demonstrated the gap):**

For both first and last, and for eager and lazy library pairs, resolve byte-identical candidates and require no warning.

**Evidence:**

The library candidate-count warning implementation passed all 45 original tests (BUILD SUCCESSFUL). The reference passed identicalLibraryDuplicatesDoNotWarnForFirstOrLast; the broken implementation emitted a warning and failed the probe (BUILD FAILED).

---

## Requirements Coverage (24 total — 11 covered, 13 gapped)

### Tier 1 — 11 covered, 9 gapped

- ✅ R1 — Expose duplicate-class-strategy with accepted values first, last, and error, defaulting to first.
  - _spec: "Add a `duplicate-class-strategy` option with the values `first`, `last`, and `error`; its default is `first`."_
- ✅ R2 — Treat every registered context source as a distinct origin even when source names are equal.
  - _spec: "Each registered context source is a distinct origin: two sources may share a human-readable name and are still separate origins."_
- ✅ R3 — Prefer every own decompilation source over every library candidate.
  - _spec: "Any own decompilation source outranks every library."_
- ✅ R4 — Within the highest-precedence tier, first/last follow root registration order and child-context list order.
  - _spec: "Within that highest-precedence tier, `first` and `last` use root registration order and child-context list order."_
- ⚠️ **R5** (gap 2, 4) — Under error, reject only byte-different inter-origin candidates; permit byte-identical candidates using the first eligible origin, and do not treat repeated entries from one origin as an inter-origin conflict.
  - _spec: "`error` rejects candidates only when their exact classfile bytes differ; byte-identical candidates are allowed and use the first eligible origin. Repeated entries from one origin are not an inter-origin conflict."_
- ⚠️ **R6** (gap 1, 5) — Reject invalid option values before processing and report all accepted values.
  - _spec: "Reject an invalid option before processing and identify the accepted values."_
- ⚠️ **R7** (gap 2) — An exact own-source binary-name duplicate activates origin coherence for the enclosing family.
  - _spec: "An exact binary-name duplicate among own sources activates origin coherence for its enclosing class family."_
- ✅ R8 — Derive member families transitively from InnerClasses and local/anonymous families from EnclosingMethod; do not infer a family from a literal dollar sign alone.
  - _spec: "Determine member families transitively from `InnerClasses` metadata and local or anonymous families from `EnclosingMethod` metadata; a literal `$` in a top-level binary name does not establish a family."_
- ⚠️ **R9** (gap 2) — Anchor a family to the selected origin of an available root, otherwise to the strategy-selected duplicate, and load subsequent members from that origin.
  - _spec: "When the family root is available, its selected origin anchors the family; otherwise the strategy-selected duplicate does. Load later members from that origin."_
- ⚠️ **R10** (gap 2) — If a family member exists only outside the anchored own origin, fail and identify root, member, anchor, and every alternative origin.
  - _spec: "If an encountered member is available only from another own origin, fail and identify the family root, member, anchored origin, and alternative origins."_
- ✅ R11 — Metadata linkage without an exact duplicate must not combine origins; independently load each class from its own source.
  - _spec: "Metadata linkage alone does not combine origins: without an exact duplicate, load each class from its own source."_
- ⚠️ **R12** (gap 6) — Apply duplicate name selection to eager own inputs and eager or lazy libraries.
  - _spec: "Apply name selection to eager inputs and to eager or lazy libraries."_
- ✅ R13 — Cache positive and negative lazy probes and resolved selections within one context.
  - _spec: "Cache positive and negative lazy probes and resolved selections within one decompiler context."_
- ✅ R14 — Registration records candidates without resolving; warnings and conflicts are deferred until selection is requested.
  - _spec: "Registering a source records its candidates without resolving them; duplicate warnings and conflicts surface when a selection is requested."_
- ✅ R15 — Adding a source invalidates affected class/family decisions, while reloadContext discards duplicate-resolution and lazy-probe state before rebuilding.
  - _spec: "Adding another context source invalidates affected class and family decisions, and `reloadContext()` discards prior duplicate-resolution and lazy-probe results before rebuilding them."_
- ✅ R16 — Keep state context-local and make winners independent of concurrent lookup or output-processing order.
  - _spec: "Keep resolution state per decompiler context; concurrent lookups or output processing must not change the winner."_
- ⚠️ **R17** (gap 6) — For each differing first/last decision, emit exactly one warning with class name, strategy, selected origin, registration-ordered ignored origins, and family root.
  - _spec: "For differing candidates resolved by `first` or `last`, emit one warning per decision that identifies the binary name, strategy, selected origin, ignored origins in registration order, and metadata family root."_
- ✅ R18 — An error conflict reports every conflicting origin in the highest-precedence tier.
  - _spec: "An `error` conflict identifies every conflicting highest-tier origin."_
- ⚠️ **R19** (gap 3, 4) — Return every selected own class exactly once and emit it only through the selected origin's output sink.
  - _spec: "Return every selected own class once and emit it only through its selected origin's output sink."_
- ⚠️ **R20** (gap 3, 4) — Omit only losing duplicate entries; preserve nonduplicate classes and non-class resources with their original inputs.
  - _spec: "Losing duplicate entries are omitted, while nonduplicate classes and non-class resources remain with their original inputs."_

### Tier 2 — 0 covered, 4 gapped

- ⚠️ **R21** (gap 1, 5) — The accepted-value domain is exact: whitespace-decorated strings and non-string property values are invalid and must receive the same accepted-values diagnostic rather than being normalized or failing with an unrelated type error.
  - _spec: "Reject an invalid option before processing and identify the accepted values."_
- ⚠️ **R22** (gap 2) — Family activation is strategy-independent: an exact byte-identical duplicate under error still activates coherence even though it is not an error conflict.
  - _spec: "An exact binary-name duplicate among own sources activates origin coherence for its enclosing class family."_
- ⚠️ **R23** (gap 3, 4) — Duplicate omission is class-entry scoped, not origin scoped; losing one duplicate cannot suppress unrelated classes or resources from that origin under last or error.
  - _spec: "Losing duplicate entries are omitted, while nonduplicate classes and non-class resources remain with their original inputs."_
- ⚠️ **R24** (gap 6) — The differing-bytes warning condition applies uniformly to library decisions as well as own-source decisions, so byte-identical library duplicates do not warn.
  - _spec: "For differing candidates resolved by `first` or `last`, emit one warning per decision that identifies the binary name, strategy, selected origin, ignored origins in registration order, and metadata family root."_
