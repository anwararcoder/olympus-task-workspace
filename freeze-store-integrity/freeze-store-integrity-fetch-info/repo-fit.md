# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · med confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-09-27 04:29
- **Investigation:** 42 gh calls · 13 gh searches · 1 upstream requests · 492.33s

Keep the task. Older candidates provide no freeze-store implementation, and the verified public code covers only narrow portions of the graded behavior. The repository welcomes freeze-store sanity checks.

## Reasoning

Corpus: I adopt the eight distinct rulings. The authoritative subject solution has 823 non-blank added lines; discounting 25 generated HTML lines, 30 repeated license-header lines, 15 pre-existing header lines, and one relocated UUID expression gives 752. Summed corresponding implementation is 0/752 (0%) for every candidate. The closest same-repo candidate, [another submission], has 0/566 corresponding discounted lines: its importer work is unrelated, and its Gradle change shares only a filename with the subject's TEST patch. The other seven have no shared solution files or freeze-store core. As a SET they deliver neither distinct major parts to stitch nor a recurring implementation kit: union coverage is 0/752 (0%). No pairwise ruling needed overturning. I retain the completed pass's single Gradle-path precursor finding, but not the previous run's seven additional Low notices for candidates with no substantive shared surface.

Upstream: I re-read the implementing source, in complete chunks, at archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java on PR #1407 head b0631bc58a5db6bf4069278e22e7e689bfacd9d4 (removeObsoleteRules), and on PR #1405 head 4952aae7799e1f08e5b1877dfc1e0395f29a4b3d (the empty-save branch and deleteRuleFile). I also re-read the actual naming algorithm and its examples in issue #1045, comment 1402273844. These are public code in the target repository's own PRs/discussion, not other-codebase reference designs. The current hidden maintenance class contains 137 graded @Test functions, recounted as consecutive groups of 41+7+8+8+4+12+19+10+8+16+4; the prior claim of 136 omitted a test. PR #1407's missing-path removal contributes to 16/137 tests after mode-selection wiring: absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry (remove the missing entry only in repair); ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry (same gated removal); repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne (filter absent key without altering present key); anEntryWhoseFileIsAbsentIsBroken (filter missing key); everyBrokenEntryIsDiscarded (filter multiple missing keys); anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken (the existing-file predicate retains ./ spelling while removing the missing neighbor); anEntryNamingADanglingLinkIsBroken (the predicate regards dangling link as missing); aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded (the existing shared path is retained, unlike its missing neighbor); twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded (existing paths remain while the missing neighbor is removed); repairWithoutPermissionToUpdateIsRejectedAndChangesNothing (its pre-removal permission check); repairKeepsAStillViolatingRuleFrozenWithItsViolations (remove only missing neighbor); randomFileNamesDeriveNothingSoNoEntryIsMisplaced (remove missing neighbor without moving existing file); absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone (remove missing neighbor, leaving base UUID naming); aStillViolatedRuleKeepsItsEntryUnderRepair (remove missing neighbor before the base save); aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical (no write if no missing entry, write if missing); arepairThatChangesNothingLeavesTheIndexByteIdentical (no second write after missing entry was removed). I do NOT count its unreferenced-file cleanup: it deletes files the task must preserve. In particular the previous run overcredited link-target ownership, a stray link, and an unowned file; it also credited resolved-entry cleanup that PR #1407 lacks and a second-store observation that would require new cache-reload work at the pinned base.

PR #1405 contributes to 4/137: storingNoViolationsUnderRepairForgetsTheEntryAndItsFile (delete known rule's file then entry); onlyRepairForgetsAResolvedRuleWhileFailKeepsIt (gate that existing deletion branch to repair); forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry (delete before removing entry); forgettingARuleTheIndexNeverKnewStoresNothingForIt (return for unknown empty-save rule). Issue #1045's deterministic string algorithm contributes to 6/137 after trivial adaptation to the already-shipped strategy interface and removal of its fixed suffix: namesTakenFromTheDescriptionShowTheRuleTheyStore (sanitize a short readable description); aRuleKeepsTheSameNameInALaterRun (derive from description alone); aRuleKeepsTheSameNameOnAnotherMachine (fixed character processing independent of machine settings); aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds (no folder-state input); aWordWorthKeepingSurvivesAnOverlongWordAfterIt (retain the initial whole word); violationsAreReadBackFromANameTakenFromTheDescription (stable lookup name). None of these credits the constructor strategy interface, UUID generation, ordinary saving/reading, or the existing shared-map/putIfAbsent concurrency fix in PR #1656: those are already at the pin and free to every solver. Total marginal public coverage is 16+4+6=26/137 graded tests (19.0%), leaving 111/137; the test-count axis does not meet half. The public routines are small relative to the still-unbuilt filesystem-identity classification, precedence and reports, safe path/link ownership and movement, collision-resistant naming, and save/examination-wide synchronization, so the hard-work axis does not meet half either. With corpus coverage 0/752, stacking provides no additional part-source.

I walked default-branch histories for all three created source paths (no prior occurrences), the existing store source, both documentation paths, and the build path; the existing store history shows the pinned strategy/newline/concurrency work, not a removed integrity engine. Broad open-and-closed PR/issue searches for freeze, store, integrity, cleanup, sanity, and stored.rules found the partial PRs, not a complete implementation or explicit won't-have. PR #795's objection was to extending java.util.Properties to sort the index, not a rejection of integrity maintenance. The #1046 maintainer called configured SPI naming somewhat overkill, not forbidden; the maintainer expressly supported freeze-file sanity checks at https://github.com/TNG/ArchUnit/issues/1264#issuecomment-2466680707. README.md and docs/userguide/008_The_Library_API.adoc describe architecture-test freezing and a version-controlled text store, making this a coherent in-repo task. The previous 31/136 estimate is therefore superseded by the current 26/137 count, not inherited.

## Findings (5)

### overlap — Low severity

- **Claim:** distinct — [another submission]: a shared Gradle filename is only a build/test-path precursor; corresponding subject implementation is 0/752 discounted lines (0%).
- **Evidence:** archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java line 46

