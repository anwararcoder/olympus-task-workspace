# 01 :: Test Quality
Verdict

FAIL
1 of 47 unfair
Verdict: mostly fair. The suite closely maps to the prompt's detailed path, resolution, sharing, cleanup, and save-time rules, with repository-backed integration checks where the prompt relies on existing ViolationStore/FreezingArchRule behavior. One test is unfairly over-specific: it requires deletion of a symlink target during save(emptyList), while the prompt only unambiguously requires target deletion for an initialization-time resolved symlink. There is a shared environment assumption across the symlink/hard-link tests (symbolic/hard link creation support) and the permission-failure test (POSIX permissions, setpriv, and UID 65534); these can fail or skip on platforms without those facilities. The permission test also asserts a test-generated exact status string, noted per-test.

Unfair Tests

Not fair
forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile
Verifies: Saving no violations removes the entry, the symlink path, and the target file, while preserving the separate keeping rule and its violation.

Evidence: The setup performs save(emptyList) on a known rule, not initialization-time repair of a resolved entry. The prompt explicitly says a symlink target is deleted for a resolved entry, but does not explicitly extend that qualified rule to this save-time scenario. Refutation searches: searched `symbolic link`, `symlink`, `hard link`, `default.integrity`, `integrity`, and `stored.rules` in `archunit/src/**/*.java`; searched `delete`, `Files.delete`, `deleteIfExists`, `Files.isRegularFile`, `toRealPath`, and `isSymbolicLink` in main Java; searched empty-save/forget patterns in freeze tests and repair/symlink/store terms in docs. No existing same-form behavior surfaced. A valid alternative is to remove the stored symlink path while leaving its target; Java NIO's standard `Files.delete` semantics delete a symbolic link itself rather than its target.

Quality: The entry-removal and link-removal expectations fit the save-time rule, but the assertion that the target also disappears imports the initialization-only resolved-symlink clause into a different scenario. The test is therefore over-specified.

Requirement Coverage (6/16 covered)

Advisory only — prompt-stated requirements and whether the hidden tests pin them.

partial
Repair audits the stored index and folder during initialization.

"Setting `default.integrity` to `repair` will check the index and folder during initialization."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne, repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder

covered
Absent integrity configuration and explicit ignore perform no integrity checking or changes.

"Defaulting to `ignore` which checks nothing."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingSoRepairStillFindsEveryCondition

partial
An entry is broken if its path does not refer to a regular file directly inside the store folder.

"If an entry points to a path that is not a regular file directly within the folder, it is broken."

anEntryWhoseFileIsAbsentIsBroken, anEntryRecordingADirectoryIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched, anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives, anEntryRecordingANestedNameIsBrokenAndThatFileSurvives, anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives, anEntryNamingADanglingLinkIsBroken

partial
An invalid path in an entry's file name is broken.

"This also applies if the file name is not a valid path."

anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne

partial
An unbroken entry with a file containing no violations is resolved.

"If an entry is not broken and its file has no violations it is resolved."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs, aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded

partial
A file containing only line breaks is resolved.

"Files that only contain line breaks are also resolved."

aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks

covered
Entries with the same recorded file name are shared, even if that name does not exist.

"Entries that point to the same file name are shared, even if nothing exists with that name."

aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair

partial
Entries reaching the same regular file by different names are shared, including symbolic/hard links and files outside the folder.

"If multiple entries point to the same regular file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."

twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded

partial
Shared entries/files and files with no entry pointing to them are not touched.

"The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to."

ignoreExaminesNothingSoRepairStillFindsEveryCondition, aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget, anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded, aFileInsideADirectoryInTheStoreFolderIsNeverACondition, forgettingARuleKeepsTheFileAnotherEntryStillRecords

covered
An entry remains shared when it is shared and also has another condition.

"If an entry is shared and anything else it will remain shared."

aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, aSharedNameHoldingNoViolationsIsNotDiscardedEither, anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair

partial
Repair discards broken entries.

"When set to `repair` broken entries will be discarded."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, anEntryWhoseFileIsAbsentIsBroken, everyBrokenEntryIsDiscarded, anEntryRecordingADirectoryIsBroken, anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched

partial
Repair discards resolved entries and their files; for a resolved symlink entry it also deletes the target.

"When set to `repair` resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well."

anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile, aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt, aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry

partial
Saving no violations for a known rule under repair forgets the rule and removes its entry/file.

"If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well."

storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile, forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry

covered
If another entry shares the forgotten rule's file, only the forgotten entry is removed, including for an outside file.

"Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."

forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside, forgettingARuleKeepsTheFileAnotherEntryStillRecords

covered
Saving no violations for an unknown rule under repair saves nothing.

"If using `repair` and saving no violations for an unknown rule nothing will be saved."

forgettingARuleTheIndexNeverKnewStoresNothingForIt

covered
If the file cannot be deleted while forgetting a known rule, saving fails and its entry remains.

"If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."

forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry

Coverage Suggestions (3)

Advisory only — these don't affect the check result.

