---
trigger: always_on
description: Core Shipd values and quality standards, routed through the current task panel and FP calibration rule
---

# Shipd Core Principles

## Repository-Native Deliverable Boundary

The description, test patch, solution patch, Dockerfile, and base-commit file must read like
ordinary upstream contribution material. Never place benchmark or program names, difficulty-tier
labels, solver/grader language, or meta phrases such as "this task" and "this challenge" in their
prose, comments, helper names, test targets, fixture names, cache names, output paths, diagnostics,
or generated identifiers. The official leak rule names the minimum: no directories or files named
"challenge", "quest", or "olympus", no `test.sh` comments referencing the challenge, and no
"Shipd", "Olympus", or "mars" anywhere in the patches.

Name authored helpers after repository behavior. Ordinary build-tool vocabulary such as Gradle's
`tasks.register` is valid, and required external coordinates such as the approved base-image
repository are exempt. Internal plans, ledgers, downloaded checks, trajectories, and review notes
may discuss the operating process, but their framing must never leak into the five deliverables.
Audit all five together before submission; a rename is incomplete until every authored occurrence
of the same branding class is gone.

## Authority Before Metrics

This always-on file contains design lessons from older Diamond work, not current Olympus numeric
authority. For every active task, read `olympus-platform.md` (official platform requirements and
check order), `false-positive-calibration.md`, and `my-review-workflow/rules/platform-panel.md`
first. The current criteria panel controls pass rate,
successful-run medians, required checks, and batch interpretation.

## Historical Diamond Sizing Heuristics

| Metric | Minimum | Ideal |
|--------|---------|-------|
| Solution lines (non-empty) | 700+ (Go ~600+ if deeply coupled) | 900-1200+ |
| Files modified | 6+ | 6-8+ (5+ layers) |
| Test count | 30+ | 50+ |
| Test patch lines | 700+ | 900-1200+ |
| AI pass rate | See the current task panel | At least one legitimate pass within the live bar |
| Median solver messages | See the current task panel | Substantive architecture and trajectory evidence |

> **Note:** The remaining size and test-count values are historical Diamond risk heuristics, not
> current platform gates. Use them only when that mode is explicitly selected. Current normal
> Olympus numbers live in the platform panel.

> **Behaviorally simple, deeply hard (the Diamond essence):** The best problems describe in a few plain behavioral sentences but require deep investigation across the codebase to solve. Each added requirement reads as ~1 sentence of description yet is a distinct, INDEPENDENT fork of implementation work that forces the solver to study how the feature integrates with the whole system (the Matchstick Metaphor below). LoC is an OUTPUT of those forks -- you reach the line count by adding depth (forks/layers), never by padding the diff.

> **Pass rate and solvability:** Use the live panel and actual tier mix. At least one legitimate pass
> is required. A zero-pass round must enter the five-way diagnosis in
> `false-positive-calibration.md`; a hint is only the single-discoverability-blocker branch.

> **False-positive gate:** Every passing patch is provisional until the required FP evaluation and
> independent contract-class audit clear it. A low pass rate does not excuse an incorrect passer.

> **Long horizon:** Use the live LOC, message, and file medians. AI evaluation is stochastic, so
> compare exact hashes, tier mix, and architecture families rather than raw percentages alone.

> **Sanity runs:** Use the platform's **quick check** (one cheap rollout) to catch build/test
> blockers and misunderstanding before a **full batch**. Do not assume a fixed batch size or agent
> roster; the batch dialog configures agents and counts, and the criteria panel sets the minimum
> number of finished rollouts. Run one batch at a time and read results before editing: any edit
> stales every finished result.

> **Uniqueness Preflight (Mandatory)**: Before deep implementation, enter a lightweight but valid package and clear **Prechecks** (which include the near-duplicate similarity check) and the **Scope Gate** (in-depth duplicate comparison, upstream history, repo fit). Open and read the close similarity matches; do not treat the check as a pass/fail gate only. If similarity is flagged or the Scope Gate drops the task, pivot immediately. Title-only or wording-only changes are not a reliable fix.

> **Holistic review:** Use every current run and its exact artifacts to catch systematic environment,
> harness, or discoverability failures before changing task difficulty.

