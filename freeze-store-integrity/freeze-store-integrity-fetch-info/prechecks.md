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
        "Different repositories and domains: Java ArchUnit freeze-store filesystem/index integrity vs. Python SQLFluff rule-level autofix convergence.",
        "Submission modifies TextFileBasedViolationStore and introduces StoreIntegrity and file-naming strategy classes to validate/repair an on-disk index and files; candidate adds convergence tracking (PhaseFixHistory/FixConvergenceTracker) and changes the fix loop and replay logic to attribute and suppress specific rules.",
        "Submission’s behavior is about filesystem safety, index reconciliation (broken/resolved/misplaced/shared/colliding/occupied/unowned), and deterministic file naming; candidate’s behavior is about detecting cycles or pass-limit divergence per phase, probing boundary rules, and replaying fixes without implicated rules to ensure a stable output.",
        "Submission introduces new configuration keys (default.fileNames, default.integrity) and enforces store ownership/creation/update constraints; candidate leaves config intact and augments linter execution, result aggregation, and reporting of attributed rules per file.",
        "Languages and layers differ: submission is a storage/index layer feature in Java; candidate is core linter algorithm/control flow in Python."
      ],
      "one_liner": "One adds deterministic file naming and integrity reconciliation for ArchUnit’s text-based freeze-store, the other attributes non-converging autofix loops in SQLFluff to specific rules and replays fixes without them to preserve stable changes.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The two patches target unrelated projects and layers. The ArchUnit change adds filesystem/index integrity and file-naming strategy handling in a freeze-store; the SQLFluff change reworks the fix loop to attribute non-convergence to specific rules and replays without them. No purpose-matched files, APIs, or behaviors overlap beyond generic notions of ‘integrity’ or ‘stability,’ which are domain-generic and not the same task.",
      "similarity": 0.6047085523605347,
      "submission_summary": "Extends ArchUnit’s TextFileBasedViolationStore to support configurable file naming (random, description-derived, or custom strategy) and an integrity mode (ignore/repair/fail) that validates and optionally repairs the index and files; adds StoreIntegrity to classify and act on broken/resolved/misplaced/shared/colliding/occupied entries, enforces safe ownership before writing, and updates docs.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.94,
      "contentAuthoredAt": 1786876774252,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: Java ArchUnit freeze store vs. Go nftables ruleset management.",
        "Submission modifies TextFileBasedViolationStore to add file-naming strategies and on-disk integrity modes (ignore/repair/fail), including symlink-aware moves/deletes; candidate adds an in-memory RulesetStore with transactions, OCC conflict detection, rebase, and serialization of concurrent transactions.",
        "Submission’s behavior centers on validating and reconciling an index file with a folder of rule-violation files; candidate’s behavior centers on staging, anchoring, committing, and ordering nftables rules, sets, and objects with handles and IDs.",
        "Surfaces changed are unrelated: new Java classes RuleDescriptionFileNames, RuleViolationFileNameStrategyFactory, StoreIntegrity, and substantial changes to TextFileBasedViolationStore vs. new Go files occ_store.go/occ_tx.go/... integrating with nftables types and paths (#handle, ~id, gaps)."
      ],
      "one_liner": "One adds deterministic file naming and integrity checking/repair to a Java file-based violation store; the other implements an in-memory, versioned nftables ruleset store with optimistic concurrency and transactional staging in Go.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "There is no purpose-matched surface or behavioral overlap: the submission introduces file naming strategies and store-integrity checking/repair in ArchUnit’s TextFileBasedViolationStore, while the candidate implements an optimistic-concurrency, transactional ruleset store for nftables. No shared APIs, tests, or repo surfaces exist; any shared vocabulary (e.g., “store”) is generic framework language, not a shared task.",
      "similarity": 0.6016160845756531,
      "submission_summary": "Extends ArchUnit’s TextFileBasedViolationStore to support configurable file naming (random, derived from rule descriptions, or custom strategy) and an integrity mode (ignore/repair/fail) that reconciles the index with on-disk files, handling symlinks, empty files, misplaced/colliding names, and safe ownership semantics. Modifies initialization, save behavior, and index file synchronization while adding StoreIntegrity and naming strategy factory implementations, with documentation updates.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.93,
      "contentAuthoredAt": 1784870646197,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and storage layers: one targets ArchUnit’s TextFileBasedViolationStore filesystem index/files; the other targets Qdrant’s Gridstore per-record encoding/decoding and storage APIs.",
        "Submission implements store-folder/index reconciliation with modes (ignore/repair/fail), file naming strategies, moving/deleting files, and strict ownership checks; candidate implements a versioned record format with CRC32C headers, end-to-end read validation, integrity auditing of occupied points, and a migration to checksummed format.",
        "Submission’s scope includes symlink handling, canonical path resolution, derived filename conflicts, unowned files, and empty-file semantics; candidate’s scope includes header parsing errors, checksum/length validation, decompression failure handling, and preserving corrupt entries during delete."
      ],
      "one_liner": "Both add integrity-related features to storage systems, but in different repos and layers: one reconciles a files-and-index freeze store, the other adds checksummed record I/O with auditing and migration for a gridstore.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The two patches modify different systems for different integrity concerns at different surfaces. The submission augments a filesystem-backed violation store with index/folder reconciliation and naming strategy selection in ArchUnit, while the candidate augments Qdrant’s Gridstore with a checksummed record format, audit reporting, and migration. There is no purpose-matched shared API or test behavior; any overlap is limited to the generic notion of “integrity,” not a shared task or surface.",
      "similarity": 0.5721481442451477,
      "submission_summary": "Adds integrity maintenance to TextFileBasedViolationStore: new default.fileNames strategies (random/description/custom), integrity modes (ignore/repair/fail) that reconcile the stored.rules index with the store folder (detecting broken/resolved/misplaced/shared/colliding/occupied/unowned) and optionally repairing by discarding or moving files. Modifies TextFileBasedViolationStore to enforce ownership checks, canonicalize names, handle symlinks/line breaks, run operations exclusively, and update docs.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.97,
      "contentAuthoredAt": 1787009515981,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: one modifies ArchUnit’s Java freeze violation store (index + violation files); the other modifies SurrealKV’s Rust engine (options manifest, B+ tree, WAL, VLog, checkpoints).",
        "Submission adds a configurable integrity mode (ignore/repair/fail) to reconcile a text-file index with per-rule files, including detecting broken/resolved/misplaced/shared/colliding/occupied entries and moving/deleting files; candidate persists and enforces a binary options manifest (SKVOPTS) with atomic publication and strict compatibility checks.",
        "Submission introduces a deterministic file-naming strategy from rule descriptions; candidate introduces a durable identity record and extends checkpoint/restore validation across manifests, SSTables, WAL ranges, VLog, and versioned-index state.",
        "Submission’s scope centers on initialization and save-time reconciliation of one store folder’s index/files with symlink and path-safety semantics; candidate’s scope spans engine-wide invariants (structure validation of B+ tree, overflow reading safety, error variants) and checkpoint creation/restore ordering guarantees."
      ],
      "one_liner": "Both add integrity/consistency mechanisms to persistent storage, but in different repositories and for very different storage surfaces and behaviors.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The patches target different systems and purpose-matched surfaces: ArchUnit’s TextFileBasedViolationStore gains integrity reconciliation and file-naming strategies, while SurrealKV gains a durable OPTIONS manifest with atomic publication, compatibility enforcement, and extensive checkpoint/restore validation plus tree/overflow safety. There is no shared file, API surface, or behavior unique enough to indicate the same task; any thematic similarity (integrity/validation) is generic. Thus they are distinct.",
      "similarity": 0.5567674040794373,
      "submission_summary": "Adds integrity maintenance to ArchUnit’s TextFileBasedViolationStore: a new StoreIntegrity component classifies and optionally repairs index/file inconsistencies during initialization, enforces safe ownership on saves, and introduces configurable integrity modes and deterministic or custom file-naming strategies. It augments TextFileBasedViolationStore with synchronized index access, path/symlink handling, and updated docs.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.95,
      "contentAuthoredAt": 1785764499698,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission modifies the freeze store (com.tngtech.archunit.library.freeze) to add file-naming strategies, integrity modes (ignore/repair/fail), and filesystem/index reconciliation, including moving/deleting files and rejecting unsafe saves; candidate modifies the bytecode importer (com.tngtech.archunit.core.importer) to detect and deduplicate duplicate accesses cloned into finally handlers.",
        "Submission introduces RuleDescriptionFileNames and RuleViolationFileNameStrategyFactory and wires them into TextFileBasedViolationStore with new properties (default.fileNames, default.integrity) and synchronization around index/file writes; candidate introduces FinallyAccessNormalizer and wraps JavaClassProcessor’s MethodVisitor to filter duplicate access instructions based on ASM tree analysis.",
        "Submission’s observable behavior concerns what files exist/move/delete on disk and how the store initializes/saves; candidate’s behavior concerns which accesses are exposed downstream from imported code units, ensuring each source-level operation appears once across all views.",
        "Submission touches user docs to surface new freeze.store.* settings; candidate updates build scripts/dependencies (asm-tree) and importer code paths without changing the freeze store."
      ],
      "one_liner": "One adds configurable naming and on-disk/index integrity handling for the freeze violation store; the other normalizes away compiler-cloned finally-block accesses during bytecode import.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The two patches target different subsystems and purposes within the same repo. The submission changes the freeze violation store’s file naming and integrity lifecycle, adding repair/fail logic and guarding file ownership at save time. The candidate changes the class importer to normalize duplicate finally-block accesses using ASM-tree and a filtering visitor. There is no shared modified surface or overlapping observable behavior; similarities are only thematic (consistency) and not purpose-matched.",
      "similarity": 0.36720684293256767,
      "submission_summary": "Extends TextFileBasedViolationStore with configurable file-naming strategies and an integrity mode that classifies and repairs or reports inconsistencies between the index and store folder. Adds StoreIntegrity and related helpers to move/delete files, validate ownership, and coordinate index updates, plus docs for new properties.",
      "verdict": "distinct"
    }
  ]
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
  "executionTimeSeconds": 235.323953,
  "message": "All hidden tests are fair.",
  "overall": "PASS: all present hidden-test expectations are predictable from the prompt or, for the two legacy empty-save contrasts and one FreezingArchRule integration behavior, from visible repository behavior. No test is unfair. The suite is unusually comprehensive and generally asserts externally visible state rather than implementation internals. Advisory quality finding shared by a group rather than repeated per test: tests using symbolic links, hard links, absolute-root spellings, POSIX permissions, WatchService behavior, and external `setpriv`/JVM processes assume a Unix-like filesystem/runtime with link and process support. The benchmark harness should pin that environment or skip unsupported cases. Concurrency tests also use finite waits; those test-specific timing concerns are marked above.",
  "requirements": [
    {
      "covered": "yes",
      "coveringTests": [
        "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
        "randomFileNamesDeriveNothingSoNoEntryIsMisplaced"
      ],
      "requirement": "default.fileNames defaults to random and names new files.",
      "sourceQuote": "`default.fileNames` names new files and defaults to `random`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aRuleKeepsTheSameNameInALaterRun",
        "twoRulesReadingAlikeStillGetDifferentNames",
        "aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt",
        "aWordWorthKeepingSurvivesAnOverlongWordBeforeIt",
        "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
        "namesTakenFromTheDescriptionNeverCollideWithTheIndex"
      ],
      "requirement": "Description naming is deterministic, distinct per rule, retains a qualifying whole word even late, uses the safe ASCII alphabet, is at most 200 chars, and avoids stored.rules.",
      "sourceQuote": "With `description`, the name derives deterministically from the rule description. Names differ per rule, and each keeps a whole word of 4 to 120 letters or digits, even one that comes late in a long description. Built-in names use only ASCII letters, digits, underscores and hyphens. They never exceed 200 characters and are never `stored.rules`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves",
        "aStrategyThatCannotBeInstantiatedIsRejected",
        "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected"
      ],
      "requirement": "A non-built-in fileNames value denotes a strategy implementation with a public no-arg constructor.",
      "sourceQuote": "Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore",
        "aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore"
      ],
      "requirement": "A no-name strategy is rejected when a name is first needed.",
      "sourceQuote": "A strategy that yields no name is rejected as soon as a name is needed."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
        "aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing"
      ],
      "requirement": "Constructor strategy behavior matches configured strategy behavior and conflicts with default.fileNames configuration.",
      "sourceQuote": "A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store is rejected."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "valuesNearAnAcceptedValueAreRejected"
      ],
      "requirement": "default.integrity accepts exactly repair/fail/ignore and defaults to ignore; ignore examines nothing.",
      "sourceQuote": "`default.integrity` accepts the exact values `repair`, `fail` and `ignore`, and defaults to `ignore`, which examines nothing."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "unknownValueIsRejectedAndNamesTheAcceptedValues"
      ],
      "requirement": "Unknown integrity values are rejected while naming all accepted values.",
      "sourceQuote": "Any other value is rejected, naming the three accepted."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives"
      ],
      "requirement": "Broken covers missing, directory, outside, and non-regular/non-direct paths.",
      "sourceQuote": "An entry is broken when its resolved path is missing, a directory, outside the folder, or not a regular file directly in it."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
        "carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved"
      ],
      "requirement": "Resolved means no violations, including all listed line-break-only forms, while embedded carriage returns remain text.",
      "sourceQuote": "An entry is resolved when the file at that path yields no violations, including a file holding only line breaks, whether `\\n`, `\\r\\n` or a lone `\\r`, although a carriage return inside a stored violation stays part of its text."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
        "failNamesMisplacedEntriesAndChangesNothing"
      ],
      "requirement": "Misplaced means recorded name differs from derived name.",
      "sourceQuote": "An entry is misplaced when its name is not its rule's derived one."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair"
      ],
      "requirement": "Same recorded name and aliases resolving to one file are shared, including absent names.",
      "sourceQuote": "Two entries recording the same name are shared, even if nothing exists under that name. So are two entries whose recorded names resolve to one file, as when one links to that file."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
        "failNamesBothCollidingRulesEvenWhenOneAlreadyRecordsTheDerivedName"
      ],
      "requirement": "Two rules with one derived name are colliding.",
      "sourceQuote": "One derived name two rules share is colliding."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aDerivedNameAnUnownedFileOccupiesIsNotTakenOver",
        "twoEntriesThatWouldSwapNamesAreNotMoved",
        "aDerivedNameLeavingTheStoreFolderIsNeverUsed",
        "anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs"
      ],
      "requirement": "Occupied includes existing objects, names recorded elsewhere, and escaping names, except an entry already recording its own derived name.",
      "sourceQuote": "A misplaced entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder; an entry recording its derived name is never occupied."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "aDirectoryInTheStoreFolderIsNeverACondition",
        "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
        "theIndexItselfIsNeverUnowned"
      ],
      "requirement": "Direct unrecorded regular files other than the index are unowned.",
      "sourceQuote": "Apart from the index, a regular file directly in the folder that no entry records is unowned."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
        "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName",
        "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied"
      ],
      "requirement": "Shared and unowned findings are left alone; colliding/occupied are not moved; broken/resolved are still discarded; shared takes precedence.",
      "sourceQuote": "The store leaves shared entries and unowned files alone. It never moves a colliding or occupied entry, but still discards one that is broken or resolved. An entry both shared and something else stays shared."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "everyBrokenEntryIsDiscarded"
      ],
      "requirement": "Repair discards broken entries.",
      "sourceQuote": "`repair` discards broken entries."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt"
      ],
      "requirement": "Repair discards resolved entries/files and removes both link and target.",
      "sourceQuote": "It discards resolved entries with the files they name, deleting a link's target with the link."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
        "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt"
      ],
      "requirement": "Repair moves misplaced files to derived names and moves link targets rather than links.",
      "sourceQuote": "It moves a misplaced entry's file to its derived name, moving a link's target rather than the link."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
        "aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex",
        "arepairThatChangesNothingLeavesTheIndexByteIdentical"
      ],
      "requirement": "Repair rewrites the index only when an entry changed.",
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
      "requirement": "Fail reports all entry conditions and unowned files in required condition and within-condition orders.",
      "sourceQuote": "Its report names every entry in any condition and every unowned file. It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it. Within a condition it orders entries by rule description and files by name."
    },
    {
      "covered": "yes",
      "coveringTests": [
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
        "anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined",
        "anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired"
      ],
      "requirement": "Invalid/absent index preconditions are rejected before examination.",
      "sourceQuote": "An absent index without `default.allowStoreCreation`, or one not a regular file directly in the folder, is rejected before anything is examined."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingARuleNeverWritesOverTheIndex",
        "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn",
        "storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected",
        "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected"
      ],
      "requirement": "Save never overwrites the index, outside content, or another file and rejection is atomic.",
      "sourceQuote": "Storing a rule never writes over the index, anything outside the folder, or a file its own entry does not record. Such a save is rejected, leaving the index and the folder as they were."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
        "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
        "aStillViolatedRuleKeepsItsEntryUnderRepair"
      ],
      "requirement": "Under repair, empty save forgets a known rule and file unless shared, stores nothing for unknown rules, rejects failed deletion while retaining entry, and nonempty save keeps entry.",
      "sourceQuote": "Under `repair`, storing no violations forgets a known rule, discarding its entry and its file unless another entry shares that file, and stores nothing for an unknown rule. If that file cannot be deleted, the save is rejected and the entry stays. A still violated rule keeps its entry."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "concurrentInitializationsLeaveAReadableIndex",
        "examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave",
        "oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind",
        "repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved",
        "repairingTheFolderWhileAnotherStoreSavesIntoAnEmptiedFileKeepsTheEntryAndTheFile"
      ],
      "requirement": "Concurrent in-process initialization/save leaves readable survivor-only state and hides in-progress saves from examination.",
      "sourceQuote": "Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress."
    }
  ],
  "taskSummary": "Implement configurable file naming and initialization-time integrity maintenance for TextFileBasedViolationStore. The store must support random, description-derived, constructor-supplied, and reflective custom naming strategies; classify index entries and folder contents precisely; repair or report inconsistencies according to default.integrity; preserve index/folder safety and update permissions; alter save semantics under repair; and serialize in-process initialization/save operations so no partial state is observed. The prompt defines the relevant defaults, path/link edge cases, precedence rules, reporting order, no-op rewrite behavior, and failure atomicity in unusually high detail.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The prompt says default.integrity defaults to ignore, “which examines nothing,” and “repair discards broken entries.”",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Directly distinguishes the default from repair.",
      "verifies": "With no default.integrity property the broken entry remains; a later repair removes it and leaves an empty index."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly gives ignore/repair semantics.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Fair, though largely redundant with the absent-setting test.",
      "verifies": "Explicit ignore preserves the broken entry; repair subsequently removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt says ignore examines nothing and precisely states repair behavior for broken, resolved, shared, unowned, misplaced, and occupied entries.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Strong multi-condition integration test; all co-asserted outcomes are specified.",
      "verifies": "Ignore preserves every file byte and index entry; subsequent repair removes broken/resolved entries, preserves shared/unowned/occupied entries, moves the sole movable misplaced file, and preserves all asserted contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt says any other value is rejected, naming the three accepted values.",
      "fairness": "Prompt-stated",
      "name": "unknownValueIsRejectedAndNamesTheAcceptedValues",
      "qualityCheck": "Substring checks avoid pinning full prose.",
      "verifies": "default.integrity=prune throws RuntimeException whose message contains ignore, repair, and fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the accepted values are exact.",
      "fairness": "Prompt-stated",
      "name": "valuesNearAnAcceptedValueAreRejected",
      "qualityCheck": "Good discriminating near-miss coverage.",
      "verifies": "Repair, repair-with-space, repairs, IGNORE, and failed each throw RuntimeException."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail changes nothing and rejects unless index and folder agree; its report names every conditioned entry.",
      "fairness": "Prompt-stated",
      "name": "failAcceptsAConsistentStoreAndRejectsAnInconsistentOne",
      "qualityCheck": "Covers both acceptance and rejection.",
      "verifies": "Fail initializes a consistent store; for a missing-file entry it throws, names the rule, and leaves the entry intact."
    },
    {
      "concerns": [],
      "evidence": "Repair discards broken entries and writes only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Clear positive and negative cases.",
      "verifies": "Repair preserves the healthy index/file pair and removes a broken entry from another store."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines a missing resolved path as broken and says repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "Direct classification test.",
      "verifies": "Repair removes only the absent-file entry and leaves the present entry/file."
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
      "evidence": "A directory entry is explicitly broken; repair discards the entry, while deletion is specified only for resolved files.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "Checks both index and filesystem effects.",
      "verifies": "Repair removes the directory-recording entry but does not delete the directory."
    },
    {
      "concerns": [],
      "evidence": "Outside-folder entries are broken, and storing/maintenance safety forbids touching outside files.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Good path-traversal safety test.",
      "verifies": "Repair removes ../outside.txt from the index and preserves the external file and exact content."
    },
    {
      "concerns": [],
      "evidence": "A valid entry must be a regular file directly in the folder; outside/absolute resolved paths fail that condition.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "Fair path-containment coverage.",
      "verifies": "Both an external absolute path and an absolute spelling of an in-folder basename are discarded; neither target file is changed."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the regular file to be directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Directly covers the “directly” qualifier.",
      "verifies": "Repair removes nested/violations from the index but leaves the nested file."
    },
    {
      "concerns": [],
      "evidence": "A path that cannot resolve to a regular direct child is broken; fail reports and changes nothing, while repair discards it.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Robust malformed-path case.",
      "verifies": "Fail reports the NUL-containing entry without corrupting the index; repair removes only it; the healthy file/content remains and the repaired store passes fail."
    },
    {
      "concerns": [],
      "evidence": "The definition uses the entry’s resolved path; ./violations resolves to the regular file directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "Appropriately tests resolution rather than raw-string equality.",
      "verifies": "./violations survives repair, remains readable as one violation, and only the separate broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "An entry whose resolved path is outside the folder is broken; repair discards broken entries without touching outside content.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Behavior is explicit; portability concerns are noted suite-wide.",
      "verifies": "Repair removes the symlink entry, preserves the external target content, and leaves a store that passes fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt classifies by resolved path and says aliases resolving to one file are ownership/sharing relevant.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Fair link-resolution case.",
      "verifies": "A symlink to an in-folder target survives as a healthy entry while a broken peer is removed; fail then accepts."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines unowned content narrowly as “a regular file directly in the folder”; the symlink itself is not such a file, and repair lists no operation deleting unrelated links.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Fair but tests an exclusion inferred from the prompt’s exhaustive condition definitions.",
      "verifies": "Repair does not remove an unrecorded symlink or its external target, and fail does not treat it as an unowned regular file."
    },
    {
      "concerns": [],
      "evidence": "Its resolved path is missing, which the prompt defines as broken.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "Direct edge case.",
      "verifies": "Repair removes the dangling-link entry."
    },
    {
      "concerns": [],
      "evidence": "An entry yielding no violations is resolved; repair discards resolved entries with their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Direct resolved-entry behavior.",
      "verifies": "Repair removes an empty-file entry and deletes the file, leaving only stored.rules."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says deleting a resolved link’s target “with the link.”",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Strong direct test of the unusual link-deletion rule.",
      "verifies": "Repair removes the resolved entry, target, and symlink; only the index remains and fail accepts afterward."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly treats a file holding only line breaks as resolved.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Discriminates empty logical content from a real violation.",
      "verifies": "A LF-only file and entry are deleted; a nonempty violation entry/file remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt names \\n, \\r\\n, and lone \\r as line-break-only resolved forms.",
      "fairness": "Prompt-stated",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Thorough line-ending coverage.",
      "verifies": "CRLF-only, lone-CR-only, and LF-only entries/files are removed; the file containing text plus CRLF remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a carriage return inside a stored violation stays part of its text.",
      "fairness": "Prompt-stated",
      "name": "carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved",
      "qualityCheck": "Good end-to-end encoding test.",
      "verifies": "Save/read round-trips violations containing embedded CR and CRLF; repair removes only the line-break-only peer; fail and a new reader preserve the exact violation list."
    },
    {
      "concerns": [],
      "evidence": "Resolved means the file yields no violations.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Simple boundary case.",
      "verifies": "Repair retains the one-violation entry/file and deletes the empty one."
    },
    {
      "concerns": [],
      "evidence": "The prompt says duplicate recorded names are shared even if nothing exists, and shared entries are left alone.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Direct shared-name test.",
      "verifies": "Two entries recording the same empty file survive repair, while a lone broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says two recorded names resolving to one file are shared and shared overrides other conditions.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Comprehensive alias/preference test.",
      "verifies": "Aliases to the same in-folder file and aliases to the same outside file both remain shared, including empty/broken-looking cases; links and target survive."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines sharing by two names resolving to one file, not merely by textual name equality.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Fair filesystem-identity case; portability noted suite-wide.",
      "verifies": "Fail reports both hard-linked entries; repair retains both empty-file entries and both names."
    },
    {
      "concerns": [],
      "evidence": "“An entry both shared and something else stays shared.”",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Strong precedence matrix.",
      "verifies": "Shared empty entries survive repair even when also colliding or their derived names are occupied; only nonshared resolved/broken peers are removed and asserted occupants remain."
    },
    {
      "concerns": [],
      "evidence": "Fail reports shared entries and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesSharedEntriesAndChangesNothing",
      "qualityCheck": "Direct report/state test.",
      "verifies": "Fail throws, includes both shared rule descriptions, and preserves both entries and the file."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says duplicate names are shared even when absent and shared overrides other conditions.",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Excellent precedence test.",
      "verifies": "Fail names the lone broken and both shared-missing entries; repair removes only the lone broken entry and retains both shared entries even without a file."
    },
    {
      "concerns": [],
      "evidence": "The store leaves unowned files alone and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Direct mixed-condition test.",
      "verifies": "Repair removes the broken entry while preserving the unowned file and exact content."
    },
    {
      "concerns": [],
      "evidence": "Fail reports every unowned file and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesUnownedFilesAndChangesNothing",
      "qualityCheck": "Fair substring report assertion.",
      "verifies": "Fail reports the stray filename and preserves index, owned file, and stray file."
    },
    {
      "concerns": [],
      "evidence": "Only a regular file directly in the folder can be unowned.",
      "fairness": "Prompt-stated",
      "name": "aDirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Good exclusion/control pairing.",
      "verifies": "A direct child directory does not make fail reject; adding a direct stray regular file does and that filename is reported."
    },
    {
      "concerns": [],
      "evidence": "Unowned files are restricted to regular files directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Directly verifies nonrecursive examination.",
      "verifies": "Fail reports the broken entry but not a nested file; repair removes the broken entry and preserves the nested file/content."
    },
    {
      "concerns": [],
      "evidence": "The unowned definition begins “Apart from the index.”",
      "fairness": "Prompt-stated",
      "name": "theIndexItselfIsNeverUnowned",
      "qualityCheck": "Clear special-case test.",
      "verifies": "A store containing only the index and one healthy file passes fail; another store fails only for its broken entry."
    },
    {
      "concerns": [],
      "evidence": "Repair’s specified operations remove the sole broken condition on the first run; no conditions remain for the second.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Useful idempotence check.",
      "verifies": "Two repairs settle to the same file list and surviving key; the second repair makes no further logical change."
    },
    {
      "concerns": [],
      "evidence": "Resolved aliases are shared, shared entries are left alone, and shared precedence applies.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Good idempotence around aliasing.",
      "verifies": "Two entries resolving to one file remain shared across two repairs; entries/files/content are unchanged after the first settled state."
    },
    {
      "concerns": [],
      "evidence": "Repair brings the index/folder into agreement; fail rejects only disagreement.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderPassesAFailingCheck",
      "qualityCheck": "Useful cross-mode integration.",
      "verifies": "After repair removes broken and resolved entries, fail initializes successfully and only the healthy key remains."
    },
    {
      "concerns": [],
      "evidence": "Repair writes the index when an entry changes; the index is the persistent rule mapping.",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Checks persistence rather than only in-memory state.",
      "verifies": "A new store instance sees the removed rule as absent and the surviving rule as present."
    },
    {
      "concerns": [],
      "evidence": "Repair discards broken entries and resolved entries with their files.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Direct final-state invariant.",
      "verifies": "After removing broken/resolved entries, exactly stored.rules and the surviving mapped file remain, and the index value equals that filename."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt requires concurrent initializations in one process to leave a readable index and survivor-only folder.",
      "fairness": "Prompt-stated",
      "name": "concurrentInitializationsLeaveAReadableIndex",
      "qualityCheck": "Uses a deadline that can fail under extreme load.",
      "verifies": "Four simultaneous repairs all finish within 30 seconds without failure; final index has only the healthy key and folder only index/healthy file."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "Concurrent initialization and misplaced-move behavior are both explicitly required.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairsOfAMisplacedEntryLeaveItOnItsMovedFile",
      "qualityCheck": "Controlled latches are strong, but 5/30-second waits remain load-sensitive.",
      "verifies": "Two deliberately overlapped repairs terminate, leave one entry mapped to derived, preserve exact violation content, leave only index/derived, and pass fail."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt says no store examines a save still in progress and concurrent operations leave a readable survivor-only folder.",
      "fairness": "Prompt-stated",
      "name": "examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave",
      "qualityCheck": "Strong overlap orchestration, with timeout sensitivity.",
      "verifies": "Repair/fail initializations started during a blocked save do not corrupt/fail; all threads finish, the new rule is indexed with one file, and both original/new readers return the violation."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt requires in-process concurrent saves to leave a readable index and only survivor files; repair-empty forget semantics are explicit.",
      "fairness": "Prompt-stated",
      "name": "oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind",
      "qualityCheck": "Correctly accepts either legal serialization; deadlines are load-sensitive.",
      "verifies": "Overlapping nonempty and empty saves produce one of two serialized outcomes only: either index-only forgotten state or one indexed file containing the held save; no failures or extra files, and fail accepts."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "No store may examine a save in progress; repair must move a misplaced file to its derived name.",
      "fairness": "Prompt-stated",
      "name": "repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved",
      "qualityCheck": "Good stale-data race detector; deadline-based.",
      "verifies": "An overlapped save and repair finish without failure; final entry uses the derived name, only that file remains, and it contains/read-backs the newly saved rather than old violation."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "No examination may observe a save in progress, and a still-violating rule keeps its entry.",
      "fairness": "Prompt-stated",
      "name": "repairingTheFolderWhileAnotherStoreSavesIntoAnEmptiedFileKeepsTheEntryAndTheFile",
      "qualityCheck": "Good resolved-vs-save race test; deadline-based.",
      "verifies": "Repair overlapping a save into an initially empty file waits, then retains the entry/file with new content and a reader/fail check succeeds."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "Concurrent initializations must leave a readable survivor-only store; fail may reject before repair completes.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairAndFailLeaveAReadableIndex",
      "qualityCheck": "Allows legal serial orderings; 30-second deadline is timing-sensitive.",
      "verifies": "Six concurrent repair/fail initializations terminate; only expected fail-mode RuntimeExceptions are tolerated; final index/folder contain only the healthy survivor."
    },
    {
      "concerns": [],
      "evidence": "“repair needs default.allowStoreUpdate and is rejected without it.”",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedAndChangesNothing",
      "qualityCheck": "Checks rejection atomicity.",
      "verifies": "Repair with allowStoreUpdate=false throws and preserves both healthy/broken entries and existing files."
    },
    {
      "concerns": [],
      "evidence": "The prompt makes update permission a prerequisite for repair, not conditional on finding changes.",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore",
      "qualityCheck": "Important qualifier test.",
      "verifies": "Repair with updates disabled throws even when no repair action would be needed."
    },
    {
      "concerns": [],
      "evidence": "“fail reports either way.”",
      "fairness": "Prompt-stated",
      "name": "failWithoutPermissionToUpdateStillReportsTheInconsistency",
      "qualityCheck": "Direct permission distinction.",
      "verifies": "Fail with updates disabled still throws and includes the broken rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says this precondition is rejected before anything is examined.",
      "fairness": "Prompt-stated",
      "name": "anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined",
      "qualityCheck": "Message omission is a reasonable observable proxy for examination.",
      "verifies": "Repair/fail reject an absent index with creation disabled, do not create it, fail’s message omits a stray file, and after an index is supplied repair can remove its broken entry."
    },
    {
      "concerns": [
        "timing_sensitivity",
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly says a fail rejection does not even create an absent index.",
      "fairness": "Prompt-stated",
      "name": "failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne",
      "qualityCheck": "WatchService makes the transient-creation check meaningful but platform/timing-sensitive.",
      "verifies": "With creation allowed but an unowned file present, fail reports it, never creates stored.rules even transiently, and preserves the stray file/content."
    },
    {
      "concerns": [],
      "evidence": "An index not a regular file directly in the folder is rejected before examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatIsALinkOutOfTheStoreFolderIsRejectedAndItsTargetSurvives",
      "qualityCheck": "Fair safety test; link portability noted suite-wide.",
      "verifies": "Repair rejects an index symlink to an outside file and leaves target content byte-for-byte unchanged."
    },
    {
      "concerns": [],
      "evidence": "The index itself must be a regular file directly in the folder, and rejection precedes examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined",
      "qualityCheck": "Thorough precondition/atomicity check.",
      "verifies": "Both repair and fail reject an in-folder index symlink, omit unrelated condition names, preserve target bytes/link status, and leave all names present."
    },
    {
      "concerns": [],
      "evidence": "A non-regular direct index is rejected before examination; repair semantics still apply to valid stores.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired",
      "qualityCheck": "Good isolation control.",
      "verifies": "Directory-at-index is rejected by repair/fail without any byte/name changes; an independent sound store is still repaired normally."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly fixes broken, resolved, shared, then unowned report order.",
      "fairness": "Prompt-stated",
      "name": "failNamesTheConditionsInTheStatedOrder",
      "qualityCheck": "Checks only mandated token ordering, not full prose.",
      "verifies": "The message positions for broken, resolved, shared, and unowned tokens are increasing in exactly that condition order."
    },
    {
      "concerns": [],
      "evidence": "Within a condition, entries are ordered by rule description and files by name.",
      "fairness": "Prompt-stated",
      "name": "failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName",
      "qualityCheck": "Direct ordering assertion.",
      "verifies": "Broken rule descriptions appear alpha-before-zulu and unowned filenames alpha-before-zulu in the message."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires entry ordering by rule description within a condition.",
      "fairness": "Prompt-stated",
      "name": "failOrdersSharedEntriesByRuleDescription",
      "qualityCheck": "Good discriminator against filename sorting.",
      "verifies": "Four shared rule descriptions appear in lexicographic description order, independent of recorded filename order."
    },
    {
      "concerns": [],
      "evidence": "Within every entry condition, ordering is by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescription",
      "qualityCheck": "Direct condition-specific coverage.",
      "verifies": "Misplaced entries appear alpha, mike, zulu in the fail report."
    },
    {
      "concerns": [],
      "evidence": "Within a condition, entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersCollidingEntriesByRuleDescription",
      "qualityCheck": "Direct condition-specific coverage.",
      "verifies": "Colliding entries appear alpha, mike, zulu in the fail report."
    },
    {
      "concerns": [],
      "evidence": "Within a condition, entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersOccupiedEntriesByRuleDescription",
      "qualityCheck": "Good discriminator against derived-name sorting.",
      "verifies": "Occupied entries appear alpha, mike, zulu despite oppositely sorted derived names."
    },
    {
      "concerns": [],
      "evidence": "The prompt specifically names rule description as the entry sort key.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescriptionAndNotByTheirDerivedNames",
      "qualityCheck": "Strong sorting-key test.",
      "verifies": "Misplaced entries appear in description order despite inverted derived-name order."
    },
    {
      "concerns": [],
      "evidence": "“fail changes nothing.”",
      "fairness": "Prompt-stated",
      "name": "failWithSeveralConditionsAtOnceChangesNotOneByte",
      "qualityCheck": "Strong byte-level atomicity check.",
      "verifies": "Fail on broken/resolved/shared/unowned conditions throws while preserving the exact filename list and every file’s bytes."
    },
    {
      "concerns": [],
      "evidence": "Repair discards resolved entries.",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "User-visible consequence of index removal.",
      "verifies": "After repair removes a resolved entry, a new store’s contains(rule) returns false."
    },
    {
      "concerns": [],
      "evidence": "A still violated rule keeps its entry; repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Good API-level integration.",
      "verifies": "Repair preserves contains=true and exact violation text for a nonempty entry while removing a broken peer."
    },
    {
      "concerns": [],
      "evidence": "Repair discards the resolved entry and file; ordinary save then names a newly stored rule.",
      "fairness": "Prompt-stated",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Useful lifecycle test.",
      "verifies": "A resolved rule removed by repair can be saved anew, is contained/readable, has the sole new index entry, and does not reuse the deleted legacy filename."
    },
    {
      "concerns": [],
      "evidence": "Repair removal is prompt-stated; the first-freeze evaluation behavior is existing FreezingArchRule integration semantics exercised in archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java, while TextFileBasedViolationStore persistence is visible at TextFileBasedViolationStore.java:127-153.",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Fair integration regression, though broader than maintenance alone.",
      "verifies": "After repair empties the index, a real FreezingArchRule first evaluation reports no violation, refreezes the rule, and does not retain the old resolved file."
    },
    {
      "concerns": [],
      "evidence": "The prompt defaults naming to random and singles out description as the deterministic derivation mode; random cannot re-derive an existing rule’s target.",
      "fairness": "Prompt-stated",
      "name": "randomFileNamesDeriveNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Necessary to avoid relocating every legacy random file.",
      "verifies": "With absent default.fileNames, repair retains an arbitrary healthy existing filename and removes only a broken peer."
    },
    {
      "concerns": [],
      "evidence": "default.fileNames accepts random as the default random naming mode; deterministic derivation is specified only for description/custom strategies.",
      "fairness": "Prompt-stated",
      "name": "namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Fair explicit-setting counterpart.",
      "verifies": "Explicit random preserves the arbitrary mapping/file, repair removes only broken data, and fail then accepts."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a constructor strategy names files the same way.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
      "qualityCheck": "Covers initialization and save integration.",
      "verifies": "Constructor strategy moves a legacy file/index mapping to its derived name, preserves content, and gives a newly saved rule its derived filename/content."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly rejects configuring default.fileNames for such a store.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing",
      "qualityCheck": "Direct conflict test.",
      "verifies": "Supplying both a constructor strategy and default.fileNames throws and leaves index mapping/files unchanged."
    },
    {
      "concerns": [],
      "evidence": "A strategy yielding no name is rejected as soon as a name is needed; repair/fail must derive names to classify misplaced entries.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Checks both no-name forms and atomicity.",
      "verifies": "Null- and empty-returning constructor strategies both make repair and fail throw while index bytes/files remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt states the random default, per-rule difference, built-in character/length/index restrictions, and random non-relocation semantics implied by nondeterminism.",
      "fairness": "Prompt-stated",
      "name": "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
      "qualityCheck": "Good default-naming integration.",
      "verifies": "Default random names for two rules are distinct, not stored.rules, ASCII-safe, at most 200 chars; broken data is repaired; later repair retains the names and exact file set."
    },
    {
      "concerns": [],
      "evidence": "Any other default.fileNames value denotes a RuleViolationFileNameStrategy implementation used to name files.",
      "fairness": "Prompt-stated",
      "name": "aConfiguredStrategyNamesNewlyStoredRules",
      "qualityCheck": "Direct custom-strategy save test.",
      "verifies": "A reflective custom strategy’s exact returned name becomes both index value and sole violation filename for a new rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a public no-argument constructor and says the strategy names files.",
      "fairness": "Prompt-stated",
      "name": "aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves",
      "qualityCheck": "Thorough reflective integration.",
      "verifies": "A public-no-arg reflective strategy supplies exact names for both a moved legacy entry and a newly saved entry, with exact file contents."
    },
    {
      "concerns": [],
      "evidence": "The value must be the fully qualified name of an implementation constructible as specified.",
      "fairness": "Prompt-stated",
      "name": "aStrategyThatCannotBeInstantiatedIsRejected",
      "qualityCheck": "Direct invalid-class case.",
      "verifies": "A nonexistent strategy class name causes initialization to throw RuntimeException."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires an implementation with a public no-argument constructor.",
      "fairness": "Prompt-stated",
      "name": "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected",
      "qualityCheck": "Good reflective validation matrix.",
      "verifies": "Wrong type, no no-arg constructor, and private no-arg constructor each throw; existing index/file remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt rejects a strategy yielding no name when classification needs one.",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Fair configured-strategy counterpart.",
      "verifies": "Reflectively configured null/empty strategies make repair/fail throw and preserve exact index bytes/files."
    },
    {
      "concerns": [],
      "evidence": "Ignore examines nothing, and a no-name strategy is rejected “as soon as a name is needed.”",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore",
      "qualityCheck": "Strong laziness and failure-atomicity test.",
      "verifies": "Ignore does not invoke the null/empty strategy; saving an unknown rule invokes it and throws; no file/index/in-memory mapping changes, while prior rule remains known."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines misplaced and says repair moves its file to the derived name.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
      "qualityCheck": "Canonical relocation test.",
      "verifies": "Repair changes the mapping to the exact derived name, moves the sole violation file there, and preserves exact content."
    },
    {
      "concerns": [],
      "evidence": "Repair moves the file, which necessarily preserves its stored violations.",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryKeepsItsViolationsAfterTheMove",
      "qualityCheck": "API-level content preservation.",
      "verifies": "After repair, both violations read back in order and the mapping equals the derived name."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says moving a link moves its target rather than the link.",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt",
      "qualityCheck": "Direct test of an unusual explicit rule.",
      "verifies": "Repair maps to the derived name, creates a non-symlink regular file there with exact content, removes old link/target names, and fail accepts."
    },
    {
      "concerns": [],
      "evidence": "Fail reports every conditioned entry and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesMisplacedEntriesAndChangesNothing",
      "qualityCheck": "Direct fail-mode counterpart.",
      "verifies": "Fail reports the misplaced rule and preserves both mapping and legacy filename."
    },
    {
      "concerns": [],
      "evidence": "A misplaced entry is occupied when its derived name escapes the folder; occupied entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameLeavingTheStoreFolderIsNeverUsed",
      "qualityCheck": "Good relative and rooted safety variants.",
      "verifies": "Relative-escaping and absolute derived names do not move files or alter mappings/outside content; fail still reports the rule."
    },
    {
      "concerns": [],
      "evidence": "One derived name shared by two rules is colliding, and repair never moves colliding entries.",
      "fairness": "Prompt-stated",
      "name": "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
      "qualityCheck": "Direct collision test.",
      "verifies": "Repair leaves both mappings/files at legacy names; fail reports both colliding rules."
    },
    {
      "concerns": [],
      "evidence": "A derived name that already names something is occupied; repair never moves an occupied entry.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameAnUnownedFileOccupiesIsNotTakenOver",
      "qualityCheck": "Strong no-takeover assertion.",
      "verifies": "Repair leaves the legacy mapping/content and unowned derived-name file/content untouched; fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "Occupied means the derived name already names something, including a link.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkOutOfTheStoreFolderOccupiesIsNotTakenOver",
      "qualityCheck": "Fair occupancy/safety case.",
      "verifies": "An out-of-folder symlink at the derived name blocks movement; legacy and external contents remain; fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says occupied when the derived name already names something; existence is not conditioned on a live target.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADanglingLinkOccupiesIsNotTakenOver",
      "qualityCheck": "Direct dangling-link occupancy case.",
      "verifies": "A dangling symlink at the derived name blocks movement; legacy file remains; fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "The derived name already names something, while only an entry recording its derived name is exempt from occupied status.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkToTheEntrysOwnFileOccupiesIsNotTakenOver",
      "qualityCheck": "Good subtle ownership distinction.",
      "verifies": "A derived-name symlink to the entry’s current file still blocks movement; mapping, link, and contents remain; fail reports."
    },
    {
      "concerns": [],
      "evidence": "Occupied uses “already names something,” not only regular files.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADirectoryOccupiesIsNotTakenOver",
      "qualityCheck": "Direct directory occupant case.",
      "verifies": "A directory at the derived name blocks movement; mapping/directory/legacy content remain and fail reports."
    },
    {
      "concerns": [],
      "evidence": "Storing never writes over the index, and an occupied derived name is never moved over.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameEqualToTheIndexIsOccupiedAndNeverMovedOver",
      "qualityCheck": "Critical index-protection test.",
      "verifies": "A custom derived name of stored.rules does not change mapping, index bytes, or legacy content; fail reports inconsistency."
    },
    {
      "concerns": [],
      "evidence": "Each derived name is recorded by another entry, making both occupied; repair never moves occupied entries.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesThatWouldSwapNamesAreNotMoved",
      "qualityCheck": "Good cycle/swap case.",
      "verifies": "Each entry retains the other rule’s derived filename; fail reports both afterward."
    },
    {
      "concerns": [],
      "evidence": "One derived name shared by two rules is colliding; colliding status applies to both and prevents movement.",
      "fairness": "Prompt-stated",
      "name": "failNamesBothCollidingRulesEvenWhenOneAlreadyRecordsTheDerivedName",
      "qualityCheck": "Subtle collision membership test.",
      "verifies": "Fail reports both rules sharing one derived name; repair leaves the already-settled and legacy mappings/files untouched."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says an entry recording its derived name is never occupied.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs",
      "qualityCheck": "Exact exemption plus no-op rewrite coverage.",
      "verifies": "Fail reports beta but not alpha; repair does not rewrite index bytes; both mappings and all legacy/occupant contents remain."
    },
    {
      "concerns": [],
      "evidence": "Fail reports colliding entries and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesCollidingEntriesAndChangesNothing",
      "qualityCheck": "Direct fail collision test.",
      "verifies": "Fail reports both colliding descriptions and preserves index plus both legacy files."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair never moves colliding entries “but still discards one that is broken or resolved.”",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName",
      "qualityCheck": "Strong precedence test.",
      "verifies": "Repair removes broken and empty/line-break-only entries despite shared derived-name collision; keeps only the nonempty colliding entry at its legacy file/content."
    },
    {
      "concerns": [],
      "evidence": "Occupied prevents movement but not required broken/resolved discarding.",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied",
      "qualityCheck": "Strong precedence and non-takeover test.",
      "verifies": "Repair removes broken/resolved entries despite occupied derived names, preserves all occupant files/content, and retains only the still-violating occupied legacy entry."
    },
    {
      "concerns": [],
      "evidence": "Occupied includes a derived name recorded by another entry; duplicate recorded names are shared even if absent.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt",
      "qualityCheck": "Directly combines two explicit absent-file rules.",
      "verifies": "A movable entry is not moved to a name recorded by two absent shared entries; broken peer is removed, shared entries and legacy content remain, and fail reports the movable rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt forbids writing over a file the rule’s own entry does not record and requires rejection with unchanged state.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn",
      "qualityCheck": "Strong retry and atomicity coverage.",
      "verifies": "Two save attempts to an unowned derived filename throw; index bytes/entries/in-memory contains/file list and unowned content remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "Saving may not overwrite a file its own entry does not record; another entry records the colliding name.",
      "fairness": "Prompt-stated",
      "name": "storingASecondUnknownRuleNeverTakesOverTheFirstRulesFile",
      "qualityCheck": "Good inter-rule ownership test.",
      "verifies": "After one unknown rule uses a constant derived name, saving a second throws; only the first mapping/file remains with its exact violations."
    },
    {
      "concerns": [],
      "evidence": "A save must never write outside the folder and new files must be safe direct children.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected",
      "qualityCheck": "Thorough unsafe-name matrix.",
      "verifies": "Relative escape, nested path, and absolute derived names each make save throw; outside/nested contents remain and index/direct file list stay unchanged."
    },
    {
      "concerns": [],
      "evidence": "A file/name its own entry does not record cannot be overwritten; the dangling link already occupies the candidate name.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleNeverTakesOverADanglingLink",
      "qualityCheck": "Good no-follow/no-takeover case.",
      "verifies": "Saving to a derived name occupied by a dangling link throws; link remains and index stays empty."
    },
    {
      "concerns": [],
      "evidence": "The prompt forbids save writes over the index or outside the folder and requires unchanged rejection.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected",
      "qualityCheck": "Direct existing-entry safety test.",
      "verifies": "Saving existing entries mapped outside, to stored.rules, or by rooted spelling throws; outside/in-folder content and index bytes remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "Saving must not write outside the folder and rejection leaves state unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsADanglingLinkNeverCreatesTheFileItPointsAt",
      "qualityCheck": "Strong symlink-chain safety with healthy-operation control.",
      "verifies": "Direct and chained dangling links to an outside target cause save rejection without creating target or changing index; saving another healthy rule still works."
    },
    {
      "concerns": [],
      "evidence": "A still-violated rule keeps its entry, and save may write the file its own entry records but not an unowned occupant.",
      "fairness": "Prompt-stated",
      "name": "storingAStillViolatedRuleWritesToItsOwnFileEvenWhenItsDerivedNameIsOccupied",
      "qualityCheck": "Good distinction between existing mapping and naming strategy.",
      "verifies": "Existing rule keeps/writes its legacy mapped file despite an occupied derived name; occupant remains unchanged; an unknown rule gets its own derived name; exact final files/mappings are asserted."
    },
    {
      "concerns": [],
      "evidence": "A still violated rule keeps its entry; ignore examines nothing, repair discards broken entries, and the link resolves to the owned file.",
      "fairness": "Prompt-stated",
      "name": "storingAStillViolatedRuleWritesThroughTheLinkItsEntryRecords",
      "qualityCheck": "Comprehensive mode/link behavior.",
      "verifies": "Under repair and ignore, saving writes new text through the recorded symlink, retains that mapping, read-back succeeds, and the broken peer remains only under ignore."
    },
    {
      "concerns": [],
      "evidence": "Saving never writes over the index, including aliases that resolve to it.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected",
      "qualityCheck": "Strong alias-based index protection.",
      "verifies": "Entries naming ./stored.rules, a symlink to it, or a hard link to it all make save throw and preserve exact index bytes."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly forbids saves overwriting the index.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverTheIndex",
      "qualityCheck": "Canonical direct-name case.",
      "verifies": "A naming strategy returning stored.rules causes save to throw and leaves the index empty."
    },
    {
      "concerns": [],
      "evidence": "Repair forgetting is prompt-stated. The contrasting legacy ignore behavior is produced by TextFileBasedViolationStore.java:127-153 and asserted by archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java:85-92, where saving an empty list leaves a stored rule readable as empty.",
      "fairness": "Repo-discoverable",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "Fair compatibility comparison with concrete repository support.",
      "verifies": "Repair-mode empty save removes the known entry/file; ignore-mode empty save retains the entry and yields an empty violation list."
    },
    {
      "concerns": [],
      "evidence": "The repair side is explicit in the prompt; fail is non-repairing, and existing empty-save persistence is asserted at TextFileBasedViolationStoreTest.java:85-92 and implemented at TextFileBasedViolationStore.java:127-153.",
      "fairness": "Repo-discoverable",
      "name": "onlyRepairForgetsAResolvedRuleWhileFailKeepsIt",
      "qualityCheck": "Fair mode distinction.",
      "verifies": "Repair-mode empty save removes the entry; fail-mode empty save retains it."
    },
    {
      "concerns": [],
      "evidence": "Repair forgets a known rule but does not delete a file another entry shares; outside writes/deletes are forbidden.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Good shared/outside safety test.",
      "verifies": "Repair-mode empty save removes only the selected shared entry, keeps its shared peer mapping, and preserves outside file/content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says forgetting discards the file unless another entry shares it.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Direct share-preservation test.",
      "verifies": "Empty save removes only forgotten-rule entry; both alias names and shared target remain, preserving content/read-back for the peer."
    },
    {
      "concerns": [],
      "evidence": "Repair forgetting discards the entry and file, and link deletion includes target with link.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
      "qualityCheck": "Strong link-specific forgetting test.",
      "verifies": "Empty save removes forgotten entry, symlink, and target; preserves peer entry/file and API behavior."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "The prompt explicitly says failed deletion rejects the save and keeps the entry.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "Behavior is fair, but POSIX permissions and setpriv/user IDs are environment-specific.",
      "verifies": "When deletion is denied, empty save is rejected and the same store still reports the rule with its violation; index bytes/file remain; after permissions restore, retry removes both."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says it stores nothing for an unknown rule.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct unknown-rule case.",
      "verifies": "Repair-mode empty save of an unknown rule leaves an empty index and only stored.rules."
    },
    {
      "concerns": [],
      "evidence": "“A still violated rule keeps its entry.”",
      "fairness": "Prompt-stated",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Direct save behavior.",
      "verifies": "Repair removes a broken peer; subsequent nonempty save retains the known rule entry and reads back exactly the remaining violation."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly requires description names to keep such a whole word.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionShowTheRuleTheyStore",
      "qualityCheck": "Property-based assertion avoids pinning an implementation-specific exact name.",
      "verifies": "Description mode creates one stored filename that contains a whole 4–120 ASCII-alphanumeric word from the description and is the only non-index file."
    },
    {
      "concerns": [],
      "evidence": "With description, the name derives deterministically from the rule description.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameInALaterRun",
      "qualityCheck": "Direct determinism check.",
      "verifies": "The same description saved in two stores receives exactly the same filename."
    },
    {
      "concerns": [
        "environment_assumption"
      ],
      "evidence": "Deterministic derivation from the description alone plus built-in character/length constraints require this result.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameOnAnotherMachine",
      "qualityCheck": "Strong independence check, though it assumes subprocess Java/classpath availability.",
      "verifies": "Separate JVMs with differing user/home/temp/locale/encoding produce the same ASCII-safe <=200 filename containing a qualifying whole word."
    },
    {
      "concerns": [],
      "evidence": "The name derives deterministically from the rule description, not store state.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds",
      "qualityCheck": "Good discriminator against collision-counter naming.",
      "verifies": "The same rule gets the identical description-derived name in an empty store and after two other rules were stored."
    },
    {
      "concerns": [],
      "evidence": "Names differ per rule, description names retain a qualifying word, and built-in names obey safety constraints.",
      "fairness": "Prompt-stated",
      "name": "twoRulesReadingAlikeStillGetDifferentNames",
      "qualityCheck": "Excellent collision-resistance cases.",
      "verifies": "Eight similar/case/punctuation/long-prefix descriptions each get a qualifying whole-word filename with no duplicates; exact corresponding violations read back and file set equals index plus names."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly states built-in alphabet, bound, and whole-word requirements.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
      "qualityCheck": "Good sanitization/path-character case.",
      "verifies": "The generated name matches only ASCII letters/digits/underscore/hyphen, is <=200, contains a qualifying whole word, and is the only violation file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a qualifying word may come late and allows lengths through 120.",
      "fairness": "Prompt-stated",
      "name": "aLongWordAfterOnlyShortOnesStillYieldsABoundedName",
      "qualityCheck": "Covers the upper inclusive boundary.",
      "verifies": "A description ending in a 120-character word yields a safe <=200 deterministic name retaining a qualifying whole word in both stores."
    },
    {
      "concerns": [],
      "evidence": "A whole word of 4–120 letters or digits must be retained even late in a long description.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt",
      "qualityCheck": "Covers alphabetic and numeric lower boundary.",
      "verifies": "Both late “controllers” and late “1234” descriptions yield distinct safe <=200 names each retaining a qualifying whole word; only those files plus index exist."
    },
    {
      "concerns": [],
      "evidence": "Only whole words of at most 120 qualify, and a later qualifying word must still be kept.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordBeforeIt",
      "qualityCheck": "Strong 121-vs-120 boundary test.",
      "verifies": "A 121-character leading word is not used as a truncated match; the safe <=200 name contains whole “controllers” and passes the whole-word predicate."
    },
    {
      "concerns": [],
      "evidence": "The required retained word may be any qualifying whole word; overlong words do not satisfy the 4–120 condition.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordAfterIt",
      "qualityCheck": "Complements the prior ordering case.",
      "verifies": "With “controllers” before a 121-character word, the safe <=200 name contains whole controllers and no illegal file names appear."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a whole qualifying word, not a substring cut from an overlong word.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordBeginningWithIt",
      "qualityCheck": "Excellent anti-truncation discriminator.",
      "verifies": "A 121-character word beginning with abcd cannot satisfy the whole-word check; the later standalone abcd must be represented, and stored violations read back."
    },
    {
      "concerns": [],
      "evidence": "Built-in names must use the stated ASCII alphabet and description naming is deterministic; the whole-word condition is conditional on a qualifying word existing.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionWithoutAnyPlainCharacterStillYieldsAStableName",
      "qualityCheck": "Good fallback-name case.",
      "verifies": "Punctuation-only description yields a nonempty ASCII-safe filename stable across two stores."
    },
    {
      "concerns": [],
      "evidence": "Built-in names use only the ASCII-safe alphabet, differ per rule, and description naming is deterministic.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionOfOnlyNonAsciiCharactersStillYieldsAStableAsciiName",
      "qualityCheck": "Strong fallback collision/determinism case.",
      "verifies": "Two non-ASCII-only rules get distinct ASCII-safe <=200 names, and the same rule gets the same name in another store."
    },
    {
      "concerns": [],
      "evidence": "Description mode names files; normal store semantics require those files to remain readable, and the whole-word property is explicit.",
      "fairness": "Prompt-stated",
      "name": "violationsAreReadBackFromANameTakenFromTheDescription",
      "qualityCheck": "Good end-to-end naming integration.",
      "verifies": "A new store reads back two violations in order from the description-derived file, whose name retains a qualifying word."
    },
    {
      "concerns": [],
      "evidence": "Such an entry is misplaced under deterministic description naming and repair moves it to the derived name.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingALegacyNameIsMovedToTheNameTakenFromTheDescription",
      "qualityCheck": "Direct built-in migration test.",
      "verifies": "Repair changes a UUID-like legacy mapping to a different description-derived whole-word name, moves the file, and preserves exact content."
    },
    {
      "concerns": [],
      "evidence": "Built-in names are never stored.rules and description names retain a qualifying word.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionNeverCollideWithTheIndex",
      "qualityCheck": "Direct reserved-name case.",
      "verifies": "A rule described exactly “stored.rules” receives a different filename that still retains a whole word from that description."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair writes the index only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
      "qualityCheck": "Good positive/negative write detection.",
      "verifies": "No-op repair preserves exact bytes and backdated mtime; repair removing a broken entry changes both bytes and mtime."
    },
    {
      "concerns": [],
      "evidence": "Shared/unowned items are left alone and index writing occurs only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex",
      "qualityCheck": "Strong no-op preservation test.",
      "verifies": "Shared/unowned findings preserve hand-written index bytes and mtime; all entries remain; fail afterward still reports the unowned file."
    },
    {
      "concerns": [],
      "evidence": "Repair writes the index only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "arepairThatChangesNothingLeavesTheIndexByteIdentical",
      "qualityCheck": "Direct no-op/idempotence write test.",
      "verifies": "After one repair removes a broken entry, a second repair preserves exact index bytes and mtime."
    },
    {
      "concerns": [],
      "evidence": "Repair and fail “examine the index and the folder while initializing,” requiring current disk state rather than stale process cache.",
      "fairness": "Prompt-stated",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "Important cache-invalidation test.",
      "verifies": "After an ignore initialization, externally replacing the on-disk index with one broken entry is observed by a later repair, which empties it."
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
  "status_reasoning": "There are exactly 2 suggestions, both medium priority, aimed at removing details discoverable from the codebase (explicit index filename and redundant explanatory clause). With only 1-2 medium/low items, the correct verdict is minor_suggestions.",
  "suggestions": [
    {
      "priority": "medium",
      "quote": "Add integrity maintenance for `TextFileBasedViolationStore`'s `stored.rules` index and files.",
      "suggestion": "Remove the explicit index filename `stored.rules`; the solver can discover the concrete index filename from the codebase. Keep it generic as \"its index and files\"."
    },
    {
      "priority": "medium",
      "quote": "\"A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store is rejected.\"",
      "suggestion": "Drop the explanatory clause \"names files the same way\". It is deducible from the class API; only keep the actionable requirement that combining a constructor-provided strategy with `default.fileNames` is rejected."
    }
  ],
  "summary": "- [MEDIUM] Remove the hard-coded index filename reference: \"`stored.rules`\" in \"Add integrity maintenance for `TextFileBasedViolationStore`'s `stored.rules` index and files.\" The concrete index filename is discoverable from the code; keep it generic as \"its index and files.\"\n- [MEDIUM] Trim the redundant part of: \"A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store is rejected.\" Remove \"names files the same way\" (deducible from the API). Keep only the requirement that providing both a constructor strategy and `default.fileNames` must be rejected.",
  "verdict": "minor_suggestions"
}
```
