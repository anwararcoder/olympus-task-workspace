---
description: Pre-submission review checklist ensuring all standards are met
---

# Review Work

## When to Use

Run before submitting any problem to verify all standards are met.

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

## Pre-Submission Checklist

### Uniqueness Preflight
- [ ] Prechecks (incl. near-duplicate similarity) and Scope Gate passed before deep implementation
- [ ] Close similarity matches were opened and read, not just the verdict
- [ ] If similarity was flagged or the Scope Gate dropped it, this idea was abandoned instead of reworded

### Problem Selection
- [ ] Public GitHub repo, production-level, 500+ stars
- [ ] At least 1 commit in the last 12 months
- [ ] Language is TypeScript, JavaScript, Python, Go, Rust, C++, or Java
- [ ] License is on the allowed list (`../rules/olympus-platform.md` section 2)
- [ ] No existing PR solves it: open, merged, or closed/unmerged
- [ ] Not declined by maintainers in issues or GitHub Discussions; not removed on purpose
- [ ] Fits the project's philosophy (README read)
- [ ] Effective solution LOC clears the criteria panel bar (house target: 6+ files)
- [ ] Cannot describe solution in one sentence

### Description
- [ ] First line is the ask ("Add X to Y" / "Fix Z when ...") and stands without the title
- [ ] No motivation or "what the repo currently lacks" preamble
- [ ] No bulleted requirement lists, no headings, no code snippets doing the describing
- [ ] Category line matches the platform category; no leftover URLs
- [ ] Self-contained, unambiguous, verifiable, not prescriptive (P1-P7)
- [ ] 9-18 lines (sweet spot)
- [ ] Behavioral focus (WHAT not HOW)
- [ ] Natural flowing prose, no rigid section headers
- [ ] Not framed as if repo is external
- [ ] Not written as a list of instructions
- [ ] Plain English preferred over code snippets
- [ ] Only necessary information included (no discoverable details)
- [ ] No file names or pseudocode
- [ ] No implementation hints
- [ ] Error formats stated (if tests verify exact text)
- [ ] ASCII characters only
- [ ] Aligned with test patch
- [ ] Core tested semantics are in description

### Tests
- [ ] 30+ tests
- [ ] 700+ lines in test patch
- [ ] 100% fail on base code
- [ ] Matches repo style
- [ ] No comments or debug statements
- [ ] Build tag isolation (if needed)
- [ ] No surprise tests (all behavior implied by description)
- [ ] Exact-vs-contains assertions match declared error contract
- [ ] No exact wording/format pins unless stated in the description or obvious from repo patterns (T7)
- [ ] Deterministic across repeated runs and machines: no timing, randomness, ordering (T2, Verify Flakiness)
- [ ] No network access (T6)
- [ ] Strong enough that inaccurate solutions fail (T3)
- [ ] No files/directories named challenge/quest/olympus; no Shipd/Olympus/mars anywhere

### test.sh
- [ ] Executable (mode 100755)
- [ ] In test patch, `diff --git a/test.sh b/test.sh` is followed by `new file mode 100755` (not 100644)
- [ ] Supports `--output_path <path>` for JUnit XML output
- [ ] `base` mode runs the repo's real tests for the touched area (not a smoke test)
- [ ] Exclusions only for flaky/network/pre-existing failures, never for tests the solution breaks
- [ ] `new` mode runs new tests only
- [ ] JUnit XML reporter installed in Dockerfile (if needed)
- [ ] No fail-fast flags (`--bail`, `-x`, `--fail-fast`)
- [ ] Failure output and JUnit XML report what actually ran; no masked or hardcoded messages (T8)
- [ ] No comments referencing the challenge
- [ ] No dependency installation
- [ ] (Go) Uses `GOWORK=off` prefix for go test commands
- [ ] (Go) Does NOT use `-mod=vendor` (prevents FAIL_TEST_BROKEN)

