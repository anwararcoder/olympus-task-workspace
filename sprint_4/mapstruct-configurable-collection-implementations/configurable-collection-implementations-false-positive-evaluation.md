# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 1 — false positives: 0, genuine passes: 1
- **Requested:** 2026-07-23 07:36
- **Completed:** 2026-07-23 08:13
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Orion #5 — ✅ Genuine pass · high confidence

- **Run:** `rd78qk2avms3zw4n2jvas7sjsd8b365e` | **Agent:** Orion | **Judge dissent:** Yes | **Panel duration:** 27m 21s

### Adjudicator — ✅ Genuine pass · high confidence

The pass is a genuine true positive. The candidate delivers a complete, principled implementation of configurable collection implementations and passes the comprehensive 53-case hidden verifier (reproduced independently, 53/53). The one dissenting judge flagged direct-property object-factory precedence, but that behavior is shared with the reference solution (both produce the configured impl rather than invoking the factory), so it is at most an underspecified/shared spec gap, not a candidate-specific defect. If maintainers want factory precedence to hold for direct property copies too, that should be tightened in BOTH the reference and the hidden tests, since neither currently requires or exhibits it. Note also the candidate's own added tests (WithCompilerResource harness) are dropped by the grading's 3-way merge and are irrelevant to the graded outcome.

**Probe re-run reasoning:**

I rebuilt the graded state (baseline + hidden test.patch + candidate production-only changes) and ran the authoritative hidden suite: ConfigurableCollectionImplementationsC4i7Test = 53/53 pass, BUILD SUCCESS (verifier2-hiddentests.log), matching test_execution.log. The suite exhaustively covers the prompt. The only dissent (judge-c) claims an object factory must win for a direct bean-property collection copy; I re-ran judge-c's own probe on freshly built candidate and reference states and BOTH fail identically (emit ChosenList, not FactoryList) — see verifier2-probe.log and reference-probe.log. Because the canonical reference solution shares the exact behavior, the probe does not discriminate and asserts a contract stricter than the reference meets; per protocol the solo FP is over-flagging.

**Independent read (before panel evidence):** ✅ Genuine pass

From the prompt I enumerated the required behaviors (classpath resource lookup for the default mapstruct.properties or the mapstruct.configurationFile option, not the processor classloader; standard Properties parsing with equal-duplicate tolerance and diagnostics for unknown/unsupported/empty/conflicting entries; deferred multi-round resolution for later-generated implementations; public-concrete-class/assignable/unbounded-arity/preserved-params/public-no-arg-no-checked-exception validation wi…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, matching mine. Reproduced 53/53 and probed the untested checked-exception int-constructor boundary, which the candidate handles correctly; no discriminator found. Sound.
- **judge-b** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, matching mine. Probed a fair untested edge (Set + int-capacity ctor in a direct property) that passes on both candidate and reference, and noted the only shortfalls (inherited-ctor detection, stream-source capacity) are shared with the reference/underspecified. Consistent wit…
- **judge-c** (trust: distrusted, fair probe: No, discriminates: No) — Solo false_positive. Claims a direct bean-property collection copy must use an applicable @ObjectFactory over the configured implementation. I independently rebuilt candidate and reference states and ran judge-c's probe: BOTH fail identically (emit ChosenList). judge-c even tagged SPEC_GAP_REFERENC…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `SPEC_GAP_REFERENCE_ALSO_FAILS`, `PROBE_DID_NOT_DISCRIMINATE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Exhaustive 53-case hidden suite validates every prompt requirement; the agent's production implementation is complete and principled; an adversarial probe on the sole untested fair boundary passed. Deserved pass.

**Details / suggested hardening:**

True positive. The agent produced a complete, principled implementation of configurable collection implementations: Filer CLASS_PATH resource lookup (default mapstruct.properties or the mapstruct.configurationFile option, not the processor classloader), standard Properties parsing with equal-duplicate tolerance and conflict detection, full validation (public concrete class, assignability, unbounded type-parameter arity and preservation, public no-arg constructor without checked exceptions, optional usable int/capacity constructor), deferred multi-round resolution for processor-generated implementations, and TypeFactory integration so configured types override built-ins across direct properties, streams, forged/nested mappings, and existing targets while object factories still win. The hidden verifier is unusually exhaustive (46 fixtures, 53 cases) and covers every requirement clause; I reproduced the verifier state (working around the benign test-infra merge conflict on 4 scaffolding …

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 7 (0 failed)
- **Duration:** 14m 51s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. The candidate is a comprehensive, legitimate implementation of configurable collection/map implementations; all 53 hidden tests pass with strict assertions, the candidate matches the reference on every subtle point, and a fair probe of an untested edge (configured Set + int-capacity constructor in a property) passes on both. Remaining gaps (inherited constructors; stream-source capacity) are shared with the reference or underspecified, not candidate-only.

**Details / suggested hardening:**

Strong, production-quality solve. The deferred-round resolution, type-parameter preservation checks, and capacity-constructor wiring are all correctly implemented and align with the reference solution. Minor (shared, non-blocking) observation: constructor detection considers only declared constructors, so a configured subclass relying on an inherited public int constructor would use no-arg construction — but the reference has the same limitation and the hidden tests avoid this case.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 7 (0 failed)
- **Duration:** 14m 53s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: direct bean-property collection copying ignores an applicable @ObjectFactory and directly constructs the configured implementation, despite the prompt requiring factory precedence in every mapping form. The reference shares the gap.

**Details / suggested hardening:**

The candidate is substantial and passes all verifier cases, but the verifier missed a required cross-product: configured direct bean-property copying plus an applicable collection @ObjectFactory. The generated mapper constructs ChosenList directly instead of calling the factory that returns FactoryList. Add the packaged probe to close this specification gap; the reference solution needs the same correction.

- **Discriminator found:** Yes — `DirectPropertyFactoryPrecedenceProbeTest.directPropertyCopyUsesApplicableObjectFactory`
- **Falsification attempts:** 5
- **Requirements checked:** 10 (1 failed)
- **Duration:** 16m 48s
