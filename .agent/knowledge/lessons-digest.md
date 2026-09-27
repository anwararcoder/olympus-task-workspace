# Lessons Digest (read at the start of every session)

The best-known solutions distilled from every previous task. The full evidence lives in
`.agent/knowledge/problem-solution-log.md` (search it); this digest is the short version that must
never be forgotten. When a lesson here conflicts with `.agent/rules/olympus-platform.md`, the platform
rule wins. Update this digest when a log entry is promoted (see `.agent/rules/problem-solution-log.md`).

## 0. Standing habits

1. Before any task, run the `learn-before-task` briefing: find related past tasks, grep the log, state
   which lessons apply, then act. After any verified fix, append it to the log.
2. Read every artifact in full before concluding: description, tests, solution, run XML, trajectory,
   reports. Summaries, test names, and verdict labels are leads, not evidence.
3. Diagnose before editing. Uniform failure is a task fault until proven otherwise; brute-force hints
   end in reverts.
4. One flagged instance is a class: sweep the whole mistake class across all artifacts in the same
   round, or pay one round per instance.
5. Verify, never assume: every claim about behaviour is backed by a run, a probe, or a file:line.
   Re-verify premises that let you skip work ("already covered", "transient", "fair floor").
6. Batch edits, then rerun once: every edit stales every completed check and rollout.

## 1. Idea and repo selection

- Classify the feature shape first. READ features (output computed from data a framework already
  resolved) hit the ceiling and are rejected. EDIT (global-property cascade) and STATE (persisted state
  with ownership and lifecycle) are eligible; STATE also needs a real algorithm for volume.
- A feature whose core is a published spec, a famous algorithm, or a named refactoring is ceiling-bound
  even if hard: a fair description telegraphs it. Graph resolution, cycle detection, DNF, dedup are
  transcribable, not difficulty.
- Difficulty must come from many independent, repo-specific decisions where the idiomatic
  implementation is wrong, not from one ridge and not from backend/format breadth.
- Measure, do not estimate: build the hardest fork in a worktree; LOC estimates run about 40%
  optimistic. Probe the base with 10-15 inputs to confirm a real fail-to-pass surface.
- Screen repo harness fitness first: offline-clean, deterministic across two runs, isolation-safe; run
  the suite twice and diff. Giant order-dependent suites are a red flag.
- Search upstream PRs in every state, issues, and Discussions (declined, removed on purpose) using both
  API names and internal architecture terms. Public core architecture = pivot.
- Run a quick check early; the agent batch is the only real difficulty measurement.

## 2. Description

- Opens with the ask, natural maintainer prose, no lists/headings/code-doing-the-describing, ASCII only,
  single-line paragraphs (no hard wrap), no em dashes, no URLs, no program words.
- Every tested behaviour must be inferable; every stated behaviour must be tested (both directions,
  re-run after every edit).
- Define every key term a test depends on ("origin", "stable order" -> "registration order").
- State what cannot be derived: exact public names/signatures, operand order, placeholder payloads,
  boundary/degenerate behaviour, mixed/empty cases, precedence between two setters, both states of a
  boolean setter, nil-vs-empty results, format tokens from external specs (inline them).
- Scope absolute words ("every", "never", "all") to exactly what tests assert; carve out real
  exceptions.
- When you change one sentence, reread its neighbours: an added type qualifier once turned an adjacent
  sentence into a 77% solvability blocker.
- A clause must be true at every stage it covers, including base code paths.
- Keep the load-bearing token, cut the framing (description-quality vs interface-alignment gates).
- Behaviourally simple, deeply hard: target "100% clear, brutally hard to execute"; over-clarity that
  enumerates the difficulty is as fatal as ambiguity.

## 3. Tests

- Assert PROPERTIES, not FORMS. Filter every cell and advisory with: "does a naive-but-correct
  implementation pass this by default?" If not, it pins an author choice. This one question ended a
  four-round fairness loop.
- Do not pin exact messages, exception subtypes, fragment order, counts in messages, generated ids,
  whitespace, separators, quote style, numeric spelling, or compiler wording unless stated. Pin only
  tokens the fixture itself supplies.
- But never go vacuous: a bare count, `Kind.ERROR`, non-null, or `contains(<generic string>)` is not
  coverage. Identity contracts need `isSameAs(sentinel)`, not a type check.
- Every test (every leaf) fails on base and passes on the solution; fold positive controls into a
  failing test; verify against a do-nothing stub with the exact signatures too.
- Tests reference only base-existing symbols (drive new behaviour through existing entry points,
  reflection, or raw input); never cast returns to a concrete type the prompt did not promise.
