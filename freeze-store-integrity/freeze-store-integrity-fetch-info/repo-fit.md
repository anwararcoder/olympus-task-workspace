# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · med confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-10-17 15:34
- **Investigation:** 41 gh calls · 14 gh searches · 6 upstream requests · 365.3s

The freeze-store integrity task is distinct from the older submissions. Public ArchUnit PRs implement limited missing-entry and empty-save cleanup, but not the store-integrity core.

## Reasoning

I adopt the eight supplied distinct rulings. The only same-repo contact worth counting is with [another submission]: its compiler-importer implementation supplies summed N=0 of the subject’s 463 authored non-blank solution lines, or 0/432 (0%) after subtracting the 16-line rendered-guide mirror and 15-line conventional license header; the reverse count is 0/566 (0%). Those integers support the worksheet’s clear-minority label and distinct ruling. The other seven candidates provide no freeze-store implementation block. As a set they still cover 0/432 (0%): there are neither distinct major part-sources to stitch together nor a recurring freeze-store kit. I also checked the two extra candidates cited in the previous run: their Go ruleset transactions and Rust database OPTIONS/checkpoint implementation are unrelated to this Java store; they are not part-sources. Prior motivation-only findings based on generic integrity or concurrency themes are not substantive overlap findings for this version.

I checked the history of the solution’s created StoreIntegrity.java path (no returned commits, including before the pinned base), the changed TextFileBasedViolationStore.java path, and both guide paths; searched PRs and issues in both states for freeze, store, stored.rules, integrity, obsolete, cleanup, validation and empty-rule concepts; and checked forward drift. I found no removal or full public implementation. At their respective heads I read the complete implementing TextFileBasedViolationStore.java sources: open PR #1407, b0631bc, implements removeObsoleteRules, an existence-based missing-mapping prune, but removeObsoleteRuleFiles also deletes unowned files contrary to this task. Open PR #1405, 4952aae, implements save/deleteRuleFile for an optional empty-save deletion, but does not protect shared files, escaping paths, or symlink targets. These are same-repo sources; no unrelated codebase is being counted. PR #1656’s caching and synchronized insertion already occur in the pinned base, so they add no marginal coverage. PR #1761 concerns FreezingArchRule’s failure reporting rather than index/file integrity.

The current new maintenance suite contains 46 @Test functions, not the previous version’s 149; its 850/779-line denominator and four naming tests are likewise from another version, whereas this solution has 463/432 lines. Giving public code generous credit after routine opt-in wiring, #1407 contributes to at most 11/46 functions: absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry (prunes the missing mapping on the repair pass); ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry (same repair-side prune); repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne (prunes the inconsistent folder’s missing mapping); anEntryWhoseFileIsAbsentIsBroken (removes the absent mapping while retaining the present one); everyBrokenEntryIsDiscarded (iterates and removes the absent mappings); anEntryNamingADanglingLinkIsBroken (treats the dangling target as nonexistent); entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken (finds each nonexistent spelling); aSecondInitializationOfARepairedFolderDiscardsNothing (persists the initial prune, leaving none to repeat); aSeparatelyCreatedStoreObservesTheRepairedIndex (persists the removal for a new reader); repairKeepsAStillViolatingRuleFrozenWithItsViolations (prunes its absent companion while the pinned base reads the surviving violations); and aStillViolatedRuleKeepsItsEntryUnderRepair (prunes the absent companion while the pinned base saves the surviving rule). #1405 contributes to at most 3/46: storingNoViolationsUnderRepairForgetsTheEntryAndItsFile (deletes a known rule’s file and mapping on empty save); forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry (tries deletion before removing the mapping); and forgettingARuleTheIndexNeverKnewStoresNothingForIt (skips an unknown rule’s empty save). These credits identify code those branches add, not a claim that either PR unmodified passes the suite. Together the public upper bound is 14/46 (30.4%), leaving at least 32/46 (69.6%) and more than half the hard implementation work: shared-name and inode identity, symlink/path safety, resolved-file classification and deletion, protection of unowned files, and fresh cached-index examination. With no older-candidate part-source, stacking does not change that remainder; neither exclusivity bar is met. The prior #1045 naming snippet has 0/46 marginal coverage because this suite contains no description-derived naming requirement. The #1046 naming-SPI preference, #902 concern about documenting an internal file format, and #795 objection to a Properties subclass are not rejections of integrity maintenance, so the previous naming-SPI finding does not carry forward.

Issue #1264 explicitly welcomes a freeze-store sanity check. The pinned README and freezing guide describe an extensible architecture-testing library and a text-file violation store; the requested maintenance is coherent with that purpose. No confirmed duplicate, complete cribbable fix, maintainer decline, removal, or off-scope contradiction warrants a drop.

## Findings (4)

### overlap — Low severity

- **Claim:** distinct — [another submission]: Gradle test-setup filename contact, but no shared solution implementation (0/432 subject lines, 0%).

### publicly-solved — Medium severity

- **Claim:** Partial public solution in open PR #1407: missing-file mapping pruning contributes to at most 11/46 maintenance tests; its deletion of unowned files conflicts with the requested behavior.
- **Evidence:** https://github.com/TNG/ArchUnit/blob/b0631bc58a5db6bf4069278e22e7e689bfacd9d4/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java — ".filter(ruleDescription -> !new File(storeFolder, storedRules.getProperty(ruleDescription)).exists())"

### publicly-solved — Medium severity

- **Claim:** Partial public solution in open PR #1405: optional empty-save deletion contributes to at most 3/46 maintenance tests, without shared-file or safe-path handling.
- **Evidence:** https://github.com/TNG/ArchUnit/blob/4952aae7799e1f08e5b1877dfc1e0395f29a4b3d/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java — "if (violations.isEmpty() && deleteEmptyRule) {"

### upstream-ahead — Medium severity

