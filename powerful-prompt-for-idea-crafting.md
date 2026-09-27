# Craft a NEW Diamond-tier problem from the Java Language Server repo — and make it one that gets ACCEPTED

You are starting fresh. You have **zero prior context** on this effort, and that is fine — this
document is your full briefing. Your job is **one thing**: craft a single, original, genuinely hard
Diamond problem idea on the **Java Language Server** repo, and write it up as
`my-work/java-language-server-<problem-name>/<problem-name>-plan.md`. You do **not** implement it
yet. You produce the plan, and that plan must prove — to a skeptic — that the idea will survive the
gauntlet that has chewed up our other problems.

Read this whole document before you touch anything. Then read everything it points you to. The
single most important outcome is not that you "followed the rules" — it is that you walk away with a
**deep, internalized SENSE of what an accepted Diamond problem feels like, and what a doomed one
feels like**, and that this sense is visibly baked into the plan you write.

---

## 0. Why this document exists (read this part slowly)

We have built many Diamond problems. A few were **accepted quickly, with almost no design friction**
(`sorg-newsletter-delivery-snapshots`, `java-move-class-to-package`, `sorg-atom-media-ownership`,
`anko-try-expression-fork`). Several others have been **stuck for many painful iterations**, fighting
a new fairness flag or "too easy" verdict every single round (`osctrl-carve-integrity`,
`osctrl-secret-rotation-windows`, `sorg-search-index`).

We have studied both groups forensically. The conclusion is blunt and it is the thesis of this
entire document:

> **Almost every block we hit downstream was actually born at the idea-crafting stage.**
> A weak core idea cannot be rescued by clever tests, careful wording, or more iterations. It forces
> you to manufacture difficulty — by padding breadth, by smuggling hardness into ambiguous text, by
> asserting an implementation choice, or by contradicting the repo's real behavior — and **every one
> of those manufactured-difficulty moves is exactly what the Fairness judge and the human reviewer
> flag.** Then, when you sand off the unfairness, the manufactured difficulty collapses and the
> problem grades "too easy." That is the death spiral. It is unwinnable from inside. The only way to
> win is to **never enter it — by picking an idea with real, intrinsic, structural depth.**

So your real deliverable is not "a plan." It is **a correctly chosen idea**, with a plan that proves
the choice. If you pick wrong, no amount of plan polish saves you. Spend your effort on selection.

---

## 1. The SENSE you must build (the prime directive)

Before any rule, internalize what an accepted problem actually *is*. From the four accepted
exemplars, here is the shape — memorize it:

1. **The feature sits on a seam that ALREADY EXISTS in the repo.** It is a natural extension of a
   subsystem that is already there, not a foreign thing grafted on. (Newsletter: the repo already
   renders web pages at build time and *re-renders email independently at send time* — that split is
   literally where drift happens. Move-class: the repo already has a `rewrite/` refactoring package
   hosting rename/override actions, so a new refactoring is a sibling, not an invader.)
   **Litmus:** name the exact base subsystem/split your feature extends. If you cannot, it is
   grafted, and grafted features generate fairness flags.

2. **The difficulty is DISTRIBUTED across 4+ genuinely INDEPENDENT engineering concerns**, each of
   which, when an agent gets it wrong, produces a *different* class of test failure. The two
   fastest-accepted problems both attribute their failures to 4 disjoint root causes hitting
   *different* runs — never one shared gotcha. (Newsletter: path-canonicalization fingerprint /
   ownership-scoped cleanup / cross-process persistence / text-from-snapshot-not-Markdown.
   Move-class: omitted-cursor default / command id / Javadoc simple-name expansion / empty-package
   rejection.)

3. **The intuitive implementation is ARCHITECTURALLY WRONG**, and only a real, repo-aware design
   survives. (Move-class: "find-and-replace the package string" loses nearly every edge; only a
   compiler-backed symbol-resolution implementation works — and a single distractor fixture, a local
   variable named like the moved type, converts the whole suite from string-matching to semantic
   resolution.)

