---
description: Handle Prechecks, Scope Gate, and Quality check failures or warnings before any agent rollout, without breaking principles
---

# Handle Initial Checks

## When to Use

Run when the pre-rollout platform checks return failures or warnings about the description, tests, solution, Dockerfile, or alignment, before any agent rollout is spent.

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

## Which Checks This Covers

In platform order (see `../rules/olympus-platform.md` section 9):

| Stage | Check | Passing means |
|-------|-------|---------------|
| Prechecks | Repo | URL/commit resolve; stars, activity, language, license meet the floor |
| Prechecks | Problem and tests | Description well formed (length, formatting, no leftover URLs, matches category), not a near-duplicate; test patch valid diff with working `test.sh`, no solution code, no quest leaks |
| Prechecks | Dockerfile | Base image, `WORKDIR /app`, build-time deps, no tests in build |
| Prechecks | Solution patch | Valid, cleanly structured diff |
| Scope Gate | Duplicates / upstream / repo fit | Pass; a drop means rethink the idea, not reword it |
| Build | Build Image | Image builds; rebuild after any Dockerfile change |
| Quality | Verify Tests | `base` passes, `new` fails without the solution |
| Quality | Verify Solution | Both modes pass with the solution |
| Quality | Verify Flakiness | No test changes result across identical runs (blocks everything downstream) |
| Quality | Test Quality | Each hidden test checks something stated or discoverable; advisory coverage notes |
| Quality | Task Quality | Description and tests graded as a pair; failing criteria listed |
| Quality | Solution Quality | Completeness and code quality issues listed |
| Quality | Description Quality | Tone, redundancy, repo-discoverable detail; suggested rewrites |

Only failures block; warnings do not, but read each warning and confirm it is fine. Fix everything
in one pass, then rerun once: every edit stales every completed check, and reruns cost tokens.
Never start agent rollouts while any of these is failing or stale.

## Core Principle

> **Balance all conditions while preserving description characteristics. Never break core principles to satisfy a warning.**

## Warning Types and Approaches

During initial checks, some warnings may push against each other:

| Warning Type | Approach |
|--------------|----------|
| Remove X (would cause ambiguity) | Keep it, rephrase to balance clarity and conciseness |
| Add X (would reveal implementation) | Don't add, rephrase to describe observable behavior without hints |
| Description too verbose | Rephrase concisely while preserving behavioral content |
| Missing test coverage | Add gap tests to test patch |
| Misalignment with tests | Rephrase description to align, or accept warning if behavior is inferable |
| Error format unclear | Follow accepted work patterns, declare approach |
| Remove X (conciseness) | Verify tests don't depend on it. If they do, condense rather than remove |
| Duplicate/similarity warning | Open and read the close matches; if it is genuinely the same task, stop and pivot. Do not rely on title-only or wording-only changes |
| Scope Gate drop | Pivot: already upstream, declined, removed on purpose, duplicate, or off-philosophy cannot be fixed by rewording |
| Test pins exact wording (T7) | Switch to a behavioral assertion unless the description states the text or repo patterns make it obvious |
| Verify Flakiness failure | Remove timing, randomness, ordering, and host-dependence (e.g. fix parallelism) from tests or `test.sh`; never just rerun |
| Quest leak | Rename the file, directory, identifier, or comment to repository-native wording in every patch |
| Category mismatch | Align the description's category line with the category selected on the platform |

## Balancing Tradeoffs

**Preserve these characteristics:**
- Behavioral focus (WHAT not HOW)
- No hidden assumptions
- Clear error formats
- Aligned with test patch
- Mandatory semantics live in Description

**When warnings conflict:**
1. Identify which warning would cause worse harm if fixed
2. Fix the less harmful one by rephrasing to balance both concerns
3. If a warning pushes towards being too explicit (revealing implementation), find alternative wording that stays behavioral
4. Some warnings may disappear on re-run (AI checks are non-deterministic)

## Error Format Handling

Error formats should:
- Follow patterns from other accepted work
- Be tested professionally in test patch
- Declare approach clearly
- No one should fail to understand the format

## Professional Hard Path

> When working on any point, follow the professional hard path that solves from roots. Make tests fail any easy/workaround approach.

This makes a huge difference for AI difficulty checks.

## Steps

### 1. Read All Warnings

Categorize each warning:
- **Must fix**: Clear violations that harm the problem
- **Tradeoff**: Fixing would break another principle
- **Justified**: Already correct, needs explanation

If any warning/review signal indicates duplicate or high similarity to an existing challenge:
- Treat it as a blocker for this idea
- Do not continue deep iteration for this problem line
- Return to idea crafting and choose a new domain/architecture

### 2. Fix Clear Violations

Address warnings that don't conflict with principles.

Exception: duplicate/similarity blockers are not "fix in place" issues. Pivot instead.

### 3. Handle Tradeoffs by Rephrasing

For each tradeoff warning, find a balanced rephrasing that:
- Doesn't give implementation hints
- Doesn't hide mandatory behavior
- Uses alternative wording to satisfy both clarity and difficulty

Note: There is no Reviewer Notes section in the description file. If a human reviewer later questions a design choice, justification is communicated via Discord.

### 4. Add Gap Tests if Needed

If warned about missing coverage:
- Add tests to cover the gap
- Ensure tests don't become "surprise tests"
- Verify tests trace back to description

### 5. Verify Alignment

Ensure description and test patch are fully aligned:
- Every test behavior inferable from description
- No hidden assumptions in tests
- Error formats clearly stated
- Exact-vs-contains assertion style matches stated error contract

### 6. Regenerate and Resubmit

After changes:
```bash
# Regenerate patches
cd repos/{repo}
git reset . && git clean -fd && git restore .
# Apply fixes, regenerate patches, resubmit
```

Before resubmission, validate test patch mode:
- `grep -A1 "diff --git a/test.sh b/test.sh" test-{description}.patch`
- Required result for test.sh: `new file mode 100755` (never `100644`)

## Checklist

- [ ] All clear violations fixed
- [ ] Tradeoff warnings resolved by rephrasing or accepted with justification ready
- [ ] Gap tests added (if needed)
- [ ] Description-test alignment verified
- [ ] Error formats follow accepted patterns
- [ ] Patches regenerated

## FAIL_TEST_BROKEN Prevention

If any agent run shows `FAIL_TEST_BROKEN`, it counts as a fairness violation:

| Cause | Fix |
|-------|-----|
| Agent corrupts vendor directory | Use `go mod download` in Dockerfile, remove `-mod=vendor` from test.sh |
| Agent modifies go.mod breaking vendor | Same fix — module cache is resilient |
| Test binary panics (type assertion crash) | Use safe type assertions in test helpers |
| Agent deletes test infrastructure files | Ensure test.sh is self-contained |

> **Key lesson from multi-catch**: `-mod=vendor` in test.sh caused FAIL_TEST_BROKEN when one agent deleted vendor contents. Switching to module cache (`go mod download` + no `-mod=vendor`) eliminated the issue completely.

## Conciseness Balance Strategy

When AI conciseness checks say "remove X" but X backs a test assertion:

1. **Don't delete** — the test would become a surprise test
2. **Condense** — merge multiple paragraphs into fewer, tighter ones
3. **Integrate** — fold standalone sentences into related paragraphs
4. **Rephrase** — use more concise wording that preserves the semantic content

Example from multi-catch: Three paragraphs about scoping + try-expression + finally → two tighter paragraphs. Word count reduced ~25% while all test-backing semantics preserved.
