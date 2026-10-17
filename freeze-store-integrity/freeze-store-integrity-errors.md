# Test Quality
Verdict

FAIL
8 of 48 unfair
The 48 newly added maintenance tests are mostly directly grounded in the prompt, and the tests around same-name sharing, symbolic/hard links, line-break-only files, re-saving, and fresh-on-disk initialization test unusually specific behavior that the prompt actually states. Eight tests add an unsupported filesystem-object survival assertion: the directory, socket, nested file, external target, or dangling link is referenced by a broken entry, and the prompt only says to discard the entry; it does not explicitly specify whether that referenced object must remain. Those tests are counted Not fair even though their entry-removal assertions are fair. Separately, symlink/hard-link/socket and POSIX-permission setups are platform-dependent; these are advisory environment concerns, not additional unfair tests. The pre-existing baseline test classes registered by the build patch are regression controls, not newly authored maintenance assertions.

Unfair Tests

Not fair
anEntryRecordingADirectoryIsBroken
Verifies: The directory-recording index entry is removed; the test additionally requires the directory itself to remain.

Evidence: The prompt and repo search battery covered “not a regular file directly within the folder,” “broken,” “discarded,” “directory,” and “remain/preserve”; the prompt specifies discarding the broken entry but does not specify preserving the referenced directory. Grepping the freeze-store source for `delete`, `isRegularFile`, `directory`, and preservation behavior found no convention governing this side effect. The entry-removal assertion is prompt-stated; the directory-survival co-assertion is not.

Quality: The broken-entry assertion is fair, but the extra requirement that the referenced directory survive chooses a cleanup policy the prompt leaves open.

Not fair
anEntryRecordingASocketIsBroken
Verifies: Repair removes the socket-recording entry and the test requires the Unix-domain socket object to continue existing and remain neither a regular file nor a directory.

Evidence: Searched the prompt and freeze-store sources for `socket`, `non-regular`, `broken`, `discard`, `preserve`, and `remain`; neither the prompt nor existing code specifies whether a referenced socket is deleted. The entry-discard expectation is stated; socket preservation is not.

Quality: The socket-preservation co-assertion is unspecified. The setup also assumes Unix-domain socket support and the `UnixDomainSocketAddress` API, so this test has an `environment_assumption` concern.

env assumption
Not fair
anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched
Verifies: Repair removes the `../outside.txt` index entry and requires the external file to exist afterward with exactly `precious` as its content.

Evidence: Searched the prompt and store sources for `outside`, `escape`, `broken`, `discard`, `delete`, and `preserve`. The prompt classifies a non-direct path as broken and requires its entry be discarded, but does not say that a referenced external file must survive; the no-touch clause covers files no entry points to, whereas this file is referenced. No existing store code establishes this cleanup side effect.

Quality: The index-entry removal is prompt-stated. The assertion that this referenced external file is unchanged is an extra side-effect requirement with no prompt or repo evidence.

Not fair
anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives
Verifies: Repair removes both absolute-path entries; it additionally requires the external `absolute.txt` contents and the separate in-store `rooted-e448f3` file contents to remain unchanged.

Evidence: Searched the prompt and freeze-store code for `absolute`, `rooted`, `outside`, `broken`, `discard`, `delete`, and `preserve`. The prompt supports classifying the absolute recorded paths as broken and removing those entries, but does not specify the fate of the external file they reference. The separate in-store file is unreferenced by the index's absolute path, but the assertion also pins preservation of the referenced external file, which is not stated.

Quality: The entry-removal expectations are fair. The external-file-survival co-assertion is not specified; the in-store file is unowned and its survival is supported by the no-touch rule.

Not fair
anEntryRecordingANestedNameIsBrokenAndThatFileSurvives
Verifies: Repair removes the nested-path entry and requires the nested file itself to remain.

Evidence: Searched the prompt and store source for `nested`, `directly within`, `broken`, `discard`, `delete`, and `preserve`. The prompt makes a nested path broken and requires discarding its entry, but it does not prescribe whether the referenced nested file is deleted; no repo convention addresses repair cleanup.

Quality: Only the file-survival co-assertion is unsupported; the broken-entry assertion follows the prompt.

Not fair
anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives
Verifies: Repair removes the link-recording entry and the test requires the external target's contents to remain `precious`.

Evidence: Searched the prompt and store sources for `symbolic link`, `outside`, `broken`, `discard`, `delete`, and `preserve`. The prompt establishes that the out-of-folder path is broken, but does not specify whether its referenced external target survives; the no-touch guarantee is only explicit for unpointed files and shared entries/files.

Quality: The broken-entry assertion is prompt-stated. The target-survival assertion adds an unspecified deletion policy. Symbolic-link creation also assumes filesystem support (`environment_assumption`).

env assumption
Not fair
anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry
Verifies: Repair removes both entries and requires the dangling symlink object itself to remain.

Evidence: Searched the prompt and store code for `dangling`, `symbolic link`, `broken`, `discard`, `delete`, and `remain`. The prompt requires discarding broken entries but does not specify whether the referenced dangling link itself is retained; the no-touch clause does not cover a path that an entry points to.

Quality: The two entry removals are prompt-stated; the symlink-survival co-assertion is an unsupported side-effect choice. Symlink setup has an `environment_assumption` concern.

env assumption
Not fair
twoEntriesReachingOneDirectoryByDifferentNamesAreBothBroken
Verifies: Both entries whose paths reach the directory are removed, while the healthy rule remains; the test additionally requires the directory and its symlink alias to remain.

Evidence: Searched prompt and source for `directory`, `symbolic link`, `broken`, `discard`, `delete`, and `remain`. The prompt says the entries are broken and discarded but does not say the referenced directory or link survives. No source convention establishes that side effect.