### publicly-solved — Medium severity

- **Claim:** Partial public coverage: PR #1407 provides missing-index-path cleanup, contributing to 16/137 graded tests, but not general integrity repair. https://github.com/TNG/ArchUnit/pull/1407
- **Evidence:** ".filter(ruleDescription -> !new File(storeFolder, storedRules.getProperty(ruleDescription)).exists())"
- **Why it matters:** The source's removeObsoleteRules at b0631bc58a5db6bf4069278e22e7e689bfacd9d4 is cribbable; its separate orphan-deletion routine conflicts with the requested preservation of unowned files.

### publicly-solved — Medium severity

- **Claim:** Partial public coverage: PR #1405 implements known-rule empty-save file deletion before removing the index entry, and no creation for unknown empty saves; 4/137 graded tests. https://github.com/TNG/ArchUnit/pull/1405
- **Evidence:** "Files.delete(storeFolder.toPath().resolve(ruleFileName));"
- **Why it matters:** Source read in deleteRuleFile and the save branch at 4952aae7799e1f08e5b1877dfc1e0395f29a4b3d; it does not address shared files, path escapes or save-wide locks.

### publicly-solved — Medium severity

- **Claim:** Partial public coverage: issue #1045 contains a working basic description-derived naming algorithm contributing to 6/137 graded tests after mechanical adaptation to the existing interface. https://github.com/TNG/ArchUnit/issues/1045#issuecomment-1402273844
- **Evidence:** "String s = description.replace(' ', '_').replaceAll("[^a-zA-Z0-9_-]", "");"
- **Why it matters:** The public algorithm cannot supply collision-resistant names, late suitable-word preservation, index-name avoidance, or relocation.

### publicly-solved — Medium severity

- **Claim:** Hedged maintainer signal, not a decline: the maintainer thought configured SPI naming might be overkill, but suggested it as a possible extension approach. https://github.com/TNG/ArchUnit/pull/1046#issuecomment-1403192283
- **Evidence:** "the latter seems a little overkill for this case to me"
- **Why it matters:** Worth considering for the configurable strategy slice; it is not an explicit rejection of freeze-store maintenance or of the naming capability.

## Investigation Log (42 commands)

**#0** · core · ok · 458 ms — `gh pr view 1407 --repo TNG/ArchUnit --json url,title,headRefOid,state,body,comments`

```
{"body":"These changes bring 2 features\r\n* clean up of frozen rules in `stored.rules` where the corresponding file does not exist in the store directory\r\n* clean up of files in store directory which are not referenced in `stored.rules` file\r\nBoth of the above operations are enabled using `default.allowStoreUpdate` property. If `default.allowStoreUpdate=false` and obsolete entries or files are found by either of the above operations, the operation fails with an `StoreUpdateFailedException`.\r\n\r\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\r\n\r\nResolves #1264","comments":[],"headRefOid":"b0631bc58a5db6bf4069278e22e7e689bfacd9d4","state":"OPEN","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"}
```

**#1** · core · ok · 461 ms — `gh pr view 1656 --repo TNG/ArchUnit --json url,title,headRefOid,state,body`

```
{"body":"Multiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore and load stored.rules into their own private snapshot. Concurrent saves caused a lost-update: the last writer overwrote the file with only its own entries.\r\n\r\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a static ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that atomically checks, sets, and flushes to disk under one lock.\r\n\r\nFixes #1654.","headRefOid":"48f6118f0f5b64d4174c0b51d68dbf117708a103","state":"MERGED","title":"Make TextFileBasedViolationStore thread-safe under parallel test execution","url":"https://github.com/TNG/ArchUnit/pull/1656"}
```

**#2** · core · ok · 463 ms — `gh pr view 1405 --repo TNG/ArchUnit --json url,title,headRefOid,state,body,comments`

```
{"body":"These changes introduce two new features for FreezingRule default store\r\n* Raise error when a freezing rule has zero violations. This can be enabled by setting the property `default.warnEmptyRuleViolation=true`. For backward compatibility it is disabled by default.\r\n* Skip rule violation file creation or delete if it already exists, when there are zero violations. This can be enabled by setting the property `default.deleteEmptyRuleViolation=true`, it is disabled by default.\r\n\r\nSigned-off-by: Masoud Kiaeeha <6916434+maxxkia@users.noreply.github.com>\r\n\r\nResolves #1264","comments":[],"headRefOid":"4952aae7799e1f08e5b1877dfc1e0395f29a4b3d","state":"OPEN","title":"raise error for empty violation store and delete empty rule file","url":"https://github.com/TNG/ArchUnit/pull/1405"}
```

**#3** · core · ok · 1414 ms — `gh issue view 1045 --repo TNG/ArchUnit --comments`

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

**#4** · core · ok · 360 ms — `gh api repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d --jq '.content | @base64d'`

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

**#5** · core · ok · 388 ms — `gh api repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4 --jq '.content | @base64d'`

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

**#6** · core · ok · 399 ms — `gh api repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleViolationFileNameStrategyFactory.java --jq '.[] | {sha: .sha,message: .commit.message}'`
→ `(no output)`

**#7** · core · ok · 404 ms — `gh api repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleDescriptionFileNames.java --jq '.[] | {sha: .sha,message: .commit.message}'`
→ `(no output)`

**#8** · core · ok · 422 ms — `gh api repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java --jq '.[] | {sha: .sha,message: .commit.message}'`
→ `(no output)`

**#9** · core · ok · 467 ms — `gh api repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java --jq '.[0:25] | map({sha: .sha,message: .commit.message})'`

