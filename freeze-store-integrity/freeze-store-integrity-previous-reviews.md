# Previous Reviews

## v1 — Thorfinn . — revision_requested — 2026-09-15 20:14

Quality score: 3

Problem Description - (1/3) Weak
- P4 - Define occupancy without including an entry's own correct file: `meta.md:7` says an entry is occupied whenever its derived name already names something. For a healthy description-named entry, that name already denotes its own recorded file, so the literal rule conditions every healthy entry and makes `fail` reject a consistent store. Define occupied as an otherwise movable misplaced entry whose proposed destination is held by another object or entry, or escapes the folder, and explicitly exclude its own correctly recorded file.
- P4 - Complete the report-order contract: `meta.md:9` orders broken, resolved, shared, and unowned groups, but also requires reports to include misplaced and colliding entries and defines occupied entries. In a mixed report, those three groups can be placed differently while satisfying the stated partial order. Either give the complete condition order or state explicitly that the omitted groups may appear anywhere.
- P4 - Define the post-state of an unsafe-save rejection: `meta.md:11` says only that such a save is rejected. The pinned save lifecycle can persist a new rule mapping before attempting the file write, so an implementation can throw without overwriting the protected target yet leave a broken index entry. State that rejecting an unsafe target leaves that rule's mapping and every folder entry unchanged.

Tests - (1/3) Weak
- T3 - Reject transient index creation: `failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne()` at `FreezeStoreMaintenance_e448f3_Test.java:836-846` checks only final absence. Run `rd70ckjs8d3gejdk47xjty9kw98eep9a` creates `stored.rules`, deletes it after `fail` rejects, and still passes 125/125. Observe the directory across the call so any creation of the index fails, while retaining the report and final-state assertions.
- T3 - Enforce complete late-word retention: `aLongWordAfterOnlyShortOnesStillYieldsABoundedName()` at `FreezeStoreMaintenance_e448f3_Test.java:2145-2163` checks shape, length, and stability but never calls `assertKeepsAWordOf()`. The same raw pass truncates the sole 160-character word to 100 characters and passes. Add the existing full-word assertion to this case.
- T8 - Publish results only for the current invocation: `test.sh:50-69` clears Gradle's result directory but not the advertised `OUTPUT_PATH`. If that path contains a prior green report and the next compile or setup fails before producing internal XML, the command exits nonzero but leaves stale test identities and outcomes at the requested path. Clear or stage the destination before execution and publish only XML created by the current run.
- T4 - Include the maintained concurrent-save regression: `archunit/build.gradle:168-200` limits `base` to `TextFileBasedViolationStoreTest`, excluding `TextFileBasedViolationStoreConcurrencyTest.java:54-74`. A per-instance synchronized implementation can lose distinct concurrent saves while every selected test passes. Add that maintained class to the affected baseline suite, or run equivalent existing freeze-store regression coverage.
- T3 - Prove that `ignore` performs no examination: `aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore()` at `FreezeStoreMaintenance_e448f3_Test.java:1303-1317` wraps both `initialize()` and `save()` in one thrown assertion. An implementation that wrongly invokes the no-name strategy during `ignore` initialization therefore passes. Require initialization to succeed without invoking the strategy, then separately require the later save to fail when it first needs a name.
- T3 - Cover short normalization collisions: `twoRulesReadingAlikeStillGetDifferentNames()` at `FreezeStoreMaintenance_e448f3_Test.java:2108-2125` covers only a long common prefix. A strategy that adds a digest only after truncation passes while mapping short descriptions such as `service:rule` and `service/rule` to one sanitized name. Add a short normalization-equivalent pair and require distinct mappings, files, and independent violation round-trips.

Solution & Code - (1/3) Weak
- S1 - Forget a resolved rule without mutating its shared unsafe target: `TextFileBasedViolationStore.discard()` at `TextFileBasedViolationStore.java:213-227` checks ownership before checking whether another entry shares the file. When two entries record `../outside`, an empty save under `repair` rejects and retains the selected mapping, although it can safely remove that mapping while leaving the shared external target untouched. Check sharing before requiring ownership for deletion, remove only the resolved rule's entry in this branch, and tighten `forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside()` so it requires both the removal and target preservation instead of accepting rejection.

---

## v4 — Thorfinn . — revision_requested — 2026-09-17 04:39

Quality score: 4

Problem Description - (3/3) Clean

