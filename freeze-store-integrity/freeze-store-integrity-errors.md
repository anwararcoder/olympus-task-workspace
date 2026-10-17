# 01 :: Solution Quality
Verdict

PASS
Summary

The repair behavior is broadly complete and maintainable, with one medium-severity edge case where directory aliases are misclassified as shared files.

Scores


Solution Comprehensiveness
2/3 — Partially Met
The implementation covers the principal described paths: it defaults to ignore, reloads the index before repair, identifies broken and resolved entries, preserves entries classified as shared, handles line-break-only contents, and removes a known rule on an empty save while retaining a shared file. However, shared-file detection also treats any two existing filesystem objects as sharing a file: `reachesAFile` accepts directories and `Files.isSameFile` then groups a directory with a symlink alias to it. Such entries are broken under the stated regular-file requirement, but the early SHARED classification leaves them in the index. This is a concrete, limited gap in the repair contract.


Code Quality
3/3 — Fully Met
The production changes are focused on the violation store, use Java NIO for path and file-identity checks, serialize index operations through the existing per-path cache, and document the new setting in both the AsciiDoc source and generated HTML. No configured-gate violation or unrelated production churn is apparent from the patch. The directory-alias classification is a correctness issue rather than a broader maintainability problem.

Issues

medium
Comprehensiveness
Distinct directory aliases are incorrectly treated as shared files

In `sharedNames`, `reachesAFile` uses `Files.exists`, which is true for directories, and `namesDenotingOneFileTwice` then groups a directory and a symlink to it via `Files.isSameFile`. Since `findingFor` returns SHARED before checking whether the entry denotes a regular file, repair leaves both entries in place. Restrict identity-based sharing to regular-file targets (while continuing to preserve duplicate recorded names), so entries pointing to non-regular paths are discarded as broken.

Evidence: The description says, “If an entry points to a path that is not a regular file directly within the folder, it is broken.” It separately defines sharing in terms of entries pointing to “the same file”; a directory and its alias are not regular files.

Feedback

The patch implements the described repair lifecycle thoroughly, including the less obvious requirements around absent duplicate names, symlink and hard-link identity, line-break-only files, and empty saves. The synchronization and reload behavior also address stale in-process index state without changing the public `ViolationStore` API.

One bounded edge case prevents a fully complete assessment: repair can preserve entries whose names reach the same directory through distinct paths, even though those entries point to non-regular paths and therefore meet the description’s broken-entry definition. Restricting shared-file identity checks to regular-file targets would resolve this gap. The rest of the change is focused and maintainable.

Completed in 318.9s

Hide raw output
{
  "completed": true,
  "evaluation": {
    "code_quality": {
      "level": "Fully Met",
      "max_score": 3,
      "reasoning": "The production changes are focused on the violation store, use Java NIO for path and file-identity checks, serialize index operations through the existing per-path cache, and document the new setting in both the AsciiDoc source and generated HTML. No configured-gate violation or unrelated production churn is apparent from the patch. The directory-alias classification is a correctness issue rather than a broader maintainability problem.",
      "score": 3
    },
    "issues": [
      {
        "criterion": "comprehensiveness",
        "detail": "In `sharedNames`, `reachesAFile` uses `Files.exists`, which is true for directories, and `namesDenotingOneFileTwice` then groups a directory and a symlink to it via `Files.isSameFile`. Since `findingFor` returns SHARED before checking whether the entry denotes a regular file, repair leaves both entries in place. Restrict identity-based sharing to regular-file targets (while continuing to preserve duplicate recorded names), so entries pointing to non-regular paths are discarded as broken.",
        "evidence": "The description says, “If an entry points to a path that is not a regular file directly within the folder, it is broken.” It separately defines sharing in terms of entries pointing to “the same file”; a directory and its alias are not regular files.",
        "severity": "medium",
        "title": "Distinct directory aliases are incorrectly treated as shared files"
      }
    ],
    "overall_feedback": "The patch implements the described repair lifecycle thoroughly, including the less obvious requirements around absent duplicate names, symlink and hard-link identity, line-break-only files, and empty saves. The synchronization and reload behavior also address stale in-process index state without changing the public `ViolationStore` API.\n\nOne bounded edge case prevents a fully complete assessment: repair can preserve entries whose names reach the same directory through distinct paths, even though those entries point to non-regular paths and therefore meet the description’s broken-entry definition. Restricting shared-file identity checks to regular-file targets would resolve this gap. The rest of the change is focused and maintainable.",
    "solution_comprehensiveness": {
      "level": "Partially Met",
      "max_score": 3,
      "reasoning": "The implementation covers the principal described paths: it defaults to ignore, reloads the index before repair, identifies broken and resolved entries, preserves entries classified as shared, handles line-break-only contents, and removes a known rule on an empty save while retaining a shared file. However, shared-file detection also treats any two existing filesystem objects as sharing a file: `reachesAFile` accepts directories and `Files.isSameFile` then groups a directory with a symlink alias to it. Such entries are broken under the stated regular-file requirement, but the early SHARED classification leaves them in the index. This is a concrete, limited gap in the repair contract.",
      "score": 2
    },
    "summary": "The repair behavior is broadly complete and maintainable, with one medium-severity edge case where directory aliases are misclassified as shared files.",
    "verdict": "PASS"
  },
  "executionTimeSeconds": 318.93056,
  "summary": "The repair behavior is broadly complete and maintainable, with one medium-severity edge case where directory aliases are misclassified as shared files.",
  "verdict": "PASS"
}
Close