- Close whole classes: (contract x every entry point), (new element class x every existing
  mechanism), every member of an enumerated domain, both directions of symmetric axes, degenerate
  parameter values, mixed valid+invalid inputs, both call orders for precedence, parallel artifacts
  (javax/Jakarta, every backend, every compiler).
- Concurrency claims need truly simultaneous calls (barrier, bounded waits), not sequential loops.
- Fault injectors must observe every path they claim to intercept (move = source and target).
- Expected-failure helpers must not swallow their own assertion inside `catch (Throwable)`.
- Fixture data must make every plausible wrong algorithm produce a different result (asymmetric data,
  equal neighbours where a block is asserted, unguessable values).
- Mutation-prove every discriminator: prove the mutation applied, and it must fail for the intended
  reason only. Replay saved passers: each FP discriminator fails exactly its own class.
- Never rename or delete a test node id after the platform evaluated it; make it fair in place.
- Unguessable test file names with a random hex token; never the word "challenge".
- Match the repo's style and run its own lint/checkstyle gate (it also runs on generated sources).

## 4. Solution

- Solve at the root, repo-native, no slop, no dead code, no unexplained defensive code, no irrelevant
  edits. Effective LOC excludes blanks, comments, imports, wiring, tests.
- Wire every path: all dispatch paths, all entry points, all config surfaces (public option listing
  with type metadata and default).
- Opt-in when a change would alter established outputs; default path stays byte-identical.
- Decisions use post-transform surviving state; reach a fixpoint; canonical output is idempotent.
- Promise == delivery: scope the description to what the code does, or fix the code; never leave an
  over-claim.

## 5. Dockerfile and test.sh

- Official: correct `olympus-base-*` image, `WORKDIR /app`, deps at build time, no tests in `RUN`,
  `CMD ["/bin/bash"]`, builds without either patch.
- The platform builds from the untouched base and applies patches later: never reference files or build
  tasks the test patch creates. Reproduce this order in local/remote verification.
- Offline, non-root, login shell: verify with `--network none`, as a non-root user, under `bash -lc`
  (profiles reset PATH and GRADLE_USER_HOME). Grant write access to tool caches
  (`chmod -R a+rwX`), remove root-owned daemon/tmp state.
- Warm everything the repo's own full test task needs (toolchains, runtime classpaths); whole-repo
  test gates run independently of `test.sh`.
- Go: vendor at build time, no `go mod download`/`go install` fetches, test flags in `ENV GOFLAGS`.
- `test.sh`: writes one JUnit file at the exact `--output_path`, base = real regression tests of the
  touched area, no fail-fast, never masks failures, deterministic across repeated runs.

## 6. Handling checks, reviews, and runs

- Order: prechecks -> Scope Gate -> build -> Verifier Completeness Audit -> quality checks -> quick
  check -> batch -> FP check -> Auto Review. Run the audit before the batch.
- Every advisory, audit gap, and reviewer example is a hypothesis: probe it against the reference (on
  every compiler/runtime) and the base, then adopt, adapt, or refuse with written grounds. Never paste
  a proposed patch unverified; that produced TEST_MISMATCH verdicts.
- Route every reported defect three ways: candidate-only -> add a test (solution unchanged);
  reference-wrong -> fix code and add a two-sided test; both agree -> invalid, add nothing.
- Three reviewers converging on one area is a real gap. A single flaky contradicting verdict earns one
  rerun before any churn.
- Classify runs by exact artifacts: real XML parser for JUnit, read failure bodies and trajectories,
  cluster by first wrong architectural commitment, compute per-run failure SETS.
- Zero pass: subtract verifier-side causes first; the residual rate may be above the ceiling. Then pick
  one class: harness, one discoverability blocker, breadth, golden defect, rejected seam.
- Over-solve from a saturated mechanism is not fixable with more fair tests; cap tuning at about two
  rounds, then pivot.
- Keep the fair difficulty carrier untouched; closing a real FP class is worth losing the only passer.
- Verify a report targets this task and this revision before acting on it.

## 7. Where to look (topic -> source)

| Topic | Search |
| --- | --- |
| Past problem with this symptom | `grep -n -i "<symptom>" .agent/knowledge/problem-solution-log.md` |
| What reviewers flag | `grep -n -i "<topic>" my-review-workflow/lessons/LESSONS.md` |
| Idea/shape selection evidence | `new-dot-agent/lessons/INDEX.md` then the linked file |
| Same repo or language before | `ls sprint4 sprint5 01_*`; read that task's ledger, next-plan, reviews, and `git log` |
| Official requirements | `.agent/rules/olympus-platform.md` |
| Live numbers | `my-review-workflow/rules/platform-panel.md` |
| FP closure method | `.agent/rules/false-positive-calibration.md` |
