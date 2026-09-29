# Test Quality
Verdict

FAIL
1 of 145 unfair
FAIL: 144 of 145 maintenance tests are fair, but `aDescriptionWithWindowsLineBreaksYieldsTheNameOfItsUnixSpelling` includes an LF index-key assertion that the prompt does not support and that conflicts with the explicit requirement that CRLF- and LF-differing descriptions remain separate entries. This is not a mere coverage issue: a solver following the new prompt could reasonably remove the old key normalization and fail that assertion. Advisory suite-wide concern: the symlink/hard-link group assumes a filesystem and permissions that support those links; the WatchService/subprocess/POSIX-permission tests additionally assume suitable platform facilities. These assumptions are understandable for the specified filesystem semantics but should be pinned in the benchmark environment. The explicitly tagged concurrency/watch tests also use fixed real-time waits and can be load-sensitive.

Unfair Tests

Not fair
aDescriptionWithWindowsLineBreaksYieldsTheNameOfItsUnixSpelling
Verifies: A CRLF description is stored under an LF index key, has the same filename as the LF description in another store, and remains readable by the CRLF rule.

Evidence: The same-filename part is stated (`each \r\n counting as \n`), but the LF index-key assertion is not and conflicts with `Entries whose rule descriptions differ only in their line breaks are still separate entries.` Refutation battery: searched the prompt for `\r\n`, `line breaks`, `separate entries`, and `counting as`; searched source/tests for `ensureUnixLineBreaks`, `getProperty`, and description keys. The old repo does normalize keys at `TextFileBasedViolationStore.java:258-271`, but a prompt-compliant alternative is to preserve the raw CRLF key (Java Properties supports escaped CR/LF, as the patch's manually seeded separate-key tests demonstrate). The prompt and old compatibility behavior therefore do not single out the asserted LF key.

Quality: The test mixes a fair derived-filename assertion with an unsupported/contradictory index-key form.

Requirement Coverage (12/13 covered)

Advisory only — prompt-stated requirements and whether the hidden tests pin them.

covered
The default file-naming mode is random and is used for new files.

"`default.fileNames` names new files and defaults to `random`."

absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone, randomFileNamesDeriveNothingSoNoEntryIsMisplaced, namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced

covered
Description names are deterministic, normalize CRLF for derivation, differ per rule, retain an eligible whole word, are ASCII-safe/bounded, and avoid the index name.

"With `description`, the name derives deterministically from the rule description, with each `\r\n` counting as `\n`. Names differ per rule and, when the description contains a whole word of 4 to 120 ASCII letters or digits, keep such a word, even one that comes late in a long description. Built-in names use only ASCII letters, digits, underscores and hyphens. They never exceed 200 characters and are never `stored.rules`."

aRuleKeepsTheSameNameInALaterRun, twoRulesReadingAlikeStillGetDifferentNames, aDescriptionWithWindowsLineBreaksYieldsTheNameOfItsUnixSpelling, aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt, aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName, namesTakenFromTheDescriptionNeverCollideWithTheIndex

covered
Configured custom strategies must implement the interface and have a public no-arg constructor.

"Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor."

aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves, aStrategyClassThatIsNotItselfPublicIsUsedThroughItsPublicNoArgumentConstructor, aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected, aStrategyThatCannotBeInstantiatedIsRejected

covered
Constructor strategies and configured strategies receive exact descriptions; configuration conflicts and no-name results are rejected.

"A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store, even as a default of the given `Properties`, is rejected. When a rule is stored, either kind of strategy is given its description exactly as it is, `\r\n` line breaks included. A strategy that yields no name is rejected as soon as a name is needed."

aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName, aStrategyGivenToTheConstructorIsRejectedWhenTheSettingComesFromDefaults, aNamingStrategyIsGivenTheRuleDescriptionUnchanged, aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore

covered
Integrity accepts exactly repair/fail/ignore, defaults to ignore, and rejects other values naming all accepted values.

"`default.integrity` accepts the exact values `repair`, `fail` and `ignore`, and defaults to `ignore`, which examines nothing. `repair` and `fail` examine the index and the folder while initializing. Any other value is rejected, naming the three accepted."

absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry, unknownValueIsRejectedAndNamesTheAcceptedValues, valuesNearAnAcceptedValueAreRejected

covered
Broken, resolved, misplaced, and occupied conditions follow the stated path/content/derivation rules.

"An entry is broken when its resolved path is not a regular file directly in the folder, including when its name is not a valid path at all. An entry is resolved when the file its name leads to yields no violations, as a file of line breaks alone (`\n`, `\r\n` or a lone `\r`) does. A carriage return inside a stored violation stays part of that violation's text. An entry is misplaced when its name is not its rule's derived one. A misplaced entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder. An entry that already records its derived name is never occupied."

anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne, aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks, carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved, anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved, anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs

partial
Sharing, collision, unowned classification, precedence, and line-break-distinct entry identity follow the stated rules.

"Entries recording the same name are shared, even if nothing exists under it. Entries whose names reach the same file are shared too, including through a symbolic or hard link and when that file is outside the folder. Entries whose rules derive one name are colliding. Apart from the index, a regular file directly in the folder that no entry's name leads to, directly or through a symbolic link, is unowned. The store leaves shared entries and unowned files alone and never moves a colliding or occupied entry, though it still discards one that is broken or resolved. An entry both shared and something else stays shared. Entries whose rule descriptions differ only in their line breaks are still separate entries."

aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded, twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded, twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded, twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved, anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded, entriesWhoseRuleDescriptionsDifferOnlyInTheirLineBreaksAreRepairedEachOnItsOwn

covered
Repair discards broken/resolved entries, deletes resolved files, moves movable misplaced files and their targets, and writes index only after entry changes.

"`repair` discards broken entries. It discards resolved entries with the files they name, deleting a link's target with the link. It moves a misplaced entry's file to its derived name, moving a link's target rather than the link. It writes the index only when an entry changed. `repair` needs `default.allowStoreUpdate` and is rejected without it."

anEntryWhoseFileIsAbsentIsBroken, aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt, aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt, aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical, repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore

covered
Fail is non-mutating, reports every condition with the stated global and within-condition ordering, and does not require update permission.

"`fail` changes nothing, rejecting initialization unless the index and folder agree, and a rejection does not even create an absent index. Its report names every entry in any condition and every unowned file. It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it. Within a condition it orders entries by rule description and files by name. `fail` does not need `default.allowStoreUpdate`."

failWithSeveralConditionsAtOnceChangesNotOneByte, failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne, failNamesTheConditionsInTheStatedOrder, failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName, failOrdersCollidingEntriesByRuleDescription, failWithoutPermissionToUpdateStillReportsTheInconsistency

covered
Index validation happens before examination, while the store folder itself may be symlinked.

"An absent index without `default.allowStoreCreation`, or one not a regular file directly in the folder, is rejected before anything is examined. The folder itself may be reached through a link."

anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined, anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined, aStoreFolderReachedThroughALinkIsMaintainedAndStoredInLikeAnyOther

covered
Saves write through owned names/links but reject index aliases, non-direct paths, and unowned targets atomically.

"Storing a rule writes its violations to the file its entry's name leads to, even through a symbolic link. The store rejects that write, leaving the index and the folder as they were, if the name leads to the index (under any spelling or through a symbolic or hard link), leads anywhere but directly into the folder, or names something the rule's own entry does not record."

storingAStillViolatedRuleWritesThroughTheLinkItsEntryRecords, storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected, storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected, storingARuleNeverWritesOverAFileTheStoreDoesNotOwn

covered
Repair-mode empty saves forget known rules with correct shared/deletion/failure behavior, do nothing for unknown rules, and nonempty saves retain entries.

"Under `repair`, saving no violations for a known rule forgets that rule instead. Its entry is removed, and so is its file unless another entry shares that file. A shared file is kept and only the entry removed, even when that entry's name leads outside the folder. Under `repair`, saving no violations for an unknown rule stores nothing. If the file cannot be deleted, the save is rejected and the entry stays. A rule with violations keeps its entry."

storingNoViolationsUnderRepairForgetsTheEntryAndItsFile, forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside, forgettingARuleKeepsTheFileAnotherEntryStillRecords, forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry, forgettingARuleTheIndexNeverKnewStoresNothingForIt, aStillViolatedRuleKeepsItsEntryUnderRepair

covered
Concurrent initialization/save operations leave a readable, survivor-only store and hide in-progress saves from examination.

"Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress."

concurrentInitializationsLeaveAReadableIndex, examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave, oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind, repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved, concurrentRepairAndFailLeaveAReadableIndex

Coverage Suggestions (1)

Advisory only — these don't affect the check result.

Saving line-break-distinct descriptions
not discriminating
Prompt-stated
Requirement: Entries whose rule descriptions differ only in their line breaks are still separate entries.

Add a test that saves both `two\r\nlines` and `two\nlines` through the public API and asserts two distinct index entries remain addressable. A shortcut that preserves the old `ensureUnixLineBreaks` key normalization currently passes the maintenance-only separate-entry test, and the existing CRLF naming test actually expects the normalized LF key.

Quality Notes (144)

Prompt-stated
absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Directly distinguishes the default from repair.

Prompt-stated
ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry
Direct black-box state check.

Prompt-stated
ignoreExaminesNothingSoRepairStillFindsEveryCondition
Strong combined-condition test with all co-assertions grounded.

Prompt-stated
unknownValueIsRejectedAndNamesTheAcceptedValues
Substring matching checks only explicitly required report content.

Prompt-stated
valuesNearAnAcceptedValueAreRejected
Good boundary coverage.

Prompt-stated
failAcceptsAConsistentStoreAndRejectsAnInconsistentOne
Direct positive and negative cases.

Prompt-stated
repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne
Direct control and repair case.

Prompt-stated
anEntryWhoseFileIsAbsentIsBroken
Canonical broken-entry case.

Prompt-stated
everyBrokenEntryIsDiscarded
Guards against stopping after the first finding.

Prompt-stated
anEntryRecordingADirectoryIsBroken
Good non-regular-file edge case.

Prompt-stated
anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched
Checks both classification and non-mutation.

Prompt-stated
anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives
Covers two absolute-path spellings.

Prompt-stated
anEntryRecordingANestedNameIsBrokenAndThatFileSurvives
Direct nested-path boundary.

Prompt-stated
anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne
Strong invalid-path robustness case.

Prompt-stated
entriesWhoseRuleDescriptionsDifferOnlyInTheirLineBreaksAreRepairedEachOnItsOwn
Directly discriminates independent identity.

Prompt-stated
entriesWhoseRulesDifferOnlyInWindowsAndUnixLineBreaksDeriveOneNameAndCollide
Correctly combines identity with derivation collision.

Prompt-stated
anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken
Good path-normalization case.

Prompt-stated
anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives
Correct symlink boundary case.

Prompt-stated
anEntryNamingALinkToAFileInTheStoreOwnsThatFile
Direct alias-ownership case.

Prompt-stated
aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget
Tests the exact object-type boundary.

Prompt-stated
anEntryNamingADanglingLinkIsBroken
Direct dangling-link case.

Prompt-stated
anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile
Canonical resolved-entry case.

Prompt-stated
aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt
Checks both target and link removal.

Prompt-stated
aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry
Good positive control.

Prompt-stated
aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks
Covers all stated line-break forms.

Prompt-stated
carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved
Strong round-trip and maintenance check.

Prompt-stated
aStoredViolationHoldingABackslashBeforeACarriageReturnIsReadAsItWasStored
Useful escape-sequence regression case.

Prompt-stated
anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs
Direct classification contrast.

Prompt-stated
aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded
Direct precedence test.

Prompt-stated
twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded
Covers both in-folder and outside targets.

Prompt-stated
twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded
Direct hard-link identity case.

Prompt-stated
aSharedNameHoldingNoViolationsIsNotDiscardedEither
Comprehensive precedence matrix.

Prompt-stated
failNamesSharedEntriesAndChangesNothing
Direct report/state check.

Prompt-stated
anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair
Important condition-precedence test.

Prompt-stated
anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded
Direct unowned preservation case.

Prompt-stated
failNamesUnownedFilesAndChangesNothing
Direct report check.

Prompt-stated
aDirectoryInTheStoreFolderIsNeverACondition
Good object-type contrast.

Prompt-stated
aFileInsideADirectoryInTheStoreFolderIsNeverACondition
Checks report exclusion and non-mutation.

Prompt-stated
theIndexItselfIsNeverUnowned
Direct special-file case.

Prompt-stated
aSecondInitializationOfARepairedFolderDiscardsNothing
Useful idempotence check.

Prompt-stated
anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled
Good idempotence plus alias precedence.

Prompt-stated
aRepairedFolderPassesAFailingCheck
Cross-mode integration check.

Prompt-stated
aSeparatelyCreatedStoreObservesTheRepairedIndex
Checks durable, not merely in-memory, repair.

Prompt-stated
aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord
Direct final-layout assertion.

Prompt-stated
concurrentInitializationsLeaveAReadableIndex
Concurrent black-box result is appropriate.

timing
Prompt-stated
concurrentRepairsOfAMisplacedEntryLeaveItOnItsMovedFile
Deterministic latches help, but fixed waits/joins can fail under load.

timing
Prompt-stated
examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave
Precisely exercises the required exclusion window, but uses two-second liveness checks.

timing
Prompt-stated
oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind
Accepting both serial outcomes avoids over-constraining ordering; waits remain timing-sensitive.

timing
Prompt-stated
repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved
Strong atomicity scenario; fixed wait is load-sensitive.

timing
Prompt-stated
repairingTheFolderWhileAnotherStoreSavesIntoAnEmptiedFileKeepsTheEntryAndTheFile
Good race regression; fixed wait is load-sensitive.

timing
Prompt-stated
concurrentRepairAndFailLeaveAReadableIndex
Broad concurrency stress, with a 30-second timeout.

timing
Prompt-stated
repairWithoutPermissionToUpdateIsRejectedAndChangesNothing
Checks rejection atomicity.

Prompt-stated
repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore
Important qualifier test.

Prompt-stated
failWithoutPermissionToUpdateStillReportsTheInconsistency
Direct permission contrast.

Prompt-stated
anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined
Checks precedence and later recovery.

Prompt-stated
failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne
WatchService checks the unusually strong 'even transiently' requirement.

timing
Prompt-stated
anIndexThatIsALinkOutOfTheStoreFolderIsRejectedAndItsTargetSurvives
Direct index-safety case.

Prompt-stated
anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined
Checks precedence and no mutation.

Prompt-stated
aStoreFolderReachedThroughALinkIsMaintainedAndStoredInLikeAnyOther
Comprehensive folder-link integration case.

Prompt-stated
anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired
The name says unreadable, but the actual setup is the explicitly covered directory case.

Prompt-stated
failNamesTheConditionsInTheStatedOrder
Uses relative token positions rather than exact formatting.

Prompt-stated
failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName
Direct order discrimination.

Prompt-stated
failOrdersSharedEntriesByRuleDescription
Good alternate-order setup.

Prompt-stated
failOrdersMisplacedEntriesByRuleDescription
Direct ordering test.

Prompt-stated
failOrdersCollidingEntriesByRuleDescription
Correctly isolates within-condition ordering.

Prompt-stated
failOrdersOccupiedEntriesByRuleDescription
Strong discrimination against the plausible wrong sort key.

Prompt-stated
failOrdersMisplacedEntriesByRuleDescriptionAndNotByTheirDerivedNames
Nonredundant wrong-key control.

Prompt-stated
failWithSeveralConditionsAtOnceChangesNotOneByte
Strong atomic non-mutation check.

Repo-discoverable
aRuleWhoseEntryWasDiscardedIsNoLongerFrozen
Appropriate API-level consequence.

Prompt-stated
repairKeepsAStillViolatingRuleFrozenWithItsViolations
Good integration consequence.

Prompt-stated
aRepairedStoreCanFreezeARuleAgain
Direct reuse-after-repair integration.

Repo-discoverable
aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation
Valid end-to-end integration test.

Prompt-stated
randomFileNamesDeriveNothingSoNoEntryIsMisplaced
Tests the maintenance consequence of random naming.

Prompt-stated
namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced
Explicit/default parity check.

Prompt-stated
aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName
Covers maintenance and save integration.

Prompt-stated
aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing
Direct conflict check.

Prompt-stated
aStrategyGivenToTheConstructorIsRejectedWhenTheSettingComesFromDefaults
Important Java Properties edge case.

Prompt-stated
aStrategyGivenToTheConstructorYieldingNoNameIsRejectedWhileExaminingAConsistentStore
Covers both no-name representations and modes.

Prompt-stated
absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone
All pinned filename properties are explicit.

Prompt-stated
aConfiguredStrategyNamesNewlyStoredRules
Direct configured-strategy save case.

Prompt-stated
aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves
Direct constructor-contract case.

Prompt-stated
aStrategyClassThatIsNotItselfPublicIsUsedThroughItsPublicNoArgumentConstructor
Useful guard against adding an unstated public-class restriction.

Prompt-stated
aNamingStrategyIsGivenTheRuleDescriptionUnchanged
Direct callback-observation test.

Prompt-stated
aStrategyThatCannotBeInstantiatedIsRejected
Direct invalid-class case.

Prompt-stated
aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected
Good reflection-contract coverage.

Prompt-stated
aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore
Configured counterpart to constructor-strategy test.

Prompt-stated
aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore
Strong laziness and atomicity check.

Prompt-stated
anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved
Canonical misplaced repair.

Prompt-stated
aMisplacedEntryKeepsItsViolationsAfterTheMove
Valid content-preservation consequence.

Prompt-stated
aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt
Exact link-move semantics.

Prompt-stated
failNamesMisplacedEntriesAndChangesNothing
Direct fail counterpart.

Prompt-stated
aDerivedNameLeavingTheStoreFolderIsNeverUsed
Covers relative and rooted unsafe derivations.

Prompt-stated
twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved
Canonical collision case.

Prompt-stated
aDerivedNameAnUnownedFileOccupiesIsNotTakenOver
Direct unowned occupant case.

Prompt-stated
aDerivedNameALinkOutOfTheStoreFolderOccupiesIsNotTakenOver
Alias occupant edge case.

Prompt-stated
aDerivedNameADanglingLinkOccupiesIsNotTakenOver
Direct dangling-occupant case.

Prompt-stated
aDerivedNameALinkToTheEntrysOwnFileOccupiesIsNotTakenOver
Discriminates recorded-name identity from target identity.

Prompt-stated
aDerivedNameADirectoryOccupiesIsNotTakenOver
Good non-file occupant case.

Prompt-stated
aDerivedNameEqualToTheIndexIsOccupiedAndNeverMovedOver
Important index protection case.

Prompt-stated
twoEntriesThatWouldSwapNamesAreNotMoved
Strong mutual-occupation case.

Prompt-stated
failNamesBothCollidingRulesEvenWhenOneAlreadyRecordsTheDerivedName
Important collision-membership edge.

Prompt-stated
anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs
Precisely tests the exception.

Prompt-stated
failNamesCollidingEntriesAndChangesNothing
Direct collision report check.

Prompt-stated
brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName
Direct precedence assertion.

Prompt-stated
brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied
Good condition-precedence test.

Prompt-stated
aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt
Combines two explicit empty-path rules.

Prompt-stated
storingARuleNeverWritesOverAFileTheStoreDoesNotOwn
Checks retry atomicity.

Prompt-stated
storingASecondUnknownRuleNeverTakesOverTheFirstRulesFile
Direct inter-rule ownership test.

Prompt-stated
storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected
Covers all unsafe path forms.

Prompt-stated
storingAPreviouslyUnknownRuleNeverTakesOverADanglingLink
Direct dangling-path ownership check.

Prompt-stated
storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected
Strong existing-entry safety matrix.

Prompt-stated
storingARuleWhoseEntryRecordsADanglingLinkNeverCreatesTheFileItPointsAt
Good chained-link and recovery coverage.

Prompt-stated
storingAStillViolatedRuleWritesToItsOwnFileEvenWhenItsDerivedNameIsOccupied
Correctly distinguishes known from new naming.

Prompt-stated
storingAStillViolatedRuleWritesThroughTheLinkItsEntryRecords
Covers both integrity modes.

Prompt-stated
storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected
Complete alias matrix.

Prompt-stated
storingARuleNeverWritesOverTheIndex
Direct unknown-rule index case.

Repo-discoverable
storingNoViolationsUnderRepairForgetsTheEntryAndItsFile
Good mode contrast grounded by both prompt and existing behavior.

Repo-discoverable
onlyRepairForgetsAResolvedRuleWhileFailKeepsIt
Reasonable compatibility assertion.

Prompt-stated
forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside
Directly matches the explicit special case.

Prompt-stated
forgettingARuleKeepsTheFileAnotherEntryStillRecords
Tests sharing through different names.

Prompt-stated
forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile
Strong link-forgetting case.

Prompt-stated
forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry
Semantically strong, though it relies on POSIX permissions and optionally `setpriv`.

Prompt-stated
forgettingARuleTheIndexNeverKnewStoresNothingForIt
Direct unknown-rule case.

Prompt-stated
aStillViolatedRuleKeepsItsEntryUnderRepair
Direct nonempty counterpart.

Prompt-stated
namesTakenFromTheDescriptionShowTheRuleTheyStore
Direct readability property.

Prompt-stated
aRuleKeepsTheSameNameInALaterRun
Direct determinism test.

Prompt-stated
aRuleKeepsTheSameNameOnAnotherMachine
Good environmental-independence test; subprocess/JVM availability is an environment dependency.

Prompt-stated
aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds
Discriminates stateful collision suffixing.

Prompt-stated
twoRulesReadingAlikeStillGetDifferentNames
Strong collision-resistance sample.

Prompt-stated
aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName
Good sanitization stress case.

Prompt-stated
aLongWordAfterOnlyShortOnesStillYieldsABoundedName
Useful upper-bound case.

Prompt-stated
aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt
Covers alphabetic and numeric words.

Prompt-stated
aWordWorthKeepingSurvivesAnOverlongWordBeforeIt
Discriminates naive prefix truncation/token selection.

Prompt-stated
aWordWorthKeepingSurvivesAnOverlongWordAfterIt
Good trailing-overflow case.

Prompt-stated
aWordWorthKeepingSurvivesAnOverlongWordBeginningWithIt
Strong whole-word boundary test.

Prompt-stated
aDescriptionWithoutAnyPlainCharacterStillYieldsAStableName
Good fallback case.

Prompt-stated
aDescriptionOfOnlyNonAsciiCharactersStillYieldsAStableAsciiName
Direct Unicode fallback/collision case.

Prompt-stated
violationsAreReadBackFromANameTakenFromTheDescription
Valid naming/read integration.

Prompt-stated
anEntryRecordingALegacyNameIsMovedToTheNameTakenFromTheDescription
Direct migration scenario.

Prompt-stated
namesTakenFromTheDescriptionNeverCollideWithTheIndex
Direct reserved-name case.

Prompt-stated
aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical
Byte and timestamp checks distinguish rewriting identical content from no write.

Prompt-stated
aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex
Strong no-op-write check.

Prompt-stated
arepairThatChangesNothingLeavesTheIndexByteIdentical
Direct repeated-repair no-write test.

Prompt-stated
repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder
Important cache-coherence regression.

Task Summary

The task adds a configurable file-naming policy and an integrity-maintenance mode to TextFileBasedViolationStore. Naming defaults to random; description-based naming must be deterministic, ASCII-safe, bounded, non-index, distinct, CRLF-normalized for derivation, and preserve an eligible whole word. Custom strategies may come from the constructor or a configured implementation class and must receive the original description. Integrity defaults to ignore; repair mutates only the conditions the prompt says to repair and requires update permission, while fail reports all inconsistencies without mutation. Classification must account for broken/resolved/misplaced/occupied/shared/colliding entries and unowned files, including aliases, symbolic links, hard links, invalid paths, and outside-folder paths. Save operations must reject unsafe or unowned targets, repair-mode empty saves forget rules atomically, and initialization/save concurrency must leave a coherent store.

Completed in 335.4s

Hide raw output
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Saving line-break-distinct descriptions",
      "gapKind": "not_discriminating",
      "requirement": "Entries whose rule descriptions differ only in their line breaks are still separate entries.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Add a test that saves both `two\\r\\nlines` and `two\\nlines` through the public API and asserts two distinct index entries remain addressable. A shortcut that preserves the old `ensureUnixLineBreaks` key normalization currently passes the maintenance-only separate-entry test, and the existing CRLF naming test actually expects the normalized LF key."
    }
  ],
  "error": "",
  "executionTimeSeconds": 335.414472,
  "message": "1 test flagged as not fair.",
  "overall": "FAIL: 144 of 145 maintenance tests are fair, but `aDescriptionWithWindowsLineBreaksYieldsTheNameOfItsUnixSpelling` includes an LF index-key assertion that the prompt does not support and that conflicts with the explicit requirement that CRLF- and LF-differing descriptions remain separate entries. This is not a mere coverage issue: a solver following the new prompt could reasonably remove the old key normalization and fail that assertion. Advisory suite-wide concern: the symlink/hard-link group assumes a filesystem and permissions that support those links; the WatchService/subprocess/POSIX-permission tests additionally assume suitable platform facilities. These assumptions are understandable for the specified filesystem semantics but should be pinned in the benchmark environment. The explicitly tagged concurrency/watch tests also use fixed real-time waits and can be load-sensitive.",
  "requirements": [
    {
      "covered": "yes",
      "coveringTests": [
        "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
        "randomFileNamesDeriveNothingSoNoEntryIsMisplaced",
        "namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced"
      ],
      "requirement": "The default file-naming mode is random and is used for new files.",
      "sourceQuote": "`default.fileNames` names new files and defaults to `random`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aRuleKeepsTheSameNameInALaterRun",
        "twoRulesReadingAlikeStillGetDifferentNames",
        "aDescriptionWithWindowsLineBreaksYieldsTheNameOfItsUnixSpelling",
        "aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt",
        "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
        "namesTakenFromTheDescriptionNeverCollideWithTheIndex"
      ],
      "requirement": "Description names are deterministic, normalize CRLF for derivation, differ per rule, retain an eligible whole word, are ASCII-safe/bounded, and avoid the index name.",
      "sourceQuote": "With `description`, the name derives deterministically from the rule description, with each `\\r\\n` counting as `\\n`. Names differ per rule and, when the description contains a whole word of 4 to 120 ASCII letters or digits, keep such a word, even one that comes late in a long description. Built-in names use only ASCII letters, digits, underscores and hyphens. They never exceed 200 characters and are never `stored.rules`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves",
        "aStrategyClassThatIsNotItselfPublicIsUsedThroughItsPublicNoArgumentConstructor",
        "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected",
        "aStrategyThatCannotBeInstantiatedIsRejected"
      ],
      "requirement": "Configured custom strategies must implement the interface and have a public no-arg constructor.",
      "sourceQuote": "Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
        "aStrategyGivenToTheConstructorIsRejectedWhenTheSettingComesFromDefaults",
        "aNamingStrategyIsGivenTheRuleDescriptionUnchanged",
        "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore"
      ],
      "requirement": "Constructor strategies and configured strategies receive exact descriptions; configuration conflicts and no-name results are rejected.",
      "sourceQuote": "A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store, even as a default of the given `Properties`, is rejected. When a rule is stored, either kind of strategy is given its description exactly as it is, `\\r\\n` line breaks included. A strategy that yields no name is rejected as soon as a name is needed."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "unknownValueIsRejectedAndNamesTheAcceptedValues",
        "valuesNearAnAcceptedValueAreRejected"
      ],
      "requirement": "Integrity accepts exactly repair/fail/ignore, defaults to ignore, and rejects other values naming all accepted values.",
      "sourceQuote": "`default.integrity` accepts the exact values `repair`, `fail` and `ignore`, and defaults to `ignore`, which examines nothing. `repair` and `fail` examine the index and the folder while initializing. Any other value is rejected, naming the three accepted."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
        "carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved",
        "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
        "anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs"
      ],
      "requirement": "Broken, resolved, misplaced, and occupied conditions follow the stated path/content/derivation rules.",
      "sourceQuote": "An entry is broken when its resolved path is not a regular file directly in the folder, including when its name is not a valid path at all. An entry is resolved when the file its name leads to yields no violations, as a file of line breaks alone (`\\n`, `\\r\\n` or a lone `\\r`) does. A carriage return inside a stored violation stays part of that violation's text. An entry is misplaced when its name is not its rule's derived one. A misplaced entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder. An entry that already records its derived name is never occupied."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
        "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "entriesWhoseRuleDescriptionsDifferOnlyInTheirLineBreaksAreRepairedEachOnItsOwn"
      ],
      "requirement": "Sharing, collision, unowned classification, precedence, and line-break-distinct entry identity follow the stated rules.",
      "sourceQuote": "Entries recording the same name are shared, even if nothing exists under it. Entries whose names reach the same file are shared too, including through a symbolic or hard link and when that file is outside the folder. Entries whose rules derive one name are colliding. Apart from the index, a regular file directly in the folder that no entry's name leads to, directly or through a symbolic link, is unowned. The store leaves shared entries and unowned files alone and never moves a colliding or occupied entry, though it still discards one that is broken or resolved. An entry both shared and something else stays shared. Entries whose rule descriptions differ only in their line breaks are still separate entries."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
        "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt",
        "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
        "repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore"
      ],
      "requirement": "Repair discards broken/resolved entries, deletes resolved files, moves movable misplaced files and their targets, and writes index only after entry changes.",
      "sourceQuote": "`repair` discards broken entries. It discards resolved entries with the files they name, deleting a link's target with the link. It moves a misplaced entry's file to its derived name, moving a link's target rather than the link. It writes the index only when an entry changed. `repair` needs `default.allowStoreUpdate` and is rejected without it."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "failWithSeveralConditionsAtOnceChangesNotOneByte",
        "failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne",
        "failNamesTheConditionsInTheStatedOrder",
        "failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName",
        "failOrdersCollidingEntriesByRuleDescription",
        "failWithoutPermissionToUpdateStillReportsTheInconsistency"
      ],
      "requirement": "Fail is non-mutating, reports every condition with the stated global and within-condition ordering, and does not require update permission.",
      "sourceQuote": "`fail` changes nothing, rejecting initialization unless the index and folder agree, and a rejection does not even create an absent index. Its report names every entry in any condition and every unowned file. It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it. Within a condition it orders entries by rule description and files by name. `fail` does not need `default.allowStoreUpdate`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined",
        "anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined",
        "aStoreFolderReachedThroughALinkIsMaintainedAndStoredInLikeAnyOther"
      ],
      "requirement": "Index validation happens before examination, while the store folder itself may be symlinked.",
      "sourceQuote": "An absent index without `default.allowStoreCreation`, or one not a regular file directly in the folder, is rejected before anything is examined. The folder itself may be reached through a link."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingAStillViolatedRuleWritesThroughTheLinkItsEntryRecords",
        "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected",
        "storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected",
        "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn"
      ],
      "requirement": "Saves write through owned names/links but reject index aliases, non-direct paths, and unowned targets atomically.",
      "sourceQuote": "Storing a rule writes its violations to the file its entry's name leads to, even through a symbolic link. The store rejects that write, leaving the index and the folder as they were, if the name leads to the index (under any spelling or through a symbolic or hard link), leads anywhere but directly into the folder, or names something the rule's own entry does not record."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
        "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
        "aStillViolatedRuleKeepsItsEntryUnderRepair"
      ],
      "requirement": "Repair-mode empty saves forget known rules with correct shared/deletion/failure behavior, do nothing for unknown rules, and nonempty saves retain entries.",
      "sourceQuote": "Under `repair`, saving no violations for a known rule forgets that rule instead. Its entry is removed, and so is its file unless another entry shares that file. A shared file is kept and only the entry removed, even when that entry's name leads outside the folder. Under `repair`, saving no violations for an unknown rule stores nothing. If the file cannot be deleted, the save is rejected and the entry stays. A rule with violations keeps its entry."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "concurrentInitializationsLeaveAReadableIndex",
        "examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave",
        "oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind",
        "repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved",
        "concurrentRepairAndFailLeaveAReadableIndex"
      ],
      "requirement": "Concurrent initialization/save operations leave a readable, survivor-only store and hide in-progress saves from examination.",
      "sourceQuote": "Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress."
    }
  ],
  "taskSummary": "The task adds a configurable file-naming policy and an integrity-maintenance mode to TextFileBasedViolationStore. Naming defaults to random; description-based naming must be deterministic, ASCII-safe, bounded, non-index, distinct, CRLF-normalized for derivation, and preserve an eligible whole word. Custom strategies may come from the constructor or a configured implementation class and must receive the original description. Integrity defaults to ignore; repair mutates only the conditions the prompt says to repair and requires update permission, while fail reports all inconsistencies without mutation. Classification must account for broken/resolved/misplaced/occupied/shared/colliding entries and unowned files, including aliases, symbolic links, hard links, invalid paths, and outside-folder paths. Save operations must reject unsafe or unowned targets, repair-mode empty saves forget rules atomically, and initialization/save concurrency must leave a coherent store.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The prompt says integrity defaults to `ignore`, which examines nothing, and `repair` discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Directly distinguishes the default from repair.",
      "verifies": "With no integrity property, the broken index entry remains; a later repair removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says `ignore` examines nothing and `repair` discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Direct black-box state check.",
      "verifies": "Explicit `ignore` preserves a broken entry; repair subsequently removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines ignore, repair actions, shared/unowned preservation, occupied non-movement, and content-preserving moves.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Strong combined-condition test with all co-assertions grounded.",
      "verifies": "Ignore preserves every byte and file; later repair removes broken/resolved entries, preserves shared/unowned/occupied entries, moves the movable misplaced entry, and preserves contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt says every other integrity value is rejected, naming the three accepted values.",
      "fairness": "Prompt-stated",
      "name": "unknownValueIsRejectedAndNamesTheAcceptedValues",
      "qualityCheck": "Substring matching checks only explicitly required report content.",
      "verifies": "`prune` throws a RuntimeException whose message contains `ignore`, `repair`, and `fail`."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the exact values are `repair`, `fail`, and `ignore`.",
      "fairness": "Prompt-stated",
      "name": "valuesNearAnAcceptedValueAreRejected",
      "qualityCheck": "Good boundary coverage.",
      "verifies": "Case changes, whitespace, suffixes, and related words are rejected."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail rejects unless index and folder agree, reports every conditioned entry, and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failAcceptsAConsistentStoreAndRejectsAnInconsistentOne",
      "qualityCheck": "Direct positive and negative cases.",
      "verifies": "Fail initializes a consistent store, rejects a broken entry while naming its rule, and leaves the index unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards broken entries and writes only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Direct control and repair case.",
      "verifies": "Repair preserves a consistent entry/file and removes a broken entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines an entry as broken when its resolved path is not a regular file directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "Canonical broken-entry case.",
      "verifies": "Repair drops the absent-file entry and keeps the present-file entry and file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards broken entries, without a one-entry limitation.",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Guards against stopping after the first finding.",
      "verifies": "All three absent-file entries are removed while a healthy entry remains."
    },
    {
      "concerns": [],
      "evidence": "A directory is not a regular file; repair discards the broken entry, while only the named resolved files are specified for deletion.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "Good non-regular-file edge case.",
      "verifies": "The directory-recording entry is removed, but the directory itself remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the resolved file to be directly in the folder and repeatedly forbids touching outside targets.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Checks both classification and non-mutation.",
      "verifies": "A `../` entry is removed and the outside file and its contents survive."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a regular file directly in the folder and says broken repair discards entries, not outside files.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "Covers two absolute-path spellings.",
      "verifies": "Absolute entries are removed; both the outside absolute target and an in-folder file merely sharing the last path component survive."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the resolved file to be directly in the store folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Direct nested-path boundary.",
      "verifies": "A nested-path entry is removed while the nested file remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt expressly includes names that are not valid paths in broken entries and defines fail/repair effects.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Strong invalid-path robustness case.",
      "verifies": "Fail reports the NUL-name rule without corrupting state; repair removes only it, preserves healthy bytes, and leaves the result fail-clean."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries whose rule descriptions differ only in line breaks are still separate entries.",
      "fairness": "Prompt-stated",
      "name": "entriesWhoseRuleDescriptionsDifferOnlyInTheirLineBreaksAreRepairedEachOnItsOwn",
      "qualityCheck": "Directly discriminates independent identity.",
      "verifies": "Of CRLF- and LF-keyed entries, repair removes only the broken one; the LF entry and violation remain independently readable."
    },
    {
      "concerns": [],
      "evidence": "The prompt says CRLF counts as LF for description-derived names, different descriptions remain separate entries, and colliding entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "entriesWhoseRulesDifferOnlyInWindowsAndUnixLineBreaksDeriveOneNameAndCollide",
      "qualityCheck": "Correctly combines identity with derivation collision.",
      "verifies": "Description naming reports both CRLF/LF rules under fail and repair moves neither, retaining both files and entries."
    },
    {
      "concerns": [],
      "evidence": "Brokenness is defined by the resolved path, which here is a regular file directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "Good path-normalization case.",
      "verifies": "A `./name` entry survives repair, its file content remains, and violations are readable through that spelling."
    },
    {
      "concerns": [],
      "evidence": "The prompt classifies by resolved path and forbids touching outside files.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Correct symlink boundary case.",
      "verifies": "Repair removes the outside-link entry without altering the target; the repaired store passes fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines ownership by where an entry name leads, including through a symbolic link.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Direct alias-ownership case.",
      "verifies": "An in-folder symlink entry survives repair, owns its target for unowned classification, and passes fail."
    },
    {
      "concerns": [],
      "evidence": "Unowned items are restricted to regular files directly in the folder; a symlink itself is not such a regular file.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Tests the exact object-type boundary.",
      "verifies": "A stray symlink and outside target survive repair and do not make fail reject."
    },
    {
      "concerns": [],
      "evidence": "A dangling link does not resolve to a regular file directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "Direct dangling-link case.",
      "verifies": "Repair removes an entry naming a dangling symlink."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines no-violation files as resolved and says repair discards resolved entries with their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Canonical resolved-entry case.",
      "verifies": "Repair removes an empty-file entry and deletes that file, leaving only the index."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says deleting a resolved link deletes the link's target with the link.",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Checks both target and link removal.",
      "verifies": "Repair removes the resolved entry, symlink, and in-folder target, then fail accepts the store."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a file of line breaks alone yields no violations.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Good positive control.",
      "verifies": "A LF-only file and entry are removed; a nonempty violation entry remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly lists `\\n`, `\\r\\n`, and lone `\\r` as line breaks that alone resolve an entry.",
      "fairness": "Prompt-stated",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Covers all stated line-break forms.",
      "verifies": "CRLF-only, CR-only, and LF-only entries/files are removed; a file with text plus CRLF remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt says carriage returns inside a violation stay part of its text, while line-break-only files are resolved.",
      "fairness": "Prompt-stated",
      "name": "carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved",
      "qualityCheck": "Strong round-trip and maintenance check.",
      "verifies": "Embedded CR and CRLF survive save/read before and after repair, while a line-break-only legacy entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a carriage return inside stored violation text to remain part of that text; repository storage semantics already use backslash escaping only for LF (`TextFileBasedViolationStore.java:164-170`).",
      "fairness": "Prompt-stated",
      "name": "aStoredViolationHoldingABackslashBeforeACarriageReturnIsReadAsItWasStored",
      "qualityCheck": "Useful escape-sequence regression case.",
      "verifies": "Repair preserves the legacy file byte-for-byte; reading returns the backslash-plus-CR violation and `plain` separately."
    },
    {
      "concerns": [],
      "evidence": "Resolved means the file yields no violations.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Direct classification contrast.",
      "verifies": "Repair keeps the one-violation entry/file and removes the empty one."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries recording the same name are shared even if nothing exists, and shared entries are left alone.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Direct precedence test.",
      "verifies": "Two entries recording the same empty file both survive repair; only an unrelated broken entry is dropped."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly defines sharing by reaching the same file, including symbolic links and outside files.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Covers both in-folder and outside targets.",
      "verifies": "Symlink aliases to one in-folder file and aliases to one outside file are shared; all such entries/links/targets survive while unrelated broken entries are removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly includes hard links in shared-entry detection and gives shared precedence over resolved.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Direct hard-link identity case.",
      "verifies": "Fail names both hard-link aliases; repair retains both empty-file entries and both names."
    },
    {
      "concerns": [],
      "evidence": "The prompt says shared-plus-anything stays shared, and colliding/occupied entries are not moved.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Comprehensive precedence matrix.",
      "verifies": "Across plain, colliding-derived, and occupied-derived stores, shared empty entries survive while lone resolved/broken entries are removed and occupants remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail reports shared entries and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesSharedEntriesAndChangesNothing",
      "qualityCheck": "Direct report/state check.",
      "verifies": "Fail reports both shared rules and preserves index/file state."
    },
    {
      "concerns": [],
      "evidence": "The prompt expressly says an entry both shared and something else stays shared, even if nothing exists under the shared name.",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Important condition-precedence test.",
      "verifies": "Both entries sharing a missing name survive repair; only the lone broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair leaves unowned files alone.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Direct unowned preservation case.",
      "verifies": "Repair drops a broken entry but keeps an unowned file and its contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail reports every unowned file and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesUnownedFilesAndChangesNothing",
      "qualityCheck": "Direct report check.",
      "verifies": "Fail reports `stray` and preserves all files."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines unowned only for regular files directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "aDirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Good object-type contrast.",
      "verifies": "A direct subdirectory does not make fail reject; a direct stray regular file does."
    },
    {
      "concerns": [],
      "evidence": "Unowned files must be directly in the folder, and broken repair does not authorize deleting nested unrelated files.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Checks report exclusion and non-mutation.",
      "verifies": "Fail reports a broken entry but not a buried file; repair preserves that buried file while removing the broken entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt excludes the index from unowned-file classification.",
      "fairness": "Prompt-stated",
      "name": "theIndexItselfIsNeverUnowned",
      "qualityCheck": "Direct special-file case.",
      "verifies": "A store containing only index plus an owned file passes fail; another rejects only for its broken entry."
    },
    {
      "concerns": [],
      "evidence": "After the first repair no stated condition remains; repair only changes conditioned entries.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Useful idempotence check.",
      "verifies": "A second repair preserves the already repaired entries and exact file-name set."
    },
    {
      "concerns": [],
      "evidence": "The prompt says same-target entries are shared, shared entries are left alone, and shared wins over other conditions.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Good idempotence plus alias precedence.",
      "verifies": "Link aliases make both entries shared, so neither is moved; repeated repair leaves entries/files/content unchanged."
    },
    {
      "concerns": [],
      "evidence": "Repair's specified changes restore agreement for this setup; fail accepts agreeing stores.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderPassesAFailingCheck",
      "qualityCheck": "Cross-mode integration check.",
      "verifies": "After repair removes broken/resolved entries, fail accepts and only the healthy entry remains."
    },
    {
      "concerns": [],
      "evidence": "Repair writes the index when an entry changes; repository `contains` reads index membership (`TextFileBasedViolationStore.java:143-146`).",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Checks durable, not merely in-memory, repair.",
      "verifies": "A new store instance sees the discarded rule as absent and the survivor as present."
    },
    {
      "concerns": [],
      "evidence": "The prompt specifies removal of broken entries and resolved entries/files for exactly this setup.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Direct final-layout assertion.",
      "verifies": "For a store with only healthy, broken, and resolved entries, repair leaves the index and healthy file, and maps the survivor correctly."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt says stores initializing concurrently leave a readable index and only survivors' files.",
      "fairness": "Prompt-stated",
      "name": "concurrentInitializationsLeaveAReadableIndex",
      "qualityCheck": "Concurrent black-box result is appropriate.",
      "verifies": "Four concurrent repairs all finish without failure and leave only the healthy entry/file."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt requires concurrent initialization coherence and repair's move-to-derived-name behavior.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairsOfAMisplacedEntryLeaveItOnItsMovedFile",
      "qualityCheck": "Deterministic latches help, but fixed waits/joins can fail under load.",
      "verifies": "Two overlapping repairs finish, retain one rule mapped to `derived`, preserve content, and yield a fail-clean store."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt says no store examines a save still in progress and concurrent operations leave coherent survivors.",
      "fairness": "Prompt-stated",
      "name": "examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave",
      "qualityCheck": "Precisely exercises the required exclusion window, but uses two-second liveness checks.",
      "verifies": "Repair and fail initializations remain blocked while save is held reading violations; all finish successfully and the saved rule/file/violation remain readable."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt requires coherent concurrent saves and repair-mode forgetting, allowing whichever operation wins.",
      "fairness": "Prompt-stated",
      "name": "oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind",
      "qualityCheck": "Accepting both serial outcomes avoids over-constraining ordering; waits remain timing-sensitive.",
      "verifies": "Overlapping save and forget complete without failure; either valid serial outcome is accepted, with no orphan file, and fail accepts afterward."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt says no examination observes an in-progress save and repair moves misplaced files to derived names.",
      "fairness": "Prompt-stated",
      "name": "repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved",
      "qualityCheck": "Strong atomicity scenario; fixed wait is load-sensitive.",
      "verifies": "Repair waits for held save, then moves the entry to its derived name with newly saved content; final reads and fail succeed."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt prohibits examination of an in-progress save and resolves only files yielding no violations.",
      "fairness": "Prompt-stated",
      "name": "repairingTheFolderWhileAnotherStoreSavesIntoAnEmptiedFileKeepsTheEntryAndTheFile",
      "qualityCheck": "Good race regression; fixed wait is load-sensitive.",
      "verifies": "Repair waits for the save and then sees a nonempty file, retaining its entry/file/content and producing a fail-clean store."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt requires concurrent initialization coherence and defines fail rejection versus repair mutation.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairAndFailLeaveAReadableIndex",
      "qualityCheck": "Broad concurrency stress, with a 30-second timeout.",
      "verifies": "Six concurrent repair/fail initializations finish; only expected RuntimeExceptions from fail are tolerated, and final index/files contain the healthy survivor."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair needs `default.allowStoreUpdate` and is rejected without it.",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedAndChangesNothing",
      "qualityCheck": "Checks rejection atomicity.",
      "verifies": "Repair with update disabled throws and leaves both healthy/broken entries and file set unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt unconditionally says repair needs update permission.",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore",
      "qualityCheck": "Important qualifier test.",
      "verifies": "Repair with update disabled throws even when no repair would be needed."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says fail does not need `default.allowStoreUpdate`.",
      "fairness": "Prompt-stated",
      "name": "failWithoutPermissionToUpdateStillReportsTheInconsistency",
      "qualityCheck": "Direct permission contrast.",
      "verifies": "Fail with update disabled still rejects and reports the broken rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an absent index without creation permission is rejected before anything is examined.",
      "fairness": "Prompt-stated",
      "name": "anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined",
      "qualityCheck": "Checks precedence and later recovery.",
      "verifies": "Repair/fail reject an absent index when creation is disabled, do not create it or report unowned files; after an index appears, repair works."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt explicitly says a fail rejection does not even create an absent index.",
      "fairness": "Prompt-stated",
      "name": "failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne",
      "qualityCheck": "WatchService checks the unusually strong 'even transiently' requirement.",
      "verifies": "Fail reports an unowned file but never creates `stored.rules`, even transiently; other bytes remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an index not a regular file directly in the folder is rejected before examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatIsALinkOutOfTheStoreFolderIsRejectedAndItsTargetSurvives",
      "qualityCheck": "Direct index-safety case.",
      "verifies": "Repair rejects an index symlink to outside and does not alter its target."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the index itself to be a regular file directly in the folder and rejection before examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined",
      "qualityCheck": "Checks precedence and no mutation.",
      "verifies": "Both repair/fail reject an in-folder index symlink without reporting other conditions or changing target/link/files."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says the folder itself may be reached through a link.",
      "fairness": "Prompt-stated",
      "name": "aStoreFolderReachedThroughALinkIsMaintainedAndStoredInLikeAnyOther",
      "qualityCheck": "Comprehensive folder-link integration case.",
      "verifies": "A symlinked store folder supports repair, save, fail, and reads while the folder alias remains a symlink and the real folder has correct entries/files."
    },
    {
      "concerns": [],
      "evidence": "The prompt rejects an index that is not a regular file directly in the folder before examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired",
      "qualityCheck": "The name says unreadable, but the actual setup is the explicitly covered directory case.",
      "verifies": "A directory at `stored.rules` makes repair/fail reject without changing bytes; an independent sound store is repaired normally."
    },
    {
      "concerns": [],
      "evidence": "The prompt states the report order: broken, resolved, shared, then unowned.",
      "fairness": "Prompt-stated",
      "name": "failNamesTheConditionsInTheStatedOrder",
      "qualityCheck": "Uses relative token positions rather than exact formatting.",
      "verifies": "Message token positions are broken rule, resolved rule, shared rule, then unowned file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries are ordered by rule description and files by name within a condition.",
      "fairness": "Prompt-stated",
      "name": "failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName",
      "qualityCheck": "Direct order discrimination.",
      "verifies": "Broken-rule names appear alpha before zulu, and unowned files alpha before zulu."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries within a condition are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersSharedEntriesByRuleDescription",
      "qualityCheck": "Good alternate-order setup.",
      "verifies": "Four shared entries appear in rule-description order, not recorded-file order."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires rule-description ordering within every condition.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescription",
      "qualityCheck": "Direct ordering test.",
      "verifies": "Misplaced entries appear alpha, mike, zulu."
    },
    {
      "concerns": [],
      "evidence": "The prompt permits the condition anywhere globally but still requires within-condition rule-description order.",
      "fairness": "Prompt-stated",
      "name": "failOrdersCollidingEntriesByRuleDescription",
      "qualityCheck": "Correctly isolates within-condition ordering.",
      "verifies": "Colliding entries appear alpha, mike, zulu."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries, not derived names, order by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersOccupiedEntriesByRuleDescription",
      "qualityCheck": "Strong discrimination against the plausible wrong sort key.",
      "verifies": "Occupied entries appear alpha, mike, zulu despite inverted derived-name order."
    },
    {
      "concerns": [],
      "evidence": "The prompt specifies rule-description ordering.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescriptionAndNotByTheirDerivedNames",
      "qualityCheck": "Nonredundant wrong-key control.",
      "verifies": "Misplaced entries sort by descriptions despite inverted derived names."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failWithSeveralConditionsAtOnceChangesNotOneByte",
      "qualityCheck": "Strong atomic non-mutation check.",
      "verifies": "A multi-condition fail rejection preserves the exact file list and every file byte."
    },
    {
      "concerns": [],
      "evidence": "Prompt requires index-entry discard; repository `contains` is exactly index-key membership at `TextFileBasedViolationStore.java:143-146`.",
      "fairness": "Repo-discoverable",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Appropriate API-level consequence.",
      "verifies": "After repair removes a resolved entry, a new store reports that rule absent."
    },
    {
      "concerns": [],
      "evidence": "Repair only discards broken/resolved entries here; repository read semantics preserve stored violations.",
      "fairness": "Prompt-stated",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Good integration consequence.",
      "verifies": "Repair leaves a healthy rule contained with its exact violation while removing a neighboring broken entry."
    },
    {
      "concerns": [],
      "evidence": "Repair removes entry and file; default random naming names new files, and baseline save semantics are visible at `TextFileBasedViolationStore.java:148-178`.",
      "fairness": "Prompt-stated",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Direct reuse-after-repair integration.",
      "verifies": "After resolved-entry repair, saving the rule creates a fresh entry/file, returns the new violation, and does not reuse the old `resolved` file name."
    },
    {
      "concerns": [],
      "evidence": "Repair discard is prompt-stated; first-time freezing stores and returns success at `FreezingArchRule.java:120-139`, also documented at `docs/userguide/008_The_Library_API.adoc:453-458`.",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Valid end-to-end integration test.",
      "verifies": "After repair empties the index, a real freezing evaluation reports no violation, re-adds the rule, and does not reuse the resolved file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the default random policy names new files; it does not derive replacement names for existing entries.",
      "fairness": "Prompt-stated",
      "name": "randomFileNamesDeriveNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Tests the maintenance consequence of random naming.",
      "verifies": "With absent fileNames setting, repair keeps an arbitrary healthy recorded name while removing a broken neighbor."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines `random` as the built-in policy for naming new files.",
      "fairness": "Prompt-stated",
      "name": "namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Explicit/default parity check.",
      "verifies": "Explicit random mode preserves an arbitrary recorded name under repair and passes fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a constructor strategy names files the same way and repair moves misplaced entries.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
      "qualityCheck": "Covers maintenance and save integration.",
      "verifies": "Constructor strategy moves a legacy entry/file to its derived name and names a newly saved rule the same way, preserving contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly rejects configuring `default.fileNames` for a constructor-strategy store.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing",
      "qualityCheck": "Direct conflict check.",
      "verifies": "Constructor strategy plus explicit fileNames property throws and preserves index/file state."
    },
    {
      "concerns": [],
      "evidence": "The prompt expressly includes a default of the given `Properties`.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorIsRejectedWhenTheSettingComesFromDefaults",
      "qualityCheck": "Important Java Properties edge case.",
      "verifies": "The same conflict is rejected when the property is inherited through `Properties` defaults, with byte-identical index."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a strategy yielding no name is rejected as soon as a name is needed; repair/fail need derived names to classify entries.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Covers both no-name representations and modes.",
      "verifies": "Null- and empty-yielding constructor strategies make repair and fail initialization throw without changing the store."
    },
    {
      "concerns": [],
      "evidence": "The prompt specifies random default, per-rule distinction, built-in character/length/index constraints, and repair behavior.",
      "fairness": "Prompt-stated",
      "name": "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
      "qualityCheck": "All pinned filename properties are explicit.",
      "verifies": "Default names for two rules are distinct, ASCII-safe, non-index, at most 200 chars; broken repair occurs, and later repair does not relocate random names."
    },
    {
      "concerns": [],
      "evidence": "The prompt says any other fileNames value denotes a strategy implementation that names files.",
      "fairness": "Prompt-stated",
      "name": "aConfiguredStrategyNamesNewlyStoredRules",
      "qualityCheck": "Direct configured-strategy save case.",
      "verifies": "A configured custom strategy writes the exact strategy-derived index value/file name."
    },
    {
      "concerns": [],
      "evidence": "The prompt specifies a public no-argument constructor and says the strategy names existing moves and new files.",
      "fairness": "Prompt-stated",
      "name": "aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves",
      "qualityCheck": "Direct constructor-contract case.",
      "verifies": "A configured strategy with explicit public no-arg constructor moves a legacy entry and names a new one, with exact derived entries/files/content."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the implementation and its constructor to satisfy the interface/public-no-arg conditions; it does not require the implementation class itself to be public.",
      "fairness": "Prompt-stated",
      "name": "aStrategyClassThatIsNotItselfPublicIsUsedThroughItsPublicNoArgumentConstructor",
      "qualityCheck": "Useful guard against adding an unstated public-class restriction.",
      "verifies": "A package-private implementation with a public no-arg constructor is instantiated and used for move/save naming."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says either kind of strategy is given the description exactly as it is, CRLF included.",
      "fairness": "Prompt-stated",
      "name": "aNamingStrategyIsGivenTheRuleDescriptionUnchanged",
      "qualityCheck": "Direct callback-observation test.",
      "verifies": "Constructor- and property-provided strategies each receive only the exact CRLF description; the expected file is created and violation reads back."
    },
    {
      "concerns": [],
      "evidence": "Only a fully qualified name of an implementation with the required constructor is accepted.",
      "fairness": "Prompt-stated",
      "name": "aStrategyThatCannotBeInstantiatedIsRejected",
      "qualityCheck": "Direct invalid-class case.",
      "verifies": "A nonexistent configured strategy class causes initialization to throw."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a RuleViolationFileNameStrategy implementation with a public no-argument constructor.",
      "fairness": "Prompt-stated",
      "name": "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected",
      "qualityCheck": "Good reflection-contract coverage.",
      "verifies": "Wrong type, missing no-arg constructor, and private no-arg constructor all throw and leave the store unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires rejection as soon as a needed name is absent.",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Configured counterpart to constructor-strategy test.",
      "verifies": "Configured null/empty strategies cause repair/fail initialization to throw without changing index/files."
    },
    {
      "concerns": [],
      "evidence": "The prompt says ignore examines nothing and a no-name result is rejected as soon as a name is needed.",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore",
      "qualityCheck": "Strong laziness and atomicity check.",
      "verifies": "Ignore does not invoke a null/empty strategy; save invokes it, throws, and leaves files/index/membership unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines misplaced entries and says repair moves their files to derived names.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
      "qualityCheck": "Canonical misplaced repair.",
      "verifies": "Repair rewrites the entry to the derived name, moves the file, and preserves its content."
    },
    {
      "concerns": [],
      "evidence": "Moving the entry's file necessarily preserves its stored violations; repair explicitly moves rather than recreates it.",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryKeepsItsViolationsAfterTheMove",
      "qualityCheck": "Valid content-preservation consequence.",
      "verifies": "After move, both violations read in order and the index records the derived name."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says moving a link moves its target rather than the link.",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt",
      "qualityCheck": "Exact link-move semantics.",
      "verifies": "Repair leaves a regular file, not a symlink, at the derived name; old target/link names disappear, content survives, and fail passes."
    },
    {
      "concerns": [],
      "evidence": "Fail reports every conditioned entry and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesMisplacedEntriesAndChangesNothing",
      "qualityCheck": "Direct fail counterpart.",
      "verifies": "Fail reports the misplaced rule and preserves recorded name/file."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines an escaping derived name as occupied and says occupied entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameLeavingTheStoreFolderIsNeverUsed",
      "qualityCheck": "Covers relative and rooted unsafe derivations.",
      "verifies": "Relative-escaping and absolute derived names do not cause movement or outside mutation; fail reports the inconsistency."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines colliding entries and says they are never moved and all conditioned entries are reported.",
      "fairness": "Prompt-stated",
      "name": "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
      "qualityCheck": "Canonical collision case.",
      "verifies": "Two entries deriving one constant name keep their legacy names/files under repair and both are reported by fail."
    },
    {
      "concerns": [],
      "evidence": "A derived name that already names something is occupied, and occupied entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameAnUnownedFileOccupiesIsNotTakenOver",
      "qualityCheck": "Direct unowned occupant case.",
      "verifies": "Repair preserves legacy mapping/content and the hand-written derived-name file; fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a derived name that already names something is occupied.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkOutOfTheStoreFolderOccupiesIsNotTakenOver",
      "qualityCheck": "Alias occupant edge case.",
      "verifies": "An outside-pointing link at the derived name blocks movement; outside and legacy contents survive; fail reports."
    },
    {
      "concerns": [],
      "evidence": "The prompt uses 'already names something', which includes a dangling directory entry.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADanglingLinkOccupiesIsNotTakenOver",
      "qualityCheck": "Direct dangling-occupant case.",
      "verifies": "A dangling symlink at the derived name blocks movement; legacy file remains and fail reports."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry already recording its derived name is never occupied; this entry records a different name, so the existing derived path occupies it.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkToTheEntrysOwnFileOccupiesIsNotTakenOver",
      "qualityCheck": "Discriminates recorded-name identity from target identity.",
      "verifies": "A distinct symlink at the derived name blocks movement even though it reaches the entry's own file; both remain and fail reports."
    },
    {
      "concerns": [],
      "evidence": "The prompt says occupied when the derived name already names something.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADirectoryOccupiesIsNotTakenOver",
      "qualityCheck": "Good non-file occupant case.",
      "verifies": "A directory at the derived name blocks movement and survives; legacy file remains and fail reports."
    },
    {
      "concerns": [],
      "evidence": "The index already occupies that derived name, and save/move safety expressly protects the index.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameEqualToTheIndexIsOccupiedAndNeverMovedOver",
      "qualityCheck": "Important index protection case.",
      "verifies": "A strategy deriving `stored.rules` leaves mapping/index/content unchanged; fail reports the entry."
    },
    {
      "concerns": [],
      "evidence": "Each derived name is recorded by another entry, making both occupied; occupied entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesThatWouldSwapNamesAreNotMoved",
      "qualityCheck": "Strong mutual-occupation case.",
      "verifies": "Both swapped mappings remain unchanged and fail reports both."
    },
    {
      "concerns": [],
      "evidence": "Rules deriving one name are colliding; the prompt does not exempt one already on that derived name.",
      "fairness": "Prompt-stated",
      "name": "failNamesBothCollidingRulesEvenWhenOneAlreadyRecordsTheDerivedName",
      "qualityCheck": "Important collision-membership edge.",
      "verifies": "Fail reports both colliding rules; repair moves neither and keeps all files, including the already-settled one."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says an entry already recording its derived name is never occupied and writes only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs",
      "qualityCheck": "Precisely tests the exception.",
      "verifies": "Fail reports beta but not alpha; repair rewrites no index byte and preserves all mappings/files/contents."
    },
    {
      "concerns": [],
      "evidence": "Fail reports every conditioned entry and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesCollidingEntriesAndChangesNothing",
      "qualityCheck": "Direct collision report check.",
      "verifies": "Fail reports both colliding entries and preserves the file set."
    },
    {
      "concerns": [],
      "evidence": "The prompt says colliding entries are not moved, though broken or resolved entries are still discarded.",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName",
      "qualityCheck": "Direct precedence assertion.",
      "verifies": "Broken/resolved colliders are removed with resolved files; only the still-violating colliding entry remains unmoved."
    },
    {
      "concerns": [],
      "evidence": "The prompt says occupied prevents movement but not broken/resolved discard.",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied",
      "qualityCheck": "Good condition-precedence test.",
      "verifies": "Broken/resolved occupied entries are removed, their hand-written occupants survive, and the healthy occupied entry remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt says names recorded by another entry occupy a derived name, and same-name entries are shared even if nothing exists.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt",
      "qualityCheck": "Combines two explicit empty-path rules.",
      "verifies": "Shared entries recording the derived name survive despite no file; they block moving another entry; broken neighbor is removed and fail reports the movable rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt rejects writes to something the rule's own entry does not record and requires unchanged index/folder.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn",
      "qualityCheck": "Checks retry atomicity.",
      "verifies": "Two attempts to save an unknown rule onto an unowned derived-name file throw and preserve exact index, file, content, and membership."
    },
    {
      "concerns": [],
      "evidence": "The target name is recorded by another entry, so the prompt requires rejecting the write unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingASecondUnknownRuleNeverTakesOverTheFirstRulesFile",
      "qualityCheck": "Direct inter-rule ownership test.",
      "verifies": "After first save under a constant strategy, second unknown-rule save throws; first mapping/file/content remain and no second entry/file appears."
    },
    {
      "concerns": [],
      "evidence": "The prompt rejects save targets anywhere but directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected",
      "qualityCheck": "Covers all unsafe path forms.",
      "verifies": "Relative escape, nested path, and absolute path saves throw; outside/nested contents survive, index stays empty, and no direct file is created."
    },
    {
      "concerns": [],
      "evidence": "The name already names something the unknown rule's entry does not record.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleNeverTakesOverADanglingLink",
      "qualityCheck": "Direct dangling-path ownership check.",
      "verifies": "A dangling link at the strategy name causes save rejection; the link and empty index remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt rejects writes leading to the index or anywhere but directly in the folder, leaving state unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected",
      "qualityCheck": "Strong existing-entry safety matrix.",
      "verifies": "Existing entries recording outside, index, and absolute names all reject writes; outside/local/index bytes remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "A dangling chain does not lead directly to an existing in-folder regular file, so the write is rejected unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsADanglingLinkNeverCreatesTheFileItPointsAt",
      "qualityCheck": "Good chained-link and recovery coverage.",
      "verifies": "Direct and chained dangling-link writes throw without creating the outside target or changing index; a safe neighboring rule can still save."
    },
    {
      "concerns": [],
      "evidence": "The prompt says storing writes to the file its entry's name leads to and rejects only names the rule's own entry does not record.",
      "fairness": "Prompt-stated",
      "name": "storingAStillViolatedRuleWritesToItsOwnFileEvenWhenItsDerivedNameIsOccupied",
      "qualityCheck": "Correctly distinguishes known from new naming.",
      "verifies": "A known rule writes its legacy owned file, not its occupied derived name; an unknown rule gets its own derived name; all contents/mappings are exact."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says storing writes through a symbolic link and defines ignore versus repair.",
      "fairness": "Prompt-stated",
      "name": "storingAStillViolatedRuleWritesThroughTheLinkItsEntryRecords",
      "qualityCheck": "Covers both integrity modes.",
      "verifies": "Under repair and ignore, save keeps the link mapping and writes target content; repair alone removes broken neighbor; reads and file sets are correct."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly protects the index under any spelling and through symbolic or hard links.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected",
      "qualityCheck": "Complete alias matrix.",
      "verifies": "Dot spelling, symlink, and hard-link aliases to the index all reject save and preserve index bytes."
    },
    {
      "concerns": [],
      "evidence": "The prompt forbids writes leading to the index.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverTheIndex",
      "qualityCheck": "Direct unknown-rule index case.",
      "verifies": "A custom strategy deriving `stored.rules` causes save rejection and leaves the index empty."
    },
    {
      "concerns": [],
      "evidence": "Repair behavior is explicit in the prompt. The contrasting ignore behavior preserves baseline save semantics: save always ensures an entry then writes the list at `TextFileBasedViolationStore.java:148-178`.",
      "fairness": "Repo-discoverable",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "Good mode contrast grounded by both prompt and existing behavior.",
      "verifies": "Repair-mode empty save removes entry/file; ignore-mode empty save retains the entry and returns an empty violation list."
    },
    {
      "concerns": [],
      "evidence": "The prompt singles out repair-mode forgetting; baseline non-repair save retains entries at `TextFileBasedViolationStore.java:148-178`.",
      "fairness": "Repo-discoverable",
      "name": "onlyRepairForgetsAResolvedRuleWhileFailKeepsIt",
      "qualityCheck": "Reasonable compatibility assertion.",
      "verifies": "Repair-mode empty save removes the entry; fail-mode empty save retains it."
    },
    {
      "concerns": [],
      "evidence": "The prompt says shared files are kept and only the entry removed, even when the name leads outside the folder.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Directly matches the explicit special case.",
      "verifies": "Repair-mode empty save removes only one of two shared outside-path entries and preserves the peer and outside bytes."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a shared file is kept and only the entry removed.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Tests sharing through different names.",
      "verifies": "Empty save removes only the forgotten alias entry; shared target/link remain, and the peer still reads its violation."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair removes the file unless shared and link deletion removes target with link.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
      "qualityCheck": "Strong link-forgetting case.",
      "verifies": "Empty save removes forgotten entry, link, and unshared target; peer remains readable."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says deletion failure rejects the save and keeps the entry.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "Semantically strong, though it relies on POSIX permissions and optionally `setpriv`.",
      "verifies": "When deletion is denied, empty save is rejected and entry/index/file/violation remain; once writable, retry removes entry/file."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says saving no violations for an unknown rule stores nothing under repair.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct unknown-rule case.",
      "verifies": "Repair-mode empty save for an unknown rule leaves empty index and only the index file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a rule with violations keeps its entry.",
      "fairness": "Prompt-stated",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Direct nonempty counterpart.",
      "verifies": "A nonempty repair-mode save retains the rule entry and replaces stored violations with exactly one item."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires an eligible whole word to be kept.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionShowTheRuleTheyStore",
      "qualityCheck": "Direct readability property.",
      "verifies": "Description mode creates a file name containing a whole eligible description word, and only index plus that file exist."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the name derives deterministically from the rule description.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameInALaterRun",
      "qualityCheck": "Direct determinism test.",
      "verifies": "The same description in two stores gets exactly the same description-derived name."
    },
    {
      "concerns": [],
      "evidence": "Deterministic derivation from description alone plus explicit character/length/word requirements imply this result.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameOnAnotherMachine",
      "qualityCheck": "Good environmental-independence test; subprocess/JVM availability is an environment dependency.",
      "verifies": "Separate JVMs with different machine/user/locale/encoding settings produce the same ASCII-safe, bounded name containing an eligible word."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the name derives deterministically from the description, not store state.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds",
      "qualityCheck": "Discriminates stateful collision suffixing.",
      "verifies": "A rule gets the same description-derived name in an empty and crowded store."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires names to differ per rule and retain an eligible word.",
      "fairness": "Prompt-stated",
      "name": "twoRulesReadingAlikeStillGetDifferentNames",
      "qualityCheck": "Strong collision-resistance sample.",
      "verifies": "Eight similar descriptions each get a distinct name containing an eligible whole word; exact files exist and each violation reads from the correct file."
    },
    {
      "concerns": [],
      "evidence": "The same-filename part is stated (`each \\r\\n counting as \\n`), but the LF index-key assertion is not and conflicts with `Entries whose rule descriptions differ only in their line breaks are still separate entries.` Refutation battery: searched the prompt for `\\r\\n`, `line breaks`, `separate entries`, and `counting as`; searched source/tests for `ensureUnixLineBreaks`, `getProperty`, and description keys. The old repo does normalize keys at `TextFileBasedViolationStore.java:258-271`, but a prompt-compliant alternative is to preserve the raw CRLF key (Java Properties supports escaped CR/LF, as the patch's manually seeded separate-key tests demonstrate). The prompt and old compatibility behavior therefore do not single out the asserted LF key.",
      "fairness": "Not fair",
      "name": "aDescriptionWithWindowsLineBreaksYieldsTheNameOfItsUnixSpelling",
      "qualityCheck": "The test mixes a fair derived-filename assertion with an unsupported/contradictory index-key form.",
      "verifies": "A CRLF description is stored under an LF index key, has the same filename as the LF description in another store, and remains readable by the CRLF rule."
    },
    {
      "concerns": [],
      "evidence": "All three properties are explicit built-in naming requirements.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
      "qualityCheck": "Good sanitization stress case.",
      "verifies": "A punctuation/long description gets an ASCII-safe name no longer than 200 containing an eligible whole word."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires keeping an eligible word even late in a long description, with 120 included.",
      "fairness": "Prompt-stated",
      "name": "aLongWordAfterOnlyShortOnesStillYieldsABoundedName",
      "qualityCheck": "Useful upper-bound case.",
      "verifies": "A late 120-character eligible word is retained in an ASCII-safe bounded deterministic name."
    },
    {
      "concerns": [],
      "evidence": "The prompt covers ASCII letters or digits, length 4-120, and words appearing late.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt",
      "qualityCheck": "Covers alphabetic and numeric words.",
      "verifies": "Late `controllers` and late `1234` each survive as whole words in distinct ASCII-safe bounded names and files."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires finding an eligible word even late in a long description.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordBeforeIt",
      "qualityCheck": "Discriminates naive prefix truncation/token selection.",
      "verifies": "A later eligible word survives despite a preceding 121-character ineligible word and long filler."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires keeping an eligible whole word whenever one exists.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordAfterIt",
      "qualityCheck": "Good trailing-overflow case.",
      "verifies": "An eligible leading word remains whole despite a trailing 121-character word."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a whole word of 4-120, excluding a substring of an overlong word.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordBeginningWithIt",
      "qualityCheck": "Strong whole-word boundary test.",
      "verifies": "The eligible standalone trailing `abcd`, not merely its prefix inside a 121-character token, is retained whole; violations read back."
    },
    {
      "concerns": [],
      "evidence": "Built-in names must use only the allowed characters and description naming is deterministic even when no word-retention clause applies.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionWithoutAnyPlainCharacterStillYieldsAStableName",
      "qualityCheck": "Good fallback case.",
      "verifies": "Punctuation-only descriptions get a nonempty ASCII-safe name stable across stores."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires built-in ASCII-safe names, per-rule difference, determinism, and the length bound.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionOfOnlyNonAsciiCharactersStillYieldsAStableAsciiName",
      "qualityCheck": "Direct Unicode fallback/collision case.",
      "verifies": "Non-ASCII-only rules get distinct ASCII-safe bounded names, stable for the same description across stores."
    },
    {
      "concerns": [],
      "evidence": "The naming requirement applies to stored files; repository save/read ordering is visible in `TextFileBasedViolationStore.java:156-170,187-202`.",
      "fairness": "Prompt-stated",
      "name": "violationsAreReadBackFromANameTakenFromTheDescription",
      "qualityCheck": "Valid naming/read integration.",
      "verifies": "Two violations read back in order through a description-derived name that retains an eligible word."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines misplaced entries and repair movement, plus description-name word retention.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingALegacyNameIsMovedToTheNameTakenFromTheDescription",
      "qualityCheck": "Direct migration scenario.",
      "verifies": "Description-mode repair replaces a UUID-like legacy name with a different word-retaining name, moves the file, and preserves content."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says built-in names are never `stored.rules` and retain an eligible word.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionNeverCollideWithTheIndex",
      "qualityCheck": "Direct reserved-name case.",
      "verifies": "For rule description `stored.rules`, the derived name differs from the index and still retains that eligible word."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair writes the index only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
      "qualityCheck": "Byte and timestamp checks distinguish rewriting identical content from no write.",
      "verifies": "No-op repair preserves bytes and mtime; repair removing a broken entry changes both bytes and mtime."
    },
    {
      "concerns": [],
      "evidence": "Repair leaves shared/unowned conditions alone and writes only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex",
      "qualityCheck": "Strong no-op-write check.",
      "verifies": "Shared/unowned findings leave hand-written index bytes and mtime unchanged; entries remain and fail still reports the unowned file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the index is written only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "arepairThatChangesNothingLeavesTheIndexByteIdentical",
      "qualityCheck": "Direct repeated-repair no-write test.",
      "verifies": "A second no-op repair preserves first-repair bytes and a backdated mtime."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair examines the index and folder while initializing; that denotes current on-disk state, not a stale process cache.",
      "fairness": "Prompt-stated",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "Important cache-coherence regression.",
      "verifies": "After an ignore initialization, replacing the on-disk index with a different broken entry causes a later repair to remove that current entry, leaving an empty index."
    }
  ],
  "unfairTestCount": 1,
  "verdict": "FAIL"
}
Close