```
[{"message":"Make TextFileBasedViolationStore thread-safe under parallel test execution\n\nMultiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore\nand load stored.rules into their own private snapshot. Concurrent saves caused a\nlost-update: the last writer overwrote the file with only its own entries.\n\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a\nstatic ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that\natomically checks, sets, and flushes to disk under one lock.\n\n- Move directory creation into FileSyncedProperties.initializePropertiesFile\n- Use mkdirs() || isDirectory() to handle the race where a concurrent process\n  creates the directory between mkdirs() returning false and the isDirectory check\n- Add TextFileBasedViolationStoreConcurrencyTest with separate initialize-race and\n  save-race scenarios\n- Convert both test classes from JUnit 4 to JUnit 5\n\nCo-Authored-By: <model> \u003cnoreply@<provider>.com\u003e\nSigned-off-by: Niklas Keller \u003cniklas@chrono24.com\u003e","sha":"48f6118f0f5b64d4174c0b51d68dbf117708a103"},{"message":"update copyright to new year 2026\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke@tngtech.com\u003e","sha":"92fe06c5c1173c920688c0ddf7287f0db0ade599"},{"message":"update copyright to new year 2025\n\nSigned-off-by: Manfred Hanke \u003cManfred.Hanke@tngtech.com\u003e","sha":"48d906095833b455a67cf470fb1a4e7233326177"},{"message":"update c
```

**#10** · core · ok · 613 ms — `gh pr view 1046 --repo TNG/ArchUnit --json url,title,state,body,comments,headRefOid`

```
{"body":"At the moment it is quite impossible to make any adjustments to the default `TextFileBasedViolationStore` since it's not part of the public API and hidden within the `ViolationStoreFactory`.\r\nWe now make it public API and allow customizing the way the store creates the rule violation file names so users can adjust the file name to be easier for humans to read.","comments":[{"id":"IC_kwDOBU1z-s5TlQRZ","author":{"login":"danhaywood"},"authorAssociation":"CONTRIBUTOR","body":"I've added a comment to associated issue #1045 to show how I'm using this.\r\n\r\nhttps://github.com/TNG/ArchUnit/issues/1045#issuecomment-1402273844","createdAt":"2023-01-24T16:57:59Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG/ArchUnit/pull/1046#issuecomment-1402274905","viewerDidAuthor":false},{"id":"IC_kwDOBU1z-s5TowPb","author":{"login":"codecholeric"},"authorAssociation":"COLLABORATOR","body":"Hey, thanks a lot for tackling this! Just to pitch in my 2 cents:\r\nOriginally I really didn't want to make `TextFileBasedViolationStore` public API, since for me this was just an implementation detail. But I see, that in some way this has always invited users to tinker with the text files, I think that's just the nature of handling bigger legacy code bases with multiple devs working in parallel (also noticed it e.g. in https://github.com/TNG/ArchUnit/issues/1015#issuecomment-1365114666 that it really makes it hard to extend
```

**#11** · core · ok · 1382 ms — `gh issue view 1264 --repo TNG/ArchUnit --comments`

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

**#12** · core · ok · 367 ms — `gh api repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4 --jq '(.content | @base64d)[7800:16000]'`

```
dRules.keySet().stream()
                .map(storedRules::getProperty)
                .collect(Collectors.toSet());

        List<String> danglingFiles = Arrays.stream(storeFolder.list())
                .filter(name -> !name.equals(STORED_RULES_FILE_NAME))
                .filter(Predicates.not(ruleFiles::contains))
                .collect(toList());

        if (!danglingFiles.isEmpty() && !storeUpdateAllowed) {
            throw new StoreUpdateFailedException(String.format(
                    "Failed to remove %d unreferenced rule files. Updating frozen store is disabled (enable by configuration %s.%s=true)",
                    danglingFiles.size(), ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_UPDATE_PROPERTY_NAME));

        }

        for (String fileName : danglingFiles) {
            Path path = new File(storeFolder, fileName).toPath();
            try {
                Files.delete(path);
            } catch (IOException e) {
                throw new StoreInitializationFailedException("Cannot delete unreferenced rule file: " + fileName, e);
            }
        }
    }

    @Override
    public boolean contains(ArchRule rule) {
        return storedRules.containsKey(rule.getDescription());
    }

    @Override
    public void save(ArchRule rule, List<String> violations) {
        log.trace("Storing evaluated rule '{}' with {} violations: {}", rule.getDescription(), violations.size(), violations);
        if (!storeUpdateAllowed) {
            t
```

**#13** · core · ok · 370 ms — `gh api repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d --jq '(.content | @base64d)[7800:16000]'`

```
ions.size(), violations);
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
                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_UPDATE_PROPERTY_NAME));
        }
        if (violations.isEmpty() && deleteEmptyRule) {
            deleteRuleFile(rule);
            return;
        }

        String ruleFileName = ensureRuleFileName(rule);
        write(violations, new File(storeFolder, ruleFileName));
    }

    private void deleteRuleFile(ArchRule rule) {
        try {
            String ruleFileName = storedRules.getProperty(rule.getDescription());
            Files.delete(storeFolder.toPath().resolve(ruleFileName));
        } catch (IOException e) {
            throw new StoreUpdateFailedException(e);
        }
        storedRules.removeProperty(rule.getDescription());
    }

    private void write(List<Strin
```

**#14** · core · ok · 388 ms — `gh api repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=4952aae7799e1f08e5b1877dfc1e0395f29a4b3d --jq '(.content | @base64d)[0:7800]'`

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

**#15** · core · ok · 420 ms — `gh api repos/TNG/ArchUnit/contents/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java?ref=b0631bc58a5db6bf4069278e22e7e689bfacd9d4 --jq '(.content | @base64d)[0:7800]'`

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

**#16** · core · ok · 576 ms — `gh api repos/TNG/ArchUnit/commits?path=docs/userguide/html/000_Index.html&per_page=50 --jq '.[] | {sha: .sha,message: (.commit.message | split("\n")[0])}'`

