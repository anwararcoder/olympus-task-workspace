# Test Quality
Verdict

FAIL
3 of 54 unfair
Verdict: most assertions are fair and closely track explicit requirements, but three logically distinct expectations are not fairly pinned: rejecting an absolute path that resolves to a regular file directly inside the store; treating bare CR characters as line breaks despite the repository's visible LF/CRLF parsing convention; and requiring a dangling symlink object to remain after discarding its broken index entries. These should be clarified in the prompt or removed. The broken-entry-forgetting test is fair as a filesystem-preservation check but does not actually exercise forgetting a known broken entry because repair initialization removes those entries first. Shared environmental caveat: several tests create symbolic and hard links without checking filesystem support, so their execution assumes a filesystem/OS permitting those operations. The non-deletable-file test additionally assumes POSIX permissions and, on its subprocess path, `setpriv`; the latter availability is guarded but POSIX support is not. No exact human-readable error messages or output formatting are pinned.

Unfair Tests

Not fair
anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives — absolute path resolving inside the store
Verifies: The test requires `rooted rule`, whose absolute path resolves to the regular file `rooted-e448f3` directly inside the store, to be removed from the index, while that file remains.

Evidence: The prompt says the path is judged by the file it finally leads to and only calls paths broken when they do not lead to a regular file directly within the folder. This constructed absolute path does lead to such a file. Refutation search: searched the description and repository for `absolute path`, `rooted`, `relative path`, `directly within`, `../`, `isAbsolute`, and canonical-path handling; no repository convention rejects an absolute path solely because its spelling is absolute. A solution that resolves the final file and accepts an in-folder file is a concrete competing reading supported by the prompt.

Quality: The test combines a fair outside-absolute case with an unsupported rule that all absolute spellings are broken, even when the resolved file is directly inside the store.

Not fair
anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry — dangling link remains
Verifies: After both index entries are removed, the test requires `alias` itself still to be a symbolic link.

Evidence: The prompt says broken entries are discarded without touching whatever they point to, but does not specify whether the dangling symlink object (as distinct from its absent target) must be retained. Refutation search: searched description/repository for `dangling`, `symbolic link`, `broken entries`, `without touching`, `isSymbolicLink`, and deletion APIs; no integrity-maintenance convention specifies this. Removing the dangling link while retaining its absent target (there is none) is a concrete alternative consistent with the stated protection.

Quality: Pins cleanup of a filesystem object separately from the prompt's index-entry removal and target-protection requirement.

Not fair
aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks — bare CR
Verifies: The assertion also requires a file containing only `\r\r` to count as line breaks and its entry/file to be discarded.

Evidence: The prompt says “line breaks” but does not specify bare carriage return as a line terminator. Refutation search: searched description and repository for `carriage return`, `\\r`, `CRLF`, `line break`, `String.lines`, and `readLine`; the relevant repository parser splits on LF at `TextFileBasedViolationStore.java:68,200`, after only CRLF-to-LF conversion at `FreezingArchRule.java:214-215`. That supplies a grounded competing implementation in which bare CR is content, not a separator.

Quality: A lone-CR convention is not singled out by the prompt and differs from the visible store's existing line parsing.

Requirement Coverage (10/14 covered)

Advisory only — prompt-stated requirements and whether the hidden tests pin them.

covered
With no integrity setting, the default behavior is ignore and performs no integrity checks or changes.

"Defaulting to `ignore` which checks nothing."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingSoRepairStillFindsEveryCondition

covered
Repair checks the on-disk index and folder at initialization, including when that folder was initialized earlier.

"Setting `default.integrity` to `repair` will check the index and folder as they are on disk during initialization, even if the same folder was initialized before."

repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder, aSecondInitializationOfARepairedFolderDiscardsNothing

partial
An entry is broken when its final path does not resolve to a regular file directly within the folder, including invalid paths and outside-pointing symbolic links.

"If an entry points to a path that is not a regular file directly within the folder, it is broken. This also applies if the file name is not a valid path. The path is judged by the file it finally leads to, so a symbolic link to a file outside the folder is broken."

partial
Entries whose files have no violations are resolved, and files containing only line breaks are also resolved.

"If an entry is not broken and its file has no violations it is resolved. Files that only contain line breaks are also resolved."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt, aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks — CRLF and LF, anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs

covered
Entries recording the same file name are shared even if no file exists.

"Entries that point to the same file name are shared, even if nothing exists with that name."

aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair

covered
Entries reaching one regular file by distinct names are shared through symbolic or hard links, including when the file is outside the folder.

"If multiple entries point to the same regular file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."

twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded, twoEntriesReachingAFileOutsideTheFolderThroughAHardLinkShareItAndNeitherIsDiscarded

covered
Repair does not touch shared entries/files or files no entry points to; a shared entry remains shared even when it has another condition.

"When set to `repair` the check will not touch any shared entries or files that no entry points to, and saving violations for a shared entry will not change its file. If an entry is shared and anything else it will remain shared."

