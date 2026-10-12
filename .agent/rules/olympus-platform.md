---
trigger: always_on
description: Official Olympus submission requirements and platform process (repo, task prompt, tests, solution, Dockerfile, checks, rollouts, FP check, review, tokens)
---

# Olympus Platform Requirements

Source: the official Olympus docs ("Creating Olympus Challenges" and "The Olympus Process"),
captured 2026-09-27, refreshed 2026-10-06 and 2026-10-12. This file is the authority for what the
platform requires and in what order it checks it. The numbers quoted in section 9a are the docs'
values at capture; the submission's "Submission criteria" panel and
`my-review-workflow/rules/platform-panel.md` win when they differ. Other `.agent` rules add stricter
house practice on top of this file; where they disagree on a platform requirement, this file wins.

Naming: the platform now calls the description the **task prompt** (form field, prechecks, and the
Task Prompt Quality check). House files keep the `*-description.md` name, and "description" means
the same thing everywhere in `.agent`.

Bar: the task must be **really challenging** for SOTA models. If you think you know what
"challenging" means, bump it up a notch.

## 1. Submission pieces

1. Repo and commit: one public GitHub repo pinned to one SHA.
2. Task prompt (the description): the task, submitted as text.
3. Test patch: unified git diff with `test.sh` plus the new or modified tests.
4. Solution patch: unified git diff with the reference (golden) implementation.
5. Dockerfile: pasted in directly.

## 2. Repository requirements

- Public GitHub repository, production-level codebase.
- At least 1 commit in the last 12 months; not inactive or abandoned (R1).
- 500+ stars.
- Language: TypeScript, JavaScript, Python, Go, Rust, C++, or Java.
- Permissive license from the allowed list: MIT; BSD family (BSD-1/2/3/4/5-Clause and their listed
  variants); BSL-1.0; BLAS; GNU-All-permissive-Copying-License; Apache-2.0 (incl. Modified,
  LLVM-Exception, Runtime-Exception); CC-BY-1.0/2.0/2.5/3.0/4.0. Anything else (GPL, LGPL, MPL,
  EPL, ...) is ineligible.
- Optional: a GitHub issue URL describing the problem.

The requirements are the floor. Repo depth sets the difficulty ceiling: a thin or flat repo caps
difficulty no matter how good the idea is. Spend real time choosing.

Take-care rules, all verified later by the Scope Gate:

- **R2 - No existing PR solves it**: open, merged, or closed. An unmerged or closed PR that
  implements the idea still rules it out. This is the #1 rejection reason.
- **R3 - Maintainers have not declined it**: check issues AND GitHub Discussions, not just PRs.
  A declined feature is misalignment with the repo. Also check that the capability was not shipped
  and later removed on purpose.
- **R4 - Fits the project's philosophy**: read the README; no nonsensical features.
- A heavily used repo makes the duplicate check and Scope Gate harder to clear. Repos cannot be
  claimed or reserved.

## 3. Task prompt (description)

- **P1** aligns with the repo's philosophy.
- **P2** not already fixed in an open or merged PR.
- **P3** self-contained: solvable from the repo plus the task prompt alone.
- **P4** clear, concise, unambiguous: nothing left to guess.
- **P5** verifiable: success is objectively testable.
- **P6** not prescriptive: do not leak the solution.
- **P7** not a duplicate: open the similarity results, read the close matches, and confirm the task
  is genuinely new. Rewording or reshaping the same behavior does not make it new.

How it reads: like a maintainer's issue, natural prose in full sentences. Open with the ask itself
("Add X to Y", "Fix Z when ...") so the first line stands on its own without the title. Skip
motivation and "what the repo currently lacks" preamble. No bulleted requirement lists, no
headings, no code snippets doing the describing. Do not spell out what a developer would find in
the repo (internal class names, helpers, field names, file layout): describe behavior, not
implementation. Judgment clause: if a detail is genuinely part of the contract and the task cannot
be pinned down without it, state it. A task nobody can implement is worse than one that names a
field.

Prechecks also validate length, formatting, no leftover URLs, and that it matches its category.
Length is not graded below the hard cap of 1,000 words, title included (the length precheck warns
above 500). Scope is graded: the Task Prompt Quality check fails a task that asks for too many
distinct things at once, and that failure cannot be contested; cut the task down and rerun the
check. One coherent change with a few load-bearing details beats a long list of small asks. See
`description-writing.md` for house style.