### Solution
- [ ] Meets every description requirement (S1)
- [ ] No regressions; follows existing code patterns (S2)
- [ ] No irrelevant changes (S3)
- [ ] No unexplained defensive code or new coding patterns (S4)
- [ ] Effective LOC (excluding blanks, comments, generated files, padding, tests) clears the criteria panel bar
- [ ] 6+ files modified (house target)
- [ ] No AI-style comments
- [ ] No AI slop
- [ ] No debug statements
- [ ] Human-style code
- [ ] Matches repo style
- [ ] Root-cause solution
- [ ] No dead code (unused opcodes, handlers, constructors, methods)

### Patches
- [ ] Generated from base commit
- [ ] Test patch: no solution code
- [ ] Solution patch: no test code
- [ ] Fresh apply verification passes

### Dockerfile
- [ ] Uses the matching language-specific `olympus-base-*` image
- [ ] `WORKDIR /app`
- [ ] Ends with `CMD ["/bin/bash"]`
- [ ] No test commands in any `RUN` step
- [ ] Builds and works without the test or solution patch applied
- [ ] No comments
- [ ] Dependencies installed at build time (runtime is `--network none`)
- [ ] JUnit XML reporter installed (if needed)
- [ ] (Go) Uses `go mod download` (NOT `go mod vendor`)
- [ ] (Go) Uses `GOWORK=off` for module commands

### Final Verification

Mirror the official local review (`../rules/olympus-platform.md` section 8): build the Docker
image, run the container with `--network none`, and run both modes before and after the solution
(rebuild between). Use a private workspace or the remote forge, not the shared clone. The commands
below show the sequence.

```bash
cd repos/{repo}
git reset . && git clean -fd && git restore .
git checkout $(head -n 1 ../../my-work/{problem}/BASE_COMMIT-{name}.txt)

# Apply and test
git apply ../../my-work/{problem}/test-{name}.patch
./test.sh --output_path /tmp/base.xml base  # All PASS
./test.sh --output_path /tmp/new.xml new    # All FAIL

git apply ../../my-work/{problem}/solution-{name}.patch
./test.sh --output_path /tmp/base2.xml base  # All PASS
./test.sh --output_path /tmp/new2.xml new    # All PASS
```

## Acceptance Criteria

Before clicking Submit, the "Submission criteria" panel must be fully green: Prechecks, Scope Gate,
Build, all Quality checks (Verify Tests, Verify Solution, Verify Flakiness, Test Quality, Task
Quality, Solution Quality, Task Prompt Quality), the minimum number of finished and current agent
rollouts with at least one legitimate pass, the FP check ("No false positives"), and a completed
Auto Review. Nothing may be stale.

Human reviewers score Problem Description, Tests, and Solution & Code on a 0-3 scale each (see
`my-review-workflow/rules/platform-panel.md` for the definitions and decision mapping). The older
21-item / "5 of 7" rubric is historical Diamond context only.

Be your own reviewer first: read the agent runs the way a reviewer will. Are failures fair (hard,
not ambiguous or hidden)? Are agents solving it in noticeably fewer lines than the golden (a sign
the effective LOC is lower than it looks)?

## Compare Against Accepted Work

Review structure against tengo-destructuring:
- Description: concise, behavior-focused, no Reviewer Notes section
- Test patch: 762 lines, 66 tests
- Solution patch: 641 lines, 5 files
- Pass rates: 0% Problem Tab, 50% Solution Tab

## Common Mistakes to Catch

From human-reviews.md files:
- Tests check exact error strings without justification
- Build tag undocumented
- Solution iterates instead of O(1) lookup
- Duplicate logic not consolidated
- Fragile parser state handling

## Quality Assessment Questions

1. Would a human reviewer approve this?
2. Is the description clear but not over-specified?
3. Do tests catch naive implementations?
4. Does solution look like repo maintainer's code?
5. Is every test behavior inferable from the description?
6. Was uniqueness validated early enough to avoid late duplicate rejection?

## Report Interpretation Guardrail

Before major redesign from AI results:
- If many runs are missing or `DID_NOT_RUN`, rerun checks first.
- If verdicts are complete and stable, treat results as true signal and tune difficulty surgically.