ignoreExaminesNothingSoRepairStillFindsEveryCondition, aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, aSharedNameHoldingNoViolationsIsNotDiscardedEither, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair, anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded, aFileInsideADirectoryInTheStoreFolderIsNeverACondition, savingViolationsUnderRepairLeavesAFileAnotherEntrySharesUntouched

partial
Repair discards broken entries without touching their targets.

"When set to `repair` broken entries will be discarded without touching whatever they point to."

anEntryRecordingADirectoryIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched, anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives — external target, anEntryRecordingANestedNameIsBrokenAndThatFileSurvives, anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives, aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget, forgettingARuleWhoseEntryIsBrokenTouchesNothingItPointsTo

covered
Repair discards resolved entries and their files, including the target file of a resolved symbolic link.

"When set to `repair` resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt, aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry

covered
Saving no violations for a known rule under repair forgets the rule and removes its entry and file.

"If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well."

storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile, forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry

covered
When another entry shares the file being forgotten, remove only the forgotten entry, including for files outside the folder.

"Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."

forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside, forgettingARuleKeepsTheFileAnotherEntryStillRecords, forgettingARuleKeepsTheFileAnotherEntryReachesThroughAHardLink

untested
Forgetting must not touch whatever a broken entry points to.

"Forgetting never touches whatever a broken entry points to."

covered
Saving no violations for an unknown rule under repair saves nothing.

"If using `repair` and saving no violations for an unknown rule nothing will be saved."

forgettingARuleTheIndexNeverKnewStoresNothingForIt

covered
If the file cannot be deleted while forgetting a rule, the save fails and the entry remains.

"If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."

forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry

Coverage Suggestions (3)

Advisory only — these don't affect the check result.

Final-path classification
single point
Prompt-stated
Requirement: An entry is broken when its final path does not resolve to a regular file directly within the folder, including outside-pointing symbolic links.

Add a symlink-chain case (for example, an in-folder link to another link that ultimately reaches an outside file) to distinguish checking only the first link from judging the final target.

Bare carriage-return line endings
single point
needs prompt edit
Requirement: Entries whose files have no violations are resolved, and files containing only line breaks are also resolved.

If lone CR is intended to count as a line break, explicitly state that in the problem description and then test it; the present wording and repository parser leave this case open.

Forgetting a broken entry
not discriminating
Prompt-stated
Requirement: Forgetting must not touch whatever a broken entry points to.

Change a path from valid to broken after repair initialization but before saving an empty violation list, then assert that forgetting does not delete the newly reached target. The existing test initializes with all these entries already broken, so repair removes them before the save calls.

Quality Notes (51)

Prompt-stated
absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Direct default-versus-repair contrast; it checks the index result, not byte-for-byte preservation.

Prompt-stated
ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Redundant with the absent-setting test for the same broken-entry case, but independently pins explicit `ignore`.

Prompt-stated
ignoreExaminesNothingSoRepairStillFindsEveryCondition
Broad co-assertions cover index membership, file inventory, and file contents. It is a representative, not exhaustive, set of conditions.

Prompt-stated
repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne
Useful positive and negative cases; does not assert byte-level non-mutation of the consistent index.

Prompt-stated
anEntryWhoseFileIsAbsentIsBroken
Clear absent-versus-present contrast.

Prompt-stated
everyBrokenEntryIsDiscarded
Adds multiplicity but is a narrow extension of the absent-entry test.

Prompt-stated
anEntryRecordingADirectoryIsBroken
Good non-regular-file case.

Prompt-stated
anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched
Directly checks both index cleanup and target preservation.

Prompt-stated
anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives — external target
This part of the test is supported. The same test also asserts that an absolute path resolving to a file inside the store is broken; that distinct expectation is reviewed separately below.

Prompt-stated
anEntryRecordingANestedNameIsBrokenAndThatFileSurvives
Clear nested-path example.

Prompt-stated
anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne
Tests several concrete invalid-name forms alongside a healthy entry.

Prompt-stated
anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken
Useful alternate-spelling and public-reader check.

Prompt-stated
anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives
Direct test of the explicitly named symlink case.

Prompt-stated
anEntryNamingALinkToAFileInTheStoreOwnsThatFile
Good in-folder symlink counterpart to the outside-link case.

Prompt-stated
aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget
Checks both the unowned link and its target.

Prompt-stated
anEntryNamingADanglingLinkIsBroken
A concise dangling-link classification case.

Prompt-stated
anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry — entries removed
The index-removal expectation is fair. The test's additional requirement that the dangling symlink object itself remain is split out below.

Prompt-stated
entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken
Important distinction between sharing by identical recorded name and two spellings of a missing path.

Prompt-stated
entriesRecordingTwoSpellingsOfADirectoryAreBothBroken
Adds alternate spellings and a directory symlink to the non-regular-file case.

Prompt-stated
anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile
Basic resolved-file case.

Prompt-stated
aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt
Checks target and link cleanup, including an explicit symlink assertion.

Prompt-stated
aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry
Representative LF-only resolved-file case.

Prompt-stated
aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks — CRLF and LF
The CRLF/LF portion is directly supported; the separate bare-CR expectation is reviewed below.

Prompt-stated
anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs
Clear positive/negative contrast.