# 02 :: Test Quality
Verdict

PASS
All 46 tests fair
All 46 added maintenance tests are fair against the prompt and visible repository behavior; unfairTestCount is 0. The patch also adds build wiring and a test runner, but these are harness changes rather than additional behavioral assertions for the store. The main advisory concern is environment dependence in symbolic/hard-link, Unix-rooted-path, and POSIX-permission tests; the permission test also compares a helper-generated exact sentinel string. The suite is broad and covers the prompt's principal rules and their interactions.

Requirement Coverage (15/16 covered)

Advisory only — prompt-stated requirements and whether the hidden tests pin them.

covered
With no integrity setting, integrity checking defaults to ignore.

"Defaulting to `ignore` which checks nothing."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry

covered
Explicit ignore mode does not inspect or mutate the index/folder.

"Defaulting to `ignore` which checks nothing."

ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingSoRepairStillFindsEveryCondition

covered
Repair checks the index and folder during initialization.

"Setting `default.integrity` to `repair` will check the index and folder during initialization."

repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne, anEntryWhoseFileIsAbsentIsBroken, repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder

covered
An entry is broken if its path is not a regular file directly inside the store folder.

"If an entry points to a path that is not a regular file directly within the folder, it is broken."

anEntryWhoseFileIsAbsentIsBroken, anEntryRecordingADirectoryIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched, anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives, anEntryRecordingANestedNameIsBrokenAndThatFileSurvives, anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives, anEntryNamingADanglingLinkIsBroken

partial
A filename that is not a valid path is broken.

"This also applies if the file name is not a valid path."

anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne

covered
A non-broken entry whose file has no violations is resolved.

"If an entry is not broken and its file has no violations it is resolved."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs, aSharedNameHoldingNoViolationsIsNotDiscardedEither

covered
A file containing only line breaks is resolved.

"Files that only contain line breaks are also resolved."

aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks

covered
Entries with the same recorded filename are shared, including when that name does not exist.

"Entries that point to the same file name are shared, even if nothing exists with that name."

aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair

covered
Entries reaching the same file through different names are shared, including via symbolic links, hard links, and outside-folder targets.

"If multiple entries point to the same file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."

twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded, anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled

covered
Shared entries and files, and files no entry points to, are not touched; entries that are shared and also otherwise broken/resolved remain shared.

"The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to. If an entry is shared and anything else it will remain shared."

aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget, aSharedNameHoldingNoViolationsIsNotDiscardedEither, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair, anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded, aFileInsideADirectoryInTheStoreFolderIsNeverACondition

covered
Repair discards broken entries.

"When set to `repair` broken entries will be discarded."

anEntryWhoseFileIsAbsentIsBroken, everyBrokenEntryIsDiscarded, anEntryRecordingADirectoryIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched

covered
Repair discards resolved entries and their referenced files.

"When set to `repair` resolved entries and the file they point to will be discarded."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aSharedNameHoldingNoViolationsIsNotDiscardedEither

covered
For a resolved symbolic-link entry, the target file is also deleted.

"If a resolved entry is a symbolic link the file it points to will be deleted as well."

aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt, forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile

covered
Under repair, saving no violations for a known rule forgets it and removes its entry/file unless another entry shares the file, in which case only the entry is removed, including for an outside-folder target.

"If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."

storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside, forgettingARuleKeepsTheFileAnotherEntryStillRecords, forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile

covered
Under repair, saving no violations for an unknown rule saves nothing.

"If using `repair` and saving no violations for an unknown rule nothing will be saved."

forgettingARuleTheIndexNeverKnewStoresNothingForIt

covered
If the file cannot be deleted while forgetting a rule, saving fails and the entry remains.

"If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."

forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry

Coverage Suggestions (1)

Advisory only — these don't affect the check result.

Invalid stored filenames
single point
Prompt-stated
Requirement: A filename that is not a valid path is broken.

Add a second invalid-path example (or a parameterized set) to discriminate a general invalid-path check from special-casing the NUL-containing name.

Quality Notes (46)

Prompt-stated
absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Direct default-versus-repair check on one absent path; a narrow but discriminating example.

Prompt-stated
ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Useful explicit-setting counterpart to the default-setting test; somewhat redundant.

Prompt-stated
ignoreExaminesNothingSoRepairStillFindsEveryCondition
Strong multi-condition test. The exact regular-file listing does not include directory entries, but the content and index assertions cover the relevant changes.

Prompt-stated
repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne
Clear positive and negative cases, though the healthy store has only one entry.

Prompt-stated
anEntryWhoseFileIsAbsentIsBroken
Direct, useful absent-file case.

Prompt-stated
everyBrokenEntryIsDiscarded
Checks more than one broken entry in the same index; still a small representative set.

Prompt-stated
anEntryRecordingADirectoryIsBroken
Good non-regular-path case; confirms cleanup does not remove the directory.

Prompt-stated
anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched
Direct path-containment and non-destruction check.

Prompt-stated
anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives
The test’s `/` rooted spelling and filesystem behavior assume Unix-like path semantics.

env assumption
Prompt-stated
anEntryRecordingANestedNameIsBrokenAndThatFileSurvives
Useful nested-path case; it checks existence but not the nested file's bytes.

Prompt-stated
anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne
Fair but shallow for the class of invalid path names: only one invalid spelling is tested.

overfit
Standard external semantics
anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken
The path spelling is a useful normalization case. The exact reader-result assertion is grounded in the existing line-reading API.

Prompt-stated
anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives
Depends on symbolic-link creation support on the host filesystem.

env assumption
Prompt-stated
anEntryNamingALinkToAFileInTheStoreOwnsThatFile
Useful symbolic-link resolution case; depends on symbolic-link support.

env assumption
Prompt-stated
aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget
Good unowned-link case; depends on symbolic-link support.

env assumption
Prompt-stated
anEntryNamingADanglingLinkIsBroken
Direct dangling-link case; setup requires symbolic-link support.

env assumption
Prompt-stated
anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry
Distinguishes the index entries from the link object itself; depends on symbolic-link support.

env assumption
Prompt-stated
entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken
Useful check that spelling similarity alone does not make absent entries shared.

Prompt-stated
anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile
Direct empty-file cleanup case.

Prompt-stated
aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt
Strongly discriminates deleting only the link from deleting its target; requires symbolic-link support.

env assumption
Prompt-stated
aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry
Good empty-versus-nonempty boundary test.

Standard external semantics
aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks
Useful cross-line-ending coverage. The three standard terminators make this more than a single newline example.

Prompt-stated
anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs
Clear boundary test; overlaps the empty and nonempty cases elsewhere.

Prompt-stated
aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded
Direct duplicate-name sharing case.

Prompt-stated
twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded
Excellent combination of in-folder/outside symlink sharing. Requires symbolic-link support.

env assumption
Prompt-stated
twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded
Direct hard-link case; depends on hard-link support and filesystem constraints.

env assumption
Prompt-stated
aSharedNameHoldingNoViolationsIsNotDiscardedEither
Good test of the precedence between shared and resolved status.

Prompt-stated
anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair
Direct test of the unusual shared-plus-broken precedence.

Prompt-stated
anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded
Useful ordinary unowned-file case.

Prompt-stated
aFileInsideADirectoryInTheStoreFolderIsNeverACondition
The test appropriately distinguishes an unowned nested file from a nested index target; it does not assert the directory listing itself.

Prompt-stated
aSecondInitializationOfARepairedFolderDiscardsNothing
Useful settling/idempotence check.

Prompt-stated
anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled
Good repeat-repair/shared-link case; depends on symbolic-link support.

