# Step 1
Hey there. I need your help recommending 3 repos for a new Olympus task. They should be similar in infra to the repos behind my accepted tasks, and they must align with the rules and workflows in this workspace.

Before anything else, run the `learn-before-task` skill (full briefing, this is a new task) and show it to me.

Where things live in this workspace:
- Official Olympus docs ("Creating Olympus Challenges" and "The Olympus Process"): captured in [.agent/rules/olympus-platform.md](.agent/rules/olympus-platform.md). It is the authority on platform requirements and the order of checks. Read it in full first; the R/P/T/S codes below refer to it.
- Rules, workflows and knowledge: [.agent/](.agent/) (`rules/`, `workflows/`, `knowledge/lessons-digest.md`, `knowledge/problem-solution-log.md`).
- The newer authoring system: [new-dot-agent/](new-dot-agent/). Read `WORKFLOW.md`, `rules/repo-selection.md`, `workflows/w0-select-repo.md` and `lessons/INDEX.md`.
- Live platform numbers: [my-review-workflow/rules/platform-panel.md](my-review-workflow/rules/platform-panel.md). The current Olympus bar is pass rate <= 40%, median of successful runs >= 250 effective LOC, >= 40 messages, >= 2 files. The "Submission criteria" panel on the submission form is the final word; if anything older disagrees (Mars, Diamond numbers), the panel wins.
- Standards: [standards/](standards/), especially `Java-C++-Support-Overview.md` and `Olympus-Diamond-Tier-Failure-Analysis-Guide.md`.
- Accepted tasks: [sprint4/](sprint4/) and [sprint5/](sprint5/). These are the most recent ones and the reference for what a good task looks like. Most are Java (immutables, mapstruct, jte, vineflower). The Python ones in sprint5 (model_defaults, pyamg, pydicom, pyparsing) use a slightly different layout.
- My current in-progress task: [freeze-store-integrity/](freeze-store-integrity/) (archunit). Don't recommend anything that overlaps with it.
- There is no local `repos/` folder. Each accepted task records its repo and base commit in its `BASE_COMMIT-*.txt` / `*-base-commit.txt` and Dockerfile. Clone candidate repos into `repos/` (create it) so you can study their internals.

About "history": the workspace git log only holds bulk-import commits for each task (1-3 commits each), so it tells you almost nothing. The real history of every accepted task is in its own files: `*-ledger.md`, `*-previous-reviews.md` / `*-human-reviews.md`, `*-ai-evaluation.md`, `*-auto-review.json`, `*-false-positive-evaluation.md`, `*-next-plan.md`, `*-prechecks.md`, `*-repo-fit.md`, `*-verifier-audit/` and the `*-agents-runs/` trajectories. Read those in full. They show what changed between rounds, why, and how agents behaved.

Repo requirements (official floor, `olympus-platform.md` section 2, all checked by Prechecks):
- Public GitHub repo with a production-level codebase, 500+ stars (I prefer 500-5k), at least one commit in the last 12 months and not abandoned (R1).
- Language is one of TypeScript, JavaScript, Python, Go, Rust, C++ or Java. Java is preferred because it gives good variety, but don't exclude a clearly better non-Java candidate.
- License is on the allowed list (MIT, BSD family, BSL-1.0, BLAS, GNU-All-permissive, Apache-2.0 variants, CC-BY). Check the actual LICENSE file, not just the GitHub badge.
- The floor isn't the goal. Depth is: a thin or flat repo caps the difficulty no matter how good the idea is. Look for a real build (Maven/Gradle for Java), a fast deterministic test suite that runs offline in the `olympus-base-<language>` image, and room for a STATE or EDIT feature shape (see the digest, section 1). READ-shaped features hit the ceiling and get rejected.
- The repo must have room for cross-cutting changes across several layers. That is the best lever for difficulty and effective LOC.
- Prefer repos my accepted tasks haven't used yet (immutables, mapstruct, jte, vineflower, archunit). A heavily used repo makes it harder to clear the duplicate check and the Scope Gate, and repos can't be reserved. Only suggest one of those if it still has a large untouched subsystem, and say which one and why it doesn't overlap.

