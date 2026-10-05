# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 1 — false positives: 0, genuine passes: 1
- **Requested:** 2026-07-28 17:46
- **Completed:** 2026-07-28 18:12
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Nova #4 — ✅ Genuine pass · high confidence

- **Run:** `rd74pcpjvetfj4x8n7y8sqdrh58bdy3w` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 25m 24s

### Adjudicator — ✅ Genuine pass · high confidence

The candidate is a legitimate, comprehensive implementation of transactional JSP batch migration in both artifacts and satisfies the prompt. The only dissent (judge-c) rests on an obscure hard-link aliasing scenario that the prompt does not require: the prompt's link handling is entirely about symbolic links, 'unrelated paths remain untouched' is about files outside the migration set rather than inode aliases, and the reference tolerates the case only incidentally via its atomic temp-file+move write strategy. If preserving hard-linked external content is actually desired, the prompt should state it explicitly and the hidden suite should cover it; as written, in-place writing is a valid strategy.

**Reasoning:**

Two judges (a, b) reached true_positive and re-ran the hidden suite; the sole false_positive is judge-c's hard-link probe. I inspected both write strategies: the candidate rewrites usage files in place via Files.write(TRUNCATE_EXISTING) (same inode), while the reference stages to Files.createTempFile then Files.move(stage,target,REPLACE_EXISTING) (new inode). The probe hard-links an in-root usage.jsp to an outside.jsp and asserts the outside alias is byte-unchanged after commit; it does discriminate, but it tests hard-link aliasing, which the prompt never raises (the prompt discusses only symbolic links). 'unrelated paths remain untouched' reasonably means files not in the migration set, not inode aliases; the converter writes exactly the scanned path it should, and 'leave no temporary files' is satisfied by in-place writes. The reference passes only as an incidental side effect of its atomic-move strategy, not intentional hard-link handling. That makes the probe an unfair, implementation-detail-dependent edge case, i.e. over-flagging.

**Independent read (before panel evidence):** ✅ Genuine pass

Reading the prompt and the candidate patch before any critique, the implementation is a faithful, substantive solution: planTags builds an immutable JspMigrationPlan with normalized absolute paths, deterministic lexical-first dependency ordering with cycle reporting, a full battery of IllegalArgumentException validations (null/empty/blank/absolute/duplicate/non-.tag/missing/non-regular/symlink selected paths, approved-include and destination checks), snapshot-based staleness with StaleJspMigrat…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — true_positive with high confidence; requirement_coverage rows all resolved to 'yes' with cited sites and passing hidden tests; its ProbeDiamondDeps scenario is fair and passed on the candidate. Agrees with my independent view.
- **judge-b** (trust: trusted, fair probe: Yes, discriminates: No) — true_positive with high confidence; attacked architecturally distinct choices (regex virtual view, cycle DFS, non-selected .tag handling, parity) and all fair probes passed on both candidate and reference. Agrees with my independent view.
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Solo false_positive. Probe genuinely discriminates (candidate in-place TRUNCATE_EXISTING mutates a hard-linked outside file; reference's temp-file + atomic Files.move preserves it), confirmed by code inspection and the judge's own exit codes (1 vs 0). But it is UNFAIR: hard-link aliasing is never m…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `PANEL_AGREED_WITH_ME`, `IMPLEMENTATION_DETAIL_PROBE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Faithful, substantive implementation of transactional JSP batch migration in both artifacts; exhaustive hidden suite plus my own diamond-dependency probe confirm correctness. No fair discriminator found — deserved pass.

**Details / suggested hardening:**

The candidate implements the entire prompt (validation, dependency analysis, deterministic lexical-ready ordering, virtual conversion, immutable plan collections, byte-accurate snapshots, timestamp-independent staleness with deduplicated lexically-ordered getChangedPaths, once-only transactional commit with directory-aware rollback and suppressed exceptions, and identical javax/Jakarta behavior). Every requirement I enumerated resolves to a correct implementation site backed by a passing hidden test. A diamond-dependency probe I wrote (a fair prompt-mandated scenario the hidden suite covers only as a linear chain) passed on the candidate. The only unexercised behaviors are genuinely underspecified edges. This is a true positive with high confidence.

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 8 (0 failed)
- **Duration:** 11m 25s

### judge-b — ✅ Genuine pass · high confidence · probe fairness: fair

Deserved pass. The candidate implements the full transactional JSP batch-migration feature for both javax and Jakarta artifacts via a valid alternative design (dependency injection via JspJteConverter(fixedJteTagPath) + regex virtual-view instead of a parser resource overlay). All hidden tests pass, and all fair probes I authored pass on both candidate and reference. No fair discriminator found.

**Details / suggested hardening:**

Solid, legitimate solve. The candidate chose a different but behaviorally-equivalent strategy than the reference for the 'virtual view of earlier conversions' (registering JspJteConverter with a fixed JTE path per dependency and rewriting usage files by regex, rather than overlaying virtual resources into the JSP parser). I verified this equivalence on attribute/body invocations inside approved includes, cycle reporting with a non-cycle predecessor, and non-selected .tag usage-file writes. No changes required; the verifier's pass reflects real correctness.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 20 (0 failed)
- **Duration:** 12m 21s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: direct in-place writes mutate outside hard-link aliases, violating the explicit unrelated-path isolation requirement in both artifacts.

**Details / suggested hardening:**

The candidate is broadly complete and passed extensive validation, dependency, staleness, rollback, hook, and parity tests. However, commit writes existing usage paths with TRUNCATE_EXISTING. If an affected usage file is hard-linked to a path outside the migration roots, the outside path's bytes change on success. The prompt explicitly requires unrelated paths to remain untouched, and the packaged javax/Jakarta probes fail on the candidate but pass on the reference.

- **Discriminator found:** Yes — `JspMigrationPlanHardLinkProbeTest.successfulCommitDoesNotMutateOutsideHardLinkAlias`, `JakartaJspMigrationPlanHardLinkProbeTest.successfulCommitDoesNotMutateOutsideHardLinkAlias`
- **Falsification attempts:** 5
- **Requirements checked:** 10 (1 failed)
- **Duration:** 18m 02s
