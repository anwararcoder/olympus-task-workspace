# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 4 — false positives: 0, genuine passes: 4
- **Requested:** 2026-07-28 16:00
- **Completed:** 2026-07-28 16:57
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Nova #2 — ✅ Genuine pass · high confidence

- **Run:** `rd7499g2g947kty8r4jwe67jc18bc468` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 27m 29s

### Adjudicator — ✅ Genuine pass · high confidence

The pass is legitimate against the prompt. Worth noting for maintainers: the agent's ClassResolver.getBytes lets an IOException from a single lazy origin escape select(), so StructContext.getClass turns a genuine I/O failure on one library into a null for the whole class, dropping candidates from later libraries. The reference (and the pre-existing code) instead catch IOException per origin and continue. This is a real robustness regression on the error path but is outside the feature spec and untested; a one-line try/catch returning null in getBytes would restore the baseline behavior if desired.

**Probe re-run reasoning:**

I re-ran judge-c's probe across candidate/reference/clean worktrees: candidate FAILS, reference and clean PASS, so the behavioral divergence is real — the candidate propagates an IOException from one lazy origin out of ClassResolver.select() and StructContext.getClass converts it into a whole-class null, whereas the reference catches IOException per-origin in readClassBytes and continues to the next candidate. However, this behavior is not grounded in the prompt: the task specifies only duplicate-resolution semantics and never mentions IOException resilience across lazy sources, and no hidden test makes a source throw. Judge-c's fairness rationale rests on the IContextSource contract and the baseline's incidental behavior, not the prompt — an unstated, untested edge case. Under the rule that a solo false_positive is upheld only when its probe is both discriminating AND prompt-fair, this probe discriminates but is unfair, so it is over-flagging. Judges a and b independently reached true_positive with high confidence, matching my pre-panel view.

**Independent read (before panel evidence):** ✅ Genuine pass