- **Claim:** Upstream `main` is 48 commit(s) ahead of `ab6a677` and touches 1 file(s) the solution patch also modifies.
- **Evidence:** "Overlap: docs/userguide/html/000_Index.html. Sample commits in range: 76a1620 (Update Gradle Wrapper from 9.8.0 to 9.8.1), 8d088b8 (Fix Java 9 build issue), f9809d6 (Fix Java 9 build issue (#1734)), 3706aa5 (add haveOnlyFinalNonSyntheticFields() to ignore synthetic fields), ef17849 (add haveOnlyFinalNonSyntheticFields() to ignore synthetic fields (#1747))."
- **Expected:** Base commit at/near upstream HEAD, or post-base commits unrelated to this fix.
- **Why it matters:** Maintainers may have already fixed this bug between the base commit and HEAD; confirm this submission's fix isn't already present or superseded upstream.

## Investigation Log (41 commands)

**#0** · core · ok · 370 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java&per_page=100' --jq 'map({sha:.sha, message:.commit.message})'`
→ `[]`

**#1** · core · ok · 446 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java&per_page=100' --jq 'map({sha:.sha, message:.commit.message})'`

```
[{"message":"Make TextFileBasedViolationStore thread-safe under parallel test execution\n\nMultiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore\nand load stored.rules into their own private snapshot. Concurrent saves caused a\nlost-update: the last writer overwrote the file with only its own entries.\n\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a\nstatic ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that\natomically checks, sets, and flushes to disk under one lock.\n\n- Move directory creation into FileSyncedProperties.initializePropertiesFile\n- Use mkdirs() || isDirectory() to handle the race where a concurrent process\n  creates the directory between mkdirs() returning false and the isDirectory check\n- Add TextFileBasedViolationStoreConcurrencyTest with separate initialize-race and\n  save-race scenarios\n- Convert both test classes from JUnit 4 to JUnit 5\n\nCo-Authored-By: <model> \u003cnoreply@<provider>.com\u003e\nSigned-off-by: Niklas Keller \u003cniklas@chrono24.com\u003e","sha":"48f6118f0f5b64d4174c0b51d68dbf117708a103"},{"message":"update copyright to new year 2026\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke@tngtech.com\u003e","sha":"92fe06c5c1173c920688c0ddf7287f0db0ade599"},{"message":"update copyright to new year 2025\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke@tngtech.com\u003e","sha":"48d906095833b455a67cf470fb1a4e7233326177"},{"message":"update c
```

**#2** · core · ok · 489 ms — `gh api '/repos/TNG/ArchUnit/commits?path=docs/userguide/008_The_Library_API.adoc&per_page=100' --jq 'map({sha:.sha, message:.commit.message})'`

```
[{"message":"add package matcher section to user guide\n\n* add a detailed part to the core API section, as PackageMatching resides there.\n* reference the detailed section where the current user guide already touches the topic\n* adjust css to fix rendering issue with codeboxes containing only the `.` (dot) character\n\nSigned-off-by: Andreas Zöller \u003candreas.zoeller@tngtech.com\u003e","sha":"733ae8b53629c6dbfb5713a99a11eb4a4839d571"},{"message":"Document JUnit 6 support in user guide\n\nSigned-off-by: Dr. Jonathan Schulz \u003cjonathan.schulz@tngtech.com\u003e","sha":"abbf1bd18650b45cff0d5a79397d3bc4b6a60f38"},{"message":"improve documentation of slices rules\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke@tngtech.com\u003e","sha":"1358b821d1fff18e73799ae1326efbc2067580dd"},{"message":"upgrade asciidoctor dependencies\n\nhttps://github.com/asciidoctor/asciidoctor-diagram/releases/tag/v2.2.6\nupdates PlantUML from 1.2022.14 to 1.2023.4.\n\nSince plantuml-1.2023.2,\n```\npackage com.myapp.application\n```\nproduces 3 boxes instead of one by default.\n\ncf. https://plantuml.com/news:\n* 2 Feb, 2023: Important change about package and namespace\n\u003e\n\u003e Starting with version 1.2023.2 (which is online as a beta),\n\u003e PlantUML handles differently namespaces and packages.\n\u003e\n\u003e There won't be any difference between namespaces and packages anymore:\n\u003e both keywords are now synonymous.\n\u003e\n\u003e The drawing is slightly different, because we no
```

**#3** · core · ok · 539 ms — `gh api '/repos/TNG/ArchUnit/commits?path=docs/userguide/html/000_Index.html&per_page=100' --jq 'map({sha:.sha, message:.commit.message})'`

```
[{"message":"prepare release 1.5.1\n\nSigned-off-by: schulzjo-tng \u003caction@github.com\u003e","sha":"6c2d659e5681b50541930d236a8c46aed5e44a5c"},{"message":"prepare release 1.5.0\n\nSigned-off-by: hankem \u003caction@github.com\u003e","sha":"502d782bfbf2632a2c9f943a502ddd8cc3e3c46d"},{"message":"prepare release 1.4.2\n\nSigned-off-by: hankem \u003caction@github.com\u003e","sha":"e45aaa20543b74daeaa09f501b8890742dc7dd8d"},{"message":"prepare release 1.4.1\n\nSigned-off-by: hankem \u003caction@github.com\u003e","sha":"6545053691bed56dacef3d767440e4cd58de739c"},{"message":"improve documentation of slices rules\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke@tngtech.com\u003e","sha":"1358b821d1fff18e73799ae1326efbc2067580dd"},{"message":"prepare release 1.4.0\n\nSigned-off-by: hankem \u003caction@github.com\u003e","sha":"c5caa020d13d21c61669bb1cae1a1223e4ce6f3c"},{"message":"prepare release 1.3.0\n\nSigned-off-by: codecholeric \u003caction@github.com\u003e","sha":"dc7238fc7dfcfc50f5473c0cb3825de3dd9ced72"},{"message":"prepare release 1.2.1\n\nSigned-off-by: codecholeric \u003caction@github.com\u003e","sha":"17ced0833324760dfdf49aaa07ea00c1fbee63aa"},{"message":"prepare release 1.2.0\n\nSigned-off-by: codecholeric \u003caction@github.com\u003e","sha":"12e8fb188c4beec33e525b5e491ef3ed5ba252e4"},{"message":"chore: updated documentation since accept no longer exists on JavaPackage\n\nSigned-off-by: Simon Verhoeven \u003cverhoeven.simon@gmail.com\u003e","sha":"3ca046cbf87da5bbaf
```