Prompt-stated
aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded
Useful checks that sharing takes precedence even for an empty file.

Prompt-stated
twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded
Broad co-assertions for in-folder and outside symlink sharing. The helper suppresses save exceptions in this test, but no save is attempted here.

Prompt-stated
twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded
Direct hard-link sharing case.

Prompt-stated
twoEntriesReachingAFileOutsideTheFolderThroughAHardLinkShareItAndNeitherIsDiscarded
Direct outside-hard-link sharing case.

Prompt-stated
aSharedNameHoldingNoViolationsIsNotDiscardedEither
Good shared-versus-unshared resolved contrast.

Prompt-stated
anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair
Directly discriminates precedence of sharing over broken status.

Prompt-stated
anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded
Simple unowned-file preservation case.

Prompt-stated
aFileInsideADirectoryInTheStoreFolderIsNeverACondition
Checks nested unowned content as well as an unrelated broken entry.

Prompt-stated
aSecondInitializationOfARepairedFolderDiscardsNothing
Useful idempotence check; snapshot makes the accepted result concrete.

Prompt-stated
anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled
Good alias/idempotence regression case.

Repo-discoverable
aSeparatelyCreatedStoreObservesTheRepairedIndex
Checks integration between on-disk repair and another store instance, not just the local assertion helper.

Prompt-stated
aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord
Useful combined inventory/index consistency assertion.

Prompt-stated
aRuleWhoseEntryWasDiscardedIsNoLongerFrozen
Checks repaired index through the public store API.

Prompt-stated
repairKeepsAStillViolatingRuleFrozenWithItsViolations
Checks index state and retrieved contents, not just file existence.

Repo-discoverable
aRepairedStoreCanFreezeARuleAgain
The no-reuse filename check is predictable from the repository's default UUID naming strategy, though the main behavior is simply successful subsequent saving.

Repo-discoverable
aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation
Integration-level test; its first-run expectation is supported by the user guide, not solely by the task's maintenance description.

Prompt-stated
storingNoViolationsUnderRepairForgetsTheEntryAndItsFile
The ignore comparison is useful; the empty return value is a baseline store behavior.

Prompt-stated
forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside
Strong test of shared external target preservation.

Prompt-stated
forgettingARuleWhoseEntryIsBrokenTouchesNothingItPointsTo
The filesystem-preservation assertions are fair, but this is not discriminating for the named save/forget behavior: `initialize(repair)` has already discarded every broken entry before the subsequent `save` calls, and `saveUnlessRejected` suppresses their exceptions. A solution that never handles forgetting a still-known broken entry can pass.

Prompt-stated
forgettingARuleKeepsTheFileAnotherEntryStillRecords
Good real save/forget case with a symbolic-link alias.

Prompt-stated
forgettingARuleKeepsTheFileAnotherEntryReachesThroughAHardLink
Useful hard-link counterpart to the symlink case.

Prompt-stated
forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile
Checks deletion and that an unrelated rule remains readable.

Prompt-stated
forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry
The POSIX permission setup and fixed `setpriv` UID make this environment-sensitive; the helper guards `setpriv` availability but applies POSIX permissions unconditionally.

env assumption
Prompt-stated
forgettingARuleTheIndexNeverKnewStoresNothingForIt
Direct unknown-rule case.

Prompt-stated
aStillViolatedRuleKeepsItsEntryUnderRepair
Checks ordinary non-empty update behavior alongside repair.

Prompt-stated
savingViolationsUnderRepairLeavesAFileAnotherEntrySharesUntouched
Good three-mechanism assertion. Save exceptions are swallowed, so it verifies the promised non-mutation but not that each save succeeds.

Prompt-stated
repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder
Directly targets stale in-memory state and the stated repeat-initialization edge case.

Task Summary

The benchmark asks the agent to add integrity maintenance to TextFileBasedViolationStore: `ignore` (including the default) must leave the store alone, while `repair` inspects the current index and folder at initialization, removes broken and resolved entries according to the prompt, preserves shared and unowned files, and applies the same sharing/deletion rules when saving no violations. The new test class exercises path validity (including links), empty versus violating files, sharing by name or file identity, repeat initialization, save/forget behavior, deletion failure, and FreezingArchRule integration. The patch also adds Gradle targets and a shell harness to compile and run the new suite and existing baseline suites; those are harness changes, not additional behavioral assertions reviewed here.

Completed in 304.8s

