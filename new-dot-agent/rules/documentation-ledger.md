# Documentation & Ledger — institutional memory that survives any provider

The old workflow documented difficulty iterations well but left precheck and QA fix rounds
undocumented — and those now consume as much time as difficulty work. Worse, lessons lived in one
provider's chat memory. This rule makes the FILE SYSTEM the memory, so any model/provider resumes
with full context.

## 1. `{problem-name}-ledger.md` (per task — append-only, one line per event, ZERO ceremony)

Create `my-work/{repo}-{problem}/{problem-name}-ledger.md` at task creation (same prefix
convention as `{problem-name}-plan.md`, so ledgers from different tasks stay distinguishable when
one is referenced from another chat or copied out of its directory). Append one line for EVERY
platform interaction and every fix round — including prechecks and QA:

```
2026-06-10 | submit v4 | desc+tests (71->74) | gates touched: all re-staled
2026-06-10 | diamond-checks | rollouts 3/3=1.00 | VERDICT: ceiling confirmed -> decision round
2026-06-11 | precheck fix | conciseness warning DECLINED (would pin free choice) | no re-stale
2026-06-11 | qa-audit r1 | 14 flagged: 12x backticked file:line (CLASS sweep done), 2x absolutes
```

Format: `date | event | what changed | gates touched / verdict`. The mutation-log discipline is
built in: every line states WHICH deliverable changed and what it re-stales (description/tests/
solution/Dockerfile → everything; QA-only → nothing; hint → hinted runs only). Ten seconds per
line; it replaces archaeology.

## 2. Phase A / Phase B commits (strategy changes keep the heavier ceremony)

When platform RESULTS arrive that change strategy: **Phase A** = update `commit-message.txt`
(structured: Problem / Approach / Results / Submission Status / Analysis / Next Steps) + the
`{problem}-next-plan.md`; touch no deliverable. **Phase B** = execute exactly the next-plan;
touch no planning doc. Never mix them in one commit. Small fix rounds (a precheck wording fix, a
QA annotation sweep) need only ledger lines, not the full Phase A ceremony — that lightweight tier
is exactly what was missing before.

## 3. The lever ledger (inside next-plan)

Every difficulty/fairness lever ever tried on the task gets a table row: lever | kind | result |
verdict (KEEP / WALL / UNFAIR / AMBIGUOUS / NO-OP / DEAD). The next agent reads this FIRST — the
most expensive failure mode in our history is re-trying a dead lever.

## 4. lessons/ (global registry — the cross-task seed)

`new-dot-agent/lessons/` holds one file per durable lesson (kebab-case name, a one-line summary on
top, evidence below — including the DATE and the n behind it). Write one whenever: a task is
accepted (what made it work), killed/reverted (what would have caught it earlier, at which stage),
or a platform check teaches something new. `lessons/INDEX.md` = one line each. The retrospective
workflow (`workflows/w8-retrospective.md`) enforces this. `rules/idea-crafting.md` requires
reading the INDEX before crafting. This is the provider-agnostic replacement for any single
assistant's private memory.

**Lessons are evidence-bound hypotheses, not eternal truths — they can be WRONG (a lucky
generalization, or true only under a gate that later changed). Revision protocol:** when new
evidence contradicts a lesson, do NOT delete it — append a dated `## Revised / Superseded` section
to the lesson file stating the new evidence and the corrected reading, update its INDEX line, and
propagate the correction into any rule the lesson had shaped, in the same sitting. A lesson built
on a single observation must say so ("observed once — treat as a prior to check, not a gate"), and
a lesson tied to a specific platform bar must name that bar so a bar change automatically flags it
for re-validation (the W8 platform-change sweep re-checks these). Precedents: the
secret-rotation "ABANDON" index line later corrected; the jte Gate-C verdict revised within a day
when the gauntlet's FINAL report superseded the mid-flight read.

## 5. Onboarding docs

A task that hands off between sessions/agents keeps `onboarding-doc.md` current: the 60-second
picture, the ONE thing to internalize, current verified on-disk state, the lever ledger pointer,
build/verify mechanics that work. Write it for an agent with zero context — that agent is usually
you, three weeks later, on a different model.

## 6. Directory hygiene

The task directory's exact file-naming contract is `templates/artifact-structure.md`. Keep it
clean: the only memory files are the ledger, the plan/next-plan, `commit-message.txt`, and the QA
artifacts. NO `PLAN.md` / `SUMMARY.md` / `CHECKLIST.md` / `READY.md`, no debug or log files, no
ad-hoc notes — they pollute the submission and confuse the next agent.
