# Immutables — Compact Versioned Binary Serialization with Schema Evolution — Plan

> Repository: `immutables/immutables` (`org.immutables` value processor) · Base commit: `8c542075`
> Problem: `binary-serialization` · Work dir: `my-work/immutables-binary-serialization/`
> Tier: Diamond · Target: rollout median ~0.4–0.6; solution comfortably > the ~380 hard floor (guides-review/check_loc.md), aiming ~650–900 solution eff LoC
> Successor to the killed `immutables-polymorphic-json` (JSON = self-describing = materialize-solvable = easy). This is the codeforces HARD version of the serialization task: drop field-names-on-the-wire → a positional, materialize-proof codec.
> Immutable once W3 begins; empirical-gate evidence appended as dated addenda.

## 0. Why this is the honest hard version (Gate-C already GO)

The core insight: **JSON is self-describing, so materialize-to-tree always dissolves the difficulty — no JSON codec is materialize-proof.** The honest easy→hard axis for "immutables serialization" is *self-describing → not*: a compact BINARY codec on a bare `DataOutput`/`DataInput` has no `nextName()`/`skipValue()` primitive and no reflective escape, so there is **no read-whole-tree shortcut**. The read must be a positional, stateful, single-pass state machine, and cross-version tolerance forces a real protocol.

**Gate-C (naive-agent gauntlet, 2026-07-01): GO.** A fresh strong agent found the core MATERIALIZE-PROOF and DERIVE-NOT-RECALL: the TLV *strategy* is recalled, but the compact + positional + nested + **bidirectionally version-tolerant** + type-change-safe instantiation is real derivation, with the difficulty-defining property that **same-version round-trip goes green fast and hides every cross-version bug**. Confidence HIGH same-version, LOW on the cross-version matrix — "that gap IS the difficulty." Est ~900–1300 total eff LoC (solution ~650–900). Both gates Idea 1 failed (ceiling + volume) clear here.

## 1. Repo philosophy & demand (dodging the auto-reject on scope — guides-review/check_solution.md)

This COMPLETES an existing repo vein rather than grafting:
- **`Parcelables.generator`** is the repo's only positional-binary codec (Android `Parcel`), and it PUNTS on exactly the hard parts — primitives/String/primitive-arrays only, everything else delegated to `Parcel.writeValue(...)`, with source `FIXME: read objects and complex types` / `FIXME: Do something with short arrays` / "maybe many more if-else specializations needed for arrays, lists, maps", and ZERO version/evolution logic.
- **`@Serial.Version` / `@Serial.Structural`** (`SerialMirrors.java`; `SerialForm` in `Immutables.generator`) is the repo's versioned/structural serialization — but the structural form is NAME-tagged (`String[] names` + `Object[] values`) handed to `ObjectOutputStream`, i.e. materialize-in-disguise, not compact/positional.
- **Demand:** issue #312 "Avro Serialization" asks for binary + schema evolution ("schema evolution is a hard requirement for our usage"); maintainer: "we might have something if we can find a volunteer to contribute a solution … Immutables supports native java serialization, JSON and other binary serialization." So a native compact evolvable binary codec is wanted + welcomed + non-duplicate (no such codec exists).
- **Framing** (for the description + review): the natural completion of the positional-binary (Parcelables) + versioned (@Serial) vein — a compact, evolvable binary serialization the value types own, no external dependency.

## 2. What it is (behavioral + wire)

For a `@Value.Immutable` opted into binary serialization, generate code that writes each value to a `java.io.DataOutput` and reads it back from a `DataInput`, compactly and positionally (no field names). The format tolerates SCHEMA EVOLUTION across model versions:
- **Forward** — data written by a NEWER model (extra appended attributes) is readable by code built against an OLDER model, which ignores the unknown data.
- **Backward** — data written by an OLDER model (missing the newer attributes) is readable by the NEWER model, which supplies the newer attributes' default/absent values.
- Optionals/`@Nullable` encode present/absent compactly; collections/sets/maps/multimaps are length-prefixed; nested immutable values recurse and are self-delimited so a nested type that evolved independently cannot desync the outer cursor.
- Round-trip of any value yields an equal value; cross-version round-trip yields the correctly defaulted/truncated value.

```
write(V2{name="a", age=3, email="x", tags=[t]})  -> bytes
read as V1 (knows name,age only)                  -> V1{name="a", age=3}     // skips unknown ordinals by length
write(V1{name="a", age=3})                        -> bytes
read as V2 (knows name,age,email,tags)            -> V2{name="a", age=3, email=<default>, tags=[]}  // defaults missing
```

## 3. Why it's hard at its core (withheld algorithm; the analogs punt exactly here)

- **Materialize-proof:** `DataInput` has no self-describing skip; you cannot slurp-and-reparse without the schema. The two repo escapes (SerialForm's `ObjectOutputStream`, Parcel's `writeValue(classLoader)`) are unavailable on bare `DataOutput`/`DataInput`. So the read is a forced positional state machine.
- **The compact-vs-skippable tension (the derivation):** "compact/positional/no-names" fights "skip-unknown" (skippability needs self-description). The correct middle is an **ordinal+length frame** per field (`[ordinal][len][payload]`, sorted by ordinal) — you must RECOGNIZE you have to reintroduce a length frame (paying compactness) rather than writing bare positional fields like Parcelables does. A bare-positional codec round-trips same-version perfectly and **silently fails cross-version**.
- **Backward-default** (missing older field) is asymmetric to skip and interacts with mandatory/`@Value.Default`/`@Nullable`/collection-empty and the strict builder — a mandatory added attribute with no default is unrepresentable on backward read (→ a compile-time constraint the agent must DISCOVER).
- **Nested version skew** forces length-delimiting sub-records so outer/inner cursors can't desync under independent evolution.
- **Type-change / ordinal discipline** (append-only ordinals or per-field type tags) — TLV-skip keeps the frame intact but mis-interprets a changed type.
- **Enum evolution** (ordinal = compact-but-fragile vs name = safe) — a real per-kind decision.