**#4** · search · ok · 908 ms — `gh search prs 'freeze' --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt`

```
[{"createdAt":"2023-01-20T10:54:41Z","number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"createdAt":"2022-09-25T08:29:52Z","number":964,"state":"merged","title":"Replace PlantUML rule exceptions by violations","url":"https://github.com/TNG/ArchUnit/pull/964"},{"createdAt":"2021-05-30T06:25:34Z","number":612,"state":"merged","title":"add property `freeze.refreeze` to allow overwriting the current store","url":"https://github.com/TNG/ArchUnit/pull/612"},{"createdAt":"2020-09-27T19:29:01Z","number":438,"state":"merged","title":"Run tests against Java 15 during CI","url":"https://github.com/TNG/ArchUnit/pull/438"},{"createdAt":"2020-09-25T18:17:05Z","number":428,"state":"merged","title":"Add component type of arrays to JavaClass dependencies #257","url":"https://github.com/TNG/ArchUnit/pull/428"},{"createdAt":"2019-10-20T15:29:17Z","number":252,"state":"merged","title":"Enhance FreezingArchRule","url":"https://github.com/TNG/ArchUnit/pull/252"},{"createdAt":"2019-06-15T08:49:51Z","number":181,"state":"merged","title":"Provide a way to store all current violations of a rule and successively only report new ones","url":"https://github.com/TNG/ArchUnit/pull/181"}]
```

**#5** · search · ok · 1109 ms — `gh search prs 'store' --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt`

```
[{"createdAt":"2026-10-14T11:03:20Z","number":1761,"state":"open","title":"fix: report new frozen-rule violations when cleanup cannot update the store","url":"https://github.com/TNG/ArchUnit/pull/1761"},{"createdAt":"2025-01-18T22:54:07Z","number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","url":"https://github.com/TNG/ArchUnit/pull/1405"},{"createdAt":"2025-01-19T14:52:15Z","number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"createdAt":"2026-07-27T15:47:27Z","number":1673,"state":"merged","title":"Add temporary publication to formally deprecate the legacy `archunit-junit` package","url":"https://github.com/TNG/ArchUnit/pull/1673"},{"createdAt":"2022-03-03T06:38:46Z","number":822,"state":"closed","title":"Add support for casts","url":"https://github.com/TNG/ArchUnit/pull/822"},{"createdAt":"2026-08-05T06:52:49Z","number":1685,"state":"merged","title":"Bump gradle/actions from 6.2.0 to 6.3.0","url":"https://github.com/TNG/ArchUnit/pull/1685"},{"createdAt":"2026-06-23T13:09:24Z","number":1644,"state":"merged","title":"Bump concurrent-ruby from 1.3.6 to 1.3.7 in /docs","url":"https://github.com/TNG/ArchUnit/pull/1644"},{"createdAt":"2026-08-03T06:52:56Z","number":1681,"state":"merged","title":"Bump gradle/actions from 6 to 6.2.0","url":"https://github.com/TNG/ArchUnit/pull/1681"},{"createdAt":"2026-06-26T06:52:13Z","number":1645,"state":"merged","title":"Bump
```

**#6** · search · ok · 1116 ms — `gh search issues 'freeze' --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt`

```
[{"createdAt":"2025-07-25T14:17:50Z","number":1494,"state":"open","title":"Bad Frozen error messages","url":"https://github.com/TNG/ArchUnit/issues/1494"},{"createdAt":"2019-09-04T11:14:41Z","number":226,"state":"open","title":"Freeze Rule Sets","url":"https://github.com/TNG/ArchUnit/issues/226"},{"createdAt":"2026-08-13T08:06:28Z","number":1700,"state":"open","title":"Surfacing freeze store size as a signal: a green build is compatible with a growing store","url":"https://github.com/TNG/ArchUnit/issues/1700"},{"createdAt":"2022-12-02T08:27:24Z","number":1015,"state":"open","title":"Do not include line numbers in freezed messages","url":"https://github.com/TNG/ArchUnit/issues/1015"},{"createdAt":"2024-03-12T16:03:48Z","number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","url":"https://github.com/TNG/ArchUnit/issues/1264"},{"createdAt":"2025-12-10T06:37:35Z","number":1563,"state":"open","title":"Freezing violations should include all violations in the store?","url":"https://github.com/TNG/ArchUnit/issues/1563"},{"createdAt":"2022-10-13T10:00:29Z","number":981,"state":"open","title":"callMethod() ignores lambdas","url":"https://github.com/TNG/ArchUnit/issues/981"},{"createdAt":"2021-12-26T23:46:32Z","number":750,"state":"open","title":"Feature Request: Import architecture breaks into SonarQube","url":"https://github.com/TNG/ArchUnit/issues/750"},{"createdAt":"2023-01-20T07:11:06Z","number":1045,"state":"open","title"
```

**#7** · search · ok · 1190 ms — `gh search issues 'store' --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt`

```
[{"createdAt":"2026-08-13T08:06:28Z","number":1700,"state":"open","title":"Surfacing freeze store size as a signal: a green build is compatible with a growing store","url":"https://github.com/TNG/ArchUnit/issues/1700"},{"createdAt":"2025-12-10T06:37:35Z","number":1563,"state":"open","title":"Freezing violations should include all violations in the store?","url":"https://github.com/TNG/ArchUnit/issues/1563"},{"createdAt":"2025-07-25T14:17:50Z","number":1494,"state":"open","title":"Bad Frozen error messages","url":"https://github.com/TNG/ArchUnit/issues/1494"},{"createdAt":"2021-12-26T23:31:04Z","number":749,"state":"open","title":"Change Request: ViolationStore-API should give access to structured violation data","url":"https://github.com/TNG/ArchUnit/issues/749"},{"createdAt":"2021-09-23T03:35:49Z","number":676,"state":"open","title":"FreezingArchRule: No longer violating a rule should under no circumstances break the test","url":"https://github.com/TNG/ArchUnit/issues/676"},{"createdAt":"2021-05-11T03:06:08Z","number":597,"state":"open","title":"ArchUnit Trends","url":"https://github.com/TNG/ArchUnit/issues/597"},{"createdAt":"2022-12-02T08:27:24Z","number":1015,"state":"open","title":"Do not include line numbers in freezed messages","url":"https://github.com/TNG/ArchUnit/issues/1015"},{"createdAt":"2021-10-27T11:58:33Z","number":705,"state":"open","title":"Scan parameter name","url":"https://github.com/TNG/ArchUnit/issues/705"},{"createdAt":"2021-12-27T00:17:29Z","number":7
```

