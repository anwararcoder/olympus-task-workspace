# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · med confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-09-29 22:35
- **Investigation:** 43 gh calls · 14 gh searches · 1 upstream requests · 635.946s

The older tasks do not supply the freeze-store implementation. Public ArchUnit work covers limited cleanup and naming behavior, but leaves the integrity engine and most graded cases uncovered. The task fits the repository.

## Reasoning

I adopt the eight supplied distinct rulings. For the measured same-repo comparison, [another submission] shares 0/779 discounted subject non-blank solution lines (0%), and 0/566 candidate lines (0%): the current subject total is 850, less 25 generated-guide lines, 45 boilerplate-header lines, and one pre-existing UUID expression. Those stated integers give a clear-minority band, consistent with the recorded non-binding shapes; no worksheet criterion flips the ruling. Its build-file contact is between this submission's TEST setup and different importer work. The other seven flagged candidates supply no shared freeze-store solution block. Re-reading the full slate as a set finds neither distinct major part-sources nor a recurring core kit: union coverage is 0/779 (0%), with nothing from the corpus to stack with public code. I also checked the previous run's extra, unflagged [another submission] against its description and full patch: its Rust OPTIONS-manifest and checkpoint machinery does not implement this Java freeze store. The prior 758-line denominator and 145-test denominator do not describe the current supplied patches; my count of the current maintenance class is 148 @Test functions, excluding the already-existing baseline suites.

I checked commit-by-path histories for all three newly created Java paths (no predecessor) and the changed store and guide paths, searched open and closed PRs/issues under freeze, stored.rules, obsolete rules, naming, and integrity, and read the relevant implementing sources in this run. PR #1407 at b0631bc, archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java, removeObsoleteRules, removes index mappings for absent files; its removeObsoleteRuleFiles also deletes unowned files, contrary to this task. PR #1405 at 4952aae, the same path, save/deleteRuleFile, conditionally deletes a known rule's file and mapping on an empty save and skips an unknown one, without shared-file safeguards. Issue #1045's complete posted newRuleFileName method supplies simple deterministic, sanitized description names, but not collision-resistant names or the required naming guarantees. These are code from this repo or a contributor's copy of its store, not an uncounted outside-codebase port. PR #1046's constructor strategy and PR #1656's canonical-path index cache/synchronized insertion are already in the pinned base, so neither adds marginal crib coverage.

A generous marginal upper bound from those three public sources is 18/148 graded maintenance functions (12.2%), with 130/148 remaining. The counted contributions, rather than the base store behavior or the description's requirements, are: #1407 supplies missing-mapping pruning for absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry and ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry (the repair-side deletion in each); repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne (delete only its missing mapping); anEntryWhoseFileIsAbsentIsBroken (detect/delete it); everyBrokenEntryIsDiscarded (delete multiple missing mappings); aSeparatelyCreatedStoreObservesTheRepairedIndex (persist that pruning); repairKeepsAStillViolatingRuleFrozenWithItsViolations (prune its absent sibling); repairWithoutPermissionToUpdateIsRejectedAndChangesNothing (reject an attempted missing-mapping removal when updates are forbidden); aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical (write on missing-mapping removal, not on a clean pass); and arepairThatChangesNothingLeavesTheIndexByteIdentical (the first pruning followed by no further pruning). #1405 supplies known-empty-save deletion for storingNoViolationsUnderRepairForgetsTheEntryAndItsFile; the conditional deletion branch for onlyRepairForgetsAResolvedRuleWhileFailKeepsIt; delete-before-mapping-removal for forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry; and the unknown-empty-save skip for forgettingARuleTheIndexNeverKnewStoresNothingForIt. Issue #1045 supplies the actual sanitized description-name computation for namesTakenFromTheDescriptionShowTheRuleTheyStore, aRuleKeepsTheSameNameInALaterRun, aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds, and violationsAreReadBackFromANameTakenFromTheDescription; the base's existing index read/write is not credited. These are generous partial crib credits, not claims that the public branches as-is pass each entire test. Neither test coverage nor hard-implementation coverage reaches half: filesystem/link identity, condition precedence and ordered reporting, safe occupancy and relocation, synchronization of examinations with in-progress saves, strategy configuration, and robust fingerprinted naming still require the principal new machinery. No corpus part-source closes that remainder.

Issue #1264 explicitly welcomes a freeze-store sanity check. Issue #902 objects to documenting an internal file format as public API, PR #795 objects to a Properties subclass, and PR #1046 expresses only a hedged preference against configuring a naming SPI; none rejects this capability. The pinned README and freezing guide describe an extensible library whose text violation files can be version controlled and reduced as violations are fixed. This maintenance task aligns with that purpose. There is no confirmed shipped full fix, removed capability, maintainer won't-have, or task-level contradiction.

## Findings (9)

### overlap — Low severity

- **Claim:** distinct — [another submission]; concurrent stores are only a motivation-level resemblance, not shared freeze-store code.

### overlap — Low severity

