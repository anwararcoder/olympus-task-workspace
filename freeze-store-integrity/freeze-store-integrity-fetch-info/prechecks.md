**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥20 messages, ≥200 LOC

This task numbers: Median files: 2.5, messages: 103.5, LOC: 921.5

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "3e0e03cf86ee16e95adeb278bcae1dcf97b0c8af265826410f5a90fa94245721",
  "overall": "distinct",
  "perCandidate": [
    {
      "confidence": 0.98,
      "contentAuthoredAt": 1786876774252,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: a Java ArchUnit freeze-store vs. a Go nftables ruleset store.",
        "Submission modifies TextFileBasedViolationStore to add integrity modes (ignore/repair/fail), filename strategies, on-disk index/folder reconciliation, and save-time discarding/move semantics; candidate adds a full optimistic concurrency transactional layer (Begin/Commit/Epoch), conflict detection, rebase, and transaction serialization for nftables tables/chains/rules/sets/objects.",
        "Submission’s behavior centers on filesystem index/file agreement, symlink handling, broken/resolved/misplaced/shared/colliding/occupied entry classification and repair; candidate centers on staging ops, gap-based anchoring of rules, rule handles/IDs, and ordering/overlap checks across epochs.",
        "Submission touches Java classes under com.tngtech.archunit.library.freeze and user docs; candidate introduces multiple Go files across the nftables package adding store, tx, conflict, rebase, and utility helpers."
      ],
      "one_liner": "One adds integrity checking and deterministic file naming to a Java file-based rule-violation store, while the other implements an optimistic, versioned transactional ruleset store in Go with conflict detection, rebase, and serialization.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The patches target unrelated projects and implement different features at different layers. The ArchUnit change enhances a file-based violation store with integrity modes and deterministic naming, operating over filesystem entries and an index. The nftables change builds an in-memory versioned transactional ruleset store with OCC, rebase, and serialization over network tables/chains/rules. Any shared notion of a “store” is generic infrastructure, not a purpose-matched surface or behavior.",
      "similarity": 0.594351053237915,
      "submission_summary": "Adds deterministic and configurable rule-violation file naming plus an integrity checker/repairer for TextFileBasedViolationStore, wiring new default.fileNames and default.integrity properties into initialization and save flows, and enhancing index/file synchronization and error handling. Extends the store’s file/path semantics (symlinks, shared files, broken/resolved/misplaced classifications) and updates docs accordingly.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.96,
      "contentAuthoredAt": 1786258071836,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: Java ArchUnit freeze store vs. Python SQLFluff linter.",
        "Submission modifies TextFileBasedViolationStore and adds StoreIntegrity and filename strategy classes to validate/repair an on-disk index and files; candidate adds a convergence tracker and rewrites fix-loop behavior to attribute non-converging rules and replay fixes without them.",
        "Submission’s behavior centers on filesystem semantics (naming from descriptions, detecting broken/misplaced/shared entries, moving/deleting files, handling symlinks, integrity modes ignore/repair/fail); candidate centers on iterative rule application semantics (detecting cycles/limit exhaustion, per-rule attribution, stable replay excluding implicated rules, preserving other fixes).",
        "Surfaces and APIs differ completely: ArchUnit adds configuration keys default.fileNames and default.integrity and corresponding factory/logic; SQLFluff introduces convergence.py, modifies linter/linted_file/linted_dir to expose attributed rules and replay logic.",
        "Scope differences: submission details line-break normalization, SHA-256-based name fingerprints, and strict path validations; candidate handles pass boundaries, rule activity histories, cycle detection, survivor replay, and reporting attributed rules."
      ],
      "one_liner": "They add new consistency policies in separate projects: one enforces filename/index integrity for a Java rule-violation store, the other attributes and suppresses non-converging autofix rules in a Python SQL linter to preserve stable fixes.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The two patches implement unrelated features in different repositories and touch entirely different purpose-matched surfaces. One is filesystem/index integrity and filename derivation for ArchUnit’s TextFileBasedViolationStore; the other is rule-level convergence attribution and replay in SQLFluff’s fix loop. There are no shared APIs, behaviors, or tests beyond generic notions of “consistency,” so they are distinct tasks.",
      "similarity": 0.5887515544891357,
      "submission_summary": "Adds integrity handling and configuration to TextFileBasedViolationStore: a file-naming strategy (random/description/custom), StoreIntegrity with modes ignore/repair/fail to classify and reconcile index entries vs. folder contents, and guarded save behavior including deletion/move semantics and symlink handling. Updates docs and normalizes line-break behavior for naming and reading.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.95,
      "contentAuthoredAt": 1784870646197,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds a folder/index reconciliation system for a text-file-based violation store (broken/resolved/misplaced/shared/colliding/occupied/unowned), with repair/fail/ignore modes, moves/deletes files, and enforces/derives file names. Candidate adds a checksummed record format, validates individual records, and reports integrity issues at the record level.",
        "Submission modifies TextFileBasedViolationStore, introduces StoreIntegrity, RuleViolationFileNameStrategyFactory, and RuleDescriptionFileNames in Java; candidate modifies Rust Gridstore modules (config, error, view, gridstore) and adds record.rs and integrity.rs, affecting binary encoding/decoding and auditing APIs.",
        "Submission’s integrity actions occur during store initialization and during save operations (e.g., deletion of resolved entries under repair), manipulating the index and filesystem semantics; candidate adds runtime APIs audit_integrity and copy_to_checksummed, changes delete_value behavior to preserve corrupt entries, and introduces migration to a new record format.",
        "Submission focuses on configuration keys default.fileNames and default.integrity with parsing/validation and name derivation constraints; candidate introduces RecordFormat in config.json, integrity error enums, and CRC32C header verification, decompression error handling, and length checks."
      ],
      "one_liner": "Both introduce integrity handling for persisted data, but in different repos and at different layers: one reconciles an index with on-disk text files, the other adds per-record checksums, auditing, and migration for a binary grid store.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The two patches target different repositories and solve integrity at different layers and with different surfaces. The submission reconciles an ArchUnit text-file violation store’s index and files, including file naming strategies and repair/fail modes. The candidate implements per-record checksums, decoding validation, an integrity audit report, and a migration path for Qdrant’s gridstore. There are no shared purpose-matched files or APIs, and the observable behaviors and scopes do not align beyond the generic theme of “integrity.”",
      "similarity": 0.5693660378456116,
      "submission_summary": "Extends ArchUnit’s TextFileBasedViolationStore with integrity modes (ignore/repair/fail), a strategy-based file naming system (random/description/custom), and a StoreIntegrity reconciler that classifies and repairs or reports inconsistencies between the stored.rules index and the store folder. Also adjusts save/delete flows and index/file handling to enforce ownership and name validity.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.98,
      "contentAuthoredAt": 1783974262114,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: ArchUnit (Java) freeze-rule violation storage vs. SQLFluff (Python) SQL linter fix application.",
        "Submission adds store integrity modes (ignore/repair/fail), file naming strategies, and index/folder reconciliation logic; candidate adds arbitration among conflicting fixes, tie-break policies, and counts deferred fixes.",
        "Submission modifies TextFileBasedViolationStore behavior (naming, ownership checks, deletion/move semantics, synchronized index operations) and docs; candidate extends CLI/config, introduces an arbitration module, integrates into the fixing loop, and reports deferred fixes."
      ],
      "one_liner": "One adds integrity checking and deterministic file naming to a Java freeze-store in ArchUnit, while the other arbitrates conflicting auto-fixes in the SQLFluff linter with new config and CLI options.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The two patches target unrelated repos and implement different features at different layers: ArchUnit’s patch changes storage/index integrity and file naming for frozen rule violations; SQLFluff’s patch introduces a conflict arbitration algorithm and reporting for rule fixes. There are no shared purpose-matched files, APIs, or behaviors beyond both adding config fields, which is boilerplate across many features. Thus they teach different lessons and should co-exist.",
      "similarity": 0.548665463924408,
      "submission_summary": "Implements deterministic rule-description-based file naming (or custom/random strategies) and adds integrity modes (ignore/repair/fail) to reconcile the TextFileBasedViolationStore index with on-disk files, including moving, deleting, and rejecting invalid states, with updated initialization and save semantics.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.93,
      "contentAuthoredAt": 1785764499698,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "They modify entirely different purpose surfaces: the submission changes the freeze store (TextFileBasedViolationStore, new StoreIntegrity and filename strategy classes, and docs) while the candidate changes the bytecode importer (adds FinallyAccessNormalizer, wires it into JavaClassProcessor, and build dependencies).",
        "Behavior diverges: the submission implements configurable file-naming strategies and integrity modes (ignore/repair/fail) that reconcile the stored.rules index with on-disk files, including moving/deleting files and rejecting invalid configurations; the candidate identifies and removes duplicate accesses produced by compiler-cloned finally blocks to ensure one reported access per source operation.",
        "Scope and edge cases differ: the submission handles symlinks/hard links, unowned/shared/misplaced/colliding entries, empty-violation files (only line breaks), and concurrency around index/file writes; the candidate handles try/catch/finally structures, switch/jump targets, abrupt exits, local-variable remapping, and ASM instruction equivalence across Java bytecode targets."
      ],
      "one_liner": "Both add robustness features to ArchUnit in different subsystems—one maintains integrity and naming for the freeze store, the other normalizes bytecode to deduplicate compiler-cloned finally accesses during import.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "Although both live in the same repository, they target different architectural layers for different purposes. The submission extends the freeze store with integrity checking/repair and deterministic file naming, while the candidate normalizes imported bytecode to deduplicate finally-body clones. There is no shared API surface or behavior; any overlap is purely at the project level, not the task level.",
      "similarity": 0.36445747236530285,
      "submission_summary": "Extends the text-based freeze store with configurable rule-violation file naming (random, description-derived, or custom strategy) and an integrity mode (ignore/repair/fail) that validates and reconciles the stored.rules index with on-disk files, including moving, deleting, and rejecting invalid targets. Modifies TextFileBasedViolationStore and adds StoreIntegrity and filename strategy helpers, plus user guide updates.",
      "verdict": "distinct"
    }
  ]
}
```

---

**Test Fairness**

Coverage Suggestions (2) - Not Blockers

Advisory only — these don't affect the check result.

Description-name property coverage
Add a deterministic property-based corpus (seeded) over many distinct descriptions, asserting pairwise distinct names, allowed characters, <=200 length, reserved-name avoidance, CRLF normalization, and eligible whole-word retention. The current suite is broad but still finite.

Concurrency operation matrix
Add deterministic latch-controlled cases for two simultaneous nonempty saves to the same known rule and for an unsafe/rejected save racing an examiner, asserting one complete serial outcome and no residue.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Description-name property coverage",
      "gapKind": "single_point",
      "requirement": "Names differ per rule and retain an eligible whole ASCII-alphanumeric word, including late words.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Add a deterministic property-based corpus (seeded) over many distinct descriptions, asserting pairwise distinct names, allowed characters, <=200 length, reserved-name avoidance, CRLF normalization, and eligible whole-word retention. The current suite is broad but still finite."
    },
    {
      "area": "Concurrency operation matrix",
      "gapKind": "not_discriminating",
      "requirement": "In-process concurrent initialize/save operations leave readable complete state and examinations do not overlap an active save.",
      "sourceIfAdded": "Prompt-stated",
      "suggestion": "Add deterministic latch-controlled cases for two simultaneous nonempty saves to the same known rule and for an unsafe/rejected save racing an examiner, asserting one complete serial outcome and no residue."
    }
  ],
  "error": "",
  "executionTimeSeconds": 299.773158,
  "message": "All hidden tests are fair.",
  "overall": "PASS: 0 unfair tests. The new maintenance suite is unusually comprehensive but its expectations closely track the very detailed prompt, including edge-case precedence and filesystem alias semantics. The unchanged baseline suites are fully visible in the repository. Suite-wide quality caveats: the symlink/hard-link, rooted-path, POSIX-permission/setpriv, WatchService, and child-JVM tests assume a Unix-like, feature-complete filesystem/runtime; the concurrency group uses 1–30 second waits and is timing-sensitive under severe load. These are group-level harness concerns, not fairness defects, so they are not repeated on every affected test.",
  "requirements": [
    {
      "covered": "yes",
      "coveringTests": [
        "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
        "randomFileNamesDeriveNothingSoNoEntryIsMisplaced",
        "namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced"
      ],
      "requirement": "default.fileNames defaults to random and random names new files without relocating existing entries.",
      "sourceQuote": "`default.fileNames` names new files and defaults to `random`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aRuleKeepsTheSameNameInALaterRun",
        "aDescriptionWithWindowsLineBreaksYieldsTheNameOfItsUnixSpelling",
        "aRuleKeepsTheSameNameOnAnotherMachine"
      ],
      "requirement": "Description names are deterministic and normalize CRLF to LF.",
      "sourceQuote": "With `description`, the name derives deterministically from the rule description, with each `\\r\\n` counting as `\\n`."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "twoRulesReadingAlikeStillGetDifferentNames",
        "aLongWordAfterOnlyShortOnesStillYieldsABoundedName",
        "aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt",
        "aWordWorthKeepingSurvivesAnOverlongWordBeginningWithIt"
      ],
      "requirement": "Names differ per rule and retain an eligible whole ASCII-alphanumeric word, including late words.",
      "sourceQuote": "Names differ per rule and, when the description contains a whole word of 4 to 120 ASCII letters or digits, keep such a word, even one that comes late in a long description."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
        "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
        "namesTakenFromTheDescriptionNeverCollideWithTheIndex"
      ],
      "requirement": "Built-in names are ASCII-safe, at most 200 characters, and not stored.rules.",
      "sourceQuote": "Built-in names use only ASCII letters, digits, underscores and hyphens. They never exceed 200 characters and are never `stored.rules`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves",
        "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected",
        "aStrategyThatCannotBeInstantiatedIsRejected"
      ],
      "requirement": "Configured custom strategy classes implement the interface and have a public no-arg constructor.",
      "sourceQuote": "Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
        "aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing",
        "aStrategyGivenToTheConstructorIsRejectedWhenTheSettingComesFromDefaults"
      ],
      "requirement": "Constructor strategies behave like configured ones; combining them with any Properties-level default.fileNames is rejected.",
      "sourceQuote": "A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store, even as a default of the given `Properties`, is rejected."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aNamingStrategyIsGivenTheRuleDescriptionUnchanged",
        "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore",
        "aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore"
      ],
      "requirement": "Custom strategies receive the exact description, including CRLF, and no-name results fail when needed.",
      "sourceQuote": "When a rule is stored, either kind of strategy is given its description exactly as it is, `\\r\\n` line breaks included. A strategy that yields no name is rejected as soon as a name is needed."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "unknownValueIsRejectedAndNamesTheAcceptedValues",
        "valuesNearAnAcceptedValueAreRejected"
      ],
      "requirement": "Integrity accepts exact repair/fail/ignore, defaults to ignore, and invalid values name all accepted values.",
      "sourceQuote": "`default.integrity` accepts the exact values `repair`, `fail` and `ignore`, and defaults to `ignore`, which examines nothing. `repair` and `fail` examine the index and the folder while initializing. Any other value is rejected, naming the three accepted."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne"
      ],
      "requirement": "Broken means the resolved path is not a direct regular folder file, including invalid paths.",
      "sourceQuote": "An entry is broken when its resolved path is not a regular file directly in the folder, including when its name is not a valid path at all."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks"
      ],
      "requirement": "No-violation and all-supported-line-break files are resolved.",
      "sourceQuote": "An entry that is not broken is resolved when the file its name leads to yields no violations, as a file of line breaks alone (`\\n`, `\\r\\n` or a lone `\\r`) does."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved",
        "aStoredViolationHoldingABackslashBeforeACarriageReturnIsReadAsItWasStored"
      ],
      "requirement": "Embedded carriage returns remain in violation text.",
      "sourceQuote": "Violation files keep their current format, in which a carriage return inside a stored violation stays part of that violation's text."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
        "aDerivedNameAnUnownedFileOccupiesIsNotTakenOver",
        "twoEntriesThatWouldSwapNamesAreNotMoved",
        "aDerivedNameLeavingTheStoreFolderIsNeverUsed",
        "anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs"
      ],
      "requirement": "Misplaced, occupied, and settled-entry exceptions use the stated definitions.",
      "sourceQuote": "An entry is misplaced when its name is not its rule's derived one. A misplaced entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder. An entry that already records its derived name is never occupied."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded"
      ],
      "requirement": "Same-name/same-file aliases are shared, including symbolic/hard links and outside targets.",
      "sourceQuote": "Entries recording the same name are shared, even if nothing exists under it. Entries whose names reach the same file are shared too, including through a symbolic or hard link and when that file is outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
        "entriesWhoseRulesDifferOnlyInWindowsAndUnixLineBreaksDeriveOneNameAndCollide"
      ],
      "requirement": "Rules deriving one name collide.",
      "sourceQuote": "Entries whose rules derive one name are colliding."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
        "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
        "theIndexItselfIsNeverUnowned"
      ],
      "requirement": "Direct unreferenced regular files are unowned, with symlink reachability counting as ownership.",
      "sourceQuote": "Apart from the index, a regular file directly in the folder that no entry's name leads to, directly or through a symbolic link, is unowned."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
        "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
        "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName",
        "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied"
      ],
      "requirement": "Shared/unowned items are left alone; colliding/occupied items are not moved but can still be discarded when broken/resolved; shared has precedence.",
      "sourceQuote": "The store leaves shared entries and unowned files alone and never moves a colliding or occupied entry, though it still discards one that is broken or resolved. An entry both shared and something else stays shared."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "entriesWhoseRuleDescriptionsDifferOnlyInTheirLineBreaksAreRepairedEachOnItsOwn",
        "aDescriptionWithWindowsLineBreaksYieldsTheNameOfItsUnixSpelling"
      ],
      "requirement": "Index CRLF/LF descriptions remain distinct; API lookup normalizes CRLF to LF.",
      "sourceQuote": "Entries already in the index whose rule descriptions differ only in their line breaks are still separate entries, while storing or reading a rule looks its description up with each `\\r\\n` counting as `\\n`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "everyBrokenEntryIsDiscarded",
        "anEntryWhoseFileIsAbsentIsBroken"
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
      "requirement": "Repair discards resolved entries and deletes link target with link.",
      "sourceQuote": "It discards resolved entries with the files they name, deleting a link's target with the link."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
        "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt"
      ],
      "requirement": "Repair moves movable misplaced files, moving link targets rather than links.",
      "sourceQuote": "It moves a misplaced entry's file to its derived name, moving a link's target rather than the link."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
        "aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex",
        "repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore"
      ],
      "requirement": "Repair writes the index only on entry changes and requires update permission.",
      "sourceQuote": "It writes the index only when an entry changed. `repair` needs `default.allowStoreUpdate` and is rejected without it."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "failAcceptsAConsistentStoreAndRejectsAnInconsistentOne",
        "failWithSeveralConditionsAtOnceChangesNotOneByte"
      ],
      "requirement": "Fail changes nothing and rejects inconsistent stores.",
      "sourceQuote": "`fail` changes nothing, rejecting initialization unless the index and folder agree."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne"
      ],
      "requirement": "A creatable absent index is examined as empty and a rejecting fail never creates it.",
      "sourceQuote": "A folder whose absent index may be created is examined as if that index were empty, and a rejection does not even create it."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "failNamesTheConditionsInTheStatedOrder",
        "failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName",
        "failOrdersSharedEntriesByRuleDescription",
        "failOrdersOccupiedEntriesByRuleDescription"
      ],
      "requirement": "Fail reports all conditions in the required category and intra-category orders.",
      "sourceQuote": "The `fail` report names every entry in any condition and every unowned file. It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it. Within a condition it orders entries by rule description and files by name."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "failWithoutPermissionToUpdateStillReportsTheInconsistency"
      ],
      "requirement": "Fail does not require update permission.",
      "sourceQuote": "`fail` does not need `default.allowStoreUpdate`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined",
        "anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined",
        "aStoreFolderReachedThroughALinkIsMaintainedAndStoredInLikeAnyOther"
      ],
      "requirement": "Missing/non-direct-regular index is rejected before examination; folder path itself may be a symlink.",
      "sourceQuote": "An absent index without `default.allowStoreCreation`, or one not a regular file directly in the folder, is rejected before anything is examined. The folder itself may be reached through a link."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingAStillViolatedRuleWritesThroughTheLinkItsEntryRecords",
        "storingAStillViolatedRuleWritesToItsOwnFileEvenWhenItsDerivedNameIsOccupied"
      ],
      "requirement": "Known-rule saves follow the recorded name, including symlinks.",
      "sourceQuote": "Storing a rule writes its violations to the file its entry's name leads to, even through a symbolic link."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected",
        "storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected",
        "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn",
        "storingASecondUnknownRuleNeverTakesOverTheFirstRulesFile"
      ],
      "requirement": "Unsafe/index/out-of-folder/new-name-conflict saves reject atomically.",
      "sourceQuote": "The store rejects that write, leaving the index and the folder as they were, if the name leads to the index (under any spelling or through a symbolic or hard link), leads anywhere but directly into the folder, or, for a rule that has no entry yet, already names something or is recorded by another entry."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
        "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside"
      ],
      "requirement": "Repair-mode empty save forgets known rule and removes non-shared file; shared files remain.",
      "sourceQuote": "Under `repair`, saving no violations for a known rule forgets that rule instead. Its entry is removed, and so is its file unless another entry shares that file. A shared file is kept and only the entry removed, even when that entry's name leads outside the folder."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleTheIndexNeverKnewStoresNothingForIt"
      ],
      "requirement": "Repair-mode empty save for unknown rule stores nothing.",
      "sourceQuote": "Under `repair`, saving no violations for an unknown rule stores nothing."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
        "aStillViolatedRuleKeepsItsEntryUnderRepair"
      ],
      "requirement": "Deletion failure rejects forget and preserves entry; violations preserve entry.",
      "sourceQuote": "If the file cannot be deleted, the save is rejected and the entry stays. A rule with violations keeps its entry."
    },
    {
      "covered": "partial",
      "coveringTests": [
        "concurrentInitializationsLeaveAReadableIndex",
        "examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave",
        "oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind",
        "repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved",
        "concurrentRepairAndFailLeaveAReadableIndex"
      ],
      "requirement": "In-process concurrent initialize/save operations leave readable complete state and examinations do not overlap an active save.",
      "sourceQuote": "Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress."
    }
  ],
  "taskSummary": "The task extends TextFileBasedViolationStore with configurable file naming and initialization-time integrity modes. It must preserve the existing index/violation-file format, normalize CRLF only where the prompt says, classify broken/resolved/shared/unowned/misplaced/colliding/occupied states with explicit precedence, repair or report them without collateral changes, reject unsafe writes, forget resolved rules only under repair, and serialize in-process initialization/save operations. Defaults are default.fileNames=random and default.integrity=ignore; repair requires update permission, fail does not; index creation/type checks precede examination.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The prompt says integrity “defaults to ignore, which examines nothing” and “repair discards broken entries.”",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Directly distinguishes the default from repair.",
      "verifies": "With no integrity property the broken entry remains; a later repair removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly assigns those effects to ignore and repair.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Direct and fair, though partly redundant with the default-value test.",
      "verifies": "Explicit ignore preserves the broken entry; repair removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt says ignore examines nothing; repair discards broken/resolved entries, leaves shared/unowned/occupied entries alone, and moves a movable misplaced entry.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Strong mixed-condition/precedence test.",
      "verifies": "Ignore preserves every file and byte; subsequent repair removes broken/resolved entries and the resolved file, retains shared/unowned/occupied items, and moves only the free misplaced file with content intact."
    },
    {
      "concerns": [],
      "evidence": "“Any other value is rejected, naming the three accepted.”",
      "fairness": "Prompt-stated",
      "name": "unknownValueIsRejectedAndNamesTheAcceptedValues",
      "qualityCheck": "Uses substring checks rather than pinning full prose.",
      "verifies": "Integrity value prune throws a RuntimeException whose message contains ignore, repair, and fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt accepts the exact values repair, fail, and ignore.",
      "fairness": "Prompt-stated",
      "name": "valuesNearAnAcceptedValueAreRejected",
      "qualityCheck": "Good exactness boundary coverage.",
      "verifies": "Repair, repair-space, repairs, IGNORE, and failed all throw."
    },
    {
      "concerns": [],
      "evidence": "“fail changes nothing, rejecting initialization unless the index and folder agree” and its report names every conditioned entry.",
      "fairness": "Prompt-stated",
      "name": "failAcceptsAConsistentStoreAndRejectsAnInconsistentOne",
      "qualityCheck": "Checks both acceptance and non-mutation.",
      "verifies": "Fail initializes a healthy store; for a missing file it throws, names the rule, and leaves the index entry present."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards broken entries and writes the index only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Clear positive/negative comparison.",
      "verifies": "Repair retains the healthy entry/file and removes a broken entry."
    },
    {
      "concerns": [],
      "evidence": "An entry is broken when its resolved path is not a regular file directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "Canonical broken-entry case.",
      "verifies": "Repair removes only the absent-file entry and leaves the healthy entry/file."
    },
    {
      "concerns": [],
      "evidence": "“repair discards broken entries.”",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Checks that repair is exhaustive rather than first-match only.",
      "verifies": "All three missing-file entries are removed while the healthy entry remains."
    },
    {
      "concerns": [],
      "evidence": "A broken entry includes one whose path is not a regular file directly in the folder; repair discards the entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "Also guards against deleting unrelated directories.",
      "verifies": "The directory-valued entry is removed, but the directory itself remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines non-direct paths as broken and says repair discards broken entries, not outside files.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Good traversal-safety check.",
      "verifies": "A ../ outside entry is removed and the outside file and bytes survive."
    },
    {
      "concerns": [],
      "evidence": "A valid entry must resolve to a regular file directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "Covers two rooted spellings.",
      "verifies": "Both absolute/rooted entries are removed; files outside and inside that were reached by unsafe spellings remain byte-identical."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires the resolved regular file to be directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Direct hierarchy-boundary check.",
      "verifies": "A nested-path entry is removed while the nested file remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt expressly includes a name “not a valid path at all” as broken.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne",
      "qualityCheck": "Good malformed-path robustness test.",
      "verifies": "Fail reports the NUL-named rule without corrupting the index; repair removes only it, preserves the healthy entry/file, and leaves a fail-clean store."
    },
    {
      "concerns": [],
      "evidence": "“Entries already in the index whose rule descriptions differ only in their line breaks are still separate entries.”",
      "fairness": "Prompt-stated",
      "name": "entriesWhoseRuleDescriptionsDifferOnlyInTheirLineBreaksAreRepairedEachOnItsOwn",
      "qualityCheck": "Precisely tests index-entry identity versus lookup normalization.",
      "verifies": "The CRLF-key broken entry is removed independently of the LF-key healthy entry; lookup of the LF rule returns its violation."
    },
    {
      "concerns": [],
      "evidence": "Description naming counts CRLF as LF; entries whose rules derive one name collide; colliding entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "entriesWhoseRulesDifferOnlyInWindowsAndUnixLineBreaksDeriveOneNameAndCollide",
      "qualityCheck": "Strong interaction test.",
      "verifies": "Fail names both rules; repair moves neither and preserves both legacy files/entries."
    },
    {
      "concerns": [],
      "evidence": "Brokenness is defined by the resolved path, not lexical spelling.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "Good normalization case.",
      "verifies": "A ./ spelling survives repair, reads the same violation, and only the unrelated broken entry disappears."
    },
    {
      "concerns": [],
      "evidence": "The resolved path is not a regular file directly in the folder, so it is broken.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Covers symlink escape safety.",
      "verifies": "Repair removes the entry, preserves the outside target, and leaves the result acceptable to fail."
    },
    {
      "concerns": [],
      "evidence": "Ownership is defined by where an entry’s name leads, including through a symbolic link.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Complements the outside-link case.",
      "verifies": "The linked entry and target survive, the unrelated broken entry is removed, and fail then accepts."
    },
    {
      "concerns": [],
      "evidence": "Only a regular file directly in the folder can be unowned; repair leaves unowned items alone.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Validates that a symlink itself is not treated as a direct regular unowned file.",
      "verifies": "A stray symlink and its outside target survive while a broken entry is removed; fail accepts afterward."
    },
    {
      "concerns": [],
      "evidence": "Its resolved path is not a regular file directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "Direct dangling-link case.",
      "verifies": "Repair removes the entry for a dangling symlink."
    },
    {
      "concerns": [],
      "evidence": "Different names that reach no file are broken; only shared entries are protected.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry",
      "qualityCheck": "Distinguishes sharing from two broken names.",
      "verifies": "Both entries are removed and the dangling link itself remains."
    },
    {
      "concerns": [],
      "evidence": "Sharing by reached file requires a file; an absent resolved path is broken.",
      "fairness": "Prompt-stated",
      "name": "entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken",
      "qualityCheck": "Useful lexical-alias edge case.",
      "verifies": "Fail names both missing entries; repair removes both rather than classifying them shared."
    },
    {
      "concerns": [],
      "evidence": "An unbroken entry is resolved when its file yields no violations; repair discards resolved entries with their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Canonical resolved case.",
      "verifies": "Repair removes the empty-file entry and leaves only the index."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says deleting a resolved link’s target deletes it “with the link.”",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Directly tests the specified link-delete semantics.",
      "verifies": "Repair removes the entry, target, and symlink; only the index remains and fail accepts."
    },
    {
      "concerns": [],
      "evidence": "A file of line breaks alone yields no violations.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Good discriminating companion file.",
      "verifies": "The LF-only file and entry are deleted; the nonempty violation entry/file remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly lists LF, CRLF, and lone CR as line-break-only resolved forms.",
      "fairness": "Prompt-stated",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Thorough line-ending coverage.",
      "verifies": "CRLF-only, lone-CR-only, and LF-only files are all removed; a file containing violation text remains."
    },
    {
      "concerns": [],
      "evidence": "“A carriage return inside a stored violation stays part of that violation’s text.”",
      "fairness": "Prompt-stated",
      "name": "carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved",
      "qualityCheck": "Strong format-regression test.",
      "verifies": "Round trips embedded CR/CRLF violation text exactly; repair removes only the line-break-only entry; fail/read preserves all three violations."
    },
    {
      "concerns": [],
      "evidence": "The current violation format must be kept and carriage returns inside violations remain text.",
      "fairness": "Prompt-stated",
      "name": "aStoredViolationHoldingABackslashBeforeACarriageReturnIsReadAsItWasStored",
      "qualityCheck": "Useful escaping regression case.",
      "verifies": "Repair preserves the legacy file byte-for-byte and reading returns backslash+CR text plus plain as two violations."
    },
    {
      "concerns": [],
      "evidence": "Resolved means the file yields no violations.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Simple boundary test.",
      "verifies": "Repair retains the one-violation entry/file and deletes the empty one."
    },
    {
      "concerns": [],
      "evidence": "“Entries recording the same name are shared, even if nothing exists under it” and shared entries are left alone.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Direct same-name sharing case.",
      "verifies": "Two empty entries recording the same name survive repair; only an unrelated broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt expressly defines sharing through symbolic links, including when the file is outside the folder.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Comprehensive alias case.",
      "verifies": "Symlink aliases, including two names reaching one outside file, keep both entries/files while unrelated broken entries disappear."
    },
    {
      "concerns": [],
      "evidence": "The prompt expressly includes hard links in shared-file detection.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded",
      "qualityCheck": "Direct filesystem-identity check.",
      "verifies": "Fail names both hard-linked entries; repair preserves both entries and both link names despite empty content."
    },
    {
      "concerns": [],
      "evidence": "“An entry both shared and something else stays shared” and shared entries are left alone.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Strong precedence matrix.",
      "verifies": "Shared empty entries survive even when also colliding or their derived names are occupied; ordinary empty/broken entries are removed and occupants remain."
    },
    {
      "concerns": [],
      "evidence": "Fail reports shared entries and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesSharedEntriesAndChangesNothing",
      "qualityCheck": "Uses required names, not full message prose.",
      "verifies": "Fail throws with both shared rule names and preserves index/file state."
    },
    {
      "concerns": [],
      "evidence": "“An entry both shared and something else stays shared.”",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair",
      "qualityCheck": "Direct precedence test.",
      "verifies": "Fail names both shared-missing entries and the lone broken one; repair preserves the shared entries but removes the lone broken entry."
    },
    {
      "concerns": [],
      "evidence": "The store leaves unowned files alone.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Canonical unowned-file repair case.",
      "verifies": "Repair removes the broken entry but leaves the unowned file and its bytes."
    },
    {
      "concerns": [],
      "evidence": "Fail reports every unowned file and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesUnownedFilesAndChangesNothing",
      "qualityCheck": "Direct report/non-mutation check.",
      "verifies": "Fail names stray and leaves index, owned file, and stray file in place."
    },
    {
      "concerns": [],
      "evidence": "Unowned is defined only for a regular file directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "aDirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Good type discrimination.",
      "verifies": "Fail accepts a store with an extra directory but rejects one with an extra regular file and names that file."
    },
    {
      "concerns": [],
      "evidence": "Only regular files directly in the folder can be unowned.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Covers depth explicitly.",
      "verifies": "Fail reports only the broken entry, not buried; repair removes that entry and leaves the nested file/content unchanged."
    },
    {
      "concerns": [],
      "evidence": "The unowned definition says “Apart from the index.”",
      "fairness": "Prompt-stated",
      "name": "theIndexItselfIsNeverUnowned",
      "qualityCheck": "Direct index exclusion test.",
      "verifies": "Fail accepts a store containing only a healthy entry/index and reports only a broken entry in the comparison store."
    },
    {
      "concerns": [],
      "evidence": "Repair only changes broken/resolved/movable-misplaced entries; once repaired no such condition remains.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Useful idempotence check.",
      "verifies": "A second repair preserves the first repair’s surviving entry and exact file-name set."
    },
    {
      "concerns": [],
      "evidence": "Entries reaching the same file through a link are shared and shared entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Tests precedence plus idempotence.",
      "verifies": "Two shared entries remain after two repairs; entry/file sets are identical and content remains intact."
    },
    {
      "concerns": [],
      "evidence": "Repair’s specified transformations restore agreement; fail rejects only disagreement.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderPassesAFailingCheck",
      "qualityCheck": "Good end-to-end consistency check.",
      "verifies": "After repair removes broken/resolved entries, fail accepts and only the healthy entry remains."
    },
    {
      "concerns": [],
      "evidence": "Repair discards the index entry; stores read/lookup rules from stored.rules.",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Guards against stale in-memory state.",
      "verifies": "A new store reports the discarded rule absent and the survivor present."
    },
    {
      "concerns": [],
      "evidence": "Repair discards broken entries and resolved entries with their files.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Concise filesystem invariant check.",
      "verifies": "For broken/resolved/healthy setup, only index and healthy file remain, with the healthy mapping intact."
    },
    {
      "concerns": [],
      "evidence": "Concurrent initializations must leave a readable index and only survivors’ files.",
      "fairness": "Prompt-stated",
      "name": "concurrentInitializationsLeaveAReadableIndex",
      "qualityCheck": "Direct concurrency outcome test.",
      "verifies": "Four concurrent repairs finish within 30 seconds without failures and leave exactly the healthy entry/file."
    },
    {
      "concerns": [],
      "evidence": "Concurrent initializations must serialize safely; repair moves a movable misplaced file to its derived name.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairsOfAMisplacedEntryLeaveItOnItsMovedFile",
      "qualityCheck": "Deterministic latch orchestration is stronger than a race-only test.",
      "verifies": "Two deliberately overlapped repairs terminate, leave one entry mapped to derived, preserve content, and pass fail."
    },
    {
      "concerns": [],
      "evidence": "“No store examines a save still in progress.”",
      "fairness": "Prompt-stated",
      "name": "examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave",
      "qualityCheck": "Precisely intercepts the save while it reads violations.",
      "verifies": "Repair and fail examiners remain blocked during a held save; all operations finish without failure; the new rule/index/file and violation are readable."
    },
    {
      "concerns": [],
      "evidence": "Concurrent saves must leave a readable index and only survivors’ files.",
      "fairness": "Prompt-stated",
      "name": "oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind",
      "qualityCheck": "Correctly permits either serial order while rejecting torn state.",
      "verifies": "Overlapped save/forget operations finish without errors and leave either no entry/file or one complete entry/file with the held save’s full content; fail accepts."
    },
    {
      "concerns": [],
      "evidence": "No examination may observe an in-progress save; repair moves a misplaced entry’s file afterward.",
      "fairness": "Prompt-stated",
      "name": "repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved",
      "qualityCheck": "Strong serialization/content test.",
      "verifies": "Repair waits for held save, then leaves the rule at its derived name with newly saved rather than old content; read/fail succeeds."
    },
    {
      "concerns": [],
      "evidence": "No examination may observe an in-progress save; resolved classification is based on yielded violations.",
      "fairness": "Prompt-stated",
      "name": "repairingTheFolderWhileAnotherStoreSavesIntoAnEmptiedFileKeepsTheEntryAndTheFile",
      "qualityCheck": "Targets the key resolved/save race.",
      "verifies": "Repair waits for held save and then keeps the previously empty file because it now contains the complete saved violation."
    },
    {
      "concerns": [],
      "evidence": "Concurrent initializations must leave a readable index and survivor files.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairAndFailLeaveAReadableIndex",
      "qualityCheck": "Good mixed-mode stress check.",
      "verifies": "Six concurrent repair/fail initializations terminate; only expected fail exceptions are tolerated; final index/file set contains the healthy survivor."
    },
    {
      "concerns": [],
      "evidence": "“repair needs default.allowStoreUpdate and is rejected without it.” The rejection is a precondition to repair.",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedAndChangesNothing",
      "qualityCheck": "Checks the permission gate before mutation.",
      "verifies": "Repair with allowStoreUpdate=false throws and leaves both index entries and the healthy file unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt makes update permission a requirement for repair mode itself, not only for changed stores.",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore",
      "qualityCheck": "Good mode-level permission boundary.",
      "verifies": "Repair with update permission disabled throws even when no repair would be needed."
    },
    {
      "concerns": [],
      "evidence": "“fail does not need default.allowStoreUpdate.”",
      "fairness": "Prompt-stated",
      "name": "failWithoutPermissionToUpdateStillReportsTheInconsistency",
      "qualityCheck": "Direct distinction from repair.",
      "verifies": "Fail with updates disabled throws and names the broken rule."
    },
    {
      "concerns": [],
      "evidence": "An absent index without allowStoreCreation “is rejected before anything is examined.”",
      "fairness": "Prompt-stated",
      "name": "anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined",
      "qualityCheck": "Checks both precondition precedence and later normal behavior.",
      "verifies": "Repair/fail with creation disabled reject before creating or reporting folder conditions; once an index exists, repair proceeds and removes its broken entry."
    },
    {
      "concerns": [],
      "evidence": "An absent creatable index is examined as empty, and “a rejection does not even create it.”",
      "fairness": "Prompt-stated",
      "name": "failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne",
      "qualityCheck": "The WatchService assertion directly tests “not even” transiently.",
      "verifies": "Fail on an allowed-creation folder with stray file reports stray, preserves bytes, leaves no index, and emits no transient index creation event."
    },
    {
      "concerns": [],
      "evidence": "An index not a regular file directly in the folder is rejected before examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatIsALinkOutOfTheStoreFolderIsRejectedAndItsTargetSurvives",
      "qualityCheck": "Good index path-safety case.",
      "verifies": "Repair rejects a symlink index and preserves the outside target bytes."
    },
    {
      "concerns": [],
      "evidence": "A non-direct-regular index is rejected before anything is examined.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined",
      "qualityCheck": "Tests precedence and non-mutation.",
      "verifies": "Repair and fail reject the symlink index without mentioning folder conditions or changing target bytes; the link and files remain."
    },
    {
      "concerns": [],
      "evidence": "“The folder itself may be reached through a link.”",
      "fairness": "Prompt-stated",
      "name": "aStoreFolderReachedThroughALinkIsMaintainedAndStoredInLikeAnyOther",
      "qualityCheck": "Complete initialize-save-read integration case.",
      "verifies": "Repair and save through a folder symlink preserve the alias, repair broken state, store/read a new rule, and pass fail."
    },
    {
      "concerns": [],
      "evidence": "An index not a regular file directly in the folder is rejected before examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired",
      "qualityCheck": "Also guards against global poisoning after failure.",
      "verifies": "Directory-valued index is rejected by repair/fail with all bytes/names unchanged; an independent valid store still repairs normally."
    },
    {
      "concerns": [],
      "evidence": "The prompt specifies “broken, resolved and shared entries, then unowned files, in that order.”",
      "fairness": "Prompt-stated",
      "name": "failNamesTheConditionsInTheStatedOrder",
      "qualityCheck": "Checks relative positions only, allowing arbitrary prose.",
      "verifies": "Message positions are broken rule, resolved rule, shared rule, then unowned file."
    },
    {
      "concerns": [],
      "evidence": "“Within a condition it orders entries by rule description and files by name.”",
      "fairness": "Prompt-stated",
      "name": "failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName",
      "qualityCheck": "Uses inverted setup to discriminate sorting.",
      "verifies": "Broken rule names appear alpha before zulu; unowned file names appear alpha before zulu."
    },
    {
      "concerns": [],
      "evidence": "Entries within a condition are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersSharedEntriesByRuleDescription",
      "qualityCheck": "Good anti-accidental-order setup.",
      "verifies": "Four shared rules appear in rule-description order, not recorded-file order."
    },
    {
      "concerns": [],
      "evidence": "Within a condition, entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescription",
      "qualityCheck": "Direct ordering check.",
      "verifies": "Misplaced rule names appear alpha, mike, zulu."
    },
    {
      "concerns": [],
      "evidence": "Within a condition, entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersCollidingEntriesByRuleDescription",
      "qualityCheck": "Direct ordering check.",
      "verifies": "Colliding rule names appear alpha, mike, zulu."
    },
    {
      "concerns": [],
      "evidence": "Within a condition, entries are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersOccupiedEntriesByRuleDescription",
      "qualityCheck": "Strong discriminator against sorting by file name.",
      "verifies": "Occupied rule names appear alpha, mike, zulu despite inversely ordered derived names."
    },
    {
      "concerns": [],
      "evidence": "The specified key is rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescriptionAndNotByTheirDerivedNames",
      "qualityCheck": "Explicitly rejects a plausible wrong comparator.",
      "verifies": "Misplaced entries appear alpha, mike, zulu despite inverted derived-name order."
    },
    {
      "concerns": [],
      "evidence": "“fail changes nothing.”",
      "fairness": "Prompt-stated",
      "name": "failWithSeveralConditionsAtOnceChangesNotOneByte",
      "qualityCheck": "Strong byte-level non-mutation check.",
      "verifies": "Fail throws and preserves the exact file-name list and bytes of every file."
    },
    {
      "concerns": [],
      "evidence": "Repair discards resolved entries; contains is the visible index-membership API.",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Good integration consequence.",
      "verifies": "After repair removes a resolved entry, a fresh store’s contains returns false."
    },
    {
      "concerns": [],
      "evidence": "Only entries yielding no violations are resolved; a violating entry is retained.",
      "fairness": "Prompt-stated",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Good API-level survivor check.",
      "verifies": "Repair removes only the broken neighbor; contains remains true and getViolations returns the surviving text."
    },
    {
      "concerns": [],
      "evidence": "Repair discards the resolved entry/file; normal storing writes a new rule and violations.",
      "fairness": "Prompt-stated",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Useful lifecycle integration.",
      "verifies": "A resolved rule is removed, then save re-adds it with new violation under a non-resolved file name."
    },
    {
      "concerns": [],
      "evidence": "Discarding the entry makes the rule unknown; existing freezing semantics store an unknown rule, visible in the repository’s FreezingArchRule tests.",
      "fairness": "Prompt-stated",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Fair integration with the existing public workflow.",
      "verifies": "After repair empties the index, real FreezingArchRule evaluation passes, re-stores the rule, and does not reuse resolved."
    },
    {
      "concerns": [],
      "evidence": "Random “names new files”; only description/custom strategies derive a repeatable expected name for misplaced classification.",
      "fairness": "Prompt-stated",
      "name": "randomFileNamesDeriveNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Correctly checks legacy stability under the default.",
      "verifies": "Default random naming leaves an arbitrary healthy legacy name in place while removing a broken entry."
    },
    {
      "concerns": [],
      "evidence": "default.fileNames accepts random, which names new files rather than deriving existing names.",
      "fairness": "Prompt-stated",
      "name": "namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Complements the absent-setting default test.",
      "verifies": "Explicit random leaves the arbitrary name/file unchanged under repair and is accepted by fail."
    },
    {
      "concerns": [],
      "evidence": "“A strategy given to the constructor names files the same way.”",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
      "qualityCheck": "Tests both maintenance and save integration.",
      "verifies": "Constructor strategy moves a legacy entry/content to its derived name and names/saves a new rule the same way."
    },
    {
      "concerns": [],
      "evidence": "Configuring default.fileNames for such a store is rejected.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing",
      "qualityCheck": "Direct conflict check.",
      "verifies": "Constructor strategy plus explicit default.fileNames throws and preserves entry/file state."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly includes configuration “even as a default of the given Properties.”",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorIsRejectedWhenTheSettingComesFromDefaults",
      "qualityCheck": "Precisely covers Java Properties inheritance.",
      "verifies": "The same conflict inherited through Properties defaults throws without changing index bytes/files."
    },
    {
      "concerns": [],
      "evidence": "A strategy yielding no name is rejected as soon as a name is needed; repair/fail need derived names to classify entries.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Covers both representations of no name.",
      "verifies": "Null- and empty-returning constructor strategies both throw under repair and fail; index bytes/files remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt defaults to random; names differ per rule, obey the built-in character/length/index constraints, and random does not derive relocation targets.",
      "fairness": "Prompt-stated",
      "name": "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
      "qualityCheck": "Covers all stated built-in-name invariants.",
      "verifies": "Default random gives two rules distinct ASCII-safe, non-index names of at most 200 characters; broken entry is removed; later repair does not relocate either random name."
    },
    {
      "concerns": [],
      "evidence": "Any other default.fileNames value denotes a RuleViolationFileNameStrategy implementation.",
      "fairness": "Prompt-stated",
      "name": "aConfiguredStrategyNamesNewlyStoredRules",
      "qualityCheck": "Direct configured-strategy save test.",
      "verifies": "Configured custom strategy maps a new rule to its exact strategy-derived name and creates only that file plus the index."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires and permits an implementation with a public no-argument constructor.",
      "fairness": "Prompt-stated",
      "name": "aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves",
      "qualityCheck": "Tests the positive reflection path.",
      "verifies": "A configured public-no-arg strategy derives exact names for a moved legacy rule and a newly saved rule, preserving expected file contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt constrains the constructor to be public, not the implementation class itself; this class is also in the store’s package.",
      "fairness": "Prompt-stated",
      "name": "aStrategyClassThatIsNotItselfPublicIsUsedThroughItsPublicNoArgumentConstructor",
      "qualityCheck": "Useful distinction between class and constructor visibility.",
      "verifies": "A package-private implementation with a public no-arg constructor is instantiated and its exact names/content are used for move and save."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says custom strategies receive descriptions exactly, with CRLF included.",
      "fairness": "Prompt-stated",
      "name": "aNamingStrategyIsGivenTheRuleDescriptionUnchanged",
      "qualityCheck": "Uses a recording strategy to test the callback argument directly.",
      "verifies": "Constructor/configured strategies each receive exactly first-CRLF-second, create the expected file, and round-trip the violation."
    },
    {
      "concerns": [],
      "evidence": "Other values must name an implementation constructible as specified.",
      "fairness": "Prompt-stated",
      "name": "aStrategyThatCannotBeInstantiatedIsRejected",
      "qualityCheck": "Basic reflection failure case.",
      "verifies": "A nonexistent strategy class causes initialization to throw."
    },
    {
      "concerns": [],
      "evidence": "The configured class must implement RuleViolationFileNameStrategy and have a public no-argument constructor.",
      "fairness": "Prompt-stated",
      "name": "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected",
      "qualityCheck": "Good negative reflection matrix.",
      "verifies": "Wrong type, missing no-arg constructor, and private no-arg constructor each throw; existing index/file remain."
    },
    {
      "concerns": [],
      "evidence": "A strategy yielding no name is rejected as soon as classification needs it.",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Configured counterpart to the constructor test.",
      "verifies": "Configured null/empty strategies throw under repair and fail without changing index bytes/files."
    },
    {
      "concerns": [],
      "evidence": "Ignore examines nothing; a no-name strategy is rejected as soon as a new rule needs a name.",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore",
      "qualityCheck": "Strong atomicity and laziness test.",
      "verifies": "Ignore does not invoke the strategy; save invokes it, throws for null/empty, leaves index/files/content unchanged, leaves the new rule absent and old rule present."
    },
    {
      "concerns": [],
      "evidence": "Repair moves a misplaced entry’s file to its derived name.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
      "qualityCheck": "Canonical misplaced repair.",
      "verifies": "Repair changes the mapping to the exact derived name, moves content there, and leaves only index plus derived file."
    },
    {
      "concerns": [],
      "evidence": "Repair moves the file; violation files keep their format/content.",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryKeepsItsViolationsAfterTheMove",
      "qualityCheck": "Checks semantic content, not merely names.",
      "verifies": "After move, reading returns both original violations and the index records the derived name."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says moving a link moves its target rather than the link.",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt",
      "qualityCheck": "Direct link-move semantics.",
      "verifies": "Repair maps to a non-symlink derived file with original content, removes old target/link names, and fail accepts."
    },
    {
      "concerns": [],
      "evidence": "Fail reports every conditioned entry and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesMisplacedEntriesAndChangesNothing",
      "qualityCheck": "Direct fail counterpart.",
      "verifies": "Fail names the misplaced rule and preserves its recorded mapping/file."
    },
    {
      "concerns": [],
      "evidence": "A misplaced entry is occupied when its derived name escapes the folder; occupied entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameLeavingTheStoreFolderIsNeverUsed",
      "qualityCheck": "Covers relative and rooted strategies.",
      "verifies": "Relative-escaping and absolute derived names do not move entries or touch outside files; fail reports the inconsistency."
    },
    {
      "concerns": [],
      "evidence": "Entries whose rules derive one name are colliding, and colliding entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
      "qualityCheck": "Canonical collision case.",
      "verifies": "Both legacy mappings/files remain; fail names both colliding rules."
    },
    {
      "concerns": [],
      "evidence": "A derived name that already names something is occupied; occupied entries are never moved.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameAnUnownedFileOccupiesIsNotTakenOver",
      "qualityCheck": "Guards against destructive takeover.",
      "verifies": "Repair keeps the legacy mapping/content and unowned occupant content; fail names the rule."
    },
    {
      "concerns": [],
      "evidence": "“Already names something” includes a symlink path; occupied entries are not moved.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkOutOfTheStoreFolderOccupiesIsNotTakenOver",
      "qualityCheck": "Good symlink occupant case.",
      "verifies": "Repair leaves legacy entry/content, symlink target content, and fail-reportable inconsistency intact."
    },
    {
      "concerns": [],
      "evidence": "Occupied is based on the derived name already naming something, including a dangling link.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADanglingLinkOccupiesIsNotTakenOver",
      "qualityCheck": "Tests no-follow existence.",
      "verifies": "A dangling symlink at the derived name blocks movement; legacy content remains and fail names the rule."
    },
    {
      "concerns": [],
      "evidence": "Occupation is assessed at each entry’s derived name; merely being a dangling link target does not mean the free name already names something.",
      "fairness": "Prompt-stated",
      "name": "aFreeDerivedNameIsTakenEvenWhileAnotherRulesDerivedNameIsADanglingLinkToIt",
      "qualityCheck": "Subtle but directly implied path-identity case.",
      "verifies": "The free rule moves to its target name; the other rule remains because its own derived name is occupied by the dangling link."
    },
    {
      "concerns": [],
      "evidence": "A derived name already naming something occupies it, even if it reaches the entry’s current file.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkToTheEntrysOwnFileOccupiesIsNotTakenOver",
      "qualityCheck": "Distinguishes occupied from shared entries.",
      "verifies": "Repair keeps the recorded file and derived symlink in place; both read original content; fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "Occupation says “already names something,” not only a regular file.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADirectoryOccupiesIsNotTakenOver",
      "qualityCheck": "Covers non-file occupants.",
      "verifies": "A directory at the derived name blocks movement; legacy content remains; fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "The index is something already named, so the derived name is occupied; the store must preserve the index.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameEqualToTheIndexIsOccupiedAndNeverMovedOver",
      "qualityCheck": "Important safety boundary.",
      "verifies": "Repair leaves mapping/index bytes/content unchanged; fail names the rule."
    },
    {
      "concerns": [],
      "evidence": "Each derived name is recorded by another entry, which the prompt defines as occupied.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesThatWouldSwapNamesAreNotMoved",
      "qualityCheck": "Good simultaneous-occupancy case.",
      "verifies": "Each entry keeps the other’s derived name and fail names both."
    },
    {
      "concerns": [],
      "evidence": "All entries whose rules derive one name are colliding; collision does not exclude the already-settled entry.",
      "fairness": "Prompt-stated",
      "name": "failNamesBothCollidingRulesEvenWhenOneAlreadyRecordsTheDerivedName",
      "qualityCheck": "Clarifies collision membership.",
      "verifies": "Fail names both colliders; repair moves neither and preserves both files/mappings."
    },
    {
      "concerns": [],
      "evidence": "“An entry that already records its derived name is never occupied.”",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs",
      "qualityCheck": "Precisely tests the exception and no-write rule.",
      "verifies": "Fail names beta but not settled alpha; repair leaves index byte-identical and preserves all files/content."
    },
    {
      "concerns": [],
      "evidence": "Fail reports conditioned entries and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesCollidingEntriesAndChangesNothing",
      "qualityCheck": "Direct collision report check.",
      "verifies": "Fail names both colliding rules and preserves index plus both legacy files."
    },
    {
      "concerns": [],
      "evidence": "The prompt says colliding entries are not moved, “though it still discards one that is broken or resolved.”",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName",
      "qualityCheck": "Direct precedence check.",
      "verifies": "Resolved and broken colliders are removed with their files; only the still-violating colliding entry/file remains."
    },
    {
      "concerns": [],
      "evidence": "Occupied prevents movement but does not prevent discarding broken/resolved entries.",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied",
      "qualityCheck": "Good precedence and collateral-safety test.",
      "verifies": "Broken/resolved occupied entries are removed; the violating occupied entry remains; all occupant files/content remain."
    },
    {
      "concerns": [],
      "evidence": "Occupation includes a name “recorded by another entry”; same-name entries are shared even if nothing exists.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt",
      "qualityCheck": "Strong interaction test.",
      "verifies": "A misplaced rule does not move onto a name recorded by shared absent entries; shared entries survive, broken entry disappears, and fail names the misplaced rule."
    },
    {
      "concerns": [],
      "evidence": "For a rule with no entry, save is rejected if its name already names something, leaving index/folder unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn",
      "qualityCheck": "Checks retry atomicity too.",
      "verifies": "Two save attempts for an unknown rule whose derived file exists both throw; index bytes, membership, file set, and unowned content remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "A new rule is rejected when its name is already recorded by another entry.",
      "fairness": "Prompt-stated",
      "name": "storingASecondUnknownRuleNeverTakesOverTheFirstRulesFile",
      "qualityCheck": "Direct new-rule collision safety.",
      "verifies": "After first save, a second unknown rule deriving the same name throws; only first entry/file/content remain."
    },
    {
      "concerns": [],
      "evidence": "Save rejects a name leading anywhere but directly into the folder and leaves state unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected",
      "qualityCheck": "Good unsafe-path matrix.",
      "verifies": "Relative escape, nested path, and absolute strategies each throw; outside/nested content remains and no entry/direct file is added."
    },
    {
      "concerns": [],
      "evidence": "For a new rule, a name that already names something is rejected.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleNeverTakesOverADanglingLink",
      "qualityCheck": "No-follow occupation check.",
      "verifies": "Save throws, leaves the dangling symlink, and adds no index entry."
    },
    {
      "concerns": [],
      "evidence": "Store rejects writes leading to the index or anywhere but directly into the folder, leaving index/folder unchanged.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected",
      "qualityCheck": "Comprehensive known-entry safety test.",
      "verifies": "Saves through outside, index, and rooted unsafe recorded names all throw; outside/in-folder content and index bytes remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "A dangling chain does not lead directly to a folder file, so the write is rejected atomically.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsADanglingLinkNeverCreatesTheFileItPointsAt",
      "qualityCheck": "Also verifies failure isolation.",
      "verifies": "Direct/chained dangling-link saves throw without creating outside target or changing index; another healthy rule remains writable."
    },
    {
      "concerns": [],
      "evidence": "Storing writes to the file the entry’s name leads to; occupied checks for existing entries prevent moves, not writes to their recorded file.",
      "fairness": "Prompt-stated",
      "name": "storingAStillViolatedRuleWritesToItsOwnFileEvenWhenItsDerivedNameIsOccupied",
      "qualityCheck": "Good distinction between maintenance naming and save target.",
      "verifies": "Known rule writes its legacy recorded file and leaves the unowned derived occupant untouched; unknown rule gets its own derived entry/file."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says storing writes through a symbolic link; repair/ignore effects are specified separately.",
      "fairness": "Prompt-stated",
      "name": "storingAStillViolatedRuleWritesThroughTheLinkItsEntryRecords",
      "qualityCheck": "Covers both integrity modes.",
      "verifies": "Under repair and ignore, save preserves the recorded symlink name, writes target content, reads it back, and repairs the broken neighbor only in repair."
    },
    {
      "concerns": [],
      "evidence": "Writes leading to the index “under any spelling or through a symbolic or hard link” are rejected.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected",
      "qualityCheck": "Exactly matches the alias list in the requirement.",
      "verifies": "Dot spelling, symlink, and hard-link aliases to the index all cause save rejection with exact index bytes preserved."
    },
    {
      "concerns": [],
      "evidence": "Save rejects a name leading to the index.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverTheIndex",
      "qualityCheck": "Canonical direct-index case.",
      "verifies": "A new rule whose strategy returns stored.rules throws and creates no entry."
    },
    {
      "concerns": [],
      "evidence": "“Under repair, saving no violations for a known rule forgets that rule.”",
      "fairness": "Prompt-stated",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "Discriminates repair from normal save behavior.",
      "verifies": "Repair-mode empty save removes entry/file; ignore-mode empty save keeps the entry and returns no violations."
    },
    {
      "concerns": [],
      "evidence": "The special forgetting behavior is explicitly scoped to repair; fail changes no integrity state of its own.",
      "fairness": "Prompt-stated",
      "name": "onlyRepairForgetsAResolvedRuleWhileFailKeepsIt",
      "qualityCheck": "Good mode-boundary test.",
      "verifies": "Repair-mode empty save removes the entry; fail-mode empty save leaves the entry."
    },
    {
      "concerns": [],
      "evidence": "Forgetting a shared file keeps the file and removes only the entry, even when the name leads outside the folder.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Directly matches the explicit outside-sharing clause.",
      "verifies": "Empty save removes only one shared outside entry; the peer entry and outside file/content remain."
    },
    {
      "concerns": [],
      "evidence": "A shared file is kept and only the entry removed.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Covers sharing by reached file rather than identical name.",
      "verifies": "Forgetting one symlink alias removes only its entry; both file names and shared content remain readable through the peer."
    },
    {
      "concerns": [],
      "evidence": "For a non-shared file, forgetting removes the entry and its file; link-target deletion semantics remove target with link.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile",
      "qualityCheck": "Good unique-link counterpart.",
      "verifies": "Forgetting the unique linked rule removes entry, link, and target; unrelated rule/file remains readable."
    },
    {
      "concerns": [],
      "evidence": "“If the file cannot be deleted, the save is rejected and the entry stays.”",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry",
      "qualityCheck": "Tests both failure and successful retry.",
      "verifies": "When deletion is denied, empty save reports rejected/still stored with old violation and preserves mapping/file; once writable, retry removes both."
    },
    {
      "concerns": [],
      "evidence": "“Under repair, saving no violations for an unknown rule stores nothing.”",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Direct requirement check.",
      "verifies": "Repair-mode empty save for an unknown rule leaves an empty index and no other files."
    },
    {
      "concerns": [],
      "evidence": "“A rule with violations keeps its entry.”",
      "fairness": "Prompt-stated",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Direct positive counterpart to forgetting.",
      "verifies": "After repair removes a broken neighbor, saving one remaining violation keeps the known entry and reads exactly that violation."
    },
    {
      "concerns": [],
      "evidence": "If the description contains a whole 4–120 ASCII-alphanumeric word, the name keeps such a word.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionShowTheRuleTheyStore",
      "qualityCheck": "Direct readability property.",
      "verifies": "Description mode creates one file whose name contains a whole eligible description word."
    },
    {
      "concerns": [],
      "evidence": "With description, the name derives deterministically from the rule description.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameInALaterRun",
      "qualityCheck": "Direct determinism check.",
      "verifies": "The same description in two stores derives exactly the same name."
    },
    {
      "concerns": [],
      "evidence": "Deterministic derivation from the description alone plus built-in character/length requirements.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameOnAnotherMachine",
      "qualityCheck": "Strong environment-independence probe.",
      "verifies": "Separate JVMs with different user/home/tmp/locale/encoding derive equal ASCII-safe bounded names that retain an eligible word."
    },
    {
      "concerns": [],
      "evidence": "The name derives deterministically from the rule description, not store contents.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds",
      "qualityCheck": "Rejects state-dependent disambiguation.",
      "verifies": "The same rule derives the same name in empty and crowded stores."
    },
    {
      "concerns": [],
      "evidence": "“Names differ per rule” and eligible words must be retained.",
      "fairness": "Prompt-stated",
      "name": "twoRulesReadingAlikeStillGetDifferentNames",
      "qualityCheck": "Strong collision-resistance sample.",
      "verifies": "Eight similar descriptions each get an eligible-word-containing unique name; exact files exist and each rule reads back its own violation."
    },
    {
      "concerns": [],
      "evidence": "Description naming and lookup count each CRLF as LF.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionWithWindowsLineBreaksYieldsTheNameOfItsUnixSpelling",
      "qualityCheck": "Covers both derivation and lookup normalization.",
      "verifies": "CRLF and LF descriptions derive the same sole file name; fail accepts and CRLF lookup reads the violation."
    },
    {
      "concerns": [],
      "evidence": "Built-in names have the stated character/length bounds and must retain an eligible word.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
      "qualityCheck": "Good sanitization/path-character case.",
      "verifies": "An awkward long description produces an ASCII-safe name of at most 200 characters retaining an eligible word."
    },
    {
      "concerns": [],
      "evidence": "Eligible words can be 4–120 characters and must be found even late in a long description.",
      "fairness": "Prompt-stated",
      "name": "aLongWordAfterOnlyShortOnesStillYieldsABoundedName",
      "qualityCheck": "Exact upper-bound/late-word test.",
      "verifies": "A late 120-character word is retained in an ASCII-safe bounded deterministic name."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly requires finding an eligible word even late; letters or digits qualify.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt",
      "qualityCheck": "Covers alphabetic and numeric words.",
      "verifies": "Late controllers and 1234 words each survive in distinct ASCII-safe bounded names."
    },
    {
      "concerns": [],
      "evidence": "Only whole words of 4–120 qualify, including ones appearing late.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordBeforeIt",
      "qualityCheck": "Good scanner-resumption edge case.",
      "verifies": "An over-120 word does not prevent a later eligible word from appearing in the bounded safe name."
    },
    {
      "concerns": [],
      "evidence": "The eligible-word guarantee is independent of other overlong words.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordAfterIt",
      "qualityCheck": "Complements the prior ordering case.",
      "verifies": "An eligible leading word remains in the bounded safe name despite a trailing 121-character word."
    },
    {
      "concerns": [],
      "evidence": "The requirement says a whole word of 4–120 characters.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesAnOverlongWordBeginningWithIt",
      "qualityCheck": "Strong whole-token boundary discriminator.",
      "verifies": "A 121-character token beginning with abcd is not falsely treated as the eligible whole word; the later standalone abcd is retained and readback works."
    },
    {
      "concerns": [],
      "evidence": "Built-in names must use only the allowed characters and description naming is deterministic; a strategy yielding no name is rejected.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionWithoutAnyPlainCharacterStillYieldsAStableName",
      "qualityCheck": "Good no-readable-token fallback case.",
      "verifies": "A punctuation-only description produces a nonempty ASCII-safe deterministic file name."
    },
    {
      "concerns": [],
      "evidence": "Built-in character/length rules, deterministic derivation, and per-rule distinctness apply to all descriptions.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionOfOnlyNonAsciiCharactersStillYieldsAStableAsciiName",
      "qualityCheck": "Covers Unicode fallback and collision resistance.",
      "verifies": "Non-ASCII-only descriptions get ASCII-safe bounded distinct names; the same description repeats deterministically."
    },
    {
      "concerns": [],
      "evidence": "Description mode names files; the current violation-file format/read behavior must remain.",
      "fairness": "Prompt-stated",
      "name": "violationsAreReadBackFromANameTakenFromTheDescription",
      "qualityCheck": "End-to-end persistence test.",
      "verifies": "A fresh reader returns the two violations in order and the description-derived name retains an eligible word."
    },
    {
      "concerns": [],
      "evidence": "A misplaced entry is moved to its rule’s derived name.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingALegacyNameIsMovedToTheNameTakenFromTheDescription",
      "qualityCheck": "Realistic migration case.",
      "verifies": "Repair changes the UUID-like legacy name to a different word-retaining description name and preserves content."
    },
    {
      "concerns": [],
      "evidence": "Built-in names are never stored.rules.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionNeverCollideWithTheIndex",
      "qualityCheck": "Direct reserved-name check.",
      "verifies": "A rule described stored.rules gets a different derived name that still retains stored/rules as an eligible word."
    },
    {
      "concerns": [],
      "evidence": "“It writes the index only when an entry changed.”",
      "fairness": "Prompt-stated",
      "name": "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
      "qualityCheck": "Byte and mtime checks discriminate actual writes from equivalent rewrites.",
      "verifies": "No-op repair preserves exact index bytes and backdated mtime; repair removing a broken entry changes both bytes and mtime."
    },
    {
      "concerns": [],
      "evidence": "Shared/unowned findings are left alone, and repair writes the index only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex",
      "qualityCheck": "Strong no-op-write case.",
      "verifies": "Shared/unowned-only repair preserves hand-written index bytes and mtime; entries remain and fail still reports unowned-file."
    },
    {
      "concerns": [],
      "evidence": "The index is written only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "arepairThatChangesNothingLeavesTheIndexByteIdentical",
      "qualityCheck": "Idempotent write-suppression test.",
      "verifies": "A second repair preserves exact post-first-repair bytes and backdated mtime."
    },
    {
      "concerns": [],
      "evidence": "Repair examines the index “while initializing”; that denotes current on-disk state rather than a stale process cache.",
      "fairness": "Prompt-stated",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "Important same-process cache invalidation test.",
      "verifies": "After an ignore initialization, externally replacing the index with a broken entry is observed by a new repair, which empties it."
    },
    {
      "concerns": [
        "brittle_message_matching"
      ],
      "evidence": "These assertions are agent-visible at archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java:40-119; production behavior is visible at TextFileBasedViolationStore.java:133-205.",
      "fairness": "Repo-discoverable",
      "name": "Baseline TextFileBasedViolationStoreTest (all 8 tests)",
      "qualityCheck": "Fair regression gate. The exact exception-message assertion at test line 49 is somewhat brittle.",
      "verifies": "The unchanged visible tests still require unknown-rule behavior, exact unstored-rule exception, configured storage/update/read behavior, empty and multiple rule handling, and multiline violation round trips."
    },
    {
      "concerns": [],
      "evidence": "The complete setups and assertions are visible at archunit/src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreConcurrencyTest.java:42-75.",
      "fairness": "Repo-discoverable",
      "name": "Baseline TextFileBasedViolationStoreConcurrencyTest (both tests)",
      "qualityCheck": "Fair regression gate; repeated/threaded execution is load-sensitive.",
      "verifies": "The unchanged visible tests require eight concurrent initializations to succeed and twenty concurrent saves to leave 20 readable rule/violation mappings."
    },
    {
      "concerns": [],
      "evidence": "All setups and assertions are visible at archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java:66-516.",
      "fairness": "Repo-discoverable",
      "name": "Baseline FreezingArchRuleTest (all visible tests)",
      "qualityCheck": "Fair compatibility gate because the agent could read every assertion. A few pre-existing tests pin exact diagnostic prose.",
      "verifies": "The unchanged visible suite preserves FreezingArchRule descriptions/toString, freeze/refreeze matching, multiline handling, configurable stores/matchers, creation/update permission behavior, delegated file naming, and ignore-pattern filtering."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Problem description have appropriate length (target: 100-200 words)**

Status: WARNING

Description is verbose (832 words, over target by 332). Consider trimming to ≤500 words.

```json
{
  "errorThreshold": 1000,
  "target": 500,
  "warningThreshold": 500,
  "wordCount": 832
}
```

---

**Shipd Bot Description Warnings**

> "`default.fileNames` names new files and defaults to `random`."

Keep the tested option names and values, but split this dense filename-policy paragraph into shorter sentences. For example: “`default.fileNames` controls names for new files and defaults to `random`. With `description`, derive the name deterministically from the rule description. Description-based names must be unique per rule, ASCII-safe, at most 200 characters, distinct from `stored.rules`, and retain a whole 4–120-character alphanumeric word.” Then state the custom-strategy rules separately. This preserves the requirements while making each rule immediately scannable. _(marked resolved, but the sentence is still in the description)_

> "when the description contains a whole word of 4 to 120 ASCII letters or digits, keep such a word, even one that comes late in a long description."

Qualify with 'when such a word exists' so non-ASCII/punctuation-only descriptions remain valid. _(marked resolved, but the sentence is still in the description)_

> "A strategy given to the constructor names files the same way, and configuring"

This is a comma splice at the end of an already dense naming paragraph. Split it into direct sentences: “A strategy supplied to the constructor controls file naming. Reject `default.fileNames` when the store was constructed with a strategy.” Keep the preceding strategy-validation requirements unchanged. _(marked resolved, but the sentence is still in the description)_

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

> "deleting a link's target with the link"

Make the deletion target explicit: “For a resolved entry whose recorded path is a link, delete both the link and its target.” This is easier to parse while preserving the required behavior. _(marked resolved, but the sentence is still in the description)_

> "Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress."

Split the two concurrency guarantees: “Concurrent initialization and saves in one process must leave a readable index and only the index plus surviving files. Initialization must not examine a save that is still in progress.” This removes the overloaded coordination without changing the requirement. _(marked resolved, but the sentence is still in the description)_

> "Storing a rule writes its violations to the file its entry's name leads to,"

Break this long save rule into a lead sentence and a separate rejection sentence. For example: “Save an existing rule’s violations to the file named by its entry, including through a symbolic link. Reject the save without changing the index or folder when the name leads to the index, outside the folder, or—when the rule is new—to an existing or already-recorded name.” Retain the existing detailed conditions verbatim after the split.

Reply (Anwar Ramadan): Storing a rule writes its violations to the file its entry's name leads to, even through a symbolic link. The store rejects that write, leaving the index and the folder as they were, if the name leads to the index (under any spelling or through a symbolic or hard link), leads anywhere but directly into the folder, or, for a rule that has no entry yet, already names something or is recorded by another entry. _(marked resolved, but the sentence is still in the description)_

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 5 total suggestions (even if most are low/medium). Per the rules, 3+ suggestions require a request_changes verdict.",
  "suggestions": [
    {
      "priority": "medium",
      "quote": "The store leaves shared entries and unowned files alone and never moves a colliding or occupied entry, though it still discards one that is broken or resolved.",
      "suggestion": "Remove this policy summary sentence. The precise behaviors for each condition are already fully specified under the 'repair' and 'fail' sections, so this line is redundant and risks becoming a second, conflicting source of truth."
    },
    {
      "priority": "low",
      "quote": "Storing a rule writes its violations to the file its entry's name leads to, even through a symbolic link.",
      "suggestion": "Remove – this is default filesystem behavior implied by writing to the recorded path. Keep only the explicit prohibitions (index, outside folder, occupied names) to avoid noise."
    },
    {
      "priority": "low",
      "quote": "The folder itself may be reached through a link.",
      "suggestion": "Remove – this is an environment/default behavior and does not require special handling beyond using the given path. It adds verbosity without constraining implementation."
    },
    {
      "priority": "medium",
      "quote": "Violation files keep their current format, in which a carriage return inside a stored violation stays part of that violation's text.",
      "suggestion": "Remove only the vague \"keep their current format,\" phrase (keep the explicit carriage-return requirement). The \"preserve current format\" directive is a generic \"don’t change behavior\" statement that adds no actionable constraint."
    },
    {
      "priority": "low",
      "quote": "fail does not need `default.allowStoreUpdate`.",
      "suggestion": "Remove – it’s implied by \"fail changes nothing\". Keeping just the behavior for \"fail\" reduces redundancy; permission checks are only relevant for write operations already covered under \"repair\"."
    }
  ],
  "summary": "- [MEDIUM] Remove redundant policy summary: \"The store leaves shared entries and unowned files alone and never moves a colliding or occupied entry, though it still discards one that is broken or resolved.\" The exact behaviors are already defined under the repair/fail sections; keeping this duplicate increases risk of conflicting guidance.\n- [LOW] Remove: \"Storing a rule writes its violations to the file its entry's name leads to, even through a symbolic link.\" This is default filesystem behavior implied by writing to the recorded path; keep only the explicit disallow rules (index, outside folder, occupied).\n- [LOW] Remove: \"The folder itself may be reached through a link.\" Accessing the folder via a symlink requires no special handling; this is environmental default and not an actionable requirement.\n- [MEDIUM] Trim \"Violation files keep their current format, in which a carriage return inside a stored violation stays part of that violation's text.\" by removing the vague \"keep their current format\" clause. Keep only the concrete requirement that carriage returns within a violation remain part of its text.\n- [LOW] Remove: \"fail does not need default.allowStoreUpdate.\" It is implied by \"fail changes nothing\"; permission checks for writes are already scoped to repair.",
  "verdict": "request_changes"
}
```
