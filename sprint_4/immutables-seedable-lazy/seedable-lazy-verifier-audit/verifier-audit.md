# ⚠️ Verifier Completeness Audit — INCOMPLETE

> Probes whether a broken-but-plausible solution could still pass the current
> tests — BEFORE any rollouts. When it finds gaps it also proposes a fix to the
> test patch. (This check replaced the old post-rollout false-positive check.)

## Verdict & Summary

- **Verdict:** INCOMPLETE — 2 demonstrated gap(s)
- **Completed:** 2026-07-25 09:47
- **Audit effort:** 30 steps · 61 messages · 874s
- **Job:** `nx7cy3mpv4m3g5113z3xe5phs58b6km3`

Audited the 12-test verifier against the specification and reference oracle, including cold/seeded states, falsey and empty values, checked failures, with-method provenance, generated and external copy paths, Modifiable behavior, serialization, invalid configurations, mixed independent attributes, and bitmap/cardinality boundaries. Two real gaps were demonstrated. For each broken implementation, the full original 12-test verifier passed, while a reference-passing probe failed. The replacement verifier adds both probes; its 14 tests pass on the reference solution. `/var/artifacts/updated_test.patch` is a full replacement, has executable mode for `test.sh`, and `git apply --check` succeeds on the pristine checkout.

## What to do with this (decision guide)

The audit demonstrated **2 gap(s)** where a plausible but broken solution still passes the current tests. On the platform you can:

- **Accept as-is** — apply the audit's proposed test patch verbatim. `proposed-changes.diff` shows exactly what it adds/changes on top of the task's `test.patch`. ⚠️ Accepting re-stales your other checks, so do it early.
- **Accept with edits** — take `proposed-changes.diff` as the starting point, adjust it, then apply. Best when the proposed tests are close but over- or under-shoot the contract.
- **Bypass** — keep your current tests; the reviewer is notified. Choose this only if a gap targets behavior the task deliberately leaves unspecified — justify it in the note.

**How to judge each gap:** weigh its severity (crash > wrong result > cosmetic) and plausibility (how likely a real solver writes that broken code), then read its broken-implementation and probe. A high-plausibility crash/wrong-result gap on a stated requirement is a real hole — prefer accept (or accept-with-edits). A gap that only bites genuinely unspecified behavior is a candidate for bypass.

Files here:
- `verifier-audit.md` — this report (complete; use it as the source of truth)
- `proposed-changes.diff` — a git-style diff of exactly what the platform proposes to change (0 new, 2 modified, 7 carried over). Apply it on top of the task's `test.patch` to get the full proposed test suite.

## Proposed-Patch Validation

The platform verified the proposed patch before offering it:

- ✅ Applies cleanly
- ✅ Base tests pass (without solution)
- ✅ New tests fail on clean repo (without solution)
- ✅ Reference passes the updated suite

```
git apply --check: ok
base (no solution): PASSED (327 tests, 326 passed, 1 skipped)
new (no solution): FAILED (1 tests, 1 failed) (exit 1)
base (with solution): PASSED (327 tests, 326 passed, 1 skipped)
new (with solution): PASSED (14 tests, 14 passed)
```

## Demonstrated Gaps (2)

### Gap 1 — WRONG RESULT · high plausibility · demonstrated

**Modifiable map mutators are not covered**

The verifier exercises builder map mutators and a Modifiable nullable-map direct setter, but never a generated Modifiable's `put`/`putAll` methods. A Modifiable implementation can therefore mutate its backing map without marking the hybrid explicitly set; accessor fallback then replaces/ignores the mutation, and even an empty `putAll` fails to establish the seed required by the specification.

**Violates:**
- `R2` — Every direct setter and collection/map mutator must establish an explicit seed, even for legal null, false, zero, empty optional, empty array, empty collection, and empty map values; before any seed, construction and mutation must leave the initializer cold.
- `R9` — An unseeded generated Modifiable computes a fresh fallback on every access without setting the attribute; unset and clear remove explicit seed state.

**Remedy tests (added/updated to close it):** `modifiableMapMutatorsEstablishSeedsEvenForEmptyInput`

**Broken implementation (what a plausible solver does wrong):**

A plausible generator wires the seed/set bit into Modifiable direct map setters but forgets to invoke the existing set-bit update from `put`, `putAll(key, values)`, and `putAll(map)` mutators.

**Probe (how the audit demonstrated the gap):**

Add a non-null map hybrid to the Modifiable fixture. Call `putAllIndex(Collections.emptyMap())` and separately `putIndex("seed", 7)`; assert `indexIsSet()`, returned explicit content, and zero fallback calls.

**Evidence:**

Reference probe `SeedableLazy_6c7a1b_Test#modifiableMapMutatorsEstablishSeedsEvenForEmptyInput` passed (1 test, 0 failures). After removing only Modifiable map-mutator set-bit updates, `./test.sh new` passed the full original verifier (12 tests, 0 failures). The probe then failed at `assertTrue(empty.indexIsSet())` with `expected: <true> but was: <false>`.

---

### Gap 2 — WRONG RESULT · medium plausibility · demonstrated

**Seed provenance beyond the first 64-bit bitmap word is not covered**

The verifier checks only two hybrid attributes. It cannot detect provenance bookkeeping that reads only the first bitmap word. Such an implementation returns the explicit value in the original object because the lazy-value bit is initialized, but loses the explicit-origin bit during `toBuilder`, causing a copied object to compute a fallback instead of preserving the seed.

**Violates:**
- `R5` — A hybrid with-method always creates explicit provenance, even when its argument equals the computed fallback; changing another attribute preserves explicit seeds but leaves omitted or computed-only fallbacks cold in the new value.
- `R6` — Generated toBuilder, builder from, and copyOf transfers preserve known explicit seeds without calling the public hybrid accessor; an unseeded source is absent and cannot erase an existing destination seed.
- `R14` — Seed and lazy bookkeeping must remain independent and total for every generated hybrid, including multiple attributes and attributes whose bit position crosses an internal bitmap-word boundary.

