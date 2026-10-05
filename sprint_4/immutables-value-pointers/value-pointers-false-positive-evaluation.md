# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 2 — false positives: 0, genuine passes: 2
- **Requested:** 2026-07-19 01:28
- **Completed:** 2026-07-19 01:55
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Orion #3 — ✅ Genuine pass · high confidence

- **Run:** `rd73azfet9kfmven1x4zvknj858ardxw` | **Agent:** Orion | **Judge dissent:** Yes | **Panel duration:** 26m 50s

### Adjudicator — ✅ Genuine pass · high confidence

The pass is deserved: a generic, prompt-faithful processor implementation that passes 46 thorough hidden cases plus 326 baseline tests. The one genuine behavioral divergence the panel surfaced is whole-array update where the operator returns an Object[] with deep-equal contents but a wrong reified component type: the candidate (Objects.deepEquals) treats this as an equal-result no-op and returns the original root, while the reference (Objects.equals => array identity) throws PointerTypeException. The prompt does not disambiguate which rule wins in this contrived collision, so it is not a fair basis for failing the solution. If maintainers want deterministic behavior here, they should specify precedence (e.g., validate replacement type before the equality short-circuit) and add an explicit test; today's suite does not require it.

**Probe re-run reasoning:**

I re-ran judge-c's discriminating probe on the candidate (verifier worktree): only equalButWrongArrayReplacementIsRejected fails (nothing thrown); the nullable-optional traversal test passes. I confirmed the mechanism from source: the reference's update() uses Objects.equals(result,target) (line 164), which is identity for arrays, so an Object[]{text} is not equal to the existing Node[]{text} and it proceeds to type validation and throws; the candidate's equalValues() uses Objects.deepEquals, so the Object[]{text} is deep-equal to the existing array and the explicit 'a result equal to the existing value returns the original root instance' rule short-circuits with no throw. This is a contrived collision between two prompt clauses (equal-result-no-op vs wrong-typed-container-rejection) whose precedence the prompt never states; the candidate honors deep value-equality (matching immutables' own array equals semantics) and still leaves the root untouched. The reference throws only as an incidental byproduct of its array equality choice, not a deliberate spec decision, and the thorough 46-case hidden suite deliberately never tests this collision (its wrong-typed cases use genuinely wrong-VALUED replacements, all handled correctly). The probe therefore over-flags an unspecified edge. Judge-a and judge-b independently reached true_positive, matching my pre-panel view.

**Independent read (before panel evidence):** ✅ Genuine pass

Before reading the panel, I judged the candidate against the prompt: it is a substantive annotation-processor implementation (a generatePointers template plus ValueType/ValueAttribute eligibility and type-classification helpers) that generically emits the XxxPointers companion with parse/render/resolve/update. The 46-case hidden suite runs in a different package (Circuit) and exercises essentially every prompt clause: eligibility gating (Standalone/NoCopy/MixedCopy/Loose/Stamp absent vs Sealed/…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted) — Verdict true_positive (high). Probed eligibility corners, index boundaries, and foreign mid-path descent; all resolved in the candidate's favor, so it shipped no false_positive discriminator. Matches my independent view.
- **judge-b** (trust: trusted, fair probe: No, discriminates: Yes) — Verdict true_positive (medium). Found a real divergence in the OPPOSITE direction (candidate strictly rejects a subtype-element array a lenient reading would accept) that discriminates, but correctly judged it an underspecified/unfair edge and did not flag FP. Consistent with my conclusion that the…
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Solo verdict false_positive (high). Its probe (equalButWrongArrayReplacementIsRejected) does discriminate and I reproduced it, but it is over-flagging: it forces resolution of an unspecified collision between the prompt's equal-result-no-op rule and its wrong-typed-container-rejection rule at a con…

