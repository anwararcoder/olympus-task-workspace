**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥20 messages, ≥200 LOC

This task numbers: Median files: 3, messages: 170, LOC: 930

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "0898d4291dd84167b71f5b7b5deecb30c7d998743fb76257e63f606db4dc8adb",
  "overall": "distinct",
  "perCandidate": [
    {
      "confidence": 0.93,
      "contentAuthoredAt": 1786258071836,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: a Java ArchUnit freeze store vs. Python SQLFluff linter fixer.",
        "Submission modifies filesystem-backed store behavior (index reconciliation, filename derivation, ownership checks, symlink/hardlink handling), while the candidate modifies the fix loop algorithm (cycle detection, per-rule attribution, replay without held-back rules).",
        "Submission introduces configuration keys (default.fileNames, default.integrity) with IGNORE/REPAIR/FAIL semantics; candidate doesn’t expose comparable config and instead changes convergence handling and reporting surfaces (FixConvergenceTracker/Report, LintedFile/Dir/Result).",
        "Submission treats newline-only files as holding no violations and can delete/move files; candidate never touches filesystem layout for rule storage but reconstructs parse trees and violation lists via replay.",
        "Submission’s lifecycle focus is store initialization and per-save behavior; candidate’s focus is during lint/fix passes, including pass-limit boundary probing and deterministic attribution across phases."
      ],
      "one_liner": "One adds integrity checking/repair and deterministic file naming to a Java text-based rule violation store, while the other attributes non‑converging autofixes per rule in SQLFluff and replays to preserve stable fixes.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The two patches target unrelated surfaces in different projects. The ArchUnit change adds a filename strategy and a store integrity classifier/repairer operating on the violation store’s index and files; the SQLFluff change refactors the fixer’s convergence logic to attribute problematic rules and replay to keep independent fixes. Any similarity is conceptual robustness, not the same behavioral change on a purpose-matched surface.",
      "similarity": 0.6015535593032837,
      "submission_summary": "Implements deterministic, description-based filename strategy; adds a StoreIntegrity subsystem with IGNORE/REPAIR/FAIL modes to reconcile the TextFileBasedViolationStore index with the folder, enforce ownership checks, discard/move files as needed, and treat newline-only files as resolved. Wires this into initialization and save paths and documents new properties.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.97,
      "contentAuthoredAt": 1786876774252,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission modifies ArchUnit’s TextFileBasedViolationStore to add deterministic filename strategies and integrity modes (ignore/repair/fail) with filesystem checks, moves, and deletions; candidate implements a new transactional, versioned ruleset store with optimistic concurrency, commits, rebasing, and serialization in the google/nftables repo.",
        "Submission’s behavior centers on reconciling an on-disk index with files (broken/resolved/misplaced/shared/colliding/occupied/unowned) and enforcing safe writes; candidate focuses on staging operations on tables/chains/rules/sets/objects, conflict detection over read/write paths, and commit ordering.",
        "Submission is Java code in com.tngtech.archunit.library.freeze with userguide updates; candidate is Go code adding multiple files that define RulesetStore/RulesetTx and OCC machinery for nftables."
      ],
      "one_liner": "They both deal with rule-related storage, but one adds filesystem integrity and naming to ArchUnit’s freeze-store while the other implements an in-memory, optimistic-concurrency ruleset store for nftables.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The patches target different repositories, languages, and problem domains. The submission implements filesystem integrity maintenance and deterministic naming for ArchUnit’s text-based violation store; the candidate implements an in-memory, optimistic-concurrency transactional store for nftables rulesets with commit/rebase/serialize logic. There is no purpose-matched surface or overlapping behavior beyond generic ‘store’ terminology.",
      "similarity": 0.5968160033226013,
      "submission_summary": "Adds deterministic filename strategies and an integrity checker/repairer to ArchUnit’s TextFileBasedViolationStore, including new configuration keys, filesystem safety checks, and on-load reconciliation that can repair or fail on inconsistencies. Updates storage semantics when saving rules and adjusts file/index handling and documentation accordingly.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.95,
      "contentAuthoredAt": 1784870646197,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and storage layers: one targets ArchUnit’s TextFileBasedViolationStore (Java) folder/index reconciliation; the other targets Qdrant’s Gridstore (Rust) per-record on-disk format and validation.",
        "Submission adds deterministic file naming strategies from rule descriptions, enforces ownership rules for files, and provides integrity modes (ignore/repair/fail) that can delete or move files and rewrite the index; the candidate adds a versioned, checksummed record envelope, validates on read, audits without mutating, and provides a copy-based migration to a new format.",
        "Submission’s integrity focuses on index/file consistency (broken, resolved, misplaced, shared, colliding, occupied, unowned) and symlink/FS semantics; the candidate focuses on payload correctness (magic/version/flags/checksum/length, decompression) and reports corruption types without altering source data except via explicit migration.",
        "Submission updates documentation and configuration keys default.fileNames and default.integrity; the candidate adds config RecordFormat and propagates it through read/write paths, plus new error types and integrity reports."
      ],
      "one_liner": "Both introduce integrity-related handling for a storage system, but one reconciles a Java text-file rule store’s index and filenames while the other adds a Rust gridstore record checksum format with audit and migration tooling.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "There is no purpose-matched surface overlap: the Java changes center on reconciling an index file with rule-violation files in a folder and naming those files, while the Rust changes add a versioned, checksummed record layer with integrity auditing and migration. Shared terms like “integrity” are generic; the observable behaviors and modified APIs/files are unrelated, so these teach different debugging lessons.",
      "similarity": 0.5784631967544556,
      "submission_summary": "Adds RuleViolationFileNameStrategy variants (including a description-derived naming), a StoreIntegrity classifier/repairer, and wiring in TextFileBasedViolationStore to enforce ownership, parse default.fileNames and default.integrity, repair or fail initialization, and handle deletions/moves and line-break–only files. Updates docs to describe the new settings and behaviors.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.93,
      "contentAuthoredAt": 1777645927219,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: Java ArchUnit freeze TextFileBasedViolationStore vs Go Hashicorp Raft InmemStore.",
        "Submission introduces configurable file-naming strategies (random/description/custom), derives deterministic names from rule descriptions (ASCII-only, length limits, SHA-256 fingerprint), and actively repairs on-disk state (delete/move files, update index) under a repair mode; candidate provides read-only verification/audit methods and typed integrity errors without mutating store state.",
        "Submission implements store initialization lifecycle checks with modes ignore/repair/fail, including rejecting creation/invalid index file and reconciling index vs folder, handling symlinks/hard-links and path containment; candidate adds VerifyIntegrity, VerifyRange, ValidateTruncation, and AuditIntegrity focused on reachability and boundary consistency in an in-memory log range.",
        "Submission modifies how violations are read/split (treating files with only line breaks as empty) and adds ownership checks preventing writes outside the folder or over unowned files; candidate does not touch I/O semantics or file system concerns.",
        "Submission extends internal FileSyncedProperties to reload/apply changes and coordinate concurrent initialization; candidate adds new interfaces/types (LogIntegrityViolation, IntegrityReport) and utility AuditLogStore but does not alter persistence behavior."
      ],
      "one_liner": "One adds deterministic file naming and on-disk index/folder integrity maintenance to a Java freeze-store, while the other adds diagnostic integrity/audit APIs to a Go in-memory Raft log store.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "The two patches target different repositories and surfaces for distinct purposes. The submission alters ArchUnit’s TextFileBasedViolationStore to add deterministic file naming and active integrity maintenance over an on-disk index and files, including repair/fail modes and file movement/deletion. The candidate adds diagnostic integrity-checking and auditing APIs to Hashicorp Raft’s in-memory log store, returning structured errors and reports without modifying storage. Any overlap is thematic (integrity) rather than a shared behavioral change on a purpose-matched surface.",
      "similarity": 0.5596698522567749,
      "submission_summary": "Adds deterministic rule-description-based file naming (or custom strategies) and integrity modes (ignore/repair/fail) to TextFileBasedViolationStore, reconciling its stored.rules index with the folder by classifying entries and optionally deleting/moving files and updating the index. It also tightens ownership/path checks, adjusts violation parsing, and extends FileSyncedProperties to reload/apply changes during initialization.",
      "verdict": "distinct"
    },
    {
      "confidence": 0.9,
      "contentAuthoredAt": 1789420959657,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": false,
      "meaningful_differences": [
        "Submission modifies TextFileBasedViolationStore to add configurable file-naming strategies, validates/owns files, and introduces integrity modes (ignore/repair/fail) that reconcile the index with the folder; candidate leaves storage mechanics alone and instead changes how violations are matched and reported.",
        "Submission introduces RuleViolationFileNameStrategyFactory and a deterministic description-based naming scheme, plus link/regular file checks and movement/deletion logic; candidate adds ClassDependenciesViolation logic to parse headings/dependency lines, compare stored vs. actual per dependency, and store complete dependency sets for cycles.",
        "Submission’s behavior runs at store initialization and save-time (reject/repair/move/delete, forbid writing outside folder or onto non-owned files); candidate’s behavior runs at evaluation time (categorizing violations, filtering known ones, emitting restricted events for newly added dependencies).",
        "Submission updates docs to describe new properties default.fileNames and default.integrity; candidate updates docs to describe per-class-dependency comparison and storing complete cycle dependencies."
      ],
      "one_liner": "One adds file-naming strategies and integrity checking/repair for the text-file-based freeze store; the other changes how bundled dependency violations are matched and stored by comparing per class dependency.",
      "overlap": {
        "shared_apis": [],
        "shared_test_behaviors": []
      },
      "reason": "Although both live in the same repo and freezing package, they change different surfaces for different purposes. The submission focuses on the file-backed store’s naming and integrity lifecycle (new factory, integrity checker, and TextFileBasedViolationStore guards), while the candidate refactors violation comparison/reporting by parsing and matching bundled class dependencies and updating FreezingArchRule behavior. No purpose-matched APIs or behaviors overlap beyond generic freezing context.",
      "similarity": 0.539929768118136,
      "submission_summary": "Adds integrity management and deterministic file naming for the text-based freeze store: new strategy factory, description-based names, and a StoreIntegrity component that can ignore/repair/fail by validating, moving, or deleting files and updating the index. Extends TextFileBasedViolationStore with new properties, ownership checks, safe writes, and special handling when storing zero violations under repair.",
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
  "executionTimeSeconds": 236.637839,
  "message": "All hidden tests are fair.",
  "overall": "PASS: all hidden expectations are either explicitly stated in the unusually detailed prompt or, for exact legacy save/read/newline and FreezingArchRule integration details, directly produced by the pre-existing repository. No hidden test requires an author-only value or shape. The main quality caveat is environmental: the symlink/hard-link group assumes the test filesystem and process account permit creation of those links, and the separate-JVM portability test assumes a runnable java binary/classpath layout. Those assumptions affect a group and are recorded here once rather than repeated per test. The three concurrency tests also use fixed waits; the most orchestrated one couples to when the naming strategy is called. Message assertions generally check only names/order expressly required by the prompt rather than exact prose.",
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
        "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
        "namesTakenFromTheDescriptionNeverCollideWithTheIndex",
        "aDescriptionOfOnlyNonAsciiCharactersStillYieldsAStableAsciiName"
      ],
      "requirement": "Description names are deterministic, distinct per rule, retain a qualifying word even late, use the restricted ASCII alphabet, are <=200 chars, and avoid stored.rules.",
      "sourceQuote": "With `description`, the name derives deterministically from the rule description. Names differ per rule, and each keeps a word of 4+ letters or digits, even one that comes late in a long description. Built-in names use only ASCII letters, digits, underscores and hyphens. They never exceed 200 characters and are never `stored.rules`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aConfiguredStrategyNamesNewlyStoredRules",
        "aStrategyThatCannotBeInstantiatedIsRejected",
        "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected"
      ],
      "requirement": "A non-built-in fileNames value loads a strategy implementation with a public no-arg constructor.",
      "sourceQuote": "Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
        "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore",
        "aStrategyGivenToTheConstructorYieldingNoNameIsRejectedWhileExaminingAConsistentStore"
      ],
      "requirement": "Null/empty strategy names are rejected when first needed.",
      "sourceQuote": "A strategy that yields no name is rejected as soon as a name is needed."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
        "aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing"
      ],
      "requirement": "Constructor strategy behavior matches configured strategies, and constructor plus setting is rejected.",
      "sourceQuote": "A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store is rejected."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
        "valuesNearAnAcceptedValueAreRejected",
        "unknownValueIsRejectedAndNamesTheAcceptedValues",
        "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder"
      ],
      "requirement": "Integrity accepts exactly repair/fail/ignore, defaults to ignore, and invalid values name all accepted values.",
      "sourceQuote": "`default.integrity` accepts the exact values `repair`, `fail` and `ignore`, and defaults to `ignore`, which examines nothing. `repair` and `fail` examine the index and the folder while initializing. Any other value is rejected, naming the three accepted."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "anEntryRecordingADirectoryIsBroken",
        "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
        "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
        "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
        "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives"
      ],
      "requirement": "Broken entries include missing, directory, outside, and non-direct/non-regular resolved paths.",
      "sourceQuote": "An entry is broken when its resolved path is missing, a directory, outside the folder, or not a regular file directly in it."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
        "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
        "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
        "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs"
      ],
      "requirement": "No-violation and line-break-only files are resolved for LF, CRLF, and CR.",
      "sourceQuote": "An entry is resolved when the file at that path yields no violations, including a file holding only line breaks, whether `\\n`, `\\r\\n` or a lone `\\r`."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
        "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
        "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
        "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
        "aDerivedNameAnUnownedFileOccupiesIsNotTakenOver",
        "aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt",
        "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded"
      ],
      "requirement": "Misplaced, shared, colliding, occupied, and unowned conditions follow the stated path/name definitions.",
      "sourceQuote": "An entry is misplaced when its name is not its rule's derived one. Two entries recording the same name are shared, even if nothing exists under that name. So are two entries whose recorded names resolve to one file, as when one links to that file. One derived name two rules share is colliding. An entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder. Apart from the index, a regular file directly in the folder that no entry records is unowned."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
        "anEntryBothSharedAndBrokenIsNamedOnlyAmongTheSharedOnes",
        "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName",
        "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied"
      ],
      "requirement": "Shared/unowned are left alone; collision/occupation block moves; broken/resolved discard overrides collision/occupation; shared has highest precedence.",
      "sourceQuote": "The store leaves shared entries and unowned files alone. It never moves a colliding or occupied entry, but still discards one that is broken or resolved. An entry both shared and something else stays shared."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anEntryWhoseFileIsAbsentIsBroken",
        "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
        "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt",
        "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
        "aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex"
      ],
      "requirement": "Repair discards broken and resolved entries/files, handles link target deletion/movement, relocates misplaced files, and rewrites the index only for entry changes.",
      "sourceQuote": "`repair` discards broken entries. It discards resolved entries with the files they name, deleting a link's target with the link. It moves a misplaced entry's file to its derived name, moving a link's target rather than the link. It writes the index only when an entry changed."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "failAcceptsAConsistentStoreAndRejectsAnInconsistentOne",
        "failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne",
        "failNamesTheConditionsInTheStatedOrder",
        "failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName",
        "failOrdersMisplacedEntriesByRuleDescription",
        "failOrdersCollidingEntriesByRuleDescription",
        "failWithSeveralConditionsAtOnceChangesNotOneByte"
      ],
      "requirement": "Fail changes nothing, rejects inconsistencies, does not create an absent index on rejection, and reports all conditioned entries/files in required order and sorting.",
      "sourceQuote": "`fail` changes nothing, rejecting initialization unless the index and folder agree, and a rejection does not even create an absent index. Its report names every entry in any condition, misplaced and colliding entries included, and every unowned file. It reports the conditions broken, resolved, shared, then unowned, in that order. Within a condition it orders entries by rule description and files by name."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "repairWithoutPermissionToUpdateIsRejectedAndChangesNothing",
        "repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore",
        "failWithoutPermissionToUpdateStillReportsTheInconsistency"
      ],
      "requirement": "Repair requires update permission; fail reports regardless of it.",
      "sourceQuote": "`repair` needs `default.allowStoreUpdate` and is rejected without it. `fail` reports either way."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined",
        "anIndexThatIsALinkOutOfTheStoreFolderIsRejectedAndItsTargetSurvives",
        "anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired"
      ],
      "requirement": "An absent disallowed index or a non-direct/non-regular index is rejected before integrity examination.",
      "sourceQuote": "An absent index without `default.allowStoreCreation`, or one not a regular file directly in the folder, is rejected before anything is examined."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn",
        "storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected",
        "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected",
        "storingARuleWhoseEntryRecordsAHardLinkToTheIndexIsRejected",
        "storingARuleNeverWritesOverTheIndex",
        "storingARuleWhoseEntryRecordsADanglingLinkNeverCreatesTheFileItPointsAt"
      ],
      "requirement": "Saving never overwrites the index, outside content, or a file not recorded by that rule, and unsafe saves reject.",
      "sourceQuote": "Storing a rule never writes over the index, anything outside the folder, or a file its own entry does not record. Such a save is rejected."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
        "forgettingARuleKeepsTheFileAnotherEntryReachesThroughAHardLink",
        "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
        "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
        "aStillViolatedRuleKeepsItsEntryUnderRepair"
      ],
      "requirement": "Under repair, empty saves forget known rules safely, do nothing for unknown rules, and nonempty saves retain entries.",
      "sourceQuote": "Under `repair`, storing no violations forgets a known rule, discarding its entry and its file unless another entry shares that file, and stores nothing for an unknown rule. A still violated rule keeps its entry."
    },
    {
      "covered": "yes",
      "coveringTests": [
        "concurrentInitializationsLeaveAReadableIndex",
        "concurrentRepairsOfAMisplacedEntryLeaveItOnItsMovedFile",
        "concurrentRepairAndFailLeaveAReadableIndex"
      ],
      "requirement": "Concurrent in-process initializations preserve a readable coherent index and survivor-only folder.",
      "sourceQuote": "Stores initializing concurrently in one process leave a readable index and a folder holding only the index and survivors' files."
    }
  ],
  "taskSummary": "Extend TextFileBasedViolationStore with configurable file-name strategies and initialization-time integrity modes. The default naming mode is random; description-based names must be deterministic, distinct, recognizable, portable ASCII, bounded to 200 characters, and never equal stored.rules. Custom strategies may be configured by public no-arg class name or supplied to the constructor. Integrity defaults to ignore; repair mutates only the conditions the prompt authorizes, while fail reports all conditions without mutation. Classification must account for missing/unsafe/non-regular paths, empty violation files, aliases and shared files, derived-name misplacement/collision/occupation, and unowned direct regular files. Saving must never overwrite unsafe or foreign files, repair-mode empty saves forget resolved rules, and concurrent initializations must preserve a readable coherent store.",
  "tests": [
    {
      "concerns": [],
      "evidence": "The prompt says default.integrity \"defaults to ignore, which examines nothing\" and \"repair discards broken entries.\"",
      "fairness": "Prompt-stated",
      "name": "absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Directly distinguishes the default from repair.",
      "verifies": "With default.integrity absent, a missing-file entry remains; a later repair removes that same entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly defines ignore as examining nothing and repair as discarding broken entries.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry",
      "qualityCheck": "Direct, though substantially redundant with the absent-setting test.",
      "verifies": "Explicit ignore preserves a missing-file entry, while repair removes it."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly states ignore examines nothing; repair discards broken/resolved entries, leaves shared/unowned files alone, does not move occupied entries, and moves misplaced files.",
      "fairness": "Prompt-stated",
      "name": "ignoreExaminesNothingSoRepairStillFindsEveryCondition",
      "qualityCheck": "Strong multi-condition integration test; all co-assertions match stated precedence.",
      "verifies": "Ignore leaves every file and byte unchanged; later repair removes broken/resolved entries, preserves shared and occupied entries and unowned files, moves the movable misplaced entry, and preserves occupant and violation contents."
    },
    {
      "concerns": [],
      "evidence": "The prompt says any other value is rejected, \"naming the three accepted\" values ignore, repair and fail.",
      "fairness": "Prompt-stated",
      "name": "unknownValueIsRejectedAndNamesTheAcceptedValues",
      "qualityCheck": "Checks required message content without pinning a complete sentence.",
      "verifies": "default.integrity=prune throws a RuntimeException whose message contains ignore, repair, and fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt says default.integrity accepts the exact values repair, fail and ignore.",
      "fairness": "Prompt-stated",
      "name": "valuesNearAnAcceptedValueAreRejected",
      "qualityCheck": "Good discrimination against trimming, case-folding, and prefix matching.",
      "verifies": "Repair, repair-space, repairs, IGNORE, and failed each throw RuntimeException."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail changes nothing and rejects initialization unless index and folder agree; its report names every conditioned entry.",
      "fairness": "Prompt-stated",
      "name": "failAcceptsAConsistentStoreAndRejectsAnInconsistentOne",
      "qualityCheck": "Covers both success and non-mutating failure.",
      "verifies": "Fail initializes a consistent store, rejects a store with a missing-file entry while naming its rule, and leaves that entry in the index."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards broken entries and writes only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne",
      "qualityCheck": "Direct mode behavior check.",
      "verifies": "Repair preserves the sole consistent entry/file and removes a missing-file entry from an inconsistent index."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly defines an entry as broken when its resolved path is missing and says repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileIsAbsentIsBroken",
      "qualityCheck": "Canonical broken-entry case.",
      "verifies": "Repair removes only the absent-file entry and leaves the present entry and its file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards broken entries, without a one-entry limitation.",
      "fairness": "Prompt-stated",
      "name": "everyBrokenEntryIsDiscarded",
      "qualityCheck": "Useful multiplicity check.",
      "verifies": "Repair removes all three missing-file entries while preserving the present entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines a directory-valued entry as broken, says repair discards broken entries, and limits file deletion to resolved entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingADirectoryIsBroken",
      "qualityCheck": "Correctly checks the directory is not deleted.",
      "verifies": "Repair removes an entry naming a directory and leaves the directory itself present."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines outside-folder entries as broken and states storing/maintenance never touches outside content.",
      "fairness": "Prompt-stated",
      "name": "anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched",
      "qualityCheck": "Direct path-traversal safety test.",
      "verifies": "Repair removes an entry recorded as ../outside.txt and preserves the outside file and its exact content."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines paths outside the folder as broken and requires outside files not be touched.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives",
      "qualityCheck": "Complements the relative traversal case.",
      "verifies": "Repair removes an absolute-path entry outside the store and preserves that outside file and content."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires an owned entry to resolve to a regular file directly in the folder; otherwise it is broken.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingANestedNameIsBrokenAndThatFileSurvives",
      "qualityCheck": "Directly checks the 'directly in it' qualifier.",
      "verifies": "Repair removes an entry naming nested/violations and leaves the nested file present."
    },
    {
      "concerns": [],
      "evidence": "The prompt classifies by resolved path and allows a regular file directly in the folder. Existing read behavior is visible at archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java:190-204.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken",
      "qualityCheck": "Good lexical-versus-resolved-path edge case.",
      "verifies": "An entry recorded as ./violations survives repair, retains content, and is readable as the single violation without its line terminator."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry is broken when its resolved path is outside the folder and repair discards broken entries.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives",
      "qualityCheck": "Covers real-path safety and post-repair settledness.",
      "verifies": "Repair drops an entry naming an in-folder symlink to an outside target, preserves target content, and leaves a store accepted by fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt classifies entries by resolved path and explicitly discusses entries whose recorded names resolve to one file via links.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingALinkToAFileInTheStoreOwnsThatFile",
      "qualityCheck": "Direct positive symlink case.",
      "verifies": "An entry naming a symlink to an in-folder regular file survives repair with target content intact, and fail then accepts the store."
    },
    {
      "concerns": [],
      "evidence": "The prompt only classifies unrecorded regular files directly in the folder as unowned and says repair leaves unowned/other non-entry objects alone.",
      "fairness": "Prompt-stated",
      "name": "aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget",
      "qualityCheck": "Checks that folder scanning does not indiscriminately delete links.",
      "verifies": "Repair removes an unrelated broken entry but leaves an unrecorded symlink and its outside target intact; fail then accepts."
    },
    {
      "concerns": [],
      "evidence": "A dangling link's resolved path is missing, which the prompt explicitly defines as broken.",
      "fairness": "Prompt-stated",
      "name": "anEntryNamingADanglingLinkIsBroken",
      "qualityCheck": "Direct missing-resolved-target case.",
      "verifies": "Repair removes an entry naming a dangling symlink."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines no-violation files as resolved and says repair discards resolved entries with their files.",
      "fairness": "Prompt-stated",
      "name": "anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile",
      "qualityCheck": "Canonical resolved-entry case.",
      "verifies": "Repair removes an empty-file entry and deletes that file, leaving only stored.rules."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says repair deletes a resolved link's target with the link.",
      "fairness": "Prompt-stated",
      "name": "aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt",
      "qualityCheck": "Precisely checks both target and link removal.",
      "verifies": "Repair removes the resolved entry, target file, and symlink, leaves only the index, and produces a store accepted by fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly includes files holding only line breaks in the resolved definition.",
      "fairness": "Prompt-stated",
      "name": "aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry",
      "qualityCheck": "Direct Unix-line-break case.",
      "verifies": "A file containing only Unix line breaks is removed with its entry, while a nonempty violation file and entry remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly names \\n, \\r\\n, and lone \\r as resolved-only line-break forms.",
      "fairness": "Prompt-stated",
      "name": "aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks",
      "qualityCheck": "Thoroughly exercises all stated newline encodings.",
      "verifies": "Files containing only CRLF, lone CR, or LF line breaks are all removed, while a CRLF-terminated violation remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines resolved as yielding no violations.",
      "fairness": "Prompt-stated",
      "name": "anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs",
      "qualityCheck": "Useful boundary check between zero and one violations.",
      "verifies": "Repair retains the one-violation entry/file and removes the empty entry/file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says two entries recording the same name are shared and shared entries are left alone, even when otherwise resolved.",
      "fairness": "Prompt-stated",
      "name": "aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded",
      "qualityCheck": "Checks shared precedence over resolved.",
      "verifies": "Two entries recording the same empty file survive repair, as does the file, while an unrelated broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says entries whose recorded names resolve to one file, as via a link, are shared and stay shared.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded",
      "qualityCheck": "Good alias-based sharing test.",
      "verifies": "Entries naming a target and a symlink to it both survive repair with both names, despite empty content; an unrelated broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines sharing by two recorded names resolving to one file; Java/NIO hard links are standard aliases of the same file.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesReachingOneFileThroughAHardLinkShareItAndNeitherIsDiscarded",
      "qualityCheck": "Extends stated resolved-identity semantics to hard links.",
      "verifies": "Entries naming two hard links to one empty file both survive, both directory entries remain, and an unrelated broken entry is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail reports every shared entry and changes nothing; hard-link identity supplies the shared setup.",
      "fairness": "Prompt-stated",
      "name": "failNamesTwoEntriesReachingOneFileThroughAHardLinkAndChangesNothing",
      "qualityCheck": "Checks reporting and non-mutation.",
      "verifies": "Fail reports both hard-link-sharing rule descriptions and leaves index and both names unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry both shared and something else stays shared.",
      "fairness": "Prompt-stated",
      "name": "aSharedNameHoldingNoViolationsIsNotDiscardedEither",
      "qualityCheck": "Direct condition-precedence test.",
      "verifies": "Two entries sharing one empty file survive repair while a separately resolved entry/file is removed."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires fail to name every entry in any condition and make no changes.",
      "fairness": "Prompt-stated",
      "name": "failNamesSharedEntriesAndChangesNothing",
      "qualityCheck": "Direct shared-reporting test.",
      "verifies": "Fail reports both descriptions sharing one name and leaves both entries and the shared file unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry both shared and something else stays shared and reports broken before shared.",
      "fairness": "Prompt-stated",
      "name": "anEntryBothSharedAndBrokenIsNamedOnlyAmongTheSharedOnes",
      "qualityCheck": "Strong precedence-and-order discriminator.",
      "verifies": "Fail's message contains the lone broken entry before both descriptions sharing a missing name, with the shared descriptions following the broken section."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines such a file as unowned and says the store leaves unowned files alone.",
      "fairness": "Prompt-stated",
      "name": "anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded",
      "qualityCheck": "Canonical unowned-file repair case.",
      "verifies": "Repair removes a broken entry but preserves an unrecorded direct regular file and its exact content."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires fail to report every unowned file and change nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesUnownedFilesAndChangesNothing",
      "qualityCheck": "Direct unowned reporting test.",
      "verifies": "Fail reports the unowned file name and leaves the index, owned file, and stray file present."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines only an unrecorded regular file directly in the folder as unowned.",
      "fairness": "Prompt-stated",
      "name": "aDirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Good type-discrimination comparison.",
      "verifies": "Fail accepts a store containing an extra directory, but rejects an otherwise similar store containing an extra regular file and names that file."
    },
    {
      "concerns": [],
      "evidence": "The prompt limits unowned files to regular files directly in the folder.",
      "fairness": "Prompt-stated",
      "name": "aFileInsideADirectoryInTheStoreFolderIsNeverACondition",
      "qualityCheck": "Checks both reporting exclusion and non-recursive mutation.",
      "verifies": "Fail reports the broken entry but not the nested file; repair removes the broken entry and leaves the nested file/content untouched."
    },
    {
      "concerns": [],
      "evidence": "The prompt says \"Apart from the index\" when defining unowned files.",
      "fairness": "Prompt-stated",
      "name": "theIndexItselfIsNeverUnowned",
      "qualityCheck": "Fair but somewhat indirect about absence of an index-as-unowned report.",
      "verifies": "Fail accepts a consistent folder containing index plus owned file, and a separate broken store is rejected for the broken rule rather than merely for having an index."
    },
    {
      "concerns": [],
      "evidence": "The stated classification and repair rules imply a repaired consistent folder has no further changes.",
      "fairness": "Prompt-stated",
      "name": "aSecondInitializationOfARepairedFolderDiscardsNothing",
      "qualityCheck": "Useful idempotence/settledness check.",
      "verifies": "A second repair retains the first repair's sole surviving entry and produces the same file-name list."
    },
    {
      "concerns": [],
      "evidence": "The prompt says shared entries are left alone and an entry both shared and another condition stays shared.",
      "fairness": "Prompt-stated",
      "name": "anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled",
      "qualityCheck": "Checks sharing precedence prevents relocation and oscillation.",
      "verifies": "After two repairs, two shared aliasing entries remain byte/logically unchanged, the broken entry stays removed, and the violation content remains."
    },
    {
      "concerns": [],
      "evidence": "Repair's stated actions restore agreement; fail rejects only when index and folder disagree.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderPassesAFailingCheck",
      "qualityCheck": "Good cross-mode settledness check.",
      "verifies": "After repair removes broken and resolved entries, fail accepts and only the kept entry remains."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair writes the index when an entry changes; ViolationStore.contains is documented at archunit/src/main/java/com/tngtech/archunit/library/freeze/ViolationStore.java:50-55.",
      "fairness": "Prompt-stated",
      "name": "aSeparatelyCreatedStoreObservesTheRepairedIndex",
      "qualityCheck": "Valid persistence/integration check.",
      "verifies": "A new store initialized after repair reports the removed rule absent and the surviving rule present."
    },
    {
      "concerns": [],
      "evidence": "The prompt says broken entries are discarded and resolved entries are discarded with their files.",
      "fairness": "Prompt-stated",
      "name": "aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord",
      "qualityCheck": "Strong final-layout assertion for a case without unowned/shared artifacts.",
      "verifies": "Repair leaves only stored.rules and the kept file, and the kept entry maps to that file."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt explicitly requires concurrently initializing stores to leave a readable index and only the index and survivors' files.",
      "fairness": "Prompt-stated",
      "name": "concurrentInitializationsLeaveAReadableIndex",
      "qualityCheck": "Direct outcome check, but its fixed 30-second deadline can fail under severe load.",
      "verifies": "Four simultaneous repairs all finish within 30 seconds without exceptions; the readable index contains only the kept rule and folder only index plus kept file."
    },
    {
      "concerns": [
        "internal_coupling",
        "timing_sensitivity"
      ],
      "evidence": "The prompt requires concurrent initialization coherence and says repair moves a misplaced file to its derived name.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairsOfAMisplacedEntryLeaveItOnItsMovedFile",
      "qualityCheck": "The blocking strategy reaches into classification call timing and uses fixed waits/joins; outcome assertions are fair but orchestration is implementation-coupled and timing-sensitive.",
      "verifies": "Two orchestrated concurrent repairs terminate, preserve one rule mapped to derived, leave only index plus derived, preserve violation content, and leave a store accepted by fail."
    },
    {
      "concerns": [
        "timing_sensitivity"
      ],
      "evidence": "The prompt requires concurrent initializations to leave a readable index and survivor-only folder; fail may reject before repair completes.",
      "fairness": "Prompt-stated",
      "name": "concurrentRepairAndFailLeaveAReadableIndex",
      "qualityCheck": "The final state is discriminating, though broad RuntimeException catching can hide a repair-side RuntimeException if another repair succeeds; fixed timeout is load-sensitive.",
      "verifies": "Six simultaneous repair/fail initializations finish within 30 seconds, no non-RuntimeException escapes, and final index/folder contain only the kept survivor."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair needs default.allowStoreUpdate and is rejected without it.",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedAndChangesNothing",
      "qualityCheck": "Checks both rejection and no partial mutation.",
      "verifies": "Repair with default.allowStoreUpdate=false throws RuntimeException and leaves broken and kept index entries plus the kept file unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt unconditionally says repair needs default.allowStoreUpdate.",
      "fairness": "Prompt-stated",
      "name": "repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore",
      "qualityCheck": "Good guard-order edge case.",
      "verifies": "Repair with updates disabled throws even when the store is consistent."
    },
    {
      "concerns": [],
      "evidence": "The prompt says \"fail reports either way.\"",
      "fairness": "Prompt-stated",
      "name": "failWithoutPermissionToUpdateStillReportsTheInconsistency",
      "qualityCheck": "Direct permission-independence check.",
      "verifies": "Fail with updates disabled still throws and names the broken rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an absent index without default.allowStoreCreation is rejected before anything is examined.",
      "fairness": "Prompt-stated",
      "name": "anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined",
      "qualityCheck": "Good distinction between index existence and later integrity processing.",
      "verifies": "With creation disabled, absent stored.rules causes RuntimeException and remains absent; once an index exists, the same repair properties remove its broken entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail examines index/folder, reports every unowned file, changes nothing, and a rejection does not create an absent index.",
      "fairness": "Prompt-stated",
      "name": "failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne",
      "qualityCheck": "Precisely checks no side-effect on rejection.",
      "verifies": "Fail on a folder with no index but an unowned notes.txt reports that name, creates no index, and preserves file/content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an index not a regular file directly in the folder is rejected before examination.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatIsALinkOutOfTheStoreFolderIsRejectedAndItsTargetSurvives",
      "qualityCheck": "Direct index real-path safety test.",
      "verifies": "Repair rejects stored.rules when it is a symlink to an outside file and leaves outside content byte-for-byte unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an index not a regular file directly in the folder is rejected before anything is examined.",
      "fairness": "Prompt-stated",
      "name": "anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired",
      "qualityCheck": "Method name says unreadable, but setup deterministically tests the expressly stated directory case.",
      "verifies": "A stored.rules directory is rejected by repair and fail without changing names/bytes; a separate regular-index store is repaired normally."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly requires broken, resolved, shared, then unowned reporting order.",
      "fairness": "Prompt-stated",
      "name": "failNamesTheConditionsInTheStatedOrder",
      "qualityCheck": "Direct ordering assertion without pinning surrounding prose.",
      "verifies": "The fail message places broken entry before resolved entry before shared entry before unowned file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says within a condition entries are ordered by rule description and files by name.",
      "fairness": "Prompt-stated",
      "name": "failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName",
      "qualityCheck": "Discriminates both entry and file sorting keys.",
      "verifies": "Within fail's message, alpha broken precedes zulu broken and alpha-unowned precedes zulu-unowned."
    },
    {
      "concerns": [],
      "evidence": "The prompt says entries within a condition are ordered by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersSharedEntriesByRuleDescription",
      "qualityCheck": "Strong sorting-key discriminator.",
      "verifies": "Shared descriptions appear alphabetically by description even though underlying shared file names would induce another order."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail reports misplaced entries and orders entries within a condition by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescription",
      "qualityCheck": "Direct misplaced-order case.",
      "verifies": "Misplaced descriptions appear alpha, mike, zulu in the fail message."
    },
    {
      "concerns": [],
      "evidence": "The prompt says colliding entries are reported and entries within a condition sort by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersCollidingEntriesByRuleDescription",
      "qualityCheck": "Direct collision-order case.",
      "verifies": "Colliding descriptions appear alpha, mike, zulu in the fail message."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines occupied entries as a condition and says entries within a condition order by rule description.",
      "fairness": "Prompt-stated",
      "name": "failOrdersOccupiedEntriesByRuleDescription",
      "qualityCheck": "Good derived-name-versus-description discriminator.",
      "verifies": "Occupied descriptions appear alpha, mike, zulu despite inversely sorted derived names."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly selects rule description as the entry ordering key.",
      "fairness": "Prompt-stated",
      "name": "failOrdersMisplacedEntriesByRuleDescriptionAndNotByTheirDerivedNames",
      "qualityCheck": "Stronger variant of the earlier misplaced ordering test.",
      "verifies": "Misplaced descriptions appear alpha, mike, zulu despite inversely sorted derived names."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failWithSeveralConditionsAtOnceChangesNotOneByte",
      "qualityCheck": "Strong byte-level non-mutation integration check.",
      "verifies": "Fail throws for a multi-condition store and preserves the exact file-name list and bytes of every direct file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair discards resolved entries; contains' meaning is documented at archunit/src/main/java/com/tngtech/archunit/library/freeze/ViolationStore.java:50-55.",
      "fairness": "Prompt-stated",
      "name": "aRuleWhoseEntryWasDiscardedIsNoLongerFrozen",
      "qualityCheck": "Valid public-API consequence of index removal.",
      "verifies": "After repair removes an empty resolved entry, a new store's contains returns false for that rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a still violated rule keeps its entry; existing read semantics are visible at TextFileBasedViolationStore.java:190-204.",
      "fairness": "Prompt-stated",
      "name": "repairKeepsAStillViolatingRuleFrozenWithItsViolations",
      "qualityCheck": "Checks entry and violation-content preservation.",
      "verifies": "After repair, contains is true, getViolations returns exactly one remaining violation, and only the still-violating rule remains in the index."
    },
    {
      "concerns": [],
      "evidence": "Prompt-stated repair removes the resolved entry/file. Existing save/read behavior and random naming are produced at archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java:84-102,137-187,190-204.",
      "fairness": "Repo-discoverable",
      "name": "aRepairedStoreCanFreezeARuleAgain",
      "qualityCheck": "Good compatibility check with the pre-existing store API.",
      "verifies": "After repair removes a resolved rule/file, an ignore-mode save re-adds it, contains is true, one new violation reads back, and the old resolved filename is not reused."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires resolved-entry removal. FreezingArchRule.java:120-138 explicitly stores an unknown rule and returns a successful EvaluationResult; freeze/persistIn integration is at lines 170-180 and 205-212.",
      "fairness": "Repo-discoverable",
      "name": "aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation",
      "qualityCheck": "Fair end-to-end integration test, albeit heavier than a store unit test.",
      "verifies": "Repair empties the entry; the next real FreezingArchRule evaluation has no violation, re-adds the rule, and does not reuse the removed filename."
    },
    {
      "concerns": [],
      "evidence": "The prompt contrasts random new-file naming with deterministic description-derived naming; misplacement is defined by a rule's derived name.",
      "fairness": "Prompt-stated",
      "name": "randomFileNamesDeriveNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Directly establishes that random mode does not relocate legacy entries.",
      "verifies": "Under default random naming, repair removes a broken peer but leaves an arbitrary valid existing filename and mapping unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt says default.fileNames supports random and defines misplacement only against a derived rule name.",
      "fairness": "Prompt-stated",
      "name": "namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced",
      "qualityCheck": "Useful explicit-setting counterpart to default behavior.",
      "verifies": "Explicit random mode preserves an arbitrary entry/name through repair and is subsequently accepted by fail."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a constructor strategy names files the same way and repair moves misplaced files. Existing save serialization appends '\\n' at TextFileBasedViolationStore.java:145-154, and constructor strategy invocation is at lines 96-102 and 176-187.",
      "fairness": "Repo-discoverable",
      "name": "aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName",
      "qualityCheck": "Covers both maintenance and new-save integration.",
      "verifies": "Constructor strategy moves a legacy entry to its exact derived name/content, and a later save records a new rule under that strategy's exact name with newline-terminated content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says configuring default.fileNames for a store with a constructor strategy is rejected.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing",
      "qualityCheck": "Checks rejection is pre-mutation.",
      "verifies": "Supplying a constructor strategy plus default.fileNames throws RuntimeException and preserves the legacy index mapping/file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a strategy yielding no name is rejected as soon as a name is needed; repair/fail need it to classify placement.",
      "fairness": "Prompt-stated",
      "name": "aStrategyGivenToTheConstructorYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Covers both no-name representations and both examining modes.",
      "verifies": "Null- and empty-producing constructor strategies are rejected under both repair and fail, preserving exact index bytes and file list."
    },
    {
      "concerns": [],
      "evidence": "The prompt states random is default; names differ per rule, built-in names use the stated ASCII alphabet, are at most 200, never stored.rules, and random entries are not description-derived.",
      "fairness": "Prompt-stated",
      "name": "absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone",
      "qualityCheck": "Strong default naming contract test.",
      "verifies": "Default naming gives two saved rules distinct non-index ASCII [A-Za-z0-9_-]+ names of at most 200 chars, removes a broken entry, and a later repair preserves the random mapping and exact survivor file set."
    },
    {
      "concerns": [],
      "evidence": "The prompt says any other default.fileNames value is a fully-qualified RuleViolationFileNameStrategy implementation and names new files.",
      "fairness": "Prompt-stated",
      "name": "aConfiguredStrategyNamesNewlyStoredRules",
      "qualityCheck": "Direct configured-extension test.",
      "verifies": "A configured custom strategy saves a new rule under exactly DescriptionFileNames.createRuleFileName and leaves only index plus that file."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires a fully-qualified implementation with a public no-argument constructor, which a nonexistent class cannot satisfy.",
      "fairness": "Prompt-stated",
      "name": "aStrategyThatCannotBeInstantiatedIsRejected",
      "qualityCheck": "Direct class-loading failure case.",
      "verifies": "A nonexistent configured strategy class causes RuntimeException during initialization."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires an implementation of RuleViolationFileNameStrategy with a public no-argument constructor.",
      "fairness": "Prompt-stated",
      "name": "aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected",
      "qualityCheck": "Thorough reflective-construction validation.",
      "verifies": "Wrong-type, no-no-arg, and private-no-arg classes are each rejected; the original entry and file remain."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a strategy yielding no name is rejected as soon as a name is needed.",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore",
      "qualityCheck": "Configured-class counterpart to constructor strategy test.",
      "verifies": "Configured null- and empty-name strategies are rejected in repair and fail, preserving exact index bytes and file list."
    },
    {
      "concerns": [],
      "evidence": "The prompt says rejection occurs as soon as a name is needed; ignore examines nothing, while save needs a name.",
      "fairness": "Prompt-stated",
      "name": "aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore",
      "qualityCheck": "Precisely checks lazy rejection timing.",
      "verifies": "In ignore mode initialization succeeds, but saving with null/empty name throws and writes no new file or index entry; existing content remains exact."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines misplaced as name unequal to the rule-derived one and says repair moves its file and updates the entry.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved",
      "qualityCheck": "Canonical misplaced repair.",
      "verifies": "Repair changes the mapping from legacy-name to the exact derived name, removes the old path, and preserves exact violation content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair moves the misplaced entry's file, which preserves its violations; read-line form is existing API behavior at TextFileBasedViolationStore.java:190-204.",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryKeepsItsViolationsAfterTheMove",
      "qualityCheck": "Checks content preservation through public API.",
      "verifies": "After repair, the moved entry maps to the derived name and getViolations returns exactly the two original lines."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says moving a misplaced link moves the link's target rather than the link.",
      "fairness": "Prompt-stated",
      "name": "aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt",
      "qualityCheck": "Precisely discriminates target move from symlink rename.",
      "verifies": "Repair maps to the derived name, puts a non-symlink regular file there with exact content, removes old target/link names, and fail accepts."
    },
    {
      "concerns": [],
      "evidence": "The prompt says fail reports misplaced entries and changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesMisplacedEntriesAndChangesNothing",
      "qualityCheck": "Direct fail-mode counterpart.",
      "verifies": "Fail reports the misplaced rule and preserves legacy file set and mapping."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines an escaping derived name as occupied, says repair never moves occupied entries, and fail reports every conditioned entry.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameLeavingTheStoreFolderIsNeverUsed",
      "qualityCheck": "Strong unsafe-derived-name test.",
      "verifies": "Repair leaves the legacy mapping/file and outside content unchanged when the derived name escapes; fail later rejects and names the rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines one derived name shared by two rules as colliding and says repair never moves colliding entries while fail reports them.",
      "fairness": "Prompt-stated",
      "name": "twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved",
      "qualityCheck": "Canonical collision case.",
      "verifies": "Repair leaves both legacy mappings/files when both rules derive the same name; fail then reports both."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a derived name already naming something is occupied and repair never moves an occupied entry.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameAnUnownedFileOccupiesIsNotTakenOver",
      "qualityCheck": "Direct regular-file occupant case.",
      "verifies": "Repair preserves the legacy mapping, occupant content, and legacy violation content; fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a derived name that already names something is occupied, including unsafe path cases.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkOutOfTheStoreFolderOccupiesIsNotTakenOver",
      "qualityCheck": "Covers symlink occupant safety.",
      "verifies": "A symlink on the derived name prevents relocation; repair preserves legacy and outside contents, and fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines occupied as the derived name already naming something, not only an existing resolved target.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADanglingLinkOccupiesIsNotTakenOver",
      "qualityCheck": "Important no-follow existence edge case.",
      "verifies": "A dangling symlink at the derived name blocks repair relocation; legacy content remains and fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a derived name already naming something is occupied and repair never moves occupied entries.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameALinkToTheEntrysOwnFileOccupiesIsNotTakenOver",
      "qualityCheck": "Confirms occupation is pathname-based even for own-file aliases.",
      "verifies": "A symlink at the derived name to the entry's current file remains a symlink; legacy mapping/content remain, and fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says occupied means the derived name already names something.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameADirectoryOccupiesIsNotTakenOver",
      "qualityCheck": "Direct directory occupant case.",
      "verifies": "A directory at the derived name blocks relocation and remains; legacy mapping/content remain and fail reports."
    },
    {
      "concerns": [],
      "evidence": "The prompt says names are never stored.rules, storing never overwrites the index, and an existing derived name is occupied.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameEqualToTheIndexIsOccupiedAndNeverMovedOver",
      "qualityCheck": "Critical index-protection case.",
      "verifies": "Repair does not move over stored.rules, preserves exact index bytes and legacy content, and fail reports the rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an entry is occupied when its derived name is recorded by another entry and repair never moves occupied entries.",
      "fairness": "Prompt-stated",
      "name": "twoEntriesThatWouldSwapNamesAreNotMoved",
      "qualityCheck": "Good simultaneous-move hazard test.",
      "verifies": "Repair leaves both swapped mappings unchanged because each destination is recorded/occupied; fail reports both."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines collision by two rules sharing one derived name and says colliding entries are reported and never moved.",
      "fairness": "Prompt-stated",
      "name": "failNamesBothCollidingRulesEvenWhenOneAlreadyRecordsTheDerivedName",
      "qualityCheck": "Checks collision applies to all participants.",
      "verifies": "Fail reports both colliding rules even when one is already on the shared derived name; repair leaves both mappings/files unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires colliding entries in fail's report and says fail changes nothing.",
      "fairness": "Prompt-stated",
      "name": "failNamesCollidingEntriesAndChangesNothing",
      "qualityCheck": "Direct non-mutating collision report.",
      "verifies": "Fail reports both colliding descriptions and preserves index plus both legacy files."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair never moves colliding entries but still discards one that is broken or resolved.",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName",
      "qualityCheck": "Strong precedence check.",
      "verifies": "Repair removes colliding-derived entries that are resolved or broken, including their files, while retaining the colliding entry with violations at its legacy name/content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says occupied entries are not moved but are still discarded when broken/resolved, while unowned files are left alone.",
      "fairness": "Prompt-stated",
      "name": "brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied",
      "qualityCheck": "Comprehensive occupied-precedence case.",
      "verifies": "Repair removes broken/resolved entries despite occupied derived names, retains the still-violating occupied entry, and preserves every unowned occupant's exact content."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says same-name entries are shared even if nothing exists and a derived name recorded by another entry is occupied.",
      "fairness": "Prompt-stated",
      "name": "aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt",
      "qualityCheck": "Excellent name-reservation-without-file test.",
      "verifies": "A rule is not moved onto a derived name recorded by two shared missing entries; shared entries remain, unrelated broken entry is removed, only legacy file exists, and fail reports the occupied rule."
    },
    {
      "concerns": [],
      "evidence": "The prompt says storing never writes over a file its own entry does not record and such a save is rejected.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverAFileTheStoreDoesNotOwn",
      "qualityCheck": "Canonical save-overwrite guard.",
      "verifies": "Saving an unknown rule whose derived name is an unowned file throws and preserves that file's exact content."
    },
    {
      "concerns": [],
      "evidence": "The prompt prohibits writing a file the saving rule's entry does not record. Existing newline serialization is produced by TextFileBasedViolationStore.java:145-154.",
      "fairness": "Repo-discoverable",
      "name": "storingASecondUnknownRuleNeverTakesOverTheFirstRulesFile",
      "qualityCheck": "Checks rejection has no partial index/file mutation.",
      "verifies": "After first save, second colliding unknown save throws; only first entry/file remains, mapping equals the strategy name, and content is exactly 'first violation\\n'."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires store-owned violation files to be regular files directly in the folder, defines outside/nondirect entries as broken, and says storing never writes outside the folder.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected",
      "qualityCheck": "Fair integrity-preservation test for unsafe strategy output.",
      "verifies": "Escaping and nested derived names both cause save rejection; outside/nested preexisting contents remain exact, no entry is added, and only the index is a direct file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says an occupied derived name already naming something cannot be taken over and such a save is rejected.",
      "fairness": "Prompt-stated",
      "name": "storingAPreviouslyUnknownRuleNeverTakesOverADanglingLink",
      "qualityCheck": "Important dangling-link overwrite guard.",
      "verifies": "An unknown-rule save to a derived name occupied by a dangling symlink throws, leaves the symlink, and adds no index entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt says storing never writes outside the folder or over the index and such saves are rejected.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected",
      "qualityCheck": "Direct existing-entry safety test.",
      "verifies": "Saves through an entry recording ../outside and an entry recording stored.rules both throw; outside content and exact index bytes remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt prohibits outside writes and unsafe saves. Existing known-rule overwrite/newline behavior is at TextFileBasedViolationStore.java:137-154,176-187.",
      "fairness": "Repo-discoverable",
      "name": "storingARuleWhoseEntryRecordsADanglingLinkNeverCreatesTheFileItPointsAt",
      "qualityCheck": "Strong direct/chained symlink safety test with a healthy-operation control.",
      "verifies": "Saves through direct and chained dangling links throw without creating the outside target or changing index bytes; saving another safe known rule still writes exactly 'a new violation\\n'."
    },
    {
      "concerns": [],
      "evidence": "The prompt says a still violated rule keeps its entry and saving must not overwrite a foreign file. Existing save serialization and reuse of existing mappings are at TextFileBasedViolationStore.java:145-154,176-187.",
      "fairness": "Repo-discoverable",
      "name": "storingAStillViolatedRuleWritesToItsOwnFileEvenWhenItsDerivedNameIsOccupied",
      "qualityCheck": "Good distinction between known-entry destination and newly derived destination.",
      "verifies": "A known rule keeps/writes its legacy entry file, an unknown rule gets its derived name, occupant content remains exact, final file set is exact, and saved known content is newline-terminated."
    },
    {
      "concerns": [],
      "evidence": "The prompt says storing never writes over the index; resolved-path spelling/links cannot bypass that rule.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected",
      "qualityCheck": "Strong alias-resistant index protection.",
      "verifies": "Entries recording ./stored.rules or a symlink to stored.rules cannot be saved; exact index bytes remain unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt prohibits writing over the index; under standard filesystem semantics a hard link denotes the same file.",
      "fairness": "Prompt-stated",
      "name": "storingARuleWhoseEntryRecordsAHardLinkToTheIndexIsRejected",
      "qualityCheck": "Completes index identity protection across hard links.",
      "verifies": "Saving through an entry naming a hard link to stored.rules throws and leaves exact index bytes unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says storing a rule never writes over the index and such a save is rejected.",
      "fairness": "Prompt-stated",
      "name": "storingARuleNeverWritesOverTheIndex",
      "qualityCheck": "Canonical strategy-output index guard.",
      "verifies": "A strategy deriving stored.rules causes save rejection and no index entry is added."
    },
    {
      "concerns": [],
      "evidence": "The prompt says under repair, storing no violations forgets a known rule and discards entry/file; the restriction to repair leaves existing ignore semantics intact.",
      "fairness": "Prompt-stated",
      "name": "storingNoViolationsUnderRepairForgetsTheEntryAndItsFile",
      "qualityCheck": "Good mode comparison.",
      "verifies": "Repair-mode empty save removes known entry/file; ignore-mode empty save keeps the entry and reads an empty violation list."
    },
    {
      "concerns": [],
      "evidence": "The prompt limits empty-save forgetting to repair and says fail changes nothing of its own.",
      "fairness": "Prompt-stated",
      "name": "onlyRepairForgetsAResolvedRuleWhileFailKeepsIt",
      "qualityCheck": "Direct repair-versus-fail discriminator.",
      "verifies": "Empty save after repair removes the entry, while empty save after successful fail initialization keeps its entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt categorically says storing never writes outside the folder and shared files are not discarded while another entry shares them.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside",
      "qualityCheck": "Intentionally allows both safe policies and pins only the required safety property.",
      "verifies": "Whether empty save succeeds or rejects for a shared escaping entry, the outside file still exists with exact content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says empty-save forgetting discards its file unless another entry shares that file; sharing is by resolved file identity.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryReachesThroughAHardLink",
      "qualityCheck": "Direct hard-link sharing preservation.",
      "verifies": "Empty save removes only the forgotten entry; both hard-link names and shared content remain, and the keeping rule still reads one violation."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the file is not discarded when another entry shares it.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleKeepsTheFileAnotherEntryStillRecords",
      "qualityCheck": "Direct symbolic-link sharing preservation.",
      "verifies": "Empty save removes only the forgotten symlink-naming entry; target and symlink names remain, content survives, and keeping rule reads the violation."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says storing no violations for an unknown rule stores nothing.",
      "fairness": "Prompt-stated",
      "name": "forgettingARuleTheIndexNeverKnewStoresNothingForIt",
      "qualityCheck": "Canonical unknown empty-save case.",
      "verifies": "Repair-mode empty save for an unknown rule leaves the index empty and folder containing only stored.rules."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says a still violated rule keeps its entry.",
      "fairness": "Prompt-stated",
      "name": "aStillViolatedRuleKeepsItsEntryUnderRepair",
      "qualityCheck": "Direct complement to empty-save forgetting.",
      "verifies": "Repair-mode nonempty save preserves the known rule's sole index entry and getViolations returns exactly the new one-line list."
    },
    {
      "concerns": [],
      "evidence": "The prompt says description names keep a word of 4+ letters or digits.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionShowTheRuleTheyStore",
      "qualityCheck": "The helper accepts any qualifying word, matching the prompt's flexibility.",
      "verifies": "Description mode creates a filename containing at least one case-insensitive ASCII alphanumeric word of length >=4 from the description, and folder contains only index plus that file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says description naming derives deterministically from the rule description.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameInALaterRun",
      "qualityCheck": "Direct determinism test.",
      "verifies": "The same rule description saved in two stores gets exactly the same description-derived filename."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires deterministic description derivation, built-in ASCII names, a 200-character bound, and a retained qualifying word.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameOnAnotherMachine",
      "qualityCheck": "Strong portability check; process/JVM availability is noted as a suite environment assumption.",
      "verifies": "Separate JVMs with different user/home/temp/locale/encoding produce equal names; the name matches [A-Za-z0-9_-]+, is <=200 chars, and keeps a qualifying description word."
    },
    {
      "concerns": [],
      "evidence": "The prompt says the name derives deterministically from the rule description, not store state.",
      "fairness": "Prompt-stated",
      "name": "aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds",
      "qualityCheck": "Good state-independence discriminator.",
      "verifies": "The same description gets the same name in an empty and a pre-populated store."
    },
    {
      "concerns": [],
      "evidence": "The prompt says names differ per rule and each keeps a word, even late in a long description.",
      "fairness": "Prompt-stated",
      "name": "twoRulesReadingAlikeStillGetDifferentNames",
      "qualityCheck": "Good collision-resistance test for truncation-heavy inputs.",
      "verifies": "Two very long descriptions sharing a long prefix get unequal names; each name retains a qualifying word and both files are present."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires built-in ASCII-only bounded names and retained qualifying words.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName",
      "qualityCheck": "Strong sanitization/path-safety case.",
      "verifies": "A punctuation/path-like long description yields [A-Za-z0-9_-]+ of <=200 chars, retains a qualifying word, and creates only the intended direct file."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires deterministic, ASCII, bounded description names and calls out useful material late in long descriptions.",
      "fairness": "Prompt-stated",
      "name": "aLongWordAfterOnlyShortOnesStillYieldsABoundedName",
      "qualityCheck": "Checks the bound and determinism; it does not itself assert the late word is retained.",
      "verifies": "A long description with many short words and a 160-character late word yields a stable [A-Za-z0-9_-]+ name of <=200 chars in two runs."
    },
    {
      "concerns": [],
      "evidence": "The prompt explicitly says a word of 4+ letters/digits must be kept even when late in a long description.",
      "fairness": "Prompt-stated",
      "name": "aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt",
      "qualityCheck": "Direct regression test for premature truncation.",
      "verifies": "A late qualifying word after 60 short words appears in a [A-Za-z0-9_-]+ name of <=200 chars, with only index plus that file present."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires deterministic built-in ASCII filenames for rules generally; the qualifying-word clause is inapplicable when no such word exists.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionWithoutAnyPlainCharacterStillYieldsAStableName",
      "qualityCheck": "Good fallback-name case.",
      "verifies": "A punctuation-only description yields a nonempty [A-Za-z0-9_-]+ name stable across two stores."
    },
    {
      "concerns": [],
      "evidence": "The prompt requires built-in ASCII names, different names per rule, deterministic description derivation, and a 200-character maximum.",
      "fairness": "Prompt-stated",
      "name": "aDescriptionOfOnlyNonAsciiCharactersStillYieldsAStableAsciiName",
      "qualityCheck": "Strong Unicode fallback and distinction test.",
      "verifies": "A non-ASCII-only description yields an ASCII [A-Za-z0-9_-]+ name <=200, differs from another rule's name, and is stable across stores."
    },
    {
      "concerns": [],
      "evidence": "Description recognizability is prompt-stated. Exact ordered save/read behavior is documented by ViolationStore.java:58-72 and produced by TextFileBasedViolationStore.java:137-154,190-204; baseline tests assert it at TextFileBasedViolationStoreTest.java:53-62,76-85.",
      "fairness": "Repo-discoverable",
      "name": "violationsAreReadBackFromANameTakenFromTheDescription",
      "qualityCheck": "Fair integration with existing ordered read/write semantics.",
      "verifies": "Two saved violations are read back in exact order from a description-derived file, whose name keeps a qualifying description word."
    },
    {
      "concerns": [],
      "evidence": "The prompt defines such an entry as misplaced and requires repair to move it to its derived description name while retaining a qualifying word.",
      "fairness": "Prompt-stated",
      "name": "anEntryRecordingALegacyNameIsMovedToTheNameTakenFromTheDescription",
      "qualityCheck": "Direct built-in-description migration test.",
      "verifies": "Repair changes a legacy UUID-like mapping to a distinct recognizable description name, removes the old path, and preserves exact content."
    },
    {
      "concerns": [],
      "evidence": "The prompt says built-in names are never stored.rules and each keeps a qualifying word.",
      "fairness": "Prompt-stated",
      "name": "namesTakenFromTheDescriptionNeverCollideWithTheIndex",
      "qualityCheck": "Canonical reserved-name case.",
      "verifies": "Saving a rule described exactly 'stored.rules' produces a different filename that still contains a qualifying word from that description."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair writes the index only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical",
      "qualityCheck": "Strong positive and negative byte-level check.",
      "verifies": "Repair leaves a consistent index byte-identical but rewrites an index from which it removes a broken entry."
    },
    {
      "concerns": [],
      "evidence": "The prompt says shared/unowned findings are left alone and repair writes the index only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex",
      "qualityCheck": "Excellent check against gratuitous Properties reserialization.",
      "verifies": "Repair preserves exact hand-written index bytes when findings are only shared/unowned, keeps all entries, and fail still reports the unowned file."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair writes the index only when an entry changed.",
      "fairness": "Prompt-stated",
      "name": "arepairThatChangesNothingLeavesTheIndexByteIdentical",
      "qualityCheck": "Direct no-op rewrite regression test.",
      "verifies": "After an initial repair, a second no-op repair leaves exact index bytes unchanged."
    },
    {
      "concerns": [],
      "evidence": "The prompt says repair examines the index and folder while initializing, which requires the current on-disk index rather than stale process cache.",
      "fairness": "Prompt-stated",
      "name": "repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder",
      "qualityCheck": "Important same-process freshness test.",
      "verifies": "After an ignore initialization caches/observes one index, replacing the on-disk index with a different broken-only index causes later repair to empty the actual disk index."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Problem description have appropriate length (target: 100-200 words)**

Status: WARNING

Description is verbose (560 words, over target by 60). Consider trimming to ≤500 words.

```json
{
  "errorThreshold": 1000,
  "target": 500,
  "warningThreshold": 500,
  "wordCount": 560
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

> "An entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder."

Make the alternatives parallel: “Treat a derived name as occupied if it already exists in the folder, another entry records that name, or resolving the name escapes the folder.” This retains the tested occupancy conditions while making clear what each verb applies to. _(marked resolved, but the sentence is still in the description)_

> "`repair` discards broken entries. It discards resolved entries with the files they name, deleting a link's target with the link."

The repair/fail paragraph combines mutation rules, error reporting, ordering, permissions, and index preconditions in one dense block. Separate it into a repair paragraph, a fail paragraph, and a short preconditions paragraph. For example, begin: “In `repair`, discard broken entries. For an unshared resolved entry, remove its index entry and owned file; if it is a link, remove both the link and its in-folder target.” Preserve the existing ordering and permission details verbatim in their respective paragraphs. _(marked resolved, but the sentence is still in the description)_

> "An entry both shared and something else stays shared."

Use an explicit subject and predicate: “An entry that is shared and also meets another condition remains shared.” This preserves the precedence rule while avoiding the compressed “shared and something else” construction. _(marked resolved, but the sentence is still in the description)_

> "`repair` discards broken entries."

Present the `repair` and `fail` policies as separate short paragraphs. For example, start repair with “In `repair` mode, remove broken entries; remove resolved entries and their owned files; and relocate safe misplaced entries.” Follow with the shared/colliding/occupied exceptions and index-write condition. Then state the `fail` reporting and ordering rules in its own paragraph. This is presentation-only: retain every named condition, ordering requirement, permission rule, and absent-index behavior. _(marked resolved, but the sentence is still in the description)_

> "Its report names every entry in any condition, misplaced and colliding entries included, and every unowned file."

State the reporting scope plainly: “When validation fails, report every affected entry—including misplaced and colliding entries—and every unowned file.” Keep the following ordering sentence. This removes the awkward “entry in any condition” construction without changing which findings appear. _(marked resolved, but the sentence is still in the description)_

> "deleting a link's target with the link"

Make the deletion target explicit: “For a resolved entry whose recorded path is a link, delete both the link and its target.” This is easier to parse while preserving the required behavior. _(marked resolved, but the sentence is still in the description)_

> "Storing a rule never writes over the index, anything outside the folder, or a file its own entry does not record."

Make the prohibited save targets explicit: “Reject a save if its target is the index, outside the store folder, or a file not recorded by that rule’s own entry. Leave the index and folder unchanged when rejecting it.” The current coordination of “writes over” across three unlike objects makes the safety rule needlessly difficult to parse. _(marked resolved, but the sentence is still in the description)_

> "Under `repair`, storing no violations forgets a known rule, discarding its entry"

Separate the save behaviors into short sentences: “Under `repair`, saving no violations for a known rule forgets that rule. Remove its entry and file unless another entry shares the file. For an unknown rule, save nothing. If deletion fails, reject the save and retain the entry. A rule with violations keeps its entry.” This keeps every tested repair-save condition while making the branches explicit. _(marked resolved, but the sentence is still in the description)_

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 4 total suggestions (3 medium, 1 low). With 3+ suggestions, the mandatory verdict is request_changes.",
  "suggestions": [
    {
      "priority": "medium",
      "quote": "\"repair\" and \"fail\" examine the index and the folder while initializing.",
      "suggestion": "Remove this sentence — it’s implied by the integrity modes and the rest of the description already frames all checks as part of initialization."
    },
    {
      "priority": "medium",
      "quote": "A strategy that yields no name is rejected as soon as a name is needed.",
      "suggestion": "Drop the timing qualifier \"as soon as a name is needed\" — it’s over‑specific sequencing. Keep only that such a strategy is rejected."
    },
    {
      "priority": "low",
      "quote": "So are two entries whose recorded names resolve to one file, as when one links to that file.",
      "suggestion": "Remove the example clause \"as when one links to that file\" — it’s illustrative, not normative, and the core rule is already stated by \"resolve to one file\"."
    },
    {
      "priority": "medium",
      "quote": "A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store is rejected.",
      "suggestion": "Remove the clause \"A strategy given to the constructor names files the same way,\" — it’s obvious from passing a naming strategy via constructor. Keep the important part about rejecting simultaneous configuration."
    }
  ],
  "summary": "- [MEDIUM] Remove the redundant initialization note: \"repair and fail examine the index and the folder while initializing.\" This is already implied by the integrity modes and the rest of the spec discussing behavior during initialization.\n- [MEDIUM] Trim over-specific timing: in \"A strategy that yields no name is rejected as soon as a name is needed.\", delete \"as soon as a name is needed\". The essential requirement is simply that such a strategy is rejected.\n- [LOW] Drop the illustrative example: in \"So are two entries whose recorded names resolve to one file, as when one links to that file.\", remove \"as when one links to that file\". The example adds verbosity without changing the rule that sharing is based on resolving to the same file.\n- [MEDIUM] Remove the obvious constructor-behavior clause: in \"A strategy given to the constructor names files the same way, and configuring default.fileNames for such a store is rejected.\", delete \"A strategy given to the constructor names files the same way,\" and keep the prohibition against mixing constructor strategy with `default.fileNames`.",
  "verdict": "request_changes"
}
```
