# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · high confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-09-15 16:43
- **Investigation:** 41 gh calls · 20 gh searches · 1 upstream requests · 695.115s

Pass. All five candidates are distinct at 0/715 discounted subject lines, so neither pairwise nor union corpus overlap binds. Verified public code covers at most 16/125 current maintenance tests (12.8%) and leaves the larger, hardest integrity core novel. No complete public solution, maintainer decline, removed predecessor, or repo-goal contradiction was found.

## Reasoning

Category 1 does not bar the task. I adopt all five completed pairwise rulings from their worksheets: the authoritative subject divisor is 715 non-blank authored solution lines after subtracting 25 generated HTML lines and 28 repeated-header lines from 768, and every candidate has summed N=0, i.e. 0/715 (0%). Those integers map to clear_minority, and no ENGINE-SHARE, TEMPLATE-STAMP, or CLAUSE-ELABORATION shape is recorded that could turn a zero-share comparison into a derivative. The same-repository candidate [another submission] changes unrelated bytecode-import normalization code; the other four implement unrelated engines in other repositories. At set level there is no union part-source: none of the candidates supplies any authored block of the subject, the candidates do not cover distinct major blocks, and no recurring stamped kit was reported. The previous run's extra candidate [another submission] is not present in the current slate and read_candidate confirmed it is not available among the valid current candidate IDs, so I do not silently carry it into this slate's union. The previous 754-line overlap denominator is superseded by the current completed pass's itemized 715-line denominator.

I verified the previous upstream claims by reading the public implementation source at each artifact's own ref. Open PR #1407 (https://github.com/TNG/ArchUnit/pull/1407), head b0631bc58a5db6bf4069278e22e7e689bfacd9d4, implements TextFileBasedViolationStore.removeObsoleteRules in archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java by filtering index entries whose referenced path does not exist and removing them. Its removeObsoleteRuleFiles deletes unreferenced files, which conflicts with this task's preserve/report policy for unowned files. Generously, the reusable missing-file primitive contributes to at most these 8 tests: absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne, anEntryWhoseFileIsAbsentIsBroken, everyBrokenEntryIsDiscarded, aSecondInitializationOfARepairedFolderDiscardsNothing, aSeparatelyCreatedStoreObservesTheRepairedIndex, and repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder.

Open PR #1405 (https://github.com/TNG/ArchUnit/pull/1405), head 4952aae7799e1f08e5b1877dfc1e0395f29a4b3d, implements TextFileBasedViolationStore.save/deleteRuleFile for empty saves in the same source path. It contributes to at most 3 tests: storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, onlyRepairForgetsAResolvedRuleWhileFailKeepsIt, and forgettingARuleTheIndexNeverKnewStoresNothingForIt. Issue #1045's public comment (https://github.com/TNG/ArchUnit/issues/1045#issuecomment-1402273844) contains working, tested DeterministicTextFileBasedViolationStore.newRuleFileName code. Its extension, truncation, collision, empty/non-ASCII handling, and character set do not implement the robust built-in strategy; it contributes at most the 5 basic tests namesTakenFromTheDescriptionShowTheRuleTheyStore, aRuleKeepsTheSameNameInALaterRun, aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds, violationsAreReadBackFromANameTakenFromTheDescription, and namesTakenFromTheDescriptionNeverCollideWithTheIndex.

The current maintenance class contains 125 @Test functions, not the previous run's 121: the section counts are 7+10+6+7+5+7+8+8+4+11+5+13+10+7+13+3+1. The three disjoint public slices therefore cover at most 16/125 tests (12.8%), leaving 109/125. This is far below half on the test axis, and the uncovered remainder is also clearly the larger and harder implementation share: filesystem identity across canonical paths, symbolic links and hard links; condition precedence; direct-child and ownership checks; repair versus non-mutating fail; collisions and occupied targets; ordered diagnostics; safe relocation and deletion; robust fingerprinted naming; and settled synchronized repair. PR #1656's concurrency substrate adds no marginal public coverage because it is already in the pinned base: TextFileBasedViolationStore.java lines 77 and 118 share FileSyncedProperties by canonical path, and lines 264-274 synchronize putIfAbsent and disk sync. Since every corpus candidate contributes 0/715 lines, corpus-plus-public stacking leaves the same 109/125-test hard core uncovered and cannot bind.

The upstream sweep found no complete public implementation, removal, or capability-level decline. The three Java paths created by the solution—RuleDescriptionFileNames.java, RuleViolationFileNameStrategyFactory.java, and StoreIntegrity.java—each have empty upstream path history. The existing TextFileBasedViolationStore history contains the already-free custom naming and concurrency substrates but no removed integrity engine. Broad PR and issue searches for stored.rules, violation store, freeze store, integrity, sanity check, obsolete frozen rules, deterministic names, empty violations, and rule/file names surfaced the partial artifacts above but no fuller source. Issue #1264 is affirmative rather than a rejection: collaborator codecholeric wrote, “I think it would be a nice addition, if anybody wants to give this a shot I would support it!” The older implementation-detail concern in issue #902 was not a permanent capability rejection and was superseded by merged PR #1046's public pluggable naming API.

