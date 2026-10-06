---
trigger: always_on
description: Official Olympus submission requirements and platform process (repo, task prompt, tests, solution, Dockerfile, checks, rollouts, FP check, review, tokens)
---

# Olympus Platform Requirements

Source: the official Olympus docs ("Creating Olympus Challenges" and "The Olympus Process"),
captured 2026-09-27, refreshed 2026-10-06. This file is the authority for what the platform requires and in what order
it checks it. Numeric bars (pass rate, LOC, messages, files, minimum finished rollouts) are NOT
restated here: read the submission's "Submission criteria" panel, then
`my-review-workflow/rules/platform-panel.md`. Other `.agent` rules add stricter house practice on
top of this file; where they disagree on a platform requirement, this file wins.

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
See `description-writing.md` for house style.

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

LOC counts only the effective solution: lines an agent must write to implement the task and pass
the tests. Blank lines, comments, generated files, padding (reordering unrelated code), and test
code are excluded. Improving tests never moves LOC. If agents solve it in noticeably fewer lines
than the golden, the real count is probably lower than it looks. Judge ideas by the solution they
force, not the size of the diff.

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
- **Still clearing the LOC bar?** If agents solve it in noticeably fewer lines than the golden,
  the real effective count is probably lower than it looks (comments, blanks, generated files,
  and test code do not count).

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
   / ready). Usually ~15 minutes, up to 90 on big or hard tasks. At least one agent must pass
   before you can submit; if none ever passes, the tests are too strict, the task prompt is
   missing something, or the task is unfair. Read the fails: failing because the task is hard is
   the goal; failing on an ambiguous sentence is a revision waiting to happen. Passing too often
   means make it harder before spending the remaining runs.
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
   be harder for agents and carries more effective LOC than one confined to a single spot. Not
   required, but the best lever when an idea keeps landing short on difficulty or LOC.
3. **Spend tokens smartly.** Clear checks first, then a small batch for a signal: 100% pass means
   too easy; 0% on a vague point or unfair test means fix before a full run.
4. **Read the check and run outputs.** A 0% pass rate is not always a bad task; it can be one
   ambiguous sentence or one unfair test, and the agent logs show it fastest.
5. **Expect to iterate.** Closing every loop yourself is the path to a clean approval.