**Remedy tests (added/updated to close it):** `seedProvenanceCrossesBitmapWordBoundary`

**Broken implementation (what a plausible solver does wrong):**

A plausible multiword bookkeeping bug updates the correctly indexed seed bitmap during construction but implements the generated `isSeeded` helper using the unsuffixed first bitmap field for every attribute.

**Probe (how the audit demonstrated the gap):**

Generate 65 seedable-lazy attributes, explicitly seed attribute 64, then round-trip through `toBuilder` while changing another attribute. Assert that attribute 64 remains the explicit seed and its initializer is never called.

**Evidence:**

The reference passed `seedProvenanceCrossesBitmapWordBoundary` as part of a 13-test probe run. With `isSeeded` deliberately reading only the first bitmap word, `./test.sh new` passed all 12 original tests. The focused probe failed: expected preserved seed `6400`, but got computed fallback `2064`.

---

## Requirements Coverage (14 total — 9 covered, 5 gapped)

### Tier 1 — 8 covered, 4 gapped

- ✅ R1 — Recognize an accessor carrying both @Value.Lazy and @Value.Default as a seedable-lazy attribute, with explicit values accepted by generated regular builders and with-methods; strict and staged support is optional.
  - _spec: "The new mode uses an accessor annotated with both `@Value.Lazy` and `@Value.Default` and accepts an explicit value through generated builders and with-methods. This applies to regular generated builders; strict and staged builders are not required."_
- ⚠️ **R2** (gap 1) — Every direct setter and collection/map mutator must establish an explicit seed, even for legal null, false, zero, empty optional, empty array, empty collection, and empty map values; before any seed, construction and mutation must leave the initializer cold.
  - _spec: "Any direct setter or collection/map mutator establishes a seed, including legal `null`, false, zero, empty optional, empty array, and empty collection or map values. Until then, its initializer stays cold."_
- ✅ R3 — An unseeded immutable hybrid must retain normal lazy behavior, including deferred computation, successful memoization, concurrency safety, and its declared checked-exception signature.
  - _spec: "An unseeded hybrid retains ordinary `@Value.Lazy` initialization and declared checked-exception signatures."_
- ⚠️ **R5** (gap 2) — A hybrid with-method always creates explicit provenance, even when its argument equals the computed fallback; changing another attribute preserves explicit seeds but leaves omitted or computed-only fallbacks cold in the new value.
  - _spec: "Calling a hybrid with-method with a value equal to a computed fallback still establishes an explicit seed. Copying a value while changing another attribute preserves an explicit seed, but leaves an omitted or merely computed fallback cold in the copy."_
- ⚠️ **R6** (gap 2) — Generated toBuilder, builder from, and copyOf transfers preserve known explicit seeds without calling the public hybrid accessor; an unseeded source is absent and cannot erase an existing destination seed.
  - _spec: "Generated `toBuilder`, builder `from`, and `copyOf` paths preserve explicit seeds without calling the hybrid accessor. An unseeded source acts as absent and does not clear a destination seed."_
- ✅ R7 — Modifiable.from must apply the same provenance-preserving, absent-source merge rule for generated immutable and generated modifiable sources.
  - _spec: "`Modifiable.from(...)` follows the same rule for generated immutable and modifiable sources."_
- ✅ R8 — Copying from an arbitrary external implementation must neither call its hybrid getter nor infer a seed, including styles that disable builder from.
  - _spec: "Copying from an arbitrary external implementation leaves the hybrid unseeded and does not read its getter, including when a style disables builder `from`."_
- ⚠️ **R9** (gap 1) — An unseeded generated Modifiable computes a fresh fallback on every access without setting the attribute; unset and clear remove explicit seed state.
  - _spec: "A generated Modifiable returns a fresh fallback on each unseeded access without marking the attribute set; unset and clear remove explicit seeds."_
- ✅ R10 — Converting a Modifiable to immutable preserves explicit seeds but does not force or seed an unseeded hybrid.
  - _spec: "Converting it to an immutable value preserves explicit seeds and leaves unseeded hybrids cold."_
- ✅ R11 — Ordinary Java serialization must not force the hybrid and must reset both explicit-seed and computed-lazy state, so the deserialized value is cold.
  - _spec: "Ordinary Java serialization resets both explicit and computed lazy state without forcing the attribute, while generated structural serialization and marshaling omit it."_
- ✅ R12 — Generated structural serialization and marshaling must omit seedable-lazy attributes whether cold, computed, or explicitly seeded.
  - _spec: "Ordinary Java serialization resets both explicit and computed lazy state without forcing the attribute, while generated structural serialization and marshaling omit it."_
- ✅ R13 — Reject seedable-lazy attributes on interned immutable values and on types lacking generated builders or with-methods, and mention both annotations in the diagnostic.
  - _spec: "Reject the combination for interned immutable values and types without generated builders or with-methods, with a diagnostic mentioning both annotations."_

### Tier 2 — 1 covered, 1 gapped

- ✅ R4 — If an unseeded initializer throws, the failed attempt must not become a memoized value or mark initialization complete; later accesses retry ordinary lazy initialization.
  - _spec: "An unseeded hybrid retains ordinary `@Value.Lazy` initialization and declared checked-exception signatures."_
- ⚠️ **R14** (gap 2) — Seed and lazy bookkeeping must remain independent and total for every generated hybrid, including multiple attributes and attributes whose bit position crosses an internal bitmap-word boundary.
  - _spec: "Introduce seedable lazy attributes as a new generated capability."_