Tests - (1/3) Weak
- T3 - Strong tests: Restore physical index-alias protection: v4 removes the hard-link case, leaving `storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected()` (`test.patch:1964`) with dotted and symbolic aliases only. The sole 124/124 passer, `rd7b8kast4adx8z6615nsvez898ehn1g`, compares index path spellings and can overwrite `stored.rules` through a hard link recorded by an existing rule. Restore a hard-linked-index save test requiring rejection and unchanged index bytes.
- T3 - Strong tests: Preserve shared identity before filtering unsafe targets: `twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded()` and `forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside()` cover internal aliases and identical outside names separately. The passing candidate discards both mappings when `alpha=../outside.txt` and `beta=outside-link` reach the same existing outside file, because its safety check erases their shared identity. Add that differing-name case with an independent broken entry; repair must retain the shared mappings, target, and link while removing the broken control.
- T3 - Strong tests: Verify rollback when an unowned regular file blocks a save: `storingARuleNeverWritesOverAFileTheStoreDoesNotOwn()` (`test.patch:1766`) checks rejection and the existing file's bytes, but not the index. An implementation can insert the rejected rule's mapping first and still pass; a retry can then overwrite the formerly unowned file as its own. Compare the index before and after rejection, require the rule to remain unknown, and verify that retrying preserves the same state.
- T4 - Extensive coverage: Exercise shared precedence inside destructive collision and occupancy branches: `aSharedNameHoldingNoViolationsIsNotDiscardedEither()` (`test.patch:518`) exercises shared empty files without derived naming; the collision and occupancy cleanup fixtures use unshared entries. A repair implementation can handle collision/occupancy cleanup before checking sharing and pass those separate fixtures while deleting a shared empty file. Combine a shared resolved file with colliding and occupied derived-name variants, plus an independent repairable control, and require both shared mappings and their file to survive.
- T4 - Extensive coverage: Include maintained save-permission regressions: the baseline lists at `archunit/build.gradle:172-174,200-202` omit `FreezingArchRuleTest.can_prevent_default_ViolationStore_from_freezing_unknown_rules()` and `can_prevent_default_ViolationStore_from_updating_existing_rules()`. All authored `default.allowStoreUpdate=false` cases only initialize, so removing the ordinary save guard while retaining the repair-initialization guard passes. Run these maintained save-policy cases in `base` so both new and existing rules remain protected.
- T4 - Extensive coverage: Preserve ordinary violation text when adding CR-aware maintenance: the selected `stores_violations_with_line_breaks()` uses the platform line separator, which exercises only LF here. The 124/124 candidate changes `getViolations()` so a saved singleton containing `"left\rright"` becomes two violations; the existing store preserves the singleton. Add ordinary save/get regressions for embedded CR and CRLF, alongside the separate line-break-only integrity tests.
- T4 - Extensive coverage: Preserve the original description supplied to custom strategies: `aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName()` (`test.patch:1213`) uses plain descriptions. The passing candidate normalizes CRLF before calling the strategy, although the pinned save path passes `rule.getDescription()` unchanged; a strategy hashing that string then produces a different filename. Add a constructor-strategy regression that observes an original CRLF-bearing description and its resulting safe filename, while retaining normalized index-key behavior.
- T3 - Strong tests: Distinguish rules that differ only in case: `twoRulesReadingAlikeStillGetDifferentNames()` (`test.patch:2187`) checks a long shared prefix and colon/slash differences, but every pair remains distinct after case folding. Hashing a lowercased description can therefore pass while mapping `ServiceRule` and `serviceRule` to one name, even though the index treats them as different rules. Add a case-only pair and verify distinct filenames and independent violation round-trips.
- T4 - Extensive coverage: Exercise the lower word boundary and digits: `assertKeepsAWordOf()` (`test.patch:2569`) recognizes digits, but its fixtures always offer an alphabetic word of at least five characters. An implementation accepting letters only or starting eligibility at five can still pass while losing the only eligible word in a description such as `1234`. Add a case whose sole qualifying word is four digits and apply the whole-word assertion.

Solution & Code - (1/3) Weak
- S2 - No regressions: Coordinate saves with repair initialization: `TextFileBasedViolationStore.java:297-306` persists a new mapping before `save()` writes the violations file at lines 211-212. Another store instance repairing the same folder can classify that unfinished save as broken and remove its mapping; the first save then returns successfully with an orphaned file. This is reachable through the maintained parallel `FreezingArchRule.evaluate()` lifecycle. Coordinate the complete save operation with maintenance for that folder, and add a controlled interleaving regression that preserves the saved mapping and readable violations.
- S1 - Meets requirements: Keep a rule recorded when its file cannot be deleted: `TextFileBasedViolationStore.java:225-232` logs a failed deletion, removes the mapping anyway, and returns success. For a traversable directory without write permission but an existing writable index, unlink fails while rewriting the index succeeds, leaving the violations file unowned. Preserve the mapping and report update failure when unshared-file removal fails; cover a verified deletion failure under an identity that actually lacks unlink permission.
- S1 - Meets requirements: Classify invalid recorded paths without aborting maintenance: `StoreIntegrity.java:257-263` catches an invalid path and returns a `File` with the same invalid name, but identity comparison at lines 230-234 calls `toPath()` again and catches only `IOException`. A readable Properties index containing `alpha=bad\u0000name` and `beta=healthy` consequently throws `InvalidPathException` before repair can discard the invalid mapping. Keep such names classifiable as broken throughout the scan, and test an invalid recorded filename beside a healthy entry for both repair and fail reporting.

