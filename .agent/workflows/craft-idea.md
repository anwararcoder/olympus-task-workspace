---
description: Craft a novel, hard problem idea by analyzing accepted work and exploring repo architecture
---

# Craft Idea

## When to Use

Run when starting fresh to find a new problem idea for a repository.

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

## Core Principle

> **"Difficult and Clear is the way to success."** The idea must be hard in its core—not something that requires iterations to make hard. Difficulty must be structural (architecture incompatibility), not decorative (tricky tests on top of a simple core).

---

## Step 1: Read Standards

Read these files to understand what makes problems succeed:

```bash
# Core standards
cat standards/WORKFLOW.md

# All rules under .agent/rules/ — especially idea-crafting.md
# All workflows under .agent/workflows/
```

Focus on:
- Structural vs decorative difficulty (concrete foundation vs matchstick building)
- Independent semantic forks metric
- Well-known pattern risk
- Multi-layer architecture requirements
- What makes problems get rejected

---

## Step 2: Analyze Local Reference History

Study 2-4 local accepted/waiting examples with FULL history (if available):

```bash
cd my-work/Accepted/{accepted-problem}/
# or
cd my-work/Waiting/{waiting-problem}/
```

For each version (v1, v2, ..., vN), read:
1. **Commit message** - What changed and why
2. **Description file** - How they phrased requirements
3. **Test patch** - How they designed traps
4. **Solution patch** - How they solved from roots
5. **Auto-review JSON / legacy AI report** - What worked/failed
6. **Agents-run artifacts** - Per-agent verdicts, trajectories, XML, and solution patches
7. **AI evaluation** - Cross-run analysis and quality scores
8. **Human reviews** (if any) - Feedback patterns

**Extract the success/failure patterns:**
- What made the BEST problems succeed? (architecture incompatibility, deep cross-layer interaction)
- What made weaker problems iterate? (decorative difficulty, borrowed traps, well-known patterns)
- How many independent forks did the successful problems have?
- How large were the solution patches? (target: matching or exceeding best work)

> This gives you the sense of what difficulty aspects work and what causes iterations.

---

## Step 3: Local Overlap Heuristic

**Before exploring new ideas**, catalog infrastructure from local known work:

```bash
# For each waiting/accepted problem, extract key infrastructure
# Look at solution patches for new structs, opcodes, methods, tokens, AST nodes
```

Build a local reference table:

| Problem | Status | Keywords/Tokens Added | AST Nodes Added | Key Subsystems Claimed |
|---------|--------|----------------------|-----------------|----------------------|
| ... | ... | ... | ... | ... |

Use this only as a risk heuristic. It cannot validate uniqueness across other contributors.
Platform plagiarism checks are the authoritative uniqueness gate.

---

## Step 4: Deep-Dive into Repository Architecture

This is the most critical step. You must READ THE ACTUAL SOURCE CODE, not just file names.

```bash
cd repos/{repo}
```

**Investigation targets:**
- **Compiler/interpreter core** — Understand the full pipeline (parse → AST → compile/CFG → execute)
- **Type system** — How types are represented, resolved, compared
- **Scope/frame model** — How variables are stored, accessed across scopes
- **Execution model** — How code runs (stack VM? tree-walking? CFG chain?)
- **Object/value model** — How values are represented at runtime
- **Control flow** — How loops, conditionals, exceptions, defer are implemented
- **Extension points** — What's missing that SHOULD be there

**What to look for:**
- **Architectural gaps** — Missing features the codebase's design could/should support
- **Architecture incompatibilities** — Places where adding Feature X would CONFLICT with existing Subsystem Y's assumptions
- **Hard casts / unsafe assertions** — Places where the runtime does `.(Type)` or assumes specific value shapes — these break if assumptions change
- **Missing compilation paths** — AST nodes or cases the compiler rejects or doesn't handle
- **Cross-layer state sharing** — Where adding a feature ripples through 5+ files
- **Untouched subsystems** — Parts not covered by any existing problem

**Avoid:**
- Copying patterns from previous successful problems
- Well-known patterns (hooks, type guards, null checks, defer, generators)
- Ideas that only touch 2-3 files
- Ideas where the core infrastructure already exists in another problem's solution
- Features from popular languages that agents can pattern-match directly

---

## Step 5: Validate Idea Difficulty

Before proceeding, verify each idea against ALL criteria:

### Hard Requirements Checklist

