# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 1 — false positives: 0, genuine passes: 1
- **Requested:** 2026-09-28 16:13
- **Completed:** 2026-09-28 16:53
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Nova #7 — ✅ Genuine pass · high confidence

- **Run:** `rd70ckjs8d3gejdk47xjty9kw98eep9a` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 31m 44s

### Adjudicator — ✅ Genuine pass · high confidence

The candidate is a legitimate, comprehensive implementation that passes all 8 baseline and all 125 hidden tests (independently re-verified). Judge-c correctly identified three real behavioral differences from the reference, but they lie outside the prompt's requirements: the reference preserves embedded lone-CR content round-trip (keeping ensureUnixLineBreaks=CRLF->LF plus a separate line-breaks-only classifier) whereas the candidate folds lone CR->LF in normalization, and the candidate's occupancy uses literal recorded-name matching rather than resolved-path aliasing. These are quality/robustness gaps a maintainer may wish to harden, not prompt violations. No action needed to accept the pass; if the store's content round-trip should be hardened against non-\n line breaks or occupancy against path aliases, add explicit tests and requirements first.

**Probe re-run reasoning:**

I independently re-ran the full hidden maintenance suite on the candidate (verifier worktree ./test.sh new => BUILD SUCCESSFUL; junit_new.xml tests=125 failures=0 errors=0) and all 8 baseline tests pass. Judge-c raised a solo false_positive with three probes; I wired them into a gradle task and confirmed they discriminate (candidate FAILS all three, reference PASSES all three). However none is a fair, prompt-grounded failure: (1) a custom strategy returning a filename containing an embedded CRLF is pathological and the prompt restricts only BUILT-IN names; (2) alternate-spelling occupancy is stricter than the prompt's 'recorded by another entry', which the hidden suite itself embodies with the LITERAL derived-name string (aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt); (3) embedded lone-CR content round-trip is outside the prompt's stated \r scope (integrity classification only), is untested by baseline (%n=\n) and hidden tests, and is a pathological content case. Discriminating-but-unfair probes do not uphold a solo FP, so the trial is a true positive.

**Independent read (before panel evidence):** ✅ Genuine pass

The hidden suite is exhaustive (125 deterministic tests) and maps clause-by-clause onto the prompt: fileNames strategies and deterministic/bounded/ASCII/machine-independent description naming, the six entry conditions (broken/resolved/shared/misplaced/colliding/occupied), unowned files, ignore/repair/fail semantics and reporting order, safe saves, forget-on-empty, and concurrency. I re-ran it against the candidate and got 125/0/0, and the 8 baseline tests also pass. The implementation reads as …

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive (high). Its four probes all pass on the candidate (by its own report), i.e. non-discriminating, consistent with a genuine pass. Agrees with my independent view; I did not need to re-run its probes since they do not claim a failure.
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Solo false_positive (high). All three probes genuinely discriminate (candidate fails, reference passes) — I re-ran them on both states and confirmed. But all three are over-flagging: probe 2 uses an absurd CRLF-containing filename; probe 3 demands alias/'./'-spelling occupancy stricter than the pro…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `TRUE_POSITIVE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Candidate passes the exhaustive 125-test hidden suite (reproduced) plus four fair boundary probes; no fair-required behavior is mishandled. Deserved pass.

**Details / suggested hardening:**

This is a genuine solve of a hard, richly-specified task. The candidate implements naming strategies, integrity ignore/repair/fail, the full entry-classification lattice, safe saves, forget-on-empty, and concurrency, and passes all 125 hidden tests, which map onto every clause of the prompt. I reproduced the pass and ran four independent fair probes (reserved-word/late-word/uniqueness naming, no-op-repair index idempotence); all pass on the candidate. No fair source requires a behavior the candidate gets wrong. True positive.

- **Discriminator found:** No
- **Falsification attempts:** 4
- **Requirements checked:** 6 (0 failed)
- **Duration:** 7m 26s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: the hidden verifier missed three fair edge behaviors.

**Details / suggested hardening:**

The candidate is a substantial, non-cheating implementation, but the pass is undeserved. It mishandles alternate spellings of an occupied prospective path, cannot round-trip a custom CRLF filename, and converts an escaped lone carriage return inside a saved violation into LF. The supplied probes reproduce these failures and pass on the reference.

- **Discriminator found:** Yes — `preservesAnEscapedLoneCarriageReturnInsideAViolation`, `customCarriageReturnLineBreakNameRemainsUsable`, `anAlternateSpellingRecordedByAnotherEntryOccupiesAProspectiveDerivedName`
- **Falsification attempts:** 3
- **Requirements checked:** 13 (3 failed)
- **Duration:** 23m 15s