- **Claim:** distinct — [another submission]; preserving unaffected rule-related work is thematic, not common implementation.

### overlap — Low severity

- **Claim:** distinct — [another submission]; integrity is a theme across different storage engines, not a reusable freeze-store core.

### overlap — Low severity

- **Claim:** distinct — [another submission]; its importer work shares 0/779 discounted subject solution lines (0%), versus 0/566 candidate lines.

### overlap — Low severity

- **Claim:** distinct — [another submission], the extra candidate cited by the previous run but not in the current eight-candidate slate; persisted database-option validation is motivation-only here.

### publicly-solved — Medium severity

- **Claim:** Open PR #1407 publicly supplies partial missing-file index cleanup, contributing at most 10/148 graded maintenance tests; its treatment of unowned files conflicts with this task.
- **Evidence:** "https://github.com/TNG/ArchUnit/pull/1407 — archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java, removeObsoleteRules: .filter(ruleDescription -> !new File(storeFolder, storedRules.getProperty(ruleDescription)).exists())"

### publicly-solved — Medium severity

- **Claim:** Open PR #1405 publicly supplies partial empty-save deletion, contributing at most 4/148 graded maintenance tests without shared-file or path safeguards.
- **Evidence:** "https://github.com/TNG/ArchUnit/pull/1405 — archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java, save: if (violations.isEmpty() && deleteEmptyRule) {"

### publicly-solved — Medium severity

- **Claim:** Issue #1045 contains a contributor's working simple deterministic description-naming method, contributing at most 4/148 graded maintenance tests but not the specified built-in naming guarantees.
- **Evidence:** "https://github.com/TNG/ArchUnit/issues/1045#issuecomment-1402273844 — DeterministicTextFileBasedViolationStore.newRuleFileName: String s = description.replace(' ', '_').replaceAll("[^a-zA-Z0-9_-]", "");"

### publicly-solved — Medium severity

- **Claim:** Hedged maintainer design caution in PR #1046 about a configuration-loaded naming SPI; this is not a rejection of the capability.
- **Evidence:** "https://github.com/TNG/ArchUnit/pull/1046#issuecomment-1403192283 — the latter seems a little overkill for this case to me"

## Investigation Log (43 commands)

**#0** · core · ok · 722 ms — `gh pr view 1407 --repo TNG/ArchUnit --json number,title,url,state,headRefOid,body,comments,reviews`

```
{"body":"These changes bring 2 features\r\n* clean up of frozen rules in `stored.rules` where the corresponding file does not exist in the store directory\r\n* clean up of files in store directory which are not referenced in `stored.rules` file\r\nBoth of the above operations are enabled using `default.allowStoreUpdate` property. If `default.allowStoreUpdate=false` and obsolete entries or files are found by either of the above operations, the operation fails with an `StoreUpdateFailedException`.\r\n\r\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\r\n\r\nResolves #1264","comments":[],"headRefOid":"b0631bc58a5db6bf4069278e22e7e689bfacd9d4","number":1407,"reviews":[{"id":"PRR_kwDOBU1z-s6aFiCB","author":{"login":"maxxkia"},"authorAssociation":"NONE","body":"","submittedAt":"2025-01-30T21:56:36Z","includesCreatedEdit":false,"reactionGroups":[],"state":"COMMENTED","commit":{"oid":"b0631bc58a5db6bf4069278e22e7e689bfacd9d4"}}],"state":"OPEN","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"}
```

**#1** · core · ok · 831 ms — `gh pr view 1405 --repo TNG/ArchUnit --json number,title,url,state,headRefOid,body,comments,reviews`

```
{"body":"These changes introduce two new features for FreezingRule default store\r\n* Raise error when a freezing rule has zero violations. This can be enabled by setting the property `default.warnEmptyRuleViolation=true`. For backward compatibility it is disabled by default.\r\n* Skip rule violation file creation or delete if it already exists, when there are zero violations. This can be enabled by setting the property `default.deleteEmptyRuleViolation=true`, it is disabled by default.\r\n\r\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\r\n\r\nResolves #1264","comments":[],"headRefOid":"4952aae7799e1f08e5b1877dfc1e0395f29a4b3d","number":1405,"reviews":[{"id":"PRR_kwDOBU1z-s6YpYMx","author":{"login":"maxxkia"},"authorAssociation":"NONE","body":"","submittedAt":"2025-01-19T11:42:15Z","includesCreatedEdit":false,"reactionGroups":[],"state":"COMMENTED","commit":{"oid":"90c5338e7f5dcfa34fa9fa1ab177089ec8b1c3db"}},{"id":"PRR_kwDOBU1z-s6YpYXh","author":{"login":"maxxkia"},"authorAssociation":"NONE","body":"","submittedAt":"2025-01-19T11:45:49Z","includesCreatedEdit":false,"reactionGroups":[],"state":"COMMENTED","commit":{"oid":"90c5338e7f5dcfa34fa9fa1ab177089ec8b1c3db"}},{"id":"PRR_kwDOBU1z-s6YpgLE","author":{"login":"maxxkia"},"authorAssociation":"NONE","body":"","submittedAt":"2025-01-19T14:06:18Z","includesCreatedEdit":false,"reactionGroups":[],"state":"COMMENTED","commit":{"oid":"60de7abdc55de7b1b4b160c1331a9556935cef86"}}],"state":"OPEN","title":"ra
```

