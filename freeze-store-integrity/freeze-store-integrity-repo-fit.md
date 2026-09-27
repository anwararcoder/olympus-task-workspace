# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · med confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-09-18 17:52
- **Investigation:** 74 gh calls · 42 gh searches · 1 upstream requests · 1058.29s

Pass. All eight older candidates are distinct at 0/752 discounted subject lines, and their set supplies no freeze-store core. Three verified public artifacts cover at most 31 of 136 graded tests; the remaining 105 tests and the hardest integrity, ownership, link, reporting, naming, and synchronization machinery remain uncovered. Upstream history shows no complete implementation or removal, and maintainers explicitly supported freeze-store sanity checking.

## Reasoning

Category 1 — corpus overlap and set union: I adopt all eight current `distinct` rulings. The subject has 822 non-blank solution lines. The worksheet discounts 25 generated HTML lines, 30 lines for the second and third stamped Java license headers, and 15 pre-existing license-header lines, yielding a divisor of 752. Every comparison has summed N=0, so each is 0/752=0%: `[another submission]` (candidate divisor 611), `[another submission]` (1614), `[another submission]` (371), `[another submission]` (1080), `[another submission]` (565), `[another submission]` (386), `[another submission]` (792), and `[another submission]` (335). Those integers correctly map to the clear-minority band. Their shared-core file sets and recurring-block sets are empty, and no shape is asserted, so the set also covers 0/752 (0%): none supplies a major freeze-store block that could participate in stitching or a stamped kit.

Category 2 — upstream/public code: I verified the prior public-code claims against the current hidden patch and the source at each public ref. The current maintenance class contains 136 graded `@Test` functions, not 135; the prior count omitted the final `repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder` test. The public slices remain 31 tests, so the corrected aggregate is 31/136 (22.8%), leaving 105/136 (77.2%).

At PR #1407 (https://github.com/TNG/ArchUnit/pull/1407), I read `archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java` at head `b0631bc58a5db6bf4069278e22e7e689bfacd9d4`, specifically `removeObsoleteRules`. After mechanical repair/ignore wiring, its marginal operation—filtering indexed rules whose recorded path does not exist and removing those properties—contributes to at most these 21/136 tests: `absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry`, `ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry`, `repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne`, `anEntryWhoseFileIsAbsentIsBroken`, `everyBrokenEntryIsDiscarded`, `anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken`, `anEntryNamingALinkToAFileInTheStoreOwnsThatFile`, `aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget`, `anEntryNamingADanglingLinkIsBroken`, `aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded`, `twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded`, `anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded`, `aSecondInitializationOfARepairedFolderDiscardsNothing`, `aSeparatelyCreatedStoreObservesTheRepairedIndex`, `repairWithoutPermissionToUpdateIsRejectedAndChangesNothing`, `repairKeepsAStillViolatingRuleFrozenWithItsViolations`, `randomFileNamesDeriveNothingSoNoEntryIsMisplaced`, `absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone`, `aStillViolatedRuleKeepsItsEntryUnderRepair`, `aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical`, and `arepairThatChangesNothingLeavesTheIndexByteIdentical`. I do not credit its `removeObsoleteRuleFiles`: that routine deletes every unreferenced directory entry and does not provide the direct-regular-file, ownership, and file-identity behavior needed by this task.

At PR #1405 (https://github.com/TNG/ArchUnit/pull/1405), I read the same path at head `4952aae7799e1f08e5b1877dfc1e0395f29a4b3d`, specifically the empty-save branch and `deleteRuleFile`. After mechanical mapping to repair mode, deletion-before-index-removal supplies at most 4/136 tests: `storingNoViolationsUnderRepairForgetsTheEntryAndItsFile`, `onlyRepairForgetsAResolvedRuleWhileFailKeepsIt`, `forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry`, and `forgettingARuleTheIndexNeverKnewStoresNothingForIt`. It supplies no shared-file, unsafe-path, or save-wide synchronization mechanism.

Issue #1045's comment (https://github.com/TNG/ArchUnit/issues/1045#issuecomment-1402273844) contains complete working code and tests for `DeterministicTextFileBasedViolationStore.newRuleFileName`. Moving that string algorithm into the strategy interface already present at the pin and dropping its fixed `.txt` suffix are mechanical adaptations. It contributes at most 6/136 tests: sanitization/recognizability in `namesTakenFromTheDescriptionShowTheRuleTheyStore`; description-only determinism in `aRuleKeepsTheSameNameInALaterRun`; machine-independent derivation in `aRuleKeepsTheSameNameOnAnotherMachine`; independence from folder contents in `aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds`; preservation of the leading suitable word in `aWordWorthKeepingSurvivesAnOverlongWordAfterIt`; and deterministic readback in `violationsAreReadBackFromANameTakenFromTheDescription`. Its algorithm does not satisfy collision resistance, empty/non-ASCII descriptions, late suitable words, index-name avoidance, or relocation.

These public slices are disjoint and total 21+4+6=31 of 136. The larger and harder remainder includes filesystem-identity classification; direct-file and path-escape validation; resolved/shared/misplaced/colliding/occupied precedence; ordered non-mutating failure reports; safe link-target movement/deletion; comprehensive save ownership checks; robust whole-word, collision-resistant naming; and synchronization spanning examination and saves. PR #1656 contributes no marginal public slice because its shared-map/atomic-save behavior is already present at the pinned commit.

The touched-path and noun searches found no complete public implementation or removed predecessor. The three solution-created source paths (`StoreIntegrity.java`, `RuleDescriptionFileNames.java`, and `RuleViolationFileNameStrategyFactory.java`) have no commit history on upstream's default branch. History for `TextFileBasedViolationStore.java` shows the already-pinned naming extension, newline handling, and thread-safety work, but no integrity engine. Searches across open and closed PRs/issues for violation-store, freeze-store, `stored.rules`, integrity, sanity-check, obsolete-frozen, file-name, and empty-violation concepts surfaced the three partial artifacts above and issue #1264, not a complete implementation. Global code, PR, issue, and commit searches for the distinctive APIs likewise found no additional working source.

Category 3 — repository alignment: the task is aligned. The pinned user guide describes the plain-text `ViolationStore`, its version-controlled use, and configurable creation/update behavior. More decisively, on issue #1264 (https://github.com/TNG/ArchUnit/issues/1264#issuecomment-2466680707), a collaborator called freeze-store sanity checking “a nice addition” and said they would support it. This is neither a capability rejection nor a repo-goal contradiction.

Accordingly, the task remains exclusive enough to exist: corpus coverage is 0/752, public code covers only 31/136 graded tests and not the hardest machinery, and there is no removal, decline, or off-scope conflict.

## Findings (11)

### overlap — Low severity

- **Claim:** distinct — `[another submission]`; summed N is 0 of 752 discounted subject solution lines (0%).
- **Why it matters:** The candidate implements a different engine in another repository and contributes no freeze-store core.

### overlap — Low severity

- **Claim:** distinct — `[another submission]`; summed N is 0 of 752 discounted subject solution lines (0%).
- **Why it matters:** The candidate's transaction machinery does not map to an authored construct in this filesystem store implementation.

### overlap — Low severity

- **Claim:** distinct — `[another submission]`; summed N is 0 of 752 discounted subject solution lines (0%).
- **Why it matters:** Generic integrity vocabulary does not correspond to shared authored implementation.

### overlap — Low severity

- **Claim:** distinct — `[another submission]`; summed N is 0 of 752 discounted subject solution lines (0%).
- **Why it matters:** The candidate's database manifest and recovery validation are not a part-source for this task.

### overlap — Low severity

- **Claim:** distinct — `[another submission]`; summed N is 0 of 752 discounted subject solution lines (0%).
- **Why it matters:** Despite sharing the repository, it changes bytecode-import normalization rather than freeze-store behavior.

### overlap — Low severity

- **Claim:** distinct — `[another submission]`; summed N is 0 of 752 discounted subject solution lines (0%).
- **Why it matters:** Its source-map importer work shares no freeze-store construct.

### overlap — Low severity

