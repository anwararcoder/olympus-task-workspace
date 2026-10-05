# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 1 — false positives: 0, genuine passes: 1
- **Requested:** 2026-07-19 19:12
- **Completed:** 2026-07-19 19:37
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Orion #4 — ✅ Genuine pass · high confidence

- **Run:** `rd759q119txqbbegqf7dg4mrvd8atg6b` | **Agent:** Orion | **Judge dissent:** Yes | **Panel duration:** 25m 14s

### Adjudicator — ✅ Genuine pass · high confidence

The pass is a genuine true positive: a complete, non-cheating compact-binary implementation across runtime + processor that satisfies the prompt and the comprehensive 38-test hidden suite. One real but out-of-scope robustness gap exists: an unknown enum constant appearing BEFORE other elements inside a container causes readFrom to throw 'Trailing data in binary field' (readList abandons the field on EnumMismatch without consuming the remaining element bytes, tripping the trailing-data check). The reference solution has an even weaker version of the same gap (uncaught IllegalArgumentException), so it is not grounds for failing the candidate, but a maintainer may want to make container decoding consume the full field before returning absent, and treat removed enum constants inside containers as absent, to fully honor the 'mismatched container elements => absent' clause.

**Reasoning:**

test_execution.log shows 38/38 hidden tests and 326 baseline tests passing (BUILD SUCCESS), and value-fixture already depends on serial so the form is genuinely generated. Judge-c's solo false_positive rests on the probe unknownEarlyEnumElementMakesContainerAbsent (List<enum>=[REMOVED,SHARED] read with an enum lacking REMOVED, expecting an empty list). Judge-c's own reference-probe.log shows the REFERENCE solution also fails that probe (IllegalArgumentException 'No enum constant ...REMOVED'), while the candidate throws IOException 'Trailing data in binary field'. Since the canonical correct solution also fails, the behavior is not fairly required and the probe does not discriminate (rubric requires candidate-fails AND reference-passes). I confirmed the candidate's failure mechanism by reading Binary.java: readList returns EnumMismatch at the first unknown element without consuming later element bytes, so requireFullyConsumed then throws. Judge-a and judge-b independently reached true_positive and their fair edge probes all passed on the candidate.

**Independent read (before panel evidence):** ✅ Genuine pass

Before reading the panel I mapped the prompt's required surface (activation via serial on classpath, writeTo/readFrom round-trip, name-independent + order-independent matching, type-mismatch-as-absent, version skew, all listed collection/optional/array/enum shapes, direct nested immutables, constructor-built values, derived/aux handling, conflict preservation, unsupported/recursive => neither method, truncation error) and checked the candidate against it. The candidate is a substantive 715-line…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, matching mine. Authored 5 fair probes (arrays of every scalar kind, empty string, enum list/set, @Value.Default round-trip and default) all of which passed on the candidate; no discriminator claimed.
- **judge-b** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, matching mine. 6 fair edge probes (empty string, nullable both ways, cross-enum-type list recovery, truncated nested payload, renamed non-positional matching) all passed on the candidate; no discriminator found.
- **judge-c** (trust: distrusted, fair probe: No, discriminates: No) — Solo false_positive, OVERRULED. The probe holds the candidate to a standard the reference solution itself does not meet: judge-c's own reference-probe.log shows the reference also fails the unknownEarlyEnumElementMakesContainerAbsent test (uncaught IllegalArgumentException on the removed enum const…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `PANEL_AGREED_WITH_ME`, `NON_DISCRIMINATING_PROBE`, `SPEC_GAP_REFERENCE_ALSO_FAILS`, `VERIFIER_PASSED`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Comprehensive hidden suite plus 5 additional fair probes for under-tested required behaviors all pass; no fair discriminator exists. Deserved pass.

**Details / suggested hardening:**

Strong true positive. The candidate's compact-binary implementation satisfies the entire required surface: a self-describing wire format (magic/version/field-count header, per-field name fingerprint + type fingerprint + length-prefixed payload) that matches attributes by name, treats unknown/mismatched fields as absent without desync, omits attribute names, and errors on truncation. Beyond the 38-test hidden suite, I verified four prompt-required behaviors the suite under-tests — primitive arrays of every scalar kind (long/double/float/short/char/boolean, not just byte/int), empty-string round-trip, enum List+Set, and builder @Value.Default round-trip/defaulting — all of which pass. The sole unfalsifiable residue (64-bit FNV fingerprint collisions) is not fairly probeable and is handled by design.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 11 (0 failed)
- **Duration:** 12m 04s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. Candidate implements the full compact-binary-form spec (runtime + processor eligibility + generation) and passes all 38 hidden + 326 baseline tests; 6 fair edge probes (empty string, nullable presence, cross-enum list recovery, truncated nested payload, renamed-attribute non-positional matching) all pass on the candidate. No fair discriminator found.

**Details / suggested hardening:**

The candidate's solution is a legitimate, substantive implementation that satisfies every behavior the task fairly requires. The implementation differs structurally from the reference (the candidate uses a single Binary runtime with structural type fingerprints and FNV-1a attribute identifiers, and supports nullable scalars which the reference disables), but every divergence is a permitted design choice or a strict superset of the reference's surface. No false-positive signal.

- **Discriminator found:** No
- **Falsification attempts:** 5
- **Requirements checked:** 12 (0 failed)
- **Duration:** 12m 33s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: an early unknown enum constant inside a list throws instead of making the attribute absent.

**Details / suggested hardening:**

Add enum-container evolution coverage where the reader lacks an early writer constant. Candidate returns early and rejects unread payload; reference also violates this prompt requirement.

- **Discriminator found:** Yes — `BinarySerializationProbeTest.unknownEarlyEnumElementMakesContainerAbsent`
- **Falsification attempts:** 5
- **Requirements checked:** 12 (1 failed)
- **Duration:** 19m 25s