**#2** · search · ok · 902 ms — `gh search prs "freeze store" --repo TNG/ArchUnit --limit 60 --json number,title,url,state,createdAt`

```
[{"createdAt":"2023-01-20T10:54:41Z","number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"createdAt":"2020-09-27T19:29:01Z","number":438,"state":"merged","title":"Run tests against Java 15 during CI","url":"https://github.com/TNG/ArchUnit/pull/438"}]
```

**#3** · search · ok · 923 ms — `gh search issues "freeze store" --repo TNG/ArchUnit --limit 60 --json number,title,url,state,createdAt`

```
[{"createdAt":"2026-08-13T08:06:28Z","number":1700,"state":"open","title":"Surfacing freeze store size as a signal: a green build is compatible with a growing store","url":"https://github.com/TNG/ArchUnit/issues/1700"},{"createdAt":"2025-07-25T14:17:50Z","number":1494,"state":"open","title":"Bad Frozen error messages","url":"https://github.com/TNG/ArchUnit/issues/1494"},{"createdAt":"2022-12-02T08:27:24Z","number":1015,"state":"open","title":"Do not include line numbers in freezed messages","url":"https://github.com/TNG/ArchUnit/issues/1015"},{"createdAt":"2021-09-23T03:35:49Z","number":676,"state":"open","title":"FreezingArchRule: No longer violating a rule should under no circumstances break the test","url":"https://github.com/TNG/ArchUnit/issues/676"},{"createdAt":"2023-06-20T09:00:06Z","number":1124,"state":"closed","title":"ArchUnit generates different set of violations rules depending on java bytecode version","url":"https://github.com/TNG/ArchUnit/issues/1124"},{"createdAt":"2021-01-12T12:35:42Z","number":510,"state":"closed","title":"Frozen rules not updated when new violation occurs","url":"https://github.com/TNG/ArchUnit/issues/510"},{"createdAt":"2021-01-12T11:51:56Z","number":508,"state":"closed","title":"Use of System.lineSeparator() prevents development on heterogenous systems","url":"https://github.com/TNG/ArchUnit/issues/508"},{"createdAt":"2020-10-22T10:19:31Z","number":456,"state":"closed","title":"ViolationStoreFactory throws StoreUpdateFailedException when
```

**#4** · core · ok · 1656 ms — `gh issue view 1045 --repo TNG/ArchUnit --comments`

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

**#5** · core · ok · 1818 ms — `gh issue view 1264 --repo TNG/ArchUnit --comments`

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

**#6** · core · ok · 436 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleDescriptionFileNames.java&per_page=100' --jq '[.[] | {sha, date:.commit.committer.date, message:.commit.message}]'`
→ `[]`

**#7** · core · ok · 469 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleViolationFileNameStrategyFactory.java&per_page=100' --jq '[.[] | {sha, date:.commit.committer.date, message:.commit.message}]'`
→ `[]`

**#8** · core · ok · 477 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java&per_page=100' --jq '[.[] | {sha, date:.commit.committer.date, message:.commit.message}]'`
→ `[]`

**#9** · core · ok · 557 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java&per_page=100' --jq '[.[] | {sha, date:.commit.committer.date, message:.commit.message}]'`

```
[{"date":"2026-07-23T07:06:08Z","message":"Make TextFileBasedViolationStore thread-safe under parallel test execution\n\nMultiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore\nand load stored.rules into their own private snapshot. Concurrent saves caused a\nlost-update: the last writer overwrote the file with only its own entries.\n\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a\nstatic ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that\natomically checks, sets, and flushes to disk under one lock.\n\n- Move directory creation into FileSyncedProperties.initializePropertiesFile\n- Use mkdirs() || isDirectory() to handle the race where a concurrent process\n  creates the directory between mkdirs() returning false and the isDirectory check\n- Add TextFileBasedViolationStoreConcurrencyTest with separate initialize-race and\n  save-race scenarios\n- Convert both test classes from JUnit 4 to JUnit 5\n\nCo-Authored-By: <model> \u003cnoreply@<provider>.com\u003e\nSigned-off-by: Niklas Keller \u003cniklas@chrono24.com\u003e","sha":"48f6118f0f5b64d4174c0b51d68dbf117708a103"},{"date":"2026-01-07T07:25:02Z","message":"update copyright to new year 2026\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke@tngtech.com\u003e","sha":"92fe06c5c1173c920688c0ddf7287f0db0ade599"},{"date":"2025-01-08T07:20:57Z","message":"update copyright to new year 2025\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke
```