Invalid file-name handling
single point
Prompt-stated
Requirement: An invalid path in an entry's file name is broken.

Add a distinct invalid-name case beyond NUL and an unpaired surrogate, so an implementation that special-cases just these malformed strings does not satisfy the broader invalid-path requirement.

Shared regular-file identity outside the folder
single point
Prompt-stated
Requirement: Entries reaching the same regular file by different names are shared, including symbolic/hard links and files outside the folder.

Add a hard-link pair outside the store folder (or another outside regular-file alias) to complement the current outside symlink and in-folder hard-link cases.

Broken path classes
single point
Prompt-stated
Requirement: An entry is broken if its path does not refer to a regular file directly inside the store folder.

Add a platform-supported non-regular filesystem object other than a directory, if the test environment supports one, to ensure the regular-file condition is not implemented as only missing/directory/path-escape checks.

Quality Notes (46)

Prompt-stated
absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Directly distinguishes the default from repair on the same missing-file setup.

Prompt-stated
ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Redundant with the absent-setting test for the outcome, but usefully checks explicit ignore too.

Prompt-stated
ignoreExaminesNothingSoRepairStillFindsEveryCondition
Strong co-assertions cover state preservation, later repair, sharing, and unowned-file preservation.

Prompt-stated
repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne
Fair but shallow: the consistent case does not compare file bytes or index values.

Prompt-stated
anEntryWhoseFileIsAbsentIsBroken
A direct missing-file case; other tests exercise additional broken-path forms.

Prompt-stated
everyBrokenEntryIsDiscarded
Useful check that repair handles multiple broken entries in one index.

Prompt-stated
anEntryRecordingADirectoryIsBroken
Directly checks the regular-file distinction and that repair does not remove the directory.

Prompt-stated
anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched
Tests containment and preservation of an external target; the asserted content also catches overwriting, not just deletion.

Prompt-stated
anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives
Checks two absolute-path forms and verifies that neither referenced file is deleted.

Prompt-stated
anEntryRecordingANestedNameIsBrokenAndThatFileSurvives
Good distinct case for the “directly within” qualifier.

Prompt-stated
anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne
Exercises two malformed names alongside a healthy entry; it is a representative, not exhaustive, invalid-path set.

Standard external semantics
anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken
The direct file-state assertions and the reader assertion are complementary; the reader assertion verifies the surviving mapping is usable.

Prompt-stated
anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives
Checks a symlink path separately from a lexical `..` escape.

Prompt-stated
anEntryNamingALinkToAFileInTheStoreOwnsThatFile
Fair; only one entry names this file, so it checks validity rather than the shared-entry exception.

Prompt-stated
aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget
Checks both an unowned link and its target; this is a useful boundary case.

Prompt-stated
anEntryNamingADanglingLinkIsBroken
Direct, though the test does not additionally assert whether the dangling link itself remains.

Prompt-stated
anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry
Useful distinction between an alias name and an actual regular-file target.

Prompt-stated
entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken
Checks the absent-file edge case for distinct spellings; the assertion is limited to the index state.

Prompt-stated
anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile
Direct empty-file case.

Prompt-stated
aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt
Checks both link and target removal rather than only index removal.

Prompt-stated
aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry
Good paired positive/negative case, but limited to LF for the line-break-only input.

Standard external semantics
aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks
Good encoding variation; the nonempty CRLF case prevents treating every file containing carriage returns as empty.

Prompt-stated
anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs
Direct contrast, though redundant with the empty and line-break tests.

Prompt-stated
aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded
Strongly tests that sharing takes precedence over empty/resolved status.

Prompt-stated
twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded
Several co-assertions check both alias forms, stored values, and link/target survival; a good direct test of the outside-folder exception.

Prompt-stated
twoEntriesReachingOneDirectoryByDifferentNamesAreBothBroken
Useful discriminator against incorrectly treating any shared filesystem object as a shared regular file.

Prompt-stated
twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded
Direct hard-link case and checks that an empty shared file is retained.

Prompt-stated
aSharedNameHoldingNoViolationsIsNotDiscardedEither
Clear paired check of shared versus unshared empty files.

Prompt-stated
anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair
Strongly discriminates the shared override from ordinary broken-entry repair.

Prompt-stated
anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded
Direct unowned regular-file case.

Prompt-stated
aFileInsideADirectoryInTheStoreFolderIsNeverACondition
Checks both the depth boundary and preservation of unowned nested content.

Prompt-stated
aSecondInitializationOfARepairedFolderDiscardsNothing
Useful idempotence check; it does not compare bytes or metadata.

Prompt-stated
anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled
Good checks for stable sharing; the repeated initialization is redundant with the prior idempotence test.

Prompt-stated
aSeparatelyCreatedStoreObservesTheRepairedIndex
Checks persisted index visibility through the public `contains` API.

Prompt-stated
aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord
Clear end-state check, though the preceding tests already cover these cleanup cases separately.

Prompt-stated
aRuleWhoseEntryWasDiscardedIsNoLongerFrozen
Direct integration check through the store's public rule lookup.