env assumption
Prompt-stated
aSeparatelyCreatedStoreObservesTheRepairedIndex
Good durability/integration assertion: it reads through a separate store instance rather than trusting only the repairing instance's state.

Prompt-stated
aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord
Direct check of the resulting index/file correspondence.

Prompt-stated
aRuleWhoseEntryWasDiscardedIsNoLongerFrozen
Useful public-API check of the index removal rather than only inspecting properties.

Repo-discoverable
repairKeepsAStillViolatingRuleFrozenWithItsViolations
Good store/API integration case; the exact returned line is supported by existing read behavior.

Prompt-stated
aRepairedStoreCanFreezeARuleAgain
Useful lifecycle test. The default filename strategy is UUID-based (`TextFileBasedViolationStore.java:87-93`), so the old manually chosen name is not a viable generated name.

Repo-discoverable
aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation
Strong integration test but adds no unusual assertion form beyond the existing first-run contract.

Prompt-stated
storingNoViolationsUnderRepairForgetsTheEntryAndItsFile
Good repair-versus-nonrepair control with both index and API assertions.

Prompt-stated
forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside
Direct combined test of forgetting, sharing, and external-file safety.

Prompt-stated
forgettingARuleKeepsTheFileAnotherEntryStillRecords
Good shared-file save case; the hard assertions inspect both disk state and public API state. Requires symbolic-link support.

env assumption
Prompt-stated
forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile
Strong symlink cleanup and retained-rule assertions; requires symbolic-link support.

env assumption
Prompt-stated
forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry
Behavior is fair, but the exact helper-generated human-readable sentinel is brittle and the setup depends on POSIX permissions (and may require `setpriv`).

brittle message
env assumption
Prompt-stated
forgettingARuleTheIndexNeverKnewStoresNothingForIt
Direct single-case check of the unknown-rule clause.

Prompt-stated
aStillViolatedRuleKeepsItsEntryUnderRepair
Good nonempty-save boundary case.

Prompt-stated
repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder
Useful stale-index/cache integration case; the existing implementation caches properties by canonical path at `TextFileBasedViolationStore.java:79, 121-127`, so this deliberately exercises whether repair observes changed on-disk state.

Task Summary

The task adds an opt-in integrity-repair mode to TextFileBasedViolationStore. With the default/explicit ignore mode, initialization must leave the store alone. With repair, it must inspect stored.rules and referenced paths, discard broken entries and unshared resolved entries/files, preserve shared entries and unowned files, and apply the corresponding cleanup rules when save is called with no violations. A failed deletion during forgetting must fail the save without losing the entry.

Completed in 268.6s

