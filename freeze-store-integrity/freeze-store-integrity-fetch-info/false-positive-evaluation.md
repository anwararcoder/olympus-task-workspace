# ❌ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `FAILED` — a passing run was flagged as a false positive
- **Runs evaluated:** 4 — false positives: 2, genuine passes: 2
- **Requested:** 2026-09-29 23:46
- **Completed:** 2026-09-30 02:21
- **Token cost:** 8
- **Criterion status:** fail — A passing run was flagged as a false positive
  - The review panel judged a passing solution to not actually meet the task's requirements. Tighten the task or its tests, then re-run agents.

---

## Nova #2 — ✅ Genuine pass · medium confidence

- **Run:** `rd750776m41gm1ekwqdg5f8mns8favt9` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 25m 55s

### Adjudicator — ✅ Genuine pass · medium confidence

The pass is a genuine true positive: the agent implementation clears an exhaustive 148-test spec-encoding suite plus 42 baseline tests, which I re-ran and confirmed (190/190). judge-c's two discriminating probes exploit corners the spec leaves ambiguous rather than clear violations. If maintainers want to nail these down, they should (a) decide explicitly whether a non-empty legacy violation file with raw CRLF boundaries should strip the trailing CR (reference behavior) or keep it as content (candidate behavior) - the current prompt sentence is self-contradictory - and (b) decide whether save-rejection's 'recorded by another entry' applies to different spellings of an ABSENT recorded path, which even the pre-feature baseline permitted. Both should become explicit hidden tests if the reference behavior is intended.

**Probe re-run reasoning:**

I materialized clean/reference/candidate worktrees and re-ran judge-c's two probes. Both discriminate (candidate fails, reference passes), but neither is a fair, clearly-prompt-required failure. Probe 2 (reject a new rule's './shared' when another entry records the absent 'shared') also fails on the CLEAN baseline, so it is not 'current format' behavior; the prompt's own semantics treat two spellings of an ABSENT name as separate/broken (hidden test entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken), so 'recorded by another entry' does not unambiguously cover a different spelling of an absent path. The reference's canonical-equality-when-absent is a stricter implementation choice the 148-test verifier never requires (it tests only literal-name collision, which the candidate DOES reject). Probe 1 (strip trailing \r from a raw \r\n legacy file) sits on a self-contradictory prompt sentence that demands both 'keep their current format' (strip) and 'a carriage return inside a stored violation stays part of that violation's text' (keep); the candidate coherently honors the latter, and on a violation ending in \r the reference silently drops it while the candidate preserves it. The exhaustive verifier deliberately constructs all its \r tests to avoid the raw-\r\n-boundary case, leaving this corner unpinned; both candidate and reference pass all 148. Both probes are over-flagging on ambiguous/reference-specific corners.

**Independent read (before panel evidence):** ✅ Genuine pass

I re-ran the hidden verifier against the agent solution and independently confirmed 148/148 maintenance tests and 42/42 baseline tests pass (190/190). The hidden suite is an unusually exhaustive, behavioral, clause-by-clause encoding of the prompt (naming strategies, integrity modes repair/fail/ignore, broken/resolved/misplaced/shared/colliding/occupied/unowned classification, symbolic/hard links, safe saves, forgetting rules, concurrency, cross-JVM stable naming). Passing it demonstrates the r…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, discriminates: No) — Verdict true_positive/high, matching mine. Shipped only a prompt-required naming probe that PASSES on the candidate (found_discriminator=false); no false-positive claim to verify. Its requirement-by-requirement walk aligns with my independent standard.
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Solo false_positive/high. I reproduced both probes: candidate fails both, reference passes both, clean baseline passes probe1 and fails probe2. Both are over-flagged. Probe2 asserts a stricter absent-path 'recorded by another entry' contract than the prompt's literal same-name semantics (and clean …

**Tags:** `SOLO_FP_OVERRULED`, `OVERFLAGGED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `AMBIGUOUS_SPEC`, `VERIFIER_EXHAUSTIVE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Exhaustive 148-test behavioral verifier; candidate implements every spec requirement correctly; no fair discriminating probe found. Deserved pass.

**Details / suggested hardening:**