Quality: The index assertions follow the prompt, but preservation of both referenced non-regular filesystem objects is an extra requirement. Symlink setup has an `environment_assumption` concern.

env assumption
Requirement Coverage (21/22 covered)

Advisory only — prompt-stated requirements and whether the hidden tests pin them.

covered
Repair must inspect the on-disk index and folder during initialization even after an earlier initialization of that folder.

"Setting `default.integrity` to `repair` will check the index and folder as they are on disk during initialization, even if the same folder was initialized before."

repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder

covered
The default integrity mode is ignore and it checks nothing.

"Defaulting to `ignore` which checks nothing."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingSoRepairStillFindsEveryCondition

partial
An entry pointing to a path that is not a regular file directly in the folder is broken.

"If an entry points to a path that is not a regular file directly within the folder, it is broken."

anEntryWhoseFileIsAbsentIsBroken, everyBrokenEntryIsDiscarded, anEntryRecordingADirectoryIsBroken, anEntryRecordingASocketIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched, anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives, anEntryRecordingANestedNameIsBrokenAndThatFileSurvives, anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken, anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives, anEntryNamingALinkToAFileInTheStoreOwnsThatFile, anEntryNamingADanglingLinkIsBroken, anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry, entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken, twoEntriesReachingOneDirectoryByDifferentNamesAreBothBroken

covered
An invalid path in the recorded filename is broken.

"This also applies if the file name is not a valid path."

anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne

covered
An unbroken entry whose file has no violations is resolved.

"If an entry is not broken and its file has no violations it is resolved."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs, aSharedNameHoldingNoViolationsIsNotDiscardedEither

covered
Files containing only line breaks count as resolved.

"Files that only contain line breaks are also resolved."

aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks

covered
Entries with the same recorded filename are shared even when that name does not exist.

"Entries that point to the same file name are shared, even if nothing exists with that name."

aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair, aSharedNameHoldingNoViolationsIsNotDiscardedEither

covered
Entries reaching the same regular file are shared, including through symbolic or hard links and when the file is outside the folder.

"If multiple entries point to the same regular file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."

twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded, anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled, forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside, forgettingARuleKeepsTheFileAnotherEntryStillRecords

covered
Shared entries and files that no entry points to are not touched.

"The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to."

ignoreExaminesNothingSoRepairStillFindsEveryCondition, aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget, aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded, aFileInsideADirectoryInTheStoreFolderIsNeverACondition, forgettingARuleKeepsTheFileAnotherEntryStillRecords

covered
If an entry is shared and has another condition, it remains shared.

"If an entry is shared and anything else it will remain shared."

anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair, aSharedNameHoldingNoViolationsIsNotDiscardedEither, twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, forgettingARuleKeepsTheFileAnotherEntryStillRecords

covered
Repair discards broken entries.

"When set to `repair` broken entries will be discarded."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, everyBrokenEntryIsDiscarded, anEntryWhoseFileIsAbsentIsBroken, anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne

covered
Repair discards resolved entries.

"When set to `repair` resolved entries and the file they point to will be discarded."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks

covered
Repair removes the file of a resolved entry.

"When set to `repair` resolved entries and the file they point to will be discarded."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt

covered
If a resolved entry is a symbolic link, its target is deleted too.

"If a resolved entry is a symbolic link the file it points to will be deleted as well."

aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt

covered
Saving no violations for a known rule in repair mode forgets it.

"If using `repair` and saving no violations for a known rule it will forget the rule."

storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile, forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry

covered
Forgetting a known rule removes its index entry.

"Its entry will be removed and its file as well."

storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside, forgettingARuleKeepsTheFileAnotherEntryStillRecords

covered
Forgetting a known rule removes its file.

"Its entry will be removed and its file as well."

storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile

covered
If the forgotten rule's entry is a symbolic link, the target is deleted too.

"If its entry is a symbolic link the file it points to will be deleted too."

forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile

covered
If another entry shares the file, forgetting removes only the forgotten entry.

"Unless another entry is sharing that file. In which case only the entry will be removed."

forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside, forgettingARuleKeepsTheFileAnotherEntryStillRecords

covered
The shared-file exception applies even if the file is outside the folder.

"Even if it points outside the folder."

forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside

covered
Saving no violations for an unknown rule in repair mode saves nothing.

"If using `repair` and saving no violations for an unknown rule nothing will be saved."

forgettingARuleTheIndexNeverKnewStoresNothingForIt

covered
If the file cannot be deleted while forgetting a rule, save fails and leaves the entry.

"If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."

forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry

Coverage Suggestions (2)

Advisory only — these don't affect the check result.

Initialization after an earlier initialization
single point
Prompt-stated
Requirement: Repair must inspect the on-disk index and folder during initialization even after an earlier initialization of that folder.

Repeat the edit-then-repair scenario by calling `initialize` twice on the same `TextFileBasedViolationStore` instance, in addition to the current separate-instance/static-cache scenario.

Broken non-regular filesystem object kinds
untested
Prompt-stated
Requirement: An entry pointing to a path that is not a regular file directly in the folder is broken.

Consider a FIFO or another available non-regular filesystem object as an additional case; current tests cover absent paths, directories, sockets, and links but not every kind of non-regular object.

Quality Notes (40)

Prompt-stated
absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Directly distinguishes the default from repair using the same on-disk condition.

Prompt-stated
ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Fair, but largely duplicates the omitted-setting test.

Prompt-stated
ignoreExaminesNothingSoRepairStillFindsEveryCondition
Good compound coverage of ignore side effects, repair, shared entries, and unowned files. The byte-for-byte assertion is a strong but relevant reading of “checks nothing.”

Prompt-stated
repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne
Fair representative consistency check; file contents are not compared.

Prompt-stated
anEntryWhoseFileIsAbsentIsBroken
Clear missing-file case.

