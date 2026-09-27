---
description: Guidelines for crafting novel, hard problem ideas that compete with accepted work and even beat them
---

# Idea Crafting

Pass-rate examples below are historical heuristics, not current platform gates. Read
`false-positive-calibration.md` and `my-review-workflow/rules/platform-panel.md` before calibrating
an active task.

## Core Philosophy

> **"Difficult and Clear is the way to success."**

A good idea is hard at its core—not something you make hard through iterations. The difficulty should be inherent in the problem domain, and being open to expanding or adding some conditions to be more difficult is also good, but main idea must be complex and hard.

---

## The Two Types of Difficulty (Structural vs Decorative)

This is the single most important concept in idea crafting. Every decision must be filtered through this lens.

### Structural Difficulty (GOOD — Concrete Foundation)

The problem's core requires the agent to discover that the existing architecture is fundamentally incompatible with the new feature. The difficulty is INHERENT — it can't be removed by simplifying the tests or description.

**Characteristics:**
- The intuitive/obvious implementation approach is architecturally WRONG
- The agent must redesign or deeply integrate across multiple layers
- Removing "tricky" tests wouldn't make the problem easy — the core challenge remains
- The difficulty survives human review without needing artificial complexity

**Examples from accepted work:**
- Interaction between two subsystems where the intuitive single-step approach forces recursive chaining through exception handlers
- A feature requiring fundamental redesign of an existing model because the current architecture CANNOT support the new behavior (e.g., static defaults needing to become runtime-evaluated)

### Decorative Difficulty (BAD — Matchstick Building)

The problem's core is architecturally straightforward, but you add tricky edge-case tests, behavioral traps, or confusing descriptions on top. The difficulty is GRAFTED ON — a human reviewer can remove it by flagging tests as unfair.

**Red flags of decorative difficulty:**
- The basic feature implementation is correct on first try by most agents
- Difficulty comes from ONE behavioral subtlety (like iteration convention) that cascades test failures
- Tests that trap agents via panic cascades rather than genuine implementation gaps
- Difficulty tricks BORROWED from other problems rather than inherent to this one
- Adding 12 more edge-case tests catches ZERO additional agents — the fundamental approach is too simple

**Cautionary tale pattern:**
- v1: 70% pass rate (too easy)
- v2: 60% pass rate after adding 12 trap tests (caught zero agents)
- v3: 10% pass rate after borrowing a behavioral trick from another problem (fragile, single failure mode)

> **Your ideas MUST have structural difficulty.** Every idea must have at least one point where the intuitive/obvious implementation approach is architecturally WRONG and requires fundamental rethinking. If you can't identify such a point, the idea is not hard enough — no amount of clever tests will save it.

---

## Hard Version vs Simple Version

Many ideas can exist in both a "hard" and "simple" form:
- **Some hard ideas CAN be implemented simply** — e.g., operator protocol where the context fork is a ~20 min discovery, then the rest is copy-paste. The idea SOUNDS hard but has a simple path.
- **Some simple ideas CANNOT be made hard** — no amount of conditions or test traps can elevate them.

The critical question: **"After the agent discovers the core insight, is the rest mechanical or does it require MORE independent decisions?"** If it's mechanical (repeating the same pattern 6-7 times), the idea is not hard enough.

---

## Independent Semantic Forks (Key Metric)