- [ ] Feature requires 6+ file changes
- [ ] Touches 5+ architectural layers
- [ ] No obvious implementation pattern
- [ ] Has implicit complexity (scope, state, timing, cross-layer interactions)
- [ ] Can create rich semantic trap tests (30+)
- [ ] No existing PRs (open, merged, or closed/unmerged) or online solutions
- [ ] Not declined by maintainers in issues or GitHub Discussions; not shipped and removed on purpose
- [ ] Repo meets the official floor: public, 500+ stars, a commit in the last 12 months, allowed language and license (`../rules/olympus-platform.md` section 2)
- [ ] Fits the repo's philosophy (README read)
- [ ] **Unique from previous work** — not repeating successful patterns
- [ ] **Low local overlap risk** — avoid obvious reuse from local known examples, then confirm on platform plagiarism checks
- [ ] **LoC estimate is 700+ non-empty** (Diamond floor; 900-1200+ ideal)
- [ ] **Not a well-known concept** — defer, generators, while loops, pattern matching basics are too documented
- [ ] **Difficulty is structural** — architecture incompatibility, not decorative surface traps

### Key Questions (Must Answer All)

1. What is the naive implementation an AI would try?
2. Why would it fail? (with specific code evidence — file:line references)
3. What architectural insight is required?
4. **How long would it take a strong agent to solve the core difficulty?** (If <20 min, find harder problem)
5. **Does the idea have a "simple version" that passes most tests?** (If yes, agents WILL produce it)
6. **After the core insight, is the rest mechanical?** (If yes, it's not hard enough — need 4+ MORE independent decisions)

> If you can't answer #2, #3, and #4 with specific evidence from the codebase, find a harder problem.

### Bypass Analysis (Per-Trap)

For EACH semantic trap, ask:
- Can the agent solve this in <20 minutes? → It's a speed bump, not a trap
- Does this produce DIFFERENT failures than other traps? → If not, you have fewer independent forks
- Is there a well-known language pattern that directly solves this? → Agent will find it
- Does the naive approach partially work? → Partial success is worse (agent thinks they're done)

> **Independent fork count is the most important metric.** 5 traps that all reduce to "add context parameter" = 1 fork. 5 traps requiring 5 different design decisions = 5 forks.

### Knowledge-Transfer Risk Analysis (Required for Each Idea)

For every idea, explicitly map what happens when an agent searches for analogies:

| Source Language | Analogous Feature | Why Transfer FAILS in This Repo's Architecture |
|----------------|-------------------|-----------------------------------------------|
| Python | ... | ... |
| JavaScript | ... | ... |
| Go | ... | ... |
| Rust | ... | ... |

If the agent can copy a known pattern with minimal adaptation → idea is too risky.
Ideally, knowledge transfer should **actively mislead** agents into wrong approaches.

---

## Step 6: Shortlist 3 Ideas

Before committing to one idea, produce a shortlist of 3 validated ideas with:

1. **What It Is** — behavioral description with examples
2. **Why This Is Hard At Its Core** — the deep architectural conflicts (with code evidence from repo: file:line)
3. **Independent semantic forks** — table of truly independent design decisions (not repetitive)
4. **Layer spread** — files and estimated LoC per file (target: 500+ non-empty across 7+ files)
5. **Local overlap risk note** — compare against local known examples only; do not present this as proof of uniqueness
6. **Bypass resilience** — how quickly a strong agent could solve the core difficulty
7. **"Core insight then mechanical?" test** — what happens after the agent solves the hardest part
8. **Knowledge-transfer risk** — explicit analysis per language analogy
9. **Risks** — honest assessment of weaknesses

### Selection Criteria

| Dimension | Ideal |
|-----------|-------|
| Independent forks | 4-5+ |
| Estimated non-empty LoC | 700-1200+ (Diamond) |
| Files touched | 6-10+ |
| Local overlap risk (heuristic only) | Low |
| AI familiarity with pattern | Low (ideally misleading) |
| "Simple version" bypass | None |
| Target pass rate | At least one legitimate pass within the current live panel |

### Comparative Ranking

After all three ideas, provide a comparison table:

| Dimension | Idea #1 | Idea #2 | Idea #3 |
|-----------|---------|---------|---------|
| Confidence | | | |
| Independent Forks | | | |
| Est. LoC | | | |
| Risk of "Easy Path" | | | |
| Novelty | | | |
| Knowledge-Transfer Risk | | | |

Rank with clear justification for why #1 is the winner.

---

## Step 7: Deep Validate Best Idea

Take the top-ranked idea and perform deep validation:

1. **Trace every code path** that must change (with file:line references)
2. **Attempt to debunk each trap** — actively try to find shortcuts the agent could use
3. **Estimate bypass time** — How long would a strong agent take for each trap?
4. **Compare against the most successful accepted problems** — Does this match or exceed their difficulty characteristics?
5. **Check the "simple version"** — Is there a subset of the feature that passes 80%+ of tests?
6. **Check local overlap risk** — Does this obviously reuse local known solution infrastructure?
7. **Verify LoC with per-file breakdown** — Sum up estimated lines per file, subtract 15% for blanks/comments

> If you find a bypass that invalidates the core difficulty, go back to the shortlist and pick the next idea.

---

## Step 8: Create The Problem Directory And Write `{problem-name}-plan.md`

Create `my-work/{repo-name}-{problem-name}/` and write a comprehensive `{problem-name}-plan.md` inside it. During idea crafting this should be the only file created in that directory.

This per-problem plan replaces the old root `plan.md` plus `new-prompt.md` split. The root `new-prompt.md` remains volatile handoff text and should only point the executor at this plan.

The plan must include a draft title and draft description so the user can run plagiarism/similarity checks before implementation. Once implementation begins, do not rewrite this file as the iteration plan; future iteration strategy belongs in `{problem-name}-next-plan.md` only when explicitly requested.

Create a comprehensive `{problem-name}-plan.md` with:

### Required Sections

1. **Executive Summary**
   - Problem name
   - Repository
   - Expected difficulty
   - Why it's unique

2. **Deep Architecture Analysis**
   - Current state (what exists, with file:line evidence)
   - What's missing (the gap)
   - Why this is hard (architecture incompatibility)

3. **Files to Modify**
   - Table with files, estimated lines, purpose
   - Must total 6+ files, 700+ non-empty lines

4. **Semantic Traps**
   - Table: naive approach → why it fails → correct behavior (per fork)
   - These become tests later

5. **Comparison to Successful Problems**
   - Table comparing against accepted work
   - Show it matches or exceeds difficulty patterns

6. **Test Categories**
   - Breakdown of test types (basic, edge cases, traps)
   - Target 30+ tests

7. **Implementation Roadmap**
   - Phased approach
   - Dependencies between phases

8. **Uniqueness Preflight Plan (Mandatory)**
   - Basic package scope (minimal description/test/solution/dockerfile)
   - Draft the minimal preflight artifacts during idea crafting to avoid delay before platform plagiarism checks
   - If patches are drafted manually, ensure valid unified diff syntax and correct file modes
   - Time-box for preflight run
   - Decision rule if duplicate/similarity is flagged

---

## Step 9: Define Preflight Gate

Before any deep implementation starts, explicitly define:
- What will be included in the basic preflight submission
- Confirm the minimal description/test patch/solution patch/dockerfile drafts are prepared during idea crafting
- Confirm manual patch drafts follow valid syntax and file modes
- What platform evidence counts as a clear uniqueness pass: Prechecks green (near-duplicate check read, close matches opened) and a Scope Gate pass
- What trigger causes immediate pivot: duplicate/similarity finding or a Scope Gate drop (duplicate, already handled upstream, or repo misfit)

---

## Step 10: Notify User

After creating `{problem-name}-plan.md`, notify the user for review before proceeding to implementation.

---

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Bad |
|--------------|--------------|
| Copying previous work patterns | Violates rules, reviewers notice |
| 2-layer solutions | Too easy for AI |
| Well-known fixes | Documented online |
| Combining existing work | Overlapping submissions rejected |
| Ideas from issues | Maintainers often describe fixes |
| Skipping the 3-idea shortlist | First idea is rarely the best; comparison reveals weaknesses |
| Treating bypass time as secondary | A trap solved in 20 min is not a trap |
| Counting repetitive changes as independent forks | Same pattern x 6 = 1 fork, not 6 |
| Treating local overlap analysis as proof | Only platform plagiarism checks can clear uniqueness |
| Skipping platform plagiarism preflight | You discover duplicate/similarity blockers too late |
| Accepting borderline LoC estimates | below ~700 is too risky for Diamond; aim for 900+ |
| Manufacturing difficulty through artificial requirements | Reviewers catch this and reject |
| Building on matchsticks (decorative difficulty) | Surface traps fall apart under scrutiny |
| Borrowing traps from other problems | The difficulty is fragile, not structural |
| Picking features where intuitive approach IS correct | No amount of clever tests will save it |

---

## Expected Output

```
my-work/{repo-name}-{problem-name}/{problem-name}-plan.md
```

The plan should still include the comparative analysis that used to live in `tmp-plan.md` when that helps justify the selected idea, but do not leave the durable idea record only in root-level volatile files.

> **Never proceed to implementation until user approves the plan.**