> **Quality scoring:** Use the current panel's description, tests, and solution fields. Historical
> 21-item/5-of-7 Diamond rubrics are checklists only when that mode is explicitly active.

## Core Values

**Difficult and Clear is the way to success.**

1. **Behavioral Ask**: Describe WHAT the feature does, not HOW to implement it
2. **Structural Difficulty**: Difficulty must be inherent in architecture incompatibility, not grafted on through surface traps
3. **Multi-Layer Complexity**: Features must touch multiple architectural layers (6+ files ideal)
4. **Tests First**: Design semantic traps before implementing solutions
5. **Professional Quality**: Human-style code without AI patterns
6. **Iterate Based on Data**: Only commit after receiving platform review data or saved agent-run artifacts
7. **Calibrate Coherently**: Never weaken a valid contract to move pass rate; de-scope only one
   complete capability island across description, tests, and golden when breadth is excessive
8. **Always Hard Path**: Choose professional solutions that solve from roots
9. **Analyze and Compete**: Study accepted work to create ideas that match or exceed their difficulty
10. **No Knowledge Transfer**: Avoid features where agents can copy patterns from Python/JS/Go/Rust directly
11. **Uniqueness First**: Validate originality with a basic preflight package before spending full implementation effort

## Convergence Rule

Use this order when iterating after checks:
1. Lock fairness and contract clarity.
2. Lock objective quality gates.
3. Tune difficulty with small semantic-trap increments.

Hardness from ambiguity is fragile and usually fails precision/reviewer checks.
Hardness from semantic depth is stable.

> [!IMPORTANT]
> It's very important to read the full content while analyzing. Sometimes with large test patch or big WORKFLOW.md the analysis read teh first portion only and don't complete the remaining of the file. Make sure you read the full content while analyzing some document, wether from the history or from the current work.

## Following the Professional Path

> [!IMPORTANT]
> While working, we need to follow the best practice and achieve our goal. We shouldn't justify our approach with weak points (even if they are valid ones), instead we should do the task professionally.
> That's why I told you that for each problem, there might be a workaround that cover most of the common cases, but we are looking for a complete, clear, professional path that solve the problem from its roots, and introduce a solution for all known edge cases, and we should validate only these solutions with covering a comprehensive edge cases. This should be a guideline that you should always follow.

## Structural vs Decorative Difficulty

**Structural difficulty (GOOD — Concrete Foundation):** The problem's core requires the agent to discover that the existing architecture is fundamentally incompatible with the new feature. The intuitive approach is architecturally WRONG. The difficulty is inherent — it can't be removed by simplifying tests.

**Decorative difficulty (BAD — Matchstick Building):** The problem's core is architecturally straightforward but you add tricky tests, behavioral traps, or confusing descriptions. The difficulty is grafted on — a reviewer can remove it by flagging unfair tests.

> [!IMPORTANT]
> Every idea MUST have structural difficulty. If the intuitive implementation approach IS correct, no amount of clever tests will create genuine, stable difficulty. Focus on finding architecture incompatibilities, not surface traps.

### Success Pattern Recognition

Historically successful low-pass Diamond tasks followed one of these patterns; measure current
tasks against the live bar rather than treating the old percentage as a target:
- **Pattern A — Deep Subsystem Interaction**: Two existing subsystems interact in ways where the intuitive single-step approach is WRONG (requires recursive chaining, state propagation, etc.)
- **Pattern B — Architecture Incompatibility**: The existing model CANNOT support the new feature — the agent must discover this and redesign from scratch

The weakest problems (required 4+ iterations): The intuitive approach IS correct, difficulty had to be borrowed from other problems or manufactured through behavioral tricks.

## The Matchstick Metaphor

> Adding one matchstick (feature) that touches all other matchsticks (components) creates unavoidable complexity. Also, think about what might be unique for the repo we are working on that will be like a novel or require an aspect from this specific repo.

A problem is hard when it requires:
- Parsing/tokenizing changes
- AST/node modifications
- Compiler/CFG generation changes
- VM/execution model changes
- Type system/validation changes
- Context/state/scope management
- Object model/value system changes

Each layer constrains the others. Single-layer solutions are too easy for AI.