Hide raw output
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Final-path classification",
      "gapKind": "single_point",
      "requirement": "An entry is broken when its final path does not resolve to a regular file directly within the folder, including outside-pointing symbolic links.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Add a symlink-chain case (for example, an in-folder link to another link that ultimately reaches an outside file) to distinguish checking only the first link from judging the final target."
    },
    {
      "area": "Bare carriage-return line endings",
      "gapKind": "single_point",
      "requirement": "Entries whose files have no violations are resolved, and files containing only line breaks are also resolved.",
      "sourceIfAdded": "Would need prompt edit",
      "suggestion": "If lone CR is intended to count as a line break, explicitly state that in the problem description and then test it; the present wording and repository parser leave this case open."
    },
    {
      "area": "Forgetting a broken entry",
      "gapKind": "not_discriminating",
      "requirement": "Forgetting must not touch whatever a broken entry points to.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Change a path from valid to broken after repair initialization but before saving an empty violation list, then assert that forgetting does not delete the newly reached target. The existing test initializes with all these entries already broken, so repair removes them before the save calls."
    }
  ],
  "error": "",
  "executionTimeSeconds": 304.809034,
  "message": "3 tests flagged as not fair.",
  "overall": "Verdict: most assertions are fair and closely track explicit requirements, but three logically distinct expectations are not fairly pinned: rejecting an absolute path that resolves to a regular file directly inside the store; treating bare CR characters as line breaks despite the repository's visible LF/CRLF parsing convention; and requiring a dangling symlink object to remain after discarding its broken index entries. These should be clarified in the prompt or removed. The broken-entry-forgetting test is fair as a filesystem-preservation check but does not actually exercise forgetting a known broken entry because repair initialization removes those entries first. Shared environmental caveat: several tests create symbolic and hard links without checking filesystem support, so their execution assumes a filesystem/OS permitting those operations. The non-deletable-file test additionally assumes POSIX permissions and, on its subprocess path, `setpriv`; the latter availability is guarded but POSIX support is not. No exact human-readable error messages or output formatting are pinned.",
  "requirements": [
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition"
      ],
      "requirement": "With no integrity setting, the default behavior is ignore and performs no integrity checks or changes.",
      "sourceQuote": "Defaulting to `ignore` which checks nothing."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
        "aSecondInitializationOfARepairedFolderDiscardsNothing"
      ],
      "requirement": "Repair checks the on-disk index and folder at initialization, including when that folder was initialized earlier.",
      "sourceQuote": "Setting `default.integrity` to `repair` will check the index and folder as they are on disk during initialization, even if the same folder was initialized before."
    },
    {
      "covered": "partial",
      "coveringTests": [],
      "requirement": "An entry is broken when its final path does not resolve to a regular file directly within the folder, including invalid paths and outside-pointing symbolic links.",
      "sourceQuote": "If an entry points to a path that is not a regular file directly within the folder, it is broken. This also applies if the file name is not a valid path. The path is judged by the file it finally leads to, so a symbolic link to a file outside the folder is broken."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks — CRLF and LF",
        "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs"
      ],
      "requirement": "Entries whose files have no violations are resolved, and files containing only line breaks are also resolved.",
      "sourceQuote": "If an entry is not broken and its file has no violations it is resolved. Files that only contain line breaks are also resolved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair"
      ],
      "requirement": "Entries recording the same file name are shared even if no file exists.",
      "sourceQuote": "Entries that point to the same file name are shared, even if nothing exists with that name."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
        "twoEntriesReachingAFileOutsideTheFolderThroughAHardLinkShareItAndNeitherIsDiscarded"
      ],
      "requirement": "Entries reaching one regular file by distinct names are shared through symbolic or hard links, including when the file is outside the folder.",
      "sourceQuote": "If multiple entries point to the same regular file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
        "savingViolationsUnderRepairLeavesAFileAnotherEntrySharesUntouched"
      ],
      "requirement": "Repair does not touch shared entries/files or files no entry points to; a shared entry remains shared even when it has another condition.",
      "sourceQuote": "When set to `repair` the check will not touch any shared entries or files that no entry points to, and saving violations for a shared entry will not change its file. If an entry is shared and anything else it will remain shared."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives — external target",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
        "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
        "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
        "forgettingARuleWhoseEntryIsBrokenTouchesNothingItPointsTo"
      ],
      "requirement": "Repair discards broken entries without touching their targets.",
      "sourceQuote": "When set to `repair` broken entries will be discarded without touching whatever they point to."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry"
      ],
      "requirement": "Repair discards resolved entries and their files, including the target file of a resolved symbolic link.",
      "sourceQuote": "When set to `repair` resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry"
      ],
      "requirement": "Saving no violations for a known rule under repair forgets the rule and removes its entry and file.",
      "sourceQuote": "If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
        "forgettingARuleKeepsTheFileAnotherEntryReachesThroughAHardLink"
      ],
      "requirement": "When another entry shares the file being forgotten, remove only the forgotten entry, including for files outside the folder.",
      "sourceQuote": "Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."
    },
    {
      "covered": "no",
      "coveringTests": [],
      "requirement": "Forgetting must not touch whatever a broken entry points to.",
      "sourceQuote": "Forgetting never touches whatever a broken entry points to."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleTheIndexNeverKnewStoresNothingForIt"
      ],
      "requirement": "Saving no violations for an unknown rule under repair saves nothing.",
      "sourceQuote": "If using `repair` and saving no violations for an unknown rule nothing will be saved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry"
      ],
      "requirement": "If the file cannot be deleted while forgetting a rule, the save fails and the entry remains.",
      "sourceQuote": "If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."
    }
  ],
  "taskSummary": "The benchmark asks the agent to add integrity maintenance to TextFileBasedViolationStore: `ignore` (including the default) must leave the store alone, while `repair` inspects the current index and folder at initialization, removes broken and resolved entries according to the prompt, preserves shared and unowned files, and applies the same sharing/deletion rules when saving no violations. The new test class exercises path validity (including links), empty versus violating files, sharing by name or file identity, repeat initialization, save/forget behavior, deletion failure, and FreezingArchRule integration. The patch also adds Gradle targets and a shell harness to compile and run the new suite and existing baseline suites; those are harness changes, not additional behavioral assertions reviewed here.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The prompt says, “Defaulting to `ignore` which checks nothing,” and “When set to `repair` broken entries will be discarded.” The indexed `gone` path is broken under the prompt's path rule.",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Direct default-versus-repair contrast; it checks the index result, not byte-for-byte preservation.",
      "verifies": "With no `default.integrity` property, `entries(store)` still contains `a rule`; after initialization with `repair`, the index has no entries."
    },
    {
      "concerns": [],
      "evidence": "The prompt says `ignore` “checks nothing” and `repair` discards broken entries; `gone` has no corresponding file.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Redundant with the absent-setting test for the same broken-entry case, but independently pins explicit `ignore`.",
      "verifies": "Initialization with `ignore` preserves the `a rule` key; initialization with `repair` removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt says `ignore` “checks nothing”; repair discards broken and resolved entries, does not touch shared entries/files or files no entry points to, and retains a file with violations.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Broad co-assertions cover index membership, file inventory, and file contents. It is a representative, not exhaustive, set of conditions.",
      "verifies": "`ignore` preserves the listed filenames and every file's bytes; subsequent `repair` removes the broken and resolved entries, keeps both shared entries and the violating entry, preserves the unowned file and its content, and preserves the violating file's content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair checks the index/folder, broken entries are discarded, and resolved entries/files are discarded. The consistent example has a file containing a violation, so it is neither broken nor resolved.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Useful positive and negative cases; does not assert byte-level non-mutation of the consistent index.",
      "verifies": "A consistent store retains its rule and its two original files; an index entry pointing to `gone` is removed under repair."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry whose path does not lead to a regular file is broken and broken entries are discarded; a file containing a violation is not resolved.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "Clear absent-versus-present contrast.",
      "verifies": "Repair removes `absent rule`, retains `present rule`, and leaves only `stored.rules` and the present violation file in the folder."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a path that does not lead to a regular file is broken and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Adds multiplicity but is a narrow extension of the absent-entry test.",
      "verifies": "Three separate entries to absent paths are all removed; the present rule is not removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a regular file directly within the folder; a directory is not a regular file. It also says broken entries are discarded without touching what they point to.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "Good non-regular-file case.",
      "verifies": "The directory entry is removed from the index, while the directory itself remains a directory."
    },
    {
      "concerns": [],
      "evidence": "The prompt says paths not resolving to a regular file directly within the folder are broken and broken entries are discarded without touching their targets.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Directly checks both index cleanup and target preservation.",
      "verifies": "The `../outside.txt` entry is removed, while the outside file still exists with exactly `precious` content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a path not resolving to a regular file directly within the folder is broken, and repair must not touch what a broken entry points to. The external absolute target is outside the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives — external target",
      "qualityCheck": "This part of the test is supported. The same test also asserts that an absolute path resolving to a file inside the store is broken; that distinct expectation is reviewed separately below.",
      "verifies": "The absolute path to `absolute.txt` outside the store is removed from the index, and that outside file remains with `precious` content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the path is judged by the file it finally leads to and only calls paths broken when they do not lead to a regular file directly within the folder. This constructed absolute path does lead to such a file. Refutation search: searched the description and repository for `absolute path`, `rooted`, `relative path`, `directly within`, `../`, `isAbsolute`, and canonical-path handling; no repository convention rejects an absolute path solely because its spelling is absolute. A solution that resolves the final file and accepts an in-folder file is a concrete competing reading supported by the prompt.",
      "fairness": "Not fair",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives — absolute path resolving inside the store",
      "qualityCheck": "The test combines a fair outside-absolute case with an unsupported rule that all absolute spellings are broken, even when the resolved file is directly inside the store.",
      "verifies": "The test requires `rooted rule`, whose absolute path resolves to the regular file `rooted-e448f3` directly inside the store, to be removed from the index, while that file remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the file to be directly within the folder; the nested file is not. It also says broken entries are discarded without touching what they point to.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Clear nested-path example.",
      "verifies": "The `nested/violations` entry is removed, and the nested file still exists."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says an entry whose file name is not a valid path is broken and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Tests several concrete invalid-name forms alongside a healthy entry.",
      "verifies": "The null-containing, unpaired-surrogate, and long names are all removed; `beta rule` remains, only its file and the index remain, and its content is unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt judges a path by the file it finally leads to; this spelling resolves to a regular file directly in the store. The exact violation-list shape is also shown by the existing reader test at `archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java:77-85`.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "Useful alternate-spelling and public-reader check.",
      "verifies": "The `./violations` entry survives while the missing entry is removed; the violation text remains, and a separately initialized reader returns exactly `a remaining violation`."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says a symbolic link to a file outside the folder is broken and broken entries are discarded without touching their targets.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Direct test of the explicitly named symlink case.",
      "verifies": "The entry naming a symlink to an outside file is removed, and the target content remains `precious`."
    },
    {
      "concerns": [],
      "evidence": "The prompt judges the path by the file it finally leads to. This link leads to a regular file directly in the store, and that file has violations, so the entry is neither broken nor resolved.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Good in-folder symlink counterpart to the outside-link case.",
      "verifies": "The linked rule remains in the index and the in-store target retains its violation content; the broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair does not touch files that no entry points to, and broken-entry cleanup does not touch the target. No index entry records this symlink.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Checks both the unowned link and its target.",
      "verifies": "The broken index entry is removed, the unrecorded symlink still exists, and its outside target retains `precious`."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the final file reached by the path to be a regular file; a dangling link reaches no regular file, so it is broken.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "A concise dangling-link classification case.",
      "verifies": "The entry naming a dangling symlink is removed from the index."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a path to resolve to a regular file and says broken entries are discarded; neither path does so.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry — entries removed",
      "qualityCheck": "The index-removal expectation is fair. The test's additional requirement that the dangling symlink object itself remain is split out below.",
      "verifies": "Both the entry to the absent name and the entry through the dangling alias are removed from the index."
    },
    {
      "concerns": [],
      "evidence": "The prompt says broken entries are discarded without touching whatever they point to, but does not specify whether the dangling symlink object (as distinct from its absent target) must be retained. Refutation search: searched description/repository for `dangling`, `symbolic link`, `broken entries`, `without touching`, `isSymbolicLink`, and deletion APIs; no integrity-maintenance convention specifies this. Removing the dangling link while retaining its absent target (there is none) is a concrete alternative consistent with the stated protection.",
      "fairness": "Not fair",
      "name": "anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry — dangling link remains",
      "qualityCheck": "Pins cleanup of a filesystem object separately from the prompt's index-entry removal and target-protection requirement.",
      "verifies": "After both index entries are removed, the test requires `alias` itself still to be a symbolic link."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-name entries are shared even if no file exists, but these are different names; it separately says paths not leading to a regular file are broken and discarded.",
      "fairness": "Prompt-stated",
      "name": "entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken",
      "qualityCheck": "Important distinction between sharing by identical recorded name and two spellings of a missing path.",
      "verifies": "Both `gone` and `./gone` entries are removed, rather than retained as shared entries."
    },
    {
      "concerns": [],
      "evidence": "The prompt says only a regular file directly within the folder is valid; all these paths lead to a directory, not a regular file, and broken targets are not touched.",
      "fairness": "Prompt-stated",
      "name": "entriesRecordingTwoSpellingsOfADirectoryAreBothBroken",
      "qualityCheck": "Adds alternate spellings and a directory symlink to the non-regular-file case.",
      "verifies": "All three entries to the directory and its alias are removed, while the directory remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a non-broken entry whose file has no violations is resolved, and repair discards resolved entries and their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Basic resolved-file case.",
      "verifies": "The empty-file entry is removed and only the index remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt says resolved entries and their files are discarded and explicitly adds that when a resolved entry is a symbolic link, the file it points to is deleted as well.",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Checks target and link cleanup, including an explicit symlink assertion.",
      "verifies": "Repair removes the entry, the target, and the in-store symlink itself; the only remaining regular file is the index, and the link path is no longer a symlink."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says files that only contain line breaks are resolved; resolved entries/files are discarded, while a file with violations is not resolved.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Representative LF-only resolved-file case.",
      "verifies": "The entry for a file containing three LF characters is removed; the entry and file containing a violation remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt says files containing only line breaks are resolved, and files with violations are not. The repository also normalizes CRLF to LF at `archunit/src/main/java/com/tngtech/archunit/library/freeze/FreezingArchRule.java:214-215`.",
      "fairness": "Prompt-stated",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks — CRLF and LF",
      "qualityCheck": "The CRLF/LF portion is directly supported; the separate bare-CR expectation is reviewed below.",
      "verifies": "The entries with CRLF-only and LF-only contents are removed, the violating CRLF file remains, and only its rule remains in the index."
    },
    {
      "concerns": [],
      "evidence": "The prompt says “line breaks” but does not specify bare carriage return as a line terminator. Refutation search: searched description and repository for `carriage return`, `\\\\r`, `CRLF`, `line break`, `String.lines`, and `readLine`; the relevant repository parser splits on LF at `TextFileBasedViolationStore.java:68,200`, after only CRLF-to-LF conversion at `FreezingArchRule.java:214-215`. That supplies a grounded competing implementation in which bare CR is content, not a separator.",
      "fairness": "Not fair",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks — bare CR",
      "qualityCheck": "A lone-CR convention is not singled out by the prompt and differs from the visible store's existing line parsing.",
      "verifies": "The assertion also requires a file containing only `\\r\\r` to count as line breaks and its entry/file to be discarded."
    },
    {
      "concerns": [],
      "evidence": "The prompt distinguishes files with violations from files with no violations and says the latter are resolved and discarded.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Clear positive/negative contrast.",
      "verifies": "The one-line violation entry/file remains; the empty-file entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says entries with the same file name are shared even if nothing exists under that name, and repair does not touch shared entries/files.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Useful checks that sharing takes precedence even for an empty file.",
      "verifies": "Two entries with exactly the same recorded name remain, including their empty file; the unrelated broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries reaching the same regular file are shared, including through symbolic links, even if that file is outside the folder; shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Broad co-assertions for in-folder and outside symlink sharing. The helper suppresses save exceptions in this test, but no save is attempted here.",
      "verifies": "The in-folder file and its symlink alias entries both remain, as do both path names; in a second folder, a direct outside path and a symlink to the same outside file both remain, with the link and target still present."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly includes hard links among ways multiple entries can reach the same regular file and says shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Direct hard-link sharing case.",
      "verifies": "Both rule-to-name mappings and both hard-link names remain after repair, even though the shared file is empty."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries reaching the same regular file through hard links are shared even when the file is outside the folder.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingAFileOutsideTheFolderThroughAHardLinkShareItAndNeitherIsDiscarded",
      "qualityCheck": "Direct outside-hard-link sharing case.",
      "verifies": "The outside path and in-folder hard-link entries remain with their original values; the in-folder hard link and outside target still exist."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-name entries are shared and repair does not touch shared entries/files, while unshared resolved entries/files are discarded.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Good shared-versus-unshared resolved contrast.",
      "verifies": "Both entries with the same empty-file name remain; the separate unshared empty-file entry and its file are removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says identical recorded names are shared even when nothing exists under the name, and a shared entry remains shared even if it has another condition; lone broken entries are discarded.",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Directly discriminates precedence of sharing over broken status.",
      "verifies": "Both entries for the same absent name remain, while the separately named absent entry is removed; no regular files besides the index remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair does not touch files that no entry points to and discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Simple unowned-file preservation case.",
      "verifies": "The broken entry is removed while the unowned `notes.txt` remains with exactly `written by hand` content."
    },
    {
      "concerns": [],
      "evidence": "The prompt restricts entry paths to regular files directly within the folder and says files no entry points to are not touched.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Checks nested unowned content as well as an unrelated broken entry.",
      "verifies": "The broken index entry is removed, the valid violation entry remains, and the unindexed file in a subdirectory keeps its content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair checks the index/folder during initialization, and a store that is already consistent has no broken or resolved entries to discard.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Useful idempotence check; snapshot makes the accepted result concrete.",
      "verifies": "After the second repair initialization, the surviving rule is still the only index entry and the folder's filename list exactly matches the snapshot after the first repair."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries reaching the same regular file through a symbolic link are shared and repair will not touch shared entries/files.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Good alias/idempotence regression case.",
      "verifies": "Both entries sharing the same in-folder file through a link remain after two repair initializations; the index and file-name snapshots are stable, and file content is unchanged."
    },
    {
      "concerns": [],
      "evidence": "The store's index is `stored.rules` (`TextFileBasedViolationStore.java:71`) and instances use a static per-path `FileSyncedProperties` cache (`:77,118`); `contains` is the public index query (`ViolationStore.java:42-45`). Repair must leave the surviving index observable through that API.",
      "fairness": "Repo-discoverable",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Checks integration between on-disk repair and another store instance, not just the local assertion helper.",
      "verifies": "A separately constructed store initialized on the repaired folder reports `contains(broken rule) == false` and `contains(kept rule) == true`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says broken and resolved entries/files are discarded. In this setup the kept file has violations; the resolved file has none, and the broken entry has no file.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Useful combined inventory/index consistency assertion.",
      "verifies": "After repair, the top-level regular-file list contains only `stored.rules` and the surviving entry's violation file; the index maps the kept rule to that filename."
    },
    {
      "concerns": [],
      "evidence": "The prompt says resolved entries are discarded; `ViolationStore.contains` is the public query for whether a rule is stored (`ViolationStore.java:42-45`).",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Checks repaired index through the public store API.",
      "verifies": "A separately initialized reader reports `contains(resolvedRule) == false` after repair removes the resolved entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a file with violations is not resolved, while the broken neighbor is discarded. The exact returned list follows the existing reader contract/tests at `TextFileBasedViolationStoreTest.java:77-85`.",
      "fairness": "Prompt-stated",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Checks index state and retrieved contents, not just file existence.",
      "verifies": "The reader reports the violating rule as contained, returns exactly `one remaining violation`, and the index contains only that rule after removing the broken neighbor."
    },
    {
      "concerns": [],
      "evidence": "Repair discarding resolved entries/files is prompt-stated. The standard store maps a new rule to a filename and writes the violations (`TextFileBasedViolationStore.java:146-185`); its default naming strategy uses UUIDs (`:87`). The returned list uses the existing store contract/tests (`TextFileBasedViolationStoreTest.java:77-85`).",
      "fairness": "Repo-discoverable",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "The no-reuse filename check is predictable from the repository's default UUID naming strategy, though the main behavior is simply successful subsequent saving.",
      "verifies": "After repair deletes the old resolved entry, saving a new violation makes the rule contained, returns exactly `a new violation`, leaves only that rule in the index, and does not leave a file named `resolved`."
    },
    {
      "concerns": [],
      "evidence": "The first-run behavior is documented: “On the first run all violations of that rule will be stored as the current state. On consecutive runs only new violations will be reported” (`docs/userguide/008_The_Library_API.adoc:455-456`). The store's default UUID filename strategy is at `TextFileBasedViolationStore.java:87`.",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Integration-level test; its first-run expectation is supported by the user guide, not solely by the task's maintenance description.",
      "verifies": "After repair leaves the index empty, a real FreezingArchRule evaluation has `result.hasViolation() == false`; a reader then reports the rule contained, and no file named `resolved` exists."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair plus saving no violations for a known rule forgets it and removes its entry/file. Existing empty-list retrieval is tested at `TextFileBasedViolationStoreTest.java:87-94`.",
      "fairness": "Prompt-stated",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "The ignore comparison is useful; the empty return value is a baseline store behavior.",
      "verifies": "Saving an empty list under repair removes the known rule and its file; the same empty save under default ignore leaves the other store's index key, and its reader returns an empty list."
    },
    {
      "concerns": [],
      "evidence": "The prompt says shared entries remain shared, forgetting a shared file removes only the forgotten entry even if the file is outside the folder, and forgetting does not touch the target of a broken entry.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Strong test of shared external target preservation.",
      "verifies": "Saving no violations removes the forgotten rule's mapping but retains the peer mapping to `../outside.txt`; the outside file remains and its bytes stay exactly `precious`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says broken entries are discarded without touching what they point to.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseEntryIsBrokenTouchesNothingItPointsTo",
      "qualityCheck": "The filesystem-preservation assertions are fair, but this is not discriminating for the named save/forget behavior: `initialize(repair)` has already discarded every broken entry before the subsequent `save` calls, and `saveUnlessRejected` suppresses their exceptions. A solution that never handles forgetting a still-known broken entry can pass.",
      "verifies": "The final index is empty and the outside file, linked target, outside-target symlink, and nested file retain the asserted existence/content/symlink state."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a shared file is not removed when another entry still records it; only the forgotten entry is removed.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Good real save/forget case with a symbolic-link alias.",
      "verifies": "Saving no violations removes only the forgotten entry; the other rule's symlink alias and target remain, target bytes are unchanged, and the writer still reads the keeper's violation."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-file entries are shared through hard links and forgetting removes only the forgotten entry when another entry shares the file.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryReachesThroughAHardLink",
      "qualityCheck": "Useful hard-link counterpart to the symlink case.",
      "verifies": "Saving no violations removes only the forgotten entry; both hard-link names remain, bytes are unchanged, and the keeper's violation is still readable."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a known rule saved with no violations is forgotten and its file removed; for a resolved symlink, it explicitly requires deleting the file the link points to as well.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
      "qualityCheck": "Checks deletion and that an unrelated rule remains readable.",
      "verifies": "Saving no violations removes the forgotten mapping, the target and symlink, and the writer reports the forgotten rule absent while the unrelated rule's violation remains readable."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt says that if the file cannot be deleted while forgetting a rule, saving must fail and leave the entry. The test checks both failure and retained mapping, then the successful retry.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "The POSIX permission setup and fixed `setpriv` UID make this environment-sensitive; the helper guards `setpriv` availability but applies POSIX permissions unconditionally.",
      "verifies": "The probe must report `rejected, still stored`; the index must still map the rule to `violations`; after permissions are restored, the empty save succeeds and only the index remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says that under repair, saving no violations for an unknown rule saves nothing.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct unknown-rule case.",
      "verifies": "Saving no violations for a rule absent from the index leaves the index empty and the folder containing only `stored.rules`."
    },
    {
      "concerns": [],
      "evidence": "The prompt's resolved definition requires a file with violations to remain; the existing store contract returns its saved violation lines (`TextFileBasedViolationStoreTest.java:77-85`).",
      "fairness": "Prompt-stated",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Checks ordinary non-empty update behavior alongside repair.",
      "verifies": "After saving one remaining violation, the rule remains the only index key and `getViolations` returns exactly `first violation`."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says saving violations for a shared entry will not change its file, and identifies same-name, symbolic-link, and hard-link sharing.",
      "fairness": "Prompt-stated",
      "name": "savingViolationsUnderRepairLeavesAFileAnotherEntrySharesUntouched",
      "qualityCheck": "Good three-mechanism assertion. Save exceptions are swallowed, so it verifies the promised non-mutation but not that each save succeeds.",
      "verifies": "After saves to entries shared by same-name, symbolic-link, and hard-link routes, the entire index equals its pre-save snapshot and each shared file's bytes equal its pre-save content."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says repair checks the index/folder as they are on disk during initialization, even if the same folder was initialized before.",
      "fairness": "Prompt-stated",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "Directly targets stale in-memory state and the stated repeat-initialization edge case.",
      "verifies": "After an `ignore` initialization, an external rewrite of `stored.rules`, and a later `repair` initialization, the index is empty rather than retaining the previously cached entry."
    }
  ],
  "unfairTestCount": 3,
  "verdict": "FAIL"
}
Close