The naive approach (bare positional, like Parcelables) COMPILES and passes same-version; it is trial-compile-oracle resistant (only cross-version behavior differs).

## 4. Independent semantic forks (each a DIFFERENT failure; ablation-provable)

| # | Fork | Naive choice → failure | Test that fails on naive |
|---|------|------------------------|---------------------------|
| F1 | Per-field ordinal+length framing | bare positional values | interleaved/skip cases desync (F2/F5 depend on this) |
| F2 | Forward-skip unknown (incl. interleaved, not just trailing) | read past-end / can't skip a middle unknown | newer-data → older-reader yields the older projection |
| F3 | Backward-default missing older field | read past-end → error | older-data → newer-reader yields defaults (Default/Optional/empty) |
| F4 | Nested-value self-delimiting (version skew) | outer cursor desyncs when nested type grew | nested type at differing versions round-trips within an outer value |
| F5 | Ordinal/type discipline (append-only or type-tag) | reuse ordinal / in-place type change → mis-decode | a type-changed attribute across versions is rejected or safely handled |
| F6 | Enum by name (not ordinal) | `ordinal()` → reorder corrupts | reordered enum constants across versions still decode correctly |
| F7 | Per-kind matrix (collections/maps/multimaps/optionals×7/arrays/primitives) | punt like Parcelables | every kind round-trips (the 449-fixture corpus + kind fixtures) |

**Ablation (W4):** one injected bug → exactly one fork's tests; e.g. dropping the length frame reds F2+F5 only if they share the frame — so design F2 (interleaved) and F5 (nested) to fail on *distinct* bugs (skip-loop vs sub-record delimiting).

## 5. Anti-thin forcing mandate

Mandatory across the whole attribute matrix (every kind) with no per-case punt (Parcelables' punt is the anti-pattern) — the value-fixture corpus (S4) is the forcing function. The anti-bypass invariant: cross-version (forward-skip-interleaved + backward-default + nested-skew) must pass — defeats bare-positional same-version-only codecs. LoC = per-branch, MEASURED at Gate B (hardest branch = the skip-unknown read loop + backward-default + nested self-delimiting).

## 6. Gate A — cascade (score geometry)

Central commitment = "ordinal+length framed, evolution-tolerant positional codec." Get it wrong (bare positional) → pass same-version (F7 baseline) but FAIL F2/F3/F4/F5 (the cross-version cluster) = the majority of the graded suite. Same-version per-kind tests (F7) are the attributable-edge layer. Cross-version cluster > 50% → median reachable. Every failing test maps to the stated evolution contract.

## 7. Gate B — MEASURE (next; the spike)

Build the hardest branch in the worktree: the ordinal+length write + the skip-unknown read loop + backward-default + one nested self-delimited value + 3–4 representative kinds, with the two-version cross-feed test. MEASURE effective LoC (target the solution comfortably clears ~380, projecting ~650–900). Fill: _<spike addendum>_.

## 8. Harness (reuse the proven env)

- **Env:** reuse `my-work/immutables-structural-patch/` `Dockerfile` + `test.sh` (offline `-pl value-fixture -am`), baseline ~323 tests. Distinctive hidden test class `BinarySerialization_<hex>_Test.java`.
- **Trigger / compile-on-base:** opt in via an existing/base-compilable construct (extend `@Serial` or a `@Value.Style`/marker that compiles on base); fixtures use only base annotations so the test file compiles on base and fails at runtime (codec absent). Reach generated codec methods via REFLECTION.
- **Cross-version test bed (the key harness design):** two fixture types `V1{a,b}` and `V2{a,b,c(default),d}` sharing ordinal layout; the test serializes V2 and reads with the V1 codec (forward-skip) and vice-versa (backward-default), plus a nested type at differing versions (F4). The assertion is the OUTCOME (cross-version round-trip value), solution-relative (each faithful codec's own bytes are cross-compatible) — so two faithful codecs both pass; the wire format is never pinned.
- **Four-state offline** then container ×2. Grading hygiene per the extract-interface Env-Linter note.

## 9. Why accepted / dodges anti-patterns

Extends an existing seam (Parcelables/@Serial) · 7 forks failing different tests · intuitive design (bare positional) is observably wrong on cross-version · contract-only tests (two faithful codecs pass) · behavioral Mars-style description · materialize-proof (not a READ) · voluminous (net-new codec, measured) · not a famous-spec telegraph (TLV strategy recalled, but the compact+nested+bidirectional instantiation is derive-not-recall — Gate-C confirmed) · fair (cross-version outcome observable, no wire-format pinning).

## 10. Draft title + description (Mars-style, behavioral — finalized at W3 with clause↔test trace)

Title: **Compact evolvable binary serialization**. Description states the outcomes: opt-in binary read/write to `DataOutput`/`DataInput`; compact/positional; forward+backward schema-evolution (skip unknown newer, default missing older); optionals/collections/maps/nested handled; round-trip + cross-version round-trip equality; a per-type schema version increments as attributes are appended; added attributes must be defaultable. No wire-format prescription.
