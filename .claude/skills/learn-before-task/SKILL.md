---
name: learn-before-task
description: Mandatory pre-task briefing for this Olympus workspace. Use BEFORE starting or resuming any task here (crafting an idea, writing or fixing a description/tests/solution/test.sh/Dockerfile, handling a check, review, FP panel or agent batch, writing an evaluation or review). Finds related previous tasks and logged problems, states which proven solutions apply, then hands back to the work.
---

# Learn Before Task

Goal: never repeat a solved mistake, and always start from the best solution already found. Do this
before acting, keep it proportional (a one-line fix needs a two-minute briefing, a new task or a
failing round needs the full one), and show the result to the user.

## Step 1 - Pin down the task

State in one line: task folder, repository and language, current phase (idea / description / tests /
solution / Dockerfile / test.sh / checks / FP / batch diagnosis / review / QA evaluation), and the
concrete symptom or goal. The rest of the briefing is keyed on these.

## Step 2 - Re-read the digest

`.agent/knowledge/lessons-digest.md` is loaded at session start; if it is not in context, read it.
Pick the digest sections for the current phase.

## Step 3 - Search the problem-solution log for this symptom

```bash
grep -n -i -E "<symptom words>|<gate name>|<tool or framework>|<phase word>" .agent/knowledge/problem-solution-log.md
```

Use two or three searches with different vocabulary (the gate's name, the symptom, the technology).
Open each hit with Read around the line number and keep only entries whose trigger matches. Note
superseded entries and the reconciliation notes at the top of the log.

## Step 4 - Find related previous tasks and read what happened to them

Related = same repository, same language/build tool, same feature shape, or the same failing gate.

```bash
ls sprint4 sprint5 01_* 2>/dev/null
grep -l -i "<repo or framework>" sprint*/*/*-plan.md 01_*/*.md 2>/dev/null
```

For each related task, read in this order and stop once the relevant lesson is clear:
1. `git -C <task> log --format='%h %s%n%b'` (each commit records problem, approach, results, analysis);
2. `*-previous-reviews.md` / `*-human-reviews.md`;
3. the `*-ledger.md` section for the matching phase (grep it, do not read it top to bottom);
4. `*-false-positive-evaluation.md` and `*-auto-review.json` when the phase is FP or review.

Also grep reviewer lessons and idea lessons when relevant:

```bash
grep -n -i "<topic>" my-review-workflow/lessons/LESSONS.md
cat new-dot-agent/lessons/INDEX.md   # idea selection / calibration phases
```

## Step 5 - Write the briefing

Present it to the user before doing the work, in this shape (short, only what applies):

```
Briefing: <task> - <phase>
Related past work: <task/round and what happened>, ...
Known problems that apply:
- <log entry or lesson title> -> I will <concrete application to this task>
Best current approach: <one or two sentences>
Traps to avoid this time: <the mistakes those tasks made>
```

If nothing relevant exists, say so in one line and continue. Never invent a lesson; cite the entry
title or the task and round it came from.

## Step 6 - Work, then close the loop

Apply the briefing while working. When a new problem is found and its fix verified, append it to
Part 3 of `.agent/knowledge/problem-solution-log.md` (format and dedupe rules in
`.agent/rules/problem-solution-log.md`). If a lesson proved decisive twice, promote it into
`lessons-digest.md` and the relevant `.agent/rules` file, and tell the user what was promoted.
