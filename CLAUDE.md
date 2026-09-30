# Olympus task workspace

Rules and workflows for building and iterating tasks live in `.agent/`. Official platform
requirements are in `.agent/rules/olympus-platform.md`; live numbers are in
`my-review-workflow/rules/platform-panel.md`.

## Learn before every task (mandatory)

Before starting or resuming ANY task here (idea, description, tests, solution, `test.sh`,
Dockerfile, check handling, FP panel, batch diagnosis, review, QA evaluation), run the
`learn-before-task` skill and show its briefing before doing the work:

1. Use the lessons digest (`.agent/knowledge/lessons-digest.md`, injected at session start).
2. Grep `.agent/knowledge/problem-solution-log.md` for the current symptom and phase.
3. Find related previous tasks (same repo, language, build tool, feature shape, or failing gate) in
   `sprint4/`, `sprint5/`, `01_*/` and read what happened to them (git log, reviews, ledger).
4. State which proven solutions apply and the traps to avoid, then apply them. Prefer the best
   solution already proven over a new guess; if you deviate from a logged solution, say why.

Scale the briefing to the task: a one-line fix gets a two-line briefing, a new task or a failing
round gets the full one.

## Record after every solved problem (mandatory)

Follow `.agent/rules/problem-solution-log.md`: when a new problem is found and its fix verified,
append it to Part 3 of the log in the same session without being asked, or update the existing entry.
When a lesson proves decisive twice, promote it into `lessons-digest.md` and the relevant `.agent`
rule, and tell the user.

Never copy log or digest content into the five deliverables.

## Humanize every description edit (mandatory)

Whenever you create or modify a task description (`*-description.md`), run the `humanizer` skill
(`.claude/skills/humanizer/`) on the changed prose in file mode before finishing, including edits made
through scripts. It changes wording only: keep every tested clause, config key, exact value and
precedence rule, and let `.agent/rules/description-writing.md` win where the two conflict.
