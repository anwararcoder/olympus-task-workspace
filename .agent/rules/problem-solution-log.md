---
trigger: always_on
description: Consult the problem-solution log before acting, and append every newly solved problem to it
---

# Problem-Solution Log Protocol

The log lives at `.agent/knowledge/problem-solution-log.md`. It records every problem met while
building tasks and the fix that worked, so the same mistake is recognized and solved from memory
instead of rediscovered.

## 1. Consult before acting

Start every task by reading `.agent/knowledge/lessons-digest.md` (the distilled best practices) and
finding related previous tasks in `sprint4/`, `sprint5/`, `01_*/` (same repo, language, build tool,
feature shape, or failing gate): read their git log, reviews, and the matching ledger section. Then,
before each of these steps, search the log for the symptom or the step's topic and apply any matching
solution:

- crafting an idea or choosing a repository;
- writing the description, tests, solution, `test.sh`, or Dockerfile;
- handling any precheck, quality check, Test Fairness, FP check, auto-review, audit, or human review;
- diagnosing a batch (zero pass, over-solve, TEST_MISMATCH, TEST_BROKEN, environment failure).

Search by keyword, not by reading top to bottom:

```bash
grep -n -i -E "<symptom words>|<gate name>|<tool name>" .agent/knowledge/problem-solution-log.md
```

When an entry matches, say so in the working notes or ledger ("known problem: <entry title>") and
apply its solution instead of re-deriving it.

## 2. Record every newly solved problem

A problem is anything that cost a round, a token spend, or a correction:

- a failing or warning gate (prechecks, Scope Gate, build, Verify Tests/Solution/Flakiness, Test
  Quality, Task Quality, Solution Quality, Task Prompt Quality (formerly Description Quality), FP
  check, Auto Review);
- a human-review or manager finding;
- an agent-run verdict that exposed a task defect (TEST_MISMATCH, TEST_BROKEN, confirmed false
  positive, zero pass, over-solve);
- an environment or harness failure;
- a mistake caught in our own work (a wrong claim, a destroyed file, a bad patch, a wrong assumption).

As soon as the fix is verified (not before), append an entry to Part 3 of the log in the same working
session. Use this format:

```markdown
### <Short problem title>
**Trigger:** <observable symptom: gate/reviewer/run and what it reported>
**Root cause:** <why it happened; the artifact and the wrong assumption>
**Solution:** <the fix, stated as a reusable rule, not a one-off edit>
**Verification:** <how the fix was proven: mutation, replay, four-state, rerun>
**Applies to:** <scope>
**Seen in:** <task, version/round, YYYY-MM-DD>
```

Rules for writing entries:

- **Deduplicate.** Search first. If an entry already covers the problem, add a `**Seen in:**` line or a
  refinement to that entry instead of a new one. A recurrence of a logged problem means the solution
  was not applied: note that too.
- **Generalize.** Write the rule so it helps on a different repository and language. Keep task names,
  hashes, and file paths in `Seen in`, not in the rule.
- **Be exact.** Record only what was verified. Mark unverified fixes as `**Status:** unverified` and
  update them once proven.
- **Supersede, never delete.** When new evidence contradicts an entry, append
  `**Superseded (YYYY-MM-DD):** <what changed and the replacing entry>` to it and add the corrected
  entry. Imported Part 1 entries follow the same rule.
- **Keep it internal.** The log may name the program, gates, and tiers. Nothing from it may be copied
  into the five deliverables (description, patches, Dockerfile, base-commit file).
- **Leak rule wins.** If a logged solution conflicts with `olympus-platform.md`, the platform rule
  wins; record the conflict in the entry.

## 3. Promote recurring problems into rules

When the same problem appears in two or more tasks, or one entry becomes a standing practice, also
fold it into the relevant `.agent/rules/*.md` or `.agent/workflows/*.md` file and add
`**Promoted to:** <file>` to the log entry.

## 4. Where it lives

The log is shared across all tasks and is not part of any task repository, so it is edited in place
and never enters a task's patches or commits. The per-task record of the same event still belongs in
that task's `{problem-name}-ledger.md` and commit message.