**Tags:** `PANEL_AGREED_WITH_ME`, `SOLO_FP_OVERRULED`, `OVERFLAGGED`, `RERAN_PROBE`, `UNDERSPECIFIED_EDGE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Exhaustive hidden suite (46 cases) plus a full requirement walk and four untested-edge probes all confirm the candidate's generic processor implementation satisfies every fairly-required behavior; deserved pass.

**Details / suggested hardening:**

True positive. The candidate implements the pointer-companion feature generically inside the immutables annotation processor (new generatePointers template plus eligibility/type-classification helpers), and it satisfies every clause of a highly detailed but fully self-specified prompt. The hidden verifier is unusually exhaustive, covering eligibility corners, pointer syntax/escaping, runtime-implementation dispatch, the Miss/Type/Malformed exception taxonomy, optional flavors, structural-sharing update, and derived/lazy/opaque immutability. I falsified the least-tested areas — eligibility with only-derived and family+standalone-copy=false enclosings (already covered by hidden Stamp/Loose cases), index boundaries (empty step, leading-zero array index, array past-end), and mid-path descent below a foreign value — with four fair probes; all pass on the candidate. No fair source requires a behavior the candidate gets wrong, and no discriminating probe could be built.

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 6 (0 failed)
- **Duration:** 10m 56s

### judge-b — ✅ Genuine pass · medium confidence · probe fairness: questionable

Deserved pass: the candidate's annotation processor satisfies every fairly-required behavior and passes all 46 hidden + 333 baseline tests. The one candidate-only divergence found (rejecting an assignable subtype array Wire[] for an Element[] attribute) is an UNDERSPECIFIED_EDGE — the prompt does not fairly require subtype-array acceptance, and a strict type check is defensible — so it does not invalidate the pass.

**Details / suggested hardening:**

Legitimate, comprehensive implementation. A minor type-checking inconsistency: typeMatches walks the hierarchy for scalar attributes (accepting subtypes, as required for rebuild) but compares array classes by canonical name, so assignable subtype arrays are rejected. Aligning the array check with Java assignability (e.g. instanceof the erased component type, as scalars effectively do) would make update more permissive and match standard Java semantics, but the current strict behavior is not a spec violation on the tested inputs.

- **Discriminator found:** No
- **Falsification attempts:** 1
- **Requirements checked:** 10 (0 failed)
- **Duration:** 18m 30s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: deeply equal wrong-runtime-type arrays bypass replacement validation.

**Details / suggested hardening:**

Validate replacement type before applying equality/no-op logic. Objects.deepEquals makes Node[]{x} equal to Object[]{x}, so the current ordering violates the explicit wrong-typed-container requirement.

- **Discriminator found:** Yes — `PointerFalsePositiveProbeTest.equalButWrongArrayReplacementIsRejected`
- **Falsification attempts:** 5
- **Requirements checked:** 6 (1 failed)
- **Duration:** 19m 52s

---

## Orion #4 — ✅ Genuine pass · high confidence

- **Run:** `rd72s36mx342fyf85ffrn0v8398astmx` | **Agent:** Orion | **Judge dissent:** Yes | **Panel duration:** 24m 53s

### Adjudicator — ✅ Genuine pass · high confidence

This is a deserved pass. The candidate is a complete, independently-developed implementation of generated pointer companions covering eligibility, parse/render, runtime-type resolution, the full failure taxonomy, and spine-only structural-sharing updates with strict type validation. The only dissenting judge (judge-c) flagged a @Nullable Optional corner, but I reproduced it against the reference solution and it fails identically — the reference author did not treat @Nullable Optional as an optional-kind either, so it is not a fair prompt-required discriminator. If maintainers want to nail this corner down, add a hidden fixture/test that pins the intended @Nullable Optional semantics (and fix the reference too); today's spec and reference both leave it as a nullable scalar.

**Probe re-run reasoning:**

I built the candidate (verifier) and reference worktrees offline and re-ran the only probe that any judge claimed discriminates: judge-c's @Nullable Optional<Node> probe. The candidate fails 2/3 (resolve/update of `/maybe` expose Optional[Leaf] instead of Leaf) — but the ground-truth reference solution fails the SAME 2 cases identically (same assertion, same lines). Because the reference (a correct solution) also fails, the probe does not discriminate and cannot support false_positive per the rubric. `@Nullable Optional<T>` is an established immutables special case where @Nullable suppresses auto-Optional encoding (the field literally holds an Optional and may be null), so treating it as a nullable scalar is what a correct implementation does. Judge-c's solo FP is over-flagging a stricter reading than even the reference meets. Judges a and b independently ran 16 and 9 fair probes respectively; none discriminated against the candidate (one of judge-b's probes discriminated AGAINST the reference, in the candidate's favor).

**Independent read (before panel evidence):** ✅ Genuine pass

The hidden verifier is unusually comprehensive: 46 tests spanning generation eligibility (single-impl, all-no-copy, mixed-copy, non-family no-copy, derived-only, generic exclusion, cross-package), parse/render with escaping, runtime-type-driven resolve across lists/arrays/string-maps/optionals (including specialized and Guava flavors)/whole-value containers, the full miss/type/IllegalArgument failure taxonomy, and spine-only structural-sharing update with strict type validation and derived/lazy…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — 16 prompt-grounded probes on untested corners (deep optional descent for java.util and Guava, whole-container type validation, equal-result short-circuit at depth, map-entry sharing, derived-intermediate, index boundary). Judge itself reports all pass; consistent with my independent reading and the…
- **judge-b** (trust: trusted, fair probe: Yes, discriminates: No) — 9 fair probes; none discriminate against the candidate. Notably updateRejectsWrongElementTypingForArray discriminates AGAINST the reference (candidate raises PointerTypeException, reference throws ArrayStoreException) — candidate is at least as correct as the reference. Verdict true_positive matche…
- **judge-c** (trust: distrusted, fair probe: No, discriminates: No) — Solo false_positive. I re-ran its @Nullable Optional<Node> probe on candidate AND reference: both fail the same 2/3 cases identically. Because the reference (correct solution) also fails, the probe does not discriminate — this is over-flagging. @Nullable Optional is an established immutables case w…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `NON_DISCRIMINATING_PROBE`, `SPEC_GAP_REFERENCE_ALSO_FAILS`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Genuine, complete pointer-companion implementation; 46 hidden tests plus 16 additional fair probes all pass. No fairly-required behavior is mishandled — deserved pass.

**Details / suggested hardening:**

This is a true positive. The candidate is a substantive, independently-structured implementation covering generation eligibility, JSON-Pointer-style parse/render with escaping, runtime-type-driven resolution, the full miss/type/IllegalArgument failure taxonomy, and spine-only structural-sharing update with strict type validation and derived/lazy/whole-value constraints. The hidden suite is exhaustive, and 16 additional probes I authored from prompt-stated requirements alone (deep optional descent for java.util and Guava, whole-container type validation, equal-result short-circuit at depth, map-entry sharing, derived-intermediate vs update, index-boundary classification) all pass. No fair discriminator was found; the pass is deserved.

- **Discriminator found:** No
- **Falsification attempts:** 8
- **Requirements checked:** 5 (0 failed)
- **Duration:** 19m 21s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. The candidate's generated-pointer implementation is substantive and correct on every fair, required behavior; all 46 hidden tests and 9 authored fair probes pass. The only discriminating probe fails on the reference (not the candidate), confirming the candidate is at least as correct as the reference. No false positive.

**Details / suggested hardening:**

The candidate produced a complete, legitimate implementation of the Pointers feature: processor wiring, eligibility logic, attribute metadata, and a generated-runtime template implementing parse/render/resolve/update with structural sharing and precise failure classification. It passes the full hidden verifier (46/46) and an additional 9 fair edge-case probes I authored. Notably, the candidate handles wrong-typed container-element replacements more correctly than the provided reference solution (which throws a raw ArrayStoreException). I found no fair behavior the candidate mishandles; the pass is a true positive.

- **Discriminator found:** No
- **Falsification attempts:** 6
- **Requirements checked:** 14 (0 failed)
- **Duration:** 16m 14s

### judge-c — ❌ False positive · medium confidence · probe fairness: fair

False positive: present @Nullable Optional attributes are treated as scalar wrappers, violating required optional-content resolve and update semantics; the reference shares the gap.

**Details / suggested hardening:**

The implementation is broad and passes the intended suite, but it inherits the processor's nullable-Optional suppression into pointer shape classification. As a result, /maybe resolves to Optional<T> and update(/maybe) receives Optional<T>, despite the prompt requiring every optional attribute step to address T. Hidden coverage should add the packaged nullable-Optional probe.

- **Discriminator found:** Yes — `NullableOptionalPointersProbeTest.nullableOptionalStillAddressesItsPresentContent`, `NullableOptionalPointersProbeTest.nullableOptionalUpdateAppliesToItsContent`
- **Falsification attempts:** 3
- **Requirements checked:** 9 (2 failed)
- **Duration:** 15m 16s