- **Claim:** distinct — `[another submission]`; summed N is 0 of 752 discounted subject solution lines (0%).
- **Why it matters:** Its JPMS import and graph model share no freeze-store construct.

### overlap — Low severity

- **Claim:** distinct — `[another submission]`; summed N is 0 of 752 discounted subject solution lines (0%).
- **Why it matters:** Its record-component domain/import work shares no freeze-store construct.

### publicly-solved — Medium severity

- **Claim:** Partial public coverage — open PR #1407 implements a narrow missing-recorded-path cleanup primitive, contributing to at most 21 of 136 graded tests: https://github.com/TNG/ArchUnit/pull/1407
- **Evidence:** ".filter(ruleDescription -> !new File(storeFolder, storedRules.getProperty(ruleDescription)).exists())"
- **Why it matters:** This is real cribbable code, but it neither classifies the other integrity conditions nor safely handles unowned files, links, path escapes, reporting, naming, or concurrency.

### publicly-solved — Medium severity

- **Claim:** Partial public coverage — open PR #1405 implements optional empty-save deletion for known rules and non-creation for unknown rules, contributing to at most 4 of 136 graded tests: https://github.com/TNG/ArchUnit/pull/1405
- **Evidence:** "if (violations.isEmpty() && deleteEmptyRule) {"
- **Why it matters:** The deletion ordering is reusable, but it does not implement shared-file preservation, unsafe-path checks, integrity classification, or cross-save synchronization.

### publicly-solved — Medium severity

- **Claim:** Partial public coverage — issue #1045's public comment contains working basic deterministic human-readable naming code, contributing to at most 6 of 136 graded tests after mechanical strategy-interface adaptation: https://github.com/TNG/ArchUnit/issues/1045#issuecomment-1402273844
- **Evidence:** "String s = description.replace(' ', '_').replaceAll("[^a-zA-Z0-9_-]", "");"
- **Why it matters:** The algorithm provides a small naming precursor but not the task's collision resistance, edge-case guarantees, or integrity relocation engine.

## Investigation Log (78 commands)

**#0** · core · ok · 490 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java`
→ `[]`

**#1** · core · ok · 531 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleDescriptionFileNames.java`
→ `[]`

**#2** · core · ok · 561 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleViolationFileNameStrategyFactory.java`
→ `[]`

**#3** · core · ok · 588 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java`

```
[{"sha":"48f6118f0f5b64d4174c0b51d68dbf117708a103","node_id":"C_kwDOBU1z-toAKDQ4ZjYxMThmMGY1YjY0ZDQxNzRjMGI1MWQ2OGRiZjExNzcwOGExMDM","commit":{"author":{"name":"Niklas Keller","email":"niklas@chrono24.com","date":"2026-07-21T13:27:16Z"},"committer":{"name":"Stefan Gräber","email":"101173483+StefanGraeber@users.noreply.github.com","date":"2026-07-23T07:06:08Z"},"message":"Make TextFileBasedViolationStore thread-safe under parallel test execution\n\nMultiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore\nand load stored.rules into their own private snapshot. Concurrent saves caused a\nlost-update: the last writer overwrote the file with only its own entries.\n\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a\nstatic ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that\natomically checks, sets, and flushes to disk under one lock.\n\n- Move directory creation into FileSyncedProperties.initializePropertiesFile\n- Use mkdirs() || isDirectory() to handle the race where a concurrent process\n  creates the directory between mkdirs() returning false and the isDirectory check\n- Add TextFileBasedViolationStoreConcurrencyTest with separate initialize-race and\n  save-race scenarios\n- Convert both test classes from JUnit 4 to JUnit 5\n\nCo-Authored-By: <model> <noreply@<provider>.com>\nSigned-off-by: Niklas Keller <niklas@chrono24.com>","tree":{"sha":"02bd7350d33864278294d81ef99cdfe98d5a34f3","url":
```

**#4** · search · ok · 804 ms — `gh search issues "deterministic freeze" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`
→ `[]`

**#5** · core · ok · 916 ms — `gh pr view 1405 --repo TNG/ArchUnit --json number,title,state,isDraft,url,headRefOid,baseRefName,body,comments,reviews,commits,files`

```
{"baseRefName":"main","body":"These changes introduce two new features for FreezingRule default store\r\n* Raise error when a freezing rule has zero violations. This can be enabled by setting the property `default.warnEmptyRuleViolation=true`. For backward compatibility it is disabled by default.\r\n* Skip rule violation file creation or delete if it already exists, when there are zero violations. This can be enabled by setting the property `default.deleteEmptyRuleViolation=true`, it is disabled by default.\r\n\r\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\r\n\r\nResolves #1264","comments":[],"commits":[{"authoredDate":"2025-01-18T22:53:14Z","authors":[{"email":"masoud.kiaeeha@gmail.com","id":"MDQ6VXNlcjY5MTY0MzQ=","login":"maxxkia","name":"maxxkia"}],"committedDate":"2025-01-30T22:07:10Z","messageBody":"These changes introduce two new features for FreezingRule default store\n* Raise error when a freezing rule has zero violations. This can be enabled by setting the property `default.warnEmptyRuleViolation=true`. For backward compatibility it is disabled by default.\n* Skip rule violation file creation or delete if it already exists, when there are zero violations. This can be enabled by setting the property `default.deleteEmptyRuleViolation=true`, it is disabled by default.\n\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\n\nResolves #1264","messageHeadline":"raise error for empty violation store and delete empty rule f
```