**#10** · core · ok · 570 ms — `gh api '/repos/TNG/ArchUnit/commits?path=docs/userguide/008_The_Library_API.adoc&per_page=100' --jq '[.[] | {sha, date:.commit.committer.date, message:.commit.message}]'`

```
[{"date":"2026-07-28T22:53:05Z","message":"add package matcher section to user guide\n\n* add a detailed part to the core API section, as PackageMatching resides there.\n* reference the detailed section where the current user guide already touches the topic\n* adjust css to fix rendering issue with codeboxes containing only the `.` (dot) character\n\nSigned-off-by: Andreas Zöller \u003candreas.zoeller@tngtech.com\u003e","sha":"733ae8b53629c6dbfb5713a99a11eb4a4839d571"},{"date":"2026-07-27T08:28:40Z","message":"Document JUnit 6 support in user guide\n\nSigned-off-by: Dr. Jonathan Schulz \u003cjonathan.schulz@tngtech.com\u003e","sha":"abbf1bd18650b45cff0d5a79397d3bc4b6a60f38"},{"date":"2025-05-04T16:13:32Z","message":"improve documentation of slices rules\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke@tngtech.com\u003e","sha":"1358b821d1fff18e73799ae1326efbc2067580dd"},{"date":"2024-04-10T22:08:23Z","message":"upgrade asciidoctor dependencies\n\nhttps://github.com/asciidoctor/asciidoctor-diagram/releases/tag/v2.2.6\nupdates PlantUML from 1.2022.14 to 1.2023.4.\n\nSince plantuml-1.2023.2,\n```\npackage com.myapp.application\n```\nproduces 3 boxes instead of one by default.\n\ncf. https://plantuml.com/news:\n* 2 Feb, 2023: Important change about package and namespace\n\u003e\n\u003e Starting with version 1.2023.2 (which is online as a beta),\n\u003e PlantUML handles differently namespaces and packages.\n\u003e\n\u003e There won't be any difference between namespaces and pack
```

**#11** · core · ok · 700 ms — `gh api '/repos/TNG/ArchUnit/commits?path=docs/userguide/html/000_Index.html&per_page=100' --jq '[.[] | {sha, date:.commit.committer.date, message:.commit.message}]'`

```
[{"date":"2026-09-25T06:31:58Z","message":"prepare release 1.5.1\n\nSigned-off-by: schulzjo-tng \u003caction@github.com\u003e","sha":"6c2d659e5681b50541930d236a8c46aed5e44a5c"},{"date":"2026-08-04T00:06:03Z","message":"prepare release 1.5.0\n\nSigned-off-by: hankem \u003caction@github.com\u003e","sha":"502d782bfbf2632a2c9f943a502ddd8cc3e3c46d"},{"date":"2026-04-18T19:28:21Z","message":"prepare release 1.4.2\n\nSigned-off-by: hankem \u003caction@github.com\u003e","sha":"e45aaa20543b74daeaa09f501b8890742dc7dd8d"},{"date":"2025-05-07T19:53:45Z","message":"prepare release 1.4.1\n\nSigned-off-by: hankem \u003caction@github.com\u003e","sha":"6545053691bed56dacef3d767440e4cd58de739c"},{"date":"2025-05-04T16:13:32Z","message":"improve documentation of slices rules\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke@tngtech.com\u003e","sha":"1358b821d1fff18e73799ae1326efbc2067580dd"},{"date":"2025-02-10T20:27:24Z","message":"prepare release 1.4.0\n\nSigned-off-by: hankem \u003caction@github.com\u003e","sha":"c5caa020d13d21c61669bb1cae1a1223e4ce6f3c"},{"date":"2024-04-11T13:31:33Z","message":"prepare release 1.3.0\n\nSigned-off-by: codecholeric \u003caction@github.com\u003e","sha":"dc7238fc7dfcfc50f5473c0cb3825de3dd9ced72"},{"date":"2023-12-03T23:07:14Z","message":"prepare release 1.2.1\n\nSigned-off-by: codecholeric \u003caction@github.com\u003e","sha":"17ced0833324760dfdf49aaa07ea00c1fbee63aa"},{"date":"2023-11-06T00:06:22Z","message":"prepare release 1.2.0\n\nSigned-off-by: codechol
```

**#12** · search · ok · 872 ms — `gh search issues "integrity" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`
→ `[]`

**#13** · search · ok · 880 ms — `gh search prs "violation store" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`

```
[{"number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","url":"https://github.com/TNG/ArchUnit/pull/1405"},{"number":1075,"state":"merged","title":"Ensure final newline in violation store files","url":"https://github.com/TNG/ArchUnit/pull/1075"},{"number":516,"state":"merged","title":"fix line ending problems in FreezingArchRule","url":"https://github.com/TNG/ArchUnit/pull/516"},{"number":252,"state":"merged","title":"Enhance FreezingArchRule","url":"https://github.com/TNG/ArchUnit/pull/252"}]
```

**#14** · search · ok · 978 ms — `gh search issues "stored.rules" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`

