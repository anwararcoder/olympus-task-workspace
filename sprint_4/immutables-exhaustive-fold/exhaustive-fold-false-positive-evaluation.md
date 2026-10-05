# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED`
- **Runs evaluated:** 2 — false positives: 0, genuine passes: 2
- **Requested:** 2026-07-11 09:54
- **Completed:** 2026-07-11 12:27
- **Token cost:** 8
- **Criterion status:** pass — No false positives detected

---

## Nova #6 — ✅ Genuine pass · high confidence

- **Run:** `rd76mmjvw0854cht1qe30hsgt18aaatm` | **Agent:** Nova | **Judge dissent:** No | **Panel duration:** 59m 12s

### Adjudicator — ✅ Genuine pass · high confidence

Legitimate pass. The candidate is a real value-processor feature (generator template + FoldStructure model + processor hook), not an overfit or stub, and it satisfies the reflection-based hidden suite generically across every specified attribute shape and dispatch/memoization rule. Reproduced 47/47 locally. The only residual grey areas (reference cycles, extra optional flavors, semantics of a null folded result) are genuinely unspecified by the prompt and not fair grounds for failure.

**Probe re-run reasoning:**

I materialized clean+candidate+test in /tmp/fp-adjudicate/verifier and ran test.sh new: 'Tests run: 47, Failures: 0, Errors: 0, Skipped: 0, BUILD SUCCESS', matching test_execution.log. The verifier is generic reflection over generated Fold interfaces across many fixture shapes (SignalNet, MeterSpec, PanelSpec, SameName, IdleSpec, FreeNode), so a pass means the generator behaves correctly, not that expectations were memorized. Both panel members (judge-a, judge-c) independently attempted falsification, found no fair discriminator, and their own probes passed on the candidate; no judge shipped a probe supporting false_positive.

**Independent read (before panel evidence):** ✅ Genuine pass

The candidate ships a genuine processor feature: a Trimou generator template (Folds.generator), a 380-line FoldStructure discovery/shape-classification model, a Folds.java template binding, and a Processor.java hook. The hidden verifier is a broad, reflection-based suite (47 tests over a rich fixture set added by the test patch itself) that a real generator must satisfy generically — no hardcoding is possible since the tests forName/reflect on generated classes. Reading the patch, every prompt …

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive/high. Enumerated prompt requirements, marked all handled, ran three falsification attempts plus two authored corner probes — all passed on candidate. No FP claim to re-run. Agrees with my finding.
- **judge-b** (trust: —) — No fp-critique-result.json produced (incomplete run; not among the listed panel labels). Only probe stubs present (ProbeMultisetShared, ProbeMapKey) targeting prompt-covered behaviors the candidate handles; no verdict to reconcile.
- **judge-c** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive/high. Authored probes ran on both candidate and reference (2/2 pass each) — non-discriminating by construction. Flagged cycle-handling as underspecified, not a fair required behavior. Agrees with my finding.

