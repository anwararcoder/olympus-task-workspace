**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥20 messages, ≥200 LOC

This task numbers: Median files: 3, messages: 193, LOC: 1011

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "389c55765f82007c945f6f29adeed7f7f102b8d3f6f3e9b8ec77585104e3337a",
  "overall": "distinct",
  "perCandidate": [
    {
      "confidence": 0.98,
      "contentAuthoredAt": 1786258071836,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "They target different repositories and domains: ArchUnit’s Java freeze store persistence vs. SQLFluff’s Python autofix engine.",
        "The ArchUnit change adds configuration-driven file naming (random/description/custom strategy), index/folder integrity modes (ignore/repair/fail), and guarded filesystem operations; the SQLFluff change instruments the fixing loop to detect cycles or pass-limit exhaustion and replays fixes while suppressing only implicated rules.",
        "ArchUnit’s scope centers on filesystem semantics (symlinks, canonical paths, index consistency, line-break handling) and initialization/save invariants; SQLFluff’s scope centers on per-rule activity tracking across phases, convergence attribution, survivor replay, and diagnostics surfaced in lint results."
      ],
      "one_liner": "Two unrelated changes: one adds integrity checking and deterministic file naming to ArchUnit’s file-based freeze store, the other attributes SQLFluff autofix non-convergence to specific rules and replays surviving fixes.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The patches modify entirely different codebases and surfaces with no purpose-matched overlap. The ArchUnit submission extends a file-backed violation store with integrity verification and deterministic naming, while the SQLFluff candidate reworks the autofix convergence logic to attribute and suppress only non-converging rules and then replay other fixes. There are no shared APIs, behaviors, or lifecycle stages that would make these the same task.",
      "similarity": 0.6047085523605347,
      "submission_summary": "Adds RuleDescriptionFileNames and a factory to derive rule file names from descriptions or a custom strategy, and introduces StoreIntegrity to validate and reconcile a TextFileBasedViolationStore’s index and folder with modes ignore/repair/fail. Extends TextFileBasedViolationStore to wire these features, enforce safe writes/deletes/moves, handle line-break-only files, and document new properties.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.98,
      "contentAuthoredAt": 1786876774252,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: Java ArchUnit freeze-store filesystem/index maintenance vs Go nftables in-memory ruleset staging and OCC.",
        "Submission modifies TextFileBasedViolationStore (naming strategy, initialization, integrity modes IGNORE/REPAIR/FAIL, file moves/deletes, index reconciliation) and touches on-disk files; candidate adds RulesetStore/RulesetTx with journaling, conflict detection, rebase/serialize of transactions, no filesystem/index work.",
        "Submission’s behavior centers on path resolution, symlink/regular-file checks, derived filenames from rule descriptions, and cleaning/migrating store files; candidate centers on transactional staging of tables/chains/rules/sets/objects, rule anchoring by handles/IDs, and commit conflict detection across epochs."
      ],
      "one_liner": "One adds deterministic file naming and on-disk integrity reconciliation to ArchUnit’s text-based freeze-violation store; the other implements an in-memory, versioned ruleset staging store with optimistic concurrency for nftables.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The patches target unrelated projects and surfaces with different behaviors and lessons: ArchUnit’s store naming and integrity repair/fail logic around a file-backed index versus nftables’ in-memory transactional ruleset store with optimistic concurrency, rebase, and serialization. There are no shared purpose-matched files, APIs, or behaviors beyond generic notions of a “store,” so they should co-exist.",
      "similarity": 0.6016160845756531,
      "submission_summary": "Introduces configurable rule-violation file naming (random/description/custom strategy) and an integrity mode (ignore/repair/fail) to TextFileBasedViolationStore, plus a StoreIntegrity reconciler that classifies entries and moves/deletes files, and integrates these into initialization and save semantics with strict path and ownership checks.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.92,
      "contentAuthoredAt": 1784870646197,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission modifies ArchUnit’s TextFileBasedViolationStore to add integrity modes (ignore/repair/fail) that classify and reconcile index entries vs. files (broken/resolved/misplaced/shared/colliding/occupied/unowned), optionally moving or deleting files and updating the index; it also introduces deterministic, description-based file naming and strict ownership/safety checks for file operations.",
        "Candidate modifies Qdrant’s Gridstore to add a versioned record envelope with CRC32C, a new RecordFormat in config (Legacy vs. ChecksummedV1), record encode/decode paths, detailed corruption errors, a full-store audit_integrity API, and a migration API to copy values into a checksummed destination, with cleanup semantics.",
        "Submission’s scope centers on filesystem path resolution, symlink/ hardlink identity, index file validation/creation, and line-break-only files as ‘no violations’; candidate’s scope centers on record header validation (magic/version/flags), checksum/length verification, decompression failures, ordered integrity reporting, and destination existence/cleanup for migration."
      ],
      "one_liner": "Both add integrity-related features, but one reconciles a filesystem-backed rule-violation store’s index and files while the other introduces per-record checksums with audit and migration in a grid storage engine.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The modified surfaces and behaviors operate in different repositories and layers: the submission is about reconciling a Java filesystem-based index with on-disk files and naming strategies, while the candidate adds Rust record-format envelopes, checksum validation, audit reporting, and migration in a block/page gridstore. There is no purpose-matched file or API overlap beyond the generic idea of “integrity,” and the core lessons (index-folder reconciliation vs. per-record checksumming/audit) are materially different.",
      "similarity": 0.5721481442451477,
      "submission_summary": "Adds integrity maintenance to ArchUnit’s TextFileBasedViolationStore: introduces integrity modes (ignore/repair/fail) that classify entries and reconcile the index with files, performs moves/deletions under repair, rejects under fail, and updates initialization/ownership checks. Also adds configurable file-naming strategies including deterministic names from rule descriptions and treats line-break-only files as no violations.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.92,
      "contentAuthoredAt": 1787009515981,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: ArchUnit’s Java freeze-store vs. SurrealKV’s Rust KV engine.",
        "Submission modifies TextFileBasedViolationStore to add deterministic file naming strategies and an integrity mode (ignore/repair/fail) that classifies entries and moves/deletes files; candidate introduces an OPTIONS manifest encoding store identity and enforces compatibility on open, with additional checkpoint/restore validation across WAL, SSTables, VLog, and versioned index.",
        "Submission focuses on per-rule file ownership and folder/index reconciliation (broken/resolved/misplaced/shared/colliding/occupied/unowned) and save-time safeguards; candidate focuses on atomic OPTIONS publication, lock-ordering, typed manifest errors, and structural validation of multiple subsystems including B+Tree, WAL range continuity, and VLog file/pointer checks.",
        "Submission’s API/surfaces: new RuleDescriptionFileNames, RuleViolationFileNameStrategyFactory, StoreIntegrity, and extended TextFileBasedViolationStore; candidate’s API/surfaces: new options_manifest module, new error variants, expanded checkpoint logic, B+Tree/file validation utilities, and vlog/wal changes."
      ],
      "one_liner": "They implement unrelated persistence safeguards in different repositories: one adds file naming and on-start integrity reconciliation for ArchUnit’s text-based freeze store, while the other adds a durable OPTIONS manifest with compatibility enforcement and checkpoint/restore validation to SurrealKV.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The patches target different codebases and implement different features at different layers: ArchUnit’s patch adds naming strategy selection and on-initialize repair/fail logic for a text-file violation store, whereas SurrealKV introduces a durable OPTIONS manifest with identity compatibility checks and extensive checkpoint/restore validation across engine components. There is no purpose-matched modified surface or shared API/behavior; any thematic overlap (integrity/validation) is generic and not the same task.",
      "similarity": 0.5567674040794373,
      "submission_summary": "Adds a deterministic rule-description-based file naming strategy and a factory for selecting/instantiating naming strategies, introduces an integrity mode for TextFileBasedViolationStore that classifies entries (broken/resolved/misplaced/etc.), repairs or fails initialization accordingly, and enforces ownership and safe saving/moving/deleting of rule files with index updates.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.96,
      "contentAuthoredAt": 1785764499698,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission targets com.tngtech.archunit.library.freeze: introduces store integrity modes (ignore/repair/fail), deterministic/custom naming for violation files, stricter ownership and filesystem checks, and documentation updates.",
        "Candidate targets com.tngtech.archunit.core.importer: adds a FinallyAccessNormalizer that analyzes ASM trees to collapse duplicate access instructions from compiler-generated finally copies and wires it into JavaClassProcessor.",
        "Submission’s observable behavior affects how the freeze store initializes, validates, moves/deletes files, writes entries, and names files; Candidate’s behavior affects which bytecode accesses are reported across all downstream views (code unit/class views, dependencies, rule violations).",
        "Different modified surfaces and purposes: TextFileBasedViolationStore, StoreIntegrity, naming strategy factory vs. JavaClassProcessor and ASM-based normalization; build/dependency changes in candidate unrelated to freeze store."
      ],
      "one_liner": "They modify different subsystems of ArchUnit: one adds integrity maintenance and deterministic file naming to the freeze-store, the other deduplicates compiler-cloned finally-block accesses in the bytecode importer.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "Although both patches are in the same repository, they touch unrelated packages and features: the submission overhauls the freeze violation store’s integrity and naming, whereas the candidate normalizes bytecode accesses from finally blocks in the importer. There is no purpose-matched file or behavior overlap; the shared scaffolding (same repo, general Java/ArchUnit context) does not indicate the same task.",
      "similarity": 0.36720684293256767,
      "submission_summary": "Adds integrity maintenance to TextFileBasedViolationStore with modes ignore/repair/fail, enforces store ownership rules, and introduces configurable file naming (random/description/custom) with canonicalization. Integrates a StoreIntegrity reconciliation step into initialization and alters saving behavior (including discarding resolved rules under repair), plus documentation updates.",
      "verdict": "distinct"
    }
  ],
  "reusedFromPriorRun": true
}
```

---

**Test Fairness**

All hidden tests are fair.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [],
  "error": "",
  "executionTimeSeconds": 310.341526,
  "message": "All hidden tests are fair.",
  "overall": "PASS: all 136 hidden test methods are predictable from the unusually detailed prompt, with a few integration/serialization assertions additionally grounded in visible repository behavior. No test is substantively unfair. Quality caveats do not change fairness: the concurrency group uses fixed 1/2/5/30-second waits and joins, so extreme load can cause timing-sensitive failures; the link/hard-link/rooted-path group assumes a filesystem/platform supporting the relevant link semantics; child-JVM probes assume a runnable java binary under java.home. The POSIX deletion probe and WatchService case are called out specifically above. Reporting assertions only require stated tokens and relative order, not exact prose, so they are not brittle full-message matches.",
  "requirements": [
    {
      "covered": "yes",
      "coveringTests": [
        "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
        "randomFileNamesDeriveNothingSoNoEntryIsMisplaced",
        "namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced"
      ],
      "requirement": "default.fileNames defaults to random and names new files.",
      "sourceQuote": "`default.fileNames` names new files and defaults to `random`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aRuleKeepsTheSameNameInALaterRun",
        "aRuleKeepsTheSameNameOnAnotherMachine",
        "aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds"
      ],
      "requirement": "Description naming is deterministic from the description.",
      "sourceQuote": "With `description`, the name derives deterministically from the rule description."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "twoRulesReadingAlikeStillGetDifferentNames",
        "aLongWordAfterOnlyShortOnesStillYieldsABoundedName",
        "aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt",
        "aWordWorthKeepingSurvivesAnOverlongWordBeforeIt",
        "aWordWorthKeepingSurvivesAnOverlongWordAfterIt",
        "aWordWorthKeepingSurvivesAnOverlongWordBeginningWithIt"
      ],
      "requirement": "Names differ per rule and retain a whole 4–120 alphanumeric word even late in a long description.",
      "sourceQuote": "Names differ per rule, and each keeps a whole word of 4 to 120 letters or digits, even one that comes late in a long description."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
        "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
        "aDescriptionOfOnlyNonAsciiCharactersStillYieldsAStableAsciiName",
        "namesTakenFromTheDescriptionNeverCollideWithTheIndex"
      ],
      "requirement": "Built-in names use the safe ASCII alphabet, are at most 200 characters, and never equal stored.rules.",
      "sourceQuote": "Built-in names use only ASCII letters, digits, underscores and hyphens. They never exceed 200 characters and are never `stored.rules`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves",
        "aStrategyThatCannotBeInstantiatedIsRejected",
        "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected",
        "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore"
      ],
      "requirement": "Custom configured naming strategies must be public-no-arg implementations; no-name results are rejected when needed.",
      "sourceQuote": "Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor. A strategy that yields no name is rejected as soon as a name is needed."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
        "aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing"
      ],
      "requirement": "Constructor strategies apply to moves/saves and conflict with default.fileNames configuration.",
      "sourceQuote": "A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store is rejected."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "valuesNearAnAcceptedValueAreRejected",
        "unknownValueIsRejectedAndNamesTheAcceptedValues"
      ],
      "requirement": "Integrity accepts exact repair/fail/ignore values, defaults to ignore, and invalid values name the accepted values.",
      "sourceQuote": "`default.integrity` accepts the exact values `repair`, `fail` and `ignore`, and defaults to `ignore`, which examines nothing."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
        "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder"
      ],
      "requirement": "Repair/fail examine during initialization; ignore examines nothing.",
      "sourceQuote": "`repair` and `fail` examine the index and the folder while initializing."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
        "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives"
      ],
      "requirement": "Broken entries cover missing, directory, outside, and non-regular/non-direct paths.",
      "sourceQuote": "An entry is broken when its resolved path is missing, a directory, outside the folder, or not a regular file directly in it."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
        "carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved"
      ],
      "requirement": "Resolved detection handles empty/LF/CRLF/CR while preserving carriage returns inside violations.",
      "sourceQuote": "An entry is resolved when the file at that path yields no violations, including a file holding only line breaks, whether `\\n`, `\\r\\n` or a lone `\\r`, although a carriage return inside a stored violation stays part of its text."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
        "failNamesMisplacedEntriesAndChangesNothing"
      ],
      "requirement": "Misplaced means recorded name differs from the derived one.",
      "sourceQuote": "An entry is misplaced when its name is not its rule's derived one."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair"
      ],
      "requirement": "Same recorded name or names resolving to one file are shared, even absent.",
      "sourceQuote": "Two entries recording the same name are shared, even if nothing exists under that name. So are two entries whose recorded names resolve to one file, as when one links to that file."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
        "failNamesBothCollidingRulesEvenWhenOneAlreadyRecordsTheDerivedName"
      ],
      "requirement": "Same derived name means collision.",
      "sourceQuote": "One derived name two rules share is colliding."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aDerivedNameAnUnownedFileOccupiesIsNotTakenOver",
        "aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt",
        "aDerivedNameLeavingTheStoreFolderIsNeverUsed",
        "anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs"
      ],
      "requirement": "Occupied derived-name conditions and settled-name exemption follow the prompt definition.",
      "sourceQuote": "A misplaced entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder; an entry recording its derived name is never occupied."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "aDirectoryInTheStoreFolderIsNeverACondition",
        "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
        "theIndexItselfIsNeverUnowned",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair"
      ],
      "requirement": "Only directly contained unrecorded regular files are unowned; shared/unowned are left alone and shared has precedence.",
      "sourceQuote": "Apart from the index, a regular file directly in the folder that no entry records is unowned. The store leaves shared entries and unowned files alone. An entry both shared and something else stays shared."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName",
        "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied"
      ],
      "requirement": "Repair does not move colliding/occupied entries but still drops broken/resolved ones.",
      "sourceQuote": "It never moves a colliding or occupied entry, but still discards one that is broken or resolved."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "everyBrokenEntryIsDiscarded",
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
        "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt"
      ],
      "requirement": "Repair drops broken and resolved entries, deletes resolved files/link targets, and moves misplaced files/link targets.",
      "sourceQuote": "`repair` discards broken entries. It discards resolved entries with the files they name, deleting a link's target with the link. It moves a misplaced entry's file to its derived name, moving a link's target rather than the link."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
        "aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex",
        "arepairThatChangesNothingLeavesTheIndexByteIdentical"
      ],
      "requirement": "Repair writes the index only when an entry changed.",
      "sourceQuote": "It writes the index only when an entry changed."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "failAcceptsAConsistentStoreAndRejectsAnInconsistentOne",
        "failWithSeveralConditionsAtOnceChangesNotOneByte",
        "failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne"
      ],
      "requirement": "Fail changes nothing and rejects inconsistent stores without transiently creating an absent index.",
      "sourceQuote": "`fail` changes nothing, rejecting initialization unless the index and folder agree, and a rejection does not even create an absent index."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "failNamesTheConditionsInTheStatedOrder",
        "failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName",
        "failOrdersSharedEntriesByRuleDescription",
        "failOrdersMisplacedEntriesByRuleDescription",
        "failOrdersCollidingEntriesByRuleDescription",
        "failOrdersOccupiedEntriesByRuleDescription"
      ],
      "requirement": "Fail reports all conditions and orders required categories and members.",
      "sourceQuote": "Its report names every entry in any condition and every unowned file. It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it. Within a condition it orders entries by rule description and files by name."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "repairWithoutPermissionToUpdateIsRejectedAndChangesNothing",
        "repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore",
        "failWithoutPermissionToUpdateStillReportsTheInconsistency"
      ],
      "requirement": "Repair requires update permission; fail reports regardless.",
      "sourceQuote": "`repair` needs `default.allowStoreUpdate` and is rejected without it. `fail` reports either way."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined",
        "anIndexThatIsALinkOutOfTheStoreFolderIsRejectedAndItsTargetSurvives",
        "anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined",
        "anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired"
      ],
      "requirement": "Absent/invalid index is rejected before examination according to creation permission and regular-direct-file requirement.",
      "sourceQuote": "An absent index without `default.allowStoreCreation`, or one not a regular file directly in the folder, is rejected before anything is examined."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn",
        "storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected",
        "storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected",
        "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected",
        "storingARuleNeverWritesOverTheIndex"
      ],
      "requirement": "Saving never overwrites index, outside paths, or unowned files and rejects atomically.",
      "sourceQuote": "Storing a rule never writes over the index, anything outside the folder, or a file its own entry does not record. Such a save is rejected, leaving the index and the folder as they were."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
        "forgettingARuleTheIndexNeverKnewStoresNothingForIt"
      ],
      "requirement": "Under repair, empty saves forget known rules/files unless shared and do nothing for unknown rules.",
      "sourceQuote": "Under `repair`, storing no violations forgets a known rule, discarding its entry and its file unless another entry shares that file, and stores nothing for an unknown rule."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
        "aStillViolatedRuleKeepsItsEntryUnderRepair"
      ],
      "requirement": "Failed deletion rejects forget and retains the entry; nonempty save retains the entry.",
      "sourceQuote": "If that file cannot be deleted, the save is rejected and the entry stays. A still violated rule keeps its entry."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "concurrentInitializationsLeaveAReadableIndex",
        "concurrentRepairAndFailLeaveAReadableIndex",
        "examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave",
        "oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind",
        "repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved",
        "repairingTheFolderWhileAnotherStoreSavesIntoAnEmptiedFileKeepsTheEntryAndTheFile"
      ],
      "requirement": "Concurrent initialize/save operations are atomic, leave readable survivor-only state, and examinations do not observe saves in progress.",
      "sourceQuote": "Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress."
    }
  ],
  "taskSummary": "Implement integrity maintenance and safe naming for TextFileBasedViolationStore. The visible prompt defines two new configuration axes: default.fileNames (default random; built-in deterministic description naming; or a public no-arg custom strategy) and default.integrity (exactly ignore, repair, or fail; default ignore). It precisely defines broken, resolved, shared, misplaced, colliding, occupied, and unowned states; repair/fail precedence and ordering; index-creation/update policy; safe save/forget behavior; and in-process concurrency/atomicity. The hidden suite exercises those definitions against the on-disk stored.rules Properties index, ordinary files, directories, links, hard links, custom strategies, FreezingArchRule integration, and concurrent stores.",
  "tests": [
    {
      "concerns": [],
      "evidence": "“default.integrity ... defaults to ignore, which examines nothing” and “repair discards broken entries.”",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Directly distinguishes the default from repair.",
      "verifies": "With no default.integrity property the broken entry remains; a later repair removes it."
    },
    {
      "concerns": [],
      "evidence": "“ignore ... examines nothing” and “repair discards broken entries.”",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Direct requirement check.",
      "verifies": "Explicit ignore retains the broken entry; repair then removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt says ignore examines nothing, repair drops broken/resolved, leaves shared and unowned alone, moves unoccupied misplaced entries, and never moves occupied entries.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Strong combined-state and byte-preservation check.",
      "verifies": "Ignore leaves every filename and byte unchanged; subsequent repair drops broken/resolved entries, preserves shared/occupied/unowned items, moves the movable misplaced file, and preserves relevant contents."
    },
    {
      "concerns": [],
      "evidence": "“Any other value is rejected, naming the three accepted.” Existing initialization failures are unchecked at archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreInitializationFailedException.java:18.",
      "fairness": "Prompt-stated",
      "name": "unknownValueIsRejectedAndNamesTheAcceptedValues",
      "qualityCheck": "Checks required message tokens without pinning full prose.",
      "verifies": "default.integrity=prune throws a RuntimeException whose message contains ignore, repair, and fail."
    },
    {
      "concerns": [],
      "evidence": "“accepts the exact values repair, fail and ignore.”",
      "fairness": "Prompt-stated",
      "name": "valuesNearAnAcceptedValueAreRejected",
      "qualityCheck": "Good exactness coverage.",
      "verifies": "Repair, repair-space, repairs, IGNORE, and failed each throw RuntimeException."
    },
    {
      "concerns": [],
      "evidence": "“fail changes nothing, rejecting initialization unless the index and folder agree” and its report names every conditioned entry.",
      "fairness": "Prompt-stated",
      "name": "failAcceptsAConsistentStoreAndRejectsAnInconsistentOne",
      "qualityCheck": "Covers both acceptance and rejection.",
      "verifies": "Fail initializes a consistent store; on a missing-file entry it throws, names the rule, and leaves the index entry intact."
    },
    {
      "concerns": [],
      "evidence": "“repair discards broken entries” and writes only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Covers positive and negative stores.",
      "verifies": "Repair preserves a healthy entry/file and removes a broken entry."
    },
    {
      "concerns": [],
      "evidence": "“An entry is broken when its resolved path is missing” and “repair discards broken entries.”",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "Direct classification check.",
      "verifies": "Repair removes only the absent-file entry and leaves the present entry and file."
    },
    {
      "concerns": [],
      "evidence": "“repair discards broken entries.”",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Useful multiplicity check.",
      "verifies": "Repair removes all three missing-file entries and retains the healthy entry."
    },
    {
      "concerns": [],
      "evidence": "An entry is broken when its path “is a directory”; repair discards the entry, while no requirement authorizes deleting that directory.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "Checks both index and filesystem effects.",
      "verifies": "Repair removes an entry naming a directory but leaves the directory itself."
    },
    {
      "concerns": [],
      "evidence": "Outside paths are broken; repair discards broken entries, and saves/maintenance must not affect outside files.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Strong safety check.",
      "verifies": "Repair removes an ../ outside entry while preserving the outside file and its exact content."
    },
    {
      "concerns": [],
      "evidence": "An entry is broken when its resolved path is “outside the folder” or not directly in it.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "Tests absolute-path interpretation and noninterference.",
      "verifies": "Two absolute-path entries are removed; both the external file and similarly named in-folder file remain byte-equivalent in content."
    },
    {
      "concerns": [],
      "evidence": "A healthy entry must resolve to “a regular file directly in” the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Direct boundary check.",
      "verifies": "Repair removes an entry naming nested/violations but leaves that nested file."
    },
    {
      "concerns": [],
      "evidence": "A path that cannot resolve to a directly contained regular file is broken; fail reports all conditions and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Good malformed-path robustness case.",
      "verifies": "Fail reports the NUL-containing entry without corrupting the index; repair removes only it; the healthy entry/file remains, and fail then accepts."
    },
    {
      "concerns": [],
      "evidence": "Classification is by the entry’s “resolved path,” and the resulting file is regular and directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "Checks normalization rather than raw string shape.",
      "verifies": "./violations survives repair, remains readable as one violation, while an unrelated broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "Brokenness is based on the resolved path being outside; outside data must not be touched.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Direct link-boundary check.",
      "verifies": "Repair drops an entry whose in-folder link resolves outside, preserves the target content, and leaves a store accepted by fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt treats recorded names by what they resolve to and explicitly discusses links resolving to files.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Useful ownership case.",
      "verifies": "An entry through an in-folder symlink survives repair, its target content remains, an unrelated broken entry disappears, and fail accepts afterward."
    },
    {
      "concerns": [],
      "evidence": "Only directly contained regular files are unowned conditions, and repair is not authorized to delete an unrecorded link or outside target.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Covers non-entry link handling.",
      "verifies": "Repair removes the broken indexed entry but preserves an unrecorded symlink and its outside target; fail accepts afterward."
    },
    {
      "concerns": [],
      "evidence": "Its resolved path is missing, hence broken.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "Direct edge case.",
      "verifies": "Repair removes the entry naming a dangling symlink."
    },
    {
      "concerns": [],
      "evidence": "A zero-violation entry is resolved; “repair ... discards resolved entries with the files they name.”",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Direct resolved-entry check.",
      "verifies": "Repair removes the empty-file entry and leaves only stored.rules."
    },
    {
      "concerns": [],
      "evidence": "Repair deletes a resolved link’s target “with the link.”",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Precisely checks both link and target.",
      "verifies": "Repair removes the resolved entry, target file, and symlink, leaves only the index, and fail subsequently accepts."
    },
    {
      "concerns": [],
      "evidence": "A file holding only line breaks is resolved; a file yielding a violation is not.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Good discriminating pair.",
      "verifies": "A LF-only file and entry are deleted; a file containing a violation plus LF remains indexed."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly names “\\n, \\r\\n or a lone \\r.”",
      "fairness": "Prompt-stated",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Covers all stated newline encodings.",
      "verifies": "CRLF-only, CR-only, and LF-only entries/files are removed; the actual violation ending CRLF remains."
    },
    {
      "concerns": [],
      "evidence": "“a carriage return inside a stored violation stays part of its text.”",
      "fairness": "Prompt-stated",
      "name": "carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved",
      "qualityCheck": "Strong round-trip and maintenance integration.",
      "verifies": "Save/read round-trips embedded CR and CRLF within violations; repair removes only the line-break-only entry; fail accepts and rereads the same three strings."
    },
    {
      "concerns": [],
      "evidence": "Resolved means the file “yields no violations.”",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Direct boundary pair.",
      "verifies": "Repair retains the one-violation entry/file and removes the empty entry/file."
    },
    {
      "concerns": [],
      "evidence": "“Two entries recording the same name are shared” and shared entries are left alone.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Direct precedence check.",
      "verifies": "Two entries recording the same empty file survive repair while an unrelated broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "Two names resolving to one file are shared, “as when one links,” and “an entry both shared and something else stays shared.”",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Thorough shared-precedence coverage.",
      "verifies": "Symlink/direct aliases to one in-folder file survive; two aliases resolving to one outside file also survive despite brokenness; links/targets and recorded values remain."
    },
    {
      "concerns": [],
      "evidence": "The asserted hard links are two recorded names resolving to one file, which the prompt defines as shared.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Good aliasing case.",
      "verifies": "Fail reports both hard-link aliases; repair retains both empty shared entries and both names while removing an unrelated broken entry."
    },
    {
      "concerns": [],
      "evidence": "Shared takes precedence over every other condition; repair leaves shared entries alone.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Strong precedence matrix.",
      "verifies": "Across ordinary, colliding-derived, and occupied-derived stores, empty shared entries/files survive while lone resolved/broken entries disappear and occupants remain."
    },
    {
      "concerns": [],
      "evidence": "Fail reports shared entries and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesSharedEntriesAndChangesNothing",
      "qualityCheck": "Direct report/state check.",
      "verifies": "Fail throws with both shared rule descriptions and leaves the index and shared file unchanged."
    },
    {
      "concerns": [],
      "evidence": "“An entry both shared and something else stays shared.”",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Direct precedence check.",
      "verifies": "Fail names both absent shared entries and the lone broken entry; repair retains the shared pair, removes only the lone broken entry, and leaves only the index."
    },
    {
      "concerns": [],
      "evidence": "“The store leaves ... unowned files alone” and discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Direct mixed-condition check.",
      "verifies": "Repair removes the broken index entry but preserves notes.txt and exact content."
    },
    {
      "concerns": [],
      "evidence": "Fail reports every unowned file and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesUnownedFilesAndChangesNothing",
      "qualityCheck": "Direct report/state check.",
      "verifies": "Fail throws with stray in its message and leaves index, owned file, and stray file present."
    },
    {
      "concerns": [],
      "evidence": "Only “a regular file directly in the folder” can be unowned.",
      "fairness": "Prompt-stated",
      "name": "aDirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Good positive/negative distinction.",
      "verifies": "Fail accepts a store with a subdirectory but rejects another store with a regular stray file and names that file."
    },
    {
      "concerns": [],
      "evidence": "Only regular files “directly in the folder” are examined as unowned.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Direct recursion-boundary check.",
      "verifies": "Fail reports the broken entry but not buried; repair removes only the broken entry and preserves the nested file content."
    },
    {
      "concerns": [],
      "evidence": "The unowned definition explicitly begins “Apart from the index.”",
      "fairness": "Prompt-stated",
      "name": "theIndexItselfIsNeverUnowned",
      "qualityCheck": "Direct exclusion check.",
      "verifies": "Fail accepts a healthy store containing only its index and owned file; in another store it reports only the broken entry rather than treating stored.rules as unowned."
    },
    {
      "concerns": [],
      "evidence": "Repair makes only the specified entry changes and writes only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Useful idempotence check.",
      "verifies": "A second repair preserves the first repair’s file list and surviving entry exactly."
    },
    {
      "concerns": [],
      "evidence": "Shared entries are left alone and shared precedence dominates misplacedness.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Good idempotence plus aliasing check.",
      "verifies": "Two shared aliases remain unchanged across two repairs; only the unrelated broken entry disappears, and the target content remains."
    },
    {
      "concerns": [],
      "evidence": "Repair’s specified output agrees with fail’s consistency requirement.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderPassesAFailingCheck",
      "qualityCheck": "Good cross-mode consistency check.",
      "verifies": "After repair removes broken/resolved entries, fail initializes successfully and the healthy entry remains."
    },
    {
      "concerns": [],
      "evidence": "Repair writes changed entries to the on-disk index; contains is the visible store lookup (archunit/src/main/java/com/tngtech/archunit/library/freeze/ViolationStore.java:50-53).",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Important persistence/cache check.",
      "verifies": "A fresh store initialized with ignore reports the removed rule absent and healthy rule present."
    },
    {
      "concerns": [],
      "evidence": "Repair discards broken entries and resolved entries with their files.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Direct final-layout check.",
      "verifies": "After dropping broken/resolved entries, only stored.rules and the healthy referenced file remain, and the property value equals that filename."
    },
    {
      "concerns": [],
      "evidence": "Concurrent initialization must leave “a readable index and a folder holding only the index and survivors’ files.”",
      "fairness": "Prompt-stated",
      "name": "concurrentInitializationsLeaveAReadableIndex",
      "qualityCheck": "The final-state assertion is strong; fixed 30-second waits are discussed in overall.",
      "verifies": "Four concurrent repairs finish without failures; the index parses to only the healthy entry and only its file survives."
    },
    {
      "concerns": [],
      "evidence": "Concurrent initializations must be safe; repair moves a movable misplaced entry to its derived name.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairsOfAMisplacedEntryLeaveItOnItsMovedFile",
      "qualityCheck": "Good race orchestration, though the ignored one-second latch result makes the intended interleaving somewhat shallow.",
      "verifies": "Two orchestrated repairs terminate; the sole entry records derived, only that file and the index exist, content is preserved, and fail accepts."
    },
    {
      "concerns": [],
      "evidence": "“no store examines a save still in progress” and concurrent operations leave a readable survivor-only store.",
      "fairness": "Prompt-stated",
      "name": "examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave",
      "qualityCheck": "Final state is checked thoroughly, but it does not directly assert that examiners remained blocked before release.",
      "verifies": "A held save plus concurrent repair/fail all finish without error; final index has only the new rule, only its file survives, and both original and fresh readers return exactly one violation."
    },
    {
      "concerns": [],
      "evidence": "Concurrent saves must serialize safely; under repair, saving no violations forgets a known rule and its unshared file.",
      "fairness": "Prompt-stated",
      "name": "oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind",
      "qualityCheck": "Useful conflicting-save race.",
      "verifies": "A save begun first and a later empty save both finish; the later forget wins, leaving an empty index and no violation file, and fail accepts."
    },
    {
      "concerns": [],
      "evidence": "Repair moves misplaced files and no examination may observe a save in progress.",
      "fairness": "Prompt-stated",
      "name": "repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved",
      "qualityCheck": "Strong race outcome check.",
      "verifies": "Held save and repair finish without errors; final entry uses the derived name, only that file survives, and it contains/read-backs the newly saved violation rather than old content."
    },
    {
      "concerns": [],
      "evidence": "No store examines a save in progress, so repair must not discard the file as resolved mid-save.",
      "fairness": "Prompt-stated",
      "name": "repairingTheFolderWhileAnotherStoreSavesIntoAnEmptiedFileKeepsTheEntryAndTheFile",
      "qualityCheck": "Strong race regression case.",
      "verifies": "Held save and repair finish; final entry still records emptied, only that nonempty file survives, and readers return the newly saved violation."
    },
    {
      "concerns": [],
      "evidence": "Concurrent initializations must leave a readable index and survivor-only folder; fail may reject before repair completes.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairAndFailLeaveAReadableIndex",
      "qualityCheck": "Good mixed-mode stress check.",
      "verifies": "Six concurrent repair/fail initializations finish; only expected fail rejections are tolerated, no other throwable occurs, and final index/files contain only the healthy survivor."
    },
    {
      "concerns": [],
      "evidence": "“repair needs default.allowStoreUpdate and is rejected without it.”",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedAndChangesNothing",
      "qualityCheck": "Direct permission and atomicity check.",
      "verifies": "Repair with allowStoreUpdate=false throws and preserves both index entries and the healthy file."
    },
    {
      "concerns": [],
      "evidence": "Repair mode itself “needs default.allowStoreUpdate,” unqualified by inconsistency.",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore",
      "qualityCheck": "Good qualifier check.",
      "verifies": "Repair with update permission disabled throws even when no repair would be needed."
    },
    {
      "concerns": [],
      "evidence": "“fail reports either way.”",
      "fairness": "Prompt-stated",
      "name": "failWithoutPermissionToUpdateStillReportsTheInconsistency",
      "qualityCheck": "Direct policy check.",
      "verifies": "Fail with updates disabled still throws and names the broken rule."
    },
    {
      "concerns": [],
      "evidence": "“An absent index without default.allowStoreCreation ... is rejected before anything is examined.”",
      "fairness": "Prompt-stated",
      "name": "anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined",
      "qualityCheck": "Strong precondition-order and retry check.",
      "verifies": "Repair/fail with creation disabled reject absent indexes without creating one or naming an unowned file; after an index is manually added, repair works and removes its broken entry."
    },
    {
      "concerns": [
        "timing_sensitivity",
        "environment_assumption"
      ],
      "evidence": "“a rejection does not even create an absent index” and fail reports every unowned file.",
      "fairness": "Prompt-stated",
      "name": "failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne",
      "qualityCheck": "WatchService observes the transient-creation requirement, but event delivery is platform/timing sensitive.",
      "verifies": "Fail on an absent index with an unowned file reports notes.txt, never emits a stored.rules creation event, and preserves the file/content."
    },
    {
      "concerns": [],
      "evidence": "An index “not a regular file directly in the folder” is rejected before examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatIsALinkOutOfTheStoreFolderIsRejectedAndItsTargetSurvives",
      "qualityCheck": "Direct index-safety check.",
      "verifies": "Repair rejects stored.rules when it is an outward symlink and leaves its target content unchanged."
    },
    {
      "concerns": [],
      "evidence": "A non-regular-direct index is rejected before anything is examined.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined",
      "qualityCheck": "Strong precondition and nonmutation check.",
      "verifies": "Repair and fail reject an index symlink without naming other conditions or changing target bytes; the link and all files remain."
    },
    {
      "concerns": [],
      "evidence": "An index not a regular file directly in the folder is rejected before examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired",
      "qualityCheck": "The method name says unreadable, but the asserted directory scenario is still valid.",
      "verifies": "A directory at stored.rules is rejected by repair/fail with every file byte/name unchanged; a separate valid store is still repaired normally."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly orders “broken, resolved and shared entries, then unowned files.”",
      "fairness": "Prompt-stated",
      "name": "failNamesTheConditionsInTheStatedOrder",
      "qualityCheck": "Checks relative order without pinning full formatting.",
      "verifies": "In fail’s message, broken precedes resolved, which precedes shared, which precedes the unowned filename."
    },
    {
      "concerns": [],
      "evidence": "“Within a condition it orders entries by rule description and files by name.”",
      "fairness": "Prompt-stated",
      "name": "failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName",
      "qualityCheck": "Direct two-category ordering check.",
      "verifies": "The fail message places alpha broken before zulu broken and alpha-unowned before zulu-unowned."
    },
    {
      "concerns": [],
      "evidence": "Within-condition entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersSharedEntriesByRuleDescription",
      "qualityCheck": "Discriminates description ordering from filename ordering.",
      "verifies": "All four shared descriptions appear in lexical description order despite opposing recorded-name order."
    },
    {
      "concerns": [],
      "evidence": "Within-condition entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescription",
      "qualityCheck": "Direct ordering check.",
      "verifies": "Three misplaced descriptions appear alpha, mike, zulu in the fail message."
    },
    {
      "concerns": [],
      "evidence": "Within-condition entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersCollidingEntriesByRuleDescription",
      "qualityCheck": "Direct ordering check.",
      "verifies": "Three colliding descriptions appear alpha, mike, zulu in the fail message."
    },
    {
      "concerns": [],
      "evidence": "Within-condition entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersOccupiedEntriesByRuleDescription",
      "qualityCheck": "Discriminates the required sort key.",
      "verifies": "Three occupied descriptions appear alpha, mike, zulu despite inversely ordered derived names."
    },
    {
      "concerns": [],
      "evidence": "Within-condition entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescriptionAndNotByTheirDerivedNames",
      "qualityCheck": "Partly redundant with failOrdersMisplacedEntriesByRuleDescription, but more discriminating.",
      "verifies": "Misplaced descriptions appear alpha, mike, zulu despite inversely ordered derived names."
    },
    {
      "concerns": [],
      "evidence": "“fail changes nothing.”",
      "fairness": "Prompt-stated",
      "name": "failWithSeveralConditionsAtOnceChangesNotOneByte",
      "qualityCheck": "Strong byte-level nonmutation check.",
      "verifies": "After fail rejects a store with broken, resolved, shared, and unowned conditions, the sorted file list and every captured file byte remain identical."
    },
    {
      "concerns": [],
      "evidence": "Repair “discards resolved entries”; ViolationStore.contains means an indexed stored rule at archunit/src/main/java/com/tngtech/archunit/library/freeze/ViolationStore.java:50-53.",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Good public-API integration check.",
      "verifies": "After repair drops a resolved entry, a newly initialized reader’s contains returns false for that rule."
    },
    {
      "concerns": [],
      "evidence": "A violation-bearing entry is not resolved; repair only changes the stated conditions.",
      "fairness": "Prompt-stated",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Good reader integration.",
      "verifies": "Repair leaves contains=true and exactly one stored violation for the healthy rule while removing the adjacent broken index entry."
    },
    {
      "concerns": [],
      "evidence": "Repair discards the resolved entry/file; storing an unknown rule creates a newly named file under normal store semantics.",
      "fairness": "Prompt-stated",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Good post-repair save integration.",
      "verifies": "After repair removes the resolved entry/file, save recreates the rule with exactly the new violation and a non-legacy filename."
    },
    {
      "concerns": [],
      "evidence": "Prompt-stated repair removes the entry/file. Existing first-freeze behavior is asserted at archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java:105-116: first evaluation has no violation and stores the rule.",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Fair integration regression beyond the new maintenance mechanics.",
      "verifies": "After repair empties the index, a real FreezingArchRule evaluation has no violation, stores the rule again, and does not reuse the removed resolved filename."
    },
    {
      "concerns": [],
      "evidence": "default.fileNames defaults to random; random derives no deterministic replacement for an existing entry.",
      "fairness": "Prompt-stated",
      "name": "randomFileNamesDeriveNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Direct default-strategy maintenance check.",
      "verifies": "With the absent/default random naming configuration, repair retains an arbitrary healthy recorded filename and removes only the broken entry."
    },
    {
      "concerns": [],
      "evidence": "The built-in random mode names new files and does not define a per-description derived existing name.",
      "fairness": "Prompt-stated",
      "name": "namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Useful explicit/default parity check.",
      "verifies": "Explicit random retains the arbitrary entry/name/file under repair and passes fail afterward."
    },
    {
      "concerns": [],
      "evidence": "Prompt: constructor strategy “names files the same way.” The strategy return values are test setup; baseline save serialization appends LF at archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java:150-154.",
      "fairness": "Repo-discoverable",
      "name": "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
      "qualityCheck": "Covers both maintenance and save paths.",
      "verifies": "Constructor strategy moves the old file/index value to its exact strategy result, preserves content, and names a newly saved rule by that same strategy with baseline newline serialization."
    },
    {
      "concerns": [],
      "evidence": "“configuring default.fileNames for such a store is rejected.”",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing",
      "qualityCheck": "Direct conflict check.",
      "verifies": "Supplying both a constructor strategy and default.fileNames throws and leaves filenames/index mapping unchanged."
    },
    {
      "concerns": [],
      "evidence": "“A strategy that yields no name is rejected as soon as a name is needed”; repair/fail examine entries and need derived names.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Covers both no-name forms and both examining modes.",
      "verifies": "Null- and empty-name constructor strategies each cause repair and fail initialization to throw; index bytes and files remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "Default is random; names differ per rule, use the stated ASCII alphabet, are <=200, and are never stored.rules.",
      "fairness": "Prompt-stated",
      "name": "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
      "qualityCheck": "Strong default-name contract check.",
      "verifies": "Default naming gives two rules distinct non-index names matching [A-Za-z0-9_-]+ and length <=200; repair removes a broken entry, later does not relocate random names, and final files match."
    },
    {
      "concerns": [],
      "evidence": "Any custom RuleViolationFileNameStrategy value names files according to its returned name.",
      "fairness": "Prompt-stated",
      "name": "aConfiguredStrategyNamesNewlyStoredRules",
      "qualityCheck": "Direct custom-strategy save check.",
      "verifies": "A configured custom strategy stores a new rule under exactly createRuleFileName(description), with only index and that file present."
    },
    {
      "concerns": [],
      "evidence": "Prompt explicitly requires/accepts the public no-arg implementation and says it names moved/saved files; baseline LF serialization is at TextFileBasedViolationStore.java:150-154.",
      "fairness": "Repo-discoverable",
      "name": "aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves",
      "qualityCheck": "Thorough reflection-path check.",
      "verifies": "A public no-arg configured strategy moves an existing entry and names a new one by exact strategy outputs; both contents have the expected violation text plus LF."
    },
    {
      "concerns": [],
      "evidence": "The value must be the fully qualified name of an implementation with a public no-argument constructor; this value is not.",
      "fairness": "Prompt-stated",
      "name": "aStrategyThatCannotBeInstantiatedIsRejected",
      "qualityCheck": "Direct invalid-class check.",
      "verifies": "A nonexistent strategy class name causes repair initialization to throw."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires an implementation “with a public no-argument constructor.”",
      "fairness": "Prompt-stated",
      "name": "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected",
      "qualityCheck": "Good reflection validation matrix.",
      "verifies": "Wrong-type, argument-only-constructor, and private-no-arg classes each throw; the original index entry and file remain."
    },
    {
      "concerns": [],
      "evidence": "A no-name strategy is rejected as soon as an examining mode needs a derived name.",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Configured-strategy counterpart to the constructor test.",
      "verifies": "Configured null/empty strategies throw in repair and fail initialization without changing index bytes or files."
    },
    {
      "concerns": [],
      "evidence": "Ignore examines nothing; a strategy yielding no name is rejected “as soon as a name is needed.”",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore",
      "qualityCheck": "Strong laziness and rollback check.",
      "verifies": "Ignore does not invoke null/empty strategies; the first save needing a name invokes and rejects each, leaving index/files/content unchanged."
    },
    {
      "concerns": [],
      "evidence": "A differing name is misplaced and repair moves its file to the derived name.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
      "qualityCheck": "Direct move check.",
      "verifies": "Repair changes the sole property to the exact derived name, removes the legacy name, preserves file content, and leaves only index plus derived file."
    },
    {
      "concerns": [],
      "evidence": "Repair “moves a misplaced entry’s file,” which preserves its violations.",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryKeepsItsViolationsAfterTheMove",
      "qualityCheck": "Public readback verifies data preservation.",
      "verifies": "After repair, a reader returns exactly the two original violations and the index records the derived name."
    },
    {
      "concerns": [],
      "evidence": "Repair moves “a link’s target rather than the link.”",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt",
      "qualityCheck": "Precisely checks the required link result.",
      "verifies": "Repair records the derived name as a non-symlink regular file containing original content; old target/link names are gone; fail accepts."
    },
    {
      "concerns": [],
      "evidence": "Fail reports conditioned entries and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesMisplacedEntriesAndChangesNothing",
      "qualityCheck": "Direct report/state check.",
      "verifies": "Fail throws naming the rule and leaves legacy filename and property unchanged."
    },
    {
      "concerns": [],
      "evidence": "An escaping derived name makes the misplaced entry occupied; repair never moves occupied entries.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameLeavingTheStoreFolderIsNeverUsed",
      "qualityCheck": "Covers relative and absolute escapes.",
      "verifies": "Relative-escaping and absolute/rooted derived names do not move entries; outside data survives; fail still reports the inconsistency."
    },
    {
      "concerns": [],
      "evidence": "“One derived name two rules share is colliding” and repair never moves a colliding entry.",
      "fairness": "Prompt-stated",
      "name": "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
      "qualityCheck": "Direct collision check.",
      "verifies": "Repair leaves both legacy mappings/files; fail then names both colliding rules."
    },
    {
      "concerns": [],
      "evidence": "A misplaced entry is occupied when its derived name already names something; repair never moves it.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameAnUnownedFileOccupiesIsNotTakenOver",
      "qualityCheck": "Strong overwrite-safety check.",
      "verifies": "Repair preserves the legacy mapping/content and the exact unowned occupant content; fail still names the rule."
    },
    {
      "concerns": [],
      "evidence": "“already names something” includes this link; occupied entries are not moved.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkOutOfTheStoreFolderOccupiesIsNotTakenOver",
      "qualityCheck": "Direct symlink occupant case.",
      "verifies": "Repair leaves mapping and both contents intact when the derived name is an outward symlink; fail names the rule."
    },
    {
      "concerns": [],
      "evidence": "The derived name “already names something,” even if dangling.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADanglingLinkOccupiesIsNotTakenOver",
      "qualityCheck": "Good no-follow occupancy edge case.",
      "verifies": "Repair leaves the legacy mapping/content when a dangling symlink sits at the derived name; fail names the rule."
    },
    {
      "concerns": [],
      "evidence": "A misplaced entry is occupied when its derived name already names something; only an entry already recording its derived name is exempt.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkToTheEntrysOwnFileOccupiesIsNotTakenOver",
      "qualityCheck": "Tests a subtle but explicitly resolved distinction.",
      "verifies": "Repair retains the legacy mapping and derived-name symlink to the same file; both reads preserve content; fail names the rule."
    },
    {
      "concerns": [],
      "evidence": "Occupancy applies when the derived name already names “something.”",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADirectoryOccupiesIsNotTakenOver",
      "qualityCheck": "Direct directory occupant check.",
      "verifies": "Repair keeps the legacy mapping/file and derived-name directory; fail names the rule."
    },
    {
      "concerns": [],
      "evidence": "Names are never stored.rules; save/repair must never overwrite the index, and an existing derived path is occupied.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameEqualToTheIndexIsOccupiedAndNeverMovedOver",
      "qualityCheck": "Strong index-protection check.",
      "verifies": "Repair keeps the legacy mapping/content and byte-identical index when the strategy returns stored.rules; fail names the rule."
    },
    {
      "concerns": [],
      "evidence": "Each derived name is recorded/occupied by another entry, so neither occupied entry may move.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesThatWouldSwapNamesAreNotMoved",
      "qualityCheck": "Useful mutual-occupancy case.",
      "verifies": "Repair leaves both swapped mappings unchanged; fail subsequently names both rules."
    },
    {
      "concerns": [],
      "evidence": "A derived name shared by two rules is colliding; both entries are in that condition, and colliding entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "failNamesBothCollidingRulesEvenWhenOneAlreadyRecordsTheDerivedName",
      "qualityCheck": "Good collision completeness check.",
      "verifies": "Fail names both rules sharing one derived name; repair leaves the already-settled and legacy mappings/files unchanged."
    },
    {
      "concerns": [],
      "evidence": "“an entry recording its derived name is never occupied.”",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs",
      "qualityCheck": "Direct exemption and no-op-write check.",
      "verifies": "Fail names beta but not settled alpha; repair rewrites no index bytes and leaves all mappings/files/contents intact."
    },
    {
      "concerns": [],
      "evidence": "Fail reports every conditioned entry and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesCollidingEntriesAndChangesNothing",
      "qualityCheck": "Direct report/state check.",
      "verifies": "Fail names both colliding rules and leaves index plus both legacy files present."
    },
    {
      "concerns": [],
      "evidence": "Repair never moves colliding entries “but still discards one that is broken or resolved.”",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName",
      "qualityCheck": "Strong condition-precedence check.",
      "verifies": "Repair removes two resolved colliders and one broken collider with their applicable files, retaining only the violation-bearing colliding legacy entry/file/content."
    },
    {
      "concerns": [],
      "evidence": "Repair never moves occupied entries but still discards broken/resolved ones; unowned occupants are left alone.",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied",
      "qualityCheck": "Strong precedence and noninterference check.",
      "verifies": "Repair removes resolved/broken occupied entries, retains the violation-bearing occupied entry, and preserves all occupant files/content."
    },
    {
      "concerns": [],
      "evidence": "Occupancy includes a derived name “recorded by another entry,” and same-name entries are shared even if nothing exists.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt",
      "qualityCheck": "Direct absent-path occupancy case.",
      "verifies": "Repair keeps the misplaced legacy mapping because two other entries record its derived name despite no file there; shared entries remain, broken entry disappears, and fail names the misplaced rule."
    },
    {
      "concerns": [],
      "evidence": "A save never writes over “a file its own entry does not record” and rejection leaves index/folder unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn",
      "qualityCheck": "Strong retry and rollback check.",
      "verifies": "Two save attempts to an unowned derived file each throw; index bytes/entries, contains=false, filenames, and occupant content remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "A save may not overwrite a file its own entry does not record; rejected saves leave state unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingASecondUnknownRuleNeverTakesOverTheFirstRulesFile",
      "qualityCheck": "Good custom-strategy collision on save.",
      "verifies": "After first save, a second unknown rule deriving the same name is rejected; only first mapping/file/content remain."
    },
    {
      "concerns": [],
      "evidence": "Storing never writes outside the folder; rejected saves leave index and folder unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected",
      "qualityCheck": "Good unsafe-name matrix.",
      "verifies": "Escaping, nested, and rooted strategy names each reject save; outside/nested content and empty index remain unchanged, with no direct extra file."
    },
    {
      "concerns": [],
      "evidence": "A dangling link is still something the unknown rule’s entry does not own; save may not overwrite it.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleNeverTakesOverADanglingLink",
      "qualityCheck": "Direct no-follow save safety.",
      "verifies": "Save to a derived name occupied by a dangling symlink throws; the symlink remains and index stays empty."
    },
    {
      "concerns": [],
      "evidence": "Saving never writes over the index or outside the folder, and rejection is atomic.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected",
      "qualityCheck": "Strong existing-entry safety matrix.",
      "verifies": "Saves through ../, stored.rules, and absolute/rooted existing mappings each throw; outside/in-folder content and index bytes remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "Prompt requires unsafe-save rejection and unchanged state. Baseline healthy-save overwrite and LF form are visible at TextFileBasedViolationStore.java:145-154 and TextFileBasedViolationStoreTest.java:64-73.",
      "fairness": "Repo-discoverable",
      "name": "storingARuleWhoseEntryRecordsADanglingLinkNeverCreatesTheFileItPointsAt",
      "qualityCheck": "Good rejection isolation check.",
      "verifies": "Direct and chained dangling-link saves throw without creating the outside target or changing index bytes; an unrelated healthy rule remains saveable with expected LF content."
    },
    {
      "concerns": [],
      "evidence": "A still violated rule keeps its entry, and saves may write the file their own entry records but not the occupant.",
      "fairness": "Prompt-stated",
      "name": "storingAStillViolatedRuleWritesToItsOwnFileEvenWhenItsDerivedNameIsOccupied",
      "qualityCheck": "Strong known-versus-unknown distinction.",
      "verifies": "Known rule keeps/writes its legacy file despite occupied derived name; occupant stays unchanged; unknown rule gets its own derived name; final files/mappings match."
    },
    {
      "concerns": [],
      "evidence": "Prompt defines the linked target as owned and says a still violated rule keeps its entry; baseline save writes an existing entry’s recorded path at TextFileBasedViolationStore.java:145-180.",
      "fairness": "Repo-discoverable",
      "name": "storingAStillViolatedRuleWritesThroughTheLinkItsEntryRecords",
      "qualityCheck": "Thorough mode and link-write integration.",
      "verifies": "Under repair and ignore, a known link entry stays link-to-target and writes new content through it; repair removes the broken peer while ignore retains it; readback and file lists match."
    },
    {
      "concerns": [],
      "evidence": "“Storing a rule never writes over the index,” including aliases that resolve to it.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected",
      "qualityCheck": "Strong identity-based index protection.",
      "verifies": "Save through ./stored.rules, a symlink to the index, or a hard link to the index throws and preserves index bytes."
    },
    {
      "concerns": [],
      "evidence": "Storing never writes over the index; names are never stored.rules.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverTheIndex",
      "qualityCheck": "Direct strategy-path check.",
      "verifies": "A strategy returning stored.rules causes save to throw and leaves the index empty."
    },
    {
      "concerns": [],
      "evidence": "Prompt scopes forgetting to repair. Existing empty-save behavior retains and reads an empty entry at archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java:77-84.",
      "fairness": "Repo-discoverable",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "Good mode contrast.",
      "verifies": "Under repair, empty save removes entry/file; under ignore, empty save retains the entry and reads as no violations."
    },
    {
      "concerns": [],
      "evidence": "Prompt says “Under repair” empty save forgets; baseline ViolationStore.save overwrites rather than removes at ViolationStore.java:56-63 and TextFileBasedViolationStoreTest.java:77-84.",
      "fairness": "Repo-discoverable",
      "name": "onlyRepairForgetsAResolvedRuleWhileFailKeepsIt",
      "qualityCheck": "Fair mode-scope check.",
      "verifies": "Empty save after repair removes the mapping; empty save after successful fail initialization retains it."
    },
    {
      "concerns": [],
      "evidence": "Forget discards the entry, but a shared file is not deleted; nothing outside may be touched.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Strong safety/precedence check.",
      "verifies": "Empty repair-save removes only the selected shared escaping entry, retains its peer mapping, and preserves outside file/content."
    },
    {
      "concerns": [],
      "evidence": "Forgetting discards the file “unless another entry shares that file.”",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Direct shared-file exception.",
      "verifies": "Empty repair-save removes only forgotten rule; both alias names and shared target remain, peer still reads its violation."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "“If that file cannot be deleted, the save is rejected and the entry stays.”",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "Semantically strong, but POSIX modes, setpriv, UID 65534, and executable availability are environment-specific.",
      "verifies": "When deletion is denied, forget returns rejected and preserves index bytes/file content; after permissions are restored, forget succeeds and leaves only the index."
    },
    {
      "concerns": [],
      "evidence": "Under repair, empty save “stores nothing for an unknown rule.”",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct unknown-rule check.",
      "verifies": "Under repair, saving an empty list for an unknown rule leaves the index empty and only stored.rules present."
    },
    {
      "concerns": [],
      "evidence": "“A still violated rule keeps its entry.”",
      "fairness": "Prompt-stated",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Direct counterpart to forgetting.",
      "verifies": "Repair plus nonempty save leaves only the known entry and readback is exactly the remaining violation."
    },
    {
      "concerns": [],
      "evidence": "With description, the name derives from the rule description and keeps a whole 4–120 letter/digit word.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionShowTheRuleTheyStore",
      "qualityCheck": "Direct recognizability check.",
      "verifies": "Description mode creates one file whose name contains a whole qualifying description word and is indexed by that name."
    },
    {
      "concerns": [],
      "evidence": "Description naming is deterministic from the rule description.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameInALaterRun",
      "qualityCheck": "Direct determinism check.",
      "verifies": "The same description stored in two folders/runs gets exactly the same filename."
    },
    {
      "concerns": [],
      "evidence": "A name derived deterministically from the description cannot depend on machine settings; built-in alphabet and bound are explicit.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameOnAnotherMachine",
      "qualityCheck": "Strong determinism test, though launching child JVMs introduces portability assumptions covered in overall.",
      "verifies": "Separate JVMs with differing user/home/temp/locale/encoding produce equal ASCII names <=200 that contain a qualifying whole word."
    },
    {
      "concerns": [],
      "evidence": "Description names derive deterministically from the description, not store contents.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds",
      "qualityCheck": "Discriminates contextual allocation from derivation.",
      "verifies": "The same rule gets the same filename in an empty versus pre-populated store."
    },
    {
      "concerns": [],
      "evidence": "“Names differ per rule” and description names keep a whole qualifying word.",
      "fairness": "Prompt-stated",
      "name": "twoRulesReadingAlikeStillGetDifferentNames",
      "qualityCheck": "Strong collision and readback suite.",
      "verifies": "Eight similar/case/punctuation/long-prefix descriptions each get a filename containing a whole qualifying word; names have no duplicates, files exactly match, and every violation reads back for the right rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly constrains built-in alphabet, bound, and retained word.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
      "qualityCheck": "Direct sanitization case.",
      "verifies": "A punctuated long description produces an ASCII [A-Za-z0-9_-]+ name <=200 containing a whole qualifying word, with only that file and index."
    },
    {
      "concerns": [],
      "evidence": "A whole word of 4 to 120 characters must be retained even late in a long description.",
      "fairness": "Prompt-stated",
      "name": "aLongWordAfterOnlyShortOnesStillYieldsABoundedName",
      "qualityCheck": "Tests the inclusive upper boundary.",
      "verifies": "A description ending in one 120-character word gets a stable ASCII name <=200 that contains a qualifying whole word in both runs."
    },
    {
      "concerns": [],
      "evidence": "A qualifying word may come late; letters or digits of length at least four qualify.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt",
      "qualityCheck": "Tests late placement and inclusive lower boundary.",
      "verifies": "Late controllers and late 1234 each survive as a whole qualifying word in distinct ASCII names <=200; final files match both entries."
    },
    {
      "concerns": [],
      "evidence": "The retained word must be whole and at most 120, even when it comes late.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordBeforeIt",
      "qualityCheck": "Discriminates skipping from truncating an overlong word.",
      "verifies": "A 121-character leading word is skipped and the late whole word controllers appears in an ASCII bounded name."
    },
    {
      "concerns": [],
      "evidence": "The name must keep a whole 4–120 character word, not a cut fragment.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordAfterIt",
      "qualityCheck": "Good opposite-position boundary case.",
      "verifies": "The qualifying leading controllers remains whole; a following 121-character word is not used as a fragment; name is ASCII/bounded."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a “whole word,” including in long descriptions.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordBeginningWithIt",
      "qualityCheck": "Strong anti-prefix-overfit case.",
      "verifies": "The filename has a genuine whole qualifying word rather than merely the same letters at the start of a 121-character word; name is ASCII/bounded and readback succeeds."
    },
    {
      "concerns": [],
      "evidence": "Description naming is deterministic and built-in names use only the stated ASCII alphabet; the word-retention clause has no qualifying word here.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionWithoutAnyPlainCharacterStillYieldsAStableName",
      "qualityCheck": "Good fallback-name case.",
      "verifies": "Punctuation-only description gets a nonempty ASCII-safe filename stable across two runs, with only index plus that file."
    },
    {
      "concerns": [],
      "evidence": "Built-in names are ASCII/bounded, deterministic, and differ per rule.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionOfOnlyNonAsciiCharactersStillYieldsAStableAsciiName",
      "qualityCheck": "Good Unicode fallback and uniqueness check.",
      "verifies": "Non-ASCII-only descriptions get distinct ASCII names, the checked name is <=200, and the same description is stable across runs."
    },
    {
      "concerns": [],
      "evidence": "Prompt defines description naming; ordered save/read round-trip is existing behavior at TextFileBasedViolationStoreTest.java:52-61 and 86-100.",
      "fairness": "Repo-discoverable",
      "name": "violationsAreReadBackFromANameTakenFromTheDescription",
      "qualityCheck": "Good naming/readback integration.",
      "verifies": "A fresh reader returns the two saved violations in order and the indexed filename contains a qualifying whole word."
    },
    {
      "concerns": [],
      "evidence": "A differing entry is misplaced and repair moves it to the rule’s derived description name.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingALegacyNameIsMovedToTheNameTakenFromTheDescription",
      "qualityCheck": "Direct migration case.",
      "verifies": "Description-mode repair changes away from the UUID-like legacy name to one containing a qualifying word, removes legacy path, and preserves exact content."
    },
    {
      "concerns": [],
      "evidence": "Names are never stored.rules while description names retain a qualifying whole word.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionNeverCollideWithTheIndex",
      "qualityCheck": "Direct reserved-name check.",
      "verifies": "A rule whose description is stored.rules gets a different derived filename that still contains stored.rules as a whole word."
    },
    {
      "concerns": [],
      "evidence": "“It writes the index only when an entry changed.”",
      "fairness": "Prompt-stated",
      "name": "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
      "qualityCheck": "Checks both directions of the write policy.",
      "verifies": "Repair leaves a consistent index byte-identical, while repair of a store where a broken entry is removed produces different index bytes."
    },
    {
      "concerns": [],
      "evidence": "Repair leaves shared/unowned findings alone and writes only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex",
      "qualityCheck": "Good distinction between finding and changing.",
      "verifies": "Shared/unowned findings leave a hand-written index byte-identical and entries unchanged; fail still reports the unowned file."
    },
    {
      "concerns": [],
      "evidence": "Repair writes the index only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "arepairThatChangesNothingLeavesTheIndexByteIdentical",
      "qualityCheck": "Useful repeated-run check.",
      "verifies": "After first repair changes the index, a second no-op repair leaves its bytes identical."
    },
    {
      "concerns": [],
      "evidence": "Repair/fail “examine the index and the folder while initializing,” so they must inspect current disk state rather than stale process cache.",
      "fairness": "Prompt-stated",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "Important same-process cache invalidation check.",
      "verifies": "After an ignore initialization, replacing the disk index with a different broken entry is observed by a later repair, which leaves the index empty."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Problem description have appropriate length (target: 100-200 words)**

Status: WARNING

Description is verbose (627 words, over target by 127). Consider trimming to ≤500 words.

```json
{
  "errorThreshold": 1000,
  "target": 500,
  "warningThreshold": 500,
  "wordCount": 627
}
```

---

**Problem description doesn't look AI-generated (line wrapping, em-dashes)**

Status: WARNING

Description formatting looks AI-generated. Rewrite naturally (or paste from a normal editor) to make this signal go away:

- 2 paragraphs are 150+ words of unbroken prose. Break long prose into bullets or shorter paragraphs — wall-of-text dense paragraphs are a common AI-output shape.

*This is a heuristic warning — adjust the wording and structure to match how you'd write it for a human teammate.*

```json
{
  "blankLineRuns": 0,
  "emdashes": 0,
  "hardwrappedParagraphs": 0,
  "signals": [
    {
      "detail": "2 paragraphs are 150+ words of unbroken prose. Break long prose into bullets or shorter paragraphs — wall-of-text dense paragraphs are a common AI-output shape.",
      "kind": "wall_of_text"
    }
  ],
  "wallOfText": 2,
  "wordCount": 623
}
```

---

**Shipd Bot Description Warnings**

> "`default.fileNames` names new files and defaults to `random`."

Keep the tested option names and values, but split this dense filename-policy paragraph into shorter sentences. For example: “`default.fileNames` controls names for new files and defaults to `random`. With `description`, derive the name deterministically from the rule description. Description-based names must be unique per rule, ASCII-safe, at most 200 characters, distinct from `stored.rules`, and retain a whole 4–120-character alphanumeric word.” Then state the custom-strategy rules separately. This preserves the requirements while making each rule immediately scannable. _(marked resolved, but the sentence is still in the description)_

> "A strategy given to the constructor names files the same way, and configuring"

This is a comma splice at the end of an already dense naming paragraph. Split it into direct sentences: “A strategy supplied to the constructor controls file naming. Reject `default.fileNames` when the store was constructed with a strategy.” Keep the preceding strategy-validation requirements unchanged. _(marked resolved, but the sentence is still in the description)_

> "An entry is broken when its resolved path is missing, a directory, outside the folder,"

The classification paragraph packs five definitions and their precedence into a run of similarly shaped sentences, making the reader repeatedly re-parse it. Present the same definitions as a short, flat list (broken, resolved, misplaced, shared, colliding, occupied, unowned), followed by one sentence: “Shared takes precedence over every other condition; leave shared, colliding, occupied, and unowned findings unchanged.” This is a presentation rewrite only; retain all listed conditions. _(marked resolved, but the sentence is still in the description)_

> "Two entries recording the same name are shared, even if nothing exists under that name."

Split the condition definitions into short, named sentences so their relationships do not have to be reconstructed from one dense paragraph. For example: “Entries are shared when they record the same name or resolve to the same file, including through a link. Shared entries and unowned files are left alone. A shared entry remains shared even when another condition also applies.” Keep the subsequent broken/resolved/misplaced/colliding/occupied rules and their precedence unchanged. _(marked resolved, but the sentence is still in the description)_

> "So are two entries whose recorded names resolve to one file, as when one links to that file."

Replace the dangling "So are" with: "Entries are also shared when their recorded paths resolve to the same file—for example, when one entry records a symlink to the file another records." This states the subject and rule directly without changing the shared-reference semantics. _(marked resolved, but the sentence is still in the description)_

> "A misplaced entry is occupied when its derived name already names something, is recorded"

Rewrite the full rule as two sentences: "A misplaced entry is occupied if its derived name already exists, is recorded by another entry, or resolves outside the folder. An entry that already records its own derived name is not occupied." Keep the existing remaining cases, but avoid packing them into one multi-clause sentence with an unclear "something" referent. _(marked resolved, but the sentence is still in the description)_

> "`repair` discards broken entries. It discards resolved entries with the files they name, deleting a link's target with the link."

The repair/fail paragraph combines mutation rules, error reporting, ordering, permissions, and index preconditions in one dense block. Separate it into a repair paragraph, a fail paragraph, and a short preconditions paragraph. For example, begin: “In `repair`, discard broken entries. For an unshared resolved entry, remove its index entry and owned file; if it is a link, remove both the link and its in-folder target.” Preserve the existing ordering and permission details verbatim in their respective paragraphs. _(marked resolved, but the sentence is still in the description)_

> "An entry both shared and something else stays shared."

Use an explicit subject and predicate: “An entry that is shared and also meets another condition remains shared.” This preserves the precedence rule while avoiding the compressed “shared and something else” construction. _(marked resolved, but the sentence is still in the description)_

> "`repair` discards broken entries."

Present the `repair` and `fail` policies as separate short paragraphs. For example, start repair with “In `repair` mode, remove broken entries; remove resolved entries and their owned files; and relocate safe misplaced entries.” Follow with the shared/colliding/occupied exceptions and index-write condition. Then state the `fail` reporting and ordering rules in its own paragraph. This is presentation-only: retain every named condition, ordering requirement, permission rule, and absent-index behavior. _(marked resolved, but the sentence is still in the description)_

> "It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it."

State the report ordering in two sentences: “In `fail` reports, list broken, resolved, and shared entries, followed by unowned files. Misplaced, colliding, and occupied entries may appear anywhere.” The semantics and every tested condition remain unchanged, but the ordering rule no longer has to be extracted from a compound sentence. _(marked resolved, but the sentence is still in the description)_

> "Storing a rule never writes over the index, anything outside the folder, or a file its own entry does not record."

Make the prohibited save targets explicit: “Reject a save if its target is the index, outside the store folder, or a file not recorded by that rule’s own entry. Leave the index and folder unchanged when rejecting it.” The current coordination of “writes over” across three unlike objects makes the safety rule needlessly difficult to parse. _(marked resolved, but the sentence is still in the description)_

> "Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress."

Split the two concurrency guarantees: “Concurrent initialization and saves in one process must leave a readable index and only the index plus surviving files. Initialization must not examine a save that is still in progress.” This removes the overloaded coordination without changing the requirement. _(marked resolved, but the sentence is still in the description)_

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 5 total suggestions (mix of medium/low) targeting redundant examples, code-discoverable details, and over-specification. Having 3 or more suggestions requires a request_changes verdict per the guidelines.",
  "suggestions": [
    {
      "priority": "medium",
      "quote": "Add integrity maintenance for `TextFileBasedViolationStore`'s `stored.rules` index and files.",
      "suggestion": "Remove the explicit index filename `stored.rules` here (keep the core task statement). The concrete index name is discoverable from the codebase and repeated elsewhere."
    },
    {
      "priority": "medium",
      "quote": "Names differ per rule, and each keeps a whole word of 4 to 120 letters or digits, even one that comes late in a long description.",
      "suggestion": "Cut the example clause “even one that comes late in a long description.” It’s implied by the word-length rule and adds verbosity without new requirements."
    },
    {
      "priority": "low",
      "quote": "It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it.",
      "suggestion": "Remove “and may place misplaced, colliding and occupied entries anywhere in it.” Leaving their order unspecified is the default; only retain the required ordering for the listed categories."
    },
    {
      "priority": "low",
      "quote": "A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store is rejected.",
      "suggestion": "Drop the clause “A strategy given to the constructor names files the same way,” as it’s obvious from passing a strategy; keep the rejection rule about also configuring `default.fileNames`."
    },
    {
      "priority": "low",
      "quote": "Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress.",
      "suggestion": "Trim the middle clause “and a folder holding only the index and survivors' files,” since that outcome is already implied by the earlier repair semantics; keep the concurrency guarantees (readable index, no examining an in-progress save)."
    }
  ],
  "summary": "- [MEDIUM] Remove the explicit index filename in the opener: “Add integrity maintenance for TextFileBasedViolationStore’s stored.rules index and files.” Keep the task statement but drop “stored.rules” — the index name is discoverable from code and not needed here.\n- [MEDIUM] Trim the example from the naming rule: “even one that comes late in a long description.” The key requirement is keeping a whole word of 4–120 letters/digits; the example adds no new constraint.\n- [LOW] In the fail-report ordering sentence, drop “and may place misplaced, colliding and occupied entries anywhere in it.” Unspecified order is the default; only the mandated ordering needs to be stated.\n- [LOW] In “A strategy given to the constructor names files the same way, and configuring default.fileNames for such a store is rejected.” remove the obvious clause “names files the same way” and keep only the actionable rejection rule.\n- [LOW] In the concurrency sentence, remove “and a folder holding only the index and survivors’ files,” since that’s implied by the repair semantics already described; keep the guarantees about a readable index and not examining in-progress saves.",
  "verdict": "request_changes"
}
```