```
[{"number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","url":"https://github.com/TNG/ArchUnit/issues/1264"},{"number":1654,"state":"closed","title":"`TextFileBasedViolationStore` is not thread-safe under parallel test execution","url":"https://github.com/TNG/ArchUnit/issues/1654"},{"number":1025,"state":"closed","title":"[suggestion] add test name to frozen violation guid files","url":"https://github.com/TNG/ArchUnit/issues/1025"},{"number":1026,"state":"closed","title":"[suggestion] sort violations in guid files alphabetically","url":"https://github.com/TNG/ArchUnit/issues/1026"},{"number":902,"state":"closed","title":"Specify file name for freeze?","url":"https://github.com/TNG/ArchUnit/issues/902"},{"number":510,"state":"closed","title":"Frozen rules not updated when new violation occurs","url":"https://github.com/TNG/ArchUnit/issues/510"}]
```

**#15** · search · ok · 1334 ms — `gh search prs "obsolete" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`

```
[{"number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"number":1562,"state":"open","title":"Add `com.tngtech.archunit.openrewrite.SanityCheck`","url":"https://github.com/TNG/ArchUnit/pull/1562"},{"number":1681,"state":"merged","title":"Bump gradle/actions from 6 to 6.2.0","url":"https://github.com/TNG/ArchUnit/pull/1681"},{"number":1278,"state":"merged","title":"fix issues with build dependencies and test execution","url":"https://github.com/TNG/ArchUnit/pull/1278"},{"number":1096,"state":"merged","title":"Fix missing try-catch-blocks in lambdas","url":"https://github.com/TNG/ArchUnit/pull/1096"},{"number":1028,"state":"closed","title":"add JDK 19 to CI build","url":"https://github.com/TNG/ArchUnit/pull/1028"},{"number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"number":904,"state":"merged","title":"Add API to create ArchConditions from predicates","url":"https://github.com/TNG/ArchUnit/pull/904"},{"number":876,"state":"merged","title":"Improve `ArchCondition` evaluation","url":"https://github.com/TNG/ArchUnit/pull/876"},{"number":778,"state":"merged","title":"implement containNumberOfElements for members ","url":"https://github.com/TNG/ArchUnit/pull/778"},{"number":794,"state":"merged","title":"Add predefined ImportOption to exclude package-info.class files","url":"https://github.com/TNG/ArchUnit/pull/794"}
```

**#16** · core · ok · 378 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d' --jq '.content | @base64d | split("\n") | length'`
→ `322`

**#17** · core · ok · 487 ms — `gh pr view 1656 --repo TNG/ArchUnit --json title,url,headRefOid,state,body`

```
{"body":"Multiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore and load stored.rules into their own private snapshot. Concurrent saves caused a lost-update: the last writer overwrote the file with only its own entries.\r\n\r\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a static ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that atomically checks, sets, and flushes to disk under one lock.\r\n\r\nFixes #1654.","headRefOid":"48f6118f0f5b64d4174c0b51d68dbf117708a103","state":"MERGED","title":"Make TextFileBasedViolationStore thread-safe under parallel test execution","url":"https://github.com/TNG/ArchUnit/pull/1656"}
```

**#18** · core · ok · 512 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4' --jq '.content | @base64d | split("\n") | length'`
→ `341`

**#19** · search · ok · 894 ms — `gh search prs "stored.rules" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`

```
[{"number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"number":1656,"state":"merged","title":"Make TextFileBasedViolationStore thread-safe under parallel test execution","url":"https://github.com/TNG/ArchUnit/pull/1656"},{"number":795,"state":"closed","title":"we ensure that the `stored.rules`-file is sorted alphabetically","url":"https://github.com/TNG/ArchUnit/pull/795"},{"number":438,"state":"merged","title":"Run tests against Java 15 during CI","url":"https://github.com/TNG/ArchUnit/pull/438"},{"number":181,"state":"merged","title":"Provide a way to store all current violations of a rule and successively only report new ones","url":"https://github.com/TNG/ArchUnit/pull/181"}]
```

**#20** · search · ok · 1193 ms — `gh search prs "cleanup" --repo TNG/ArchUnit --limit 50 --json number,title,state,url`