Prompt-stated
repairKeepsAStillViolatingRuleFrozenWithItsViolations
Checks public lookup, returned content, and removal of an adjacent broken entry.

Prompt-stated
aRepairedStoreCanFreezeARuleAgain
Good recovery integration test; the exact old filename check specifically distinguishes deletion from reuse.

Repo-discoverable
aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation
Valid integration behavior grounded in the existing FreezingArchRule flow; more involved than the direct store tests.

Repo-discoverable
storingNoViolationsUnderRepairForgetsTheEntryAndItsFile
The ignore control is not itself stated as a save-time rule, but is predictable from the visible existing save implementation.

Prompt-stated
forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside
Good combined coverage of outside-folder sharing and the save-time forgetting exception.

Prompt-stated
forgettingARuleKeepsTheFileAnotherEntryStillRecords
Strong public-API check of a file remaining usable after one alias entry is forgotten.

Prompt-stated
forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry
The helper's exact status string is test-generated rather than a product error message, but its exact formatting is unnecessary to the semantic requirement; state assertions separately verify retention and subsequent deletion.

brittle message
Prompt-stated
forgettingARuleTheIndexNeverKnewStoresNothingForIt
Direct test of the unknown-rule case.

Repo-discoverable
aStillViolatedRuleKeepsItsEntryUnderRepair
The precise one-line update follows the visible save contract; it also checks repair does not discard a newly nonempty file.

Prompt-stated
repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder
Useful stale-index integration case; exact behavior is anchored in the initialization-time audit requirement.

Task Summary

The task asks the text-file violation store to audit its stored.rules entries and referenced files at initialization when default.integrity=repair, while the default/ignore mode leaves them alone. Repair must remove broken or resolved entries under the stated sharing rules, clean up owned files as specified, and make save(emptyList) forget a known rule without deleting a file another entry shares. The tests also exercise the resulting store through ViolationStore and FreezingArchRule.

Completed in 252.8s