This is a legitimate, high-quality solve of a very hard, tightly-specified task. The candidate's TextFileBasedViolationStore rewrite correctly handles the full naming/integrity/repair/fail/safe-save/concurrency spec. The hidden suite (148 tests) mirrors the spec clause-by-clause with behavioral, format-agnostic assertions, so passing it demonstrates the required behaviors rather than incidental string matching. I walked every spec requirement against the candidate code and ran an adversarial fair probe on the trickiest clause (a qualifying word appearing only late in a long description); the candidate handled it correctly. No fairly-required behavior is mishandled and no fair discriminating probe exists. True positive.

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 9 (0 failed)
- **Duration:** 7m 36s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: verifier passed, but CRLF reading and equivalent-absent-name ownership both fail fair probes.

**Details / suggested hardening:**

The candidate is broad and legitimate, but the pass missed two contract edges: preserve the existing CRLF normalization when reading stored violations, and compare a new name by resolved path identity/equivalent spelling against all recorded entries even when no file exists.

- **Discriminator found:** Yes — `readsCrLfRecordSeparatorsWithoutLeavingCarriageReturns`, `unknownRuleCannotTakeOverAnotherEntriesEquivalentAbsentPath`
- **Falsification attempts:** 7
- **Requirements checked:** 10 (2 failed)
- **Duration:** 15m 25s

---

## Nova #6 — ❌ False positive · high confidence

- **Run:** `rd74dba480yw9da8wdz1bwwfq58faz04` | **Agent:** Nova | **Judge dissent:** No | **Panel duration:** 17m 11s

### Adjudicator — ❌ False positive · high confidence · verdict changed by panel evidence

Confirmed functional false positive. Bug: TextFileBasedViolationStore.FileSyncedProperties.put() normalizes the rule-description key via ensureUnixLineBreaks before setProperty, so integrity repair's move of a misplaced entry (rules.put(entry.key, derived)) rewrites a CRLF-keyed entry under its LF spelling. This leaves the original CRLF entry pointing at the moved/broken file and clobbers any separate LF-keyed entry, violating 'entries differing only in line breaks stay separate'. Fix: write the moved entry under its exact original key (do not normalize on put during maintenance move), as the reference does. The hidden suite exercises the separate-entries rule only for the broken/random-name path; add a misplaced-move case with CRLF/LF keys (and even a single misplaced CRLF-described rule under built-in 'description' naming) to close the gap.

**Probe re-run reasoning:**

repair() moves a misplaced entry via rules.put(entry.key, derived), and FileSyncedProperties.put does setProperty(ensureUnixLineBreaks(key), value). For a CRLF-keyed misplaced entry this writes to the normalized LF key: the original CRLF entry is left pointing at the moved (now broken) file and a separate LF entry is silently overwritten. That violates the prompt's explicit invariant 'Entries already in the index whose rule descriptions differ only in their line breaks are still separate entries.' I re-ran judge-c's probe myself: candidate BUILD FAILED at FpProbeLineBreakMoveTest.java:43 (getProperty("rule\r\nbreak") was "legacy", not "crlf-derived"); reference BUILD SUCCESSFUL. The reference deliberately guards this ('keys are taken exactly as the index holds them, since it can hold keys that differ only in their line breaks'). The trigger is prompt-supported (custom strategies receive the raw description with \r\n) and the same corruption is reachable even with built-in 'description' naming for a single misplaced CRLF-described rule, so it is in scope, not a contrived edge. The verifier tests the separate-entries invariant only for the broken/healthy random-name path and never for the misplaced-move write-back path where the bug lives.

**Independent read (before panel evidence):** ✅ Genuine pass