Prompt-stated
everyBrokenEntryIsDiscarded
Useful multi-entry check against repairing only one broken entry.

Prompt-stated
anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne
Fair no-crash and removal check, but the absent targets mean this test does not isolate invalid-path handling from ordinary missing-file handling.

Prompt-stated
anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken
Tests both normalized-path classification and subsequent readability.

Prompt-stated
anEntryNamingALinkToAFileInTheStoreOwnsThatFile
Fair symlink-to-in-folder case; depends on symlink creation support.

env assumption
Prompt-stated
aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget
Good coverage of the unowned-file rule. Symlink creation requires filesystem support (`environment_assumption`).

env assumption
Prompt-stated
anEntryNamingADanglingLinkIsBroken
Clear dangling-link classification; setup assumes symlink support (`environment_assumption`).

env assumption
Prompt-stated
entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken
Fair, though it substantially overlaps the absent-file tests.

Prompt-stated
anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile
Direct empty-file case.

Prompt-stated
aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt
Covers target deletion and checks that no dangling link remains; symlink setup has an `environment_assumption` concern.

env assumption
Prompt-stated
aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry
Good contrast between line-break-only and violating content.

Prompt-stated
aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks
Useful breadth for line-break forms; the assertion is not an exact output-format pin.

Prompt-stated
anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs
Fair representative contrast.

Prompt-stated
aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded
Tests same-name sharing with an existing empty file as well as an unrelated broken record.

Prompt-stated
twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded
Strong combined case for in-folder aliases and shared external targets. Requires symlink support (`environment_assumption`).

env assumption
Prompt-stated
twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded
Direct hard-link coverage; creating hard links assumes filesystem support (`environment_assumption`).

env assumption
Prompt-stated
aSharedNameHoldingNoViolationsIsNotDiscardedEither
Good interaction test between shared and resolved status.

Prompt-stated
anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair
Direct test of the explicit shared-plus-broken rule.

Prompt-stated
anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded
Clear unowned-file check.

Prompt-stated
aFileInsideADirectoryInTheStoreFolderIsNeverACondition
Good non-recursive/unowned-file case.

Prompt-stated
aSecondInitializationOfARepairedFolderDiscardsNothing
Useful idempotence check, but only a single repaired-folder scenario.

Prompt-stated
anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled
Good interaction of shared paths and repeated repair. Requires symlink support (`environment_assumption`).

env assumption
Prompt-stated
aSeparatelyCreatedStoreObservesTheRepairedIndex
Useful cross-instance integration check.

Prompt-stated
aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord
Fair aggregate assertion; overlaps several smaller repair tests.

Prompt-stated
aRuleWhoseEntryWasDiscardedIsNoLongerFrozen
Good API-level integration check.

Prompt-stated
repairKeepsAStillViolatingRuleFrozenWithItsViolations
Tests retained rule membership and exact stored content.

Prompt-stated
aRepairedStoreCanFreezeARuleAgain
Good re-save integration test; default UUID naming also makes the last filename assertion predictable.

Repo-discoverable
aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation
Useful integration test through the actual freeze evaluation path; the prompt alone would not dictate the `EvaluationResult` return form.

Repo-discoverable
storingNoViolationsUnderRepairForgetsTheEntryAndItsFile
Good mode contrast. The ignore-mode retention assertion relies on the existing API implementation, not a separate explicit prompt sentence.

Prompt-stated
forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside
Direct coverage of the shared-external-file clause.

Prompt-stated
forgettingARuleKeepsTheFileAnotherEntryStillRecords
Good same-file sharing/deletion interaction. Requires symlink support (`environment_assumption`).

env assumption
Prompt-stated
forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile
Good coverage of both the recorded link and its target; requires symlink support (`environment_assumption`).

env assumption
Prompt-stated
forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry
The synthetic exact status string is brittle formatting, but it represents a deterministic helper outcome rather than an API exception message. POSIX permissions and optionally `setpriv` are environment-dependent.

brittle message
env assumption
Prompt-stated
forgettingARuleTheIndexNeverKnewStoresNothingForIt
Direct and appropriately scoped.

Repo-discoverable
aStillViolatedRuleKeepsItsEntryUnderRepair
Fair regression of nonempty-save behavior, though it is adjacent to rather than verbatim in the prompt's repair requirement.

Prompt-stated
repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder
Direct test of the stated stale-cache edge case; uses a new store instance on the second initialization, so same-instance reinitialization remains an advisory gap.

Task Summary

The task asks the file-backed violation store to add an integrity mode. `default.integrity=ignore` (including when omitted) must leave integrity unchecked; `repair` must inspect the index and folder from disk on initialization, classify broken and resolved entries, preserve sharing and unowned files, and remove only the records/files the prompt specifies. A later `save(rule, emptyList())` in repair mode forgets known rules under the stated sharing/deletion rules, does nothing for unknown rules, and fails without removing the entry when its file cannot be deleted. The added maintenance class contains 48 tests. The build patch also adds a baseline task that runs pre-existing store/concurrency/freezing tests; those suites add no new assertions in this patch.

Completed in 319.8s