Count the number of **independent** design decisions an agent must get right:
- Each fork should cause DIFFERENT test failures when wrong
- Forks should NOT be "the same pattern repeated" (that's ONE fork, not many)
- Target: **4+ independent forks** for a hard problem

| Fork Count | Assessment |
|------------|------------|
| 1-2 | Too easy — agent solves core then coasts |
| 3 | Borderline — might reach 4-5/10 pass rate |
| 4-5 | Structurally promising; measure against the current tier mix and live bar |
| 6+ | Ideal — deep difficulty |

> **Key learning**: An idea with 6 traps that all reduce to "add context parameter" is effectively a 1-trap idea. Count INDEPENDENT forks, not total traps.

---

## Well-Known Pattern Risk (Critical)

Some concepts are so heavily documented that AI agents have near-perfect pattern matching for them:
- Python `__dunder__` methods (operator overloading)
- JavaScript generators/iterators
- Go-style `defer`
- Rust-style pattern matching basics
- While/for loops (basic control flow)
- Try/catch/finally (basic exception handling)
- Python list comprehensions
- Hooks / middleware patterns

If the idea maps directly to a well-known pattern from a popular language, the agent gets a massive head start. The idea must have a **repo-specific twist** that makes the well-known pattern inapplicable or misleading.

### Knowledge-Transfer Risk Analysis (Required)

For every idea, explicitly analyze what happens when an AI agent searches for analogies:

| Language | Analogous Feature | Why Transfer Fails in THIS Repo |
|----------|-------------------|--------------------------------|
| Python | ... | ... |
| JavaScript | ... | ... |
| Go/Rust | ... | ... |

If the agent can successfully copy a known pattern with minimal adaptation, the idea is too risky. The best ideas are where knowledge transfer from other languages **actively misleads** agents into wrong architectures.

---

## What Makes Ideas Hard

### Multi-Layer Architecture (Required)

Problems MUST touch multiple architectural layers:

| Layers | Difficulty | Example |
|--------|------------|---------|
| 2-3 | Too easy | Single-file fix |
| 4 | Minimum | Good starting point |
| 6-8+ | Ideal | Most accepted work |

### Architecture Incompatibility Pattern (Most Successful)

The strongest ideas have this shape:
1. **A surface feature that seems approachable** — agents can start implementing confidently
2. **A deep cross-layer interaction** — where the feature's behavior conflicts with an existing subsystem's assumptions
3. **An intuitive approach that is WRONG** — the obvious implementation breaks tests requiring fundamental rethinking
4. **Multiple INDEPENDENT decisions after the first insight** — so solving one trap doesn't unlock all the others
5. **No direct analogy in well-known languages** — agents can't copy patterns from Python/JS/Go/Rust

### Implicit Complexity

Hard ideas have complexity that's not obvious from the surface:
- Scope and state management across layers
- Lifecycle and timing issues
- Configuration/context propagation across subsystems
- Edge cases that trip naive implementations
- Require deep investigation in the repo codebase
- Need to be knowledgeable about the repo's specific architecture

### Novel Domain

The idea must be unique:
- Not copying patterns from previous work
- Not a well-known fix (null checks, type guards)
- Not documented online (PRs, blog posts, SO)
- Share a unique aspect to this repo specifically
- No knowledge transfer from other well-known concepts

---

## Solution Patch Size — The More, The Better

The solution patch size correlates directly with problem robustness. Targets:

| Target | Why |
|--------|-----|
| **700+ non-empty LoC** | Diamond floor (900-1200+ ideal); 400 is the retired baseline |
| **7+ files** | More layers = more independent decisions |
| **900+ patch lines** | Including hunks, context — our best problems are here |

A larger, multi-layer solution means:
1. More opportunities for agents to make independent mistakes
2. More files that must be consistent with each other
3. Harder to short-circuit with pattern matching from known languages
4. More likely to survive human review without needing artificial difficulty layering

---

## Analysis Process

### Required Reading

Before crafting any idea, read:
1. `standards/WORKFLOW.md` - Full standards
1a. `olympus-platform.md` - official repo, description, test, solution, Dockerfile, and process requirements
2. 2-4 local accepted/waiting examples with FULL history (if available)
3. All rules and workflows under .agent directory
4. The actual repo codebase — deeply, not superficially

### History Analysis (Essential)

For each version (v1, v2, ..., vN) of local reference problems (if available), read:
- Commit message - What changed and why
- Description - How they phrased it
- Test patch - How they designed traps
- Solution patch - How they solved from roots
- Auto-review JSON / legacy AI report - What worked/failed
- Agents-run artifacts - Per-agent verdicts, trajectories, XML, and solution patches
- Human reviews - Feedback patterns

> This reveals what causes iterations and what works on first try.

### Codebase Investigation (Non-Negotiable)

Read the ACTUAL source code, not just file names. Look for:
- **Architectural constraints** that would CONFLICT with a new feature
- **Cross-layer interactions** where intuitive approach diverges from correct
- **Hard casts, assumptions, limitations** that would BREAK or PANIC if assumptions change
- **Missing compilation paths** or AST nodes the system doesn't handle
- **Subsystems with shared state** where adding one feature ripples into another

---

## Uniqueness Validation

### Local Overlap Heuristic

If local reference problems are available, catalog what they claim:

| Problem | Tokens/Keywords | AST Changes | Opcodes | Key Subsystems |
|---------|----------------|-------------|---------|---------------|
| ... | ... | ... | ... | ... |

High overlap with local known work is a risk signal, not a uniqueness proof.

### Platform Uniqueness Preflight (Mandatory)

Local overlap analysis is good to do but other contributors' submissions are not available locally. Before deep implementation, enter a basic but valid package and run **Prechecks** (includes the near-duplicate similarity check) and then the **Scope Gate**, which compares close matches in depth (tasks and what their solutions touch, not wording), investigates upstream history (shipped, open PR, declined, removed on purpose), and judges repo fit. Open the similarity results and read the close matches yourself.

Upstream homework before spending on the Scope Gate (official R2/R3/R4):
- Search PRs in every state (open, merged, closed/unmerged). An unmerged PR implementing the idea still rules it out; this is the #1 rejection reason.
- Search issues AND GitHub Discussions for maintainer rulings; a declined feature is repo misalignment.
- Check the capability was not shipped and later removed on purpose.
- Read the README; the feature must fit the project's philosophy.

Minimum preflight package:
- Concise non-prescriptive description of the core behavior
- Valid test patch with representative checks and working `test.sh`
- Minimal solution patch that applies and runs
- Working Dockerfile
> [!NOTE]
> During idea crafting, prepare this minimal package early so preflight can run immediately after selecting the direction.
> At this stage patches are usually written manually, so test/solution patches must use valid unified diff syntax and correct file modes.

Decision rule:
- If preflight is clear, continue full implementation.
- If preflight is flagged as duplicate/similar, or the Scope Gate returns drop, stop and pivot to a different idea.
- Do not assume title-only or wording-only changes will resolve overlap. A drop means the idea needs rethinking, not rewording.

### Compare Against Local Known Work

| Aspect | Ask |
|--------|-----|
| Domain | Does this touch the same subsystem? |
| Pattern | Is this using the same technique? |
| Files | Does this modify similar files? |
| Traps | Are the semantic traps similar? |

**Small overlaps in local known examples may be acceptable**, but platform plagiarism checks are the final originality gate.

### Red Flags

| Pattern | Why It's Bad |
|---------|-------------|
| Well-known pattern names | Too Easy |
| Mentioned in issue json file | Documented solutions exist |
| Copies approach from accepted work | Not novel |
| Same failure modes as existing problem | Reviewer catches repetition |

---

## Difficulty Factors

### What Makes AI Fail

| Factor | Description |
|--------|-------------|
| Cross-component interactions | Symptom in one place, fix in another |
| Scope chain complexity | Constraints propagate across scopes |
| Type system depth | Reflection or type-system subtleties |
| Assignment path coverage | Multiple code paths to validate |
| Error message precision | Exact format required |
| Architecture incompatibility | Existing model CANNOT support new feature |

> [!IMPORTANT]
> Most ideas might be resolved with easy workaround or simple wrapper, but also might have a very difficult aspect and require deep analyzing to this specific repo. Focus on hard and professional path all the time.

### Semantic Traps

Design traps before writing code:
1. What would a naive implementation do?
2. Why would it fail? (with specific code evidence from the repo)
3. What test catches it?

### Bypass Validation (Critical Step)

For EACH semantic trap, perform a bypass analysis:

| Question | What You're Checking |
|----------|---------------------|
| Can the agent solve this in <20 minutes? | If yes, it's not a real trap — it's a speed bump |
| Does this trap produce DIFFERENT failures than other traps? | If no, you have fewer independent forks than you think |
| Is there a well-known pattern that solves this directly? | If yes, the agent will find it immediately |
| Does the naive approach partially work? | Partial success is worse than total failure — agent might think they're done |
| Would the "simple version" pass 80%+ of tests? | If yes, the idea is fundamentally too easy |

---

## Output: `{problem-name}-plan.md`

The output for idea crafting is a per-problem plan at `my-work/{repo-name}-{problem-name}/{problem-name}-plan.md`. Create the problem directory during idea crafting and put only this plan file in it until the user approves implementation.

The plan replaces the old root `tmp-plan.md`/`plan.md`/`new-prompt.md` handoff. It should preserve the useful comparative work by containing **3 validated ideas** or a clear shortlist section, then a deep selected-idea plan. The root `new-prompt.md` is volatile handoff text only and should point to this per-problem plan instead of duplicating it.

The plan must include:

1. **What It Is** — clear feature description with syntax/behavior examples
2. **Why This Is Hard At Its Core** — deep architectural conflicts and cross-layer interactions (with file:line evidence)
3. **Independent Semantic Forks** — table with 4-6+ independent decision points, each causing DIFFERENT test failures
4. **Layer Spread** — table of files touched with estimated LoC per file (target 700+ non-empty LoC across 6-8+ files; Diamond ideal 900-1200+)
5. **Local Overlap Risk Note** — compare with local known examples if available; do not treat this as proof of uniqueness
6. **Bypass Resilience** — table of shortcut attempts and why each fails
7. **"Core Insight Then Mechanical?" Assessment** — what decisions remain AFTER the first insight
8. **Knowledge-Transfer Risk Assessment** — for each language analogy (Python, JS, Go, Rust), why pattern transfer fails
9. **Comparison with success patterns** — how this idea replicates the architecture-incompatibility pattern of best accepted work
10. **Preflight plan** — how to build and submit a basic uniqueness preflight package before deep implementation

11. **Draft title and draft description** -- enough for the user to run plagiarism/similarity checks before implementation

After all three ideas, provide a **comparative ranking table** with clear justification.

Once implementation begins, keep `{problem-name}-plan.md` immutable. If review data later requires a strategic change, write `{problem-name}-next-plan.md` only when the user explicitly asks for it.

---

## Anti-Patterns

| Do | Don't |
|----|-------|
| Explore untouched subsystems | Copy successful patterns |
| Find structural incompatibilities | Add workarounds or basic wrappers |
| Design traps from architecture gaps | Think about solution first |
| Compare difficulty against accepted work | Assume idea is hard |
| Read full history of past problems | Skim documentation |
| Analyze the gaps in the codebase deeply | Pick an issue from issue json file |
| Count INDEPENDENT forks | Count repetitive variations |
| Validate every claim against source code | Trust surface-level analysis |
| Target 700+ non-empty LoC (900-1200+ ideal) | Accept borderline 400-500 estimates |
| Find ideas where knowledge transfer misleads | Pick features that map to Python/JS directly |
| Run uniqueness preflight early | Skip preflight and discover duplication only after deep implementation |
