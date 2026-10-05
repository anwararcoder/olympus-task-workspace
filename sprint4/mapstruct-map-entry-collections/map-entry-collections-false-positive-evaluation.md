# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 2 — false positives: 0, genuine passes: 2
- **Requested:** 2026-07-21 03:53
- **Completed:** 2026-07-21 04:09
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Nova #2 — ✅ Genuine pass · high confidence

- **Run:** `rd7ehg5245sj914bbfkgbh87b58az3dy` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 15m 23s

### Adjudicator — ✅ Genuine pass · high confidence

The pass is deserved. The candidate correctly implements bidirectional Map<->iterable/array entry mapping matching the prompt and passes the full hidden suite (32) and baseline (3641). The one flagged defect (a source element type literally named 'Entry' collides with the generated 'entry' loop/mapped-entry local, causing 'Duplicate local variable entry') is real but is ALSO present in the reference solution, so it is a pre-existing edge-case limitation beyond this task's contract rather than a candidate-specific regression. If maintainers want to harden this, derive the mapped-entry local name from a variable set that also excludes the loop variable in MapMappingMethod.getEntryVariableName().

**Probe re-run reasoning:**

I re-ran the hidden suite result (test_execution.log shows 32/32 pass) and independently re-ran judge-c's sole discriminating probe (EntryNameCollisionProbeTest) on both the candidate/verifier state and the reference state. BOTH fail identically with 'Duplicate local variable entry' (see collision-verifier.log and collision-reference.log). Because the ground-truth reference implementation exhibits the exact same behavior, the probe does not discriminate a correct solution from the candidate, and the 'element type literally named Entry' collision is beyond the task's fair contract. Judge-a and judge-b independently reached true_positive; their falsification attempts (Map<->Set generalization, stream-boundary preservation, abstract-entry construction, lower-bounded maps) all resolved in the candidate's favor, matching my own reading.

**Independent read (before panel evidence):** ✅ Genuine pass

The prompt requires bidirectional Map<->iterable/array entry mapping with iteration order, normal method selection/conversions, iterable qualifiers, logical key/value targets for Map.Entry, and compatible lower-bounded map results. The candidate implements all of these via generic type-system/model paths (getMapEntryType, buildIterableToMapMapping, entrySet() iteration, AbstractMap.SimpleEntry construction, getMapEntryTypeWithBounds), and the comprehensive 32-test hidden suite plus the 3641-tes…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Authored a fair Map<->Set extension probe that PASSED on the candidate, correctly concluding the implementation generalizes rather than special-casing. Verdict true_positive, aligned with mine. No discriminator found; I did not need to re-run since it supports TP.
- **judge-b** (trust: trusted) — Enumerated the fairly-required behaviors and probed the hardest cases (iteration order, update targets, qualifiers, conversions, inheritance, subtypes, lower-bounded results, null strategies, stream boundaries); found no discriminator. Correctly rejected 'forging without an explicit entry method' a…
- **judge-c** (trust: distrusted, fair probe: No, discriminates: No) — Solo false_positive. Its discriminator (source element class named 'Entry' causing a generated local-name collision) is real for the candidate but I confirmed by re-running that the REFERENCE solution fails identically ('Duplicate local variable entry'). Judge-c even tagged SPEC_GAP_REFERENCE_ALSO_…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `REFERENCE_ALSO_FAILS`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass: a substantive, generic implementation of bidirectional Map<->iterable/array entry mapping; the comprehensive hidden suite and full baseline pass, and a fair Map<->Set extension probe also passes. No fairly-required behavior is mishandled.

**Details / suggested hardening:**

This is a true positive. The candidate implements the map-entry element mapping feature through generic type-system and mapping-method paths (Type.getMapEntryType, MapMappingMethod.buildIterableToMapMapping, IterableMappingMethod element-type override, entrySet() iteration in the FreeMarker templates, and forged SimpleEntry construction in BeanMappingMethod). Every prompt requirement — both directions, iteration order, arrays, method selection/conversions/qualifiers, abstract Map.Entry targets, and lower-bounded map results — maps to a passing hidden test with a fair (prompt-stated or preservation) source, and the full 3641-test baseline is preserved. I ran three falsification attempts: (1) Map<->Set as a fair non-List reading of 'iterable' — passed via an executed probe; (2) whether the retrieval-check relaxation broke the Map<->stream rejection boundary — preserved because the exclusions gate on isIterableType, not stream; (3) abstract Map.Entry constructor binding — correct because…

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 8 (0 failed)
- **Duration:** 5m 27s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: not_applicable