## The Incremental Process

1. Run uniqueness preflight with a basic valid package (Prechecks + Scope Gate)
2. Start with solid testing (failing tests on base)
3. Then write the description (aligned with tests)
4. Then implement the solution (multi-layer, professional)
5. Generate patches (test first, solution second) and do the local review in `olympus-platform.md` section 8
6. Follow the platform order: Prechecks -> Scope Gate -> Build Image -> Quality checks -> quick check -> full batch -> FP check -> Auto Review -> Submit. Never spend on a later step while an earlier one fails.
7. Iterate based on results (never commit until results received)

At least one agent must pass before the platform allows submission.

## Workspace Isolation

Do every repo edit in a private workspace, never directly in the shared `repos/{repo-name}/` clone. Multiple agents may run in parallel on the same problem; touching the shared clone simultaneously corrupts patch regeneration and breaks fresh-apply verification.

Set up the workspace once at the start of any Phase B execution:
- Clone the shared repo (or `git worktree add`) into a temp directory at the recorded `BASE_COMMIT` SHA. Example: `WORK=$(mktemp -d); git clone --no-local "repos/{repo}" "$WORK/{repo}" && cd "$WORK/{repo}" && git checkout $(head -n 1 ../../my-work/{repo}-{problem}/BASE_COMMIT-{problem}.txt)`.
- Apply the current `test-{problem}.patch` and `solution-{problem}.patch` into that workspace.
- Edit code, regenerate patches, and run verification only inside the private workspace.
- Copy regenerated patches back into `my-work/{repo}-{problem}/`.
- Discard the workspace once Phase B is verified.

The shared `repos/{repo-name}/` clone is a read-only source of truth for the base commit. If it has uncommitted edits at the end of a session, the next agent will mis-diff their patches against the wrong tree.

## Iteration Loop (Two-Phase Rule)

After the first submission, every iteration alternates between two strictly separated phases. Each phase is its own commit; never mix them in one diff.

**Phase A — Plan** (when platform results arrive: auto-review JSON, agent-run artifacts, Diamond Checks, AI evaluation, or human reviews):
- Update `commit-message.txt` with this round's problem / approach / results / analysis / next steps.
- Update `{problem-name}-next-plan.md` with the concrete artifact changes to perform next.
- Do not edit the description, test patch, solution patch, Dockerfile, Diamond artifacts, or any other deliverable in Phase A.
- The user commits Phase A.

**Phase B — Execute** (after the user commits Phase A):
- Make only the artifact changes called out in `{problem-name}-next-plan.md` (description, test patch, solution patch, Dockerfile, Diamond artifacts, etc.).
- Regenerate test and solution patches from the base commit when patches changed.
- Do not edit `commit-message.txt` or `{problem-name}-next-plan.md` in Phase B. Those stay frozen until the next Phase A.
- The user submits and wait for evaluation results.

After the platform returns new results, return to Phase A.

Why the separation: a Phase A commit reads as "results received, plan for next round." A Phase B commit reads as "artifact changes that match the most recent plan." Mixing them in one diff hides which deliverables the platform actually evaluated and forces every future agent to reconstruct the iteration history from raw diffs.

If during Phase B you discover the plan is wrong, stop, report the gap, and start a new Phase A with the new information. Do not silently rewrite the plan in the same commit as the artifact change.

## Difficulty Classification

| Difficulty | Hours | Lines | Files | Examples |
|------------|-------|-------|-------|----------|
| Hard (Diamond) | 4+ | 700-1200+ | 6-8+ | Language features, VM changes |
| Medium | 1.5-4 | 150-250 | 3-4 | Multi-component bugs |
| Easy (AVOID) | <1.5 | <150 | 1-2 | Simple fixes |

## Green Flags (Choose These)

- Multi-component that requires investigation
- Undocumented behavior affecting real use cases
- Syntax/language features requiring parser + compiler + VM
- Features needing scope/state/context management
- No existing PRs, no online implementations

## Red Flags (Avoid These)

- Solution describable in one sentence
- Single-file fixes
- Known patterns ("add null check", "use WeakSet")
- "Good first issue" labels
- Existing blog posts or StackOverflow answers

