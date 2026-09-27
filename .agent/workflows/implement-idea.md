---
description: Implement an approved idea following the incremental process from the per-problem plan
---

# Implement Idea

## When to Use

Run after the user approves `my-work/{repo-name}-{problem-name}/{problem-name}-plan.md` from `/craft-idea`.

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

## Core Principle

> **Incremental process**: Focus on each step independently to produce solid, professional work. Tests first → Description → Solution.

---

## Prerequisites

- [ ] Validate `{problem-name}-plan.md` that's approved by user
- [ ] Repository cloned and clean
- [ ] Understand files to modify from `{problem-name}-plan.md`
- [ ] Understand semantic traps from `{problem-name}-plan.md`
- [ ] Uniqueness preflight policy is defined and ready to run

---

## Step 1: Set Up Working Directory

```bash
mkdir -p my-work/{repo-name}-{problem-name}
cd my-work/{repo-name}-{problem-name}

# Initialize git for version tracking
git init
```

If the directory was already created by `/craft-idea`, keep the existing `{problem-name}-plan.md` unchanged. Do not replace it with a root `plan.md`/`new-prompt.md` copy.

---

## Step 2: Record Base Commit

```bash
cd repos/{repo}
git rev-parse HEAD > ../../my-work/{problem}/BASE_COMMIT-{name}.txt
echo "https://github.com/{org}/{repo}" >> ../../my-work/{problem}/BASE_COMMIT-{name}.txt
```

`BASE_COMMIT-{name}.txt` must have the base SHA on line 1 and the GitHub repository URL on line 2. Any checkout command must read only line 1.

---

## Step 3: Run Uniqueness Preflight (MANDATORY)

Before deep implementation, create a basic but valid preflight package:
- concise description
- valid test patch with `test.sh`
- minimal solution patch
- working Dockerfile

Enter it on the platform and run **Prechecks** (includes the near-duplicate similarity check), then the **Scope Gate** (in-depth duplicate comparison, upstream history, repo fit). Open and read the close similarity matches. Do not start the build, quality checks, or rollouts yet.

Decision rule:
- If Prechecks and Scope Gate are clear, continue.
- If duplicate/similarity is flagged or the Scope Gate drops the task, stop this idea and return to `/craft-idea`.
- Do not continue by only changing title/wording.

---

## Step 4: Design Tests First

Before writing ANY solution code:

1. **Tier 1 tests** (basic functionality) - AI usually passes
2. **Tier 2 tests** (edge cases) - Some AI passes
3. **Tier 3 tests** (semantic traps from `{problem-name}-plan.md`) - AI should fail

Focus on tests that catch naive implementations identified in `{problem-name}-plan.md`.

---

## Step 5: Implement Tests

Follow repo's existing test style:
- Use build tags if tests reference solution code
- Create test helpers for common patterns
- No comments or debug statements
- Match exact repo conventions

```bash
# Verify on base
./test.sh --output_path /tmp/base.xml base  # All PASS
./test.sh --output_path /tmp/new.xml new   # All FAIL
```

---

## Step 6: Write Description

Write description AFTER tests are complete:

**Style:**
- Format: `# Title`, a `**Category**: ...` line, then prose (see `../rules/description-writing.md`)
- First sentence is the ask ("Add X to Y" / "Fix Z when ..."); no motivation or "currently lacks" preamble
- No bulleted requirement lists, headings, or code snippets doing the describing
- Natural flowing prose, no rigid section headers
- Behavior-focused (WHAT not HOW)
- Concise: only mention what's necessary
- Don't frame as external or turn into instruction lists
- Use plain English over code snippets when possible

**Content:**
- Every test behavior must be inferable from description
- No hidden assumptions
- Error formats clearly stated
- No discoverable repo details unless tests depend on them

**Length:** 9-18 lines typical, but focus on completeness over brevity.

---

## Step 7: Implement Solution

Follow the roadmap from `{problem-name}-plan.md`:
- Touch 6+ files across multiple layers
- 700+ non-empty lines of professional code (Diamond target 900-1200+)
- Match repo style exactly
- No AI patterns or comments
- Solve from roots, not workarounds

**Key questions:**
- Would a maintainer accept this PR?
- Does it solve the root cause?
- Is there any redundant code?
- Does it follow the repo coding style and standards

---

## Step 8: Verify Solution

```bash
./test.sh --output_path /tmp/base.xml base  # All PASS
./test.sh --output_path /tmp/new.xml new   # All PASS
```

---

## Step 9: Generate Patches

Run `/generate-patches` workflow.

---

## Step 10: Create Dockerfile

```dockerfile
FROM public.ecr.aws/d3j8x8q7/olympus-base-go:latest
ENV GOBIN=/usr/local/bin
WORKDIR /app
COPY . .
RUN GOWORK=off go mod download
RUN go install github.com/jstemmer/go-junit-report/v2@v2.1.0
CMD ["/bin/bash"]
```

For new submissions, use the language-specific image that matches the repo:

- `public.ecr.aws/d3j8x8q7/olympus-base-python:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-typescript:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-rust:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-go:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-cpp:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest`

Java and C/C++ are supported now. See `standards/Java-C++-Support-Overview.md` for examples. No comments in Dockerfile.

Official Dockerfile rules: `WORKDIR /app`, all dependencies at build time (runtime is `--network none`), no test commands in any `RUN`, end with `CMD ["/bin/bash"]`, and it must build and work without the test or solution patch applied.

---

## Step 11: Review Work

Run `/review-work` workflow.

---

## Step 12: Hand Off for Platform Checks

Notify the user that the package is ready for the platform flow, and remind them of the order
(each step unlocks the next; never spend on a later step while an earlier one fails):

1. Prechecks, then Scope Gate (if not already cleared during preflight)
2. Build Image
3. Quality checks: Verify Tests, Verify Solution, Verify Flakiness, Test Quality, Task Quality,
   Solution Quality, Description Quality (handle with `/handle-initial-checks`)
4. One quick check rollout, then a full batch once stable (handle with `/handle-ai-report`)
5. FP check after the run set is settled
6. Auto Review last, then Submit

Every edit stales completed results, so batch fixes and rerun once.

---

## Expected Files

```
my-work/{repo}-{name}/
├── {name}-plan.md                # Immutable initial plan from idea crafting
├── {repo}-{name}.md              # Description
├── test-{name}.patch             # Test patch
├── solution-{name}.patch         # Solution patch
├── Dockerfile-{name}             # Dockerfile
├── BASE_COMMIT-{name}.txt        # Line 1 SHA, line 2 GitHub URL
├── {name}-auto-review.json       # (downloaded when available)
├── {name}-agents-runs/           # (downloaded platform run artifacts)
├── {name}-ai-evaluation.md       # (written when requested)
├── {name}-human-reviews.md       # (added by user/reviewer)
└── {name}-next-plan.md           # (only when explicitly requested)
```

---

## Quality Gates

Before submission:
- [ ] Description aligned with tests
- [ ] Tests >=30, >=700 lines
- [ ] Tests 100% fail on base, 100% pass with solution
- [ ] Solution >=700 non-empty lines, >=6 files
- [ ] No AI comments or AI slop in patches
- [ ] Matches repo coding style
- [ ] Fresh apply verification passes
