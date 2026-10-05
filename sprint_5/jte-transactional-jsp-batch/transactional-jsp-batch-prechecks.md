**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥40 messages, ≥200 LOC

This task numbers: Median files: 12, messages: 90, LOC: 1644

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "bc99e674d5f8b317c175b46b9d8d31389ede67235c867f43f104062d4c7dd1c0",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Implements incremental precompilation and artifact maintenance by persisting per-template dependencies and generated artifacts, reconciling and removing abandoned outputs, regenerating only stale templates, and restoring prior artifacts on failure. Exposes new TemplateEngine/TemplateLoader query and maintenance APIs and adds manifest/loader helpers (GeneratedArtifacts, PrecompiledDependencies) to drive cleanup and dependency queries.",
      "confidence": 0.97,
      "contentAuthoredAt": 1781446712446,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Modified surface: submission adds JspMigrationPlan, StaleJspMigrationPlanException, and extends JspToJteConverter and the Jasper parser/converter to support planning, dependency discovery, virtual resources, and transactional commit in jte-jsp-converter(-jakarta); candidate changes TemplateEngine, TemplateLoader/RuntimeTemplateLoader, and adds compiler/runtime classes (GeneratedArtifacts, PrecompiledDependencies) for precompile artifact management.",
        "Behavioral change: submission computes dependency-ordered conversion for selected .tag files, rewrites usages in scanned JSP sources, exposes getWrites/getDeletes/getConversionOrder, and performs a one-shot transactional commit with staleness detection and rollback; candidate records and reconciles generated sources/classes/binary artifacts across runs, incrementally regenerates only stale templates, removes abandoned artifacts, and exposes query APIs like getStaleTemplates, getGeneratedArtifacts, getDependencies, and removeAbandonedArtifacts.",
        "Scope: submission validates inputs (relative .tag paths, root containment, symlink/regular-file checks, include constraints), detects cycles, and enforces destination collision/escape rules; candidate focuses on precompile lifecycle across processes with content-hash identities, dependency persistence, and runtime query of dependencies/artifacts without regenerating."
      ],
      "one_liner": "They implement different subsystems: one plans and transactionally commits a batch JSP-to-JTE tag migration; the other maintains and incrementally precompiles JTE artifacts with manifest-driven cleanup and queries.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Despite living in the same repository, the patches target unrelated features and layers. The submission introduces a new batch-migration planning/commit flow in the JSP converter modules with rollback semantics, while the candidate implements incremental precompilation and artifact maintenance in the runtime/compiler with persistence and query APIs. There is no purpose-matched surface or shared API/behavior beyond generic concepts like staleness and rollback, which are applied to different tasks and code paths.",
      "similarity": 0.49425041675567627,
      "submission_summary": "Adds a batch JSP-to-JTE migration planner to the JSP converter that computes dependency-ordered conversions, tracks intended file writes/deletes, snapshots source state, and provides a commit() that verifies staleness and atomically applies or rolls back all mutations. Extends the Jasper converter/parser to support virtual resources and discovery of custom-tag and include references, and adds a staleness exception type.",
      "title": "Precompiled Output Maintenance",
      "verdict": "distinct"
    },
    {
      "authorUsername": "legendaryfrog",
      "candidate_summary": "Integrates Cleaner with Parser/StreamParser to sanitize parsed documents and fragments, exposing CleaningResult with ordered CleaningEvent details and supporting BODY vs DOCUMENT scopes. Refactors Cleaner to delegate to a CleaningSession, adds exact Tag-based safelist configuration, attribute prefixes, and protocol rules, and preserves parser errors and output settings during cleaning.",
      "confidence": 0.97,
      "contentAuthoredAt": 1784948794923,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: jte JSP-to-JTE conversion versus jsoup HTML/XML sanitization and parsing.",
        "Submission adds JspMigrationPlan/planTags with filesystem snapshotting, staleness detection, dependency-ordered conversions, and transactional commit/rollback; candidate adds Cleaner.Scope, CleaningResult/Events, and Parser/StreamParser hooks to sanitize parsed documents and fragments.",
        "Submission modifies Jasper-based converter/parser (JtpConverter/JtpParser) to support virtual in-memory resources and reference discovery; candidate modifies jsoup Cleaner/Safelist to support exact Tag identities, attribute prefixes, and protocol rules, plus detailed event reporting.",
        "Submission’s observable behavior is a planned, immutable migration with getWrites/getDeletes and a single commit that either applies or rolls back; candidate’s behavior is returning a cleaned Document with an immutable ordered list of cleaning events and validity, without mutating the source."
      ],
      "one_liner": "One adds a transactional batch JSP-to-JTE migration planner/commit with dependency ordering and rollback in jte; the other integrates a namespace-aware sanitizer with jsoup parsers and exposes structured cleaning results and events.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "The patches target unrelated projects and surfaces for different purposes. The jte change introduces a batch migration planning API and transactional commit across the JSP/JTE converter stack, while the jsoup change wires a sanitizer into parsers and adds rich reporting and configuration in the cleaning layer. There are no purpose-matched modified files, APIs, or behaviors; any similarities (e.g., immutability or non-mutating planning/cleaning) are generic and not shared surfaces.",
      "similarity": 0.47962701320648193,
      "submission_summary": "Adds JspMigrationPlan and planTags to the JSP-to-JTE converter to plan multi-tag migrations with dependency ordering, virtualized includes, and an immutable set of writes/deletes, plus a commit that checks for staleness and performs transactional writes with full rollback. Extends JtpConverter/JtpParser to expose custom-tag/include references and to support virtual resource overlays used during planning.",
      "title": "Integrate namespace-aware cleaning with parsers",
      "verdict": "distinct"
    },
    {
      "authorUsername": "yenwee0804",
      "candidate_summary": "Extends OpenRewrite’s Java parsers, visitors, printers, RPC, and tree model to support JPMS module declarations in module-info.java, including directives (requires/exports/opens/uses/provides) and their modifiers, with lossless formatting preservation across Java 11/17/21/25 while keeping Java 8 unchanged.",
      "confidence": 0.98,
      "contentAuthoredAt": 1784860408056,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: JSP-to-JTE migration planning/commit logic in jte vs. JPMS module parsing/printing and tree additions in openrewrite.",
        "Submission modifies converter and parser internals to plan and transactionally commit filesystem writes with rollback; candidate modifies Java AST types, visitors, printers, and RPC to support module declarations.",
        "Submission’s behavior focuses on dependency discovery among JSP tags/includes and rewrite of usages; candidate’s behavior focuses on lossless parsing/printing and visitor traversal of module directives across multiple Java versions."
      ],
      "one_liner": "One adds a transactional, dependency-ordered batch migration plan for converting JSP tags to JTE templates; the other adds full JPMS module (module-info.java) parsing, traversal, and printing support to a Java AST framework.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "There is no purpose-matched surface or behavior overlap. The submission adds batch planning and transactional commit for JSP-to-JTE conversion within the jte converters, while the candidate teaches how to extend a Java parsing/printing framework to handle module-info.java. Different repos, files, and observable behaviors make these unrelated tasks.",
      "similarity": 0.478213369846344,
      "submission_summary": "Introduces JspMigrationPlan and StaleJspMigrationPlanException and extends JspToJteConverter/JtpConverter/JtpParser to plan a dependency-ordered batch conversion of selected .tag files, simulate rewrites, and transactionally commit filesystem mutations with staleness checks and rollback. It also supports virtual resource overlays for includes and rewrites JSP usages to JTE references across scanned files.",
      "title": "Parse, visit, and print Java module descriptors",
      "verdict": "distinct"
    },
    {
      "authorUsername": "sonikar",
      "candidate_summary": "Integrates a Cleaner into jsoup’s Parser to sanitize documents during parse, producing a per-document CleaningReport of actions and errors. Extends Cleaner and Safelist to support live cleaning callbacks, tag replacement, namespace-aware exact-tag policies and protocol rules, and exposes new public reporting types.",
      "confidence": 0.97,
      "contentAuthoredAt": 1785234271387,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": false,
      "meaningful_differences": [
        "Different repositories and domains: a JSP-to-JTE converter in casid/jte vs. HTML parsing and cleaning in jhy/jsoup.",
        "Submission introduces a JspMigrationPlan with staleness detection, dependency ordering of JSP tag conversions, virtual resource overlays for parsing includes, and transactional commit with rollback; candidate integrates a Cleaner into Parser/TreeBuilder, adds CleaningReport/CleaningError, and extends Safelist with namespace-aware policies and tag replacement.",
        "Submission modifies converter and Jasper parser internals to support planning and virtual resources; candidate modifies jsoup’s Document, NodeInternals, Parser, TreeBuilder, Cleaner, and Safelist to enable live cleaning during parse, reporting, and qualified tag policy APIs.",
        "Submission’s observable behavior is planning-only until commit (no FS mutation until commit) with rollback-on-failure semantics; candidate’s behavior is immediate sanitization during parse with unwrapping/replacement and per-document cleaning reports."
      ],
      "one_liner": "One adds a transactional, dependency-ordered JSP-to-JTE batch migration planner with commit/rollback; the other integrates a namespace-aware safelist Cleaner into jsoup’s Parser with live sanitization, tag replacement, and auditing reports.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "The patches target unrelated codebases and implement different features at different layers. The submission adds batch migration planning and transactional commit/rollback to a JSP→JTE converter, including dependency discovery and staleness checks. The candidate integrates jsoup’s Cleaner into parsing with live sanitization, detailed reporting, and namespace-aware safelist APIs. There is no shared modified surface, API, or observable behavior that would teach the same task.",
      "similarity": 0.48710066080093384,
      "submission_summary": "Adds a batch migration plan API to the JSP→JTE converter that discovers custom-tag dependencies and included files, orders conversions, predicts file writes/deletes, and performs a single transactional commit with staleness checks and full rollback on I/O failure. Extends the Jasper-based converter to expose custom-tag and include references and to parse over a virtual resource overlay.",
      "title": "Namespace-Aware Single-Pass Safelist Cleaning",
      "verdict": "distinct"
    }
  ],
  "reusedFromPriorRun": true
}
```

---

**Test Fairness**

Coverage Suggestions (2) - Not Blockers

Advisory only — these don't affect the check result.

Approved-include symlink containment
Add a test where the lexically in-root approved include is itself a symlink to a file outside JSP root, verifying rejection or otherwise proving resolved containment without touching the outside target.

Self-cycle reporting
Add a one-node self-cycle test to verify that the deterministic closed path repeats the same selected path and planning remains non-mutating.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Approved-include symlink containment",
      "suggestion": "Add a test where the lexically in-root approved include is itself a symlink to a file outside JSP root, verifying rejection or otherwise proving resolved containment without touching the outside target."
    },
    {
      "area": "Self-cycle reporting",
      "suggestion": "Add a one-node self-cycle test to verify that the deterministic closed path repeats the same selected path and planning remains non-mutating."
    }
  ],
  "error": "",
  "executionTimeSeconds": 359.372387,
  "message": "All hidden tests are fair.",
  "overall": "PASS. All hidden-test expectations are either directly stated in the unusually detailed prompt or, for exact legacy conversion strings and concrete naming collisions, produced by visible neighboring converter code. The tests are deterministic, use temporary directories, avoid brittle implementation-generated message matching, and generally assert public plan/commit behavior rather than internals. The custom failing filesystem is justified by the prompt's explicit rollback semantics and injects deterministic I/O failures. The javax suite is comprehensive; the Jakarta suite intentionally overlaps it to enforce the prompt-stated equivalence.",
  "taskSummary": "Implement transactional batch planning and one-shot commit for JSP tag migration in both javax and Jakarta artifacts. Planning must be filesystem-read-only; validate all selections and destinations; discover parsed custom-tag dependencies (including approved inlined includes but excluding comments/suppressions); order ready tags lexically; expose immutable normalized-absolute order/delete/write collections; preserve existing one-tag conversion, setup, and subclass-hook behavior against a virtual view; detect all content-based staleness before mutation; and commit atomically enough to restore exact prior bytes/absence and created directories after post-mutation I/O failure, suppressing rollback failures while rethrowing the original error.",
  "tests": [
    {
      "evidence": "The prompt states lexical ready ordering, immutable normalized-absolute plan data, exact write/delete membership, read-only planning, commit effects, and no temporary files. Exact emitted forms are discoverable in jte-jsp-converter/src/main/java/gg/jte/convert/jsp/converter/JspJteConverter.java:27-28 and JspToJteConverter.java:117-151.",
      "fairness": "Repo-discoverable",
      "name": "unorderedPlanIsReadOnlyInspectableAndDependencySafe",
      "qualityCheck": "Strong end-to-end test. It checks many co-assertions without relying on private internals.",
      "verifies": "The order is exactly independent, leaf, parent, root; deletes contain exactly those selected absolute normalized paths; write keys are exactly four generated .jte files plus page.jsp; generated parent/root content contains @template.my.leaf( and @template.my.parent(; page content contains <my:jte jte=\"my/root.jte\"; planning changes no files; commit removes selected tags, installs the expected content, preserves untouched.jsp, and leaves no transaction files."
    },
    {
      "evidence": "The prompt says affected .tag files are final writes while selected tags are deleted and not written. The exact usage replacement is produced by JspToJteConverter.java:117-151.",
      "fairness": "Repo-discoverable",
      "name": "nonSelectedTagUsagesAreFinalWrites",
      "qualityCheck": "Fair integration check of a nonselected .tag usage.",
      "verifies": "Deletes contain only leaf.tag; the unselected root.tag is a write containing <my:jte jte=\"my/leaf.jte\"; after commit leaf is deleted and root contains that replacement with no transaction files."
    },
    {
      "evidence": "The prompt explicitly says unchanged scanned files are not writes, every usage-scanned file is compared with the snapshot, changed paths are unique lexical normalized absolute paths, and staleness precedes all mutation.",
      "fairness": "Prompt-stated",
      "name": "unchangedUsageScannedFileIsCheckedForStaleness",
      "qualityCheck": "Direct and deterministic.",
      "verifies": "An unchanged scanned JSP is absent from writes, but changing its bytes after planning causes StaleJspMigrationPlanException with exactly that normalized absolute path and causes no planned mutation."
    },
    {
      "evidence": "The prompt explicitly rejects destinations whose path is already taken, including by a symbolic link, and says planning does not mutate the filesystem.",
      "fairness": "Prompt-stated",
      "name": "danglingDestinationIsRejectedDuringPlanning",
      "qualityCheck": "Good NOFOLLOW_LINKS edge case.",
      "verifies": "A dangling symlink occupying the generated destination causes IllegalArgumentException; the selected source remains and the symlink remains."
    },
    {
      "evidence": "The prompt requires every generated destination to still be absent before mutation and requires all changed normalized absolute paths in the stale exception.",
      "fairness": "Prompt-stated",
      "name": "danglingDestinationMakesPlanStaleAtCommit",
      "qualityCheck": "Good distinction between planning validation and commit staleness.",
      "verifies": "Creating a dangling destination symlink after planning causes StaleJspMigrationPlanException listing exactly the destination, with source and symlink untouched."
    },
    {
      "evidence": "The prompt says unresolved non-suppressed tags reject the whole plan. Existing one-tag behavior throws for unresolved JSP tags in JspToJteConverter.java:200-213, so an unselected tag is not silently auto-added.",
      "fairness": "Repo-discoverable",
      "name": "unselectedDependencyIsUnresolvedAndRejectsThePlan",
      "qualityCheck": "The RuntimeException assertion is broad rather than brittle.",
      "verifies": "Selecting only root.tag while it invokes existing but unselected leaf.tag throws a RuntimeException and leaves the full filesystem snapshot unchanged."
    },
    {
      "evidence": "The prompt requires content comparison of every usage-scanned file and no mutation on any stale result; absence differs from the planning snapshot.",
      "fairness": "Prompt-stated",
      "name": "deletedUsageScannedFileMakesPlanStale",
      "qualityCheck": "Good deletion-staleness case.",
      "verifies": "Deleting a usage-scanned file after planning yields a stale exception listing exactly that path and performs no source deletion or destination write."
    },
    {
      "evidence": "The prompt explicitly requires exact pre-commit bytes or absence after a post-mutation IOException, rethrow of the original failure, and no temporary files.",
      "fairness": "Prompt-stated",
      "name": "rollbackRestoresMalformedUtf8BytesExactly",
      "qualityCheck": "Deterministic fault injection; validates bytes rather than lossy decoded text.",
      "verifies": "After an injected IOException following mutation, the original IOException surfaces, malformed usage bytes are byte-for-byte restored, selected source exists, generated destination is absent, and no transaction files remain."
    },
    {
      "evidence": "The prompt explicitly says input order does not affect the plan and defines deterministic lexical ready selection.",
      "fairness": "Prompt-stated",
      "name": "inputOrderDoesNotChangeThePlan",
      "qualityCheck": "Clear determinism test.",
      "verifies": "Two permutations produce equal conversion-order lists, equal write maps, and equal delete collections."
    },
    {
      "evidence": "The prompt explicitly requires a repeatedly rewritten file to appear once with final content. Exact replacement syntax is produced by JspToJteConverter.java:117-151.",
      "fairness": "Repo-discoverable",
      "name": "multipleSelectedTagRewritesAccumulateInSingleFinalWrite",
      "qualityCheck": "Good virtual-state accumulation check.",
      "verifies": "Writes contain exactly a.jte, z.jte, and one usage JSP; that single usage value and committed file contain both exact replacements."
    },
    {
      "evidence": "The prompt explicitly says each step chooses the lexically first root-relative path whose dependencies are already converted.",
      "fairness": "Prompt-stated",
      "name": "mixedDependenciesUseLexicalReadyOrder",
      "qualityCheck": "Minimal, precise topological tie-break test.",
      "verifies": "For a depending on z and independent b, conversion order is exactly b, z, a."
    },
    {
      "evidence": "The prompt explicitly states these collections are immutable.",
      "fairness": "Prompt-stated",
      "name": "inspectedCollectionsAreImmutable",
      "qualityCheck": "Conventional and direct immutability assertions.",
      "verifies": "Clearing conversion order, clearing deletes, and putting into writes each throws UnsupportedOperationException."
    },
    {
      "evidence": "The prompt requires one final write per repeatedly rewritten file. Existing replacement code checks a delimiter after the exact tag prefix and separately replaces exact closing tags at JspToJteConverter.java:117-151.",
      "fairness": "Repo-discoverable",
      "name": "repeatedUsagesCollapseIntoOneFinalWrite",
      "qualityCheck": "Useful boundary check against prefix matching.",
      "verifies": "Write keys are exactly leaf.jte and usage.jsp.inc; the one usage value converts self-closing and body forms, while leaving <my:leafish/> unchanged."
    },
    {
      "evidence": "The dependency expectation is explicit in the prompt. Existing parser output preserves comments as <%--...--%> in org/apache/jasper/compiler/JtpConverter.java:221-229.",
      "fairness": "Repo-discoverable",
      "name": "commentsDoNotCreateDependenciesOrUnresolvedTags",
      "qualityCheck": "The preservation co-assertion is repository-backed, not merely inferred from dependency semantics.",
      "verifies": "Order is exactly a then z despite commented <my:z/>, and a.jte retains the exact JSP comment text."
    },
    {
      "evidence": "The prompt explicitly says comments do not create dependencies and that approved inlined includes participate in dependency discovery.",
      "fairness": "Prompt-stated",
      "name": "commentedInvocationInAnApprovedIncludeCreatesNoDependency",
      "qualityCheck": "Good composition of include and comment rules.",
      "verifies": "A commented z invocation in an approved include does not block a, yielding exactly a then z."
    },
    {
      "evidence": "The prompt requires dependencies from parsed invocations, which implies exact parsed names rather than substring matching. Exact JTE call syntax comes from JspJteConverter.java:27-28.",
      "fairness": "Repo-discoverable",
      "name": "realCustomTagDependencyIsNotConfusedWithLongerNames",
      "qualityCheck": "Good parser-vs-regex boundary test.",
      "verifies": "With root invoking foobar, order is exactly foo, foobar, root and root.jte contains @template.my.foobar(."
    },
    {
      "evidence": "The prompt explicitly requires deterministic closed cycle paths, input-order independence, whole-plan rejection, and read-only planning.",
      "fairness": "Prompt-stated",
      "name": "directCycleReportsAClosedDeterministicPathWithoutMutation",
      "qualityCheck": "Does not over-pin punctuation or an exact message template.",
      "verifies": "Both input orders throw RuntimeException with equal messages containing a.tag and b.tag; at least one path occurs more than once to close the cycle; filesystem snapshot is unchanged."
    },
    {
      "evidence": "The prompt explicitly requires a deterministic closed path for a cycle and no planning mutation.",
      "fairness": "Prompt-stated",
      "name": "longerCycleReportsAClosedDeterministicPathWithoutMutation",
      "qualityCheck": "Nontrivial extension of the direct-cycle test.",
      "verifies": "Both permutations throw RuntimeException with equal messages containing a.tag, b.tag, and z.tag; some path repeats to close the cycle; no file changes."
    },
    {
      "evidence": "The prompt explicitly says getChangedPaths lists all changed paths, each once, and no planned mutation occurs.",
      "fairness": "Prompt-stated",
      "name": "aFileStaleInBothSelectedAndScannedRolesIsReportedOnce",
      "qualityCheck": "Good deduplication assertion.",
      "verifies": "A changed selected tag that is also usage-scanned appears exactly once in normalized absolute changed paths and no mutation occurs."
    },
    {
      "evidence": "The prompt explicitly rejects unresolved non-suppressed tags. Existing behavior detects and throws UnsupportedOperationException for such forms at JspToJteConverter.java:200-213.",
      "fairness": "Repo-discoverable",
      "name": "unresolvedExternalTagRejectsTheWholePlan",
      "qualityCheck": "Broad exception check is appropriate.",
      "verifies": "A selected tag containing unresolved <my:external/> throws RuntimeException and leaves every file unchanged."
    },
    {
      "evidence": "The prompt says conversion failures reject the whole plan and planning does not change the filesystem.",
      "fairness": "Prompt-stated",
      "name": "conversionFailureAfterAnEarlierConversionLeavesEveryFileUntouched",
      "qualityCheck": "Good all-or-nothing planning check.",
      "verifies": "A later unresolved conversion causes RuntimeException; the original snapshot remains exact and jteRoot is not created despite an earlier convertible tag."
    },
    {
      "evidence": "The prompt says getNotConvertedTags applies to every selected tag. Existing implementation registers those tags as no-op converters at JspToJteConverter.java:71-75 and excludes them from unresolved errors at 205-212.",
      "fairness": "Repo-discoverable",
      "name": "explicitlyUnconvertedExternalTagMayRemain",
      "qualityCheck": "Checks the precise resulting content.",
      "verifies": "When getNotConvertedTags returns my:external, the generated a.jte string contains <my:external>."
    },
    {
      "evidence": "The prompt explicitly says suppressions apply to every selected tag and dependencies come from parsed invocations under those conversion rules.",
      "fairness": "Prompt-stated",
      "name": "suppressedCustomTagDoesNotCreateAnEdge",
      "qualityCheck": "Focused suppression/order test.",
      "verifies": "Suppressing CustomTag for a.tag makes the exact order a then z even though a contains <my:z/>."
    },
    {
      "evidence": "The prompt explicitly requires approved includes in dependency discovery, virtual earlier conversions, affected .jsp.inc writes, and read-only planning. Exact emitted strings come from JspJteConverter.java:27-28 and JspToJteConverter.java:117-151.",
      "fairness": "Repo-discoverable",
      "name": "approvedIncludeParticipatesInOrderingAndVirtualConversion",
      "qualityCheck": "Strong include integration test.",
      "verifies": "Order is leaf then root; root.jte sees @template.my.leaf(; fragment is a planned write with replacement content but remains unchanged on disk during planning."
    },
    {
      "evidence": "The prompt includes approved includes in dependency and snapshot checks, while limiting final usage writes to .jsp, .jsp.inc, and .tag files.",
      "fairness": "Prompt-stated",
      "name": "approvedNonScannedIncludeParticipatesInVirtualConversionAndStaleness",
      "qualityCheck": "Excellent distinction between included snapshots and writable scan extensions.",
      "verifies": "A .partial approved include orders leaf before root and affects root.jte, is not itself a write, but changing it makes the plan stale with exactly its path."
    },
    {
      "evidence": "The prompt explicitly rejects normalized duplicates, absolute paths, and paths outside the JSP root, all as IllegalArgumentException; planning is non-mutating.",
      "fairness": "Prompt-stated",
      "name": "normalizedDuplicateAndEscapingPathsAreRejectedBeforeParsing",
      "qualityCheck": "Direct validation test.",
      "verifies": "A normalized duplicate pair, ../ escape, and absolute selected path each throw IllegalArgumentException, with no filesystem changes."
    },
    {
      "evidence": "Every listed invalid category and its IllegalArgumentException semantics is explicitly enumerated in the prompt.",
      "fairness": "Prompt-stated",
      "name": "emptyMissingNonRegularAndNonTagInputsAreRejected",
      "qualityCheck": "Many independent assertions, all directly specified.",
      "verifies": "Null collection, empty collection, blank string, null element, missing .tag, directory .tag, and .jsp input each throw IllegalArgumentException."
    },
    {
      "evidence": "The prompt explicitly rejects selected symbolic links as IllegalArgumentException.",
      "fairness": "Prompt-stated",
      "name": "symbolicSelectedTagIsRejected",
      "qualityCheck": "Straightforward platform-dependent filesystem feature, stable on the benchmark's Linux environment.",
      "verifies": "Selecting a symbolic-link .tag throws IllegalArgumentException."
    },
    {
      "evidence": "The prompt explicitly rejects colliding and occupied destinations. The specific a-b→aB normalization follows JspToJteConverter.java:182-196 and CamelCaseConverter.java:5-18.",
      "fairness": "Repo-discoverable",
      "name": "normalizedOutputCollisionAndExistingDestinationAreRejected",
      "qualityCheck": "Precisely covers both intra-plan and preexisting collisions.",
      "verifies": "a-b.tag and aB.tag together throw IllegalArgumentException because their generated destinations collide; selecting a-b when owned aB.jte exists also throws and preserves content \"owned\"."
    },
    {
      "evidence": "The prompt explicitly rejects ambiguous selected invocation names. Existing invocation extraction uses the immediate parent as namespace and filename before the dot as name at JspToJteConverter.java:159-173, making both selections my:a.",
      "fairness": "Repo-discoverable",
      "name": "ambiguousSelectedInvocationNamesAreRejected",
      "qualityCheck": "Concrete ambiguity fixture is repository-grounded.",
      "verifies": "Selecting one/my/a.tag and two/my/a.tag throws IllegalArgumentException."
    },
    {
      "evidence": "The prompt explicitly rejects generated destinations outside the JTE root and says planning does not mutate files.",
      "fairness": "Prompt-stated",
      "name": "outputSuggestedOutsideTheJteRootIsRejected",
      "qualityCheck": "Also confirms the public/subclass destination hook remains authoritative.",
      "verifies": "A suggestJteFile override returning ../outside.jte causes IllegalArgumentException and does not create outside.jte."
    },
    {
      "evidence": "The prompt explicitly says an approved include resolves against the resource base, must resolve beneath the JSP root, and outside includes are IllegalArgumentException.",
      "fairness": "Prompt-stated",
      "name": "approvedIncludeOutsideTheJspRootIsRejected",
      "qualityCheck": "Direct containment test.",
      "verifies": "An approved /outside.jsp.inc resolving outside jspRoot causes IllegalArgumentException and no generated template."
    },
    {
      "evidence": "The prompt explicitly says setup applies to every selected tag, setup failure rejects the plan, and a setup-consumer failure surfaces unchanged rather than wrapped.",
      "fairness": "Prompt-stated",
      "name": "lateParserSetupFailureLeavesEveryFileUntouched",
      "qualityCheck": "Identity assertion correctly tests 'unchanged' exception propagation.",
      "verifies": "The exact sentinel IllegalStateException thrown on the second setup invocation is returned by identity, and the filesystem snapshot remains unchanged."
    },
    {
      "evidence": "The prompt explicitly says parse failures reject the whole plan and planning does not change the filesystem.",
      "fairness": "Prompt-stated",
      "name": "parseFailureLeavesEveryFileUntouched",
      "qualityCheck": "Broad exception type avoids parser-message coupling.",
      "verifies": "A malformed selected tag causes RuntimeException and leaves the complete filesystem snapshot unchanged."
    },
    {
      "evidence": "The prompt explicitly says timestamp equality does not make changed content current and staleness causes no planned mutation.",
      "fairness": "Prompt-stated",
      "name": "selectedContentChangeWithUnchangedTimestampMakesPlanStale",
      "qualityCheck": "Robust  content-vs-mtime test.",
      "verifies": "Changing selected bytes while restoring the original mtime produces the named stale exception with exactly the selected path; changed source remains and destination is absent."
    },
    {
      "evidence": "The prompt explicitly requires checking usage snapshots and destination absence, aggregating all changed normalized absolute paths once in lexical order before mutation.",
      "fairness": "Prompt-stated",
      "name": "changedScannedUsageAndNewDestinationAreBothReportedInOrder",
      "qualityCheck": "Good aggregation test.",
      "verifies": "Changed paths are exactly usage and destination in Path lexical order, normalized and absolute; source and concurrent destination content are untouched."
    },
    {
      "evidence": "The prompt explicitly includes every included file in commit snapshot comparison and forbids mutation on staleness.",
      "fairness": "Prompt-stated",
      "name": "changedApprovedIncludeMakesPlanStale",
      "qualityCheck": "Direct approved-include snapshot coverage.",
      "verifies": "Changing an approved include after planning reports exactly that path and leaves selected source and destination unchanged."
    },
    {
      "evidence": "The prompt explicitly requires all changed paths, unique and lexical, and verification before the first mutation.",
      "fairness": "Prompt-stated",
      "name": "everyStaleCategoryIsReportedTogetherInOneFailure",
      "qualityCheck": "Strong non-fail-fast staleness aggregation test.",
      "verifies": "A changed selected source, changed usage, and newly occupied destination are all reported together exactly once in sorted order, with concurrent bytes untouched."
    },
    {
      "evidence": "The prompt requires normalized absolute exposed paths and containment but does not force acceptance of dot segments; the test deliberately accepts either reasonable validation choice.",
      "fairness": "Prompt-stated",
      "name": "dottedSelectionIsEitherRejectedOrKeptInNormalizedForm",
      "qualityCheck": "Permissive rather than over-constraining.",
      "verifies": "The test accepts either IllegalArgumentException with source intact or a plan whose order/deletes use exactly the normalized selected path; if accepted, changing that source reports exactly it as stale."
    },
    {
      "evidence": "The prompt explicitly defines getWrites values as final UTF-8 content and requires committing every planned write.",
      "fairness": "Prompt-stated",
      "name": "committedBytesAreThePlannedContentEncodedAsUtf8",
      "qualityCheck": "Exact encoding assertion, not locale-dependent.",
      "verifies": "Both generated-template and usage planned strings retain é中ß, and every committed write's bytes equal its planned String encoded with UTF-8."
    },
    {
      "evidence": "The prompt says content is compared and specifically that timestamp equality does not mask content changes; therefore metadata-only timestamp changes are not stale.",
      "fairness": "Prompt-stated",
      "name": "aTimestampOnlyChangeLeavesThePlanCurrent",
      "qualityCheck": "Natural complement to same-timestamp changed-content test.",
      "verifies": "Changing only selected mtime permits commit, deletes source, and writes destination containing a."
    },
    {
      "evidence": "The prompt rejects destinations whose path is already taken, which includes a directory, and planning must not mutate.",
      "fairness": "Prompt-stated",
      "name": "existingDirectoryDestinationIsRejectedDuringPlanning",
      "qualityCheck": "Good occupied-path variant.",
      "verifies": "A directory occupying a.jte causes IllegalArgumentException; source remains and the destination remains a directory."
    },
    {
      "evidence": "The prompt requires exact pre-commit bytes or absence for every affected path after an IOException begins post-mutation and no temporary files.",
      "fairness": "Prompt-stated",
      "name": "rollbackRestoresASourceDeletedBeforeALaterDeleteFails",
      "qualityCheck": "Deterministic delete-phase rollback scenario.",
      "verifies": "Injected IOException during later mutation restores both selected tags to exact original bytes, leaves both destinations absent, and leaves no transaction files."
    },
    {
      "evidence": "The prompt explicitly says a successful plan commits only once and successful commits leave no temporary files.",
      "fairness": "Prompt-stated",
      "name": "successfulPlanCommitsOnlyOnce",
      "qualityCheck": "Does not over-specify second-call exception type or message.",
      "verifies": "After a successful commit, a second commit throws some non-null failure, leaves the complete committed snapshot unchanged, and leaves no transaction files."
    },
    {
      "evidence": "The prompt explicitly requires restoration of exact bytes/absence including created directories, rethrow of the original failure, and no temporary files.",
      "fairness": "Prompt-stated",
      "name": "ioFailureAfterAnInstalledWriteRestoresExactOriginalState",
      "qualityCheck": "Strong whole-tree rollback check.",
      "verifies": "Injected primary IOException surfaces with its original message; complete snapshot is restored, generated files and newly created jteRoot are absent, and no transaction files remain."
    },
    {
      "evidence": "The prompt explicitly requires rethrowing the original I/O failure and attaching restoration failures as suppressed exceptions. The pinned substrings are the deterministic messages emitted by the test filesystem itself.",
      "fairness": "Prompt-stated",
      "name": "rollbackFailureIsAttachedToTheOriginalIoFailure",
      "qualityCheck": "Tests exception chaining without coupling to implementation-generated wording.",
      "verifies": "The thrown exception is the original IOException containing \"Injected commit failure\", and a recursively collected suppressed exception message contains \"Injected rollback failure\"."
    },
    {
      "evidence": "The prompt explicitly preserves subclass hooks and applies setup to every conversion. Existing prefix behavior is at JtpConverter.java:88 and 106-107; readFile is a protected hook used at JspToJteConverter.java:47-53; exact nested call syntax is at JspJteConverter.java:27-28.",
      "fairness": "Repo-discoverable",
      "name": "readFileAndParserSetupHooksApplyToEveryConversion",
      "qualityCheck": "Good compatibility test against extension points.",
      "verifies": "leaf.jte starts with the setup prefix and contains subclass read override text; root.jte also starts with that prefix and contains @template.my.leaf(."
    },
    {
      "evidence": "The prompt explicitly says each generated template uses the same parser setup and per-tag conversion rules as existing one-tag conversion.",
      "fairness": "Prompt-stated",
      "name": "plannedTemplateMatchesOneTagConversionForAStatefulSetupConverter",
      "qualityCheck": "Exact behavioral parity test; fresh counters avoid accidental cross-run state.",
      "verifies": "The planned root.jte String exactly equals the UTF-8 content produced by existing convertTag with a fresh equivalent stateful setup."
    },
    {
      "evidence": "The prompt explicitly says conversion failures reject the whole plan and planning does not mutate the filesystem.",
      "fairness": "Prompt-stated",
      "name": "aConverterCallbackFailureRejectsThePlanWithoutMutation",
      "qualityCheck": "Broad enough to permit unchanged or wrapped conversion errors, as the prompt only singles out setup failures for unchanged propagation.",
      "verifies": "A registered custom converter throwing IllegalStateException causes a RuntimeException plan failure and leaves the entire snapshot unchanged."
    },
    {
      "evidence": "The prompt explicitly requires resolved approved include paths to remain beneath the JSP root and makes outside includes IllegalArgumentException.",
      "fairness": "Prompt-stated",
      "name": "approvedIncludeEscapingTheJspRootByTraversalIsRejected",
      "qualityCheck": "Important normalized-containment variant.",
      "verifies": "An approved /WEB-INF/../outside.jsp.inc causes IllegalArgumentException and leaves the full snapshot unchanged."
    },
    {
      "evidence": "The prompt limits affected writes to files under the JSP root and says unrelated paths remain untouched. The test deliberately accepts either safe policy for the symlink itself.",
      "fairness": "Prompt-stated",
      "name": "CommitDoesNotWriteThroughAUsageSymlinkLeavingTheJspRoot",
      "qualityCheck": "Security-oriented and permissive; symlink support is platform-dependent but stable in the stated Linux runner.",
      "verifies": "The implementation may reject planning or skip the linked usage, but if it plans, writes must not use the outside target key; in every case outside.jsp bytes remain exact after optional commit."
    },
    {
      "evidence": "The prompt explicitly says unchanged scanned files are not writes and unrelated/unchanged paths remain untouched.",
      "fairness": "Prompt-stated",
      "name": "UnchangedScannedFileWithMalformedBytesIsNotAWrite",
      "qualityCheck": "Good guard against decode-and-rewrite damage.",
      "verifies": "A malformed-byte unchanged JSP is absent from writes, and after commit its bytes are exactly unchanged."
    },
    {
      "evidence": "The prompt explicitly requires javax/Jakarta equivalence and all batch effects. The exact emitted forms are mirrored in the Jakarta JspJteConverter and JspToJteConverter at the same lines as javax (27-28 and 117-151).",
      "fairness": "Repo-discoverable",
      "name": "jakartaArtifactPlansAndCommitsTheSameBatchBehavior",
      "qualityCheck": "Appropriate artifact-parity smoke test.",
      "verifies": "Jakarta order is exactly leaf, parent, root; generated parent/root strings contain the corresponding @template calls; planning leaves source/destination untouched; commit deletes all selected tags, rewrites usage with the exact JTE tag form, and leaves no transaction files."
    },
    {
      "evidence": "The prompt explicitly requires Jakarta equivalence, approved-include dependency discovery, virtual earlier conversions, and read-only planning. Exact call syntax is repository-defined by JspJteConverter.java:27-28.",
      "fairness": "Repo-discoverable",
      "name": "jakartaArtifactUsesVirtualIncludedContent",
      "qualityCheck": "Focused parity coverage for includes.",
      "verifies": "Jakarta order is leaf then root; root.jte contains @template.my.leaf(; planning leaves the included fragment's on-disk <my:leaf text unchanged."
    },
    {
      "evidence": "The prompt explicitly says JSP comments do not create dependencies and artifacts are equivalent.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactIgnoresTagTextInComments",
      "qualityCheck": "Direct parity assertion.",
      "verifies": "Jakarta order is exactly a then z when a's only z text is in a JSP comment."
    },
    {
      "evidence": "The prompt explicitly combines comment exclusion, approved-include discovery, and artifact equivalence.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactIgnoresCommentedInvocationsInsideApprovedIncludes",
      "qualityCheck": "Direct and non-brittle.",
      "verifies": "Jakarta order is exactly a then z despite a commented z invocation in an approved include."
    },
    {
      "evidence": "The prompt explicitly applies setup to every selected tag, propagates setup-consumer failures unchanged, and forbids planning mutation in both artifacts.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactSurfacesALateParserSetupFailureUnchanged",
      "qualityCheck": "Strong parity test for exception identity.",
      "verifies": "The exact second-invocation sentinel is surfaced by identity and the filesystem snapshot is unchanged."
    },
    {
      "evidence": "The prompt explicitly requires generated templates to match existing per-tag setup/conversion rules and both artifacts to be equivalent.",
      "fairness": "Prompt-stated",
      "name": "jakartaPlannedTemplateMatchesOneTagConversionForAStatefulSetupConverter",
      "qualityCheck": "Exact public-behavior parity.",
      "verifies": "Jakarta planned root template exactly equals existing one-tag conversion output under a fresh equivalent stateful setup."
    },
    {
      "evidence": "The prompt confines writes to files under JSP root, preserves unrelated paths, and requires Jakarta equivalence.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactCommitDoesNotWriteThroughAUsageSymlinkLeavingTheJspRoot",
      "qualityCheck": "Permissive safe-outcome test.",
      "verifies": "Planning may reject or safely skip the usage symlink, but it must not plan the outside target and outside bytes must remain exact after optional commit."
    },
    {
      "evidence": "The prompt explicitly excludes unchanged scanned files from writes and preserves unrelated paths in both artifacts.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactUnchangedScannedFileWithMalformedBytesIsNotAWrite",
      "qualityCheck": "Good byte-preservation parity check.",
      "verifies": "The malformed unchanged JSP is not a write and retains exact bytes after Jakarta commit."
    },
    {
      "evidence": "The prompt explicitly requires content-based staleness regardless of timestamp and no mutation.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactDetectsSameTimestampContentChanges",
      "qualityCheck": "Direct.",
      "verifies": "Changed selected bytes with restored mtime cause the named stale exception; changed paths contain exactly selected; destination remains absent."
    },
    {
      "evidence": "Every invalid category and IllegalArgumentException semantic is explicitly listed in the prompt, along with non-mutating planning.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRejectsInvalidSelectionsWithoutMutation",
      "qualityCheck": "Dense but all co-assertions are specified.",
      "verifies": "Null input, normalized duplicate, outside path, absolute path, directory, non-.tag path, missing path, blank path, null element, and empty collection each throw IllegalArgumentException; the complete snapshot remains unchanged."
    },
    {
      "evidence": "The prompt explicitly snapshots every usage-scanned file, including unchanged ones, and prevents mutation on staleness.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactChecksUnchangedScannedFilesForStaleness",
      "qualityCheck": "Direct parity check.",
      "verifies": "Changing an otherwise unchanged scanned JSP causes the named stale exception with exactly that path; source remains and destination is absent."
    },
    {
      "evidence": "The prompt explicitly rejects any already-taken destination and says planning does not mutate.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRejectsExistingDestinationDuringPlanning",
      "qualityCheck": "Simple and deterministic.",
      "verifies": "An existing generated destination causes IllegalArgumentException, preserves content \"owned\", and leaves source present."
    },
    {
      "evidence": "The prompt explicitly requires deterministic cycle reporting, unresolved-tag rejection, and no mutation. Existing unresolved behavior is RuntimeException via UnsupportedOperationException at JspToJteConverter.java:200-213.",
      "fairness": "Repo-discoverable",
      "name": "jakartaArtifactRejectsCyclesAndUnresolvedTagsWithoutMutation",
      "qualityCheck": "Cycle test is somewhat shallower than javax because it does not assert a repeated closing node, but remains fair.",
      "verifies": "A cycle throws RuntimeException with input-order-independent message containing both paths; an unresolved external tag also throws RuntimeException; the full snapshot remains unchanged."
    },
    {
      "evidence": "The prompt explicitly defines lexical ready order and equivalent artifacts.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactUsesLexicalReadyOrder",
      "qualityCheck": "Precise.",
      "verifies": "Jakarta order is exactly leaf, z, a for independent ready leaf/z and a depending on z."
    },
    {
      "evidence": "The prompt explicitly rejects approved includes resolving outside JSP root as IllegalArgumentException.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRejectsAnApprovedIncludeOutsideTheJspRoot",
      "qualityCheck": "Direct.",
      "verifies": "Outside approved include causes IllegalArgumentException and destination remains absent."
    },
    {
      "evidence": "The prompt explicitly rejects selected symbolic links and forbids planning mutation.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRejectsSelectedSymbolicLinks",
      "qualityCheck": "Direct.",
      "verifies": "Selecting link.tag throws IllegalArgumentException and the real source remains."
    },
    {
      "evidence": "Both rejection classes are explicit in the prompt. The concrete ambiguity follows JspToJteConverter.java:159-173; the concrete camel-case collision follows JspToJteConverter.java:182-196 and CamelCaseConverter.java:5-18.",
      "fairness": "Repo-discoverable",
      "name": "jakartaArtifactRejectsAmbiguousNamesAndCollidingDestinations",
      "qualityCheck": "Two distinct but well-supported validation assertions.",
      "verifies": "one/my/a.tag plus two/my/a.tag throws IllegalArgumentException for ambiguous invocation name; a-b.tag plus aB.tag throws IllegalArgumentException for output collision."
    },
    {
      "evidence": "The prompt rejects every already-taken destination path and says planning does not mutate.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRejectsAnExistingDirectoryDestination",
      "qualityCheck": "Direct occupied-path variant.",
      "verifies": "A directory occupying the generated destination causes IllegalArgumentException and remains a directory."
    },
    {
      "evidence": "The prompt defines staleness by content snapshots rather than timestamps and requires successful commit effects.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactTreatsATimestampOnlyChangeAsCurrent",
      "qualityCheck": "Direct complement to changed-content test.",
      "verifies": "Changing only selected mtime still allows commit; source is deleted and destination content contains a."
    },
    {
      "evidence": "The prompt says suppressions and getNotConvertedTags apply to every selected tag. Existing no-op registration and unresolved exemption are at JspToJteConverter.java:71-75 and 205-212.",
      "fairness": "Repo-discoverable",
      "name": "jakartaArtifactAppliesSuppressionsAndNotConvertedTags",
      "qualityCheck": "Combines two configuration paths but pins their distinct observable effects.",
      "verifies": "With a's CustomTag suppressed and external marked not converted, order is exactly a, leaf, z and leaf.jte contains <my:external>."
    },
    {
      "evidence": "The prompt explicitly requires aggregate unique lexical changed paths and no mutation before throwing staleness.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactReportsEveryStaleCategoryTogether",
      "qualityCheck": "Strong aggregation parity test.",
      "verifies": "Changed selected source, changed usage, and newly created destination are all returned exactly once in lexical order; concurrent destination content remains \"concurrent\"."
    },
    {
      "evidence": "The prompt explicitly requires rethrow of the original IOException, exact restoration of affected paths, and rollback failures attached as suppressed exceptions.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRollbackRestoresExactBytesAndAttachesRollbackFailures",
      "qualityCheck": "String checks only target messages supplied by the deterministic fault injector, not implementation wording.",
      "verifies": "The original injected commit IOException surfaces; a suppressed message contains the injected rollback failure; malformed usage bytes are restored exactly and selected source exists."
    },
    {
      "evidence": "The prompt explicitly rejects destinations outside JTE root and preserves subclass hooks/non-mutating planning.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRejectsAnOutputSuggestedOutsideTheJteRoot",
      "qualityCheck": "Direct.",
      "verifies": "A subclass-suggested ../outside.jte causes IllegalArgumentException and creates no outside file."
    },
    {
      "evidence": "The prompt explicitly says a destination occupied by a symlink is rejected.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRejectsADanglingDestinationSymlink",
      "qualityCheck": "Good NOFOLLOW parity check.",
      "verifies": "A dangling symlink at the destination causes IllegalArgumentException; source remains and destination remains a symlink."
    },
    {
      "evidence": "The prompt explicitly defines final write content as UTF-8 and requires equivalent artifact behavior.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactCommitsPlannedContentAsUtf8Bytes",
      "qualityCheck": "Exact and locale-independent.",
      "verifies": "Planned generated and usage strings contain é中ß; every committed write's bytes exactly equal its planned value encoded UTF-8."
    },
    {
      "evidence": "The prompt explicitly includes created directories in exact rollback restoration.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRollbackRemovesDirectoriesItCreated",
      "qualityCheck": "Strong directory-cleanup check.",
      "verifies": "Injected primary IOException surfaces; complete filesystem snapshot is restored and newly created jteRoot is absent."
    },
    {
      "evidence": "The prompt explicitly says the plan collections are immutable.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactCollectionsAreImmutable",
      "qualityCheck": "Direct.",
      "verifies": "Clearing conversion order, clearing deletes, and clearing writes each throw UnsupportedOperationException."
    },
    {
      "evidence": "The prompt requires rollback after post-mutation IOException and says unrelated paths remain untouched. The assertions also pass if the blocker is encountered before mutation, since the pre-state remains unchanged.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactRollsBackWhenLaterDestinationParentIsBlocked",
      "qualityCheck": "Useful real-filesystem failure path without over-pinning commit operation order.",
      "verifies": "Commit throws IOException when zzz destination parent is an unrelated file; both source contents remain, earlier aaa destination is absent, and blocker content remains exact."
    },
    {
      "evidence": "The prompt preserves subclass hooks and per-conversion setup. Existing hook/prefix/call forms are discoverable at JspToJteConverter.java:47-53, JtpConverter.java:88 and 106-107, and JspJteConverter.java:27-28.",
      "fairness": "Repo-discoverable",
      "name": "jakartaArtifactAppliesSubclassHooksToEveryConversion",
      "qualityCheck": "Appropriate artifact parity for extension points.",
      "verifies": "leaf.jte starts with setup prefix and contains read-hook text; root.jte starts with the same prefix and contains @template.my.leaf(."
    },
    {
      "evidence": "The prompt explicitly says a successful plan commits only once and successful commits leave no temporary files.",
      "fairness": "Prompt-stated",
      "name": "jakartaArtifactCommitsOnlyOnce",
      "qualityCheck": "Does not over-specify the second-call exception.",
      "verifies": "After successful commit, second commit throws some failure, leaves the committed snapshot unchanged, leaves destination present, and leaves no transaction files."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Shipd Bot Description Warnings**

> "their final UTF-8 content"

Tighten this to something like "getWrites() maps normalized absolute paths to the final file content" and keep the UTF-8 requirement in the later commit paragraph. The accessor returns Strings, so calling the map values "UTF-8 content" reads like API-reference wording and mixes the plan shape with the separate requirement that commit writes UTF-8 bytes.

> "resolved against the converter's resource base"

This is more implementation-specific than the tests seem to require. Consider simplifying to "approved inlined includes still participate in dependency discovery, but only if they resolve under the JSP root." That keeps the behavioral requirement while leaving the exact resolution mechanism to the implementer.

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 5 suggestions total, including multiple HIGH priority items (removing explicit API signatures/returns and boilerplate about preserving behavior). Per rules, any HIGH priority or 3+ total suggestions requires a request_changes verdict.",
  "suggestions": [
    {
      "priority": "high",
      "quote": "JspToJteConverter.planTags(Collection<String>, Consumer<Converter>) accepts a non-empty collection of root-relative `.tag` paths and returns a migration plan. `getConversionOrder()` and `getDeletes()` return normalized absolute `Path` values, while `getWrites()` maps normalized absolute paths to their final UTF-8 content. These collections are immutable.",
      "suggestion": "Remove this entire API/signature/return-type/immutability block. The exact method/class names, signatures, and returned collection types/immutability can be discovered directly from the code/tests. Keep only the high-level requirement that a batch planning API exists (already conveyed by the first sentence of the problem)."
    },
    {
      "priority": "medium",
      "quote": "and `getNotConvertedTags()`",
      "suggestion": "Remove the explicit method name reference; it’s discoverable from the codebase/tests and adds noise. The surrounding sentence stands on its own without naming the method."
    },
    {
      "priority": "medium",
      "quote": "Planning does not change the filesystem.",
      "suggestion": "Remove – this is an obvious default for a “plan” phase and is already implied by the later commit semantics and enforced by tests."
    },
    {
      "priority": "high",
      "quote": "Each generated template uses the same parser setup and per-tag conversion rules as existing one-tag conversion.",
      "suggestion": "Remove – this is “maintain existing behavior” boilerplate that a competent solver will assume and can verify from existing one-tag conversion logic/tests."
    },
    {
      "priority": "high",
      "quote": "Successful commits leave no temporary files, unrelated paths remain untouched, subclass hooks keep working, and the `javax` and Jakarta artifacts provide equivalent behavior.",
      "suggestion": "Remove – these are general non-regression assurances and cross-artifact equivalence claims that are either obvious defaults or fully covered by tests."
    }
  ],
  "summary": "- [HIGH] Remove the API signature/return details block: \"JspToJteConverter.planTags(Collection<String>, Consumer<Converter>)... `getConversionOrder()`... `getDeletes()`... `getWrites()`... These collections are immutable.\" Action: delete this whole sentence group; the exact method names, signatures, return types, and immutability are discoverable from the code/tests.\n- [MEDIUM] Remove the method-name reference \"and `getNotConvertedTags()`\". Action: drop the backticked method from the sentence; it’s code-specific noise that can be found in the codebase/tests.\n- [MEDIUM] Remove \"Planning does not change the filesystem.\" Action: delete this obvious default; read-only planning is implied by the commit phase behavior and validated by tests.\n- [HIGH] Remove \"Each generated template uses the same parser setup and per-tag conversion rules as existing one-tag conversion.\" Action: delete this maintain-current-behavior filler; it’s assumed and enforced by tests.\n- [HIGH] Remove \"Successful commits leave no temporary files, unrelated paths remain untouched, subclass hooks keep working, and the `javax` and Jakarta artifacts provide equivalent behavior.\" Action: delete these non-regression/equivalence assurances; they’re either defaults or fully covered by tests.",
  "verdict": "request_changes"
}
```