Finally, the task is repository-aligned. The pinned guide says FreezingArchRule records existing violations, automatically reduces stored violations when they are fixed, and uses plain-text files suitable for version control (docs/userguide/008_The_Library_API.adoc lines 442-444 and 462-463). Integrity maintenance and readable deterministic naming coherently extend those goals; no repository-purpose contradiction was found.

## Findings (8)

### overlap — Low severity

- **Claim:** distinct — [another submission]: 0 of 715 discounted subject solution lines correspond (0%); generic stabilization language does not connect its SQL autofix convergence engine to this filesystem integrity engine.
- **Why it matters:** This is a motivation-only retrieval neighbor, not a corpus duplicate, derivative, or union part-source.

### overlap — Low severity

- **Claim:** distinct — [another submission]: 0 of 715 discounted subject solution lines correspond (0%); optimistic-concurrency language does not connect its nftables transaction machinery to freeze-store maintenance.
- **Why it matters:** No authored machinery or major subject block is recycled from this candidate.

### overlap — Low severity

- **Claim:** distinct — [another submission]: 0 of 715 discounted subject solution lines correspond (0%); the common storage-integrity motivation leads to different core implementations.
- **Why it matters:** The candidate's binary-record checksum and migration work supplies no part of this index/folder reconciliation engine.

### overlap — Low severity

- **Claim:** distinct — [another submission]: 0 of 715 discounted subject solution lines correspond (0%); the common integrity-audit theme is motivation-only.
- **Why it matters:** Its Raft-log reachability checks do not supply a major implementation block of the subject.

### overlap — Low severity

- **Claim:** distinct — [another submission]: 0 of 715 discounted subject solution lines correspond (0%); the same-repository candidate implements unrelated compiler-finally access normalization.
- **Why it matters:** The only repository proximity does not create solution overlap or a union part-source.

### publicly-solved — Medium severity

- **Claim:** Open PR #1407 (https://github.com/TNG/ArchUnit/pull/1407) publicly implements the missing-file index-entry cleanup primitive in TextFileBasedViolationStore.removeObsoleteRules, contributing to at most 8/125 current maintenance tests; its unreferenced-file deletion conflicts with this task's unowned-file policy.
- **Evidence:** ".filter(ruleDescription -> !new File(storeFolder, storedRules.getProperty(ruleDescription)).exists())"
- **Why it matters:** An agent can crib this narrow primitive, but it neither approaches half the graded tests nor supplies the hardest classifier, ownership, fail/reporting, naming, and repair machinery.

### publicly-solved — Medium severity

- **Claim:** Open PR #1405 (https://github.com/TNG/ArchUnit/pull/1405) publicly implements save-time deletion for a known empty rule and non-creation for an unknown empty rule in TextFileBasedViolationStore.save/deleteRuleFile, contributing to at most 3/125 maintenance tests.
- **Evidence:** "if (violations.isEmpty() && deleteEmptyRule) {
            deleteRuleFile(rule);
            return;
        }"
- **Why it matters:** This is real partial coverage, but it is a small policy branch rather than the integrity engine's primary implementation challenge.

### publicly-solved — Medium severity

- **Claim:** Issue #1045 (https://github.com/TNG/ArchUnit/issues/1045#issuecomment-1402273844) publicly carries working and tested deterministic human-readable naming code contributing basic behavior to at most 5/125 maintenance tests, but not the robust built-in naming capability.
- **Evidence:** "String s = description.replace(' ', '_').replaceAll("[^a-zA-Z0-9_-]", "");"
- **Why it matters:** The public code is cribbable, yet its collision, extension, truncation, and non-ASCII/empty behavior leave the challenging naming guarantees uncovered.

## Investigation Log (41 commands)

**#0** · core · ok · 503 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleViolationFileNameStrategyFactory.java`
→ `[]`

**#1** · core · ok · 506 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleDescriptionFileNames.java`
→ `[]`

**#2** · core · ok · 531 ms — `gh api /repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java`
→ `[]`

**#3** · core · ok · 695 ms — `gh pr view 1407 --repo TNG/ArchUnit --json number,title,state,url,headRefOid,body,comments,reviews,files`