4. **The tests assert the observable CONTRACT, never an implementation choice — and two genuinely
   different faithful implementations both pass.** This is provable and was proven in the accepted
   work: the newsletter reference uses a `.snapshot.json` sidecar, but a passing agent run used an
   in-file fingerprint marker instead — both correct, both pass. Move-class accepts either a thrown
   error or a returned `ResponseError`. **If only your exact implementation can pass, you have built
   an unfair test, not a hard problem.**

5. **The description is natural behavioral prose stating OUTCOMES**, with zero mechanism hints and
   zero rigid "## Test Assumptions" sections. Length is fine *if every clause is load-bearing for
   fairness* (move-class is 528 words and was endorsed because every requirement is needed to make a
   hidden test fair). But a **single misleading word that telegraphs pre-existing behavior is a
   BLOCKING defect** — atom-media's "still take precedence" falsely implied the feed already honored
   an override; it inflated the pass rate via reading-comprehension and was flagged as "more
   ambiguity than genuine hardness." Difficulty must come from engineering, never from a word.

6. **Every failure an agent makes maps to an EXPLICIT-or-INFERABLE requirement** — no shared blind
   spots, no trivia, no environment friction ("no agents failed to find the test runner or
   compile"). Accepted pass rate is **10–20%**, and the reviewer's decisive test is: *do all
   failures map to legitimate missed requirements rather than unfair expectations?*

7. **The reference solution is substantial, idiomatic, repo-faithful, and free of dead code / diff
   noise / telegraphing.** Difficulty is carried by genuine logic across layers, never by padding.

Hold these seven in your head as a single gestalt. When you later look at a candidate idea, you
should be able to *feel* whether it has this shape or whether you'd be forcing it. That feel is the
point of this whole exercise.

---

## 2. The anti-patterns that KILLED our struggling problems (study these as hard as the wins)

This is the other half of the sense. You must be able to recognize these from the inside, because
they are seductive — each one *looks* like difficulty while you're building it.

**(a) LoC / breadth as a vanity metric.** All three strugglers were selected partly to hit a line
floor (carve-integrity "~800–900", secret-rotation "1000+", search-index "700+"). Breadth does not
equal difficulty — **breadth equals fairness surface.** Carve-integrity's 7-behavior, 33-test sprawl
is *precisely why* it surfaced a new fairness coin-flip every single round (reclamation placement →
local backend → sync-vs-async → integrity_axis value → retry-cap off-by-one). LoC must be an
**output** of genuine independent forks, never an input you design toward.

**(b) A fork that shifts or contradicts BASE repo behavior.** Secret-rotation's headline freshness
clause "required behavior the repo does not have" and contradicted a *deliberately documented,
security-reviewed* 2-hour cache TTL — instantly unfair. Carve-integrity asserted a *synchronous*
response where base osctrl is *asynchronous* (`go ProcessCarveBlock`), and seeded a storage
representation base doesn't establish. **Every fork's "correct" answer must be inferable from, or
consistent with, how the repo actually behaves. Pre-verify this in source before you commit.**

**(c) A fork that is an ARBITRARY CONSTANT or otherwise UNOBSERVABLE.** Carve-integrity's retry cap
("after three failed attempts") is a guessed integer with no repo convention and only reachable
through a hidden failure path — the textbook UNFAIR_PROBLEM_STATEMENT. Search-index's tokenization
and excerpt rules were under-specified text conventions ("split from surrounding punctuation") that
judges ruled ambiguous three runs running. **A fork must grade a real decision the test surface
SIGNALS. If the answer is an arbitrary value, you must state it — and if stating it makes the problem
trivial, then it was never difficulty.**

**(d) A "leaf value" with no derived state — breadth-capped.** Secret-rotation's enrollment secret
is a leaf: no cascade, no derived state, no downstream consumers beyond a one-line fork. It was
*empirically proven* breadth-capped (7 of 8 failures collapse onto one subtle reading; everything
else passes ~90–100%) and is now recommended for ABANDON. **Pre-screen: does your central artifact
have derived state / a cache / a cascade / cross-component consumers that a naive design gets WRONG?
If it's a leaf, the ceiling is one fork and you will fight the explicitness-vs-ambiguity tension
forever.**

**(e) "Compute-and-emit" with no state / ownership / lifecycle.** Search-index recomputes everything
from the in-memory input and writes it out — so "there is no owned state to get wrong, which is
exactly why agents pass." Every structural fork was solved by ~everyone (64–66/68). The fix the docs
converged on is to bolt on owned, persisted state with **ownership + lifecycle + cross-process
reconciliation** — the newsletter/atom-media model. **If your feature just transforms input→output in
one pass, every agent solves every fork. Difficulty lives in persisted state that survives across
runs and must be reconciled: what to keep, what to delete, who owns it, what's stale.**

**(f) A feature whose natural home is UNTESTABLE by a base-symbols-only test.** Carve-integrity's
founding disaster: reclamation was specified as a background daemon sweep, so 34/34 agents built it
correctly *in the daemon loop* — which a base-symbols-only test cannot run — and 0/34 passed. The
"fix" (grafting an artificial explicit operator endpoint to make it drivable) carried ambiguity
downstream for months. **Before selecting, ask: what synchronous, base-named entry point drives this
feature, and what base-readable state observes it? If the honest answer is a daemon loop, an async
goroutine, or "you'd have to run the server's background thread," the idea is mis-shaped for the
harness.**

The unifying signature of all six: **"uniform failure on a fork that has a reasonable alternative
reading" = graded a DEFECT**, and its inverse **"all-pass compute-and-emit" = graded too-easy.** Both
are born at idea selection. Your job is to pick an idea where the hard forks are
*implicit-but-discoverable* (the test surface signals the right design) rather than
*arbitrary-and-unobservable* (a guessed constant) — because depth is what lets a fork be discoverable
instead of a coin-flip.

---

## 3. The brutal-honesty mandate (do NOT evaluate your idea optimistically)

This is where we keep fooling ourselves, so read it twice. **In theory, almost every idea sounds
hard. In practice, the implementation turns out to be something a weak agent solves in one pass —
certified rubbish dressed up as a Diamond.** Your analysis must be adversarial against your own
idea, not advocational.

Concretely, before you commit to a direction:

1. **Write the SIMPLE/NAIVE version in your head (or as a sketch) and ask: would it pass 80%+ of the
   tests you'd write?** If yes, the idea is fundamentally too easy. (idea-crafting.md "Bypass
   Validation".) This single question kills most bad ideas.
2. **For each claimed fork, run the bypass test:** Can a capable agent solve it in under 20 minutes?
   Does it produce a *different* failure than the other forks, or do they all reduce to the same one
   move ("add a context parameter")? Six traps that reduce to one insight is a **one-fork idea.**
3. **Assume the repo hands the agent strong primitives.** The Java LS gives agents
   `elements.overrides`, `trees.getElement`, the full JDK compiler API. Call-hierarchy learned that
   "clearly-stated mechanical contracts add no difficulty — the population just implements them"
   and a *fairness fix RAISED* its pass rate to 7/10. If the JDK compiler API does the hard part for
   the agent, your "difficulty" is a speed bump.
4. **Knowledge-transfer check:** if the feature maps to a well-known LSP/IDE feature the model has
   seen a thousand times, the agent gets a massive head start. You need a **repo-specific twist where
   the obvious pattern actively misleads** (semantic-tokens found one: the repo's only coloring is a
   misleading 2-category custom `java/colors` notification, the wrong protocol shape; and javac
   reports unresolved names as a static class, so the naive resolver ships *visibly wrong* output).
5. **Use replay as a lower-bound gap-finder, never as a pass-rate oracle.** Estimating "this will be
   2/10" from theory is the optimism trap. The honest signal is: build the minimal package, and let
   a fresh measurement (or at minimum a naive-version self-implementation) tell you it is NOT
   trivially solvable. A plan that asserts difficulty without an empirical or source-grounded
   argument is worthless.

If you cannot, with a straight face and source evidence, explain *why a strong agent's first
reasonable implementation is architecturally wrong on 4+ independent axes*, you do not yet have a
Diamond. Keep looking. It is far cheaper to discard an idea now than after building 1,000 lines.

---

## 3.5 The implementation-VOLUME mandate (read this as hard as §3 — it is the trap that caught Encapsulate Field)

§3 makes you adversarial about whether the idea is hard to GET RIGHT. This section makes you
adversarial about whether it is hard to BUILD. They are **different axes**, and the platform grades
the second one explicitly — yet our doctrine had no filter for it, and that is exactly why a heavily
difficulty-emphasized prompt still produced a ~450-line solution.

**Difficulty has two independent axes:**
- **Recognition difficulty** — the agent must DISCOVER a non-obvious design (which context, which
  order, which edge). The §1–§3 fork/bypass filters all measure this.
- **Implementation volume** — the CORRECT design is a large amount of genuine, non-trivial code: an
  analysis the compiler does NOT hand over, a real algorithm, a whole subsystem. **The platform's LoC
  floor (~850 non-empty) and the long-horizon median-LOC gate measure THIS**, and a thin solution is
  graded under-scoped / too-easy **no matter how many forks it has.**

**The failure mode (carve-integrity, and now Encapsulate Field):** a feature can be recognition-hard
and implementation-thin. Encapsulate Field has 8 genuinely independent forks — and its honest
solution is **451 non-empty LoC**, because **each fork is a 10–30-line branch the repo's primitives
make trivial once recognized** (`read → getX()` is one line; the JDK gives you the parent tree, the
element, the source positions). Eight small branches sum to ~450, not ~850. carve was identical:
hard to balance, simple to implement — "the effective solution was simple."

**The contrast that defines the target (move-class, ~1100):** every move-class "fork" is a
SUBSTANTIAL chunk — the Javadoc/DocTree walker (~110), the cross-file package-private access scanner
(~80), import rewriting in six forms (~100), the `executeCommand`+capability+`RenameFile` transport.
Each fork is BOTH recognition-hard AND a real algorithm/subsystem. That is why its LoC is an honest
output of its depth, not a number anyone targeted.

**Run the per-fork VOLUME test on EVERY fork (alongside the §3.2 bypass test):**
> "Does this fork's CORRECT implementation require substantial, non-trivial code — an analysis the
> compiler does NOT give you, an algorithm, a cross-file traversal, a subsystem — or is it a small
> branch once I know what to do?"

If most forks are small branches, **add up the honest sum now: it is thin.** Forks make a problem
FAIR and distributed; they do **not**, by themselves, make it voluminous. A 6-fork idea where every
fork is a 15-line branch is a ~150-line core wearing a fork count as a costume.

**The codeforces principle — the shape to hunt for.** The strongest Diamond is a **small, clearly
stated CONSTRAINT that forces a difficult ALGORITHM with many edge cases** — exactly like a
competitive-programming problem where changing one condition turns an easy task into one that needs a
hard algorithm and a dozen edge cases. Difficulty-by-algorithm produces genuine volume AND the
"fix-X, then Y breaks, then Z breaks" cascade we are chasing; difficulty-by-many-small-recognition-
branches produces neither. When you weigh a candidate, ask: **what single stated constraint forces
the agent into a real algorithm here?** (Encapsulate Field's missing one, found only after a thin
build, is "behaves EXACTLY as before — evaluating every subexpression once and in source order,"
which forces side-effect/evaluation-order analysis + temp extraction + statement sequencing, a
genuine ~250-line algorithm. The original framing never stated it, so the build came out thin.)

**VALIDATE the volume empirically — do NOT estimate it from theory. This is the concrete fix for the
recurrence.** The §9-style per-file LoC table is an ESTIMATE, and our estimates run ~40% optimistic
(Idea 1 estimated ~850; honest build 451 — it even counted a `JavaCompilerService` prefilter that
`findMemberReferences` already provides). Before you freeze an idea and hand it to a weak executor:
> **Build the single hardest fork — or a skeleton of the two or three hardest — in a throwaway
> worktree, and MEASURE its real effective LoC (non-blank, non-brace, non-comment).** If the hardest
> fork is 30 lines, the whole feature is thin. Deepen the idea (add the algorithmic constraint) or
> change ideas NOW, before ~1000 lines of test+solution are written against an under-scoped core.

This is the same "measure, don't assume" rule the naive-replay applies to *difficulty*, applied to
*volume*. The plan you hand over must report the **measured** hardest-fork LoC and the **stated
constraint that forces the algorithm**, not a per-file estimate table. A plan that asserts ~850 from
a summed estimate, with no built-and-measured hardest fork, is not validated — treat its number as
fiction until a worktree proves it.

---

## 4. Your reading list (do ALL of it — this is non-negotiable)

You will not develop the sense by reading summaries. Read the primary artifacts and their full
history. Paths are under `/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/`.

### 4.1 The doctrine (read first, but treat the SENSE above as the spirit these serve)
- `.agent/rules/idea-crafting.md` — the core: structural vs decorative difficulty, independent
  forks, the bypass-validation step, the required `{problem-name}-plan.md` output schema.
- `.agent/rules/` — also `idea-implementing.md`, `description-writing.md`, `solution-writing.md`,
  `test-writing.md`, `patch-generation.md`, `reviewer-notes.md`, `shipd-core-principles.md`,
  `zero-pass-remediation.md`, `finalized-agent-evaluation.md`.
- `.agent/workflows/` — `craft-idea.md`, `implement-idea.md`, `generate-patches.md`,
  `review-work.md`, `handle-ai-report.md`, `handle-human-review.md`, `handle-initial-checks.md`.
- `standards/WORKFLOW.md` — the single source of truth: target metrics, the 8-step lifecycle, the
  uniqueness preflight, the structural-vs-decorative doctrine, every deliverable's standard.
- `standards/Olympus-Diamond-Tier-Failure-Analysis-Guide.md` — the pipeline (Prechecks → Diamond
  Checks → Castor ≤30% → Auto Review → QA) and the four required QA artifacts.

### 4.2 The ACCEPTED exemplars — study WHY they passed (this builds the positive sense)
Read each one's description, `*-plan.md`, `*-ai-evaluation.md`, `*-human-reviews.md`,
`*-diamond-checks.md`, `*-diamond-artifacts.md`. Path:
`my-work/Accepted/diamond-submissions/sprint2/`.
- **`java-move-class-to-package/`** — the large-feature Java-LS gold standard (20%, ~1,100 lines,
  ~13 forks, accepted in one design round). Note especially the per-group "Why it is fair" with
  verbatim prompt quotes, the distractor-fixture trick, and that the only friction was QA paperwork.
- **`sorg-newsletter-delivery-snapshots/`** — THE model for state/ownership/lifecycle difficulty
  (10%). Note its explicit `## Independent Semantic Forks` and `## Bypass Analysis` tables, and the
  proof that two different ownership representations both pass.
- **`sorg-atom-media-ownership/`** — same lifecycle/ownership shape (20%), and the cautionary "still"
  word that was a BLOCKING ambiguity defect — learn what telegraphing looks like.
- **`anko-try-expression-fork/`** — genuine language-runtime depth (20%), the riskier
  *concentrated* difficulty model that survived only on triple-stated explicitness; learn why
  distributed is safer than concentrated.

### 4.3 The STRUGGLING problems — study WHY they bled (this builds the negative sense)
Read each one's `*-next-plan.md`, `*-diamond-checks.md`, `commit-message.txt`, `onboarding-doc.md`,
`*-plan.md`. Path: `my-work/`.
- **`osctrl-carve-integrity/`** — the cautionary epic. Trace all 8 rounds in its `onboarding-doc.md`
  history section. It hits anti-patterns (a), (b), (c), (f). Feel how breadth created an endless
  fairness treadmill.
- **`osctrl-secret-rotation-windows/`** — the leaf-value / explicitness-death-spiral case,
  anti-patterns (b) and (d); now recommended for abandon. Read its `*-diamond-checks.md` "too easy"
  Env-Linter flag and the human review where the freshness clause "requires behavior the repo does
  not have."
- **`sorg-search-index/`** — the compute-and-emit case, anti-pattern (e). Read how every structural
  fork was solved by ~everyone and the fix was to bolt on ownership/lifecycle (the newsletter model).

### 4.4 The Java-LS in-flight siblings — for UNIQUENESS (you must not overlap these)
- `my-work/java-semantic-tokens/` and `my-work/java-call-hierarchy/` — read their plans and current
  status. Both are *fairness-clean but fighting the difficulty knob* (semantic-tokens 5/10,
  call-hierarchy 7/10 — both "too easy" because the JDK compiler API does the work). Learn from their
  struggle: **on this repo, the resolver is so strong that a "stated mechanical contract" adds no
  difficulty.** Your idea must force decisions the compiler API does NOT hand over for free.
- `java-tmp-plan.md` (at the Olympus root) — the existing Java-LS candidate menu. Read it; two of its
  three ideas are now consumed, and it flags which remaining ones are cohort-adjacent/breadth-capped.

### 4.5 The repo itself — deeply, in source, not by filename
Clone facts (confirm against the docs above):
- Repo: `github.com/georgewfraser/java-language-server`, base commit
  `eee7904717f8b626c0c6d7cdc9d468f21765a4ca`. A shared read-only clone is at
  `Shipd - Olympus/repos/java-language-server` — **never edit it**; make a detached worktree for
  exploration.
- Build/test: Maven, **JDK 21** (repo `pom.xml` says source 20), JUnit4 + Hamcrest, offline `~/.m2`.
  Heavy build (~140s) — run ONE `mvn` at a time, cap heap (`-Xmx1g`), `rm -rf target` between runs.
- Test harness: prefer the **LSP-wire transport** (drive the server over JSON-RPC, read results by
  LSP-standard JSON field names so no internal DTO class is load-bearing). Bind tests by handler
  **method name**, never by `Class.forName` on an internal param type (that was a call-hierarchy
  fairness block). Tests must **compile on base and fail at runtime** there.
- **Already implemented in the repo's `rewrite/` package (so they are PARITY, not net-new — do NOT
  propose them):** extract method/variable/constant, inline method/variable/field, rename, implement
  abstract methods, override inherited method, generate constructor, add/remove parameter,
  organize/auto-fix imports, and ~15 quick-fix code actions. Many providers are already advertised
  (hover, completion, signature help, references, definition, document/workspace symbol, formatting,
  code lens, folding range, code action, rename, the custom `java/colors`).