Then recommend 3 repos. For each one, give: stars, license and last-commit date; build and test harness fitness (W0 gate: builds offline in the base image, base tests pass, no flaky or network tests in the area you'd touch); candidate subsystems with a STATE/EDIT shape; why agents would find it hard; existing tests/logging/diagnostics that support it; risks (harness, ceiling, maintainer philosophy from README/issues/Discussions, prior PRs); and your confidence.

Go ahead please and do amazing work.


# Step 2
Well, good work.

Now I need to start a task from scratch. Recommend one solid idea that can compete with the accepted ones and get accepted on the first iteration.

Re-run `learn-before-task` for the idea phase, then follow [.agent/workflows/craft-idea.md](.agent/workflows/craft-idea.md), [.agent/rules/idea-crafting.md](.agent/rules/idea-crafting.md) and [new-dot-agent/workflows/w1-craft-idea.md](new-dot-agent/workflows/w1-craft-idea.md) / [w2-difficulty-preflight.md](new-dot-agent/workflows/w2-difficulty-preflight.md).

You can't know what a good task looks like without analyzing the full history of the accepted tasks in `sprint4/` and `sprint5/`, meaning their ledgers, reviews, AI evaluations, FP evaluations, next-plans and agent-run trajectories (not the workspace git log, see Step 1). They are the reference. They show what the agents we are challenging can and can't do, and the mistakes we fell into.

Skipping this step or doing it lazily is not acceptable, because it ends in incomplete or wrong insights.

Plan the scope before anything else. Models are stronger than you expect, so if you think something is challenging, push it a notch further. The time to find out a task is too easy is now, not after 600 lines of solution. Judge the idea by the effective solution LOC it forces (no blanks, comments, padding or test code), and prefer an idea that cuts across several layers or subsystems.

The idea has to clear the Scope Gate on the first try, so do its homework now (R2-R4, P1, P2, P7):
- No existing PR implements it: open, merged or closed/unmerged. A PR that never landed still rules it out. This is the #1 rejection reason.
- The maintainers haven't declined it in issues or GitHub Discussions, and it wasn't shipped and later removed on purpose.
- It fits the repo's philosophy (read the README and docs). It's not an invented feature that doesn't belong.
- It isn't a near-duplicate of an existing submission. Rewording the same task or reshaping the same behavior doesn't make it new.

Once you understand the agents' capabilities and our past mistakes, create a directory at the workspace root named `{repo-name}-{task-name}/` and put everything in it:

1. `{task-name}-plan.md`: every aspect, design choice and detail needed to implement it directly. Include files to change, layers touched, semantic forks, edge cases, test plan (30+ trap tests, each mapped to a description clause or something discoverable in the repo), expected golden effective LOC against the 250 floor, and the Dockerfile/test.sh approach. Mention every small detail, so a zero-context agent can't miss anything.
2. `{task-name}-description.md`: a draft description following [.agent/rules/description-writing.md](.agent/rules/description-writing.md) and the structure of the accepted descriptions (for example `freeze-store-integrity/freeze-store-integrity-description.md`). Per the official docs (P3-P6), write it the way a maintainer writes an issue: natural prose and full sentences, opening with the ask itself ("Add X to Y"), and the first line has to make sense without the title. No motivation preamble, no bulleted requirement lists, no headings and no code snippets doing the describing. It must be self-contained, clear, unambiguous and objectively verifiable. Describe behavior, not implementation: don't name internal classes, helpers, fields or file layout unless they're truly part of the contract. Run the `humanizer` skill on it. I'll submit this first to make sure the idea isn't plagiarized.
3. `{task-name}-repo-fit.md`: the repo-fit check following [my-review-workflow/guides/upstream-repo-fit.md](my-review-workflow/guides/upstream-repo-fit.md), recording the evidence for each Scope Gate point above (searches run, PRs/issues/discussions checked, README quotes).

It's very important that the task is repo-fit and doesn't break any rule or standard from the repo, its discussions, the official docs, or the `.agent` / `new-dot-agent` rules.

Go ahead and do amazing work.

# Step 3
Okay, great work. I confirmed on the platform that it isn't plagiarized, so we can start executing and get it to a submission-ready state.

Re-run `learn-before-task` for the build phase, then follow [.agent/workflows/implement-idea.md](.agent/workflows/implement-idea.md) (tests first, then description, then solution), [.agent/workflows/generate-patches.md](.agent/workflows/generate-patches.md) and [new-dot-agent/workflows/w3-build.md](new-dot-agent/workflows/w3-build.md) / [w4-verify.md](new-dot-agent/workflows/w4-verify.md). Use the rules in [.agent/rules/test-writing.md](.agent/rules/test-writing.md), [solution-writing.md](.agent/rules/solution-writing.md) and [false-positive-calibration.md](.agent/rules/false-positive-calibration.md), and the templates in [new-dot-agent/templates/](new-dot-agent/templates/).

The deliverables go in `{repo-name}-{task-name}/`, named like `freeze-store-integrity/`: `{task-name}-description.md`, `{task-name}-test.patch`, `{task-name}-solution.patch`, `Dockerfile-{task-name}`, `{task-name}-base-commit.txt` and `{task-name}-quick-setup.sh`, plus a `{task-name}-ledger.md` that you keep updated every round.

Each piece must meet the official requirements (`olympus-platform.md` sections 3-6):
- Tests (T1-T8):
  - 100% fail on base and 100% pass with the solution.
  - Deterministic: no timing, randomness, ordering or machine dependence.
  - Strong enough that inaccurate solutions can't pass, and covering every requirement and obvious edge case.
  - Nothing unstated or undiscoverable. No network, since the container runs with `--network none`.
  - No over-pinned output: don't assert exact messages or formatting unless the description or repo patterns fix them.
  - Failure diagnostics stay intact: the real failing test and its assertion output must show, with no catch-all or masking reporters.
- `test.sh` at the repo root, inside the test patch, supporting `./test.sh --output_path <xml> base|new` and writing JUnit XML:
  - `base` runs the real existing tests for the area you touch and must pass. You may exclude only tests that are already flaky, need network, or are already broken, and must say why. Never exclude a test because your solution breaks it.
  - `new` runs the new tests and must fail without the solution.
  - No fail-fast flags.
- Solution (S1-S4): meets every requirement, causes no regressions, follows existing code patterns, makes no unrelated changes, and has no AI artifacts (odd comments, unexplained defensive code, new patterns).
- Dockerfile:
  - `FROM public.ecr.aws/d3j8x8q7/olympus-base-<language>:latest` (`jvm` for Java), `WORKDIR /app`, `COPY . .`.
  - All dependencies installed at build time (it runs offline), and no test commands in any `RUN` step.
  - Ends with `CMD ["/bin/bash"]` and builds without either patch applied.
- Leak rule: treat the patches like a real PR. No files or directories named challenge/quest/olympus, and no "Shipd", "Olympus" or "Mars" anywhere in the patches or in `test.sh` comments.

The review docs show how reviewers grade submissions: [review-guides/](review-guides/) (`Reviewer-Instruction-Guide.md`, `check_*.md`, `Winnie-checklist.txt`, `count_loc.py`) and [my-review-workflow/](my-review-workflow/) (`WORKFLOW.md`, `rules/`, `lessons/LESSONS.md`). Self-review against them before calling anything ready, and aim for a 3 on description, tests and solution.

You also have reference tasks with dense histories full of mistakes and how we fixed them on the way to acceptance. Review them: what went wrong, how it was addressed, and what balance they ended up with. Learn from that and avoid those mistakes as early as possible, because we don't get a second chance. If we fail once, we get banned.

Take the time you need to get everything perfect and ready to submit. Personally, I'd pick one great accepted task (for example `sprint5/vineflower-duplicate-class-resolution/` or `sprint4/immutables-exhaustive-fold/`) and study it in detail. Look at how it covered every gap, how its solution avoided issues, how its description was written, how agents behaved against its artifacts (the `*-agents-runs/` trajectories), and how each round's changes moved the results (ledger, reviews, AI and FP evaluations). All of that and more is stored for you to learn from, so skipping it will end in a failing task and, again, a ban.

Before declaring it ready, do the reviewer's local check exactly as the official docs describe:
1. Clone the repo and check out the base commit, apply the test patch, and build the image.
2. Run the container with `--network none`. `base` must pass and `new` must fail.
3. Apply the solution, rebuild, and rerun both modes. Both must pass.
4. Rerun to confirm nothing is flaky.
5. Count effective solution LOC with `count_loc.py` against the 250 floor.

Then give me the platform plan in the official order, where each step unlocks the next and costs more, so nothing gets spent on a later step while an earlier one fails:
1. Prechecks.
2. Scope Gate.
3. Build Image.
4. Quality checks (Verify Tests, Verify Solution, Verify Flakiness, Test Quality, Task Quality, Solution Quality, Task Prompt Quality).
5. One quick-check rollout first, then a full batch.
6. FP check, once the run set is settled.
7. Auto Review, last.

Remind me that any edit stales every completed check and rollout. So batch the fixes, rerun once, and never start more rollouts while a batch is still in flight. If the repo keeps real source under a folder named `build`, `dist`, `target`, `node_modules`, `__pycache__` or `.venv`, tell me the path to list under Protected source folders before the FP check.

Log every new problem you solve along the way in `.agent/knowledge/problem-solution-log.md`.
