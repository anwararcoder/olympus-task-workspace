# Test Quality
Verdict

FAIL
1 of 48 unfair
Verdict: 1 of the 48 newly added maintenance tests is not fair: `repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder` requires freshness after an external edit to a path whose properties are already cached, which neither the prompt nor repository promises. The other tests closely track the prompt’s detailed integrity rules or established store/FreezingArchRule APIs. Shared environment caveat: the maintenance suite assumes filesystem support for symlinks and hard links, POSIX permissions, and (for the socket case) Unix-domain sockets; the overlong filename case also depends on filesystem name-length limits. These assumptions affect the link/hard-link/socket/permission/long-name cases, but are test-environment concerns rather than additional fairness failures.

Unfair Tests

Not fair
repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder
Verifies: After the test externally rewrites `stored.rules` between two initializations of the same folder, repair removes the newly written absent-file entry, leaving the index empty.

Evidence: The prompt says repair checks the index during initialization, but does not specify rereading an index externally rewritten after a prior initialization. I searched the description for `index`, `initialization`, `on disk`, `earlier initialization`, `reload`, and `external change`; no freshness-after-external-edit requirement appears. Repo searches for `integrity`, `repair`, `reload`, `reinitializ`, and cache symbols found `TextFileBasedViolationStore.java:77,118,220`: the store uses a static path-keyed `STORED_RULES_BY_PATH`, `computeIfAbsent`, and loads properties when that cached object is created. Reusing that cache is a concrete repo-grounded alternative to reloading this externally modified file, so the test selects behavior not singled out by the prompt/repo.

Quality: The scenario is explicit and deterministic, but external mutation of the index while a cached store exists is not a stated use case; the existing path-keyed cache makes the alternative behavior concrete.

Requirement Coverage (16/16 covered)

Advisory only — prompt-stated requirements and whether the hidden tests pin them.

covered
Omitted integrity configuration defaults to ignore; ignore does not perform repairs, while repair checks the index and folder during initialization.

"Setting `default.integrity` to `repair` will check the index and folder during initialization. Defaulting to `ignore` which checks nothing."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingSoRepairStillFindsEveryCondition

covered
An entry is broken when it does not point to a regular file directly within the store folder.

"If an entry points to a path that is not a regular file directly within the folder, it is broken."

anEntryWhoseFileIsAbsentIsBroken, anEntryRecordingADirectoryIsBroken, anEntryRecordingASocketIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched, anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives, anEntryRecordingANestedNameIsBrokenAndThatFileSurvives, anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives, anEntryNamingADanglingLinkIsBroken

covered
An invalid path name makes the entry broken.

"This also applies if the file name is not a valid path."

anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne

covered
A nonbroken entry with no violations is resolved.

"If an entry is not broken and its file has no violations it is resolved."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs

covered
A file containing only line breaks is resolved.

"Files that only contain line breaks are also resolved."

aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks

covered
Entries recording the same filename are shared, even when no file exists under that name.

"Entries that point to the same file name are shared, even if nothing exists with that name."

aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair

covered
Entries reaching the same regular file by different names are shared, including symbolic and hard links and targets outside the folder.

"If multiple entries point to the same regular file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."

anEntryNamingALinkToAFileInTheStoreOwnsThatFile, twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded

covered
The store does not touch shared entries/files or files that no entry points to.

"The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to."

ignoreExaminesNothingSoRepairStillFindsEveryCondition, twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded, aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget, anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded, aFileInsideADirectoryInTheStoreFolderIsNeverACondition

covered
An entry remains shared even when it is also broken or resolved.

"If an entry is shared and anything else it will remain shared."

aSharedNameHoldingNoViolationsIsNotDiscardedEither, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair, forgettingARuleKeepsTheFileAnotherEntryStillRecords

covered
Repair discards broken entries.

"When set to `repair` broken entries will be discarded."

anEntryWhoseFileIsAbsentIsBroken, everyBrokenEntryIsDiscarded, anEntryRecordingADirectoryIsBroken, anEntryRecordingASocketIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched, anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives, anEntryRecordingANestedNameIsBrokenAndThatFileSurvives, anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne, anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives, anEntryNamingADanglingLinkIsBroken