Working from the prompt and the unusually exhaustive 148-test hidden suite (which exercises naming, path-safety, shared/broken/resolved/misplaced/colliding/occupied classification, repair/fail ordering, forget-on-empty, links and concurrency), I judged the candidate a complete, genuine implementation and provisionally leaned true_positive. I saw that FileSyncedProperties.put() normalizes the key with ensureUnixLineBreaks, but before reading the panel I did not connect that write-back path to th…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: distrusted, fair probe: Yes, discriminates: Yes) — Verdict true_positive. Its own probe (misplaced entry naming a symlink leaves an orphaned dangling link) does discriminate vs the reference, but judge-a fairly judged it underspecified (prompt distinguishes resolved 'with the link' from misplaced 'the link's target rather than the link'; hidden sui…
- **judge-c** (trust: trusted, fair probe: Yes, discriminates: Yes) — Verdict false_positive. Probe targets an explicit prompt invariant with a legitimate custom strategy. I reproduced it: candidate fails at line 43, reference passes. Root cause and reference guard confirmed by code reading. Upheld.

**Tags:** `CONFIRMED_FP`, `SOLO_FP_UPHELD`, `RERAN_PROBE`, `PANEL_CHANGED_MY_MIND`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: questionable

Passing trial with a genuinely complete implementation; the only reference divergence (leaving an orphaned symlink after a misplaced move) is a deliberately-underspecified edge, so the pass is a true positive.

**Details / suggested hardening:**

Thorough, correct implementation of the freeze-store integrity feature covering naming (random/description/custom), integrity ignore/repair/fail, path safety, all seven classification conditions, fail-report ordering, repair idempotency, forget-on-empty-under-repair, and cross-store concurrency locking; all 148 hidden and 42 baseline tests pass. The one divergence from the reference is that repairing a misplaced entry whose recorded name is a symlink moves the link's target to the derived name but leaves the now-orphaned symlink behind, while the reference deletes it. This is not a fairly-required behavior: the prompt phrases resolved ('deleting a link's target with the link') and misplaced ('moving a link's target rather than the link') differently, and the hidden tests assert link removal only for the resolved case, using symlink-blind fileNames() for misplaced. The leftover dangling link is invisible to the store's regular-file model and breaks no consistency requirement. Underspec…

- **Discriminator found:** Yes — `probe_repairOfAMisplacedEntryNamingALinkLeavesNoDanglingLinkBehind`
- **Falsification attempts:** 2
- **Requirements checked:** 8 (0 failed)
- **Duration:** 11m 56s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: broad verifier pass, but repair collapses distinct CRLF/LF index keys when moving a CRLF entry.

**Details / suggested hardening:**

The candidate should update a moved index entry using its exact on-disk key; normalizing the key during repair merges CRLF and LF entries and violates the explicit separate-entry requirement.

- **Discriminator found:** Yes — `repair_keeps_crlf_and_lf_index_keys_separate_when_only_crlf_entry_moves`
- **Falsification attempts:** 8
- **Requirements checked:** 10 (1 failed)
- **Duration:** 10m 30s

---

## Nova #7 — ❌ False positive · medium confidence

- **Run:** `rd715nf8ejf8pf5f4vjs02gyrd8facte` | **Agent:** Nova | **Judge dissent:** No | **Panel duration:** 19m 40s

### Adjudicator — ❌ False positive · medium confidence · verdict changed by panel evidence

The candidate over-broadens the 'broken' classification: inspect() marks any entry whose file resolves to the index as broken (pointsToIndex), so integrity=repair silently discards an entry recorded as pointing at stored.rules even though the prompt's closed definition (regular file directly in the folder, with content) makes it neither broken nor resolved. The reference keeps such an entry. This corner is untested by the 148-case hidden suite, which is exactly why the pass slipped through. To fix, drop pointsToIndex from the broken predicate (index-target safety is already enforced separately on the save path). This is a narrow, pathological deviation, but it is determinable from the prompt's stated rules and the reference disagrees with the candidate.

**Probe re-run reasoning:**

Judge-c's index-entry probe exposes a real, prompt-grounded, untested deviation. The prompt defines 'broken' as a closed condition (resolved path is not a regular file directly in the folder). An entry recorded as pointing at the index (stored.rules) resolves to a regular file directly in the folder, so it is not broken; the index has content, so it is not resolved; with random names nothing is derived, so it is not misplaced. Per the prompt, repair discards only broken/resolved entries (and moves misplaced), so it must leave this entry alone. The candidate's inspect() adds an unstated 'pointsToIndex -> broken' predicate and repair discards the entry. I re-ran the probe in isolated worktrees: candidate FAILS (mapping removed at FreezeStoreProbeTest.java:106), reference PASSES (entry preserved) — confirming the probe is fair and discriminating. Confidence is medium rather than high because the scenario is a pathological corner (a save can never create such an entry) and a maintainer could view a defensive discard as tolerable; but the prompt's exhaustive classification rules and the reference both determine that the entry must be kept.

**Independent read (before panel evidence):** ✅ Genuine pass

The hidden verifier (FreezeStoreMaintenance_e448f3_Test, 148 cases) maps almost sentence-by-sentence onto the prompt, and the candidate passes all 148 plus 42 baseline (190/190), implementing naming strategies, integrity modes, broken/resolved/misplaced/shared/colliding/occupied/unowned classification, link handling, save-target validation, forget-on-empty, and per-path locking. On my own requirement-by-requirement read before opening the panel I found no clearly-required behavior obviously mis…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: distrusted) — Verdict true_positive with high confidence and a thorough requirement-by-requirement coverage map; it explicitly surrendered (no discriminator found) after probing last-vs-first kept word, hard-link ownership, and index-write minimality. Its coverage work is sound, but it missed the repair-time ind…
- **judge-c** (trust: trusted, fair probe: Yes, discriminates: Yes) — Primary probe (anIndexEntryIsNotBrokenMerelyBecauseItsTargetIsTheDirectRegularIndex) is prompt-grounded and I confirmed it discriminates (candidate fails, reference passes). Judge-c's own note that save-time index rejection is separate is correct and does not undermine the inspect-time claim. Its s…