Hide raw output
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Initialization after an earlier initialization",
      "gapKind": "single_point",
      "requirement": "Repair must inspect the on-disk index and folder during initialization even after an earlier initialization of that folder.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Repeat the edit-then-repair scenario by calling `initialize` twice on the same `TextFileBasedViolationStore` instance, in addition to the current separate-instance/static-cache scenario."
    },
    {
      "area": "Broken non-regular filesystem object kinds",
      "gapKind": "untested",
      "requirement": "An entry pointing to a path that is not a regular file directly in the folder is broken.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Consider a FIFO or another available non-regular filesystem object as an additional case; current tests cover absent paths, directories, sockets, and links but not every kind of non-regular object."
    }
  ],
  "error": "",
  "executionTimeSeconds": 319.834192,
  "message": "8 tests flagged as not fair.",
  "overall": "The 48 newly added maintenance tests are mostly directly grounded in the prompt, and the tests around same-name sharing, symbolic/hard links, line-break-only files, re-saving, and fresh-on-disk initialization test unusually specific behavior that the prompt actually states. Eight tests add an unsupported filesystem-object survival assertion: the directory, socket, nested file, external target, or dangling link is referenced by a broken entry, and the prompt only says to discard the entry; it does not explicitly specify whether that referenced object must remain. Those tests are counted Not fair even though their entry-removal assertions are fair. Separately, symlink/hard-link/socket and POSIX-permission setups are platform-dependent; these are advisory environment concerns, not additional unfair tests. The pre-existing baseline test classes registered by the build patch are regression controls, not newly authored maintenance assertions.",
  "requirements": [
    {
      "covered": "yes",
      "coveringTests": [
        "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder"
      ],
      "requirement": "Repair must inspect the on-disk index and folder during initialization even after an earlier initialization of that folder.",
      "sourceQuote": "Setting `default.integrity` to `repair` will check the index and folder as they are on disk during initialization, even if the same folder was initialized before."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition"
      ],
      "requirement": "The default integrity mode is ignore and it checks nothing.",
      "sourceQuote": "Defaulting to `ignore` which checks nothing."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "everyBrokenEntryIsDiscarded",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryRecordingASocketIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
        "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
        "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
        "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
        "anEntryNamingADanglingLinkIsBroken",
        "anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry",
        "entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken",
        "twoEntriesReachingOneDirectoryByDifferentNamesAreBothBroken"
      ],
      "requirement": "An entry pointing to a path that is not a regular file directly in the folder is broken.",
      "sourceQuote": "If an entry points to a path that is not a regular file directly within the folder, it is broken."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne"
      ],
      "requirement": "An invalid path in the recorded filename is broken.",
      "sourceQuote": "This also applies if the file name is not a valid path."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither"
      ],
      "requirement": "An unbroken entry whose file has no violations is resolved.",
      "sourceQuote": "If an entry is not broken and its file has no violations it is resolved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks"
      ],
      "requirement": "Files containing only line breaks count as resolved.",
      "sourceQuote": "Files that only contain line breaks are also resolved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither"
      ],
      "requirement": "Entries with the same recorded filename are shared even when that name does not exist.",
      "sourceQuote": "Entries that point to the same file name are shared, even if nothing exists with that name."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
        "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords"
      ],
      "requirement": "Entries reaching the same regular file are shared, including through symbolic or hard links and when the file is outside the folder.",
      "sourceQuote": "If multiple entries point to the same regular file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
        "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords"
      ],
      "requirement": "Shared entries and files that no entry points to are not touched.",
      "sourceQuote": "The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords"
      ],
      "requirement": "If an entry is shared and has another condition, it remains shared.",
      "sourceQuote": "If an entry is shared and anything else it will remain shared."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "everyBrokenEntryIsDiscarded",
        "anEntryWhoseFileIsAbsentIsBroken",
        "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne"
      ],
      "requirement": "Repair discards broken entries.",
      "sourceQuote": "When set to `repair` broken entries will be discarded."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks"
      ],
      "requirement": "Repair discards resolved entries.",
      "sourceQuote": "When set to `repair` resolved entries and the file they point to will be discarded."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt"
      ],
      "requirement": "Repair removes the file of a resolved entry.",
      "sourceQuote": "When set to `repair` resolved entries and the file they point to will be discarded."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt"
      ],
      "requirement": "If a resolved entry is a symbolic link, its target is deleted too.",
      "sourceQuote": "If a resolved entry is a symbolic link the file it points to will be deleted as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry"
      ],
      "requirement": "Saving no violations for a known rule in repair mode forgets it.",
      "sourceQuote": "If using `repair` and saving no violations for a known rule it will forget the rule."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords"
      ],
      "requirement": "Forgetting a known rule removes its index entry.",
      "sourceQuote": "Its entry will be removed and its file as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile"
      ],
      "requirement": "Forgetting a known rule removes its file.",
      "sourceQuote": "Its entry will be removed and its file as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile"
      ],
      "requirement": "If the forgotten rule's entry is a symbolic link, the target is deleted too.",
      "sourceQuote": "If its entry is a symbolic link the file it points to will be deleted too."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords"
      ],
      "requirement": "If another entry shares the file, forgetting removes only the forgotten entry.",
      "sourceQuote": "Unless another entry is sharing that file. In which case only the entry will be removed."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside"
      ],
      "requirement": "The shared-file exception applies even if the file is outside the folder.",
      "sourceQuote": "Even if it points outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleTheIndexNeverKnewStoresNothingForIt"
      ],
      "requirement": "Saving no violations for an unknown rule in repair mode saves nothing.",
      "sourceQuote": "If using `repair` and saving no violations for an unknown rule nothing will be saved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry"
      ],
      "requirement": "If the file cannot be deleted while forgetting a rule, save fails and leaves the entry.",
      "sourceQuote": "If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."
    }
  ],
  "taskSummary": "The task asks the file-backed violation store to add an integrity mode. `default.integrity=ignore` (including when omitted) must leave integrity unchecked; `repair` must inspect the index and folder from disk on initialization, classify broken and resolved entries, preserve sharing and unowned files, and remove only the records/files the prompt specifies. A later `save(rule, emptyList())` in repair mode forgets known rules under the stated sharing/deletion rules, does nothing for unknown rules, and fails without removing the entry when its file cannot be deleted. The added maintenance class contains 48 tests. The build patch also adds a baseline task that runs pre-existing store/concurrency/freezing tests; those suites add no new assertions in this patch.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The prompt says, verbatim, “Defaulting to `ignore` which checks nothing” and “When set to `repair` broken entries will be discarded.”",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Directly distinguishes the default from repair using the same on-disk condition.",
      "verifies": "With no `default.integrity` property, the broken index entry remains; after initializing with `repair`, the index has no entries."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says `ignore` “checks nothing” and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Fair, but largely duplicates the omitted-setting test.",
      "verifies": "With explicit `ignore`, the broken entry remains; with `repair`, it is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt states that ignore checks nothing; repair discards broken/resolved entries and their files; shared entries/files and files no entry points to are not touched. The surviving violation content is the test's own setup.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Good compound coverage of ignore side effects, repair, shared entries, and unowned files. The byte-for-byte assertion is a strong but relevant reading of “checks nothing.”",
      "verifies": "Ignore preserves the folder's file-name set and each pre-recorded file's bytes; subsequent repair removes the broken and unshared resolved entries/files, retains both shared entries and the violating entry, and leaves the unowned file and its contents intact."
    },
    {
      "concerns": [],
      "evidence": "The prompt states that repair discards broken entries; its resolved-entry deletion rule does not apply to the file set up with a violation.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Fair representative consistency check; file contents are not compared.",
      "verifies": "Repair retains the consistent rule entry and its file, while removing the broken entry in the inconsistent folder."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry pointing to a path that is not a regular file directly within the folder is broken, and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "Clear missing-file case.",
      "verifies": "Repair removes the entry whose file name is absent and keeps the entry whose file exists with a violation; only the index and present file remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt says broken entries are discarded in repair mode.",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Useful multi-entry check against repairing only one broken entry.",
      "verifies": "All three entries with missing targets are removed, while the present violating rule remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt and repo search battery covered “not a regular file directly within the folder,” “broken,” “discarded,” “directory,” and “remain/preserve”; the prompt specifies discarding the broken entry but does not specify preserving the referenced directory. Grepping the freeze-store source for `delete`, `isRegularFile`, `directory`, and preservation behavior found no convention governing this side effect. The entry-removal assertion is prompt-stated; the directory-survival co-assertion is not.",
      "fairness": "Not fair",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "The broken-entry assertion is fair, but the extra requirement that the referenced directory survive chooses a cleanup policy the prompt leaves open.",
      "verifies": "The directory-recording index entry is removed; the test additionally requires the directory itself to remain."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "Searched the prompt and freeze-store sources for `socket`, `non-regular`, `broken`, `discard`, `preserve`, and `remain`; neither the prompt nor existing code specifies whether a referenced socket is deleted. The entry-discard expectation is stated; socket preservation is not.",
      "fairness": "Not fair",
      "name": "anEntryRecordingASocketIsBroken",
      "qualityCheck": "The socket-preservation co-assertion is unspecified. The setup also assumes Unix-domain socket support and the `UnixDomainSocketAddress` API, so this test has an `environment_assumption` concern.",
      "verifies": "Repair removes the socket-recording entry and the test requires the Unix-domain socket object to continue existing and remain neither a regular file nor a directory."
    },
    {
      "concerns": [],
      "evidence": "Searched the prompt and store sources for `outside`, `escape`, `broken`, `discard`, `delete`, and `preserve`. The prompt classifies a non-direct path as broken and requires its entry be discarded, but does not say that a referenced external file must survive; the no-touch clause covers files no entry points to, whereas this file is referenced. No existing store code establishes this cleanup side effect.",
      "fairness": "Not fair",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "The index-entry removal is prompt-stated. The assertion that this referenced external file is unchanged is an extra side-effect requirement with no prompt or repo evidence.",
      "verifies": "Repair removes the `../outside.txt` index entry and requires the external file to exist afterward with exactly `precious` as its content."
    },
    {
      "concerns": [],
      "evidence": "Searched the prompt and freeze-store code for `absolute`, `rooted`, `outside`, `broken`, `discard`, `delete`, and `preserve`. The prompt supports classifying the absolute recorded paths as broken and removing those entries, but does not specify the fate of the external file they reference. The separate in-store file is unreferenced by the index's absolute path, but the assertion also pins preservation of the referenced external file, which is not stated.",
      "fairness": "Not fair",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "The entry-removal expectations are fair. The external-file-survival co-assertion is not specified; the in-store file is unowned and its survival is supported by the no-touch rule.",
      "verifies": "Repair removes both absolute-path entries; it additionally requires the external `absolute.txt` contents and the separate in-store `rooted-e448f3` file contents to remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "Searched the prompt and store source for `nested`, `directly within`, `broken`, `discard`, `delete`, and `preserve`. The prompt makes a nested path broken and requires discarding its entry, but it does not prescribe whether the referenced nested file is deleted; no repo convention addresses repair cleanup.",
      "fairness": "Not fair",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Only the file-survival co-assertion is unsupported; the broken-entry assertion follows the prompt.",
      "verifies": "Repair removes the nested-path entry and requires the nested file itself to remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says, “This also applies if the file name is not a valid path,” and says broken entries are discarded. All three names have no corresponding file in the test setup, so they are also broken as absent paths.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Fair no-crash and removal check, but the absent targets mean this test does not isolate invalid-path handling from ordinary missing-file handling.",
      "verifies": "Repair removes the entries with NUL, unpaired-surrogate, and long names, keeps the healthy entry, and leaves only the index and healthy file."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines brokenness by whether the path is a regular file directly within the folder; `./violations` resolves to the direct in-folder file created by this test. The repo's `getViolations` reads the stored file (`TextFileBasedViolationStore.java:190-209`).",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "Tests both normalized-path classification and subsequent readability.",
      "verifies": "Repair retains the `./violations` entry and its file; a separately initialized reader returns exactly `a remaining violation` for that rule."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "Searched the prompt and store sources for `symbolic link`, `outside`, `broken`, `discard`, `delete`, and `preserve`. The prompt establishes that the out-of-folder path is broken, but does not specify whether its referenced external target survives; the no-touch guarantee is only explicit for unpointed files and shared entries/files.",
      "fairness": "Not fair",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "The broken-entry assertion is prompt-stated. The target-survival assertion adds an unspecified deletion policy. Symbolic-link creation also assumes filesystem support (`environment_assumption`).",
      "verifies": "Repair removes the link-recording entry and the test requires the external target's contents to remain `precious`."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt says entries reaching the same regular file through a symbolic link are shared and that a still-violating file is not resolved; the link and target are created within the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Fair symlink-to-in-folder case; depends on symlink creation support.",
      "verifies": "Repair removes the separate broken entry, retains the entry whose symlink reaches the in-folder violating file, and retains the target's contents."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly says the store “will not touch any shared entries or files that no entry points to”; neither the stray link nor its target is recorded by an entry.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Good coverage of the unowned-file rule. Symlink creation requires filesystem support (`environment_assumption`).",
      "verifies": "Repair removes the broken index entry and requires the unrecorded symlink and its external target to survive."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt says an entry whose path does not lead to a regular file directly within the folder is broken and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "Clear dangling-link classification; setup assumes symlink support (`environment_assumption`).",
      "verifies": "Repair removes the entry naming a dangling symlink."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "Searched the prompt and store code for `dangling`, `symbolic link`, `broken`, `discard`, `delete`, and `remain`. The prompt requires discarding broken entries but does not specify whether the referenced dangling link itself is retained; the no-touch clause does not cover a path that an entry points to.",
      "fairness": "Not fair",
      "name": "anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry",
      "qualityCheck": "The two entry removals are prompt-stated; the symlink-survival co-assertion is an unsupported side-effect choice. Symlink setup has an `environment_assumption` concern.",
      "verifies": "Repair removes both entries and requires the dangling symlink object itself to remain."
    },
    {
      "concerns": [],
      "evidence": "Each path fails to identify a regular file directly in the folder, and the prompt says repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken",
      "qualityCheck": "Fair, though it substantially overlaps the absent-file tests.",
      "verifies": "Both entries, one recording `gone` and one recording `./gone`, are removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an unbroken entry whose file has no violations is resolved and that repair discards resolved entries and their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Direct empty-file case.",
      "verifies": "Repair removes the resolved entry and leaves only `stored.rules`, so the empty target file is gone."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly requires discarding a resolved entry and its file, and says that if a resolved entry is a symbolic link the file it points to is deleted as well.",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Covers target deletion and checks that no dangling link remains; symlink setup has an `environment_assumption` concern.",
      "verifies": "For an entry naming a symlink to an empty target, repair removes the entry, target, and symlink itself."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says files that only contain line breaks are resolved, and repair discards resolved entries/files.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Good contrast between line-break-only and violating content.",
      "verifies": "The entry for a file containing only `\\n` characters is removed with its file, while the entry and file containing a violation remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt says files that only contain line breaks are resolved; the test supplies the three common line-break encodings.",
      "fairness": "Prompt-stated",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Useful breadth for line-break forms; the assertion is not an exact output-format pin.",
      "verifies": "Files containing only `\\r\\n`, only `\\r`, or only `\\n` are all removed as resolved; the file containing a violation remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt distinguishes entries with violations from resolved entries with no violations and specifies removal of the latter.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Fair representative contrast.",
      "verifies": "Repair retains the one-line violating entry/file and removes the empty entry/file."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says entries with the same file name are shared even if the name has no file and shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Tests same-name sharing with an existing empty file as well as an unrelated broken record.",
      "verifies": "Two entries with the identical `shared` name remain despite an empty target, while the unrelated broken entry is removed; the shared file remains."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly covers multiple entries reaching the same regular file, symbolic links, files outside the folder, and preserving shared entries/files.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Strong combined case for in-folder aliases and shared external targets. Requires symlink support (`environment_assumption`).",
      "verifies": "The in-folder real-name/symlink entries both remain; the two entries in the other folder that reach one external file through different names also both remain with their original values, and the link and external target survive."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "Searched prompt and source for `directory`, `symbolic link`, `broken`, `discard`, `delete`, and `remain`. The prompt says the entries are broken and discarded but does not say the referenced directory or link survives. No source convention establishes that side effect.",
      "fairness": "Not fair",
      "name": "twoEntriesReachingOneDirectoryByDifferentNamesAreBothBroken",
      "qualityCheck": "The index assertions follow the prompt, but preservation of both referenced non-regular filesystem objects is an extra requirement. Symlink setup has an `environment_assumption` concern.",
      "verifies": "Both entries whose paths reach the directory are removed, while the healthy rule remains; the test additionally requires the directory and its symlink alias to remain."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly names hard links and outside-folder files in its same-regular-file sharing rule, and says shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Direct hard-link coverage; creating hard links assumes filesystem support (`environment_assumption`).",
      "verifies": "The two in-folder hard-link entries and the two entries naming external hard links remain with their original filenames/values and file contents; the unrelated broken entries are removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-name entries are shared even when the name has no file and shared entries/files are not touched; repair otherwise removes resolved entries/files.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Good interaction test between shared and resolved status.",
      "verifies": "Two entries sharing the same empty filename remain, while the separate unshared resolved entry and file are removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-name entries are shared even if nothing exists and that an entry that is shared and anything else remains shared; repair discards other broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Direct test of the explicit shared-plus-broken rule.",
      "verifies": "Two entries sharing the same absent filename remain, while the unrelated absent entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says files that no entry points to are not touched, and broken entries are discarded.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Clear unowned-file check.",
      "verifies": "Repair removes the broken index entry but retains the unrecorded `notes.txt` file and its exact contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt limits entry validity to a regular file directly within the folder and says files no entry points to are not touched.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Good non-recursive/unowned-file case.",
      "verifies": "Repair removes the broken index entry, retains the healthy entry/file, and leaves the unrecorded nested `buried` file unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair examines the on-disk store on initialization, while broken entries/files have already been discarded by the first repair.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Useful idempotence check, but only a single repaired-folder scenario.",
      "verifies": "A second repair initialization leaves the surviving entry and the sorted set of files exactly as after the first repair."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt says entries reaching the same regular file through a symbolic link are shared and remain shared; repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Good interaction of shared paths and repeated repair. Requires symlink support (`environment_assumption`).",
      "verifies": "After a second repair, the index properties and file-name set equal their post-first-repair snapshots; both linked entries and the legacy file's violation content remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires repair to remove the broken entry and retain the valid violating entry; the assertions inspect the repaired index through a separate store instance.",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Useful cross-instance integration check.",
      "verifies": "A newly initialized store reports `contains(broken rule) == false` and `contains(kept rule) == true` after repair."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires discarding the broken and resolved entries/files, while retaining the entry with violations.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Fair aggregate assertion; overlaps several smaller repair tests.",
      "verifies": "After repair, the folder's regular-file names are exactly `stored.rules` and the kept file, and the kept rule's index value is its filename."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards resolved entries; `ViolationStore.contains` is the public membership operation (`ViolationStore.java:57).",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Good API-level integration check.",
      "verifies": "A separate reader returns `contains(resolvedRule) == false` after repair removes the resolved entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt's resolved condition requires no violations, so the set-up file containing a violation is not resolved; repair discards the adjacent broken entry. The store API returns stored lines (`TextFileBasedViolationStore.java:190-209).",
      "fairness": "Prompt-stated",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Tests retained rule membership and exact stored content.",
      "verifies": "After repair, `contains` is true, `getViolations` returns exactly `one remaining violation`, and the index contains only that rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair removes resolved entries and their files; `TextFileBasedViolationStore`'s default filename strategy uses UUIDs (`TextFileBasedViolationStore.java:91-93), so the manually named `resolved` file is not the normal newly generated filename.",
      "fairness": "Prompt-stated",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Good re-save integration test; default UUID naming also makes the last filename assertion predictable.",
      "verifies": "After repair removes the old resolved entry/file, saving one new violation makes the rule present with exactly that violation; the folder has no file named `resolved`."
    },
    {
      "concerns": [],
      "evidence": "The composite return assertion is supported by `FreezingArchRule.java:121-140`: when the store does not contain the rule, it saves the result and returns a successful `EvaluationResult`. Repair removal is prompt-stated; default UUID naming is at `TextFileBasedViolationStore.java:91-93).",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Useful integration test through the actual freeze evaluation path; the prompt alone would not dictate the `EvaluationResult` return form.",
      "verifies": "After the resolved entry is removed, a real `FreezingArchRule` evaluation returns `hasViolation() == false`, then a reader reports the rule stored and no file named `resolved` exists."
    },
    {
      "concerns": [],
      "evidence": "Repair-mode forgetting is explicit in the prompt. For the ignore comparison, the existing `save` path unconditionally ensures an index filename and writes the supplied list (`TextFileBasedViolationStore.java:146-185`); the public API defines save as overwriting stored violations (`ViolationStore.java:61-67).",
      "fairness": "Repo-discoverable",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "Good mode contrast. The ignore-mode retention assertion relies on the existing API implementation, not a separate explicit prompt sentence.",
      "verifies": "Saving an empty list for a known rule under repair empties that index and leaves only its index file; under ignore, the existing entry remains and `getViolations` returns an empty list."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says that if another entry shares the file, only the forgotten entry is removed, even if the file is outside the folder.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Direct coverage of the shared-external-file clause.",
      "verifies": "Saving no violations for one of two entries sharing `../outside.txt` removes only the saved rule's entry, retains the peer's exact path value, and requires external contents to stay `precious`."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly says that when another entry shares the file, only the forgotten entry is removed; the test's link and target reach the same regular file.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Good same-file sharing/deletion interaction. Requires symlink support (`environment_assumption`).",
      "verifies": "Saving no violations for the symlink-named rule removes only its entry; the other entry, both filenames, and the shared file's contents remain, and the writer can still read the peer's violation."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt says a known rule saved with no violations is forgotten, its entry and file are removed, and if its entry is a symbolic link the target is also deleted.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
      "qualityCheck": "Good coverage of both the recorded link and its target; requires symlink support (`environment_assumption`).",
      "verifies": "Saving no violations removes the rule entry, target file, and symlink; the unrelated kept entry and its exact violation remain, and `contains` reports the forgotten rule false."
    },
    {
      "concerns": [
        "brittle_message_matching",
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly says that if the file cannot be deleted, saving fails and leaves the entry. The helper's exact status text is assembled in the test; the underlying state and failure condition are the asserted behavior.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "The synthetic exact status string is brittle formatting, but it represents a deterministic helper outcome rather than an API exception message. POSIX permissions and optionally `setpriv` are environment-dependent.",
      "verifies": "Under a setup that prevents deletion, the helper must return exactly `rejected, still stored with [one violation]`; the index and content remain, then after permissions are restored a later empty save removes the rule and file."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says that in repair mode saving no violations for an unknown rule saves nothing.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct and appropriately scoped.",
      "verifies": "Saving an empty list for an unknown rule leaves the index empty and the folder containing only `stored.rules`."
    },
    {
      "concerns": [],
      "evidence": "The prompt's forget rule is specifically conditional on saving no violations; the existing `ViolationStore` contract says save overwrites a rule's stored violations (`ViolationStore.java:61-67`), and `TextFileBasedViolationStore.save` writes through the existing index mapping (`TextFileBasedViolationStore.java:146-185).",
      "fairness": "Repo-discoverable",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Fair regression of nonempty-save behavior, though it is adjacent to rather than verbatim in the prompt's repair requirement.",
      "verifies": "Saving one remaining violation under repair keeps the rule's index entry and makes `getViolations` return exactly `first violation`."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says repair checks the index and folder as they are on disk during initialization, even if the same folder was initialized before.",
      "fairness": "Prompt-stated",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "Direct test of the stated stale-cache edge case; uses a new store instance on the second initialization, so same-instance reinitialization remains an advisory gap.",
      "verifies": "After an initial ignore initialization, the test replaces the on-disk index with a single broken entry; subsequent repair leaves the index empty."
    }
  ],
  "unfairTestCount": 8,
  "verdict": "FAIL"
}
Close