covered
Repair discards resolved entries and their files.

"When set to `repair` resolved entries and the file they point to will be discarded."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks, aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded

covered
If a resolved entry is a symbolic link, the link target is deleted as well.

"If a resolved entry is a symbolic link the file it points to will be deleted as well."

aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt

covered
Under repair, saving no violations for a known rule forgets it and removes its entry and file.

"If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well."

storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside, forgettingARuleKeepsTheFileAnotherEntryStillRecords

covered
When forgetting a rule whose entry is a symbolic link, its target is also deleted unless another entry shares the file; if shared, only the forgotten entry is removed, including for an outside target.

"If its entry is a symbolic link the file it points to will be deleted too. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."

forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile, forgettingARuleKeepsTheFileAnotherEntryStillRecords, forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside

covered
Under repair, saving no violations for an unknown rule saves nothing.

"If using `repair` and saving no violations for an unknown rule nothing will be saved."

forgettingARuleTheIndexNeverKnewStoresNothingForIt

covered
If the file cannot be deleted while forgetting a rule, saving fails and the entry remains.

"If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."

forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry

Quality Notes (47)

Prompt-stated
absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Direct, useful check of both the absent-setting default and repair. The later ignore test is partly redundant but checks the explicit value too.

Prompt-stated
ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Fair and focused; substantially overlaps the absent-setting test.

Prompt-stated
ignoreExaminesNothingSoRepairStillFindsEveryCondition
Good multi-condition test. It checks an ordinary nonempty file’s exact contents as well as the repair decisions.

Prompt-stated
repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne
Fair, but the “untouched” assertion checks keys and filenames rather than byte-for-byte identity.

Prompt-stated
anEntryWhoseFileIsAbsentIsBroken
A clear absent-file example; the broader suite tests other broken-path classes.

Prompt-stated
everyBrokenEntryIsDiscarded
Useful check that repair handles multiple broken entries in one index.

Prompt-stated
anEntryRecordingADirectoryIsBroken
Fair and distinguishes removing an index entry from deleting a directory.

Prompt-stated
anEntryRecordingASocketIsBroken
Good non-regular-file case. The test’s Unix-domain-socket setup is part of a shared platform assumption noted in overall.

Prompt-stated
anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched
Important safety case; it checks both index cleanup and that repair does not delete or rewrite the outside target.

Prompt-stated
anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives
Fair. The test checks the unsafe paths are rejected without removing the separate in-folder file.

Prompt-stated
anEntryRecordingANestedNameIsBrokenAndThatFileSurvives
Clear nested-path case.

Prompt-stated
anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne
Good coverage of several invalid-name forms. The overlong-name case relies on filesystem component-length limits; see the shared environment note in overall.

Prompt-stated
anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken
Fair path-normalization case, with a useful end-to-end read assertion.

Prompt-stated
anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives
Useful distinction between discarding a broken entry and deleting a resolved link target.

Prompt-stated
anEntryNamingALinkToAFileInTheStoreOwnsThatFile
Good symlink-to-in-folder case; assertions cover both the link entry and target contents.

Prompt-stated
aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget
Useful unowned-link case, complementing the unowned regular-file test.

Prompt-stated
anEntryNamingADanglingLinkIsBroken
A concise dangling-link case.

Prompt-stated
anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry
Good check that a dangling alias is not treated as sharing a regular file.

Prompt-stated
entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken
Fair distinction between shared-name protection and two spellings that resolve to nothing.

Prompt-stated
anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile
Direct empty-file resolution case.

Prompt-stated
aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt
Strong test of both the link and its target being removed.

Prompt-stated
aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry
Fair representative line-break-only case.

Prompt-stated
aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks
Useful breadth across common line-break encodings.

Prompt-stated
anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs
Clear contrast case.

Prompt-stated
aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded
Direct shared-name case, including an empty file and an unrelated broken entry.

Prompt-stated
twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded
Strong test of distinct names, link aliases, outside targets, and coexisting broken entries.

Prompt-stated
twoEntriesReachingOneDirectoryByDifferentNamesAreBothBroken
Useful boundary case: shared identity does not turn a directory into a valid regular file.