```
{"body":"These changes bring 2 features\r\n* clean up of frozen rules in `stored.rules` where the corresponding file does not exist in the store directory\r\n* clean up of files in store directory which are not referenced in `stored.rules` file\r\nBoth of the above operations are enabled using `default.allowStoreUpdate` property. If `default.allowStoreUpdate=false` and obsolete entries or files are found by either of the above operations, the operation fails with an `StoreUpdateFailedException`.\r\n\r\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\r\n\r\nResolves #1264","comments":[],"files":[{"path":"archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java","additions":55,"deletions":0},{"path":"archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java","additions":81,"deletions":0}],"headRefOid":"b0631bc58a5db6bf4069278e22e7e689bfacd9d4","number":1407,"reviews":[{"id":"PRR_kwDOBU1z-s6aFiCB","author":{"login":"maxxkia"},"authorAssociation":"NONE","body":"","submittedAt":"2025-01-30T21:56:36Z","includesCreatedEdit":false,"reactionGroups":[],"state":"COMMENTED","commit":{"oid":"b0631bc58a5db6bf4069278e22e7e689bfacd9d4"}}],"state":"OPEN","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"}
```

**#4** · core · ok · 729 ms — `gh pr view 1405 --repo TNG/ArchUnit --json number,title,state,url,headRefOid,body,comments,reviews,files`

```
{"body":"These changes introduce two new features for FreezingRule default store\r\n* Raise error when a freezing rule has zero violations. This can be enabled by setting the property `default.warnEmptyRuleViolation=true`. For backward compatibility it is disabled by default.\r\n* Skip rule violation file creation or delete if it already exists, when there are zero violations. This can be enabled by setting the property `default.deleteEmptyRuleViolation=true`, it is disabled by default.\r\n\r\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\r\n\r\nResolves #1264","comments":[],"files":[{"path":"archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreEmptyException.java","additions":23,"deletions":0},{"path":"archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java","additions":36,"deletions":0},{"path":"archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java","additions":80,"deletions":2}],"headRefOid":"4952aae7799e1f08e5b1877dfc1e0395f29a4b3d","number":1405,"reviews":[{"id":"PRR_kwDOBU1z-s6YpYMx","author":{"login":"maxxkia"},"authorAssociation":"NONE","body":"","submittedAt":"2025-01-19T11:42:15Z","includesCreatedEdit":false,"reactionGroups":[],"state":"COMMENTED","commit":{"oid":"90c5338e7f5dcfa34fa9fa1ab177089ec8b1c3db"}},{"id":"PRR_kwDOBU1z-s6YpYXh","author":{"login":"maxxkia"},"authorAssociation":"NONE","body":"","submittedAt":"2025-01-19T11:45:49Z","includesCreatedEdit":fals
```