Deserved pass. The candidate correctly implements every behavior the task fairly requires (both mapping directions, iteration order, method selection, conversions, qualifiers, abstract Map.Entry targets via key/value, lower-bounded map results, null strategies, Stream boundary preservation), verified by 32 hidden + 3641 baseline tests. The only candidate failure found (forging a Map.Entry<->bean mapping without an explicit entry method) is reproduced on the reference solution, so it is an UNDER…

**Details / suggested hardening:**

Legitimate, substantive implementation. The candidate folded iterable->map entry mapping into MapMappingMethod and reused IterableMappingMethod for map->iterable, diverging architecturally from the reference's separate IterableToMapMappingMethod class, but producing equivalent behavior across the entire hidden suite and on probed edge cases. Forging-without-explicit-method is the one observable gap, shared with the reference, so it does not affect deservedness. Stream-family boundaries, null strategies, qualifiers, conversions, inheritance, subtypes, lower-bounded results, and update mappings are all handled correctly.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 10 (1 failed)
- **Duration:** 11m 10s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: reverse iterable-to-map generation fails for a valid source element class named `Entry` because the generated loop and mapped-entry local both use `entry`; the reference shares the gap.

**Details / suggested hardening:**

The solution is substantively strong and passes broad order, qualifier, conversion, abstract-entry, wildcard, and lower-bound probes. However, reverse mapping is not robust to a source element type named `Entry`: generated Java redeclares `entry` inside `for (Entry entry : source)`, so a valid mapper cannot compile. The verifier missed this fair naming boundary, and the reference solution has the same gap.

- **Discriminator found:** Yes — `EntryNameCollisionProbeTest.mapsIterableWhoseElementTypeIsNamedEntry`
- **Falsification attempts:** 5
- **Requirements checked:** 5 (1 failed)
- **Duration:** 11m 14s

---

## Nova #3 — ✅ Genuine pass · high confidence

- **Run:** `rd782f9g6ffm3dkzykxr19rjrx8ayx9w` | **Agent:** Nova | **Judge dissent:** No | **Panel duration:** 13m 09s

### Adjudicator — ✅ Genuine pass · high confidence

Legitimate true positive. The candidate takes a different but valid architecture from the reference (single IterableMappingMethod + FTL branch for both directions, using AbstractMap.SimpleEntry for forged abstract entries) rather than the reference's dedicated IterableToMapMappingMethod and SimpleImmutableEntry. All five prompt requirements are implemented and exercised by the 32-test hidden suite plus 3641 baseline tests, and I reproduced the 32/32 pass locally. Divergences from the reference (concrete entry impl class, wildcard/raw-map handling detail) are underspecified by the prompt and reached by no fair input, so they are not grounds for failing. No documentation was added (reference updated the asciidoc), but the prompt does not require docs.

**Probe re-run reasoning:**

I re-ran the hidden verifier against the candidate (verifier worktree + agent_solution.patch + test.patch, `bash test.sh new`) and observed 'Tests run: 32, Failures: 0, Errors: 0' with BUILD SUCCESS, independently reproducing test_execution.log. Those 32 tests exercise all five prompt requirements: both mapping directions with iteration order, arrays, conversions on entry keys, iterable-mapping qualifiers, abstract Map.Entry key/value targets, concrete/subtype containers, lower-bounded map results, RETURN_DEFAULT/null handling, entry-var collision with @Context, and stream-boundary error preservation. The panel is unanimous TP; each judge's falsification probes (Map<->Set, lower-bounded typing, update-path clearing, stream rejection, null/empty/duplicate) passed on the candidate, and none produced a fair discriminator.

**Independent read (before panel evidence):** ✅ Genuine pass

