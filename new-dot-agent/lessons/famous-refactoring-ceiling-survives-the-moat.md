# A compiler-withheld algorithm does NOT clear the ceiling if the algorithm is a famous one and the fair description states the contract

**One-line:** the analyze()-only "READ moat" (javac withholds liveness/flow) is necessary but NOT sufficient — withholding the algorithm from the COMPILER does nothing against a thorough agent that already KNOWS the textbook algorithm and is handed the contract in fair prose.

**Stage:** W2 (Gate-C naive gauntlet). **Applies to:** `task-shape.md` §1 (READ/EDIT/STATE pre-screen, the moat argument), `idea-crafting.md` (Gate C), `repo-selection.md` (java-language-server retirement).

## Evidence (2026-06-27, java-extract-method, n=1 gauntlet — an existence-proof solve)

Extract Method on java-language-server was selected as a cascade-EDIT whose core is **live-variable dataflow over a statement range**. The plan leaned on a verified moat: the server stops at `borrow.task.analyze()` (`CompileBatch.java:43`) and never runs `Flow`/`Lower`, so liveness/definite-assignment is genuinely not in the symbol table (confirmed: zero liveness API in `src/main`). The claim was "the agent must hand-roll the whole liveness pass → not a compiler-assisted READ → Diamond-hard."

W2 measured both gates at slice cost:
- **Gate B (volume): comfortable.** Full-core slice = 485 effective / 603 non-empty LoC; projects ~650-800 eff full-task (in the java cohort band). Four-state green.
- **Gate C (ceiling): FAILED.** A fresh ZERO-CONTEXT agent (draft description + repo only) built a **correct full-contract** implementation in ~4 iterations — parameter derivation (read-before-assigned, first-appearance order), single live-out as a return, void, static mirroring, **two-live-out rejection**, **control-flow-escape rejection**, the assigned-before-read non-param, and the double-role (param-and-return) variable. It hand-rolled the def/use dataflow from scratch (the moat held — javac gave it nothing but symbol resolution), hit ONE transient bug (live-out declared above the selection), and fixed it via its own compile-and-run-equivalence harness. Independently re-verified: 8/8 of its own tests green, code reads correct — not overclaimed.

The plan's load-bearing "intuitive design is architecturally wrong" property (naive IDE port over-promotes locals / botches single-return / forgets by-value) held only against WEAK agents (cf. `fair-forks-catch-weak-agents-only`). The thorough agent made NONE of those mistakes — because the FAIR description, to be fair, stated the liveness contract, and a thorough agent reads textbook dataflow off a clear prose statement of it.

## The corrected reading

Two ceiling mechanisms are independent and BOTH must be cleared:
1. **Compiler-assisted READ** — javac/the framework computes the answer and hands it over. The moat (does the server run the analysis phase?) addresses THIS. Extract Method passes it.
2. **Famous-algorithm + fair-description telegraph** — the agent itself knows the algorithm (it is a named refactoring / textbook analysis), and a fair contract statement is all it needs to reproduce it. The moat is irrelevant here: the algorithm is withheld from the *compiler*, not from the *model*. Extract Method FAILS this — same family as `well-known-spec-features-are-ceiling-bound` (api-gateway-http-cache) and the `over-clarity-vs-ambiguity` call-hierarchy enumeration.

**Selection screen (add to the kill questions):** after confirming the algorithm is compiler-withheld, ask the SECOND question — *is the algorithm itself one a thorough model already knows (a named refactoring, a textbook analysis, a published spec)?* If yes, a fair description telegraphs it and the ceiling is ~1.0 regardless of the moat. The only rescue is a repo-specific twist where the obvious (known) design is WRONG and the wrongness is discoverable without being stated — and on a famous refactoring that twist usually collapses into either a telegraph (fair but easy) or an arbitrary/unfair fork (the death spiral).

**Deepener caution:** a deepener that is a MORE-obvious design (Extract Method's two-live-out → record-return + destructure, which is exactly what modern IDEs do) adds LoC, not ceiling. Verify a deepener raises the *ceiling*, not just the volume, before counting it.

**Process win:** caught at W2 slice cost (a few hours + a zero-context gauntlet), not after a full build + QA. The Gate-C gauntlet is the cheapest possible detector for this class — run it on EVERY famous-operation idea before W3. n=1 is sufficient for a SOLVE (existence proof in the kill direction); it would not be for a fail.

## Confirming evidence (2026-06-27, java-replace-inheritance-with-delegation, n=2 — a DIFFERENT operation, same kill)

Replace Inheritance with Delegation was the next `rewrite/`-stub Diamond candidate, selected precisely because its derive-not-recall corner — the **down-call / SELF problem** (the famous refactoring is *actively unsound* when the delegate runs a superclass method that self-calls a method the class overrides) — looked LESS telegraphable than pure liveness: the textbook steps "create a field, forward the methods" deliberately SKIP it, so the model's recalled architecture is the wrong one, and detecting it requires a **transitive call-graph closure over the superclass's own method bodies** (compiler-withheld; no call-graph/down-subtype API). The bet was that this closure is harder to *assemble* than a single named dataflow pass.

The W2 Gate-C gauntlet refuted the bet. A fresh zero-context agent (fair description only) built the FULL contract in ~37 min, **including the transitive down-call closure** — virtual-vs-`super.` self-call distinction, cycle-guarded, passing a 1-hop AND a 3-hop dispatch-back reject AND a non-overridden-self-call negative control — plus generics substitution, protected→public, constructor-arg threading, all three rejects, and the whole transport. 9/9 own run-equivalence tests green, HIGH confidence on the core. Independently consistent with a borderline-thin Gate-B (slice ~544 non-empty, core thinner than extract-method's 485-effective — the javac primitives collapse the analysis: the down-call closure is ~40 LoC of BFS).

**The sharpened rule (why the "subtle algorithm" defense fails).** A behavior-preserving refactoring's REJECT condition must be stated in a fair description (omitting it is the ambiguity killer). Once the *trigger* is stated as an outcome — "rejected when a member the delegate runs would have dispatched back into a method this class overrides" — a thorough agent reconstructs whatever analysis computes that trigger, **no matter how subtle the analysis is** (transitive call graph, alias-free SELF reasoning, JLS 6.6.2 accessibility). The ceiling is set by whether the CONTRACT is recallable+stateable, not by the implementation difficulty of the analysis behind it. Subtlety of mechanism ≠ difficulty of derivation when the goal is handed over. The only edges the gauntlet missed were genuine spec-open under-approximations (implicit `Object`-method uses; dispatch-back through an aliased `this`) — 1-2-test edges, never a cascade, and unfair to grade if unstated.

**Selection consequence.** For ANY famous refactoring on a behavior-preservation seam, the kill question is now: *is there a hard corner whose TRIGGER need not be stated to be fair?* If the difficulty lives in a reject/behavior condition the description must name, it telegraphs — independent of how hard the underlying analysis is. Down-call/SELF was the strongest such corner on the delegation operation and it still telegraphed. Treat the entire `rewrite/`-family famous-refactoring vein as ceiling-bound; stop mining it (see `repo-selection.md` portfolio rule).

## Bar dependency
Tied to the current Diamond partial-reward ceiling in `rules/platform-bar.md`. If that bar loosens materially, re-validate.