Hide raw output
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Invalid file-name handling",
      "gapKind": "single_point",
      "requirement": "An invalid path in an entry's file name is broken.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Add a distinct invalid-name case beyond NUL and an unpaired surrogate, so an implementation that special-cases just these malformed strings does not satisfy the broader invalid-path requirement."
    },
    {
      "area": "Shared regular-file identity outside the folder",
      "gapKind": "single_point",
      "requirement": "Entries reaching the same regular file by different names are shared, including symbolic/hard links and files outside the folder.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Add a hard-link pair outside the store folder (or another outside regular-file alias) to complement the current outside symlink and in-folder hard-link cases."
    },
    {
      "area": "Broken path classes",
      "gapKind": "single_point",
      "requirement": "An entry is broken if its path does not refer to a regular file directly inside the store folder.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Add a platform-supported non-regular filesystem object other than a directory, if the test environment supports one, to ensure the regular-file condition is not implemented as only missing/directory/path-escape checks."
    }
  ],
  "error": "",
  "executionTimeSeconds": 252.78847,
  "message": "1 test flagged as not fair.",
  "overall": "Verdict: mostly fair. The suite closely maps to the prompt's detailed path, resolution, sharing, cleanup, and save-time rules, with repository-backed integration checks where the prompt relies on existing ViolationStore/FreezingArchRule behavior. One test is unfairly over-specific: it requires deletion of a symlink target during save(emptyList), while the prompt only unambiguously requires target deletion for an initialization-time resolved symlink. There is a shared environment assumption across the symlink/hard-link tests (symbolic/hard link creation support) and the permission-failure test (POSIX permissions, setpriv, and UID 65534); these can fail or skip on platforms without those facilities. The permission test also asserts a test-generated exact status string, noted per-test.",
  "requirements": [
    {
      "covered": "partial",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
        "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder"
      ],
      "requirement": "Repair audits the stored index and folder during initialization.",
      "sourceQuote": "Setting `default.integrity` to `repair` will check the index and folder during initialization."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition"
      ],
      "requirement": "Absent integrity configuration and explicit ignore perform no integrity checking or changes.",
      "sourceQuote": "Defaulting to `ignore` which checks nothing."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
        "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
        "anEntryNamingADanglingLinkIsBroken"
      ],
      "requirement": "An entry is broken if its path does not refer to a regular file directly inside the store folder.",
      "sourceQuote": "If an entry points to a path that is not a regular file directly within the folder, it is broken."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne"
      ],
      "requirement": "An invalid path in an entry's file name is broken.",
      "sourceQuote": "This also applies if the file name is not a valid path."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded"
      ],
      "requirement": "An unbroken entry with a file containing no violations is resolved.",
      "sourceQuote": "If an entry is not broken and its file has no violations it is resolved."
    },
    {
      "covered": "partial",
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
      "requirement": "Entries with the same recorded file name are shared, even if that name does not exist.",
      "sourceQuote": "Entries that point to the same file name are shared, even if nothing exists with that name."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded"
      ],
      "requirement": "Entries reaching the same regular file by different names are shared, including symbolic/hard links and files outside the folder.",
      "sourceQuote": "If multiple entries point to the same regular file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
        "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords"
      ],
      "requirement": "Shared entries/files and files with no entry pointing to them are not touched.",
      "sourceQuote": "The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair"
      ],
      "requirement": "An entry remains shared when it is shared and also has another condition.",
      "sourceQuote": "If an entry is shared and anything else it will remain shared."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "anEntryWhoseFileIsAbsentIsBroken",
        "everyBrokenEntryIsDiscarded",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched"
      ],
      "requirement": "Repair discards broken entries.",
      "sourceQuote": "When set to `repair` broken entries will be discarded."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry"
      ],
      "requirement": "Repair discards resolved entries and their files; for a resolved symlink entry it also deletes the target.",
      "sourceQuote": "When set to `repair` resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry"
      ],
      "requirement": "Saving no violations for a known rule under repair forgets the rule and removes its entry/file.",
      "sourceQuote": "If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords"
      ],
      "requirement": "If another entry shares the forgotten rule's file, only the forgotten entry is removed, including for an outside file.",
      "sourceQuote": "Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder."
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
      "requirement": "If the file cannot be deleted while forgetting a known rule, saving fails and its entry remains.",
      "sourceQuote": "If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry."
    }
  ],
  "taskSummary": "The task asks the text-file violation store to audit its stored.rules entries and referenced files at initialization when default.integrity=repair, while the default/ignore mode leaves them alone. Repair must remove broken or resolved entries under the stated sharing rules, clean up owned files as specified, and make save(emptyList) forget a known rule without deleting a file another entry shares. The tests also exercise the resulting store through ViolationStore and FreezingArchRule.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The description says, “Defaulting to `ignore` which checks nothing” and “When set to `repair` broken entries will be discarded.”",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Directly distinguishes the default from repair on the same missing-file setup.",
      "verifies": "With no integrity property the missing-file entry remains; initializing with repair removes it."
    },
    {
      "concerns": [],
      "evidence": "The description says, “Defaulting to `ignore` which checks nothing” and “When set to `repair` broken entries will be discarded.”",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Redundant with the absent-setting test for the outcome, but usefully checks explicit ignore too.",
      "verifies": "Explicit ignore retains the missing-file entry, while repair removes it."
    },
    {
      "concerns": [],
      "evidence": "The description says ignore “checks nothing”; repair discards broken and resolved entries/files; shared entries remain shared; and the store “will not touch any shared entries or files that no entry points to.”",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Strong co-assertions cover state preservation, later repair, sharing, and unowned-file preservation.",
      "verifies": "Ignore leaves the directory's file names and bytes unchanged; subsequent repair removes the missing and empty-file entries, retains both entries sharing a nonempty file and the nonempty entry, and leaves an unowned file and its content unchanged."
    },
    {
      "concerns": [],
      "evidence": "The description requires repair to check the index/folder and discard broken entries; a file with a violation is not resolved.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Fair but shallow: the consistent case does not compare file bytes or index values.",
      "verifies": "Repair leaves the consistent store's rule key and two top-level file names present, and removes the entry for a missing file in the inconsistent store."
    },
    {
      "concerns": [],
      "evidence": "The description says an entry whose path is not a regular file directly within the folder is broken and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "A direct missing-file case; other tests exercise additional broken-path forms.",
      "verifies": "Repair removes the entry whose referenced name is absent and retains the entry/file that exists with a violation."
    },
    {
      "concerns": [],
      "evidence": "The description says, “When set to `repair` broken entries will be discarded.”",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Useful check that repair handles multiple broken entries in one index.",
      "verifies": "All three entries referencing absent files are removed, while the valid entry remains."
    },
    {
      "concerns": [],
      "evidence": "A directory is not a regular file directly within the folder; the description says such an entry is broken and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "Directly checks the regular-file distinction and that repair does not remove the directory.",
      "verifies": "The directory entry is removed from stored.rules, while the directory remains a directory."
    },
    {
      "concerns": [],
      "evidence": "The path is not a regular file directly within the store folder, so it is broken; repair discards broken entries. The prompt distinguishes files within the folder from external paths and says only resolved-entry files are discarded.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Tests containment and preservation of an external target; the asserted content also catches overwriting, not just deletion.",
      "verifies": "The ../outside.txt entry is removed, and the outside file still exists with the exact content “precious.”"
    },
    {
      "concerns": [],
      "evidence": "The description classifies paths not directly within the folder as broken and says repair discards broken entries; it separately says resolved entries and their files are discarded.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "Checks two absolute-path forms and verifies that neither referenced file is deleted.",
      "verifies": "The absolute outside path and the slash-prefixed absolute path are removed as entries; the outside file's content and the in-folder file's content remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "The description says a path must refer to a regular file directly within the folder; a file in a nested directory does not meet that condition, and repair discards the broken entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Good distinct case for the “directly within” qualifier.",
      "verifies": "The nested/violations entry is removed, while the nested file still exists."
    },
    {
      "concerns": [],
      "evidence": "The description explicitly says the broken-path rule also applies when “the file name is not a valid path.”",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Exercises two malformed names alongside a healthy entry; it is a representative, not exhaustive, invalid-path set.",
      "verifies": "Entries using a NUL-containing name and an unpaired-surrogate name are removed; the healthy entry, its file name, and its exact contents remain."
    },
    {
      "concerns": [],
      "evidence": "Java/filesystem relative-path resolution makes `./violations` resolve to the same direct child as `violations`; this matches the prompt's criterion that the path point to a regular file directly in the folder. The repo's store reads the entry value through `new File(storeFolder, fileName)` at `TextFileBasedViolationStore.java:205-208`.",
      "fairness": "Standard external semantics",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "The direct file-state assertions and the reader assertion are complementary; the reader assertion verifies the surviving mapping is usable.",
      "verifies": "The `./violations` entry survives repair, the broken missing-file entry is removed, the file contents remain, and a reader returns exactly one violation, “a remaining violation.”"
    },
    {
      "concerns": [],
      "evidence": "A single entry to an external target is not a regular file directly within the folder and is broken; repair discards broken entries. The prompt's extra target-deletion rule is specifically for a resolved symlink entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Checks a symlink path separately from a lexical `..` escape.",
      "verifies": "The entry naming a symlink to an outside file is removed, and the outside file still contains “precious.”"
    },
    {
      "concerns": [],
      "evidence": "The entry reaches a regular file directly within the folder; the description says multiple entries can reach one regular file through a symbolic link, establishing that the link's target is the relevant file.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Fair; only one entry names this file, so it checks validity rather than the shared-entry exception.",
      "verifies": "The entry naming an in-folder symlink survives repair and the target file retains its violation content."
    },
    {
      "concerns": [],
      "evidence": "The description says the store will not touch “files that no entry points to”; the stray link and target are not recorded by any entry.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Checks both an unowned link and its target; this is a useful boundary case.",
      "verifies": "Repair removes the broken index entry but leaves an unrecorded symlink and its outside target/content intact."
    },
    {
      "concerns": [],
      "evidence": "A dangling link does not reach a regular file directly within the folder; repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "Direct, though the test does not additionally assert whether the dangling link itself remains.",
      "verifies": "Repair removes the entry whose symlink target does not exist."
    },
    {
      "concerns": [],
      "evidence": "Neither name reaches a regular file, so both entries are broken; repair discards broken entries. The link itself is not a file that a surviving entry records.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry",
      "qualityCheck": "Useful distinction between an alias name and an actual regular-file target.",
      "verifies": "Both entries are removed, and the dangling alias symlink itself remains a symbolic link."
    },
    {
      "concerns": [],
      "evidence": "Both paths fail the prompt's regular-file requirement; the description says entries sharing the same file name are shared, not arbitrary spellings that resolve to no file.",
      "fairness": "Prompt-stated",
      "name": "entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken",
      "qualityCheck": "Checks the absent-file edge case for distinct spellings; the assertion is limited to the index state.",
      "verifies": "Entries for `gone` and `./gone` are both removed when neither spelling reaches a file."
    },
    {
      "concerns": [],
      "evidence": "The description says an unbroken entry whose file has no violations is resolved, and repair discards resolved entries and their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Direct empty-file case.",
      "verifies": "Repair removes the empty-file entry and leaves only stored.rules among top-level files."
    },
    {
      "concerns": [],
      "evidence": "The description says repair discards resolved entries and their files, and specifically says that for a resolved symbolic-link entry “the file it points to will be deleted as well.”",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Checks both link and target removal rather than only index removal.",
      "verifies": "Repair removes the entry, the target file, and the symlink path; only stored.rules remains and the path is no longer a symlink."
    },
    {
      "concerns": [],
      "evidence": "The description explicitly says files containing only line breaks are resolved; it also defines resolution as a file having no violations.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Good paired positive/negative case, but limited to LF for the line-break-only input.",
      "verifies": "The LF-only file's entry/file are removed, while the entry for a file containing a violation plus a trailing LF remains."
    },
    {
      "concerns": [],
      "evidence": "Java line-reading semantics recognize CR, LF, and CRLF as line terminators; the assertion applies the prompt's “only contain line breaks” rule to each form.",
      "fairness": "Standard external semantics",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Good encoding variation; the nonempty CRLF case prevents treating every file containing carriage returns as empty.",
      "verifies": "Entries for CRLF-only, CR-only, and LF-only files are removed; the CRLF-terminated violation entry remains."
    },
    {
      "concerns": [],
      "evidence": "The description says an entry is resolved if its file has no violations and repair discards resolved entries and their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Direct contrast, though redundant with the empty and line-break tests.",
      "verifies": "Repair keeps the one-violation entry/file and removes the empty entry/file."
    },
    {
      "concerns": [],
      "evidence": "The description says entries pointing to “the same file name are shared, even if nothing exists with that name,” and shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Strongly tests that sharing takes precedence over empty/resolved status.",
      "verifies": "Both entries with the same name remain even though their shared file is empty, and the file remains."
    },
    {
      "concerns": [],
      "evidence": "The description says multiple entries reaching the same regular file are shared through symbolic links and even when the file is outside the folder; shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Several co-assertions check both alias forms, stored values, and link/target survival; a good direct test of the outside-folder exception.",
      "verifies": "The in-folder file and symlink entries both remain with their original names; the link and target remain. For the outside target, both the `../outside.txt` and symlink entries remain, along with the symlink and outside file."
    },
    {
      "concerns": [],
      "evidence": "Sharing by different names is specified only when entries reach the same regular file; a directory is not a regular file, so both entries are broken and repair discards them.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneDirectoryByDifferentNamesAreBothBroken",
      "qualityCheck": "Useful discriminator against incorrectly treating any shared filesystem object as a shared regular file.",
      "verifies": "Both the directory entry and the symlink-to-directory entry are removed; the directory, healthy entry/file, and now-unrecorded symlink remain."
    },
    {
      "concerns": [],
      "evidence": "The description explicitly includes hard links in the rule that multiple entries pointing to the same regular file are shared.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Direct hard-link case and checks that an empty shared file is retained.",
      "verifies": "Both hard-link entries remain with their original names, and both hard-link names still exist despite the empty content."
    },
    {
      "concerns": [],
      "evidence": "The description says same-name entries are shared and shared entries/files are not touched; an unshared no-violation entry is resolved and discarded.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Clear paired check of shared versus unshared empty files.",
      "verifies": "Both entries sharing the empty file remain, while the separate empty-file entry and its file are removed."
    },
    {
      "concerns": [],
      "evidence": "The description says entries sharing the same name remain shared even if nothing exists under that name, and that a shared entry remains shared if it is also anything else; repair discards the lone broken entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Strongly discriminates the shared override from ordinary broken-entry repair.",
      "verifies": "The two entries for the same absent name remain; the separate absent-file entry is removed; no data file is created."
    },
    {
      "concerns": [],
      "evidence": "The description says repair discards broken entries and the store will not touch files that no entry points to.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Direct unowned regular-file case.",
      "verifies": "The broken entry is removed, while the unowned notes.txt file and its exact content survive."
    },
    {
      "concerns": [],
      "evidence": "The prompt limits entries to regular files directly within the folder and says files no entry points to are not touched.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Checks both the depth boundary and preservation of unowned nested content.",
      "verifies": "The valid rule remains; the broken entry is removed; the nested directory's buried file retains its content."
    },
    {
      "concerns": [],
      "evidence": "Repair discards the broken entry; after that repair the remaining entry points to a file with a violation, so it is neither broken nor resolved under the prompt's definitions.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Useful idempotence check; it does not compare bytes or metadata.",
      "verifies": "After a second repair, the surviving rule and sorted top-level file-name list equal the post-first-repair state."
    },
    {
      "concerns": [],
      "evidence": "The description says entries reaching the same regular file through a symbolic link are shared and shared entries/files are not touched.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Good checks for stable sharing; the repeated initialization is redundant with the prior idempotence test.",
      "verifies": "After two repair initializations, both entries and their original stored values are unchanged, the file content is unchanged, and the file-name list is stable."
    },
    {
      "concerns": [],
      "evidence": "Repair must remove the broken entry from the index; the repo's store loads and consults the index via `TextFileBasedViolationStore.java:114-120` and `:141-145`.",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Checks persisted index visibility through the public `contains` API.",
      "verifies": "A second store instance initialized in ignore mode reports the discarded rule absent and the surviving rule present."
    },
    {
      "concerns": [],
      "evidence": "Repair discards the broken and resolved entries/files; the unowned-file rule does not require deletion of any files here because none are unowned in the setup.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Clear end-state check, though the preceding tests already cover these cleanup cases separately.",
      "verifies": "After repair, the only top-level files are stored.rules and the surviving entry's file, and that entry maps to the exact kept filename."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards resolved entries; the repo defines `contains` as checking the stored rule description at `TextFileBasedViolationStore.java:141-145`.",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Direct integration check through the store's public rule lookup.",
      "verifies": "After repair, a newly initialized reader reports `contains(resolvedRule)` as false."
    },
    {
      "concerns": [],
      "evidence": "The prompt resolves only files with no violations and discards broken/resolved entries; a nonempty violation file is neither condition.",
      "fairness": "Prompt-stated",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Checks public lookup, returned content, and removal of an adjacent broken entry.",
      "verifies": "The reader reports the surviving rule present, returns exactly `one remaining violation`, and stored.rules contains only that rule's description."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair removes the resolved entry and its file. The repo says `save` stores or updates violations at `ViolationStore.java:49-55` and writes them at `TextFileBasedViolationStore.java:147-166`.",
      "fairness": "Prompt-stated",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Good recovery integration test; the exact old filename check specifically distinguishes deletion from reuse.",
      "verifies": "After repair removed the resolved mapping, saving one violation re-adds the rule, returns exactly that violation, and does not recreate the old filename `resolved`."
    },
    {
      "concerns": [],
      "evidence": "`FreezingArchRule.evaluate` saves and returns success when the rule is not already stored (`FreezingArchRule.java:120-145`); repair removes the previous resolved entry/file as stated in the prompt.",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Valid integration behavior grounded in the existing FreezingArchRule flow; more involved than the direct store tests.",
      "verifies": "A real FreezingArchRule evaluation returns a result with no violation, then a reader finds the rule stored and the old resolved filename absent."
    },
    {
      "concerns": [],
      "evidence": "The repair branch is directly stated in the prompt. For ignore-mode save behavior, the repo's `save` always obtains a filename and writes the supplied list (`TextFileBasedViolationStore.java:147-166`); the `ViolationStore.save` contract says existing violations are overwritten (`ViolationStore.java:49-55`).",
      "fairness": "Repo-discoverable",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "The ignore control is not itself stated as a save-time rule, but is predictable from the visible existing save implementation.",
      "verifies": "Under repair, saving an empty list removes the known rule and leaves only stored.rules; under ignore, saving the same empty list leaves the entry, and its reader returns an empty list."
    },
    {
      "concerns": [],
      "evidence": "The prompt says shared entries remain shared even when the shared file is outside the folder, and forgetting a shared file removes only the entry.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Good combined coverage of outside-folder sharing and the save-time forgetting exception.",
      "verifies": "Saving no violations removes the forgotten rule's entry but retains the peer entry with the same `../outside.txt` value; the outside file still exists with exact content `precious`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says multiple entries reaching the same regular file through a symbolic link are shared and that forgetting a rule with a shared file removes only its entry.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Strong public-API check of a file remaining usable after one alias entry is forgotten.",
      "verifies": "Saving no violations removes only the rule using the symlink name; the other entry, both names, and the target content remain, and the writer can still read the peer's violation."
    },
    {
      "concerns": [],
      "evidence": "The setup performs save(emptyList) on a known rule, not initialization-time repair of a resolved entry. The prompt explicitly says a symlink target is deleted for a resolved entry, but does not explicitly extend that qualified rule to this save-time scenario. Refutation searches: searched `symbolic link`, `symlink`, `hard link`, `default.integrity`, `integrity`, and `stored.rules` in `archunit/src/**/*.java`; searched `delete`, `Files.delete`, `deleteIfExists`, `Files.isRegularFile`, `toRealPath`, and `isSymbolicLink` in main Java; searched empty-save/forget patterns in freeze tests and repair/symlink/store terms in docs. No existing same-form behavior surfaced. A valid alternative is to remove the stored symlink path while leaving its target; Java NIO's standard `Files.delete` semantics delete a symbolic link itself rather than its target.",
      "fairness": "Not fair",
      "name": "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
      "qualityCheck": "The entry-removal and link-removal expectations fit the save-time rule, but the assertion that the target also disappears imports the initialization-only resolved-symlink clause into a different scenario. The test is therefore over-specified.",
      "verifies": "Saving no violations removes the entry, the symlink path, and the target file, while preserving the separate keeping rule and its violation."
    },
    {
      "concerns": [
        "brittle_message_matching"
      ],
      "evidence": "The prompt explicitly says that if the file cannot be deleted, saving fails and leaves the entry; it also says that once saving no violations succeeds for a known rule, the rule and file are removed.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "The helper's exact status string is test-generated rather than a product error message, but its exact formatting is unnecessary to the semantic requirement; state assertions separately verify retention and subsequent deletion.",
      "verifies": "The unprivileged save attempt yields the exact helper result `rejected, still stored with [one violation]`; the index mapping and file content remain, then a later save after permissions are restored removes the entry/file."
    },
    {
      "concerns": [],
      "evidence": "The description explicitly says, “If using `repair` and saving no violations for an unknown rule nothing will be saved.”",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct test of the unknown-rule case.",
      "verifies": "Saving an empty list for an unknown rule leaves the index empty and stored.rules as the only top-level file."
    },
    {
      "concerns": [],
      "evidence": "The repo's `ViolationStore.save` contract says a rule's stored violations are overwritten (`ViolationStore.java:49-55`), and `TextFileBasedViolationStore` writes one line per supplied violation (`:147-166`). The repair cleanup of the adjacent broken entry is prompt-stated.",
      "fairness": "Repo-discoverable",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "The precise one-line update follows the visible save contract; it also checks repair does not discard a newly nonempty file.",
      "verifies": "Saving one remaining violation retains the rule entry and returns exactly that violation; the adjacent broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The description says setting repair checks the index and folder during initialization; this setup deliberately changes the on-disk index before that repair initialization.",
      "fairness": "Prompt-stated",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "Useful stale-index integration case; exact behavior is anchored in the initialization-time audit requirement.",
      "verifies": "After an earlier ignore initialization and external replacement of stored.rules, a later repair initialization removes the newly added missing-file entry."
    }
  ],
  "unfairTestCount": 1,
  "verdict": "FAIL"
}
Close