```
[{"number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"number":1717,"state":"merged","title":"cleanup ClassFileImporterAnnotationsTest and minor other locations","url":"https://github.com/TNG/ArchUnit/pull/1717"},{"number":1658,"state":"closed","title":"[part2]add support JUnit 6.x testing framework. ","url":"https://github.com/TNG/ArchUnit/pull/1658"},{"number":1685,"state":"merged","title":"Bump gradle/actions from 6.2.0 to 6.3.0","url":"https://github.com/TNG/ArchUnit/pull/1685"},{"number":1681,"state":"merged","title":"Bump gradle/actions from 6 to 6.2.0","url":"https://github.com/TNG/ArchUnit/pull/1681"},{"number":1569,"state":"merged","title":"Adjust AnalyzeClasses annotation to support individual classes as parameter","url":"https://github.com/TNG/ArchUnit/pull/1569"},{"number":1646,"state":"merged","title":"Bump com.gradleup.shadow from 9.4.2 to 9.4.3","url":"https://github.com/TNG/ArchUnit/pull/1646"},{"number":1644,"state":"merged","title":"Bump concurrent-ruby from 1.3.6 to 1.3.7 in /docs","url":"https://github.com/TNG/ArchUnit/pull/1644"},{"number":1649,"state":"closed","title":"Bump junit5 from 5.14.4 to 6.1.1","url":"https://github.com/TNG/ArchUnit/pull/1649"},{"number":1640,"state":"merged","title":"Bump actions/checkout from 6 to 7","url":"https://github.com/TNG/ArchUnit/pull/1640"},{"number":1554,"state":"merged","title":"Bump actions/checkout from 5 to 6","url":"https://github.com/TNG/ArchU
```

**#21** · search · ok · 1236 ms — `gh search issues "filename" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`

```
[{"number":668,"state":"open","title":"Differentiate objects of different languages","url":"https://github.com/TNG/ArchUnit/issues/668"},{"number":1669,"state":"closed","title":"Overridding methods show up in addition to their parent method","url":"https://github.com/TNG/ArchUnit/issues/1669"},{"number":1025,"state":"closed","title":"[suggestion] add test name to frozen violation guid files","url":"https://github.com/TNG/ArchUnit/issues/1025"},{"number":136,"state":"closed","title":"Dependencies should consider annotations","url":"https://github.com/TNG/ArchUnit/issues/136"},{"number":791,"state":"closed","title":"Add locations of architecture violations to stack trace","url":"https://github.com/TNG/ArchUnit/issues/791"},{"number":373,"state":"closed","title":"Dependency should also consider parameter annotations","url":"https://github.com/TNG/ArchUnit/issues/373"},{"number":211,"state":"closed","title":"Enhance Freezing for CI executions","url":"https://github.com/TNG/ArchUnit/issues/211"}]
```

**#22** · core · ok · 1253 ms — `gh pr view 795 --repo TNG/ArchUnit --comments`

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

**#23** · core · ok · 1474 ms — `gh pr view 1046 --repo TNG/ArchUnit --comments`

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

**#24** · core · ok · 1742 ms — `gh issue view 902 --repo TNG/ArchUnit --comments`

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

**#25** · core · ok · 300 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4' --jq '.content | @base64d | split("\n") | .[240:341] | join("\n")'`

```
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
        private final Properties loadedProperties;

        FileSyncedProperties(File file) {
            propertiesFile = initializePropertiesFile(file);
            loadedProperties = initializationSuccessful() ? loadRulesFrom(propertiesFile) : null;
        }

        boolean initializationSuccessful() {
            return propertiesFile != null;
        }

        private File initializePropertiesFile(File file) {
            boolean fileAvailable;
            try {
                fileAvailable = file.exists() || file.createNewFile();
            } catch (IOException e) {
                fileAvailable = false;
            }
            return fileAvailable ? file : null;
        }

        private Properties loadRulesFrom(File file) {
            Properties result = new
```

**#26** · core · ok · 324 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4' --jq '.content | @base64d | split("\n") | .[120:240] | join("\n")'`

```
private File getStoredRulesFile() {
        File rulesFile = new File(storeFolder, STORED_RULES_FILE_NAME);
        if (!rulesFile.exists() && !storeCreationAllowed) {
            throw new StoreInitializationFailedException(String.format(
                    "Creating new violation store is disabled (enable by configuration %s.%s=true)",
                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_CREATION_PROPERTY_NAME));
        }
        return rulesFile;
    }

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
```

**#27** · core · ok · 331 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d' --jq '.content | @base64d | split("\n") | .[0:120] | join("\n")'`

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

**#28** · core · ok · 330 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d' --jq '.content | @base64d | split("\n") | .[240:322] | join("\n")'`

```
}

    private static class FileSyncedProperties {
        private final File propertiesFile;
        private final Properties loadedProperties;

        FileSyncedProperties(File file) {
            propertiesFile = initializePropertiesFile(file);
            loadedProperties = initializationSuccessful() ? loadRulesFrom(propertiesFile) : null;
        }

        boolean initializationSuccessful() {
            return propertiesFile != null;
        }

        private File initializePropertiesFile(File file) {
            boolean fileAvailable;
            try {
                fileAvailable = file.exists() || file.createNewFile();
            } catch (IOException e) {
                fileAvailable = false;
            }
            return fileAvailable ? file : null;
        }

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

        void setProperty(String prop
```

**#29** · core · ok · 337 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d' --jq '.content | @base64d | split("\n") | .[120:240] | join("\n")'`

```
}

    private File getStoredRulesFile() {
        File rulesFile = new File(storeFolder, STORED_RULES_FILE_NAME);
        if (!rulesFile.exists() && !storeCreationAllowed) {
            throw new StoreInitializationFailedException(String.format(
                    "Creating new violation store is disabled (enable by configuration %s.%s=true)",
                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_CREATION_PROPERTY_NAME));
        }
        return rulesFile;
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
```

