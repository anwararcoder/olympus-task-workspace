# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 2 — false positives: 0, genuine passes: 2
- **Requested:** 2026-07-28 16:34
- **Completed:** 2026-07-28 17:06
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Orion #2 — ✅ Genuine pass · high confidence

- **Run:** `rd79gw70qavc0vqx2h010kjsbs8bc0xs` | **Agent:** Orion | **Judge dissent:** No | **Panel duration:** 28m 03s

### Adjudicator — ✅ Genuine pass · high confidence

Strong pass. The hidden k7p4 suite (103 tests) is unusually comprehensive and maps closely onto every enumerated prompt clause, leaving little room for a functional false positive; the candidate passes it and the full baseline. The implementation is substantive and mirrors the reference solution's design. The one behavior left unspecified by the prompt (whether inheritSuperMappings recursively re-applies on ancestors) matches the reference and is not a fair basis for failure. No action needed.

**Reasoning:**

I read the prompt, the candidate patch, and the hidden test.patch (103 tests in the k7p4 subpackage covering precedence, diamonds, generics/transitive overrides, flattening accumulation, config-inheritance interaction, parameter rebinding, verbatim expressions, conflict diagnostics, cross-package/private/covariant/default/update methods). test_execution.log records the candidate passing all 103 hidden tests and the full 3663-test baseline with BUILD SUCCESS. My independent standard is fully met. Both panel judges independently reached true_positive, each attempted falsification and reported their constructed probes PASS on the candidate (non-discriminating), and both note the candidate mirrors the reference solution's design choices. No judge raised a fair discriminating probe, so there is nothing to overturn; the only residual either judge noted (recursive re-application on supers) is unspecified by the prompt and matches the reference.

**Independent read (before panel evidence):** ✅ Genuine pass