## When to Abandon

Abandon immediately if:
- Solution touches fewer than 6 files
- Core logic < 150 lines
- Naive implementation passes all tests
- Tests only verify one function

## Problem Directory Structure

Each problem lives under `my-work/{repo-name}-{problem-name}/`. Idea crafting creates this directory early and writes exactly one planning artifact there: `{problem-name}-plan.md`.

`{problem-name}-plan.md` is immutable once implementation begins. It represents all needed info that an executor agent would need to deliver a solid problem without any further guidance.

## Final Deliverables

| File or directory | Purpose |
|------|---------|
| `{problem-name}-plan.md` | Immutable initial idea and implementation plan created during idea crafting |
| `{REPO}-{problem-name}.md` | Problem description |
| `test-{problem-name}.patch` | Test patch (test.sh + tests) |
| `solution-{problem-name}.patch` | Solution code only |
| `Dockerfile-{problem-name}` | Uses the matching language-specific `olympus-base-*` image for new submissions |
| `BASE_COMMIT-{problem-name}.txt` | First line: base commit SHA. Second line: GitHub repository URL |
| `{problem-name}-auto-review.json` | Holistic auto-review artifact downloaded after review, when available |
| `{problem-name}-agents-runs/` | Saved per-agent run artifacts from platform evaluation |
| `{problem-name}-ai-evaluation.md` | Optional cross-run evaluation document when written |
| `{problem-name}-human-reviews.md` | Human reviewer feedback and responses |
| `{problem-name}-next-plan.md` | Optional next-iteration plan, only when explicitly requested |

`commit-message.txt` is a temporary side file used only by the commit-message workflow when explicitly requested. It is not part of the official problem artifact structure or final deliverables table.

Agent-run directories use this shape:

```text
{problem-name}-agents-runs/
  {problem-name}-agent-X/
    {problem-name}-agent-X-evaluation.json
    {problem-name}-agent-X-trajectory.json
    {problem-name}-agent-X-solution.patch
    {problem-name}-agent-X-base-tests.xml
    {problem-name}-agent-X-new-tests.xml
    {problem-name}-agent-X-metadata.txt
```

Patch mode contract:
- In `test-{problem-name}.patch`, `test.sh` must be recorded as `new file mode 100755`.
- `new file mode 100644` for `test.sh` is a patch generation failure and must be regenerated.

## Repository Requirements

Official floor (full list in `olympus-platform.md` section 2):

- Public GitHub repo, production-level codebase
- 500+ stars
- At least 1 commit in the last 12 months
- Language: TypeScript, JavaScript, Python, Go, Rust, C++, or Java
- License on the allowed list (MIT, BSD family, BSL-1.0, BLAS, GNU-All-permissive, Apache-2.0
  variants, CC-BY 1.0-4.0); GPL/LGPL/MPL/EPL are ineligible
- No existing PR (open, merged, or closed) implements the idea; maintainers have not declined it in
  issues or GitHub Discussions; it was not removed on purpose; it fits the project's philosophy

House preferences on top:

- Good, deterministic, offline-clean test infrastructure
- Active but not too active (no daily PRs)
- Depth: a thin or flat repo caps the difficulty ceiling
- Avoid heavily used repos (harder duplicate check and Scope Gate)

## Key Questions Before Starting

1. What is the naive implementation an AI would try?
2. Why would it fail? (specific code evidence — file:line references from the repo)
3. What architectural insight is required to fix it?
4. Does it touch 6+ files across multiple layers?
5. **After the core insight, is the rest mechanical?** (Must be NO — need 4+ MORE independent decisions)
6. **Can an agent copy a pattern from Python/JS/Go/Rust?** (Must be NO — or the transfer must actively mislead)
7. **Does a "simple version" pass 80%+ of tests?** (Must be NO)
8. **Was uniqueness preflight cleared before deep implementation?** (Must be YES)

If you can't clearly answer #2 and #3 with specific code evidence, the problem is too easy.
If #5 is YES, the problem has insufficient independent forks.
If #6 is YES, you have knowledge-transfer risk.
If #7 is YES, the idea is fundamentally too simple — no amount of clever tests will fix it.
