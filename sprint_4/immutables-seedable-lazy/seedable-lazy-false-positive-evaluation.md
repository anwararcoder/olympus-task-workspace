# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 1 — false positives: 0, genuine passes: 1
- **Requested:** 2026-07-26 15:27
- **Completed:** 2026-07-26 15:53
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Orion #3 — ✅ Genuine pass · high confidence

- **Run:** `rd73p726cmzph3ezbcyw0srw498b89s2` | **Agent:** Orion | **Judge dissent:** Yes | **Panel duration:** 25m 46s

### Adjudicator — ✅ Genuine pass · high confidence

The pass is legitimate: the candidate is a faithful, complete implementation of seedable lazy attributes and passes the exhaustive hidden suite (13/13) plus 326 baseline tests, reproduced independently. One genuine but non-prompt robustness gap exists and is worth a follow-up (not a reward-blocking defect): unlike the surrounding generator (and the reference), the candidate emits its synthetic helper names ([name]$seed(), [name]$isSeeded(), [name]$seeded, [name]$lazy) WITHOUT the codebase's disambiguateAccessor/$$ convention, so a model with an attribute literally named e.g. value$seed() produces uncompilable generated code. Realistically unreachable ('$' is JLS-discouraged in source), but tightening it would match the library's existing disambiguation discipline.

**Probe re-run reasoning:**

I reproduced the verifier independently in /tmp/fp-adjudicate/verifier (test.sh new -> 13/13 + negative compilation, BUILD SUCCESS). Judges a and b agree TP; judge-c is a solo false_positive resting on a name-collision probe (an attribute named value$seed() colliding with the generated value$seed() seed-helper). I re-ran that probe on both states: candidate fails to compile ('method value$seed() is already defined in class ImmutableSeedableLazyCollisionProbe') while the reference passes because it wraps its seed helpers in disambiguateAccessor (appends $$). So the probe genuinely discriminates. However it is NOT fair against the prompt: the prompt exhaustively enumerates ~13 semantic requirements and says nothing about collision-safety of internal $seed/$seeded helper suffixes; the discriminator is only reachable via a '$' in a hand-written attribute name, which JLS 3.8 reserves for machine-generated code and no realistic user model contains; and it effectively demands parity with a reference implementation detail (the $$ convention). Per the rubric, a solo FP is upheld only when its probe is fair AND discriminates. It discriminates but is unfair, so it is over-flagging. The pass survives scrutiny.

**Independent read (before panel evidence):** ✅ Genuine pass

The candidate is a substantive, coherent implementation of seedable lazy attributes: it adds isGenerateSeedableLazy to the meta-model, threads $seed/$seeded provenance through the immutable and modifiable generators (getter short-circuit, withers guarded by $seeded, from/toBuilder/copyOf, transient fields + readObject reset, Gson/structural omission), and rejects interned / no-builder / no-wither combinations with a diagnostic naming both annotations. The hidden verifier suite is exhaustive (co…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted) — Verdict true_positive/high. Attempted 4 fair-edge falsification probes, all passed on the candidate; reproduced the verifier pass. Matches my independent view and the exhaustive hidden coverage.
- **judge-b** (trust: trusted) — Verdict true_positive/high. Aggressively probed under-tested combinations (copyOf-with-from-disabled, wither-equal-to-fallback, modifiable unseeded access, equals/serialization leaks) and found no fair discriminator; noted only unrequested auxiliary-generator interactions. Consistent with my view.
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Solo false_positive/high. Its collision probe genuinely discriminates (I reran: candidate fails to compile with 'method value$seed() is already defined'; reference passes). But it is unfair against a prompt-grounded standard: the prompt never mentions internal-helper collision safety, and the case …

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `TRUE_POSITIVE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass: a principled, comprehensive seedable-lazy implementation passes an exhaustive hidden suite plus baseline and negative compilation; all fair falsification probes also pass.

**Details / suggested hardening:**

Strong true positive. The candidate implements seedable lazy attributes across immutable and modifiable generation with correct provenance tracking (transient $seeded/$seed fields, guarded withers, from/toBuilder/copyOf transfer via $isSeeded), correct serialization/marshaling omission, and correct rejection diagnostics naming both annotations. It passes all 13 exhaustive hidden tests, the negative compilation suite, and 326 baseline tests, and its design mirrors the reference solution. Falsification against fair-but-lightly-tested seed shapes (present optional via unwrapped setter, non-null nullable, array, single-entry map, and their preservation across toBuilder/from) found no divergence. No fairly-required behavior is mishandled.

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 9 (0 failed)
- **Duration:** 14m 09s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. The candidate implements seedable lazy attributes thoroughly across the processor and both generators; the 13-test hidden suite (covering every prompt requirement) and 326 baseline tests all pass, and 3 fair probe tests for under-tested edge combinations also pass. No fair discriminator found.

**Details / suggested hardening:**

Strong, legitimate solve. The implementation correctly handles seeding (incl. falsey/empty values), cold/computed/explicit provenance, wither/from/toBuilder/copyOf transfer without forcing the accessor, external-impl non-probing (incl. from-disabled), modifiable fresh-fallback + unset/clear + conversion semantics, Java-serialization reset, structural/marshaling omission, specialized optionals, and rejection diagnostics. Minor non-blocking observation: auxiliary generators (Parcelables/Transformers/Visitors/OkJsons/Datatype) still iterate the now-broadened getSettableAttributes and are not adapted for seedable lazy, but the prompt does not require hybrid support there.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 13 (0 failed)
- **Duration:** 16m 27s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: core semantics pass, but a fair legal-accessor collision probe makes the candidate's generated code uncompilable.

**Details / suggested hardening:**

The pass is loose-verifier false positive rather than a merely different implementation. The candidate covers the substantive seed/copy/modifiable/serialization behaviors, but its seed bookkeeping helper is derived as <attribute>$seed without the generator's normal disambiguation. A legal sibling accessor value$seed() therefore collides with the generated helper; the candidate fails compilation while the reference passes. The hidden suite should add a generated-member namespace collision case.

- **Discriminator found:** Yes — `SeedableLazyCollisionProbeTest.legalAccessorNamesDoNotCollideWithGeneratedSeedBookkeeping`
- **Falsification attempts:** 4
- **Requirements checked:** 10 (1 failed)
- **Duration:** 17m 20s