The candidate is a substantive, coherent implementation that reuses IterableMappingMethod plus a new FTL branch to handle both Map->iterable/array and iterable/array->Map directions (entrySet() iteration, Map.Entry element type, put(entry.getKey(), entry.getValue())), with AbstractMap.SimpleEntry construction for abstract entry targets, lower-bounded map results via the selected method's return type, and preserved stream/non-iterable boundary errors. Every one of the prompt's five stated requir…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict TP/high, matching mine. Its Map<->Set probe is a fair, prompt-in-scope case (non-List iterable) and it reported the candidate passing it. No FP claimed, so nothing to overturn; consistent with my re-run.
- **judge-b** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict TP/high. Most thorough falsification set (5 attempts across typing, update path, stream boundary, null/empty/duplicate, forged constructor); all fair and all failed to discriminate. Correctly labels reference-only choices (SimpleImmutableEntry vs SimpleEntry, getTypeBound/raw-map guard) as …
- **judge-c** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict TP/high. Probes on literal Iterable boundaries, one-shot traversal, and Map.Entry identity all passed on the candidate; the only failure it observed was in the reference implementation, not the candidate. No FP claimed.

**Tags:** `PANEL_AGREED_WITH_ME`, `RERAN_PROBE`, `OVERFLAGGED_NONE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Comprehensive 32-test verifier plus 3641 baseline all pass; candidate is a legitimate alternate implementation covering every prompt requirement, and a fair Set-iterable probe also passes. No fair discriminator found.

**Details / suggested hardening:**

The candidate solves the map-entry mapping task with a different-but-valid design (reusing IterableMappingMethod for both directions instead of the reference's dedicated IterableToMapMappingMethod). Every fairly-required behavior in the prompt is backed by a concrete code path and a passing hidden test: both mapping directions, iteration order, arrays, conversions on entry keys, iterable qualifiers, abstract Map.Entry key/value construction, lower-bounded map results, inheritance, @Context, RETURN_DEFAULT, @MappingTarget updates, and preservation of the stream/non-iterable boundary errors. Structural risks in the candidate's approach (folding map<->iterable into isIterableMapping, changing the array getWrapper type, entry-variable naming) were each investigated and shown benign via the assignability guards, LocalVarWrapper's import-only use of its type, and existingVariables including all parameter names. A hand-authored fair probe covering an uncovered but prompt-implied case (Set it…

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 7 (0 failed)
- **Duration:** 10m 48s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. The solver implemented Map<->iterable/array entry mapping end-to-end by extending the existing IterableMappingMethod pipeline; all 32 hidden tests, the candidate's own tests, and 5 authored edge-case probes (null key/value, empty containers, duplicate-key overwrite) pass. Architecture differs from the reference (single class vs split) but is functionally equivalent on every fair behavior; the only divergences (wildcard/raw-map getTypeBound handling, SimpleImmutableEntry forging) …

**Details / suggested hardening:**

Strong, complete implementation. The choice to fold both directions into IterableMappingMethod rather than introducing a separate IterableToMapMappingMethod (as the reference does) is a legitimate design alternative and behaves equivalently on all tested and probed cases. Minor hardening suggestions (not required by the task): have TypeFactory.getMapEntryType apply getTypeBound() and guard the size!=2 case, and key the BeanMappingMethod constructor accessor on isMapEntryType() rather than the literal SimpleEntry FQN, so forged returns of other concrete entry implementations would also work. These are forward-compatibility niceties, not correctness gaps for the prompt as stated.

- **Discriminator found:** No
- **Falsification attempts:** 5
- **Requirements checked:** 8 (0 failed)
- **Duration:** 10m 07s

### judge-c — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass: all stated requirements hold, baseline regressions are clean, and additional literal-Iterable/direct-entry probes pass.

**Details / suggested hardening:**

This is a real solve rather than a loose-verifier false positive. The candidate covers both mapping directions, order, arrays, qualifiers/conversions, abstract Map.Entry construction, lower bounds, updates/null strategies, and preserves unrelated mapping families. Additional fair probes found no candidate defect and exposed only a reference-side local-variable collision.

- **Discriminator found:** No
- **Falsification attempts:** 5
- **Requirements checked:** 8 (0 failed)
- **Duration:** 8m 41s