# 02 :: Dockerfile guidelines
Warning
warning: The Dockerfile enforces a pinned Gradle distribution by checking the distributionSha256Sum and verifying Gradle 9.7.1 (the grep checks). However, the Dockerfile cannot itself guarantee that the project's library dependencies are pinned — that depends on committed files in the repository such as gradle.lockfile, libs.versions.toml, or other lock manifests. Ensure the repository contains committed Gradle lockfiles or pinned version manifests (e.g., gradle.lockfile or a properly populated libs.versions.toml and any relevant lockfiles) so dependency resolution is reproducible.
warning: The Dockerfile does not perform a full project assemble/build (e.g., ./gradlew build or ./gradlew assemble for the full project). It performs targeted compilation of archunit testClasses and a cacheOfflineDependencies run to populate caches. This is reasonable, but if your intent is to populate build artifacts and maximize build-cache reuse for downstream tasks, consider adding an explicit assemble/build step (for example: ./gradlew --no-daemon assemble or ./gradlew --no-daemon build) to precompile the main project modules during image build. If you prefer a smaller image and only caching dependencies, the current approach is acceptable.

Note: Internet access is available during `docker build`, but not when running the container. Test patch is injected into the container after build. Ensure your Dockerfile installs all dependencies at build time so the environment works fully offline after build.