## 4. Tests

The agent gets only the repo and the description; the tests are hidden.

- **T1** highlight the missing or incorrect behavior: 100% fail at base, 100% pass with solution.
- **T2** deterministic: no timing, randomness, or ordering dependence; stable across runs and
  machines. Verify Flakiness enforces this.
- **T3** strong: not permissive enough to let inaccurate solutions pass.
- **T4** extensive coverage: the requested behavior and all obvious edge cases.
- **T5** never check unspecified or undiscoverable behavior.
- **T6** no network (container runs with `--network none`).
- **T7** do not over-pin output: no exact error text, messages, wording, or formatting assertions
  unless the description states it or the repo's existing patterns make it obvious. Check that the
  behavior holds.
- **T8** keep failure diagnostics intact: results must show which test failed and its real
  assertion output. A custom harness, reporter, or JUnit adapter must not hide real failures behind
  hardcoded catch-all messages, mask upstream errors, or report something other than what ran.
  Misreporting is a serious defect.

`test.sh` at the repo root, included in the test patch:

- `./test.sh --output_path results.xml base`: the repo's existing tests for the area you touched,
  a genuine regression check, not a token smoke test. Must pass. Writes JUnit XML.
- `./test.sh --output_path results.xml new`: the new or modified tests. Must fail without the
  solution.
- Existing tests that are flaky, need network, or fail for pre-existing reasons may be excluded.
  Never exclude valid tests because the solution breaks them; reviewers check.
- No fail-fast flags: every test result is needed.

JUnit reporters: pytest `--junitxml`; vitest `--reporter=junit --outputFile`; jest via
`jest-junit` (pre-installed); go test `-v` piped to `go-junit-report -set-exit-code` (pre-installed,
`-v` required); mocha via `mocha-junit-reporter` (pre-installed); deno `--junit-path`. For JVM,
Gradle/Maven write JUnit XML natively; copy or merge it to `$OUTPUT_PATH` without rewriting
results (T8).

## 5. Leak rule (all patches)

Treat every file like a real PR. No directories or files named "challenge", "quest", or
"olympus"; no `test.sh` comments referencing the challenge; no "Shipd", "Olympus", or "mars"
anywhere in the patches. If it would not appear in a normal PR to the repo, it does not belong.

The official approved frostdb example puts its tests under `challenge/` and calls itself a
"challenge" in `test.sh` comments. Do not copy that; the rule above governs.

## 6. Solution

- **S1** meets every requirement. A golden that misses a requirement and still passes the tests is
  a bad position.
- **S2** no regressions; follows existing code patterns. Existing tests still run.
- **S3** no irrelevant changes.
- **S4** no AI-generated artifacts: weird comments, unexplained defensive code, new coding
  patterns.

Solution size: the standard Olympus bar has no lines-of-code floor. Diff size is not a criterion,
and review and payout do not price it; what counts is how hard the task is for the agents (section
9a). Other submission types (Mars, Diamond) still have a minimum solution size, shown in their
criteria panel. Effective lines remain a scope signal: if an agent solves the task in noticeably
fewer lines than the golden, the task is probably smaller than it looks. Comments, blank lines,
generated files, padding, and test code never count as solution.

## 7. Dockerfile

- `FROM` the language base image:
  - Python: `public.ecr.aws/d3j8x8q7/olympus-base-python:latest`
  - TypeScript / JavaScript: `public.ecr.aws/d3j8x8q7/olympus-base-typescript:latest`
  - Go: `public.ecr.aws/d3j8x8q7/olympus-base-go:latest`
  - Rust: `public.ecr.aws/d3j8x8q7/olympus-base-rust:latest`
  - Java (JVM): `public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest`
  - C++: `public.ecr.aws/d3j8x8q7/olympus-base-cpp:latest`
- Install all dependencies at build time; the runtime is offline (`--network none`).
- `WORKDIR /app` exactly; tests run from there.
- No test commands in any `RUN` step. Prewarming with a build (e.g. `go build ./...`,
  `gradlew testClasses`) is fine.
- End with `CMD ["/bin/bash"]`.
- Must build and work without `test.patch` or `solution.patch` applied; they are applied after
  the build.

## 8. Local review before spending tokens

1. Clone the repo and check out the exact commit.
2. Apply `test.patch`.
3. Build the Docker image.
4. Run the container with `--network none`.
5. `./test.sh --output_path /tmp/base.xml base` must pass; `./test.sh --output_path /tmp/new.xml new`
   must fail.
