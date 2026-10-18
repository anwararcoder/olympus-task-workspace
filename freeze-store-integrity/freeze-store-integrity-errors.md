# Test Quality
Verdict

FAIL
2 of 46 unfair
The bulk of the maintenance tests are fair: they translate explicit prompt rules into concrete index, file, link, and save assertions, and the integration checks use the repo’s visible ViolationStore/FreezingArchRule API. Two tests overreach: the deletion-failure test requires the original file contents to survive (the prompt only says fail and leave the entry), and the repeated-initialization test requires reloading an externally overwritten index despite the repo’s canonical-path cache. The symlink/hard-link cases require filesystem link support; the permission failure test additionally assumes POSIX permissions and may use `setpriv`. Those are environment assumptions in these test setups, not separate fairness failures.

Unfair Tests

Not fair
forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry
Verifies: When deletion is blocked, saving no violations must throw a runtime failure, leave the index entry and filename intact, preserve the file’s exact contents (`one violation\n`), and subsequently forget the rule once deletion becomes possible.

Evidence: The prompt states only: “If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry.” Searches of the description for “cannot delete,” “fail to save,” “leave the entry,” “contents,” and “violations” find no requirement that the file’s bytes remain unchanged after failure. The source’s existing write path uses `Files.write` and wraps I/O errors (`TextFileBasedViolationStore.java:159-166`), but does not establish transactional rollback. A valid implementation could retain the index entry on deletion failure while having already changed the file; the prompt does not rule that out. The exact exception behavior is consistent with the repo’s runtime `StoreUpdateFailedException` (`StoreUpdateFailedException.java:18-23`), but that does not justify the unchanged-content assertion.

Quality: The core requirement that save fails and leaves the entry is prompt-stated. The test additionally pins unchanged stored violations, which is not stated and is not guaranteed by the existing write path. The exact helper-generated outcome string is also a brittle formatted assertion. It assumes POSIX permissions and has a setpriv-dependent path; see the shared environment note.

brittle message
env assumption
Not fair
repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder
Verifies: After the same folder was initialized once, the test overwrites `stored.rules` on disk with a new broken entry; a second repair initialization must then leave the on-disk index empty.

Evidence: The prompt says repair checks the index during initialization, but does not state that an already-initialized store must reload external edits made directly to `stored.rules`. Search of the prompt for “on disk,” “earlier initialization,” “external,” “reload,” and “same folder” finds no such condition. The repo provides a concrete alternative: `TextFileBasedViolationStore.java:87-90` caches `FileSyncedProperties` by canonical path, and `TextFileBasedViolationStore.java:221-240` loads the properties into an in-memory object; repeated initialization can reuse that cached state. Thus a competent solution following the visible cache convention could repair its in-memory index without observing this out-of-band file rewrite.

Quality: This goes beyond repair of the index presented at initialization: it specifically requires observing an external write between two initializations of the same path, despite the repo’s path-keyed cache. The tested behavior is not explicit in the prompt and conflicts with a visible repository convention.

Requirement Coverage (9/11 covered)

Advisory only — prompt-stated requirements and whether the hidden tests pin them.

covered
With no integrity setting, the store defaults to ignore and performs no integrity checking.

"Defaulting to `ignore` which checks nothing."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingSoRepairStillFindsEveryCondition

covered
Repair checks the index and folder during initialization.

"Setting `default.integrity` to `repair` will check the index and folder during initialization."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingSoRepairStillFindsEveryCondition, repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne

partial
An entry is broken if its target is not a regular file directly within the folder, including invalid path names.

"If an entry points to a path that is not a regular file directly within the folder, it is broken. This also applies if the file name is not a valid path."

anEntryWhoseFileIsAbsentIsBroken, anEntryRecordingADirectoryIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched, anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives, anEntryRecordingANestedNameIsBrokenAndThatFileSurvives, anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne, anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives, anEntryNamingADanglingLinkIsBroken

covered
An unbroken entry whose file has no violations is resolved; files containing only line breaks are also resolved.

"If an entry is not broken and its file has no violations it is resolved. Files that only contain line breaks are also resolved."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks, anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs

covered
Entries with the same recorded filename are shared even if no file exists; entries reaching the same file by different names are shared, including through symbolic/hard links and outside the folder.

"Entries that point to the same file name are shared, even if nothing exists with that name. If multiple entries point to the same file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."

aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair

covered
Shared entries/files and files with no entry pointing to them are not touched; shared entries remain shared even when also broken or resolved.

"The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to. If an entry is shared and anything else it will remain shared."

ignoreExaminesNothingSoRepairStillFindsEveryCondition, aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded, aSharedNameHoldingNoViolationsIsNotDiscardedEither, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair, anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded, aFileInsideADirectoryInTheStoreFolderIsNeverACondition

covered
Repair discards broken entries.

"When set to `repair` broken entries will be discarded."

anEntryWhoseFileIsAbsentIsBroken, everyBrokenEntryIsDiscarded, anEntryRecordingADirectoryIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched, anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives, anEntryRecordingANestedNameIsBrokenAndThatFileSurvives

covered
Repair discards resolved entries and their files, and deletes the target of a resolved symbolic link as well.

"When set to `repair` resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt, aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks

covered
Saving no violations under repair forgets a known rule, removing its entry and file unless another entry shares the file; shared files are retained even outside the folder.

"If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."

storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside, forgettingARuleKeepsTheFileAnotherEntryStillRecords, forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile

covered
Saving no violations for an unknown rule under repair stores nothing.

"If using `repair` and saving no violations for an unknown rule nothing will be saved."

forgettingARuleTheIndexNeverKnewStoresNothingForIt

partial
If the file cannot be deleted while forgetting a rule, save fails and the entry remains.

"If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."

forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry

Coverage Suggestions (2)

Advisory only — these don't affect the check result.

Invalid recorded filenames
single point
Prompt-stated
Requirement: An entry is broken if its target is not a regular file directly within the folder, including invalid path names.

Add another invalid-path example distinct from NUL, so a solution that special-cases this one filename does not cover the whole invalid-path requirement.

Deletion failure rollback semantics
not discriminating
needs prompt edit
Requirement: If the file cannot be deleted while forgetting a rule, save fails and the entry remains.

If the intended contract requires the stored violation bytes to remain unchanged when deletion fails, state that explicitly in the prompt; otherwise narrow this test to the specified save failure and retained index entry.

Quality Notes (44)

Prompt-stated
absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
A direct contrast between the specified default and repair behavior. It uses one broken-entry example.

Prompt-stated
ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Fair and largely redundant with the absent-setting test; it distinguishes an explicit ignore value from the default.

Prompt-stated
ignoreExaminesNothingSoRepairStillFindsEveryCondition
The test checks both non-mutation under ignore and several distinct repair outcomes. Its setup makes the shared, resolved, broken, and unowned cases visible.

Prompt-stated
repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne
Fair, though the consistent-store assertion is a single simple case.

Prompt-stated
anEntryWhoseFileIsAbsentIsBroken
A direct missing-file case with a healthy control.

Prompt-stated
everyBrokenEntryIsDiscarded
Fair; adds a multiple-broken-entry case beyond the single-entry test.

Prompt-stated
anEntryRecordingADirectoryIsBroken
A useful file-type distinction, with an assertion that repair does not delete the directory itself.

Prompt-stated
anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched
Fair and concrete. The content assertion verifies preservation, not merely existence.

Prompt-stated
anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives
Fair. It checks multiple absolute-path forms in one setup; the expected path treatment is grounded in the direct-within-folder requirement.

Prompt-stated
anEntryRecordingANestedNameIsBrokenAndThatFileSurvives
A direct nested-path case.

Prompt-stated
anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne
Fair but shallow for the class of invalid path names; this test uses only a NUL-containing name.

overfit
Prompt-stated
anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken
Fair. This both tests a normalized in-folder spelling and exercises reading the surviving entry.

Prompt-stated
anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives
Fair, conditional on the filesystem supporting symbolic links; that platform assumption is noted once in the overall review.

Prompt-stated
anEntryNamingALinkToAFileInTheStoreOwnsThatFile
Fair link-to-in-folder case; it does not assert the file’s bytes beyond the content remaining present.

Prompt-stated
aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget
Fair preservation check for unowned link and target.

Prompt-stated
anEntryNamingADanglingLinkIsBroken
Fair, narrow dangling-link example.

Prompt-stated
anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry
Fair distinction between removing an index entry and deleting a broken path object.

Prompt-stated
entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken
Fair; complements the same-name-but-missing shared case.

Prompt-stated
anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile
Direct empty-file case.