---

**Description Quality**

```json
{
  "completed": true,
  "evaluation": {
    "comments": [
      {
        "category": "tone",
        "presentationOnly": true,
        "quote": "A misplaced entry is occupied when its derived name already names something,",
        "severity": "minor",
        "suggestion": "Split and name the cases explicitly: “Treat a misplaced entry as occupied if its derived name already exists, is recorded by another entry, or resolves outside the folder. An entry that already records its derived name is not occupied.” This retains the rule but avoids making the reader resolve several different meanings of “name” across a semicolon.",
        "testPatchCheck": {
          "foundInTestPatch": true,
          "reasoning": "The patch has dedicated occupied-entry tests, including derived names occupied by files, links, directories, and other recorded entries.",
          "searchedFor": "occupied; derived name; another entry"
        }
      },
      {
        "category": "tone",
        "presentationOnly": true,
        "quote": "Storing a rule never writes over the index, anything outside the folder, or a file its own entry does not record.",
        "severity": "minor",
        "suggestion": "Use a direct permission rule: “A save may write only the regular file recorded by that rule’s own index entry; it must not write the index or anything outside the folder.” The existing construction makes “a file its own entry does not record” unnecessarily hard to parse while preserving the same safety constraints.",
        "testPatchCheck": {
          "foundInTestPatch": true,
          "reasoning": "The patch includes tests for saves that must not overwrite unowned files or the index, write outside the folder, or follow unsafe recorded paths.",
          "searchedFor": "storing never overwrites; index; outside the folder"
        }
      },
      {
        "category": "tone",
        "presentationOnly": true,
        "quote": "Stores initializing or saving concurrently in one process leave a readable index",
        "severity": "minor",
        "suggestion": "Split the final concurrency guarantee into two sentences: “Concurrent initialization and save operations in one process must leave the index readable and retain only the index plus surviving violation files. Initialization must not examine a save that is still in progress.” This keeps the tested guarantees but makes the two independent synchronization requirements immediately visible.",
        "testPatchCheck": {
          "foundInTestPatch": true,
          "reasoning": "The patch contains concurrent initialization, concurrent repair/fail, and initialization-while-save tests that assert a readable index and waiting for the in-progress save.",
          "searchedFor": "concurrent; readable index; save still in progress"
        }
      }
    ],
    "formattingChecks": {
      "hardWrap": {
        "detected": false,
        "evidence": "",
        "note": "The raw description uses paragraph breaks rather than recurring fixed-column, mid-sentence line breaks."
      },
      "headerScaffolding": {
        "detected": false,
        "evidence": "",
        "note": "There are no markdown section headers in the problem description; it is structured as prose paragraphs."
      },
      "titleDuplication": {
        "detected": false,
        "evidence": "",
        "note": "The problem description begins directly with “Add integrity maintenance…”; the separate title metadata is not repeated as a markdown heading."
      }
    },
    "summary": "The task is technically precise and matches the tested surface, but three dense, compound requirements should be split into plainer prose.",
    "verdict": "FAIL",
    "verdictBasis": {
      "dropped": [],
      "majors": 0,
      "minors": 3,
      "unanchoredFormattingDetections": 0
    }
  },
  "executionTimeSeconds": 166.709217,
  "summary": "The task is technically precise and matches the tested surface, but three dense, compound requirements should be split into plainer prose.",
  "verdict": "FAIL"
}
```