6. Apply `solution.patch`.
7. Rebuild and rerun both modes: both must pass.
8. Confirm no existing PR (open, merged, closed) already solves it.
9. Confirm every point in this file holds.

### 8a. Be your own reviewer first

Before submitting, read the agent runs the way a reviewer will:

- **Are the failures fair?** An agent should fail because the task is genuinely hard, not because
  a sentence was ambiguous, a requirement was hidden, or a test asked for something the task
  prompt never stated. Fix what you did not intend now; after submission it returns as a revision.
- **Did the agents really have to work for it?** Open a Nova run and check its sequence length
  (shown on every rollout). A short sequence means the agent found a shortcut or the task only
  touches a couple of files; either way it is not forcing the long exploration the bar asks for.
  If an agent solves it in noticeably fewer lines than the golden, the task is probably smaller
  than it looks (comments, blanks, generated files, and test code never count as solution).

## 9. Platform flow

Each step unlocks the next and costs more. Never spend on a later step while an earlier one fails.
The "Submission criteria" panel tracks everything live; when it is all green you can submit.

1. **Prechecks** (cheapest). Repo: URL/commit resolve, stars, activity, language, license.
   Problem and tests: task prompt well formed (length, formatting, no leftover URLs, matches its
   category), not a near-duplicate, test patch a valid diff with a working `test.sh`, no solution
   code, no quest leaks. Dockerfile: base image, `/app`, build-time deps, no tests in build.
   Solution: valid, cleanly structured diff. Fix everything in one pass, then rerun. Warnings do
   not block, but read and confirm each.
2. **Scope Gate**: pass or drop on whether the task should exist. Checks in-depth duplicates
   against similar submissions (tasks and what their solutions touch, not wording), upstream
   history (shipped, open PR, declined, removed on purpose), and repo fit. A drop means rethink
   the idea, not reword it.
3. **Build**: Build Image before quality checks. Rebuild after any Dockerfile change.
4. **Quality checks** (must pass and stay current before agents):
   - Verify Tests: test patch on clean repo; `base` passes, `new` fails.
   - Verify Solution: solution on top; both modes pass.
   - Verify Flakiness: suites run several times with and without solution; any result change
     between identical runs fails and blocks everything downstream.
   - Test Quality: each hidden test must check something the description states or a developer
     would discover in the repo; advisory coverage feedback.
   - Task Quality: grades description and tests as a pair; lists failing criteria.
   - Solution Quality: completeness and code quality against the repo; lists concrete issues.
   - Task Prompt Quality (formerly Description Quality): templated structure, redundancy, and
     details an agent could find in the repo on its own; suggests rewrites.
5. **Agent rollouts**: agent gets description, repo at the commit, and the Docker environment;
   graded by the hidden tests. A minimum number of finished rollouts is required (see criteria
   panel). Quick check = one cheap run for iterating; full batch = several runs, configurable
   agents and counts. Trust the results banner (quick check / full batch / too easy / looks broken
   / ready). Usually ~15 minutes, up to 90 on big or hard tasks. Solvability: Orion or Vega must
   solve it, but only occasionally, and no unhinted Nova run may (section 9a). If no agent ever
   passes, the tests are too strict, the task prompt is missing something, or the task is unfair.
   Read the fails: failing because the task is hard is the goal; failing on an ambiguous sentence
   is a revision waiting to happen. Any unhinted Nova solve, or Orion and Vega solving more than
   25% of the time, means the task is too easy: make it harder before spending the remaining
   runs. Every finished rollout shows its sequence length; a batch of short Nova runs means the
   task is smaller than it looks, even when every run fails.
6. **FP check**: reviews every passing run; a single pass judged false fails the "No false
   positives" criterion. Run it only after the run set is settled. If it finds a false positive,
   strengthen the tests (and check the description so the new tests stay discoverable), then
   rerun. It rebuilds solutions from agent patches and skips folders named `build`, `dist`,
   `target`, `node_modules`, `__pycache__`, `.venv`; if real source lives under such a name, list
   its full path under **Protected source folders** (also protects re-evaluated rollouts).
7. **Auto Review**: full review of task, tests, solution, and runs; must run to completion. Its
   verdict does not block, but a human will likely flag what it flags. Run it last, when all else
   is green. May grant a **queue skip** straight to manager final approval. Can be run earlier as
   a helper, but it goes stale.