The candidate adds `inheritSuperMappings() default false` to @BeanMapping and implements a substantive annotation-processor change (generic/transitive supertype traversal, current-method-wins precedence, most-specific resolution, incomparable-branch conflict diagnostics naming target+declaring types, shared-ancestor-once, target='.' flattening accumulation, source-parameter rebinding by signature position with the property-vs-parameter distinction, verbatim Java expressions, and the no-super-ma…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive/high, matching mine. Authored ProbeDiamondK7p4Test (shared-ancestor-once + incomparable-target combination) which the judge reports passes 2/2 on the candidate; three falsification attempts found no fair discriminator. No FP claim, so nothing to re-run/overturn.
- **judge-b** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive/high, matching mine. Transitive-chain probe passes on candidate (exit 0). Notes the candidate matches the reference design; residual 'recursive re-application on supers' is prompt-underspecified and also true of the reference, so classified UNDERSPECIFIED_EDGE, not an FP.

**Tags:** `PANEL_AGREED_WITH_ME`, `OVERFLAG_NONE`, `COMPREHENSIVE_VERIFIER`, `MATCHES_REFERENCE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Substantive, correct implementation of @BeanMapping(inheritSuperMappings); passes all 103 comprehensive hidden tests plus an authored fair diamond probe. No fair discriminator found — deserved pass.

**Details / suggested hardening:**

The candidate implements the full inheritSuperMappings feature in the annotation processor: supertype traversal (generic/transitive), property-only inheritance, local-wins precedence, most-specific resolution, incomparable-branch conflict errors, target='.' flattening accumulation, and source-parameter rebinding with a correct param-vs-property distinction decided against the overridden method. The hidden suite is unusually comprehensive (103 tests) and content-robust (error regexes require only target+declaring-type names, not exact wording), so the candidate's custom diagnostic strings remain valid. Three adversarial probes (wording, diamond shared-ancestor + incomparable-target combination, property spelled like a parameter) failed to falsify; the diamond probe passes on the candidate. This is a true positive.

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 8 (0 failed)
- **Duration:** 11m 45s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. The candidate fully implements inheritSuperMappings across all prompt-stated requirements; 103 hidden tests and a transitive-chain probe pass, and no fair falsification discriminator was found.

**Details / suggested hardening:**

The implementation is correct and complete against the task requirements. The only non-discriminating residual is the unspecified question of recursive re-application of inheritSuperMappings on supers, which the reference handles identically; this is an underspecified edge, not a defect.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 15 (0 failed)
- **Duration:** 8m 59s

### judge-c — unknown

- **Discriminator found:** No
- **Duration:** 25m 05s

---

## Orion #4 — ✅ Genuine pass · high confidence

- **Run:** `rd71hn9e8vjy7ycrecjet02jnx8bcnjd` | **Agent:** Orion | **Judge dissent:** Yes | **Panel duration:** 32m 10s

### Adjudicator — ✅ Genuine pass · high confidence

The pass is deserved. The candidate legitimately implements inheritSuperMappings and passes an exhaustive, prompt-aligned 103-test hidden suite. The one dissenting probe exposes a genuine behavioral divergence from the reference: when an override demotes a same-position source parameter to @Context, the candidate rebinds the inherited source path onto the @Context parameter (generating a read from context data) whereas the reference rejects it. This is real but out of scope for the prompt, which specifies rebinding purely by 'signature position' and never addresses @Context role changes. If maintainers consider a source->@Context demotion a hazard worth guarding, they should add an explicit prompt requirement and a hidden test; today it is an unspecified corner and not grounds for failing this solution.

**Probe re-run reasoning:**

I re-ran the hidden suite context and, decisively, re-ran judge-c's solo false_positive probe on the candidate: it does discriminate (candidate compiles a source->@Context role-change mapper and generates `nowContext.getValue()`; reference rejects). However the probe is UNFAIR. The prompt states literally 'rebind that segment to the overriding parameter in the same signature position' (task_description.txt:7) -- the candidate does exactly that; the prompt never mentions @Context nor requires the same-position overriding parameter to itself be a source parameter. The reference's rejection comes from an unstated extra guard (reference_solution.patch:357 `overridden.isSourceParameter() && overriding.isSourceParameter()`). The author's exhaustive 103-test suite tests full-signature-position rebinding (SignaturePositionMapperK7p4, with a @Context param in the hierarchy) yet deliberately never tests the source->@Context demotion, indicating it is out of intended scope. The probe over-fits to the reference's incidental diagnostic. Judges a and b independently reached true_positive after serious falsification. This is a 2-1 panel with the solo FP being over-flagging on an unrequested edge case.

**Independent read (before panel evidence):** ✅ Genuine pass

The candidate is a focused, legitimate implementation of @BeanMapping(inheritSuperMappings): it adds the annotation attribute, discovers overridden mapping methods through generic/transitive supertypes, applies most-specific precedence, combines incomparable-branch targets while erroring on same-target conflicts, dedups shared ancestors, accumulates target='.' flattening, rebinds source-parameter path segments by signature position, and is gated default-off. The hidden verifier is unusually exh…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive/high, matching mine. Did a requirement-by-requirement sweep plus a fair deeper 3-level most-specific-chain probe that passed on the candidate (non-discriminating, TP-supporting). Sound reasoning; did not need re-verification given the exhaustive passing suite.
- **judge-b** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive/high, matching mine. Enumerated six falsification hypotheses (precedence, rebinding classification, override discovery, config-inheritance ordering, message wording, dedup mechanism); none discriminated. Correctly characterized candidate/reference divergences as behaviorally e…
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Solo false_positive/high. Its probe (source parameter demoted to @Context in the override) genuinely discriminates -- I reproduced candidate failure / reference pass. But it is not prompt-grounded: the prompt says rebind to 'the overriding parameter in the same signature position' (which the candid…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `TRUE_POSITIVE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Exhaustively-tested MapStruct inheritSuperMappings feature; candidate is a legitimate independent implementation passing all 103 hidden + 3,649 baseline tests, and an additional fair deeper probe. True positive.

**Details / suggested hardening:**

Deserved pass. The 103-test hidden suite covers every clause of the prompt (precedence, most-specific resolution, incomparable-branch conflicts with diagnostics, shared-ancestor dedup, flattening accumulation, generic/transitive overrides, signature-position source rebinding, verbatim expressions, config-inheritance ordering, and default-off preservation) on both javac and Eclipse. The candidate implements the feature independently and correctly, gated behind isInheritSuperMappings with no test manipulation. A requirement-by-requirement falsification sweep plus a runnable probe extending most-specific resolution to a deeper 3-level chain found no fairly-required behavior the candidate mishandles.

- **Discriminator found:** No
- **Falsification attempts:** 2
- **Requirements checked:** 12 (0 failed)
- **Duration:** 14m 03s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. The candidate fully implements inheritSuperMappings; all 103 hidden tests + 3649 baseline pass (re-confirmed). Six falsification hypotheses (most-specific, shared-ancestor dedup, config-inheritance precedence, source rebinding edge cases, nested option usage, flattening) all failed to discriminate; a fair probe for plain-linear most-specific with a renamed parameter passes. Divergences from the reference are equivalent design choices, not behavioral defects.

**Details / suggested hardening:**

Legitimate, thorough implementation. The at-resolution source-rebinding design (InheritContext.isSuperMapping + SourceReference.BuilderFromMapping) is a sound alternative to the reference's at-retrieval string rewriting and passes the same comprehensive suite. No undeserved behavior found. Minor non-blocking note: error message wording differs from the reference, but the prompt does not specify message text and the hidden assertions are wording-agnostic, so this is acceptable.

- **Discriminator found:** No
- **Falsification attempts:** 6
- **Requirements checked:** 10 (0 failed)
- **Duration:** 16m 52s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: unchecked positional rebinding lets inherited @Mapping source paths read an overriding @Context parameter.

**Details / suggested hardening:**

The candidate solves the advertised inheritance, precedence, conflict, flattening, generic, and configuration cases, but its positional source rebinding bypasses the repository's parameter-role rules. In `buildFromSuperMappingSourceParameter`, the same-position overriding parameter must still be a source parameter; otherwise the inherited source path should remain invalid. The verifier missed the source-to-@Context direction and therefore awarded an undeserved pass.

- **Discriminator found:** Yes — `InheritSuperMappingsRoleChangeProbeTest.sourceParameterChangedToContextIsNotAValidInheritedSource`
- **Falsification attempts:** 5
- **Requirements checked:** 15 (1 failed)
- **Duration:** 25m 13s