- **Confirmed ABSENT providers (genuine candidate territory):** `inlayHintProvider`,
  `typeHierarchyProvider`, `implementationProvider`, `typeDefinitionProvider`, `declarationProvider`,
  `documentHighlightProvider`, `selectionRangeProvider`, `linkedEditingRangeProvider`,
  on-type/range formatting. **Verify each against the live `src/main` before relying on it** — grep
  for the provider registration; do not trust this list blindly.

---

## 5. Uniqueness constraints (hard requirements)

Your idea must be clearly distinct from the **three** Java-LS problems already in the cohort:
1. **Move Class to Package** (accepted) — `workspace/executeCommand` refactoring producing a
   `WorkspaceEdit`/`documentChanges`. Anything sharing refactoring-edit machinery is cohort-adjacent;
   the menu explicitly warns Pull-Up/Push-Down is "too close to Move Class — do not submit adjacent."
2. **Semantic Tokens** — `semanticTokens/full|delta|range`, classification + delta encoding.
3. **Call Hierarchy** — `prepareCallHierarchy`/incoming/outgoing, the override/dispatch graph.

Do not overlap their LSP surface, their subsystem, or their semantic traps. Note the structural
cousins: Type Hierarchy shares Call-Hierarchy's prepare→up/down graph shape; Implementations
overlaps Call-Hierarchy's override set; Linked-Editing/Document-Highlight lean on existing
rename/reference machinery and risk leaf-value thinness. **A different LSP method is necessary but
not sufficient — the difficulty must come from a different place too.** Run the platform uniqueness
preflight early (idea-crafting.md §"Platform Uniqueness Preflight"); a flagged duplicate means pivot,
not reword.