Raw Output

{
  "all_issues": "warning: The Dockerfile enforces a pinned Gradle distribution by checking the distributionSha256Sum and verifying Gradle 9.7.1 (the grep checks). However, the Dockerfile cannot itself guarantee that the project's library dependencies are pinned — that depends on committed files in the repository such as gradle.lockfile, libs.versions.toml, or other lock manifests. Ensure the repository contains committed Gradle lockfiles or pinned version manifests (e.g., gradle.lockfile or a properly populated libs.versions.toml and any relevant lockfiles) so dependency resolution is reproducible.\nwarning: The Dockerfile does not perform a full project assemble/build (e.g., ./gradlew build or ./gradlew assemble for the full project). It performs targeted compilation of archunit testClasses and a cacheOfflineDependencies run to populate caches. This is reasonable, but if your intent is to populate build artifacts and maximize build-cache reuse for downstream tasks, consider adding an explicit assemble/build step (for example: ./gradlew --no-daemon assemble or ./gradlew --no-daemon build) to precompile the main project modules during image build. If you prefer a smaller image and only caching dependencies, the current approach is acceptable.",
  "base_image_compliant": {
    "explanation": "OK: Dockerfile uses FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest which is one of the accepted Olympus base images.",
    "status": "OK"
  },
  "dependencies_installed": {
    "explanation": "OK: The Dockerfile uses the project's Gradle wrapper (./gradlew) to validate the wrapper (checking distributionSha256Sum and Gradle version), runs tasks to compile test classes (:archunit:testClasses, :archunit:compileJdk9mainJava) and a custom cacheOfflineDependencies task to populate Gradle dependency caches. These actions install/fetch project dependencies via the wrapper rather than leaving them entirely for first container run.",
    "status": "OK"
  },
  "interactive_shell": {
    "explanation": "OK: The container ends with CMD [\"/bin/bash\"], providing an interactive shell for developers.",
    "status": "OK"
  },
  "no_test_execution": {
    "explanation": "OK: The Dockerfile compiles test classes (:archunit:testClasses) but does not run tests. It does not COPY or execute test.sh or apply test.patch. No test runner (e.g., ./gradlew test) is invoked.",
    "status": "OK"
  },
  "package_manager_installation": {
    "explanation": "OK: No package managers or tooling are installed via apt/curl/npm/pip inside the Dockerfile. The selected olympus-base-jvm image provides the JVM toolchain already, so no redundant package-manager installation is present.",
    "status": "OK"
  },
  "registry_compliant": {
    "explanation": "OK: The base image is from the approved public.ecr.aws/d3j8x8q7 registry and matches the allowed olympus-base-jvm:latest image.",
    "status": "OK"
  },
  "repository_setup": {
    "explanation": "OK: WORKDIR is /app and the repository files are copied with COPY . .. The Dockerfile does not perform any git clone operations. This satisfies the requirement that the repo is provided to the build context and used from /app.",
    "status": "OK"
  },
  "security_safety": {
    "explanation": "OK: No external install scripts (curl|bash) are downloaded and executed, no obfuscated/base64-decoded commands are present, no host artifacts (docker.sock) are referenced, and no obvious secret or exfiltration patterns are present.",
    "status": "OK"
  },
  "user_creation_compatible": {
    "explanation": "OK: The Dockerfile does not create any user/group. Not creating a user is acceptable per the rubric.",
    "status": "OK"
  },
  "version_pinning": {
    "explanation": "warning: The Dockerfile enforces a pinned Gradle distribution by checking the distributionSha256Sum and verifying Gradle 9.7.1 (the grep checks). However, the Dockerfile cannot itself guarantee that the project's library dependencies are pinned — that depends on committed files in the repository such as gradle.lockfile, libs.versions.toml, or other lock manifests. Ensure the repository contains committed Gradle lockfiles or pinned version manifests (e.g., gradle.lockfile or a properly populated libs.versions.toml and any relevant lockfiles) so dependency resolution is reproducible.",
    "status": "warning"
  }
}
Close