# Solution Quality
Verdict

FAIL
Summary

The implementation largely covers integrity repair, but it cannot forget the final rule referencing a formerly shared file outside the store.

Scores


Solution Comprehensiveness
1/3 — Not Met
The patch implements the described initialization reconciliation: repair reloads the cached index, classifies invalid/missing/non-regular and empty files, preserves shared entries, and avoids deleting unreferenced files. It also handles empty saves for known rules and deletion failures. One promised case is contradicted: after an outside file is preserved because two entries share it, saving no violations for the first entry removes only that entry; saving no violations for the now-unshared second entry is rejected by the ownership check, leaving the rule and file instead of forgetting the rule. This is a reachable sequence within the shared-file and no-violations-save behavior described.


Code Quality
3/3 — Fully Met
The production changes are organized into a package-private integrity helper and the existing store, use the store's synchronization object for initialization and saves, and keep documentation source and HTML output in sync. Imports and Java language constructs fit the repository's configured conventions; no unrelated production changes or obvious dead code are present. The identified failure is a behavior gap rather than a general maintainability or style problem.

Issues

high
Comprehensiveness
A formerly shared outside file cannot be forgotten by its last entry

For a repair-mode store with two entries pointing to the same outside file, the first empty save correctly removes only its entry. A subsequent empty save for the remaining, now-unshared known rule enters `discard`, but `checkStoreCanOwn` rejects the outside path before deletion or index removal. The save fails and leaves the last entry, although no other entry shares the file. Make the forgetting path handle the last reference separately from the write-ownership check, deleting the recorded file and removing its entry when it is no longer shared, as the stated contract requires.