**#30** · core · ok · 399 ms — `gh api '/repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4' --jq '.content | @base64d | split("\n") | .[0:120] | join("\n")'`

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

**#31** · search · ok · 913 ms — `gh search prs "integrity" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`

```
[{"number":1338,"state":"merged","title":"Bump gradle/actions from 3 to 4","url":"https://github.com/TNG/ArchUnit/pull/1338"}]
```

**#32** · search · ok · 1131 ms — `gh search prs "file names" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`

```
[{"number":1294,"state":"merged","title":"run tests with JUnit Platform","url":"https://github.com/TNG/ArchUnit/pull/1294"},{"number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"number":690,"state":"merged","title":"Public getters for source code location","url":"https://github.com/TNG/ArchUnit/pull/690"}]
```

**#33** · search · ok · 1356 ms — `gh search issues "freeze" --repo TNG/ArchUnit --limit 80 --json number,title,state,url`

```
[{"number":1494,"state":"open","title":"Bad Frozen error messages","url":"https://github.com/TNG/ArchUnit/issues/1494"},{"number":226,"state":"open","title":"Freeze Rule Sets","url":"https://github.com/TNG/ArchUnit/issues/226"},{"number":1700,"state":"open","title":"Surfacing freeze store size as a signal: a green build is compatible with a growing store","url":"https://github.com/TNG/ArchUnit/issues/1700"},{"number":1015,"state":"open","title":"Do not include line numbers in freezed messages","url":"https://github.com/TNG/ArchUnit/issues/1015"},{"number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","url":"https://github.com/TNG/ArchUnit/issues/1264"},{"number":1563,"state":"open","title":"Freezing violations should include all violations in the store?","url":"https://github.com/TNG/ArchUnit/issues/1563"},{"number":981,"state":"open","title":"callMethod() ignores lambdas","url":"https://github.com/TNG/ArchUnit/issues/981"},{"number":750,"state":"open","title":"Feature Request: Import architecture breaks into SonarQube","url":"https://github.com/TNG/ArchUnit/issues/750"},{"number":1045,"state":"open","title":"[suggestion] Allow the mechanism for creating a file name for frozen violations to be specified via an SPI or similar.","url":"https://github.com/TNG/ArchUnit/issues/1045"},{"number":676,"state":"open","title":"FreezingArchRule: No longer violating a rule should under no circumstances break the test","url":"http
```

**#34** · core · ok · 461 ms — `gh api '/repos/TNG/ArchUnit/commits?path=docs/userguide/008_The_Library_API.adoc&per_page=100' --jq '.[0:3] | map({sha, message:(.commit.message|split("\n")[0])})'`

```
[{"message":"add package matcher section to user guide","sha":"733ae8b53629c6dbfb5713a99a11eb4a4839d571"},{"message":"Document JUnit 6 support in user guide","sha":"abbf1bd18650b45cff0d5a79397d3bc4b6a60f38"},{"message":"improve documentation of slices rules","sha":"1358b821d1fff18e73799ae1326efbc2067580dd"}]
```

**#35** · core · ok · 479 ms — `gh api '/repos/TNG/ArchUnit/commits?path=docs/userguide/html/000_Index.html&per_page=100' --jq '.[0:3] | map({sha, message:(.commit.message|split("\n")[0])})'`

```
[{"message":"prepare release 1.5.1","sha":"6c2d659e5681b50541930d236a8c46aed5e44a5c"},{"message":"prepare release 1.5.0","sha":"502d782bfbf2632a2c9f943a502ddd8cc3e3c46d"},{"message":"prepare release 1.4.2","sha":"e45aaa20543b74daeaa09f501b8890742dc7dd8d"}]
```

**#36** · search · ok · 770 ms — `gh search prs "FileBasedViolationStore" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`
→ `[]`

**#37** · core · ok · 1002 ms — `gh issue view 1264 --repo TNG/ArchUnit --json title,body,url,state,comments`

```
{"body":"Hi ArchUnit Team,\r\n\r\nFirst of you do a great job here. ArchUnit is great.\r\n\r\nIn our project we currently have >70 freeze files in the stored.rules mentioned.\r\n\r\nDigging deeper I noticed several things, which I am concerned about.\r\n\r\n1. The files referenced might not exist anymore, but the reference in stored.rules is\r\n2. When freeze files become empty you are not being advised to remove the freezing from your test. \r\n3. Freeze files might still be in the archunit folder, but not referenced anymore\r\n4. Tests were removed without removing the stored.rules line or freeze file\r\n5. stored.rules are not sorted. To make it better human readable it would be nice to have it sorted alphabetically.\r\n\r\nOf course in the end it is our job to keep our source code in check and clean up correctly etc.\r\n\r\nYet I wonder how ArchUnit itself can help to have a sanity check of its freeze files and stored.rules?\r\n\r\nWhat is your opinion on this?","comments":[{"id":"IC_kwDOBU1z-s6TBo-D","author":{"login":"codecholeric"},"authorAssociation":"COLLABORATOR","body":"Sorry for the late reply, I think it would be a nice addition, if anybody wants to give this a shot I would support it! In the past we've already sorted the actual violations alphabetically to ease human browsing and diffs if I remember correctly.","createdAt":"2024-11-10T10:38:30Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG
```

