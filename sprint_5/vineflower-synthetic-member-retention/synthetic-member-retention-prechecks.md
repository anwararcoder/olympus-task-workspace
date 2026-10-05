**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥20 messages, ≥200 LOC

This task numbers: Median files: 14, messages: 164, LOC: 471

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "0608746415d57b13ea294aa40ad5c6ecaff3a0bd3d18d09ca2f12cf5edf72030",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Extends the Immutables processor so attributes annotated with both @Value.Lazy and @Value.Default become seedable-lazy: they can be explicitly set via builders/with-methods, retain seed provenance across copies, and remain lazy when unseeded. Implements this across meta model and codegen templates for builders, with-methods, copy/from, Modifiable behavior, and validations.",
      "confidence": 0.97,
      "contentAuthoredAt": 1785059537028,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: a Java decompiler (Vineflower) vs. a code-generation processor for immutable values (Immutables).",
        "Submission modifies decompilation surfaces (ClassWriter, ClassesProcessor, DecompilerContext, preferences) and adds a SyntheticMemberRetention pass that iteratively renders, scans output tokens, and unhides synthetic/bridge members referenced by emitted Java; candidate alters annotation processing and codegen templates to support @Value.Lazy + @Value.Default as a seedable-lazy attribute with builders/with-methods and copy semantics.",
        "Submission’s behavior is reference-driven retention of synthetic members (fields, methods, inner classes, bridge methods) during writing; candidate’s behavior is explicit seeding, provenance tracking, and preservation across builders/copies for user-declared attributes, including collection/map/optional variants and Modifiable types.",
        "Submission’s scope hinges on decompiler options (REFERENCE_AWARE_SYNTHETIC_RETENTION, REMOVE_SYNTHETIC/REMOVE_BRIDGE) and class hierarchy resolution for references; candidate’s scope hinges on generator constraints (requires builders and with-methods, disallows interned types), serialization paths, and numerous template paths in generated code."
      ],
      "one_liner": "One adds an opt-in, reference-aware pass to a Java decompiler to unhide only those synthetic members still referenced by emitted code, while the other introduces seedable-lazy attributes in a code generator so lazy defaults can be explicitly set and preserved across copies.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "The two solutions target unrelated projects and features: one adds an iterative, token-driven retention pass in a decompiler to conditionally unhide generated members, while the other extends an annotation processor’s codegen to support seedable lazy attributes with explicit seeding and copy preservation. There is no purpose-matched modified surface, shared API, or shared observable behavior; similarities are only in generic terminology about retention/initialization. Thus they teach different lessons and should co-exist.",
      "similarity": 0.5057605504989624,
      "submission_summary": "Adds a new decompiler option and pass that iteratively renders classes, scans emitted tokens for member references, and unhides only those synthetic/bridge fields, methods, or inner classes still referenced by the output. Integrates this via ClassWriter/ClassesProcessor hooks, a SyntheticMemberRetention context object, and a default-off IFernflowerPreferences toggle.",
      "title": "Seedable Lazy Attributes",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Adds a language-server refactoring to replace inheritance with delegation, wiring an LSP executeCommand handler and a code action. It analyzes AST/types to remove the extends clause, insert a private final delegate field, forward used methods, rewrite internal references, and rejects when behavior could change or types are incompatible, returning a WorkspaceEdit.",
      "confidence": 0.98,
      "contentAuthoredAt": 1782539866774,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: a Java decompiler (Vineflower) vs. a Java language server.",
        "Submission adds a decompiler preference and an iterative write pipeline to retain referenced synthetic members; candidate adds an LSP command, code action wiring, and source-to-source refactoring that edits classes to delegation.",
        "Submission’s modified surfaces are decompiler internals (ClassWriter, ClassesProcessor, DecompilerContext, a new SyntheticMemberRetention, and IFernflowerPreferences); candidate modifies server initialization/dispatch, code action provider, and adds a refactoring engine (DelegationEditor/ReplaceInheritanceWithDelegation).",
        "Behaviorally unrelated: submission conditionally unhides synthetic/bridge/inner members based on references in the produced TextBuffer; candidate analyzes AST/semantic types to remove extends, insert a delegate field, forward methods, and rewrite internal/external references under safety checks.",
        "Scope differences: submission’s option-driven retention affects only emitted synthetic constructs and iterates until fixpoint; candidate’s refactor operates via LSP on user-invoked command/code action across workspace files with rejection conditions to preserve behavior."
      ],
      "one_liner": "One adds a decompiler option to retain only those synthetic members actually referenced by emitted Java, while the other adds a language-server refactoring that replaces class inheritance with delegation and forwards members.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "The two patches target different projects and implement unrelated features at different layers. There is no shared purpose-matched surface, API, or observable behavior; one is a decompiler emission control option, the other is an IDE/server refactoring operation. Overlaps are only generic Java and tooling concerns, not structural task similarity.",
      "similarity": 0.4892953336238861,
      "submission_summary": "Introduces a new decompiler option and machinery to retain only those synthetic/bridge/member-class declarations that the emitted Java actually references. It modifies ClassWriter and the class-writing flow to iterate decompilation with a SyntheticMemberRetention tracker, hooks hide decisions for fields/methods/classes, wires context/state, and adds the preference with a default of disabled.",
      "title": "Replace Inheritance with Delegation",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Adds a duplicate-class-strategy option and a DuplicateClassResolver, refactoring StructContext and Fernflower to deterministically select one origin for duplicate class names and anchor related inner/local class families. It handles first/last/error policies, caches resolutions, and logs decisions while ensuring concurrent lookups don’t change winners.",
      "confidence": 0.93,
      "contentAuthoredAt": 1785057061180,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds a decompilation-time retention pass in ClassWriter that iterates output tokens to re-include only referenced synthetic/bridge fields, methods, and inner classes, controlled by a new reference-aware option.",
        "Submission wires a new per-decompilation context (CURRENT_SYNTHETIC_MEMBER_RETENTION) and adjusts hide decisions for fields/methods/classes; candidate does nothing with member visibility or emitted Java structure.",
        "Candidate adds a duplicate-class resolution strategy (first/last/error), a new DuplicateClassResolver, and rewrites StructContext/Fernflower integration to deterministically select an origin and anchor class families; submission does not touch class loading or origin selection.",
        "Candidate’s behavior concerns context-source registration, lazy/eager libraries, and conflict logging; submission’s scope is per-file, per-member emission semantics based on references in produced Java."
      ],
      "one_liner": "One adds a reference-aware pass to keep only those synthetic/bridge members that emitted Java still refers to; the other introduces a strategy-driven resolver to pick a single origin for duplicate class names across inputs.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "Both patches live in the same repository but target unrelated features at different layers. The submission modifies the writing pipeline to conditionally retain generated members based on references in the emitted Java, while the candidate reworks class loading to deterministically select among duplicate class definitions across sources. The only common file edited is the preferences interface, and each adds a distinct, unrelated option; there are no shared APIs or behaviors beyond repository boilerplate.",
      "similarity": 0.482932984828949,
      "submission_summary": "Introduces a reference-aware synthetic retention option and a SyntheticMemberRetention pass that scans emitted tokens to keep only generated members (synthetic/bridge/hidden) that are still referenced, integrating with ClassWriter and DecompilerContext. It loops decompilation until the retained set stabilizes and adjusts hide decisions per member.",
      "title": "Deterministic Duplicate Class Resolution",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Implements a deterministic identifier-legalization/renaming system: plans legal names for classes, fields, and methods (respecting overrides), and applies them consistently across code generation, constant pool, annotations, and generics via a new IdentifierRenamingPlan, JavaIdentifierRules, and enhanced PoolInterceptor.",
      "confidence": 0.93,
      "contentAuthoredAt": 1785155734997,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds a new decompiler option and an iterative retention pass (SyntheticMemberRetention) that scans the produced TextBuffer tokens to unhide only referenced synthetic fields/methods/member classes/bridges; the candidate adds a comprehensive renaming plan for illegal identifiers across classes, fields, and methods, including override-family coherence.",
        "Submission modifies hide decisions in ClassWriter (hideField/hideMethod/hideClass) based on dynamic reference analysis, gating write passes and logger calls; the candidate removes ad-hoc identifier sanitization and integrates PoolInterceptor-backed mappings throughout expression rendering, constant pool resolution, and generics/annotations rendering.",
        "Submission is opt-in via IFernflowerPreferences.REFERENCE_AWARE_SYNTHETIC_RETENTION with default off, leaving output unchanged when disabled; the candidate restructures IdentifierConverter/PoolInterceptor and always runs a legalization pass to ensure compilable names, affecting naming even when entity renaming is otherwise off.",
        "Submission introduces DecompilerContext.CURRENT_SYNTHETIC_MEMBER_RETENTION and a fixed-point loop around writeClass; the candidate introduces IdentifierRenamingPlan and JavaIdentifierRules, updates ConstantPool/ExprProcessor/FieldExprent/AnnotationExprent/GenericType to honor planned names."
      ],
      "one_liner": "One adds an option to iteratively retain only those synthetic/bridge members that the emitted Java still references; the other implements a deterministic identifier-legalization/renaming pipeline that rewrites invalid class/field/method names and all their references.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "Although both touch core decompiler files, they do so for unrelated purposes. The submission’s new SyntheticMemberRetention iteratively adjusts which synthetic members are emitted based on references in the generated Java, while the candidate rewires the naming pipeline to legalize and consistently map identifiers across all surfaces. There are no shared APIs or behaviors beyond repository boilerplate; the modified surfaces serve different goals and teach different debugging lessons.",
      "similarity": 0.48260802030563354,
      "submission_summary": "Adds a new preference and a SyntheticMemberRetention pass that iteratively writes a class, scans emitted tokens for references, and unhides only those synthetic/bridge members (fields, methods, member classes) still referenced by the output; integrates this into ClassWriter/ClassesProcessor via a context key and option gate.",
      "title": "Automatic Identifier Legalization",
      "verdict": "distinct"
    },
    {
      "authorUsername": "zeyad2003",
      "candidate_summary": "Introduces control‑flow/SSA‑based analysis to decide when stack-allocated temporaries from dup/swap permutations can be safely inlined across branches/loops, tagging assignments per permutation group and preserving evaluation order/frequency; integrates into ExprProcessor/StackVarsProcessor and augments AssignmentExprent with group metadata.",
      "confidence": 0.92,
      "contentAuthoredAt": 1785178196473,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Submission adds an option-driven pass in the class writer that scans emitted Java tokens to decide whether to unhide synthetic/bridge members and inner classes; candidate adds SSA/control-flow analyses to govern when stack assignments can be inlined across branches/loops.",
        "Submission modifies ClassWriter, ClassesProcessor, DecompilerContext, IFernflowerPreferences, and introduces SyntheticMemberRetention; candidate modifies ExprProcessor, StackVarsProcessor, AssignmentExprent, and adds DirectGraphAnalysis, StackValueFlow, StackValueLocationIndex, StackTransferGroup.",
        "Submission’s behavior iteratively re-renders a class until referenced generated members are retained; candidate’s behavior groups JVM stack permutation assignments and restricts substitution to preserve evaluation order/frequency and simultaneous-transfer semantics.",
        "Submission targets synthetic member visibility in output; candidate targets expression/stack simplification without changing semantics."
      ],
      "one_liner": "They implement unrelated decompiler features: one retains referenced synthetic members during class writing, the other adds control‑flow‑aware stack value simplification.",
      "overlap": {
        "same_repo": true,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "Despite being in the same repository, the patches target entirely different subsystems and purposes. The submission adds a reference-aware synthetic/bridge/member-class retention mechanism in the class writing stage, while the candidate implements a control-flow/SSA-based operand-stack simplification pipeline. There are no shared modified APIs, tests, or concrete behaviors; overlaps are only at a very high, generic level (output correctness), which is not sufficient for duplication.",
      "similarity": 0.4640600085258484,
      "submission_summary": "Adds a new preference and a retention pass that repeatedly writes a class and uses tokens in the emitted Java to unhide only those synthetic/bridge fields, methods, and member classes that are referenced; integrates via ClassWriter/ClassesProcessor and a new SyntheticMemberRetention context object.",
      "title": "Add control-flow-safe operand-stack simplification",
      "verdict": "distinct"
    }
  ],
  "reusedFromPriorRun": true
}
```

---

**Test Fairness**

Coverage Suggestions (4) - Not Blockers

Advisory only — these don't affect the check result.

Option registration and public API
Assert that `IFernflowerPreferences` exposes the new option with boolean metadata and that `DEFAULTS` maps it to `"0"`; also exercise the normal CLI/option parser rather than only inserting the raw string into a fixture options map.

Broader disabled-mode compatibility
Compare disabled/absent output on representative synthetic fields, methods, bridges, member classes, and lambdas, not only the assertion-field scenario, to enforce the prompt's global “output is unchanged” requirement.

Reconstruction combinations
Add a paired case for another selectable reconstruction setting—such as synthetic accessor or inner-class reconstruction—showing the same member omitted when reconstruction consumes its references and retained when that reconstruction is disabled.

Omitted nested code
Add a case where an omitted synthetic member class or omitted synthetic method is the only code referring to another generated outer member, ensuring the outer member is not retained through code absent from the final file.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Option registration and public API",
      "suggestion": "Assert that `IFernflowerPreferences` exposes the new option with boolean metadata and that `DEFAULTS` maps it to `\"0\"`; also exercise the normal CLI/option parser rather than only inserting the raw string into a fixture options map."
    },
    {
      "area": "Broader disabled-mode compatibility",
      "suggestion": "Compare disabled/absent output on representative synthetic fields, methods, bridges, member classes, and lambdas, not only the assertion-field scenario, to enforce the prompt's global “output is unchanged” requirement."
    },
    {
      "area": "Reconstruction combinations",
      "suggestion": "Add a paired case for another selectable reconstruction setting—such as synthetic accessor or inner-class reconstruction—showing the same member omitted when reconstruction consumes its references and retained when that reconstruction is disabled."
    },
    {
      "area": "Omitted nested code",
      "suggestion": "Add a case where an omitted synthetic member class or omitted synthetic method is the only code referring to another generated outer member, ensuring the outer member is not retained through code absent from the final file."
    }
  ],
  "error": "",
  "executionTimeSeconds": 230.46514,
  "message": "All hidden tests are fair.",
  "overall": "PASS — all tested agent-facing behaviors are explicitly required by the prompt or concretely supported by existing repository behavior. The suite is unusually thorough about per-member precision, active removal/reconstruction settings, transitive closure, omitted-code exclusion, non-code false positives, nested scopes, determinism, compilability, and behavior preservation. It avoids brittle whole-source golden files except for the justified disabled-option equality check and exact marker syntax already produced by the repository. No hidden setup requires an undocumented implementation strategy from the agent.",
  "taskSummary": "Add a boolean decompiler option named `reference-aware-synthetic-retention`, defaulting to disabled. With it disabled, output must remain unchanged. With it enabled, the decompiler must reconsider only declarations that the active synthetic/bridge removal and reconstruction settings would otherwise omit. It must retain each synthetic field, method, member class, or bridge method exactly when code that survives into the same emitted Java file refers to that member. The decision is per declaration and follows references transitively through retained declarations, but references from omitted code, comments, and literals do not count. References from member/local/anonymous classes and lambdas in the same output file do count. The selected reconstruction settings matter: if reconstruction consumes the reference (for example, assertion or lambda reconstruction), the generated declaration stays omitted. Results must be deterministic across contexts and after recompiling/decompiling the emitted output.",
  "tests": [
    {
      "evidence": "The prompt explicitly says the option is “disabled by default” and “When the option is disabled, output is unchanged.” The pre-change omission behavior is also concrete in `src/org/jetbrains/java/decompiler/main/ClassWriter.java:455-457`, where synthetic fields are skipped when `REMOVE_SYNTHETIC` is enabled; the fixture enables that setting at `testFixtures/org/jetbrains/java/decompiler/DecompilerTestFixture.java:54-55`.",
      "fairness": "Prompt-stated",
      "name": "assertionFieldTracksTheReconstructionSetting — disabled/default compatibility",
      "qualityCheck": "Fair and strong backward-compatibility check. Comparing normalized output from two runs is deterministic and avoids pinning a hand-written formatting fixture.",
      "verifies": "With assertion reconstruction disabled and the new option absent, none of javac's generated assertion fields is declared. Passing `reference-aware-synthetic-retention=0` produces exactly the same normalized source as omitting the new option."
    },
    {
      "evidence": "The prompt explicitly requires generated members to remain omitted “Where reconstruction consumes every reference.” Assertions are reconstructed by default (`src/org/jetbrains/java/decompiler/main/extern/IFernflowerPreferences.java:430`) and `AssertProcessor` only performs that reconstruction when the setting is enabled (`src/org/jetbrains/java/decompiler/modules/decompiler/AssertProcessor.java:24-35`).",
      "fairness": "Prompt-stated",
      "name": "assertionFieldTracksTheReconstructionSetting — reconstructed assertion",
      "qualityCheck": "Fair. It checks both the exact declaration set and that the resulting source compiles and behaves equivalently.",
      "verifies": "With the new option enabled and default assertion reconstruction active, the intersection of emitted fields with the compiler-generated assertion fields is exactly empty; the recompiled output's public static `value()` returns the same result as the original."
    },
    {
      "evidence": "The prompt requires retention “where references remain” under the reconstruction-setting combination that produced them. `DECOMPILE_ASSERTIONS=0` prevents assertion reconstruction at `src/org/jetbrains/java/decompiler/modules/decompiler/AssertProcessor.java:24-27`, leaving the generated assertion-field uses in emitted code.",
      "fairness": "Prompt-stated",
      "name": "assertionFieldTracksTheReconstructionSetting — literal assertion implementation",
      "qualityCheck": "Fair. One weakness is that the test does not independently assert that `generated` is nonempty, though OpenJDK's assertion translation supplies the expected field.",
      "verifies": "With the new option enabled but assertion reconstruction disabled, the emitted fields among the generated assertion fields equal the complete generated-field set; the recompiled `value()` result equals the original result."
    },
    {
      "evidence": "The prompt explicitly says retention is “per member,” that declaring one generated member does not justify declaring unreferenced siblings, and that a generated declaration is declared when emitted code refers to it. Here surviving code uses `Child.needed`, while no surviving code uses the field `discarded`.",
      "fairness": "Prompt-stated",
      "name": "referencedSyntheticFieldDoesNotKeepItsSibling — enabled decision",
      "qualityCheck": "Fair, direct per-field test. The values and names are deterministic and parsed through javac's AST rather than brittle source substrings.",
      "verifies": "Among the two marked synthetic fields `needed` and `discarded`, the output declares exactly `needed`; the output recompiles and its `value()` result equals the original."
    },
    {
      "evidence": "The hidden setup compiles with `-parameters`. The repository documents that method-parameter names are taken from `MethodParameters` at `src/org/jetbrains/java/decompiler/main/extern/IFernflowerPreferences.java:126-130`, enables that option by default at `src/org/jetbrains/java/decompiler/main/extern/IFernflowerPreferences.java:444`, and assigns those names at `src/org/jetbrains/java/decompiler/modules/decompiler/vars/VarDefinitionHelper.java:82-99`. The prompt's definition of a reference as a use of a member excludes a mere parameter declaration with the same identifier.",
      "fairness": "Repo-discoverable",
      "name": "referencedSyntheticFieldDoesNotKeepItsSibling — identifier collision",
      "qualityCheck": "Fair and useful: it prevents naïve name-based source scanning. The exact parameter name is supported by existing parameter-name behavior, not an arbitrary hidden formatting choice.",
      "verifies": "The emitted source contains a method parameter named exactly `discarded`, while the synthetic field with that same name remains omitted."
    },
    {
      "evidence": "The prompt limits the new decision to declarations that active removal/reconstruction settings “would otherwise omit.” With synthetic removal disabled, neither field is eligible for omission. The existing option is documented as removing synthetic methods and fields at `src/org/jetbrains/java/decompiler/main/extern/IFernflowerPreferences.java:18-22`.",
      "fairness": "Prompt-stated",
      "name": "referencedSyntheticFieldDoesNotKeepItsSibling — removal disabled",
      "qualityCheck": "Fair integration check that the new option does not override an explicit existing removal setting.",
      "verifies": "With `REMOVE_SYNTHETIC=0`, the output declares exactly both marked fields, `needed` and `discarded`, and the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt explicitly requires a per-member decision and says retained declarations are justified by references in emitted code. The surviving zero-argument `needed()` refers to `helper()`, which refers to `dependency`; the unreferenced `discarded()`, one-argument `needed(int)`, and `discardedField` are outside that retained reference closure. The overload-count assertion precisely enforces “per member,” rather than merely per method name.",
      "fairness": "Prompt-stated",
      "name": "referencedSyntheticMethodDoesNotKeepItsSibling",
      "qualityCheck": "Fair and high quality. It checks transitive retention, an overload with the same name, an unrelated sibling, and a field dependency without relying on source formatting.",
      "verifies": "The only emitted selected field is `dependency`; the only emitted selected method names are `needed` and `helper`; among methods named `needed`, the only emitted parameter count is 0, so the one-argument overload is absent; and the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt explicitly includes bridge methods and says the decision is per member. The existing writer independently omits bridge methods under `REMOVE_BRIDGE` at `src/org/jetbrains/java/decompiler/main/ClassWriter.java:482-484`.",
      "fairness": "Prompt-stated",
      "name": "bridgeRemovalUsesTheSamePerMethodDecision — bridge removal active",
      "qualityCheck": "Fair. It isolates bridge removal from synthetic removal and checks the exact retained method set.",
      "verifies": "With synthetic removal disabled and bridge removal enabled, exactly `needed` is declared among the two methods marked bridge, `discarded` is absent, and the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt applies reference-aware retention only to members that active removal settings would otherwise omit. Existing code conditions bridge omission on `REMOVE_BRIDGE` at `src/org/jetbrains/java/decompiler/main/ClassWriter.java:482-484`, so disabling it makes both methods ineligible for the new omission decision.",
      "fairness": "Prompt-stated",
      "name": "bridgeRemovalUsesTheSamePerMethodDecision — bridge removal disabled",
      "qualityCheck": "Fair integration check; it guards against treating all ACC_BRIDGE methods as candidates regardless of settings.",
      "verifies": "With both synthetic and bridge removal disabled, exactly both marked methods, `needed` and `discarded`, are emitted, and the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt explicitly includes synthetic member classes and requires member-by-member retention. Existing code identifies and hides synthetic member classes at `src/org/jetbrains/java/decompiler/main/ClassWriter.java:505-511`.",
      "fairness": "Prompt-stated",
      "name": "referencedSyntheticMemberClassDoesNotKeepItsSibling",
      "qualityCheck": "Fair and direct. AST parsing makes the exact nested-class declaration check robust.",
      "verifies": "Among synthetic member classes `Needed` and `Discarded`, the output declares exactly `Needed`; the emitted source recompiles and `value()` returns the same result as in the original."
    },
    {
      "evidence": "The prompt explicitly says that a member declared on the outermost class and referred to only from a member class in the same file is referred to.",
      "fairness": "Prompt-stated",
      "name": "memberClassBodyKeepsAnOuterField",
      "qualityCheck": "Fair and directly targeted at the same-file scope rule.",
      "verifies": "When only a retained member-class body refers to the outer synthetic field `needed`, the output declares exactly `needed` and not sibling `discarded`; the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt explicitly lists a local class body as code in the same output file whose reference must retain an outer member.",
      "fairness": "Prompt-stated",
      "name": "localClassBodyKeepsAnOuterField",
      "qualityCheck": "Fair and deterministic.",
      "verifies": "When only a local-class body refers to the outer synthetic field `needed`, the output declares exactly `needed` and not `discarded`; the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt explicitly lists an anonymous class body as code in the same output file whose reference must count.",
      "fairness": "Prompt-stated",
      "name": "anonymousClassBodyKeepsAnOuterField",
      "qualityCheck": "Fair and deterministic.",
      "verifies": "When only an anonymous-class body refers to the outer synthetic field `needed`, the output declares exactly `needed` and not `discarded`; the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt explicitly lists a lambda body as same-file emitted code whose member references count. The repository's lambda writer obtains and emits the lambda content body at `src/org/jetbrains/java/decompiler/main/ClassWriter.java:217-226`.",
      "fairness": "Prompt-stated",
      "name": "lambdaBodyKeepsAnOuterField",
      "qualityCheck": "Fair and important because lambda reconstruction could otherwise make a reference scan miss the body.",
      "verifies": "When an emitted lambda body refers to outer synthetic field `needed`, the output declares exactly `needed` and not `discarded`; the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt defines references in terms of all emitted Java code and requires per-member retention. Once `anchor` is retained, its emitted initializer refers to `dependency`; once `dependency` is retained, its initializer refers to `leaf`. Nothing refers to `discarded`. This is the direct transitive application of the stated reference rule.",
      "fairness": "Prompt-stated",
      "name": "retainedInitializerReachesItsOwnDependency",
      "qualityCheck": "Fair and strong closure/fixed-point test.",
      "verifies": "Among marked fields `leaf`, `dependency`, `anchor`, and `discarded`, the output declares exactly `leaf`, `dependency`, and `anchor`; it omits `discarded`; the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt explicitly says “Omitted code refers to nothing” and that a generated member reachable only from another omitted member remains omitted. The dead two-method cycle is exactly that scenario.",
      "fairness": "Prompt-stated",
      "name": "omittedMethodBodyDoesNotReachAnotherMethod",
      "qualityCheck": "Fair and particularly valuable: it prevents seeding retention from references in code that will not be output.",
      "verifies": "Among marked methods `needed`, `deadLeaf`, and `deadRoot`, the output declares exactly `needed`; the mutually referring `deadLeaf` and `deadRoot` are both absent; the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The exact marker form is produced by existing code at `src/org/jetbrains/java/decompiler/main/ClassWriter.java:227-232` when `MARK_CORRESPONDING_SYNTHETICS` is enabled. String constants are emitted as Java string literals at `src/org/jetbrains/java/decompiler/modules/decompiler/exps/ConstExprent.java:345-348`. Existing lambda processing explicitly treats a non-method-reference lambda as having a hidden synthetic content method at `src/org/jetbrains/java/decompiler/main/rels/NestedClassProcessor.java:47-52`.",
      "fairness": "Repo-discoverable",
      "name": "syntheticMarkerCommentIsNotAMethodReference — setup and exact non-code forms",
      "qualityCheck": "Fair, though the first two assertions are mainly harness sanity checks and rely on the fixed OpenJDK javac translation. The exact comment assertion is not arbitrary because it mirrors existing writer output.",
      "verifies": "The manually marked `literalOnly` method is present in the reflected synthetic-method set; javac generated at least one additional synthetic lambda implementation method; for every such lambda method the raw output contains the exact marker form `/* <methodName> */`; and the emitted AST contains the exact string literal value `literalOnly`."
    },
    {
      "evidence": "The prompt explicitly says comments and literal contents are not code and refer to nothing. It also requires lambda reconstruction to leave its consumed implementation method omitted, while a reference inside the emitted lambda body still retains the field it uses.",
      "fairness": "Prompt-stated",
      "name": "syntheticMarkerCommentIsNotAMethodReference — retention result",
      "qualityCheck": "Fair and high quality. It catches both comment and literal false positives while simultaneously ensuring real code in the lambda still counts.",
      "verifies": "No method in the complete generated-method set is declared, despite generated method names appearing in marker comments and `literalOnly` appearing in a string literal; exactly field `needed` is declared and sibling `discarded` is absent; the recompiled `value()` result equals the original."
    },
    {
      "evidence": "The prompt explicitly requires repeated runs and separate decompiler contexts to agree on the same retained members.",
      "fairness": "Prompt-stated",
      "name": "repeatedContextsAndARecompiledRoundAgree — repeated contexts",
      "qualityCheck": "Fair and non-flaky: each run uses isolated temporary directories and the retained set is compared structurally.",
      "verifies": "Two separate decompilation contexts each emit exactly `needed` and not `discarded`, and each recompiled output's `value()` result equals the original."
    },
    {
      "evidence": "The prompt explicitly requires “a further round, over output that has been compiled again” to agree.",
      "fairness": "Prompt-stated",
      "name": "repeatedContextsAndARecompiledRoundAgree — recompiled round",
      "qualityCheck": "Fair, but somewhat shallow for the retention algorithm: after recompilation, an ordinary Java source field generally no longer carries ACC_SYNTHETIC, so the third round mainly proves that the retained field stays present and the omitted sibling does not reappear.",
      "verifies": "After compiling the first emitted output and decompiling those class files again, the third output still contains exactly `needed` and not `discarded`, and its `value()` result equals the first recompiled output's result."
    },
    {
      "evidence": "These are standard observable semantics for a Java decompiler: emitted Java must be valid Java and preserve the behavior of the decompiled method. The prompt itself reinforces compilability by describing emitted Java that must not refer to omitted declarations and explicitly requiring a round over output “that has been compiled again.” The repository identifies Vineflower as a general-purpose Java/JVM decompiler producing clean code at `README.md:3-7`. Java 17 compilation, class loading, reflection, and invocation supply the exact external semantics used by the assertions.",
      "fairness": "Standard external semantics",
      "name": "Shared compilation, output-presence, and behavior assertions",
      "qualityCheck": "Fair integration coverage. The checks use deterministic, side-effect-free integer-returning methods and isolated class loaders, so there is no timing or ordering flakiness.",
      "verifies": "Every Java 17 scenario source must compile; every enabled-option decompilation must produce at least one `.java` file; every output used as an `Output` must itself compile with `--release 17`; and each `assertBehaviorMatches` call requires reflective invocation of public static `value()` on the compared classes to return equal objects."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Dockerfile guidelines**

Status: WARNING

warning: The Dockerfile itself does not show explicit pinned versions for project dependencies or package installs. While using the Gradle wrapper can pin the Gradle tool version (via gradle/wrapper/gradle-wrapper.properties) and Gradle/Java dependency versions are defined in the project files, the Dockerfile does not verify or ensure a committed lockfile (e.g., gradle.lockfile) or pinned dependency versions. To ensure reproducible builds, confirm that the repo includes pinned dependency versions or a committed Gradle lockfile and that gradle-wrapper.properties is committed to pin the Gradle distribution version.

Note: Internet access is available during `docker build`, but not when running the container. Test patch is injected into the container after build. Ensure your Dockerfile installs all dependencies at build time so the environment works fully offline after build.

```json
{
  "all_issues": "warning: The Dockerfile itself does not show explicit pinned versions for project dependencies or package installs. While using the Gradle wrapper can pin the Gradle tool version (via gradle/wrapper/gradle-wrapper.properties) and Gradle/Java dependency versions are defined in the project files, the Dockerfile does not verify or ensure a committed lockfile (e.g., gradle.lockfile) or pinned dependency versions. To ensure reproducible builds, confirm that the repo includes pinned dependency versions or a committed Gradle lockfile and that gradle-wrapper.properties is committed to pin the Gradle distribution version.",
  "base_image_compliant": {
    "explanation": "OK: Dockerfile uses an allowed Olympus JVM base image: FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest.",
    "status": "OK"
  },
  "dependencies_installed": {
    "explanation": "OK: The Dockerfile uses the project's Gradle wrapper (./gradlew) and runs a step that populates/caches dependencies (invoking a custom init script and running testClasses + cacheOfflineDependencies). This counts as dependency population/installation for a JVM/Gradle project.",
    "status": "OK"
  },
  "interactive_shell": {
    "explanation": "OK: The image ends with CMD [\"/bin/bash\"], providing an interactive shell for developers.",
    "status": "OK"
  },
  "no_test_execution": {
    "explanation": "OK: The Dockerfile runs the Gradle task testClasses (which compiles test sources) but does not run tests (it does not call gradle test). It does not copy or run test.sh or apply test.patch.",
    "status": "OK"
  },
  "package_manager_installation": {
    "explanation": "OK: The Dockerfile does not install or bootstrap package managers that are already provided by the chosen base image. No curl/wget bootstrap install scripts or apt/npm/pip installs of package managers were detected.",
    "status": "OK"
  },
  "registry_compliant": {
    "explanation": "OK: The base image comes from an allowed public.ecr.aws/d3j8x8q7 repository and matches an accepted Olympus base image.",
    "status": "OK"
  },
  "repository_setup": {
    "explanation": "OK: WORKDIR is /app and the Dockerfile performs COPY . . to copy the repository into the image. The Dockerfile does not attempt to git clone the repository and does not appear to copy only built artifacts.",
    "status": "OK"
  },
  "security_safety": {
    "explanation": "OK: No obfuscated/encoded commands, no hardcoded secrets, no docker socket mounts, and no downloads-and-execute patterns (curl|sh) were detected. The file permissions adjust with chmod but do not appear to be unsafe.",
    "status": "OK"
  },
  "user_creation_compatible": {
    "explanation": "OK: The Dockerfile does not create any users or groups; therefore there are no user creation compatibility issues with the required model:1000 UID/GID constraint.",
    "status": "OK"
  },
  "version_pinning": {
    "explanation": "warning: The Dockerfile itself does not show explicit pinned versions for project dependencies or package installs. While using the Gradle wrapper can pin the Gradle tool version (via gradle/wrapper/gradle-wrapper.properties) and Gradle/Java dependency versions are defined in the project files, the Dockerfile does not verify or ensure a committed lockfile (e.g., gradle.lockfile) or pinned dependency versions. To ensure reproducible builds, confirm that the repo includes pinned dependency versions or a committed Gradle lockfile and that gradle-wrapper.properties is committed to pin the Gradle distribution version.",
    "status": "warning"
  }
}
```

---

**Shipd Bot Description Warnings**

> "Output that needs no generated declarations must not gain any, member for member."

Trim this sentence. The preceding line already says retention is decided per member and that declaring one generated member does not justify keeping its siblings, which conveys the same constraint more naturally. Removing this extra restatement would make the description read less like a spec without losing behavior.

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 5 suggestions total, including 2 high-priority items (obvious defaults and over-specification). Per the guidelines, any high-priority item or 3+ total suggestions requires request_changes.",
  "suggestions": [
    {
      "priority": "high",
      "quote": "When the option is disabled, output is unchanged.",
      "suggestion": "Remove this sentence — it's an obvious default for a disabled option and adds no new constraints."
    },
    {
      "priority": "high",
      "quote": "The decision is deterministic for the same input: repeated runs and separate decompiler contexts agree on the same retained members, and a further round, over output that has been compiled again, agrees as well.",
      "suggestion": "Remove the entire paragraph — determinism for identical input is an assumed default; the added round-trip note is over-specified for the problem statement."
    },
    {
      "priority": "medium",
      "quote": "Where reconstruction consumes every reference to a generated member, that member remains omitted; where references remain, it is declared under the combination of reconstruction settings that produced them.",
      "suggestion": "Delete — this restates the prior rule (“Declare each such member if the emitted Java of its file refers to it…”) and the note to use reconstructed Java, without adding new requirements."
    },
    {
      "priority": "medium",
      "quote": "Retention is decided per member.",
      "suggestion": "Remove — the next sentence (“Declaring one generated member is no reason to declare its unreferenced siblings.”) conveys the same requirement more concretely."
    },
    {
      "priority": "low",
      "quote": "Output that needs no generated declarations must not gain any, member for member.",
      "suggestion": "Remove — already implied by the per-member rule and “declare only if referenced.”"
    }
  ],
  "summary": "- [HIGH] Delete: \"When the option is disabled, output is unchanged.\" This is an obvious default for a disabled option and adds no actionable constraint.\n- [HIGH] Delete the determinism paragraph: \"The decision is deterministic for the same input: repeated runs and separate decompiler contexts agree on the same retained members, and a further round, over output that has been compiled again, agrees as well.\" Determinism is a default assumption; the round-trip note is over-specified for the task.\n- [MEDIUM] Delete the restatement: \"Where reconstruction consumes every reference to a generated member...\" It repeats the earlier rule to declare only when referenced and to base the decision on reconstructed Java.\n- [MEDIUM] Delete: \"Retention is decided per member.\" The following sentence about not retaining unreferenced siblings expresses the same requirement more concretely.\n- [LOW] Delete: \"Output that needs no generated declarations must not gain any, member for member.\" This is already implied by per-member retention and the “declare only if referenced” rule.",
  "verdict": "request_changes"
}
```