The prompt is unusually explicit and the hidden verifier (48 resolution tests + LazyLibraryTest baseline) mirrors essentially every clause: option/default/validation, distinct origins, own>library precedence, first/last ordering over root+child order, error byte-equality with identical-bytes coalescing, member/local/anonymous/nested/sibling family coherence, literal-dollar non-family, metadata-doesn't-combine, unavailable-root anchoring, family conflict reporting of all origins, eager+lazy cand…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted) — Concluded true_positive (high). Its authored probes (family anchoring depth-2 under LAST; unrelated inner-class reference) pass on the candidate and were not offered as FP discriminators, so nothing to overturn. Assessment matches mine.
- **judge-b** (trust: trusted) — Concluded true_positive (high). Found one divergence (library-duplicate warning's metadata-family-root field = '<none>' vs class name) but correctly treated it as underspecified/unfair since the prompt does not define a family root for a non-own duplicate with no activated coherence and no hidden t…
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Solo false_positive. Probe reran: candidate fails, reference and clean pass — the IOException-to-null divergence is real. But it tests lazy-source IOException resilience, which the prompt never requires and no hidden test covers; the requirement is derived from the IContextSource contract and basel…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Substantive, correct duplicate-class resolver passing an exhaustive 48-test hidden suite plus the integration baseline; falsification found no fairly-required behavior the candidate mishandles.

**Details / suggested hardening:**

Strong true positive. The candidate independently reimplements deterministic duplicate-class resolution matching the prompt's precedence, byte-equality ERROR semantics, transitive InnerClasses/EnclosingMethod family coherence, lazy probe caching, add-source/reload invalidation, synchronized concurrency, semantic warnings/conflicts, and selected-origin output routing; the hidden suite is unusually thorough and all pass. I probed the two real divergences from the reference — the candidate reads all InnerClasses entries rather than only the class's own enclosing, and it drops the badlyPlacedClasses correction path — and neither violates a fairly-required behavior: InnerClasses entries encode true nesting so over-broad reading cannot fabricate a family, and the badly-placed edge is peripheral to this task with the integration baseline still passing.

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 10 (0 failed)
- **Duration:** 20m 51s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: questionable

Deserved pass. The candidate's duplicate-class resolver satisfies every fairly-required behavior (verified by re-running the 49/49 hidden suite and tracing each requirement). The only candidate/reference divergence — the warning's metadata-family-root field is '<none>' for a library duplicate vs the class name for the reference — is an underspecified edge the prompt does not unambiguously require either way, so it is not a false positive.

**Details / suggested hardening:**

Solid, origin-aware implementation that passes the full hidden suite. Minor note (not a correctness failure): for non-own (library) duplicates the warning reports 'metadata family root: <none>' because family roots are only computed when own-source coherence is activated; the reference reports the class name. The prompt is silent on this case, so this is an underspecified edge, but if strict consistency with own-duplicate warnings is desired later, computing the metadata family root for library duplicates too would align the two.

- **Discriminator found:** No
- **Falsification attempts:** 1
- **Requirements checked:** 14 (0 failed)
- **Duration:** 12m 54s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: candidate passes official tests but regresses lazy-library fallback after an IOException.

**Details / suggested hardening:**

Most explicit duplicate-resolution requirements are implemented correctly, but lazy probing no longer preserves the repository's per-origin failure isolation. If one lazy library throws IOException, ClassResolver aborts the whole selection and StructContext caches a miss instead of trying later lazy libraries. The added probe demonstrates candidate failure with clean/reference success.

- **Discriminator found:** Yes — `LazyFailureFallbackProbeTest.lazyReadFailureDoesNotHideLaterValidLibrary`
- **Falsification attempts:** 5
- **Requirements checked:** 11 (1 failed)
- **Duration:** 16m 36s

---

## Nova #3 — ✅ Genuine pass · high confidence

- **Run:** `rd7428js5vb1w81mjrbr0ye8xx8bd9kx` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 28m 13s

### Adjudicator — ✅ Genuine pass · high confidence

The candidate is a genuine, structurally-independent implementation that passes the full 48-test hidden verifier plus the baseline. The only credible FP claim (judge-c) rests on an underspecified multi-duplicate rootless-family scenario and exploits a lookup-order artifact: the reference produces the same error when the member is requested in the other order or through getOwnClasses (the real pipeline). The candidate's deterministic anchoring is actually more consistent with the prompt's 'lookups must not change the winner' requirement. If maintainers want this edge pinned down, the prompt should specify which duplicated member anchors a rootless family when several are duplicated with differing origin sets.

**Probe re-run reasoning:**

I re-ran judge-c's exact probe: candidate FAILS (IllegalStateException) and reference PASSES, so it does discriminate. But the probe is UNFAIR. It calls getClass("probe/Multi$B") directly BEFORE Multi$A on a rootless family where Multi$A lives in origin-one+origin-two and Multi$B in origin-two+origin-three. I built a variant that instead requests Multi$A first, and one that uses getOwnClasses() (the real decompile pipeline path); the REFERENCE throws the identical error 'Duplicate class family probe/Multi is anchored to origin origin-one, which cannot supply member probe/Multi$B' in both (reference-variant-result.xml: tests=2 failures=2). So the reference's 'pass' is purely an artifact of resolving Multi$B before Multi$A via direct lookup. The candidate anchors deterministically regardless of lookup order, which is what the prompt's 'Concurrent lookups or output processing must not change the winner' demands, and its error is a literal application of 'If an encountered member is available only from another own origin, fail.' The multi-duplicate rootless-family case with disjoint origin sets is underspecified by the prompt ('the strategy-selected duplicate' is singular), and the candidate's reading is defensible and order-stable. Judge-c holds the candidate to a stricter, order-dependent contract that the reference itself does not meet in the actual pipeline. Solo FP not upheld.

**Independent read (before panel evidence):** ✅ Genuine pass

The candidate implements every clause of the prompt: the duplicate-class-strategy option with early validation and named accepted values, own>library precedence, byte-aware first/last/error, transitive InnerClasses/EnclosingMethod family coherence with anchoring, per-context probe/selection caching with add-source and reload invalidation, synchronized deterministic lookups, one-warning-per-decision logging, and selected-origin output filtering via ContextUnit.save. The hidden verifier is an unu…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, matches mine. Its boundary probe found no discriminator; consistent with the verifier being comprehensive.
- **judge-b** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, matches mine. Correctly noted the only divergence (a library inner-class family-root warning field) is an underspecified edge shared with the reference and never exercised by the hidden tests.
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Probe discriminates on candidate vs reference but is UNFAIR. It requests Multi$B before Multi$A via direct getClass; my variants (A-first, and getOwnClasses pipeline path) make the REFERENCE throw the identical 'anchored to origin-one, cannot supply member probe/Multi$B' error. The asserted no-erro…

**Tags:** `OVERFLAGGED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `SOLO_FP_OVERRULED`, `UNDERSPECIFIED_EDGE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Comprehensive 48-test verifier maps ~1:1 to the prompt and passes in full on a substantive, correct candidate; a fair boundary probe also passed. Deserved pass.

**Details / suggested hardening:**

Deserved pass. The prompt is exceptionally detailed and the hidden verifier is a near-exhaustive, deterministic enumeration of its clauses (precedence, byte-identity error handling, transitive InnerClasses/EnclosingMethod family coherence including anonymous/local/nested, $-in-top-level-name exclusion, deferred resolution, per-context positive/negative caching, add-source and reload invalidation, concurrency, per-decision warnings, and selected-origin output ownership). A requirement-by-requirement walk found a real candidate code path satisfying each clause, all 48 tests pass (reproduced by re-running gradle offline on the candidate state), and an additional fair boundary probe (a late lazy library must not disturb an already-resolved own winner) also passed. No fair source requires a behavior the candidate mishandles, so no discriminating probe exists.

- **Discriminator found:** No
- **Falsification attempts:** 2
- **Requirements checked:** 10 (0 failed)
- **Duration:** 7m 54s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. A substantive duplicate-class-resolution implementation clears all 48 hidden tests and 4 authored fair probes; the only divergence found (library inner-class family-root in a warning) is underspecified and shared with the reference, so it does not void the pass.

**Details / suggested hardening:**

Strong, origin-aware solve covering option validation, deferred byte-aware first/last/error selection, own/library precedence with root+child ordering, metadata family coherence and anchoring, per-context probe/selection caching with add/reload invalidation, synchronized concurrency, semantic once-per-decision warnings, and selected-origin-only output ownership. One underspecified edge worth a maintainer note: the warning's family-root field is computed only from own-class metadata, so for a library inner-class duplicate it reports the inner class rather than its enclosing top-level (the reference has the same gap); consider deriving the metadata family root for library duplicates too if that field is meant to be universally accurate.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 12 (0 failed)
- **Duration:** 20m 51s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: with an unavailable family root and multiple duplicated members, the candidate anchors from the first duplicate indexed for the family instead of the strategy-selected duplicate being requested, causing an avoidable family conflict.

**Details / suggested hardening:**

The broad implementation is substantive and passes the supplied suite, but the pass is not deserved because unavailable-root anchoring is still entry-order dependent when a family has multiple duplicated members. A fair probe requesting B first fails after the code anchors from earlier-indexed A/origin-one; the prompt requires B's strategy selection to anchor, and the reference correctly selects origin-two and loads both members coherently.

- **Discriminator found:** Yes — `org.jetbrains.java.decompiler.UnavailableRootMultipleDuplicatesProbeTest.requestedDuplicateAnchorsUnavailableRootFamily`
- **Falsification attempts:** 3
- **Requirements checked:** 8 (1 failed)
- **Duration:** 15m 13s

---

## Nova #5 — ✅ Genuine pass · high confidence

- **Run:** `rd75d5g7azhsvasvzxte06tztn8bct9v` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 26m 47s

### Adjudicator — ✅ Genuine pass · high confidence

The pass is behaviorally deserved: the candidate independently re-passes all 48 hidden tests plus the baseline with a full, faithful implementation. The only live concern (judge-c) is a genuine but underspecified edge: when the 'error' strategy and a family-member-split conflict coincide, the candidate's generic byte-conflict message fires before the family-specific message and omits the anchored origin's name. The task's own reference solution has the exact same behavior, so it is not a fair basis to fail the solution. If maintainers want the anchor named in that overlapping case, tighten the prompt and add a discriminating test that the reference also satisfies.

**Probe re-run reasoning:**

I independently re-ran the hidden verifier on the candidate: duplicateClassResolutionTest reported tests=48 failures=0 errors=0 and duplicateClassBaselineTest passed (BUILD SUCCESSFUL). The lone dissenter, judge-c, ships a probe (errorFamilyMemberConflictStillIdentifiesTheAnchorAndAlternatives) asserting the error-strategy family-member-conflict message names the anchor origin. I applied and ran that probe on both the candidate (verifier worktree) and the reference (clean + reference_solution + test.patch): BOTH FAIL at the identical assertion (line 1364). The probe therefore does not discriminate a correct solution from the candidate. The scenario is an unspecified interaction between two failure modes (error-strategy byte-conflict vs. member-only-in-another-origin); both candidate and reference throw and identify member/root/alternative origins but resolve the byte-conflict message first, omitting only the anchor-origin name. Holding the candidate stricter than the task's own reference is over-flagging, so judge-c's solo FP is not upheld.

**Independent read (before panel evidence):** ✅ Genuine pass

The candidate is a substantive implementation of deterministic duplicate-class resolution covering every prompt-stated behavior: option parsing (first/last/error, default first, reject-invalid-before-processing naming accepted values), own-outranks-library tiering, registration/child order, exact-byte error semantics, transitive InnerClasses/EnclosingMethod family coherence with root anchoring, deferred resolution, per-context lazy-probe/selection caches with invalidation on addSpace/reloadCont…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted) — Verdict true_positive, agreeing with me. Authored only a preserved-behavior (badly-placed-class) probe that passes on the candidate; no FP claim to verify. Requirement coverage all 'yes' with cited evidence.
- **judge-b** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive. Its three authored probes pass on BOTH candidate and reference (non-discriminating by its own report). Flagged the family-root warning field as UNDERSPECIFIED_EDGE, not a fair failure. Consistent with my finding.
- **judge-c** (trust: distrusted, fair probe: No, discriminates: No) — Solo false_positive. Its probe asserts the error-strategy family-member-conflict message names the anchor origin. I re-ran it: candidate FAILS and reference FAILS at the identical assertion (line 1364). Because the canonical reference behaves identically, the probe over-specifies an underspecified …

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `REFERENCE_ALSO_FAILS_PROBE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Genuine, complete implementation of deterministic duplicate-class resolution; passes all 48 hidden tests, and no fair-but-untested requirement is mishandled. True positive.

**Details / suggested hardening:**

This is a deserved pass. The candidate is a careful, complete implementation of the deterministic duplicate-class-resolution spec: it adds the strategy enum with pre-processing validation, defers resolution until first request, tiers own-over-library with registration/child order, enforces exact-byte error semantics, derives transitive InnerClasses/EnclosingMethod families with correct anchoring and conflict reporting, maintains per-context probe/selection caches invalidated on addSpace/reloadContext, synchronizes lookups for concurrency stability, and routes output through the selected origin's sink. All 48 hidden tests pass (re-verified independently). Falsification focused on behaviors the exhaustive suite does not directly exercise: dropping the badly-placed-class read correction (candidate preserves it — verified by an authored probe), family over-linking via referenced InnerClasses entries (impossible — those edges are genuine nesting), and own-lazy mis-tiering (impossible — Con…

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 8 (0 failed)
- **Duration:** 14m 38s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. Candidate implements the full duplicate-class-resolution feature correctly; all 48 hidden tests and 3 fair probes pass for both candidate and reference. The only divergence is an unspecified warning field (non-family 'metadata family root' = '<none>' vs reference's class name), which the verifier does not assert -> UNDERSPECIFIED_EDGE, true_positive.

**Details / suggested hardening:**

Legitimate, thorough solve. The candidate's monolithic StructContext rewrite correctly handles option validation, own>library tiering with registration/child order, error exact-byte conflicts, repeated-entry non-conflict, transitive InnerClasses/EnclosingMethod family coherence with anchoring and member-conflict reporting, deferred resolution, lazy/eager probe caching, addSpace/reload invalidation, synchronized concurrency, warnings, and output-sink ownership. One stylistic note (not a correctness issue): for non-family duplicates the warning's 'metadata family root' is emitted as '<none>' whereas the reference emits the class's own binary name; the task does not define this value and the verifier does not check it, so either is acceptable.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 20 (0 failed)
- **Duration:** 16m 11s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: under `error`, differing alternative bytes preempt the required family-coherence diagnostic, so the anchored origin is omitted.

**Details / suggested hardening:**

The implementation is substantial and passes nearly all explicit behavior, but `resolveFamilySelection` validates byte differences before checking whether the family anchor supplies the member. In the combined case, this emits a generic error conflict without the anchored origin, contrary to the prompt's required diagnostic fields. The hidden verifier lacks this cross-product case; the reference solution has the same gap.

- **Discriminator found:** Yes — `org.jetbrains.java.decompiler.DuplicateClassResolution_49e03e_Test.errorFamilyMemberConflictStillIdentifiesTheAnchorAndAlternatives`
- **Falsification attempts:** 4
- **Requirements checked:** 10 (1 failed)
- **Duration:** 19m 32s

---

## Nova #9 — ✅ Genuine pass · high confidence

- **Run:** `rd700857dx9v6a2xcebfxdh6rs8bcwf7` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 30m 16s

### Adjudicator — ✅ Genuine pass · high confidence

The candidate is a legitimate, prompt-faithful implementation that passes the full 48-test hidden verifier (reproduced) plus the baseline, and covers every clause of the specification via a dedicated ClassResolver. The only dissenting judge flagged a class-loaded-under-a-mismatched-entry-name (misplaced binary name) edge, but the reference solution behaves identically, so it is a shared underspecified gap rather than a candidate defect — not fair grounds for failure. If maintainers care about that aliasing case, it should be added to both the spec and the hidden suite; it does not affect this trial's disposition.

**Probe re-run reasoning:**

I re-ran the reward-gating hidden suite against clean+agent_solution+test.patch: duplicateClassResolutionTest reported tests=48 skipped=0 failures=0 errors=0 (BUILD SUCCESSFUL), so the candidate genuinely satisfies the verifier. Judge-a and judge-b independently reached true_positive after serious falsification. The lone false_positive (judge-c) ships a probe (FpMisplacedBinaryNameProbeTest) asserting that classfiles registered under an entry alias different from their internal binary name must be merged into one duplicate decision under 'error'. I re-ran that probe: the candidate fails both cases (returns 2 own classes; throws nothing), but the REFERENCE solution — the canonical correct implementation, ctor adapted enum->"error" — fails both identically (tests=2 failures=2). Judge-c even self-tags SPEC_GAP_REFERENCE_ALSO_FAILS. A probe on which the reference also fails does not discriminate and cannot ground a false_positive; it targets an unrequested edge (entry-path vs binary-name aliasing) the accepted solution does not implement. Over-flagged solo FP overruled.

**Independent read (before panel evidence):** ✅ Genuine pass

Before reading any critique I mapped every prompt clause (strategy option+validation, distinct per-origin identity, own-outranks-library, first/last by registration+child order, byte-exact error coalescing, repeated-entry tolerance, transitive InnerClasses/EnclosingMethod family anchoring with member-conflict reporting, metadata-linkage-alone-doesn't-combine, deferred resolution, per-context positive+negative lazy-probe and selection caching, add-source invalidation, reload discard, concurrency…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted) — Verdict true_positive matching mine. Its falsification probes (warning ordering/count, lazy cache vs reload, self-family double-warn) all resolved in the candidate's favor; I independently reproduced the 48/48 hidden pass it cites. Relied upon.
- **judge-b** (trust: trusted) — Verdict true_positive matching mine. Enumerated 23 requirements all satisfied; its two executable probes pass for both candidate and reference; the one divergence it found favors the candidate. Consistent with my review. Relied upon.
- **judge-c** (trust: distrusted, fair probe: No, discriminates: No) — Solo false_positive. Its probe (entry-alias vs binary-name merging under 'error') is unfair to ground an FP: I re-ran it and the reference solution fails both cases identically to the candidate (2/2 failures each), so it does not discriminate. Judge-c's own SPEC_GAP_REFERENCE_ALSO_FAILS tag concede…

**Tags:** `PANEL_AGREED_WITH_ME`, `SOLO_FP_OVERRULED`, `OVERFLAGGED`, `RERAN_PROBE`, `SPEC_GAP_REFERENCE_ALSO_FAILS`, `CONFIRMED_TP`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Exhaustive 48-test hidden suite covers every clause of the prompt; candidate (a ClassResolver structurally close to the reference) passes all, reproduced 48/48. Requirement-by-requirement review and three falsification attempts found no fair required behavior the candidate mishandles. Deserved pass.

**Details / suggested hardening:**

True positive. The candidate delivers a complete, correct implementation of deterministic duplicate-class resolution: strategy option with pre-processing validation, own>library precedence with registration/child-list ordering, exact-byte error handling with identical-byte coalescing, transitive InnerClasses/EnclosingMethod family coherence (including $-in-top-level and split-family cases), deferred resolution with per-context positive/negative lazy-probe and selection caching, correct invalidation-on-register vs discard-on-reload semantics, synchronized concurrency, semantic one-per-decision warnings, and selected-origin output ownership. Every prompt clause has hidden-test coverage and all 48 tests pass (reproduced). Three falsification attempts (first-strategy ignored-origin ordering/one-warning-per-decision, lazy negative-probe cache vs reload, potential double-warn on self-family) all resolved in the candidate's favor. Residual suspicions (option case-insensitivity, exact message…

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 9 (0 failed)
- **Duration:** 12m 39s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. The candidate fully implements deterministic duplicate-class resolution (first/last/error, own precedence, registration/child ordering, byte-equality error handling, InnerClasses+EnclosingMethod family coherence with anchoring, deferred resolution, per-context lazy-probe/selection caching, invalidation, reload, concurrency, semantic warnings, and selected-origin output ownership). The 48 new + 1 baseline verifier tests pass and reproduce. Four falsification attempts (including tw…

**Details / suggested hardening:**

Solid, legitimate solve. The dedicated ClassResolver cleanly separates duplicate-resolution policy from loading, correctly synchronizes resolution, and preserves output ownership via the isSelectedFrom loader filter. Minor non-blocking observations (not grounds for a false positive): (1) family indexing only covers eager own sources, shared with the reference and untested for lazy own sources; (2) getFamilyIndex reads every own class's bytes on first resolution, which is acceptable given deferred resolution but worth noting for very large own inputs. No required behavior was mishandled.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 22 (0 failed)
- **Duration:** 14m 27s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: entry aliases for one internal binary class bypass duplicate resolution and output deduplication.

**Details / suggested hardening:**

The solution is strong on the tested ordinary cases, but it resolves duplicates by IContextSource entry key rather than the parsed classfile binary name. A misplaced class is an existing supported repo behavior: DirectoryContextSource keys by path, and clean StructContext corrects wrong keys after parsing. With two own sources exposing different aliases for internal probe/Binary, error accepts differing bytes and identical bytes produce two own classes. The verifier should add binary-name normalization probes; the reference also needs the same correction.

- **Discriminator found:** Yes — `FpMisplacedBinaryNameProbeTest.errorGroupsCandidatesByClassfileBinaryNameNotEntryAlias`, `FpMisplacedBinaryNameProbeTest.identicalAliasesReturnOneSelectedOwnBinaryClass`
- **Falsification attempts:** 5
- **Requirements checked:** 9 (2 failed)
- **Duration:** 23m 08s