**#6** · search · ok · 1054 ms — `gh search issues "violation store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2021-12-26T23:31:04Z","number":749,"state":"open","title":"Change Request: ViolationStore-API should give access to structured violation data","updatedAt":"2022-01-03T06:47:16Z","url":"https://github.com/TNG/ArchUnit/issues/749"},{"createdAt":"2021-05-11T03:06:08Z","number":597,"state":"open","title":"ArchUnit Trends","updatedAt":"2021-05-11T13:45:42Z","url":"https://github.com/TNG/ArchUnit/issues/597"},{"createdAt":"2021-09-23T03:35:49Z","number":676,"state":"open","title":"FreezingArchRule: No longer violating a rule should under no circumstances break the test","updatedAt":"2021-12-01T16:36:08Z","url":"https://github.com/TNG/ArchUnit/issues/676"},{"createdAt":"2021-12-27T00:17:29Z","number":751,"state":"open","title":"FeatureRequest: Possibility to define IDs for Rules","updatedAt":"2022-07-17T13:55:15Z","url":"https://github.com/TNG/ArchUnit/issues/751"},{"createdAt":"2022-12-16T14:27:24Z","number":1026,"state":"closed","title":"[suggestion] sort violations in guid files alphabetically","updatedAt":"2023-01-20T06:58:06Z","url":"https://github.com/TNG/ArchUnit/issues/1026"},{"createdAt":"2022-12-16T09:55:55Z","number":1025,"state":"closed","title":"[suggestion] add test name to frozen violation guid files","updatedAt":"2023-01-20T06:59:03Z","url":"https://github.com/TNG/ArchUnit/issues/1025"},{"createdAt":"2022-07-04T13:29:35Z","number":902,"state":"closed","title":"Specify file name for freeze?","updatedAt":"2022-07-07T08:55:04Z","url":"https://github.com/T
```

**#7** · search · ok · 1083 ms — `gh search prs "violation store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2025-01-18T22:54:07Z","number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","updatedAt":"2026-07-06T12:26:23Z","url":"https://github.com/TNG/ArchUnit/pull/1405"},{"createdAt":"2023-03-02T20:42:57Z","number":1075,"state":"merged","title":"Ensure final newline in violation store files","updatedAt":"2023-07-04T08:32:15Z","url":"https://github.com/TNG/ArchUnit/pull/1075"},{"createdAt":"2021-01-23T17:48:15Z","number":516,"state":"merged","title":"fix line ending problems in FreezingArchRule","updatedAt":"2021-01-27T21:52:35Z","url":"https://github.com/TNG/ArchUnit/pull/516"},{"createdAt":"2019-10-20T15:29:17Z","number":252,"state":"merged","title":"Enhance FreezingArchRule","updatedAt":"2019-10-24T17:49:36Z","url":"https://github.com/TNG/ArchUnit/pull/252"}]
```

**#8** · search · ok · 1097 ms — `gh search issues "freeze store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2026-08-13T08:06:28Z","number":1700,"state":"open","title":"Surfacing freeze store size as a signal: a green build is compatible with a growing store","updatedAt":"2026-08-13T08:06:28Z","url":"https://github.com/TNG/ArchUnit/issues/1700"},{"createdAt":"2025-07-25T14:17:50Z","number":1494,"state":"open","title":"Bad Frozen error messages","updatedAt":"2025-07-25T14:17:50Z","url":"https://github.com/TNG/ArchUnit/issues/1494"},{"createdAt":"2022-12-02T08:27:24Z","number":1015,"state":"open","title":"Do not include line numbers in freezed messages","updatedAt":"2022-12-26T11:46:05Z","url":"https://github.com/TNG/ArchUnit/issues/1015"},{"createdAt":"2021-09-23T03:35:49Z","number":676,"state":"open","title":"FreezingArchRule: No longer violating a rule should under no circumstances break the test","updatedAt":"2021-12-01T16:36:08Z","url":"https://github.com/TNG/ArchUnit/issues/676"},{"createdAt":"2023-06-20T09:00:06Z","number":1124,"state":"closed","title":"ArchUnit generates different set of violations rules depending on java bytecode version","updatedAt":"2026-08-14T19:15:21Z","url":"https://github.com/TNG/ArchUnit/issues/1124"},{"createdAt":"2021-01-12T12:35:42Z","number":510,"state":"closed","title":"Frozen rules not updated when new violation occurs","updatedAt":"2021-05-30T06:49:23Z","url":"https://github.com/TNG/ArchUnit/issues/510"},{"createdAt":"2021-01-12T11:51:56Z","number":508,"state":"closed","title":"Use of System.lineSeparator() prevents development on
```

**#9** · search · ok · 1101 ms — `gh search prs "stored.rules" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2025-01-19T14:52:15Z","number":1407,"state":"open","title":"cleanup obsolete frozen rules","updatedAt":"2026-07-06T12:26:23Z","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"createdAt":"2026-07-06T12:40:17Z","number":1656,"state":"merged","title":"Make TextFileBasedViolationStore thread-safe under parallel test execution","updatedAt":"2026-08-13T08:48:55Z","url":"https://github.com/TNG/ArchUnit/pull/1656"},{"createdAt":"2022-02-15T19:48:19Z","number":795,"state":"closed","title":"we ensure that the `stored.rules`-file is sorted alphabetically","updatedAt":"2022-06-08T13:09:23Z","url":"https://github.com/TNG/ArchUnit/pull/795"},{"createdAt":"2020-09-27T19:29:01Z","number":438,"state":"merged","title":"Run tests against Java 15 during CI","updatedAt":"2021-01-25T08:56:11Z","url":"https://github.com/TNG/ArchUnit/pull/438"},{"createdAt":"2019-06-15T08:49:51Z","number":181,"state":"merged","title":"Provide a way to store all current violations of a rule and successively only report new ones","updatedAt":"2019-07-06T19:08:06Z","url":"https://github.com/TNG/ArchUnit/pull/181"}]
```

**#10** · search · ok · 1134 ms — `gh search prs "freeze store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2023-01-20T10:54:41Z","number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","updatedAt":"2023-02-06T18:07:18Z","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"createdAt":"2020-09-27T19:29:01Z","number":438,"state":"merged","title":"Run tests against Java 15 during CI","updatedAt":"2021-01-25T08:56:11Z","url":"https://github.com/TNG/ArchUnit/pull/438"}]
```

**#11** · search · ok · 1187 ms — `gh search issues "stored.rules" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-03-12T16:03:48Z","number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","updatedAt":"2025-08-11T12:40:51Z","url":"https://github.com/TNG/ArchUnit/issues/1264"},{"createdAt":"2026-07-06T12:11:58Z","number":1654,"state":"closed","title":"`TextFileBasedViolationStore` is not thread-safe under parallel test execution","updatedAt":"2026-07-31T11:05:58Z","url":"https://github.com/TNG/ArchUnit/issues/1654"},{"createdAt":"2022-12-16T09:55:55Z","number":1025,"state":"closed","title":"[suggestion] add test name to frozen violation guid files","updatedAt":"2023-01-20T06:59:03Z","url":"https://github.com/TNG/ArchUnit/issues/1025"},{"createdAt":"2022-12-16T14:27:24Z","number":1026,"state":"closed","title":"[suggestion] sort violations in guid files alphabetically","updatedAt":"2023-01-20T06:58:06Z","url":"https://github.com/TNG/ArchUnit/issues/1026"},{"createdAt":"2022-07-04T13:29:35Z","number":902,"state":"closed","title":"Specify file name for freeze?","updatedAt":"2022-07-07T08:55:04Z","url":"https://github.com/TNG/ArchUnit/issues/902"},{"createdAt":"2021-01-12T12:35:42Z","number":510,"state":"closed","title":"Frozen rules not updated when new violation occurs","updatedAt":"2021-05-30T06:49:23Z","url":"https://github.com/TNG/ArchUnit/issues/510"}]
```

**#12** · search · ok · 1318 ms — `gh search prs "deterministic freeze" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`
→ `[]`

**#13** · core · ok · 1545 ms — `gh pr view 1407 --repo TNG/ArchUnit --json number,title,state,isDraft,url,headRefOid,baseRefName,body,comments,reviews,commits,files`

```
{"baseRefName":"main","body":"These changes bring 2 features\r\n* clean up of frozen rules in `stored.rules` where the corresponding file does not exist in the store directory\r\n* clean up of files in store directory which are not referenced in `stored.rules` file\r\nBoth of the above operations are enabled using `default.allowStoreUpdate` property. If `default.allowStoreUpdate=false` and obsolete entries or files are found by either of the above operations, the operation fails with an `StoreUpdateFailedException`.\r\n\r\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\r\n\r\nResolves #1264","comments":[],"commits":[{"authoredDate":"2025-01-19T14:51:37Z","authors":[{"email":"6916434+maxxkia@users.noreply.github.com","id":"MDQ6VXNlcjY5MTY0MzQ=","login":"maxxkia","name":"Masoud Kiaeeha"}],"committedDate":"2025-01-30T21:48:33Z","messageBody":"* clean up of frozen rules in `stored.rules` where the corresponding file does not exist in the store directory\n* clean up of files in store directory which are not referenced in `stored.rules` file\nBoth of the above operations are enabled using `default.allowStoreUpdate` property. If `default.allowStoreUpdate=false` and obsolete entries or files are found by either of the above operations, the operation fails with an `StoreUpdateFailedException`.\n\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\n\nResolves #1264","messageHeadline":"These changes bring 2 features","oid":"b0631bc58a5db6b
```

**#14** · core · ok · 1651 ms — `gh issue view 1045 --repo TNG/ArchUnit --comments`

```
author:	danhaywood
association:	contributor
edited:	false
status:	none
--
On closer inspection, I see that the code in question is in `TextFileBasedViolationStore`, so perhaps this is already pluggable.  Will dig a bit deeper.
--
author:	danhaywood
association:	contributor
edited:	false
status:	none
--
I've raised a PR https://github.com/TNG/ArchUnit/pull/1046 for your consideration.
--
author:	danhaywood
association:	contributor
edited:	false
status:	none
--
In the meantime, I've copied out the `TextFileBasedViolationStore` from the associated PR TNG#1046, and I've created my subclass to create deterministic file names:

```
import java.util.ArrayList;
import java.util.List;

import com.tngtech.archunit.thirdparty.com.google.common.base.Joiner;
import com.tngtech.archunit.thirdparty.com.google.common.base.Splitter;

public class DeterministicTextFileBasedViolationStore extends TextFileBasedViolationStore {

    // 100 (directory) + 155 + 4 (extension) = 259  ... Windows has max limit of 260 chars.
    public static final int MAX_LENGTH = 155;

    protected String newRuleFileName(String description) {
        String s = description.replace(' ', '_').replaceAll("[^a-zA-Z0-9_-]", "");
        if(s.length() > MAX_LENGTH) {
            List<String> parts = new ArrayList<>(Splitter.on("_").splitToList(s));
            String candidate = Joiner.on("_").join(parts);
            int partToTruncate = parts.size() - 1;
            while( candidate.length() > MAX_LENGTH) {
```

**#15** · core · ok · 553 ms — `gh api /repos/TNG/ArchUnit/commits/ab6a677dd4b678f0ab1d9481df17222916705170 --jq '{sha:.sha,date:.commit.committer.date,message:.commit.message,parents:[.parents[].sha]}'`

```
{"date":"2026-08-20T09:31:04Z","message":"Bump com.diffplug.spotless from 8.9.0 to 8.10.0\n\nBumps com.diffplug.spotless from 8.9.0 to 8.10.0.\n\n---\nupdated-dependencies:\n- dependency-name: com.diffplug.spotless\n  dependency-version: 8.10.0\n  dependency-type: direct:production\n  update-type: version-update:semver-minor\n...\n\nSigned-off-by: dependabot[bot] \u003csupport@github.com\u003e","parents":["cef095bbede8c46851661edc6d013059e719859e"],"sha":"ab6a677dd4b678f0ab1d9481df17222916705170"}
```

**#16** · search · ok · 898 ms — `gh search prs "obsolete frozen" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2025-01-19T14:52:15Z","number":1407,"state":"open","title":"cleanup obsolete frozen rules","updatedAt":"2026-07-06T12:26:23Z","url":"https://github.com/TNG/ArchUnit/pull/1407"}]
```

**#17** · search · ok · 937 ms — `gh search issues "obsolete frozen" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`
→ `[]`

**#18** · search · ok · 986 ms — `gh search issues "integrity" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`
→ `[]`

**#19** · search · ok · 1052 ms — `gh search issues "file names" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2023-01-20T07:11:06Z","number":1045,"state":"open","title":"[suggestion] Allow the mechanism for creating a file name for frozen violations to be specified via an SPI or similar.","updatedAt":"2023-01-24T16:57:16Z","url":"https://github.com/TNG/ArchUnit/issues/1045"},{"createdAt":"2026-05-19T08:25:59Z","number":1623,"state":"open","title":"Use source information from classfile attributes (when available) and expose path","updatedAt":"2026-05-20T11:35:11Z","url":"https://github.com/TNG/ArchUnit/issues/1623"},{"createdAt":"2021-07-20T21:26:24Z","number":641,"state":"open","title":"Add ability to execute a subset of rules from the via system properties","updatedAt":"2022-06-23T17:11:26Z","url":"https://github.com/TNG/ArchUnit/issues/641"},{"createdAt":"2020-10-10T19:36:34Z","number":452,"state":"closed","title":"Rules shared between tests have ambiguous names","updatedAt":"2024-07-23T15:27:25Z","url":"https://github.com/TNG/ArchUnit/issues/452"},{"createdAt":"2022-07-04T13:29:35Z","number":902,"state":"closed","title":"Specify file name for freeze?","updatedAt":"2022-07-07T08:55:04Z","url":"https://github.com/TNG/ArchUnit/issues/902"},{"createdAt":"2021-09-20T15:01:16Z","number":673,"state":"closed","title":"Public access for fields of `SourceCodeLocation`","updatedAt":"2021-10-24T17:40:40Z","url":"https://github.com/TNG/ArchUnit/issues/673"}]
```

**#20** · search · ok · 1091 ms — `gh search issues "empty violation" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-03-12T16:03:48Z","number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","updatedAt":"2025-08-11T12:40:51Z","url":"https://github.com/TNG/ArchUnit/issues/1264"}]
```

**#21** · search · ok · 1128 ms — `gh search prs "integrity" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-08-05T06:51:14Z","number":1338,"state":"merged","title":"Bump gradle/actions from 3 to 4","updatedAt":"2025-06-10T05:19:52Z","url":"https://github.com/TNG/ArchUnit/pull/1338"}]
```

**#22** · search · ok · 1139 ms — `gh search prs "empty violation" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2025-01-18T22:54:07Z","number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","updatedAt":"2026-07-06T12:26:23Z","url":"https://github.com/TNG/ArchUnit/pull/1405"}]
```

**#23** · core · ok · 1244 ms — `gh issue view 1045 --repo TNG/ArchUnit --json number,title,state,url,body,comments`

```
{"body":"this follows on (somewhat) https://github.com/TNG/ArchUnit/issues/1025.\r\n\r\nWe have a modular monolith, and have set up archunit to run for each module.  We are using frozen violations to manage the technical debt in each module, to prevent new violations from being added and to chip away at old ones.\r\n\r\nIn some circumstances Archunit will recreate the guid files with the current set of violations, which in theory is a good thing but we find that the guid file can sometimes change.  Perhaps our workflow is wrong, but at any rate, when multiple developers on current feature branches, we find we get a bunch of git conflicts that need to be resolved.\r\n\r\nWhat we think would work for us is if the file name storing the violations for a rule were deterministic rather than a guid.  Looking at the code, this is done at https://github.com/TNG/ArchUnit/blob/main/archunit/src/main/java/com/tngtech/archunit/library/freeze/ViolationStoreFactory.java#L166 , so the suggestion is to provide an SPI that makes this strategy pluggable.","comments":[{"id":"IC_kwDOBU1z-s5TVvbW","author":{"login":"danhaywood"},"authorAssociation":"CONTRIBUTOR","body":"On closer inspection, I see that the code in question is in `TextFileBasedViolationStore`, so perhaps this is already pluggable.  Will dig a bit deeper.","createdAt":"2023-01-20T10:44:30Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG/ArchUnit/issues/1045#issu
```

**#24** · search · ok · 1248 ms — `gh search prs "file names" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-04-14T14:43:10Z","number":1294,"state":"merged","title":"run tests with JUnit Platform","updatedAt":"2024-06-09T22:02:43Z","url":"https://github.com/TNG/ArchUnit/pull/1294"},{"createdAt":"2023-01-20T10:54:41Z","number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","updatedAt":"2023-02-06T18:07:18Z","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"createdAt":"2021-10-10T09:43:07Z","number":690,"state":"merged","title":"Public getters for source code location","updatedAt":"2021-10-24T17:40:40Z","url":"https://github.com/TNG/ArchUnit/pull/690"}]
```

**#25** · core · ok · 1599 ms — `gh issue view 676 --repo TNG/ArchUnit --comments`

```
author:	timtebeek
association:	contributor
edited:	false
status:	none
--
From my experience the desired behaviour you described is what you get when you set `feeze.store.allowStoreUpdate` to `true` (the default). That actually allows ArchUnit to remove previous violations, while restricting you from adding new violations. I find it's best to set that to true locally, or by default, so any changes to violation stores are part of the diff when you commit.

Then, to satisfy your build manager requirement of not changing any files, you can override the setting on the build server to disallow freeze store updates. That way you can ensure there are never any pending freeze store changes not part of the commit & build.

Would such a flow solve most of your use case? 

I also had to fumble a bit to arrive at this flow, perhaps is can be more clearly documented as a suggested workflow.
In particular it's not immediately clear that `allowStoreUpdate` only allows removal (or creation of new rules store files?).
--
author:	codecholeric
association:	collaborator
edited:	false
status:	none
--
I think that makes sense :+1: But I would propose a new configuration `skipStoreUpdate` then. 

Obviously the [user guide](https://www.archunit.org/userguide/html/000_Index.html#_freezing_arch_rules) should also be improved a little, because these options seem to cause more confusion than they should :joy: For example `allowStoreCreation` is something that really only needs to be set to `true` one tim
```

**#26** · core · ok · 1605 ms — `gh pr view 1656 --repo TNG/ArchUnit --comments`

```
author:	StefanGraeber
association:	contributor
edited:	false
status:	changes requested
--
Thanks for contributing 🙂 
The code itself looks good, just one minor edge case in the case of a non-existing directory which remains as race condition.

to make the pipeline pass, you must include a `Signed-off-by:` footer to your commit
https://github.com/TNG/ArchUnit/pull/1656/checks?check_run_id=85373415790
--
author:	StefanGraeber
association:	contributor
edited:	false
status:	none
--
you might have a merge conflict with #1655 which will be submitted soon.
It migrates some tests from Junit4 to Junit5 and thus exchange the Temporary File provider Rule with an Extension.
I think it has not touched the same test as you, but I might have missed it.
--
author:	kelunik
association:	contributor
edited:	false
status:	none
--
> you might have a merge conflict with https://github.com/TNG/ArchUnit/pull/1655 which will be submitted soon.

Thanks for the heads up! It didn't have a conflict, but I rebased anyway and converted the test to JUnit 5.

>  The code itself looks good, just one minor edge case in the case of a non-existing directory which remains as race condition.

True, I added a separate test for that.
--
author:	kelunik
association:	contributor
edited:	false
status:	none
--
Oh, these old Java versions, should be fixed.
--
author:	StefanGraeber
association:	contributor
edited:	false
status:	changes requested
--
Please squash at least the last two commits to avoid having an invalid int
```

**#27** · core · ok · 1640 ms — `gh pr view 1046 --repo TNG/ArchUnit --comments`

```
author:	hankem
association:	member
edited:	false
status:	commented
--
Thanks for your contribution!
Note that you'd have to please sign off your commit according to the [DCO](https://github.com/TNG/ArchUnit/blob/main/DCO).
--
author:	hankem
association:	member
edited:	false
status:	commented
--
I think your're getting close to a build as passing as you can get it! 👏 (Unfortunately, there are issues with the JDK 10 build since recently, and we also need to extend the copyright statement to 2023, but those will be taken care of independently of your PR.)
Oh, speaking of which: I think you'd also need to add this copyright statement to the new file `TextFileBasedViolationStore.java`... 🙈
--
author:	danhaywood
association:	contributor
edited:	false
status:	none
--
I've added a comment to associated issue #1045 to show how I'm using this.

https://github.com/TNG/ArchUnit/issues/1045#issuecomment-1402273844
--
author:	codecholeric
association:	collaborator
edited:	false
status:	none
--
Hey, thanks a lot for tackling this! Just to pitch in my 2 cents:
Originally I really didn't want to make `TextFileBasedViolationStore` public API, since for me this was just an implementation detail. But I see, that in some way this has always invited users to tinker with the text files, I think that's just the nature of handling bigger legacy code bases with multiple devs working in parallel (also noticed it e.g. in https://github.com/TNG/ArchUnit/issues/1015#issuecomment-1365114666 that it really
```

**#28** · core · ok · 1671 ms — `gh issue view 1264 --repo TNG/ArchUnit --comments`

```
author:	codecholeric
association:	collaborator
edited:	false
status:	none
--
Sorry for the late reply, I think it would be a nice addition, if anybody wants to give this a shot I would support it! In the past we've already sorted the actual violations alphabetically to ease human browsing and diffs if I remember correctly.
--
author:	maxxkia
association:	none
edited:	false
status:	none
--
Hello 👋 
I would like to work on this!
--
author:	maxxkia
association:	none
edited:	true
status:	none
--
Hi @codecholeric 

I have created https://github.com/TNG/ArchUnit/pull/1405 which solves parts of the features requested above, request no. 2 to be specific.
> 2. When freeze files become empty you are not being advised to remove the freezing from your test.

If those changes make sense to you I can proceed and update the docs in the same PR.
--
author:	maxxkia
association:	none
edited:	true
status:	none
--
I can work on the following feature requests in another PR
> 1- The files referenced might not exist anymore, but the reference in stored.rules is
> 3- Freeze files might still be in the archunit folder, but not referenced anymore
> 5- stored.rules are not sorted. To make it better human readable it would be nice to have it sorted alphabetically.

The 4th request
> 4. Tests were removed without removing the stored.rules line or freeze file
is more complicated because it requires taking an action by considering the whole test suite. At this point, I don't know if it is possible to achie
```

**#29** · core · ok · 1672 ms — `gh issue view 1025 --repo TNG/ArchUnit --comments`

```
author:	codecholeric
association:	collaborator
edited:	false
status:	none
--
Glad you like the project :slightly_smiling_face: It seems that the text-based violation store is much more "human-read" API than I originally thought :thinking: But I like your suggestion, since it's not very invasive or expensive to implement but might still make it easier to look up frozen violations for users :+1: 
Is there a reason you want all the escape characters in the comment though? If it's a comment it wouldn't be necessary to escape spaces with `\` and similar, right? And if it's about the association between the index file `stored.rules` and the details I would go via the UUID anyway, no?
--
author:	danhaywood
association:	contributor
edited:	true
status:	none
--
My thinking was that keeping the escapes in the comment would make it easier to associate with the stored.rules file, easier to search for than have to pick up the filename.  
--
author:	codecholeric
association:	collaborator
edited:	false
status:	none
--
But for that we have the association inside of the `stored.rules` file, no? :thinking: You can even rename the file arbitrarily if you want (doesn't have to be a UUID, that's just what ArchUnit picks by default). If you already look inside of the `stored.rules` file, then why not just use the association that's there anyway?
--
author:	danhaywood
association:	contributor
edited:	false
status:	none
--
OK thanks.  I'll close this as I have a different proposal to raise, will do
```

**#30** · core · ok · 1738 ms — `gh issue view 902 --repo TNG/ArchUnit --comments`

```
author:	hankem
association:	member
edited:	false
status:	none
--
I probably didn't understand the question correctly, but maybe it already helps to mention that the `stored.rules` properties file maps tests to violation file names (which are UUIDs by default) like in [this example](https://github.com/TNG/ArchUnit-Examples/blob/main/example-plain/src/test/resources/frozen/stored.rules). You can rename the violation files as you like, as long as you adapt the mapping in `stored.rules` consistently. (I actually do so when I want to have a semantic file names that make the mapping more memorizable for me.)
--
author:	keiki61
association:	none
edited:	false
status:	none
--
Thank you. You understood my question completely. :+1: 

Probably because I was myself not introducing the archunit tests I am not fully aware of all the features.
--
author:	hankem
association:	member
edited:	false
status:	none
--
Well, the [section about _Freezing Arch Rules_ in the _ArchUnit User Guide_](https://www.archunit.org/userguide/html/000_Index.html#_freezing_arch_rules) basically just states
> By default FreezingArchRule will use a simple ViolationStore based on plain text files.

but doesn't document further details of this default store (yet).

If a short sentence about `stored.rules` would have helped you, we should IMO add it.
--
author:	keiki61
association:	none
edited:	false
status:	none
--
Yes it would have helped me. For me I looked more in the javadoc to know what's going on. But I guess on
```

**#31** · denied · FAILED · 0 ms — `gh api -X GET -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java -f ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4`
→ `ERROR: `gh api -f` not allowed (sends a request body; GET only)`

**#32** · denied · FAILED · 0 ms — `gh api -X GET -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java -f ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d`
→ `ERROR: `gh api -f` not allowed (sends a request body; GET only)`

**#33** · denied · FAILED · 0 ms — `gh api -X GET -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java -f ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4`
→ `ERROR: `gh api -f` not allowed (sends a request body; GET only)`

**#34** · denied · FAILED · 0 ms — `gh api -X GET -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java -f ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d`
→ `ERROR: `gh api -f` not allowed (sends a request body; GET only)`

**#35** · core · ok · 589 ms — `gh api /repos/TNG/ArchUnit/commits?path=docs/userguide/html/000_Index.html --jq '.[0:20] | map({sha:.sha,date:.commit.committer.date,message:(.commit.message|split("\n")[0]),url:.html_url})'`

```
[{"date":"2026-08-04T00:06:03Z","message":"prepare release 1.5.0","sha":"502d782bfbf2632a2c9f943a502ddd8cc3e3c46d","url":"https://github.com/TNG/ArchUnit/commit/502d782bfbf2632a2c9f943a502ddd8cc3e3c46d"},{"date":"2026-04-18T19:28:21Z","message":"prepare release 1.4.2","sha":"e45aaa20543b74daeaa09f501b8890742dc7dd8d","url":"https://github.com/TNG/ArchUnit/commit/e45aaa20543b74daeaa09f501b8890742dc7dd8d"},{"date":"2025-05-07T19:53:45Z","message":"prepare release 1.4.1","sha":"6545053691bed56dacef3d767440e4cd58de739c","url":"https://github.com/TNG/ArchUnit/commit/6545053691bed56dacef3d767440e4cd58de739c"},{"date":"2025-05-04T16:13:32Z","message":"improve documentation of slices rules","sha":"1358b821d1fff18e73799ae1326efbc2067580dd","url":"https://github.com/TNG/ArchUnit/commit/1358b821d1fff18e73799ae1326efbc2067580dd"},{"date":"2025-02-10T20:27:24Z","message":"prepare release 1.4.0","sha":"c5caa020d13d21c61669bb1cae1a1223e4ce6f3c","url":"https://github.com/TNG/ArchUnit/commit/c5caa020d13d21c61669bb1cae1a1223e4ce6f3c"},{"date":"2024-04-11T13:31:33Z","message":"prepare release 1.3.0","sha":"dc7238fc7dfcfc50f5473c0cb3825de3dd9ced72","url":"https://github.com/TNG/ArchUnit/commit/dc7238fc7dfcfc50f5473c0cb3825de3dd9ced72"},{"date":"2023-12-03T23:07:14Z","message":"prepare release 1.2.1","sha":"17ced0833324760dfdf49aaa07ea00c1fbee63aa","url":"https://github.com/TNG/ArchUnit/commit/17ced0833324760dfdf49aaa07ea00c1fbee63aa"},{"date":"2023-11-06T00:06:22Z","message":"prepare release 1.2.
```

**#36** · core · ok · 634 ms — `gh pr view 1405 --repo TNG/ArchUnit --json comments,reviews --jq '{comments:[.comments[]|{author:.author.login,body:.body,url:.url}],reviews:[.reviews[]|{author:.author.login,state:.state,body:.body}]}'`

```
{"comments":[],"reviews":[{"author":"maxxkia","body":"","state":"COMMENTED"},{"author":"maxxkia","body":"","state":"COMMENTED"},{"author":"maxxkia","body":"","state":"COMMENTED"}]}
```

**#37** · core · ok · 638 ms — `gh pr view 1407 --repo TNG/ArchUnit --json comments,reviews --jq '{comments:[.comments[]|{author:.author.login,body:.body,url:.url}],reviews:[.reviews[]|{author:.author.login,state:.state,body:.body}]}'`
→ `{"comments":[],"reviews":[{"author":"maxxkia","body":"","state":"COMMENTED"}]}`

**#38** · core · ok · 734 ms — `gh api /repos/TNG/ArchUnit/commits?path=docs/userguide/008_The_Library_API.adoc --jq '.[0:20] | map({sha:.sha,date:.commit.committer.date,message:(.commit.message|split("\n")[0]),url:.html_url})'`

```
[{"date":"2026-07-28T22:53:05Z","message":"add package matcher section to user guide","sha":"733ae8b53629c6dbfb5713a99a11eb4a4839d571","url":"https://github.com/TNG/ArchUnit/commit/733ae8b53629c6dbfb5713a99a11eb4a4839d571"},{"date":"2026-07-27T08:28:40Z","message":"Document JUnit 6 support in user guide","sha":"abbf1bd18650b45cff0d5a79397d3bc4b6a60f38","url":"https://github.com/TNG/ArchUnit/commit/abbf1bd18650b45cff0d5a79397d3bc4b6a60f38"},{"date":"2025-05-04T16:13:32Z","message":"improve documentation of slices rules","sha":"1358b821d1fff18e73799ae1326efbc2067580dd","url":"https://github.com/TNG/ArchUnit/commit/1358b821d1fff18e73799ae1326efbc2067580dd"},{"date":"2024-04-10T22:08:23Z","message":"upgrade asciidoctor dependencies","sha":"fe1ef05cfa59a034886ca8635458fccba8c74455","url":"https://github.com/TNG/ArchUnit/commit/fe1ef05cfa59a034886ca8635458fccba8c74455"},{"date":"2024-04-10T22:08:23Z","message":"hide empty fields \u0026 methods of class diagrams","sha":"8da60d5b5e2ffc45a256da3634d0b3d20a342a19","url":"https://github.com/TNG/ArchUnit/commit/8da60d5b5e2ffc45a256da3634d0b3d20a342a19"},{"date":"2024-04-10T22:08:23Z","message":"render PlantUML diagrams as (interactive) SVGs","sha":"34899667627454282a1faa1f7d1b0e87a95282c2","url":"https://github.com/TNG/ArchUnit/commit/34899667627454282a1faa1f7d1b0e87a95282c2"},{"date":"2023-08-25T15:54:32Z","message":"extend the user guide about the `modules()` API","sha":"b6fcdf2e4efb75cac9bda74274ad7aa236f427dc","url":"https://github.c
```

**#39** · search · ok · 790 ms — `gh search issues "cleanup frozen" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`
→ `[]`

**#40** · search · ok · 1132 ms — `gh search prs "cleanup frozen" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`
→ `[]`

**#41** · search · ok · 1202 ms — `gh search issues "sanity check" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-03-12T16:03:48Z","number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","updatedAt":"2025-08-11T12:40:51Z","url":"https://github.com/TNG/ArchUnit/issues/1264"}]
```

**#42** · search · ok · 1207 ms — `gh search prs "sanity check" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2022-06-10T10:47:59Z","number":880,"state":"closed","title":"#641 Added tooling tests","updatedAt":"2024-04-10T22:40:41Z","url":"https://github.com/TNG/ArchUnit/pull/880"},{"createdAt":"2022-02-26T21:59:51Z","number":816,"state":"merged","title":"add the possibility to allow empty should per rule","updatedAt":"2022-02-27T14:41:40Z","url":"https://github.com/TNG/ArchUnit/pull/816"},{"createdAt":"2017-12-11T20:36:17Z","number":53,"state":"merged","title":"Add syntax fails on invalid args","updatedAt":"2017-12-11T20:37:43Z","url":"https://github.com/TNG/ArchUnit/pull/53"}]
```

**#43** · search · FAILED · 62 ms — `gh search commits "obsolete rules" --repo TNG/ArchUnit --limit 100 --json oid,message,url,committedDate`

```
exit_code=1
--- stdout ---

--- stderr ---
Unknown JSON field: "oid"
Available fields:
  author
  commit
  committer
  id
  parents
  repository
  sha
  url
```

**#44** · search · FAILED · 63 ms — `gh search commits "store integrity" --repo TNG/ArchUnit --limit 100 --json oid,message,url,committedDate`

```
exit_code=1
--- stdout ---

--- stderr ---
Unknown JSON field: "oid"
Available fields:
  author
  commit
  committer
  id
  parents
  repository
  sha
  url
```

**#45** · search · FAILED · 66 ms — `gh search commits "deterministic file names" --repo TNG/ArchUnit --limit 100 --json oid,message,url,committedDate`

```
exit_code=1
--- stdout ---

--- stderr ---
Unknown JSON field: "oid"
Available fields:
  author
  commit
  committer
  id
  parents
  repository
  sha
  url
```

**#46** · core · ok · 397 ms — `gh api -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4`

```
package com.tngtech.archunit.library.freeze;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;

import com.google.common.collect.ImmutableList;
import com.google.common.io.Files;
import com.tngtech.archunit.lang.ArchRule;
import org.assertj.core.api.ThrowableAssert;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static java.nio.charset.StandardCharsets.UTF_8;
import static java.util.Arrays.asList;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

public class TextFileBasedViolationStoreTest {

    @Rule
    public final TemporaryFolder temporaryFolder = new TemporaryFolder();

    private final ViolationStore store = new TextFileBasedViolationStore();
    private File configuredFolder;

    @Before
    public void setUp() throws Exception {
        configuredFolder = new File(temporaryFolder.newFolder(), "notyetthere");

        store.initialize(propertiesOf(
                "default.path", configuredFolder.getAbsolutePath(),
                "default.allowStoreCreation", String.valueOf(true)));
    }

    @Test
    public void throws_exception_when_there_are_obsolete_entries_in_storedRules_files() throws Exception
```

**#47** · core · ok · 398 ms — `gh api -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d`

```
/*
 * Copyright 2014-2025 TNG Technology Consulting GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.tngtech.archunit.library.freeze;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.util.List;
import java.util.Properties;
import java.util.UUID;
import java.util.regex.Pattern;

import com.google.common.base.Splitter;
import com.tngtech.archunit.PublicAPI;
import com.tngtech.archunit.lang.ArchRule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
import static com.google.common.io.Files.toByteArray;
import static com.tngtech.archunit.PublicAPI.Usage.ACCESS;
import static com.tngtech.archunit.PublicAPI.Usage.INHERITANCE;
import static com.tngtech.archunit.library.freeze.FreezingArchRule.ensureUnixLineBreaks;
import sta
```

**#48** · core · ok · 408 ms — `gh api -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4`

```
/*
 * Copyright 2014-2025 TNG Technology Consulting GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.tngtech.archunit.library.freeze;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import com.google.common.base.Predicates;
import com.google.common.base.Splitter;
import com.tngtech.archunit.PublicAPI;
import com.tngtech.archunit.lang.ArchRule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
import static com.google.common.io.Files.toByteArray;
import static com.tngtech.archunit.PublicAPI.Usage.ACCESS;
import stat
```

**#49** · core · ok · 421 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleDescriptionFileNames.java --jq 'map({sha:.sha,date:.commit.committer.date,message:(.commit.message|split("\n")[0]),url:.html_url})'`
→ `[]`

**#50** · core · ok · 423 ms — `gh api -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d`

```
package com.tngtech.archunit.library.freeze;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Function;

import com.google.common.base.Functions;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.tngtech.archunit.ArchConfiguration;
import com.tngtech.archunit.core.domain.JavaClass;
import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.lang.ArchCondition;
import com.tngtech.archunit.lang.ArchRule;
import com.tngtech.archunit.lang.ConditionEvent;
import com.tngtech.archunit.lang.ConditionEvents;
import com.tngtech.archunit.testutil.ArchConfigurationRule;
import com.tngtech.java.junit.dataprovider.DataProvider;
import com.tngtech.java.junit.dataprovider.DataProviderRunner;
import com.tngtech.java.junit.dataprovider.UseDataProvider;
import org.assertj.core.api.ThrowableAssert.ThrowingCallable;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;

import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.collect.Se
```

**#51** · core · ok · 430 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleViolationFileNameStrategyFactory.java --jq 'map({sha:.sha,date:.commit.committer.date,message:(.commit.message|split("\n")[0]),url:.html_url})'`
→ `[]`

**#52** · core · ok · 441 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java --jq 'map({sha:.sha,date:.commit.committer.date,message:(.commit.message|split("\n")[0]),url:.html_url})'`
→ `[]`

**#53** · core · ok · 448 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java --jq 'map({sha:.sha,date:.commit.committer.date,message:(.commit.message|split("\n")[0]),url:.html_url})'`

```
[{"date":"2026-07-23T07:06:08Z","message":"Make TextFileBasedViolationStore thread-safe under parallel test execution","sha":"48f6118f0f5b64d4174c0b51d68dbf117708a103","url":"https://github.com/TNG/ArchUnit/commit/48f6118f0f5b64d4174c0b51d68dbf117708a103"},{"date":"2026-01-07T07:25:02Z","message":"update copyright to new year 2026","sha":"92fe06c5c1173c920688c0ddf7287f0db0ade599","url":"https://github.com/TNG/ArchUnit/commit/92fe06c5c1173c920688c0ddf7287f0db0ade599"},{"date":"2025-01-08T07:20:57Z","message":"update copyright to new year 2025","sha":"48d906095833b455a67cf470fb1a4e7233326177","url":"https://github.com/TNG/ArchUnit/commit/48d906095833b455a67cf470fb1a4e7233326177"},{"date":"2024-01-01T16:44:53Z","message":"update copyright to new year 2024","sha":"193a91fad9b0ddf12d1d4aa34cfb62cde43ebd32","url":"https://github.com/TNG/ArchUnit/commit/193a91fad9b0ddf12d1d4aa34cfb62cde43ebd32"},{"date":"2023-04-15T13:48:36Z","message":"fix Javadoc reference to constructor of `TextFileBasedViolationStore`","sha":"0eed9b215a881bfadf30a0fb04747febe44585bd","url":"https://github.com/TNG/ArchUnit/commit/0eed9b215a881bfadf30a0fb04747febe44585bd"},{"date":"2023-04-15T13:16:17Z","message":"Ensure final newline in violation store files","sha":"94f31edadaf69b179df39316554f79881d2a26e7","url":"https://github.com/TNG/ArchUnit/commit/94f31edadaf69b179df39316554f79881d2a26e7"},{"date":"2023-02-06T17:51:25Z","message":"allow adjusting file names of `TextFileBasedViolationStore`","sha":"d48e0e155c
```

**#54** · search · ok · 788 ms — `gh search issues "rule file name" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`
→ `[]`

**#55** · search · ok · 895 ms — `gh search prs "rule file name" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2023-01-20T10:54:41Z","number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","updatedAt":"2023-02-06T18:07:18Z","url":"https://github.com/TNG/ArchUnit/pull/1046"}]
```

**#56** · core · ok · 382 ms — `gh api /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d --jq '.content | @base64d | split("\n")[130:210] | join("\n")'`

```
}

    private void ensureExistence(File folder) {
        checkState(folder.exists() && folder.isDirectory() || folder.mkdirs(), "Cannot create folder %s", folder.getAbsolutePath());
    }

    private void checkInitialization(boolean initializationSuccessful, String message, Object... args) {
        if (!initializationSuccessful) {
            throw new StoreInitializationFailedException(String.format(message, args));
        }
    }

    @Override
    public boolean contains(ArchRule rule) {
        return storedRules.containsKey(rule.getDescription());
    }

    @Override
    public void save(ArchRule rule, List<String> violations) {
        log.trace("Storing evaluated rule '{}' with {} violations: {}", rule.getDescription(), violations.size(), violations);
        if (violations.isEmpty() && warnEmptyRuleViolation) {
            throw new StoreEmptyException(String.format("Saving empty violations for freezing rule is disabled (enable by configuration %s.%s=true)",
                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, WARN_EMPTY_RULE_VIOLATION_PROPERTY_NAME));
        }
        if (violations.isEmpty() && deleteEmptyRule && !contains(rule)) {
            // do nothing, new rule file should not be created
            return;
        }
        if (!storeUpdateAllowed) {
            throw new StoreUpdateFailedException(String.format(
                    "Updating frozen violations is disabled (enable by configuration %s.%s=true)",
                    V
```

**#57** · core · ok · 386 ms — `gh api /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4 --jq '.content | @base64d | split("\n")[190:280] | join("\n")'`

```
"Updating frozen violations is disabled (enable by configuration %s.%s=true)",
                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_UPDATE_PROPERTY_NAME));
        }
        String ruleFileName = ensureRuleFileName(rule);
        write(violations, new File(storeFolder, ruleFileName));
    }

    private void write(List<String> violations, File ruleDetails) {
        StringBuilder builder = new StringBuilder();
        for (String violation : violations) {
            builder.append(escape(violation)).append("\n");
        }
        try {
            Files.write(ruleDetails.toPath(), builder.toString().getBytes(UTF_8));
        } catch (IOException e) {
            throw new StoreUpdateFailedException(e);
        }
    }

    private String escape(String violation) {
        return violation.replace("\n", "\\\n");
    }

    private String unescape(String violation) {
        return violation.replace("\\\n", "\n");
    }

    private String ensureRuleFileName(ArchRule rule) {
        String ruleDescription = rule.getDescription();

        String ruleFileName;
        if (storedRules.containsKey(ruleDescription)) {
            ruleFileName = storedRules.getProperty(ruleDescription);
            log.trace("Rule '{}' is already stored in file {}", ruleDescription, ruleFileName);
        } else {
            ruleFileName = ruleViolationFileNameStrategy.createRuleFileName(ruleDescription);
            log.trace("Assigning new file {
```

**#58** · core · ok · 400 ms — `gh api /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d --jq '.content | @base64d | split("\n")[210:300] | join("\n")'`

```
ruleFileName = ruleViolationFileNameStrategy.createRuleFileName(ruleDescription);
            log.trace("Assigning new file {} to rule '{}'", ruleFileName, ruleDescription);
            storedRules.setProperty(ruleDescription, ruleFileName);
        }
        return ruleFileName;
    }

    @Override
    public List<String> getViolations(ArchRule rule) {
        String ruleDetailsFileName = storedRules.getProperty(rule.getDescription());
        checkArgument(ruleDetailsFileName != null, "No rule stored with description '%s'", rule.getDescription());
        List<String> result = readLines(ruleDetailsFileName);
        log.trace("Retrieved stored rule '{}' with {} violations: {}", rule.getDescription(), result.size(), result);
        return result;
    }

    private List<String> readLines(String ruleDetailsFileName) {
        String violationsText = readStoreFile(ruleDetailsFileName);
        return Splitter.on(UNESCAPED_LINE_BREAK_PATTERN).omitEmptyStrings().splitToStream(violationsText)
                .map(this::unescape)
                .collect(toList());
    }

    private String readStoreFile(String fileName) {
        try {
            String result = new String(toByteArray(new File(storeFolder, fileName)), UTF_8);
            return ensureUnixLineBreaks(result);
        } catch (IOException e) {
            throw new StoreReadException(e);
        }
    }

    private static class FileSyncedProperties {
        private final File propertiesFile;
```

**#59** · core · ok · 407 ms — `gh api /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4 --jq '.content | @base64d | split("\n")[130:190] | join("\n")'`

```
private void ensureExistence(File folder) {
        checkState(folder.exists() && folder.isDirectory() || folder.mkdirs(), "Cannot create folder %s", folder.getAbsolutePath());
    }

    private void checkInitialization(boolean initializationSuccessful, String message, Object... args) {
        if (!initializationSuccessful) {
            throw new StoreInitializationFailedException(String.format(message, args));
        }
    }

    private void removeObsoleteRules() {
        Set<String> obsoleteStoredRules = storedRules.keySet().stream()
                .filter(ruleDescription -> !new File(storeFolder, storedRules.getProperty(ruleDescription)).exists())
                .collect(Collectors.toSet());
        if (!obsoleteStoredRules.isEmpty() && !storeUpdateAllowed) {
            throw new StoreUpdateFailedException(String.format(
                    "Failed to remove %d obsolete stored rule(s). Updating frozen violations is disabled (enable by configuration %s.%s=true)",
                    obsoleteStoredRules.size(), ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_UPDATE_PROPERTY_NAME));
        }
        obsoleteStoredRules.forEach(storedRules::removeProperty);
    }

    private void removeObsoleteRuleFiles() {
        Set<String> ruleFiles = storedRules.keySet().stream()
                .map(storedRules::getProperty)
                .collect(Collectors.toSet());

        List<String> danglingFiles = Arrays.stream(storeFolder.list())
                .
```

**#60** · search · ok · 453 ms — `gh search commits "store integrity" --repo TNG/ArchUnit --limit 100 --json sha,commit,url --jq 'map({sha:.sha,message:(.commit.message|split("\n")[0]),url:.url})'`
→ `[]`

**#61** · search · ok · 454 ms — `gh search commits "deterministic file names" --repo TNG/ArchUnit --limit 100 --json sha,commit,url --jq 'map({sha:.sha,message:(.commit.message|split("\n")[0]),url:.url})'`
→ `[]`

**#62** · search · ok · 483 ms — `gh search commits "obsolete rules" --repo TNG/ArchUnit --limit 100 --json sha,commit,url --jq 'map({sha:.sha,message:(.commit.message|split("\n")[0]),url:.url})'`
→ `[]`

**#63** · search · ok · 540 ms — `gh search code "RuleDescriptionFileNames" --repo TNG/ArchUnit --limit 100 --json path,repository,url`
→ `[]`

**#64** · search · ok · 549 ms — `gh search code "removeObsoleteRules" --repo TNG/ArchUnit --limit 100 --json path,repository,url`
→ `[]`

**#65** · search · ok · 558 ms — `gh search code "default.integrity" --repo TNG/ArchUnit --limit 100 --json path,repository,url`
→ `[]`

**#66** · search · ok · 551 ms — `gh search commits "TextFileBasedViolationStore integrity" --limit 100 --json sha,commit,url,repository --jq 'map({sha:.sha,message:(.commit.message|split("\n")[0]),url:.url,repo:.repository.nameWithOwner})'`
→ `[]`

**#67** · search · ok · 607 ms — `gh search code "removeObsoleteRules TextFileBasedViolationStore" --limit 100 --json path,repository,url`
→ `[]`

**#68** · search · ok · 641 ms — `gh search commits "stored.rules repair" --limit 100 --json sha,commit,url,repository --jq 'map({sha:.sha,message:(.commit.message|split("\n")[0]),url:.url,repo:.repository.nameWithOwner})'`
→ `[]`

**#69** · search · ok · 801 ms — `gh search issues "TextFileBasedViolationStore integrity" --limit 100 --json number,title,state,url,repository,createdAt,updatedAt`
→ `[]`

**#70** · search · ok · 841 ms — `gh search prs "stored.rules repair" --limit 100 --json number,title,state,url,repository,createdAt,updatedAt`
→ `[]`

**#71** · search · ok · 860 ms — `gh search code "RuleDescriptionFileNames TextFileBasedViolationStore" --limit 100 --json path,repository,url`
→ `[]`

**#72** · search · ok · 874 ms — `gh search prs "TextFileBasedViolationStore integrity" --limit 100 --json number,title,state,url,repository,createdAt,updatedAt`
→ `[]`

**#73** · search · ok · 892 ms — `gh search issues "stored.rules repair" --limit 100 --json number,title,state,url,repository,createdAt,updatedAt`
→ `[]`

**#74** · core · ok · 1014 ms — `gh issue view 1264 --repo TNG/ArchUnit --json number,title,state,url,body,comments`

```
{"body":"Hi ArchUnit Team,\r\n\r\nFirst of you do a great job here. ArchUnit is great.\r\n\r\nIn our project we currently have >70 freeze files in the stored.rules mentioned.\r\n\r\nDigging deeper I noticed several things, which I am concerned about.\r\n\r\n1. The files referenced might not exist anymore, but the reference in stored.rules is\r\n2. When freeze files become empty you are not being advised to remove the freezing from your test. \r\n3. Freeze files might still be in the archunit folder, but not referenced anymore\r\n4. Tests were removed without removing the stored.rules line or freeze file\r\n5. stored.rules are not sorted. To make it better human readable it would be nice to have it sorted alphabetically.\r\n\r\nOf course in the end it is our job to keep our source code in check and clean up correctly etc.\r\n\r\nYet I wonder how ArchUnit itself can help to have a sanity check of its freeze files and stored.rules?\r\n\r\nWhat is your opinion on this?","comments":[{"id":"IC_kwDOBU1z-s6TBo-D","author":{"login":"codecholeric"},"authorAssociation":"COLLABORATOR","body":"Sorry for the late reply, I think it would be a nice addition, if anybody wants to give this a shot I would support it! In the past we've already sorted the actual violations alphabetically to ease human browsing and diffs if I remember correctly.","createdAt":"2024-11-10T10:38:30Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG
```

**#75** · search · ok · 1047 ms — `gh search code "TextFileBasedViolationStore default.integrity" --limit 100 --json path,repository,url`
→ `[]`

**#76** · search · ok · 1063 ms — `gh search code "freeze.store.default.fileNames" --limit 100 --json path,repository,url`
→ `[]`

**#77** · search · ok · 1069 ms — `gh search code "DeterministicTextFileBasedViolationStore" --limit 100 --json path,repository,url`
→ `[]`