**Tags:** `PANEL_AGREED_WITH_ME`, `RERAN_PROBE`, `OUTCOME_VERIFIER_PASSED`, `TRUE_POSITIVE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Exhaustive, faithful hidden suite (47 tests) over a genuine fold-generator implementation; all requirements hold, reproduced pass, and two probes into untested-but-required corners also pass. True positive.

**Details / suggested hardening:**

The verifier's pass is deserved. The hidden test suite is an almost clause-by-clause check of a very detailed prompt (families/cases discovery, all container/optional/nullable/map/multimap/array shapes, identity-based per-application memoization, most-specific dispatch, cross-family single-case, IllegalArgumentException for foreign values), and it passes 47/47 (reproduced independently). The candidate's Folds.generator + FoldStructure model implement the feature genuinely and generically rather than overfitting; dispatch is exact because it tests against distinct final Immutable classes, memoization is a single per-application IdentityHashMap shared across shape helpers, and nullability wraps every shape uniformly. I probed two fair, prompt-required corners the hidden suite does not directly assert — memoization reuse spanning an Optional and a List within one application, and a present-but-empty @Nullable list folding to an empty list — and both pass. No fair discriminating probe was…

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 6 (0 failed)
- **Duration:** 12m 29s

### judge-b — unknown

- **Discriminator found:** No
- **Duration:** 25m 01s

### judge-c — ✅ Genuine pass · high confidence · probe fairness: fair

True positive: verifier pass appears deserved; no fair false-positive discriminator was found.

**Details / suggested hardening:**

The candidate solved the generated fold feature. Hidden tests passed, and fair probes for shared families, generic-root exclusion/generic-implementation cases, identity memoization, and unsupported hand-rolled instances also passed. Cyclic graph behavior remains only an underspecified suspicion.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 6 (0 failed)
- **Duration:** 17m 57s

---

## Nova #7 — ✅ Genuine pass · high confidence

- **Run:** `rd7102q1xc7tmfztena3vtttpn8abqny` | **Agent:** Nova | **Judge dissent:** No | **Panel duration:** 66m 24s

### Adjudicator — ✅ Genuine pass · high confidence

Legitimate pass. The candidate ships a complete, structurally sound fold generator (FoldStructure + Folds.generator wired via Generator_Folds) that satisfies every prompt clause and passes the highly comprehensive 47-test hidden suite (reproduced 47/47). The only divergence from the reference is the choice of getSettableAttributes() vs impl.attributes for @Value.Derived/@Value.Lazy family attributes, which is an underspecified corner where the candidate happens to match the reference (both exclude them). No maintainer action needed; if desired, the prompt could clarify whether computed (derived/lazy) family attributes should participate in folding.

**Probe re-run reasoning:**

I materialized the verifier state (clean + candidate + hidden tests) and reran the hidden suite: 'Tests run: 47, Failures: 0, Errors: 0, Skipped: 0', BUILD SUCCESS. The hidden tests exhaustively cover every enumerated prompt behavior (leaf/direct/chained folds, list/set/sorted-set/multiset/array->list, jdk/guava/fugue optional, map/multimap preserving order, nullable single and container, identity memoization vs equal-but-separate, most-specific dispatch across 3-level chains, second-family and cross-family entries, one case for a two-family impl, caller-chosen result type, declaration-order signatures, non-family and unsupported-shape attributes contributing no parameter, generic impl gets a case while generic family gets no fold, public interface with one type parameter, and IllegalArgumentException for unknown impls). The only genuine divergence from the reference (candidate uses getSettableAttributes() while the reference uses impl.attributes, affecting @Value.Derived/@Value.Lazy family attributes) I probed directly by applying judge-a's DerivedSpecProbeTest and building the candidate processor: caseBranch param count = 2, identical to the reference-confirmed behavior. That edge is underspecified by the prompt and the candidate matches the reference on it, so it is not a fair discriminator. No fair, prompt-grounded failure exists.

**Independent read (before panel evidence):** ✅ Genuine pass

The prompt asks for a generated <Name>Fold companion for enclosed value families with bottom-up dispatch, identity memoization, most-specific dispatch, and shape-specific child folding across every container/optional/nullable form. The candidate's FoldStructure + Folds.generator implement each of these clauses and its logic maps cleanly to the reference's semantics. The hidden suite of 47 tests is unusually exhaustive and pins nearly every prompt clause, and I reproduced 47/47 passing on the ca…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, high confidence, matching mine. Its DerivedSpecProbeTest probes the one real divergence (derived/lazy family attributes). I reran it against the candidate processor: caseBranch param count = 2, identical to the reference, so it does not discriminate. Fair but non-discriminati…
- **judge-c** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, high confidence, matching mine. Same underspecified derived-attribute edge identified as shared with the reference; packaged fair probes for unsupported shapes/nested containers/generic dispatch, none discriminating. Consistent with judge-a and my own reproduction; did not re…

**Tags:** `PANEL_AGREED_WITH_ME`, `RERAN_PROBE`, `OVERFLAGGED_NONE`, `UNDERSPECIFIED_EDGE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Complete, reference-equivalent fold generator passing 47 comprehensive hidden tests; the one real divergence probed (derived/lazy attributes) behaves identically to the reference. Deserved pass.

**Details / suggested hardening:**

This is a legitimate solve of a substantial, fair code-generation task. The candidate's FoldStructure + Folds.generator implement family discovery, case generation, bottom-up folding with identity memoization, most-specific dispatch, and shape-specific child folding (direct/optional/list/set/multiset/array/map/multimap, nullable, across jdk/guava/fugue optionals), matching the reference structurally and passing all 47 comprehensive hidden tests (reproduced at 47/47). Falsification focused on the only genuine implementation divergence from the reference — inclusion of @Value.Derived/@Value.Lazy family-typed attributes — but a built-and-run probe showed candidate and reference behave identically (both exclude them), and the corner is underspecified anyway. No fair requirement is mishandled.

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 9 (0 failed)
- **Duration:** 14m 45s

### judge-b — unknown

- **Discriminator found:** No
- **Duration:** 25m 02s

### judge-c — ✅ Genuine pass · high confidence · probe fairness: fair

True positive: the pass appears deserved; no fair discriminator was found.

**Details / suggested hardening:**

The verifier pass looks deserved. The candidate added real fold generation and handled the prompt-stated hard cases I probed. A derived-attribute probe failed, but that edge is underspecified and shared by the reference, so it is not a fair false-positive basis.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 7 (0 failed)
- **Duration:** 17m 09s