Prompt-stated
twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded
Strong test of hard-link identity both inside and outside the store.

Prompt-stated
aSharedNameHoldingNoViolationsIsNotDiscardedEither
Good coverage of the shared-versus-resolved interaction.

Prompt-stated
anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair
Directly exercises the unusual shared-but-broken case.

Prompt-stated
anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded
Good explicit unowned-file safety assertion.

Prompt-stated
aFileInsideADirectoryInTheStoreFolderIsNeverACondition
Useful check that repair does not recurse into a nested directory.

Prompt-stated
aSecondInitializationOfARepairedFolderDiscardsNothing
Fair idempotence check; it tests a settled store rather than external changes between initializations.

Prompt-stated
anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled
Useful idempotence and alias-preservation check.

Prompt-stated
aSeparatelyCreatedStoreObservesTheRepairedIndex
Useful integration check that the repaired on-disk index is visible to a distinct store.

Prompt-stated
aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord
Fair compact consistency assertion; it checks the index-to-file mapping as well as directory contents.

Prompt-stated
aRuleWhoseEntryWasDiscardedIsNoLongerFrozen
Good integration assertion using the store’s public lookup API.

Repo-discoverable
repairKeepsAStillViolatingRuleFrozenWithItsViolations
Fair end-to-end check; the exact list assertion also verifies the existing text-file read contract.

Repo-discoverable
aRepairedStoreCanFreezeARuleAgain
Good recovery integration test. It does not pin the random filename, only that the stale resolved filename is not reused.

Repo-discoverable
aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation
Useful integration coverage beyond direct `save`; setup and assertions are visible.

Prompt-stated
storingNoViolationsUnderRepairForgetsTheEntryAndItsFile
Strong contrast of repair and ignore; the non-repair read behavior is backed by the existing API tests.

Prompt-stated
forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside
Important outside-folder safety case; the same-name peer makes the sharing condition explicit.

Prompt-stated
forgettingARuleKeepsTheFileAnotherEntryStillRecords
Good shared-file save case with a read-after-write check.

Prompt-stated
forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile
Directly covers the unshared symbolic-link deletion path and verifies the unrelated rule remains readable.

Prompt-stated
forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry
Strong failure-and-recovery check. The asserted text is a probe-generated status, not a pinned production exception message. This test shares the suite’s POSIX/privilege environment assumptions noted in overall.

Prompt-stated
forgettingARuleTheIndexNeverKnewStoresNothingForIt
Direct unknown-rule no-op case.

Prompt-stated
aStillViolatedRuleKeepsItsEntryUnderRepair
Fair, though it covers one representative nonempty save.

Task Summary

The task is to add integrity maintenance to TextFileBasedViolationStore. On initialization, `default.integrity=repair` should inspect stored.rules and the store folder; an omitted setting or `ignore` should leave them alone. Repair removes broken entries and entries whose files contain no violations (including line-break-only files), while protecting shared references and unowned files. Sharing is by repeated stored name or by multiple names resolving to the same regular file, including symbolic/hard links and files outside the folder. When saving an empty violation list under repair, a known rule is forgotten, with its file/link target removed unless another entry shares it; an unknown rule is not added. If the file cannot be deleted, saving must fail and retain the entry. The patch adds 48 maintenance tests; the baseline task also runs existing tests, which are not new test assertions.

Completed in 268.6s