```
{"message":"prepare release 1.5.1","sha":"6c2d659e5681b50541930d236a8c46aed5e44a5c"}
{"message":"prepare release 1.5.0","sha":"502d782bfbf2632a2c9f943a502ddd8cc3e3c46d"}
{"message":"prepare release 1.4.2","sha":"e45aaa20543b74daeaa09f501b8890742dc7dd8d"}
{"message":"prepare release 1.4.1","sha":"6545053691bed56dacef3d767440e4cd58de739c"}
{"message":"improve documentation of slices rules","sha":"1358b821d1fff18e73799ae1326efbc2067580dd"}
{"message":"prepare release 1.4.0","sha":"c5caa020d13d21c61669bb1cae1a1223e4ce6f3c"}
{"message":"prepare release 1.3.0","sha":"dc7238fc7dfcfc50f5473c0cb3825de3dd9ced72"}
{"message":"prepare release 1.2.1","sha":"17ced0833324760dfdf49aaa07ea00c1fbee63aa"}
{"message":"prepare release 1.2.0","sha":"12e8fb188c4beec33e525b5e491ef3ed5ba252e4"}
{"message":"chore: updated documentation since accept no longer exists on JavaPackage","sha":"3ca046cbf87da5bbaf593b6387c95c2765623e96"}
{"message":"prepare release 1.1.0","sha":"7038a72f7a3731f05cd495cd460fd0f654c4b73b"}
{"message":"prepare release 1.0.1","sha":"bfbf0477f56188ea92077a08e9e28cba26d474fa"}
{"message":"prepare release 1.0.0","sha":"f11750bd2feb61f49209040f9ce25a2ec7b80b9a"}
{"message":"prepare release 1.0.0-rc1","sha":"dd533a43103c767eaddc5e63dd4ca012bdb505bb"}
{"message":"prepare release 0.23.1","sha":"d236cd3b277e67c0d2e3fe41738fa1afa9c56888"}
{"message":"prepare release 0.23.0","sha":"1e579c3408a58131f106268882dd435f44b85f46"}
{"message":"prepare release 0.22.0","sha":"821f16459fac126312fdb95
```

**#17** · core · ok · 627 ms — `gh api repos/TNG/ArchUnit/commits?path=docs/userguide/008_The_Library_API.adoc&per_page=100 --jq '.[] | {sha: .sha,message: (.commit.message | split("\n")[0])}'`

```
{"message":"add package matcher section to user guide","sha":"733ae8b53629c6dbfb5713a99a11eb4a4839d571"}
{"message":"Document JUnit 6 support in user guide","sha":"abbf1bd18650b45cff0d5a79397d3bc4b6a60f38"}
{"message":"improve documentation of slices rules","sha":"1358b821d1fff18e73799ae1326efbc2067580dd"}
{"message":"upgrade asciidoctor dependencies","sha":"fe1ef05cfa59a034886ca8635458fccba8c74455"}
{"message":"hide empty fields \u0026 methods of class diagrams","sha":"8da60d5b5e2ffc45a256da3634d0b3d20a342a19"}
{"message":"render PlantUML diagrams as (interactive) SVGs","sha":"34899667627454282a1faa1f7d1b0e87a95282c2"}
{"message":"extend the user guide about the `modules()` API","sha":"b6fcdf2e4efb75cac9bda74274ad7aa236f427dc"}
{"message":"parse colored PlantUML components","sha":"19b3927eef275e1e8579d31c4c778b5c8fad3d28"}
{"message":"add property `freeze.refreeze` to allow overwriting the current store","sha":"e8fbae4b49bcb0215308f7561faae6488d19bd87"}
{"message":"extend user guide for software architecture metrics","sha":"772dc98bb1d9b4e8cb262258abd0e7f274ef7d56"}
{"message":"Improve user guide regarding general coding rules","sha":"731d70827e7b5815f506c3c82f8fd3a440b6edf2"}
{"message":"rename branch `master` -\u003e `main`","sha":"3d35948ec5c1a30d49e75a2d3e1842d188f4f194"}
{"message":"fix typo in \"The Library API\" in user guide","sha":"ac001fa92280bd23c1d7c83ce094d3aaddf1dd3a"}
{"message":"adjust docs for new configuration parameters","sha":"dbb7d2a62e1cca2e2899f0d5a914
```