**#5** · search · ok · 1051 ms — `gh search prs "stored.rules" --repo TNG/ArchUnit --limit 50 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2025-01-19T14:52:15Z","number":1407,"state":"open","title":"cleanup obsolete frozen rules","updatedAt":"2026-07-06T12:26:23Z","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"createdAt":"2026-07-06T12:40:17Z","number":1656,"state":"merged","title":"Make TextFileBasedViolationStore thread-safe under parallel test execution","updatedAt":"2026-08-13T08:48:55Z","url":"https://github.com/TNG/ArchUnit/pull/1656"},{"createdAt":"2022-02-15T19:48:19Z","number":795,"state":"closed","title":"we ensure that the `stored.rules`-file is sorted alphabetically","updatedAt":"2022-06-08T13:09:23Z","url":"https://github.com/TNG/ArchUnit/pull/795"},{"createdAt":"2020-09-27T19:29:01Z","number":438,"state":"merged","title":"Run tests against Java 15 during CI","updatedAt":"2021-01-25T08:56:11Z","url":"https://github.com/TNG/ArchUnit/pull/438"},{"createdAt":"2019-06-15T08:49:51Z","number":181,"state":"merged","title":"Provide a way to store all current violations of a rule and successively only report new ones","updatedAt":"2019-07-06T19:08:06Z","url":"https://github.com/TNG/ArchUnit/pull/181"}]
```

**#6** · search · ok · 1064 ms — `gh search issues "stored.rules" --repo TNG/ArchUnit --limit 50 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-03-12T16:03:48Z","number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","updatedAt":"2025-08-11T12:40:51Z","url":"https://github.com/TNG/ArchUnit/issues/1264"},{"createdAt":"2026-07-06T12:11:58Z","number":1654,"state":"closed","title":"`TextFileBasedViolationStore` is not thread-safe under parallel test execution","updatedAt":"2026-07-31T11:05:58Z","url":"https://github.com/TNG/ArchUnit/issues/1654"},{"createdAt":"2022-12-16T09:55:55Z","number":1025,"state":"closed","title":"[suggestion] add test name to frozen violation guid files","updatedAt":"2023-01-20T06:59:03Z","url":"https://github.com/TNG/ArchUnit/issues/1025"},{"createdAt":"2022-12-16T14:27:24Z","number":1026,"state":"closed","title":"[suggestion] sort violations in guid files alphabetically","updatedAt":"2023-01-20T06:58:06Z","url":"https://github.com/TNG/ArchUnit/issues/1026"},{"createdAt":"2022-07-04T13:29:35Z","number":902,"state":"closed","title":"Specify file name for freeze?","updatedAt":"2022-07-07T08:55:04Z","url":"https://github.com/TNG/ArchUnit/issues/902"},{"createdAt":"2021-01-12T12:35:42Z","number":510,"state":"closed","title":"Frozen rules not updated when new violation occurs","updatedAt":"2021-05-30T06:49:23Z","url":"https://github.com/TNG/ArchUnit/issues/510"}]
```

**#7** · core · ok · 1224 ms — `gh issue view 1045 --repo TNG/ArchUnit --comments`

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

**#8** · core · ok · 1635 ms — `gh issue view 1264 --repo TNG/ArchUnit --comments`

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

**#9** · core · ok · 504 ms — `gh api -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4`

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

**#10** · core · ok · 510 ms — `gh api -H Accept:application/vnd.github.raw+json /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d`

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

**#11** · core · ok · 942 ms — `gh pr view 1656 --repo TNG/ArchUnit --json number,title,state,url,headRefOid,mergeCommit,body,comments,reviews,files`

```
{"body":"Multiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore and load stored.rules into their own private snapshot. Concurrent saves caused a lost-update: the last writer overwrote the file with only its own entries.\r\n\r\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a static ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that atomically checks, sets, and flushes to disk under one lock.\r\n\r\nFixes #1654.","comments":[{"id":"IC_kwDOBU1z-s8AAAABJkhIkQ","author":{"login":"StefanGraeber"},"authorAssociation":"CONTRIBUTOR","body":"you might have a merge conflict with #1655 which will be submitted soon.\r\nIt migrates some tests from Junit4 to Junit5 and thus exchange the Temporary File provider Rule with an Extension.\r\nI think it has not touched the same test as you, but I might have missed it.","createdAt":"2026-07-10T16:09:35Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG/ArchUnit/pull/1656#issuecomment-4937238673","viewerDidAuthor":false},{"id":"IC_kwDOBU1z-s8AAAABJ2NlTA","author":{"login":"kelunik"},"authorAssociation":"CONTRIBUTOR","body":"> you might have a merge conflict with https://github.com/TNG/ArchUnit/pull/1655 which will be submitted soon.\r\n\r\nThanks for the heads up! It didn't have a conflict, but I rebased anyway and converted the test to JUnit 5.\r\n\r\n>  The code itself looks good, just one minor
```

**#12** · core · ok · 1078 ms — `gh pr view 1046 --repo TNG/ArchUnit --json number,title,state,url,headRefOid,mergeCommit,body,comments,reviews,files`

```
{"body":"At the moment it is quite impossible to make any adjustments to the default `TextFileBasedViolationStore` since it's not part of the public API and hidden within the `ViolationStoreFactory`.\r\nWe now make it public API and allow customizing the way the store creates the rule violation file names so users can adjust the file name to be easier for humans to read.","comments":[{"id":"IC_kwDOBU1z-s5TlQRZ","author":{"login":"danhaywood"},"authorAssociation":"CONTRIBUTOR","body":"I've added a comment to associated issue #1045 to show how I'm using this.\r\n\r\nhttps://github.com/TNG/ArchUnit/issues/1045#issuecomment-1402273844","createdAt":"2023-01-24T16:57:59Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG/ArchUnit/pull/1046#issuecomment-1402274905","viewerDidAuthor":false},{"id":"IC_kwDOBU1z-s5TowPb","author":{"login":"codecholeric"},"authorAssociation":"COLLABORATOR","body":"Hey, thanks a lot for tackling this! Just to pitch in my 2 cents:\r\nOriginally I really didn't want to make `TextFileBasedViolationStore` public API, since for me this was just an implementation detail. But I see, that in some way this has always invited users to tinker with the text files, I think that's just the nature of handling bigger legacy code bases with multiple devs working in parallel (also noticed it e.g. in https://github.com/TNG/ArchUnit/issues/1015#issuecomment-1365114666 that it really makes it hard to extend
```

**#13** · search · ok · 1085 ms — `gh search prs "violation store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2025-01-18T22:54:07Z","number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","updatedAt":"2026-07-06T12:26:23Z","url":"https://github.com/TNG/ArchUnit/pull/1405"},{"createdAt":"2023-03-02T20:42:57Z","number":1075,"state":"merged","title":"Ensure final newline in violation store files","updatedAt":"2023-07-04T08:32:15Z","url":"https://github.com/TNG/ArchUnit/pull/1075"},{"createdAt":"2021-01-23T17:48:15Z","number":516,"state":"merged","title":"fix line ending problems in FreezingArchRule","updatedAt":"2021-01-27T21:52:35Z","url":"https://github.com/TNG/ArchUnit/pull/516"},{"createdAt":"2019-10-20T15:29:17Z","number":252,"state":"merged","title":"Enhance FreezingArchRule","updatedAt":"2019-10-24T17:49:36Z","url":"https://github.com/TNG/ArchUnit/pull/252"}]
```

**#14** · search · ok · 1092 ms — `gh search prs "freeze store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2023-01-20T10:54:41Z","number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","updatedAt":"2023-02-06T18:07:18Z","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"createdAt":"2020-09-27T19:29:01Z","number":438,"state":"merged","title":"Run tests against Java 15 during CI","updatedAt":"2021-01-25T08:56:11Z","url":"https://github.com/TNG/ArchUnit/pull/438"}]
```

**#15** · search · ok · 1097 ms — `gh search issues "freeze store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2026-08-13T08:06:28Z","number":1700,"state":"open","title":"Surfacing freeze store size as a signal: a green build is compatible with a growing store","updatedAt":"2026-08-13T08:06:28Z","url":"https://github.com/TNG/ArchUnit/issues/1700"},{"createdAt":"2025-07-25T14:17:50Z","number":1494,"state":"open","title":"Bad Frozen error messages","updatedAt":"2025-07-25T14:17:50Z","url":"https://github.com/TNG/ArchUnit/issues/1494"},{"createdAt":"2022-12-02T08:27:24Z","number":1015,"state":"open","title":"Do not include line numbers in freezed messages","updatedAt":"2022-12-26T11:46:05Z","url":"https://github.com/TNG/ArchUnit/issues/1015"},{"createdAt":"2021-09-23T03:35:49Z","number":676,"state":"open","title":"FreezingArchRule: No longer violating a rule should under no circumstances break the test","updatedAt":"2021-12-01T16:36:08Z","url":"https://github.com/TNG/ArchUnit/issues/676"},{"createdAt":"2023-06-20T09:00:06Z","number":1124,"state":"closed","title":"ArchUnit generates different set of violations rules depending on java bytecode version","updatedAt":"2026-08-14T19:15:21Z","url":"https://github.com/TNG/ArchUnit/issues/1124"},{"createdAt":"2021-01-12T12:35:42Z","number":510,"state":"closed","title":"Frozen rules not updated when new violation occurs","updatedAt":"2021-05-30T06:49:23Z","url":"https://github.com/TNG/ArchUnit/issues/510"},{"createdAt":"2021-01-12T11:51:56Z","number":508,"state":"closed","title":"Use of System.lineSeparator() prevents development on
```

**#16** · search · ok · 1128 ms — `gh search issues "violation store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2021-12-26T23:31:04Z","number":749,"state":"open","title":"Change Request: ViolationStore-API should give access to structured violation data","updatedAt":"2022-01-03T06:47:16Z","url":"https://github.com/TNG/ArchUnit/issues/749"},{"createdAt":"2021-05-11T03:06:08Z","number":597,"state":"open","title":"ArchUnit Trends","updatedAt":"2021-05-11T13:45:42Z","url":"https://github.com/TNG/ArchUnit/issues/597"},{"createdAt":"2021-09-23T03:35:49Z","number":676,"state":"open","title":"FreezingArchRule: No longer violating a rule should under no circumstances break the test","updatedAt":"2021-12-01T16:36:08Z","url":"https://github.com/TNG/ArchUnit/issues/676"},{"createdAt":"2021-12-27T00:17:29Z","number":751,"state":"open","title":"FeatureRequest: Possibility to define IDs for Rules","updatedAt":"2022-07-17T13:55:15Z","url":"https://github.com/TNG/ArchUnit/issues/751"},{"createdAt":"2022-12-16T14:27:24Z","number":1026,"state":"closed","title":"[suggestion] sort violations in guid files alphabetically","updatedAt":"2023-01-20T06:58:06Z","url":"https://github.com/TNG/ArchUnit/issues/1026"},{"createdAt":"2022-12-16T09:55:55Z","number":1025,"state":"closed","title":"[suggestion] add test name to frozen violation guid files","updatedAt":"2023-01-20T06:59:03Z","url":"https://github.com/TNG/ArchUnit/issues/1025"},{"createdAt":"2022-07-04T13:29:35Z","number":902,"state":"closed","title":"Specify file name for freeze?","updatedAt":"2022-07-07T08:55:04Z","url":"https://github.com/T
```

**#17** · core · ok · 1320 ms — `gh issue view 1025 --repo TNG/ArchUnit --comments`

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

**#18** · core · ok · 1570 ms — `gh issue view 902 --repo TNG/ArchUnit --comments`

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

**#19** · core · ok · 520 ms — `gh api /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4 --jq '.content | @base64d | split("\n") | .[115:190] | join("\n")'`

```
storedRules = new FileSyncedProperties(storedRulesFile);
        checkInitialization(storedRules.initializationSuccessful(), "Cannot create rule store at %s", storedRulesFile.getAbsolutePath());
        removeObsoleteRules();
        removeObsoleteRuleFiles();
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

    private void removeObsoleteRules() {
        Set<String> obsoleteStoredRules = storedRules.keySet().stream()
                .filter(ruleDescription -> !new File(storeFolder, storedRules.getProperty(ruleDescription)).exists())
                .collect(Collectors.toSet());
        if (
```

**#20** · core · ok · 535 ms — `gh api /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d --jq '.content | @base64d | split("\n") | .[120:220] | join("\n")'`

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

**#21** · core · ok · 575 ms — `gh api /repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=48f6118f0f5b64d4174c0b51d68dbf117708a103 --jq '.content | @base64d | split("\n") | .[70:170] | join("\n")'`

```
private static final String STORED_RULES_FILE_NAME = "stored.rules";
    private static final String ALLOW_STORE_CREATION_PROPERTY_NAME = "default.allowStoreCreation";
    private static final String ALLOW_STORE_CREATION_DEFAULT = "false";
    private static final String ALLOW_STORE_UPDATE_PROPERTY_NAME = "default.allowStoreUpdate";
    private static final String ALLOW_STORE_UPDATE_DEFAULT = "true";

    private static final ConcurrentHashMap<String, FileSyncedProperties> STORED_RULES_BY_PATH = new ConcurrentHashMap<>();

    private final RuleViolationFileNameStrategy ruleViolationFileNameStrategy;

    private boolean storeCreationAllowed;
    private boolean storeUpdateAllowed;
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
        this.ruleViolationFileNameStrategy = ruleViolationFi
```

**#22** · core · ok · 828 ms — `gh api '/repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java&per_page=100' --jq '.[] | [.sha[0:12], .commit.author.date, .commit.message] | @tsv'`

```
48f6118f0f5b	2026-07-21T13:27:16Z	Make TextFileBasedViolationStore thread-safe under parallel test execution\n\nMultiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore\nand load stored.rules into their own private snapshot. Concurrent saves caused a\nlost-update: the last writer overwrote the file with only its own entries.\n\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a\nstatic ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that\natomically checks, sets, and flushes to disk under one lock.\n\n- Move directory creation into FileSyncedProperties.initializePropertiesFile\n- Use mkdirs() || isDirectory() to handle the race where a concurrent process\n  creates the directory between mkdirs() returning false and the isDirectory check\n- Add TextFileBasedViolationStoreConcurrencyTest with separate initialize-race and\n  save-race scenarios\n- Convert both test classes from JUnit 4 to JUnit 5\n\nCo-Authored-By: <model> <noreply@<provider>.com>\nSigned-off-by: Niklas Keller <niklas@chrono24.com>
92fe06c5c117	2026-01-07T07:15:42Z	update copyright to new year 2026\n\nSigned-off-by: Manfred Hanke <Manfred.Hanke@tngtech.com>
48d906095833	2025-01-08T07:20:57Z	update copyright to new year 2025\n\nSigned-off-by: Manfred Hanke <Manfred.Hanke@tngtech.com>
193a91fad9b0	2024-01-01T16:44:53Z	update copyright to new year 2024\n\nSigned-off-by: Peter Gafert <peter.gafert@archunit.org>
0eed9b215a88	2023-04-
```

**#23** · search · ok · 1170 ms — `gh search issues "integrity" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`
→ `[]`

**#24** · search · ok · 1229 ms — `gh search issues "file names" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2023-01-20T07:11:06Z","number":1045,"state":"open","title":"[suggestion] Allow the mechanism for creating a file name for frozen violations to be specified via an SPI or similar.","updatedAt":"2023-01-24T16:57:16Z","url":"https://github.com/TNG/ArchUnit/issues/1045"},{"createdAt":"2026-05-19T08:25:59Z","number":1623,"state":"open","title":"Use source information from classfile attributes (when available) and expose path","updatedAt":"2026-05-20T11:35:11Z","url":"https://github.com/TNG/ArchUnit/issues/1623"},{"createdAt":"2021-07-20T21:26:24Z","number":641,"state":"open","title":"Add ability to execute a subset of rules from the via system properties","updatedAt":"2022-06-23T17:11:26Z","url":"https://github.com/TNG/ArchUnit/issues/641"},{"createdAt":"2020-10-10T19:36:34Z","number":452,"state":"closed","title":"Rules shared between tests have ambiguous names","updatedAt":"2024-07-23T15:27:25Z","url":"https://github.com/TNG/ArchUnit/issues/452"},{"createdAt":"2022-07-04T13:29:35Z","number":902,"state":"closed","title":"Specify file name for freeze?","updatedAt":"2022-07-07T08:55:04Z","url":"https://github.com/TNG/ArchUnit/issues/902"},{"createdAt":"2021-09-20T15:01:16Z","number":673,"state":"closed","title":"Public access for fields of `SourceCodeLocation`","updatedAt":"2021-10-24T17:40:40Z","url":"https://github.com/TNG/ArchUnit/issues/673"}]
```

**#25** · search · ok · 1253 ms — `gh search prs "sanity check" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2022-06-10T10:47:59Z","number":880,"state":"closed","title":"#641 Added tooling tests","updatedAt":"2024-04-10T22:40:41Z","url":"https://github.com/TNG/ArchUnit/pull/880"},{"createdAt":"2022-02-26T21:59:51Z","number":816,"state":"merged","title":"add the possibility to allow empty should per rule","updatedAt":"2022-02-27T14:41:40Z","url":"https://github.com/TNG/ArchUnit/pull/816"},{"createdAt":"2017-12-11T20:36:17Z","number":53,"state":"merged","title":"Add syntax fails on invalid args","updatedAt":"2017-12-11T20:37:43Z","url":"https://github.com/TNG/ArchUnit/pull/53"}]
```

**#26** · search · ok · 1268 ms — `gh search prs "integrity" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-08-05T06:51:14Z","number":1338,"state":"merged","title":"Bump gradle/actions from 3 to 4","updatedAt":"2025-06-10T05:19:52Z","url":"https://github.com/TNG/ArchUnit/pull/1338"}]
```

**#27** · search · ok · 1276 ms — `gh search prs "obsolete frozen" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2025-01-19T14:52:15Z","number":1407,"state":"open","title":"cleanup obsolete frozen rules","updatedAt":"2026-07-06T12:26:23Z","url":"https://github.com/TNG/ArchUnit/pull/1407"}]
```

**#28** · search · ok · 1334 ms — `gh search prs "file names" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-04-14T14:43:10Z","number":1294,"state":"merged","title":"run tests with JUnit Platform","updatedAt":"2024-06-09T22:02:43Z","url":"https://github.com/TNG/ArchUnit/pull/1294"},{"createdAt":"2023-01-20T10:54:41Z","number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","updatedAt":"2023-02-06T18:07:18Z","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"createdAt":"2021-10-10T09:43:07Z","number":690,"state":"merged","title":"Public getters for source code location","updatedAt":"2021-10-24T17:40:40Z","url":"https://github.com/TNG/ArchUnit/pull/690"}]
```

**#29** · search · ok · 1354 ms — `gh search issues "sanity check" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-03-12T16:03:48Z","number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","updatedAt":"2025-08-11T12:40:51Z","url":"https://github.com/TNG/ArchUnit/issues/1264"}]
```

**#30** · search · ok · 1391 ms — `gh search issues "obsolete frozen" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`
→ `[]`

**#31** · core · ok · 558 ms — `gh api /repos/TNG/ArchUnit/commits/ab6a677dd4b678f0ab1d9481df17222916705170 --jq '[.sha, .commit.author.date, .commit.message] | @tsv'`

```
ab6a677dd4b678f0ab1d9481df17222916705170	2026-08-20T06:52:21Z	Bump com.diffplug.spotless from 8.9.0 to 8.10.0\n\nBumps com.diffplug.spotless from 8.9.0 to 8.10.0.\n\n---\nupdated-dependencies:\n- dependency-name: com.diffplug.spotless\n  dependency-version: 8.10.0\n  dependency-type: direct:production\n  update-type: version-update:semver-minor\n...\n\nSigned-off-by: dependabot[bot] <support@github.com>
```

**#32** · core · ok · 714 ms — `gh pr view 795 --repo TNG/ArchUnit --json number,title,state,url,headRefOid,body,comments,reviews,files`

```
{"body":"In the file `stored.rules` there are all frozen rules stored, along with an uuid to a file where than all frozen violations for that rule are stored.\r\nCurrently, the content of that file is not sorted in any way.\r\nTherefore, adding a new frozen rule adds a new line to that file and can lead to a reorder of all lines.\r\nThe reorder of the file is especially than a problem, when we want to see the changed to the previous version as a diff.\r\nIdeally by adding one new rule also only one line should change in the file.\r\nBy sorting the file alphabetically this is given.\r\n\r\nUsed the following post to sort the file: https://stackoverflow.com/a/55957344\r\n\r\nSigned-off-by: Hannes Oberprantacher <h.oberprantacher@gmail.com>","comments":[{"id":"IC_kwDOBU1z-s5D-d2r","author":{"login":"codecholeric"},"authorAssociation":"COLLABORATOR","body":"As discussed, while I see the reasoning behind sorting these files I'm not super happy with extending `java.util.Properties`, because I don't like the maintenance aspect of this (this could break with any JDK upgrade and I don't feel comfortable with extending such core JDK classes, feels \"hacky\" to me). Did you make any progress considering an extension point for users instead? Where users could hook in code like this themselves?","createdAt":"2022-05-29T13:23:00Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG/ArchUnit/pull/795#issuecomment-1140448683"
```

**#33** · search · ok · 973 ms — `gh search prs "empty violation" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2025-01-18T22:54:07Z","number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","updatedAt":"2026-07-06T12:26:23Z","url":"https://github.com/TNG/ArchUnit/pull/1405"}]
```

**#34** · search · ok · 1003 ms — `gh search prs "rule file" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2025-01-18T22:54:07Z","number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","updatedAt":"2026-07-06T12:26:23Z","url":"https://github.com/TNG/ArchUnit/pull/1405"},{"createdAt":"2026-07-22T06:55:16Z","number":1670,"state":"merged","title":"Bump com.gradleup.shadow from 9.6.0 to 9.6.1","updatedAt":"2026-07-22T07:37:57Z","url":"https://github.com/TNG/ArchUnit/pull/1670"},{"createdAt":"2023-01-20T10:54:41Z","number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","updatedAt":"2023-02-06T18:07:18Z","url":"https://github.com/TNG/ArchUnit/pull/1046"}]
```

**#35** · search · ok · 1047 ms — `gh search prs "deterministic" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2026-07-06T12:31:08Z","number":1655,"state":"merged","title":"Replace junit-dataprovider with junit-jupiter-params","updatedAt":"2026-07-10T16:39:37Z","url":"https://github.com/TNG/ArchUnit/pull/1655"},{"createdAt":"2021-11-12T07:24:42Z","number":717,"state":"merged","title":"fix non-deterministic return value of `JavaCodeUnit.getMethod()`","updatedAt":"2021-11-12T07:50:36Z","url":"https://github.com/TNG/ArchUnit/pull/717"}]
```

**#36** · search · ok · 1103 ms — `gh search issues "deterministic" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2023-01-20T07:11:06Z","number":1045,"state":"open","title":"[suggestion] Allow the mechanism for creating a file name for frozen violations to be specified via an SPI or similar.","updatedAt":"2023-01-24T16:57:16Z","url":"https://github.com/TNG/ArchUnit/issues/1045"},{"createdAt":"2026-05-26T14:48:18Z","number":1630,"state":"closed","title":"Nondeterministic violation description for ModuleDependency: leads to failing test when used as frozen rule","updatedAt":"2026-08-02T19:07:19Z","url":"https://github.com/TNG/ArchUnit/issues/1630"},{"createdAt":"2022-07-20T13:26:26Z","number":923,"state":"closed","title":"FreezingArchRule breaks when executed from IDE and maven","updatedAt":"2022-09-17T11:23:59Z","url":"https://github.com/TNG/ArchUnit/issues/923"},{"createdAt":"2019-11-03T15:21:11Z","number":256,"state":"closed","title":"Make JavaClass.getMethod() deterministic","updatedAt":"2021-11-12T07:50:35Z","url":"https://github.com/TNG/ArchUnit/issues/256"},{"createdAt":"2021-01-21T18:20:02Z","number":513,"state":"closed","title":"Covariant return types cause non-deterministic JavaCalls","updatedAt":"2021-11-06T11:40:17Z","url":"https://github.com/TNG/ArchUnit/issues/513"},{"createdAt":"2020-10-23T08:33:11Z","number":458,"state":"closed","title":"Freezing rules issues on windows/non-windows environments","updatedAt":"2021-01-27T21:52:31Z","url":"https://github.com/TNG/ArchUnit/issues/458"},{"createdAt":"2019-08-10T13:43:18Z","number":212,"state":"closed","title":"Vola
```

**#37** · search · ok · 1152 ms — `gh search issues "rule file" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2019-10-11T09:29:25Z","number":248,"state":"closed","title":"Freezing Architecture Tests doesn't work well with Lambdas","updatedAt":"2019-12-20T13:28:46Z","url":"https://github.com/TNG/ArchUnit/issues/248"}]
```

**#38** · search · ok · 1304 ms — `gh search issues "empty violation" --repo TNG/ArchUnit --limit 100 --json number,title,state,url,createdAt,updatedAt`

```
[{"createdAt":"2024-03-12T16:03:48Z","number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","updatedAt":"2025-08-11T12:40:51Z","url":"https://github.com/TNG/ArchUnit/issues/1264"}]
```

**#39** · core · ok · 1401 ms — `gh issue view 456 --repo TNG/ArchUnit --comments`

```
author:	hankem
association:	member
edited:	false
status:	none
--
Thanks for the report! I can indeed reproduce the issue with the following simple example:

<details><summary>imports</summary>

```java
import com.tngtech.archunit.ArchConfiguration;
import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.junit.ArchUnitRunner;
import com.tngtech.archunit.lang.ArchRule;
import org.junit.runner.RunWith;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static com.tngtech.archunit.library.freeze.FreezingArchRule.freeze;

@RunWith(ArchUnitRunner.class)
@AnalyzeClasses(packagesOf = Issue456.class)
```
</details>

```java
public class Issue456 {
    static {
        ArchConfiguration.get().setProperty("freeze.store.default.allowStoreCreation", "true");
        ArchConfiguration.get().setProperty("freeze.store.default.allowStoreUpdate", "false");
    }

    ArchRule ruleWithoutViolations = classes().should().haveNameMatching(".*");

    @ArchTest
    ArchRule frozen = freeze(ruleWithoutViolations);
}
```
--
```

**#40** · core · ok · 1484 ms — `gh issue view 676 --repo TNG/ArchUnit --comments`

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