Hide raw output
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Invalid stored filenames",
      "gapKind": "single_point",
      "requirement": "A filename that is not a valid path is broken.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Add a second invalid-path example (or a parameterized set) to discriminate a general invalid-path check from special-casing the NUL-containing name."
    }
  ],
  "error": "",
  "executionTimeSeconds": 268.560674,
  "message": "All hidden tests are fair.",
  "overall": "All 46 added maintenance tests are fair against the prompt and visible repository behavior; unfairTestCount is 0. The patch also adds build wiring and a test runner, but these are harness changes rather than additional behavioral assertions for the store. The main advisory concern is environment dependence in symbolic/hard-link, Unix-rooted-path, and POSIX-permission tests; the permission test also compares a helper-generated exact sentinel string. The suite is broad and covers the prompt's principal rules and their interactions.",
  "requirements": [
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry"
      ],
      "requirement": "With no integrity setting, integrity checking defaults to ignore.",
      "sourceQuote": "Defaulting to `ignore` which checks nothing."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition"
      ],
      "requirement": "Explicit ignore mode does not inspect or mutate the index/folder.",
      "sourceQuote": "Defaulting to `ignore` which checks nothing."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
        "anEntryWhoseFileIsAbsentIsBroken",
        "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder"
      ],
      "requirement": "Repair checks the index and folder during initialization.",
      "sourceQuote": "Setting `default.integrity` to `repair` will check the index and folder during initialization."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
        "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
        "anEntryNamingADanglingLinkIsBroken"
      ],
      "requirement": "An entry is broken if its path is not a regular file directly inside the store folder.",
      "sourceQuote": "If an entry points to a path that is not a regular file directly within the folder, it is broken."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne"
      ],
      "requirement": "A filename that is not a valid path is broken.",
      "sourceQuote": "This also applies if the file name is not a valid path."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither"
      ],
      "requirement": "A non-broken entry whose file has no violations is resolved.",
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
      "requirement": "Entries with the same recorded filename are shared, including when that name does not exist.",
      "sourceQuote": "Entries that point to the same file name are shared, even if nothing exists with that name."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
        "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled"
      ],
      "requirement": "Entries reaching the same file through different names are shared, including via symbolic links, hard links, and outside-folder targets.",
      "sourceQuote": "If multiple entries point to the same file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "aFileInsideADirectoryInTheStoreFolderIsNeverACondition"
      ],
      "requirement": "Shared entries and files, and files no entry points to, are not touched; entries that are shared and also otherwise broken/resolved remain shared.",
      "sourceQuote": "The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to. If an entry is shared and anything else it will remain shared."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "everyBrokenEntryIsDiscarded",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched"
      ],
      "requirement": "Repair discards broken entries.",
      "sourceQuote": "When set to `repair` broken entries will be discarded."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither"
      ],
      "requirement": "Repair discards resolved entries and their referenced files.",
      "sourceQuote": "When set to `repair` resolved entries and the file they point to will be discarded."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
        "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile"
      ],
      "requirement": "For a resolved symbolic-link entry, the target file is also deleted.",
      "sourceQuote": "If a resolved entry is a symbolic link the file it points to will be deleted as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
        "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile"
      ],
      "requirement": "Under repair, saving no violations for a known rule forgets it and removes its entry/file unless another entry shares the file, in which case only the entry is removed, including for an outside-folder target.",
      "sourceQuote": "If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."
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
  "taskSummary": "The task adds an opt-in integrity-repair mode to TextFileBasedViolationStore. With the default/explicit ignore mode, initialization must leave the store alone. With repair, it must inspect stored.rules and referenced paths, discard broken entries and unshared resolved entries/files, preserve shared entries and unowned files, and apply the corresponding cleanup rules when save is called with no violations. A failed deletion during forgetting must fail the save without losing the entry.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The prompt says, “Defaulting to `ignore` which checks nothing,” and that repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Direct default-versus-repair check on one absent path; a narrow but discriminating example.",
      "verifies": "With no default.integrity property, the absent entry remains; after initializing with repair, the entry is gone."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly distinguishes `ignore` (checks nothing) from `repair` (broken entries are discarded).",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Useful explicit-setting counterpart to the default-setting test; somewhat redundant.",
      "verifies": "Explicit ignore retains the absent-path entry; repair subsequently removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt says ignore checks nothing; repair discards broken and resolved entries/files; shared entries/files and files no entry points to are not touched.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Strong multi-condition test. The exact regular-file listing does not include directory entries, but the content and index assertions cover the relevant changes.",
      "verifies": "Ignore preserves the directory's listed regular files and their bytes. Subsequent repair removes the absent and empty-file entries, retains both entries sharing the same nonempty file and the nonempty rule, leaves the unowned file, and preserves the asserted surviving contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair checks the index/folder and discards broken entries; a regular in-folder file with violations is not described as broken or resolved.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Clear positive and negative cases, though the healthy store has only one entry.",
      "verifies": "Repair retains a valid entry and its file in the consistent folder, and removes the entry whose file is absent in the inconsistent folder."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines an entry pointing to a path that is not a regular file in the folder as broken, and says repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "Direct, useful absent-file case.",
      "verifies": "Repair removes the absent-path entry while retaining the entry and file for the present, nonempty file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says broken entries are discarded in repair mode.",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Checks more than one broken entry in the same index; still a small representative set.",
      "verifies": "All three entries to absent paths are removed, while the entry to the present file remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a regular file directly in the folder; a directory is not a regular file, and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "Good non-regular-path case; confirms cleanup does not remove the directory.",
      "verifies": "The directory entry is removed, and the directory itself remains a directory."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires referenced paths to be regular files directly within the folder and says files no entry points to are not touched.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Direct path-containment and non-destruction check.",
      "verifies": "The `../outside.txt` entry is removed, while the outside file still exists with the exact original contents."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt requires a referenced path to be directly within the store folder and says repair discards broken entries; an unreferenced file must not be touched.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "The test’s `/` rooted spelling and filesystem behavior assume Unix-like path semantics.",
      "verifies": "Both the outside absolute-path entry and the entry using the rooted spelling are removed; the outside file and the separately created in-store `rooted-e448f3` file remain, with the asserted contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the file to be directly within the folder, not nested, and says broken entries are discarded.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Useful nested-path case; it checks existence but not the nested file's bytes.",
      "verifies": "The nested-path entry is removed, while the nested file still exists."
    },
    {
      "concerns": [
        "overfit_single_point"
      ],
      "evidence": "The prompt explicitly says an entry is broken if its file name is not a valid path, and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Fair but shallow for the class of invalid path names: only one invalid spelling is tested.",
      "verifies": "The NUL-containing path entry is removed; the healthy entry remains, the regular-file listing contains only the index and healthy file, and the healthy file's contents remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "Java `File`/`Path` relative-path resolution makes `./violations` resolve to the same direct child; the prompt says a valid file directly in the folder is not broken. The exact one-line `getViolations` form is also the existing reader behavior at `TextFileBasedViolationStore.java:193-204`.",
      "fairness": "Standard external semantics",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "The path spelling is a useful normalization case. The exact reader-result assertion is grounded in the existing line-reading API.",
      "verifies": "The `./violations` entry survives repair, the unrelated absent entry is removed, the file's contents are unchanged, and a separately initialized reader returns exactly `['a remaining violation']`."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt requires a regular file directly within the folder and says repair discards broken entries without touching files no entry points to.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Depends on symbolic-link creation support on the host filesystem.",
      "verifies": "The entry naming the in-folder link to an outside target is removed; the outside target's contents remain unchanged."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly recognizes sharing/reaching a file through a symbolic link and says non-resolved entries are retained; the target is a nonempty in-folder file.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Useful symbolic-link resolution case; depends on symbolic-link support.",
      "verifies": "The entry through the in-folder link survives repair, and the target's nonempty contents remain."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt says the store will not touch files that no entry points to; the link and its target are not recorded by any entry.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Good unowned-link case; depends on symbolic-link support.",
      "verifies": "Repair removes the broken index entry, leaves the unrecorded link present, and leaves the outside target's contents unchanged."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt says an entry whose path is not a regular file directly within the folder is broken, and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "Direct dangling-link case; setup requires symbolic-link support.",
      "verifies": "Repair removes the entry whose link target does not exist."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt defines both absent/non-regular paths as broken and directs repair to discard broken entries; it does not direct repair to touch unowned link files.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry",
      "qualityCheck": "Distinguishes the index entries from the link object itself; depends on symbolic-link support.",
      "verifies": "Both the absent-name entry and the dangling-link entry are removed, while the dangling link itself remains a symbolic link."
    },
    {
      "concerns": [],
      "evidence": "The prompt says absent paths are broken; it separately says same-name sharing may apply even when nothing exists, but these entries have different names and do not reach one file.",
      "fairness": "Prompt-stated",
      "name": "entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken",
      "qualityCheck": "Useful check that spelling similarity alone does not make absent entries shared.",
      "verifies": "Both entries, including the `./gone` spelling, are removed because neither resolves to a file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a non-broken file with no violations is resolved and repair discards resolved entries and their files. The persistent index file convention is visible at `TextFileBasedViolationStore.java:71, 115-124`.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Direct empty-file cleanup case.",
      "verifies": "Repair removes the empty-file entry and leaves only `stored.rules` among regular files."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly says a resolved symbolic-link entry causes the pointed-to file to be deleted as well; repair discards resolved entries/files.",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Strongly discriminates deleting only the link from deleting its target; requires symbolic-link support.",
      "verifies": "Repair removes the entry, the target file, and the link, leaving only the index; the former link path is no longer a symbolic link."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says files containing only line breaks are resolved; repair discards resolved entries/files.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Good empty-versus-nonempty boundary test.",
      "verifies": "The file containing only LF characters is removed with its entry; the entry and file containing a violation remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt says line-break-only files are resolved. The specific CR, LF, and CRLF forms are Java's standard line terminators (as also reflected by the repository's CRLF normalization at `FreezingArchRule.java:214-215`).",
      "fairness": "Standard external semantics",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Useful cross-line-ending coverage. The three standard terminators make this more than a single newline example.",
      "verifies": "The CRLF-only, CR-only, and LF-only entries/files are removed; the entry/file containing a violation followed by CRLF is retained."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines resolution by having no violations and says repair discards resolved entries/files.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Clear boundary test; overlaps the empty and nonempty cases elsewhere.",
      "verifies": "The one-violation entry/file remains and the empty-file entry/file is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries with the same file name are shared even if the file is empty, and repair must not touch shared entries/files.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Direct duplicate-name sharing case.",
      "verifies": "Both entries with the identical `shared` name remain despite the file being empty; the unrelated broken entry is removed; the file listing contains only the index and shared file."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly includes sharing through symbolic links and sharing even when the reached file is outside the folder; shared entries/files remain shared and untouched.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Excellent combination of in-folder/outside symlink sharing. Requires symbolic-link support.",
      "verifies": "The in-store target entry and symlink entry both remain and the broken entry is removed; in the second folder, the `../outside.txt` and symlink entries both remain with their exact recorded values, and the link and outside target still exist."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly says multiple entries reaching the same file through a hard link are shared and remain shared.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Direct hard-link case; depends on hard-link support and filesystem constraints.",
      "verifies": "Both entries with the two hard-link names remain with their exact mappings, and both hard-link names plus the index remain in the folder."
    },
    {
      "concerns": [],
      "evidence": "The prompt says shared entries/files are not touched even when otherwise resolved, while unshared resolved entries/files are discarded in repair.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Good test of the precedence between shared and resolved status.",
      "verifies": "Both entries sharing the empty file remain; the unshared resolved entry and its file are removed; only the index and shared file remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-name entries are shared even if nothing exists under that name, and if an entry is shared and anything else it remains shared.",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Direct test of the unusual shared-plus-broken precedence.",
      "verifies": "Both entries with the same absent name remain, the lone broken entry is removed, and no data file is created or removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the store will not touch files that no entry points to and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Useful ordinary unowned-file case.",
      "verifies": "The broken entry is removed; the unowned `notes.txt` remains with its original contents; only the index and notes file remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt limits entry files to regular files directly in the folder and says files no entry points to are not touched.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "The test appropriately distinguishes an unowned nested file from a nested index target; it does not assert the directory listing itself.",
      "verifies": "The valid entry remains, the broken entry is removed, the top-level regular-file listing has only the index and kept file, and the nested unowned file retains its contents."
    },
    {
      "concerns": [],
      "evidence": "Repair discards broken entries/files; after the first repair the only indexed entry points to a nonempty regular file, so the stated cleanup conditions no longer apply. The index persistence convention is at `TextFileBasedViolationStore.java:71, 115-124`.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Useful settling/idempotence check.",
      "verifies": "After a second repair, the surviving entry and regular-file listing equal the post-first-repair state, with only the index and kept file listed."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt says entries reaching the same file through a symbolic link are shared and remain shared; repair discards only broken/resolved unshared entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Good repeat-repair/shared-link case; depends on symbolic-link support.",
      "verifies": "Both the link-name and target-name entries remain equal to the post-first-repair index after a second repair; the entry keys and target contents are preserved."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards the broken entry; persistence through the existing `stored.rules` index is the repository's store design (`TextFileBasedViolationStore.java:46-51, 115-124`).",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Good durability/integration assertion: it reads through a separate store instance rather than trusting only the repairing instance's state.",
      "verifies": "After repair, a newly initialized store reports `contains(broken rule) == false` and `contains(kept rule) == true`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says resolved/broken files are discarded and unowned files are untouched; the index-to-file layout is documented at `TextFileBasedViolationStore.java:46-51`.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Direct check of the resulting index/file correspondence.",
      "verifies": "The regular-file listing is exactly `stored.rules` and the kept file, and the surviving rule maps to the exact kept filename."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards resolved entries and says saving/forgetting removes a rule; the direct boolean `contains` contract is documented in `ViolationStore.java:47-50`.",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Useful public-API check of the index removal rather than only inspecting properties.",
      "verifies": "A separately initialized reader returns `false` for `contains(resolvedRule)` after repair."
    },
    {
      "concerns": [],
      "evidence": "The existing `ViolationStore` API defines `contains` and `getViolations` at `ViolationStore.java:47-68`; `TextFileBasedViolationStore.java:193-204` reads stored contents as violation lines. The prompt's repair rules retain non-resolved entries and discard the broken neighbor.",
      "fairness": "Repo-discoverable",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Good store/API integration case; the exact returned line is supported by existing read behavior.",
      "verifies": "The reader reports the violating rule present, returns exactly the one stored violation, and the index contains only that rule after the neighboring broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "Repair discards the resolved entry/file; the prompt says an unknown rule with no violations is not saved, while a later save with a violation should store it under the repository's existing `ViolationStore.save` behavior (`TextFileBasedViolationStore.java:149-163`).",
      "fairness": "Prompt-stated",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Useful lifecycle test. The default filename strategy is UUID-based (`TextFileBasedViolationStore.java:87-93`), so the old manually chosen name is not a viable generated name.",
      "verifies": "After repair, saving a new violation makes the rule present with exactly that violation, leaves only that rule in the index, and the regular-file listing does not contain the old `resolved` filename."
    },
    {
      "concerns": [],
      "evidence": "The repository documents that the first FreezingArchRule run always passes at `FreezingArchRule.java:40-42`; evaluation saves when the rule is not already in the store at `FreezingArchRule.java:119-139`. The prompt requires repair to discard the resolved entry/file.",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Strong integration test but adds no unusual assertion form beyond the existing first-run contract.",
      "verifies": "After repair removes the resolved entry, an actual FreezingArchRule evaluation returns a result with `hasViolation() == false`; a reader then sees the rule present and the old `resolved` filename absent."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires repair to forget known rules saved with no violations and says the entry/file are removed. The ignore-mode contrast is consistent with “ignore” checking nothing; existing save/read behavior is at `TextFileBasedViolationStore.java:149-163, 193-204`.",
      "fairness": "Prompt-stated",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "Good repair-versus-nonrepair control with both index and API assertions.",
      "verifies": "Under repair, saving an empty list for the known rule leaves no entries and only the index file; under ignore, the same known rule's entry remains and its reader returns an empty violation list."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a shared entry stays shared and that when forgetting a shared file only the entry being forgotten is removed, even when it points outside the folder.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Direct combined test of forgetting, sharing, and external-file safety.",
      "verifies": "The forgotten rule's entry is removed but the shared peer's `../outside.txt` mapping remains; the outside file still exists and retains its exact contents."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt says that when another entry shares the file, only the forgotten entry is removed. Existing `getViolations` line-reading behavior is at `TextFileBasedViolationStore.java:193-204`.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Good shared-file save case; the hard assertions inspect both disk state and public API state. Requires symbolic-link support.",
      "verifies": "After saving no violations for the forgotten rule, only the keeping rule remains; the target and link names remain, the target contents remain, and the keeping rule still returns its exact violation line."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly says a resolved/forgotten symbolic-link entry deletes the file it points to as well; the other rule's nonempty file remains. The reader form is existing behavior at `TextFileBasedViolationStore.java:193-204`.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
      "qualityCheck": "Strong symlink cleanup and retained-rule assertions; requires symbolic-link support.",
      "verifies": "The forgotten entry is absent; only the index and unrelated kept file remain; the link path is no longer a symbolic link; the forgotten rule is absent and the kept rule returns exactly its violation."
    },
    {
      "concerns": [
        "brittle_message_matching",
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly says an undeletable file makes forgetting fail to save and leaves the entry. The test helper's sentinel is constructed from the caught failure and the still-readable violations; the subsequent assertions independently check the disk state.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "Behavior is fair, but the exact helper-generated human-readable sentinel is brittle and the setup depends on POSIX permissions (and may require `setpriv`).",
      "verifies": "The helper returns exactly `rejected, still stored with [one violation]`; the on-disk index mapping and file contents remain; after permissions are restored, a subsequent empty save removes the entry and leaves only the index."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says that under repair, saving no violations for an unknown rule saves nothing.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct single-case check of the unknown-rule clause.",
      "verifies": "Saving no violations under repair for an unknown rule leaves the properties index empty and the regular-file listing containing only `stored.rules`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says only rules with no violations are forgotten; a still-violating rule is not resolved. The exact returned line follows the existing reader at `TextFileBasedViolationStore.java:193-204`.",
      "fairness": "Prompt-stated",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Good nonempty-save boundary case.",
      "verifies": "After saving one of two existing violations, only the rule's entry remains and `getViolations` returns exactly the retained violation."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair checks the index and folder during initialization. The assertion tests the current on-disk index on that initialization, rather than merely the earlier contents.",
      "fairness": "Prompt-stated",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "Useful stale-index/cache integration case; the existing implementation caches properties by canonical path at `TextFileBasedViolationStore.java:79, 121-127`, so this deliberately exercises whether repair observes changed on-disk state.",
      "verifies": "After an ignore initialization, the test rewrites the on-disk index to contain an absent path; a subsequent repair initialization removes that entry, leaving the index empty."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
Close