Evidence: Description: “If using repair and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. ... Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder.”

Feedback

The repair pass is thoughtfully structured and covers the main integrity cases: it reloads the on-disk index, prioritizes shared entries, classifies path and content conditions, and avoids rewriting a consistent index. The save path also correctly preserves a file while another index entry shares it.

There is one remaining lifecycle hole: after one of two rules sharing an outside path is forgotten, the remaining rule is no longer shared, but the ownership guard still prevents its empty save from forgetting it. Please make the final-reference cleanup follow the stated no-longer-shared behavior; with that corrected, the rest of the change looks maintainable and well-scoped.

Completed in 348.7s

Hide raw output
{
  "completed": true,
  "evaluation": {
    "code_quality": {
      "level": "Fully Met",
      "max_score": 3,
      "reasoning": "The production changes are organized into a package-private integrity helper and the existing store, use the store's synchronization object for initialization and saves, and keep documentation source and HTML output in sync. Imports and Java language constructs fit the repository's configured conventions; no unrelated production changes or obvious dead code are present. The identified failure is a behavior gap rather than a general maintainability or style problem.",
      "score": 3
    },
    "issues": [
      {
        "criterion": "comprehensiveness",
        "detail": "For a repair-mode store with two entries pointing to the same outside file, the first empty save correctly removes only its entry. A subsequent empty save for the remaining, now-unshared known rule enters `discard`, but `checkStoreCanOwn` rejects the outside path before deletion or index removal. The save fails and leaves the last entry, although no other entry shares the file. Make the forgetting path handle the last reference separately from the write-ownership check, deleting the recorded file and removing its entry when it is no longer shared, as the stated contract requires.",
        "evidence": "Description: “If using repair and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. ... Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder.”",
        "severity": "high",
        "title": "A formerly shared outside file cannot be forgotten by its last entry"
      }
    ],
    "overall_feedback": "The repair pass is thoughtfully structured and covers the main integrity cases: it reloads the on-disk index, prioritizes shared entries, classifies path and content conditions, and avoids rewriting a consistent index. The save path also correctly preserves a file while another index entry shares it.\n\nThere is one remaining lifecycle hole: after one of two rules sharing an outside path is forgotten, the remaining rule is no longer shared, but the ownership guard still prevents its empty save from forgetting it. Please make the final-reference cleanup follow the stated no-longer-shared behavior; with that corrected, the rest of the change looks maintainable and well-scoped.",
    "solution_comprehensiveness": {
      "level": "Not Met",
      "max_score": 3,
      "reasoning": "The patch implements the described initialization reconciliation: repair reloads the cached index, classifies invalid/missing/non-regular and empty files, preserves shared entries, and avoids deleting unreferenced files. It also handles empty saves for known rules and deletion failures. One promised case is contradicted: after an outside file is preserved because two entries share it, saving no violations for the first entry removes only that entry; saving no violations for the now-unshared second entry is rejected by the ownership check, leaving the rule and file instead of forgetting the rule. This is a reachable sequence within the shared-file and no-violations-save behavior described.",
      "score": 1
    },
    "summary": "The implementation largely covers integrity repair, but it cannot forget the final rule referencing a formerly shared file outside the store.",
    "verdict": "FAIL"
  },
  "executionTimeSeconds": 348.655967,
  "summary": "The implementation largely covers integrity repair, but it cannot forget the final rule referencing a formerly shared file outside the store.",
  "verdict": "FAIL"
}
Close