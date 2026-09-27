# Historical Shipd Complete Workflow Guide

> **Superseded authority notice:** this file preserves older Diamond-era mechanics and numeric
> examples. It is not the current source of truth for Olympus gates, scoring, false-positive
> evaluation, batch size, or bypass decisions. For an active normal Olympus task, read
> `my-review-workflow/rules/platform-panel.md` and
> `.agent/rules/false-positive-calibration.md` first. Use this file only for details those current
> sources do not replace. Remote verification is governed by `HYBRID-CLOUD-WORKFLOW.md`.

---

## Table of Contents

1. [Quick Reference](#quick-reference)
2. [Repository Selection](#repository-selection)
3. [Problem Selection & Difficulty](#problem-selection--difficulty)
4. [Uniqueness Preflight Gate](#uniqueness-preflight-gate)
5. [Workflow Steps](#workflow-steps)
6. [Problem Description](#problem-description)
7. [Test Standards](#test-standards)
8. [Solution Standards](#solution-standards)
9. [test.sh Requirements](#testsh-requirements)
10. [Dockerfile](#dockerfile)
11. [Patch Generation](#patch-generation)
12. [Pre-Submission Checklist](#pre-submission-checklist)
13. [AI Difficulty Guide](#ai-difficulty-guide)
14. [File Structure](#file-structure)
15. [Common Mistakes](#common-mistakes)
16. [Reviewer Notes](#reviewer-notes)

---

## Quick Reference

### Target Metrics

| Metric                         | Target                   |
| ------------------------------ | ------------------------ |
| **Solution lines**             | 700+ non-empty (900-1200+ ideal) |
| **Files modified**             | 6+ files                 |
| **Test count**                 | 30+ tests                |
| **Test file lines**            | 900+ lines               |
| **Description words**          | depend on the problem    |
| **New test fail rate on base** | 100%                     |
| **Pass rate with solution**    | 100%                     |
| **AI pass rate target**        | 1-3/10 agent runs (≤30%) |

### Core Principles

1. **Complexity matters**: 700+ non-empty lines across 6+ files (Diamond target 900-1200+)
2. **Tests first**: Create failing tests, then implement solution
3. **Revert if simple**: If solution is < 700 non-empty lines or touches fewer than 6 files, pick harder issue
4. **Generalized tests**: Test behavior, not implementation
5. **Codebase analysis**: Examine actual code, don't rely only on issue descriptions
6. **Quality over speed**: Thorough analysis beats rushing

### Convergence Priorities

When checks conflict, resolve in this order:

1. **Fairness/contract clarity first**: remove ambiguity between description and enforced behavior.
2. **Quality gates second**: satisfy objective requirements (700+ non-empty solution LOC, patch hygiene, style).
3. **Difficulty tuning third**: adjust trap depth after clarity and quality are stable.

Do not trade fairness for hardness. Hardness should come from semantic depth, not ambiguous wording.

---

> [!NOTE]
>
> 1. Constructing the problem
>    - What we have gone through and the fixes we have done
> 2. Initial Checks
>    - Basic checks try to notify you with what need to be enhanced and what errors and warning you might need to handle, but you need to be mindful and think about them pretty well, as some warnings might be oppose others and might cause some ambiguity if we followed them like "Problem description contains only necessary information (AI, up to 2 min)" checks and you will see them shortly.
> 3. AI post checks.
>    - similar to initial checks but more deep and take more time, and this stage where the AI try to solve the issue and must fail to pass it, and this stage when we recieve the AI difficulty report.
> 4. Human reviewer
>    - A human like me try to review the problem and make sure it follows the conditions and rules without violating anything, and let you know if there are anything to fix.
> 5. Final review
>    - one of the shipd team review it and decide if it will get accepted or need any further changes before accepting it.

## Repository Selection

### Requirements

| Requirement   | Details                                                            |
| ------------- | ------------------------------------------------------------------ |
| **Stars**     | 500+ GitHub stars                                                  |
| **License**   | Permissive (MIT, Apache, BSD)                                      |
| **Languages** | Python, TypeScript, Go, Rust, Java, C/C++ (Go/Rust/C++ preferred for AI difficulty) |
| **Type**      | Production-level tools/libraries/frameworks                        |

### Language Difficulty (Hardest to Easiest)

| Language       | AI Difficulty | Why                                        |
| -------------- | ------------- | ------------------------------------------ |
| **Rust**       | Hardest       | Ownership, borrowing, lifetimes confuse AI |
| **C/C++**      | Hard          | Build systems, native toolchains, and memory/runtime edge cases |
| **Go**         | Hard          | Error patterns, goroutines, interfaces     |
| **Java**       | Medium-Hard   | Larger build graphs, static typing, and framework conventions |
| **TypeScript** | Medium-Hard   | Complex generics, conditional types        |
| **Python**     | Medium        | Dynamic typing makes "working" code easier |
| **JavaScript** | Easiest       | No types, loose code passes tests          |

### Repository Types by Difficulty

| Type                              | AI Difficulty |
| --------------------------------- | ------------- |
| Monorepos with cross-package deps | Hardest       |
| SDK/Library code                  | Hard          |
| Framework internals               | Hard          |
| Application code                  | Medium        |
| Utility libraries                 | Easiest       |

---

## Problem Selection & Difficulty

### Must Have

- No existing PR (open, closed, draft)
- **No online implementation** (forks, tutorials, Stack Overflow answers, blog posts)
- Reproducible bug on base code
- Verify fix belongs to THIS repo, not upstream dependency

### Difficulty Classification

| Level            | Time        | Criteria                                     |
| ---------------- | ----------- | -------------------------------------------- |
| Easy (REJECTED)  | ≤1.5 hours  | Obvious patterns, one-liner fixes            |
| Medium           | 1.5-4 hours | Requires codebase understanding              |
| **Hard (IDEAL)** | ≥4 hours    | Multiple components, architectural decisions |

### Green Flags (Worth Pursuing)

- Bug spans multiple packages/modules
- Symptom differs from root cause location
- Requires understanding undocumented behavior
- Involves lifecycle, timing, or state management
- No maintainer has proposed a solution
- Need deep debugging and analysis

### Red Flags (Abandon Quickly)

- Issue has linked PR (even closed/draft)
- Maintainer comment describes the fix
- Labeled "good first issue"
- Fix is in same file as symptom
- One-liner description
- Well-known pattern (null check, type guard, debounce)
- Touches one file.

### Structural vs Decorative Difficulty (Critical Concept)

**All problems must have STRUCTURAL difficulty — not decorative difficulty.**

**Structural difficulty (GOOD):** The problem's core requires the agent to discover that the existing architecture is fundamentally incompatible with the new feature. The intuitive approach is architecturally WRONG. The difficulty is inherent and survives human review.

- The obvious implementation seems to work but fails because of deep architectural constraints
- Fixing it requires fundamental rethinking, not just patching
- Removing "tricky" tests wouldn't make the problem easy — the core challenge remains

**Decorative difficulty (BAD):** The problem's core is architecturally straightforward. Difficulty is manufactured through tricky tests, behavioral traps borrowed from other problems, or confusing descriptions. A reviewer can remove the difficulty by flagging tests as unfair.

- The basic feature is implemented correctly by most agents
- Difficulty comes from ONE behavioral subtlety that cascades test failures
- Required 3-4 iterations and borrowed tricks to reach target pass rate

> [!IMPORTANT]
> If the intuitive implementation approach IS correct, no amount of clever tests will create stable difficulty. Find ideas where the architecture itself creates the challenge.

### Knowledge-Transfer Risk

If the feature maps directly to a well-known pattern from Python, JavaScript, Go, or Rust, agents get a massive head start. The idea must have a **repo-specific twist** that makes the well-known pattern inapplicable or misleading.

Well-known patterns to avoid (or require significant repo-specific twist):

- Python `__dunder__` methods, generators, comprehensions
- JavaScript generators/iterators, Proxy/Reflect
- Go defer, goroutines, channels
- Rust pattern matching basics, trait implementations

### Quick Tests

> "Can I describe the fix in one sentence?" → YES = Too easy, skip  
> "Is it a well-known pattern?" → YES = Too easy, skip  
> "Does solution require < 150 lines?" → YES = Too easy, skip  
> "After the core insight, is the rest mechanical?" → YES = Not enough independent forks  
> "Can an agent copy a pattern from Python/JS/Go/Rust?" → YES = Knowledge-transfer risk  
> "Does a simple version pass 80%+ of tests?" → YES = Fundamentally too simple

---

## Uniqueness Preflight Gate

### Why This Is Mandatory

Difficulty and quality can be excellent and still get rejected for high similarity to an older Olympus challenge. To prevent losing full iterations, run a uniqueness preflight before deep implementation.

Do not treat local comparison as a reliable uniqueness gate: other contributors' submissions are not available locally. Platform plagiarism checks are the authoritative source of duplicate/similarity decisions.

### Preflight Policy

Before investing in full trap depth (large tests and 700+ solution lines), submit a **basic but valid** package to validate originality/similarity risk early.
Start drafting this minimal package while crafting the idea so platform plagiarism checks can run without delay.

Minimum preflight package:

- A concise, non-prescriptive description of the core behavior
- A valid `test.sh` + small representative test patch
- A minimal solution patch that applies cleanly
- A working Dockerfile
  If patches are drafted manually at this stage, they must use valid unified diff syntax and correct file modes.

### Decision Rule

1. If preflight is clear: continue to full implementation and difficulty tuning.
2. If preflight is flagged as duplicate/similar: stop immediately and pivot to a different idea.
3. Do not rely on title-only or wording-only changes to solve similarity collisions.

---

## Workflow Steps

### Step 0: Run Uniqueness Preflight (MANDATORY)

- Build a basic, valid package quickly (time-boxed, minimal depth)
- Submit once to validate originality/similarity
- Only continue to deep implementation after preflight is clear
- If similarity is high, abandon and restart with a different idea

### Step 1: Clone & Save Base Commit (CRITICAL)

```bash
# Clone repository
git clone https://github.com/[org]/[repo].git repos/[repo]
cd repos/[repo]

# IMMEDIATELY save base commit
git rev-parse HEAD > ../../my-work/{repo_name}-{description}/BASE_COMMIT-{description}.txt
echo "https://github.com/[org]/[repo]" >> ../../my-work/{repo_name}-{description}/BASE_COMMIT-{description}.txt
echo "Base commit: $(head -n 1 ../../my-work/{repo_name}-{description}/BASE_COMMIT-{description}.txt)"
```

`BASE_COMMIT-{description}.txt` must contain exactly the base SHA on line 1 and the GitHub repository URL on line 2. Checkout commands must read only line 1.

### Step 2: Verify Base Tests Pass

```bash
# Install dependencies
# Python: pip install -e .
# TypeScript: bun install / npm install
# Go: go mod download

./test.sh --output_path /tmp/base.xml base  # Must pass on base code (regression tests only, affected by the solution)
```

### Step 3: Reproduce Bug (if it's a bug)

- Create minimal reproduction
- Verify bug exists on base code
- Document expected vs actual behavior
- If can't reproduce, find another one

### Step 4: Write Tests

- 30+ tests covering the behavior
- ALL new tests must fail on base code (before applying the solution)
- Match existing repo test style
- Cover sync AND async variants
- Include all edge cases
- No comments or string docs (unless following the repo standards)

### Step 5: Implement Solution

- 700+ non-empty lines of changes (Diamond target 900-1200+)
- Follow repo coding style
- No AI-style code patterns
- Test incrementally
- No comments or string docs (unless following the repo standards)
- Solve the problem from its roots
- Be comprehensive and professional

### Step 6: Verify

```bash
./test.sh --output_path /tmp/base.xml base  # Must still pass
./test.sh --output_path /tmp/new.xml new   # Must now pass
```

### Step 7: Generate Patches

See [Patch Generation](#patch-generation) section.

> [!IMPORTANT]
> All implementation work goes under the repo itself, not the working directory (aka, the directory under my-work), then we generate the patches from the repo itself to the work directory like what's mentioned in [Always Generate From Base](#always-generate-from-base), but never do the implementation in the working directory (aka, the directory under my-work).

---

## Problem Description

### Format

- **Length**: Depends on the problem
- **Structure**: analyze accepted work to gain more insights.
- **Goal**: Behavior-focused, hard for AI (target 1-3/10 agent pass rate; Diamond <=30%, 4/10 does not qualify. Lower is better)
- **Style**: Natural flowing prose, no rigid section headers (e.g. no `## Description`), only ASCII characters

### Writing Style (from Shipd review team)

1. Be concise: only mention what's necessary; no need to include discoverable details
2. Avoid to seem it's AI-written description
3. Avoid being prescriptive unless implementation details are required
4. No titles or rigid sections (e.g. "test assumptions"); keep it natural
5. Don't frame the prompt as if the repo is external (e.g. don't start with "X currently supports Y but lacks Z")
6. Don't turn it into a list of requests or snappy instructions; it should flow naturally
7. Don't list discoverable repo details (behavioral or implementation) unless necessary
8. Don't use code snippets when plain English works better, unless needed for expected shape/structure or clarity

### Rules

| Do                               | Don't                                   |
| -------------------------------- | --------------------------------------- |
| Describe WHAT is broken          | Describe HOW to fix                     |
| State expected behavior          | Include pseudocode                      |
| Be specific about symptoms       | Mention file names                      |
| Use neutral language             | Give implementation hints               |
| Write naturally flowing prose    | Use rigid sections or instruction lists |
| Use plain English where possible | Use code snippets when English works    |
| Mention only what's necessary    | List discoverable codebase details      |

### Contract-Lock Rule (Critical)

- If tests require **exact** error text or exact literal markers, description must explicitly state that contract.
- If tests only require semantic markers, description should use containment-style wording.
- Do not mix contain-style description with exact-string assertions for the same behavior.
- Core tested behavior must be in the description itself; do not rely on reviewer notes to define mandatory semantics.

### What NOT to Include

- Hints about implementation approach
- Discoverable repo behavior that tests don't depend on
- Process details (build tags, compile modes) unless non-obvious

> [!NOTE]
> You will gain a lot of insights from analyzing accepted work.
> What's accepted and not accepted differ based on the test patch.
> You should balance everything to avoid failing in the AI checks.

---

## Test Standards

### Requirements

| Metric            | Target     |
| ----------------- | ---------- |
| Count             | 30+ tests  |
| Lines             | 700+ lines |
| Fail rate on base | 100%       |

### Coverage Requirements

- ✅ All scope configurations (global, scoped, local)
- ✅ Sync AND async variants
- ✅ Edge cases and error paths
- ✅ Plugin composition if applicable
- ✅ Different HTTP methods if applicable

### Code Rules

- ❌ NO comments in test code
- ❌ NO debug statements
- ❌ NO `any` types (TypeScript)
- ✅ Match existing repo test style
- ✅ Variable names vary (not always `expected`, `result`)
- ✅ Focus on testing the behavior, as much as possible
- ✅ Follow the professional testing practices

### Test Robustness

**Avoid brittle patterns:**

- ❌ Regex patterns that break on combined sequences
- ❌ Exact string matching on styled output
- ❌ Tests depending on specific glyph rendering

> [!NOTE]
> When we are forced to follow some brittle or bad practices, we can add a reviewer note explaining our reasons in a simple and concise way.

**Prefer robust patterns:**

- ✅ Parse numeric values from structured formats
- ✅ Strip formatting before content assertions
- ✅ Handle edge cases (empty content, missing fields)
- ✅ Order-independent comparisons when order doesn't matter

### Assertion Policy (Exact vs Contains)

- Use exact-string assertions only for user-facing contract lines that are explicitly documented.
- Use contains-style assertions for non-contract-critical diagnostics to reduce brittle mismatch noise.
- During iteration, if review data is dominated by `FAIL_TEST_MISMATCH`, audit this policy before changing feature scope.

### Trap Depth vs Redundancy

- Avoid mass variants of the same behavior only to increase line count.
- Prefer non-redundant trap intersections (scope + control flow + composite values + reassignment paths).
- Consolidation is good only if behavior cardinality is preserved.

### Focus on Behavior

**Bad:**

```typescript
expect(transport.listeners.length).toBe(1); // Tests internal state
```

**Good:**

```typescript
transport.emit("change");
expect(callback).toHaveBeenCalled(); // Tests observable behavior
```

---

## Solution Standards

### Size & Style

- **Target**: 700+ non-empty lines (Diamond 900-1200+; below ~700 might be too easy)

### Human-Style Code (CRITICAL)

Code must NOT look AI-generated. AI patterns get rejected.

| AI Pattern ❌            | Human Pattern ✅                  |
| ------------------------ | --------------------------------- |
| Comment every block      | Some blocks uncommented           |
| `# Handle edge case:`    | `# edge case` or nothing          |
| Docstrings on everything | Some functions without docstrings |

### Rules

- ✅ Explicit variable names (responseStatus, not rs)
- ✅ Consolidate related loops
- ✅ Defensive checks (isinstance, null checks)
- ✅ Handle edge cases explicitly
- ❌ **NO comments or docstrings** (but don't remove existing upstream comments)
- ❌ **NO debug statements** (console.log, print)
- ❌ **NO unused variables**
- ❌ **NO AI slop** (verbose, over-commented, or obviously auto-generated boilerplate)

---

## What Makes Problems Get REJECTED

### Too Easy

- Type annotation fixes
- One-liner conditionals
- Simple flag additions
- Missing null checks
- Fix can be described in one sentence

### Poor Description

- Implementation hints included
- Redundant or "helpful" phrasing

> [!NOTE]
> Again analyze the accepted work deeply and how they are aligned with the test patch.

### Test Issues

- New tests pass before applying the solution patch
- Non-deterministic or brittle timing

---

## test.sh Requirements

### Template

```bash
#!/bin/bash
set -e

OUTPUT_PATH=""
MODE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --output_path)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        base|new)
            MODE="$1"
            shift
            ;;
        *)
            echo "Usage: $0 --output_path <path> {base|new}"
            exit 1
            ;;
    esac
done

if [[ -z "$MODE" ]]; then
    echo "Usage: $0 --output_path <path> {base|new}"
    exit 1
fi

case "$MODE" in
  base)
    # Run existing regression tests only
    python3 -m pytest tests/{related_existing_tests} --ignore=tests/test_new.py \
      -v --junitxml="$OUTPUT_PATH"
    ;;
  new)
    # Run new tests only
    python3 -m pytest tests/test_new.py \
      -v --junitxml="$OUTPUT_PATH"
    ;;
esac
```

- Different languages apply the same template, but the commands and JUnit reporters differ
- The `--output_path <path>` flag is **required** -- the platform passes it to produce JUnit XML

### JUnit XML Setup by Framework

| Framework   | Setup                                        | Command Flag                                                                  |
| ----------- | -------------------------------------------- | ----------------------------------------------------------------------------- |
| **pytest**  | Built-in                                     | `--junitxml="$OUTPUT_PATH"`                                                   |
| **vitest**  | Built-in                                     | `--reporter=junit --outputFile="$OUTPUT_PATH"`                                |
| **jest**    | Install `jest-junit` in Dockerfile           | `JEST_JUNIT_OUTPUT_DIR/NAME` env vars                                         |
| **go test** | Install `go-junit-report` in Dockerfile      | Pipe `-v` output to `go-junit-report`                                         |
| **mocha**   | Install `mocha-junit-reporter` in Dockerfile | `--reporter mocha-junit-reporter --reporter-options mochaFile="$OUTPUT_PATH"` |
| **deno**    | Built-in                                     | `--junit-path="$OUTPUT_PATH"`                                                 |

**Go example:**

```bash
# In Dockerfile:
RUN GOWORK=off go mod download
RUN go install github.com/jstemmer/go-junit-report/v2@v2.1.0

# In test.sh (with output_path):
GOWORK=off go test -v -count=1 ./pkg/... -timeout 10m 2>&1 \
  | go-junit-report -set-exit-code > "$OUTPUT_PATH"
```

The `-v` flag is required for go test -- `go-junit-report` parses verbose output.

> **IMPORTANT (Go repos):** Do NOT use `-mod=vendor` in test.sh. Agents can corrupt the vendor directory, causing `FAIL_TEST_BROKEN` (platform fairness violation). Use `go mod download` in Dockerfile and default module resolution in test.sh.

### Rules

- ✅ Must be executable (`chmod +x test.sh`)
- ✅ In `test-{description}.patch`, `test.sh` must be `new file mode 100755`
- ❌ `test.sh` as `new file mode 100644` is a blocking patch error
- ✅ Support `--output_path <path>` flag for JUnit XML output
- ✅ Support `base` and `new` modes
- ✅ Use `set -e` to fail fast
- ❌ **NO --bail flags**
- ❌ **NO dependency installation** (use Dockerfile)
- ❌ **Avoid rebuilding the project** (doesn't work on shipd platform)

---

## Dockerfile

### Template

```dockerfile
FROM public.ecr.aws/d3j8x8q7/olympus-base-python:latest
WORKDIR /app
COPY . .
RUN pip install -e . pytest                   # Write the equivalent for other languages
# Install JUnit XML reporter if needed (e.g., go-junit-report for Go)
CMD ["/bin/bash"]
```

**Go example (validated):**

```dockerfile
FROM public.ecr.aws/d3j8x8q7/olympus-base-go:latest
ENV GOBIN=/usr/local/bin
WORKDIR /app
COPY . .
RUN GOWORK=off go mod download
RUN go install github.com/jstemmer/go-junit-report/v2@v2.1.0
CMD ["/bin/bash"]
```

For new submissions, use the language-specific base image that matches the repo:

- `public.ecr.aws/d3j8x8q7/olympus-base-python:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-typescript:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-rust:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-go:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-cpp:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest`

Java and C/C++ are now supported. For setup details and examples, see [standards/[EXT] Java _ C++ Support Overview.md](<F:\.shipd\Shipd - Olympus\standards\[EXT] Java _ C++ Support Overview.md:1>).

### Rules

- ✅ Use the matching language-specific `olympus-base-*` image for new submissions
- ✅ Install dependencies at build time
- ✅ Works with `docker run --network none`
- ❌ **NO comments**
- ❌ Avoid `yarn build` / `npm run build` during image build unless absolutely necessary

### Monorepo Warning

In monorepos, Docker builds BEFORE patches apply:

1. Docker runs `yarn install && yarn build`
2. `dist/` folders created with original code
3. THEN test.patch applied
4. If solution adds new types to core, `dist/` won't have them

**Safe:** Runtime method patching, monkey-patching existing methods  
**Unsafe:** Adding new type exports to core packages

---

## Patch Generation

### Always Generate From Base

Patches must show diff from original base commit, NOT your work commits.

### Process

```bash
# Stage files
git add test.sh path/to/test_file.py path/to/solution.py

# Generate test patch (test files only)
git diff --cached -- test.sh path/to/test_file.py > /home/zeyad/Downloads/Shipd/my-work/{repo_name}-{description}/test-{description}.patch

# Generate solution patch (solution files only)
git diff --cached -- path/to/solution.py > /home/zeyad/Downloads/Shipd/my-work/{repo_name}-{description}/solution-{description}.patch
```

### Verification

**Test Patch:**

- `grep "new file mode 100755" test.patch` → Must find test.sh
- `grep -A1 "diff --git a/test.sh b/test.sh" test.patch` → Must show `new file mode 100755`
- If mode is wrong: `chmod 755 test.sh` and regenerate patch from base
- If Git still records wrong mode on Windows: `git update-index --chmod=+x test.sh` then regenerate patch
- Include testing helper code.
- Must NOT include Dockerfile, description, or solution code

**Solution Patch:**

- `grep -i "comment\|//\|/\*" solution.patch` → Must be empty (unless we follow the repo standards)
- `grep "test.sh" solution.patch` → Must be empty
- Must NOT include tests

---

## Pre-Submission Checklist

### Uniqueness Preflight

- [ ] Preflight submission completed before deep implementation
- [ ] No duplicate/similarity blocker found in preflight
- [ ] If preflight flagged similarity, idea was replaced (not reworded only)

### Problem Selection

- [ ] Repo has 500+ stars
- [ ] Permissive license
- [ ] No existing PR and no online implementation
- [ ] Go/Rust/TypeScript/Python project
- [ ] Bug reproducible on base code
- [ ] Solution cannot be described in one sentence
- [ ] Solution touches multiple components and files (6+ files)
- [ ] Requires ≥ 4 hours for experienced dev

### Problem Description

- [ ] Figure out depending on the problem
- [ ] Describes WHAT is broken
- [ ] NO file names, pseudocode, hints
- [ ] Aligned with tests

### Tests

- [ ] 30+ tests
- [ ] 700+ lines
- [ ] 100% fail on base code
- [ ] Matches repo style
- [ ] NO comments or debug statements

### test.sh

- [ ] Executable
- [ ] test patch records `test.sh` as `new file mode 100755` (not `100644`)
- [ ] Supports `--output_path <path>` for JUnit XML output
- [ ] `base` mode runs regression tests
- [ ] `new` mode runs new tests only
- [ ] JUnit XML reporter installed in Dockerfile (if needed)
- [ ] NO --bail flags
- [ ] NO dependency installation

### Solution

- [ ] 700+ non-empty lines
- [ ] NO comments (don't remove upstream)
- [ ] NO debug statements
- [ ] Human-style code
- [ ] Handles edge cases
- [ ] Touches multiple components and layers

### Dockerfile

- [ ] Uses the matching language-specific `olympus-base-*` image
- [ ] NO comments

### Final Verification

```bash
# Clean repo
git reset .
git clean -fd && git restore .

# Apply and test
git apply test-{description}.patch
./test.sh --output_path /tmp/base.xml base  # All Must PASS
./test.sh --output_path /tmp/new.xml new    # All Must FAIL

git apply solution-{description}.patch
./test.sh --output_path /tmp/base2.xml base  # All Must PASS
./test.sh --output_path /tmp/new2.xml new    # All Must PASS
```

---

## Submission & Platform Rules

### Quality Score

Reviewers evaluate every submission against 21 checklist items across three categories:

- **Problem (1-7)**: Requirements, ambiguity, conciseness, scope, design philosophy, irrelevant context, formatting
- **Tests (8-15)**: Missing behavior, determinism, assertions, behavior vs internals, repo structure, coverage, conciseness, unspecified behavior
- **Solution & Code (16-21)**: Meets requirements, no regressions, no defensive code, no irrelevant changes, API stability, no AI slop

Your submission must score **5 or above out of 7** on the quality scale to be accepted. Higher quality means higher reward.

### Scope Requirement

Challenges must be system-level and multi-file. Successful agent runs must modify at least **3 files**, take at least **100 agent steps** (counted as messages), and add at least **700 lines of code** (median across successful runs). Single-file fixes, trivial CRUD additions, and narrow changes do not qualify.

The solution patch must include at least **700 non-empty lines of real, purposeful code changes**. Blank lines, artificial line inflation, filler, or dead/unreachable code intended to bump the count are strictly disallowed and will be rejected.

> **Diamond-tier note.** The 700-line figure above is the platform FLOOR for any qualifying challenge — it is NOT the Diamond target. A reference solution that lands near 700-750 non-empty is borderline-too-easy and risks a high pass rate. For Diamond, calibrate against `.agent/rules/idea-crafting.md` ("Solution Patch Size") and `.agent/rules/solution-writing.md` ("Diamond-Tier Sizing"): **700-900+ non-empty lines of genuine logic (our accepted Java Diamonds run ~850-1200), 6-8+ files / 5+ layers, 900-1200+ total patch lines for our best problems.** Reach this through more INDEPENDENT semantic forks and genuine ripple into existing subsystems — never by padding (padding is rejected by the rule above and "catches zero agents"). If the honest solution lands near the floor, the IDEA is under-scoped; deepen the idea rather than inflate the diff.

### Token System

- New contributors start with an initial token balance
- Finalized approvals earn bonus tokens (reward varies by tier)
- Tokens replenish hourly based on your contributor tier (determined by approval rate and number of finalized approvals)
- Running checks consumes tokens -- be deliberate with your edits and fix issues before rerunning
- Running checks on every small tweak will drain your balance quickly
- We need to make our work solid from the first attempt as much as possible.

### Check Staleness

- Editing any submission content after checks have completed marks those results as stale
- Stale checks must be rerun before you can submit -- this costs tokens again
- Fix all issues thoroughly in one pass before rerunning

### Run-Quality Interpretation

- If many runs are `DID_NOT_RUN` or missing agent verdicts, rerun before changing design.
- If runs complete and verdicts are stable, treat results as true difficulty signal.
- Do not overreact to infra-noise by rewriting requirements or broadening solution scope.

### Historical Bypass Notes

The current panel and exact artifacts control whether an evaluation label can be reclassified. A
written explanation does not waive a numeric gate, solvability, fairness, repo fit, golden defect,
or required false-positive evaluation.

**Possible evaluator-label correction:**

1. **Test collision/conflict**: if exact run artifacts prove `TEST_MISMATCH` is only an evaluator or
   name collision, record the evidence and ask for reclassification. Do not generalize that into a
   metric bypass.

**Important:**

- At least one legitimate passer is required.
- Use the current live panel for every threshold and required check.
- Reproduce false-positive and golden claims before disputing a result.

### Submission Criteria

From the platform checks:

- **All runs completed**: All agent runs must finish without infra errors or stale results
- **Fair task**: No agent flagged the task as unfair or broken
- **Solvable**: At least 1 agent run must solve the problem
- **Hard**: At most 4 agent runs solve it (2-4/10). For Diamond the gate is stricter: <=30% = at most 3/10 (4/10 = 40% does NOT qualify).
- **Long-horizon**: Median of successful runs: >=5 files modified, >=100 agent steps, and >=700 LOC added

### Quick Check

Before the full 10-run evaluation, the platform runs a **Quick Check** with a single agent as an inexpensive sanity check. This validates that the build, test.sh, patches, and basic setup work before committing to 10 runs. Fix any issues flagged here before submitting for full evaluation.

Quick Check is not a uniqueness gate. Keep the separate preflight submission policy for duplicate/similarity risk.

### Holistic AI Reviewer

The platform uses a **Holistic AI Reviewer** that reads all agent runs to catch systematic trivial failures (environment setup issues, test running problems, etc.). This prevents wasting runs on problems with setup bugs.

---

## Tips for Horizon & Pass Rate

### Increasing Horizon and Pass Rate (from 0 passes)

- Don't point the agent directly to files that need to change -- let it explore and find them. The task should still be precise and unambiguous. Add exploration, not confusion.
- Prompt the agent to read key files, understand the codebase structure, and answer key questions before starting
- Prompt the agent to test its own changes

### Reducing Over-Solve (when passes > target)

- Keep description contract stable once precision is healthy.
- Increase difficulty with **small, surgical** trap-depth increments, not broad rewrites.
- Add tests that target near-correct implementations:
  - shadow/rebind boundary behavior,
  - branch-selective invalid writes,
  - mixed declaration/assignment error-path consistency,
  - composite-value source and expansion intersections.
- Re-run and re-measure after each small change.

### Agent Messages vs Agent Steps

The platform counts **agent messages** instead of agent steps. This properly accounts for parallel tool calls, reasoning steps, etc. The platform uses a mix of agents (Nova, Vega, Orion).

This means tasks that were previously flagged for short horizon may now pass with the new counting.

### If Median Messages Is Low

Sometimes agents solve your task too quickly, dragging down the median agent messages. Options:

1. Rerun All to try to get more solving runs with higher message counts
2. Use "Check Bypass" with a short note explaining why

---

## AI Difficulty Guide

### What Makes Problems PASS AI Difficulty

1. **Requires investigation**: Trace through multiple files
2. **Non-obvious root cause**: Symptom differs from bug location
3. **Cross-component understanding**: Multiple parts interact
4. **No public "how-to"**: No existing documentation about fix
5. **Subtle edge cases**: Non-obvious scenarios trip up naive implementations

### What Makes Problems FAIL AI Difficulty

1. **Well-known patterns**: "add null check", "use WeakSet for circular refs"
2. **Implementation hints in description**: Mentioning mechanisms or approaches
3. **Tests reveal solution**: Checking implementation details
4. **Publicly documented solutions**: Blog posts, SO answers, PRs
5. **Too few edge cases**: Simple test suites don't trip naive implementations

### The Balancing Act

**The Dilemma:**

- Human reviewers want: Clear, concrete descriptions with specific terms
- AI difficulty wants: Vague descriptions that don't hint at solutions

**The Solution - Test Assumptions:**

When tests MUST check implementation details, add a Test Assumptions/API Interfaces section:

```markdown
**Test Assumptions:** The solution must [specific mechanism]. Tests verify this approach.
**API Interfaces:** [list of interfaces used by the solution]
```

This justifies implementation-specific tests without counting as a "hint."

### Expanding Scope to Increase Difficulty

When AI pass rate is too high (>50%), add requirements that trip naive implementations:

| Original              | Expanded                        | Why It Helps                         |
| --------------------- | ------------------------------- | ------------------------------------ |
| Dynamic array updates | + Deduplication                 | Agents concatenate without comparing |
| Basic CRUD            | + Concurrent access             | Agents ignore race conditions        |
| Single transport      | + Multi-transport deduplication | Agents don't deduplicate             |
| Happy path            | + Graceful failure              | Agents don't handle edge cases       |

### Multi-Layer Architecture Requirements (CRITICAL)

**Problems MUST require work across multiple architectural layers.** Single-file solutions are too easy for AI.

#### Minimum Requirements

| Metric             | Minimum          | Ideal     |
| ------------------ | ---------------- | --------- |
| Files modified     | 6+               | 8-15+      |
| Components touched | 6+               | 7-9+      |
| Lines of changes   | 700+ (non-empty) | 900-1200+ |

#### Successful Pattern: Cross-Component Features

Study the bunster-examples to understand good patterns:

| Example   | Feature     | Layers Touched                                   |
| --------- | ----------- | ------------------------------------------------ |
| bunster-1 | select loop | Tokenizer → AST → Analyzer → Generator → Runtime |
| bunster-2 | source/dot  | Parser → AST → Resolver → Runtime                |
| bunster-3 | coproc      | Parser → AST → Analyzer → Generator → Process    |
| bunster-4 | job control | Parser → Runtime → State Machine                 |

#### Anti-Pattern: Single-Layer Solutions

| Bad (Single Layer)  | Good (Multi-Layer)                                       |
| ------------------- | -------------------------------------------------------- |
| Add helper function | Add feature requiring struct + method + helper           |
| Modify one method   | Modify struct field + constructor + method + tests       |
| Simple detection    | Detection + enforcement + configuration + error handling |

#### Anti-Pattern: Combining Already Submitted Work

**NEVER combine work that was already submitted as a separate problem:**

- If "Safe Mode" was submitted as problem A, don't add it to problem B
- Each problem must be entirely new work, not a composition of existing submissions
- Combining leads to rejection: "overlapping functionality with existing submission"

**Example (BAD):**

```
Problem A: "Add Safe Mode" (submitted)
Problem B: "Add Multi-Query + Safe Mode" ← REJECTED (includes A's work)
```

**What to do instead:**

- Keep problems independent and non-overlapping
- If you want multi-layer difficulty, find new extensions within the same domain

#### Test Requirements Must Match

**Tests should verify behavior at integration points:**

```go
// BAD: Only tests helper function
func TestIsModifyingQuery(t *testing.T) { ... }

// GOOD: Tests full integration
func TestClient_ReadOnlyMode_BlocksQueries(t *testing.T) { ... }
func TestClient_ReadOnlyMode_AllowsSelect(t *testing.T) { ... }
func TestIsModifyingQuery_EdgeCases(t *testing.T) { ... }
```

#### When to Abandon an Issue

If after designing the solution you find:

- Solution touches only 1 file → **Abandon or expand scope**
- Core logic < 150 lines → **Abandon or add integration**
- Tests only verify one function → **Add integration tests**

---

## File Structure

```
/Shipd/
├── standards/                   # General rules (this file)
│   ├── WORKFLOW.md
│   ├── QUERIES.md               # Quick access well-crafted problems for easy access
|   └── loay_notes.md            # The workflow of my friend loay
|
├── repos/                       # Cloned repositories
│   ├── strawberry/
|   ├── participle/
│   └── dblab/
│
├── my-work/
│   ├── Accepted/                # Accepted submissions
│   ├── Rejected/                # Rejected submissions
│   ├── Waiting/                 # Pending review
│   │
│   └── {REPO_NAME}-{description}/
│       ├── {description}-plan.md              # Immutable initial plan created during idea crafting
│       ├── {REPO_NAME}-{description}.md       # Problem description
│       ├── test-{description}.patch           # Generated from test.sh and test files
│       ├── solution-{description}.patch       # Generated from solution files
│       ├── Dockerfile-{description}
│       ├── BASE_COMMIT-{description}.txt      # Line 1: base SHA. Line 2: GitHub URL
│       ├── {description}-auto-review.json     # Downloaded holistic review artifact, when available
│       ├── {description}-agents-runs/         # Saved per-agent artifacts
│       ├── {description}-ai-evaluation.md     # Cross-run evaluation, when written
│       ├── {description}-human-reviews.md     # Human review notes/responses
│       └── {description}-next-plan.md         # Optional, only when explicitly requested
│
└── *.md    # Some misc files with different purposes, only added by user.
```

### Forbidden Files

Never create in issue folders:

- ❌ Extra summary/plan files (`PLAN.md`, `SUMMARY.md`, ad hoc notes). The planned exceptions are `{problem-name}-plan.md` during idea crafting and `{problem-name}-next-plan.md` when explicitly requested.
- ❌ Progress updates (READY.md, CHECKLIST.md)
- ❌ Debug files (debug.ts, log.txt)
- ❌ Implementation notes

> [!IMPORTANT]
> Don't add any extra files unless asked by the user

### Version Control for Problem Work (New Working Approach)

When the user asks for a commit message, write it to `commit-message.txt` as a temporary side file and base it on the current review data: auto-review JSON, agents-run artifacts, AI evaluation, human reviews, or any legacy AI report. `commit-message.txt` is not part of the official problem artifact structure or final deliverables. Do not create a next-plan file during commit-message work unless explicitly asked.
Initialize a git repo in each problem work directory to track iterations:

**Recovery from overcorrection:**

```bash
# If a later version makes problem too easy
git checkout v1  # Go back to harder version
git checkout -b recovery
# Apply minimal surgical fixes only
```

**Required Files to Track:**

| File                                                | Purpose                           |
| --------------------------------------------------- | --------------------------------- |
| `{description}-plan.md`                             | Immutable initial plan and executor handoff |
| `{REPO_NAME}-{description}.md`                      | Problem description               |
| `{description}-auto-review.json`                    | Holistic review result, when available |
| `{description}-agents-runs/`                        | Per-agent trajectories, evaluations, XML, and patches |
| `{description}-ai-evaluation.md`                    | Cross-run evaluation, when written |
| `{description}-human-reviews.md`                    | Human review notes/responses |
| `{description}-next-plan.md`                        | Optional future iteration plan, only when explicitly requested |
| `test-{description}.patch`                          | Test patch                        |
| `solution-{description}.patch`                      | Solution patch                    |
| `Dockerfile-{description}`                          | Docker configuration              |
| `BASE_COMMIT-{description}.txt`                     | Line 1 base SHA, line 2 GitHub URL |

**Why This Matters:**

1. **Easy rollback** - If v2 makes problem too easy, return to v1
2. **History preservation** - See what worked vs what didn't
3. **Minimal fixes** - Apply surgical fixes to good versions instead of redesigning
4. **Agent handoff** - Next agent can understand the journey

> [!IMPORTANT] This is very important to learn from the journey and a cure for the agent's hallucination.
> With every iteration we go through we wait witout commiting the changes, until I return with the results.
> Then document the whole journey with the results, and if there are some changes required, work on them, and wait without commiting the changes, until I return with the results, and so on.
> If I give you updates regarding the ai difficulty checks (report), then you commit with tag vX.
> The commit message should follow that approach:
>
> - problem: what is the problem we are trying to solve with the current state.
> - approach: what is the approach you follow to solve the problem (details about the current un-committed work).
> - results: the warnings and errors and notes I gave to you here in this chat.
> - The commit message shouldn't contain 'vX' only tags does.
> - Never commit until I explicitly tell you to do.
> - The commit happens to the working directory (under my-work/\*) not the repo codebase.

## Common Mistakes

### Problem Selection

- ❌ Choosing problems with one-liner solutions
- ❌ Not checking for existing PRs or online implementations
- ❌ Picking "good first issue" labels
- ❌ Continuing after realizing solution is simple

### Tests

- ❌ Tests pass on base code before solution
- ❌ Implementation-specific tests (checking internal state)
- ❌ Comments and docstrings in test code
- ❌ Not matching repo's existing test style

### Solution

- ❌ AI-style comments on every block
- ❌ Debug statements left in code
- ❌ Removing upstream comments

### Patches

- ❌ Generating patches from work commits instead of base
- ❌ Including solution code in test patch
- ❌ Including test code in solution patch

---

## Reviewer Notes

When tests require patterns that might seem brittle, add a reviewer note explaining:

1. **Why it's necessary** - What can't be tested any other way
2. **What makes it robust** - How it handles edge cases
3. **Regression coverage** - What backward compatibility tests exist

**Example (Deduplication Behavior):**

> [!NOTE] This space is optional to add, we use it to clarify our reasons of doing some bad practices, or do specific work, that AI checks complain about, but it's reasonable and intentional.

```
Tests use exact length assertions intentionally to verify proper
deduplication behavior. The ignoreUrls should contain only transport-derived
URLs with no additional defaults. This ensures duplicates are eliminated,
not just accumulated.
```

**Example (Visual Output Testing):**

```
The test suite relies on parsing ANSI escape codes and box-drawing characters.
This tight coupling is intentional and necessary:

- Nature of the Bug: The issue is purely visual misalignment in rendered output.
  There is no public API to inspect semantic highlight positions; the rendered
  ANSI stream is the only observable side effect.

- Resilience: The tests strip box-drawing characters (│) when verifying alignment
  to focus solely on the relationship between the underline and the source text.
  The ANSI parser handles standard SGR codes, including underline reset (24) and
  full reset (0).

A regression test (test_traceback_backward_compatibility) is included to ensure
standard space-indented tracebacks remain unaffected.
```

**Example (Database Feature Testing):**

```
Tests for maintenance statements (VACUUM, REINDEX, ANALYZE) verify that Client.Query
returns an error when read-only mode is enabled. While SQLite would also reject these
statements with its own error, the test validates that the blocking logic detects them
BEFORE execution, as evidenced by the read-only-specific error message. This ensures
cross-database compatibility where the underlying database may support these operations.
```

### Common Mistakes

- ❌ Add implementation hints in this space
- ❌ Explain every small decision we took
- ❌ AI written style
- ❌ Showing only What without how.
- ❌ Be too verbose without necessity.

---

## Getting Issues JSON

To get a repository's issues for offline analysis:

```bash
gh issue list --repo {owner}/{repo} --state all --limit 300 \
  --json assignees,author,body,closed,closedAt,comments,createdAt,id,labels,milestone,number,reactionGroups,state,title,updatedAt,url \
  > /home/zeyad/Downloads/Shipd/{repo}-issues.json
```

---

## Things to Keep in Mind while Working

> [!NOTE]
> Most of the problem can follow the easy/workaround/straightforward path and it will work in most of the scenarios, but in a large scope it will fail because it's not following the professional path that solve the problem from its origin and prepare the infrastructure to be ready to built up on it.
> This easy paths can be eliminated with solid testing, so again the idea itself can be easy or hard depending on how much it should consider, but that should be behaviorally, and the problem itself touch a lot of aspects to avoid adding redundant extras on it.
>
> In general you got my idea, so take that under consideration while you're picking an idea, and compare it with the other accepted work, if it can produce a hard task then go with that.

> [!NOTE]
> When writing the description, make sure it's aligned with what's inside within the test patch.
> Some descriptions might be good with a specific test patch, and when we do some changes to the patch, then the description will not be valid.
> That alignment must be preserved along with behavior-focused description, without adding too much implementation details.
> In general, it's better to make test patch loosly coupled with implementation details as much as possible.
> Also, obvious details and language conventions could not be added to the description, and add a simple reviewer note, but make sure it's very obvious to avoid ambiguity in the description, and any expected behavior or hidden assumptions must be declared, and we can think how to balance that with preserving the behavior-focused and concise description, by rephrasing, concatenating with the original description, or sometimes make it implicit, and add a reviewer note, etc.
> Clarity is very important, we don't want to have any hidden details. If we wrote a sentence that can be mis-understood even if it's low percent to happen this will be very bad. Shipd cherishes clarity, and that mean that the problem we are working on must be difficult and touch a lot of aspects.

> [!NOTE]
> When I tell you to analzye the history of the work, you should go to that directory and iterate on each version from v1 to the latest version, and read the following:
>
> - Commit Message
> - description file
> - test patch
> - solution patch
> - auto-review JSON / legacy AI report
> - agents-run artifacts when present
> - human reviews (if any)

> [!NOTE]
> When some changes are needed within the patches, we must avoid updating them. We should apply them to the repo, do the fix correctly and following the repo coding standards, then regenerate them again in the working directory.

> [!NOTE]
> Description should be concise, focused, behavior focues, and complete with no hidden assumptions and fully aligned with the test patch.

> [!NOTE]
> During the initial AI checks, some checks might push against removing some parts that will cause ambiguity if we did, and some might ask for declaring some info that will reveal implementation details in the description which is also forbidden.
> We need to balance all stuff together with preserving the characteristics of the description and meeting all conditions.
> Some of these errors and warnings can be handled with multiple approaches:
>
> - Description conciseness could be handled by reviewer note when we should keep something implicit/explicit, and sometimes it does make sense so we remove a specific part or rephrase it.
> - Gap tests could be added to the test patch to cover the missing aspect.
> - Description is aligned with the test patch could be handled by a reviewer note when we have a reason why we didn't mention it explicitly/implicitly.
> - Error formats should follow other accepted work, and test patch should utilize a professional way for testing it, and declare our approach. No one should fail to understand the error format.

> [!NOTE]
> After you finish and re-generate the patches (solution and test), try to analyze them, and make sure no violation happens regarding the repo coding style and format.
> Also, it's a good idea to search for all \*-human-reviews.md files and read them and get that sense of what issues we might be falling into like whitespaces, or other stuff.
> Don't care about the too specifications regarding this specific problem, but if you think there's a common issue that we are doing attempt to handle before we submit.

> [!NOTE]
> When working on an idea, sometimes there might be multiple possible paths to handle a specific point. I always encourage following the professional and hard path that solve the problem from its roots then make sure the tests fail any other easy/workaround approach.
> This makes a huge difference regarding the AI difficulty checks (which is our hardest aspect in problem creation).

> [!NOTE]
> When working on the problem don't spend too long iterating and fixing without taking your time thinking about the problem itself and remind yourself with this document often to get back into the context and remember our rules that we need to not break.
> I recommend following the incremental approach for accurate and professional outcomes.
> After analyzing other work and how they approached the problems, and delivered a successful work, you should learn how they comprehensivly tested all aspect of the problem and how description is clear and aligned with that test patch and also how it utilized reviewer note space for good balancing between tradeoffs.
> After you understand and get the correct insights you should start with solid testing that can compete against other work and eliminate all easy and naive approaches from passing. Only solid, professional, and complete work will pass.
> Then craft the description that aligned with the test patch and also behavior focused, complete, clear and concise.
> After that you should work on implementing the solution that's professional and solve the problem from its roots, and don't add implementation that are redundant or have no relation to the problem we are working on.
> All of that should follow the rules mentioned in the workflow document, and follow the repo coding style and standards.
> This is an incremental process that if you focus on each step independantly you will produce amazing work that's solid from all aspects.
> Dockerfile and other stuff are usually straightforward, but for new submissions use the matching language-specific `olympus-base-*` image instead of copying an old generic base blindly.

> [!NOTE]
> Don't commit anything to the repo codebase, and those files are the final files that should be in the working directory (only):
>
> - {REPO_NAME}-{PROBLEM_NAME}.md
> - {PROBLEM_NAME}-plan.md
> - test-{PROBLEM_NAME}.patch
> - solution-{PROBLEM_NAME}.patch
> - Dockerfile-{PROBLEM_NAME}
> - BASE_COMMIT-{PROBLEM_NAME}.txt
> - {PROBLEM_NAME}-auto-review.json
> - {PROBLEM_NAME}-agents-runs/
> - {PROBLEM_NAME}-ai-evaluation.md
> - {PROBLEM_NAME}-human-reviews.md
> - {PROBLEM_NAME}-next-plan.md (only when explicitly asked)
>   Other temporary side files might be added when the user asks for them (e.g., difficulty analysis), but they are not part of the official problem artifact structure.
>   All other files like test.sh or any code implementation goes for the actual repo codebase and be embedded within the patche when generating them following the rules mentioned above.

> [!NOTE]
> When the problem has a high pass rate, then we have multiple options to handle that like expanding the problem scope itself to manage another difficult aspect, or expand the testing to catch the tiny edge cases to avoid simple solution for passing or reviewing the description to make sure we are not prescriptive and it describe the observable behavior and use words that doesn't hint to any implementation and neutral and require investigating in the repo to find the solution, but without hiding any info or make any surprise tests. The description help a lot even more than other approaches but this when we have a good and difficult problem on first hand, it plays a key role.

> [!NOTE]
> AI results are not deterministic, and the platform itself receive frequent updates, so the problems that passed before not necessarly will be accepted if we re-run the same problem again now. We reference them to get the general idea not to consider this specific idea is hard. So we might have more difficult idea that not pass and another problem be more easy and it was accepted. Every problem has its own conditions, and there are multiple intersections that will cause failures and that's why we document our work to avoid falling into those mistakes over and over. So take the general idea and make your work as hard and clear as possible and maintain all conditions to pass the checks easily, but don't follow the same patterns as those are not always the best approach.

> [IMPORTANT]
> ⚡ Some Tips: Problem writing:
>
> 1. The problem should be a **behavioral ask** (a behavioral requirement describing the desired outcome), **not an implementation document**. It should be written as **what** and **why**, not **how**.
>
> - How to implement it, is the solver's (AI's) work, so the problem should not leak implementation details (ie. not prescriptive about the solution)
> - Anything obvious from the repository should not be included
> - Points like "maintain backward compatibility" should also not be included, since that is generally expected unless explicitly stated otherwise
>
> **TL;DR:** Do not include content that is de facto, obvious, or just repository conventions.
>
> - You should include method signatures if they are not obvious
> - If the code already has a `constructClonePath` method and you are asking for a distinct path construction, there is no need to mention `constructDistinctPath` since it is obvious
> - Make sure your tests use the repository's conventional method names.
>
> ⚡ Tests writing:
>
> 1. **No surprise tests** - Everything tested should be part of the requirements
> 2. Tests are **adequate** - comprehensive coverage and sufficient
> 3. Tests are **not brittle**
> 4. Someone implementing the feature should be able to pass all tests with a correct implementation.
>
> **Questions to ask when writing tests:**
>
> 1. Are the tests sufficient to validate the behavior described in the problem?
> 2. Are there any extra tests that do not make sense?
> 3. Are there any tests that can be removed because they are not relevant to the problem statement?
> 4. Are any important edge cases missing?
> 5. Are any tests brittle?
>
> ⚡ Solution writing:
>
> 1. Is it a correct solution for the problem statement?
> 2. Does it avoid hardcoded values?
> 3. Does it have any code smells?
> 4. Does it introduce any bugs?
> 5. Does it do anything not asked in the problem?
> 6. Is it missing anything that is asked in the problem?
> 7. Does it **break** any existing functionality?
> 8. **Would you accept this PR as a maintainer?**
>
> **TL;DR:**
> All of this with preserving completeness and clarity. This doesn't mean hide assumptions or write the description in a way that can be mis-understood.

---

## The "Hidden Gem" Approach

Prefer looking for missing features rather than working on an open issue.

1. Do deep analysis of the repo
2. Find a missing feature or hard bug
3. Implement a fix that doesn't exist anywhere

Requirements:

- Must be hard for AI to solve
- No existing PR implementing it
- No online implementation (forks, closed/draft PRs, discussions)
- Follows all quality rules mentioned above

---

## Problem Scope by Difficulty

| Scope                         | AI Difficulty | Why                                                   |
| ----------------------------- | ------------- | ----------------------------------------------------- |
| **Cross-component bugs**      | Hardest       | Symptom in one place, fix in another                  |
| **Lifecycle/timing issues**   | Hard          | Initialization order, race conditions, stale closures |
| **Configuration propagation** | Hard          | Config set in one place, consumed elsewhere           |
| **API contract changes**      | Medium        | Adding methods/types is straightforward               |
| **Single-file bugs**          | Easiest       | All context in one place                              |

---
