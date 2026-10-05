**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥40 messages, ≥200 LOC

This task numbers: Median files: 6.5, messages: 220.5, LOC: 678

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "62487cb9ccb39d7a76c925b261003a9d258ddefaa90618a16a26e9285b9ee67f",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Implements automatic legalization/renaming of invalid Java identifiers with a deterministic plan across classes, fields, and methods, propagating mappings through rendering and the constant pool. Adds a planning API and rules, updates PoolInterceptor, and rewires decompilation so references, annotations, generics, and nested names remain consistent.",
      "confidence": 0.94,
      "contentAuthoredAt": 1785155734997,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": false,
      "meaningful_differences": [
        "The submission adds a duplicate-class resolution feature: a new option (duplicate-class-strategy) and a resolver that selects winners among multiple origins (first/last/error), with class-family anchoring based on InnerClasses/EnclosingMethod metadata, deterministic ordering, and warning/error reporting.",
        "The submission reworks StructContext/ContextUnit integration to defer resolution until requested, cache decisions, respect own-vs-library precedence, invalidate on reload/add-space, and ensure only the selected origin’s class is loaded and emitted.",
        "The candidate implements identifier legalization/renaming: it plans and applies legal Java names for classes/fields/methods (preserving valid names), computes override families, allocates conflict-free names deterministically, and propagates mappings through the writer, constant pool, generics, annotations, and expression rendering.",
        "The candidate introduces a new IdentifierRenamingPlan and JavaIdentifierRules, extends PoolInterceptor to publish/query planned mappings, and updates rendering components (ExprProcessor, FieldExprent, AnnotationExprent, GenericType, ConstantPool) to use these mappings; none of this overlaps the duplicate-origin selection lifecycle.",
        "Shared edits to Fernflower are for different purposes: the submission passes a new strategy into StructContext; the candidate wires a PoolInterceptor and runs renaming unconditionally."
      ],
      "one_liner": "One adds deterministic, strategy-driven selection of a single origin for duplicate class files (with family-coherence and logging), while the other introduces automatic, deterministic legalization/renaming of invalid Java identifiers across classes, fields, and methods with end-to-end reference consistency.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "Although both patches touch the same repository, they target different lifecycles and surfaces: one governs which byte source wins when duplicates exist, the other ensures emitted identifiers are legal and consistently renamed across all references. Their modified files overlap only at framework entry points (e.g., Fernflower) but for unrelated purposes, and their observable behaviors and scopes do not intersect. These are separate exercises and should co‑exist.",
      "similarity": 0.5501934909831648,
      "submission_summary": "Introduces a configurable duplicate-class strategy (first/last/error) and a DuplicateClassResolver integrated into StructContext/ContextUnit to pick a single origin per class, anchor class families via metadata, cache and invalidate decisions, log deterministic selections or conflicts, and emit only the chosen own classes.",
      "title": "Automatic Identifier Legalization",
      "verdict": "distinct"
    }
  ],
  "reusedFromPriorRun": true
}
```

---

**Test Fairness**

Coverage Suggestions (3) - Not Blockers

Advisory only — these don't affect the check result.

Own-over-library registration permutations
Add a case where an own source is registered before later eager and lazy libraries with the same class, proving own precedence is independent of registration direction as well as strategy.

Concurrent output processing
Add an explicitly overlapping output-processing/save scenario, if the API supports it safely, since current tests force simultaneous lookups and compare thread counts but do not directly race output processing.

Reload warning lifecycle
After reload, resolve the same differing duplicate again and assert that the rebuilt decision emits one new warning while repeated post-reload lookups do not duplicate it.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Own-over-library registration permutations",
      "suggestion": "Add a case where an own source is registered before later eager and lazy libraries with the same class, proving own precedence is independent of registration direction as well as strategy."
    },
    {
      "area": "Concurrent output processing",
      "suggestion": "Add an explicitly overlapping output-processing/save scenario, if the API supports it safely, since current tests force simultaneous lookups and compare thread counts but do not directly race output processing."
    },
    {
      "area": "Reload warning lifecycle",
      "suggestion": "After reload, resolve the same differing duplicate again and assert that the rebuilt decision emits one new warning while repeated post-reload lookups do not duplicate it."
    }
  ],
  "error": "",
  "executionTimeSeconds": 214.660095,
  "message": "All hidden tests are fair.",
  "overall": "PASS. All 48 hidden tests assert behavior explicitly stated by the task prompt, with visible repository APIs supporting the chosen integration points (`Fernflower` properties, `StructContext` lookup/reload/save, `IContextSource` child/lazy/source/sink contracts). The suite is unusually comprehensive and generally avoids brittle full-message matching or internal field inspection. The dynamic javac family fixtures include two self-checks that generated local/anonymous names match across structurally identical compilations; these are reasonable deterministic fixture guards and do not force an implementation-specific family algorithm. Concurrency timeouts are generous and the synchronized start is appropriate.",
  "taskSummary": "Implement context-wide duplicate-class resolution for own inputs and eager/lazy libraries. The new `duplicate-class-strategy` option accepts exactly `first`, `last`, and `error`, defaults to `first`, and must be validated before inputs are processed. Origins are source instances, not source names; own sources outrank libraries; ordering follows root registration and child-list order. `error` compares exact classfile bytes, identical candidates coalesce to the first eligible origin, and repeats inside one origin are not conflicts. Exact own-source duplicates activate metadata-based family coherence through transitive `InnerClasses` and `EnclosingMethod` links, while `$` alone and library duplicates do not. Resolution is deferred, cached per decompiler context, invalidated appropriately on source addition, and reset by reload. Winners, warnings/errors, output ownership, resources, and concurrent behavior must all reflect the same stable decision.",
  "tests": [
    {
      "evidence": "The prompt explicitly says the default is `first`, differing `first`/`last` decisions emit one warning, every selected own class is returned once and emitted only through its selected origin, losing duplicates are omitted, and nonduplicate classes/resources remain with their inputs.",
      "fairness": "Prompt-stated",
      "name": "firstIsTheCompatibilityDefaultAndKeepsOutputOwnership",
      "qualityCheck": "Strong end-to-end default/output test. It checks semantic contents and sets rather than brittle class ordering.",
      "verifies": "With no explicit option, `getOwnClasses()` returns exactly three unique own classes; the duplicate contains `firstMarker`; saving writes exactly the duplicate and `FirstOnly` to the first sink, only `SecondOnly` to the second sink, preserves each source's resource, and emits exactly one warning."
    },
    {
      "evidence": "The prompt names the public option and says `last` selects by registration order, selected classes use the selected origin's sink, losing duplicates are omitted, and resources stay with original inputs. The public properties integration is visible in `src/org/jetbrains/java/decompiler/main/Fernflower.java:40-55`.",
      "fairness": "Prompt-stated",
      "name": "publicFernflowerOptionControlsEndToEndOutputOwnership",
      "qualityCheck": "Good public-API integration coverage; content matching is semantic and not tied to formatting.",
      "verifies": "Passing `duplicate-class-strategy=last` through the public `Fernflower` properties leaves the first class sink empty, writes exactly the duplicate to the last sink with content containing `publicLastMarker`, and preserves both resources."
    },
    {
      "evidence": "The prompt explicitly defines `last` by registration order and says a selected class is emitted only through its selected origin, losing duplicate entries are omitted, and nonduplicates/resources remain.",
      "fairness": "Prompt-stated",
      "name": "lastSelectsTheLatestOriginWithoutWritingThroughTheLoser",
      "qualityCheck": "Focused and non-brittle.",
      "verifies": "`last` loads the second origin's `secondMarker`; saving writes only `FirstOnly` through the first sink and the duplicate through the second sink, while retaining the first resource."
    },
    {
      "evidence": "The prompt says `error` rejects exact-byte differences and identifies every conflicting highest-tier origin. `getOwnClasses()` has no checked exception in `src/org/jetbrains/java/decompiler/struct/StructContext.java:146-151`, so the broad unchecked-exception assertion is compatible with the visible API.",
      "fairness": "Prompt-stated",
      "name": "errorRejectsDifferentHighestTierBytesWithStableOrigins",
      "qualityCheck": "Uses broad exception type and substring checks rather than pinning implementation wording.",
      "verifies": "Resolving differing own-source bytes under `error` throws a `RuntimeException`; its message contains the binary name and both origin names; neither sink receives a class."
    },
    {
      "evidence": "The prompt explicitly says byte-identical candidates are allowed and use the first eligible origin, repeated entries from one origin are not inter-origin conflicts, selected own classes are returned once, and warnings are for differing `first`/`last` decisions.",
      "fairness": "Prompt-stated",
      "name": "errorCoalescesIdenticalBytesAndIgnoresRepeatedEntriesFromOneOrigin",
      "qualityCheck": "Good combined coverage of two easy-to-confuse exceptions.",
      "verifies": "Under `error`, byte-identical inter-origin duplicates load `sameMarker`, save the duplicate only through the first origin, retain the second origin's unique class/resource, and emit no warning; two repeated entries in one origin produce exactly one own class with `singleOriginMarker` and no warning."
    },
    {
      "evidence": "The prompt explicitly says that within the highest-precedence tier, `first` and `last` use child-context list order.",
      "fairness": "Prompt-stated",
      "name": "childContextListOrderDefinesFirstAndLast",
      "qualityCheck": "Direct and deterministic.",
      "verifies": "For child origins listed first then second, `first` returns the class with `firstChildMarker` and `last` returns the class with `secondChildMarker`."
    },
    {
      "evidence": "The prompt says every context source is an origin, child-list order controls selection, and output goes only through the selected origin while nonduplicates/resources remain.",
      "fairness": "Prompt-stated",
      "name": "childOriginKeepsOutputOwnershipForItsSelectedClass",
      "qualityCheck": "Covers child origins as true output owners, not just ordering.",
      "verifies": "With `last`, the selected duplicate has `secondChildOut`; saving sends only `FirstOnly` to the first child, the duplicate to the second child, and preserves each child's resource."
    },
    {
      "evidence": "The prompt explicitly requires exact own-source duplicates to activate family coherence, `InnerClasses` and `EnclosingMethod` linkage, root-origin anchoring, and also says metadata linkage alone does not combine origins without an exact duplicate.",
      "fairness": "Prompt-stated",
      "name": "metadataFamilyLockingPreservesLocalAndNonduplicateSplitControls",
      "qualityCheck": "Comprehensive co-assertions accurately distinguish member, local, and nonduplicate controls. The fixture self-check assumes deterministic javac local-class naming across structurally identical compilations, but it does not constrain the submitted implementation.",
      "verifies": "A duplicated member family under `last` yields exactly two classes, both root and member from `selected-family`, and no output from losing root/member-only origins; a local family linked by metadata loads both root and local class from the anchored source; a metadata-linked but nonduplicated split family remains split across two origins, returns/saves two classes with the expected markers, and emits no warnings."
    },
    {
      "evidence": "The prompt explicitly says to fail when an encountered member exists only in another own origin and to identify the family root, member, anchored origin, and alternative origins.",
      "fairness": "Prompt-stated",
      "name": "anchoredFamilyRejectsAMemberAvailableOnlyInAnotherOrigin",
      "qualityCheck": "Message assertions are semantic substring checks and carefully distinguish root from member.",
      "verifies": "Family resolution throws when the root-selected origin lacks the member; the message contains the member name, separately contains the root name, and names both the anchored and alternative origins."
    },
    {
      "evidence": "The prompt explicitly says a literal `$` in a top-level binary name does not establish a family, while ordinary differing duplicates still follow `last` and warn.",
      "fairness": "Prompt-stated",
      "name": "dollarInATopLevelBinaryNameDoesNotCreateAFamily",
      "qualityCheck": "Good regression guard against name-based family inference; it does not over-specify warning text.",
      "verifies": "For a top-level class literally named `sample/Cash$Money`, `last` selects the `cashLast` bytes and the first warning contains that exact binary name."
    },
    {
      "evidence": "The prompt explicitly applies selection to eager/lazy libraries, says own sources outrank every library, resolution and lazy probes are cached, and conflicts concern the highest-precedence tier.",
      "fairness": "Prompt-stated",
      "name": "librariesRespectSourcePrecedenceRegistrationOrderAndCaching",
      "qualityCheck": "Good cross-product coverage. Exact lazy read counts follow the stated probe cache and the need to inspect candidates for differing-byte decisions.",
      "verifies": "Across lazy/eager library duplicates, `first` loads `lazyFirstMarker`, repeated `getClass`/`hasClass` calls remain positive, and each lazy source is read exactly once; `last` loads `lazyLastMarker`; for each of `first`, `last`, and `error`, an own duplicate outranks eager and lazy libraries, returns `ownMarker`, and emits no duplicate warning."
    },
    {
      "evidence": "The prompt explicitly applies the same selection to lazy libraries and says `error` rejects only exact-byte differences while identical candidates are allowed.",
      "fairness": "Prompt-stated",
      "name": "lazyErrorDistinguishesDifferentAndIdenticalBytes",
      "qualityCheck": "Concise and directly tied to byte semantics.",
      "verifies": "Two differing lazy-library candidates under `error` throw and name both lazy origins; byte-identical lazy candidates succeed and expose `sameMarker`."
    },
    {
      "evidence": "The prompt explicitly says positive and negative lazy probes and selections are cached, and `reloadContext()` discards duplicate-resolution and lazy-probe results before rebuilding.",
      "fairness": "Prompt-stated",
      "name": "reloadRefreshesPositiveAndNegativeDecisions",
      "qualityCheck": "Strong positive/negative cache test with observable read counts.",
      "verifies": "An eager positive lookup remains on `beforeReload` after source mutation but changes to `afterReload` after `reloadContext()`; a repeated lazy miss stays false and performs one read, remains false after source mutation, then becomes true after reload and has exactly two total reads."
    },
    {
      "evidence": "The prompt explicitly says adding another context source invalidates affected class and family decisions, and `last` uses registration order.",
      "fairness": "Prompt-stated",
      "name": "addingASourceInvalidatesCachedClassAndFamilySelections",
      "qualityCheck": "Tests the family cache, not only the direct duplicate cache.",
      "verifies": "After caching a duplicated family's second-origin member, adding a later own source under `last` makes both root and member resolve to that newly added origin's markers."
    },
    {
      "evidence": "The prompt explicitly requires one warning per differing decision identifying binary name, strategy, selected origin, and ignored origins in registration order.",
      "fairness": "Prompt-stated",
      "name": "warningIsSemanticOrderedAndEmittedOncePerDecision",
      "qualityCheck": "Semantic substring/order checks avoid brittle full-message matching.",
      "verifies": "Repeated class/has-class lookups plus saving produce exactly one warning; it contains the binary name, `last`, selected origin `origin-c`, and ignored origins `origin-a` then `origin-b` in that order."
    },
    {
      "evidence": "The prompt explicitly says concurrent lookups or output processing must not change the winner and selected output must use only the selected sink.",
      "fairness": "Prompt-stated",
      "name": "threadCountDoesNotChangeSelectionOrSinkOwnership",
      "qualityCheck": "Deterministic and checks both selection and output ownership, though it varies configured parallelism rather than forcing a race.",
      "verifies": "At thread counts 1 and 4, `last` leaves the first sink empty, writes exactly the duplicate to the second sink, and emits content containing `parallelSecond`."
    },
    {
      "evidence": "The prompt explicitly requires concurrent lookups not to change the winner and one warning per resolved decision.",
      "fairness": "Prompt-stated",
      "name": "simultaneousLookupsAgreeOnOneWinnerAndResolveOnce",
      "qualityCheck": "Reasonable 30-second bounds and synchronized start reduce flakiness; broad semantic assertions avoid scheduling assumptions.",
      "verifies": "Eight barrier-synchronized `hasClass`/`getClass` workers all receive a class with `concurrentSecond`; afterward there is exactly one warning containing the duplicate name."
    },
    {
      "evidence": "The prompt explicitly says registering a source only records candidates and nothing is resolved until selection, when warnings/conflicts surface.",
      "fairness": "Prompt-stated",
      "name": "registrationRecordsCandidatesWithoutReadingOrWarning",
      "qualityCheck": "Excellent direct test of deferred resolution for both successful and failing strategies.",
      "verifies": "Adding two eager own duplicate sources performs zero byte reads and emits no warnings; first lookup reads both sources, selects the last marker, and emits one warning. Under `error`, registration likewise performs zero reads/warnings, while resolution throws and causes reads from both origins."
    },
    {
      "evidence": "The prompt explicitly says cached probes and resolved selections belong to each decompiler context alone.",
      "fairness": "Prompt-stated",
      "name": "separateDecompilerContextsKeepIndependentStrategies",
      "qualityCheck": "Covers both strategy and cached-state isolation.",
      "verifies": "One context configured `first` keeps `contextFirst`, another configured `last` gets `contextLast`, and switching the thread-current context back does not alter the first context's winner."
    },
    {
      "evidence": "The prompt explicitly gives the default, exact accepted values, and requires an invalid option to be rejected before processing while identifying accepted values.",
      "fairness": "Prompt-stated",
      "name": "optionIsDocumentedDefaultedAndValidatedBeforeInputs",
      "qualityCheck": "The test name says “documented,” but assertions only pin the stated default and validation semantics. Message checks are not brittle.",
      "verifies": "`IFernflowerPreferences.DEFAULTS` maps the option to exact string `first`; constructing `Fernflower` with `middle` throws before any input and the message contains all three accepted values `first`, `last`, and `error`."
    },
    {
      "evidence": "The prompt applies selection to lazy libraries and explicitly says adding a source invalidates affected class decisions.",
      "fairness": "Prompt-stated",
      "name": "addingLazySourceInvalidatesCachedPositiveSelection",
      "qualityCheck": "Focused positive-cache invalidation test.",
      "verifies": "A cached lazy-library winner initially has `initialLazyWinner`; after registering a later lazy source under `last`, lookup changes to `laterLazyWinner`."
    },
    {
      "evidence": "The prompt explicitly says anonymous families are determined from `EnclosingMethod`, exact own duplicates activate coherence, and an available selected family root anchors the family.",
      "fairness": "Prompt-stated",
      "name": "anonymousClassUsesEnclosingMethodFamilyMetadata",
      "qualityCheck": "The same-name assertion is a fixture integrity check relying on deterministic javac naming for identical source structure; the product assertion remains metadata-based and generic.",
      "verifies": "Two structurally matching compilations produce the same anonymous binary name, and when an earlier anonymous-only candidate competes with a later complete family, resolution uses the complete family's `anchoredAnonymous` member because its available root anchors the family."
    },
    {
      "evidence": "The prompt explicitly says an `error` conflict identifies every conflicting highest-tier origin.",
      "fairness": "Prompt-stated",
      "name": "errorReportsEveryConflictingHighestTierOrigin",
      "qualityCheck": "Minimal but exact semantic coverage.",
      "verifies": "An `error` conflict among three differing own origins throws and the message contains `error-a`, `error-b`, and `error-c`."
    },
    {
      "evidence": "The prompt says state and resolved selections belong to the decompiler context alone; strategy selection therefore cannot leak from the currently active other context.",
      "fairness": "Prompt-stated",
      "name": "delayedLookupUsesItsOwningDecompilerContextStrategy",
      "qualityCheck": "Good delayed-resolution isolation case.",
      "verifies": "After another context resolves with `last`, a previously configured but unresolved `first` context still resolves its duplicate to `delayedFirst`."
    },
    {
      "evidence": "The prompt says negative lazy probes are cached, adding a source invalidates affected class decisions, and source-specific state remains in the context. Its separate statement that reload discards lazy probes makes preserving the old source's cached miss while probing the new source predictable.",
      "fairness": "Prompt-stated",
      "name": "addingLazySourceInvalidatesCachedNegativeProbe",
      "qualityCheck": "The exact one-read counts usefully ensure decision invalidation does not unnecessarily erase unrelated source-probe cache entries.",
      "verifies": "An initial lazy miss is false; after adding a lazy source containing the class, lookup returns `addedAfterMiss`; the old absent source and new source are each read exactly once."
    },
    {
      "evidence": "The prompt explicitly requires differing-resolution warnings to identify binary name, strategy, selected/ignored origins, and metadata family root; it also says the available root's selected origin anchors members.",
      "fairness": "Prompt-stated",
      "name": "familyWarningIdentifiesMetadataRootAndAnchoredSelection",
      "qualityCheck": "Careful root-vs-member check avoids passing merely because the member name contains the root prefix.",
      "verifies": "A duplicated member resolves to `anchoredMember`; a warning mentioning that member exists and contains anchored origin `root-and-member`, ignored origin `member-only-later`, strategy `last`, and the separate metadata root `family/Outer`."
    },
    {
      "evidence": "The prompt explicitly says that when the family root is unavailable, the strategy-selected duplicate anchors the family, and an encountered member available only elsewhere must fail with member and origin information.",
      "fairness": "Prompt-stated",
      "name": "unavailableFamilyRootUsesDuplicateToAnchorLaterMembers",
      "qualityCheck": "Directly exercises the no-root fallback.",
      "verifies": "With no root class available, `first` anchors the family on the first duplicate member; resolving a sibling available only from the later origin throws and names that sibling plus both member origins."
    },
    {
      "evidence": "The prompt explicitly requires transitive family determination from `InnerClasses` and detailed family-conflict reporting.",
      "fairness": "Prompt-stated",
      "name": "nestedMemberFamiliesAreResolvedTransitively",
      "qualityCheck": "The replacement check correctly proves the root is independently identified.",
      "verifies": "A nested family conflict throws; after removing the leaf name from the message, the message still contains root `family/DeepOuter`, and it also contains leaf `family/DeepOuter$Middle$Leaf` plus both anchored and alternative origins."
    },
    {
      "evidence": "The prompt explicitly lists those required warning fields and one warning per decision.",
      "fairness": "Prompt-stated",
      "name": "firstWarningContainsAllSemanticFields",
      "qualityCheck": "Fair and non-brittle, though partly redundant with the broader warning-order test.",
      "verifies": "A differing `first` decision emits exactly one warning containing the duplicate name, strategy `first`, selected origin `warn-first-a`, and ignored origin `warn-first-b`."
    },
    {
      "evidence": "The prompt limits `first`/`last` warnings to differing candidates and states byte-identical candidates are allowed. Thus only the independently differing sibling requires a warning.",
      "fairness": "Prompt-stated",
      "name": "identicalDuplicatesDoNotWarnForFirstOrLast",
      "qualityCheck": "Good negative warning test; exact count catches accidental warnings for identical bytes.",
      "verifies": "For each of `first` and `last`, an identical duplicate still loads `identicalMarker`; with a second differing binary name present, exactly one warning is emitted and it names only the differing decision under test."
    },
    {
      "evidence": "The prompt says adding a source invalidates affected class decisions and `error` rejects differing highest-tier bytes while identifying all conflicting origins.",
      "fairness": "Prompt-stated",
      "name": "addingSourceInvalidatesPositiveErrorDecision",
      "qualityCheck": "Covers transition from a successful cached decision to conflict.",
      "verifies": "An `error` context first caches a lone lazy candidate successfully; adding a differing lazy candidate makes the next lookup throw and the message contains both the cached and added origin names."
    },
    {
      "evidence": "The prompt says a conflict exists when exact bytes differ and that an `error` conflict identifies every conflicting highest-tier origin; all three origins participate in the conflicting candidate set.",
      "fairness": "Prompt-stated",
      "name": "mixedConflictReportsAllHighestTierOrigins",
      "qualityCheck": "Useful mixed equivalence-class case.",
      "verifies": "With candidates A and C byte-identical to each other but B different, `error` throws and names all three highest-tier origins."
    },
    {
      "evidence": "The prompt says warnings are triggered for differing candidate sets and must identify ignored origins in registration order; it does not exclude byte-identical losing origins from that ignored-origin list.",
      "fairness": "Prompt-stated",
      "name": "mixedWarningListsAllIgnoredOriginsInStableOrder",
      "qualityCheck": "Precisely tests ordering without pinning full message syntax.",
      "verifies": "A `first` decision with one identical loser and one differing loser emits exactly one warning, and the warning lists the identical loser before the differing loser in registration order."
    },
    {
      "evidence": "The prompt explicitly defines conflict using exact classfile-byte equality, not semantic class equivalence.",
      "fairness": "Prompt-stated",
      "name": "exactByteDifferencesTriggerError",
      "qualityCheck": "Strong discriminator against parsed/semantic comparison.",
      "verifies": "Changing only one classfile version byte causes `error` resolution to throw and name both origins."
    },
    {
      "evidence": "The prompt explicitly says each registered context source is a distinct origin even when two sources share a human-readable name.",
      "fairness": "Prompt-stated",
      "name": "sameNamedSourcesRemainDistinctOrigins",
      "qualityCheck": "Good identity-vs-name regression test. It avoids requiring an impossible textual distinction between equal display names in the error.",
      "verifies": "Two own source instances sharing the same human-readable name remain distinct: under `last`, exactly one own class is returned with the later marker and is saved only through the later sink; under `error`, their differing bytes still throw and the message contains the duplicate name."
    },
    {
      "evidence": "The prompt explicitly applies the same name selection to eager libraries and specifies strategy, warning, and error-origin semantics.",
      "fairness": "Prompt-stated",
      "name": "eagerLibraryDuplicatesUseEveryStrategy",
      "qualityCheck": "Complete strategy coverage for eager libraries; warning checks are semantic.",
      "verifies": "For eager-library duplicates, `first` loads `eagerAlpha` and emits one warning containing name, strategy, selected and ignored origins; `last` analogously loads `eagerBeta` with all warning fields; `error` throws and names both eager origins."
    },
    {
      "evidence": "The prompt applies selection to lazy libraries, requires one warning per decision with those fields, and says selections are cached.",
      "fairness": "Prompt-stated",
      "name": "lazyLibraryDuplicatesWarnWithSemanticFields",
      "qualityCheck": "Good lazy warning and deduplication coverage.",
      "verifies": "For two differing lazy libraries under `last`, lookup returns `lazyBeta`, emits exactly one warning containing binary name, `last`, and both origin names, and a repeated lookup does not add another warning."
    },
    {
      "evidence": "The prompt explicitly says ordering uses root registration order and child-context list order; composing those orders gives the asserted first and last eligible origins.",
      "fairness": "Prompt-stated",
      "name": "rootRegistrationAndChildListOrderComposeLexicographically",
      "qualityCheck": "Important ordering disambiguation and fully deterministic.",
      "verifies": "For a first root with two children followed by a second root, `first` chooses the first child of the first root, while `last` chooses the second root rather than the last child of the first root."
    },
    {
      "evidence": "The prompt says an unavailable root makes the strategy-selected duplicate the anchor, later members load from that origin, and warnings identify origins and metadata family root.",
      "fairness": "Prompt-stated",
      "name": "unavailableRootLastAnchorsStrategySelectedDuplicate",
      "qualityCheck": "Covers successful no-root anchoring, complementing the failing `first` case.",
      "verifies": "With no family root available, `last` returns exactly two classes and selects both sibling members from the later origin; the warning for the duplicated first sibling contains both origin names and independently identifies metadata root `family/Siblings`."
    },
    {
      "evidence": "The prompt explicitly requires family failure to identify the anchored origin and alternative origins.",
      "fairness": "Prompt-stated",
      "name": "familyConflictReportsEveryAlternativeOrigin",
      "qualityCheck": "Good completeness check using broad substrings.",
      "verifies": "A family-coherence failure throws and its message names the anchor origin and all three alternative origins that offer the unavailable anchored member."
    },
    {
      "evidence": "The prompt explicitly says the same name selection applies to eager or lazy libraries and error reports every conflicting highest-tier origin.",
      "fairness": "Prompt-stated",
      "name": "errorCombinesEagerAndLazyLibraryCandidates",
      "qualityCheck": "Covers a meaningful cross-mode integration case.",
      "verifies": "Under `error`, one eager and one lazy differing library candidate are combined into one conflict whose message names both origins."
    },
    {
      "evidence": "The prompt says an exact binary-name duplicate among own sources activates coherence, without requiring differing bytes; identical candidates use the first eligible origin, and unavailable anchored members must fail.",
      "fairness": "Prompt-stated",
      "name": "byteIdenticalRootDuplicateStillActivatesFamilyCoherence",
      "qualityCheck": "Excellent distinction between conflict-byte semantics and coherence activation.",
      "verifies": "Two byte-identical own root candidates still activate family coherence; because the first selected root origin lacks the member, resolution throws and names the member plus both origins."
    },
    {
      "evidence": "The prompt explicitly says repeated entries from one origin are not an inter-origin conflict and metadata linkage alone does not combine origins without an exact inter-origin duplicate.",
      "fairness": "Prompt-stated",
      "name": "repeatedEntriesFromOneOriginDoNotActivateFamilyCoherence",
      "qualityCheck": "Directly guards against counting entries instead of origins.",
      "verifies": "A root repeated twice within one origin plus a metadata-linked member in another origin returns exactly two classes with the expected per-origin markers and emits no warning."
    },
    {
      "evidence": "The prompt explicitly requires root anchoring and says reload discards prior duplicate/family resolution before rebuilding inputs.",
      "fairness": "Prompt-stated",
      "name": "reloadRebuildsFamilyAnchoring",
      "qualityCheck": "Strong mutation test proving family graph and anchor are rebuilt, not merely class bytes.",
      "verifies": "Initially, a member duplicate plus a root available only in the later origin resolves both root/member to later markers; after adding the root to the earlier source and reloading, both resolve to the earlier markers under `first`."
    },
    {
      "evidence": "The prompt explicitly says positive lazy probes and selections are cached and reload discards both kinds of results.",
      "fairness": "Prompt-stated",
      "name": "reloadDiscardsPositiveLazyProbeResults",
      "qualityCheck": "Focused complement to the negative-probe reload test.",
      "verifies": "A cached `last` lazy winner remains on `beforePositiveLazyReload` after mutation, but after reload it resolves to `afterPositiveLazyReload`."
    },
    {
      "evidence": "The prompt specifically limits origin-coherence activation to exact duplicates among own sources and says metadata linkage alone does not combine origins.",
      "fairness": "Prompt-stated",
      "name": "libraryDuplicatesDoNotActivateOriginCoherence",
      "qualityCheck": "Important scope boundary between own inputs and libraries.",
      "verifies": "For library-only inputs under `last`, the duplicated root comes from the later root-only library while its member independently comes from the earlier complete library."
    },
    {
      "evidence": "The prompt says adding a source invalidates affected decisions and requires one warning per decision. The post-add selection is a new decision, so a second warning is required.",
      "fairness": "Prompt-stated",
      "name": "invalidatedSelectionEmitsANewWarningForTheNewDecision",
      "qualityCheck": "Correctly distinguishes warning deduplication within a decision from suppression across invalidation.",
      "verifies": "The initial `last` decision selects B and emits one warning; adding C makes the next lookup select C, increases total warnings to exactly two, and the new warning names C."
    },
    {
      "evidence": "The prompt explicitly limits the option to exactly those three values and requires invalid options to be rejected before processing with accepted values identified.",
      "fairness": "Prompt-stated",
      "name": "invalidOptionNearMissesAreRejected",
      "qualityCheck": "Useful exact-token validation; broad exception and substring checks are robust.",
      "verifies": "Each invalid value `firstly` and `error!` causes `Fernflower` construction to throw, and each error message contains all accepted values `first`, `last`, and `error`."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Dockerfile guidelines**

Status: WARNING

warning: version_pinning — The Dockerfile itself does not explicitly pin versions for tools or for project dependencies; the network-download operations are performed by the Gradle wrapper and Gradle dependency resolution. To ensure reproducible builds you must verify that the repository includes a pinned gradle-wrapper.properties (distributionUrl with a specific Gradle version) and that dependencies are pinned/locked (Gradle dependency locking or pinned versions in build files and a committed lockfile such as gradle.lockfile). The lines in this Dockerfile that will trigger network downloads and should be confirmed as pinned are shown below so you can verify/add pins in the repository:

RUN ./gradlew --no-daemon --version

RUN printf '%s\n' \
    'gradle.beforeProject { project ->' \
    '  project.tasks.register("cacheOfflineDependencies") {' \
    '    doLast {' \
    '      ["testRuntimeClasspath", "testFixturesRuntimeClasspath", "jacocoAgent", "jacocoAnt"].each { name ->' \
    '        try { project.configurations.named(name).get().files } catch (Exception ignore) { }' \
    '      }' \
    '    }' \
    '  }' \
    '}' > /tmp/cache-offline.init.gradle && \
    ./gradlew --no-daemon -I /tmp/cache-offline.init.gradle \
      testClasses cacheOfflineDependencies && \
    rm -f /tmp/cache-offline.init.gradle && \
    rm -f /opt/gradle-cache/jdks/*.tar.gz /opt/gradle-cache/jdks/*.tar.gz.lock

If the repository already commits a pinned gradle-wrapper.properties and uses dependency locking/locked versions, then no further action is necessary. If not, add/commit pinned wrapper/distributions and a lockfile so builds are reproducible.

Note: Internet access is available during `docker build`, but not when running the container. Test patch is injected into the container after build. Ensure your Dockerfile installs all dependencies at build time so the environment works fully offline after build.

```json
{
  "all_issues": "warning: version_pinning — The Dockerfile itself does not explicitly pin versions for tools or for project dependencies; the network-download operations are performed by the Gradle wrapper and Gradle dependency resolution. To ensure reproducible builds you must verify that the repository includes a pinned gradle-wrapper.properties (distributionUrl with a specific Gradle version) and that dependencies are pinned/locked (Gradle dependency locking or pinned versions in build files and a committed lockfile such as gradle.lockfile). The lines in this Dockerfile that will trigger network downloads and should be confirmed as pinned are shown below so you can verify/add pins in the repository:\n\nRUN ./gradlew --no-daemon --version\n\nRUN printf '%s\\n' \\\n    'gradle.beforeProject { project ->' \\\n    '  project.tasks.register(\"cacheOfflineDependencies\") {' \\\n    '    doLast {' \\\n    '      [\"testRuntimeClasspath\", \"testFixturesRuntimeClasspath\", \"jacocoAgent\", \"jacocoAnt\"].each { name ->' \\\n    '        try { project.configurations.named(name).get().files } catch (Exception ignore) { }' \\\n    '      }' \\\n    '    }' \\\n    '  }' \\\n    '}' > /tmp/cache-offline.init.gradle && \\\n    ./gradlew --no-daemon -I /tmp/cache-offline.init.gradle \\\n      testClasses cacheOfflineDependencies && \\\n    rm -f /tmp/cache-offline.init.gradle && \\\n    rm -f /opt/gradle-cache/jdks/*.tar.gz /opt/gradle-cache/jdks/*.tar.gz.lock\n\nIf the repository already commits a pinned gradle-wrapper.properties and uses dependency locking/locked versions, then no further action is necessary. If not, add/commit pinned wrapper/distributions and a lockfile so builds are reproducible.",
  "base_image_compliant": {
    "explanation": "OK — Dockerfile starts FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest, which is one of the accepted Olympus base images for JVM projects.",
    "status": "OK"
  },
  "dependencies_installed": {
    "explanation": "OK — The Dockerfile invokes the Gradle wrapper to populate cached dependencies (./gradlew ... testClasses cacheOfflineDependencies), which installs/fetches the project's JVM dependencies into the image cache. This satisfies the expectation to install application dependencies.",
    "status": "OK"
  },
  "interactive_shell": {
    "explanation": "OK — Dockerfile ends with CMD [\"/bin/bash\"], providing an interactive shell for developers.",
    "status": "OK"
  },
  "no_test_execution": {
    "explanation": "OK — The Dockerfile does not run tests. It runs ./gradlew testClasses (compiles test sources) and a custom caching task, but does not run the test task (which would execute tests).",
    "status": "OK"
  },
  "package_manager_installation": {
    "explanation": "OK — The Dockerfile does not install package managers that are already present in the chosen base image and does not run curl/wget installer scripts to install package managers.",
    "status": "OK"
  },
  "registry_compliant": {
    "explanation": "OK — Base image comes from an allowed public ECR registry (public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest).",
    "status": "OK"
  },
  "repository_setup": {
    "explanation": "OK — WORKDIR set to /app and the Dockerfile copies the repository with COPY . .. The Dockerfile does not attempt to git clone the repo. (Assumes the Dockerfile is placed at repo root as required by the workflow.)",
    "status": "OK"
  },
  "security_safety": {
    "explanation": "OK — I found no obfuscated or encoded commands, no external installer scripts (curl|wget) being executed, no hard-coded secrets, no docker.sock mounts, and no signs of malicious activity.",
    "status": "OK"
  },
  "user_creation_compatible": {
    "explanation": "OK — Dockerfile does not create any user/group. This is allowed by the rubric.",
    "status": "OK"
  },
  "version_pinning": {
    "explanation": "warning — The Dockerfile itself does not explicitly pin versions for tools or for project dependencies; the network-download operations are performed by the Gradle wrapper and Gradle dependency resolution. To ensure reproducible builds you must verify that the repository includes a pinned gradle-wrapper.properties (distributionUrl with a specific Gradle version) and that dependencies are pinned/locked (Gradle dependency locking or pinned versions in build files and a committed lockfile such as gradle.lockfile). The lines in this Dockerfile that will trigger network downloads and should be confirmed as pinned are shown below so you can verify/add pins in the repository:\n\nRUN ./gradlew --no-daemon --version\n\nRUN printf '%s\\n' \\\n    'gradle.beforeProject { project ->' \\\n    '  project.tasks.register(\"cacheOfflineDependencies\") {' \\\n    '    doLast {' \\\n    '      [\"testRuntimeClasspath\", \"testFixturesRuntimeClasspath\", \"jacocoAgent\", \"jacocoAnt\"].each { name ->' \\\n    '        try { project.configurations.named(name).get().files } catch (Exception ignore) { }' \\\n    '      }' \\\n    '    }' \\\n    '  }' \\\n    '}' > /tmp/cache-offline.init.gradle && \\\n    ./gradlew --no-daemon -I /tmp/cache-offline.init.gradle \\\n      testClasses cacheOfflineDependencies && \\\n    rm -f /tmp/cache-offline.init.gradle && \\\n    rm -f /opt/gradle-cache/jdks/*.tar.gz /opt/gradle-cache/jdks/*.tar.gz.lock\n\nIf the repository already commits a pinned gradle-wrapper.properties and uses dependency locking/locked versions, then no further action is necessary. If not, add/commit pinned wrapper/distributions and a lockfile so builds are reproducible.",
    "status": "warning"
  }
}
```

---

**Repository meets compliance requirements (500+ stars, permissive license, active maintenance)**

Status: WARNING

GitHub API rate limited. Repository compliance check could not be fully verified.

```json
{
  "error": "rate_limited",
  "owner": "vineflower",
  "repo": "vineflower"
}
```

---

**Shipd Bot Description Warnings**

> "visible in the log and honest in the output"

Drop this rhetorical sentence and go straight to the concrete requirements that follow. For example, start the paragraph with "For differing candidates resolved by `first` or `last`, emit one warning per decision..." The current wording is natural enough, but it doesn't add behavior beyond the specific warning/output rules in the next sentences.

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 2 suggestions total, both medium/low severity, so the appropriate verdict is minor_suggestions.",
  "suggestions": [
    {
      "priority": "medium",
      "quote": "The decision should be visible in the log and honest in the output.",
      "suggestion": "Remove this vague, meta statement; the next sentences already specify concrete logging and output requirements (warning contents, sink ownership) without the rhetorical preamble."
    },
    {
      "priority": "low",
      "quote": "Load later members from that origin.",
      "suggestion": "Remove — this is implied by the preceding sentences that anchor a family to a single origin and require family coherence. It repeats the same constraint without adding new edge cases or behavior."
    }
  ],
  "summary": "- [MEDIUM] Remove: \"The decision should be visible in the log and honest in the output.\" This is non-actionable filler; the following sentences already define exactly what to log (warning contents) and how outputs are routed (sink ownership).\n- [LOW] Remove: \"Load later members from that origin.\" This repeats what is already stated by the family anchoring/coherence rules (family stays on one origin and is anchored by the root or selected duplicate) and adds no new cases.",
  "verdict": "minor_suggestions"
}
```