**#18** · search · ok · 985 ms — `gh search prs "integrity" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1338,"state":"merged","title":"Bump gradle/actions from 3 to 4","url":"https://github.com/TNG/ArchUnit/pull/1338"}]
```

**#19** · search · ok · 1056 ms — `gh search prs "violation store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","url":"https://github.com/TNG/ArchUnit/pull/1405"},{"number":1075,"state":"merged","title":"Ensure final newline in violation store files","url":"https://github.com/TNG/ArchUnit/pull/1075"},{"number":516,"state":"merged","title":"fix line ending problems in FreezingArchRule","url":"https://github.com/TNG/ArchUnit/pull/516"},{"number":252,"state":"merged","title":"Enhance FreezingArchRule","url":"https://github.com/TNG/ArchUnit/pull/252"}]
```

**#20** · search · ok · 1159 ms — `gh search prs "freeze" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"number":964,"state":"merged","title":"Replace PlantUML rule exceptions by violations","url":"https://github.com/TNG/ArchUnit/pull/964"},{"number":612,"state":"merged","title":"add property `freeze.refreeze` to allow overwriting the current store","url":"https://github.com/TNG/ArchUnit/pull/612"},{"number":438,"state":"merged","title":"Run tests against Java 15 during CI","url":"https://github.com/TNG/ArchUnit/pull/438"},{"number":428,"state":"merged","title":"Add component type of arrays to JavaClass dependencies #257","url":"https://github.com/TNG/ArchUnit/pull/428"},{"number":252,"state":"merged","title":"Enhance FreezingArchRule","url":"https://github.com/TNG/ArchUnit/pull/252"},{"number":181,"state":"merged","title":"Provide a way to store all current violations of a rule and successively only report new ones","url":"https://github.com/TNG/ArchUnit/pull/181"}]
```

**#21** · search · ok · 1229 ms — `gh search issues "freeze" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1494,"state":"open","title":"Bad Frozen error messages","url":"https://github.com/TNG/ArchUnit/issues/1494"},{"number":226,"state":"open","title":"Freeze Rule Sets","url":"https://github.com/TNG/ArchUnit/issues/226"},{"number":1700,"state":"open","title":"Surfacing freeze store size as a signal: a green build is compatible with a growing store","url":"https://github.com/TNG/ArchUnit/issues/1700"},{"number":1015,"state":"open","title":"Do not include line numbers in freezed messages","url":"https://github.com/TNG/ArchUnit/issues/1015"},{"number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","url":"https://github.com/TNG/ArchUnit/issues/1264"},{"number":1563,"state":"open","title":"Freezing violations should include all violations in the store?","url":"https://github.com/TNG/ArchUnit/issues/1563"},{"number":981,"state":"open","title":"callMethod() ignores lambdas","url":"https://github.com/TNG/ArchUnit/issues/981"},{"number":750,"state":"open","title":"Feature Request: Import architecture breaks into SonarQube","url":"https://github.com/TNG/ArchUnit/issues/750"},{"number":1045,"state":"open","title":"[suggestion] Allow the mechanism for creating a file name for frozen violations to be specified via an SPI or similar.","url":"https://github.com/TNG/ArchUnit/issues/1045"},{"number":676,"state":"open","title":"FreezingArchRule: No longer violating a rule should under no circumstances break the test","url":"http
```

**#22** · core · ok · 495 ms — `gh api repos/TNG/ArchUnit/commits?path=archunit/src/main/java/com/tngtech/archunit/library/freeze/ViolationStoreFactory.java --jq '.[0:50] | map({sha: .sha,message:(.commit.message | split("\n")[0])})'`

```
[{"message":"update copyright to new year 2026","sha":"92fe06c5c1173c920688c0ddf7287f0db0ade599"},{"message":"update copyright to new year 2025","sha":"48d906095833b455a67cf470fb1a4e7233326177"},{"message":"update copyright to new year 2024","sha":"193a91fad9b0ddf12d1d4aa34cfb62cde43ebd32"},{"message":"make `TextFileBasedViolationStore` public API","sha":"c58158c4bf9495a0916c9a8b6a6e481edb98786a"},{"message":"adjust all log-levels besides WARN to TRACE","sha":"69227cfe5cc6e89b608a13facfc8386ea2a5a469"},{"message":"adjust copyright to 2023","sha":"4cf2d0dfbe757da47a90ce7f9c944778e309dbac"},{"message":"replace Guava `Files.{write/append}` by `java.nio.Files.write(..)`","sha":"506030b3d066ed66e70740d6000cdb0ae52721ca"},{"message":"replace for loops by stream operations","sha":"abf72754413d5cb7203ad8e76c305abed264bba4"},{"message":"move `@MayResolveTypesViaReflection` from package `core` to `base`","sha":"e761a6152da991752353fd8825d8fe9dc4e36ad3"},{"message":"update copyright for year 2022","sha":"519aa68050e40dab5f076a28df80613a6dbfa889"},{"message":"fix line ending problems in FreezingArchRule","sha":"9608307c06f12d47ef1632625d98efc9392824e4"},{"message":"update copyright to 2021","sha":"fdc05e8fdb88652963a8bedccd999ee80e9de249"},{"message":"read empty list of frozen violations correctly","sha":"33c341b68dd9267f13b17063628f0e72f23d3fba"},{"message":"update copyright header for new year","sha":"7a96cd45282a609a76b795b2eec7fd3ad767cf96"},{"message":"It is now possible to explicit
```

**#23** · core · ok · 557 ms — `gh api repos/TNG/ArchUnit/commits?path=archunit/build.gradle --jq '.[0:25] | map({sha: .sha,message:(.commit.message | split("\n")[0])})'`

```
[{"message":"fix: include java.lang.IO in ACCESS_STANDARD_STREAMS (#1686)","sha":"35d9d6b8c1d8315a22b179f28512f32d8132d9bc"},{"message":"Restructure self-tests to apply them archunit-junit6* modules, too","sha":"5222b9154de48e234d1b9d423c12f7d40a04be29"},{"message":"remove junit-dataprovider dependency","sha":"7d8c067bfad58f6a72c522a1d76c8a2a37496d1c"},{"message":"migrate some junit-dataprovider tests to junit-jupiter-params' @MethodSource","sha":"c3d3253606dda09dc2545c48dd62726aaba02f52"},{"message":"Split JUnit deps into archunit.java-junit-conventions plugin","sha":"5e2a34c286af6c3df6536f265457e2e4dc36ef76"},{"message":"Update Gradle Wrapper from 8.14.3 to 9.5.0","sha":"39def90ebec6afd17a80bf3747957b81737d7a9b"},{"message":"use Gradle version catalog for ArchUnit dependencies","sha":"7d3bc3540bffc8641cc4eb5583234d09210772b8"},{"message":"consolidate test dependencies for logging","sha":"320e3dc438a002044723aa6182c003d4f0345b4c"},{"message":"run tests with JUnit Platform","sha":"d9bcdd183495da5b4cda5b8c52bb93236be7d110"},{"message":"add `sourceSets.main.output` to classpath of `jdk9main`","sha":"5a8f5e5b64848007e2487ca91c520c256a92b248"},{"message":"fix `compileJdk9mainJava` task dependencies","sha":"262880301a049d08694879809d9dc0759d6724ce"},{"message":"support running build with JDK 16","sha":"edcc8b9023bfb0c493a4dd97373c35ba62298512"},{"message":"remove exclude workaround for Java Records in Gradle 6","sha":"12f2bf28894d8fe6f9ddaf9401382c29dd96e167"},{"message":"upgrade
```

**#24** · search · ok · 955 ms — `gh search issues "integrity" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`
→ `[]`

**#25** · core · ok · 1074 ms — `gh issue view 1045 --repo TNG/ArchUnit --json url,title,body,comments`

```
{"body":"this follows on (somewhat) https://github.com/TNG/ArchUnit/issues/1025.\r\n\r\nWe have a modular monolith, and have set up archunit to run for each module.  We are using frozen violations to manage the technical debt in each module, to prevent new violations from being added and to chip away at old ones.\r\n\r\nIn some circumstances Archunit will recreate the guid files with the current set of violations, which in theory is a good thing but we find that the guid file can sometimes change.  Perhaps our workflow is wrong, but at any rate, when multiple developers on current feature branches, we find we get a bunch of git conflicts that need to be resolved.\r\n\r\nWhat we think would work for us is if the file name storing the violations for a rule were deterministic rather than a guid.  Looking at the code, this is done at https://github.com/TNG/ArchUnit/blob/main/archunit/src/main/java/com/tngtech/archunit/library/freeze/ViolationStoreFactory.java#L166 , so the suggestion is to provide an SPI that makes this strategy pluggable.","comments":[{"id":"IC_kwDOBU1z-s5TVvbW","author":{"login":"danhaywood"},"authorAssociation":"CONTRIBUTOR","body":"On closer inspection, I see that the code in question is in `TextFileBasedViolationStore`, so perhaps this is already pluggable.  Will dig a bit deeper.","createdAt":"2023-01-20T10:44:30Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG/ArchUnit/issues/1045#issu
```

**#26** · core · ok · 1097 ms — `gh issue view 1264 --repo TNG/ArchUnit --json url,title,body,comments`

```
{"body":"Hi ArchUnit Team,\r\n\r\nFirst of you do a great job here. ArchUnit is great.\r\n\r\nIn our project we currently have >70 freeze files in the stored.rules mentioned.\r\n\r\nDigging deeper I noticed several things, which I am concerned about.\r\n\r\n1. The files referenced might not exist anymore, but the reference in stored.rules is\r\n2. When freeze files become empty you are not being advised to remove the freezing from your test. \r\n3. Freeze files might still be in the archunit folder, but not referenced anymore\r\n4. Tests were removed without removing the stored.rules line or freeze file\r\n5. stored.rules are not sorted. To make it better human readable it would be nice to have it sorted alphabetically.\r\n\r\nOf course in the end it is our job to keep our source code in check and clean up correctly etc.\r\n\r\nYet I wonder how ArchUnit itself can help to have a sanity check of its freeze files and stored.rules?\r\n\r\nWhat is your opinion on this?","comments":[{"id":"IC_kwDOBU1z-s6TBo-D","author":{"login":"codecholeric"},"authorAssociation":"COLLABORATOR","body":"Sorry for the late reply, I think it would be a nice addition, if anybody wants to give this a shot I would support it! In the past we've already sorted the actual violations alphabetically to ease human browsing and diffs if I remember correctly.","createdAt":"2024-11-10T10:38:30Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG
```

**#27** · search · ok · 1107 ms — `gh search prs "cleanup" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1717,"state":"open","title":"cleanup ClassFileImporterAnnotationsTest and minor other locations","url":"https://github.com/TNG/ArchUnit/pull/1717"},{"number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"number":1658,"state":"closed","title":"[part2]add support JUnit 6.x testing framework. ","url":"https://github.com/TNG/ArchUnit/pull/1658"},{"number":1685,"state":"merged","title":"Bump gradle/actions from 6.2.0 to 6.3.0","url":"https://github.com/TNG/ArchUnit/pull/1685"},{"number":1681,"state":"merged","title":"Bump gradle/actions from 6 to 6.2.0","url":"https://github.com/TNG/ArchUnit/pull/1681"},{"number":1569,"state":"merged","title":"Adjust AnalyzeClasses annotation to support individual classes as parameter","url":"https://github.com/TNG/ArchUnit/pull/1569"},{"number":1646,"state":"merged","title":"Bump com.gradleup.shadow from 9.4.2 to 9.4.3","url":"https://github.com/TNG/ArchUnit/pull/1646"},{"number":1644,"state":"merged","title":"Bump concurrent-ruby from 1.3.6 to 1.3.7 in /docs","url":"https://github.com/TNG/ArchUnit/pull/1644"},{"number":1649,"state":"closed","title":"Bump junit5 from 5.14.4 to 6.1.1","url":"https://github.com/TNG/ArchUnit/pull/1649"},{"number":1640,"state":"merged","title":"Bump actions/checkout from 6 to 7","url":"https://github.com/TNG/ArchUnit/pull/1640"},{"number":1554,"state":"merged","title":"Bump actions/checkout from 5 to 6","url":"https://github.com/TNG/ArchUni
```

**#28** · search · ok · 1218 ms — `gh search prs "store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1405,"state":"open","title":"raise error for empty violation store and delete empty rule file","url":"https://github.com/TNG/ArchUnit/pull/1405"},{"number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"number":1673,"state":"merged","title":"Add temporary publication to formally deprecate the legacy `archunit-junit` package","url":"https://github.com/TNG/ArchUnit/pull/1673"},{"number":1685,"state":"merged","title":"Bump gradle/actions from 6.2.0 to 6.3.0","url":"https://github.com/TNG/ArchUnit/pull/1685"},{"number":822,"state":"closed","title":"Add support for casts","url":"https://github.com/TNG/ArchUnit/pull/822"},{"number":1644,"state":"merged","title":"Bump concurrent-ruby from 1.3.6 to 1.3.7 in /docs","url":"https://github.com/TNG/ArchUnit/pull/1644"},{"number":1681,"state":"merged","title":"Bump gradle/actions from 6 to 6.2.0","url":"https://github.com/TNG/ArchUnit/pull/1681"},{"number":1645,"state":"merged","title":"Bump actions/setup-java from 5.3.0 to 5.4.0","url":"https://github.com/TNG/ArchUnit/pull/1645"},{"number":1554,"state":"merged","title":"Bump actions/checkout from 5 to 6","url":"https://github.com/TNG/ArchUnit/pull/1554"},{"number":1220,"state":"merged","title":"Eliminate redundant line number","url":"https://github.com/TNG/ArchUnit/pull/1220"},{"number":1075,"state":"merged","title":"Ensure final newline in violation store files","url":"https://github.com/TNG/ArchUnit/pull/1075"}
```

**#29** · search · ok · 1265 ms — `gh search issues "store" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1700,"state":"open","title":"Surfacing freeze store size as a signal: a green build is compatible with a growing store","url":"https://github.com/TNG/ArchUnit/issues/1700"},{"number":1563,"state":"open","title":"Freezing violations should include all violations in the store?","url":"https://github.com/TNG/ArchUnit/issues/1563"},{"number":1494,"state":"open","title":"Bad Frozen error messages","url":"https://github.com/TNG/ArchUnit/issues/1494"},{"number":749,"state":"open","title":"Change Request: ViolationStore-API should give access to structured violation data","url":"https://github.com/TNG/ArchUnit/issues/749"},{"number":597,"state":"open","title":"ArchUnit Trends","url":"https://github.com/TNG/ArchUnit/issues/597"},{"number":676,"state":"open","title":"FreezingArchRule: No longer violating a rule should under no circumstances break the test","url":"https://github.com/TNG/ArchUnit/issues/676"},{"number":705,"state":"open","title":"Scan parameter name","url":"https://github.com/TNG/ArchUnit/issues/705"},{"number":1015,"state":"open","title":"Do not include line numbers in freezed messages","url":"https://github.com/TNG/ArchUnit/issues/1015"},{"number":751,"state":"open","title":"FeatureRequest: Possibility to define IDs for Rules","url":"https://github.com/TNG/ArchUnit/issues/751"},{"number":1249,"state":"open","title":"Custom Error Messages for StoreUpdateFailedException","url":"https://github.com/TNG/ArchUnit/issues/1249"},{"number":1045,"state":"open","title"
```

**#30** · core · ok · 525 ms — `gh pr view 1407 --repo TNG/ArchUnit --json files --jq '.files | map(.path)'`

```
["archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java","archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java"]
```

**#31** · core · ok · 581 ms — `gh pr view 795 --repo TNG/ArchUnit --json url,title,body,state,comments`

```
{"body":"In the file `stored.rules` there are all frozen rules stored, along with an uuid to a file where than all frozen violations for that rule are stored.\r\nCurrently, the content of that file is not sorted in any way.\r\nTherefore, adding a new frozen rule adds a new line to that file and can lead to a reorder of all lines.\r\nThe reorder of the file is especially than a problem, when we want to see the changed to the previous version as a diff.\r\nIdeally by adding one new rule also only one line should change in the file.\r\nBy sorting the file alphabetically this is given.\r\n\r\nUsed the following post to sort the file: https://stackoverflow.com/a/55957344\r\n\r\nSigned-off-by: Hannes Oberprantacher <h.oberprantacher@gmail.com>","comments":[{"id":"IC_kwDOBU1z-s5D-d2r","author":{"login":"codecholeric"},"authorAssociation":"COLLABORATOR","body":"As discussed, while I see the reasoning behind sorting these files I'm not super happy with extending `java.util.Properties`, because I don't like the maintenance aspect of this (this could break with any JDK upgrade and I don't feel comfortable with extending such core JDK classes, feels \"hacky\" to me). Did you make any progress considering an extension point for users instead? Where users could hook in code like this themselves?","createdAt":"2022-05-29T13:23:00Z","includesCreatedEdit":false,"isMinimized":false,"minimizedReason":"","reactionGroups":[],"url":"https://github.com/TNG/ArchUnit/pull/795#issuecomment-1140448683"
```

**#32** · core · ok · 653 ms — `gh pr view 1405 --repo TNG/ArchUnit --json files --jq '.files | map(.path)'`

```
["archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreEmptyException.java","archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java","archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java"]
```

**#33** · core · ok · 838 ms — `gh issue view 1700 --repo TNG/ArchUnit --json url,title,body,comments`

```
{"body":"Hi — an observation about `FreezingArchRule`, not a bug report. It comes from a\nformal result on separation criteria I deposited recently, and I'm opening it here\nbecause the result says ArchUnit made the right granularity choice, and points at\none thing the current output cannot show.\n\n**What the freeze mechanism does right.**\n\nA rule of the form *no dependency from A to B* is a separation criterion evaluated\nagainst a declaration of what is permitted. Such criteria have a general\ndegeneration: if the permitted set can be enlarged, every violation can be removed\nby enlarging it, without touching the code, and the required enlargement is\ncomputable from the violations themselves.\n\n`FreezingArchRule` does not do that. It records individual violations, and the\ndefault `ViolationLineMatcher` matches the specific violation rather than the\nrule's predicate. Absorbing an instance does not permit the class — a new violation\nof the same kind still fails. That is strictly weaker than enlarging the rule, and\nit is why freezing is usable at all. The downward ratchet — fixed violations are\nautomatically removed from the store — is the second half of the same virtue.\n\n**What the result says you cannot see.**\n\nAny graded measure computed from the *current* violation count is structurally\nunable to signal drift along a path of successive absorptions: it assigns the\nmaximal value to every absorbed state and cannot decrease as absorptions\naccumulate. The info
```

**#34** · search · ok · 867 ms — `gh search prs "sanity" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":880,"state":"closed","title":"#641 Added tooling tests","url":"https://github.com/TNG/ArchUnit/pull/880"},{"number":816,"state":"merged","title":"add the possibility to allow empty should per rule","url":"https://github.com/TNG/ArchUnit/pull/816"},{"number":53,"state":"merged","title":"Add syntax fails on invalid args","url":"https://github.com/TNG/ArchUnit/pull/53"}]
```

**#35** · search · ok · 980 ms — `gh search issues "sanity" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","url":"https://github.com/TNG/ArchUnit/issues/1264"}]
```

**#36** · core · ok · 1027 ms — `gh issue view 676 --repo TNG/ArchUnit --json url,title,body,comments`

```
{"body":"Current behaviour:\r\nWhen there are less-than-frozen violations, FreezingArchRule tries to save the shortened violation list (which undoubtedly basically is a good idea), but when feeze.store.allowStoreUpdate is set to false, this leads to a StoreUpdateFailedException.\r\n\r\nDesired behaviour:\r\nWhen using FreezingArchRule, it should _always_ be allowed to generate less-than-frozen violations, no matter which settings are used for freeze.store. So if allowStoreUpdate is false, it should simply do nothing. (Potentially there could be another option, failIfShorteningNotSaved or so for those who like to fail).\r\n\r\nReason:\r\n* Our build manager strictly forbids the build to change any file in the workspace\r\n* The acceptance of tools like SONAR or ArchUnit is not that big that we could make a rule for each developer to check/update ArchUnitTests before committing\r\n* For that kind of developer, it is even less desired to point him too directly to the freezing mechanism so it isn't too simple to work around new violations. ArchUnit should work more in the background.\r\n\r\nExtra Reason:\r\n* If we had forbidden any update of Rules from the beginning on (not just since the new build manager detected the modified files in his workspace), we wouldn't have suffered that much from #458 since for years we didn't realize a test wasn't run on CI because it's violation store was silently created on each build.\r\n\r\n","comments":[{"id":"IC_kwDOBU1z-s44Ub0P","author":{"l
```

**#37** · search · ok · 1032 ms — `gh search prs "file names" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1294,"state":"merged","title":"run tests with JUnit Platform","url":"https://github.com/TNG/ArchUnit/pull/1294"},{"number":1046,"state":"merged","title":"Allow adjusting file names of `TextFileBasedViolationStore`","url":"https://github.com/TNG/ArchUnit/pull/1046"},{"number":690,"state":"merged","title":"Public getters for source code location","url":"https://github.com/TNG/ArchUnit/pull/690"}]
```

**#38** · core · ok · 460 ms — `gh api repos/TNG/ArchUnit/commits/48f6118f0f5b64d4174c0b51d68dbf117708a103 --jq '{sha:.sha, message:.commit.message, paths:(.files|map(.filename))}'`

```
{"message":"Make TextFileBasedViolationStore thread-safe under parallel test execution\n\nMultiple FreezingArchRule instances each create a fresh TextFileBasedViolationStore\nand load stored.rules into their own private snapshot. Concurrent saves caused a\nlost-update: the last writer overwrote the file with only its own entries.\n\nFix by sharing one FileSyncedProperties per stored.rules canonical path via a\nstatic ConcurrentHashMap, and synchronizing writes with a putIfAbsent method that\natomically checks, sets, and flushes to disk under one lock.\n\n- Move directory creation into FileSyncedProperties.initializePropertiesFile\n- Use mkdirs() || isDirectory() to handle the race where a concurrent process\n  creates the directory between mkdirs() returning false and the isDirectory check\n- Add TextFileBasedViolationStoreConcurrencyTest with separate initialize-race and\n  save-race scenarios\n- Convert both test classes from JUnit 4 to JUnit 5\n\nCo-Authored-By: <model> \u003cnoreply@<provider>.com\u003e\nSigned-off-by: Niklas Keller \u003cniklas@chrono24.com\u003e","paths":["archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java","archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreConcurrencyTest.java","archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java"],"sha":"48f6118f0f5b64d4174c0b51d68dbf117708a103"}
```

**#39** · core · ok · 623 ms — `gh pr view 1046 --repo TNG/ArchUnit --json comments --jq '.comments[] | select(.author.login == "codecholeric") | {url,body}'`

```
{"body":"Hey, thanks a lot for tackling this! Just to pitch in my 2 cents:\r\nOriginally I really didn't want to make `TextFileBasedViolationStore` public API, since for me this was just an implementation detail. But I see, that in some way this has always invited users to tinker with the text files, I think that's just the nature of handling bigger legacy code bases with multiple devs working in parallel (also noticed it e.g. in https://github.com/TNG/ArchUnit/issues/1015#issuecomment-1365114666 that it really makes it hard to extend the behavior of this `ViolationStore`). So meanwhile I'm not feeling so strict anymore about keeping this private :wink:\r\nThat being said, I really don't like inheritance as a way of extending / adjusting logic. Because it feels like a quite tight coupling of API and implementation details and somehow comes back to haunt you at some point. I know that it's convenient to just declare some method as `protected` and then plug in some logic, but stuff tends to creep in over time. So, if we go down this way and we want to make `TextFileBasedViolationStore` public, then I would really prefer it to just plug in this name adjusting logic in a different way. E.g. by passing some function like object `description -\u003e name` into the constructor, or by going some SPI way of defining an interface and dynamically loading the implementation as configured in `archunit.properties` (the latter seems a little overkill for this case to me).","url":"https://gi
```

**#40** · search · ok · 900 ms — `gh search issues "stored.rules" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1264,"state":"open","title":"Feature suggestion: Freeze files and stored.rules validation / sanity check","url":"https://github.com/TNG/ArchUnit/issues/1264"},{"number":1654,"state":"closed","title":"`TextFileBasedViolationStore` is not thread-safe under parallel test execution","url":"https://github.com/TNG/ArchUnit/issues/1654"},{"number":1025,"state":"closed","title":"[suggestion] add test name to frozen violation guid files","url":"https://github.com/TNG/ArchUnit/issues/1025"},{"number":1026,"state":"closed","title":"[suggestion] sort violations in guid files alphabetically","url":"https://github.com/TNG/ArchUnit/issues/1026"},{"number":902,"state":"closed","title":"Specify file name for freeze?","url":"https://github.com/TNG/ArchUnit/issues/902"},{"number":510,"state":"closed","title":"Frozen rules not updated when new violation occurs","url":"https://github.com/TNG/ArchUnit/issues/510"}]
```

**#41** · search · ok · 1300 ms — `gh search prs "stored.rules" --repo TNG/ArchUnit --limit 100 --json number,title,state,url`

```
[{"number":1407,"state":"open","title":"cleanup obsolete frozen rules","url":"https://github.com/TNG/ArchUnit/pull/1407"},{"number":1656,"state":"merged","title":"Make TextFileBasedViolationStore thread-safe under parallel test execution","url":"https://github.com/TNG/ArchUnit/pull/1656"},{"number":795,"state":"closed","title":"we ensure that the `stored.rules`-file is sorted alphabetically","url":"https://github.com/TNG/ArchUnit/pull/795"},{"number":438,"state":"merged","title":"Run tests against Java 15 during CI","url":"https://github.com/TNG/ArchUnit/pull/438"},{"number":181,"state":"merged","title":"Provide a way to store all current violations of a rule and successively only report new ones","url":"https://github.com/TNG/ArchUnit/pull/181"}]
```