Hide raw output
{
  "completed": true,
  "coverageSuggestions": [],
  "error": "",
  "executionTimeSeconds": 268.564166,
  "message": "1 test flagged as not fair.",
  "overall": "Verdict: 1 of the 48 newly added maintenance tests is not fair: `repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder` requires freshness after an external edit to a path whose properties are already cached, which neither the prompt nor repository promises. The other tests closely track the prompt’s detailed integrity rules or established store/FreezingArchRule APIs. Shared environment caveat: the maintenance suite assumes filesystem support for symlinks and hard links, POSIX permissions, and (for the socket case) Unix-domain sockets; the overlong filename case also depends on filesystem name-length limits. These assumptions affect the link/hard-link/socket/permission/long-name cases, but are test-environment concerns rather than additional fairness failures.",
  "requirements": [
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition"
      ],
      "requirement": "Omitted integrity configuration defaults to ignore; ignore does not perform repairs, while repair checks the index and folder during initialization.",
      "sourceQuote": "Setting `default.integrity` to `repair` will check the index and folder during initialization. Defaulting to `ignore` which checks nothing."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryRecordingASocketIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
        "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
        "anEntryNamingADanglingLinkIsBroken"
      ],
      "requirement": "An entry is broken when it does not point to a regular file directly within the store folder.",
      "sourceQuote": "If an entry points to a path that is not a regular file directly within the folder, it is broken."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne"
      ],
      "requirement": "An invalid path name makes the entry broken.",
      "sourceQuote": "This also applies if the file name is not a valid path."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs"
      ],
      "requirement": "A nonbroken entry with no violations is resolved.",
      "sourceQuote": "If an entry is not broken and its file has no violations it is resolved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks"
      ],
      "requirement": "A file containing only line breaks is resolved.",
      "sourceQuote": "Files that only contain line breaks are also resolved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair"
      ],
      "requirement": "Entries recording the same filename are shared, even when no file exists under that name.",
      "sourceQuote": "Entries that point to the same file name are shared, even if nothing exists with that name."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded"
      ],
      "requirement": "Entries reaching the same regular file by different names are shared, including symbolic and hard links and targets outside the folder.",
      "sourceQuote": "If multiple entries point to the same regular file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
        "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "aFileInsideADirectoryInTheStoreFolderIsNeverACondition"
      ],
      "requirement": "The store does not touch shared entries/files or files that no entry points to.",
      "sourceQuote": "The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords"
      ],
      "requirement": "An entry remains shared even when it is also broken or resolved.",
      "sourceQuote": "If an entry is shared and anything else it will remain shared."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "everyBrokenEntryIsDiscarded",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryRecordingASocketIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
        "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
        "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
        "anEntryNamingADanglingLinkIsBroken"
      ],
      "requirement": "Repair discards broken entries.",
      "sourceQuote": "When set to `repair` broken entries will be discarded."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded"
      ],
      "requirement": "Repair discards resolved entries and their files.",
      "sourceQuote": "When set to `repair` resolved entries and the file they point to will be discarded."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt"
      ],
      "requirement": "If a resolved entry is a symbolic link, the link target is deleted as well.",
      "sourceQuote": "If a resolved entry is a symbolic link the file it points to will be deleted as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords"
      ],
      "requirement": "Under repair, saving no violations for a known rule forgets it and removes its entry and file.",
      "sourceQuote": "If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside"
      ],
      "requirement": "When forgetting a rule whose entry is a symbolic link, its target is also deleted unless another entry shares the file; if shared, only the forgotten entry is removed, including for an outside target.",
      "sourceQuote": "If its entry is a symbolic link the file it points to will be deleted too. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleTheIndexNeverKnewStoresNothingForIt"
      ],
      "requirement": "Under repair, saving no violations for an unknown rule saves nothing.",
      "sourceQuote": "If using `repair` and saving no violations for an unknown rule nothing will be saved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry"
      ],
      "requirement": "If the file cannot be deleted while forgetting a rule, saving fails and the entry remains.",
      "sourceQuote": "If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."
    }
  ],
  "taskSummary": "The task is to add integrity maintenance to TextFileBasedViolationStore. On initialization, `default.integrity=repair` should inspect stored.rules and the store folder; an omitted setting or `ignore` should leave them alone. Repair removes broken entries and entries whose files contain no violations (including line-break-only files), while protecting shared references and unowned files. Sharing is by repeated stored name or by multiple names resolving to the same regular file, including symbolic/hard links and files outside the folder. When saving an empty violation list under repair, a known rule is forgotten, with its file/link target removed unless another entry shares it; an unknown rule is not added. If the file cannot be deleted, saving must fail and retain the entry. The patch adds 48 maintenance tests; the baseline task also runs existing tests, which are not new test assertions.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The prompt says, “Defaulting to `ignore` which checks nothing,” and “When set to `repair` broken entries will be discarded.” The setup uses an absent path, so it is broken under the prompt’s definition.",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Direct, useful check of both the absent-setting default and repair. The later ignore test is partly redundant but checks the explicit value too.",
      "verifies": "With no `default.integrity` property, the `a rule` entry remains; initializing the same store with `repair` removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says `ignore` “checks nothing” and repair discards broken entries; the entry points to the absent name `gone`.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Fair and focused; substantially overlaps the absent-setting test.",
      "verifies": "With `default.integrity=ignore`, the broken `a rule` entry remains; with `repair`, it is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says ignore checks nothing; shared entries and unowned files are not touched; repair discards broken entries and resolved entries/files. The kept file contains a violation, so it is not resolved.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Good multi-condition test. It checks an ordinary nonempty file’s exact contents as well as the repair decisions.",
      "verifies": "Ignore preserves the listed regular-file names and their bytes; subsequent repair removes the broken and resolved entries/files, keeps both shared entries and the violating entry, and preserves the unowned file and kept-file contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines broken entries and says repair discards broken entries; the valid file contains a violation and the inconsistent entry points to an absent path.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Fair, but the “untouched” assertion checks keys and filenames rather than byte-for-byte identity.",
      "verifies": "Repair leaves the sole valid rule and its file in the consistent store, and removes the entry pointing to `gone` in the inconsistent store."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry whose path is not a regular file directly within the folder is broken, and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "A clear absent-file example; the broader suite tests other broken-path classes.",
      "verifies": "Repair removes the entry pointing to `not-there`, keeps the present rule, and leaves only the index and present file among regular files."
    },
    {
      "concerns": [],
      "evidence": "The prompt says broken entries will be discarded under repair; all three names in this setup are absent.",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Useful check that repair handles multiple broken entries in one index.",
      "verifies": "All three entries pointing to absent files are removed while the valid `present rule` remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a regular file directly in the folder; a directory is not a regular file. Repair discards the broken entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "Fair and distinguishes removing an index entry from deleting a directory.",
      "verifies": "The directory entry is removed, while the directory itself remains a directory."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a path that is not a regular file directly within the folder is broken and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingASocketIsBroken",
      "qualityCheck": "Good non-regular-file case. The test’s Unix-domain-socket setup is part of a shared platform assumption noted in overall.",
      "verifies": "The socket entry is removed, the healthy entry remains, and the socket still exists as neither a regular file nor a directory."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a path must be directly within the folder to be valid and that broken entries are discarded; the outside file is not a file in the store folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Important safety case; it checks both index cleanup and that repair does not delete or rewrite the outside target.",
      "verifies": "Repair removes the `../outside.txt` entry and leaves the outside file’s contents equal to `precious`."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires paths to be regular files directly within the folder and says broken entries are discarded. The two recorded absolute paths do not name files directly within this store.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "Fair. The test checks the unsafe paths are rejected without removing the separate in-folder file.",
      "verifies": "Repair removes both the absolute-path entry and the `/rooted-e448f3` entry, leaves the outside file and its contents intact, and preserves the separate in-folder file contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a regular file directly within the folder; a file in a nested directory is not directly within it. Repair discards the broken entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Clear nested-path case.",
      "verifies": "Repair removes the entry for `nested/violations` and the nested file remains present."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says an entry is broken if “the file name is not a valid path,” and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Good coverage of several invalid-name forms. The overlong-name case relies on filesystem component-length limits; see the shared environment note in overall.",
      "verifies": "Entries containing a NUL, an unpaired surrogate, or the overlong name are removed; the healthy rule/file remains with the asserted contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt treats an entry as broken when it does not point to a regular file directly within the folder. `./violations` resolves to the regular file directly in the folder; the unrelated `gone` entry is broken. The reader assertion also matches the existing store’s line-reading API at `TextFileBasedViolationStore.java:175-190`.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "Fair path-normalization case, with a useful end-to-end read assertion.",
      "verifies": "The `./violations` entry survives repair, the unrelated absent entry is removed, the file contents remain, and a reader returns exactly `a remaining violation`."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a regular file directly within the folder and says repair discards broken entries. The link target is outside the folder; the prompt separately specifies target deletion for resolved symbolic-link entries, not for this broken entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Useful distinction between discarding a broken entry and deleting a resolved link target.",
      "verifies": "Repair removes the entry naming `link-to-outside` and leaves the outside target’s contents equal to `precious`."
    },
    {
      "concerns": [],
      "evidence": "The prompt recognizes references through symbolic links when describing entries pointing to the same regular file, and says repair removes broken entries. The link resolves to an in-folder regular file containing a violation, so it is not resolved.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Good symlink-to-in-folder case; assertions cover both the link entry and target contents.",
      "verifies": "Repair removes the broken entry, retains the entry naming the in-folder link, and preserves the target’s violating contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the store will not touch files that no entry points to, and repair discards the broken entry. Neither the stray link nor its target is recorded by an entry.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Useful unowned-link case, complementing the unowned regular-file test.",
      "verifies": "Repair removes the broken index entry but leaves the unrecorded symlink and its outside target/content in place."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry is broken if it does not point to a regular file directly within the folder; a dangling link reaches no regular file. Repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "A concise dangling-link case.",
      "verifies": "Repair removes the entry naming the dangling symbolic link."
    },
    {
      "concerns": [],
      "evidence": "The prompt makes both entries broken because neither points to a regular file directly within the folder; repair discards broken entries. The link is not a resolved entry whose target should be deleted.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry",
      "qualityCheck": "Good check that a dangling alias is not treated as sharing a regular file.",
      "verifies": "Both entries are removed, and the dangling `alias` symlink itself remains a symlink."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries are shared by the same file name, but also says an entry is broken if its path does not point to a regular file directly within the folder. These spellings reach no file, so they are broken.",
      "fairness": "Prompt-stated",
      "name": "entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken",
      "qualityCheck": "Fair distinction between shared-name protection and two spellings that resolve to nothing.",
      "verifies": "Both entries, `gone` and `./gone`, are removed because neither spelling reaches a file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a nonbroken entry whose file has no violations is resolved, and repair discards resolved entries and their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Direct empty-file resolution case.",
      "verifies": "Repair removes the entry for the empty file and leaves only `stored.rules` among regular files."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says resolved entries and their files are discarded, and “If a resolved entry is a symbolic link the file it points to will be deleted as well.”",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Strong test of both the link and its target being removed.",
      "verifies": "Repair removes the entry, the target file, and the symbolic link; only the index remains among regular files and the path is no longer a symbolic link."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says files that only contain line breaks are resolved; it also defines resolution by the absence of violations and says repair discards resolved entries/files.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Fair representative line-break-only case.",
      "verifies": "The line-break-only entry/file is removed; the entry and file containing `some violation` remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt says “Files that only contain line breaks are also resolved.” CRLF, CR, and LF are the line-break forms constructed in this test.",
      "fairness": "Prompt-stated",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Useful breadth across common line-break encodings.",
      "verifies": "The CRLF-only, CR-only, and LF-only entries/files are removed; the file containing a violation remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry is resolved if its file has no violations; the setup contrasts one violation with an empty file.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Clear contrast case.",
      "verifies": "The one-violation entry/file remains and the empty entry/file is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries with the same file name are shared and that shared entries/files are not touched; it also says repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Direct shared-name case, including an empty file and an unrelated broken entry.",
      "verifies": "The two entries recording the same filename remain despite the empty file, the file remains, and the unrelated broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries reaching the same regular file are shared, including through symbolic links, “Even if that file is outside the folder,” and that shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Strong test of distinct names, link aliases, outside targets, and coexisting broken entries.",
      "verifies": "The in-folder entries reached by a file and symlink remain; outside entries reached by a direct outside path and symlink also remain, with the outside target and link still present; unrelated broken entries are removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a regular file directly within the folder; the shared target here is a directory, not a regular file. Repair discards both broken entries.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneDirectoryByDifferentNamesAreBothBroken",
      "qualityCheck": "Useful boundary case: shared identity does not turn a directory into a valid regular file.",
      "verifies": "Both entries reaching the directory are removed, while the directory and alias symlink remain and the healthy entry remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly includes hard links in entries reaching the same regular file and says this holds even if the file is outside the folder; shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Strong test of hard-link identity both inside and outside the store.",
      "verifies": "Both in-folder hard-link entries and both outside hard-link entries remain with their original names; the outside file contents remain `precious`; the unrelated broken entries are removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-name entries are shared and shared entries/files are not touched, even where another entry is resolved; repair removes resolved entries/files.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Good coverage of the shared-versus-resolved interaction.",
      "verifies": "The two entries sharing the empty file and that file remain; the separate resolved entry/file is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries recording the same filename are shared “even if nothing exists with that name,” and shared entries remain shared; repair removes the unrelated broken entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Directly exercises the unusual shared-but-broken case.",
      "verifies": "Both entries sharing the absent name remain, the lone broken entry is removed, and no regular file other than the index exists."
    },
    {
      "concerns": [],
      "evidence": "The prompt says files that no entry points to will not be touched, and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Good explicit unowned-file safety assertion.",
      "verifies": "The broken entry is removed while the unowned `notes.txt` file and its exact contents remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt limits entries to regular files directly within the folder and says files no entry points to are not touched; the buried file is in a subdirectory and is unowned.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Useful check that repair does not recurse into a nested directory.",
      "verifies": "Repair removes the separate broken entry, retains the valid rule/file, and leaves the buried unowned file’s contents unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair checks the index and folder during initialization and specifies which entries/files are discarded. After the first repair, no broken or resolved entry remains.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Fair idempotence check; it tests a settled store rather than external changes between initializations.",
      "verifies": "After a second repair initialization, the entry keys and regular-file names equal their post-first-repair values, and the store contains only the index and kept file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says references to the same regular file through a symbolic link are shared and shared entries/files are not touched; repair discards broken entries, leaving this store settled after its first repair.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Useful idempotence and alias-preservation check.",
      "verifies": "A second repair leaves the entry map and filenames equal to the first-repair snapshot, retains both aliasing entries, and preserves the target contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards the broken entry and leaves the non-resolved entry. The `contains` return values reflect the index lookup in `TextFileBasedViolationStore.java:134-140`.",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Useful integration check that the repaired on-disk index is visible to a distinct store.",
      "verifies": "A separately initialized store reports `contains(broken rule) == false` and `contains(kept rule) == true` after repair."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards the resolved entry/file and broken entry; the remaining entry points to `kept`.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Fair compact consistency assertion; it checks the index-to-file mapping as well as directory contents.",
      "verifies": "The regular-file names are exactly the index and kept file, and `kept rule` maps to the exact `kept` filename."
    },
    {
      "concerns": [],
      "evidence": "The prompt says resolved entries are discarded under repair. `contains` checks the stored rule description in `TextFileBasedViolationStore.java:134-140`.",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Good integration assertion using the store’s public lookup API.",
      "verifies": "After repair removes the resolved entry, a separately initialized reader reports `contains(resolvedRule) == false`."
    },
    {
      "concerns": [],
      "evidence": "The prompt implies a nonempty file is not resolved and requires broken-entry removal. The exact returned list is supported by the store’s read/unescape behavior at `TextFileBasedViolationStore.java:175-190` and existing exact-list tests at `TextFileBasedViolationStoreTest.java:78-85`.",
      "fairness": "Repo-discoverable",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Fair end-to-end check; the exact list assertion also verifies the existing text-file read contract.",
      "verifies": "The still-violating rule remains contained, `getViolations` returns exactly `one remaining violation`, and the adjacent broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The old resolved file removal is prompt-stated. Nonempty saving and reading are established by `TextFileBasedViolationStore.java:133-157,175-190` and existing tests at `TextFileBasedViolationStoreTest.java:48-85`; the new filename is generated by the store strategy.",
      "fairness": "Repo-discoverable",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Good recovery integration test. It does not pin the random filename, only that the stale resolved filename is not reused.",
      "verifies": "After repair discards the old resolved file, saving one new violation makes the rule contained, returns exactly `a new violation`, recreates its entry, and does not reuse the filename `resolved`."
    },
    {
      "concerns": [],
      "evidence": "Repair removal is prompt-stated. The first-evaluation behavior is documented in `FreezingArchRule.java:120-138` and tested in `FreezingArchRuleTest.java:107-113`; the evaluation’s store configuration is explicitly set in the test.",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Useful integration coverage beyond direct `save`; setup and assertions are visible.",
      "verifies": "After repair removes the resolved entry, a real `FreezingArchRule` evaluation has no violation, the reader then finds the rule, and the old `resolved` filename is absent."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair forgets a known rule when saving no violations and removes its entry/file. The existing store test also establishes that empty saved violations read as an empty list at `TextFileBasedViolationStoreTest.java:87-93`.",
      "fairness": "Prompt-stated",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "Strong contrast of repair and ignore; the non-repair read behavior is backed by the existing API tests.",
      "verifies": "Saving an empty list under repair removes the known rule and its file; saving empty under ignore retains that entry, and reading it returns an empty list."
    },
    {
      "concerns": [],
      "evidence": "The prompt says shared entries remain shared, even if outside the folder, and forgetting a shared entry removes only that entry. It also says files with no entry points to are not touched; the surviving peer still points to this outside file.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Important outside-folder safety case; the same-name peer makes the sharing condition explicit.",
      "verifies": "Saving empty removes only the forgotten rule’s entry while the peer entry with the same outside filename remains; the outside file still exists with contents `precious`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says if another entry shares the file, only the forgotten entry is removed. The target contains a violation, so it is not resolved.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Good shared-file save case with a read-after-write check.",
      "verifies": "Saving empty removes `forgotten rule`, retains the other entry and both filenames, preserves the shared target’s exact contents, and the writer still reads the other rule’s violation."
    },
    {
      "concerns": [],
      "evidence": "The prompt says forgetting a known rule removes its file and, for a symbolic link, deletes its target too, unless another entry shares the file. No other entry points to this target.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
      "qualityCheck": "Directly covers the unshared symbolic-link deletion path and verifies the unrelated rule remains readable.",
      "verifies": "Saving empty removes the forgotten entry, its symbolic link, and the link target; it leaves the unrelated rule/file and its exact violation, and `contains(forgottenRule)` is false."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says that if the file cannot be deleted while forgetting a rule, saving fails and leaves the entry. The later retry checks the same rule can be forgotten when deletion is possible.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "Strong failure-and-recovery check. The asserted text is a probe-generated status, not a pinned production exception message. This test shares the suite’s POSIX/privilege environment assumptions noted in overall.",
      "verifies": "When the rule file cannot be deleted, saving empty produces the test’s `rejected, still stored with [one violation]` outcome, leaves the index mapping and contents intact, then succeeds after deletion is possible and removes the entry/file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says that under repair, saving no violations for an unknown rule saves nothing.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct unknown-rule no-op case.",
      "verifies": "Saving an empty list for an unknown rule leaves the index empty and the index as the only regular file."
    },
    {
      "concerns": [],
      "evidence": "The prompt distinguishes resolved entries (no violations) from entries with violations; the latter are not resolved. Existing store read semantics at `TextFileBasedViolationStore.java:175-190` and the exact-list test at `TextFileBasedViolationStoreTest.java:78-85` support the asserted list shape.",
      "fairness": "Prompt-stated",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Fair, though it covers one representative nonempty save.",
      "verifies": "Saving the remaining violation keeps the rule as the only index entry and `getViolations` returns exactly `first violation`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair checks the index during initialization, but does not specify rereading an index externally rewritten after a prior initialization. I searched the description for `index`, `initialization`, `on disk`, `earlier initialization`, `reload`, and `external change`; no freshness-after-external-edit requirement appears. Repo searches for `integrity`, `repair`, `reload`, `reinitializ`, and cache symbols found `TextFileBasedViolationStore.java:77,118,220`: the store uses a static path-keyed `STORED_RULES_BY_PATH`, `computeIfAbsent`, and loads properties when that cached object is created. Reusing that cache is a concrete repo-grounded alternative to reloading this externally modified file, so the test selects behavior not singled out by the prompt/repo.",
      "fairness": "Not fair",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "The scenario is explicit and deterministic, but external mutation of the index while a cached store exists is not a stated use case; the existing path-keyed cache makes the alternative behavior concrete.",
      "verifies": "After the test externally rewrites `stored.rules` between two initializations of the same folder, repair removes the newly written absent-file entry, leaving the index empty."
    }
  ],
  "unfairTestCount": 1,
  "verdict": "FAIL"
}
Close