Prompt-stated
aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt
Fair and checks both the target and the link path, rather than checking only the index.

Prompt-stated
aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry
Fair; one LF-only resolved example and a non-empty control.

Prompt-stated
aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks
Fair and broader than the LF-only case by exercising three line-break encodings.

Prompt-stated
anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs
Fair. It uses one violation as a representative non-empty case.

Prompt-stated
aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded
Fair; it demonstrates that sharing takes precedence over the otherwise-resolved empty-file case.

Prompt-stated
twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded
Fair and directly tests both in-folder and outside shared targets. It depends on symbolic-link support.

Prompt-stated
twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded
Fair hard-link case; depends on hard-link support.

Prompt-stated
aSharedNameHoldingNoViolationsIsNotDiscardedEither
Fair and tests the resolved-versus-shared distinction.

Prompt-stated
anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair
Fair and directly tests shared-but-broken precedence.

Prompt-stated
anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded
Direct preservation check for an unowned direct file.

Prompt-stated
aFileInsideADirectoryInTheStoreFolderIsNeverACondition
Fair, though it is a single nested-unowned-file example.

Prompt-stated
aSecondInitializationOfARepairedFolderDiscardsNothing
Fair idempotence check, though the exact file-list comparison is a narrow instance.

Prompt-stated
anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled
Fair and combines alias-sharing with repeat repair; depends on symbolic-link support.

Prompt-stated
aSeparatelyCreatedStoreObservesTheRepairedIndex
Fair integration check that verifies the repaired index is visible to another store instance.

Prompt-stated
aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord
Fair, but its entry/file arrangement is one straightforward representative case.

Prompt-stated
aRuleWhoseEntryWasDiscardedIsNoLongerFrozen
Fair user-visible API check of entry removal.

Prompt-stated
repairKeepsAStillViolatingRuleFrozenWithItsViolations
Fair integration check; exactly one surviving violation is a representative data point.

Prompt-stated
aRepairedStoreCanFreezeARuleAgain
Fair repair-to-save integration test. The random replacement filename is not pinned; only non-reuse of the old resolved name is checked.

Repo-discoverable
aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation
Fair integration coverage of the actual FreezingArchRule path, not just a direct store save.

Prompt-stated
storingNoViolationsUnderRepairForgetsTheEntryAndItsFile
Fair comparison of repair and ignore. It does not exercise a shared file in this test; separate tests do.

Prompt-stated
forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside
Fair and combines outside-folder sharing with save-time forgetting.

Prompt-stated
forgettingARuleKeepsTheFileAnotherEntryStillRecords
Fair; it checks that the remaining rule remains usable, not only indexed. Depends on symlink support.

Prompt-stated
forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile
Fair; checks link and target cleanup plus preservation of an unrelated rule. Depends on symlink support.

Prompt-stated
forgettingARuleTheIndexNeverKnewStoresNothingForIt
Direct unknown-rule case under repair.

Prompt-stated
aStillViolatedRuleKeepsItsEntryUnderRepair
Fair but narrow one-violation update case.

Task Summary

The task asks for integrity maintenance in TextFileBasedViolationStore: absent/default or explicit ignore mode should not check the store, while repair mode should remove broken and resolved entries/files, preserve shared or unowned data, and forget known rules saved with no violations without losing entries when deletion fails. The patch adds focused tests for initialization, path and link cases, resolution, sharing, deletion, and FreezingArchRule integration.

Completed in 195.4s

