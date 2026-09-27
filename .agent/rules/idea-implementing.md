---
description: Guidelines for implementing approved ideas following the incremental process
---

# Idea Implementation

## Core Philosophy

> **Incremental process produces solid work.** Focus on each step independently—tests first, then description, then solution.

---

## The Incremental Process

### Order Matters

```
1. Uniqueness preflight → 2. Tests → 3. Description → 4. Solution → 5. Verification
```

**Why this order?**
- Preflight catches duplicate/similarity blockers before deep investment
- Tests define the behavior (not the solution)
- Description must align with tests (not implementation)
- Solution comes last (solving what's tested)
- This process make us focus on each part independently and do each step perfectly

---

## Step 1: Uniqueness Preflight (Mandatory)

Before deep implementation, run a basic but valid platform submission to check originality/similarity risk via plagiarism checks.

Minimum package:
- concise non-prescriptive description
- valid test patch with `test.sh`
- minimal solution patch
- working Dockerfile

> [!NOTE]
> You can write the patches directly with valid syntax to save time without having to do the changes within the repo and regenerate the patches.

Decision rule:
- If clear, continue.
- If duplicate/similarity is flagged, pivot to a new idea.
- Do not rely on title-only or wording-only changes.

---

## Step 2: Tests First

### Design Before Code

Before writing any test code:
1. List Tier 1 tests (basic functionality)
2. List Tier 2 tests (edge cases)
3. List Tier 3 tests (semantic traps from `{problem-name}-plan.md`)

### Professional Testing

Act as a professional tester who:
- Spots gaps independently
- Designs tests that fail naive implementations
- Ensures every test traces back to description
- Reviews `*-human-reviews.md` for common patterns

### Target Metrics

| Metric | Minimum | Ideal |
|--------|---------|-------|
| Test count | 30+ | 50+ |
| Test lines | 700+ | 900-1200+ |
| Fail on base | 100% | 100% |

> Numbers are guidance. Focus on comprehensive coverage that eliminates naive approaches.

---

## Step 3: Description

### Characteristics

- **Behavior-focused**: WHAT the feature does, not HOW
- **Complete**: No hidden assumptions
- **Clear**: No ambiguous statements
- **Concise**: Only necessary information
- **Aligned**: Every test inferable from description

### What to Include

- Feature behavior specification
- Error formats (if tests verify exact text)
- API interfaces (if notation varies)
- Syntax examples (if applicable)

### What NOT to Include

- Implementation hints
- File names or paths
- Pseudocode or algorithms
- Obvious language conventions

### Balance Tradeoffs

Some warnings oppose each other. Balance:
- Conciseness vs completeness
- Clarity vs over-specification
- Implicit behavior vs hidden assumptions

> Rephrase description to make implicit behavior inferable without adding implementation hints.

---

## Step 4: Solution

### Professional Developer Mindset

Act as a professional developer who:
- Solves problems from roots, not workarounds
- Eliminates naive implementations through solid architecture
- Creates code a maintainer would accept
- Competes with other accepted work in quality

### Target Metrics

| Metric | Minimum | Ideal |
|--------|---------|-------|
| Lines changed | 700+ (non-empty) | 900-1200+ |
| Files modified | 6+ | 6-8+ |
| Components touched | 6+ | 6-8+ |

> Numbers are guidance. Focus on comprehensive, professional solutions.

### Code Quality

- Match repo coding style exactly
- No AI patterns or comments
- No debug statements
- No redundant code
- Solve root cause, not symptoms

---

## Step 5: Verification

### Fresh Apply Test

```bash
# Clean repo
cd repos/{repo}
git reset . && git clean -fd && git restore .

# Apply and test
git apply ../../my-work/{problem}/test-{name}.patch
./test.sh --output_path /tmp/base.xml base  # PASS
./test.sh --output_path /tmp/new.xml new   # All FAIL

git apply ../../my-work/{problem}/solution-{name}.patch
./test.sh --output_path /tmp/base2.xml base  # PASS
./test.sh --output_path /tmp/new2.xml new   # All PASS
```

### Patch Analysis

Before submission, verify:
- No AI comments in solution patch
- No debug statements
- Test patch doesn't include solution code
- Solution patch doesn't include test code
- test patch records `test.sh` as `new file mode 100755` (never `100644`)
- Matches repo coding style

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Tests pass on base | Add semantic traps |
| Description reveals fix | Remove implementation hints |
| Solution too short | Add missing layers |
| AI comments in patches | Remove all comments |
| Tests reveal solution | Focus on behavior, not implementation |
| Duplicate found late | Run preflight before deep implementation |

---

## Iteration Approach

> Never commit until user explicitly says to.

Iterations follow the two-phase rule in `shipd-core-principles.md` ("Iteration Loop"). Each iteration is two separate commits:

- **Phase A — Plan**: when platform results arrive, update only `commit-message.txt` and `{problem-name}-next-plan.md`. Do not touch deliverables.
- **Phase B — Execute**: after the user commits Phase A, apply only the artifact changes called out in `{problem-name}-next-plan.md` (tiered fixes per `handle-ai-report.md`, patch regeneration). Do not touch `commit-message.txt` or `{problem-name}-next-plan.md`.

The user submits; then wait for the next platform round and return to Phase A. If Phase B uncovers a plan gap, stop and report instead of editing the plan in the same commit.