**#38** · core · ok · 1123 ms — `gh issue view 1045 --repo TNG/ArchUnit --json title,body,url,state,comments`

```
{"body":"this follows on (somewhat) https://github.com/TNG/ArchUnit/issues/1025.\r\n\r\nWe have a modular monolith, and have set up archunit to run for each module.  We are using frozen violations to manage the technical debt in each module, to prevent new violations from being added and to chip away at old ones.\r\n\r\nIn some circumstances Archunit will recreate the guid files with the current set of violations, which in theory is a good thing but we find that the guid file can sometimes change.  Perhaps our workflow is wrong, but at any rate, when multiple developers on current feature branches, we find we get a bunch of git conflicts that need to be resolved.\r\n\r\nWhat we think would work for us is if the file name storing the violations for a rule were deterministic rather than a guid.  Looking at the code, this is done at https://github.com/TNG/ArchUnit/blob/main/archunit/src/main/java/com/tngtech/archunit/library/freeze/ViolationStoreFactory.java#L166 , so the suggestion is to provide an SPI that makes this strategy pluggable.","comments":[{"id":"IC_kwDOBU1z-s5TVvbW","author":{"login":"danhaywood"},"authorAssociation":"CONTRIBUTOR","body":"On closer inspection, I see that the code in question is in `TextFileBasedViolationStore`, so perhaps this is already pluggable.  Will dig a bit deeper.","createdAt":"2023-01-20T10:44:30Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG/ArchUnit/issues/1045#issu
```

**#39** · search · ok · 1188 ms — `gh search issues "obsolete rules" --repo TNG/ArchUnit --limit 70 --json number,title,state,url`
→ `[]`

**#40** · core · ok · 1406 ms — `gh issue view 676 --repo TNG/ArchUnit --comments`

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

**#41** · core · ok · 413 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java&per_page=100' --jq '[.[] | {sha, subject:(.commit.message|split("\n")[0])}]'`

```
[{"sha":"48f6118f0f5b64d4174c0b51d68dbf117708a103","subject":"Make TextFileBasedViolationStore thread-safe under parallel test execution"},{"sha":"92fe06c5c1173c920688c0ddf7287f0db0ade599","subject":"update copyright to new year 2026"},{"sha":"48d906095833b455a67cf470fb1a4e7233326177","subject":"update copyright to new year 2025"},{"sha":"193a91fad9b0ddf12d1d4aa34cfb62cde43ebd32","subject":"update copyright to new year 2024"},{"sha":"0eed9b215a881bfadf30a0fb04747febe44585bd","subject":"fix Javadoc reference to constructor of `TextFileBasedViolationStore`"},{"sha":"94f31edadaf69b179df39316554f79881d2a26e7","subject":"Ensure final newline in violation store files"},{"sha":"d48e0e155cfa4ebc2d68cf3f5c32d041255f5cf7","subject":"allow adjusting file names of `TextFileBasedViolationStore`"},{"sha":"c58158c4bf9495a0916c9a8b6a6e481edb98786a","subject":"make `TextFileBasedViolationStore` public API"}]
```

**#42** · core · ok · 726 ms — `gh pr view 1046 --repo TNG/ArchUnit --json comments --jq '.comments[] | select(.body|contains("overkill")) | {url, body, author:.author.login}'`

```
{"author":"codecholeric","body":"Hey, thanks a lot for tackling this! Just to pitch in my 2 cents:\r\nOriginally I really didn't want to make `TextFileBasedViolationStore` public API, since for me this was just an implementation detail. But I see, that in some way this has always invited users to tinker with the text files, I think that's just the nature of handling bigger legacy code bases with multiple devs working in parallel (also noticed it e.g. in https://github.com/TNG/ArchUnit/issues/1015#issuecomment-1365114666 that it really makes it hard to extend the behavior of this `ViolationStore`). So meanwhile I'm not feeling so strict anymore about keeping this private :wink:\r\nThat being said, I really don't like inheritance as a way of extending / adjusting logic. Because it feels like a quite tight coupling of API and implementation details and somehow comes back to haunt you at some point. I know that it's convenient to just declare some method as `protected` and then plug in some logic, but stuff tends to creep in over time. So, if we go down this way and we want to make `TextFileBasedViolationStore` public, then I would really prefer it to just plug in this name adjusting logic in a different way. E.g. by passing some function like object `description -\u003e name` into the constructor, or by going some SPI way of defining an interface and dynamically loading the implementation as configured in `archunit.properties` (the latter seems a little overkill for this case to
```
