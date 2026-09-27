---
description: Process and address human reviewer feedback systematically
---

# Handle Human Review

## When to Use

Run after receiving human reviewer feedback on a submission.

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

## Review Outcomes (official)

- **Approved**: goes through a final quality pass, then finalizes. Only a finalized approval counts
  (payout, bonus tokens, approval stats). Freeze the task; do not edit it.
- **Revision requested**: returns editable with the reviewer's feedback attached. Fix what is
  flagged, rerun every check and rollout the edits made stale, then resubmit. This workflow covers it.
- **Rejected**: a disqualifying finding, most often a duplicate PR or a task that cannot be made
  fair. If the call is wrong, appeal with concrete reasoning; otherwise archive and return to idea
  crafting.

Submitting locks the submission for editing, so everything here happens only after a revision
request (or an accepted appeal) reopens it. Batch all fixes into one pass before rerunning checks.

## Steps

### 1. Read Feedback

Read the complete feedback and categorize each point:
- **Valid issue**: Something that needs fixing
- **Justified by design**: Can explain in reviewer notes and we have solid and convincing reasons
- **Already addressed**: Point to existing documentation

### 2. Create/Update Human Reviews File

Use `{problem-name}-human-reviews.md` in the problem directory. Keep the immutable `{problem-name}-plan.md` unchanged; if the review requires a future strategy document, create `{problem-name}-next-plan.md` only when the user explicitly asks.

```markdown
# Human Reviews

## v{N}

### Description
- [Issue description]
  - **Status**: FIXED / Justified (see Reviewer Notes)

### Test Patch
- [Issue description]
  - **Status**: FIXED / Justified (see Reviewer Notes)

### Solution Patch
- [Issue description]
  - **Status**: FIXED: [what you changed]
```

### 3. Address Each Point

**For Valid Issues:**
1. Make the fix in the repo code
2. Verify tests still pass
3. Document in human-reviews.md as "FIXED: [change]"

**For Justified Decisions:**
1. Prepare concise justification for Discord message to reviewer
2. Document in human-reviews.md with status: **Justified**

### 4. Common Review Patterns

| Feedback | Response |
|----------|----------|
| "Tests check exact error strings" | Justify via Discord: repo convention, user-facing contract |
| "Build tag undocumented" | Justify via Discord: isolates feature tests from base |
| "Solution inefficient" | Fix: optimize implementation |
| "Duplicate logic" | Fix: consolidate helpers |
| "Tests too brittle" | Justify OR refactor tests |
| "Panic/error recovery doesn't match repo pattern" | Fix: use existing repo pattern (e.g., recoverFunc-style type-switch) |
| "Embedded fallback skips type processing" | Fix: ensure embedded dispatch paths match main dispatch paths |
| "Redundant tests" | Fix: remove the redundant test if same behavior is covered |
| "Missing edge case test" | Fix: add the test |
| "Dead code/unused opcode" | Fix: remove all dead code from the solution patch |
| "Agent LOC below threshold" | Justify with ADDED vs NET data — platform measures ADDED lines |
| "Pre-existing test failures" | Justify: document they exist in the base commit, pass in Docker |
| "Description unclear about scope" | Fix: rephrase to clarify what changed without being prescriptive |
| "Problem is duplicate/similar to existing challenge" | Stop this idea line, document blocker, and return to idea crafting with uniqueness preflight |

### Discord Response Style

When responding to human reviewers via Discord, write conversationally and concisely:
- Start with "Hey, thanks for the review!" or similar
- Group fixed items together ("I've resolved points 1 and 3:")
- For justified items, give one-line reasoning ("Regarding point 2, ...")
- Include specific data when justifying (LOC counts, pass rates, file counts)
- Don't over-explain — reviewers are technical professionals


### 5. Regenerate Patches

After fixes:
```bash
cd repos/{repo}
git reset . && git clean -fd && git restore .
# Apply fixes
# Run /generate-patches
```

If feedback is duplicate/similarity, do not regenerate deeper iterations for the same idea. Archive findings and pivot.

### 6. Verify Changes

```bash
./test.sh --output_path /tmp/base.xml base  # PASS
./test.sh --output_path /tmp/new.xml new   # PASS (with solution applied)
```

### 7. Run Review

Run `/review-work` to catch any issues from changes.

### 8. Prepare Commit
When user ask you to write a commit message.
Run `/write-commit-message` with:
- Human review feedback received
- Specific changes made
- Justifications added

## Example: tengo-destructuring v7

```markdown
# Human Reviews

## v2

### Test Patch
- Tests check exact error strings, making it brittle.
  - **Justified (see Reviewer Notes):** Error messages are part of user-facing contract.

- Build tag undocumented.
  - **Justified (see Reviewer Notes):** Build tags isolate new feature tests.

### Solution Patch
- ~~Solution iterates entire map instead of O(1) lookup~~
  - **FIXED:** Added `OpHasKey` opcode for O(1) key existence check

- ~~compileNestedArrayPattern duplicates main pattern logic~~
  - **FIXED:** Consolidated into `compileArrayPatternElements` helpers

- ~~Fragile parser state save/restore~~
  - **FIXED:** Added `parserState` struct with `save()`/`restore()` methods
```

## Quality Gate

Before resubmitting:
- [ ] All valid issues addressed
- [ ] Justified items documented in Reviewer Notes
- [ ] *-human-reviews.md updated
- [ ] Patches regenerated
- [ ] Fresh verification passes

> [!NOTE]
> Commit message and updating the *-human-reviews.md should be done after the user approves the changes.
