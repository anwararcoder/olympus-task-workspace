# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 1 — false positives: 0, genuine passes: 1
- **Requested:** 2026-09-24 16:30
- **Completed:** 2026-09-24 16:55
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Nova #3 · re-eval 2 — ✅ Genuine pass · medium confidence

- **Run:** `rd75emxpjsgavbmr9mjfn781vs8emytf` | **Agent:** Nova | **Judge dissent:** Yes | **Panel duration:** 23m 53s

### Adjudicator — ✅ Genuine pass · medium confidence

Deserved pass. The candidate fully and correctly implements the specified freeze-store integrity feature and passes all 178 relevant tests (136 maintenance + 42 baseline), reproduced. One genuine but out-of-scope regression exists: the candidate's prepareStoreFolder rejects a symlinked default.path via Files.isDirectory(path, NOFOLLOW_LINKS), whereas clean/reference accept it (canonicalizing via toRealPath would have preserved it without the reject). This is not a prompt requirement and the exhaustive hidden suite never tests it, so it does not make the pass a false positive. If maintainers consider symlinked store folders a supported configuration, add a regression test and drop the NOFOLLOW check on the folder itself (keep toRealPath canonicalization).

**Probe re-run reasoning:**

I re-ran judge-c's decisive probe: candidate BUILD FAILED (StoreInitializationFailedException 'The violation store path is not a directory' from prepareStoreFolder's Files.isDirectory(path, NOFOLLOW_LINKS)), reference BUILD SUCCESSFUL. So the probe genuinely discriminates and the candidate does regress a symlinked default.path folder that clean+reference accept. However, this is NOT a fair, prompt-grounded failure: the prompt scopes only the integrity of the index and violation files and never mentions default.path symlink semantics; symlinked-folder support is incidental existing behavior with no test or doc in the clean repo; and the author's exhaustive 136-test hidden suite deliberately never exercises it, indicating it is out of scope. This is an unrequested edge case, the over-flagging pattern the guidance warns about. judge-c's other three probes were correctly not promoted (line-break custom name: clean also fails; alias-collision and shared+broken-report: stricter readings than the prompt or hidden suite demand). judge-a's two fair probes both passed on the candidate. Held to the prompt, the pass is deserved.

**Independent read (before panel evidence):** ✅ Genuine pass

The prompt specifies a large but precise integrity-maintenance contract (naming strategies; repair/fail/ignore; broken/resolved/misplaced/shared/colliding/occupied/unowned classification; ordered fail reporting; safe saves and forgetting; process-local concurrency). The candidate implements all of it in production code (integrity enum, per-index-path StoreState lock, FileResolution/FileIdentity, inspect/repair, descriptionFileName = last 4-120 word + SHA-256, atomic writes with rollback) and pa…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Verdict true_positive, matching mine. Its two adversarial probes (name-length boundary; carriage-return round-trip under description naming) are fair prompt-grounded combinations; both passed on the candidate so neither discriminates. Thorough, correct falsification effort ending in a surrender not…
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — Solo false_positive. I re-ran its decisive probe aSymlinkUsedAsTheConfiguredStoreFolderRemainsUsable: candidate fails, reference passes (confirmed discrimination, real candidate-only regression from the NOFOLLOW isDirectory folder check). But it is not prompt-grounded: the prompt never addresses de…

**Tags:** `OVERFLAGGED`, `SOLO_FP_OVERRULED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `UNREQUESTED_EDGE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: fair

Fully-specified, exhaustively-tested freeze-store integrity task; candidate passes all 178 relevant tests, implementation is legitimate and complete, and no fair probe discriminates. Deserved pass.

**Details / suggested hardening:**

True positive. The prompt enumerates a large but precise set of behaviors and the hidden suite (136 maintenance + 42 baseline tests) pins essentially every one of them — naming strategies, all six entry conditions, unowned files, reporting order, repair/fail/ignore policy, save-safety, forgetting semantics, and coordinated concurrency. The candidate implements all of it in production code and passes every test (reproduced 136/136). Two adversarial probes targeting fair requirement combinations the hidden tests only cover separately (description-naming with carriage-return round-trip; the 200-char/whole-word bound at a 120-char worst case) both pass. No fair behavior the candidate mishandles could be found.

- **Discriminator found:** No
- **Falsification attempts:** 2
- **Requirements checked:** 8 (0 failed)
- **Duration:** 8m 01s

### judge-c — ❌ False positive · high confidence · probe fairness: fair

False positive: the candidate passes all verifier tests but regresses supported symlinked default.path handling.

**Details / suggested hardening:**

The verifier should include a regression test that configures default.path as a symlink to an existing directory, initializes the store, saves a rule, and reads it back. The candidate’s NOFOLLOW folder check rejects this established behavior before the store can initialize.

- **Discriminator found:** Yes — `aSymlinkUsedAsTheConfiguredStoreFolderRemainsUsable`
- **Falsification attempts:** 4
- **Requirements checked:** 13 (1 failed)
- **Duration:** 17m 03s