When you weigh candidates, apply the section-2 and section-3 filters relentlessly. The promising
territory tends to be where the feature needs **state the compiler API does not hand you** — e.g.
workspace-wide *downward* traversal the repo lacks (it only walks up), reverse type-inference
printing with no declared type to read, or a reconciliation the resolver can't do alone. The thin
territory tends to be single-target navigation, tree-walk-and-emit ranges, and anything already
living in `rewrite/`. Decide with source evidence, not with this paragraph.

---

## 6. Your deliverable: `<problem-name>-plan.md`

Create `my-work/java-language-server-<problem-name>/` and put ONLY this plan in it until the owner
approves implementation. Follow the output schema in `idea-crafting.md` §"Output" — and on top of
that mechanical schema, the plan MUST make the **SENSE** explicit. Required contents:

1. **3 validated ideas (or a clear shortlist), then one deeply-developed selection**, with a
   comparative ranking table justifying the pick.
2. For the selected idea, the idea-crafting.md sections: What It Is (with wire/behavior examples);
   Why It's Hard At Its Core (architectural conflict with **file:line evidence from the actual
   repo**); the **Independent Semantic Forks** table (4–6+, each causing a DIFFERENT failure); Layer
   Spread (files × LoC, target genuine 700+ non-empty as an *output* of the forks); Local Overlap
   note; **Bypass Resilience** table (each shortcut → why it fails → the counter-test); "Core Insight
   Then Mechanical?" assessment; Knowledge-Transfer risk table; comparison to the
   architecture-incompatibility pattern of the accepted work; the preflight plan; draft title +
   draft description.