**Tags:** `CONFIRMED_FP`, `SOLO_FP_UPHELD`, `RERAN_PROBE`, `PANEL_CHANGED_MY_MIND`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Exhaustive 148-test hidden suite maps onto essentially every prompt clause; candidate passes all, implements each requirement correctly, and the one ambiguous edge is shared with the reference. Deserved pass.

**Details / suggested hardening:**

Strong, deserved pass. The candidate implements the full freeze-store integrity feature (fileNames random/description/strategy-class, integrity ignore/repair/fail, classification of broken/resolved/misplaced/occupied/shared/colliding/unowned via file-identity, link-aware repair and forgetting, save-safety, and per-path lock-based concurrency) self-contained in TextFileBasedViolationStore. I falsification-tested the highest-risk divergences: (1) the description strategy keeps the LAST qualifying word rather than the first, but its 4..120 maximal-run notion is provably identical to the hidden test's word check, so any kept word is accepted; (2) unowned classification for an unrecorded hard link is underspecified and handled the same identity way as the reference; (3) index-write minimality and no-momentary-index-on-reject are honored. No fair source requires a behavior the candidate gets wrong. The included probe is a confirming (non-discriminating) description-naming check.

- **Discriminator found:** No
- **Falsification attempts:** 3
- **Requirements checked:** 10 (0 failed)
- **Duration:** 7m 20s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

Verifier pass was real, but repair wrongly removes a nonempty entry whose name resolves directly to the regular stored.rules index; targeted probe fails candidate and passes reference.

**Details / suggested hardening:**

False positive: remove pointsToIndex from the integrity broken classification (or otherwise preserve this direct regular, nonempty entry under the stated contract), and ensure empty repair saves validate ownership before deleting any resolved target. The existing verifier did not exercise these boundaries.

- **Discriminator found:** Yes — `repairForgetDoesNotDeleteAFileOutsideTheStore`, `anIndexEntryIsNotBrokenMerelyBecauseItsTargetIsTheDirectRegularIndex`
- **Falsification attempts:** 4
- **Requirements checked:** 12 (2 failed)
- **Duration:** 13m 32s

---

## Nova #9 — ✅ Genuine pass · high confidence

- **Run:** `rd76pp0e5d5cyb8wk2wznzk07s8fb6st` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 16m 50s

### Adjudicator — ✅ Genuine pass · high confidence

The pass is deserved. The candidate implements the full freeze-store integrity feature and passes the exhaustive 148-test hidden suite plus 42 baseline tests, reproduced here (BUILD SUCCESSFUL). judge-c found a genuine behavioral divergence from the reference: for an ABSENT recorded path, the candidate compares path spellings literally (raw Path.equals) while the reference normalizes './derived-name' to 'derived-name' for the occupied/'recorded by another entry' check. However this is not a prompt-required behavior: the prompt deliberately limits the 'under any spelling' qualifier to the index-leading check, and the ground-truth suite establishes that two spellings of an absent name are treated as distinct (entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken), a convention the candidate honors. If maintainers consider absent-path alias occupancy important, they should add an explicit hidden test and tighten the prompt — but its absence is not grounds to fail this solution.

**Probe re-run reasoning:**