---

## v5 — Thorfinn . — revision_requested — 2026-09-19 18:34

Quality score: 4

Problem Description - (3/3) Clean

Tests - (1/3) Weak
- T5 - Specified behavior: `oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind` (`test.patch:953`) requires an empty final index even though the two saves overlap. A valid implementation can prepare the earlier save's payload before taking its transaction lock, let the empty save commit first, and then commit the nonempty save, while preventing initialization from observing unfinished writes. Accept either consistent serialization, or complete the first save before starting the deletion; the description does not require invocation-order commits.

- T7 - Avoid over-pinning output: The `.contains("controllers")` assertions at `test.patch:2714` and `2734` reject an uppercase whole word such as `CONTROLLERS` with a distinct suffix, although the naming contract permits it. Remove those case-sensitive assertions or make them case-insensitive, retaining the existing whole-word, length, and distinctness checks.

- T3 - Strong tests: `carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved` (`test.patch:505`) checks nonempty violations only through payloads written by the candidate itself. The current passing candidate introduces a backslash-CR encoding that silently removes a literal backslash when reading a pre-existing file containing `left` + backslash + CR + `right` + LF. Seed bytes from the pinned store format independently and verify their exact contents survive both reading and repair.

- T3 - Strong tests: Still open from the prior round: the constructor-strategy tests at `test.patch:1530` never check the original callback argument. The current passing candidate changes `"first\r\nsecond"` to `"first\nsecond"` before invoking the strategy, unlike the pinned implementation. Add a first-save regression that records the exact CRLF-bearing argument and checks the independently expected safe filename; the index key may retain its existing normalization.

- T3 - Strong tests: All configured store roots use ordinary directories (`test.patch:2931`), so the current passing candidate can reject a `default.path` that is a symbolic link to a legitimate store directory. This configuration works at the pinned base, including in default `ignore` mode. Cover initialization, reading, and saving through a linked store directory; this is distinct from rejecting a symlink used as the index itself.

- T3 - Strong tests: `aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing` (`test.patch:1554`) supplies the setting directly. The current passing candidate checks `Properties.containsKey`, so it accepts the prohibited combination when `default.fileNames` is inherited through `new Properties(defaults)`, despite `getProperty` resolving it. Exercise that effective configuration through the public `initialize(Properties)` API as well.

- T3 - Strong tests: `aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore` (`test.patch:1708`) checks directory names and existing violation content, but never the index or the rejecting store's membership. A save can persist an empty filename mapping and then throw without changing either checked value. Check unchanged index bytes and absence of the rejected rule through the same instance after each rejected save.

- T3 - Strong tests: `ForgettingProbe.forget` (`test.patch:3356`) returns `"rejected"` on an exception without inspecting that store again. Removing cached membership before a failed unlink can therefore pass the disk assertions, and the later fresh initialization hides the damage. Before returning from the probe, require the same instance to contain the rule and return its original violations.

- T4 - Extensive coverage: Empty saves cover an ordinary uniquely owned file and a shared link (`test.patch:2383` and `2449`), but not a uniquely owned internal link. A separate empty-save implementation can delete only the link and leave its owned target behind while passing these cases and the initialization tests. Add a known-rule case asserting that the mapping, link, and target all disappear, keeping the existing shared-file control.

- T3 - Strong tests: `failNamesTheConditionsInTheStatedOrder` (`test.patch:1277`) uses representative names already ordered alphabetically as broken, resolved, shared, and unowned. Sorting every finding globally by name passes this and the separate within-condition checks without implementing the required condition priority. Use names whose lexical order conflicts with the required groups and assert the cross-group ordering.

- T3 - Strong tests: The no-rewrite cases at `test.patch:2855`, `2876`, and `2898` compare bytes only. Unconditionally writing the same original bytes back passes all three, but violates the no-write requirement and can fail on an otherwise valid read-only index. Add an independent write observation, such as a deliberately old modification timestamp with an actual-change control.