3. **A dedicated "Why this will be ACCEPTED" section** that walks the seven properties of §1 and
   shows, point by point with repo evidence, that this idea has each — and a **"Why this will NOT hit
   our known anti-patterns" section** that walks §2 (a)–(f) and shows this idea dodges each. This is
   the "sense, made explicit." A plan without it is incomplete.
4. **An empirical/adversarial difficulty argument** per §3: the naive-version pass-rate honest
   estimate with reasoning, the per-fork bypass analysis, and the plan for the minimal preflight
   package that will let a real measurement confirm (not assume) the difficulty before deep build.

Once the owner approves and implementation begins, the `*-plan.md` becomes immutable (a
`*-next-plan.md` is only created later if review data demands a strategic change).

---

## 7. Definition of done for THIS task (the idea stage)

You are done when you can hand the owner a `<problem-name>-plan.md` for which **you yourself, playing
the harshest skeptic, cannot answer "yes" to any of these:**
- Could a strong agent's first reasonable implementation pass 80%+ of the tests?
- Do my 4+ "independent" forks actually collapse into one insight?
- Is any fork an arbitrary constant, an unobservable choice, or a contradiction of base behavior?
- Is the central artifact a leaf value, or a compute-and-emit pass with no owned state?
- Does the feature's natural home require a daemon/async/background path a base-symbols test can't
  drive?
- Does this overlap the surface OR the difficulty source of move-class / semantic-tokens /
  call-hierarchy?
- Is my "this is hard" claim theoretical optimism rather than a source-grounded, bypass-tested,
  preflight-confirmable argument?
- **(VOLUME) After the core insight, is each remaining fork a SMALL BRANCH the repo's primitives make
  trivial — i.e. recognition-hard but implementation-thin?** If yes, the honest LoC will be thin and
  the platform will grade it under-scoped no matter the fork count (the Encapsulate Field / carve
  failure mode). The cure is a single stated CONSTRAINT that forces a real algorithm, not more
  small branches.
- **(VOLUME) Is my LoC an unvalidated ESTIMATE rather than a number I MEASURED by actually building
  the hardest fork in a worktree?** If you have not built-and-measured the hardest fork, you do not
  know the volume — and our estimates run ~40% high.

If every answer is an honest "no," you have something worth building. If any is "yes" or "I'm not
sure," keep crafting — that is the cheapest hour you will ever spend on this problem.

Now go read everything in §4, explore the repo in source, and craft the idea. Take the time. The
goal is not to produce a plan fast; it is to produce **the right idea** — one with the unmistakable
shape of the problems that got accepted, and none of the shape of the ones that bled.