I re-ran the hidden maintenance suite on the candidate (verifier worktree = clean + agent_solution.patch + test.patch): BUILD SUCCESSFUL, freezeStoreMaintenanceTest executed 148/148, matching test_execution.log (190/190). The only FP claim comes from judge-c: two probes where an entry records './derived-name' (an absent path) and a new rule / misplaced rule derives 'derived-name'; the candidate compares raw Paths (./derived-name != derived-name lexically) and so does not treat it as 'recorded/occupied', while the reference normalizes via denotedFileOf(resolvedIn(...)) and rejects. The discrimination is real (confirmed by reading both implementations and judge-c's documented run), but the probe is UNFAIR: (1) the prompt (line 21) attaches 'under any spelling or through a symbolic or hard link' ONLY to the index-leading check, deliberately NOT to 'already names something or is recorded by another entry'; (2) the parallel concept 'Entries recording the same name are shared, even if nothing exists under it' is string-based for absent names, as the hidden test entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken confirms ('different names that reach no file are broken rather than shared') and the candidate passes; the reference's own comment agrees ('two spellings of an absent name reach no file'). Thus normalizing absent-path spellings for the occupancy check is a reference-specific implementation choice, not a behavior the prompt clearly demands, and the exhaustive suite del…

**Independent read (before panel evidence):** ✅ Genuine pass

The candidate fully rewrites TextFileBasedViolationStore to implement default.fileNames (random/description/custom strategy), default.integrity (ignore/repair/fail), the entire broken/resolved/shared/misplaced/colliding/occupied/unowned classification, repair moves/deletes, byte-stable fail reporting, save-time path safety, repair save-forgetting, and concurrency safety. The hidden verifier is extraordinarily thorough (148 new tests) and maps almost 1:1 onto the prompt's sentences; the candidat…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, matching mine. Four falsification attempts (late-word retention, 200-char bound, escaping-file deletion, cross-JVM determinism) all correctly found non-discriminating; three fair naming probes pass on the candidate. Reasoning that divergences from the reference (last-word + f…
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Solo false_positive. Its two probes genuinely discriminate (candidate raw Path.equals in isRecordedByAnotherEntry/isOccupied vs reference denotedFileOf normalization) — confirmed by reading both code paths and judge-c's probe-results.txt. But the probes are UNFAIR: the prompt scopes 'under any spel…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `PANEL_AGREED_WITH_ME`, `RERAN_PROBE`, `PROMPT_SILENT_ON_EDGE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Exhaustive hidden suite (148+42) tracks the spec closely; candidate is spec-aligned on every fairly-required behavior. Four falsification attempts on naming/paths/determinism found no fair discriminator; 3 fair probes pass. Deserved pass.

**Details / suggested hardening:**

True positive. The candidate rewrote TextFileBasedViolationStore to implement default.fileNames (random/description/custom), default.integrity (ignore/repair/fail), full entry classification (broken/resolved/shared/misplaced/colliding/occupied/unowned), repair moves/deletes, byte-stable fail reporting, save-time path safety, and repair save-forgetting, all consistent with the prompt. Its divergences from the reference (keeping the last qualifying word and appending a full SHA-256 hex rather than a leading readable prefix + short fingerprint) stay within the spec's allowed latitude: names still keep a whole 4-120 word, use only [A-Za-z0-9_-], stay <=200 chars, avoid 'stored.rules', differ per rule, and are deterministic. The most promising crack (an outside file being deleted when forgetting an escaping entry) is unreachable because escaping entries are pruned as broken during repair init unless shared, and shared entries hit the keep branch. No fair source requires a behavior the cand…

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 11 (0 failed)
- **Duration:** 11m 12s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: the candidate passes the verifier but mishandles equivalent absent-path aliases recorded by another entry during new saves and repair moves.

**Details / suggested hardening:**

The verifier missed canonical/resolved path aliases for absent destinations. In both new-save and repair ownership checks, the candidate uses raw Path equality, allowing derived-name to bypass an existing ./derived-name index record. Add coverage for equivalent spellings with no file present.

- **Discriminator found:** Yes — `unknownRuleCannotTakeAPathAliasAlreadyRecordedByAnotherEntry`, `repairCannotMoveOntoAPathAliasAlreadyRecordedByAnotherEntry`
- **Falsification attempts:** 5
- **Requirements checked:** 10 (4 failed)
- **Duration:** 11m 55s