8. **Submit**: locks the submission for editing.

### 9a. Submission criteria (standard Olympus bar)

The "Submission criteria" panel in the form shows the exact bar for the assignment, with live
numbers from the rollouts. For the standard Olympus bar the agents themselves are the measure, and
three rows must go green:

- **Nova rollouts**: at least 8 unhinted Nova runs must complete and none of them may solve the
  task. Hinted runs never count toward the bar. Nova is the long-horizon agent; if it can solve
  the task, the task is not hard enough.
- **Long horizon**: those Nova runs must average more than 256K tokens of **sequence length**:
  the agent's largest request (the whole prompt plus the model's output) plus everything its
  harness compacted or trimmed out of the context along the way. Real exploration of a large
  codebase, long test cycles, and many iterations push it up; a task an agent can finish after
  reading two files does not. Averages above the bar also raise the payout: the scope share of
  the reward keeps growing up to 500K.
- **Orion / Vega rollouts**: at least 4 runs on Orion or 4 runs on Vega (the stronger agents)
  must solve it more than 0% and at most 25% of the time. One of them proves the task is
  solvable, but it must not be routine.

Only runs made against the current task and the current agent line-up count (section 11). The
standard bar has no lines-of-code floor (section 6); Mars and Diamond submissions still have a
minimum solution size, and their panel shows it.

## 10. After submitting

- **Approved**: final quality pass, then finalization. Only a finalized approval counts (payout,
  bonus tokens, approval stats).
- **Revision requested**: returns editable with reviewer feedback. Fix, rerun what went stale,
  resubmit. Normal.
- **Rejected**: disqualifying finding, most often a duplicate PR or a task that cannot be made
  fair. Can be appealed with reasoning.

**Contest button**: some failed verdicts (a check or an agent run) offer one rebuttal. Use it only
when the verdict is actually wrong, with proof (code, test output, run log). The note is exactly
what the human reviewer reads next to the verdict; a contest without real reasoning reads as an
unanswered flag and the submission comes back.

## 11. Tokens and staleness

- Checks and rollouts cost tokens: prechecks cheapest, agent runs most expensive.
- Initial balance for new contributors; finalized approvals earn bonus tokens; hourly replenish by
  contributor tier (approval rate and number of finalized approvals). Balance and tier are in the
  page header; Progression page shows the ladder.
- Refunds only for platform-side infrastructure failures (automatic). Contesting a review verdict
  does not refund tokens.
- **Staleness**: every result is pinned to the exact content it ran on. Editing any field after a
  check, rollout, or review completes makes it stale: it stops counting and must be rerun.
- **Agent line-up**: rollouts are also pinned to the agent line-up they ran under. When the agents
  are updated (a new model or harness behind Nova, Orion, or Vega), rollouts from the previous
  line-up stop counting toward the bar and must be rerun, and the FP check that reviewed their
  passes has to run again.
- Batch edits: fix everything in one pass, then rerun once. One rollout batch at a time; read
  results first, edit second. Triggering more rollouts while a batch is in flight risks staling
  all of them at once.
- Budget: clear checks first, then a quick check or small batch to get a signal (100% pass = too
  easy; 0% on a vague point or unfair test = fix before a full batch).

## 12. Time expectations

Assembling a submission typically takes 3-6 hours, plus iteration with checks. Almost nobody
lands the first pass; every loop closed before submission is a revision cycle saved.

The assessment runs a smaller version of this flow (fewer checks, several steps skipped). Every
step above applies to real submissions.

## 13. Official tips

1. **Plan the scope before writing patches.** Without thinking about overall scope and the repo's
   architecture first, it is easy to end up too trivial for the difficulty criteria. The bar moves
   quickly; find out the task is too easy before writing 600 lines of solution.
2. **Consider cross-cutting changes.** A solution spanning several layers or subsystems tends to
   be harder for agents, and pushes their sequence length up because they must hold more of the
   codebase in context, than one confined to a single spot. Not required, but one of the better
   levers when an idea keeps landing short on difficulty or context.
3. **Spend tokens smartly.** Clear checks first, then a small batch for a signal: 100% pass means
   too easy; 0% on a vague point or unfair test means fix before a full run.
4. **Read the check and run outputs.** A 0% pass rate is not always a bad task; it can be one
   ambiguous sentence or one unfair test, and the agent logs show it fastest.
5. **Expect to iterate.** Closing every loop yourself is the path to a clean approval.