**#8** · search · ok · 749 ms — `gh search issues 'integrity' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`
→ `[]`

**#9** · search · ok · 809 ms — `gh search issues 'obsolete' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1494,"state":"open","title":"Bad Frozen error messages","url":"https://github.com/TNG/ArchUnit/issues/1494"},{"number":66,"state":"open","title":"Improve reporting of ignored violations","url":"https://github.com/TNG/ArchUnit/issues/66"},{"number":286,"state":"closed","title":"[Question] Classes should be referenced in external package","url":"https://github.com/TNG/ArchUnit/issues/286"}]
```

**#10** · search · ok · 1015 ms — `gh search prs 'obsolete' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"number":1761,"state":"open","title":"fix: report new frozen-rule violations when cleanup cannot update the store","url":"https://github.com/TNG/ArchUnit/pull/1761"},{"number":1562,"state":"open","title":"Add `com.tngtech.archunit.openrewrite.SanityCheck`","url":"https://github.com/TNG/ArchUnit/pull/1562"},{"number":1681,"state":"merged","title":"Bump gradle/actions from 6 to 6.2.0","url":"https://github.com/TNG/ArchUnit/pull/1681"},{"number":1278,"state":"merged","title":"fix issues with build dependencies and test execution","url":"https://github.com/TNG/ArchUnit/pull/1278"},{"number":1096,"state":"merged","title":"Fix missing try-catch-blocks in lambdas","url":"https://github.com/TNG/ArchUnit/pull/1096"},{"number":1028,"state":"closed","title":"add JDK 19 to CI build","url":"https://github.com/TNG/ArchUnit/pull/1028"},{"number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"number":904,"state":"merged","title":"Add API to create ArchConditions from predicates","url":"https://github.com/TNG/ArchUnit/pull/904"},{"number":876,"state":"merged","title":"Improve `ArchCondition` evaluation","url":"https://github.com/TNG/ArchUnit/pull/876"},{"number":778,"state":"merged","title":"implement containNumberOfElements for members ","url":"https://github.com/TNG/ArchUni
```

**#11** · search · ok · 1043 ms — `gh search prs 'cleanup' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1761,"state":"open","title":"fix: report new frozen-rule violations when cleanup cannot update the store","url":"https://github.com/TNG/ArchUnit/pull/1761"},{"number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"number":1750,"state":"open","title":"render JavaAccess and field access descriptions lazily in conditions","url":"https://github.com/TNG/ArchUnit/pull/1750"},{"number":1751,"state":"open","title":"Refactor archunit-maven-test build","url":"https://github.com/TNG/ArchUnit/pull/1751"},{"number":1717,"state":"merged","title":"cleanup ClassFileImporterAnnotationsTest and minor other locations","url":"https://github.com/TNG/ArchUnit/pull/1717"},{"number":1658,"state":"closed","title":"[part2]add support JUnit 6.x testing framework. ","url":"https://github.com/TNG/ArchUnit/pull/1658"},{"number":1685,"state":"merged","title":"Bump gradle/actions from 6.2.0 to 6.3.0","url":"https://github.com/TNG/ArchUnit/pull/1685"},{"number":1681,"state":"merged","title":"Bump gradle/actions from 6 to 6.2.0","url":"https://github.com/TNG/ArchUnit/pull/1681"},{"number":1569,"state":"merged","title":"Adjust AnalyzeClasses annotation to support individual classes as parameter","url":"https://github.com/TNG/ArchUnit/pull/1569"},{"number":1646,"state":"merged","title":"Bump com.gradleup.shadow from 9.4.2 to 9.4.3","url":"https://github.com/TNG/ArchUnit/pull/1646"},{"number":1644,"state":"merged","title":"Bump concurre
```

**#12** · search · ok · 1113 ms — `gh search issues 'validation' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1634,"state":"open","title":"External Validation for ArchUnit Compatibility with Future JDK and Class File Versions","url":"https://github.com/TNG/ArchUnit/issues/1634"},{"number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","url":"https://github.com/TNG/ArchUnit/issues/1264"},{"number":1095,"state":"open","title":"Consider linking ArchUnit sample with best-practices","url":"https://github.com/TNG/ArchUnit/issues/1095"},{"number":1589,"state":"closed","title":"[Question] Implementing a check for Lombok @Builder usage with mandatory fields","url":"https://github.com/TNG/ArchUnit/issues/1589"},{"number":1238,"state":"closed","title":"@AnalyzeClasses breaks JUnit 5 tag filtering","url":"https://github.com/TNG/ArchUnit/issues/1238"},{"number":532,"state":"closed","title":"Feature proposal: fail on empty givens","url":"https://github.com/TNG/ArchUnit/issues/532"},{"number":151,"state":"closed","title":"ArchCondition to ensure no upper package access incl. solution","url":"https://github.com/TNG/ArchUnit/issues/151"},{"number":113,"state":"closed","title":"Expose parameter annotations ","url":"https://github.com/TNG/ArchUnit/issues/113"},{"number":109,"state":"closed","title":"Question","url":"https://github.com/TNG/ArchUnit/issues/109"},{"number":315,"state":"closed","title":"Can ArchUnit issue warning and not error","url":"https://github.com/TNG/ArchUnit/issues/315"},{"number":330,"state":"closed","title":"Pl
```

**#13** · search · ok · 1117 ms — `gh search prs 'integrity' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1338,"state":"merged","title":"Bump gradle/actions from 3 to 4","url":"https://github.com/TNG/ArchUnit/pull/1338"}]
```

**#14** · core · ok · 1513 ms — `gh issue view 1264 --repo TNG/ArchUnit --comments`

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

**#15** · core · ok · 557 ms — `gh pr view 1407 --repo TNG/ArchUnit --json headRefOid,body,title,url,files,comments,reviews --jq '{sha:.headRefOid,body:.body,title:.title,url:.url,files:[.files[].path],comments:[.comments[]|{body:.body,author:.author.login}],reviews:[.reviews[]|{body:.body,author:.author.login}]}'`

```
{"body":"These changes bring 2 features\r\n* clean up of frozen rules in `stored.rules` where the corresponding file does not exist in the store directory\r\n* clean up of files in store directory which are not referenced in `stored.rules` file\r\nBoth of the above operations are enabled using `default.allowStoreUpdate` property. If `default.allowStoreUpdate=false` and obsolete entries or files are found by either of the above operations, the operation fails with an `StoreUpdateFailedException`.\r\n\r\nSigned-off-by: Masoud Kiaeeha \u003c6916434+maxxkia@users.noreply.github.com\u003e\r\n\r\nResolves #1264","comments":[],"files":["archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java","archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java"],"reviews":[{"author":"maxxkia","body":""}],"sha":"b0631bc58a5db6bf4069278e22e7e689bfacd9d4","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"}
```

**#16** · core · ok · 685 ms — `gh pr view 1405 --repo TNG/ArchUnit --json headRefOid,body,title,url,files,comments,reviews --jq '{sha:.headRefOid,body:.body,title:.title,url:.url,files:[.files[].path],comments:[.comments[]|{body:.body,author:.author.login}],reviews:[.reviews[]|{body:.body,author:.author.login}]}'`

```
{"body":"These changes introduce two new features for FreezingRule default store\r\n* Raise error when a freezing rule has zero violations. This can be enabled by setting the property `default.warnEmptyRuleViolation=true`. For backward compatibility it is disabled by default.\r\n* Skip rule violation file creation or delete if it already exists, when there are zero violations. This can be enabled by setting the property `default.deleteEmptyRuleViolation=true`, it is disabled by default.\r\n\r\nSigned-off-by: Masoud Kiaeeha \u003c6916434+maxxkia@users.noreply.github.com\u003e\r\n\r\nResolves #1264","comments":[],"files":["archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreEmptyException.java","archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java","archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java"],"reviews":[{"author":"maxxkia","body":""},{"author":"maxxkia","body":""},{"author":"maxxkia","body":""}],"sha":"4952aae7799e1f08e5b1877dfc1e0395f29a4b3d","title":"raise error for empty violation store and delete empty rule file","url":"https://github.com/TNG/ArchUnit/pull/1405"}
```

**#17** · core · ok · 784 ms — `gh pr view 1761 --repo TNG/ArchUnit --json headRefOid,body,title,url,files,comments,reviews --jq '{sha:.headRefOid,body:.body,title:.title,url:.url,files:[.files[].path],comments:[.comments[]|{body:.body,author:.author.login}],reviews:[.reviews[]|{body:.body,author:.author.login}]}'`

```
{"body":"The filtered result is computed first, and removal of obsolete violations then runs inside a catch for StoreUpdateFailedException. With store updates disabled, a frozen rule that gains a new violation fails with StoreUpdateFailedException and the message that updating frozen violations is disabled.\n\nThe Gradle run of FreezingArchRuleTest finished successfully.\n\nCloses #1494\n","comments":[],"files":["archunit/src/main/java/com/tngtech/archunit/library/freeze/FreezingArchRule.java","archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java"],"reviews":[],"sha":"46f4ad65a2775325f174c5997e7a39336cd20801","title":"fix: report new frozen-rule violations when cleanup cannot update the store","url":"https://github.com/TNG/ArchUnit/pull/1761"}
```

**#18** · core · ok · 956 ms — `gh pr view 795 --repo TNG/ArchUnit --comments`

```
author:	codecholeric
association:	collaborator
edited:	false
status:	none
--
As discussed, while I see the reasoning behind sorting these files I'm not super happy with extending `java.util.Properties`, because I don't like the maintenance aspect of this (this could break with any JDK upgrade and I don't feel comfortable with extending such core JDK classes, feels "hacky" to me). Did you make any progress considering an extension point for users instead? Where users could hook in code like this themselves?
--
author:	oberprah
association:	contributor
edited:	false
status:	none
--
Yes, I totally agree this approaches feels very hacky. 

However, I haven't tried yet to create an extension point for users. I'll see if I can get around to it next week, otherwise I'll close the PR.
--
```

**#19** · core · ok · 1251 ms — `gh issue view 902 --repo TNG/ArchUnit --comments`

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

**#20** · core · ok · 1306 ms — `gh issue view 1045 --repo TNG/ArchUnit --comments`

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

**#21** · core · ok · 1351 ms — `gh pr view 1046 --repo TNG/ArchUnit --comments`

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

**#22** · core · ok · 302 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d' --jq '.content | @base64d | split("\n") | {lines:length,block:.[0:85]}'`

```
{"block":["/*"," * Copyright 2014-2025 TNG Technology Consulting GmbH"," *"," * Licensed under the Apache License, Version 2.0 (the \"License\");"," * you may not use this file except in compliance with the License."," * You may obtain a copy of the License at"," *"," *     http://www.apache.org/licenses/LICENSE-2.0"," *"," * Unless required by applicable law or agreed to in writing, software"," * distributed under the License is distributed on an \"AS IS\" BASIS,"," * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied."," * See the License for the specific language governing permissions and"," * limitations under the License."," */","package com.tngtech.archunit.library.freeze;","","import java.io.File;","import java.io.FileInputStream;","import java.io.FileOutputStream;","import java.io.IOException;","import java.nio.file.Files;","import java.util.List;","import java.util.Properties;","import java.util.UUID;","import java.util.regex.Pattern;","","import com.google.common.base.Splitter;","import com.tngtech.archunit.PublicAPI;","import com.tngtech.archunit.lang.ArchRule;","import org.slf4j.Logger;","import org.slf4j.LoggerFactory;","","import static com.google.common.base.Preconditions.checkArgument;","import static com.google.common.base.Preconditions.checkState;","import static com.google.common.io.Files.toByteArray;","import static com.tngtech.archunit.PublicAPI.Usage.ACCESS;","import static com.tngtech.archunit.PublicAPI.Usage.INHERITANCE;","import s
```

**#23** · core · ok · 307 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4' --jq '.content | @base64d | split("\n") | .[85:180] | join("\n")'`

```
private File storeFolder;
    private FileSyncedProperties storedRules;

    /**
     * Creates a standard {@link TextFileBasedViolationStore} that names rule violation files by random {@link UUID}s
     *
     * @see #TextFileBasedViolationStore(RuleViolationFileNameStrategy)
     */
    public TextFileBasedViolationStore() {
        this(__ -> UUID.randomUUID().toString());
    }

    /**
     * Creates a {@link TextFileBasedViolationStore} with a custom strategy for rule violation file naming
     *
     * @param ruleViolationFileNameStrategy controls how the rule violation file name is derived from the rule description
     */
    public TextFileBasedViolationStore(RuleViolationFileNameStrategy ruleViolationFileNameStrategy) {
        this.ruleViolationFileNameStrategy = ruleViolationFileNameStrategy;
    }

    @Override
    public void initialize(Properties properties) {
        storeCreationAllowed = Boolean.parseBoolean(properties.getProperty(ALLOW_STORE_CREATION_PROPERTY_NAME, ALLOW_STORE_CREATION_DEFAULT));
        storeUpdateAllowed = Boolean.parseBoolean(properties.getProperty(ALLOW_STORE_UPDATE_PROPERTY_NAME, ALLOW_STORE_UPDATE_DEFAULT));
        String path = properties.getProperty(STORE_PATH_PROPERTY_NAME, STORE_PATH_DEFAULT);
        storeFolder = new File(path);
        ensureExistence(storeFolder);
        File storedRulesFile = getStoredRulesFile();
        log.trace("Initializing {} at {}", TextFileBasedViolationStore.class.getSimpleName(), storedRules
```

**#24** · core · ok · 305 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d' --jq '.content | @base64d | split("\n") | .[180:280] | join("\n")'`

```
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
            log.trace("Assigning new file {} to rule '{}'", ruleFileName, ruleDescription);
            storedRules.setProperty(ruleDescription, ruleFileName);
        }
        return ruleFileName;
    }

    @Override
    public List<String> getViolations(ArchRule rule) {
        String ruleDetailsFileName = storedRules.getProperty(rule.getDescription());
        checkArgum
```

**#25** · core · ok · 306 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d' --jq '.content | @base64d | split("\n") | .[85:180] | join("\n")'`

```
private boolean warnEmptyRuleViolation;
    private File storeFolder;
    private FileSyncedProperties storedRules;

    /**
     * Creates a standard {@link TextFileBasedViolationStore} that names rule violation files by random {@link UUID}s
     *
     * @see #TextFileBasedViolationStore(RuleViolationFileNameStrategy)
     */
    public TextFileBasedViolationStore() {
        this(__ -> UUID.randomUUID().toString());
    }

    /**
     * Creates a {@link TextFileBasedViolationStore} with a custom strategy for rule violation file naming
     *
     * @param ruleViolationFileNameStrategy controls how the rule violation file name is derived from the rule description
     */
    public TextFileBasedViolationStore(RuleViolationFileNameStrategy ruleViolationFileNameStrategy) {
        this.ruleViolationFileNameStrategy = ruleViolationFileNameStrategy;
    }

    @Override
    public void initialize(Properties properties) {
        storeCreationAllowed = Boolean.parseBoolean(properties.getProperty(ALLOW_STORE_CREATION_PROPERTY_NAME, ALLOW_STORE_CREATION_DEFAULT));
        storeUpdateAllowed = Boolean.parseBoolean(properties.getProperty(ALLOW_STORE_UPDATE_PROPERTY_NAME, ALLOW_STORE_UPDATE_DEFAULT));
        deleteEmptyRule = Boolean.parseBoolean(properties.getProperty(DELETE_EMPTY_RULE_VIOLATION_PROPERTY_NAME, DELETE_EMPTY_RULE_VIOLATION_DEFAULT));
        warnEmptyRuleViolation = Boolean.parseBoolean(properties.getProperty(WARN_EMPTY_RULE_VIOLATION_PROPERTY_NAME, WARN_EMPTY_R
```

**#26** · core · ok · 312 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4' --jq '.content | @base64d | split("\n") | {lines:length,block:.[0:85]}'`

```
{"block":["/*"," * Copyright 2014-2025 TNG Technology Consulting GmbH"," *"," * Licensed under the Apache License, Version 2.0 (the \"License\");"," * you may not use this file except in compliance with the License."," * You may obtain a copy of the License at"," *"," *     http://www.apache.org/licenses/LICENSE-2.0"," *"," * Unless required by applicable law or agreed to in writing, software"," * distributed under the License is distributed on an \"AS IS\" BASIS,"," * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied."," * See the License for the specific language governing permissions and"," * limitations under the License."," */","package com.tngtech.archunit.library.freeze;","","import java.io.File;","import java.io.FileInputStream;","import java.io.FileOutputStream;","import java.io.IOException;","import java.nio.file.Files;","import java.nio.file.Path;","import java.util.Arrays;","import java.util.List;","import java.util.Properties;","import java.util.Set;","import java.util.UUID;","import java.util.regex.Pattern;","import java.util.stream.Collectors;","","import com.google.common.base.Predicates;","import com.google.common.base.Splitter;","import com.tngtech.archunit.PublicAPI;","import com.tngtech.archunit.lang.ArchRule;","import org.slf4j.Logger;","import org.slf4j.LoggerFactory;","","import static com.google.common.base.Preconditions.checkArgument;","import static com.google.common.base.Preconditions.checkState;","import static com.google.comm
```

**#27** · core · ok · 317 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4' --jq '.content | @base64d | split("\n") | .[280:400] | join("\n")'`

```
private Properties loadRulesFrom(File file) {
            Properties result = new Properties();
            try (FileInputStream inputStream = new FileInputStream(file)) {
                result.load(inputStream);
            } catch (IOException e) {
                throw new StoreInitializationFailedException(e);
            }
            return result;
        }

        boolean containsKey(String propertyName) {
            return loadedProperties.containsKey(ensureUnixLineBreaks(propertyName));
        }

        String getProperty(String propertyName) {
            return loadedProperties.getProperty(ensureUnixLineBreaks(propertyName));
        }

        void setProperty(String propertyName, String value) {
            loadedProperties.setProperty(ensureUnixLineBreaks(propertyName), ensureUnixLineBreaks(value));
            syncFileSystem();
        }

        void removeProperty(String propertyName) {
            loadedProperties.remove(ensureUnixLineBreaks(propertyName));
            syncFileSystem();
        }

        Set<String> keySet() {
            return loadedProperties.stringPropertyNames();
        }

        private void syncFileSystem() {
            try (FileOutputStream outputStream = new FileOutputStream(propertiesFile)) {
                loadedProperties.store(outputStream, "");
            } catch (IOException e) {
                throw new StoreUpdateFailedException(e);
            }
        }
    }

    /**
     * Allows to adjust the rule
```

**#28** · core · ok · 324 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d' --jq '.content | @base64d | split("\n") | .[280:400] | join("\n")'`

```
return loadedProperties.getProperty(ensureUnixLineBreaks(propertyName));
        }

        void setProperty(String propertyName, String value) {
            loadedProperties.setProperty(ensureUnixLineBreaks(propertyName), ensureUnixLineBreaks(value));
            syncFileSystem();
        }

        void removeProperty(String propertyName) {
            loadedProperties.remove(ensureUnixLineBreaks(propertyName));
            syncFileSystem();
        }

        private void syncFileSystem() {
            try (FileOutputStream outputStream = new FileOutputStream(propertiesFile)) {
                loadedProperties.store(outputStream, "");
            } catch (IOException e) {
                throw new StoreUpdateFailedException(e);
            }
        }
    }

    /**
     * Allows to adjust the rule violation file names of {@link TextFileBasedViolationStore}
     *
     * @see TextFileBasedViolationStore#TextFileBasedViolationStore(RuleViolationFileNameStrategy)
     */
    @FunctionalInterface
    @PublicAPI(usage = INHERITANCE)
    public interface RuleViolationFileNameStrategy {
        /**
         * Returns the file name to store violations of an {@link ArchRule}, possibly based on the rule description.<br>
         * The returned names <b>must</b> be sufficiently unique from any others;
         * as long as the descriptions themselves are unique, this can be achieved by sanitizing the description into some sort of file name.
         *
         * @param r
```

**#29** · core · ok · 330 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4' --jq '.content | @base64d | split("\n") | .[180:280] | join("\n")'`

```
@Override
    public boolean contains(ArchRule rule) {
        return storedRules.containsKey(rule.getDescription());
    }

    @Override
    public void save(ArchRule rule, List<String> violations) {
        log.trace("Storing evaluated rule '{}' with {} violations: {}", rule.getDescription(), violations.size(), violations);
        if (!storeUpdateAllowed) {
            throw new StoreUpdateFailedException(String.format(
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
        String ruleDescriptio
```

**#30** · core · ok · 404 ms — `gh api '/repos/TNG/ArchUnit/commits?path=docs/userguide/html/000_Index.html&per_page=100' --jq '[.[]|{sha:.sha,subject:(.commit.message|split("\n")[0])}] | .[:10]'`

```
[{"sha":"6c2d659e5681b50541930d236a8c46aed5e44a5c","subject":"prepare release 1.5.1"},{"sha":"502d782bfbf2632a2c9f943a502ddd8cc3e3c46d","subject":"prepare release 1.5.0"},{"sha":"e45aaa20543b74daeaa09f501b8890742dc7dd8d","subject":"prepare release 1.4.2"},{"sha":"6545053691bed56dacef3d767440e4cd58de739c","subject":"prepare release 1.4.1"},{"sha":"1358b821d1fff18e73799ae1326efbc2067580dd","subject":"improve documentation of slices rules"},{"sha":"c5caa020d13d21c61669bb1cae1a1223e4ce6f3c","subject":"prepare release 1.4.0"},{"sha":"dc7238fc7dfcfc50f5473c0cb3825de3dd9ced72","subject":"prepare release 1.3.0"},{"sha":"17ced0833324760dfdf49aaa07ea00c1fbee63aa","subject":"prepare release 1.2.1"},{"sha":"12e8fb188c4beec33e525b5e491ef3ed5ba252e4","subject":"prepare release 1.2.0"},{"sha":"3ca046cbf87da5bbaf593b6387c95c2765623e96","subject":"chore: updated documentation since accept no longer exists on JavaPackage"}]
```

**#31** · core · ok · 441 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/FreezingArchRule.java?ref=46f4ad65a2775325f174c5997e7a39336cd20801' --jq '.content | @base64d | split("\n") | map(select(test("obsolete|storeUpdate|StoreUpdate|filterResult|result"; "i"))) | .[:55] | join("\n")'`

```
import com.tngtech.archunit.lang.EvaluationResult;
 *   a {@link ViolationStore} to store the result of the current evaluation and retrieve the result of the previous evaluation of this rule.<br>
    public EvaluationResult evaluate(JavaClasses classes) {
        EvaluationResultLineBreakAdapter result = new EvaluationResultLineBreakAdapter(delegate.evaluate(classes));
            return storeViolationsAndReturnSuccess(result);
            return removeObsoleteViolationsFromStoreAndReturnNewViolations(result);
    private EvaluationResult storeViolationsAndReturnSuccess(EvaluationResultLineBreakAdapter result) {
        log.trace("No results present for rule '{}'. Freezing rule result...", delegate.getDescription());
        store.save(delegate, result.getViolations());
        return new EvaluationResult(delegate, result.getPriority());
    private EvaluationResult removeObsoleteViolationsFromStoreAndReturnNewViolations(EvaluationResultLineBreakAdapter result) {
        log.trace("Found frozen result for rule '{}'", delegate.getDescription());
        CategorizedViolations categorizedViolations = new CategorizedViolations(matcher, result, knownViolations);
        EvaluationResult filteredResult = filterOutKnownViolations(result, categorizedViolations.getKnownActualViolations());
            removeObsoleteViolationsFromStore(categorizedViolations);
        } catch (StoreUpdateFailedException e) {
            if (!filteredResult.hasViolation()) {
            log.warn("Failed
```

**#32** · search · ok · 720 ms — `gh search prs 'empty rule' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","url":"https://github.com/TNG/ArchUnit/pull/1405"}]
```

**#33** · search · ok · 773 ms — `gh search prs 'stored.rules' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"number":1656,"state":"merged","title":"Make TextFileBasedViolationStore thread-safe under parallel test execution","url":"https://github.com/TNG/ArchUnit/pull/1656"},{"number":795,"state":"closed","title":"we ensure that the `stored.rules`-file is sorted alphabetically","url":"https://github.com/TNG/ArchUnit/pull/795"},{"number":438,"state":"merged","title":"Run tests against Java 15 during CI","url":"https://github.com/TNG/ArchUnit/pull/438"},{"number":181,"state":"merged","title":"Provide a way to store all current violations of a rule and successively only report new ones","url":"https://github.com/TNG/ArchUnit/pull/181"}]
```

**#34** · search · ok · 775 ms — `gh search prs 'remove frozen' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`
→ `[]`

**#35** · search · ok · 782 ms — `gh search issues 'stored.rules' --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","url":"https://github.com/TNG/ArchUnit/issues/1264"},{"number":1654,"state":"closed","title":"`TextFileBasedViolationStore` is not thread-safe under parallel test execution","url":"https://github.com/TNG/ArchUnit/issues/1654"},{"number":1025,"state":"closed","title":"[suggestion] add test name to frozen violation guid files","url":"https://github.com/TNG/ArchUnit/issues/1025"},{"number":1026,"state":"closed","title":"[suggestion] sort violations in guid files alphabetically","url":"https://github.com/TNG/ArchUnit/issues/1026"},{"number":902,"state":"closed","title":"Specify file name for freeze?","url":"https://github.com/TNG/ArchUnit/issues/902"},{"number":510,"state":"closed","title":"Frozen rules not updated when new violation occurs","url":"https://github.com/TNG/ArchUnit/issues/510"}]
```

**#36** · core · ok · 1018 ms — `gh issue view 1264 --repo TNG/ArchUnit --json title,body,url,comments --jq '{title,body,url,comments:[.comments[] | {body:.body,author:.author.login}]}'`

```
{"body":"Hi ArchUnit Team,\r\n\r\nFirst of you do a great job here. ArchUnit is great.\r\n\r\nIn our project we currently have \u003e70 freeze files in the stored.rules mentioned.\r\n\r\nDigging deeper I noticed several things, which I am concerned about.\r\n\r\n1. The files referenced might not exist anymore, but the reference in stored.rules is\r\n2. When freeze files become empty you are not being advised to remove the freezing from your test. \r\n3. Freeze files might still be in the archunit folder, but not referenced anymore\r\n4. Tests were removed without removing the stored.rules line or freeze file\r\n5. stored.rules are not sorted. To make it better human readable it would be nice to have it sorted alphabetically.\r\n\r\nOf course in the end it is our job to keep our source code in check and clean up correctly etc.\r\n\r\nYet I wonder how ArchUnit itself can help to have a sanity check of its freeze files and stored.rules?\r\n\r\nWhat is your opinion on this?","comments":[{"author":"codecholeric","body":"Sorry for the late reply, I think it would be a nice addition, if anybody wants to give this a shot I would support it! In the past we've already sorted the actual violations alphabetically to ease human browsing and diffs if I remember correctly."},{"author":"maxxkia","body":"Hello 👋 \nI would like to work on this!"},{"author":"maxxkia","body":"Hi @codecholeric \n\nI have created https://github.com/TNG/ArchUnit/pull/1405 which solves parts of the features requeste
```

**#37** · core · ok · 498 ms — `gh api '/repos/TNG/ArchUnit/compare/ab6a677dd4b678f0ab1d9481df17222916705170...main' --jq '{status:.status,ahead_by:.ahead_by,commits:[.commits[]|select((.commit.message|ascii_downcase|test("freeze|integrity|obsolete|violation|store")))|{sha:.sha,subject:(.commit.message|split("\n")[0])}]}'`

```
{"ahead_by":48,"commits":[{"sha":"3706aa51a944a2cb740c109399978e893c651f81","subject":"add haveOnlyFinalNonSyntheticFields() to ignore synthetic fields"},{"sha":"ef178491974a38cc05a353d33e3b572b4fe4f5f7","subject":"add haveOnlyFinalNonSyntheticFields() to ignore synthetic fields (#1747)"}],"status":"ahead"}
```

**#38** · core · ok · 649 ms — `gh pr view 1656 --repo TNG/ArchUnit --json files,body,url --jq '{files:[.files[].path],body:.body,url:.url}'`

```
{"body":"Multiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore and load stored.rules into their own private snapshot. Concurrent saves caused a lost-update: the last writer overwrote the file with only its own entries.\r\n\r\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a static ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that atomically checks, sets, and flushes to disk under one lock.\r\n\r\nFixes #1654.","files":["archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java","archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreConcurrencyTest.java","archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java"],"url":"https://github.com/TNG/ArchUnit/pull/1656"}
```

**#39** · core · ok · 299 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java&per_page=100' --jq 'map({sha:.sha,subject:(.commit.message|split("\n")[0])})'`
→ `[]`

**#40** · core · ok · 314 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java&sha=ab6a677dd4b678f0ab1d9481df17222916705170&per_page=100' --jq 'map({sha:.sha,subject:(.commit.message|split("\n")[0])})'`
→ `[]`