- T8 - Preserve failure diagnostics: The report merge at `test.patch:3531` concatenates any existing XML files without parsing them, then publishes the result. A native report truncated by an interrupted child remains present, bypasses the no-report fallback, and produces unreadable JUnit; atomic publication does not repair malformed XML. Validate native and merged reports before publication, disable external XML resolution, and report malformed output as an actual infrastructure failure while preserving available native failures.

Solution & Code - (1/3) Weak
- S2 - No regressions: `reloadFromFileSystem` (`solution.patch:988`) clears and repopulates the shared map in separate operations, while `containsKey` and `getProperty` do not take its outer lock. A concurrent `FreezingArchRule.evaluate` can observe an existing rule as absent, enter its initial-freeze branch, and accept newly introduced violations. Publish refreshed state atomically to readers or coordinate their access, and cover the maintained consumer's behavior.

- S1 - Meet the requirements: `FileSyncedProperties.apply` (`solution.patch:1015`) normalizes keys returned verbatim by the index reader. With valid Properties records `broken\r\nrule=missing` and `broken\nrule=healthy`, repair classifies the CRLF-keyed record as broken but removes the LF-keyed healthy record instead, leaving the broken entry and orphaning the healthy file. Apply repairs to the exact examined keys without conflating them with normalized lookup keys, and cover both entries together.

- S1 - Meet the requirements: `rejectBeforeCreating` (`solution.patch:342`) still examines an absent index outside the shared synchronization. After it observes absence, another store can create the index and save a rule; the first initializer then scans against an empty map and wrongly reports the owned file as unowned. Coordinate the absence check and pre-creation examination with initialization and saving under the same store identity, while preserving no index creation on rejection.

- S1 - Meet the requirements: `StoreIntegrity.repair` (`solution.patch:594`) silently skips a required deletion or move when the filesystem operation returns false. Initialization then succeeds with the resolved or misplaced entry unchanged, although repair promises to discard or move it. Surface unsuccessful required operations while keeping mappings consistent with the operations actually completed; no particular exception text or rollback of unrelated completed repairs is required.

---

## v12 — tg 1239 — revision_requested — 2026-09-26 00:49

Quality score: 4

Problem Description - (2/3) Minor
P4: The description is overly specification-like. More importantly, it says every description-derived filename keeps a whole 4–120-character alphanumeric word, while the required punctuation-only and non-ASCII cases may contain no eligible word. Qualify this requirement as applying when such a word exists.

Tests - (1/3) Weak
T3/T4 — The only passing agent is a false positive:
- It normalizes CRLF descriptions before invoking the user-provided filename strategy, changing the public callback input.
- It uses direct Properties.containsKey handling, so configuration inherited through Properties.defaults can bypass the constructor/config conflict.
- It rejects a symlinked store directory that the existing store accepts.
Add direct regression tests for all three behaviors.
T5 — The concurrent save/forget test over-prescribes the winner. It requires a forget invocation started second to win even when the first save already owns the transaction lock. The contract requires a consistent serialization, not invocation-order precedence. Accept either complete serialized result or specify the required precedence publicly.
T3/T4 — Additional coverage gaps remain:
- The integrity-report ordering test uses condition names already in lexical order, so a global-sort implementation passes.
- The empty-name strategy rollback test does not verify that stored.rules and cached membership remain unchanged.
- Failed file deletion is not checked against the same live store instance.
- Empty-save cleanup lacks the unique internal-symlink case.
- “Do not rewrite an unchanged index” is tested only by comparing bytes, which cannot detect an identical rewrite.
- Custom strategy input is not tested with CRLF descriptions.
- The harness concatenates native XML without validating it first, allowing a truncated report to produce malformed advertised JUnit.
T1/T6: Trim the long test narration and section-divider commentary.

Solution & Code - (1/3) Weak
S1/S2 — The reference implementation has four unresolved correctness defects:
- reloadFromFileSystem() performs clear() followed by putAll() while readers are not synchronized on the same monitor. A concurrent evaluation can observe a temporarily empty store and incorrectly refreeze a known rule.
- Repair normalizes discard keys before removal. Distinct LF and CRLF keys can therefore cause the healthy mapping to be removed while the broken entry remains.
- The absent-index fail-policy scan occurs outside the per-path transaction lock. It can inspect files created by a concurrent save before that save publishes its index entry and reject them as unowned.
- Repair silently continues when a required delete or move returns failure, allowing initialization to succeed without completing the requested repair.
S4: Reduce the comment-heavy implementation narration to short explanations of genuinely non-obvious invariants.

Other notes:

Fix all the issues in this revision