Hide raw output
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Invalid recorded filenames",
      "gapKind": "single_point",
      "requirement": "An entry is broken if its target is not a regular file directly within the folder, including invalid path names.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Add another invalid-path example distinct from NUL, so a solution that special-cases this one filename does not cover the whole invalid-path requirement."
    },
    {
      "area": "Deletion failure rollback semantics",
      "gapKind": "not_discriminating",
      "requirement": "If the file cannot be deleted while forgetting a rule, save fails and the entry remains.",
      "sourceIfAdded": "Would need prompt edit",
      "suggestion": "If the intended contract requires the stored violation bytes to remain unchanged when deletion fails, state that explicitly in the prompt; otherwise narrow this test to the specified save failure and retained index entry."
    }
  ],
  "error": "",
  "executionTimeSeconds": 195.366905,
  "message": "2 tests flagged as not fair.",
  "overall": "The bulk of the maintenance tests are fair: they translate explicit prompt rules into concrete index, file, link, and save assertions, and the integration checks use the repo’s visible ViolationStore/FreezingArchRule API. Two tests overreach: the deletion-failure test requires the original file contents to survive (the prompt only says fail and leave the entry), and the repeated-initialization test requires reloading an externally overwritten index despite the repo’s canonical-path cache. The symlink/hard-link cases require filesystem link support; the permission failure test additionally assumes POSIX permissions and may use `setpriv`. Those are environment assumptions in these test setups, not separate fairness failures.",
  "requirements": [
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition"
      ],
      "requirement": "With no integrity setting, the store defaults to ignore and performs no integrity checking.",
      "sourceQuote": "Defaulting to `ignore` which checks nothing."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
        "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne"
      ],
      "requirement": "Repair checks the index and folder during initialization.",
      "sourceQuote": "Setting `default.integrity` to `repair` will check the index and folder during initialization."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
        "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
        "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
        "anEntryNamingADanglingLinkIsBroken"
      ],
      "requirement": "An entry is broken if its target is not a regular file directly within the folder, including invalid path names.",
      "sourceQuote": "If an entry points to a path that is not a regular file directly within the folder, it is broken. This also applies if the file name is not a valid path."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
        "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs"
      ],
      "requirement": "An unbroken entry whose file has no violations is resolved; files containing only line breaks are also resolved.",
      "sourceQuote": "If an entry is not broken and its file has no violations it is resolved. Files that only contain line breaks are also resolved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair"
      ],
      "requirement": "Entries with the same recorded filename are shared even if no file exists; entries reaching the same file by different names are shared, including through symbolic/hard links and outside the folder.",
      "sourceQuote": "Entries that point to the same file name are shared, even if nothing exists with that name. If multiple entries point to the same file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "aFileInsideADirectoryInTheStoreFolderIsNeverACondition"
      ],
      "requirement": "Shared entries/files and files with no entry pointing to them are not touched; shared entries remain shared even when also broken or resolved.",
      "sourceQuote": "The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to. If an entry is shared and anything else it will remain shared."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "everyBrokenEntryIsDiscarded",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives"
      ],
      "requirement": "Repair discards broken entries.",
      "sourceQuote": "When set to `repair` broken entries will be discarded."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks"
      ],
      "requirement": "Repair discards resolved entries and their files, and deletes the target of a resolved symbolic link as well.",
      "sourceQuote": "When set to `repair` resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
        "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile"
      ],
      "requirement": "Saving no violations under repair forgets a known rule, removing its entry and file unless another entry shares the file; shared files are retained even outside the folder.",
      "sourceQuote": "If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleTheIndexNeverKnewStoresNothingForIt"
      ],
      "requirement": "Saving no violations for an unknown rule under repair stores nothing.",
      "sourceQuote": "If using `repair` and saving no violations for an unknown rule nothing will be saved."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry"
      ],
      "requirement": "If the file cannot be deleted while forgetting a rule, save fails and the entry remains.",
      "sourceQuote": "If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."
    }
  ],
  "taskSummary": "The task asks for integrity maintenance in TextFileBasedViolationStore: absent/default or explicit ignore mode should not check the store, while repair mode should remove broken and resolved entries/files, preserve shared or unowned data, and forget known rules saved with no violations without losing entries when deletion fails. The patch adds focused tests for initialization, path and link cases, resolution, sharing, deletion, and FreezingArchRule integration.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The prompt says, “Setting `default.integrity` to `repair` will check the index and folder during initialization. Defaulting to `ignore` which checks nothing.” It also says, “When set to `repair` broken entries will be discarded.”",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "A direct contrast between the specified default and repair behavior. It uses one broken-entry example.",
      "verifies": "With no integrity property, the broken “a rule” index entry remains; after initialization with repair, the index has no entries."
    },
    {
      "concerns": [],
      "evidence": "The prompt specifies “Defaulting to `ignore` which checks nothing” and that repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Fair and largely redundant with the absent-setting test; it distinguishes an explicit ignore value from the default.",
      "verifies": "Explicit ignore leaves the broken entry present, while repair removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt says ignore “checks nothing”; repair discards broken and resolved entries and their files; shared entries/files and files with no entry pointing to them are not touched. The byte-for-byte preservation aspect is also consistent with existing initialization loading, rather than rewriting, an existing index: `TextFileBasedViolationStore.java:231-270`.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "The test checks both non-mutation under ignore and several distinct repair outcomes. Its setup makes the shared, resolved, broken, and unowned cases visible.",
      "verifies": "Ignore preserves the directory’s direct-file listing and each existing file’s bytes; a later repair removes the missing-path and empty-file entries/files, keeps both entries sharing a file and a violating entry, and preserves the unowned file and its content."
    },
    {
      "concerns": [],
      "evidence": "The prompt specifies that repair checks the index and folder, discards broken entries, and does not touch shared entries or files with no entry pointing to them; retaining a healthy entry is consistent with those stated repair effects.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Fair, though the consistent-store assertion is a single simple case.",
      "verifies": "Repair preserves the entry and direct files of a consistent store, and removes the broken entry from an inconsistent store."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry pointing to a path that is not a regular file directly within the folder is broken, and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "A direct missing-file case with a healthy control.",
      "verifies": "Repair removes an entry whose recorded filename is absent, keeps the healthy entry, and leaves only the index and healthy file in the folder."
    },
    {
      "concerns": [],
      "evidence": "The prompt says “When set to `repair` broken entries will be discarded.”",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Fair; adds a multiple-broken-entry case beyond the single-entry test.",
      "verifies": "All three entries pointing to absent files are removed, while the entry pointing to a present file remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires an entry to point to a regular file directly within the folder; a directory is not a regular file. It says broken entries are discarded.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "A useful file-type distinction, with an assertion that repair does not delete the directory itself.",
      "verifies": "Repair removes the entry whose path is a directory and leaves that directory present."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a path must be a regular file directly within the folder and that the store will not touch files no entry points to; the escape path is not directly within the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Fair and concrete. The content assertion verifies preservation, not merely existence.",
      "verifies": "Repair removes the `../outside.txt` entry while the outside file remains and retains the exact content `precious`."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires paths to be regular files directly within the store folder and says broken entries are discarded. It also says files with no entry pointing to them are not touched.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "Fair. It checks multiple absolute-path forms in one setup; the expected path treatment is grounded in the direct-within-folder requirement.",
      "verifies": "Repair removes both the outside absolute-path entry and the entry whose recorded path begins with `/`, preserves the outside file and its exact contents, and leaves the separate in-store file’s content intact."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a valid entry must point to a regular file directly within the folder; a file in a nested directory is not directly within it.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "A direct nested-path case.",
      "verifies": "Repair removes the nested-path entry but preserves the nested file."
    },
    {
      "concerns": [
        "overfit_single_point"
      ],
      "evidence": "The prompt explicitly says broken status also applies when “the file name is not a valid path,” and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Fair but shallow for the class of invalid path names; this test uses only a NUL-containing name.",
      "verifies": "Repair removes the entry whose filename contains NUL, preserves the healthy entry and file, and leaves only the index and healthy file as direct files."
    },
    {
      "concerns": [],
      "evidence": "The prompt’s criterion is whether the entry points to a regular file directly within the folder, not whether its spelling is a bare filename. The existing reader’s line parsing is visible at `TextFileBasedViolationStore.java:196-204`; the test’s returned violation is the single stored line.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "Fair. This both tests a normalized in-folder spelling and exercises reading the surviving entry.",
      "verifies": "The `./violations` entry survives repair, the healthy file content remains, and a reader initialized in ignore mode returns exactly `a remaining violation`."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the pointed-to file to be directly within the folder, says symbolic links count when determining shared files, and says outside files must not be touched when unowned. In this setup the outside target is not otherwise recorded.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Fair, conditional on the filesystem supporting symbolic links; that platform assumption is noted once in the overall review.",
      "verifies": "Repair removes the entry naming a symlink to an outside target and preserves the target’s content."
    },
    {
      "concerns": [],
      "evidence": "The prompt’s direct-in-folder regular-file condition and explicit symbolic-link sharing language support treating a link to an in-folder file as pointing to that file; repair removes the broken entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Fair link-to-in-folder case; it does not assert the file’s bytes beyond the content remaining present.",
      "verifies": "Repair removes the unrelated broken entry but retains the entry naming an in-folder symlink and preserves the target’s violation content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the store will not touch files that no entry points to. Neither the stray link nor its target is named by the index in this setup.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Fair preservation check for unowned link and target.",
      "verifies": "Repair removes the broken index entry but leaves the unrecorded symlink and outside target, with the target’s content unchanged."
    },
    {
      "concerns": [],
      "evidence": "A dangling link does not point to a regular file directly within the folder, meeting the prompt’s broken-entry condition.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "Fair, narrow dangling-link example.",
      "verifies": "Repair removes the entry naming a dangling symlink."
    },
    {
      "concerns": [],
      "evidence": "Both names fail the prompt’s regular-file/direct-in-folder condition, so both entries are broken and discarded. The prompt does not require deleting the link itself as part of discarding a broken entry; the rule against touching files no entry points to supports leaving it.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry",
      "qualityCheck": "Fair distinction between removing an index entry and deleting a broken path object.",
      "verifies": "Repair removes both entries, and the dangling symlink itself remains a symlink."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines broken entries by whether they point to a qualifying regular file, and separately says entries sharing a filename can be shared even if nothing exists under that name. These two entries have different spellings and reach no file.",
      "fairness": "Prompt-stated",
      "name": "entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken",
      "qualityCheck": "Fair; complements the same-name-but-missing shared case.",
      "verifies": "Repair removes both entries, even though one filename is `gone` and the other is `./gone`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an unbroken entry whose file has no violations is resolved, and repair discards resolved entries and their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Direct empty-file case.",
      "verifies": "Repair removes the empty-file entry and leaves only `stored.rules` among direct files."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards resolved entries and their files and specifically says that if a resolved entry is a symbolic link, “the file it points to will be deleted as well.” Removing the resolved entry’s link name follows from discarding that entry/file.",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Fair and checks both the target and the link path, rather than checking only the index.",
      "verifies": "Repair removes the resolved entry, the symlink itself, and the empty target, leaving only the index; it also asserts the link is no longer a symlink."
    },
    {
      "concerns": [],
      "evidence": "The prompt says files with no violations are resolved and “Files that only contain line breaks are also resolved.” It says repair discards resolved entries and files.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Fair; one LF-only resolved example and a non-empty control.",
      "verifies": "Repair removes the entry and file containing only `\\n` characters, while retaining the entry and file containing `some violation\\n`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says files containing only line breaks are resolved and files with violations are not resolved; it does not restrict the line-break type.",
      "fairness": "Prompt-stated",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Fair and broader than the LF-only case by exercising three line-break encodings.",
      "verifies": "Repair removes entries/files containing only CRLF, CR, or LF, and retains the file containing `a violation\\r\\n`."
    },
    {
      "concerns": [],
      "evidence": "The prompt distinguishes an entry with no violations (resolved) from one whose file contains a violation.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Fair. It uses one violation as a representative non-empty case.",
      "verifies": "Repair retains the single-violation entry/file and removes the empty entry/file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries pointing to the same filename are shared, even if nothing exists with that name, and shared entries/files are not touched; broken entries are discarded.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Fair; it demonstrates that sharing takes precedence over the otherwise-resolved empty-file case.",
      "verifies": "Both entries recording the same empty filename remain, and that file remains, while the unrelated broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries pointing to the same file are shared “Including through a symbolic or hard link. Even if that file is outside the folder,” and shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Fair and directly tests both in-folder and outside shared targets. It depends on symbolic-link support.",
      "verifies": "For an in-folder symlink alias to an empty target, both entries and both path objects remain. For the outside file reached by `../outside.txt` and a symlink, both entries and the link/target remain, with the exact outside path strings still in the index."
    },
    {
      "concerns": [],
      "evidence": "The prompt expressly includes sharing “through a symbolic or hard link” and says shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Fair hard-link case; depends on hard-link support.",
      "verifies": "Both index entries and both hard-link names remain for the empty shared file, with the exact original filenames still mapped to the respective entries."
    },
    {
      "concerns": [],
      "evidence": "The prompt says shared entries/files are not touched, while an unshared entry with no violations is resolved and discarded under repair.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Fair and tests the resolved-versus-shared distinction.",
      "verifies": "The two entries sharing an empty file remain, while the unshared empty entry and its file are removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-filename entries are shared even if nothing exists with that name, and that an entry shared and anything else “will remain shared.” It also says lone broken entries are discarded.",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Fair and directly tests shared-but-broken precedence.",
      "verifies": "Both entries with the same absent filename remain; the lone entry with a different absent filename is removed; no direct file besides the index is expected."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the store will not touch files that no entry points to, and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Direct preservation check for an unowned direct file.",
      "verifies": "Repair removes the broken entry but preserves the unowned `notes.txt` file and its exact content."
    },
    {
      "concerns": [],
      "evidence": "The prompt describes the index and folder, requires entry paths to be directly within the folder, and says files with no entry pointing to them are not touched. The nested file is not a direct child and is not indexed.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Fair, though it is a single nested-unowned-file example.",
      "verifies": "Repair removes the broken index entry, retains the healthy entry/file, and preserves the nested unowned file’s exact content."
    },
    {
      "concerns": [],
      "evidence": "Repair discards broken entries and resolved entries/files, while a healthy entry remains. After the first repair the setup has no such conditions remaining; the prompt’s instruction not to touch unowned files also constrains later repair.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Fair idempotence check, though the exact file-list comparison is a narrow instance.",
      "verifies": "After two repair initializations, the surviving entry remains and the sorted direct-file listing equals the listing after the first repair; only the index and healthy file are present."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries reaching the same file through symbolic links are shared and will not be touched, while the broken entry is discarded. The file contains a violation, so it is not resolved.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Fair and combines alias-sharing with repeat repair; depends on symbolic-link support.",
      "verifies": "After a second repair, the index equals its post-first-repair properties and contains exactly the two entries pointing through the alias and directly to the violating file; the file content is unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires repair to discard the broken entry and retain the healthy entry. The API’s `contains` directly reports stored-rule membership: `TextFileBasedViolationStore.java:155-157`.",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Fair integration check that verifies the repaired index is visible to another store instance.",
      "verifies": "A separately constructed store initialized in ignore mode reports `contains(broken rule) == false` and `contains(kept rule) == true` after repair."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards broken and resolved entries/files, and that files with no entry pointing to them are not touched. In this setup only the kept file has a surviving entry.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Fair, but its entry/file arrangement is one straightforward representative case.",
      "verifies": "After repair, the direct-file listing is exactly `stored.rules` plus the kept file, and the kept entry maps to that exact filename."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a resolved entry is discarded under repair. The repo’s API uses index membership for `contains`: `TextFileBasedViolationStore.java:155-157`.",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Fair user-visible API check of entry removal.",
      "verifies": "After repair removes the resolved rule’s index entry, a reader reports that `contains(resolvedRule)` is false."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a file with violations is not resolved, and repair discards broken entries. Existing store API methods expose membership and stored violations at `TextFileBasedViolationStore.java:155-157` and `190-204`.",
      "fairness": "Prompt-stated",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Fair integration check; exactly one surviving violation is a representative data point.",
      "verifies": "The reader reports the violating rule is contained, returns exactly `one remaining violation`, and the index contains only that rule after the neighboring broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires resolved entries/files to be discarded and says saving no violations for an unknown rule saves nothing; the API supports later saving violations for a rule. The exact returned violation follows the input saved and the reader behavior in `TextFileBasedViolationStore.java:190-204`.",
      "fairness": "Prompt-stated",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Fair repair-to-save integration test. The random replacement filename is not pinned; only non-reuse of the old resolved name is checked.",
      "verifies": "After repair removes the resolved entry, saving one new violation makes the rule contained and returns exactly `a new violation`; the index has only that rule and the old filename `resolved` is absent from the file listing."
    },
    {
      "concerns": [],
      "evidence": "The repair/removal portion is prompt-stated. For the additional exact evaluation result, `FreezingArchRule.java:124-138` shows that when the store does not contain the rule, it saves the evaluation result and returns a successful EvaluationResult. The re-freeze membership check uses the `contains` API at `FreezingArchRule.java:124`.",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Fair integration coverage of the actual FreezingArchRule path, not just a direct store save.",
      "verifies": "After repair, the index is empty; a real FreezingArchRule evaluation returns `hasViolation() == false`, then a reader finds the rule stored and the old `resolved` filename is absent."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair forgets a known rule saved with no violations and removes its file unless shared; it says nothing is saved for an unknown rule. The contrast setup uses ignore, which checks nothing. Existing empty-list read behavior is tested in `TextFileBasedViolationStoreTest.java:87-93`.",
      "fairness": "Prompt-stated",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "Fair comparison of repair and ignore. It does not exercise a shared file in this test; separate tests do.",
      "verifies": "Saving an empty list for a known rule under repair removes its entry and file; under ignore the entry remains and `getViolations` returns an empty list."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-filename entries are shared even if the file is outside the folder, shared entries/files are not touched, and saving no violations removes only the entry when another entry shares the file.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Fair and combines outside-folder sharing with save-time forgetting.",
      "verifies": "Saving no violations for one of two entries with the same `../outside.txt` name removes only the saved rule’s entry, preserves the peer’s exact path string, and preserves the outside file and exact contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt says symbolic links count when entries share a file and that when another entry shares the file only the forgotten entry is removed. Existing `getViolations` reads stored lines at `TextFileBasedViolationStore.java:190-204`.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Fair; it checks that the remaining rule remains usable, not only indexed. Depends on symlink support.",
      "verifies": "Saving no violations for the rule recorded through a symlink leaves the other entry, both path names, the target’s exact content, and the other rule’s exact returned violation intact."
    },
    {
      "concerns": [],
      "evidence": "The prompt says save-time forgetting removes the entry and its file unless another entry shares it; it specifically says a resolved symlink’s target is deleted as well. The `contains` and violation-reading APIs are visible at `TextFileBasedViolationStore.java:155-157` and `190-204`.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
      "qualityCheck": "Fair; checks link and target cleanup plus preservation of an unrelated rule. Depends on symlink support.",
      "verifies": "Saving no violations removes the rule entry, the target file, and the link path; the remaining rule’s exact violation stays readable and the forgotten rule is not contained."
    },
    {
      "concerns": [
        "brittle_message_matching",
        "environment_assumption"
      ],
      "evidence": "The prompt states only: “If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry.” Searches of the description for “cannot delete,” “fail to save,” “leave the entry,” “contents,” and “violations” find no requirement that the file’s bytes remain unchanged after failure. The source’s existing write path uses `Files.write` and wraps I/O errors (`TextFileBasedViolationStore.java:159-166`), but does not establish transactional rollback. A valid implementation could retain the index entry on deletion failure while having already changed the file; the prompt does not rule that out. The exact exception behavior is consistent with the repo’s runtime `StoreUpdateFailedException` (`StoreUpdateFailedException.java:18-23`), but that does not justify the unchanged-content assertion.",
      "fairness": "Not fair",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "The core requirement that save fails and leaves the entry is prompt-stated. The test additionally pins unchanged stored violations, which is not stated and is not guaranteed by the existing write path. The exact helper-generated outcome string is also a brittle formatted assertion. It assumes POSIX permissions and has a setpriv-dependent path; see the shared environment note.",
      "verifies": "When deletion is blocked, saving no violations must throw a runtime failure, leave the index entry and filename intact, preserve the file’s exact contents (`one violation\\n`), and subsequently forget the rule once deletion becomes possible."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says, “If using `repair` and saving no violations for an unknown rule nothing will be saved.”",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct unknown-rule case under repair.",
      "verifies": "Saving an empty list for an unknown rule leaves the index empty and the directory containing only `stored.rules`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards broken entries and says only a rule saved with no violations is forgotten. A file containing a remaining violation is not resolved. The read API is visible at `TextFileBasedViolationStore.java:190-204`.",
      "fairness": "Prompt-stated",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Fair but narrow one-violation update case.",
      "verifies": "Saving one remaining violation retains the rule entry and `getViolations` returns exactly `first violation`; the neighboring broken entry is absent."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair checks the index during initialization, but does not state that an already-initialized store must reload external edits made directly to `stored.rules`. Search of the prompt for “on disk,” “earlier initialization,” “external,” “reload,” and “same folder” finds no such condition. The repo provides a concrete alternative: `TextFileBasedViolationStore.java:87-90` caches `FileSyncedProperties` by canonical path, and `TextFileBasedViolationStore.java:221-240` loads the properties into an in-memory object; repeated initialization can reuse that cached state. Thus a competent solution following the visible cache convention could repair its in-memory index without observing this out-of-band file rewrite.",
      "fairness": "Not fair",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "This goes beyond repair of the index presented at initialization: it specifically requires observing an external write between two initializations of the same path, despite the repo’s path-keyed cache. The tested behavior is not explicit in the prompt and conflicts with a visible repository convention.",
      "verifies": "After the same folder was initialized once, the test overwrites `stored.rules` on disk with a new broken entry; a second repair initialization must then leave the on-disk index empty."
    }
  ],
  "unfairTestCount": 2,
  "verdict": "FAIL"
}
Close